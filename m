Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DFEDCF65E2
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 00:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 712DE6B0088; Mon, 26 Jan 2026 19:51:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0B66B0089; Mon, 26 Jan 2026 19:51:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2166B008A; Mon, 26 Jan 2026 19:51:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9316B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:51:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2295C2E39
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:51:54 +0000 (UTC)
X-FDA: 84375916548.08.CB4D388
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3CDD74000C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:51:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aEotvvZF;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769475113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VPcButAP/UZ901ko67k+uVch1acSmoZ0yMY7vXyJSOk=;
	b=v0khVLpqPxYFIOkzWFgjSuTZ/KL7JCELuYvtPG5kJksWEe5uECvCDJsEBH67HR7ZdlIBqM
	zyBg1qdU1AyPsnpgVl5IsnhGbTZYq5HiGZjyu84FJkElYJEeo1gLSpxAQCN8ZfG8hOIbKQ
	PNiI1Qr4sfyWHd5jMaCPWHPi25twvtM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769475113; a=rsa-sha256;
	cv=none;
	b=xMp2Yj3kDwHBaRMhfcmFNXaBiRdhwKNJMqpawv4O2y9FuCR97q4rYLKfYgIGQLfkz1EihA
	ZWg7FMmoDBivLz/OHqBtYQLWwuGMJqLn2CKjGbdAV0oxpkoX1mwKpRi6ZW8VkK4JoG5rUQ
	4sQtnvZXR8yrkccyQCshrIC7JM0cmXc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aEotvvZF;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1233702afd3so6836345c88.0
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769475112; x=1770079912; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VPcButAP/UZ901ko67k+uVch1acSmoZ0yMY7vXyJSOk=;
        b=aEotvvZF/37OR36IHTm50SVuNaAHz8TRnyeCLjDfyjLHexf90jMW0CMSr1V97EtVXL
         ms9QCc3mpU5anyFqhOcN8cJhJBIUOzQLTG/3/cLIe/1zkslJf+VIMK+xKvF6FibBjirP
         NHC3ZAmA9BWmqTU9YySX/sWHAYdC6BepAxS8IcWuYyI9ztWF0r4qaYldXZnIwTfD0nW2
         maXNgj0+NCGgAgbKCcFLoZSLDtaRGhYUM9x2S4ld8hXzNKfTFhL9R4205JgcNcFPgxH2
         a1gKAu2MF10LoGoUVwhJYQxlJ6OublFBxgQhIUk1pwWIbA5RS88p26xmaAiiO2rvY8re
         /Mrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769475112; x=1770079912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPcButAP/UZ901ko67k+uVch1acSmoZ0yMY7vXyJSOk=;
        b=kXte/8h5Egc58O6cgJdWWub9htw1cyXKlgzVMoCXWrI2HM4GTdOyfg42vtpbAGEXIA
         x2/341bImQdZIWWs/xxLVq/CmaaIR4S+5YZKdDgvaDN+oSM7p/7OdYQcKMhrmfjeREVe
         2PajBkarqozdCkocwsCTgbsNZ2yZsZo82rsMhQHKXWbY2O9xELNRp/eCy1DWzVCqAhFt
         AmOywCXPP3cmsE+sKG3ipzUX4sV+flbbzW/DWXOQBpaAxicOQ5MuLJyp/sEfRgg2kaq0
         XIPHS5LcaCpSTMOTU0g+wGirwyGKY4+NLffGlI0LlhXVG7vE4SuPOdTuB9n4X2wbJO3a
         Wzuw==
X-Forwarded-Encrypted: i=1; AJvYcCXFXZuKIEX7sdIhEPWFmdoVg6HqdmYif+ICs3h9PiZppMHc5jnzZVvyFZb5ESRdZBVOaGl0p/6tag==@kvack.org
X-Gm-Message-State: AOJu0YxZZlES5EJ989CUDXpgMIcfJzbqN4ViRepVoAUm30lfEWYoulM1
	mqHxc9JTOcgDahncFJ8k/zYFLbEzMz5QTI3qblA5xGcblaAOa2YFxTqM
X-Gm-Gg: AZuq6aLX3lBpFIsdc7jk7tQn1pGH3dUhfwBaWmWW9Lb+0ua8aPcFzYDyAn8JyTZ/bOS
	Uh4/yllhO+kIhry4BMa+Q8bkl9S59ZdoxZpJZg315D9/LmD+fuTg5XtleFiGRgM1Eznqb//VXZr
	J+xLzUgSunkv0oakmLU5nNXgULyT9rPs7H4fNj8eQDMmN9VISdItoXYnoLCgCHS+T/dfWuWloA2
	rb01GDOMIlT2R3tjv0Q++i1CyITbykOd18wne3VkC4X4gaOTmf/yYD5CgxN/PCVqCpFjO+e31Q6
	2c3yt1iK4rKeLmM6ifKnzZIk0zNFysVHg1hmr26CtOkTB9VvXOClw21dm9AQIc4Sy4sjUmKHeYB
	X1lGQwg5XxV0S0A6OGWQlvSM41qh1W/yJnnIGYM+3j3zaM8tJEacZ40ekda3WcW8qAHGJaplZOo
	DYsgwwVW6zEO3kvnGH98hohcUYfuLoQkvYIPPmJEkz+OM=
