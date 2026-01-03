Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7966FC6160
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 16:58:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5376B0088; Sat,  3 Jan 2026 11:58:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88CFD6B008C; Sat,  3 Jan 2026 11:58:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761046B0092; Sat,  3 Jan 2026 11:58:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 623F16B0088
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 11:58:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAC8D1A04D3
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 16:58:20 +0000 (UTC)
X-FDA: 84291260760.05.1126DB8
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id E99B38000D
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 16:58:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=cTLoq0Y1
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767459499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9j+lytdvFaQc0rDMkV0fSvoJ/5Wk5aT873gsJML9tGo=;
	b=WSco9QnjXXRd0Tb2v4cshHkUpgWeoD3FdkToSyuYTAd9Z0A1u4dRlcME/RUYvRAdDVc8iu
	0Tt3lCIRz4gg0vaR1xFwu3JScfxhE7gPQWnrcTNEbgnsGPy0N4ZrnCGGhYXwiLHz1xoD5G
	AQglKgghjr7h8WJh+oYPUPttiFXOAcE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=cTLoq0Y1;
	spf=none (imf02.hostedemail.com: domain of boudewijn@delta-utec.com has no SPF policy when checking 209.85.208.51) smtp.mailfrom=boudewijn@delta-utec.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767459499; a=rsa-sha256;
	cv=none;
	b=sHY28+TjRlOAETVrhEe/Ypeqvalr32Kqak5+maaTscboz+3nG2IV92NMZbCdP5CZ5m1JJV
	4snbLK5QqIKzUezkeo3ShOhM1KrJ9S0uNMjOlVRVdY8GJuybY/6XFafYLzEYxovXE6b/oB
	x8bisxzp+iplQfE4ylfsVYVAxhEABqk=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64b61f82b5fso17354465a12.0
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 08:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delta-utec-com.20230601.gappssmtp.com; s=20230601; t=1767459497; x=1768064297; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9j+lytdvFaQc0rDMkV0fSvoJ/5Wk5aT873gsJML9tGo=;
        b=cTLoq0Y1JNDgM60/uNHa0Q2mpUyS2BASrZlWTTfwKG9vyfofpGUYPe14Al6tBPLIsP
         Q69M9qMczGJ+P3Z0kamjg4VriZB5FLnBGs+O/vJ77X3eIT9QUM9C5FVGiHhGmwh3NtOS
         bmpszzVoHNmOo2fL/3mDV9BT5UQuSYpjZGzqQiZCJMhd1f3siDjyId4Ap75yqSfoC+L6
         aUUoYskybS0kNFcTn1TxuUV4EqZ7+wBh9Rny71G6gKKvyzM8ODPZ0eInE222YwektnO2
         cLHaLr8ixvFZBhO3pglSdxfk1pIPCkS4T6whrBCYVLDpGI1ZCDzR2bUmp6l8uiL7YxED
         At9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767459497; x=1768064297;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9j+lytdvFaQc0rDMkV0fSvoJ/5Wk5aT873gsJML9tGo=;
        b=LVQOAwQCX4DhDNU79oW+xHDgjkUc7ruek+qctdsiJXxK5YyFZjgvoIZwR5Blt5SLST
         t0dgAB2t1hG2G5TpC8DSS+YKmyQUuXza0d+Fkm/2OoDuAvwzvSVfhps7J9/i9QiuRB78
         cSD84p2xZhM28COxOrubR0/Bnkva3YBxcBsZP6PCoMv+i0Id2CH8/gLcCf6a9RPEpox4
         6xpJijKCg9zJyf42Aqi244cF+SVDg6yEmOb4U6NQu6TusH7lb18s4Umslyx+mHqwq3VH
         i52GANDoeqZ2oJnLKGa3ZWat20uLBOQPkTVncx9kK8Dx8gTQNoxdzrKwf0dbLvKGoSWV
         LWIw==
X-Forwarded-Encrypted: i=1; AJvYcCWQ23zygFstyWqUdrt+HorlPMw0SafuEA2OVhG5lTPKxhH6GA4W875195bwZxsAQzWxdeCi0O+l+Q==@kvack.org
X-Gm-Message-State: AOJu0YxELSrYkOt3MwX1DjigeVO7+JG+V3qZFDWq19S11VrJZT4SGTk2
	yBHDXgDXMuz8uJqdtV/v7KqH5lTuBzZoAYqEUMEqDS6nfKl8cW99+Jjuab/c/CrfzQ==
