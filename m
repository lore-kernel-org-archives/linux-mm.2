Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42138C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3C76B0093; Mon, 13 Jul 2026 03:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292EE6B0095; Mon, 13 Jul 2026 03:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D9F6B0096; Mon, 13 Jul 2026 03:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E76106B0093
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:17:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C5D693E34
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:17:35 +0000 (UTC)
X-FDA: 84982898070.27.3072C08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E612414000B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:17:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVklzPwn;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783927054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1GD0Oj81wk33gSXNYFk26bc8DHHpPqcq8HMI+cgJUQ=;
	b=s/UwkyRmEuEm/a3gxgy8TGg77BNT7vqi4dbOQI+cXwPJO/08qm9Vj4bbzK8whf0OPBoTCn
	lwTCxw+Chrxg86m3GbUuLMNWWZWkCuoNngetC0XS6Tulg6a+KDjHWdsH9Am0Q9Hx4+GyFp
	2hty10v9QmumbzFnibdHULIrF5o7Yd8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVklzPwn;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783927054;
	b=SbhNaQTf2WlaKIpHDlRA1b9NHptLjXFj/kaVECwdKxwqO3JfgJrUSpf7ze72t6qfbJJFwI
	7N+BW50rA1y6pDisK3YYjcX525zDxXOuLrmzNc/DIZgEAO4nHPzH7+w3m9bxzMo8tIjvQe
	6XidGIebNaBzF0QOqHgPOIkiQG4wxd8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4661043B11;
	Mon, 13 Jul 2026 07:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864261F00A3A;
	Mon, 13 Jul 2026 07:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783927053;
	bh=N1GD0Oj81wk33gSXNYFk26bc8DHHpPqcq8HMI+cgJUQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mVklzPwnjtBYd+N3Q1NTXm8l+G32kSV0uADFNMVZ8zoEX2vISW7RRd4d/NPd12JOh
	 DzxIKDw/Yt++8V/vrQHUfVzIi6FQ5tiWtLY0oMeG9eE25+rSnBmB6k1lqEcHp3Ko+M
	 SDTuufoH7QqmiMlseyEIUUScT72Gq+35ghE6HXuXL0Y8HPFf0//qsgaGGQ5PsrymfU
	 RkhBMQlqCLUqscttXvtCJU/wbAbnoqr29BiiAi1Q53EE56nvDVnArYJIWay2NOIyLo
	 Y5h+aMGGNZPCE5Q1kaPFlT+G2B17cd8C2zP+4/u0Q7m3D7ITJXHilhhJh96jwlzB/g
	 qT0T1CnxHBwHg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 13 Jul 2026 10:17:24 +0300
Subject: [PATCH v2 3/5] IB/mthca: mthca_reg_user_mr(): use kmalloc() to
 allocate addresses array
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-b4-rdma-v2-3-65d2a1a5180c@kernel.org>
References: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
In-Reply-To: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Stat-Signature: 5xorxebbjcsyectxuegmn8r9bbqrmtih
X-Rspamd-Queue-Id: E612414000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783927053-371291
X-HE-Meta: U2FsdGVkX1/8bPp4Ibgioa7zI4VFpQLCSaVNCRLDN8NS9FTeglxKLjzbPxnDU5+WuohDha2HA1BVz2WcOWLTQ/zGlfen3kQU4KB28ln4I6rLUJvcdJU0NoKYAu1P1WViJuKAaa7RaWp7Z6BWMWNz24jrGiYuNcokfepjVVkfF9LIfRHbEGuF02pqpI6HB9dsuSgYQk49ZeSGiO8hOiycgSd9xsMlgEI0yohn/r1whzpNAcLPcFCwYWO2CotS+opbp7bThYNw66swuDgVvUR6zWQoK/hJ547PbqOR57kgWvHQpqxz+Vqf0mU5bTEZrgo4jmxfP6+GsWzfY1vH4V725OlZaqUB78drLVt+KhL9iXzY6A+bHG7cLX4v0xIvrBN3mvy9uLgucIVWFjJoshtkOCeqdDNH8Q05JJvtA/acy4Wm7ou7VEqTshYml74Qx+EiMqjWAgkK38bxvh+r4BAII4MsrPhTAwLQMOnP31iJTW1QOWYrBMOjuuWLJGJYvhX5aVfkZOOCk8/M/5zEHsqVkj/koA0J8dAzm1B91vx3l2zbBkAcffZW1/hJiikzhH/D3bwyJMRYgSQhYlufQ/Vfs4OiYheA3ZdG3flYDnhtpAfDsBnePa0EF/Ey1b67EpGzussslJqCVLxT+oN4sHR/dDcdwjkMBsl3rtLHa9DIfTubO6FqJJPXnguMpVsISoh0dz37voMT4cXZMKMmroHrIOCMKVH1nPR8sAmlNXedCEOCDq+MmoCq2qlq4XFBF7eUs9QDISZxb9qoz5aYUDywURDHxLWTGOomFI34+nKXsgmbmjPEUdFv6VioOEBvy/+8enZO1q08XWHtAqLT4TsasnUuvOAbBUHIUH8boFkRRkFLtcGRI2hGAUOt1JhZKxZYcZDLBkkmr/GQL8lTNhCsoH32eKHIdj6h9IyYJp0JFPdXBw1JVA0rDrlhni228dizu7N7OGdE4qUP5ivtQiU
 ip/H/Bca
 TAtKyfBiholy4HAnvoB8xrC4pv4raDZ7MMlQx5PwauApFSXRFc9A4MkJo2hK0xQBz0U/8S8s3Qs9UxZpCr9lDqQ5QsgUpSSXT3m7qBe7hSskXDNh9MwAuEqZbotehxuuVJNXDqPdqO0ZSd8t21nVwssAxi2naAEvk8eG9iT8Uody+qwqXHcLmatEwL4quaL7HtZKKgqh+qUvoJ6HugoqAJuCjq80uzrPGtIjVPw6G51gQLvYBEHcE3+IGfoRHqKMNel1VxBFR/3KAIKbRWIOngU9sCTdF6RPMM2YXoZzbIJ+Ekiv1viscCYnf8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mthca_reg_user_mr() allocates an array of DMA addresses during memory
registration.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/infiniband/hw/mthca/mthca_provider.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index f90f67afc8fa..9940165781e1 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -895,7 +895,8 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto err_umem;
 	}
 
-	pages = (u64 *) __get_free_page(GFP_KERNEL);
+	/* TODO: switch to "fast and as large as possible" allocation helper */
+	pages = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!pages) {
 		err = -ENOMEM;
 		goto err_mtt;
@@ -924,7 +925,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (i)
 		err = mthca_write_mtt(dev, mr->mtt, n, pages, i);
 mtt_done:
-	free_page((unsigned long) pages);
+	kfree(pages);
 	if (err)
 		goto err_mtt;
 

-- 
2.53.0


