Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F5C606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 14:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q5HczsTT
Received: by kanga.kvack.org (Postfix)
	id 1DF0D6B0A31; Wed, 25 Nov 2026 09:27:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F596B0A33; Wed, 25 Nov 2026 09:27:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07E836B0A34; Wed, 25 Nov 2026 09:27:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CCD506B0A31
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:27:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F718A0D69
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:27:26 +0000 (UTC)
X-FDA: 85473869292.13.92B25C7
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7E37BA000F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:27:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=q5HczsTT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795616844;
	b=qt23tXDAee+ahuHn4E63SGNyE5dxu0BHA4ux8XUkyjdvQZI5LYeqEanfpTQIAqe0oYM21k
	Nn6AtRe5rdqjJUUdLGRK3leLDmQKc1XPHJ0gBb4S8rRFl18ls7Ot9RWC1dNasWakdTBeKQ
	/LpgucPVEAwoUShmWd7T8BGl/jD6i48=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795616844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=git5H/KUb8r/Os1Gz2Z/JEfZLifx/Swk93pecwuIC0A=;
	b=YVwQGeFapDq+dXVW5nRKC5KfipNfDO8QQfs1dpwJVoYrbk7H4y6EzVmlsEBLvnsI3ifg3u
	8BhdyJGRG4YGfSrK1vwv93z2Ct3mZjelee/GJw/mIHk8sHkYCDc1ZRwXx4K8NfMM6rYefy
	o/X2Nxw8q22m9F9uBwGN7zvDRjMVuDg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=q5HczsTT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-3831d564bcfso2147613eec.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795616843; x=1796221643; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=git5H/KUb8r/Os1Gz2Z/JEfZLifx/Swk93pecwuIC0A=;
        b=q5HczsTTJkhuJjOmKk5IeJZP5gbAOocgVa3drmpAhoZSDfnAQJ5MLeHtqvRYgPp3uY
         NPrz4oM5kByJPpnnbJphhztcVwaCiHEqAFfGJR+kG2aHDrvqw/fJ5adgP2MQaoi2lCx+
         eH1+H9ZuboT8aPVsFcn28WB7UY6R9KBiiF7oTddeiNHBByOjCZk1sOdrKf3gcreSPJfb
         dyDikumT1vIe1Bqrh6kXejMQcrr5ySaLbzxwWzYJ26fsoKrrK8E3pEKwVSc36XLhq+/s
         hLmWdQQ1hdHqXYFa1FX7b/clGIZWhQUSmKnRXHKHsNijV16AdRAJQcznHyq8+b/Wyr7r
         sR5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795616843; x=1796221643;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=git5H/KUb8r/Os1Gz2Z/JEfZLifx/Swk93pecwuIC0A=;
        b=cGk4fdQ/tpzjTuJVuo6/E9OieGoS9PFnvW0TrVcL6o/+q5lyXo/bDVgn7pUQ/jrPOq
         9Vl6BLZhABke6CwXXbU2axNnYrhXPd3Sp6HALFsF6+uZnYvJj3z2C+IYJM48KE5v/azQ
         zAvtmM63STMw6S9+MWkO4+gMCpCjcPI8YQKdJFX2H4DwH44sVT+av/vDhHrl76MsJdJQ
         Ir/8F7iBv/ghYuD/oWT3c/z0+fR4H+fjrYJxlFlLaykRYPLu3+yF8drbIjBaVKOoB8QH
         fGR8wNtradOo0s77tnUI5kzwBk10jrbvqdZbkpVeeGS8B5IA4E2ORFM1OpqLJR/2iiny
         KcOA==
X-Forwarded-Encrypted: i=1; AL+hErFfSHanHW6xw9+qoW/KkDc/KgzUhjwZ/KYhF5h9MJ4JleXVVLIzPsEEZNPX49vXYh/gxSWEypZGEg==@kvack.org
X-Gm-Message-State: APuU4Z813KB/ntXQjA5HDHt0uydo/Rp4rFgQqUW2zlwBPlClWtc4Z0g+
	cevhLdYs1+AywtKVQIi0vOE5EjVdhfor/xfKLVBMovNz6K5ef35k+hff
