Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E05FE784AC
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 01:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757F56B0088; Wed, 24 Dec 2025 20:54:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FEE6B0089; Wed, 24 Dec 2025 20:54:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 665EB6B008A; Wed, 24 Dec 2025 20:54:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 580986B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 20:54:57 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0260D5914C
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 01:54:56 +0000 (UTC)
X-FDA: 84256325034.04.5D01CEB
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4AF3A180009
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 01:54:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cbElRjhf;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766627695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Vtr0f/ctbPwJTaxnMo8RDMm0e3evaE0tCuhz9AWi7I4=;
	b=ZKZkcrtFjL4f+MU+dZ9OxMiCQNFdBMvGc8Rq6eYhaEd0a+YhCG9mt2dmMneO671Ey9WQYk
	zHxGx9E3yINj/O1DcX50daE2UBm5Uh+ODdvY5r4iz4kxeCqo1fDjHLqdaajXTHs1s4r2fk
	4ziAL7m95KsC48NE19m2ZmEmrcJAmK4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cbElRjhf;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766627695; a=rsa-sha256;
	cv=none;
	b=ZGHoS0Or3UvmdaYiU6u3iGnx7UEhaj7KuyoJO51/8bMI9hur9zxkneWOKx2XIpTCjrd1s4
	ZFMaM6Tcl1AgIyLrsJw0KV0GUW/QWyBk0zvaO/2AUo7hihaZ63tcUTlPwXt/OsjfykiOhO
	GwQ+CdCefyI/Ayb2fc1rLQn7weIeoeE=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64b8123c333so9188223a12.3
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766627694; x=1767232494; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vtr0f/ctbPwJTaxnMo8RDMm0e3evaE0tCuhz9AWi7I4=;
        b=cbElRjhfH8Bss8bs9XTGBpfck0bc7AhGifEbcnTzXswbuUK//alfe1PcYyf3+NxMQ2
         0k1zFWRFYGF2ry4l1I+oVchZsJj6P26Mx1lOiEUYK//YtNKxUGIGPfLY8yQmGcMUnbYo
         40Ku5tSIOnTdoh7jwyZG/7CS7z2jXLIaIUXtepZ6WD3S1qtFsLwhdcHe+oyQ0JiLmqAL
         MmM+v84aLRgQHtY/ba0mIpOsugXIy5phoJ12lKjL8MQ/SjTqgHSQPH9oT66JkWQqv4LZ
         pEEx7NHNydX+MDAO+/HpBluPA09i09urIMIzxuWUH9XjeKHcwn4lNNhlX7PBm5l8ETl3
         YbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766627694; x=1767232494;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vtr0f/ctbPwJTaxnMo8RDMm0e3evaE0tCuhz9AWi7I4=;
        b=sDLWHn74K/fzCrmGspqE1vrn5nrfJOkdJ7oYqqwacs5LE94anRfGdgKnpYhFk/kH5C
         /3+UlzAPT5NKWrfIyLFHWk1MenK+sB9Tj4iCeWAVMdXlxxqUjcWclTxKerxFsOzXgAWB
         vTciKt0zoLMoWk6ImZ3XSisZRmG4HXJPQUOQG2lWBaYwQnb1IfU/HpCJRDMrvnuMcaFA
         HhO7p3ZsIXNY9++WJcHyR8wP4kEDMhoD+cG9a8BPZK+Re7DB/wP3HCUT7oU14/gOpTXz
         Fo5f+A3YWLr97iEVxCuygAzy9J88pqLF4tscv8eNW+B20/cSqyGIiO6jbohRCaESuWF3
         vs9A==
X-Gm-Message-State: AOJu0Yyw6woodaATULjcPiFVMHM1wkh0myxPU7QUOT3GgGAz1x5Cz1uo
	TJMqH+0iXz4wHQ8Nbx1tXPxVClj0lNx05qQvwjD7NSpovPCgXJL+umW/
