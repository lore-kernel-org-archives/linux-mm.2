Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9CC3606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 21:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=b2acwWPs
Received: by kanga.kvack.org (Postfix)
	id CF8BC6B05B0; Wed, 11 Nov 2026 16:28:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA92E6B05B1; Wed, 11 Nov 2026 16:28:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97C26B05B2; Wed, 11 Nov 2026 16:28:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9219B6B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:28:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 22A161A046B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:28:12 +0000 (UTC)
X-FDA: 85424126424.21.9FB7ADD
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 18BAD4000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:28:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=b2acwWPs;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794432490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZoJPYJRE+a3rUDuNJFthWOEClKW7JBQ6lGyHIzbta9E=;
	b=UzQTsMSeAIbMJQGy50fQVXKhH8Ed3JKJAiWC8yLLbqD/KUh61cdSKaNf/ap8Ro4VX/owco
	iWKVw/EEG6tabf383zb6PqD8A7I+j/yV38Ez9gq6NsrLl05Ze+XX5NT3y2Zm0vFgeZy5Rs
	fTg6MARLAen0CHQHiDeKakfH29H+f1E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794432490;
	b=U10eQqdeBT2+isDDw6VoDjjWFO282SoUBd3n64bwUFBa4jpw9QIbOEcyQKBE5XUpfMuHXR
	ibZsiXUYwt0nCARUdQ6djAi90lP5BaIab3vV8DnEsg2/MvfolNn4naaC7s/WT6u+f1OKEN
	37SuuMN35E8CI0cL8iDxFEdgYMLxxIA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=b2acwWPs;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5ee1e4e3abcso330782e0c.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794432489; x=1795037289; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZoJPYJRE+a3rUDuNJFthWOEClKW7JBQ6lGyHIzbta9E=;
        b=b2acwWPs3HyI+gaofm/rhbh/BbzScq3dRR2XhIWZf7wLbJS6jfQzSsGHaghALVpW4x
         /u+HvXlakc7lTV1YyeBtdLTqqfKPRtlsNtDweWV4nm956F1tYwKnn5iwM0t8mDMqb4r/
         m9zUGhcSlANnPz/zN6x4qP3N+OP/QDcaSqeio9E5J8iOIQN7tSGVeGKFN7cZVTGQOnr5
         qqVKwcY5WeJ+acbxp7Mho//HuiLgTInADoekLPFjd3RBDPJo0TOe5FuhURBKd+2OPUbC
         TuoZS5OgmHh6f4td1y+yPF8ceUhFPSC+u5SomFgc9MBAO9FwxYJc35SUX5hQQLzJEGqk
         Btcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794432489; x=1795037289;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZoJPYJRE+a3rUDuNJFthWOEClKW7JBQ6lGyHIzbta9E=;
        b=JPoIzBe9VqzbFl88gu3gb/pbOUklm9mehQrQlM/wJ4dB8Zca6kW3dKWALhMS4IuVd+
         /PonaFhcM8cIdgp49n97P2GnuNOR+suG+C+URf9/WzWIh8aNniN9/myq7K1zVh/bQi0D
         cz89RaWIDbKHd+SFiygaveaRu3Xoepyc1mDg6VYwdnZIF8tOsZI9VGAmzpM+6WPlh+ZZ
         B0pku8sjcGH0qwYPJuxEUExgTdMyIyCB6YayQjibTA0iTajb0r9WOvmnJsXvyPei0a+u
         NlL21PtdbhPorqzJsnMIhwmp8Zoar7yvBt0NYwC6tUAOIwq5t01aLH/hVEAwabDdgdy0
         lPIw==
X-Forwarded-Encrypted: i=1; AL+hErFiq4A38lfuA8cDDeBEzh4zY4FP+X/PRvoRu0HbgY7T1l3mTg+ZGgXA47XacaLRi40huBPGwjIRgw==@kvack.org
X-Gm-Message-State: APuU4Z/FgElUWtv4h0Hl8SFH/0jyN/ka+qFa4shMyvfHACbAp6bunNP8
	6lrDCs3r+s2jWxn3jt08abyJPgT2HwuY7dClt2HO9kdUV1NFPe2yo2X7kp7kdR860Dg=
