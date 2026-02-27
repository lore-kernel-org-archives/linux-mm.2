Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 142E5FD9E35
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 03:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4506B0005; Thu, 26 Feb 2026 22:30:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267DF6B0088; Thu, 26 Feb 2026 22:30:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183076B0089; Thu, 26 Feb 2026 22:30:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0034F6B0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:30:23 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 997C4160468
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:30:23 +0000 (UTC)
X-FDA: 84488808726.26.18863A7
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id BB269100005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:30:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OgnY+gpL;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772163021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQiXZ+kgARAPEGEExKJL8Pnyc8DlS+Lw/ZxK53C0NXk=;
	b=ku5jLZQVivmnGmgyqNWtYiTLaG4Z2M4iO16Wi82M2aNJt2UhaQkITcNqEux/mZXiEhJWXf
	8vCPkB9IxgABEeC/QjWUujMMxREKeYQ1IkYm6lZcNaD9MlnzAW9aizb6FtBjn9kKJ5Ncw5
	YrjQBvLwMTESCEjcIsYdblT87tOY/bs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OgnY+gpL;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772163021; a=rsa-sha256;
	cv=none;
	b=N0ZegknBMZZoiL7VdmTu0KtQUBNr9laIZOGGtaGoTsvmEUombs/zdkKXJawdO7YjUIbD9H
	adwrn+l/TA5SFpenYMxLnUPJY3N14l+EvNq36GIID0NuGxf6ZrVvkYc+PG0HCHKBouLNkJ
	L8zD2aQxPLLzoXXr7ESdw2832+Kygo0=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35851eadc17so915657a91.2
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772163020; x=1772767820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HQiXZ+kgARAPEGEExKJL8Pnyc8DlS+Lw/ZxK53C0NXk=;
        b=OgnY+gpLC/+v13fJobslL2Pnd6oU75QQI6iDSjbyKCRxE7L/iI5ZPSF1oF3qLXI4TL
         U00LTcviT28CxW2mzGGwczagxdIMHo6/6Yl3uU2YFozXUXRfE2ne3lubW3zhrOT787/0
         QjhFZnZqn1p7q6HaqLKo1WVZwUSmQV6s+YiUVSX/X8a/ntXelHNLlgbxhs78wUOc64/u
         3UatrKuXRFn1rP71Tvyrm/+7e1hHBTdbY8RGsWZr3Mp9kIIjZyZAMwV5+Qn6eLolrjui
         twBUfH0dcsyYXake0gui5hPTfuuO6SLlW7UyTiGytgyyno7i0dh7njI73U+q1olTedIa
         KDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772163020; x=1772767820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HQiXZ+kgARAPEGEExKJL8Pnyc8DlS+Lw/ZxK53C0NXk=;
        b=jjYfguWWEBn83iz/8iXThjMRiY5kOI6KgIq+A/C3JFvM+/cI4UQAffaMa5xFgO/Ld3
         K2LjbkngimakwqT6+PAel2utuQzjZzemD7+uf3NWx6NgUmeBC4Nk+ouwbiVEaUJYYwnr
         9swEw6wTXSWqofugHWLu6jjA7eH+rWwvfTCRZJl809kdUabrHfM1MEjULPgQNVFE46Pq
         UKcMU3ZP9PZT87F98pLB0XfoH1cg97kL2tQI/J0eCUW+RfJuxDBmxjagmySq1sYLAYtb
         KSs6tr1fAUy49kv1VP+v2gIM9JQM+vJ/fEY8Lb4NOrF+DrQs2iyTtRqgIo5H6LxIShRI
         LdFg==
X-Forwarded-Encrypted: i=1; AJvYcCXp6DrmaSdqKqw6bYtdB16kNB3aALoK0fhXSYNJj65s+fHMm8a1h8aQHtRes0SKKwaHUuUwNomyEQ==@kvack.org
X-Gm-Message-State: AOJu0YxAxdX2OQgBIZ1HxlmkqW+YL+Jd0tRyFeSdJa/tFOyX1eGYZro/
	Y4eprnuV2snJL9FawT7/TSVEEr+Db6xrekLwbGs5DGMo+cpkYriNK+EC
X-Gm-Gg: ATEYQzxeIwh8+2WoxJIiYY4ZJHI3MP0MUjrIDLNhMiwPQGvJnojTYFbdvZcAmyk7F6u
	jjICIT2neqiQArPUIpYVTA+O3vJ8yIH4APJ8uPr0NmLXmvOQOhfxVjVVhyLzrYExDQ3HwScoY3P
	MLjePNxGcThg3R4UddfeqIu8aB1H9hhnP+G3NLKA2igOCcuBQNWwCQVi/7JyoYN1kxl5bQGhPzF
	5ofL17KN8Pnz5pNu1pP07oC1tRE9nWlI6m2w3HGkKxYng3Yq/UBDFYldJy5TAXhN1Rj9E9HdXE5
	48KRC6BZxlXGZmNjr41FrPaXhtJuq3EsEDhIRtTdHsLuI81KiiQZkfUHT2yxB7khKW8sUQHAGQA
	ZCl1lNO9HXGxvKfIKq7Cdt6tFNqk04naaeSznifYAPAXEH73DSQDpBuAtu1zjXgPAnc/ypY+ePd
	o42T+JKcstf1F14E1jnX89YgXLDtNbB2jt8GRt
