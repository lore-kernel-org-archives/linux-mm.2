Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3710FD31A09
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 03:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52C406B0089; Tue, 13 Jan 2026 22:25:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ABE36B008C; Tue, 13 Jan 2026 22:25:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384286B0092; Tue, 13 Jan 2026 22:25:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 260DC6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:25:42 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9F5F160342
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:25:41 +0000 (UTC)
X-FDA: 84329129682.08.A48CC3C
Received: from mail-dl1-f67.google.com (mail-dl1-f67.google.com [74.125.82.67])
	by imf27.hostedemail.com (Postfix) with ESMTP id 06B2B40004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:25:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WdfjdkLa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768361140; a=rsa-sha256;
	cv=none;
	b=NkxwsSlZxKg0Ox7CkZG6zhROUeSqoOr8l5xSQfN91Jjok1SAKT+oSf579tp/8+QHudremm
	XyT/vjMGVY0ihaE/6o+/xHVhCWdoAvDegQimpuyMR2rFymzdnWd00zuNEOuWWYvi6n7AOx
	T2oLwleAcBFZdiX1Gdf0RRTDD9l+5q0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WdfjdkLa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768361140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbWLobpjJa8xgEi+LiwpClMK13xKffaVB3M347EXltk=;
	b=7vu5RJUUkmOR8LRMVf91d39GOJthmHSblZQGKKbuWwBAFk8QNxaJGGT09zThwv0WtkgHQE
	eCYqyfKMFrFU+beb+R+BqFsS3piH8R3b8GPeemNZAIpFddwE2mmfIrclQHH8h12ysZKObL
	R//wbbUQERzuvdadXY3k179NPb8HXDM=
Received: by mail-dl1-f67.google.com with SMTP id a92af1059eb24-12332910300so2420788c88.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768361139; x=1768965939; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LbWLobpjJa8xgEi+LiwpClMK13xKffaVB3M347EXltk=;
        b=WdfjdkLa/+uz2kjAGgLlqgkSt/FKRmBnD5CtXpUPcVyfavZnV+CLnQJavZuuZV6B0M
         oW6Bu1sVZChrJ5kB6wWMyyFysFQx2zie94VwB7Cqwkziwwocnk9pujZS5O98adw4P5L2
         eS9UfdTlpvYHl/mkqQ1Pv1Hn6U3CckSyjpFWHFbomQLoqwWfRFskmOHnmrs/Y23Iw2uM
         s/lwKYXWmKvaL4fwjfliRBkitpoPggiSs8tUXBYOzgcaxDUKy564FsKUyr2LlJG6LMY7
         nu/vR6ARo9+offFYg4OP5WELn2h9uzO43V2mf6lbYsdprxPwSt8384fYRUF7i9HlNaiP
         dvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768361139; x=1768965939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LbWLobpjJa8xgEi+LiwpClMK13xKffaVB3M347EXltk=;
        b=jXngqhIC7amsrMEH1DvJH5Jb6z+hnevw9ZltoZua2ArzjILckz5Hy2E6mcgyB2RHiO
         aDuckDJz04Yfnb6ODlgZQVlx6fD9rQHiTDupHG1gmNH1sU5bdkOyRfYJ9tloscauvOjL
         gznQQgnpzMEP02DgzRfXoC9QkzWp9P7rf249SpbF24Vuuxzjk2glVZPhu9V5K9U5LGcb
         jFc0lXM5ohy9ciSwaAiAnmkFvLPYI1RQVLr3zebhMhc6COaVO1rrt8oiKkgDdJPw5N/d
         GK4byu1QunOzCYSTAXXOwlS708oF6wzG4jNKW5sfsbH6aSKk263unHIfktzxusQIXpnJ
         miJg==
X-Forwarded-Encrypted: i=1; AJvYcCU6LSF67COV0G6OGI03DgKDykhJshXdDE1sJ9nqhqSnR8SrE6f8czOWnWb6Zsok6/GwIrkdMTDN3Q==@kvack.org
X-Gm-Message-State: AOJu0YziNBxCBttb1hUa9vopt8opMnnpk9/zog2u/hr6WpHkoqLKawM4
	9Qx81sNUR8hpNZNzHZ+KvVdx1ZUhSE+5pcEYgcngXnrYsM223WQjEOW2
X-Gm-Gg: AY/fxX62ckJSAnhhDoGKKroo6Xo7wH4c5UPwL1H7LkknlKXtV0DuxPdp0+B/B6hlarf
	0NnXfEnj/s27rUsfef+De/hUpr9Uzd9zyoOZZG3PHkDq0AtP3+Iq+jx19kTRSDUCXOHWSi0M/zH
	j8vMCA8Usputpfg+jaDn+ei9Cuts32epARj+DUbk65hN+YAKUbbYFqg/OffRNxM5vuAWdOOeXxP
	sDYm6kTBHHy1xF5xDMsyMAMBKSG8b3f6BoAua+auuJMShQ12BtldDwVlWtqFzZF3jG0H1tpKk77
	OiOYH5DUAidUGzAT+0RQywllhtrotIjkfndg9P+oHIa3XKGdzyyEiiDghh8OZfwYeNLX0pv44jc
	KCB19OKc1MpmP1Ky8QEQrEnxb4z2V4FuCqR9xE8E+lngPtX7C2UH7Z1kpmgc24QL0+yQLk6mrhC
	nW
