Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A43B0606F15E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZB6SOwJp
Received: by kanga.kvack.org (Postfix)
	id DD5A06B05BB; Tue, 10 Nov 2026 00:02:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86946B05BC; Tue, 10 Nov 2026 00:02:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74F56B05BD; Tue, 10 Nov 2026 00:02:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC606B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:13 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F09F416087B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:12 +0000 (UTC)
X-FDA: 85418012904.24.3D2BD46
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf21.hostedemail.com (Postfix) with ESMTP id 353D81C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZB6SOwJp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3UaXyagkKCMQ3k14x2kr4qyyqvo.mywvsx47-wwu5kmu.y1q@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3UaXyagkKCMQ3k14x2kr4qyyqvo.mywvsx47-wwu5kmu.y1q@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=daK/IkDIXVqnfjYl8/M+M9VjkzPIwCe5yl4tay+gSqg=;
	b=5eOKvjbB6yDWRvbwpYaOUYmFGUk48LR3LnQk8MSvFV7pH+gcUOxqJ//EXc2cBOr+lyqp+d
	4TmdC8hoULY47YRfP742YTohz6TRDR+wyGT+y2wIp2HfbyubzDrBW2fooKBVbLdI3YygvE
	yDkpuKh58R5obi47fgKseO8MjngRh8M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286931;
	b=Ln/EkA9yYsCBPA26LbL121UKDitjeXMLvDPYlH4RYD6VJZ2LFjblW+fpl+kwLkiM7mA9Qi
	4V+oxkBn+i0LroMUbOflZXBwPuNUQdjIxu+VUCgvEG0iA4c0tPkuKdM8Ai1JXWVRxqXsPl
	JWwu4kqUgoVfdaQH5GEOgyelXqOibkU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZB6SOwJp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3UaXyagkKCMQ3k14x2kr4qyyqvo.mywvsx47-wwu5kmu.y1q@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3UaXyagkKCMQ3k14x2kr4qyyqvo.mywvsx47-wwu5kmu.y1q@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b499549f64so1410036a12.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286930; x=1794891730; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=daK/IkDIXVqnfjYl8/M+M9VjkzPIwCe5yl4tay+gSqg=;
        b=ZB6SOwJpr89XnsWM0trAYRhAAVmAlgc34e9Ar3ZEddNCV7Z7OxjdSSOPsc8SCQHFFX
         7jGM16itz4HEdk+PefPYC3KAfzDXNezDLpGrxSYmloFcVud+FFBoQdX2DQgqTjXQBv7n
         jyEXYK4ToriFE3dJ0D2kDelzKgq73WgV4LT5hi5fW2gyFKbTdkbdCngwMB1BEX7a8VCa
         dHdws2e53EUPKksedsgoRNiJw00INdYWNNjfYPuGjZbHHkbL9sGhF/8ngo1C4VlFq4zi
         421jkXdg9g7g1Sv8EHXk5nb9nngMEgdenWWemk4V38x379duZHfvLDtzmhDReTWSCgXB
         HJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286930; x=1794891730;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=daK/IkDIXVqnfjYl8/M+M9VjkzPIwCe5yl4tay+gSqg=;
        b=zwdhpV4NQslTMyXCpWwXFgVoubEz3cScVxIau6AojX187EDSx2Z0HuwQvoF9Yik2Ad
         qRNrxuU+XScMJE3vHfteZQr93Jk8s45GsEkYHnvfwHPzBF7TEjJyAM3PQUcm5sA4/6AF
         ePLKUgrJbYwZep8L9NP+kGZGhyxsJpM5g/nFjYGsSw7mF7zZ/46uJGHSIZqAib1rzphd
         XZXfnNleG6W3feVjc6/JmCT8APSnU3TEK/qv1uBLIwvm9+WS8+DrUVSxqCxbRyBoXNmg
         J/lMWIM6RLXTceKQAXZH6Y9mqEbEnwKggZliSvSPqYsY7wEQnGAm+xfqkkZlL3bo57aK
         +sPg==
X-Forwarded-Encrypted: i=1; AL+hErEAwpzZD0Z7xnXpWJD5oJdAhqHGldghRJeX5kLnND4Y9PCy1VrsT9EkPEFlTEhhimnAHhLg7ocmcg==@kvack.org
X-Gm-Message-State: APuU4Z+vmrh2igbFHkbytkhIGE8Pa5udbtaP145WwtR969DCGD2Pse6g
	f3WYzC+TtsQcDS7B7jsgJxx/cFHTxgMR4/Ej/UgXnP7eVrOXSrEAwYxuTdOudGej/x9nK5fhe32
	g3larnhfbabqIq3zxXw==
X-Received: from edwl2.prod.google.com ([2002:a05:6402:1242:b0:6b3:bbb1:9405])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a6c3:10b0:6b4:8ba2:83ba with SMTP id 4fb4d7f45d1cf-6b756addabfmr786498a12.43.1794286929585;
 Mon, 09 Nov 2026 21:02:09 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:47 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-5-tarunsahu@google.com>
