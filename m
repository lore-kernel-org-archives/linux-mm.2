Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4BC606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 21:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=RoCEpjHz
Received: by kanga.kvack.org (Postfix)
	id 532246B0088; Fri, 23 Oct 2026 17:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2856B008C; Fri, 23 Oct 2026 17:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1296B0092; Fri, 23 Oct 2026 17:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12CFE6B0088
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:51:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 264CEA0273
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:51:56 +0000 (UTC)
X-FDA: 85355239032.24.E544649
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by imf09.hostedemail.com (Postfix) with ESMTP id 66DF3140007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:51:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RoCEpjHz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3-NbbagkKCHMkRilejRYlXffXcV.TfdcZelo-ddbmRTb.fiX@flex--tarunsahu.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3-NbbagkKCHMkRilejRYlXffXcV.TfdcZelo-ddbmRTb.fiX@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792792314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=37bgzHVD8y8sAVNI32vtF0/e4Mt+8V5lKNPa4buINEw=;
	b=CBWV/D6AWGIS6hMer6WmaDxvo+/dX4siCuOa5+ctFKzBUdzby+P2ypkY9OhuMf88WEtCN6
	fmG5r38zcYIRDAmDGHZO/PpXm4iay454dnd7T5VT4spjlrvaLiGJUa2ys6SgvCHxLsWSHb
	q334AIoZd6I6/4kOBJ5n7n0L5Nu4Dk4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RoCEpjHz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3-NbbagkKCHMkRilejRYlXffXcV.TfdcZelo-ddbmRTb.fiX@flex--tarunsahu.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3-NbbagkKCHMkRilejRYlXffXcV.TfdcZelo-ddbmRTb.fiX@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792792314;
	b=d3zn/VGuJpW6FdBUe04S6r2zdP8zhSZ8kt8X+MquHH/smMOCmWwDC94KOl5AV7Iuqbz4uJ
	vJepSao/DPF7F6HfEGhEjN/PEpr7xjK9vdo4/kG0sgw4UOiymWyO9DG+N3a1kmU274k0vL
	DqGbzPStnOBXE5XIJM0VU5ZlddwTNsE=
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6a125f5b317so1429357a12.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792792313; x=1793397113; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=37bgzHVD8y8sAVNI32vtF0/e4Mt+8V5lKNPa4buINEw=;
        b=RoCEpjHzqGTOpFjT6SNRnunMShzg38dpbNmqz3Atq1NMmjweeHMIXDTG6omanoj128
         vUJZ5dCqaTo42H5p0XH44gUGrtltga7b/pTsKo0DpcuaK9qEIjYYVd8QogM9AFvVLEbK
         Cu/MMYP8261Buxs7yQHe9rEuYtiI75Mzpr51KFDFPQsp9JMiVzYm2C+8zz+3Ub4R9AKa
         cPwsrPv3RKlvqt1tDrXgK/5GqaChMI+FfQicRwURTPVWlYRR933DaBCUog7A2oo+DVV6
         4AGW3xmbycYU6dq0rq6VRoSVvuUrQ5H9N7Yti8GYtf6nuJ4cA33U+HMoW1soF3+zekcY
         CxRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792792313; x=1793397113;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=37bgzHVD8y8sAVNI32vtF0/e4Mt+8V5lKNPa4buINEw=;
        b=qJCKZaAuRy/qBDUkYgoYt5pfUHjQk0HYpAXY6z3U6eQ49pn1cvgMQFvb4ZAW310gfX
         p2xZ6RVDRjPzKW76n+7VWTY/C7Ha31jj3EiEEOBMpmXSiymaKr0+oZBqQBWPEH4kGiK+
         jWhfIHxVOTPT1YvVwF5xbMYVaMeei2e5usbir6bRgO5RCwUUbHWToG1QDKJ/Pr8pS9jJ
         Lqe4CBaZGAC765ivVA1XDLdlCPSezdKZafDzoizhvyPDuyGPBl1pQ0PTnYTR/geDUqZl
         7rryfc72TVgWK90UqIQ5kczw3Nbl2hlE+L2HnzaNldJsfRe7IzJw9lGiZnRai3hH+GON
         J8bA==