X-Gm-Gg: AZFdTZdVORNNkrd7b7P4oUNcn5Pgj6/JjcxmoFAvbAHUQS7SQOCgHbkIqc6HFEgzWeU
	H0ZxZ22MbHgMZ8WV8IP/15STZNfhqZNajC3OLU1Qc4P71GhsZJk1Xrbn+dfVDJ+80Dx8QbYAi+A
	1OZbKBvac4iehkkOeSqs6rtCxH5iGi12ledrPpNdilnl0U0Cm8L9Lyqsn8IfdWwd97tKD8Q2tsb
	xSpVqTVtOnRCKgf5xr0sTLZXvpaomy+i3GLcsvq6muG8Av9uY7W3pLv4RLmmCyL96ctfg9j3O0W
	u1v/dOW+Mnd2DtMX/piCeyR0hSAYHp34A/qPD2kF+JHkJX3LkSz+UlBmcLduzQZB1g7HaCb/EoE
	bMtwqCy4ujiQBRjmF+Pbw58kg+VetL5uE2F0DpYp5YSkQQNMxBnpTjduXBdNjpirfeJlGPmdPWq
	pjq2AauhPE9cy6xQD5VEz5s00wyHu52HSjLWf8OMBXWHElNw1CScoMhPmvbFR6kXnQCrxnaopk5
	k0B0CxQd68iZ6wEMPz9FJJBMZC/MAQpSUi9c+mX2wnlorLcHiK3EMMB7SVH2WcsU/3m4KMoMSIP
	xiSNCkdOfVJd0uTPiX0AtTl9WHj6G0KGQUParRwKL4v6OSUIFzJe1Rk6M+JnKqU+9CymVgaqPeJ
	Sqh/O2tyI+F1Y8TQEguhDw8HW3eUxLuseFd9UDB1lx2tL+n39cVwISzV46Zx/vKDYQhHPDg==
X-Received: by 2002:a05:7300:c7c4:b0:376:13e5:e8fe with SMTP id 5a478bee46e88-3856c4b839cmr17298103eec.3.1795616842823;
        Wed, 25 Nov 2026 06:27:22 -0800 (PST)
