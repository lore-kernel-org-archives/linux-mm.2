Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15F27CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6736B009B; Mon, 28 Sep 2026 13:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2764B6B009D; Mon, 28 Sep 2026 13:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C3A6B009F; Mon, 28 Sep 2026 13:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1B896B009B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:53:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77A501202C1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:53:54 +0000 (UTC)
X-FDA: 85263919188.21.FF65EC6
Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id C0946C000E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:53:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D21Bc0hu;
	spf=pass (imf28.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.229.43 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790618032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Ry9723u1VCONEYNULtfqjmkGkxac0FV34z/xJBvJ25M=;
	b=NiK4JFfkZqzfICbpqvfMqtyeuxJNFFuqoKABTZzum+++DEEd+z6zZKk1p59vFP9ByhbwaA
	M0+wRE/J/i4jXT+sADMBDSMo9F7/XG0kO7igt40MMLy+KBy2SJHvActl44V/CFwcnu0dxy
	LoHqfTxXxC1ZOBq5NgB/jjXAkQCZ+ZU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790618032;
	b=UsPnNz3Pf4sfJyawZ+kn3ZiA8rmxc8VIsyv7cH712L1zL+C+vLWaS7UPWxLzs5OVbEfhlr
	poy6FOPQCVW5OMAP7bXhX6aLX2/hCaXqUz+qHV5nujF/HnmpfNr9ykRCOhInlQDbN4T68c
	GXt6px5KNr/e4+3InMXYVgMa76h26RQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D21Bc0hu;
	spf=pass (imf28.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.229.43 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33c0d931083so1222988eec.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790618031; x=1791222831; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ry9723u1VCONEYNULtfqjmkGkxac0FV34z/xJBvJ25M=;
        b=D21Bc0huFrrPsAhbfiKMZxnqoRYMOhcupYBpBw0eO2xJ+ZakJWE19Qw9ty3FpOwJb6
         gHqBGk2dEVE+Vvy+WnKgSxh6Y002BsqpZolockhK2UdqBqFLJrxOeUpUHJ+WpDCCpoPk
         /Q0sXf9u2RxMj1FCCGBTMMwRUV9PlbbKmr/AKQRs8A1OrkelYPmGtoWahTYRHjoPZtBV
         rlvWMMMu6B1f8nRXWSxB8RXdjD79pfQkZ3EJ9XmPYVyX7gFWDNwN46jhz5Mh5UcGAhgb
         ipkxAsV2qdd52e3Rza+D5F1qPZGud88mjdlqWHO0XhPv0J+MApfX6xhOG5BUfOzOUuGj
         5bvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618031; x=1791222831;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ry9723u1VCONEYNULtfqjmkGkxac0FV34z/xJBvJ25M=;
        b=aHcoMUM6s6RujG37sWI+8hNnoo5LZXkjIYtrEtCSwf+b9zy2lEKyqjbSWJuUNnSWA6
         bvU1Xjf6jSGm9Bxo8+AYl6Ujih1/iqNNHAOlF3nHtIaw8mjbZmTM9L1FxdrcZv8gHA9V
         YDXttArEJWEhF7WVFYRE0WRmjpQ28sAgNNPJrepSqCHFrPZIYI6CikDFFqlCMKKSjb81
         v4RKEJfSaFOggUcvAYtl331erxy2RNyvfdYEgbwT0pEbLxAby+iD2ekzxb+ukrVIzFsB
         kXtfHtEbLn2grCzOeTMO0wWoe5LPGEvD8RIPKn7QW9Y/sDd/120c33tAPIRoJHB+n9GJ
         iFuQ==
X-Forwarded-Encrypted: i=1; AKwUvBzW4h2jhr2cnaDKuLSK6Zninv5FJGyZ7OhxgcbZPZWidUgU1Tlq3ZmDtrWKjzW/IbLvbhJIHfMeLw==@kvack.org
X-Gm-Message-State: AFuF++l17shfVDUeLKxMCiZKjk02E4CJDyroI1GkeZwOXZwwHES6orl/
	nvF4Uu5gKfd8qrjiRpPe8FU7dtxz8XmXrcPYp/sg3MJSA5F/Ns9LfDBcOoYDMhSw
X-Gm-Gg: AYBFou3jnR0uhUOcwLCE3FEoysP/wNBnFA8gfkMfGTGPi8yJiZuif6vMonLSLVdvrnI
	v4cZXTJkyo8RmBMClZQHnGxQH5M9EYnaJNlS4S1KffXTfmiagJyB4aRjRL0vqMnuFJOmyuY29Gd
	FvJ1n16EuHN8oh6pdfmBm8FTSLxaTL5k995IlfvhaH2UMWafjaSPrvMmqr/8ybvqrhhhcn9QZg3
	thRgV0DvtlAL6/OyxlOg0vQ/SNTGmx+42ZkRj6ol/5PKm4vlfdDsfqF5lzbgD8f+YaRYLkffeT5
	6yAIoWtFMrqKU96daPFPEc8JmW0OE+WYbEekDoBChzn4e0gEC1omuXLDV1caoaR+4pueaM9mT8P
	CDE4WxhC67fZCbMLGXafcYoBLghj5DFnfxCbUiUlTwe/G2VUrrk/C7tzX3rb+nFA2vuBq9O8fMb
	Nnch67hIfTgLJDmHbIIXhqo0ebvERHoPROpa+jHRYx30sbwsh2uWuFhA9ErhaB8+0p+F0GANs8o
	n6QCQYKsKqktMwXohz6IxYVMWCI0ar1cP7ZBbH5mQJCv/s/Hopr6g==
X-Received: by 2002:a05:701b:2210:b0:144:fb71:dbd8 with SMTP id a92af1059eb24-14b2b6bd4dfmr165181c88.8.1790618030705;
        Mon, 28 Sep 2026 10:53:50 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145aa0cb6b9sm24285377c88.1.2026.09.28.10.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 10:53:49 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Muchun Song <muchun.song@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/6] mm: Unify device DAX and HugeTLB vmemmap population paths
In-Reply-To: <8385F749-0F72-494E-9CA2-2E433A066712@linux.dev>
Date: Mon, 28 Sep 2026 23:13:35 +0530
Message-ID: <se2tjmpk.ritesh.list@gmail.com>
References: <20260924075259.2013039-1-songmuchun@bytedance.com> <607759bf-59f2-4ad6-b95b-e780ed2acba3@kernel.org> <8385F749-0F72-494E-9CA2-2E433A066712@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C0946C000E
X-Stat-Signature: 11bmjp4dnnbbcouwbzy4dzqy3m4g64yx
X-HE-Tag: 1790618032-690017
X-HE-Meta: U2FsdGVkX195q0vu2pQ5U3B4tILFoZela+mhdiT0nr+egihF4eLUqYeTg104Z59dFzk0UG3Wb3QxApdJJXV5WWmDWT7TXi+nCXcEJ5r5527X30iSS1suubOSRNq55AaQVyECUu2mnABXNe1tDYOKBIbXYqcPeYidVSrHOuUDNHT9LIzYjga6buxeVirMlgYBJlbtwr4OCzFovMU+CCiKSirLocgbbhbVmhJ3BskoKN6Ev5X0C6BwhUJet8/BvM/MTo0/otqEQNAn007zPIJS3a4VcCPlUfaze8xBdYYBxrUYQqSfJiQSasL4gypf5/ifmD43q8rseCrWJM59/kXa52YLe7k1faMepwgQqkJVM53T9+KoMfjMTNi79jy7p7MttSJg9MnCMYwv7s3z/L2Qrji6ealte7qNK+I1YtKmpgeyc7NkiBSY2sYrn5OiBLCbBDfhJPgn975m+evkqSMLL8QRpNeWvnXY+0x00YJR83x+nRBHee9Zswq+Tjdv+vHWQg/bOuEcMZ4/tX64Rwfwz15GMfDmSv8gZJLNbhltqvmQQisE6NTDL5TDlS2QavPyOfK4SDuOYVSE1qihLswbD6/oKB2RHq0mmini5HwTvNpztCCLKC52GvdKh1ZAbjcKrDtdoB9Bq23nhXhZCyqg99kU1/k+o7cdiAA3pnvJ5mu7RikOtFu5C37N92mU5bj8UiPAnnIH+8ZUlsc9XyGYmrCBom9FD8QfrKNm4nMlJoKEwut1GG+bvrcSILgs1sC+xRtsgQVsAXEm1lnUaQNdI8w9WOfP3qxeKHWmbHA08W9l77b++gkVbPjsVDOqRmfmoQpCW7fsNWnBkxPM1qddeIwbfPBgsEcUSXFvLDPqRwSrEJaa4rVErf8eK0WFR52H8kdj3HjDclCbvHx8axf4TJnCHH/e++aOAvvYWfu7p0OPoaqD5hGo9UhJslLgovl5M5z8V9jxpiTneYEOIkx
 pXAdcxHB
 6sjBkNDyZRp5ig4VA9aKMiw+krAABFlFgGxt4c1zwdyaC7d/wx9Rya2lRSzgRnwhB1i5g7o5I49phFx1sqp1w3H6QhzFnVBn98KTAN3nSzDQfP50wVbSKUJExpTfG5m4ZTRvR1dDm317TmA3hLnvMdPojP74akzQFTUvZSAxvtwPTCe8dHzXRrmBFP39Ls5Fwh7woFLG/Bv2NZZSux6izSZfin2LaDixI3jDEp46Pyy/z9SZ1jKBuUdfoCc4bMuxiz8zVicvYECyV1oPxXxTt8PVPVB1LV19hj2C+/dTnJZXQ1S+G6DPXW/8zUMEVIhNpCQuPM34HI+g0QFgo7vlqU/IX7Fyysv7i3PMbKWolvxqsAvy2O8HfAT45EbNBByP+7wzY26P+Fyeu6AB16at0xSUZxpT76rI87rnL8QBitLtI07CIvHC2GOo1OakUt/3m8TIEHyfuVfjtpAeXFiYrwS6HAsA0lVVLObo7ElOYyp2UNdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Muchun Song <muchun.song@linux.dev> writes:

>
> If you're planning to review this series, I'd suggest waiting for my rebased
> version.
>

Hello Muchun,

Thanks for taking care of powerpc side of the changes. Is it possible to
share your git/github tree somewhere? Sorry, but it's hard to follow
which series is based on which and the overall multi-series is based on
which upstream tree. If you could share your updated tree somewhere -
that would make my life simpler.

Thanks!
-ritesh

