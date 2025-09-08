Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 781C9CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D77D78E000A; Mon,  8 Sep 2025 08:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4F948E0003; Mon,  8 Sep 2025 08:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C659E8E000A; Mon,  8 Sep 2025 08:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B42AA8E0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:18:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E04B138344
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:18:10 +0000 (UTC)
X-FDA: 83865985140.04.52FB7A1
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6DB5040010
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:18:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=eMEw4qWd;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757333888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YavscbhBnLQerUXpQQXuMR+munlLpsXdMeTmkcH9XaY=;
	b=fyOZpKmpBkN1/zL0Q0U7698e3hE8DQVcLSA/ILHG4nn/KmMYyS4gvcjGlh1khss2BSimgw
	uQ5j6GQu7Ijt9LoNRxFJHfTLkJ3xhf90oenzSiLg+q3wp1AykBWRTU00ziIp59rg1KnoEn
	d7AtVszmp9Mb1IAhE1GO84JtJ2xCGPQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=eMEw4qWd;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757333888; a=rsa-sha256;
	cv=none;
	b=U64kAjLUxDOB5tm44aZTxyCiO92hq/b3JBm8JSrtFk2VlsJaGJZEL6M4kjCoyvsXFwNSYN
	DJqnmtG/2/MLok4EUQgbCqrisvIcFEi14i5rdUUoRCWQLyWJbyn3SFrqX/AJFd4plSKNmW
	q0GjN27x2FmEnN5Y25YCZZLoRHeXXkI=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76e6cbb991aso3657589b3a.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 05:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1757333887; x=1757938687; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YavscbhBnLQerUXpQQXuMR+munlLpsXdMeTmkcH9XaY=;
        b=eMEw4qWdnkX+JFZ7J8zarD7K6Cnlw8K6GHpXFFJ06Rm8+lMqxaBLixHfSDToyZGv4c
         PTdIb7RliXh5mtMzvgtFPRjCujW/AkgEltbfwniTTlI1C3PWc5gFk3Y+DZSL7NVuNQ6d
         XGDdhSym5IIHw0LggBN+heh+fS9eYYX2Nxp2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757333887; x=1757938687;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YavscbhBnLQerUXpQQXuMR+munlLpsXdMeTmkcH9XaY=;
        b=ZsOwfcvQdkCgIQRUdAp51wucgViUfBJ8+h/F+JnkQcqd8+ikWpDZUr+pjEL1G+59On
         oysaJYe0Ybuj7cOrsvWqNg1cYVbUK2A6U4+mdDVYBfOMgFDqRJVzgWijYIjl9hnQ6sA8
         eec8qsf8nYvl1p/KKtya5GckGrQazlKjgDZ3AzBhiRc20LlUe1w5xqmoFRqjLUQ9po0q
         B2Cu3LK4Jkzs32KaK26r/4Mne1rUZjvBNMRJLl4IIb+edlxg5pJBQ3fA6ER1r2BziP8n
         d92b6W7P6YmM8+hj56ewdTMnJ/NQss0KgYT8enOwe/OuIbCLh32JI2e7x7WpaStzvU6C
         nTTQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1LMzjPI0tpmApdHXOEpoJAuzzW2kX287Ifc/Y8MCaUmkBozbQFnUIpAr7IRO54fhuVBKgIpz63Q==@kvack.org
X-Gm-Message-State: AOJu0YyJ4I/fpNq3cteXsBF2yE62ZYF2NrdLAITx8eQ6/3VOGDUR5suG
	CKj6Exoq7NfbBmbgnnYlN/ChJ4ck9gVRDVIyntWD3A5OsORlHzeJn+Dq6oWjuW+2fQ==
X-Gm-Gg: ASbGncuDfhJ9qOAPqoOgGq0c3asgqjX0CNO+Z3Q18rTfYAob1nNN5NSVdDn1c+MxgMJ
	Ddj4RS4bVXY8FPKBKL3VAJ2J0S2vesO5Sd7gHLSzbEhp4Uuv3MF04PAo2trnkdHnqh+ZvaXg9+F
	IP7Y4b3L0q603NEqKOFURsGBg1cRlofufy+frC6syEw//Hqh1aVYj2D8la5uCpRWRbsr03AHyDc
	/T4y9q2mMjpkQ8C8QqTaLLH8spsh4vaXeODDYNVqP3FA8Iy9IvW02eKHU+T+QSzmd/GnwdUX8nq
	tUEdcdKoe+/zjzu04syrT+E0qGGftJaztcswktcONoZ6j6h32TpKdj/zUZh9QmuELJPgnJxrn/+
	fUSW3j+w1d4Z4LbC0c63scGL1sd0kZDUfc7E=
X-Google-Smtp-Source: AGHT+IGuc3KygF0Lp+FwgSMyfraRkRT9MUUiHa7qCu0NYd6Kla6Qfj9Pvg/sdd0O+HgGq1D/Lgo9vQ==
X-Received: by 2002:a17:902:ea0a:b0:246:80ef:87fc with SMTP id d9443c01a7336-25174c1a958mr113566295ad.45.1757333886695;
        Mon, 08 Sep 2025 05:18:06 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:b900:780:53bb:571c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24c7bb4eb4asm155396755ad.140.2025.09.08.05.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 05:18:06 -0700 (PDT)
