Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB304CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 10:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4372D8E0013; Tue,  9 Sep 2025 06:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8C68E0007; Tue,  9 Sep 2025 06:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AFCE8E0013; Tue,  9 Sep 2025 06:08:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 10A968E0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:08:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB97513AF6F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:08:33 +0000 (UTC)
X-FDA: 83869287306.23.6280930
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 96C0D40013
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:08:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XqRLSZMW;
	spf=pass (imf11.hostedemail.com: domain of jgross@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757412511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DiDplQj9hx3PvXah5112bj2kShJJIkIE7dUW74ox+yg=;
	b=nGsMlsropCPhg5X+YXh5Z2HE3jvZYpS0g14zLjK2yl6nmJlBXx3+vd8qJYpoW+No/EfcQ2
	+uKq6ShMXFD2u4kqGwFMr5MqRUY8nNU6GOMik4IpKc2V8q9LWdLVsyQS8tPwdHIU4bPUzl
	hE4U70MIyfWd832lmjsN7UJzxrXXock=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XqRLSZMW;
	spf=pass (imf11.hostedemail.com: domain of jgross@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757412511; a=rsa-sha256;
	cv=none;
	b=SfYDX95rvqg/Ep6XewWF1GdiYjwY39siIo+6jKcXB9BBD5hjezQjz8h3tKBkBVloEfy6jZ
	pVcuXOOlPDrUNQiPysJtE10LOyPe9caHnQWFoTOhTlSFt6cRiNQwiEKTHSy7xkDB/++m0+
	J9N8+vu18yDeFC9D15BsxY2eVytCdhU=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3df35a67434so3394872f8f.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 03:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757412510; x=1758017310; darn=kvack.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DiDplQj9hx3PvXah5112bj2kShJJIkIE7dUW74ox+yg=;
        b=XqRLSZMWeBZTesK1BH3E3UtLQlZkafpjOWE8/wElsNP4ZCuNKgbJkqwO04Gbxh4ZtU
         qKUZVzWuul5aAHgSAROSAquke3fQvJYUIqdQFlR9nsK5BmBkSRlaRwNm3cjmz18P/zDN
         LVdGvuexdzb1CiyBdZT0l2clHIc/oNd8xwIi76JHIJ5bZAvXyW/JDor2Ub/zMMtMv1XZ
         XkTe75Y/VIlLyYaettn+5DEHTA+ZkFy0FQKAQJKsJGA+CPU5CacLNEeF2gKOFmBOkVCB
         8LIGn6JMg22acX2hgmAQPrF/03Z1TDs0n0rrDfM7Lzvqmj8XBMZFLzDMiXv4U3a2IKrY
         tgjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757412510; x=1758017310;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DiDplQj9hx3PvXah5112bj2kShJJIkIE7dUW74ox+yg=;
        b=deypl+yxYSRjyDFs6ktD6AWVSHzGHr2j6N+iE23Jc1r02oay81RV+IkO2FpUVc96Yi
         2gxrrS4ly2FxfbDjGZIlO6Y3e7A27sRQdnUYf7/Z39DQYbyFcOmZKnoB/UbPoqkXZnVO
         AKoBoO7WdL7rTIaXdZVItpRJnYA75OQIWqd/HOxyG8r+ippvzkQ0Dw8JHhgwLKaY/LIE
         kEYgKox3TLUl0y5hEFFQgwMmIzBEn2jRdHpamt9L6uRXM8q+Dvw/kIQhvKcSnvItHWCQ
         QjM1cxBQjCYufb5z+BM3bJLSon85QWzYc4UXL5GwkEqHvZpwWWVkvoOv7MuW4EfbDuIV
         wexA==
X-Forwarded-Encrypted: i=1; AJvYcCWPhg8ZEpgFJpwZQf/rJU9pFwNib/SV47VDkUB7M5RHLA2e0sZB9QHxXhhtWg9+lRq2tdFlYzn7BA==@kvack.org
X-Gm-Message-State: AOJu0YybMP2b/RtjqJdesMFafALVtNC2QXZQj8yltXBcMGx7HPVu7OZB
	3zojVEgOqViYzZDbe37n+jgX+/Bg0adqH13GbaGGw90SsPhi/t9Eu0uFzbqvddhmuW8=
X-Gm-Gg: ASbGncs6a3yiCdDu09eohMmqMJf+pSVECRLdcanX+WZX4tbpjzCuIbs2okvKywItOMj
	b/W8I8u1ZIExpTCgbhG+jV7LTLtK2SO3p+RMh9D/nnsn6aNtiSvDYBKVVWPvbdxWv+c14jumuJo
	acdBP0+HpZnmetMWKDFuuRV7PrZgTDabtrZsCl9CsbzpS3cx/yDW5omdlspDO7geB0uthdASEi5
	9PGTYAUuKQI9GMIq1lZzK24R4Nxvyo/Qfd71OH7HgGEU74rX8qkjUHia79TKnoV8DsQqJIUtLRU
	4QY7RTvJNyJVKzlKGJAh9VvHFXwqKFVTpaAvBRsQ2CSNDal+OIMO/TQckBq1sCLc80MUzWYiruP
	SG4N/ksIE1d2RuYxhJZCYy/VKbRGqwDASZBVH/C+jIMRQ+1GQpz1z3D33I69rnpG2d1hDotO9j9
	iJXTQLhJ4xc/zkaPTxSDXkWwr+kHs0sLGvh1sICOn58/UXegeXSt0A03M=
X-Google-Smtp-Source: AGHT+IEbIOzIcWCGsxFeJqTqswoKzFZU8h5ca9ioFsTGk0plA7q521H22LxnzLsjlklRQdzf2ZNlhQ==
X-Received: by 2002:a05:6000:2385:b0:3e4:64b0:a787 with SMTP id ffacd0b85a97d-3e64392d4b3mr7866480f8f.33.1757412509825;
        Tue, 09 Sep 2025 03:08:29 -0700 (PDT)
Received: from ?IPV6:2003:e5:873d:be00:c26:b971:1ba7:9d8b? (p200300e5873dbe000c26b9711ba79d8b.dip0.t-ipconnect.de. [2003:e5:873d:be00:c26:b971:1ba7:9d8b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9bcda91dsm317709275e9.6.2025.09.09.03.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 03:08:29 -0700 (PDT)
Message-ID: <5b42a1bf-d46f-42e1-90ef-f20d698828f5@suse.com>
Date: Tue, 9 Sep 2025 12:08:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <20250908073931.4159362-3-kevin.brodsky@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------dpEbV9t2uYfrqqebO0e2knsF"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 96C0D40013
X-Stat-Signature: r1ubagb3ybjnt8oxkmmk3zbcu3w74sst
X-HE-Tag: 1757412511-572455
X-HE-Meta: U2FsdGVkX1/VG6+ZZclywIK/JQvNmy5SoCBicvyqC4wn/ZjVVyfi2PxII4Cx8eycW8ALTodd9ufljYxxUYEyzYsykZCpFA2k9fa2tW2V3wVPPt3XzEihxDaSxQhfzLWqINVvnP/i9A0GyUVQPJh8oNHGiZQ8odkEmyFkGqmUeK1ITSV8FbzQJE/jTPSeorzQSQo9Oel9H1xPximHv8Sn9s/+b8cMbqf4Kf4yiEy2wYEQ+ajJ3b4AXFjfX2qmsEOZ+l2idqAwZfKSvblVaDLHFn94KXKzz4IpFs8evrHpqx3ngJOvqDUD2E7qTSwbluBvdwjaoc9ZAIAsQZXwgPTV9ly67HFaXWzj+KPDIar72X94fxlQOWJXmyUlwSJivkDH/i/imq1sUH+pMGx6TOufw/QlmcpA6aUN0TwcJTCWArKaevwdGQmBrqcStQ/e1N3Hzm2dFVhdrASlGh/lg04GRhVNJhpN34gfJy7lV/DAXtl54KaWIyAaHLQvmKBK3PqT//oMhalcd1YF+yDgUFkoS5OnAX1kbpaLT/2n2K9kN66S71HfJ9S2HxR7rfY/J65kqsC+nxeW1DcZa/RStMbNWWfIM9ZWyo+uaRNz3ItkMjxDLndHAVdFoRG133vsCmAuFqcAjpSzMn8xAczQCFAPTsmAw3OfoCTPd8gajqX7uHKlNz2YYI9nvS8sIIy4noz6RKDUEsyQKoW364JR+bys9thigzbXB3o16RLWYGZVDxZllP73L3pmeX1PQKqBb9sCXeRGNcW+6eQAxkbqLknb1ELXS822tkscczQ0l3PJBS/cpWWJG4OiBs/7FBbcBKkvhUkAoTFAuPdhNSX3AsJ9rq7zigepzSaKw5f23mX9p0N6iDX89d8o18sfFo1SuPbIO17Qk2t2Mtev8BwhtfiHRDlCWng+HWbcnxjn/6dwkQtJyYgxIRO1VYXCoLzr1gfn+WOqev7/WR5btGpYOe8
 xm/oBPDM
 Ut9vXOo3ocmDRH1maSMuqGVY7MUydwnbwHjDv0uTFT1rda4BBo3mMhVzqwQM7Ayud/ixixwwZktR6u1ruhrbQLo/3niI3HlQFyfvBXvVYKbPssRVKnbk0bwZ+4xtBcmMHMnjIS9hlihAOYnB3vLU637TVHu7dLob9TMlTX2zI09V36eMZEbr59M/tnV36kUbu784RdoxNKhTMllvWMXiO5eU141bzv76ekNemWnJC8BGHWXdBr7SZZbRqoBqPuKhliS4KuWWp6mJ3kX2o5J9mk/iAVoRZTkxzJGZ5WImjDapOFq4BhyUFs1PyHkwXpT8SC4HS1YxeZsrDq3ZyQezQch2NF61Vcg078Ivh0j7wMAr1m2zv+OLNyJM6snOZu53a15zH2A4ct381VgyE54SXfEMNYVDFlDWLW+Wlx4ipg6Lvof/PCRH57pH6O2Y7FUEGeDj2hBTn69IDuIa/5SIxEFCR95YSlwDoYZmqq0y6/fcmMHQ0c0DfEdd+m6E9NryQ/1M7LTd5pUQGtMUXlNyd6aqUQJEt2ib0gz5++eejqQcH3nQ/ggeD1fjvDAW5DqVkIBCv8yTrdKxpIYsWMiR/oTvQBiDjB2E/57q1vWw0SQlBb27xgY8PHrGkM/d+r5aSuxktBfY3Cz7uS4fn2nAs80SWXkJYdU8kBqx6iKXiT0xkPQWY/2r98m+tsGXPAA91hPwF0CA01w2FK3meJ+G7tiGkkFp1YfQWtCnNbZmG+Qdw7JYQ8T/t9vVe8dfiiLABrCPlk3ap1vJPu0Dplus9RIae9S9Cup8Q0I03W2mS4U7NqpVcsSMgn0SmZkoGZYDmCJkWkJA/KcGdjRYTKbAf1Xcks0fDRtlF7ztVXzUUJRV9P44MEMLWLKo/9zLDHFvHqNpYSwCrBk3XulGR3IjLwAr2aRV5Ep34GQUvWLpfdkQEZ46617UczpiwHSODNzNlmOOTWXnhMP85TRDFPZ+8a0KU4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------dpEbV9t2uYfrqqebO0e2knsF
Content-Type: multipart/mixed; boundary="------------5pXmA0RBOYXCBdtoZQDsU4Hn";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
Message-ID: <5b42a1bf-d46f-42e1-90ef-f20d698828f5@suse.com>
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
In-Reply-To: <20250908073931.4159362-3-kevin.brodsky@arm.com>

--------------5pXmA0RBOYXCBdtoZQDsU4Hn
Content-Type: multipart/mixed; boundary="------------l0nheg3mWWAbvEJzY7GAPskH"

--------------l0nheg3mWWAbvEJzY7GAPskH
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDguMDkuMjUgMDk6MzksIEtldmluIEJyb2Rza3kgd3JvdGU6DQo+IGFyY2hfe2VudGVy
LGxlYXZlfV9sYXp5X21tdV9tb2RlKCkgY3VycmVudGx5IGhhdmUgYSBzdGF0ZWxlc3MgQVBJ
DQo+ICh0YWtpbmcgYW5kIHJldHVybmluZyBubyB2YWx1ZSkuIFRoaXMgaXMgcHJvdmluZyBw
cm9ibGVtYXRpYyBpbg0KPiBzaXR1YXRpb25zIHdoZXJlIGxlYXZlKCkgbmVlZHMgdG8gcmVz
dG9yZSBzb21lIGNvbnRleHQgYmFjayB0byBpdHMNCj4gb3JpZ2luYWwgc3RhdGUgKGJlZm9y
ZSBlbnRlcigpIHdhcyBjYWxsZWQpLiBJbiBwYXJ0aWN1bGFyLCB0aGlzDQo+IG1ha2VzIGl0
IGRpZmZpY3VsdCB0byBzdXBwb3J0IHRoZSBuZXN0aW5nIG9mIGxhenlfbW11IHNlY3Rpb25z
IC0NCj4gbGVhdmUoKSBkb2VzIG5vdCBrbm93IHdoZXRoZXIgdGhlIG1hdGNoaW5nIGVudGVy
KCkgY2FsbCBvY2N1cnJlZA0KPiB3aGlsZSBsYXp5X21tdSB3YXMgYWxyZWFkeSBlbmFibGVk
LCBhbmQgd2hldGhlciB0byBkaXNhYmxlIGl0IG9yDQo+IG5vdC4NCj4gDQo+IFRoaXMgcGF0
Y2ggZ2l2ZXMgYWxsIGFyY2hpdGVjdHVyZXMgdGhlIGNoYW5jZSB0byBzdG9yZSBsb2NhbCBz
dGF0ZQ0KPiB3aGlsZSBpbnNpZGUgYSBsYXp5X21tdSBzZWN0aW9uIGJ5IG1ha2luZyBlbnRl
cigpIHJldHVybiBzb21lIHZhbHVlLA0KPiBzdG9yaW5nIGl0IGluIGEgbG9jYWwgdmFyaWFi
bGUsIGFuZCBoYXZpbmcgbGVhdmUoKSB0YWtlIHRoYXQgdmFsdWUuDQo+IFRoYXQgdmFsdWUg
aXMgdHlwZWQgbGF6eV9tbXVfc3RhdGVfdCAtIGVhY2ggYXJjaGl0ZWN0dXJlIGRlZmluaW5n
DQo+IF9fSEFWRV9BUkNIX0VOVEVSX0xBWllfTU1VX01PREUgaXMgZnJlZSB0byBkZWZpbmUg
aXQgYXMgaXQgc2VlcyBmaXQuDQo+IEZvciBub3cgd2UgZGVmaW5lIGl0IGFzIGludCBldmVy
eXdoZXJlLCB3aGljaCBpcyBzdWZmaWNpZW50IHRvDQo+IHN1cHBvcnQgbmVzdGluZy4NCj4g
DQo+IFRoZSBkaWZmIGlzIHVuZm9ydHVuYXRlbHkgcmF0aGVyIGxhcmdlIGFzIGFsbCB0aGUg
QVBJIGNoYW5nZXMgbmVlZA0KPiB0byBiZSBkb25lIGF0b21pY2FsbHkuIE1haW4gcGFydHM6
DQo+IA0KPiAqIENoYW5naW5nIHRoZSBwcm90b3R5cGVzIG9mIGFyY2hfe2VudGVyLGxlYXZl
fV9sYXp5X21tdV9tb2RlKCkNCj4gICAgaW4gZ2VuZXJpYyBhbmQgYXJjaCBjb2RlLCBhbmQg
aW50cm9kdWNpbmcgbGF6eV9tbXVfc3RhdGVfdC4NCj4gDQo+ICogSW50cm9kdWNpbmcgTEFa
WV9NTVVfe0RFRkFVTFQsTkVTVEVEfSBmb3IgZnV0dXJlIHN1cHBvcnQgb2YNCj4gICAgbmVz
dGluZy4gZW50ZXIoKSBhbHdheXMgcmV0dXJucyBMQVpZX01NVV9ERUZBVUxUIGZvciBub3cu
DQo+ICAgIChsaW51eC9tbV90eXBlcy5oIGlzIG5vdCB0aGUgbW9zdCBuYXR1cmFsIGxvY2F0
aW9uIGZvciBkZWZpbmluZw0KPiAgICB0aG9zZSBjb25zdGFudHMsIGJ1dCB0aGVyZSBpcyBu
byBvdGhlciBvYnZpb3VzIGhlYWRlciB0aGF0IGlzDQo+ICAgIGFjY2Vzc2libGUgd2hlcmUg
YXJjaCdzIGltcGxlbWVudCB0aGUgaGVscGVycy4pDQo+IA0KPiAqIENoYW5naW5nIGFsbCBs
YXp5X21tdSBzZWN0aW9ucyB0byBpbnRyb2R1Y2UgYSBsYXp5X21tdV9zdGF0ZQ0KPiAgICBs
b2NhbCB2YXJpYWJsZSwgaGF2aW5nIGVudGVyKCkgc2V0IGl0IGFuZCBsZWF2ZSgpIHRha2Ug
aXQuIE1vc3Qgb2YNCj4gICAgdGhlc2UgY2hhbmdlcyB3ZXJlIGdlbmVyYXRlZCB1c2luZyB0
aGUgZm9sbG93aW5nIENvY2NpbmVsbGUgc2NyaXB0Og0KPiANCj4gQEANCj4gQEANCj4gew0K
PiArIGxhenlfbW11X3N0YXRlX3QgbGF6eV9tbXVfc3RhdGU7DQo+IC4uLg0KPiAtIGFyY2hf
ZW50ZXJfbGF6eV9tbXVfbW9kZSgpOw0KPiArIGxhenlfbW11X3N0YXRlID0gYXJjaF9lbnRl
cl9sYXp5X21tdV9tb2RlKCk7DQo+IC4uLg0KPiAtIGFyY2hfbGVhdmVfbGF6eV9tbXVfbW9k
ZSgpOw0KPiArIGFyY2hfbGVhdmVfbGF6eV9tbXVfbW9kZShsYXp5X21tdV9zdGF0ZSk7DQo+
IC4uLg0KPiB9DQo+IA0KPiAqIEluIGEgZmV3IGNhc2VzIChlLmcuIHhlbl9mbHVzaF9sYXp5
X21tdSgpKSwgYSBmdW5jdGlvbiBrbm93cyB0aGF0DQo+ICAgIGxhenlfbW11IGlzIGFscmVh
ZHkgZW5hYmxlZCwgYW5kIGl0IHRlbXBvcmFyaWx5IGRpc2FibGVzIGl0IGJ5DQo+ICAgIGNh
bGxpbmcgbGVhdmUoKSBhbmQgdGhlbiBlbnRlcigpIGFnYWluLiBIZXJlIHdlIHdhbnQgdG8g
ZW5zdXJlDQo+ICAgIHRoYXQgYW55IG9wZXJhdGlvbiBiZXR3ZWVuIHRoZSBsZWF2ZSgpIGFu
ZCBlbnRlcigpIGNhbGxzIGlzDQo+ICAgIGNvbXBsZXRlZCBpbW1lZGlhdGVseTsgZm9yIHRo
YXQgcmVhc29uIHdlIHBhc3MgTEFaWV9NTVVfREVGQVVMVCB0bw0KPiAgICBsZWF2ZSgpIHRv
IGZ1bGx5IGRpc2FibGUgbGF6eV9tbXUuIGVudGVyKCkgd2lsbCB0aGVuIHJlLWVuYWJsZSBp
dA0KPiAgICAtIHRoaXMgYWNoaWV2ZXMgdGhlIGV4cGVjdGVkIGJlaGF2aW91ciwgd2hldGhl
ciBuZXN0aW5nIG9jY3VycmVkDQo+ICAgIGJlZm9yZSB0aGF0IGZ1bmN0aW9uIHdhcyBjYWxs
ZWQgb3Igbm90Lg0KPiANCj4gTm90ZTogaXQgaXMgZGlmZmljdWx0IHRvIHByb3ZpZGUgYSBk
ZWZhdWx0IGRlZmluaXRpb24gb2YNCj4gbGF6eV9tbXVfc3RhdGVfdCBmb3IgYXJjaGl0ZWN0
dXJlcyBpbXBsZW1lbnRpbmcgbGF6eV9tbXUsIGJlY2F1c2UNCj4gdGhhdCBkZWZpbml0aW9u
IHdvdWxkIG5lZWQgdG8gYmUgYXZhaWxhYmxlIGluDQo+IGFyY2gveDg2L2luY2x1ZGUvYXNt
L3BhcmF2aXJ0X3R5cGVzLmggYW5kIGFkZGluZyBhIG5ldyBnZW5lcmljDQo+ICAgI2luY2x1
ZGUgdGhlcmUgaXMgdmVyeSB0cmlja3kgZHVlIHRvIHRoZSBleGlzdGluZyBoZWFkZXIgc291
cC4NCj4gDQo+IEFja2VkLWJ5OiBNaWtlIFJhcG9wb3J0IChNaWNyb3NvZnQpIDxycHB0QGtl
cm5lbC5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IEtldmluIEJyb2Rza3kgPGtldmluLmJyb2Rz
a3lAYXJtLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNl
LmNvbT4gIyBhcmNoL3g4Ng0KDQoNCkp1ZXJnZW4NCg==
--------------l0nheg3mWWAbvEJzY7GAPskH
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------l0nheg3mWWAbvEJzY7GAPskH--

--------------5pXmA0RBOYXCBdtoZQDsU4Hn--

--------------dpEbV9t2uYfrqqebO0e2knsF
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmi//JsFAwAAAAAACgkQsN6d1ii/Ey/C
1wf/cnsOcbouTosXpOkMhBjr243f1nECaiPmx1oWx83zmSC4SlVt0VJFI2hpjqlZZn3kk+T+f/BY
riH1vti+7aji2EwTeUjuL+sruFDv5+lCOefk6+b46OZl2eNVp8VbrcgJzJ6kv6KhdqWIaK9xQg5E
y78GsOvALgfkC9dMGlo3V0JpBT/NhIqVX0CkLTytEiz6z4/WyGI49id3c1cDHnLo4umVXEElO7Rb
LFId0sWhskdjaRvSWuUHTzL9F8u0j0NAwfiI4CZUIhTmeuOnhk9p6MM3dso8MBODi0QhzlxCbFUn
PT0KWq6tyl6iW7RcH025OPh/I+hvKsP+LkQeTxcTXA==
=nAef
-----END PGP SIGNATURE-----

--------------dpEbV9t2uYfrqqebO0e2knsF--

