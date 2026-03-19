Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FFF91090233
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6F7C6B04D0; Thu, 19 Mar 2026 10:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18FB6B04D2; Thu, 19 Mar 2026 10:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0896B04D3; Thu, 19 Mar 2026 10:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 983F86B04D0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:14:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43446160569
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:14:45 +0000 (UTC)
X-FDA: 84563008530.01.56E7339
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4EEE080009
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:14:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OipdbY86;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773929683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntFH0htT9ffFrh9knb0jn+m+GRQSXC/6K3X5v8dqre4=;
	b=4hNxNXoY7NCfKJMIq6PklKC3yepsTerJMQLjoCg8nr9S/AFtY/+iwZCh+42prMWWBHFJQm
	8+c+r8HO5JzTrrlvOteNXVY7M0ULqBQ4TrEYlCKj5fv3SI5hxxjsdHfF3a0pnOwplEH6wN
	WzCRDXBCjxV4fbsW6M28uzhPn5WYZMA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OipdbY86;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773929683; a=rsa-sha256;
	cv=none;
	b=0gHSKJkhjjgVNdMpD8UW5qQmB0Jwxi+9x6z5jn+Ev0UbbOT8JCYzMp4eloiYdRSrmxTVkq
	XRmPW2mwmHqo6CEFUGXuQVlm1S2Yyfbv/biIumCe0dk9W00JSDGjOXGg7pvIkOVUwetQJm
	2cmEZc7yiWshkYQs3euybNgxdOn9jwg=
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-67baf20e8c2so370898eaf.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773929682; x=1774534482; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ntFH0htT9ffFrh9knb0jn+m+GRQSXC/6K3X5v8dqre4=;
        b=OipdbY86c63ftcINI53R+KbMhzFkBvIiWXvxCnv7ME6jeQsApG8/UwJ51bAL+dGtj3
         geITrQEHxsk7E37+Nihov+xwikdyGfcR6fpEf7MfmoVpzDNNjTinCyYFUPeZgkuVaET7
         O0iQ73VLBg3GWEpxJ5N8GgYcNLomuDk0u/4MpF5sDb1/EjsVwfF2mXajC/SN2hC+oBAV
         ZWoNJel/ymN6SLSXyrJQqTm7iXc51Iedv3uKFAV0D+NnyEmfNZcrd07M/3pkRLfI2HPl
         2aT7pB0AgGGJmyZHRRy/qm7xH7kzB7PLIpt2bsGtoFIjavVeR2H8SZtzDytEAwTkhXEu
         zwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773929682; x=1774534482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ntFH0htT9ffFrh9knb0jn+m+GRQSXC/6K3X5v8dqre4=;
        b=k8RUHnRaJ/8OQ7a0hJd5drVGSyBLexEVBFQ3fTFTegHQoN3vjBxg1Uy5+X01/p7vYz
         TI0R3NYQeP3crbJu53jbLpA2HpmKPCgRKgLuN2v6EWr73cBLEExgWO9p3HuyKLjOTeDV
         6mRtcSxZcqvPyJGYOxnQa48rGyusqxnUdMed6cjIlCtXV2iVwoiO4N0Tp9xMcN/rqVJs
         VGo0qrxEV5PaawT5TrxrCwp5vO+40EILX2JyoQbDZLo/MPmejQV/lBb7K5JSobeIZcDu
         T81kqzlTWWw0Fu7Li/cggMhR9J2if38E2XY/nw8IagmwilATUsdKpPaT8lI2S+o+4IK7
         ajhg==
X-Forwarded-Encrypted: i=1; AJvYcCXQfl+JyulqhxPzETOHjEOELRaD7N1fRPPDHDtDSOSNu9bXFPCsLH/VAGYZqJ4MKrfQKYCQE0HNMw==@kvack.org
X-Gm-Message-State: AOJu0YySJmowdbgStxoQTNRkDNXMtXu3PTcXJBS5TH8O6Bn3MZEEUsbk
	A1mtJU+G+PHGPpUvYHFxWbLfDSPF+8Z6F/6X4rdtFNCGRcNQmobenfeL
X-Gm-Gg: ATEYQzxERUegq8lksDjDkJBSnbk2P1FpZor1sYtddEgahFCBJP+Q2dctz9EQyo8luwf
	YIIEdXvy7xlS59BkMcuDu9zt/kTHf9XhJI6dfIttG3yy4HOJrWC5j+Rvk+bhSNdo2Sc86fMneYB
	OKWXnc+Crd6a7kfr+qJkm9oFYP+84LQVOtSdqVnxsJH8qe/vr7Sdje7tkc9Mt3AWb07AM3h40aY
	B6V5K4NFV9crmJsgwg+MM3a3zVMpO5IfgaSLTww2Ve9lKArBl14eD4gsOoBSf/BLErsM6eVHHks
	mN2zVsBZUaZ1yvvTkiALp9U49dphEcjgEJUVpRm/+07jayNBADnCM6AjD6JMlinm8eAe1jEmtVx
	14zrMwH6UasGXWaz4i1/5tGh4YuBZtwicshC869hhy1i0f7cXyMBmMO3Kxyu+1+BoRF4m1/dtY8
	EFP3fSmbOs5TpVKafKJ5jx
