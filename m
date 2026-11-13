Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD70606A33F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=HgmZ9Gaj
Received: by kanga.kvack.org (Postfix)
	id BE9256B0631; Fri, 13 Nov 2026 03:52:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9A526B0633; Fri, 13 Nov 2026 03:52:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7076B0634; Fri, 13 Nov 2026 03:52:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82EB06B0631
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:52:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B12A1C30B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:52:02 +0000 (UTC)
X-FDA: 85429478484.05.C7C0D0F
Received: from mail-pi2-f4.google.com (mail-pi2-f4.google.com [74.125.227.196])
	by imf15.hostedemail.com (Postfix) with ESMTP id A2A72A0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:52:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=HgmZ9Gaj;
	spf=pass (imf15.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.196 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559920;
	b=TBkmqRexmpybO/nPeJ0WoRoEFz/tRzQTaZpXD2BFElQAMLtc98ulDFMQ18MgaUGi3yRsEd
	yvvIkM13cRAfbXSmak4jPldoba42NkMZWOondIEuVEH0FAJrvdEY01VOoxLkrmXQSZkipd
	56U4x2sDRIkqli/tR2vf7YFH+SFsKFY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=HgmZ9Gaj;
	spf=pass (imf15.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.196 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8ixB8K8R172rrdk/LmhJTXU2lsskw0hIUmehvKI8Xk=;
	b=Zf6Z56s1Kd81/ED4h2n8EMwBRLGtN3ngBzWLWKYmBRXp0iVE6JoYC2G+qzlUZ93SlPwDSj
	6doRAgtR0S3Fvvi1Ttx/phz2H1FH1PRgGD188/y5lPHm1yXS5uNZVRwMBJpASkkWTDmlmq
	NrfT8BB7hnUwoXCibv3/OOlQ1J9Iu0M=
Received: by mail-pi2-f4.google.com with SMTP id 41be03b00d2f7-cdd8c1fdf4aso209259a12.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794559919; x=1795164719; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d8ixB8K8R172rrdk/LmhJTXU2lsskw0hIUmehvKI8Xk=;
        b=HgmZ9GajrIw5ILvTxhmrIsDIQdwFi9ldbc18M4DzRr6HxcJLXYxYUOe2ikXIbATtrE
         2Du/reeY54iGlGYC+4MgBXeExK40hwStZ/YKkpj0djsl2p4+WAxEhATl/Klj7EVueiv0
         X8Pa2XNeYj1frlmnGk1EVLrW1xtBKEiuaFMiY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559919; x=1795164719;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d8ixB8K8R172rrdk/LmhJTXU2lsskw0hIUmehvKI8Xk=;
        b=Une01lEswMB6x4BmLArYQg7HeFsZgR+toayrJTwxlSQcqow5D7To1Hymc+qOvtOPFM
         XWPVAZ9474vuv481QNO+iidHZ7kXFh7Knh4G+/TVaAN8EM6175cA083bID7uf3N9scuX
         iIilQJ5zVHBG+xw9N3rAS7DLFoPGhb6cGHHS3mlFMjVPhQFbWLBLVWGFc26Zy939fqS4
         r1PS6Fkt11uoReDM9e39i7NDGeU4zhJeV0dZRtctEKnWZZjpaN2FzbL2aBH1QKrqU3Ms
         F+PsseTm2IXFHMmui1SbNeqF58f+VbF0Gzc7D6z195QOGw98GhGiCvAoQJ+HwzfDFORt
         V2IQ==
X-Forwarded-Encrypted: i=1; AL+hErGnLkfSqPdMRPlgFjXjMkUFLx/p7Z2To4c1QjQ1kNu1tpQ75OeM6lu1J26cO6BQxLu2KBt57iNrRQ==@kvack.org
X-Gm-Message-State: APuU4Z+DBxFWdVxCIlik42BAv15/j5e29C4NMSc5zU8Q/FenTsQ8BIHm
	dw86CbYg7suS8syQno7NYzTd2gHfR8acHdt3oKT8CqBfz/9TCWfKWy6TqxbV88TDniQ=
X-Gm-Gg: AYBFou1cvlfxrNvkYm7vxGR92Wll/jBJdlqoAH85ZnB+O0sQnL7K4ehpS+DW9hM4jNg
	AEMmw9yTKsTCTQOaAfbrhKtKvuMEckUkjYzzPmYgc93GIj9SzojO/b5hy00xAj16+VvA7AH+X+L
	uswvUv6EKR5e8/QVMnhyodmB8ICUSKUMhtZ6SESfscj1bowE/DnayLidOpWny75Dg9vZz5BWcP1
	oSq1KScVy43MP8Aau2sEDoKhfjfgclDR7PjfTz2qE4y/s4ZLJeCMfJpsLmrat79XiBu6/dOvIGT
	8AyDPwL3llXzsbkE0/AW53XiDNZa+ayMQr4jYoY/5q+wegVDXgeoW00lP4r+Pajzr1Bht1evswL
	WWLtF6IEOKf4IWRsLDFX0LWctN1Sq82otVWSFTc214en5o+G5xjcWrRL5ZGzP+20TYXou35x7IA
	8vQmmt9WIBHG9WZb5L2XH3FGYIJ9ibHg+Sbnc8+JtKdqMQkEvX++u3WI5M7TGCSCM5FjgeRGSfK
	IL85D0hHapxfpKCNvtyvh53Wa2gO07HLybJOamQPZUl3pkVIL/u8GSJGyZXjeXuvTmuyx/8/YZA
	BgjK9dPYtdnxXXJo7abpgplEfNLD3SwB/SzGZc+CkymmGzK2f52TXqIgXOSxUGdFc4+bFq3a31Y
	PxkrTGHKtJ43xqjfIsxQgPdveEfTtGzshzAH3nKA1GnywHfSJUGckrAxrGYvFWPl1e1H71JIXmu
	CvuMs+yntwCK2nM/s8XfWUIQurQAydl3dCIjngit06NvvBst0/SGyw4sWMu0s=
X-Received: by 2002:a05:6a21:798f:b0:3e2:1a24:fb85 with SMTP id adf61e73a8af0-3f7a4dbd84bmr1333192637.1.1794559919456;
        Fri, 13 Nov 2026 00:51:59 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc186f472sm907794a12.6.2026.11.13.00.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:51:58 -0800 (PST)
Date: Fri, 13 Nov 2026 00:51:54 -0800
From: Chris Down <chris@chrisdown.name>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Marco Elver <elver@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>, Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/6] mm/slab: Enable SLAB_FREELIST_RANDOM by default
In-Reply-To: <202610302113.FB347BE5@keescook>
References: <cover.1793253633.git.chris@chrisdown.name> <6bdc161bd869ead04b3b9a651ef6a83882ecbea3.1793253633.git.chris@chrisdown.name> <202610302113.FB347BE5@keescook>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113005154.79ad6432034bf65c@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: ws6dsre38p1biiyxggfodftajou8z8bz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2A72A0003
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794559920-38609
X-HE-Meta: U2FsdGVkX19d7zWrmfDT3IZdjrIKZnERVV58dCgngqrVWlnI4o1jNKrdeFVAiKt9PPSOL8lDRqiYzsoyF23TmTkA/Nou3WQCWFbgzPWJ8Eic/IqeGZKFhz5TY3eLR1UDyXDfo8U7M+bgj9/qj2sENLGHywa3X0iRt9Ev6KHfrKKUJB0R/39gtE5USRpSZstzQbJdfq96CKnzIOKcBlRaZ1997UcSAG9v0PNRGEmIVNiy7++Jc1Up6dfPh7AyG0v5wFHlPepxS5+rRgV+3QXj1FJZ3Oly38tXUGXrpO06AAYb7ZqoXLy01IxI5Huu5zTO9gTR9TOZZaaTOupWrVKJSHW0gQnqZI50BAvFQw+gyz8d46Bc9UXMm2qrw2HCX9bskh0k12KMcGVAL5p+AUeen7YwKKYGAiIzt/em+PhaqY590qOos8nuGwTq4A1+I5dwHVDVFetLDue3u+Y77+QR7RzMEqHsg/554NCV7p11uytpROkqZ4hbR46B1zca8+SnG9Bkl2OAArP/AMYW5AUkGGES8QgwfTtcRzxnkGPpKHEc4hGJ3QTKLLoQtsTZNAkC/fbhtE65oMqcBgjAH3wbRoRKM0Anbn84bszCI+s+FgLH7bAdkZRiFmsoBapcfwkSPDx4C8XeUJEL9C03PQkMwTgxLjOtIRfYmi7bQ7RMLpD6TuP/OB9pZyWFrTHdGjhOV5WR/+8QTZrDGY/VhID3Pm4SbXqcVTNMB9FmkFnHlgR0jQYEjCU6osETK5ozioAdHAYRCcws0aSaGm1crrmWT1qojSV8/YYBgRC4VnpK/0rOI9pLbeSmbk/mYxKl21qS23MFQbyzVjgfXNWXQQpbVQw021vBs3w41747kjiBM1aabheRf6yPNxaCGzw5QyB0DZo9VdYwzkZAiO0/UvEAUAHzf8Lzd/pov1kuJ6G3x6zJLT7S0E6nkXaDRUNsR3B8k7LfQi7N88WQXVvcXjW
 wI2dr/Dg
 nJHzMeQhNdWkI6udg+d7Zeo46kqnURknT/iXSL9BbzHAOxY+/EUrZz0Jt0PuC4V+amhr9z2Q/TTZ783pFtlrXBXvuVOeYR9NuPZw1WuWlCIo+4Ka7OilT9CTRk8CNmBLyquMYFk0o5jDeGYuvgRyWth6XoCl+Q7ValjSHIyro1VW/jliEw9Oij4stgUd1nEPuR7amldrC71w8Ad8pNF282DFCdMEwquHFztJ9VrJ7sKu4QxxietP1d/SAqDvv2ZgT9mdjFwDw6JXaNLSyw2trttA4VS8k+W2McYT0i2y1N6t8L+THHZnTRUr+LDOLBYOpDK9j+pQOTvfb8aKyeUhHviAbS4i+Mvp1LYvKCrpS8txwj8X7Rj/l5vUENE6+0cEggfGQ9l4O6t6YuP31qapVuRt0y6/etZo4HAfzsYJo6yXIX4fzkHI0NP+JFb61oc63cE1VqJ9wItAWvjLUUsTuuZ5/6vPBmf0C/vbnyWCdl7njKZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kees,

Kees Cook writes:
>Again, just like it should be. I wonder, though, don't these 2 changes
>undercut the goal of making these boot-time selectable?

I don't think so. The goal is to stop needing separate images for hosts
with different needs. It was never to make every option switchable for
its own sake. For these two, the only real argument for leaving them out
was CPU cost, and with sheaves that cost doesn't show up at the system
level [1]. So turning them on everywhere removes the reason to build
without them at all. Anyone who still wants them off can still say n at
build time.

SLAB_BUCKETS and KMALLOC_PARTITION_CACHES are different. Their cost is
memory, which is real and doesn't go away with sheaves, so those are the
ones where a boot time switch makes sense.

[1] https://lore.kernel.org/r/auITixAJMfLtfa7i@chrisdown.name

Thanks for the review!

Chris

