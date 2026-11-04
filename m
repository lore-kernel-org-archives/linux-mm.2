Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1806606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZrxgHQRM
Received: by kanga.kvack.org (Postfix)
	id F15416B05B3; Wed,  4 Nov 2026 09:48:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5416B05B4; Wed,  4 Nov 2026 09:48:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB31E6B05B5; Wed,  4 Nov 2026 09:48:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE9A96B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:48:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47A054076C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:48:09 +0000 (UTC)
X-FDA: 85397716698.01.2C2F068
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf31.hostedemail.com (Postfix) with ESMTP id D475920002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:48:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZrxgHQRM;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793803687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gjoFlql1j75pc12XdJHKWu97116XlpTwWzrWzwPXnYE=;
	b=bnj00xaec5FCoYbnYdMi8Rr5zfL2rXOnLIX4RT0IBEg8P06T4QL6dT/fgNBNEkoUNra2RC
	D5FymJ9kIqiQXq6AP2W5aUhfcyn+ZhP0ZTYbQ6kY8bajxaFeynPzn0gl1gTaySJXx/GGeJ
	Fo2w0sUTYF+Ba3f+xzRL6H7Q7IkSUBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793803687;
	b=1j/2oOz006kl2aEQLh2494D7r6hA5zoxfee3M13X+8BY89konMqOdRoresyUHFrNFF5d2D
	bcEmWZ5ShPOjUladGqnMiMSA47E5yoc10/Z/i+9NlPpmTE/Y0sc2LG7l/kSQyLSS7NEojn
	Qkv0QOA4EazKeS8O9yeJ0Mvq5VS+KYI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZrxgHQRM;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36d6765756fso514049eec.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 06:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793803686; x=1794408486; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gjoFlql1j75pc12XdJHKWu97116XlpTwWzrWzwPXnYE=;
        b=ZrxgHQRM2+uc7b3mM0XA1SNvvV9lZ8ohDg3Jb7L7hjGI0FqFc1S6enBoip64KyJREh
         50fVI26Ca86UsbC/u4gyOSOcG1cKxTxtSqvqfdY1OOhwc1SEaY5xOHZ1NfbLlrdoNxPt
         8FQtfAGe/cWBGuRSG+pVyMI3ktaCgF/ICub/mVHHF0z6+0mtEoyppIpOFogEl1y7g0PA
         Vnfz4G6dk9Mhsfdz9cTnv6lZZaPJY67DXM+P5Vh5oKCL9usEFptrcWCFHsz+FZb+bBZG
         2kim7QnC8pY+bnH5m9doj2iZb/MJe4t3UL8edGmVHajGXc2WIF1WXMbcmwYSosiUFyxe
         TaCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793803686; x=1794408486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gjoFlql1j75pc12XdJHKWu97116XlpTwWzrWzwPXnYE=;
        b=V0TuLmvYFWnO78rqqPGvO5BrCJ/Zieuh1DfMcxf/TXxpUXQ0TwuPf3FHpm/gVaS4eT
         W3vtwHtVijGrt/ZoRGjFEOMhuahZKCnMPFrG4HAjNVILmuE0RhyHw39/6k4Z08IQ/+NW
         wh7BbBMgIDdaZv61A0qJdpB586Fmx2qPNfeoa+pgS9M7yvSMMg4jM5itgjtOijq73sMu
         ycK+w25L93f6qmlIZSumhi70CdCPBdlzZApEnwtvrYccMMBMPawrMsbUf6/6xrXHWvqO
         rQNuzSHIStIThidXXthaaX4+H5CuyLDBjMiRZh1MDG6t/J6D6HOHMukSi7Bj7kTvn8Vi
         awHQ==
X-Forwarded-Encrypted: i=1; AKwUvBw0qk5ujtlBz3v0W3gXJ7ZikL0Z/YvzuFsmTbRqgDNg/IweTQdQQxVpKuiz38E3u+LHcXqI65zaaA==@kvack.org
X-Gm-Message-State: APuU4Z8foLYZkHceaCGh/nFEDfhqazPs0u/bakvx/XaqG0ZU05rpb1io
	p57HHrTcD/iHMf4k3eifWb5DhejGXoKYtLlFTO/QKPBiEdZr2t1Qvfq2
X-Gm-Gg: AYBFou270nkCkiDavuVJBA4ue/bDhLCCunZ1Y8IPSB29gf6bhOFccASdmNIWrcbDnQy
	qJ9VrXycP4xYZgq0RC6Xo1M0zFyz69miPE63+VfM6/ByeqV47va3PIFKX9pvRyRRAQKy1EwhNMu
	OSyzBB85Ep/rlbbEPf8vROkVJBYWe+p+EtYLQZyRFovrO98eolF9Qf0Xw7FaJwHyXCdwOpq8l6z
	mRpHkgVX+0D1cTTw7+dlaVHKBYzV3o/H88wv9TOd+jbycYenW12PcJ3zBDqd9JDPJJ5y+KJUVDV
	8bxaIWxvrWVVHwfcGZMt5bYlip9ypqvd5KkyM+5OzHFCAw05sTiH7XP+ch9H6TGX3n4767HgFfd
	dfnGcBtH15gX+g+r2wdzMKZCmbtncFD2qRQHZ5vY7Y+wi5232Ks9/mHNWnLbRwCKJnjbU3LJPDq
	EXIWc8NhfoyEIIhkyfR4YDQ/pHO7SpZ19tDQypLTqBNqKy2ZGWHve1iyt+ebQSzLOTc33UuH6YY
	rcxBVDlxzpQJly7K3vFZJPXbOTN+rPG5Xg1POouzfbeHy3H+a1BP4OF8sJCh+w/PwNDCxXcGFA/
	RNzSwC44TXJsfBfpi+GQ1Y2RKz7B9oOclfcP2R7FE/NnEpsP7W50
