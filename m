Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 984DBC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7510E6B00A3; Tue, 15 Sep 2026 02:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701BC6B00A4; Tue, 15 Sep 2026 02:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618446B00A5; Tue, 15 Sep 2026 02:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4796B00A3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:59:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B47981C21F9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:45 +0000 (UTC)
X-FDA: 85215096330.04.1FD4DE9
Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	by imf09.hostedemail.com (Postfix) with ESMTP id C9F2B140005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ii7UKsEJ;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789455584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRXjTYOp0x97eL4gSyPw0XCas9R7Mn2V+8OCW13A3no=;
	b=aLiB7gEcoUYP+oTuYt5BiiweYr7Vw0g17xcPCl8ZcARZNu2q3b//y3mEEpoSpFjyBz48Iz
	97MPNKHsXMbR3GN6KbKFbnfQmYjxQn8z0bB3lXfcH4T++HVjYOovidxXNfgY1EBgI4dGD7
	SPjXO6gwUTuS1N428ZZG8/pvsdeI1YU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ii7UKsEJ;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789455584;
	b=Zw/c/+mGhIA7aJma9xXy8GQfmshcXrT3b9h1br0jOagzK0DHvdXQ6+/ivgA7kaA4esJPU7
	sA/amO4Ep5SIGqCPrVTE85hSgE7WV11Sw8yyNtW6awYE3m8MMCuTk1OZNgUe2OwKaUilCP
	ZEfEIEEn+KjORDV0DtJByOa45Oi6D7M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0gcszhOdin+bUpsUHNDDdcWh1NUbmDL4eeu4aqfKVU0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789455582; v=1; x=1790060382;
 b=ii7UKsEJcTBsF7caN5U1iFoEQgL0UqerqAbbcBOobpfHYqOXY5XOrkAR+NW+SfrUtm08NJgX
 wUnivqnee3uX/0YJZmuNIG0ypkh/Gd0p3OUsCYe9AN0OJ9uJwla9HSyQpjYPfieGPxJHVhKV39V
 kl65Ukv3OwOzPAtRWnLwwTng=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id efae1140c7a24bc8;
	Tue, 15 Sep 2026 06:59:42 +0000
X-Mizu-Trace-ID: efae1140c7a24bc8
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-modules@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v10 6/6] alloc_tag: Defer /proc/allocinfo removal to a workqueue
Date: Tue, 15 Sep 2026 15:00:01 +0800
Message-Id: <20260915070001.113559-7-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260915070001.113559-1-hao.ge@linux.dev>
References: <20260915070001.113559-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4nzmtg4cgrx4uanirndce4mfsppsdory
X-Rspamd-Queue-Id: C9F2B140005
X-Rspamd-Server: rspam07
X-HE-Tag: 1789455583-879210
X-HE-Meta: U2FsdGVkX19shZhCZfjbWUXuEvnS5TD3FVpmQQRCpZLdJS6W6WcAe6Px5C1kNWDUfFxJdzdDORD3SF2PyseTwDgupzZyORcDRYr1F3q3O/dGXk4L9jlb7EAoMlun/92VASdBbDlXfSjTb4/E4m5W8bXH7yhyAHm9FjJdGXflHNAPAH+3b9Eo5NidyYZRQr1cJ6Uq0RXru4tKlXTGy4Hh3HJ9xHB2f7EXuu9i1KEeicR+kBBPk28BOkxKGQnf7ulUr33prUmRkDVCXISsOpgMzRO4QgGBl9twQIcrCvQ83Xcb3U+CV+33N8hzmWlZbJH/giPkaw04tMshvV4iyavvDv0FQ/hfJgSvu3CJ9j3GvrWhbIFoQPO5FKMT31IrNRTegKoXidZq9mW+5f74P3M/1d7bLGhfca9hnsdYDokvHdrzCQDJfGCUVEay8unH7bA6hX0qFWOIlj/h8EsgDdI9hkTNmffEDJRBgISiqniqvraBD2Zt4yeuO4kACV/C88qlCcJEqou3E1jTso+AVFXj3NKF2Qs9xOmsfWDfdrGsFlXC8mzizqnjIqx8wxV/pmgaJDeL1Z+6Gx6NTQn6CzQYnFcWlD1M2qVblVyaIO59SFm9oK7c/tdFrpRNin6PNqkBc+N5Aq4SuN5l4ynru4JfCIHrR/2HH8WvfuBLLdxTXuC1jYRqZpWXWh8rn+9mn6Mo0gTlLtjRxgYjuLf74V8VddzL0LYFoSCghuK9MubeZBovpSPSkwvOZenmJJUb0JGtXGTtzQEz7kKHp5Yl8l9nZmegJ50C3RgT9/b0YK2/DHy7xulj3rGI1l5vtTJhBgyzmFt1LqKtM2NzYkXHu3Jj0eRld7x8DycZ3DNeq9CpzXVqaVcGloqHuSe/XRJCribqQAne2EtjtA1qDGJatKOrRYkvXgt/1FhcnqJo4YIc/AhtD6eQUQxl5su8Vcew0v+7WhrF9MF1rJLpezuLKjz
 Gn6dxfSm
 goRwW5hQWtIMNe7gVNY0dH30UNoNJgk5yq/I7D8V1pM0nCwdCRaGqjC9QwEqdhnuOOuogfD6BwL3oJaXkSjGKwH40XEiYHKPAM7GvQz6yhLWOBpgNs064BWh3ixNSjnk1Iwq/k2t1TrkuYrWWuCEviuslR9b6SQUopB9y7dGV74tuecPOWdmqNXoYd2jyotFSI/LY/ecl3DQAKKknyKnMl+3UkQv+eEbkHieiBqVIUqBw/m7OtptUV5Wtx92j4QW/N6p/jG7hJjajrdzYlKXDCEMe5V/4G2ODHoDMY/kjcnXkFsc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shutdown_mem_profiling() calls remove_proc_entry() from
