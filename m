Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFFCF1077609
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B716B02F1; Wed, 18 Mar 2026 15:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC316B02F2; Wed, 18 Mar 2026 15:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1E86B02F3; Wed, 18 Mar 2026 15:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79F466B02F1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:34:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 361621C0DD
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:34:37 +0000 (UTC)
X-FDA: 84560185794.27.AD6B24E
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4C09A40013
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:34:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MRdNfqer;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773862475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y49aj7IZjy3x/shxvuF3SJ1bFf/kbOhQ+X5g3vtgMYg=;
	b=F2dTPVQcFGcdLVKXDbibziTSVd51JCtWQSKkvI5EXo+VBCBx/fhJr6HJdVzc1Pm9GpSkdD
	1RzXnvvOlplAnTJiKyHrS81IQWUQrQi859jXy5nyRvNwBW8ZauNZbKlWxqr97ngrFUF4bn
	1cE23BwQ7UQ2PL+1ORwQgjhotp+jQLo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773862475; a=rsa-sha256;
	cv=none;
	b=hlS0lwg+gy+NMlmX0IqbU3lViljnky530k636kdHE1mspPM+7SdN3nQKHxPmctTLOnouV2
	FeBYcP/QxMeiSisrrHVyHlQfw1+9SdJMQMl4QQhutrK8zJBKdE1hk2v3gaNDF8gWzQg4UN
	0EW+Xhgmb/QaMDsf8sHswhyXiUkMj9c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MRdNfqer;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 18 Mar 2026 12:34:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773862472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y49aj7IZjy3x/shxvuF3SJ1bFf/kbOhQ+X5g3vtgMYg=;
	b=MRdNfqerzaUUlyh1c7K60Zq8CwKbm6z/BS9uwdFGo+9qce721SHiqLDHMRG5J6cb625vuR
	KwTjoUeY7SPaKn1detVgnaS/YL0EFomz72Pi2sG9h4CRAbLCGi9Gj3THprZQp2RLKuc8sB
	OrZx1qH523VpgiKnLnYeR1NtHMwmdmU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] mm: list_lru: lock_list_lru_of_memcg() cannot
 return NULL if !skip_empty
