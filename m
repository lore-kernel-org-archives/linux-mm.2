Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1086CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2446B0096; Wed, 14 Oct 2026 05:41:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73586B009B; Wed, 14 Oct 2026 05:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62286B009F; Wed, 14 Oct 2026 05:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 849626B0096
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:41:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 209FB1C3C4E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:41:12 +0000 (UTC)
X-FDA: 85320738384.03.3059BD2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 12DB11C0006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:41:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="V92y/KLn";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970870;
	b=1O/71aJgLaK79viUPlA6fR/yuGLHX1/nesxc+Ik7d5c+dYSE727F3/1jq0Wyhln3lPQeAc
	ilvYnKiOTu9xBXQJV6C/xjJyHLFCn5EN7ScSn0IhQAsy3hLowN2GKbAYhR1SiarnUUFcmA
	QxMMLmPKrxc/F0JTlge6fLaJ7T2qph0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="V92y/KLn";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vz1ssuCpz9PpBX/PCoxi6kz30EjSUR7yJ+LJtWInUcA=;
	b=wzHvIj21Yi/l4JwysS0Plxo+4n/f6JOmBBJHlGamdfd+MBuF6/YjknpuIGzIzJhu3lvOWo
	jyuf8qajfWhSQnsBCONuBKgpjOgwEddHfijJ7R/xqODNQlWLxxi7ekrahxb+usAwC3dEyO
	fIk7pbUzZFxusEfYm90Em/C2qWfm1oA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88C081595;
	Wed, 14 Oct 2026 02:41:05 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AF293F7B4;
	Wed, 14 Oct 2026 02:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791970868; bh=IZ8rfk5wxLDPpZ+dPdITJwhlPRFAwVPL9jnNAGRlXks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V92y/KLn+QFs1dHeT5iQbY8pAfel4csa8XC0I/lkv0KHx1K2TT47ezllvr0uhly/0
	 015KPOYKeVKGO+UgOwsPrd/6b/fuoIlM6ngOfqHLEiWFVMzudL5X5ZAHOlmapDgTxZ
	 T0WIJMCN2wo4aeW9rp9i0FoWrlPYfah9XjcOeeQM=
Date: Wed, 14 Oct 2026 10:40:58 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Sohil Mehta <sohil.mehta@intel.com>
Subject: Re: [PATCH 00/21] mm: change behavior of pXdp_get()/pXd_page() in
 compile-time folded pgtable
Message-ID: <as9OKt7pg-vkJDz9@e129823.arm.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
 <as36bbrMVHOESsLd@e129823.arm.com>
 <ef5b6275-d15b-4192-a278-ab23235956a0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef5b6275-d15b-4192-a278-ab23235956a0@kernel.org>
X-Stat-Signature: 5t95zt9amoi4xaj6xx1xw5pet7n86uub
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 12DB11C0006
X-HE-Tag: 1791970869-968419
X-HE-Meta: U2FsdGVkX195XV8HQN49fwYGQmQsBd+EHMr+3im8ipvyPSfvuIh0x2/fXd7oNXLUPYX8CXoJFzZmZHISLJlKn0p13hh/+0txZ0SsbRWz44irRkkcWOdufYcPY6SJ/6g1R2v9sa2U+21RE+lh1kugCWFyxvBHzfpUPJSlWxpZg3O/E/vhawirD/HRkIKyEoGBwSpjzmXDHh6QzeGGdauBcEmTGbo6Y1kM19C1sbSudEYNLeMoz1CVWQFqrztmuMqJrjxDIuw+/M9n6E1IBeQDFPa2+dITQbSWwHXuZICMN6wuHvdMT+WNf1Sdv9G9uVnWVtEAv5YDttLd4QRBVC4YxFWRF8o1H4aNfikt/dinjlcWZMGfSFAUXBXekQPnRVpK2zIJlwp1MJONPVEYz6s5Ju+tM5wwrTKTFwVHH4h1RG+ipr+Gfap3j/+Rv792ATLjUQ4SxMBlBo17Dl2ZETL1KBYljxNghBbtSh3F77/ueiFc01qp/2syRV0fIUiibKY98BBrL8fFNs3429Lmy0n/HJeJGkDGLDLsfVohcPlUZ05KpkjcoZ9qvHW+O/mE+cnDQxrzJUzGAWio+JEJu80hgaF4L6EjSphuA1RGiARWRpUyL6OrSxgIYrBaTWqzbZQWno0dOS6tyqVTp7yBxYt40C06vlh6X/vuGqoNS7SN0EsBaYhqgVrH0WjNULPZh1yw3eKTXy3rLBN5jL9Seo1ojK00WM4WVu8ymGCbcSJq+ETa1L6GWJns8BVOf4hbT4WZq+mr0bFslwihFMoJ2ArxXt3dRknglbWg+9G3XeN5n/Fz9YUCRoHHjlNrOK1Ta2vaNPJQVFMgNIe6dMqc8qNmuBZ1rqgRwlLlm01ynJXWCHPnNsAsS/n+j/neSYfQQ8xgMfxkrNNoRflIapgavt1BIXk47UrTaqzWIstgfcXEKExdhWdk4KXMGCoobdThGW9EqP873SXDePCCZ6/xii4
 dvaAECCJ
 oJqch/YM0MtvDYKz9Db3LQ1BBmp5pb5FxLgEnxD1l2JOb6GcHaxI1rmGqaSMusqMcDH1rg0DXK0gYO1dnzn95xFOQf6SRfdzBGMdrdDCkdPhBQqarujSbeCFD1hAtGTk9A+X2KKfiE9iXHvPeTeDQ1VJr8h+jC0KzgT7w6ySK74qwUK5c/f9Ih0BmI7LyIb12KytM89xm5657rwft7AHw2wezf3xLRlo3ea7xcAHoZJm7z7BMzoYi0DgTRRsOjeew0ByK3sZcS/U3DJv4AHlTCZfbsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 10/13/26 11:31, Yeoreum Yun wrote:
> > Hi all,
> > 
> > May I ask there are any further comments on this series?
> 
> Let's resend after -rc1.
> 
> I think most arch changes are reasonably simple and uncontroversial.

Acked.

> 
> But I'd prefer if riscv maintainers could have a look at
> 
>   [PATCH 11/21] riscv: mm: use proper set_pXd() for generic compile-time folded
>   patable in vmalloc_fault()
> 
> You are working on some general vmalloc_fault() cleanups, but until we have them
> I would hope to get an ACK from riscv maintainers that this temporary solution
> is good to go in.

Hopefully. Thanks!

-- 
Sincerely,
Yeoreum Yun