X-Received: by 2002:a05:6820:1518:b0:67c:c4e:4ca with SMTP id 006d021491bc7-67c0dab23c8mr4161966eaf.29.1773929681867;
        Thu, 19 Mar 2026 07:14:41 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd689e3cdsm5313808fac.6.2026.03.19.07.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 07:14:41 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
Date: Thu, 19 Mar 2026 07:14:36 -0700
Message-ID: <20260319141439.218078-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260319-config_migration-v1-1-42270124966f@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4EEE080009
X-Stat-Signature: ay7yyej6k18yr9tpumarzjd1u6h34ya9
X-Rspam-User: 
X-HE-Tag: 1773929683-899895
X-HE-Meta: U2FsdGVkX1+AvES1kckokbzQzlxRes6iAHWz5HEuFXxY7QBDVrS/gSxakQs+ne+l88w3843GL0Rv2NKuF4mpZnsvVhpV1arfjZTuRwTFTENdN98fog0FXxjvAvirBjNvDqI0FqSYpO3Rbo4B8cuWrQGYmmJf3bzZRbfOafdCCQ8gTZXgHJaO3ZDF7htOHnGBZkclLE4Q15sCWJEbsCphy8dpdLvOOtB0Gi8a8pIk+20WSLuvSSw1Le325SupQjpZ21FrE1UjW+XPfnNH1PijJYDxLh4qacDMNniOumZNI265c45vXWDqmBP3q4DTdE78F0+5NrDCJMQ6NSgfo4jsHuxvfruP06NCVySzEiHP9y8nu0iQIhE5tydNfOaBQ8mMttTx8yF37zMxYOeyJ9DMUbwZgvOhibRCDUNeYhHbh9OH5aKOeVfi4fsNArKuTTgeq5IvjLjkLZ+LO8jKdR9jyJvhfonkhdvUljS/EthjreJj4rVi75McoodvUDuIv3NawRAG1FIHABHoFzHHJmgkUW9BWicKonf8cl5xIk/N4YV47eY5bvlncAwxiizgHs7pV1ZQ3xQBPWkHGzJnMq9T97LjzTssWE2/FB2qSlpW13QLbH9jNWFhlgchIkyu91zNbwtTX3o+tiw0FEoCplRrEiYtSSOhZLEkI15mEWVNvG/WGiGpZuuRQb4bC2xjqR0A4dFzqMPMDjc0QoA98ZoH7r8SQJPyKtMElUFNOi4G3+jASanPO2g7fGz1Sh0r8CjEAyha48oqK8UdLtASkRNHsDCmDjj1YWeAvCLMTLvFf5AHABQOJXRdJ37p0kmgq+OsG1Z2UeB7gBiEYLTQyJvcqFc9Ftfx9g4YrexjJWEPu+Lbv4XjADM4RRlwsq7dScKKNgxq1pKAz+Yn2JchM8RMerRNkIebhJalwFBQ2BzYRqSBiEC0IoO3aDO5MbpibodIff/lHh0LtJVZ8WvLkun
 zreYtqoq
 KXiauEVhckK6G+ija/ygecL2Lfvljp0XdUP7sUaWwEWb/bkntaWNjQwczC0HwBfhZbpEa/mladXLsF2tRrzgp6L7u9ylWpYZXmeRsvP2KroxxzrLsVjHrDmxdtFEX5PsV8V3Y1x7UZLP8INa9xqncMNv2P+Q+kYtuwvfh+cj7Dkovf0wq+Mff8E1PkyK376c+F4VVS6NLO5HtNFFGRtcvrkWiLy4lkrkvwBfW+7r/9ry3Q9pOXOYJe/InJe8wFFJgTmiR4WJpa5IdWBOYVLZwC4jyLcgz/HzHhj9IJDzz59ol78UyKym/Q49XCl4zoreqe2h/pkJRPSgwFYr6kV55/yoR9fnRxnwDgJ+0oxn96gCheM0LUz4qepU5HiCl1dLVb95bdH+MVSOy4h+HtcUTNv2wNkxkIahO8W2DO7MqA+yzXgZBkVahe/k0nwSE9epBbirOZADA3hsMXyHEiSlkoKqvQRli2z93Bu5fEH6/BAu8scnxhzYBgtozk2p6eeH3QsgxOrx+w0yXzv8p3zi63FsFkwptZd2czqqMV1CgkIxlxKO6Wzd/tgEAGr+ZfPW1Hy89
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 09:19:40 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> All architectures that select CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE also
> select CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG. So we can just remove
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE.
> 
> For CONFIG_MIGRATION, make it depend on CONFIG_MEMORY_HOTREMOVE instead,
> and make CONFIG_MEMORY_HOTREMOVE select CONFIG_MIGRATION (just like
> CONFIG_CMA and CONFIG_COMPACTION already do).
> 
> We'll clean up CONFIG_MIGRATION next.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Hello David,

Looks good to me : -) Thank you for the patch, I hope you have a great day!

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

