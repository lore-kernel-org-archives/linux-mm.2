Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31AB0606A686
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=O3LNbgj8
Received: by kanga.kvack.org (Postfix)
	id 54D506B073D; Tue, 24 Nov 2026 10:13:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524DC6B073F; Tue, 24 Nov 2026 10:13:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC7D6B0740; Tue, 24 Nov 2026 10:13:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0186F6B073D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:13:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 77F0740979
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:13:21 +0000 (UTC)
X-FDA: 85470356202.04.874C6C9
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4FA9E14000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:13:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=O3LNbgj8;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of jgross@suse.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=jgross@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795533199;
	b=pgdNv5Fe0bbQN6lEaNTLZynInZ8AaKGF+GKReAAPiXIrrSJrSoDqIotsfkMwTL61V0y9Bu
	4Wl60MDGswRyLrWT2BDPpTJItcZ+QTKi/SeMZoJ3///vcaaUvlnVVHZpfaM9Lqxjutgl06
	ll0xO0ACiR5QWSpNAANnvm5RvLdSfNQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795533199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OavKAVZv+OA0pfYHqsDmPh81k4IRaCsSuMGSaPHhIPw=;
	b=Be0uGX2zaUjwSzOGWgN0ApulpidLC7uES1ZbIDknzczL9kOhslogJ/I6Z5XkLB/FUbxdVG
	CCgb2bYa0XKeYx7H/L90XJgYBhx5JfOLTvIDn7PsfGHFASw6Yr8/TArAYErl5oy+0dCnKR
	8+tWcZwpMjm15TAIaVuCL2J978B6C2M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=O3LNbgj8;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of jgross@suse.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=jgross@suse.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c5118deebcfso684765266b.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795533198; x=1796137998; darn=kvack.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OavKAVZv+OA0pfYHqsDmPh81k4IRaCsSuMGSaPHhIPw=;
        b=O3LNbgj8gD2hSsflHB9iaPZStjRUxOsxhboaiIc+fRLp2eqnteIHdr+V4j4fsttDu2
         LJheFQoMb7VeysSTZltCzYlFkkKlB4fF9IR3GKqdWZJFDeBPfbzWEa4Nm5yxv6PiavJK
         V0taxIUJLMUlq8Xgm6ZUtlUgU5TtJ9idjiIQY4hGKSz9zzlDc3bdPgi7KEtTeauRMoP7
         mFInuUjt9PF6kLOSXvx4X4rU8/IyUMvItEoUQRVMkN8M14AbxeEG1YBMf4p0Vq0VbOc2
         3qKqkgZ65NUd7m+7gY9uW1ztGiMZ5857FuMChdYiM7O+gOxdyWViktRv8QTp84EolAuX
         0Hew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795533198; x=1796137998;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OavKAVZv+OA0pfYHqsDmPh81k4IRaCsSuMGSaPHhIPw=;
        b=pHhZ57iyI4gms1TQpYQfD2Xapnjkb33ckp8Gn7RgMuUMKYhyZzDhvwBdSDlfNo3M22
         xr5LWG7yNMX1VVOXwXO7XSUIOXo8fYZWmg//MhW3dLKdEzZ+3wiGyzBPqksFll8vqcMx
         ZzmkEAqfoP4DyAw1MxQ1EGwJrSVKQL7CQHUlvcmd2WJ1Tv3k+wJGVbomr2KIMx9p7iJT
         vraz0qa/vDuBjUj+l36pFy9hs7iBsn9lwAR7wg0S2Ga8SmXspHlpV+dcJwdw2qK8+uyx
         7Ik8Oqi6AEGR3YlG44tP81/KaIVZIwI6Se41C+j8Fs2TFvGzhipR6vpxmnoJ0DG7TDAg
         99eQ==
X-Forwarded-Encrypted: i=1; AL+hErGnUnfhIUbEw7ocmkHMFGGx5FEp4jDW5ZWr3gBeeE7OT3vfrRtHbdK7NBiIoGY4AF85JlaXKEwIMg==@kvack.org
X-Gm-Message-State: APuU4Z8cm0AtXz5p7XhCURi/oLwFTdviLyEQ0b848Tw1XWPDRhUCNWyE
	zCsp15+PZ6TpgdskxThp5anchOq1FpnfDO5qxfHsRgb1cjdJo9W+neFOJ4pzxTexCNg=
