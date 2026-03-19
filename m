Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 082AC109192F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65BF36B04A5; Thu, 19 Mar 2026 19:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632C26B04A9; Thu, 19 Mar 2026 19:30:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F9F6B04AD; Thu, 19 Mar 2026 19:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 43BF06B04A5
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:30:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DEC921DDA1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:30:57 +0000 (UTC)
X-FDA: 84564410154.26.0965876
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 003BF160008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:30:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jh22sIJF;
	spf=pass (imf08.hostedemail.com: domain of 3Loe8aQYKCIM35pohunvvnsl.jvtspu14-ttr2hjr.vyn@flex--wyihan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Loe8aQYKCIM35pohunvvnsl.jvtspu14-ttr2hjr.vyn@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773963056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yCIxwFZ47k6gWbx57q3bhruGtmGGBP4Tv/5VwuBdu0A=;
	b=jNagjpbfbw4Z0MRSP2PUpA1VfW9p5SeuK5f/ojjbsuRsxOBBurEBQDfElywkpswbIV3CUp
	WOaOCesvmOisVXc3qfLwJTsFEGJBAp2fROBl5zwR4+nOwEislbYS/1EuL2AiccklKZFHXS
	qkZVdtrCNHfK0m30f74f3RHvlwYQnVo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773963056; a=rsa-sha256;
	cv=none;
	b=CyLo9eYSN1HhIjmHFIcZKKEtiPjJ23Z/wE0KysoW+8eWYrNoWjbFw6MtTzetrIh0HwzyU0
	bcjE2/tY+In9zP9d17ckmSUKjwXnEbzRw8wT53PR2ubx2IrwRoePDdQoaNfi1oJ3IBiDCR
	wFwTp82SHJapOPJZxdvoNtcOWdkEo+Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jh22sIJF;
	spf=pass (imf08.hostedemail.com: domain of 3Loe8aQYKCIM35pohunvvnsl.jvtspu14-ttr2hjr.vyn@flex--wyihan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Loe8aQYKCIM35pohunvvnsl.jvtspu14-ttr2hjr.vyn@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35b901d542bso9675981a91.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773963055; x=1774567855; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yCIxwFZ47k6gWbx57q3bhruGtmGGBP4Tv/5VwuBdu0A=;
        b=jh22sIJF4gAbBsbypHuLaamZBaI5YvgxGxStfhTcb7qFpgBWVKX/i7NJZbrKqBIjxH
         ATxjW8deORDwKw80QCpriGZlpwRAchyTyOb6UyUdsSqMZSaZM5kU8LQ5PWy/taqtrwv4
         OUC1BjphrVjJ6cHsUwPHR3oF4DQj/Bk+dF0+eqgdbCaTA7/ohmAAeQb0fUSplWzH70CI
         mZzupCo9cwZ+14WYgjm/69wQkn40mEbtx8PwmkG90xceYn4uZTX+5eGvM4Wyn45NiSXT
         CXQRMBJGTl3CUF5vaQbEAxLgn1UJRfuTgAiLUuY5tCb3aQrFdVxgSh3W4p06U5PdGeiF
         OyIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773963055; x=1774567855;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yCIxwFZ47k6gWbx57q3bhruGtmGGBP4Tv/5VwuBdu0A=;
        b=AzOw8KwwIZXP63eXoGEEP6wZQQ1KXpisHCjxMRn1g2pfwU2OpNVQiu6IDdsHL4XOMU
         htsxs1gTdaj4eLd/2gWdEjNf+y98ZXk5CysbMg7KCdBUIjhGPlPdhXq+GnEGV8mhV6dI
         SUhH4Zaru/118C4cC0OhDRQB4FQlXB6HxNiBXSAqJLjmxXu9W0JKpi99LN9jOmHTINFQ
         pn140kAGUco0PbpN+PYgT8xAKYhO2J4EC10F8IscXdWtxmpMoUYB42eZhPRv+nBPGWMu
         EBGllkNL1h1G2mD9Ioh2QsTCbhN1afmmkkgehhMMkX9QFu5220v9zSVn7T+TyXxD7Sss
         zHRA==
X-Forwarded-Encrypted: i=1; AJvYcCUSL/kw2r5DqySEQ4dfspGT7+KS9uSU8ZS3hzzOgh6QckxUSWxsJmADUqMXg2F8f9LoslZls8k79Q==@kvack.org
X-Gm-Message-State: AOJu0YzA4Wm+5NLaLNvYgzO7YvzHA5eVMCuHAx4yqJBT0uSduK6JW79p
	8vTPGzUlB2HmfaY8svUv/IMHUtO+kgoexXCWajpLljeaX04LpKnkvvTevvZVxQ/bKXaomSFTZtA
	qQgZiZg==
X-Received: from pgww9-n1.prod.google.com ([2002:a05:6a02:2c89:10b0:c74:42:8993])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d05:b0:398:a6d4:dbf7
 with SMTP id adf61e73a8af0-39bcec2990dmr884293637.55.1773963054511; Thu, 19
 Mar 2026 16:30:54 -0700 (PDT)
Date: Thu, 19 Mar 2026 23:30:27 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIABOHvGkC/x2NQQqDMBBFryKz7oBJqaXdCj1At6WLYH50wKhMq
 FTEu3fo8vF5/+1UoIJC92onxSpF5snAnyrqhjD1YInG5Gvf1Gd344w868YpyPhRcE4cMYYNkZN 8WVPHq+cL4FxswtUksqtFYes/86Lno6X3cfwAHAkyQXsAAAA=
X-Change-Id: 20260319-memory-failure-mf-delayed-fix-rfc-v2-5ee11d6a7260
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773963053; l=2186;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=mpcY4kRf+nPP5p5eWgT3Y1evjSbcjRoF+f54tj5v7pY=; b=mWnFvQ5ui3ggdbSI/gbCZaSWpVcU5hlhGvSATXtAyXZwDfjEUhF4BWK5E7B5/5PQNCDI5xSiU
 xIX5xLfd+SSA0zwnDrFuPU+talg1mimDxNRWM7dNEzT6Wnry6w6Sa0M
X-Mailer: b4 0.14.3
Message-ID: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
Subject: [PATCH RFC v2 0/7] mm: Fix MF_DELAYED handling on memory failure
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 003BF160008
X-Stat-Signature: qinjcnnpdo37szc5xbkor6oa5dnkpcmq
X-Rspam-User: 
X-HE-Tag: 1773963055-388013
X-HE-Meta: U2FsdGVkX1/m5NLe+TIxBPENi6hZ1YgBICTFyqpyWaeCgs5lJphfERE4GVBn2zR0rir7P0NFMUXJZHyUtR6wZvKMDFGRAMBqQ+Tk6JDVaSQcswSPIcDNJo0BLm/4g17Z9IfJ2zRxZbYgSZ/nQ1Wm9mTVEHn7eizCFzniS4TRgc8wa6BPOz12aPumLOW2N/EHJE8PTsqPah5G8QZMWIioEacMZmrpLGMZRjyyGbsJkH6F2g0gW+uhRY2COFr1Z4e6id+eBKdvvYFHgdeUMMxgpdG5RRdQ8IjZk/ZzYh4/kK2xJOkHJjHYKEJi3B2uCfu0W6x00P63FJeV1hOIDilAAvez05YB4YObk0zNuf5o8MOR//jYqRL+ZBRlwUvwJNheMAvDhPmYmNfePQGeY9TaPrdUCEXAsZI/0eIOvooE5IElp2UrUKxB0lvBHAkSFbvrFRFl4Jtb1B9+aMJEPis9/aoX4h5V2fTDSYM+3wNr9B/CnoWUWc+IzMGVFfrizi1K4y1zrNqL+nXRDwwpJGUw4weoyD3ZHoN+wsb0+R7v/OZl3Iyt52/PaUVmbXb+wgmD8azw/BDrSDVTZlklbnntEjGWBV+bxrirqZLxHAjNRB9SaseWncCoHCJY2gEMqgrKrO3FA8NrJSIN9PRCpjqf/iVsxZs3rT0syQq6HUswWBnBgb9T+NWxEx+PM+jRgcGWBE7BjFVYc0RKF01+Lgh3eHi1rr3fVIqsbS0+7ZOXsMq2ScM0jaLl1V+/nr96oI/5RWMmZDz/mtYZyJ/Q4srX/rvXQSZcX8cgU/O2D93Zl/siZeQ6bBet3lCy1OBhyv+9dxVPjojTHn/YIh7HFRD225xBXtjHhSUbMnuAVs7nUWOQT3RCG8FXa6gXzpD4dKMTY/8v/8WUyC8AgzKtZAjVnA4DQTpb+GLvTqF66w4Jk5lbmDmygqzVObQHe2lf9UvgDAxTtNBcmVZzzMkeMUn
 pU+zCHc5
 NC++I6XhjMMBxbDTl0AS2DlDUgNwix4u95odAlRb8QnlO9xTN8LaHOvmNBAj1wQ0DRRkNrPHYKVqfPZib5uohlCXUb3bNb0Yls195S0sG6jHFfZnZnN7q3wpJtNIvTyvhfcis+vjBNtaZXIz1l2h203AzLGcOQpOudCmLeqAbsvPb9KQEL8LLaAoEiNuZ3kfygArnYRylYBsMcp16kBcTgdLahOVeYzz9IWMhGq+hsHVVQEhp6oH/KqnPmD99a0YMQ3ApvmnZcU3Emn3dEa2tmsTBdtblmnfqa5NA9zehpc7hq41wL3nZ2urPvu8uj1dOfjmlvesGYcN9it3LW3StVzMvPpxalfD98cWQuI5sDqlAb2+83yxyJgodCWAeKfjZiGCOwBIyDv/FNKrO0cI7Ft3L9LaUlIEpAdhVkNZchObX3dLiA9G6v3vqTOhrRftFlnPDsdaNRqNfYpyqfPsLqXq4zK/wPxN4SHYHD1l7DXy3puX/TZrTbXocVeGTXfrVvDpI3Wqtmx5GwebGYVMr7XpB4zcBwcJDZrfTp930QqE/mvv0t/JGX0ClYi6iNmzXqfByHK6dR48pog9HobZMwKVaRrPMmfb9Uw/UrV0WeyyFvegOdnJtNUjow/vMfSypNnVCf8bFB+QIjaxXpk9OerlgIVcC1M2VHufOaSZ8UE1/rgrNpl6bXmoD/oLmeplFVt7BNTnYujviM9EVN38Clp843vpHGKWwvr/y2CfylVxGmMwrykjzeuc0DUbiXGnuM1nhxkfaRWgeNBDTM1e+JGmyU9gYGAN1M/nX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here's a second revision to fix MF_DELAYED handling on memory failure.

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

RFC v2 is a more complete solution that includes parts 1 and 2 above to
address David=E2=80=99s comment [1]. Selftests are included for all the abo=
ve.

+ RFC v1: https://lore.kernel.org/all/cover.1760551864.git.wyihan@google.co=
m/

[1]: https://lore.kernel.org/all/91dbea57-d5b0-49b7-8920-3a2d252c46b0@redha=
t.com/

Signed-off-by: Lisa Wang <wyihan@google.com>
---
Lisa Wang (7):
      mm: memory_failure: Clarify the MF_DELAYED definition
      mm: memory_failure: Allow truncate_error_folio to return MF_DELAYED
      mm: shmem: Update shmem handler to the MF_DELAYED definition
      mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED =
cases
      mm: selftests: Add shmem memory failure test
      KVM: selftests: Add memory failure tests in guest_memfd_test
      KVM: selftests: Test guest_memfd behavior with respect to stage 2 pag=
e tables

 mm/memory-failure.c                                |  17 +-
 mm/shmem.c                                         |   2 +-
 tools/testing/selftests/kvm/guest_memfd_test.c     | 233 +++++++++++++++++=
++++
 tools/testing/selftests/mm/Makefile                |   3 +
 tools/testing/selftests/mm/run_vmtests.sh          |   1 +
 .../selftests/mm/shmem_memory_failure_test.c       |  98 +++++++++
 6 files changed, 344 insertions(+), 10 deletions(-)
---
base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
change-id: 20260319-memory-failure-mf-delayed-fix-rfc-v2-5ee11d6a7260

Best regards,
--=20
Lisa Wang <wyihan@google.com>


