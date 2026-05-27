Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A7FACD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2C86B00DB; Wed, 27 May 2026 10:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99976B00DC; Wed, 27 May 2026 10:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6FA6B00DE; Wed, 27 May 2026 10:06:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6996B00DC
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:06:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51A08405E4
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:06:42 +0000 (UTC)
X-FDA: 84813375444.07.E95C56F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf25.hostedemail.com (Postfix) with ESMTP id 784ECA0016
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:06:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=t5XLJFW+;
	spf=pass (imf25.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Eg1c66LFMSDZiSV4TVxCFeAUFW0duGKcjtTfzIRAmY=;
	b=4j+zFc/1fd4i90DQgFKnsP4uf/sM0CcPm5hv/IcUmEfT9L3f71ygjieuKDgPsmu4iDCVd6
	sWFnR6sPdLs1zKD/F4e2dYP7CVM+OU4QGp86AB9yGji8P2XoxOoiAqMta7DzV4sh/tOgX4
	2BJiHOxLGR7eMm9VDx181WFIJuTf+Ak=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890800; a=rsa-sha256;
	cv=none;
	b=MbKh2QQN5oVq9u1E5KrX7bTjUdywU7fEqSl904XeLcM+ikwe9GtMQDFPCZM4CFjyjzmMgy
	CxrfDZvPPv4WC0Iq9+0d5MAjU/thJFMvQDxEFPR0S+4+0LLL2dx0sJhdDzBRLeFiYqExwt
	aIU2JwNK/DU6QKAbuaFU59PrRIOZ1sU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=t5XLJFW+;
	spf=pass (imf25.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=7Eg1c66LFMSDZiSV4TVxCFeAUFW0duGKcjtTfzIRAmY=; b=t5XLJFW+uun1qucxrWkkyytvAC
	HKxTRIK0pdxK6gln5TMBVKA9j8oKw0A41XdPIb0bG2gARxsyUdy4Np5sACSgpck9Ek8n79JBgraJc
	n77fanFsSs/29HEH9MVJzDahLk1p1vICqVjuO3HtRbpSvExxqg4GYbfvv4h3sYHhf/dAFGAFyUtL3
	3cDuqpj+SbZly5GYogh3UZ2XWATlPaMRPSYFijQ4IfKJnZKOvaoEfZp5f5NCFfwQq/+0aAoN7G3wI
	zSc+GuXpj9nBXeOgMBSOO/98xpgP023IS2gL2aiB2DuS1HUWp8+Elxa/Rjr0Z4dsxELYz4GwKLLM5
	36h+Usqg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wSEtz-003DSd-1i;
	Wed, 27 May 2026 14:06:31 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 27 May 2026 07:06:14 -0700
Subject: [PATCH v8 1/6] mm/memory-failure: drop dead error_states[] entry
 for reserved pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260527-ecc_panic-v8-1-9ea0cfa16bb0@debian.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
In-Reply-To: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com, Lance Yang <lance.yang@linux.dev>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=3194; i=leitao@debian.org;
 h=from:subject:message-id; bh=dRzYu8tKgN6EjEgu5H7QOpWd9i5LbDMZJK2X6dDuigk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqFvpb1t1yv21tSoXdpd9OeX7lVUqVxBfmBWhRO
 7QMfvqcuUqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCahb6WwAKCRA1o5Of/Hh3
 bRLSD/9hra+31QED97u48QP55twrygQyNcmxlYKWygJmoyU4xa7l6enHBboEvlIJi7I/r2D8812
 ZM1O1RL4Rl0bxPeX4dQDLD21S+aNapyrEP/X1Nc+z7O5xECZK1gAiTXa1ZDG/jna6TbAIT8iUKu
 3c5LPqKasQzx6QwGZuf+PfZRicIkAxftwTNEdUB4+M74p8Jic0eGsydOMR23W0dzm75MsjGe39B
 wna0s/IXdcK1m7Qw4lpXQNdmbiWapHcmEUOqMezfMugMkUCiz8bgSfRRG7gLPG4EX1D5o2eNaMu
 itOnCL/dX/AUwCSE2eKiIMNZwf3Aey9zc6Msb3yVwKdRDxu0yLIHvUFQUI9jvIWRMjQu9fjNWOh
 yUUzXaDncvCoJA1LL1oVJzi/mEHe5YrHkLKOC6DMhYYMts7Cgj8s8OiXiGmngwT43XyL64x8VmO
 EHmlfnY9FVJY57gVvOP06yMEq6HJKpcHUD9mjcpdba4L24qncka7JHwbu0x1O7DOQSKi0M0IgDO
 +FZqA2sNAf4etbyVSm9aV6mCYLbt2jO3o0ItIeV3SpI+A40KNmuo1a8DcjrltK9R9NV+p3+dXvT
 WwZtY5lCZVJU/v+gePAT8u/k+VN1IZFPgWbIO4BcMcIw/zU4l1HWhqIFCsikew7x7FiAyA1/QKY
 1Xr7zhi5EBlO9Cg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Stat-Signature: o4ce1h7j7keranjcmpw7htaouw7h8j4f
X-Rspamd-Queue-Id: 784ECA0016
X-Rspam-User: 
X-HE-Tag: 1779890800-508202
X-HE-Meta: U2FsdGVkX19htGG3mxbM6UZA/Lck0g/aY5UCF4O2lNNvPKK51Zci4trQz2bsPoh0lRjzad96C6PYbCLYy8ypHQOrljfbE4CmzI5Y9yVhhvQI7532OqD+DUqAOxxLnSx0mhc9c/ctcBRyXI76d5FtFvZBNFfQBRzpRMMWFJU12Pd59Kg4xU8IF7S1vhiqxDkAmMe/0jwUx10nkSiUo95cNf8xSK7/fwZ1WlyEECiE/0Y8zm7ACQD2/8RKfaetqunP2EUDxoF4rGJAyovxWWz28yizOjwZh+Owpmtc77KrM3nzueJ326S9Ip/jGDirp+A1eq3DPN7DKPTF5TqU8UDoZq4v68DrsBwZ0qx4kC5nLLLOUc8Xw+2GPPG8QwXNXhazDecTcRuxOENCDd7FwlRfSdZZZR1ME7Jd3Lnd22HYOD4qOClSDTZEtCiU8mivHGm23FHOuD6fUWbT1xzawJhiXEIitBqhTohxjuTPGKmh9fUTXVaboc8rHGYLS7mEKkkr4obWCE4M9O6nrQcbAb1KrcBIQyitH2cFnB0JneU5qnz7yB02DeDaLCvsOR2BxmXAFOqsDwZhxFSxnHx8IWnhBpfJ+p5R8nobGrMKRuQUzHXOVgZGw3mBqK7UdVMzi742J8B62K3TQhmGeQ8c/ZE1CdiPev2vUSXVaKPlmv36EdU38Tj7cKCx56EiM7PICFPML6ElnEozySD8b7CdqxAkrdT/2Nh1R+aSlKZKBYGYyVjX8uLTKTdmS/Iom3hLa7vqaF4HS+9K+MAdQi4V+pIjxKfr7uVHwhZ3lKhB5V2V+DPyg7xxtPTuQeHuH8ZzbTV7HUlRzDfnAZDWrMojhlWCQ7WLi6rYhwJmvLIcSmwkuwhVkvgO8tqBR4qoB8MB1m4fzuCT6oRICg0ykiougOEXUADNtFDBXDQXyXsNsL2A2ub1nsdFsvnFY2ZrK0+2mgGFbRJ1pj43PKLt/xkx8yd
 lmKGBK3N
 +9MHyti4Qv9I9U5aqDD8j5GHUeByf7C3fmwXmAY1kzVrokL1j1pURDDwqUD5rUneRr87y39iVcmfbTZP8OTjazMJWGuj0jmftBTCuurjD9cAF0TcdnSCMR8iQNtF6pLWuyGjsRxSDa8uNoJIPTWk4g1gruHRiy5q8j54aoChuNZAPyv01JOW4WtCXIt6IQt3Q1z4vXeWccAZ8ijIHqKyq4iiJ0QYDF/Juc6GcVyr84KZv+Q8M4wnmy//BW55coRuhttP7TOBo9p/z3hJNOjQ2HxtV4bRdGAZNKwf447MdUHqjRR5/5/Kclb420vbXWmefa0/jbID1q0ANd9EkHJidLiYur1GlSLkpha8XkXBdOvrEe9N69KL5FyBlhqqHRitnYPgMe8daX6nfy6XleoW9ydnjIygoJCUsUhmIUX6qNExa+mREoSvJM5elrmYyn9aasrpl1tlvArlKbC0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first entry of error_states[],

	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },

is unreachable.  identify_page_state() has two callers, and neither
one can dispatch a PG_reserved page to me_kernel():

  * memory_failure() reaches identify_page_state() only after
    get_hwpoison_page() returned 1.  get_any_page() reaches that
    return only via __get_hwpoison_page(), which only takes a
    refcount when the page is HWPoisonHandlable().
    HWPoisonHandlable() is an allowlist for LRU, free-buddy, and
    (for soft-offline) movable_ops pages -- PG_reserved pages do
    not satisfy any of these, so they fail with -EBUSY/-EIO long
    before identify_page_state() runs.

  * try_memory_failure_hugetlb() reaches identify_page_state() only
    via the MF_HUGETLB_IN_USED branch, where the page is necessarily
    a hugetlb folio.  hugetlb folios don't carry PG_reserved at that
    point: hugetlb_folio_init_vmemmap() calls __folio_clear_reserved()
    during init, so the reserved entry would not match even if it
    were still present.

me_kernel() never executes and the entry exists only to be matched
against by code that cannot see it.

Drop the entry, the me_kernel() helper, and the now-unused
"reserved" macro.  Leave the MF_MSG_KERNEL enum value in place: it
remains part of the tracepoint and pr_err() string tables, and
follow-on work to classify unrecoverable kernel pages can reuse it
without churning the user-visible enum.

No functional change.

Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c405..f4d3e6e20e13 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -980,17 +980,6 @@ static bool has_extra_refcount(struct page_state *ps, struct page *p,
 	return false;
 }
 
-/*
- * Error hit kernel page.
- * Do nothing, try to be lucky and not touch this instead. For a few cases we
- * could be more sophisticated.
- */
-static int me_kernel(struct page_state *ps, struct page *p)
-{
-	unlock_page(p);
-	return MF_IGNORED;
-}
-
 /*
  * Page in unknown state. Do nothing.
  * This is a catch-all in case we fail to make sense of the page state.
@@ -1199,10 +1188,8 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 #define mlock		(1UL << PG_mlocked)
 #define lru		(1UL << PG_lru)
 #define head		(1UL << PG_head)
-#define reserved	(1UL << PG_reserved)
 
 static struct page_state error_states[] = {
-	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
 	/*
 	 * free pages are specially detected outside this table:
 	 * PG_buddy pages only make a small fraction of all free pages.
@@ -1234,7 +1221,6 @@ static struct page_state error_states[] = {
 #undef mlock
 #undef lru
 #undef head
-#undef reserved
 
 static void update_per_node_mf_stats(unsigned long pfn,
 				     enum mf_result result)

-- 
2.54.0