X-Gm-Gg: AYBFou3jf6F9GTkvPpymEHyuB0Buoicg4plp0mefVsTuWZEpMXfzXz8QvN1Ei8i1fv2
	1uDviU27BeukG2erDSfcZEJ2PZYy7dU8ENClC8gVOYQcCpZC1pjHBGKrCI5QJn3bTN3ERV4AuGx
	9LyLIzkkTFO4fsEuZFn3/L4DTRPFEUdOlx9CK3BJcMloL18OT0gaNznirFhIlBA9/4I7IQ2M2sW
	TsyEKwAyHtopYM7fpV3R/8LFPQhqYwhn3J/ZuCOqJJqnKaA9p6zIiXjvANyLqwPgZhz1NncRqdV
	LtLDRwBbtvtPvbVc+bwLvmt5kbxCszrvFT4ys38lDpwxX+IVwRcUg9HNt43+vByYBDYHVkvvuJI
	2wVqjvowWA7r8ZnhwkS9q12PVDVM4QZlA+Tippe2C0i71jJDjEjEtHxZlVqiQVmOyht2fqPTEHk
	qMWkJU0CxHJpwvbymru0wvmbjdzc/ucUQdqxfMImGmwPQTrIw4ZMr5/Bljzb8IWILC8sLWUuirY
	PNpdWj94Eq96NmH8b6dw/rOwqkGefdzYWSNcWemI9/wxZRlF/HME1f+wAdlAuztfINoXx884Ozk
	/nzf3X6Dv8Wt+/QsvvRngdt7ImAnoOqwGPr/B+crmFw/939PEwZD+ecg0e6fr64iLUXRFEy+OTb
	7t7vguV458F3V8S7HbYJWg7nfNjXlFLD6PAPZ7m7+mqSc8Cs=
X-Received: by 2002:a05:6122:d29:b0:5ec:e7e:27d6 with SMTP id 71dfb90a1353d-5ee1c3f4dc3mr1648884e0c.4.1794432489164;
        Wed, 11 Nov 2026 13:28:09 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee0c45a110sm5203554e0c.2.2026.11.11.13.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 13:28:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] kho: Prevent reuse of preserved pages after a
 reservation failure
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Chris Down <chris@chrisdown.name>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
 graf@amazon.com, kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com
In-Reply-To: <avQUquBK6cO6tUUI@chrisdown.name>
References: <avQUquBK6cO6tUUI@chrisdown.name>
Date: Wed, 11 Nov 2026 16:28:03 -0500
Message-Id: <179443248353.2329176.13720873996862751451.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=543;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=elFU4wPAMaBwFrT4m33njt5Q2auHHtG7NC96QfM6Q7E=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq9N3nz3mQqqZrDWc72K1rOdBUMPnBo7ID+Ai0B
 BiIhG8vS0SJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavTd5wAKCRC7dyhM23N6
 3hSgEACblS54tgUdblcItbWjWQY1CPYiO7TGqqZhhdrLqVtXFac+KaDZHty5ilwOQXbXz3faZP6
 tSkSdpg4RSpnv9BxJ0pgW/oV/uWlh0ldV1rXZo55QTXgkfYapVrbiYNWmoiEkrvT3XUOwfUXjAk
 y4kMM3Lm+6imri2z2cC9ZwODXrzlCak5wtL6z9S/AwC/EfB2Qr5z0H8irPqr+ixQckAkOM6as62
 HHCCumwW77zcIs0HjI584FuSyvGGnYt1WQLtEMuIoco6wk5Th8XTnHNBWplpX8hk68PTQZ3uddJ
 OHUEnGOGB3+0cOjr/sF6hbtB94cP/StjzirPi6UHoOlkXaJce+SG5a3qmCA3VyVjEJgkcopWCL1
 /9QRwBV1NNdNxGUDdxv2WQK5jM9lsz5P7QaZN16XY5gveQW7rWNBF5MiDpLmZRxO4dsFjqb5T0k
 62ivZnDTjzdJHRWUNby3GJKXKz4u2CKBivaHxBzPS+bD8k3RV4s7fATfYOsXyCJdaLkiu7X/C9a
 a36oBuvgU1+tAdW6LkbWVkUVwDzRoevrZH16WKRBySusP2btDD/wwoCql/HTBtTB714M4SKqfuG
 SAm0mxL++DCkiyW05CAijA4BWVFgswkITvUwI8pbEhX09pN2OB2PdueWiuuK01EoDtKz5yQBNyI
 /5AJgaT3+KKUnjQ==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: gbuxdgeic3rz7heoqxqbomy69dbhfex7
