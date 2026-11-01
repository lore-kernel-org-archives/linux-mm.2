Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11259606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 03:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=n+Y20mJa
Received: by kanga.kvack.org (Postfix)
	id 240EB6B05B4; Sat, 31 Oct 2026 23:20:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9A06B05B5; Sat, 31 Oct 2026 23:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0928D6B05B6; Sat, 31 Oct 2026 23:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7C0A6B05B4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 23:20:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DC6AA85DD
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 03:20:18 +0000 (UTC)
X-FDA: 85385096916.27.341A26F
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 536621C0004
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 03:20:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=n+Y20mJa;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.53 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793503216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROyck2tv4dX+E4QrQzUDo16ieFP08+/ueNOZlrK/9dI=;
	b=QGk8GikXYn+ISkAwZL/GYroOmft6xfNk3xHhnPbWFdf8ZlKgdM342593g6OwlvkZO2SQqr
	dmUpEgWs0r6/NqGFZm9Msu7kUlwbJZm9ja8UImWCXDXSssxSecCo2J/Mpk8D3YMyfCRKJl
	WSRCEbOKTnmbL+I9CbcH3tRnUaB6W1E=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=n+Y20mJa;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.53 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793503216;
	b=3WB5AOlya9BXvuizb8OX0dSK5MeyAyayBP5g+2vlDaI5khw4J45otq846P24cpju2fn80l
	ge6nxIyhdBUj5xvfJe2G5GAyLJzs3uY27FGOctUQaLyb93kBuQ/KA4kXDQLDo2F7XOFAYm
	AJEGh7aswhgpNkN8nyj61n+3+3jLK58=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5be42ae8eadso1232407e87.3
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:20:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793503214; cv=none;
        d=google.com; s=arc-20260327;
        b=NZmw4PpKeKh00Cl1oWWdTtYBrvvF9SA0L18TsbQpS0Sy5o6URjMBF51gNdqfpUYa5e
         nqSGkkj9xiONC6QGsujcvaRYOXUAEuuy01Cl3wT5uXZGJ3KanRXHeFK4i0j/fmGTeDKL
         PdVbZlBjF0sG7AV0l5+iyvk5KwrIH4BxG9ws977PhoiHJwwJRet8Iw6bqbQ8bbitqzqS
         0ThU6ld9JSlqHPFGNrRp/Nvjlcc/UbMoEt+Jle8oNBefiDhuHc3vGuiXSvzJb632pKYP
         Z65c6lBXtkhRYGSgOkSQIkN9HSe5rEZQEUQZbDOYQJYrnS+rgBZd8DrUvu+0wi0hyngE
         +KMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ROyck2tv4dX+E4QrQzUDo16ieFP08+/ueNOZlrK/9dI=;
        fh=c+VbdyKkfCCQn4/hGz8ScW0yoLXKHl3n0PHbm0IWYUk=;
        b=qhS8T5U2jkGOAz/yoRPBfDW9htz2flMmmDdpbiu1Y2qhaQ7gtjdO0b02nHQ1wGJTqZ
         9yA3emDFDmUe6hKEKzP0+f/6FgSlMQJ/AxY/cQiHL5PU3Td/sRIwlcOJPpBuLGKwIPGu
         AMQX4rzd71GOX14FGmVnVFYP5FZgiFjsx5cjI9ZTPFfTEyX3LztJg3ncp4w4N7+nPeTS
         xoRCN0dOZz5Ql7kLpe1Vw9ScTZHODoOoIKdZYTaMTC6CghulhjHfCShM0ABk9nLODZJv
         a9QJlCIIgzg6HfojvuGKUWUk11rjpbuq+k0YWdW9Ze7fZjaP2T4KDW5qY+h5Ou0RGL9t
         zb1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793503214; x=1794108014; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ROyck2tv4dX+E4QrQzUDo16ieFP08+/ueNOZlrK/9dI=;
        b=n+Y20mJaiScn6hqaKEsDSJj06oPClkettZqfNDmddwg3vGKOWjM3kvl9qeMyA9xMcQ
         FBNo7VIfwcJ7cZpYCMnJ6irkzwvMgzT38ujPODsoRRTHHBCV1ck9+y9r1LjzJ5kdmlp8
         S0d6WVttl+gw10P58lGJdX8YQ6Wkh5jKdiicBiXsqV3cajEprnw+HbuHJQnSaLnp+f3/
         sL1lqoxyjK4zOWVj0LIzipI4pPxNycueJr8Ce/dc1OpZIEQ2wISrHwiMKco3XLnzg7R4
         wZxZLIh/Uxj44NKYqKy/MyvLJmmhwuDwAoLaTuZX3Us9d3AbF7PIlqMTMFXsaVhD4tlX
         uzyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793503214; x=1794108014;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ROyck2tv4dX+E4QrQzUDo16ieFP08+/ueNOZlrK/9dI=;
        b=e348fcm0l2a7LhPDd8IuqphR25ZD9GUMcNwtSChxVOeq6YKUzR2hPyLpYnS7NIiH14
         MsJ1MHZmJyNj0VMke+wcSWMfnsTxqjNJ2CcQBaqEHskIesDtOa2883TVFSF1jmprCCyW
         cfBuZGxKfT/GPjqe+mZYPpKo9pJeLPkxzRGQGY7NlDMcATMWcyom7/KPRMwzu77jJXLL
         IBEGyI0F3dwnNyCtCeyT/v3fcK/f2KDszYoxrtwOb2gjzMSQ6WG+MU9cEyksPaYi5an9
         MVax0Ysss4qS4AyFyI6wEdOUuU4S2E3P3fF4TE50wJJeFO9iBZuE6CLjc1Fx+Dy15ZGw
         q9xg==