Received: from [10.131.38.181] (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385d2b93dd9sm62402114eec.24.2026.11.25.06.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:27:22 -0800 (PST)
From: Aveline Noir <jm5905938@gmail.com>
Date: Thu, 26 Nov 2026 01:10:56 +1100
Subject: [PATCH] mm/hugetlb: track pending subpool requests separately from
 used_hpages
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-hugetlb-subpool-pending-v1-1-e1831a48f19c@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WP0Y7CIBREf6XhWRJgBUp/ZeMDXC4tptIKrdnE+
 O9LrQ/GxMeZzJx7504K5oiFdM2dZLzFEqdUBT80BAabeqTRV00EE4pzoeiw9riMjpbVzdM00hm
 Tj6mnwjAwYLUO3pPanjOG+Pck/552XStnhGXDbQlnC1KXbYJhsz7BGUesiRcr43Wtzy07cO/Cd
 LnEpWug5Vy7EFR7/GEqSODBSOOZlADCiaP3SjuOjryP6prXJEm/XKbOtmhQMya9726cnB6Pf2b
 Mk/swAQAA
X-Change-ID: 20261126-hugetlb-subpool-pending-290c9ca77fdd
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Usama Arif <usama.arif@linux.dev>, 
 Karl Mehltretter <kmehltretter@gmail.com>, 
 Ackerley Tng <ackerleytng@google.com>, Zhao Li <enderaoelyther@gmail.com>, 
 Jinmeng Zhou <zhoujinmeng@bytedance.com>, linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Stat-Signature: ra6ufj6ir7gjheger78j46sge7z7tr16
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7E37BA000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1795616844-91581
X-HE-Meta: U2FsdGVkX1/dToik2YEDeTpTipdQY//7Yrc0PRVmwJiZAsHP0SrgcbEBWK+GQyJd5wXs5BIk+/082CalDbE+L6bBXoe+oJu9VAdDSf8J4LzbjgvphEU3sqfEjRH1TJ2QzJybgneWGcWuvKrarPvxZ/yhD/0oZL0ckVmVtOBV1SBsN1pyIFnK1HubTUDehXamHOx0xv9sO9X4Y1gLZYbBKAXa8crUnpiQvDxAxAcASsgs0GUgV5uhhMv61hZQH1N2dld8MzNEcjWjcl2fYmh1sITfG7Q6WHzpXX+NLs5zkdXB571KaNSsUflcBz9Sij5O+lvEGdealpVMgGeMU0AauW/yYTZh7Yrdkr6lD13QCxbrTiOxfrFxHHcBP97KPmcOXO9GL5dxCeJw1Y/ZvaorLKf/SdWb5notAuNKMCUIyPeD9wqix02D+ZiqO7cDcb3haw2XDi/rDZE7KR2EIL+URADlia+wxmMOD2WxFBTIlVVm+gNt6ke22/yd5FCENE6dxBAHeFpsf1phWF5vOmqR3Jc38oODpyFOt1JjDV1fQmESG38skqstj1sh30uXIOfW4cRicqkSCQaQ3ZAcRykQ+XzTIDT6hABouSNnOcFTy0v9U5NTl9eZvIYgC9J8kyjbWpYlRA5LYjUfrvwBvUKmpczPYNk3trohjZvr91C6wYM0gn1krqYGXE7ZGbPgckXx6xOBKTMoFuI89W4fhNXJ5dHRl1QvGOgDZem98HomLZoSsJT+i4yj5X/cbxghyMa82IUVFWYcnJpYK8BosbFcBOie4NZM3vLgGhW/QInUvejaMH+mpq0IzRMzU81W1R+IkCK2yCaKFA2Qw8+pzbF+BUJl2y+nregfGI5gs4DDnQ93cuL804hYAFFG/ukLirboXg79D25XWepnbc7lp0xjWuDNpTgc6VQMxMk9eSuwU9o0d6cfIEzUoo827+E15qAD7MGvrji8mHhU0ltuylb
 6eYjOpUR
 0DFKckM6dD7UEFwTI2AmEv+leFwqXMiW8M6tu+NbGx0F/VJp+Scg8NGOfvaddcTXyrh9bxpHFiVjQsCtmaGiNTB1nqAqCHVwlAOBKfWAn/xuCsBPPeBeLAPrH9mxRtfxWrYJPaj5PxeqkRogZCpDpDjck63kh1cgwJJe5OhhWvI5h7L22Ng54jAhO67iPuwDoLMGovQ7tXKfxnORpCTEWF4vIZffpKaqolkjqEwAv8rsA3SDoEOgOTrekyc9YvdT0caYbnL2fdr7HaH+mJnWZS4i3J6ptyXm1UM0w0pKsYLQ0bjZ21GXeo07ZyzGPM9kEZghMjOLry4Y+SV5L3F9vGN8cRnYpNuC2gYnQ3Nyy+p86VhEfGT/+gUVtH3lS+gx+bhOL3Cd2HBTRI8BNyu4QNu1eVdwGrCE6uxEhXcHOdw1SLGfZCML+RVTd2ZQNbOV4qvZlYf9TPaZ1U4YnrAa/LYtsDOR4UYT+OgFlqlZoQ9bp7vBT4IMoMAGTNYaYihh1aL59nMpmIrwnGi6hm9My6i9ePc9tHy8laSDsyIpA6U6BTLKQL6CxenZX9WXZuMenKsHMhIoD4GFdmc415ilPzcbV336FNLl81ioP23EiOf56yQtLbKQW/zvfHB4DS3Vf/wAnnNRfc0Q41GKQp9gckDHVyzUuT5De9+ez1NRlGWhTtTdg/fv6tn1yWG+ysAiUcChKyG2R2x2UOUqVh8cMOscIaMbJqfbKHGyfYkivu2DSRKNoX0hipPUiaGY+qnWw1fGEAbWsNsJwF+jieWlct95T/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On a hugetlbfs mount with both size= and a positive min_size=, a
reservation that fails global accounting while another task releases
pages on the same mount can leave the subpool short of its minimum
reservations. On unmount the subpool then drops all min_hpages global
reservations, more than it still holds, so HugePages_Rsvd underflows or
another mapping silently loses its reservation.

hugepage_subpool_get_pages() adds the whole request to
spool->used_hpages before the caller has obtained global reservations or
a folio. A concurrent hugepage_subpool_put_pages() compares this
inflated used_hpages with min_hpages, skips refilling spool->rsv_hpages,
and drops a global reservation instead. When the request then fails,
hugetlb_reserve_pages() only subtracts the failed global portion from
used_hpages, so the refill that should have happened is lost.

When both max_hpages and a positive min_hpages are set, keep the portion
of a request that still needs global backing in a new
spool->pending_hpages counter until the caller commits or aborts it, as
Karl Mehltretter suggested on the out_put_pages thread [1].
hugepage_subpool_commit_pages() moves it to used_hpages once global
accounting or folio allocation succeeds; if a concurrent put refilled
rsv_hpages meanwhile, commit trims rsv_hpages to what the minimum still
needs and returns the excess for the caller to drop from the global
pool. On failure, hugetlb_reserve_pages() drops the pending count
without touching rsv_hpages, avoiding any positive global adjustment on
rollback. A request that overlaps such a release now fails if the global
pool has no free page, as if it had run before the release. Mounts
without both max_hpages and a positive min_hpages leave pending_hpages
unused and return 0 from hugepage_subpool_commit_pages() without taking
spool->lock.

hugetlb_fix_reserve_counts() commits its page as well; if
hugetlb_acct_memory() fails there but commit trimmed a refilled
reservation, one trimmed reservation covers the dangling reserve map
entry. The max_hpages check, hugetlbfs_statfs(), and subpool_is_free()
count both used_hpages and pending_hpages, while minimum accounting in
__hugepage_subpool_put_pages() only considers committed pages.

Fixes: 1d3f9bb4c8af ("mm/hugetlb: restore failed global reservations to subpool")
Link: https://lore.kernel.org/20260927170103.2381-1-kmehltretter@gmail.com [1]
Suggested-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
Applies on top of:
https://lore.kernel.org/linux-mm/20261125-hugetlb-subpool-release-v1-1-7398c24d09b0@gmail.com/

That patch is a runtime prerequisite (it closes the free_huge_folio()
reserve-restoration window that commit trimming can otherwise hit), so
please do not backport this to stable without it.

Karl's idea in [1] of keeping global requests provisional until commit
or abort fits this race well, so I went with that approach here. Karl,
would appreciate it if you could take a look :)

