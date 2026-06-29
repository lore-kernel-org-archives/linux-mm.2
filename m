Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDBF4C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A316B011D; Mon, 29 Jun 2026 11:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4476B011E; Mon, 29 Jun 2026 11:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576F56B011F; Mon, 29 Jun 2026 11:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA476B011D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:27:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9BCAA1401BC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:27:35 +0000 (UTC)
X-FDA: 84933329670.12.16E31D1
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id BB2F640010
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:27:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="E/NjmNO8";
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782746853;
	b=xkuDKIqELWIs81sScVQP9L5bjLcIwc5bwWFlQXtIxQ57WLC3gJJg8Z0fekiqEwi7vrMX2q
	2OjX48kN1kMqfnYhYOwbwqRXu5lUA8kGqtGdwte/T2TgL8eCejLJ6d5bV33Q0p6FS9+iYv
	kEvRJohDGfB4gKKE97RrJhJwvDwRJwY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782746853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVSnUoP7z1l2IjNO7QqWpl688BIslf+DGUxd2Ln6LGs=;
	b=6mEpc4B5f5N4OkcYKJ+H211b4L6+Z30md+mEI0lzRr9ffFQn8Pt4YI1s6SqlhGCK/GFsCJ
	P5t6z9XJqYUo3hxVkAn4l6F5Gv4YHm2tXxzHWXbljzfTvYT+9/D/dnsiAFl2R7/gt+QmYA
	yHLYuepCAhjZK68v+qQxJMUl+zIOU3w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="E/NjmNO8";
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e512a9a6bso82435085a.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782746853; x=1783351653; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YVSnUoP7z1l2IjNO7QqWpl688BIslf+DGUxd2Ln6LGs=;
        b=E/NjmNO84/8o4XR2rke/PV/S2HlbhQjHm2UR8hWR81UiFKHBbDlD+3e3h/SOX9DjyI
         YfzssFEzZ0gBSSBgpZ3CfLROzUeeHSXeM8rMIEn3t0nua0I65lNR950UMqryaY8Kfwn9
         lEb4KOinafsIHrnK/ya2ugFqU1CO184GheMpbdDYdQhdxiBqSJ/EDW6xK4L4rIOvd2TN
         5L3VaA2lz+eRcNo0eVJCcspmG9oYaFvZSfLG6YSj8kZ8UdMINbC4h+hzZ8DnbXBq0XQz
         8tYon5OJkQ/I3ZpcBcJuddaoRUkpPrBehRWnj5swTER6wHoHAjADib0ogO1qnM4hM7s3
         qjpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782746853; x=1783351653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVSnUoP7z1l2IjNO7QqWpl688BIslf+DGUxd2Ln6LGs=;
        b=J37c5Cjj+dVzikNBXhcqL7ZS4BwB1Z8dCnrpWD2O5LuBCUDqRrLrjp6PkI0OjI3KQ0
         WiI5xpMoZhf+jv1KcIIKKAPNJOfGlObp6jbmZSR61vj4gWzPRFIVbRW7gVyITGTWK62O
         x131ll7kKd8JyRYLEpzBj+9u2ds1QjtvAuJZ8Jsydk1HrK1st5LPWPu8oqI41oWoIWrR
         vFYqaZwwwVStLyR0bpTCWgomU7Vp5ptNeYKPs+BbUtkZblolWdzNYQIobNkqSQNSlJhW
         a+Qw6ebBm71jTYWJWBJ7P3qZsTMnNuOKoO0ZkH9Hl7CjSGlKemxkRUt1w1OcnfW/NXaY
         lXDQ==
X-Forwarded-Encrypted: i=1; AFNElJ9GMVmYK1Iff+o18omqkBahjdUDj508InnuRyl6nV3bqAwkyqiL15TljSiXqAdVR5Z8KSVB/a04bA==@kvack.org
X-Gm-Message-State: AOJu0YytgCGvgPzMPxL1YNx88fZMoBWLaxb1ggfFWfSdudTOkCvkvwBe
	oylsi2BNZpKTxi0gZYySRYKFrOdrLaNwt22LkmibkQbOaXqV5tlRe4q80+rMnwAtlSg=
X-Gm-Gg: AfdE7ckeeqx/My2S5nqgjqPi6un6JVLlNgg0iEE4a+G/CAwsjGjnGwJfLPRDwh7Ct/R
	q3u0WN2h9TAapZ2nAaeTNcsx4Slu4SxE+f4Dkocy9wD0lwrWYDe/X5E2QJvsrofuzALZt2ZSdY9
	KLrvT7z0+c5TRU0QugF+T6JUQ7n+DfC3NqlEq96KzifRRV5jfBuU+rTmkJjjHWzzkdjLfu4/ktn
	sbxa59bNEOddmM2SsiP2RLB9MA9z3ywukbO/iGPZAz7JMhz/d/p7mTkjhfjehTGylokSIdVB/ds
	cUtPsonGhviLpTYBfIEmqSqTyJWPQNtRLTry3VnE4wHBiTH7pCFKM+x+0umiUa+dhA+MKA6j/16
	lbjeKMZcKQm1neaWeZOFalLpfjZD3rSqEjQ4CLTB4UPdYE/rnYDeqmN2SfVodqjioAyVV6301OH
	GiSRYMrW+XUI1ByLV9ejAaBMJIoQF6oK6i23yJOw1a5W7xMTZ126taysCtIjrzrPbOKPp8NTjpt
	ew/we4=
