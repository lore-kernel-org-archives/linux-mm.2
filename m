Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83743CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 23:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B838E01E9; Thu, 30 Oct 2025 19:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1B4D8E006B; Thu, 30 Oct 2025 19:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E40B8E01E9; Thu, 30 Oct 2025 19:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 89B398E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:24:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E4F21402B9
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 23:24:26 +0000 (UTC)
X-FDA: 84056361732.30.89E727B
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 558E6100003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 23:24:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mfyFjY+x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761866664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFcFfa21Y8J0EvYjz5FYEa4biOxuGL1h90UpSLZ/vN0=;
	b=mmONZjXYFcteF6WfWbd9Fvryo7x7pY1VQ0ep/0wKoAWlVWlfH5t5/aLl87QsQ0MR1a5UQU
	QqbQYPfb0JEBvtLNaW80noKQnvjq3VzqtnuWcwKkC7odYnxip6HfgQQkK+rp1/fzJq0VEQ
	TF7EPh1maBXWZ1TJ0OWBlcfpzEgL0aE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mfyFjY+x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761866664; a=rsa-sha256;
	cv=none;
	b=NXzrPARJqBUAVnEmEX6d+btEzaCnSXJMatKDASLgQBQMq3ab5jYlnGsdIoZ204F7GybC9x
	oRwOOKzjRfLD2/0j0xp+2TgMDB0UFry/61tsfqk8zTvPFbyPZKmA4cRYAkqFTn1c2BYbIU
	CG31q2PqjUK2+W9jvbWAcdWieTW3zeQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761866662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vFcFfa21Y8J0EvYjz5FYEa4biOxuGL1h90UpSLZ/vN0=;
	b=mfyFjY+xuK5o/5m3QmAXgABGIwfeRaMj8f5cMWUmw2pAzfQT8LIKXkkjjjHK/fKnYyBZ7k
	81yKYEXTIfVNFD686cdiGUOIO4/FODITODwT1oQm33mRZNioDP2jq5kO1hi2ljt7DmY/+x
	d+7pG1L9EuwIC5HQqNbCGpdPnpfZspg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Amery Hung <ameryhung@gmail.com>,  Song Liu <song@kernel.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  LKML <linux-kernel@vger.kernel.org>,
  Alexei Starovoitov <ast@kernel.org>,  Suren Baghdasaryan
 <surenb@google.com>,  Michal Hocko <mhocko@kernel.org>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Johannes Weiner <hannes@cmpxchg.org>,  Andrii
 Nakryiko <andrii@kernel.org>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-mm <linux-mm@kvack.org>,  "open list:CONTROL GROUP (CGROUP)"
 <cgroups@vger.kernel.org>,  bpf <bpf@vger.kernel.org>,  Martin KaFai Lau
 <martin.lau@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,
  Tejun Heo <tj@kernel.org>
Subject: Re: bpf_st_ops and cgroups. Was: [PATCH v2 02/23] bpf: initial
 support for attaching struct ops to cgroups
