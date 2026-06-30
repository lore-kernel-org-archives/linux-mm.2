Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B79C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93EED6B00C4; Tue, 30 Jun 2026 06:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EE9E6B00C5; Tue, 30 Jun 2026 06:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805396B00C6; Tue, 30 Jun 2026 06:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 58D366B00C4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:56:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0277120465
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:56:04 +0000 (UTC)
X-FDA: 84936274248.01.AC0A8BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 20FCD20006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:56:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/OxEb3e";
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816963;
	b=Fojpi5stDmoeINWugZwrgjO6U3KF0q+ql1QfQSAel+wthq69poO4xSr1ExlvE3sbd592aY
	7gvvqb3Bc7CvXLOOHUpOItk1Ny9ghwfYLRH0pOCPqYvsObQhAMRACJnstGwUmL0Y63SHs5
	sd4BLJwWt4ftT4LDTfLBjTBMGFLaeqo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=x+ErKDJZBnJk0BN/YgBPDVpN7NT+yJFm0+JSzLOIJy4=;
	b=sJGyOe8vDeqngthxTmaveJvaTi1Cq5au3HNevlXIZT4qHj31x5UBCx7lPtzGtxXKjNpPm2
	QCussc5hIZ2Y9gibiBL5Mgzw2LmWMIhD5yJViPb0eDvG9ffyna5W7QQgOWBYOy03rHz3Do
	6d1cKnWXw4gPBhWghmU2/LwQNfuUGYA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/OxEb3e";
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CD7F4199E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C3B1F000E9;
	Tue, 30 Jun 2026 10:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816962;
	bh=x+ErKDJZBnJk0BN/YgBPDVpN7NT+yJFm0+JSzLOIJy4=;
	h=From:Date:Subject:To:Cc;
	b=L/OxEb3etSRt/QAorUEF8M3kq8Zwkbm7HMFlEI2d6mzVGkMbHR0sFH75EsQmAmaux
	 6HPuU5YzbcWqYttygaAoio8rinz8q1jcrjnHF50OVgSed9T1i0b0WKonTJM5+fZPUt
	 Sl8uBXBQfzNO1kBTNdg9tgtpHJNS58xnsAnVIR59ULzPCL6wXRsXW8s46erGhxcN44
	 naBlPCWRlgBfF1P50VgW4HDrSEuK+bB9lnTHDXX9tlIfLaOPYRa5tb4C9kBjl7mAdK
	 mDDIVlDwEQa+ZdNU+jadPiewbEbHvObwvqw05zUDsxivMCDf5Q4tjL8VeSqNi3a+wy
	 /GiIQeOm1KFfQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:55:58 +0300
Subject: [PATCH] ACPI: NVS: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-acpi-v1-1-a9f59c04d221@kernel.org>
X-B4-Tracking: v=1; b=H4sIAL2gQ2oC/yXMwQrCMBAE0F8pe3YhiSXU/krxsJuudnuIJasil
 P67iR7fMDM7mBQVg7HbochbTR+5wp86SAvlu6DO1RBciC6GHrlHSpui8344zyRy4Qi1vRW56ef
 3NF3/thevkp5t3hpMJsiFclpa1AjH8QWGA02cggAAAA==
