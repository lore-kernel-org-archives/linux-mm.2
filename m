Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 943BBD2F326
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 16:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1ED6B0005; Tue, 13 Jan 2026 11:12:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934906B0089; Tue, 13 Jan 2026 11:12:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840D56B008A; Tue, 13 Jan 2026 11:12:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74B186B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:12:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B47E1401DE
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:12:11 +0000 (UTC)
X-FDA: 84327432462.12.1B94963
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	by imf16.hostedemail.com (Postfix) with ESMTP id 28891180010
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:12:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=PCz8aVv4;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768320729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/IM1IJGDRiUpTxho6UE3GiNOiCAJhVQawQ+QVWUuJNc=;
	b=QcK5RYpHnpg8qqIuJm3dBmxAvdX7cPRjcVnKoQHFq9svgY9okx0rtzMaIca2vTH4uOoYEd
	tAVbl6jbDn6DZ/92ExnLo4aHvvCySVmFIDVkVPZhq3WwjR7d8pT/RK3RDHPvnJH3avBg9H
	tXrqN/MewbFgbWoh8V9EaLsGARdlil0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=PCz8aVv4;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768320729; a=rsa-sha256;
	cv=none;
	b=N5ck3Dy9kKppqD2AKv64RU9qAhg3O/mdBLPFaNNvQVOcbWhBC1/UItlcorv9KyBMPXHfjB
	zg2TouYxH+9KZFfR4SdCI7QzqGJBWjBrTYdk+X8W6OgA4E2CXKpJIutYzfm3hz2qcFQrpi
	AjEE7jywsNuwcohTGBw1XnPePbnICq8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768320726; x=1768579926;
	bh=/IM1IJGDRiUpTxho6UE3GiNOiCAJhVQawQ+QVWUuJNc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=PCz8aVv4IGAk/Wq0F2CSJwRLR9S50YAOPeSR1axyUSgOwAC+2vkzTQ/9Z8t3/uCXx
	 ujndJxSPlNSivO9Z2BZUMn6wlt5PQW2ioFrZmqQ4lX8bStId29hBxsQHdImeU8WUJ2
	 fgkji/raLkDp0JzNiKB0fYvEkhhmTuLi/0ExPYlZzL7zY/A07wtdllatzLf/GQv3Xe
	 yLnvxSUJwbJBmJoEwcfWGlzUpOUJFHYrTCRYTAVtGf9fmCarB6NzuzcQsRbz8lf+M7
	 pbwIBAMz620pjhqJj2gyhMvxT9odf5gckE6TdzcTQAj6bihyE/M/dliWJHqOTsWpB3
	 5eFSXMt+ovvsg==
