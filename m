Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6091D606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U4x54eMx
Received: by kanga.kvack.org (Postfix)
	id 6ADE56B05BE; Mon, 23 Nov 2026 12:36:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E8E6B05BF; Mon, 23 Nov 2026 12:36:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574B76B05C0; Mon, 23 Nov 2026 12:36:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 353C16B05BE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:36:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADB68A09DE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:31 +0000 (UTC)
X-FDA: 85467088182.14.02B5B3F
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf13.hostedemail.com (Postfix) with ESMTP id CF2CB2000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=U4x54eMx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455390;
	b=Im2wHJvNmvtCuRRI6fK6K+s8TyMlBcj1yoymHYVy2rK0IZ9LYXRp68F/A70D48UOlEXKNk
	6tXVVCJY3kXUgdZzKTqLAOleX4LKQdRLirThJr0/bt1RQBzhll6qxZbp91O0gXUHZ4IfaN
	jij5l0wmokxk8LExsEVMmxLaAyt05ks=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/aUT5PBmLZcyNJkQoSxFcXbcPE5jdOsaYBnBQfYlQU=;
	b=O34KsxAJgmuJSHyi2DrigObSKPCG/8Kpub40tVICrw5xNubvgOy5VlABuXEPBG8RLPyRB/
	RV4XUhruofNILz5Rdb49UGDjy51x0kNTkmEbJVe/ciQUvZza8nNFy69L6/UoofSnE3FvjY
	6hlAh7v1T9HOAcoT42ZilYrmzexMENk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=U4x54eMx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-3831d564bcfso1418761eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455389; x=1796060189; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=G/aUT5PBmLZcyNJkQoSxFcXbcPE5jdOsaYBnBQfYlQU=;
        b=U4x54eMx96hW+2XvjBHah7iww43uJ4AtIBaMgCTj9ui+xPK4CWhncYc7vFgLUcDo7E
         1dEsdlY4OfF506qnQgy752m8j535B29QhvLUj1ee/yY8AHJ+BgaxvnbvVuJfYu1SQ93o
         tVP8c1A3FKaUjo0zDQwlwRzfvBWC9toO4mQ6uPJHseOyCXabo/LdoHNixBsZFBewYDvn
         mM3dqIPxWQ5g/Kk44xWDcC81Hqx/C3W3ta6R6XW7VEW+zrG+n9C0ZxdoI7HScJ7Uox5n
         fmJN+7fqQUzxAmEKRyUWb+WauEj6sohQwOnpOdunKMYiSUy4Lu3AylbBiDwKzaiPnjt9
         C/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455389; x=1796060189;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G/aUT5PBmLZcyNJkQoSxFcXbcPE5jdOsaYBnBQfYlQU=;
        b=WpMXRSNLgytZSLuyEFos0cqKujhnryQXakL2x2yqCQmhyL3Aw0mZrRnOx/do2i6qtO
         pfl+bok68MbNbuCK6QUmRwm1Wi+wuv+uwmWCzD5cOP4hsHWd7vkRD6OtTfe4MpaQKo42
         2APNpOldyLiBg0x0xx7uS/GnVJgbDjlXL8v+CftDZaWoK/QSGkcp3pL9KqsOH5k/ej8I
         ndgX3jCAP4XQ0AKFA7FM9L8UgzI+QoiKwoYlvs0zP2cjxZSUU70Iat3CqwT+k2zUjYNk
         29FM73oTNuISB6N9Hsb2EDEDW7K/dS9/sH06mycM4bYkP/IgOBOlX3bOWoDnXlxVnLwu
         uiRA==
X-Forwarded-Encrypted: i=1; AL+hErF2ouVxiExTfH817oCArCa4xpHosJLapvf3Iv1oG1DCDB7EmQWS76GulZ6kji2SdjfEEnduGRWPKw==@kvack.org
X-Gm-Message-State: APuU4Z9vwDfoPaH+JgGO+gmQwGnIdS/AGZcl41zvDWjTnwOZeWn1ZcYY
	Qc/X5VoPnYO4Ot055ty/yti7fO1rEWkbofHWklrPzuebbkODHFwFy5hO
X-Gm-Gg: AZFdTZdQixSj5NfZzDLGm9vQTFThD9zWSJ0ebIw+Sp3v0o7BWOvRW8slN94b6/OUbr7
	U4gsftcXGkfu+ipJ7ts6WpiFSl/ycecoxCzArRKkq1AMB7H7hHO9s4jtCyEoO5g/lrTpDFptolA
	gFiKpvbVomfX8jRcaT6lpsNo/SLEfStZd9thAyP5I0M5TVw2jC3cUt4TlsKoEY/ndp0qdFj1kjv
	MaFhD6TAzJnx1qFIO/gt4Nzm5W1BfziEsR950Sj7zdlY5+ydabQ3+GcqYbCFAnCE/bRFCA+x0cq
	DsqKmvrMnQXhoG76b0hft38b+ep1SiBJopJ2dUyhYrwRHpKvBpbAqPhED8WLIwygJy5gcWw+S8G
	9Doc8yJxfXOj0ZMc3ke+BnF5oJ9poX8h4Gq4sRMWln4969fjdVph4d41A5+SyrGUcY+Mx3fUkfy
	2l8cyD+gyfkWDwi8kYe3ZXhbddE2rZDhFMjDp2n8Xc0709yqGlcaBZa4kW/tbIRHp5orYloykXk
	CzwHoImnj5ifHZ74R9TYIVRmv120xvWLRR0MFgHkqRheNU4oWwt+vtJXLo4hxYtB6qZLXEZ+9eJ
	xiu8waU74hrNBzarWEaXXi6+vlRm8zTio4rMqdRC1pfWHK3TfKk6dsDn70H4nvTvl1/v8roP6Ou
	5ovEtUiqgvajet11BMN7q/mTSG1BO7M7xyNZy/K/hCteM1lt8TKzKQQFhT2qSQA==
