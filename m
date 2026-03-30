Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 514821061B20
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 21:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99FA46B008A; Mon, 30 Mar 2026 17:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950366B0095; Mon, 30 Mar 2026 17:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865E66B0096; Mon, 30 Mar 2026 17:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77DB16B008A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:49:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 211FEE114D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:49:55 +0000 (UTC)
X-FDA: 84604072350.06.D327521
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4DC65100004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:49:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HeQKWftY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774907393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oxxZkapCjdRGWxNFLnYw/4aXiwSuhxrTsuAMQ0/9xZ8=;
	b=w48pIBBJcZJnjx5AGnY3IjBHEgkOFDQDwWgTbN7tKAFtJoESmZMdK19eCT8B+Xg0hdxWcU
	XguV/Zg2DA+o1qM91MxV39ZFQEmjpbsN6yIyUuRKfHcFFTp0pOX9l996+DzoZIZWyJYNmU
	pxqZ00pLk4w3jeU9TtTDZCibaEZKk/c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774907393; a=rsa-sha256;
	cv=none;
	b=TgCiUWbLmXbXo6uaTdANBhPS9DhOaMmFKy50IpAj9x8YixhRt7Jz6diZBxbBjyJGyHc8yO
	eAyU8FI1Qes4DnBA6wZPXFUsRJbkoj3bSeJ6rur6yTGZUkO9e3W7F7FuQZ3DmumEscELxn
	DGHBxyRjrY61AMe1zG8QT1boJxQnXVY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HeQKWftY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=devnexen@gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43cfb723698so1248745f8f.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774907392; x=1775512192; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oxxZkapCjdRGWxNFLnYw/4aXiwSuhxrTsuAMQ0/9xZ8=;
        b=HeQKWftY0/ufToWOUablPofuYvwzzSZ8xwSueNWg83kWk/K4sI4q4H31tW+Bu/++2j
         Wts0Bj7wkgwF8duhcFJ8c+mzvAnvC30SV8R4BP1QsnrzbyHYQMkjzPM59rEM7FGmqs5V
         +p/w3W/1MNewW2UHdZ/JiKrU247kGQavcTD/oYxIsM3EkSHZogl72HJ7mDugWwPAcXt2
         fnm8mDVgz1Hleh6UzJp7fPxe9w2V6SUIlcKVtj0fyMHDy+ZJ2EXULdNWcnbqxqYUzAXt
         HQXoWe/vslbl7lH1AB5fU1t8fHLEnkZvI/lxMUwZGjv3jyUyxtaYZFehUjIupzMDwM7H
         8wjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774907392; x=1775512192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oxxZkapCjdRGWxNFLnYw/4aXiwSuhxrTsuAMQ0/9xZ8=;
        b=FGSUy0UaFj+l7RRiu33DWh+vbS9wyKhnN2CJjFRQvDtRPTgEtPvVbBHvHE0uGq5Luc
         wVjjY3eeJvoAHRyBuw6BCtkoxApK+VbumIbMXSWbXuESAzOQLPKjk0G4OY6kSGZrLgUA
         wNO1vjm9ICiCFv+HgCJTHxCF3kvswgfNg4xmAmih0cxebe3ZEnXA2HuHYRqcxcFyinaq
         jpW9bHb3x6tuG5X+vydTZiFhi6Aoj4vNrd9JD/bGLZmW3kSERaTUqqoi7p5SJwglfuB2
         lDMVJ1WkQlOCSuYvK5xsV58cCQuyH+dMcN0P1kgqLbI3xgUJLgl8dupWIEcYs+R0wupB
         ocow==
X-Forwarded-Encrypted: i=1; AJvYcCXYvvXG04Pe7MNqEBbGso/apRJWT1lO0ktfLc8MATSwAtxJCb3lOsPzNnoWgSEHDSynKbWsdOKV8w==@kvack.org
X-Gm-Message-State: AOJu0YzxGd936c9HsAvIMwelEKRfC+1r/odihdfxeOPvYOHEGx0oER3y
	DXAZq7Q/X+shiUF2eQvrisWrj6yD4V+M3lDScMQ/EJP3/etSsnAwhLKx
