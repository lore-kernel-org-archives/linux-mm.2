Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C908BC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 19:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02F16B0005; Fri, 10 Jul 2026 15:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDB2C6B0088; Fri, 10 Jul 2026 15:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1F96B008A; Fri, 10 Jul 2026 15:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7C16B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:20:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 24A3F1A0559
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:20:52 +0000 (UTC)
X-FDA: 84973834344.20.F24D722
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5ABC720008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:20:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sOmo+Fx6;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783711250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFW+QIJ4JFkYmnZudtxzUHG1gsom4gRJfGrSXFnz7n8=;
	b=Kl+JLtyW19PSs6FBpskCZB01gw2hsUIpTB8uFRG7KJnqHT9lcf4LxoWrLb//CkPGnGR8aD
	u83qDhC0Fu92eyXq3FMA2UprVbklW3E4Ka8ExKxqgTkVk927PUeRyXjAPSliEIXMeyaYig
	eTppq2ah9ffP67hRJOaKRtu7pOnX55c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sOmo+Fx6;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783711250;
	b=1RS7bRvZI5GPCLpJLkRMRDI0zS6505LJjD6ac6YNx3uj60mpTvUnHecUujhJWkzCKw6VlI
	VZsgpFl21GiMuRlXKeyy9eLSi5bHn2j2ZRZ+yAH7dZTs5FCTmUEFwJt1rFRr6btHheaic5
	X11DPWekZjPx+uYy5dlrm7mO/rxlpyA=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e512a9a6bso63803985a.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783711249; x=1784316049; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xFW+QIJ4JFkYmnZudtxzUHG1gsom4gRJfGrSXFnz7n8=;
        b=sOmo+Fx6BW4okyZCWzA3TRTkTglGxJ5bLLIoDONVoe+27q4GIitVsjHh19NpC89lnQ
         wIO49xfXUvVAoL3PUEdDRr64J2iO4eBsT8r0vIc2uxL/bBtL3XvsAULIntyYfdBEpg8T
         4EoqhJO7snbfvnzFv/cW/JhW+v4m8iA6XKXd4bi2i+6vyURKe5y6A0qHcBVqQfddUCAc
         L18CR3x8FT3FeAvLBijZs4eao84JfRmYzUgpjmNZlKgZKagnXCgdio/f+zV1CaN9itxN
         rECMnxbNZkkW2qFW/nyBIpYG+djrxa51X7gNHc4IhCLgxP/8FLz93lSCyOCeFvC10fDO
         VMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783711249; x=1784316049;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xFW+QIJ4JFkYmnZudtxzUHG1gsom4gRJfGrSXFnz7n8=;
        b=bbhg10aS/67EfyCmsWKeh8Uh9FaxBMnuNY5ezZg0UqSw6FTDXUh1seCUxXxivpqKlQ
         4gWB7bd11CbvOrVVnCLNhDzTJTHQc0STwsY1/0GgjVs4z2pQc/TxhsvzPU50t9M5BRCD
         g3fU4T6AQMchu8OIep+I52eQgFIvBhdaqLqP56dJCVs49vWTKVZPB4ZFp6zVdbvz6plA
         O5c/l2RFZUhy7PD3uiEKH8cQLLZmRnuKhH04YoweVUSRApU/IlPm02WTl8glH2jXq+0y
         hVv9VTTCAriQStTZKopVHE9SHHvNmrJleFsOuQTtJzXzD6hCY8nwGjWi0/l1TKfwf6Cs
         jY/w==
X-Forwarded-Encrypted: i=1; AHgh+Rooo9yz6bLoJBQmYs8AJ8VV2o4J/p7RpkKGKhdSEV6Y7Ni04Qh8iOJ4iXynkl6LgNGgiAnXJQa6dg==@kvack.org
X-Gm-Message-State: AOJu0Yy7zrN0FIYiVERsijIAbVvfQ4TSE2+YjC5NyZGRZhh0SUeqN0PH
	x0Iq8IxrxPYLH03qy0PJum8kCRQgcooOV8v2hgVWtBvcEjUA+ma/6g40/RTzHCaUHoA=
X-Gm-Gg: AfdE7cnoXZE1J9DiZD4YL/CYJK0G17lskfRyqTQxYKTBA/zikWlXq6HlJDZd31Sy8y7
	0td5s9I4xLLNp6AMc1t/2GnBRWUdQqaF4OTnzfXFgvF04/UYnZtbVdfCo8n3n/ts2yGIINb91lY
	bj/LxnfILXKPFmS5nwFNc1XpuQrKkYPgV+4zoBNvzZB8dSZyJCd2nKmOYq9IIIHJw7qwbMvKEMo
	n+hPLRwkuib7ehLFOFhPrbkBKs1LxyMvKvXHxkI19sv0opsgDHozzN8YbgV1YCSO0xCMWN0hPgW
	EumQZyDgMOAMQod/dp0ut9xpUqcE5UkbP9FdBVZFuiphHusH8zF9931Mjf4JpYFCJlWaL+CONq/
	cBtH1bI1xCwXdsCKdeu01pwcgT2L9KdAitj7oYYEVXV7hJmFAw4UAQyuo5XzMBH3Dx01ed0pD5d
	W9kW+NCIK9hiY6QDu0B8NquTw9fkiMY7jhq9cT66k5axEv/jLlU/4jwIJHwwoHJMlai6L/
X-Received: by 2002:a05:620a:44c3:b0:92e:c117:5ecd with SMTP id af79cd13be357-92ef2d107efmr56266185a.77.1783711249227;
        Fri, 10 Jul 2026 12:20:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5b8b3f2sm268883885a.13.2026.07.10.12.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 12:20:48 -0700 (PDT)
