Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B314310AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169146B00A2; Thu, 26 Mar 2026 18:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142E96B00A3; Thu, 26 Mar 2026 18:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED59C6B00A4; Thu, 26 Mar 2026 18:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB7746B00A2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A442D140D45
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:56 +0000 (UTC)
X-FDA: 84589645392.23.DE47436
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf20.hostedemail.com (Postfix) with ESMTP id CD1C21C000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fof3e29U;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3NbLFaQsKCAYgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3NbLFaQsKCAYgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563894; a=rsa-sha256;
	cv=none;
	b=iu//+DS0TzVpbbD5uXpRlP0koBvvT6z265l+sn73KLsOBtY5T4aZ0I2h1dKU7QBd1qOC1p
	CRdDumNH37DGIt1Lz2E4FJ0MwJEFVKLOJzSteKrrZ5lgGXVcBV2ae6jAhaoWe2kwt0GVEJ
	kAaC1QRKicZZWQ9gKy/TabDf1qSG94g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fof3e29U;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3NbLFaQsKCAYgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3NbLFaQsKCAYgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=krjKKoUHOcKbfpf9SpjvgIZEA4m0P+3HWizcMkU39sE=;
	b=AcH+nPIOZxwehbxRuvq1N4AEGBwoMbwGDIA+x/McfdcuFpRUTgWRTtwqY4LSt7TSl9Ru08
	0Ngsk4x1uY33vMMYN7mvE4Ob/UtbbsVtjzgYVPPhig15/HvdJ647bwn3sTdi9+B5h8jO4+
	336pnAzWMxT+qu8gj1dIg+SVXJdjZWU=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c741f038f7cso1005614a12.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563894; x=1775168694; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=krjKKoUHOcKbfpf9SpjvgIZEA4m0P+3HWizcMkU39sE=;
        b=fof3e29Ugi8nEA+rG+99AYiCTgA4xHLzfKoQoIt40k3UlpwXYtS+5lglnCO8VyuZhN
         Tlw2doVxxkD8A7oMHpSw5pKLFh91UDALxWC0e/kyk2XhpsTKmQ7S9c/qsIwHjaYfjfOo
         piavlpgwL5Drs2QhT0nDMlG2lbkToTuQb6j341KO9yhKZBMHfAeEG0SGcQCAAqL4J1xG
         qKWDQ53RRQvZVsXCKTkL7NjbGJ2Rbh53Zy4FbitZDLbwdi3KwZ+iTR0i/RXJ6hJeDBMo
         q1rGiE5cy42/bU9L3yV2zfFQ+FI4xsOS77vy4ASQ2pJqeYnAyOytAyY5Pggdd7Z8E1s6
         janw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563894; x=1775168694;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=krjKKoUHOcKbfpf9SpjvgIZEA4m0P+3HWizcMkU39sE=;
        b=PcDJQObH2MwFCoJaiwWeqi3s7icf65pBJUEcYiyAHYwJknv4lILj3tgcK/TuEf3A/b
         28Bozf2GovJEqVjTbeRUcntlCYuiHajh0v6nV6StcOvOU78tCWpwhZHdbovEratuXy+f
         elpav8xqyyqa4WwPOfLshOuBFa62qmg3fNS3EzCk+qRtT5yGb5XUdma1nbZGgOzKk5lC
         6MKKnxzDDaXN3KA0Xuzu0G+oqkwg7GZj884idgqNh1jCnxCU/enGkBhf0hIQXwvxvcJ6
         HCPvlGeEGhgWufkieraxIxNbaqNtSCCNJzy3ooENq7/WGpgO/dkD5ho42FL0qr4RTPVF
         GAFw==
X-Forwarded-Encrypted: i=1; AJvYcCVC61Hs95EB8ufYnMdxFU+Wi5f8Z3z/PN/SSFfh/y1QRLOs8q+Yl2J+l/AjfA4txYcttk+2bcDcjA==@kvack.org
X-Gm-Message-State: AOJu0YxITlc+al4aHQMDq45VCB3VGkx92a9sHMLAjdamy365DVt1yXC8
	mwcSCqS7imycu899/MQN/oIhqxlzhK3obBkwnYx/SqRZl4995D/ueHiSGpBNTRbPNzplC1MbhgR
	1qzL3pGxUT/sqfLy9W4ilmKgDng==
