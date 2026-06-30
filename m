Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49F2BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12D786B00B6; Tue, 30 Jun 2026 15:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F266B00B7; Tue, 30 Jun 2026 15:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFF26B00B8; Tue, 30 Jun 2026 15:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD8126B00B6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49E3F16836D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:13 +0000 (UTC)
X-FDA: 84937516986.28.B92E7E4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id B88971C0004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4tLZSjXo;
	spf=pass (imf21.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846551;
	b=5/Mlym/k+Pf1yLK6731t6i2lNgulH4cYoajYiJerY/IJFm7qKOSUIF7rB1nk09njDzteFb
	Qkcx5vKCOmPu25JxEGS82Kxhsb/GG68pk4yALXTBq3VAdoSX74woJpkJb2QdvomzMYb6b6
	YJJubnYHcKqj1lCS+J81WZGpO2T3kSA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDmgxBpe1durDwt0gaYecCUhfDj8JsczELCLT5SFoSk=;
	b=S+9QVk8QieoeRQa1I7jThX0v9FmyOaPBWA5iuWyoPFavlfDuhdYrDC6SvL24aQjTPMNkrx
	NluOy2kkcWlFwvNIGLC4GViB99kY7Wr0N+UWkGWNbauPoGzzxDzIi+nSCDyhLt7aBa6FwO
	gfyqORr0JwjuVWmvjYgX5WZZDWYNCg8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4tLZSjXo;
	spf=pass (imf21.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KDmgxBpe1durDwt0gaYecCUhfDj8JsczELCLT5SFoSk=; b=4tLZSjXoKHf5V87h0xOQ3U5F7e
	6BUOeNDg325KevFUnZIY/JAQ6ZtBzfQQyLuWCwjLitSCOYjFHb9aBuHayWbqAoNtkMunv7o+GwUVF
	xarp21lvOnonMgGlK6PL/Fy/0x6UkY9AdLc/pMZjaugmP5n66Ot9bujX2l7sUE1EGXnHxsh9543Sq
	Vmzx3ywH4dokQz6GTz6AGsT6zgDlwJiCsk4/M0dtinD4x97nP77Jx8FWlFKMMGh8HTCTOQO35wZuG
	HevaGVpvg330Xer/JGQBKTPLTwhWBYNVIf9n46CRJp5Ei7FSirfUlu9VbkLOsL/f0sHk23dhWVI9f
	T5esrqig==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpW-000000005zJ-2sGV;
	Tue, 30 Jun 2026 19:09:10 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH v2 13/19] maple_tree: Document that erase may use GFP_KERNEL for allocations
Date: Tue, 30 Jun 2026 15:08:37 -0400
Message-ID: <20260630190843.3563858-14-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zfswcg1pdb5tcua4iykg8wfhcryp3z15
X-Rspam-User: 
X-Rspamd-Queue-Id: B88971C0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782846551-324293
X-HE-Meta: U2FsdGVkX1/Es2sLiyIi73tZ/evLyzEW+s3GWqnh1Uo2R0TdUIDYihyEpkmtOWg9BuHtPD0dycPmhcUJMrjbrUBUQsixukuqpHRNdTFfGIsq24k4HcgkVO0c1kOk6U0EgmAG/Nk4U6tZ42SeCBGZ4dxNY5jwMOQd75853hOPw9xOr8byC6q5k7vlKF1bq/sx5yEhF9bcEuQOozk28EucC2Vy/44ZQqcL+k0Q2t4qIKn7SXbAlJpMXzlMVN6F5MqVFGPjv0lacrfEHjK2GDNvIs9R9/Vu3MScYRQd3uF+zNeay9PlAEjFLLA1A2d0cDhg9pIZrpCItvbNW7Ab2Dr3uxrPLqEAbK2rV3O+/DClu9+//KpdQ+U4JfOLzM4qywc5nT4CKyhGk/+pouyR2Ncvo1jicKONnO9yCj2Zk+aT5XBVJBxVpwU01aMuIb7hZ8soks+UwEMU9bP+jxZ4Mi3t/opEKY41KqCv170AwI62L9RuHN8r71N5LC2CtoyfAE9MuU8ivkcmueYFcx18/HJbEAWFjpSplUdXvkxdbE9SYt8/MqLwcp6sAd63BMx8cmpHts1H52N+iT/q6hovsYsK0WPK1Hdp4gRWy2foLjgmX+8V9MkOL5g+4L77FJTFycErlD2Lz+llFdXjMh+xlL6AU48ApHoVj+a6x1gNywKpxxz2gru8jGwbW1QfSyOYPjZ5sRZ3up3UN6Bh/TX9xIHzQzcOF4GbiKHBHRuIszf0/qUZrLAxAamK4KHjO+qWBZsH36LekgTG/cNjyw/vv7UGoIKKhwh6v7uYRM4BoM3mOIdc1ta9qiqouJwCps5p7+ChtWuh4O6QqprMRNxN6ryhU+jdTIaXh6lr6Hb/VIJTxP8EIFcJF4Of4Lw8GgRDm4UeiSxts5S+9TSse7jjBTE7Kpx6Jym2cB6aYX6ESRYvXunP87QFfrZz43BE5nB8BFjle9K8nZGc8FmgZRiq3Rn
 PBkeFxM1
 gX9HEnh4MYDyYavPtZcokGEEo1RpL25yFABY+q43CliUAw0DiX82uvDIeBh1VztKHl1n2vJgEsI45/cwHZaM7dZCiDVh8f3qTXA8eexrrmLD24IqPGxTYkumofcyZZODCUXZ9aO/wsdT7Qei/r+AY2PHs2x2rpmDUUFMr/mhGLKc9zU9NYVVW2q/gY4aDiCJBtM8D4qXpNptROcEElXR2ApdjixeCI3A/cmEOSCkXo3limng/A+04tKpQSVY8jOGuU6+TA0zJ7uTcBUoKDQ4NI91Fnm+Ob7bI2gshJRaCiVBxBFz7Y43P/oh1d9T0FzVXsgHTRqI5dNngYQGyBAAMKmCVBQ2V+apg/b3rd+Kik8QKPql1sdRzGS4t6ZH0Q2HQlEBYrCzt8G+t0udjW7Jc7ZZhqQyei9q8ErYlLj4yyO2x5NmSgNkSVD4dYkIN2us+dGKel8KZOOamtzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

State that the mas_erase() and mtree_erase() functions may use
GFP_KERNEL on allocation retry.  Don't just depend on people reading the
documentation by adding a check that will warn of the use.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1bc177bf42f9f..15e8081f61808 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5657,6 +5657,10 @@ EXPORT_SYMBOL_GPL(mas_find_range_rev);
  * Searches for @mas->index, sets @mas->index and @mas->last to the range and
  * erases that range.
  *
+ * Note that erase requires allocations and will use GFP_KERNEL to do so if
+ * necessary.  If the allocation fails, the internal lock will be dropped to
+ * retry.
+ *
  * Return: the entry that was erased or %NULL, @mas->index and @mas->last are updated.
  */
 void *mas_erase(struct ma_state *mas)
@@ -5665,13 +5669,21 @@ void *mas_erase(struct ma_state *mas)
 	unsigned long index = mas->index;
 	MA_WR_STATE(wr_mas, mas, NULL);
 
+	/*
+	 * In low memory situations, the allocation is retried with the gfp flag
+	 * GFP_KERNEL.  The internal spinlock is dropped in mas_nomem(), however
+	 * the external lock is not dropped.
+	 */
+	if (mt_external_lock(mas->tree))
+		might_alloc(GFP_KERNEL);
+
 	if (!mas_is_active(mas) || !mas_is_start(mas))
 		mas->status = ma_start;
 
 write_retry:
 	entry = mas_state_walk(mas);
 	if (!entry)
-		return NULL;
+		goto out;
 
 	/* Must reset to ensure spanning writes of last slot are detected */
 	mas_reset(mas);
@@ -5682,8 +5694,10 @@ void *mas_erase(struct ma_state *mas)
 		goto write_retry;
 	}
 
-	if (mas_is_err(mas))
+	if (mas_is_err(mas)) {
+		entry = NULL;
 		goto out;
+	}
 
 	mas_wr_store_entry(&wr_mas);
 out:
@@ -6011,6 +6025,10 @@ EXPORT_SYMBOL(mtree_alloc_rrange);
  * Erasing is the same as a walk to an entry then a store of a NULL to that
  * ENTIRE range.  In fact, it is implemented as such using the advanced API.
  *
+ * Note that erase requires allocations and will use GFP_KERNEL to do so if
+ * necessary.  If the allocation fails, the internal lock will be dropped to
+ * retry.
+ *
  * Return: The entry stored at the @index or %NULL
  */
 void *mtree_erase(struct maple_tree *mt, unsigned long index)
@@ -6020,6 +6038,7 @@ void *mtree_erase(struct maple_tree *mt, unsigned long index)
 	MA_STATE(mas, mt, index, index);
 	trace_ma_op(TP_FCT, &mas);
 
+	might_alloc(GFP_KERNEL);
 	mtree_lock(mt);
 	entry = mas_erase(&mas);
 	mtree_unlock(mt);
-- 
2.47.3