X-Forwarded-Encrypted: i=1; AKwUvByUlqrmS5w6ZDpqg0pnD6D4uTr+TdfHZ/5yUgwL6t82d80D1YlPii1ojB1+8NgLVY5A9RglJS5mig==@kvack.org
X-Gm-Message-State: AFq9FYLEvIjsxyOZOdyn3hfVlP2/HqOD1dnE3qAXz5xrYdljAvHjYuVW
	SHFjXllh5TM9cxjpaToZYdYWUV55ox2+rDJst0KIDsjsZZ0UZiXP64wIUgCDAL16/3iTi//dbIZ
	/KnHBlrvtHlfnr+fHSqqPAcFT2qAG+rnXJZHL8jgq
X-Gm-Gg: AYBFou0hBAIGupLJ4jza0/srxKxyn7bQ4uy+Y9xrrvvG8yDtrKy7GQhS4g9uoTUNfYc
	4cwsJqRTVJnSWR7C3uI35VleIzxZXG4S8MFOWXKfN0+srqDpqaAx3fCrJLNu0K07LHxaksPCzVO
	HCN94cjrzQtDnTlMs8plJHiUosIGu1YgmF+RVbDUGAuChgJTNCWHCI7DJXPc4+xZMuOfatMFIfh
	Z/BJgEKU4R1UcKNUl1W+QOiKJKa3gNq/++1TKS9zsgIsocysLw/fHqh5PwqVFZ4z8MNoC7CrY+V
	0GpD481G4YP6jScn4FzfDahgd+TYHNpIlnG8hGwoi710swBB+FDOIrR+Lemy5CIPxyP+/naZ4o7
	ts30WRnWqI17tMvQ2qhAv9ZYgQtcPfpqmTyyEbv0Ij+juca9Yab5TmsE=
X-Received: by 2002:a05:6512:3b0e:b0:5bf:b5a1:390d with SMTP id
 2adb3069b0e04-5bfd9569843mr2136047e87.27.1793503214478; Sat, 31 Oct 2026
 20:20:14 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261031203540.2282507-1-skhawaja@google.com> <20261031194058.d3bd25ed950e5340ab595f07@linux-foundation.org>
