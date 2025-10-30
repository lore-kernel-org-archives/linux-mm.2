Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FBDCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 17:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13F08E014E; Thu, 30 Oct 2025 13:22:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB4A8E0089; Thu, 30 Oct 2025 13:22:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927E58E014E; Thu, 30 Oct 2025 13:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 811A78E0089
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:22:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 302BE1A0222
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:22:44 +0000 (UTC)
X-FDA: 84055450248.15.34065E8
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2FE0C40002
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:22:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fRYib/kM";
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761844962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yKUVg2QX7KLyptUjcVniVMmwZzulWf6rl33AVF5l/o=;
	b=AXOtlrSPPKFzp8z55pXT4sdOk6nkEuNYgV8ehWpkfzXeRrGih+UnQE7cGaXfZKZYBA/RmU
	ede4s1lwvvvpo7RY/LgikH5IuMqNNOAfDoGNDcXPsETNfN189dPtGz+ipDGJxzux/lUIqx
	vxfETdaSAfdKQ/s9khJNwHc2RDCb2As=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fRYib/kM";
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761844962; a=rsa-sha256;
	cv=none;
	b=NbuOmbmKGQ8mkIFXeewyHAQ14LU6vgqySWGAmxoZijhgH/MsnfD8Lp3ALJ9J7wfXPpEdbj
	UlGK5PGKf1fBS6jgdIDG7S5GDc5SGHESMgKTYNYYktZqj2teyNuJCKl7LvXC/BFiQoGE1p
	i7HmwmvEUKVtw5YIRcHR0VAu6oqJr1w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761844959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1yKUVg2QX7KLyptUjcVniVMmwZzulWf6rl33AVF5l/o=;
	b=fRYib/kMeIDOH90ZS1ch2yNi5D8QUkaH4tedw7Z/hSbGGXrRmdrIpZ8M9Y/J8qtzjFwMqj
	yOKKjjMwh9zn0bUKfvhmXdxn7jOOZaENuw1uvt38qHMAoafwoGb86QAtAWCbFkqIJfFVC+
	6SEitYt7Mlk0NycoOGJBAnM9Rn6cvbE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Song Liu <song@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko <andrii@kernel.org>,  JP
 Kobryn <inwardvessel@gmail.com>,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  bpf@vger.kernel.org,  Martin KaFai Lau
 <martin.lau@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,
  Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops
 to cgroups
