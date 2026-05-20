Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BDA7CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 022036B0005; Wed, 20 May 2026 04:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14C46B0088; Wed, 20 May 2026 04:16:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2AB76B008A; Wed, 20 May 2026 04:16:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D13396B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:16:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 341321C0110
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:16:13 +0000 (UTC)
X-FDA: 84787090626.14.0D31CE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 618CA20010
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:16:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DrFPXo7B;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779264971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8cLE9GJnLxVk1PO/q0NbGrn9yaBQPal5piuLn9fXCpo=;
	b=ZIxeqJZ0DYDVO1q87NqU7pYWEyMhhz0POW5YS3+Of4F9Ws9YqmmPQh+T7AtQsIVmglJoqv
	Mr6UNdWNEaNV/2PnaXBxTB9iMK3Cyy/WC4LQz1/hWu4vXpoy+dW1lRyT8bqNHx5Nl99KKt
	jbHshPrNf7+Rm2NiIBMUxoIl+12IOUs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779264971; a=rsa-sha256;
	cv=none;
	b=lSGQlMWz+JiY/KhuZuvuSnvPhvhc+C6pgMmxmj71JsMv7nGw+w8ysygwz6g4G+xc2vQS3j
	fGtzcvsIuFInmI0XxqEnRL3iPi2m1OQdiN94HwMbIs97k/+OAEtPM7GPiL//Qq4g7AhWXz
	hE82r6errrY9Nfu+TJbcGDxcSkU3jWw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DrFPXo7B;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F624442B2;
	Wed, 20 May 2026 08:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278B51F000E9;
	Wed, 20 May 2026 08:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779264970;
	bh=8cLE9GJnLxVk1PO/q0NbGrn9yaBQPal5piuLn9fXCpo=;
	h=From:Date:Subject:To:Cc;
	b=DrFPXo7B++pdx3NrXXms9mMsON/Ok7u2SsjXcACX1DaKEI1JD2MdNdgKjQiBy1iP+
	 gKv8O9DPKetOJstx20jQX1sP7IJx7t1y/HR7J/AqWicvkNkRpSTxKT/f1dsN8sw3cy
	 uB1KHEzTX5jjmXDf0d1BsS9bfMxA4D+W94p2fmkNxdjhgprzSuT/Wl6RgNpdgagFss
	 dY0KYxEtWhwqIa0LZs9up/9z0/yeMF4GViFaHt2xNttm2IUhfxnxMeL6pqNp17CvHM
	 m0+NFDUXYb2TCQKpHX9wfRI1CsA6hm8pIBQq59YqkeFQqWV7IsxSrcgf2akTPijpHm
	 1y/+tO++sgJfw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 20 May 2026 11:15:52 +0300
Subject: [PATCH] block: partitions: replace __get_free_page() with
 kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-block-v1-1-6463dc2cf042@kernel.org>
X-B4-Tracking: v=1; b=H4sIALdtDWoC/yWMQQ6DIBBFr2Jm3Ukphtb0Ko0LwEGpFgxjGxPj3
 QW7fD/vvw2YkieGZ7VBop9nH0OG26UCO+jQE/ouM0gh70JJgWaKdkSpVCMfqnZd3UB250TOr2f
 n1f6Zv+ZNdinnYhjNhCbpYIcy9W7GJeL40VMOXs8q7PsB2IcTPpAAAAA=
