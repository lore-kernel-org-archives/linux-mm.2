Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25FDBC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF8016B008A; Fri, 10 Jul 2026 14:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCFB46B008C; Fri, 10 Jul 2026 14:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E126B0092; Fri, 10 Jul 2026 14:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B03606B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:25:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5215B1A04BA
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:25:17 +0000 (UTC)
X-FDA: 84973694274.01.6487B24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4FD7480003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:25:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kK/1O+W3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783707915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZekBbFA9NhngbLYIVC+8htxKlJKsz67NZnwnFVfRBM=;
	b=vxRy/haWC7WhtKKdBPovgwCqA7sTlSf2Y0Im8k7NSQtrEZx6BjaZ4GtSjQ4kldV4LPCu5F
	Elx2KNKlK9zfuVxh8DdDbhAVJBWblx4lUoNH8Kwq1DCMLK0xHgGsgJpvT/DIx0DA0gIm8w
	jpNMMHu5Wa9dlUnHkedOH/KKZZ9PhGA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kK/1O+W3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783707915;
	b=gQCjhBoEcwClh4/AK95E2pujZ3T/HnLbxguCUdT17f+6nmkWEaCZYGHDcY0YwISZoU1Vgr
	L19uOphy42sWEi2H3RgyhbF+oA9y7LcNScahtEs8yrshrnKwMyM/2fQ+oZezBwcZ4QBT9B
	GI1xnQ20ogHcFO0lDQD8G8uw1Ix9HDQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7695B43EFE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5294B1F01558
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783707914;
	bh=ZZekBbFA9NhngbLYIVC+8htxKlJKsz67NZnwnFVfRBM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kK/1O+W3osF9lgM9cCR2fSLVCuFSKquZMb8a81GQnUuMXdBkPWJLYf3vkFk2v9aOx
	 Rq5g37N3VKaT96KU0NhGdys6TP1Zmwo24/ML6c3wsJXjRNZ6mPZTJI8PcUcf+INeR/
	 oRkxx3luKCThwCDDcc/+HGxyaUYQP3QcZ/OIesIm+aUSkP3CkLha7AVUQQ/q0CBGTF
	 f6k3SVvuGRznyd6r3MaQG4xDKKa82O92etN9/H3UJux64t2wexnmSRle2dioIGtXiK
	 6mQ4VXDL1PsditNjwJwTrO4in52ocoOunKlX966sM1PVKUDeWB9OGB5hVdB0EBTMs4
	 BV2VdAHMRH1CA==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15fd3a299eso156662166b.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:25:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RopM9wYtd5nGQzu4gUlqNLTxFPZvAFjqfhIFgIP2cankPfBbTSUVe3hGgI6CpbILYHSXayFhfsykw==@kvack.org
X-Gm-Message-State: AOJu0Yzt7o4sx3MhcJMWlM7OapgJs+/vMdbTtg5ucyyWM+5NAAFP4krj
	K3gayWKmXnXnqz2v396DkcvWDhQ9cSMY/Fo/V1u/QFaO8H5kooK7r2yxy9veMB1HglMniD23OW9
	4BuJNkYppD8DmsnuMHrT+BS1eBxwiz6I=
X-Received: by 2002:a17:907:26c8:b0:c12:6cdf:6071 with SMTP id
 a640c23a62f3a-c15cdecfa6amr810724166b.4.1783707913208; Fri, 10 Jul 2026
 11:25:13 -0700 (PDT)
MIME-Version: 1.0
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
 <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
 <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com>
 <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
 <CAKEwX=M7axSs2FJDq0KF3GBDpd6G0J=gP_2boUJraNf8M2n3Bw@mail.gmail.com>
 <CAO9r8zM8qk9g6+B6GiCV3oytjViMTEhbr0KjrccU+bF4+PMfTA@mail.gmail.com>
 <ak6c2TaOlcGxZ2Ih@localhost.localdomain> <CAO9r8zPiOyri2wVxRvB0bwEXf9bCKoPsQmRzOpj01XozA8hqUw@mail.gmail.com>
 <CAKEwX=PLauANTu8nDLbDmViQ6u9gvh7HbKffUAzUXuBa6Jes=g@mail.gmail.com>
In-Reply-To: <CAKEwX=PLauANTu8nDLbDmViQ6u9gvh7HbKffUAzUXuBa6Jes=g@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 10 Jul 2026 11:25:00 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPiK44=LA4bzyS=WA1irGFL-YCKmz7u70v-ddEVj5-zSw@mail.gmail.com>
X-Gm-Features: AVVi8Cclh0zv6h_QCsnP6fSkY8HFOsG8hOvjUqUDiHIONAoQflK4FdYIabyurfE
Message-ID: <CAO9r8zPiK44=LA4bzyS=WA1irGFL-YCKmz7u70v-ddEVj5-zSw@mail.gmail.com>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: Nhat Pham <nphamcs@gmail.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, tj@kernel.org, 
	Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4FD7480003
