Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B039DCCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 23:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DE08E0009; Mon,  6 Oct 2025 19:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E638E0002; Mon,  6 Oct 2025 19:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 834778E0009; Mon,  6 Oct 2025 19:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72E3E8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 19:52:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1D37458EE
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:52:39 +0000 (UTC)
X-FDA: 83969341638.28.43170EF
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 31208100006
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:52:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JCQ2UMea;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759794758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCUKFNV9pB2HHiGXvox0lNS0cxJuEqyCXiERPvgsXT4=;
	b=Wl3hRcN34j15nEDsgYRdBN3It+A6QrKqhfGkQztbF3z5hZeBQweAPT2wh4Xp2cB7e7y+Yl
	3WZCZopPkUquJh/hT87ym+nwEGiw+S0GdhIEnYlnUZtj4GQ+zGVYqZXcCOrk5dcKTEKLBV
	MoBVQ1lRlHHP5224CyGSSyiDDPunlpM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759794758; a=rsa-sha256;
	cv=none;
	b=HXx40H483+hUXW4tXIHi6Ix9J7VTwRxxZPK+ty5EZmACDZrURl4R9slwkV1Du1t9zA2VRI
	7G7aAjN74EGtXupQifYdrkoDF038JYoxFcMPqdQVIWT3Vdx298PEkffADu7fJhGLt4Vz19
	l9HZV6KsqtMWYDfazpZL+IR5K2QcGHg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JCQ2UMea;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759794756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WCUKFNV9pB2HHiGXvox0lNS0cxJuEqyCXiERPvgsXT4=;
	b=JCQ2UMea2wNbBv+MsAu1MjQcoFWbbExLj4kIDJJ3yije2EJP5s/UKafwWfgrhCH52KkRrn
	fCeFW0gYdQSat/OfaAQL3jGUClrKvovbnWe2a8uj5S4jl+VkKqQ/WscTZGcnZIoIegSRtN
	bo2rFN2ywB5fu9PKFArPOXAjoOibACI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>,  Alexei Starovoitov
 <alexei.starovoitov@gmail.com>,  Kumar Kartikeya Dwivedi
 <memxor@gmail.com>,  linux-mm <linux-mm@kvack.org>,  bpf
 <bpf@vger.kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David
 Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