X-Received: by 2002:a17:90b:4cc5:b0:354:a05d:9dc2 with SMTP id 98e67ed59e1d1-35965c2d153mr1259446a91.9.1772163020387;
        Thu, 26 Feb 2026 19:30:20 -0800 (PST)
Received: from Barrys-MBP.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3591359fa2csm3326270a91.4.2026.02.26.19.30.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Feb 2026 19:30:19 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: ryncsn@gmail.com
Cc: axelrasmussen@google.com,
	linux-mm@kvack.org,
	lsf-pc@lists.linux-foundation.org,
	weixugc@google.com,
	yuanchu@google.com
Subject: Re: [LSF/MM/BPF] Improving MGLRU
Date: Fri, 27 Feb 2026 11:30:13 +0800
Message-Id: <20260227033013.94901-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BB269100005
X-Stat-Signature: dubsf5xspdaxfscoyjnfd7ia6nwmyt37
X-Rspam-User: 
X-HE-Tag: 1772163021-141547
X-HE-Meta: U2FsdGVkX18vJ+PwVgmHDeMVrExhpoN6kG5DRZOmFQ0mS47JYcHsoTb29eMagxZWb0GGTw/JTU9VuN3ZRgE9udYuUriejSPk08pgV51bpGbW0PNhg2KpmXx9cw/rXWGjL58y4/J5Jy6UHWEduFQHKOLlQQaEA6xOXYVtOFFoqJO8yf15eBqr4y+zdN7nY5dtEkGtLVNtLgI8M/M2eUk6mnSMmQcRiinWa2jcYS4kRJsOUku7cWYP5nJOhy3vdJtpoE0TrArr1w9H28eS2IBQRMD3BNLYaIROQ9Zo37PqhM3O2HOm/InW0BUGaVgvugADCDmA7RyjwHkXxqSW3eUyP6RYCVpF4VCECyF9cAixf0nHIwE7c8cChD3JOHOiatJm/2imfWKT7an7FONjAiSm6P/xH47hj4OGtudYurwfeHtKlsYkAPzUjvnUQw2gdietcaCyLi+EgLMnqhfy/gADfqHbuntUIbVQGIADoSSYqGOgiKlE8q/QNvxvPK9WKuz7bb9Sa2OXAuegNvlA4oM84sw8XLhJa9Yxdhojwy6xLv2PtOM6B+yNPpuf0HUuxv3oDRTl6tZKaiAfLVIETmda7S0hSVYJrPECc58ukboDkBsXcbbRSkOnRSfO2eWL4sN8slgDDkTk9nvlrcMYCkq+DB8JzGtTGypONRrl4NjVWyzB4ajwuOAyTXJzxZ9N+Nc0HG+7MZP3DjrR50/BLdXQd4W+8qdq9Ab2Xh1VgWPO1HUr0cjC9ob6S0XLj3Z+GlAAFeOnbhWnCefc9bheGbiMj+L2iCVjItETtTLEg8O2RkzveAv3oirdpPiwyU04ltjUi2PY52JRqlvGOlulM5BK10O37J2jz6US6XnFViELgvSNgd0vshJg9JM+0J0XxLnsR+fFsdWiaohRXd4Pg/ToG0DbZPZM8L23Puztb93ln/KdX8rILNAyDGMjztEfo8hwn6Z4LyN43OaCLmiWvKJ
 kUsoqVDH
 vRp/nPJPm+EfwdBmkX8EoZW3fA/iJZd0HMoD7t2ybyppT6kiAassEPGXyGIa01OuNDVZwtO9qJRI+01KVaVTGHjyyqdHV47OYXfqpxyIiIUrLIYZ780W2i0DfO+8WISGHT2kYhFfH1q65slw/FyNcBsWgOPA1W9ZD87vTsmQncxkM/FyYo74MyYm6Xp9dQi90j8UtMehzTy/uZvIKca0o6lZjyNRzfAQth0pVIrwa2z7FX94Z0ReBGaLdZoVkQeUSucIruMxxILo1eKQZriAZvGNG41yisOCk/yDcNCbmoB1g6QBUZGcL/O8UC1TL8XVaQKPU7KJzhNiewP3ZxrqFpL0vMKBz2wspmZJmNfuSyXx7N2r8tiGiz6H9OxXAfHX52rVCE3k83whqIxzcaNG6fiy85qSDibODbkKBg6r2h0MSJ7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 4. MGLRU's swappiness is kind of useless in some situations compared to
>   Active / Inactive LRU, since its force protects the youngest two gen, so
>   quite often we can only reclaim one type of folios. To workaround that, the
>   user usually runs force aging before reclaim. So, can we just remove the
>   force protection of the youngest two gens?

I guess not—MGLRU needs at least two generations to function,
similar to active and inactive lists, meaning it requires two lists.

You Zhao mentioned this in commit ec1c86b25f4b:
"This protocol, AKA second chance, requires a minimum of two
generations, hence MIN_NR_GENS."

But I do feel the issue is that anon and file folios currently share
the same generations. This may make anon and file be reclaimed more
fairly, but isn’t swappiness meant to allow some imbalance? Sharing
generations causes them to keep catching up with each other. We might
consider providing separate generations for them.

Thanks
Barry

