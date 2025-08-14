Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECDFCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E70C9001CD; Thu, 14 Aug 2025 16:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09D8B900172; Thu, 14 Aug 2025 16:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA13A9001CD; Thu, 14 Aug 2025 16:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6B92900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:08:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0DE2160733
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:08:42 +0000 (UTC)
X-FDA: 83776450884.05.5FC7E2E
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf25.hostedemail.com (Postfix) with ESMTP id 07EAAA000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:08:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kLQWHfAy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of nathan@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202121; a=rsa-sha256;
	cv=none;
	b=mY7PDjrmxbJNcdqK38duMwXnOx8hE7GppA8+m3669QGyfbFf2Sa6L2cmnperog9s3tc5KQ
	TX1+IEJQASL2RTvSs7SbIxUarGqp4+4U+YyP1XEonlp3t9rcjwzljtaAFCNNi/W/UnvcyD
	yp+v492ytQUEEcz2pEUisdRikdjlJxo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kLQWHfAy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of nathan@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pA9EdWV/SxLEb38C+RRUbVDtiK1nUI10k3NpYwO7o04=;
	b=ef2MPn+c0n5NsmxwaW9Rycgnqo3j6Cx22a4lPE6iuA5feAbBYgsxAQpKoytgg/l6DbsMtW
	dfPjkXOBzfyLA5s0dB3lqhDwtygeCW7ZLPuHLytLI6FknXiYUfImgHhekysfXeqgivwD+v
	Rsbc8iuOr6u/t+T2t7rMxi4ANjL0FlE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 41DC1A55367;
	Thu, 14 Aug 2025 20:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B7FC4CEED;
	Thu, 14 Aug 2025 20:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755202119;
	bh=xcfeo2/DQtmCLjuZc4lx76Xl5JQ/w8kZY0rp9JIkZh8=;
	h=From:Date:Subject:To:Cc:From;
	b=kLQWHfAyHImX7AQXABORqZ+fce4DMi4GN3e/nOuAXZqUpBXuAcdoxb1yj21YyFJNk
	 SsSbbo+jHBvRe0K2KYVLALgQvRFM25sMbVc3RoJQ/SZVMVJH7CCxH9PCGsxYwCPge3
	 tGXwz5z5u4jZ+Q5Z8I3hktUXIXh0oPjA4WvjvQeyyxmok2BKMJBkP2gZSIOwAVaVnn
	 Zk4p6budaB8J4G/Re3WeWMoCGHsK6p3xjMNYCNNlZmymL9EK5UWxSLVJ8fkOhJPc7e
	 bzvhn4eIR0XbRsriNgnwmCauSOZaQ/yGuMuQg6Qy4LCBguxOjSGe5+1raWu2JnAsmh
	 JGoSYw6WdQ25A==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 14 Aug 2025 13:05:22 -0700
Subject: [PATCH] mm/rmap: Always inline __folio_rmap_sanity_checks()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-rmap-fix-build_bug-conversion-v1-1-fb7b10a0b362@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIFBnmgC/x2MQQqEMAwAvyI5G2hrFdeviEitUQNrlRRlQfz7V
 o8DM3NBJGGK0GQXCJ0ceQsJdJ6BX1yYCXlMDEaZUtXaoqxux4l/OBz8HfvhmNFv4SR5Svwoa7V
 XRTVZA+mxCyX3/bfdff8BMsVfxW8AAAA=
X-Change-ID: 20250814-rmap-fix-build_bug-conversion-90441c036f42
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
 linux-mm@kvack.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2110; i=nathan@kernel.org;
 h=from:subject:message-id; bh=xcfeo2/DQtmCLjuZc4lx76Xl5JQ/w8kZY0rp9JIkZh8=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnznFyjnirtNJzLvLT5L9ed7A8f+fadub56858jRmacz
 qxZM+UfdJSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJpIowMiwOmXTlu8aRpo54
 X4eMDxbNXXsuWG2fNS/Myzx6dkamawgjw8Ef33ukomcenPzkfJ3xiasON7idLQ6t1jqe4unwpi3
 pKiMA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Rspamd-Queue-Id: 07EAAA000D
