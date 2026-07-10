Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD01C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85616B008A; Fri, 10 Jul 2026 17:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C357B6B008C; Fri, 10 Jul 2026 17:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF856B0092; Fri, 10 Jul 2026 17:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 892166B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:12:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 211711695FF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:12:16 +0000 (UTC)
X-FDA: 84974115072.30.06BDD82
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5510C1C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:12:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=shmoEbks;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783717934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pf2tO4nh1364RXnPDWacirAQrZ5x9Oo1qInEIWqsetg=;
	b=InOmLL3VOXhwuYXt00gbDXwqOKuKe/WFPBUAGXX+0DElK+lEKP8h0AjFe9cSRVXWP4jJpT
	0Dhse3Wg9/smBU17a7Bph/+gUHFX0aoOe+gX2PbOiFPwEUw8KDxSL2eTmQzkKkbK6dxt5m
	h0ts4ks5uuMKvVg88vv/nD45frzNl1o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=shmoEbks;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783717934;
	b=W0Ygi439c1zferd1+4P0c3QqGTCf/60z5yimhy+np0OLt0wdwnJyOXAOooY8Pd6EhG7ed9
	g+dk32zpdqlPP/U13l2qVt4EMEYGti/ugkfA8VL2VVRMFmRji6DKbMN9aEf0TlvHtCvyeh
	n+6ILSfLHf6BAuu0mwCvx5ezyzDbKFk=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e5b048375so67380385a.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783717933; x=1784322733; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pf2tO4nh1364RXnPDWacirAQrZ5x9Oo1qInEIWqsetg=;
        b=shmoEbkspVfDBBq+QBaqNyndUIhpdphZKmKru/+HMrGWLHJmh18LA842ZEiyL8mJj8
         3OhJwGVtTBU9G34aZ3vI6ZHVD1YTFT187PT6eFHcorKXG9F1P2qy7/QhfipPgfZ5gL4y
         P2mU5L0ITGvwaQ7fVUd296VIBEM4a72JjGY0hA2UN/2W5MiOVFN/9BxliNlHeoUtPbDr
         E7BpLNhzLDLKvxy5aTG9XvDaUOghJ7tZA7BJ8vYdmJ1qjHjr4Woeh0NzErDxaLLHZ7gD
         De//wWgjhTpU9DZuSDPE8IGxQ+jf+Tk3Y6hGnJxuv607ZRtLQ6BS4JniFI8DM+1c1Gj5
         l7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783717933; x=1784322733;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pf2tO4nh1364RXnPDWacirAQrZ5x9Oo1qInEIWqsetg=;
        b=Fb861p2MYqswOBDXD4WUEdOh1wpDu6jV1DFF3Zx/zfF3PxrZSu4lUQukyUuM697mrd
         T76fSUH71tBZ7AxQazEiCeKfwwCkvcouhNzsvzJvzcOP2fFSOkbx3viOxgYwjoFtZkuA
         59WuEiGAMGYQw19T6Fieekisa9GwFsxaut8+ZWam5Xn4At+aQ5pOs9JR1Hdc+sLunIs1
         IkhEWL1NfGqshaI6ShTFXeCoQSRcj6OW/UTd4aFRi6Vah2QiCv/pBAGeoki7X/Prl5EL
         17CAimZgzKUehxAHOIO6PIS+s6+sQuRxSTXssXGTwXl0Sf0ljCvDOrjp6sQEiYZXWsUA
         5y0Q==
X-Forwarded-Encrypted: i=1; AHgh+RqsIVIs5Fh57PW3ZqdQfOGK/D8lxcGmuBW27YscRa2mwwFA1pJdQvraac5+8ADEso71HgGukYeeqQ==@kvack.org
X-Gm-Message-State: AOJu0Yzxqyb+Ym477dgdZr9EPqMFZXP/1wC5IHNpZRydrWZ/M57Db7Ih
	eqYgZPxgW3hV6KNThGVbu8U3rvARmgASHgPIqjKHCEi1EbLNOMDaSSMW8J1+Ibf1Xnc=
X-Gm-Gg: AfdE7cm1yMEjJoerw9Nii8bfRIao9HBSqQGHxhxg0t3f/BzK8liboEjQjWr+EWR/0I5
	/znkMgdl6tiSdZxDKPxBlS0DEnrBfHKr9r7tOMS9iJrm88nl70hudOAeQFkeW1kPUvJ0VMadpRf
	1hoE08M8pbF9RaXc+krSQZFuCzJmfEzLeaH+pUIqk4BydYD3aAeZUE+x88D2NjRbWMuIs5gO58b
	26CrFrI/+nXz+N50f88xSC6OrbHbGtr9Uq8xCGBtz+21IqGvmB6nPjq282xtD2Ykh5f4NemKEZS
	jpXzuVt1QWkHdy5CvZeUSjFHkyIG8sS1Qldh505Rw+WtaI8bRaOheY1WoIMoQZKClYoLcSTrO7S
	XVTG2A1lDNNE/l2toGeNV8rpIpf5PAKzXEpmncc3BUmmCdDFfHnzizXMUa+dyBToJyurtAr24x5
	VDpKpgSKtBhObUzl8GKJqwwDg2Ajr6AcZgwVLRHuMQAXsiQzWhAfb4Rnz/23np/2u95HqI
