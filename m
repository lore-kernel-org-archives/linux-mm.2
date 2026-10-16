Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00703CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 01:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141D96B0095; Thu, 15 Oct 2026 21:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1198E6B0099; Thu, 15 Oct 2026 21:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0567A6B009B; Thu, 15 Oct 2026 21:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7D936B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:25:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6CAC91C288B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:25:06 +0000 (UTC)
X-FDA: 85326745812.16.4D6890D
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf18.hostedemail.com (Postfix) with ESMTP id BADA31C0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:25:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792113904;
	b=btK20TrBpu8ZCpv+JkpvJd7wbt2I1oEFbARNuKorD9msxStta+m0RvFpbu9i71IvocP8vS
	g/Vu19o6+rN07d1UFNyQVNr2URK8+WQR5GCvawlO6NPRd4PiS0qjBxYHjk2WkN3eBlhvfv
	f7R+jG3NWeZ/cIN/vy0o7pWDsoojR9A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792113904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7ImDDYOheW50p3xtIBMH3kXzz7Eu57kAvuyHHkxIOnk=;
	b=C1Mq/g5APNI5lnPx7fvHZc1qramG2DZ0rmXwZT9wD5+MQbOTGV1lsDlhcNA+NRPFwlu476
	9Fpnj99jFbEQB3LQs2we100U5HNX5+qXP6rxxij1aNbKwvl1XSTeXltp+RfuXkVs2NnKOH
	r13rO2+mUZUEfoVyXUbzP0eln1d/HG0=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4j5S0q4mfvz8XrrJ;
	Fri, 16 Oct 2026 09:24:59 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 69G1OrPZ066351;
	Fri, 16 Oct 2026 09:24:53 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 16 Oct 2026 09:24:54 +0800 (CST)
X-Zmail-TransId: 2af96ad17ce6809-7b4dc
X-Mailer: Zmail v1.0
Message-ID: <20261016092454394HJ4ACd4Qd8oKYogL2CB7H@zte.com.cn>
In-Reply-To: <20261010203906.93156-1-kmehltretter@gmail.com>
References: 20261010203906.93156-1-kmehltretter@gmail.com
Date: Fri, 16 Oct 2026 09:24:54 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <kmehltretter@gmail.com>
Cc: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>,
        <kmehltretter@gmail.com>, <hao.li@linux.dev>, <cl@gentwo.org>,
        <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vc2x1YjogaW5pdGlhbGl6ZSB0aGUgZnJlZSBwb2ludGVyIG9mIHRoZSBib290c3RyYXAga21lbV9jYWNoZV9ub2Rl?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 69G1OrPZ066351
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 16 Oct 2026 09:24:59 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AD17CEB.000/4j5S0q4mfvz8XrrJ
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BADA31C0003
X-Stat-Signature: j6wrqh616ek7ugpqxxrxsdx6z3caj3w5
X-HE-Tag: 1792113903-415094
X-HE-Meta: U2FsdGVkX18cWv8rvnOEbxN8f/FlcjxcOdTHK3Ta72PpUpqBJjoyCiDbvSXox8YHYA49281aPCI7KNMKSmVDjWTeh5NV4YcceXo0J06TrzMw9wFNGJXEHC/Zql8o1/lqxDiQRKx7auHYIs5EkRZ9jvliP5aZ7Q3y8a/wmNzoxE2LNNK+pPmtfl97l8A2XZ4+DYSAOeXiJm84x8NFlzxSuX5VNCWc4SJK4l4quTillc7LNot66TVCK6CYxQf5mZuoYgdJsIx/c8lIRUcb8RkkMvuhYaw2XBIy9jf2wkGUOjv61Xzlwculej9T40GD0QLC7L5cREpmLgFwtocl63i9XYjBREuZSyVxzB1BlICdjKCWSqQ4d5cd/XL1FtlKai61Bl8If69uT5JUJRr2/hAN7F506gQLSNVMacvcT5pqqVKOO/ZQml7Oaxy48OeNBLyFUR1KScc5w8Vkfy/9++RgeP0Fdj2jczvEPPGWjtUWEgPUIvtR8lchCCyespquPKqODFHgVGg/SSrKN65zey7Q/9QxlgEROTdd4bDZk5n7cBWJd7NeXfzerKA9jeTHRTgu7oui4gzbHO1Z92HFwEewK/wkwnO7Oeyqa2PDkN7/scr+FzvQbulN6LpGDDEcnxDvmluq2tor+OGC7Nmt6QUFTH1s8CnmBR6+GRVcTdgiskI+kyG4lYOZKoSWEROuIih8pexXn/h9oYIFBuoR27+c/fB6uetw+9ZwMvg6LcMFiODi8wVGl2bd5mPpdyzY95J2L2QE67zowsiSbkWVx3PlM+La7VvCMjZVSBKKKiGs4FESBGKnjfibtt1l6+lExOeI3Fm2cb9yv4kOYkVl9hd62qH1eEILtQCg0VyPVqI+eiQ0TL7eYOOPnXbHAFoWIU/BmcT9UvR68jUwxEjszECyInBN1LEtB2uKSpHb/f+F+66J+NObJn1j1dTjchcI2WY3tXhmJYNN3xfdS3PvcZz
 Av9nOH2W
 CosEsTAb4mImP8u26FdPt0LX3ZLSJ3XaDktGJvWL2RS9HDNtxam+d3ydrODt7R5dsm6iAya+8hWWs2Vr+c+dA2j82oa/XhFnxSVgzJKZItLBPe0KtC3dtiE8S1H4+mI0kqrfqqHJ8x2EcU4Yhf4VJAtPPbyZiu7N6GLS3FpafKZ/RIN1s0FsbN42lmoeE/M4gfkuDfI/51mUxHREfgEZSMUIZH8AyzdkcO4BK4bSvyAYmvZtMMA9JsGBBkDjltgRpgWHlcKEQY91AF40+lhH5GtkPvrJknSLkVHM/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmehltretter@gmail.com wrote:
> With slub_debug=FZPU, validating kmem_cache_node reports
> 
>   BUG kmem_cache_node (Not tainted): Freepointer corrupt
>   Object 0xffff888000140040 @offset=64 fp=0x5a5a5a5a5a5a5a5a
> 
> and taints the kernel. Poisoning places the bootstrap object's free
> pointer outside the object, where check_object() checks it even while
> allocated.
> 
> early_kmem_cache_node_alloc() previously took this object from a
> freelist with an initialized pointer. It now takes it from the slab
> iterator and builds the freelist only for the remaining objects,
> leaving its pointer filled with POISON_INUSE.
> 
> Initialize the bootstrap object's free pointer to NULL.
> 
> Fixes: dc795d4c0282 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Thanks for the patch, LGTM!
Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>

--
With Best Regards,
Shengming

> ---
> QEMU x86_64 and custom QEMU SH7785LCR model, slub_debug=FZPU:
> validation reports "Freepointer corrupt" before the fix, clean after.
> 
>  mm/slub.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 54ec125033571..9a20aa820bb0f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7777,6 +7777,7 @@ static void early_kmem_cache_node_alloc(int node)
>  
>      n = next_slab_obj(kmem_cache_node, &iter);
>      BUG_ON(!n);
> +    set_freepointer(kmem_cache_node, n, NULL);
>  
>      slab->inuse = 1;
>      build_slab_freelist(kmem_cache_node, slab, &iter);
> -- 
> 2.53.0

