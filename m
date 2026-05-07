Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7019BCD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 23:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955F06B00EA; Thu,  7 May 2026 19:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9088F6B00EC; Thu,  7 May 2026 19:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7DE6B00ED; Thu,  7 May 2026 19:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 686F76B00EA
	for <linux-mm@kvack.org>; Thu,  7 May 2026 19:33:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CD8D4061E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:33:02 +0000 (UTC)
X-FDA: 84742226604.25.F5849F3
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf13.hostedemail.com (Postfix) with ESMTP id 319D72000E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:32:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=iVYEAzSY;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf13.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778196780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0yXurVd+vBtVsJ59FkRCImq2A0GRBwr2KgHlyQcm6R8=;
	b=T875+5ZU99/Tq5mU9FW6FKGjzL+edWmMI/jutlqHGxiK/s8w0aU+2s6a6rcDoeU6sF68v7
	DJoSdOUZqLrw8A/F3V5CjeKzwjshEgAZW/wSvygFYZfrpFkeozzNSu8jcyXvGjj982w7Tf
	+ckX+X4ksX6y/+vcU8qAqs+83CN/iX4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778196780; a=rsa-sha256;
	cv=pass;
	b=4Bs74kmKFENi7TgwNic260cekY6i8cBr3lzgDFLKNvGfa7BOzD2En3I1uB0rwfgaF584xm
	Ky8wAXmRIn7EescL28tZmEDq5rS8nxewiBzvkZPx3N4gRAln8sDAP2SflDHLEeH67le0/Z
	8W2mEFH8sllKVspGkjRNJ6WD8084Z4k=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=iVYEAzSY;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf13.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1778196765; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=iodR+X/sfygQTZFO7MO+8dJKs+PSVKYNwaZcBryNUV0U6DqjGSN+r9IK5htAANVryOd7ThQu9KiqdQDmdYHuH5nkujSKRHKIykmcy9OJ8S+8/rkmKl+2AYRn2h1ULv3P4fNbz3/amBZ80xNaMgQOqAL5xapuVqlLCga4bo20uOE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778196765; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0yXurVd+vBtVsJ59FkRCImq2A0GRBwr2KgHlyQcm6R8=; 
	b=iVolRgS9IUseYB1TZIT30l1YI9IVnXPPF+Jem6gvazKAJ8wUQBjl63qoMHRF5XU5UBGOTG5AkfIouemwjiKPkuMZfaxfzqmoE5QMc7d7icp50jRTqfd+wA6+pa8Ul9EOcPwDohHHiEvDLoEn/VHbrjapKhHURlqlcLePdn8TuQE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778196765;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=From:From:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:To:To:Cc:Cc:Reply-To;
	bh=0yXurVd+vBtVsJ59FkRCImq2A0GRBwr2KgHlyQcm6R8=;
	b=iVYEAzSYWg8zuqA/0fzNP54Rcvy+I5m6/m1GN2ptYnzcxD8orITKLm+e+UWJ0WBQ
	JMisswL9xB5p6AjNxestVh58t91+cAQqiyBAMTDlxrSSNl1+FxZdWYC/5Z7vPNglo8H
	vTppCf0WkaWowBB6Yo6G8n/SjplL1urtJG14xbwo=
Received: by mx.zohomail.com with SMTPS id 1778196762618896.5906424507173;
	Thu, 7 May 2026 16:32:42 -0700 (PDT)
From: Deborah Brouwer <deborah.brouwer@collabora.com>
Subject: [PATCH 0/7] drm/tyr: add userspace MMIO mmap support
Date: Thu, 07 May 2026 16:32:38 -0700
Message-Id: <20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDUwNz3ZLKIt3c3MQCXeNESxNDEwMTs7SkJCWg8oKi1LTMCrBR0bG1tQC
 Dm0F4WgAAAA==
X-Change-ID: 20260507-tyr-mmap-3a9414046fbb
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Daniel Almeida <daniel.almeida@collabora.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 boris.brezillon@collabora.com, beata.michalska@arm.com, lyude@redhat.com, 
 acourbot@nvidia.com, work@onurozkan.dev, alvin.sun@linux.dev, 
 Laura Nao <laura.nao@collabora.com>, 
 Deborah Brouwer <deborah.brouwer@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2137;
 i=deborah.brouwer@collabora.com; h=from:subject:message-id;
 bh=+hdChgrxdEzktXzCgBh0WuTgbVK+102ALnzsogUqgo4=;
 b=owGbwMvMwCVWuULzOU9c7WvG02pJDJl/FSUl922OWt1eskJE4PJyC8fzt7+fT4lYIbq4wk/jY
 MWabvnIjlIWBjEuBlkxRZaz9kY94lXvjXTn/2+GmcPKBDKEgYtTACbyYyojwwqXJh+NLexTj4rt
 aix3n22//fKDqv74A0nPM55rLZhU2szI8EQn+v2zigeK500l9uT/nLF850+uLQlfVGU3HdRN9Ir
 JZgYA
X-Developer-Key: i=deborah.brouwer@collabora.com; a=openpgp;
 fpr=CD3F328C177AEF322D9FFF8379A829E70C5E7DEB