X-Received: by 2002:a05:620a:1a24:b0:92e:7c7e:9c9a with SMTP id af79cd13be357-92ef2b32433mr108915185a.31.1783717933240;
        Fri, 10 Jul 2026 14:12:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5cfcb0dsm290194785a.25.2026.07.10.14.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:12:12 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:12:07 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	iommu@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 09/33] mm/rmap: parameterise
 anon_vma_interval_tree_*() by anon_vma
Message-ID: <alFgFakGEcg6hO6E@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-9-2a5aa403d977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-9-2a5aa403d977@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5510C1C0003
X-Stat-Signature: p9fmqfrwgcd8cj5jaurcymdyrye3e9dq
X-HE-Tag: 1783717934-271117
X-HE-Meta: U2FsdGVkX1+eZ5w6In2+PNwoRHXpq5tRNZ3ISN8bi1UwYs3mMe/HSSez6fxXPkG1PRu/3Qqufu+HquxQN3SerHGMmVp7NG5SxJlsFDh4nCsrx4vhePzMPb3H8aSfWZpE98qU2tSQNrcq5RmQearOJ2lCFPZVVIBuuvoIKZ5SC1Yr4pdCS+j4YNdExN7LosIj4HyK+oRqmOVSpS8VZoxc69xTK/WhpW3E3WRTy9HirX9FvyGnubJiHPJ6XCKjWBkbvwZmNBb9Pzdzo+EVBfVfrwuS2trnboad2BYYm9kNJM06W2/163rpUhEAJBFRp/guUyoGW8cQImTXsUQ4PPKhfCsvTIJzhnU+pX2l6UjSl3kNOP2PV134uHJB3GHLBS+OcGxSm5/cDucE/NBxUFkYYEwfA0lm5xajAzPN7xldkhnkQ6WDCBRyL6Q09yGShl//QsAsGYpbNUby32y6uqxa8Pc3Gw6U9orEPgDxZEwhc4Z0tR1xS9GXP6mZKpmnA0RoaUQksBZsU307DZ4TBGeU7UQdLZwZRoQ7L70tga+I0pFSeruFosPxlGvN0tbqVMlMPaRrZ4mxn2tMeofzPupleV98sSXIls0RR6AAK+s/eYoaNlGMvPhjNtxHX14I6PV6n+U4dpYyOUa64qoE9CltV1Irb01hbn/FxE0wqSrnb6bkwduugZrn5Szyb7JchIeQqIWyrMQEMo6QrnmSjfO4a86AS6xd38OBTU7fTu5shAOiiIzcFGdCw2TG3cXL+VDVre2HzpzJRQeOUaxX4gVeguCVEkFrLnwuCgFDk8NmARNxkZRU6fJ+mKGdybfcnzF75G9DeUNUoLbdt2Q0qxGCKmJu8at0A5y/pNumLOJTUCLBX/2QHuMLLLU3GpVDRndSUwcIwNRMOQAtmwhRUXzR8qbpG66epd55tFFeHwdQJ1EmyCL6Ek+TJYHnjzHvosMdBHZpRP2n3Hy9U7+DkD0
 02wXeA1e
 CVYUPphmGwSMLEezXkHqhUOmjnLoDtw/uVNTgKNEwJFoowE54cLcMo29poLwsQ8ZQeN7dJXkWH0qbwiILOMpNzMhGHL/6dliTQALL8zkzcy//QxYeIaPVqM8b+/JA7Ll5yo8QV6TjWq3rnNnq1a3a5c3yC6qPsuvhFRtfCJMHzL6uUaiQZ0+Yz1qFj1f64XNJFwukD3fLCMScDcfdQudzn5XKPryOQhYtuur2AzaFPZcBfNhO1+xnCYxo+zH1h/GoXz9E++zf6tQmDSFOJxQW7MUFXp3vHic4zNxJ5Vtcq9Gqei/2LaoYofKf8L0PY8S7MkXxMz7JP/ppJzofeXzCDerCXdrDkMM6go25dsRSD1ZUdb5s/gTCn3eGpphtkgzvMtsgUKNPq1i6zZ8t/PiTRHjl1Erna9m6jCEswqQvOMruFSZ1o1Xvo1ul3RBpST+12l3ZUDL7nEZd2xmLphxtab8TZg84wSE7zhtwvF/0qH+wcreghjU2EO3mR/sqUVEUL+LGVYXNsqIjBvEq3mWhGq1LR27iZlKKhF+nWxNa+oRtqzoXCL5a0pl67hq1udoN5uO9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:16:50PM +0100, Lorenzo Stoakes wrote:
> Similar to what we did with mapping_rmap_tree*(), let's declare
> anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.
> 
> In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> anon_vma and the functions can figure this out themselves.
> 
> Also update the VMA userland tests to reflect the change.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


