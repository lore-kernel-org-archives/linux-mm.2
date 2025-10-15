Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21888CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 13:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B27D8E0031; Wed, 15 Oct 2025 09:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7634F8E0020; Wed, 15 Oct 2025 09:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0768E0031; Wed, 15 Oct 2025 09:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 596EA8E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:11:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1452F1383B6
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:11:48 +0000 (UTC)
X-FDA: 84000385896.08.AEA8AC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 45B2414000E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:11:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bj3kAtTv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760533906; a=rsa-sha256;
	cv=none;
	b=0wwFXYL3eGV1Hg9ZU1nCEWbo/jWxJbyBk6AnhP0VtUIIW4znGT0YKQeB8Grxc0F2ELkPLQ
	X/WP6+RPUcJFD6tGmneFU0hwMlKP25GXcBtakWUdiiWGzPg7RfQxn0gDA8EUjbjfGrQoAm
	zQtQ1ZtNhrFIvF9tVOrm1m9Zju40npw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bj3kAtTv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760533906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXbauMlt4Pxz/MefjAuBjtTmdLctrXtespYiKt1VVhM=;
	b=5U+PkjgcBMbtNkR8QCXm9I7dfRTuCEKVVTJEb5DYRFaTE+GLR+s+9XxzLMixTlIA66CwGv
	bozNA2mWeAWYjPzn7z8WtUPS4E3vsG3Bi5APM/hQ6ih3Y0ziDSkC+ljPLM2GZdnEmfhLgm
	5SNJnCODL+N9/WsSSpGIhAQHfZV5Byc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29DC644942;
	Wed, 15 Oct 2025 13:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D96DC4CEF8;
	Wed, 15 Oct 2025 13:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760533905;
	bh=omexcsvQOP6L3u6VXqhGkYJUOCWIegna1Gz630OIFyA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bj3kAtTvuMH0wrdZEdcvWcUEePwq0ISRRyCNWlhSpLuB6WQVpbV0vTd0PuT52xlAS
	 w7KFR5RXN7/WBOhy+YS726di7J4JaoI0d4fan+f4IiCJjqlVJlAD6MHu/578kiA4xV
	 A7MpgIXtEEOQ9yi9IE0weQsmeyVwMca2PpXfMUgC5LiwVYlWewTC95p0Ly4cPNO73I
	 ee2bIlA/rLBudcBVPP1aqtm+RtpYrRb21GqaDgDvR67Eavpg7HBO7oE3YZV4ydK+kr
	 qXsz8moSzdIAmz4widHWgoPA0mJBioHsEaAlz0wePPBt+CHyNvMboHoe7gy/H8nOV8
	 I60zSTotKp7SQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  akpm@linux-foundation.org,
  brauner@kernel.org,  corbet@lwn.net,  graf@amazon.com,  jgg@ziepe.ca,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  masahiroy@kernel.org,  ojeda@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org,
  jasonmiu@google.com,  dmatlack@google.com,  skhawaja@google.com
