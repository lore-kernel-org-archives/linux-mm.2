Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69831606A335
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 07:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Y3f74oLq
Received: by kanga.kvack.org (Postfix)
	id 521596B05B3; Tue, 10 Nov 2026 02:26:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2696B05B4; Tue, 10 Nov 2026 02:26:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375EE6B05B5; Tue, 10 Nov 2026 02:26:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DFE06B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:26:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 86BA71C42AE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:26:04 +0000 (UTC)
X-FDA: 85418375448.29.BC3D81F
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id 554E6A0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:26:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y3f74oLq;
	spf=pass (imf25.hostedemail.com: domain of jgross@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794295562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OVur5LhTJoFv66K/FHeEGJ1JCwZsBRUToYym0WGroXg=;
	b=I42HiD13SsZNkNwB3CMng25TAdHlVzzJnCoMjekyrpiDAIwD2gO3dbRLD8BN61n9PqSPK7
	+pHXJ0+jP4K7unBcEKo+xSCTVFbrX5tjPmlru68AxzT8msFBEAbY4m/nOlQxZyEbDdt2w6
	wA7sll6XCeL2hPUKw3UUojXQeMgyNPY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y3f74oLq;
	spf=pass (imf25.hostedemail.com: domain of jgross@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794295562;
	b=kAW4cX8scXF8rh98t1FFSEOa1PgNSA35/Nto/kQI/skS07ffBVMV103qIVK1P3++KiUU4q
	9sd4FrLqbq/pkOdA0BjGWWNd3EZ2N7ACc2Z8q1smn79R/iy1EXr9sE1yQssk9sTCpYGllU
	weuwunajbqvN+y+4ZnvbaAdjSY5sSAg=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4697404c2bso228583966b.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 23:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794295561; x=1794900361; darn=kvack.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OVur5LhTJoFv66K/FHeEGJ1JCwZsBRUToYym0WGroXg=;
        b=Y3f74oLqtwHNE/bmxw7kdNjK/8Xn5oXzee3B9q25WCYU9eCIgsRcwccDSVhpGhrm6U
         VronjCgfkRMsGbFIfQg8TsUP0zOS/nlAnsIEfXnuR17zDnrumMzLG4H36srkfFPo8vsJ
         FWQfnlC37DzcPtKQ6CgwqUkN9QJLxSm7e8KWgyvH0EJUljNc7F2jCUOXsnhG02Lc1rLZ
         AAV/85PmKTP6RbU1oBOXwm8GYLn7BjSqnGcmivrHVQlAOaXCt6YajYEtBlSdrq2fmzxd
         wvZYg0mkedZwuNYLzs7H/dJI5VMRfqRr066kQDFB5luVymjEe9K2YSkaS40uz5OrKRd3
         v2Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794295561; x=1794900361;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OVur5LhTJoFv66K/FHeEGJ1JCwZsBRUToYym0WGroXg=;
        b=P54j7PL+LSYLS9W3oq5aEGycEHneSgMITP1jXcNeHdGmqHqcfO+dVyI7QUMBgQPOJK
         Jg1Lem87hENSqy4wsEUd1LKMiXaO6N3jyZ9YvizNrfDa2Js9tht1RmDLLLzErIQpfENr
         C1pDPaqucREcDxdKzcDRs+ifeVlFKTTtTUiY8e6rQp5JzkHyuDy/5ySYM+UoylheRhSZ
         kmlnQmByGpElFCWlY7LZkgIJ+e7YTxr3hhe3hkBy2WKjHVi7ILAQrxMXV8PEjBYE5tdp
         vNjvFO0cyIM8Vb3RzvmyJAgZElNpmAqglGssFeyNGvai2W4NuTCgozuxhqIm1wP9UaIz
         r48w==
X-Forwarded-Encrypted: i=1; AL+hErG9pAypirJI0TP/T2pwKYFx2U4NzcDo61G1rfQhsYyDbyQRCmmODcKZdETWw4cGNfsxbmyYy0La8w==@kvack.org
X-Gm-Message-State: APuU4Z8dK/xNjezF76R71tkHcIcKY+uJQljSwVuKq5VqCbIoiLQZRlDd
	zNgE+mXzGUGdttpeJCaWd2hNFWfdS/152/XY2gW/qpQLU2WbPifQ0i5UtAhvitZOaxU=
X-Gm-Gg: AYBFou3cYPDok0l8c17NHsaUBNmim3293OfDcOol57lbkZaGeAnxuYS31KzRS7noUDY
	3VQZQU2DV1OhozfIaXGp4GSIUkneh81ykWzc847yhEaFERwStnV9GOvgkduvZKRkwpQC9V5KiNm
	EZVdE1QZ1A+hxxjSK8kLS7ZVU/EjsyhOH4/OOlHdJ90vXUUgIotG196FQu8NXLhzMRkY0gWoOwx
	cfO71LknwNmTIGRVf3xneG345yepUsKsvwrAxtu3bSFFbACF/7mi3v2nKnOU0OhwXAeIdHb7E91
	v0qOfCcwiZMBWBYWduPBz08ccLDS0hW1x67rMuTLaSEX3Zadhjkcwb4M4yX9zdFCFA9RiFxLlN7
	ho1c351m5jpgI75dMOpNWcVIpLBNxf9Coziy7hjC2V/V1KcOx327E3T3YA1Y+yMhAF5Zin2BU3r
	hKltACfIHPeNayrFWAVHUdHYh357XCQyxYJ0wkZ3XVqfq4OOD25QmWwl78lct1qQN9XzN8v0Jku
	DKRJIW2MOyMPdCaHC0SMytaRSsqOQvx8Wt07JcdCnXcOso1HUACiun88jFmEe1dZiPhiFW0lzub
	iRfJYiJ9bsQCCzGsgou+rRI7EV2XF8PYXtTjt+DpiddAHbMkxWaZCIG5BZFwUZjDnMD4+tof/MS
	XVGmeXQDqah89n9j0AUqxqCQKPzBAEBw6rXILW3tNyeFHOMhG6zrpKNqrKbaLWDg1QWb5ve7A
X-Received: by 2002:a17:906:eecb:b0:c40:4965:72bd with SMTP id a640c23a62f3a-c50494e70c5mr127676966b.19.1794295560623;
        Mon, 09 Nov 2026 23:26:00 -0800 (PST)
Received: from ?IPV6:2a00:12d0:afa3:c01:92cc:e257:77ba:97a1? (2a00-12d0-afa3-c01-92cc-e257-77ba-97a1.ip.tng.de. [2a00:12d0:afa3:c01:92cc:e257:77ba:97a1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a593b5esm76107766b.34.2026.11.09.23.26.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 23:26:00 -0800 (PST)
Message-ID: <b67abdc3-f234-49ce-b463-1e06e87eccf8@suse.com>
Date: Tue, 10 Nov 2026 08:25:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xen/events: replace page allocator calls with
 k[mz]alloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: David Hildenbrand <david@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, linux-mm@kvack.org, xen-devel@lists.xenproject.org,
 linux-kernel@vger.kernel.org
References: <20261110-b4-xen-v2-1-21ece28be7d4@kernel.org>
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
In-Reply-To: <20261110-b4-xen-v2-1-21ece28be7d4@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------EM4uW1evflvUIpHMy0e9UjZp"
X-Stat-Signature: iikf4bgbg1ci18ptieofpmz3k8whimna
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 554E6A0005
X-HE-Tag: 1794295562-601596
X-HE-Meta: U2FsdGVkX1+/Jm1mHZd+SyToG0DZ2DTaIywUVA31tFvANEVuneYNeEspq7s9eZ/0Aj6WqqVGhkN8+b0zgDAGHoVOptbcbzD95mV/LYMudlUs4lTLy489+RbNALxF0dUeULyszhYDj5KKBJJfHvKz84rxbqEtYB9QQbRvxHhDtzVp2oZEnlO0t5iFm44Gt/yc91hERvYfkdlkOnP9m3t0FVvw8Wy53SJkSmbpMwrqa6TpXDcN9dJLmA6e3E84esco+Y/sjnlJGgkyG+5Ka25d3a63XMTtSiYl2m0/HnDhrZQIRBm6jLNZTLv/7siyoxILVDEdsj/JrjyBabQoIHLTn64QBpobkyZKBcOGOWpQ5kckahPm9FPNHta90FzsYApv9SzGX8mLCvlS5h0GigdBXdE+ORLukDyAKTVNZML44dm5PAPmuGHDG6+6IHkEAKVtUhDYgMIehqDXbQTeYfA6KA82igP+gMnBWxbqTXJYRUZTbb4AUA29Us4hNZ/xJIjyks5UP9/MsqyBON1EQ9l47SDxor7ZrcPkwG9gqeSYtPEXBinU88k28bssm76Lhnn4Lxk2MSHpdWEU3f2EZG+QnHm4aq9eTCR3LeWUiOE7OFcS7Ck12aA1Sck+k+l4KBB/QrHA6lRGyTDRq++oZbt3UMgX3nzV1pJfGbpLUEDlrru6gHH0qd//Tm/UCVMBubct9m6zqgu0iuBdlbLzMzyAHOcBJTVcpNQxN7+TqIUp73IC6n6AX2oM8dmlJmZg4GKCFcFmCK7z7mHh/U+rIfXEw8y1/iM55LaQeG/V09bsaxtpDkyUpuYbgcOaIq73gMvNWuvUZoAdS/BGpbHa8vlZIHeV4pRUkJGQ5/betjBfuMnr0WMUl0Uryg58r/c0YutJY1M6jWzvyfdj746RtNZzBbR8m87H0i6hyrYqmaTvgC3uOSzGjym90u8eYN1Z4M36mcMXVG2ihV6z2gnjV/C
 Hbs9Y72I
 DAdvLJqc9SmhDd/jNsMEZYhuP8ETR/zcasGOLffbyZnGlR9yeaiKAsiX7LdZ9AbRoUu8zrZwvwBijx/6FGPD6uSp19TzucNCIJ807cvttxmpLAp6pw4WA2V47EMHORNaAiz6UCQU3CQUMqSx3RUfqqqg+sca+ufMbtrQchf8rvgu70ALHfjSr41gPuYXcA8Gk2RaW1U+qAkPyWpReciW5U6gh97Cs5af2qTjKe0YtUDuwLmmN1Fp9DTDImFGTpohwQXWJth4fUGJm69DxmLPu4rfUsT5AKpvP8cggONgx0O54wiLukJp6Bm3/9Q9hFoozRqf9/JPpZ9Fb4QzCczdBr2KmoeBJoGRDcww7yhZulpGYil+0egb7UqnSMX8C+zkkhEjCFf8BLKuIAH86MtI8KxXDtaUCfh1hSRGSytCUf1cvkMMj1sxQYCrGOSIC1VnoQ5Y0V+Vb8ZXe/erFTTUiMaNd1Ph9dzIjzXAT9RQuErIthIfSiZThmAFRtfGuP8MrjfjTbk220F9NB4m9iRMNbIyI/cwRqavBFtg5E3tw5/+OSuK9L6bu5ZEGl4MlWwbiT3mOKZxJQT8HBwM2srIVBSN+Udotm0ZZwLFpq0OG7wpGIJieB3OD3NuRzl9Z9j1+Vluo6XfOnqlnk/kPZhxMwIiZFtJpmBm4uSr5SOfBf8nPfcwy8jGVSrEXogClB5dIUbvBP3qA9bm++zoZn4E1szS2EHYMx31/wgDuWA54SzZWltpXsz0JJFJgwVjNnbDSc74AgSVs++/P7xCTD1bI+N1aug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------EM4uW1evflvUIpHMy0e9UjZp
Content-Type: multipart/mixed; boundary="------------Yi2633bQOqoh05egSSnPXUpZ";
 protected-headers="v1"; hp="clear"
Message-ID: <b67abdc3-f234-49ce-b463-1e06e87eccf8@suse.com>
Date: Tue, 10 Nov 2026 08:25:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xen/events: replace page allocator calls with
 k[mz]alloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: David Hildenbrand <david@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, linux-mm@kvack.org, xen-devel@lists.xenproject.org,
 linux-kernel@vger.kernel.org
References: <20261110-b4-xen-v2-1-21ece28be7d4@kernel.org>
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
In-Reply-To: <20261110-b4-xen-v2-1-21ece28be7d4@kernel.org>

--------------Yi2633bQOqoh05egSSnPXUpZ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAuMTEuMjYgMDg6MTQsIE1pa2UgUmFwb3BvcnQgKE1pY3Jvc29mdCkgd3JvdGU6DQo+
IHNldF9ldnRjaG5fdG9faXJxKCkgYWxsb2NhdGVzIGEgcGFnZSBmb3IgdGhlIGV2ZW50IGNo
YW5uZWwgdG8gSVJRDQo+IG51bWJlciBzb2Z0d2FyZSBsb29rdXAgdGFibGUgYW5kIHhlbl9p
bml0X0lSUSgpIGFsbG9jYXRlcyB0aGUgUElSUSBFT0kNCj4gYml0bWFwIHRoYXQgaXMgcmVn
aXN0ZXJlZCB3aXRoIHRoZSBoeXBlcnZpc29yIGluIFBWIGRvbWFpbnMuDQo+IA0KPiBUaGVz
ZSBidWZmZXJzIGNhbiBiZSBhbGxvY2F0ZWQgd2l0aCBrbWFsbG9jKCkgYXMgdGhlcmUncyBu
b3RoaW5nIHNwZWNpYWwNCj4gYWJvdXQgdGhlbSB0byBnbyBkaXJlY3RseSB0byB0aGUgcGFn
ZSBhbGxvY2F0b3IuIFRoZSBQSVJRIEVPSSBiaXRtYXAgaXMNCj4gcGFzc2VkIHRvIHRoZSBo
eXBlcnZpc29yIGJ5IGl0cyBmcmFtZSBudW1iZXIgYW5kIG11c3Qgb2NjdXB5IGEgd2hvbGUN
Cj4gcGFnZSwgd2hpY2ggaXMgZ3VhcmFudGVlZCBmb3IgYSBQQUdFX1NJWkUga21hbGxvYygp
IGFsbG9jYXRpb24gYXMgaXQgaXMNCj4gbmF0dXJhbGx5IGFsaWduZWQuDQo+IA0KPiBrbWFs
bG9jKCkgcHJvdmlkZXMgYSBiZXR0ZXIgQVBJIHRoYXQgZG9lcyBub3QgcmVxdWlyZSB1Z2x5
IGNhc3RzIGFuZA0KPiBrZnJlZSgpIGRvZXMgbm90IG5lZWQgdG8ga25vdyB0aGUgc2l6ZSBv
ZiB0aGUgZnJlZWQgb2JqZWN0Lg0KPiANCj4gUGVyZm9ybWFuY2UgZGlmZmVyZW5jZSBiZXR3
ZWVuIGttYWxsb2MoKSBhbmQgX19nZXRfZnJlZV9wYWdlcygpIGlzIG5vdA0KPiBtZWFzdXJh
YmxlIGFzIGJvdGggYWxsb2NhdG9ycyB0YWtlIGFuIG9iamVjdC9wYWdlIGZyb20gYSBwZXIt
Q1BVIGxpc3QgZm9yDQo+IGZhc3QgcGF0aCBhbGxvY2F0aW9ucy4NCj4gDQo+IEZvciB0aGUg
c2xvdyBwYXRoIHRoZSBwZXJmb3JtYW5jZSBpcyBhbnl3YXkgZGV0ZXJtaW5lZCBieSB0aGUg
YW1vdW50IG9mDQo+IHJlY2xhaW0gaW52b2x2ZWQgcmF0aGVyIHRoYW4gYnkgd2hhdCBhbGxv
Y2F0b3IgaXMgdXNlZC4NCj4gDQo+IFJlcGxhY2UgdXNlIG9mIF9fZ2V0X2ZyZWVfcGFnZXMo
KSB3aXRoIGttYWxsb2MoKSwgX19nZXRfZnJlZV9wYWdlKCkgd2l0aA0KPiBfX0dGUF9aRVJP
IHdpdGgga3phbGxvYygpIGFuZCBmcmVlX3BhZ2Vbc10oKSB3aXRoIGtmcmVlKCkuDQo+IA0K
PiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvNjM1NDA1ZTQtOTQyMy00YTI1
LWE2ZTctZTAzYzhlYTBiY2JlQHJlZGhhdC5jb20NCj4gU2lnbmVkLW9mZi1ieTogTWlrZSBS
YXBvcG9ydCAoTWljcm9zb2Z0KSA8cnBwdEBrZXJuZWwub3JnPg0KUmV2aWV3ZWQtYnk6IEp1
ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCg0KDQpKdWVyZ2VuDQo=

--------------Yi2633bQOqoh05egSSnPXUpZ--

--------------EM4uW1evflvUIpHMy0e9UjZp
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmryxwcFAwAAAAAACgkQsN6d1ii/Ey+K
AAf8C1MTN/9OTck7FwQ3t4PikfL6XxlBCTguh5pnn+XNtKkgbFvaAl26KbqsNDq4Egql3ZmgZZWC
paO5EYc8G75rASCelZYAQfSQKB3nTpgwiayf5hMeng2ctPr5OIgyyyio+dv/1CxtW/LHXR9KLfVw
5R+HkZRUjZ1yHvS5+lVN15yGXa93Ieul1NfGzmjSPBKfNobHPKLiUo3QIu8s+KTPcSDmaktt99lr
iH738+5hCNflKljXbvBlxRByHIlTSQ6UgINKd3G8zwt1cRPf+4wMgtJ0d2riY2wAq7K9pg23xMsp
1BbUY9oLWgVcH0jorlzfwPHe7TUbICLgc3iQLsAopg==
=dDBY
-----END PGP SIGNATURE-----

--------------EM4uW1evflvUIpHMy0e9UjZp--

