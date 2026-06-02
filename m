Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B005CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 22:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DF596B008A; Tue,  2 Jun 2026 18:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6E76B0092; Tue,  2 Jun 2026 18:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3956B0093; Tue,  2 Jun 2026 18:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 728506B008A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:24:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D83D1A0150
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:24:05 +0000 (UTC)
X-FDA: 84836401650.14.BEB9D69
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5B50314000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:24:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PqJ9cSII;
	spf=pass (imf23.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780439043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=muTnxhGqlYOE/TlItGjvUxPhQ3HFtb72AnUGbvWcFwM=;
	b=mzZlWfcvsudExQP4aQUngLGC8IefNHQ5ItMn01KaajqKAz+dzovQqMey2R4sWwvln4/6Lx
	XV4BaEH5vMfUQN+chCSG9Y4/qaEkHSrxDh97rDdWNdOXh9juN8jvQR8ZLaNP0uo/RifZa8
	x/jTv2f9GufQK5iDHrEtFvynd6LSQK8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780439043;
	b=Zdvgv/DXIlKN8ezMGhF0rj0njYLLQF5PHdl82TRivdF1KYrc64E6DtYqLe8JLlMFpP6tUt
	9Bg2sKVHMbUpnF7JkIkKoMlZjI3uKFyFkyS7TxbLO9FDTKM/KR44JSDscHNHLxdhO+CcOA
	lRkR4GX1MDUghgYLGb288qYiDwVKJPM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PqJ9cSII;
	spf=pass (imf23.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490b64c8311so1480955e9.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 15:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780439042; x=1781043842; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=muTnxhGqlYOE/TlItGjvUxPhQ3HFtb72AnUGbvWcFwM=;
        b=PqJ9cSIIUkjcjsP/SOssQ+fZn+jm0iH4iH+G+DNr/A4cLAKk6q4iZP/ZoI4VOTV5k5
         vOY3/hyoiG8t4gKc+aEkyTvKO07+VYCL9PSdPJAteQF4PgOgupYMrJOat5uRsEfCp+z9
         pMM0F4YLbszekDc7T906KDkUkjJEougrFC0cONWiN//N4235PgfIEXuHkOZcW30ublJZ
         r8YN7gFgcKwS9NMVDLFvEP0Z2xYL2KbEW1i8MxoKnJ/+SOrSMZZC9YS0IpcsW7uDFsgf
         l56BvEBPzIwwWcpykPaUkRvPMwscHRf/swe7iMrtUQBMfxplwz4YF436lN60YukLE1D9
         vJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780439042; x=1781043842;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=muTnxhGqlYOE/TlItGjvUxPhQ3HFtb72AnUGbvWcFwM=;
        b=PY9ahMPvNE8PyLtJydED8h6LIZpe28JrU8gv4d9ZuKIuxZJxv0Ox7zfq31o3spccB3
         C8SSzPZUU4OocxceG+ZP2++BWQqxrlaXuQRQIs7H35npPvfpAeZ5238Aycxz4PMBSvsl
         kr6XNl44qefMYA0RawXAweX889PNSkI4DheKqCjuskZ8+UXX8ZL6IJah2J4U2mnrAqW3
         2F2DxIXsjtbDHhQyxNaaHmEeb00zg9j1zFO3sr/cmQxmwbn+iurYsqKN7y7zG7kVuf0U
         gxwG/rK9ZSO0l1+JmB5qN70nXXhAIfGyaxhw58de/Bsjm0pkEyNF/R1Hsjt6qGwkDgRm
         kdtQ==
X-Gm-Message-State: AOJu0Yyv8EKIuV3FIL0Npw3SILXHYwwBrg4f/iQOM2U0wCvXOP3MLjib
	RXkw+8L5jvjTU/meKDG/8Xe3H0YdYJWzTqhIqML/UQU6mfKIF6obcHeg
X-Gm-Gg: Acq92OETHtBQ5eEqLVsZXOlBDLc7/q2CesERyMx2h+ZOzzJzGakhjYt5Fzn3/QFwL7f
	UR386GjFjN5cLJBMV6BwvVNSaNlSw1LGdSOxdYxN6cYjZhuQMTyvuMs6bgFF9YxJ2clEtlYg8gM
	PpTw4v/MPK4mIJENtA1CoNXkDMidAxoDqqYdAnSXp9nKVGOOg59cj0u+259HlMJdvHgspu6SY//
	e4soZHC0hZXqBhQge6t1jlSmedf1B8FhfDG0b6rXsZ1MWzNTw6Sboo9SLiXepm+EIDeOw7uaRMn
	fuhBYlXK4aYwL69FYhaiFsGOGZuxSWj69l/GZchc4v+EZH4JXsmYzeab6kMWnHbWt7iaVAmrHFn
	hMWfZOvDaO+pxoy7bkVH55lJLdb1vOIT585kDASlU3qwzYDnI1Vr6iEvnf+i2TgbVJlYMI/8AXy
	Hbw+RUcITbXEFBh4NME23YE+wGzZUGNQ6IOOgcuNfWzHazDQTTxLsLGOsRAEWbIdyLZbWSIUGWO
	dALNJOk3wLXvfBibC5cig==
X-Received: by 2002:a05:600c:3e0c:b0:48f:e1ac:c94f with SMTP id 5b1f17b1804b1-490b5ea86d9mr9922945e9.10.1780439041650;
        Tue, 02 Jun 2026 15:24:01 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b60f6d5asm10362265e9.0.2026.06.02.15.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 15:24:01 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>,
	syzbot+deedf22929084640666f@syzkaller.appspotmail.com,
	stable@vger.kernel.org,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>
Subject: [PATCH] mm, swap: free the cluster extend table on teardown
Date: Tue,  2 Jun 2026 23:23:57 +0100
Message-ID: <20260602222358.49061-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B50314000A
X-Stat-Signature: k9htpn8wkrtxq8t5fjkh3b7jq1hujgzm
X-HE-Tag: 1780439043-813099
X-HE-Meta: U2FsdGVkX1/0d2/7EIS6zgYAb8HPugJU2HpvG5Z88wbHc2ajtLgJcvWXJkud6a3GhPkoLUKGzZYJTxtnkm6wj8PJ4eiqPOuaR0ouNxhKjS+iuMB6QUp96bfWDj+fzLoBgFv3/IoNt+Hi81FylyxGi8hfCe3fvjCWLJ1RMKs6dUkW1bNgj1dFOY5eIYOjKXx8p86mKAs571AhcZmr9E/xKyCjpyIZondc0yWmblzXUNZ3MT+lQgmm/WFJpbq0qMbwenM7SipttmMhCD+YX/DGCyjoQI+gk0snge8uAdGfQ8U0HWfw/ZBQwqDRkyVma9NKeGPs01AQj+pT5wEd4NVqoHM9q1yjG8aBRJyPWA46CaJsh1+zQc/5ulrptDP0737DOVHQzsG8LCChniMVitR46/6tIA+VW/QplS9CbWdIiDyvnpQuPrBsOpwJmHWEzjs7AvHj4oKDp1QNW04IS0t9mGZ1Q51UElixmBY/+QB18HMru8Np6Qjq6YC0CPff5fVnfOtzqWY2clbwopHa4+KmIxIfEPTaDCamxabLpcTVRMeQcr6dA9LPvY0NLVyqHiXmWmlKvt3gymLf7ZhdR6cIjNjeL5WqKPDKijGelChU2ek4e7oOraxdpKr/DDQ3RiaEhmOLaqPOHuYUsGwgTcLp+E9vYex9HKrh84Rka69ZW6QPkAn3Bw9p51gYMwvNZaI3jqizStPldXX3wvJsi0CPJDRQIMOjdQQlq0GQaKuIIkXoWubELE7LBzInouAMClKU9VhwHM+V7riAdidwgiItLv5Fo6rrSCVaGMhOtrd0fOiL6D330qysxG5DoG+4lLu6bCC1y5v3t45pev3nAkbuI3b6dnwIfQoPoLzTlZY21gRofyiFD8AVXZQ+NHK4uZaeGDeojfDITotrDdZq3QuKMTmB58CyTq1/UXgbY5utjTRcorwVj8YFZI1x45MdxPV4jFLWbq5LhGQFE0K4/dd
 /d3DTO0B
 z1OR4afFBVRq3OvD7a7D8yZy72hUirhaN0eyBfPd/XSDQk22YiXBTVgWuW7nXEkFoLSzZf+cxm7yuZsU6uv6e7B7cwF2rGk1S6hMf1/qB7Z4wJ3YZr6ZKl2IGf6BIxj7cI49peKzVJi3PlGwzpUbLWc3M9nK3rIy7rq6jex/MI5x8eljwmltnCZXkwpj9+daUwgnEb6Biumif7Jc6IC73b6zb3ZlVQAgMn/pOZ98a493XwEq2BhIQSHIo6CsXDz5wMy9BfXEAQgf9LdPSAxBBWq/JWxjce/fJs5WRJJPy28rfMWaoGiaZc118D7926WPZbfZOP84zPTvqZ4NPzSy7TypbJg52qIo6XpTZw/z/7q9yqZ2X/LBNfs0ewc9Cqqs9KvJFqkMGuSKKxZ9/bPW9089DP9vAhF35W+w258V20padF0N54tlR+a38JeNmuEOnatPK2gJuqMNiG403++f7nowzRFT20C2gJU/KwBHWcNRfzWni28Nx68ZGSBAUxHVtCQqyglbS2xjN0AgRnlkbrCkMsVVyLXsqyeOfVv6PDA3uFFhie0HI26CJo4fFKxbgxzOqM1Ltpvs5KaRshHEpJRVXw4rt5E8iqCDLyUI+Wc+0+/p25WIyJ8E2C0xZkLDO0f+EMWad1f+jjJ2RDeRA7z/+7D5TB3jkKN+UWojnOkf0wmURAATnfxn+qbPls6eQ/LrtmiVHMEuDykVIVX+X/GlMt0gQW4QyrF3/ujZs4B61lUadCZtyFEYTCJwkaEPf8A9K6RkmH609pR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_cluster_free_table() frees every per-cluster side table but
ci->extend_table. That table is only released by
swap_extend_table_try_free(), which the teardown path never calls, so a
cluster can be freed with an extend table still attached.

It can also linger while the cluster is live. swap_dup_entries_cluster()
drops the lock to allocate an extend table when a slot reaches
SWP_TB_COUNT_MAX - 1, then retries. If the count dropped in the meantime,
the retry takes the normal path and leaves the table behind, all entries
zero; only the failure path frees it.

Since a swap_cluster_info is reused in place and swap_extend_table_alloc()
skips allocation when ci->extend_table is set, the next user of the
cluster inherits the stale table and its leftover counts, corrupting the
swap count of any slot that overflows. CONFIG_DEBUG_VM catches the
dangling table in swap_cluster_assert_empty(); otherwise it is silent.

Free it in swap_cluster_free_table(), and also on the
swap_dup_entries_cluster() success path to match the failure path.

Reported-by: syzbot+deedf22929084640666f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=deedf22929084640666f
Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
Cc: <stable@vger.kernel.org>
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/swapfile.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 615d90867111..a69a26aec4c0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -432,6 +432,9 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 	ci->zero_bitmap = NULL;
 #endif
 
+	kfree(ci->extend_table);
+	ci->extend_table = NULL;
+
 	table = (struct swap_table *)rcu_access_pointer(ci->table);
 	if (!table)
 		return;
@@ -1711,6 +1714,7 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 			goto failed;
 		}
 	} while (++ci_off < ci_end);
+	swap_extend_table_try_free(ci);
 	swap_cluster_unlock(ci);
 	return 0;
 failed:
-- 
2.53.0


