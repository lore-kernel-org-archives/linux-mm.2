Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E69606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O0mKHdSO
Received: by kanga.kvack.org (Postfix)
	id 2986A6B05B8; Mon, 23 Nov 2026 10:13:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2220D6B05C5; Mon, 23 Nov 2026 10:13:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E4F6B05B8; Mon, 23 Nov 2026 10:13:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDF7F6B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:13:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66708C0914
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:24 +0000 (UTC)
X-FDA: 85466727528.19.0477802
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C27E22000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O0mKHdSO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446802;
	b=UdK2vpJzMrRp4CAhsoDm+xUDDwr/Dr08LP2EEGQUbntUQGoiXH6xJhTI5R1NDk97FLkwAP
	8/Wblf0VrxLIu59hVsw7/4c2qkyOfBUdisEG17YkjPMm0ItaAQQJs1udyHkJ5se3WOTFbZ
	zVt6uaaB1q1HmGbktuUzZErctPwvmGw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mv1jTJ/CU74ohK3c9rLtY3Z7CGxLG5rZTuHNMWr+L44=;
	b=YrodXhHpH94iU5cby6M/wj9M0+Z9/CAUTcYaoN9gQ/b+qJbGT+HQWNqM3O04yo21TBpN3l
	GymuUx1hzyaOjX3ltWjsrUqIz2zVyuGNJ+d+b2OIc6SrGKWn4/trefgrzCNeSxT0nit4BR
	kcNjz0bUTkTaupgvkQtpnQGuKiBq5Co=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O0mKHdSO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 242F1455F6;
	Mon, 23 Nov 2026 15:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0FE1F000E1;
	Mon, 23 Nov 2026 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446801;
	bh=Mv1jTJ/CU74ohK3c9rLtY3Z7CGxLG5rZTuHNMWr+L44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0mKHdSOa+Rf49S8071hoHr2ZSrIchkChN8nzXK84k+SIYLqUoS/jLcLfbK6jdIsE
	 6eFE0Q0c9g/Y9bHFbj3D0HNYKL2eZAlXkTMFyNzaVFhkGYKI2ofgPESdgH+dFB/Y29
	 qG0WqDAwAa7VYy6k462SEGltprQCen4hvNGv7WFfBGLLEiqcbTGXLA4hmYV9qsCDH4
	 bgldDcKQUn3GdQRiFPyN7hNo/qfK0h+lkoXhIi/+oeNiCIkC8yJ6xaJnQpxjjEuRmu
	 7zsVgTjGsu476VR86opZhiQKVPX+8/PX/aGARoS+7XQo5xvyKUFHHw4n1haaXlgdDU
	 DV6fEJ0+FdLwg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mattathias Pinchover <mattathias.pinchover@uber.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH v3 6/6] Docs/ABI/damon: update for sz_ops_filter_passed_last
Date: Mon, 23 Nov 2026 07:13:07 -0800
Message-ID: <20261123151309.82675-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123151309.82675-1-sj@kernel.org>
References: <20261123151309.82675-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C27E22000D
X-Stat-Signature: scxe6churkzj1chpgfhb49ggd1ty7n1q
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795446802-894468
X-HE-Meta: U2FsdGVkX19rREhXkoJUptxZqtP5hjOcxA+zDBARZ1i6e7oo5vWvCLbfy+GsyKDPDSM36kHAiUB9RFZXQ/ZKN2XjDQyk4HLFQ4WPveAvIlvf187qvqcK4hSpogOrrf0v9579kA/efwRt5cQMkeIg2dChfp/zsbcwDXFkEIutZFh9p9cva/ziy+QcihTwikWog1k+qAQ0sOV14CNEYiOHqdRHGuym73FHhgQtHjBSnnAfjZKZygwXnvFmMwRKNy7c0WDEDupDh2tpmyuVwXM4zj/f3+zWJRg4nMRMBH4Q65RyAV0hYb1igm/AWOUp6tV+jp3wzTekEAoc7mANk5YXnUEg+MzIcgMfClumXv/w/z4wLM1QPhADMVuXMvzMj0RB1NNxe4R1bIyE//xZfYTaZjhMu3a7SIv21d2llsWxLpmORHVIpoh0rWACcY5fL/YkWKHv7lKogiFWTL0r0/B5GRoaINW9ckFVr7dckCX+cmg6H1ODNS86mgkBE2/D6MdUgkkG2xkd0Ij7nNjfWVQsfwBQt3RJ8xgcFPaB1Fztr5LOQXKRMqtgtr0D1saEpqp1iKMI+khnhK14Ypn4DLwGEJGEqaqZIsS+HC6rqDPEDYKYzq2tik1zZDI6V3cjnz0bLHiQWlAo9lCO4u8vR2mvMfNuk15nes33DUps1agSm0F63yQrB/uinXc6R9WCnW6tvEurZFHZMqsqNYVA1KOkeEgby4nX3qCsyQz74bZB9tlSLpKJf8Q5ewCnnEcEZb9WULZFF8bwfEwG89fzVnU89zyCizBbyankqAB+EyTRQoBQsmOACrqWKGrPh+LWXg+6sF42Bj5ajWlfdarbvfiAoCCdBFEsHggw9TViq3JxXT2eb7l9tPzL9ZQEyhN7RDF3cu8lqufk7X/IDMP7MqPTajAcjv6il6hyzNvtJ2wBr8zQADtbGbbrbpynsL9xmYPZK2kbM95HWnvhLmh5WCL
 +lTTp2l5
 bTZ2dlaw3ZWG5rkobHce0eP8W8H3L5jZcGpw/eNTE9w9/ww9oNnBGjTZA6isvQXiPLnPHPCvK7bPGepdLtzBI2X7G3ANWYyTukuZfPWV+SU2EUKihboexGOoSq/8K8nRjvB36kF8xC9ggV6vYXfJGae0wYo/eHA4eIRoi/369dODNm4x5PRt695Rxy+m/o4M7Qb+Agn/bMDpow+Vs5JOyRrUfNR05Zfr0ViC66IT5/jro49CSADZqsurnTg/fjoOfRvLdywEZq9lSpW42pAvopGsCJgLYRNfPU4nVN457A+vi0n1lEEVfUoNg0kT+nTEnVeOTFCy8xfvOvD66BgSVcGATGzwT7X0jyg9VPZpYeiAfKBc0tG+nLI2nWAFNgSCmq8eqvlfPEOGIRGt+Y+2MX8wj0CtvvCHoR51Y8+ERHoFrrGsYiV7ivg5mc+Ra0UXRNVHj0yhnTXy2f9vdPJgBpqK3EeiBdrTpG+83YAXn5a8o48y25oLKorN1E8ykbVXn69/sHyd/WQC2aqMNz2/t5QYJ7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

Update DAMON ABI document for the newly added DAMOS stat file,
sz_ops_filter_passed_last.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 4acb2015c2f4f..92348178e48a0 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -623,6 +623,13 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the total size of memory that passed
 		DAMON operations layer-handled filters of the scheme in bytes.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/sz_ops_filter_passed_last
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Reading this file returns the size of memory that passed DAMON
+		operations layer-handled filters of the scheme in bytes, in the
+		last apply interval of the scheme.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/qt_exceeds
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

