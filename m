Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D6C2606A33A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=O37Mbu/G
Received: by kanga.kvack.org (Postfix)
	id 26A576B05B3; Wed,  4 Nov 2026 17:06:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 241FC6B05B6; Wed,  4 Nov 2026 17:06:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133D26B05B7; Wed,  4 Nov 2026 17:06:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB0AA6B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:06:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2C991C4289
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:06:48 +0000 (UTC)
X-FDA: 85398822096.02.3094483
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id AEEF5C000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:06:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="O37Mbu/G";
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793830006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ufPIe0MNsaPL8q21bT+XXMgG6he7MqxkIOdgpkrKFhc=;
	b=qyshVNWOJ9BXZcmAgTTzzGwDx4KgoxaKFmeh1rAFA3beXdueazUvyzDlHLM5N1nwbt7szs
	J1+CbXMAYFRnp3gsD4tj3plSXQdExq1D5XuDYBAiyYAelpAexqJqhFhp379robJxHJ5ptv
	RjDodO67FD0DSae0icmYHO0PJKDe25Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793830006;
	b=nYZBhxLZ4MOu2Gb56VMo9ZxlcTpuSnmhaqP45Gfv8iecikv8rAg/wcFFSDWtJJ2EJ8Ztzf
	DpZ6WnfJyv1A5B2AANeBwxP3X6UmhsxIWUKRGCNZ+ia147XwQ7PkuTiYWZ1C3qlNPzrN2z
	YjDfRURqjKpyo6pIunVE+78OavfOCrM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="O37Mbu/G";
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5e948e56af3so437558e0c.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 14:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793830006; x=1794434806; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ufPIe0MNsaPL8q21bT+XXMgG6he7MqxkIOdgpkrKFhc=;
        b=O37Mbu/GaIRlONwCeYrZPjFO1lK4EwESoBgB1jPCi78ugpq2T4tJXfes/x02n5yN2X
         vnqJDE++l5yE+GQwggfAffLuvGTiw4tFxs8jXYAF5+3uIdJ1LrP4k13xqfrUKEHLy4YY
         e5DVFe+EO4A7ql+p/252YSvmPq9Y4WbYFqJyOs4LlzWn6MFkRI1kG8F/U3atF6NAY9+I
         7oVRnAS2sBDmxEI50cpmPFV2MbFKe+/107KGa3Z2hb0Yp8z2AsghqddQ8vGtqhOG+s+Q
         KXH+96XzEgDmGaBFo9ByHdoJghtSgnjB90YlXFfM67HDJ7OR/UOGJcd68Eh4QgQnYbBn
         2dSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793830006; x=1794434806;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ufPIe0MNsaPL8q21bT+XXMgG6he7MqxkIOdgpkrKFhc=;
        b=0cTRp3pxWw6i5WYCea5DxTNil3Ov3hmLzk6r2uxZXDUqEHaUmQrxL6GZYMXg+4brbC
         uiZi7p/kyKkBdVkaFgvxgZmYMDaJa0EyOmSp3GWt5KutrzyA76XlRzVyC61e/cqGKxCx
         M6dh+aIF2pAKdfAy5X6XHfpZkmeZX3wWQXCE06h54KEwaykKAEc+RBvQCdy8s5qo8un1
         dreciLz1v674+pUPTbJfJRTR5Vg69mQ+d42gDB7oAG0UG/h/ZsUfpxqI79t1S2xDgYoU
         6HR3Sjaw4BNNExRNv1k14F21kDSE6RpJw1RKDi5gawvNH8FxN6HmYeho2D2XgjyPCTZX
         nFbg==
X-Forwarded-Encrypted: i=1; AKwUvByug1mPqV+UmY9ZEgy3KDhpGRiDWLzgqx+m71DEVPVgfTD/ZkS1zgCvXyKfVeWyqUbTFwkoAiBA5w==@kvack.org
X-Gm-Message-State: APuU4Z+qH1i+LYCaKHedkW68962q5YPPLAAk0VaFQRu3bJHLuQ/vURPp
	fW+nO+3kTsYdVuPNIa+TiT+hPrYjha9ZWKCzTfSHLd3VC9gaUiDu0oFRl9xMYrZwOJs=