X-Forwarded-Encrypted: i=1; AKwUvBxcVrU56BBzxJWtGIOHLruqYZ4Z50hqi2oTqsHHuTplyCFDCac7WedgdmiDLkoOUpg4dPjGfvMtXA==@kvack.org
X-Gm-Message-State: AFq9FYK57RmB/BgzJnrpfd3ZZi3CliGOmWjYUuwGVGOjT6biEuw4+RXw
	fUt5VGLSBmElQk2kD6VX2OUH97iNGLj9bW2eVVhxV/sMmx9RImpYSX991pIzuYSeIGH5jlpxUk/
	MA/0B1Z929s3P+gHdBQ==
X-Received: from edve18.prod.google.com ([2002:a05:6402:1492:b0:6b3:c422:923c])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5191:b0:6b1:b97b:744 with SMTP id 4fb4d7f45d1cf-6b442ff3810mr590380a12.32.1792792312470;
 Fri, 23 Oct 2026 14:51:52 -0700 (PDT)
Date: Fri, 23 Oct 2026 21:51:51 +0000
In-Reply-To: <atsQQcUiVhb9KXWZ@kernel.org>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-2-tarunsahu@google.com>
 <CA+CK2bC_wc4LxvHe0TREbBP7esYW3pcMNtkGK-kqvf6MyvOh2g@mail.gmail.com>
 <9huzik2u6hs5.fsf@tarunix.c.googlers.com> <CA+CK2bDyk=F7W3J=q3pKCjsr2wy_PLdgqgu+ywp0F5HL=VoMpA@mail.gmail.com>
 <9huzld7q4zjz.fsf@tarunix.c.googlers.com> <atsQQcUiVhb9KXWZ@kernel.org>
Message-ID: <9huz33twf5l4.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 1/4] liveupdate: Rename handler compatible to name
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Andrew Morton <akpm@linux-foundation.org>, 
	joro@8bytes.org, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, 
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, 
	will@kernel.org, Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	linux-arch@vger.kernel.org, sagis@google.com, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, linux-pci@vger.kernel.org, 
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 66DF3140007
X-Rspam-User: 
X-Stat-Signature: jntwbkqpz8guefwjcoi7ttrr5h7npz5p
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792792314-11582
X-HE-Meta: U2FsdGVkX1/RIUaRALrUwclTCN9cVEvuyFT/Fxt1jD7Dbt59D/g9b+QBxE82JIcZLpx6OV8xkvfkwo+NUauiiR+X2O2F/pYE1K+tfXWZmKDVwTWh7CsYMpoul6EmUSmKyz0IY/NKN55lykwXkiy+ucrr6Um56m0HfDHNA6sPha7NMccIaFwhI7B6witdzcl19inkbWaHgtKnKT/DAI0dxPKExWVdqBSTjfFwWon0bfhmFYO3n3XXOCo5NwCefGRBZbWxXkD0jvKt2iuBTJSjpC4BIfOKHOTJnOFDhU6T7BI8hiNHn47CCCa9sW5YGpTcKzGXqY3faKe1AJ5afow++JIVo6tltXknMGpC+I1X+qH45T5iCj4oqGXooFGfAdJLHgx6BsF2y+lZopD9lOv1a4b3vSpbaIEIR5/5gSZ9J7f+Rt+SrZsiuRnKPLp0XUvvJpPrqkqdvW1bkO0yc7E12jsCCtHqc882M9Fgb6guSCcFG9ba1i0TJhrzvaBMUNRSkY+J2pKvXByJo4hc1C9cUDyhqFLQzP/H8wQHpbSpT5WQi84bnk8yOaOlccSasIZoP+HbYPylhvyqLHBWP1fPviQagvYeVOTUBnC9Ubau4+cLn9dX5u5mK5DtACGVjAzcHKBkhOlNOjVmgSesBKqF96wiLQenKFYYKGE9G/bykboYSAS1FOBGPz8USakRN1LkKGW51DouY8ihwm7/1KWDrOCl4ceQ7rSwVNaVm1l4yRq2cfAWEta9deAdTaA0QrMwoLQ4GKS2jMCnRvwmmrbhRCEueje1HNKzJcGelexB9jc4AbIsRt/FIIfG+vY9LSjm/aNS0ZAG8uC8fXFs6OwEDm4DCNokZLAVazh537lOsr7rbsXFo1fiPrRtSJ596Hycebah2gcRViB1DyVDPBVBnkLyvwVUS1Pz055dxBcceJrrVA88nh9ZxBrSprGG7MBLeCy8sxWK4r0ObDFaoZ7
 17DLqMYP
 QuswPIuIQnfWK3R7eh3zeRFugvxU/bDQyAosbr+IytV3peznm1LVNosLeeKiXEjVZmEzeXeBxyUUufUdCOWT/J8/7ym7ouiZX+JNyPv6Jx15ePmQPeqMhjS5cluQ4jYsI1cq9UQkw6y3PFcMCxxjjyFTxjVaHyQLRy3FmmD+JtGfKWjy5OSzls8+CDOiHggHoC0L9FASgjCPhliInw5TzVJ1MSrfhWEdYnMvurRuMkIz1zkHiO5lF/RKaT3hiVjZnqpKJHjFO1RrCl3E5eI0uZyPdr2DM0vphWKRsPxOjKNc931YbFGEZeDupVJtz2u33khcPwj2IyyoZqaswqj4ijmreaXMdCCdJYdJm71jI+hvh4IzB6LuQMltEHWyyOpzJQDKjvh9MaOKznuLMiZpIKEqbp3OlezFoItgx1J13hG6RepiNZnRn+45yMIzL3E+Yo14ez2BvFiMGfy+3kwe8XJupDD3joFppOWVdlpfMdObgzaaZhmy4lEhUOufaBHtT3bM3RO9JTb6xZR3dJoDZAj6o6Uy7O6eJmWEucGFO02tQxxY7aWeXHTyAJsruWmI3KASPb/HBIaejWvgJSvv5eRBjJq+pKwvDvkoB9SEr31IoEdqC00e8fiUrttPgjWd8MPbatj0Uo0Cj6TnbDD/rvuw1lUtBWY6hbl4O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Mike Rapoport <rppt@kernel.org> writes:

