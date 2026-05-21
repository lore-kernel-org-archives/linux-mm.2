Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8BAECD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EBBB6B00C9; Thu, 21 May 2026 10:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326A56B00CE; Thu, 21 May 2026 10:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD626B00CB; Thu, 21 May 2026 10:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2A896B00CC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A564F8BFA9
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:44 +0000 (UTC)
X-FDA: 84791673288.14.37E84BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 15FC0180013
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mbr7hz7Y;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Q+fxjZuCnosHblIbwlECkpSubPFTTaxfUpkwZ9ZxQM=;
	b=Cbvqgl+xv6dz2JhbjeLQD9KaFm+ugBYgdOGjJ+eUVRITDnSD19c0v36SKYb/PgoxoA0Lyk
	A/Jm9KogRw0DHMXa+5I5pQUapNaWCtOb6xiK7BHI6vQPYSQhQRlB8AqJv7tbsWwwGWUml+
	kN8Lfza8KipkXHjJqrL33DduITvRwmI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mbr7hz7Y;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374083; a=rsa-sha256;
	cv=none;
	b=c+TWHR2EqoUd/t0r81sF439n45OWy23a9Jqblmk0bx56eESJw/eIdZRU+dx/twVlzcfCcs
	E700D7UprcsJ49CwtmMIo7wSDoGviwKrZrWn32a27J1joh8PYuLnlKbJQj/tAoeIhY28Ro
	usvF16McWJxrSox3/EaWkuQFWhQ8Mgc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B81376021D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F651F000E9;
	Thu, 21 May 2026 14:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374082;
	bh=9Q+fxjZuCnosHblIbwlECkpSubPFTTaxfUpkwZ9ZxQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mbr7hz7YcemYHIxCvxgFidxLPabBO8v8iCe2Dre4oypmwg0kxT1enQSSazfXttV+8
	 kH291s3wRJ/bUNnbBxFDOgs5/VqudtNmebjbmVGul6KwPy0MFk4wSHIlrzkcwkJU4j
	 hQuGQZOihSsTDTCx/PLg2TR/X25Iu3R8EQs+SMmPO43r1yKs3bKrXyVxyyMnczfKfc
	 MEjJftNjgf0el7HBkoLOsyrwLb1nSPYJExJYuqGqEgfD5KQkxdeE/FyBlqZrIo1Y69
	 AUVD/EYmd26qTTVQQwD2ME1FipFvS+ogR6EKmXCNRuvC26jsEryDCOqW1OIwfq7HYQ
	 ArXeLXg9YDuTw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 14/14] selftests/damon/sysfs.sh: test pause file existence
Date: Thu, 21 May 2026 07:34:24 -0700
Message-ID: <20260521143428.83157-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 15FC0180013
X-Stat-Signature: 5bxub9yxg4frna9ydwk4r1esysuk88g8
X-HE-Tag: 1779374082-478949
X-HE-Meta: U2FsdGVkX1/DLkmcf2ccnd6vAcWS3BLbW2Y66KD5ib7QzitQpLrDiBl/+HcJarACdFnaHmpc5U+wGvVL8YXXKsxAt1m4oSNH31l9LFu6eMk+e8STH2IXxzHD3Czd7J/pFU2soE2mZu3m/XGY/uX5IUuig9MtK4ThNocK0D3/H7JaxOj6ADqpfku5t0gODXpWjM6A4ioxuaOFzbmXmnwbER5umjlucEv9ipLbFxcw9OlQjJq3Ic4dFbo5RZ4wO99KT9XG1i1Z3p67ulR/1gk62sQFmoV6C0orn3nFyEBHJuIS3ggNHxadCRTku2r1GnSdAa2vJQ226Ccdb6Y1DUq3e1nnyoiDB+alZG0focVb/nHZcOaY9ZSrjEyo0WXsDbp48O+jxzvaCUhIWLi2Y9Sg9OtfEg2oQvXjM6JTEbhs8B4SBHgUaPj4iDBoUye6w3nRfLIhLew9+QHNFNqPbJuX8HUU+pwQnAyjJYlvTgSUtLIBB00cMm7eH023T1XZlDtW5X9PBe3b6pZRjdwQ263kJ9ZLuZnzslIl3lpkVAqaBel/G5nZuLPgDdFXod5WnKG9HnIeaviWaf9A6gAZmK4wfbXZgbyUbpifhTrdalnofvUBUQPXVcChqdrsB+L+r6vjuV9+LcaBLCHqczoFeBdkiLTg02mByuSzF2f1HXDqJStI2jwrck9Z2UHTVurCWBppKpccPCbWhJCwsldXmnxBwPPBE/eKar1pf6d5GLudLYDPavBYpMlZi5PK4SGMXKbdPgIOj9U4G2RuAT9NQZUhu/ZaQDquU6wwWqI50f7yMxa0abgnw6A3YEjUEeIqij4hyIjWKMGlWh4Lw166BF2Rs0/rwRrfdO9S7qkFgca2jxslZr6MwuyrV4pLel2Vt5HzklLTqrHXlrjfB0lh4iNMir0Jc/VogMmT1j4mHleMAbE8VTZtJTK8qRc92cjggdTLGm94EynB9SSnQbhtegN
 oQCIISHL
 53DoKwXrpVnLLarMuvu6A2zW+8qutyKDGDNgzxGX9pSxJuJa7MkpLxuHgZ8i4sM4R6bsuaEG7mw+gKbBweiNknvMVAClA/4BD9YHy/z33rDn85dMo8ynNjyaxF/BM2ud6hC4Jbic1L7TjYqIGntrcRmgpDAHhyjteIrkXK+Jf8+zgY6/S/KBypfY2wlvNEfDzMiRuePyUQUfSXSIoxtfaCksFcjLv7Gu0ht9YxiBJsZicp3MGH18rqgDtYNp4LfhHElP/BqtqFsBaxKRsRVbvzigc6mgYCff9Vl9XQDRXlKcFUzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sysfs.sh DAMON selftest is not testing the existence of the 'pause'
sysfs file.  Add the test.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 92b44c86818af..78f4badb5bebb 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -366,6 +366,7 @@ test_context()
 	ensure_file "$context_dir/avail_operations" "exit" 400
 	ensure_file "$context_dir/operations" "exist" 600
 	ensure_file "$context_dir/addr_unit" "exist" 600
+	ensure_file "$context_dir/pause" "exist" 600
 	test_monitoring_attrs "$context_dir/monitoring_attrs"
 	test_targets "$context_dir/targets"
 	test_schemes "$context_dir/schemes"
-- 
2.47.3