X-Gm-Gg: AYBFou1c6py1lCbjjtcNcZ/kawwxUzN4n5AI+2R+YqfJDuNnoVl/OAoHDPEbj3SJUox
	MA6bbQkHbOT07yvwULU4q7ACn4Ax3b82X3XlmW5cCjuOgXvB+mkpfKRU/oSBi1RzTEkWJZvIQvw
	XOrbNzLjsEj/ld6eoxx4Yn1QWAT56tz/R0yYmxk+FIbf+JJ9HYGuGbAwvwVa/yZRhHTFoVZabf6
	Q+HHNPr2tr8NXU6YT/9a3KV0N/yDNAkipofIheEYR6H5/rSAeHcIEFODyGqq0veUncEmQOkCeQU
	8MCoeXFHsjpHuaq6w94FnpJsBihSDuWarF7bPyNWhy0sLsD+xs6zOiZ6DGBaNgS4lKdSJ73YfjI
	JVG/UBp5nz6YA8Ofygmh+zIx0XBvAvwNC9xehE6fy6TdEJGrjX26QVyegIgUL0E7d6aFpouNaYo
	fEOErGCMNc4z73rgd3p0sr4S0vXxiRqPMkKa1NmJUAW5MdTo9aWRpprbgzJgVOodPlNB9LGID4H
	v0XNMTxY/GIT/xJ94ZVhsNWcrBm/g1QpkOW6/SvM9Qn9f1618Oh2Hky41qeqAPJDGU/3l5CiaAE
	MoO33DVTEm9MzIXLJfXi1EQ2S1RoI8duwPzoxK2wr4o1VsVsUooqaWIlEU1OyOZB5YdHJA0JSQr
	iKU6FJxzoVxkCYq7wprzuamO472L+G5UkdLwxy5K/hLo5
X-Received: by 2002:a05:6122:310b:b0:5ea:cd4f:8494 with SMTP id 71dfb90a1353d-5ec6897bcc7mr7448416e0c.16.1793830005585;
        Wed, 04 Nov 2026 14:06:45 -0800 (PST)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca8d774dcsm2714498e0c.5.2026.11.04.14.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 14:06:44 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
 Alexander Graf <graf@amazon.com>, Arnd Bergmann <arnd@arndb.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Changyuan Lyu <changyuanl@google.com>, Thorsten Blum <blum@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261104162352.140836-3-blum@kernel.org>
References: <20261104162352.140836-3-blum@kernel.org>
Subject: Re: [PATCH v2] kho: Remove redundant 0x prefixes
Message-Id: <179382998668.2089669.366825701461081981.b4-ty@b4>
Date: Wed, 04 Nov 2026 17:06:26 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=328;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=bxNUDneQzMXPopJ3U7vhIU7tZ6OZ2ltQlUaSDgbGkI4=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq66xzJBj4jQ6s4ffhsZHum0EOCVZkmEy4vpG9A
 nhdhvRi5laJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCauuscwAKCRC7dyhM23N6
 3rRdEACF+wDzWW99SGiwMwtuFbYT4Xc8ZvesuZt8wZB/qXnZR9gyJwdjXVibGieISJj+fl6WUDX
 UkzUEhuFemIAteJft5JUXzw5Jhe3JgGpnAFYg0SU8H0T4dPbInWmAilKZelqYn7D9BVgYBSG7GA
 aQvPIffpelgiK7WaCG4gGC0xpfVgmXtRU9RaflFlCkz5aEI12rB0FvrBr7gvroAMK+ubgFt0iEO
 pGIdUFoo7xToZiowASNJVpJ/KswWmLvCUVQ2XGnZWcxnh7K9dFerjGsHUFUs26hTErZkHs1QXFj
 zEFKgGKkpNzboYk3Tw5iU4ZglLYChRoinFSHoW/bWDPRBGaoHQCy+aATI0bCZI+YxHprqo2bBO7
 z/KwoFQkgLKzRangEXnpWYPbbKiEmgt2zCBymSqriEKoDo2QTGLQKtal4UgAaxzigcB86bXF2sz
 qVBocvbZh2yO2ZEGxVtinU78W8oDexbm2Qfsg7/xyEmsdJZtg+6ngxT4nOApFfDxFe3SM4P5F42
 Weyraqc+tx3+G1m+sE87IjwSdxaaFy4H7+lRgvydBx08IeYpmySIeBSZ/LhUniQK4a5EDN+B8Y9
 DBVRDKSi47qHOkrchgjFCQfrs4o0kHLVu5NzS1dXnv74ycFcrz0ru53V5iM9nJsd/HVLzr/hfYX
 A+FxXGiWAnGQceQ==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Stat-Signature: 3af8imadmsux5kqhg39nf7fttqtxe4qt
