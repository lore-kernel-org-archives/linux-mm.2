Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80812CDE00B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 18:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58DAD6B00D0; Thu, 25 Jun 2026 14:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D316B00D2; Thu, 25 Jun 2026 14:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405216B00D3; Thu, 25 Jun 2026 14:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1280C6B00D0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:49:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 843C140252
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:49:06 +0000 (UTC)
X-FDA: 84919322292.08.598BEA9
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id BF3A9180009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:49:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qi5HeTSZ;
	spf=pass (imf06.hostedemail.com: domain of 3Hng9agYKCF0NPM9I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3Hng9agYKCF0NPM9I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782413344;
	b=iMAOqlyiALBIAfjy19BS33RH2u4zA+3nRoctEXi3KfFm+egekcRwjV3QBIAjLnGKtb720r
	/Iw8MLkXhFFrN7fdr1mi8AHZJcDIK2gsQop811Wx6nxnDBitiIavwIASULGyk2L7PJhWLK
	d5nOuU8ifkoxMpiDk0D/f1lga9LGs4s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782413344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUBS0rLb1BujonsJ9pkTL2EqtvM8d+PBVmWaaYJPOu8=;
	b=kBQwbMXV0tLFPqtGGvVHtVP6dArcSWKaoo2xt8vVJjheyCkvw+Y4wIt4RXiMQBaF2ELmTb
	e95XCAvRTENLaUsJHnJAPdol7BF4pOVFomTttyPd5tMUYMiktt0Pg5dwPf5cSswHc/I6jF
	5ZochhzKAQIli//KpxOO0kEKlRrifKo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qi5HeTSZ;
	spf=pass (imf06.hostedemail.com: domain of 3Hng9agYKCF0NPM9I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3Hng9agYKCF0NPM9I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-137f3465368so331248c88.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782413343; x=1783018143; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OUBS0rLb1BujonsJ9pkTL2EqtvM8d+PBVmWaaYJPOu8=;
        b=Qi5HeTSZJMSyry+JETMMbWVZi4TWYogw2vHXB35LehShlpuEnIP1PHRXUrC21/khCA
         3sNKEzy0i048JctdfjrAwdYj2WCSsWptIQwzBTPMg3CV+AiooxWZPrNzxVbjxJCbGtmb
         0eUL/SEafeYO4hT4kE50NzDnzTXDZZeMSVcGNKAwQ+49W1uWsxtP19bwId+aWL3OyL6p
         E47sVkopR8ZVfL/gUF+2yw9qOMjd2WVATQuGWlD+pCX7C8KeEf9WN2eigklpsZ1c58Jn
         EdRy8tnQBf0BHVGtSE3vkyeRroOoAMPWzW4yE8A1kthz9ytEN3DyEv5j15WOzk4K7sFo
         anEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782413343; x=1783018143;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OUBS0rLb1BujonsJ9pkTL2EqtvM8d+PBVmWaaYJPOu8=;
        b=VgPVIHlENpx5LArd9Jv3lZgngoun5x/t9Wo/6Rnlo/6uE0vpTOneDfmgkM5tF2QgDQ
         W0mGABTUTky4VcLGjCwphFA9D5ZrglxVY/fCV4fQ5aS2T/xAQ3m82FmJp/X4/MLNMVuJ
         9jh7x738qOFoSaQA7MNdMtejias1MwrHXUWiRxVDW5AN7OaZsI/KjFjctSRkAHyv60Bj
         nAcBpItQtFrk7n37TstncQIZLoqpqXyWza3MMNytnNvUhSvQaEdsEaf3QrV/pHblRYE3
         GtZ98gzX62JpWryVaUbehM0Bn7AJZYL7VuwAF2Je2Ubid+//FrAp712rJ4fEALGu/Ioq
         PEXw==
X-Forwarded-Encrypted: i=1; AFNElJ/SGbXCWUyF9fuj/NwDGbrtT4Id58QSzfszRuC0s+5Tifls3p28ncSHFedxxhbaTBql4mwOm1949Q==@kvack.org
X-Gm-Message-State: AOJu0YzIYJA9iNQnvPKeG79nBtXz8UCVaFEc+sfooEQhjM/ZWzpCIOf7
	Ja9nfKI04oJCZYYIk7YXvgRiMxz4G1vHFo884SBW0CFiQAvKnXDWwO90EZz2PbNCnny5tbs1ujr
	25uAvag==
X-Received: from dlbvv17.prod.google.com ([2002:a05:7022:5f11:b0:138:1684:5f4c])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:672a:b0:135:f5ed:868
 with SMTP id a92af1059eb24-139dbb91e6amr3551697c88.17.1782413342934; Thu, 25
 Jun 2026 11:49:02 -0700 (PDT)
Date: Thu, 25 Jun 2026 11:48:56 -0700
In-Reply-To: <20260625184857.2193482-1-surenb@google.com>
Mime-Version: 1.0
References: <20260625184857.2193482-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260625184857.2193482-2-surenb@google.com>
Subject: [PATCH 1/2] MAINTAINERS: move inactive maintainer to CREDITS
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, hao.ge@linux.dev, 
	jackmanb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: BF3A9180009
X-Stat-Signature: n7uwqu6hxbzorhfjf11u5m8qzcg9kawe
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782413344-841129
X-HE-Meta: U2FsdGVkX1+mJPgsLzYdhDN4vedE5TB6icEWytt+7p2QReQOB0ysPjHc07EfCR5etDuTg5CfAbVqAoyNpBpAgWuyUEGNoMdOIHgcQr/gmeDkNkXUyEQ+FJZQ1gPtpAcKIvo7Md2pmLulYMVIdSKbqVI0p3DsBVOGQrWrghEjdMF+NHAJIbyLj3GRvzIMoNe37FXa6YGusCoAUPFWUfRhGKIBolmEtcqcXFdLgWnBTZ4LLEyJma/aCsZHhIQg8cCWNxk6yHCRGetmqzWdSWfVhZUwgLInsNIe8Dn5enWUBWFqmdwouD1OIOE52ME70lg+/hRWvoyf2XDspdq8DbetBnGCdJRAJfzgAplfpA/mSJ/wYcn3TLVr/sLngDtSitS84W7YJw6IWk0SW9rLX/ZAzGmfqNCW8Smy9/JdwLFgL+xo02iARfzGVXWjwXWgsAQd+9TvMUoquXDoICHjppBUNb05eVgmxbdeWgI+0cLgate+zC4s7yErEKVsx5vm1hrM2ZQkVI5SwbIQfKtNEV2sswuPs0mjBBdhrV0eH1c4Mj/Pcon1YAKNlRxt76Ws6nZfFLThnNUnQGg8Use6MTQQCBlLa62Eirip/5FhQ9Rz/h5Jrm17GfedRsPk+Cyl02lacRpr21gylDJgBa/o4/ZpH836C7r7L6l+AJzc8lDlTd/iXFCmdAJS+CHFEJYKIPAG0ZuTakDfUQ9EmwrlFmrKplmFtbF05ykJmDAiBOx5ohZdgnKlm5GMVkKGODyOnnmrf/jSdiSKhN+DXB+Y7kujQkw4YivJL6m+by5wo6powjNRbMA/iOBhpByHmYkwzZ522mF21III49XCnM+3g3/lwY48fSzgN1yt+x1BkywsWhGuUTOPoMR63bHfKWGZsJOYQ/tyC53CZzaMlH1+1ntdlvTT8ofmcwoodIY6G/x8ZKqWpONICgAekRsQ/eTNv8J9AWe01DqxmSycc4VniZU
 HmJI9zt/
 QkLK8ZfobmjNqePoqxa1V/fuiHF/pEDgeAfpINialXuFdRd5czpnd/KL1Jl8M68MSbANNunwrPYOHMhQQDHcQ6yVhxkiD8ofhaq7MVvk+FuUq6GCPjNqk7FyQTn3gzUlmYVT74s07QHSOtPz8GpKGdojvCitY3tf/eGyPf5dVcw5gMazecjtJslcNIvsR5clQelvNgEZB1BvNcJonFIDLHGbM59a1bFWJDzJ1JXrjD0CSxxLhJ3JmTbuvD/68sBxD+LEsZ3tN3jvqrAkweoVxamf/psUZNjWiaQhy4da2RJhqBhE7sHNUlZulmz8ZrAnz1TGYtt7TxN45KoxGXTokKSEOXbFZOadbbJhTDWH3gLLhzDGt7sBBdWkm5t3qEBFqcYnN0efy87gzMV0CDlg3qgcyyUqemJbo0M9z53b2z/UnmxJgD1M2fyIX/8M53zOJ6HJ8D0lLXGFQ2PHh/K9/EXzcTXDDP/O9ATCL5qJAqYR/Xbf1X1H27v3zJiPmEIusbo3+cg6wDM8jCC54QQavkv41F47MmPV9SOvpYYRsBBpQcXFBYHXt4BNS2xaNOi7EmNAJpzLNyfiq6H9spX/Il8DWYCRc//uKUAqWQ5Cfq7qq4rQfnetil/F8wZ1Rv859KopV9VyW/YWfm/oaqMJq5xqIROS/6+gWc0Ka3rHnj7M9qj2LyVovIefmWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move Kent Overstreet from maintainers for Memory Allocation Profiling to
CREDITS in recognition of his co-authorship and contributions to this
feature.

Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 CREDITS     | 4 ++++
 MAINTAINERS | 1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 17962bdd6dbd..9a3e4b639505 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3091,6 +3091,10 @@ N: Jens Osterkamp
 E: jens@de.ibm.com
 D: Maintainer of Spidernet network driver for Cell
 
+N: Kent Overstreet
+E: kent.overstreet@linux.dev
+D: Co-authored and contributed to Memory Allocation Profiling
+
 N: Gadi Oxman
 E: gadio@netvision.net.il
 D: Original author and maintainer of IDE/ATAPI floppy/tape drivers
diff --git a/MAINTAINERS b/MAINTAINERS
index dd963b72c614..0948dc573744 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16706,7 +16706,6 @@ F:	tools/testing/memblock/
 
 MEMORY ALLOCATION PROFILING
 M:	Suren Baghdasaryan <surenb@google.com>
-M:	Kent Overstreet <kent.overstreet@linux.dev>
 R:	Hao Ge <hao.ge@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
-- 
2.55.0.rc0.799.gd6f94ed593-goog


