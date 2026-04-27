Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FC45FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B4D6B008C; Mon, 27 Apr 2026 12:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB5726B0092; Mon, 27 Apr 2026 12:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3806B0093; Mon, 27 Apr 2026 12:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8726B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:58:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DFB51A01AB
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:58:04 +0000 (UTC)
X-FDA: 84704943288.10.16C4B9F
Received: from out203-205-221-191.mail.qq.com (out203-205-221-191.mail.qq.com [203.205.221.191])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9A3A74000A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:58:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="Zont/CG0";
	spf=pass (imf17.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.191 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777309082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sedt+0yF4PUXjW2cDCOuf6zPYyf6IHuFfjmu5yfXC5g=;
	b=xEshrYv885NMzS7wtFhHJVYGDVvTIKeXXMH17MOgwEjpxy802hnegrrCCAaNXc5VumXlM9
	23dDARWJE+aPOti9cFeU4PDgaE+VKn1yKQM6+daIFxp/+83VSDpUmrSquefjhOFQjXWco2
	avF+KLw5lRT2Xb18h9vwhJQSVZBVAX8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="Zont/CG0";
	spf=pass (imf17.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.191 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777309082; a=rsa-sha256;
	cv=none;
	b=EQtTTiKgcgVk2bvb3AajbvmKylnYfROnRIxwxgg9YOsvl35IIPYl7PCDIVgyz18kxkTtr9
	91S/VnVL4JNO7+7WYXBaTLtZRL+/l9/2Yy6cL2/x7AXp7H/ZoWskYSgEdQtnyNjTdPxqkN
	iP04qOoHCxW+QP82c4Qbon/YUvt6jdQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777309077; bh=sedt+0yF4PUXjW2cDCOuf6zPYyf6IHuFfjmu5yfXC5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zont/CG0ABOv54t4qVAB9I+1E9JbS2gagH7mZvQ6iNCrAujXTqK+W6rpa+ZPZoah/
	 G/KnvFayhnvJWZ6FLKAPeCpb4oOSbMif5Ks3hrysdlZ8RmTIHbMq5YSNDkReSRI+F0
	 3/CPZXIVVMJGfE1i1QEM3nfm0j7BdoJNhkU0KLQM=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id E73AA4C8; Tue, 28 Apr 2026 00:57:51 +0800
X-QQ-mid: xmsmtpt1777309074txsg2bvql
Message-ID: <tencent_6116695C50CF078AB6F36F1E40235E377108@qq.com>
X-QQ-XMAILINFO: M2SvzgchpLqfiz8Rydv2i7njf9z+f9bbu8zDDCUeFgsDjDbuYchvLoA9hsxoXC
	 ga78Eulp6EMVLvwd21cfoMvhLxpdN9qTNTUq/JzYF5fuClIxCodvNAWQwtZDwJKTS3By+EziMA8s
	 y4Q2q6wTkXmziGRr2Qw1ZQWZX+r1Uo2z99KomAVYQQsjUEh5AUHC2cr/xGZFgMNL45h4ed5JJpvm
	 bdXTXWyZ6ShMMnaKGslzcWphja56fpgGXubtaiXf70qRMgJnQtz9fBOtYIAf++4qtL35uOorMWgA
	 ebVnSgwBCHtduOCvjyt6oo126NhprmRa6HOehNkuPT+BxZppRqSQQHn/pEhyKWa8V2EU0yKDh8hf
	 fJYFbQjLrox/6Nl42nW8DqpkxTy4J5JqpQaA68R2B3B2j1IjauVWtIo7vgheGuuBy1KSwbthIbLh
	 zt9d1RFMrlVzUXm/PCcWRVGfmnHRBnfItltriMJ1CsT0uUCv1nMe+PQsShZhwpciX/s/icayQZUc
	 aX8L3FxfwcJN4+6tbpHJHGk8IfjVb44na/t20hGHy7vJTF/QlFinQK9UC3VinLT4XbJcaF+nhdRv
	 ZfrR6w+tH3T558Xrq7QfyUuCo2/devF87AhJscVtWOI1/soRsqLACsQ0F8NiCxOhJ9G3OrWKTyc8
	 UBX+31NBc3sUEvFblNovKQOJV1AYJH9BjGMmj0PcjjlVFr9/Yu2pjOXuCn7+KIZH94ChwUUzKsJW
	 3ipuYENJjHP3xBTUjS06abhiJrNEM3jl1jBOMJDPR1DDr12yT+mT8kKmWcNLhqnSf5Yel97TqOIo
	 b8qFxMm9i8CFeGydD0Z1nmBJLZ4VhrWmXAwSSmTgGTnm7fdqtiOq5cpuvDTao7rCx6llM53osTJJ
	 o+WnqRk7DDhfyu+iJ15uRvD/kozg9JbMfGrlJC03yL8iZhWTdz7WLGiAakPp6skKfR1oSc3z/3Bd
	 9NelFPg9Yf8Mo3dUu/uQcajPKkGqyEseWRUpEDD85SRJ3BhpglWYCULBZkJHCPCod0ZEQ0J7DfIE
	 MANPAN6ZBDuX3GyNN4Kv/7+CAZH+Y0eAuHwqPpBlQ3G7dpK3Fr
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: fujunjie <fujunjie1@qq.com>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Haoran Zhu <zhr1502@sjtu.edu.cn>
Subject: [PATCH v2 2/2] mm/filemap: do not count FAULT_FLAG_TRIED retries as mmap hits
Date: Mon, 27 Apr 2026 16:57:51 +0000
X-OQ-MSGID: <20260427165751.746502-3-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260427165751.746502-1-fujunjie1@qq.com>
References: <20260427165751.746502-1-fujunjie1@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 97hj3e4ikwcrem3aentodf979cioyzzc
X-Rspamd-Queue-Id: 9A3A74000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777309081-244287
X-HE-Meta: U2FsdGVkX18np/fDwY7lwMDiFdGPNzwQJcMJL5YbInwFiOkoa8oM/UwNILHXmXEOtj2q06bo0krMfcyXNrmD4ytC60ue6TWC1QF+6YQ2VZoLtVV2hvmm6MKz9aGkkSx/VaUEa/BA2yzmuq0mqgPwJo7FO99NdXO8UZv8z7eTkfTHN2xFRaoc9h9e5t/pcIfIK8aB01IRiOdoFBOrp6yyYtO2KXOooE6NYlO5OwTNcfi6vggV1O/Ma88UXvZql2T0G+vsRf2zMRDdZ9/UVtfthKAyZOQCe1rxDaheIcN83kiLEZZWT5JqaGRiNReR5brkdMBEBTckr5u6A56XwKZsVJClYpSnaDRBga7fEPROv1E3HCv0SXjqbVZLmWnayCYppRjQyYwVoyqDLUsW12M2EbqamHMa6Ql7DIisR2i0F/310X8YTi5jkY3av5iTH4tISTuwTcRNZXV4jR1xS6WfgNJYLDVk8SSkFpJlpP2iArcD+clKHhzvsHWNQLmIHL02BMHdeLvVQ52L82kXp97G72AUXUP3cw5wM5CDqaHfZ444EJVtWIuGk2+e1edinjyhkMQD3qkAIKiohCzB8Pq18hh6V8MhqxFL2dNz6BrI4HLvzv5kXQdg0x9xZ7j3welGhvqAplWKbKgSiqZS7eYpFaqlapN8jJ8hmVq4Ez4JLgjGl9pOORv8hjWw7KhX2VFScV07fp2lqZpQWnU17WzAC2l0SENtLO4t7dgg76mKqKM4lITuAUzwOovOKiljUzsVyF5UAk/3qbF72ed5ZbW7EJLEq2MKGMaPHzmL6O9xpgnzVeJDEzc8+x4plkRhzVzPR1lc+0YQvYHPqfhHLD8jv9nK66ieGHV/VT32x90m373tpbx5V4Ue4DaOl0E33S/lVuRUNDHIXv8M1J1gR3REYCzTyIEhYcNEJPCWiMxeaXNeEWbpBh8RtFz2pl+SU3hpIq1jXcqhq6Vj5cggmTR
 DbsLraGY
 aqh2Yj2RaYZzuM14q/DaA9LmOuKArc8Eh/a5PmUg7oOjtKqTF2sTUIGIDqfWe3SVXhbrgTpUFFNSfGI7gipda3xMGyRcUsjE6Yhrm8oNUhfo6p8G65fXE7VtIAKwjc7qSxGBqAJ/5ygOeJ1bCRV/R0lDtEG/dPfkFiIWWLO7AiPjyfhl5yFh2IGvHusSYSsZ5plA50skuo+zbmpuRdNY5Alqpr4GSp3znqx8GxapdbAcl4p34lvg0ZiS6W6+i0gd/8Esu6Y115RlvOlDHBBdt3/wMmtARl3+iF5pKZFIPAWa5Q9Nwcj9+JTonIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A fault that starts synchronous mmap readahead can return VM_FAULT_RETRY
after dropping mmap_lock.  The retry may then map the folio brought in
by that same miss.

Do not let this retry decrement mmap_miss.  The retry still maps the
folio from the page cache; it just does not count as a useful mmap
readahead hit.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/filemap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 41ffe9036c96e..f244886b1df3b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3926,6 +3926,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		ret |= map_ret;
 
 		if ((map_ret & VM_FAULT_NOPAGE) &&
+		    !(vmf->flags & FAULT_FLAG_TRIED) &&
 		    !folio_test_workingset(folio)) {
 			unsigned short mmap_miss;
 
-- 
2.34.1