Subject: [PATCH v4 04/19] liveupdate: Reference struct luo_file_set_ser via
 serialized pointer
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: kday1hm78m11nh7z335jas4apdy6waft
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 353D81C0004
X-HE-Tag: 1794286931-287556
X-HE-Meta: U2FsdGVkX1+eE/OgIGdIpDASylX8RovDZKGf+pfdNmKo0TvFAHyPQQf0HtpgmPnXDPoIrnh/o1VyQz9slGdOSmJPS0xySgrCNhiSrFotodVLTOIdZT93urPBb9yf9E80s6gnA8u6UMB1Z6NFF/pyik7eOHWMWfFmbCzcsboryOmb8NdnHHup51OqmfAIvmBnhclL2aQnQAtEwj7RARyojtd+zvBGdTXmhMOjpNOO1FODhFgZkWRhFHQqfyBHTtXzD20cqwx/WHeKvPOp1L922GOREoKD4XaLqD1jmaO3xjz516M8DMKqyjpGA7sLqlyxeFIiZDBfCDAZ3QX24NToKdiLjlEzW0wTKeqzJLky8j1GhAUrRLJSQ0d3EWvj0TZokskL6uEDqMZUq/c4bUhYq/trYEXOQCuGEjXQM3Ws/f+K1M/+nCb+B48Wmso/9oV8dqOFIa8URCMp0BfruP+Mc2otXfLIsbw5DACZvTMO2jVnHhaYco8BWT55nu3g5rRAkVU57+D/3dxJXtqhyHWOko3Xanfmnfk3hETTWTooxJVd7JbsV305/QcKwVqOpiLUQCDlwKScH/0vuJsVZIMITNoIKWlA2awqcoK+1Xd686XGBiA/vNqstBJDBheOxHrh/N7IGmYamg0f6hNH/lbP4nuWMhpoOAlGxznY6VbKLcL1KV4ZqjIj2whcYVFJYsgG5wVb88YYWgfzec6q2tloA3b78WiobhMEQqWgW5tYhhewKcBu4m8KCiOsBTkVf28NDAlU12k6AlegoPmHKlsvz/wb47FuAbAAPjdmEtzvYpnU/QJHMeSqyXdYdfc+mtzUnkJfsxR0cnOxh4y/6N9dyVv8sn6GVrTYWptR+wRF9qCkvQaQ5yoNUcspgJItPshKzSM8hxkyegY/OK7S+oYNBi+zjIxO5582T+7QJhKWoe5aokaYABV5kS4fscGvK0+rzz+m9p4+GZ71m03OqnX
 dsuDIEy8
 vZvOBpNb2KjWRCCcDoncCAgdFIwKf2SN+urUeWgR4ayofBUvcYieruriHRiesix2q0iUWkJX5mtdkVwb+iqTUPpqi8KkcI361eLoidPHQz+N6dOSAn8U2Wl1NkdH35fZDWHSYBc+og78AA6n3/TfJDzswlcN3/SwcQSbTWbVctnYeXUAM5P2BNKPciM+CA7MZSue8Cl7qaK9AFx8lgahrYMqMXYFpZE/jqMEZkW4K6U+zlOiEkH8binKYu03Se1nsm5xaB4H7CEtV0mC1U2Ex8XfYVN2Aju82EWzr6wYA8x8swT0Ldydtu/SowrToHiaCM+CglEQXwRJQcB/t6vQ+9av2sCXo+/15BcuQmA7kIDdkHzkKt+r60WYO5Q0v4CdLFUOZb3ePIeg8L7i1uM04NU+FIlm7NMHgwlEaww8RRRpQjmAxoPQ0lfnjCg7GNPoGlvq0BXRYRuwUrCG1Z0b4HW8FdQNk2b3Xy5K4m5E2webL/VR2NX6rYIcnXmUxpKxo/HEXMbJYYuDKqZY0WHi/a6qxGxabW81uAKR0/8gh5sb+zfUVvUBdNbTULyRr3wcflGIkwUjj0xO/QZZETm1L91ngN/PnmjFe755J6ImyYcSyO2iubx0gzgYq+AyjlotJKzFjmxRu42U59YkRjWBo+6t12A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

struct luo_session_ser currently embeds struct luo_file_set_ser directly
by value. Embedding struct luo_file_set_ser couples the session layout's
size and field offsets to struct luo_file_set_ser, preventing either
structure from appending fields independently across kexec.

Convert struct luo_session_ser to hold a DECLARE_KHOSER_PTR pointer to
struct luo_file_set_ser instead of embedding it by value. Reserve space
for both structures in each session block-set entry, placing struct
luo_file_set_ser immediately after struct luo_session_ser, and bump
LUO_ABI_COMPATIBLE from luo-v5 to luo-v6.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h     |  9 +++++----
 kernel/liveupdate/luo_session.c | 27 ++++++++++++++++++++++-----
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 721949374fa1..f1152470f71a 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -61,13 +61,14 @@
 #include <linux/build_bug.h>
 #include <linux/kconfig.h>
 #include <linux/kho/abi/block.h>
