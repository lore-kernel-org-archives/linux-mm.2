Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE171090233
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0B016B04E0; Thu, 19 Mar 2026 10:30:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE2AD6B04E2; Thu, 19 Mar 2026 10:30:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFDED6B04E3; Thu, 19 Mar 2026 10:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5466B04E0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:30:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48B3D1405ED
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:30:04 +0000 (UTC)
X-FDA: 84563047128.10.29D9E27
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2F6AE8000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:30:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JvFkzUb9;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773930602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZ62zRGDMh84ev+ADivtxhXkIe87cWoaQL4WKudvzqg=;
	b=fm806dVyEpUSHR6uIrspw3NDxqbE6J4jeWJuagzaGIhs4a3ZT8OUJWeUeEChmI27XkODGw
	k/z+lj0fokPNat0Hg1iq7a++zzaKLXyLvWVR+cXXUR7IGcplEBZJqReMarblhdeQCoXMNI
	wJLREwyh9v7rOUr6ZOSlAIDZW2h7WUs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773930602; a=rsa-sha256;
	cv=none;
	b=NTNuH1qawGyclR5yANabaaSGE309cPtBRBq97xPVbENZelmaBlo3n+W46hMqmWW7diZXVG
	Rgg8N9Or+kMAlwLvHMwq8Dg93ceWGqZ3wTg0KV5xKNw0mUav+oWh/euzY3fgyJHPLck35U
	sMDTw4eOyq3sEU2vKW4EmewF//y/CUI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JvFkzUb9;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cfbbdbaf3cso88037685a.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1773930601; x=1774535401; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MZ62zRGDMh84ev+ADivtxhXkIe87cWoaQL4WKudvzqg=;
        b=JvFkzUb9NdGzz4dhvHpEMm+XeoUfNuV7GVyd8VGuZL7zTrnC88qttyhQ+CQRfDqmrt
         EpcTxH8BiPGTXNouEI1zmA1v7l5dv0KyyK/DGK/NK075Rxo+Q6BqsomlFTVUwW3EEi3+
         vA6JO1c43cv7VVaHgTb6kljVeniyA/o2yl9wfrEgZVtXX7wl8CpH9l7a3K7Z+1T1+3UK
         eoo9+m08yqceuwefnSP6XPqr2s7Tj5/3SVLl8Hc6SFKrTiuZJWkPVJXcAtcx5q/fuyKM
         g6QF7cq6ExrLxXVeEYvEdP7YZzA5d87qiEUP7zGrjptlj0lPeGjRunDpTgRm/85pI9nT
         DlKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773930601; x=1774535401;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MZ62zRGDMh84ev+ADivtxhXkIe87cWoaQL4WKudvzqg=;
        b=hMYuCeyreibZ6qlZLrheCRgFitliyVuh6mFVemNgoBF/24zGATlSOjpF8xJbuVMwsk
         UsNG7M7vyrFhzOXY1wAZy43fe1jcQcxxfwA5s9q4sN5bRGA/AwPywx8/+S3+wegAEsvq
         6lGjD4Uf01Hr7hKGEM1Npoi865jYhxmwDCfLgnGT1zhMeY+3F4qVDeKDBFxO6RIj90yc
         fDDyuQC2eTZerUSq7gIMQ7tBfqG/YgHZ0Z0iPFnck0Gziq3btBHrQZvmBJKIJ6msoQpn
         cMuI/uWhdPQq79as2KOUY09acW1u7AEXWqwKl/JsiC2Ayaa+uww2rDuXDuB0wEUTo0EB
         4ygg==
X-Forwarded-Encrypted: i=1; AJvYcCXHsJUgNUeHybDIMGZYxJWNwDSCVw1DJzA/uSY9AIrRfibTkDodHcA0I9vpSvoFxDt0UvDEhh9GzQ==@kvack.org
X-Gm-Message-State: AOJu0Ywd9ltxvgg1haBWcFBKUU/vm8SQSYr/t2DIa/q8bTw2pEzhbLdZ
	RAoTEhLslpqPzr7KRIWClbNx5apid6kgGsPJYZYT7Ra/VZE4qPcgBSoZ7bH5a0xW3siZBgIYX3v
	PE3W7
