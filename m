Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C7C606A681
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=aq4t5SwR
Received: by kanga.kvack.org (Postfix)
	id D66AD6B073F; Tue, 24 Nov 2026 10:14:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3E836B0741; Tue, 24 Nov 2026 10:14:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D886B0742; Tue, 24 Nov 2026 10:14:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9ABE96B073F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:14:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E709120BB4
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:14:26 +0000 (UTC)
X-FDA: 85470358932.29.B730AEE
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3ED631A000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:14:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aq4t5SwR;
	spf=pass (imf19.hostedemail.com: domain of jgross@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795533264;
	b=RZvYpN0dnUxmK22F1a4Xs705p1w8c8YiUAcX5mXGAn3m9W6BtZgZD4tYmM/od+BKwjBgJK
	sqLgHTpEexFHM3qABhoW0T/5pOqDt9/2s+dkjJ/K7SodznKMDrrZY08x9ElkO2ypYWNJnS
	y2XYWyz6kaEvIg9vxjseuByBfElZ7/A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795533264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVJS6gkYs1IOy2J1QEN8soh2l1ljp7ZJVoiYPlTtrQ8=;
	b=D3DytjPy1K4t83BSlmX6BTAAbKaIeqcxF99R7lPNfIyqZBKj8O3SRno/cfIMq67lzAsd+/
	jO8zwGW1pYkwcLMaMrBqkIbfkwsqRApIV7TmVTOYb/p/s43G3d7JW7FCEWlGnednhMqGtm
	5iFsZriXODReJKNGfhZ8aD7he3v3xNo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=aq4t5SwR;
	spf=pass (imf19.hostedemail.com: domain of jgross@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4395d31228so790311866b.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795533263; x=1796138063; darn=kvack.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PVJS6gkYs1IOy2J1QEN8soh2l1ljp7ZJVoiYPlTtrQ8=;
        b=aq4t5SwRg0EWfe6et4PEls5XT4rW/dhp5DRGA5mb2on6xXvfr8rq14g8bsNmLgupmM
         svVEWqCizsIcgtHYaRuEdTj8joCvVzduHSXfZW5XF+ZoNJUz1gf/Ef8+BXA2/8GiFa0S
         dGmLHTBE+3tKT1tKb8XBIXcacITblLTmeTpmDDH6GLk8ZfFaxqydMLgH97i7508EqZXn
         tGhVlRtODnC7Wzt9CNqdKfXKN2d9q62LBKIo6sM75d3tQwbfwe69q2HIc+OACCiLeGTW
         qh95Sz4PFFEtzdO5W9hQkxrwrQBt6g9KpKiI/VrMG/z5ETyrAbE96GKKH2lGVrN+DXx3
         dxAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795533263; x=1796138063;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PVJS6gkYs1IOy2J1QEN8soh2l1ljp7ZJVoiYPlTtrQ8=;
        b=HN2H7dRwTPh8KY/dJZR49h+/muqD1Wz0LZTcd8u6dV7r2DLp8G1+HAKxF1n5pTnffE
         Zr/OC9JpkqNDAXuEYG693MvMBouLnPgjF5P/dQG2CT77pDkuVcgIrcxXoLMXnagXOJTJ
         F8hFZdh+sLeJsUZVn/N/CWXuyR04yQ+SP+g3xvf/bFIahgQrphQS7WaddAS9vpGuKr0l
         rFRJGJjiVGWNc6bN36LgMDWd3SgyeNPpJTXE3dS87KhdGRggt0TFi0xLAlJGWVsR0b6Q
         C4CyP07Jr5XCz0WH6qxhGFiD/z9wwjcu4T8T8XYUEw6RA84ViCccw6V1WgjTUDK7EcfN
         1ieg==
X-Forwarded-Encrypted: i=1; AL+hErGafbuJ21fYkKohZssCZ4ed7LON2cyjjqU4FNkjQnDcJFWFyvuMrXL1fSUx7CsRitmJDX1WWkBY4g==@kvack.org
X-Gm-Message-State: APuU4Z8hkym4CczYnAr3mNXWFRnUIVGmRVLZCe8IxG3c80iHtCOFqi2v
	4qNYfyatmd7JWPDlUL+y001roQr7eWB+7R6UfidCh3gLGF3FakuNTw4xAqxXWc39WV0=
X-Gm-Gg: AZFdTZefBcfqZaeiGo46iUQrKQ/OPlSqZrJBkeLr65IOUEFgLqmJuXyAwkfZfsJnw+H
	AiTrOcFkwOfi04B/nau1TFeyEuzCWBZxNayvEmESUhSvRBxWdevWT06Ksqn7fvUddeK3bTtbGMU
	yQtS/Y/txPdtnkat0OlA3RAP0RHQQKCY4eY05fVP1VSOyhNXW4nkPQB9uaWbiaDkhlEasb8W9Mm
	VvGxU74Om/yVIKy+CtHzagpb0UczXAE78hsOzIwBkRFIIqZalJpv/9+v82osVqbR7QADXOQZDCW
	Ss+SyJV9Wb2SXpg/vaubYysuX0H1vmWYsL+7+HG+BaG9U4RhGXyx23zXM0u51t/610xmOW/kICw
	ycS6jgt7yYURtRmO5wC8iQvcvVKdRb/swfI+No8gsFiNHzE8tYcnxgXHzCg9Iq/BKcgyxYWnSE8
	CXzPZi9YiT26D38ACkTZLSCvEA0GWtZ4yRXibDu9YKO3XYkGkvtctsPK0KMUqq6ScbfQzn2IuIL
	LD470y2jF3BlmhzajX+UE61jqbpBykqoF5DjB6Z1YMg+GUCcduHesjrTx7rtL0hAPjm0C8dNHsG
	D/qlR3LDRSXvHcm6vNoQEIZ4FiWR4gLTpRyHl+jnnrpjhjlwSVEfKCukE1k1fSIZ+hmb9ZBdYPf
	F23tUAtiTky4mjOY5ZO8OhX5aXs7icfdu9x3qUWvVPEVYqcl6qpU=
X-Received: by 2002:a17:906:c14b:b0:c35:babe:ab44 with SMTP id a640c23a62f3a-c513a1e0076mr1490288666b.0.1795533262820;
        Tue, 24 Nov 2026 07:14:22 -0800 (PST)
Received: from ?IPV6:2a00:12d0:afa3:c01:92cc:e257:77ba:97a1? (2a00-12d0-afa3-c01-92cc-e257-77ba-97a1.ip.tng.de. [2a00:12d0:afa3:c01:92cc:e257:77ba:97a1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513ae698ccsm534442066b.26.2026.11.24.07.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 07:14:22 -0800 (PST)
Message-ID: <589d567e-912d-4913-9949-ee28dfd7f719@suse.com>
Date: Tue, 24 Nov 2026 16:14:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/13] xen: convert xenstore interface mmap hooks to
 mmap_prepare
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowangio@gmail.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>,
 Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
 Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>,
 Ryan Chen <ryan_chen@aspeedtech.com>, Billy Tsai
 <billy_tsai@aspeedtech.com>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>,
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>,
 Scott Branden <scott.branden@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Richard Cochran <richardcochran@gmail.com>,
 David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-sgx@vger.kernel.org, selinux@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org,
 linux-arm-msm@vger.kernel.org, op-tee@lists.trustedfirmware.org,
 netdev@vger.kernel.org, linux-mm@kvack.org
References: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
 <20261124-late-2026-mmap_prepare-v2-7-0b0d99d655f9@kernel.org>
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
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-7-0b0d99d655f9@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------rZw0QHKmzMvHx5VSPSOUKur0"
X-Stat-Signature: 37punm3ik6rk6fm35gwryxpa89mmxpeu
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3ED631A000D
X-HE-Tag: 1795533264-75787
X-HE-Meta: U2FsdGVkX19vHly1KNz7bOb08XKnhqXvb53ULoyEPiTSiKY0oLK6bZEQa6VnZzlxpWGNqGlPAab7Nlj1QY0q4L/6Yj05vFj7NCl8LIjsA9aKrZxW8N2JSEG7A1qDTHk539GdCUlyDGtzibolp8NwiL4J/om3MBXInmJPXjdNqloqJMEYurClgjfThXawS0SZZLd3KcPXMwKo2yluTWOeryG3fd9MLIGYI8qnDIoT6DutrdAX2QXERwHDLcoUtX2Rk6kQPfN6klHyU/ipUTLj/YyPxrOHgUaA4Y1mEDQexWGZH/ipOeCekNPJ3lBAHz9kc35ErK1kYht1TbO70B7SpahpJrY2w5yy9OPJVOwEoTdh8divHkaDrYq9SFo53EKQFt4z9YKuzJYEQalQqaPxDkm/+Lhb1BevM24jX9CMebUeovxhTVPC51N2qnedS7JEOrNXAmHz0F+rpsNr+rTBSLh4EbqrijHqL/Bed46qQx75Ulm/VcVO/a4uO2fdgaIA3j2k0or4Hn3w72kDd3vaUhLFyAYdKzRCLoGJltK5CD6kkaNM5SD90DRWfaxSpFVG8thgCvEq6JnTBqF/koMyNHj6+MfbGRnMFwm3qNareM55t0g7Uvd/46NUJYKxyHUYjGYLOKfLjWQrYlcYoHVvMUU6il8RGbdgE64tPAH7z9kg+GhByZxvFBCHJSNQ51kPua4L+jP8am0ZcYjfjgOjTO23mfPg/56KBIMZkjDhlQzJci4s4UQ/tfilNPO9wEa7SyBOre+0O2DRyao2f06VB21EH5ALgWxiGwWeooizamMMBGDt2Iw6SD6CoykUeY2UUFvyQbTElTQTGWH4dlcaYoM0p28H3iZOd8O0numukgs7B/ZdYAKi12BoTb3UggLkMzk/SViLTq2wxAG3ncdHLs+j6PJLPFGzaslJtEPLtcLWLg31gpxR3XSrKB9sUxho9WgS1wAV+x7zI5m/tmC
 QiMIOe0a
 pbvXUM5iARPLVJbQKBABylpRBtrEXVWJORNYGsX8/G0wmrjsqEpNUYJKsP2D4dKBinS4KZqwzb7t+pPFcdnW3fuAv7pHmVuftieNct4mBNJnIedWwrlOcR4F4BmSwJVw22U7eVhLdrHkF06Aq7R1ZhNwfb5LiPpTMyxi0cPeJ+MqxftrMssIIqJ/8noIaVqRju9mx/j1m1RGpgN4dAJxLcN48S/MIqx18whU96zUfnmGty8rqqjshtGW7Y4I39JtxKzEOWg++miGvgBgZCA1+7bZnFp5vpKmuKDpoAwOKuWTlum5hCLnB9DSRDkq1sPTuixl/hrJ+JU+OcFpfR6WfWuuvQpmItLbUlYSqK6OslDKLzYCvfd1Kqc3Dr9c2wGIIMWeR7kN5H/R7qw8XwHAWF6TOgYNmoUEOFcBgyebI1E8+iCDJNxfzw2VajMMYVsqpbvdG33sMk+DWP00qmoWxcdyMJmeGJZI+wq1xz3L8ab6k6LvkfI+Jy339P6J94d4reTaV+8NZmIxdYxG7Adj7cARjNEW/7xWU5zuNuqL8u6Z1y+0dMPDoXcHYGCe6aw5tw/lqjQqZOtsc2mqqsZ5zXx4wo0UXZdTFw7Gcku6vEnwfSJe+AHzeYJhUyeezt9w1X7euQTkNtPxINtTwx4y/kP94ZkBFBDz3uzwJldp3zy3UWR87+tVH8Jjo4DkxreW7oUNe0kEvFnjFgl4YAr4HYm+Ejbs+BtXZRrkVQblIzgvgeNMvJCx7rGkeSYukcXaau4KUE18mOBF8hnz+AQGETK1cT9Q3roSsukt/AR+ba3reT+Z71VY8lyOtq3a3wETBOzk/oZJRw166JlVcLGyloHx+xKjO0FAkLVl9CBVLzIpfKR1x2aXD8TcVHPFAWmE5EUHU5+Fi4D7xqr2p+NtImtMfdSvtsjcfePc6PDYuzwDNXR8IaimK+NmzxReZmwWFVfKiHekgbCJU8GbI/8Ua8YRKfw4b
 sF8g2yFL
 h5onCZx1ahzrvWeX+xuH9IX7w2yUbutCyWn8/p895TUHV5uXJHAMgFKuO46J1jsCre662m6zAGrlWOqityTxuDO0O05xdgUYMcPbvTpmobT6w03C8E7vkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------rZw0QHKmzMvHx5VSPSOUKur0
Content-Type: multipart/mixed; boundary="------------1hIkmj8WyEEdRHjB5CXVAQ0q";
 protected-headers="v1"; hp="clear"
Message-ID: <589d567e-912d-4913-9949-ee28dfd7f719@suse.com>
Date: Tue, 24 Nov 2026 16:14:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/13] xen: convert xenstore interface mmap hooks to
 mmap_prepare
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowangio@gmail.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>,
 Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
 Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>,
 Ryan Chen <ryan_chen@aspeedtech.com>, Billy Tsai
 <billy_tsai@aspeedtech.com>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>,
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>,
 Scott Branden <scott.branden@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Richard Cochran <richardcochran@gmail.com>,
 David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-sgx@vger.kernel.org, selinux@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org,
 linux-arm-msm@vger.kernel.org, op-tee@lists.trustedfirmware.org,
 netdev@vger.kernel.org, linux-mm@kvack.org
References: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
 <20261124-late-2026-mmap_prepare-v2-7-0b0d99d655f9@kernel.org>
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
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-7-0b0d99d655f9@kernel.org>

--------------1hIkmj8WyEEdRHjB5CXVAQ0q
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjQuMTEuMjYgMTU6MDIsIExvcmVuem8gU3RvYWtlcyAoQVJNKSB3cm90ZToNCj4gTW92
ZSBmcm9tIHRoZSBkZXByZWNhdGVkIG1tYXAgaG9vayB0byB0aGUgbmV3IG1tYXBfcHJlcGFy
ZSBob29rIGZvciB0aGUNCj4geGVuZnMgeHNkX2t2YSBmaWxlIGFuZCB0aGUgeGVuYnVzX2Jh
Y2tlbmQgZGV2aWNlLCBib3RoIG9mIHdoaWNoIHJlbWFwIHRoZQ0KPiB4ZW5zdG9yZSBpbnRl
cmZhY2UgcGFnZS4NCj4gDQo+IFVzZSB0aGUgUEZOIHJlbWFwIG1tYXAgYWN0aW9uIHRvIGRv
IHNvLCByZXRhaW5pbmcgdGhlIC1FQUdBSU4gZXJyb3Igb24NCj4gZmFpbHVyZSB2aWEgdGhl
IGFjdGlvbiBlcnJvciBvdmVycmlkZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IExvcmVuem8g
U3RvYWtlcyAoQVJNKSA8bGpzQGtlcm5lbC5vcmc+DQpBY2tlZC1ieTogSnVlcmdlbiBHcm9z
cyA8amdyb3NzQHN1c2UuY29tPg0KDQoNCkp1ZXJnZW4NCg==

--------------1hIkmj8WyEEdRHjB5CXVAQ0q--

--------------rZw0QHKmzMvHx5VSPSOUKur0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmsFqc0FAwAAAAAACgkQsN6d1ii/Ey8U
agf9EKmbZX8l548UDsdyJg6oJvCYHOXjuS/ExKBuNpmGhFgk7GREMY+3u3PwwH5i8jr55bbeWohR
PQZmJLsVx91G2Go2UnTECf+ux5hcQK/L88QRCcbKXHLPL5o2jl4qSVtCpjc4+Zq8UulQYIwYP35a
OS34bD2osQ81MOzn9C89cW+1W2vyw6436TybryP/f0H8AtinZ/cTr3yFyQO/tR2V2NBHtEzwqslP
jNDjxr1xdpiDdCL4jZ8rdh7WfCE5cgGr89hzbDR9ZyzH4ka8x2ICUX++Mym777GSOuxLf3wzSPuW
OkTRlKQEHsYqdVjYj7TAHGOBC56IwBlTfAmWefOR2g==
=vFml
-----END PGP SIGNATURE-----

--------------rZw0QHKmzMvHx5VSPSOUKur0--

