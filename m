Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59665CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 10:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFDB46B00A2; Mon,  8 Jun 2026 06:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD58C6B00A4; Mon,  8 Jun 2026 06:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EB196B00A5; Mon,  8 Jun 2026 06:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DAEE6B00A2
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:14:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 560761C2BCF
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:14:48 +0000 (UTC)
X-FDA: 84856336656.21.A3D24D5
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4F72F16000C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:14:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Dr2jh2Jv;
	spf=pass (imf08.hostedemail.com: domain of jgross@suse.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780913686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxBQAWC7FUeGTJNBfhWbQ+ZfQbJdlJJx+tZ9LegFXV0=;
	b=mA1258g1TgpSRUA7KTOQPS9GtIGVDQGsieEWW1Ix1A9wvMpiQw42lH+CBlpDYEDeENpNjs
	HfqjC1LuqWTwXUnqT6zE0kFOAZD7dmFcOrWUtqn/aCCj8OFdZ2lAr7z8Id7kMSZNV2DhXg
	2haY/IeBv50ap0OAQtYbS0pNlQejELo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780913686;
	b=GXEAW7ypSTy7u6zkyS7ajZmMf5pz9gTHxZJId+tF3Hp0vWqaMmzNoTR4s7PrrJ6f1zRgwD
	4Z4c7j6bDVLyADschtwf5iq3/BzRcPZMchRhr2AQXbc6OmeRFHHjNiYiyPILJVe7lmE+lA
	0Z7jNlqQycBCAabB/oHDj+e4DFxdIA0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Dr2jh2Jv;
	spf=pass (imf08.hostedemail.com: domain of jgross@suse.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bf0170c80f7so669577066b.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 03:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780913685; x=1781518485; darn=kvack.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nxBQAWC7FUeGTJNBfhWbQ+ZfQbJdlJJx+tZ9LegFXV0=;
        b=Dr2jh2JvQaK4efUDaIQrGjMJG1odBYGljL673VLAJwN0YR0FSX9Rgkvbej8cpi8jmu
         /pwI2E3JzRk0ub/njGsr8C5/GaxSzEgyZWUxNWnxuszLH24akox3xmXNJQRFFqCf8efp
         8FsYIrxbW2+FluVH/DM3wzixztVWgUsB8Sxwi2gNFsX0lOuSpzx/Q5oAsPPNzZAfnaax
         wOWdrZTWzq2boMcqT7x4mox+9/68z8KCTEoiSiXzNsiOe37Nz/nxPKGsZemYYjJWXhHG
         Gy4pwlNI3Sr3tJoDEY23TmfRdHYxcWeTkqlKF+LfqSQlX01f3n/SVqJ42jlpPMsj4f73
         L3OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780913685; x=1781518485;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nxBQAWC7FUeGTJNBfhWbQ+ZfQbJdlJJx+tZ9LegFXV0=;
        b=ktgDS/lqbGV/YgGuEdSzk1t1j8sUilb7k8UtqOS0Sgfd8uYC1EWAGdzZ86uP1WdleS
         Dxael2k9mrsy2Iw8Lx5Z7jVtWldJTb6oHSbeQNsj4hi4UgNdiBz67y6F7bpk2uTE2zw+
         CU0j9aoMC0GCutfC1XtoUOuhQX/rb66CJ1blk2jF8m2bAuZct8ko8zbNYB+r9E0EwlmJ
         /NnksSguqS90K+sBQYYYC0dS9bX3BiNQ1obnnI0Gh22aJF/had66EkG2CiWvD9A3GOpX
         oquNYTUhgxKu1YtQdhbwygoxV6p6IldiWs1t0wstAdqiUWqd3zgyXB1Xz4bZkXMIbksT
         L8aA==
X-Forwarded-Encrypted: i=1; AFNElJ9QFsLWbnb/pNdNYZIDmUgezBRtGCkFoTSI9w6MxxKIs74V7c9zN9DY5T9/1qz4ASS+Lb5+Cfgh1g==@kvack.org
X-Gm-Message-State: AOJu0YyG2x57tD/NCYVfn6qP5jVqHtCIZZgwRPOXpFlgcz24RypMCdnC
	8lw1ZLRokojqApBYswGLeelDEPZyAfHpkeo5Z5E76EXQSV2Q0Rrzs2YHo+v5DFViDdc=
X-Gm-Gg: Acq92OF8YSUGKpdqo+tFLik0SRIGMEduaiUVbpWBSDH60skaDHM36QHLEBkNi9JtSS8
	s9kk1GgIAwk72BNiF9EO681uR2lXsGCv0u9GNm5nG/Ayt2bdEx6hsxYkLM8Oynjgf0cAho1xaLr
	aF9N8CBH9ZmMGDx9RhdwjadtOKYtIiK/buM0KuYDCKgCFjYxk8gi6SfLBWgwB0rljCra7p1nuG+
	oYopFBL9HtcN0WiUyVn8YY4fUpZWHkhXi/ebbx6p21tGtMjaasFFHGHhMdfMU1rzlZvXajcvXkQ
	ZYeKTgQXi43Q2RD67POCnmNVrKdPydq8EfITv8AzR2LlzhBm6FlTSW8eD34wE/JNSi2FhVk8eWR
	nTfq1LZnswLlKneWWN2AcNkqsy/f721QMGJXL0iewsTL3prIYtXYcUVKGdJAG2Ds/9ljxUcvHKh
	WJkLCcUc5r23Mc0zk41IREWwy6IfBdZ6VNNORxvPOAygaRuvAE001U/tSNmqYIsIPnJt1pf7Xni
	g720CFqsp3iWdUmWwZNTE/AvuC9xFZb8zBLQzCk5IMkAsTGcfMn+MllLZ/94JMZ
X-Received: by 2002:a17:907:2803:b0:bec:228e:26e5 with SMTP id a640c23a62f3a-bf36fba1ed3mr502078366b.7.1780913684833;
        Mon, 08 Jun 2026 03:14:44 -0700 (PDT)
Received: from ?IPV6:2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112? (2a00-12d0-af5d-ad01-5d3f-14e6-9bcb-5112.ip.tng.de. [2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf0517721c2sm820999866b.3.2026.06.08.03.14.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 03:14:44 -0700 (PDT)
Message-ID: <0c1b9be8-258a-4f2f-bcdd-e8594ddc1aec@suse.com>
Date: Mon, 8 Jun 2026 12:14:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] x86/xen: Convert xen_mm_unpin_all() to ptdescs
To: Vishal Moola <vishal.moola@gmail.com>, Dave Hansen
 <dave.hansen@intel.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 xen-devel@lists.xenproject.org, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20260527140316.294621-1-vishal.moola@gmail.com>
 <20260527140316.294621-10-vishal.moola@gmail.com>
Content-Language: en-US
From: Juergen Gross <jgross@suse.com>
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
In-Reply-To: <20260527140316.294621-10-vishal.moola@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------15uZ9BCclmHdokGRSdMRESv0"
X-Rspamd-Queue-Id: 4F72F16000C
X-Rspam-User: 
X-Stat-Signature: dgrzmyowiprdy97rf3q9darkie9rdwg7
X-Rspamd-Server: rspam08
X-HE-Tag: 1780913686-353785
X-HE-Meta: U2FsdGVkX19mcJdzrdz3ZXOPX0cSMePcvNMhik+k0mxK4T60AQ8OvQN1KMjfFLTjhRU3SEXgKMKWgE8DdBxEXMWGqYWzMncR2DLsn1c/dKaFVOxdCiux6J+Ro0q/rjgsrOg5jtt2Zn5bWEeqQ9vV/rAacv14qRkCYjjwV23Cvvh5Hwy2odxJg8g7/A/leMPp6N0qIqQhfDjpWaLtQyMZfGU2bkX89ond0sMT5MaBL3Fd8sim3Ax3p/VA12fzkoKj2A+qC6q8kYxrS3oGS7h5dqG1GcftZ0z0siELd/AcDTdbSllegjHG07zzWaSh/TEZ1E9mQV8hyhM0MsK+mO1602Fx8LVb+vUiFE42GRDR9k+NZ6eaxGQfJjEzvCdbfE7DbQ8O9glXa2db+HnEqgQHST+58UMddOoodBSIqjrF1Pi233Ry+NdGRdQ1DTlu6YoCyTLtmzWx0MS7CfGHR08gga38ydD0ry1EUCpRtu5Ut37GGEE12QNRJe4oSJeozvtXODn4fcI+/vepmpo9fUcpqtvADTyr4NQvR+WIYuaR/ZSRKHlGLew56T41zso3vS7KFdnlrECq+5DXoxNLlTsMKztoAZ/NQ433L5NSVBbUCkwXvRpCq83uA98zGoX1/tpMUM+q4HpJJ45R1pbIwC8ufKumGBx0OJSCR8psvBcO6mboF5L8Ngu5bNrp5dN0ZdKuN91mF0Awq1HESPgnCGHRomxzsCbmgIL7OXdmTLiOY83ehOIdpjQq5J5/RYCoJlus2HTzpG/jFffgP9yCuPc4WfNb69wQCETeS4BHb3F8KkLc5MzoJRoqk8NKMaVncGoIwqfnJlq7XM+iaSZLkKDFsrCM6m2IPJ+wpXk7AsYqMU5h/A7h73ktJKXx4R+WUhVL66iY2c4lgl552GaW74GwGL0uYdCuuFCPVctAsFhW4foGOXfAfiIyHNG2brtow09amxI/r65s5IIHdyhNDDu
 YNLi3V1m
 81b6TEU2UGDWcIehAsTKn9FXsRJBfP3IWjtrfeZef8VA2Kn1f+2cUQCB6NmYAifDj6wvK1T0ZOxO6pBU3izX+Q/qr2f7JTAPwgU3dT8C98pnZ5tfHu2Z/t70HN+HDTRKKq4mz03bHnVLPO1p057fDyT1EVLzMv7G9i4k5o4yeziH0mMuCdT0jp40eLWXY4ewpiRO08DuQW+IAapsrJrNHXafY8CeNppIER6N1AX/y3hBqFX7bmIPiONYWmz5czXBM5VdgSA3ifx08zF+440ULPxoOVtU3Zpl96JlWvHjf7nsgU++qCpUqdi/ClWPUXZQVGuhWDdScODu1HWUk1+Ad33LRSkd3gs8s17T+S4xnG5yfmEzjCJWICMCYEtnUdpWqEYPEu0EpacpNtOcr2rZwrk4FqYb+Zk/OwjgHYyezR6KLfN9WppNnew0p38DaI0WEJqnWbzGtnDTFYG6Gs5VPYviZnhHqgO5wdwx/d930GIpVR3poVII2tuFtxUgHBXPyzTM/z5Mb7abRhkGq0/iAhRxnYHCgVskRcuzogwFEAr0RCTXPwC/vsuf6Zy0cQtl7j/NSd/YVyP2REQKslwWI5f0zwUDx7u3T8i3rXMDcRV5/0UaAAE+vALf3JZKtU48ZZA+40Xe08pPzvLEX7px4DdtILdfjlGRSamCFwOX9/QfXLAkK1bnX1bHWafig6/6ugVzv1x2tXdFLzptaeT91Udwro1QC1x1JkgmFb0TtXkJwlQOGvIPC6veqkyI6GUk7GWjX6uE46nO3U16tqq6InxRCbHPmp3Mg+SfoYm4jMEARmGHngFQGUYMX4+tJXvQsHKLF8PoUXp7wXSxwyeXTFoVEFqz7GOQZbNLemV8/7s1MwpXQnHMfDGQr/KQRyqUHExLHMVdtkBeFfWV7CfVo5aKuHMKocTiMqeUnXQ9eVbvuKAj3ZSF/uOitag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------15uZ9BCclmHdokGRSdMRESv0
Content-Type: multipart/mixed; boundary="------------0PH114zVSoGpQ4tBm8RXhOwi";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Vishal Moola <vishal.moola@gmail.com>, Dave Hansen
 <dave.hansen@intel.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 xen-devel@lists.xenproject.org, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <0c1b9be8-258a-4f2f-bcdd-e8594ddc1aec@suse.com>
Subject: Re: [PATCH 9/9] x86/xen: Convert xen_mm_unpin_all() to ptdescs
References: <20260527140316.294621-1-vishal.moola@gmail.com>
 <20260527140316.294621-10-vishal.moola@gmail.com>
In-Reply-To: <20260527140316.294621-10-vishal.moola@gmail.com>

--------------0PH114zVSoGpQ4tBm8RXhOwi
Content-Type: multipart/mixed; boundary="------------cXBNXfou8d7pbxhXUj79ph7U"

--------------cXBNXfou8d7pbxhXUj79ph7U
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjcuMDUuMjYgMTY6MDMsIFZpc2hhbCBNb29sYSB3cm90ZToNCj4gQ29udmVydCB4ZW5f
bW1fdW5waW5fYWxsKCkgdG8gcHRkZXNjcyBpbiBwcmVwYXJhdGlvbiBmb3IgdGhlIGV2ZW50
dWFsDQo+IHNwbGl0dGluZyBvZiBwdGRlc2NzIGZyb20gc3RydWN0IHBhZ2UuIENvbnRpbnVl
IGNoZWNraW5nIFBhZ2VQaW5uZWQNCj4gdGhyb3VnaCB0aGUgdW5kZXJseWluZyBwYWdlIGFz
IHdlIGRvIG5vdCBoYXZlIGEgcGVyLW1lbWRlc2MgYXBpIHlldC4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IFZpc2hhbCBNb29sYSA8dmlzaGFsLm1vb2xhQGdtYWlsLmNvbT4NCg0KUmV2aWV3
ZWQtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCg0KDQpKdWVyZ2VuDQo=

--------------cXBNXfou8d7pbxhXUj79ph7U
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------cXBNXfou8d7pbxhXUj79ph7U--

--------------0PH114zVSoGpQ4tBm8RXhOwi--

--------------15uZ9BCclmHdokGRSdMRESv0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmomlhQFAwAAAAAACgkQsN6d1ii/Ey+c
nggAiU7PaHe2GWgjkyU+bQ5XYfd8d3Vprzu2LSpdmXgf4mmpk8UqYrmnLF0AFoEDjbaWslVHE1g+
xDBDEVsmCV/vGoUc+3sGJTHTRq7VsAsLz/Gd4DxgZ2e2NeZpyqCAf9IhKimVZotTrYsP40ddDcAd
9YAxZkuc4oXiIvI0zqF76HzMExAMOkgfw3Vwsm9jT8fJDm/8DjvqFzFdR6aPjZidujNczaNrI611
6dpvLXmptPUhx5DlMh5ivijpquwYyBYmnGMPbccba7WuVAiCRyvVIO0Sj5k1tYcP+IEiHTvEu98X
6U7WslxT3SgqOowiWGAe9Jf8+QZLJ/+kGjnju8ODag==
=r6p4
-----END PGP SIGNATURE-----

--------------15uZ9BCclmHdokGRSdMRESv0--

