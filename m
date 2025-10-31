Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B93C1CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 19:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3C58E00DB; Fri, 31 Oct 2025 15:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB8C8E0068; Fri, 31 Oct 2025 15:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A9E8E00DB; Fri, 31 Oct 2025 15:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0E878E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:33:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 92E7F59635
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:33:36 +0000 (UTC)
X-FDA: 84059408832.24.AF19B02
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 82B7F14000F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:33:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HxOox6bg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761939214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aX/UYGyfT3leoZk+snX0p7Zlv8DRsK4nDYm1uUOo7Pc=;
	b=gFfSnx966OEgHa8uz1RG6aR8xZ8Y5WMfXCbzVmXNR3mpEEsRyVjqRLVjPilf9h6TC4KM0S
	5Q/XJAvQnv50GgZ/xeNxtevBrk8o9WbRpQxDQZLIQ0xcRsYdle3ilV4KpN8VCLEFl+/I/q
	UfyvbqSzOfBN7w59fBvtbA+b06UaUxM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761939214; a=rsa-sha256;
	cv=none;
	b=HnBefbXSIGmjMXqfaLI+K4KRPKgWb1xwnxLBe7YEy4GUFQpKX8X+b5vy6jgib5bm5NwPvB
	Dva8azZJSRi/cV4DJjDgowJXZmrBx71z081atvScL/+AmSxQghY4CTyK3WWqthmDJtVGLm
	bXqHPV+l2xm4//OZRLxOi89A6tSFu9g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HxOox6bg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761939213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aX/UYGyfT3leoZk+snX0p7Zlv8DRsK4nDYm1uUOo7Pc=;
	b=HxOox6bgKqACMoQ4GheKT28ssEoMg6nMvg1we08moxRAEN2YgVRrBIKbbiWjpPbGkTZNGM
	NmA6RLoh9Y042Sj7qo6EKsx4CX7LvaOhVNqcJz0bP+8PG/KEsV2N8ymtxLK8smnlIh1P3Q
	qj2vWTdp4+N9Y1iKb2r0LJVemMChkrk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-191-F_Jq7KkVMGSxVN2YOi909g-1; Fri,
 31 Oct 2025 15:33:22 -0400
X-MC-Unique: F_Jq7KkVMGSxVN2YOi909g-1
X-Mimecast-MFC-AGG-ID: F_Jq7KkVMGSxVN2YOi909g_1761939195
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE8CA18001E2;
	Fri, 31 Oct 2025 19:33:12 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE1A51800591;
	Fri, 31 Oct 2025 19:33:05 +0000 (UTC)
Date: Fri, 31 Oct 2025 20:33:03 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Askar Safin <safinaskar@gmail.com>
cc: Dell.Client.Kernel@dell.com, brauner@kernel.org, dm-devel@lists.linux.dev, 
    ebiggers@kernel.org, kix@kix.es, linux-block@vger.kernel.org, 
    linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org, 
    linux-lvm@lists.linux.dev, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
    linux-raid@vger.kernel.org, lvm-devel@lists.linux.dev, agk@redhat.com, 
    msnitzer@redhat.com, milan@mazyland.cz, mzxreary@0pointer.de, 
    nphamcs@gmail.com, pavel@ucw.cz, rafael@kernel.org, ryncsn@gmail.com, 
    torvalds@linux-foundation.org
