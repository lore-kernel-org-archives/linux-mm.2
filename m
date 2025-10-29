Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE8A4CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610D48E00F6; Wed, 29 Oct 2025 16:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1748E00B2; Wed, 29 Oct 2025 16:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D77B8E00F6; Wed, 29 Oct 2025 16:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 381D18E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:27:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA74989020
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:27:12 +0000 (UTC)
X-FDA: 84052286304.11.CBBD87F
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id D1F7240010
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:27:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uDvBTjFN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761769631; a=rsa-sha256;
	cv=none;
	b=YJDLU+YuNkbd8sRFPh1oGE/mQjnrKZ3QEXyNz/p32DOwqFxqmsxSFTWG+OtWkryFqVndFm
	+mMcCcOWNOe4G07dTemqr/tBl9QTiCuPB/U9ONJDIaMEL6ENpsHJqRnLjAh/zEYMOvrAjz
	1OPuYyo5JF7IKqjzaivKJNBMTY7L3a4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uDvBTjFN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761769631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5vmLW+oATPFNaWdtHY1yVME8el6pZeETE8QCtK8TCA=;
	b=hSWPFl3tSN11DAx5akH2W5stFR+eBWK0rQGBR236FnqDBzriplkhmgBPhH1HJ0rJxIjsQR
	2MyYj/+7bg6fKqePt+RawW7z4BNT8Zps6nfZrJ1mzqto3SFFQMD3mG9nZfF+SQ7wFPRsgJ
	9pgqlWlz9jqf1L5ciJmxuMN2bMZqmNk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761769626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L5vmLW+oATPFNaWdtHY1yVME8el6pZeETE8QCtK8TCA=;
	b=uDvBTjFNloStyK5QFb/yoXxdR2x9MXtvvx+VlwjlfcjJkJJCF/u4jP8Z1O8uvzIJVQei7i
	DLMoZGz0HxN1qz2OYh0rxnJZijSp4ZzRT5ISRcNxuFsImqMhMXzbscUzEIQ+vEupnezkGS
	jrYIMHJUDg0Es/IWmxMEqmpTQ0M5jVI=
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
Date: Wed, 29 Oct 2025 13:26:59 -0700
Message-ID: <87cy65e9nw.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D1F7240010
X-Stat-Signature: 5ikowjjd6bqnpijzds1sjtxoqn8rhtkg
X-HE-Tag: 1761769630-937292
X-HE-Meta: U2FsdGVkX19yu6z9o7c/6SIRnJdgNBCfA/URb0V5OVQm0bt2+qkT9ZUIjt1fKIlNiJ0J4rUB/HOJriP2JQOzuvFgK17hFMB7BwS+liTH68ueINGwfBKAcay14FLATQYgbbrM0K7Ko6/ev38VrSU04h9GhEVKoceXArJQ729r0M2QL90+1dlu1KF4fWwafcSAO35M0a7plfqF81otazrbCkvrMsK0/AaCJyTaQEzhJwjZvBO8C1FyoVkdJ64XHoEMH/rezxrTnyYwuST+Jv9jJDC7kyNaycEYge3oOT+F/q2WnSGfOwymLt4gBPaGtCRFSWPxhqRCZ7Z2uYoTshiPcZwSN/WAgML1nvTQd2KG7Lk3zVYtHI8vz2HNV0ftdKCZEx6ulSQBAVzXz6BaIjN4W9+owUZhGXNvE3KOLTivuxH5T38gtEOoAK/C9KlKbbJ6bsBIgG8fCd3An01TQ/48HUZNRtqhjpSmNofS5xnHZohHbDQDLXX7wd7BnbJR9Ycz0U2u6fEta2+W02xzOfQl80UJpws0RMfAHZKElTdKxhckRu0CFdCKRV4YZqeCQmOazMKt8CWUxfSoPqWEXpMglc0PJbDQAuEVs+n7OSwR6Fs3artdkZgk2dFfMst0kOf8aN38G34Y3Nrh/iTjKbrcrgd9zwsHzX6+dTmOiIcJT3ezGlIk9QBlSDkOHQVArUwJceR5A7/i3rM8e8W2UlDqZmBkcmCgVeSqLG/Th1tr4EXbmC+CYk62FNLAicUua1A2klBEZoKEsTiC4CIFv/bhXZjcaEC6nvk2hKjgf17M4Y6FZF0bSs6CKuxr1ZVoxBDCWSg8o2f4boiDCkCyFbAwdLNnqdBtMgqv73NuEW+IfVp94JcLT4Jrm6KkqbJJ6+Ajbdgvbl96g/s+2sSDGYA3hQzlOz6gpt96u9lbY6rfAaAnRNbmpTOY503DxDWB2vT23Am/tIXuSY0ldePzpf7
 x5ut/16q
 fVv4pmA5IHPu8G5xEDyp3HtRnxigOqPYX9jtr0k1RELKHAds5oqy22zE/Eam6A3VEr13tt90BzddZahwXKEqDtM3OZUa9QuXIhdUid6Sb3zoO8k71w4qEeEaOz7B2GwJSYECQgLHm6amJbT5KI8bO6D85Al6TdwDZrGf5XulgKGbcF7nJC+a3X+6WRxeX3KqFJ9pnu/ZD5+GFMukfTyGjbsyUr87wETgK7ptzEkAXqmo+o50=
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

Ok, thanks!

>
> Also, 0 is a valid fd, so we cannot use target_fd =3D=3D 0 to attach to
> global memcg.

Yep, switching to using root_memcg's fd instead.

Thanks!

