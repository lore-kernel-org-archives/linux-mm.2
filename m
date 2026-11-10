Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFBF0606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TVcyHMrA
Received: by kanga.kvack.org (Postfix)
	id 6D09C6B05C2; Tue, 10 Nov 2026 00:02:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A876B05C3; Tue, 10 Nov 2026 00:02:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD126B05C4; Tue, 10 Nov 2026 00:02:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 169916B05C2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 90A621A08AE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:20 +0000 (UTC)
X-FDA: 85418013240.01.997CA0A
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7BB0A0007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TVcyHMrA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3WaXyagkKCMwBs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3WaXyagkKCMwBs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPe/n/7OHPWH7BQXApvZomY3AKt9T7o7Wopgeakkuns=;
	b=s4UF1VTZBtYofiSpEAFi+JfxP4XIV8o8eC/30BTCjZGgr9v35phI7FAWHumh58JMpaDPQ0
	CfzWuiLG4rZ5dSMMbkukj5m2h9ikzwyKeyG3uYlIpr/Oi/nNCOMi1R6nGjKWcYLO5fq4zN
	nRcAxscUhhAHhk7Pt5s6aDBZBzH9Q4w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TVcyHMrA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3WaXyagkKCMwBs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3WaXyagkKCMwBs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286939;
	b=n2tzxm8KJbD03wqV0m+xcyr1LuPYysP3/N4UQpUpIYXr1WXQZuNFFoJt6PCOVNrXr914k6
	Qjhu6EjpjEwHe1eg45hql96S5tczU7kgf2JXJt8S2YR6yXaTjccREI3f9r/VO0Q0Qkim/y
	m011Dejct3CQKNzcXtBRKTj86mtYlpc=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b70b9f6e0aso2089462a12.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286937; x=1794891737; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bPe/n/7OHPWH7BQXApvZomY3AKt9T7o7Wopgeakkuns=;
        b=TVcyHMrAIotx3wympwqld4Ul2XcixErVcG+ooBsVpN97yeJ04d6hHugdnBqlDtThXJ
         4rO6jMWAf11FrZ8EtV9+VOaq0lRyFQ4QGfY9ayPNc5lLXhN8T2nwnYvb8iUwoyjO4QFf
         vhUqijPuXq5PFaJxUpHFsg8cPUY6wAMVA/Rz0A+NcXj2mls1I8Zy9r3iWzvwcKH9HLk5
         /E2AHYG4ymeneSpeWLHN+WQsMnX40B3Dvbo8QLOMRB2tdzI1Vn9XRLhdfM0O2r6ChNjJ
         XppHvMeI8DS3VO33mQJIeti+LhZ76GCpuIhQ4WMn8Mmha9uTPFnX6JfuNGnf6Tq0zUjN
         dIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286937; x=1794891737;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bPe/n/7OHPWH7BQXApvZomY3AKt9T7o7Wopgeakkuns=;
        b=TQca4CxZOzfEirfeBDJfE4+lQ/G1LXjPKOVdRSzz/3ZaB9V+9M8mozEWG910YYf6i5
         mx9XRXSWO2MILPxT8kJHKzWPe462XHSKv0zCh/KZHoSnw99e9FAYvNQe6/rm9X3xQs48
         t2+uYs33qJ0e1HvxG9Sjps7/GKZRAg9GewFlDCp5WBGmv3KxO/n/N90ONoqVlE1B13AN
         EjgKtmSCCWxPGSiJlxZ1Xyk7dYDrUh+10zl59TYW8+c8oYd9Yx2RjEK8EMOG76VFteTD
         drlLBSLuhrfTEHFhOX3l2W5sR4yRyPP5NTtQy7hdeheKHIBkoSfYUXA9yqsuFiI+FBxQ
         GR9w==
