Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC7EC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 01:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810336B008C; Wed, 19 Aug 2026 21:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1586B0092; Wed, 19 Aug 2026 21:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0B46B0095; Wed, 19 Aug 2026 21:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5B36B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:32:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABE28C0644
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:32:37 +0000 (UTC)
X-FDA: 85119923154.25.F5C1F35
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf25.hostedemail.com (Postfix) with ESMTP id ED5CEA0003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:32:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="etIJ2x/U";
	spf=pass (imf25.hostedemail.com: domain of 3MlmGagYKCFkJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3MlmGagYKCFkJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787189555;
	b=wwZF6Xwsv3TmR8abX0bZpkLpxaqmgeiWaW+JdUT2gF+D3/hEPRHIRWinASTL+iECs6CfCc
	Ott61gVgKTHe+zbC1UqvUwYEB5jUv0EOxZ/kV49DUa69stpll/5xQYr7Mv9u3gpOCWcP5P
	cPQ6r+DitjbloA0UWxUg7jXjq6zLHck=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="etIJ2x/U";
	spf=pass (imf25.hostedemail.com: domain of 3MlmGagYKCFkJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3MlmGagYKCFkJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787189555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQeRam/aXC557IkHfkSAK7ZCCBwHdULqaqUlyhncFbY=;
	b=zxBhctH9Y0CH/zs0bML07GxCE7b5CsAwHRO84wCopAaMhjiO14tDwxuJxm9ulhYMCp+Zpr
	XfaWGL2kWD2Ve9uh8TX12Z+63l2eYPMQfZlOlv62FiqypHD+6bwnBwZDDKoww9v8LPhvWZ
	HBA8tZEXDOaCk80toGtv12zVltYMEPw=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d5d00fd19bso26704005ad.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 18:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787189555; x=1787794355; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PQeRam/aXC557IkHfkSAK7ZCCBwHdULqaqUlyhncFbY=;
        b=etIJ2x/U8FEkS4SRGtG91mSqgwSr1GxH9SQmuKFrM1vQncxk86+UFl9qnzaFgf5Eez
         Oo5LRN805/WCiGd3DyWFVOwLxjILwCo1R343YNtK7hCxD7fDTwlaNxl4m4Aj8z+iIVuN
         lkopbylmV2UhKR5YILv2Qsx8HOqDWbHzhM3pbe+X7tKhEpanGwopB34lSDA0SXHTMADs
         5ujfcrM3w5e78MefptfSXG4pJWHp80c7ce3qZBEiT1m0VI/rbsGyylSZ365vzRH11IGO
         QIDcHSNpBN8zQUOxTlu68SPollgIJJPtAl4p8FqG/dS3Lr55O/ZBUOyRY7xqL0fW54fe
         9HNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787189555; x=1787794355;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PQeRam/aXC557IkHfkSAK7ZCCBwHdULqaqUlyhncFbY=;
        b=H9f5CTnN5Tj1N/gdW4a0BhCu1wsAw9oZsrPMrAn2IgMbS8NATWCraSkor/hrULdu6M
         VHMnO3rmI5wo7lIIM/HW2EVacnNkqrzx4MglRNOfD3iyhWGmf0ggB0cZTy8QShptegZf
         bYyjNbBcQLHpRXWrE/8orLsGv0TSukqAAwichpUXi76mivwengvS/J3d3qPAcLt0x+5d
         G5t8NQd7dx5g4N+D6gYBvs/zIPspUzQHR2GsYtVChTFlbQ0h3O35F0g8LUogwi+4gqj+
         xrepwYFaGd7xwkL5BX+43Tq1//BPmVkaGjh9/yS4SXh3ut/sq8fiH+pHd4xbTuTVrsml
         YFIw==
X-Forwarded-Encrypted: i=1; AHgh+RrStAphEfMn+ugG504faKy9lV2j8+A6w+sRNas5CJxWm9RBGEhfV8FrKFeLVGpFV8ISjTNFMg9V+Q==@kvack.org
X-Gm-Message-State: AFuF++nod2FfHZgsnWJKee+JNTSY4QEXjye3HRYhvZBDGkz8yYRjS44c
	HlF1/H9RbeCu1sLFDFW+nTWqRGFG7BmAg3453Xz7lb7L6uiOFalU2Vw9Us+heVvit7Ml1x3zF6v
	SzvCFUw==
X-Received: from plbi9.prod.google.com ([2002:a17:903:20c9:b0:2d5:ca58:37e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:40c9:b0:2c9:b396:1a55
 with SMTP id d9443c01a7336-2d60197c4c5mr178024025ad.12.1787189554412; Wed, 19
 Aug 2026 18:32:34 -0700 (PDT)
Date: Wed, 19 Aug 2026 18:32:33 -0700
In-Reply-To: <CAEvNRgGOyQHnF_b8dk8E0d7_=CcwXtYUdU3ko7Qbep+_O7UC0Q@mail.gmail.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
 <13ca60c6-e154-4397-8092-09f861e90fe0@kernel.org> <cbf5f7ca-a960-4fb8-a760-2d2794eb6864@arm.com>
 <CAEvNRgGOyQHnF_b8dk8E0d7_=CcwXtYUdU3ko7Qbep+_O7UC0Q@mail.gmail.com>
Message-ID: <aoZZMQ3Uc8yQWPNA@google.com>
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: ED5CEA0003
X-Rspam-User: 
X-Stat-Signature: mbnfijtoje9gffdh6umu9495kpew636y
X-Rspamd-Server: rspam06
X-HE-Tag: 1787189555-889372
X-HE-Meta: U2FsdGVkX1/1eymLrHkV1I5Qb5FvQo+oQEr3jPUE3OlyV3HzlgiGFRTchdPxDMZ2orNVshZThoCWlsimIOX8hSPxbuWrFEjTV4Rwp/pnU+GkHlNZsaVWIyG3Ff9rq7wcTjN+43sBjL66xdzSeco57fjR73ZXCSA/OrsRcdPMjDc7BfaHE8GmBmKz2P1L8pq3ftNYUFUpaFlxrMlQ5pzDhx7dAZmWK8LDmecqR8UFMeIa8Z74l57ZQVU6XsOUDXqjNpQByH48SVi+Ffa6P/YVX3OnG1BHX8t3RZp0Bhk4p0BYLnQWlL2JXw4p5aq/qGeBC7XGEBwveGbWL8Pat/KCbj0lepRtWRJEtIxdmPOyC/KrOpsRpbBx1USmTd+YLGjQnrmcD1fbHBjV5uRmV6jecIgEN+627+xXwtDfuCcRVWlKWDSonxzZ7C4t+cVbF27ORz+8MoHq0+Vh1GU6lwfTVd73ylIE9E+gQ3/PiARbkjhcjTtsZo9cuFZ4B7nNYdO7b3BXXcESkRGwHPsb+DVcPXmnR9zFxU6wBcRFIUZ5Xx9GzhRRjXkKzQi3YNkbj1hNebYhX7+qj24ZekQvHmvyYZe6x6fQv12+N/DV919iXqnCcN79s3l0wcwWlQDf2UlSL9YhTP9ae1HCpqKU2iwlFrL2jwZngIPXNmaE016nLjHaUf7Do057NmwbUTnRTxZer6+SaekyJxg9JlsMpGKS4EOkZqNsAFiBJ0vzofG8VNvhdWRoqAQENR2Hbr78fPOfeR2jiXx/6cbBsPo3NHZmH4e3EBDIwTdlg18xj6w2kdOO8kAWnphbOt5HXPILKRJu2rGz7IwC81PWBi4LYXrtViSReDuT4zRxqI3PXrhTFJOFTktvKup8OQuezsS12VzwplMxM8cvMOj15lmNqdG74hBpXsh0GSpKicPjALk0rQdMoPFwfQofnOSBKEuy875qh/SggxEDyUDjWgkzaBR
 D1CSufEo
 m2HXJY/7Vxawj7gF0uZcGZ/6+seIEXwY8KpcWT/LUEjfMrTdKbqwpI1gbN3dyc51cQ3hxez1OORrla32g+Ym0OLRMSmkLRmfKMdQTA27x89XeENuif1b7Ldnbks82QproqfMTKIIeBgOOjtjC03s+WajdTiiVDPPVDP5KHEhgFJfuFpL1gRh0O+zUiTgwWFxfFRYTSuzrRkgq3bw+5YLKyfp0nl3nQqNbo1tcmkUfC3kFJTV8MQJT9cXHzotEm6jCGiufJF+0Z6maE5rCqVfglvKGw0j7AscssHNxvz/IxHSqdKK+0wUKlK4hHh2efX8mi99cocNz7bJ1uvNQbi7r/71wwpVyrXoLjtU6H21qEwwgTOKAv15A7Oxg8LmBAtce7v1nun5EuznhZNrPJGhdzMd+CNkIRZyMxc01BCVUFKmuSq+pjvTJI5LmyqPXdrOYZ2Nv61+7t39ei/0XHtSKJOYkOzcvkKIScSv5Cz7DVQC0nc0rHkmScZYksY6Mn8W5fVQ6ERogq+AXHvCR0p2HR+Aby6kIRBrZWMEKFTIs+wvXBt33V4Kr8lGD5rQvEwWD/VorOWbh+pdUoVSja4DS+prVXaKPsFlJvert2KHrk0vWBQ7Fw9tp5uyONQFzWWWd0+l17hM9fT19ek4+RjyzDNp/DGkUxFFBhHMD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026, Ackerley Tng wrote:
> Sean, do you know if looking up attributes in gmem to feed the KVM MMU
> the smallest set of pages to zap will improve performance significantly?
> Or if there's any other reason to do this lookup (more complexity in
> gmem)?

While working through this with Ackerley, I realized this patch is buggy.  When
in-place conversion is NOT supported, then as evidenced by the current code,
invalidations are guaranteed to only affect one of SHARED vs. PRIVATE.  And if
we change that to zap both, we risk overzapping.  I.e. it's not just the cost of
the extra MMU walk, it could also be a functional bug.

Specifically, if KVM zaps both when SHARED vs. PRIVATE is tracked per-VM, then a
PUNCH_HOLE operation on a PRIVATE guest_memfd will incorrectly zap SHARED mappings
that have nothing to do with that gmem instance (because they're mapped via a VMA,
not a gmem fd).  And vice versa, a PUNCH_HOLE on a SHARED gmem (if userspace is
using an INIT_SHARED gmem for the shared branch of a memslot) could invalidate the
PRIVATE mappings (of a different gmem instance).

That latter case in particular would be a functional bug, as spuriously zapping
PRIVATE SPTEs is fatal to TDX (destroys the memory contents).

So, for the initial change, we want this (full patch below):

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 75979c885e03..8ff2ec148614 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -138,6 +138,9 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 
 static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
 {
+	if (gmem_in_place_conversion)
+		return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
+
 	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
 		return KVM_FILTER_SHARED;
 

And then in the main in-place conversion patch, have the conversion flow to only
zap tap the "previous" types (with prep work as needed).  Ideally, that would be
done *after* the main conversion patch, i.e. as an optimization, so that we get a
nice bisection point if it's somehow buggy.  However, Ackerley pointed out that the
conversion flow invalidates the entire range if the attributes of any gfn within
the range is changing.  Addressing that would be rather annoying, e.g. there would
need to be multiple invalidation ranges to deal with interpolated conversions,
so going straight to a "zap only the previous" is probably the least awful option.

---
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 19 Aug 2026 18:06:38 -0700
Subject: [PATCH] KVM: guest_memfd: Invalidate both SHARED and PRIVATE mappings
 for in-place conversions

When removing one or more folios from a guest_memfd instance, invalidate
both SHARED and PRIVATE mappings if in-place conversion is enabled, because
stating the obvious, KVM needs to ensure that all mappings to the folio(s)
are dropped.

Opportunistically rename the helper to capture that it returns the a filter
for all gfns in anticipation of zapping only the previous mapping types on
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
---
 virt/kvm/guest_memfd.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 75979c885e03..7ae05ce3cd14 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -136,8 +136,11 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
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
 
@@ -188,11 +191,9 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
 static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
 				      pgoff_t end)
 {
-	enum kvm_gfn_range_filter attr_filter;
+	enum kvm_gfn_range_filter attr_filter  = kvm_gmem_get_all_gfns_filter(inode);
 	struct gmem_file *f;
 
-	attr_filter = kvm_gmem_get_invalidate_filter(inode);
-
 	kvm_gmem_for_each_file(f, inode)
 		__kvm_gmem_invalidate_start(f, start, end, attr_filter);
 }
@@ -344,7 +345,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
 	__kvm_gmem_invalidate_start(f, 0, -1ul,
-				    kvm_gmem_get_invalidate_filter(inode));
+				    kvm_gmem_get_all_gfns_filter(inode));
 	__kvm_gmem_invalidate_end(f, 0, -1ul);
 
 	list_del(&f->entry);

base-commit: 620f8362aaec3848ee8f465949a0701175fe0896
--

