Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A6CAC44501
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 02:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D306B0096; Wed, 15 Jul 2026 22:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12EC96B0098; Wed, 15 Jul 2026 22:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020366B0099; Wed, 15 Jul 2026 22:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9AEC6B0096
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:34:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49DD91403A8
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:34:59 +0000 (UTC)
X-FDA: 84993072318.09.F17D77D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 90B531A0003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:34:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUeHue2T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784169297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AplusJcTTIVCbe9CwBy+/wj8nodbLNnKMROAKeKy5HA=;
	b=LrQM+Q6h+3exqkP9rbiJ/u8l+wyPjj9f18sG764D0FmrQUd//kZ/ZVBIZf2A+YAEdfYCUE
	DNuKrDJx4pE9l9AB2eMEOyMUCmYWRlj3vBV/XFrvzgIdcJRKtgMlUQoVQiKnv+NI0Lrjez
	qCXCQcXbd2MroX89TBZLpGeteDiHqSI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUeHue2T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784169297;
	b=hAWCQZ1jPcl3/zRGBOv/k7BKMy7zzhCNUTUIus71RRvENcGNYhOMsPNCnYYfsaIVSz9AN3
	wGsSQPlmXVPHNR3dcLv3yIS5HSaka5kjckWGCUulteoKIBl0O/yPUPMIwWlY5EWyhmKHYu
	2CKASgD2tbF7eYsIWSNYiWOwjtKCBYo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D8ED402DB;
	Thu, 16 Jul 2026 02:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425301F000E9;
	Thu, 16 Jul 2026 02:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784169296;
	bh=AplusJcTTIVCbe9CwBy+/wj8nodbLNnKMROAKeKy5HA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LUeHue2TdDv8VmLTTI4CmXrR4tw7d1yV0CCDTQ1YH/nnkTBxIVCnHwMyVpG+OjkLA
	 qsVzAQ3Rd0EmQTeZFkC8qqySTrgniv3ArGNtzk5yUB2FlTRShycyeQ3iwhHocnU/Am
	 v3LdU3ypT0a/DtvhjyDQ+KeZJYHfdxJOLcazRd9FYHw9Qkh4iRUcFaaxIU3pPwR6CY
	 HlrPQYK5Jd34WuG1WueooMPV4pxV1wY4HewRrmalRbaOQBoU54vlBKFU+sjJ/1+IfC
	 V0bugSAltncCFUO4mScPCT3WDCyfzifjPgpLTWVzE9S7SGsdYbRAzdiAu8+G0H0Zjq
	 y5Ffum7bJc+Iw==
Message-ID: <3dee7d67-c8e8-49e1-83f9-54aeeb699442@kernel.org>
Date: Thu, 16 Jul 2026 11:34:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes v3 3/4] lib/alloc_tag: introduce
 mem_alloc_profiling_permanently_disabled()
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <20260713-kmalloc-no-objext-v3-3-47c7bd138de7@kernel.org>
 <CAJuCfpG=Dk6PRWy-8wR4j0UreSsa=fdiFWvBYpOkSZE0zV2Z4A@mail.gmail.com>
 <fcee1dbe-1109-44c8-a3dc-8aebc5569c73@kernel.org>
 <34af7126-0a19-4da7-a3dc-4e6e0ae01ca7@kernel.org>
 <CAJuCfpHYbTobe04+Mm_CRMv2SkUuT_9j8T7ByEyv=cJU+YZZCg@mail.gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <CAJuCfpHYbTobe04+Mm_CRMv2SkUuT_9j8T7ByEyv=cJU+YZZCg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lOxC8w6OqcKZOEPosUCaHYgt"
X-Rspamd-Queue-Id: 90B531A0003
X-Stat-Signature: x79p1gz4tts3inn93jb4eg1hbw5shern
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784169297-773337
X-HE-Meta: U2FsdGVkX1/sJQP+le3ko+M8qTpQpBcEfy980QMibW3DplDPe15EKH/qx6PIu9737f/UfBvrsEgSnQ+/8LfevJEXoW9SYCUkzZZjYPBM+VxYvzWSyCGaLmXLD7SqGXIZjXvaDQBjb2oiIvs/S6mKmo55h+Fbjn+Q048XSE1Fs+at7JRlIJ4+8nXytMUemcJCOhUEu3ejobHwRN1REMIYx1wjihpE6YSI3iBQqrT0dkBXrGTnQq000CQzPb2KtI4DPJiKEFFtvQReT+EeaNOVBP4M1dqKceqrkL6wDSgxzFV+LAG+5sEOmgco+vYlwC9poZPB8l+P0FRXWtNsuKMDoXIfl1QDiqiG10VxEyTfY25AntapwyyBrM1dDx5q/UY80qsClC9kw2e1SazPITcupSjJ+nXs1rHTHbUnhAa6bdDAHjFzeVV1t3FYyyL/CQTSqYzHRZjDKabtmTrWbPynJ7Pnm+fMiSHGTs7ciqsnt6h69noomMm0eSAzhRKetdbrsiGZ5dlUHP48jNppf3Uemz2eFCgLxs3n7le8lw2NCTi3rlahn198YChfcfDv+arlKiCqUpsm3wwLECL28TpKplipEpYkWv+2vyGjYwzzc2ipKnv2llLVM3HEW9t/VBJ46YznANyYgrq7xNeHFZajoKoSVr5HXnZw2/ZVVs+gtn4mS2UdS8K8gWrwFpllkt7Clahtcq1c2L/qF1x1UT1RFayMRQsOSaco8oIizESZT0oNCtBP/oZSMp6CVEVm8dp5qIIPBRM+d7VDYIkwB4K1lKHnArMRADpf/Fdoda972AY0lYv7Yc29UXG0LDmY6a/7VYe8OzoL8oDHTMGeTdLX5uk+Mmoc7dH5OQUFzuNrd85W0WVNf+GBbq37a23Kw6T34MMhii6bT2ZRQ3ydrQ/z5Fo4eM4+e2jQz+scY1smPKGlDZQcdbGINdlWCRlSzDpXAjnEW/VfNhVizQaH3ai
 7hx4L9Zi
 Ror3yqGLojwLUUXavKMc5/I725H12ms8FdMjQE7Kz6Bgy+VWg9BZZWXoVl00vRtb/OsMre/XOzP+RiyKC490bynt5clBiU3T+AM7/GQsQ1qONxi6YQlzp+kQVPZGl5HH/7lUh95f5IKXfPZr7H0DhPMq3O8IybAV9bYSywMgEUiY+JB4vE9P1Nom8F9t5MjFn71BVCbCSQ4Mfx6K0FXR955zVx5Oes+/v4dcMfc9J7H8/OJ+0GXXz4tWQCYeBPit020cJB+uwJMpGXFv3to7MvGP0SobSzigG0U+qEh8XLI8Tk/G7elRvNJuWIg+rd0KzABE3kFBnYi3qH2quIgrYB1A3v+KH67v2Udtw9yk/TfwbEsY4Alkhk3sS3cxWkdpAXtq37eSbJLidUm+lxSkGZcK/uOUJEzzxC7h+nLbSPElJMsevvMtYHS1JYL8dVWNmHUpOSXn3P6dlhiBwp2Nv6BObHf4xNz6b0rixAJfmDUWnO0REMlHXalkD8f42H0g6uMmPoFApXZ8B67s0odcTwbSDyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------lOxC8w6OqcKZOEPosUCaHYgt