Note for the overlapping subpool work: for size= + min_size > 0 mounts,
in-flight global charges now live in pending_hpages until commit. The
pre-existing alloc_hugetlb_folio() failure leak (now in pending_hpages
for those mounts) is left to the separate alloc-failure fix.

Tests passed in x86_64 QEMU with KASAN, PROVE_LOCKING, DEBUG_VM and
DEBUG_ATOMIC_SLEEP.
---
 fs/hugetlbfs/inode.c    |  3 +-
 include/linux/hugetlb.h |  4 ++-
 mm/hugetlb.c            | 96 ++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 85 insertions(+), 18 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 4a92f31c88e1..a893ba76eab9 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1138,7 +1138,8 @@ static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 			spin_lock_irq(&sbinfo->spool->lock);
 			buf->f_blocks = sbinfo->spool->max_hpages;
 			free_pages = sbinfo->spool->max_hpages
-				- sbinfo->spool->used_hpages;
+				- sbinfo->spool->used_hpages
+				- sbinfo->spool->pending_hpages;
 			buf->f_bavail = buf->f_bfree = free_pages;
 			spin_unlock_irq(&sbinfo->spool->lock);
 		}
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 0d5414392d87..2fabc19e245a 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -39,8 +39,10 @@ struct hugepage_subpool {
 	spinlock_t lock;
 	long count;
 	long max_hpages;	/* Maximum huge pages or -1 if no maximum. */
-	long used_hpages;	/* Used count against maximum, includes */
+	long used_hpages;	/* Committed count against maximum, includes */
 				/* both allocated and reserved pages. */
+	long pending_hpages;	/* In-flight global requests not yet */
+				/* committed to used_hpages. */
 	struct hstate *hstate;
 	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
 	long rsv_hpages;	/* Pages reserved against global pool to */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 05c34ca44a15..a2140a0e7615 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -151,7 +151,7 @@ static inline bool subpool_is_free(struct hugepage_subpool *spool)
 	if (spool->count)
 		return false;
 	if (spool->max_hpages != -1)
-		return spool->used_hpages == 0;
+		return !spool->used_hpages && !spool->pending_hpages;
 	if (spool->min_hpages != -1)
 		return spool->rsv_hpages == spool->min_hpages;
 
@@ -219,7 +219,10 @@ void hugepage_put_subpool(struct hugepage_subpool *spool)
  * request.  Otherwise, return the number of pages by which the
  * global pools must be adjusted (upward).  The returned value may
  * only be different than the passed value (delta) in the case where
- * a subpool minimum size must be maintained.
+ * a subpool minimum size must be maintained.  When both max_hpages and a
+ * positive min_hpages are set, pages counted in a positive return value
+ * stay in pending_hpages until the caller commits them with
+ * hugepage_subpool_commit_pages() or drops them on failure.
  */
 static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
 				      long delta)
