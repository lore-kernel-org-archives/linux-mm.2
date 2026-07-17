Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5101EC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370B26B0093; Fri, 17 Jul 2026 12:15:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FACF6B0095; Fri, 17 Jul 2026 12:15:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9836B0099; Fri, 17 Jul 2026 12:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C02586B0093
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:15:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41EE1C0152
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:15:20 +0000 (UTC)
X-FDA: 84998768400.15.0B3036A
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7E1EE40006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:15:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ccgTIUbf;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784304918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RbJ0Dq7r5q2pbKEUMnBVIvh0QCgrg4Tige0pOW6lYSw=;
	b=3f77bmsuVtCakEkpqW58Q2crePfR/MTgpb3Uf16kFzN+Byfyt6LPgOVDIP7GdWwvFpgPPA
	hATr5K5W2QXSGyy4Cl0+ezTOlK91KFu0i5rgIQ65+Q/GvRbZnsKZWutoBMm1EGV24fvgks
	miMIwRe1kRHkBnWTanXcu7ngtNenHUA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ccgTIUbf;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784304918;
	b=vriLRABSoUqUTkQhM6lnAMJrCx72rg05gI1Lk5JF8EK4TGx0uYWGwzh/Qw0eNVFoRYrcSr
	Aa636gG0NkQfhY5kWRBuIMXhEyLbBL8izceIm2k2Rh6fXpnJDw7Z0ahaUqT3VMXYPeG9bu
	FvvFlSmnaHiqO9iG04et+oXX3+WpSoA=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8111c0c7561so107100437b3.3
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 09:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784304917; x=1784909717; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RbJ0Dq7r5q2pbKEUMnBVIvh0QCgrg4Tige0pOW6lYSw=;
        b=ccgTIUbfH2zmKTrg/f3CpaY040u/ZTFMhayOMAratt+zKVaz8GgeQgwOfCauNIQJ+L
         mUTySi1lJyYcbKuLIwSkxqe0swSO4e8W6JIxoew2nK3ygkFmr9rG76/7elfrYJP23cX5
         fqicw741SRjHy2OwmWI4AK/Z/yY+SKGr/8Iz0QAAAb4aqH8OM4cChPl66yvX7JoF5qkI
         vu1aw62jKPZyNWb6pwivMejzINMB6fHSaCMNEvEaEu0RsOLIIlKjCtrJ4ppVVAmVJoz1
         TAnNbQhmPrYSIb/HrfHHsPzq1T95jTI4W2fFFTuZsfaeQTAizjyRJfnEp+A3pln032Z7
         GnXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784304917; x=1784909717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RbJ0Dq7r5q2pbKEUMnBVIvh0QCgrg4Tige0pOW6lYSw=;
        b=Xl/Sw/4N6Keu0eNbFstD/rzm8CXUsbG3XLayf11V4piwTv5v9IKqW1DnxVgPaEu7oY
         1nUgYGPg0TsSzPMcVK2frQEM0+BY96N55YQPMj/n8EyvI329TxArsdEl+UDR7nEksojc
         W4lf5oFfB1lvnRNnWvay1FHIz3U9H3nvG12sditG3uDQM7n7PZBxnlWpYEa2ebXGzTwa
         WxhQdQsST0da8S2CC+CKTSiy0pjE/SqPS6wtKxu0V3wgCDRmg+chzGtnZHB+pEb+RRJf
         IDgWSM173SrliI4T5qdomIW4o5rM5mhIKaiMh552Qu9l9YhwN4ubD1fs18k8mXR1ey1o
         76JQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp6+/Lbnux54jy6gxyTOL0vEEaN66QAS25uGQDcdhLbug/N7Q6fSOAQ4rDyMCco6HqTa6/dz3z9Ig==@kvack.org
X-Gm-Message-State: AOJu0YxhKsSbCfyLc94CupJwo1VPHpw89JJpnVpybkii+kH4NEZ0hVtS
	mU+JYdIc48tJurLbxyfe5gvWXeRr4yhP8mQcnozifDaMmhmy7WNjI0W/SUW9WYb+0T4=
X-Gm-Gg: AfdE7clGONRLRUbuLJsqz/ysJxwoCG+1E868++zA0jrGDPxpT5qpFxawoM7AfYvPIL6
	qkLaohZQ0o9xwmIa4Bf7mVpZJwR182yIVBmmKg9b4Dzw3YjrB/XIgKzKABR85FKbCPjzKc7W4FZ
	+q9VWqMXfJPF/ve2n6G+/zsyKt2CpYJonejKc8o8Nf6pzs4JiFoE7/PR4c7ZpTLHrG54Diyzvox
	Y+dSoI9ZYrKPXqbDqAqjCkTM737i9PVC+LV9JGx+8UHyJl43j8SGJ2NxxLw5Pr05aCu9isZ1u2L
	2Z7qtCyrFliCbfit9eQcabEBHLpb1LkaF+JL71syb1tsSYcsy0jmvFwRzfhayWTSmhAxdRt91bL
	MtbV7/t17eufzgcg3d0Z7uirkWDOb7TQqUFA9/LZlLUiCk2uD01XVetzgUGgJhQnKkbkyCm8Z9Q
	Wmw50iQyU35kgF8BPYqkB2CsfWmJjBmRy+E0wM6ci9Uqk1iEwaFTO9lFag/qc2gTAY9qZztuHAM
	Ju1L4jVw5o+Sr6a2xOchKex8cSMfP55