reserve_module_tags(), which runs under mod_lock held for write.
remove_proc_entry() waits for readers, and a reader takes mod_lock for
read in allocinfo_start():

  CPU0 (insmod)                      CPU1 (read /proc/allocinfo)
  ----------------                   ----------------------------
  reserve_module_tags()
    down_write(&mod_lock)  [held]
                                     use_pde()            [in_use++]
                                     allocinfo_start()
                                       down_read(&mod_lock)  <- blocks
    shutdown_mem_profiling()
      remove_proc_entry()
        wait for in_use == 0         <- blocks

Move remove_proc_entry() to a workqueue.

The file creation is moved to the end of alloc_tag_init() as well.
If alloc_tag_init() fails with alloc_tag_cttype still NULL or an
error pointer, a concurrent reader of the leftover file would
dereference it in allocinfo_start() and panic.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/alloc_tag.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 1ca0409b492b..cfa0fc84b68f 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/string_choices.h>
 #include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 #include <linux/kmemleak.h>
 #include <uapi/linux/alloc_tag.h>
 
@@ -591,6 +592,13 @@ void pgalloc_tag_swap(struct folio *new, struct folio *old)
 	put_page_tag_ref(handle_new);
 }
 
+static void remove_allocinfo_file(struct work_struct *work)
+{
+	remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
+}
+
+static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
+
 static void shutdown_mem_profiling(bool remove_file)
 {
 	if (mem_alloc_profiling_enabled())
@@ -600,7 +608,7 @@ static void shutdown_mem_profiling(bool remove_file)
 		return;
 
 	if (remove_file)
-		remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
+		schedule_work(&remove_allocinfo_work);
 	mem_profiling_support = false;
 }
 
@@ -1358,16 +1366,10 @@ static int __init alloc_tag_init(void)
 		return 0;
 	}
 
-	if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
-		pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
-		shutdown_mem_profiling(false);
-		return -ENOMEM;
-	}
-
 	res = alloc_mod_tags_mem();
 	if (res) {
 		pr_err("Failed to reserve address space for module tags, errno = %d\n", res);
-		shutdown_mem_profiling(true);
+		shutdown_mem_profiling(false);
 		return res;
 	}
 
@@ -1375,10 +1377,16 @@ static int __init alloc_tag_init(void)
 	if (IS_ERR(alloc_tag_cttype)) {
 		pr_err("Allocation tags registration failed, errno = %pe\n", alloc_tag_cttype);
 		free_mod_tags_mem();
-		shutdown_mem_profiling(true);
+		shutdown_mem_profiling(false);
 		return PTR_ERR(alloc_tag_cttype);
 	}
 
+	if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc_ops)) {
+		pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
+		shutdown_mem_profiling(false);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 module_init(alloc_tag_init);
-- 
2.25.1


