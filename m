Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7869EC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 14:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E44CA6B00B7; Thu,  7 Aug 2025 10:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6A86B00BB; Thu,  7 Aug 2025 10:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96AE6B00BC; Thu,  7 Aug 2025 10:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B74126B00B7
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:41:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36C10116D71
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:41:01 +0000 (UTC)
X-FDA: 83750223522.21.7763595
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2826E40009
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:40:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Af8uHDom;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of jgross@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jgross@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754577659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNvtAxmLROgNUzbc11bBNIMDhX3I5pMyJHrrae5iWIY=;
	b=6I5xHhNvKe/6R+/uFve6jP7r0xXT17dH4ZWyH39CpqCJ0IC13Bsas843sUp5oXFLSfxoYu
	kByIi4XBkj1z0TMW3ieRCc8ktLq8wTSV28r1Md+TNbA1X/gkCjFaJqbhs0zJXc/+9KAWJk
	BYgX7VeKHKfQWzfqn1gwfIbCY6Ms9FU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754577659; a=rsa-sha256;
	cv=none;
	b=qI+WiVAjVTA8In8Mi4zUtXcvMi3pWLOWscKGKRruYZAj+TiBDws+WVxsrOdQhRZZoCt8/U
	iJLzuNwNWJnAXhlLbKNcw0IhE46UJwQsZllOXMpOTk+EBwVYCkPTvO5UE5WtNOpLwwq4bi
	WGMMuQbYuAm3vQ9wjKYuwUhJojbWuV4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Af8uHDom;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of jgross@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jgross@suse.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-451d3f72391so9400385e9.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 07:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754577657; x=1755182457; darn=kvack.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UNvtAxmLROgNUzbc11bBNIMDhX3I5pMyJHrrae5iWIY=;
        b=Af8uHDomXOWG/GO4JY+Cfs5XAvpdD+scqWukQJqK2AGSYa9YKF+e21BKpzYi2uWQ/e
         9gb0k83zdLonsmsn2raGBYOS5+8vTGjuP+sN9T4IxO+FczBu1/SBciFbYkX8pr6+MB+8
         5trD759iCwxSMAZ8Vp0cYzRRHZ24+zj4IZI2fPL+N0ExfJeW9O6ckXbBIfD9h8oFtdMN
         +aybGbid++754nM4iADNFSLf1PIZGkNR9zIIMcvhKT3cOWMV/7K3uaAeZO+gnUP2tBmb
         QYwCt8QJhcVL22DGA0Gut6mSkevXKDUcUP7CPC/vexdwo1yw4qyWPHbWqZ+MbSds/LqO
         fRJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754577657; x=1755182457;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UNvtAxmLROgNUzbc11bBNIMDhX3I5pMyJHrrae5iWIY=;
        b=b37gUg4V9jOd4mGDVNRpo2xBrIUJRpMZbGdZF42KfchLAcmuDHUb3patxC+Y+PCmil
         dAafUCOFl4p36O1o/TrwyGXMXYdUUWIRKagPolQ4ans8OeY7/QeHshZWklnS4yOLTasm
         HlwJxQJ7V3QYM2IOaC0JCDumziC/Wqsfxny+pRMngo5lTXO6C63CEEXffG+XNBNweP8y
         HZaRdVwo5GojbzQtJDtBYW1qdNGUiulNXgqKBQsBMNqPzZFinGh6R02zGJg06R8bX7AW
         RFUJ9BZLhTTIpxYzzDW4r0EZACeotQx5LCtxfwxRxztTbwN6viFDV1QVz+AQcMOOKo1Z
         UKfg==
X-Forwarded-Encrypted: i=1; AJvYcCXzzEYT8IMAwAbZ5dcMVJsmYI/SldCkGm7zqdJJ2io1zzGgmABCFLzRn5whe9fgEtxmCo2VIjNt/w==@kvack.org
X-Gm-Message-State: AOJu0YyktkGs4DI+dWgQZzOWXxh8aparXXKtdSCfqB+LUU0iUKrf6WuY
	6G3hiHWegZCaGZpNoAkjlgSjfXDCoRjGZQXYxzV4krmkgXIbKKRTEqchQ3uIi0Rzmp4=
