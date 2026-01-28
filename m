Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96E34D46BEB
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 18:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682BE6B0005; Wed, 28 Jan 2026 13:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664596B0089; Wed, 28 Jan 2026 13:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53BC56B008A; Wed, 28 Jan 2026 13:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41DFF6B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:52:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8C861407A8
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:52:15 +0000 (UTC)
X-FDA: 84382267830.02.4D01416
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id E249C20009
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:52:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ty4s7Yoo;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769626334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CfgweDiPW3wgT8f/jWDWaNU2yLUPwXceZe08po6uplY=;
	b=errlTyu/Zczw38plkLCkyQn8agkNWR47aGkEQ+HHfX5M6pywEkqiS07/YkYSE95b+QLG33
	4Esb+/8Wbo8YPA1GhbNTWMFq1FWDMBNO6z2ymwz95I5oTN3oIBNO77ir4cToVDVflIXx/B
	p/MeBO+2DHbvNmXKSebDNornCeDFG+M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ty4s7Yoo;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769626334; a=rsa-sha256;
	cv=none;
	b=zX2REHDop7Bq24DlN85CqvXd60bGTWDZPxO/xOVScNUSz/2f236f1LZlkFF1mO9eZDEegH
	V6nnV8SFdI1QvqsRgPm6TGfDgaOZQrafQ4UaL7rBuOc7+Iqi1iBcHfRMesuNDNdZeXWDMw
	lvCmTqvD5SLHt3d2PFnTKOOWiK9zrqQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769626331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CfgweDiPW3wgT8f/jWDWaNU2yLUPwXceZe08po6uplY=;
	b=ty4s7YoohM67YP8T9nnixgYuzM2FfMNOijhQULCX0p68d1BLFELww25talGKOrg3n9J0dB
	wEZxDRBMN+5Hew/a8UYrJPkcKADMy5vRbbgfurnAeqg6w479aYDM9rMJx1Qs6I9AEkfOjN
	luA28aNrV3DSup1lweSqg9XprkhkqxY=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Josh Don <joshdon@google.com>
Cc: bpf@vger.kernel.org,  Michal Hocko <mhocko@suse.com>,  Alexei
 Starovoitov <ast@kernel.org>,  Matt Bobrowski <mattbobrowski@google.com>,
  Shakeel Butt <shakeel.butt@linux.dev>,  JP Kobryn
 <inwardvessel@gmail.com>,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  Suren Baghdasaryan <surenb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 02/17] bpf: allow attaching struct_ops to
 cgroups