X-Gm-Gg: ATEYQzzTam63fTqexJwCP4fW8PRdBuvno5u2gGCbjFwHn/aBooqeNthYWQ42aMkyHIt
	uiSTeyTLN+aD83VdQx1GBJiRb3rc2Ph4q/8jYjAs7DjHyrY5xzV9ysLgTyPG4SPt1Je0SjIQoca
	vmXrG2RSed0bTPv0mUIoRQtYq4zM2t8V9TJVjfpWZaPfcUdHQZ95HngManhc84adnZYU5IreVQV
	97hIC8vGGulqR3roh/iZhr6uRpfaiLFJznHAa5qlJt8LkePgsXhS3OES8rzGW4aMtx/e5b3+lOF
	u41eE0F4NK3VdYk5MoKvi4SoKeyO29gOSPQgDcM+hrF7fWRQ+Kngd1DsSj8JKaV6/E9JaPdOHEh
	AgU+1FJY19e0zpMSzvhLuMoSk5P9d1JdJU4vbkr+ttQ1ch9dtBD11M5vG2IrUz0LNe05qjweR/J
	L2k2WPCJCIDDHRtiVrYTlgISKi5CQTlZDQSMhosqw5nn3mHV+w9d1uBaK9GfDSACDc+BSz6XCee
	yRGAd/duBS6
X-Received: by 2002:a05:6000:4305:b0:43c:fb4b:d4a4 with SMTP id ffacd0b85a97d-43cfb4bd585mr12069867f8f.50.1774907391494;
        Mon, 30 Mar 2026 14:49:51 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf245f87esm20936342f8f.22.2026.03.30.14.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 14:49:50 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v3] mm/userfaultfd: detect VMA replacement after copy retry in mfill_copy_folio_retry()
Date: Mon, 30 Mar 2026 22:49:48 +0100
Message-ID: <20260330214948.148349-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4DC65100004
X-Stat-Signature: aftiwear7es9b7onfa88y83ici9wuf7b
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774907393-28007
X-HE-Meta: U2FsdGVkX19iU/+m7eAEZOipKEiqozE+E3nPg15lpX4ftDaEuPl6OapPoXGz37RQ97VudfSfOlX7TnEdIAHi2zNREfy9DItRKUlbbfzJIkV7oZTdLynz/yrEx7UsSA4f2Mh+Q0EBb/eFbRACeqYCOjaQ4c1bdPOySuECs7xbRY1K6W2UFF90x9VDcFcRISSTy7mv3UmnSEC9rHFyuJLWBbn21SBB/DyiPeNGdQ6MvP/tWyyYrTZHJ9MDwa22PAreV0LQQgOUTRMCA1xV/lEjMIRq7RrxqbF8GgAUBlMnXM5ZrS3H4Fcd+zyHHhFQAvdWDEiEcJJGA8mUpuRfxVrf55XSj3fT56iK+9X9k0U8t7jQM1SdC+ej4cKeW5C0u6mExVuLYRuhbiyq7oJxW6W7YuCjcmiZ0y70vkTP1CmovIQ0QElVmz9gRB1RYsuqYTVd76M5bIPdFJTv9jyNzLkYdsWeVf1xTwpprqwxJbk14QGKXfh7j+oNBRtd0mX5eMRYJOyTKPnWkuvUdOFnZ7MywSa3fDJth2ZOd4T6redQZ3mP74BJlPX8xoLcL5DzAcICp7loUVhkU/VYieCP418UdBsFeslcQbXoRPc7ZI1dZVdyhkp6yxa184UclyzO+fqBameKO27G5aWvhqB9M0ttGUzGxUQ8a4tv1lPsCfyMYCHg3Jqq2q61CGQLkHj6zWsrZaV1bJwcqytmEmH3O7D5P8Nxmk4X7iTVdu8pqcpJqJUvv6u4ZVlJ0kodkEP8flP/HwVuL84npyhfT5efztibchmvrtTnm86RK26VzB07BKZm3pFDxqMhpESfzOgR/aQ7lG8g0e2YEPOkGznD5PV82NsBopyTPOGOGmDNm5k4qDTMCaFJlzIBQQduvgXUjRMRwfJy9xL/GaKU1cXTZM0QEGiiELgVLwfF/rIFhPTVbr0Ez1OzJ14mja5fhQgTcMhJqJbs1cJzR6twM6wsEhl
 ilyd+hu7
 Yj2INOSKvuOoWH3mH6tMyTrTNKF/2kA6fcz96LMhBx26WTXd1f5Cv0z9QJwC2LlGil5t0R6d+dc1QXqrWgoOeuq//+JOmlDVA2RGiPUAaB5D0tVFlaqzq18psOh2YsQKAmZ4Lp0rB5rXNmunetGHxjzHa02po0m48yhrAhX4Mj0RMf9f4R3unOr9UjiKmTc+hZ1G2almImfWqP2D9kCF9XecN90xZI4gC3eeqXsOq0ntEb8tajBGG5zY6q/Xn6UA8RdsQktxevQ1z4rhHVsWykN4vLWInFKxvphnB86Ah3P1jE0BKrtqsRzgfWayBdvu8FjtKv0zHZYOb+Tp5dN47feeF1hAQTbzJFD6H7dTkzX+Rs+06hq2dN7Nxt6lJ8doOla1vbVK+LW0W89nKZMRYJAAzLieFAHQlD9sVofAqysIQUiZAm4Y4IJJg1eMJ+BAwL90B75GsJz4FTU23joG51VV0tEWOEUmbsIWvrL8XVd2AGvvQhJWP4AOoBKcCI4POuAs1DZFRcmVLlgoBoUQMG/jMqarogfztp7DddGVB8oDoH1rFOouhWb7DHMHXKNR6VW7T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mfill_copy_folio_retry(), all locks are dropped to retry