X-Gm-Gg: AY/fxX5mo5zd5TxvaS286xWTPR/N0df7F36z9wuKZUWmanqSCeskfQk5BIgjI44o4N4
	gWKqAwBUTFh7AnVPO/kTnHK+GgQnw2yIBbubmoohN7+WdTMyEsBZp/jtgx1NA9qDisJIXbKGE1k
	AABen5pAEUZ9U0eZoU4BS0EhKBHB9+HKfKUr7vUwyaDw/VzsR7Xxdg0l22kmwDh9e36A8YK86WH
	lQtfk+9DFOQkDMz5r3r6aK7FVscLMYiEE88n+bSZtEh++xOvB6AbKOUJcjd8xjYcaTGl66KQiEz
	ejV73/2hbgkr2N70gzrHxVBhAJd7NUOglKtRYJ1gHipDWlovKk/8KnEPCMr4idL/1j/zUCHaNE2
	7dGdi0In7dy0h+TfecOnnNY6Ao+dron+D0bMFPUUb9ufd2P9zezalgCokWpPd3zcJPuoSE+9B26
	ebn0eEbwIb5w==
X-Google-Smtp-Source: AGHT+IH2uqxK8FPC2TjvHZS4a00Fjw7WNr/wSB8VUTrTHYLw7jbZL3zsm1y92BF2L6wq11ADffC5Cw==
X-Received: by 2002:a17:907:1caa:b0:b77:1b03:66a1 with SMTP id a640c23a62f3a-b80371756c1mr2152407966b.41.1766627693392;
        Wed, 24 Dec 2025 17:54:53 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037ad8577sm1931933366b.24.2025.12.24.17.54.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Dec 2025 17:54:53 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] mm: remove unused function inc_node_state()
Date: Thu, 25 Dec 2025 01:54:45 +0000
Message-Id: <20251225015445.16727-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4AF3A180009
X-Stat-Signature: 8bcj1ik7icbm6cfgfdqhm9fgk7ssc7qc
X-HE-Tag: 1766627695-143934
X-HE-Meta: U2FsdGVkX1/H+73jmjFVF3O559jueKIW1BirxAXzjUn6GDFTnqOePmji8uxXzJb7I62VYIQMq2apU1y7CDp2TeGGcOAlmVpWoVvMa3ervtgjw8UGOFRGx//IS7txRfx2Q5zbjlKWf9W+nHIpeJnpJeEH0IEnd3cvkbFHAz2vS3SzM4ZZpQgboTIaZ3cBuNbOfqG1ZIKb6hq2KWb7pQAaxUz5F+gwfSEPtdSb68DunqfjC2CiIJcMn5LCZ4gHnSokr8PSUOefhGT/geP5J9QsCWIFta6Owu54dIVz/zYcQOhMzX0K9e31uBtt2PZjgGLEnbz6lYEbsm4ViQnHCL1TIskOPB8n3ABlV4ZVNUqkYWd4b/YMwW+M4f1gXv6oMtp4DTiqTm9YBggTKcsHFbJJOHAlAO86t2JfYvccO8MCIqoXXPEpwcX+GB+agTtdR8scr2EiCBI0r3SbvWHA2AxdZjm5S2UvP/OppOxKr57qZLnQ00lovuaNNeuzx6DZn4TgzbcgewTkxiTD4JMMNvW1/NOFakHaigEc5drm9vjsCHaaukn5ofcp3n+FlOvJdB7Wt+LFlhJhrGcosZk7Ql6Fe1lOQ7OUs+7k1frb6oWHinIVZrfKbJloeCCwq8XiNdn5t+PlLAs8zR+Yse5kJVeFPrBjDo2J+ShT4n+19BV3EdnG6o78EKg7i7wpfUbHk+BSH7t/DD4RggM6280ZOzkcTN5M3hlp8ucSsFDaT3pn3+q9GPsR1m1NLKasLNZmdf+l7QpwYA4lPkoy143aTT24qesB0wVE1ch4/EKGth8b4XfrdtNut+Keg2YNfMujvEtuPae0UDdkbYN0frU3gkZR4OvN7T1QZk69qZ7/Xg1Yl16GTMgORV+OnkADMPQFqW1RZQtukk2IRstxwvImplDlZWzoXdF1az5TarwqfDbyW6pyGjETo5fcMROq4oraV6AEKg1KwTKWj7jrbvQWXDF
 Ra5l56fa
 0iPOkh/HjJMaS7lDiYVnEQCa6pC6BrKqFf//TizxIauIOeFa8PVrFUj3Luqni6xVdiOkv+JdART4GKxGPTcxqRXwzO5fLifkKWVwK+uct/58QddyRr0eBr18wwKzuYE0QDRSO8gBB3OqrzzY3Z9BqzEUdIhVrzzvrGyBzQOiU4HUMwEQezEXTeDvZzFAAXl6zEa0lfiKxMy9S/qg7I1ceA6iebzDsMy+VDa4TTRqSv/UQpSJqQRBMpyRQfs3A7q4V5pApIMPTEzmfYYDWWM7XZriYf0F4uGOV0Ah/8AxO6u8b+yZ/Yjqb565wqbLgxHnIf03GXotmPsGcwr+yeaVpIqKvUR5EEoMlhM6Y2Maj30zKubkUl+wJRcJBoNGZuG1HhyNola2zGuSUFfqKjA3JAj4zzMZ7U1gDA7DFej65FfVj8aRoNLXC62PlfRlsSpZZJsIFvOfjZShVi5WGvUO9XUpRew0JEG9zY68dkTWZoqvhi/x5YbuUFPFSwBazSdmB6CRrNxqNcdnoGEJoqP3jgBTU/fniz4r6BPYyDW/lRxnUyVO3zbnreeXQI1Vdzxcpt0blW/U1M4q4tPCT7eXtUvHEkV8voV1sFKrD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function inc_node_state() is no longer utilized by any part of the