X-Received: by 2002:a05:701b:2504:b0:11b:ca88:c503 with SMTP id a92af1059eb24-12336a33f69mr1176816c88.3.1768361138641;
        Tue, 13 Jan 2026 19:25:38 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f248c246sm29706885c88.11.2026.01.13.19.25.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 19:25:38 -0800 (PST)
From: wang lian <lianux.mm@gmail.com>
To: sj@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	damon@lists.linux.dev,
	david@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@suse.cz,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH 07/11] Docs/admin-guide/mm/damon/lru_sort: document filter_young_pages
Date: Wed, 14 Jan 2026 11:25:16 +0800
Message-ID: <20260114032516.83483-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113152717.70459-8-sj@kernel.org>
References: <20260113152717.70459-8-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 06B2B40004
X-Stat-Signature: o54agqy94boe7kmhgybdg3z5r3u8u6xd
X-Rspam-User: 
X-HE-Tag: 1768361139-886241
X-HE-Meta: U2FsdGVkX1+E3UG7PZSPKCjNfTszo/TMAceCsFXPyY6MA72KuKl2/31QLUDbnsShADCq3ik8zg7Iqua3plZ5PMH+Y9cSEy1LXzUdfViNHLPHBR3sbawN/3hXCqDyhutOIYJ/GPTxOZ8PVX5sufvgoww9eYi5x1nVk0ABrlmEQaefiLj81+5HIjlTR04gMpICwgYQpAUYGkUtPT0oKKuD3CRFTfNGVBa+XOvRYEQXDeRuAX9N3r9Iti9hbMjsfXWY50A+51KjJ36QtWCBsOJT8bHC4I0s6nRULXEGNHwEmUXMWHOgoNuHlwzd47ebjm85CODTLi6jQCaghBie7EnF/+TfEjKuTh6xOF/Gq90sMWxteXKj0geqlsZTqJESUBxtJVHqREklsZ/Rypio8BSqUb9PyiMAc2hoUgKnk7UuljaxqOEqtRqOmWI4FVUr6FzOGnrwVeRO2zEf986lfK/KASVRE3ZboXBpj+6RQoOA0ocWDg4JH+ToIi2DxI8xEQniyd1/RMgAYVhd7hcpkjSYcgQEMkkZR/wShoSfqSsE3NgM4BJLrDeZbofUAwlMNYZIfENBSTlgROs1Bb46Zf4b86T814YgNtxlvkaaEFhkvkxzm4zJYVG3fXKX06ozVny6+oassrWDBsvGGqQDedyIvD4Gthtr1aXMXFgwKM7kl1E2nv1Nwt+V9P1MIDmr+OooZBrpM1CjftavhD9EmDTfWgd75n6xiozO+dfPpvDFZ5WoXL1zo9CBEzrtSPJVGwp7BAWVvl96YEuLz/NjPRz5NcdJhB+/J0D4oNOYVpLWs1QY6txYjTfQJxSarLgRPsYGMXcGvgJRc8EW9PsS3TO1GAN22YRJ6M0eRSoLd2MUr9T+JpMb0/F+lN1Na3pBfCM21f3N5Y7MW2qokqNjaDeweuFhcMPMvGR0S0LKpPY4+K/IufeDrDJB7xsPcJ0mkz1sjmi/Zm+x0X63le+vrn+
 74kXQjtB
 ki21Oeumb03kg9BHsV7XC40/4kYLynVWSQMU1zkYUTkXxlBbfTG8I/bbDt+IBAMxYtUlOarFEiBniqrNA0z8umVAAmRK7B7RFLlhvvXHhTM434sqig9zep7qhfbdn2vrgzzd96lrfRFt8+sc7NOAMSFpU8FCUi3MRk7z7yDiRWhq3Sk9Hk/FHx5nW5Yj6f5CtpvuidM5jjT8zOau6lqyyf/qB1wd+Ar7uye9CCiwhm7qdX7JpP2ekOU3m0hZZrrvv1Q3ckYGC18hZLH1K9dm5lP/bkWVhOTuGvpXsqnXMURWXFqru2PUxalrJnCPM5S7raksmAhm7BNhXXqPrfcgZ44J7zLfU7O9VKOr3FmOOoh9HN/0xWQ3EIwU5u88xW6YSaCydL23idgjYGnOVawyti+sKP+EcnFszAVnSk3DkwTMdAaGj34MgsDpgrEHFKCv63Uwa4RFlknswe+BWfsZBLH0k5ehMxY3RneLG6L1BGBW9HgwPaiv23wCCYAE+EAaoS9UDAav33EMKgAhHgp9TrBXrEpgSSI9JUgD67DM3BxviRm3InHAzl7WzgPiBldrJlYhQf4O4HwFhUKi2wFhFFn7cUFnZMuP7B8hE+9Evg8Nh8VKVk882yLyAfU4B9PQvColZIQLUbYxQibwUxOJ9+jkSqzhdztpnEUAMfSWifHnysVHJSD37McyUaVw4tnlFOBcA4HkQ0374wsCU+w2Vi5vN8cqLxOkoCgQU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000007, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Document the new DAMON_LRU_SORT parameter, filter_young_pages.  It can
> be used to use page level access re-check for the LRU sorting.

> Signed-off-by: SeongJae Park <sj@kernel.org>

Acked-by: wang lian <lianux.mm@gmail.com>

--
Best Regards,
wang lian