In-Reply-To: <20261031194058.d3bd25ed950e5340ab595f07@linux-foundation.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 31 Oct 2026 20:20:03 -0700
X-Gm-Features: AclHuK_zB1iHzMf0lJZAS88jOk23h0UPCqaNcjm28FlTC1Q3GtQOHifFuWxluKo
Message-ID: <CALCETrU76ThzLDbUfpoota5=xcoOS4aZrwgK2B3ELkYcFOjGJQ@mail.gmail.com>
Subject: Re: [PATCH] mm/gup: check folio->mapping under folio lock in memfd_pin_folios()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Hildenbrand <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 536621C0004
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: kdx38kkytg4d8rw97fgzpcohyq1dy7us
X-HE-Tag: 1793503216-571809
X-HE-Meta: U2FsdGVkX1+3wRRGkF2u7K8bPBH9JIwJuLxSky5rKQIugds/qp34R4UV4ez9601RCWmPYs47eCaXOzV+4N+cj9FoYllKfIf6smqUG9/n0ZndTfq8oPb5xwoBREbCUltt7yhNBCqHB4IuNEcB2XfYyYvXLLoB/wTf+NFt34IV6RYXEJJ2dsSXducOEol/vam6vxaKO2iuzs0UIFvSAnS75HQf/ahHAWXJrUkTnHptad+ggByuwgrfQAyoKf6iz/M0ynHlR40q1/eZW0HuVLtscrwZvX+ORUegLjkjId7OQ0keqz9HbIe0W6K92OIwvC7PSH3lJuV3d/9dLpBpq7U09uLJNN/AY+Qgm14v/wdWhvfL2M+J14QnZLfyL+baHckTqpwrIHXwM34LujMSVKIxaHrg4Y10REFcXvF2tYd6itQ1+WhwIU5HqxLyTKzDcZLZQCx2jx4/89LykCZM+uYkTou/vhr8idkCkW3Z34ELOf7LwWcnLEN/l2nb9nBouhKgmb2mpAtsQDSTxpduD84tVdbj1aKDad2AAsIAFsGrd7p3ZKujtRFpRoARIm/GFyS6p0agQ3qHaiIriiYVOIjdKXTSCvgA7fsNRK+gjXk0TIDfvbc9CSXHHaDdva0ZfwBt0I9fcF4X7Bs7VgqEX+xyM1iLYi6abuiRjX6k9rdzBtzf91ULg58HYLbbrr7+R8IvMr0XxDDYhj66hv0hzkMhrfCJkE8Xa55w/5thOhb/etH0ugXs+VSy3Bit6tGfsDBgaEkR1W260rvWewjE85txQiT076AA1qJDuFG4iewktt5BmeSSkkYXM4DKVMqnnMrFrdf81jtuqzQ94z7jWyHGHej85QFodkypauefbY4P95ZSZEMh2ZM2nSJASPAHv1EpagQYcudamGnoIhDZRT6FlVanfvUAOswMLxRYlqI6lnaiq/MaGIhyZzQWOwkUHZVzzfIGFxQQCyvxFfKsQuw
 EUekS1WW
 2+BAKgrDz77BIxxUbWjsRAu+HgRVfTatB0OET5mAztj0A5YsN2hz9XfyfxC5+MWd62a3QaaX2WBbK/MHnT4i2R08OeXH8HUlaOZ381r8BiCZs48v3SG9wrFZeq7G/PVr2uUjKI/0NTevQOL7r/WCM0Ry/6EPkzHqGwQbzyfRVUPH2p/DtG0TYYcvrVw2PmdyoL6AC0rtrYpq8by41Rltzkj06E5szh0Jy1t+n5V1w+Rd79DMI7SuQ32cTtpuqJHRmysvmGZBfJVavebLQL9eqZqcAfMb/Ba7ium8h3DUap6zSmZNddal+FlpOVPbj2bE/arkIJRUAqLeYdw3stTP9oPqO93K4clmtiKy5bmBygJ2g7KK9U/b8+IErN4Cc44vDOvkU4BAR3GBERZdhvD6p6lrPwhthGJhKqq+oFQBxjm2LXRRhA7TMPrggirVb0B/yHwrqmTQ1QkgW6fhhBe6RyYoOMxiuOtjyQ1LEkBm3RUL06VuJ4fhCKybg4ostWi2RPyasPuoats8kHQQJcUMKOuspr5+DB6ncOYDPgHtbKf462xWLtN+8OfGncg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 7:40=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sat, 31 Oct 2026 20:35:40 +0000 Samiullah Khawaja <skhawaja@google.com=
> wrote:
>
> > memfd_pin_folios() pins folios from the page cache without taking the
> > folio lock. So khugepaged or MADV_COLLAPSE can replace the folio after
> > its refcount check while memfd_pin_folios() still pins the old folio,
> > and the caller ends up with a folio that is no longer part of the memfd=
.
> >
> > Lock the folio and recheck folio->mapping before pinning it, like other
> > page cache users do. If the folio was removed, retry the folio lookup
> > from the index that was removed.
>
> Can we please include a clear description of the userspace-visible
> runtime effects of the bug?

It's straight-up data corruption if you manage to trigger it, no?  If
you manage to race a memfd_pin_folios() against collapse,
memfd_pin_folios() will pin the wrong folio.

Fortunately, there are a whopping three callers in the whole tree.
You can hit it from udmabuf or iommufd or memfd LUO.

The former two will direct DMA to the wrong folio.  Fortunately it's
not UAF as the DMA will be directed to a folio that is still pinned,
but it's the wrong one.  DMA reads will read potentially stale data
and DMA writes will overwrite that stale data but not update the live
copy.  (The DMA will not be directed to some other application's
memory, just to a leftover copy of the calling application's memory.)

As far as I know, the effect with LUO would be for stale data to
reappear in the memfd after handover.  With the patchset that started
this whole discussion applied, I think it might result in misdirected
DMA to freed memory (I do not stand by that claim at all), but that
patchset is not applied.

>
> > Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning =
memfd folios")
> > Reported-by: Andy Lutomirski <luto@amacapital.net>
> > Closes: https://lore.kernel.org/all/CALCETrV5eqg6d9=3D+BQhCpRwBNe3aCQiu=
t8vxPBs8b7PToqjaHg@mail.gmail.com/
>
> Includes the words
>
> > The issue is live update doesn't preserve those background punched
> > folios and now we have created an UAF attack on the kernel across
> > kexec if you don't do something about it.
>
> Is that the extent of it, or are there other effects?

I *think* that the UAF can't actually happen in any upstream kernel.

--=20
Andy Lutomirski
AMA Capital Management, LLC

