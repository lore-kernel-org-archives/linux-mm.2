Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D14CAC5B1
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637338E0020; Wed, 24 Sep 2025 11:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E718E001E; Wed, 24 Sep 2025 11:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C1D8E0020; Wed, 24 Sep 2025 11:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44CE18E001E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15BF71A08A3
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:32 +0000 (UTC)
X-FDA: 83924455104.27.EE3CEC3
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2DC57120010
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0p3liudu;
	spf=pass (imf29.hostedemail.com: domain of 3jAfUaAgKCDkeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3jAfUaAgKCDkeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oP8jWp4MkINOH7Jswzd6ZODnFl0qB6e1xzS3CEKeQl0=;
	b=pf4KXvo7mq1CiwwUmZMVjusyLx116cLNRx70mwJXV7pRpp/tPgqXmzBwyK/8yoBjHnY+mg
	NVei95FiGVl/I5KA2wAjBWVB0oH0QpipL3BG2VEhKu70v+eoNaMmkfMx1Vg0hc/Qy3HXKc
	cI/G+USTQzq/1OjujmHwNki+okpKb6o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0p3liudu;
	spf=pass (imf29.hostedemail.com: domain of 3jAfUaAgKCDkeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3jAfUaAgKCDkeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726030; a=rsa-sha256;
	cv=none;
	b=g18CbFVzWAFQtcG0aA2yb4op7oHIXpIbxCFwrWtS1G7DmtOKeliEOtCB9A06EVy3ngT8ZY
	nj6c8FpRquxvt6PoYCNjIKXxeEEBnDbgWNuqN0G8684phGIqzqR4VdY1em+LdAkumfGHBO
	TVSQOic1Bblgwx4nmsG0GC4aLrbqq3s=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3efe4fcc9ccso3363141f8f.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726029; x=1759330829; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oP8jWp4MkINOH7Jswzd6ZODnFl0qB6e1xzS3CEKeQl0=;
        b=0p3liuduHCUBzSH0UMO0aryAnP4iDy4pwXxHd0ku63k1XVS7BR6iQ+PqVT5ueTBFoc
         gAoQfocWyky+00QeOBEehAEcvhHDobKCAMyYB49zlmOR89Zl94AXCUzqtBfirg2LKvEo
         WGmCcfplfgB3wzZZd+BR7QVMaGMMLeK8XDSZ+qDxPjLAyfdomyChr2wQHCoi0qqZqFao
         wF7CeFSQOxuZ36qB2FLMKg9IIpmlNtuHrP+MVcIY0p0u98Ld+N8SUBJ0j0g7yOhiL8oe
         Bdn4kXpBdSoIqqJoeSfDWW/bhwWUspqO+d5uXqQTZfkXTUwvuri7LI1RR33MlfNFYj+b
         WFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726029; x=1759330829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oP8jWp4MkINOH7Jswzd6ZODnFl0qB6e1xzS3CEKeQl0=;
        b=VaGC6d9DLxuPaudjFObUrW0SCrSGJCAPsHeXgejJLGaqxZBYX+UEtn43Yc4yHCs/FI
         ea7dHJOnqntsMWCx2WoHNR91+m2QcPDA7XtkxGCLQKhJBOrSlhia9ZBodIjzsOoSv6E7
         Plbumt3uyzlu5tjEIPiUDMFz3CNpsU18xJY6dztD92aQOY8ZP+gAXo3d8tNjOb6dOugc
         ehEkcFztcAGXaVmWlo8gLO59vgMEFafT4khroR1KZ4f95u974FxZ6SlDVNWT51eoBF7q
         9E3tht11bcTND8kmfP+fI+qoVKxLeihPJNfSZeUS1eiMYWsRkbM+65RvAh+yN3ZbMvfr
         R9PA==
X-Forwarded-Encrypted: i=1; AJvYcCUFjP+IMoUI4OByhm0DXrf4N7HLLyxeD9d8J8dbBhCz7BVHGPsqo/+o2ogW3Wi0Sg+LsPNT/4PeNg==@kvack.org
X-Gm-Message-State: AOJu0Yzh0FglwfUm3A1PYRGsSo539oMAIcpPgph/MfyL6BhH+RxFv4i5
	/UlxG2GBbBef9jIYez1HIfvUh1LmhhxPfHKZyzI6WGWnCw+ETI6uIIm05to5G2Dli8dJOrI+h4g
	JyeDFuxGWuDwThQ==
X-Google-Smtp-Source: AGHT+IHodywAlVICR2SlEwjI/nDMWsb7c+Q0rCIs295IEGPrhzAjMAXo4iCffE/QGARjzAt8FOBx8w/TD0aqww==
X-Received: from wrvh13.prod.google.com ([2002:a5d:548d:0:b0:3ec:e12a:e26])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:240a:b0:3e2:ac0:8c55 with SMTP id ffacd0b85a97d-40e50f5651fmr215557f8f.55.1758726028587;
 Wed, 24 Sep 2025 08:00:28 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:55 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-20-2d861768041f@google.com>
Subject: [PATCH 20/21] x86/mm/asi: don't use global pages when ASI enabled
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2DC57120010
X-Stat-Signature: 16c96i9dhkz73xr9h375ys93zyhirzxc
X-HE-Tag: 1758726029-249755
X-HE-Meta: U2FsdGVkX18AJMMPB4IjdS+SQsYBRRsiCztEyfey0PYbpaxt5y3vfCuzHH2fRyBKvnbASEl+48jRPHOY3xnn+28cnSYcAcS5VuxpGGIvp8DCCEzhA7i0Y1pd1a4kDwoYGPcyYs74w/xb1FAzNAfEMk0Kboy65DjcGDc1v7fsG5qyga/Q+Rk12nb/zPcgrS320L1nwRSWXNGuJ0x5M0KMjHUCiFsvjU0/lvL7uOXF6pvy01S2qM5UNPIX7kQD1pRLtn3ZsgBrtc8FjTv7+79/y3XgHGUA6gWYoMlMCJ3/LXUCiad+VVPkaxBU59fwSqt0W6EP9v4H63RHYkmD1DmleCTaX5gn+BBJIR9/soBkIltD1bnAr2K9ySejCsjURZWWLkrSeRBaUNZOOGSZatSRlzjx35mf3Rplk/ge48gIFHRm5YinbT2ihnL+W9UC8CQ0OioJN7800nGtFG3GLwHu14GdLAvogAIMyfcYis46K0ujqd6hpxYlHHyZ/XWtGD5vHS9I/pgf/vHSKtrcAWrAaru6ZkhWISLUFTxRwKiNW9HlgRizpWgmjAtM9ucV75/1x7K3yTCsKeHjwNxbM4gl2Nr4rhwwME63F3uKFSNxQqD+R8+HQwXkpYS56Y6G5FRj2OIKdu8WV+F2FOkFJLlmFHZaRQgIoBALpljnHdzeDXc6ctMh7pkM/RiJfSOSSxDNJuV89Lc6WH50+PFaELLxiY+JPFoNzBGg0tUTw7xOCRf0v/TndYxD2TYzInW99dLIHNPlDrx7UlB7jkNTfRVNGc/UQ/Tj56/CFj+t4RPJtcg8l10SuVaDx83QzHVsn1MiwvFMFomKM8gWWOELgXtdkavEgjRPUq6GS1Bn0vb4YoybFWUHak/2p9i+lLJfiKID3SZsx2Y2o6xKr9Ijhru56GgY0MoxoYjvNKYYDJTDwfiUvRGSnqBckLxkm7FohPaB3XmqQr/0wBZmyNrS7Ya
 mvdyTlLo
 /DnfM+24Qa9EvtW2Ody0Rd5JR6nIC/QaCh+TgcSReKNY75Q4eAN6KYJkvBjpKTxbEBWdjI/IzO8rHFzW1TP+i66g/IyJxI6eHSnPMbxg9Rwjh67fZdzbtHE834h4jE6TGavQDpTc8NN0jSGwa2dlHNNkYXtmSYiJ2kENL9S7jmihZUldiC8FZf61oBtNINlwwSDam0tg8g9bE/RrIv9rs5TBtC3H3Gfmg+WotpdKxdoygfTRo09MaFAMd6AJBsMKHZ93+QzpBGvA/jgzwF4YkRlQjbsoPeuvzLBlS4f0zwf6YDc/w1ACDleuaNE6Ky2+yW/c0PnTaeuVCNtM7n1ZnCk1jKTzs9QVl6SM3JEZrOHdMQCRUGbe4J+bsX6sd+PfQzjsRihGmoYYOHltm1eiyT7bMVXXl9cAVSp8aXQy4XVtmewGYX0p3HUX92xdv+2RS53Om3cBuzaV7G9r8s0qG6XcTrwtPXyuraN7PRpvrhzmGQpiVQvkOLK1KMY9P7idCJMPWMq9uam4Y61oGBjC20uasH6TWKLg61jmatsCeG/NSRzvv6/tZkGJ3NA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the same reason as with PTI, ASI means kernel pages can't be global:
TLB entries from the unrestricted address space must not carry over into
the restricted address space.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/mm/init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8fd34475af7ccd49d0124e13a87342d3bfef3e05..45bbe764ca4e0abc13d41590dc4ff466180cca31 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -249,8 +249,9 @@ static void __init probe_page_size_mask(void)
 
 	/* By the default is everything supported: */
 	__default_kernel_pte_mask = __supported_pte_mask;
-	/* Except when with PTI where the kernel is mostly non-Global: */
-	if (cpu_feature_enabled(X86_FEATURE_PTI))
+	/* Except when with PTI/ASI where the kernel is mostly non-Global: */
+	if (cpu_feature_enabled(X86_FEATURE_PTI) ||
+	    cpu_feature_enabled(X86_FEATURE_ASI))
 		__default_kernel_pte_mask &= ~_PAGE_GLOBAL;
 
 	/* Enable 1 GB linear kernel mappings if available: */

-- 
2.50.1


