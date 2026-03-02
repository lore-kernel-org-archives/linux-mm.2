Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1878EA4E21
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C18A6B0005; Mon,  2 Mar 2026 10:21:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375796B0088; Mon,  2 Mar 2026 10:21:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 274716B0095; Mon,  2 Mar 2026 10:21:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15B136B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:21:51 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3EE51C10D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:21:50 +0000 (UTC)
X-FDA: 84501487980.02.40421A4
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5CE442000C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:21:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Fi+5uedU;
	spf=pass (imf03.hostedemail.com: domain of jgross@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772464908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETlvC185db5TbfgIdZN3woKwjLCVJdZ9mMDN+oYJ5tI=;
	b=JKNEMG07EmKJJVyehF8SYL3CMibVTaQ9wY6xe8UIU95jvijnWaRXAJEpd2m/7MdeVRaZ09
	xRj+QJEK9p+HQaxyRALrhBx4BecmyOLKasPFLaD0LUkH29g4lJakKGPCNoA2EJshCyY8lr
	hWgzYpeqLOBQigNakqqrgf/ZP4sxb8w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Fi+5uedU;
	spf=pass (imf03.hostedemail.com: domain of jgross@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772464908; a=rsa-sha256;
	cv=none;
	b=XEjNj4jDn4anTfSVgWQi/2/6RfR7NZtTNcwJPijnRLLhmq1uSiqhdgdi98Gd7YMfvz/flE
	Fdk+oZdacr57Pasz3hFU6YClGmbD6nKVsNMjK8VYwg/6P1wOGGqC4ejQ2pG47FpGXtQmbz
	svYxIv7V0PfE1J+J1/Qjh8cEVBUrMCU=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4837584120eso33136345e9.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 07:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772464907; x=1773069707; darn=kvack.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ETlvC185db5TbfgIdZN3woKwjLCVJdZ9mMDN+oYJ5tI=;
        b=Fi+5uedUI3/gNy2pLMxw1oW2DKwvrSeghkqgWG5dg1nQ+IJ13nViEKLF8g2eQ2yOp5
         MEh66eceN/AZBrLyCRbA8s2036dh9bm3wJ+LAtwoHvfnUiZHQvqNMVc6fm5pqWzA+/Vi
         YkUPd36qGhPzL2I9qDxEVjP3v/IxG7xKjAvfT5lPn7zBgRRLy2Y0iCWvtnxpA3FVWx+x
         Vwc57QOCkwRkBnA8Rg6n4Akvtekh62YDfQZuvv6sZp27RdaQKg0QKtx4NZOdxNO2SR/9
         QaL97dYr9T1/rYoX7WA2YLEwy94nvubKHdswwQ3vLdlhd2Ru5my39pySkrFgo0NZ/nmF
         GiWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772464907; x=1773069707;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ETlvC185db5TbfgIdZN3woKwjLCVJdZ9mMDN+oYJ5tI=;
        b=HWEqfNXM3JjLPoxzxVrWDblw1EAhez+gMA8YqpaDo5o20xFL/Fn778S/R/4V+13Yl3
         zdtH+xWsk96AuXeL7Qs+anBqiNkrayBndM0Xqmrt7LsN43yWJ9U/Z5o7gdghcq4/9ciz
         H+Y3z1k7gIr044LsLBaSMaz8TWUc1twBSZE+FsbDnblr1sRmklqI9h9EJoh9v5F/c/Ae
         +4RVL9w8p++TEfi9oJ9olMEmEggrl4hcobPVXTU/v5epcIfQnO7jmx524swhvjLydPwh
         JKTTs0RjDBRf3/z4ZrHaX9e/L8MN5IxwRgWX9/RqzVxiCBGcZd3A0X3ju8DcwL7mSUvy
         H/yg==
X-Forwarded-Encrypted: i=1; AJvYcCUrBg1Sxp3VErbc1WB+ktPanjeJ26xdG+lmR+/aLFwECg7dHtYO65VZCVUrECQET6DlnmWTkdtFeA==@kvack.org
X-Gm-Message-State: AOJu0YyyGoQKW7NO6dUz46msNLp3Tp2y0EYsG+Ftt9HSrLGJLotcyAWE
	a1SfiRPBINzU7cePGOpJ620s+/Tv3JYdNXFiZcnMdD74Cb1LcHx7FECzU9dWxqBfwFM=
X-Gm-Gg: ATEYQzy211fwSmAJE/T6xNKpuS0D3NK3WFihbJlZ+cryoj1qHWwff2d8kSruP0cRYIg
	X3AOnI9EvSLeDpRd0AC6dOVeARSkLE1hiIqY/GHKCBTK0eG3MXHqh1+eP7A5C1NmhjTEFkVElW3
	YDzLxVn6X6uEXTms71GEiWY4tvqHQoUkR60JUTKUrXeXo67DElXa+TmU7/+vQxhbWTowNfEOs53
	Ue0Shal82AydkBAwiiLznAVwZbkDQvZlP/rgRF0bcKroZEzUInmzlSMvwZta4lQKPucsGqTB6ZI
	GUnB8PuT4KfWSG1h48VotyMbTaWCPHCZZeAPORJWpT2s1Gcnskr3jtJ1f2VeGGMdWVddWTpKqPA
	VN1rESrf0ChvA8Fj9DVrt5F+Rnp+A/ufDY6tBKnIko39Ett8+aAMBUMsKLMMUzmwJFQ7vr8qnEI
	lTChIR8j+nooJEOAofLY6n65W53sQVEfDijcOQrOIf9SURUrZGGTNAnndac34U3Idze5FPFASgK
	tkpV3PrzSmh04w2vFPh0bA+Z5W0JEdy3nFLcloNVTcyZKziYbqZSUZaXCO18MsJ
X-Received: by 2002:a05:600c:1e89:b0:483:badb:618b with SMTP id 5b1f17b1804b1-483c9bc55e1mr209049255e9.24.1772464906439;
        Mon, 02 Mar 2026 07:21:46 -0800 (PST)
Received: from ?IPV6:2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112? (2a00-12d0-af5d-ad01-5d3f-14e6-9bcb-5112.ip.tng.de. [2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd75df9fsm491001415e9.13.2026.03.02.07.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 07:21:46 -0800 (PST)
Message-ID: <9d30d9ea-c080-45ff-a77d-30f79d4e800e@suse.com>
Date: Mon, 2 Mar 2026 16:21:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Excluding init_on_free for pages for initial balloon down (Xen)
To: =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: xen-devel <xen-devel@lists.xenproject.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 linux-mm@kvack.org
References: <aaRVcVmtv2UBD-GF@mail-itl>
 <513e624f-35c1-4d43-ba3f-c96af613d400@suse.com>
 <224968e6-7236-4efe-bcc0-ab39ac0c6c45@kernel.org> <aaVuB3x3y4ROr5XA@mail-itl>
 <663cff60-8181-4a47-beff-204bfe01bb06@kernel.org> <aaWohimzb5P8n0YU@mail-itl>
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
In-Reply-To: <aaWohimzb5P8n0YU@mail-itl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------y09wBeURikoDRh6YDGjmJ4El"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CE442000C
X-Stat-Signature: jxjhd9qroxtimhr3zpjuwyntx7wxxxiy
X-Rspam-User: 
X-HE-Tag: 1772464908-626358
X-HE-Meta: U2FsdGVkX1+Ypc+NPaKdWMo0P4Yapo/Q7ZBZudPP+5HfV0CgEvfrzlirYlUJhHjDbx3fd7UWvrmpDZFvhzfpNLSNlZgYLZTzXxFfuOjyCb6ALsfmOHImw7vyflLmuCp6+d9c/fxWgovll6LeHzatIyseScLlozS/p9Y1hY7ErEqXZe3g+gXVHPHmqQYXsszhh25QgMHOJxRaF9oMfR8kisx9i776tO4axkXiI4qamGGkh6S+yNM9oUnK9vSPBY7KBX1FlBjonG009W2/O3+Habwkh8j1H7pmdO5jSbVpmJhPnSo1FNzJvtDEE83cFz6e8FwMzEDqRKc2s5g1e5o/P5jEUcyUUUCQ+Pog2h2ySCG7QUIydGo8p9kyCjE/Nrzd9Np3Q5BQRv3SihE25LCPtmKlDKmvniId71oG5W0dKc0P/Zx8yZIwhzFFkU7AOnLK+ngwnTeZ+Bf3bGAuRiBZ4g2++ndERJJHSlifPI5JOFNG+L/nC/WD4iO69ERMWJ2yqebItCuu4apfjphOsYKE7Z7XZ66iAH7Ni08ezqJ/wEtSuoAi8/qWKT2ZWoAuxLvnfu8tY0yoSQfcLLJeUkkZhaaNptnQ+DmCevacMCbnZ+i4njrnF5sKBysEsMKzIF7elb2C/HWiNCGIYMfwbQIDLzcC/WOZfByb4U+s3wpNzalIzcFS91u3M4OZZEgo39xbNA99wW9a8pApcc0G9fbHfxr5iXTEckdHaFOsudCRbz7pI1nUuRNbyWLxuU6OvA5ytj+/fTA+2F9JlN33LTfgmB2SCT3kUdtYvJ5teIbRtSORWOB6T9mq2yPcvXvpY2U+dh1l3rOucoAdE/x5fWvZmBZEWLvUhSNbyxvt53ybEr+dlvcqHzAOu+7U0As5h3LknhhQqfv+Uitra0Fv28arC+FX5z5Co6lFe8sKWwCq9HsnJg3uAsgVfM1rmidM3pgp3B4nZdGSnYDp7ztf9+t
 WoCvlQ97
 K/bWfoR+OGynYxjekjfShSqCY7TIkajvoH0KE3Sr/uCQ4Vrii9UFb3J3jJ3Lui+ZgmwLf9dXMm9dVpfXqw/A3xRBJ2SFhRl34FaupoRR6DYHi7zYL+sUaxP/Ng3RxeZcdbrD23a1T3SqIrd+hdYMX/xgRJxTGwslDkdgDpm5/WjszpLShxpgUda2mfURap7HBgqa5fmhhX/oQbMq6LnlvIxJpgmRi+P4vYUVY5WV6LTQ1eSScWnQn5mEQm2SWIbndLdyzUIYxn7MEP/sMKoTr5jBWybegyw//jyl1x9GZ3L9ThKKb2uk6CY2EvV0wsPANbg0DDjjtHfTqZtIfPWtfBIYC/JZcpdGnG9a2DOaynSV0LuP0dDyUDdGNVKs9GimdKRRLXtWrsJyBcdUV2ik0Ut2PQM1Ybb/rCLWsUQ1Jweu9ttcFkAB9SwofdsXRxRM4QA0CueH9wK9hRfWfAfe9i6qpoUybeV50VsZZkhHfJnfdIVdW3PwJojGaTJ9UnaWO8NsO1csyngDNDva2f6IZA7F1qDIzgU/zGbwlMWPJAfKfWbLx5p1cenIeNgvwsaCkXcBD9kzweQ2V7B40V1XZh0uVIvWeYxa+hTzNUbM5DsAk5SBL/MNPRvt0oBGcCGXOUgZs5xpSCe9dfLEskK8obfrhvIdYmJ0+olhq8Ad2k0E8W1BdvRw9eNyNgWvSeh93vSOrXUuoFgLngB/agwZ/HsaBKfskmQCGnDol6qAtlbrE9MnP4/an4clyA0GbcJyklJ5iQHLq2jaDrwevFlQ3UDwTCAV1pWV2I7aalcAPpaqBKBTptwYgcQS8+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------y09wBeURikoDRh6YDGjmJ4El
Content-Type: multipart/mixed; boundary="------------e1DxIpki1MRw3sNDu0gCKGiO";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: xen-devel <xen-devel@lists.xenproject.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 linux-mm@kvack.org
Message-ID: <9d30d9ea-c080-45ff-a77d-30f79d4e800e@suse.com>
Subject: Re: Excluding init_on_free for pages for initial balloon down (Xen)
References: <aaRVcVmtv2UBD-GF@mail-itl>
 <513e624f-35c1-4d43-ba3f-c96af613d400@suse.com>
 <224968e6-7236-4efe-bcc0-ab39ac0c6c45@kernel.org> <aaVuB3x3y4ROr5XA@mail-itl>
 <663cff60-8181-4a47-beff-204bfe01bb06@kernel.org> <aaWohimzb5P8n0YU@mail-itl>
In-Reply-To: <aaWohimzb5P8n0YU@mail-itl>

--------------e1DxIpki1MRw3sNDu0gCKGiO
Content-Type: multipart/mixed; boundary="------------v5nbIR44GMrnBS70Yhw0f5mu"

--------------v5nbIR44GMrnBS70Yhw0f5mu
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDIuMDMuMjYgMTY6MTEsIE1hcmVrIE1hcmN6eWtvd3NraS1Hw7NyZWNraSB3cm90ZToN
Cj4gT24gTW9uLCBNYXIgMDIsIDIwMjYgYXQgMDM6NTQ6MTJQTSArMDEwMCwgRGF2aWQgSGls
ZGVuYnJhbmQgKEFybSkgd3JvdGU6DQo+Pj4NCj4+Pj4gV2hhdGV2ZXIgbGVhdmVzIHRoZSBi
dWRkeSBzaGFsbCBiZSB6ZXJvZWQgb3V0LiBJZiB0aGVyZSBpcyBhDQo+Pj4+IGRvdWJsZS16
ZXJvaW5nIGhhcHBlbiwgdGhlIGxhdHRlciBjb3VsZCBnZXQgb3B0aW1pemVkIG91dCBieSBj
aGVja2luZw0KPj4+PiBzb21ldGhpbmcgbGlrZSB1c2VyX2FsbG9jX25lZWRzX3plcm9pbmco
KS4NCj4+Pj4NCj4+Pj4gU2VlIG1tL2h1Z2VfbWVtb3J5LmM6dm1hX2FsbG9jX2Fub25fZm9s
aW9fcG1kKCkgYXMgYW4gZXhhbXBsZSB3aGVyZSB3ZQ0KPj4+PiBhdm9pZCBkb3VibGUtemVy
b2luZy4NCj4+Pg0KPj4+IEl0IGlzbid0IGp1c3QgcmVkdWNpbmcgZG91YmxlLXplcm9pbmcg
dG8gc2luZ2xlIHplcm9pbmcuIEl0J3MgYWJvdXQNCj4+PiBhdm9pZGluZyB6ZXJvaW5nIHN1
Y2ggcGFnZXMgYXQgYWxsLiBJZiBhIGRvbVUgaXMgc3RhcnRlZCB3aXRoDQo+Pj4gcG9wdWxh
dGUtb24tZGVtYW5kLCBtYW55IChzb21ldGltZXMgbW9zdCkgb2YgaXRzIHBhZ2VzIGFyZSBw
b3B1bGF0ZWQgaW4NCj4+PiBFUFQuIFRoZSBpZGVhIG9mIFBvRCBpcyB0byBzdGFydCBndWVz
dCB3aXRoIGhpZ2ggc3RhdGljIG1lbW9yeSBzaXplLCBidXQNCj4+PiBsb3cgYWN0dWFsIGFs
bG9jYXRpb24gYW5kIGZha2UgaXQgdW50aWwgYmFsbG9vbiBkcml2ZXIga2lja3MgaW4gYW5k
IG1ha2UNCj4+PiB0aGUgZG9tVSByZWFsbHkgbm90IHVzZSBtb3JlIHBhZ2VzIHRoYW4gaXQg
aGFzLiBXaGVuIGJhbGxvb24gZHJpdmVyIHRyeQ0KPj4+IHRvIHJldHVybiB0aG9zZSBwYWdl
cyB0byB0aGUgaHlwZXJ2aXNvciwgbm9ybWFsbHkgaXQgd291bGQganVzdCB0YWtlDQo+Pj4g
dW5hbGxvY2F0ZWQgcGFnZSBvbmUgYnkgb25lIGFuZCBtYWRlIExpbnV4IG5vdCB1c2UgdGhl
bS4gQnV0IGlmIF9hbnlfDQo+Pj4gemVyb2luZyBpcyBoYXBwZW5pbmcsIGVhY2ggcGFnZSBm
aXJzdCBuZWVkcyB0byBiZSBtYXBwZWQgdG8gdGhlIGd1ZXN0IGJ5DQo+Pj4gdGhlIGh5cGVy
dmlzb3IgKG9uZSB0cmlwIHRocm91Z2ggRVBUKSwganVzdCB0byBiZSByZW1vdmVkIGZyb20g
dGhlbSBhDQo+Pj4gbW9tZW50IGxhdGVyLi4uDQo+Pg0KPj4gVGhlIHNhbWUgaXMgdHJ1ZSBm
b3IgbW9zdCBiYWxsb29uIGRyaXZlcnMsIGluY2x1ZGluZyB2aXJ0aW8tYmFsbG9vbi4NCj4+
DQo+PiBTbyBmYXIgbm9ib2R5IHJlYWxseSBjYXJlZCBhYm91dCB0aGF0LCB0aG91Z2gsIGFz
IGluaXRfb25fZnJlZSB1c3VhbGx5DQo+PiBjb21lcyB3aXRoIHN1Y2ggYSBoaWdoIHBlcmZv
cm1hbmNlIHByaWNlIHRhZyB0aGF0IHBlb3BsZSBpbiBjaGVhcCBWTXMNCj4+ICh3aGVyZSB5
b3Ugb3ZlcmNvbW1pdCBldGMpIGRvbid0IGVuYWJsZSBpdC4NCj4+DQo+PiBfX0dGUF9CQUxM
T09OX09VVCBpcyBqdXN0IG5hc3R5Lg0KPj4NCj4+IFdlIGNvdWxkIHByb2JhYmx5IGhhdmUg
YSBzcGVjaWFsIGFsbG9jYXRpb24gaW50ZXJmYWNlIChub3QgZXhwb3NlZCB0bw0KPj4gYXJi
aXRyYXJ5IGtlcm5lbCBtb2R1bGVzKSBhbmQgaGF2ZSB0aGluZ3MgbGlrZSBtbS9iYWxsb29u
LmMgY29uc3VtZSB0aGF0Lg0KPj4NCj4+DQo+PiBJSVVDLCB4ZW4gYmFsbG9vbiBkb2VzIG5v
dCB1c2UgdGhlIG1lbW9yeSBiYWxsb29uIGluZnJhc3RydWN0dXJlLA0KPj4gdGhvdWdoLg0K
PiANCj4gSXMgdGhlcmUgc29tZSBmdW5kYW1lbnRhbCByZWFzb24gZm9yIHRoYXQ/IEJ5IGxv
b2tpbmcgYXQgdGhlIGNvZGUsIHRoZQ0KPiBtaWdyYXRpb24gdG8gdXNlIG1tL2JhbGxvb24u
YyBzaG91bGRuJ3QgYmUgdGhhdCBoYXJkIChmYW1vdXMgbGFzdA0KPiB3b3Jkcy4uLikuDQoN
Ckkgd2FudGVkIHRvIGRvIHRoYXQgZm9yIHllYXJzLCBidXQgLUVOT1RJTUUuDQoNClBhdGNo
ZXMgd2VsY29tZS4gOi0pDQoNCg0KSnVlcmdlbg0K
--------------v5nbIR44GMrnBS70Yhw0f5mu
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------v5nbIR44GMrnBS70Yhw0f5mu--

--------------e1DxIpki1MRw3sNDu0gCKGiO--

--------------y09wBeURikoDRh6YDGjmJ4El
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmmlqwkFAwAAAAAACgkQsN6d1ii/Ey9f
Fwf9EH3eVCcUPnLhmeZGvJl5wVYuyA8jurNChwHN0evqFezznfHweMatiP8h6+gtF0Xv0q9O8DzQ
WuEtAbBogZYxsRMqyRrqBhxLPZ5V9BxPF9/Vbw72Sgjm7s5R9jzXfqTKW5MkHnuvtdwTNZ8DKB0T
t8rRMZeJfoQgQ3BJ0g8kQemPWTjXTxdg+fI6xZTPtzfZBAzUoIIKG1NjPLC+j9UgBk3XdH6SnKXW
Oc1XcKeNQhLkkKUqSBN79tWoWtXU6o6t5rJEHHAAWFVadPuo0ihfTm+67VICHzVrogByCjsZsfEO
elF53pC3zyxFRXizLgr1tbyn+o5Jr+Piip8iCw1Z/g==
=Qr2j
-----END PGP SIGNATURE-----

--------------y09wBeURikoDRh6YDGjmJ4El--

