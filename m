Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32C6F606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=e2k6z9Lg
Received: by kanga.kvack.org (Postfix)
	id 49ECC6B05BF; Fri, 13 Nov 2026 00:07:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44FB36B05EB; Fri, 13 Nov 2026 00:07:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D1F6B061E; Fri, 13 Nov 2026 00:07:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12B336B05BF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:07:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9275F8052F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:07:23 +0000 (UTC)
X-FDA: 85428912366.07.249D880
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA7C820005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:07:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=e2k6z9Lg;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794546442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pUQ12nlyx4HX6d0KqIKX5qaNGaPIm7bVzP7lJ+Kotz8=;
	b=NUfFYD2aFohg3dVZh1bJ3cqEDVlbdTE1yf6WMyHfRM6Unc5m4dRll2gGUSaZ/muxiTRaAB
	a3RaYEL85YO4J7spDjpqZX2ZPJhreMbK9PLxpSEA2WgJbi2YAAxKRXd0LTmqwR12hlrTbF
	TEeNoqXuWBo7pPIOHb6tpoo0gGjor9g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=e2k6z9Lg;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794546442;
	b=4JG9EfEqykKm3D+hyxJq5gjt1qOMbzpRc+uwxnnGW4mebVh53spK5FHbSMS/79IyeHIqMq
	6yW4/7PmF0xpf9AnBduwuYXe3N6lrMDxa10RExTJi2p8sPw/y2PlOReege3l8CcAInxqQi
	u1BlwHW9pGLz+mPY2LCRENj+cZrcpCQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E27EC463C7;
	Fri, 13 Nov 2026 05:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433531F000C4;
	Fri, 13 Nov 2026 05:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794546440;
	bh=pUQ12nlyx4HX6d0KqIKX5qaNGaPIm7bVzP7lJ+Kotz8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=e2k6z9LgR9oEPd4b4CAv1/nPxjCbaaPq6uHd+OHl+JDwjVJ6KMeCVAgM2iMKW8Gf0
	 diIEpMxXxG5yBsJKLLQGiCf43wbn6qtsjyaeoUV1SshKo0jw0k5+2nx3LBBYxehU7z
	 +GBsnFx9muK6B7dQq8TSCnN3GYZaxEftInJ4vjQQ=
Date: Thu, 12 Nov 2026 21:07:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: sashiko-reviews@lists.linux.dev, Dave Chinner <david@fromorbit.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Qi Zheng
 <qi.zheng@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH] mm: list_lru: don't use a new memcg's lists for an
 offline memcg
