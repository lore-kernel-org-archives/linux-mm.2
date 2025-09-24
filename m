Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C17CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E82E8E0023; Wed, 24 Sep 2025 11:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF638E0007; Wed, 24 Sep 2025 11:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5308E0023; Wed, 24 Sep 2025 11:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3298E0007
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:07:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0F16438A5
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:07:48 +0000 (UTC)
X-FDA: 83924473416.23.E7DEE2C
Received: from mail-lf1-f73.google.com (mail-lf1-f73.google.com [209.85.167.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id DDAC940017
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:07:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ay5Q8eJi;
	spf=pass (imf11.hostedemail.com: domain of 3gAfUaAgKCC0SJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.167.73 as permitted sender) smtp.mailfrom=3gAfUaAgKCC0SJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxm1+BttfzZabXPoYExS0LpEIkdqq5ptW85BH8SIzIM=;
	b=f8ifgw8A/WpDRG17M67wnG/hYiv3yuQK115fOG9pbDkDzkAQifO7nA/sTOLSlqosthlU+d
	GOWQ33Zxr7LbvKtP2u457LQ/gGKk+uiauAJRYDjz6Oog+2xAYcbrVEtIXEMZ8zN/UIBzPz
	lGM0sfOfg1BJecmI3UfJSp25J7Obr00=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726467; a=rsa-sha256;
	cv=none;
	b=NF4M9Q6COpTURJWEhkHCgOuSfXK3T93lwqZ5GCtpt/FNXz+otCvY9pkBwz5XWUr+kSaBTR
	ayqoiV6Cl8EZnjeskG3j4Q/zQg3DBhsq4PNxv2sEklVvcGxhdsdSgAYYdcBTscgn+tKtSC
	s2o0m766odxr+Bdz0zGteQTTx5ZzjS4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ay5Q8eJi;
	spf=pass (imf11.hostedemail.com: domain of 3gAfUaAgKCC0SJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.167.73 as permitted sender) smtp.mailfrom=3gAfUaAgKCC0SJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f73.google.com with SMTP id 2adb3069b0e04-5777d0bbb91so3810401e87.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726465; x=1759331265; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cxm1+BttfzZabXPoYExS0LpEIkdqq5ptW85BH8SIzIM=;
        b=ay5Q8eJiSGvw8hxa7HO8n1YrCdfqewkg4+GrfqwoKjrAc2frGst/7iNBVPe/7hacUz
         bPZG9948w1wxJExbBOjGPnyrPGTBAmEngQCmjqZkdNhEC1MNyLjXuUKpccO6frEjeMJA
         h1rHmgFusy7q6UFcbv9QfjY36+K7FylnIOjAqaPDKrM+sX0ZhGajir/BNth7Q1KYHmAg
         lnIlEBZivMafd/suREE7/t1D/WnqWDMv551X7M7bmekkgKeqbznmfAr4spLgUwd5UOQ7
         U59s44S5r8m7UacxXXxU74eTi8Ly/lGybL4IgJV3a4xRTKPuNeEwsbphrTjKEOOl1FF5
         1Nnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726465; x=1759331265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cxm1+BttfzZabXPoYExS0LpEIkdqq5ptW85BH8SIzIM=;
        b=CCUCsGHV1qNTWXfoihgWB1eEIK3sauaWE0d9TbcIX2pMO51nn59NP5ijcfFhjx749T
         7w/7eYscrqPYGcYPdqa/P6i6AjHXm8nb/hKrXMETEj4yp/oqoZCEVYOMx7+Fpbnx73PQ
         z+OIjacFeJPmHaPMYXBpa+Ef26DM21DpYXZ6oG72CjI9NP/oZzk3YL3LkuMHbldbMLiD
         RypmkjuCp0y681EH+mWFdMJxUqQtGKAJSCipO6m9U7vyPRWB74/Yg0f90bBYWzPf5pYS
         fX0LpnLC+HSWDiom9HHhkN8gPS/X2RZKJ9qNOfcUbyxHPBtUYugmXItq4OUOWc/K/c5w
         Re5w==
X-Forwarded-Encrypted: i=1; AJvYcCWiRzmgJZpptblEEv+i01/VfDTXGbnzIvcSVk9geHa2BasFIdwk13ckEV6rpSrs4zYVo/Z5D28XQQ==@kvack.org
X-Gm-Message-State: AOJu0Yxt0mV/0jUxrgkn/6cIqyMsDjNmUC/QSr9nR6P/ecDqjpiC7k/x
	gVvzwngGQulSHd0nGEjS0X3z+dhEFsLR1HS2mAulJqVCwFswrE4nLjrdG9o1L5n5jA5orqtKFVX
	zUOBwXJxEtplNrQ==
X-Google-Smtp-Source: AGHT+IFbV4XCppcQcBh4YT0+YYYGbMDe4to2Az87MctcSzey34CxXXjmAG4jYevOjLMuvS5zxWssC7rPfCkOlw==
X-Received: from wmpz21.prod.google.com ([2002:a05:600c:a15:b0:46e:2f78:5910])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:420e:b0:3e3:e7a0:1fec with SMTP id ffacd0b85a97d-40e43b08a86mr265628f8f.16.1758726016966;
 Wed, 24 Sep 2025 08:00:16 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:44 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-9-2d861768041f@google.com>
Subject: [PATCH 09/21] mm/page_alloc: Invert is_check_pages_enabled() check
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DDAC940017
X-Stat-Signature: xh8ur4cynz1inqj8wqiyfu6inraz7qwj
X-Rspam-User: 
X-HE-Tag: 1758726466-279712
X-HE-Meta: U2FsdGVkX19Q4b3bzONIieEClmJjqisbe7JhtrBJDXEm7pw6eoj0Dip9V3J61A7JExlP8GiOwWUqzUe0v1pp7+nRF8mSlmxuiIPAFCqEb0kid1Zh41jWNGMWf+z3pxOrx1h7b7qyYm1nyKi/IsxJq2KQlmYgfvbJ3CteEhrkCblIsbgTwk7MdWqcaqzH3Z95ZMIZXVZuQfJW2uLI5WKnOrczNPn90qOu6hDxfKzs3IwVF8h/MRZwrENM/KpYpgGMuOSipLsEuRo9nQXdWAY7ZmqZZDuAEjO+hBCOY0V7KvWaI1XSu62qHHGB1AiyWsPOyToBq2ldV+GuJkbSVpaYmilRvtOhKUFaWEe09F7UhnOitioooZkwOI9WgcachhG+1weG37eXa/otVsYL8TiitezG3S5DBZoSDmd4eG2+Ej7NiXilduIBeWl1xCr8aXCmzevbSNfjVfRr03Asv9ulMje7jc6FTk8K2YY5jpP9nkfwfhLkdsUJ98ilsvOukaxF+TsvsjFdY4RT2cWI8Yqy5Zr/NyB9agvAxfb6mMSFqcMgBmdGDav7t5WjLksVNE/+6VIE0NDYHWltwpMgNxZsdLiLiHQOWsO/yXu7rBRsxEkdUKhstYodN/22vIUv5t0lRyJGYKcqIb4qKTRL2pA1aEH5f5AYDjx3EVo8xhCwMxXmZuGcsJ8+kT7fRf/+LuPiwuOoigxGRFX436o74yND/jX2pJXScZ1tX/J/MY17PT6CEG41rc8D4lOo1s3simUmdQYLPC0aA8YNy0B2RSx88zfG2ruLIaCsiIXcPgEKSofkrBYwwi8uL2D+xRPcghXqFDbZl0+6FRwNgepoL6BNYZ43/MhGQR2T140WQu8ZPZP05pR/Roo7gB/DSdR3Pnopqj9QZW81DTPXruyBEU07unLHlxVi2ubccGaNNKTFuNNTeqG1d40z4WpgAq3+9zzYsDN4cYijadhDAHXh9hh
 ivqQwH8B
 eLI7r01+Cjo2bg/hfT60PENihtFqgZ2/58dHekP7cgjr3ATgP8ZlU2JKowzdc2mHsrI6BCzqHTzoInG1Hpc77GDXYeALhXucLFTh48VsqTiLOvOG+b3iFR10TQ2FcFRuc02TBgRvOtrYpdqwQEEU1jPQMoFjIqC/4Pv7Rqntr29sTP2DBFddVXW1hBbVly/cHcIWGvd4Jx+5jvbsb9H689Fys2rSikzCQRJ/GBbnisznwld/J0rSNGXDTjv18c3xOPJdi3e/Ov7VFUYharX32dmzBm7q2mgK579ntye8TuwLDrGkHaMhw6Lbhdiwcfl4/DBfKmihQR5hHHN6naB8PUpOu6mrPzBcidDS4WQQ6eOi+SdJ08XxkZw4MrZkorduf9g4M/tYIaTNV+GYc+5T4pd9Os0jT3EhLS49QbMNHjgfd/eefFomZWuNQ9Eqgst5sQkzeA5dRiXlHbxTnifYF9OVAN6mswnhUngtltjjbmOeDAJEb6jaOEymrSgPsJfvz7CpbcYgGXXtw6F7dyxMmxId6+ju79CWNMGx8jH9vjVh4Xfa9y+NbHcQYC+8ieH4NSu7Ov+4TTitAC0ANSdAb48KE3/RVI9iigSUBjxuSn/r5qz+I/oZN0zDWIzhtgDTqG1aGnHPkv2QBzE6gbX+hzQYZcQTLssoVLviJKPeVpxty9ryrBL8KoU7BIYVZi9O1D6Ed6IevkwUzX73PcqJR/qxYwf2Nptc3XXDT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch will expand this function, making it ugly that the whole
body sits inside a conditional.

In preparation, invert it to de-indent the main logic. Separate commit
to make review easier.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a1db87488296a6d2d91a1be8d4d202f1841c4dfd..10757410da2127b0488c99c5933422fc649f9a1d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1752,13 +1752,14 @@ static bool check_new_page(struct page *page)
 
 static inline bool check_new_pages(struct page *page, unsigned int order)
 {
-	if (is_check_pages_enabled()) {
-		for (int i = 0; i < (1 << order); i++) {
-			struct page *p = page + i;
+	if (!is_check_pages_enabled())
+		return false;
 
-			if (check_new_page(p))
-				return true;
-		}
+	for (int i = 0; i < (1 << order); i++) {
+		struct page *p = page + i;
+
+		if (check_new_page(p))
+			return true;
 	}
 
 	return false;

-- 
2.50.1


