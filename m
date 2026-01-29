Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34330D73E84
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 17:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6396B008C; Thu, 29 Jan 2026 12:35:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B88E6B0092; Thu, 29 Jan 2026 12:35:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9D066B0093; Thu, 29 Jan 2026 12:35:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD0846B008C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:35:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73A02B73C3
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:35:20 +0000 (UTC)
X-FDA: 84385702800.24.0DB2ED4
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 71E641C0011
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:35:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=snai.pe header.s=snai.pe header.b=LxNJm8iJ;
	spf=pass (imf18.hostedemail.com: domain of me@snai.pe designates 209.85.221.54 as permitted sender) smtp.mailfrom=me@snai.pe;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769708118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Phc9qAk4f5Y7siOZluWOGyZS8E5U/JFAMjIiUncQyU=;
	b=5tfXtFycY9zzKM4uTQlHgJJ3vKr3CFugMINFZh2g6JYHUfYgPQ0eWq+uO6m1IudxuxHUnZ
	w/6bCa/4iS0mzdkB5Y2h94R33Rxfv/yEnOqhR+YAHV4XK2dSSfm6vNsBfgzI0mkQI5msf5
	qHJCvK41qlIPh0ueCo5Oh7wC2ak4/zU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=snai.pe header.s=snai.pe header.b=LxNJm8iJ;
	spf=pass (imf18.hostedemail.com: domain of me@snai.pe designates 209.85.221.54 as permitted sender) smtp.mailfrom=me@snai.pe;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769708118; a=rsa-sha256;
	cv=none;
	b=e/4jY5E+3Kh2rx3Z9h25wN79BVVoKuqKZGArOshlvdVKOSUBf6mPuyig7mnjUy6X2p347D
	1Uh7/ivU9r13zImOHQB23CVo9HsDW04Mp39hpLP/mUoz1w5CKvCLK4ImMXyw3FcIlDVVTy
	H4Q/tfjcgo30gvb5JszgaEivpas04V4=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42fb2314eb0so1118162f8f.2
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snai.pe; s=snai.pe; t=1769708117; x=1770312917; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Phc9qAk4f5Y7siOZluWOGyZS8E5U/JFAMjIiUncQyU=;
        b=LxNJm8iJHlfJDnMm4Vu+exF0VpaBy+YGyGN/hcTz++1PD4/7FlwJf+hv7dq9FGz5wp
         hkqTxhKff7Oefqx+fJG+NiwEcG+DxFRsQaA7jANTD+caYlp9GUk2JDO6IMkEhuCVjX+3
         DDYGp7DVTaKF72olOjZBd8YfIx0n1QncIot4p1Ucy2W/NUdqj9HnDj6eEm/Xl3wNg+Pj
         FYq8ALuLdtnFJ38hxRBqCKVsLh+4VcOHb+b6ajWeJo6UX7YzeNXsZ+DeY82q+X+aANdO
         acpfyNkfnepDjHCnKjaiktCWVFLAWCQ+aUvIlNdfclleMCJ05q2pTrtvc2FUywfZvMQi
         FAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769708117; x=1770312917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9Phc9qAk4f5Y7siOZluWOGyZS8E5U/JFAMjIiUncQyU=;
        b=djfq8EKPdiw/ojzP5hE+cWFkK5xI7bm9VlU8Hcy3fWf5fwWoM2YEFP/Q5kLB31JNt7
         u4pJZ2dpSuC1nS9uXnHGvOAoPDaTZThoRJbQh36A9T5Me1BxCP6jaINI4B8A8ZYlCVa5
         QQBhakWNYfR+9ntlp/sjyGRfHjfoGiXgyYq6m0J7kjzn2/0YMJcY5XHDzO0ABcJDMv+S
         7zA4pZZXagK7ouKqOV+Xvw1KH54o+QSNdrgnwcG3bn0yZfMQmRG1h+evk32ZvZTxeiZQ
         ywCWrnvBiPZSi2x5Y2+ps9kVdASEerpLu1StDxw6zREybgKAi8736LcFTKLMpXz8AZvR
         aP7Q==
X-Gm-Message-State: AOJu0Yz29yetPX2tOYyqmkHdA0fA5h60peRHIvoyHGViyGdMwJ652wa6
	252/2KtL6rCrpfL1WaSZ61JtaZrLkEBHzjv/nXuJ8tm35h/CSpvEOwiNwOA3mG6VY2OYe8Nl35U
	8j21U47o=
