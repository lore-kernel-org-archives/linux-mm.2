Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79898CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E281D6B00B9; Tue, 26 May 2026 09:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF916B00BC; Tue, 26 May 2026 09:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC82F6B00BD; Tue, 26 May 2026 09:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE0E46B00B9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62A5CC18FA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:22 +0000 (UTC)
X-FDA: 84809592084.15.4FBA06D
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6DEC120017
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="N dbTXC6";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=IGBF0Cz2;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E7L0m3RyuvBx1kNYpnyZCnh1DhseUWlMTVoo0K5ue5I=;
	b=Ntg7SbhYplFF03TSF/AjTNYYAh1dsT8ugyJ7iuY52N19GgCZvE3VyXNOy54lA7Ibnffawp
	SX9tTbOxzTvxzwgqMmacS74Nd3wqcTdpwfvYeZgnijDtuZcqDDU37pTlw4aPOOOxrEKPjX
	kHIr8CKUVINgLYnyN/27Gl6UnkxAamQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="N dbTXC6";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=IGBF0Cz2;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800720; a=rsa-sha256;
	cv=none;
	b=brBW6ImSZn/ZV+1fedS8ccdIfpLQ83QqJqa2Oj5PYzR7ELOIgu1Ycz0k4Qv/90+pk3my+E
	PsM04kjQNVNfJD95Ze9eMYZ50nrles64aEtrdnLUe2oYF2KY7+0HiCYqw3SfxqLf3hmz++
	TxYEhJoIy72MhhsOm7zdNF63re53iFY=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 1B37E7A0084;
	Tue, 26 May 2026 09:05:19 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Tue, 26 May 2026 09:05:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779800718; x=
	1779887118; bh=E7L0m3RyuvBx1kNYpnyZCnh1DhseUWlMTVoo0K5ue5I=; b=N
	dbTXC6nfKnkuwTtmDny+2aqIfJfyc1pBOZW+8mXnJyJFIEx+jT73avZVDg/Jdvjw
	Nzv0eaYnrGmJoaCuXRXodkKmc8sK4BAknIxuTjQ52wqoDGzcFYg+Ha5WVQU6B0hK
	rbjOB49DcM5AXfYsIoNMqTJWHx+4EOd6goiLvaSou0h7pn3VDDyzOHlInzHUIjZI
	/+RNwRPiMw2v4NO05bqJRe7dH6zRyPI1ApCqipYeUWHgpltb1WLwcC6MoH+hp6x+
	fjf3GmwRmT1FYvAr08Xppk0iWSgXdFzF9jJTzvbGTKiTsOTW5+jdlMmZtCwXc9jb
	M1z6MHUXBOf129pYYVm9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779800718; x=1779887118; bh=E
	7L0m3RyuvBx1kNYpnyZCnh1DhseUWlMTVoo0K5ue5I=; b=IGBF0Cz2M9jn/2BO1
	XqK9E7mBCfZ+0kW/I5mbgVnQ3I/ZSgJ1JA9UWnFdlkX0WAKHtEFH0bH56UQ+mynW
	5ki0M36q2ccwgGP3XTCdjTJhlyPmamMRg8v5lv4UZnxYmBDNinnd4HTHKAwYPR/K
	3o6I0AjjhRjolYHVK0IAMYcpUTrSyqbWT57Wa+oqNiMFNb0o/GJYHa5V4xsSZ/8u
	yoelRdT6Bfx/CMs5cTRDsWD8v5scZ+xazieiEp7R2yyv4p1Zl8kSr3J12JKbqkap
	12f65rOvP5garDUHPksiR0Fg75ChENNaiX+TMqd9+BsvP17+PxsUA527yL6LRl9A
	tH7YQ==
X-ME-Sender: <xms:jpoVajmJ6WfrbsSPGTVkEfrekOjzMs8zWXbpbWq639ZzOL8HiMj6cQ>
    <xme:jpoVan5a9eUB6O8v9m3GLafW_NDDs1LTXe1HLng_jFNy7Zk_TuZGvaWkINExq3vDP
    DGWUdYumCw5GpXqnvpJawBcKsQXLCawD6YluV1OJDhLauBRnmT1lA>
