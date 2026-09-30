Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F14BCCA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 10:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9C36B008A; Wed, 30 Sep 2026 06:27:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5AFD6B008C; Wed, 30 Sep 2026 06:27:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22716B0093; Wed, 30 Sep 2026 06:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 877756B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:27:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0269F1C3782
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:27:27 +0000 (UTC)
X-FDA: 85270051776.12.46D5C0D
Received: from mail-qk2-f40.google.com (mail-qk2-f40.google.com [74.125.230.232])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0A60F16000A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:27:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q3VvY0h8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.232 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790764046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1bhyfk1ADE8+nR+UpUvKzTDyETELacsIgwqRNvLeG9o=;
	b=duCRRt14k9VOpVP+uaaWUgbRltY2rz7WErXdimZl+BgzsdnI4CNwAG6fCmvApMwLKSbj09
	UdgEP9OTWpxu6nOGDsXUPVD0pbLhkYRCqvWDmWOsa/rvhB7XSXKY9in0oDdhkONYH8wYzY
	JTz8tcbYEQgz7g5fkL0E55OTj4JPOcM=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q3VvY0h8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.232 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790764046;
	b=MgFFOVEHVZxU/QKOzMyxyp2Opca5EsMXQAsThXzDQ9P7IQIPnfDb5x8u4M+bTCn52p9qUV
	8sGYNS0YFmkk4qXQGfo45i4aTPW4ZRlGahOcqg2OQrEmTkirK6cWqJuVxyLgsEAsuNQIBo
	nc+y4hxEbmoALTe6o+1tnlNp4epX0qM=
Received: by mail-qk2-f40.google.com with SMTP id d75a77b69052e-5332b967eb4so38130971cf.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:27:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790764045; cv=none;
        d=google.com; s=arc-20260327;
        b=qw++GmGQWWQOllH+1e2kS2QyrCw0dQcqiHzHkwtKZE1BtEKt4SPaw12yhcU9Tzurdm
         yUWkH6u+4LZCoVEmnZtUP+KMNM6V4RTH38YKm50M074lOm+sOqLvdQwNeUMr7j6t5DP8
         tKmbYrGxELq2lA6aXS4HSVYy2M4je1mEVyaS5JU/bM0cUAXrHhxfWXjuSA+itxqpn1fZ
         pmgx5S5mLvqKTZNenDwuaT2CPYXplxM7KQwtLUNrVSJBVzsXhkRT7XnOCy/aCpl5hKFD
         bcOh7v5DcEf5EOfsSIBhZfUrFXFrtV7nqkRPBUYG6ioskovk1qP1iHW5Y/23lL8JS3XS
         Tybg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1bhyfk1ADE8+nR+UpUvKzTDyETELacsIgwqRNvLeG9o=;
        fh=eU+7J5zG8KhObk4oF9LN/8Qmen8uqEbod2Z/REFoRCM=;
        b=LLJVNy/InhRXP4C6M1C/UesvPxDO6FKKPTcd7Ypqv4ljnlj3vwVUHTotbPvBL1jxdP
         4epvFXpxRixo2KxkK0EswDcCmAUx3GHM1D7gmyokTLAXV42NsqZPmU/c5cjyc23XKj7g
         TBuPE6l6BgpPH7V+W/dYGcUA+Jt7aAbLOwypNJi2Jf74KiJiKh/2VAhBvRA3UxNcTzHh
         mH49b+r8yNKTc55ilX8d+GsCoXl0MRxMdJBrJgxGFdb14mzQeiH2gKXc4jzc5cHe9pHJ
         OJn/sAU8DsW4Bh0VMMhwnngx9BK7vmQF1C3IJJ/NhmXSwTkcgMIuM80LWSkbH3xp102/
         Uq6w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790764045; x=1791368845; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1bhyfk1ADE8+nR+UpUvKzTDyETELacsIgwqRNvLeG9o=;
        b=q3VvY0h8CQ6N7f655q5c69eBpME6vHbFvRozGH+n/0s7s531iMYZrlQIfbg96VkOKo
         qnflzsuapDAs1nvSOmqugMemw6D/Zow4RgNVIoOD2gf045laOARuFTpYKmCaX/JaAutD
         DNAzxnFRj8Lsj5UKEPXRbKdGIi6xoHImLA0W9wg0VGSIl1yktOYUDM+ouy3Yjm2iS5dD
         wsaZtv6OOQyPFQpCniM7GJ1yxPwUH3ClcVBP6hcM3gcNxWa5QgfeG+lKx1EKdoOCdXhN
         YDesBtWIGlR+iiVydwAwlqpbvfJnOH+Woh3HxreHqaZjQy+lc1qyR9Fu3yaw+rn58XW7
         8E9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790764045; x=1791368845;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1bhyfk1ADE8+nR+UpUvKzTDyETELacsIgwqRNvLeG9o=;
        b=hjMGvDI1YZObdmxfrWZWF1tP9Gn553ze8oRQ92Z+8zNtDFwvf018dWEv5EZsemYZ/K
         V6p+CWE6sSFMC5Qx9TsqeC50Z1QfJtYZJtuQJpVtm+imzVYLv4eHMqa8+ouiLyshbCMf
         CXKD+Lr+eXm+1lgo82+MQnmEwuMk5rIIW5mMDJHYzrQHdurI1Bf+teWbhXr6oBaXFQvU
         Z3YxwYUv+59d7FpZ/UG8EiE1Pr3gdmCDxhwIIgsHeZ7vvj6ygRRqTnev8HM0OPaNxtPA
         McZ5uIzwjDX+9Hqi9MEF5y/yxd0zqPddGgfJyaIAasvNnq24yuQIpEVGuCUQuBjDMTfB
         HbXA==
