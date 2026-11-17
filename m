Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C96606A337
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=La5iaYZ1
Received: by kanga.kvack.org (Postfix)
	id 857596B00EF; Tue, 17 Nov 2026 10:57:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0E56B05B0; Tue, 17 Nov 2026 10:57:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681AD6B05B1; Tue, 17 Nov 2026 10:57:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 424AD6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:57:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB1821A049B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:57:34 +0000 (UTC)
X-FDA: 85445066028.11.C651F19
Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	by imf13.hostedemail.com (Postfix) with ESMTP id 04FDA20010
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:57:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=La5iaYZ1;
	spf=pass (imf13.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794931053;
	b=rDEggn4YcWBPcYwNowCoLjfO/Q8KqOwq5I61wND8EKv5Bl6rIZcXAU2ATqPhca3BjmanUi
	10C5FVDsEsXaZsnuxrs8Eu+09aU4vIElTCaEREgD5TYok5/s8O1TyMrXryuv+G2nt+HPvL
	NpE2kk8sPYzsNmnP0xUjoO1LijnhMZQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794931053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+FyKPryUnxHupmwOSIIYdOL35FcAHgGEhz0DKQNfhY=;
	b=Ibg5rKpSTQZ1qNb7/gHN2hfMPZPv2fxbba1U5cx0lVSWMI7KBxzQ96i7vyZlWIezbZzRpe
	WWPK8Paqw2bU9HcoJFSbzvxby9i5JveYUVFTRNfC/04lLpEExEOw/MGmlqBzgdWA0PoAIL
	U0yPXkuHgmMOxGYv/OYA+dWGQy9NuOM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=La5iaYZ1;
	spf=pass (imf13.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f9.google.com with SMTP id 98e67ed59e1d1-3b18c01238eso1530254a91.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794931052; x=1795535852; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3+FyKPryUnxHupmwOSIIYdOL35FcAHgGEhz0DKQNfhY=;
        b=La5iaYZ1G4vXQQ7Wbv+/fz2S7sRa47+Gwvv7LkWCj7q7Sh1AAkd15tb1q1TOR5wj8z
         +R0jWT5JQcEpuWLOYsiC8o4KY3zFPdmK6zlRv5P0GXBU+mb3ohImR+NZbejzboKSI42u
         hh9eDiaPEXtGsidy5dbsOOioxYEYvTLQguNpKCuAFB3y/L1+J60AYsd9hMmlWLXYO/Hh
         FGPlybplhh6yR4YtlDBMsXGC81uBh4xBSjswCxR6Ya6McLew93/wYRBdDQVlCa3qkP7C
         K6fTTMeV9ECX85L4S+mZSmS652AaF2YATxQfgoxrSj/1Oaen/Av3GH5Eq7jmfxBRupZ7
         pTlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794931052; x=1795535852;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3+FyKPryUnxHupmwOSIIYdOL35FcAHgGEhz0DKQNfhY=;
        b=kfYecTIsFhHGVz5Ju38h9fOKbEVBLzMPIBU13lxcwgqylt/gywKKG0z2gwgFUvPj7f
         VOa0mZzZ9cMl4Kq8ZngvOCZFfQYDim8QcNeYkw5qW2h8X0YDGFCk2Klcd+yntCpGL1Qx
         cJJQOgELBijjlcRVCTNWbMv7cegIOR1ejrvhH5cIljSNJrAImQzKSL5CqpPHWXluWKDd
         SxGRrQbE0KqwivgakVGvkmhNrZk/VLL17ggsmnz1dNkx5ubgb7gZg27YY3u2ipiMB28Z
         E6raykeirBekRLe2yIheFvb69Wq59nuKn69MlU5J5o7Z4Miurr3EYohLLTEisq7uLvfR
         bSKA==
X-Forwarded-Encrypted: i=1; AL+hErHV5ZR4EDG39GSpn+coY0TXWap9G699MbZkNzglunB7UkpJYpRUa0o4iL/U4JexylcbM+LBzQ6qbQ==@kvack.org
X-Gm-Message-State: APuU4Z98KYHhqMldHlq7DIO9vHF5wUgyt3x80xp21a2wRRuBV3nSJq8G
	cpGweaav2QXk+SjQaD7OjOL3j74MzYTrEuc9N81RjFt7Tn5LCQCtEMDL
X-Gm-Gg: AZFdTZcly6LBfesRlCWLQ58vhQqR1QsoRymSeLJ2uJHWQaLFuNOIjW69WtTXbYkO/H5
	3iywhfRjYZrhpwarPyE+5jbw6OxSgtRQqNalv7PoLqmY74SUU4ta4vbDucgfh8cckDIAno3gt/M
	INIE6MpHsZ5ypTB7I4E8oWQ62ojdJOifbnBCTkZdC7ClC2nn6DyR5ZbGrKdiqTqbuakfCebb7//
	7c+SYogVhTdZOl1N653kD1jRN7IDc5p+7mgA0FrXjRYuQrcooM8jmc6tgEdGrn2gwDycQKRkbbT
	I4cycoS0P5wMTgdp2vknr+bDazC4tpxlhfFzwS08O46aCDmwHeEhsFwL6Vsjhp4s3H8XOa5h+CQ
	OdmAOz4Gs2wVg9J7eAAnVcyrIa6Xnm1xfK7l80uLPP0vqzLszUFQCavegJmCYYpV01RkTUyej2G
	B6Qev/HooYEeYvbWpjbT1rXSjuj853YtB4hB61Zgi/EE5YLm1DJ37funV3AFt9OZBeZ2y8l42Ou
	v58TWCNF7vAreIcV1UT5vL+r+M0Fb5w8Ad9V56aq2RW/YLN/GfhqyM68F+KbCzMsCEH6RIDsgyG
	b8XijtlrIwrFHD+fWEGP8DV/XdOARdxvFAZTHdx2flzrO6abB19X6LoeEblISdNjI7Uw5VAWQrW
	CiKV7hBhmEAjM17Uacf/zdO98hO44Omnd8O5l1ATcPzt4w4kuKRxc3UI+MEkOaS3+E5ZKaczDuZ
	XezWXUtn4=
X-Received: by 2002:a17:90b:50d0:b0:3b3:b750:d2ed with SMTP id 98e67ed59e1d1-3b3b750d6acmr2306459a91.8.1794931051401;
        Tue, 17 Nov 2026 07:57:31 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac6016c3sm4692320a91.15.2026.11.17.07.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 07:57:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/damon/paddr: skip hugetlb folios as a whole in
 pageout
From: Aveline Noir <jm5905938@gmail.com>
Date: Wed, 18 Nov 2026 02:54:30 +1100
Message-Id: <179493087012.57245.993362683540368479.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, sashiko-bot@kernel.org, 
 sashiko-reviews@lists.linux.dev
In-Reply-To: <20261117143352.121497-1-sj@kernel.org>
References: <20261117-fix-damon-hugetlb-pageout-20261117-v1-1-054ef8760a92@gmail.com>
 <20261117143352.121497-1-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 04FDA20010
X-Rspam-User:
X-Stat-Signature: ogjqgepe78dpdfhsoedymzm55f1is5jh
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794931052-761035
X-HE-Meta: U2FsdGVkX1/eNJjYXPCRVNimtE5Yp0RCd09ds9A2cbejuM1CGjNq6ODBFUi/f6Co6+JLXqrSwTQcY4r8TmjjZPoQoE8JgKjhjans1h+ObEMCmXAmGIK/UsgbmZN2YEq5wnI9/0T9bnH/rL55xXwGZwuynfYmBofXFfmfaWKCJvZgUEPlaxGWOxy8Vcn2KAUbWcfpHXThYpHrrlCnAU1RJ6YG8nZp6Hh+FrHrC0DpjDzhlglDTg2C2SoomgwbrnlTFNo1M+xvVXfHjTjH+fmu6U1yDwilME9uuCIeJI3F9cWiHMH0ntiK3HfekEEJs+Pq5gtXo1DIvKBy7oSh6HmRj5u69mzFF2Cih+uWmsME23lR8VVWQtDuqMwVAg1cRsslu+aNvQfc/KXpX+mOU9Nmrszfh1xYxen1mkdx8JRxooQ3u1n49MGRBTjyIGpIrWSyW9tLcHazC2uxJhlBZxr6nOdHjjOkxrqfIj3xS3A9h/Tli+DlqET9T2D7rLm74XhdKeJFE47AIS5JbdZ/EEZmqKedqjLujRkwwaJiF2xkw9IK5WwY/Wkrhn4XzH8f3EvYrONhTzE+OCDv4vinA2uIaY6pn5NRlkkXEVNCcTTk1nDfUr2vM7sK/rXtQBYMlinMF1+E8cWWhGW2RxqGQdE4uMD41untT2EcqSgjeTlS68yZrNUmLD2MZIVPCDC6anVl8T23cfzpPlkUTT2VA2o9s6/5K7ijQOQrcjt8btlZnyBrKayEr0R4b4YEt+9zbDMnkAOHAZ+gi6mSuI+N1EvWGOhTdtxASXT1POzUjGPbz4lPzxjonhxVKdUTXnldNXNAJPPOH3sEQoZfozCML+nlDR+sXmIYKic95AH0jG/01J0H1tCDgjfIBMHorBzu5chYKXznEvH56zNC3C5HJGcciRd9S/hxNk/SZMjxkAhFGR/juetl90Q6ai1bqZQrGRZfdbGEvh98352I6tVCCRW
 Cz8pIdGt
 dWsNBg4amrX0Vmx1QKC1ChH72mSXcMGv/tt8RpLkT228nDPeGrC33/X74NDJkCkXvQ+mdIuBaRVtihhTjlkiw4CoCzGpUhK1LQleIdoPJIjp1EQckH/mvV/5/i70TKP6OHY0bvKXNj3dEZbkX8o1m7HdrABrMKUmc+ILadMaUk4K4g0GTsFx88UU2rUyxf50G1U5inw4rZHDliCnx49fKbIQ38Ms7hLQ7hkoWdDwlz8FCElUe7QAhNEH8CrIfxv5d5SDXtmFlF0jiee5+4PWx+0NdKq4vb2e4aqahl1/mTTncy+tCo8o5vA8xDWszMdlVORDk6H1mzLwMW7TN3XUaoYZBS9kd/OWhU7o4vGkclXJlvEkAHKdBpxdHd3+a4wMnDKKQn2uD1gFZbN2DGBwv/27sz5Qoc+91XSzBeAFrj+f5Awfn6E6UZrz1CApiU0cD0fiizJCuCQYyrOVlOhFLbvjaQrj82iBhoGYzWPM+YDHhWZO7Qb+yvxuuY5G3PUUUFO4Y/SBFMdwCzJveszYXKnvhelsWPiAd8tV2YcPEGSPnbPErzzpfKvRo+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Tue, 17 Nov 2026 06:33:51 -0800 SJ Park wrote:

> > +		if (folio && !folio_test_lru(folio) && folio_test_hugetlb(folio))
>
> Why do we need both !folio_test_lru() and folio_test_hugetlb() here?  Could
> hugetlb folio in lru list exist?  Could folios not in lru list be reclaimed?

Yeah, you're right.  Neither is possible, so the hugetlb check is
redundant.

> Would only !folio_test_lru() suffice?  If so, the patch subject and
> description may also better to be updated.

That'll be better. Thanks for your help :) I'll fix it in v2.

Thanks,
Aveline Noir