X-ME-Received: <xmr:jpoVasmQdD8CIIlXVC6KWxrECud1Y7qt1SFMnXGGYVE9wBSKkgpulwbJgGhw-Q>
X-ME-Proxy-Cause: dmFkZTGhhOzazjqDbg84kXmGQIriAJ7A5ZgfZ0KyuPxd944l9VDoz0auYhNa1nywHIJo+A
    1950kHkKTkQx9lnfSbZcx/S8Mcmt8P0l8Wb8fN0f+wGCwnBkoWy9vl20eCC3tZZX+sH7av
    Dlxe1oS29Zt+/zoZFzy+yh5aDbHDzc3iUaHQ8s1Xon6Q6ulUL8z0cPYFRnxsd9cUuaOOeC
    grd5OyNgyo2h51fT3APjemmY7PM1ZW9p43vVXIU5xFLcMabfv/O6RwCJbL3XPnw5Oz6kjj
    h/H6ZW2FJischjgbFlb1Y+t4mjYQn8Uqjf0DstcwPvag6qa0D5BtHhYNV9zEgkVoBIpvsV
    HjeUxvJUyBNj4Et00jMB7yxNstb+ga+iDaignJA2Z1TUx07nEuujPXNVC1yKIQAZC/SRzt
    KO5DpEJq+zywyr4tZxV7LPwshOrBc4oFzAodKrcv+DCEH47AMqMlDsNbdlfSfkf4eUkFiA
    6FrzrMB9pHbLNpLe7gvkO33hNIIfH5mGXcbOUp8UxYISR022hjAtnUUAcDxY697CtAxQpP
    zVqAPTUv6uxCKk4KV2zALF7uGWHWgp8gpR2UBm+3CtgTzS5njazyXneppcKKltY4vTsOgH
    bM2isd0gIi4bl9y8nut0ap6qUmCIjBrJ5uh6XU6vK+q1gGHoKXBVlBAI4d+w
X-ME-Proxy: <xmx:jpoVapSB3NiLJAt2oBY_qVX6PeATrFh8ryxFpUGzBAGC8q-RLv9mnQ>
    <xmx:jpoVaqnfDl3OkB8GHiY4njTmrqhqpBg9k9wlUxREioGuLZDzM7yPPg>
    <xmx:jpoVaqOpVyT8PispWbGQbpRrC7IAGA4whXvqq7W6Gedbn55oLSAMEg>
    <xmx:jpoVaq0ExCIZGsrjGeGe4IOoij7eUukPqrEf9m-HIIND7l0QFYp6bg>
    <xmx:jpoVarbEJal-RJM_emCreopxr2MC6yXgAvxyIpdvxoEPhTt6JhxAGLql>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:18 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	stable@vger.kernel.org,
	Sashiko AI review <sashiko-bot@kernel.org>
