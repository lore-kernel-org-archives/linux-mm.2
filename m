Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3CD1EFCE4C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 22:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2235A6B008C; Wed,  4 Mar 2026 17:03:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD586B0092; Wed,  4 Mar 2026 17:03:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CFD66B0093; Wed,  4 Mar 2026 17:03:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F00ED6B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:03:11 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB7DE1B877E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:03:11 +0000 (UTC)
X-FDA: 84509756982.28.99358F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F3A1C14000D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 22:03:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="rlpLqS/K";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772661790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7q2ScTrTa7RWe6lsUG4IH7isB5eWpir4Z/DML/zFVSM=;
	b=F+qdblaSV5VYsK7zLYGgCBHam91AX9wrZU39om6mFITEXi+m7xdfAkYzyhxfU8TUQ4yCKL
	WkkpXEAuWV6ECXB7jkZePtKNJ4TbJ9OJTYZ9fWs+2GdHDJuku3D4PWeVVxcMOpROlVOq85
	/tO5sR4uzVBHIhp4iwpqIB9V/O+WDE4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772661790; a=rsa-sha256;
	cv=none;
	b=HC2T7At+pcvwymeKIDrExqZwpRCnVZSHd9ESm0ewlb7OPKXmlnCsr4+dAK8o990UbTjyT0
	vTKSku4WWdTRU8Jdbk9O8U7lIENUiZk1bOh87D0Mdy21IgyiwaNEE1boDhYdhDpgfZzgQk
	w3jMOlkTcl3/89Mq5hkxQBF4S7K4U5Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="rlpLqS/K";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA40F40914;
	Wed,  4 Mar 2026 22:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A735FC19425;
	Wed,  4 Mar 2026 22:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772661788;
	bh=QcDeX+4A0lvHQQbRg9leLOGUG35mNFYWz5fL5TVLF1Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rlpLqS/Kj6XuSnENrppvplSEKrxYqPvM+aALj0ec5JjEL9u5ixAsovpcNNV7ejj0S
	 ljLr1AObex51OKKnoemq2v5AjE6O6xx8BW7Uq/Mxw9EQkmTCgKqYr0ac2XQl6ye+cM
	 GGkekwE02kT/+Xw0PJzgRoeJlHS3jhSKzvw6sAt4=
Date: Wed, 4 Mar 2026 14:03:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-Id: <20260304140307.f51a33f77f6ddc1dfc0cf476@linux-foundation.org>
In-Reply-To: <vfmyb3pp2gatdrqa2uimw44pxioreo7zc373zn7buvdfzhejew@ndhaa4yl3bvh>
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
	<20260228072556.31793-1-qi.zheng@linux.dev>
	<CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
	<de1476aa-20a3-420e-9cd7-9238efd3c85f@linux.dev>
	<46bgg2vwqvmex7wtk2fkvf454tqgaychb7l4odnnrx7svci5ha@vy4b4ophm763>
	<22cca07c-49e0-42e8-b937-7b1c7c51e78d@linux.dev>
	<vfmyb3pp2gatdrqa2uimw44pxioreo7zc373zn7buvdfzhejew@ndhaa4yl3bvh>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F3A1C14000D
X-Stat-Signature: dsf1fttr7xxnxtzi9tgcghugqwbakjdm
X-Rspam-User: 
X-HE-Tag: 1772661789-761338
X-HE-Meta: U2FsdGVkX1+bvloQRbNBL5U2jRnSbUbg4tk3p1/4wmB7+vjdvsW7v768CKJTONSIiaYQA8z2QdeHtN7TFjZXyArpeYzHAaWaGk6YW8RW63lf5lHgPJWAdoOukOQLcxMTvtg6pXU4s2ei5BbOVyqYoD2B59UNAQvv/E7eyfmvSwhPcaKO/YTi8swqqwfOPSLZ/ank6KwoVgHS6rpUNCL1PFpDJ4RxnSP4x6vNFG6Js5wCOg14gxIkNEuUi+g9OLgbO4mwyr/iLiLmnJkODFhUKCx1NWMrhOAP1dH7+esIfxgMZvBJdem05e/COjECA+Vek9Zz0af8801d4a446op7VFxMyAJHCGBsgzWQO5vj/tBJO5YV1izX03EsSSdolingBCf2tbjrRqXHSELessqFAfcyLQIa898heClJZfiLr3MivVD1qC4nBVJMjTIAwso8GAjlKlzxG1QSPZV4v4XoCcko/89LfvGY9/7ckZGIxcOWXA+COgeveoX7Ojt66n6PoZI4lp8Deb4W364nFZdZ/Xl9uf7WO0iIYIM0DD/v+5ZAgEdUhzEfCxezjPJjjy9Q8lrZcxvN6GkjXYi5TypK7DTJMVqvSkwAe6uDjDyxpM2Xgoyz/bvf26+mElbzWRmPf2i/HYDikfiSrIKUQdXrM0VsvlZFcZvFZMNyWwEZBAyVVekqLy2McXLD8VN5KIY/vEkEju85iwRzg9ZDzXhDI6XDWuftjitwd0VqYJXipOGQ4DDxs67PJQeQLjjIeRBbhlJZFpUBN+MsuKv2bGxNOVMikILmCqMbL69yG1Z0y9rmJbp1/a5ad4NeH52fULGe5g+SSHMX4CQaBD1W/Rgwpfen2Q2GfsRo3ACUVv1icc8cSI8xyJ6NmiIhkZcX/UgXbc3RmhVZeKj2nNIs2CslZY4dUAc5IxKm1ZhPvy+TNXNxKdNIKap6+cIQwrEFS4wQA9F8/YLQGjMtLFCY6X+
 LyxOmVLV
 TgBNaWMNtyKCMBBOLSyWs+RbKGGKiY33SL8AoFecdbJa/FAzkA9QKsb6rvHbIzTLOoRbgcbtPzkWgWj2I4kntx1KyW6fSZ7opN16yfYPVDLdpmeYL237bc2qQf4kFwOi/Ngw58ZndWbSVrdKrKoFT7qeFbtqrjESnd3055h6I23DA0RMUO13t5KPWqlE+e3ZUulM2zz+Lgu4bd7/B+JLw8tqeFSB3YngLKynjKsFr3f6+Zjm5lVTa/l76n86Hv0dItQTntDS7OjwVkHPP0GaJ00esPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Mar 2026 13:57:41 +0000 Yosry Ahmed <yosry@kernel.org> wrote:

> > > What about this (untested), it should apply on top of 'mm: memcontrol:
> > > eliminate the problem of dying memory cgroup for LRU folios' in mm-new,
> > > so maybe it needs to be broken down across different patches:
> > > 
> > 
> > I applied  and tested it, so the final updated patches is as follows,
> > If there are no problems, I will send out the official patches.
> 
> If I am not mistaken, Andrew prefers fixups to what he already has in
> mm-new (Andrew, please correct me if I am wrong).

Yes, if the changes are reasonably small and the code has already
undergone significant review.

Although the mm-new branch is quite speculative/early so I guess this
is less important there.

Adding a sprinkle of -fix patches can be a pain all round, so nowadays
if someone sends a replacement series I'll generate and send a
what-you-changed-since-last-time diff.  So

- we can check that the diff matches the changelogged updates
- reviewers don't have to re-review everything
- the author can eyeball it and think "yup, I meant to change that".

I believe this series is due for quite a few updates so a full v6
resend series would be appropriate.  I'll generate the
how-you-changed-mm.git email from that.


