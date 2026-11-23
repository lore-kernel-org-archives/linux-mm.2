Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D254606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uZ+RemnX
Received: by kanga.kvack.org (Postfix)
	id 997986B05C9; Mon, 23 Nov 2026 12:38:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96EF76B05CA; Mon, 23 Nov 2026 12:38:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885796B05CB; Mon, 23 Nov 2026 12:38:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0396B05C9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:38:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF777409B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:11 +0000 (UTC)
X-FDA: 85467092382.22.027F224
Received: from mail-dy2-f6.google.com (mail-dy2-f6.google.com [74.125.229.6])
	by imf14.hostedemail.com (Postfix) with ESMTP id BC0ED10000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uZ+RemnX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.6 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455489;
	b=oMPq5tW9hOZvyS8uE9c1yh6z7KbT/wJnvsfLwEjFgksa/Mj2zHn4RaQY1REbwngmE4ff7S
	GDteLubMFw1mqIN0XggznxrMuL5fdy8o6LyF9GqoO7xpavOoOQ4C6M9YRmtSQF9lG+F5e9
	Eau8cXKqWXWjjGg3ZlhFe6DQxj/uSZc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNprIaLuwx/PIfm0T+TSNXckbwgMyUXMskfrNB0wgSA=;
	b=afL1dnkZ3GAK9grjHKf0OCYrcw87qax8I8af9wvj2Myp7rj9VqIcRMhElJwnjPJhSeLjHE
	g3FbdPrCrq1FmAQeXg+FiT0vbOQQvtV7RrdUBWNje9vWmUgzjcfuw6CK526Hk3854g8y5C
	906Ca8n557tSAGsaL+f/8fwSS4xK7AM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uZ+RemnX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.6 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f6.google.com with SMTP id 5a478bee46e88-35adc681e1aso855990eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455488; x=1796060288; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UNprIaLuwx/PIfm0T+TSNXckbwgMyUXMskfrNB0wgSA=;
        b=uZ+RemnX/5tQLJ4KYMcVki3awDBw5Hbt5+rBSL+bPJQgM6GJU8Ne8d+3kxiFIsc7pO
         H+w+Z+/8WvI5g4Kc5KieGfEfrFMNoUXuzbojTmQv9WagOnUbLITttY9IsXkxuG5Exp9Y
         L/KpfK0Oaz+MHiuTF6x2pNp2ZT6E1C+//KGZXRTz+RxOkQp22Ei/osB0MPToQfV6AvTX
         QAJMAqcQuOBwPaBh5d/7dHdTLjabC64l5+oV5aaNTFL0TbHyUX1R9T0y4NNza5tbEAaZ
         y0ydg+8GBWJGD0XLDt2FHHr8Ij/GF+4MnxdlID0didotfzr/FHXfNaXfN7Nyh8Ecu3oL
         ucVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455488; x=1796060288;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UNprIaLuwx/PIfm0T+TSNXckbwgMyUXMskfrNB0wgSA=;
        b=MASQFqGAB5dpc+At8+vfzBURcQoqd/0jLPWefAgmGSQ/oyhJlzaWaj2FAa+izdgz0L
         QeyWS1jGUDvCXZxymF+4nGbYeLPkHOr11PxukL5LRoG23T6uX+xbU3lrokN4M4o8IU1s
         PbCZ0p9VEfNSvlsdN8r7+DhPnGDcYXnSlzW1bCG1FUmJOdhWCoR5rfIHJjrhcbhsF9mR
         4qkioOpk2p5zyZkzmTR4vxcXCnUU2rvT+YjiaoZFWfoBzvM6N67Cg9GXwWqDuSX9eg+C
         jJsyftIJ19vqSiAgnQkl1naIh7hodJkNB+mitqujKH/axwUhNcN1/ZJ0fwB5zH60q/sP
         W4Zg==
X-Forwarded-Encrypted: i=1; AL+hErE/iysmFbF2URylMq/sL5tOkT+/0yqn4ntEEEosWRWBZZEzWH9cZK19kIbEo1AerjbUiKBwwqfvBA==@kvack.org
X-Gm-Message-State: APuU4Z9kGy77fGhPH0Kh2WLL1c3uLjoE+cyfbe/m2EfmCEDxvn+ybinh
	XUZTk3UYNykgeglDWC5y7bGuB2YNrDJIN76YGHLnRC0S3RhlxYpPFjkv
X-Gm-Gg: AZFdTZfsK3TP8P5nUicqHIBdO5X58m+unb6zGE/1VCDX1UdSGNq5ko97iefs5gQhrRk
	82LflG1l3QBkXLKNa18OwWvtdj8idzMIbhQSmILYzBO9qayNa5ld/WF7aBK2GogOCJc1le0EyHY
	O46GtkZlQBs2TIr8KDKLn7ArVzA3Qa2ZUwmcCmIUOX+xmVZOkOkWKhf2vorNqKzU6Dsb/urXvJK
	plZSF3Bx/irBiLBKzYpT/NH2zAB+sCN57L4hXZJFfQedpdcapTkgim2H7FV3ifLe5rKU864IRFj
	VEbwYzrkxkyWiSQLqL0g8T8QqDbLBS9fQartkXt/scbujyxGTlqFqG3Wea1LvPcDHcNq7SXc26b
	dVB4/HV67GKPNsNBw3IhSH5Yv+RIj3ZWHMGoswXlDRKA94RDB3zMtzJR4PZaeN0FChj7O8+2oaj
	J61hpsJ2pzP1NcXt7nhC0FbsRkFLO4pEnyrnzpHID5Mqc1K5F5P+sD5mE9SeegaDQUxbEYPG2Ys
	zh8t5ZxeD09wuXDQCNULT9IyawM2QXPu5EPj3o6g4eDMnVeaN5ZAAtwbj2RBR6Aq+qW9HMpLsrp
	8dFwXNgFjQV90xEMhPVTM6gMF8bij+MKr2RRw7DXXcnCp1fG3Gfbeq1yyfb24nQ2ZCKW/JgmnXa
	HajISqjYEwYusw0FQWZ2HHm/h02VErR6umB6/cu01Lnsqprq2t+9Sig2ule6b/g==
