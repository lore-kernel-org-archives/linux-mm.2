Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5D9606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 21:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lq+qp7R7
Received: by kanga.kvack.org (Postfix)
	id 2DAE96B05B1; Fri, 27 Nov 2026 16:16:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C5A6B05B2; Fri, 27 Nov 2026 16:16:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A706B05B3; Fri, 27 Nov 2026 16:16:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E70A26B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 16:16:03 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F68D1A04E4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:16:03 +0000 (UTC)
X-FDA: 85482156606.09.A1E33D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 79CF0C0005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:16:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lq+qp7R7;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795814161;
	b=6ChFLYqWoxyfepnfpJ9LR3ZrSLD+RNrX6HSyJSjnoGJDw0V8hZaSc3Hp07x2GNVfff8dLT
	XpKV2xCqp2y+V14kC9qs8qXhVXJGX0WCClElzWsWHH3ljie/uNAdFR+k0FUGIj6O6le9KU
	rfjIVLFKXM+XpLhwzY73vWo/8kF8rjg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795814161;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sfwWIfLM5eBAp9zz0UUR4VAbCLqVdDlycZTm0DH5/vc=;
	b=iC1SH6KBvuCJfKXKZQD1G+WWrm8K5ah3EmRS/QlQ3chPJQgogFiI9pCSkojUpiV9z808RU
	4eIBh1OTt0xfQ9CpVn2AaoS2o6XG/swVLycpT2aR/YeVl7wBh0gC3D+oBBcUvkER32HWmZ
	demhl63spHv38xZ8vfUF0jSqVqx6PDw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lq+qp7R7;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95A8F61B39;
	Fri, 27 Nov 2026 21:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD141F000C1;
	Fri, 27 Nov 2026 21:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795814160;
	bh=sfwWIfLM5eBAp9zz0UUR4VAbCLqVdDlycZTm0DH5/vc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lq+qp7R7ZMrsq8pzYA3yCv7Zdnyv6N4L4h2tzTwKmZiXjSc8zYH8FyONG8xLliGRx
	 7+3wGtdhcTp3nY7WMPmhvLp3G6vDvB1EmzWf3CAjbXatNmGxjUItb7/LVknn+3WIHp
	 vOeSRR+2pshSGrtNUkDOgnJAWhlpUTrqQVFLs6qS3zrSsCo1QhHEDw3GbR5VCe1Qy7
	 XPD1Dfe0EwrzQJ8mlLHG+0K8qIDk5mCAcTiYNHL6fiFdPRuD71yrccA4RiFJ5jzkJQ
	 kJKosXamQhhgxT/L1qCXzU8kk+WLDWPRDhdCAe7mACgrlJwURqZ/ghcSdFomnCEKV9
	 vBajCiXchPuuw==
Message-ID: <sashiko-outbox-238286@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] mm/slab: keep caches that drop debug flags
 unmergeable
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Vmxhc3RpbWlsIEJhYmthIChTVVNFKQ==?= <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, linux-mm@kvack.org, "Chris
 Mason" <mason@kernel.org>
In-Reply-To: <20261127-slab-ai-fixes-v1-3-cf13b6be6692@kernel.org>
References: <20261127-slab-ai-fixes-v1-0-cf13b6be6692@kernel.org>
 <20261127-slab-ai-fixes-v1-3-cf13b6be6692@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 21:15:59 +0000
