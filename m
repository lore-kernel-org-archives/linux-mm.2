Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F4D8CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 04:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D6CC6B00A6; Tue, 29 Sep 2026 00:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687B66B00A7; Tue, 29 Sep 2026 00:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54FBE6B00A9; Tue, 29 Sep 2026 00:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 223D86B00A6
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:06:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E0A0C038D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:06:30 +0000 (UTC)
X-FDA: 85265462940.06.539AF22
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf10.hostedemail.com (Postfix) with ESMTP id 81598C0005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:06:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pthdOyaF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.234 as permitted sender) smtp.mailfrom=rockeet@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790654788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUqW22UO8+f58aBt4HLAJFHAQ6hQs2WZWeoUhs/jE28=;
	b=bKHetNtWfoxm7uvmrFB0n4smtsDPc8RS8K+f2tMJbSCaMDsmj/ALiOWhJHljhWgF23KJHz
	cOijovGbQaKxxtJJMedzZP3fh9hoYM6IiMqscdHF6m6bJerDXTtN9wSSU37/RkthHGrAdz
	eG5T76eOoNZFy5Nuzt/kvJESQtvop78=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pthdOyaF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.234 as permitted sender) smtp.mailfrom=rockeet@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790654788;
	b=aUtQs8UebHECC1XjzE8tvYV6nafWeKHBev4yghFqd2VvE07f7IUrdrjgznDsuOU+HxXMTf
	zqaPUto6wDS02m0/e3qhw3LWOqU9IgFLFqy+gcBj4wdtgv9tmIF6oOEI68PcpMPrRj0ZsH
	8c+CLbjOhtEgGvPPYqWQhwlNpMmBXxw=
Received: by mail-qk2-f42.google.com with SMTP id d75a77b69052e-52fb769ca17so32129471cf.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:06:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790654788; cv=none;
        d=google.com; s=arc-20260327;
        b=aqtxjDaViFHSQ5l5GqBDjs83hGjMk01s0genMD+goaOLccGM06T9uyARw+W/BkWwvy
         1N04P3G8it8O4V1G6TMTF9CSvKPTOYEz+YGZ+Pg4C9mX08VtCE3rpF3T2T7U9x4Wp4GD
         kKz8WI+kX8n/0TqGWwSMTsfIcM6RF5iItcKzrFpZVfuFwQ8n1Tju+xeCuNRh+we3yHsM
         gNET0l1gsoeJxKGBIdAldD/RyvEL4YPOE12JhiaVSAH1cJL7XfKXLT+rIgshEQFtIHM+
         kCEZrQJrFDfHazdEl1h9kMmlmSa1IWKNe6RM2NlZxJpD0D/IeOLnPsVpffAOXBTU1htD
         v9jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OUqW22UO8+f58aBt4HLAJFHAQ6hQs2WZWeoUhs/jE28=;
        fh=hAmEF9MMl/NXy2UsU6eKXWD0uElAYz1278QmfXBJrSI=;
        b=RG4SdkdNz6TuC2yQvpfGSRv0LEU7K8Z8fSFKu5i9g4/kfEtYtXnLzHsPgnICXRm7ws
         jq9PUOuC175KIa5z28BCyVyyhdHeEG6ZEvwD+znNGWdIyZbbwo0WtTSMLbbTqcx7yacF
         JgZfaBmMrA/SqMTFwol5Mo4lmaENHsEr+T+sPkS/eZu10j8oXW7LmbZZxjepyIYA0Kbt
         l/CBvze+wt4oayWHvVIoCp1WotDcBQnfIA8PdXnK+hr8yOvjh+8BN/nQhkfUspnDANxe
         J+M56JeT/C9OPq0HtaptFeE4iuL8oVrVMyDqH3xIzerSe4WffcRHFuA0SplaoJbNP840
         py+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790654788; x=1791259588; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OUqW22UO8+f58aBt4HLAJFHAQ6hQs2WZWeoUhs/jE28=;
        b=pthdOyaFohrjqU38hke8jkbgExKUaFk8dR8QpsqlyFR6KGvI9payeT8nQXrML4BVq1
         59OtNw8rFgx9goUoGF3EEwf266vs9RJLIj34p+WXIfPtHaAutEGB6efwmy4K1L1J0yJz
         OYYz5qelDJJPBfZm+v9ISG7ZKjee+6KFlUMNuvPMU7MNJ8l4Rh6WGVg43Rdu3qqWXF4y
         /ahVXlaurzaqh5xshcIlBjfavDXGjf/Q4IElHLD+H15X2Q40sr8R1ZPjZEVKSds/GXmP
         tDJzcx+VBug2FD41X/Ftk6vLy/sWGhAKGR63B/24SGkh0T8aH2nLR/O7jbwGkogAHuLz
         Un2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790654788; x=1791259588;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OUqW22UO8+f58aBt4HLAJFHAQ6hQs2WZWeoUhs/jE28=;
        b=L8TYksxRI0r5Jr9TMS8/Gjtcupn7tbpwIbuMIkgejjmkJhn/a5Tv4dDi2qdU2eHVCk
         GFqtDYxE1jebwpv9JTVg+igggpz6QANXbLejV1kN/g4JST1G+6MxPBN+HvLJH61yI7ws
         h6ErGhgULdBXfnJNvESp6Wthc7ZulFBIwNgILJ0oGCJWbLCGaZ1dGeyxL9tcuS34aDdB
         hC/mMjt+MJpE6htRfAWwU3abd5DoxHZVNKFW1nmOY/3kc+j8enVR9+CAkSfFlaEmCh7I
         X8cvOgxa0j9AYa1QxGnUrQ7qesLQ0sqaVYY9q1bZu/t6/lhS7MsNc+430gRiCVKhcyhW
         SIvA==
