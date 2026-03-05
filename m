Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E19F3094A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DDF66B0088; Thu,  5 Mar 2026 06:48:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF9D6B008C; Thu,  5 Mar 2026 06:48:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5696B0093; Thu,  5 Mar 2026 06:48:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 324B76B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:48:44 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 070EEC1F38
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:48:44 +0000 (UTC)
X-FDA: 84511837368.07.EE6E0F2
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4511680007
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:48:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Hq0rTFw2
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQkinhDuPvsI+Mc9zYJbcWtkNsBII7yHHxY2ORHu0zM=;
	b=acg6zQUpR92zWvGM1CkpXh5V0XDOhxpA1tYM25aqj5pY8rjcOoEZL8ss63Ky/KTykXm8o7
	HLekO7rNrXoKkqfpOpLVRutTChAKILWLetnRkR0pJaLI4Z6lX/0aaoXy60Oxp2boOBvUsX
	U27FbhmXG20UiEWUBOOzwHbc5h9vWmw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Hq0rTFw2;
	spf=none (imf30.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711322; a=rsa-sha256;
	cv=none;
	b=7W+mK5DiK7FbY5fqy56occnanxxFE2XAqUhX6XE2iuHwG+4KvJUxWZPWt5qShf1TheNGOl
	ARtzmCpVtGKunUDSUnmmDssn6vzfyizVMxNvpDWcgGxQY2NKgpmAefcaXdzSRDIeAnDci3
	IoDI8liNS1VHd+lAlPPvKN1xuKrvgu4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zQkinhDuPvsI+Mc9zYJbcWtkNsBII7yHHxY2ORHu0zM=; b=Hq0rTFw21/sh5uhsqYfzcxFS2d
	iluItr+FEpx0MlWdcYcTIWwlo+DZWTLIamUpmati9WRVLwJvUhczqblmDxJ1fBjCOBgZ3K/+CGsfv
	a1GDllI5Kl2ANRQ4puUiZgIActvll7SaQN1PxXT6YRz+8KyJXE9ko9N0q+4BEvIRFESF71bKZToT2
	EuXKajdspI1cNFsEK//TQgDM+V2nj7TSw8dgDuAXQ3RzeeOG3d5PbBJVWlIVzefFWx+ag9OqDrL60
	YsZkVo7KhoQwBSWuANsg/38M6R0ybAXU6rQ62E5xZM+GWQQSoJv1nws62XQ6sHpxuKFrfGD7BpAlm
	+ViILwOA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vy7Be-00GhhC-DY; Thu, 05 Mar 2026 11:48:14 +0000
Date: Thu, 5 Mar 2026 03:48:07 -0800
From: Breno Leitao <leitao@debian.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
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
Message-ID: <aalXA_nP2k2OrHhc@gmail.com>
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
 <20260304-thp_logs-v1-1-59038218a253@debian.org>
 <ec07d7f0-cad4-4d9b-8e40-d4ded8170340@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec07d7f0-cad4-4d9b-8e40-d4ded8170340@lucifer.local>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 4511680007
X-Rspamd-Server: rspam07
X-Stat-Signature: ts3hs9ywjcmtn1oaoj5x7p9o1bq3rh1k
X-Rspam-User: 
X-HE-Tag: 1772711322-816346
X-HE-Meta: U2FsdGVkX1/1aTcgV9K4fiFjS4nPhWbwzhQaiw52abaH/mwYXi2Zs+TCWZP+JsbXCsFjUO9wo1NAa5rek844Pm5mjg+gj1Y2jWaIVbHVjSmuIciYTDSmnF/Vxiez7cBAByEDYB7H1JG1a2xSclhQ4JCdAkrJbyVBD52V8sKnS1ekDcAinIghfXIDjQJuCzZfraUL/eoBcH+ryA2yDRUXDZgKl4RPmaTIcFJNQWHxJhLq7SgAj4jO1Opb9HOwrSstDNnOAHDxAG6gxdQjvauzfml+/p0DE9AbzzoGxW2sgP7v/Cuw94UhCCfJLfnAKY3KN2k3CynBh65XvWML058L+cE23tp7x4GMFkuFdA1CKU2YIoJlmZ4DeyoE/b3n94w5MIXi/YmIaZvlZqALKM7uFd8XD397YZhiWar/fyFig6W5ShUgtbfYsFiJN6l9cUMXgAk5HUkmGk2Cf75anG+CBToqHjtViNznrUzqEMys/CJYl3CY8/JTx5LjfcvDfz8RA9fZX4oePj7XQa4qE71VVzrkDc3EWx1kC3fDUSH24o8zRaT6uDvjTiyEGK2dUlZ+6nkX3NWZ92uFo3m1GOiQiqjxB0bO1b7C7KyqQjO56WMgNBo9oB+HgRhNJLnzQOmAbz6nYGWyuv3uwYrFKEQO4AtwIfyvUKlaqY6aPCdT0eLa48iM2dnzfob53cyi33pZIoja4pxdcZiR6586688WSYxe4F+P/ked2f9K8MKU86r6f/fl+74ms9xfdqQat8RSGyvAzYSGHgmBwZmu5edIMVJExg140a00smM2UUtPVZ+o5wE7VPIP7OO68bg9+o1pHjJ59BcENEXtfLVGQsp6acD/DGPtx1Q/nP+DzRJiMO1lYMslXCHMmrq/SHQm1hWibiHoc9zQOBYiNqXlPml6pio0VFE67dRjLrmuzaZ5CIuKqFP6anIjXK7ym2DNRfNElBjbgU+fIgJ4OigJ6sB
 IQObDq3t
 nalYn1ued+yMOblZ5ppPz+OEKMbbLOEzPwRWEo5DfEA2/ocEcA2qm2NR3rmd58rzEXktwWKAoHp8N5SKeM38NtnxfNsJg4fp0fDQo+EyPf91ZiTFLyfr64nQENMoRx1/f7wGM3obPTlqGfIZdrSSDgODKVSO89nu6M+BEChPFm3wF9z3Ao8xG05bwxqrWq0wpvJ/1+xYLUEXYHGr0ffYrZjdID6VVbf6nuT77
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 04:40:22PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 04, 2026 at 02:22:33AM -0800, Breno Leitao wrote:
> > Writing "never" (or any other value) multiple times to
> > /sys/kernel/mm/transparent_hugepage/hugepages-*/enabled calls
> > start_stop_khugepaged() each time, even when nothing actually changed.
> > This causes set_recommended_min_free_kbytes() to run unconditionally,
> > which is unnecessary and floods the printk buffer with "raising
> > min_free_kbytes" messages. Example:
> >
> >   # for i in $(seq 100); do
> >   #       echo never > /sys/kernel/mm/transparent_hugepage/enabled
> >   # done
> >
> >   # dmesg | grep "min_free_kbytes is not updated" | wc -l
> >   100
> >
> > Use test_and_set_bit()/test_and_clear_bit() instead of the plain
> > variants to detect whether any bit actually flipped, and skip the
> > start_stop_khugepaged() call entirely when the configuration is
> > unchanged.
> >
> > With this patch, redoing the same operation becomes a no-op.
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> General concept is sensible, but let's improve this code please.

Ack! Thanks for the suggestions.

> >  		spin_unlock(&huge_anon_orders_lock);
> >  	} else
> >  		ret = -EINVAL;
> >
> > -	if (ret > 0) {
> > +	if (ret > 0 && changed) {
> >  		int err;
> >
> >  		err = start_stop_khugepaged();
> 
> There's a caveat here as mentioned in reply to Kiryl - I'm concerned users
> might rely on the set recommended min kbytes even when things don't change.
> 
> Not sure how likely that is, but it's a user-visible change in how this behaves.

Is there any motivation that users are retouching
/sys/kernel/mm/transparent_hugepage just to trigger
set_recommended_min_free_kbytes() ? That seems weird, but, I will keep it in
the change.

> From cb2c4c8bf183ef0d10068cfd12c12d19cb17a241 Mon Sep 17 00:00:00 2001
> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> Date: Wed, 4 Mar 2026 16:37:20 +0000
> Subject: [PATCH] idea
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks for the idea. Let me hack on top of it, and propose a v2.

> ---
>  mm/huge_memory.c | 74 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 46 insertions(+), 28 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0df1f4a17430..97dabbeb9112 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -515,46 +515,64 @@ static ssize_t anon_enabled_show(struct kobject *kobj,
>  	return sysfs_emit(buf, "%s\n", output);
>  }
> 
> +enum huge_mode {
> +	HUGE_ALWAYS,
> +	HUGE_INHERIT,
> +	HUGE_MADVISE,
> +	HUGE_NUM_MODES,
> +	HUGE_NEVER,
> +};
> +
> +static bool change_anon_orders(int order, enum huge_mode mode)
> +{
> +	static unsigned long *orders[] = {
> +		&huge_anon_orders_always,
> +		&huge_anon_orders_inherit,
> +		&huge_anon_orders_madvise,
> +	};
> +	bool changed = false;
> +	int i;
> +
> +	spin_lock(&huge_anon_orders_lock);
> +	for (i = 0; i < HUGE_NUM_MODES; i++) {

> +		if (i == mode)
> +			changed |= !test_and_set_bit(order, orders[mode]);
> +		else
> +			changed |= test_and_clear_bit(order, orders[mode]);

I suppose we want s/mode/i in the test_and_{clear,set}_bit() here:

		if (i == mode)
			// set for mode
			changed |= !test_and_set_bit(order, orders[i]);
		else
			// clear for !mode
			changed |= test_and_clear_bit(order, orders[i]);

For two reasons:
	* you want to unset "i" when i != mode.
	* you would have an OOB when accessing orders[HUGE_NEVER == 4]


>  static ssize_t anon_enabled_store(struct kobject *kobj,
>  				 struct kobj_attribute *attr,
>  				 const char *buf, size_t count)
>  {
>  	int order = to_thpsize(kobj)->order;
>  	ssize_t ret = count;
> +	bool changed;
> +
> +	if (sysfs_streq(buf, "always"))
> +		changed = change_anon_orders(order, HUGE_ALWAYS);
> +	else if (sysfs_streq(buf, "inherit"))
> +		changed = change_anon_orders(order, HUGE_INHERIT);
> +	else if (sysfs_streq(buf, "madvise"))
> +		changed = change_anon_orders(order, HUGE_MADVISE);
> +	else if (sysfs_streq(buf, "never"))
> +		changed = change_anon_orders(order, HUGE_NEVER);
> +	else
> +		return -EINVAL;

I think we can simplify anon_enabled_store() even more, by leveraging sysfs_match_string().
Something like:

	static const char *const anon_mode_strings[] = {
		[HUGE_ALWAYS]   = "always",
		[HUGE_INHERIT]  = "inherit",
		[HUGE_MADVISE]  = "madvise",
		[HUGE_NEVER]    = "never",
		NULL,
	};

and then

	static ssize_t anon_enabled_store(struct kobject *kobj,
					struct kobj_attribute *attr,
					const char *buf, size_t count)
	{
		int order = to_thpsize(kobj)->order;
		int mode;

		mode = sysfs_match_string(enabled_mode_strings, buf);
		if (mode < 0)
			return mode;

		if (change_anon_orders(order, mode)) {
			int err = start_stop_khugepaged();

			if (err)
				return err;
		} else {
			/* Users expect this even if unchanged. TODO: Put in header... */
			//set_recommended_min_free_kbytes();
		}
		return count;
	}



Anyway, I like this approach, thanks!. Let me hack a v2 based on it.

--breno

