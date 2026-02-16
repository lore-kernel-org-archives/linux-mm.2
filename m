Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03F50E7BDAC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637546B0088; Mon, 16 Feb 2026 08:32:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1016B0089; Mon, 16 Feb 2026 08:32:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4606B008A; Mon, 16 Feb 2026 08:32:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 388066B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:32:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF36C8D207
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:24 +0000 (UTC)
X-FDA: 84450409008.19.DAEAFF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D346640006
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LpeBzW5m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248743; a=rsa-sha256;
	cv=none;
	b=OwW0vyruERUGWHKSu2NNHCZnEv+s9oFG8BO6KOda2lEAFDezj+9ymvvtx5mCq/6kmzJKQS
	aZGEK1CD6FYvDnHvjJ/4ti+iB8qaViJONP1zhwVwghENfu/qtMj0txus/oeyLcHdIFZPDO
	3dAYhgivKUcnV2LBHEVC/6U4QGsmrjM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LpeBzW5m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qxzbVmYrDkR1e5Q+0qWRbD8LkULMRf7nSR+57RKMwuA=;
	b=GS4tcQfhKAXSuPZYgj7usTxS4BAY6m674F/RvHnzRnOyg25lh5iR5LBX6fCloN8bb+ZDLO
	mesESZqEizXkMbr+GJ8ZAmEQRRyEy1bUoenlkOUKoN8o4B014QZoDxFucrEWvxo3C9+Gi8
	MIzSGj8sBg1yzOq03PZ8urYwvydiR8c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1328E438F8;
	Mon, 16 Feb 2026 13:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1D2C19423;
	Mon, 16 Feb 2026 13:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248741;
	bh=GQODvPKfpe1TuAASNlfZOpKx+opiPpT2Vm9Zk2O6rrw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LpeBzW5mKUxVFtLej99Vdf/DLsg/Lz5wVffdIB06ucKJPM75RkE2zw6eu2gjLAXY2
	 el/H2qkyx1qaloadnIfPom8wn/ga6OBtW96Kv80BBigoWZAesiZnp3CaXK5yO1AZdU
	 OPX9Xd/XtjLC1QmeBSXIZmPE9mhstsztwVmmhHQGEoFGOQ0V9kguWN4aILDUDeOb88
	 EkJJN7eIrl4ryh405XEph+QaqlOLsNFbrzrvZN28wgbc2mL43EzhIvvPbiC75ijZbf
	 h6at3a+Jt1uSrnUQFUHnP/J3xlPzVLSj0LZrGXC4SfyZ1+k0pOlk2cvdjPTR0Ms4dg
	 X9H6BjBtmKm2w==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Feb 2026 14:31:57 +0100
Subject: [PATCH 01/14] xattr: add rcu_head and rhash_head to struct
 simple_xattr
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-work-xattr-socket-v1-1-c2efa4f74cb7@kernel.org>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
In-Reply-To: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jeff Layton <jlayton@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
 linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, 
 netdev@vger.kernel.org, Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2838; i=brauner@kernel.org;
 h=from:subject:message-id; bh=GQODvPKfpe1TuAASNlfZOpKx+opiPpT2Vm9Zk2O6rrw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlomTaIl83Gt+OeTiNWF1CbMFL08cD3PetfQlJ0PZx
 WbTawUuHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMxPMrwz1Ci5rhPAFOf3LKl
 78uOf5myJuvMsYUScicmG/244j11URIjw3++OjWV4xdd132cI+jgbPpzp/iMCku2ZWmmKV6996u
 YWQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D346640006
