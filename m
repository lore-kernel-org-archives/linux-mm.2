Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8886D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A3FA6B02FE; Thu, 22 Jan 2026 13:27:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451466B0300; Thu, 22 Jan 2026 13:27:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353F26B0301; Thu, 22 Jan 2026 13:27:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21C3B6B02FE
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:27:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E32BBB97C8
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:27:58 +0000 (UTC)
X-FDA: 84360433836.21.676F6B1
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id E46B2A000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:27:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iQj62EOO;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769106477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mouF04Fjg8ir5c/+5/uLoczeIu6+gVBtr+E4eejz/fc=;
	b=IeDBKrcSF/KxVF9oZ2rqalYzKWaZ3fwYlnq4cQUiM/cKMB/WkaupGdWsDe2ZjXomWhf4tt
	Qt0uoM2BqxLXxS42xfM1zCEOaBo2mSogjFRtjujSaUVxMKCXUz4NfRQJIyM6p3rkp8hfax
	FiX7/KL9y6eu47y5vKQIsMjxucwHcPA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iQj62EOO;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769106477; a=rsa-sha256;
	cv=pass;
	b=WXjCekE7f/a5V//6uLEZwbWLzPq5PkFxIsEzS4/45rbxiOUbrzIPx04BUTK8y4M1UAf1f6
	nLiSOsrvoR33Oy4YJz64sEuZNYLStwxNbhPpNryXIUpSvZcixg/2FfB9QLUZOslUTHzi7j
	jYy3ElLx4tm0itqOaoSGoDD4LiO/+yE=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64b92abe63aso2689843a12.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:27:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769106475; cv=none;
        d=google.com; s=arc-20240605;
        b=dD8gLlzSA8fj4c+gsBpn69zDLOdQBC1mDg3UgaGlMDwF9ESMFNs5T/SaKkkFCfipJb
         k4C/dj5yJTMXGLkk2XrBcSiQfoWtw632fhO4XflP1JJUj1WwMSVCcH2zHu9q+ZNRZVQW
         FsTL9Ybb+ebZLmcH0U8OyCf/mstGna8LG/Pqtj4wbSgVFkbCfbGxhm7w5ywz/HVqSILD
         aG+KeVm7VTsJ2aVFVcr0nOSfAI+NndHXtLWGyM46XubD+LyU+et4salgG1LGvcFjoWoh
         K2gef6JOYiU8DdNytNNSe1k2yGaP3HzKJGAoJk3zaU5sx7/bwQuCbCb+LKoDCVj6ddxk
         dYPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mouF04Fjg8ir5c/+5/uLoczeIu6+gVBtr+E4eejz/fc=;
        fh=gaTZ99Yv6GaVV02SfqjIPIc8UvfyZVQFoybKfROMW3o=;
        b=dtz9xaRNe3XwScCvQO8x3vfuXpaATEY2taGyqAnQJdchsKsh5Jyz1cnjIxJnFJwhiW
         rs8nB2SBt7hWxTqxYHoeudtrYe4Oqrb/QQ81RX6OUNd/Won3tytuf0ypytxjZcAmQwAc
         N1uuNAIgeG/Hnj/xekZOhSNngwwSfAVhOKrA7JigIVDGOFKv3tgRBsXqujBE6XvWDzT0
         56+cQQ3X5L9s7qMmob74jzQxb6g4/7TQ0nqu90PnRKt5qDsQrite4V0vkPQplmhTJmwR
         kl4zeFsxos0uo+IXemgmZUCrRgCm1LqWca6P8+qSiCzTs/V4v2YONMkTVDGrWK0aE6/i
         Ko+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769106475; x=1769711275; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mouF04Fjg8ir5c/+5/uLoczeIu6+gVBtr+E4eejz/fc=;
        b=iQj62EOO8h9kFR+jWf3tPPH6ss4sIsfO5QAaCF/uPxAaHHxvRuLb4BIoFvdqUO+mfe
         a+WOlxCC1en4z2HHmDcCXp0EiKIIFV5EwNf0YBT+eTtXnbIw89N2Ti3fjaVWaOJXuzhr
         AxDtyrykiXRV6wUsGVnAUWvBHuAmkp8d0dDgbPiUK0Eb1AGoRdqpU0qbb9WfdPEk8EIk
         HW6roQLvB9nuniXfRn7GMZmgEg+CmVOMtAllXAy3ZHb4hCBNRDtWFum0I7qxifbmscIX
         r9kCNLA08LDQqq3fSouiudA68ow17nHzCMnUWSsbcsVKSp3dz1E9Eg7eV2K2pfp/fAqk
         rj3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769106475; x=1769711275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mouF04Fjg8ir5c/+5/uLoczeIu6+gVBtr+E4eejz/fc=;
        b=sFe3bj0QsG4uZg6FvEiBiMhAtm44wRCd6z+ak0s0mLLHxhkHFmDc+NGwFrZ49RpD8U
         yD6PNcSiayy0o1b0dL7lD+ACsX6wpohRF/AgYUdev+16IymZUHeDCt1Fx7rR7jh7qGuH
         Zw7rdQtwDqzknBDD4I8LzWeC8lzG6iCT3rU2VM0mKuTFjMwL+0sCN5GGk8MtmzXr8/2k
         gYB9rIbaqA8BarmpVht03gYMRNr8wU/gZVzsEPXH6Rp9tfz8c3/y0ROqewpZMfYjQEod
         NbNBFyBHCRemHwRFVppm+zm2kCbh6ouIxf6L3RNaxHQXQ7SihXla7Qom1KzpBYOwkKWI
         uMBw==