X-Gm-Gg: ATEYQzzxgImhionjFZaoTzCwrOvoeen6JPq6w9e4RAEf41sVY3cd3ytQhXCkoUYHUUh
	IdY1X0N2QXvXeF5IglWAIvktneBXfhdQj6VU1LZwayE7DhlDrfJBeYZ4gpKnOf/FVye4dSSRq+L
	jjPjYJxC2bJxO+TPGfI3x2tYflSlK1dOZyiFshno795hakmqPRjKvrU1+gy3zvuRIZR0OtYkljz
	4GvsY9byoMJUK2cKzJOvFLuRPRG6VIWVgPDRzHg9BkZFNM6QvBBmUcQtiwfAl31UuIZ5D4OxnHZ
	krA1RiVtGYggetwq+thRsh3A+0ROOstZIOHPJJ5wNdSIxk8Uirlh7ouPBEBGthWG34cJE+aALJh
	mWlL9cPe76OwvzfROc3hUrfOvjCIJfe1SRcHWKvmjB2rNbarva5WkXZZoKdUwh1gzU9cShlJ9zx
	uWxNyiW0N1VcgbCeliDxhsLRv59XlGS+QWrvZbOmz7H7pykrsmOxn/OktFXpnQF48E7xdQevf9Y
	RNFJmJ0Ug==
X-Received: by 2002:a05:620a:1a21:b0:8cd:b024:114d with SMTP id af79cd13be357-8cfb9ea6bb2mr485207585a.40.1773930600903;
        Thu, 19 Mar 2026 07:30:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc25f0340sm87627185a.1.2026.03.19.07.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 07:30:00 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:29:57 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <abwIZd7FNPj5YYXQ@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <c10400db-2259-4465-a07e-19d0691101a4@kernel.org>
 <aZxqP7J1kOClQUPQ@gourry-fedora-PF4VCD3F>
 <aZx7hsVNU0XOCCiG@gourry-fedora-PF4VCD3F>
 <049d056b-844b-4480-b90e-bf4c850fc70e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <049d056b-844b-4480-b90e-bf4c850fc70e@kernel.org>