X-Gm-Gg: AY/fxX4TSZ9I0/Jyivyk1OoMlp+wIc/L6klFISGdob67VcV9w61gDhEPwJH1cUWWCWd
	7a6u5biU6MJ7o5VGvNEtbppwRelNOB9QORFjL0ZQuZTl3z/OOa/grlU5w6q3R01p7fvZvDpFZvm
	AshhmmBWSW4azF7wUQCIV0lsAhNsIwVkyEkVjdWRC1+ZJXN6/ezjvsRqAThtuSLJxNtoU+Whnfx
	WdtDruXXEF/uhl5Y+zZKKbzkmW0isVf2jIPxI9EcfvN/BPwz/oDbsXNHpEp8WwQx32dtaZKyIUM
	k5zV7JY3u0Su2VGoJxdsyIAl6t0Tqe4X8h8JxcMC1HQ9O/UlfBjGyxTEmYQ4cRDx1TMs4S8dlg+
	ON+DiMM7uotvV9BCe+Vx72A9heRME5WJir0e5g4NiujxTDO6owv7IHfliQLNVwfS2M8tLgq7wUq
	z8DFSWp0Vfp/idm7rM0suwbijLvVyeRcMFQI/BcsjqK26o5t1ELwm+njktBtB4GMKIOxbHbqGZ4
	Ale6TVUs6V4mKe3rR+DtC+r2HyxhHZYoQEQkVx6t5POoecq4/A=
X-Google-Smtp-Source: AGHT+IGTM8oiOr+3z0DU0MxA7Zl9Alho44cHAql3c2v17Ye0cAmOQUtpCtyGbcS8YqyfsBgebhZFlw==
X-Received: by 2002:a05:6402:40d1:b0:64f:cfa0:9024 with SMTP id 4fb4d7f45d1cf-64fcfa0a2camr3365926a12.34.1767459497264;
        Sat, 03 Jan 2026 08:58:17 -0800 (PST)
