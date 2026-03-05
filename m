Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30BC5F30946
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 12:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51BA06B00AC; Thu,  5 Mar 2026 07:30:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F496B00AE; Thu,  5 Mar 2026 07:30:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1B56B00AF; Thu,  5 Mar 2026 07:30:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 283396B00AC
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:30:52 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C10D41A011A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:30:51 +0000 (UTC)
X-FDA: 84511943502.09.1307C5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5783D1C0004
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:30:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tmwqJizx;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772713850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgR2oNoL2KIF+7/QVFVoe0KjSJzKstUeaKxTsM4JfkU=;
	b=CnAYgLlhXY7lKI+wy7kdvNGPugeAD0KdiwEAwkrmL+B3r6PvE6K06mV/6v46gUmKmbHOhH
	RAdwn4G6Coly2ktwbvNl3R8JX24UU7eHEqKNTfi32ksQsVVbp5ZtdJKAFOEwJOkNVNrbPL
	zx0GxS4W+hQVhFhP1EKg7qQJZ6rtiUE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772713850; a=rsa-sha256;
	cv=none;
	b=bq4/5UEgTbRpsdAVSoxAlL3zF18KBxf3MHEg5CkT2nMzTNCGfDw3gyDWSyy/hv1ln19H6R
	DITUz5dAC35ya25rcigqwbQeAFYCSI2onDCtpW4OGQ7UGDlHDmWwfrU6hFI3dxVi2Iapnq
	elYRC4nTTgngDtArHh/TSMzjt5XHPxQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tmwqJizx;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D03861339;
	Thu,  5 Mar 2026 12:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D708DC116C6;
	Thu,  5 Mar 2026 12:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772713849;
	bh=ou6P22AaUMwtzK/lZK4+cuILdeYptAQivhv6iGAoAfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tmwqJizxPJNI+D0Sw/K02tGdZCnZDkDoG5eim6r8+3PRJSn0+EI2QzONUMRGd4IWX
	 gQOtFqxdl4Kz9hWMoR0DCcegkXIjnMJJOsl8E5CAcfTi7cLTOFnoqc183Z4rzi4Y4q
	 qB0wqhH4rD5Yc+YD9avyfRhhYGMV0fX4y4c1fso04d2AQ+naaGlJNBxUBSBiaOVSCD
	 Skv68MX2O7k3kLPhe1KiHJV/7x9PfEMoqTta/KBp1TBp5nR/JbaZCCxoMGpSFd68Af
	 PdS/M7ZD6xXioibwlbYdsb30XhzDxVeX6x8Nw1zi4GwHyjyQiI17gruAuKmC7yAqWn
	 tLEPI+JKnzMRQ==
Date: Thu, 5 Mar 2026 12:30:40 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm: thp: avoid calling start_stop_khugepaged() in
 anon_enabled_store()
Message-ID: <6eaeeace-7b0e-4465-8bb0-88cce2b13bb9@lucifer.local>
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
 <20260304-thp_logs-v1-1-59038218a253@debian.org>
 <ec07d7f0-cad4-4d9b-8e40-d4ded8170340@lucifer.local>
 <aalXA_nP2k2OrHhc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aalXA_nP2k2OrHhc@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 86bdapc7uijy8cm6y1y998hme1hgk9e7
