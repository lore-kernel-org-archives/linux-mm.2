Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D914DC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 06:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6A7B6B00B6; Sat,  4 Jul 2026 02:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F29F6B00B7; Sat,  4 Jul 2026 02:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1D86B00B8; Sat,  4 Jul 2026 02:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6136E6B00B6
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 02:13:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF6881403D6
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:13:45 +0000 (UTC)
X-FDA: 84950078010.01.EC04E04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 26C2EA0007
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 06:13:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JkcCyOCq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783145624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+SDuZDxwIL1kIbOtke72tYDvudvYgsBJGC1Qp/Jzm4=;
	b=bsFHaNwKQKrV2k37R4tYo92MjUgPVGTUSQt/O4MWxEDLdMV4yEeb0N67oy+1Y0XiwBnveZ
	NXx23rmpli8iAxVi0io1BzwMeVliH2qZpphNhIiCqEhfnWoq22MgRsKvIERzdxh5oQtDsB
	2WiwBP/L7I+z4wxtMUA7EFtHMeUufuc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JkcCyOCq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783145624;
	b=UcqiCDd9thIyjhOphb7IH7t0GMecv4h/vQmp1d1a6M26mE4uYcr5YE9hnsBIa8L7ZbAB+r
	OzNncpniA474d8GquSPL4vPnNbBIFeiwRswJhhQ7XaOkVKQVOVbpJWJCTAEbcJ6itmo6Ej
	1lAIVckfWt6taYgHOdDPUtuVpXeI/Lk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD41660122;
	Sat,  4 Jul 2026 06:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25C71F00A3A;
	Sat,  4 Jul 2026 06:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783145623;
	bh=9+SDuZDxwIL1kIbOtke72tYDvudvYgsBJGC1Qp/Jzm4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JkcCyOCq6l6LrtrHM0kwOqlM+Adl8sZyIF/PIBgjnTQj8QxOt4K4QpBvezc8CgPKx
	 wv0y0fpp90yXKlE6PshiAYUZXTUj9MP1LrXgL+GLzhCLw7HyJNGN1jf7xmzE/dLkwd
	 cbdJTAbyuNnJ9/PrmSUZw2OBVg+frBsIHbHPCtlhLFJSSnf1ynSDxB36JsGR4XzW4j
	 KMDSgtMvyTp3V3x2bkEwfwkLO9uW4GJ9z3At9YiQgxMjSvpnToLq5o0uwiNwvjAYDj
	 j2EDIq6Tbsad2Rsz3SYqC//r7ylzZOtQ4BB9dmy5ND7WrVTQg34nk2hcUMk0RriVa3
	 LmCwYMxhsvXNg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 04 Jul 2026 09:13:34 +0300
Subject: [PATCH v2 1/4] scsi: target: file: use kmalloc() to allocate
 temporary protection buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260704-b4-scsi-v2-1-7d2d21a810de@kernel.org>
References: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
In-Reply-To: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, Hannes Reinecke <hare@suse.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 Wen Xiong <wenxiong@linux.ibm.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
X-Mailer: b4 0.16-dev
X-Rspamd-Queue-Id: 26C2EA0007
X-Stat-Signature: c943qu767ftd8axqoq5aknt87793gew3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783145623-576005
X-HE-Meta: U2FsdGVkX18ASzcnU1h+WrUav04NEaIGRjC2llRoUQGuEeCkE5aEfzJI5yvf4UPtPZcpN9TrrcFEP5Cz4El7UtV43kOXTqqeDY72t79kHbqW3rzl/TkOv+m1VetlnZ3LTkzaegN41v7QCEjM4VzkXVTbyvL0bE7T8aXUYpOr5X5xkJjVu3pqtqKupww9jUJZtlZlC+jLORb9KGz0F49hcI8487lGTnSmkoqZ7Kg3eUZzN6MmQztgY2bd6SVCXBtQNfpOEYW1l5iJCOWaJGTHn6tXlJpWi+ZdrNS49fG8V7nf97sd7Q31p+yqus7h8ysQ4EphjL62QjkkPA2n1ckhxqj2wMT6+ObszkQ8688J0EgzfsANV+rtXh2o6Gv0/etnfqmF4AOFwMMdEH0FmULNdL265cJtqePGf+VKWS9himIwFjF+oQq9XFIPHfgwNLgZgFylz9P5if7jPec5NZBojgXBa1Q5kWg3Y0y9zZJbSwh8G0CLKwt7UfRCe457GdaRc987NrkNGIdmqpZbkrJf24+IMH0e+OPnOBov7jAXXFz17x0MG22+TszxnuxQpDjB1ivdI5a6FzNoLHshest0A35lLoxDIogCL4Cn3NJ9e+NWX4zbwSrgvdF7iU6mgFK9QhF6cZtvKpmwyBsQBkF9JK5ekvrJaHhycSYt3zHEj/KzxSTkUQdDsZdSTDoX3hoEdUzda445OeQC9+0wDu8NWfhp9yDPGGhDhrKqM8Lg1brybKoNGxjIjZWGj+tQO2HDKsg3MMOWaO3rVXmgfopCGCLS6ntbvkTYMpLWH7zdmTWdeJkUo6JOLvpXjThmUu+Wh4gS4EAL5U0Fb21Ji11Em+HnfnI00zmCoeb/6c/FaMIwQrHAK2bOh39tk+s7hLjD4oLmDOZMe5opDjhB03FBuMCEyquv55pEXIdgDQ3hizyK0PbC2p10lvgCpvbYe/+APssopXHa3oBpMZQiayk
 chLxjjHH
 aJPeSTZvQfqC1g72VTVyhKLL80kxLB3sXMDmn6NfiyY4MFj0bVH1gJ7V6KxesHW5tPvrj3jRHDwBg/Dmn5oPiqTW91OWWLMSCxzk7oTm3c3HIwS9ao/KwJGjXuW3L1HGrZ++2zupUMn3vmvEnlwqvjXQ8dE+SAna8l5FwL1NqClQRhIjL8iRrQhTxkKZJnG6w2G/2aOcslaBU/HDG0gFhPv2bPE02e2ik13s3NY70dAEQCnAe6I6FgYAKcQN/GFNLXNTMYLmOKDZwJGvApeBGmC6fdM+U0JCVF21B0gjqMLI5qmERpH+ondf0XyPXISqb3jDMJuGTpJ4pmiV1QI9BhkkS5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fd_do_prot_unmap() uses __get_free_page() to allocate a temporary buffer
that is used to invalidate protection info for the unmapped region by
filling with 0xff pattern.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of __get_free_page() with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/target/target_core_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 62ced9f5102f..ab9824a4852f 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -516,7 +516,7 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 	void *buf;
 	int rc;
 
-	buf = (void *)__get_free_page(GFP_KERNEL);
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf) {
 		pr_err("Unable to allocate FILEIO prot buf\n");
 		return -ENOMEM;
@@ -524,7 +524,7 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 
 	rc = fd_do_prot_fill(cmd->se_dev, lba, nolb, buf, PAGE_SIZE);
 
-	free_page((unsigned long)buf);
+	kfree(buf);
 
 	return rc;
 }

-- 
2.53.0


