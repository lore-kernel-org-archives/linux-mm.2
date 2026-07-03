Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D2FFC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637DB6B00C6; Fri,  3 Jul 2026 08:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F526B00C7; Fri,  3 Jul 2026 08:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54CB46B00C8; Fri,  3 Jul 2026 08:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4C26B00C6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B07F940519
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:35 +0000 (UTC)
X-FDA: 84947403870.21.15F9542
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id ED04C4000D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tqB/lxe1";
	spf=pass (imf04.hostedemail.com: domain of 336tHaggKCK4XOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=336tHaggKCK4XOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081953;
	b=QThpTV80wcuZg0ngdJ+ZtOIjTQfNslBN1gM6fD/8Sg2W7YvQhBs9dXzMZgy7EHItB1j3w8
	WCSbuLhPgzrgXlxDEVPHLamlZ31HEhgIjRK8WGvD2OKNep0piLZOWpYAychDRUTskXzawr
	zT/Sxco3Q7OHR2S1dtICqW5Rd/et5uM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lC0ttmwMBcsuhLErJ+9tppRyqpd5bumu/+XIyMEHUjw=;
	b=0/txyCVEl84zX5uomVCgouiTmn4Tgf7kDAugj7lk4JH/Y2QR2kLQAsBFKCvBwKswkBb2kb
	3DjSm4HixJmJQODJaQX51tVXshVzMMErtPw5lOkpXtDdndp0pjVWc86KjlAdqg+rWxKRiG
	+Vsb3IshJo9DLCtwS++ByUZtLk7In9c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tqB/lxe1";
	spf=pass (imf04.hostedemail.com: domain of 336tHaggKCK4XOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=336tHaggKCK4XOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-470cb859d96so348588f8f.3
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081953; x=1783686753; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lC0ttmwMBcsuhLErJ+9tppRyqpd5bumu/+XIyMEHUjw=;
        b=tqB/lxe1EIpPniWra5uKa3hBQmJmadYy8toEH10H810lHyOfbLIJgQ4KUaaatHnGoN
         wMNbk0DZ+lUCa6Ftj5yUDLOnGPH5TJBc2vChfgDh62kcH+tz4YB5NYVvibgg4JnL+7rG
         c8f0FVLLQsBUvdSIXLt6Q6kCaBrgfxKZdstYwo6+uSUlWFseOffqY6/X9LHh934cwkG/
         ScVRlVsOg3lMY/H3u1T2TA6bOciH2pY4DT7vOPOed3faCub8kLa3vkLwjAhrcAT7wm0c
         POaWefaL+wGwnNCtv+NSL211ScmOelaKNkxtBFtBg+drbHT93IEe7kU+UicpAXJFgD3w
         Pjdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081953; x=1783686753;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lC0ttmwMBcsuhLErJ+9tppRyqpd5bumu/+XIyMEHUjw=;
        b=s/PzIgejWBByCTvj5jS1m9gvLd7JSsPUDwzDRfI71p5OgMsF8PfGmjpGpfCRP7faTU
         YbLkLfaWz50e46LDZuuMlHGwEROxT+5lF/enjtRxew3d+gFM3YTVVAJPDjbnNvC7Eg8s
         zz66/UKZv1KfnWLbwPFZhaFOg/ws0cmXpm7tO939vZWUTEdUvgOSZwgBoDlzFZ4lqSga
         wSz3tf4ar+1alSCuOvEu4wXEHLcOUl12XMZGniOjAislnVomHeVyc7VPtfRaNl3ROD+k
         OLbOWsvU8MAliL0XyrLqgOSD9GTVGV+jfkLbMknQmB90QiW35WgQZ7p7Zo7Cd9r980R4
         Gs6w==
X-Forwarded-Encrypted: i=1; AHgh+Rp4WAM7N36tfbARcjmyNUbVTHP+Ai0KbSREQugXpLRc9ojHqdoYz08xwq021ByU5147RNo03LE9mA==@kvack.org
X-Gm-Message-State: AOJu0YyIQrSQSTNBykE79uA4Xfc1Nw1X9nB071kT7BIq+iZqHXINIVHj
	Rp8/UqoQxl7q821JTLgHoyLBuasLymdpBGx9Zhid5ZezeeuXvn7VAY0PnnfgPRVbV5mlvYhsCV3
	ohKthCeENzRcmXw==
X-Received: from wrou11.prod.google.com ([2002:adf:ed4b:0:b0:46f:e7a6:2dc5])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:18a7:b0:474:d7a5:4b6d with SMTP id ffacd0b85a97d-477b38897b8mr13728542f8f.21.1783081951915;
 Fri, 03 Jul 2026 05:32:31 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:50 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-10-c87b714e19d3@google.com>
Subject: [PATCH v5 10/18] x86/virt: Use higher-level allocator API
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 8w17o9r3q6snf16it5zya176o8z8gfe4
X-Rspam-User: 
X-Rspamd-Queue-Id: ED04C4000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1783081953-314248
X-HE-Meta: U2FsdGVkX18yGx3qvjGA550DOPuEZ3sGDeZbMgEjRiNJiUR+XeeKfYp+JbLCGWi2vBbdeEOa6tCuXzzrkTWuQAZizXEPIrJvz/GoG+P2lDbrcrJVMR4RBGaMHKivuw3jStFK/eNVSwjerTkLFXqCop2yvQKmSseenPJ+ESi7i8ywHEDv0z2NNNGy7nt4Bwyh10znrHLmnaKz4pn5+bYMkQuyGdnUD29+6EqO75QHyw7x4b6SQh16KGiiR/mbUlXY6n/KwqXzk2iqw4+gUhO45XL59G+HRkdWKOnG67HrdTJnPnUf802EEhZWbguSS5VcZUu2DdRylJCV76FifLAdFDE5XJMVhcCWx/vBvfeumjaK3J4SbZ8uLB0rzKjc8/8MxxjWf8Yml2jzHKoQZJvrDfo/F+Q/3HPg3rFexRQE5NsoQBHOJsJvaH0iLsdNckaoxVN/fnoKb2+U5C2TxNJuiNwrbQev/rvbHbkTQ0MPtfXl2HMCf4wiXqcp0W/OX50ALZTzZ4VFWJ9r0a2tv/uu9OGxCWXoSZLToBFxFNayTpTyvRyhpkupwK03DXF6gdHaCLFT1hFk4yybBpeQirTmmfL3l1NOxG4PM7Zk0SX3f1tNDl2cTx8/AQVv8igt+5JaGFtANSfjSoLcBwNrQGehxqw1Vg+AdT+Adnj/wOx1IpKigA8Q278RXctFkekbINl7fgr6ZWDh5HMgbFofFHrO8ciu3VsQtD4wWNC+RfTxOww9PbvjUOXbREWhngn5EGqfFsAPdcOTkOIB55m9fRc4TX/PiCmGGMeRM3sehvDGBd/iXNQjBygzY8msoLQUP6ezAjIXOVAtNMSYe2mcW7bhMCTTxo1VIo7r6XSROyX8f1OxjGzln1nVRx/ckUyln3qkvThlN7jK9dMTIISYarBYfF3pt/89dtuxEHJuOZpDx6JvYlLiMoidUevkIbdx5kIxTIq1UVoLM6XN/eezFrw
 NFplMvEp
 Im6MhzFqllj94nmtirwDnZ1gKGIRYdlw6K0RDYkZqmC0PboB/wtjKRNzK0IXiYw03oguASPr2ecm9MFhYBMxVyzInQQ3dVvg+eug0CmnfXBu/x/csCdNAMlo7iNaHT0GcLAdPzG7CEqHkHCe5O1RW4zZpQtjHn2TN/mqVFJrEqOB2JpxhcVYEUbHrP3YhcEjeJIkfSoxQnufyu2JTEQLCGwEqktuhtJ0yF24n5dx3SgRwxZiX2zNTz24273EaqCVrgBc3WJqz7SfXT6VFFJBWe7ZgS8p0DCoVgNXnqM3t7QbDJMIcot8X28hReb2LZtftjxn3BDDHG7v9sXSNc4UuvQS/XhzfZPRGoRgFmObBXcWiCA/8p3/gUBDzWzfjRpxU8hm9G7UiN9PbSw4M8XgjfRBv0z/iNRv0iVQTnLEcx/TOWtDqCJV9uxVVDAPiR86c72jD7lKiODNY6sAvt2FzvwZ9QciKJCtE9lWXtcDVbB/+T9tQN5FEHOlXtHCMa/cNeyhStNN2dIxpzQGvXtTeSPVLL+71yomR9wqY0vrGM8hVGBwhIhbPPJLo47WOwvSvdOQ9sSxAGWLstdAPDtUZX1HS4E1d3TEjqzxa5KQvEyrAqKYPQ3w8SNRFXUEBc/tAyL0evRkMqsF1psn3AY9UgKD0PdPX+eBHm3GvXsYasI8QrxvdDamcpeXmwIm/T1tc4TxC4prsK5JgYU728cOpZL49xr8QWAnh4RPRlC2L1Vsx2EPEEmVbW/JUwLOl/lygn3Tixx67tgLEj70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The difference between __alloc_pages_node() and alloc_pages_node() is
that the latter allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

No functional change intended.

Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Assisted-by: Gemini:unknown-version
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/virt/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
index 7e9091c640be0..a236447ac7a26 100644
--- a/arch/x86/virt/hw.c
+++ b/arch/x86/virt/hw.c
@@ -196,7 +196,7 @@ static __init int __x86_vmx_init(void)
 		struct page *page;
 		struct vmcs *vmcs;
 
-		page = __alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+		page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
 		if (WARN_ON_ONCE(!page)) {
 			x86_vmx_exit();
 			return -ENOMEM;

-- 
2.54.0