X-Rspamd-Queue-Id: 5783D1C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1772713850-312995
X-HE-Meta: U2FsdGVkX1+FZxx9hbsegMSfHJqaAP+c1En9DjBEHzzXaTGWTwti+y8OU7l/OHB+KzpUZlf4tYtogG32a0xwye+ubmlPGObav7qhq6jBNhIzF6/FgPHKzWjvGd3qyRCUlWkxL9ANAlWE3L2t5ngZm/fju9dbnLw2eShcLTEXxgvXTvFGjm7puJrezPDuBG/KMvlJLvmnR4pwDRrZ1NBrbOlyHnfry7jmVUghsnUNb8B51n89n5k9LAu0NXLIjN4MAaRfhXwr4/A99jST3r3tIi6v21aq8+cX800MU0rUvOdeMiUe7CkYp/BGpNSsfXFrEQX/YJiKQGd9krJhz/V8AlqDYuvPydzQtEcFVSeGQVtDmRO1mSdU7KVHJWve53KMtW5WU/C4qDBGPedP4QrNJI8TOaTf9qU1DbbKx0JnYwl2iOXIK9A/2Sy1eVsUN/JBiS+pcUd2avNBpYqGTHEP2Gsmqjo6Zg586X/f6an6htPWzJgYN7+et0C2Ygqpz1T/iTYeJXLbawIsQhjJmiOAQoZIM80yM/xS2x4z6r6+3W2ro7rDt6AJi4GgAtVPckz6dbeVUdC6STI/MtcpkvDKH4wnCQmusWiUG6U0EZH8TMFRoE0qbJqpIpZgAzRO5RqTku2rWPoXUUxhJFRn+jDwM75ocWMCnS3WMjidPS2/oFGlbCMpQfD85W/udv1Cl9fuYboRP1Zvzxq+68HmCJvvKr0ToGlx5FNypzB0r8ETCnfkO/2pDDXpKAizbWi9qNswoPAgjsUyH6JPJmwVkdHXvrJQFUphLjx9rCV1Z2SChR842UlROTLNcOqfvkeQHRIeLi3JMnOjNoO2jFzyf3yFPrysCPhEhV0B78nsIcXlXu7NdqP3rlOco0cPNjbGf0OAFJRkmm/RlrYegxRLvInHKlXezRMGi1jgY/kDnQ2QIeumGgfpEbNTaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 03:48:07AM -0800, Breno Leitao wrote:
> On Wed, Mar 04, 2026 at 04:40:22PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 04, 2026 at 02:22:33AM -0800, Breno Leitao wrote:
> > > Writing "never" (or any other value) multiple times to
> > > /sys/kernel/mm/transparent_hugepage/hugepages-*/enabled calls
> > > start_stop_khugepaged() each time, even when nothing actually changed.
> > > This causes set_recommended_min_free_kbytes() to run unconditionally,
> > > which is unnecessary and floods the printk buffer with "raising
> > > min_free_kbytes" messages. Example:
> > >
> > >   # for i in $(seq 100); do
> > >   #       echo never > /sys/kernel/mm/transparent_hugepage/enabled
> > >   # done
> > >
> > >   # dmesg | grep "min_free_kbytes is not updated" | wc -l
> > >   100
> > >
> > > Use test_and_set_bit()/test_and_clear_bit() instead of the plain
> > > variants to detect whether any bit actually flipped, and skip the
> > > start_stop_khugepaged() call entirely when the configuration is
> > > unchanged.
> > >
> > > With this patch, redoing the same operation becomes a no-op.
> > >
> > > Signed-off-by: Breno Leitao <leitao@debian.org>
> >
> > General concept is sensible, but let's improve this code please.
>
> Ack! Thanks for the suggestions.

No problem, thanks for the patch! :)

