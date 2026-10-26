Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAFAB606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=B8KqZ4NQ
Received: by kanga.kvack.org (Postfix)
	id B8CAB6B05B7; Mon, 26 Oct 2026 11:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D446B05B8; Mon, 26 Oct 2026 11:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2B956B05B9; Mon, 26 Oct 2026 11:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1706B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:47:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0CA871C4066
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:47:53 +0000 (UTC)
X-FDA: 85365208026.01.9B7BC29
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 22CF6A0008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:47:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=B8KqZ4NQ;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793029671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35uD3sVJLZUeRHcPV8RyOPRby60btWRa2sdjDc5SOss=;
	b=QCM+FHV41oR+54eissMk3VbcODsXvS/PoZOSsIKxqB87/9WDeRAai6Gnr+vnWTx0M0Sioz
	aZeW4COd9j3KzVT/7hmxRvMD5OM9GYAMCiC/94P04nrFBXN0jHudotz84qN/5L5b5NY0CG
	jWnRxP/WK/uLm/eXZxZQFRL5XY70Rso=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=B8KqZ4NQ;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793029671;
	b=CyiLbMJz116xJcuJW4EkEexfgBPvl9AS12Ca+UXIQR34ujz6YFrfUHjbW1bKzYN2Bglngn
	TB9rzdZe7UeZXGvfUhhhDxrHd6POx25g9SKfzWYoKFVWAyzbCdP07eo867ZzCZxjRgO9Hj
	lUWs/Pf9yrYf/fH5B5kHy5XlOUQqWKg=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91c11468b5fso33926426d6.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793029670; x=1793634470; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=35uD3sVJLZUeRHcPV8RyOPRby60btWRa2sdjDc5SOss=;
        b=B8KqZ4NQ41SNECyaqpVRm4ECDEbMRcsUS1p+IudWuEmOdJbqdDHSZv0u1DdvfKAAXy
         H/3NCsDGv5rVmtbuMSnqCHSoOSRR9ZZTH5KfOxj3yIHCiacwxNCJQUudjxczuMsj6b8y
         9YKH5heeAQnwL+PzxsklxgWLtFivt8d8R378ysDHPzsw573U6RiTj0eugsNefc6e2ki4
         6SGSNhVKpoZZP8VP1Pm8RWP3zFLGsVtisui6DGRD9Jk9I/WGKh+lebZcSAUhp5W2KecI
         0f8shphyqFkqeucbI7CK6qae4/mjUlvEw5JQYCO5AoQwqMYDnxgTqjzs/fS0y3pi0yQq
         JNOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793029670; x=1793634470;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=35uD3sVJLZUeRHcPV8RyOPRby60btWRa2sdjDc5SOss=;
        b=rhUoJUY41t6zYMjOzHFybTdKN6qFMxeFv8GtXxtE/L/4KDohG24/PCBpOiIao2cIwa
         TlMo/SM1iJuyQEoL9oP18S+W6tMgxdMOU0ZVYzgtknP4iJP8zMTEYLZVD2+TuYiUN00L
         RPiPZg8XBCCB73eNAeGVEChUdf+S/ZvbrxcPiV9M93JiF4Ls8gETLf7Hk7NtjKLSR30q
         luoZVg8HCXCpXx177MhmP1KbD07E3eJN3CW15aRulm2wX3oWvPTl5DVDts81ZF4/aSqm
         WVw7OvQd/ooYVOmMNNoC3H0oxNOpG5yg2/ZjS6NO03AwXiJCkxS8zhZBxsAIv9EuyMdb
         SBfQ==
X-Gm-Message-State: AFq9FYLFDewGfl+leIClzkcekOCnxRF6eKtCUEGD1b0IJamixa/zzXmA
	9QjEZFpHa3GPVl7V15hEqXU4WiWrOfoM5WZAIGDziS4pm7/847G1aEJ1u31/Dpfw+HM=
