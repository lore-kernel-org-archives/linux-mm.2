Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56EE5F513F1
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 15:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01E36B0092; Sat,  7 Mar 2026 10:09:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC3A6B0099; Sat,  7 Mar 2026 10:09:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE9C6B009B; Sat,  7 Mar 2026 10:09:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7DC766B0092
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 10:09:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2217A8C775
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 15:09:07 +0000 (UTC)
X-FDA: 84519599934.07.E98E3DE
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 42C8440010
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 15:09:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=nMv6OVDL;
	spf=pass (imf12.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.52 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772896145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7B+3R/eVcF0a4VFyKy9Mj+9RSgZdL4bns+9ocGpr2c=;
	b=mT3V7jjxI3a9o/owi0LnM8QLUtjjvgoLghtD3ZrJQKxXGCS9ovgykNP/50DTmfb4W0B5h3
	3vJ6Jnjiqg7lJnn+Af/1qi67EsE6pDw8aOdPaBbrAWvHH/5j1YYidwsTFdfd751hGIeN5T
	+6IGSk3/EchYHnwB+ywl6dqVXpHsAoM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=nMv6OVDL;
	spf=pass (imf12.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.52 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772896145; a=rsa-sha256;
	cv=none;
	b=uY7dQdy/YM9VoEKkXP56vllL1eqPMYrSnkwu5wPejRQukMTX7Cs6bSc6zrxZCWBILyrdR9
	AmgqMxW9AqK5IbXqBR7AvMqzXQ6W3o7DycYRMsKv6YSTWJdGruqBz14YLehGiYXWaKgDLC
	V7OSE6KJMNj+JxRk6ATe9MjbaqHUgo0=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-356337f058aso5523980a91.2
        for <linux-mm@kvack.org>; Sat, 07 Mar 2026 07:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1772896144; x=1773500944; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u7B+3R/eVcF0a4VFyKy9Mj+9RSgZdL4bns+9ocGpr2c=;
        b=nMv6OVDLvcN4MkiRmzriqhx9+bBsOF/KHvWwOEvRf5qXci71Awr1F4crTR6uiuRw3N
         JO5b/DwuH2Alt5hqPhklvNN4R9hWMz+GkBe0ZNS+W9sjAgwXmQk2//zHQaoAt7l8xsh+
         CEzFcnNst2MU2Jc0aLT4UHP5fae+WTMuhCluM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772896144; x=1773500944;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u7B+3R/eVcF0a4VFyKy9Mj+9RSgZdL4bns+9ocGpr2c=;
        b=lu0IPf41bOLjze1duCvwEHQxMwpcxohHvr2KSI9tv6w6OH6tx8zbKB2YOYrNmV81+t
         mBkutaV1VxwINZ6dI5+NbpWjpeA5TUb9cri+CuPNK3+M5foGtxPGT0SxdSFG1D3/2ZAe
         eg5IyjVwKZEXs2CPiy2sxc0NQHr8Dz/dwtnv/9ps2mNI8N7Dtd8Gvgaqia1Fn8xtfckw
         z9CTInlW9BmS9snW903kNkHtwZ8SDhxNzAEtmsyMeDhvjRnE9H3kZCkQoRiumJn48XlF
         2U4z99gtAykf9NbnVatukY4XXFuXJ0c1tqyKBw1IWYQQgC6PP2wRT9w/GzpOnttqxEO9
         IsDQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9SiOWPnddgc1BdLXjMnUSBtslEmWax3/2uJj4DBHAv1CaicSJo/2SPqvgAnItk4zIydL0veoPeA==@kvack.org
X-Gm-Message-State: AOJu0YzqmPFPH2ph1bdv9WY4kvz7QZ6yyCQIsdCrI0rzDPLG7K5dYqzl
	Le80UD8qMXLW0J4/hGFMfW2xFz7d2m9S/R7OYrFwvexbYDZnpxD7PETdLchlDHclr4s=
X-Gm-Gg: ATEYQzwQfcxVKF6qmvmNdLuG3yocPg1SJY40r8TDLnZbir5hPYJUtyuKoSpizqqePr6
	5R+/UGhl0i7qu7wrtCpTwAIRhdcrGV/yKkENsjeWxIc84D77RTw8Sym+Cl4oUQ7dUq3PLBQl3Vo
	cc3RnnKzD/o4P6Uvjlpz0h++RRPcYkq8laZ98cgrNyDAGMuPLYS2kIwoaM6Rv1MnQ1ScxS6f/3a
	O+xLm5rOcnL2eohWkKBpzqajRO9VoKxbAy23G9lGdJsIJc/cEDXPT5CbQ4oBOFDwtTi29Vb/EOC
	1aJJxZoDscLfmyUeer4QuJgjQE9AsPfDGJByfh5m7FxpUjDiEowpJPOMa91gI6BaXBC6SPUyL3x
	mRFVoltwcy/XgPMaR8qzE+i+hquCuQOHF7j9ExQK9jUZnRVokvo89i+bZ/b8Q5ymaKwBt9pME8t
	Nl+QPuGSNJ+f6RykP8Ir0=
X-Received: by 2002:a17:902:ef46:b0:2ae:3b36:23e7 with SMTP id d9443c01a7336-2ae82398d80mr56455605ad.16.1772896144073;
        Sat, 07 Mar 2026 07:09:04 -0800 (PST)
Received: from localhost ([149.28.151.93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83f8baa3sm58418835ad.65.2026.03.07.07.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 07:09:03 -0800 (PST)
Date: Sat, 7 Mar 2026 23:08:57 +0800
From: Chris Down <chris@chrisdown.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/huge_memory: Prevent huge zeropage refcount
 corruption in PMD move
Message-ID: <aaw_iU38qvIrNGAA@chrisdown.name>
References: <aaBVz7eb6-VBCvaz@chrisdown.name>
 <6147cf80-9d02-4c5c-ab81-8cb9b00044f0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6147cf80-9d02-4c5c-ab81-8cb9b00044f0@kernel.org>
User-Agent: Mutt/2.2.15 (2b349c5e) (2025-10-02)
X-Rspam-User: 
X-Rspamd-Queue-Id: 42C8440010
X-Rspamd-Server: rspam08
X-Stat-Signature: n7hf3ogbb7rngr8c1h63yrm7as3txz97
X-HE-Tag: 1772896145-584683
X-HE-Meta: U2FsdGVkX1/dQdRgs+NUlXY0z+N0j/RoBqpx2qlC3TEMlIxs0PfPseHUSxwE4kInFBbQcRcv30hHcED8FowMvnK7/FrXFNQxVvYPnaQ95XuvI7vuZqpTP7CzCD2ksbkGyTXE656bnCeYRR6IRG32ag7I6+cPGDV2RQqoExnZYzhmd9fO/tYpGItK7L/I/vWdXwIRSBe7/VNgwW2yM/5CF251j81YnWBGuZNrZztf0+Qh/Vr1Gebiks7TpTGXFPJcP8oLNnYFNFB9z6EvZs4COzmoR8NNDq6XogCUGg0cR39lhiqS9nrx21PGNXjp3VNlrS9GohIFQVrNdV80OESTb6q9cafj/gf2K0I/C02iz3v+OKENZZjizBphDhK75dzmffR97mu7UbluzQhzXwRDTRGbfoRWimW0JLobWPDXu+XlOYawDYzS7jXWMt7Ri4pTPGZmPPZM+cnllWyzUBb7QGycNqlsY4K7NlL+hQWrIy039QkDZYUjxqLizzSR7vJCYGsB08IhnSvM+0dEv391kdNqBZLSwsLPxdQhc5K06rkO9hAlMLmCTil9x+k49Ypzj4opKhlYVUm4P2+diZoJCBpe+9u3by6JmJ/qaAE9dsbMFT57k2SJk+eBXc0fw7jueXVxxh8OH2CR5BTZYLo5q1W2O9HvQrfk4glkTPpG+Z0lJfFCqyUv6aGNTt8fZuVbiw6poPZIHDSu0fUcEEsE4wcqA1Mi9PSw2Eub2GIyHL/F4Ao9nEPKBkpyShuk4N3mNgNZIpAT8hA/RpwcklBL+JiL7eMZfrhpJeO5VDZHDQru0xuqoGxOgYEmYXrcBTIwxy3gt50f6xZxns8XXRTsLq4Jgzz4Ftf1lRxwbuhTGGMZxSSRK4pe9WgH3Fyw+b/oni1KQlBjy/KxpPlHsVIgITnay1VCr/V9Fdurk2JAnY3gtdraPgc/yWYRSj/1jR+ccvLFV0WUuNrOPAid8Aj
 Ly4QmHnA
 ewAMtYOK8vhWrXnHUs8jhRPgyZjN+SDADOpQtxjvb2N2k/ho/gK3Y8t2fy1rPkOQZhG8cn2DrclWAW1IITI1mav8FELhH8TruH3kKgwQ0Dik9C2yJ+8O8NZGod5HGbLhKio8t/rg+B+HIraMscfJDbJxGHYeU+bcSHGamO6vo1YMsZMdGY5/VNB/1R0R36wNAw8BfWqmvKZmPbagwUBFrfIY1M6rdUqdB0k6xh7Abvv2Jr2FET51LLF9V3Ej8SxZRg50JEYVO9jRddJ3v6FDWYZ2Pf1YcrCgEtQdyLFKkDtLfikGmncXuNsnl+Dd5SnqayHmNgi1XJ17FtCZCDsEK4IuhBFbi2v9Cv4Ujsz/QyJDlHSnKu0+45zbZLgSq2DniWk5FPDl+AO5kXVY/2MRWiQSXplEKEsG0eVw361fDtg8/nqGClVXz9n2ufC9WEG/DiaYtug4bEEl7wb/f6IWU6w0CV44dV+3gmpOGCyrz6dg/p/7+q+o7CmSzihwFeTviBfAtokcmIPAoG4TfqtRk8JBRkE5yBQsBQmWsO/Yh6XTK6FU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand (Arm) writes:
>Please squash that patch directly in #1.
>
>It doesn't make sense to leave something partially fixed in #1. It's
>been completely broken from the start. folio_mk_pmd() should never have
>been used.

The reason was to make sure that in theory the correct trees can be updated 
based on Fixes: for each. But I agree that it probably doesn't really matter.

>
>Apart from that, the end results LGTM, thanks