X-Gm-Gg: ASbGncvVEHNi+yDJ9W2VH78AEYWAnnw1/64aa3k95dR/rlNFwuF1makdTyZKm+Svkly
	H4nSof1M1UUEeXhDXXMX9DBFVg88Jgc0VYPUferdtNOwxR8JJOh/TvfIMjJE6dW04Uike/5TRQo
	mUv8u8vACGEw88PHaHe8MSAf1VqnUDZqDnGtFaDdMJ8Gde9Hc1mhDTf2YpTiEUDvU2aqaGJHUds
	NWabt4dmm5HSBF7e77p894yBMyBHFt6R3L+d54eecg7S7aqfGrCaSHlUhQxshiF/LmutXrPN2zV
	sBDHGHfBZosozzkyDv8BmoINGjCVBqL69dCe48t05e3MOna7/3y0NEXpJIJ6qEdFLZZGBlvMLkD
	oaZ5smDb0dBqR3GWSFF5qdDv1A4Jcu87FlYAe750w2myNYdzqQLsS9yWmSED1R9giMh7Kgwpp/L
	Tj6JiS9Zwta/FV/nGztJ6mBg6+L+sJah74l+KXV33ojbLsNVLnqziI
X-Google-Smtp-Source: AGHT+IEdsq/70nzbECt2XZv20aIclJJnJG4WOaVhcMt6Kol5NiFtvhP7+awwyCp70aSiqlFjENFKWA==
X-Received: by 2002:a05:600c:840f:b0:459:d709:e5d4 with SMTP id 5b1f17b1804b1-459e6fb8315mr72888315e9.0.1754577657329;
        Thu, 07 Aug 2025 07:40:57 -0700 (PDT)
