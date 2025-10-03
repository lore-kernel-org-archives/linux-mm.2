Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFF9DCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 20:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A968E000C; Fri,  3 Oct 2025 16:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DB848E000A; Fri,  3 Oct 2025 16:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619518E000C; Fri,  3 Oct 2025 16:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 42B8C8E000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:39:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0620411B0A3
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:39:00 +0000 (UTC)
X-FDA: 83957967240.11.D19A536
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 54B2E4000B
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 20:38:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J5WhN/8/";
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759523938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=heyxGCyE3jV8ylSe959ZQw9kGfXuyrnxJnzN9QK7tY8=;
	b=xJFukkEYgZg0g915ytkXJm/GqQATIuX+tfa9jIet9PqJe5HYRdpUJ5d+z9dhqDF5EbvFzh
	GV3j2TRpyxYQ4uIXL82BGMqZxT0ZoTLW4LZ5dsrPbwN3NuBijMjDb1tL/H/Usqac0NvbjA
	IXI4tjuSJgImvbQCxB2ebbP7FBnFD6o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J5WhN/8/";
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759523938; a=rsa-sha256;
	cv=none;
	b=FC+OQyZtsd+AGQthR8d7hONxzaTqowJg7Upsuqi+7qJFFRh/g1sH1K0rWB5PaN4uXBuYz0
	wurtCEVzk1UcI+2iTgyP0AU35ER/Lg5ef6ZV/7jf1+smMLLswNK10g1a6R4ch1fwYP1VzZ
	u1CALSsce1n771YYNGtq6kuaYn9bpjw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 61D38489DB;
	Fri,  3 Oct 2025 20:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29012C4CEFA;
	Fri,  3 Oct 2025 20:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759523937;
	bh=NgT9HuawGnR8STlvRUNA5Z4q86GZ1SZe6LmbwqF2RCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5WhN/8/0/J9r/s9eimc704yu7UUGyVuANQo1hLuh6QEm1xUCf3itmIaTm9dMmk/x
	 K4DCJnrUJ/SPeFUe1tRkOJ3zKRJe7Zs9XJwduKRZPGyFM6p2ae3syfmcP5VZxJiaj+
	 VzCVZlk3QUZVyskHaD1GEzX6V+juOdDk5WQoi5rZ328Zd/firom/7VV0tB42+wmzpo
	 2qUVzVWfUuSo7JorfDCq4TQjXBeTJM9YUQBDAHGGm6e8BNgwbxzzIvqoxxTNC/uMcB
	 BEzykhLqaJl4+qFaSsuDrn8J+EiR8WuKD6ti2MiR+qPP5qeye0NwL71X1aY+GnvdMd
	 7BxpTAm2uqQzw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/4] mm/zswap: s/red-black tree/xarray/
Date: Fri,  3 Oct 2025 13:38:50 -0700
Message-Id: <20251003203851.43128-4-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251003203851.43128-1-sj@kernel.org>
References: <20251003203851.43128-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ro4axpdn4fk8hwf734garqbt15m4ugsy
X-Rspam-User: 
X-Rspamd-Queue-Id: 54B2E4000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1759523938-965716
X-HE-Meta: U2FsdGVkX18vR3NUzEDazAsVOju8m/84rUDOIfYG211+Z+B3RotphFEFB6TSAKq4SDehR+SQex4eA11o9LS/mshhJt2rOGRke7JH0r+z4tdg6SSQ7z8sUn7WUuEyEt395l+A9uyiJc4CEV9uHyerqEX7EmQ42rdIaJLBmYv2ukDNVAV6G0YqfF5APBykwsF8f3UuZxB3Qzu2GVBGztnNHrOfKoRL1yelIdOPYF6lIgQXT/ktLAX8AtZdoO5RWgymcEfEI9XofcjZ+pRgJo1d1LNpDWVDI5mZnsKrFwn/iuzzoxupFwkzT6B/cpf90W5lwI2XmSx2yEro50JUA1T+HcnsznzFnyJQobwbj8Apva/DVuXR4HrTmmnA5Jr+/sSo5JLH2DICfFSiy1Y5qAVnAIlAvo891ALfaTnpNfgfdAc6JZS6h1yledd9jbK+U/mlGe8MvsBNnp/Ys3mRs447POl3dRbLcZbMNYj15Bmp7y94rQ3UVnpTDNBBJYjMu/UYsFl0ZKPfP8/Th7p4cn/+4zOSD6c9AAl+ipP7ineY7XMLH9oQZ82fKbkpQUmaVzcIcl3kvmgY9Y4ntRO/Ytme6eOsZHKwANW1mxJ4i1iGZsFvn+ZlWyrZgx3sOEs3cRu54LIlppG/0h3v44MBoHcpFYXqD/5JpUA2vT15TXwuIICOn1xCeF++NLa0ndCaLODjpgs9iaqaCk4ntMJxg1aCYcQq3K3p45fFdRJTbqZ/H7sdwEifMq6fRQAkxktP/4weB2DQsNmlsw8eNQFZ19NDrdCARHUnGowM0c3qeVZQU/xj1747169BbpnvKFKctc560qZH//Gbzo/i1NQG1sKSJ2er0F9sE5/Bnq9Gk5b/Q56q7GUNqlWQxsdmf+Vre9tyNPjLtkjTAEHDipAP393kuKYH3WRXpWaF2CybAmYZ63MlFJ8cCvBymeqNwpiKWbPAernjZ8EdVMAAJvZHzsH
 Ac35yZjz
 0plQxxmXX1t++LPeRXyZr3pv5Oetki4yFZw92Y/7/OrFLZgDwQJKzihsR26/b/DoAKSZWhIy+Hk2werK5WvaZpGFB4T/A1lzlF9oFBTT2EtXQJhcdfzY0kYp26fgXyMwCSS2yikkAP4n/p1inYwpYlZC+RghIrTd5Egbl3WPVaX/dXXheHd1rAAg4J+nOuiTQ2RrmW9cfOCzGOnzfAouufs0CcKkvygXnnghTL1E8lSgrWlc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes made by commit 796c2c23e14e ("zswap: replace RB tree with
xarray") is not reflected on a comment.  Update the comment.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index f6b1c8832a4f..5d0f8b13a958 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -175,7 +175,7 @@ static struct shrinker *zswap_shrinker;
  * This structure contains the metadata for tracking a single compressed
  * page within zswap.
  *
- * swpentry - associated swap entry, the offset indexes into the red-black tree
+ * swpentry - associated swap entry, the offset indexes into the xarray
  * length - the length in bytes of the compressed page data.  Needed during
  *          decompression.
  * referenced - true if the entry recently entered the zswap pool. Unset by the
-- 
2.39.5