Message-ID: <abr9sDFvueL6fGPv@linux.dev>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-2-hannes@cmpxchg.org>
 <abrnEU-wHNkqGK2k@linux.dev>
 <abr8Kf38paSBh9H_@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abr8Kf38paSBh9H_@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: cnf9q9498kbt4856w9bqq7pcmt56bonz
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C09A40013
X-Rspamd-Server: rspam12
X-HE-Tag: 1773862475-199863
X-HE-Meta: U2FsdGVkX196hO+PXjKiZ7UA1KwxoVNrpyFqMce952tSM/LdtCye/9ZfFXkcFLsze76PwD/qFHomzDem4mJByK4zjK0DKk2ayB9OtaUQfsTlNFt7SVR85vQIaSg6obaWz9r0yBvq1Y21sEGuAkJsL8DVPflDsZewgP5vUt3MxUpVA7v6j9XE2h0Il8zE9Qkpcrz+KBameM7BXIRg7PSYe4zln8lnxiXGS3KFQB21/SodMGmuibFpnKupdc4vSFJbT2yeKZtOeirttMrTc24kDUlQI3Msr2SAA8a6xCK14UyUIDizGhTSqim4k08kTOtywC5YRKnTf6OC4Nl9NA6UqqAnUb8Xn1BvKJeyVyfYaFlsi32IDujgx7RQpkreACxXjDUKvTEF1nyvwv4KO4y7kTS2RTwHFy+bDXnhmddMkUN9trFFzHw95AA3WZQFKuL4/eCDe40ShI5OoU8WDCVn5uoswd9USuzKYjwAmbI88EMaZGWdtWyfBm4Ts7VmmY6mbDzwSmNFopwmTpfXSzhRw2YSX1PFDGCjLBI+hnHMMbdjBpOBNMNC6CXRyB5T9ny7069MHu/qyJo5VEuWChQFFnb6AkAM+PFVhURQ8wbhYGqK5qvXm8mv+/oUxrGcjd43OCyAMz4xFTVhYBfyOdr4mxfNfkg78fLh1PV2dir471SH0Il3d4w32+2r29BacFsf4coydyJzCYBzmrQDU3Xa9S5Aq6F5Kd8A4lqqb1PWSvu/nuBqhDoBCB3hAjlTvHqjP3pAjEEhQvZNiVPPr63fVV1YFUkBtmjxsOra+O4/t/+9r9C9tblZ5S8SlyQx7//No87/qtO1/yRDdHUf2RJ2+KfKupOShd3CvPGdYDOII0KRNTSGIKlMHnJVUFJejEEUnuLNNT82dRqhlU/WUNs1IJsKatvAGpLhbhc92fMTMrT8RbgKm/uYWp9yhYXcg4nBnlN+fGnwUwqMU6YUraT
 VEdhSL6b
 Wf5nNg/0t0W8/HtbKe2u8nzzGyHTgy/7IBzVpL0jho3hO6CjtL7P8yxrK3NEVFqbmBGgY475zpMcMy/a59mWpRTDNmTMc1zxhj+7sZVyGePjx0ab+XE8NE5Z27enqn0AijlbagXry4iGSosB5xr6PFGdERw7IoIFHza5oOuCFL1IDAzPYadd5NbLAoTZrfNfoWrWSOB6DN/Ga9tDnEJs44w/XSn7DFH1zrtrzFf/yA6HFdHZVTnOxlzQHNG4H3nNqeLCw/b8LTpLC9ycpGFXcwuN7Jt0zYXqmyVKTNjy0YQPIVFA22XPPBb4DWLtgiyAAc7vk4Ez/EJqMNTtiMyUq7TJ0xMJLrzBeqaKMQfUBgW6xwL4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:25:29PM -0400, Johannes Weiner wrote:
> On Wed, Mar 18, 2026 at 10:56:55AM -0700, Shakeel Butt wrote:
> > On Thu, Mar 12, 2026 at 04:51:49PM -0400, Johannes Weiner wrote:
> > > skip_empty is only for the shrinker to abort and skip a list that's
> > > empty or whose cgroup is being deleted.
> > > 
> > > For list additions and deletions, the cgroup hierarchy is walked
> > > upwards until a valid list_lru head is found, or it will fall back to
> > > the node list. Acquiring the lock won't fail. Remove the NULL checks
> > > in those callers.
> > > 
> > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > ---
> > 
> > What do you think about squashing the following into this patch?
> > 
> > From bd56ea4505f792e00079b1a8dd98cb6f7a5e7215 Mon Sep 17 00:00:00 2001
> > From: Shakeel Butt <shakeel.butt@linux.dev>
> > Date: Wed, 18 Mar 2026 10:43:53 -0700
> > Subject: [PATCH] list_lru: cleanup
> > 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Thanks for taking a look!
> 
> There is some overlap and conflict between your delta and what later
> patches in the series do.
> 
> AFAICS, the main thing left over would be: to have
> __lock_list_lru_of_memcg() for the reclaimer (which does not walk the
> parents during a cgroup deletion race) and lock_list_lru_of_memcg()
> which does. Thereby eliminating the @skip_empty bool.

Yeah, I saw your discussion with David and thought on how can we further reduce
the params.

> The downside
> would be to have another level in the lock function stack which is
> duplicated for CONFIG_MEMCG and !CONFIG_MEMCG, and the !CONFIG_MEMCG
> versions are identical.
> 
> I'm not sure that's worth it?

I am fine with whatever route you take. I know you have next version ready to
send, I will review the remaining patches for the next version (though I have
taken a look on the current series but will add my tags for the next one :P).