>
> > >  		spin_unlock(&huge_anon_orders_lock);
> > >  	} else
> > >  		ret = -EINVAL;
> > >
> > > -	if (ret > 0) {
> > > +	if (ret > 0 && changed) {
> > >  		int err;
> > >
> > >  		err = start_stop_khugepaged();
> >
> > There's a caveat here as mentioned in reply to Kiryl - I'm concerned users
> > might rely on the set recommended min kbytes even when things don't change.
> >
> > Not sure how likely that is, but it's a user-visible change in how this behaves.
>
> Is there any motivation that users are retouching
> /sys/kernel/mm/transparent_hugepage just to trigger
> set_recommended_min_free_kbytes() ? That seems weird, but, I will keep it in
> the change.

I mean I can't really think of any, but I don't want to risk breaking (weird)
userspace.

>
> > From cb2c4c8bf183ef0d10068cfd12c12d19cb17a241 Mon Sep 17 00:00:00 2001
> > From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> > Date: Wed, 4 Mar 2026 16:37:20 +0000
> > Subject: [PATCH] idea
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Thanks for the idea. Let me hack on top of it, and propose a v2.

Thanks!

>
> > ---
> >  mm/huge_memory.c | 74 ++++++++++++++++++++++++++++++------------------
> >  1 file changed, 46 insertions(+), 28 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 0df1f4a17430..97dabbeb9112 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -515,46 +515,64 @@ static ssize_t anon_enabled_show(struct kobject *kobj,
> >  	return sysfs_emit(buf, "%s\n", output);
> >  }
> >
> > +enum huge_mode {
> > +	HUGE_ALWAYS,
> > +	HUGE_INHERIT,
> > +	HUGE_MADVISE,
> > +	HUGE_NUM_MODES,
> > +	HUGE_NEVER,
> > +};
> > +
> > +static bool change_anon_orders(int order, enum huge_mode mode)
> > +{
> > +	static unsigned long *orders[] = {
> > +		&huge_anon_orders_always,
> > +		&huge_anon_orders_inherit,
> > +		&huge_anon_orders_madvise,
> > +	};
> > +	bool changed = false;
> > +	int i;
> > +
> > +	spin_lock(&huge_anon_orders_lock);
> > +	for (i = 0; i < HUGE_NUM_MODES; i++) {
>
> > +		if (i == mode)
> > +			changed |= !test_and_set_bit(order, orders[mode]);
> > +		else
> > +			changed |= test_and_clear_bit(order, orders[mode]);
>
> I suppose we want s/mode/i in the test_and_{clear,set}_bit() here:
>
> 		if (i == mode)
> 			// set for mode
> 			changed |= !test_and_set_bit(order, orders[i]);
> 		else
> 			// clear for !mode
> 			changed |= test_and_clear_bit(order, orders[i]);
>
> For two reasons:
> 	* you want to unset "i" when i != mode.
> 	* you would have an OOB when accessing orders[HUGE_NEVER == 4]
>
>
> >  static ssize_t anon_enabled_store(struct kobject *kobj,
> >  				 struct kobj_attribute *attr,
> >  				 const char *buf, size_t count)
> >  {
> >  	int order = to_thpsize(kobj)->order;
> >  	ssize_t ret = count;
> > +	bool changed;
> > +
> > +	if (sysfs_streq(buf, "always"))
> > +		changed = change_anon_orders(order, HUGE_ALWAYS);
> > +	else if (sysfs_streq(buf, "inherit"))
> > +		changed = change_anon_orders(order, HUGE_INHERIT);
> > +	else if (sysfs_streq(buf, "madvise"))
> > +		changed = change_anon_orders(order, HUGE_MADVISE);
> > +	else if (sysfs_streq(buf, "never"))
> > +		changed = change_anon_orders(order, HUGE_NEVER);
> > +	else
> > +		return -EINVAL;
>
> I think we can simplify anon_enabled_store() even more, by leveraging sysfs_match_string().
> Something like:
>
> 	static const char *const anon_mode_strings[] = {
> 		[HUGE_ALWAYS]   = "always",
> 		[HUGE_INHERIT]  = "inherit",
> 		[HUGE_MADVISE]  = "madvise",
> 		[HUGE_NEVER]    = "never",
> 		NULL,
> 	};
>
> and then
>
> 	static ssize_t anon_enabled_store(struct kobject *kobj,
> 					struct kobj_attribute *attr,
> 					const char *buf, size_t count)
> 	{
> 		int order = to_thpsize(kobj)->order;
> 		int mode;
>
> 		mode = sysfs_match_string(enabled_mode_strings, buf);
> 		if (mode < 0)
> 			return mode;

Nice!

>
> 		if (change_anon_orders(order, mode)) {
> 			int err = start_stop_khugepaged();
>
> 			if (err)
> 				return err;
> 		} else {
> 			/* Users expect this even if unchanged. TODO: Put in header... */
> 			//set_recommended_min_free_kbytes();
> 		}
> 		return count;
> 	}
>
>
>
> Anyway, I like this approach, thanks!. Let me hack a v2 based on it.

Great, thanks!

Note that my code seemed to introduce a splat, so it's buggy, make sure to check
it carefully (that 'untested' proviso was apposite, it turns out! :)

>
> --breno

Cheers, Lorenzo

