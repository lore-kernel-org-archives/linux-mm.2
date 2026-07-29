Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E4EFC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 06:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F636B0088; Wed, 29 Jul 2026 02:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9A06B008A; Wed, 29 Jul 2026 02:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC136B008C; Wed, 29 Jul 2026 02:41:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3E016B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:41:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B3B1805DA
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:41:03 +0000 (UTC)
X-FDA: 85040866806.03.5CA8B89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B82658000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:41:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/0JUvwr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785307261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJ+OYo0jt+7rELKxSKj63C782hUiaz6ZZJLz2l3U6Os=;
	b=giJA/lzgLzK2LD3h3OYux5nJuhWkJEdyn5xmOtCbV/kF4qfx09ZrWNyh9fOCu+sbm2FdLP
	f7k36YqZ8ZOn5QITnuhlMGag6jWcAbzbwxUdS8T31hYJ2wrAd+nKk377zVcjT+7GLk1lP5
	wMY1INQBN4v3KV+7/L2I/O76VTFf0T0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/0JUvwr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785307261;
	b=X765dDbGLtvfAteVtaYD60GKO4Fu48MTg8ry9QO7YcEaGLJjCNKoXC2EIM8eOsuQ1aMI0k
	XyOwLR3uftitF6ItV3pFnySgIgPVMbxj+mgMPYOCLKh8zq+vbgYZuVwd9N3SfYACy4kGDq
	PeKlDsvjI+ir08TxltjKEjgXZnjIfUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 152DD40547;
	Wed, 29 Jul 2026 06:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C3E1F000E9;
	Wed, 29 Jul 2026 06:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785307259;
	bh=aJ+OYo0jt+7rELKxSKj63C782hUiaz6ZZJLz2l3U6Os=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h/0JUvwrqc9fADdYseINnuUR81h0pXXKxeyvG4vnTsM35njoUbwZSEWo09fw0WCpN
	 h+tgKdMHVHw3x6r/HjuZnAC+ELyh2JJzhDRGjSJU2omixz7cX4r3bQAwy/S4ldY2le
	 ReLMjgqoU6252ken+TyS1q/mANDObeevQS33DrY0K8bfkPEEld0y9pSweCadeKStvO
	 M/VADi1/oYAAft8yswpZc6KQwI1ECNYcDQSiwEqqIsavRlWGJ8JwJSTQnV5WFxRX1q
	 SbxrxW+VhZ78tPB52sv8Q2yFuw9RwG3/mrD2ddNazOX3YPbhH/f33XG9OsmxX5jCPu
	 XDpe4tQrka7RQ==
Date: Wed, 29 Jul 2026 06:40:57 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 07/13] mm/slab: replace slab.stride with
 obj_exts_in_object
Message-ID: <ammbWxBtX7KxgJ5R@dev>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-7-c29ef0f1f257@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-7-c29ef0f1f257@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B82658000B
X-Rspam-User: 
X-Stat-Signature: hr8yj54g6m3qoergg5hns5d9raxgbrmn
X-HE-Tag: 1785307261-801156
X-HE-Meta: U2FsdGVkX1+Bqr8IoBLXbDjTdKu4BZZDRf7mDNi08RXZMGP3/cHN1etKt9vmoLEyZSkq/kYExd7xTRGFG+WKplxoYm+OQhSZZURWJKD6wS9U2aXWfG3F86r7dmQuKFySA9bCvW/pwc5HAd53q/gTqhvTZMjpKtBoGrKooUBRmul+5exdNVOjChhXL35Hgmm8DiyOuAXSgL7hSTv6Ea9rlganvLWXV0X7chzJTcEr7FD/07js0BalbziZVXJlEG5+CE5ZnLi1FGTZannqxfvFmBzqPtWGdD1neWvflQIhyww2V+9k+sMF9/MwHXfwRFg16FtulYxEDHGfRzO6aQ8xK4oZ/c2ngKAQx+Vk04+pX2QdBnbrMo2S4wuLweucivTK4Tqb72CatNHX13+7PIiyFWjacihTv655cXQIDOTZOWdqqmPuu3wLbm0scqjQnMJyY0tA3kXYkh1UjUlu42/epo5VTGtueCkHdIdT1YZo1n54/XvaQkNeJiuEWz+q6hINHi4cY4jnfGrLC141RDjmCmoX1rH01G7wyBBHh2FCW3ik0QP0+i+XxFLGCstIBfh7K8vG3tx1X0N8GIoZ6YskQlyocchxuG+B6eAA5nxd4Un3ZPAzt9qdhneJIQrIXeLFy34E4/NwRvn/dJrN7DZYdCXZjjTLhDuN4La6/PTKvG6cHp0zJz+6NLK3j8fkekjv0TUAZa2hia4uI9GdJhiX7/MR7t8gicsF4v2NeODaxDG9PCHXk0c+vvpMv86Yjf0JtKrbWbsYnnOrGiNHR5fZdlt4nPH3n1uFlGtjI9/DBapjrC27pJ3cCUOlHmvQt3sCFQsLt4hUMNF4EnuzUHtxa84BmocHzZT6irNYyiLWHu3BreWypNrEgiSjk+K8rJ8b60jUUvF3NPCURjIn7lx/xWLEnJut9F7gUymzhnQlkfL191GyfLO3t98K6eWNWPfYsqxH0z/4BTAKYSq/4jm
 7Kkxo12F
 40WjY8/jARRlq2Mj/9g2u9kry8kCqTPKZHrjyA4gqZBBF3E5v8E9Kq5/7kVDb1kfQFUFgoMZmTcJrGf2XT6On/H/z9SfSqdSgq5+2jl1UwVM0P0PE4UkvJETAqLLpxBRZ7wH5EN3iAJj7XeBXNflD5SXZrNKZbMiQzYKYnCpVpjKUefbms/Seyp1G4VEODMLVhrTNQkSPq15p+EHduzcVnG+A6G4SI4sZHM0554LixqhtKZHkbCAYHGFVow2wjNV+JZ/+nQo6NUrhA2v/ANB4a1FBzCXR0RfpfEiLtHarWdwtqQmWrmKHCoEyJ6CrYgyuCGaO83wDMGgsTAyID0mF0PDwwRHHMtkQjjzV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 02:54:01PM +0200, Vlastimil Babka (SUSE) wrote:
> The stride field is used to convert object index to an slabobj_ext so
> both compact arrays (kmalloc() or in-slab-leftover) and spread
> in-object-padding obj_ext layouts are supported.
> 
> In practice thus the stride is always sizeof(slabobj_ext) or s->size.
> 
> This simplifies the calculations, but with the upcoming slabobj_ext
> handling changes, it will be easier to stop storing the stride and
> instead just have a flag whether obj_ext is in the object padding.
> obj_exts_in_object() can then rely on this flag and slab_obj_ext()
> can use that to determine the stride.
> 
> No functional change intended. Performance impact TBD, hopefully
> in the noise.

Performance impact is not TBD anymore?

> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

