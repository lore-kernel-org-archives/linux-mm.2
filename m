Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A45CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 05:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4658F6B0098; Thu, 14 May 2026 01:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415A16B0099; Thu, 14 May 2026 01:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32C4A6B009B; Thu, 14 May 2026 01:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1FE9A6B0098
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:07:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E16391604D1
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:07:52 +0000 (UTC)
X-FDA: 84764843184.28.24706B1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E5CDA0007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:07:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KgHc+bOn;
	spf=pass (imf15.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778735271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JkbR0Taqqvng3VkslUCPHs2UCeUv1QVcVPIAF2ScO9g=;
	b=VMMiNlxDRmcln2rTHoyAIq7YEkTBgKJFC8zL81ztpUjeESg42CQrmTD3YfdESTMQqHUCh0
	Xbah7TM2zhF3emuC8taxFRY1nCQextPASQlhQ+AgFPLL8yv6dTF4GNK7G183s5+Um5a2p7
	wk1A4hCobjNskmUz8QxPQB5a6ClPLx8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778735271; a=rsa-sha256;
	cv=none;
	b=rc6a4TXq9jWA4tcdx1PLXWuBxLPCqmbAZZCybXR0ogRHVIbh8zDAJLM0XBUFkYUUDL5B+m
	qbF+tOMpkRlMMY84IDH1L8MGk/VB+ifRAdq2HsWoUd8NkqsNgq+5ycL/mwobtpOBu5fARb
	kiJpa3T611XpxCS8+GJlQ14dgwzK0bM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KgHc+bOn;
	spf=pass (imf15.hostedemail.com: domain of justin.he@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=justin.he@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF4261655;
	Wed, 13 May 2026 22:07:44 -0700 (PDT)
Received: from entos-yitian-01.Arm.com (unknown [10.168.197.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E43C13F7B4;
	Wed, 13 May 2026 22:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778735270; bh=ce3AeHJV8yA0xKyUjIxramcUgkGMSx1azmaa1bteAa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgHc+bOn9lgikGgIomgvWGL7kqneuNOKKQ+fOrKWE/NieiqN2IOjN5N29xio9U/Gs
	 tBlE8ab9OSGUZFsIgarUDezyF9gM9cPeTqnwWlC2UBGo0zeYocjDsihl89fxbt8ze6
	 h1nNyx74R72oscuS5m7ZFFQvmtdjAxbza+RG+LqQ=
From: Jia He <justin.he@arm.com>
To: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Rae Moar <raemoar63@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jia He <justin.he@arm.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Kees Cook <kees@kernel.org>,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH 5/7] misc: reject duplicate names in misc_register()
Date: Thu, 14 May 2026 05:04:53 +0000
Message-Id: <20260514050455.2954509-6-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514050455.2954509-1-justin.he@arm.com>
References: <20260514050455.2954509-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E5CDA0007
X-Rspam-User: 
X-Stat-Signature: mktyixuk81cdo1d83getrwugsgibxjoe
X-HE-Tag: 1778735270-330531
X-HE-Meta: U2FsdGVkX1+Ict/J1zCWzPvdOp30YfCZD6YOg1Dm+D9c23cJDqNaA3DwGXOzLUkJzTv5bP7w6h+ZEdHDCjQCqbpd/za4wkJjQvJZgjZWJWu3bOn0ZyyHs/AEw0IQoKi46e/fFDC+mabHYbpOYxjMiolA856Yhcn+0vjDd8qL3O+dwwoSmEt9XlflZ028F+AL4cb727MCG1vCn5AU2xnZ4mqdkf+23grQ/t+fdcCraK/Wh0zzlVbo2f1RZxR72XDikWVmiY2Z8rG4/RDt45SBwQ9+qrnfjrUT5ONQI26S+NQpkaXQZtbPhoOau3Gl0RMqtNKJJWb2rmoyQ+5d2Cwqbf90F9k46YFh1jPX7u42qqtZdxmsJX/L12PbFqyFV8Z2HvdbpxiqbQP5rAooFKx2AsLqxt8do3kVxtKj0Bi4wCZIJmpfPgrwXEgK9ZdU3afZbCK9PeFt0nxo6AOkyMxi13mWhVpq5j9PQ/Yx2XW44C2LoO2a7knPZOjbvtAl6KY/eZLUsCw4URJjAC/ssjOp2hEj8QaheJycQXIJ88BTiRSLkbqXqXvc30Rl11/TSSdpL/YOPL5ZAjzJD0VRW+OqIUqCRdrfQNURbmbGhMz1NQ/0RiX+oj6kzj54w39xZcKhpMkqKCqecuUYggl/L485FZOtgjQx6l8xbwPqIhHkfyFTCN2wH9WeS4dg3n95t66HDLahnQGkGjrfNYJTSa3N7ydoVjSQdTgRrjTll8EFM2wNsh4An19YM3Kgb8emqVnLtvkxPTy61pFiz0+EW4wtFKHCiJ0alRE2k7Fl4RdbxAULWhE2J8ms2D2h8r9dV2hwIQOaDMoMy73mkaa54HnyNDKJKs57xJhwTxzZM+VQqQQlGDRPCm3lTy25rsVLTL4M53/oG5XfIspehwJhvj9wcKJFNZTkPLejanuX3Q9sD0kIZ6kV53SYt2mW4X9q4QwPNZOxId97tIS0JeJhoMw
 DhHGyDw7
 0Mgl/gRpYdURU1W8SPqvGenXkztZiHPtNmFvMinzbmphp+oy9XT/iX0CrN/yRVatLe+D0NJVUgOAYBuU1N4/caR0W1T8ombOYjPTb6HWGlbVb2zhgjpDupg3LJdzrGeRlTQItnjHb8dWzLh7Dfk+J4e1MPxhaYoldomuuYwFirw2DjIZ8/Ry7mJQ5XCOkSFqz4aISGrF5BEH87jvruHOzuZuunyHqbxlZR5d9sFeY4ZvuJiKabODPtMiq3RSxSrREt2cZzVy+0EWt6Ej6CD3ocWuSvtr3UYFEbLl7dcD2nVDMcDnSMox/qlV9qoSF+xRYCrHNNFyrJbMiFdSxi+81QY1NofghwZnyYlvQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The miscdev kunit suite registers two miscdevices with the same name
and expects -EEXIST. The second call currently goes all the way to
sysfs_create_dir_ns(), which prints "cannot create duplicate filename"
with a backtrace on every run.

Walk misc_list under misc_mtx, return -EEXIST on a name collision and
free the just-allocated minor before returning.

To: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Jia He <justin.he@arm.com>
---
 drivers/char/misc.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 726516fb0a3b..d6ffa21ac495 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -248,6 +248,28 @@ int misc_register(struct miscdevice *misc)
 		}
 	}
 
+	/*
+	 * Detect duplicate names up-front so the subsequent
+	 * device_create_with_groups() does not trip
+	 * sysfs_create_dir_ns()->sysfs_warn_dup(), which unconditionally
+	 * dumps a stack trace. Both the existing miscdev kunit suite
+	 * (miscdev_test_duplicate_name) and any caller racing on the same
+	 * name would otherwise pollute dmesg on every -EEXIST.
+	 */
+	{
+		struct miscdevice *c;
+
+		list_for_each_entry(c, &misc_list, list) {
+			if (strcmp(c->name, misc->name) == 0) {
+				misc_minor_free(misc->minor);
+				if (is_dynamic)
+					misc->minor = MISC_DYNAMIC_MINOR;
+				err = -EEXIST;
+				goto out;
+			}
+		}
+	}
+
 	dev = MKDEV(MISC_MAJOR, misc->minor);
 
 	misc->this_device =
-- 
2.34.1


