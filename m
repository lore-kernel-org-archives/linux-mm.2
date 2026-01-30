Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53952D73EA9
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 00:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952C76B0005; Thu, 29 Jan 2026 19:57:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DA86B0088; Thu, 29 Jan 2026 19:57:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FEEA6B0089; Thu, 29 Jan 2026 19:57:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 703BA6B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 19:57:49 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1EF3B8BA7C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:57:49 +0000 (UTC)
X-FDA: 84386817858.12.E503B30
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E2E140007
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:57:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YKnE+7KF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3CgJ8aQgKCFE2tB7651Dz77z4x.v75416DG-553Etv3.7Az@flex--jasonmiu.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3CgJ8aQgKCFE2tB7651Dz77z4x.v75416DG-553Etv3.7Az@flex--jasonmiu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769734667; a=rsa-sha256;
	cv=none;
	b=4FdolE/x8yc2wJJtjJYBJKKim75SZkCPAxKekq8thfKtdCEXwW1xYFvB4Zk0TsBEHLe5PP
	BGC7PL3aJnWsi2m1wmvXeqLd1mBVXk93y4FdqqXDlOgALRit/oz7BWx0dU2Bpy5obT1qfM
	a8YUV3wusYWGAnOZ+XaPpZ37Y9Z4WaA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YKnE+7KF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3CgJ8aQgKCFE2tB7651Dz77z4x.v75416DG-553Etv3.7Az@flex--jasonmiu.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3CgJ8aQgKCFE2tB7651Dz77z4x.v75416DG-553Etv3.7Az@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769734667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nakOP4nNLeplXpjUG2ytajYseRS79uoM0tVY0Gq55+A=;
	b=cQYmsH3ZIzEt4pXPckgVvD///n5AWgSTNySavo2B5InIlG3/LSlWC0TU2e3gdOcOby+uOD
	Lh9Pn0HiVK9GcT1411PwW3i98E0xLku8dPZB7I7Hmc/MXB7EfQPD1fZj9JD43kYjny4A2v
	9UpQszkJ0/97K8gyuQpuQBX9865L2/E=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2b75222e9easo5861521eec.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769734666; x=1770339466; darn=kvack.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nakOP4nNLeplXpjUG2ytajYseRS79uoM0tVY0Gq55+A=;
        b=YKnE+7KFXuOgGFD1cvsrxbnb+7ifxkRK+EkSauMV1v5+LKZtCWRgSJ8/SSwpJ64jSr
         HQD1UUPMhNbc8eotR2sxRSf381HlTZVBP2y5THjCqo5RqPrOfBVi7fNx/VCzUMPGGI2B
         egA0Oy7DFRwaWEIzjx7KvOAMyLlUMzwmx1F9WNThkD1zfWCj/Tvgfd26OUxL3a5P0Jkd
         IW29gWtGa4/77piRoTSrYoPY1WDRWPpbRorhqfLe1O4Q9rQoJizOArot2JH1/nttmtNV
         MGpyBOvwOehC9jSIxZaVCpB03wdOih9YH7i36RHI/2YKCVfOl1+FJEaI1saMLUAEKUzl
         NilA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769734666; x=1770339466;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nakOP4nNLeplXpjUG2ytajYseRS79uoM0tVY0Gq55+A=;
        b=sXVS2Ytlh1E/u7V1r+vUVutKQK8RIZ3NbFQJCPo4o0jrGZ/5MalQeeVE6+5PzFq3q6
         ZBr9bfOkcMBgc+s3YYNHsXPp5eojY4xEqNHQBZNSSDflNrN1AvgdWXAnUhcz/9DdRaib
         vvtamzBRTDoypj3LP1eSi/kkhAlgBVu2VbNALgC8sstc9vSbL1BZ5SF9eZI2Mvc/Hwpm
         rHLkcyIbZxVzTKCXMqzJPnzH2W2lRuRGUomcdCumfxktIozWCNDV345AczspGZ69wyI6
         RFzPrflqY4Go9tiDV/bwX9UVgRHjwp2c/jdGD2jbY5jJ6k0QG1iAF8NRO0VYmZZBUydN
         VdDw==
X-Forwarded-Encrypted: i=1; AJvYcCW/3xCmqy/JxSqLoRRzxxJD2owAvi0SwiaOFqLJ+GyBIIkhBe60K8lXkQjhsWB8oc2ert/TagisUg==@kvack.org
X-Gm-Message-State: AOJu0YwRb49lCKiICfd1VxwLaw/KGVJAzO7mhVmjBu7DG01Jql0XUoAr
	d3Emkao8p8mRTd86u9bFIRxbwjrVO4JG4ITLgunKSDYPV0WzD8Q+QkWSB3eyXxIWD6+jqc1iaPi
	MVk6naJ9vM5fKJg==
X-Received: from dlbtv3.prod.google.com ([2002:a05:7022:3c83:b0:11f:3ccd:73d7])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:160b:b0:11b:2de8:6271 with SMTP id a92af1059eb24-125c0ffe445mr596408c88.39.1769734666217;
 Thu, 29 Jan 2026 16:57:46 -0800 (PST)