Subject: Re: [PATCH 1/2] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
In-Reply-To: <CA+CK2bD4z_j_jMhMtrvvQ5nOMEFT6yrRHk9rk7BEiQPSPCHiqA@mail.gmail.com>
	(Pasha Tatashin's message of "Wed, 15 Oct 2025 08:40:26 -0400")
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
	<20251015053121.3978358-2-pasha.tatashin@soleen.com>
	<mafs0zf9sjrgc.fsf@kernel.org>
	<CA+CK2bD4z_j_jMhMtrvvQ5nOMEFT6yrRHk9rk7BEiQPSPCHiqA@mail.gmail.com>
Date: Wed, 15 Oct 2025 15:11:41 +0200
Message-ID: <mafs0qzv4jomq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: yeyj87pnz8owp81cq7rec1k3qis9bdug
X-Rspamd-Queue-Id: 45B2414000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760533906-311409
X-HE-Meta: U2FsdGVkX1+zqwi8JaRWeJma1UT0crG2fHr3jcUiUtQtmKBHFA6elDkW7yqIEAuNkpXuzarwWmCCbl4IHcIKzFVHQOxdZXJWCW1j0UGb7ENXCe2vXAbl6dIDmljbujygrU9AYsHzXBAeKVT9MGRKupIPKLiHHgRMxX2Jf4WPtgOPSVv6Q9lrqX0Y9KyVh+99ea3wRsbRgNbU0lGxvg9H9DO6j2BB/8fMLEW0O2eJRY525u4bmIpFeDsyk0/43D1dNm4OUcTIZEeYKszYbr76motdee4DLoeUOhKewyMDqKs+9AbgMrneCGjTvN0vWquP1fVgOvc3pHB8qvWAUsJTRKrp87kjwmbAkO0cwRXfEAl652BoRYK/4fkSYIK01mnthFt0WMhbvm+mjGIKSsvTnfwdHjIC3lC+mHk2Q/aS7vnLuz3r6pNszMP864PnEX/iec/cLd3eHq/VdJi6RPj3voicdE4sX+W6fU89syZYvDLyNPcPQ9z8VaqSk7dZX+Z51pgMb7G9RoFEVYcgePigkiotUwwIS9KSbo1me2Nm5mAy3oeuwOKzJHDJEp9HWb3XYo4ttIDrpTgI7z0NbErx9ID2V8D5Ipx94u20dWr3xXHuABBkGlAFT0bkfaUrkDzX12KrbjnSs61U2z2aOv1uW+TmcppSNgA/v6D3AAXy3Bmu2vfZn30RKN/z954By1qpMeoawOTJi1T3wr3tooB91vjcB8deYQGXyR90KCKIPA5WDPcNmbKzEa2toh29Hif+rgpQYyHDxMX4of0zFeqZOXW5QR7R7A4V1VWrAp9vFESrLcpg7+FS6i/BfoNTS40umO/4Dmsm4MWWqOEgfrPWIdAiOtRkLUj2gGQcLT7oxQjIA//yzbIrPRGnD8nxxosxMbMkIsOdKxtku/PXhIijuJyYzp11eIAp40bQah4wIkVEJFzFR9RmvGwBJtCMq/saSODfhjL9uf9QfGQ4Rsu
 pCM5sh6d
 it50FVSo+02VfseaM0sdsLjk4UMNc21jhep7CilwpMg0mHEFSZkMztniRHVcs7Vc2gehGsgBFnz+pa+T5l3WMwvi+P7mgh8iUVPu5STRCneO+O2tkgnlVgidpxx0RoX7o7DSKlhnOUGEMg2idsxOWSBxA4pvEfb3FeYcOcV17g25EMQHLYkFHD9TxYADgnJb4Uvw8YGDNzrwXBkq2i17SlVixtMfNgiiZYc5Iw+zGo8wFSSR1ZUf4cYwG7W3DtBITSc21OKojCsBPNZMMvGInZ6P9Z/H6wMnHaGf3olu3tsWomXTaG5cmw7xdDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15 2025, Pasha Tatashin wrote:

> On Wed, Oct 15, 2025 at 8:10=E2=80=AFAM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
>>
>> On Wed, Oct 15 2025, Pasha Tatashin wrote:
>>
>> > It is invalid for KHO metadata or preserved memory regions to be locat=
ed
>> > within the KHO scratch area, as this area is overwritten when the next
>> > kernel is loaded, and used early in boot by the next kernel. This can
>> > lead to memory corruption.
>> >
>> > Adds checks to kho_preserve_* and KHO's internal metadata allocators
>> > (xa_load_or_alloc, new_chunk) to verify that the physical address of t=
he
>> > memory does not overlap with any defined scratch region. If an overlap
>> > is detected, the operation will fail and a WARN_ON is triggered. To
>> > avoid performance overhead in production kernels, these checks are
>> > enabled only when CONFIG_KEXEC_HANDOVER_DEBUG is selected.
>> >
>> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> > ---
>> >  kernel/liveupdate/Kconfig                   | 15 ++++++++++
>> >  kernel/liveupdate/kexec_handover.c          | 32 ++++++++++++++++++---
>> >  kernel/liveupdate/kexec_handover_debug.c    | 18 ++++++++++++
>> >  kernel/liveupdate/kexec_handover_internal.h |  9 ++++++
>> >  4 files changed, 70 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
>> > index 522b9f74d605..d119f4f3f4b1 100644
>> > --- a/kernel/liveupdate/Kconfig
>> > +++ b/kernel/liveupdate/Kconfig
>> > @@ -27,4 +27,19 @@ config KEXEC_HANDOVER_DEBUGFS
>> >         Also, enables inspecting the KHO fdt trees with the debugfs bi=
nary
>> >         blobs.
>> >
>> > +config KEXEC_HANDOVER_DEBUG
>> > +     bool "Enable Kexec Handover debug checks"
>> > +     depends on KEXEC_HANDOVER_DEBUGFS
>>
>> Why the dependency on debugfs? Why can't the debug checks be enabled
>> independently?
>
> Because there is one kexec_handover_debug.c file, that I thought would
> make sense to use for both, but now thinking about this, perhaps we
> should split the code: KEXEC_HANDOVER_DEBUGFS and
> KEXEC_HANDOVER_DEBUG, and add two files:
> kexec_handover_debugfs.c and kexec_handover_debug.c, this would avoid
> ifdefs in .c.

Sounds good.

>
>>
>> > +     help
>> > +       This option enables extra sanity checks for the Kexec Handover
>> > +       subsystem.
>> > +
>> > +       These checks verify that neither preserved memory regions nor =
KHO's
>> > +       internal metadata are allocated from within a KHO scratch area.
>> > +       An overlap can lead to memory corruption during a subsequent k=
exec
>> > +       operation.
>>
>> I don't think the checks that are done should be listed here since as
>> soon as another check is added this list will become out of date.
>
> I thought it could be expanded when new features are added, but I can
> remove this description.

Yes, but it is easy to forget to do so.

>
>>
>> > +
>> > +       If an overlap is detected, the kernel will print a warning and=
 the
>> > +       offending operation will fail. This should only be enabled for
>>
>> This also describes the behaviour of the checks, which might change
>> later. Maybe for some checks the operation won't fail? I suppose just
>> leave it at "the kernel will print a warning"?
>
> If it changes, and Kconfig should be updated as well.
>
>>
>> > +       debugging purposes due to runtime overhead.
>> >  endmenu
[...]

--=20
Regards,
Pratyush Yadav