X-Rspamd-Queue-Id: 18BAD4000A
X-Rspam-User: 
X-HE-Tag: 1794432489-851837
X-HE-Meta: U2FsdGVkX19bMUXY/fWvNeu+4PzVo63+8adopztHXg2vnblbfOKearO8BBf27f+pG0xC8a2R5mXBZkrLczVdZm4fM77VG28Jh6LRCeDiA2gZwEJDdFNihuYiS8VS78E0IxKOxm34vublzC/GfV23DnV7RTIMCXiqdzBL9EjYXBkHGdFvPubCuuvpQj7ArtXEy7dz4x3oFiVdiF1vkSbt9fBEH32vQ2F+OA0NkugEx2doWqYuRfWbQCk+SA5Wt7loJqM8Ch5sy4QFes+KInwrRWb7cYGXtlXo/LPuGQEV3bSutVabFlb4XK5kzevoC4Op5r02YlWFTPTN+60jQWw5MMeGmHe25mLbWpBLHJtluw4P3XoVzXjXYU+BzTjhHnb5FkmCPOb0aRBeHMjTNf5fdKNhoKYVtrLkVSW2FOJMWXELOUxEw/izcn96UeAxTg4q03kXRuWrZkiNjhBlReSn+di67Sgsk4XF31I0UYIPe1jpfbK6IaRCUin8ZEhgT88ET4/xmhhPiHOBApSTxrWH+EiZETC68OqUJ3d0FxGI8b/2+dQ5ro3c23u4cF+edIp2Zg2hT0NfYWMZOnhNGGr4vE6K06vePlFGR/OqUQIhgh0Qrvlpu4vnKCRCsspW1XY7PxIG2Y1Wap/DARV/ZHZCFWnMnOk7NLWXkKUvAMFCIptTI7aEB+TehvdzNLHMFd/VlkPhqbdfBmb0d1BjFq7ZEfNEGJQ5aVZjFKc2jnAN3j95sepW5woERqsZSkq87xZ29YzxDWYP1PkJXUB4bFdPmUH2rVd+m708uBiyYWbgGInWLX83Ske2Gp22AhPErqWEv5syOaTrc0j7LuVFEiS7dK26z+q8r1A699B+wrZLsR8aOe2OYi80cgWW/q5P1gdYjOhsal9zIq1JXuc1azcLzJtWFyRFR4Vh4tZMNFQ3oLrB91503BHaS1S/I9/T2OChvIcJ8v8af1zJC3r1WnS
 6BKvjMuE
 eRqbRuytKntGge7/p5Id8Z3V+qpA5whTuqX1qx48uiG6IAyhaYvDqQNQnY4YxqrJiVtxSwxGBY2Nmy+oNmkxoTQ2EYeUgQiyURvAMcI2acii7uhwsCwIKm5snFB0rpwX+5FbMmu7UNAQndV0yyibRdRTr5JDKdo66YwfTXG+dZ0p8nSzRa+ZsLoeYX9C+L+XTfBJ/D3SCj1UdVefJW2Xo8y+t+lAliSUcYAKqutlo3tSAZggvxQYKYEocZkwmC/d/2CjUbNPEvsEES0fGjgb9VUlR9XzSdLX7hI+dwsx5vZxF79xx3M4cnA4k5Q7CSsVksQFRbCl8U7b64Ko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 23:09:30 -0800, Chris Down <chris@chrisdown.name> wrote:
> kho_preserved_memory_reserve() reserves each range of preserved memory
> in memblock and marks it noinit, but ignores both return values. Either
> can fail when memblock has to grow its reserved array and can't find
> room, which at this point in boot it may only take from KHO bootmem.
> The boot then goes on as if the range were reserved, and two things
> can follow:
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


