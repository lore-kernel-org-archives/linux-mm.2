Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47BF0C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 16:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0816B009D; Tue,  7 Jul 2026 12:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091D16B009E; Tue,  7 Jul 2026 12:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9AF96B009F; Tue,  7 Jul 2026 12:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C49A66B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:26:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E3DC404B7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:26:07 +0000 (UTC)
X-FDA: 84962507574.23.4A357EC
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6720F160006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:26:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DDgHGC1i;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783441565;
	b=BGdiKpmCUX27kBrSbHHrk/m2i4B75FOS84/95SnCCUpPfjb5X2Jlb4vkzbMBLVIYBOcT+x
	7Bei+aZMA8w+sl5tfZRSEH9k9ZHadw5fg01d5pVls8Fx+QkARVfed0UzDecsfY8lOPFW5s
	4gr1/YinBdAalKSo4eufhcZdX35EPR8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DDgHGC1i;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783441565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Abd7yWEQE6Vuyzvr8uj66ic6dsI9yDvEtRp+r0f0v0Y=;
	b=IgRfU+slrEZfD4AB3Ckr0xbny3SxTQ/tYfGyiNTU2meySlmUx4dJUno30QlA5ZImr7KT6Q
	uemcnP+zNp+9KPNU98kcgWKXSmbTRo+sbTO0cNclo8kKtYEkwxn4qTTssSbooRlCMDgh3w
	yJUzxgcY0rkvysrwkHnwJf8zu/hSDSo=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8e9c9d63815so18124486d6.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 09:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783441564; x=1784046364; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Abd7yWEQE6Vuyzvr8uj66ic6dsI9yDvEtRp+r0f0v0Y=;
        b=DDgHGC1iX9SASv296gySB4Z3RYUOGQWlY3WFAJs3hbfok3ialZsE77Gr2KToMe5gIo
         NsEmLzJYePBW4VhMAJ/g0iXQrd8zSLQAJmmcphzICO9iisPEMwDuvs5PU9hfv8x3JmnD
         lIEaNpaYBRxrtIgzjQcNG+PpbZSEBe3jTUTSF1anxOJzRIEqek+cbPTHuLKA1t362JZc
         ILiin8laEOPaJ2R6gB/uab6UsLzVOltyOfCT8XArdl2M8849/k+ZPrXBabftpR+F1KTS
         N1Gcu3RAWJ7pWdqcNl1uFb1RiD7uBL7nhI7bofn5FXYsQK+81HMfnYyx947G82fxvr/a
         0Avg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783441564; x=1784046364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Abd7yWEQE6Vuyzvr8uj66ic6dsI9yDvEtRp+r0f0v0Y=;
        b=SF392jG7EzOzCG3vIPxAS6LFwM+iotwsr/FHQxjz9D2uH4YDubDXfPajj1fX2Zth7T
         YKIEQG0BCCguW/xXbePS2V3NdKa0zihujJud2lCH+ARXsL2Q+tEcGYsBe0evlb8PtAY0
         On1KrLNutuSH7WJ1Nb+wr4SEwQGccMisyUl3ffoY9SP5Uo4opsOQLhnL8an8hbcuidGn
         RLPmlQ1N3USwxFokaoHWt3JLWPs3S3WXFaUZZtfLlPHGZL0sR7Kh7xh4cOZH14TG/4J0
         Wanlmp+Cc/Y6uooLCcBj0Acedc94mc+c73k0iz9VWb6h0OPGS685JBxhcBO/rnFYXuWx
         UtZQ==
X-Forwarded-Encrypted: i=1; AHgh+RpJ0dq248inhUsJ8JP3gBrwh3dxcD9G0o/lhpgGh3C6smLsSjal0ywPYDNEmjqHRyj8eYhYodMCxA==@kvack.org
X-Gm-Message-State: AOJu0YyteZMjl5r8swMg2vLUzJR/kzslyVZQBzW7a1mNXFvb7UFFnqI+
	HxFEBcTFEupXr+FPVxmSofOoVd7CnSvBxPyJN2cl1J87/4HeVFd4HEL1ZIafTNfKErg=
X-Gm-Gg: AfdE7cl/TwjiNo9UVFQe5syVYfP/4iaEV9mi+KujtXZfL9s78BoeNTIjMgsGGZEgW0e
	biREivGbcojBoDWkxd/AjP7aK5Zi7AftUkROLKtImZcq9JYvG391aPKI/9ZkA28ANH3ZSipeWwf
	vcl8sApeEuDSeJ2uJkBZsZavXAy9AoxjLo15ER0YR6W7oQbnv9BObjEEcnn8yMiV7OPn+ocrUeR
	IyJrapzohBWNMmuX7bpTsdcewY5wNmyXUYkkHwTr5RCU4BLd6rPw7sqWByqv//AaleTEdNTbynj
	eY8Bc53n2335rSEnCvliB5A6dbHNRj7UvT1yDj9xkQUaR069TYIDt99HfVrz7aCL1lPpIUBnuFD
	b4FP0egdW9ePP+3zvBk4C9+P9KIh/vkXtgSP2FNpG4CxjxM1rHMZJaFRr6TqDAH7M+LiNzEjonL
	g8k69oFBWECvdP4eyNiYfwYTB6VpMSG5tpNE9wRfuSMPfp0uz8G5bKaxGoyJiWWcBZMPDbGSrc0
	Xegj1s=
