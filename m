Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62089C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6E256B00A4; Wed, 26 Aug 2026 05:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D469E6B00A5; Wed, 26 Aug 2026 05:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82B56B00A6; Wed, 26 Aug 2026 05:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B02296B00A4
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F82BC02EE
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:31 +0000 (UTC)
X-FDA: 85142870022.16.4CBF4B4
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf05.hostedemail.com (Postfix) with ESMTP id 695D5100007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q8LXVjxg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3Y6-OagsKCFg02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Y6-OagsKCFg02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXPej6/aazY/Zy0bqnNH6AiLcBSkzXva7x44ZsPvDyg=;
	b=kKhsckM7J6tR4rwITvtGptGfirIPKCWESqD+JNmjgUCB3WpG7O9cy9t3+NuRDRbeS+ugOq
	+WdmZlAswAbw3hhMW2etDYhS3B2BO6cYCRx9XoQequ3yDZ6UTIp0tiOpeSHE/KKLBiOjCK
	N0UuX6BEFBSjavmGZ/SoCnOFS+mz5xw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735909;
	b=D4ekgadishhSiF99safglvC/j0bibOYG7BLUmIB9RcZZCuEoH8v/JsH+sLcA3jhp5OH5n/
	UB0SlWh7H16wXpcIrkTkP/jTaSRLdVenH7gO39Gybnt2Wz5PmNA8LahUmDXm4zVdc41wmn
	wWs83gUwsZ77NzdJ+08nYriVg2krqWs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q8LXVjxg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3Y6-OagsKCFg02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Y6-OagsKCFg02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cfa55c9430so9737435ad.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735908; x=1788340708; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uXPej6/aazY/Zy0bqnNH6AiLcBSkzXva7x44ZsPvDyg=;
        b=Q8LXVjxgeE69XwmRC79ZRW8Arlf9uSGLzaqj0vuS7+v6BoqX7DQ/vQWFxHXFwrFCE6
         Qd2Im1gCuzyDPPnXB4cgym/ImQsEkf6TEoALQv14zvZcS3WZhEtRMpSEo7ebrmVL3WF6
         JUdxcsXxAEiaf5ds2CPliZoB/Psl5v/HV7dZP5kNcApdxc2iDdZhI6YoKMZsLC2JKone
         bToCqrsGwtP+N0SrBvbbQwACLIo+fhcWHigm9c84jH97U8M4xkTZg80ciZi3w29bIwN2
         P0ku5KyfG1baksVoFR0wBa6BNkKntdlbAncfT2sjlvT59XJCyePiZxwm5re6PnyQcK88
         /i7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735908; x=1788340708;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uXPej6/aazY/Zy0bqnNH6AiLcBSkzXva7x44ZsPvDyg=;
        b=ZeB8Y8bzf7qeV4xjCYiCZWJCy45xDdRbAbiQKb6gt/rg/UI+ooKaa0a20/Hkj2Om61
         ewZMCq7i8g1tHKDg1u0a9HtQUwUkKHXFOxXTEK8acbXzHOX6kAWS3toRlgBw6RQNyG3L
         GHsjtE8xlsnoqiAfsMFzpLFvwbXSrz7JWvaKSVJjDH0JLVb2GDnZE9dZEPRAdFEuICdq
         a+RnLuZ0c/Nl6XW9TjGtAb+4SB0q2bpt2mcjwLT5+cpFNH0o1barLCh/46X394mCsj3d
         2XzxabG8eXohwSJc8oLN5CTJWF3uMrFdlvC8Znz7iDC1WJSgIbGar73OpgPhqsmbbIIz
         Xzlw==
