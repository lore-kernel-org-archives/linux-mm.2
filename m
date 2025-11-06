Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D70C1CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:06:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA748E000A; Thu,  6 Nov 2025 11:06:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29AC28E0002; Thu,  6 Nov 2025 11:06:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A428E000A; Thu,  6 Nov 2025 11:06:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 070AA8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:06:40 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C30451601C5
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:06:39 +0000 (UTC)
X-FDA: 84080660118.30.3185E8B
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id DA21780010
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:06:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FrjMUpPj;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762445197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qlags31RcfCKvG92vgNW4kmUAWjqVO/1QLHXyW672fQ=;
	b=y+plkMqEFm3j8vFDJ775YzANozGvaeGfSQXUurqEScXlKCRHhCltOnbJGYUHQpOnhUN9d4
	tVY2LC8ayeJzxZBpqeN0XdyqfFUL2sBmJnNVuz/dWzM64j8nSl+vZxqMthL5Cq1bzdeq8X
	+y7Q7DrJONTPwZkqmlgWz4Wd0PNoDBQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FrjMUpPj;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762445197; a=rsa-sha256;
	cv=none;
	b=hhj3iWfHD4JxRUYY96/65PQIWhrg6cvZoLHEqN2YSwy5tIVBrgxVT67fkUlCIyDIhkdyBz
	SC+y4yJTEN4z9lkmdAGqUV2qyWm9uDOj3aEW4FHH+mz5Wtuz9TEyBGQGcpPMH2g0eGZn77
	wAAvjsULGdh0eU8K4LmS85G/0WSylZE=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8801f4e308dso10734656d6.0
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 08:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762445197; x=1763049997; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qlags31RcfCKvG92vgNW4kmUAWjqVO/1QLHXyW672fQ=;
        b=FrjMUpPj7+eQQ4PKN4waHAVKlg6QUampVAFxfUxp2MLqncjlIqiFaJd4baBg02Pr/K
         GCjzeXDlouePKQukYeT53Ho0Jd5IsIidDx06vMX9OAXr8K8SjtnnjbP3b0zXJGozuJXO
         nH8Jk6bwXLIFh5RaUCdE352Y6L/bTVnHF1xIQL8dsVLZz+S37FPzHKUkpMAwnJ07XTg1
         SN7bvRUMyMAGBS3MFPcDr7rJPPiSr4AiTY2nwVL4V/dftalEBep96VJQs7B3tYx3520a
         rnL+z5MRhdcxUmqF0tqgqCObZ09xgEvOBn5wSUtUHXkxH40PFPK1Ukt62O6/8sh1O5MU
         q0Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762445197; x=1763049997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qlags31RcfCKvG92vgNW4kmUAWjqVO/1QLHXyW672fQ=;
        b=jQ3QMx8I4cgukWLQ8VHDju5r2k1XtaqLIicvTzaZz8YAPxZUiZcZh5glj0OPZv/sCR
         OyYv/l7v5GKa+dHFjQTkwoNcbL/y7vxPZzNXyuUmRFtqKnL4Gb9HP2m53T3fsryycjzC
         NwPYmcUg76Xe2eeUiswGMicWMpUVUIUCs7JNYDnjbb5JolueZTb6aMydQxT3WqRxS+4l
         B/FHbynry+lGPlpl2OpbkIWchjKuWO+jEpsWd7bel5ttm1P7unDUJa3Kyx5if3HgXa7i
         KcHPTEhHE1NgX/fouj9kxTYMYikcY0uEi25SrvfD5ac1xXHvQBip5Grrixqwy99d2iaK
         yrEA==
X-Gm-Message-State: AOJu0YzlOi+SPAfBWOTuc3yohP2UgSL45pGqStbfr2TE8j0UK9LBNOuF
	GQtqP49UI9wAwpnKfJTYb71ZitUT9+cYB9s6nE/YsoQBS+s7NR5Xeg1wHz2X9gDnOLw=
X-Gm-Gg: ASbGncuni0buPlXJtJfr10S98MwLAhcdiiTs3Q8fdiB2d9mEq1+xkZMyJRH8IIX4tSJ
	ghJRKziee8q57n1B6lKDcRjh0/2c4JyW4t+8g6K/6pXZ7JE3h1Eq917+HB5TuHjGryssYcBlEE4
	KTtOMG2n6D93vGFq8uPrssHVZVNnd/96wDLxYvJkBLUTpArPY628ThOJg/N4o4nJc2QPMVEzdw5
	J+Ye1WHOnlZ/dax6q3JwIi2A66TrltE7Zq1AR+f7xLLnTOJmmUXUbaNzU5NgWMpVEhn32AAJoaR
	8Ma44gDzyyl1ZX2K9bF76FSYCl5AXBb/lXVpLD/3XfwqLWUbzbjXq+XdvFdhbbTcCBI3FGpx4Xw
	zdc0SoksrWJzexT6nrlbJ8h5B4UXBhTjRkQREiy+w8TGJxIG1Py8v+5Lx9YUASOxs0oFYJER7g/
	B0HTlBnf90tyQen9pz8HAaogQ7au1/ldQZEhNEChwq78lu2QYUhHhDZ5yOSf0=
X-Google-Smtp-Source: AGHT+IHsSxe5JOoiqI22nTLPJo6OLJlkjEqsT6Afcf91+ImeIdz/5SsDaK9sk7rEW7EEqspIerIC6g==
X-Received: by 2002:a05:6214:2243:b0:87c:29c4:4bec with SMTP id 6a1803df08f44-88071188f19mr107210016d6.54.1762445196690;
        Thu, 06 Nov 2025 08:06:36 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88082a3aa91sm21241056d6.56.2025.11.06.08.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:06:36 -0800 (PST)
