Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C2B7F357DA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84F9B6B0096; Wed, 25 Feb 2026 02:20:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F796B0098; Wed, 25 Feb 2026 02:20:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73AEB6B0099; Wed, 25 Feb 2026 02:20:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8B76B0096
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:20:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B7418B63E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:54 +0000 (UTC)
X-FDA: 84482132028.27.F1BB815
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7D5B5C0006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kYUoqYLh;
	spf=pass (imf28.hostedemail.com: domain of 306KeaQsKCOYIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=306KeaQsKCOYIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772004052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RDRU6RwH6vqwiVf/LjeEDphDyyED18VHPEr6YXDP6Vo=;
	b=k1wOClmCHcLp4F56sitvpr01QtnGxbFNYFt6NNwsNRK5xeV7xnXo3RZHsxzXEsG8njz5SM
	inHXfT4tEIJPiIKRxmR4lXMaDwtRF0QEHqsux9ClwcaQtcBBh0wV2339R7Vw/cMsaaJogI
	AOWVnJn3OmeRw5OgQzr+3zz85cGGkpU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kYUoqYLh;
	spf=pass (imf28.hostedemail.com: domain of 306KeaQsKCOYIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=306KeaQsKCOYIKSMZTMgbVOOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772004052; a=rsa-sha256;
	cv=none;
	b=zyFNLxC6atQFgT+d+ijZSk/VF5b7/xP1Or/RFdvOC/nxFsL4NvAy/+Y9zlinLyhgJF3lIr
	6myuje9qZZWS3MeCkyRJaE9CJ9zHlEjbcrDv+xHuUcv8iZaLxJA+O6JE5q+k1Fzjq5ncog
	QPWIQDJFC3BwkFB63AsTi1h8MseYYL8=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2add1118c19so3642715ad.2
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772004051; x=1772608851; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RDRU6RwH6vqwiVf/LjeEDphDyyED18VHPEr6YXDP6Vo=;
        b=kYUoqYLhbxeoIQYfXj71xgDKZBV+EHWOPFPTIx4I6kYQqbaTgm3pCI6plqP0tqio9D
         7eQ8tRpkPrLVCbR7Uc7Dv5jyOwTtmu529royJsHQQ3mxMqaoo0tpOAPy64TLAm77NQhY
         9ZQkF5k53ha1izLIdD+bgSCzYLjioaCHVpsFvKanmXnUYxjjuihCcFP9uthS7KyHetWq
         csAa1XOmmEBWFAjvKdkoryD8j7rTuF40W5NDLUjM0A7owh1vUXRDSl4ryWpDU4mK5Lo2
         L6PHgehRugDqrqQ16OQj5rgyBpY36Ugm2FlmFbyc52zdoojk4jrRqnA8peDRUnZHz/WC
         UR1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772004051; x=1772608851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RDRU6RwH6vqwiVf/LjeEDphDyyED18VHPEr6YXDP6Vo=;
        b=hbJlYOqI01RTWkKl1OGot7a9THAZvEAYUXax8ivUeAGgWNRHC0Emd7Y9Z7xjSSW5lE
         d5fnpJmgHo5wyFtSeJW0S7gt3ZDx9mU32cuYAe+o2zMKETwgPhY89m2X3jLXAHadj5XT
         6hP5mpWDbbOZsGGackPLzEOmLJ9ZxK7bkGnZgY+e8E34ZpBFDVWswEkDVJgnkeHKLcHc
         Hsdh3CG307ZHGv9CK4ec5egyDE9nlKTb0tPeEXL8Gvc51iksyAQwApJpoOB+5G2sglj5
         LQlNhmQ9z/hlK/TGThE4zCpED1rfmghHuKbGnhkBYhdD0b45lhq5zQHvw+IpcRXTt7Mk
         a4QQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYaHi4Z+cGCKvfgGa82Rj69jn4oWqXEB22s60QaMKewrWBPS1njBfLaobuqPAHKbciVphFkUonYQ==@kvack.org
X-Gm-Message-State: AOJu0Ywt2C2tdeZgvKlfNds9c5ioD0+8SJIlpVBmZWTlRQSm/JqNXzwX
	GE8XaV6KztsVy7LQkAwH2BWqeQabtKxddxj3jOF7VSpTxbDL4xOIZLaTimckWO7VZl57P2xNUP8
	BF+BDntyCo1SbjF0Ub+AjCzZlig==
X-Received: from plgz12.prod.google.com ([2002:a17:903:18c:b0:2ad:ae4d:4a00])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2c5:b0:2a0:c58c:fdd2 with SMTP id d9443c01a7336-2ad74516011mr136747995ad.26.1772004051111;
 Tue, 24 Feb 2026 23:20:51 -0800 (PST)
Date: Wed, 25 Feb 2026 07:20:39 +0000
In-Reply-To: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
Mime-Version: 1.0
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772004043; l=1673;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=qLKykmEADbn2/q4Ccup9gI+7j5uvqRK9sZMPeThKEJc=; b=PxKzCcZpN4XBlCkb+5wYqal7atRqWZJGyLYGiwIgdVnxm+1x2H3IPSPZKe0CxJWfo9pjig1VC
 VIXLsNc8fL3CSev+ABXwmk1qEQrJyPu2C3V81bGGt4IF7QyCFliofNZ
X-Mailer: b4 0.14.3
Message-ID: <20260225-gmem-st-blocks-v2-4-87d7098119a9@google.com>
Subject: [PATCH RFC v2 4/6] KVM: guest_memfd: Track amount of memory allocated
 on inode
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7D5B5C0006
X-Stat-Signature: h58szik7ze1jejcoz7ri3wnfx1hrzngf
X-HE-Tag: 1772004052-860863
X-HE-Meta: U2FsdGVkX18xHh/v03R9+2ajgmY3O6qFBnEi0BS1uZ1SYFsgYlDx+nAFJul+i+9gzoc5XYQR4I9+ZV8lHuJ43RYj9w1TM5Gs90McjcgkWQidVgDuiTUDCTibvH+RFOSob1cxntSTcVreWZx6EZjH7oaB1hEqmE9W9Vkuf0lUDYiUn8CoEumIhlLxVRzjCuZ3bAfKs+AB3cyZi9gFkrR5mv3IJlmzX5b3XwCEXeuy002X1J/8L0hxJmsye0oa+6z5jXqZgvvvrdHQHTBfuZkjH7FyTQb6zaq9REAact2FIFXwjxSBSFbQ+31sIAqaHivz7+wp/UEeudpH33sDkSltPMVetb2r35zJ5t0cqsjYnDBxc29XgV40FXL1ALbxJJUhoAF67msTBcwaz7S+f70d1tAryKIuKQp6cQmYcF7xu8PbhHc1y+hx3Hrq5KfsQkLfy1GzA7NX6GScoTAStZSpNGFHasau+oWGhBNN5yv1Vm+pD5aeLEay4ph7TyAAdQtcMTyhNvy4wKqSWc3uM5feCLMCjqxDBoFjquaCYAvGou2unuXwzAfEXnFKWkIQ6v/hmTPWRxjv3nQgJC5a4RQ898NVHZJOug+azfeAPxfDcHmZW9uTOP/dtiX/D9JTl3JmrpdAp13pFfrCubZ/6rpA7k2IwwmEvPbDorHOF5bGEnen+q35o5GfSlkHONcz/plphPPxH/+cVX45yYPNzYibKAqH29mo+qMLV0XodqJGP8sM8CuuI3e+iT4T6w693T2jgVdTQ7shBkOnbyCep3afCEiUZOQOKSZL22ZGvLs8P4nRiDapUXd+I6E91Y5ZzWrjQs8qKn7uSNZQjjtdYLjr7ogRP/Iat5jRHX8jA/pSjBmW8zxUX5i8gefI5Eb09MUUgV/Et2/58X8BA+HlPerSliMVGcJX9OBwVMG1v/XV83KgvT1edP2dKp6xY31h3OS/wUT8jOMoYFITpAIUKc3
 Oto4LRIh
 nNANEQoioZnGrF3kKphB77JxWFYHjws9E4g7MbqZaswiNP1ga3/aDnQeZfPNPllIbTs/5kGnJAp81fwoIPR0CHQERShtUq/sdXtT/eFulRCS0k+aOM5a3YQelLihcX3IrZj84YKOkurDgh6oI+dLqsaMmAnWumPSM/8HgDHe7a64p7XdaXHetaqRjn6SR7MMfkgIK2RgWhY6XXJFgk7OiS7Rwy/rdkN2phkvvj2m9Z5oPMaPz+riReZlB+FimmUJ8L1zWDDKD9Swz0f9aWBXs+EeU6HMCCr8vKBhDijT0a+MLr+orwGIZ6yp8rzFpnruMmBKC27Ri0fAVZaKDRqIXliCLTUpVfyycen8xF73+VMwSPVnraZaJ5WEQk34z+CDO/IEPpFugRO5Im61SUyMZVlRc/Tc4QVpGiWTmwCzIj6lP4bf9IbE5EXV7iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The guest memfd currently does not update the inode's i_blocks and i_bytes
count when memory is allocated or freed. Hence, st_blocks returned from
fstat() is always 0.

Introduce byte accounting for guest memfd inodes.  When a new folio is
added to the filemap, add the folio's size.  Conversely, when folios are
truncated and removed from the mapping, deduct the folio's size.

With this change, stat.st_blocks for a guest_memfd will correctly report
the number of 512-byte blocks allocated to the file, consistent with other
memory-based filesystems like tmpfs.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2488d7b8f2b0d..b31e6612d16a8 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -137,6 +137,8 @@ static struct folio *__kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 		return ERR_PTR(ret);
 	}
 
+	inode_add_bytes(inode, folio_size(folio));
+
 	return folio;
 }
 
@@ -553,10 +555,16 @@ static void kvm_gmem_free_folio(struct folio *folio)
 }
 #endif
 
+static void kvm_gmem_unaccount_folio(struct folio *folio)
+{
+	__inode_sub_bytes(folio_inode(folio), folio_size(folio));
+}
+
 static const struct address_space_operations kvm_gmem_aops = {
 	.dirty_folio = noop_dirty_folio,
 	.migrate_folio	= kvm_gmem_migrate_folio,
 	.error_remove_folio = kvm_gmem_error_folio,
+	.unaccount_folio = kvm_gmem_unaccount_folio,
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
 	.free_folio = kvm_gmem_free_folio,
 #endif

-- 
2.53.0.414.gf7e9f6c205-goog


