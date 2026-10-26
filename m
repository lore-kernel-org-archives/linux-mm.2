Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE36606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 01:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=EQZ8zI5o
Received: by kanga.kvack.org (Postfix)
	id 553076B05B0; Sun, 25 Oct 2026 21:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504196B05B1; Sun, 25 Oct 2026 21:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2986B05B2; Sun, 25 Oct 2026 21:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC616B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 21:49:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 60AC01A05EE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:49:54 +0000 (UTC)
X-FDA: 85363096308.27.F4478AD
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id 92ED6140002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:49:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EQZ8zI5o;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792979392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gj50Wyl35b8FQCs8zNwzAdmPqWzyuGVVyabxqbOdDKA=;
	b=zDfgzizFQXv0FLGMNZV6YvYe6IiWMU6+uno1c6558y6CHONqWnCh08nMztc6+PlqqpSyo1
	x4RioOVjzYvc5ft9Eh+hzNq9vZuCbcc51no7Rpq8o0tINqyPuEkxIChnPyhPkds0RVzhTc
	eKEybRkjfDJewhW7/Tn8b11EHS8dg/4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EQZ8zI5o;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792979392;
	b=5IyZ7tUiekZZHpSPNpxpxXCY2LVyrTVlTEeMWXUr3/aD3zo8jAgzv5BESI6Xdz3bjeQh1o
	XUVGg/C0s5byHQtd7fslkPNnD8AfCyuhaLsWHsGOiXTWmShmkf+W+/5YbXwg2mcrl7JKni
	fc8LvwsVQuXojtLzToHERJp78B8wOQI=
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7cc013095d4so681644137.2
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792979392; x=1793584192; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gj50Wyl35b8FQCs8zNwzAdmPqWzyuGVVyabxqbOdDKA=;
        b=EQZ8zI5ooX6yhRQR+qqt8HL5jmcphbzHIy05FIRKKpFTdFn8cQE80PVk59KwcXM/pW
         tWqvv12GdQ2O9te6XhYngLAyKy3vAjyX5xfqRLwC3w+uxxr1fWw8tT2kVrmwGe2tZqRX
         St+YhqCEzbyjMcYlVXwlfplc4hxpULrK2sFR2OiOtCwgsItHM9OwCBece1W2C8yblN+A
         aH0Itzl5J86TBunUgPoQphhYXwHaQCHsB0zU0g6M1c99po7+q+QxW7brEPUKTM+o51Yy
         PYTInylal9AXqVrkfd0sO8fSFwDhG3xlkCsi1uZJ1ZpxGuSJJWPDGT7nGqCtzkNGrY+U
         0Rrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792979392; x=1793584192;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gj50Wyl35b8FQCs8zNwzAdmPqWzyuGVVyabxqbOdDKA=;
        b=nE7uNUqCNl5gVoOU3cf81fbwu/VxPStqwnj7VXx48D2DdEMHyfS1PXIcA+WGCxJvZD
         Ek7r9G9J7bPs79d4znFLwfkYmm6YadzseeIftyWYncPrPIABN3DuTHlWN9VTHgJzTMwI
         RMV79EQvJ1M/gbiHgSWfOJALMAC0Y+OLP/BRWM0CqEguuMWz7PqcXcuklr1JT5emK6zJ
         8sEeo5GP79oHO1MpJ06aDE2OC5N7ctiF0V0uIbgU7FqIDKMbssmlDh1kdypLJ/SCpOOm
         VjaHmrr6TOXMs+u6erEuSv+Ozo/w5IMtArjspkxkjItZjxMHm/2VpMcdf9HWriLm8zDs
         QIfQ==
X-Forwarded-Encrypted: i=1; AKwUvBwQdDbwbY/4CVgynurAlPIWMfCp+0FqpNLtWoAl8gkPHLCe+cBUx323P0dywV/W2qs8m/93y48mNg==@kvack.org
X-Gm-Message-State: AFq9FYISST+NvYwE+m+YYfsfJLOLimq0Ab3TsbZU8F8Y2nHYDw0toAeT
	3H4xYkYZlC4p1lHy3nidRoKHkm6pj2LcShpPa+fkvKo1b16RZeJZE2pfsOE22zJEM3w=