X-Gm-Gg: AZFdTZdZkdbR87VvQD6F1pXoYLDzUZy5xd6magmdVX+lB8BrMFSRB5c4WlZ3ubpafDO
	bmc2ZtXC52B37533ngLJv9jHgI3tloSa6KPaIuQ9Jtz9vDw0PvRjUSS2BhGNXimNusDIBGX7I5o
	ADpf1gQ5ZwXNUpgswaIA6uqJxe9grmVXQgqCY0lBkNinP1pPZawNhRJSgxlHPxaolYZlKiu21t5
	F/ClZx02ZX9cqEzsAhdY4zUSO/WND2aqf8CfJDnzj2BNXQ5pZkwmiXTzKtQDktyMtolkk/deUL9
	EnZpcAWhg262x4mXm/gtOH6mTVaJFuYPfWSAa+lEuwjyVmfVsx4x8rzwW1OPintL1pnEY0ayAUx
	I2qd0xERG6f100/1UFqWxmbLNQE88+fPmcg0fa6Y8NxnFI+VyDRFxf2yJjzj+GbecB+62Blnv+d
	nlkGPhdIV9oPf8ue1N+FhsNKBbSPd7Tz2WhuCqNBw+898qwAQuUvXbn/9rbAlW6PYZ5ZrMaBQg0
	9knXDg4YRDauq8Ae8+cYPf73RxFAAbINmVKZmNMKUe+qf1KmP30oADDj/tQKiapLdYHitSz1d4T
	wt5ego9f4RM58Z5oPKhkxXH8EOkMJEKabmp6tnfi50UYF98nFsCnz/YRLmWVb5vyxXcTHI+Rz6k
	h3uMshTYQnV5lq4+82CdjtWMXcwg6QnhOcQX6V126SPZ29tCkUg4=
X-Received: by 2002:a17:907:e00b:20b0:c4d:22e2:1a2b with SMTP id a640c23a62f3a-c513a47e2ffmr818303866b.1.1795533197737;
        Tue, 24 Nov 2026 07:13:17 -0800 (PST)
Received: from ?IPV6:2a00:12d0:afa3:c01:92cc:e257:77ba:97a1? (2a00-12d0-afa3-c01-92cc-e257-77ba-97a1.ip.tng.de. [2a00:12d0:afa3:c01:92cc:e257:77ba:97a1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513ae8d0dbsm543097066b.31.2026.11.24.07.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 07:13:17 -0800 (PST)
Message-ID: <f9ddfaa9-9a78-4fcb-a142-6c466d215492@suse.com>
Date: Tue, 24 Nov 2026 16:13:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/13] xen/privcmd: convert mmap hook to mmap_prepare
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
 <20261124-late-2026-mmap_prepare-v2-1-0b0d99d655f9@kernel.org>
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
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-1-0b0d99d655f9@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------q205G5Arex3sh2KHaxisqvnr"
X-Rspamd-Queue-Id: 4FA9E14000D
X-Stat-Signature: 7j4wmziuu8phx16kpf1koxamqugbpmya
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795533199-514524
X-HE-Meta: U2FsdGVkX18pG6A+J2KtmtBZdYAbzLJ6+g9kI34fuvnesMbTHuH1ZfyZajg7ajjxgAgVIR38/8svWJZvKKISN4dlkHru/OEggXoCkWuPZrjN6fZVAjz6PNtW7t4qVEEOqJZgiSpETaguoB41TTr1eaDSNFmdSuqTbnfActvtvaSl3EZ0aXfpIYkxbWzqWjc3bjOH/VgI25Af8O4XumofMue4S8eudpoJL3E0F/xG/ga+HM70WsnDzGkCyOiQCFPMTmRdTrbWVn6oGlpI54LebnNHgHJFYcClKUPHFbUiI9HHdGAXqG/WwbIE4ewYmXuQmAc28iGJKPBTIM1mMcxeCoa0SZtKK+mTRhWQg+QhMsqqguMrN8Au1YM3TRZPjdQAiBCgyhr/Q+W6nXVlswdmhyNYptrYwiQApxE5OhTVF3y0fTfxXZTTFxHw2DJ/u0iNneuTLvUY9pJI9YqdvKCo3MA+jZYyc51ViFhyD0q9ujVCXO6egA0YLCjdfjb8nWbHwPCdTRU53lV5snACcFQxsRL61UdceeHtBUj2Cyi/6AjCilXEnIh+npQqLzodz/PvX3GULLvm35STbaxYaYh69LFhQQRfImkXc8R8ZmLDD4fw1jw+RaNiWgY8n9np3x4VVabOZlCRf9lqeKWD6zAsCR379Jia3TUyQdp1CuvF817DIkNvRIqjnxUN9ZiVOe+7XON+gHtEBDTLpwVgKbWy0yXdGjlsR4kIkbcQZUP/n+aNAvjtZ/BiOE5YEooOWhhkplvV1mKFCuSQWCLTvO4SW4iGi8AhQeGpn1aS36SwQ5ymPl3oWnbxtX3EF0xlgPJP7KMEt3aOPIcJKtzJSqdfjlA7F3DaUZtx08KJHEXXf8/wxoLrDzJFKT46uoAk2yYRgC/Xdp2TcnNMq+sbKKFpRWFRaJ0qhL4+b8FWJHqwbHmc9tTULYRqI9Lp3LQJ8t2LhHoc92pW0uC7VNFuU6d
 UvJt/7y2
 EfwTna/J/T8Gzb9igRIVvj2M6jVsXuTn3aNL3GwNGajLTp4YhrH+2kwr+p3GSG41WoJSz+B6gCKLSs185omQRAZ8UhrP1wwKrJXaoKsoT9AX02EcPGNouDttMnGhc01VF9Y1kQBhA7XdyOg9D9F5BA6cRhxxJM/5ulTAFzYG0NRXR3/LD6emHICa4koe9gn1n5R9SueCzmAe1A1MLDYR4REwmoSAVMNiY9N6DRDlK4xB9gVC49+taZ3pwKK2KokNp961GdbGkkt5mgxQ5VLc2A0aAjjCRRH/iHk4Ie3yYiKGWkM3cYUS9WwTJZqP2pDer4thlB9aiwh1SnJY+n3/K7x0ubUF/0AHENLTN9CDeAcfw0dGAsxyLuEtHN1wjRAiDPJpgRrZ4pAcgVndsygIJxgkoxFGGEyp62lYjt8FJoV1abgAcbao7DFjI8Q8VUunk3fX3AMaiFkZdfpwfQEBKbIzSisvUZofwOrreQNMm4FZ8uu8FTZjio9CGhUgI0yohqGVmIuA1GzeXgQCnWwbiZtoFYjSCO4YmHzf4SUC5dCTlJUVAYmJgc2sSgEXPWkq+dy+YyJ4jR3uFk55A4bFGnkzTf/JO6DhJhtI2DeidYOBMvTHv6+yx7+lBJn4VvWh7jM5g31xN9jXwRU9e53uy4CTKSFQT94BSpMRDKKl0WTCL1v1V0vAnculGmXWZLkBL7KkeoLEJiUO5cp/YK8MPJjy3CPflUm5q37D3L8CMa/r2Fprr6hbsnzPdsd0zLVhWgAnI2QsBJjULrq+iqCfjr8YKXzipDCimuzhjCbGKpYDkRcf4KAAC7GI+EC17FujksPJANMPUzXOSSVpbxfoIoUqUSHy8veBpMcSXPLcTy3A8yyoP2oA7+Zh8DfY5J8Fv6QpKY6d5PsZ+PpynhJK+NxNY1DbU+lkJeDc6APrbOLIeqSc5iBsY/dWUaacOP1aagI5srV6WQCiUJVlnNym+C7FRytgZ
 x1QjrRGM
 HEboC5hc15tVhXJlXuSGE/kMWVmmaCP0Xsvxn5oqscDXmJPWXX5Bd8Ta6kIXah8RboV91KvWDebKtsu+j70ap3DF4CU71/JElqfNlHfCWrK2jOQiIFmhkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------q205G5Arex3sh2KHaxisqvnr
Content-Type: multipart/mixed; boundary="------------AjT5XFhC0OM07fDCW0uVTora";
 protected-headers="v1"; hp="clear"
Message-ID: <f9ddfaa9-9a78-4fcb-a142-6c466d215492@suse.com>
Date: Tue, 24 Nov 2026 16:13:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/13] xen/privcmd: convert mmap hook to mmap_prepare
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
 <20261124-late-2026-mmap_prepare-v2-1-0b0d99d655f9@kernel.org>
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
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-1-0b0d99d655f9@kernel.org>