X-Rspam-User:
X-Rspamd-Queue-Id: 79CF0C0005
X-Stat-Signature: aoig6aofgd3t17k1ts5qb3xgh1rhgsa4
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795814161-440080
X-HE-Meta: U2FsdGVkX1+skWF0mFRDeqTi9r45Yy26PnoSO78+amyTaoSSiGIuEYC8oAwEEjhPUsP+hBJx20oFJkEBbrjyLHdyCjXJDrYPgerAEhmtEN4VJMwJIu4u8XRObMChcYImw08LtoyR+5rYvXmufDky0lXR/CbF0gj/Muu/Zdg8GEDNtoQYj9aLTGjgzYm9j4DqU9Yl77St/ZaukIZ1n/GcQet/NTE4MCvAPI2R3hWOyAGFj2ua8fKbuXil6oPB+vAJnHViDQgEsFwgo0kIfYNb4sPKMLRdX48zZc4a15pxFVM95RvQYGf/gzO+YpYRCMmQ9QuwWOBPUGxPS2AIX/+hvILNVRezs9+V4c7tJTNLI41PXSM5GGN6FnU12x2SL5kxTM73H/doTPLXIwmoyxqQP7rgEfL1kVJtXngJiKEu9pvDhU8sWZkXbrYvDyBwjJpIW6EXYK1Tqdd8Gjq5hx77VZityZM+ZvDO6/zPHqSjwmtQHpHsCNid3Mpe68YScjlGwwVwBma62mp8UF6/icXAw/MUoSeAhsl9iuxQyvPY7Wer0qZ6Y4U9fq5BjxSGWb0BbaMQT9eODEN9aJpOY5FYHdi4M4vnsJJi/4oEKwHUTOUx4T4Vy1Rpqx3CjH/B2YqpSd9CbjUhKKeXDXRHZY9ZMC2E7wJRkZIKBvScNRsgeEtsZ3/9hQNYww/1c00xlC4rzlKtUizABD87j9jZ7KcOY506cXPoCv9CElLxwHrYx5LId+bkFacO/DYqzQQReoVh2/55MvHMZabX6qDYzYjhG6+T3+IdMZA+A+zr5EWxvYQj8oda81Hl5nB+iVThjB8igfUPr8ZXIYOjyaJ6V3iO2vCpx7Uz39ZGGDcApDotfmTndWEfDtuDvKkHmsVdqLelsdbyuS0Td3BfoAyAFtdHc2ErAWp5hnZwIm4QdZGqsqsE9xjmZ3W70jSCmofUPKSt2KTiAC58RqBlrYgl/Mh
 hlULEEnc
 e2hY+PqWbms+5+p8ACrf8i6MYHBTDmWo41U1p5+dfZgbMGk+QFf3lDsF21Lv1/MBr04IQCfY3Ro3fDMJC+zRiU0t4xlvPQMMijOPk9GYVvL9rBUoG8TdSTDkJFj8KHFQaZ4EkHcWBftUOkwrsjArkqhFepC8Zq5z92jz3zmz2xtxEuFfFiM+xZx/91i63CJsUWnEdVkX9w41hQSt5ZIy+1Js6tEg3EDZU6ZtqGYcxb+ytHgp+oOO7tO7svGwIimbjMNhT3aT59aUjFImWuzZCUEN2WArUT8fbBTailzZKz6ScEO2RMAc1QosxNz27kI1n7uwPfMqY7pKPBZPv2EsQ/x3XFTej3DKC6CdG6oszzLaQjt3vCtR2dq2nndnBy3zfto/wEu0WTsYjbd4CY6XSr3ydPPEhj5dLAUXTMCu/PEDVBK/AdzmPaDeU0YsYWg6b/9iDguF4/FvQimTPm+ZR+2tuzfPTSpEfMgmzqdAtbj4FWKrF7TKosUrKbPZzt9GUV/tfQfSFFAWu3TTl4xebQiSchOMYrfGQzOI04zoOpq9U02turTJp+3jl+cXTCtVvoZ+xiuLMjS0F8UrrtkvQ1UujactEc2pjhoASkyVpkKDwp7/t2Z3wxKOk7ZTNIYh0eB5W8cfov+hO6FIzGTCRmJWCRJ0V6ik2YSbeMgSUwWIFGK8f9KtZ1vGS3nc3EeKsEj1/tbJpz+znUMaeu4UIciRSuPEWe+UZzjq6GioGE0T7bq2OIyc9gN6QE15ksRj2mgHWOu/WUK6BWGiQ8DZ1/DnLwFgW9sAzstIwUPBBxKgWHgE7lctiyFRqZvAxRdY623FM08ftSovpNhRhnqK4J/tueegYxItZcA7F9IJw1saot6ibcI4QAC5VGkcfp1hGZfUM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/slub: SLAB_NO_MERGE set after second calculate_sizes() in
  do_kmem_cache_create()
--

commit d25c80897a858b81158f0edaa6a941c6407fc597
Author: Chris Mason <mason@kernel.org>

mm/slab: keep caches that drop debug flags unmergeable

This commit sets SLAB_NO_MERGE on slab caches that drop debug metadata flags
due to disable_higher_order_debug, and removes the global slub_debug check
from sysfs_slab_add().

> diff --git a/mm/slub.c b/mm/slub.c
> index 20570e4f1795e..9bb031f9a41fd 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -8864,6 +8864,8 @@ int do_kmem_cache_create(struct kmem_cache *s, cons=
t char *name,
>  			s->offset =3D 0;
>  			if (!calculate_sizes(args, s))
>  				goto out;
> +			/* Created as unmergeable, so it has to stay so */
> +			s->flags |=3D SLAB_NO_MERGE;
>  		}
>  	}

[Severity: Low]
Should SLAB_NO_MERGE be set before calling calculate_sizes() a second time?

calculate_sizes() checks slab_args_unmergeable(args, s->flags) when deciding
whether to set SLAB_OBJ_EXT_IN_OBJ:

mm/slub.c:calculate_sizes() {
    ...
	aligned_size =3D ALIGN(size, s->align);
#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
	if (slab_args_unmergeable(args, s->flags) &&
			(aligned_size - size >=3D cache_obj_ext_size(s)))
		s->flags |=3D SLAB_OBJ_EXT_IN_OBJ;
#endif
    ...
}

When DEBUG_METADATA_FLAGS are cleared before the second calculate_sizes()
call, a cache that was unmergeable only because of those debug flags will
appear mergeable to slab_args_unmergeable() during that recalculation and
miss setting SLAB_OBJ_EXT_IN_OBJ when alignment padding is large enough.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-slab-ai-fi=
xes-v1-0-cf13b6be6692@kernel.org?part=3D3