X-Gm-Gg: AYBFou225Mr80bODzmdWi0Map1NSp4dZU4v5YvNg8ZPfjYEes/KsYROvIdKTzrlJNdQ
	RahJO9T9u5bsfSypm2QiQSEUkEZVsKc10q01ewNU7879Fm57fAvy1NCPPpRUKr+tTELUCGrYAIM
	pqTOpFXRy6GGMhLG7vvSPZb4LzVfL31Gt0VbX7VWkh6OaiIBq23FRw8zcNNKH7cPsTsBpn0SkM/
	HeAQpiL0/vCKiUHkzQeZ/T/nSIOq+Y+eQX4LDP7BPh+5GHZdF3MElf8Gixf12kiFp8RB1wpS7xV
	eeo3kxIRj+EuH2SM5IRKmOINRc6d2mTBrQAQcm7OVy+FE2yuQQfL1JVWf0JAc9pNRHD3YYlixsq
	2VwjEHxIWzV8rujmgvMXwxlptOdqK3EkmLTQ+0oR9epcPoIzBszvzJMq3UNASdwiAWWg04wbm/P
	jR1JZMoMq/fmeutp0rjRvCe+AVifPavyzDv03p0bY7vzveZ1mew/dt3MdmiNBPLenNHy0goQzpq
	ah+Z+pBBQRPH6yN3Xfogk5fYycDkAn4f2VihAgN6kv1ZpREVrO5f1BwosLCd8REH1kknroPGNss
	uUkl31rqV8eXkxqtGpL8guuWDElWZ7YqWth3U/gK4Q8TynJHH0twDqTItxgXMrtQz1XLrAiPUfo
	o
X-Received: by 2002:a05:6102:38ce:b0:7a6:b8fe:e834 with SMTP id ada2fe7eead31-7ce5cd91472mr1215927137.27.1792979391619;
        Sun, 25 Oct 2026 18:49:51 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7ce5df73970sm6099917137.1.2026.10.25.18.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 18:49:51 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [PATCH v4 1/3] liveupdate: Move file_set_ser handling to session serialization helpers
Date: Sun, 25 Oct 2026 21:49:44 -0400
Message-ID: <20261026014948.162559-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261026014948.162559-1-pasha.tatashin@soleen.com>
References: <20261026014948.162559-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 92ED6140002
X-Stat-Signature: k6bj94y3fctonc8ij949ofio7akdaj5m
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792979392-941848
X-HE-Meta: U2FsdGVkX194CoPLfVAXh5/bkdDNZc8L66MxT16jqpWp+LuIUWbSsk5AGeuJKAX+dP/F2vY6vYDHQg37m/9+xbgo8fRYMFN+MA+hb5UXEmL5RjpYlGXgjODCY0QbFijMKXCuHUgmd42LfIff8EGAdYr7zRCGRI4VjLhsim/+68uu+1qpa4lKCWnAphbr+30fiS74XIBtLU6kcApPNOao05w6+vRuy2gwUNfwGG7kjN2s16GoK+BgGmi7owCGV9g5CFCYzbxfcv3/DrwkGNELyZM6+GbmzNUiNlUzDYT5YY+jK5WMDe7tPY0C0FgunmLbDFBD04QJNogXULKGNkQcf8lV2encZ2pjwbGQtoUqcPgY3eYofdXOVnXdPSw+V0pd1kwGlEGcz9LrckZaf+r95hTwxUqHvv6Efpxj2mWysd3CcDG5sD8AHkx6ByA/Atcs1pe0fZltZZ6kQfPk6OUSdCaa5QTbyu2ho3Dhc58GWwN0beA9Hw2edUAIAWEU3o7l2fml2LdOIycjr1cX012N8FC13JAD5y8PgPhsyfx7apXZefRfZysY6UU4ETwN8DX3tmQ9wA97czvX0Ibs9eu96/KjhBRY4djZH9S0tILhxABhuJ2E4wnbo7SlwL1tzxuSwmNLpV3w7SRtZyviVS7kP99wBIZ6vZ+6zuau50K8DVdSPtcQMJfo3yJmg1NZw3IyCucPyg72nnG3NfrzYfXHji2rj5ZFP/1ygu4iNluDTTMPx9LhpwpYg3HkEn4IuwKh+rQxgkCzbGGQ4B6z4Lg46NdBghmyR0g7g/168rgYJ/ssIiWmG9yE27iXhmHnP5a+auMh2pRiYjJkyxXCtK/KLZPsqa0BoVsqd6wzYeThGVYMigHYDzjtMMJoyGdTUbR/E3cJwzN33u3C7vLtghpnTJtnKM1/bBf0iVeB+weaxGVb+d2Lzv9P5XXniJF5ke1dCWNRnwF1C7Q3Bzn1G3u
 isZA8o25
 0nj4Gn+8FS0dUOrdFQTIqTcLbVSEwtntoROvwPecUntVgzjxeksFHvwK4B+uzgUZm68tABZL1pSEfWJJgel0dslBiLfAkesizgg3woQJtZm03lx5QNFJsDyMzN5tBkPD19siWSNlQDo8U1CRXDdMy/CLc2vzxNT4GJ2PREgDg8SbAL1f8ox6dIVxIXn5aBNSVjktY3shzakUEnLqylKuUBOFUxdOS0xuDjFl4EgV79sDUB157NtU3fwoDisPgJZFsMJ+OPRWnDArDHX0zTr4Tja1hGXISyRWQ28M9aZwbzDFNvM8jbrFPNgKbmv181/r3oz+vUGtOCWdvgQpS4DwGToC4jQ/rET3uzzIbUVjk7hwNKjxQ6ypHyCPTzgpOJsd6y6Vz1Ru5lZR/oEIGI1tUc5RSEvs2ZHOYigR1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, struct luo_session_ser is populated and cleared across two
