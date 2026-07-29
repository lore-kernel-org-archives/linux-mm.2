Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D80EC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48A126B00A5; Wed, 29 Jul 2026 10:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461366B00AA; Wed, 29 Jul 2026 10:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3511B6B00D4; Wed, 29 Jul 2026 10:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0890C6B00A5
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:07:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80E7A1206C4
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:07:45 +0000 (UTC)
X-FDA: 85041992490.15.21FFDBA
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id C59F5A0003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:07:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b="KT/FUem4";
	dmarc=pass (policy=quarantine) header.from=nebusec.ai;
	spf=pass (imf25.hostedemail.com: domain of zhilinz@nebusec.ai designates 209.85.214.179 as permitted sender) smtp.mailfrom=zhilinz@nebusec.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785334063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XLkmGuuq18IHP354DhjjEnF2Z8bNgGhJQgcALrtgbCg=;
	b=EUhFqwzDBfqYcBuPJUGe0FX1SBX7Lk1gsMceu1zxEFP4Bjmwkg9L93zJ8i8MbEh2agfyT8
	X8MwvPD6SLMNhxIf7LK9y3aYH5thBUsJLF1q3a7X8t5vcwVAxpdzQINDj4PtwKoU1mCPxT
	i0w0DqPx4y5YEb5S2c6tfOenzDOsZKA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b="KT/FUem4";
	dmarc=pass (policy=quarantine) header.from=nebusec.ai;
	spf=pass (imf25.hostedemail.com: domain of zhilinz@nebusec.ai designates 209.85.214.179 as permitted sender) smtp.mailfrom=zhilinz@nebusec.ai
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785334063;
	b=xcFKyt8IKyBV7wAlb1MMqPwKDYiWYdvKBSlTbTyz0j4MwaDsviKMC92bGqTspTLF8pDf7Q
	9p1IISmsqnxNA8axV8efdkhHriVqvrYoBQ0P3/Mgf+XRS9nte91jym6+WQlancWB/WpCM9
	vPT1hu92X6dL1C8Acmrz/atUgIbU09Y=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cc73e322dbso12148625ad.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785334063; x=1785938863; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XLkmGuuq18IHP354DhjjEnF2Z8bNgGhJQgcALrtgbCg=;
        b=KT/FUem4UCJo8k2c2nIGIx+5ydxamPzmx2BZo+gwYt1NggeNOl89BNuVnXYg+8w2qh
         /a3LCneyzerZ7Moptl0n/452dj8nrseF1BrRHfQfyhLgbWKufH0FfmOnvWGc3RVuczhO
         tfz7wLzSdhhRwN789OY9yJ3CpIA+76+nJ7eEDrbgkgESPsk+t8eNRnugX9wOmIhUfVKR
         a+3dqFAwYEAVNIy6gtW0C04TBCv0sP+cnOR1V7Hu+D1Coxm0kHSwt65oBbgkolJ+ygi1
         g4XnEsAN57HYQSfzZzcR7woChPPJ8gtaHr7ykr99MiyOlzhhAAaXgaoFKCO1V4Ov1x1x
         kPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785334063; x=1785938863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XLkmGuuq18IHP354DhjjEnF2Z8bNgGhJQgcALrtgbCg=;
        b=Yv2ZzsTckDCepPtXGgdvEry55T1PwlHkm3nW60YuMhrSvjMOfugIIRAha06irRdczo
         2sxr3yXN5xxYMkv24kjnE/tfkoZiQHy2FlsxqrbxFxdIqiYeZ6Dc0gep49jwyowhLuuQ
         LshK/+UtoC45JqUkyBpeZIUWA+f3UyfGoO7Q4DG2qzDAXpmOmViNDsHkWjG7jJVVdvCo
         UE2961e6nnYc5sEeFnoJyn2GcsYE4mtEOe2THgyQmVakLcoE2pW4WhH6xrX47Hfq/Y8/
         kwWbpAumffghKtZowbvY+7X5WfZUp0q0IGCWLICgIjfL9O4PavDe/KYZaoxnmnNMy6LX
         jL9w==
X-Gm-Message-State: AOJu0YwLsns3tJFUJO40R8/an5F1VYfotpDzdHwhDLmSlCa+ULUVIKma
	sSc5HsdjjVJADVKCAm3/8Aj47Q/FlyVAeryx5j5tcXWBAy8KKqAh4En5UOLHYj/3bVbr+jel62i
	v0x9TGxhemM4=
