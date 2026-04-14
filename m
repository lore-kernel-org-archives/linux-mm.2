Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA3EF531EB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 03:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD6F6B0088; Mon, 13 Apr 2026 23:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87346B008A; Mon, 13 Apr 2026 23:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B288D6B0092; Mon, 13 Apr 2026 23:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CEBA6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 23:27:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3669E5813C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:27:30 +0000 (UTC)
X-FDA: 84655726260.07.2165DC3
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 36A28100006
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:27:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LmKShUIT;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776137248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pOnRFYTB9oKY4AxXu1Op5pVF1RPrbIg8+CUKW94/JvQ=;
	b=VXuqYjQMl7rPDHAbqFt4Lnbp5JlEQj97xxaDwOIOL8k/Z48r2KtR6ZI4UoqySEiebXIE9g
	6RduScYdlBnGIrc3N+rZrG8rU8vi/deQJ6qtqQ+Kn16G77hMRCSpbMBDEkuULcZyh0/Vr+
	WNdxik/vFeXOCk0BTkP97Fx/7xJgryE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776137248; a=rsa-sha256;
	cv=pass;
	b=sINGZHQ94smDQWaImw2PYpxAPjxLhizDo3K/Me7a8zkwXVZGg1JgsiV2SSguyuPGwWytQj
	m+AfZpS1bPg8QaEwc+8TI3hWSI57kkBWXw3eN5pTvlyRgon/aaRTwvGpEb3xK5xOo0e5yH
	l08q6QakzAPPgv+vk9emCaBQX+VEslM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LmKShUIT;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6715006f4f7so2850111a12.2
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:27:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776137246; cv=none;
        d=google.com; s=arc-20240605;
        b=KARVAiJNfQpMZbR1fuqZ4eVl+5RyqWbgZ3+8v8+z7P/05hW5skSndPSUELtfca9L2l
         RVNFn1z8PNjsCclFM9nYIeil9aFDn+uNOPCut5/kyhlx+Y5/bl4fciz+xnhR0mA/nnKh
         a4zUolaHaj1hhmu3P0JvdQajzfUk4dRuz5XNvPTD6itahb7TTNk7xvB1OwNR/LBIaB1R
         zHyQ/1ZTQ6kQnn2gVxg3fILFzjoMsXc95opJnxECJ3Nx/WWSmeXhT14N9MmaBsnCLYVX
         2RK27yPGvkIBIVUF6EHHIPW1AI6f1Siz07HZVcOITSyLKHhR7DY3bSN/6Etw9iy4+ZXA
         n/Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pOnRFYTB9oKY4AxXu1Op5pVF1RPrbIg8+CUKW94/JvQ=;
        fh=0180xE9z9SzChSIEw3mGw0e4IIaQspy4QULOzvdOHJg=;
        b=T1gG9le0jT2H985IPLu7kWoGXsD/MJsGG6WYaa/lID7Y/n9WZWv17oObUXxJZwliU7
         BhTddDJnuR4QFJImdrXn/bsOLPdRT6u1q811J3CriGrIjaPGSpubQUO1Fm2vcvieRKpz
         MYWmzee/WMPjHPxWZB9gLhRov+SX/3Dd0CDENiEnH0e0fOYjZeyYYTFIe/flPAojiFJY
         mYrAGlerHYP2Zt9WdioCCI6NIDzECiV7VH6cOuOIkHHuh9DekuYaBmD7pbsVnljCuxtw
         Y9cDICZMJWfmkKyvA4NzBdG2jg6sNZfmRhLuAo3GOep8pKgPLLumSuYUxSvK79/f5eF0
         FCmA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776137246; x=1776742046; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pOnRFYTB9oKY4AxXu1Op5pVF1RPrbIg8+CUKW94/JvQ=;
        b=LmKShUITjeRHsf75wEP34lWW/MHZamPbBWd37CSwTlxsVRz0BGtTJTTBU46XtfBLrh
         O7htlYlvd68ycouG8nMDb/cFw+Elq6O4jYcRSTNGHxyC5OZFtMURP2K32MpLF4NiPxce
         ywlthCC6sc/cOpC/vZXaIspWZoizKQ8RpnbciOeON+iZFZ5QERK8CNlbvKNRSj7Ev7WS
         Qd3MaOFn7L3Hxlm6dT74uovPp6pFLHoitvZw1C2bDxcjtD29HS/bQhZderAuPflmwkJi
         Y2yrWbfO8e+rmflYrw6mTtd8ucthVzgNLnbmNpZqsAssG+L66F38J6F1wOWWVF5XtqDr
         o7Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776137246; x=1776742046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pOnRFYTB9oKY4AxXu1Op5pVF1RPrbIg8+CUKW94/JvQ=;
        b=IRxsmYF1nySEJZi62AIE/etlSK7k11+IFN2sDg/OtMrQzZXJEax5QclgzSuOW8UO2d
         yMKiFywp6aLyM0sUSkYtfKnn7nNqsQi3fgY8HvwHm4r4Shoh7NMOwqtPtKujokFQNC97
         GX3E28TefyxuEDGlrrvHDWbtwqZ1yQ9SoHPwDCqNrBQgI3E/OUDBPv8QqR35o26TmSxP
         NE6h/xiXEeopKw/cLwgqcocbuBHpt8xWA6cGyDqK6dpcwf2SjPTuLyjFMzTvy0xuWN4h
         KSbzH5rgLIvHxlh5nl9OFNoQ3hLAp3bpOoN9c5nGKnQzpByzuw7Df2iE/TUkCK9S0El1
         az9g==