X-Forwarded-Encrypted: i=1; AL+hErHitjkJ6TYYxoN+38CNbT0fbN54DRB8qLdJOKkZ4RWedA85bHfWbzudTfb5RY9cEvVj7Br2lBm0cg==@kvack.org
X-Gm-Message-State: APuU4Z/9IX2btRPpVxhk+esi9IZaFbm969I7zTpoTfFIv3CF14zUgva6
	fxLUy7lnr/31/TiZcpr/wSY/1Dpd5ZwaUJMJk83PcOhn+y6xAKPd72AwCBfoJXGNIsnI4FO36gC
	h7Ng8om5bSMTahdOxVg==
X-Received: from edcp5.prod.google.com ([2002:a05:6402:43c5:b0:6b5:8717:e943])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3907:b0:6b5:5fca:3d5 with SMTP id 4fb4d7f45d1cf-6b756ad6f48mr1260878a12.19.1794286937148;
 Mon, 09 Nov 2026 21:02:17 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:54 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-12-tarunsahu@google.com>
Subject: [PATCH v4 11/19] liveupdate: Add feature header to struct luo_file_set_ser
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D7BB0A0007
X-Stat-Signature: 1xph1q6xxfrng7y9eo3mctte5t388tim
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794286938-88579
X-HE-Meta: U2FsdGVkX19q4sDz9WIZgZtgLgO5AgOWhnVGLjv8rckUHxDDds+ccf9bl5tH2LWb12wKUMhartW35EySRCCDF4EfK7/dCUCje1L8Akxc+4HHmc+xulgkkCSz7EBQ1bSO9UzPAjG8atQH5SP6EAKmVoEq97D27iUe3tRimt8siw0wzK4WhPgqa4tJ1bhZd7l6KUNUbyiR0NnyGzRu1aJXDFh1Kjzg6vxAHl8OHjd/6MrAWSTvLFjV+HupGRyyrbZ/S4FnR7vCwfjJhcNafAqX4hKtXjRRAo5NSYLPFq1/kB0TVGjuT4z7KddY+VNQ9uRGrl2U++FGB8thZUkj6UbcsBNXOUnaO8EUGcpJwKQZtKo5wreMkgOel65RTrcQpSZ2T84/zIGKYtIej4Ds/2huullBQZadSOci3Xf1Cs8Qbemx2uIgX/RH8POmAGlTT+BFiRCVHBn7ifDyR/QwAw5vhpGfuWB3yIME3songXmGzgmY+Ggnfly7TmzE6rHRYIdL5Nm6/cj4W7XVWIfIK52dc8Tif3y8e7fIsFJ4WfyH94O0V7Doxbkwd6zSZsGr7ymXfNZ+z9yviksbXvpe0F+kmr9AidjeTVWp9INOoujzkNJUhf6vCLs8vBXTfhyaLiIVPXGe7CixleWxDSibiW0i9MagAe2K9EWQl7PVTxEIWcz+jF6ciPdMvSwCLxYr7aCiw4RFyfkFyOkIaIcyZFwsSDyGqcTIeAIjQXzmUNe5rDsP+yqe8bAhZ8+gtiN+B8RzQymBCm3L3ffpDk9h7F9XdMvbEbRDEUaTEwuXTwIJEYwQfO+oi4jfEUiBBuoDJbtx8ODJhiKUBz62ZT3smSbYajw9LPX3yp50MxNHbq6GOZPzhrrmq0R9Lo0xbNPrcl9x1QGS5xANGLRge04R/N1Fo4o2bawosH1GPpgq7IjT185FJaQPYtgzZezafPjy+lYZtnRczBpv7W1pMRQGsDu
 0jnympRa
 dqhlqoAikK5a670Ek0JFC+Abv3qBiqMKK9k+t5fdhIFPGYp0gWvnmXfHxd2Sdck2tEDaAKjIEOTcOMrVA3d+1LFwU85PlJz/zPWLXBTvUzV6qmO6z2sx65MnIvqN6LZG/dexT+ryg6iO8r/cjH2idfwgGhd82Kq5noozvQJlTP8qg50LOICJKbS4RAob3gz9RQuHWhxWYqBs2Dprmx6PL+z8U4N5OhA6fAhTKrjtOH/EIe8PDj6dFnZiWoHuzwT+WWZCs0YlE/1ns8xHBpICmTXiSw31WQFHUhzPs9rWcH93NIgp/FefoZSANU/kVoacJCXwxPtB1ATO+Cx8g705wF6/hSk0xf1hvAuRqtLbxcDYwgyZ2yVaNqMnNu/Oaa26a3Tb9cDuKk5oqrGkJOII3bu/fvE+p/Y6DKwE4t+QAjI9iYAZVv+SqYdLnNZhBATmRtkO2Kl+3tXlo37hiLCbKkS/cwj0qvXsJvHc9nhseN5JYZOyWGj6Ctlatbzmh5eYSQjWOfL2O0aUKLknE0m83L0+DxKJSBP8t9DGy9hP5XMMTEqDFoGCQao5sIjPKFQu1uZuVv5jGhzbPeKuYSKtk7QdROumjXNooiHHXPRdGttlgmULDV8uZPcJiCCaDNlwAqz4tIhr3yRYlg4OtK1b68CQySw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Precede struct luo_file_set_ser with struct kho_ser_hdr via