X-Forwarded-Encrypted: i=1; AKwUvBwogcvIc9qqKy+nvweKQYq/uX780FGpt+FPhXiS0rzbHBOixjic8xAvVY2QcBquXSIyh65eYaQuWg==@kvack.org
X-Gm-Message-State: AFuF++mSEKt047Hrd9eyU2Wnc2p7wA8ODS4cMGJui0GZYqj5g7aqvkLS
	22opT9rqlSZqb/OQI0V2wnyn+LgYRZUpUYnaWErY7JISAm9c7aR8u9X/oOS3ktIkHACUV//AM8t
	Xby3QHZ92j6QpbANGHC6xIj12z91UWsk=
X-Gm-Gg: AYBFou3HgNhfs12ul7/nJ1Nc7v24oFTgnMZQsJrqSzW2wXv/kY6+684GlTSQNSfxqsf
	5qxVfUX1okoBJvpd+jYbJ/eOjAXVTNrA73KwJqTSmECMKG/Ldopf2LVXRxbgKw+hJ87Zve/uplB
	XSegHjH3kpbdxR53D/J5rvnLSV8R4VzkAm1NDwOqRxJhVrdIMiiTyOxGVK2GVaL0ntzV3r7pCox
	BpYrmdTM4V6XHUEAsVVql17LT/bh93aXLHXR87/H+taexNTIitAN+S8Syqx7gCVpB8g/IbKfU/g
	XQeSYqrhjVsqZqUlDDY0Ssy/kJWrxeKY58HvDKFuPyNXZtjSuAjprTg7Y0GznJ1h8/JKk+O3ukQ
	czKMMDF1emcxzmAD03dNavAO/0paXf/T+rjUcTw==
X-Received: by 2002:a05:622a:2593:b0:533:2ed5:3191 with SMTP id
 d75a77b69052e-53374d2ed19mr14887221cf.34.1790764045045; Wed, 30 Sep 2026
 03:27:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAAE3jtcL_CZJdcattCwe0RraKnHcZO=UknxEUQVG858ouZCUQA@mail.gmail.com>
 <7ebe4591-2306-4b5c-b83e-6a2e34b52bd8@kernel.org> <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
 <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org> <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
 <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org> <art8EKRKMdwSDCkr@gremlin>
