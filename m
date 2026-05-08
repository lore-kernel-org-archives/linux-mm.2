Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA65CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 08:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE6776B011C; Fri,  8 May 2026 04:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBE306B011E; Fri,  8 May 2026 04:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3A56B011F; Fri,  8 May 2026 04:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9DDE6B011C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 04:33:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D796140758
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:33:58 +0000 (UTC)
X-FDA: 84743589756.06.587085B
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2904CC000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:33:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aNV1b7iV;
	spf=pass (imf10.hostedemail.com: domain of jgross@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778229236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8pa6nW6L+PoRyM5QGx30dORKj2RFf8dclDZUh9rUiM=;
	b=pj3mNub2TE9Jgy6qy3bS7YZ7xw7aNJrvTFqd1YdPCyCrlLdO2MWwHvDR0o0agJve2vtw8c
	M7C32YHWuJd6qDta15mDj0mhUkfpCWOz9FhTuJbQ/TjSU3nvQahAF2tTOCVtLjtROtyuMk
	68PXXosP/NkqW7zOr7W+fezRtDonJI8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aNV1b7iV;
	spf=pass (imf10.hostedemail.com: domain of jgross@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778229236; a=rsa-sha256;
	cv=none;
	b=ZCtFpHYERq2YiR8jLH23/mcPrbGM2vJeO8s92p7j4nQ/F2yaFaDBHFVt48wOKnhYaSpdxZ
	tMBn+HUbaON0HxKzgKjf89l84L841qTJaFctj4q0f6KMDfq+caI6hER33oaX9CFEgrHo0V
	4kiKzM2dMucs4hjUgGYVjLyFolJOq6E=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bba0dde4f43so254538066b.3
        for <linux-mm@kvack.org>; Fri, 08 May 2026 01:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778229234; x=1778834034; darn=kvack.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i8pa6nW6L+PoRyM5QGx30dORKj2RFf8dclDZUh9rUiM=;
        b=aNV1b7iVB6sFkvhwyf+SRThQ8IbY043Zs9QV71qoNAMLMX0PubaXuukj1Cu0sogbeW
         FENRFPoLxC6z3z289GGVJKaX9YmUQfZYWo4AgCMUX14cAya2CSKtqw4wURhqxStSEgxE
         wyCrMyHw8vxKHmPnbymBmW8AgrCLELNNwCDQVf6dr4hEY7d1YZDfbcaijMV3AXDzPgky
         MaT7y4IK8VPz83SjSsqQBfFfX/kzpYEh9dFeWzibee3Tz3+yUFVKT0tLPVzsT1bqaeIB
         zxcVDMZm5jDxkklx/nOe6dLs1doVNOvtZhzt9lmIkvBwzAf55NFxowYzIsxDXwf+3mXp
         pbwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778229234; x=1778834034;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i8pa6nW6L+PoRyM5QGx30dORKj2RFf8dclDZUh9rUiM=;
        b=nbk7AL6jM4XhVXKdzqIaczHRRyglDm8ddTUeteIg4XRk9tFoH2XL5QzezZ9FeP7E8z
         /Eaz5dxQH8KiFI8cj6RGNsAUwi3PGyTkuvDeMrBWkJMsKcZRwQJJbGW8BwhakQ9/0jms
         83/HPJqSAioDrv+lCV6Mh+LXsdSvw02BpFS1Iv/FgSCVNzbitWiiA/aDOdWeDfekeb/L
         2K8Pt/n4MwvL3ataBMB0IS38SmUFn1EARmFtDG+KjfnSk84nHVBql96nOi9rKMC0SPLx
         uz3Rhu7lQh4B5OcZb23kClvdl2xVqAfe9OeZtToTq6GUuRms7iWKFD6RzJvbCWEnQfRs
         T1Eg==
X-Forwarded-Encrypted: i=1; AFNElJ9txemaPr+4M5ZsghikBU5aDzwOU1Eu3So53CvgJ1IvfF4BibHSXkG68Hy2HAlyl7zOtJygn6Sw7g==@kvack.org
X-Gm-Message-State: AOJu0Yw1aPpFsotxKOO8N+KrXXMT7B0GImGxnFz7ZhomcbZbHNxLyGU2
	54JcBMb4zmPaSVBaXL1y8Oxl+EVZXRZzmbZ5UdTr97j38c4W0uWnGopY6lc6fQ9M4/c=
X-Gm-Gg: AeBDieuguE+nWG49CqvqqCBqzlG2V2NKRIGdg4r2fN3u/4ezKsSb5541lOFy+JSslVp
	j+xctEi5LS/OJdvn6WEUZseSABaiwqpa1mLUNGm6f0lRYzHFnQbGwigwmsRdl0oeYoz50tkVOqx
	c24XuBoT4WyUV7tc0hAu0+SgQz1eUcc27JQp+4jjPoNXPKSGwEVIa4dsIle/Mcmz2sztCsmWLPx
	R7GKn9QVqBfTmHJF6wfboHt6+fAKs6F3Y+22aAVfgJa8rTjbYxE8WusLcT606GUian+1iqMwB7s
	bANwItCfOeRfoQGfKk2/k9oPtj16mFUSxJDtHhIH1bzPDiWJuRBolQM0tNGGWSx0smr8dl8V5re
	quShJ/noHXMkKs/pARvXRrTa6UuDyiJPObHOxGl0RtZzYB8HXURrtdFtUGZ75NFHI9w6RedoWsV
	Wdh1FsLRpvMivcW8IzFXc46M90e0gVvXXKkjAXLAqyb6P6ddYtN2Qy9iQ5MQiT7P9ebjXZTUe+g
	bB8DwoE+HNjakjUxtnBmBtrarQQ8T5Vac4oW3Q5ohGUy08nIrBwkw==
X-Received: by 2002:a17:906:478e:b0:bc9:e1b1:8edf with SMTP id a640c23a62f3a-bcaaa54ce58mr100836066b.12.1778229234147;
        Fri, 08 May 2026 01:33:54 -0700 (PDT)
Received: from ?IPV6:2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112? (2a00-12d0-af5d-ad01-5d3f-14e6-9bcb-5112.ip.tng.de. [2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bcac484dd7bsm47705566b.60.2026.05.08.01.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2026 01:33:53 -0700 (PDT)
Message-ID: <5cb54bd1-5981-4a46-9083-f7b527ca342f@suse.com>
Date: Fri, 8 May 2026 10:33:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/xen: Fix lazy mmu handling across context switch
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org
Cc: kevin.brodsky@arm.com, mmarek@invisiblethingslab.com,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, xen-devel@lists.xenproject.org
References: <20260508080514.454607-1-jgross@suse.com>
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
In-Reply-To: <20260508080514.454607-1-jgross@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------3Jq2hVC2vaJmzLdycTi38fj0"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2904CC000B
X-Stat-Signature: dtf7tht16ak4wqp5k5z1rjep44nfj1au
X-HE-Tag: 1778229235-855085
X-HE-Meta: U2FsdGVkX1/FvFTPJ6QtSGXHp3HYq4ydGX3Xqenfw3gpQq5iZHBy+RZknU6aL9aOK3Yu1OZ6YTYTkjfQ+HhbJPSd24j8eJtJSchO6fbeBDQkiTFrI4lDnjTdNz+cWNwWUkxHdhbnDsC8PqiLgsgclVx1jxgj+nTHynnQI4bpAgfyU0x/BG9wYVl2NMCKPPB8Tjn31cKxRSofmIcRay9neST+6qgHtUb16Vrcv8Zt9p1zokVDBHWBTmeGzntf06toRg1FE0/RvTXlGDh1p0aYKYuEP/dYcLRjwYUFoXm81ps+6J2Gde1NDfsdVQk0Md8fYn2eQbcKdsoHQDtNLOIAZvrt8DcZArVFhn3S+VVdf0N2mNyIrvO23Fo65ye4VQepY0z8JbiDSOoncTcSK9LWQsnuXMkLnSILtGSiEGq0gK4UY62Q30Eui0pD8g/oxPPU4SfpJHlk3oa0x5OXyGe1pGpWu6blMJoqCOY9UvGNIkZJgdBx+19XBn4dqeyGbpS3QHnvrAci7IMMzV2u49qTb95ZFnO9AoSkV/37gT1+/O51zVlZn0NsvnoIwCVkD25Hs7LJ6LydjQ6KMWjzBzB2woest8c7XbxC7+KsIrDD26mynhLFZEPzkP/S2H4t/8GdFepqcxATdOKWuwwJvdJaeD0UN4GMKpEmHtm9k6h/BNZ2USwHLFE0vwIq+AJmWgtpYF/hdRKoI0X1HLNtoyTLngehqPWk19x6o7bjtl7AWLEmROpJ7fXwXwNDmIUy7P4l/9/uRY7LaNY3Ot6B5SziON1glWAVS/f6cPygkhZZEBy/PwkBWixhpofQBiebRE/pP2j0+xC7RYtnsJb9T02bM5Nmp+ruRmHK+gkVf6oFniuS8fUSYSwq0InqcGQXQE2TYe1mAgUaKJ4rBDRlVmsaQTZqUKju5xfDhshI1pI403owepFmu++2OErCVZOsDiyvRfqPipulxuOttabDeVL
 QmuVX2mk
 hu8rQrZnPCWu/zSpFYv5plmtrEJwDNEBKKTxCIx8acVZ2GXbR6unnNTpUBWEV7R9cX6YsUGyJ08I66cLHElZf4tF0E42SqjrV2VEOyA4/qD7mBskv+xPVgpF3+898Q1hf+RNo4qvHbP7ARKV/ZWtz6G+ovznV+Ghtd+ljB4F70r/As+PSjPNJgZiy6y1ZHrQX6RcVdcj0O2PV9ZcYSK5nGRF+XDkrQNgz4AKwQCVWm72Sau9FTyZSSu9TPUJ77PpAJ6Ql4iQu50PcPe7S3PzDAnvKA8J8WN+th1p+I0G8G6a0iDnihXRFZnG+5srRJqV7khxZNElm111jJPimN2x2uYSeZGOqgx+Gh7bK1HDhGdNsb7bKCw5gu9H+NiuZ4OLXizBoFeVTm5GNLG0h1ImghcpBCk4VD3uVW1RDAdlw/DLtx95r0CHo6J3teZnHonCLFsa5pYOMZ5bKETu/Fuh60Ac4YPpacNKbb8nB2LZsIHVgbJH/1c/mA3c8ecAMtfGo1S7QUkUFa3/nBacTJMu659ADpsSjkoJtFA++3fHuz2f+oU44ub0Rn+fcr8KoTA3SotcekRnQLaihPI/vGNQxOk2wCyxyXcqwpkxNXO3LIF47BW8OJ0P47vAvN9GZ4wULG0otwga4nfQIIWh7s0itosPCGxK54prXAFoj8cMMaQpkJRTZYsfA6GQ8NrGtZUWioW4NWjyEg7kJR3POzQuHzrJQ525unYdc1IgPxa+Ige4b+1JykIbMMRhKjBpNWsl9VHpvnbc8iEpHgSa5X4w9EDTR8WDrVkPgnZKOx6qCyntBXOMF6Djv3Q9U6d/Axny5G/yDkeq/qaBUJ8YZ0EmyS7j7Zu002rRtKIzl8TcwyrQRwnZZILiIueotIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------3Jq2hVC2vaJmzLdycTi38fj0
Content-Type: multipart/mixed; boundary="------------Vt7oWIJw8gIt0eyJaT1vcDAe";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org
Cc: kevin.brodsky@arm.com, mmarek@invisiblethingslab.com,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, xen-devel@lists.xenproject.org
Message-ID: <5cb54bd1-5981-4a46-9083-f7b527ca342f@suse.com>
Subject: Re: [PATCH] x86/xen: Fix lazy mmu handling across context switch
References: <20260508080514.454607-1-jgross@suse.com>
In-Reply-To: <20260508080514.454607-1-jgross@suse.com>

--------------Vt7oWIJw8gIt0eyJaT1vcDAe
Content-Type: multipart/mixed; boundary="------------oDEGK9VJWMWYbdXgkX7jaAvL"

--------------oDEGK9VJWMWYbdXgkX7jaAvL
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

UGxlYXNlIGRpc3JlZ2FyZCB0aGlzIHBhdGNoLiBJdCBpc24ndCBmaXhpbmcgdGhlIHJlYWwg
cHJvYmxlbS4NCg0KT24gMDguMDUuMjYgMTA6MDUsIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+
IFRoZSByZWNlbnQgcmV3b3JrIG9mIG1tdSBsYXp5IG1vZGUgaGFzIHJlc3VsdGVkIGluIHBy
b2JsZW1zIHdoZW4NCj4gcnVubmluZyBhcyBhIFhlbiBQViBndWVzdC4gRW5hYmxpbmcgbGF6
eSBtbXUgbW9kZSBmb3IgdGhlIG5ldyBjb250ZXh0DQo+IGR1cmluZyBjb250ZXh0IHN3aXRj
aCBpcyBkb25lIGZyb20gdGhlIGFyY2hfZW5kX2NvbnRleHRfc3dpdGNoKCkgaG9vaywNCj4g
YnV0IHdoZW4gY2FsbGluZyB0aGlzIGhvb2sgY3VycmVudCBoYXNuJ3QgYmVlbiBjaGFuZ2Vk
IHlldCwgc28gdGhlDQo+IGxhenkgbW11IG1vZGUgc3RhdGUgb2YgdGhlIHdyb25nIHRhc2sg
aXMgbW9kaWZpZWQuDQo+IA0KPiBBZGRpdGlvbmFsbHkgaXQgaXMgbXVjaCBjbGVhbmVyIHRv
IHVzZSBsYXp5X21tdV9tb2RlX3BhdXNlKCkgYW5kDQo+IGxhenlfbW11X21vZGVfcmVzdW1l
KCkgaW4gdGhlIFhlbiBjb250ZXh0IHN3aXRjaCBob29rcywgYXMgaXQgYXZvaWRzDQo+IGNv
bmRpdGlvbmFscyBpbiB0aG9zZSBob29rcy4NCj4gDQo+IEluIG9yZGVyIG5vdCBoYXZpbmcg
dG8gYWRkIGFub3RoZXIgaG9vayB0byBiZSBjYWxsZWQgYWZ0ZXIgc3dpdGNoaW5nDQo+IGN1
cnJlbnQsIG1vZGlmeSBsYXp5X21tdV9tb2RlX3Jlc3VtZSgpIHRvIHVzZSBhIG5ldyBzdWIt
ZnVuY3Rpb24gd2hpY2gNCj4gdGFrZXMgYSB0YXNrIHBvaW50ZXIgYXMgcGFyYW1ldGVyLiBU
aGlzIG5ldyBzdWItZnVuY3Rpb24gY2FuIHRoZW4gYmUNCj4gdXNlZCBpbiB0aGUgeGVuX2Vu
ZF9jb250ZXh0X3N3aXRjaCgpIGhvb2suDQo+IA0KPiBGaXhlczogMjkxYjNhYmVkNjU3ICgi
eDg2L3hlbjogdXNlIGxhenlfbW11X3N0YXRlIHdoZW4gY29udGV4dC1zd2l0Y2hpbmciKQ0K
PiBTaWduZWQtb2ZmLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+DQo+IC0t
LQ0KPiAgIGFyY2gveDg2L3hlbi9lbmxpZ2h0ZW5fcHYuYyB8ICA3ICsrLS0tLS0NCj4gICBp
bmNsdWRlL2xpbnV4L3BndGFibGUuaCAgICAgfCAzMyArKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0NCj4gICAyIGZpbGVzIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyksIDE0
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0
ZW5fcHYuYyBiL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW5fcHYuYw0KPiBpbmRleCBlZDJkN2Ez
NzU2Y2UuLjY3YmI2YmY2ZDI0MCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYveGVuL2VubGln
aHRlbl9wdi5jDQo+ICsrKyBiL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW5fcHYuYw0KPiBAQCAt
NDI0LDkgKzQyNCw3IEBAIHN0YXRpYyB2b2lkIHhlbl9zdGFydF9jb250ZXh0X3N3aXRjaChz
dHJ1Y3QgdGFza19zdHJ1Y3QgKnByZXYpDQo+ICAgew0KPiAgIAlCVUdfT04ocHJlZW1wdGli
bGUoKSk7DQo+ICAgDQo+IC0JaWYgKHRoaXNfY3B1X3JlYWQoeGVuX2xhenlfbW9kZSkgPT0g
WEVOX0xBWllfTU1VKSB7DQo+IC0JCWFyY2hfbGVhdmVfbGF6eV9tbXVfbW9kZSgpOw0KPiAt
CX0NCj4gKwlsYXp5X21tdV9tb2RlX3BhdXNlKCk7DQo+ICAgCWVudGVyX2xhenkoWEVOX0xB
WllfQ1BVKTsNCj4gICB9DQo+ICAgDQo+IEBAIC00MzYsOCArNDM0LDcgQEAgc3RhdGljIHZv
aWQgeGVuX2VuZF9jb250ZXh0X3N3aXRjaChzdHJ1Y3QgdGFza19zdHJ1Y3QgKm5leHQpDQo+
ICAgDQo+ICAgCXhlbl9tY19mbHVzaCgpOw0KPiAgIAlsZWF2ZV9sYXp5KFhFTl9MQVpZX0NQ
VSk7DQo+IC0JaWYgKF9fdGFza19sYXp5X21tdV9tb2RlX2FjdGl2ZShuZXh0KSkNCj4gLQkJ
YXJjaF9lbnRlcl9sYXp5X21tdV9tb2RlKCk7DQo+ICsJbGF6eV9tbXVfbW9kZV9yZXN1bWVf
dGFzayhuZXh0KTsNCj4gICB9DQo+ICAgDQo+ICAgc3RhdGljIHVuc2lnbmVkIGxvbmcgeGVu
X3N0b3JlX3RyKHZvaWQpDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3BndGFibGUu
aCBiL2luY2x1ZGUvbGludXgvcGd0YWJsZS5oDQo+IGluZGV4IGNkZDY4ZWQzYWUxYS4uODNh
MDk5YmYyMDM4IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L3BndGFibGUuaA0KPiAr
KysgYi9pbmNsdWRlL2xpbnV4L3BndGFibGUuaA0KPiBAQCAtMzI2LDYgKzMyNiwyOCBAQCBz
dGF0aWMgaW5saW5lIHZvaWQgbGF6eV9tbXVfbW9kZV9wYXVzZSh2b2lkKQ0KPiAgIAkJYXJj
aF9sZWF2ZV9sYXp5X21tdV9tb2RlKCk7DQo+ICAgfQ0KPiAgIA0KPiArLyoqDQo+ICsgKiBs
YXp5X21tdV9tb2RlX3Jlc3VtZV90YXNrKCkgLSBSZXN1bWUgdGhlIGxhenkgTU1VIG1vZGUg
Zm9yIGEgc3BlY2lmaWMgdGFzay4NCj4gKyAqDQo+ICsgKiBMaWtlIGxhenlfbW11X21vZGVf
cmVzdW1lKCkgYmVsb3csIGJ1dCB3aXRoIGEgdGFzayBzcGVjaWZpZWQuDQo+ICsgKiBNdXN0
IGJlIGNhbGxlZCBvbmx5IGJ5IGxhenlfbW11X21vZGVfcmVzdW1lKCkgb3IgZHVyaW5nIGNv
bnRleHQgc3dpdGNoLg0KPiArICogTXVzdCBuZXZlciBiZSBjYWxsZWQgaW4gaW50ZXJydXB0
IGNvbnRleHQuDQo+ICsgKg0KPiArICogTXVzdCBtYXRjaCBhIGNhbGwgdG8gbGF6eV9tbXVf
bW9kZV9wYXVzZSgpLg0KPiArICoNCj4gKyAqIEhhcyBubyBlZmZlY3QgaWYgY2FsbGVkOg0K
PiArICogLSBXaGlsZSBwYXVzZWQgKGluc2lkZSBhbm90aGVyIHBhdXNlKCkvcmVzdW1lKCkg
cGFpcikNCj4gKyAqLw0KPiArc3RhdGljIGlubGluZSB2b2lkIGxhenlfbW11X21vZGVfcmVz
dW1lX3Rhc2soc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrKQ0KPiArew0KPiArCXN0cnVjdCBs
YXp5X21tdV9zdGF0ZSAqc3RhdGUgPSAmdGFzay0+bGF6eV9tbXVfc3RhdGU7DQo+ICsNCj4g
KwlWTV9XQVJOX09OX09OQ0Uoc3RhdGUtPnBhdXNlX2NvdW50ID09IDApOw0KPiArDQo+ICsJ
aWYgKC0tc3RhdGUtPnBhdXNlX2NvdW50ID09IDAgJiYgc3RhdGUtPmVuYWJsZV9jb3VudCA+
IDApDQo+ICsJCWFyY2hfZW50ZXJfbGF6eV9tbXVfbW9kZSgpOw0KPiArfQ0KPiArDQo+ICAg
LyoqDQo+ICAgICogbGF6eV9tbXVfbW9kZV9yZXN1bWUoKSAtIFJlc3VtZSB0aGUgbGF6eSBN
TVUgbW9kZS4NCj4gICAgKg0KPiBAQCAtMzQxLDE1ICszNjMsOCBAQCBzdGF0aWMgaW5saW5l
IHZvaWQgbGF6eV9tbXVfbW9kZV9wYXVzZSh2b2lkKQ0KPiAgICAqLw0KPiAgIHN0YXRpYyBp
bmxpbmUgdm9pZCBsYXp5X21tdV9tb2RlX3Jlc3VtZSh2b2lkKQ0KPiAgIHsNCj4gLQlzdHJ1
Y3QgbGF6eV9tbXVfc3RhdGUgKnN0YXRlID0gJmN1cnJlbnQtPmxhenlfbW11X3N0YXRlOw0K
PiAtDQo+IC0JaWYgKGluX2ludGVycnVwdCgpKQ0KPiAtCQlyZXR1cm47DQo+IC0NCj4gLQlW
TV9XQVJOX09OX09OQ0Uoc3RhdGUtPnBhdXNlX2NvdW50ID09IDApOw0KPiAtDQo+IC0JaWYg
KC0tc3RhdGUtPnBhdXNlX2NvdW50ID09IDAgJiYgc3RhdGUtPmVuYWJsZV9jb3VudCA+IDAp
DQo+IC0JCWFyY2hfZW50ZXJfbGF6eV9tbXVfbW9kZSgpOw0KPiArCWlmICghaW5faW50ZXJy
dXB0KCkpDQo+ICsJCWxhenlfbW11X21vZGVfcmVzdW1lX3Rhc2soY3VycmVudCk7DQo+ICAg
fQ0KPiAgICNlbHNlDQo+ICAgc3RhdGljIGlubGluZSB2b2lkIGxhenlfbW11X21vZGVfZW5h
YmxlKHZvaWQpIHt9DQoNCg==
--------------oDEGK9VJWMWYbdXgkX7jaAvL
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------oDEGK9VJWMWYbdXgkX7jaAvL--

--------------Vt7oWIJw8gIt0eyJaT1vcDAe--

--------------3Jq2hVC2vaJmzLdycTi38fj0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmn9n/EFAwAAAAAACgkQsN6d1ii/Ey/x
6gf+J/AVbxjJD4ti6UuIJFneskf3CRILQ7wRPiAmpCYPrfNgX1dIMcFi+mCI5dGoqjvb5KsqVCe5
F1gpJ5cPOudh5Ky0nAlR+Hv0e9nRzDs6nZdGh/mDQRRU8AN10C+du3mUAwldWGa3jaSbkegh8Ywp
2KKF/PN6Uy+zPKM1X9cPH2pXYoGFAkKxxUGPtJQtUumnACJtMhYTgEMHj3ysMO7PZicHMNqrFlb3
odeXUh7Uy80Z/rGBpuE/b5jsKYefVvpnGDxphAoJX6C/xTGSIe0eoi3XUThtIuuSkauRGLB4zCA1
02WVdKpLS27gtabxdsUth7kNBliUDHHTtfm9ptRaeg==
=Xx43
-----END PGP SIGNATURE-----

--------------3Jq2hVC2vaJmzLdycTi38fj0--

