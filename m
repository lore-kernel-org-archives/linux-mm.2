Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2946CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D986B00AA; Thu, 18 Jun 2026 20:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088E16B00AE; Thu, 18 Jun 2026 20:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0E76B00AF; Thu, 18 Jun 2026 20:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC91E6B00AA
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12FFBA02FD
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:57 +0000 (UTC)
X-FDA: 84894784674.19.E83D56B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1DA5118000A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aT1lMDnQ;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829115;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/kCFDAQmLaOve1iHpwl8EC2e8MmkHEe/ljbEU5Zu+E=;
	b=E3p9iQYq4EXstX4krl8yITaqT5YkYXP4Rb//xFcs07HBrKNBjbtNWiNmkNSaXXI8u6bYN7
	Zao8A1bZL2Vi0/z7A2VyTPCgwvmgWyPx8XZrg6Oa3onb2X5z8qzym/k+0ACYYo8eX/vwUu
	eUWgsZ1kfzt1e1aXg+r1ThXjS5TMEIY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aT1lMDnQ;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829115;
	b=SC9ApRpOfvJ8YkK8RVoKNzWzgf3aQZd9TqwxTDqA/lsly3hBJSq6UTcnQI6kIBKA38AVQB
	5P4oUiH9S0m5Jz3oOSGMFZkCBXj9dLvzRH4uGxlVOvM9oQ3jGOzwFjsi+XvquOIzgAvGwG
	DiFT8HHziT2jxV1t9Hm7gr9AdSs2eJQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D3F0C41A93;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AFE82C2BCB0;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829108;
	bh=zwr/kib05D0i/Eehwnu1gSWwPlJmpnwxEu/3mfyz01M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=aT1lMDnQ/Hssjko+ktcLQNhGZE4FZUIEZhBPBgI6uihEym94fE0u8rmBUGf8oidOJ
	 S/rKVLw+ccs+VMsepcwFDhZTWYLLyBX2ZqpBvVcHHgyggkug7/Nu2J1U1RPCzXesdt
	 AFQIFyjheLB6PD/SoYNfmjl9GM/qBOORKEjtnf4Y03puH4aGCGqneKnbHpnvkFhXc/
	 O4yoKgkn/o+Kh7TaIrmbgAQfdgLfWuSDAs2JMZcSa2jqsoYZyKiJ3QQ07A8h88WcET
	 VkQkYjL1c5ydJ2G9idxWW/kJGVr1BNLIiKTnFpzTbTxF28+QYGPAO9vxWzXSDW+i+p
	 7/0xriAVQ96zA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A637CCD98FE;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:56 -0700