@@ -231,13 +234,11 @@ static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
 
 	spin_lock_irq(&spool->lock);
 
-	if (spool->max_hpages != -1) {		/* maximum size accounting */
-		if ((spool->used_hpages + delta) <= spool->max_hpages)
-			spool->used_hpages += delta;
-		else {
-			ret = -ENOMEM;
-			goto unlock_ret;
-		}
+	if (spool->max_hpages != -1 &&
+	    (spool->used_hpages + spool->pending_hpages + delta) >
+	    spool->max_hpages) {
+		ret = -ENOMEM;
+		goto unlock_ret;
 	}
 
 	/* minimum size accounting */
@@ -255,11 +256,52 @@ static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
 		}
 	}
 
+	if (spool->max_hpages != -1) {
+		if (spool->min_hpages > 0) {
+			spool->used_hpages += delta - ret;
+			spool->pending_hpages += ret;
+		} else {
+			spool->used_hpages += delta;
+		}
+	}
+
 unlock_ret:
 	spin_unlock_irq(&spool->lock);
 	return ret;
 }
 
+/*
+ * Commit pending pages once the global pool backs them.  Return the number of
+ * subpool reservations that are no longer needed; the caller must drop them
+ * from the global pool.
+ */
+static long hugepage_subpool_commit_pages(struct hugepage_subpool *spool,
+					  long delta)
+{
+	long ret = 0;
+	unsigned long flags;
+
+	if (!spool || !delta || spool->max_hpages == -1 ||
+	    spool->min_hpages <= 0)
+		return 0;
+
+	spin_lock_irqsave(&spool->lock, flags);
+	spool->pending_hpages -= delta;
+	spool->used_hpages += delta;
+
+	if (spool->rsv_hpages) {
+		long needed = max(0L, spool->min_hpages - spool->used_hpages);
+
+		if (spool->rsv_hpages > needed) {
+			ret = spool->rsv_hpages - needed;
+			spool->rsv_hpages = needed;
+		}
+	}
+	spin_unlock_irqrestore(&spool->lock, flags);
+
+	return ret;
+}
+
 /*
  * Subpool accounting for freeing and unreserving pages.
  * Return the number of global page reservations that must be dropped.
@@ -1038,8 +1080,17 @@ void hugetlb_fix_reserve_counts(struct inode *inode)
 	if (rsv_adjust > 0) {
 		struct hstate *h = hstate_inode(inode);
 
-		if (!hugetlb_acct_memory(h, 1))
+		reserved = !hugetlb_acct_memory(h, 1);
+		rsv_adjust = hugepage_subpool_commit_pages(spool, 1);
+		if (!reserved && rsv_adjust) {
+			/*
+			 * One trimmed subpool reservation covers this entry;
+			 * drop any remaining excess from the global pool.
+			 */
 			reserved = true;