In-Reply-To: <CABk29NvS+4F-a=Z7Jp27OUZCJ2YUWR3LJcwT-NBoWYAK8JeCEg@mail.gmail.com>
	(Josh Don's message of "Tue, 27 Jan 2026 19:10:35 -0800")
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
	<20260127024421.494929-3-roman.gushchin@linux.dev>
	<CABk29NvS+4F-a=Z7Jp27OUZCJ2YUWR3LJcwT-NBoWYAK8JeCEg@mail.gmail.com>
Date: Wed, 28 Jan 2026 10:52:05 -0800
Message-ID: <87a4xx1sfe.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E249C20009
X-Stat-Signature: bdepdesa5zfuywms11irkggyb76y6u4c
X-Rspam-User: 
X-HE-Tag: 1769626333-277271
X-HE-Meta: U2FsdGVkX1/v3ty6xd9RDfLqTGeYwrgL3jDp/sqjWJpYruPMQgZvQVbKc/tAe5bj67rxArLOCLY2flr+KXjFZm3QfgZCBUVklIeo30HYLYYLkduMy4/YZEt1eQm/U/p3IlXo4+PyY/pCDpMjfX/yXuwiQPZY5Hm5GUgGlywCxS6dGaGO4H3dyY/EMvETOPDNq+mBzZ4DFBc/u472Na9QR9OTvI90+NGpuAy4c3yisxRBa6qixc3MotwxCmHQc8EeJsf/+VDh6g1I60aAkSBpZBAdjzFkKMNWLMNaULF0oQQ8e63oYAIqdpJX6BgvFUeKEzkLIYrPmQECYeW3LE2DYJgBvGOSglYCUYy7t+f4XTNTT6zghra16FSjXgGFbTLRKTwHFGNPb6NMG7r1Xo3RigVmdDuwPG6ekoVjcpKQwUVR7NKPVgBIDDGAKIvx4v3Fb68Mujfmx7aVYhMYoVNzBIKAUg5+S2yAY8pa0lcqRXoLTMmCZjzgEuGjCrtEcGYjuDeb7yVBesatVa8O6abHYmdJ3HpsCEIhi7qQATkpJ03M3SyLPskpbDGBuqSEkzX03hOrfBdvG22+kSE/tceA04efJtnlsOh/9pT/lAMqt4f+wx1QdNe5V1OV83sjFVgWDT0RW3xRAXppxa5nLS5q2gvtQQsIXrpF558ex2rurxuDOGj3XesECWbWRoIP357dKle1PxRlSVMbUcd3wegQylJkJ+Z07ig767M8DzJxXi186r91Ms4OuckavS3jdIQQx5c9Q5fg2bV2mjH3M0SazCa5fKozvoN+32vIbDg0aKwsxySxmILYdmxQvYgRV2PTen80/FSOxaLRTqNIcWdife/5AyLl2HHJ7nTd3mQwpMwdPKAtEnM0R5ArmoihN4X5a3RGBu3fs0+wp9tAa7vLo7rZjWlVEYCfjc2mlwzfVxqKc41Gn8nTvYLg+UI06rxqScRAyBZhch3B893l6pd
 lTQYRb0J
 h61zwfP6iB1MVfrTnqqJ8aGHB8DRhZcw/lh3y2s7W4iBp6PLOACPmuwNuE4Lio2G9NbInRgPvjSCWUjtuBoZWV937XdOvDf/Q3TMG+Ul2BDwCnroDk+Iv/O1ortOa8HQP+BWF6DM6giaRGXp/24N/uXjcIATJew8h8KUs2Md4X3GoDO4mXZsbp1PlbLpsapn+nUZJptXaC4opL33gOLSQBo86Rb8TRGy7Ev7YXgep2erZC8R3mz9Rl2EvYTF+68s1tG/ssoQgs3G9qqPqP2bcRB3wQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Josh Don <joshdon@google.com> writes:

> Hi Roman,
>
> On Mon, Jan 26, 2026 at 6:50=E2=80=AFPM Roman Gushchin <roman.gushchin@li=
nux.dev> wrote:
>>
>> Introduce an ability to attach bpf struct_ops'es to cgroups.
>>
> [snip]
>>  struct bpf_struct_ops_value {
>>         struct bpf_struct_ops_common_value common;
>> @@ -1220,6 +1222,10 @@ static void bpf_struct_ops_map_link_dealloc(struc=
t bpf_link *link)
>>                 st_map->st_ops_desc->st_ops->unreg(&st_map->kvalue.data,=
 link);
>>                 bpf_map_put(&st_map->map);
>>         }
>> +
>> +       if (st_link->cgroup)
>> +               cgroup_bpf_detach_struct_ops(st_link->cgroup, st_link);
>> +

Hi Josh!

>
> I was worried about concurrency with cgroup ops until I saw
> cgroup_bpf_detach_struct_ops() takes cgroup_lock() internally (since
> you take it inline sometimes below I falsely assumed it wasn't
> present). In any case, I'm wondering why you need to pass in the
> cgroup pointer to cgroup_bpf_detach_struct_ops() at all, rather than
> just the link?

Sure, good point.

>> @@ -1357,8 +1386,12 @@ int bpf_struct_ops_link_create(union bpf_attr *at=
tr)
>>         struct bpf_link_primer link_primer;
>>         struct bpf_struct_ops_map *st_map;
>>         struct bpf_map *map;
>> +       struct cgroup *cgrp;
>>         int err;
>>
>> +       if (attr->link_create.flags & ~BPF_F_CGROUP_FD)
>> +               return -EINVAL;
>> +
>>         map =3D bpf_map_get(attr->link_create.map_fd);
>>         if (IS_ERR(map))
>>                 return PTR_ERR(map);
>> @@ -1378,11 +1411,26 @@ int bpf_struct_ops_link_create(union bpf_attr *a=
ttr)
>>         bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct=
_ops_map_lops, NULL,
>>                       attr->link_create.attach_type);
>>
>> +       init_waitqueue_head(&link->wait_hup);
>> +
>> +       if (attr->link_create.flags & BPF_F_CGROUP_FD) {
>> +               cgrp =3D cgroup_get_from_fd(attr->link_create.target_fd);
>> +               if (IS_ERR(cgrp)) {
>> +                       err =3D PTR_ERR(cgrp);
>> +                       goto err_out;
>> +               }
>> +               link->cgroup =3D cgrp;
>> +               err =3D cgroup_bpf_attach_struct_ops(cgrp, link);
>
> We have to be careful at this point. cgroup release could now occur
> concurrently which would clear link->cgroup. Maybe worth a comment
> here since this is a bit subtle.

Agree, will add.

Thanks!

