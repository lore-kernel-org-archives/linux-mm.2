Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B04DED0E6E2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 13:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1792D6B0062; Tue, 25 Nov 2025 08:40:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129666B007B; Tue, 25 Nov 2025 08:40:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33096B0088; Tue, 25 Nov 2025 08:40:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC3DD6B0062
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:40:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8CAACC0131
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:40:01 +0000 (UTC)
X-FDA: 84149237802.12.F0417E3
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8F7011A000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:39:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ge9Ckvhe;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of jgross@suse.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jgross@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764077999; a=rsa-sha256;
	cv=none;
	b=faaoM7JqfPCm0T0w6t0oAN/37h932PuORh6pdRpmkX63rjYAYviawxb9VecGpVW3xO+gTm
	U0MoFix48n/PUJCywXC903jLZpIO0m9+oyjZevJ6rQRbaJQRlErci7A1FPsefLzdhazNju
	2LQCXZSILLlmFGMWyMHan/MGbJMTiO4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ge9Ckvhe;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of jgross@suse.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jgross@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764077999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9k46YKiR0yToOqPC8tJLWldUv3bkY2Nm4TLf+L1CEI=;
	b=TZBFwUOJ9asUaHR2XR8q2VhHp0P15BQArcxY/rIGWB8wSfne0F5DStl5pvtuWURMLHcorW
	yAJfHJmQINuksSa8//j+rHPXa6+q/tFm5hRkr9GT1vmDneu4gm5H8fnTyIBGCF3Hx8zmEr
	jP/zg7ZH01vyVMmOskN9y8DOked5GXI=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-645a13e2b17so4242217a12.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764077998; x=1764682798; darn=kvack.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t9k46YKiR0yToOqPC8tJLWldUv3bkY2Nm4TLf+L1CEI=;
        b=ge9CkvhefO1M5Su1SmcYA8kOMHYvwqs0XInaFQGyLoJJOd7Wv3i47GpKTVDkBTIAU4
         At6plBQmTk2FEXESam5bJvB3SZjGosHynlJmAyH0U8nW62M5kh/hpCLbpttegLoz2kUv
         baSSU8ZnNg5OM5j9Q6vqv5y/nAf7KYz4V4SYSUsxXlo9nJajMv9ejJjvGKapZ8RACsHN
         qpzDFVcGLDonT9thrtJitiqBXQTJPWakd3IRJNI0pBrgXJOiIGeEhYQ22UC1ck8Vi2m/
         DUFHujkWjxwRGR5QWe9uhSfJUvqtqTBeiYtVWwV0BScDQd+btJrep2/juNVuwsv2FKIx
         QW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764077998; x=1764682798;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t9k46YKiR0yToOqPC8tJLWldUv3bkY2Nm4TLf+L1CEI=;
        b=L5pyAFGU4BOJ5bBFuSAiYQzHXuWt71dqIAaMV790qpm84ugL+FiASqTRL/G+iM11UK
         WtnHFgQIpeYHDNhcwuZfeAzGciYXLIQNVfKn7FPuWrHuniAmnOs2augrfHE3LsbqqamM
         NCvkB3fUHlsrtV1dhCAB/bykveIwg8do8bRLwyJXI2k1uoFki7EOQBixMu9dc1lP2E1H
         uIB2VnlVJEabFeeYvUAITwHfDP+d3dLv3GkBu8uw3nPtHH3RXr/KMTcOiAhDluKeb9We
         tQyVVF12RmgbIE6SdsbyuI297E/b7xxXEGQNlxOz6MTF4tlzn2pwwksam/8I5g7dq+n7
         R1oQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQ8cGA5y/J/wrXkBAtBPuOcKXB0A2OCy1hPB8yirEc5o5zai90lutOKBQ+cMws2svyasW7syGmbQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0C2BHB3XJuTbbyyVekM30MoLfjAhZ4YY1VYFEphr5I1Rguxyk
	h+wYOZgDd2IE0vhGrOTMXCZ9Rva9Xj9Ywvs5uqPzO48ncX0xzzhpMG2VciPv+dHULJY=
