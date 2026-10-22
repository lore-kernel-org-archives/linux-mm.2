Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73638606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 11:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=brf0jNaF
Received: by kanga.kvack.org (Postfix)
	id EA3466B091C; Thu, 22 Oct 2026 07:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C176B091E; Thu, 22 Oct 2026 07:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A506B091F; Thu, 22 Oct 2026 07:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B096D6B091C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:48:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A115C07EE
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:48:41 +0000 (UTC)
X-FDA: 85350090042.20.2B2F038
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id F1E712000D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:48:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=brf0jNaF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792669719;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ESmd90fx1D0rpbzG2EpAYl8sOSqIWpsFVg+5k4FcAI=;
	b=KllEWcvInAwZWqPRf3K2AFBHyAoCB08bZ/3LfkfZ2bG+WJkR6So2AdS4MhD1nVfajgxo02
	VhRDw8decuNql52zcVfpWsjQwycK6EObASIaaLG5JxAICvlr2tzTc7Fnjs3V4TJHWBmWRb
	dRbyVR6+rsafUP3tx6uduPO+KawnpG4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=brf0jNaF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792669719;
	b=yLuTNu7oswRJsw+AUFLbwZ1DnaMDKD1mTEyAWiGo6fYJkDk7ZHjnz8XUNkdm51FqrUymHP
	d6ipt4NdtgJj9JHqAxVPRaT8AG/4m34E/mCKQE1fB4IM1fkiT5u0Q+YBemrd6tIbDIF5Hp
	m2pa3RUDfC8XdfGx6IiRKO+uBsxOPGU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BD07601FD;
	Thu, 22 Oct 2026 11:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BAF1F000C4;
	Thu, 22 Oct 2026 11:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792669718;
	bh=6ESmd90fx1D0rpbzG2EpAYl8sOSqIWpsFVg+5k4FcAI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=brf0jNaFv71W67YPpeIOIVSkHUAVVVJMSL3F38FPVdC2DnDLYr6sWatAhZby3KN+P
	 sbKMWlM578+MylqG32w6FY5bOjDcX64RMUPwqHEeX9Lfn/pXgjMbX5LM5riQuEFv0D
	 f3+ckQ/Ijnhn4uqu2Fw0/2kneeNRyHOave9N8wy+oq1sxXPrc9PxJcgP7qsNQ+7DRO
	 cuRZSj51F1cevrdxDoYkFltMAJ7/h6woy4aN9sp2+lLpQqnojzZfIPchLQMLEHlIxf
	 H99rTCkphHrclMJNltD/rW0RtLbHMN4wlZQ1TTFtSXMAeF2JWEaJ0EH92UReBU9Wy6
	 05/YZM96G7eEA==
Message-ID: <sashiko-outbox-181384@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH slab/for-next 03/14] lib/xarray: specify
 SLAB_MAY_ACCOUNT for radix_tree_node cache
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SGFycnkgWW9vIChNZXRhKQ==?= <harry@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Roman
 Gushchin" <roman.gushchin@linux.dev>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Muchun Song" <muchun.song@linux.dev>, "Hao
 Ge" <hao.ge@linux.dev>, "Pedro Falcato" <pfalcato@suse.de>, linux-mm@kvack.org, kernel-team@meta.com, "Matthew
 Wilcox" <willy@infradead.org>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-3-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
 <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-3-096800aa3330@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 11:48:36 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F1E712000D