X-Received: by 2002:a05:690c:692:b0:81e:8b74:b35c with SMTP id 00721157ae682-81ef28050cbmr11065817b3.36.1784304916395;
        Fri, 17 Jul 2026 09:15:16 -0700 (PDT)
Received: from soleen.c.googlers.com.com (138.200.150.34.bc.googleusercontent.com. [34.150.200.138])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81ef40179absm13642147b3.6.2026.07.17.09.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 09:15:15 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	"Andersen, Tycho" <Tycho.Andersen@amd.com>,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Matlack <dmatlack@google.com>,
	"Heyne, Maximillian" <mheyne@amazon.de>,
	James Gowans <jgowans@amazon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Praveen Kumar <kpraveen.lkml@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	"Woodhouse, David" <dwmw@amazon.co.uk>,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [Hypervisor Live Update] Notes from July 13, 2026
Date: Fri, 17 Jul 2026 12:15:11 -0400
Message-ID: <20260717161512.3141871-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7E1EE40006
X-Stat-Signature: s6kdkj1xmksq6bh3njdkpiznzhdccahy
X-HE-Tag: 1784304918-767769
X-HE-Meta: U2FsdGVkX1/3uci6pveMeZyOx5DP7+wxsBj6wNb30sD05LHGFEQ2QmzceisJ9vVsV+1wAlzVwsh3sGe5DBM83Uz+KU4hy6wom8WR4+ZZH6aITWdgj1m/9U647vNJYtsyZ+vuq1UTUO/8f0DHSgcIEx7CRY37SmqTgZk0/6IOQfQtmdvj4UKPjuzMA9DdQoEI+hpc09IpoO1+G3fJVHX20XVsoUHGYZsZLgK9PGv+17GEDiPUIx9AcoWZzJa20MR9TTiZJgX6CoGbDDXtXHgR+gVGxlUtXJGNdzD5CszCOUQAiOVVe3bmR1j7QmO7vp+iFX0/CDHJQfOZ/w2EAMiFA19rs4NRPqn8Guc9znxQ3czdGj+7GPyBiId1aBk9mO5CSNQBChnCLU3wo451c/xPWiW7oU8Q7qXB/9+KBuH28IuQ8j2kf4SDwsOY8+zV0ho+Ecs9LlfrHUDQyaUZQleOLUtXxWv3OettptQVW9z9E+mkvTkvhYWuOfswVfafxJ6ZDnAG2fLS9uwxpOMjmzt5gefkweLM7l9pwr50J/1n4cBLOvnxbHxannLhF7DEm/diHpc5tBFLvmSgwMD9m3euVKJJsnmi1/OZ6GfKKZ2NobIbuJ4ZZieR/f2KmCR39V6NDC20yC9IURnOzLQ+OwdojorJIkT3hD+ztz0NpHmozCrxNWHJiG0MUEUs8mu4n+vXGmiULVPsc/VR+EWmENbrDF6J2lAlRB1Ly52Jk3PnRuZpqOucws2LUuVziRMRbYCxD7Tke2Vqa0x+teLH4dm5Ky8o8FgQ7Cah1GEjlTJyaed17YLye7jJjqY39G+Wqcf/Uuacs+QCQtSb0g3lc4tXkU32P/d8lADmnFNk8nz4rXHtWQaEjwaXtfxrEKy1TRQroeGII/OT5nM9yuBfZevpX5UrYtB0al8nf1dzDslqpkwBpd6+NEfwmkfQPUI7CFHGX4zk/3lMjx4Z08AFNZI
 5beiMiqG
 OjO7IRZBtODolNS2X34monDZVkmmZIdBYAV0w/aH3v5GC7HadIzWOAh6y777yHUzzy99CUayU/REINYoon0MmYj8mNPNSCLrWhaQcvP1QsgRhqG+wW5fdnl3OF15wE0KN7GGDBQBTKSqzvmRaHgyShQOlf/BZccGOcaq0OqJET/ljQTcEdrA5UBG0qwMO3Se3Adh/TcswB511hb9f037BlByalTJtFq3/XRJ++tUXodWk9YqfiLKZu5XECSNApxEeYJZMdxjIUqWIi679lrBbiMi3SkNtqKtJeZmqWxaRcRxIIOs6Ol/bxPXQykVC/AuXVaQc/eROmoBhLHg73QFtrGJU+i6a8CfHKnDv6CZggwWfwcXnhQpvqXKq2lIpAnorq5Ie+QnvgnbPlmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from our Hypervisor Live Update call held on July 13.