X-Rspam-User: 
X-Rspamd-Queue-Id: 319D72000E
X-Rspamd-Server: rspam04
X-Stat-Signature: 4t9i8a9teedhs161ardi9auyfg8ay5zz
X-HE-Tag: 1778196779-768744
X-HE-Meta: U2FsdGVkX1/QrAaPEO4vc/m2RmZBCsG58v4YV6BJf1wd+1DwRPflJyt2zVpAAvu9P03PsgLWiJMgCYdmhe7CTSrw2LmBlQe6jFZhzPsj+HfNs3v/pGPVUc6ZRWWABZ63l6xYM/jC7TCLvw7Qqmmlj0czVRU1Kp+417y5sJlbgACkTsFfkWArrRVivJ4efPToSzrcSxBhBDCirvRwbMRVqW9cE5DHbRrBkrrtsBoh69A3NTs9Z+x5t0ECbmOK8obg5SZmHZ1goo/hDcPflka+E8ZZr6a5nP01ioXj60VFl/m0y4K1LURgHO2Qi++tL81RBlSeyn6c33ckvVWTXFZ+gdPIvnglFFZ0Q6Pa0F+3dKu2/ocxgHt8nGJHMo/y0XAny/6c7JXanj21+wXLhUe6tMtC4MOB3a5cso0eI809QUpO9BcmJLYSKetEtOE7RaterLGWevI0TrqFZQkzzLJOZLfqlJxG8/NGgPCGWAjuGhlw+pJ/Gp40HwEDAlgKWzTUHDfeE8Is+PPNILwGePvQNCIsojzVyoduQGs6J8DVmHQW+ozthUDMnuEAKRHBHEokcIzDUkCUt4BRHYGtHBiDZGpH5108joT6ibfncsh8GkSqq3XiNDnmqwLDWzX1TSduYlMI4FeWP+z1nQfOGU+8EwZDXcx6yBonlwhcYj1IY4t33fGc+mjl+jbfssJqy7etyMn5rlmzUBYv1c+JuWzLOLjZ0eIjbDZNGwbLZXRg+9rN7PMXzpaE+KlIqb5d+euAGfrHlJPdQr1+qjdFEDUN01s6S4b7vCeZHbRUoaQgzshC3oCOV7rtRproMWMES1ZJ34TVtKoeJXYQ2uamozfM8metqPTuOPovT+nHIIkNApBdwSq4y98pxHJZ8+vLHCkUaG4R2c/iawk9BYerrDmXtwPHqh6XBp3UrzAblwHgLgKt0bGQR5+J4+wh+RU+dWAI7CRyeY3UJxP4XTFAgcT
 rFrNdrtY
 bV0g6bw07PrO76rxpLPLzafJ1lMuc+c+Od7nosdMwBZzzXnsS0qgEbmgRwghbmEh+J4Vyo+npwnBtbMsw1aFnC4ENGbZm8GdQHe2U6Hl1ECbynLb3n5WlGmz6PvZmVEn3OO0PIRtF0Op3Hp9LjvWe5roj9tVZM5hH+QSfC7hlN5Pi/gTuctYAnPDBipQVFLKIbyz4fL1OylxyvWE/hbPrXVI1ui0MsX7HLN0g1FII+mfI7zVOZByt/dfHqCOvMDcvO/CX7iuYxpCqJAWx79tDuUmdiMZJC1ERLyH8ZVdkcWZb6d4vUzmEknhUMb8WBhuc9YOe6ZBITmdGNgfNsNkdtpFx4cL/LNgUsAkEBnEbDiiis8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds support for Panthor-style userspace MMIO mappings to
the Tyr driver.

Panthor reserves a special DRM mmap offset range for exposing selected GPU
MMIO pages directly to userspace. This series implements the initial
userspace-MMIO mmap path for Tyr and wires up support for mapping the
LATEST_FLUSH USER register page.

The mapped page is read-only, non-cached, shared, and faulted in lazily
through a custom VMA fault handler using vmf_insert_pfn_prot(). This
allows userspace to observe GPU cache flush completion directly through
the mapped register instead of polling through an ioctl.

To support this, the series adds a small set of Rust MM and DRM helper
APIs:

* pgprot_noncached() wrapper for Rust MMIO mappings
* VmaRef::pgoff()
* drm::File::device()
* driver-overridable DRM file operations

The series also adds USER register page definitions and stores the MMIO
physical base address in TyrDrmDeviceData so PFNs can be derived during
fault handling.

Signed-off-by: Deborah Brouwer <deborah.brouwer@collabora.com>

---
Daniel Almeida (2):
      mm: rust: add pgprot_noncached helper
      mm: rust: add VMA page offset helper

Deborah Brouwer (5):
      drm/rust: add File::device() helper
      drm/rust: allow drivers to override file operations
      drm/tyr: add USER register page definitions
      drm/tyr: store MMIO physical base address
      drm/tyr: add userspace MMIO mmap support

 drivers/gpu/drm/tyr/driver.rs |  12 +-
 drivers/gpu/drm/tyr/mmap.rs   | 247 ++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/tyr/regs.rs   |  18 +++
 drivers/gpu/drm/tyr/tyr.rs    |   1 +
 rust/helpers/mm.c             |   5 +
 rust/kernel/drm/device.rs     |   4 +-
 rust/kernel/drm/driver.rs     |   6 +
 rust/kernel/drm/file.rs       |  12 ++
 rust/kernel/drm/gem/mod.rs    |   3 +-
 rust/kernel/mm/virt.rs        |  10 ++
 10 files changed, 314 insertions(+), 4 deletions(-)
---
base-commit: 37f748ed0c19e007e7c5677f5d605d6b93841792
change-id: 20260507-tyr-mmap-3a9414046fbb

Best regards,
-- 
Deborah Brouwer <deborah.brouwer@collabora.com>


