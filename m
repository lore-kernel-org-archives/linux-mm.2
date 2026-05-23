Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5203FCD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9BC06B00AE; Sat, 23 May 2026 13:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C8A6B00B0; Sat, 23 May 2026 13:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63126B00B1; Sat, 23 May 2026 13:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96D306B00AE
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:56:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 620771A0B5A
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:19 +0000 (UTC)
X-FDA: 84799438878.19.388C45C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id CC38E140005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IPMImHOH;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lb9R1+4tK0UkG7ujaRwCAX/p5J9rcF0zL4gQIBfdRGo=;
	b=2syC8sT61n8gNFt5Ykdt3hiyJcIAiekMyZyyNOn5hSd8QRa9DSXkLjW/4vnbTbhQpyqWUu
	1t7mlXk5gHwVCxTvkf3j0GMzuWi3h1/0iji1cnGPLBLPuJoGnkAElHrIn/qHk6ybkRO0Ej
	k7Bkw40SuS6QLPzUJ07SJvy74SOK4dc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IPMImHOH;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558977; a=rsa-sha256;
	cv=none;
	b=5E3oNWSf7HApsj8DrbK1a5vF5mPQ4rVtLj+eeJsKS2kzY20wgA2K1aWMd2nDLQTUapSwfc
	WV7HILYbHAH82iSO6i6NIwEbdctMi8jzBMvNB09iqmClPBdX+aGqekt5OWzJIURpUugGql
	U1goYUb2cRrUSQsK3ufcqHqd2VkLfv8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B19E60141;
	Sat, 23 May 2026 17:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369561F00A3A;
	Sat, 23 May 2026 17:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558977;
	bh=Lb9R1+4tK0UkG7ujaRwCAX/p5J9rcF0zL4gQIBfdRGo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IPMImHOHZX9R3AYIw3MrZ7UCgx62XFn7hoyyedz0iFQPJGvDjWaHpwmxJB5koBaxa
	 /Zc5t8a2CPG487TQZEccpAsZr3Cf1rO92HRpgstttNSWqixLgLGXd0DvsUS9tZtlla
	 d329bJbl/Atss8Vx+9BzQKI0uNEQtubea4TOBfBsFNekgNqOkGDqHmCQSubaFIZfAT
	 TauGSVKvJQhiO+GYyWyay/Wiwy869ulfv9WbRoBbyef941Hh/lralRMIiBOuObnSZQ
	 Z4Cg5jGvVivL+u0EWcq3emC3mmNYhjnSI624SUa8QgsCk9k0C1+RlnpQa3FfKJZTlc
	 xbJ0tHiFeZ+0g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:25 +0300
Subject: [PATCH 13/17] fs/select: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-13-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Stat-Signature: 5u3ajf5qsizjek5rt6tn9mqug3zw7kw8
X-Rspamd-Queue-Id: CC38E140005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779558977-137691
X-HE-Meta: U2FsdGVkX186LTESJy9A+8Kgc4kLZET7lo/kdFJ1y9coy8Vl0gsGtpBotjC+t0gJFFYUoOAkn3g61Pc7dhtbySToXNvNgFV7/NGPsztj07DKblCWi7TPVbjMiK6bZP9CO7pfh6rKBuKhuZJRsD2w5JXHbtYJxleTJHz3CmiisLsdQMiKm/+k6g+eP9sVcieQaXBV2vuj8eFK27A108xKnxys/cOcJaD0+wZHC+X3AIRmzcfnMAsKTxsT3NygDA3cDBsC5g6R17rY/5fZLtY5ejhtFgu1WeL49bv2szqU+7Do8zCNVIqUrX+/XYwd44hQMV/rZTlRIuS0aLRXYOo8o4RExsq9oASJubW1/Wn38HPWUwRaeHVKjJmytgWMcWonGKd9Nu8RFlg9jics5BjPphLI2ck1U5RJakMk2+j4Qtg0FPyZV4gevvbyxMVVvHsf+mimgUuju/N3iFXkR52Pdc4n4fe4uXNNu/xYCas4fmX8jBVh+KSUcUqjF0qJ25M2Vq7Rb2CZQrE4jkBl1cNAUHMUJ/gXQXzgBzK869rnfuyWnxypLjBggYkQALvneetQ4HN9sV1E4HD5rbT2Qedp0/hJwAUPq3kTi3FxOcivCGDZyyUP/3V3qQh1So0jO2+Mvv02Vhx6mDMqaaO8PYVSiRFwDOeu7e4i0rtD2/rux1OmvfxQv5Emndhm2AjOwv18TwcQnP+0KpxO3L/K4/cfX6DngrjbqrXEOIP3abMZm9sAaGwn92bM2PbmwAjnNwtlgDpLhvBULQO0MYJiaueWc/o+qdBFcx+lOjdOluHSxj6TTjN6rt21hJb1VJcRbdMDbw/D76mFIlvaQY/4JIu8d62sOeSJOXuTKOn/kGQemCe0qeheiYqzeANDM7gMWnek+L6mU7zLHc8rCOKgMSnMiy79NQzwJbQVngUnFPw0Tq/9D4tChPEn9Cb94U2KDd7X/GUDquKVkqQLthVBw5f
 AsTjnAK0
 WkUiEKLeYxu5gS2jgK64EJl2ap8OBP1t9cAIJLU69CofQ2kp7AsZ38NpRWopVz4f+JefVLXBHEcCwnA0LDbplD0ECooYIFVoPo6oCEJxuhkzpH8L4o1BGsPnRTlLNAH1YcLN3o4GyalTAvaXpc4ZlcIuh9VdJVcQXmNvsckQ6D0tl60NgL6U/jrfaFDd9xKFO2EZwe7Vgxjw3Hlek43WG5pSgU0oAJqrQE4oPVt4xwHBYicX2JfSwybpZr7BLE6cCRMoerkV1rHqhgYGxqlnClcudtbw+rRgPvmfk8jbO5QriVAdyCWYfwTaqo/H8L8TkQrCpCAvYRzMQOgmUbZHU8+XfaHUlqQ9WPygew/hFfAJ6ZKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

poll_get_entry() allocates new memory for poll_table entries using
__get_free_page().

kmalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of __get_free_page() with kmalloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/select.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 75978b18f48f..6fa63e48cdee 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -150,7 +150,7 @@ void poll_freewait(struct poll_wqueues *pwq)
 		} while (entry > p->entries);
 		old = p;
 		p = p->next;
-		free_page((unsigned long) old);
+		kfree(old);
 	}
 }
 EXPORT_SYMBOL(poll_freewait);
@@ -165,7 +165,7 @@ static struct poll_table_entry *poll_get_entry(struct poll_wqueues *p)
 	if (!table || POLL_TABLE_FULL(table)) {
 		struct poll_table_page *new_table;
 
-		new_table = (struct poll_table_page *) __get_free_page(GFP_KERNEL);
+		new_table = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!new_table) {
 			p->error = -ENOMEM;
 			return NULL;

-- 
2.53.0


