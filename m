Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A3C606A320
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o0CadyDO
Received: by kanga.kvack.org (Postfix)
	id B06136B05C7; Sun,  8 Nov 2026 04:05:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4436B05C8; Sun,  8 Nov 2026 04:05:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E4D6B05C9; Sun,  8 Nov 2026 04:05:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68F236B05C7
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:05:02 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0509240357
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:05:02 +0000 (UTC)
X-FDA: 85411367244.02.BAFBAFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F75B40003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:05:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0CadyDO;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/5xWZuOcu5wq1ILIYVug4mJ+WQ7JQuKPaFdS0svDsis=;
	b=6m4iK6n0vdsyOSndkkWuUcVfU730/kvOiTNTzm5tKzNM7PuLbtHmqnfhrdy5cNYc36BK+E
	PCnj20zVXJKHCELyiyD34NPcsd444lH9emXkQECl0rkSqg3qaTCyt1Aem1fKGhmLqJ4MrS
	mZM7AXMSvtFjNs8ttolf7W5z+FwUPwM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128700;
	b=GV494oCtRCZdOkSuIMgKA+aeTM29ZEK2I+gLEsUEMAlFwnUCh0rB/UvzuFYLyjr9uyFhPZ
	znCud3pSRwI8iacUKDW7RPc+knj0xfM1ShYp1xbB42u4qzHdsiYOXWx0BBv6hjrF67wzjZ
	eZRYzmNxC7GdAQJE/X1TLMm/YjWQu1c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0CadyDO;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 136756156C;
	Sun,  8 Nov 2026 09:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA1B1F0089F;
	Sun,  8 Nov 2026 09:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128699;
	bh=/5xWZuOcu5wq1ILIYVug4mJ+WQ7JQuKPaFdS0svDsis=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=o0CadyDO8ch09f8UDJW0fs22/dou/hpVtAd3CkgGduDYwDI6GH0BbUIWx1HB6RD8s
	 Gf97OZWAjCWSCBGqWVAyTgcJw5LtawIKJhAK/zqWRkKCAZ3AWieT193KBlgvETs1VW
	 o6/EdF+1mAE2TWOmYuDnBSPEaHCUsI1CqVQMnbmsqxZZG0uJ35fChO0QcI6ItTJoDZ
	 gWYwiG5ChHjkhgQbeEjuKG/0b5oPJ533UpA3sl5fO25cDkyOwsl2ElvgYAT0+vF3U9
	 Oza3yy2QtLv002cmfHyN+517zx0KI90d5lp6e9nqqd4njHSHN/EhWRYkHr6c5j8bWl
	 c/+U0E0Y4O73Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:43 +0200