In-Reply-To: <art8EKRKMdwSDCkr@gremlin>
From: =?UTF-8?B?5aSp54u8?= <rockeet@gmail.com>
Date: Wed, 30 Sep 2026 18:27:14 +0800
X-Gm-Features: AclHuK-4Kbsa_X5iz4H6jHTRUMy1VIoQyPoWQlC8GcQsmw033rYSNdAy64prik0
Message-ID: <CAAE3jtftxMkCfWJ77W-xvV2x7jdAN8C8kyofYC3fEivM-Cq6UQ@mail.gmail.com>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file mappings
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0A60F16000A
X-Stat-Signature: htikxxzzf1wc1muto9c4w8wkiu6k4i4j
X-HE-Tag: 1790764045-932435
X-HE-Meta: U2FsdGVkX1/2bnv65vx10ceYxdugdT+bGzINYawZSXvrpodGco6mcqK73GGU2BiSsgWaRPx5/h0Sa3t30Z6KA+fzKvVp9apFdcKk7pU1fZlXTbLnPKJh4ONbo/FYhZTHYinPmHxw2ZP4IBmU8+3xOSfcCyyzimKGmjozBFAn5cNaSFKbVNd9dIko8YWtpsxUM22CoChHP29EAJbVJKYFWdKqDrafT6GkwnuH+zbK8G788oIeUaFAyO+rVQ9PO99HBJ0/F3Ti3hT3AFXIui9ig1V/XKYwb5/OGkZeOZpVExLXzFu/3MnZxjbd+ASxc40j8/GxqyabHKS50+hsB7mTp9Ay9QsXgTDzEUdlVoDtLFyNT91l2vJt2AMtUy2UNFICR7pL77Mm3pik21mi4tFjDu77NLbv9yMrgwbaVeIJhV05OfvAgEQV2643AACrLFGhBrzqdIJMxvEIEjZmZIPiYM2RWTmWN7h6l/h9tWeCRkWQwp3E7WUsquLwHOqgTw/47iu7dYazLZxzCHN2PBpU4HML1D06blD2dv+WtNzRpFv+tHr+qlqnuelPLyJib4Hh+MSegf0t12Mai6kud+7SbU5MxTotQnnwYGVVJjgTTlIyyCXwdOR1ql3WdxnEU1TgKuU4SGH0FMj/jWCPR54EJY+W6X+J3UF6Rr/R5Sv9JLC21UZ3bl99ZNxSS3uCIm06+tVT6RObjiNR9MAKFiKLDiw0dvJo+9m1d/5YRI/tpdzLqBM+brsgBBRItJZ1KPb8AZ94iuS7aD2aeJif5IfFUqgKJ6UWnJIkwUPxi2Au0jqEm1e1SC1OTolS7iVlB2u8wMSvH1xxbKETyUMqWtLymz0do3LAHcDoZo9BHqVEQCULseURjr9+KDER9hOzSX7um/8AIce+j5xkd7rtb68kwiXZkhqtBNbEDzFuaCUIEDzDuvJnvUo8vvIX9Cya/Co9+6OcRajOegIN/lAmbvx
 VVkHbsTB
 uOYREBoeQYA307RXMl9s1s8AuwX+gD41V0lV3XAahS2fhdAcKQXkuqXNxls0+MXYePo/o9h1rPwGP4jPnnBBCvI/qDSau1xB8gccnW1JbwXRrn8JsONmeexVCrrL+KiBMbFm3WoZpPktTIHm+5fWL4TSYtU+waHmZgu24x2qU68+suaQMded5g0/p5d8ycyfL0arD/OLE+muT/P9xap6mg5ZYeQjoMXqsxjKGEyoMIyR/XdC02+WXTX4Uuzq3ZQwPGlJyaAlpnfuc1EgkreG46pBf4UoXAmcuohI6ltzDB66/dYprpQeLUN+hiiiJoU4snfBZtwPA9nj8D1rb04tqViVPfM+uygFGYnWArERTlAuM4vBCD+CZ3+jMtwr5ht9o/mqBwOTc67C+4A8wwmPYrtdVSGCtP8X98+fNjIxwFb7oQQLMssIZwOkZNlGh2ISpglka
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David, Lorenzo,

> You really need an actual file on disk. Shared memory / shmem / memfd is
> not sufficient?

Yes, an ordinary disk-backed file is the intended output, and subsequent
consumers access it through mmap.

Shared memory can preserve state across a process crash if the shared
object remains alive. However, using shmem/memfd would introduce a separate
staging and transfer step to put the data into the final file. Building
directly in a file-backed MAP_SHARED mapping lets us preserve the latest
userspace writes across process crashes and retain the same file-cache
pages for subsequent consumers.

> I also assume MAP_PRIVATE mapping the file so it's anon CoW'd is not
> sufficient either?

Correct. With MAP_PRIVATE, modifications remain private and are not carried
through to the underlying file. If the constructing process crashes before
transferring those modifications to the file, another process reopening the
file cannot access them. That would lose the process-crash survival
property we obtain from MAP_SHARED.

> It'd be problematic to effectively corrupt the page cache by saying "hey
> this is dirty but just clear dirty state and pretend this is what the
> disk has".

To clarify, the proposal does not involve clearing dirty state or
pretending that memory and disk contents match. The pages would remain
dirty and continue to count toward the existing dirty-page limits.

The requested hint only expresses that the application expects to modify
the data again soon and would prefer background writeback to happen later.

> Delaying writeback could interfere with the writeback balancing logic.

I understand that concern. The hint should not exempt the application from
dirty-page limits or throttling. If writeback is needed for balancing,
memory pressure, or explicit synchronization, the kernel should override
the hint.

The intended benefit is to avoid writing intermediate versions when the
kernel has room to defer that work. There is no requirement to prevent
writeback until construction finishes.

madvise is not the only option, deferring writeback for the entire file
would also be acceptable.

Could such an advisory preference be accommodated within the existing
writeback balancing policy while retaining its limits and fairness?

Thanks,
Peng

