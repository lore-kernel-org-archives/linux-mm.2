Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67563C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 00:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C2C6B00B4; Mon, 29 Jun 2026 20:12:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42D586B00B5; Mon, 29 Jun 2026 20:12:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F55A6B00B6; Mon, 29 Jun 2026 20:12:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F29C76B00B4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:12:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62F2D16786E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:12:12 +0000 (UTC)
X-FDA: 84934651704.07.C60757A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B5E0B40002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:12:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqp6ovtc;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782778330;
	b=XOSZiLOrmZIwFOT9+w298Kf4KnplGPSLCO+wLsRcAzBbr1oeZDvKNEfUXIFcZqXmzteDRM
	VBC5eahcT4FSzSMA+YkZzkGw0/z9AiBXYW62/pcS51EBkIdWHBr4TB9xhIChEVIBYFRtEd
	zfU65nuZO2UGruUn2pUqA3rzt8Z8I4w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782778330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a64RIiIV5g7zUCoZKk0RU0OaXgbT9t9LC605MaLKQjE=;
	b=74qcUd2AzFrCTkp+G9uG5TdnNMlU3ufsK6tVBbEx5LWbBrSt3EkXknccDvwcGOgKdv8rPY
	pUoEKaaXpjgPCktNcKqpFHzF+5n5l1c42L0frggOOB8FkK+/lmCaWUv/bmL2Y9EKnCKBBA
	8ZUV9mva7mfWg+BIMOxaD8Vso50Jwjc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqp6ovtc;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE866416C4;
	Tue, 30 Jun 2026 00:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE721F000E9;
	Tue, 30 Jun 2026 00:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782778329;
	bh=a64RIiIV5g7zUCoZKk0RU0OaXgbT9t9LC605MaLKQjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqp6ovtcMAfA2KsMjewBOCot7QpQU+TrwAfxpD4Z2sngOCSXsbtBGzMV9G2ihxMHM
	 EzM3eseuwxS3lItVuSkojLNHBqFP3vNnQ7f74LgzTWcF74FCHDNVqjJE/2L0pngBX5
	 gHusJa7fgFXjvZ2gr7P7DuPcmzUz2z1vHLvTd/ED0uDeglpI2akCIFXOgpQzRgOQWi
	 Q0iY57hEsRtpqz+c/SFniyhcocpVuLTtp2G6H7RrLeqeMiJqBbULCYWQ0A5BmBRBcN
	 23J0bzYvOxk4uOScV4cjUhEepr5EM2xby41+WS7MQIwK59rUYp8rz4o4bmldVkGa/E
	 EeHN1s4Rihftg==
From: SJ Park <sj@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
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
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
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
	Steven Rostedt <rostedt@goodmis.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 16/30] mm/vma: use vma_start_pgoff(), linear_page_index() in mm code
Date: Mon, 29 Jun 2026 17:11:59 -0700
Message-ID: <20260630001159.140651-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <33d79008948391d30bab38db5ae31072ce12f0a1.1782735110.git.ljs@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B5E0B40002
X-Stat-Signature: uckdg8cpy9rhszh3gkinzeu14zz18488
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782778330-476622
X-HE-Meta: U2FsdGVkX18VYyGFORrmuWN+bIR4Zt3WaU1B0vE80gBrP+j+j5+WC6IAw0VTKxilTWCweRWAqP5Hf8h/2UyXHt3WUVttOuhedjHolNNHI/6w/Y/RK/58BbBaC4Ndo4ENhAPT9tjCU7Ckwn4m510Hi+Shhp3SdW9J7dkH4ba1PsFssseO5ohEPR4CpeygvFasqeAfDIdF1b+/bEz/UmD7ShJuHlbBbcpybs8yWFLBTeQ0eZjExzYU2ix0qNyDv+AkV1G0tB6ftOswZwWp9RRWUGO+XWl5TnUeZ4yczWJkzU11ZzOrs8B1UsGMF9on1JFxeT9+vr2v8tm1UVE9gUmevfuR2ZLROhF/rBrNUD8dOw1XYc4ZgPf8LyPCl5s/xLRI9e3VWIfko6pN9+362GrJb8mcBMMD10cviEwcxexatQLZx8a1Gxu4NuaIZV6K1vtuExDOIjCZPhzlAgBgD+EeMA9y7w3XZgsU3LHFnQWNufMHUhbzD+CHuk9EehrTjKgwSiPsLazv5b3aDGD4rLjSTNS2LgXMkp/YhbBh78k+JKF2bfxfGeBCv7Jown7NJBCdxusN/1RGTLMNONZ4B0/W0vgD9Hr7v4/0vtnisi8LnNWTl7nrZUNYe89WZQaRzSGK82zNQNJdvntjrQVnAzE6qUZ1JsIIS5LdW/w2cCKPpank9AZQ9II9ixCisOAV2TbNUSQLhpyDleUtm5e586AlTZT0jTYC42hsIsG28yso3Zfs8yxV+WzsrW/lEc/xw6ubDmFdpeFN2jNE0Hm1vUjxuU1lrNTbYgKGc1JW1+vQZan3EQzNTUFoui71yNhekFoRRXkXIJ+8I4lHCGZI9PsYiqO4XKN7+DI2rji8QURxqLgcEx26b+6V5kSzhcrvY3i0FjGbfpErN+GDihRvMl6a87eOrYI7URuqWtU+ziQb4z3QeSaodV8nIDRqld5MOr1K4a1owYziu5Uqdq+/Q6w
 C/hutxM+
 IlOxsM/jNA/UXnq15lGyOkzs/r5Jk+6sMWHjrS0vv8D+xkweVvNpxTk0Thb1oSE3mKGoMbCkuK34a0+zyJ/qgyTizaf5hGxOmd50MP5IkBRZ5ALXaenGgU7sTXm9KXPtUvpvO+2OCkrhfZ933e4ePKN9KJHqb6iU2IxOm+QWLWnHJrb3/i7nNRiRKjVAknemqmEG5A4M8fHRdD1mpr3ysBS5Im3Q/+z95GMlwW6gO88z1FDC27lYMHMF+TQ8KYRG/29k4dvH3Ho7+0dUbS1FfG5J4QXxORj9SWOhoAGmFHo85a8a4RTaEt47Dfyac9LBag8piewZKlyKEZm6NkFm99GwzhZeoHHkFo7VbChxrT7JEOos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 13:23:27 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> There are many instances in which linear_page_index() (as well as
> linear_page_delta()) is open-coded, which is confusing and inconsistent.
> 
> Additionally, vma->vm_pgoff doesn't necessarily make it clear that this is
> the page offset of the start of the VMA range.
> 
> Doing so also aids greppability.
> 
> So use vma_start_pgoff() in favour of directly accessing vma->vm_pgoff, and
> linear_page_index() where we can.
> 
> This also lays the ground for future changes which will add an anonymous
> page offset in order to be able to index MAP_PRIVATE-file backed anon
> folios in terms of their virtual page offset.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  include/linux/huge_mm.h    |  1 +
>  include/linux/hugetlb.h    |  3 +--
>  include/linux/pagemap.h    |  2 +-
>  mm/damon/vaddr.c           |  5 +++--

I quickly looked only the DAMON part.  Looks nice and cleaner, thank you!

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

