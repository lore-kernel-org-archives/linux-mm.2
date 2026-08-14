Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F15C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 10:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F656B02FF; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409DF6B0302; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD056B0301; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E31746B02FE
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:41:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7548EA280E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:41:26 +0000 (UTC)
X-FDA: 85099533372.15.1A89EF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8ABE1C0009
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:41:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZFddGD/R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786704084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cU3ZNIpDY+b4X3iaz8Cvs+nyy49d6sug4wUSJtEsGiI=;
	b=Ajwy/xcYj1w1+0UoSXDuKVXfJ6uDWYM7Nr5A4yML8KxmVm5XIyHFtpof0fjTnljtGhFe0o
	dLtzrE1w57lp1OUj1uaZauyO+rMAbzD721Ph9XyYlTL8lF7y+EUU9GG7j/qv3Ex4VZ1hXw
	u/3bD+Pvt2HPkM+ZuP7KRXKsb8Un7tQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZFddGD/R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786704084;
	b=2B/t41rFIVCHxeNNABBXZnYZLpQbf0nCK0kkIRSD0nTm8p6ASRDIw20BFYsSBrrVOnwlT2
	9RsdeSIZZ5IqfKCjDyJIq1hgkky/uBO4u91JmQcsuy6zykkJx3q81mrG/zXMSZ1TvTvkYK
	ZoDFKI1O1LxjZERJH3hKjHTSvRviCbA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4BD04018F;
	Fri, 14 Aug 2026 10:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8CA67C2BCB3;
	Fri, 14 Aug 2026 10:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786704083;
	bh=VImGdtbQhVpxolptJjq7ucid3bvJX7n+SBXE+EDTI6I=;
	h=From:Subject:Date:To:Cc:From;
	b=ZFddGD/Rs90lVEEZWzFu20eMDuYEjDnodMuWcqXrF0M6euyPtxR0BcMOZTEkT1qSg
	 5lCZeQvfZLHpT5Tg9+YYojjbC4lizqStnnNPaDZJMmJ2Vdq3fxpMab1CT89Xwy4YeW
	 TRjpOmn9EnkR1lUio48N51w2Lg+AlgJnZvZQWpgqKZaKS0cKji4wR6tSdj8yux60aR
	 SKCwrcMwT6cRFf6k99zKWn24s0gT0VKqH4vWdJardEiKBW3nqxCckNHVII2lhvfLhz
	 z+aeyL4l0l5Gb0aVHO1ylkz8GXBAGyLjeFSzaC23BktGZitNsW1YpyZdEHxA64rZUV
	 uqg6yR4cvjTXA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799C8C5CFDB;
	Fri, 14 Aug 2026 10:41:23 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Subject: [PATCH v2 0/4] sysctl: Disallow partial updates of miss-formatted
 sysctl vectors
Date: Fri, 14 Aug 2026 12:41:11 +0200
Message-Id: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMfwfmoC/32NQQ6CMBBFr0JmbU0LQtGV9zDElHaACRXIlDQaw
 t2tHMDle8l/f4OATBjglm3AGCnQPCXITxnYwUw9CnKJIZd5JWtVCD/6l1gMr2T8064+ohWtq+t
 Kt1q60kJaLowdvY/qo0k8UFhn/hwnUf3s/15UQgrXXbFUVhVaXu4j8oT+PHMPzb7vX/lcKly3A
 AAA
X-Change-ID: 20260813-lklm-partial_ctlvec-bd8867b70d5c
To: Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Jianlin Shi <shijianlin11@foxmail.com>, akpm@linux-foundation.org, 
 vbabka@kernel.org, hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com, 
 jackmanb@google.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2346;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=VImGdtbQhVpxolptJjq7ucid3bvJX7n+SBXE+EDTI6I=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGp+8M9/63kdDlD1fFzjnvUMsa3BnyokcX0Mn
 YEESFUZ+6VyCIkBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJqfvDPAAoJELqXzVK3
 lkFPX4gMAItfGWXct2+B8L4J8D1LbaCtRErVfSZzNrw+UZZyeZNt9JD07OYY9rsCAbsAFl9WfUZ
 h5bHqfGZYsTC3CqgEuMBBWzNfjbfbY8tRsSDYbAjhtuRa12ARpdCY1foDgI9LQVRFobA6pdfM2g
 5G3VdUH2cxloE2AINCYY5ntOz/JXI3vgTm7IY23HTYa6PbmfGxsGHG9oy5da6OY1YwuW7a6z8ST
 xJ/AGN/QeY1GZ7hxRjuRHB4G5sTtg8O1OD076hVqFuCPZu9/Y8g2mY1VtRCU3fLyw7hi45EW9N7
 TH8rO95bdxPKc4ZFYgvSlxN1H/zUJaALtIPzNRY5p1aVJkFMnvBo2WEC9M+Dk/EmhUCO77e1Dtv
 Pm08FU81/mg3v9Ax1i+7Jml6gtooXzQh67tuAlSzC4cGc9X5Ved8Zx+Q3rgDckoEMJbYAJtUfTH
 VFqkdgnK8WsG2rXGpQEV8u07ehdfBzL+0gicCr48XZaL6I4OZ2XjVJxSrEKBRgz1rZp0LdRBin7
 DU=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239