X-Gm-Message-State: AOJu0YxfpcGcvwjBodGZu3IyKDIHY7+ZlrJUFEa3nxgFfG8ZGWXD2ssM
	z5v0BmtHWjpi5S9UVa9YH0tSN4ZQAQevaGSUuBE1pSryE25yAD+4/FAqlqD/iYTVcaRDac7uJ1l
	DVlVuZrPjiR9SdT83ieLU9lbdvsROWlk=
X-Gm-Gg: AeBDietR/fI5LzsZem0iWyG/tJPT5Wk6pygWiZkhploOA8CSdwGXiQY2l8DF5dV4QBk
	TPpXTY5zEu1p3KEQOqh/CJOhavOhIZBYCG+1tFM3UrO0WQzxYqd0CtCBcMqI2KY7b5w8cxMFeOm
	OcfhyrOJWSZH6KeO0RwCWucLHOxnGa/XQ1cimwbGxuwQHmhYvecgVnPx3YlzYwRM6rCG5ISxOgE
	54lkn24zWhZ4ntZGnkpK4TKFoGK6cNfaJVupdl+lCYpiOXyMCeaMSaSKawtO4m7rv6fnzr/Kc3s
	8uh/I6zcL5ydn/tJJy/h7d6aIIrkn8g9uwXGnUXr
X-Received: by 2002:a05:6402:2116:b0:671:a6e2:97b0 with SMTP id
 4fb4d7f45d1cf-671a6e2994fmr2262250a12.0.1776137245805; Mon, 13 Apr 2026
 20:27:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260407-swap-memcg-fix-v1-0-a473ce2e5bb8@tencent.com> <adycRemx6QmSOX8n@yjaykim-PowerEdge-T330>
In-Reply-To: <adycRemx6QmSOX8n@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 14 Apr 2026 11:26:49 +0800
X-Gm-Features: AQROBzCyZoZKqmWRCentpJTVxu-E7g1IvgKn93O8Ud6MPqO0q94XIMEqzEqSiZw
Message-ID: <CAMgjq7CEY+4JqUcnqbEsr7XET9oD7o+Dra=8dn_BRouu39TkSA@mail.gmail.com>
Subject: Re: [PATCH RFC 0/2] mm, swap: fix swapin race that causes inaccurate
 memcg accounting
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chuanhua Han <hanchuanhua@oppo.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 36A28100006
X-Stat-Signature: pxf57d4yfq5qds85zf5mumc5m4mmqata
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776137247-430253
X-HE-Meta: U2FsdGVkX19eBfZkxawa4FKkwzXBYingNIYHmEZghbCicPdIfKzBvgmlQ3OO7tZxejaG+zB8lszxjZvk8aaWfehRw+G+CZDEthp/oQvihgjD5bVS99fxx5Ls4zXuoeZlaa9Q6wK+y3D9Ge5VstZxuLzAXneHNYQqpfw6rogeZXUN1hBQeoUPTaycd5+m6En+b8EBA/sAnvbiI+oS2iy4nHlGeGkE9o+0SWZiulsEdSfCg4g2iY+c0rN5CFKc84IosnFnRZlqDDblMftMEXZK3BE4epXsH6TYXu1rDLb3u7eDHOvvdkZz8mZqvdJlOB4A9SlCwu6RLEQz4Ll1/4P1Pp3xzg//+30qxsIlyO9HpXly/A/S2zpooEWY4NlC09aydh+fLqph+A5rX+H3hnmIFB4XpuIk4HoReq3CxBVvXKaOaNOD/wRBkp5UKRDqKFezGARC7cVXFOKhQnJYmdiBjNr8ZA6A53rcGpHIbjVmHvGSY6v0Laa9NOmJz8FaYjSCgOTramX74o45r0GsCKU3fLXq/1VOeOnSjqeK+cVt/EuSFLd8dEBG8kNaOjTbFVn3vMn09wl8bDPr8rN0zeGV0JobpN3VRFX2cNrIacCUxkwPKAD4Iue8YPTeFb0PgJqd3rshIm//BY/FbR4Prl+krwdfCd+FIZmHVTynfOCmlfkOKmHwimMsfgB4V1NAe2JCldtbRIV78TReD7L8XkwiUQ89eLQxUD7XddizqdRPc8tQQTuBy2usChvIJE10dRUp0vGhPB71UPAE6J2yyEMPIh40MayH3Bzd676SEVmoaOHnmjCd3D9nkHDUFg735qAZQTHqCH7bkiPTbh1dbvZTFhCD8O9GUnyOIbKWp+wchlDwoFdozlEDY7/l5XPUNeSMkx8EFhwO6prGyireL0Jk9Rz+T+JsPyE9yQw2UDgizFXozEYxvK0cexEKqDVtt+HhlJgN257JzMl28oxfiTf
 5FS9+OKh
 ie6YWviBf6oWtvTIJnCrZLM/bLRCQoZR5crxTjVxZJhcUnC0Sr44YKm+nNMSnyS/s+GbNK16inL1vdPP5w6WTJGOLr3cIhgc0nuilU5sAdXWmxH0JkMuBiBYTVj8B1gjplOoR0aDX1EaVXM2941dYj4U147QsiSkC+S6YYj5/tyVae0n/n1uznvkD8qMw+41yB7ZOFt1j9cz5etzK3ICNkp0WbSuWsvu96TndjI5XpJ8ehzYXsgCZvi4psd5HqsbS8o4slCvl1gH+Tzh2GcVwCwsHhGZwBQCGew9AhgBgpIPbXDv+REgnrWqQpydi43PENAUJkvMIzkMQoFTnzHNDv/mIop1Jk0oTbUoVkFBTgxIYeQjkvXL4C9NsHOIev2OdQ+rcU0ZgTpjSTU+venLUTEBYtmZHhS3vK2NQa3Gbvq67iyVCPuVQvGyT26EpADypkI5rOTfUXEDWUSiEI6FG9kQ9DJpoSlD+DT/U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 3:54=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Tue, Apr 07, 2026 at 10:55:41PM +0800, Kairui Song via B4 Relay wrote:
