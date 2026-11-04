Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A52606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 04:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=I40AKDJB
Received: by kanga.kvack.org (Postfix)
	id 9D3596B00EF; Tue,  3 Nov 2026 23:28:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C3D6B05B1; Tue,  3 Nov 2026 23:28:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FD226B05B2; Tue,  3 Nov 2026 23:28:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5CA6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 23:28:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 442A7A04C0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:28:58 +0000 (UTC)
X-FDA: 85396156356.13.56659DF
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1FC951C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:28:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=I40AKDJB;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793766536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YoT0N3seRwZx2djffCaiAALCN3DDAOTgxnkps9J0Des=;
	b=HHnQdP54dfduJGlzX4c70H8pSH7j3xUb22dcfogrV6hI4+Xjdcd7HXknHIeHx3BaC2bigy
	I2PwiGfINQnCbL4Bwxqm0BqMye8bjRQ7O5A9pbPfdNANQBeKnDXSvbFEngE58LSIdHh7ad
	SqN4wm/oDIhqsKQpEm4iW+NfCpEOZJo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793766536;
	b=YCq+jrCw5XJuUmg1/uOcO7cA2256XDLjErIcDnATiDC1YooOObyH6mcPTUVga632TWmjhl
	oO0UJS10pVSx97/wSbNdD99Xi2bY65JivIytrVaKMeZHSfG7GOveURW5P4zwZe6GeM4aOX
	qk+i2geQz5x7VTx7HUmnf4kfr7JmLQo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=I40AKDJB;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c34bff61551so46872166b.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 20:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793766534; x=1794371334; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YoT0N3seRwZx2djffCaiAALCN3DDAOTgxnkps9J0Des=;
        b=I40AKDJB0LjfUDvyDjLi111QsLDWSY/W7IC5YezGKR1Y9H/Y9SYI0NIZ3ojbKCz53q
         JttnG3savvhTfddvb6hyCpwYwhFnNTCXxtWclndcuCuvfSCASqb0PX15NKtasCGG3wyI
         kJFwQUxT1rYmBPG29R/txO/bn+l/J0BaItq+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793766534; x=1794371334;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YoT0N3seRwZx2djffCaiAALCN3DDAOTgxnkps9J0Des=;
        b=HaM+XDa/yAMFZKVlaJK/+uyD6Xl0YqD1y4Lng/UaCorll9IYNKde++iyNgxEzs4/KJ
         La+LXPAvotc9+xVCskVNlnlkBLSBUbnbPDQhEDtqmV7HAiRCHfGesCdZhNrB8DSuvgzd
         kOTvlUYV6E8g41cNPZScTBGo7V8//pllq7aOoyNvErGygRO3GEDkiKwer06nqVXLX3c0
         oKMdDpTFSFiwxnB5Xt9E/vV/2oG84n4C5nY69TTouM/dH4mgPkb5JL4J7xRxQp9Iazkx
         BUDzcJb694KLTQBDkEWNrubQdD60mo7S1kSHQuihars2Cu9UX21HkY39a7Vil/5t9a9g
         LmJw==
X-Forwarded-Encrypted: i=1; AKwUvBzK7QCAuafYMorLzxOI1klNsp6M4WK9Vz+vyqnhQP3Vk571e1THPftGCKI07T289Z/cMf48FihuDQ==@kvack.org
X-Gm-Message-State: APuU4Z+JkFDF1DMBXmo88Pv2L2z2pzl3ghImrhYFzwDAMftw2ZPXacdl
	yjcCBp6zWi4Mz+7TGm2Si1c6pTIfMfnjolySPGEgcDjJ15oX5TRpJaXiP64Ubyvf3Lom+ikZLk7
	1udvymU8=