X-Received: from pfbfa24.prod.google.com ([2002:a05:6a00:2d18:b0:829:813e:c970])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4b12:b0:829:a127:518 with SMTP id d2e1a72fcca58-82c9605434bmr143072b3a.40.1774563893212;
 Thu, 26 Mar 2026 15:24:53 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:23 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=3333;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=+lH9JgLOF707IWKJRbslu6RR2YV0S99MONEW8Yc3BZ8=; b=M/Gbb884LE5QPF+3EzZzuqSIO6Odv8JZWUawyA7Mhz//bCISt9epGhctguzMXhMlD/ZE6w0Rj
 EGaXkNBVodNBXGot/DtKS79CF61Z84KbG7KljbyQM3ZQboU3Sv7s68x
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-14-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 14/44] KVM: x86: Add support for applying content modes
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: s67awhe9xtc376iq5xthgyoiz7b6me7e
X-Rspamd-Queue-Id: CD1C21C000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774563894-488826
X-HE-Meta: U2FsdGVkX1+Wq06yU3eaa0C3pe+augr1quYtBSAon3KEZpJZWoJVqZR+E1XE5axWcLogxk6RKWxs47TOJzZxThSIkkQov2bibsSvejhzQUCrAWZsppuENBw6qkjne3/H6yBymMUyN3LR3sGyCxlsacHbou/W4mYWO7qDC8ha1+tjemFKRbX5hx5HZXxTwKlVYQRsUttn/CHoyhTz80BffLi38kOnd3co1181I1ov+xVbXe80Dpl523TylTWmULDeixBajPwyNP3IM8K1zU/QfS+cx3tXIHKfkxWsn9mQgY4NGl1kZuFGMNeogue5Ss4FuN6Vao5ouik6OVkRIxGzwzYKw4I8xg+87vf+kL/bckHgmjePif7F87pR92vIp2Dx5fumAP2Z1aiBfPFuoMVfekHprckxGGThDTf4xhr9LFz/veTj9L+pfD6/tko03dvmUc0yglMvzcOpR3wte2++z0Byu5ONeKPtzwJBS9PDFR4v1GY8ls1mCPKdTetcicoIy+SgKjhQpkxYe5byOEBHADfj1eTXRm9IfEgMctcYR3ZehkR0QvBL8WiRPA+0qNkZIxgeYx3VcP7gW2ywCfHy8++ohsbGNtBYxsNAVK8Z0A83cSAZ8u23THvZJgggBLElTcPWI6uDddJ1OpDzVRRtbNcYcK0DbonNCCmQKtXksH54CPrUqRjZP4jd78l6gfs2obfj/m/DpT7qgNEgLdOAW4kyLRr4GSkNxOIdJN8+OJCEGyPIwNimCUYxJmYwaq1SZQBYnjRCJwL/fUs7oub71y6zDz+B9uk7p6W/KxOF+HcuHfaJAGVcMK05bm+Jld2efh3o2RcJMVR4C3/sR+ySJhcEjogqHz3BGmqWKc+8M7ZxkGlO1k7ue425wNN40zq6gnUf6l0JOPno36nPEgWWelf4b8hPoARnUTla3SQbUxRws6cLYT7If92lNWCdw69m9kgLi7VYftha57wFw7u
 J0bgibzw
 vvO3Cqa19kwA4iYF8enV7hDsIPaYwFdJf/yqeURRJqR4MJXmfC8SBdXmh2tLoheeUFxYiJZgg+2z/Nxc5OjiNjHn3Q8d4xLZtakETg1I+RsJVD1PjGVWHH+u3LZ0jBnoOA68xcUUBbQ/LrIclFBl67skLkCtvD2VJqiWvRm0PG7KqzCxQvqh6iD0wow9jW8XB+OKRAfv382YDQ7wQgiwMMWlBzWxJC7awIHmSAHJl8U7ysDWMmhKrjjA7OlwKoTbaIYQ5afbF5h07x5hyV4sZdLR1j+pgPHWl0YPWS3tLQ48DZJlXROgZsgkqD24BpXkhW26J214e27LjzrZFKrPiDSZuECg9pTwQ/Lc4ThfneWpJCi2CaiA9j+v4Xs38x16o/lp9B85i/tNIcDU+utb876tQ/KfWthpjaCdydyqXaPTtBDvRZydU8DhAl6giKmXY+8oGDX65GiweZRkNV2bfdaanmCdXCzACkdrtn7AOgC7SV56PcwNNWAl8lS5g6VUrmPqb9RQjt15WYnEoITWiuNhXZE94j+Rl5C4VKzurEn31W5Yxs4t6ZTdKuFffMUHsJW7cpHT8wmI5FJJo4G3RlgdMnFMQz48tlL+lxGA9zSw2nZF1OZCEp55aRcvUVdSBcyZ+zPFKd/iQ7vOI5qF5QHv/bo0Rh0K6uB6x+jpoTOISphI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For x86, override the default implementations of content mode functions to
