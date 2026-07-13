Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94858C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FA556B00F6; Mon, 13 Jul 2026 13:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AAB96B00F8; Mon, 13 Jul 2026 13:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C986B00FB; Mon, 13 Jul 2026 13:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 548E86B00F6
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:59:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D86EF40153
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:59:47 +0000 (UTC)
X-FDA: 84984516414.06.1A0E577
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 214A0140009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:59:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7BuXF36;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783965586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYvgaKF+lNQasv/wb3uzhUgLVtPhLyGMvnl75+AOHGI=;
	b=5RKt23q+y7Z+yrEDAZRT5cuqo9y6T5+MkUzSM56aXlCEElW7dgfeD01/+9PaUlcVW+Ndq/
	PD0dr9ToyLpjzbGz9dhPwYgGsvEehilbdAg1Tl0EXQ65UZBKrfeatPp1ZqL0bfdGTt/y8U
	YnacIP/jhytHf5L8Eeax1MfqLvtYxyA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7BuXF36;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783965586;
	b=a8UO28ViikjdCGLs826ulX4cxJ1ldb4e+VBHA7IlY2VD3qOJMlNshdCevxZXSzvbm2kral
	JRzdeoSrbyM+frrDecm3FjcJO/bToZawYarV41rH56Da0qBtGJZ2xVOLiQ/I5slAAbQMjh
	Z++JPtG+hbWLspdzfxOdj771M2YSzpA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B2DB600AE;
	Mon, 13 Jul 2026 17:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDDF1F00A3A;
	Mon, 13 Jul 2026 17:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783965585;
	bh=PYvgaKF+lNQasv/wb3uzhUgLVtPhLyGMvnl75+AOHGI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K7BuXF36OkYrZckYedtoDXpC45usOaiMXXp48pArsJzL8ynFf9YVuQSRcLkffbf1v
	 k4BSU0QintjGc16WhtGfqpni4DMk9w87G241IxY3EOiJuKdiga19Rf+cARcHnJ3PNn
	 T4LYEPcgBncSjVZCoJmYQyjqGeo/bzWqdUTRrHnV1kB/+N30sV1AFh7RPSY1PwzVtd
	 sq0jE34LcALjEuYQqVbuJ0p4D4cKbyBwW5Z7V9K/tjpTptYIEebrNU/atmR32JclK2
	 WvJfSROMS6QJitAG1liEPWSC8pTk9MeWkCCKcLLOeo0X9UEiGZOHp8Ng6kePDfnVxG
	 Of6QbsC4EvY5g==