X-Gm-Gg: AZuq6aLwi66m+qP6OKSzD0MTI4dCCzZA4dzK12DX3VEx1EBZsRAsV7jSYb9ssgbYMt0
	xrj6Mdld/oDtR6Gj+/BDlPZYUXv3JSk1932D5CrRJIPn7CHnT+OzMkfEdW13ze6EoXSNpslktnS
	7iD2IyFB4lDmz+KEoCemhvGqTu8DHyzhgjFZNjjhP5i8ZcQ1DSfQaP/54s6rgL7Iv8XNsiTRCMJ
	iW/qKs1sD197PLqy6dR9KwBIh2Hy7qLcAuHlDtM2E0F4nXD1O/GcFR0va9GMeBFgdKdrEJlx6sb
	H1G9snwUaqnVBBwOjtZa+kxGvtMOAfh59xxFnXIDyU5WQAwFBYS5Ziba+T9mxg0JFQ2SpNRZakH
	z2yQwm62FGABkih+s0hT+pyVgnUYVXxMf0BVZ17TAnw5aWu8PzlHSF+s8aTymJld1P9OM/AJn51
	KxPwkwBc5qtn/B8pMhSJM3F9eERuPRhyQI7M8GQaJAmHzYnStqilRjoKSHMoXu8m2NJ9Y6ftXwn
	dRU6QRS6X5MVQ==
X-Received: by 2002:a05:6000:4007:b0:435:a2f8:1515 with SMTP id ffacd0b85a97d-435f3a62efamr583681f8f.10.1769708116859;
        Thu, 29 Jan 2026 09:35:16 -0800 (PST)
