Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7146C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABFA86B0112; Mon, 29 Jun 2026 11:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70806B0113; Mon, 29 Jun 2026 11:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939B36B0118; Mon, 29 Jun 2026 11:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5CE6B0112
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:54:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F35BE166FE2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:54:55 +0000 (UTC)
X-FDA: 84933398550.11.2394ED7
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2C4DFC000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:54:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rhT2bUx9;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782748494;
	b=5o762PUk5npOAb7grkc9ZQmUkZpQwLo6IXF88QYhi3RjIrmFKS4Dee1qEBFm/vY/ImfDVw
	ySsaOAfRkv+Wt2Oi8L0GVwEWmWXX67cd0TuNTmEEvngaGUZbQS81sbY6IJ1wz7xRzWLm6u
	Dk3veca9l6Qvtftc3ti/F4+1GwMuT1w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782748494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4r3nyg8MsZ+G0ckW9OOGJtlL6QAvCNLsDtm+wiwuKtE=;
	b=C7b7h+6Qvoy3Wl1rMcM5qZJIQJxIMyC5I+tR5KGjVRq9zOttcC6eh1v0FYDPesQJ0BgSVj
	PyOzIbNGv52ivIYc9hg2tmmQVzUrCwrwQS8Ac82P4LAV/11WvnogOHHbnxGkjnq40DXmwb
	0Pn+FGAc7Vc5yO9vXSOwfOffqV53TOQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rhT2bUx9;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8eec5dfdb65so9350676d6.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782748493; x=1783353293; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4r3nyg8MsZ+G0ckW9OOGJtlL6QAvCNLsDtm+wiwuKtE=;
        b=rhT2bUx9tLwKen0Uaqb8OqyWiqMpJhhnirimTkeuhCHHufyb6EyxUNVa5Qx43uY35C
         6wtUmUQ1G4UXQo7RUK5sd8zGodMTzc7E90xW8YRHh3gI+PVQnFgTAGDAcMt23QIi1DmC
         vvXfkoymaIM8ZHuPBy/Ni0GFFO3N9ugNNGCxgdnR6ZFR334mhHa7+EGjMLt4WzZSWnTP
         Mc0OIuQiD6NBTCHkuyIM3y+QS+BL5pt+Ios1Ccxr1SNAVeNO1ewCJnRk3o1gGSOHsK84
         iiXwgTKL+B9DcEjZS9tMVTIxdzlOUnG99nQEp6myF8nCFKnwJDW6ARB3MuqHhrrexKMe
         gOTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782748493; x=1783353293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4r3nyg8MsZ+G0ckW9OOGJtlL6QAvCNLsDtm+wiwuKtE=;
        b=gSn2asXiJc56xfMuSWvcPVR9cwrk57x6tSo7ikSuoi2v2csHCWD10Nq2bxXKdK+wCU
         Cn3PrfHyRl8XOY62OvrzFIRIxzTyR2n0f+7ennSOXvFfiTiPmrPVVJF34KcUVQ6d+Ok/
         Ngu0etrfwVUIvtWnVFdalZHIQfdegG8Jr84JlxuTbX3UUxrHS6pxdL1XH2QMNQ3Xj1BD
         JgiDRoIUqhxvJXiDEVwIbEbVl+y7X5hlwJaCjn/Emf+SXTFPhMH3v0m4cnyZkqByhYAW
         t68utiOKVloO3dv1rL4MVSOd46cCm+D4PQXrJe+hRT+aaFNDRkniNXn6xYzUXD6W/aR2
         pNgg==
X-Forwarded-Encrypted: i=1; AHgh+Roy/uQ+Z3bWAUwv6h/Hela/s21RdPjHlNwUHPwE7WBLRRHHf65KGu6uhaVB4chm24r+gf/Wcmjv1Q==@kvack.org
X-Gm-Message-State: AOJu0YyHXVR1cJzE9mjCjteDdrAq6wNVeAzNUyCd5ynNKBDqeE2KmN/k
	nemBPR425lTJiT9tLa7jeslkDlB17VGqzTpqLkTdvfzmW9JfL/2AeQjxFEuOwkTjl9s=
X-Gm-Gg: AfdE7cnm11V993kS4kO7gXQzTvjgBohtex2SnF+wunhO7TReYkLSAVmA/RVZn1ZKMl4
	rE59TbcWWT4hWcSmzEKmorc8FYuCzDrXDQpcMoDkxC5A0J7ytPnn/4oX9OP0MFHEmH/Q08nuch8
	KBo+88wFduXAzJInp7SrqCzBRX88ec+yvSyOCQGnJXewNIWuDb2c3AzDjn0ojCWERUAgqTiN/Ot
	ib1HCuDdSeUsUUrdZPNpb7EP8QkI/pNzff26nYaXOy0ShYhfeId2+8ZilBJ1yAHJaGVdimvifFg
	vy21TTr90G/irC8ZXUglus430TN1BYss55jcUm1pkRswJrpg0FVBFVJqYUtKRbewEX5xMYMvW/N
	mKg8Z5tTrvXJCdVpIK1cKCbBHZNwbvrW8rIPdGLYH04i7BZ+NX2HTq4F1+3/TdgrUBvvP/AIeo2
	c/xPb+Bus8+wqQmD/Ey3R8vVYIgb8h8yByDonlGKIuuJgu6Zn4uAiAmbjiQGackl29vHcDrHfA8
	FnXfQ8=