Date: Thu, 29 Jan 2026 16:57:37 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260130005739.3163049-1-jasonmiu@google.com>
Subject: [PATCH v8 0/2] Make KHO Stateless
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9E2E140007
X-Stat-Signature: q45r71gza38cacqz5wsu83ucm8ytzog9
X-HE-Tag: 1769734667-175569
X-HE-Meta: U2FsdGVkX1+F5OI0nHR7i+X+khdOMmnNal0y7gwbqCc/3R+jhE5OE0gJMOxPBfcU4Mqtcljdx0+X4i5rq3Q7pFKmrd7Sd7XAvAwTjA3WD26rOMxI5PfKNxtmoo4Tq/c8Z7NpO2LPH1igjF76qOxPNisyrRM8t/yFBcLC4FEWWH4/6MV+yIyIf4d9GMkMsH6k1aXzb2rStjAlJ+ddDw9Wp+F1TL44EgoxvCTsDvO2uPPCfBHJopDEkwRj86zDwFMxDcKOjh/D3Nzqk3NfT5loeO+3OmtUIDrh0a3TNhQk7cBva5F/Kl4onqDZT2dQiPrQvIojQg0b9y3F9RXlkKFYNDT7WmJc85tluJ0xlxMVoznSBKC+HB1/VeEpEHuyXS2ZaZGFiP9Dua83okU6tBN4wjYsdxWS6o6flVkaGsS7FGHCLML760WKUGvHFP9g+hm5upnyf6ZWiniiMKwxSrh8DKKUIKM+Yy+ANpP4LBBbjoutfQWeGqW2d7Gn3+fO6bGj2MFUihZUI3WMp/kYh3pEbz+pJKI88mmU0kuoLx9TwsoBOHf+G84pX3YpSz1tYDkCD00ejDeRuHHYmTmUyyAzID1llSl2H1VahuuOMC54/v0c0ocD88k2XpmYtK7lNs/+FzbMzF6bY5TIp7YluTWdYnGZNexEKJ4fTHC/k+CriTgHN6yCPt/PfpK9gxwFAQnpPCrCr10dHFL0omUwRN74ARurQvZbjMJxabImYY0POWtRjCeq3vyJAaE6zFwiq7yjRVPFW5prxrY74FLJLgJyw+RlvrGlsOX28ACGYmTcRDBcX23ckKj/Jm8C0HhqzL/2J3QoTAse2hExVRfgos1gRJMVqRJadB3uR2KaiKgL0rcx+3ZuulyVF/ioHK7iTUnALJIm1tdcNb+BPVFLgn0a+2l5G2RcUAJxgTi8rewkCzDPA7QmxfV8Ek4eAFK9951JwttmUnKN10WxJu1soak
 QqbZ3aqj
 +e8/pDs+k5QoC/aKpGcdQkRGHqxYfKBpzfpwHWST3YDfLMtX2BHem3TABPK3jJfa6/5VgQpeAAr54W5gvItANqPiGO/qejFtpeP8wG1piJrwpLbX4+tycQlp/ZK0RO2c5lAkLILYoupJu9L0XRn4pu5+/udlC052w2FCR99UF+rjvamicM7J7/f7F3aalfytHYsLa1D0HVrKxIKKlYrvj0vM+PXLbdx6hlx6hokV7UqomHlu2CsWf5QRN9CWRCQLNwqk4zO0Hmv3QgIg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series transitions KHO from an xarray-based metadata tracking system
with serialization to a radix tree data structure that can be passed
directly to the next kernel.

The key motivations for this change are to:
- Eliminate the need for data serialization before kexec.
- Remove the KHO finalize state.
- Pass preservation metadata more directly to the next kernel via the FDT.

The new approach uses a radix tree to mark preserved pages. A page's
physical address and its order are encoded into a single value. The tree
is composed of multiple levels of page-sized tables, with leaf nodes
being bitmaps where each set bit represents a preserved page. The
physical address of the radix tree's root is passed in the FDT, allowing
the next kernel to reconstruct the preserved memory map.

This series is broken down into the following patches:

1.  kho: Adopt radix tree for preserved memory tracking:    
    Replaces the xarray-based tracker with the new radix tree
    implementation and increments the ABI version.

2.  kho: Remove finalize state and clients:
    Removes the now-obsolete kho_finalize() function and its usage
    from client code and debugfs.

---

Changelog since v7 [1]:
- Initialized anchor_node to NULL in kho_radix_add_page()
- Re-added kho_get_mem_map_phys() and checked the FDT memory address
  validity in kho_populate()

[1] https://lore.kernel.org/lkml/20260116034432.1520731-1-jasonmiu@google.com/

---

Jason Miu (2):
  kho: Adopt radix tree for preserved memory tracking
  kho: Remove finalize state and clients

 Documentation/admin-guide/mm/kho.rst        |  53 +-
 Documentation/core-api/kho/abi.rst          |   6 +
 Documentation/core-api/kho/index.rst        |  18 +-
 include/linux/kho/abi/kexec_handover.h      | 144 ++++-
 include/linux/kho_radix_tree.h              |  70 ++
 kernel/liveupdate/kexec_handover.c          | 674 ++++++++++----------
 kernel/liveupdate/kexec_handover_debugfs.c  |  23 -
 kernel/liveupdate/kexec_handover_internal.h |   3 -
 kernel/liveupdate/luo_core.c                |  12 +-
 tools/testing/selftests/kho/init.c          |  20 -
 10 files changed, 573 insertions(+), 450 deletions(-)
 create mode 100644 include/linux/kho_radix_tree.h


base-commit: 33a647c659ffa5bdb94abc345c8c86768ff96215
-- 
2.53.0.rc1.225.gd81095ad13-goog


