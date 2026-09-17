Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1850C982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EE856B0096; Thu, 17 Sep 2026 09:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7086B0098; Thu, 17 Sep 2026 09:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B64B6B0099; Thu, 17 Sep 2026 09:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1E66B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:26:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C67E1A036B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:26:44 +0000 (UTC)
X-FDA: 85223329128.11.A637C4D
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7E37A1C0009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:26:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b=moxkC9Vb;
	spf=pass (imf18.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.76 as permitted sender) smtp.mailfrom=sean@starlabs.systems;
	dmarc=pass (policy=none) header.from=starlabs.systems
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789651602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhZfe7j97gcGMqNS+7HeL0ehn+NCntLK64e5hLR53vg=;
	b=f87Ublcks69xT3woEnIiOJ0Yrd1I1PtrD9MK2lrVBOf991YAsZDSVXL5jVHz0LGbFmI11b
	8IE8MHkk7FOMC3POLA5C607FpBVK73yAUbuTHp1iQwtOpDGTYe0BAeHHzoIfJc0Hb9aKfV
	Vs2ExFRpfJuVRFv8c7z98pkjr/GlQ7Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789651602;
	b=tkbmfn/WQcSpe6PIBaMXuLDULiYrs3T4fonwf/Dc5wSd3OtW1A1R4TsFe4lcQIS0kjGsL3
	uH2TDtmsr/NDQD81pKIiQxI/LqwMOAVlcyZpkbR1cUMZAgrKrRxHZkvIBoIC2+5uUIg9tn
	lqlBWOJIB88EqTT5e7zBxx1vScRCtNU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=starlabs-systems.20251104.gappssmtp.com header.s=20251104 header.b=moxkC9Vb;
	spf=pass (imf18.hostedemail.com: domain of sean@starlabs.systems designates 74.125.225.76 as permitted sender) smtp.mailfrom=sean@starlabs.systems;
	dmarc=pass (policy=none) header.from=starlabs.systems
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48434392b02so687264f8f.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starlabs-systems.20251104.gappssmtp.com; s=20251104; t=1789651601; x=1790256401; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GhZfe7j97gcGMqNS+7HeL0ehn+NCntLK64e5hLR53vg=;
        b=moxkC9VbPZu3/Qmi39ctJoI9bkHdjYU6zWYG2C0zv6XyuAp/+GL3oLYpedlMiW/9Ww
         AgyPPJP4RONXZqDRSU33aXymxhnzQHsVXfQ0y/EUwOB/PhmwgPghdH3L8QfPMEebISA4
         m66lcGzZenQgFLsDlSb+SKzgEjtKE55x22TMECdOOKjSP0HxO32b6eVMJwlmlYWeCPXI
         TQCHsrcCo6ESj1TsgtSlXsIMHc3QiuPZmyfx2dUgcJiaytPQkM6CxC8Xz6eqDk/XwE1z
         JOFo+JJcmWhwrL5UdRQ7ZRT8j2Ipemz3l2u4VnSir5uZfZcu4lN1vCCG2Nbs5qIn/ZZU
         ncxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789651601; x=1790256401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GhZfe7j97gcGMqNS+7HeL0ehn+NCntLK64e5hLR53vg=;
        b=rrtoXDAVA6lcaTVcGicSHOXOnoTSsYf7IFu4S21ttIC4WsJYXplVBU9ZBUA8Qk9BOx
         FwNDF2fPuNazEgCt18VQEwXfZKf0+cU8kMV0DrTqknuUayoPxGhrmJSJV8Fs/OO4UdID
         cjHFqSMP5yu9bW+JnIgyhFAT4r0J54MFFHXk8yn8S93gUSgb+nHzleKGtXt8KxQv20l0
         IqzyLWi8bsWYy5UhtYl6PjbZzRXSO2bD7aYhq2xq1O44pno5lWk305O8nWidNiecVFNx
         V8jHaefaHl6X7oKXJth2bVLMeO/9Kn0PI0hEqt/dsdBXwaUJSZWgKYsZ3tutxayvi/h6
         4YxA==
X-Forwarded-Encrypted: i=1; AKwUvByDMqT5INOA87Or/kB2O926KgZGB0Ohx7c+qNtX/EU9oPCl9Np38N3HMuwgvxMcn8hzlpzbVf8/hQ==@kvack.org
X-Gm-Message-State: AFuF++lXVNpsiUWEl3TqsbancxXTPGlhDCawUAaeOsxV4R3C6k/6KuKt
	4CRPa/TEhm5Fg8HomPcbpkUvg5pQK8GYUOM6N8SQdP7zZhUsZdKiJuaznN1QkacBiQ==