Subject: [PATCH v5 01/18] fs/proc/task_mmu: fix make_uffd_wp_huge_pte() prot-update race
Date: Tue, 26 May 2026 14:04:49 +0100
Message-ID: <20260526130509.2748441-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6DEC120017
X-Stat-Signature: 9g4aa1yy5mds8mbp9jgwttcgdam9gyrc
X-HE-Tag: 1779800720-356060
X-HE-Meta: U2FsdGVkX1+K4GJTimLIWKOMaftuGbYU2hIm4mAq8Xp6z+dpUWcNsp/JISF9dh2hXQuYpv/EqKox8lipOyjQogmVCWi8m7VeaMu02rKtF6e6dzP4Ah+rp+6nn+l/7WkWKmoaOeEP0yv3aezbSNBJTfYsN92+gIgIW5K65KD8kNQxJMoKQi4zHWagGUQZlTuacO7RD7jSiA5/nHTSCqxkCm4IHuQ3XfYOUAFcvOr5WW4GWqofSqUnDlrR2dOglSTaCxo9QFio/qmhRnqjK5z+Xodbv/6ebXrkAGk4cHL89v5SxLe7eZPW9dQR5Julo6XL21nnhy8CW39QNM3BX/PQ/VIoueplznyHi+d3yt5PUnK5PePkZWCL7SCrgQ4JUi79VO+Flzk9iLiQ/+rsaIefWE2GUMFczm25q4B0z4GouQNIEeLpGm4rmIQ3PbJ5jOzHb6CE8Bwd1piFJM4175ovu0CKPS8IWBSbCwy4yWEFY5g4URsTQHxsiXAPlL05DJ8+ixN6Vkp1GRqfJdXreSp5+vIwaO1QCkmZNjuW3TUnDCK/5fXmb3inaNSC4CCneEEWITXlXPC61dpQiMqjzfdBYyCnFezkWDKUf3JiB0pIcexxmmepoKrWVUiWG7GFF7htJO9V5zyEpsr1aMf+jCFVEUu3WLQ0M8e4gYnrwJOZ2cvFyPOtgyThGILZoXgCprrDsv6U8epz+v3SktaENfmtr+nC+AVTEzLzinHz4dgvkH0cIoiIFGx3wt9PuKWQ2RxvFWs6jvzwBTuaQ8W8dZ5IEhKjE9+ZiqQOpYHV/k80U3Ow5ci7WIw/O+9M8CtNQGbl1GerAOiWzF4UF6XUblCpwDwtM7acjIsW6qBeWrKKIGH4AhxA0Sy1uQw/QLRdX0eVTSU8pG5MIu770No/WoBHFzED/wJ+X0vj89EoRK7AOIqn2vAva/ZJ+SBpiKGtUa94wTnhvpxhqErvsSVAmNI
 otGV4fyg
 D6N+dhaVQL0VfAVcECK4Zy7wKKIqO0U9fYuHaxITvH2OCfI+WmdJZfYOfawAxSgvWVTiKv1N1H/DJk8qWppcjYbKKWbOswQP9IlbGjKDlTp9D+nl1AypBSz2hzxo/CUKT5KqcdQRWDCf15f6KH8V6O5QZzLZedeTfq+IU3UOmSwKCZ79AgwdCFsZURi7Annwx4lXHsHO1hKnEtoSV1+twZs4ABGd8oIol0Steh795z/fi+U1AMHtnXvpRualXdI2rEya9Xid0yaJ5bHFi4F6E0nktzb8MTFHHyNRQLf2f8gqsyJfM9laL9JZOkSSDAlWUl3N6PPjVH+KOji/7INV0Zk0upb45D/U3jw9IPdHPNsinXkOua2xdmVpoMUUZiHafGDpjNX12pf32x9YG6PB7LNetrT5C3Z+yIk3cFGqGYt7I5RJuYPCHjs7aKRUX11TOEK00JotQrZmc23rUrf0Hx8VE13Xtew+MJ9/+uTLOSkc7GhUGCqM8tlt3rBjGEW/91Bh/cgo0Y8iAvhNojmsKPA1iN0/YQmXl7t5uC08P8ipmhwf3f5MR6ZW3ZP3JGT9Sh1gk+YOMkYXYiSoSfRp80CwaGrwgnmVt49+gVrzTGZhBrW4UBEilLZ4KpdGmbiQc0dJNMIhPIC8X71oafXwI97KHf5k2bsCfsKjWTk4eztFjSPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

make_uffd_wp_huge_pte() arms the UFFD_WP bit on a present HugeTLB PTE by
calling huge_ptep_modify_prot_commit() with a ptent snapshot that was
fetched without the corresponding huge_ptep_modify_prot_start(). The
start helper is what atomically clears the entry so the kernel-owned
snapshot stays consistent until the commit; without it, the hardware
may set Dirty or Accessed in the live PTE between the original read
and the commit, and huge_ptep_modify_prot_commit() (whose generic
implementation just calls set_huge_pte_at()) then writes the stale
snapshot back over the live hardware bits, losing the update.

The non-hugetlb sibling make_uffd_wp_pte() does this correctly via
ptep_modify_prot_start() / ptep_modify_prot_commit(). Mirror that
pattern for the present-PTE branch. The migration case stays as-is --
migration entries are non-present, so there's no hardware update to
race against.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Cc: stable@vger.kernel.org
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 fs/proc/task_mmu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1e3a15bf46f4..e21a38ac745b 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2610,12 +2610,16 @@ static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
 	if (softleaf_is_hwpoison(entry) || softleaf_is_marker(entry))
 		return;
 
-	if (softleaf_is_migration(entry))
+	if (softleaf_is_migration(entry)) {
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
 				pte_swp_mkuffd_wp(ptent), psize);
-	else
-		huge_ptep_modify_prot_commit(vma, addr, ptep, ptent,
-					     huge_pte_mkuffd_wp(ptent));
+	} else {
+		pte_t old_pte, new_pte;
+
+		old_pte = huge_ptep_modify_prot_start(vma, addr, ptep);
+		new_pte = huge_pte_mkuffd_wp(old_pte);
+		huge_ptep_modify_prot_commit(vma, addr, ptep, old_pte, new_pte);
+	}
 }
 #endif /* CONFIG_HUGETLB_PAGE */
 
-- 
2.54.0