layers: luo_session_serialize() writes and clears ser->name, while
luo_file_freeze() and luo_file_unfreeze() write and clear
ser->file_set_ser.

In preparation for allowing userspace to freeze a session explicitly
before kexec reboot, luo_file_freeze() and luo_file_unfreeze() need to
be called on session->file_set before any struct luo_session_ser entry
is reserved in luo_session_serialize().

Drop the struct luo_file_set_ser pointer parameter from
luo_file_freeze() and luo_file_unfreeze(), and rename
luo_session_freeze_one() and luo_session_unfreeze_one() to
luo_session_serialize_one() and luo_session_unserialize_one() so that
all fields of struct luo_session_ser are populated and cleared in one
place.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c     | 24 ++++++++----------------
 kernel/liveupdate/luo_internal.h |  6 ++----
 kernel/liveupdate/luo_session.c  | 31 ++++++++++++++++++++-----------
 3 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a39992da504f..988eb313a135 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -440,8 +440,7 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 
 /**
  * luo_file_freeze - Freezes all preserved files and serializes their metadata.
- * @file_set:     The file_set whose files are to be frozen.
- * @file_set_ser: Where to put the serialized file_set.
+ * @file_set: The file_set whose files are to be frozen.
  *
  * This function is called from the reboot() syscall path, just before the
  * kernel transitions to the new image via kexec. Its purpose is to perform the
@@ -457,8 +456,8 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
  *
  * 2. Serializes Metadata: After a successful freeze, it copies the final file
  *    metadata—the handler's compatible string, the user token, and the final
- *    private data handle—into the pre-allocated contiguous memory buffer
- *    (file_set->files) that will be handed over to the next kernel via KHO.
+ *    private data handle—into the pre-allocated serialization blocks
+ *    (file_set->block_set) that will be handed over to the next kernel via KHO.
  *
  * Error Handling (Rollback):
  * This function is atomic. If any handler's .freeze() operation fails, the
@@ -471,8 +470,7 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
  * Context: Called only from the liveupdate_reboot() path.
  * Return: 0 on success, or a negative errno on failure.
  */
