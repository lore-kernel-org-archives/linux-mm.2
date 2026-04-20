Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10186F5581E
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 11:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ED066B00A0; Mon, 20 Apr 2026 07:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49D166B00A1; Mon, 20 Apr 2026 07:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38BC46B00A2; Mon, 20 Apr 2026 07:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 242326B00A0
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:49:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE6C7E3677
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:49:19 +0000 (UTC)
X-FDA: 84678763638.13.AB99E82
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id F128718000F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:49:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MjnlEsSO;
	spf=pass (imf16.hostedemail.com: domain of 3uhLmaQUKCM0x4ExAz77z4x.v75416DG-553Etv3.7Az@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3uhLmaQUKCM0x4ExAz77z4x.v75416DG-553Etv3.7Az@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776685757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5qBi9ldbtbrcpWyzJP2C0tv/H5iabsIC81OiRN0uJ2k=;
	b=DFwL6gETR88Zhrle4kpbeUtXCBJQYFJf2aBzuVAQ44Yq9+hNI8zisfqgyrltAic9JGMhQS
	HJSC6NvRWHxcJ32opHQbaMH55iHuZ1cGOm6mqhOnSsKWITQrTHAbzKWiaWpmvIpWTY6rB7
	7OZ+S08a8/TcCtpLuntyBgCYUKX1VIQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776685757; a=rsa-sha256;
	cv=none;
	b=2zMS+1+nzHpnzYtEpz1LCx8oPVuXHt5TCl5L0f1wTvWcotYSbcAuidYKuUhtq7N/gbpaLI
	XigzXyeEoApr26kzj0kqwMrCwJUPtH6ht8oDUl3/dW1Frp5s8ML3xyY7MWj5dpnPfvM0Dg
	LhWLujutLnV99kgahPjOSScm+u46owU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MjnlEsSO;
	spf=pass (imf16.hostedemail.com: domain of 3uhLmaQUKCM0x4ExAz77z4x.v75416DG-553Etv3.7Az@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3uhLmaQUKCM0x4ExAz77z4x.v75416DG-553Etv3.7Az@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43ff19e54beso842203f8f.2
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 04:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776685755; x=1777290555; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5qBi9ldbtbrcpWyzJP2C0tv/H5iabsIC81OiRN0uJ2k=;
        b=MjnlEsSOosazTnT3lb3uf18w7fVjuuDrlVCVpFiwMqo6StRl4kTWYZHC9xyOmg+U4M
         wK2SP8WJzoODpbpzZhGH/NFVOUEWs7agS9BOLhlSMZ/S+2howJcf0cscu4P2ZibYo/qB
         iGKxeU0EjQs0loa8M1O3R9086lsA4cUA/7W7B9OzIGYl0rF1EthnxnnPCfxJVQoBeQhT
         QzflfsaUzli99ym5+X6TAVyeDQEd+NbFbY31y7Hxt3dz+2jiH2zUIR8ohDeLxhL3DgJc
         89tyhl+waIRtwOjC+ko3Kj9JCtj0IhiPKvinnI281jHiPkPjM/peM0XKX1bV0mMJBqZ+
         5RZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776685755; x=1777290555;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5qBi9ldbtbrcpWyzJP2C0tv/H5iabsIC81OiRN0uJ2k=;
        b=nAERuo0S4ly/eBbbg4Zluao0ZBWJKY6BtrcT2q63W6V7z5KnVnaxN/UYL0Nk/LFlQV
         Tkcs1hMtldKXUjV/9IGzgnJpJc3wEziMHq00Tjq3DyJEXniPTYJuCoiItx8TxDjYQ1nH
         eMKACFnkqcNqgrg2tuV++JhBrxjbJfNoKm4B1ijcAno+OhOJzb72XzD3f4NKUejpXSMB
         Vs/0mA3/dwf7N3Rl6DVuRdcmVMH+Qz1p1hfRSgN79HHM4Xf4D8a7oF5dWfd58+ZxIXnn
         PEUM8w6c3VcR0uNM6vdKFmq2hZdPZZ+gh5H8FryAniZxK8rvdN/kcmFjRvderYmb/4xG
         2xig==
X-Forwarded-Encrypted: i=1; AFNElJ/cwMM4E7xA9tXRay4QGr31X2xfFQE5FCKHxac1wFEf/rf72hmSX14bQigyav7hexGLviZYdAUweQ==@kvack.org
X-Gm-Message-State: AOJu0YwVh6L9kS92GyGQp+rA1XXh7Ky9NvVReVlD9waBuMabRaEqhhU7
	BgzhAmTlR91qdHHC+3Pq2vnHqn/VDTeS5ew8mUTo4jThBNJjA8yVTtpLwq27eiEtbGB0m1PwPzc
	bCg==
X-Received: from wmpv10.prod.google.com ([2002:a05:600c:4d8a:b0:486:fe68:2045])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8901:b0:488:d228:a133
 with SMTP id 5b1f17b1804b1-488fb778d15mr138129125e9.14.1776685754892; Mon, 20
 Apr 2026 04:49:14 -0700 (PDT)
Date: Mon, 20 Apr 2026 13:47:26 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc1.513.gad8abe7a5a-goog
Message-ID: <20260420114805.3572606-2-elver@google.com>
Subject: [PATCH] vmalloc: fix buffer overflow in vrealloc_node_align()
From: Marco Elver <elver@google.com>
To: elver@google.com, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, Vitaly Wool <vitaly.wool@konsulko.se>, 
	stable@vger.kernel.org, "Harry Yoo (Oracle)" <harry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: F128718000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 4mnyqyuxq5xifg44nhsa7n1s8jnz9oyq
X-Rspam-User: 
X-HE-Tag: 1776685756-245297
X-HE-Meta: U2FsdGVkX1/Bh9EAA6kStbAN8MMe+5CMlMIMrvzRwjkScoDIjTkDL2/0uMjYkpLr1VTw/hEI3s4IaOYF2/oOerz6uRUPhgjS5hw9wKEo2SH+VPHP/F76jmf4A/AqetDT06gbnTxhqjvYOu0Q7Uz8UQ9JTW9QUQ1Nmhw2CJgtBVQ3L6TR/fvlXTlFKtSBZF5NqdWtOZLJLScgOoMRKE6QSMV7Cb6oNo6kZj0DABkxPwwzlMNLxtuXqCnczW3Oq1RFRpNxnnx9lZluDCv969i1we0ZddxExbbwdjJV8q+47hybmRZfHKrq1GP2qlUDyxLa0dXCJuwSEHTrTkz2fUOaUwYelmscb87G/pkEhgZyb2RPKrmXdn/u60/gJAjXNhJf/21z/blMw0iFKPmkjuIVIXUiyEVgVuHfyAI7H7fvRhRXX90/havzgB0FVB61lzxinJ1nZqyfwp3lmycNt8UwZW2oddUNc5FqlsmhF0QQ7UB6fbmvF3q3RORe1sCnp/Mth3r1rWyibag5CKVKUp7H66V12SzYJUib/UykNMdPddbsBRSQyOr2UURaxaT4Y3DFqxkz7sNXphbCbEGeuN3XuONPnKTPOSFewHIWeGFDoL30p9we9siLL1uXpLq+xrKSIf+7Ssk00kRqcTxAE+4RszOw+WgK9y/7aZL5m+JCfwp+czuhbJW0CCec2P2lW/5O8SPA6eYoqAbbcfPcrOaw8YJdGvDVDtLVJbTDpVQsTC01aFL3i+SlT5F4vavKlI4S/2tH0Qx/QiudqKjPoSluVy/AHper0isesq/CGWyZKnj9QQm1RprnP66nAT1AVFakXDsUSd8kFrOGJXTclU0hOANUhmyu+GMb2IqxpcIMDxvj/h9gL3E2VdEuRTUWc73gPeehXwoQncgZbip6h6V9ojqsm/C/4HrhtzgD3ZpkfJgstafE7sS85YPAklY01D3//GqLdN62dQpGxZWCtgi
 Sf1DbSQ+
 v+BUi0wrL/YWp57GqIz+2qA0SvFgiaShcmlU4pF4EJJwZd5AbHxF4Dj4KrbJNjcY/0/uwdUVE4Z4s+Y26bqBTv69MKgZqbMotq4HT7HBrfl782b4CggsJVoylhsuqxtuOI1WA0ij5gM4nDtYEnVBhac8QNde2svO+NErjL5OOga+B0cMTb6gl0CIz+1zYHNotJr3itg+T+zss63dzEs1EJisEkKv9YwLSdQ89ExkL5RVnoGPAc7OLfMAnAEiMaJsHx6tZUewlFD08utdL725TWN+eN75KfJKQg8XvzY2Bn3YdwQywwerZL+sRRFMcgScTkFIHvx429lc1JZ1NViMPxIIZx8NI82NmQiiB7+m61pe8HdIIgrLR3LPPIn70kU5u0R2QJm1exg1wjAaS/ddriCKtPQFJQZ75Sxw9WlFxhwKEy/TCovRh/jLtBzs6JoKJOviAiTvQe1Z62E+ggpRifXxCXRQUAp0nt6E+ZSOWnYnvHihbPn4i05EAyg9BoeYRboIXx+gZLOSQmgjst/KhwFRz//6a9vkwEkLapqRrLFQWvEnoXIjoNgIYpRCQtPMixogHSkJypOgo0tg2SJ7+SEOqkHTaE+eGN+UXYQYJT+Qw17e+LTIW64nBVJZFnzaYbiIjYZo4yTbLet+ztXT8jNBHnyjrHKPw0Qls5N/yMa3pUIKoMLFqQQTskg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 4c5d3365882d ("mm/vmalloc: allow to set node and align in
vrealloc") added the ability to force a new allocation if the current
pointer is on the wrong NUMA node, or if an alignment constraint is not
met, even if the user is shrinking the allocation.

On this path (need_realloc), the code allocates a new object of 'size'
bytes and then memcpy()s 'old_size' bytes into it. If the request is to
shrink the object (size < old_size), this results in an out-of-bounds
write on the new buffer.

Fix this by bounding the copy length by the new allocation size.

Fixes: 4c5d3365882d ("mm/vmalloc: allow to set node and align in vrealloc")
Cc: <stable@vger.kernel.org>
Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Marco Elver <elver@google.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..8b1124158f54 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4361,7 +4361,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		return NULL;
 
 	if (p) {
-		memcpy(n, p, old_size);
+		memcpy(n, p, min(size, old_size));
 		vfree(p);
 	}
 
-- 
2.54.0.rc1.513.gad8abe7a5a-goog

