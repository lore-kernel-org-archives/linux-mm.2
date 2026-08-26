Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F19C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 06:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122D26B0088; Wed, 26 Aug 2026 02:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4336B008A; Wed, 26 Aug 2026 02:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04B76B008C; Wed, 26 Aug 2026 02:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD2E46B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:15:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35EB91A02B7
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:15:37 +0000 (UTC)
X-FDA: 85142409114.28.488390E
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 74BE9100004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:15:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D4tfYZum;
	spf=pass (imf14.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787724935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IFxcZ1IROsPv4rceYm+aT5Ud3Cuqd0ESuqG9hhc5tu4=;
	b=Pk++M7UNCWcxdrMKn/L8zLERJ28iaHZd8/tTPzNkmb6QwTSFBhKfdhZICkVf+W/JdJlF3z
	cA8c+72uMpvWRZlo1rdG5+nTsX/bYctDSiklVHibBWn+KGq+hcUzBUmsfZ3wPjM6L/Aw/y
	6Kht4pL1TriCQBTOQcxrqqQVIRiQVYc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787724935;
	b=sJXWPFDmkre1D/BeCKEQE4QfVcd9tgFh7k3WR3BBs30aoEDYJPSEEh7ir7ZRdHMstwCFxZ
	nsGmjKw8DJ+B+FrzrLlhMTsimPTcOyExMjergmZLL7U8s8wOlHxHX5ZNduMIZZ7IX7ucEi
	2kcqI/Oj492eF5QXx6jF0x/TzrKsUDk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D4tfYZum;
	spf=pass (imf14.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso922716a91.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 23:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787724934; x=1788329734; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IFxcZ1IROsPv4rceYm+aT5Ud3Cuqd0ESuqG9hhc5tu4=;
        b=D4tfYZumXHwWKBuWUuQww+UKm+go9L1FzjVgSpp1mkmtfFPAp1Wsr0Zy3AmXm/ph99
         h1di4cmPX4k2PmEtrVS04aUJgiVO7nSwgwouQdiPsd9qVgt+bgqHezPT06dnU/7oYUHN
         pNb4hs0POm9x7mA/pL2BcPcwIT95ZDIYD1waC44gK5EId2NFOx/0ZVk7Dpq4Zv+kRZjr
         jqfVs/8cWY5a3kzXU62Ni3QeuTFKBLnIuKDijLh2CichZW6rAf5RNp7rT3OTmu6jDoVj
         yD0AYZUUvPUJsw7pHb9YzjIcbpLhsWXVFTnhGiV1qeV7AnUW7xzVpu9HFpJR+qRLL8Tv
         08yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787724934; x=1788329734;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IFxcZ1IROsPv4rceYm+aT5Ud3Cuqd0ESuqG9hhc5tu4=;
        b=iNKS/SSNfOYy6splvA1+4wfLskF25pItMm0OK/+8jrkQvwBNU7IFbBGm1uVhIJJMBw
         xtKTVTboNCF6bzFzoWKrF/2bLhoo65gGJA3zKSXa2wbIiPkdlwpVjDVPG/ruvdnJfVNF
         V5MIx/hZfW32RXWwLLDzVM5VDzHzTXkYXcpv1N0bEhsJLSYCtNZFskf2g6rwelqMJhiO
         ANlSC8V0TnMXl0Biv5YSQ1oocGYqxC40HJk4ej/K1dQQtHCV6KCIClqfC9C67ok+sZTd
         rAukHO5sLxUW8KhH4DubTAIZZgKjXw7zTmLzqwUC9ZQYcuyVmgHExaOfi/hvkH99XYHf
         yrNA==
X-Forwarded-Encrypted: i=1; AHgh+Rq5CQlK82wLEBSIHgcx8gSSAQiNCItFmL5lqkLDiXlOEp6G6smNuRHB+tDqz8YBCodbfDEGXkuE2A==@kvack.org
X-Gm-Message-State: AFuF++npXIYnsGsL7vukX5v7tBzDhuZoo+xV/nAnIQM/ZZ+0fmrytQkH
	8quA499xGoBS2sFv6MkFqVUXh9Xm4Ic+r2E33XBepkJukUYEXAbjaP1i
X-Gm-Gg: AR+sD11PZE93LHRSKiPwJjiYPAKKIQARALID3PH+qqjzvABWwM8Mk/D4htqqrs9RLkr
	4dXuDCbShsnOh4GmXD7oSTlSrQ/rAaxYrHkbG6EBmOz1YmzkTGJ4QhFadz6ZTTgWMoPMmOEjngY
	3UaCCb0ySAHv3GbQifvTY66Fkx2JIFfFZXwh6YrV1GFIFfK+2UsQMiCzfT84l8EmyDvsJbimw2Y
	hWdDRV/1xuOpTN9py1k6XsIuqdRCd10QIh67jgQWKbJN78792OEFbIjM9p33sOYoRDhTeNtiyem
	OhDPyQ1dbI4z5S8Y8a53KcV8ScHXW8Whq3fvT+AzD43n9Wbml3zEfB0gOp1/ID7LAYA+4RZbi2z
	YFzHASIlIoI6AMrkzcuhAa97jwaej5AgDpBI0ewj6R23L9NK5pMDlOt2sqt5b73wybkAfA3xUv5
	dMMoBOmBy56TyBuRo1gwyGChIUbBWWnpz9MiaZKasXpXKFTCXs8RicoysoOQYs1iaW6HU1TqoUD
	ZEkB7pytzfuV4fxmlUwynvn/+w=
X-Received: by 2002:a17:90b:1e4f:b0:38d:ef48:b04 with SMTP id 98e67ed59e1d1-3966d5f8eaamr8803881a91.10.1787724934185;
        Tue, 25 Aug 2026 23:15:34 -0700 (PDT)
Received: from Anshuman ([103.161.223.14])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283d885fb6sm5192046eec.14.2026.08.25.23.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 23:15:33 -0700 (PDT)
From: Anshuman <anshumantewari123@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Anshuman <anshumantewari123@gmail.com>
Subject: [PATCH] selftests/mm: fix line buffer leak in mremap_test is_range_mapped()
Date: Wed, 26 Aug 2026 11:43:00 +0530
Message-ID: <20260826061300.14038-1-anshumantewari123@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 74BE9100004
X-Stat-Signature: gm3smfjg9oujnreux1m3z4dnyio8s5yw
X-HE-Tag: 1787724935-832736
X-HE-Meta: U2FsdGVkX19yJ+gXoSM8a9HtGP3sLhv9YGnRZQJt9EhjoGyNOwi1ShJcNFTtGMd1E/DFx3OimF6iEJQkEi5jeoa++WG4jRmfYYGsRDMqoMCAfCcUd88o9dza2d9i4notK1MSP4YOQcak/z2N1vrjx8Tw+poUSBP8Pok9AqQVJqi17p/SNwoDrzZNGfLXd5G9JVaCyAuvRt9ZNmjpKqrYUm+ifUg5K9W2mC0VwVtnydYRnU4GDErqGq2cAsg6HcMmyeqYZNZLx/qskbQ5Kp9ZbKI38aM1SfsygMd1N31MqnCGO9FcJnchr5bgG7cXYB5U6Y3x1ATsPFxf/QJN5j8H732/2K51c4NXRId4eMccj+hPm44B0a39xN7lEezy6mdCXaonu+JbPTTGWT6JpjnXPRWVx7hPk8gAZkJ7qE6mt11o7enKuOlKwYf29mZhzLilAbk6vR7cFEjLqhYFq5E5s72OFfV7ikT6vf9IsjRjZ7pPHhvF/eFXD8+a7I/m6gMZIDG0fBWBmkZPv+DBjlNc6SBZMaZHEEsucCbW/FFMh+hufG1xahZfHxTnsXhnHcu3STcd639v5iP/FnGviQg+ZWjd8yfKSYzK6gqYa2nJZA9JYOMeH750QWRF0E71CQKxvs9CMdKi1MiPrmOgfbFcHBet0zohS9YrkDki4/0rAIQ9IVIb7uJWKZ7saMCXq48tKFynz+gGLIG0OpIlQ4E6phrzgblb4tOqEqBlLIyZpoh9FULiRZgbZ3YLjowmzs9gTkP6tF+8FGHQ97td+hFuTTF/9Vi1yhKW4aCR+7qNggoIVKlDr1JuvolL4ln5FUZkHV2iuB7Sr84Z+8W/74AZ5AIEokuosoiJQpXfBwqpmzT2AMCS8L5otL1ujtmTRrlzUzPkJ7i7CmNK+AMam6f3xAgWmHnL5WAv/zZuSMOyTLSj8Zgbtd3OBPTJvwxRvbapdxVVwgsfumwVxEM52Oz
 /UReSfCB
 bWQYROWxcDbbLcTXXkEPrqMsIx7E2oEqmNzmqUS9M818lMTQVNWbYfCdUDy6gdfSohlXltFsv2isL5rvOFnJOcTGAM70uPQwbTqBl/Cze3jH3X+wwyZ5vBnTSGAfSLdvPQBcOOddAnT7U9FCu+PEUIfozKMz/z2zp8sVxlBZdGJJTQ686PyaKzy6XNZXxEUcp1CZzSR3pGOTmO9n3jZ4uEOd0mI4pCxlG+iSL7ODmsX1zlfVDcFVL7rP9el7j1UNNPe2ZI7PKGIihCEoRJFuk6efAt6TF/pfxQE5j62VzMGCG4Sm7mblZ6jLMH8TYkY0Gm8W9nuu6odGX+gPKW3w5zmxJpcFyBszYsXzpnGjZw9bfDzsMntQt8CavMhU06wnyMCQANE3/JXfFVd02PJVVLuOb3wktMbgaed0L4SEZf/PuH3xY8wheYDf/0CgHaAb6qPNlH0et0xH3aNRN3gHMOxZBrd5XmA2NDaMBx0I7+sUD6uM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

is_range_mapped() uses getline() to read /proc/self/maps line by
line, but never frees the buffer it allocates. Every exit path
(parse failure, match found, or reaching EOF) returns without
calling free(line), leaking the buffer on each call. The function
is called multiple times in this test, so the leak accumulates
across calls.

Free line before returning.

Signed-off-by: Anshuman <anshumantewari123@gmail.com>
---
 tools/testing/selftests/mm/mremap_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 131d9d6db..779ef2d5f 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -156,6 +156,7 @@ static bool is_range_mapped(FILE *maps_fp, unsigned long start,
 		}
 	}
 
+	free(line);
 	return success;
 }
 
-- 
2.55.0


