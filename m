Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B779606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fNkzmp2o
Received: by kanga.kvack.org (Postfix)
	id 580576B05B2; Mon, 23 Nov 2026 14:04:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531796B05B5; Mon, 23 Nov 2026 14:04:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447CF6B05BA; Mon, 23 Nov 2026 14:04:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 185156B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:04:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F1C9A07C5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:04:02 +0000 (UTC)
X-FDA: 85467308724.20.96E966D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id ED77380016
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:04:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNkzmp2o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795460641;
	b=YdKcvRPQc4nb0nXGE1w6frvE2RzKkzzqvkgWzPyhFCxN+APPkXcUA84L/7108xZ1HfRE7j
	ZeXaZaTNuxr8ljD/7RxE/xvfuB2/LRrL43yxu7xf6ZB1IO23hiUh09OaP/oRWVPB1lHw8X
	7K27ZEtCX5Zjmf12o2vcc1BA6H66gW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5OBMtF7PWPhg5B+K+A0+CiyDUgz58ztAmv4VwVZNZE=;
	b=UwUXbrEA/MLfapMBmje67OuDnOgBUzka1K0nQ8kE9Rkq/nHXLjhhOZYTVxbd5pjk7TCotz
	r/JpbgLlARXeNb+ZpsOEtDt8k9vGJvMcU75XThVoUlXmD1yguIGXGxuHMQx63qDJ9BxaJw
	GDvaEW7cfwbXrvbMzjUuLXzZej5bP9Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNkzmp2o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 753F660E78;
	Mon, 23 Nov 2026 19:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F511F000C0;
	Mon, 23 Nov 2026 19:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460639;
	bh=x5OBMtF7PWPhg5B+K+A0+CiyDUgz58ztAmv4VwVZNZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fNkzmp2oG0pQH9VwwhTvFnU2TesfiXbyLMoJV0rwJ/TO93UP5BPRUpJ+C92d7JJom
	 OyAVsUcRQfAb3H8SMGfVY/ZOXTL+MSCQj+Dyws3v7cZkUVHo44LqPBjA3Ca7CHgtBh
	 99y9XZGjQ4ViDdGRU0WIBgXeToDRxBSCncds6bSkRZ0D7B0wBxaXwxBJ8ymxPG+EHf
	 TK0Glvu65JhK/aYAWpC2MwZ54QDkh6PQFr8Gq8hZwnApxYIFOOAosssXt7GR5MilMA
	 3wlavrtEV2/SDnTVIkl06lmclxYnH9wn6vDjbFe46kpo3GnVzpXCHmFNO9R5/AwbMo
	 dguvu7FpL2eyg==
Date: Mon, 23 Nov 2026 19:03:57 +0000
From: Harry Yoo <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Usama Arif <usamaarif642@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 2/3] mempool: fix missing alloc tagging in
 mempool_resize()
Message-ID: <awSNLjJ8MbasBXUb@thinkstation>
References: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
 <20261119-alloc_tag-v1-2-efcccfd3a9c9@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-alloc_tag-v1-2-efcccfd3a9c9@kernel.org>