X-Forwarded-Encrypted: i=1; AJvYcCXM3MRHMmGnki2ApY/+TDusyohPMMK+nDi+5tN2MojzJN6bq8XcBPJCf65avSB4s/PNVwloAkCFeQ==@kvack.org
X-Gm-Message-State: AOJu0Yym/BgA7XpgTBqRcQBBxcjlDQojEQ/R/DvXDv+FVRyAG/TcYH3/
	otq5o0B+GQcx4OGY/dIp1skvV9cEYYAH9o6LZ1yjS34psc/uLH3Gav8taazPSvLOYmyI9+WTGJX
	qaRLikBUcd0P1R7RpJJJ+eUZR0Q5ajednSIYqQaoH1A==
X-Gm-Gg: AZuq6aKABFsVNKtVUXjz6LwwQGZmP1L3T3yiKu/L1d+ITV7g+Mrj8OkNcAbGtDwPyQx
	miznvqISU6OnOeodb9VRvpfPUvGLQD7FuwBdxiGT7liF0yKzpZlr6XADgUT87aq18s/Ci3/NOOO
	UEmwOHpXpkxqHetthYcIVEZUl4EdY9aBEieOkhhtcmpC4K6th63dNNEo/jqjc2SU+aSsskVcjX+
	0YfsaMrm/YWgiWgzo4nNDPN72vjkWYrpUT5iqSttBpCdQ3dl6oyV7uck2Dgc9pmTOfO7uVqMa92
	czSqqqSkHObUC4WcFvAyDBElCg==
X-Received: by 2002:a17:907:787:b0:b87:bb45:bd5c with SMTP id
 a640c23a62f3a-b885aeea0demr12601766b.58.1769106475582; Thu, 22 Jan 2026
 10:27:55 -0800 (PST)
