Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 854B1C624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 20:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0746B0098; Thu,  3 Sep 2026 16:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A3C6B0099; Thu,  3 Sep 2026 16:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738616B009B; Thu,  3 Sep 2026 16:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22B746B0098
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:37:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4716A1C24F9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:37:36 +0000 (UTC)
X-FDA: 85173611712.07.31B1E28
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 74EA2100005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:37:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qep6i0fo;
	spf=pass (imf14.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788467854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rgIj/N8oul9ZLAizfJH63NRBCwMtcxycrJMIa0TwyZo=;
	b=6zJCfMRXJQXn/iPIL/4N/NHRxKv/DQpsY8j1iqwcQca4Wcb5nU5eK8NM9FbIRxaUsiqv9r
	Uiw1suHcuJCVoHIUhiVQ5NoX4NlTNql4kl6Q7HUjb/iT+ajdqQmgFJ6pRkMMWQWDGWTl3v
	vaLdCU9VJilsXRUUDWZmGaUsBlMAZac=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788467854;
	b=mAEnlp9tHkacXQ2cjY7OvHFasLDJj8EWhdBlid/EmKea3nd3r4pJWVz/zlorW4yV7JU9rJ
	dChpOLL/Y8EK2QbbxZ2S4TvpTZVcE0282F8yXlqJ9w5J1snyeu5Q9O7mSdun9LtydMTw+Q
	qNQf/EfoV92hzGK/ghiNPBGsrAZ8kyg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qep6i0fo;
	spf=pass (imf14.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49cf4f81d86so2265295e9.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 13:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788467853; x=1789072653; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rgIj/N8oul9ZLAizfJH63NRBCwMtcxycrJMIa0TwyZo=;
        b=Qep6i0foH6Y7+gsZj93X6VGQld/KdT4bBwu9iofsbI2DGl6rymLtasI6d6bBnxL0tK
         MQW/c0Cv2dBCznV4DecE69ja2WBRvUSr/aQe5SNKrPzW7ZcVg0ZcyzzTxmWGHm6xpVnP
         UnRlzxng4ZpowHbQLWt+na9xKU7kxM/lPjpVBRyTTqxtB0Sr+Jz8cZuC52Aa52UxRd/8
         VZRFJ3tedhMK7N27SI0pj0rTqBGgRyluWu4m5GCOXxgAgaBqXqHPMpoK/wHgSwBY+xjs
         lwg/G86n5zjb39ACXXfvbPyK/WlzsRhc0wukO/kJrl1EsLhmYVm00ztlLN5VqADDsVDw
         HxPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788467853; x=1789072653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rgIj/N8oul9ZLAizfJH63NRBCwMtcxycrJMIa0TwyZo=;
        b=GLPrHG1GfCuQ6KB1v04kOxXmIDNHb5i2I3BqO/KjF9ktPw9wepq8SAIKGtGHpd+TKq
         lRD/FD98kwlcg5t8NQFi4K7x8LPAr9CpMfDpVHIA9LwlIlVZiIPzS7t/hMNEe1Wadeum
         Zsaq3vq+7h5Be2vj6IWkpLY97ILx55OWWLIiDjMEp9Uy1g9xdt0OCg4Wx1+HTRxC7H/z
         w62V4mKWVSQIgnZtSS3dsU31q5B9fkKG385ZUNjQ9kxZxMp+HWL9LD+IamOJQlb9Lqu0
         xPDVz01VZGkAr6VFRIZqxPRLEcnLZw34nQeQtF8ekYVuLkoEVWnLUPNQRgDGfk80uDwv
         QFtA==
X-Forwarded-Encrypted: i=1; AKwUvBxeVrSaDLsIMLwwwHuxr511cpHENDTBychcH3MVuhuiFQLxIypecSNPizmyEiuoZBQ48ieK/bx4zw==@kvack.org
X-Gm-Message-State: AFuF++kfRZ4FFkNveegxqlbJPE9oHjdUTa/AID1xcZrsWTid9Yw/bypy
	cnQ7aW0Tso3r/lM3S2Yes/3TOtAk9MNJQTDjkABh05rXGSNGWVueR9+5
X-Gm-Gg: AYBFou1FP8JEepNSuwwJ1mn2ptg9Yyyey1uf/Px3zK8ZrxX+roGZTvGELqWJrwdytwg
	kAfEC9nE/fnO9i1NGMW/dn1xNwGw5Q5dBu/S6H47a2NxYWOHp6uY5cuZSdfBeCZ1fWxBzDaSw88
	o/Wft/YT8EnBgEwoqg4NhZAljF9ii8Xj+pXWc9azsjwQKBAEE8wXQQSu/nNQY/av4jL8su0HE5q
	16RkXP4L0oJkua+uU42FcGcACL1z4vLpB81NtoK3MbamQqlvdO8OqLPKcfmHX1oikkNz2PbJGRD
	Q5cDz8Qv9ASFcmRTEsovw23Ag79/wxkmHLOy+odMOn3KeNQMuBjTPbcLRpEm62Zfbi6Iw8nq9oh
	KEnwmNBUKqEideIEvLaCt/B50HvFyIRPwS1Bnv+NAQ9QpgQkql1u63EU0QRKPAbHWd1E+xR9PoK
	R8XR5VUVeEStJhl19t7SrsZ3e1GHZp/kLg7hKPEUpzI7z8E3K5ZhfR2NA7FKUcXciIp6LyW99+p
	4WgfCukd1J6V/CTV0Nd/OxnUWHK0OrKSFpdPmLlUMMgC3TxMmB+89ZB0Zgd7B3y2Ehco8XEKN2z
	46S+TGW2hAcOYfkro6xim1DqcwsC+lpk9QPCNPE4cs+xRJnunUPMGCCafIbza7LNMq4+bDYwOtM
	rYkl9b9eTY4tsWvin
X-Received: by 2002:a05:600c:1c23:b0:49c:eb16:9fd with SMTP id 5b1f17b1804b1-49cf820a8e3mr8535635e9.3.1788467852848;
        Thu, 03 Sep 2026 13:37:32 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a979-9501-3df6-d7fa-8a5a-06c5.310.pool.telefonica.de. [2a02:3100:a979:9501:3df6:d7fa:8a5a:6c5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48588394fa1sm1005070f8f.8.2026.09.03.13.37.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 13:37:32 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v3 3/5] slab: handle ERR_PTR values in kfree and hardened usercopy
Date: Thu,  3 Sep 2026 22:37:18 +0200
Message-Id: <20260903203720.63689-4-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260903203720.63689-1-kmehltretter@gmail.com>
References: <20260903203720.63689-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 74EA2100005
X-Stat-Signature: fdgrzhcd5a1ui8dyqoo7kijqzdff8r6a
X-HE-Tag: 1788467854-552786
X-HE-Meta: U2FsdGVkX1+JlLSxZQMfPfpNfJRTS/SHKf40mTK+MOHWJkChlXGcw1NAR2BpcRWHTsFVGvy4DdC8jYgTAXux1IUBqoRXFyFBz2Stw3xUUQ49IXtvpEky5Ne2YRJjTajtUeNKe1l/712AMFXxjBrGgZUF7Cj2MfD2xlJhVsCblf9LBZHTM2h+c1Tvt2ISgBGXsmH770XzTwCWoOBnHNaTcj+dH0za8zin6vL6ImbNQ0U3K7wO21pMoJ3/SfUDJjPdiyuvoSmYH/kxvmIMyNy5Vgz7XYfdJAJRYdw8QYcXgTVfGrpbsMwRoaG2vWGJ1LIntkAgsi59a8VebJnmM+exKLjOkwTcfXCq7gKi7jD5rdW94jIUiK5QtCj9AEXTQ+iLCgnjvzhAK4Fi1+CQhO1WHE2rxRZG2o++J7/vyTrNCM/A9gToxNZOhVHvJ1OMMB7XfrU+b7eynDJ+9IJgAQMZ9GOFpBKLnK6qctYTWLMh/LtH8jKgA8FfGbLxGZSiXeqy1/CLVT57t/aqtwhMsi7jS6IT2oI/Te086A5ViFQRs2UdZQc5EkvNXszDa2OHg3siTpt+/hGyShDxtE02EM5ndXDko9xQMSz1A89Etlmal86ktRbVLPRAA35oL/Y+TxTNGN9eia9ONPiwFDPq5wALWCHsXi2Hd6SeMDyQnHVABqvxjRAMLGtSgWscRHgIxuYmTsaYVmBZyk+RqdJ9/DklZEI6YRMeiRs+d/j63/dpc4YeeYvqUwbQW/JSCsniHH2t/fA72F5HERIK81klfsQMd+kGWdNlkud9j3vp0tBSoqNcZkZ9orzQ551hZRvNA6GsgZDKJ20/Vve/fo4BlNLzLaqfJCIXtYrppbcrhhN0nkCh7vkdTeV+NYFLD1LVvUaAwnnQSoM+a4XMRz5ElzBTQxUb/m3JHlIZiIKU3ZUoVMJc4e879eJA0acUmaUpVo/rD9RcFrowDxzkYuG94aD
 RakKmsUu
 WfbvHnZ3PUe6GWPI7+1Js3PO+fvEH0yeFIIudy219syyjErI74J/hKFrnLJGL5yTEOwwuDSkEev4DRCG2ShskDNur3LIy3r4Oa9chvoe82JzQxexz4Tmsmkov6cwZP2h9wojox/mroGxeqggY3rhvmMujA7Mg9wu37MiFgPBFxZB62gT+i+wvemdslSfj+/C6AiMOrswjq3y23Vg66yRLqhSDGNACMQ8T9Kp3UWbtpfCYZSNKXH9XYR5qUJL5/FHRk6YE4pLIu+fSIx+sJJ93FlKJNhVpYd7YTFQMN/px992wVVWuxoNZntNhlHnkn8mPGXLZGaja8Vm6RynbyC9UxIHPFO8tcJETp8X4DquMYKTpEp7gyGZWiYSvJ1Ju+ZkuO2FaPDIdnJWPv5F1bHE/1cSDCxw6/jsVN8d2Ayh1RKQbOvQLJQEzJ4uRlBakOheZ4538K6CPlCJXattZQsQQ9SYQdlL+ELKy2eGO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Passing an ERR_PTR to kfree() currently reaches virt_to_page() and may
fault. Warn and return instead, leaving the bad caller visible without
using the pointer as allocator metadata.

Also reject ERR_PTR values in hardened usercopy. Keep both checks
separate from ZERO_OR_NULL_PTR(), whose exact matching is required by
krealloc().

Link: https://lore.kernel.org/r/CAG48ez05QVn6_gQ2TBrRa1a_DWQoaSSYubUsu5YMWxx-gqMijQ@mail.gmail.com
Link: https://lore.kernel.org/r/202608111716.0FA9DB17@keescook
Link: https://github.com/KSPP/linux/issues/93
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 mm/slub.c     | 3 +++
 mm/usercopy.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index f9b56cb439e7..027b44dd7f07 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6780,6 +6780,9 @@ void kfree(const void *object)
 	if (unlikely(ZERO_OR_NULL_PTR(object)))
 		return;
 
+	if (WARN_ON(IS_ERR(object)))
+		return;
+
 	page = virt_to_page(object);
 	slab = page_slab(page);
 	if (!slab) {
diff --git a/mm/usercopy.c b/mm/usercopy.c
index 5de7a518b1b1..c8d8703544c6 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -157,6 +157,9 @@ static inline void check_bogus_address(const unsigned long ptr, unsigned long n,
 	/* Reject if NULL or ZERO-allocation. */
 	if (ZERO_OR_NULL_PTR(ptr))
 		usercopy_abort("null address", NULL, to_user, ptr, n);
+
+	if (IS_ERR_VALUE(ptr))
+		usercopy_abort("ERR_PTR", NULL, to_user, ptr, n);
 }
 
 static inline void check_heap_object(const void *ptr, unsigned long n,
-- 
2.53.0


