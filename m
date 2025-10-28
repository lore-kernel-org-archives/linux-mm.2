Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EBA6CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 18:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E8EE801AE; Tue, 28 Oct 2025 14:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C03280199; Tue, 28 Oct 2025 14:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D667801AE; Tue, 28 Oct 2025 14:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4752080199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:32:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF418C0369
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:32:44 +0000 (UTC)
X-FDA: 84048369048.29.5D1C3B0
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1285DA0008
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:32:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hssVsn3Q;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761676363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nf6l5EBnraIwk2fFm2crn/UFRlvBCZhPypt0K7UxZjY=;
	b=IJ8FOI0cOn5UHDWGSeYm7WNAsunbWoZmeY97hyrLX2juazSIIa7lmBQCBqoiXeb0uv5RPV
	wwvdUdLLXsOzLpwRag9t0YqtbzVU//FnflFf2sVSjvSsUNf4skX9Vf7QTujvgGZYMJWNjh
	B4jbk3zGSJ+WWsBBFadVSu0/b9gXuy8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hssVsn3Q;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761676363; a=rsa-sha256;
	cv=none;
	b=CvgwN5ALymiXZ27URMuTNeYVX+4aZntEzK0vohQjquL8quUxQ4FJO+UktHAvpKWtzLbof8
	AGanFp5S8MGmGfL40pRGLe5dSSDVyucGkBkNXoNSrvxeh8I38euSEX9ClnPHazjYp7hQ3C
	xjTPO14i++e6SFHbFkQkONBK3BRlUz4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761676360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nf6l5EBnraIwk2fFm2crn/UFRlvBCZhPypt0K7UxZjY=;
	b=hssVsn3Q/lG0Ha8WD0NuxkPn5nIfYTE9daX6kZTPWtQkfcc3c5liTlrsaeobIK+I5u/Qsi
	5u5PKy2Fn5+Y3sy756yujLmcWPZCVTncPzc64DvnC8OzMF/k3zCALlzXU5oKmoAsWHtJ7d
	ssChMGvkIZRChpOs5U70e0V6baHPiU0=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Chris Mason <clm@meta.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
  bot+bpf-ci@kernel.org,  Andrew Morton <akpm@linux-foundation.org>,  LKML
 <linux-kernel@vger.kernel.org>,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko <andrii@kernel.org>,
  inwardvessel <inwardvessel@gmail.com>,  linux-mm <linux-mm@kvack.org>,
  "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,  bpf
 <bpf@vger.kernel.org>,  Martin KaFai Lau <martin.lau@kernel.org>,  Song
 Liu <song@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,  Tejun
 Heo <tj@kernel.org>,  Daniel Borkmann <daniel@iogearbox.net>,  Eduard
 <eddyz87@gmail.com>,  Yonghong Song <yonghong.song@linux.dev>,  Ihor
 Solodrai <ihor.solodrai@linux.dev>
Subject: Re: [PATCH v2 08/23] mm: introduce BPF kfuncs to deal with memcg
 pointers
In-Reply-To: <f5d71202-188d-45ff-a5e8-387d060fca47@meta.com> (Chris Mason's
	message of "Tue, 28 Oct 2025 14:03:18 -0400")
References: <20251027231727.472628-9-roman.gushchin@linux.dev>
	<2c91977fcab04be6305bf4be57e825f7e84005d16667adcdfad0585be506537c@mail.kernel.org>
	<87ldkv57nc.fsf@linux.dev>
	<CAADnVQLkza5_95qc0vGYBLUu-4FN_cZEcVywTs5XemTE9O-ZtQ@mail.gmail.com>
	<f5d71202-188d-45ff-a5e8-387d060fca47@meta.com>