handle reporting of supported content modes, and application of requested
modes based on x86 VM types.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/x86.c | 101 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9c29407712580..3bbc8ffbf489e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14078,6 +14078,107 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	kvm_x86_call(gmem_invalidate)(start, end);
 }
 #endif
+
+u64 kvm_arch_gmem_supported_content_modes(struct kvm *kvm)
+{
+	switch (kvm->arch.vm_type) {
+	case KVM_X86_SW_PROTECTED_VM:
+		return KVM_SET_MEMORY_ATTRIBUTES2_ZERO |
+		       KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE;
+	case KVM_X86_SNP_VM:
+	case KVM_X86_TDX_VM:
+		return KVM_SET_MEMORY_ATTRIBUTES2_ZERO;
+	default:
+		return 0;
+	}
+}
+
+int kvm_arch_gmem_apply_content_mode_zero(struct kvm *kvm, struct inode *inode,
+					  pgoff_t start, pgoff_t end)
+{
+	switch (kvm->arch.vm_type) {
+	case KVM_X86_SW_PROTECTED_VM:
+	case KVM_X86_SNP_VM:
+	case KVM_X86_TDX_VM:
+		/*
+		 * TDX firmware will zero on unmapping from the
+		 * Secure-EPTs, but suppose a shared page with
+		 * contents was converted to private, and then
+		 * converted back without ever being mapped into
+		 * Secure-EPTs: guest_memfd can't rely on TDX firmware
+		 * for zeroing then.
+		 */
+		return kvm_gmem_apply_content_mode_zero(inode, start, end);
+	default:
+		WARN_ONCE(1, "Unexpected request to zero for vm_type.");
+		return -EOPNOTSUPP;
+	}
+}
+
+int kvm_arch_gmem_apply_content_mode_preserve(struct kvm *kvm,
+					      struct inode *inode,
+					      pgoff_t start, pgoff_t end)
+{
+	switch (kvm->arch.vm_type) {
+	case KVM_X86_SW_PROTECTED_VM:
+		return 0;
+	default:
+		WARN_ONCE(1, "Unexpected request to preserve for vm_type.");
+		return -EOPNOTSUPP;
+	}
+}
+
+static int __scramble_range(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct folio_batch fbatch;
+	struct folio *f;
+	char *kaddr;
+	int ret = 0;
+	int i;
+
+	folio_batch_init(&fbatch);
+	while (!ret && filemap_get_folios(mapping, &start, end - 1, &fbatch)) {
+		for (i = 0; !ret && i < folio_batch_count(&fbatch); ++i) {
+			f = fbatch.folios[i];
+
+			folio_lock(f);
+
+			if (folio_test_hwpoison(f)) {
+				ret = -EHWPOISON;
+			} else {
+				/*
+				 * Hard-coding range to scramble since
+				 * guest_memfd only supports PAGE_SIZE
+				 * folios now.
+				 */
+				kaddr = kmap_local_folio(f, 0);
+				get_random_bytes(kaddr, PAGE_SIZE);
+				kunmap_local(kaddr);
+			}
+
+			folio_unlock(f);
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+
+	return ret;
+}
+
+int kvm_arch_gmem_apply_content_mode_unspecified(struct kvm *kvm,
+						 struct inode *inode,
+						 pgoff_t start, pgoff_t end)
+{
+	switch (kvm->arch.vm_type) {
+	case KVM_X86_SW_PROTECTED_VM:
+		return __scramble_range(inode, start, end);
+	default:
+		return 0;
+	}
+}
+
 #endif
 
 int kvm_spec_ctrl_test_value(u64 value)

-- 
2.53.0.1018.g2bb0e51243-goog


