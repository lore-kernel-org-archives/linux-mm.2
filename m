Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76F2DC44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9D26B010C; Thu, 16 Jul 2026 10:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B2F6B010D; Thu, 16 Jul 2026 10:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771766B010F; Thu, 16 Jul 2026 10:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 494FF6B010C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:59:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 116C4160119
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:43:29 +0000 (UTC)
X-FDA: 84994756938.02.ACB6134
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 542CB4000B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:43:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eFb4A2up;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784209407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fZPKYsDRJG+4F9Azuo4iLsk6UDzXDy61m+XGdUaWSw0=;
	b=dMLzk3BN4wkOzAQ33W8V15EbMSzefBc6Hq0Xe8gHMy5KKGjdcMqecgCRF8ZQOgLYNokv+u
	RrqflxD7vz0SoqUIir/Za7rQ6lNB6740ByREkcaP8Wv2gZRZV/BgT4JVfJ4Yw9EeSnEwsr
	BDxViCyWOXas95ppVxKKu/74QCUSZN0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eFb4A2up;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784209407;
	b=C5nJBt0gp8ksN7/j/rc0EzzXGd8iCnOBu6+kUNd/Pix7mroL8i7Yc7+uB+zrWclSL/sOZj
	iQ5tInw6SYC7xQPtKVWS8rniM/Pfoavkl3BEdgVmG7ma1T26k2I3JT4AzKHdOXUJEcCzq1
	mu+ZCnvxNC185uOnSnvmk6SEsZCGvn4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF1EE6001A;
	Thu, 16 Jul 2026 13:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7EF1F00A3D;
	Thu, 16 Jul 2026 13:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784209406;
	bh=fZPKYsDRJG+4F9Azuo4iLsk6UDzXDy61m+XGdUaWSw0=;
	h=From:Subject:Date:To:Cc;
	b=eFb4A2upc+DNWmXhR/oZogBtUkYdnnGheADoFx7GNvy2bCkPj3gNkoPpWJkqkvovT
	 kduGbGrcvF0X1xPGJCaq1p+t19sjqwU8pBOwwIrrUTBwEg1v6yN/5ZQ4w+Sbu4a+jg
	 9xyx9U/1ePKcJ7z/4FZMNWcQr65BHzqcnajCnSE3NiYJ3rGqGDCRmW7qj9lH6bZOAS
	 VuSbLWtAyR5PkCiXtaavmaVsklIiqO7TCPnZREMi+/jOZDSokWiv10YzHaE/MWsq/T
	 LtC24YMzRFnX4tvAKvNZ+Alq6mDDTsEN85vwmu09FktrYSbqz96wdPw1XO8Mgq7RQv
	 oSp8g7uEkHlUQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 0/3] mm/mseal: further cleanups
Date: Thu, 16 Jul 2026 14:43:08 +0100
Message-Id: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOzfWGoC/yXMywqAIBCF4VeJWSeogWGvEi0sp5rohlMRRO+e1
 fLjcP4LGAMhQ5FcEPAgpmWOUGkCTe/mDgX5aNBSG5krIyZGN4qWzn1loTLlvLSZ9aghXtaAcfl
 yZfWb93rAZnsbcN8PJkyi3nAAAAA=
X-Change-ID: 20260716-mseal-fixups-131ad0939de2
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1186; i=ljs@kernel.org;
 h=from:subject:message-id; bh=7UI0mIFYG+mIz3byt2ODgMg+7CLGrncE3i/GKe5ys1E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIi7n+8u3lWve2EY4p11opp1pO2vXjmuE102n2RVysN2
 YOZMkSzOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRrfkM/0y6X/06zHXu8PYJ
 3O9+b469vmK7+aKtwmzPL9vNyDS69/EYI0PHFMawV46LtRt9ujY9Z/7PeS2g8bUMs9E2GYewx8/
 YcvkA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: yjtbm4yricu43ir3mda6bmm5n88hg3mq