X-Rspamd-Queue-Id: ED77380016
X-Stat-Signature: e4tyt85786odge6rzjsj6p71pmke5mwe
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795460640-60729
X-HE-Meta: U2FsdGVkX19c8lH10+irrdtqHStolRYcHBur/fOgb0Mkk3FXrkh4komZW314P6CKquVoU83LbBEYwogS1rfi+3Xy1c9dyeWNeOQgdGsifVaOOLLc6JkuL5W3pXVH7590dkXu3fd0IrKETOyXDTuum65C7wNU8OvqBrV6CY1/0in9il5Mgn7ViJ3PjGXthkoK8PHgSoCSOFVU9Cl1e9Y7YWiwEU3eQO0HNujwtFpIC6kSQf37SxyN1xSoZSMIM37ZjNN51BqAfoGgVOMLKvTx2b4UWig6ivcbc9ayGTLY9EkZEFeeo8G6o/UMnIl1HuNVLvA7FFHBabssCM2bOCq6TF514V8+J2dIvNPeTrnKeFEuNn3ya6fb+qHShRUvimnoee9pgALo013858arPTK9Bu1R6qivSyNKRgyQk1g6n3GN9cAf6mjt4nuGvv9Wam1gg0yA2TmhYfs852/34ErF4fO4uh+qXgz3KQ0uTD1LsTYf7BDDBg8++ymJPbQvmum5VTDdRt/kRe3yvMbyQ78y3Jsnx6nZh58x/bFb+IAhwHTQt4w6d+75hUyJa2+bHJTPZdRIMBNUucocCVKoJFLGut+sO1v5IZ6MPVLlxtva5zJwhRJduV+3DqfADM4DDd8xJb5p7/NkKQ2FlSVSwr8sZdYAjUjT0fY9L3nRozoz7WojVjZmPqe/M5y8KitcO82s/nfgOdQ3yXKRRRf819l/mqxwDphKoQaCplGrlxVKg2skaR2PLOT8sgGLwM4ilh5bmKTeRwzoTS1rhgCrqg52M+Dyvw2suX2oKaVbwGXJUVtR5VRtvK/vVHMeIcc/sd9RUj3VnjqeanaQ4SVGlfulNuXIoNvnNY5F4+jYlI/a1h2lyy7Wh61/KQi5AoNw/EBpdvNl+Bc0C8Tgm6UiPD/NXIW+keUY27H+f1s2Os2ZXQdXgvQSaBz1rd2VGKSrmUgtGe5kMSli2iNifXC24d/
 3B8A9o7y
 C/uQEsieJYeLlDMN6VRU8I7QeE5Iy5toELuSgz9TtQgvCNPsm1UNuO4DqfNTdr1wUZrUcQ8DGhvKENIGKGF1adxo6wFmJHeYDPw9ugVg3xHPrTzzWrmy5eSJKispWUE2kpmQhY3XPVTt3NJK9JJVZ7Qw1kDds9pxDtEplVEaIC891OqpXj6HL/Ny5J/FRVbZ86vJXyDIlqHAHIsuARFORnmkomg6CYqRc3HvoMbu7DjQDhCk0n0819LNelBoWQAjuOzLn4nd4jUbRtv53xSEbEF0fyE+hICLzFcSpbG5S1gl5qBhLm6YFmktaWNABBRDImO0COoVBm/lWj/0IPSw7vzkC3ErLw/MvNwuQQ01ag+EFT/5SKuv8a6f60XLA0JCJpqc+yKu4qljK6g5KhkC7Q/zOCPJwWRL6+4yqlfUxvwawII6ozlmRmqNB0gRnnnWULbP+difySXoyu3NUlmCj3jhgS4/BOzwkDcFc2btfXogUG54xfmCYcAotYohiK54YfwoRlZaXxTbTPeqzY9H0msqniawrATuebClrHw0Q6zF47gE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 09:52:21AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> With memory allocation profiling enabled, mempool_resize() allocates new
> elements without an allocation tag: mempool_alloc_slab() and friends
> use the _noprof allocators and rely on the caller to have set
> current->alloc_tag.
> 
> Unlike mempool_init() or mempool_alloc(), mempool_resize() is not an
> alloc_hooks() wrapper, though.
> 
> Therefore, the newly allocated elements are missing from /proc/allocinfo,
> and with CONFIG_MEM_ALLOC_PROFILING_DEBUG=y we can trigger
> "current->alloc_tag not set" and "alloc_tag was not set" warnings.
> 
> Fix it by turning mempool_resize() into an alloc_hooks() wrapper, just
> like the other mempool functions that allocate elements.
> 
> This has low urgency.
> 
> Fixes: e26d8769da6d ("mempool: hook up to memory allocation profiling")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: adjust description, remove kmalloc_objs() change ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

