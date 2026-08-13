Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2D6C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9CB6B046C; Thu, 13 Aug 2026 06:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592256B046E; Thu, 13 Aug 2026 06:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432D36B046F; Thu, 13 Aug 2026 06:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA176B046C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:03:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EF9716054D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:03:07 +0000 (UTC)
X-FDA: 85095808014.17.CFB82D6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 924FB1C0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:03:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jTcssKBz;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786615385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLVa+zjcHZ3q89ZlAQukI32EVVr5AUEVuCmPcq6Ui6I=;
	b=cWSwIbM5EAXNjtsmRa9L3G/DBuKLT2BnbaCXQ4CHXDoU6/C2wvOoFmvnjpHqPnVJ/ZlGOV
	Xs4LGWt1Y3zUuNfSsoTESOhm4qagJf1uRn75MJFD4B5XVdAA0Yuj7IOAKgN27WoBuwtTqU
	O8TTzjs7c1vCGZvgVHKNJquBMVYVPik=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jTcssKBz;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786615385;
	b=X8q3zkeCY0vQ+EbYokknOmX+VPT3QWe5p69be0PQ0n7uZrvtf2w/GWA+fYmfW+IsJYYog1
	aHVPDjat8MVArv1MUF8nQa4boyZ17EPENf/XQVV3BasQf2W70uRIoJiUyMcLEhwD5UOpKP
	PWAdM94AvcOu0fZfzXEqm5vuMzejl2Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=hLVa+zjcHZ3q89ZlAQukI32EVVr5AUEVuCmPcq6Ui6I=; b=jTcssKBz7dr2qg6m1N2so6N7BO
	q+nPfb1dlbVYlKRSKu278fmNllB8oizjDynyYTea4w/doHRjyyXoc01tCXBbzMNzkh1JL4dvigoq0
	wn9U2D9nX1DLlpojcc42pkcjK8uC7zUBZKdBDy6H+OVisKC7JoxPpivwFy1w43r3Fk+lACgIvKg7E
	m3ECEyRimVWkUTSTq+O4c9spEhe2aBFtGDlmwH1hdhDB4kzZdgVCNM9kcRk9jdvnUSoyyMNfJsNak
	tSVQZ8+RiYbWt+OpJnF5RVl3Jj2POahrdBK1QLsj+OqgtPFSwUJWJrT7mfV7iUqwSodyCfTnm0rnd
	LUAj5VuQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wuSGv-00520o-3D;
	Thu, 13 Aug 2026 10:02:50 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 13 Aug 2026 03:02:22 -0700
Subject: [PATCH v2 3/3] mm: fail the fault on a malformed swap entry
 instead of retrying it
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-v2-3-4a625ccabdae@debian.org>
References: <20260813-swap-v2-0-4a625ccabdae@debian.org>
In-Reply-To: <20260813-swap-v2-0-4a625ccabdae@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=951; i=leitao@debian.org;
 h=from:subject:message-id; bh=SmrcYFoWWX0gEHdUAwCRGijyGvjB/SH6IwdV5jR8akM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqfZYw9iNKkPP+i+19qL3SClZWK1+Fa9721SNcr
 UBC7tBWG3uJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCan2WMAAKCRA1o5Of/Hh3
 bad1EACgMQM2KbtrxWEgwHNbB7QPz+gCJwzh4OW8BQ7Wj+BguF4gu28JGQl1Qy5o9MOFuhNjA4k
 7SoINP180rTa9PmSoDVXIflJ+UJbZigq1nsXuJCutdNPOOWM3lPbvAtmhBLOua15cSbKZwRmQsM
 qf2yCRJwA2nSTAoSWlG86gv4q99tPro36mUr+P/0YWpydC4jXp03XFoExMBal3N/PcAlzUgTpNX
 EAjZUYc6eBXFOHCYw4A3pf8Bx1MU+0m4b1Yg17k6I3sp2Zi3s7An054zKYiJxzSRmpjgiwAS3m0
 YlW4aQd8Zrno/YGyanJjm+1tgNG9KoA4ZHd9gICzh4JvZWsw87FRzlLukpgG+cT/teIEuLRRYIB
 QrGNs0aaHkuTIihG2ll+ClCEPOCvmmP03po5iAhNuff7YpHYumm25pLw6MU5ZggAWyVYZkwFXqe
 zmPiUL81D6EGsRC7TVQuXdKChdXupd+5JVn8QNKLuskCdDI1vz8M1Ky/LMd60ryIVTBav/ou1pa
 4OIErsleCnefOj0fJqGD0OmnN1v46fePOyhg3qGxJWXTRhEPTcgFXmOWI/yEbjdIG909TFjpebH
 wdD8R8MdHsJK3jaUakVsRZf7FQGylfaAxTijrZmn//T49hT88BVfT/hYD9al0ZOJZ3teBRYUnwf
 po/eNDPaRnDsDgA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 924FB1C0003
