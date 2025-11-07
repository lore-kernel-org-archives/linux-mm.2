Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37DDECCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 15:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8978E0008; Fri,  7 Nov 2025 10:46:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AFB88E0002; Fri,  7 Nov 2025 10:46:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578258E0008; Fri,  7 Nov 2025 10:46:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41EC48E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:46:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 106881404F8
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:46:02 +0000 (UTC)
X-FDA: 84084236964.24.BDEC0B0
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id AF689C000C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:45:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Ay1ds8ug;
	spf=pass (imf10.hostedemail.com: domain of jgross@suse.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762530360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bo8hOLP5wIkBbrnuws1pinQ4AYj9Sz8IvZxz60kmJmU=;
	b=XgIrGX8AHIou2qkP4VZWMHjApKIeFK6/10YwGG3UdTh0v1+EG/J5Y6uabsrIYQNNwooVjp
	12fmMf+SikEUQwnFWRiUrz+srVJPZkbHfpvB/j/TwFnF1wgUygJ1ZVSEVbUZz6sCYnYdtq
	XI6d+zSAF8XGPWAlcTv/392yNOpUkXs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762530360; a=rsa-sha256;
	cv=none;
	b=W8mhlpjajaNHADFrSx77LgbxKm2chXviYPCzlYosR1S9pg4XJA0vaGZGL6tuSik1e7Ti5R
	KqLSgK43mObsM46ouFdDDGYHtLF7azvujyxDFsGzAjDHtx8oyRb2JngIx6jTklT6Pu1fEf
	/4xNYUNfX6U7cgVBrT9dL+QgUHhhnEk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Ay1ds8ug;
	spf=pass (imf10.hostedemail.com: domain of jgross@suse.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b64cdbb949cso169359266b.1
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 07:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762530358; x=1763135158; darn=kvack.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Bo8hOLP5wIkBbrnuws1pinQ4AYj9Sz8IvZxz60kmJmU=;
        b=Ay1ds8ugtglpfUNdoxzvTXDw4i5HYh45ObyFcftI/DCg3V+YirbYhG2B81gIz1op78
         ev+0HVJB9V/IP+NQ0iVwLRM3m465yuQ8I+P3z0hKHWFCTJV5a9seCXwDZmCF8upNawA4
         RhE2B7tLYFXJZVXwxVtj8Fe8fvVvs5bOI9vK+cK/AASPJ6VZvVEYiTHqghRk5HhquWwC
         fsTl/lyYEUqK4XIR5ueotB4OeBlV66ivqsEUokCaJ7apvHAxQ/Dgv5Epsh6kHKrxbhDu
         nwNSsvAfuVxiC/9NmsScaIaTsM4txJ0yERpTB8tlNgdFzKdftQdRb0Vpdjagy7n6VPia
         2o1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762530358; x=1763135158;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bo8hOLP5wIkBbrnuws1pinQ4AYj9Sz8IvZxz60kmJmU=;
        b=GFkoPNgT9uft/hhL1EPpIwU6d4A2udrapOe5BmlPE+0PbHBfKrJqnw/gvhj0CAtS8N
         /9BzoWJJi7TrH7jAtpD7+fXNbPRyOV5gyXl/SPk8CayUGTDrKNg9EcRbYPEFxQ6oHUV4
         ZdBqMR/GGTTMMnpPrFgqM+UofkgBzV8KRrzI6zBERj6Zv3TAEGhnjX4rY/gEJo4J1bRv
         rjWikfSwdURuDUycbarIvXOeLrxsPAWnvXW4vtTIQkS3pVGRmRTxKX/YZUy3YXi9TiyS
         5KysndJh3mvZBhpQH+21uLO2nOFdJPMPpb+XaY/O6Mw3NFmeSbZIaRqJZTSNJhWUppRj
         Ek4w==
X-Forwarded-Encrypted: i=1; AJvYcCXJ1mbVMtaVFNH1DRdGbt4IPkmIkd/fPKAaE/X/oscQKMVo7GLgO8NKaI6gcHUVUaMtRxBN6exVZA==@kvack.org
X-Gm-Message-State: AOJu0YzZZtqYufVH1McfTrQ2HZ+a+GC3iUKcHjjB4ej8i0NWrloWnhPn
	hAdt5Ngqe/+EP7D81zFUkJCeXDcPxlF2m1TrRaCKDT+AWZJEY09qym+u41q9Vv3TIyY=
X-Gm-Gg: ASbGnctAIebs7LcIY3e7BUzDmODuCiMptUY9IM+q3o5eaSkOluSeZVCgMoqqpmc+neB
	ZDg9UnOtujTd6bInTwpYSPgjzfq/kjrp8VXdjJIGOUpCmIjg/OCh/tvBeboUyUz+vej6tiHWxxn
	eZK51g6bDOvuPU7N7mQ9MxxqPoukWIWEWOBSL7SYQ82O+4vCzg1fqR7Pat2+aMKbopYODzcXh0R
	7vg2FvbiYKWogQwr0iNmZCjEAu6VVkY0B8XbWzKgnv6gefZZnX5MVltsRuM73U+jLu8AX1SvM5k
	TZWXWlZ7G6Wdc8WVzAqdbbkCUNmVoZ2Cc3nud1ZWjt6YO+dQx9yblUgIzff+yWk85se7PxJp/DS
	iHd+q/CO4Vq+Khf2wct4o99tYshswS8RPYyMPAvjdoexKQjNOWCDK5Jrql7eQarbCbTIsxJtaUi
	CAHrA4nPSgkGQw3XW+EonW6DkBJ71IZYIjSy9yC2HG/jfEZBNvY+5Lah/s9drc3/qDJtSIxJPxK
	Y+47fJzMPpy7JtZlnQgJfcJj6CHJuA7Z+fFkxY=
X-Google-Smtp-Source: AGHT+IFuCx4lTV36ytxTOyAJ/RoowaLhIeY2jVZHeX87aG97vvwLOiA38P+znCtMJ8WqDnaM5A4vXg==
X-Received: by 2002:a17:907:6096:b0:b6d:4dc2:7be3 with SMTP id a640c23a62f3a-b72c08dc800mr387131266b.9.1762530357944;
        Fri, 07 Nov 2025 07:45:57 -0800 (PST)
Received: from ?IPV6:2003:e5:870e:1500:7795:3e8a:56c1:ae53? (p200300e5870e150077953e8a56c1ae53.dip0.t-ipconnect.de. [2003:e5:870e:1500:7795:3e8a:56c1:ae53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf9bdf15sm274044366b.62.2025.11.07.07.45.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Nov 2025 07:45:57 -0800 (PST)
Message-ID: <ed4971b3-49ea-4263-b225-80a643bca0c4@suse.com>
Date: Fri, 7 Nov 2025 16:45:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] x86/xen: simplify flush_lazy_mmu()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-3-kevin.brodsky@arm.com>
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
In-Reply-To: <20251029100909.3381140-3-kevin.brodsky@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------2KDMQGlJELWzw0JdPjGXTYgs"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AF689C000C
X-Stat-Signature: 33yrmdc5hpnyt4mmzth3n8yxpaipszxh
X-Rspam-User: 
X-HE-Tag: 1762530359-202364
X-HE-Meta: U2FsdGVkX1+d4s9ADRSyHxtPMwQvPiJgTBLzgUu8lpPekboWIlo+jTNmWB8yn6eSapiUDC6y5d8sv4QC47uZpbb31f+zUUr+w5acgJEybA52fyaeMcTeOn8jprV/YZ5SkvxBUJbJdKkum76+wKmrJiByHXev1fNAFnbF+qjA/HpWzii24crfvTdIfLvgxCxhLcA1IGESYH7dFR4zdQoYZ9AVeVLcJLdatoSNEqGi2kNODH8EVUBZOcMuxSfcDxE7gCK+vgtp4WyBFk5AHCyNrq+Z4fM9zbFW7Mes3pMX0gezhN4D5oaeSFQgA/Ba+roT1ekUHEiaYQkcRakiQTW3mPhf96Z8irF8SwawgK9WDTYISMpn9LjxrkJo1tgTG0JMdVRBJFw/fz0uvLqMmyWRTGTMpvEuXKGeL9laWkIzhOPGMZwNTYkJD20kguWiW/S/+GFoJiHQnMg3IH7JI24yYFQOs8mAhDwuXYPrE7SFXDz3bitD168tTUuTZoei+eDIK6Sajg7ZHbBaY/LAXQMaVDgHwsSI/hHLGkhRqxVoHxoUvGNUbmgGpn21Oc682SQuEeH9WhLlHKCioHDyxopndd5lLWJUDkvzrKSu2Pt2I5fZEZPzFOp+SHN9MHwbKQZEL4Ed4T9Mla5+Qjycg4LUkBETowNpLd8Mx8GBJ03GTxf/g06Vp+tLFFFeLlv8zff1pR0FaS+zwEJn7dbghyYknvq0WwgvorDLDbOoV5ffxiH7k9H1E8YLTf3xPPg66jHOOEfeNblwP3uV/6Re1yaKLbVQymcgTIeoLeSu3mB/E1bhEWD70Z5WF2hO/71H9CKWgCULEqVk0jzgWgDyy1INz2FHd2OLftv2orPhvVRdu3oRUyiOBzxtA9cDX1Cgf76MOVc9EBLEMVpzZt3oIu5urf9F2jT40+Sm9XrQEiG10YZdExmuwuX6unb6GZ0S1GVBz+DRBsQMsRZRSR8PwJN
 NcjDUFje
 Ftz4XWDgiQQ/wY1EmYZE6cYhI/qNBG1dngbCryab1BliEVW/ajPEaAS0jzFRksG86F5J9nBTjjWZB1GonA5TWlIZ7/vPdc/hkCH0UfPYGK/0dFCemzYXTBeGWgELLKQC+Uhv0Ch2vUuAa/QogRPs4CW57wo/5vjRJYiFJPQEvph7hfLcg/SPj7wCXN7KVAUbyUDiCqSYnc5M3UYHuWLhipwxiRFXrNAhu2q8OUcwx9YI0flcmv11OOc6Pfcujr9w3WFvUiUUlnicwMYgZkHI9fHMN/ad1hW9B8/7XISmogY0UW30jIgu9rHbH+4ylu+JsB4n8swHl5rVVYBDeluk5QBrv0wnBbo1P8JM0R+O7fd/tH4AHDJvMSilQ/fvtJulIQ9wEpxgwsGzUJt3kF0U40LamehVYa6AbmL5leyNZE1SMn1K+btCO+5OADNmoDEfyOSryup7FY/dye2dg7ARMi/dv0UwoCm6IUokhAqY6I24K8qcicYxNSPXh757WqG5EbxDZMZycTxYcto3RMcrg/5op+BNo0OllJkHAHMyVcKzFcBdjrUCyVaMAH/G0BN34XKYEy9o4/G3UoWjo1pdFfc/8GliH6B1z6DuxgYaIB2R3KOfLpOKQiy/hy3iTm9MOVPCZe9DCbRcy/fUnLibxQmSMuGjkx9Ha96+UPTiYdtRorOQbwRQSGHhTvTHrzg5AGjyyxySPzh4nxGfMKRNTWKYirQ2bDOjpIesF6Hawsm1SBw3lxPT558TEsDTUAg23dp4mGTIAEINgoap1VwlDxrtiwnZHQevLQ6BHcbS28iCl4mkTaPWvmmT9TqyA5jRWls08z8J/Vs2kM8Cfs5FrPcNdz2WTHg8efkTLsZ1Oxn9WDNfUtNY7XUoP2A367DC18QKCbv0QCFXNTeQ7Cl4zkNFjp5xVlEpuYHcVWMVDKgPPQzqs+WCMk8ezshmxznn8qS6C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------2KDMQGlJELWzw0JdPjGXTYgs
Content-Type: multipart/mixed; boundary="------------knysrRNvahQGLFPAzdME9JNX";
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
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
Message-ID: <ed4971b3-49ea-4263-b225-80a643bca0c4@suse.com>
Subject: Re: [PATCH v4 02/12] x86/xen: simplify flush_lazy_mmu()
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-3-kevin.brodsky@arm.com>
In-Reply-To: <20251029100909.3381140-3-kevin.brodsky@arm.com>

--------------knysrRNvahQGLFPAzdME9JNX
Content-Type: multipart/mixed; boundary="------------0xpsCIW0ItmLiouLur0gOGNm"

--------------0xpsCIW0ItmLiouLur0gOGNm
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjkuMTAuMjUgMTE6MDgsIEtldmluIEJyb2Rza3kgd3JvdGU6DQo+IGFyY2hfZmx1c2hf
bGF6eV9tbXVfbW9kZSgpIGlzIGNhbGxlZCB3aGVuIG91dHN0YW5kaW5nIGJhdGNoZWQNCj4g
cGd0YWJsZSBvcGVyYXRpb25zIG11c3QgYmUgY29tcGxldGVkIGltbWVkaWF0ZWx5LiBUaGVy
ZSBzaG91bGQNCj4gaG93ZXZlciBiZSBubyBuZWVkIHRvIGxlYXZlIGFuZCByZS1lbnRlciBs
YXp5IE1NVSBjb21wbGV0ZWx5LiBUaGUNCj4gb25seSBwYXJ0IG9mIHRoYXQgc2VxdWVuY2Ug
dGhhdCB3ZSByZWFsbHkgbmVlZCBpcyB4ZW5fbWNfZmx1c2goKTsNCj4gY2FsbCBpdCBkaXJl
Y3RseS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEtldmluIEJyb2Rza3kgPGtldmluLmJyb2Rz
a3lAYXJtLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNl
LmNvbT4NCg0KDQpKdWVyZ2VuDQo=
--------------0xpsCIW0ItmLiouLur0gOGNm
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------0xpsCIW0ItmLiouLur0gOGNm--

--------------knysrRNvahQGLFPAzdME9JNX--

--------------2KDMQGlJELWzw0JdPjGXTYgs
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmkOFDQFAwAAAAAACgkQsN6d1ii/Ey+9
7Qf/T56S47fDqEb7wrI6i48Xr9hbJbL1cOc88MTixDkHAfIu70HOLvfAW2G+G73cTTY/1IFY+cr+
wk6KhYqguuIbbFGh6hlD2neoBl0l4Fiujn0c9wTKQbJrDL6h8jDeODAFWmkuyd0Rtnawy6o+0tgP
OLmQ4vhbq2u58C6zzLGQWIz6csmJqnGTKYGIQZI/h7xUZhz/b/RzD8p5aTRMGfVraJlKwuNAsKmp
/f7DpPGGCI7nCZWglBlKRFiGM/bZFdt9rZRV30JAFzq5kyUL6Lp3Y0nGp91si4slpitgwPxEG3M6
oApGVoFTsieG0o5HaiDhf8c0R7g+2PiCjn5h6HxMIA==
=Eb3P
-----END PGP SIGNATURE-----

--------------2KDMQGlJELWzw0JdPjGXTYgs--