X-Stat-Signature: 5rgc5xc4i7384x8zpojhfywt3si7s9a5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755202120-362379
X-HE-Meta: U2FsdGVkX1/FHRKL6hYGQEpFoEzFslOvq6XO7tvNGbRAvyGW/a1OUvphcqAYG8NkwgrDJJjznm+OdXAHNlYJb9D3B1jPIM1hbFNhBViFhyBdlHaO6O9m84GKdTgmK2H6uU6lEYN5qgeyulOTd4F8qK/+EmoYkoHGimpbqmX2yXUuoOElQmgY/qniaGQ7bi5pQIzquxrK2aB6Z4csetF5gdAmMB5+YyNn5lLg2n4z14pKcHQI09i4nwcHqeRnJJMBXQ+9w9g6PO7Yj+FFKYQD0VTefWL4BVOE2niZ7P+xV+5otyaRie+ZJUHP1eondaHAEUX6xVYAT4fndGdwbMlC90KG0lKYRd/ByHkwwonb9cKvyCCN8PSqsnA6VnTJc2elQEl9AoDZ9n71X4C+fvLEDlLSINx27eFFx91XAIapfF5LlmzdseZUDV4Ivy5c/sS9k5QbGx5XQ80Djawangha7pF1fIuXSP2hMY7B0kbXjIzlgchdDe/Ymsj2IJRcEZAgXnWgJQAhEGJcGEJEC6E9CsGFCHAgo4GJ2ya/vIDvAJOJBUG4P+LPy/L4d3SMUqaL2qgSjtTHFRU7sqJ2J9a/3gbPVfzo4TgYSlW+LSIVXB8IWj5hoD43SKPIy4baOS/iiIJHC/hhtl/p5/e7g0/SznFAvZJBYKjlr7klM7erT2QNnx17S2tKAwhWkfdbGCuiQdhTXxXTb5Og5XF7+0MEGkFdcIaslDUXHR9hkczoy9LaktzOIr33kwxbxtM7s0besM76lSBc2MWyqPfmY/iGr77x0jPBnedsD9Fo1rsrOVdZklFunmQ2JbYL+Io3qmfC5/UYrA6KTC3LTgticV7VYQKc4KZJc9IPk+pBCtN4mZQt6Y4JKnmw3DO7DHDGn1jgXUVkMXVnXKpl70xJ4SwbHe2bXogTyKJYbHBn82feCIlFJFSW904kAC8b3Fx+Bk0oU8XPP78+NLHpwSySJQk
 EPsD8vG8
 h6YP3bffSCxeRXtkJGOSIbbn7bFwqKG8DFa2UEuajcvGZzxn6MxlPsGdavzXAmnlW/869/X/Fn3U6eszZevAni4YqyJ8w5o2Y22s1NnllHij+TnghpPGbDiAF67KWcZI9FQoaO/QPx2XJXQ50o5PUpRzd6dppdGHPM0eXsiNOZAqWARnkgrd40UnxxE7NBNjMIXwX8DPUmubVagvJzbbMe19zhwtavAeFyIIJFpFRU0BRyJRCrc5g7oazVsuSejL2oUCmOr0tJXf5LjaLqp6507pKlppSzJsCewMI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 5e901e249ad1 ("mm/rmap: convert "enum rmap_level" to "enum
pgtable_level"") changed VM_WARN_ON_ONCE, a run time warning, into
BUILD_BUG, a compile time error. After this adjustment, certain builds
with older versions of clang (such as arm64 allmodconfig) started
failing to build with:

  In file included from mm/rmap.c:63:
  In file included from include/linux/ksm.h:14:
  include/linux/rmap.h:440:3: error: call to __compiletime_assert_890 declared with 'error' attribute: BUILD_BUG failed
                  BUILD_BUG();
                  ^
  ...
  <scratch space>:21:1: note: expanded from here
  __compiletime_assert_890
  ^

While __folio_rmap_sanity_checks() is marked 'inline', the compiler may
not always honor it, such as when sanitizers or other instrumentation is
enabled.  If __folio_rmap_sanity_checks() is not inlined, there is no
way the compiler can eliminate the default cause.

Mark __folio_rmap_sanity_checks() as __always_inline to allow the
BUILD_BUG() to work consistently, which clears up the error.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
I assume this will be squashed into
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch so no fixes
tag.
---
 include/linux/rmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 9d40d127bdb7..e8aff6d2deda 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -394,7 +394,7 @@ typedef int __bitwise rmap_t;
 /* The anonymous (sub)page is exclusive to a single process. */
 #define RMAP_EXCLUSIVE		((__force rmap_t)BIT(0))
 
-static inline void __folio_rmap_sanity_checks(const struct folio *folio,
+static __always_inline void __folio_rmap_sanity_checks(const struct folio *folio,
 		const struct page *page, int nr_pages, enum pgtable_level level)
 {
 	/* hugetlb folios are handled separately. */

---
base-commit: 6bee0462de1f9f4fa9400f153d3b0792c20d7111
change-id: 20250814-rmap-fix-build_bug-conversion-90441c036f42

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>