X-Received: by 2002:a05:6214:c65:b0:8f0:5b55:1f6c with SMTP id 6a1803df08f44-8f05b552223mr58558406d6.43.1782748492988;
        Mon, 29 Jun 2026 08:54:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a26f1b34sm1726396d6.3.2026.06.29.08.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 08:54:52 -0700 (PDT)
Date: Mon, 29 Jun 2026 11:54:47 -0400
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
Subject: Re: [PATCH 04/30] mm: introduce and use vma_end_pgoff()
Message-ID: <akKVR2wNSjbLDt1-@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <e379a1cb6a897126ad96e3a263fdb91d6c11f6cb.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e379a1cb6a897126ad96e3a263fdb91d6c11f6cb.1782735110.git.ljs@kernel.org>
X-Stat-Signature: kkchdaojm3ouwomcd16g6xka65a7phjp
X-Rspamd-Queue-Id: 2C4DFC000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782748494-137308
X-HE-Meta: U2FsdGVkX1+eWe12PfTcnQGOTunk8CoExr3YbfEyFGp8TllDhJNeCduQuI7Pee0M23YjukS/ZsD6z2DnXBMGR0f6u5iDFX//zEVN8UmLzf05HP1OkCNYdOd/rVn6qY7qX7NT5WeSQhMQ1WlSQRObV25W872kVa7LLgNasocUro+4vMMww03RHC/cnwA1J6WfmQtrtPAaAmumSSDiQnF83WyKaBszLA0htBAW2LwPPmNbHM5MnToWJMZMG+VTu9pOPqraht6NkZHTGw1bJAkELqFdMl7SX3P1akK7t+f6r91eU9YQtzsDcpUyMMF2L+JnCyDP5M4QRycmRWC01Vz+Xsk2+LDLQRuS2ITdZh4cSRtoJEaHn/syVUZZpzMjUwWSqWGcrbtIV4GXLzh27ksUE0Dv7qXbgEgpgRNjWiLwqpoxhkFLjQFReyQCWfVM+xHwNnJdjFecG9S0n4XD0I0tmcmzBIjuXyRGeGYrkZ60TsTgeESw/3gPvV9hWxKBs7h/nTyTZNf3tGUmOwiiRWv/cttaswjHU5hUOm9gTjP9jTax6zFXcHDwUACRD/5csYVJWCvBOVdJBQGNmHu16i1tk8qKp+xIUaBV5xSssu1FDCMEf7m/lNoIr5kBOKXHRVhzJpFf7AIlk7F8Isn9OWLL73b7iiLDjpDUvzfORTpLP5/9VAZRiilVHFUVlnCxPSY1GeHvpO7YIsYvJ1LsQ3SusnAwxSAERi/JXeEFl8r59TAzsh6euqtC13ZmVDzUZsf+ppHtggEHQOhpi7P/HGc7dfd2ATPplL2eX3gP5BrMd55OFYX/EBF0bofzykfB0KBzQFbSrICmApKzm4zRWjDN1FxmUPlQ2xpgEIddpIrvdYk/qWeI+bgQD1L0sONlLg8B4JPLs9NBFPAdfU70OOJnBT1je6ztSmmhdmoMmmV0l3Ds+Lwrlg7HKt5IVDBHd55M7MR/p1ITC2YMeuXv1/V
 ACoR3H4w
 HinvcGunMqGZB2IdDmE3/5RtnCCx0mNo0ymQiTCaIWfZNfXjNAx/red9ckSoDVLPACWMEE7mHjJ0fGQ1xZs9fYqL4Bezda7eQlfxyqXlWwq9IzCSofp7NnJ62c1FjmRLnpFrkXlWM0WTUyJ9TVmfpj4frH0RoelYkYXGr8LTK37ZleFym15SjVWaGgIhPkiBEZs+Wm6Oeq93U/kHuyfZ/5alBYapCkg42D/cSlavyZeWZH+JbT1hcEDjPChEs9zNU7lxfibM1hVoN4Y0+i5JlrRu1Ytz/RP7pcjtFNw3aUFfSvgya4c9m0MyyBknepCkGi12PC/d2HIsD44zBecuOvyCi3g/W4iMs6VXrerBJvW5ZgGFHfJ+0YV0cBPFv2ZMgvtw5yzFzgpr/hH/HgnAplqchvnffawVj0O1KBo3V7bo+dEQGaD+QLW/FojZ3PiRUEW1La+gTYXxuDGBCuDSbxmV48M3iqeQPY5vP6/sfY/VDnhhqso0m9+0gfdf+JTIPqIdWHfa343sfXo7pPYs3WIBsbZ/qsmlq2858
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:15PM +0100, Lorenzo Stoakes wrote:
> We already have vma_last_pgoff() which retrieves the last page offset
> within a VMA.
> 
> However, code often wishes to span a page offset range, which requires the
> exclusive end of this range.
> 
> So provide this in vma_end_pgoff() and update vma_last_pgoff() to use this
> function.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


