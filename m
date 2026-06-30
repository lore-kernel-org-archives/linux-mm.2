Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666D4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36DF36B00B8; Tue, 30 Jun 2026 06:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EDF6B00BB; Tue, 30 Jun 2026 06:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235E66B00BC; Tue, 30 Jun 2026 06:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E67876B00B8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:54:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 714B91C6E92
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:54:28 +0000 (UTC)
X-FDA: 84936270216.07.317FDF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id CA4C41C0007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:54:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gjf/ZuGe";
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816866;
	b=Mq0Kng24+baseT9JgyvIfaUX7uEzF4+9+irmQOLZmfxTW5s66kyTm7daseAsgQTpVmp3x0
	cSSRMXvV+NSaxVZIe7d8Uhwh4o7EwfBK/MrdoOkHVgsqn0xTQ18Bwz6EVHZVw/MDnbZemv
	tFDj8xuwVfLhNYhT5JA1u+S9Gnhctyo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvAMoaymjsNlTe4kwsyBLHq1Qu+UJKHUnCgBBRJ3/ao=;
	b=K+6MKTcn6XmZOVoCkFFuMzHyKWLFPW2XXiSdSbyblcnPbUBqGqYf3Rs3LJW7PMSg8WgkkA
	mT3VT8v1oHoo8ifoMFLc+mzFGEMdYGYW9NGH8fjsiiammiN/eCFCNF3UESi8KXZeRGL7Cv
	IYT6E5+lrN4z9Utuunpc6c3Kyt0rCbU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gjf/ZuGe";
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CE89600C3;
	Tue, 30 Jun 2026 10:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1951F00A3A;
	Tue, 30 Jun 2026 10:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816865;
	bh=KvAMoaymjsNlTe4kwsyBLHq1Qu+UJKHUnCgBBRJ3/ao=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gjf/ZuGe9/6tmqVaNQU85VRcHoOkG2BkpuNKDBPGkJR+sdHeZqmEMjjOq4X+bf6Jj
	 kcYkVsKjDRym5vCqxmovsyaqquaHOr20VeJy3Wi9n5lZ15vWTC/rQAuGjdn9rlD1ot
	 aIehXwlUMfnL03EFyofiqO48TFZGSo2yAKkyi/anxE4e850c+PfJd0BZeAm94uiw99
	 vlMIFizPVCSqklDNClOZLR2m5o8PEo8WgrJOSobc1sBe6tPqOKWcgEleB3IEEYr0Aw
	 twVQjEQHpgLLFcD/PbULzMoiFWjNLZxcWhDuTB+yvzSR8a0yCx8V+x5+nXWqllVwd8
	 l3AcZ+ouFkp/A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:54:18 +0300
Subject: [PATCH 1/4] scsi: target: file: use kmalloc() to allocate
 temporary protection buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-scsi-v1-1-494fb37ebe7b@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
In-Reply-To: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Stat-Signature: dkd4icnn31u1s57a3tujme75ubfs8tjo
X-Rspamd-Queue-Id: CA4C41C0007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782816866-918044
X-HE-Meta: U2FsdGVkX18fwUm/EQRcs/hgamaGrBbrV+XQ8CZY7EbrtemPKepeooiL8Mz1DQNpQLFreyZaFzMh9BuuDDFA+DOCgbWdbP4YfZZ9ATnYfQbs91pN/SOvBg8FseOJQOfDVEM712GKlrjl2wMiE9E8wync3QRJSJrtYyDCI9k5nuBmQL0BCK669UlXSIkONbHrPx7L39tavyBgNeFBAudfCj36z8RE+9wK9kMQXHTvuJmgqL+B6WqKlK9wPlS3cee2dsM+rE27eUUNOna/ubLvQ7s620kl08UWEjM+dCS0JNc/lBz/kkHxiXYosY0z4GRxfFrHOAJhIN29doMediBNQGgD4A/f8LGO69oJ4inMM98MsrrfUqsQuwy6DRT4Sb/oXo6sf0tHmg072l0UJ6r8xlv7EsvwrL3wcyOAiCt3MgkyBaUUBZp0V/CaID0YDITqlrwFMJ0Iln5twHWDKzN2vqdaJqZ/RetdCDjS3QiQ06xQVXPXHgSCO/dBU215PZ+3mrZcJDIk7Z3vEwocPY980ygidS6QjlEB4XV+rukwsUoypoEarzwjKtyhyNSoeGP3w0KKuZuBjv/U8LVlIf/JFqLzZu4AkR6JIVorPxap9647EJ4IUVOvUb4coiM9Zs27bzSZEbSwPl0Ej9A4kf0yz5LTeHONP3BNFDxhU82kMwKwTaBZvdYfe6i69XrY1DVdBslpMEAkbNcE5lWrBaZIM2RQevZyff3+fwWcf2j8PZtUvaWuTzhsUpLxH+7WEW8yXkGk9Zlk+4cz3bx/eGGAnuHfdlDuR6o3fEEAVtHOmkPFFROIfcsgZ8PHM23r5//NqaRwGPwKt7ozgGzobVDdSoOcEvAy0YF6a9RkO/mZD/4GRFcL8bH7lbbTXjogRZA3WMzdnmFCPfCp7d/aJtGAaWIhvX3BbRY9jnDBlyHhYJtRiA7FM/PmlTobt3HXSZN9bog84O5VU9VeEMj7nga
 KSjVbRhO
 S+U7a/2TkgfuJOzARb8b4XqZSEgjz1FCAqvuhadiGPEAO6WDlFfDEJOmM+q5EyXvVQgP51wC6RMjQDdneuIAnoKsDc/hkCd7Lh+3GtPWjzFJeR3vPYvOgJ8kXKvtd36H+x7wCFEmv59rwJ9mP1bmLdf1SO7GWOQzP4KIigQJQJaJhFzh3qy4l3QD0A/abMY3GGVAvzlGvWS5ZIS2q6jtAIaKR4RJXKMn8x7V9X7qJvqm/8Xu+EV716AFpZhj2RdopBMya1p1Tzc8BvZc=
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


