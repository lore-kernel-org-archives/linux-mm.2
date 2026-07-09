Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C23C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694396B008A; Thu,  9 Jul 2026 11:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C0C6B008C; Thu,  9 Jul 2026 11:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582A66B0092; Thu,  9 Jul 2026 11:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27A006B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:56:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98BF1C1200
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:56:02 +0000 (UTC)
X-FDA: 84969689364.30.158638C
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id C1651100012
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:56:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H6DOgS55;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783612560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QupnWz0oLATZw6wM2bylQaqDWCRhZF5lJVU8oFwJF/g=;
	b=sNcbYP7MlEOy3n8TABPaCP39qpA5GT2RwZSycVDxw/9kQU2CDlEhxfil8XqjxpaWTpPaz8
	umUybluYtCkLL9Zg9qpdAzJdsNn8v6yvBFyQNFD67Pqi0QGK0Fwsbq01rwxdkITqxKW0rE
	3mPvx1Bo1F5+GYpqlR9DvUzJ02pwYXc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H6DOgS55;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783612560;
	b=HDPcfm80SNA82Oq+nwvBi4NGhORxF0xYkBfljn9pZco3LnZ8OfOV6kkRGIDTnzaTv4J7vH
	L6+7/6hgs0liwDhVMKQ2FRABGEtMKNE89AhDmvS1KqeXHLmXdvBZLh8Y3HzLdTY/PEMhYE
	OG4Dsjx/xwMvQ5GUBaoez0JqrB1P/Cw=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c05dcdf49so18759711cf.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783612560; x=1784217360; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QupnWz0oLATZw6wM2bylQaqDWCRhZF5lJVU8oFwJF/g=;
        b=H6DOgS55ngOzbRHxwgzX4lV258z5Hcl5MDHfSVbrDhd+SrEWIOdhTa2/UueBHcGtL8
         FGbX5j6iMINba0ZZK/WlXhPpSun0Yxl1wORshI5zgCrC8sg4mG9n5fhdYPT5gYWT5OMW
         pAsaAoVAX4aKTKKYjfUtjwGUeMZmRE3NW0/J2L6yKwtFTkJOVPK60//FtfdB+U658pUl
         GbCgT5HqEueLa1S1+x4ZjrWvGNMnHKU6sJDkzicxMFMwzVa+b0l7dZQnU3qT8MYE28Ss
         rTew0bOu2RAxvo7zixBCY5PltX923Vh4WLK6Tcpn3MLqeMRJofMHFhK/n+YTAAcsFYT0
         qMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783612560; x=1784217360;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QupnWz0oLATZw6wM2bylQaqDWCRhZF5lJVU8oFwJF/g=;
        b=S/r1k83NdagogBPlTuClNdbRhSOTQqFBx5rQdXRjGH07eExuPsg9/ThEE/HJefkMBL
         BqSoofHsEkGCmJ+AOA63/WZ+JkkMyxKxD2ftejjjYjSCVezCnF3ZNy0E+3LWHxQQQupR
         NAcTRr51D5+GWRb6+1gWtL8OLtIoVOmFzsqGkCMFkmUeG2DQHtLBg8TU6FWMBtDrl2f+
         5RsI9Uhbe7LUEDslka421vCQH2mLsQmZqxZqIlMlGwYbb6eNqiLlWMlztdVtiWYdYhgS
         irB4xbg4wu8U248KuStrz3P/6Phxg13EJMWl7wPAI5GItsJJLMCFr2r4IUslnbMehyRK
         vNCw==
X-Forwarded-Encrypted: i=1; AHgh+Rra6sjUPgO6U/+ao6x1Xd8bw/2pM1Yj1V9J/WxZVtq2RBp//ZxW68RMp0lEaSN5C2gMXWfa7AT+Gg==@kvack.org
X-Gm-Message-State: AOJu0Yxh3f/Iebm8s0TKyjSQ6GeA6e59ISEXXmgmOlRxvTrZTbomFMtq
	0Sg3apAYcUccX7nSOxz5Yw6grMzX6aqUo8lx8XizJGA3bpN3I6+M6twCNfusYpufmb0=
X-Gm-Gg: AfdE7cne53JyalBVk/k0+wzCzJ12kKwN9c1xt7jOfCwYjZn6ZSAL9Dlu51ZYlBf3cTA
	QLYpMM4jdzMnVhWfpPjAnlnZ1ypHfu3vMTRdHGlJplk0tENlA4nWba080RLX+i4SAsYRfIVr41w
	EQOyUkUTo+JJ8hPft/oD4HC4wrq7nTN+QpGFJguCYRoNqBbcuuYUNk7ypfw3SKUHrl2PJFTvT8V
	bZfaplRD7Pr1QCnzvrqJf8VZzYiu8mJKDY0lTZfRoVElV0IDx4jEcwPwP4b7G12jNio/uwbVB4c
	Kvaqws6+96JHuzTFNG2ZSnbfGtOJ8GCeDxXVNgBKvCAHfZqhNVO5S8/4QUiGKsp0tQIwZbEgF9/
	/t7nWOS8ZbM87rwU4tpkzV6nfme+XiEFrmWJTOLjasTR19r38dSJlrspQ9mgmIQ43iCCpowh13C
	8L2s6xNuIAYW1lU+YU17YXdU8V5Se/PQmjWcr9fyy3ZPDhiEr4857TBtaNl4wCb7gGdhC4
