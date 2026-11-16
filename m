Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D1DA606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=A4jZBMLr
Received: by kanga.kvack.org (Postfix)
	id 171166B05B1; Mon, 16 Nov 2026 14:42:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 121D86B05B2; Mon, 16 Nov 2026 14:42:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F066B05B3; Mon, 16 Nov 2026 14:42:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA4F46B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:42:05 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60896A7559
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:42:05 +0000 (UTC)
X-FDA: 85442003010.02.690D6D6
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id C4B73C0003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:42:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=A4jZBMLr;
	spf=pass (imf22.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794858123;
	b=wbH8jPfXEn0VnXTZabAyykD+4JrpRQi5+3nXNqRc+knhLOtRmIEFNkSjkz15AnC7Bhuubd
	lG7GJ4cW9d897V6KZnklcPOnDthyrHtsUtGQX09fahHY4wjr0Slj5Uv4R6Po3NqP7Ja67J
	OAbc5rfjIGPSvhlMU8wwrtvIK71FHQ8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=A4jZBMLr;
	spf=pass (imf22.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794858123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SoqAqmuXv97PmZGFBFFCczoznG+kfpt1kIToyl4KM94=;
	b=gqCvkSJ9QP/ZYM/JxWqg09Hez7gk7cLcNGsv60QATGSRFm/8ljw6xnm9AzEeievvRv5gMu
	JYKUZAfH8Mrrez0eiiMKJf2Vh6OvQoef/c8JQGySdo/B+QObGrSLX9CaJCScrcT0r/ME3m
	RW9dqXIiOMrKkdcfAaBUmfBuET+sNxw=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c50e9408873so130667366b.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794858121; x=1795462921; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SoqAqmuXv97PmZGFBFFCczoznG+kfpt1kIToyl4KM94=;
        b=A4jZBMLrZDsG0zxpCoDyLDKJrVU1r7aDG4DNQYQ0cXkxNI9udO5WttF/09eHsbXQFP
         1TST1Vzk3jQRGmfUtADpM9xB7jiZ5ciUwK3TGbh3NssNm8Zbq/HmoFpGVubDPZMCIo2r
         ycFfFfkXLifDoruxjrf+rkL5HlkVJGqvCu4Lo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794858121; x=1795462921;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SoqAqmuXv97PmZGFBFFCczoznG+kfpt1kIToyl4KM94=;
        b=GJsLmLXAZuo4oAG6jZpDoNmfzmCeFW/3xNNBTtAs/Euq/4aAO2vjKZfTMTml9IOBXy
         vv4uZh8KFKqQ9qqnaq/wCf4sVlGO3QphEQEsyS3GetO/aJMnr53G/aTRuVsJ2sU3Cf7r
         LEsRXEvoIujVeElrklO4GgEVNc2afc18zrdWMyfMqO+4c3Afw0mLAhPn9Y5PQAXqfLjf
         fV2SGzr59Z3o5lXzE7skG+gwJLk5Mb//70D42sdZmxnSgteF8J5hJeewxADuiOgbDAp5
         SMbCYf96Rsotjw9atZrBZemATbQ/ue3VdNYwgmwE+eTkb6yLIm6jl9CI43RYHy0kOIL5
         LH7Q==
X-Forwarded-Encrypted: i=1; AL+hErF6bM8znAgxFcRc2bBwBux6VhxlmArjW+q3bOkKrqD5CKwCUmPq6ecqvGeUR41gATOyjdYoC7zLVA==@kvack.org
X-Gm-Message-State: APuU4Z9xBi9zwjf1bZiWEiOlhAAGQ+Avwv1Y3XYpPYPX1cVIvXdIKvtl
	DBXsSPu2woR09vesiTUTrzySOH1mkwXjd3YAL5m0uB597ES2EC4tDErDBmKeVbWsfmtR9Fa6Rbi
	7h1ErbtsMBQ==
X-Gm-Gg: AYBFou1PZsDjulvm4vLQ8Amj83lwX4CjQ9xYi2vXjmWQJeT0Ut4TQupKvEFeP4wrSyA
	XVR55X7xYmvFA7NlS+nHg1ZdLmiQswNren4P/YnOzxPM9QvP5DtDFL7g/ostchieEIkqmeXzPVV
	XkQhoNIQfpPV5M01z76cnVujTiNa1885dmoW7BYgEckQB26ZbMR1P3ys3wSFHIk8vYcsYL6bQd4
	TPa8UW6MfywSFofCf5jVBYxjxpgdpYCnmX8NUAruxePM/kEHupO7b5Z0AfwDBHqg1NhMwpemrf2
	0ysizeHJEgAUc7drwUTQFN4ZDBXVR2Zrg4JLlXfInKhC6NYeMSiByfCp4dUNehxjY5JN4IRg/Dr
	+i+7gw2rOLxeJekoMCSMPfhVPefDh2FObBwLiEc8bksZuJnrwYk6VzSYT4Q/ZimqrI1NFoJAc/T
	YyK2fR4+KlqDC3dGsf5aGg2F6kVbTP4022lLGvxQTuMpdqAigUvQLaYWgdSdPhbkBDBCn6hbD72
	f94Wwrl0BgvQacZDKK1kxGLIkOzSg+uSS4juWDhOxF0yTVpDCcz/BGWC2jQNHr+D6RimTKgCP3x
	jifAcQbAfUiwkQkxBmQfashHj8WGDCYWYYzhQjSdVz+4oi4AQi0omswXcAVzpZIfkqfJbKCbbEj
	pPbs=
X-Received: by 2002:a17:907:2d21:b0:c41:21ef:26ef with SMTP id a640c23a62f3a-c509637ce21mr1022979666b.20.1794858121241;
        Mon, 16 Nov 2026 11:42:01 -0800 (PST)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b236d4sm456604266b.18.2026.11.16.11.42.01
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 11:42:01 -0800 (PST)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c50a4a2132cso507581666b.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:42:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFOzM4LUyXZCYZUyUB9ITxOm2L76b6BEdpx5/gexVGjhoo2Ja1rBoNXN0TKgkAvIOUVtnmATVCZEg==@kvack.org
X-Received: by 2002:a17:907:60cb:b0:c4c:d6a3:f4bb with SMTP id
 a640c23a62f3a-c509634503cmr1008394466b.10.1794858120895; Mon, 16 Nov 2026
 11:42:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261025164719.1831477-1-sashal@kernel.org> <CA+1xoqcxAsRij1j10TyhNX9JXNXNkdWO3sMaVRXCqYdEXi45fg@mail.gmail.com>
 <CAHk-=wgCX4=ZSPALxR7VHKKAKipU1nD_Am-Q-0z1SRKxr-VRRQ@mail.gmail.com>
In-Reply-To: <CAHk-=wgCX4=ZSPALxR7VHKKAKipU1nD_Am-Q-0z1SRKxr-VRRQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Nov 2026 11:41:44 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg-5cWvYgmnE2WH4yys8tB5AwwRQU6kW0r5VoRYBLT7TA@mail.gmail.com>
X-Gm-Features: AclHuK-GW-sq_aqp10QbcNSLO7AtIlmoHSb6NWDtJ770GEzenoCICUrGbvxqol4
Message-ID: <CAHk-=wg-5cWvYgmnE2WH4yys8tB5AwwRQU6kW0r5VoRYBLT7TA@mail.gmail.com>
Subject: Re: [GIT PULL] Kernel API specification framework for v7.4
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: C4B73C0003
X-Stat-Signature: m7ck1yw7ug1e9fc5ohd1w75phj1fudjw
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794858122-661260
X-HE-Meta: U2FsdGVkX18JDgeZ5OMeVB92UKNgqI0UAGHurGlv5mP+bBIscgVA+xv3hPEoCA2tuShPt2bdcLDFxSHIJxAI5opgAe24gybR026ETX8Y5w/Ey3rfa5WgA016RcwETtuO+5nDxFathsijPtTJdKoVxBSvJ6alclmIBJkbUDWEuBx7NeizRf5EUsm1fU3cO/HwmeX66ncZs3Ln5z+VY25U8glaOzjZ6y0f/KwJ0p5i76/QQnPL6x8rCCDZM/ZPy7V3mEa63hzXOv+A12nDHgPtf5wPoH9ioR74KOTpjeVLSbDKMJR0njlhHIdat9XU9tdFjA8l9nV/M/w4/+MAHi9eU/uJMg0xSL/T33/TOb+8r0EctAKvPaRSHGX454bJEYYYEJqicW9pAad2RzGYEGlHLH+Jrw5lv2RdHLavvJ0yNPepBgXaUDY5gnxvOlpcap8mxsG0o31o1/sPyr4LMsrD94l97ulPN1wcpz3ovdzwNukgUOM6HUOuxDmY7Yk7sXmq+rcwrVqLNwwK+0EYUKsi9hHvQ4O8gyBmk4Z0A9bp5JHLfnVjEgSkIa+QS3356q1Jx6WTj2QLwpq2nnJDc9XGLqRk5gc4kuO3LXUb3K0UsgpuxsQd7cCYRyYUkcDYAtcLVXfRIboyxQH83AgplraqsDtRFnVot4DPkNS8mj6KNfWXYKpWsx+qT7e0bhbSLPaD3bHSK5r4MeXi2dgSoNVOWzCt5ouKNUi/boEzi8vyuqU957LHmIe2NaEW8yZrgA11tUj9BuzB/PNIXlHoGRiSvDhgSDXfrsAggsyVbiHZ5sWTg0n9lb5hXwnvUi05Tu2ypoEnX9iQa64qQMVuUFN6CZEVQswPFOAkoQFtpxLYOg5pLcq7dgquBMgyj686Qe1rnBKgJXYBVROpvncxEpBEXjzTL6uctxYhdXY+Si8BnrO9CdW7Up1gq39ujQLheEmXbEkeTZ+kur405XhnK/c
 dH/Jdq82
 R6FRxRMBGyxKYpaSlJdHIU5Vko91IYyjnOdnKprdtYjJ0NydEDpvhA2YYdtjfkfwI5kQ6CLdiKTOR9OihN17+fXNTThWA3qEyvLb3xkjST9GSu0Q3Y9QUwAo0tdQTU1dL/qAg94wO2KoXqcT9WqkgzDs9S2jC0dafowdyIcHN5ZnzDfuHbzOcDUzRwWZ6oitZ5ZydRoYEvOdRV+MebUPm435MCzNnDUHie9wuwOTi18Nl9GptcLN9V2fyM6jjUR3RVIvGuzuVMsxeyaueyZ7AhIJHD1g0sMPOQLBd1NyNJrTiRdpYRR6SBQiUI8ihfmN+6eB99jdnzSQ6NMHvEDBK61FjJ5xKhG1mlDdvVMkb5s8p9V2WWQBUD1XI5B+Bd9fh2JalUd0/DhC30qLFhpzqlX3Kv+h/PECN9RqTfpdxAichHaIDi/BEOYU7RDs18+1On42L/TzUvowFu/L0mvJrY6dAOuOA5V+pGBji6A1fpGcG2d5e32x/zX5N9uGy0VqthFPHoD80A2qGt0mP110D0iTW5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 at 11:36, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And I see *no* upside to any /sys/kernel/debug/kapi interface

And yes, the documentation calls this part "human-readable". Nobody
cares. No sane human ever reads and compares specs. We shouldn't
expect humans to do that, and we should not design *any* of this
around "humans will check it". Completely pointless.

I think the specs should be purely for automated checking, and I
suspect any initial spec should probably even be *generated* by tools.
Because the kernel API is not something that has ever been designed
"by spec".

The kernel API has grown over time, and pretending anything else would
make the whole project be just a fever dream. We are *NEVER* going to
change the API _to_ some spec. The spec needs to match reality, we're
not changing reality to match a spec.

Then, once such a "spec matches reality" has been generated, that spec
can then be used to check changes. But neither of those phases are
ever going to involve any humans, because competent humans have better
things to do.

           Linus