--------------AjT5XFhC0OM07fDCW0uVTora
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjQuMTEuMjYgMTU6MDIsIExvcmVuem8gU3RvYWtlcyAoQVJNKSB3cm90ZToNCj4gTW92
ZSBmcm9tIHRoZSBkZXByZWNhdGVkIG1tYXAgaG9vayB0byB0aGUgbmV3IG1tYXBfcHJlcGFy
ZSBob29rLg0KPiANCj4gVGhlIGhvb2sgb25seSBzZXRzIFZNQSBmbGFncyBhbmQgb3BlcmF0
aW9ucy4gVGhlIFZNQSBwcml2YXRlIGRhdGEgaXMNCj4gYWxyZWFkeSBOVUxMIGF0IHRoaXMg
cG9pbnQsIHNvIHdlIG5vIGxvbmdlciBleHBsaWNpdGx5IGNsZWFyIGl0Lg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogTG9yZW56byBTdG9ha2VzIChBUk0pIDxsanNAa2VybmVsLm9yZz4NCkFj
a2VkLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+DQoNCg0KSnVlcmdlbg0K


--------------AjT5XFhC0OM07fDCW0uVTora--

--------------q205G5Arex3sh2KHaxisqvnr
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmsFqYwFAwAAAAAACgkQsN6d1ii/Ey9P
6wgAhB7FWWxaGPhKVeHejmUgx+jnN5sGJc29B5zeOJ/udOQfrpojRJR0JMaTJNeJ8g/QXkTWmCZt
Zd6lRhkVQVMmVrlatIREKD6+lx0mr154pd31nTm9ffbjdyAK9RPk6czEHFUxkktbU/9vv+pBcZEa
4SaEbJuidUtK7Vgek2j0JKYNWpqv8R80d+nRsMU+RX0YbRKCuT8Jtt3uB/TLb76UL/eK81vzE7j3
bGBh83GA0cSOumIzSg72te0PCuz4U9UgccJbDbwLIPRkV2Gx83sLPaLOj5968cz/vyT0qZwJ5LfI
2oGgirhriBPAdLJrm4WtpkDGIWO5CaJWyZf5I3zVZQ==
=Eyqx
-----END PGP SIGNATURE-----

--------------q205G5Arex3sh2KHaxisqvnr--

