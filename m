Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09AAD606A934
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cZGW9aS5
Received: by kanga.kvack.org (Postfix)
	id 28D906B05B4; Mon, 26 Oct 2026 07:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217066B05B5; Mon, 26 Oct 2026 07:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DEF16B05B6; Mon, 26 Oct 2026 07:16:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE2D96B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:16:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E2A716073A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:16:27 +0000 (UTC)
X-FDA: 85364524014.09.646BE10
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	by imf23.hostedemail.com (Postfix) with ESMTP id C110014000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:16:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cZGW9aS5;
	spf=pass (imf23.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793013385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8rYpsphUHQN5o3M8ULTGHPBVlkOicoYy0qDzZu7+FCs=;
	b=WHWR97T8EgQNNvMahT8To9LP/plPm7UFqtIBjqDG8vfJa6pR/ro1+wPR/aAC9abyKSF35s
	ZsjFzZdcYdKTW+61g8h1UpNgqsvOR259hJPM4u5euE3CroN7wvn6yPn19KtXWxYJou8vEQ
	Le2Z1UWzRcDWgIE1rio6wxHjvJk/8BE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cZGW9aS5;
	spf=pass (imf23.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793013385;
	b=Z8wtfvcSy4tlmB7bfKjBrP6PnMssy1k9rWmBuWiHtepke+qOrXkqlU/iJe+VX7bOureKGa
	id/KQZGckC+zSDfbLK7Da53JcK+hO8GTngD9wWEVvkFItdm0X/SkvHrlRV9xyhmDylczqK
	CobCnwENmswZQNvP9V/MiyY8SmBa3nE=
Received: by mail-pj2-f7.google.com with SMTP id 98e67ed59e1d1-3ac63aee1ecso508660a91.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793013384; x=1793618184; darn=kvack.org;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8rYpsphUHQN5o3M8ULTGHPBVlkOicoYy0qDzZu7+FCs=;
        b=cZGW9aS5jsFknwD4LypIAXj9wn1RnafUWntj8sSgxwiJagStZtcQA4apXczl1gKVQk
         EQOQgIn0/Ogu2n0DSx4C2isBZnWp/MJ4fQvHJDAdToIsNB7PZLrzlwN7zDefrhQAMNrw
         DcUNzvn3au1zesY1hOV9EFw3v8dRYrOlT34YfeAT9wKaBcvYDw3CmCOLHjSmrQzqrQkS
         hV4dLx4vdEz1qnMmkZqffMc6Bb6oY1kyYg2eLtQe4WR8FiOkNsJ5M/M0k2AL+Eeb1nVl
         psab+uTZGWRWQpMcbC2rFePukdCAMSucxOObuUiARuJOWu3vGMS+p1Ohw3QT0g8IAiwQ
         h5Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793013384; x=1793618184;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8rYpsphUHQN5o3M8ULTGHPBVlkOicoYy0qDzZu7+FCs=;
        b=LooemNv1hbtP7tD7bUTh447SPi/aGma4GfeUN7UNlcHKx3UJ3v0UhG1ZYiwVcCUiIV
         c+aPgMk8GCcNzuCfTbIePfWf7njJQqT7Plb/7Yqv53BOIiPAB7kGPMheQV6MYG1CcwQk
         Te9S99hDMdsw4v65jBpDz2wBgsKYsASXhqIP6Ja5sIzXMYJ10hllhksSvGkpPk4XrMWJ
         dN/CYhLVwZk1n1B4XwrzlfsucjUYkAaHjjoJkojWUdPERmkzGCpN0xh4ii0YmORbHFXq
         KL+1reByZpucJhCtrCR6w+6CfMxt9gvm7/jlEhzLmYCG4CM7IvMns2kc9W7IUKJGgopU
         lbyw==
X-Forwarded-Encrypted: i=1; AKwUvByL0zLNW430kIMO61nCqdAySU0BKow/rQX5h1hz3nciOr6KFp2zEcGhq07ruTIrTQq/ifOgAtDK6Q==@kvack.org
X-Gm-Message-State: AFq9FYJkXkkqxO+x9xPpMkLXH4Yl3Y9Q1gSxqYRr0qNjgEKPbYbG8gps
	5PVBFEFN+1QD9HuBEOaedU4EGH2kwr5TLcEOBlJXPdohS2IoUBxqDJ0R
X-Gm-Gg: AYBFou3VARhUYhFtPEYYQu4nU1/J8eVx7Gbgz7UeUXO9a9IRVq5n3xZZwTldcRx9aHK
	tiyFtcGQLOOjENHpXAoUP7wCmINvbepyxAtEUVbK4q8Bn+gl3G+2MM7YmpqVRjNA+yQ7+VDFGT3
	5Q7QbKA1WaJ1KZy80A6zyFDU5kzJj2T8B9ZhT9kMmQTkO10SQeNuj+0lKDB2I7TAQ9y8p/IRWEJ
	UkS1leiybKHbEXPmhN0DhRG3lYocqgR4PDm2Ju3QwZi8xZlBOsyV5eRddUDPk2/fovQgCa7yAF8
	4WWGzUwXiAXuLBGtBeUxZLTD1gvR1SerI0n+NV89s0RdhEwAAJt3xfSo+AmHpLV31lzOm7YI9tj
	2GtQHVYlC7mt2tWCWRHL/sy2LuqhtiXYR32Ih2CVgNHifF3U9HHe3hRfI6lnIcjPDapaOhHZLu1
	szbwbcOelWEUwt6+W/5t6tt2C5Z4QvW6Lgvx5BCTtihtdr1wnc5lON1U+KGr6+1k/73S0grMZX8
	1YegqcvJOLYp0xm6SKJygmikbQ/uOSb28axGbMMHCzcIibXxx/Wszpwa4ybGdS5sqpwxt7MH3wK
	YXsaICTgTM+ISIydQNnqYT0tIJAKZh5sqPlrNIF2XZAkruDV2GtUNw==
X-Received: by 2002:a17:90a:b896:b0:3ab:b39f:41c8 with SMTP id 98e67ed59e1d1-3adead4dce8mr3439038a91.46.1793013384321;
        Mon, 26 Oct 2026 04:16:24 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ccc90d74sm1382169a12.20.2026.10.26.04.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:16:24 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Manuel Ebner <manuelebnerli@mailbox.org>,
 damon@lists.linux.dev,
 linux-mm@kvack.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] Docs: damon: fix grammar and typos
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 26 Oct 2026 22:14:32 +1100
Message-ID: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C110014000A
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: n8bm5ezqo5rrcj48kscjif64ao3nh8mj
X-HE-Tag: 1793013385-460901
X-HE-Meta: U2FsdGVkX1+DKfKUsI0OxirerAjncHX1+FqUQpj01XgOyJgCgV+z47p/kkk4jbh03kfImIkfn/eaMiusgT2ydVmIC5bU/MaTVkKpoVbGZ1d5tEqGqQK3MlkEZjvwYKEmEkv0EnOHwwCW0H4WHmuRkewWKDkDdqUH0C0gCttA5Efs0lq0QUSSV8H6MvjH9H09tsUrgCOHd3ru47zcBkvmZEkmN3s2FACKm5eqmneUPkdjwI2HT4xCH7teTRb3BxhyBlAsQpL41PB/nfZ1XJyHWmo2BGWDoD+q50rLc0vIZ+/jDvNfQR+WmL2TN5TYCCsSYEQLoLZBemk8XhIgXYyMK1g6QXbpwWBJwPrcwyPEOhcUI8QkBolJyfA4SlOtUL0fXg77hGPwk9hwBGb035oK+fpHkqRoss+qmUjMq8Fo7TMxi1JZK13KHB6Xx6PAqKtOP/9NxAflyo5RsP2bEw5WIVU/EnFuEkuaeRxyIKfNqL8N/xgNDaoG/ZVuGHdpe5YVgJbrHVfWACapCyLrjRgvO8muXKp4xkL9dfeVG03dTrqk4HYjOxCgutEcf1URXWZh2/m8+yajMhqxD29sXtywugqVSDlmWABF6M7yq1KFW8qq8LU0l+OwgGJ/DML7pmVRK4nCKaahCy7dSGozfY8WYkSbtvmNd3O2rsHSt7BmhdgQRLo7+EijtxPH2+uyJMrnlG5akg8R9nUZIF5Zw1bq9tliU2PFJ9kAX62XEhF2nhzb2LK1ACrVkPJNbQFOA/nNAYabdto2EZgN1jonyyKsychU3u7DP04jMEKRlqEgSZxQCgcUdkpicWQGCqOJcVIxXe8CqsnlyOHFHiu87r19RRVhluoJSGxQXGrO9PEAbyeYmNksWuVYbnOFT0TC7gQujs8R8l/j3N4mRRfmnCgnoy0ifv89VnTKaCb4Ir4R/1cAV2diQCCQdbSax4U5jxtlFwb9qjjzAnoj290d8Kw
 oh04lOQ7
 F+2b3/EXN4ORyse0c6nGJXvL2ZJ3bMFBJYktFrMtWgo9lrZuio/ddgZ+1WCN0LbphzVoxnZ18XkN3bT90VycCtL52ptyNM9XNpJBN5kU+qbtkblIdKGbHmemz1P6qGWUzF5Az7o2/mqKxxyDWaNiPObc9Z/ZBa48QGG4e+UcSuAJERKUbpO7Cf8fwl3U0/Obdp/VXtZfTZwhX7yAGkE1CvgN+z0stTwLbaohwiiH6ECM3E7R2l3qXur5iuWPZVUQy3gkGId2QhAVd6zj2uM/SLjSzw/YfeQsqJmv9/S2mvX5tdRcPLaIu2wiRwe41IjUlvg8KKRAswHOzfZhIVHBdQETycwAVUGOR/OUW5P/mUV56XXly/mPA/prDVLdEyZM/WgXJXDcPgtmEinCT/30sWiDCBvhs+kYixziX9Xb5gV0pZgr3efsN4ov7OHtUevma0DW8FzXZWt9OxSl1zVzil0/G2TipQ5WaUfZJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I was reading the DAMON docs and kept running into small grammar
mistakes and typos, so here is a series that tries to clean them up.
There is one patch per document, and nothing beyond grammar was
changed :)

