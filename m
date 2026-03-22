Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB1E9D58CAA
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 22:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 205106B0005; Sun, 22 Mar 2026 18:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E466B0088; Sun, 22 Mar 2026 18:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02E7D6B0089; Sun, 22 Mar 2026 18:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD4EA6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:04:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 995241A091C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:04:25 +0000 (UTC)
X-FDA: 84575078490.21.5B6FD4B
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id 754F8140005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:04:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=twYxqtoO;
	spf=pass (imf09.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774217063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ri4lHYfJVw85l/96eAcQUjigQAVRnpKam0B4k1gAuzo=;
	b=KG4hGEEXImJHpSi0lxk6pAfoyx0u318/u6A6crb2pV2vAu2ZUczEt22WCFCs28P+fNT35J
	Q/r8Vf9pjUxZnb0ncQ4Cdqav4XIutindtQe8cyZ1/NMZ8aTvzv24y4cfNjj7mcAJ+Rakpi
	oCl4LgZ+xS/mim0KR2HXF9MuwffF0TU=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=twYxqtoO;
	spf=pass (imf09.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774217063; a=rsa-sha256;
	cv=pass;
	b=DHjZ+4LGxmtoGLt1x8RVz+HZzg0tSKIM0imvoWz6CAEXYqNUAn2/L/Am0H8u9HBYq8VL3l
	rStPB+oo2V9nvDEK9m8f8sXVuSJJ6s3FCvzudZP1/rmaLYcgWVWY/ruvMKHavLdc5rf8NF
	r9yUEP/TrJJW388hemp620WI47WKbbk=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48569636800so101605e9.0
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:04:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774217062; cv=none;
        d=google.com; s=arc-20240605;
        b=h9ZvyGdBwaV/+yNBbn6J/1WmG+QJWKeTKe2m4pOgBEQqCRHQq0TEbgDGrNDON1Inr/
         d4lXa9vqwmuf7xop8SIcCr2aZFK9uJGqzp10QDsSe38rxzbFvuDtXyIZMIOkPyQCMdLi
         m17/pk6PePmMylzZFefJyffcUwrAyJbZRupcsqvOCDab+KmGrEC/Kk2PBT8ag6GdJe/8
         jXLg+UaKe2JTFCSdJgSlDi9rvuVjO1r2SSLQw33rocTyC2th1XmqY4HmxYgK0ndFnykV
         OvUotuEGDv7Lv5xw6ceZD6F4XWb+RTFQcRXmHoiUqZ10U3d0sUkGVvFT7J2AJwuzlq1W
         T/bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ri4lHYfJVw85l/96eAcQUjigQAVRnpKam0B4k1gAuzo=;
        fh=gwEBTzhgHawuVrlzFcL2gedcVKWxn3ewr88Zm4Ul5t4=;
        b=kzvxyKnNZOYz+VJH+C0qheZ0MbsmDSxRguAAKnlhO48HRX3fIOBttWlyKsWxZ1Bz6S
         OfGBKrEhpaY3S1vW/DOuQlI8qYcmQxVphBMWdpvURdB9YUpQ+b8sg6ISGyTuKu9W8tqm
         2uNlcfiyeOfWRo/lmBW0v3yGeu9eJ4R7EY27fOjAvc0Bw77BzET8pSxazqFE2qf1OHwm
         Slij80+asKnvXIA7hUj5xo9f30gA3lH7ExLEIYflWxomsEgDJfuN1Ra+/vzbh/asxvzZ
         csWRXuF8pKI1qjUzFGzMMfoqkSAhUST3hZw/ShY16zNF3D9877fVtBpFzDOUA2fxkT73
         oASA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774217062; x=1774821862; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ri4lHYfJVw85l/96eAcQUjigQAVRnpKam0B4k1gAuzo=;
        b=twYxqtoOLFGajbdRxWFP3JK1JdkLyDeXvbORa94GofaEUkI1srzcLdUow9OJC73Ug3
         AzO3LD2aAGaMtxqg5qqNYRaUEvJoPhGg4qB45dkLU//sFxcUJHnfzZ2n0csO3zmMBaIp
         uulhi70zXrSQCrKX9Z8ZBqDW/6HwfViTZu/cQwmhetnZ2G5ytzNgbKD9vv0rg3uHeo+Q
         qfKoYz1bxr+dmIuc2brge7d7J4M1GkPsSHSqlvJ9VHN5yj6nSBEXPxIIw51rtSfjDbAF
         rTw1YP8YkNaeDvxBC6yXY4vHqmIdEch+oElQ3XOZzKMinJQZFIsDD7lssoHj7yt9HVkL
         a4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774217062; x=1774821862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ri4lHYfJVw85l/96eAcQUjigQAVRnpKam0B4k1gAuzo=;
        b=fFKl5umchY902PiqIB7f3r/TDtX1gusWc4QV1ozRfYZY+xlQnBPAQubCIW89jF1mSL
         /xEahPEVhSc4XAB9UdxNPxsA704893Ot28b7qIevXqIhuHAVYF7wyjKGkUBkyTd6U2hl
         36g5U0VVvbSfjSFxwhPgw0/HkqCdJYbsqUK0ILfOD5D1NYwnJT3tze4QdD8U0T4f8GbS
         PZlqhqWbhK0VJvahEI9mwa9bu2w+PfWK03RkiBONh0q6vN46RZc/Mcn7VkQKSp7LgvpH
         qaZaFfXd1SavqbnTY7jbotgkapyk2KL8BwkzCoCq6jHaiF4dCMxum7njSi3X1XweylKu
         MBIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfwU41ZdnQGZMMuv07J2Ku9Qhy7SB0RtwjH8OHFOcdin9YvElpn77ywMjl2QCGTd/O/3i8DfLZKw==@kvack.org
X-Gm-Message-State: AOJu0YwkPAKw+g6s6J5eP47QmsfZ0lBoncVcv2PGBIcNS2hfoCxC6Soz
	PT5ZqUiFmu03UNU5v20y1D6ajngDqYCfZ59D+vp2jf/vbzu0tKzpNZVYuFDwp/W7ciIGCTZiB/j
	/MV+P7a6m7M2gCsaWPbScMIEHFjtOQ8azf+sxUbnj
X-Gm-Gg: ATEYQzwbkcbu1+uqHoUjvliPwbPdpDlnUllLfk8A10tu6i1jz6z8d8Tj7Vg2z0MDP9Z
	dtkM5sWCGS7AR+g33BfxM1S0p3ADdTWvlIOnyhmJ6vq3BSCvhzaCUqpFmnDY9nE6hrgawKwxtDz
	bctaa6JZNIBTyhW174ATiZLfYSUDKb3QNj2zEU2tFiP55KeK1046q4kVu6ex0C8v7958HxE4AR9
	d+PANRJpB8HelR8hifCIR+s2x7PgSoYXg0MxHYVSJP5j6ptp2MFBF9WYC5S/EVUTPo6Pe6S5+KZ
	niVBcrtcIKsJ83lykJtu4a3YtnQgjbtpvgsy1iDs
X-Received: by 2002:a05:600c:3f1b:b0:485:b6e4:9808 with SMTP id
 5b1f17b1804b1-487037d0152mr1453745e9.1.1774217061445; Sun, 22 Mar 2026
 15:04:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260203192352.2674184-1-jiaqiyan@google.com> <20260203192352.2674184-2-jiaqiyan@google.com>
 <7ad34b69-2fb4-770b-14e5-bea13cf63d2f@huawei.com> <CACw3F50PwJ+sSOX0wySQgBzrEW2XOctxuX5jM37OG0HS_kHdbQ@mail.gmail.com>
 <31cc7bed-c30f-489c-3ac3-4842aa00b869@huawei.com> <CACw3F50BwnLJW75EXgz0t5g+eUhr+wKgJ3YfRFq5208N5KfaiA@mail.gmail.com>
 <a0d25caf-a18b-e3d8-e74f-fc18fa85252e@huawei.com> <CACw3F51+bAm03nvucV54bkThnYc-4ewgqGzq_c5i6oMmnGdEtw@mail.gmail.com>
 <a3ff8c7b-69c1-fecc-3564-ecaa3e8a7e67@huawei.com> <CACw3F53qr1Af=r__SNxU1ohr69s8apHqHz9tcEHg1hDSLsk5TQ@mail.gmail.com>
 <6b304954-f3d1-5581-5937-1464caf85ab1@huawei.com>
In-Reply-To: <6b304954-f3d1-5581-5937-1464caf85ab1@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 22 Mar 2026 15:04:10 -0700
X-Gm-Features: AQROBzAlS6RIdu-V0p3Jh22np-9jp8KFNc2vnNHVizPj2auHNAlaES0cJT1KD3g
Message-ID: <CACw3F52K3TTjtmaEsWLcei_ThKwHyn8xj=_4-vpiZhd-ciFU2A@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm: memfd/hugetlb: introduce memfd-based userspace
 MFR policy
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	william.roche@oracle.com, harry.yoo@oracle.com, jane.chu@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 754F8140005
X-Stat-Signature: 33a9ifpk3zf6t5isbb8k1dzxp4b4yduj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774217063-817969
X-HE-Meta: U2FsdGVkX1+DRxvjPwwg+30jZoQOj2AkW9GvaYXAwhIK9gtyfymNzQvhEtewjLee7nWX+aIbMloPxDB9fqwsOQUuA5j/5JHwb41bfJp+5W2cg6s0kHyEs6gSizFDbY4EJ+EMaF3wChJWkhf0oM6yy3A/vpZubLBTZgekMoLIq84LdmkgpahwqTnNb8f+SQpHoKKqa0YUo6Hov73cMUBPlP0rmYxDvlz6j3KeDb3KB4E3Zq1iuPmHeW6TIwWrQpVDkn/MkMyQC+d+FMFYQJRBcFDB0yiiL6NvNKtc+y0D9MkDH+Ynd2h7/wJcrBbonXR8FJ69FshNrN0981Rl5E9UmKvFFKIF9o+x5ajHCo3+ULKtLG2mTspnQmgYUFg4VHGF+qalddDfcAdQGkbi3iMqZ8agz4U0NPqskiha2WzS5uxXR95YccFzr9bg8bUsOG+ghfwZrgru3m79ok73uUhS0VsIECRdmlOM0Riu15aqDQbpGKza+A45IMzGzceSFfFU59BW7vCPfZh5DXcNhTO3xT9E/MUg3R+ILwDwSsdia9DSqZOtnJ8a1XjDZmASgVKjyq/5fl/LO2eSYT0iIHXbHs2cpMRD5FvsgyGGM4EDgOpQkBLX5Y7VpO009jxtbum9xvEC6VNXHneiAB5rdiglCzLgJdy9xzj9rxaNt2gM06lT9jI2SSp4OkpeSqh1O2YDgkCuEYY5Zghqx0p/+ofDcrAFB4DQjjHMtPDuTk612s9vsraxv0TReQGmmI4n7Q8jGSd1lwlzLxAjEpiqcpwqgY1z6UjTLLTtRr/6ySEI6T5PPYOsoIiGh17h7CKMWuGVZPMRTFTwhf8hOXkBWg9oy0F2w6bOYZBV5ZdqrzXBJogT/wiABoQXfBm1sYEUYD6TGRjo7LDOOroIYv9J635GSLP3hophks4nzQVAm/f3aa9cSjehk6Hj0mQRG8cXOno7fMnXSkLH/6wmbjz1D9K
 YRkEsaQ6
 FnYoOfke5/UA9PgNm5fqy28eSx+qievzMUT6D+AfPaYeXbm+u6gL2ZmqQh9aqRxZsa/0uBblvR09P6jVW5W8qFtMRmyWL+rXZkbIxGFoHiTaoHperPzNLrk8U5niHQD7yhVY0dbM8n/XqDFxqTjS87I4B4BR7KyJTU6Kce1oDVsrKR0GBBFwbOgvhwXGc/L/IZVp4TAWIFBucRJ+7VnrTdT5AcUxwovaRI1KqPCH94MI5kPNp44z68cgXvVy8HIAeTc6uFfd3IBF6rVyN2GyDQAS/TE0UkyW4BZG+unhHuQu/GIM1fj6cX856KYWmVSupB1cVHPbpQyEQ29A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 9, 2026 at 7:21=E2=80=AFPM Miaohe Lin <linmiaohe@huawei.com> wr=
ote:
>
> On 2026/3/9 23:47, Jiaqi Yan wrote:
> > On Mon, Mar 9, 2026 at 12:41=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.co=
m> wrote:
> >>
> >> On 2026/3/9 12:53, Jiaqi Yan wrote:
> >>> On Mon, Feb 23, 2026 at 11:30=E2=80=AFPM Miaohe Lin <linmiaohe@huawei=
.com> wrote:
> >>>>
> >>>> On 2026/2/13 13:01, Jiaqi Yan wrote:
> >>>>> On Mon, Feb 9, 2026 at 11:31=E2=80=AFPM Miaohe Lin <linmiaohe@huawe=
i.com> wrote:
> >>>>>>
> >>>>>> On 2026/2/10 12:47, Jiaqi Yan wrote:
> >>>>>>> On Mon, Feb 9, 2026 at 3:54=E2=80=AFAM Miaohe Lin <linmiaohe@huaw=
ei.com> wrote:
> >>>>>>>>
> >>>>>>>> On 2026/2/4 3:23, Jiaqi Yan wrote:
> >>>>>>>>> Sometimes immediately hard offlining a large chunk of contigous=
 memory
> >>>>>>>>> having uncorrected memory errors (UE) may not be the best optio=
n.
> >>>>>>>>> Cloud providers usually serve capacity- and performance-critica=
l guest
> >>>>>>>>> memory with 1G HugeTLB hugepages, as this significantly reduces=
 the
> >>>>>>>>> overhead associated with managing page tables and TLB misses. H=
owever,
> >>>>>>>>> for today's HugeTLB system, once a byte of memory in a hugepage=
 is
> >>>>>>>>> hardware corrupted, the kernel discards the whole hugepage, inc=
luding
> >>>>>>>>> the healthy portion. Customer workload running in the VM can ha=
rdly
> >>>>>>>>> recover from such a great loss of memory.
> >>>>>>>>
> >>>>>>>> Thanks for your patch. Some questions below.
> >>>>>>>>
> >>>>>>>>>
> >>>>>>>>> Therefore keeping or discarding a large chunk of contiguous mem=
ory
> >>>>>>>>> owned by userspace (particularly to serve guest memory) due to
> >>>>>>>>> recoverable UE may better be controlled by userspace process
> >>>>>>>>> that owns the memory, e.g. VMM in the Cloud environment.
> >>>>>>>>>
> >>>>>>>>> Introduce a memfd-based userspace memory failure (MFR) policy,
> >>>>>>>>> MFD_MF_KEEP_UE_MAPPED. It is possible to support for other memf=
d,
> >>>>>>>>> but the current implementation only covers HugeTLB.
> >>>>>>>>>
> >>>>>>>>> For a hugepage associated with MFD_MF_KEEP_UE_MAPPED enabled me=
mfd,
> >>>>>>>>> whenever it runs into a new UE,
> >>>>>>>>>
> >>>>>>>>> * MFR defers hard offline operations, i.e., unmapping and
> >>>>>>>>
> >>>>>>>> So the folio can't be unpoisoned until hugetlb folio becomes fre=
e?
> >>>>>>>
> >>>>>>> Are you asking from testing perspective, are we still able to cle=
an up
> >>>>>>> injected test errors via unpoison_memory() with MFD_MF_KEEP_UE_MA=
PPED?
> >>>>>>>
> >>>>>>> If so, unpoison_memory() can't turn the HWPoison hugetlb page to
> >>>>>>> normal hugetlb page as MFD_MF_KEEP_UE_MAPPED automatically dissol=
ves
> >>>>>>
> >>>>>> We might loss some testability but that should be an acceptable co=
mpromise.
> >>>>>
> >>>>> To clarify, looking at unpoison_memory(), it seems unpoison should
> >>>>> still work if called before truncated or memfd closed.
> >>>>>
> >>>>> What I wanted to say is, for my test hugetlb-mfr.c, since I really
> >>>>> want to test the cleanup code (dissolving free hugepage having
> >>>>> multiple errors) after truncation or memfd closed, so we can only
> >>>>> unpoison the raw pages rejected by buddy allocator.
> >>>>>
> >>>>>>
> >>>>>>> it. unpoison_memory(pfn) can probably still turn the HWPoison raw=
 page
> >>>>>>> back to a normal one, but you already lost the hugetlb page.
> >>>>>>>
> >>>>>>>>
> >>>>>>>>>   dissolving. MFR still sets HWPoison flag, holds a refcount
> >>>>>>>>>   for every raw HWPoison page, record them in a list, sends SIG=
BUS
> >>>>>>>>>   to the consuming thread, but si_addr_lsb is reduced to PAGE_S=
HIFT.
> >>>>>>>>>   If userspace is able to handle the SIGBUS, the HWPoison hugep=
age
> >>>>>>>>>   remains accessible via the mapping created with that memfd.
> >>>>>>>>>
> >>>>>>>>> * If the memory was not faulted in yet, the fault handler also
> >>>>>>>>>   allows fault in the HWPoison folio.
> >>>>>>>>>
> >>>>>>>>> For a MFD_MF_KEEP_UE_MAPPED enabled memfd, when it is closed, o=
r
> >>>>>>>>> when userspace process truncates its hugepages:
> >>>>>>>>>
> >>>>>>>>> * When the HugeTLB in-memory file system removes the filemap's
> >>>>>>>>>   folios one by one, it asks MFR to deal with HWPoison folios
> >>>>>>>>>   on the fly, implemented by filemap_offline_hwpoison_folio().
> >>>>>>>>>
> >>>>>>>>> * MFR drops the refcounts being held for the raw HWPoison
> >>>>>>>>>   pages within the folio. Now that the HWPoison folio becomes
> >>>>>>>>>   free, MFR dissolves it into a set of raw pages. The healthy p=
ages
> >>>>>>>>>   are recycled into buddy allocator, while the HWPoison ones ar=
e
> >>>>>>>>>   prevented from re-allocation.
> >>>>>>>>>
> >>>>>>>> ...
> >>>>>>>>
> >>>>>>>>>
> >>>>>>>>> +static void filemap_offline_hwpoison_folio_hugetlb(struct foli=
o *folio)
> >>>>>>>>> +{
> >>>>>>>>> +     int ret;
> >>>>>>>>> +     struct llist_node *head;
> >>>>>>>>> +     struct raw_hwp_page *curr, *next;
> >>>>>>>>> +
> >>>>>>>>> +     /*
> >>>>>>>>> +      * Since folio is still in the folio_batch, drop the refc=
ount
> >>>>>>>>> +      * elevated by filemap_get_folios.
> >>>>>>>>> +      */
> >>>>>>>>> +     folio_put_refs(folio, 1);
> >>>>>>>>> +     head =3D llist_del_all(raw_hwp_list_head(folio));
> >>>>>>>>
> >>>>>>>> We might race with get_huge_page_for_hwpoison()? llist_add() mig=
ht be called
> >>>>>>>> by folio_set_hugetlb_hwpoison() just after llist_del_all()?
> >>>>>>>
> >>>>>>> Oh, when there is a new UE while we releasing the folio here, rig=
ht?
> >>>>>>
> >>>>>> Right.
> >>>>>>
> >>>>>>> In that case, would mutex_lock(&mf_mutex) eliminate potential rac=
e?
> >>>>>>
> >>>>>> IMO spin_lock_irq(&hugetlb_lock) might be better.
> >>>>>
> >>>>> Looks like I don't need any lock given the correction below.
> >>>>>
> >>>>>>
> >>>>>>>
> >>>>>>>>
> >>>>>>>>> +
> >>>>>>>>> +     /*
> >>>>>>>>> +      * Release refcounts held by try_memory_failure_hugetlb, =
one per
> >>>>>>>>> +      * HWPoison-ed page in the raw hwp list.
> >>>>>>>>> +      *
> >>>>>>>>> +      * Set HWPoison flag on each page so that free_has_hwpois=
oned()
> >>>>>>>>> +      * can exclude them during dissolve_free_hugetlb_folio().
> >>>>>>>>> +      */
> >>>>>>>>> +     llist_for_each_entry_safe(curr, next, head, node) {
> >>>>>>>>> +             folio_put(folio);
> >>>>>>>>
> >>>>>>>> The hugetlb folio refcnt will only be increased once even if it =
contains multiple UE sub-pages.
> >>>>>>>> See __get_huge_page_for_hwpoison() for details. So folio_put() m=
ight be called more times than
> >>>>>>>> folio_try_get() in __get_huge_page_for_hwpoison().
> >>>>>>>
> >>>>>>> The changes in folio_set_hugetlb_hwpoison() should make
> >>>>>>> __get_huge_page_for_hwpoison() not to take the "out" path which
> >>>>>>> decrease the increased refcount for folio. IOW, every time a new =
UE
> >>>>>>> happens, we handle the hugetlb page as if it is an in-use hugetlb
> >>>>>>> page.
> >>>>>>
> >>>>>> See below code snippet (comment [1] and [2]):
> >>>>>>
> >>>>>> int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> >>>>>>                                  bool *migratable_cleared)
> >>>>>> {
> >>>>>>         struct page *page =3D pfn_to_page(pfn);
> >>>>>>         struct folio *folio =3D page_folio(page);
> >>>>>>         int ret =3D 2;    /* fallback to normal page handling */
> >>>>>>         bool count_increased =3D false;
> >>>>>>
> >>>>>>         if (!folio_test_hugetlb(folio))
> >>>>>>                 goto out;
> >>>>>>
> >>>>>>         if (flags & MF_COUNT_INCREASED) {
> >>>>>>                 ret =3D 1;
> >>>>>>                 count_increased =3D true;
> >>>>>>         } else if (folio_test_hugetlb_freed(folio)) {
> >>>>>>                 ret =3D 0;
> >>>>>>         } else if (folio_test_hugetlb_migratable(folio)) {
> >>>>>>
> >>>>>>                    ^^^^*hugetlb_migratable is checked before tryin=
g to get folio refcnt* [1]
> >>>>>>
> >>>>>>                 ret =3D folio_try_get(folio);
> >>>>>>                 if (ret)
> >>>>>>                         count_increased =3D true;
> >>>>>>         } else {
> >>>>>>                 ret =3D -EBUSY;
> >>>>>>                 if (!(flags & MF_NO_RETRY))
> >>>>>>                         goto out;
> >>>>>>         }
> >>>>>>
> >>>>>>         if (folio_set_hugetlb_hwpoison(folio, page)) {
> >>>>>>                 ret =3D -EHWPOISON;
> >>>>>>                 goto out;
> >>>>>>         }
> >>>>>>
> >>>>>>         /*
> >>>>>>          * Clearing hugetlb_migratable for hwpoisoned hugepages to=
 prevent them
> >>>>>>          * from being migrated by memory hotremove.
> >>>>>>          */
> >>>>>>         if (count_increased && folio_test_hugetlb_migratable(folio=
)) {
> >>>>>>                 folio_clear_hugetlb_migratable(folio);
> >>>>>>
> >>>>>>                 ^^^^^*hugetlb_migratable is cleared when first tim=
e seeing folio* [2]
> >>>>>>
> >>>>>>                 *migratable_cleared =3D true;
> >>>>>>         }
> >>>>>>
> >>>>>> Or am I miss something?
> >>>>>
> >>>>> Thanks for your explaination! You are absolutely right. It turns ou=
t
> >>>>> the extra refcount I saw (during running hugetlb-mfr.c) on the foli=
o
> >>>>> at the moment of filemap_offline_hwpoison_folio_hugetlb() is actual=
ly
> >>>>> because of the MF_COUNT_INCREASED during MADV_HWPOISON. In the past=
 I
> >>>>> used to think that is the effect of folio_try_get() in
> >>>>> __get_huge_page_for_hwpoison(), and it is wrong. Now I see two case=
s:
> >>>>> - MADV_HWPOISON: instead of __get_huge_page_for_hwpoison(),
> >>>>> madvise_inject_error() is the one that increments hugepage refcount
> >>>>> for every error injected. Different from other cases,
> >>>>> MFD_MF_KEEP_UE_MAPPED makes the hugepage still a in-use page after
> >>>>> memory_failure(MF_COUNT_INCREASED), so I think madvise_inject_error=
()
> >>>>> should decrement in MFD_MF_KEEP_UE_MAPPED case.
> >>>>> - In the real world: as you pointed out, MF always just increments
> >>>>> hugepage refcount once in __get_huge_page_for_hwpoison(), even if i=
t
> >>>>> runs into multiple errors. When
> >>>>
> >>>> This might not always hold true. When MF occurs while hugetlb folio =
is under isolation(hugetlb_migratable is
> >>>> cleared and extra folio refcnt is held by isolating code in that cas=
e), __get_huge_page_for_hwpoison won't get
> >>>> extra folio refcnt.
> >>>>
> >>>>> filemap_offline_hwpoison_folio_hugetlb() drops the refcount elevate=
d
> >>>>> by filemap_get_folios(), it only needs to decrement again if
> >>>>> folio_ref_dec_and_test() returns false. I tested something like bel=
ow:
> >>>>>
> >>>>>     /* drop the refcount elevated by filemap_get_folios. */
> >>>>>     folio_put(folio);
> >>>>>     if (folio_ref_count(folio))
> >>>>>         folio_put(folio);
> >>>>>     /* now refcount should be zero. */
> >>>>>     ret =3D dissolve_free_hugetlb_folio(folio);
> >>>>
> >>>> So I think above code might drop the folio refcnt held by isolating =
code.
> >>>
> >>> Hi Miaohe, thanks for raising the concern. Given two things below
> >>> - both folio_isolate_hugetlb() and get_huge_page_for_hwpoison() are
> >>> guarded by hugetlb_lock.
> >>> - hugetlb_update_hwpoison() only folio_test_set_hwpoison() for
> >>> non-isolated folio after folio_try_get() succeeds.
> >>>
> >>> as long as folio_test_set_hwpoison() is true here, this refcount
> >>> should never come from folio_isolate_hugetlb(). What do you think?
> >>>
> >>
> >> Let's think about below scenario. When __get_huge_page_for_hwpoison() =
encounters an
> >> isolated hugetlb folio:
> >>
> >> int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> >>                                  bool *migratable_cleared)
> >> {
> >>         struct page *page =3D pfn_to_page(pfn);
> >>         struct folio *folio =3D page_folio(page);
> >>         bool count_increased =3D false;
> >>         int ret, rc;
> >>
> >>         if (!folio_test_hugetlb(folio)) {
> >>                 ret =3D MF_HUGETLB_NON_HUGEPAGE;
> >>                 goto out;
> >>         } else if (flags & MF_COUNT_INCREASED) {
> >>                 ret =3D MF_HUGETLB_IN_USED;
> >>                 count_increased =3D true;
> >>         } else if (folio_test_hugetlb_freed(folio)) {
> >>                 ret =3D MF_HUGETLB_FREED;
> >>         } else if (folio_test_hugetlb_migratable(folio)) {
> >>
> >>                    ^^^^*Since hugetlb_migratable is cleared for the is=
olated hugetlb folio*
> >>
> >>                 if (folio_try_get(folio)) {
> >>                         ret =3D MF_HUGETLB_IN_USED;
> >>                         count_increased =3D true;
> >>                 } else {
> >>                         ret =3D MF_HUGETLB_FREED;
> >>                 }
> >>         } else {
> >>
> >>                   ^^^^*Code will reach here without extra refcnt incre=
ased*
> >>
> >>                 ret =3D MF_HUGETLB_RETRY;
> >>                 if (!(flags & MF_NO_RETRY))
> >>                         goto out;
> >>         }
> >>
> >>         *Code will reach here after retry*
> >
> > You are right, thanks for pointing that out. Let me think about more
> > how to handle this.

I was struggling to find a good fix, as I really don't want to memoize
into the folio that if memory_failure has elevated a refcount.

> >
> >>         rc =3D hugetlb_update_hwpoison(folio, page);
> >>         if (rc >=3D MF_HUGETLB_FOLIO_PRE_POISONED) {
> >>                 ret =3D rc;
> >>                 goto out;
> >>         }
> >>
> >> So hugetlb_update_hwpoison() will be called even for folio under isola=
tion
> >> without folio_try_get(). Or am I miss something?
> >
> > Just a random question: if MF never increments a hugepage's refcount,
>
> MF will hold hugetlb folio's refcount unless it's freed or isolated.

A random thought. For an isolated hugetlb folio, if it becomes
hwpoison (after __get_huge_page_for_hwpoison() failed with retries),
and then `folio_putback_hugetlb()` is called, should we block setting
migratable and putting it back to hugepage_activelist? IWO, make it
forever isolated and just decrement refcount:

 void folio_putback_hugetlb(struct folio *folio)
 {
        spin_lock_irq(&hugetlb_lock);
-       folio_set_hugetlb_migratable(folio);
-       list_move_tail(&folio->lru,
&(folio_hstate(folio))->hugepage_activelist);
+       if (!folio_test_hwpoison(folio)) {
+               folio_set_hugetlb_migratable(folio);
+               list_move_tail(&folio->lru,
&(folio_hstate(folio))->hugepage_activelist);
+       }
        spin_unlock_irq(&hugetlb_lock);
        folio_put(folio);

(Maybe the event "become hwpoison =3D> folio_putback_hugetlb()" can never h=
appen?)

If so, as a side effect, I can use folio_putback_hugetlb() to
decrement the refcount even if we are uncertain that the residue
refcount is whether from memory_failure or folio_isolate_hugetlb().

>
> > what does the folio_put() in me_huge_page() (when mapping =3D null) do?
> > Is it dropping for something other than MF?
>
> For isolated hugetlb folio, MF_HUGETLB_RETRY will be returned and code wo=
n't reach here.
> Thanks.
> .

