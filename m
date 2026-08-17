Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51BBEC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 18:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D7596B0103; Mon, 17 Aug 2026 14:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AE5C6B0107; Mon, 17 Aug 2026 14:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29DF26B0108; Mon, 17 Aug 2026 14:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D89666B0103
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:22:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63B251607FB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:22:26 +0000 (UTC)
X-FDA: 85111581492.15.9EBC265
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 719191C0009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:22:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cZxGFIP4;
	spf=pass (imf18.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786990944;
	b=DidW6Qz2YOURTeygJsA4iClqiT4xFhG5YInG0qKbxSNTzmqnbmWfvLMS69PDgXjc+cmEI7
	4kr942ptgBLOXQPe4EhC9FxwanW1kXBgOm1ia3LXgUmBdl/exRXesZ+9fGa31lu2+V91P+
	cTBVg8qLDrQP7CrybrCy3rwP4KAova8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cZxGFIP4;
	spf=pass (imf18.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786990944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LxYwqYOrD411oJvKVf7MSl5O4yE/v1cgNQc8LyxR9SI=;
	b=5B2ymu0JtNGO1WTFwzfgVYd71MsRfZD1hiDfjeWFl9gqo9CxIC2e20T+TMGd0CFOMXpUlH
	YPMCHKH8vB2oYVwQWnZWm6JwGfzIfL78S4uFOQX/pPgUbrdFXwy1UM498pzLOxP3wUkc7k
	pV3kzCrEk7LozM9XXbQ9vRBEf+Kw/Tg=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84a652535dcso2254734b3a.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:22:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786990943; cv=none;
        d=google.com; s=arc-20260327;
        b=mVzZJdhbZ0ncRy2vf9ntIN6mSCgNoXxQpr2nrbox3h5zxb8EmpxYvinP+opy/ezJF/
         n0aLzmO0npnBFlK/dQfTZH9XsSHcaXefVknkT5lEdaBCql3+7zXrFkDXqENMvOtHC8Xh
         +2jRjlu6g/6AcJdPfKeJsLC+I33bPefKmXMAMyeuprVwkJcYRA1CtPYY0ZycIiJkBSX7
         tZpkGJjnX4qnhhX5ycuXKoOT8Fh6LxQ6usCTA31h5gHTzJmUdwkq0vJnjmkQvsMk3m5S
         8nqrCEI6sIEoikKqBGJd5pxbNsHivp9ufwnxTMJOyg/1RtZloBAXyXgxsHyQQKwrdtTu
         LOZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LxYwqYOrD411oJvKVf7MSl5O4yE/v1cgNQc8LyxR9SI=;
        fh=jXxQII4cC7YpqC2chTvSdNF3+FpA4ZdmX3Z6rnLzsmk=;
        b=r29iflYoaB4oiH5JhuMDR1zysaWmVgQXKnLoLDsh5fvQokxHli+pk4K7oWOtUiql4E
         H7QALfu8yAYLjISeqYudqaTcsByG0BFAg22gZX0r+i8m+96rjfRAJDOK4CRNkaSN+Y/s
         SF2LqGwIkS+qkXRZtGsQBmiwS5MF3dY655NlaX4qRV+f9nKZcSKU3wNYlvDyMMercrMJ
         PgFbnUlGv9JoZiXb86gr0MnWqzaZ05IH/ax3rQZAOyRT3XgMpuXeNZOp/cPbL5kwi1jB
         n1dPhf1LQu7NCONzRKaiuOVszTEMTNpN4gjz+WFIXrixgKvOrgbt7jFS8CEDEw4Kdzwu
         dg9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786990943; x=1787595743; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LxYwqYOrD411oJvKVf7MSl5O4yE/v1cgNQc8LyxR9SI=;
        b=cZxGFIP4gAxnSZxT4gbhbXFZCrjmDPCqUCzVBgXoxuz4JCpWd5N/ioC9kFV0sv/nEJ
         oWVJWGhqjkqNj7I2f9b1xyytt5VCS9xsYOiTeFrzZIPBQ9XUIQliTOLqCz5ITaY+C8+O
         wu1PFnNlinqPYHk8aYNN1ViL6F7cArr+7hO73N3tvh7Dh2lqPi5y65hisNf6vB3N9dk9
         wbyMBHHar0cdPw+09pV7amjasxQ2sA9HhlzmS+cqJiw0d3KPUPq7twNMZsY7DG8r3HHK
         W6hQF+Nd3v4MzIoFJxGPjc6vxbABGTBCIQZnsY6ezq+6bfWvgRZMKB9yHV4p3iFKznSq
         PewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786990943; x=1787595743;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LxYwqYOrD411oJvKVf7MSl5O4yE/v1cgNQc8LyxR9SI=;
        b=MaoJwwHtvGKlklYvVagGVk52LXeKCw+U9JC4JRfcN9C0nfL2eP+hZOnouzmiw8qZin
         F/I0pne/eXojs82KJ0F3eG//DEzwnEpjjGhFRcsnQzFGa7+dMqKYTxD8nYQRysZH0cKe
         uHVkV9lxiaoVeQB4c/C6MURuTtGbDs5Lu4WIxIwWDfMLMcauJVd7anLg3MT6R66GsHuh
         XXdVu2vr4rllqjLeBP2MEEfzB9PTlrUpUZpOMSilYkFmHzdihXf0ETwGCCz4HFQgoXWp
         bsMvb7UrcLU17mT8nynoKmuxpazCNTL7UYpz+GiuQDEJDewaoiy9WCUUq+RHg7hNRHCM
         F7UQ==
X-Forwarded-Encrypted: i=1; AHgh+RoRadpak4peF3ddvjQ52wshjYvkt12z4+Hkg+McB8iEnNfMKz/SE4c1QM9134calAkMCMjJShQgTw==@kvack.org
X-Gm-Message-State: AOJu0YyEupVz3K2FJNfK7gvkUy1YrQ4ZlgGkPelv+9UlSl9us47lu6tY
	0S933LHO8qn2ba+f9xdPXSDczVBGGs0SD5pjTm0RyMGbPE6Yowmvw79Tq0gZHdV4SQBZB1WmE/+
	UfhMMrI/GY39DMkPsmG+erRyR6cQzeaY=
X-Gm-Gg: AR+sD10btTr7KcgiTO+NVSOf29I4mO+6fp054vEJ0IKzkaxsMYv2HO6C/1RiXJ5i+3N
	0q7mkvcWi8HaD3/D3vIzVxeEe2tN6CpjmavmYCvaXhcF/XG3OmHVVIZzzjM/BrLltAOJa0AuuMM
	6cDLP994KUBP1if39/V9xYBGcDmbwvlD1rtu4MvnO1ELuSl3poX7ZKenwfZCW9tiehwEqRvli5i
	8kdTTW4C1yCrQNtIV0FEHALKYdyLF/ZvJ4sRH0qUh8OXFdkNB23xZdcAn6R5FcL7RbyOlYXoBTg
	nXCkj6VQLBn8/XfKTCC8IzzVUMosSItuYE5wsmnPdsO5sdc8FcUp6glMRBJe2InPIwxphBzLzE2
	Cuqbig2icTlUN/ZKzyFqEhUkiU/SF2W3q9A26CzD/5A==
X-Received: by 2002:a05:6a00:94e3:b0:848:6720:6fec with SMTP id
 d2e1a72fcca58-84fde34a291mr26130114b3a.28.1786990942981; Mon, 17 Aug 2026
 11:22:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260815091819.3651099-1-gaoxiang17@xiaomi.com> <04f3ce2f-67f5-4829-9551-a69b9df29854@kernel.org>
In-Reply-To: <04f3ce2f-67f5-4829-9551-a69b9df29854@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 17 Aug 2026 11:22:07 -0700
X-Gm-Features: AcwNN1WfsDbZbp0-lpvXe5rDMDaXky5_oG6XfLm1oTm1uuOmMOh7cMvg-ry1wfk
Message-ID: <CAEf4BzbwZkoacX-iP1j4+p8YNbWsq0pc3eTermh2uT5ir66zbw@mail.gmail.com>
Subject: Re: [RFC] bpf: account ring buffer backing pages separately from Lost RAM
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Xiang Gao <gxxa03070307@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrew Morton <akpm@linux-foundation.org>, yinchuang1@xiaomi.com, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Xiang Gao <gaoxiang17@xiaomi.com>, 
	"Lorenzo Stoakes (Arm)" <ljs@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 719191C0009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gi89ijyc34edrridjn897h3othuypcb5
X-HE-Tag: 1786990944-193442
X-HE-Meta: U2FsdGVkX1/5XBWEAF+MRkL4M10S98Uj+XV6z/JOQ0Oe1vmtG+W5J0pvFK8hrS0WHQLtjpBN8bFitR3nA1lSgLB9jCJJbGPg8orA52RZtzeCWlJQZxlEmrSVBr4ioxkWGcPbi4wgzzFSmRvMJ6zt+CrHxlDFbt++o3H6eVvoVodUO6b5GcKlewA48XGh0SNSiiU0Gz4Mim4acJRKyTBzWWmPda/r3g7u9Dpt0rb6Y7vM+76R0HnctAJNCN243mM0DUg5xLxFwfckTW55koFQNA1GRybGQwA1uh4ovQyCEcj2Ykv2gq8wz70kPcj7KeouJdoO3FxHU/Tv+A/o7Qr6oiTrdR7o51H67Hddsj3WWG21oWyNWPcjB9dO/YV73+Qm4clj8XrzlfXMGuSefp6vzfNgZ0z33/j2THRlYrtFwBHLEU+gp08LUp5zQbGaI9fFeUox472N7lEnk731z8GHzZlbbi6euLvI8t4YrMkvFsG4PQ0/0Yv3k5N70N3NHE4obTCHfVDd8eXNGm77IZiMnfTpbWJ6RSqmYPod94YIUXWCadGBMCnhErkzWIWsO3X26tBKzsrLPdHfpXf1jx0ohMU0I7WQwv5jpI5Sx1L7gFCK7gZjLL/spiiqKsjSbQg4LTQxAggN/ue2uVy4gUQ2WuFOYAzF77pOffGa6WyczRk3J/c+V1MDAhQe8yiZKKXc5KA4Cp7raO7LltyGAhR+v0C0DAkgh9TKxnIraBMOxX0shh4ugQxj9oJZsS2MpJFpVldvCIxPY2u5c0djxB5ziG+aV2aAYHjyGJFvhO8XevqIJOhf6TrbWLojtNwjOzXjN0XbsbvIlIQt92nKL6t7Bhcc79fsBB+wEpxFZmzDXxpFFkGBq9sszoVuriZx5bA+7+xWIL7g/3W6Ny/cbniDA6/fzb5QkksU3+rcPhC9fKdoQJrA6Xprql/XkE9eHROvOLI39Xe0clPcr6GKKpl
 2SntZWhD
 D1zfsGhm7oH/3o2OvUDGhj2bn97585MRbJVMu5/CCLTC9O54LmopY8sRVYMTFOvOQeYCE4q9d+o23aqd7PALLNOTygMw56ap0aIqusVh+pF9pEDo2vQjFr6EewpvxO6xHTro9gO6SD6TQye9WZ5aNOP+xfwnoTMdh/TRvGOsjB3bC8+OhIXQus5n9+UilgKNeWmXziDSCvytA5UDj3Snq4aqgKy/gv0Hb7obFXa5zi/0bsK4gZLalqbkt9z6KEDzqK7rASovVuniNUTBf77r5MDYyh2d/RaMJgIeMfTw7lgtiE8ua+SJqsOSM4HqyUrF/Qr/8MUyajT9EfVrrpMKDKMxK3q+9N2WLwvdaBQC7icGlquvLS8oyrtGLmPWAawWGcWKlAD74tErFElJbIOkx16Q1nYPT4qChpBW1BWWkaokw3CMDFoAgSM2YAsgQadDH91IN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 11:10=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/15/26 11:18, Xiang Gao wrote:
> > Hi,
>
> Hi,
>
> >
> > I would like to discuss accounting BPF ring buffer backing pages in
> > system-wide memory reports.
> >
> > BPF ring buffers allocate their data and metadata as order-0 pages dire=
ctly
> > from the buddy allocator, and then map those pages with vmap().
>
> I assume there is a reason the slab isn't used, right? Are these pages ma=
pped
> into user space such that page->mapcount would get used?
>
> Can you point me at relevant code?

See code in [0]. And yes, these pages are meant to be mapped into user spac=
e.

  [0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree=
/kernel/bpf/ringbuf.c#n93

>
> >
> > Because vmap() maps caller-owned pages, these backing pages are not cou=
nted
> > by VmallocUsed. They are also not slab pages. As a result, most BPF rin=
g
> > buffer memory is not represented by an existing named /proc/meminfo cat=
egory
> > and appears as Lost RAM in Android memory reports.
> >
> > We measured this on an Android 6.18 kernel.
> >
> > Test case:
> >
> >   32 BPF ring buffer maps
> >   16 MiB data area per map
> >   512 MiB total data area
> >
> > Observed changes:
> >
> >   Lost RAM:       approximately +529 MiB
> >   VmallocUsed:      approximately +2 MiB
> >   Slab:        approximately unchanged
> >
> > After destroying all maps, the values returned close to baseline.
> >
> > The question is whether the kernel should expose the unique physical ba=
cking
> > pages of live BPF ring buffers through a dedicated global counter and a
> > /proc/meminfo entry, for example:
> >
> >   BpfRingbuf: <value in kB>
>
> This looks a bit too specific for my taste. And I think we should try to =
no
> inflate these statistics here too much.
>

+1, way too specific

> >
> > The proposed counter would include:
> >
> >   * ring buffer data pages;
> >   * metadata pages;
> >   * consumer and producer position pages.
> >
> > It would exclude:
> >
> >   * the second virtual mapping of data pages;
> >   * the pages[] pointer array;
> >   * map metadata allocations;
> >   * vmap page tables.
> >
> > The goal is to account for the currently unclassified direct backing pa=
ges.
> > Slab- and vmalloc-backed auxiliary allocations are already represented =
by
> > existing memory categories and should not be counted again.
> >
> > A possible implementation is an NR_BPF_RINGBUF vmstat counter maintaine=
d by
> > the ring buffer allocation and free paths, with the aggregate exposed t=
hrough
> > /proc/meminfo.
> >
> > Questions:
> >
> > 1. Is a dedicated BPF ring buffer counter appropriate?
>
> I don't think so.
>
> See [1] where we just had the same discussion for tracing buffers. For th=
em,
> Steve [2] had an idea on how to expose them more fine-grained and tracing=
 specific.
>
> [1] https://lore.kernel.org/r/20260810094025.136705-1-gaoxiang17@xiaomi.c=
om
> [2] https://lore.kernel.org/r/20260810105710.6ee5e493@gandalf.local.home
>

We already report per-BPF ringbuf memory usage either through bpf()
syscall or map's fdinfo. E.g., with `sudo bpftool map show` you'll
see"

1455733: ringbuf  name event_ringbuf  flags 0x0
        key 0B  value 0B  max_entries 262144  memlock 275776B
        btf_id 2193434
        pids tcpeventd(2549812)

where memlock is how much memory is allocated for the ringbuf data area.

> > 2. Should this be represented as an NR_* vmstat counter?
>
> I don't think so.
>
> > 3. Is /proc/meminfo an acceptable interface for this information?
>
> Again, I don't think so. "Lost RAM" really is just "excessive memory allo=
cated
> by some other subsystem".
>
> I agree that some users might want to figure out what is consuming that m=
uch
> memory, but I don't think growing /proc/meminfo in that way is really wha=
t we want.
>
> > 4. Is counting only unique physical backing pages the correct accountin=
g unit?
>
> I'd assume the "It would exclude" part above should not be accounted ther=
e, if
> that's what you mean.
>
> --
> Cheers,
>
> David