X-Received: by 2002:a05:693c:835b:b0:386:b5ad:b719 with SMTP id 5a478bee46e88-386b5adc3cdmr2651925eec.33.1795455388511;
        Mon, 23 Nov 2026 09:36:28 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:36:28 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 09/27] Docs/mm/damon/design: update for report system
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:25 +1100
Message-Id: <179545256500.4.7925013692568446528.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-doc@vger.kernel.org, 
 linux-mm@kvack.org, Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261121210013.130397-10-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-10-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CF2CB2000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: u39tr1gi9eswffbbtwfjpskb5ykqeh44
X-HE-Tag: 1795455389-194512
X-HE-Meta: U2FsdGVkX189bEwwH7k3BPqTcYOBFbg1D6MvfWrDAs18ERilR+ZmBfnjOnvoNpWeeVmMYIA3T9UTBWdnMnP58oBbXOaqlGW3TTBhTP2PH4yjQsJReIX5phMjReFFpO0/X4vPXdUSDfYNq1PMVGIE0SVVC5JoNs6aVfxG5Q98H98vmNoXvG9zXyegv8Wk4yYpfC43v3NiMZSNBuMbjBlCGsvb8778TLuZukbbzPlu4iMcw+oBV0rhiRUanL+hfNva11nSQPK3da5f053ebX7AVECbxNyud21is6Kgr1F3QtLZ78uc2csG88BqBRJblSuqiGdXAV6Kc77WjtKK21gogKp8gdb7fdrsTorFnobvVp/SBryru8EgLn9IeOFPD+rB5Uq+4YVZxmDFi1jSdrA4NaIl52jffbO/0nXbpbv6pihlvOnWeUAwGsZGF+DGN+g0tuxAykOGQtUNyF71qJD+yj1+Vd9y8jUbRBY0NzDUKNKm68/zSsvsb1ZCxr7SiO2NYb7o4aeczVBm54uHLK6b44HYJIxW4UJ746WsDOr68G4kNVvSnB48p/giCuuHQzoRqNlSQYzSurfN3IVUn2F+Ee3cv5v11x8SrSCZZeWdja/bOs2WyNHRYtJ7C8XT3Q0knlTeVD3SB/sjydNqO2qD9PDEuJUokPYRWQBSyf4yXSa9NnoqUHTRQEC7+xQz9VwHCNBD0lTDfar8wieEcSPJN/cM5uzmOzbc+mYXxS0Vye1nkAM/RWuf65CczhNYU3Iv0K9yRgLdLaVghzmCpu1Hdx4oPjqCmkbodi9BK7QjmpKYiNygzrGDC0AI0kjj7NniMAbxrxzeM+6HB8exmnDmYHEQGc1gpo4DUYFYzzOkzPv1mOU/BlCeYkeeLg+fVm2KV19N2f1NiLms/2CuTkAlFKHU/nHYO4ydKCCltLLFa2iGh9bhwUXI2IyFDtx5I8mFAmDZW0vJ+CGaEnIdLk6
 6gpNyE0b
 ju+nkI2OztWi1pAlf43hA4VMY4g+KAkcBoYSAkn3No3GsDiy7mV+zWTvkcrqFUVfy2Ff9r65JAT3JFCqVSJ8w9RaLiA3S7ZK+Qbqk9N0j93d8krIfUVp9LoTlETVMsRo8u0evv11cMU9E4DMcbcvKx9U4mLl8iY0LO+fOzI3/4R3AQLZb+QEj4aKsZU0WmivGNFgJDi9XaOT5tW14FRujinwLTUVzdFD3UInAcmeafbnMOBUbeAhEeOYi46R4jiOQj4vAp/KbRVMfKp8F9Dvl5i6lY2kPD3mhKAM1RyuWAeRUS2G7Ie4mKWIiYOlZnYkguvThaM9IlPLYV8uXmakTT444PkxOV6qWx7eEVZw2lnAauwPyXuSgQuELZAj7bjbzvNey/NeJm30Eij0qc1cm7shjX8EsnKBF4MaaxlLy6nZhm6MW82aTbmTGYogooIfmDgI+ERdqTpTTxZb09OmOWPAZ5TjLBOFPJhwmHHNt0FFU3gL0mGKXvhyyxxnaBw2neuv40hsAAclOQc5blyFSyEKJe4Uf9gRdnjUVzN5U5sM4F+3KZyatjzZ9j4ee/ugfg7sBE9KI1qb2yqXu8Kygoc4IXSKtDobc4JY3Aw4Ok45UhlQiGvES2fqMovWhwlX4nD012RVH3ZD5ZMEsSg3Dvt7/SW6Lc2Mf31RHIK7YRfvAlIIKhpudTa8SYrc1dsXte1G1aolCG57sAXc7gi46S+Cc5or2bPU0Dz7QHwvDIMS2xsv3VGVGwqR2HaN9ZJXeO/tCJ62MctWm2u8m5HNSAszbcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 12:59:53 -0800 SJ Park wrote:

> Update DAMON design for the data attribute report system.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