X-Gm-Message-State: AFuF++mqifwMhDX8ONe0o0Ny81C04zcthbbBA+XZnkxi04UDMRt2GAIJ
	vy2gy61v3JZ7yUAwf/lU7nnJVSD/TN8yRXnxkrxkw9vSvqz+ijjOhCvX7VNnrEy/Mksf5lYokKu
	+mI/KyY1SZhISnDBG77lMuner3lUnH1c=
X-Gm-Gg: AYBFou2ND1PtW3EeK2zQ0c66A7eYxQmecipdixgeyHiTOVjC8PXshSp09OUj7Wft/yl
	61/GFXP8oIWUYaHGeB8kZ/g/PBqZkSAs9ZpBdvMGM+QpmKc9Bkpj6iOmG9VekWQHu39Wybtfc9s
	0ly1tjTE8hYlAiYgTRGlyzxvcZ3u+tGq5c3ZqAG5BYKYQcNHy7BQr0kkx/ABfh0l8ceCwdeSrzA
	d42g3WsFNR1MwqsFaMWXdiWl0VPekAbAUU0itzwx/DVeDrKzz0bDEOHhSQcQBWsQ6n9gq1VPCPw
	8+rEH5W1NhvnTiDsxeUJ2s1U586913pu4ehUFf2f+ULDpQ/OD46N7gO3q+H/cexGTwFn1yIPZTG
	rpzFGRPYW2TpcXptkE/BL9/T0ECKAq7pZycFcvg==
X-Received: by 2002:a05:622a:4d9a:b0:533:33c6:e636 with SMTP id
 d75a77b69052e-53333c6feb6mr144083901cf.6.1790654787333; Mon, 28 Sep 2026
 21:06:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAAE3jtcL_CZJdcattCwe0RraKnHcZO=UknxEUQVG858ouZCUQA@mail.gmail.com>
 <7ebe4591-2306-4b5c-b83e-6a2e34b52bd8@kernel.org> <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
 <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org>