Date: Mon, 8 Sep 2025 21:18:01 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Vlastimil Babka <vbabka@suse.cz>, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 0/3] mm: remove zpool
Message-ID: <tbvushbdn7nzitey3uy6humdndd6247r4544ngqkds3cr447e6@prnla4edwxmk>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
 <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
 <girukcvvzgbtkxt4aftfz3lw3glvf2qsof4mx6wf5perolck5n@vaxlrtaeuzw7>
 <dh74mr7bjtpzk7frviv6iqqno2u2b27p7jiagp2dtnsz2wrfhr@wlb5vqg4majs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dh74mr7bjtpzk7frviv6iqqno2u2b27p7jiagp2dtnsz2wrfhr@wlb5vqg4majs>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6DB5040010
X-Stat-Signature: xkag68oegsqxkd3fkd5meoq64unydnsw
X-Rspam-User: 
X-HE-Tag: 1757333888-407442
X-HE-Meta: U2FsdGVkX18ID+9YVSWjbUnBJn/dx51Pu9H+S1kew7atCxRUU4lOtnCjSVke4yCOPg9FbZRQ+a2Ppd/NR42o6suVfq1/0QCYZK8GRs60KNctV85gcqfRYOJzsa2qqfitdC8hpnPnnSDDLqnaiLIrUNCF8nlMEzkhzgDK0dbhXlSHT19VI6drWmSNnw4+JfE8TKygLF+fRdGIPc/fCSCEqR+X7/zYibezcIxNOELwlAtsUpJ7NjaxN01hxnuQFGdDQ/aHfpr/HeLh9V8ryXr4kYHsHavVLiuM2p3b8qPsgcHhh0ptovI0G2tLp/O8LZunHW3Mmldibo5g/Ga1hb08/e1FdVpbfoM5jfvrkrLFulvVNCXYizpvcAlsf4JZ6r8/Z5U3MBhFGxa4x2bf5mi4eeEN5BoDxDPQmlP4WEaj9JZGTV+UfWMygGzn3AU0bXVLBxbwE53u9A8qRCyf2pCmRZMxJEaUP7Eh5mGsTe7VISSXw/W6K/NVJtncfxxLg9aHtuEfrWRAo2p987pofBvAKzep+c/mSSEOlNvX1gwpyfSQ2HoOcj6NPUWwZNCXuiWZPb0Q8C2ODoLTDfT2HZY8lYUyEUL2pa33B3Lex4nC5ycoXC0les84HBfRqzGBCsUZvgVqTYQbwmjAbNqtP2vfhvh7mUSD5TJQZJC7/6zOaRTZrKb0gePmcsdG08UxPlciVrjfSEyBLZ+xrNhVouYAecORAvRsLv2nOUcQU6VotwRoGP5rY69LfdfSDlXCZiAoM/hGq4FKtzppHdwEk59Yps3QOELISblEeFD77qzuDwMuIwqfcH9TsQ/vOgkKMWBSncLd/HAaC32lTSo17nbdasRjQVQUDVKZTgRNImnQZUr3KREMc+yyadTWC9doH0lsxqdS4EvspazDiAp//4BAuKrNj//9hVQcC6NnW4p3WNuOD0Zf2pTOQ9UvepzAU3WhW+8OMPZD30THvENbCh6
 Bf+p5F+G
 mqZELOloCMvKRb7wy4cTYYV3IB3IgbVXtKrJiOeLV/B8gNFqTBpE7cGYPkcSwlwV+DCagG7UtoAcgxbqsosaV6oAKCtJ8Pofa0ezFKE72jMdl0W6E5RB3+RZBjy2IUg/7tYxMEFLDlYzpViXWJ8IqMPeb0NKynPTGYxM5CZZNTE8O6tQtj+b7F2//cwyice6M3bOOx5jyiRej82jSUKP5NXBfYmsxITkanRA7wnuXGhrqIfK0YN/ISwN3kWK+XsM5BPGxbxESL7bL1WrmnSU3wBL0MWBhilLli1s2aH5xYDcMb4o5KHjnyZTQQWAray8j8BW0/JtEUHqO5Vu2sRzZL7z6lyEfcQR/BYzZK6sEJXX6RVN6JeMvQImmJPHXf6I6wTin
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/09/06 14:25), Sergey Senozhatsky wrote:
> On (25/09/05 19:57), Yosry Ahmed wrote:
> > I think Android uses zram+zsmalloc with 16K pages. Perhaps Sergey could
> > confirm.
> 
> I'm not working on android directly,
> 
> I can confirm that android uses zram+zsmalloc.  As of 16K pages, there
> was a way to toggle 16k pages on android (via system settings), I don't
> know if this is the default now.

While I don't know what zsmalloc struggles Vitaly is referring to in
particular, off the top of my head, zsmalloc does memcpy()'s for objects
that span multiple pages, when zsmalloc kmap()'s both physical pages and
memcpy()'s chunks of the object into a provided buffer. With 16K pages
we can have rather larger compressed objects, so those memcpy() are likely
more visible.  Attacking this would be a good idea, I guess.