Date: Fri, 10 Jul 2026 15:20:43 -0400
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
Subject: Re: [PATCH 26/30] mm/vma: introduce and use vma_set_pgoff()
Message-ID: <alFGC3Vq-sbf56lV@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <37f4d951897641f304dba26f6f91ade03a50eb01.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37f4d951897641f304dba26f6f91ade03a50eb01.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5ABC720008
X-Stat-Signature: gd313xya1pk19qhkw64kga8pbuciuxwm
X-HE-Tag: 1783711250-590772
X-HE-Meta: U2FsdGVkX1/ip1Enn4/gKzJReGRnsevpGxOjIC7Ih7fKfYsSMP/DZDBQM34cvRAfJ6exyhcsgzoorDnhcu9ickNb8KBoOL1PoNlD/jRszn1rlKsEeyFp3A+XFRtN9mdZu6n8/kDWlEF+ymU9LS2ABgbLvEouXYEapN8iubF9fcGceLF7dbWVVQMzSaulbH2mpojxsgXa6svf6p9qNogmRGI4UcLWMMd5Ylo2h+r2Jk4pQjgnyq05ZvekhVHuBiMmPANC+W1ATRNtCH+3PZJPXQHDup3GdEIUxGrLGTCA/18CXCr0Ipc6SCZ2yZME3UtNHlhGUhs+7QevAfCofH6jQo5HinZTtiW0u+c6TIkGzDWmrJZJ4m1wEWYVFuRhzOV3+8WC8MS/0+4oFiW199WhlCoT7mLYMTIhGpsXr2wpYGrYS156lVi+WLnl0v7ylZWOpQdWyj+NbnIFWglK42O4FjBigWInxuqeE0g+/k455lLepdAtcYqY7fDAe6+eoqOspQgVpbWin3nit8NqNRRkh1SATyvy/bjbu2yHx6Pqh3bYtmcJ4levtGLQBwxEVkyqT+205Hy+hwdnuCBBneJq4g/tzKTUkeOUTboimeOxMDOkHYabrzdpjBY9/B/D+ls1fAGRhfBu8eJD7h0EcWynPkC9MLL3TKaOWw9SnWsmZ2Bv4utqn+UVWHvRWrB55u/tmjZuQeP6ib2TfWAtyN1qzPBH3mC0FSmp8zorOwwrXJGO4PVQ7XzBTC/b5HLRxlVxrJ2F42m9JkSW2RewO4eTgihuPR8iN+MHcqfQGakpduUR+DrG2fApDVnJtz+6j+nbkuWC6pCN1Cre0KnEBOb5TqPbdyGdNOCwJo8JE42/bpZbWQvlg14SkYwCWz1IiTuZept6e5HXnachZoV/nhFMAeZVTT9LWUDgoSeJrcaVXyKsSskID92RqOLAALV5c/iqPSAc9PONC/H4ulgn/T6
 MfoaVNDi
 7FrH8Rs1ZnX3iVCokZkk4XebPpl+shRUWHL83peAYhy2Qf3sK5sTrXPwQQNMAb2Xzo/PfPGUT4uzzrtlJE1nVaGIZqua5lgnYqvd5OaFkqvR2IalNnhAqNv9EAa5zcI4G8PJ1EwokLlSqgT1UOpBnnty4QRQE0dsDItNIppd/Ctjrsmhaym98yk0e4TvZOuoWglAdwX539Y0iNzPk0vlD/pHhbUXeM223xMRQsWB6m9qF1SdtyuyyKurGKDu91c3GopjBE973TrTjMNpLAJUm7bj5yt+TF3C1DAQyQN8YMpEikcHp1m3fSuR0hNEQ4gFd/C8FHx1S2de9COOzfBRaj2fA02IUHpj3lOoIxLY7k9aCXDV8MFdrAXAMJc0u2/o0WxAq2mi+/kq1Twf/MzCZP+12Dubab6YXmxKlXrg6pneOlXZhtpUyNnDzxe2mkeFWGhxfGyIQ6F7qF1XJSw1O0Brl+bi8EkWYs8DprMOwlPq2xG6B1u98lhCzhA/Pp1jrV2RpKLh9V+qw3zE0egN4Ck/ZJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:37PM +0100, Lorenzo Stoakes wrote:
> In order to lay the foundation for work that permits us to track the
> virtual page offset of MAP_PRIVATE file-backed mappings, we abstract the
> assignment of vma->vm_pgoff to vma_set_pgoff().
> 
> We additionally add a lock check here using the newly introduced
> vma_assert_can_modify(). This asserts the VMA write lock if the VMA is
> attached.
> 
> We also assert that, if this is an anonymous VMA and unfaulted, that its
> (virtual) page offset is equal to the page offset of the VMA's address.
> 
> In order to maintain correctness given this assert, we also update
> __install_special_mapping() to invoke vma_set_range() after it's set
> vma->vm_ops (which determine whether the VMA is anonymous or not).
> 
> We do not use vma_set_pgoff() in vm_area_init_from(), as at the point of
> forking, we don't necessarily have correct locking state.
> 
> Updating vma_set_range() covers most cases, but in addition to this we also
> update insert_vm_struct(), compat_set_vma_from_desc() and nommu callers.
> 
> We also update vma_add_pgoff() and vma_sub_pgoff() to use vma_set_pgoff().
> 
> While we're here, we drop a BUG_ON() and update insert_vm_struct()'s
> comment to reflect the fact anonymous mappings can be added here.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