These notes are intended to bring those who could not attend up to speed
and to keep the momentum going between meetings.

----->o-----
LPC 2026 Call for Proposals & Registration

The Call for Proposals for the Live Update Microconference at LPC 2026
in Prague remains open. Please submit your topics and abstracts before
the July 24th deadline. Pre-registration is currently open for content
submitters. General registration will open on July 24th; early
registration is highly encouraged as capacity is limited.

https://lore.kernel.org/all/ahcc3Qyuy7Oy03Iq@plex

----->o-----
VFIO Persistence

* VFIO v5 Status: Vipin Sharma's v5 series is ready, rebased on top of
  David Matlack's PCI v7. It is expected to be posted to the mailing
  list shortly.

* Finish Call Cleanup: The group discussed Vipin's proposal to clean up
  KHO state and reset the device if a finish call fails. The consensus
  is to keep it simple for the initial version: if retrieve/finish
  fails, return false and leak the resources. This is safer than
  attempting a partial or unsafe cleanup.

----->o-----
PCIe Persistence

* PCI v7: David Matlack sent out the v7 PCI series. Key changes include
  moving to a KHO block allocation model (instead of guessing max
  devices), which allows dynamic allocation. Additionally, retrieve
  failures are now treated as fatal (triggering kernel panic) to avoid
  memory corruption in dependent subsystems.
* Landing Strategy: The initial series will likely go through the PCI
  tree (pending discussion with Bjorn) to establish maintainership.
* Next Steps: David's PCI series will be applied to the next branch once
  the FLB fixes land, allowing him to rebase (v8).

----->o-----
IOMMU Persistence

* IOMMU v4 Status: Samiullah Khawaja is working on v4, incorporating
  feedback and KUnit tests. Landing is blocked on the PCIe and VFIO
  series.
* Retry Logic: Samiullah proposed allowing retries for file handlers
  (e.g., under memory pressure). The group agreed retries should be
  allowed on a case-by-case basis for specific recoverable errors,
  rather than as a generic mechanism. Samiullah will propose a patch
  series for this.

----->o-----
KHO, LUO & Selftests

* LoongArch KHO Support: v3 was posted by George Guo using device tree.
  The implementation needs refinement. The team is waiting for LoongArch
  maintainers to clarify their preferred boot protocol (command line vs.
  device tree) and confirm real use cases.
* KHO Scratch Extension & Rename: Pratyush Yadav sent v3 for scratch
  extension. He is working on v4 to address feedback and simplify
  conflict resolution with the MM tree. The rename of scratch/boot
  memory will follow the extension landing.
* LUO Fixes: David Matlack's FLB fixes (PATCH 0/2) have been applied to
  liveupdate/next.
* Selftests: Mike Rapoport's end-to-end test VM infrastructure (v4) has
  been applied.
* KHO Component Splitting: Pasha still plans to split KHO into
  components, pending discussion with Mike.
* Directory Location: The group agreed KHO Red X3 will remain in the KHO
  directory to maintain binary format stabilization guarantees.

----->o-----
Guest Memory (guest_memfd)

* guest_memfd Preservation: Tarun Sahu posted v3 and is working on v4.
* In-Host Migration: The team discussed implications of supporting
  multiple files per inode (needed for in-host migration, where a new VM
  starts before the old one dies). Currently guest_memfd operations are
  per-inode, posing corruption risks if accessed simultaneously. For
  now, this scenario might be marked as incompatible with live update if
  resolution is too complex.
* Submission Standard: Pasha reminded contributors to include cover
  letters with their patch series.

----->o-----
HugeTLB

* Status: On hold. Pratyush needs to land the extended scratch and KHO
  Xarray before resuming work on HugeTLB.

----->o-----
Action Items & Next Steps

Pasha:
* Review PCI v7 series.
* Consult with Mike on KHO component splitting.

David M:
* Rebase PCI series on top of liveupdate/next (v8).
* Consult with Bjorn on PCI landing tree strategy.

Pratyush:
* Follow up with LoongArch maintainers regarding boot protocol and use
  cases.
* Work on KHO scratch extension v4 and subsequent rename.

Vipin:
* Submit VFIO v5.

Samiullah:
* Work on IOMMU v4.

Tarun:
* Post Guestmemfd v4 (include cover letters).

Jork:
* Discuss resource accounting and session handover (systemd integration)
  with Luke.

----->o-----

Next meeting will be on Monday, July 27 at 8am PDT (UTC-7), everybody is
welcome!

Join Here: https://meet.google.com/rjn-dmzu-hgq

Please let me know if you'd like to propose additional topics for
discussion, thank you!

Best regards,
Pasha

