Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10F86CA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 23:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2986B0088; Thu,  1 Oct 2026 19:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53846B008A; Thu,  1 Oct 2026 19:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91AEF6B0093; Thu,  1 Oct 2026 19:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66AD16B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 19:50:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BCC5FC05BD
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:50:24 +0000 (UTC)
X-FDA: 85275703968.10.8F6B180
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf18.hostedemail.com (Postfix) with ESMTP id 82E4E1C0007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:50:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=JmlYPD4U;
	spf=pass (imf18.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790898622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whCQ9fl0eQjp5iKExakuvCYoQnjcdvda7l5h7qSqS90=;
	b=JmmWve7+QhdWmDBv4fFXx6+5qzudVtXo44t0V+k+79IRZ5NK8V9TPT3ohJbgXwc+3pp9Zz
	w8L3fqWHZWV/97xL2hWagwCjL9HeLKARqB4qlY3UNNRkRzO69LO1r34J5UM0ALdqtFk7Gk
	zmjjGtTh6Nk5n+w+mHsvo+3GeV9b9fk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790898622;
	b=k5uSYYMmwlgPbn3lsKJwdNnw2ckIpW/GssyPXG1JUx/OAQ4OBMLSaManTDTCE28jclIRZH
	JRwuxYiiDkoUL9wO+ntzxGoskH1b8wbDMDCtSWXvWDGJsQtIWssmSEw0hbZ9cYPIhTntt1
	Ujl6bniQwVoUNZS/fVqKWU5lo/db6C0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=JmlYPD4U;
	spf=pass (imf18.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790898620;
	bh=whCQ9fl0eQjp5iKExakuvCYoQnjcdvda7l5h7qSqS90=;
	b=JmlYPD4UJDhVjwwrx+4YPLIWm5Hx+wk+YBuo3BgInqrx8XaLZL1QB/fD51DvjfyxStlD
	tCvGzU/QAAxrR4VfK9NWntogjRxWEr1v42OLjsTf74LRGWAgf1HIlr4mff79dS4wa1oX3B
	dsCb1nChD+C2cUtOCh8/5vvsN9dY6+h/Ihu9AX92M6ZWlJ9Dg47RFx5Bxjaez6T5v7IXSX
	BBPvcjFJHAgBBqd9nOIFDmSfmKVRluAVrXkpzPx7E6xoLIRIFUEolHs6jIICTfjx6sWY4G
	fwdVYOkZ36dDnkik2Sa0rs6kWmJxeEx6mvxRmr3gfyBlAVwhZJtEPFx67KKxIsRA==
Received: by recvd-79d8dd9bd4-m8x27 with SMTP id recvd-79d8dd9bd4-m8x27-1-6ABEF1BC-56
	2026-10-01 23:50:20.465335371 +0000 UTC m=+197336.687606404
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-1 (SG) with ESMTP
	id XGCZYlfaSNC2o_ADWl529g
	Thu, 01 Oct 2026 23:50:20.446 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Thu, 01 Oct 2026 23:50:20 +0000 (UTC)
Subject: [PATCH v5 1/3] writeback: clear the old wb's dirty IO state after
 switching inodes
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-wb-dying-cgwb-flush-v5-1-8361eb8c65c6@honeycomb.io>
References: <20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io>
In-Reply-To: <20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1880; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=LuvshFqNCoD4IL13j3PQO4E118Ca1NJNCJKV7xSioM0=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBqvvG7bhgoyaa8gq6TobhGVwXGsBxQxd6r7uySt
 U8QKMK/yyCJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCar7xuwAKCRClztTjl62v
 wuQbB/9eVvqjaA/Nd4q3vxsxJVJDSKOSahHvcApfmb6hEw9Ps1RxId05mi18a8qDa0JFSrxAnQq
 VR6Kf4d+6Ze0VcFHmM1VIB8JYdU6JcsxPibabo3KSBlOlYFkYl8y1CDo3hKS6ikFrxPuQ+90iSF
 te2yVLH39PdXepnY1oi0W9wwguw0GOqYdU1KN6LxloeVX+vB3aHGupiNQyPXZCJ3D8NVn4Z3iEq
 TQLUdf75Vxr9QTj47MH+c/foW3MG1dkYIdK9g80gP9SvL8Ao2IT1te9sRyFWg9Oyob4Jnp9tnss
 sNs4aW+DvXFVPdlWCmBCJP0FXWpVuViLb9gExBLAQ4JuF/Oj
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmedxDdO+wTo2o?=
 =?us-ascii?Q?TPIqqmrvsGRDpWxoBtidiwVgA1SmB5ddBYcEXo2?=
 =?us-ascii?Q?Bhs1rcumCUKhl62VPgzmo3cT98d0VLvzaBb0=2FEd?=
 =?us-ascii?Q?D+mUpz=2FKvLoySWhQZDh4hlnHE+nTWz4XwSTDyOm?=
 =?us-ascii?Q?hY+wFRXaDjpSizDEmLxjwjAJO04KTGT5GnuxeAE?= =?us-ascii?Q?wAP0?=
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Tejun Heo
	<tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 82E4E1C0007
X-Stat-Signature: h7xprssuqhc6xr7qrjr1sempq3rrz7wy
X-Rspam-User: 
X-HE-Tag: 1790898622-90494
X-HE-Meta: U2FsdGVkX18RcWc8QKXjq2jWegzGTiULKSsmgizX2gA0DcChzll0Chvrk8VoWw0x2dyfLhxDw4SI7+W8dRaaC2s2xTPIWcfDdMLLDISTcZbsYavbqhmIUfNBAKv+EjCN1aLvcTZyv6VnTsRj2yU28OoWFZVIQRXZJXnyx0CLbGP4pOHOlsghL2uCHjHjaudBp9rr9CL9h7ARwwZ56Vv58zva4qM1BoOwWE2eEaUM8EVX3QZlv9+7LmUVMgURmn4ee2CzvXsnoDluq7kmvGCoSqeSWKfIGDluX6Dac5D6Nxrk8I3DDmUHyh1X3E4dMjvikB4BGlToV6NHItvzbf7Nv+i/m4+Eoslqazb4MmB6fiQzO/jUm4yBaBnVLyg0Zk2xaBz0KjCIy4iLhVYbX5x2qJs0hC4GPiU6h+gyyghf8xVcQ/PG+i6e8mkhx04Mnm0ggmzS0chowhsaqiZjFMy/ErGK/C7rOnZY4CqUbiJeP8hJXLacFIPBS5XFvDcU71Od72NYUTS7JaQZcXUudzPMhO1ldXiyTyKiqEa+qdMG/cWkJ6m6QVZ302Dwam4bcRj6xFFBhLYYCQilcIOLqws45dhXjer1E0iB38XagBg195AyN/I5UI0tJg5GhbkX7358fsh4dap/jFcHcOgrgDYuGcOlPmJn6DnbjTgKOsNfBzhcm2Bjo7K1ECBnS1cYbC40McTh/M5McRqKXzsemEWt5y1kY0tDTHKCKQD2hk5fMaEEXfvE6D/JYieopsBNhLYVywW9eAX1RIb5PIrmpfW78pBOiesCLlMM8s/LnOyHngXVIGDNZ5R5rAxahmUsRRHWV01M0rj9NSdDP+kZZ/cEcArwgpt2/xUXYGk3xO3txnXPBUcN4zjJz8iZnuAp4PkQtQGpPzGPn1YgmhDgzudjD/EKe1wisuug2+Nluv24lqTNrUZcbuigGwtuEdxrltyCqmFKAGhlXqMs+S4ytLx
 qnZoMUCC
 Xz6Op5l0o8xah3briDWeJ99IAeqJxVlzolMVmRxcAOdoeDApvCVDSy0S6DKtHZuErjVv+Nvwl6Tp0cuomHh5cpnOxMwyWV0DhP4XpJ7cM76xqW59OuSbRze3yGSAtz6PxDEUT23UKfG6gpBOeEocjLU/PslT4FOOsZjfowasHkvEkS3ZYZnjoTYcFWYvsLMIacXIJDweUSHJVjkjz54HABKrKrn/W4UR3sLd4HUOa4vUncUJnAFLYkzwfefIOx6xoXRVr1q+mIpWzsJ1/Wq0OHs37JnUF1UMgDcI0+iuICyvM/EJyWWMWsdIY4Ek88bHhG6JjNYGwmg2JKgPLu0Au00OS1pCD802jp1HNJB0d5p3riLHC1727XLjr3cFxmG+Xk7xwGM2Ru7GMNcxeueEGjyWsCLvNhdBWAO5n1vrJLmaJMeaX9BcYv/8wTPz/SjvcTEfRxuPjpegoh1kABtp41cDOHshfpn7YT5pazVEDUL56CXgJNKKo5fe6RTOoQWUeTl8rmnZu2HI4LcL0lfUbLHYd0tgcRCHozwxF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switching a dirty inode to another wb can leave WB_has_dirty_io set on
the old one. inode_do_switch_wbs() moves the inode onto new_wb->b_dirty
through inode_io_list_move_locked(), which only updates new_wb, and
nothing calls wb_io_lists_depopulated() on old_wb. A live wb clears the
bit on its next dirty to clean transition, but a wb that gets no more
inodes, such as a dying one, is freed with its avg_write_bandwidth still
in bdi->tot_write_bandwidth, which wb_split_bdi_pages() and
wb_min_max_ratio() divide by.

Call wb_io_lists_depopulated(old_wb) after the switch loop in
process_inode_switch_wbs(), while old_wb->list_lock is still held.

Test: a later patch in this series switches all of a replaced cgwb's
inodes, dirty ones included, to its successor. After that, with every
writer stopped and the filesystem synced, BdiWriteBandwidth in
/sys/kernel/debug/bdi/*/stats stayed at 411700 and 407820 kBps with
b_dirty, b_io and b_more_io all empty, and the replaced wb was released
with WB_has_dirty_io set. With this patch it read 0 kBps and the wb was
released clean, in 3 of 3 runs.

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 fs/fs-writeback.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d26b2cf05283..050d507aa554 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -566,6 +566,12 @@ static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
 		}
 	}
 
+	/*
+	 * inode_do_switch_wbs() only updates @new_wb's dirty IO state.  Clear
+	 * @old_wb's if its IO lists are now empty.
+	 */
+	wb_io_lists_depopulated(old_wb);
+
 	spin_unlock(&new_wb->list_lock);
 	spin_unlock(&old_wb->list_lock);
 

-- 
2.53.0