X-Gm-Gg: ASbGncvyMptJEHtzj9XEvuu2PUBpeBguJQU4rwfOslqqY//imcC2sjuWBI0imy7TIXb
	py7MkGAxsRHQcebAdcuUxTzh9q3OoIZAnLL5Xoio5DXje5dDqr/5EulvSfhdCYFzoCMlXoU4tQb
	ozORfeRRR0ZdZJkNgsB5oqadVsHIYDziNfmg+5Km9rkpguMfcJy+phYcIUafV1B35/3WAfmNjhg
	KRAahKOtq8V1dfva4EqVlhFDWoKkhU4myoZHi8yDUSv/FIMK2aQcwMKN/A/znsraXJF1lzuexHj
	bbYy8VPAs5HAb1HXSH8SyRAh3OEzUJSROzJgYpdw8H7J1Etb8MWb/JT6sc+UQTkLlseqoaWKsda
	pH7WqGzE2FcGn1HP64kCEXUG00bmV+ll2pOjI0SAFWldbzT8OPrD8IATZKC5FLFsf8ebna46CXP
	EzeTuFNqo4owIxi7l4595OtPJUt+/U0+1+9ZQc0qtXxoO8kLsiHt8g0+JQjnSWqblYPIJO3iqxL
	u2po7zDP4o095baGo6GSP9gWs2Eva9wrNZgEeHVcOgYZlVvAg==
X-Google-Smtp-Source: AGHT+IFEyicFSi+PL/7sV+Rr65T6PnnmK37s9BQnogitw6aYlavVnxgivz8dWx5vdwjWsip7TwnDGQ==
X-Received: by 2002:a05:6402:1d50:b0:640:cd2a:3cc1 with SMTP id 4fb4d7f45d1cf-645eaf9e5d6mr2598230a12.0.1764077997753;
        Tue, 25 Nov 2025 05:39:57 -0800 (PST)