Subject: [PATCH v8 19/46] KVM: guest_memfd: Use actual size for
 invalidation in kvm_gmem_release()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-19-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=1550;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=2g4cy0ezLsimvjBUeN80lEVTjw7VPhXUpjCJcq31lAQ=;
 b=6SZymPWXElVmP6Ks6J4dZmntqiQYDHtI43GPt0vGuDfQzqECi0WCLuV/5v+5akHZjHb/8CzX0
 QeO5kliyrRiAG4Q00KInoT8eoZhH98t8zn+L8T76Kcci66v5MwF141W
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1DA5118000A
X-Rspam-User: 
X-Stat-Signature: nyq5duak9utm6h58m191t9xbxhpj4jf6
X-HE-Tag: 1781829114-655701
X-HE-Meta: U2FsdGVkX19NyUw2OWkewZRY+Pf2wPr+oLVvWfEcUKcGgLoRqI/YJvS94XAjjW6V+8mp4Kg6wFddzYD3yzhJn5MUzYcaQAVIDxB05GjZ5u2zNWa0hZK7fhlizFbjQQ0k0Z9yszfqLYSRLzTX7Kar/TcTEjkmiIflrsRFO56fhllTbnw1fxqfbUHBoR/GqvwAcaSRPHsHd7qVE2PwFIvgTYAai5Jj10lLqlHbJbQSOVt7Nt5RMKek2CniErByHP4omxAvjVFxWMUL0Xxn280P+eftV0p3Yw4Unwan6fezFHnwJ+7dXGD0xCcEFfAMfTgZih42SCc4iquarZTwv1NEyrVq/9e+4Keys5UobscLXLnF5lbtUE42FiGuhIvWrTqw3y93BwYscFu7354MPmtgtodXlCYUoY45ynyvpha1tNVltPCPEKpXI4Li2A+gtgQIbBv9OA34Q9q09gT3uVu5PV+I3DReQpkbcSLp6Fx8R2sMiMjrU/sZvjNSRpRzmkaXJXRTAoBbFt9TRxt2ZY2T7NoPZPGFthyI7LJqPJna6tIaDVeaREw0xj5DYEzIF6P7qen6GxsShtD07JKcI6b23yGsgZjR0Ox+AAhkEUk039SiQDUYbvN4QBRjMbWX72AwSITTeJwd5zmhGwLfy+EMpp67PZo+K+AFOTpyuW6ipYF0UC6Qs+Pg2NC9GGSDk9CJdiv/6J3TcpD5s2TQDNicvuwQu7EF0Cly3p7PeKcR8Yx2NTq2wBM8AqBfWDzlGC7sXINLfbO76dj25bW/hGqGE7vRqAAXVx3AH4gU9QE4DKIv9nA8DdMmubufsZgRAkezsg8cpD0mQYh/gckhCThYu7tFI0V19K/VG2av8aq6zsagazbRfNPRZNDAazOjxR1GRXbrrTm1HWPP8va+lAktbUEa3ryJrxHlqG2igKzsNBua61wOs288op/PbXdKAJVMszKS3kmaCuXBqfJw0tV
 ywF37zE5
 adAfOUQ8DwNtbkaxHsNHhsbioS/eTNgiBl4Y+qUFz5vtjNTrTWJvHGVVOIzlEQQZAHOIpblhkxX411CG5qlrScuFLlYHPiveL652BsQD9uNSyLNQPpl2SmRvIXRYpAUlr+MLDrVXDmoICdEfmVtQZtiZTHz6M8VJBXXh+sHlLc0cm3yeZ5o+1YBTalvArDS/CVgL5ulKVRoCLI0kcWBh2UqV2/6lqcd5I7V5X5gKkfkdwxWPyzRV51f9azgkjwSXHn0/G5/hYyIP+Ag8vhxfZ2m1EWkp7YRdxNVrswnX8YFBJrtLdZzGxNAIfqJkWHL2G42T5AS0jp0JL4nzjHlCjj5IWeabwuSAMHBGffVriihFV6yXOWLoPFK1I7sD4v22rC2gLOW0T3t/tOcqSNOonkraziDPKPZQxLMK6mGJq66IpJIV6FIp7MkphWtSiZ3sAaFg5427qEBDooJ/9SsdZmIBvXZ+8UYQcVr9/Jdmcn6uMCJqRLk+9QF+9jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

__kvm_gmem_invalidate_begin() and __kvm_gmem_invalidate_end() actually do
not specially handle -1ul. -1ul is used as a huge number, which legal
indices do not exceed, and hence the invalidation works as expected.

Since a later patch is going to make use of the exact range, calculate the
size of the guest_memfd inode and use it as the end range for invalidating
SPTEs.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d163559da0235..d72ecbfcc3144 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -366,6 +366,7 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 
 static int kvm_gmem_release(struct inode *inode, struct file *file)
 {
+	pgoff_t end = i_size_read(inode) >> PAGE_SHIFT;
 	struct gmem_file *f = file->private_data;
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = f->kvm;
@@ -396,9 +397,9 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	__kvm_gmem_invalidate_start(f, 0, -1ul,
+	__kvm_gmem_invalidate_start(f, 0, end,
 				    kvm_gmem_get_invalidate_filter(inode));
-	__kvm_gmem_invalidate_end(f, 0, -1ul);
+	__kvm_gmem_invalidate_end(f, 0, end);
 
 	list_del(&f->entry);
 

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



