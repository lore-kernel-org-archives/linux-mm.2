Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E754CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 23:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53D38E0008; Tue,  2 Sep 2025 19:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B7D8E0001; Tue,  2 Sep 2025 19:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968378E0008; Tue,  2 Sep 2025 19:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 863768E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:36:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E97058FA9
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:36:39 +0000 (UTC)
X-FDA: 83845922118.28.FCCD66D
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4085712000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:36:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d7+z3KRj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756856197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VRotmPacgDSBhrhKHEwQvLwXAIZ2QzWSVjur4ooG6I=;
	b=MtjQEkT7Oi6z2NmgNr+/k6GzexCaO7yFY6FLij70GplLMDOIXUVl82g9YGL4dXrrsIhePX
	c3FlyrPLTP0ObVKDDPbcfuTIsB46Sokh3ZISMQBHfI9JAS8qSGqz9M0QYzp14oEeDvTLpi
	WMC1DNw8UR0fOougFLXCR6mOJRYdwyI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d7+z3KRj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756856197; a=rsa-sha256;
	cv=none;
	b=F2xqTINlyjKxDeCap8iJoUio4WwLs6bIrkDHsQXPui57OjNH1gKWGWwt4SUoJD3Wy+f8/m
	g/Pnoqo+jIwEtAoUmQTiuSTyId6NbbP6/zvvti/9ZScYlFOs+cFVfAA/jd4sgItAociwYS
	BLnzqADD2CIrrTcaZXDll+b1//NujWU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756856195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4VRotmPacgDSBhrhKHEwQvLwXAIZ2QzWSVjur4ooG6I=;
	b=d7+z3KRjKnYgIE8FVboMNcu7cNJ22o0DwNdthxu9cPcAnsobQBApJF/8cftXd51mtBvxBk
	oNje22SYw/0i4sNoY4RKXd8pZxN4Yo2xT3ys5FFmFFvr41PRc8X6zPCH6lHOGwVv0PBKtI
	CL58h7dU/uh1AGcCuCtqP1r4DrEqgQE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>,  linux-mm <linux-mm@kvack.org>,  bpf
 <bpf@vger.kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David
 Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
In-Reply-To: <a76ad1e9-07d5-4ba1-83e4-22fe36a32df0@linux.dev> (Martin KaFai
	Lau's message of "Tue, 2 Sep 2025 15:30:04 -0700")
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
Date: Tue, 02 Sep 2025 16:36:27 -0700
Message-ID: <87ms7c5sw4.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4085712000A
X-Stat-Signature: jp3xnwckquo4xeg66do388gor1x4p755
X-Rspam-User: 
X-HE-Tag: 1756856197-634137
X-HE-Meta: U2FsdGVkX19WP2wViwSy8fTZ2JXTP9fIW5QlUrQM744yZ1rvVyJVvgJNY6lJxubHWQKs4yP92nrIayqaeQ+Oq1jopNVerQKgBIgO2DWj2G+1VV/35/NHgSpLTTrY3mkCrOFf8q7c5Orxy9SCNvHsrjfg2AnGaHSR2sOVDpg3cIskXvTCxf1ai2TiUuhdtp8F9ZDaFpvkyrsk8VKuwrlwjbMEi3TmhRcb8TShpFOOYteWspAizxewuYmBCkubKFQT8a5aE/L39V62X9dF/DoLgFunS1/s8VTzAZlycFZrNOWURH2lCpIcdWB2xatXVsrYq/Yp4l0aqiR1nLBxexo/rOiYNduh+1A8vVzigbWjFL/mMM6F0rIQ7SforXB8+mv2H/clwYbkp0O2oDcFT3NKXPQPpAY5d7RvAKfpuOIILclLCtxESHm5TLp4EVppAFqaBBymcF1FJ/HAN6CZG1w0SW+nBO1a/rOjgKN1t0UN+rTzum9mZWCAgFGAgyAXrHW47+wJpTbpeReKXMKv8JLL9k/BOMIwy4PM1ZqL2tVmZhABsWqt86c/5g/WlLclSJsdOEZYXqBhH3rCcm2NWi9QAJsuADswtUOIzC/UqdPiHj5AtmK1/mUZDdWB2143jwptNQvFmjgJ9ZMFckAOkBhENLYlaewT9IcctVFomW2joQdyBA1F1FGO/krLnIQ9fSzkGXgR42rFf8Xs0Ig9kpm01sdHwM01kOqpj66WyKmfPyh6PSgiBgrA8zsYBnWd9KuiUmAriInXb25+FQmnOVZfXIb7kS20zmZ7bbrm0NHF8GWnYItE9+Oin73b9lDtymAmTwRcbkLLcL+xoFBAPE3TqPoZgiBeFpBjA0rVKCCdmCaHDudBmocGuuWSiBNrV7R30PZUWXAxPTtUG9cv/EC7UdJQ2/F652VohFxPDGCKvX89cFkb36aU6mQr4vk87ZR43bqBMD8AjLP0XD9OEoc
 Q+sAVLyz
 eDiRnxQzKpqrz9NO8k/pD+dCf10z8UmXIozyCr2EAI9OmIscN+Jc3mrJRCZb6w/HdDI+bCkMdu1rDpdrm76MHK3d0aHiDEeXrfKCg30QI4Vu1izpN40AudYkosWufUlsTWgz1ta3nPqMSSX+Y5JCZPvDO30yLJHqLmiYXpN320kFOwAk2Mcrz80iZMgRo3YlGz0rZO8gyPaCwG2EtGwVLbqzApIYDqDC2/JYM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Martin KaFai Lau <martin.lau@linux.dev> writes:

> On 9/2/25 10:31 AM, Roman Gushchin wrote:
>> Btw, what's the right way to attach struct ops to a cgroup, if there is
>> one? Add a cgroup_id field to the struct and use it in the .reg()
>
> Adding a cgroup id/fd field to the struct bpf_oom_ops will be hard to
> attach the same bpf_oom_ops to multiple cgroups.

Yeah, this is what I thought too, it doesn't look as an attractive path.

>
>> callback? Or there is something better?
>
> There is a link_create.target_fd in the "union bpf_attr". The
> cgroup_bpf_link_attach() is using it as cgroup fd. May be it can be
> used here also. This will limit it to link attach only. Meaning the
> SEC(".struct_ops.link") is supported but not the older
> SEC(".struct_ops"). I think this should be fine.

I'll take a look, thank you!

