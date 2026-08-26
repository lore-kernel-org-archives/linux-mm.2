Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 378E7C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46E536B00AB; Wed, 26 Aug 2026 05:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445406B00AC; Wed, 26 Aug 2026 05:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8DC6B00AD; Wed, 26 Aug 2026 05:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09FE96B00AB
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65733C02E7
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:38 +0000 (UTC)
X-FDA: 85142870316.29.5C7548F
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf18.hostedemail.com (Postfix) with ESMTP id 795AF1C0004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eTZwEyst;
	spf=pass (imf18.hostedemail.com: domain of 3aq-OagsKCF879HBOIBVQKDDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3aq-OagsKCF879HBOIBVQKDDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735916;
	b=gHpdlEE6UrbrjRSU7X01CzZvjMN1Hlilfpxb+etZSk59M15cpUUZlw9/Lpm4Km4dnTT0DL
	vGJCQSWZAUA80rSk19Uh9oI7He5QQUaVo1ujiCgV3+wA43/2aXFvT1IcBlO4Cod1SDK0JY
	AxMADxn79wHBMBk+U5jo/Ip2MtF8CSU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eTZwEyst;
	spf=pass (imf18.hostedemail.com: domain of 3aq-OagsKCF879HBOIBVQKDDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3aq-OagsKCF879HBOIBVQKDDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9viyxfvYsSlaAuG4kZ9V8QlGv88Bbdqdj5aKht9VSg=;
	b=RllBbrEGaCt2XlPiq5BAj43PWi8Pv9VEsZFQUAkbVIEDm9TTiMbt9L6Ta6vT6wz/4eIFWK
	QO1DeDEJp1j86Q2Zu4rpoSbeIDwhWMHAvJimQ1d3OH3N0iEgoVdwFIy99LRT7CzDm0ZEIR
	NCxQ2jQFEA0YIL0125qcBrIjIbhwbDU=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc6dd43737so9650095ad.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735915; x=1788340715; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D9viyxfvYsSlaAuG4kZ9V8QlGv88Bbdqdj5aKht9VSg=;
        b=eTZwEystp2YBKdgKXeNHhSfFlIjycIgcIOTtlo0iPIe1pgsldxQamgELwevqEt6TnM
         ciQlFCYFHEvDKOyWO7I0UPk8VRwtguQGDHVU/yKfxB7azswUx7Ek9adRc3WTsXRNGoq2
         QApURrqbZSegOILTdcPPI2YJXxsVaABYhCNQOofHPQklWRxaEcVHq8yo0cHD3k/H5qRq
         1VLadEC2+2IkQjTkl/U2PtBzY7USDmpSnT6cb9pJyxqXPY7kFJb0OQuJcmcDjqdfQxW4
         96SyUkfz9/4uNfrge/479fi2j0tdFjSHiI5g2h1cjVAWw7emB9e5uRxjql5jPqifJlp6
         6fSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735915; x=1788340715;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D9viyxfvYsSlaAuG4kZ9V8QlGv88Bbdqdj5aKht9VSg=;
        b=p42/SZYZk+wrJQyfKLcah8V6iuzmnML8ddVaulpwRAnsYSctyunvV9hAs1mkL45wt7
         Ekj6nXRv7NCO/fvsobQ4qQAZAeEJ1xKk90BCX6AtFYMKGfIh9rOzuI3EiI4GqvfxrJNb
         U6XPtP+ryzxiYgCUK/mzdBtE8LB+8LQnc4L3/bHK01qhvT+H2Dk1FH1zEQT1T6LCxB2K
         w5GCB6d2izMrhISqc5h4RJJgfcDvO90y2co4QicCYRAWR+Wj19wIHx2ildluoBNzQPuP
         lNa+iDPPtWabDTPsNDd3UguxJHjlmB4IAi3PMgyEZRmNlyC3Ltum+atJD41IXXTpz3Y8
         Zicw==
X-Forwarded-Encrypted: i=1; AHgh+RoPo369Nj5/+3gEtqiNtW547BfNp0C0ZZuBmVGdXGk2n3qjGHEJjS4oKV3BINwFJCTtQzx4fjnjkA==@kvack.org
X-Gm-Message-State: AFuF++k3KIwAbjVJcBvwJuW4P85kbdRN+1ZSB03x+a4P9uJPfUiVYe6h
	hkVb76+NfHC89drAGCV+10xM82jbb2VcR8u+GCmRbw1kSUk4mCiWiH88pJ4jbzvRLfHtmalBGhu
	ePXnmryLfgTpMbniisf3QbvIZpg==
X-Received: from plmt11.prod.google.com ([2002:a17:903:3d4b:b0:2d0:34d:e973])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:22ca:b0:2d6:fd55:3a9d with SMTP id d9443c01a7336-2d707a55a21mr87392135ad.3.1787735914764;
 Wed, 26 Aug 2026 02:18:34 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:14 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=1963;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=5Zy0wgRHoYXULlg01g6F2vvkEu14R8QvWTtrIAn8XBM=; b=hJwcYJYD3aQhvV9hZ30dJZ8oFevxPiomh64e9F++PWR61XHxRgbkXw3b9UE+Q/itDtGXtMPp4
 zJhf3vH1eeDAA7nHPjekSt0TG32A8zYAxjhuYb571OlL26p5daTs2K6
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-16-0a15d8a799aa@google.com>
Subject: [PATCH v11 16/46] KVM: guest_memfd: Return early if range already has
 requested attributes
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: wgfibdhn6a9bnwicau8s6w3cimxsg9w4
X-Rspamd-Queue-Id: 795AF1C0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1787735916-247027
X-HE-Meta: U2FsdGVkX198ezesvxnEksOldTVY91Nq7tTvudqSX3LxxAfxeERxoNya0Bx/+v/ECFvhliQ+1CfwgYZBFLl9wuUTL/MaMz6M/cV2thcARwVE5XaN4cTsptClTL9E8ps2g4xvUUIWdkHa42wcSXzW9mr88i/vycGbrJ8cS9DLuYvVWtDyr381tlDcQr23jLoSi0pKomMBJ1GO/Cj+Q+nhAVAP/qgOgQgm0DYUOp9ae1sEZkbUimKS7Z+HmdVV8RANeyIZh4tDIj2vKZl+if8aoX65GoZJ+OecZjh17pLySLX5QNV6/FQkm6aUypZJFwLBGEipPcHaKpT43UsFr9fD42MOiAgdqk+ofUGZXf+A+80wMCvN4N+5BAvoTKosNS0/ujHGdxCeb7SVAZWA7A0eJUpHvW1uBw+nezFQoOzqOpPE8O9f6tSp+S/Y8qjMRtA0PMPd1ScpEY5SnvaXaQm6/3kqd4iuOSx70ghi9h48NSPbJ09qoVSm6jz/CN5xiXbPInsg5HQkEARyCdDFJ5i9DWbnWoLJkPbvSvINQrX2iymvr4nYIEGrI/SbLsUzVC9zlUa3AndJdbtvwiZqUqCEbmAjwc+wzj5jHwHLqfsWEfRHI5hkWO/AQzWYvdjAb+uYKYXSanOXjwD5GsJbLY+iyJX5E4fyEQkgUa2+vErHDp3rZuhAg1KsG3ZJOGw3lUggvSa7U47vIA6rE60PYUqTvo7stTy+OQ7mq9BehJ84nYmhsgBPgOPtt9DlIZd8J5eraYNaQ3gtKlztSMf9zTHmorIrfGFe+X2/K19UMLTB9KPB3gomvTmQxLtkk7quib7OWmzPJWpju91kxxKEOFV9lpHdX71MyFWrIjRH6Vuc9JHBNc9Brz5lk7uKrxptZJUS6FdvtSUeoTPVT6BzzGHJAEy7FxdAvCsEU9nt0J6HEqW9ywVmoGSohnr9Wq+9t9APjGiv7gy91DVHM+k8BwC
 2cQ2yI5c
 nxpDqI9LQHPHa7FXIGmqhI2Mo57ela2wjmie6GAD/+oDX5uVnuMneFfL7dQR9HCzq5zb8qh9VOQlLXM2koFaAxzqnwUUSgKJavpqJ/Mb0PuTaec4Pq9QBrmQHgCiDlNlOMTtUlrCroM+rcRg/W84M2bKBGM6vC3FP24qmHNQQRm7q6k/AsuXBDN92TYzFq/MqQonXrlx4gOR7u3S4o1zu3kDdmqiG+iVPGq+kX3Dtb+SVhjt3QnxQgzWrxcAOlH//ehMbJAZ0avOu+fY1f2wVMRAYEywSKCwZMOblzX7MOiJLNMvh7WxuoZFOKna3INbjtucACnU42rcacprEM2mvei1+FbX4xvbyzBu5fL7Vf1GvPNtg1hi3rfeB8vH3E9KYzLFZnA9YfKEztXS7yl8dieCTNgcoOXog2VdyPncbKQNL7FGblZorhB2Ioz93eZ+Qm2DVEyYGu4jnlUttjoYK6n6u7HZtvLyLjSSHXvXc9BJMRvzS8jB2xrklH8sfqwOWkv4WHNFOGGa89bdCKJbGBtAlGQpcuRvY6hUcheCT3LO+1reBRbjnNTSffyteG5Fjz9Cmp5bylryFyJtY2vBbuNInfDDy6CkAzHWCn67V9I/5vtPoNRjoL5G1P+IGwxhujH94ZqT0Sj1duedKhT3dpUEhb1QRU+dDJO/9gm4Ys995jbEr/cPzBv/W8TtlSTTJkA3wNh1Iu8OgOqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide a function to check that a range has given attributes.

Optimize setting memory attributes by returning early if all pages in the
requested range already have the requested attributes.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d1134b23576e4..6dc199be0eb87 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -98,6 +98,24 @@ static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
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
@@ -623,12 +641,15 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
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
2.55.0.887.g758fc8c411-goog


