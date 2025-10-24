Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFEDDCCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 22:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D021F8E011B; Fri, 24 Oct 2025 18:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2EF8E0112; Fri, 24 Oct 2025 18:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7AD88E011B; Fri, 24 Oct 2025 18:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B36C8E0112
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:53:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F7C18954A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 22:53:04 +0000 (UTC)
X-FDA: 84034509888.19.9690362
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 25C074000E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 22:53:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AB07wObc;
	spf=pass (imf04.hostedemail.com: domain of demiobenour@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=demiobenour@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761346382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mmyfUlxIO9G+mnEZZtfRPMoHw8LWeBFeTEO3Heos1A=;
	b=6YMEHbE04gGJLsdZEn89BvkQVsZZ2neeiDVhqOwR6PN4WSSdUBDeZS3fpMhdli6pm8vXzw
	OrDpyPU2ABR8+YOl+hCZ19Z3FAm/xehx7jqD4GIGdQ/dNM6IVMujHRfVDdDQLvqCxapYNC
	fL0PnHFhvWHcj2vfVuotHbvxzn/8cPg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761346382; a=rsa-sha256;
	cv=none;
	b=EzNIZnBqJb34bjgQeUD5wm0iSDay13DSb/MS/TTlsDmgJTTjgW4A7x8dyrzd5ySUi35hss
	LKh5zq1cQzYJ3p7o/HKIKTW8qDmrMy5bh9XFeUJXKFEvYikqz1PW3l19HDmCa5laSQgRQO
	s07aNHcBEx14j0dCPC/bKiOcE7/MJx0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AB07wObc;
	spf=pass (imf04.hostedemail.com: domain of demiobenour@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=demiobenour@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-63d0692136bso3149463d50.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761346381; x=1761951181; darn=kvack.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/mmyfUlxIO9G+mnEZZtfRPMoHw8LWeBFeTEO3Heos1A=;
        b=AB07wObcNzZTtm7doBRkolAPmtV0shCcA7zfcZE+jHdi/H3nyzoWv++2+1A46ETGbg
         XbxL2/NCEX4VMKpHGSWLpC51fFfdpIObciWewkzNTBp6v1s/bilDHST+KDZ+nWJzEtn4
         EeP0TKfv532T3A/dNIJwl/QL249g6DmuUYaRwbSBrEmW07EgiMciEC18TwdGkXbKSNyN
         hSNG4XdTxVbU72Qk6t9iAd7wJZcJL4poe3LJPA/IJRgjKB0z+xegQE154ZYJgji5dukz
         +NYLGBvbezJ9AKG/zb+fGwUkn3MwMza5TT2u7b/Qia+ZK4vEjvTmzoB/JTOJjWBvDpKp
         /PXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761346381; x=1761951181;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/mmyfUlxIO9G+mnEZZtfRPMoHw8LWeBFeTEO3Heos1A=;
        b=ZH2NGlwY6+hSgAUtpFFco2e2m4KcvDxtVSl30vZaql6C4hojtzzRYqMy3/za5jZc3p
         vPuOiFXWHhSC7QBcdHtQJQc2XEfVrDXAeuyB3YCbRHvEhW07g+uAftEvX1tiUnN/d4kA
         zLEGsU+DG/oxaXIsQ8FscOwo1P6QspFEwk4l0JxZDnY81XrbV5kfeZy7XCKYATP8Er+O
         PwMvyfYmyYqOSipknymD8LM21QGKXICNybjGhxj1/OLLmpQXRLl/70Oj8dYMlhUi4l5I
         Smx3WPbQWV6De9ibdhCQhSSmdNKeSicaJC1uINBkFRUeeOTeLcsUkqRweSSgQFnP+tZD
         +5Zg==
X-Forwarded-Encrypted: i=1; AJvYcCWjeFc1cxim6roOrNqZ+y+NWuB1GXBg5MGhjStiO4f65UeZZPjCGCnXD9LBxa59nofGw52ukShQtw==@kvack.org
X-Gm-Message-State: AOJu0YwwU1Kx10Y4Mw6zhvN1+ibo1le6lLRWO331ZA1VosXJOk2dhPaR
	dva9BAF9qE4ec/iJAcmOdTtolSXY/a77PXyXAfEUjy0WdE8KUYjMsEjv
X-Gm-Gg: ASbGnct7lBPV9muBUBPgI6votbgtQszNJGAuHvFms6RfKjxkvYNc+vjyxCnznUVYyd5
	X855oGK3t3XYPhEnE0FccdDV26UojWGec9F3HVG9k04UBEGv0SYIjJW8Xdj3pB5HZsvA25hysn+
	Z1GKOsdPPGAN21K8sVUZqiZeF9GCoAJ5TH8Q+gBclHEYi7Ebtac/ovPEq+8dcWCNyW/QEA0vRfG
	qaYhIW4yVlD67/oPmNAAYDuCi8rPEsIp5gZB9weDJcnARBisflje32606yHht00+fxzZ296XnrY
	smNdOpDCMf/pz/KrrPA2gUXog4CbLxiLP6wzT83L9Yh0FdObTHiZNaMWS6Q8q1NfTkFrUC8u5Kw
	2wmMM4LThjs1vJ//Q8DtjdqlIVjSmeSdsEesbMT5s8BkPeBHe/nrKwpxau7sW7WSwyg60ruUGmM
	fBw+C6Yc7kiZvLfuHVdKD0Ypp1uwjzW8GRIqQ14G1zuvuIa9gV9wTMjMihEIcw0t7YcjgxOd5BK
	qUadTDLmi+YP+p96+ti/Hv2WmE=
X-Google-Smtp-Source: AGHT+IGWAvoqHmVALDLkkW4Nv74dFC4bxZqcncsjw3cv6YCeH3p7CQGTYcT90n3c9hPTMMA9o7Hw5g==
X-Received: by 2002:a05:690e:11cc:b0:63e:1943:ce46 with SMTP id 956f58d0204a3-63e1943d20cmr24087137d50.38.1761346380903;
        Fri, 24 Oct 2025 15:53:00 -0700 (PDT)
Received: from [10.138.34.110] (h96-60-249-169.cncrtn.broadband.dynamic.tds.net. [96.60.249.169])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63f4c471b31sm115469d50.25.2025.10.24.15.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 15:53:00 -0700 (PDT)
Message-ID: <3ff4aaeb-61ce-4b72-ba90-1b66374b1b95@gmail.com>
Date: Fri, 24 Oct 2025 18:52:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/13] x86/xen: use lazy_mmu_state when
 context-switching
To: David Hildenbrand <david@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, Kevin Brodsky
 <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-12-kevin.brodsky@arm.com>
 <f0067f35-1048-4788-8401-f71d297f56f3@redhat.com>
 <348e5f1c5a90e4ab0f14b4d997baf7169745bf04.camel@infradead.org>
 <70723f4a-f42b-4d94-9344-5824e48bfad1@redhat.com>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <70723f4a-f42b-4d94-9344-5824e48bfad1@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------fVWE7l0lJ0S6BZqVtKd8YErV"
X-Rspamd-Server: rspam05
X-Stat-Signature: wxbm63saxsbkth6ggosp8xj9hdtmiis1
X-Rspam-User: 
X-Rspamd-Queue-Id: 25C074000E
X-HE-Tag: 1761346381-43479
X-HE-Meta: U2FsdGVkX19a+RPNNl5ZjjX1kCFOeHa36Htoycw3yrPU8MWUl0gl+raX7zxpsfWctvfF7XP10Z82UBfLQpj6njo4sUyepB8uejKUyiwzMQOt3nCfDMZIyqU/C/SXIsHKkinyPpPf18DFZwZ+X2sVVq0SMiy4CG76jDKTcZIL3vstp9PDGe9iidDvyLLyTpBkbD18l6hGiJcuYakDCBZz77GoGivREz5PwDWnaiQ37pgxnEi3znmP4KU0plVl3KoNnn8RpH68qPAPf0y7YND5slYkL2px0jxxx686XFUZ5F290IYknwBjWiCDKVDBRkFzB398ceME83gNoX+CEUivFrwlWbEWVFDk2+SZDPaUUQJs5RQL5mNU+k64vYIUk5Vr45QmFKBzTvNmxAP+rx7031E6Wm73YgS5ydrbpA98Q7WmKxm4b2EIMEBQExL+J0G43gRsIEw9sVV+91/54YKEskGcFEDZ+Wly2gw2nZ9IlN3zGja3HzVZ2mwLhNQ2AX6ygr22puYT4n8Xa+/8rWSyZM0/NdWLBXVUyoQM9r1ImrEcmyhnP6jl1d24//qGAoJvF+7jbnfX0dbdjiwyn8H7mSDCB+aTwKCN5L/1Hwhy6jV+k08+ZSwdBYwAevdUYomVAsYxE8Qh/uK8QQ8xGJ4Fp/KEGurwqzI9wr8VhTOo4EOhQaMfPtLkVT+PZoiIam8OTp3TS5SxdLxLF8darg/bShoRtxbBab6YgbRBW9NPjv0WmP22S9I+c+M7GEeOHDsKQxNurUor0bFoUT5OcMoNtrYn0lFl7bhx2nDtmKKuljfopjDygV3Sfe+fa8nQ+TI3ZnGVh2kLsvmKXmXEd/n/tA9rU+59v2JTetCQF80ZBuEIF+kyXDa5vtNbvWbP8Ndeq+m1GK0FVBL136PD2dVQx1jfjohBb9eVNqZeSKRNOYAdV//vKvlBOM896tivOCG8xe2ocwqRRBb/Irs2YEY
 h3roG2ID
 zoZmQGLk1caV92YcGkayi9ajK22NUaTIpqFQsQES8ufOAFXkpKGV6f4HzwfsEA8RFCgUWn2Kw4CPmXg9+IsbX37PeaS8IWubRsn2q7k5iDm8GEtXFnVWSMV58pzGJZwfxZORdINYe4WciSkO6Ywy2bEZk5MXqzkjtSzTD1kL5+lb+U31eSA1kBNM/PKG808aNAV7HKJAWJvvyvOIUkYhtT4m+edUQ8yyPAiHxgh2opBsrxQhueRs7iFlyq6+mY8rxYwP4ERBEuXucN8fo0q1W0K3jwP9DUnDpX0tq19FMn38zXajn4PhbENypBQm/VgtQ0G+XmXGELs56xQR5AOakOXuUvbnajsD4Ui30btTNoc4f6Ca7vxaZpj0EjMth3OnmZBQrBmffne0AT+L7PKJKSEeXxvM7sRwEmpaScpSqiZWk1443+kAOWLRACoTI2TiBwcFB8LNKW42yv9YdmbpSY0NnX/YQBJpgDoF2rC7WzKr/7DJqHPAk3uDyPIr4mO7eJ2HiCQAmWxNLScSsGRvxAvbgSwhInTGPhHRxYr47UCCm9LUmQ8TK8e52GJvr22DeVqrAYYOJWDJGoQRP3VWAmMJIO+IRqX1+IWKSy/mU/+3T4p9nUOifaErDy76XINPWA1oEfpcYNLoj2MRi0lOJ/ap/+nbdJk+N6plv49EMa9pnWKvt553Y1dYLpKJGFbrgr/NPsMf//Xx3KjG+gIOCRcRCusCoxte3Rbf2A1cXlrx7Yzu/+6Y62ViJjKX77IWO60DcHm5VWzjOmXSWhOAThdNcneM3LEcZsMU/6O7hQ32pBz3QYUj2xWypfiYmMdiED2yS+llfSXv5to0Z8jsHVFlgrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------fVWE7l0lJ0S6BZqVtKd8YErV
Content-Type: multipart/mixed; boundary="------------7Vdm9KUmuSRGLGKvKHtq4xxx";
 protected-headers="v1"
From: Demi Marie Obenour <demiobenour@gmail.com>
To: David Hildenbrand <david@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, Kevin Brodsky
 <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
Message-ID: <3ff4aaeb-61ce-4b72-ba90-1b66374b1b95@gmail.com>
Subject: Re: [PATCH v3 11/13] x86/xen: use lazy_mmu_state when
 context-switching
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-12-kevin.brodsky@arm.com>
 <f0067f35-1048-4788-8401-f71d297f56f3@redhat.com>
 <348e5f1c5a90e4ab0f14b4d997baf7169745bf04.camel@infradead.org>
 <70723f4a-f42b-4d94-9344-5824e48bfad1@redhat.com>
In-Reply-To: <70723f4a-f42b-4d94-9344-5824e48bfad1@redhat.com>
Autocrypt-Gossip: addr=jgross@suse.com; keydata=
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

--------------7Vdm9KUmuSRGLGKvKHtq4xxx
Content-Type: multipart/mixed; boundary="------------uG9jzKpwHHYZUrEKmkQI4i0A"

--------------uG9jzKpwHHYZUrEKmkQI4i0A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/24/25 10:51, David Hildenbrand wrote:
> On 24.10.25 16:47, David Woodhouse wrote:
>> On Thu, 2025-10-23 at 22:06 +0200, David Hildenbrand wrote:
>>> On 15.10.25 10:27, Kevin Brodsky wrote:
>>>> We currently set a TIF flag when scheduling out a task that is in
>>>> lazy MMU mode, in order to restore it when the task is scheduled
>>>> again.
>>>>
>>>> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
>>>> mode in task_struct::lazy_mmu_state. We can therefore check that
>>>> state when switching to the new task, instead of using a separate
>>>> TIF flag.
>>>>
>>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>>> ---
>>>
>>>
>>> Looks ok to me, but I hope we get some confirmation from x86 / xen
>>> folks.
>>
>>
>> I know tglx has shouted at me in the past for precisely this reminder,=

>> but you know you can test Xen guests under QEMU/KVM now and don't need=

>> to actually run Xen? Has this been boot tested?
>=20
> And after that, boot-testing sparc as well? :D
>=20
> If it's easy, why not. But other people should not suffer for all the=20
> XEN hacks we keep dragging along.

Which hacks?  Serious question.  Is this just for Xen PV or is HVM
also affected?
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
--------------uG9jzKpwHHYZUrEKmkQI4i0A
Content-Type: application/pgp-keys; name="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBFp+A0oBEADffj6anl9/BHhUSxGTICeVl2tob7hPDdhHNgPR4C8xlYt5q49y
B+l2nipdaq+4Gk6FZfqC825TKl7eRpUjMriwle4r3R0ydSIGcy4M6eb0IcxmuPYf
bWpr/si88QKgyGSVZ7GeNW1UnzTdhYHuFlk8dBSmB1fzhEYEk0RcJqg4AKoq6/3/
UorR+FaSuVwT7rqzGrTlscnTDlPWgRzrQ3jssesI7sZLm82E3pJSgaUoCdCOlL7M
MPCJwI8JpPlBedRpe9tfVyfu3euTPLPxwcV3L/cfWPGSL4PofBtB8NUU6QwYiQ9H
zx4xOyn67zW73/G0Q2vPPRst8LBDqlxLjbtx/WLR6h3nBc3eyuZ+q62HS1pJ5EvU
T1vjyJ1ySrqtUXWQ4XlZyoEFUfpJxJoN0A9HCxmHGVckzTRl5FMWo8TCniHynNXs
BtDQbabt7aNEOaAJdE7to0AH3T/Bvwzcp0ZJtBk0EM6YeMLtotUut7h2Bkg1b//r
6bTBswMBXVJ5H44Qf0+eKeUg7whSC9qpYOzzrm7+0r9F5u3qF8ZTx55TJc2g656C
9a1P1MYVysLvkLvS4H+crmxA/i08Tc1h+x9RRvqba4lSzZ6/Tmt60DPM5Sc4R0nS
m9BBff0Nm0bSNRS8InXdO1Aq3362QKX2NOwcL5YaStwODNyZUqF7izjK4QARAQAB
zTxEZW1pIE9iZW5vdXIgKElUTCBFbWFpbCBLZXkpIDxhdGhlbmFAaW52aXNpYmxl
dGhpbmdzbGFiLmNvbT7CwY4EEwEIADgWIQR2h02fEza6IlkHHHGyiLVf/5wiwQUC
X6YJvQIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRCyiLVf/5wiwWRhD/0Y
R+YYC5Kduv/2LBgQJIygMsFiRHbR4+tWXuTFqgrxxFSlMktZ6gQrQCWe38WnOXkB
oY6n/5lSJdfnuGd2UagZ/9dkaGMUkqt+5WshLFly4BnP7pSsWReKgMP7etRTwn3S
zk1OwFx2lzY1EnnconPLfPBc6rWG2moA6l0WX+3WNR1B1ndqpl2hPSjT2jUCBWDV
rGOUSX7r5f1WgtBeNYnEXPBCUUM51pFGESmfHIXQrqFDA7nBNiIVFDJTmQzuEqIy
Jl67pKNgooij5mKzRhFKHfjLRAH4mmWZlB9UjDStAfFBAoDFHwd1HL5VQCNQdqEc
/9lZDApqWuCPadZN+pGouqLysesIYsNxUhJ7dtWOWHl0vs7/3qkWmWun/2uOJMQh
ra2u8nA9g91FbOobWqjrDd6x3ZJoGQf4zLqjmn/P514gb697788e573WN/MpQ5XI
Fl7aM2d6/GJiq6LC9T2gSUW4rbPBiqOCeiUx7Kd/sVm41p9TOA7fEG4bYddCfDsN
xaQJH6VRK3NOuBUGeL+iQEVF5Xs6Yp+U+jwvv2M5Lel3EqAYo5xXTx4ls0xaxDCu
fudcAh8CMMqx3fguSb7Mi31WlnZpk0fDuWQVNKyDP7lYpwc4nCCGNKCj622ZSocH
AcQmX28L8pJdLYacv9pU3jPy4fHcQYvmTavTqowGnM08RGVtaSBNYXJpZSBPYmVu
b3VyIChsb3ZlciBvZiBjb2RpbmcpIDxkZW1pb2Jlbm91ckBnbWFpbC5jb20+wsF4
BBMBAgAiBQJafgNKAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRCyiLVf
/5wiwYa/EACv8a2+MMou9cSCNoZBQaU+fTmyzft9hUE+0d5W2UY1RY3OsjFIzm9R
/4SVccfsqOYLEo+S0vQMIIIqFEq3FCpXXwPzyimotps05VA8U3Bd7yseojFygOgK
sAMOAee2RCaDDOnoJue01dfZMzzHPO/TVdp3OvnpWipfv5G1Xg96rwbhMLE3tg6N
xwAHa31Bv4/Xq8CJOoIWvx6fcmZQpz01/lSvsYn0KrfEbTKkuUf0vM9JrCTCP2oz
VNN5BYzqaq2M4r+jmSyeXLim922VOWqGkUEQ85BSEemqrRS06IU6NtEMsF8EWt/b
hWjk/9GDKTcnpdJHTrMxTspExBiNrvpI2t+YPU5B/dJJAUxvmhFrbSIbdB8umBZs
I3AMYrEmpAbh5x7jEjoskUC7uN3o9vpg1oCLS2ePDLtAtyBtbHnkA4xGD7ar8mem
xpH9lY/i+sC6CyyIUWcUDnnagKyJP0m9ks0GLsTeOCA0bft2XA6rD6aaCnMUsndT
ctrab42CV5XypjmC4U1rPJ8JQJUh1/3P48/8sMH+3krxpJ06KNWNFaUbaMTGiltZ
7x9DngklSYrX0T+2G4kVXNmjaljwkoLahwLla2gUWwBSyofXdqyhQdwZsp01KXNQ
UCyT/Pg+aDcm/E7OMV3d4lf7g/CSxiX2GSEe6BlhSz+Lmd7ZJ3g32M1ARGVtaSBN
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
EtJuZYM5blWncBOJCoWMnBEcTEo/viU3GgcVRw=3D=3D
=3Dx94R
-----END PGP PUBLIC KEY BLOCK-----

--------------uG9jzKpwHHYZUrEKmkQI4i0A--

--------------7Vdm9KUmuSRGLGKvKHtq4xxx--

--------------fVWE7l0lJ0S6BZqVtKd8YErV
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmj8A0MACgkQszaHOrMp
8lML0hAAigIfQ+XuV1xY2lVweZbTOXQw4gbWwhzVyP5xYwcJ9cNpopsO8QhCpx+l
CD051fg3GGh9GbWDiXJaF0OuflawLIQruAU58oGe3FGMJu5FQ6lt3h0U4YHX13hy
XrZY6Y780Rb6BIhcQFP1hLNZ2xWiYi1jORBEsIiNe5B+wKhV4eEz8jaJuqmnnG5i
i660PErOwV5kmXYGn/r/nBwTtPTGUSmqOZwiY7YkpVFmPT+qiA3+RN5fsRvKu8sY
AI+sEbqdGDfYtzp2lKYDpKtme2lOAVONjzlJa6TAKa6Vmi8roDfCLCZ2yWxXviAo
FVhfUH+hEsP2Q8i/vCtT/iJ2ErSRrijlH9x+bMV/YaS/ZYpvHmM/MbAGl0+1//6B
3p6Y9nNSGk+CegsiOExJ/bGAFLKUU0CQxCXVw1AiaRNW6DtvIK35tkUhWWXflRik
9dW8T/OoFJE3hknF5zoa6nhlKYiZWc2OsXp64Q4KMwRuthqW+c23mTXuQO10NZvi
5eEDTPW1vN6hldCnAh5kwurHM/apb7KU4df/6oZkhER/I9LERfeURsayC6G2r7+l
kEytsJtUNMlh5yDMkUUPz9diUvqLEcJWq7oHHFT+eeLRnxa4uml9vV9buKCs7/DV
Ph6CGtySx1Gy494nr/xHj3MGjiIE90cASt1hOR7x1CKivw3/384=
=wFBt
-----END PGP SIGNATURE-----

--------------fVWE7l0lJ0S6BZqVtKd8YErV--

