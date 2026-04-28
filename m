Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0420CFF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6386B0104; Tue, 28 Apr 2026 19:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656316B0106; Tue, 28 Apr 2026 19:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51EE76B0107; Tue, 28 Apr 2026 19:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 313396B0104
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:34:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B80E1411F9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:47 +0000 (UTC)
X-FDA: 84709549176.15.31C7E0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7392B1C0009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sbiu4tt9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418745;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AxQVIxnfllQe6Puh4LBJmGEnO56tGaMyqT4iVOZ3z8=;
	b=ZathN6TQevkaTLfREfq1+RAo9X+N9GaN1U/PXV7VI0LYz//5G8ug4dgEaRgLYM+G9cyowa
	7c4DdInh/In7YjURMTqCY9ZbFSAj4vRLzM+iRzLZHaYbrLLcl//Xi1/vNG0QjLYMAn6aNg
	RHap6CY4SvDQlyE/aoA2ynBUi0cNl0k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418745; a=rsa-sha256;
	cv=none;
	b=wVzkY1ID8dMcY/0CVuNUvEkl0ZsNUg9ObNgv2QBsBbYzyYWRzBMX2HJUe3dB4ZCkF4ffHL
	5Av57TGqLeQvGSZWUWS3plnxWtR+lEo/CrPj0Qk6FHsdziEUxMvptLmmnjMEIwq0zdd0VK
	zmT/wnzjFtgVcHJ2osVfsflJJR222mo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sbiu4tt9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76D3244B92;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5388EC2BCB7;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418721;
	bh=SAmPYY8ikK4ezlQwpFa0qJSjGj7Hehm7adP1PCdg64M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=sbiu4tt9r3333B2m0VI4lNS1EPVTgi1gSvQG257nZ0yeOBC04OLCI7S8P1OKje+KO
	 OOI8LK2gNImg+0V2pPVZsRqr614T7l8D64kUrbZ164sgfOCdjhdLJdzlLJ0zhlfgLt
	 L9+yfg86gwoyUrUXj+spY2zQNgjD7y7+IVm5gfJ7vKOpnO+Fx4m7wJzln6xfV81pd7
	 ff7ZZczkzB45dnDbShWr28sTNyJtDAwBxaOfswmWlD+0lWWgY/nY5ya9rokXj5AEle
	 zR34Acdgw1V7LCYve3zsXffG+mqNYAVkUWoxQ1W/7GEZzluPLgfAYuWMuajrl6Ehnw
	 yVraDDJW9ePEg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA54FF8877;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:43 -0700
Subject: [PATCH RFC v5 48/53] KVM: selftests: Check fd/flags provided to
 mmap() when setting up memslot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-48-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=1296;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=IxI4eTFElDaAEgNuCkIQkVDl6ebpJJNnDFRZJGqwXQw=;
 b=WwmI5IeOHhkqMGZ/qG56oUC8AyqB97cuGsLr6zsOzEnvokGwUPESMchcaDt2kB3vL7wLTuZ9f
 DlnHwXKVjgEANKol0SPOqnV8OKYSDjJDIZc+57uveI/Ja+R6yt668Wm
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7392B1C0009
X-Stat-Signature: o7gyp6fdp6zzxehsb5cmi3r5d3cygkaw
X-Rspam-User: 
X-HE-Tag: 1777418745-379474
X-HE-Meta: U2FsdGVkX19CtKfVkNJk9mdz8wRtbO0LCQ6Y21H/K2OLCiH8wOjXo7+4C3ITieMR2uIdb0TQcdEazWdIGkQA6QSG3v3K5/1GmKK/gbnTU0kEFKnTQFoTr1YJMM8751HEg7vnsnq+FTkEJs6mk48tP0lmjVdqnwthejVqn1HGuvLJLtKgdxhnChmfZFohtYseHmCetwFejT71YmkLfqAUDENR8md6oCzqv+i6sm5bbT5LfaxCP22pKFOKpipJSCi0/lKO/gAiagyP9dkejj5Ut57Uq/WeQZ2c5EJ616ABr4Rupi1Byun+y+0PoATYEilriMuu6cXIwsSxoutZWSdzuzREFmiJ+LdH0VOIbCcFHciIiwDYqbAhnlFd+xQDwS5DgAnJEpa68jhSCTKxiIwNXQQcZiH90e0W1Inkm/omRcXb2fE5NFRYojG7g/8AarwINGrbfPL2ZsMqVzZAMdl8ilrotbyTBvDE7K3UOp0XhrHtyqh2JF8nXuQ9nXEXhYCi6beIZ1JlEqeRjADSQreNPAGoI4GVebTu2mnbztZijhNb+PukmwdBcfccKxI2wJvbX66fkavwk1N+DgjfKpvf7gTXxP8jm7lIJI3Y11dXmjPwtD+wflnR26ML69hk/0IbTYSWBT3HjW3wMr30MwKFl75e4E8ykNwY+DgJGmVNQgVtAW7nPwFSA7miS9oP0NyLUL7HLmJhaUcQjOYLhGnPK1hXZ3qFGtv4xxJqYqSfIp5fO4aIGZhm8YKzc+JMYujcrGMyAho9fXBEnyAgE5ZnuK2a3xuPdi+oTZFURDAtVyBUxUqkD3V5175ADGPbOhl6SLGQZL7Qi+cO6Wi6qFZ8a5v+b6OyCpZtykmTiBKPszpt7ZvfcnojRKLqx1NHvYWbe83vqAh0ZnWwR3xyZdZplbsOb4bVxhJrRKLrDbhxjEmIEAYQ+zgRX5xJe5y5yZUFB/mNd1Y3w+ulMcjp61u
 KylGhDyR
 sACwHeVlYQK8Xmct6hKn5Nhsp47seJu78pq+cRF3UwDdb2NOT/BZf7LglU+PixCe0QF7DbEbjT1Y+E1Fp+fO1BfOl5+2QN8UG9tcKZdyv6qEiwazBE21Z1JqjbE40TrMF+qt5QF1TFFrluFeIHL9iTn9yYPWsQj4TxsqDC+D6hiA1UwbaXqdodz0/3Ba2XtmOxz0oeYYxinPOxQ0ZBwp1Hs9cuzC4uIxnCvFQv7G0syKhU1IexvzEj1hRNWmCuB7z+Bb7si+o9/DYWxiiIAiJ+C+5sA6V4s5H/TFE+7ZI9I0y6BCGWKl50a+FZjmFef3weeTBUldcCkN7Np3+uAXoSOIsWUmCnaRDUFKQJwtWYpTMULVuSDOA/5oRIheFMmtKFSms7dgxokRFDymTq+BEB4yBd8IufM7MirNR
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
index 12e031a8fc20d..29b3f4e9fb4a7 100644
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
2.54.0.545.g6539524ca2-goog