X-Gm-Gg: AYBFou3g9fgisCqpv0Lgdk3b70NynDeVKS9mEBdbaY75JkZv9exdCvFTmPr6heuxDUX
	J7PlPngnpgmrgCibv4ZThShCWOb5L5JpHsVgSDcfWwtHilC8oV3S6SxNjIDtTKccmuc7WF7k+DT
	E1TygEi1EU93BRZ4hAmt3d3a2aNt9pDJtG3WnyPnubT7iQOrVLOinHa47q77GgwG3YWjZ03+TDu
	PCqmKIUjgu5KT9WTqktcqLhsis/nXStAmCmQaHZfpdQx7Xmz1Xowd/n3QAc6+0aBFqlJKRreWCD
	pkx9gUC0Zt0YaGIiVHI6DPvJzH+EBg57gwhLZJiif8ZmU3D8xgTlpeTWr7iGubXBGpZpTOhSl9C
	AxgisGYpRCBOcHD/dgcKYkk5Hm2dLt5ePQqjd3zURn891q7Iuin2Z4mGuV/MvJp08JS5d+9lKoG
	tWntylVsZetRr4vOOiIMmR/PUQ2P4iOEZ4oC3NNrxjbw6nmuAD33R3Fnsd1MLTckk+0V4kAxYtx
	Qz1klFp3F79nC5KzK1/RfyO454+TvVDvQC+a7bmIUW7OsGfvk2uTwi+XCItnv8z8PE07parwYOT
	5GxWv+0tMel+m0qgPw6PCKHw63Kfe4CxY/Kbwscp1ZguxJwfGbaGC0zXFmDCnvR+Z5hmleFfMjg
	+cQ==
X-Received: by 2002:a17:907:3f8a:b0:c46:7462:6332 with SMTP id a640c23a62f3a-c4ca7acb051mr1251452866b.37.1793766534361;
        Tue, 03 Nov 2026 20:28:54 -0800 (PST)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b55abd3d83sm358758a12.2.2026.11.03.20.28.53
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 20:28:53 -0800 (PST)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c49b431f022so39694566b.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 20:28:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByrgvpPuHIjKmQ92YvKOK/R0q1fCWWf0S98upUGQ7LFuMshMijX5SVWDkCnXDouVjq9vX7ulDeVog==@kvack.org
X-Received: by 2002:a17:907:3e8c:b0:c31:8984:7fad with SMTP id
 a640c23a62f3a-c4ca7a4bdd3mr1249450166b.15.1793766533308; Tue, 03 Nov 2026
 20:28:53 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028154218.1668182-1-liam@infradead.org> <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au> <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au> <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
