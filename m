Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 315EACD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7335F6B00BE; Fri, 22 May 2026 20:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6020C6B00BF; Fri, 22 May 2026 20:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4071F6B00BE; Fri, 22 May 2026 20:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0952C6B00BE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC0594095E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:22 +0000 (UTC)
X-FDA: 84796772844.01.E15C025
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id DBDB5100006
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CwmlVTsS;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495501;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2tiUxqhRjfecZPCKIvZ1g5UZlfEErmuQlNJbUIsdxY=;
	b=qfT8lZBJKKFvfJxPmc8WphJzlcJQPBp7SyW83SC2BDGANADnxxMWHQjWlvaZMtv7k6o4Ac
	si9BKmjRuA7Rj7bsRsomrf5QMLCvFKykuOEFz5dC4ssxyR7gWHNxIfq55fAQ5lD6UpkIPV
	BVJWD9wCA6nwwgmeHSeFtduTj0HFZaw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CwmlVTsS;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495501; a=rsa-sha256;
	cv=none;
	b=mE6DwjlMc4BUlKmxhhlRANGUX7yaaKMzjr0Noef2vDEO/EXql+yIEDkoqS3ARF7VzOXwAy
	x4IP3XhRfOdLbHCpTyLI2DvTDo2ml1/ufRqht3kN02aATZ/bLpml7KDFERezeutQDNKAyA
	kMi/yNAlp4yLEFMXeFU2rj2YnYpaIik=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2112E44E30;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0A8CC32781;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495486;
	bh=JIqs8C+lGjBiztTMRgcMv4CW4Nx+b+za+cxC2VySfXo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CwmlVTsSqqc7Js9Tno5mvbi7eltuvebaO8ad7/GfvnAtqv12uffiCdgz8UyjekXqa
	 uVccFrPxFNMQkahQpWemjttCmTJ68tiF812OfRz4gR6dI253MRcBDEXuEX3RsZ5tQB
	 X5UsMBrc0RKqSALDTZ2ABAplhWXhyW0Bct5+qN9DgIHephqQzK/kWCmQ4pNHDkQZyL
	 vcE7qf0lSNnC0b9az25DQz4mvddmsU1EFLaKl9IzePHyhe65/oRxjb/RvMmkdxaFTZ
	 ML5PC7QKTAHtGBOmpOJMyBvdfI3TGzmjsC2eGUuILZ0CGHErZkuU/dEvic4JI8h8IU
	 GYqVPeRHgumDA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A098BCD5BC4;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:20 -0700
Subject: [PATCH v7 38/42] KVM: selftests: Check fd/flags provided to mmap()
 when setting up memslot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-38-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495481; l=1296;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=AM84c6gdaIW2Q1/+PUgijcHWRW0I+2VX2PAGnhsjLWQ=;
 b=DVemTg0boTEieN+phW6EGMB5JbNUtmunQz5Dngjyk3XBw3IvfPNhMND1lF0wGXxWz3WjWBV1s
 MgXAnEhBbJUAb/ZPI6gRCpok/6GAyc2ElxN8iLKsUAmf1fgCgc2gR8m
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DBDB5100006
X-Stat-Signature: girw4pwpygg54xdzpk6h84hya493xq55
X-HE-Tag: 1779495500-261783
X-HE-Meta: U2FsdGVkX18Npm6/cDkfUauCY00aNl4pbUSahO6+wLOL8AeTP5DrN0ZuL3MLaFz90pGWDtvP9Jhs/120Re/9DpN6u8IayvkQO1k5u632gdr2InfNYeaW/5CWou996dqsvs2LZje4rD/xbX99WKWB4Sag62zPEalpt2NHQ4m+kEMcxfDOIFjPr/EctEw6ewIsLxi38SlJpWklC6fXd3HjhRsyx/3xsR14ls6TFXRXYLpmso3ZCHuvSkGpO5bGjvZc8TwKZ3pdavtxAc4j5LrVnjndPMJJd0Q6QjvPIv/CAeS1Cgt4pAcixRzM1WAexxnDvT7xVLzcbWjfWX7QXJ3pbYJS1nUIwzIGQRCFAbBwB+hVo5gyqtPWfEJ3iF/OQTdMaaMQDcKEFc7m3rqTRms7k07qV/V+8xGAfzg9LHRFdjonp6Yory2sC6IYC8o4aQWGLggAEabEhIw/lW7kDJYIteRQN5BtDoBm0gGDIc8lGNS1wwgsoi/BA7u7UWC1gboVptkMmDML0LlxIOhNqEZemTBNYn+7DsrWor2wHMK44C6e66D8kk3XKN+6LyTzrd9uRcXhdqXAdtM9lzTaRWwXTFt++dWZQVcz5lJmN52pdLhksi2N3iTs4O8A9BghbeGACzm8bd6052KndTDi+juIEW2qA3rof+bojFwTf6iL0tyPWfDLLTjXhtvxd85T91vyFF+/Lm3t1w9k/HTUQrBYKZKVRHxIhyCckBbcpiiZl4Lb4dpWyge0lOePQJ8Csbfu0oMAZONc8pYOzbFdrBU2HpyyADRT2Vct7fGVMAmBfHY4rnBNM5Dyy7ueqcqnB5s5TNmHGjsiL21luXKs45Rt/3rOqYp9cJKMnGxKZlid9A/MQW3O47kR8N9xhFm75GJJptExm87I4TB3tn0LAjr7cuH6ZMTThLFWk68WcAwj0yOT9FqT7ovoHsX7Llh6r13XYQsznkmIbVt0cYT+f5r
 n7fdCzxd
 GryyhCqw+zLvulYhpp24X0M3QiH7kTmltE37zljQRAgOTqHi0wlPaGPEiGzzzZzHA26Udt8lL2dNuDYdICxyWOeqPeMX1a4LH9HX1Acvs6JlYFpnhzLfH5IOBYuOJE9U7NKo2yzuu7fNFxqZnvTG5K3B/iYwsG2rHzRTUz0KOtK9HueelDxrUaMNpFQSXQ9Kvo/EUV6GP2KgImhmkpq+oJymK55+KGu1z9zvRN7UAjMiWenZqnsR75GZroQj+RxzB60RUvhDvPsmWl9RBt4qhe+15M518pUtwZhjgZkHFR8+2Nd+GRelwvqUzWkTqo8ovG/Gl4Z7f8bQ1B2KtMZLkJ+U0wSRXgdxJMdr7as4b8jlwkxyidjv7FeKpaNruPXsZB70FazgYxynltKBLY2xWr5eV1CsLFz+FYmeX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Check that a valid fd provided to mmap() must be accompanied by MAP_SHARED.

With an invalid fd (usually used for anonymous mappings), there are no
constraints on mmap() flags.

Add this check to make sure that when a guest_memfd is used as region->fd,
the flag provided to mmap() will include MAP_SHARED.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[Rephrase assertion message.]
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f8f0cd62f2f17..21c7e52a2bdac 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1088,6 +1088,9 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
 	}
 
+	TEST_ASSERT(region->fd == -1 || backing_src_is_shared(src_type),
+		    "A valid fd provided to mmap() must be accompanied by MAP_SHARED.");
+
 	region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
 					vm_mem_backing_src_alias(src_type)->flag,
 					region->fd, mmap_offset);

-- 
2.54.0.794.g4f17f83d09-goog



