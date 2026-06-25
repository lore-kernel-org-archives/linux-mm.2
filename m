Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6876CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DF086B008A; Thu, 25 Jun 2026 04:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969186B00A1; Thu, 25 Jun 2026 04:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8300F6B00A2; Thu, 25 Jun 2026 04:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFC66B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:37:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D856C1C5B88
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:37:38 +0000 (UTC)
X-FDA: 84917781396.03.168393C
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1D3F218000B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:37:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B3gqxyXr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782376657;
	b=Eq+pMXFufgS8IQrJNU3FWyUgqNuBHRaLMJk9MsuvYrLYQ+onrFQiJuGW3XNflJP5DlKc3O
	B8gs2rIxIA2ubMMMYB8J2ZhvdADO5IyFs0SmwG/MIgyplBguUBwedyvSmv/EDmGzqUYLT/
	p1xNbV66NCJZc3zwCoiIMYcZZk2HJbE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782376657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0J1jnzmQVNhnRjMNcripM0zyo9VQmhoRd3tOhETxEs8=;
	b=6MQeX+iQ0NlqljR44H4wPnGKaNtWZyPwBKrRywcremDPZBpc7n1EKr5qFDHJleNW82TlYm
	oAMepfxMCZCaeYo6bHy2t+Ik4fOdTJA2tqvFPj6R0rmgw0d09tVqRpiX/hidVQzEkHpeVb
	SZ6FbaoxhvVQQ8Z+dwawRyUEXBuYC0A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B3gqxyXr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4624a44e152so1663625f8f.2
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376656; x=1782981456; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0J1jnzmQVNhnRjMNcripM0zyo9VQmhoRd3tOhETxEs8=;
        b=B3gqxyXr2WuJVQASVoQ5EaLkLi1KfMmaSe01DRvyKdQhLRyADNJaLt8b58yiNil+h0
         w3m6ll9YcXSigRd9yl8xjsOzzB8SPGG0iSSlgdd+25MN0504aEqCBuGEaJqMGN4CEsjg
         Bp1Io7SGVrkSaXy0dBNxCSqtLR3opEEqwlU5oB3UNPOrjEEwIolG/7Z9iM0JtwlcBzk1
         E1xROwK7mMFBsl07PERKwR3WZe0ak4lzHlvASz/g0F/DSFt+M9/T6xSRLF59Q7m1qFl0
         F9XJwXCvDQuffW4xAuUV93lbC6PW5Dz7krCu6uTZIQVj7UgCZsOtUxVKB0UkpNn2OBkz
         U22g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376656; x=1782981456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0J1jnzmQVNhnRjMNcripM0zyo9VQmhoRd3tOhETxEs8=;
        b=nKQEHRJ0rQ3bswORXlf/0cLbinMNGmgwR5fTHuiVak5TsHxk+OuHvU432mv9cBtmsb
         G90jx7RMGgnYakcnecW/A8lFuCGDzV6c0FAUsQpv9WkGIq9u4PZZLmml4qju48GOjLq6
         UGiWGkDelWoBQurTsLGk0BgjJ9BxA2ZNiBaIryJboylDC97AMU0fdugPnUUfXsvg0ihb
         +k4HrhJOdbj1uC+cI8hPDdRiWLvyrq/o0fjnT/hqAtHNs2VRLJtPdsFFf8ejFSKHPywm
         49m6+mrwsK/pVVmKXHM9tIwXiYMUxtQ7VcPPY3hbAE3qQG8d16xG2VKVcgp24UpyXmPB
         /2ew==
X-Forwarded-Encrypted: i=1; AHgh+Rrl3pxJq7N+Jhus6G7sJhrT2aB6RkAv3SSvYAD1AbbuF9dVO3spyK0wDD3e9AtBsCNUMX9hNyb1Yg==@kvack.org
X-Gm-Message-State: AOJu0Ywz/xLjc+5RwEbehhVw2+lgbTe7Z6utnLaAACH5smQnYQpyfCf4
	XWY+ROv67fFsLe77ueDVpsIuMHUUAgRRlzY0g4Nj6bXtzGrIADDdXFJm
X-Gm-Gg: AfdE7cldVeBJ5g/Tq0JP+y1yPl39ByS9Q97bVCphPqTURWJzvHHaEmB38Hq1V/FI+wu
	ByRGufMglrWOeJo3DPjvpnOfFQO3kGve9fAUJjZ3csHQx8bF1DxNT6qN6fB6Pag0ZvdqnDHAvW0
	W+PIqXYbtXDluZfJnLaLBtZkzrklSozihcIaC5TLfWz5BgQ1H8M88F4M/R6/bgqDEx0/+AUPga9
	pKbkocYpwFhTzJZBsVsdemUsxnh/2CNwP6DQuk9KLAQVsfF2GtjZWRTWJdKEi58/z1Y4eBOJPOD
	/G86WSeco0JUmkKc6rDtMZTCUSieI7qvplnxTArFBCwnjw4t7gMewI4pca7neK4DZVRTMGLVzhb
	SIe3O2WdA1Ke/TXdcPvVjFhAOHEbtn49WgdqIR1zX9maz4s+L6D/+pGL5+S6nC+w8NjPrt41iB5
	scio/KFfHRJRYuQZzne0c=
