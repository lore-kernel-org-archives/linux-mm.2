Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D29C61DE2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97676B009B; Sun, 30 Aug 2026 03:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20176B009D; Sun, 30 Aug 2026 03:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F9D6B009E; Sun, 30 Aug 2026 03:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90DE46B009B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:48:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 124F016024E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:12 +0000 (UTC)
X-FDA: 85157157624.02.C15BDB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 71CFC14000C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C5WEFdIx;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788076090;
	b=sWKX+gn3OGIBZ1IkDV0qXuuyjJsk/dLo0NgZpvoEMNgOo0td4QUkRZnpR9/25WsEJlIW3W
	mO7cUrSVjXeo21DLeqd79m5PtOYoLaYRN7UEAxd512GaR2Bm8RhcI+NFhWvpsxCI9gXYb9
	2JO74E/qA1SoArHzkHE8d76wfa0Id+I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C5WEFdIx;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788076090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBV4SRjso+EkgLj4PkYZQJzo+GNlBWOlH+QTKJh25O4=;
	b=tI7g84enXKNxmTWXs4A0l6Cu0FZPXl4IFAb7FPZIu8VKlWhW7+g5vIIyj9iIX02ihcRB8o
	nEqfxmR8u1xlAQJhqfuXs7ksJfKr+FkhL2S7EfcBniGgPyDqGS49LuTOsPnFxAHZ4IHReu
	Q/Gu2PymNoj7CWJhgpqyUhmqFQ+c8O8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 472016020A;
	Sun, 30 Aug 2026 07:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3281F000E9;
	Sun, 30 Aug 2026 07:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788076089;
	bh=lBV4SRjso+EkgLj4PkYZQJzo+GNlBWOlH+QTKJh25O4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=C5WEFdIxnZu7NyCEa0917/q9m8RAavDxTcdqoLLl699TQIsq4EeOhuxI+szK6oUPX
	 BBIzv3+IJ6+fS9FQmBehVilOS0JWGi1UM3ADz5QENEJkQ7B/lCi6MWuSsmh9d24gC/
	 xqZO9ZbJgzAnKUPKUwFxOq36/mp/Mjxngs08R/Q2YejbbFqe90lyuLn5rhvLGud3X2
	 EVKuB+T3cucf4i8ZuJBhzJEXqmfg9dO6oauWM/ZNRbde/XgSesB8Mx+xxgTVU6krb/
	 +wgLp1Rk81AU4bDORSu6mDLNfdNz2kcvtvVoz/m10gaevkyEoeDi6cwxlvkD5TYLbP
	 9ZbWSJno7s5+w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 30 Aug 2026 10:47:58 +0300
Subject: [PATCH 1/4] char: xilinx_hwicap: replace page allocator calls with
 k[mz]alloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-char-misc-v1-1-05e2ce44f291@kernel.org>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
In-Reply-To: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>, 
 Eli Billauer <eli.billauer@gmail.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: a3zx4dkoer6u1figd6b5mxe9gm41wjyj