Subject: [PATCH 12/14] s390/sclp_ftp: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-12-3e7c90eb6676@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
In-Reply-To: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7hebgjciko7bhpik9xh8jdkpq8d7xzuz
X-Rspamd-Queue-Id: 6F75B40003
X-Rspam-User: 
X-HE-Tag: 1794128700-394932
X-HE-Meta: U2FsdGVkX1/ZI/iSsAkYUAiQV7UB4pKPB0vi4jHS5KrV8tc3i8RjOWX5S2FTDxDvwp2cURX76R3dFiAyoKU+wya3z3uJfjUD0zihxaYf4qTDmu9ajD/wEAPzxnYjCWK6mR8TnHizi/dJSp6HPP4QYtcaVPTryTIqe2sANOVVYMTCbjp5A44dT0C0htt34AX8rL7SC1maxQ3KG+aoV+yRFxJQIO6OHwThqRHZSTNVYyMDKbDUS5KCemWkOwI9CLc8WlsKVULYttf4EhabvZPjAa5d+oxSKEYTo7WRgUtWGoDuJ+qPtWxnpgh1UmJPaLkZtMjpXlY2aQoOXbNlUWIIlEdxVOvmNFD2mgATJJmZIqfxwF7WgWexH0M3Y4uFVwm/2ZltMjhHfAlJ+ILqp2OOhO0M8EsBW86eMk6LVHAdd1WnUT/KBeLBElDEnTvfpIKXuvu0CV4F+Z7TxYANpQgao6+S+nn/FJALhqJ+/HjaoUafgQmpx4Oe3tgo+3oiGcN36a06qfM3h4PV4zFxOGVwn7f3tqxVEHt51tSwhLn5P3IB57VmyN8Zrp7UbgSQnFMT7QYOCLJZhIdVfmhQ+N3sdronco4TXOyxqZataz9QNp9NZxqOcWcb0z5MrKseze0SXFtraDyOtrgXChYlWKvHz3Zu91rQ6FGuOcSoG23vVByrnax3jwTWQCX9/mW5+QLgf+NHmAD2kbHdgC5b/gmNQEhkmBujNKQaIaDXan+fBm/sryGZ9NrL+K6v0ts2y/yhqdzBuoywwk5icpGWDsjmDbzBhQ1/jfCr/5QNDAugAB/ptEhRLbjgySuXzBXzqTA4jmYlqE6zqd8yTaK3XWJttIoYkO4XxH2lF2bswoT/rQrm1NE6CIJlf57jZa29bPMTnWytOEFk0sftLawP6D3NtxS0HNixsxKZHn4ByuRU47GfXCYD3/QB0tI7JNMZxN8+zwtK1jDFVk0UBBTZsaO
 ghcq1NVE
 MYj20M77N1z+FohKW2Yz2wgREgOPg0X1nE3LTOBRBZiWruql9T3u2Xgf2Vsj9wPJtJac7x7oYLRFEetu4vXPbuzlNZmy0iBGLQcXOu/kyzUFuumlJZcT6Ig2Ki0klUwxmSYoUPgSfGS9/1boclX0HPmvbo0oZxrGloT/u4SKuOJPADlo2K1Jp6ozoiHPgyIXnpOlOpfYOJSVSmHCPQgD8KLb9IFfg+hDh0sUf6c8PAiLqbz6Ksh1ET4ImgqtAtAjWzHEqx4LmR3wRvxMXzN1asaJ540MFegW4hKUgsUgflkafW/59ZxT+WSvzqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sclp_ftp_et7() allocates the SCCB used for an HMC file transfer request
and sclp_ftp_startup() allocates the SCCB used to read the SCLP info in
the debug code.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_ftp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/char/sclp_ftp.c b/drivers/s390/char/sclp_ftp.c
index 853492d53953c..c46fd056e9daf 100644
--- a/drivers/s390/char/sclp_ftp.c
+++ b/drivers/s390/char/sclp_ftp.c
@@ -93,7 +93,7 @@ static int sclp_ftp_et7(const struct hmcdrv_ftp_cmdspec *ftp)
 	int rc;
 
 	req = kzalloc_obj(*req);
-	sccb = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!req || !sccb) {
 		rc = -ENOMEM;
 		goto out_free;
@@ -155,7 +155,7 @@ static int sclp_ftp_et7(const struct hmcdrv_ftp_cmdspec *ftp)
 	}
 
 out_free:
-	free_page((unsigned long) sccb);
+	kfree(sccb);
 	kfree(req);
 	return rc;
 }
@@ -250,7 +250,7 @@ int sclp_ftp_startup(void)
 		return rc;
 
 #ifdef DEBUG
-	info = get_zeroed_page(GFP_KERNEL);
+	info = (unsigned long)kzalloc(PAGE_SIZE, GFP_KERNEL);
 
 	if (info != 0) {
 		struct sysinfo_2_2_2 *info222 = (struct sysinfo_2_2_2 *)info;
@@ -262,7 +262,7 @@ int sclp_ftp_startup(void)
 				 info222->lpar_number, info222->name);
 		}
 
-		free_page(info);
+		kfree((void *)info);
 	}
 #endif	/* DEBUG */
 	return 0;

-- 
2.53.0