X-Stat-Signature: 15939d7ihrdmqxz75kjcw8k7pki7zthe
X-Rspam-User: 
X-HE-Tag: 1786615385-364202
X-HE-Meta: U2FsdGVkX18BsEI/u85e0xkocqCePEt2tPtqOVgVadcvHChh8PbNKQwK62Dx8Hbj9LZ5UM1Ge3L41tWn1Zjcek5lfz27K1BPT2N50nsPfjD1J65dEDEItCG/0sl/jqoa3xNlIbHMsUtPK5nsIoGE2Xa98yZmf0XymRerjxXz1Zwa0nUqtqYb0zNymeulFb2I92Jevtyi1ZUJiPu/ItNoSeMkq7Uphvdxbc6Jlvj0IojPG063z99gMhnbIx3XeDeqRX7VzDoNquvCIvFJOT34lBYlU5choJtNupXS577/S1qQzj7QL1TZ0IaLyU+4HMU0TopCH5e7lFWR6FfUvGXfE+ZjXlMEGouod9I4ooPIor2dPc/hsi6Nk6ykfZxXoH0Efafh93wCsPxWc2GDnPlxUtHoDQ2WIar8l0azmPbJMYmqRiR7KGgJHkD+QcR488UsmzPLDU6E9RUchZqhytK51FCIeY5pgyx31buV78KFxzWpXgRN/k/Le+A4Z4hZflmyebDOuFSb2qXh45/fduTVZGJDmASDjBl1mUbegnXDxCfdgcaLREl75t3BXDKIycnzq5F74sfNwEeP88thjvtgKneEydrfrbwTrxhygWwXoTZE3115wGnj2JWDTv1dIecbfCqMJbZFryC13U1m3lbLSJ79i/nrz5dXyySj1z0snQjfmh9QHjBZ6FKaAvnv6wPFED+Hc2tPf4r5APMsEvaAEkbfVN470puNvB5gfuaM0O8DBW4nPWddUQK5B3C9eeYddO9M0bVKxR9CTFCktgnnD+BM0tBeN1rhsGIhwImSQp5p7XvJQxsoBcLBWUFntxhZxalJI2aFdv4+pDB2uhXdl0SdyWk9GjZuIQILQLiQyl5ghIGvdKJT6dVA3nlUBp2V6dTHfao+sGNvNfk5LwfAHueiz6u6zGsHqdrucJQqBaa7CvtCevoDQInM17LBEiNgs65Z8H2YA4XchmFcae0
 fkL4p1fV
 LEuWx9IzIzR/iE2Xq8nY8gqJORALoeM9CUSmE4Ed2+RbqSo5a+pqpICsPjZLWXe5mIKXHC7RKgOvnt5MF8YpoZt3/xhxjnKmDqWj+fI/WDc6D5akD44N0H1HI4qVewf6zU2ZHXHeSDcHAtFTwrmjb32wFzKdiYGX63YsAf+e4LbcASj0PsXiXyhWDh7dNyqBXv4+/TTmuUtdMgQIsbVaAABtQ1GTy0AZ00m+va6fDh78bqhPzjCBuDN+KqmHjWT6ThrDmudOoUGz/s2bH8nVn0cljzh/W/xS8TlIn/C9ncTGd9iRE31nhXRjlBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_swap_page() returns 0 when get_swap_device() fails, which the fault
handler reads as "handled". For an entry that can never become valid
the retry takes the same fault again, so the thread spins forever,
retrying on the same fault.

Return VM_FAULT_SIGBUS (Bad access) for a malformed entry (pr_err() was
called at get_swap_device()).

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 7201e848129a7..fa2b3d2ad3202 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4957,6 +4957,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	/* Prevent swapoff from happening to us, and reject a bad entry. */
 	si = get_swap_device(entry);
 	if (IS_ERR_OR_NULL(si)) {
+		/* A malformed entry never becomes valid, so don't retry it. */
+		if (IS_ERR(si))
+			ret = VM_FAULT_SIGBUS;
 		si = NULL;
 		goto out;
 	}

-- 
2.53.0-Meta