kernel.

This commit removes the dead code.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 include/linux/vmstat.h |  2 --
 mm/vmstat.c            | 15 ---------------
 2 files changed, 17 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3398a345bda8..864a78287371 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -286,7 +286,6 @@ void mod_node_page_state(struct pglist_data *, enum node_stat_item, long);
 void inc_node_page_state(struct page *, enum node_stat_item);
 void dec_node_page_state(struct page *, enum node_stat_item);
 
-extern void inc_node_state(struct pglist_data *, enum node_stat_item);
 extern void __inc_zone_state(struct zone *, enum zone_stat_item);
 extern void __inc_node_state(struct pglist_data *, enum node_stat_item);
 extern void dec_zone_state(struct zone *, enum zone_stat_item);
@@ -395,7 +394,6 @@ static inline void __dec_node_page_state(struct page *page,
 #define mod_node_page_state __mod_node_page_state
 
 #define inc_zone_state __inc_zone_state
-#define inc_node_state __inc_node_state
 #define dec_zone_state __dec_zone_state
 
 #define set_pgdat_percpu_threshold(pgdat, callback) { }
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 090b5c5294b9..16b7cb24d411 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -671,11 +671,6 @@ void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 }
 EXPORT_SYMBOL(mod_node_page_state);
 
-void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
-{
-	mod_node_state(pgdat, item, 1, 1);
-}
-
 void inc_node_page_state(struct page *page, enum node_stat_item item)
 {
 	mod_node_state(page_pgdat(page), item, 1, 1);
@@ -724,16 +719,6 @@ void dec_zone_page_state(struct page *page, enum zone_stat_item item)
 }
 EXPORT_SYMBOL(dec_zone_page_state);
 
-void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__inc_node_state(pgdat, item);
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL(inc_node_state);
-
 void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 					long delta)
 {
-- 
2.34.1