X-Stat-Signature: cqjobdx6fjpfsrae34a3j4duzkzuwkk8
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792669719-113935
X-HE-Meta: U2FsdGVkX1+XVzj4vHzo2QAVUQ6Jaz3W3JXzusOs+WyjVtGmFTQV8aD9xjoRD1kdsijA+ycGnboh4fpNuwEzwBw14eVGCuUtLA/dPl4yKKvGMCV/6lUVuDu91T5u2Qxl9F9z+IC0fxGkDpt/bzP2RGuug18KpIHq1r4B1PeW0RwVz9fZ9B+ijLzw7PhoyI95MMfq5ST6/RBHVjjzKiRbgYR++2umbAH8vAkjT4zF+zuuWiVkcp9i+iu0pv0nlGiKxX9IBY7yr45mMzC2ifbixoY/I63MUGrEKSgUcBsi0Rmg8OhuCG6BcDPiE6RcQGhBx4WJSVn2n/8I5MK3Iy6aS7PORt/YnCUStj7TPMRvwjCMvI85iM41eSeWFhPCQRonmNFeL+bt4TsR7tl4A9XMoNFGAs7Gg7cwSeWAGT9uYWS1uo2NUe6P8fnBSHf+SZvaO8HR3N/ROGysuvR7eBqNhau3WijVSmhx/Kz3uBrhOmXumaUyw+ikXcZI+hF+TnRMBkzI5lksKAmmnJwSs8+TqY80tnirIwTKunWmrhNB+8WBIiWuGLq0HCLVDAqA4NLbB3OwdUrzk2Opw/znV//zqC2icdlbomEw3A5JdQFMRmqJr4PQvMkL8ZJjy00SickCRmnwOYOl0wVgd6ukBWGnUEL+bpf+pshOpSsL3Zho1naYKCqCia7fx8km0fXelJU6MKqqRNGEfxHAlaFSEFlOW4gHVDpt5fJXPbobHguf2kH3bSHi9tPL0gfq8YsXOg/bnimPMtKiqTPjtPexCehPQDkiGu1I2PWoKlZKYbLkkDFSI7J61YTd2ViF0LRKHHGN6pHJx740/j44SRw5JQl8/Sat/+2AStV+zbsayAFRZWuIjw8FisKyrlh1m4CnMimLXf8DG3vKTzWQdRGaKqCltgKQwokou9/e5DgYZvh6vFqx2A+DPfKZr4YD6dX/4mRo9mlhz3yvla7Z5Jb1E29
 2QIXm6Nx
 kTL7+kB8EIXAvkfpsVW+ARG9t7RHK6giuh8fOz3f81TYANrZmp1x4Q4kn9BXR15qI4/QVd0vVrplElzCwG2hP6wIM8SF7r2os0mQKNeHlj7ws26UBgpFW4Tli2w0OTyy/LfAEF3BOoTQQT1c8qo5XKm/RK1V35qSs+LYi6LId+zgII9MkqgG8hCjfSUPQWM4iEN1VGsIPvvdrTcuv5RawbPwH1HYvqQ7JU0LwommswSEuD+BDfLrgB7+NpdMwwBMBdJGQiJT4jfCJPNMlWZKySZFz5187vuzsFagNF5XbueaIH2u+j7dVp+CBDY1LjVtOLQ06uW2v5RiNyhheVeSzNjkcgaE/z6Mu9X9JFhRak91QNuuICLDY4loxcSWr3thJm3qq2CSbtSjOZQ+nfxKUvJ9lnISfnwB7eE6t0g6AwKM1k6nfpwvM8z+zaamfpXlx6IvwTzN0s+Bba33TBwq1yjMv+COALwywLCEZMkVqamGJwN7+St4Z2jUdWjFaFFIv/Ye4cast89Jd9kEbgxg1ag7mm9dKNlGaxEz6rNdiQkQiTnarcLratKm7MGYkB9UghEeQMYLbQCSRtYCCf/xoJQ0etdI+rJ8yeXSjCrn+8U4Z9A9EGYJaqSvl0eLngy8qFRd+PqXzf7+nLBvMzXQ8ap9sgadsrGDYqwsmW29ETqUIVYg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] lib/xarray: undeclared SLAB_MAY_ACCOUNT in tools/include/linux/s=
lab.h
--

commit 93954c4312f84244c94152321c79f4a0b093067d
Author: Harry Yoo (Meta) <harry@kernel.org>

lib/xarray: specify SLAB_MAY_ACCOUNT for radix_tree_node cache

This commit adds SLAB_MAY_ACCOUNT when creating the radix_tree_node slab
cache in radix_tree_init() so that nodes allocated with __GFP_ACCOUNT can be
charged to a memcg.

> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index 976b9bd02a1b5..2c7531deb0df7 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -1600,7 +1600,7 @@ void __init radix_tree_init(void)
>  	BUILD_BUG_ON(XA_CHUNK_SIZE > 255);
>  	radix_tree_node_cachep =3D kmem_cache_create("radix_tree_node",
>  			sizeof(struct radix_tree_node), 0,
> -			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
> +			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT | SLAB_MAY_ACCOUNT,

[Severity: Medium]
Does adding SLAB_MAY_ACCOUNT to radix_tree_init() in lib/radix-tree.c break
the userspace test suite builds under tools/testing/ (such as radix-tree,
rbtree, and vma)?

When building those test suites, tools/testing/shared/shared.mk generates
radix-tree.c from lib/radix-tree.c:

tools/testing/shared/shared.mk:
radix-tree.c: ../../../lib/radix-tree.c
	sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < $< > $@

and compiles radix-tree.o against tools/include/linux/slab.h rather than the
kernel's include/linux/slab.h.

However, tools/include/linux/slab.h does not define SLAB_MAY_ACCOUNT:

tools/include/linux/slab.h:
enum _slab_flag_bits {
	_SLAB_KMALLOC,
	_SLAB_HWCACHE_ALIGN,
	_SLAB_PANIC,
	_SLAB_TYPESAFE_BY_RCU,
	_SLAB_ACCOUNT,
	_SLAB_FLAGS_LAST_BIT
};

Should SLAB_MAY_ACCOUNT also be defined in tools/include/linux/slab.h so
that compiling radix-tree.o in the userspace test harness succeeds?

>  			radix_tree_node_ctor);
>  	ret =3D cpuhp_setup_state_nocalls(CPUHP_RADIX_DEAD, "lib/radix:dead",
>  					NULL, radix_tree_cpu_dead);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-memalloc-p=
rof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org?part=3D3

