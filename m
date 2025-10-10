Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6760CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172488E0033; Fri, 10 Oct 2025 11:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122FA8E002C; Fri, 10 Oct 2025 11:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011F28E0033; Fri, 10 Oct 2025 11:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF2508E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:45:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5552140376
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:45:06 +0000 (UTC)
X-FDA: 83982628212.21.EBB8A7D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id BCECF1A0014
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:45:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P+7vPmSh;
	spf=pass (imf19.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lA5CHRSnZ1rgFxjlHeMvJuEi1mBcTnDR9FDgvniUAeE=;
	b=d9YpI9sadc0cjeMzaWVMxiN5kspKHyfDmqn6GL9mwfWD8UMoj6wGeyy3tZKR+GPtFQP5hN
	4YeHD3YDOW+LIIeAQYT6E2tSZR6cy1PkH9OX7nFiCppPIQetDhRDXvNRgf+nXbXg+Rqvd4
	L1jZA6yECSU9Wy/Q5tMBKQOm9om/Ass=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111104; a=rsa-sha256;
	cv=none;
	b=OPPYMj8A6uLxAHgpNUun2xMJVPHhWvFU2o4ptqYn0+nlf+T5ESwv0YuHp3M44DjW9iiOdb
	A2pALMaMifnl0Mv1VhekkkcVkdUK0F+O9JUfnF/1PIlnKXMpC+zHkypKAN0S8jqp4pHo6O
	oHQAiEzld6OQiAqs3CTxl/JbwXh7Dsw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P+7vPmSh;
	spf=pass (imf19.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lA5CHRSnZ1rgFxjlHeMvJuEi1mBcTnDR9FDgvniUAeE=;
	b=P+7vPmShHfieUVDAE9kypwNMg8a1HnUMjACNuIxfTTQGeHNxJhbkR7Jps61/uuDXoFT9a9
	wbbGeYNIE+6RtmRgPkR/3KjMEoTVynu/CL8Ip6yc54IBF2cVhGGQsiRe8XtyiswZE1Tdl0
	89Ve+wk30U9ZE2uQDdVH0FGllibliMA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-205-1nR1k9OtNHyFHWxfDt3B_A-1; Fri,
 10 Oct 2025 11:45:00 -0400
X-MC-Unique: 1nR1k9OtNHyFHWxfDt3B_A-1
X-Mimecast-MFC-AGG-ID: 1nR1k9OtNHyFHWxfDt3B_A_1760111095
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 372811800343;
	Fri, 10 Oct 2025 15:44:55 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C27A18004D8;
	Fri, 10 Oct 2025 15:44:40 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>,
	Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH v6 16/29] KVM: VMX: Mark __kvm_is_using_evmcs static key as __ro_after_init
Date: Fri, 10 Oct 2025 17:38:26 +0200
Message-ID: <20251010153839.151763-17-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam05
X-Stat-Signature: 441q5xap6rgu9c36rjeaky4imdminswj
X-Rspam-User: 
X-Rspamd-Queue-Id: BCECF1A0014
X-HE-Tag: 1760111104-411785
X-HE-Meta: U2FsdGVkX1/vs4kNAdVECJdUXnQG0Bx1mFpCAWKUNkqP6phGnil0PNTVbDcpam7PU8l+/d5mzlqHGb8DnXtDh/9jcq7fru4vSX9ZGihX+XVC1gY9qFn32DfFoHSZrW8AsX5DVyt3bBOOwDxOzvItgvgFrrdWpjVZ+wW9LFN9xSLAnNjaKlG+FX02ey/8SbcmEwZrHqz7fq2sAYsV59QjymE8nHiWEbrqE//P1K3ulfqRhyF5UaXnx7JGnC36fAHehDl8lhO/kEKqRcb1CjSNLgv9CjqqpoeG4YwAQy0WhLmqPeL82hy0p1Fojqbqbidkd7a5lKQOafMfctmQD4+koP0suJYQJe0tGUfEMDGuoG5XR8zkv7jQCshQSfhaKEq8qV13yJmIn95DfTCm6ZRFzdWGM2AxAhSB0Q/OFxpMHvju/qiBOsZC6UzMrWHJbt6ea3HLtbmXYcr/OqQnqDoswjnCq8YwemxhdZrUTtvTicXXtrUSmVqnfnGqATbHFjhPc0kcUHSir2iiu2V73tVKo0eHI3RaUEMxc/IVt5RoFhnk2AsxnWIY8QQ+ZwjA1WsH61jaMQTpd326HYo6DmC9D+AeglfidPDeaKVcFy5QDLqlCAgQMY2QbQc6hUTi1rk0CRhb7Xv3KQe2Hq4XNncJnMuS+th5IwPLRrwqty4Lzh087jCiFomV05LPiZOKDKIIEVE1IgtzKPtZKhzU17Jc0WUL4S5aPOXqX5QZ6oH1fmgUMZpW0NiROrCIcPDjWbcLwP9AvnT56EOIxT9aTbspPqlTOf/r+DHxgjx0MTf31q0hntvjY3la537rivsDLTFlGcZXamay8DmpucOFUHADeU0zPYlgYvr2v8rSUXVEW/xFls7HR0FzRMKUlHY0xsTFLFT+fmF/ZemLSB/wHlKdPYZmm3mFB9XUdX9jZDcyF2Q3fA/gjaiepH2xzjHoQaS4FhjiZb9CM072w9cd4GO
 Ho6f13hj
 AL2fcbfuMLWugwe6O/NLHLg/pUMEyT7PBoJuTdVqGr2UojRisMtf72DDAXoS7LlV1ViDlF4oQEYRCbZSZ5fIeeHV7LC9qX3fy7nkUZbbct4ntafMT6VR47d/qNFj+rQOWPsg+pvPQKMkpd25HZaORC7voYuJIWid+Cy09bH2Ohrx+zpCrHjPXEtSEFhyz8I7jgMyjskDXn37UBAp2zMjHMtCywtzcVsk43f1mWnxyZwzNImQtIszo7jlWiKmfF0FkunqxXWlEweTdUE3lBHG+UFUI2R8pY/6xnGOoOxMABpVT7Hk3fCNvID3BwsT6r+RgicMKDtpV4RhANef//2tuvu2Tlw/BHeBKXwBDgkURTPmIYomv5H+pm17p6fH7qdWkYHxGCevtWstxYCqu8Sp6t/GbBhRx6WGZCTArCYZ4K8H6AcaJKKmc40tamEQO1u1TdNtQwoCCwic0CfygJjOYm8LTEFPNhNqBXzrLlO5XY40X0Zh6IDxOPM2+FA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static key is only ever enabled in

  __init hv_init_evmcs()

so mark it appropriately as __ro_after_init.

Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/kvm/vmx/vmx_onhyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.c b/arch/x86/kvm/vmx/vmx_onhyperv.c
index b9a8b91166d02..ff3d80c9565bb 100644
--- a/arch/x86/kvm/vmx/vmx_onhyperv.c
+++ b/arch/x86/kvm/vmx/vmx_onhyperv.c
@@ -3,7 +3,7 @@
 #include "capabilities.h"
 #include "vmx_onhyperv.h"
 
-DEFINE_STATIC_KEY_FALSE(__kvm_is_using_evmcs);
+DEFINE_STATIC_KEY_FALSE_RO(__kvm_is_using_evmcs);
 
 /*
  * KVM on Hyper-V always uses the latest known eVMCSv1 revision, the assumption
-- 
2.51.0