Content-Type: multipart/mixed; boundary="------------p0ORmjYoU6jt0zrPNhwgnPpM";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-ID: <3dee7d67-c8e8-49e1-83f9-54aeeb699442@kernel.org>
Subject: Re: [PATCH slab/for-next-fixes v3 3/4] lib/alloc_tag: introduce
 mem_alloc_profiling_permanently_disabled()
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <20260713-kmalloc-no-objext-v3-3-47c7bd138de7@kernel.org>
 <CAJuCfpG=Dk6PRWy-8wR4j0UreSsa=fdiFWvBYpOkSZE0zV2Z4A@mail.gmail.com>
 <fcee1dbe-1109-44c8-a3dc-8aebc5569c73@kernel.org>
 <34af7126-0a19-4da7-a3dc-4e6e0ae01ca7@kernel.org>
 <CAJuCfpHYbTobe04+Mm_CRMv2SkUuT_9j8T7ByEyv=cJU+YZZCg@mail.gmail.com>
In-Reply-To: <CAJuCfpHYbTobe04+Mm_CRMv2SkUuT_9j8T7ByEyv=cJU+YZZCg@mail.gmail.com>

--------------p0ORmjYoU6jt0zrPNhwgnPpM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/14/26 11:37 PM, Suren Baghdasaryan wrote:
> On Mon, Jul 13, 2026 at 9:28=E2=80=AFAM Harry Yoo <harry@kernel.org> wr=
ote:
>> On 7/14/26 1:15 AM, Vlastimil Babka (SUSE) wrote:
>>> On 7/13/26 17:43, Suren Baghdasaryan wrote:
>>>> On Mon, Jul 13, 2026 at 7:29=E2=80=AFAM Harry Yoo (Oracle) <harry@ke=
rnel.org> wrote:
>>>>>
>>>>> mem_alloc_profiling_enabled() tells whether memalloc profiling is
>>>>> currently enabled. However, even when this function returns false,
>>>>> it can be enabled later.
>>>>>
>>>>> However, this is not enough. Some optimizations can be applied only=
 when
>>>>> memalloc profiling is permanently disabled. For example, to skip th=
e
>>>>> creation of KMALLOC_NO_OBJ_EXT caches at boot time, mem_profiling m=
ust
>>>>> be set to "never", "0" w/ debugging on, or have been shutdown so th=
at
>>>>> it can no longer be enabled.
>>>>>
>>>>> Introduce mem_alloc_profiling_permanently_disabled() for this purpo=
se.
>>>>
>>>> nit: I would call it mem_alloc_profiling_supported() but this name w=
ould do.
>>>
>>> I wouldn't like that name, because _supported to me sounds like those=

>>> CONFIG_ARCH_SUPPORTS... things and not something that was just disabl=
ed.
>>
>> Agreed!
>>
>> Actually, last year I wasn't sure what "_support" in
>> mem_profiling_support means and had to look at the code while fixing a=

>> bug [1].
>>
>> This year I forgot what it meant and had to look at the code again :)
>>
>>> I suggested mem_alloc_profiling_unavailable(), but it's not ideal eit=
her,
>>
>> Hehe, in terms of 'the meaning is obvious without reading the code',
>> it's not very straightforward...
>>
>>> naming is hard.
>>
>> Agreed!
>=20
> I'll let you pick one :)

Haha, I'm honored! ;)

--=20
Cheers,
Harry / Hyeonggon


--------------p0ORmjYoU6jt0zrPNhwgnPpM--

--------------lOxC8w6OqcKZOEPosUCaHYgt
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalhDSgAKCRCGXBN6rc5S
1hcnAQD3nYQVAKHZ3hfmxXfyxI1L/pYM8ir0KVNZM9xSNtSPWQEAgwc55+yK9mth
1O9U56aSWA7yIYwDafELZ7j9tOAzpwM=
=KQXf
-----END PGP SIGNATURE-----

--------------lOxC8w6OqcKZOEPosUCaHYgt--

