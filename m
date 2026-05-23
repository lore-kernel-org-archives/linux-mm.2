Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74877CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97A46B00AC; Fri, 22 May 2026 20:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25DE6B00AF; Fri, 22 May 2026 20:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FDE66B00AD; Fri, 22 May 2026 20:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 562B36B00AC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 22F7D1C0097
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:12 +0000 (UTC)
X-FDA: 84796772424.03.FAE230A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2CF952000D
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qk9LOsei;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495490;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wy8O3C4f7Of5EQsmL5pcGNb7rLzxUcjiqdTnusk3OTs=;
	b=DUHbzEXGGFOPWCLh9fUif0PANSUaqkqoj0ZKM1VfJY6SllqBDPkLkicIaaQ3BdIAZqzibU
	Xcpbe0+gXPfPNIXlj5HKItevE/IDQ/aqYeTbkcmjl8j/CV+++ZkqrNro6jCCquixCx4KUO
	gjz44i1QprjwIAevbkLsXQ+d/CKTu18=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qk9LOsei;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495490; a=rsa-sha256;
	cv=none;
	b=rixrwKk1jplz/wr5xJenHxwJF36Hcfp++rM+E1TeIORK+jqvge6e7gQ1YK1aAdcghXHasH
	jjnk8IuF3Q4kbp6KhdsMC5Id9fYSBtlkGzoig9qXkxPqTtrfi7SS0rjtE0c55edPs+JZpD
	YsIQuOXaRIALZRfS7eX+JoAp3Mt1ESA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D158D446A7;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71F43C4AF0B;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495484;
	bh=qUYjNA0eco5NJ9jVeC5gu6EUkqMfeTPF0qC2cGuhEbk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qk9LOsei2mu3m5JJabvICgH+P5omSMjflgrqemQKVy2tYqAsiryGmAMrPoTWHYziw
	 PGcdcL8jPvok78F4N6DyYjI4HV1DT1v0RJ2LJOYbkiWuY+sk8Y6A8UqbDxFhnd2cn2
	 DTqGmNEBB+Ietx8YwT1RNIkcF3klANheQ/vNVGScYh2H9m719AxWuDD51pLr1DM619
	 dZ1MvJxaDxvXwVIz+tWwPW2LZUnnk4Sc2FWNUvF0Cqw/h//XNSFLUya3oHtADJdfg4
	 nHtCgrTQpKB2v+IgFVeat4e3kyrLWccVWNg9bDHofH2EuWb1tK96EKbY9lfnNWPTcI
	 x05prZUAR73rg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604ADCD5BBE;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:57 -0700
Subject: [PATCH v7 15/42] KVM: guest_memfd: Use actual size for
 invalidation in kvm_gmem_release()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-15-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=1535;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=HETjd3B6v8GtRqbtrDZh0cSDeSq9rvnbWfv6A4pQb+k=;
 b=bxfoI43e31zSYUnX62jyjE4P7P4RIEb3sqiutPm5+T0GQNQ28QRWkAzRDB6NAynZC9lbOFasd
 H9dUOmPRfwfBZql16GfGc8C9DaNO7oqfimLH8GVZevZwQBXFMXPn5Ej
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: ng18oue3c78aneoes3jbigkzots3zqt8
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2CF952000D
X-Rspam-User: 
X-HE-Tag: 1779495490-15948
X-HE-Meta: U2FsdGVkX1+aEzkCurexfV85f06/MJ4tfYqEoeWBYbUZiqZaPiRcJtOKaXlzBcjsE1VqAbuYN6oFCgNejhBCpg5E76THb+FgV/6CJwz9Aw0Oon2LbbwiFX/PPo5LLdBBe70WEfU/UFwL7tZeih7RizIeXbNt6lGG5FLM6he3a++2nIUGF4z8KYoIPEzj1vj2ZqWRLwpmo9btGyFg7MUwangdtaPzchW1hlWVctNmP4hrxEG/s1ku9NP3R0f+ph14f7fGmrlwswfrhruXiiYGnxx85sW7WSVLg+NOVHkTg0PfhkSBiIqXmDW0KFofTfh+ln3VtxrtwEFSy2wKVXXRQI97c+92Ez1XbVWwVJ9+fsXVaESVY2PZMp3iL/mPQQgamc2eOepoKA5QNKgs7LeIS0lEvEJQqRCld8bOtN/99CUpKzggDo1Ne1TNOISYhkIesjBykMoYJ6mrj6eSUXsl1x44SBaOdumWsEgOTWiJbw/hNAlrEMfr4uUvx6sgYdFu/w09VuCcZgGJF+9fG5dCget7ar/PqS3upKNAeAOQDLOQslUDeB4OoGovKE7TIU8bHBOsZy1GTLqa2Gg2Er6duwxvk649DvEW94TTcpkGtgoizVxUPG59cJi7VP4OXOhfmWH8bt5N2hXBghnQfYQ24M6TAVvWiC4FJt/FuzSbiDGDSfB25HYTLWn5cY4qAAeIh87CIthNu/ZduGGB+xb47Uh0iWBcuIMseIFqG8UJDclUvWqlROCpNXNYvIIw8rHvR9iTzswtA2FbJ2Y27zNrNvFBwT6g1dzX3a9oHA34Ok2ZVWLkVxgvS5EYM7T11vZg6ZNcG3Lt7XQ0+eQ0IZXdUmpDJS8IFbHn15Znxz98YbiiiO4p9jpoCfH2zPbwuyeVSI/FQ3qnFzFQ/Go6hsCfW6T57J7LQsgiLfVBlf1mmbT7TrXpBVH/0AfW4W8Jpak84VVDmisoYrylVYvSfXi
 sx50xLy+
 3hJuZ/xO6F8HptOXkwkd84CSsiVo02fjGEP9/SvRQnuUmprwi7PtZd8xWrxBCXvd57JsVHgkO0kQqalVp+S3hNU4Ic4zl+TVsRhJFCHD0HxFbHNlLGv8Wa3jrkTZCQ2w+T5yFQa5qvBlDtdvfNl1I/K9keB+qNvixrLaNElVK/ilomutWs2Xb7BS1MJsJWiPX6zuy8lWpd01NXXtdI9/+qagM3cdyfXJVkVkQN30zvWoYwnN1XBgR1C9ZVAQU2kEBr61XT41R9pjv/lbmnmVJggrHfdHbO1kkFh/XqvVZBoHwkMcFKXQTkXjOTDypAApiYicyUvnkW1JeqXJPEgERmHVi4aUdl9sNmw6fNKYViPKrtkgGViFK09U1cUpSI4BPzCF2UQv5TrXK37ppXUfxKpQ6ZuV71izJeVm+5ze8HtpVwy4VLqV1LdZLQKkZzbu3zDGDWMsayxOBdS/rPWoXpSX23w==
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
 virt/kvm/guest_memfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 352cb8b837468..38b24f79ec223 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -370,6 +370,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = f->kvm;
 	unsigned long index;
+	pgoff_t end;
 
 	/*
 	 * Prevent concurrent attempts to *unbind* a memslot.  This is the last
@@ -396,9 +397,10 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	__kvm_gmem_invalidate_begin(f, 0, -1ul,
+	end = i_size_read(inode) >> PAGE_SHIFT;
+	__kvm_gmem_invalidate_begin(f, 0, end,
 				    kvm_gmem_get_invalidate_filter(inode));
-	__kvm_gmem_invalidate_end(f, 0, -1ul);
+	__kvm_gmem_invalidate_end(f, 0, end);
 
 	list_del(&f->entry);
 

-- 
2.54.0.794.g4f17f83d09-goog



