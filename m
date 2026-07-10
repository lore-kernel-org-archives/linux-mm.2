Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 246D8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0C36B008A; Fri, 10 Jul 2026 14:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61BA6B0092; Fri, 10 Jul 2026 14:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D6B6B008A; Fri, 10 Jul 2026 14:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3C0E6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:55:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4ADEE1C3CBC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:55:58 +0000 (UTC)
X-FDA: 84973771596.23.A594FD6
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7DAD020004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:55:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Pa3CApRL;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783709756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35hzoYcsWEd72Qin3ApbTs4xBItRwQ29eotWM9K9y9M=;
	b=2Ss0simGHTItz9ojruv3Kpv2G8UELpzFR+T0SPazxeLGdKJVaz640PE5znOCDrgkIJCO9H
	iiX/uag3vKxX5+gVQ2ZK8/9oV7v+R26Rfo+BbNiMgkzpFO+j1hs4rX5t4dODNKbzY3r1eo
	3wKrcUTONNBtxmkxq9OPMq6GJJ9zQss=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Pa3CApRL;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783709756;
	b=jzZpY3/x8bFZIRioiLssMBp1ZkMuzXlQPnxYIDSFKkk0lnn+W+1vm/JCTtjo+SjJHYQXMr
	0IAFobMMWVocjImsab8Y0pmD2u1QZxM1od3umP7+PLKvbFfalypP58yJahjXPuq2s3Wi6v
	VrSCUcbcYnAek9+ikIldxiQ+CO/Gvzs=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51bfad59921so7789921cf.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783709755; x=1784314555; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=35hzoYcsWEd72Qin3ApbTs4xBItRwQ29eotWM9K9y9M=;
        b=Pa3CApRLxnYbBC21PX6JGNv/GJyDJkeOzzip0zrjDzyerL1bcDH2hSR4gARDN4V9/i
         qvOJLBCHQBSTWKqXipbNtnj3XDDWU7GRjqaFANPtqvGENWsNclZq2oudiBt7JNEufbPk
         GVHwKPHCD7M+Q/MzRaExIOxwRx6RBJ29xn42WVQgiG/jOBMan66lCeGWd0Tx8tkZobHq
         /aOsCfIypnPpUhH87NK0FLan5h6c3IYQRxrqSYqnWkqac2N2LPb0SUUsuKvpWMpD412n
         Ioq4pvpmCms6eV3RrLP0WH2vCusxXLy8tJofx78t5Q8eObjU0SQ5OKE8McO/pgIRBx6B
         gEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783709755; x=1784314555;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=35hzoYcsWEd72Qin3ApbTs4xBItRwQ29eotWM9K9y9M=;
        b=WJ/WtJSKxP4pWTUm6i4rZvn+JEk1TCji5TqFO8p4hc7iRZcBN0J9n23qjTvyfuVYk0
         /YeyhQ/FSvelYvpVyTyjOkgL6rA8DSY7/sqzUQD/IkaCyRYOoTX/wSJo87qKsnuSOicJ
         ZaS8p77Qyj1x66/BwLsqR4Fql6Kzb5b0HnhtVsYVzMCbVd60GoxKzTGyx4Lkh52hISe4
         Qc9loZqNTEbhpBZPD0xXoazzYPaJ3IaadghQvHs5U6KZiK009fhn8NiFMGaBpXU+DWdO
         fc0YBqYVhVNFw5b1+CuTMW+lea5A6FCx1wW3k7Tjii1kyDwUV5pyAgmjKEKdISLfHnsj
         XVkQ==
X-Forwarded-Encrypted: i=1; AHgh+RpewcH3u0gYLEoAgyZjoMYuFM2LdMtBSln0BoBqA/1TUwyp2gO8M2Mh4sZ68ycTs6qeijy+a3+Wvw==@kvack.org
X-Gm-Message-State: AOJu0YwH/cCJEKHukRENiCJ1koEywkVCHxNJswW0cbBC3L44rOjnG1LO
	mkCKiBDrj4XZ9gKbFhkcAu6grvXUYKIBTXzRXeY4DF2+JSlE27lh0PC7GeRNNkufL6E=
X-Gm-Gg: AfdE7cnsLC4kOkHwThV6k6O7pSUQFrzO+MV+87po5X7Q1QIr/PgvPRow3hZcVOjDei9
	cYFl2aL8iIVCKzS+ROWFX0b8Kib7FqHMljYOg6SLrYo++THJ13+yPcqChSBO8I0uWQOST1/f5NH
	rZuRaJjOyYjsA+Exg2nttx2fW2ZrsCQXoW+vnXJcsqEx0cLdNUldyONhnZH/TeCi3FL9lfZe21y
	rUPyqoSwTnATTD1PupXmnNf0B5Yy1FxZxvamWVUMpN8BZnWoX+wH5AXYqllOzQG2hXlHYcGO1FV
	XYFdA6++/4tbZRAP+T03LIleKoRcegmtaqV3I+sNU6zRD8LtydTs9A0U5zja3tkAdO2q+dmGREd
	eIjymFweiHrz54gJKaTFaKSul/obVZocfkpG6PYGy4CCNgbpirGenHvjvBw4TNxKfW/p0/l+pJ1
	YoSBPqNYq+xzlBI2x/7YBSq42MWIPK/akNe6fvSMkAtM+Q5DirRyUDXODchtZl/rImYZw1