X-Rspamd-Queue-Id: 71CFC14000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1788076090-266587
X-HE-Meta: U2FsdGVkX1+EKGtUJi1lxFiI6RvOxwtPDh1fSLBFUWfNW6kvWkd1QIZaXmScMJieh/VQod+QlwAQMr5SKr19FqWOTnTxp48BedR3934OYgI/aFJqYM7eQYXslf6fgXm6xgLctCtvJH4IGzW5Mwbn2XzQlZBKlh7w5dlH/c9UnO0DZlsEu7ufayn/VHAgqpznIJA2Z6VwHNHma/FXgV0r+4xAE3nYZSPyAEWPraIjh6fTE804ZrCnRTDzvkxQVUMsjRpVwjusAhKyy0aMUutIQtpLELs4WvuhHZxLJL4aOc3MBUVFH6PJ6Y33nX9B4ooVVbCMYUn+JAm2JCNhETVMvS7+e1HjgEYJXdnB/ODce+iKp4dzW4FM2d8VpXFjiZKtgaPQ2vnqM9VAzLr3PX0e7m42rqwV9xLkWjd6iI6mcDptN1qACXufomJYarBxM63o6lCLpVu4Utbe9aucWV+6BgpSazskVQZD3yCcoSXuTut5lCly6KlMHYvtV9UnNejM2Ebn72uKqJNlPK/pV8zbvCwXLB60RxyQ47nbqIGrhXNOsIgLKCn1jXR0wwe4uWrmYCKuYlu7Busd1ZUPrK4DPnByfIgnwxb+LxwZfaf4kzwf6Tw4svt+Pgm71zndNaan7lvWUgzVFWF6h6YwqgNaygWuQPg0egp8AGnO/YyBpdDJm1na40yIC4OFybqkWC0qdN5OzTZei7Cd4nQWamwI2MXHjkdD1zN8dtal0S1PF/XWxs+zoGvNr9+LD1SlQF6ew0bfa7WHVTxhycfhlPVAUw8xDbrqTnwp8Bp7AF0SxNteZeYmUWSM1NWSAmE+l9fN0QMvQwmhuTgt67EuknYKSzXUtPxmuNRsfTQzK9mKJdtS9P8rnW/hPRIzJEI1tJguT4wpkFeumkpAMazFwDRbYekJ77eyp3wse2RJCwc/xY3jCJYchFld/EN95wWZXHao2wKr5p9pi+FKIsZrWEj
 cDhMxuRu
 X6O328q2E/K/X3FEF13ImPATJO0D9N8mKhdOgoNayv7+Rmte5AozwbVlsbOHQxDHCgTOc9fDcfkf7oxfL1wRb+3xWFYIUw8nhOo9SeD43M+zOAMXb9MGV4L8Qia37Aqp0dLFKTtk2Sdc/ntE1Qa3/PC8CF4w64Bv4EMm7Rcd0xwZ8L9/QHvkHlc5efpEMdTFORyPYK+HYFiAG3zs38ZlQR1UZlGfuB+DHhS+uXHttSsXo3J8VmBQJxK0lHH+x3tNJUHs8e5zzK3sxwSPlE6XWTHT8sD59dqwvcELFZNYNuOqiuSM1ShT5KNAHdE+n7LuIYnVr5LcNbZJCkZWrG9uJuwi4u4ETpYzKC5Ut+QZFfEq6auNt2VgkO8U3M4gqfPrPONOeSzPsw0K7xOA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hwicap_read() and hwicap_write() allocate temporary buffers used to pass
the FPGA configuration data to and from userspace.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() and get_zeroed_page() with kmalloc() and
kzalloc() and free_page() with kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/char/xilinx_hwicap/xilinx_hwicap.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 9bb5fa642fd8..bbeb9b6060dc 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -382,7 +382,7 @@ hwicap_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		       4 - bytes_to_read);
 	} else {
 		/* Get new data from the ICAP, and return what was requested. */
-		kbuf = (u32 *) get_zeroed_page(GFP_KERNEL);
+		kbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!kbuf) {
 			status = -ENOMEM;
 			goto error;
@@ -412,13 +412,13 @@ hwicap_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 		/* If we didn't read correctly, then bail out. */
 		if (status) {
-			free_page((unsigned long)kbuf);
+			kfree(kbuf);
 			goto error;
 		}
 
 		/* If we fail to return the data to the user, then bail out. */
 		if (copy_to_user(buf, kbuf, bytes_to_read)) {
-			free_page((unsigned long)kbuf);
+			kfree(kbuf);
 			status = -EFAULT;
 			goto error;
 		}
@@ -426,7 +426,7 @@ hwicap_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		       kbuf,
 		       bytes_remaining);
 		drvdata->read_buffer_in_use = bytes_remaining;
-		free_page((unsigned long)kbuf);
+		kfree(kbuf);
 	}
 	status = bytes_to_read;
  error:
@@ -457,7 +457,7 @@ hwicap_write(struct file *file, const char __user *buf,
 		goto error;
 	}
 
-	kbuf = (u32 *) __get_free_page(GFP_KERNEL);
+	kbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!kbuf) {
 		status = -ENOMEM;
 		goto error;
@@ -479,13 +479,13 @@ hwicap_write(struct file *file, const char __user *buf,
 			    (((char *)kbuf) + drvdata->write_buffer_in_use),
 			    buf + written,
 			    len - (drvdata->write_buffer_in_use))) {
-				free_page((unsigned long)kbuf);
+				kfree(kbuf);
 				status = -EFAULT;
 				goto error;
 			}
 		} else {
 			if (copy_from_user(kbuf, buf + written, len)) {
-				free_page((unsigned long)kbuf);
+				kfree(kbuf);
 				status = -EFAULT;
 				goto error;
 			}
@@ -495,7 +495,7 @@ hwicap_write(struct file *file, const char __user *buf,
 				kbuf, len >> 2);
 
 		if (status) {
-			free_page((unsigned long)kbuf);
+			kfree(kbuf);
 			status = -EFAULT;
 			goto error;
 		}
@@ -516,7 +516,7 @@ hwicap_write(struct file *file, const char __user *buf,
 		}
 	}
 
-	free_page((unsigned long)kbuf);
+	kfree(kbuf);
 	status = written;
  error:
 	mutex_unlock(&drvdata->sem);

-- 
2.53.0