MIME-Version: 1.0
References: <20260105165839.285270-1-rppt@kernel.org> <20260105165839.285270-4-rppt@kernel.org>
In-Reply-To: <20260105165839.285270-4-rppt@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 13:27:19 -0500
X-Gm-Features: AZwV_Qh5OQxnhkP1BE91ywGY4oJqPabhz38UybbAGCSh0mnJSMFxpX6QR-TTRaM
Message-ID: <CA+CK2bBzv4mLEmFSQszHdcO9x+YJ+UA001KNvS2of8o_Wa6itA@mail.gmail.com>
Subject: Re: [PATCH 3/6] kho: docs: combine concepts and FDT documentation
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Jason Miu <jasonmiu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E46B2A000A
X-Rspamd-Server: rspam07
X-Stat-Signature: 47k1c8iw537rj7unbzj6ndbgzng4jc76
X-HE-Tag: 1769106476-116849
X-HE-Meta: U2FsdGVkX19OTU858h7sDZe+O1HuR7O3cjSK+AmfCffIebmK2BS18x/o8r4vTB6hBIhHL5Afp3qYQyr7osmLeT+4szp8/uFh9wnswp92Fa66SyZFtgYfc+BVBAjlSOs0KZKAKGAUHmfXkj4IVF4zZvxHcDwSxCI2dDw+Y4XcQQh/qbEycz4rCFHxppKy9Nnf1fnvunCOpgsqAMo3LFqIuP+wcCsOGh1lDGorTh+HhJaw2teNMmA7Ye08rFtqvF6zwmLnzgM5Dh9gOobQOqHpf8N4gfrCjjM2+8p5VNLM/gUmDeH5WWTBI976KXDuLy1Xl8o5WjZIAIIIf8IKeE8h51gyOO1TYwS9E2njzLlp3x3oJTSIpRMV3NpRVLiFknKgVG+D46iDrV1vW2zXVjVR7jQvmto9GCREQ7cAEx89O4e88AywSGFDnWHF2VswJuY1M4V7YVyh8DOgfse8Cp1d4ISh1LdxLGP1lql5xQEcDd9uqd3U1GyHRvr6G+EtaSY6dw6joGYrcFn3vJInnu9Oeg5G5zS6m9WV+Kbr5nF2SEBfOHYbxHDLC/U5WEg1YLN4zxTaHUW01Q5eysmZqE+++7VMcredykWey5XqWYswtiE297un7+EM4qnkm20hjc4trnIKcSWMH39bumpsa6JZFOpbqQPGhiwRN/8MAmicXrPuCxnCOKBKTCQOBTvmH6DGqK+Vsjx2kT2F2WtDxtn2guHHUV/KZ+bHUDQJ9pxz1mKX10km2/+HKD3EP+6rvZyOqhyCJ5td9mjhsxaSGdfhmuy+GgL9TVfP+tmwnauDW9NV16kMmZCwOcYLdYQkLK4n9MrOten7hqXliNk5XFPh1TI9gOwKa/neKiXNtiejaRrJSSTQwjRgRjVhbMc8DrFb+t0xB04PwlxqJPoMWB/eqCDyd4eDZFf22uDnmzicDGTNV78m/XFIYR1gDNhsOG5TBA94rKeeu+mngooBsOk
 bRBOH5c5
 evz1U8asbt+arxQDpVfbxlQT73QLOZ+7bWLjy15fu6iZ1MqcU321HrZaP9OGKdQyMzMFNTBeMX2QHkf4P+uspPIGVGtwDnLybZrgqBs8Imn2s89LdYNjRTXQ02JWDMUHzppmq727ziCRw4eXnXe52lzs2ljT3WrEZ/pWAq3K772zzzgjjc+FQlxUnSW4wmgUVdre1KHHA6O4vHKh0UVB4Df7wvTlSR818RIta0UIFYGcUQsbvylMPoTAfh8xJNvnB78ViY1sr4cyFi1uCnjV47wyHS3TR/K1grEzxT6w+ui4cRsBHE86ATeGJT7A3N0bpL7wWbtDZUsf9Xq/EYxBjmapQ3f4a30o3xxphm+vW6qOcC6Xu4Cbyh0CvQ8Q95r5KJLaI37WqsSFB/SsAncUp2xeoWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 5, 2026 at 11:58=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Currently index.rst in KHO documentation looks empty and sad as it only
> contains links to "Kexec Handover Concepts" and "KHO FDT" chapters.
>
> Inline contents of these chapters into index.rst to provide a single
> coherent chapter describing KHO.
>
> While on it, drop parts of the KHO FDT description that will be supersede=
d
> by addition of KHO ABI documentation.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