> > While doing code inspection, I noticed there is a long-existing issue
> > THP swapin may got charged into the wrong memcg since commit
> > 242d12c981745 ("mm: support large folios swap-in for sync io devices").
> > And a recent fix made it a bit worse.
> >

...

> > SYNCHRONOUS_IO fix seems also good, but it changes the current fallback
> > logic. Instead of fallback to next order it will fallback to order 0
> > directly. That should be fine though. This issue can be fixed / cleaned
> > up in a better way with swap table P4 as demostrated previously by
> > allocating the folio in swap cache directly with proper fallback and a
> > more compat loop for error handling:
> >
> > https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-4-104795d198=
15@tencent.com/
>
> Hello Kairui,
>
> Nice catch!
>
> I have reviewed the proposed patches, and LGTM :D
> (For 1/2, flattening the if-statement depth slightly could help readabili=
ty.
> However, since this is planned to be refactored as part of the P4 swap ta=
ble work,
> I think it is fine as is.)

Hi YoungJun

>
> I mostly agree with your rationale.
>
> > memcg0 is not completely irrelevant as it's true that it is now
> > memcg1 faulting this folio. Shmem may have similar issue.
>
> That said, I would like to leave one small comment.
>
> My understanding is that if we account based on the folio that was
> allocated while running in memcg0 (on CPU 0), then having
> set_pte_at() install it with memcg0 already charged may still be
> considered acceptable from a acceptable coarse-grained synchronization pe=
rspective.
> (cuz folio is alloced at the time of "memcg 1 epoch")

Right... which is also why I sent it as an RFC, I wasn't completely
sure that if I missed anything. Charging into memcg0 is not really
that wrong, so this might be a negligible problem.

>
> Let's think of the situation below
>
>   CPU 0 (memcg0)                 CPU 1
>   ---------------------------    -----------------------------
>   charge folio to memcg0
>   allocate / prepare folio
>                                    task migrates to memcg1
>   ...
>   set_pte_at() installs PTE
>   (folio is already charged to memcg0)
>
> In this flow, the charge follows the allocation context (memcg0),
> even though the actual PTE installation happens after migration
> to memcg1.
>
> I understand that we cannot strictly guarantee correctness without
> fully synchronized migration, so this region inherently has some
> ambiguity. In that sense, the patch is addressing a corner of that
> problem space.
>
> But, I largely agree with your argument (the rationale is sound,
> and the change is not intrusive).
>
> I would have no further concerns if the following hold:
>
> - There is a tangible benefit to modifying this patch.

I can't really say that. The effect might be hardly observable, the
time window is really short and a few pages of inaccuracy (and in this
case, it's not completely inaccurate, just ambiguous) of the memcg
counter is hard to detect too.

> - There is no meaningful behavioral difference between charging
>   earlier (current behavior) and charging later (proposed change),
>   (e.g especially when memcg limits are hit.)

This part should be fine. Charge after swap cache might help to avoid thras=
hing.

> If those assumptions are correct, I am fully on board.

Thanks! It seems the benefit of this RFC is indeed trivial. I also ran
some performance tests later and didn't observe anything meaningful so
far.

Maybe we can then just go with the swap table p4 series directly, I
might overthinked about the potential issues, it would be solved
cleaner if we skip this here.