Date: Tue, 13 Jan 2026 16:12:01 +0000
To: Andrey Konovalov <andreyknvl@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 04/14] x86/kasan: Add arch specific kasan functions
Message-ID: <aWZups-lK-J3NwgS@wieczorr-mobl1.localdomain>
In-Reply-To: <CA+fCnZdTDzruwLA2MdE=+5KQC5VKMEjm49Z5ez-dDO27y4GORw@mail.gmail.com>
References: <cover.1768233085.git.m.wieczorretman@pm.me> <785eb728e2cc897e05ee709d42214172be481ab9.1768233085.git.m.wieczorretman@pm.me> <CA+fCnZdTDzruwLA2MdE=+5KQC5VKMEjm49Z5ez-dDO27y4GORw@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 5dbf393033876631cef8bd13fe0e2530c3676625
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: dcr4osfoh6bri7uu8h7sigx3atp3ch3q
X-Rspamd-Queue-Id: 28891180010
X-Rspamd-Server: rspam04
X-HE-Tag: 1768320728-100735
X-HE-Meta: U2FsdGVkX1+K/KRTSbc5G2iQPG/nMsbGoxtKOlCHnEl3UrCjSCXTBU1wDWH/a9RXqxeBELcnqvi6xpgPTIe784hmsuuDTUEzzfQmJRuBghBLDwTQLIT9FVK8/D/96ftY/+/yWiEeEeFOhGF2HozOyHpVTfdJPomggWg5Wh95VtbsXO5H4XDfWEPdWXTSSs9PvV5U0lLh7YkVUypMMu7F/VAitMKLqOCP0v8PFJMgN2TOCTZW+HW2aApl/uWdDEPs9fo8V8dlSfdadfvl6+4QVcr/t8UbibmnJo5Zv88dgqmeaKf6S5wppYL7kPzuBpLan3Pv7bcuqS9Z/YOOSBfnb6Md80Y0P+byrlYppWlMra3QWtvIjLbMIYwgR6G6cgW4Lcxh07HVscXB6PEjQfsWx5UM2kQQehcWEo8oJzWyOIG3Sv9A/EkoNeZmnL8lVwl7lIz7YzFfxKuPCai/l5gpM39ScMfpCAqmdy7noqOL9L1QbwaR3TsAV5Fd131Zj5angO/eGRESKPox2fPEHB983M2VphiQQ2pC2WgIZ/MZ7t+yJ5jgVwkEmCrtlvzCx7lXLzTIIfNyIpPTes5NrR9Kia3hWA9kGcD3WXIJG2HYXGV5HTWFeA92EJTCIByWZqvI2s3VQdfWonOyMjuKRyyNFE3yYiMEX3SksDctlbJPAk7O2bnIE7YvSTq13xkFwwX+iN3aHrdqRZniu8DtlTk1DzZsDAnLOgBIX/MuVtW8sLH4/KZZJ9gE7r/mGb1/oDQCmXyObfekUY1HzqpYj/ZX8TSezMCrlX0yC4y2YztG2o4zOKUHoNCN/nkH3HB4bLmlx1w1FcLxtcxnt/812WyHalBySjRTMfvHqt7lc3i4yvUpOoUVvaSn8QLJHYHNWt4HJFy+Qxm8o1CN7YHKv2KilxP7GKOXvbgGszKQCiaiALQXNCw6L+jyTvnRcYcCdcWPXYD8rfXXOyZWqaFmvD+
 paJJZdio
 um/isKdOk16Tf1jbOmz7dWGOTaalegVkPeZUXhs0CBmB5gC5zrFeHcOH4dcJut7bAN3NUFIAUY1vDGi9zl6oOb0E+89XFUuLqbvsgv9uZSGGvgylMhtozoh1QfcjN4jQhu8AhG6X3NW+iw+hXj2LiifdRDLX2yzW1ZxLLFXe6Zo3/gDmw6S1VVahlP+QH4n10N6uLDMqgmJU5Avw66sJ+wR3wXjesk9oxcgtOhCP4b7NfZmCq32SdlxG/Xh1Bq+Y2eoN5nij4zyfJJbhIposSFySFySrTaxOMMcXe8FQ58v02XsM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-13 at 02:21:15 +0100, Andrey Konovalov wrote:
>On Mon, Jan 12, 2026 at 6:27=E2=80=AFPM Maciej Wieczor-Retman
><m.wieczorretman@pm.me> wrote:
>>
>> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>> diff --git a/include/linux/kasan-tags.h b/include/linux/kasan-tags.h
>> index ad5c11950233..e4f26bec3673 100644
>> --- a/include/linux/kasan-tags.h
>> +++ b/include/linux/kasan-tags.h
>> @@ -10,6 +10,8 @@
>>  #define KASAN_TAG_WIDTH                0
>>  #endif
>>
>> +#define KASAN_TAG_BYTE_MASK    ((1UL << KASAN_TAG_WIDTH) - 1)
>
>How about KASAN_TAG_BITS_MASK?
>
>When KASAN_TAG_WIDTH =3D=3D 4, the mask does not cover a whole byte.

Yes, I suppose that name makes more sense :)

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


