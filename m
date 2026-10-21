Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F2260A4AC6
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Kd04tNJg
Received: by kanga.kvack.org (Postfix)
	id 33D576B0722; Wed, 21 Oct 2026 11:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F916B0725; Wed, 21 Oct 2026 11:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115756B0726; Wed, 21 Oct 2026 11:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAC8B6B0722
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:25:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D10C2A813E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:25:34 +0000 (UTC)
X-FDA: 85347007788.18.289B8FF
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf12.hostedemail.com (Postfix) with ESMTP id 221FE4000B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:25:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kd04tNJg;
	spf=pass (imf12.hostedemail.com: domain of 3a9nYagkKCN4TARUNSAHUGOOGLE.COMLINUX-MMKVACK.ORG@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3a9nYagkKCN4TARUNSAHUGOOGLE.COMLINUX-MMKVACK.ORG@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792596333;
	b=hMYAFFT2QiiGr6RA9/91ofaJqxz2m0+LbmqThGwGVboBuLmqaIQs20+noD8u6Zl205vhz9
	3nOKIqX1POOQl33P0hSmccVFIqFNLXeSAHb0J9r8UZ3+pd0L7+LJ/REOKaumZ39MYZASH5
	tsoPY/MsbpftCS+lRlGNUJbCXcpwIMg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kd04tNJg;
	spf=pass (imf12.hostedemail.com: domain of 3a9nYagkKCN4TARUNSAHUGOOGLE.COMLINUX-MMKVACK.ORG@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3a9nYagkKCN4TARUNSAHUGOOGLE.COMLINUX-MMKVACK.ORG@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792596333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eF6EuxU5y/OwYzc2Wn37QAO5vY1XkAXoeRxwHLACs2w=;
	b=w2IxDXg377Fl4aqMepg5kONOiLlcFRxsk4gbrNyjxlhXVzGd9lvGdG3HkfwFQ6/CCxlPPk
	FtUI81wru0F+Luj6argaW5urAs1Uo4OMHC8vWE0us9M4NR0o4xMe/xt7AM8p/hwO6Uyi9P
	YxhPangP4keHBqOlsQJjs8GfM2u3BvU=
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2dd399f761so78614766b.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792596332; x=1793201132; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eF6EuxU5y/OwYzc2Wn37QAO5vY1XkAXoeRxwHLACs2w=;
        b=Kd04tNJgy5Nl6wWPCFLQ3nWtWA8EFo8uht7aBTmdPvqO1/lkhQIYSJYQeAagXFL8/N
         CzFi4193PJv/RhGqhNLbeAEvRTQvFL2vmhsGzNyy6dYk23Zm9H+ad1Csy4z5oL3zPjwn
         FJi3lc4TXzxKOTyynlSsxWAE6SiuK0dUuuHHKuDPFncB6EsY0E739/+WDL7L1ckQTDSL
         Gz6WoWGlLkAqfA6RgNRZCb9mTDU03ogqR/Jevx7dApoFrXAMLsj3PM5I3D6heSn0PXmE
         p4RlMYfKJtGgVCOV0BRNiunfdLEwObU97OfQIPPfiZrmRdHtE0Eb/DzvPzQfkTkQYigV
         Vguw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792596332; x=1793201132;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eF6EuxU5y/OwYzc2Wn37QAO5vY1XkAXoeRxwHLACs2w=;
        b=AbirO8X5sWrd/rhZhCKWKjRSlj0HMS+GMC5SIq7+aKoS3H1yK2hNzLoP8WL6B1NXo1
         lFIk9hDse8HcGlq0XorrKt/HSY8CkdXClgtytgoFDWF8OpnYpt0XlI54COdJ1LCRJwK8
         2epsR8wR1DjTG0QPEGaRbr5eZmnx2ZJMy5J4onZAS6fX5bhqz/vf8urX9TRGW8WHrAB3
         fTiqlOL6SApVouDV/FYIoU5Oa34CZmvM26tVm7u8gF0auVZ7rO3qU4DPeK5A17Hq+NH1
         zO3Bvugpt9csc/jtiCoeYyQv5kVtBMX4OPKF2aBoBi7QMadDuKdGA1F65w9GsUYNtHKN
         fIkg==
X-Forwarded-Encrypted: i=1; AKwUvBxyo4qOwFwlZ5eevPbIrX9JAMfJAcn5PvTXLFwumUbH1QfiAlGI3jARhKnSQNBwROchZmfRO0zWMg==@kvack.org
X-Gm-Message-State: AFq9FYJBu7PPBf7yxzGdFxn/FtRF4nx0xsiHt79Pb6fOHUNCFs9TzEF/
	Vjj3NGquNc1w1oma/ThwfUEhQlBwIXWtAul7+Ps+HjGgSqQ2LJL7mgum0VoRtWuSHnvBPq6Uk3Z
	nFBvhXbQT1X4AICNJ8Q==
X-Received: from ejbgw26.prod.google.com ([2002:a17:906:f15a:b0:c3f:b33c:8124])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:d40a:b0:c45:d8aa:6ae5 with SMTP id a640c23a62f3a-c46799bdbb7mr204058966b.42.1792596331473;
 Wed, 21 Oct 2026 08:25:31 -0700 (PDT)
Date: Wed, 21 Oct 2026 15:25:25 +0000
In-Reply-To: <20261021152527.375070-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261021152527.375070-3-tarunsahu@google.com>
Subject: [RFC PATCH v2 2/4] liveupdate: Select file handler by name in the
 preserve ioctl
From: Tarun Sahu <tarunsahu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, 
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, 
	will@kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: etn3j5q1h3oqo76gspmz7w495opbihky
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 221FE4000B
X-Rspam-User: 
X-HE-Tag: 1792596332-722437
X-HE-Meta: U2FsdGVkX1/9LzlvaQ39B/DSfYuXiv52IdZTIEjjkG1oBoA3rynE2uggnCKw1rsyn9VC1jNQYLLAnFmgNnZujzLJ4/2zPs/5ws5F5D/R2I/dNDzOfif/g4oIatWP9F3e3OoWGI2gX3aGnm1CrEn7EFTEVwKuWV3cAJDZJhwba8azz18Q9zP8Lo3f+URC6FC3FgYcftk2t+2j0oc5jRTLlg95tR1ilnxiDgs944IWFApRSxoXk6KGauXw5pf7qebCSNeyTeH223ecandKayvM/8h8suia+jGuSfCfnr0GvtV7jFsyoYD0ce6WNTBl8fY5b2881oEgRNIY5vMNVVpsIK9aOpsKpnrfEXSuAGaisiKyuSW6Gs5xoeNIAHlhSfR/rPs1xxbr0R83NYNDpRsJ6VhMWcwBE8lBS0PUPicnXDIvZ/ms4SVDvChmERsaZRHijKD4z0n+nXbZkUpzHZ3Zip5hSCe/DOd4la0n1AQTMZcxMoj1ClsPSehMTP4mv/bgFjxJzuj7SbeN5xItbdneV1P/32xK1v/QIohXyWbYkfQ40wGRyRSA2YfROy7sZuSaKflT8vGs6/wojc3fiixYgFBZYTxlLDDw1RU4qgkkCfH8/ObPM0XodE1niHNRd3l5MSYdlpiB/vWTovqPY4oGdpBMCp1Sd33y2wOZ+Mh0iawqpXLcpxbvEDgzjGNOzVtBtltDIXTo6iJZAuxRlBP1qAQAwNi/OuflCopJs5K2Abb7F69erPwoEwMCC9KyyDFMlRf4hoerqNuKPH76/27RcCs+YX26w5DXQGZjkREn/Ur8LmMLPRUIRshdqwMogRlLVIFzVxtMZQuoEKJUO/zw3rCoG0H8dDHruOaw6afKV7hHUgsaZsTucIcC8TVnua71zHClzPn66pz63rk0Khj4Z+jRv2nGT1vEzIuabUro4lkVeTr7Z1flz/VV25SLofIg2yU2sdiSrB3GEKdVYVg
 EdN1at3a
 mOJ8mvqegydYRJRFkKCmL59/kS7P2VZZH4q2wFHIJy775A1O7gHHX8iHZwhBYkZ/BHgMCbI6L4Kx94PLtFVrEg8lkqjUkl3MHlhZvAA0iS0OejX6z/NsT3NQI3UsZcpV7K1EtkX5Qy2rpfgVggJEmxHMPAustqVNeua/JGPzgv18V2ZMSxbWTmEva8vLAbkRKtztOAPI669ZrBWfn8kgF8buwr8hWOg7xWWUrKmJz0WT2tZEQkflvkY5xdTgVKRMAGE6zXDmAovUy/CQsU+yuF/8xv6FVs2XoHggnGeo10nE8q06wYjbeUaB/iCXt945krk6yHLwZYMat2HWbwwFR3Yj5MOKDEAB1rpCcrPRrAwYa0SELcketXi2mYEQxpuOYx14Ps+yexAxPs5S0RSfS3SwTxK8hrRJWgVzxXXb2FIjXbJ+E4g4vw8BO9gxjYYlqstNhltQYbinmOwDLt8fHAXCzPbdcSFIABQZ1+WAXXECofVZFNa+Nsl0RaYA24Xa/iK7v7v/93c7xhrH62KpY0IZ5oja3oBDpVvv7s1c/Zf2z3zYAkCikXMhnfhQN4GrFTmYho1jznxbP0P7vExJ7uQbYRO1PnOu4zjcu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently luo_preserve_file() iterates over luo_file_handler_list and
picks the first registered handler whose .can_preserve() callback
returns true. When a subsystem introduces a new, backwards-incompatible
file handler alongside an existing one for the same file type, userspace
has no way to choose which handler preserves a file descriptor, nor can
the kernel keep the existing rollback-safe handler as the default while
allowing callers to opt into the new handler.

Append char handler[LIVEUPDATE_HNDL_NAME_LENGTH] to struct
liveupdate_session_preserve_fd immediately after token, keeping
IOCTL_OP min_size at offsetofend(..., token) so callers passing the
original 16-byte structure continue to work:
- When handler is empty (all-zero, or zero-filled when userspace
  passes the 16-byte structure), luo_preserve_file() selects the first
  registered handler whose .can_preserve() callback accepts the fd.
- When handler is non-empty, it must be null-terminated within
  LIVEUPDATE_HNDL_NAME_LENGTH bytes (returning -EINVAL otherwise);
  luo_preserve_file() looks up the registered handler with that exact
  name (returning -ENOENT if unknown) and verifies that its
  .can_preserve() callback accepts the fd (returning -EINVAL if not).

The retrieve ioctl is unchanged because the handler is identified by the
name stored in the serialized payload from the source kernel.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/uapi/linux/liveupdate.h  | 12 +++++++++---
 kernel/liveupdate/luo_file.c     | 21 ++++++++++++++++++---
 kernel/liveupdate/luo_internal.h |  3 ++-
 kernel/liveupdate/luo_session.c  |  7 ++++++-
 4 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 509c6236720d..2413b19dabc1 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -126,9 +126,14 @@ struct liveupdate_ioctl_retrieve_session {
 
 /**
  * struct liveupdate_session_preserve_fd - ioctl(LIVEUPDATE_SESSION_PRESERVE_FD)
- * @size:  Input; sizeof(struct liveupdate_session_preserve_fd)
- * @fd:    Input; The user-space file descriptor to be preserved.
- * @token: Input; An opaque, unique token for preserved resource.
+ * @size:    Input; sizeof(struct liveupdate_session_preserve_fd)
+ * @fd:      Input; The user-space file descriptor to be preserved.
+ * @token:   Input; An opaque, unique token for preserved resource.
+ * @handler: Input; Optional null-terminated file handler name (max length
+ *           %LIVEUPDATE_HNDL_NAME_LENGTH including null terminator) selecting
+ *           which registered handler preserves @fd. If empty (all-zero, or
+ *           omitted when passing the 16-byte structure), the kernel selects
+ *           the first registered handler whose .can_preserve() accepts @fd.
  *
  * Holds parameters for preserving a file descriptor.
  *
@@ -152,6 +157,7 @@ struct liveupdate_session_preserve_fd {
 	__u32		size;
 	__s32		fd;
 	__aligned_u64	token;
+	char		handler[LIVEUPDATE_HNDL_NAME_LENGTH];
 };
 
 #define LIVEUPDATE_SESSION_PRESERVE_FD					\
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index fb81239bedf3..be20e0f1e0aa 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -207,6 +207,8 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
  * @file_set: The file_set to which the preserved file will be added.
  * @token:    A unique, user-provided identifier for the file.
  * @fd:       The file descriptor to be preserved.
+ * @handler:  Optional NUL-terminated handler name. If NULL or empty, the first
+ *            registered handler whose .can_preserve() accepts @fd is selected.
  *
  * This function orchestrates the first phase of preserving a file. Upon entry,
  * it takes a reference to the 'struct file' via fget(), effectively making LUO
@@ -238,11 +240,13 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
  *         -EBUSY if the file descriptor is already preserved by another session.
  *         -EBADF if the file descriptor is invalid.
  *         -ENOSPC if the file_set is full.
- *         -ENOENT if no compatible handler is found for the file type.
+ *         -ENOENT if no matching handler is registered or accepts @fd.
+ *         -EINVAL if the named handler cannot preserve @fd.
  *         -ENOMEM on memory allocation failure.
  *         Other erros might be returned by .preserve().
  */
-int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
+int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
+		      const char *handler)
 {
 	struct liveupdate_file_op_args args = {0};
 	struct liveupdate_file_handler *fh;
@@ -266,6 +270,18 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	err = -ENOENT;
 	down_read(&luo_register_rwlock);
 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
+		if (handler && handler[0]) {
+			if (strcmp(fh->name, handler))
+				continue;
+			if (!fh->ops->can_preserve(fh, file)) {
+				err = -EINVAL;
+				break;
+			}
+			if (try_module_get(fh->ops->owner))
+				err = 0;
+			break;
+		}
+
 		if (fh->ops->can_preserve(fh, file)) {
 			if (try_module_get(fh->ops->owner))
 				err = 0;
@@ -274,7 +290,6 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	}
 	up_read(&luo_register_rwlock);
 
-	/* err is still -ENOENT if no handler was found */
 	if (err)
 		goto err_fput;
 
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dac6644bfb18..911ffedec9f3 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -101,7 +101,8 @@ int __init luo_session_setup_incoming(u64 sessions_pa);
 int luo_session_serialize(void);
 int luo_session_deserialize(void);
 
-int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
+int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
+		      const char *handler);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
 int luo_file_freeze(struct luo_file_set *file_set,
 		    struct luo_file_set_ser *file_set_ser);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index f48e9a4185f9..194ef45907c1 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -266,8 +266,13 @@ static int luo_session_preserve_fd(struct luo_session *session,
 	struct liveupdate_session_preserve_fd *argp = ucmd->cmd;
 	int err;
 
+	if (strnlen(argp->handler, sizeof(argp->handler)) ==
+	    sizeof(argp->handler))
+		return -EINVAL;
+
 	guard(mutex)(&session->mutex);
-	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
+	err = luo_preserve_file(&session->file_set, argp->token, argp->fd,
+				argp->handler);
 	if (err)
 		return err;
 
-- 
2.56.0.212.g129ede20d9-goog


