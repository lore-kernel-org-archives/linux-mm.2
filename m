Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3122606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 09:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mIVZebeJ
Received: by kanga.kvack.org (Postfix)
	id CDCF86B0201; Wed, 21 Oct 2026 05:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8DCE6B0202; Wed, 21 Oct 2026 05:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCAC26B0205; Wed, 21 Oct 2026 05:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9ABDA6B0201
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:33:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2AF631A04C2
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:33:11 +0000 (UTC)
X-FDA: 85346119782.17.5A14FFA
Received: from mta0.migadu.com (out-154.mta0.migadu.com [91.218.175.154])
	by imf18.hostedemail.com (Postfix) with ESMTP id B009D1C000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:33:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mIVZebeJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.154 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792575189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jr7HnwUIiu7FdL/RBzGWRsmL/DGvW3qYiYRJage31n4=;
	b=R6d5e62fFyvgx0mkfzYNGk+mlQ2Todc5gVGjp8owbHnFQEqc4Plx+3Jj+Akvjtbt0yJyKx
	mPolpkUv3Fa5F1BAVqmPc9M6N0nLab/RcxnvsL6ycL8GxSp7nxOiEsPuOWEiEiMu5l7p4o
	IENMVDOwUKaN8NFEOr7yNrVSZnSbvWk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mIVZebeJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.154 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792575189;
	b=yqD2PpPuKbivQPKc6NXlsG41w5O+qAWD3iHDQlyOwFks8DRWKOHrhxZJftVUQJ2A7o67GN
	u+DURUAeeHtaK2WDmVC6BbB6jNK8j5J454QAUxCliAZTezndubsHrtXlDdLfQj8qr1LKtI
	4p/73r6WOEx7dnM+F/cuzy6KWOP/Gl8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dR+VfLDHueVtZzyRT3cCSn71Vr7MLkcSNP5OUCJWM8A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792575187; v=1; x=1793179987;
 b=mIVZebeJDheysgRfBLQ5IYp9YqVkwZieb9MhPYSmKwSMHOcH/yx93Iq8oES6Xap5rYT+13qG
 yGIsquauM1c7o+8BMiBIrGKBG0B44BN0ij0dcuL9yskE7+Boo8Wr6HcV4caGA6hDiut3Khw8eVe
 B71aq7l/zBLTa9fvZH75Q6vE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 0674a95a7bee71c4;
	Wed, 21 Oct 2026 09:33:06 +0000
X-Mizu-Trace-ID: 0674a95a7bee71c4
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 01/20] hugetlb: Don't restore vmemmap of non-HVOed
 folios on bulk restore error
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261003002123.505555-2-jthoughton@google.com>
Date: Wed, 21 Oct 2026 17:32:49 +0800
Cc: Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <491B482A-8177-447A-8CDB-AF83C13A5DEE@linux.dev>
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-2-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: B009D1C000A
X-Stat-Signature: ky4rjx3x9o8cdj3ujot1ih5xfik7p9xg
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792575188-727139
X-HE-Meta: U2FsdGVkX19W7U0lCziRxCY5mQnVPr68zAH+E3farzixGzfWpPxHO8veO8s3/EOe+0J4VdOxR3WQoDcBdrEBWxAnA4rUh5f/HvQHhfvFCrGiKzUctcLjy9cO/AYz3drcS2cU8ZTvQRmvAapHWd8gXnlFw+vDCZSZUtTjcS7RljZtiRyFif0AztxG1OJv973W+oWgr5N00yU/2zK4WfIKbrtJ/zU6JIv1NDcl5n7WtWv1iQjddx71UaREZLfvBLcX7aF8+iDiYMZk8XbiQ44ur0Lx89dB+Gqdlwao0i4Db8fzHF9sa53HFDeihsIDp+bjPuhgqnr/U6Gi6uh5uJFExlKDBzB8ELCbcPAtVIY66I6jIcq8eRNSp2aLJmxCwgCMafMeQRbPrvM1jyKTUooP+RdJpNNJ5/utZ35oqCaMFZDKygzwEbF+8e5QovV8N+td4djeHeT+H8Qz22XBKRE+GgvmQBk5hYgP0Jy8aRZN2svcttSNJUl3fcgGiMtEtqDhidC1DRw3Djxhh6HiuIq1rsqqf5t3sJ3RRNMRmG2gTIB0WHWLvm1yGS/tAvebXLBPMaaZKF2uazK0i11RkXr2qWBiEsmdhb3nc4HjaE8Z183i0bZrEindjmmLxmjUircN//M9eKpebIKLWLjvutyV0VdKFE0gCQkN9fJ4JwLzSMs/ajJZtMAgvVi4wtrBD2RIyFshIDSx1xt9mKrGu/b4KmvriDgFhPgJBfDAa7Jr0sKRaKREBY+XGIKC6XBLrJdxYsiu00/vNBlrzr61imsmshvk+HiKsUkh8SHRFJA4EuHMBEQFqktJQypm9qOYc0hMPSJhHjD2Lt6Wz0KK2TVkJ4NHVPtY1p9hmxz/8lenKJfFFN8N9QEiO6qql3xsP4xcmakwVxOr4L25tTijk1QM5DVHgi+y8fd9LOvMng+CT5hyXhguBY810Jzar/LdWs7L6cplddKc6RVWfN/yHne
 HQI2xoSM
 a08YRf9NJma3NqDZODbejOIkz3n3NYUOHkI4RyTwNXeP/NFYWeCBGM0tWffWg2g6cturntWgJq0ts/RSrnDwjmcEHTLhkuVLw3xBX/yw7CmBUtsC/lDrfVoXV74JJolsFJFiXv/cyfGGZLCRpiacfhO7YYkszSECu+vNVG4bAgRixx4VX5OB3+Tatt5w2ItjzHFrvyy/laRvQFmsK8wNaNxetNxoXGnJmMqN+V9h/6RIF9xzo5HXNiYUrUae1rR335yN3T4+UoioZtM2OVDeJlWPQ6f7XtnBUgZ/m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> =