X-Change-ID: 20260624-b4-acpi-01183daee9b6
To: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-acpi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 20FCD20006
X-Stat-Signature: y5cz4rdxysia3yht77k4yothdxhjj9xm
X-HE-Tag: 1782816962-280621
X-HE-Meta: U2FsdGVkX1/3koBnxblrQdX5w5+7HRuA/0iEQVgrV6rHVYpz9JAKVqMmstGy7uRA6RoQ+fkG9VYhqHprrldBZdDpUA8ARx+Z4KRVVwcrVfgq3wjWfrFxsMqIbFlk159/f+cXvHg/S6L1Njz8LBPFLlCfX7ndXV2pB7zB3NZW8iEtyGQk3eMbQ8PFe0r5WZ+Ua/GMq+GjfYQUgxK20QeqfOXdue0+nmK+gCJlL+NylviuMFp7Cy7nJp9h+VLe4QXLYEQlF7Ouo7q6GZ7UTJyGyaHKg3iA6zXTFpPYPsjTBeVEq//xDQlkxCgUKDdZXzzulJXN+TMNJm7auf5MY4H8bUBHYQnnq+Bgc/eVYgCmLe0UqVXrF4NYGkO+eSeG4vdrAlmV7/aXEQFG21CCuisEJlfZmcE1WGEKfJFydG5KZ6Q32FCG8MyUg/rDGixYNJSinzocePSkkXIAKiMVFf36yGMx6WTmNHwv8OZhSQpOtIXPJ7VKfFcRgq9PGMdYZEd+n8qY7M8F72spjNNoB7LdP0lN1AfA8FRu+ghOVXDwq4xTs4qbeASBGI5Sf1Cei6g5+baC6PsDRwB4IzqlXP6FLl07LUtMOHw7igLk8KzX0D86j28iEk5ozKXLJ4DjmKoivzM4uVyADBuPbzdC2LJQWa+kkifG7ZBUV+VeL9nSNrNvKmjMC+YXqgI6kFZyv7QrMDEin8FafXto8+Qcc1MD/cGQD/SLTEJWOLWUwatZdQAOGkDMpCmxmm6dv3l10bOvayE3f2FVKVHBhsHHzh+rF11Rb0/kJ5cMyhtwq6Nfhc48BByPCB7bn1UhF5ARfLw3W7pujNCojqA47MKbGHrY8nHZD8QIhfxriBFCy3EYaVsSu1FdrcOj8WpYZDFz6dARzBPp39qa1cwD7has215hT0uE9/GOHBNgVYgBHnDY7iBOrOaudvo/9zbrnUxiie4HCsVI7yif+WRRtepktxR
 dDdH9F8u
 BgHqOH2d/VT7csCNTvNVXEVQe2gPxsQKEl2OLTvIeu1AXjfU4Kernb+FvVUTpA2EZQhvUKs9TyAJ97hoFaBlwFF+BLV22iIOT/JIyeqNrOlV1iElZ5cJCNNvn7CyOazYyz/zqsxqEWzEPrMna0RzYH7tNZZcmkbLQ4DTuGnuGRDnjub+Jvrsa3Q6Nw1xjZTYcJQ3Hm476lb63C6GoXfxu+nD3Gq8VEo/oaxyDcZnoEOtmTSJeghUf4kM+MUC3iT4K0ZDbyY+HizJHi+SA1J3Z1wxW6SG0GO4JYCuRmQFzc9Z1C8YMgN0ng1fZZmGyOBOct5szHvDJE45SGhwNz/woBfTskvo9iczg14/c0kHxKa1my+VpCprw+7HJlPH4mmF2JfeLUlOAsq1VeflxAodwT3ZnNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

suspend_nvs_alloc() allocates shadow pages for saving and restoring
ACPI Non-Volatile Storage regions across suspend/resume.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
This is a (tiny) part of larger work of replacing page allocator calls
with kmalloc:

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/acpi
---
 drivers/acpi/nvs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nvs.c b/drivers/acpi/nvs.c
index 6eaad7dd0241..12aee4102696 100644
--- a/drivers/acpi/nvs.c
+++ b/drivers/acpi/nvs.c
@@ -133,7 +133,7 @@ void suspend_nvs_free(void)
 
 	list_for_each_entry(entry, &nvs_list, node)
 		if (entry->data) {
-			free_page((unsigned long)entry->data);
+			kfree(entry->data);
 			entry->data = NULL;
 			if (entry->kaddr) {
 				if (entry->unmap) {
@@ -156,7 +156,7 @@ int suspend_nvs_alloc(void)
 	struct nvs_page *entry;
 
 	list_for_each_entry(entry, &nvs_list, node) {
-		entry->data = (void *)__get_free_page(GFP_KERNEL);
+		entry->data = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!entry->data) {
 			suspend_nvs_free();
 			return -ENOMEM;

---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260624-b4-acpi-01183daee9b6

Best regards,
--  
Sincerely yours,
Mike.