+#include <linux/kho/abi/kexec_handover.h>
 #include <uapi/linux/liveupdate.h>
 
 /*
  * The LUO state is registered under this KHO entry name.
  */
 #define LUO_KHO_ENTRY_NAME	"LUO"
-#define LUO_ABI_COMPATIBLE	"luo-v5"
+#define LUO_ABI_COMPATIBLE	"luo-v6"
 #define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
 
 /**
@@ -133,7 +134,7 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
  * struct luo_session_ser - Represents the serialized metadata for a LUO session.
  * @name:         The unique name of the session, provided by the userspace at
  *                the time of session creation.
- * @file_set_ser: Serialized files belonging to this session,
+ * @file_set_ser: Serialized pointer to the files belonging to this session.
  *
  * This structure is used to package session-specific metadata for transfer
  * between kernels via Kexec Handover. An array of these structures (one per
@@ -144,10 +145,10 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
  */
 struct luo_session_ser {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
-	struct luo_file_set_ser file_set_ser;
+	DECLARE_KHOSER_PTR(file_set_ser, struct luo_file_set_ser *);
 };
 
-static_assert(sizeof(struct luo_session_ser) == 80);
+static_assert(sizeof(struct luo_session_ser) == 72);
 static_assert(!IS_ENABLED(CONFIG_64BIT) ||
 	      __alignof__(struct luo_session_ser) == 8);
 
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 74bc66929f4b..df667fe15fb2 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -131,18 +131,21 @@ struct luo_session_global {
 	struct luo_session_header outgoing;
 };
 
+#define LUO_SESSION_SER_SIZE (sizeof(struct luo_session_ser) + \
+			      sizeof(struct luo_file_set_ser))
+
 static struct luo_session_global luo_session_global = {
 	.incoming = {
 		.list = LIST_HEAD_INIT(luo_session_global.incoming.list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.incoming.rwsem),
 		.block_set = KHO_BLOCK_SET_INIT(luo_session_global.incoming.block_set,
-						sizeof(struct luo_session_ser)),
+						LUO_SESSION_SER_SIZE),
 	},
 	.outgoing = {
 		.list = LIST_HEAD_INIT(luo_session_global.outgoing.list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.outgoing.rwsem),
 		.block_set = KHO_BLOCK_SET_INIT(luo_session_global.outgoing.block_set,
-						sizeof(struct luo_session_ser)),
+						LUO_SESSION_SER_SIZE),
 	},
 };
 
@@ -223,14 +226,16 @@ static void luo_session_unfreeze_one(struct luo_session *session,
 				     struct luo_session_ser *ser)
 {
 	guard(mutex)(&session->mutex);
-	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
+	luo_file_unfreeze(&session->file_set,
+			  KHOSER_LOAD_PTR(ser->file_set_ser));
 }
 
 static int luo_session_freeze_one(struct luo_session *session,
 				  struct luo_session_ser *ser)
 {
 	guard(mutex)(&session->mutex);
-	return luo_file_freeze(&session->file_set, &ser->file_set_ser);
+	return luo_file_freeze(&session->file_set,
+			       KHOSER_LOAD_PTR(ser->file_set_ser));
 }
 
 static int luo_session_release(struct inode *inodep, struct file *filep)
@@ -552,6 +557,17 @@ int __init luo_session_setup_incoming(u64 sessions_pa)
 	return 0;
 }
 
+static struct luo_session_ser *luo_session_ser_init(void *mem)
+{
+	struct luo_file_set_ser *file_set_ser;
+	struct luo_session_ser *ser = mem;
+
+	file_set_ser = mem + sizeof(struct luo_session_ser);
+	KHOSER_STORE_PTR(ser->file_set_ser, file_set_ser);
+
+	return ser;
+}
+
 static int luo_session_deserialize_one(struct luo_session_header *sh,
 				       struct luo_session_ser *ser)
 {
@@ -575,7 +591,7 @@ static int luo_session_deserialize_one(struct luo_session_header *sh,
 
 	scoped_guard(mutex, &session->mutex) {
 		err = luo_file_deserialize(&session->file_set,
-					   &ser->file_set_ser);
+					   KHOSER_LOAD_PTR(ser->file_set_ser));
 	}
 	if (err) {
 		pr_warn("Failed to deserialize files for session [%s] %pe\n",
@@ -657,6 +673,7 @@ int luo_session_serialize(void)
 			goto err_undo;
 		}
 
+		ser = luo_session_ser_init(ser);
 		err = luo_session_freeze_one(session, ser);
 		if (err) {
 			kho_block_set_it_prev(&it);
-- 
2.56.0.506.g506a7eabc5-goog


