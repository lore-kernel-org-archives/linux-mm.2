Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFC9CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 05:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545A66B009E; Fri, 12 Jun 2026 01:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF856B00A0; Fri, 12 Jun 2026 01:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE1A6B00A1; Fri, 12 Jun 2026 01:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 259A16B009E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:35:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA758120328
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:35:15 +0000 (UTC)
X-FDA: 84870147390.25.A7EC767
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id DCCB1A0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:35:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=adnOBQhT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781242514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mAWalnkfq5iOPhyVkcUx6hxjbGEftgu1Arv6KFIZNLs=;
	b=3LlWyfszndHKxuhuzLIR8B8Tbqyi8mFdbTsiR1ZdQ9aF2f5Lf5Geibm7r8Tzy8R5BEErmG
	M1WOuvVpFmDtcg/oM4V4gF63BqCgoFj1xY1I+L2ksOqcOcniZIQC9dQP687CtJiVxTjriq
	n3v+HsRghEfOJRnsmpYYILG15/dby/k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=adnOBQhT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781242514;
	b=aEquRgv8TBm/39jevrypSFrhpvSEwXDxuMMXLU5Q7kXTHzPmd7Pbdvuw0QKYp+pxpl6D0D
	/i0MecnH9GcpWrc/pxL5e+Nq4PXARptqsMWUhNl7Pthpuhoa+tF1fgm9qzerH/GcuR+/mr
	EEtG1dViynay2OUsNWYL5Sv/biqyncc=
Date: Fri, 12 Jun 2026 13:34:33 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781242512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mAWalnkfq5iOPhyVkcUx6hxjbGEftgu1Arv6KFIZNLs=;
	b=adnOBQhT/kdwf1srUsq085IWW8dNvpJ4V3UBaXoDyMPUARhmbNs8c48lmte4qntFlvv1pz
	3O1IsLoJ4rZdgFiekGEOxmy14D6EE2eS71blAMyuGqiYDKPH5t1oq6pja/K0W/9tfErVgs
	1QVhuUx8ZCk9Ngu9+uxlB5Fx3h7xAFw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 12/16] mm/slab: pass slab_alloc_context to
 __do_kmalloc_node()
Message-ID: <aiuZZKDwYCshXPGK@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-12-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-12-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DCCB1A0005
X-Stat-Signature: anpycaifdix1k3gcsurgcckc64gdob3f
X-HE-Tag: 1781242513-497066
X-HE-Meta: U2FsdGVkX18Pen5MGnlFu22nZgTL0pgLtODGKlF4pw7EDSQ+zDSywekoDbGO2jSnLzsutUGzUg5zxtcOI7EU5Fe1yXQ97MnzUUyGru6I7fxPnjTuAa/zYoPLWMilUmjK74IHgEWUuwJvzhNQ6ll8L4c8eevhFHtUav1r86SssMmiabAi87952S4mVNse22jrTmvoiE4EbEu0XuGdHHYvKidlDFOEhiwhhoMwccEg2pHA7hvhGOW1QnSRDA2P/p0UVvKBSG8zDR+lxIuGjVx5gcW+I7JcwV6H9r7D+EQl3ttP1lChw9pbrfsnW4ZO4CyIghxhHoknYgbc3rX1XAGmbD2yODUDaAxxZEh/o3L037xuzWcnvNsymqzUXxwC8R7Y3Q4U24fkBerUk18+V0hURtpsl5Bt07a5z6WGRfNRl4eR2UrLpYeRpTKksAnQ5q9IfGFyXS7IQNg889a3ELG4rPAAnvpWw1UFhNk/mD1hfqthL8XF/SYZIA+Gw4XtB//d2Zz70YEtB3UQ3Aqigg5+bKtp5o2t8j5/jTXuoPUAuovQMcrNJre6mE5o3MNzu4tNygBXN77gGDk3IvnzVu6qEjwy5EpjFlPwOcx2fZAP/aZBTXvVib+0b/bIMUQ3NfEuXUeIvEYu7frKJyo4a0QdGwpQjGaiSeBkz6Ra/KAPlxQJ4v8HIcsYgHITPy+abQbr4coLXwL6ibpIFE7DRu7MyoxwwlS8w4easzZlQuXYI4HcTGUP1qmgWOSkXiaTWo58If7iltDRTVShxp27p8lGYVH3TVmCzQSdVF2J6L1EoKfrt2q+NxHz8kaDMVTj6/qufhYLuXfJwjbuuTv1E3qSvC6f+JnVQfSTO8Kre3SfJvNG7vUlAoxHDHLDquxr1gN3lk1ZO1gkRDwkZwlXRcmxUDgIt1V8haCjCe6InsIsrOa7ynpr5O5aMCsNHw4fIO9Iud6A9yNhsoLxCPaMTsf
 Q0ITmPdX
 e8m87GptxEXESkPiG7mQFSn+MbY4BoFiQPv1VH1m0zXhi4RkkgdgafjpaWEVUHoF066EJ+CyDoeejWSwIb/N9A25DiTu0OIQhnPAfHtuySflHJssgDbftbXHGahtV37vc6jSQ4xPfxbkDrKZzH3LeFeWWyq8gM0IEDBHZKdVBy2dkvP18of/z9Pa4qEwWvaBPpPr4G5t99Vg4/ycGtLP2jxpaa0zgwnAsA3h5PB23ms2PsICi9WS1F+sxV4jbGLGZJ7d4VP0qj5mV15oh61z2/QTBPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:14PM +0200, Vlastimil Babka (SUSE) wrote:
> With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an
> alloc flag that prevents kmalloc recursion. For that we need a version
> of kmalloc() that takes alloc_flags and use it in places that perform
> these potentially recursive kmalloc allocations (of sheaves or obj_ext
> arrays).
> 
> As a preparatory step, make __do_kmalloc_node() take a pointer to
> slab_alloc_context. This replaces the 'caller' parameter and includes
> alloc_flags which we'll make use of.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