In-Reply-To: <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org>
From: =?UTF-8?B?5aSp54u8?= <rockeet@gmail.com>
Date: Tue, 29 Sep 2026 12:06:16 +0800
X-Gm-Features: AclHuK9HdKWxBr-sSsUZ5a8tjbRFwN_-vuhBxXzXtHCDYVNfVrksHL5LNaPEO2I
Message-ID: <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file mappings
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	"Lorenzo Stoakes (Arm)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: q1sk4ayg3d6ni1wzkpyywdjajaikomu8
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 81598C0005
X-HE-Tag: 1790654788-335539
X-HE-Meta: U2FsdGVkX1972jEDTJAQVhf43V6mRjXxO5Xvy0yeUqCEEgsijA3cU0eJH5K2s/55FNbOw55ZQpTOApWixZKt72Go02mc8mDJ115IKw78/Qnm2U0YwwyFdOjUv2XF75dGXJ1Zbpm5vfYwuae+BZzKh/qrCVlgHC30dGJrlm24E8vcYkRVzMcay/NCmNXkNt/Y9cI844cHmMsfVFwEeH1AHNkkptrGWfCssecyST7wnfaHlpfrN8av6aMNGYFcOFE7NmnVJYFODyJ/9xoVI9fXI47tQTHB2it6q/vfCLBNBiol8vznL0CQRwgkNeEZ7CnPJEORDTap2IG7u96zAvohtCp/K0J18Q0Nt8XpKcfYuRhPUhEFZc8DKNXhAukAbpTf+YeL9bln9TyW7/ZBhDwh4wD95pnY1yd1Cy4aNcSGTiTRywLgYjJGURB//iv9t770vm3PsLJmUYxJzIhuZnJSZmNw38g8/o35ida7IR2mUBKgFHGJ3rIg1BbJvNyunAAlpRH2TldKIGoA7ac6MBATp7Ugs44AKmfXA4ryu2y8QNNkQS43+gSOt7zepttqdHc/WMNk2d2wX28Jub8Syf3y5XTMZRx0Xq3nCSHJlZywzZD+9oBrZ5q9CpFH6TZ1ootAO3eWYJUYx2lfH4yKjGw3xmBN6w/jqqrF4B7Eezicf6D5+7s/1Uqm+jlq63fdOsd3uL1jbB6/T+z5MAMJGqC4RuA7RwjRyHLPCbpw/7QxczSiWxJwx/c7g/KjdLN5qvYopUVg8M3yqf+UylnORRWSOUazfUAClmEzZ4Q+MTXIpoU1TtpxhKLEecwyBG/WzIYvsQoIjObb7q3o9qv1q2BZpsjmo0xbgX7hyuQSeoNzyKrJ15Vp92n7ZxrqUXlOucNmuaJVY477WvgsiCy0uJ3qUeaC39YGhvScC7fgnoIvrt+ZtWg2q90jdlzf3IM8h+Ih4trMr4aOk9EMXyfERYl
 gs34SVC/
 qr+9d3rCRcGbvjJb+GiV8J/douIGXhAcerkINhRGta/NGlmU2DHG5eJyia/noLrE6JqL40gpRAmHPCAbAFziU3GYmx734qpdIayFl/9FY7t/O4KeMTL2Zf5gqLycHvMEC9ZrleYwlCW/Q/cvsh0uDgLtF6ROkzTksg5CnPbsT/+f05vLPIL1RQuGKD1G4eDbccc//8wOIgRbec3NOCCCJ4rODg+QQ31Ow+c5ofrMhLI4sjG3HnOuHByOjFrxYsXQ/Aw5ZpdOeOXbo7YRVhviv7HpehlZURcT1ToA3xFIY4A2rjXapI0tKnT7k/DgS1cq/CSLUZreD5E2Ns1s1Bq/S3d6XPGZnfa9w9j7jm7/dn2veMHiCVki2eqio09PJfK8g5aU/kqvjyq45wngowwaarPwbaZYdGvEBkKDTDK2IsSE8NqD3XwFgWtM9PCbtiU1Zf/NW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

> What is supposed to happen if the process crashes when updating the
> MAP_SHARED region halfway through?

The data structure survives an interrupted update through its
application-level copy-on-write and lock-free concurrency design. A
file-backed MAP_SHARED mapping preserves the latest userspace writes after
the process dies, even if they have not yet reached disk, provided the
kernel remains running.

This does not depend on preventing writeback. Deferring writeback is purely
a performance optimization, not a correctness requirement.

> It would be helpful if the use case + data structure would be explained
> in a bit more detail.

The data structure originally used uint32_t offsets instead of pointers to
reduce pointer overhead. On that basis, we implemented lock-free concurrent
reads and writes, obtaining crash safety for free at the same time. We use
a file-backed MAP_SHARED mapping to turn that capability into an actual
feature that survives process crashes.

