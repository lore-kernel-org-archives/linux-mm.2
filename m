Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8504606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 04:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MphBLX/k
Received: by kanga.kvack.org (Postfix)
	id ECA726B05E7; Mon, 23 Nov 2026 23:41:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79A06B05E9; Mon, 23 Nov 2026 23:41:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8FDE6B05EA; Mon, 23 Nov 2026 23:41:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7BA56B05E7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:41:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 09A43A82A4
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:41:20 +0000 (UTC)
X-FDA: 85468763520.18.66A0B87
Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5F16A40003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:41:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="MphBLX/k";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795495278;
	b=YQ6+bc4WG8Qp85fl1dKStGeKsMvHHxyPbc9bf5dmSJ1exkSzEEjMyiLgw2htg6pAVvYj7h
	GB9WrlwhiedfeD16nsGQyRwKI/F2fyfeCvQiUCX7X5MNsQSOcLwg9psELKc4VteKmL089p
	xRj+/nZDNFQ8FnH1Dy51Pi5vezEjNdU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795495278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CKWgdwMEZ/BK3C1IIrQQ4oozU1IHhGkVZGy1zDX8PzQ=;
	b=WrOqnzel6a1tARAWvxh6cWAED/v/NrIp4K8RMJsliWbw2yrji3TC55jibrL1gV4mOwudJd
	QJke+uaz1139SqdUW2vkU9sFDrFPRve+uw6GZDDqiqR3UBel9DCiAGLd/jYLOiahcKpy/G
	0IHoiNKrh/RkZ9eImisJBr0O+9lKvrg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="MphBLX/k";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sKzbdtRHuSFmYz9Wu0WId1iqCHblOqIb7Zas3UsUNOo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795495275; v=1; x=1796100075;
 b=MphBLX/k3My+TEpZ8FPkpbOTnyAZAlLcUi1kMZ4XvxyZhjhWcDyFVZuo6AIwRrrGrnN9IqZc
 aP6pK+CvbUBUXeKbi5621pW1pn3RxO15Mn9FcSc++Mq5kbPFQyp1e6b2M6Eii3sgf24ESob1c0J
 nyXLVeI0maQTpNraumm615Ls=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d97c5093d7af4130;
	Tue, 24 Nov 2026 04:41:15 +0000
X-Mizu-Trace-ID: d97c5093d7af4130
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Tue, 24 Nov 2026 12:41:02 +0800
Subject: [PATCH] mm/hugetlb: fix NR_HUGETLB accounting for kept surplus
 folios
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-for-gather-surplus-v1-1-231e5660f3d8@kylinos.cn>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDQAxA0atI1g00wYr1KtKFjlFTikriiCDe3
 Wm7fIv/D3AxFYcqO8BkU9d5SqBbBmFspkFQu2TgOxdEnGM/Gw7NOoqhR1s+0ZGkLIvAz5YfBCl
 cTHrdf9P69bfH9i1h/Z7gPC8k3pYHdgAAAA==
