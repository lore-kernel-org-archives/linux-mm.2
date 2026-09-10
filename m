Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7E73C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132D46B00BE; Thu, 10 Sep 2026 19:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA4C6B00BF; Thu, 10 Sep 2026 19:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01EB6B00C0; Thu, 10 Sep 2026 19:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4F16B00BE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1DDE1C28A1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:46 +0000 (UTC)
X-FDA: 85199512692.23.DCE296A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D4B61100003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ajjd34tp;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084545;
	b=eV/7HcbMgvY9UKRlT4Sjv0IrTMvp4K9DxPGkmpKx3NWx5gxcJOgkOlTVNxtojwb7lo6sCc
	e4XY0vZiO4cvZTf0MS0ZNjC5qS0bxodmJWONUOMUe/BY6UA+wvUnzDcKX9S66oHiA9UtI2
	QTooEJ5rDCmv/qODVpG4VH1QwZM3arg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ajjd34tp;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084545;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXKMQxiyASJNNVEed6C/y1LN+Us59qZRmphgw2ptmwc=;
	b=gXiiD9u87ZWknqL6Rpzj0lYvqR30nCfS2HYQEmxoSCAYz+6DD90LeQYQmSLFIyTnz5XWMl
	GaM+uoQn/K+aLEMSvnu380FR3D4p87570d19K7cZ6SwE1VvncOlffidEs0gUZxRtzyVXKU
	QxIiC984jmUIv0dCrZyqI3WCoTY0bPc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A45F1447E3;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77ADFC4AF0B;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084538;
	bh=XvjyT37ewda8EokKetwnMlMrgsCA3GmR9B7rATZUyhs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ajjd34tp0B6uQvxEznltqXs4GsPO5rw2rsnEIEHQmxj3ODTA/u2Kuz3JZEP4E7pRu
	 egLhdygCQJ8EFzI9z2ftznjVDVkB02qh09ruLjRrticoXhE84wbkKk259nRhDZbrMl
	 DFIfVfvNiuKyoDTr5y3wx92hnKtlhRnDnIRo01IWDnrFuaKf4rTapBnecl+ZK0ye34
	 Znc6tNc/R/xwvhJkjA5UMOUmYC8jW4kuKcS7DNkVZ2J+3txwte/Ss3bjJh1y0IbaL7
	 QdxViihlE0PWTey/vWFeO6HF5ytiwmVvQT4o4XC5ztZRAN6kZ7VQUcJFZoKwn8hmGz
	 3S/8oDK8X3QCQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6027BC88E45;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:43 -0700
