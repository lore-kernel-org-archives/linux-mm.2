Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAA4BCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 00:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19F5A8E0009; Mon,  6 Oct 2025 20:42:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150588E0002; Mon,  6 Oct 2025 20:42:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0663F8E0009; Mon,  6 Oct 2025 20:42:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E8CD48E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:42:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81483BB201
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 00:42:04 +0000 (UTC)
X-FDA: 83969466168.21.235D614
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id A569440004
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 00:42:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FYgek9SA;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759797723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mv3+xA9kD1I985ghdrUGEDO1hqGIeV/sS/Ttd+zrLjc=;
	b=sppZv5gZ6MZhQknMenfUPYKNqI3Msz5YO7OHEZs7UP/rRHLDgIxRAwcDFy0KUZlVyc458g
	9/7c7bVWsSDdIxCmjJovv7o32ZTKnP79/InF/5/6jdG+5wb6cgEa0hRrZeeQZq53fv4MIX
	Fe9HmNmohCJENJV1Ynum0B0DHf75wCM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759797723; a=rsa-sha256;
	cv=none;
	b=uPm5oDqFmPvJUjKtZFZu7EHIp5x3iFrkE9bv6JRKBv4n+YcU5szpq/8xPCH25kg8zBC9Cj
	M8odcZOJnbePMXSxyH3yQiBlntyj65XabapuC7dZCEMX/qpQc6cINx3DNgDmSwLw3aduO6
	QJbJHgzI0FgYm02WW2e3dOlwetk0wuw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FYgek9SA;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759797720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mv3+xA9kD1I985ghdrUGEDO1hqGIeV/sS/Ttd+zrLjc=;
	b=FYgek9SAutdY9P9IZoaZxz3kLUJrlT4rgo6GJPU5sc+EYaxjQ+hsU7m65t3uU1p2wU1V5h
	Tg+gjsHHq9uuA0CVNrKV2LJEhBu7ifbgCFvb4tfS7+8s1H7s3e3vCQvCWDx/ZTFMAqzZpm
	pwM8Y9NRrjhqcHsARSu6Rk8RqOYqvo0=
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
In-Reply-To: <CAEf4BzaVvNwt18eqVpigKh8Ftm=KfO_EsB2Hoh+LQCDLsWxRwg@mail.gmail.com>
	(Andrii Nakryiko's message of "Mon, 6 Oct 2025 16:57:22 -0700")
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
	<871pnfk2px.fsf@linux.dev>
	<CAEf4BzaVvNwt18eqVpigKh8Ftm=KfO_EsB2Hoh+LQCDLsWxRwg@mail.gmail.com>
Date: Mon, 06 Oct 2025 17:41:52 -0700
Message-ID: <87tt0bfsq7.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: 55cfwdjsnj3u7uzysko8uoo3i4u8hmch
X-Rspam-User: 
X-Rspamd-Queue-Id: A569440004
X-HE-Tag: 1759797722-477014
X-HE-Meta: U2FsdGVkX18OX2d4mog2KTpJUxubFO48blD5XPKF+AE9M6Bmy/GWHomrsSCPMrmD4V7lbQoCnyWiLb0vvG9U2v7PMEMLakQSLgeMdy/r2tIaAvPpI5vwafObuDZOlZl+hj1G0C7vQYDI7atWST1d55KVvfyD2Qte8Kx9wMPrO8iz9X2eyGIPARIvNW6RTLKRKPnsv4ZMrpADPxCwPqYl3uPm+TezUeYTP2pJ13tYz4Q7saWLX5yPfAVjufB8g2Zd0dlRIth8/9PqIKzYtgPAproD/eYq0F/OpS136zVNa8110PaeXYmPpv093KC+/w8svp+TnUNLZF50AfsGvdCAlbc2LGh0SdIIedP4XHGnU18gVUBHm3CdO2E0TyrCgLHnE1fkhZX8RuZvp2lIo15Aox9PrrI2T2dvGy3jec02KZLyYe4cJXjhGbyvUtCPf0EJRKVI3DE+jFbs1dVyy+soZ0IzbJG3Yz92TP9AJHmauxe/nj6A5OKr8z0Z+OgY2nqoIdXY1PBs7F/exA4uDyAdqXgRpnoYpyhFL3IpCdiSYc6TQJdfiHGcWLLUaKg+Q5R789S/D5liMVjubuUY9VPAf8rvyyWaQq5soBid2qd+RxLqEdLgvH/30D4TIe2usTnMuwBC5hv1tDz9UIYPfz492cSzuBQslJZFDYuaxLOcxoosBFNqx7OOPuqXb7vvzkOC73lwmIFK3lrfJdU/LNZbpxFe1tq9Br23VV4WZRO6inIY2plVOeEy40krfbSppvSA3vU6nUlI4zm5TeIBNVw1oFuxvvyyuesX5ICkro12yRmB5s0ripEf8VSllCRgrRXTbWpKF/8JjiNw+mX/Tx4SWzUqTOrwcFTuSLJv7BTYhEiJscoad3rUfsnnzHoLCK7zg6yzz1JFocbcJ+mm8gOH+DxFCFwOrnOAX9PY/4NrGnJnEV0COotur/lqtElHJ/ciCbyzcAVER6Z9aQcxbw/
 PzvK1OdF
 geY/JEjHAi2KUiKoa9YxhkFwrPq9YoMsf6NKaz7Vdht4nwWw6lLMbrpeH9zj5YcUSY4BbWzujrUtUL+A/RWJDMNyCvC5U7LRYwmnVrk4vi3tXzEbGKlwQSm9Shg40vfK7NMXZgG7rZrmqc/PuZnj+GKTkZKB7RCHIfhKqEA3CgWCD1RlfPDDX84bXe50zrtiJOBhnIstu9WbWL/yN3CWsQ8eF1vWeMmM1IdGnCHd1Bpu2BCwLnRauU+W281z74Jjqtsm7AsyiQbcNoakLckJm2YrGofLV4AD0hR1xiXytskHw27yOr85tnWwsUjxpunDiU53iJCxWOtXmCEhL5hqnc71UtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Oct 6, 2025 at 4:52=E2=80=AFPM Roman Gushchin <roman.gushchin@lin=
ux.dev> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Fri, Oct 3, 2025 at 7:01=E2=80=AFPM Roman Gushchin <roman.gushchin@=
linux.dev> wrote:
>> >>
>> >> Martin KaFai Lau <martin.lau@linux.dev> writes:
>> >>
>> >> > On 9/2/25 10:31 AM, Roman Gushchin wrote:
>> >> >> Btw, what's the right way to attach struct ops to a cgroup, if the=
re is
>> >> >> one? Add a cgroup_id field to the struct and use it in the .reg()
>> >> >
>> >> > Adding a cgroup id/fd field to the struct bpf_oom_ops will be hard =
to
>> >> > attach the same bpf_oom_ops to multiple cgroups.
>> >> >
>> >> >> callback? Or there is something better?
>> >> >
>> >> > There is a link_create.target_fd in the "union bpf_attr". The
>> >> > cgroup_bpf_link_attach() is using it as cgroup fd. May be it can be
>> >> > used here also. This will limit it to link attach only. Meaning the
>> >> > SEC(".struct_ops.link") is supported but not the older
>> >> > SEC(".struct_ops"). I think this should be fine.
>> >>
>> >> I thought a bit more about it (sorry for the delay):
>> >> if we want to be able to attach a single struct ops to multiple cgrou=
ps
>> >> (and potentially other objects, e.g. sockets), we can't really
>> >> use the existing struct ops's bpf_link.
>> >>
>> >> So I guess we need to add a new .attach() function beside .reg()
>> >> which will take the existing link and struct bpf_attr as arguments and
>> >> return a new bpf_link. And in libbpf we need a corresponding new
>> >> bpf_link__attach_cgroup().
>> >>
>> >> Does it sound right?
>> >>
>> >
>> > Not really, but I also might be missing some details (I haven't read
>> > the entire thread).
>> >
>> > But conceptually, what you describe is not how things work w.r.t. BPF
>> > links and attachment.
>> >
>> > You don't attach a link to some hook (e.g., cgroup). You attach either
>> > BPF program or (as in this case) BPF struct_ops map to a hook (i.e.,
>> > cgroup), and get back the BPF link. That BPF link describes that one
>> > attachment of prog/struct_ops to that hook. Each attachment gets its
>> > own BPF link FD.
>> >
>> > So, there cannot be bpf_link__attach_cgroup(), but there can be (at
>> > least conceptually) bpf_map__attach_cgroup(), where map is struct_ops
>> > map.
>>
>> I see...
>> So basically when a struct ops map is created we have a fd and then
>> we can attach it (theoretically multiple times) using BPF_LINK_CREATE.
>
> Yes, exactly. "theoretically" part is true right now because of how
> things are wired up internally, but this must be fixable

Ok, one more question: do you think it's better to alter the existing
bpf_struct_ops.reg() callback and add the bpf_attr parameter
or add the new .attach() callback?