Message-Id: <20261112210719.e843ee35b7fa69cf7710cfdf@linux-foundation.org>
In-Reply-To: <avZ3rcGiLnWS4qUq@linux.dev>
References: <20261112221248.3512447-1-shakeel.butt@linux.dev>
	<sashiko-outbox-211977@kernel.org>
	<avZ3rcGiLnWS4qUq@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA7C820005
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: y61k87ymeseeac4eigbkr3shq5g69tmh
X-HE-Tag: 1794546441-842051
X-HE-Meta: U2FsdGVkX18lh4ablgThxGD383TqC5PANqS667VSBv1FKJW+CZS1zBOFUtIwEynR6kWTXYMHCcPP3STNF4NK+2rNfQbPE37TZ8V6XIjFuunfNmXcZ3IITvkvHOs/OKpXc0mVBOx6sKy1mdK7EdmhZOtu2SykSDDU+wAfmAPIjZu6QYJAyK+YPrP7xDKVTcCx9aqzwOmAVWlGL+Wlf4tTzopvS8h7EkZG+Dh7TYU4iCkeBvlOcqiK/eww25Twukps+ZM+/5nxJmiHFgruC9Go88hGkDzInh2luFRHPiVLOEp1EJzOlo2OPiMcyNQnpGDc+lKVoj8YQ7XOTfAywnu+b6U2YAjWy0i96irm/hEaUJQWzUadCW/iiSGGIt438y9ZXYQalUafqudhiYI2O72g31I1IErWZgiruQVqTaTSxn/wPlM0PcmPU58u6cpdTtlglES8DKy5NoIbkFgryp7NsRzyQHpjqIyY/qCqP3S+VM78wJV7/KeVcYQNnGFdPgmYZ8vdg17ZsZxnRZJR3KF0tQmidan6mNCmSSa/ZrHlMNZOEt2RuwhOLEJVBNfQUD5Xnibuww7UPF7M+BXOsk082PCUE25bGVclciEJEtYyZBeojSQ00rkHfwD1p1WShYWbm47pF5eCyFoKWbdo0lN8mM/koqn5ulHUap+q5zUdzAATWiBks49GY8e6h8IiTyzW0J3Q+4YjWUfFhYX/f44blIinypv01OldYWSUgCRRyJLkBbpbtNuguU4ZD/qWq7388TDwtVtgxfOVHqh9/JKwEtsI6EfNh34eRqNxTFL+Ilp6OcO9TQdSTwnI1tljYXf6ui2H34J1UMWQJJZVPi26gJIWhWkdT4cEOZIaRFsvTmSMdsWPTaII3F5D+0Y8QLLN2YvwozMYkZR59ERPTUxKG+WNrJNBfkZoNgF7tkXEZvefJM02+8WRzrXe+R9pj9kGWKwiwSF23YEazTbK6CU
 5Y5NUIbc
 wUWoYHDNH6RBQ/79zGUevBV6NX+VMXa5thZznIzzLZj1Ajyiel5GUqk4Bppd6Z6bsgpEB9V7naQ7dAPuoYGNa2YhnBJ5BLtff2DqgMZOYqT/o/XQlWTuzH8vYjP+b08v4JHhHUB1+iu7vEoM40vCpIj7XPQsw+0FC0UrGy1lpMxT8T9pmhxb7i1Cns4QHPPgeNXo4b8MWWmaRadt8oqZYQya3tTJ26E7DLyNpiuNuwAT3XUcAugB+k2tIG3N5roleFdD1fIzIzMS1vMDhBZGzq0mLTEbw3pekQQyoHVXhnID4PFNrPcRRgi/uAkMNeoIHiHE0vtoCDifEdOk1jFMGQ3/6bzrKoBSWkdXmb1wkeYeA2mDIRXzg3CAN4jRL5vxDiWhGyAV5DgU7s3pOmAL0nKiHcWCECTPoJEoQPLeF1OnZbTekO3k5U8xpfw27QUDrwRLwatEFjlloueMZeGtiM1X4dWyxJuJw9NXSzmXo6Rx2qB1xWyiLOOv98xYpe3X4ozPidMwaOJtRUaCHzeXGZEOGIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 18:37:10 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> > [Severity: High]
> > Does memcg_list_lru_allocated() also need to check mlru->memcg == memcg?
> 
> Yes this is correct and Andrew already have a fix for this.
> 

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/list_lru: verify memcg owner before skipping allocation
Date: Thu, 12 Nov 2026 16:08:59 -0800

list_lru_from_memcg() rejects an entry at a reused kmemcg_id when it
belongs to another memcg.  memcg_list_lru_allocated() still treats any
entry at that index as a list for the requested memcg.  Its callers can
therefore skip the allocation of that memcg's ancestor lists.

With child C and parent P's lists both unallocated, a reader can retain C
while it is offlined.  If an unrelated new memcg reuses C's ID and
allocates its own list, the reader mistakes that entry for C's and skips
allocation of P's list.  Once the folio's objcg points to P,
deferred_split_folio() can add it to the root list.  If P later gets a
list, unqueue locks P's list while unlinking the folio from root's list,
which can corrupt that list under concurrent operations.

Require the entry to belong to the requested memcg before returning true. 
Hold RCU over the XArray load and owner comparison because this helper is
also called outside the folio fast path's RCU section.

Link: https://lore.kernel.org/20261112161502.18d9d72c0139b8f69bb88ff4@linux-foundation.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/sashiko-outbox-211977@kernel.org
Cc: Chris Mason <mason@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 mm/list_lru.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix
+++ a/mm/list_lru.c
@@ -568,9 +568,19 @@ void memcg_reparent_list_lrus(struct mem
 static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 					    struct list_lru *lru)
 {
+	struct list_lru_memcg *mlru;
+	bool allocated;
 	int idx = memcg->kmemcg_id;
 
-	return idx < 0 || xa_load(&lru->xa, idx);
+	if (idx < 0)
+		return true;
+
+	rcu_read_lock();
+	mlru = xa_load(&lru->xa, idx);
+	allocated = mlru && mlru->memcg == memcg;
+	rcu_read_unlock();
+
+	return allocated;
 }
 
 static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
_