Date: Tue, 28 Oct 2025 11:32:31 -0700
Message-ID: <87y0ouri68.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1285DA0008
X-Stat-Signature: fgbpyggkga9yo3ipm5cap7uatoik5kbe
X-Rspam-User: 
X-HE-Tag: 1761676362-46774
X-HE-Meta: U2FsdGVkX19jvUaiwCfdpUk10rFK1WGafd3omTcgrAeOLUqoT8FX//ogRzfGH0QzAoTmyC28uT2LZVEg7yJ7VFupvokTQ1Yt1osfsOfs1KgdAhsB9ho1VdGHK5ReOSq3WxLlAl60amUe+XljErQuPMHIfRUnyw+TB90R5/Vjx66gu347NCemGbYns/dhcBXWVDjE8nT5kwbeTaiX4HhH3TrqlsoMuxVHGkn+xu3Ke1qNgCFADyUFgdb+B+3Ria9SlNtpqfbM37D/qj+DI/BbVSTPgl3lRdTcWwGW0KDTmz7wQKNNXfPBeOpL7EGTn7hMphLF29ly0SVJboljBEp/9R0ZNW06HUKORNrlDcUK9TcIAtrFVy9cg3n04pbs+0Fqo5Qnl2Io4VZSMpfF9ReBg4Ju73j+lDEeFsgGx+GH4FfmkZlU5Isu5Qu/tNRmBWJ782yYckRZP/upxTMG59Eq8NZLpj2S3yZ+f/VbqD+FKbOrT9xqsIJ3yQ6Ls4AmHtM3yDjitBbcuNLRZJ4IBjnWOHEkMk+LyzOawzbTHv5ZUYAX/9BrLw6Oe8oPkWJ7midJwNGuOKvGGLEWyvUN1aGtMzv4wgvbSw9jH0aNtGmgf1VLooodf8bcKroJfQKLsSgSM0D6pjie2cvysWklA8w7ZXgX09uYFq/pJn3M6lfGYSkCMp8cFTD3DYASGyzZKmmUvyGXWs6Vj3YyW3J7BEPoREiWTmGuYjRUZ7fsH+aB//B2G0uJTqWgX5jM+uK0awo6VAhfKOB+p/Lie1hcF3LadVxfyE9KCtnv5dyXJd29y5OBC5YjowGIy3df1bUcG6NpeI5VKUUjSuIGMtTOcnqRhcJhXNuB84k3LdDnViM/A0BqFcyqwSiSGR3kYj7SrF5orNFrBkWEldfsYV6hRbke7+N8rKP4JPnnKj25M+iOkeqpe9aM1+5FtCWv74+Kmhmv/nrw9F3/lnV7hbL7g+A
 dPviv7xH
 ctmG9jGXr/sudUMHu/lxc+1gonhEBBW1ECCanQVQzx/hwjvCYsCH6Vs2qB/JHODsxp3x2Re+81pHv/4RlonoPWTy7U8m3jP8iVY1h8lo2kGSJHhbL1+n9RK/8kE+Hwk2t4JOPb0h3WjbJy7tCsEfCLqSs9OhtG9FMZejdGl4Wzmp83NUAizQywOvzNn9AhI/uhk8Etwqqy6DdqDLNglxWOs5hfDluXhiieu2srKCekYMP7IAs/8R5FGoNw1TtnR2NLVX/CbXr7lrnHxAKsItfMpEZEfAa+BjVRWw70YvtJwnBa30Sol40pZj7SpYydSIPP++bSNUKmqbC8v5Zm3SitJHiZmugECHmadEp5SiBrvlbkmq79VhsCdEdRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chris Mason <clm@meta.com> writes:

> On 10/28/25 1:12 PM, Alexei Starovoitov wrote:
>> On Tue, Oct 28, 2025 at 9:11=E2=80=AFAM Roman Gushchin <roman.gushchin@l=
inux.dev> wrote:
>>>
>>> bot+bpf-ci@kernel.org writes:
>>>
>>>> ```
>>>> commit ec8e2e1769704b4f69261f36e6aaf035d47c5f0f
>>>> Author: Roman Gushchin <roman.gushchin@linux.dev>
>>>> Can this dereference a NULL css pointer?  The function checks css for
>>>> NULL at line 42 with "if (css && css_tryget(css))", which suggests css
>>>> can be NULL.  If a BPF program calls this function with a NULL css,
>>>> wouldn't it crash here before reaching that check?
>>>
>>> Here css passed as an argument to bpf_get_mem_cgroup() can't be NULL,
>>> because the BPF verifier guarantees that it's a valid css pointer.
>>>
>>> However the result of rcu_dereference_raw(cgroup->subsys[ssid]) can be
>>> NULL, this is why the "if (css && css_tryget(css))" check is required
>>> down below.
>>=20
>> Yeah. Not sure how feasible it is to teach AI about KF_RCU semantics.
>
> I pulled it down locally to try and w/semcode it is properly catching thi=
s:
>
> False Positives Eliminated
>
> 1. EH-001 NULL dereference - css parameter dereferenced without check
>
> - Why false positive: BPF verifier ensures pointer parameters are
> non-NULL. All kernel kfuncs follow the same pattern of not checking
> parameters for NULL (css_rstat_updated, css_rstat_flush,
> bpf_put_mem_cgroup, etc.). The KF_RET_NULL flag controls return value,
> not parameter nullability.
>
> My plan is to just have the prompt read Documentation/bpf/kfuncs.rst,
> which Eduard suggested.  I'll make a bpf kfuncs pattern and do that.

Awesome, thank you!