Received: from snaipe-arista.aristanetworks.com ([81.255.216.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e131cf16sm16904163f8f.22.2026.01.29.09.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 09:35:16 -0800 (PST)
From: Snaipe <me@snai.pe>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: [RFC PATCH 1/1] fs,ns: allow copying of shm_mnt mount trees
Date: Thu, 29 Jan 2026 18:35:15 +0100
Message-ID: <20260129173515.1649305-2-me@snai.pe>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129173515.1649305-1-me@snai.pe>
References: <20260129173515.1649305-1-me@snai.pe>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 71E641C0011
X-Stat-Signature: ieemo3onndsigpig4irfhzpuqxaychcb
X-Rspam-User: 
X-HE-Tag: 1769708118-91137
X-HE-Meta: U2FsdGVkX180Y/qmmUXwJ5xtOl/bS4nTtsB6uVbratuYe8oxSlDnxPYjy+aHIC6yaMy8BMAHXPxOWPH9ldl7cvBJmGlDk5AUhDPQDkC0SWCTNdKd0xASZkRTh+pOFCwxUjc/e5Nn0z6icT9GJsuaAqEbbxW/rlLDfj0aTsdwS6ph1qPH8ixfiCY9PDhOIeqQHJbBtAqb6LclkM4erRF8NmawVqykwscMQZaVlTi4lvKn8+8YAB7Cc59MfASIPInAVRMtHtV8vODNP5ySFaMT0TqWK6K+UXDt9p0iUAa/3RRoA7MmxS1u785jmH744LuWvpLykDWOiGJSV0hp+pXx2R7TwitSU/w7JqLYp+j5doCic+qBAevwj9DWXBl2ouCjpJ2O+E1STI0FMz9BFF9FZlHoEgn+G1VbWvcv4VsmbLc9I380rAvIsROEkB2Kq2ZUQcJVwZ0RHmt0j/QmT6YWGkE8ex36sI7DUkYLKyE/l5AnwsKnR9kpeU/xToQM9YOm1017NxlNaJAL3CkAVPl0RV+KM8+gsAxIbvkL7E1zKUB3iB44nq8Fi8NgLWJ44MuZHPIduFWDKqsHE05SkJTnVqh06YG7LVn8F0x4WEvS3/IHWqrndAd21XzJeieQbkoaR7QLfHx5Et5wwPLhx4BLvYpEbyfgfo8V4gC6KAXEWa5BF9uB1xTelbyFEThZGIpbmb6s+7otTlfdhhVnBqrB04hwoeEEDflh0NDXPDUDI76amcSKO/SJWjcbUPT9Q3HK0tlwFW3+yd48QgZCFjofE6VfMadl7JsT6Z/chLYcZK3auuBGT/bzcIfTDbwt1CIZypMm7qihlhjET4AtpxFcq4E9Ex3ED0q3blCBtTNssO0i9y9aTzY/e47PBwUFY1SHe3acARXkdH7Mj/GRs+WXFNEIoKhb8Z1wDrWgGzAY0/5qCtEebI0gx7vHmwDj0i8dHd24cNulWjvvhUhhs6H
 qcK/Cm95
 j94Por3q4j5IUHadFT97R4b/D6AL5qVGA/tZkEyQ2ZazhNq5nTPKi22K5Oc8xIDpfQeJGOj2Gt4VThK95luUNnVIETN9qv//64Qc9HSPVHtMELFqyX/Az1gR3GbSpvizyRmaYCmM0lS1OE8ePPbFzYThP4wAdmrUbvM2oXYkrbQBGJY/TuHhUA8ypZddcJBQBsMTswL4DAd291ejS/flYGBSfBnqxCVA6U3R/e1gwH8OW/RC4/1FVyFdsgFg1sCCujcMLYNixxAAOlieBu9SwsySaIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Franklin \"Snaipe\" Mathieu" <me@snai.pe>

The main motivation for this change is to be able to bind-mount memfd file
descriptors. Prior to this change, it was not easy for a process to
create a private in-memory handle that could then be bind-mounted.

A process had to have access to a tmpfs, create a file in it, call
open_tree on the resulting file descriptor, close the original file
descriptor, unlink the file, and then check that no other process raced
the process to open the new file. Doable, but not great for mounting
sensitive content like secrets.

With this change, it is now possible for a process to prepare a memfd,
and call open_tree on it:

    int tmpfd = memfd_create("secret", 0);
    fchmod(tmpfd, 0600);
    write(tmpfd, "SecretKey", 9);

    int treefd = open_tree(tmpfd, "", OPEN_TREE_CLONE|AT_EMPTY_PATH|AT_RECURSIVE);
    move_mount(treefd, "", -1, "/secret.txt", MOVE_MOUNT_F_EMPTY_PATH);

Signed-off-by: Franklin "Snaipe" Mathieu <me@snai.pe>
---
 fs/namespace.c | 8 ++++++++
 mm/internal.h  | 2 ++
 mm/shmem.c     | 2 +-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index d82910f33dc4..f51ad2013662 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -38,6 +38,9 @@
 #include "pnode.h"
 #include "internal.h"
 
+/* For checking memfd bind-mounts via shm_mnt */
+#include "../mm/internal.h"
+
 /* Maximum number of mounts in a mount namespace */
 static unsigned int sysctl_mount_max __read_mostly = 100000;
 
@@ -2901,6 +2904,8 @@ static int do_change_type(const struct path *path, int ms_flags)
  * (3) The caller tries to copy a pidfs mount referring to a pidfd.
  * (4) The caller is trying to copy a mount tree that belongs to an
  *     anonymous mount namespace.
+ * (5) The caller is trying to copy a mount tree belonging to shm_mnt
+ *     (e.g. bind-mounting a file descriptor obtained from memfd_create)
  *
  *     For that to be safe, this helper enforces that the origin mount
  *     namespace the anonymous mount namespace was created from is the
@@ -2943,6 +2948,9 @@ static inline bool may_copy_tree(const struct path *path)
 	if (d_op == &pidfs_dentry_operations)
 		return true;
 
+	if (path->mnt == shm_mnt)
+		return true;
+
 	if (!is_mounted(path->mnt))
 		return false;
 
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..aa45c5576b16 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -24,6 +24,8 @@
 
 struct folio_batch;
 
+extern struct vfsmount *shm_mnt __ro_after_init;
+
 /*
  * Maintains state across a page table move. The operation assumes both source
  * and destination VMAs already exist and are specified by the user.
diff --git a/mm/shmem.c b/mm/shmem.c
index b9081b817d28..449d6bc813ae 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -43,7 +43,7 @@
 #include <linux/unicode.h>
 #include "swap.h"
 
-static struct vfsmount *shm_mnt __ro_after_init;
+struct vfsmount *shm_mnt __ro_after_init;
 
 #ifdef CONFIG_SHMEM
 /*
-- 
2.52.0