In-Reply-To: <CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
	(Song Liu's message of "Wed, 29 Oct 2025 11:01:00 -0700")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-3-roman.gushchin@linux.dev>
	<CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
Date: Thu, 30 Oct 2025 10:22:31 -0700
Message-ID: <87zf98xq20.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2FE0C40002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: pepfg6qkb3npi6a54if4nsewwyds59ji
X-HE-Tag: 1761844961-893745
X-HE-Meta: U2FsdGVkX18Vvl2l4bmBdNy47gtyVJPVbd5h83FRqY6UJiXQ5jflevls22o74gFHFiU2CsiuO27cbDPkzEAa87GSrQ/T29bNToZQC52Tg6/XemLOWJNXOZSd+MmiIHR/ath3HPPfRIUWkuOkFgLsxuHHxPoyXNJaOGfEPI2caftqREyRKCSeyNEyc3cGoQkLHLcBU2ENFvQw7PFIBmQZXn3iZ+duDaZru0yXxObdjzqZMfwsyL7x9/nqbEYlLagx0xuRAwNflGOz/2h0JMmchmel7Vzxc+lDadYntRGY7YfCmuhYxm5gjy2KkDIzIB9q9XGXYYQZUEyiLkfOdf4gB1CjmXd6Q5BGyq78kH05zTcgMAUt7BCY/AQOMt7h+1h+1R+nOvasrOtpJ3zofW2h7WUeFpZKgm+7hL3h5++umwENBLgskOYdNgF5OvHiuFufLmah5eOCjQ6WeDNlDg4buSLfdNh/yx9Pa92gfXJWm/AOSGyA7gkk/FB0qWp3eRDjJ9UgBWifztK/eikx+znn5VTMuyEuYjcj3BbQQhMa/DKi6uwL3n8LxUpeyeddDmzsjJv4LYj1jBvMa5ueB+ZHXdnAuQqB+xmtyxZFwVfvca8xaUpbfS0jnRocQ3KtXilzotMfat2+nQ2i0E2Vx41y6eRKtrvWRtdrxf04dAeUxLldxLOZcx+yG1Tt+W4lwEeYUeyueduosk5kUEMvX1ce1cOb0yBhjdXrN6S52PCdACUUBoQ05xtnMEt5ZcksDqjH5ct+XQwkGRPqg9swlH7ljFTLNJy46cqDIrSol77ttsMO8aNH+jtp6Q3Urmr79lVQ/utmSMd84bHCfxRgiC9NU4zgCDsZeOi/XAXoBq6h66kaC8LwlPfND2h/tIARbQS07Yc/4chJ07t8wig2FJgREXMnF1lZaoc7XfsMDuLP2kJ6pL5gwM3wJCUypBAGl/vLYvvyMA/k7yINqwTj5+0
 /wG8PSqI
 Teoyej78z0sYdZ0XUbHygVy/MKh4nSkwiDxW4pmK+EA77b0RofdT1v2c/cx4T5TyTU84rkkxIFl15rph+dcO/2Cc75Fo1+30MH/k+2DG/utazwkPrrpxSaQtHen2ZZUcE0GZmNjG60KRDK8ZSc+iIFv+swucVYG5RBSsdxXwpTBAceLDEwUoWhG3luocHf1OUuLj+/NB8mi3Gu3QA46akm7iI3V8dTLVwFnZQqx/iHcbvXR8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Song Liu <song@kernel.org> writes:

> On Mon, Oct 27, 2025 at 4:17=E2=80=AFPM Roman Gushchin <roman.gushchin@li=
nux.dev> wrote:
> [...]
>>  struct bpf_struct_ops_value {
>>         struct bpf_struct_ops_common_value common;
>> @@ -1359,6 +1360,18 @@ int bpf_struct_ops_link_create(union bpf_attr *at=
tr)
>>         }
>>         bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct=
_ops_map_lops, NULL,
>>                       attr->link_create.attach_type);
>> +#ifdef CONFIG_CGROUPS
>> +       if (attr->link_create.cgroup.relative_fd) {
>> +               struct cgroup *cgrp;
>> +
>> +               cgrp =3D cgroup_get_from_fd(attr->link_create.cgroup.rel=
ative_fd);
>
> We should use "target_fd" here, not relative_fd.
>
> Also, 0 is a valid fd, so we cannot use target_fd =3D=3D 0 to attach to
> global memcg.

Yep, but then we need somehow signal there is a cgroup fd passed,
so that struct ops'es which are not attached to cgroups keep working
as previously. And we can't use link_create.attach_type.

Should I use link_create.flags? E.g. something like add new flag

@@ -1224,6 +1224,7 @@ enum bpf_perf_event_type {
 #define BPF_F_AFTER		(1U << 4)
 #define BPF_F_ID		(1U << 5)
 #define BPF_F_PREORDER		(1U << 6)
+#define BPF_F_CGROUP		(1U << 7)
 #define BPF_F_LINK		BPF_F_LINK /* 1 << 13 */
=20
 /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the

and then do something like this:

int bpf_struct_ops_link_create(union bpf_attr *attr)
{
	<...>
	if (attr->link_create.flags & BPF_F_CGROUP) {
		struct cgroup *cgrp;

		cgrp =3D cgroup_get_from_fd(attr->link_create.target_fd);
		if (IS_ERR(cgrp)) {
			err =3D PTR_ERR(cgrp);
			goto err_out;
		}

		link->cgroup_id =3D cgroup_id(cgrp);
		cgroup_put(cgrp);
	}

Does it sound right?

Thanks