X-Gm-Gg: AYBFou1eXvXOfQHhJR774/Vyqx5IXQ8GULeFGgeYxB2sKtudQphiFVKws8KiYqWut1g
	gYwEDb9VfPTpnI99cfImGpfmE+e55h0hIpJLZ74nJQ/Mup8F4N93KqIncECjBTFuli780ATgSE7
	yhMMqTGC/IPZRQM0OCkobBzz7d1K8vCIgnssphSFd+StYvFXWDAeMFxufL939yN+tXGTIfPXxrB
	vK7AE0h3Jm1jjL/HfPrwF2ngAg8bb2i4jyRpaeePH637N6v+SZgZdMO/vxbju4uZUJ2PdaYCJOf
	FEbTRFYvLOw5B4OgYh3n1CDl4rENykE9zdM2bUBdO6FPDQwPRy0gKkZ/cZCySJPQVM/h/MNuiA6
	mTDMkgClAG70qBg6jE5twFJyvYj5CRDMDCykCPc1bG/Wto5PMukLJw8xGk03/mAp6lRdGHZz4z+
	I4aXWXXyMZxYGeQZJtBsEqo+97l9XD0N0O9N2X1TbraZSmbLhMRPjSts3HHy6iZhcwNEP25WG6V
	wxhSVqhcJ9y4AjciUxSURAoH4aD5ZNkknMwX+WI1yLNfEZUG24pmToFFipOeLM+paLJktEp49OX
	FGp0heFxYld/VSJoyfH+7Gk04NzJsy/IraGX
X-Received: by 2002:a05:620a:4515:b0:93e:48fc:aa85 with SMTP id af79cd13be357-940ef9571aamr1034017685a.43.1793029670123;
        Mon, 26 Oct 2026 08:47:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f066731esm719609385a.9.2026.10.26.08.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:47:48 -0700 (PDT)
Date: Mon, 26 Oct 2026 11:47:46 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	ying.huang@linux.alibaba.com, honggyu.kim@sk.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy: recompute automatic interleave weights on
 memory hotplug
Message-ID: <at91WFlW96PH-a8A@gourry-fedora-PF4VCD3F>
References: <20261024170415.4121901-1-gourry@gourry.net>
 <e3a1ae72-9370-4c3c-8935-6a410a74377b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3a1ae72-9370-4c3c-8935-6a410a74377b@kernel.org>