X-Received: by 2002:a05:7022:6189:b0:11b:9e5e:1a66 with SMTP id a92af1059eb24-1248ec0542amr2982851c88.14.1769475111776;
        Mon, 26 Jan 2026 16:51:51 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-1247d91b9e1sm22185065c88.5.2026.01.26.16.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 16:51:51 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 0/3] Convert x86/mm/pat to ptdescs
Date: Mon, 26 Jan 2026 16:51:37 -0800
Message-ID: <20260127005140.197847-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3CDD74000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: h8emxpk7g88n4fsspx4z3o366mdgd4aj
X-HE-Tag: 1769475112-910445
X-HE-Meta: U2FsdGVkX1+WGNbTfoejMJm3HZNouQSfQAAtC4wtvWDblkITm/ryFb2Y6npWm49IyagLduzEu/kSD/O4B07K/bUaCmdng8snURtjQtDchTlxMkjveHU0udHL1fC1NbeQYQp/OOglrhabER7wRcmmy3t0x7HZsTd1yVpCXwTZMzxMta+oIOrjcbtpwfN4LI+KqxUh+fHd92dt9st04U6bpNS8kjZ+m+hpUfv3hfqq9AlNFkwVvkbrIJQ/IvhajsClfnw9ms6fhGgnQYwcZa5VS5VczIi3uszhvZsyBxEK5zFkOlov5tGHa3MWWeYZC4Gfs/MOqcCPpebIcLbG3VtjYO3f95u+NIv2smFDfKzwVHqAHjyD5j/kOzIf/z0mEKgouLhL4AP4N/4/NSdDYTwD6QIv5EltnfpaODg7M6F40YPVyvWQ7cuuKpPGPGc4sIMZdCdAPwteUYUxSnX18cokgfksBBeGMwglRpR/QRyKbM7SAcfCygN6Hnq00hGHBFYzr6OSI6x/dCmVwTdC/xtkAOwd/lvqp6O+/5D2Zcw060Ucd6N7rzRvlJAw4Mappxoo6GUiRlGf6bFe4oyJ40IXAWyJ2elVQlWRzjW7hGWat6NuK1+hj/8vCnOb2KGU5TP7JsGk6TQ/P1AUa0ArO4Wb67m3SNXQZnyhErvJBOEXxc7f+r/6l3WepVx5S/Le/TtJTWgWGkPyihHEapIpx660Cmrh7RivG4rZ8AEkJc9iGO5rDYs92KYJ8ECLVneeNh5FRvzh+3dUTEJuQaJEzOzwAHL42clzg2PLfG3ATG8bpvxYDAYiFpwHoAynHFWSL7osH9ZWzbZShSSybsyDZWfW4XOEJ64HirjjB0wY7UbYnWuaXPeQukIgsTBmiQkfG0gaNWqcdw6fzQeJGAqhkuZzqk8d89ikwncuF0vrYsipyftrndpKaGfxP+o0BP25OYQAzGulSpaLK6MJQQkoyXd
 IG5a8VcB
 s+9BvIhJgJsWYmMvLDf59i0y4qr2F899cmcgDDXynr2wqKBk4cIbrgCqpE560WNfeMCli49e+DdNiye3mqS74kriI5mK5HoMkHzqKoxPjmsi3ShlA4jKKUcMVu8FPiyw8Pk3014mVIvudQIcO9hVPcd26arsl5v3emQbL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

x86/mm/pat should be using ptdescs. One line has already been
converted to pagetable_free(), while the allocation sites use
get_free_pages(). This causes issues separately allocating ptdescs
from struct page.

These patches convert the allocation/free sites to use ptdescs. In
the short term, this helps enable Matthew's work to allocate frozen
pagetables. And in the long term, this will help us cleanly split
ptdesc allocations from struct page.

------

Based on current mm-new.

Vishal Moola (Oracle) (3):
  x86/mm/pat: Convert pte code to use ptdescs
  x86/mm/pat: Convert pmd code to use ptdescs
  x86/mm/pat: Convert split_large_page() to use ptdescs

 arch/x86/mm/pat/set_memory.c | 37 +++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

-- 
2.52.0