X-Received: by 2002:a05:693c:6092:b0:35e:5ca:e0df with SMTP id 5a478bee46e88-36a424609c2mr29635283eec.35.1793803686038;
        Wed, 04 Nov 2026 06:48:06 -0800 (PST)
Received: from ubuntu ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca39b8eb3sm10742548eec.27.2026.11.04.06.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 06:48:05 -0800 (PST)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Hao Li <hao.li@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH] mm/slab: remove outdated comment in create_kmalloc_caches()
Date: Wed,  4 Nov 2026 23:47:51 +0900
Message-ID: <20261104144753.2266231-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: wbkc8ntj44ec9e5m7w5b3he34gosib1a
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D475920002
X-Rspam-User: 
X-HE-Tag: 1793803688-497520
X-HE-Meta: U2FsdGVkX19fq9Wik+CiPRXnEr9t2ASVjbdyVkOnNakas0cpXBU4fjz1dGVrxWGQMf5OxZzrnqwjJfOJSXkkPXSCq8vg1JEySPyz3Yo+KDajZURXZ6KxZv+ZoQ5mCiOWNMR382BgvzUPkv8dWDLfDEe3aHpXqNlk8MmKFA3+3UH867KVhKtTwKJIm5nhXgkMfaL6XLGZuKLpB7eBXm6HlefgXSBG2G9JKAhzxOjQT8r9xQ6Ss4hDDZwxDyFrnzXHkxE7aut58sZ/ka4T7Gw1xRD/fUTj1qXL4ndlq+eTCgrkhpESF/tWKPOL1Y816ggtDVB6Wad6FsLsJoYXCSgBAHiGNzjiE7SrrU3MfZdiMxA149K0yZDz7hYQJs2ZuLdzEBayEbc3xt1MBpHxSxGVtOBWhBu5K/CZ2WPauJAQkPpXvL9RHZysw5A0oMsMP2UI0ta89+IgmTK5XcJfTmBcPcp8Op0mqg4fl71Q7+DD+w8WL2NyUlA5cK+bUXqHmOYrgjgFhG3B//HQ4ga3sCvh1t+hxF3PtEs+JBrVdDfI1m5MYixL4p7mjFkc2eEbjfP90GRlt3PbYGmhm1C3d3eBBbn2tEv3AdqE1bzLqJPJQ54HQL2ISQMV8YBx8SKw28PbzSvW+BY9eKrj55ioHMxsORkJN3Py494DextZCElzcAX/eWPZH09cZUOgYKyDxGZkOUgRT7UUuNyoNII3+rCCQOeQTxJDcg3tpVQphCFUpTQLAiL5Trbv0j577TomPma2a19k1DSuejdIN1G9k5rfny+cm9vAhdleAfqKi+qAx7X26BbidtP4LJP/kCU5XZOHa/b/LRtzAOChfJQ65ZaSDVYc8clxVJMWXrAoaYHszCmavCoIcNulRV7xudu0UWNnjTPWK8x7hPpvL5KXGufV55Q3PqokBtnVpoTprI2eJRrMnAG732LlXqpE4GcwypsdF3ET4OwNcLo0P/vkW4J
 ds95OiRD
 lLi2tnC/j7yoiMTJ/MHZkPrgMOlK0IUnNeWjH0x9ZsuCXszz1l1pwwb2dg88TUkVjtEQoWQkaPBmQtX5GA3bx3Whel3lpdG9Aa7GdTzjx+lWFhKLQIJeE9KoppE1ysxfaMcka5nI6KiaaL4fDofE1j61QrKoEWH87/rDYok/UND+3hiTN67oJfdkiWncmH0kx0yyfSkMfQOT2YsFt1kGggWGhzNP9zEGtTi0CJEl200eSynzyZPB/YK1NnJd7Z0ukiJVLi0C7JsU9K9vyFDAGLKWFLpG4N5bWeTzqjiqWcxXoTJbIYZ9F+VnLFWJ5cAu4Mn3+OucQ5//+l/r/wefnxbh1bBB9ZKCtpm8B+zPCI9xpdf/1T9MM6nnUlBPxBaHYwuPDvOJy3nshAohb1Bl6FPWHb4cZ3SWmRKNKHOTl0f9J3/oF7BOC8lIbGUvjMKc1Bc99Hsc3USroVFg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 16a1d968358a ("mm/slab: remove mm/slab.c and slab_def.h")
removed SLAB, no kmalloc cache is created before create_kmalloc_caches().

So remove the outdated comment.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/slab_common.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index e66c0778ee98..c4a386f0dd90 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1029,9 +1029,7 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 }
 
 /*
- * Create the kmalloc array. Some of the regular kmalloc arrays
- * may already have been created because they were needed to
- * enable allocations for slab creation.
+ * Create the kmalloc array.
  */
 void __init create_kmalloc_caches(void)
 {

base-commit: d15d7703166daf7bd62c844a3cb1b3a6279adb4c
-- 
2.43.0


