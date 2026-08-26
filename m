Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A88C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3076B00A3; Wed, 26 Aug 2026 05:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88ADD6B00A4; Wed, 26 Aug 2026 05:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A06D6B00A5; Wed, 26 Aug 2026 05:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4595A6B00A3
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C235DC02E7
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:29 +0000 (UTC)
X-FDA: 85142869938.15.A4EAD1C
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf10.hostedemail.com (Postfix) with ESMTP id 04669C0007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p8r4dBEJ;
	spf=pass (imf10.hostedemail.com: domain of 3Yq-OagsKCFcz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3Yq-OagsKCFcz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTE6Asm+7RXlDcDxfjIUoFgKCyFEbiLPZQMuOphEUv0=;
	b=A8FMYjeLg8uAqbWoPg13JU5Yp0m+6uyGbiZAibkAfu3//IYSvvlfFEVUnCeHs07EJ1bp9q
	fdi42pg3I1KLSPX+sDYzh67UVHpUVq6VUH/87efEZB7esIrfzY8yFdY782izUoaGnh0dOp
	eqAVtJIXLmAPAnkndviU5HkcVa2z8qw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735908;
	b=jqMIzUMIhm4fQI1aSQLUOk7J3oqY7OFangHEkm3SM1ewEiYGwMFFrzl1yRjIGD3u8eZ6sr
	U2nc2cFhIXRFONQPwR7oZP6yMqaWBd2GAZyLs3jKr/BOcdbQdVC1mVrEjXm6/GUcCic7fK
	1e1JRDWt5sTM8D1AaYhkA43dl1l1228=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p8r4dBEJ;
	spf=pass (imf10.hostedemail.com: domain of 3Yq-OagsKCFcz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3Yq-OagsKCFcz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d001671a54so15927815ad.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735907; x=1788340707; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oTE6Asm+7RXlDcDxfjIUoFgKCyFEbiLPZQMuOphEUv0=;
        b=p8r4dBEJYxlmcCf600TpQ1wBLdFBnkT8FmyzoaU2w57Cf/FYnK/InBIcDwMk3ERDCo
         BuFcf2ccPntmajUqgwwj4JYpo60x5rz4gQOTkpNMGkWFNjvj1ml90x6ZZKPLWcq02F7O
         S9YyKaM2uxqK6eHvMQrPxgUmtKay+Uka66/jHJGtacIxE1xykHZ4PGQLRPaZiRBXvGlY
         eReGHKgYXgZcOW5OpqlRAp9KA80jwvvARG/TmZmF0GYD1zK27cd/kNlygGErvW372SIz
         5nCUsNjaAMW5GepoCob9ygnYknQvMqiGegZhQUxToGxKXO1Lma0xErtVJpflDAStGStm
         czxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735907; x=1788340707;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oTE6Asm+7RXlDcDxfjIUoFgKCyFEbiLPZQMuOphEUv0=;
        b=h0zCNTc4ZK27zmucFdMo0+ItPlHYWUVntVYGXfMIdpTbQAWl85Si4OkxXcyrFTjs7F
         rU4FWPSbbhEezEpddxc0rAdCE3Fn+H6Du2RR9b9SNv4r+ASHVy7AeXWJ/5dqBzZ5kbaY
         jLbwlI+mkt+/c6QOF+V9+xslyzpWCNNymJfPtML7UmavJUYXLvtnTJLJQSmeZnDhdsuP
         dF3ln1oRsdcM8I4dodlLQ62I+QBh6CjS7Y0ELtoUsUlDOeRi7RnAa8xFwbmyGFL5Ln+0
         zCCThZiEv9MvqcC0QRysDfO6pEFr8ZJxwK0QGC4RrlJoXYX4rIauqLqRxLnfq6XiOhOA
         1Uog==
X-Forwarded-Encrypted: i=1; AHgh+Rr+LzUXmTEFOBgUh2hhAL77fsvx/un9LbqMFdNCFo6+1gM8YRXh9L8uV9PunGWHZ1uGY5TxrdgYRw==@kvack.org
X-Gm-Message-State: AFuF++m3A6OXqIQ0cOkc1HkrCZVQ91Kbva5W+aq296pGU8I/iXfDOcdN
	qG1xdnr/l2WmZOHT9f6xVFzWy/WSqIZDDJl1JrdLQE4GPAKM4bMMNA/db550rRKddsepPa0Evjm
	80W38oqVGuBh1X+sgPN71iqmDfQ==
X-Received: from plcx11.prod.google.com ([2002:a17:903:cb:b0:2d6:e968:e012])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e549:b0:2d6:fec3:bd51 with SMTP id d9443c01a7336-2d707a069c4mr76735725ad.5.1787735906226;
 Wed, 26 Aug 2026 02:18:26 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:09 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=3177;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=YUnwhC+mh4fTP4jvnneQXyA3asq1d/voGqOiDIo7t1o=; b=Wjc/Pos7KfwzIVN8Ns8lzU7jxfHIdmvfrZOOpjQ6O4nJ/C7BmszK2LLtQ7rlqfZLTDl01NH3d
 k6lZKdmqN+mCdTG+AcXcUlLBxQxLmTU7lbl3u9elGj0Dg7z285TAHtw
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-11-0a15d8a799aa@google.com>
Subject: [PATCH v11 11/46] KVM: guest_memfd: Invalidate both SHARED and
 PRIVATE mappings for in-place conversions
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 04669C0007
X-Stat-Signature: gmjs5wkakp5xtzu4mdmmxobrg8wroyqp
X-HE-Tag: 1787735907-50740
X-HE-Meta: U2FsdGVkX1/bAj50hlmd3jfjFEOGwVEl3J4xNQ5o/755VKSV9ql/uoIo4qfIu7QFp8KBpuQJjtpsdoKlyFmEcPvhtoWNjo8dfX6IjfErVBQoqltvdSU7L+apCL7oOosuzJygF1TluL/QByZp5AqbsbFMwDi4ecstfWW1esyw/DtjTDGDfLv018WWgnNFVBY2lvBt7xg2q+/fPDtApVUgXVh76V7e9cSMXFtOVb2fs5BL2QLRUhxwiw2EGlw2h4AqHB+yPd/x02ZQNjrCz/Kq64mgRjqnzDDvuYKHWdsglTHirCPi3Wh6PtM5iejOu+7JjO0Aiytxc+eMhUOMMrd8Se4fnoRlN3reOopLQNMQaIRDMvu+Vvp/o4cxkw/SigyoobEQTp/FIf8ENx9sQFkd7PcZNAhonayprRgc8pBizFWSQslyF5yiMEm1TzX/8MIZm12Y2gSBxC0DJms95poR2+yRTMvhfTlh8Em/yReVOeG9mlxxVn+0aUJZp4NYrzaCWmuVyHwH2g1hOmb7Kfkzlt92YedfdPVl8G+1cj8l+MH+E4qcePRQUGCS00kNG9F1PVAtl1yZx+rXF1sj7BeKgBozgPZ7JziFO9+S0MMYUMysSitgvI4hv5mwJdV7oHSYIP2gix8AyLXhO6DnnfuxuJxJBpCmR6f0gKNQIyv6JH4MshDCZvPhfTj3jawRrHqVWyr0W+97QW1pOwU8d4qz3WcoLE+sWQCppAVW3vn/XnhHJwIq4ZgaLo6UUfett2PYQMMViWSeKD1ngcNN1si6zsqirqCndFUc7gmGxwoddir4BhMafa9TmfMgS7mWlkx2sQy6R5d+Qpz3+f1vqGy5bmihiWM/dY0W+Bw1MsdXUApPG0jfDegJpXqNWBx+V5ENg6za56nMJ981+2HOfX16QvFdjFUpLdY6lS3Ojw9wUHTXYPHrR2u/YMVW2hPIF5+8y4RhXMkdmI1fL5KH/gJ
 ulzl8QoF
 AqZW+rcpnFjcBivFHRExZz/GMAYSjoXSCUIjoPqXNsnB5s8RWTn20QFJtt0H9TTAyVkBY3Duw34InAvOGobE6AEY9477ah6Z/xocVlM6xoHE6iW1e3t1o4njgSuZkDsTYU6U9qmD/Fq3jZh5lydZNxo+lZuca8njWWbVKsvUUf6hJfGuc79l0ibMZWzA/FRGvFPIFMFvoJv+eYJk6VUmoLsNnuOkNv+Stq6mZweDb7fkYL8nzwb3F42uk3qyic5EucyQ2SnN13KoxRQBJjuKXqEmlgBtuMIKFqHiLghssuCdpsKCBa1TPP+dNSPTMBdSrRywY0oDWez0VRwv+U6yuo4vimFjuvMDTAwzOtSFAGqcys0lM2jrAnvgYQmTH+wbjvign7hxzEKny1DI4FJRKnZRD+R+GvKwi5IkG33a+pCwZyHizWL2jSpVhpoZ5G0A5LCWs3wqtOotI5qbHjrm6ahhkrJAY62r/HFP5x9kWLoFz/mVNbgrn+jHqapmro5YTg6myNs1xQ8GsAlCd2nBJaWD5qYYglivIHUe6oLiIkTry6wIMTR7ObqGQF6t4ogiBYhu7QpS3I4xiS4NdRxPI0/qSsXZrifiIM6n3UTZrh6/rRux4+xQMy6BgEWSXWynxxPIq+9MuH2fu9z3XuknOKbAk0EaCf+PKtGf3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

When removing one or more folios from a guest_memfd instance, invalidate
both SHARED and PRIVATE mappings if in-place conversion is enabled, because
stating the obvious, KVM needs to ensure that all mappings to the folio(s)
are dropped.

Opportunistically rename the helper to capture that it returns a filter for
all gfns in anticipation of zapping only the previous mapping types on
conversion.  I.e. when doing in-place conversion to PRIVATE, only SHARED
mappings need to be zapped (ignoring that KVM would ideally not invalidate
ranges whose attributes aren't changing in the first place).

Note, precisely zapping only the possible mapping types when in-place
conversion is disabled is important for functional correctness, not just
for performance.  Specifically, if KVM zaps both when SHARED vs. PRIVATE is
tracked per-VM, then a PUNCH_HOLE operation on a PRIVATE guest_memfd will
incorrectly zap SHARED mappings that have nothing to do with that gmem
instance (because they're mapped via a VMA, not a gmem fd).  And vice versa,
a PUNCH_HOLE on a SHARED gmem (if userspace is using an INIT_SHARED gmem
for the shared branch of a memslot) could invalidate the PRIVATE mappings
of a different gmem instance.  The latter case in particular would be a
functional bug, as spuriously zapping PRIVATE SPTEs is fatal to TDX, as
doing so destroys the contents of the memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5399ae4aae0e7..d4a9877b29ab0 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -139,8 +139,11 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	return folio;
 }
 
-static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
+static enum kvm_gfn_range_filter kvm_gmem_get_all_gfns_filter(struct inode *inode)
 {
+	if (gmem_in_place_conversion)
+		return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
+
 	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
 		return KVM_FILTER_SHARED;
 
@@ -191,11 +194,9 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
 static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
 				      pgoff_t end)
 {
-	enum kvm_gfn_range_filter attr_filter;
+	enum kvm_gfn_range_filter attr_filter = kvm_gmem_get_all_gfns_filter(inode);
 	struct gmem_file *f;
 
-	attr_filter = kvm_gmem_get_invalidate_filter(inode);
-
 	kvm_gmem_for_each_file(f, inode)
 		__kvm_gmem_invalidate_start(f, start, end, attr_filter);
 }
@@ -347,7 +348,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
 	__kvm_gmem_invalidate_start(f, 0, -1ul,
-				    kvm_gmem_get_invalidate_filter(inode));
+				    kvm_gmem_get_all_gfns_filter(inode));
 	__kvm_gmem_invalidate_end(f, 0, -1ul);
 
 	list_del(&f->entry);

-- 
2.55.0.887.g758fc8c411-goog