Received: from ?IPV6:2003:e5:871a:de00:dd24:7204:f00a:bf44? (p200300e5871ade00dd247204f00abf44.dip0.t-ipconnect.de. [2003:e5:871a:de00:dd24:7204:f00a:bf44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64536443a9csm14940329a12.29.2025.11.25.05.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 05:39:57 -0800 (PST)
Message-ID: <263d6867-bf94-40b5-87f8-96b40e797ebe@suse.com>
Date: Tue, 25 Nov 2025 14:39:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/12] x86/xen: use lazy_mmu_state when
 context-switching
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
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-13-kevin.brodsky@arm.com>
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
In-Reply-To: <20251124132228.622678-13-kevin.brodsky@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------aG2Ac2AfdT2tzwl0XdLF1SjN"
X-Rspamd-Queue-Id: 8F7011A000D
X-Rspamd-Server: rspam07
X-Stat-Signature: 858fbiknog77dqoutjuht53nyyxa39dm
X-Rspam-User: 
X-HE-Tag: 1764077999-921301
X-HE-Meta: U2FsdGVkX19Du8UbAf3WEfTYfuyrUxPUl/6aUrw46BzFWAcVCPuwIbtiwu/cT5ExKh6StN5Dh+gBKk9VkmBUsLr8P3OiAaJffDCCEFjrUK8nODO3GNBl/5IsauePwBPyc5EvKmltfHY5bMyTvofQLR37F0kr94IKdLoFmX1Az+Unkif0tB31bW2ouLvnhW0Bl/jRCWd7n1+Wev0H8QuYvFHUE7p2/MhoqUp6QptjwMTrmGHMdbTedcVgFjS23D23akWNNHtXvlv1Z882g/c5bIYqRJVEnWf2r22K/rhlR2AssnKCyDKCM6YkPuZ6CnGVMq5yc5jcLRmEbZjSzqiM+XUd42nifmgdsSoTGIyWzgnOxLk7PeNspt2Cv5hB1VDXEwMLt+SFBqY/5KbU6hcfbn5lZ1YZBnStNR2r8LQo5+zvh9+DZLJVptl99FD6fPobg6uTfXAC9duGIkH8C5xd4KF0RJqQE4zR4bLZYLxSFARLfmQ2tCR+kA6DHtN+y6wpPo2gZsx29xEeOY9zLCGsKfZbZ9o/JA4jNEPxZFb4rsFknbOKuY+1TP785j6iSNzFiMqbhdLf7rMVO8ZgH5rogI4QjWV6xvGF6rlf8liIXTk8rzAmiYdHejzsDLRFMDSwCC3U1JWIre7tQo1U+3FBHRpH1ADlG37yv/l5Tgu44vWD3gmywU8GPs5cT5qKmP6BuGLkNgJ5yiQ2r2pqttEsyjPFvoAP4ot5UvhkK0EeObw+NBRNLPd1+FioHAE7ETPoZuWMnQqtylpFlBdsUAeQDbquwITsiH0gwLsrUSQDWqKspfQbCFSOeqvQ8KnLXC6rNkXVisNvh5gav3ZfH/MIvpFPWRohYNua190Pywqbgt4Lk20OZIuyy06g4EE7t82BxkaVYkXnd/2Seq3JiIePjOK8yGrYIO7RVz9Ye78HZMF2BjYZMYINnAAVaxvD/B1SDtUd8u8Y0EdYJ+0jWpX
 Vh4u6DL7
 /o/fiD640QkWsFGnZNXJqS2qH/x5axWvxsJ/OqxAH/UNOKq+tcebfJGe6HDsZ36ABaDKbIRpJyY13ruzmQyjH/4o4sQbwjcsHwFyE+xrIAICyU0H9GznW9lqXVYlSv/Pw2r2RYacdAqD259M2WVpEHcolrXk9Tw1ucnDie7rtHc0BK4i9UpSeJXbgrJrosJsMe/dkpVromLG/AdeXEtjKUREda6nqWS/L8M7LT2HoKjvIYNm/zV9LrHdQhCTZ2qgg09JHtjahpDhG20oPnfxVAEGiIfppaBOuyo2uPzDCM/LcGdb5l1dc51jwRRzQzDXWl5z3L0xwIjYHdO7FUahSbez4JZfReNasEihkreBplB0EcsXr9O+X5L51aXrvREaIdQHhUGzVhWywsqaW5R4xVXpHEhnpilRNj1QHxv5A011kKnyWe0SlN/2YfAksQay33eP24CBo0wQjJyHKH9asTNjKSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------aG2Ac2AfdT2tzwl0XdLF1SjN
Content-Type: multipart/mixed; boundary="------------uiRZ28tjJaLdZE5TT0DoL5p0";
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
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
Message-ID: <263d6867-bf94-40b5-87f8-96b40e797ebe@suse.com>
Subject: Re: [PATCH v5 12/12] x86/xen: use lazy_mmu_state when
 context-switching
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-13-kevin.brodsky@arm.com>
In-Reply-To: <20251124132228.622678-13-kevin.brodsky@arm.com>

--------------uiRZ28tjJaLdZE5TT0DoL5p0
Content-Type: multipart/mixed; boundary="------------yTa6J58m2WgehpiHUf7cxco6"

--------------yTa6J58m2WgehpiHUf7cxco6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjQuMTEuMjUgMTQ6MjIsIEtldmluIEJyb2Rza3kgd3JvdGU6DQo+IFdlIGN1cnJlbnRs
eSBzZXQgYSBUSUYgZmxhZyB3aGVuIHNjaGVkdWxpbmcgb3V0IGEgdGFzayB0aGF0IGlzIGlu
DQo+IGxhenkgTU1VIG1vZGUsIGluIG9yZGVyIHRvIHJlc3RvcmUgaXQgd2hlbiB0aGUgdGFz
ayBpcyBzY2hlZHVsZWQNCj4gYWdhaW4uDQo+IA0KPiBUaGUgZ2VuZXJpYyBsYXp5X21tdSBs
YXllciBub3cgdHJhY2tzIHdoZXRoZXIgYSB0YXNrIGlzIGluIGxhenkgTU1VDQo+IG1vZGUg
aW4gdGFza19zdHJ1Y3Q6OmxhenlfbW11X3N0YXRlLiBXZSBjYW4gdGhlcmVmb3JlIGNoZWNr
IHRoYXQNCj4gc3RhdGUgd2hlbiBzd2l0Y2hpbmcgdG8gdGhlIG5ldyB0YXNrLCBpbnN0ZWFk
IG9mIHVzaW5nIGEgc2VwYXJhdGUNCj4gVElGIGZsYWcuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBLZXZpbiBCcm9kc2t5IDxrZXZpbi5icm9kc2t5QGFybS5jb20+DQoNClJldmlld2VkLWJ5
OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+DQoNCg0KSnVlcmdlbg0K
--------------yTa6J58m2WgehpiHUf7cxco6
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------yTa6J58m2WgehpiHUf7cxco6--

--------------uiRZ28tjJaLdZE5TT0DoL5p0--

--------------aG2Ac2AfdT2tzwl0XdLF1SjN
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmklsawFAwAAAAAACgkQsN6d1ii/Ey9M
5gf9EkkVr+UGKF/wariaJTMLeEayZP1qBy09TFMvwrlbuCyD1J20iKHWJ2c/xfac/xcQdvzxGK3Y
nMX8Dg+6nWgGk7tT/9p0s2dcvsYF2fnh4WI7yS6FTimnkkmwDCj9T7zl1nziZEYUlj7oSea1hRVz
v5iiijrTDLW6L4D3oVzmqLK1XGNpOTClCzJcn9gz45Pw5+8laVmiYBcktiYFOT/TcJvnIeHTH8Fx
P0/i23ndybO8Xtkp5yj+KAjX+75J2bEJOx79yOSaRu5z3yYhY2XBKE9tsxsVb7uoaIhxnhc2Z5ZH
ms+Hk03X+jeJhvbey+a5MrddNG95o9MtcKNcDmNH6g==
=ph6L
-----END PGP SIGNATURE-----

--------------aG2Ac2AfdT2tzwl0XdLF1SjN--