X-Change-ID: 20260520-block-25582753fd38
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Rapoport <rppt@kernel.org>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2038; i=rppt@kernel.org;
 h=from:subject:message-id; bh=iVaqBtFYBCE5KYG/yGAvVZf7o0sXkVHrzQo9ScdcIiA=;
 b=owEBbQGS/pANAwAKATkDhibLDv2RAcsmYgBqDW3FFxdymUm74+B5Ltlyqex2ijloRdLMdORm0
 p2SqhAPO8uJATMEAAEKAB0WIQR45VhVpZkvn3TRr+k5A4Ymyw79kQUCag1txQAKCRA5A4Ymyw79
 kbSfB/40Fp7YEG2dDGt/X0/HW800n7ahFnLVCASurAwFITkTWouSdJmXfW7Q5yN3DXeXpe7J9fY
 5LiCpvqfIomNQY9GNKwa0SDRYb9MMZPD8/l5ovQYoeNqAyE/ZkkHl+PZTzsfXuIgxqnfpIrtbxY
 WK/+VhPxvau9u+gBYousFs8a73T2fMNNt6zjC44KpXn61rrV/nXt1iSZcGhTmOL8ZD4X1uyRWpd
 Lpirl5zEla1UoklSDYdvwq9Wtv0blWB6gIbr7zbhUmwLNmhUYE18DVXzo29rYjwprjXWIoaZKMI
 oILc8Tg+Dkp5URyIzO1PO1Uin9i1qO8d0EFxo9zsilFDYIAz
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 618CA20010
X-Rspam-User: 
X-Stat-Signature: juo986xsftn4xuqrtdybg11fae3knhgg
X-HE-Tag: 1779264971-966705
X-HE-Meta: U2FsdGVkX19yql6u/D4F8qUiTzMpCJm8sTVwKlSMwyi/0XFU7bVmsYLm3UkLs3f2znr2I4IhA8TvGtAoe6WYcrA95urUTtppNXMyd+i+0vf2K6TCFJA0C9qDMqm/GqC9pL7N9JI7pCB5MbBBCeEfFLgoJUw7NarSMgSkCjATXzC8gtQGQH8fKiZLyoIfwUIElkGrAf6qzzNyc0SHdFXlkOCo81qCbzxwTFzFiv0N5baEnBouvytS7oINYlMy/p2nm0XwzrkUv2qF4tK2By/97y0nSrQby8aAPjwb1t98GIToDeXHmqwVBIGianOzNu/Sxhde6XnFu2NMKbextDZCa/0UU+DQ9ojqsbPtfq6eUkFiV63r75Y/CGeIB3g9uZC5sLAHhSClXpc3zOFoAnS6QewWG1yPvAutLy4hImWrILaMPt7X6O4WRLf8OF7tL55p7EGz3OoGYTiCeAOAGWgli4ucQvvUBm1YZVZ6hzGmzt8vS04XnVHt5DU2xjgmIMUuKNjP16NPI+C+POm816lY+GVxmeJnXct2jhr84Da1zpiqbljDOGY6yZ0F+THiyX+0BDm46wnCO2F11gRlQ/Jki2PES9cpkOzqPbrM5pDs/4kvtUM1t1bYYQdzcj4dNCRlMRw+AQK37F82uH4avL8de3xFi/4hTw2cUnNBGzy7eE9SmM2Tm+hJ2vuH6JMiOfMaP2ynyJo+87qp1xclijexALZEXP46pL4gED0nvSzXtD2EHoOjWkfrXhuKl3Gp/K1AWlxxG8f2LW2V/V5FzMtFOc/8pzvDLBoPCpLjf2ZTY/rt63bAXYkphWUwZ6egOQJvo1hmXpILWoAuOV62Kgc8hV2pahkTm8PGVFpTk+sjJOUocORvOZ984d6kVEIwtK/TFxWwTpEEIYNlIl143/1l2gOEGCc8Dl0+a5A4H+vYfc183GeVURyLxFGNnh7DTVLn52dc3lulCI/MqW5w6H9
 WmKGNTTG
 /b9JdklXY2A4ZXk60SdA/8z0WSp/aUrWSSVJ4Fqr6IB/T2kZfbsfhuwQfyg5tcb8PmRx3OV1mM5W9+yCEE6mZ+UWGtmcGoPhw8RGkHRINYO9yFTcR7C5MjKe7oD/lDtJZNp8wEAeGUXOkuIuJD8k+Jf6dtymsA0SFzqSSkYfZz1nepocV35D43zHXlBubBp8EdZC7WiJLd90BT1lJgYu8nE9sqzSIUC94qwnZMCYoiLHtNu4u/nIEzRuZ0cULq3kAJYUBQD8dMHbgbP5hevUmJnmzgOEle5AwqxsUKcIn5yXoHcRt5U4i4TAidg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_partition() allocates a buffer to use as backing buffer for
seq_buf.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
This is a (tiny) part of larger work of replacing page allocator calls
with kmalloc:

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/block

Signed-off-by: Mike Rapoport <rppt@kernel.org>
---
 block/partitions/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 5d5332ce586b..b5c59b79ca7c 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -124,7 +124,7 @@ static struct parsed_partitions *check_partition(struct gendisk *hd)
 	state = allocate_partitions(hd);
 	if (!state)
 		return NULL;
-	state->pp_buf.buffer = (char *)__get_free_page(GFP_KERNEL);
+	state->pp_buf.buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!state->pp_buf.buffer) {
 		free_partitions(state);
 		return NULL;
@@ -154,7 +154,7 @@ static struct parsed_partitions *check_partition(struct gendisk *hd)
 	if (res > 0) {
 		printk(KERN_INFO "%s", seq_buf_str(&state->pp_buf));
 
-		free_page((unsigned long)state->pp_buf.buffer);
+		kfree(state->pp_buf.buffer);
 		return state;
 	}
 	if (state->access_beyond_eod)
@@ -170,7 +170,7 @@ static struct parsed_partitions *check_partition(struct gendisk *hd)
 		printk(KERN_INFO "%s", seq_buf_str(&state->pp_buf));
 	}
 
-	free_page((unsigned long)state->pp_buf.buffer);
+	kfree(state->pp_buf.buffer);
 	free_partitions(state);
 	return ERR_PTR(res);
 }

---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260520-block-25582753fd38

Best regards,
--  
Sincerely yours,
Mike.