X-Received: by 2002:a05:620a:7002:b0:921:9df8:d38f with SMTP id af79cd13be357-92e62785c63mr1415985a.43.1782746852526;
        Mon, 29 Jun 2026 08:27:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e621943b3sm7429785a.19.2026.06.29.08.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 08:27:32 -0700 (PDT)
Date: Mon, 29 Jun 2026 11:27:26 -0400
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
Subject: Re: [PATCH 01/30] mm: move vma_start_pgoff() into mm.h and clean up
Message-ID: <akKO3vnNmWIJAZ7z@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <b28b698df4c009e85c4728446ca5863d8e633164.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b28b698df4c009e85c4728446ca5863d8e633164.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Stat-Signature: ttweuzh4qpx6uefx3p3jm1ftif98xq6n
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BB2F640010
X-HE-Tag: 1782746853-621498
X-HE-Meta: U2FsdGVkX1+D5Y4ZYov9Zbt0SUKuCUmpjnOuwDKrFA2mtpwOIdGbXF1BgEEHf/5t0K8CZ+I2TSzOQdzDIKzCxvR0Ew/8ide0tzj1fvyP8/TfLUBrt9Fs9vKJv+PF+DmWzGDApE2aoj6byyYXtTJlbBuoTakdNdjdknt6dXTqyQm4uEBWs3J8lODaZDD+WZ/iS30cwZshNok7zrTlzK65GM89r3xzjvBdF/Yxas2gPrEQ6S1s7X4teYVd/G+GvHdhJCmU7juKcwAaRGVX+Z37OcllLvh5HE1QYdUf+DI75ErimXHbUz2GtfQoVYmPjdKcZVw7IImMfm/g0okivQW81wTbHs9U3HXMRUSj7DL1nHaRGSVDCtkMqpqihDJPAZfspBUUFuh6wExYRj5Kd4seVmnkun5yBo2pFR+hBuwkV56mcI8SsG1w6l6UpYxC8W8vrFB64kMsX7txBF+2jlYuEML2mk3wuQBT8EdWBqDiGLYqmLnqRptqyKq15U15RMcU76Lt0hcUpQrcOKlj/xM4euNFrtibqRR2wW+nPh/9snumQ71N1+Vuazo61Q+3mjca86YmTz43M7pAjix9Vrbl1ymTgO2PKo6RZzky/8dCNur/Xbhw6l9lHhmtqfUYhTHhAv1rS3eidibwnot5g+Et4GMHldimerkRJdoh6SJNktdcET5/xJxSRqsMNEfuVt+15B4hLdXHLBooNdcTH3xbnLe8X/UL+6EoHPM5XzcuxNbdm4eJR2sLohilgd3WFeuQMNcbTngZbHp0mQHVBR2QDdJJkwDo2rU7xB0VxdJ7tRCUCTc9GConvvAKr3j9vdeJj96W4HCQsZGD/pcovpxkn0WpjL1mJ1x4ITOZtVKaK7EHhfbYuvDtTvGLBV2XRLKhhxlnW6LfklbEgyywPTAoQTkiY/DINyYVh8CMeAvmA3ozufZNWGs9j/2VFD42mjMG1EvYOPFJknQC1473/nK
 UVZhFx6O
 uSNcyMGYD9UwTdsKTxyI4xabZCv4QREex+/JqhcS3ZkA3PwTsyMVGFVOHilJP43uHdlXDLyLJnVA4Re7aMUGKJgZXWLXKwn3J6X1uy0yGZk2hvvOJRR1Qh7Q/vT12MgiAMG/WJ8IpR6Cr1apBNNb8zaO6qDT/kVU92snSlMLgys6DTUAGpOS9hpOPccxUMT8Db12BiSTH0WJBNLQ1VgMDfz9pOuf2MaYmVQi2OSNJw7ZtWcBlBYPlok5D4D2OhjIvAb14yzUIAfNgH0U8VSF2RlglMcBT2eE5ey/72YwC6KX25eKbbrAgk77kl4ClQlp5mEoZSydyrKqIKYZ/jdhwVY5BJi41bVkFdx/+rLXNEd6b3MMVxDFX+GP3uan47gTq6vyiEBBEB6RiOGnVJSBmyI9ExwEhIWd6Y3MXwjOdpgylRTg3GToci77gQ0hLOBIVIbsgju2OeFvCPMDPhHd6lccIwc9lTmwVrwN3XERRBqEzGT2a+7t4Y3uk8iRJ/PvQoWkGe420kwx5EHXcO9yGBj/+hqqtlkqIKdUY7cHMibw5kOKwePMK/KnnUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:12PM +0100, Lorenzo Stoakes wrote:
> vma_last_pgoff() already lives there, so it's a bit odd to keep
> vma_start_pgoff() in mm/interval_tree.c. Move them together.
> 
> These each return unsigned long, which pgoff_t is typedef'd to. Make this
> consistent and have these functions return pgoff_t instead.
> 
> Additionally, express vma_last_pgoff() in terms of vma_start_pgoff(), since
> we wrap the vma->vm_pgoff access, we may as well use it here.
> 
> Also while we're here, const-ify the VMA and cleanup a bit.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


