Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C0ACC43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CADED6B00F2; Mon, 29 Jun 2026 09:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37226B00F4; Mon, 29 Jun 2026 09:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7C46B00F5; Mon, 29 Jun 2026 09:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76FB06B00F2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E214414061B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:31 +0000 (UTC)
X-FDA: 84932989302.13.C7DE1F4
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3446740007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UBduy5bL;
	spf=pass (imf12.hostedemail.com: domain of 3PG9CaggKCH0kbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3PG9CaggKCH0kbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738750;
	b=N2+X9v+uuZFjxLJrNsHqp1I/a+VVNzkrfGTQ3NqnsXzlmidVBMZQ0tO/OQM7Y2Y3fqQqJK
	AYUzEN2BQah4a0YaeVRfHZ5rbhY5V5K/+6i44s1yp//VJRYMoxDOeEhNmV7CXScQjJerHV
	SANWbxyK+lN9VuUQDcj8iX4i/oix+wo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJ78q8Al9VbD9+7rxBEKZgyEVtSkV4vtK1mqsIB7EjY=;
	b=6+5aIWU9VqDsPm0X84ciIANADtt/bIYf/JGLZVtRUKmF0hTmymQbO/Zk7CnX0jg4cSIGa+
	vBhODd0LI8x7Fj5grMgYapkXYgJQ7p/e80sJBniMdpooh0YjkYyhovB93nGIeIGxR23Zn6
	vgRcrPMDf+DS2v31i26O1swX563lfLY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UBduy5bL;
	spf=pass (imf12.hostedemail.com: domain of 3PG9CaggKCH0kbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3PG9CaggKCH0kbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4924725bec9so20989315e9.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738749; x=1783343549; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VJ78q8Al9VbD9+7rxBEKZgyEVtSkV4vtK1mqsIB7EjY=;
        b=UBduy5bLAWElIDFxEYwkBdvbnx+iRAvonJl/0XEL4h5pyU8vpMuRGWX9tZ9xbJo2yy
         wz00c48tLpNGrjQxz+vP2vBJylhyH3KKT34oRO8ym6sOvo4p0lOOMS/0Va+fGd3AZDbq
         mqCogn7CahZNgg6S5fAMtJyWIpOw8pzmVL+cxDnh+KXDXtzOmWtiFDTyX6l/Z41Yiq/x
         KlPYkJYgRRWxp4/H3lIPhy2jORNNIGkSsB3k7EorNWkOIkEvQyNyHnvRLkl1MoMIjSOo
         O0FenXeDq3SrUwYuHtKcHM556Ly8xx7v/UTmZ1AjXh8nJW5NoGuxO6CIPSqxz9gr6mzw
         gL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738749; x=1783343549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VJ78q8Al9VbD9+7rxBEKZgyEVtSkV4vtK1mqsIB7EjY=;
        b=Iqgdy4FHOz9awaix07r54M9RXz5Fe+E1goUAgKoq95OTmgiN/8VSep/e5YJYcXNj2j
         P8zVBddh8VZrwiV8xrFiixAmicyol1bv1OezTZZ98JvJUVwG3nYW/y1bxkpFUGIRkLc0
         UCGj8vdItMpYieSNegr5qNnEqNtqXkKu88khiN6GaGkNv3eqEE46w2IALqEsJRwDO6Ds
         nlwXeYN1AdxidT1t9/VvbSjjQ/Hx+FJ/VPxIM5xtDq2znftn/e48jowUib77lov8ILVU
         8gYiK2udzl4JNRbgo7JJmyiCFyGRqTS+pJqBav+0jexh6D3b+G8fxZVzjDX4KFU6n8Gg
         mf4A==
X-Forwarded-Encrypted: i=1; AFNElJ+dLaY868g1KJ4I9YmYe39pkIFm5MdhJewHQfkpl5FtCw38BfWNFOeBOC/CCNNS6Nj0VDPkB5aSxw==@kvack.org
X-Gm-Message-State: AOJu0YymhWa8k/KmlsMlTEJhntSmNjahOBpZW5FcvsVb0nEmixe0Ijdy
	mNC9fAKGfyukL8lk7H8iiNCjF2F2qIoo+PRl5HiZ/zPkh4Wfcj2iQK5V91aoUED0kJ4HtEAJ05p
	WXs4ONosc6X6vuA==
X-Received: from wmbdy18.prod.google.com ([2002:a05:600c:6592:b0:490:5e18:ff1c])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:6409:10b0:490:ce99:d2ee with SMTP id 5b1f17b1804b1-4926fc43078mr145672575e9.15.1782738748573;
 Mon, 29 Jun 2026 06:12:28 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:11:59 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-10-57bef0eadbc2@google.com>
Subject: [PATCH v3 10/16] x86/virt: Use higher-level allocator API
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
	Brendan Jackman <jackmanb@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: kzqity3kkozxjwij475hj3y5fggkzmxj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3446740007
X-HE-Tag: 1782738750-20356
X-HE-Meta: U2FsdGVkX18v+yyRZf9aGPaSAi42ftTQj9Rcqy/JOMTTZIDXGCBCz9pG336IOTriUHeJfO91uNISbi+T9L/pjm4csoF5ouQxfvIU7K4Sy9Q3EnUrMMy7T+/Ba4xHzBH9kvk5hc61jz0KOMqtTdh4Mv+rgc0uofMi6cazmVwr8s+Nn3P+yUL+IrXrJSkaVDclPcdvPiiS8G7pmxr0yXbBXV5jaQ9vIzptEyjGBr/x1qIsYpqIJVWat6+lKwQx8XYVfYmhhyU3uayddk76reBhnW9LEjq6FF/obFDBC9yi4tQDpIp4HUoGFsE0mrzAZrlT1kvZcc89HZaSkp/LUeeM2jrZpRACgtiG3QQww0xIzwlj0Qvpqoqb2S0Ku0i8SP4+IxQNce9nN4pW7iT2jHJuQiirv+I6lvhQHdF4xmwIzM6lQjWr5oSjQ/f02ePoSToh/Hzn0Ui9h0Lo3hocr1B0RHvipbf1sEdMjnMP9jyC+4/wMIEeIIFONo7KfU6FnDi9ftPO3S7k5lQpZTg5wG+bdwrDVwqNoVnSNM3+w5AxN5rqC+SV928LX59r/xzEo4Osbh0G0XrVa9eHS2VNQfZbcWXN16B7GoWxZdsKikqiPYgJzlQWo6X1TjLcTfyKurXnv+rWNLJb9WtQnGB271x8ZkYdTyoUpURVHHgmA+5AGioD0Dj+rtxE7GK+R9b0ZhZaWJpCCzpkC5Pcrc2OQe1q6g3AQIpx6NBAiL5C7AaeCkARnMFHNK0kWcYPJQfnnomW6XuCBopU9d9ZHOPTV4JHCeUtZRkaA/smGqYaO8Pbw1B+t1kjasmcwAbh6yp24Nq8pFtrubmwTLaWkKWt5pG0u2/E/AEXpgD7Jdhje7WiHHnQeOtbs3wNgXThiaQFRn7aObHdy2vpdXay9tC9lMSGxIr2/VedszZLYFz6eeNqbCM7m0PLRp5o2dLa0DmwHredWEEEwBTnchzLEQVEEK5
 uvUvftme
 D+mhdd90ygw4q40NALG0GT3pEQEuZLgdOq+RgxgzD9yPpXebIv8oxAqFXLOso375fXUa7xrtcdQfLYUS7Xil5WmEFnC8y2cjqg3eltvNNT6AjGKIY4OKvvFntwkFdeVHj1FpYUk3XL9cTuE26o1fOLdzYgF4Hd68GRy1z3ZvySgTCGLHRBUe98lvUjr+HA1vogCNguiejYYNtVJr2U+uFA0Lqz7j/7CkT1ZWnXA8AL8afmPFMj3Lz9ddJhoSEqj/8si+R8+HSIUxiIh6j/2pasI7kmzdsOIwG1g5BjSjm+Dki0px0KWULb4EKFzRf7kUOYFxbgZuHKIJc+0C8XqOJdEp7XY4f5IbPnOpqYRUEeSsXEZN3Rj0X1SBHViePvAwSchjinmAfxn7WOWvAl3lesQGOPMXuNHS4yPECLjmPDYHsugk9HM33mERqZy05rptLzYqz9ap1aQtcVorzG8RgK9Xteoh7fsCfLi9TZvdWWImkGNaGyfn2JIFO9Tsphdp4CAy37S4n7hVqxwT8WsG38HtkFXvrMMHNPt2aFRJDs5ujhYEtB98Lwg9f5E/PxTWzceYA4MwY6bmoXiVf2jf9MaJSwI9sD2wOhWglEB1DiicE8XTtSKGWfrQuXcRuuaaXwpKDvAYWVRHIs+q/ZwPXF/UgcsBu4cS4B+I4zsmJiHh/LEvAVe4dc4OlrwJjUij0OBS4hbtAQF3o4++FL+RtcaZ2RosKpRX4QJtMIVvkMzHTxkMEWaAWdBjvFmubBOQ5mO8l1wcsDY1IS5I=
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