DECLARE_KHO_SER so future file-set metadata features can append fields
to struct luo_file_set_ser without breaking compatibility between
adjacent kernels.

Reserve space for both the session feature header and the file-set
feature header in each session block-set entry, initialize the file-set
feature header in luo_file_freeze(), and validate incoming required
features in luo_file_deserialize() before accessing payload fields.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h      | 15 ++++++++-------
 kernel/liveupdate/luo_file.c     | 32 ++++++++++++++++++++++----------
 kernel/liveupdate/luo_internal.h |  7 ++++---
 kernel/liveupdate/luo_session.c  | 14 +++++++-------
 4 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 425c52c494f1..bd19211c64e1 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -112,21 +112,21 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
  * @count:   The total number of files that were part of this session during
  *           serialization. Used for iteration and validation during
  *           restoration.
+ *
+ * Preceded by &struct kho_ser_hdr.
  */
 struct luo_file_set_ser {
 	u64 files;
 	u64 count;
 };
 
-static_assert(sizeof(struct luo_file_set_ser) == 16);
-static_assert(!IS_ENABLED(CONFIG_64BIT) ||
-	      __alignof__(struct luo_file_set_ser) == 8);
+DECLARE_KHO_SER(luo_file_set_ser, 16, 0, 0);
 
 /**
  * struct luo_session_ser - Represents the serialized metadata for a LUO session.
- * @name:         The unique name of the session, provided by the userspace at
- *                the time of session creation.
- * @file_set_ser: Serialized pointer to the files belonging to this session.
+ * @name:          The unique name of the session, provided by the userspace at
+ *                 the time of session creation.
+ * @file_set_fhdr: Serialized pointer to the files belonging to this session.
  *
  * This structure is used to package session-specific metadata for transfer
  * between kernels via Kexec Handover. An array of these structures (one per
@@ -137,7 +137,8 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
  */
 struct luo_session_ser {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
-	DECLARE_KHOSER_PTR(file_set_ser, struct luo_file_set_ser *);
+	DECLARE_KHOSER_PTR(file_set_fhdr,
+			   DECLARE_KHO_SER_HDR(luo_file_set_ser, *));
 };
 
 DECLARE_KHO_SER(luo_session_ser, 72, 0, 0);
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a39992da504f..02d09a80d785 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -440,8 +440,8 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 
 /**
  * luo_file_freeze - Freezes all preserved files and serializes their metadata.
- * @file_set:     The file_set whose files are to be frozen.
- * @file_set_ser: Where to put the serialized file_set.
+ * @file_set:      The file_set whose files are to be frozen.
+ * @file_set_fhdr: Where to put the serialized file_set.
  *
  * This function is called from the reboot() syscall path, just before the
  * kernel transitions to the new image via kexec. Its purpose is to perform the
@@ -472,12 +472,14 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
  * Return: 0 on success, or a negative errno on failure.
  */
 int luo_file_freeze(struct luo_file_set *file_set,
-		    struct luo_file_set_ser *file_set_ser)
+		    DECLARE_KHO_SER_HDR(luo_file_set_ser, *file_set_fhdr))
 {
+	struct luo_file_set_ser *file_set_ser;
 	struct luo_file *luo_file;
 	struct kho_block_set_it it;
 	int err;
 
+	kho_ser_init(file_set_fhdr, luo_file_set_ser);
 	if (!file_set->count)
 		return 0;
 
@@ -506,6 +508,7 @@ int luo_file_freeze(struct luo_file_set *file_set,
 		file_ser->token = luo_file->token;
 	}
 
+	file_set_ser = kho_ser_payload(file_set_fhdr, luo_file_set_ser);
 	file_set_ser->count = file_set->count;
 	file_set_ser->files = kho_block_set_head_pa(&file_set->block_set);
 
@@ -519,8 +522,8 @@ int luo_file_freeze(struct luo_file_set *file_set,
 
 /**
  * luo_file_unfreeze - Unfreezes all files in a file_set and clear serialization
- * @file_set:     The file_set whose files are to be unfrozen.
- * @file_set_ser: Serialized file_set.
+ * @file_set:      The file_set whose files are to be unfrozen.
+ * @file_set_fhdr: Serialized file_set.
  *
  * This function rolls back the state of all files in a file_set after the
  * freeze phase has begun but must be aborted. It is the counterpart to
@@ -534,13 +537,13 @@ int luo_file_freeze(struct luo_file_set *file_set,
  *          the reboot() syscall, after luo_file_freeze() has been called.
  */
 void luo_file_unfreeze(struct luo_file_set *file_set,
-		       struct luo_file_set_ser *file_set_ser)
+		       DECLARE_KHO_SER_HDR(luo_file_set_ser, *file_set_fhdr))
 {
 	if (!file_set->count)
 		return;
 
 	__luo_file_unfreeze(file_set, NULL);
-	memset(file_set_ser, 0, sizeof(*file_set_ser));
+	memset(file_set_fhdr, 0, kho_ser_size(luo_file_set_ser));
 }
 
 /**
@@ -780,8 +783,8 @@ static int luo_file_deserialize_one(struct luo_file_set *file_set,
 
 /**
  * luo_file_deserialize - Reconstructs the list of preserved files in the new kernel.
- * @file_set:     The incoming file_set to fill with deserialized data.
- * @file_set_ser: Serialized KHO file_set data from the previous kernel.
+ * @file_set:      The incoming file_set to fill with deserialized data.
+ * @file_set_fhdr: Serialized KHO file_set data from the previous kernel.
  *
  * This function is called during the early boot process of the new kernel. It
  * takes the raw, contiguous memory block of 'struct luo_file_ser' entries,
@@ -804,12 +807,21 @@ static int luo_file_deserialize_one(struct luo_file_set *file_set,
  * Context: Called from session deserialization.
  */
 int luo_file_deserialize(struct luo_file_set *file_set,
-			 struct luo_file_set_ser *file_set_ser)
+			 DECLARE_KHO_SER_HDR(luo_file_set_ser, *file_set_fhdr))
 {
+	struct luo_file_set_ser *file_set_ser;
 	struct luo_file_ser *file_ser;
 	struct kho_block_set_it it;
 	int err;
 
+	if (!file_set_fhdr)
+		return -EINVAL;
+
+	err = kho_ser_validate(file_set_fhdr, luo_file_set_ser);
+	if (err)
+		return err;
+
+	file_set_ser = kho_ser_payload(file_set_fhdr, luo_file_set_ser);
 	if (!file_set_ser->files) {
 		WARN_ON(file_set_ser->count);
 		return 0;
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dac6644bfb18..e22a8cf39d91 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -8,6 +8,7 @@
 #ifndef _LINUX_LUO_INTERNAL_H
 #define _LINUX_LUO_INTERNAL_H
 
+#include <linux/kho/abi/luo.h>
 #include <linux/liveupdate.h>
 #include <linux/uaccess.h>
 #include <linux/kho_block.h>
@@ -104,14 +105,14 @@ int luo_session_deserialize(void);
 int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
 int luo_file_freeze(struct luo_file_set *file_set,
-		    struct luo_file_set_ser *file_set_ser);
+		    DECLARE_KHO_SER_HDR(luo_file_set_ser, *file_set_fhdr));
 void luo_file_unfreeze(struct luo_file_set *file_set,
-		       struct luo_file_set_ser *file_set_ser);
+		       DECLARE_KHO_SER_HDR(luo_file_set_ser, *file_set_fhdr));
 int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		      struct file **filep);
 int luo_file_finish(struct luo_file_set *file_set);
 int luo_file_deserialize(struct luo_file_set *file_set,
-			 struct luo_file_set_ser *file_set_ser);
+			 DECLARE_KHO_SER_HDR(luo_file_set_ser, *file_set_fhdr));
 void luo_file_set_init(struct luo_file_set *file_set);
 void luo_file_set_destroy(struct luo_file_set *file_set);
 
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 641bd67ce76e..6513fde3ecfe 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -132,7 +132,7 @@ struct luo_session_global {
 };
 
 #define LUO_SESSION_SER_SIZE (kho_ser_size(luo_session_ser) + \