X-Stat-Signature: n1ho3fei4gi7rztshpu6ojm7kek3dgow
X-HE-Tag: 1771248742-170728
X-HE-Meta: U2FsdGVkX1/WAsYKOpFBunNuB2lPLxLM689DFkOztGQuMxVKR5nZyNeDzJgasEYKO+CEP4yLWN7t0rHGq/JQO3A9MGrdEzYiii1VRRcOvQC9UQGwarPvGOBbMmg5Ocz1mSukeriW4vapMmrZchx6uff0UDITsuYA8/dymCAdXJ7dVn4aMTtIPyuxDUTe1l++tb31IaPIbOskJWWO1z55a9RSFEsdEX4atASKyIGvR+OFeIV1XwbaAM4kn9PDQVdXQTc4viI7tFTCd6snISS5zcDPEsE392CoVuwFHKTUjDylYbMomWsNwAda0VYoKQ/EvOWO9FZq3D9WTQiLgRPk/LjbkrzqYJkGZxOYnxHd6plsApLFkEB4YA6R6gGH8cHBdBV+/1Bipa4+GRvFi09LnMCB+CUN1Jaa1mR7B7ghLnUQvhqDlLUfs+BeyfU9pv7lr8nvIz+HJhWNlK7U2c9aprLnC5TNl+ze/bCraaEYiceJDwS3gcGXfugQnPECtIYiUBgD9oQz+Tfbf/4gATxLUCqsNooRL/FQEmibkAMY0cY/8Trx2M/yxB7k+EVbojvgqVHk4hBwOMkKYuXxn2T2vUMBQUsTEw7vpKVDSD7esF9Hga0zjuAKW6HD36hN1TNf+qPNc4NMWjUzAk0rBeeW0VOXJQtu7fHJBW4NcJyKo+aMHlRgo+DU9GTAiB8FF7IRDapg8xrYGEDQ6+6bWfTOxgpJOUrHXUdZPDF3UZX8ro78gExgYBEogy93N0fVPSBl59NNTFPhupvMm8t2/EjT737r/QEkzayZgzT245fAGJVfnTKJVc4ODMMX8dlCTV99fVpCupPyB0UBqytoodx679MW6T+xzQN+hkYy92+2U/7nzo3dgWkURt/smxtx1QNtXTnunQ37sC4tCR8VK0q+xuxphgYN3Gg/6G+376yKGb6OLZJbSan6t0RU11lPq8YeSOnplv8fl2yt3I68eC8
 tcjGC5TK
 ewps9Ux06g1CSeThFf753nknwE92slSa3XGQF8rSjAbwSbHyN3aypdeFLcD9qS8z19wFl8TkkG4bFMV/Hv14YKw7u3jnkQc1KPFdYwsRYqEYQYXpvnZyz9gPM3HKuJJL4JHevKlXhUR7QPLbqE5bdr+Gyk7MDimDN2UF0pHCaNw11Wx/Wif6aQ8jcbJWzdPSg0C/O4iGxqyCkR1lupOi9T8kcceg3RDxu0d7ONI7oLYGDuIxrlpATuonR0ccji2LlxhCYdbdaka21iNQDBcxvI/jMHDRdke+HCXGsO0oTtzkOhCFgTepu332css5vJWqRBa2YEJwPu41kyopvia2l3N+DLFR76Q0SzDvW8Vbf3MklVC8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for converting simple_xattrs from rbtree to rhashtable,
add rhash_head and rcu_head members to struct simple_xattr. The
rhashtable implementation will use rhash_head for hash table linkage
and RCU-based lockless reads, requiring that replaced or removed xattr
entries be freed via call_rcu() rather than immediately.

Add simple_xattr_free_rcu() which schedules RCU-deferred freeing of an
xattr entry.  This will be used by callers of simple_xattr_set() once
they switch to the rhashtable-based xattr store.

No functional changes.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/xattr.c            | 23 +++++++++++++++++++++++
 include/linux/xattr.h |  4 ++++
 2 files changed, 27 insertions(+)

diff --git a/fs/xattr.c b/fs/xattr.c
index 3e49e612e1ba..9cbb1917bcb2 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -1197,6 +1197,29 @@ void simple_xattr_free(struct simple_xattr *xattr)
 	kvfree(xattr);
 }
 
+static void simple_xattr_rcu_free(struct rcu_head *head)
+{
+	struct simple_xattr *xattr;
+
+	xattr = container_of(head, struct simple_xattr, rcu);
+	simple_xattr_free(xattr);
+}
+
+/**
+ * simple_xattr_free_rcu - free an xattr object after an RCU grace period
+ * @xattr: the xattr object
+ *
+ * Schedule RCU-deferred freeing of an xattr entry. This is used by
+ * rhashtable-based callers of simple_xattr_set() that replace or remove
+ * an existing entry while concurrent RCU readers may still be accessing
+ * it.
+ */
+void simple_xattr_free_rcu(struct simple_xattr *xattr)
+{
+	if (xattr)
+		call_rcu(&xattr->rcu, simple_xattr_rcu_free);
+}
+
 /**
  * simple_xattr_alloc - allocate new xattr object
  * @value: value of the xattr object
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 64e9afe7d647..1328f2bfd2ce 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/mm.h>
+#include <linux/rhashtable-types.h>
 #include <linux/user_namespace.h>
 #include <uapi/linux/xattr.h>
 
@@ -112,6 +113,8 @@ struct simple_xattrs {
 
 struct simple_xattr {
 	struct rb_node rb_node;
+	struct rhash_head hash_node;
+	struct rcu_head rcu;
 	char *name;
 	size_t size;
 	char value[];
@@ -122,6 +125,7 @@ void simple_xattrs_free(struct simple_xattrs *xattrs, size_t *freed_space);
 size_t simple_xattr_space(const char *name, size_t size);
 struct simple_xattr *simple_xattr_alloc(const void *value, size_t size);
 void simple_xattr_free(struct simple_xattr *xattr);
+void simple_xattr_free_rcu(struct simple_xattr *xattr);
 int simple_xattr_get(struct simple_xattrs *xattrs, const char *name,
 		     void *buffer, size_t size);
 struct simple_xattr *simple_xattr_set(struct simple_xattrs *xattrs,

-- 
2.47.3