In-Reply-To: <auqtTjXhD8is-y9f@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Nov 2026 20:28:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
X-Gm-Features: AclHuK8Q2xxyDr0nTOpQBX0hGVCNXuqdZQKlHZIGiyhVn_ThF61kvu3f6cKlY_8
Message-ID: <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Liam R. Howlett (Google)" <liam@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Mason <mason@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: d6ehho7ys5w8y4895hozxmfyob4a4m1d
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1FC951C0005
X-HE-Tag: 1793766535-318345
X-HE-Meta: U2FsdGVkX1+WEVRBJ7i/Icifc8pPR/A06xHEsYk4A5dWDEHDiZUF5DUGJzHAHGVGssPRWURlfaEVsuBAwxTqJAiAJ0m5w4g2S6yodL7BMoncmoOh6xoghPSoVQN+6MJdwi1oQStxpIu/9TQnbZxvUo1s70c6kPyiTGZymAPcnJpl6JGCBwVAr4bYmreF+A255bWvHohhlmUkrCjzJOH2jckl9H2aPni0/96yXOemvoiIBcaLDWuAGmwDCjvofnDymHsw3nnRiBtw1gN69hYKwGomSt7MjcpF2FLlyCpfkxbqZuVOZTNAGYSOTZ2oUSiuer2EVxxUnLQvNCPTzGQmVz6xmcRqen3+Y2yK2aACl1/pGbQnu+Ejx3u7xCGfyZs/wamsybWMxOVLomqkSj2Il5ZwM3rSNwCSbE7UpdyF4GBd8WCbFPOilbU03+40Au4HmS1yZVz6XYXl1TEfupQXlq1WFTWclO2WeSA/DeFT7KF2QeZYosLcHN02IXX7CLlzRvPBmro3umDjS+bCTOVFsWnbB5TOfZunG7+c9HQo93LMkPp2210V187rsSxvndvgUmQXH8AU8TFviw2Twz75DGgKzR580yGHE8IObJFwbcRVmrMon/J37nQoZb+VZgGBauZuMF9lUFI3pH+8Hp4eYZbgj+mOBLUd/2sd9XEKh/Q2MEGNe6x3AvtXi/zN8q1CtEPWnnxZWzRVXmXELUpSOiCgqgTeEOP6YTSkNLmDwmG3N/yxpva1a1WZZ2FFIz8FgVUGp8F3mEFpic4DtfAg4ix2CQyOn3/dEvTtGHiQCRtHdCiTUAQTaAbxPzHHtv4/mMaxJtdA5jnFPdtqpXJIFBj7jzFdFJWLjeptTwInRZfMiH1YJHwmIo1oz6gs4VXO0AITSvi8u/Zzd2QlEho+EddNPYQgjjq0gfqDaIHBlNAYHS7rIUCp6q/cjHC863+Z0IGjC2OY7w1s+8nSSUs
 LCaWRnlh
 UsywXP4lQN2/NBujY5xOMENRCklNAMeZQ6EphaS6I4eMMKXME/PRrVAWXy1Cpk7r3R/ztSViHYVO3hT5wNrfPlcSmckcyNHmH9QgE8OwqfVuGa+vDdbzowM8DkvSQntYTZD0A4TpZqaKUpSdn7/qzzbOfbXUug3EOEK7UncjevDIxsx5DnYSouGlmCnOsS0N8kXXtblbxo265CZ2HqSHQurv6agNL/yauLaQ4jgi+FF0Fa0t4vPm7ljyO+WLNCnk6yetB/C1GIq0oVNqvpD55ARKTOCVsaU6s0UUlrxQnLuGlV3MmvTVecgiBHrIGgMXOoGcpomW6Ynp+tH+fL01CZ5dc5fIdkPIvqFjEOStstQe5E4gHmGzLYWEJAmUyxK6x9YFxlsvMQz4kUDRw5pgZWzWtLdD1h3xn1GJzGW1UxLPOGjPTjmNHy1p35DoX+Tv0en24FgqhYJtdS6KUKvh2P2ml6trb9nid2dfSt8XMnvQ5nnxl48EZZg8kI0atXIMAHHsNnGV7BoBhh3JFF/htvS7rw3T5yO9bIeEUbJJfuuzfFMxRmtKXQvaKdJzjVeKg8PgiRKL3OHqBPto9qZbM+Sp2qaDWXet3CPCMlVT9p1a6bI5MU+M1FaRNYMSNzAaTS9xGzYCTG27qExA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 3 Nov 2026 at 19:58, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> To recap, kvmalloc was modified in 2025 such that it can use vmalloc
> even when called with GFP_ATOMIC (commit c6307674ed82).  Unfortunately,
> it does so in a way where it has to wait for other CPUs to do certain
> work.  As a result, if you call kvmalloc with GFP_ATOMIC under an
> external lock, this easily leads to a dead-lock when other CPUs end
> up blocking on the same external lock.

Ok, so it sounds like that change was clearly complete garbage and needs fixing.

The only reason for GFP_ATOMIC is that you're in a context where you
can't block. That's the *point*. So if GFP_ATOMIC waits for something,
it's just fundamentally buggy.

Sadly, the commit you point to doesn't talk about *why* that
braindamage was done. Looking at the original thread it seems like it
was for kmsan.

I didn't actually find the kmsan use case, but I didn't search very
hard. I absolutely *DETEST* it when "debug infrastructure" causes
actual bugs and mis-designs. That's the opposite of debugging.

IOW, I guess we do have to split those allocation cases up, and we
damn well should remove GFP_ATOMIC support from vmalloc() again since
it's clearly buggered beyond belief.

              Linus