Subject: [PATCH 1/2] pm-hibernate: flush disk cache when suspending
In-Reply-To: <de1f0036-84f9-2923-2c0a-620e702d850b@redhat.com>
Message-ID: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
References: <03e58462-5045-e12f-9af6-be2aaf19f32c@redhat.com> <20251027084220.2064289-1-safinaskar@gmail.com> <de1f0036-84f9-2923-2c0a-620e702d850b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam01
X-Stat-Signature: 7zta74n36zxzkuge8xioocno3ykaab8b
X-Rspam-User: 
X-Rspamd-Queue-Id: 82B7F14000F
X-HE-Tag: 1761939214-924643
X-HE-Meta: U2FsdGVkX1/3Sxb2baCr55pOXyWxS6ZzZvU8PLNR+WsMn+4smKhUj9gYo9IaZ2LSLOKvyCOk2LJdzeiwYS9+5S2/9RIPLdpu1Fw8pvOpUp+p3kosZYcJyP9tnCDSwSdj+LQ4miZi2L2qH6iCIfCSyEDZt9d1XqhEDo0GraXizJxBaMSVcUeEVObaiYyXSy/YKe3zjr5sUARl2BhReu7VY+UyHHLFxmr4Dwh5abIjxatdzHXRiSru8HfNChwzdxFcy44PCgjlaPLCKzFPYuWnC39OAyaB/rGE5TF5SqTcXZIazsm/w3n+mKUM47jWiaykYrNouqI0uOB50MBHJflCAETu/9xQg4k+R69PB0iPv4U75P8jeoRIU5uTBayqh6i5NGq+rZ9//3Ona2UACtU58f1madzHNVBcCaDnK6iAqJYwXRVeeq5NQRzduWYcYK6KFMeN3WBImv1jj9ltoruqWp0cWp4mzDoxrsxbHzqT9f1yAcsoBryx8Qj044kfOHnPF3lEM1RoqK8Zuf1KWBUv53OoDNqPbHZ7lTGQR2VJ+oCmQSMkwgPS5/wVEjVZHoxZvVn2QW9y4bQe+r1BqVheCjKS6kBc+YMY45jnB4OaToXYaotTFtPl3HP/VbY4JG6O00IAUxspvpJoAqEjF4eATQQLmSPeNPaw3p9FogulmN7iQq4kHOQUBaFnPS2ibAvVYKqjnpyiTB1B6EIZkNiAu7qvXcLsfU+yi8GMJoUSnVuTv+BfdzeQaZIlgjmALc2g9Bcw5ILNasJR6XwyOgDcP9SiB0JuER/VaV8Q2yZlkTsWqJRIkeD4b7wZiLIjxLvRVINlmzrxuiu59wLMoiQ6w/jujeOzciPv8alWqgvxtvuVWtj4XZll6d6mP2kjMGcGkZLygbtnMh1Ka0I6pIT4XE2qeFbA6V2MRNDma9ZlYmSRsIqCg3hRWme5gkWNkZRVuafWOAo+k/lGd9djYg6
 4nKy+Gle
 2a0JVFXTJoWNNGSBtArvYrlSsjegaG8VKGJIluWVd3X1DGIQFwTgiqvLf8ZfCmIBxriF6YDcqwV0jDB4TSH41Y2wtdvA+1WhvLc8KYfWb9EaOY4lVsKSiGWJNxBY/3PlWGsSsGPcpdRT1K7R6EbgXieeJOaguCpnlAa7nR+69EcG8/hXCmpB4j7yagKDDhYCzm+ofOTbqYPkuJTej6TTTN78hiN2+UERETL6wzRI96Xz0sQJICxi7Hkd6JiNB/B7k9Tikcy4EpBhCMcz3QoQqeh6QTIV9zJiZE7Ke/c0XT9nufeZ5M6Wx2KALq4PVhe6z9DvXod1nshBcUORz8jkCPXJbcuzxk93vyFOa+wwHwSsIBbhMdTcltEd2VWu3AleOPkUGJ2/O8nDF8o0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[PATCH 1/2] pm-hibernate: flush disk cache when suspending

There was reported failure that suspend doesn't work with dm-integrity.
The reason for the failure is that the suspend code doesn't issue the
FLUSH bio - the data still sits in the dm-integrity cache and they are
lost when poweroff happens.

This commit fixes the suspend code so that it issues flushes before
writing the header and after writing the header.

Note that the system may lose power during suspend - in this situation,
we don't want to attempt to resume with invalid data. So, we flush the
cache before writing the header (with REQ_PREFLUSH) and after writing the
header (with REQ_FUA).

The call to flush_swap_writer was moved up in swap_writer_finish, so that
it writes the data before mark_swapfiles writes the header.

REQ_FUA is also needed on resume, when marking resumed image with the
original swap header.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Askar Safin <safinaskar@gmail.com>
Link: https://lore.kernel.org/dm-devel/a48a37e3-2c22-44fb-97a4-0e57dc20421a@gmail.com/T/

---
 kernel/power/swap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/power/swap.c
===================================================================
--- linux-2.6.orig/kernel/power/swap.c
+++ linux-2.6/kernel/power/swap.c
@@ -320,7 +320,7 @@ static int mark_swapfiles(struct swap_ma
 		swsusp_header->flags = flags;
 		if (flags & SF_CRC32_MODE)
 			swsusp_header->crc32 = handle->crc32;
-		error = hib_submit_io_sync(REQ_OP_WRITE | REQ_SYNC,
+		error = hib_submit_io_sync(REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH | REQ_FUA,
 				      swsusp_resume_block, swsusp_header);
 	} else {
 		pr_err("Swap header not found!\n");
@@ -486,11 +486,12 @@ static int flush_swap_writer(struct swap
 static int swap_writer_finish(struct swap_map_handle *handle,
 		unsigned int flags, int error)
 {
+	if (!error)
+		error = flush_swap_writer(handle);
 	if (!error) {
 		pr_info("S");
 		error = mark_swapfiles(handle, flags);
 		pr_cont("|\n");
-		flush_swap_writer(handle);
 	}
 
 	if (error)
@@ -1587,7 +1588,7 @@ int swsusp_check(bool exclusive)
 			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
 			swsusp_header_flags = swsusp_header->flags;
 			/* Reset swap signature now */
-			error = hib_submit_io_sync(REQ_OP_WRITE | REQ_SYNC,
+			error = hib_submit_io_sync(REQ_OP_WRITE | REQ_SYNC | REQ_FUA,
 						swsusp_resume_block,
 						swsusp_header);
 		} else {
@@ -1641,7 +1642,7 @@ int swsusp_unmark(void)
 	hib_submit_io_sync(REQ_OP_READ, swsusp_resume_block, swsusp_header);
 	if (!memcmp(HIBERNATE_SIG,swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->sig,swsusp_header->orig_sig, 10);
-		error = hib_submit_io_sync(REQ_OP_WRITE | REQ_SYNC,
+		error = hib_submit_io_sync(REQ_OP_WRITE | REQ_SYNC | REQ_FUA,
 					swsusp_resume_block,
 					swsusp_header);
 	} else {