X-Rspamd-Queue-Id: AEEF5C000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793830006-516000
X-HE-Meta: U2FsdGVkX1+11cdimvcgNFTZupZvGrd/ynIHZWEJTBUXGrLAxqZ4tPVGggRaMb/HndoHUOciscJ0ZjBCdjOOgNaY7XMJtoWKoyDyx/LxtedGLycG/lWw/MFMNoYHJDc0kBKLeYERcbHMl+9Yp1LiiYkTlx23XqlSJvHHu91qypZwtDkOdSY410y584AZPPsSpJ5StzXJJraUyUczcZHhFrx0ahuYCv3+boFTnWVuWWJnvu0AIlDBRgMmUmnMcZiGt1IRb3I1KhuYrjdrL3EaMeNzuDyd7+viL4jvEVMevvZmhubOyNNafpl7DKhDHYZSQhVYgq0XpzYGEicCQK9XheCRxvZJrn2gCV5ZE9ZdnTKIwgSfkFi3EknHeI4azSgoFmGh/quMG4ot2/SAbwRXc1bwyrEQM/r9Z46RRu7LajmSnoCZhUvwAe7Avb823RhSqZdwHFZ5kyU9qZiFF7Q5SunTFPCzG6lMCeqYbAHXr/+m1xtAKLBcxDvaRH4T5lmD+DWPzfLGHZQ3QTrfqBJrNpiQejDlrC5dNgaftOzsQYU3afhqEt8yecoNxuVEeSHTrgMAtR/jAlOYhfYCjanG0gbFLp3/NT3Xht9ZiCBdNIHrx+1KCM9wVn5DIGgAk3GseRpmYtXfqdSF7gRG2E1dnbSnKjG9C52yYKCNeNbeAmgZ30ytBdFhoaEAakp9067fn37HIEAgpy4oEJnmuTFQW3CtM1oLrKicF4o+xnx/MnhilumoC0jSy4FJu0aCQ/TxjvRexiuifpAZzdpEE++DbEX1xYNCwOFPg/fbrnvKd5Psq/rAnE5k4i4L6N40HWo5LUZSdKQa3CyMlSI/6iIpbJwlwDmqXA43z1Hrwo5prgS6Bk/6/Y7G6CosNhjmHYD3R+zjMseVUMoBiB2s8mki6Tv6zZ3BWZpJWbAJa4tLbkIO948cRiTz8n0sF85Qayu1WUoFc4SRjDwU5Z0jopA
 3KDSA8pJ
 vQlyAYapSfU3CrDj33F5hWVYyozQbWVd8RV7tIMy8lr9WNK6VCZyqncYmSyO0UmnyVEvEysggDUg49aUuHxsrmadpLy7lQRUj4052QoMuugRmSXuxFMf06gYEUM/7YO2NzYHd4VPb7V+Hiz3xAQNBr2MWdQFat4GsubmDu/waK8knXGnHz9trrraUniL+Ou6XutP0fPdF1rR7ObBARA55gysDKX52X1TwwRqTOUBXsvU3g0a4wceOqfVBUvDg8fCiQ7FHA5FCAjPVsKR/oTnUokA/bHDzjo4NGrhKQ4Rbp3zfJkQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 17:23:53 +0100, Thorsten Blum wrote:
> kho: Remove redundant 0x prefixes

Applied, thanks!

https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/log/?h=fixes

[1/1] kho: Remove redundant 0x prefixes
      commit: 3cf66b39f560257e77f422d9fc73525ee2c29275

Best regards,
-- 
Pasha