+			rsv_adjust--;
+		}
+		hugetlb_acct_memory(h, -rsv_adjust);
 	} else if (!rsv_adjust) {
 		reserved = true;
 	}
@@ -3253,6 +3304,12 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		goto out_subpool_put;
 	}
 
+	if (gbl_chg) {
+		long rsv_adjust = hugepage_subpool_commit_pages(spool, gbl_chg);
+
+		hugetlb_acct_memory(h, -rsv_adjust);
+	}
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -6944,7 +7001,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 		struct vm_area_struct *vma,
 		vma_flags_t vma_flags)
 {
-	long chg = -1, add = -1, spool_resv, gbl_resv;
+	long chg = -1, add = -1, spool_resv, gbl_resv, rsv_adjust;
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
@@ -7058,7 +7115,10 @@ long hugetlb_reserve_pages(struct inode *inode,
 			hugetlb_acct_memory(h, -gbl_reserve);
 			err = add;
 			goto out_put_pages;
-		} else if (unlikely(chg > add)) {
+		}
+		rsv_adjust = hugepage_subpool_commit_pages(spool, gbl_reserve);
+		hugetlb_acct_memory(h, -rsv_adjust);
+		if (unlikely(chg > add)) {
 			/*
 			 * pages in this range were added to the reserve
 			 * map between region_chg and region_add.  This
@@ -7066,7 +7126,6 @@ long hugetlb_reserve_pages(struct inode *inode,
 			 * the subpool and reserve counts modified above
 			 * based on the difference.
 			 */
-			long rsv_adjust;
 
 			/*
 			 * hugetlb_cgroup_uncharge_cgroup_rsvd() will put the
@@ -7088,17 +7147,22 @@ long hugetlb_reserve_pages(struct inode *inode,
 			 */
 			hugetlb_cgroup_put_rsvd_cgroup(h_cg);
 		}
+	} else {
+		rsv_adjust = hugepage_subpool_commit_pages(spool, gbl_reserve);
+		hugetlb_acct_memory(h, -rsv_adjust);
 	}
 	return chg;
 
 out_put_pages:
 	spool_resv = chg - gbl_reserve;
-	/* Restore used_hpages for pages that failed global reservation */
-	if (gbl_reserve && spool) {
+	/* Restore subpool accounting for pages that failed global reservation */
+	if (gbl_reserve && spool && spool->max_hpages != -1) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&spool->lock, flags);
-		if (spool->max_hpages != -1)
+		if (spool->min_hpages > 0)
+			spool->pending_hpages -= gbl_reserve;
+		else
 			spool->used_hpages -= gbl_reserve;
 		unlock_or_release_subpool(spool, flags);
 	}

---
base-commit: c8117bff684306f5c1f959d055cc2b24dd67b1eb
change-id: 20261126-hugetlb-subpool-pending-290c9ca77fdd
prerequisite-change-id: 20261125-hugetlb-subpool-release-ba8e9e7005dd:v1
prerequisite-patch-id: 4e904ec452de2249cd958c99e9801fdd211f2d20