Some fixes pushed lines over 80 columns, so those paragraphs are
rewrapped.  Patch 4 picks up what I think was left in lru_sort.rst
after Manuel's recent fix.

Based on damon/next at 9d301805e3f6.

Thanks,
Aveline Noir

Aveline Noir (8):
  Docs/admin-guide/mm/damon/start: fix grammar
  Docs/admin-guide/mm/damon/stat: fix pronoun agreement
  Docs/admin-guide/mm/damon/usage: fix grammar
  Docs/admin-guide/mm/damon/lru_sort: fix remaining grammar
  Docs/mm/damon/design: fix grammar and typos
  Docs/mm/damon/api: fix verb form
  Docs/mm/damon/maintainer-profile: fix subject-verb agreement
  Docs/mm/damon/monitoring_intervals_tuning_example: fix grammar and typos

 .../admin-guide/mm/damon/lru_sort.rst         |  45 ++++----
 Documentation/admin-guide/mm/damon/start.rst  |  10 +-
 Documentation/admin-guide/mm/damon/stat.rst   |   8 +-
 Documentation/admin-guide/mm/damon/usage.rst  |  31 ++---
 Documentation/mm/damon/api.rst                |   2 +-
 Documentation/mm/damon/design.rst             | 108 +++++++++---------
 Documentation/mm/damon/maintainer-profile.rst |   2 +-
 .../monitoring_intervals_tuning_example.rst   |  28 ++---
 8 files changed, 118 insertions(+), 116 deletions(-)