X-Received: by 2002:ac8:6112:0:b0:51a:f94e:ce51 with SMTP id d75a77b69052e-51cbf1fb386mr1548881cf.50.1783709750657;
        Fri, 10 Jul 2026 11:55:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caace31a4sm22925021cf.12.2026.07.10.11.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 11:55:50 -0700 (PDT)
Date: Fri, 10 Jul 2026 14:55:45 -0400
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
Subject: Re: [PATCH 06/30] mm/rmap: parameterise vma_interval_tree_*() by
 address_space
Message-ID: <alFAMZNiJvxNpzGF@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <43050b10b53cdfc3627440e6b14ae2a9730b2a5c.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43050b10b53cdfc3627440e6b14ae2a9730b2a5c.1782735110.git.ljs@kernel.org>
X-Stat-Signature: rf5jo5cqeotsq18fpgonsjortpbidcuf
X-Rspamd-Queue-Id: 7DAD020004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783709756-269351
X-HE-Meta: U2FsdGVkX19Py/n/anFcGi4E5hMT/jQZxC5d/JE4vv7R5uplmrUEObe584z5KoY/gSR2YJsfXY4nzR7K/kDFzQjsmwz4ENQjjMpxqPRQrAK6IeMOvX8gwckfQNa/KKV8JgUH11z4ckrq7MdSabto2IC3BbEI67Lr2F1J1CxPIMk92fNmKqD73nC6UBi/omwVXHOmVOQXkRYo9HDzSJzdr6OHEXqFpKEIdBegE9w0K2zpMrB+lIiMcXJQYvvv/FhuKVhIr3iJmhjjTjvRetHc4S/hYdlwRvBZAQER/ku5UKLV+B2u/VrcvVMoTG3dqahd/smZ79uUMjJ4sVEGipvcXtlNms7grzVz0oQBJvvg1uVWVQMW0m0i6Rq1p6gFwv+0uA5FFJ/lwy8K8bEeaWuNigfOYI6LBWgH5sRHB+Ht3/CLUai3WJX50eMUBHdZJvMdutY+3wCd8DIngXapn282wHwygqXOCTghp9S5OahkLrlZQytXhXH3kNGfuplnhfgBOLilR7ocbpArnotkTjG0kqwIsLYX7mJBVBD0Og5fCM0oetawqgHKEX9/CSxiBClfoYur40+dX1XlNdH9iqLIDkcTkXRaeTlX0tJh/RbarXij8mw9crbPdGXweMzh9UvEmB9t1WqzFQcK0by9DsZzy1Pff8qEl1HVh+RxNCsOevWHMRFjuHwemD39vL4VhVDsVp/dN31luX5VfWoF8eDQL/gj/CBHQVYewp/UflOUp/NFmvvxozZvf5dkJUntpKvV0zufmCWS/KCWbkbaT2qGGYHgjOfJB+3oWQAgvBowoONWSP1Yz7EV3xH3xYab7XoWT7y0EbYF4XD5uSqlcwKskMqfmM9skiCENy31kAphxh84ippzUAFJWAn5lzuEoO34/UlVeYGwNoHSAdXYmVnjnJyBbstSDX6yu9NxV+dM/CIDs1RBXummJac2UwUcvoxfIpVAlueoBSxdseDkpKF
 JNRztAiv
 oT6Ziwe4OntP88CmlM7LJCRZlct82jwJi3yNQBOD2RQwhiKkKE8NWkRh0B9K89qmpQyrZVBzDeoQ2poVmxcdYkI5PiWOo9p1SehnhcopMriMkfWJBUKyGiuQitALpodIbUIsJESAgdE2l9dhifYZvYGX3c7nq6jMrO7HAdBPpPoDQKQtzplv6/vVjHBZPfFReI+TzkO6SF/xAelbz99WhL5vHYKEtGrz0MOZHot10noMcMECWWRI1KztApZPPbbd+m6tGVj9r7A0Z/SVLS/OwpNsE2j3c6OD5z5tiKxaF6xbmRyx/f8niJSOeU+kt60v5TDd1ZwZNzkEsaU6NutBLwzO18KqPSdL+Mf5COqz2vGfm78xNvXFoUNra5p11PRGERym0J+44XT8C7U5fuD+ZRv+8m0O78zOlVYSmveEbyM72qFaVH+0U45o3Yw72k/EnI4IpxW6ZfkijDL/cg0ryGJBCDLpUfOEj5ij9QmjXT0SHdDwVurl+hITJUJG4TYbzZ8bTS4rT9d9a1nNXCxOYUUsmvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:17PM +0100, Lorenzo Stoakes wrote:
> The file-backed mapping interval tree functions vma_interval_tree_*()
> accept a raw rb_root_cached pointer to determine the tree in which they are
> operating.
> 
> However, in each case, this is always associated with an address_space data
> type.
> 
> So simply pass a pointer to that instead to simplify the code, and more
> clearly differentiate between these operations and those concerning
> anonymous mappings.
> 
> While we're here, make the generated interval tree functions static as they
> do not need to be used externally (any previously existing external users
> have now been removed).
> 
> We also rename VMA parameters from 'node' to 'vma' as calling this a node
> is simply confusing, update the input index types to pgoff_t since they
> reference page offsets and rename the parameters to pgoff_start and
> pgoff_last.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

nice

Reviewed-by: Gregory Price <gourry@gourry.net>