X-Gm-Gg: AR+sD105ebHYkhZ4LrKVj8c4+6bdGRWxFIQSH36HFNA/hVWuPN5VpSef2YFobYak3P0
	mA8LIlQCa83/hyu1BU7x3iJmWrH0p5kHYS4z0+qRbqnf+DYKdmokP5OVq7RrKYk82JgQkCl84am
	vIwsV24L/EzBcDR0a+R2tsf3t6vy2F6vUMi0TlXLY+7TuRLAYXlAgfRfzWuJ7zS6QDETXlb8gWk
	5+NP/wlCaFOcFn+h+vJdhAOl6WOG2WJuNJ6nlAPG+scQjWWcf5Wxt5RelzuVyydwcf65VEa+veG
	M/AaiAgyr3iqUvi6MNJOWlb3sI+VdnZW7HPRN6MS982TZyWALSHh8DKJhmJZGGcfOlfynCkvLwT
	G/ML7caKQJknczll3qQX87y+j9JIr3bNmqG2lO/a/SHPY1PQg6s7gevT5zGvZrWI2lerPl1so3f
	hCQYa29e19GeeazheLZ4+Prwj/LwYVv0xAZVhAYWLYW61TwGkI9TGOP4y2DFA/PTMabxKvV+ivX
	y/Hb0dXFos4FrPZ
X-Received: by 2002:a17:903:1b65:b0:2ce:d34a:5959 with SMTP id d9443c01a7336-2d015dc8e16mr80390685ad.44.1785334062438;
        Wed, 29 Jul 2026 07:07:42 -0700 (PDT)
Received: from Roxy.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a48858sm12034405ad.30.2026.07.29.07.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 07:07:41 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: linux-mm@kvack.org,
	baolin.wang@linux.alibaba.com
Cc: hughd@google.com,
	akpm@linux-foundation.org,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH v2 1/1] mm: shmem: reject page-aligned fallocate end overflow
Date: Wed, 29 Jul 2026 22:07:30 +0800
Message-ID: <87a63846fe9873b1e26e8a7dcafcb21aa8d709fa.1785309651.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C59F5A0003
X-Rspam-User: 
X-Stat-Signature: uu6b74ysnhkjarsp6k7s75bkqm71ee6w
X-HE-Tag: 1785334063-435986
X-HE-Meta: U2FsdGVkX19UWVPXM8CyZFFQiNmlLjhHKEY4ioj6eAYQu3gGRJLqkUyC2jw7MDYcCgjeOvCj0J8Tqh2BJFwDoN1jeQRx8FvoPL1AKNS8ZFC8z6aQmNatY71O6lRyq1Tdhn4eESz8q9HgX30gkT+OFp4HRSbuL1LBJSGsF2BM9F9/EZCixVnyo+96eqDap/IWoCXYZl8Luw4prUtkF7WUQZHndCPIdUxhC/7R0JrZbrTbtxhoKMNjYOxXXU0w2ZtFtho4sWrTZdPYGi1DMMHkyLIuF57VPk3UCa1LVhS4lvI+L99Cght6IXVgJbDDvwJw2PFow0Z72Z707Y1h8nezETJvdbdcib+k6IelXniYHO3h/fysZq9DPatdpYhtzIqF2xfABSpMrFCH2wXUIkHrlRjeDfpYd9VURzZ5mNkwqflRhZmlYwXpAwX0se6famk2Pq2ZYx3Bovt0w6Plb+mDvqg0G2MlIJ3cXg3mkBbsKeo/jeC4s5GlEHBshSaoKMyqsbhU+0kPSyd6GQJq7UFRUE2NxMOg3R0C8fY6FxbOtPGqJN9X/wNOVcy0B0lQCPsE0TkNeFsJFkzM3+9jO6O14VtXK0fgfbDCmJirkYt7namHbkyKIoLphkjvLwDNeXXUx1kTnrKnu+Y0lGeiir5/10I4PnOFA63pkv4qlFXrZJ+hML3tp7ENZsuu4TMYGTRawPzKKdm+WbnbT3ow9qbllSbZB3UdBYGDsUJ7YYdAm4NsoZZxNjnQygB/6WUlVLdHSVp3PRe7/eHizAIJhGNUzd0BvToX5GxRLfIbWflNRvALPyxU0sdPeS/sV31SnFIxvj9C4DQbmNJDIVAYqFdFC/FrmdUNU0ifvLPeqM5Gejt8/Iuq7nS+1oTCW8I6un2eoWOX6B3FIasR35VCgklX2QYsX59pXbRWh0wx6GmvO7jj5dpLw4QfnpSTsZHeKj3zzmtQzYGzys9HW6o551i
 G7oLImct
 nxp22UX2vv5Qfy0EySAH70bOJz3seZKY9sNQWVZKXhV8/HJ6cF6uXjWg0hZ2W4Tq/RYCARe1bUjO37H6k6i9XmVoGgpCkmpuycQ6zp1ECLMN6HpBwJY8s0N34edd5VwXV3ZMCiGr4dJd5oDr4lcVwsrEbnJBsxA4VGQLyGTHyF6lo44TNih+PWEBdkHu6fkxMyiy1bez4ie+uCLMaqeiQR7+QdHqwMkbz0K1qYQg48MKM2i2WY+sgYUTUBs6PWQyarkaw8vJO/m+WOjcZ+rxo2I2gmQc6M1M+9ttN0/wsmR00/Eg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_fallocate() validates offset + len with inode_newsize_ok(), but