-int luo_file_freeze(struct luo_file_set *file_set,
-		    struct luo_file_set_ser *file_set_ser)
+int luo_file_freeze(struct luo_file_set *file_set)
 {
 	struct luo_file *luo_file;
 	struct kho_block_set_it it;
@@ -506,9 +504,6 @@ int luo_file_freeze(struct luo_file_set *file_set,
 		file_ser->token = luo_file->token;
 	}
 
-	file_set_ser->count = file_set->count;
-	file_set_ser->files = kho_block_set_head_pa(&file_set->block_set);
-
 	return 0;
 
 err_unfreeze:
@@ -519,28 +514,25 @@ int luo_file_freeze(struct luo_file_set *file_set,
 
 /**
  * luo_file_unfreeze - Unfreezes all files in a file_set and clear serialization
- * @file_set:     The file_set whose files are to be unfrozen.
- * @file_set_ser: Serialized file_set.
+ * @file_set: The file_set whose files are to be unfrozen.
  *
  * This function rolls back the state of all files in a file_set after the
  * freeze phase has begun but must be aborted. It is the counterpart to
  * luo_file_freeze().
  *
  * It invokes the __luo_file_unfreeze() helper with a NULL argument, which
- * signals the helper to iterate through all files in the file_set and call
- * their respective .unfreeze() handler callbacks.
+ * signals the helper to iterate through all files in the file_set, call their
+ * respective .unfreeze() handler callbacks, and clear the serialized blocks.
  *
  * Context: This is called when the live update is aborted during
  *          the reboot() syscall, after luo_file_freeze() has been called.
  */
-void luo_file_unfreeze(struct luo_file_set *file_set,
-		       struct luo_file_set_ser *file_set_ser)
+void luo_file_unfreeze(struct luo_file_set *file_set)
 {
 	if (!file_set->count)
 		return;
 
 	__luo_file_unfreeze(file_set, NULL);
-	memset(file_set_ser, 0, sizeof(*file_set_ser));
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dac6644bfb18..01a172cd9d7a 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -103,10 +103,8 @@ int luo_session_deserialize(void);
 
 int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
-int luo_file_freeze(struct luo_file_set *file_set,
-		    struct luo_file_set_ser *file_set_ser);
-void luo_file_unfreeze(struct luo_file_set *file_set,
-		       struct luo_file_set_ser *file_set_ser);
+int luo_file_freeze(struct luo_file_set *file_set);
+void luo_file_unfreeze(struct luo_file_set *file_set);
 int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		      struct file **filep);
 int luo_file_finish(struct luo_file_set *file_set);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index f48e9a4185f9..827f9ad1938f 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -218,18 +218,30 @@ static int luo_session_finish_one(struct luo_session *session)
 	return luo_file_finish(&session->file_set);
 }
 
-static void luo_session_unfreeze_one(struct luo_session *session,
-				     struct luo_session_ser *ser)
+static void luo_session_unserialize_one(struct luo_session *session,
+					struct luo_session_ser *ser)
 {
 	guard(mutex)(&session->mutex);
-	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
+	luo_file_unfreeze(&session->file_set);
+	memset(ser, 0, sizeof(*ser));
 }
 
-static int luo_session_freeze_one(struct luo_session *session,
-				  struct luo_session_ser *ser)
+static int luo_session_serialize_one(struct luo_session *session,
+				     struct luo_session_ser *ser)
 {
+	int err;
+
 	guard(mutex)(&session->mutex);
-	return luo_file_freeze(&session->file_set, &ser->file_set_ser);
+	err = luo_file_freeze(&session->file_set);
+	if (err)
+		return err;
+
+	strscpy(ser->name, session->name, sizeof(ser->name));
+	ser->file_set_ser.count = session->file_set.count;
+	ser->file_set_ser.files =
+		kho_block_set_head_pa(&session->file_set.block_set);
+
+	return 0;
 }
 
 static int luo_session_release(struct inode *inodep, struct file *filep)
@@ -656,13 +668,11 @@ int luo_session_serialize(void)
 			goto err_undo;
 		}
 
-		err = luo_session_freeze_one(session, ser);
+		err = luo_session_serialize_one(session, ser);
 		if (err) {
 			kho_block_set_it_prev(&it);
 			goto err_undo;
 		}
-
-		strscpy(ser->name, session->name, sizeof(ser->name));
 	}
 
 	if (sh->count > 0)
@@ -675,8 +685,7 @@ int luo_session_serialize(void)
 	list_for_each_entry_continue_reverse(session, &sh->list, list) {
 		struct luo_session_ser *ser = kho_block_set_it_prev(&it);
 
-		luo_session_unfreeze_one(session, ser);
-		memset(ser->name, 0, sizeof(ser->name));
+		luo_session_unserialize_one(session, ser);
 	}
 	up_write(&sh->rwsem);
 	up_write(&luo_session_serialize_rwsem);
-- 
2.56.0.307.g5fe7bd680c-goog


