Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61800C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD48C6B00F0; Mon, 29 Jun 2026 09:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D7D6B00F2; Mon, 29 Jun 2026 09:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD74E6B00F3; Mon, 29 Jun 2026 09:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75F216B00F0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D645D8FE6E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:30 +0000 (UTC)
X-FDA: 84932989260.20.C8D79FE
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0ABB314000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v4W7pyZA;
	spf=pass (imf26.hostedemail.com: domain of 3O29CaggKCHwofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3O29CaggKCHwofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738749;
	b=q6K1ltDjH+rZib7tyhP7GzpPcq0g0iKFVfloopt30D6lccs+hWbTW1uLhxsvnNqpxD/+j7
	0SJE833oldYhjIUstYQ4wvOByTosXEZArBMzinI5Kz0GZ96PFIT5c0zwjbr+MPw6N/bdam
	5lJvfMAlKcK0k6usWRAD0CoGj1mnhJI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1IRysh5TqTjmsvBmEr1NgaWZsZT3eifgrzLdKx/xP5Q=;
	b=UxZdgJ5zh/c5XcDFF07Sf8J5XuyU/v1HCptWymvSi8+B0o41C341N+MfZyonRhd70g8ksA
	s2yEcmSe+R6k2fsV9MpewLVaWjIEUnwb68oXzkR9dB3fVBckxork4A4mdvE0UNyxLo1lCa
	QGPu8OsRUM7wjxhDgJDGMdR9b5Khy9g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v4W7pyZA;
	spf=pass (imf26.hostedemail.com: domain of 3O29CaggKCHwofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3O29CaggKCHwofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6984402aee4so2089391a12.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738748; x=1783343548; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1IRysh5TqTjmsvBmEr1NgaWZsZT3eifgrzLdKx/xP5Q=;
        b=v4W7pyZAs+GKooNqEg2gFaY7Rx03awrYjc5JmUiQVnievOmGlAWSJ28j+Ocxu1UUqL
         Vjk+eMG7QTokn3M4P8MTu+wmQD+9N8QF7x7NbA2e6/jC67HU0HXUNVvzhEc1fYMVUWW9
         r2OTy8zzz8Cc7qwwMe0OIAWCaPsae9AsU3NmplVSR6w0u/kNQmOwwcq7FmgdaDnelt9Y
         Vjh7IR5EFRrlJYBn1lS9xDDiQtp/2jqV1/i696q3Adx6YIkKOYv78g7A/waoIPXCNyvm
         s30Ku8hlIH1sNLyYLD1TQpzmgW0Hc4MFMlZXr0I2rvYLpb8XyrnyCezYyHtcQ+ewO4fp
         +xVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738748; x=1783343548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1IRysh5TqTjmsvBmEr1NgaWZsZT3eifgrzLdKx/xP5Q=;
        b=V3HWSMk9VO679g+xl3ULODtC8X+thhTtHujByuzzLQZpok8kIP1wRHyhg55UTJEhCj
         2SggI4DA+MiTa6tg1kYurE+Sf7vm+AAgRrA/jvuW2EcHfnKlhT70NAmnr8EvWAN2CiZI
         qRnMWkdCo/3BRO9nThkG5LpeXgeU7eSopN6tzV19ipwTDJNk07j+D1M4NvcU93OK/Ccm
         wxwLbJfaxYSUCSpftV/KI2jKgxgdaDM+sDbufNvNsvjBXYWVQUYx9eL6P3R1DZ7wo7dz
         XGb7k9oycB+apVzIRPUb6e8M9sRYT6eJuf1iWOLhQIBciMvn6VdVLkOB9pKsH+EDv7g/
         AFqw==
X-Forwarded-Encrypted: i=1; AHgh+RrRnGGFaBEtK/f7LZGah8R5+O9ZvcZa2UgGq+qSUfHtVMPRgR7auwgm1RgwRfDHY7Kky1D9XCcL8Q==@kvack.org
X-Gm-Message-State: AOJu0YxfCpSHPy6aIyua8wkys2eihMYOwndQ3P/kC19yhJxvs8AlueLY
	c8PayGLuNAUoLa12qJNx0EuYb5jhOoz/rhxcdH9AeY5kcUGOGJo4NGrNT8d8bLroTZpuO5u9xha
	mqZmcGy4W2NLepw==
X-Received: from edxu16.prod.google.com ([2002:a05:6402:650:b0:697:cdd6:b90d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5511:b0:698:3365:f950 with SMTP id 4fb4d7f45d1cf-69836552666mr4278172a12.21.1782738747073;
 Mon, 29 Jun 2026 06:12:27 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:11:58 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-9-57bef0eadbc2@google.com>
Subject: [PATCH v3 09/16] KVM: VMX: Use higher-level allocator API
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
	Brendan Jackman <jackmanb@google.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: a85xtnzc8m4nwhumqszp9u4hcfb7m1y1
X-Rspam-User: 
X-Rspamd-Queue-Id: 0ABB314000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1782738748-974153
X-HE-Meta: U2FsdGVkX1+fV1a/HEeJRRvJox8/3ZKUF4E3zZO7Tv3iBpqtIDd+O42g9t1Ir4hka8WYl2KPy63aX0cnOJ+CnyxImKZKU/E23IO3h9IGd2DBjPUFCheO4hfFtW9WdlM1tswX/C4aOSNEDoE7yXHqwkNKSzTljAYQUEJSEIjJJFrPIHkA9ykeFAA+JDPqVuaCpwiPdaQfaUwBvJd3YOa8KD5gNNf+1myiJRzbv2GHoFiQhNROOHqaVSrO5UEmMEYrZ536sx0DaOF0FX6nA0222vxkV6vkGbIj7SlckuufppbETbLnRiBBa12KeVRh4DKtwHubn/o4UWBO8iDE0Ffk76f3igl6A1VAWHZ4Ars58ZUN5hcMnVck1gezHQpeaaZGRcjLDLwoWIJWZq1XutpEoXLRvZfGvacWqIJZata8lL3yrY4A4GPsxv3+O5KYiK7vdhA9hCA3j/gZLllWbHhFg8UIaFgE0IafTQQRU6t8my0Kc3rd5BkIGfRnrxvgnmcEjRjkBqt0o02C7XrLjJoKW1JyhpCr3ybUIcaArHlpcevjeGAABeWkSxU7hEViSb62xNOrw1roGzzM1MSu00bQFx/abfimBNcQH3h0v/PlJQfv9SKGSwqKk310nbQKzN1cSrkaIuXSjTTEYWwWltaT/mxJQb4joDK774tIjdOsSk1iJJzavkH51MdPQmpraTIpoGTNXa9Br5tqP56Bkd7x6h4+z5VzKrRXf/5hJ6QK8If9+VJSZS+3I/Asar3UjtWgugYV9kbokhV8atGQpw1APzcQEY0q6Y53/HkOn/eh3KgtIVnLgMkCgMVtCRV+Lf+hTYq8ruobcUsq/gZc1m1qxMoSw4c9CC8aLvbyjesGo3QTbAcr9DXeaHMXNcE83Z4pGdZ+7CUAIIJqZV6OHVCn6WJK5I7/ss0kxitJJo16Ixujdg/eFlwhGxIbqXRz5byI5QDdNRQl3HEHnTDMKsc
 jfWf9lLh
 v/PCmu41iCggn7EIM7VqCSd14jyl+BcMl7tljrCR64fW5XqhfSU9f3B/3N/DCnBo+xVoH8QupAj/71wOD2gHwLBfuRrxeZCFucbKKj1B/sfOVwEcZWyylKf6Dme9mgu+DwiWu8kFjrABt3YpWkxwEpsxA9+R7RcT2OFg6huo3mn36GfGFrHXDYgZJLmFNj3J6/4WmV2RYnUbaYgdiHgviqKzPY8eKEl9kbeGo+GbkgOcjenfkI+07cX5UGO1pzz1Zd6qOKvpA8E6R4LcIvKpj9idBE0GH7+b9f4Zh/VbPJTZREDfcEt3QkrAAACYjqmcn+sLWMUtzJPeflZMZVgxRDHZ8vNdsouZzVqobzhOOHlOIaWI3Yd5WJf04yEabSg6dZk4B4BXbfCx7XbaoeRwoimc7OLAMNnqqgpJbwcef3GE9dxFA8kBSEToP0tQ1NQDvRZs9ghawglil/JJzaOR25KW7JYoOZUshCvLmzsX0gilNcZfEqO95zqikNK248UGCYw5kXwD4XiFEuQud6GWV/R40XSaGS/p6FikIfDExMfCcKM9vP8+k9UOKkK6/U1T4MDxWqUDzNpRq0l6FQDYCT7jN3Qdb/t3+GlsH37cKHqI0f2QyA4zfiPhmTnNoK3lJv5SECvwc9IbQpIHsuwdf5NGdgTeEyY/Hf4RQe1EzsXuzdzi0NP41Xx9PSg==
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

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Assisted-by: Gemini:unknown-version
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2325be57d3d75..ad6a7fc6a54da 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3028,7 +3028,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 	struct page *pages;
 	struct vmcs *vmcs;
 
-	pages = __alloc_pages_node(node, flags, 0);
+	pages = alloc_pages_node(node, flags, 0);
 	if (!pages)
 		return NULL;
 	vmcs = page_address(pages);

-- 
2.54.0