X-Rspamd-Queue-Id: 542CB4000B
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784209407-47992
X-HE-Meta: U2FsdGVkX19rOQdmVUR9OpRuatUagjiZjeXs1+UXz5+n5alwwtOqmo+LxvD6GqKPLdKpmH3fdKebz8pjUETkLvUKZfoo7yZQPOSpYVE3nzu6RL7hPizxT2K2Cl08TjUV+O/YcMc4z8w+t9rNNXDQwzWlnZkTB5vM0tfegW/Zz0eyvlCUgwv4OY2PoN4NZMlFgDtDcOObrZcaazfDGllOI7ouVWhOj4yV9c3xAvjHP4t1+EISIdl70We8NYVUFpwUuVBzHtxPAL1CeGQEP/H/Sa0EEMdHHiQxuCla+aPbQ0mk8EpE8QjIlpwwW9j65cliIDd1/QbMxW8eyBUJpmZQfWS6NJPovWIPbtr4xFgCFmjq5oLn0fU6quJ2iuuC3pVxFtDDVD1QaowaQvHPLknFq9GOsEU0edPe0VlI5wrmMVjANGDReuI8cHiE5pKx2mhn/zNgnSWjsTkMquavEpbJ/ia8p6d0qRCpVT96Tf0jIdjV202+7j9VsNQ2qHaxBwTf3+9YN+AS2GEGGvfB/nsTkne7rTmUVamnDD5/uUshTUPjDOJpmbQZTla37Ixi4DSQ1lOXIoPjRDv2ej1OzKlekPMxjJDBMSI3pmGoT55FwA5EmJw2j7cWFB9OafoJyhGiaJ/7ViFH25LSPEIDrRExXXrbGYeWsJM+F72q/98Lb5Sb+TNtRaKtvAd2k5a/470133itCJv5p/iPJa2QJ77MRiyAljqMkty3ZmiDNd0x+XuLRdGOLIb0F6Sp9/F/oxSWAAFMf3aj8vBxs1luKtcttG2egPBU3QpPiOQNQKKxlr7Snt8mURJVzWNezsqhvP+Nrco6rCgRCL1M1B8tYWaABHCFsNLh+KeiyfMiW93/rvUMj9/zBEuHr2up4vH1OxEjYqaolQFmjUvwmFgxkFTOy1equgYI4nP87nZ/VT9K3DPc8X1ceSN8/yVEakXgrsTVpy7dXw79DU5OYfZ8/fZ
 Z4+sAqwj
 k2rCSOtCS9xmeKk0eb9EvZ90TiJNC0P5usLRdjdAbSiah2hB5a9cKLcZAp3RWYvxv8LbYNb7aK118LI4wZ2J/dnNqoXURJPzhpoFUMF1FGEOdZwNxvJhHtkiMOnCI8fpWcHjS0z8CPz6wpn4QZRDMdGjSyLkGsDkJUAGlohOdlGGYoEsoEBlkBZyJc+6g0leUhnliERaBU3/f+ROOqtuZ23aRuAYb/QrEch2qqVtqdqUDRz5iM8WJbbL47g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mseal implementation is still rather confusing, so tighten things up a
little.

The only user of do_mseal() outside of the system call is the MMAP_PAGE_ZERO
process personality - retain better control over how mseal is utilised by
providing mseal_mmap_page_zero() for this instead.

The comments are overly long and confusion, so cut them down so they're a lot
clearer.

Remove confusing mm_struct params (mseal can not be used on remote mm's) and
wrap the actual system call logic into the system call declaration.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Lorenzo Stoakes (ARM) (3):
      mm/mseal: remove superfluous comments, fix confusion around mm
      mm/mseal: limit scope of mseal address zero to address zero
      mm/mseal: remove further superfluous comments, do_mseal()

 fs/binfmt_elf.c    |   7 +--
 include/linux/mm.h |   8 +--
 mm/mseal.c         | 156 ++++++++++++++++++-----------------------------------
 3 files changed, 56 insertions(+), 115 deletions(-)
---
base-commit: 59c684a9908d2e6f7a791f7f033eae57ec2b3a61
change-id: 20260716-mseal-fixups-131ad0939de2

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