In-Reply-To: <CAEf4BzafXv-PstSAP6krers=S74ri1+zTB4Y2oT6f+33yznqsA@mail.gmail.com>
	(Andrii Nakryiko's message of "Mon, 6 Oct 2025 16:21:24 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-2-roman.gushchin@linux.dev>
	<CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
	<87ms7tldwo.fsf@linux.dev>
	<1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
	<87wm6rwd4d.fsf@linux.dev>
	<ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
	<CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
	<87iki0n4lm.fsf@linux.dev>
	<a76ad1e9-07d5-4ba1-83e4-22fe36a32df0@linux.dev>
	<877bxb77eh.fsf@linux.dev>
	<CAEf4BzafXv-PstSAP6krers=S74ri1+zTB4Y2oT6f+33yznqsA@mail.gmail.com>
Date: Mon, 06 Oct 2025 16:52:26 -0700
Message-ID: <871pnfk2px.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: pmjjq1uyqfxan3fdwj1ss5metknwuff8
X-Rspam-User: 
X-Rspamd-Queue-Id: 31208100006
X-HE-Tag: 1759794757-541633
X-HE-Meta: U2FsdGVkX19ynJa0iMW6ImNa/3VMVX6w194FVkmB9qKKK/FM+YloNfMYGZniwC32T/nLrrzXAQPRqo/mj/7VdNSjTZPbEGBQgj+FsxL4CgkUyCiO1maPWyx8ZJeGNgOvSelvn8Z8btTvmqXxpi2ojPUC/i7zzw5r7JZ1Ujnk9l4ON+EPkptArdnvnTk99QpVURM3F5DdShoSNRY/4kKpBx+Vq98q+G2SIT5FbiMfa3kTkVv6p3EA91vfCCUkrQg73mNG0zO6JpQMUWKGe0W0WubL//XgHIgcrB7OFD6STn0Zq2CnuSJwL9mGiLeGe96ANQMR6Laq2YDncEpc8ANLYndb6/DPeu9yPMuR+5VWVrhiAo0ZW3Hpftholm1aPlfrSjG1pqXrzr1X6hw5BkCsqY5VGLV5btrvTmKo0SLGl2vV1E7regqsOrfeDkj8gRMgXyghB+zH//RBfmqKhSupIaquZ7j2PzfG9QP4EIPjVJrmMOwwNAMlMuqelODwla3fYU7Jh0HnriQzMpY8bHws9LUHa7QgIo9ZkaNdmOGmyKioCLnoPboPnBo9QyClRwfHzVERNSBTgvR4Z4N2oDShkOof3OxeyXkstG51h/OOFHCToZeSmzQiB/P/9wtges23Gx7c7j0LaUm+tiIVUn4Acbf5xI33AUd47cpx0ixUV1aTRv0Pal9O+DLEiw2P+dkcgOrBx70J//wjqQItaZUEz3QE/0I7qiFym4pJB07nalslTsFzraxu7rXQJ8rI5V1eLAIzq7eGBy87j6VLJNG55ywz1jXAf3b/z1FPVKjy0uEEET/RfbEqSooUhHIDHdUCEZdO4Cdm/T8dA0ihRvpIbmOzpfh6flLRQih1oNIhCT+VBLoabHm4+j7w+vX1QdzeZKkUyPEi+31g7cRchKGMQXQL53pw0K4FHXnuAj01XbZjikaziUHelE4jUmO3YBx5w2LMsrs0l716cqimZV8
 aXIRclbJ
 3VV94aS6SC7UNjLlz0pc9Jx7gDnhlo8zst+GTHlCLKlcvXVPPy2go9bc9/kg8l0s3ijIsDV6FT0nlZDUtOGfJaIFV3Ekoo2h5iCGpI3cvspPRR8EluIU/kicTnFnAP5fEiUUEiT1bIsl6R0zYh2emo/WLxOhBcterubJfNosZ9K8A6snNaUouhPMJXPCaOybYlIGPSkAHT/eRu+bAX1E5PPs7dOOm8CTvneQzDegKMbFsOPdoseQdjAAErOYEKCItdZ2l6qGfkdj0l7ZDE4smjJKEsJbgmVwKvPXWEBYHlLJpLOsgZk/m+Vcl6WZ6sL4I0AxwlRFbhlbc/npGNrAuy2MUkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Oct 3, 2025 at 7:01=E2=80=AFPM Roman Gushchin <roman.gushchin@lin=
ux.dev> wrote:
>>
>> Martin KaFai Lau <martin.lau@linux.dev> writes:
>>
>> > On 9/2/25 10:31 AM, Roman Gushchin wrote:
>> >> Btw, what's the right way to attach struct ops to a cgroup, if there =
is
>> >> one? Add a cgroup_id field to the struct and use it in the .reg()
>> >
>> > Adding a cgroup id/fd field to the struct bpf_oom_ops will be hard to
>> > attach the same bpf_oom_ops to multiple cgroups.
>> >
>> >> callback? Or there is something better?
>> >
>> > There is a link_create.target_fd in the "union bpf_attr". The
>> > cgroup_bpf_link_attach() is using it as cgroup fd. May be it can be
>> > used here also. This will limit it to link attach only. Meaning the
>> > SEC(".struct_ops.link") is supported but not the older
>> > SEC(".struct_ops"). I think this should be fine.
>>
>> I thought a bit more about it (sorry for the delay):
>> if we want to be able to attach a single struct ops to multiple cgroups
>> (and potentially other objects, e.g. sockets), we can't really
>> use the existing struct ops's bpf_link.
>>
>> So I guess we need to add a new .attach() function beside .reg()
>> which will take the existing link and struct bpf_attr as arguments and
>> return a new bpf_link. And in libbpf we need a corresponding new
>> bpf_link__attach_cgroup().
>>
>> Does it sound right?
>>
>
> Not really, but I also might be missing some details (I haven't read
> the entire thread).
>
> But conceptually, what you describe is not how things work w.r.t. BPF
> links and attachment.
>
> You don't attach a link to some hook (e.g., cgroup). You attach either
> BPF program or (as in this case) BPF struct_ops map to a hook (i.e.,
> cgroup), and get back the BPF link. That BPF link describes that one
> attachment of prog/struct_ops to that hook. Each attachment gets its
> own BPF link FD.
>
> So, there cannot be bpf_link__attach_cgroup(), but there can be (at
> least conceptually) bpf_map__attach_cgroup(), where map is struct_ops
> map.

I see...
So basically when a struct ops map is created we have a fd and then
we can attach it (theoretically multiple times) using BPF_LINK_CREATE.

>
> Having said that, we do have bpf_map__attach_struct_ops() already
> (it's using BPF_LINK_CREATE command under the hood), and so perhaps
> the right way is to have bpf_map__attach_struct_ops_opts() API, which
> will accept optional extra attachment parameters which will be passed
> into bpf_attr.link_create.struct_ops section of UAPI. That thing can
> have target FD, where FD is cgroup/task/whatever we need to specify
> attachment target. Just like we do that for BPF program's
> BPF_LINK_CREATE, really.

Yes, this sounds good to me!

Thanks you for the clarification.