X-Stat-Signature: xhsz8ijp94xdff39pr5foeidetki89sh
X-HE-Tag: 1783707915-529960
X-HE-Meta: U2FsdGVkX18xJCLyrEy+Jlp+HZwqQ7dKzZVyBkEh+1InECCHHQtdkEd20EmzgFX9qQWgv01rtITKIYX9UIKdp3vCGuetl6Z8lLF1/x16lz0Wp1gUYoxxPU/wMoWFESdVTK0fQI4VH6jOhyPS5k3a9bwda1ffqbO5fsNbzqIyhndoChIZfh+wZuZtYibMQkZb5uKF7aPf/KPXNLUQEqY9bzEmwq+nRjPf9YynMpDDPV9yacSomE9GaMeh1RvlSZg4cSmF6UPVuHQO+pAu4AyK4eK/sWLL9R8Hhy1uy2NXi4Xp1JH9etfuPwZ91T1gAKvXgiEiNv+wpO57L/IXnDbX4gnVDzExIsN8r7SjSsQKT1zdXgHXo+d6XyQt1c/ah7ItZOymqYI0nLJIBcG6r1P8twe8t30AxgMRpsWdavd0p+hE0b13HZQckERFpkPF+MYkDKlcqZBAW0Chlv7tv7paXmyrQtM1TEOU571qUKwmEJN3fSsdCp0lo+UrsiYYQlk1csGyEGzpFkgBb+wBZlHFCITw1WpWaUnhd5SLLImowSX4gl8XN/yA1vi7QuUXlxVC2xh8pqFE8mgXBjLidGH7Ros2utmh+E+wp34QMd2BODy9Xors4fO2Z7Uyuscel2oafp+WD5FzHqm3jGzg0Ky0scom7/jv695yCj21ESLjN6vkAWhC4jkpXZyxGOZpFtnWfyMdABuHVLLxLGwS3SSEy//dxWt/m592tfTDY/55Y6KU7w8Bx2/xSa+3imvMAlQ5KU4HPEgbAOhl4LGl4CaTukZN4yjmb0FMWx5OiSlnfgUFy6olB2bvY+lpvBfI5lY85MHRYFK2UglDcGX+E16YXr769vP/6JG+zA7ZJ/eZfGNhXbBt3N2WSH+R0pR37MoQ5Tn++uvIprjBVu86ojqs9X2GnsR2GM3Eu/+1n0AlbKjH0n0Tf6HEjOlPAHToqrufsuOj6d7yWFcbb79H+AA
 VHHPf39A
 mHwtuRPGaehHf+PdqHo+2uL64+ylm+G7ExNC6izkX8XfbMYxCTvdfSichwoaBbURSh3Moq/Wz+4v7D+C+0ZePJMks03qfPW6L+4nd8/bOFF/UqqeJSbRVsnm35fv4zh/FUFEElWLImOvhXCw5hSvPiZ2NsGOuLnNcXNZvLBHpIyoXeqJMHBZSthVRHVZ8r0W/VV96NflCpMm9IwLUgsJw+T/f9qeFy0v5B7BtqjT+SDDYSb0L2cZf6HV54xdzbZEB90ARuCvfv8szvDGQ7azVqb96vdy5s+1fExZdG7kSy+mwDnfdBrdRz3pQ+sTrs0q1Nvl9UC605WmEJpsGnpoqkEqEdkLHT4qbPj0cZAGPLvE9ekV3Pg4E8xD2SFvGzTNJ54harPABGNRye3AuPOcLOJD/gxL5pPFiF5KbJdNyoawwtRGL6H/g7ZK53A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 10:30=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Wed, Jul 8, 2026 at 12:08=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Wed, Jul 8, 2026 at 12:00=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@sus=
e.com> wrote:
> > >
> > > On Tue, Jul 07, 2026 at 02:49:56PM -0700, Yosry Ahmed <yosry@kernel.o=
rg> wrote:
> > > > I would honestly rather use more memory. I think there might be cas=
es
> > > > where the flusher is delayed. The flush being slightly delayed is n=
ot
> > > > technically a bug that we want to see a failure for, but if a large
> > > > stats change is not visible that's a user-noticeable behavior that =
we
> > > > want a failure for.
> > > >
> > > > WDYT?
> > >
> > > There's already the (recent) page size-based scaling, so the idea wit=
h
> > > nr_cpus scaling could make the selftest useful on wider range of setu=
ps
> > > (even page size can be considered as a slight implementation detail
> > > leak, thus the justification of nr_cpus dependency).
> > >
> > > Also, I still think that internally the threshold should be changed t=
o
> > > the "harmonic" formula [1] but the selftest can go with the linear
> > > dependency for more pronounced effects.
> >
> > Yeah I agree the threshold formula can be improved, but we need to
> > make sure performance doesn't regress.
>
> Yeah that's a separate discussion indeed. For now I'm fine with fixing
> the selftests by using more memory.
>
> Is there a good generic formula for this? I understand there will be
> hardcode values, but at least making it scalable (by how much memory
> we have, page size, # of cpus) if possible? :)

The rstat formula depends on the number of CPUs and a constant factor
(see memcg_vmstats_needs_flush()), but this formula is for the number
of updates (e.g. number of pages reclaimed), and that value will
decrease as the page size increases. So I think we want to scale with
both the page size and the number of CPUs. The amount of memory in the
system is not a factor for now.