X-Forwarded-Encrypted: i=1; AHgh+RoGbV1RMIv/tQiivCXBN0kK/3NbqQFihJnvLMqT5lRK9AMCn56MomN5MOgUyM53c0CLF+/NiRnlsQ==@kvack.org
X-Gm-Message-State: AFuF++nhy0/92L7Xaw4CRK55SweZ4I8f7WaXyol4DOrsTTnqMnvfUFQm
	WiLey/8MbJ3su7JaSHrv083tr7TT5t5L6cA7sODgEjaRILSq3yWGikdsO8OjDAzTMMCQaGkM41p
	d6OTxScRZqpKOvmG9VaUvPXnGbQ==
X-Received: from plblh3.prod.google.com ([2002:a17:903:2903:b0:2d3:1b72:ff0a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1a0f:b0:2ca:2079:91cc with SMTP id d9443c01a7336-2d707a8eb75mr93292455ad.5.1787735907954;
 Wed, 26 Aug 2026 02:18:27 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:10 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=2917;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=d74irKAD/WY1oRS6lvT6VEWWDqrQZv2skOByz9ZePX0=; b=fCUn+TX3iBXyhcxdFfxYrHVsFqPrFalVdBOqXAzPzLfL/WoqEtNajpCcqHmxHZNjEuZgf7onY
 ak56oI3jLtlBkiH5CIOlWLg71rSuHsLBV/sKh/x4ig+QvPQxWgiJpVH
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-12-0a15d8a799aa@google.com>
Subject: [PATCH v11 12/46] KVM: guest_memfd: Pass mapping type filter to
 invalidation helper
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
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 695D5100007
X-Stat-Signature: wfqn83fxybj7cmc715bjz7aus7f97pcc
X-Rspam-User: 
X-HE-Tag: 1787735909-121224
X-HE-Meta: U2FsdGVkX19q7vm9rfj3LMFnfljYGyVw97/sDBbJ4j2tLL8bshdidNRnbiQyYrdZ0a9w8zIzdqOaZJBjbT57PASxHlt/PHpsJLVSVOWtC9sJrjuiUV6dItTWWZmqgfjF0A7Ndvo1BhJlk7X1z1JPC6sY7V57E9gk/wYMc6tTdS7lv1cgmDPYDqE+uweoRsyIKTocTufQ1+KM1MJBUv1DMYxQU8mUFrt0EZdk6QG6NlHCS3OsyERhjv8jRDdondgDRYOWSLZKwL5Xe0xiY9muB016eX19f7q1qVDIReFyN4KnJDQ25UQSz6WxdFPMmu9VgS2klqJ4gENKasO51hoc4GqxXUZ167R7uthaKCIUVQx/4y2BkRoD6FPqvRvEiJoVH0BY3B9OWqIpETREwZSVSvDa9kQvN/2lpd2KvyBf8okZzIOo94rx1jBpSot1bQOsN8rSrwTK4LlIIBXZG3XvfOZrs3bf62E9qv3LZ1x5s+TdLqpO7XUOkiV+xQdPxrvc8pQLMEBNQbsdNB39xr6Us2XrB9/5lSiqb8R9FTlxLBgNfqs/o3uWgZiFsZIEzi6oun0ak0IBnvH7vgnZ04/K31RMZS1Bcec4tjQO2O71eYF4hJW5BCeYh0N5SfiJDF7KHMNsIJEDaGVdKNCDI3qaj/eWu3nU4qaIQiKytA4VQFWavpahSDzUQPzT2CVV0DiFPSAoO05Mv+3ydcttl6CngUAPyV/6eiW7bVf3/3DvgPAfo2zFUsFI6f77XZSArk/uia0B+zOzvszwVqz0xyzIYIuJJ2c1b8OG7oXiIEXzsdTYhIaQX8epWq5Taswchh7CZnL07BMU0/HGtTEXPPwMPVCnuJyYGpDdOaLzwSWveXucT1jIYctAqMMnhui/RyCvsXrQh85JzcGDma/lWR0QaOt+HicbAyKfDYUIxGcb2Y6JaU4j57SWwZUNQd3VgnKsiixnOY7OkgOjP8PNROr
 sFwDbBvM
 IRG2nmOXIfadN/pHEqcK7fFvx/dPFND1Ov1FbmE2qf0V9MILMfk0FPtJtQVJxC2a+wNjkyUJd8pQ05TXGaZTrQqiMk9vwvxrfA0R8UsD7H2X1xia/cobZne4ASPxG+yYUnIvjh2zvz743F4W/hKvrS7DgVNkB3/1GPXrjRQcuDsL6kpICd0u93Tdm7z79y5N/vYwwjiAThez81X78YAlPk2IClot6T6OTWFSxmps1FtaBQJ55d+axTR+hJIAmenGOcPP8RSOs8afpm4axoyU0bvh0Dr0kHf2l0cUG9qlqtvJju7qPA+qbb485d+TKcybIrWxAQ65Hu5juDw/AE7X2YH06eT20Y4AwFmni8kEE6QiE6YvIAD9WuPMBSaCijpQgtFAbKjOgzT4Z4sIOAmIiCW2R1WIaRXJDCeJm/yujto2shn6Iy5VRAgKCZ5cOylBlbLJ4y7oSH5tGoOHcvP+4y67e7GBuxaNgfZfRAg/5mcnCmHKHl2x52zFXc7k9s3KLjh7zx6sS0ddJw3DsvqnuEuURV3CdKpDl960Ql/p8zP067rvtT71ldPkVxfvHxjssDvpfi5u3VUOFPA2RuNyErlhQWcKWjjECmvEaJqFnptHsdigFdVsA/29J7okbyBtI+hdgW6RBTs+9QIqwhjwOZzk9+7yivYbZdd+MiOQ+VazPByrmFVMzXAm1xjqTv0FiJXuF3XpM+vV1Qp6SP2G62+DQQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Accept the mapping type filter as a parameter in the invalidation start
helper instead of querying it internally. This allows callers to specify
which mappings (shared, private, or both) should be invalidated.

In the next patch, the conversion process will use this new parameter to
invalidate mappings only when they're different from the target state of
the conversion, i.e. invalidate only shared mappings on a shared to private
conversion and not both.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d4a9877b29ab0..ab29e7f555787 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -192,13 +192,13 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
 }
 
 static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
-				      pgoff_t end)
+				      pgoff_t end,
+				      enum kvm_gfn_range_filter filter)
 {
-	enum kvm_gfn_range_filter attr_filter = kvm_gmem_get_all_gfns_filter(inode);
 	struct gmem_file *f;
 
 	kvm_gmem_for_each_file(f, inode)
-		__kvm_gmem_invalidate_start(f, start, end, attr_filter);
+		__kvm_gmem_invalidate_start(f, start, end, filter);
 }
 
 static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
@@ -224,6 +224,7 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
+	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
 	pgoff_t start = offset >> PAGE_SHIFT;
 	pgoff_t end = (offset + len) >> PAGE_SHIFT;
 
@@ -233,7 +234,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
 
-	kvm_gmem_invalidate_start(inode, start, end);
+	kvm_gmem_invalidate_start(inode, start, end, filter);
 
 	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 
@@ -522,6 +523,8 @@ static int kvm_gmem_migrate_folio(struct address_space *mapping,
 
 static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *folio)
 {
+	struct inode *inode = mapping->host;
+	enum kvm_gfn_range_filter filter;
 	pgoff_t start, end;
 
 	filemap_invalidate_lock_shared(mapping);
@@ -529,7 +532,8 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	start = folio->index;
 	end = start + folio_nr_pages(folio);
 
-	kvm_gmem_invalidate_start(mapping->host, start, end);
+	filter = kvm_gmem_get_all_gfns_filter(inode);
+	kvm_gmem_invalidate_start(inode, start, end, filter);
 
 	/*
 	 * Do not truncate the range, what action is taken in response to the

-- 
2.55.0.887.g758fc8c411-goog