X-Gm-Gg: AYBFou1JGukXbHwHGZIhCDiXddHwcXpNNGgWB3z2WQKojXFFk8qy7pFQiZhFKZuQ/C5
	iHTBbizKp385JsO+j2MjleY2DMaxCKNh2WTl7Th96GFgF+r/wK1+/32iI77S94gVBwKxkTv7w36
	F4lwG2uzJAHJniQ+VXjF8eSimztHA/5EH31MHnrrulJ+pZ/lM1ZhG/n4JDFMf6leXv7+h2h6ycy
	IQ1UXX5CDbFwtXGocC6cD9fNX9H9AbSBXME/5evIb4eRkgyRLmc+hPF6CW6yrEj8O4SxtQq72wm
	ibTvNI9msuNJgF2eYoR8Wk3wdaNSYuT5kSJj3Qccs0em2hr/+FChr8gXcmKWmoPVdJPDGe2ulFb
	LCN2o0+8dFomQHjvy/640T0pYvnFCIn5Psy1CaQILbHoIktUNhUXWsnpHeEqRQRCvNfFT+reK+s
	JG+2dmqFLB1hs4v7t0VqNVZDWwlKLJK2THCP/QLEqj1+HISl9gFcnhbhXZlO9zB6/s8BSxlD+qp
	1WOrDECs4Z3dW641bc5ciaezG8=
X-Received: by 2002:a05:6000:2885:b0:487:c3e:8df8 with SMTP id ffacd0b85a97d-4870ceee433mr16279360f8f.5.1789651601109;
        Thu, 17 Sep 2026 06:26:41 -0700 (PDT)
Received: from fighter ([216.128.28.240])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf1f6cfsm15879947f8f.13.2026.09.17.06.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 06:26:40 -0700 (PDT)
From: Sean Rhodes <sean@starlabs.systems>
To: linux-pm@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Sean Rhodes <sean@starlabs.systems>,
	Evan Green <evgreen@chromium.org>,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>
Subject: [PATCH v3 4/4] PM: hibernate: document encrypted snapshot seed ABI
Date: Thu, 17 Sep 2026 14:26:31 +0100
Message-ID: <81c284e9246faa817050f34d46a9fbe558ddba5b.1789651581.git.sean@starlabs.systems>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1789651581.git.sean@starlabs.systems>
References: <cover.1789651581.git.sean@starlabs.systems>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7E37A1C0009
X-Stat-Signature: 988prg4nhm4o9awhancg4orh8f35fhrp
X-Rspam-User: 
X-HE-Tag: 1789651602-96728
X-HE-Meta: U2FsdGVkX19ptIqtYZn9Yo4zfnfXka3dgN83Lf3AYa3KH4Os8M6clratkGC6GcN5zyQUsF5hbjEjyloUNyPynABaJTTLpE3ihDV9sfPaopX15bAKvjlJuYNLpgA4CHTiNFp5/lkWl9MdVq8ZMuY0nuPEJERp4JEat74qCXa3QKf3WImu+uh2czaS7Sle1zfJbOW8vVkT3ScuyOGSiyf5xuOZPEuUTDYNupnBje/hO0eLOnibVwUG9sZOjtOeTa7dhLl+z4NLL9nqhrLfT3s6jQuyH7cBFLUNx8oma9GWfXC85Xu7lECsO9BUFIyEnu2EZUF4Rt4viGxQzHKJjyMIOX06uTvmn3BBPdiydMx087XZZcmR7l4CZ5cJhJuZBtTgGNMdplOb9ViNMq0z7O7OQBhBRfBzhlSCVKb4FDorH+bmprFR8OP9vHkl1ZJih1CHfKdAt5e1zrd6VwLdYEwh2qYldktcV6+cqWpopkLq3OKB6eSht/WxgeJGc7mX7Ojw+sgFC9pQoMm6AkxLVQC7q+vb3MTlPd412p7kNR1FqninwutXpcJ0AcyGQSVO15khv5ZY8L7gyrp8qRNrskjJ204wd/Angz5GpeKz3zH3OD19nItjuhWCh64O+eSi6a9CTg8ZvLO5f8JPdu6Djpbt+eBlS/kluu3i9tl7oIXU98cUw9bSOojih67TTrWeawaS1NRG39W2vgds4nlVwY10Mz0E4m2XNv/9guYONkORKzFwTk7Raq/lo/tFQ1oFaiDuDKnIsDs3hkOKGz8fR7Fy63B1ypmcrNiTh+0jR6yvGdZPDyPdwFtzfCcxVtCyVIpyyzui8k1frd96WIZYxjf6lq3m/TaoKluaqpLZ+MATx9vj6wtvne83uGjMizao3urbktbpTAJ26cXikwBOG9Ejqb/6TuJ7crivNj7jabHA4PHg76fC1EgL9dX6OFXex9lUznBZmC4SyCJoRgrkhaX
 8Rtd9T03
 Uvd2yVSeIGNDSWgZYUjNPUpX+9iuOSky7R4bOrE4dpY+20lmTGVLHdRUFj4LXSIT7r6uw1NXZVlfBV5Aw6YvZNEvxTcLJXe3pefRDjwJ1J2djZ5D/qX011yeJB2srhfwKjy8OB8fQs/cgWzA7egQpSqt1tfk5FFSW5pmCaImVMsh6JWjbchJWMXWFKl9cLtnwKGfK8rjeoOwkgZ6F/qwnlZ56i5vIeZLk79ZkP+nl9vKVCNqm0H7SIYQKe4BZNYynxXmwhEYN4GzMGYcZqbXsvsKnyp8jz1ZaqMlKzYfhsAHrjs0TpkEjdXk3JVCz3m0yxn9AbQAbvOFFiqen9+HFBM9KfccY0gRhhTdEYdAAeonxMlCIN9cWnL7gacifDmYGpNqj+id1ssGJgefVcLGcZWgxsnWxSVMGderR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the write-only snapshot_seed sysfs file and update the userspace