X-Rspam-User: 
X-Stat-Signature: zsydqim796gw9h4keies1m5no3xnyhje
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8ABE1C0009
X-HE-Tag: 1786704084-491389
X-HE-Meta: U2FsdGVkX18XcbjIJ2dKDYpC96WtSJxKRthDplE/fZG5195eqPq1XaT9QnZQy5/tnXnwFhvgtixESBlOiSDYo+BdDjzEA3gI7Fia0qmwpIVZF8sp08hZ3HKeGu3ehuO3so9kVBlOGeZfoirK7gaEFte9OdB9y2DzdU5u47TfXjFZHVeqWL6msjE5DHyWFA/eI1VC4J/e3HstwhPO4s86heipEnotqXD6v5qkYluX4a9CM2ga5pFvtlEHL8XrzhQ0TZvS5JDDRcKMsglFzOzdoNVig5bw18ombm/hANhXjQWgh86cF/qnY+IhkLhzcPjI/pOhDyAu/Lc9Pv/IWvkJ+C8vsLTHyv+FFHFn+IFxV8/FgO2wRSMxPyxknw9PhM6k3j5daKDcmphhGaSNz1vqrQl+QjD7SbACC4d5Uqy6f/Prir+4oh4SKOTgPC5mN0t9eC8gjIUKUfnJc/uSMYGbFPjnxekC23PG+DeGBNDgXBXTOjvROxfICg59jKhacHjvV1LFqYIaTXYbYLc+sjFUi6DiqYMAOKk64Gl3+J4K+0/3vysXVqEGMqUKX6OPoTIL0PJaCh2MkkNbgBB5CSgU0A6HZziXClPYg29G50/nSEOiXYM7JLl9rZc9QJe8guTcThQB7yV92HWrpBeBbTUSD+Gk75+YYHqBaRQEQRrxMsuqGLpmlYscUPBH6YN5GNrGzoKBHb+l0zgRkhC3Gr/GnaL4zfsTi9OY517iMJBmRcOOpqtATUhpUldK0BKeg/QEcTFZqJeYh3XPlojwkDUMcqsfJdlU9382ifMhTT5QpcHR2xJMApqlyu/4A+ohvo4JFQYdUDtiN1RDYvSqG2Zejvnpr3TINXXC6izNdPxJun9XD0MY7LzK8tw/g0kNeAoht1el8besD0kHLZgkRYIkkmsolXbTFJ5YwvyHowfEEQ/nEHgcoe1HTCJyw5BXMd7uSgsIrhZ9W0P/QxSrVOi
 9zrqckCu
 vGkHeY4t3yq5yDDgLoGRHUli3Q5Ad8C6EhAEHGPFdaf5gKZXLteh4qeDMv/Dbti1AUg7xQ/yzzZW/GfOSFu2pLMJMvNwcrShMXkPp5DeN45c4ZKV7QXRjV3f01532mPSbD/Np48+986suFw3cpUw0J8YEJDrawwoz9nbuU70hi5LhigVE0YvS31v6fZ6iHG0QXVAiXNkNciI2ttptbA7qEP/m7jpejsKku7ZX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

What?
=====

Stage table->data when writing INT & ULONG ctl_tables. Commit staged
data to kernel variable only when all the conversions have succeeded.
This is applicable only to variables that represent a vector; paths
pertaining to scalers are left unchanged. Notice that partial updates
can still happen if less than the size of the vector are passed and
correctly formatted.

This is the behavior we are protecting against:

  # echo "4 4 1 7" > /proc/sys/kernel/printk
  # echo "1 x" > /proc/sys/kernel/printk
  -bash: echo: write error: Invalid argument
  # cat /proc/sys/kernel/printk
  1 4 1 7    <- the write failed, the first element changed anyway

Why?
====
Allowing a partial change to a vector after returning from an erroneous
proc_handler is just plain wrong. This should be handled within sysctl
to avoid users having to do it for themselves [1]. 

Behavioral Changes
==================
1. A failed write will not update the vector
2. Vector writes can now fail with -ENOMEM

Testing
=======
This went through regular sysctl kunit and self test. Also is posted to
0-day.

I always find it difficult to know who wants to receive this. Please let
me know if you want to be removed from the Cc/To.

Best

[1] https://lore.kernel.org/all/tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com/

Signed-off-by: Joel Granados <joel.granados@kernel.org>
---
Changes in v2:
- Avoid doc compilation warnings related to apply_conv_on_vec function
- Initialize rc in testing to avoid a false positive when executing 0013
  individually
- Link to v1: https://lore.kernel.org/r/20260813-lklm-partial_ctlvec-v1-0-df9e51c13704@kernel.org

---
Joel Granados (4):
      sysctl: Split data conversion and file position handling
      sysctl: Reject uint arrays before calling the general proc_vec
      sysctl: Disallow partial updates for erroneous sysctl vectors
      sysctl: Add 0013 to test partially updated vectors

 kernel/sysctl.c                          | 237 ++++++++++++++++++++-----------
 tools/testing/selftests/sysctl/sysctl.sh |  60 ++++++++
 2 files changed, 217 insertions(+), 80 deletions(-)
---
base-commit: 4c12287001da60f3c022bb25932aa7a5590fc0b1
change-id: 20260813-lklm-partial_ctlvec-bd8867b70d5c

Best regards,
-- 
Joel Granados <joel.granados@kernel.org>