Date: Thu, 6 Nov 2025 11:06:33 -0500
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH v3] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
Message-ID: <aQzHibKYKy0SQU1z@gourry-fedora-PF4VCD3F>
References: <20251024192849.2765667-1-gourry@gourry.net>
 <2de17512-3df3-4ee4-9912-8a8f7ca5b648@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2de17512-3df3-4ee4-9912-8a8f7ca5b648@redhat.com>
X-Rspamd-Queue-Id: DA21780010
X-Stat-Signature: 7exr9ncs1tsj4f8sz1fkz4uxiw3ncycc
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762445197-44916
X-HE-Meta: U2FsdGVkX18weDNHd1MWdKaA9T6XTwb5DQjnQXC7qSMNE4yYYN4J7wdiH8gHuPznbxYdMrX3snm8kYX1fbrVNhpMtY4H+JuERF2YNKaVrTvTBhT5aiZJbcx6+RBBQAw9ImUab5cVm/biod+qsCzxwOV1u4TUCXHf9egYFdMYIuyLz6WXa7GL/BdPVMtegyYs88hm6QL6l32O1PQ9X7FuiyxaFw1IBwoRxYAu5sMJBLKZfUvJFbZ/iEf17bRFmsTy1UyGXqqy8vyhKr9x+okBN6ryPhTYo1yaI3XGn2MbSpVAKtOIegpBivBwVWohbEP24ctQaai71XZVJTRfDro7eDsbXrPsEM59BxqV8dqL12oiZH+47IeQ5rvCcUJI+6GYO4TI1YZYAivzciflCLguQlQU3hg15jTA1ZbXsF/8Zo8RIes4Ip3uXk3oGC9nWa7KIeAU9MAxp5nzXLOO9gFdscHLg9SXtaLqRPqCgp8iGU7bURfl/TE+GRxJaLjaCVM5mI/z0vlSM2GZyzD4qaTLMBnkLCJycx2nmezhP3aKIVinBmoE/Ov+ZICGyoPcp1J0bgoZM6f1S/9pUt6JnnFIbKkDWp4IfqupHdUsfsB9pTCOLrgzWMmXBbgKgOTtgCEYcybFn8vWQtjD2AcCVzvWuPoFwNKiByxtID5y2qEl3L/e/ievHK1Lf2eIImRklmKTmip7T+Bdnj1IXt/tLD0gHlz2gXgtBTftm1nz5hAJR8vv7D0eE3tt1pFTeR+HtYJOKHx0kXqoB5xArLGyB5ZORZGxZZ1Y5KnSItAiXyYHoH4BnZPTFlVBGjpVbM4kX7h/LCzGpK/h4FTaBMXdgvqzwnWytHiJVN+jRR4DggCO7i8BMO8rWFLu/gbqGetrHEnrcuow6I8ZW6f7iIyEfoHdIRmn2ig+pF84Xetj3dzDxzA7e3RnbiufIs4NtG0yqhjnxH7ttwbtJ1WqzlcGU9X
 ezCJQFKn
 wNRAUg/ZR6XofNP0iCuDCwDHHoBb3/wLOndkNMUIURx5ueI9sRnZDqOCRh3hJifTEBQMH7u9nG7BbgIiQJIcSlC3ELEHPWT5RwAW0+yJMLi6t/57kkz/8KNYIDFiYiz/zM1olZVdaiATOHXlC1PQ561uO6NShmhG7TZvSIjJhYin5smlhFHLvrEg5oc6yX+0wghTHmRqLKMreZjz7HX3j5IUIsTeoAYQuqUKiTHprpelU+OJRLL3pGwYBw5i7xi1/oHKFq1hz1ynSf7wDw88hKt+gBNO+3GHdk3/nNNmzFAhSEbC3KohPrr6EYNTuQAkihLgBQOkWgTkdt1DSiW/zRJfslJwK6ngenrE8sRIqvJuv+LDVARrGkGkvsrD9YsvOdYwJXRGUMODQmA7ksmBJT3KbubThIMoc72XroDCJelmGsFVaIn+Pcw0THXn3tpUh16QKHGs+3jlPvAc5O+ZrZv8pWtKcdfKlhbGnjd7EMW0zoec0209aMaTLSShA5qWh/yxCPJ5BV5OK+bfEacuAwi9QprwGaqYvZYRC30XrXS4Al5k+/60LgsV92P9KeuvWTNvzshASyrpr4OXJlO/7S54aaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 04:43:25PM +0100, David Hildenbrand wrote:
> On 24.10.25 21:28, Gregory Price wrote:
> > We presently skip regions with hugepages entirely when trying to do
> > contiguous page allocation.  Instead, if hugepage migration is enabled,
> > consider regions with hugepages smaller than the target contiguous
> > allocation request as valid targets for allocation.
> > 
> > isolate_migrate_pages_block() already expects requests with hugepages
> > to originate from alloc_contig, and hugetlb code also does a migratable
> > check when isolating in folio_isolate_hugetlb().
> > 
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> > ---
> 
> Nit: trailing "." in subject
> 
> Acked-by: David Hildenbrand <david@redhat.com>
>

Hi David,

Do you think i should just staple these commits together at this point?

https://lore.kernel.org/linux-mm/20251009161515.422292-1-gourry@gourry.net/

If not i'll drop the '.' and just resubmit this with tags and just
update the commit message on movable_gigantic_pages to reference this
commit and your notes from there.

~Gregory