Message-ID: <da145e1e-95e2-4eb5-be18-fdac20101987@kernel.org>
Date: Mon, 13 Jul 2026 19:59:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/33] mm/rmap: elide unnecessary static inline's in
 interval_tree.c
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Russell King <linux@armlinux.org.uk>,
 Dinh Nguyen <dinguyen@kernel.org>,
 Simon Schuster <schuster.simon@siemens-energy.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>,
 Peter Xu <peterx@redhat.com>, Kees Cook <kees@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Andrey Konovalov
 <andreyknvl@gmail.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Lucas Stach <l.stach@pengutronix.de>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, Abhinav Kumar <abhinav.kumar@linux.dev>,
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
 Marijn Suijten <marijn.suijten@somainline.org>,
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
 <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 damon@lists.linux.dev, iommu@lists.linux.dev, kasan-dev@googlegroups.com,
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-7-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-7-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 214A0140009
X-Stat-Signature: oh9cfu34jr8p4mfaffpziii3dyuamtco
X-HE-Tag: 1783965586-873712
X-HE-Meta: U2FsdGVkX1/P0bEsGO1Du6q9vZ7R9l0wHoHlOLH1kzzuFHchPXMFTyt8Z+bu09rAvAAMt9EOfTZGEQ1gZxwGw7c/kdvstAyUN/EL+3WygfHWEbUhNOpMM12GczFntrQ2t1sQpKQ7BG19DeTbtuwmi9NuOhMmYXp780PEC+jyWzOs2paOxg6qfhfifrkbFdAHe9mBsp41YetkewOcaeCmLNaRRuYAtAISQUcJAa6l8YYVKiqFC/BbJnabqxufnwhQNSgFldgwF/zmPf4FOl2Bk/Yu19D+py3CEcSryJUbppAu+Dr03wzD5p4PiBG4akQzL+N++G/1Tr75NdZW1GIh5QprZPYZPP9+yHxVOYab+KSNUUUTbiAvHHjxsm843pAuthIF37ZfVNPrCdaI5nfB4NA2ijfA1YxTVdlbraMczYKvQLElr/HHFTvCe+aYQB9WQbQepTUpx7YKRfukkEiN8bk0aeayoSn8mLdG1MbI2ZDcnYiSxMerRu5e32+dzIJh7hGIHT053hGwPKrfkabrFd3btRTiT34Ytgxn011ZpkcoHaoXmaLKvngpx7buIQ9yol7Gs9ibezmTkWVGcke6OZAWfdi7QkJ62Zfz+ZDJud3/IrhSun/POwKXqQUFnGEmojYF2zAu7rnuj8d/imjdKsb4JjNy0Vvl0MBGU3P4WVNC+o23rLuDppN1QthJ8ESeqnSOKzcPxsmmAG4M64WFAxnU1gkunjFJWmRkXefv0CbPN5yuiopW4OSljuSa1JoD4uIocS3X03dGRkpYmP43e5BNLFKIQNF+AmxfEWD/fHJJwym3zW4Utm/seWYdUQWFQ89LYnoCBzQlE/i3X5TBD6W7hTAtDaZUuzT2l7weaAjkxUSDrjZRgzFy/+EOx/++PIyg+rxGYKjFhMQYL8HM4Jc20BVxewRClR+ZnUUFkStvMpbicFOiZ+AyZg/RXZ6TLyoSKE/yjVdeSErx4z9
 iB5g3vIT
 PGvToFyu13vf2z+wNSIyTHnC21Mq8EQiQZP4DR9gjVNLKTm6Y12mM3GMMWCgyO7xj5EUo4TiXEFnHfJ2AqIfoYuWA1ia0psJw3EFOke6dPbS2QPWaMmbjzkOIiJps383JX2HyLP9CEenef+N+YzrnM6MAFRyJw+OxI9kltiYHMAIR6FQuDaKJ/U+TbFWSskT7xVsejPN6D1AH2AeBZ/QuY0LbAaonIPrE+ZN4YFPvfoYgdtUZs80NygT734XpTA16urn4dpFmvqnrkM0lszcDBRltfLtz+HA8Gh7lbbgHRbdsJL2LcLOFD5ZRy+cqvKkjXZ7bToN2Ds1bad5e4P8i+G3aJOvTIbkvHfltR63a6skLkbotvtnfCpHze82RbfqMP29WeFgbNfJBBbeQXuciSVd+ZmmvOmGh4k+fEEnG5sly3IZdjlrkPRrnz+AJzA49DvcdRdMLFXTjLKXr6i8Lhe0I7LqswguIErYI254rnl08kcB0jxwpRxGXT1VLVsZyqb5m+QkGJTX9osZ6SlL8+WEBW9izET9ot7Lep5SPGMJ/cjl5xMsaLihsBfISs3PuKviPFM7jgCMLc0xOAoPiO9ZBrBQK2t3rKOpzKDOYwwTxdq65XOSNWqgQOOKgH7MytPzNGWM7jIhngtKa6vZtQNIlF/pvvKcSL/SqZmj7YeIaRmrdqMN1tCnUJMcWJrSO6xKNWvMRUV50QCGOO8h1//R94zk0X+KmjMQmlHihEJ5VS8cyE1k5laoEQlyUcdGV9Zgt1aTqn1fU3HxyYabZtMyn+NIrsV5r2NLWqTiV9ImaxTAtfCk/bTrQdWBIwPEdzt9NB4ij6ylUD1Jp41cfYxhj4OKkvXxwFJOCFmCNHZBDULHfsr61+ogmeEdbReEYsDs/vSy1DL1Rs9sLgGNR5fihK8zcVnngrpuzDhRBTQrbzHb3KlI8IVPSocm9SXGW1CB6T6g1d+AdmKRQ2zdybWLJ2hqg
 WtguaGgv
 kgjH97QIv3Kmj6lpTlVD13u1qKJzVPWG+xXZd3Zy8M0PVelm4bVr3IUgGc3cA3DAKe6K4prAqSCfKsRuwxxEL3+iSK4sxrjWOZkQQUN01ZCCNTy20rEqyoa8aXip+q7mCnMkp0WvLa+rbcCDSp3lbNdT4CjR4b1sUsLYZgnv78udAm0H3K0xrK4mEwhyCiNBZSxx8u14b0nNyYMaPLqGrVySGfShJhGIUgIv8/4s4WeffgrluG8N8Q4BZCT2bvviBOr9/sEX8rREqrBB9yKZqRY2K/cL88ZbRWgCRtc5KjQ+CkEZ6i578pvpTtLO7IaHU+UaalCGkiRrtHpzTItId37p/fzmCcbrjPeWLbx2ZnFjsBxPwAk8kbSpSG+tVkykmqTrL6Sriwe5ePJ6MjmavDfaB8UupTjOTEP+mncUazfq1z8JCIx4mkMiPYuBl5uOAyMfs2010D3nq/C0kmtg8eYtE2Hm4QKBQNQx+pyxPnjSio3uAIoVPJ8lTv4/VQji825NUUi7jh37F0tvlc8W67LDHjTfVi20ZZ+mp98GNVKDpRsSR+9JGsy2QwTnU1bZECqeEFl3AMPguIxNFG4QvmXXwDjE7vXEU8QVM2OYq64co9S7frRmhqyDAwR2nKmnG/UK3Vetdx/do/QLp8Bm/jRn3FM5oaZOAD5sBeT5ei3UzfIMHhB/uKAOBYeaihD5PHh/uxd01xxYjs5ziT5roMc6zyIXF0Sbofck9TpXfJnvewcfjxCtLOQVJg1G5WfpCfoi0S+ylpcOKfc2eRtyXwBq2netiRGYcJYSvyCaXzjPN2d+LeB4kbMg1ywmAP3m9cshW+rNfh0CdzQdKeRneQJcYyJs31GOvGHWyYYPcyCDaifDl3/UFnPzmmKIf2uZhq3u8zk4DyeNoqgEgn7ZGM0atQiU102wSAFW+DOQnMk+uvCiqk7AUhkZU4b1kmD8kNnxFUChwQ6Kk/NR1YxAwbcqFB2v2
 3n2JKPDI
 PGj8aAOWIoErib4VL7RSLDg4/7weCq/lVf/qtRVy3tvnCQVcktaZ6BrwL142wAmvsercasQUhMhHw8t4tVxIjjo1ex4Va8y3XJSKdnpMEPnNN3mljVx/uk9iHMK5E3vcu+qiDcj8kuH++7gBql7djexiJNkUg2Dj6ow1CRguunD82rGiwUQ2Ot1m4/F3V+01oGBzAP/XBqYEY9qnzR+acIRpVjitRfCHzlpqmz7B6QcGQRtPNHs4EUC0xU26pwIn4D3MZJvQQQxMjzWYG4tA5AdJZz2ZJwdl6uM/xLiTcxAT4496ASKu1MneaC7CUSa4ZMSu1eNTm1aYtGkr0Vq7oVJ9tChVNKuzMh+HsnEo4MqwTEAr6Xw8wQUF0NTwy74yq5/7hgwe79ANlRhFDwi/sSKu1o3qRG7eUD6GOo7KebBIkq/ZEcEQ6Y/yjvgaDH77HOnhcYrCs7cou92Iw9EsYruXKrurdDepI3Oa8ac6IE1ujpIRY6PlYvjInQCTHXKbsYEJBfcc3l6aimX41Cefnaj32g4RtPk+KSMEyWSrltW6pQBMn0/jCA8vKEzZIpZtNqhSX3j2X0YOkNQYrju0YrbZBqJnZBGcsF5x6PzMmMb2/OzLF3on0DwH1gQyfzEecMn/+JdZcaEIJA/NQbBPARjfmgK7f9vjnhGpPUHNYD+vX9CK5jMMZv3NOBY8GcHEw46ClZD/KuoJPcaePONfBJiAVuMpw5maP04Y0UFpZ1APDf9CODVSQN/BA/tu6R6clR4H/VphwZeYlLmwUCZ5zLUKR0N+yoivD8wzdfEcvt99ix9lpXtBn8U2ICwwZIm2SRkFEwGel29qlP+gvNvFOvisVafjIm+kCVJ9Zf5QyO78XN4MYXLRpunUXxbLLboLHDz4OvYQ6DThQIM4YFvwKcBl3C+O4RXCdgROJ2y1uQ+IS/RVIV6M+409DSNDKT1ZJZExO7vV0PFimIbAyXJ64C3WeVSRe
 F+9CF5NL
 mCUu4rY0+VVQE5epLbBUzGfaCvGVE7Nrcn5MuoybXD5POyfxNVsNUX/HeDxm0hvafQefXDuQjAmfPDqOtWAzfQB+h5OZrps27MyYyY8DV4zI0mWW9pnhTq+QxkY6uUEYIYzpKttrw7wiUM0EIMbYEMslMOvCZQxeIW7rgd0e69WtmwRWmRsSpjy3tnlZZhbPjKHkqrXQ3yDsb/Ui7N9MkXqSodVmr6UTr/GLKPSovI2AcK0L3MemzYRSiQEItW97DrwanefAXYyrdEluGgaJsMiXDo9hslCG+cOcgM/Aq1M4ORYxs2zcMOxCnSkj5neFPnBZfbJbyHYDWW9V939bMWp+Ha6WydvBPyxPvNvraDOS/+97XeXxhlrH7S0q5izXHZ4U4JNM607Qml4Iv296BfS+LPaLf3k5No2iTdVCIOIA8aK3/5AtSZ2xIC3AZ363T/Dj4oZhpkGOUQWmMvtYVGztIWINhr1z5tMEfzcgI0O0Unne9oIw4A/ckfq/+Znob5SZVPh0Zok0+Z7GO7z1J+s0onDVh387xjUQU5vow0yIry9RYnkV3KAaWjdAjOgy97WVG+lJ3vJikvBYDCxVyEhcyGkGf5KUdl+YB+2mGCGK/AzyLfUU70vC3PoVl6iKd9hEKJsnW/ANtU5jJ0s0MrTYtHyMGbXAvM3rc2AZIQBpvnT5xeAPLJjn1JMc8xFEvIU8ngzpIGNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> It's not necessary to declare these functions static inline as they are
> contained within a single compilation unit.
> 
> This makes the anonymous interval tree code consistent with the newly
> updated file-backed interval tree code.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


