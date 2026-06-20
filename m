Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B0BDCDB466
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 22:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CE716B0005; Sat, 20 Jun 2026 18:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F046B008A; Sat, 20 Jun 2026 18:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447516B008C; Sat, 20 Jun 2026 18:00:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16A8E6B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:00:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8224DA029A
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 22:00:03 +0000 (UTC)
X-FDA: 84901659486.21.831C0F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B80CC120002
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 22:00:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9PwQS4e;
	spf=pass (imf29.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781992801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tDJ33uOBr59BAp/p2vfEcH2XbwYYJbL8kVvEXKlUrLA=;
	b=tUOAqqfHBT3QKqZK0UbBb6tc8ETQfRA+lpLeIPJUKy0/8ul2BQ8InaxJZh3IxoE8DnnUTU
	pa0wGWGDp2PF91C0OQhOCdhpH/UWtY5FQv60oIx1EgJ0S09YM6YHwgi+pg6H1T90OTztGR
	6g4bm/fBaMor3JRCwqO2USAqGvq2K9w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9PwQS4e;
	spf=pass (imf29.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781992801;
	b=Ox6cVuLL8E/9LrMwXPge+MPyHXILxCqrk79GTfgruLyZKTvNuKLIKd4hmEkJ2x7JJYf2YM
	2lglx9IpQVbEEoxbRXNI5WYAWWTkTmrGefgvSehzCMh97Ktmk1E3Ah8H/B6GkfhVofTWfH
	i2zKxQ+hlzIPUvA8O7O4ztCXtuYITbo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A614B418B2;
	Sat, 20 Jun 2026 22:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFC51F000E9;
	Sat, 20 Jun 2026 21:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781992800;
	bh=tDJ33uOBr59BAp/p2vfEcH2XbwYYJbL8kVvEXKlUrLA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=h9PwQS4etwPbAg9X2ufL4llCHlsEGgXRKFxLf0paQ1BatbX471sarP1Hr5epLyFV+
	 aK4CUkuXrN/eh8KzC2flQhazihb50wVyjEslO8yT8drbWxzlSHZn6XoSkvHgNWiFL4
	 JPFraZpq3DgZ1PwE1RXzZCElzchoUdxGPFYcXnYKBCoLEKEzKTaX6uRjnDmn5b20Eu
	 cmT91luAAjGnEXpas+kc6Grz6gVgWXECc/6pUVassD47ERWE3gAwtX8ViX4CXPUckR
	 u8P9/NC/KsIhgVkNsRnqoc53kdMNNI3M5WzMN1KCv/VZZm7FcP/0fD9xTJlTtXkVHL
	 hJxAv2t9cjwPg==
From: Thomas Gleixner <tglx@kernel.org>
To: David Stevens <stevensd@google.com>
Cc: Zach O'Keefe <zokeefe@google.com>, Dave Hansen <dave.hansen@intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>,
 Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Andy Lutomirski
 <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra
 <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, Kees
 Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
In-Reply-To: <CAOiLmNFC+BWdBNm_waA2Ly1x6oyCzsomc0AM=r5TkQK3YskfGA@mail.gmail.com>
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13>
 <CAOiLmNFC+BWdBNm_waA2Ly1x6oyCzsomc0AM=r5TkQK3YskfGA@mail.gmail.com>
Date: Sat, 20 Jun 2026 23:59:57 +0200
Message-ID: <87pl1kna8y.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B80CC120002
X-Rspam-User: 
X-Stat-Signature: 94tb8qfbne3xmyay9mrp5876igwg1ggu
X-HE-Tag: 1781992801-381946
X-HE-Meta: U2FsdGVkX18BbTIEzMDXCWEn68q493RvCosYCtnyYSgtA+O3QbYD4ombuFTIPJB2QQ6UdVWjgOv7XDaXFwtO4WmqYkE2wRdmzDGH7dZX+DuXPHSn8PSAifAv0FhtTbjIstPKJjEaGjcOItJH2XLlbn7L6u4C4qjplQ5YNXHJF+roPTDi9LxHHyEiTIWA2/k6X18vf1jlsdoU3UCCqvnz9qOmag3qGAS5M50/d+9xsQUrKznX3D2Veg91+57PFTxHx7WKjfqnBIutbwGqOiUCourD7C5VSC0X+aZZYdo4kgmTbNg+RgjITUq/c1zOSYi63WEPgIaeBKZTWbMEwRocvrA3G22dCwdVcn9jVl5pZY0NFBs1eS0nfoYHhlG3uZjMBAv2BYZelcQcii7HkAVZQUgh5M+gHoNB98jYOrjsHKcDhbVLgJibNd2RUtze7aUyD1x3TqN39WgxWhYK5+AyEgTdLQ701T7cJzXg3E4QGL4QVgBkR55R5mJTd8USacMm15S9fHCM5oPzlbwz+NsNybsVFka9fchjyBUD5LgwWXFawstgAyjp2i1F4dxGWNPeKN45OuNPrBJG2N9o/0Zdf7dZBDHIcFjfeae8wivPgeTwY4J5FDAqg8gDkgOEQXoZmveXZgSkrs9DSO6Gv2fbIPVJ0GrbpeuEufh8SVSbgN3Xe4y8KQK/RWd2klBgREqT0fxEOnVBaUuanpRSZY3o0/XdVF4QpOHZApPZ2qcux2U55RWfm+2Tk4gcWtqmpn3YEHukqgItcjGKMKNnAh/zjwfPwrvDj5X8GiX6zG6WDDyz+R0XU83/04dtuaQcfu6TjICpzMC2h8DXnnUYWwbq7DcC8vGefufdVeuOl8khvSeCDskFvWyoN8tc22YwYY4N26Z9oAzL5hm6mEv7C00Ps0Ciwt8F8spDuzsVoaGNeaYnWVSQYOuRxdqXen9bYFkc6QSZKLHTke1bUhFF9PG
 NKDBhEd6
 e6qGiGj7SteiKK+arMzR/sjOrAsB1mZvVtqgJJF/EH9wOLD1nkj8psDcNi1KgYdurac54emUodDgSXQNfES6EKanqFaJH2XnZWvGZJAAVg82T2ikoDMn6HWElssjdg41iL0YsdZSt3uld6Qxdv7prX3xZ8A2cCVNOCucHDQIo9hV56/ZDCdtmyAzW3dTucm/1iYqT4w3y1Uc0cJtBh8bjCVqmvn1CLR0QkudU8Z2x5XjGSsFsfjBLCThkrXszdT838IJN6sDY95TawD0rN2ia8qWBFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19 2026 at 22:02, David Stevens wrote:
> On Fri, Jun 19, 2026 at 2:59=E2=80=AFPM Thomas Gleixner <tglx@kernel.org>=
 wrote:
>> If the kernel skips a whole page or more then there is a serious bug
>> somewhere. I might be missing something, but again the "very unlikely"
>> wording which handwaves about it is just disgustingly useless.
>
> FRAME_WARN accepts values up to 8192 bytes, and it can always be
> ignored or simply disabled. If a stack frame is larger than 4k, then

We should limit that to something sane.

> it's entirely possible for the code and compiler to align in a way
> where the first access in the frame skips a page in the stack. I think
> we agree that such code would be highly suspect and (hopefully) would
> only exist in out-of-tree drivers.

We don't care about out of tree drivers.

> But it's something the kernel build system accepts today. Dynamic
> kernel stacks suddenly turning that into a runtime kernel panic seems
> like exactly the sort of edge case that we would get yelled at for not
> addressing.

That's a good thing. If it breaks in tree code then those people have
finally an incentive to fix the warnings sent by the robots which they
ignored for a long time. If it breaks out of tree code then *SHRUG*.

We guarantee not to break user space, but we don't guarantee anything
for out of tree kernel hacks.

Thanks,

        tglx

