Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34D1FF589AE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D55A6B009D; Thu, 23 Apr 2026 08:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD7B6B009E; Thu, 23 Apr 2026 08:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ED356B009F; Thu, 23 Apr 2026 08:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7826B009D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:25:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D3881C001F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:25:56 +0000 (UTC)
X-FDA: 84689742312.14.512A2A5
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7AC87100014
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:25:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Wlz548De;
	spf=pass (imf14.hostedemail.com: domain of 30A_qaQoKCO0bRaPeXchZXVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=30A_qaQoKCO0bRaPeXchZXVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776947154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oCWWahIemX4BzZi3Pb2z29oKLrHnKRsi0RRUy/lRLsk=;
	b=JlY0eRD7Lg5v86thlj5NUL8/b0oOuDvAjIJv15Py7WmseERke5zE1jp17sOgx53mj+lg3Q
	pH6gG4wVWVJXl8XOY0L0Q05XdjGVCiKxNKHubhXbdswentzFILrK4kL1fVaC1b0GA7H1rG
	DojG6Y7ss91GkQmcJWh3RgWI4QpasIQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Wlz548De;
	spf=pass (imf14.hostedemail.com: domain of 30A_qaQoKCO0bRaPeXchZXVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=30A_qaQoKCO0bRaPeXchZXVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776947154; a=rsa-sha256;
	cv=none;
	b=7QM/JUTmBYl3ddSAfv1yAHy7PBPL78JW+PAarYZ5+hbNqEvfkJsYinMcb3AwFgnlIwRCAo
	FPlVKzV4qiADi7xlzibOREwE+dBgPjW+JLfLhXkVPicehDL7MM50y8cW5eoEkyRe55GBQv
	WlzQ//4+s7lMJB4TSThXiWgoEg5TAXg=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so73789595e9.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776947153; x=1777551953; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oCWWahIemX4BzZi3Pb2z29oKLrHnKRsi0RRUy/lRLsk=;
        b=Wlz548DeURAsTDjMUGnPd/atXR8sMIIhKMmh8J9OF5xsFMXBX5+LvkM2bdiDQGOPho
         /jggKCvS1HQbyoVdipqbLoAQVxVEdA/SUlxGbjDWIGaLK636At0+LXvkq/Nxr86h/jBo
         rkWBycTfwuzMxN1xrDipjrNPgBa1qU8gL5CDviTFDDpWyGaomwTv8FAtfg1I4ek6JjZQ
         Erkw7PAox6R9aNOl6MDeYeUxJMz1TOyaNpDSmtHBBI1/7cFN3Zm29gEW9XMll9cXKzrg
         M1PKJpKCdzVC/RwuCXFfbzmjVq391S1s6Ji7EVgS+NkltW+/yJ+iEfYCbyuZLw5q+Gl7
         chVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776947153; x=1777551953;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oCWWahIemX4BzZi3Pb2z29oKLrHnKRsi0RRUy/lRLsk=;
        b=c2euSo2mdmWcaU6hb4Op5cdDQIi/RkB+QY7FiXfUcjvO9srEAIQ3qYXAEK9E433zoB
         yyWNcn7KzDBbXyH8Kj9OMTM5GJMicGXzz+xI6azULQ7xU7w+boqYXobbO+3YLeAvueLG
         O3m7ngdgdn2oR2eM62wUtbJOE1Jh0VzYIJEtOsVBRjjxbJLpgZOV4C+UbJRdHBL7FrGk
         lMB07QmnchdBDzJ2RN8wEZkJdUB8AM8pt8ZQom9EQLFYSrHOvDYUTzozYuj8K9HSMxNI
         IsK4jRIqcSOs58IRLdhpaPAJMv+iEg69D+rTvmbfCSutmkcLdeafKbDmH1Ef13EN0oI5
         vUHg==
X-Forwarded-Encrypted: i=1; AFNElJ8h6QzZUG0xq7X5XVFFdXX0568RT+LQuQQsXnriokmzuohBYCKxtwJPCCwiwfRchbMKwkNUnC97pw==@kvack.org
X-Gm-Message-State: AOJu0YzSNNWFqZNkKBeAizVrILzdJSLcAaZ5LRcjCsezKA7o+6gyOvbj
	vw/fqpOmLNL0if11KWUZA8HIMWi33+Vp/nOcPFZUJXDLLUUjpyndydeOASbP6RZGmNlkF0x2b7/
	Dr84hRMYWFysIQMxTBaTdlw==
X-Received: from wmbdx21.prod.google.com ([2002:a05:600c:63d5:b0:485:2f1e:2ed5])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a103:b0:48a:58e1:6d17 with SMTP id 5b1f17b1804b1-48a58e16ee0mr105282075e9.20.1776947152925;
 Thu, 23 Apr 2026 05:25:52 -0700 (PDT)
Date: Thu, 23 Apr 2026 14:25:38 +0200
In-Reply-To: <20260423122538.140993-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260423122538.140993-1-mclapinski@google.com>
X-Mailer: git-send-email 2.54.0.rc2.533.g4f5dca5207-goog
Message-ID: <20260423122538.140993-4-mclapinski@google.com>
Subject: [PATCH v9 3/3] selftests: kho: test with deferred struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7AC87100014
X-Stat-Signature: xdyh5s66rqprzug4z9c9hwkgf9uxx8wd
X-Rspam-User: 
X-HE-Tag: 1776947154-330837
X-HE-Meta: U2FsdGVkX1/a3PIn1tGtN5IfqnWQidIazojzwwg6bjaPk6IkoonUT7c1JroOKMS563807lSyMLIYy4zrobYro8/Jv3p8PSD1yR9boV9gl/KRp2J8FWGIFBVnVJdqXDMCvfPAogQMaFiV9mD7FHaHHr+jA+YSCH5OKYXVXKpYN0tujO/6sGnCcTES6Ii+j7xvAQwiNSPKp2En6+icRA40ZIAbNIQVW5Dgz8XjrSlGu0By5bZwV4WHk0g6JLEZlWBB1xxEurQC1ENHoTH84tEz8CQV4JuUaYIRFgRfOTAj0zKb18VlSmYbFyksA3YkYJqULbkjC84BAniVLhmTQFphfqEPtPfgZOL46Mo2TNoa1P0dOTrX1CXhzoL8c0k/gpNLBvo9+itiqK4tlPtZIBvRpFDSeTjLWcccifQwCZQy9jQz7/qCGgopUajdvZo4+oEI9YYmITpg7MH6CcyGEFxZIsa/uH3qXgaCH8Xbi8RCw2kqV2fpxVoC1FPanpVeDUvpr/to7rQPL0kJRuAnOnlHhItXb3sEnHI9j+vWtXZq7TbBFkB3kq/DqOYUImIoC6SfFvsXN+cZYLEWeTLx2wfsqpieWvtwl1lQCUOrl6pdwNZ+D1w5Jk7CoOyyYzvTSJZR2hPSlRl9cvUFiP48xsf88piza1HQ8EY3cETPn6sGF5Y7QY1MTn4dHIejCsA7jFOefj+f/S3QOPThq1aeFyjIjiqySLzWplY/aoofK00ax8k79DfTGezTEwjyoxM74iJ60fG8cFNbUCtTmf5nVvd4MmbMMajguWiFvyScdqjLEM23yfgO/HdgrHXbW0cSOO1OgSnGJnNJ9oRf6rYJ2awMagf4CpN9mswZ0hXU/RptR+b+qUbPDSQaM7CKgN6qwTU+oA5x2WJOARiYrL6nR+s6GUUtPzfaVzoCiMPdgLEC3ZCDEMASQQDqlv8iTSAbbvK3/XaAdS5Bv0DmlQI8RiH
 turdjtbU
 +DpsIPOrsv83h0p0OLvGH1I4uX+7OxKRP8ZBAJUquF6mmTO9naiaHPW27dxMm/HnG3hUmc9HK1JeZb8mHYNsFqqcWMfeI3xxC3pUTQuTN7PihPeTHdgOFYoStkBA/TO56N9Hmywlfz8nJKjKYBw2L743yF+ys+AT26pN4Ue9jv+9zanMa85wOEZUfROK7+UfclvU7s5CCp6GXBz0vpexpr0NaP4GMlPaFshoqkW/9MipgSpCsS+7vobxlraABERbaPP6aJcf10zYk4/DBg7WkKimiTk11TOhUs1EG4HbrEui5ag0DbRFDVb2w06lEuPvGrzSi7SqfJ3nexwSc+Ab/R7QiuEF/hrT+zbJMgYMoPcyYpAAcrkHnLI67KQHIgUIP87jKlG8st039KzQ/jk8qRFwWkvnZ7T7mL1gh324la2AjHIM2H18n3TAKgpnVnTVFE+KGLDT3ziy7W/2d0F6oeXn0q0HdI6pPdw6ja+3pwmziW2viaR4GgaTROSlIHSFQc9lluQvrxrj6xxaArDSDsSCD6HqbruPNwz4anuAtrYhghXTOUcyNTElNTO/cweDbF+hr0zV4+mw+ZbQ6HgZvwjwniGc6aIIVt4g/qpkePd0jOSxSZ3iWKyNTRz6ov/OYuq0NEWepelMIITtx2cYHsJfIOkFL7tCwZ777
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable DEFERRED_STRUCT_PAGE_INIT which depends on SMP.
Also enable additional debugging options.

Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
 tools/testing/selftests/kho/vmtest.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 49fdac8e8b15..0014bd76e88d 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -59,10 +59,14 @@ function build_kernel() {
 	tee "$kconfig" > "$kho_config" <<EOF
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KEXEC_HANDOVER=y
+CONFIG_KEXEC_HANDOVER_DEBUG=y
 CONFIG_KEXEC_HANDOVER_DEBUGFS=y
 CONFIG_TEST_KEXEC_HANDOVER=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_VM=y
+CONFIG_DEBUG_VM_PGFLAGS=y
+CONFIG_SMP=y
+CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
 $arch_kconfig
 EOF
 
-- 
2.54.0.rc2.533.g4f5dca5207-goog


