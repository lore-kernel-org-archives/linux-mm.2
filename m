Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BEF3CDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2369D6B0098; Mon, 22 Jun 2026 06:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2147A6B0099; Mon, 22 Jun 2026 06:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AF166B0099; Mon, 22 Jun 2026 06:01:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C623C6B0096
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:01:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 282038FE08
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:53 +0000 (UTC)
X-FDA: 84907107306.08.B1641DD
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 48AEC14000A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K2cZ8ai0;
	spf=pass (imf26.hostedemail.com: domain of 3DQg5aggKCFoB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3DQg5aggKCFoB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DAXfb8BCSbPGPrK7X9VVeT4nqNdHAMMoqJF1QOMo6js=;
	b=qZSshiBhMyxOtc+7kk0SE/d63piDiHW38fNpmHiAbdWeK8b0Zc6JqNCLhZvN1SM1MtQCRU
	MUXudLY665AqoEtIou0dGWKQ005jYxUbfPrTwycQubGBwMjBPe8cXvmEX2EqJZIR9uOWkV
	khNOwpyayJbVKK3vf/gzqfwrUtIPjn8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122511;
	b=dF9i5dvNj1DLKhPw1VdJr/MWu9jTThtDdVQvY0dOtQ/ZIy8FFBZzaYTZ08lQ3BUjYAl+jT
	sZ1As/VglwK7Oi5JcRA1Ke0zP72oujf1NcgoforJ21slreYcmPhNdU9LOBQ6ok9or2wwUK
	frx5mvppsjBY0HkDKuI8l1vhuli90J8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K2cZ8ai0;
	spf=pass (imf26.hostedemail.com: domain of 3DQg5aggKCFoB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3DQg5aggKCFoB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490a060eb84so26389245e9.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122510; x=1782727310; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DAXfb8BCSbPGPrK7X9VVeT4nqNdHAMMoqJF1QOMo6js=;
        b=K2cZ8ai0i9UyGJocy22HRuENmcgkCWnj+z44OOf5otH+Zb5XgHP4x1eXrT4neollwL
         V+LduORU6s+zECX4LcP7shp1q5J1uesrnPSrwjPti7Lp/mNqRfHoYmiuw3oS+IYo5t5/
         D1HbSneYFRSF5/RAhzlCgQzZkTBWGbW3lJIZeN2h0KzoYvG9EyDpAggqsicDTPKyO2ow
         YGLucKtm5+mxzocj4eoxyGyB734LZxJeC7pK5LlyGUOrDxGnihJ726RL0escG6oPlqfU
         seTx10mAvpzwnj03fn9Kf+ecdkhV3NZgyI9JoZU4hM2aOAetpzb8hHIGoP6KUajkvkx5
         r/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122510; x=1782727310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DAXfb8BCSbPGPrK7X9VVeT4nqNdHAMMoqJF1QOMo6js=;
        b=LgNr9BFzBB7HiOZTR5Kjr4FYSfW9Wp3h34MfCsZC80SAseB7O9cEJXDns/Rabh70On
         f0t+0Al93KHdGzOzHBU8eqeFF50GMJ3eK6pLNxzeei5T75ZFLbJyBz3ygU1lPrNfLIs1
         Urrrrfe5pLpcJhcVg2SDyvrK+1ImoLo0i6AuoeVVpqOeaUTvtcVMkZVTJti1SftpZSYv
         AXKIZIxtgOA2w2num2itVHmO6gqPA4FqBSFt/3J4veHCd/3w2JPZS8+B8CFfdPjq+dE0
         mJx+mOW3RETiDXrswlpRmvvHuzFDGwbc4Lg3ALoG3tdT0kwcnU5cvRn+fuBOOk2A83fg
         m5sA==
X-Forwarded-Encrypted: i=1; AFNElJ8V0DTQK8Vr0SFswGqVv6m1Iqkj+kpC9Cr8t24dFBznKRpJ5JdXaJp8xTUjbmf3kX+uhfZ4eBhBRA==@kvack.org
X-Gm-Message-State: AOJu0YzPP8CIlcXyGfx/4qTMf/ssIo5AJUvTp4MjisRW4vjCW1pd9HbD
	bJretn5T7ZKxmB9HirmCvMksGBjXhx9kypCBm9cdSHn/uGkqeHd+mQgjYsH2shpkCH7JUP9w784
	2YNSNw9PmiKL73Q==
X-Received: from wmhj19.prod.google.com ([2002:a05:600c:3013:b0:492:463f:2524])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8653:20b0:492:488c:f627 with SMTP id 5b1f17b1804b1-492488cf6c8mr100943345e9.11.1782122509368;
 Mon, 22 Jun 2026 03:01:49 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:33 +0000
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Mime-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-6-31f31367d420@google.com>
Subject: [PATCH v2 06/13] KVM: VMX: Use higher-level allocator
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
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: jw4mtyatdxntzs5sooekztdsnepfmuz1
X-Rspamd-Queue-Id: 48AEC14000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782122510-386369
X-HE-Meta: U2FsdGVkX19MUD6sxxDLp5ZDudd8/E7nBCZ+w/7seIoV4IBPzGoBHVhwVwuQ0ygxkckKVHBkglW0vH7HbPv0+SvHqGWkoStQ5+G9F4aCjbY1ny0t4FDUCF1aOxCD5PowfHTbxkTXu3YmahU5xZ4B9/b/QIgfcbvftSA3hbInq4RSyPuxvsk5b/3p6rLp4sxHnLrtVZFx/LYYE8zSGrN8XU6SLZdkEnmk2vcIdZfp/O0lUX9tIHTf0zSMCqcK691FlVISt/N107Nx6ifi2uyi/N342tuDZq+YASxz7oZqVGeJ4JI4tSP7r5jdXS9rNdMX60idU2vRNTSgFtoZS3YSBz/ZXwavUOJ7foUOoEfBYmm3ipQ8PIrBuuirmsvA7z+2LXjBNAWXpXxcWAHtxJ58Zf3G3CCGG9Q4GKVNsysEMBleMhB46Gz7ZysBFpEX6t5kXnbdDtlnM1mleaacGWyXvpVBhViaU/nb97TYdCL3IJbrxIaoWUcHyf6li+G2wzACRW+rXaxYccJpHoO5/ZJGPvKipoIHKPvFMNudQChFTBBp6c3DWWSwcaqm/ELBGsvcfQW5Mt0lHECAl2fTEXMuJb1JjqziH09MeN1eLVGjAQeFG/k6tIBw19JcYpFO+yrxK0hJlqj8DLzcTuGmHFvv+iWaNauEpJmC/X85QYOyKny8qy8zuWb2S3XK1/cKlT1OPISyuFpzJwxvb8u3v+SOIdEqzt9uF+ymQXXDYxmcYS1uY/1uoZTrlnVN96yd6114C8Lq1bB5x3ruALHcNR3GfCqbBSGDpCPI4KMtLilEOCSJIsNED1BIq3Nnvj0HSUmyf0qPxL5nd0sIJPbKocRh8vzJPFAdmkcrakLlIinq4Vsmh86Kyiuqfyrb6ZPLy3Tw2BBDyTsl313TAcUD5qLHC0kS4kTE6VX66Yl3luVG1IrefXG1UlguoFfhS9/LAw3WzkyL6QZHlawURH4B/WW
 miT97IFg
 WFi6PLQJDAyOqThlKcTbOVuUNGkoWrVXAxtWlopCd47xAOWncuGQZh8X6G+454enxb0vLrnptjUyDUSEIL38bljzYiwCG7euWdwXIZof+tk8qu4RlQthIMSl6ixf+g75wbFpdP9ncbpROusQeOJVsX7ju4FYlMAHh/MJKny0eNvCQnVGPJ1ovrsIz0f4WgMpZ1hf8qwtvR/HE/NLV4uyUjs69we05SycpnWi2TmraRJ6zLWWUxp+NwXxWMhzCyerxxTG5wC7nlvF2qjcDKbnQwlkJU9yjFTIDQvJuXDYBVHOEJrOLp3c27LuuXx1NY9DAayaT2oGzmWV1Cqo4gdkGJy/XWRfcXgjOP/46M/6vsFj0w5XH8FKjJsnu4P9ycCF4tVxGLcJ4yqgOKEoY4XvmxhWSHJ651GxGO6IS6TTnOTad7IYnip61DTPrGQQTTRH8a9eRLcqOMhyeGDQDeM2L4el3SDLXGqP99Eu8ht/kLK2YjdduT1828KAKJ2EbpMWIQ6jir8WKwZobn03A/9ke60D6Wg1rWGYoggzkax1izHzCWyGAfl6do51mBdohSJepUcqHMbGj1Liyc7zDBTXzgjkW5oPLtehvWhBt0ZO8wB/SkmTov7oDGerp47jMQzCYNQLbtYEuJP5C3pMzalCCci0x7zX/+U9wIOtLZcXH/OCMPrtoSNeGT+i+AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The difference between __alloc_pages_node() and alloc_pages_node() is
that the former allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Assisted-by: Gemini:unknown-version
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b9103de01428e..23ba400b30eec 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2994,7 +2994,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 	struct page *pages;
 	struct vmcs *vmcs;
 
-	pages = __alloc_pages_node(node, flags, 0);
+	pages = alloc_pages_node(node, flags, 0);
 	if (!pages)
 		return NULL;
 	vmcs = page_address(pages);

-- 
2.54.0


