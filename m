Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B023CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:45:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B638E00E1; Tue, 14 Oct 2025 08:45:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EBBB8E000D; Tue, 14 Oct 2025 08:45:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA6D8E00E1; Tue, 14 Oct 2025 08:45:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 562FE8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:45:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1764B140780
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:45:05 +0000 (UTC)
X-FDA: 83996689770.23.66B6A1F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1D32140008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:45:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fzwZcz4a;
	spf=pass (imf11.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760445903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oq5FU6UUWvw2KLYz4msTSjy80Lvwg4TbSIDB93lwHNo=;
	b=v3NcBXgC8Qsa0SB6eQEZH1Q20KEFP9Ta4hfBvru7Suhol7fzVjB3q5xupwReZE+m6WplE4
	Xpresa90jLzuaVF+qf98vUwkjC/tLaW+Gdqn92frZNZEbIRiWOGLCuCGWMGW1IFMnWdPCV
	zV4UXx1QX8zbCvoEhJtdTVpDEHLhoqE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fzwZcz4a;
	spf=pass (imf11.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760445903; a=rsa-sha256;
	cv=none;
	b=5kmZLrL7jFEnTmqQKRuL8VOFekMLQoMBXYQU8OBQlYkR1GGiBVodMxk9y7Sm/SS0PY7wsm
	JTcLvebqd8a2N/TclQLpCsVkSwKhVrQhaT5Yhd6sHh+VOWO942M8emkbU4c7auBNJ9Z0TQ
	HvkLSCemxlvpAZ685DbHhNF2dmcP8qQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760445902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oq5FU6UUWvw2KLYz4msTSjy80Lvwg4TbSIDB93lwHNo=;
	b=fzwZcz4aQnpROhRt8r2vCUflsJwM3CKkapPcpNpRXSVmUj84R6Wq8TTCH3zLrEHd5eM08t
	qDITKgLivdvSRF3wxTLNomq/6FY+bgO/DD8OUSONi4PmtadRAOjS/X+qNQNPqum0ML4z1z
	zYLEluyaEzm2GeRATlEVQNn8/UVMDDI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-OK3bvKPEOnyMUdO2_OEm6g-1; Tue, 14 Oct 2025 08:44:59 -0400
X-MC-Unique: OK3bvKPEOnyMUdO2_OEm6g-1
X-Mimecast-MFC-AGG-ID: OK3bvKPEOnyMUdO2_OEm6g_1760445898
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ed9557f976so5612362f8f.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:44:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760445898; x=1761050698;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oq5FU6UUWvw2KLYz4msTSjy80Lvwg4TbSIDB93lwHNo=;
        b=Vhji1jn7HDMin/QbP6U9RkJ/Ku6YMKD0VAG0BtbQBDgkgKI/dkmZ6b3C8d6ok0IRq6
         PDCXVURClPKvFM1gbWQ01SwRZEwOVpXiLCkEH0UBV4wFU7VLlW6CX5B8b7T9p3ySDZWZ
         cuPgZDLsrtcx2mhOXq+I4mgQl3PibQdk6w+Uw8xMeHKQUWBCjd00QSZxgR7m4KQqZa3t
         z02UDLnc/9QZ7EwJxnLrQPZevpZ1yyuTHUTa8wA4m2+Z1YY2QD5/e0cWqPzJOG20I9wx
         yL6/2LLKIRApImpudQi2OEElirAbHj4OdmTuBGkiWovWGkTm+YXMP5Mki2tl3pJIBfEx
         u39g==
X-Gm-Message-State: AOJu0Yx2+hE5inOOkXig2FiJ6GPrXsomAnuso/9DzhX5JVzGR78vlao6
	ttxhf7BFZwiiNjCnmQylEwLFmEMYdQ0P4zf7ZC6J2h3euzPEB0bwP17gIaZww0zaTFP8Az8NJT9
	hLtIHPNRdxXiolAbj/4H3o6LqgC0v/WuvjWUeUF8hYDUacz2vZ4Yu
X-Gm-Gg: ASbGncuxgCVfF8YZ8OKlGZfAiN7GbcOL7AzuI1twMy/wXYK1LmICWGWeZszjvUfLV3g
	dcsFCBFqFPAYO563i9B+bimoAgfhNFCLIYRXT+svv4o7JpOwW2iE37l4U0p0psT1PT0jW+H+BSP
	Msft4nOZf8jWTB6o4mhwuCHRHa/DTG6bv/I/1oI5JZc9dr+Kf6x/MarPKTOkWL6E0BktP9wmfie
	jSXbod52S91BUcuitiCul23HB2J42K4tSZt92cAaUNvRsxRdITLYy0oE4utsa+xOaMb1zY4nAt1
	ujW1DtsxiUfb7/HuMr/g4IrwcEmgyit1LDs=
X-Received: by 2002:a05:6000:2003:b0:3eb:5e99:cbb9 with SMTP id ffacd0b85a97d-42666ac410emr16251738f8f.10.1760445897956;
        Tue, 14 Oct 2025 05:44:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxSeyruCmc9SGR2jeGa4d8IULuUIdP5u2aBzan4Fq5iEL1yjTsOV2vBHOnBmYhi1j6hNaRzA==
X-Received: by 2002:a05:6000:2003:b0:3eb:5e99:cbb9 with SMTP id ffacd0b85a97d-42666ac410emr16251717f8f.10.1760445897499;
        Tue, 14 Oct 2025 05:44:57 -0700 (PDT)
Received: from localhost ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-426e50ef821sm8878961f8f.38.2025.10.14.05.44.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 05:44:56 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v1] vmw_balloon: indicate success when effectively deflating during migration
Date: Tue, 14 Oct 2025 14:44:55 +0200
Message-ID: <20251014124455.478345-1-david@redhat.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DkuTuRAG5tUVIlf5xoT_5lpKWwRpcZmymTHPZrAX9Ks_1760445898
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: ge4gmdpj7mtocxt9zg47qcjmyzq1rmjr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1D32140008
X-HE-Tag: 1760445902-3295
X-HE-Meta: U2FsdGVkX1+ZKc3J98JBouMeij4kKvSBhSWhVRTqJ6BAPyy56d8NJ90yqt4vg6Vr0Z2HrMq+9aPnpBZtpAY4ofTu5bjRdeVo+76Lzx/MZRpr3s2gqku8sbaOBOtjSs//K5ZCPsADTgls/088mKUuB3R5uVFjSV4MPnHk9r1q947ylgvVpiKNzdcdJEOA7xeZGA4WlkO8f7Q5ky+88HNzgevVlerEMI/2hpQ4ToeuGJF5bUAk66rgw49sXjVIt+g7NrWgrfuw8FTnDSpDFihzivpYXcC6TZIutJHEO9zpTnfDIZyxVpwcwqeKvJufZVnEjciFh7ED+uf4EoKrwcE0+j2zbixYMN/e+76oGm+YHsLltaU4ifTcxES5jeu0JjIgPiSdNRAXHyY4haBzmc6ylv3mbHM2wksGEr4VC2PxKUIu4fSXo1L1hrz8gszTeVMI7UD1EMVvo7lKGzZncntMmjpuq1cQiYfdD04TLs8dqahbeQMyBkDgwFXZIVMUbDklkYjHSbL3/IRHuMnG3YGvFWLHF/94zBQ8zLZJtftL1bbHxgG7xUgX1TmSC04X3QHxopicTwQWglpS4vjBaHEio8cYaneYYRg9rgBpAGF2tHZGAXEL6oA7NmQpn7sKXj8rra4FIZAalUDnk8XDnrhiO+tebnJwEw8xh52B7dIYpa08PEio5GtdFDHrUlBGlybY2qPMkLFKv9d4q6fCB51XYuCltuRBPGqo76RBAcEcWLmtDY0Q/v9aAxyYQKxRY1XFtpkXBZIeGu+Za9pOXTLeXMYpCDnOIp+DyqbFWh7ZhtTkeD1jz303xAzKH4qxgkSVZT3zmLmuD0g3/NSv0bk4NBBC6z8or1dfB+9ZiDMEoKJ8wY6x7De5XFY3VCyu+4P/rzgIfuN/ShzMMSvhZ5wqpMhIAcvImrZxb+Mm74DoSaKNqmcocvC2Q0vIxv/8WCdMjkW2ofiT0EOKcvHIMky
 yAMtM/JS
 zVj02K3aXXgxjWqoQj1dI6t75Sj7Zfwe3RpiDSAYdbyr9LWDW3bSijPsBQevQyBomWqBqKtIs6vG60LQR+lD4VUVjrxDASf+9yi3lcMHw4b7f2R/Z2++E7z9M1FocOacNCN6zbJXX7DvqevZeO7+k3Dfzi7QuIKhw5Wb4lvmYRokkiXrY9mGM530G2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When migrating a balloon page, we first deflate the old page to then
inflate the new page.

However, if inflating the new page succeeded, we effectively deflated
the old page, reducing the balloon size.

In that case, the migration actually worked: similar to migrating+
immediately deflating the new page. The old page will be freed back to
the buddy.

Right now, the core will leave the page be marked as isolated (as
we returned an error). When later trying to putback that page, we will
run into the WARN_ON_ONCE() in balloon_page_putback().

That handling was changed in commit 3544c4faccb8 ("mm/balloon_compaction:
stop using __ClearPageMovable()"); before that change, we would have
tolerated that way of handling it.

To fix it, let's just return 0 in that case, making the core effectively
just clear the "isolated" flag + freeing it back to the buddy as if the
migration succeeded. Note that the new page will also get freed when the
core puts the last reference.

Note that this also makes it all be more consistent: we will no longer
unisolate the page in the balloon driver while keeping it marked as
being isolated in migration core.

This was found by code inspection.

Fixes: 3544c4faccb8 ("mm/balloon_compaction: stop using __ClearPageMovable()")
Cc: <stable@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---

I have no easy way to test this, and I assume it happens very very rarely
(inflation during migration failing).

I would prefer this to go through the MM-tree, as I have some follow-up
balloon_compaction reworks also mess with this code.

---
 drivers/misc/vmw_balloon.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 6df51ee8db621..cc1d18b3df5ca 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1737,7 +1737,7 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 {
 	unsigned long status, flags;
 	struct vmballoon *b;
-	int ret;
+	int ret = 0;
 
 	b = container_of(b_dev_info, struct vmballoon, b_dev_info);
 
@@ -1796,17 +1796,15 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 		 * A failure happened. While we can deflate the page we just
 		 * inflated, this deflation can also encounter an error. Instead
 		 * we will decrease the size of the balloon to reflect the
-		 * change and report failure.
+		 * change.
 		 */
 		atomic64_dec(&b->size);
-		ret = -EBUSY;
 	} else {
 		/*
 		 * Success. Take a reference for the page, and we will add it to
 		 * the list after acquiring the lock.
 		 */
 		get_page(newpage);
-		ret = 0;
 	}
 
 	/* Update the balloon list under the @pages_lock */
@@ -1817,7 +1815,7 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 	 * If we succeed just insert it to the list and update the statistics
 	 * under the lock.
 	 */
-	if (!ret) {
+	if (status == VMW_BALLOON_SUCCESS) {
 		balloon_page_insert(&b->b_dev_info, newpage);
 		__count_vm_event(BALLOON_MIGRATE);
 	}

base-commit: 1c58c31dc83e39f4790ae778626b6b8b59bc0db8
-- 
2.51.0