Received: from ?IPV6:2003:e5:872d:3c00:27e3:fc0:fb5:67a3? (p200300e5872d3c0027e30fc00fb567a3.dip0.t-ipconnect.de. [2003:e5:872d:3c00:27e3:fc0:fb5:67a3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac158sm27487389f8f.4.2025.08.07.07.40.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 07:40:57 -0700 (PDT)
Message-ID: <e52e54f9-5f46-4d52-b02b-3ddb497d5ed9@suse.com>
Date: Thu, 7 Aug 2025 16:40:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 10/16] xen: swiotlb: Open code map_resource callback
To: Leon Romanovsky <leon@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Abdiel Janulgue <abdiel.janulgue@gmail.com>,
 Alexander Potapenko <glider@google.com>, Alex Gaynor
 <alex.gaynor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
 iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
 Jonathan Corbet <corbet@lwn.net>, kasan-dev@googlegroups.com,
 Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-trace-kernel@vger.kernel.org, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, "Michael S. Tsirkin"
 <mst@redhat.com>, Miguel Ojeda <ojeda@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
 Sagi Grimberg <sagi@grimberg.me>, Stefano Stabellini
 <sstabellini@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
 xen-devel@lists.xenproject.org
References: <cover.1754292567.git.leon@kernel.org>
 <e69e9510d9024d664133dc788f5186aac414318e.1754292567.git.leon@kernel.org>
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
In-Reply-To: <e69e9510d9024d664133dc788f5186aac414318e.1754292567.git.leon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------zbc1rtf2MP4v0hwBljje0R4r"
X-Rspamd-Queue-Id: 2826E40009
X-Stat-Signature: y1g6fatfccbcq4me754tftqucf98hqdh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754577658-547883
X-HE-Meta: U2FsdGVkX1/7451QAMKVkvBgHMiXlvAaXO8Vecn4MwbufY1OfIvNvx8apSx0wrdWX1DW8PT8YolI9GrkvUA3oqnYt1hFfXe/+wIKAQ4TzWt6JE4F5KuaQNLcfRy/+GxsTHsj0RyWOHSToEc5peqhHlDfic0RjmazrzRii2nb1ufp2WcPhlGH9uxkkL+94T7ivlDhG9rfOaTYUHldgh3AmrqxnW2p9qgeXmzZ9Vy8aeDJ3nvW97dr9wem7g9FyXV+3iXRAYa2bbYUmJ3fVWbir1wL1yacO7IalqL2ZsH1MViL4lHo5E0gE/eQY4/ZMUFLODGk01VSusnrFQ9jIxpCLTy1G6ms4lQ20HxPo9+s2wk1JEco9KN4UQjSMYWBMltPgvXAS1SXUFsHsrXDCErlu+RLAGzh35nJtsxDVIbsTu4XtMd6V/+sVLhvQ0u6jnLA/I6Ms88Gy1xgCZuIo1taVT9Xpu/B+D93MNwO2ddSwpE8NmJ7xOQ6q5+bz9E/ublzjB35iD5irugNQw1ki6JT3k+baXub+I34jUwX+Hg4c3gd6VRFqlkaMGIqILVrrK0+X2PY5WBANz/mJ66esL3qbjTlOCgscyUUex6bjpRTc/jnJELMDjxljLtPaX9B61Z7DQeYlDclMg1t9scNon1W5L1hx4kgxjSVTYxrNu6SCVuGMbwURIBHTw5LgZY6lKqVrkGAYgHTztyTuEQrxHvpN0Bz0K3oiF3vyNF3Ic69ZTC+P42scjJ9LTqFfC0qtb1UUnfTQjqtW0mZLrwxGbRnMnDaKf+9AqaPB0pnOJ5y+z7Bn1LSeg5NbB00ueWkz6qz+Ph9SnOSc805SwHBLyYGxbl0RuCZ/5f9L7klSHACmI89h09gjaBkhRKjrmzw77p4Yu6xvbW6BcOXFtiKzN2noxypJfnSCuMzgVhTUOiroHQGKtSqQdmUnjb2ky1fxyR9oU6JXIoOYLjPKyPUlP6
 vekryMoW
 gutkhRvoVB6a8Kd5J+CtP9374j7E+sYkhHmtrodIWerqfg9bHRP6JSi/+4fvlMLGPDMIfa5JLDuX1OO9H5CAzG26pccsYSUisXMO+aMAqVh4fG9yEgNrExTRfDmraxhu04rJ73UQ1dcPTRM7Vs41cVYkwbUKbwd1lxGzquDD3zqMGgV38E3PBV36WazS7wDM8Q9e0XKMydId0WzS4aZeNkx5l/bJmVmeFR3jwPZ1VJZST4lAp0BwcIlyDBJkgpBXyVuakjEz6nlciW9N/PpxRX5jYdcihIWI62C9AXAmMEqCIeF3N4KzAqjUKO4gPLJKV+puKoPMTplX7cxoCKj+d6Fek3rqTqWpQyiGzedqxH7DzRbjKQ3nzzGVr4561cyirPX0wi+Bd2BWkJhKCU77ajkt+X/AFfGBWAuC7wid6KOW4X8QS9U9QWubQ7gOyLnP5mY/wkpF5yoVJ3XIBOShvOsmw+eDC5VSKcHntMvGTrQ4OXuOv5Gse04y6UGlTWS+XuX9Zw9h6oj9g5QobADAsa8T9KoqYME3ZjTuwnOXmI4+iQYc8gTVD/XbSTnHVECRbnNd4fEwHSy8EDaH1MOeFhcJObrSZ9Af31Mpaz9mtZop8ElB5X8fyQ0MTfF/8928FQOcEed227T8+6Iyj/G3gsA0WmmH88lECSGqcrZCDYao52ThGOUiSzk860gbYFnDusEtyMSrFn/fDR1fZmKxlSwjbiUuid5GXb2oXQPuywlhYmw+5rPwr0/uG3NpGp0ReqVMX8MdSEPxgsdpneM4lTrHk10/ONd16ONmlBMLFI2TpjjUroOk83iNi9rbyLzIWbxRXEPMjEI+oedCgKimNDpNWpNuq4esQO5cN8aVmyi4vNsglO/gj+K4qRPivgjr+jbmz5em1Ue9mOyTV0Snv9jskJklIzcN9Yn4vlUl6bUDQqOD8squgvc+0hmTllwHL/BXrA8ftYnL9RA0sKC2Qxo6sIGhV
 H1z3OUeg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------zbc1rtf2MP4v0hwBljje0R4r
Content-Type: multipart/mixed; boundary="------------9ZSgHGkw4I0gfARYLaBix7N0";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Leon Romanovsky <leon@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Abdiel Janulgue <abdiel.janulgue@gmail.com>,
 Alexander Potapenko <glider@google.com>, Alex Gaynor
 <alex.gaynor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
 iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
 Jonathan Corbet <corbet@lwn.net>, kasan-dev@googlegroups.com,
 Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-trace-kernel@vger.kernel.org, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, "Michael S. Tsirkin"
 <mst@redhat.com>, Miguel Ojeda <ojeda@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
 Sagi Grimberg <sagi@grimberg.me>, Stefano Stabellini
 <sstabellini@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
 xen-devel@lists.xenproject.org
Message-ID: <e52e54f9-5f46-4d52-b02b-3ddb497d5ed9@suse.com>
Subject: Re: [PATCH v1 10/16] xen: swiotlb: Open code map_resource callback
References: <cover.1754292567.git.leon@kernel.org>
 <e69e9510d9024d664133dc788f5186aac414318e.1754292567.git.leon@kernel.org>
In-Reply-To: <e69e9510d9024d664133dc788f5186aac414318e.1754292567.git.leon@kernel.org>

--------------9ZSgHGkw4I0gfARYLaBix7N0
Content-Type: multipart/mixed; boundary="------------MyLdgWVjx6doOE9CX8bqeBuf"

--------------MyLdgWVjx6doOE9CX8bqeBuf
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDQuMDguMjUgMTQ6NDIsIExlb24gUm9tYW5vdnNreSB3cm90ZToNCj4gRnJvbTogTGVv
biBSb21hbm92c2t5IDxsZW9ucm9AbnZpZGlhLmNvbT4NCj4gDQo+IEdlbmVyYWwgZG1hX2Rp
cmVjdF9tYXBfcmVzb3VyY2UoKSBpcyBnb2luZyB0byBiZSByZW1vdmVkDQo+IGluIG5leHQg
cGF0Y2gsIHNvIHNpbXBseSBvcGVuLWNvZGUgaXQgaW4geGVuIGRyaXZlci4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IExlb24gUm9tYW5vdnNreSA8bGVvbnJvQG52aWRpYS5jb20+DQoNClJl
dmlld2VkLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+DQoNCg0KSnVlcmdl
bg0K
--------------MyLdgWVjx6doOE9CX8bqeBuf
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------MyLdgWVjx6doOE9CX8bqeBuf--

--------------9ZSgHGkw4I0gfARYLaBix7N0--

--------------zbc1rtf2MP4v0hwBljje0R4r
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmiUuvcFAwAAAAAACgkQsN6d1ii/Ey8T
2gf9Fig/dfNm6Pc7N5CfTbfrvQeHxFrx0A+Lbz3wE1LBralSuURdjPw+wrBAGuNq/agCOFH7OBqC
ayEkBjEdcL5kEblmVCgSWfcKQRq0vW5y0zkrzYglQyfuWhihBm/d56LwWxjbGku6QYLMnb5dGvHG
wtjPE58yPWlaVaZa/NiWJLKtHyLc9Ep3+vhGNksayAXIsaRoqhk6g0dlVfOZUhQB2CTSQmBN8Cjo
yhy4qsUiY26xJ0qhoNBaBahj9XRBQX5jz0z6IXT0xVJOTx5MoVU/ciBTMU97RmC1WbR0D5dAFfaA
bgpP4QE+654uwyPjna/thpNWrTTm0kf3W+lFK/6fTQ==
=Fe2s
-----END PGP SIGNATURE-----

--------------zbc1rtf2MP4v0hwBljje0R4r--

