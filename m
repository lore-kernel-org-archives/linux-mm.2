Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 348E0CD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 01:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70E536B0005; Fri, 12 Jun 2026 21:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BF666B008A; Fri, 12 Jun 2026 21:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4B66B008C; Fri, 12 Jun 2026 21:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5836B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 21:25:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8E241402BA
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:25:24 +0000 (UTC)
X-FDA: 84873146568.29.9DA639F
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf28.hostedemail.com (Postfix) with ESMTP id 443B9C0003
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:25:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e6AAR3MA;
	spf=pass (imf28.hostedemail.com: domain of 3gbEsaggKCO4iaXQmQZQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--skhawaja.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3gbEsaggKCO4iaXQmQZQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781313923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cu/yolJajqpUi6JPaZqDIqNimARDAvp56AZs+065qLg=;
	b=1030jWwQ5JSTp7NXzdcG59BeiL0jiNr4vkTyA2J/GL9PFgHsVNqxtgk//U/+7STqSxz9hM
	aFxHEWIARKHY9/w3Xk5/YtnY2WtRL3VZvOmdUQkA36/56ITw2ei0b6PFI5+IHIzvzJdJtD
	9lLftkpQi5g+0Pvjmd+7N3S4knA4HPM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e6AAR3MA;
	spf=pass (imf28.hostedemail.com: domain of 3gbEsaggKCO4iaXQmQZQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--skhawaja.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3gbEsaggKCO4iaXQmQZQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781313923;
	b=DTD+grpBNyF578Avwd2D3NX6m4jlpllVAprgZQ5rHWiWckRsJJ+yfh8rbaBEXq8GmqhUlu
	0GYkErjHRv5V9C/OGpZPFvM4MH8Y0sGbJvlvOBKVm+pSVnfXjE2/8jq8ZzpMV2esTeANfx
	TVFMz1jnOr4JyGM/xs1H5jI1rfUGtRY=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c857fa2706aso639241a12.2
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781313922; x=1781918722; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cu/yolJajqpUi6JPaZqDIqNimARDAvp56AZs+065qLg=;
        b=e6AAR3MAzigFhPcSJmbb0Tn5dhNcEUPjYQhU7Dd1kMi9Jnkfq6ktzEENmt6Z+6EUDA
         JMEJ/x4fr7AGLfA9Ebr2mQpUcFJUovafectRlf2fxg34C3emqp696z9Z2+M6vmbiJYUN
         e5XhRDKPEaG8Vj5uRvF5ot5ww/n7LmOlSKlcI937rfv+VC93XPE90Me0OWEbeqnv9Cxk
         j6T7w4rGGTWPifkwUVQtb826hiX3qKJRvZdbJcfewDKZ4zjNAFubSfQmWGig3LCqj+/p
         UUbFJEhFsoWLGRQOCkBvi19bF9PqHbU06Hf3VzwF+dh8jNPgaKkqIEo8wG3oktAzk79g
         rD4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781313922; x=1781918722;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cu/yolJajqpUi6JPaZqDIqNimARDAvp56AZs+065qLg=;
        b=Xg3e3da590xw6Vz4PdXG6wjF96ZoHcZTKROlijMBTDazymsPQHyB+s1biUdnMHL/35
         QVMblojfPkxEQrDWpb7kNPTak2stKOGR517AMwMZyDH3kEIe5jrPGHF09kt7tmjTdZkx
         BSqRDOXgGXBKl14ggbgV+VnZL4WhaG8I6slDEzZcgGZmTPs3tzqchVRrdBcO4Akihi6e
         RLEnf5ZJDfK7oNlGXWc9A10ceyUkv0/xHDrBFaLssdFS9VIKYMPDlZrhSX6rSjn2c8q8
         cVw3PNSQ4CypkOrzg0czITQzjjS+WQnQqLDmS4FOX0iN4x4KuB9L6s4Sf5ASyo9AYsrt
         uvgg==
X-Forwarded-Encrypted: i=1; AFNElJ+6xI6XN6O4W8qwNxKQPxAl4IauA9FY68++yiy1KCCfZ8WH9ZYmMRI2MmXg6VxWeB0jYQdrZZWk8w==@kvack.org
X-Gm-Message-State: AOJu0Yz7JAFj6DI9NIzHeL3PzL8g2Z/uIQGHbRUvrmr9Gyh0taWCL+Qr
	tY8SVjjTxN9pi8tVr/MqQnnrHoKF6a0OYqoR4skvS3utr8Vyiu8fZh3EZEZcPP7UvgDYGiHH1/D
	N4ECZ1FmQuM+iqg==
X-Received: from pgce10.prod.google.com ([2002:a05:6a02:1ca:b0:c85:81b8:dc5f])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:7106:b0:3b4:7c33:296b with SMTP id adf61e73a8af0-3b7963cf4b5mr1901418637.32.1781313921702;
 Fri, 12 Jun 2026 18:25:21 -0700 (PDT)
Date: Sat, 13 Jun 2026 01:25:19 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613012521.835490-1-skhawaja@google.com>
Subject: [PATCH 0/1] liveupdate: Add internal APIs for file preservation
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 443B9C0003
X-Stat-Signature: dw1b3731ep5qxm9x9db8w6ph8yqzwbcw
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781313923-191232
X-HE-Meta: U2FsdGVkX18BiojhjF6B9vKAq80T6n23/YWpkJ2zro6pwKqu+567Kxlj/qgzYxLU3n+kQcYq+gP238tGJIsOmQfjNq2jl6y+y7nFdUE2VfgEkSpaCLFw3McgOz+VvUBR/quvx0/Flbp2DjowYaCHgSEm5pAZicz6gmX6slKF7Re68imCLPNzzgxFRzSxC7crJruJ/2YqEOFcqkcFGnxXeFzvJ35Q+bB5wwbCLYGD2smWFX1OKVUDvfeTNAIsAEf76DGejIsGSiB1zPcCw/YBcutBYVfSwZYvgYgr3DFzJVuRlGgYOFcxL7kDuJuNJsJiblVchbpN9XDmBGvpnrwEKon1XQ2VV9cRh7mOqYjJkvglpYQIuxnxLx7UmSyunAwq7ynI6LVdyfhIm/Ipxi3Z0YKmSTNcr+nMBS01J8O4XIRZ8AUOcmXZ9ZkZJ+fthL54ahcXm8ioqjSNN+kZf7NManYOKevC6ebm49u096BggmzQCV3xvK5EF6iIbkx8lzY6/aN70UY6Ir5hl/OV/2f2rFbOPdxM004cnV7BOcZYOZnK/wml7ezj1pvzIHdR0cl8Hky1ybXCaDopCLgX7f5PLrEdPzzxShN7T9ijhWiVYjaL670koLoM0M/NRrylgYZGtcgeEPe5ubrA3MmKLpoormKjQFgfmCET6SSlm760FLWW6mh0IJKOX7wXICPW4ziZWVBuoXEP8HZO9Bmoz4q6qmH3QT2S8qd2MM8w0YP8wxugpeGvcRZRWbf1wkWBasKKvp2jVQvLu/aY1/H66AT4A6/6WsDVczBLiTw6SpNLITVJCaOpgLxNPdYoNDi8bzYGz7s3nnejPS5BuDw8GrpbGyp88OIZzYVLcCOtmmvxt2lKUBpteN11xZX+Rk2XjZUjKen+CmIubEe13h8GwI5r1otzChv5loei6Ca+rGYzwoHtUs14THneT33aSeRMsMbSDtpvf5Dfd/eIeWnLPyn
 8/sKzF9U
 i12U+6gPrjc0TsyqOBai2N3KKwmleEcuvMuYdtP52DgUpupsGkkmHzBRfIgLMJFaLvcg65ibX8mntaDSmYP8E0++Mh8zKUcXJ8SHKeeGMOQw4qWhdfXMugAeZzCt8zDMc1e23o9uKX3CqTMBvFrLxfYrSJ/uEaLFfGZ4kflUqgA3rpSRIjfvwkm8oSqid4ElkGK9kA03WzdSwlBktvX9OBH1G0b1UvWVX6PPJiWX9/aAJ/uuHEK2o5Nh7hiLKHNkcht06pchYRvRyfLw+Yd3wtqkXnDDNatbuITbO7EqFRzEi/fQY1+XqXN5WMZ2uteZYYj6TuQRjnqfoHufMqHweUldOh8JIB8T5QQkOGvsfJZoy5rVuyiQCTlbRQhIhkv780U6giN5UJl0ojI8RevyRt5V69jplo+aMV12xAOaAc50OPNbhUs2jGSzkY30/nFZfuuc9hOTR6zUuBLEobsLVrSa3tzXHSV4GTLAUNRiClqE0//Uw3QbFHcLC93Lx3Kwc5Ly2JSQRoPyyYjdLsEMz6rD2XjFwiBDFasfzIS0k4Gd9sCslhFq+5pBrijRc4p7UxXfGEK+j4qp7MfE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Live update orchestrator file handlers depend on the preservation of
other files. To make sure that the dependency is preserved, the file
handlers needs to fetch the preservation token of the preserved
dependency. Similarly during restore, a file handler wants to fetch the
restored file of the dependency.

There are two known usecases of this,

- VFIO-Cdev preservation requires the preservation of iommufd. This is
  required by the IOMMU preservation series:
  https://lore.kernel.org/all/20260427175633.1978233-1-skhawaja@google.com/
- guest_memfd preservation requires the preservation of kvmfd. This is
  required by the guest_memfd preservation series:
  https://lore.kernel.org/all/20ae20f9d1a198b289444ebb4c824314cbba1bcf.1780676742.git.tarunsahu@google.com/

This patch was being sent as part of the IOMMU preservation series, but
now it is being sent separately.

Pasha Tatashin (1):
  liveupdate: luo_file: Add internal APIs for file preservation

 include/linux/liveupdate.h       | 21 ++++++++++
 kernel/liveupdate/luo_file.c     | 69 ++++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h | 17 ++++++++
 3 files changed, 107 insertions(+)

base-commit: 34e8f02817e31826e76bb2ded48bf28fe921f20b
-- 
2.54.0.1136.gdb2ca164c4-goog


