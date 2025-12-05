Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31BA2D2E02E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AF5F6B0113; Fri,  5 Dec 2025 02:55:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 586F06B0131; Fri,  5 Dec 2025 02:55:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C45F6B0133; Fri,  5 Dec 2025 02:55:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7FD6B0113
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:55:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D64FB8A4F7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:55:11 +0000 (UTC)
X-FDA: 84184656822.13.4AD1BD8
Received: from mail-10629.protonmail.ch (mail-10629.protonmail.ch [79.135.106.29])
	by imf15.hostedemail.com (Postfix) with ESMTP id B108FA0006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:55:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="kvFx/xmZ";
	spf=pass (imf15.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.29 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764921310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eiqow6AcLnuWm1OdBsmeLZ5HYj8tUdXBpN9mWfYflcc=;
	b=hgZqEhZh9/1zbkD/lOQUrsp+1Km6yVoZGlMLbMo00IERopm6ObOcApVuxp8NnE2i2VMI2T
	uQ5MqnW7NGy+hiR0QXQl0fSnv5YpaALIerXF9pVCZFltQ02cYDN9cR0qlEkdJ1CFt2Ovjo
	yc4Om8rBwyfGjpue/NdsyLNvtQTkcU0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="kvFx/xmZ";
	spf=pass (imf15.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.29 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764921310; a=rsa-sha256;
	cv=none;
	b=jSE4txjmL6hS2M/BL1XfpDaNTbSvOudZYK8WTdKJvrqKzvZWTgPfop2/UvyEVqkCQ5Rbys
	pqaUDtwWGB6VpVYFFo4kZkYi8CLInbbrYHcErU3c7gimuYNH4rrsDYnPyctmQqGSP6rqKj
	uDO1ax4CzIz0u7dbrvn0ukIupYsNAP8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764921307; x=1765180507;
	bh=eiqow6AcLnuWm1OdBsmeLZ5HYj8tUdXBpN9mWfYflcc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=kvFx/xmZyPHAKz30NarZ1fmnaBZi4q2DISbTJQWJqwuiLWqwDAFVMgfVhPtW6+3lN
	 T+qcK/wAOc+iAoEXl3S7vPawn+ZnyRPN6TDEtAERsy1fLrYzuBsor82zfqMtxOlc4t
	 +F1nZwI+yDMuKL9lo5nSM+ZZlU0TDzkQBWXUKD9iECzfuY/rbsXW9PbzsPx/Tkz0s6
	 v7U1YgNPKDOIga4EX5jagdZde9ME/o+/Zl5cQzdzn+MWFQFQwlmJIqQwlXkfZYXS3G
	 owBB+wERT44JXHTbDhbzHcvuDHa35BRdf10UqUILaekSYK6iW927qQDuAQ2PTE49dG
	 gyXSGcJBIbWUQ==
Date: Fri, 05 Dec 2025 07:55:02 +0000
To: Andrey Konovalov <andreyknvl@gmail.com>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver <elver@google.com>, jiayuan.chen@linux.dev, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] kasan: Unpoison vms[area] addresses with a common tag
Message-ID: <qg2tmzw5me43idoal3egqtr5i6rdizhxsaybtsesahec3lrrus@3ccq3qtarfyj>
In-Reply-To: <CA+fCnZfBqNKAkwKmdu7YAPWjPDWY=wRkUiWuYjEzK4_tNhSGFA@mail.gmail.com>
References: <cover.1764874575.git.m.wieczorretman@pm.me> <873821114a9f722ffb5d6702b94782e902883fdf.1764874575.git.m.wieczorretman@pm.me> <CA+fCnZeuGdKSEm11oGT6FS71_vGq1vjq-xY36kxVdFvwmag2ZQ@mail.gmail.com> <20251204192237.0d7a07c9961843503c08ebab@linux-foundation.org> <CA+fCnZfBqNKAkwKmdu7YAPWjPDWY=wRkUiWuYjEzK4_tNhSGFA@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 0439dadbcca67de10a77ca7cb46b286e26d6834d
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B108FA0006
X-Stat-Signature: hht38ym6ebrdxhpoyxtek3kutst1iwxw
X-Rspam-User: 
X-HE-Tag: 1764921309-147028
X-HE-Meta: U2FsdGVkX18tNlRfl0B3bHtnntofFpjhsHlJLS8ZaCxwvfpt7MlPgAnG2rSnsSiAUtv8yyNR+3UDlsOXz3f5zvV3mIF4QviUVaiI2z/XFtrcSU1AyYKHXgu+StyAW8i2qyhFfFoOh/xPCg4WLT6uKckgmzZFBld9q8ANP4voSS+Hxg12y+hSOanIC6KvOgXMJgviD5/Uu6Y6DNn0nDHm0jEbJua3EdYo9P1tZMP1penRUuj7FJf+RGHyLNBVNB3x8je7tP0kMCraRJ9uFCUSEj5UohokS6C7p6SskBHGwiZ9WLQZ9hd3Zqw7eVH62W+L2lgfyqFXkGX14X1fPSiVN6zTHaaOOaE4FhRkbtm7xj043fw8L7000YHL8PZs0fpIPCuGsBE/0G+5K4NLDt+cM4pSFFLIIZ2JGH2iPkwCsGRaH4uOG41mSoVMNQArLzcDXAYMWCjqYvfGsx75oT+eb0wM2hPh1FkA1A6AOEZZt2192PYK6wb1Fn5zslc/11+BnwinIv1RhyWvRB88dX4QMRbgy7WLgHvSubgH/ytSaal1a9vRZY16PP4E8bJULEelgUH0v6+dXdhxAJD/leEVH0vgHqP3X0YQak+BxB/RO9GrOUELxynbmV4hwHDm9joWoOOpxyYdg0EfNhpyqsoPitM56tywVq8pBRybb5B5+J7HxBB042XQSL2M9lOtOKbOQmuWMTcpSaibvowKge/YSVVb9pwmp4KAMJM4mrPII7aW2e1iRIJ0BHbBbA6BA43gbvL3nRGPHM66wQC+8XYKBK+wJA6VCMIxkOC9U+98xkDeyd7M4pQQqPJmHcaBfvJ/rl7o3wtKyuTLbx8Gmv9ydMW6K7Xvd4j/+k0JKT0iOXqXRLAmbBdv6JsINNdO5oRdW7y4L/k4wN+VYDk/V+XQD9/SG2CAnCS0UKYdk+TsADp+cTsT+NPiE5E7ZARzbKlcVH4oXailJsF0M7YqIAn
 D/aSDwul
 PHugS7wVI37GeJj44lcxyH0ms5OBB30rUId1RqUgFfhi/ugI/UnlYAEO8oZMuQOReLGBGfJxU+I3RxuxQZpLZDNWHmfjYLK4hET4gsTYvMGg1ZkjNjLTVfNSA0vF2cJNzOE5Pm/YnTzbM/P4BcqJqUNV0v1f13sKVUAESZdjz8RJQ962doGRRxIDEVlLdFwxpQy32Q0AzRPTOJFfzx6lww4HflPbiVoadSfl3VoEY+dQwbqMm7D+/4iwttmVB5FPXMgsaTonsfn4hOCZsQATA43RJkBuXTskVan9RxBXbGEiz/QOc8jHNY0nwKu9KkhScIKJgOn3cNWud84f2nx4xuko3QG3XzUExCTeZNgtv6GKSzAmiThfCq1P1Nr5/pI3+O2Jn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for checking the patches out, do you want me to send v4 with this
correction or is it redundant now that Andrew already wrote it?

Kind regards
Maciej Wiecz=C3=B3r-Retman

On 2025-12-05 at 04:38:27 +0100, Andrey Konovalov wrote:
>On Fri, Dec 5, 2025 at 4:22=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>>
>> On Fri, 5 Dec 2025 02:09:06 +0100 Andrey Konovalov <andreyknvl@gmail.com=
> wrote:
>>
>> > > --- a/mm/kasan/common.c
>> > > +++ b/mm/kasan/common.c
>> > > @@ -591,11 +591,28 @@ void __kasan_unpoison_vmap_areas(struct vm_str=
uct **vms, int nr_vms,
>> > >         unsigned long size;
>> > >         void *addr;
>> > >         int area;
>> > > +       u8 tag;
>> > > +
>> > > +       /*
>> > > +        * If KASAN_VMALLOC_KEEP_TAG was set at this point, all vms[=
] pointers
>> > > +        * would be unpoisoned with the KASAN_TAG_KERNEL which would=
 disable
>> > > +        * KASAN checks down the line.
>> > > +        */
>> > > +       if (flags & KASAN_VMALLOC_KEEP_TAG) {
>> >
>> > I think we can do a WARN_ON() here: passing KASAN_VMALLOC_KEEP_TAG to
>> > this function would be a bug in KASAN annotations and thus a kernel
>> > bug. Therefore, printing a WARNING seems justified.
>>
>> This?
>>
>> --- a/mm/kasan/common.c~kasan-unpoison-vms-addresses-with-a-common-tag-f=
ix
>> +++ a/mm/kasan/common.c
>> @@ -598,7 +598,7 @@ void __kasan_unpoison_vmap_areas(struct
>>          * would be unpoisoned with the KASAN_TAG_KERNEL which would dis=
able
>>          * KASAN checks down the line.
>>          */
>> -       if (flags & KASAN_VMALLOC_KEEP_TAG) {
>> +       if (WARN_ON_ONCE(flags & KASAN_VMALLOC_KEEP_TAG)) {
>>                 pr_warn("KASAN_VMALLOC_KEEP_TAG flag shouldn't be alread=
y set!\n");
>>                 return;
>>         }
>> _
>>
>
>Can also drop pr_warn(), but this is fine too. Thanks!


