Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B6EECD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB116B00BD; Thu,  7 May 2026 16:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664486B00BE; Thu,  7 May 2026 16:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579F66B00BF; Thu,  7 May 2026 16:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 476776B00BD
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 127691A05FD
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:15 +0000 (UTC)
X-FDA: 84741748350.10.749EA55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C5CE62000C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nD23O150;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185392;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GqABZPMaxro3T4KSd9QYg4RThW8bb3lt2V6jz8CKAXg=;
	b=VCc1jciNYpkFUwX0yapJSs3Usbi/jMHIf7aDVK/zS4lecdG41FzHoO5V+jz4cNa3L0Sr3G
	lQJC8P/AMvFUzJVgM4gTC3UTnDNjz3gG3HWp58RvlsQep7HGKzJTyLlm68JNoQV5bbRMiu
	PqIh2Oh98yOsSl/6i7s6LQtzmSt7iFE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nD23O150;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185392; a=rsa-sha256;
	cv=none;
	b=KinOnokkwaQmFYjcArt+eNvIynVKmT1hh9DgEA2bXjtpgv9/TiNreoYVQsu8/y2n1hfTKv
	hF8EVrZUlwX5veTmU/VIYkcEj3mg525CVedkaIOXwVGu0sINH9elnaNGYjqc7Fbv8l7RDF
	H7CgItJsijqXn9R/nIojVef87ktdGqg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E9FB448EC;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31174C2BCFF;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185373;
	bh=1NB111VWMMIbtLLMaZhidTrmdjE0QUTjYTzPM4ECTnY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nD23O150M5kxfo5P5NmOGYLjZ1wLSoVuj2fKNaT6dcOXKmDn98eMeXbf06onyK1w9
	 //K12jZviv6ykZKOu3HmsoV5E455JC3KCtY5hKPfflTmB3e5lHt+Ss7dA2cdPcosOz
	 d9fBjtre4+ulurcD15ACbnpwYRZl0fZ5Fd4hhWQd6WLeakxfpnJrOUEt76yYLXWF56
	 LnXDzjQ1NFjQCZbABZFFeuYXJzDtcqBirFK2nOxlOZArnS9LwbIg1FEVVfCVoB1QDP
	 QD7IQRIz8Sm6mBfS4gatvwK7czORbEgNKcnwsWCb8HOh45bbLTSsqhAYcsfdZLwn00
	 YJC5ZJFoc6izA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24881CD37AA;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:58 -0700
Subject: [PATCH v6 39/43] KVM: selftests: Check fd/flags provided to mmap()
 when setting up memslot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-39-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=1296;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hcETOw3sAakUfUaKNjQnUdIZ+346evieR+VBYLGswB4=;
 b=cIj661j8IDgWy+PWu4jCnPKM2SLywbk1kXdBd+D6Q62oSumO6qZFaetZYpSu9OcQrA6xB94ly
 6pW1OA/sb4VDv5ZqJo7uX/yYjODzHvFiNDing5PYpFUp/jRBn9+zp9T
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: C5CE62000C
X-Rspamd-Server: rspam06
X-Stat-Signature: 1wou59rezz6euw6xc1uogrzsktm1hyds
X-HE-Tag: 1778185391-844117
X-HE-Meta: U2FsdGVkX1/xVksRaMbPUe4mSpXWl/XuXlxPqEt3Bsm1CbD24Y2acoFugL5rfGwRyNwjgJ+BFCoQIpHFQozk7GV9Lmn3ZJBf1/fEj0hYGvsLIfe5JvzDTPSHq/WEgVHhLlT8Y0VHlHxko8o1OtVoKivc+m2x4q8loAabsE8XQ5iiv6DVuGF67yoJfZUUYOHFYZg4K0QScwabAAmNGSAm937HuZjqJ6gsvOfWz25uEmknoKwPJsb7jPu7//mh5bSJVcS9ZP8uS+zkFC7qRFbfIt/15PSFG+xEc0TB+OWDew1KPobM/AhxhU8kuCjXxrZ3+uquxBu//9z7eb9QDvEqN3XmeL7sjo627Ch4pSts+X54qJnnZO2aNv1DY5G4+1OTQYUa07fUZyws5iBammKcQdcCL2hWzYNb1BMbPTMOwTWe4iilbkHD/QrgwTKQ3QVEMm6xnTfLTam/Yro3oUlATW14kYs3w9nEE6e5sJGCbGE3GFKZCYcBDR92UhXBqrdYda/gbs8ib8lHvxqYWbL8QLV8RJlFxCR1mTWI8lcmYhGPl8HlisznarvvUf0fHCntjrYqwaZDwPverqX9PNC5qp/95Uq2+mw03IO8SMrhL9c37QVV8BHj27MuCKZaD4axKEw/Hi72OEVTESW+lI/DHv2DA4DRZpIy1HQ5LEJgtHyY2LIoXILjJVBW/Iq/LQzHzavSXkSlhEa+hBgNqmifzAz1E8nJ2AkWrY3Qmum7orAguN/wUaOMqtSZfl6GEFcPy4ep4J9yXeIdUqtCyT2wqBo5fHiqm+X1Z8LHlBplV+FtIrKSWJ4n8DMbWxcCaqhOzf294N+Pzj3N9Q/4Ef/Psez6JMXEuiNzI4MxcDW7RLFNzFPdAvQJXyKjE8adRwVQsPZ35thp27fkECC05sQCDfX+7gM7VmjgDmN2pxAjMfSRPfONdjeTFAoSxLo1SMaGJflt9YSopvBqpNAJNpc
 Kaph6Kn7
 FLyxLzcdaye3ya371h1sUrRvCimhybvCtWv4qZL/2wjGG6RcEfhMS8X2UFMu41/xT/cQrOW2rVZY3zhljmm+LHY7d+AbVOGU484dTiXCE/ukFvsumxWylOHSUWZd9hjURFi4dydQB1tMZMUq4h9k9lECcNSy2OBJAn7cYIaLUt3LEPnaBSA/xYH+Y+XipVA0ukgLxxeE8EB5slhZjvcW1lVIrojpWpWIm5ylSYbWJKJ0cXPGY/wdk3MSCUU+BqwOEPlAmsKTZImv2aQgR1hS1HroSs5YcFb7OTIeWeepB7qNHBudNaSKOD3ijHCtajbjq/xNUpkm/oiO5i6oS/70hJzoNpuLJtqoZ59GsxEomxebka0c5tby87edGik65mRK6ymm8VStVeV7uPBCu72bkd2TImJOj3IiRnnJD
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
index 8ff09e179ff5c..efad3e6b19f4b 100644
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
2.54.0.563.g4f69b47b94-goog