X-Change-ID: 20261124-for-gather-surplus-1e886c29b251
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: hongfu.li@linux.dev, linux-mm@kvack.org, 
 Hongfu Li <lihongfu@kylinos.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795495271; l=1760;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=hYiFlUVN5OeZDn2vfYEe4KQAKeTxMLlpGyjtOmnNeUU=;
 b=1C6A+yUFr2mAXrNg2Vmku223mdaXaR1L9uKWPymWTkLoOeDUKDTTyqCjUQOZ3365wBg24W4J2
 VvG0IymcYXIDJV16bkcbI8ZZOCbYmOqqWYoLyUlS+Z67kbYHSAzgGB2
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 5F16A40003
X-Stat-Signature: xnmt5brcku8y4m8z6cydginxqhm9urnr
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795495277-20355
X-HE-Meta: U2FsdGVkX1+Kyy8x9VblFSf0d46XeDwm1vrHNBYc73zbrGLrLVHWRVmzaplsWT6R6si+yaiWdgjhwc/RF2dpWru8uDHlFImHkqFwOJKD9jGXncZirTmsSJKjum2JnPWxnLSm+hCzZWBUI7ZDXmzHpwOiAmgoxKT2AdVMKyGauVSb/DDi/OS/v3Fpe2XJ/tvwRsAr5L7hvH4vuJ/M1CpZTQEu6TYzoADCMPVwEQmpaZurPyUMtcA92EZk1tXw3vQ9u4RtVnbclwkMjXhzmXnzBbW6AjNdc2tks7Bz/l3LToleTrlhRQSlEjsCaAVV+NPGhmjTnSBxHFrZD6pxHpS7GKJLRpZRI3RvYO9OTfPjpKmsm+7+kO0EXk/IJq+WfTBkBpwid0bLmbF2OqX9+CgUUuZH/cJ18y8c4AZgHL8FdaWo5s0/s+7ls34GykSMyGXFoePTLFJ76pj4WYuaYDx+//5IK0kJz0NPxykkUHmU2nnoUHPvX52/hp2q4sBLLn4qCIyRVbCym3jvbEcXNgvS+LD1ybIeYedccKKVJa8zRfaIECqgkIk2G8TSxzwljJSXqF+1lFt01RrRAHn6sx5agJ7nQV92Em2XQqtdD/ARDXbIw7JCMhLMpUvLUvc5W35qIispyUrdDznIFsrIP5WrRDjTxJrInHLVCgG+1N9sfF6Mhg7MBVNH2Domvyl+hCOVBZp3TGpl8LgzZkqHcpxmpgyOrlo7x/eZqDGWxh6zj89aRcPudi/CXalRRV9O2f7gBYQte5uiUwRKW+lavE3MFGw4mDLjSA1GABcxYU96X7g3SYvS+Qqw91UCO/YXg61YD/jDlH5nqKpSYiL3xNat4yum0luX2y1j8MFRUyctflLGVsuys4NBawBTZ3KHFF3vC4hjFryX8stiC6EFCPXYYKi91tDhg0+tnH9El3tca3YWx5YYVXh4eiTf/SbPJeNTrmxzAA1rZexBOIoELTz
 p6NLvgtx
 lo2zgxpYS/LjCcqiJ6FSBNBNwZ2oto8Kpz8AmnKCG6Wy2ZdWhBzjH8vwHQZkgS0nRNUKbYzw8njahjPZSsX25AoBxSPGRvzQ9Tn/Z7+PvSaT5zC9MXwDfe2xk/2cyooM3EZjf38P7pLbNfIDL74t/0xqr9wAHfzIevBzJp3+z53TQ43MLR71feY9KdyFgf0XT7cBD5ZbuLOfbPXJ9UIVEjA4HAjdNLqO8LBunLHdRjWGFp/XWfykZ6mnHcdzRk4QjWpeZ6SRC/1i29GzU2+Y4Y6hVcRthE03rErPEzsEbXf+XswMLvz+6EL2Hs/qOnwx4X/0KfWs03D38y9Dm8CMhTSH8hB3qVYdzFNrRvMPmbeb+eWfK6kktDE2979AB5WGFOWwF6q0oshwyXxtVmoWwVoKPCVNPMrdFqJTkHxvSeUKcG2c5i9h1Hqz2y/TVEnwiYndyGkEzh91zpLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hongfu Li <lihongfu@kylinos.cn>

Commit a11a13ebbc5d ("mm/hugetlb: account restored reservations before
freeing folios") reworked the free path of gather_surplus_pages(): when
the pool was resized concurrently, folios that are no longer surplus
are kept and enqueued directly instead of being freed.

However, folios on the surplus list are accounted in NR_HUGETLB when
allocated in alloc_surplus_hugetlb_folio(), and every other path that
returns an already accounted folio to the free list decrements
NR_HUGETLB first, as folios on the free list must not be counted. The
new enqueue branch skips that decrement, so the folio remains counted
while on the free list, leaving NR_HUGETLB permanently overcounted by
pages_per_huge_page for each kept folio. Nothing corrects that later,
whichever path the folio takes next.

Fix this by decrementing NR_HUGETLB before enqueueing the folio, as
done in the other enqueue paths.

Fixes: a11a13ebbc5d ("mm/hugetlb: account restored reservations before freeing folios")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/hugetlb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d0e66fb30622..b2c14f4f99b7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2489,6 +2489,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		 * count as persistent and we must keep them.
 		 */
 		if (!h->surplus_huge_pages_node[folio_nid(folio)]) {
+			mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+					    -(long)pages_per_huge_page(h));
 			enqueue_hugetlb_folio(h, folio);
 			continue;
 		}

---
base-commit: 87cdbd9bd63174de47ba16555bfe9800a8f3da07
change-id: 20261124-for-gather-surplus-1e886c29b251

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