Lorenzo Stoakes (ARM) <ljs@kernel.org> =E4=BA=8E2026=E5=B9=B49=E6=9C=8829=
=E6=97=A5=E5=91=A8=E4=BA=8C 16:59=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Sep 29, 2026 at 08:59:57AM +0200, David Hildenbrand (Arm) wrote:
> > On 9/29/26 06:06, =E5=A4=A9=E7=8B=BC wrote:
> > > Hi David,
> > >
> >
> > Hi,
> >
> > >> What is supposed to happen if the process crashes when updating the
> > >> MAP_SHARED region halfway through?
> > >
> > > The data structure survives an interrupted update through its
> > > application-level copy-on-write and lock-free concurrency design. A
> > > file-backed MAP_SHARED mapping preserves the latest userspace writes =
after
> > > the process dies, even if they have not yet reached disk, provided th=
e
> > > kernel remains running.
> > >
> > > This does not depend on preventing writeback. Deferring writeback is =
purely
> > > a performance optimization, not a correctness requirement.
> > >
> > >> It would be helpful if the use case + data structure would be explai=
ned
> > >> in a bit more detail.
> > >
> > > The data structure originally used uint32_t offsets instead of pointe=
rs to
> > > reduce pointer overhead. On that basis, we implemented lock-free conc=
urrent
> > > reads and writes, obtaining crash safety for free at the same time. W=
e use
> > > a file-backed MAP_SHARED mapping to turn that capability into an actu=
al
> > > feature that survives process crashes.
> >
> > Ok, thanks. Just be sure: you really need an actual file on disk. Share=
d memory
> > / shmem / memfd is not sufficient?
> >
>
> I also assume MAP_PRIVATE mapping the file so it's anon CoW'd is not suff=
icient
> either?
>
> > >> What exactly is the problem with writeback here? Unnecessary I/O? Is
> > >> writeback the problem or actual reclaim after writeback?
> > >
> > > Unnecessary I/O. Reclaim after writeback is not the problem I am tryi=
ng to
> > > address.
> >
> > Ok.
>
> I mean if you're mmap'ing it you're literally mapping the page cache foli=
o and
> dirtying that folio.
>
> So the kernel really does have to do writeback and it might be quite prob=
lematic
> trying to prevent the writeback algorithm from doing its work on a specif=
ic
> range.
>
> I think the shape of a viable solution really is either MAP_PRIVATE-mappi=
ng it
> or using some anon shmem/memfd as David suggests.
>
> I think it'd be problematic to effectively corrupt the page cache by sayi=
ng 'hey
> this is dirty but just clear dirty state and pretend this is what the dis=
k has'
> or something.
>
>
> >
> > >
> > > During construction, background writeback can write intermediate cont=
ents
> > > that the application will soon overwrite. Those repeated writes waste=
 disk
> > > bandwidth. Delaying writeback would avoid that waste where possible; =
it is
> > > not required for correctness.
> >
> > Understood.
>
> Yeah again delaying writeback could interfere with the writeback balancin=
g logic
> which tries to keep dirty page levels sane and is fair and balanced so pr=
ocesses
> that writeback a lot get delayed in doing so under heavy dirtying.
>
> I think anything like this would interfere with that.
>
> >
> > >
> > >> In a fuse server you can in theory delay the writeback request.
> > >
> > > Thanks for the suggestion. That sounds like a possible way to experim=
ent
> > > with delayed writeback. The feature I am requesting would make this
> > > advisory behavior available to applications using ordinary file-backe=
d
> > > shared mappings.
> > >
> > >> So fadvise would be an option. However, this "defer mode" is really =
odd.
> > >> It sounds more like you would want to have a custom policy there [..=
.]
> > >
> > > madvise is not the only option, deferring writeback for the entire fi=
le
> > > would also be acceptable.
> > >
> > > The application only wants to indicate that it is still modifying the=
 data
> > > and would prefer background writeback to happen later. The kernel wou=
ld
> > > retain control over the actual timing. Memory pressure could override=
 the
> > > hint, and explicit synchronization would keep its normal semantics.
> > >
> > > The hint should also expire automatically when the owning mapping or =
handle
> > > is released, including on process exit.
> >
> > Ok, so while you are updating the large mmap'ed file concurrently, you =
don't
> > want writeback to go crazy, because you know that you will modify the m=
emory
> > immediately anyway.
>
> Yeah see above, I really think the only sensible solution is a MAP_PRIVAT=
E CoW'd
> mapping or memfd etc.
>
> >
> > Let me CC some more people.
>
> Christian and probably Willy also? But I'm not so sure there's anything s=
ensible
> to do here other than something-anon.
>
> >
> >
> > --
> > Cheers,
> >
> > David
>
> --
> Cheers, Lorenzo