snapshot interface text to describe the opaque wrapped-key flow used by
encrypted hibernation.

Signed-off-by: Sean Rhodes <sean@starlabs.systems>
---
 Documentation/ABI/testing/sysfs-power   | 18 +++++++++++++
 Documentation/power/userland-swsusp.rst | 35 ++++++++++++++++++-------
 2 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-power b/Documentation/ABI/testing/sysfs-power
index d38da077905a..c756712a9df5 100644
--- a/Documentation/ABI/testing/sysfs-power
+++ b/Documentation/ABI/testing/sysfs-power
@@ -470,3 +470,21 @@ Description:
 
                 Minimum value: 1
                 Default value: 3
+
+What:		/sys/power/snapshot_seed
+Date:		July 2026
+Contact:	linux-pm@vger.kernel.org
+Description:
+		Write-only file present when CONFIG_ENCRYPTED_HIBERNATION=y.
+
+		Trusted early userspace writes a 32-byte seed, encoded as
+		64 hexadecimal characters plus an optional newline, before
+		enabling encrypted userspace hibernation snapshots.
+
+		The first successful write locks the seed until the next boot.
+		Writing the same seed again succeeds. Writing a different seed
+		fails with EPERM.
+
+		The kernel does not authenticate the first writer. Trusted early
+		userspace must provision this file before untrusted privileged
+		code can run.
diff --git a/Documentation/power/userland-swsusp.rst b/Documentation/power/userland-swsusp.rst
index 282e01d2fe61..957be396dcf5 100644
--- a/Documentation/power/userland-swsusp.rst
+++ b/Documentation/power/userland-swsusp.rst
@@ -116,20 +116,37 @@ SNAPSHOT_S2RAM
 	its state on the basis of the saved suspend image otherwise)
 
 SNAPSHOT_ENABLE_ENCRYPTION
-	Enables encryption of the hibernate image within the kernel. Upon suspend
-	(ie when the snapshot device was opened for reading), returns a blob
-	representing the random encryption key the kernel created to encrypt the
-	hibernate image with. Upon resume (ie when the snapshot device was opened
-	for writing), receives a blob from usermode containing the key material
-	previously returned during hibernate.
+	Enables encryption of the hibernate image within the kernel. Trusted
+	early userspace must write the 32-byte snapshot encryption seed to
+	/sys/power/snapshot_seed before calling this ioctl. Upon suspend
+	(ie when the snapshot device was opened for reading), this ioctl returns
+	an opaque wrapped key blob and the starting nonce. Upon resume (ie when
+	the snapshot device was opened for writing), this ioctl receives the
+	same blob and nonce from usermode after the same seed has been written
+	to /sys/power/snapshot_seed. The plaintext image key is generated and
+	unwrapped inside the kernel.
+
+	The first successful seed write establishes the wrapping key for that
+	boot. The kernel does not authenticate the writer, the TPM policy used to
+	unseal the seed, or image freshness. Early userspace must provision the
+	seed before untrusted privileged code can run and must enforce any TPM
+	policy and rollback protection.
+
+	Under lockdown, direct block-device write() calls to the active swap
+	backend are restricted to the process which owns the snapshot device and
+	the extents allocated with SNAPSHOT_ALLOC_SWAP_PAGE. These writes must
+	use synchronous buffered I/O (O_DSYNC without O_DIRECT), and cannot
+	exceed the number of pages returned by that ioctl. The swap header may
+	only be written at the offset supplied with SNAPSHOT_SET_SWAP_AREA.
 
 SNAPSHOT_SET_USER_KEY
 	Mixes additional user key material into the data portion of an encrypted
 	hibernate image. The ioctl argument points to struct uswsusp_user_key.
 	key_len must be between 8 and USWSUSP_USER_KEY_SIZE bytes, and reserved
-	must be zero. The kernel writes meta_size with the encrypted metadata
-	size that userspace may transfer before providing the user key during
-	resume.
+	must be zero. During hibernation the kernel writes meta_size with the
+	encrypted metadata size. During resume, userspace passes the saved
+	meta_size back so the kernel can switch keys at the metadata boundary
+	before the snapshot header has been decrypted.
 
 The device's read() operation can be used to transfer the snapshot image from
 the kernel.  It has the following limitations:

