Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8E79606A33B
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftx4v6cB
Received: by kanga.kvack.org (Postfix)
	id 01A836B05B9; Wed, 28 Oct 2026 10:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C686B05B7; Wed, 28 Oct 2026 10:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21D76B05B8; Wed, 28 Oct 2026 10:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C72136B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:12:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B2C0140415
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:12:00 +0000 (UTC)
X-FDA: 85372224000.29.790A807
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8299420003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:11:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftx4v6cB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793196718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DBAwupr574cqsrPW8LZMhh/I92Jfido+74PsyFCXFnU=;
	b=Z/7nYSYflliSfzoPun3fWe12HOyeOeOllv5n+Li3X5ezQT1PgiSP32rsDwoneauhEkzXy4
	DDMqKSuNGPQOYW/L6aD1tDoafyf/7pzQfLOYQgQ13DoRdavGyhbAjk63AnVbPQD/TLJ6NK
	Pu/QDJpR2gwDK8kYzO1FIFn+u0WIetc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftx4v6cB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793196718;
	b=qI8pJVl3mrx5m5YHo2BXuDr+If8y8RSU8lEyrUwG95hEksvhx4FIBqB942mceDUoWc1v6l
	pis5t8631LY9N8YzXjiVh3hWyQCXyS/nEcDgdp6PjzQSrXQPAn9RSyH5Knf4YqDXgp02n8
	IGvBInVkxqR99nOL26BzyZArYsDO7V4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A01BC4049D;
	Wed, 28 Oct 2026 14:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569361F031E8;
	Wed, 28 Oct 2026 14:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793196717;
	bh=DBAwupr574cqsrPW8LZMhh/I92Jfido+74PsyFCXFnU=;
	h=From:To:Cc:Subject:Date;
	b=ftx4v6cBTQ46AqtV5OsXjBLzK2VZEfSGpWSzh7CkWjresyhm7DwBOHHRqgUhqClrt
	 cpoP1kXSBgT9E2TVC/mm9xrJQ0JCIxsQeHrHRohqt+ZgK5Or5CBCR9tBmZViDEEBN7
	 dzaWEbFQt0wGylL0iQI8tJzABrTGD8pOtUq3SlSpE7i0ED6wYN6Y36krgehar4eY2b
	 X2PTMBtxH3RhpGtV2s5u2HMmSWCNZ3Mk684Gq2dH8zuCitzzKYXfbxQLiRIrYC+VgZ
	 HuZ+2FgJZpQuYo0lPJKW4GcUXdHAMBMaeGF01PT0nKY9CtRkgITpdHJWimRzHVj5Pk
	 ToRQwPwkClIwA==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.12.y 0/2] mm/damon/sysfs: fix pid leaks from wrong error handlings
Date: Wed, 28 Oct 2026 07:11:47 -0700
Message-ID: <20261028141150.160711-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8299420003
X-Stat-Signature: rid8mbp1os651wu5zpdrzsd4hpxa3uza
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793196718-912760
X-HE-Meta: U2FsdGVkX18dwHw5xVPiAw4T3ukS4w13bK9OB8aFTrFjadlqU8tDX1Hyh2cLaarG2bEI4fEHTcg5tiKANmqWr2VHeDcRdQ71fA16vFIFE5aQKtuAYpcm5CNtx4Sx4BJXtdqSJDGeLQzC4HoiAK6u1YbWvA9kxvw5OOREsWEbytuYQKaKbx3QqwCqjJTeb6f+eTnEV4+N2WBcU8Yo28+VA6yRR+VG23pk+JDAdw9afPMv+/XtZNZHyYqeHwuIZU4bB1tx/Sn00ylmj57Rxe+jmTUrVPnHqGDKntPvpNrcWRTzvQjZZT5ykW30xEh/VHQGXHVaLMHnnVt0agwjacgLWBgGBPuleLCC6AA4kvNyjBVWKgi+1H/TXZbo3yHhwRhy6HN3Y5SzdyMAoibahEgYZvEjUdh/TV5ug1QvQTXRi2f4ThxqqRS9TGxFgsY8Reeze97BnB031WUM6ygYtNQiYuxVOkKtMzbcJ3v4TxlzfjoMm15K7BQjwqvvJVP1PCdTc5/4EqfvNv90Ap7Wdj7M1GCiFsiWQdRU6DEcKtunwM5smYcFJWoopnBnVT3F6dyc4S/lnTJmC9FFPpmsE0EHQwAA9FxeKPi3C07UCl9UHoThXBsFnXXhfil+zq5PrhPf2EzoDtixI0VIpACAB9Kp8b4XBKBnzbFju/vRlG+Q4iMlx0qu3xyNXiuIao2G9qJK5CW5OAFdh7Jyw1r7a3N+XnAf/G2R+y/Gts7IIDB8hU4DW4x+D0U2fw6XZ0Ho8mLjfKQ9IKXf/h3O33ifxlsKC+erCCR9uZLRczb6fLZkmtxNwszUipPDVCaD+0173kYeRLx5Z2pZG53zd0/9p/oU8irZ9jDkzBcjNQ0dP/YA3B3relOKZc86f4ZcCyxV10KRpAP5n5VPNjlIpOY6+f1SgCO9VUrG218A/aEoSLNshCcEorYUmA8C5gdF3Jh9CGU9IXJe9ZSlB6T3N+/fQqs
 dFQ4N1xn
 o86Gld03h8n2SOqYEcJc/+IZpa4jWHpYSN8qVzB9yz19hAllJK+GUA2Bg3eSG545R9GKmP+o35t2WD+noZA8P6ci3R5oxwG5M18cM+Po1ovQTQL5wEvRbG2l3qAGfSJA/XwUS0mRom0CFWO1EoitILwCwRCm9fhHQPT7u5ssL7Wn8GUzKPmnCpsOCTwcFAogg/0Z9LYjS/lyrIqtgBzkomfoWxKubDkB3a+UfZaBbBAzInR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON sysfs interface can leak pids due to wrong error handlings.  The
issue in the mainline has been fixed with code refactoring.  The
refactoring is done with commits including 7114bc5e01cf ("mm/damon/core:
add cleanup_target() ops callback").   Porting all the refactoring
changes to old stable kernels will be challenging.  Hence submitting
this non-mainline hotfix series.

Changes from RFC
- RFC: https://lore.kernel.org/20261028042617.165657-1-sj@kernel.org
- Drop RFC tag.

SJ Park (2):
  mm/damon/sysfs: put target pids for damon_start() failure
  mm/damon/sysfs: put target pids for apply_inputs() failure

 mm/damon/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)


base-commit: 355214ae5d8da08854c5749cc79b688e4ff265f7
-- 
2.47.3

