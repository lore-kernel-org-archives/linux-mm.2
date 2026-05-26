Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FC18CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1356B0088; Mon, 25 May 2026 23:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E9D6B008A; Mon, 25 May 2026 23:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65E06B008C; Mon, 25 May 2026 23:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A38A56B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:19:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 716A41A0262
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:19:35 +0000 (UTC)
X-FDA: 84808115910.05.A15D6DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C2F1C80003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:19:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=Fzd15vWW;
	spf=pass (imf02.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779765573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fqDemX/FdOBkBnC5ZP9UcI550Lp4WB10rVWgF62/WPE=;
	b=pR2osseBhPxd2m6js3oIGwWMuL2vG/SfUJfIj979EYu1STKp+Uoqqy5zyzxt3OhRzHVMFe
	uwjSvRpL0iO4YTLmRPG8xkEyDpdtnn0r0KOSDkRxqjEBOptXGVzC5Pr/6BLLWTaBTaUZri
	OYKwfcLcZWE3CS7XLxBZpbGcNuY2l8E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=Fzd15vWW;
	spf=pass (imf02.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779765573; a=rsa-sha256;
	cv=none;
	b=0jtLwEwBJdAeOalB2ci4VUA4cGTE9akjac/lc+Jx0rjkaC29XJlfpYnV7qoRwkBCJ2uJUt
	WfZW0ee1j2F0dQ/hB+Ppr403gVSD4bVnSm3V9Bwf11lxqoui5sqnlFONivJ27is/3c0mlL
	sSqUi1zDTwwVT1Hb9yc3CiWHxCxtM7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A88204402C;
	Tue, 26 May 2026 03:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7761F00A3A;
	Tue, 26 May 2026 03:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779765572;
	bh=fqDemX/FdOBkBnC5ZP9UcI550Lp4WB10rVWgF62/WPE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Fzd15vWWyuYXLNpPYgTplgKtYq8F2XR5KRsMEcF8xi2CD72aP31LWYlDErz9DBd+J
	 opHg/6+RBvpOe+ogUW/8tC48Sr4O6K1U0yzALBoShK+RaMDlUG5FsZdh2Av0bPEdxU
	 /RvangL28JkJBl5vUxjGFNwHlEespD8WpeXZ1mNgt6sNJ6D268ysX7OGYuUZVM0ucQ
	 r2b5NQAaSa/B+1193b424wq9mVvcyo4qxECiHgNDbnhOVE0jwdFipHIEkGMwEw1jkQ
	 lZZBXlWsy21t5+XLv6AmZDg2+4jwjQNvGFHVz9NnOOHgXJzgrSc2lhdUMy7nDAjqtj
	 zIjNyT3zxQ8hg==
Content-Type: multipart/mixed; boundary="===============2941777259395279126=="
MIME-Version: 1.0
Message-Id: <cf69281a5bdcb9c508d5b856610ec86893ad95e1d8dd4586b72b65fcb595ed61@mail.kernel.org>
In-Reply-To: <a7bf069cbc39930fad3740269aa82f1acadb029b.1779760876.git.zhuhui@kylinos.cn>
References: <a7bf069cbc39930fad3740269aa82f1acadb029b.1779760876.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v7 02/11] bpf: allow attaching struct_ops to cgroups
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev, ast@kernel.org, daniel@iogearbox.net,
	john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev,
	eddyz87@gmail.com, memxor@gmail.com, song@kernel.org,
	yonghong.song@linux.dev, jolsa@kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, inwardvessel@gmail.com,
	akpm@linux-foundation.org, shuah@kernel.org, davem@davemloft.net,
	kuba@kernel.org, hawk@kernel.org, sdf@fomichev.me,
	kpsingh@kernel.org, chen.dylane@linux.dev, yatsenko@meta.com,
	leon.hwang@linux.dev, a.s.protopopov@gmail.com, ameryhung@gmail.com,
	tklauser@distanz.ch, eyal.birger@gmail.com, rongtao@cestc.cn,
	haoluo@google.com, peterz@infradead.org, ojeda@kernel.org,
	nathan@kernel.org, kees@kernel.org, tj@kernel.org,
	jeffxu@chromium.org, mkoutny@suse.com, kernel@jfarr.cc,
	brauner@kernel.org, rdunlap@infradead.org, brgerst@gmail.com,
	masahiroy@kernel.org, willemb@google.com, kerneljasonxing@gmail.com,
	paul.chaignon@gmail.com, chenridong@huaweicloud.com,
	lance.yang@linux.dev, jiayu@kvack.org, an.chen@linux.dev,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: geliang@kernel.org,baohua@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 26 May 2026 03:19:31 +0000 (UTC)
X-Stat-Signature: t9spdi3m8ggfdczpsg1hh1h1hepb3g57
X-Rspamd-Queue-Id: C2F1C80003
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779765573-313214
X-HE-Meta: U2FsdGVkX1+XhggdLPdrbe03A8cYHxg/ev27g2m6qLNHARj7zywOMZDIVPTH986N9I5hwpZk9uvHf+8wLCejk2vWFT+z0NqqW9A83je5x7wDt1BBUoCztn84cO/5wZoQObYpYueY4464hjjOFVjk/XApbArFyPdAYGqQV9xLUJkvK1bl6QGhtF1UxG7TFKKrfx2Tyobs2S4LJt8yAYOcLzbMW2ZxMdc85fC0M2r1IViOig+jGIowWVf/W+oNOnibU2ZLQtt1WXF5mOAdZlNzyT//Xtd688RUDSxLuVSqZR9VUZD3aKMdXrzjWm1xwlC6S7wfgnMK9i56ynN7b/52udXLqIHcBcnucUPXNDJ4bCj5uzakTFRis8cEGQyHLvpEtoSoT4SUpibNwlDXHYFQxj1he3bMaqR7ve/eJO6TqMVkbhwVEbleU/+8TxiYolqCA+Qu8RQx9D3rvndWrwBecaIQECAXpT84/Lzx3+jJYEFt/3X3X391XwaENU4iqQQ5+aIIdZMzyoC3r21KmtYf2Z47/lpdKaS+EYpaYP9fRyyp2mMxad/LdygaYWPPjlrOZh4gOcf+V5EQhb1q2TU3kpd3Ul1ZFG4J6nUhreuDC0wA4GAaWlaiS6zN/xoA9sAAOjMnp+4Yw1bmcJjraDBEsnh9pO3ZsA2+8j8k8aZ066CR97W1k3WOf1TXDmNtmnha6oqIDeP/HfSgY3TwMUSbsut7+6WGgWIflyOaMf04x0j8KSBnqNMKTcCo8O3hF+qXCNuGUIDpA/LDWIxqS6hVkK0y9Xjg7FjckSByr9cwK461G3MiEAaVoc1BE+eJOZFhmZZoO1gVGNXlDzXZev6R/7stjZIAU3D9dSG2ZaBYHsoMln8c4senbaQcKKd8ZQ4M9aKGo6WwENRuWZKd5RYBaWlvQ3xCIt8ODbNIolPV6SrRz+wfeQdrMn8kpOWp/cu51Ej6h9CCAIviVFCC1bC
 1U/9KO0G
 Ono44rxyliFuRDzNGABGBw3hJAnM3rqYR3gRgkr/m9VV5p9bqfuC1PW//DoVvzWbxJoqzH3gIMPLnnQDOxCM9pd8L8UL1kTxOmswano3WSugf7YCqgrvw0NUIwBAYPkGA9t0RDvOAsgPgv4XUa7LmX56+gn34+hDMZSnLRcYVs0jJCcmwEQ27NYwOrARN5KYlktmvsh9hlvq3qjMNA4+e3YnZ8KPecBvKFcmItvuoJp5xCH70gKz/EOlgkLPz3/zgdCKawaAwd8qogAqU+2JYKYWveee7gmo2zmnjONxxIHb8DPx268dxy+AYMCpfaN3E5AlVmoW7iCY0tvyxncI9HDfjRJT3xXyZbDlY3Nbuldt0lRRTO2relHi7b52Y6AMnhLnL2+2xFLC01PGpFCaL2D0ONaFDFP5i78xoaUlSld9hbQ0FbNs33I8OVORw/kSf7G6ZxcWOKXzFabbQSAJKU8vWOEJ2vBW5N+8FaF/jRhkeoowyaj0HaeuhScNaaDye/SbwOcanFBC1f6jLWIi95igfTApLbXC6ccDNHEiG6ZdUHnm73Oo66qO9KM9ZJCZ7AbYgu/yqTF+4wdIpKc+n5c9+W1mRsAURTAy0CL9RWKvZ5BpKBbVm1TMg+zZU9sJz7EK28O9VGXJcnZbrcotMNSs99eMGaTUE2KuQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2941777259395279126==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index dd4f34e041ab..bd1b94a618ad 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1922,6 +1922,9 @@ struct bpf_raw_tp_link {
>  struct bpf_struct_ops_link {
>  	struct bpf_link link;
>  	struct bpf_map __rcu *map;
> +	struct cgroup *cgroup;
> +	bool cgroup_removed;
> +	struct list_head list;
>  	wait_queue_head_t wait_hup;
>  };

Yafang Shao raised a design concern about the struct_ops_link structure:
The struct has hardcoded cgroup-specific fields. He suggested a more
generic solution using 'int type' and 'void *private' fields to support
other structs (task, etc.) in the future. This design feedback was not
addressed or responded to.

Reference: https://lore.kernel.org/bpf/CALOAHbDXmgi=yeB1c2zzQ7-Lz2+MEZvtbxQp1=mWXMJSsg3sgQ@mail.gmail.com/

> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index aec171ccb6ef..f547613986cc 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1246,6 +1246,7 @@ enum bpf_perf_event_type {
>  #define BPF_F_AFTER		(1U << 4)
>  #define BPF_F_ID		(1U << 5)
>  #define BPF_F_PREORDER		(1U << 6)
> +#define BPF_F_CGROUP_FD		(1U << 7)
>  #define BPF_F_LINK		BPF_F_LINK /* 1 << 13 */

Since both fdinfo and link_info show the cgroup ID, would BPF_F_CGROUP_ID
be a better name than BPF_F_CGROUP_FD for alignment?

This naming suggestion came from Yafang Shao and was not addressed or
responded to.

Reference: https://lore.kernel.org/bpf/CALOAHbDXmgi=yeB1c2zzQ7-Lz2+MEZvtbxQp1=mWXMJSsg3sgQ@mail.gmail.com/

> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
> index 7ad3b1a49dee..e63f926d8728 100644
> --- a/kernel/bpf/bpf_struct_ops.c
> +++ b/kernel/bpf/bpf_struct_ops.c
> @@ -1264,6 +1270,7 @@ static void bpf_struct_ops_map_link_show_fdinfo(const struct bpf_link *link,
>  {
>  	struct bpf_struct_ops_link *st_link;
>  	struct bpf_map *map;
> +	u64 cgrp_id = 0;

Assigning 0 to cgrp_id would technically be incorrect. The cgroup_id()
function returns 1 for !CONFIG_CGROUPS, and for CONFIG_CGROUPS the ID
allocation via idr_alloc_cyclic() uses a range between 1 and INT_MAX.
Would a sentinel value like (u64)-1 be more appropriate?

Matt Bobrowski raised this concern and Roman acknowledged the review,
but this was not fixed in the current version.

Reference: https://lore.kernel.org/bpf/aXnyKw5sRt_MB-8A@google.com/

> @@ -1271,6 +1278,14 @@ static void bpf_struct_ops_map_link_show_fdinfo(const struct bpf_link *link,
>  	if (map)
>  		seq_printf(seq, "map_id:\t%d\n", map->id);
>  	rcu_read_unlock();
> +
> +	cgroup_lock();
> +	if (st_link->cgroup)
> +		cgrp_id = cgroup_id(st_link->cgroup);
> +	cgroup_unlock();

Could an inline helper be introduced for the cgroup_lock()/cgroup_id()/
cgroup_unlock() pattern? This same dance appears in both
bpf_struct_ops_map_link_show_fdinfo() and
bpf_struct_ops_map_link_fill_link_info().

Matt Bobrowski suggested this and Roman said he would try, but the
helper was not added in the current version.

Reference: https://lore.kernel.org/bpf/aXnyKw5sRt_MB-8A@google.com/

> @@ -1393,8 +1422,12 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
>  	struct bpf_link_primer link_primer;
>  	struct bpf_struct_ops_map *st_map;
>  	struct bpf_map *map;
> +	struct cgroup *cgrp;
>  	int err;
>
> +	if (attr->link_create.flags & ~BPF_F_CGROUP_FD)
> +		return -EINVAL;

Should all the cgroup-related logic be protected by CONFIG_CGROUPS ifdef?
Both cgroup_get_from_fd() and cgroup_put() lack stubs when building with
!CONFIG_CGROUPS. Should BPF_F_CGROUP_FD only be accepted when
CONFIG_BPF_CGROUP is enabled, returning -EOPNOTSUPP otherwise?

Matt Bobrowski raised this and Roman acknowledged the review, but these
guards were not added in the current version.

Reference: https://lore.kernel.org/bpf/aXnyKw5sRt_MB-8A@google.com/

> @@ -1414,11 +1447,26 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
>  	bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct_ops_map_lops, NULL,
>  		      attr->link_create.attach_type);
>
> +	init_waitqueue_head(&link->wait_hup);
> +
> +	if (attr->link_create.flags & BPF_F_CGROUP_FD) {
> +		cgrp = cgroup_get_from_fd(attr->link_create.target_fd);
> +		if (IS_ERR(cgrp)) {
> +			err = PTR_ERR(cgrp);
> +			goto err_out;
> +		}
> +		link->cgroup = cgrp;
> +		err = cgroup_bpf_attach_struct_ops(cgrp, link);
> +		if (err) {
> +			cgroup_put(cgrp);
> +			link->cgroup = NULL;
> +			goto err_out;
> +		}
> +	}
> +
>  	err = bpf_link_prime(&link->link, &link_primer);
>  	if (err)
> -		goto err_out;
> -
> -	init_waitqueue_head(&link->wait_hup);
> +		goto err_put_cgroup;
>
>  	/* Hold the update_mutex such that the subsystem cannot
>  	 * do link->ops->detach() before the link is fully initialized.
> @@ -1429,13 +1477,16 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
>  		mutex_unlock(&update_mutex);
>  		bpf_link_cleanup(&link_primer);
>  		link = NULL;
> -		goto err_out;
> +		goto err_put_cgroup;
>  	}
>  	RCU_INIT_POINTER(link->map, map);
>  	mutex_unlock(&update_mutex);
>
>  	return bpf_link_settle(&link_primer);
>
> +err_put_cgroup:
> +	if (link && link->cgroup)
> +		cgroup_bpf_detach_struct_ops(link->cgroup, link);
>  err_out:
>  	bpf_map_put(map);
>  	kfree(link);

Can the error path here trigger a use-after-free?

After cgroup_bpf_attach_struct_ops() succeeds, the link is added to
cgrp->bpf.struct_ops_links and becomes reachable by cgroup_bpf_release().
If bpf_link_prime() then fails (FD exhaustion or memory pressure), the
error path checks link->cgroup and calls cgroup_bpf_detach_struct_ops().

However, if the cgroup is concurrently destroyed, cgroup_bpf_release()
can run:

  cgroup_bpf_release():
    cgroup_lock()
    list_splice_init(&cgrp->bpf.struct_ops_links, &st_links)
    for each st_link in st_links:
      st_link->cgroup = NULL
      st_link->cgroup_removed = true
      bpf_link_inc_not_zero(&st_link->link)  // refcount 1->2
    cgroup_unlock()
    ...
    st_link->link.ops->detach(&st_link->link)
    bpf_link_put(&st_link->link)

At this point link->cgroup is NULL, so the err_put_cgroup check becomes
a no-op. Control proceeds to err_out and calls kfree(link), freeing the
memory.

Meanwhile, cgroup_bpf_release resumes its second loop and accesses the
already-freed link memory via st_link->link.ops->detach() and
bpf_link_put().

The error path uses kfree(link) directly, bypassing the bpf_link
refcount mechanism. Once the link is added to cgrp->bpf.struct_ops_links,
it becomes exposed to concurrent cgroup_bpf_release which can bump the
refcount. Direct kfree() ignores the additional reference and frees the
memory while the release work still holds a raw pointer.

In contrast, when the post-bpf_link_prime reg() failure occurs, the code
uses bpf_link_cleanup() and sets link = NULL, which is safe because it
relies on the refcount mechanism.

> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 876f6a81a9b6..b593ebb30a4e 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -307,12 +308,23 @@ static void cgroup_bpf_release(struct work_struct *work)
>  					       bpf.release_work);
>  	struct bpf_prog_array *old_array;
>  	struct list_head *storages = &cgrp->bpf.storages;
> +	struct bpf_struct_ops_link *st_link, *st_tmp;
>  	struct bpf_cgroup_storage *storage, *stmp;
> +	LIST_HEAD(st_links);
>
>  	unsigned int atype;
>
>  	cgroup_lock();
>
> +	list_splice_init(&cgrp->bpf.struct_ops_links, &st_links);
> +	list_for_each_entry_safe(st_link, st_tmp, &st_links, list) {
> +		st_link->cgroup = NULL;
> +		st_link->cgroup_removed = true;
> +		cgroup_put(cgrp);
> +		if (IS_ERR(bpf_link_inc_not_zero(&st_link->link)))
> +			list_del(&st_link->list);
> +	}

Does this loop have the correct ordering for concurrent link dealloc?

The first loop writes to st_link memory (st_link->cgroup = NULL,
st_link->cgroup_removed = true) before calling bpf_link_inc_not_zero()
to take a reference.

Meanwhile, if userspace closes the link FD and the refcount drops to 0,
bpf_struct_ops_map_link_dealloc() runs:

  bpf_struct_ops_map_link_dealloc():
    st_map->st_ops_desc->st_ops->unreg(&st_map->kvalue.data, link);
    if (st_link->cgroup)
      cgroup_bpf_detach_struct_ops(st_link->cgroup, st_link);
    kfree(st_link);

The dealloc path reads st_link->cgroup without holding cgroup_mutex.
If this read sees the NULL written by cgroup_bpf_release, dealloc skips
cgroup_bpf_detach_struct_ops() and proceeds to kfree(st_link).

At that point, cgroup_bpf_release continues and performs use-after-free
on the freed st_link memory:

  st_link->cgroup_removed = true         // UAF write
  bpf_link_inc_not_zero(&st_link->link)  // UAF atomic on freed memory
  list_del(&st_link->list)               // UAF / list corruption

The link is on cgrp->bpf.struct_ops_links but list membership does not
increment the link refcount. The cgroup_lock would only synchronize the
dealloc path if dealloc unconditionally took it, but dealloc takes
cgroup_lock conditionally on (st_link->cgroup), which the racing writer
just nulled.

Would it be safer to call bpf_link_inc_not_zero() first before touching
st_link's other fields?

> @@ -2755,3 +2773,31 @@ cgroup_common_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +void cgroup_bpf_detach_struct_ops(struct cgroup *cgrp,
> +				  struct bpf_struct_ops_link *link)
> +{
> +	cgroup_lock();
> +	if (link->cgroup == cgrp) {
> +		list_del(&link->list);
> +		link->cgroup = NULL;
> +		cgroup_put(cgrp);
> +	}
> +	cgroup_unlock();
> +}

Is the cgrp parameter needed in cgroup_bpf_attach_struct_ops() and
cgroup_bpf_detach_struct_ops()? Both Matt Bobrowski and Josh Don
suggested that both functions should operate on link->cgroup instead,
with a !link->cgroup being considered -EINVAL. Roman acknowledged with
'Ack' and 'Sure, good point' but the parameter was not removed.

Reference: https://lore.kernel.org/bpf/aXnyKw5sRt_MB-8A@google.com/


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26429228214
--===============2941777259395279126==--