A concurrent skiplist using offsets as pointers is a simple example of such
a data structure.

During construction, writes are scattered throughout a large mapping,
dirtying pages rapidly and repeatedly modifying pages.

> Unless you would try to bypass the page cache of course (if possible for
> your use case).

The page cache is useful here: it preserves the latest shared-mapping
writes across a process crash, and subsequent consumer processes can map
the file and read the same pages. Building directly in MAP_SHARED gives us
both properties without a separate copy of the completed structure.

> What exactly is the problem with writeback here? Unnecessary I/O? Is
> writeback the problem or actual reclaim after writeback?

Unnecessary I/O. Reclaim after writeback is not the problem I am trying to
address.

During construction, background writeback can write intermediate contents
that the application will soon overwrite. Those repeated writes waste disk
bandwidth. Delaying writeback would avoid that waste where possible; it is
not required for correctness.

> In a fuse server you can in theory delay the writeback request.

Thanks for the suggestion. That sounds like a possible way to experiment
with delayed writeback. The feature I am requesting would make this
advisory behavior available to applications using ordinary file-backed
shared mappings.

> So fadvise would be an option. However, this "defer mode" is really odd.
> It sounds more like you would want to have a custom policy there [...]

madvise is not the only option, deferring writeback for the entire file
would also be acceptable.

The application only wants to indicate that it is still modifying the data
and would prefer background writeback to happen later. The kernel would
retain control over the actual timing. Memory pressure could override the
hint, and explicit synchronization would keep its normal semantics.

The hint should also expire automatically when the owning mapping or handle
is released, including on process exit.

Thanks,
Peng

David Hildenbrand (Arm) <david@kernel.org> =E4=BA=8E2026=E5=B9=B49=E6=9C=88=
29=E6=97=A5=E5=91=A8=E4=BA=8C 03:12=E5=86=99=E9=81=93=EF=BC=9A
>
> On 9/28/26 15:09, =E5=A4=A9=E7=8B=BC wrote:
> > Hi David,
>
> Hi,
>
> >
> > The use case is a concurrent, lock-free, relocatable data structure tha=
t
> > uses offsets rather than absolute pointers. It implements copy-on-write
> > at the data-structure level and is designed to remain recoverable after
> > a process crash. We therefore build it directly in a file-backed
> > MAP_SHARED mapping, so its state is not lost when the constructing
> > process exits unexpectedly.
>
> What is supposed to happen if the process crashes when updating the MAP_S=
HARED
> region halfway through?
>
> It would be helpful if the use case + data structure would be explained i=
n a
> bit more detail.
>
> >
> > Building it in anonymous memory and calling write() only after
> > construction would lose that state if the process crashed before the
> > write. It would also require copying the entire structure into the
> > file's page cache.
>
> Yes. Unless to would try to bypass the page cache of course (if possible =
for
> your use case).
>
> >
> > During construction, writes are scattered throughout the mapping,
> > dirtying pages rapidly and repeatedly redirtying pages that may already
> > have been written back. The goal is to reduce writeback of these
> > intermediate states while retaining the same page-cache pages for
> > subsequent readers.
>
> What exactly is the poblem with writeback here? Unnecessary I/O? Is write=
back
> the problem or actual reclaim after writeback?
>
> (I recall that in a fuse server you can in theory delay the writeback req=
uest.
> So maybe you could get something going by serving your file through fuse =
and
> enlightening the fuse server about it. Just a random idea.)
>
> >
> > The hint would remain strictly best-effort: memory pressure and explici=
t
> > synchronization could override it. By "process crash," I mean terminati=
on
> > of the process while the kernel remains running; recovery after a syste=
m
> > crash or power loss is a separate durability concern.
> >
> > Regarding the interface, madvise was only a suggestion. A file-level
> > advisory interface would also work for this use case: deferring backgro=
und
> > writeback for the entire file, rather than individual mapped ranges, is
> > acceptable.
>
> So fadvise would be an option. However, this "defer mode" is really odd. =
It
> sounds more like you would want to have a custom policy there, instead of
> hardcoding something that really not a lot might want. Hmmm
>
> --
> Cheers,
>
> David

