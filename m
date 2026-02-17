Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB2C9E6817A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 12:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1AC76B0005; Tue, 17 Feb 2026 07:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E946B0089; Tue, 17 Feb 2026 07:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A804E6B008A; Tue, 17 Feb 2026 07:37:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8ECD76B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 07:37:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D995655D59
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:37:22 +0000 (UTC)
X-FDA: 84453899124.19.57F3023
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf19.hostedemail.com (Postfix) with ESMTP id F1A531A000D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:37:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UACQIDpE;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771331841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=msDEC8P3Y7O3dfS3sdhcpXjWKe2JYJmxrwEcOrENtGw=;
	b=BBcSYZBngNtUpOAD5EUNOJmxrqV9lyznHhOrWdRQnUadJLQNkpWyzZeCtT2PvZgO/sSRx9
	v1MIT1pbMT52tJ2mlvaRFEnSszFWU2qZjLbKhRREOlY7yZd/bm1uBhExs1CgqZy08EkicO
	KJzN1N4kn0lB6vHUsD2FO1QPXQA5D8I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771331841; a=rsa-sha256;
	cv=none;
	b=aE55nTX6hmLwbvn/y8JXDiRIufzSM2SK89Q3MiaDCAHANfpqV61dRxVll0VF64kAnYj7wn
	Lel9sm26PFH+OhwgCIpKxASq59M9Qrc2VtsoGgTm8dzwcGY+YYlEWh8S91dptFU6a1kRTQ
	f2O9k6fVpCWwITzvE9jZFMVLfod4l78=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UACQIDpE;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-48372efa020so30030565e9.2
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 04:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771331839; x=1771936639; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=msDEC8P3Y7O3dfS3sdhcpXjWKe2JYJmxrwEcOrENtGw=;
        b=UACQIDpEDzfrE/CYO1bgl7KaOnsjCH3EnsuSHZHmdMz46Aau3YzcvUBWXdRF6otj4m
         F96GQDLRUYlcSjuMiV9SGwrD6WfUJOBXkno6QRvwgUKXaWRTdd5s9hxnerQNlpWqNjov
         NEBrjoE8GsNRuc+z4faj/26Dq9aGkUbwL+kOHMfRZ2FLvjvZJhSdDPzMtldtRiKlZLs4
         gPGAOAlQ8A02oNOrZrZ7471xxFseW7mNZXlY83GqXX5Yj1A+FC/8TRchQ7L8RiYk7cSD
         dVfzUm+C3qZxXxoNIurO39WNDzSIDShxo7uTz4ZcsntqPvEWse0A9nsrzA1bejon1TFp
         q9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771331839; x=1771936639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=msDEC8P3Y7O3dfS3sdhcpXjWKe2JYJmxrwEcOrENtGw=;
        b=Qut0zcpF7EtN7mVtSQUCAUAGmfKypkarH1LsghQuqcKGymvxJw0EU4sJcbFHAVY5Yt
         34dsBDYdmc2I6IUFyzBhU4bBYoYeqe2UYh5DlK6K4MXFzis2WUXek/n/yAuaY/U9s4y7
         5V7oOovvrzeLY/OnbauJxzfNAE0We/3W4/KPx/BDG1wllaWHhA+cABbXt91l4zMbNcgY
         0VmoMizBqZn5nO00rMkJGaCSdmlLepDNk9fzDI0VMOOi7ufIO9HY8tGrSRS86KEMfSCx
         ztwtgXskynK+64hxLaf2/OH+be7hSLnG5td8kAxR/JId/n28rIGOkWagz8fIVLBeRBNe
         HICA==
X-Gm-Message-State: AOJu0YzV1BfOp9Q3sZnxwsDOxaSXuP4xR6JVjIriyMHSVGGv344v5YtX
	GF0F21hQ+dR8S1yjMZnmsZrTp9+yVJofKMAxs1K3UChM7FUbBexrOvlRc9QN3RKfmcM=
X-Gm-Gg: AZuq6aJhSBBVxTGkce/xR5vVSsGXqgHbe/wKYnj/+KE+cOVXqtArPkiRArOyQ5lYEqt
	i3o9NrirJGdeyuO79Aa0UN0tmE1f+uka4Mqk1bk5wm54KWnxWZ1PxO5ZUzgKdzlEZfNbKw/NpCl
	jSmQwWiu+FoF0Zohojb6tuXnTNbPFNctnqWXAuzqcvTHTumXx466TtdOMx60jKmoiAQDZ4u4fMO
	jQPXL6RMOIANGpA9nhD3b16ugwxiJYnUb/3y0KdwKh980phV1Cfw4F/aRBDoLU4DUiWi+m3ZrOC
	ApIHg4zeC/vidUNgZpQDaM+90RRc/Ikg8amwugxnFcf332SpE1oKKmMNLYRlgsL2wRw1MfgPmql
	YJR9a5Otxy1SI96ORPSL4WWv4uyLio5/TEo2vgNyLXJKl7X/cLpZP29vr02fi/3u4ZD8Vcv24UG
	x6OhavyGnyiTqirlrZmiH4BzjK6CbAZR9Qj6Wa
X-Received: by 2002:a05:600c:6308:b0:47d:586e:2fea with SMTP id 5b1f17b1804b1-48379bc887fmr174214075e9.15.1771331839406;
        Tue, 17 Feb 2026 04:37:19 -0800 (PST)