Received: from localhost.localdomain (2001-1c00-3405-d100-e1ff-2c8c-c190-2ee3.cable.dynamic.v6.ziggo.nl. [2001:1c00:3405:d100:e1ff:2c8c:c190:2ee3])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b9159ac90sm47948224a12.29.2026.01.03.08.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 08:58:16 -0800 (PST)
From: Boudewijn van der Heide <boudewijn@delta-utec.com>
To: "Liam R . Howlett" <Liam.Howlett@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Boudewijn van der Heide <boudewijn@delta-utec.com>
Subject: [PATCH] maple_tree: Add dead node check in mas_dup_alloc()
Date: Sat,  3 Jan 2026 17:57:58 +0100
Message-ID: <20260103165758.74094-1-boudewijn@delta-utec.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hbkx598oku6sp886r9cgz4aeegwij133
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E99B38000D
X-HE-Tag: 1767459498-358897
X-HE-Meta: U2FsdGVkX19YkAFIILCvHZ7kZxs3flEFmau92ZlKGDi6ZGzpIWegWUT4T1UuXEwWs2JBMDHZSTIYOozr2RB+hG3vbSX9KbRt1UsLSsf63tsqAQrw7jH8q3yFPpVhqKZqZOBJ6sfKi5QtX0ys4xqwB2qk/P74XredV6SI9nVYiWjt52CG14ChwazXNLY0n93f9yaZOH88X5TgRkFRP95Jj2y3bSHXLus/I0M1GZ4jwqlhrNP2c4hbpkY0ecvyvf4G55GIGCdeDwWPBp7gDFhngFqS/2XHjKcJd+KvsedNzuoilSd19+0+eThPPaPi2M6VQJR+MjW+t4IBBj+2BMy1sG4rKDS+CnqJI9sNywxaoK39KkoGvqJ86rQSdFGxhdrtDY978rTvbFilCXhCb/ruBZxkJuKP8MdAbDnPlzxysU5WSB0sDdrz7RE+HbqYZBzOejkbkXIiNuTEnGA7brvZ1A2chknXt/y4Tos+VQrSCDNTMEtRF6P1KVDQjdF8kJPNqNDsrFXmQeKjgopljX55yA+2HZBtxjkwpk6wWBR7XHIuviMff621O8Bc/3Jhf6ZbiBM71QQsTJN50ABT2vA2qF3kqKBkpEv13XEBzLs1XdXwW7uEJcgY8g4jG+oH3lq/GEtAV4kpLrALeI378v3qKBmZk1nZAcYRK0yLHb1HX98xIq08ETmhBmjWX7mp3Ve40gmwE+Ogzx6HUby7/mw0wRzVGy5+avhorvLJePZNXGKML9PzK7snMYlv+6b4xDoiXBAzP0+VoeJ0LzoiyROQENtBqYC6048O6ujBWZezyIfEAFfLA2uQc2nAGqN1An5mNy3ldEhLiyWOCl3ETo+vHe9Z7r2cj8DE1TD9K9pWhBXedCUr8Wku15VWNJ1dcXHWbkMVxvaEL6Zp7rkQ62TqHP28dmfTdHuNAnfKVOY9DdUp07GpeWy8ZQNpTCCbsB7WMzY3TrY2TOl0xK3NhA+
 uT7MGIzn
 joSlCXVSSlLKjmh4Ys0GXjmuhDw7JajzvMrk3l0ipe0k+ld9KF24oM1DWU8O9U3/zNK2uonvvLIw5ympPCqmVkol/ntFPoCCbeuH68JidIvdlh0v7s/c/bg4lxxrQAoXvABKri5Ncf8TpdzD9D7B+UOZ2RmJVk7Sk11L15d28XINruc2zS2lDwS7Q2g4M0cvjF2wZof2+9W8QR2pEwDvc6jomXrJwW0P86+vBGuiospicTaj3VPewg2ns0GjjNzYrwmv0UJsOghDoHMhAw8z1/8SD+kQX8V7RV5CkfLlYuaJ76q9jQtbdsnb07Dqv/EIk4oylgMGTQJXtud2pO/eAaYlq2B9UI/FQnafwqXAwoeL1QdI+2rzdXtf5uzDcrtI7QUGDkTwneXmKOVO7YR5/Kxcu1Z8P/Sptko5EnCIelDBWwyCeh6aPuUIlefLsEytjJ6AYPcqooqO7eToUl7i8pUuU+lwNUIuTO7tR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The __mt_dup() function is exported and can be called without internal
locking, relying on the caller to provide appropriate synchronization.
If a caller fails to hold proper locks, the source tree may be modified
concurrently, potentially resulting in dead nodes during traversal.

The call stack is:
  __mt_dup()
    → mas_dup_build()
      → mas_dup_alloc()  [accesses node->slot[]]

The mas_dup_alloc() function may access node slots without first
verifying that the node is still alive. If a dead node is encountered,
its memory layout may have been switched to the RCU union member, making
slot array access undefined behavior as we would be reading from the
rcu_head structure instead.

Add an explicit dead node check to detect concurrent modification during
duplication. When a dead node is detected, return -EBUSY to indicate that
the tree is undergoing concurrent modification.

Signed-off-by: Boudewijn van der Heide <boudewijn@delta-utec.com>

---

Build-tested and boot-tested with QEMU with Buildroot on x86_64. The
kernel booted and basic commandline operations work correctly. The race
condition this patch addresses is difficult to reproduce in testing, as
it requires concurrent tree modifications without proper locking.
---
 lib/maple_tree.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5aa4c9500018..f623a7aabd53 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -6251,6 +6251,11 @@ static inline void mas_dup_alloc(struct ma_state *mas, struct ma_state *new_mas,
 	/* Allocate memory for child nodes. */
 	type = mte_node_type(mas->node);
 	new_slots = ma_slots(new_node, type);
+	if (unlikely(ma_dead_node(node))) {
+		mas_set_err(mas, -EBUSY);
+		return;
+	}
+
 	count = mas->node_request = mas_data_end(mas) + 1;
 	mas_alloc_nodes(mas, gfp);
 	if (unlikely(mas_is_err(mas)))
-- 
2.47.3


