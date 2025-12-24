Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 334ECE7490C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 04:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35D316B0005; Tue, 23 Dec 2025 23:22:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30B856B0088; Tue, 23 Dec 2025 23:22:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2173A6B008A; Tue, 23 Dec 2025 23:22:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0CDC26B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:22:18 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A51CC1405DF
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:22:17 +0000 (UTC)
X-FDA: 84253067514.29.05BF24B
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id E5C391A000A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:22:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QZB4ecCq;
	spf=pass (imf19.hostedemail.com: domain of shu17az@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=shu17az@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766550136; a=rsa-sha256;
	cv=none;
	b=GizLGYBaYs4ePkuOry1qbflPca8Zojm0HBD6qqjJmANP6G8sJAQRnDZNC/a5wCQqV7roPw
	JnavUGc/m8v/dF9iwBW5/cQQOLF3A7oZhSG9qOP6ElhPPoqBCS0P/BhzGB+ttEq0A2SxRI
	NEZg6O7YXJEtfhnq65NvgyQzsf0vBGk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QZB4ecCq;
	spf=pass (imf19.hostedemail.com: domain of shu17az@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=shu17az@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766550136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+TGrPuT2v1cZj1mmHtKJ1nXyGxXS49Cs2xA/DQGK74o=;
	b=3HZbj8Ng0Z6ba3wCTiZ68ze3QMLfQy7uXvo+KrDAuNRrSERjbHFZpPAJDQz/rFHkaLFyuk
	FCCDa5vYg2ry6TIpWyHQoIpSK7OHyPlvyTFJJf5WahkLINMUdreiV65s9/OdFifw8pdb/O
	uKGgouTgve11QMD2gSoieEuD7ARjmag=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso3676008a12.3
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766550135; x=1767154935; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+TGrPuT2v1cZj1mmHtKJ1nXyGxXS49Cs2xA/DQGK74o=;
        b=QZB4ecCqt7TM9xhCTqmD3iCGTr3gztVel6Sc6LS9m2M8AejwyuotexmYwKGr194r+K
         KtWk3YIqn3X6EgaByNwJmbZAjFEF+3YDj1AkstN/JaueoZ+peVrN1TuefebICbLxEInS
         y0Y3umFo8EQF0foMNFHuF+6j1rYhv/F7XL6bQkUQsGjjAvpkMAR3P3BCAOC/4v/P9PN/
         wU8EZjwF7wDBQ0vxpVHK4O3whdiwkmoXLviQS0AmKeymnFz7r5QBU7CPSn1d7oriJ6xp
         yubCFZ+7DHA3qeIzxYbCIWS+SO1ufOnn3IkUzCfdeGV2TmWQ11mFFto+cZmlOH/dujuw
         36Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766550135; x=1767154935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+TGrPuT2v1cZj1mmHtKJ1nXyGxXS49Cs2xA/DQGK74o=;
        b=McNJzb799KNm6ouaoABL/Q0t56oKcBr3eYyWY6H/TIH+91VfRMw4lMmxsojWv5Eihm
         G4KwymcKtYRZQsi8wyBl+gJ1JqN7+q6X8qdNXdBCrVQt+Atv0+E2h9vsRlcGWx1RSsJ9
         mh7PeUCCLA7fGSOBzpeb3HSkzkShzlSb/Z62/jjNXI7OniGgNNPVzxk8xp30fEvhdhoT
         ipiw03smV4W3R23VUbKzdO1FUvrbXmQKojpzM0t68IPlUUXhwjEw6Kc4qXJDaZsjvo9Y
         ZH4hPVsunuWZ7CbEDBdpZIyexrkH0PnzTAkwP7+nFgwplB3b6hz5v7e3C9XeWfqBoDlf
         LsJQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9MJgyfvmHvR8zmfNQvQw1DA4lallXAaLiaL3sFYh2ZnfKo9Q8Xb2+1WYLvDyBPD7kRNMptedVqQ==@kvack.org
X-Gm-Message-State: AOJu0YwhQQhM4T2NaQBIWC+MG2JQz+J7Xm1Xypkne45w2ESf9aVnBiDF
	RrqJlqsApthxTwJJKJtNMaGx9sF6oXaikg7pc2/kDWByX4GzSqaEdjU+
X-Gm-Gg: AY/fxX4dfUoXX7IbaEDnRkBuyLf8VjzLuYhlQ33CFYnbqk6kA9Np4+KQcF4ccFTn7Td
	CbuoU8GWvIB+VXM1HKQT3wO5V/bkplBJQTNaYvCVr+ryTwi8Km1ZyyYcxCjLuNUZK7dQ5gCn7jM
	DWpwpi6KNBsyRFGDyTn4S9lGp47xcbMlyc9WmWiZK213a3UPH3KQ0owfXNgKAsYz4hGeEs/k7B6
	sWiJCqRb1CQM5aaZDVhs1OzocCdiYHdMLORrq9KFE3zQ2+Za2UQfbY/V8roTWvRl4wPG16BN1+Q
	We/jCXElwVcJnnDeRerSfv+3YbHhMbIIAwEWPSw79OPlNSxf3qsp5rGNTzV0QDYGmReSaKaB8ec
	Z/+Hsz7lD3xNfAAh0PfsNnMOBSP88lSbGflHmuzgZ3aqR1sIEwNdrx6s7GEMDgGNs8GxDfTMxd5
	oy
X-Google-Smtp-Source: AGHT+IHOv+s1tLvmzhpsyvu7LJTsUAsXFw9q7TcmS1xRa6GeikBeK5vKJ0t6dCFNR8dYeCrV/OJTzw==
X-Received: by 2002:a05:7022:1719:b0:119:e569:f609 with SMTP id a92af1059eb24-121721ababfmr11396994c88.2.1766550134622;
        Tue, 23 Dec 2025 20:22:14 -0800 (PST)
Received: from dev.. ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724de268sm48542031c88.8.2025.12.23.20.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 20:22:14 -0800 (PST)
From: Shu Anzai <shu17az@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Shu Anzai <shu17az@gmail.com>
Subject: [PATCH v2 0/5] mm/damon/tests/core-kunit: extend existing test scenarios
Date: Wed, 24 Dec 2025 04:21:55 +0000
Message-ID: <20251224042200.2061847-1-shu17az@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E5C391A000A
X-Rspamd-Server: rspam04
X-Stat-Signature: whqx5hmrz41tyctwxwmrmjp1gacrix87
X-HE-Tag: 1766550135-445833
X-HE-Meta: U2FsdGVkX19sHky+1UVhyYnIF7t9ZMZADcqI1bi1bYk9ZKsAjoLuCTcOBL38hpjgYgTiyk6k4c5M36v/1+UYg/p6VikIdUIg0JaGv0yiE32lpK/BHnQSAjNb2Rh4vlEVgRBGV/I+ERKdx3NP2q89oTZkRwnFc/j7dR11EcOb/iuZkjOsCBXuZzJsoYwXyOpHDY0OdjFa7yxzLxzNmn7P2NjkvILOz7vUeZ06mTb7T/KYYNpHk8htlePEoQNVoLhgcN5eUAvL2OVQv8xWvthjem9VtzCZy0cP1dQoGQXE8PgS+cZhsZ2QXqtYh6tWEEcxzGtdFCfuEX69jt71DDgA4Vb7MzfxiwVSTqBgLxG7a6/CnNWba+D2uPRR6CNsGstuXNLdM78rtumCz7rQ5UzJhO9Y2ojx6QBWf4Um7xg3/tWqhd2wz6BITUFnUv306u6seX02OHFhHhVN8pMm3JwD3A9B9f3lS8NBUl3YKdCzGA4ybE3hg8nJR9ttcBRYnot0hoY9zzA3rwhDM/E7Cf2ja9U9b5aHUFOd2LPFEHmRao5dHF7IGLTET8FOtU7CczbWqniN977Tt+2ZKiJ8Lc3RUZU6iizHcYa/05AXNtmWKLSerS/y2LovEttPRUBeudw4iZOMPCjrfQVipvxwtOFQGJejcvZIIt20eKPffXwmfv5uAOi9B4+EQ/qQP9SAXPzpx2mwLRaUbF2iv8DR2AkNRgIHNKqEv8qdp6+eFAy30Ruai0QQ66QTp2lenzrkFCiNYeGITYGtTULqsyT6eAavQ1YUQ3tD+JaRi1E8Y398Al5UMkEh+FhDH0ELgTaxdnuyeA97OU85H1YVf+4GFrhAo4NHmFshL3ff+f5SY6F5sXLtklArI2cs+VtIJleaIjzqLKGCPEU/uGzjzjPxpC5knO4edXZ7moBcpfBOYB2sFlvUm3IDW36iQWZkIUHfyRgLY65LsB9aWP4+upUVc1B
 8qE7l7R7
 r5Xm1bL5xVTK4N0Vg/wLN7sP0fhZSuoRHl/I2DkUM/iSrZkSAnEGw46KyN5UUaLhL6yZbsVZKPYWJVnKVol4UurzZfw+QJUV7W5nwN87mlKp5JyM2Nj7AYGoNqIj8S3XfkU6iwhMYpAR6y1QDYRuHxlsI47AFJp85R5Iz3l/PfgBq/gdTONj6sGZRSjPF5E2v9rzIrMF3owLCo8x7sVtBndZDg6Ergb2kQYo4TCllZ/AHWHXrVo0Xlgd9tff7DbczDEK6aWacwRFb4gB5oTc9P3cQ7qgbKWAtEMUE+P/YSuRB9+cgAZHMb+DflSLciboiWFGrnpYCfks9mYZAIw77sHg3RC9dWV5Gy5FeTAspnelpIp9PVhZfpovS2SoYLFWXcDGy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Improve the KUnit test coverage for DAMON. 

The five patches in this series respectively extend damon_test_split_at(), 
damon_test_merge_two(), damon_test_merge_regions_of(), 
damon_test_split_regions_of(), and damos_test_commit_quota_goal().

Changes from v1:
- Split the original patch into five smaller patches.
- Remove a newly added region from damon_test_merge_regions_of() 
  to avoid an obvious test case.
- Restore the test case in damon_test_split_regions_of() 
  that was previously removed.

Shu Anzai (5):
  mm/damon/tests/core-kunit: verify the 'age' field in
    damon_test_split_at()
  mm/damon/tests/core-kunit: verify the 'age' and 'nr_accesses_bp'
    fields in damon_test_merge_two()
  mm/damon/tests/core-kunit: add a test case for region merge size limit
    in damon_test_merge_regions_of()
  mm/damon/tests/core-kunit: add test cases for multiple regions in
    damon_test_split_regions_of()
  mm/damon/tests/core-kunit: remove a redundant test case and add a new
    test case in damos_test_commit_quota_goal()

 mm/damon/tests/core-kunit.h | 50 +++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 11 deletions(-)

-- 
2.43.0