X-Rspam-User: 
X-Stat-Signature: atyi3dp9m4ycrph9ubktcrpyjcxxjgof
X-Rspamd-Queue-Id: 2F6AE8000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773930602-424699
X-HE-Meta: U2FsdGVkX18zbv0pIuERIUeLPgZnz93BP662wxpgnDrpVDWO9WeTAQkMjQ2pAa7Yiopkmj1d24InihFsXbDvXLI0VPCJHSumHyCC2knvm9HD5A5ECi3bT9mjFgwCwfyFXWi2WHWeNAoMe0f6JL6wPv+Jymib2LDKSfMFqyGAXpyAPYUzL/hgu+JIAbkQVxGOpw5Qn4eVKHAoSQWQ54ROGSgJA+7pJYlmG9ISy5C5euwOtvM7c/4OPCnDif78VIISSFLF7hkFUce7SXBYRT5iJA4UoyKn5+rlZRaXYCpQi57mZ5CxliEPPGOM5LXE3pA2P80pw1rkggVYra63w3V4XyGkv0UtWvVnNcFjbE5JYUC9nETJz4iB7KVED41ri3LsZcZJM89uiCDRpygLgyAxjqsmVy/e9Ibvek6QSungYuXZRQmR9k0zTtp2ZMKCQN17N6MzSJsXUYnZv/WfdXqly4gYBg4ONasJbTN9fL3ewkaJOy6hCEA8SW3DtKwZN0mrb+o/iYzRUeu9P0O/Zk9CWdIOApIz1gOC+AYMtdIQlXVPJZu1aBpsBwkx9GPMdalRzn/tYvMSo9s4c0eOMJdCSmy/ECkilVjQnK8lbcujLADPCsweUihb7xHrhGEOcvInp2w6RBGlKwuALWGklrjSgxf0gvsLIei2lI1q4Lswx0yJH5OdfXF7n03/NjOMelm8Ydq1idEpbf88lB4ghtZLR0O7xIlqvwJqQEeeUsaBIu/kPwrEhhRYGxXJ8WuZAJvxg7mMJEPxEDZguVfk7GAN2FGwVW934+E/1HPvuwXdppK5cKK1V2uyBe7oi0g1/15Z5c+OT1QujJSEJZF5IsCQy/IW6O4rEFt5MfLA/SKFaszkZl/tbtSCL8+kFRGrJ2EmOfdjbOJ2SFG7UXl78tV1pFUjpgczenlXSzAmXS6DjINSBrFchPUKGgJ+3nb/GDqOPmfl/D2zqUtY+/01Ltg
 840HD3kE
 idn1FDjDJ2RB5Qo0IQ13/lw3RDRl2adL/Aqe+TI/DxMgtZputPOSs25v6hkun3+pi+nsz8hTY46MJvDckZ5im6KaSKmDjgKie29a77lbc45BQ2vIhSZZCteHadt9UYOfAmG8BZYJxXTsZ6Tb2V0sUp6fkBeEetE7Q4JqXuXtejXfSjhZtlImMq8qBG/BYO+RayFZ4UPzyq+G/ENDMBbSRhIfLCTD7B6TYyrgCXKtjlgmHg2sVHRl6c3pSJf+V5mGnN1yu0IPjxL16Gyqi5YmZm/0SEJJhVsT9u17PMD3hX5zkfTGMahIgFGH7QiL6p3X+k8SOMWfa30G519YCE8Wc43dQHac3yH7MWOx+i+xKZ/XNjss/rJpNWcYUnKeM0x0ppzevtiUtZmB4BhnOUSJF8Z/iiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 02:05:53PM +0100, David Hildenbrand (Arm) wrote:
> On 2/23/26 17:08, Gregory Price wrote:
> > On Mon, Feb 23, 2026 at 09:54:55AM -0500, Gregory Price wrote:
> >> On Mon, Feb 23, 2026 at 02:07:15PM +0100, David Hildenbrand (Arm) wrote:
> >>>
> >>> I'm concerned about adding more special-casing (similar to what we already
> >>> added for ZONE_DEVICE) all over the place.
> >>>
> >>> Like the whole folio_managed_() stuff in mprotect.c
> >>>
> >>> Having that said, sounds like a reasonable topic to discuss.
> >>>
> >>
> >> Another option would be to add the hook to vma_wants_writenotify()
> >> instead of the page table code - and mask MM_CP_TRY_CHANGE_WRITABLE.
> >>
> > 
> > scratch all this - existing hooks exist for exactly this purpose:
> > 
> > 	can_change_[pte|pmd]_writable()
> > 
> > Surprised I missed this.
> > 
> > I can clean this up to remove it from the page table walks.
> 
> Sorry for the late reply -- sounds like we can handle this cleaner.
> 
> But I am wondering: why is this even required?
> 
> Is it just for "Services that intercept write faults (e.g., for
> promotion tracking) need PTEs to stay read-only"
> 
> But that promotion tracking sounds like some orthogonal work to me. What
> am I missing that this is required in this patch set? (is it just for
> the special compressed RAM bits?)
> 

Yes, this was specific to the compressed ram bits - it allows for a
service to control where/when writes to the device can happen.  In this
case, I've limited writes to just the demotion step. (Although I have
since realized i need to not allow file-backed memory to be demoted).

There may be a better way to do this, but also it may very well be the
case that such a hook is just a bridge too far and isn't wanted. I think
this debate is warranted.

~Gregory

