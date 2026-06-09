Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DD91CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 185686B0092; Tue,  9 Jun 2026 06:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1364F6B0093; Tue,  9 Jun 2026 06:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 025386B0095; Tue,  9 Jun 2026 06:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E65E86B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:57:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B50F2163AD2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:57:39 +0000 (UTC)
X-FDA: 84860073438.07.3D23458
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id EB72F180005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:57:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Lpx7hj9G;
	spf=pass (imf06.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781002658;
	b=5/bznqZjNaEC5oAQrbUdsUnkokeBTBuBYVZqbxFed9POkpcwx066z3mXEFtgxbIgHnpDDE
	vBGnDy5LOAHcsCEtThCrGLITiXyKuaSzKbMIknGGhDu2WzcKPSFhwDGNAfoUPnL35nmC64
	RSvGfXPINKyp8bVt0b4YEePIDhNl/8s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Lpx7hj9G;
	spf=pass (imf06.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781002657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+nohVdFqLh53p7CXnhNyUtPR5DDNhEHlR6gaOs/wF1M=;
	b=s/16tA7nw7IYby0PDWwXQrwEIqtzyokDebv/tQTFYgFg6Ups6V8FFxi1C7kVn+FBawobDJ
	KTSBowMcpp9jWu87qA1p+tcQOW9dxJNneLycpqLkm/UkYMjSQ2PPlKB0Ra4prLLW+rCfa9
	qgV6A9sf2BDP2O4TEaQqcWPQM9C7SH4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=+nohVdFqLh53p7CXnhNyUtPR5DDNhEHlR6gaOs/wF1M=; b=Lpx7hj9G3s2TQTtB/xam5NsxlC
	y+WwN0BvnZBo543Eh7xDClDaakrH+ZmRXr2aiv7yjHHbwJclE6ePbiAc2H5WdRwT/SHi21ZbErK5g
	MJxu++r1QV0RILCD5OruTlkld+JYAp28rUdrXlv7r2ptbUB5XKmOsnhvAT9epcRyjb5+PlIWEXnho
	c+AyhQDWoetpWJA67YIMl96bVfDOkaH/e8Cn+EYS8K/ta9Mt5ACfoA7z1NvqxyymRovS4C2MOTcPM
	TGN2GDM+JrfhaZoaLqBFdTqhqCONTdSACimyc7w7wlYrGCJeCFOvQpZV+kgE8lu2PL8l5BzbFZfdP
	VdtDaaqQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wWu98-008LtT-1n;
	Tue, 09 Jun 2026 10:57:26 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 09 Jun 2026 03:56:57 -0700
Subject: [PATCH v9 3/6] mm/memory-failure: report MF_MSG_KERNEL for
 unrecoverable kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-ecc_panic-v9-3-432a74002e74@debian.org>
References: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
In-Reply-To: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2453; i=leitao@debian.org;
 h=from:subject:message-id; bh=Oc/n/XwBBXtwbj6X9XE1i3pEwNRXj+wVbkUgEoDgdsE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqJ/F/kF2/XCBiL5ksWydZps0h/w0J3/rHD35aY
 2p6eZM0TB6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaifxfwAKCRA1o5Of/Hh3
 bUotD/4kz5OLP+m2jSn6O6pSdolh2/muiWL7jwAJoIvQHPL9hMW15HTEPNeOJgT5BGvvsGw5tMH
 c6I4yqQuN7qu/HIlsjn7r+eIRt8e3RUi3FseWx0v4zAD8W7t4/gy32ASUAZDh2HQostVe6jODsI
 nHxByOIw8FvQmcG1EryDDz/zVlXGeU96DB/1gEdrEEKmLZc4LzDtz59Q6/UZVVwfk6Wb8S6v5y2
 XFJPV8ZtuA0ARqrghH8HfJHtErdgKvEDjOWAwgUKfoM5+7Xb+cd83pai3fY9Jel840DP1DX6Qj8
 vCdCONy8NtQrqEC5w8rMQlpxSpWcvYax9eBaXZM1v1NoMiKhAOgJ82VZFQCEsGP8Ce6HoDDN7/5
 4cAN7QqGpLi0ntBoxiAqwO1kMirrciC+I918RJH4hS/VaFSM3krN1rplSDRktJtZWwoubTYrHgG
 47EkJbJecMzwO6GiBlyV3+8MRCLugLAM5iWWUM5QAaZerKVrMfpoO3te5Gd0C7oqVDzoii2h7Tz
 c4qDqWrMImt0aCAfar6u2IaLjLnELIaoZS4CyOWUSoXIo7mIDuNXv/yvxy4mRVM/Q+6hKd/Pm+3
 lwp1lVmZ7Y+rok9jWEi2fEy4FO/4U/EU7Dp7X2K+4r3fdOQoHhIm56F05PzJlFO7tkXuy5uvy3G
 SJpfI1qHxJBB3+Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: EB72F180005
X-Stat-Signature: ka9pii8dm9eetfbxp9aousixdwx8tbsi
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781002657-295445
X-HE-Meta: U2FsdGVkX19kfOggxNKvDEM5jVmdg+LzG0CCqOchqnMj9oqo6pgd8ZJ6vKDlJkbulSoVj4q+kgoGp4zDzDUFQ/qkpet85NuvzeXEnf1VPeyNGQ1Qiteao5Mcg0gEZEmnR3FKfk+Az9XdwFcxmTbzvpYMlAHXvjxEqxMbJxis1nR7cNKuy0iB0mnGjgXmHvI3OnnoXNzSLRT/1ruNvTOgeRtA4p+YYCNVhdmC3E+NFuMUavvxw9SeoIhap3O1mGctElApoETYYbDB2AC+d7/K0lVQ5rl0SsqWYH7a9vCqrMYbZmJNyN1jhkpF04PXeKF+qGt87kheA9K+IxilAoq/45yjt6JPLPAHRC8U1dAJzcY74DMIk6dzrTXIdC9oWqw2msVKKqfT9gR4HAn+HYEhteE+YhtBgi72Yh/qM2fmZQ39hqORXOTwHnOWi1txtD5e2/Fe5/UYYcT8JDr1oH3XNBr2jaW5/X5NWXyexCImMujeeyxt0c2tpeSjDzES9nH/zYCcXxcrc7N0GrvEtKAsO0a4XyX/3jB0Iai347IS9TOVLQolfcXI5vOlKR+6D7/CyNMoYAFIBMVos89PeZFiE94Xde9YyXVr+wDqt0quMYlpV/lMfpc52X7oGyFfjB0A7dWJab4b7ynnOkOi3H5Hj98Ytrviun0vUfiQyM20+zMWZNZXh1F4/mnAkhC+UBZdfR10vSUrtFHM0tEEiwH/0xZ9En65VRU5rhwwRQReTpOQSdaG3rnnDnL+mlpSn4CDm1e8FoIDWWhkiacjngVGGeGPtUtn8+FLFq3yhzGbJT9DwIFeRdynfjQmYvfh6a6Kp/u21/gRRLtZmenBYSP8mc+XIxv9y11STUFy431zBHi+lG/yf4sMcZq1per9pL170FNUMcanIJS7JqUDOS2hFIWEBKbktQm1gIlo2xEkG2p3cAc6fmQpG8KbJ/OUu2CzGa9gCm+ZA5/6YZnVVp4
 MMOVfoMS
 nIh41++Wtb8JKxJCs+EpayePQijUfsl4QtlCE5rJWU2SrdPwJ4gKyWZGEkYwZfGnZT1e+Jq2Q2mWCGpQZkVVJsI+EOPkMokCDZ3rgJy6ptKaGP3Kk4XPm9nfgMRwdbISlp/ljRrS69T5xZ9G+rU7VsWTKXGsNuRMJ9VRx7LyBtPRaX+T0u2+Z39UxPEaxAGbLAFve+8lDWCnB/5kast5MfFMjDP87pOZzK6WZbb/N0ihHJwVD1FNECRkCu4dQ0faEZWT2I7sSJGUbFuOorqMYVh4X7hZRBKCypwdhZ6OccORkUcim4jTj6rq0C1V0EfJGlwanXRROq07JY3Y6UmuY0h8u+h4onDiE6hIBzcMatvZwmALlxLiE9oEBnTHF6c/31j/gLk2OgpWcaA14JWENWa/ClvkRp2EYtih66Phq02m5+1GL5pGxbiTp4TJ+qEAlS1cGiGxrrT6bDqU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous patch teaches get_any_page() to return -ENOTRECOVERABLE
for stable unhandlable kernel pages (PG_reserved, slab, page tables,
large-kmalloc).  memory_failure() still folds every negative return
into MF_MSG_GET_HWPOISON, so callers that want to react to the
unrecoverable cases (a panic option, smarter logging) cannot tell
them apart from transient page-allocator races.

Turn the post-call branch into a switch over the get_hwpoison_page()
return code: map -ENOTRECOVERABLE to MF_MSG_KERNEL and any other
negative return to MF_MSG_GET_HWPOISON.  case 0 keeps the existing
free-buddy / kernel-high-order handling and case 1 falls through to
the rest of memory_failure() unchanged.

The MF_MSG_KERNEL label and tracepoint string are kept as
"reserved kernel page" to avoid breaking userspace tools that match
on those literals; the enum value still adequately tags the failure
even though it now also covers slab, page tables and large-kmalloc
pages.

Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index eed9de387694..35f2b5d89fbe 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2444,7 +2444,8 @@ int memory_failure(unsigned long pfn, int flags)
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
 	res = get_hwpoison_page(p, flags);
-	if (!res) {
+	switch (res) {
+	case 0:
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
 				page_ref_inc(p);
@@ -2463,7 +2464,19 @@ int memory_failure(unsigned long pfn, int flags)
 			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 		}
 		goto unlock_mutex;
-	} else if (res < 0) {
+	case 1:
+		/* Got a refcount on a handlable page. */
+		break;
+	case -ENOTRECOVERABLE:
+		/*
+		 * Stable unhandlable kernel-owned page (PG_reserved,
+		 * slab, page tables, large-kmalloc).
+		 * No recovery possible.
+		 */
+		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		goto unlock_mutex;
+	default:
+		/* Transient lifecycle race with the page allocator. */
 		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
 		goto unlock_mutex;
 	}

-- 
2.53.0-Meta