-			      sizeof(struct luo_file_set_ser))
+			      kho_ser_size(luo_file_set_ser))
 
 static struct luo_session_global luo_session_global = {
 	.incoming = {
@@ -227,7 +227,7 @@ static void luo_session_unfreeze_one(struct luo_session *session,
 {
 	guard(mutex)(&session->mutex);
 	luo_file_unfreeze(&session->file_set,
-			  KHOSER_LOAD_PTR(ser->file_set_ser));
+			  KHOSER_LOAD_PTR(ser->file_set_fhdr));
 }
 
 static int luo_session_freeze_one(struct luo_session *session,
@@ -235,7 +235,7 @@ static int luo_session_freeze_one(struct luo_session *session,
 {
 	guard(mutex)(&session->mutex);
 	return luo_file_freeze(&session->file_set,
-			       KHOSER_LOAD_PTR(ser->file_set_ser));
+			       KHOSER_LOAD_PTR(ser->file_set_fhdr));
 }
 
 static int luo_session_release(struct inode *inodep, struct file *filep)
@@ -560,14 +560,14 @@ int __init luo_session_setup_incoming(u64 sessions_pa)
 static struct luo_session_ser *
 luo_session_ser_init(DECLARE_KHO_SER_HDR(luo_session_ser, *fhdr))
 {
-	struct luo_file_set_ser *file_set_ser;
+	DECLARE_KHO_SER_HDR(luo_file_set_ser, *file_set_fhdr);
 	struct luo_session_ser *ser;
 
 	kho_ser_init(fhdr, luo_session_ser);
-	file_set_ser = (void *)fhdr + kho_ser_size(luo_session_ser);
+	file_set_fhdr = (void *)fhdr + kho_ser_size(luo_session_ser);
 
 	ser = kho_ser_payload(fhdr, luo_session_ser);
-	KHOSER_STORE_PTR(ser->file_set_ser, file_set_ser);
+	KHOSER_STORE_PTR(ser->file_set_fhdr, file_set_fhdr);
 
 	return ser;
 }
@@ -601,7 +601,7 @@ static int luo_session_deserialize_one(struct luo_session_header *sh,
 
 	scoped_guard(mutex, &session->mutex) {
 		err = luo_file_deserialize(&session->file_set,
-					   KHOSER_LOAD_PTR(ser->file_set_ser));
+					   KHOSER_LOAD_PTR(ser->file_set_fhdr));
 	}
 	if (err) {
 		pr_warn("Failed to deserialize files for session [%s] %pe\n",
-- 
2.56.0.506.g506a7eabc5-goog