X-Received: by 2002:a05:622a:311:b0:51c:185b:29e0 with SMTP id d75a77b69052e-51c8b2ae67bmr82998651cf.10.1783612559586;
        Thu, 09 Jul 2026 08:55:59 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c41d2d688sm169684691cf.17.2026.07.09.08.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:55:59 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:55:54 -0400
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
Subject: Re: [PATCH 19/30] mm: use linear_page_[index, delta]() consistently
Message-ID: <ak_EivwcDDdn1Xvp@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <bf56e2e98b512962a2fb88900d535a0e9e6769d8.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf56e2e98b512962a2fb88900d535a0e9e6769d8.1782735110.git.ljs@kernel.org>
X-Stat-Signature: ga8ym7yrhrkqr54zi95zya6mgcobae4p
X-Rspamd-Queue-Id: C1651100012
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783612560-876520
X-HE-Meta: U2FsdGVkX1/tJhqE/R2/h9H1ShPn8HbwREwjkuWpOuiUpkOdHcg2uKwgUOp+RkHojkOIzHIdHI3e4oSIkUnDpVtUAtql5t9vr7CsaF7YbKW1YuCV1bnIgJQRGhjkatkTrPJ3x170mGxDdPf/J0rD7visAlw9IRG9bApwaqySp7Is3B3uPGHk9F35Lk1emDdYFd/Gufe1olmHA/UswN/YbMJkg3te+daB3ZDEZeoR9/Uqni3ABs06dmkpjJFUWIsA8+JA0AU3d9AoYTgb22E4KzSqZ6iw1Z/XplytLEe4PoSyulpZegPOm63/sfG44euegI2o7dbmL3drWuko2v82Z/V1dZ2PP1uPJFI09DfvtLIenkBHZX1O23SS3atxHRkFeZ/jj8s9HSxx2Fn1EsOvqVaKkNAslLHkqcTdOwprxaNzwPIkKKbQGw2Fmn1azE/9dds0lHIzRPydY9Nne2ntvt6xzVdK96y5pXIiJqi8Nj4U9um+ssamFGaoo44hY4h5zw93XxqIAFQA+SNM2yLnRTImOwTkvj1wfmWCRE1IDecFxgXO5le6ZnuHegpX6S9usg/bkwLNia6HBkciegEso2rgbnSw4SCD32pbxQK+UJ+WMi+YoHAOQgf45WLErHHJzwUkv18ZK3u6J7yPqRmVroiVVafLc0GF7vV83LlTu0yaW38ens293xMCNm+N3UeQnsd6unlpiQYLjF5HIi0a0gOUsZeXTf0CB03ogmvJKMw74M1zhoUKSARihFm5Xi5HXXefxF/j3koN77gmRZOAahWdUHgxd520HdRGZrh//jKN7/U7GI58M5aQz2byG90Ml8lbKRP1sqvDq+cfgV9SxXiKQygk9vNvF9BBUdsy7CmP4YmdmpA351T0WQgWZIz9uBZbPhM8B9+01/RIhNLRg4ZkTYlhvuDY8ekcEtqyPQY4Y1lJpz1ZNFUFZCE3BkzNIQ+wthrG/K3pNTHrUMs
 C9zmD4wb
 P0OXI9BwxSo1rXYg4vE6j75RSvPdsy9tRWdlbOvWx1xdZZfPb+Dh1QKkuCtrhJ40VyHLBlqx+ITbpGB9UyuI7SOqbYPnd+GnCATuYHO847nSQZ5Icdhd60wbZBErdUUkVMypj0xUGRn7k86ElhiXCjWklh2kgKCYxfRAbW+P4kPvNvyUsND13u3zVtKMRQdyLrekrkZxDKwfcbU4wRv4unvUb0HoyTAT+ybxwA2901OzzYL/DYihd6h3OJCZ2gloppYUn1oAe3HHVOIopdJrjIxjYtj2eEr7vETUn2iIe0o/v7C55OmtBUykF3Q7ECnaKqiD1/1OEbPyo6Khh6x7lwkECatBrQH0rq0VlQOALl4WEluN7bSivgt4KtP+69/TTFPL+QPFfwkkCfz4gSUJJWocOaYmwV96EZfoy0iSmbwDy38zAMXefJFJGSsj1hqn6IFdIn/D/P66iy1iw9NF3COy+OwDSZsXz3zJFMntTxkdos33U+zh9JZ1hZhk2zYwd2S8La23bWAXW/07xlomhS8hOOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:30PM +0100, Lorenzo Stoakes wrote:
> There are a number of places where we open code what linear_page_index()
> and linear_page_delta() calculate.
> 
> Replace this code with the appropriate functions for consistency.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

one nit

Reviewed-by: Gregory Price <gourry@gourry.net>

...
> diff --git a/drivers/comedi/comedi_fops.c b/drivers/comedi/comedi_fops.c
> index c09bbe04be6c..536c25d8dcee 100644
> --- a/drivers/comedi/comedi_fops.c
> +++ b/drivers/comedi/comedi_fops.c
> @@ -25,6 +25,7 @@
>  #include <linux/fs.h>
>  #include <linux/comedi/comedidev.h>
>  #include <linux/cdev.h>
> +#include <linux/pagemap.h>
>  
>  #include <linux/io.h>
>  #include <linux/uaccess.h>
> @@ -2462,7 +2463,7 @@ static int comedi_vm_access(struct vm_area_struct *vma, unsigned long addr,
>  {
>  	struct comedi_buf_map *bm = vma->vm_private_data;
>  	unsigned long offset =
> -	    addr - vma->vm_start + (vma->vm_pgoff << PAGE_SHIFT);
> +	    addr - vma->vm_start + (vma_start_pgoff(vma) << PAGE_SHIFT);
>  

Obviously correct, but was this intended for a different patch?

~Gregory

