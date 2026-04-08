Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA68110F9964
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 17:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E8D6B0088; Wed,  8 Apr 2026 13:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915E26B0089; Wed,  8 Apr 2026 13:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82BDB6B008A; Wed,  8 Apr 2026 13:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7062A6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:26:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 102B257767
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:13 +0000 (UTC)
X-FDA: 84636067026.27.081CBA3
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2430C1C0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mmUekVg8;
	spf=pass (imf21.hostedemail.com: domain of 3sY_WaQYKCIA02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3sY_WaQYKCIA02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775669171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oXQyTXYZ9HA4GAttYpd1iImAOXEXFhOnKZhr8KGG2U8=;
	b=GFNVRbsAQVscfbXEnMMgkGA/yRtxX4NZYWuhClKK0sMLlEJtnN+jqGDc3IZsBc2gKK9ZwU
	4fpbrXJWI9w5yrNj0FKaKodhKk04THXqExLJC9KY/FusBhxw7HJONiseF7fQq+gTGY26Nj
	m88Bx9+kaac++52e6wXuKS3hlqUo5co=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mmUekVg8;
	spf=pass (imf21.hostedemail.com: domain of 3sY_WaQYKCIA02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3sY_WaQYKCIA02mlerksskpi.gsqpmry1-qqozego.svk@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775669171; a=rsa-sha256;
	cv=none;
	b=8LRHeDkMnGoOANwG3jcRHCWs9E155PUhYni9ukrBhVlnjt+pO7KtQ368bntzv+yydbg8Nl
	iJ6itBumjq6epcIG+fcYpAe4D2qOW4kpreKEqll+Dq65YWHN55q96JoGAuxSvargHrNjWn
	iBFN0ggHvJOvzIl/fBR8RoeEA5fYbxk=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82d42b6f2b0so15557b3a.1
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 10:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775669170; x=1776273970; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oXQyTXYZ9HA4GAttYpd1iImAOXEXFhOnKZhr8KGG2U8=;
        b=mmUekVg8b8Ok6y0kc6rmOQ+3B8P7P8usYoysxm6Kwpnz5V7zPdlbjdY4o/iFLwhrks
         W8wnczcPzTv17R59qD3BWpmsaizRgIa8YZJZ4YJGrSo01YujyRWcYkfQpZ9l9QHj8G8K
         yF5Yz17439Anh1MaleAZkTQwUEi/N2V66tdk0CxsFyNUWuAYmFLtb2vcw3DLv7tpl1mZ
         SStGaaTieSLZHZV//cskRzFbqHo0TLm9bK/+I5Im/s3qpOieUaf0/6OvAyQ76hYX7FFj
         84hvCJyhZpUiuPwmoICptUKBKFknYDu5MB5MqtfqDC7GmazEMVuSIouQsJWQPKnCl46w
         k+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775669170; x=1776273970;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oXQyTXYZ9HA4GAttYpd1iImAOXEXFhOnKZhr8KGG2U8=;
        b=GhVJ7BPtkO0CPTPQGn1Irpj/DSXvfBV35o3gsETBXpsxeZagMZIHnpwhFf0BtavL7x
         wtonRMbVKpw42psefIse20DDJU5+nJIVTiDZ/ian8lgV/Z1HHNtZgt4ubA9W4aFqnafa
         sBGMGBzPJgMohQO9jKhyUV6U5ONYO/yXhXgCbUJ8LGmDT33Zas/kfjWnophe+tU/k533
         wcB1sK94PeTkhsk6YWw0LkwW5Yf61Kcw6WdsKaO80/rzPqHKlSqSgsVF/b8tBTaTpDds
         KOQ4ntV8pbJ/MggE+IT9j7mPiFdtsWOM6Fx7ftmu9mzUlfDI4foFfkqpwsyvzYZY7YI/
         WM8g==
X-Forwarded-Encrypted: i=1; AJvYcCUwptJSD9XXCF1LvaCBX3vdsf6Hw9mZHpbzGVMmJy10CmFTuC/F3F4lK77VglzlJURbjMH3KXHW7g==@kvack.org
X-Gm-Message-State: AOJu0Yz73iMxy8oypUW0OoP61b/twl4utmEwOHAU/tDgvLztxrgOTU+c
	MyEmfgt5u4DzudH1nioTe2CaaoG5M+qfbS3d8aYv8ZXoqvNBC2z0Oijag/jP6I/+jAFbB6NMP74
	NewIwsg==
X-Received: from pgbcp3.prod.google.com ([2002:a05:6a02:4003:b0:c70:e4b6:a27b])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3286:b0:398:b499:44e0
 with SMTP id adf61e73a8af0-39fc832f20dmr634781637.41.1775669169633; Wed, 08
 Apr 2026 10:26:09 -0700 (PDT)
Date: Wed, 08 Apr 2026 17:24:41 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAFmP1mkC/x2NwQqDMBAFf0X23IWQ1Cq9FvoBvRYPqXlpF4zKh
 ooi/ntDj8PAzE4ZKsh0rXZSLJJlGgu4U0X9x49vsITCZI29mLNxnJAm3Th6Gb4KTpEDBr8hcJS VNfa8ODa2bdrQINavmkpqVhT73zzpcb9Rdxw/yad0vHsAAAA=
X-Change-Id: 20260403-memory-failure-mf-delayed-fix-rfc-v3-02878d7ef5b5
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775669168; l=2920;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=+gY9M7pK6g1wVjdUn1IEgoo+d0875SrS/mpl3kkU7n0=; b=pZPKd+rhK4e+NAPviiUHM2w6HcUVC5JRoewg3GzHhgWj5s8+YLuzvk/OygZLAk2t9HwTzPnwm
 zL5GLng99vcD3WUNtHTJ/15DbjUedlvIDsEAcNeVyyvO2Xr7qjvDPia
X-Mailer: b4 0.14.3
Message-ID: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
Subject: [PATCH RFC v3 0/7] mm: Fix MF_DELAYED handling on memory failure
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2430C1C0005
X-Stat-Signature: tgmubu31t6pzqrxsnk6sk3edqaggau4f
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775669170-462496
X-HE-Meta: U2FsdGVkX1+vTgVVfioB9c3qPKwbdYVknhXMa82mdBAXR+x0eG7mGh5++fdzFvcG4MenoeKEPRu1NidhXGt7tWnzP42f2R5IF/QJR/IEEXt/aMJcMKcLciS6em51ifzJfYxKdo8NtLsSO9m55l98TarjfXwL4s7o4nHPaSUrjN/fkTt15F4YhEElBFRbYdorjAaA1nUi/zDfDGRkzTp0YJc3GZonHGIM9tGiI+ACFMJs42x5Qnsn1fs6lHBu3V1XUzEh8FpEHUUMlri69lq2cmWKTbV+exwLWE8ZHM8OdKwukIN5NTJHHWkHg4cOE8GLeCZZ8CwpAccDSXHptnlTwhDcY3p8kFeGVhLShf2TR3dazjHZBv6c8HIuNDcZn3Gxy5UU1VjbrRqiSAMHde+bbB1wvHK0nj1LChv7tF9J2GFgZyZVzWbQNdFRbjiXKMfTCBz5o2MNm+WqcDLX6NrRgXb4hBwcLXjQbeCqDWVYpFOdPzcVzLtUf5mrcH8on1GdDTCcOx8EZhCsML+a41kzfe/Ii74NwZBgZlJYuJ43DY8MSb4KDvGBDmpbs5kUzVrDWWWXmc8FthHPKz1D0ySvQ2MxapnrQAThLVbNlvodotcIVJA4PhMQscBLwCvcfxORm6Rt+HCSYXXFppdOCOlT6yaJOR4bIQ81MApAfK3IafEx5QvJTrHXRIw7trMIMo6bxiVso1hpqDCL5shaJrXIFG+77fNCfBs0aUsOemHG0VJcsxj1NsptwnrU3/plKFvz0Mr1pUpw+ri85ob/6Z5S+ynGHuIKTGxo7uo5u9mE//Wsc0DaVe/9dMTx/Z1T+Yy1q9hJr5E4YFiFCNJw7bqso28AILeNrVT8FDPPxLxnbv4yDmqMTzi9FVPeok3ycwBaGYiJBgvDpov8W48XfIb6yRW7v6PS9A/AoqcvR4GzLebBV5UYYU2qfehTIuOVIswuUUOl1xpn338ZbwewhBb
 Yi932qTI
 xcNX10FKmOvmaa45gfwSip8f0guw2XEyOikKZSYQeiLQQYFsXkTImGn8iPw7zHqkz4g6t7INBOFqvy//lJqLWxE1qrQBtZJzpV6FaRYBL/xzRz9PXi1pTNtrm0abkTH8d8nOqJ87rPRBfJOESbU2r7J4McSl44eH7msMAdiox2NwjGzUixzZXX38zcEsSMB84ViMzKTLOitQUFGQU5997gLzr/aHXolbLRn9O7fiL5dS9Fseos0AfCVPjwpdRZXMSY07PCR7m++xTXhEnio1Y7qIee0+XOrR0V/iEpLApYtIX6iAZWjp5B2PZJkDrT4deOM/aSeZm16lysTrCh6TDSfUD2RiRkokck90n3gRdkzw6Akh2BEc9EKAeTNQWiuc1VjZkzXXZJKgO6Ed3PBgN2upfz8/rgkgxQUACm5GaV4qnxih81VTQrChr4/uSM7mH4BEcZPSNUyMEzXSkzAlkMtW73n3Yor4oxysLgFdcDd79xLq4G6kUTyqOpPb1epG6xQfroOabba23kJzZRVXNKGTNMXLUwvtwhzcETh8S5FR4YrE/ERWEAl7eedieIZVX2RCJ9vSxNspN1dZP7RtKnaRxZCPnbBGqizvpmpvYBjhNKfkD3Ll93QDMbVG55uHCfHXJuxB0NXfce69SlKLkTggNbpvJMLVKySo489mq9g0X+SOHZYch6SxYR8TrUi8aD2RZMjhwDTIUP9Rmq6u4nDsA0dqyQ7IlnvA7wHiLsIrHVAosrMhVfEaIOzSP2/gA/hqmmWeT/Uu5F1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here's a third revision to fix MF_DELAYED handling on memory failure.

This patch series addresses an issue in the memory failure handling path
where MF_DELAYED is incorrectly treated as an error. This issue was
discovered while testing memory failure handling for guest_memfd.

The proposed solution involves -
1. Clarifying the definition of MF_DELAYED to mean that memory failure
   handling is only partially completed, and that the metadata for the
   memory that failed (as in struct page/folio) is still referenced.
2. Updating shmem=E2=80=99s handling to align with the clarified definition=
.
3. Updating how the result of .error_remove_folio() is interpreted.

Changes from v2:
+ Address the comment about fixing the typos and clarifying the
  'unmapped' status from Jiaqi
+ Address the comment about merging shmem memory failure selftest into
  memory failure selftest from Baolin
+ Align the consistent style in truncate_error_folio suggested by Miaohe
+ Fix some bugs found out by Sashiko. e.g. set vcpu register when VM is
  running.
Thanks!

Would like to request reviews from Miaohe and Baolin regarding the
selftests:
+ Is adding more TEST_F()s suitable?
+ Are you expecting refactoring to reduce code duplication in
  selftests?

Would like to get feedback on the direction of selftests before looking
into adding selftests for hugetlb.

Also, hope to get some feedback about the guest memfd test in this
version. At a high level, should I move the memory-failure specific
guest_memfd tests into a new file? guest_memfd_test is starting to get
really large. Also, I'd like to use the kselftest_harness to handle
teardown/cleanup (unpoisoning memory poisoned for testing) on test
failure.

+ RFC v2: https://lore.kernel.org/r/20260319-memory-failure-mf-delayed-fix-=
rfc-v2-v2-0-92c596402a7a@google.com

Signed-off-by: Lisa Wang <wyihan@google.com>
---
Lisa Wang (7):
      mm: memory_failure: Clarify the MF_DELAYED definition
      mm: memory_failure: Allow truncate_error_folio to return MF_DELAYED
      mm: shmem: Update shmem handler to the MF_DELAYED definition
      mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED =
cases
      mm: selftests: Add shmem into memory failure test
      KVM: selftests: Add memory failure tests in guest_memfd_test
      KVM: selftests: Test guest_memfd behavior with respect to stage 2 pag=
e tables

 mm/memory-failure.c                            |  27 ++-
 mm/shmem.c                                     |   2 +-
 tools/testing/selftests/kvm/guest_memfd_test.c | 238 +++++++++++++++++++++=
+++-
 tools/testing/selftests/mm/memory-failure.c    | 109 ++++++++++-
 4 files changed, 357 insertions(+), 19 deletions(-)
---
base-commit: 513de28cb70afe6d3e24fe5b432c13363f9cfda6
change-id: 20260403-memory-failure-mf-delayed-fix-rfc-v3-02878d7ef5b5

Best regards,
--=20
Lisa Wang <wyihan@google.com>