X-Received: by 2002:a05:6000:2485:b0:46c:a463:987b with SMTP id ffacd0b85a97d-46dc1e82faamr2365468f8f.41.1782376655597;
        Thu, 25 Jun 2026 01:37:35 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c9ed7491esm9943798f8f.37.2026.06.25.01.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:37:35 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andy Lutomirski <luto@amacapital.net>,
	Collin Funk <collin.funk1@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Stefan Metzmacher <metze@samba.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Val Packett <val@packett.cool>,
	Andrei Vagin <avagin@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 7/7] pipe: set FMODE_NOWAIT for named FIFOs
Date: Thu, 25 Jun 2026 08:34:09 +0000
Message-ID: <20260625083409.3769242-8-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625083409.3769242-1-safinaskar@gmail.com>
References: <20260625083409.3769242-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1D3F218000B
X-Rspam-User: 
X-Stat-Signature: qu9yfnajss1zowmmtb4jfdzx5jf3g9co
X-HE-Tag: 1782376656-424998
X-HE-Meta: U2FsdGVkX1/8k6dEtK5HfeCTAypO3dc2diiSDoCsMBKKd//tlBAzlrmo0+OYrurh/7OZ+nUgmqL7sN+UO5g+vO1PwbUw/Qxhd0GQRceXPKTj3UfsU33UZmibK4uA0PXzUE28/3D/8UBgyAxNimERb4QGlXz5O9UtkQP9+y7TiHIGdnez4hK2tL4fvs5iNcXXxtB59c1Hfu3+9UST7wzx/J7X8sFqQHbde4mdo+/8XZJiC09OJz9uhg4op0uqWcEK53QLpFRAQeFm0H749obqZcNlNlzxAMdb/YWq2zN1Jw6jz3eP7IDFlY8PmS0r/lN1CrMMR5D6T2epZx+dx5byVZ9nn2d/AqKqQ6OJp8NRi1W6hV/Xfc3VJ8hIHG/Cw91O6aVfQJRvsVlEAhr6j3W68QHCdRNbzZVHpC0fiGzgs4siO1fdTgfhJnSe+qnd2kunEbP/qq+R0dH2Sx2RdrNcblRoQcwKymaQLMQXMGbqc2rxQuvof72LI264I9pAQZohK+g5eWvLU6Csujte3tQYhqfiqdHJ5Gg4USEET2pbnI6hOTx0YPB0Flmubn0x0Kvx9wQ7qi45esSYJj7mtcBUUmMZImy71SsQ/hI6tzTNC73pcGNtHh4k9JxtB0X9RQK6X/XABL0b/Khp/gisppCCi1FAin5OG8g9W6nbywAmAYT+q8mLiHD5EkX1K2khG+rk7XIEfcdr+nIMkxzbR5vyhKt0earzqZsfVmnHymNy2pjCNVGM1SfePQeL2KhZyAmsOc57TJDL+bU4uwZSIfy72yrQKCoCFO1r90y2yDyqih0UFohPYZhrld20ApHtiAyPjZjihgFKrHZV5Ejp3bwdHapXnOecc47YLUb9u6ICKiUt3KQhnQfAQnmrfZTp//rMWIDzUgclAzWc+7O+8vmqW80Cm8ZMSt/egP4ij2CqsxaDubCW/5nB6ac87YnfwALVBfeq+yoescdNcS/ZsjO
 klZ7gUjX
 3MicDHTZzRdhc2MbphDX9zI4PPKPZhysZ3vESmj+ShXoPxwo0a9Sq4gkftIZkRV9+7Ks7yngjKuhH0W0b2Wg4TuoTQnkEzesuQ6+5icL60UNgh1EH+/oU06wGO8djdAOqF4hQOYMXxv8uF3SujM6bi+mnvkpEnJv8OKm9ID51beIgzXv00YVkJziXB5MOJ2048t3FXVKykhKs6qd8TFZpShRBaQN+o8omg41xVJ0icgM4QzRQmMTPL1luzZlKbNadi/IxpzKA3fiXTw9evAP1zowdorT4AXEpO4LUYt0WAePlKb2an04SN6driQqg47DVCOz4YprkxBu6m5JG+VQF72IvGzXjPfWZ74AHzEyLozZB3oe9wozWbgGP3xZk4HAuo9w4ADbNWDI8j+B2/+SeAlE1l0sSmFosdNngYAf5LD4eBRzIyQQfb0s+gZEbdRfEptgZSztT9nasmooWzAnEzP/DLs+kMLr+9laL4+Mjd3OuB+SA+nNBhM7Ued7tEGO6XYj38KnadX3+ojzG7AXsDhzUWYzIruodu1/q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CRIU relies on ability to do vmsplice(SPLICE_F_NONBLOCK) on named FIFOs.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/pipe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/pipe.c b/fs/pipe.c
index c0ccf21b9..a8e9b4459 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1156,6 +1156,12 @@ static int fifo_open(struct inode *inode, struct file *filp)
 	/* We can only do regular read/write on fifos */
 	stream_open(inode, filp);
 
+	/*
+	 * CRIU relies on ability to do vmsplice(SPLICE_F_NONBLOCK)
+	 * on named FIFOs.
+	 */
+	filp->f_mode |= FMODE_NOWAIT;
+
 	switch (filp->f_mode & (FMODE_READ | FMODE_WRITE)) {
 	case FMODE_READ:
 	/*
-- 
2.47.3