Subject: [PATCH v13 17/44] KVM: guest_memfd: Return early if range already
 has requested attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-17-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=2021;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=aWC7q7TfOQBRXxfaI/bprLobieqMQa31lPnqLIZNQQg=;
 b=IvM3zmLIvg3kdTU+xjwTpru5AZjxzSMMBzH6CkhOdmQqNSixiQVfVxaHsotMs8RT9igbUQ1Y6
 YahMx5Iaz/2Dg1du2b9n8m84m0G29Yr2OT1rQuH/JBCvLFK9otOyy2P
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D4B61100003
X-Stat-Signature: miry8hr3acnz7bj656b4ptq1xyfgz447
X-HE-Tag: 1789084544-720333
X-HE-Meta: U2FsdGVkX19X95LLkDfxfyrok2MiEX9zJ1Eb/h+kW8OWRtZhGjCuYROe3aAYhI9C/wjFDjQCBPwVhITgMaGVeG7K4xi3TgWEFEWMdH791DYA+iqC4TdBOiZW8RQ6jYY4RqB+pdZsiyy6/LNuAg4ZbutMtuO4G9Yf7WVhw1U8VqC0+hE3c0+UKzdkLQjZ2ADafCzlAXNLEc0PKT4rRw+0aQVnMkFs9navCrGKI285KfSpTccVBcfzj1f63aoSZ8j9rnKFe+TObkOsC1QBybNo6vGowZn4+GX8z/MbfyqNGrVzmEL6QydS9Zvq/FEcuxo97DCwJYJc8txpFl6Rydc1GC1bStJgCPNtKrdZh6YkCF08fhxMwr8rYgcEKq4PKe90Pz6FVe6vrq8e6rw7jzZIBI5PN+pH27hhF4l7A2uKZ1/XPkOOjMVKjM9g8uobP0I1yp7yG2ybfh7Kg8uzwPAjWzNGWRyA2xZgaajOhLsw27KcD+LN1ohKsGFIluvEBR7AfyE//MUrC1XSywTSOc5oJTfx+WeZuyTzS/LaZyCz0EpRPNTWdfxO7O3zZTwMToK/qIPiqUm1kwr1pLwOwGY+8wvwO80MLHRqCR2FHwuvLGQD8wffKs4kaoYhCV8fqHe0gWlPsRVhd9U14i5i802XWWSmN6LDlnAkNkROiczz6frIlSmXqyD9bxPvsvhffzGmQI+ZTNhPP6S8uij46SQI16BxHnFK+IsmpWJ5owI3oMErUgBT2WNxVztrR2HHJ6/IqbB26LijqZydrq+ZRk1NShOyNyK/FAtZNyVI0dWmDyi+/pkqgTjyKX0D4HMFLzIAO20/H9bRdU9lM7YyagZ5ti6uM7Ls2dAoy7+mz2CM6tOPr5FMTWLA8v15fncQzqqj5AmWBtA2P6PfKEgeQFXgbk+9taByPwUdmuthgFAMIClcoOX0SyNxA2OVNqGlsDARRwygIXoPps2h3KviwqI
 1KhVB9Cu
 hEx5zHR5xhhDs02SSEHgVc5YjRjt/8is5PJfLNvWn/h+6MphF9Dug88xUYO5rs1rLA9PIlUG9ag0uHZrNt/FSzQ/gbkHOQ7lHdMeyifwxmJQvgXjkXdL2zuxwkJIJtSViTsc91YX20EyoYSc6w1g3wyLjdbbQgYEGpYuD1ullfu0yYengdYXKzDWlZnCaG2g7fQlhFEJGG3CVqpOp0lh1rapsbpY0kiNGT+6j4I2npipadbF0yHCl9GnlT6xobbWJf9s1GqECMWOBzLO2i5+H8SIhKsP3MXIh1uZ6LW9io4SthJZVoORTqnWSQLhl3C1/TI2PK95fc2yQGfrQPMOPqIna5Mikgh1c2fuWJ7G2t3RCkxxSMUugjFrKKZ2e9flkpJOvOD64CzRo/ZjQU9QsDXtcJWu+7Urvyw1QINIfYTM7dojNDXwpLFQvenez+d0EMQDEBuoAhhZJVGd+rIwGqyijnaurBKZYKiKaqdPYAL6TE9RP5eSW4XgApXdTCRUwxytMpHSy4OH+Gi545W4g3mPJ82jfCSmsfkaf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Provide a function to check that a range has given attributes.

Optimize setting memory attributes by returning early if all pages in the
requested range already have the requested attributes.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 virt/kvm/guest_memfd.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 85446fe720603..f1c36e99cd3ce 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -99,6 +99,24 @@ static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
 	return !kvm_gmem_is_private_mem(inode, index);
 }
 
+static bool kvm_gmem_range_has_attributes(struct inode *inode,
+					  pgoff_t index, size_t nr_pages,
+					  u64 attributes)
+{
+	struct maple_tree *mt = &GMEM_I(inode)->attributes;
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	lockdep_assert(mt_lock_is_held(mt));
+
+	mt_for_each(mt, entry, index, end) {
+		if (kvm_gmem_get_attributes(inode, entry) != attributes)
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -636,12 +654,15 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	pgoff_t end = start + nr_pages;
 	struct maple_tree *mt;
 	struct ma_state mas;
-	int r;
+	int r = 0;
 
 	mt = &gi->attributes;
 
 	filemap_invalidate_lock(mapping);
 
+	if (kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs))
+		goto out;
+
 	mas_init(&mas, mt, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
 	if (r) {

-- 
2.55.0.1007.g17ff1f9808-goog