then rounds that end offset up to a page boundary before entering the
preallocation loop.

For a valid request ending at MAX_LFS_FILESIZE, such as offset = 0 and
len = LLONG_MAX, adding PAGE_SIZE - 1 to the validated end can overflow
the signed loff_t used for the rounded end calculation. If that wrapped
value is then converted into a page index, shmem_fallocate() can enter
the folio allocation loop with an invalid range.

Cache the already validated end position, use check_add_overflow() when
rounding it up to a page-aligned byte offset, and reuse the cached end
for the later seal, shmem_get_folio(), and i_size checks.

Fixes: e2d12e22c59c ("tmpfs: support fallocate preallocation")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
changes in v2:
- drop the RAM/swap-based range rejection
- drop the NORESERVE full-range accounting probe
- use check_add_overflow() on a signed loff_t rounded end
- v1 Link: https://lore.kernel.org/all/adcf644e780706c220809b7a41e6e496d2181806.1784947149.git.zhilinz@nebusec.ai/

 mm/shmem.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb3..f4648545e7ae7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3602,6 +3602,8 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_falloc shmem_falloc;
 	pgoff_t start, index, end, undo_fallocend;
+	loff_t end_byte;
+	loff_t end_pos;
 	int error;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
@@ -3649,23 +3651,28 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	}
 
 	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
-	error = inode_newsize_ok(inode, offset + len);
+	end_pos = offset + len;
+	error = inode_newsize_ok(inode, end_pos);
 	if (error)
 		goto out;
 
-	if ((info->seals & F_SEAL_GROW) && offset + len > inode->i_size) {
+	if ((info->seals & F_SEAL_GROW) && end_pos > inode->i_size) {
 		error = -EPERM;
 		goto out;
 	}
 
+	if (check_add_overflow(end_pos, (loff_t)PAGE_SIZE - 1, &end_byte)) {
+		error = -EFBIG;
+		goto out;
+	}
+
 	start = offset >> PAGE_SHIFT;
-	end = (offset + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	end = (u64)end_byte >> PAGE_SHIFT;
 	/* Try to avoid a swapstorm if len is impossible to satisfy */
 	if (sbinfo->max_blocks && end - start > sbinfo->max_blocks) {
 		error = -ENOSPC;
 		goto out;
 	}
-
 	shmem_falloc.waitq = NULL;
 	shmem_falloc.start = start;
 	shmem_falloc.next  = start;
@@ -3699,7 +3706,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		else if (shmem_falloc.nr_unswapped > shmem_falloc.nr_falloced)
 			error = -ENOMEM;
 		else
-			error = shmem_get_folio(inode, index, offset + len,
+			error = shmem_get_folio(inode, index, end_pos,
 						&folio, SGP_FALLOC);
 		if (error) {
 			info->fallocend = undo_fallocend;
@@ -3743,8 +3750,8 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		cond_resched();
 	}
 
-	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
-		i_size_write(inode, offset + len);
+	if (!(mode & FALLOC_FL_KEEP_SIZE) && end_pos > inode->i_size)
+		i_size_write(inode, end_pos);
 undone:
 	spin_lock(&inode->i_lock);
 	inode->i_private = NULL;
-- 
2.43.0