Received: from localhost (109-81-87-131.rct.o2.cz. [109.81.87.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4836aa0847asm557596855e9.3.2026.02.17.04.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 04:37:19 -0800 (PST)
Date: Tue, 17 Feb 2026 13:37:17 +0100
From: Michal Hocko <mhocko@suse.com>
To: "JP Kobryn (Meta)" <inwardvessel@gmail.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
	david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
	weixugc@google.com, xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <aZRg_ZSDkbGWv7Vq@tiehlicka>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com>
 <aY2BcIHIARSwwQpo@tiehlicka>
 <eca7a8f9-173d-4cb0-93b3-df082b8d0c08@gmail.com>
 <aZLUm95Y-dKkdBWI@tiehlicka>
 <3fe7c5dd-b184-4421-a21c-bafce6aa7b09@gmail.com>
 <aZOHIQj3pJ-9dW_0@tiehlicka>
 <9ae80317-f005-474c-9da1-95462138f3c6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ae80317-f005-474c-9da1-95462138f3c6@gmail.com>
X-Rspamd-Queue-Id: F1A531A000D
X-Stat-Signature: n8kzr8hxzb4g17w9rxb6bufarq9aoti7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771331840-418404
X-HE-Meta: U2FsdGVkX19DiVeMEKyXTGYHpj7nLe/xw2y0W2YM1ubh6uqHZDIbx3LSYIBBFFM+C2xTXuP6//+YZO4WnRZcTYCLEhj7XUXNTP2l20WalKCshlGsep91Oz0q+NPZWOEy4LB1y2VuPIvMTsXKCa/DKgZqoJI0lPTofCbBe1ymyc2n7lkbO7uKzty5kCSLtAMrNWfLc+0lvlmwzY6sE4+hH/grjYKUuFNr0tN0eQIY2h5d0HVmhxLSV9RupY/k0Bpbkan7hudezInKg1xEhWeD/N/QNdP7rhRv79NMkQjlpRblsVrbmr3AKguPwNy1bNDXwp5M32YPSM4cHSRBHDg50+vGte3DTMSPanGQGXN5V3mxxzFJKjyYXtHFzi4xv03o8uC15VbnhmiKE5DXssr1lFHYMCFY7wJ7gF9/8Ts3bKemy9qdiOLgFxDQI4jKuQISICeB4h/yiW3hewGXOzEIEgJ9/pUTCzFHfLcdDV+bmqabbqNYaFUqYNwEiSVq2b/FhIMSlRbQ3CnSE1ou0tMpV0pv41OaZilr7PsYO+8caYmkrDnnToytNVgcGEwVuRDYonZwM1OmwudyVgp5GpFFOICqC3cFx6a53keJTICn6mgbrPa4QGpA7Dno5/Im/aHBhoPsoSwd6ZPP6Jihu3JaizaqhkH4YzmEKJ+o9Bal0j76ImauTZAE5s6uIoI9RBV9WSPo2Vq4YNagqd7Fp5K0NSJksF9CZcf17YEb9yzYo1qf5oXc/YKvlPiv0HPHl6x26lv0Jsbl/KACez/ysJS+Er84D1FRuT6Rrqts5ZEd26NfN5EduIuMLTfXBFPfbIRo+mlTgQHpioGSIMYeGhF0mXk6tQJdRlXrHaNhp13EIvmj05R4XiNrYVLwqhd25MIGrxvn212g0kTAA6kAj1IOhw+cLv874b4C+qCcaLsHtq2SNj2+K9LZvyQb6D4Eru9d11OBbaPLYkrtNs7VLwI
 hWFDALp7
 0B3aFCAMsu+G8rctJsHVlTYWX7j4bOcwYH0kNSYvaSI6rrEGQa6CrC4Zcg3P11GSH49glXTkg50fMD3X3c47tOLVCsy32QK7uMLgvYxd7qqGrY92G4j8fDZALJusFSSMxi5lR/ijHmUTmDv6EVmenXZ7pi4taEVSFRzWWC1m/9MuQVPuFT8z6oEB+JUyz45a/baE/CL7lgKqen8P7nwfbWVBoZzEg8y0mUXncR1eZ/Y7o56pyu0OpwPFPE8fJdZPRCX6XDt5h3qQZyDx7SCdzjBLDjBd/SmZLnWFvpw8Z7oZfCLWvzgUPv1Spxtap3IqaOAVbx81lSVNiym3zVvV/Z03Hj22YGlOUVoxTFy7U8EXH86KEpP0kCyIqrtM0Wllir14gcEKjXvKsPGB0m6C6o4y+actKVMFq3wMZO+UqKol1F3U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 23:48:42, JP Kobryn (Meta) wrote:
> On 2/16/26 1:07 PM, Michal Hocko wrote:
[...]
> > [*] btw. I believe you misaccount MPOL_LOCAL because you attribute the
> > target node even when the allocation is from a remote node from the
> > "local" POV.
> 
> It's a good point. The accounting as a result of fallback cases
> shouldn't detract from an investigation though. We're interested in the
> node(s) under pressure so the relatively few fallback allocations would
> land on nodes that are not under pressure and could be viewed as
> acceptable noise.

This is really confusing. You simply have no means to tell the
difference between the requested node and the real node used so you
cannot really say whether the memory pressure is because of fallbacks or
your mempolicy configurations. That means that you cannot tell the
difference between the source of the pressure and victim of that
pressure. 

I am not saying these scheme doesn't work in your particular setup but I
do not see this is long term maintainable thing. It is just too easy to
get misleading numbers. If we want/need to track mempolicy allocations
better than what existing numa_* counters offer then this needs to be
thought through I believe.

I do not think we should add these counters in this form. 
-- 
Michal Hocko
SUSE Labs