In-Reply-To: <CAADnVQJGiH_yF=AoFSRy4zh20uneJgBfqGshubLM6aVq069Fhg@mail.gmail.com>
	(Alexei Starovoitov's message of "Thu, 30 Oct 2025 15:19:11 -0700")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-3-roman.gushchin@linux.dev>
	<CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
	<87zf98xq20.fsf@linux.dev>
	<CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
	<CAMB2axMkYS1j=KeECZQ9rnupP8kw7dn1LnGV4udxMp=f=qoEQA@mail.gmail.com>
	<877bwcus3h.fsf@linux.dev>
	<CAADnVQJGiH_yF=AoFSRy4zh20uneJgBfqGshubLM6aVq069Fhg@mail.gmail.com>
Date: Thu, 30 Oct 2025 16:24:15 -0700
Message-ID: <87bjloht28.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 558E6100003
X-Rspamd-Server: rspam03
X-Stat-Signature: qkk5du4a5iyd4b739znmq7gisszfc3qe
X-HE-Tag: 1761866664-775897
X-HE-Meta: U2FsdGVkX18W4hOIMtAiUdJeIC6OskpqgIkfTZ2MiWaa1zziesd9SIVi/87ThsWY9RoD/PtUTZWn2VAX3FhPXMp+33x0KLgfCHc7N/EtFzDxR9wVkDhIsq8btOdI6PWaZCZAIHzJPEgs+HUh9VGFTpJR8d+z38J1TYMyStuqMqezQkkH4LGt+S8cE65/VuIczD2LIkVQzsSSVMCnNw2GAeP/TIvi+IpwdfVlsVL3L3dhKeMAuiq6lXknCevSpT6BZ2+kmJtHVLKomSwDFLIlbvKUVkSY3gizfpMG9I/KTsW0VjLcNE5aK0OYcYpImYQMokCUvflblOxHko6GHUGt6prZLFqjYvDLa0y1S/1iwO2ue+pCx0uNNAGIOi9xF0J6bdH3J0Hrh/4WcXKugMQRNgudsEZD8EsmO8MSE03uBBIPtTeknkg7HZrKZZ60N17uaGu+hbgsgcLEz4G2/0QGULUPSCV9Wb7S0PLNvml5YGh/a0w6wvd8OYZPQID/5OnxL2eNjGRCdYRdhQriKuW+XGTd9UnSY737J6CpuabKDmixaraBkPYF7QyJRuXCj7L0pBkZcRgWhv6NMKc4P6osPq90UECzdihuWYJvcVcSa8Op9/oRmXH3ECiv/ZJ+3gIqyOHxhPk3jvyBp2RQMWkV6dYio6MdVvAJR4gWxEIlOFJebF8mdQDMdfZb1CbvHF/wUOjFDSCBh2OgoCTaHoQFvbLAyj9ulkIqzeCN9osmXx7jxbTsDQmrIL7r6Xm+3Xf54YSeeg7dMCoSfildr3X7P/ll85hyC9EY0QVhVz1nJKlTRWDBjSJlRIodLhagOghOYeOU+QzoBeeCqcAavU1hAPgupsga7ON8uWaGi4QrtF0CIPZP09q0XYuHz2SpS1D0h965b42DTH2YWFZt560j9qDlN5G0w0dHic9tcMT78gGKNdMGuuzeFFaEUMeFmrUSmwQZnGYIEDjlRLtG0a0
 eQ0lPkZL
 aGZtTHEf/fYEVIgE5R1I0yMoX/eKyAdrT1fax19ti2LsEYEE+UzgsJYB2SzhIFM7sCaJXY76+x1CVyexDNmitfkAFtYu95xF+pK1giur72CQWEXw4al4/rCLp85+fkpZ3cdP4gMcMS75Jl/0npb/yTrEo5VS3xR/+Jwpa2hoBvvmDcSmHW0ymLfNODyRO/SB56ODT2fUzxOkkAB2Fak+tKhiXj6JL7VgUnmSbMVU85UgXG3dlaupfCJsTEtcTvCR3oL6DTEFCR2JEUSx5Es9vKAJmA1oMsiiKwwjFlhz+07j+A3LhHrr3p44y6hQ5NuUn7Gu95tq4Qk81ijoixnJBmeH9Qcn/Y6uKyjNz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Oct 30, 2025 at 12:06=E2=80=AFPM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
>>
>> Ok, let me summarize the options we discussed here:
>>
>> 1) Make the attachment details (e.g. cgroup_id) the part of struct ops
>> itself. The attachment is happening at the reg() time.
>>
>>   +: It's convenient for complex stateful struct ops'es, because a
>>       single entity represents a combination of code and data.
>>   -: No way to attach a single struct ops to multiple entities.
>>
>> This approach is used by Tejun for per-cgroup sched_ext prototype.
>
> It's wrong. It should adopt bpf_struct_ops_link_create() approach
> and use attr->link_create.cgroup.relative_fd to attach.

This is basically what I have in v2, but Andrii and Song suggested that
I should use attr->link_create.target_fd instead.

I have a slight preference towards attr->link_create.cgroup.relative_fd
because it makes it clear that fd is a cgroup fd and potentially opens
a possibility to e.g. attach struct_ops to individual tasks and
cgroups, but I'm fine with both options.

Also, as Song pointed out, fd=3D=3D0 is in theory a valid target, so instea=
d of
using the "if (fd) {...}" check we might need a new flag. Idk if it
really makes sense to complicate the code for it.

Can we, please, decide on what's best here?

