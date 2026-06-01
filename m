Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C07FECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066106B02B0; Mon,  1 Jun 2026 03:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016A26B02B1; Mon,  1 Jun 2026 03:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6EA96B02B2; Mon,  1 Jun 2026 03:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2F316B02B0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:56:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E9171C0702
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:56:47 +0000 (UTC)
X-FDA: 84830587254.30.9EF990D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf07.hostedemail.com (Postfix) with ESMTP id 97B964000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:56:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780300605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TnjlsCRVbJRi9kwP8ZufzTZes5mMjU4DmlCJoFUUJ1A=;
	b=HS9u9gKl1sSackW3Xv85kyi+YKYijQl1hVgUiLanBQNFwQ0yP+XIc/maBvvXauyY42cVGX
	rttwJfDPu23KaiS0IC0jIHIgcbsCR9vQx0ZvT626V1W4vLMkSxgrLTKoAfKFPbOhN4OMnI
	8rtN95VMSSaIhbhM9AdFqooNzGxT/Qs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780300605; a=rsa-sha256;
	cv=none;
	b=oIEszJ92rqi+BLe56xxAs1fZnBrU3p/dA8q0+GV2cmZwKYeCKVbZ8RQnbLmGTigH5C7X6x
	erXM8by36onMRRC/qcCXu1WU/YMN41sHZxhAjdJvpul8zHah8qR7OGfLpqaddupIj1hlh6
	f9OxTrt4hWcxl5k0dFSbEWSgCOTu4bA=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4037268B05; Mon,  1 Jun 2026 09:56:40 +0200 (CEST)
Date: Mon, 1 Jun 2026 09:56:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Harry Yoo <harry@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Brown <broonie@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, io-uring@vger.kernel.org,
	kasan-dev@googlegroups.com, bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?utf-8?Q?=C5=96ob?= Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Abhinav Kumar <abhinav.kumar@linux.dev>,
	Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
	Marijn Suijten <marijn.suijten@somainline.org>
Subject: msm_iommu_pagetable_prealloc_allocate, was: Re: [PATCH] mm/slab:
 improve kmem_cache_alloc_bulk
Message-ID: <20260601075639.GA8193@lst.de>
References: <20260528093437.2519248-1-hch@lst.de> <20260528093437.2519248-2-hch@lst.de> <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org> <20260529135045.GA10647@lst.de> <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam12
X-Stat-Signature: i1c1nczo3jfpdu1gtepcmaae3zbear9i
X-Rspam-User: 
X-Rspamd-Queue-Id: 97B964000B
X-HE-Tag: 1780300605-801295
X-HE-Meta: U2FsdGVkX1+kkfeHuIi9oOegNFGeUvKj6l4+N4yPz/u6sBtq58l1+PWtUZmdBo1UH9fxXdHI30sActExs09Ja83VE3017ZV40eW09hhW0X/o5HxYFexQ3q5vxsdlQWOYKrI5ofvk8XFT07VUhMInef7jPojJD89F5UPQZo8zqpUolYaUerm+bPtCeWKL8X1fE2LYrrqCjmAw2tlVVSytg0tv0OR6R9SfvnAvTI6VhASxFBVSEi7NNLQKRuvAtp4mADSY+EevJhu4sO7cLtov9H0De+ZWhXV8poKZJnaEscYEctLpXuAdcNeSWPw8BoHQ/dTmLDDZDheNoS5eKg+fJ4tEmw9rD2YLWDI64dVh2Z+ODD2KWnPGxj4fDlqYEPvtiEij+LqrwhuroLqbo5b4XxeT1fV+NIssSAVAjtGO5NlBaIiRP7icRMTTzfeJKzqS8aI99QgScotm3LvcJU+ZB9Z/sRceTXKMQg4yeyGu9oEz3aYE+8a71R/X/YLtDM5/jzqooR2xwGP3nDmz8St1QvOjvmZ/omw77kt5YALv2YhB73+sfNHlevgXvpY4GTrpLIbfg0mglcsbWDLdRss/ZsDqoDTeoEXhnnCtFqwyLHKACKL4I2cdOZNaMX7ptMijKYzbRg2m+vaueXYBKHkxVMltmTYtyQOXDVo96tYCFSgMonbW91q0pATIL5Fk0+j5dhiJpcxL6LkxOdULHzX63HaQrrn/zKe1Zb27GTYv3A2IBxBjk0tzDOYbnHnJKQmsBZo6L0GYNvl0Uxv37WZ6Z4AqxWV5oAuxsEkaroAjzaG62izkjxwmWCEaofCewvPrpfEub4DmPxKmi7yWW2BUuuk4o8R0F2eamQEzxi2ifj4ErOzjC72zg/gEzcF1RkvP1Z/h5fxwHLwRTN0TwXHHGObFMG0v4vjnAfQ6oRth9ZZOID3b9/fG1mscr0dPKeP09LEG+r6O1N8ils+WJDX
 Jt92YMlQ
 /8vXC7/lQoE5WHINCGBoXp032j18TOQXvMKpXFyfkVX4mWFlh9C21LlJnD7nXua4a7ECBKLF5LuieuG0XOzM2Wyz6LtzlpQQDUu/Ta1jh4RDJzl3Xmy3n9GPaZ6SXEDvmY5xu75IjS+Hf809N3u3w8ZcUJsqNJ7hLt+xAUAKNlAOnP/QMkeTIWxzWVRMNseacAvtsc5aSYfifI6+G/JfNn9LGZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 03:39:06PM +0900, Harry Yoo wrote:
> > Ok, thanks.  The two Sashiko complains also look like they had merrits,
> > but I won't get to looking into them until Monday.
> The review:
> https://sashiko.dev/#/patchset/20260528093437.2519248-2-hch%40lst.de
> 
> So there is a user who might call kmem_cache_alloc_bulk() with size = 0
> (although the comment says @size must be larger than 0!) and
> kmem_cache_alloc_bulk() returning 0 was considered a success in that case.
> 
> Either fixing kmem_cache_alloc_bulk() (and the comment) or fixing the
> user sounds fine to me.
> 
> And yeah freeing an object via kfree() allocated via kvmalloc is a bug...

I think the right fix here is to check p->count somewhere in the msm
code and never get here.  And the kfree/kvfree fix of course.

І.e. nothing to change in this patch, but a headsup for the MSM
maintainers.

