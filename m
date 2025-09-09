Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA79CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C958E000F; Tue,  9 Sep 2025 05:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D018E0006; Tue,  9 Sep 2025 05:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15CC8E000F; Tue,  9 Sep 2025 05:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 86EB58E0006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:42:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D2FD1A03C2
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:42:07 +0000 (UTC)
X-FDA: 83869220694.16.9C4E5E7
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 36C86A0011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:42:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=c4buSedH;
	spf=pass (imf15.hostedemail.com: domain of jgross@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757410925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SjRoDXFIQA5duWfB2MZCu0jToXiY+NtBhO/biBCm3yY=;
	b=SAfF5WwhdHEgEyze786LMmcHpeTA9V9TyBTkR9onPe+Uic4bjfTCmIoWnQ9U9it6ixCHwl
	Pqxkzv01+b0+jMECcl7VR8ODE8LQ4jZjaQ8Sh+bNvGUPly62tK9BiclDnqTruN8795Xivw
	nfbOQJzd+NTGfRYQ/PbVHfrpCG3L98E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757410925; a=rsa-sha256;
	cv=none;
	b=UwqKpxB99QrihuUpvfOVB1zNMeg/ehe3ZDO33mrl7ys8XHPi9Ny73suMxH0DmnZRpWt5iM
	8dthhvemQ0wXd1SLmj3jK8TOIMpds5I6Vhzbts0BbBYeKgqp6XqhyQXU89PRQmFQX9ZDTo
	0UUHhQEqF6eT5+NbYlS+wYKgR2cW3VI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=c4buSedH;
	spf=pass (imf15.hostedemail.com: domain of jgross@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45ddddbe31fso18397735e9.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757410924; x=1758015724; darn=kvack.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SjRoDXFIQA5duWfB2MZCu0jToXiY+NtBhO/biBCm3yY=;
        b=c4buSedHz2lpuw5lMVpk70kDmB6eMIj1Wn3QMWkAhSNDRAhkOeDaB7713PCaNq/7iM
         29qzhL7C1TWjOZoEXBpQkMRoC5QYy0bKDdjnHkJvJAUcP4bqsdaxcyGmSSnzYdEwZPhV
         FTbLmfkP2WWU7sn28CvP7HgS+HOOBlQFvEr2EleFkdHMjQcr5im3YhwwPZE19tRhYwTQ
         NPLPs5a5LnUQJEMlWj5T+K/xIu/gJXu/RJfRflicKy+B0n0zkdqusNjC+IHabzqMLUOo
         2KutDc/YwH8pNNTlmkg0swtq0KafAK6vWDMHN5kg2VfliTx3CdwcfYWJQfCHADXEB/Kh
         tbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757410924; x=1758015724;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SjRoDXFIQA5duWfB2MZCu0jToXiY+NtBhO/biBCm3yY=;
        b=pYZInvb5naBFoJJ3kPw99UViN5jUVKIKs5N5mTFIc10wW9/vAPBpx/26AD98xKqHe2
         irdcuQT31AKTXPyyTtQyTXKuVeoL/mzewmvnh4aKB0nNez0Y3gdSP/SyTLUoSK+yTqrM
         ltazyjO2KEQqln9yIoHi0iTItXe7KjhX53+JgXd8XYNjvCtaP1EPu4sk7SiOIm2RCi6j
         Hk66OyOAvFEtyBPlkbLmTVPT3a9LtXq6Nz8jlcJdbQhTkxuOOtCnQ6do/zTMF3Y7W23A
         UJt0Bpsf7e0+NHIVZpMneMc2s23LaLmxFhOoaNwsIJc9Dg9nfvbxbZv86D/l5fgxR8Yh
         67Tg==
X-Forwarded-Encrypted: i=1; AJvYcCV7t+w5dM8LeWmY13heOFQh9MgYe9nf1lgJi97s5Ih7pr7nLb699Y/F8SYcnNuwoJBCZKaCkxpM2g==@kvack.org
X-Gm-Message-State: AOJu0Yw1P2ZzWQdxk8424Lhbl+qSrbu5q7JRpQ+CRoFnF/rKMlz+vNz+
	v4BB4XNNt9A1nE2aQKqHhIcPnMiANYui7Fr7U4cT1VepnMspf/rWVk9rzKBMknOZjak=
X-Gm-Gg: ASbGncvXpn5fQocS6RqZbjV6S+gHoduIzpmE7UZN94vRWc2cSQ+asaNOi4g+sMOevUg
	dOymcJeFwOgpZS0b87QtIR6Dq6bayCisOBduX3MNzfFFLc8mPvZuBgSugdVdMnTrIABF0U+zkhH
	eXjo8hhQefJ53KuXdduI0iPOxAOlq4wglUEinRRSiBv1g7/eelc7kr0NKUEwY0D4ipdNH/MLnNh
	pl4Wp1YeBEI7qsSKGF08fDu537bss9V0C/EIeF8vzbTq0cIVOvZC6SbRtiKOl3tfenSiT1cTjTg
	HcZCUpjIwEs4QuUWZ2aSuPAElTpQQomDJltWKctqgiu3Ub1n6R1BeUaXp1wmJkONE2znW6DZjCq
	kX4DB+BSilOzv867mE9XNFGZ2dF3YhP/yMUxjqI2B0D0wU1gZHgATsXjuDUXT/JA4mF8so+X5TP
	O3TPNTaEqCGSRL7P9/nKivzMLqWL2O0XD6eeWNy0g2AS/7SznRFWybZrw=
X-Google-Smtp-Source: AGHT+IENj+1E2T8r/gDXDQF+CsCcmRvQT/1w4yxsS7gi6iQW38MFrgfpZ1CxcgavO4g+sqDlHTXLsg==
X-Received: by 2002:a05:6000:2c0d:b0:3e7:441e:c9e1 with SMTP id ffacd0b85a97d-3e7441ecde8mr6021132f8f.18.1757410923604;
        Tue, 09 Sep 2025 02:42:03 -0700 (PDT)
Received: from ?IPV6:2003:e5:873d:be00:c26:b971:1ba7:9d8b? (p200300e5873dbe000c26b9711ba79d8b.dip0.t-ipconnect.de. [2003:e5:873d:be00:c26:b971:1ba7:9d8b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e752238832sm1864553f8f.31.2025.09.09.02.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 02:42:03 -0700 (PDT)
Message-ID: <a23237ea-5b29-402f-850c-743e106e5f7c@suse.com>
Date: Tue, 9 Sep 2025 11:42:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] x86/xen: support nested lazy_mmu sections (again)
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
 <20250908073931.4159362-5-kevin.brodsky@arm.com>
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
In-Reply-To: <20250908073931.4159362-5-kevin.brodsky@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------6t70nAkYkpQ5fhIc00dD9qVa"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 36C86A0011
X-Stat-Signature: znp6jqoqmhtib8uzjg8bq9ium93pop9e
X-Rspam-User: 
X-HE-Tag: 1757410925-874644
X-HE-Meta: U2FsdGVkX1+vi1kTOMfCqTvgiXbyePcKP2Xvb7pFGdcSOg8H6krhfDFedNK3E4xMwgJJUYGNEwVlDTy/8mLXG4PapSFdbIddLY8GfN+VN60zzPEJ4qzOzapjina4mEjW1WzogU6D4iTBHMVLXPRtQKOOpMDrPDst01mdku4Dg5O9dCgDkbO85uHWlScyAh1S8obHJQmiR8SBwYrgyifREks6zjeWkXNYHIANDlytwwW7kVGeQuU0TqAyljtzCbqKmEEAfa7fAIh2uEvHZLaYVXoXk3dbojfgUAHlN9E1u3Gmc6k6+sD2K66UFPm8FaH2ZXiqtNW6Di1ibXuP7Mtmfkdd0wdYrVQBldFnIK3IjnisIh6RxJu/BJfpi7eDKnzMovFi8g6oF9P+Qv+F93pVKqSJPzTt2FkJC8PC6RCKCRRgnBueWkJtLKHGxRsDv39X6jiFRbV03XJZNWnENVhRfgrNT6200ndu1qNQT80JfrdvTn1QfW5HX/87Ian+nPvzEOeM/9FAosYOH7TUhR0VqfsIKZo+omvFg0DXvgq8uy7+CI29UreWkSsgl+7NZR+/0fvP5gTLhi/nEzUgLg7a7Fo9FzF2Ew23ahjP81DoK3dyMxpDgzLfzVNLHlg0mdLghg07AtXHUQWdE2rcVuQJIyzJpn/HYvq4/rDX3IFFCqe5BCjKs8jUciURJXz9it10nAMLuqVL5lX8I4zdbwAh7jYoMvU+vH5j3/X7Mgmi+L4M/WtflzPQsw9ct2HwNdeYZQ3V+UN+7Opz8zSyHVVNMsfF6vSr/qDNdL9EKx8bQgj300CuyEgjiVnEJYSSddA0H+L1dMcUxN+pfB7ctRJYovVdRNzC+focyVoi+tqibPcgOLw0nkqzSqmer1q3nU70YdSSa1gaVkCA2swnqZhVN4ctySaOjTtDqEY4a1VA3PQQG+Z/tXLrGz1KjLRgmMwnbpwGaU3ysCXiFJIuxwv
 vR5t0QEx
 7o57MXg83oTUH6kgy/8b418VkrF57J3F48ADUH8HG0GwvZP0NbBUWmpIS0JMQthf30OToQN8LA6wd6tScEiLbbGb+g2TCDFhHiCQbdTmSydcqBriNnJ24YSCVtryxH6om8Z6mfD6MPxpWrtdr+Y552CUUCHb98ayKTsG4hKioX5wwk7NxpyHN4CsIu94L7fbRE+VgVhGNTQMYaTVvjVDltxw4jX1Gg+//7INlsFXkVbZQ/0D0EE4tvzKF+y8YnuD7va5/F8pkhDUczyJWx/TSRkkH05dIjETFeTWKhc89fDs/UzanuAdXm5r1NDFm8zappUjqQs+Sm4PC/WCxW45OL9EHNFq26pv6FpydiHtDGQ2UO4XmCCk3nrhSrJ0dSr49PfFdfJVxQtvkOBQqRYqSoaWm2n/0TO1ApEya4LmjUC7wJGHuv2bGIzp9mTCxzmSiXNaAfEZ9yk4NJNk6tLOQRDCauGI8S1Qs8U+S6VF5fAGGeZULAwtGqTlqnxT6Nk/c7nyGNP3mbbwsANBE1pYkYhs5vWWfh0VyMGFNhk4BwyLhEip7mQpAl0KKAWWUy3LAnKM4R1XekGKgAfTZHTDQ0AloTUfuipRjG2Q2jFXvKD+VQOJQs4+L2NGPt6BM8o7uoa4RXVYiLgFuGwv4I+1LVERvMXZ+bHuYClpp7B3BZEBl5uW+OhjY4W9w8MAohoPoKzLve4qq2e7+50ucBLGbJPDW44qUcK8o/b+WKm6OfAS7bk9TCy0XafMOmKkOU8dCkwK6NFsFhj3WWN5MrzW4ClW5OXiQeqgUioR9aMVc5vHVXzXpdu1LvJd2NCkgpbwGGPajWBkTv0+7qEOvHXxwAaBK968EbAM3igQEzPKnwWwD58MSYncYtgJtEESryVvW5OnTqZnM1ZYPqrSeHWjFYqXrzInaQvD8YzEprCnh3pr2QAB4Enu/kfaltPYwpW94Z6cD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------6t70nAkYkpQ5fhIc00dD9qVa
Content-Type: multipart/mixed; boundary="------------0NiQUpv1CWC70bbdwQmMvvwT";
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
Message-ID: <a23237ea-5b29-402f-850c-743e106e5f7c@suse.com>
Subject: Re: [PATCH v2 4/7] x86/xen: support nested lazy_mmu sections (again)
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-5-kevin.brodsky@arm.com>
In-Reply-To: <20250908073931.4159362-5-kevin.brodsky@arm.com>

--------------0NiQUpv1CWC70bbdwQmMvvwT
Content-Type: multipart/mixed; boundary="------------4l0ODE8pZhEM8pbolfSSghyw"

--------------4l0ODE8pZhEM8pbolfSSghyw
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDguMDkuMjUgMDk6MzksIEtldmluIEJyb2Rza3kgd3JvdGU6DQo+IENvbW1pdCA0OTE0
N2JlYjBjY2IgKCJ4ODYveGVuOiBhbGxvdyBuZXN0aW5nIG9mIHNhbWUgbGF6eSBtb2RlIikN
Cj4gb3JpZ2luYWxseSBpbnRyb2R1Y2VkIHN1cHBvcnQgZm9yIG5lc3RlZCBsYXp5IHNlY3Rp
b25zIChMQVpZX01NVSBhbmQNCj4gTEFaWV9DUFUpLiBJdCBsYXRlciBnb3QgcmV2ZXJ0ZWQg
YnkgY29tbWl0IGMzNjU0OWZmOGQ4NCBhcyBpdHMNCj4gaW1wbGVtZW50YXRpb24gdHVybmVk
IG91dCB0byBiZSBpbnRvbGVyYW50IHRvIHByZWVtcHRpb24uDQo+IA0KPiBOb3cgdGhhdCB0
aGUgbGF6eV9tbXUgQVBJIGFsbG93cyBlbnRlcigpIHRvIHBhc3MgdGhyb3VnaCBhIHN0YXRl
IHRvDQo+IHRoZSBtYXRjaGluZyBsZWF2ZSgpIGNhbGwsIHdlIGNhbiBzdXBwb3J0IG5lc3Rp
bmcgYWdhaW4gZm9yIHRoZQ0KPiBMQVpZX01NVSBtb2RlIGluIGEgcHJlZW1wdGlvbi1zYWZl
IG1hbm5lci4gSWYgeGVuX2VudGVyX2xhenlfbW11KCkgaXMNCj4gY2FsbGVkIGluc2lkZSBh
biBhY3RpdmUgbGF6eV9tbXUgc2VjdGlvbiwgeGVuX2xhenlfbW9kZSB3aWxsIGFscmVhZHkN
Cj4gYmUgc2V0IHRvIFhFTl9MQVpZX01NVSBhbmQgd2UgY2FuIHRoZW4gcmV0dXJuIExBWllf
TU1VX05FU1RFRCB0bw0KPiBpbnN0cnVjdCB0aGUgbWF0Y2hpbmcgeGVuX2xlYXZlX2xhenlf
bW11KCkgY2FsbCB0byBsZWF2ZQ0KPiB4ZW5fbGF6eV9tb2RlIHVuY2hhbmdlZC4NCj4gDQo+
IFRoZSBvbmx5IGVmZmVjdCBvZiB0aGlzIHBhdGNoIGlzIHRvIGVuc3VyZSB0aGF0IHhlbl9s
YXp5X21vZGUNCj4gcmVtYWlucyBzZXQgdG8gWEVOX0xBWllfTU1VIHVudGlsIHRoZSBvdXRl
cm1vc3QgbGF6eV9tbXUgc2VjdGlvbg0KPiBlbmRzLiB4ZW5fbGVhdmVfbGF6eV9tbXUoKSBz
dGlsbCBjYWxscyB4ZW5fbWNfZmx1c2goKQ0KPiB1bmNvbmRpdGlvbmFsbHkuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBLZXZpbiBCcm9kc2t5IDxrZXZpbi5icm9kc2t5QGFybS5jb20+DQoN
ClJldmlld2VkLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+DQoNCg0KSnVl
cmdlbg0K
--------------4l0ODE8pZhEM8pbolfSSghyw
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------4l0ODE8pZhEM8pbolfSSghyw--

--------------0NiQUpv1CWC70bbdwQmMvvwT--

--------------6t70nAkYkpQ5fhIc00dD9qVa
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmi/9mkFAwAAAAAACgkQsN6d1ii/Ey80
SAgAiJl65x111bqE27qLDXwGxB+GHINdgm+I0ml8OZ3XtcdZfY5Bn8HD+AFRa9lSJsdUCcklLH88
S/XTNIYun/KfdgyVrC8qkhA6upKCQ0rpmnpVnLRbhGIAfdA1IzOEVv2DasQOSUIW2FrnDMHnIM5j
9+GsXLikB0D+M5Sev7kMHqH0v6VpecDZxbEu6/sLpb/M/HFFLElALOu7Hyc50kf9HcdEFGeRGWGS
zeCAhFKiMqstJpK5XcvR/Gt9WVh9pNNhIyYYHfDfImt28tyiC90MYW+bnoykmn4S2v3yVQOo5qbZ
Ejwt4zi2ksSSuPgsa0AerARvR/6wjZwPfi35XC3Gfw==
=Ew/s
-----END PGP SIGNATURE-----

--------------6t70nAkYkpQ5fhIc00dD9qVa--

