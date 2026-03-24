Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 728F6F54AA0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8A8D6B0088; Tue, 24 Mar 2026 09:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62136B0089; Tue, 24 Mar 2026 09:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03536B008A; Tue, 24 Mar 2026 09:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B0B686B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:19:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 70E2D55D98
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:19:45 +0000 (UTC)
X-FDA: 84581013930.30.F3FE807
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 917F8100014
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:19:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ABD+g7yD;
	spf=pass (imf14.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774358383; a=rsa-sha256;
	cv=none;
	b=XaiVHuxqh74CWwzcnNdEELxDpbGreQeAG9Tdv9buwjOSpfvyvAJiBENfGIaBk3/1LqGfpr
	218o9e09I4FM0H4weP8AqcSs9GWu1z2qM/mxURyWRezkIfjki4heDWouBWLCyTiV7qOf/Z
	Hi72TgYGPyrB98+tpm9Jf1h/lv+jKkQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774358383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDW9QxylvtudolC4OrULLL0I8iMCwV1m1od/FFAOgBU=;
	b=fBeqR/6smG0LO4La0zEfz2SsleFBu909tlyUu+gEIsZpFrYSCsg4EMCelYQ2D3QghuEZ2F
	rm8hd+O6Vab+1PCmlMtJ/Yzlo+MvciPwcjZd0EK9zxOXWu+M/2xh3AJVtp6XGtuKQVHP4a
	iPzpf4/X8VvcG2bYScDxDrlnzn5AH4U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ABD+g7yD;
	spf=pass (imf14.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-486fda2a389so31814245e9.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774358382; x=1774963182; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDW9QxylvtudolC4OrULLL0I8iMCwV1m1od/FFAOgBU=;
        b=ABD+g7yD65o83SROgK9X6aQ4Oddy/ZND45GVhK4l/3548OImmuv+jWIBfCZUu1lbkL
         jqE4rAZzFkKWNFn5eV85Wsv8Huri96BsfLLNTcLATQEQPwkFOdH1iZOxcfF4kaIEvGCH
         tGr1QDL7+iaCmgNTRpm8UNgg47tUHG3eHgWWDHFFbB8tYGBO/iCF3z3Rga45i25joyVL
         adRjMbetJRRwmMcgH2nrOARsiGKyS12RcgEnfIB3tZ8qzLUar8PmZlWaIBmkHvItr9on
         kcUFxjNnmnovXEzQ4f/jGUh1WT7HK6mS567WWRIqcKBQbHnfWnIuLBcgf5HCynQu91vO
         CvcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774358382; x=1774963182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hDW9QxylvtudolC4OrULLL0I8iMCwV1m1od/FFAOgBU=;
        b=DYv45MWxMKwH0c47Sl4jwKDRRscpSEGSBQ0R1bWTouvHRamj9tcJ4g1got7+ODzSix
         EKWszCPwdPnJ0oU28hgKixAZgZnXAG6gBIAgFCfccti2NQDKEm3QoZPJcVHa0bfJq9Yv
         bK5uhabPK51/F/9h2pj0Ev3MnYEIDUdM/8NkEI7ej+1Calx12jm963VG2v3A3dmjtXv5
         kVsT32oZbC6KV3K07HhQUjQjcy7viffhRqPle60PJ31ZPVMeQOlDYvzMLKSrwVLgVCls
         SPCeKWM+S83gI92DBP9DV1/K6glrS8HwdOEffOQT6wOCIpKFmVUKm+RQzJKFVO797rpN
         t7wQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdKMrUg+cbzvFi39rrckaS/4T+JnimkMjYLZn2YZ/0n+2eXzkVuL5h1Fm90aAoyFhRzotkdItehg==@kvack.org
X-Gm-Message-State: AOJu0YwhK8hZBmtvYoKn/mJYIVx8RcZqA8d+kufj5R4fpxxu+3GRcgIi
	MvTTru7Bk54zzMnVN7gqIqqMmIwRXvry2apnwxFXjZ1PkQS/evpPP/VI
X-Gm-Gg: ATEYQzz3uVcXx46tLsXIGPslD/7/QyFjQgfSfe0QnEb4ZIQ2NMN1dy8NQff1mZdzw4Q
	KmVha9ndVp8ED01e2CDph8phk3rWwzO80l8JGKjkYITMoZLNC10uC3LvQJxFuZ1cnGbHOLf46zY
	oRTtU1J0G1+Bwj/rENMbiEGadBo1jVaHw8FN4s4fjODPA3nnZ9mjiLUEoP1NI4UTzI5LKnGWAFU
	sLbF7tcWQAlolXOllLpPYPPv3MjQWqVsFNvh0pwy0+L+DNroRcXj5hQoq/UhNum5fEDUC5DBvmq
	mgNaAERmqYveAUlgadCllfzjkGKjlqoankVVss++wE2h7oL1slHohvcwvCYSmVC1q1nNBPRndFx
	HxuOhGArYYtccUknpCOoKTRus8NAAKRaMfbeWnVoCht2e+6yPaMAu/gOIsd1dHh1ShjkpTlSO3C
	iMfEaRA5DMlG3FEMYXylw=
X-Received: by 2002:a05:600c:1c16:b0:485:39d4:2dd9 with SMTP id 5b1f17b1804b1-486ff04fb4cmr260524475e9.33.1774358381485;
        Tue, 24 Mar 2026 06:19:41 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-487116939b8sm77926095e9.3.2026.03.24.06.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 06:19:40 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: nphamcs@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	kasong@tencent.com,
	kernel-team@meta.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	riel@surriel.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	Kairui Song <ryncsn@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
Date: Tue, 24 Mar 2026 16:19:31 +0300
Message-ID: <20260324131931.4004123-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 917F8100014
X-Stat-Signature: q15qunekpt17p3mxcauw76jbwmjkoju3
X-HE-Tag: 1774358383-541534
X-HE-Meta: U2FsdGVkX1/o8IeYauBiw1hg2I0VmYNRidQ/vEyHZRnLKrwJ/NWpb0/c2E4XFEDDEsYP/+XOZ6rbYduENC9MvE4fU1Op4toxfiC7o9fj5CkgqR/J8zX5KBm4ZY7uc3WmUS/nRnAlWq/21d9YzMnV/tLZjax1VZYsOBO14y9qyKtnTeoVMLwE+/zpkREahS61aoCNo72LAJ5skJgZL4PhmBDuBM+urN1Kyv0EtzpSuu27L2e5l1kG09d2GgaH8F969XA142v9uh5/U+mH0mFe3LOf02ajsL3X4eGdqzb/DYtNQYcuFC6aGkZbVipZyfswoZOg1HgIwjBSpK9JPMdx9zHP0icKD1xP522XbPdO7WZyqeczpUuWOAl9Nrt1CSwmMMx40+jsAeIodQ2UaabfUGmi3/c82PimEzMgVdGi3U7SvVSvOHlAUIGIMdmDR3W34jr24zJvyLZf8PUi75p3HLZEiIz1bTis9MwcaIh5yTtqKLzIzYCyep0xiXQquel89Yc3z6wBz1WvPOOffBmY8CtvQplu5i6g9fLejAncyRYA6KuqobUIfbEjVxAvuSKICV2w+QWGJ16aTVxJTRLJpGhBZRyCWh7XFa3/IEL5MppAalAfegLp3ny55/+NrLdC1xYfYNM62OZxpW63mYg/d0duYe/9EC0aWdfP2FcD/9q/QpFFR2a/Zaj78UiGIu0UJtctFF35zBedt8OgK0d3cEi2O2/YqWuQHmDIlP2LNz3d4LfXjLms+7iMHJg6DNq/EhsMiLRABmV0Ersuk2aM7ovqS6/GxB68Ed1gbu7YCa36Fb9XyjpLJii1RMiPVkhEqV7yOaPxAtj8n8rNcYs/g/Y5ZnzZ9E3Tg9vy3soIXV8BAjEP7IHBqs5THexmEQXO4Um6YpRd18Jf+HiAqyoJCmfl5z44WtxQV0NBOrHfulAFVXE2IRlHaCvabJj1Z1OiY4GguKsZ1ugtt8vu3p4
 Bx9oB9Om
 rroqQ7gQLs/wKQa/xkSPJimgp3yXlBVFjx+dkMql5W3On4AFEPEI6jcDV8lpbG6lzCAX1rFPezWBFmNPn4wbu9vvmAr67OXM0bm5VYRoOt+TT4Dx2AvAoOQTaee9jznuMs+AceclZsyswTOKghLq+nGCa0e3ZegjdpxcqM12NQ1bhMrZfBmyGIYXGzeYZZIqzKS2D0AY4IbF/t9XBq22aUMAteSiFvkPr2lW07nRIIbNhPBVdybIngbEvHB13oSXR2LzLvMb23Ky99MYILrxrgPLNnBRMsQflnZo4lDrGKHKkuaHISonx0HgwlmD26zF60B4OpXmamPC7vQZa7ewDCZcVeGEyMJgKmhl0+1TOvFkZzbVNYRjNBXuJz8tC7j41Pj7jxP9uLbLJH3N5+Ku67QyNxwRm1p/CWLcGmKG8R+7vNTxMaZWEzcFNBnC/ZiQ+bCOtkYssYe37duPQiC2UpDxcqd6MYQyjNvuTOGIh4NND1e9d6ptXcbkOeyKtKCorfc6V2TfZwA+Ip4FBnnnLrLfazNYAf0A1qwHBj0piLxHNm6tlfHS0VksDtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nhat Pham <nphamcs@gmail.com>:
> We can even perform compressed writeback
> (i.e writing these pages without decompressing them) (see [12]).

> [12]: https://lore.kernel.org/linux-mm/ZeZSDLWwDed0CgT3@casper.infradead.org/

This is supported in zram. The support was added here:
https://lore.kernel.org/all/20251201094754.4149975-1-senozhatsky@chromium.org/ .
It is already in mainline.

-- 
Askar Safin

