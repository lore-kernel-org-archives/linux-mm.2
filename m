Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD039C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 02:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB36B6B00F2; Wed,  2 Sep 2026 22:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B826B00F4; Wed,  2 Sep 2026 22:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A086B00F5; Wed,  2 Sep 2026 22:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 760846B00F2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:34:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBBF6140402
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:34:58 +0000 (UTC)
X-FDA: 85170883476.30.961DA5B
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf01.hostedemail.com (Postfix) with ESMTP id 394DE40003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:34:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="EPQdWtu/";
	spf=pass (imf01.hostedemail.com: domain of 3z9yYagoKCEgvyqkxynovvqyyqvo.mywvsx47-wwu5kmu.y1q@flex--loganodell.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3z9yYagoKCEgvyqkxynovvqyyqvo.mywvsx47-wwu5kmu.y1q@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788402897;
	b=vmQ0397U8dE2OLbOnSMAstmpXWpM6LbLOHDQdUoZqKH/kQQXWuQ3GhtVqgP+yd4UFm/RZ3
	71PcpoFsI0/xTgSkjyK2k1JemUTGBFZETutQ+bDVDpkQCsg6buhVYYCKpJ2T+cG0amqsf6
	qBMCnaQdsA9sl4embvMgK5iSFVGlp4k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="EPQdWtu/";
	spf=pass (imf01.hostedemail.com: domain of 3z9yYagoKCEgvyqkxynovvqyyqvo.mywvsx47-wwu5kmu.y1q@flex--loganodell.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3z9yYagoKCEgvyqkxynovvqyyqvo.mywvsx47-wwu5kmu.y1q@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788402897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Z/CUOTjDyaAxtZC1lTIYdZbcKOF2SIWxflbwVxpxItE=;
	b=QiY4q6CwlGHoabFnv3wqJhxpbqO2hze0CGVizo9Y/0C32/wA83+jwYBEnF5/5HajFHt4r+
	iwkThZLk6faGQK1xWRQY6CrFO+bahke3auwNva4HKyoTGyMrEvG7cB4lthzVLFdzdehmFw
	IdrTlRn2YACDLJW3hXyEyfo1KPXfMKk=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38ecc48b3c2so2941741a91.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 19:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788402896; x=1789007696; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z/CUOTjDyaAxtZC1lTIYdZbcKOF2SIWxflbwVxpxItE=;
        b=EPQdWtu/Ck/UXJXxirawyMkc2xAV2gkxEjCjcQq4tdpzVkz0iloUcMlhytpio2DCxr
         i0YEhJthxmjHC9ZUxFgufSieMVfzxO12QuFIw6NU8jK5Lw257aM9A/yMvOImtrmiCfZr
         y8e826WBRQe2W4hxrclIKtrZE1qThXyZazMB8M/4nqTbPq7uuQRywzEhvK7tF2AHhvqs
         i8QHDqsuorLZSAQgIvYI2JZkPXp/u5fXJ7NhX1RqsnyJYv3KmKWYQB8AZyOa0axh06XX
         KFOmBu71Cs/VYovL3Dx/3QCuxALWWcCB36QBFUqCsp64y9HLqY56OSh8B7Qfeo1YLP3w
         NwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788402896; x=1789007696;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z/CUOTjDyaAxtZC1lTIYdZbcKOF2SIWxflbwVxpxItE=;
        b=OmqT96oVNtKHVCyHj9KDc0gs7O059cImQFgJgWNiZY6KO1GaCsHnlpgC1vQ8RrmUkl
         J4VP7w36FGyZ2ZOxKeAmC6MMgYGX9lAhTBs6h30qHoWnxy5+vFv/Q1+cFehqWrwm5Bgj
         O8MLHYAQXWPPQtSug+XVjKBCl3vwHiCE4NSz+nMh2xXqmJa2J9l3qsE6+QexsnARyneF
         6BVtyvtd1akBm5EEGS8TEXBEYg39AginCG7rnCcTqzhFRrZMz3GNOMnkgu5ZkvhW7rf6
         nzi3g6PyVuIiXGoYwaS67lkiHRINRr0b2V9nb6qJYRyB5JoOhd/RG91nqh7Cz5vcqB+1
         SNMA==
X-Forwarded-Encrypted: i=1; AKwUvByHKsLRv836mrvLN1tfCk/ayHSauLwZv4CaaEb7nFOMKb95ZAmpkLRTNH85KID5mLoTPXxYznjOtA==@kvack.org
X-Gm-Message-State: AFuF++kJRPb5AGNUYJK/EsucJdjsXeLsr1ZFAp3MK90JMS7k1+ZmgBjJ
	sFiT6/PCJY28okz8yX8DWVyE82GRwcC0bxVNOkIF5RYXKsYxvW09oQ8MrJ6986HxXKWp9ISqzAI
	EtgGzLP2+oLp/4Q+Fduogug==
X-Received: from dysc26.prod.google.com ([2002:a05:7300:3b1a:b0:332:2edd:e13a])
 (user=loganodell job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d85:b0:398:9c00:29f0 with SMTP id 98e67ed59e1d1-39aee249bd7mr14082963a91.24.1788402895806;
 Wed, 02 Sep 2026 19:34:55 -0700 (PDT)
Date: Wed,  2 Sep 2026 19:34:49 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260903023452.721732-1-loganodell@google.com>
Subject: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and memfd
 ABI compatibility
From: Logan Odell <loganodell@google.com>
To: arnd@arndb.de, pasha.tatashin@soleen.com, rppt@kernel.org, 
	pratyush@kernel.org, graf@amazon.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, maz@kernel.org, oupton@kernel.org, seanjc@google.com, 
	bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com, kevin.tian@intel.com, 
	dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org, 
	will@kernel.org, robin.murphy@arm.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-pci@vger.kernel.org, iommu@lists.linux.dev, 
	Logan Odell <loganodell@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 394DE40003
X-Stat-Signature: axrbtciir488p9hhq1k3nyx81m3g9kyz
X-HE-Tag: 1788402897-86732
X-HE-Meta: U2FsdGVkX19e34lftYt9EazFbXiXT0uRGHI4M5Qh4cJ0ba7TdlFIK6CFnlHUsSepH+sZdJ/3P05H/QGJS8K0kaVhpRbeiytIGxG4YjerSdBqN8gWHxEOT1BTWu6cGodZe7xkfp9u5G/1wXMeuLo0wno5Hr55wEbI+BqS5xa3ESyM/mL2N4gYL3pmMJKedaa4bGgzfSMqRClKKk7wlMIXhy2Ut9nZHX+qjrS6kHsulVdrvWLi8jfxTTnpQxMrgDkZ6grNswoHRcVWsl2JFQKnbBqyNLm5niGkKFSq9R4uoVNM+VlwRfToV2Si/N12PukN0dx2CRxICwnX0Pv/HKjaiddl0a5LUvJHkLI3W+KeG9EThUpWGyu9qm4aoQ4Up30qPGO0YRx5GvUc7GwGj0tfmOtuE2d8sKWozxHQYQmT5MyvEjMzBPGeuQj2XWJ120x65Mno/RD2nprL653QvtvhZn6vM6zhvY92wLQ5H4rpumcgRlzKZVyK8uVhrEv7/Gs5JprTFUVTK/McWHIeX1yzRGAG/z+uok+EEWdH8uEtMNanByR2W1PNGug//hXi2P79w5WTEbKRFXcL60w9oIq3Ohp8JdDqhLObLJNEVNC8IEk8dnVQH/D9k7VOaviVv7QetJwQo6jzHc+C5NiFrD6st030OVFle1ifxYzrRrMFL45MIklnASaDuRdHRUWSUizSxSa9B87hz6y3Z4hAbEjf5Lkc7TpIXPAdoB3bqrDnjD/wPJlo1VGsmimL4DRJMFQ/Z8l6J54E1D6LtqW8p+1rTG0+wRvXD9vTcyfLUnyYRyzCMHgk/SMic0eyCsyU+VMZ+CYk0sVPhDY8EbUbbShR7JU9FLOp7+qzO5ipRb/mSFf2OkJk0pOfORUktXpcVi/KaCeVXT4VFrB2yTbpwOIiUU/Q1Nbo9Hj7mJDqVClJHnJDGVP72A0T+dtDgOQHqS+Z0vr6tkKlTEdz2ttjHxn
 0UphgOmd
 UllOC5pzrgzvFtG6Yo+NnBbpUThZi84afYOEDRbV/zAWFVWmP4AOeTsmmGsaQbz6cPaYXPXXSSnKXvPYrnsU11sscXUhcckqrZCNnXa4n5dPWFpgCk53RuUts3T9w7J7lpcVAUuxBMbZfUZnSgUw3jkfnDcgaHNwCN3h0XFoAc49T8f6M0eOFHOmlRERpWGCVJtiekyWUVOAW4uCb2ZljmoKNWDZE7jO66IHGU94pZkDrvyJyXqX4j2y2VTMuavduLexf2AoBQAq3/+S2hpq3tz72JCPaOIoWdKqyjBtEYaK+vlVT6+V59j0Az1asnxgoYWhobfJHeNOuQpL/If0G3wTrdEhB/UY8yhtdzVLLvFf3pvrS/CfucXuVUcPy51KBgDRqVSKWfvyu1YqzEjqudk6GPb7Z22Z5e1bS0Eh1whkH/4YiiVGSeQ7fyTOCblxNbYFeK7XU3CaTWq5m6rsSgym9vkHJJ4KIav2YpZ+4MaggkMN5g4LeGZNrYZ5t9J0krkV6KvK/ybfC07bhNZUR/Sc2EUvO3JL3sXcIqP5nkL8CX+ZKFUzjGpRkf4TxTgtS3MDofVSvvkiqc24xNYVAHulErH+m0rcQlRYTyxtgYK7lrBK+MbPfPu9kGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We're including maintainers from all subsystems that currently is or
will be expected to participate in live update to ensure alignment on
the path forward for compatibility.

Currently, Live Update Orchestrator (LUO) and its file handlers rely on
monolithic compatibility strings (such as "luo-v5" and "memfd-v1") to
validate ABI compatibility across kexec live updates. Any modification
to serialized structures requires bumping the version string, which
strictly breaks compatibility between adjacent kernels even when changes
are additive, backwards-compatible, or optional.

This RFC series transitions LUO and subsystem file handlers to use
granular feature bitmasks instead of compatibility strings. We replace
the compatibility string with a header structure that includes some
reserved space to define the features that are included after the
feature.

We include 3 bits of data for each feature: supported, active, and
required. When the supported bit is set in the next kernel, the previous
kernel can serialize the feature and pass it to the next kernel. When
the active bit is set, it means the previous occurred and the data for
that feature is valid. When the required bit is set, it means that the
next kernel must have the associated supported bit in order to be
compatible.

If a feature is required in that it cannot live update to a kernel that
does not support the feature, it is expected that the feature not be
active or required initially. This allows for an intermediate upgrade
path.

Overview of Changes:
1. Define feature header and migrate luo_ser (Patch 1):
  - Introudce the feature header with the supported, active, and
    required bits.
  - Replace the luo compatibility string with this new header.
  - Validate the preserved size is at least the size of the header. This
    breaks compatibility with the old way.

2. Export feature header information to vmlinux (Patch 2):
  - Adds a .liveupdate_features section in vmlinux containing
  - Adds helper macros to export feature information for a given
    subsystem
  - Export luo's feature information

3. Memfd Handler Migration (Patch 3):
  - Migrate memfd to use the feature header instead of compatibility
    strings

Logan Odell (3):
  luo: Move to feature flags instead of compatibility strings
  luo: Export feature support to vmlinux section
  luo: memfd: Move to feature flags instead of compatibility strings

 include/asm-generic/vmlinux.lds.h |  12 ++++
 include/linux/kho/abi/luo.h       | 114 +++++++++++++++++++++++++-----
 include/linux/kho/abi/memfd.h     |  41 +++++++----
 include/linux/liveupdate.h        |  22 ++++--
 kernel/liveupdate/luo_core.c      |  60 ++++++++++++----
 kernel/liveupdate/luo_file.c      |  28 ++++----
 kernel/liveupdate/luo_flb.c       |   2 +-
 lib/tests/liveupdate.c            |   2 +-
 mm/memfd_luo.c                    |  40 ++++++++---
 9 files changed, 246 insertions(+), 75 deletions(-)

-- 
2.55.0.979.g7e5102b832-goog