wrote:
>=20
> When hugetlb_vmemmap_restore_folios() fails, it stops processing the
> list, so folio_list may still contain folios that were never vmemmap
> optimized, e.g. because HVO failed when they were allocated. Their
> hugetlb flag has already been cleared by remove_hugetlb_folio().
>=20
> If no folios could be restored, bulk_vmemmap_restore_error() then =
calls
> hugetlb_vmemmap_restore_folio() on every folio left on folio_list,
> including those, which trips the !folio_test_hugetlb() check in
> __hugetlb_vmemmap_restore_folio():
>=20
>  page dumped because: =
VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio))
>  WARNING: mm/hugetlb_vmemmap.c:503 at =
__hugetlb_vmemmap_restore_folio+0x270/0x300
>  ...
>   __hugetlb_vmemmap_restore_folio+0x270/0x300 (P)
>   hugetlb_vmemmap_restore_folio+0x1c/0x30
>   update_and_free_pages_bulk+0x2c0/0x368
>   __nr_hugepages_store_common+0x2e8/0x3f0
>=20
> Otherwise this is benign: the restore is a no-op returning success for
> non-optimized folios, which are then freed as intended.

Good catch.

>=20
> Skip the restore for folios that are not vmemmap optimized; they can =
be
> freed right away.
>=20
> This is very unlikely to happen without fault injection, as it =
requires
> both HVO and a subsequent vmemmap restore to fail.
>=20
> Fixes: cfb8c75099db ("hugetlb: perform vmemmap restoration on a list =
of pages")
> Assisted-by: LLM
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> mm/hugetlb.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a1b51251103b..4dac7ed1df57 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1613,9 +1613,14 @@ static void bulk_vmemmap_restore_error(struct =
hstate *h,
> 		* page is made a surplus page and removed from the list.
> 		* If are able to restore vmemmap and free one hugetlb =
page, we
> 		* quit processing the list to retry the bulk operation.
> + 		*
> + 		* Folios whose vmemmap was never optimized (e.g. because =
HVO
> + 		* failed when they were allocated) can be freed right =
away;
> + 		* remove_hugetlb_folio() has already cleared their =
hugetlb flag.

Since you mentioned the hugetlb flag is cleared. So it's unnecessary to =
clear it again.

> 		*/
> 		list_for_each_entry_safe(folio, t_folio, folio_list, =
lru)
> - 			if (hugetlb_vmemmap_restore_folio(h, folio)) {
> + 			if (folio_test_hugetlb_vmemmap_optimized(folio) =
&&
> + 			    hugetlb_vmemmap_restore_folio(h, folio)) {
> 				list_del(&folio->lru);
> 				spin_lock_irq(&hugetlb_lock);
> 				add_hugetlb_folio(h, folio, true);

Something like following:

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6a011b627986..1ab3e61f4704 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1616,21 +1616,31 @@ static void bulk_vmemmap_restore_error(struct =
hstate *h,
                 * If are able to restore vmemmap and free one hugetlb =
page, we
                 * quit processing the list to retry the bulk operation.
                 */
-               list_for_each_entry_safe(folio, t_folio, folio_list, =
lru)
-                       if (hugetlb_vmemmap_restore_folio(h, folio)) {
-                               list_del(&folio->lru);
+               list_for_each_entry_safe(folio, t_folio, folio_list, =
lru) {
+                       list_del(&folio->lru);
+
+                       /*
+                        * remove_hugetlb_folio() already cleared the =
hugetlb flag
+                        * for folios whose vmemmap was not optimized, =
so they can
+                        * be freed without restoring vmemmap.
+                        */
+                       if (folio_test_hugetlb(folio) &&
+                           hugetlb_vmemmap_restore_folio(h, folio)) {
                                spin_lock_irq(&hugetlb_lock);
                                add_hugetlb_folio(h, folio, true);
                                spin_unlock_irq(&hugetlb_lock);
-                       } else {
-                               list_del(&folio->lru);
+                               continue;
+                       }
+
+                       if (folio_test_hugetlb(folio)) {
                                spin_lock_irq(&hugetlb_lock);
                                __folio_clear_hugetlb(folio);
                                spin_unlock_irq(&hugetlb_lock);
-                               update_and_free_hugetlb_folio(h, folio, =
false);
-                               cond_resched();
-                               break;
                        }
+                       update_and_free_hugetlb_folio(h, folio, false);
+                       cond_resched();
+                       break;
+               }
        }
 }

Thanks,
Muchun

> --=20
> 2.56.0.rc1.315.gc6ed9934b7-goog
>=20