> On Wed, Oct 21, 2026 at 07:35:28PM +0000, tarunsahu@google.com wrote:
>> Pasha Tatashin <pasha.tatashin@soleen.com> writes:
>> > On Wed, Oct 21, 2026 at 2:16=E2=80=AFPM <tarunsahu@google.com> wrote:
>> >> Pasha Tatashin <pasha.tatashin@soleen.com> writes:
>> >>
>> >> > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@goog=
le.com> wrote:
>> >> >>
>> >> >> --- a/include/linux/kho/abi/luo.h
>> >> >> @@ -84,18 +84,16 @@ struct luo_ser {
>> >> >>         u64 flbs_pa;
>> >> >>  } __packed;
>> >> >>
>> >> >> -#define LIVEUPDATE_HNDL_COMPAT_LENGTH  48
>> >> >> -
>> >> >>  /**
>> >> >>   * struct luo_file_ser - Represents the serialized preserves file=
s.
>> >> >> - * @compatible:  File handler compatible string.
>> >> >> + * @name:        File handler name string.
>> >> >
>> >> > We are renaming from cpmaptible to name; I am not sure that is
>> >> > necessary. We can still use compatible for the same purpose as name=
.
>> >> > Unless it really bothers people, but for me 'compatible' works just
>> >> > the same.
>> >>
>> >> Yes it is necessary, For example if we have two handler for a single
>> >> subsystem. We should refer it by handle this or handler that, not lik=
e
>> >> handler with compatible string this and handler with compatible strin=
g
>> >> that.
>> >
>> > I still feel like compatability makes more sense to me. Take an exampl=
e:
>> >
>> > We have two file handlers for memfd (i.e., FH_OLD and FH_NEW): one has
>> > compatibility =3D "memfd", and the other has compatibility =3D
>> > "memfd_next_generation". The user chooses one of them to preserve the
>> > memfd data, and the compatibility string is saved alongside the FD.
>> > When the next kernel scans through the registered file handlers, it
>> > must find exactly one that is compatible with the preserved data.
>>=20
>> I will open this for vote.
>
> I'd rather won't ;-)
>
> "compatible" does not contradict more fine grained bitfields, and still h=
as meaning.
> Just like in FDT world from where we inherited it, it means "these ops ar=
e
> somewhat compatible with that serialized format, will check the details a=
nd
> will know for sure".
>
> And IMO we should keep it.
> =20
> And please, trim your responses. I had to scroll 463 lines to see there's
> nothing there.

Okay.

I will send the v3 soon with feature flags only. Also I will drop this
and its next patch, as It will be part of other compatiblity series with
exporting the schema to userspace so that userspace can make better
decision in selecting the handler (As per the response from the other threa=
d).

~Tarun

>
> --=20
> Sincerely yours,
> Mike.