copy_from_user() with page faults enabled. During this window, the VMA
can be replaced entirely (e.g. munmap + mmap + UFFDIO_REGISTER by
another thread), but the caller proceeds with a folio allocated from the
original VMA's backing store.

Checking ops alone is insufficient: the replacement VMA could be the
same type (e.g. shmem -> shmem) with identical flags but a different
backing inode. Take a snapshot of the VMA's inode and flags before
dropping locks, and compare after re-acquiring them. If anything
changed, bail out with -EAGAIN.

Fixes: 56a3706fd7f9 ("shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops")
Suggested-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/userfaultfd.c | 64 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 7 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 481ec7eb4442..d10eb81dc3b2 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -443,33 +443,83 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
+struct vma_snapshot {
+	struct inode *inode;
+	vma_flags_t flags;
+};
+
+static void vma_snapshot_take(struct vm_area_struct *vma,
+			      struct vma_snapshot *s)
+{
+	memcpy(&s->flags, &vma->flags, sizeof(s->flags));
+	if (vma->vm_file) {
+		s->inode = vma->vm_file->f_inode;
+		ihold(s->inode);
+	} else {
+		s->inode = NULL;
+	}
+}
+
+static bool vma_snapshot_changed(struct vm_area_struct *vma,
+				 struct vma_snapshot *s)
+{
+	if (memcmp(&s->flags, &vma->flags, sizeof(s->flags)))
+		return true;
+
+	if (s->inode && vma->vm_file->f_inode != s->inode)
+		return true;
+
+	if (!s->inode && !vma_is_anonymous(vma))
+		return true;
+
+	return false;
+}
+
+static void vma_snapshot_release(struct vma_snapshot *s)
+{
+	if (s->inode) {
+		iput(s->inode);
+		s->inode = NULL;
+	}
+}
+
 static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
 {
 	unsigned long src_addr = state->src_addr;
+	struct vma_snapshot s;
 	void *kaddr;
 	int err;
 
+	/* Take a quick snapshot of the current vma */
+	vma_snapshot_take(state->vma, &s);
+
 	/* retry copying with mm_lock dropped */
 	mfill_put_vma(state);
 
 	kaddr = kmap_local_folio(folio, 0);
 	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
 	kunmap_local(kaddr);
-	if (unlikely(err))
-		return -EFAULT;
+	if (unlikely(err)) {
+		err = -EFAULT;
+		goto out;
+	}
 
 	flush_dcache_folio(folio);
 
 	/* reget VMA and PMD, they could change underneath us */
 	err = mfill_get_vma(state);
 	if (err)
-		return err;
+		goto out;
 
-	err = mfill_establish_pmd(state);
-	if (err)
-		return err;
+	if (vma_snapshot_changed(state->vma, &s)) {
+		err = -EAGAIN;
+		goto out;
+	}
 
-	return 0;
+	err = mfill_establish_pmd(state);
+out:
+	vma_snapshot_release(&s);
+	return err;
 }
 
 static int __mfill_atomic_pte(struct mfill_state *state,
-- 
2.53.0


