Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00EA2D72361
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566EA6B048A; Fri, 23 Jan 2026 04:19:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9F06B048C; Fri, 23 Jan 2026 04:19:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FBCF6B048D; Fri, 23 Jan 2026 04:19:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB696B048A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:19:09 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E51CAC1628
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:19:08 +0000 (UTC)
X-FDA: 84362679576.22.6C815C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6552920009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:19:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b="InW/yky3";
	spf=pass (imf03.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769159947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3qsbcDpqhWS+BMvgDhRavq/+1aaBrGQUhD1vQmP8HZc=;
	b=u21AtwDvuMcwEhPosXL5Zc92fVNDiVxfv2lHMfXOSv30ciul66HdQhLijc78IyxQCE0qNn
	GuBHPM5OHKZF38s8LsEMTHhDIXeFaGe6Qlw6JUOnRUxtcU+hrzFwpLSDLODPROcjLaFsgW
	Ua8/DmOvZAftajnP5k/Bw1p+4VB5JWQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b="InW/yky3";
	spf=pass (imf03.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769159947; a=rsa-sha256;
	cv=none;
	b=MfUP6zh8Yahz9HTYMCMDgRysjgTW9dCkuM4uUpx5noPlY+r1K4/mTTUDw8mpAkXFdN80Qi
	P/0KazsVmU5Tsg5SbTAuZzFGYBYaQN3APxczCKCiXJ8uCWY6hd1/nnqRw1OB+C/HxShUCI
	ncA5GeVwcH4DiYOL5D/oWOHUPJRJQzk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 706E54454A;
	Fri, 23 Jan 2026 09:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D6FC19422;
	Fri, 23 Jan 2026 09:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769159946;
	bh=++ck5HBZpMPSGGpoonSSzPKOjTBgq1xO2oJuGzY5lWE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=InW/yky3spHD+VBL/Qubq9HdIWp1bq9AGY9a5aZ2YmU+pKqOnipVCfNDJt14vOnFo
	 9Ft2oZDTviiR/bowI6zlIWddMT8I5Ul7/TZjzSq3JSZd1SYjENW4vkO7jIvqbMaawn
	 ZibHjAyS5VJ3/jb4FYoyWyCYRBVcqkQs1KNNTLluXVTdzOG+9IifYB1/nsbs00FAEO
	 4ubr6fqhaf0Ta0LmzkjnYVMYIyxIE8RQaBGp9BoMpXuBsCGu5egLFcs/4p21F10B67
	 jBlGYrsbfePzLz78Gmx5Qsgj6QPP10wXwijDTMui34uAx8ZMNJVrrAfd8OWAU3eX0T
	 cQcdYe91kgOwA==
Content-Type: multipart/mixed; boundary="===============0725732639387219158=="
MIME-Version: 1.0
Message-Id: <b0f009e6e0f8ec688597c5c3954b3335069f3aa60441a7c3f44246af7a9c4629@mail.kernel.org>
In-Reply-To: <e34da0fc270eb7cc41f6b388026f503799541675.1769157382.git.zhuhui@kylinos.cn>
References: <e34da0fc270eb7cc41f6b388026f503799541675.1769157382.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v3 02/12] bpf: initial support for attaching struct ops to cgroups
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev, akpm@linux-foundation.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com,
	song@kernel.org, yonghong.song@linux.dev, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@fomichev.me, haoluo@google.com,
	jolsa@kernel.org, shuah@kernel.org, peterz@infradead.org,
	ojeda@kernel.org, nathan@kernel.org, kees@kernel.org, tj@kernel.org,
	jeffxu@chromium.org, mkoutny@suse.com, kernel@jfarr.cc,
	brauner@kernel.org, rdunlap@infradead.org, brgerst@gmail.com,
	masahiroy@kernel.org, davem@davemloft.net, kuba@kernel.org,
	hawk@kernel.org, inwardvessel@gmail.com, willemb@google.com,
	kerneljasonxing@gmail.com, paul.chaignon@gmail.com,
	a.s.protopopov@gmail.com, ameryhung@gmail.com,
	chenridong@huaweicloud.com, lance.yang@linux.dev,
	jiayuan.chen@linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org,
	netdev@vger.kernel.org, linu@kvack.org, x-kselftest@vger.kernel.org
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 23 Jan 2026 09:19:05 +0000 (UTC)
X-Stat-Signature: 5s6qnffa9xamjdwcyzg9zyyfjisea6fd
X-Rspamd-Queue-Id: 6552920009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769159947-77637
X-HE-Meta: U2FsdGVkX1+hZI2FLOtCkuChpEEoAMn5/HakiIoaxb9zP0dx4Oq+uShoZ9TVzhJyW7uR6j91LfcgZHUtzPGgI0fMM4wCNX+xpq/Jf2fw3apwhz3Jzp3CLotdMfnW9K4NagSMSgJLm64TzTtURu2+PzxZ0ksUBKq7TEMUkQ5JhS5WFA/UjHaD76trB+3HLvqqJbDzcrqt/r+ZPe36EWHUg7xGEnieDPzpn5Ld/UfjgOaqKc6K0sGi+e3ul5aP2Xo06tBa183SNMIVB5U0KGlxBPxar+1USef0fZdL+kiiWeEfoAN6K+mf2OWF3Uq+vmBw/Em+VXGw62uGqCmsaoN5mH/3hRd/hYJSnNO0ZxI1+eyNyEdhZZpVPhtjUGZR9Hp+xQPxk8EQO+zX79p1EteaktFoUuy3Vy2B0rMVtJ7T4pb4nq2IMOcCZRpEjkxgWHGK1b427K5MB/I6mtf9b7HH7Z76wp8/n2Ul8tl6xdpAy+h26c3gHEiikY0uvey6t2k+2ddVXaepHalT3IlHuHdoQeB/PuhNceCFd5UO9NWSSBpVBXuu4McLgQzKkZfaSzMbo1wUusQv+RZe+6Sw5VmQjFnpwllzB6CF4YXRYsac2vjV4Yu7lC6u3TrxKPvJozhqFQBhEfuTHAEyy7tWPUim3DOwqn5BZcMYCuTTWgnM9sZojWjvYCzy+uoApxR4z16KGH86gCtr3X0OQdNmrKyWqHT3KOcOixBjumlmYB2inq1aFVbhvqhCzEZ6jOomMLg8jcJ9SfFgvydvoKadyYwJPTjmJZRhNNqxM2+0PdMrKgZoXrj5fqUuTey0DSXpkeqjeTpaTaV9peqkH/j14FU2asXMkVsr3/wAVtC0nirYV5LOOK6cKzKHgzhRCD8SIQ7dCt/1vqXYg+1JoAhVVH+VcjvDu3OlnSK6x1re3KTY3rJA6sqPivROeo/hj/RtwTPyNlBSntDX63NPlLiAaHq
 kO04QLtG
 7JuVW6Kc/Mwg2vUFjyNyo0zzHEqCYpiXDM5Zrhc0ydRQ+kSXCoG+yJUxacqmloQ0fLlbFJ1D2wOKV+vYhGX0/t8E0/LpalDLcUfRyf+8JzFKB8ua6sUMZFTIuAM1ThPwE0KJBGsIBCxOjmnM3LdfAEOizjRuG4jCp3lLlh4JOU4ACdSbWrX8gipuwPDSOWj7jE/hV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0725732639387219158==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
> index de01cf3025b3..f575c5cd0dc8 100644

[ ... ]

> @@ -1377,6 +1378,18 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
>  	}
>  	bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct_ops_map_lops, NULL,
>  		      attr->link_create.attach_type);
> +#ifdef CONFIG_CGROUPS
> +	if (attr->link_create.cgroup.relative_fd) {
> +		struct cgroup *cgrp;
> +
> +		cgrp = cgroup_get_from_fd(attr->link_create.cgroup.relative_fd);
> +		if (IS_ERR(cgrp))
> +			return PTR_ERR(cgrp);
                        ^^^^^^^^^^^^^^^^^

When cgroup_get_from_fd() fails, this returns directly without cleaning
up. At this point in bpf_struct_ops_link_create(), link has already been
allocated via kzalloc() and map has a reference from bpf_map_get().

Should this use goto err_out instead? The err_out label calls
bpf_map_put(map) and kfree(link), which would be needed here but are
bypassed by the direct return.

> +
> +		link->cgroup_id = cgroup_id(cgrp);
> +		cgroup_put(cgrp);
> +	}
> +#endif /* CONFIG_CGROUPS */
>
>  	err = bpf_link_prime(&link->link, &link_primer);
>  	if (err)


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21280790825

--===============0725732639387219158==--