X-Received: by 2002:a05:7301:18aa:b0:386:a0cc:b97d with SMTP id 5a478bee46e88-386a0ccbd2fmr7820717eec.4.1795455488491;
        Mon, 23 Nov 2026 09:38:08 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:38:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 20/27] mm/damon/api: introduce user_report report type
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:25 +1100
Message-Id: <179545256509.4.13193548537304229599.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-21-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-21-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: 6mqn64tqzbwxgb48ihnw87i3wiew376d
X-Rspamd-Queue-Id: BC0ED10000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795455489-438130
X-HE-Meta: U2FsdGVkX1+jny0sQxa1MJqGCpzbkqgB/1/wyei9/FwwjoQnpDKm6epwcSMPLO/9+zWWiUfWFyvrra043NUFCQjxJHHkVNa35Vmiu42PQJSKUtvXXGWvaI106EZGqngWOVXBVjSvz/z5Rw1GkM9Ezes463IdnuV0eECd/U6dktgz5DRfnuokFZtNHZn0SZJXr3dy0PnRXYDgtAVT6WRY0MumAsAzYLvdLZbgWPT27iUAeSeb5PxvajH4mIGmkF0DZi4wA0Fv6ZIhKKY2Xiw/4Nw9BGK8dOE7Uj0itL6Npk2hFw9jCGckcblYZdexUpcKOWzVsOgY4tjwXBc4a/zeL/hU28fL2bTyMXZJd+hJlkBf11dgSxK9am6wlgPdl41QinIn4+25+YRzzuGdoRhbAB2w/0xBBMNwTUu7qAbBhfZJEijEBLID+WM4vQudo/PeN9tEWtvNF7wU5jADe8FzmY+HrY2O6BLuAG+xTLna+sbATvCtCtsk76oabg5QZ6sI4Ii/cvTi2idNDRWYSNsoU9ARm+1+bewjGSqW4LelZ1VWByucwmYBhz1cOzEuPvyQgQ1yjY2VSG+NzxmjWZ9UzJAADYe46jGopJVMllStJjpGz6l5MYeZ4m+KbZLSsvYL4NIhVA7wMv5K5XsLZHw8KvwD1Mke6XpjdCR6Rtznl+m6MnLd3E9WMEVaTh0QiUq5mCJGrTF0JIEnfe5lPA1Y/f/1woY6cv2m6VPx/gtcJzuY/NwyeKH0qPYYQcCOLymD3/yljrYCWvRFhBpCg7emOGiu5qG+F+qRn8rqJrIEVxTdLf4EKNbAh4oXUFxN/zDrXD8wJFE9U3P0Qx+McBDstg8OQ10YdQ/3Lo/kej8vjFonj0sAfNnXDlrmUv/vW+tDGMzgDBQSdYybQiH2DypaJagGCO0ghIPoIEq6oZA70jdEhCIvrG82vEIsIiYEt6V1W20JgFliBXCliRmSJFN
 +STJAz6e
 nr/D7kz9ZqoS/b1L/PZ5jKnMWkb5QM14YyeOXvifHT3CLwEhVvJd1HTterKg9YWx5ym7kaRYzkYfW/7i52+i1gMoAABmBvBydWc8yA7YhOsBzRbILuLJLgxjFTbWWqh2BCrUks4cLjhl02R7nLS8pU2MmELm7XqFrO65UNhOKHVa9CCMxbufFqJJ9SdbLSMTd21tvkI18Vep+HWjcB+Sjqt4PcahiDtD2SxbsspTG8h7znQSqf148V+zSdqaEhILKkRJFvLvZvI958mTW+pfas1Ys22KGU4QipqNbx/j7rifYoSODOhJVUZmuaOOpMWvJ3ycI7j7c5E0cJWJQ+ehmabyZh1aeU9raRwr8BuX8v5dQ3AwGkKKRQeHB2LbXvOJkIXNjhgSdoo9VBQl3NEU3+6uklIUu54gEUUddE/Y8Jb6FYmPZOipmSOatEHTXBvqvNbcGC+bguThboZ9MC5rLsVLr2Lm/QG9l6UgoCNyxMqNLyavvnit5gNIXXzxTeBxLTTNVAkJH4XdvpN2QaDzJSpMZjs392Wv36RZvpvwrLeHdr/z+VosqGgC7t3ipv63zfbgxubUGaRbkliq8obPehu8UiAUHnVz82NTuMXGkaFF7W7BKsnnH8CYhSrqP2NbFlyXv8hCaxMncw8h6F83Ohqqn78Z6MKTLQU5hOExtaFz1xS6LL/DYHvg1g2uxuLu2fZaU4v/Ge1BmzET+QND7Y05iKW00DWLCS++lBzhyavIQpLeeL8uPKnk58UJ/bfjEnemtNcRZDOjw4bFc8LA6Zbw20dkkhTA2t6cHkRd2QZ9yysY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 13:00:04 -0800 SJ Park wrote:

> Users could know some data attribute information and willing to provide
> that to DAMON.  Introduce a new damon_report_type,
> DAMON_REPORT_TYPE_USER_REPORT, for such user-provided reports.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

