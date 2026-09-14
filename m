Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F87FC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDF446B009F; Mon, 14 Sep 2026 10:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90916B00A7; Mon, 14 Sep 2026 10:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57A96B00A9; Mon, 14 Sep 2026 10:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79DD96B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:23:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E331912010E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:38 +0000 (UTC)
X-FDA: 85212586116.27.64CD295
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5B53F1A0008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HYWk1xvQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOENOCXANQ196Y7IaHjgPhFv7InBS8bgPr0HQuFZGX8=;
	b=uCLpc49PESlOGPXhQvtjmDaRasTKj8VX4T1k8h0EKT8oeJ6ktgTa36QGtsiDphCt/oybN/
	NT6sSQ16KdFyDea7FwT1AWeKTmN54lEt8u2VmIQ1zVq8Eiu05xlw6KFXcQ7coMPHL+NZ77
	WVuUgljPJfQPechPvt3v+cCZg/8p6Iw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395817;
	b=UOhPYc/ndcXNLWWRJh1ujWQcAvIDoHuj6aRTnX7K9SfU7dXJrxA70YJ3lKn2ocaLpA0Phv
	FPIQcm1TZwNOhbbkkuLWeAI1ZGwIECoVVPL/qSPPubAlnQ9n8pnuHUogqzEeb/RbK37/3c
	SEWIlK1otqJOK+vIssNJ3EYVvS4yszQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HYWk1xvQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E9E7B601FF;
	Mon, 14 Sep 2026 14:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1491F0089B;
	Mon, 14 Sep 2026 14:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395816;
	bh=tOENOCXANQ196Y7IaHjgPhFv7InBS8bgPr0HQuFZGX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYWk1xvQvcnIFbcqa1C2fX/oWjgZSWbJNNKHPp9pfOqUYW9Tg03tBeuu9CB0MbJN/
	 NVu5hrHYgov25H63p6g/kJgZlwWsOW7gs0xSUoR3Yg6rtcc0cEPnMtSEu82t6gC0KI
	 e8zJwDwcokla7atG2zK26UOFknEar+FtGCd9VVAZU+5P6cOzvIbPJ9+zYgk4DO9hgP
	 4DD+nrmHxsQ4jZszS6nqIRvKpxbtKvsXnMd2hr/ntC7GhQlhjSwTmCrf99DeDgTBuo
	 YDyq02dxv1QeTr6e9hhLiyxeL8H+y08wGFyCW13RBN+PD652Or5eaUbI5s9QvQPD9I
	 8AgCTjfVLzUkQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/8] mm/damon/core: disallow max < min damos filter range arguments commit
Date: Mon, 14 Sep 2026 07:23:21 -0700
Message-ID: <20260914142327.92510-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914142327.92510-1-sj@kernel.org>
References: <20260914142327.92510-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5B53F1A0008
X-Stat-Signature: d7k64cq98fnkjgfwzduwb5fezn1o583m
X-HE-Tag: 1789395817-310555
X-HE-Meta: U2FsdGVkX18vRBcRNXHA3iNZP+3fIfP5eSX8JDdkBxpFuVchOm0+8+o6q+biNXPaToA0POUssyQnaIACz0t+KxUY4VDF7J1yqC1GJ39WW+VFBvSS0Tsx8/1fItV8xdBPdWVcBtwHFOr+mIe9J09BOx8I8R60uv3hhe+Nlli8Zv3+1H8pZfUBDz5vIvcQXrhwu173XJNEe2hVxAm6DsswF1eDUZIve+KZvkmD78URV5Ycqe9VJPe/ataE3InUrxRNrxw2E1OOWCtZoSoxthq4UBvxSbVg+WQrC31GBKU62wWDSfvuMXK6uZrIdHYmfSqOf8CjiwUfPZ7bKNIHIy5cehKmXbaLBc/elqjzDHgW08S2pHFmtu1p1F0ieaTYs8/k7OY8+hqj2qqFWmhk9BhysB5IFVxPnamE8VJFLcxiMkBF79yZ7TVOi0oA0JNdSZDpCnuXWlBCppEET9cnn1lgAlj9DykL5hxPdEzjU1cagnSPO+gifoCKXSc5tjWwPy23rSeaIDotOrHhQXum2KcKuVy+LeeVrVDW4R7gnKp0se/Z6CGU0xAttKzBYNaQ7NO1xErE4iCxQMineR0dIwYPITxVSk7QnB6jpGESa5l5/UjA13+vFFmjTR1UcvtyXSJaxdCIf8V59Cny3Ay6Z63m1M8erZFQaHvt++o9kIBO9+onQ0m0AG4ZvEh0BUKyWc4KAUnOzFOeSkiBW9crs6c5R2FEuFpubz+r8OgOo3Qt70jEjo6p0Yfn945Y+8tj4As4av1kpnFaeQEowpG2xZBfja1bCKJFpfsepCBBKDH3Jf6ha5+4HahIoMx9ogwS9RqnSPivBwBXlbOi7diwzxsD6V8hVrrxMODdSmq/aVY66ko2APEh1IFM6DEeNdEVUkQzviemMekQb7/yu6FLVIH8AH0YpBOwVGfTM9i802aYSCT7ycJbyIFcaYiqJSF5jVulhd0VV43p3B0Rnc+ff42
 LccsoAHI
 waidld/vsf8ZykxKglqXcIulRDElAPZp8YxnfR+rGNtBE7DaX7XCdc+DhyqMoplbQIFttTM6rzwn+sqioHzPi9at0L/lXnvC/J79Z04GXN7snrCr5uv5IcHW21dX6DB8OpxnUw83OcQIFwW179KYcYKo5hoI2zlR9vwsU6FyxN5Zu9S5WeopE+tFg8quymfaHMyaN9uyj5ItParqPQRzdO0FJqdbuNCTIPvU4ZGL/6w/o0is=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_filter_arg() receives range arguments for a few types of
DAMOS filters.  It allows any range including max < min range.  It is
fine for the logic, but makes no sense to support it.  Actually DAMON
sysfs interface is doing the validation on its own.  To avoid duplicated
validations in multiple DAMON API callers, it would be better to do the
validation in the core layer.  Add a validation of the given range.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 94ea63084a24d..e0414d2adcb41 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1325,15 +1325,21 @@ static int damos_commit_filter_arg(
 		dst->memcg_id = src->memcg_id;
 		break;
 	case DAMOS_FILTER_TYPE_ADDR:
+		if (src->addr_range.end < src->addr_range.start)
+			return -EINVAL;
 		dst->addr_range = src->addr_range;
 		break;
 	case DAMOS_FILTER_TYPE_TARGET:
 		dst->target_idx = src->target_idx;
 		break;
 	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
+		if (src->sz_range.max < src->sz_range.min)
+			return -EINVAL;
 		dst->sz_range = src->sz_range;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		if (src->range_max < src->range_min)
+			return -EINVAL;
 		dst->range_min = src->range_min;
 		dst->range_max = src->range_max;
 		break;
-- 
2.47.3