X-Received: by 2002:a05:6214:6011:b0:8fd:6de3:bbaa with SMTP id 6a1803df08f44-8fd6de3be6emr28372996d6.64.1783441563961;
        Tue, 07 Jul 2026 09:26:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f46f306123sm181382626d6.20.2026.07.07.09.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 09:26:03 -0700 (PDT)
Date: Tue, 7 Jul 2026 12:25:58 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 11/30] mm/vma: introduce and use vmg_pages(), vmg_[start,
 end]_pgoff()
Message-ID: <ak0olp9zA6ERCXtO@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <f7b4f8a611ab4d36eb3cf2e394610a3744a93895.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7b4f8a611ab4d36eb3cf2e394610a3744a93895.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6720F160006
X-Stat-Signature: npi1h6waq5j7c6e1makb5qefeuusaj3z
X-HE-Tag: 1783441565-231052
X-HE-Meta: U2FsdGVkX1/y6kkkNX49/XYR+OSG9fhye0iYJ5Uziesg6tCeUhzY79rnWPpPX/1vkorfwa34p3wm1hc4hOrTL+BFqZpKC3ozvDubcYFpyjYvG5VvsR8wBMC23NpYFueq/oHPJeopCUKOzP5d0BHDj/zW831Vm2MIYXeF/hu2rkR8/5dA6qc8Zp9ulOZoZMM12Hi+oCAHdu+BPlh3+JuA17v3DNPO/11ZqJvg7jJ6pKnzZxf4CZiZe0X12MWg8kqb9jWwlgYghJ3FQ64g9onbivu/nAwoxQMySKEkWygwoxJK5nj6R/PvAhdtxFBCR10vzzUzAfZzIfaIYuYlJ8NKWpP/sP3dwMQbeXWvihb2DvFIEbrg/dCIhgcTrakQlk9tUl+n2UKITTRR1BoIgzbDQXOClA7ixBbqrc7q9wluk0h9xwJS6H1NbJtQO3cGCSB4LVWvFWdR1qaIxsFiqcxlIjR0NMfG0pa7VvbhWVxx04NVVY5hiQ4Y/l4bcJtXL/n8MjW7q/js1WaVpFJuU1c3EaYueFRrpxbis57cQi3z60/faML6K52RY2jqMxgeYjD6Sytzv0NjZT+5/GG1x4gKwH+MLwih7tvsVqaH8dRUsbus0/4fQuWgrsovLSHsCtREL5loHWjGjXhSP8TDeUz8J1kRDz+6ecQW3IP7ydcJ89ljFooIkrZhCWRTpo79u/0BqMFVPN/ZjtcRAD+FdExMrf1riePTg9Nlggng14gWXH3V+9+NWT2QXfAnMwmzNiBRTstdo+K4oA9PZwmh0UJ8MwuTXa/EKThq+56N9MlHgDAHqJamhzfdmbDMgpF3k+Lfcx+CV/hCi69PgRYTAwnQh11BboIZsw7QFiF8puKotS+CY7Y3EDjl5buGlVxvcfKk3ZK+hq9eQMUNgD7RtzO1b0desAkwqN7njyBIsYEd4tWx7/mdF2nuyIx76W9fjcfkQbgAHDpFQWtx0RGKRri
 V7gRSc/d
 hk90TgdkF2E0oX9djVFlSrOTu5yMaqeXj14tiYnJ7Fypl2hqEqc6kaeQ7o9/pnqcYU7E0uq23OhgF/EmxymBrJS5WvS/r1d8bGvm6PYL0p2ixBBTP3/EDcfLz6qDuBviF8whl9P7fF4bnhNEfDmJ+eXib7sj9oKFoNp2hFihqFObZKibg+dJvq1b/rI3OZOePHwVfLeqLA0lECxaa4IX9uus81V2pG7tQJziQ1HAAhWMd+fdORhQFBYqBQTyAqsGUcr8JYkv4gjvNg1Gvm1hEJFKBCS3j0IQBKQLzX41I691Enchiym8u6xI3KbGOiBJ+lt7NaIxNbrNQ5PhZMTCc/2CN28BbNp7xLD0Ui04Dpz/87/depb/Nyg2vNai7thFVYKt9RNP7Wm9I73De8RVv3Q/UUW5Pw4Rwog4ZGAX6SahqRKAPa4v7y15RatfciiuHL4+WxYppd9lrf+Pq4XcT1wQ/c71BmG3hPvAJFRYP2rKKhHCKYyYDFvu6wTOY322iN8fp835q/DTTKOjcGGNo+CATQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:22PM +0100, Lorenzo Stoakes wrote:
> In the VMA logic we often need to determine the number of pages in the
> specified merge range, as well as the start and end page offsets of that
> range.
> 
> Introduce and use helpers for these purposes.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