X-Rspamd-Queue-Id: 22CF6A0008
X-Stat-Signature: twtux3p9s51h687aedyocqaixhmrtypq
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793029671-972903
X-HE-Meta: U2FsdGVkX1/dHzMuOJoCO+vBC5+7s/wOHIBPxeB6eJSQPdVTnUa5acyxZE2a+VYSWIFjohR2Mw8d7d4eTxi3vmHZq1ePXbpdDVENag68+ANAZnwfTsu0q4Ol05tcdbBk5IYoD8RcBGDcps8UHmrTDvLRS68EECOZMRWa3332bxRczH2uvoVNFVA+FQF+zkkFzPs2t0FAt4n9YsXgYvEmsV8M+xEY7KG6eDMnd4JxBnzllq3ZcX6f4+TeNgLj6n8IJCjRYrc/9dZL/FY/fbwkRZ1Js8yZqcJPD5TobrKOMeZmeSD1SNVmMxbMNapOOMyLztyQvepb65eki9wUJMrp6aBfZZd9xX4jtpvaoQup9Bzrvzx8AQ0qjhjlzD6FPFRqtu0zMBmhSxZ1A4owrj/liXZkFH/xQAOn1XRMFd2bqADjCPERF9FFlVhCVBHlXEm6VvEmu1NjV3iqFyExt+K21ms90z4sk1/bely8Tayzt346IPqEYfKQfQIoiW0HLecCmSIGIGwS4aRzixZrJmorUFT4EfmDLZq0jFclgxb4G1CxNMwcLs9td+vKYEZLznsdTmao8SPXwgF7coiFg5zgZP5ugrCeSqMJRhPRxm5GTNlU0G1tzn/55T0X7PHLaYKGGg2jwUAFCLERVUH3UaWxX12Swam1qeUKYZIaH1Pzk92sz03u06fp0OMEzAOaOR/tuFDX0XboWzYer87m/lLoG8g5d5lKXtTNBMtcg+rutM2K9Q0dq9jPT7L+2z0ASHNH2GFNUZwIJg2O2mQ5OsKSco1liTsz12dGISBw7IjEOZYyYEmWhUEvwA39DtTW3XECNQrpk7KRsOmsXsqjk7pVe/l+J0uRZuatApBjmgLRU6PTDrFN97HhabiY8UOzHbsSFxt+pQUnK4tojaz8M8tgSg8CzyIdqB+lJ74sicHrUqqUwZP+uQ5+CUUq5+7tqpjkZjd/Q7f97WOBQsmD5kI
 wR8RWSG8
 JhdUn7wDtFPrS9DIxWTEczifuQo/aZRoEVVrli5z6mApicZCoUMbRM/Ask8Xz/ooviCyRM1KSCFC0e1wtNZvtW4ENrvGcyx5IDQDW8JzmQtgrRe5s7JGcuOdpD08mlrdo2Bkg219m3q+XAOuz/9NBynFjryJ3HcZk+tb74Tm7GE2fJUZa5PHjrOb2EOsGwxHFMrIKTWApRpphRdMlmvXpzSdgIGUQHmEI1rAzqPF3yW+/59Jy0hP4SXMSV/KYNKWZqZFjnRc1cv9L7OM8NFP1gwCjsRGJb3384hB4Qh70MDc0Gb9nb+2PNWg9x35wDgGmxGBTOFQZT/5r5JVJZgRXzO6Du15kozyzG7+gE2fgcDhbMNx1f1KFxAtsXS4KfYR0F05PpAflF/SGfTMoyPBeOnQvXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 12:19:21PM +0100, David Hildenbrand (Arm) wrote:
> > +/* Recompute the weights from node_bw_table, unless they were set manually */
> > +static int wi_state_refresh(void)
> > +{
> > +	struct weighted_interleave_state *new_wi_state, *old_wi_state;
> > +	int i;
> > +
> > +	new_wi_state = kmalloc_flex(*new_wi_state, iw_table, nr_node_ids);
> > +	if (!new_wi_state)
> > +		return -ENOMEM;
> > +	new_wi_state->mode_auto = true;
> > +	for (i = 0; i < nr_node_ids; i++)
> > +		new_wi_state->iw_table[i] = 1;
> > +
> > +	mutex_lock(&wi_state_lock);
> > +	old_wi_state = rcu_dereference_protected(wi_state,
> > +					lockdep_is_held(&wi_state_lock));
> > +	/* NULL wi_state assumes auto=true */
> > +	if (!node_bw_table || (old_wi_state && !old_wi_state->mode_auto)) {
> 
> 
> I was confused about the node_bw_table check at first. Maybe
> 
> /*
>  * We can get hotplug events before any BW data was recorded.
>  * ...
>  */
> 

I went back and forth on whether to do the mutex in or outside this
function, but ultimately decided inside is just better structurally.

But yes, this comment seems warranted in this case.

> > +	/*
> > +	 * HMAT and CXL report a node's bandwidth only when it first gains
> > +	 * memory, so recompute the weights whenever N_MEMORY changes.
> > +	 */
> > +	wi_state_refresh();
> 
> If the function fails, should we at least pr_warn_once() ?
>

The only failure state is -ENOMEM, wasn't sure that was worth warning
on.  I actually debated whether to just make this a void function.

I don't have a strong feeling here, but happy to add a warn if you
prefer it.

~Gregory

