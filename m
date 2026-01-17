Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17616C98313
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 06:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB64C6B0005; Sat, 17 Jan 2026 01:53:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8DE56B0088; Sat, 17 Jan 2026 01:53:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8CE66B0089; Sat, 17 Jan 2026 01:53:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2A666B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:53:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B46E713A934
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 06:53:23 +0000 (UTC)
X-FDA: 84340539486.24.982E857
Received: from mail-10630.protonmail.ch (mail-10630.protonmail.ch [79.135.106.30])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7AEAA80004
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 06:53:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="YZZgSyZ/";
	spf=pass (imf30.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.30 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768632802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mY1/L4vLjuKGDVBMdRgRIO1ljS4pAfye7RfXByDjAz4=;
	b=YCgNCqLA4YSlR0Z0EwunQW7qlL8t1XEaOCNspDHlFvnIcKRJGKfQoELuuuKojoAJQAdBNa
	RRv+weay/Nb5TYwUD9PZovT9/aYvh6FM7GJkRMrbM9E+N3QuIuZTQ7a2H36erOZuRv1MyO
	N4zOThV0qYn0/jbVx+bkTn46/zjLRhw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768632802; a=rsa-sha256;
	cv=none;
	b=hlrRXSn3fE+ZPlQsBJsU1kRQbthrTlRLw1N5tCSmZanN/s78YLjQObkh1NxRNzZ5JHK3l/
	8T8vrr/9Xj/GD93z0KeDLxJjoL76H316/tPG6CHrO/Uy+/RGH65tmXvDgEopNJaob9wq/u
	9pSGg9O+/qzc2FbkdRe769fdYvo95Bk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="YZZgSyZ/";
	spf=pass (imf30.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.30 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768632798; x=1768891998;
	bh=mY1/L4vLjuKGDVBMdRgRIO1ljS4pAfye7RfXByDjAz4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=YZZgSyZ/V8qaiWNq6r9ExFXobkwTuo/XDZEYnuBeVIGcW0FuvP8Bl53evH0LC0P9/
	 f8Yk660bTP2QRumACMtdPun2sFSRePXWT3Y8OOyJ7kPkdTk3vZRp71OJ1keUi2kwQY
	 gklEyWVI1l+A0miBsRg/GFIE0/Sj8T5h3QZxsiSJjuWh/vHksv0QeE0bjmbFNywBy7
	 czNXyNHTlECxW1rjgwC7BPs8yKgANOsCdtxTPCbfuDWX4qqSSBAR8/eglBWMSu26Q9
	 q/sTNWsC6zB+cSvRwBEhZg365qrX8R5wEArTogZ95y0nCg7wHzF5MwgBpdt6ELhvn9
	 H2Rsccf1Ott4w==
Date: Sat, 17 Jan 2026 06:53:12 +0000
To: Andrey Konovalov <andreyknvl@gmail.com>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 13/14] x86/kasan: Logical bit shift for kasan_mem_to_shadow
Message-ID: <aWsxozSMLytabW5p@maciej>
In-Reply-To: <CA+fCnZewHBm+qR=zeJ4DG6RJ-mHhLhF9G7f_xSaNt_PAogJv2A@mail.gmail.com>
References: <cover.1768233085.git.m.wieczorretman@pm.me> <b1dcc32aa58fd94196885842e0e7f7501182a7c4.1768233085.git.m.wieczorretman@pm.me> <CA+fCnZd+ANJ2w4R7ww7GTM=92UGGFKpaL1h56iRMN2Lr14QN5w@mail.gmail.com> <aWfDiNl9-9bVrc7U@wieczorr-mobl1.localdomain> <CA+fCnZd4rJvKzdMPmpYmNSto_dbJ_v6fdNYv-13_vC2+bu-4bg@mail.gmail.com> <aWkVn8iY27APFYy_@wieczorr-mobl1.localdomain> <CA+fCnZewHBm+qR=zeJ4DG6RJ-mHhLhF9G7f_xSaNt_PAogJv2A@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 031d99193aadb68b322ecc1084a22287a39ff89a
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7AEAA80004
X-Rspam-User: 
X-Stat-Signature: x9zkfjw9mr8e3zohj9wm9sutqyjodqey
X-HE-Tag: 1768632801-716765
X-HE-Meta: U2FsdGVkX19g02yRsFVQTvaqs9rufLcKiv58ndJhJ4TlpwPSKiBbBECF+WqK5lJ/C5M4NBTY2X8XsE/pzEN5ueg3H6T7uCNhr5whQXxeRe4aj9Nz/10MTvGv7FZVIp8uU+d9h9dXaTiGC3tnzPMlJr7fMD/E7oymrT5eS8wAvB/iVQ2CItiszHU6vSQGd65AFkMA1n6Lw3Bf3oPoErS+ttfQBkV5s8QDEeWD3sQBGcUp8l0SnhOEIPlP3l95qi3o7KG/Zbeul7oGDjj5nKjegefAOPNcopvq2oFG+Us93iQT5wYmS/rs9fabbeLGrnq0hB//I9Kr+Lyq+lisqD5vR2iD1GQMWW3Y/uDpAJ/F6XqF3ib0/iz+mVRUAZL0z31vYci+mU7ymkzPzGS66tcExczNJkdYr5YWGYuZoG+Auu0qvjYioIvWFvWkOziPqtaeY1TDZBHfDxP+Gnaq5e5AyLVT0waCktkxskPdseeB9KeDqy5Wj9d732r2+bixE6+eIXGqZ+rnuMrtwjLh0LW66aUEGFgRhkFFcqje6rYa46RK6I9n4vNhOQ7CAv4q/4IQBleCIy8IcmnluVwEK0tEkAevW0vBg7Uy3FtVrS/6Ro4Nj6Go2Sxy+2QX9kByZAYM/y0BpOOMMp7DGUz5SnT0SL1yUACBBUhuLKm3nUAYktHKpYPPI+3BiH+Kv6H3FE90Bi1I/1lLqZbMJgeP5wWWpzDDdR8nH9joZ+secljH+3W+aKKFwXzID0nzCMsg/1NVvuCirHRbQxMKM9aZzcA+Mr8Wb6I7Wl808KOYqlY9QEU2TMm4sKHYLxfBT1fiOXnVp9bqgM0KgQLJIyn882AQlVVDSUcLHX9oKJ2adSEjdMpwHU5YIaM7B6mNbgYFqCi6KsDPD6s3nwcy0IuvdjPziVpwUkLzGOel3CaS86T4Qz4SQ/pWJsEW22WgXkZj1dZcrO/cVTNbABSYh2ekYQB
 IkdT2Ze+
 RRSKW8r1USDFWr5tA1MRG77yu1rGRgH2BOP88hr4U1mw+8Jz/vrSop63zG6X6RTtoGJptNcpH5pcQqSSld7KyCIlMmlr/zXGftKwzV/NiDONwJTHTtZXh+dNBO7kMZx8aD8lI+AstoEeX11UT+G2aayZVp4QLR2r1NgYxNqJFBA+qxvZ+PBwFKlliWNANwMGgj9CgisAn7o5++pyuzlLOCHQwPnj0LNAgj8XedUT1TeEGZ/ZdyRk8glBZ9fw39GcoYWXqnHnUiOmDBQNemIdr4AJ+BzZtp23MNPYHBQp5BBHJk9WLXMoSA7OWU6fOIvm7B7vn09ahMeTixEOcikOBW1bY/bnWFM8usEJF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-17 at 02:21:31 +0100, Andrey Konovalov wrote:
>On Thu, Jan 15, 2026 at 5:43=E2=80=AFPM Maciej Wieczor-Retman
><m.wieczorretman@pm.me> wrote:
>>
>> x86 was easy to do because the kasan_mem_to_shadow() was already in the
>> asm/kasan.h. arm64 took a bit more changes since I had to write the
>> arch_kasan_non_canonical_hook in a separate file that would import the
>> linux/kasan.h header in order to use kasan_mem_to_shadow(). Anyway below=
 are the
>> relevant bits from the patch - does that look okay? Or would you prefer =
some
>> different names/placements?
>
>One comment below, otherwise looks fine to me, thanks!
>
...
>> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
>> index 9c6ac4b62eb9..146eecae4e9c 100644
>> --- a/include/linux/kasan.h
>> +++ b/include/linux/kasan.h
>> ...
>> @@ -403,6 +409,13 @@ static __always_inline bool kasan_check_byte(const =
void *addr)
>>         return true;
>>  }
>>
>> +#ifndef arch_kasan_non_canonical_hook
>> +static inline bool arch_kasan_non_canonical_hook(unsigned long addr)
>> +{
>> +       return false;
>> +}
>> +#endif
>
>Let's put this next to kasan_non_canonical_hook declaration.
>

Sure, will do! Thank :)

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


