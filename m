Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B075160A2618
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 04:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=JGFrRZb8
Received: by kanga.kvack.org (Postfix)
	id F18566B05B6; Tue, 27 Oct 2026 00:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1656B05B7; Tue, 27 Oct 2026 00:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D694C6B05B8; Tue, 27 Oct 2026 00:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A24A06B05B6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:22:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28A111C42E3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:29 +0000 (UTC)
X-FDA: 85367109618.09.6E0D3FD
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6B18B100006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JGFrRZb8;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793074947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fgx0S8/0sycDsnMopzoyCblR7NpYYIVN3Htks6C0yAA=;
	b=N+xB8dKywR9weu0lmVn/L50BJlZsJH3bSihNf81AmB8EffJCotNZXyM6NetmkycbqNNl/2
	bX8DKJsJTE9lmdvamdtbi5RErxy/liOOtSmRmUeVv6XXqYpCzRszLBb3oBP48KABZrb3ep
	J3hVi/+mxzhDeCXzgBuVGs5GqfRnZ0Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JGFrRZb8;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793074947;
	b=kzH/DIKtb6XoZhHhBIpOBymAaBgVGXaiBTvKWP4lOX7a4+YYNh55jJjUkWt0SzGQmXtNvo
	Lea/le+YbbZrYx0AStD5i/FtOjmKsJ2OxEpv4l46+LQkEp74+xPFUFbq305WH5/8jvX7nB
	/JCReUTpflOmeT9dyqALM84OoqD+rks=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-53394bffe0fso5634731cf.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793074946; x=1793679746; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fgx0S8/0sycDsnMopzoyCblR7NpYYIVN3Htks6C0yAA=;
        b=JGFrRZb8VNi5ld98ony8sy+mNFYvCbcQ8wBtHqN4J2MLZz+7fJzo8lGSn6SYv5IapQ
         DBluiHBRG0AgKFNULOWUzbwd9XxL7QzjOcMSxBgvLo36yjtIkgNqAjz2zvG20jHzHORk
         OZxHqpszbDoH2R87mOmmmx3erLNKeQE0qQ2qTskEKjP4IAZrUU/YsSQlfMha33lNBofk
         /y4iizv5Nmf3vsVfdrMrU9iC7LR8SfksSrle42D04CSQyuNaeWNh29QIMNkwsnzLAWcS
         SnaFlweZP1H2m82HJDAkXNwcG80wbeJXtvFqqzN/agsFUs9wJKyr5TRqNNRds00oL40n
         PzpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793074946; x=1793679746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Fgx0S8/0sycDsnMopzoyCblR7NpYYIVN3Htks6C0yAA=;
        b=0KFOWFNiQalpljUDQEQwPCQABZ/31wUOuJL9CBJ2xEz2czFAHkMtJXvct+XENrLIYU
         HUu/dCOD2EPmrzmWxHjSjpl9iBbgjg9nista4DOBX6ekIjnOAGh1MnIS3Jbu7jlpfrtj
         Qrcb+sNMjtv05g8sfHlcAS5WY+juYT8635QsyMoxQlyNclvGWkhqhbn/jAw8s89E11tw
         7ZhjdIRv2UlgsMA+I5LPqVKKNMF1F56WVKpazMo1eZTbliwjx9iLju2qYO7Er11r3TxT
         OeeCAKnqBfZVGK30Z2E9X3RwtdHxvN73sAULke/LaPj/5gjfwyzIf5ma9cqNHmHVE2Mm
         cbuQ==
X-Gm-Message-State: AFq9FYIx1M51hlLuavM800smdH837xafuWWxWlW+hgzfk5yyC5WCF8Si
	Xz0wYUhdf9U2fBdU2ey28osAqYAL8OBEOLwkg2u3DTpK3nDsk+Fb2wvItOgdFweiFtv/En4Z/Y+
	HjrqUYXY=
X-Gm-Gg: AYBFou33g+ZRS45I8r963nsGsFeffPtQXiVG6g93kqx4lQUSsN9kZeM11WsPSKNG0Gf
	ySxT2cOxaNanDH7gnV9nb0rF3XvKeK4ZcNWfNj+PaMnXwG5y/QGeuKn825nhHuRfZCVFR0m4BrI
	dqTz7dwTJWlQ8F9JbziLAnXsBVtAb85ML0wEpb5moRw6eg1y1TC3gS0nY+AD+F453fjwCaCd0md
	l1nsx1uCv65W6fzoQRdFBEZ08JLnrzHaDhU5j8y4KwanoaCRYCJXLystBNYfiBrH//srAWmlp7b
	48VV+XPFap6pddaEUEWX4OWPdUav0Ne4wDUZPFd4JlVlFJv7lDrKF2ZOY40gDenL9rsbhjTd7TL
	IxG14muWvnSdOEOF2AZS2R0qiTeOqM5v2wAVu8EFHU/A3WbE51j4Gsx/2MlkfckpRnhNQznbIBW
	K/0hgAHKq9hcnWIBRwRAgLJKBOgqWuF4qFEgA13UQyE0gf1zONm+4xH8lcSH23Xs82pOKNhLvSl
	h4Y5hL0xL5lOdhJew/vmydUHoqllPnR4pcvAS6/FGbrsGLlvM6X0YgZyFKnURnjaeyeYonYbnKV
	TVi+hgSNrfWt2sPfbgo1lrqY4GtqzhVjt8bSYq2oGw==
X-Received: by 2002:ac8:5ad5:0:b0:536:723f:5de7 with SMTP id d75a77b69052e-53e3bd81b50mr32491021cf.4.1793074946632;
        Mon, 26 Oct 2026 21:22:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47bd01cdsm91139676d6.7.2026.10.26.21.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 21:22:25 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	osalvador@suse.de,
	muchun.song@linux.dev,
	iamjoonsoo.kim@lge.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH 5/6] mm/page_alloc: keep the range online while alloc_contig isolates it
Date: Tue, 27 Oct 2026 00:22:03 -0400
Message-ID: <20261027042204.3741307-6-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027042204.3741307-1-gourry@gourry.net>
References: <20261027042204.3741307-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6B18B100006
X-Stat-Signature: 6mjgm7b9mbgseqtjpsx4am5p7gsrtbt1
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793074947-857970
X-HE-Meta: U2FsdGVkX1+9DwLQ/r96qoqLLrRlRfny8GnLKXmPkH8yZhykuqgVByF6SZT5zWJNnewRs6RlQApU/SExsrDmhUohLAg1vWTodSctoRTUdIBPq9xEDplYyOwXDjzQm/DCd9zQPd4mKvFqLAQbxcpzcRRvDntDQpGSf8AZkPPXDpyMK3GGAK6tP/L1gSLn0dcph82amMqFzYSm7LwQ0TKgyRCtleuF7SbVZNxqcufAmC4coD5bB2EMZGqJw8PTTsZRljvRwjZ96vLkUqRezPBUzbpjThOHuJuyRxWPqVudGCeZs7eTeTe9Y/2AVN5rYcNQ9zrNgH5kD/Bn8Hc1VMb0LxpPb4nVXucR3KhSzac53GPyoiYeICENqA4u8lLYq7v8E69u3wWU1ZeiFHDo1rk2bFmb8uJBnHaK5Y2DiZEedrksMj84sFYC1d+owv90kwZIoGuNCDaqB0OwPqvP3mHzc1x9FpSlL1zuu3yGflZxnwgjWERNANZuyWAoK42zNeWSg0KNHA+q6W/fNZds0Z3G7ANrduZpGmyebz3n3M1y1rrg+NrFOTe0K5H+hWvUkf/lqZL908xmx5DyxH3LhiqzSIXkob8qj+hLwM7LD15Rl9PTgmPbpBmU8G2UU9mJrwVavHF7JrpikMsSzEcD7/S22xNrUonfCqj+oS95mCxtltwdK76VWUttPS1cUax0SYstpQBI/fTqY0QpcU1RVpR0BrmA/kgRsXOilQ6VtfkaYXh8vAIvIiff9BXfiyY3HmL61Rzu711/p1NuEzG33QnkU7YcGixBHsWp8hGjSbPlb2mXnEsOGSBPbagVsGfz+o1/nGftyUWi3HHdB9SKqP0t9vYKePuwqBjaVXPoMz6V35qLO5ly1NP6G3rhxFlm8GekGl89cNpRTF2+heK3EWSk84z19IXSKmTpUD1sfDWoFhRfZjH/T3U0HHHV5QHugSEKKhw+lfJHjEHNB/c+M5h
 f9SiFv68
 HAVs/Gae2z3+R8pFT5SU0onDQzYK7uJ6R/3Yg9nETiHtPipE1q3mTM2zSrDVe/qQJ+r0rlYaFsYezAVWpSdkRRzRZxzlKPL1NzLAkJHVkdd4HwmUsZlkIHZq5kCsZEmn+4DTUJ6qSlIazZv9+yoV/XsV0ySTIOkjJuprG2UHExaZhzODtcRZGCAVlMYt05kB1DOxr2Bmxfl3/plr7l2LsFgmLibcBYdgcWpC8AyExvTOvZyNV6dPwLVpXj+642/rMLStPm1Yyec28o4fxOQbA3xq5wwVDiSL8kzYY4SkPLGqb0v2+9dNQ4uRXIW1+EOjiXT6C9SAsWgOeetLi2SrWwGRs+AX2v02o/J8Gw4pRZKyW00mr8TeWWwM5xlwXuvBgy0ni6MbPNYoBbfkPpuiT515DQe6MgDGh7BG+2LOEohplXXi9qLC/MBRY/1IGCT6z8jB2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A gigantic hugetlb allocation racing with memory offline can crash.
alloc_contig_pages() checks that a range is online under zone->lock,
drops the lock, and alloc_contig_range() then reads the zone of its
pages.  If the range goes offline in between, a DEBUG_VM kernel faults
on the poisoned memmap, and removal frees it on any kernel:

  CPU 1 (alloc_contig_pages)          CPU 2 (offline_pages)
  pfn_range_valid_contig()
    range is online
  spin_unlock(&zone->lock)
                                      offline_mem_sections()
                                      remove_pfn_range_from_zone()
                                        page_init_poison()
  alloc_contig_range()
    start_isolate_page_range()
      isolate_single_pageblock()
        zone of a poisoned page

  Oops: general protection fault, probably for non-canonical address 0xdffffc00000006a2: 0000 [#1] SMP KASAN
  RIP: 0010:isolate_single_pageblock+0xe5/0x820
   start_isolate_page_range+0x74/0x1a0
   alloc_contig_frozen_range_noprof+0x21c/0xcc0
   alloc_contig_frozen_pages_noprof+0x4cf/0x700

A range that goes offline during isolation is no better, since
start_isolate_page_range() skips offline blocks.

Check that the range is online, isolate it and check again under
pfn_walk, and look up the zone only then; an isolated range cannot go
offline.  This adds one online lookup per pageblock on each side of
isolation.

With a kprobe holding a 1G allocation at start_isolate_page_range()
across the offline, base faults in 3 of 3 runs.  With this patch the
offline waits for the allocation in 6 of 6, and both finish.

Fixes: 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bb3c7e95f2ed4..82f35816a0711 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7319,6 +7319,16 @@ static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages
 	__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ true);
 }
 
+static bool pfn_range_online(unsigned long start, unsigned long end)
+{
+	unsigned long pfn;
+
+	for (pfn = start; pfn < end; pfn += pageblock_nr_pages)
+		if (!pfn_to_online_page(pfn))
+			return false;
+	return true;
+}
+
 /**
  * alloc_contig_frozen_range() -- tries to allocate given range of frozen pages
  * @start:	start PFN to allocate
@@ -7352,7 +7362,6 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	struct compact_control cc = {
 		.nr_migratepages = 0,
 		.order = -1,
-		.zone = page_zone(pfn_to_page(start)),
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 		.no_set_skip_hint = true,
@@ -7397,13 +7406,29 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	 */
 
 	/*
-	 * On failure this has undone its own isolation, and any other
-	 * isolated blocks in the range belong to someone else, e.g. offline.
+	 * Part of the range may go offline under us.  Offline cannot poison
+	 * the memmap while we hold pfn_walk, but isolation silently skips
+	 * blocks that are already offline, so check before and after.  On
+	 * failure, start_isolate_page_range() has undone its own isolation,
+	 * and any other isolated blocks belong to someone else, e.g. offline.
 	 */
-	ret = start_isolate_page_range(start, end, mode);
+	scoped_guard(pfn_walk) {
+		unsigned long first = pageblock_start_pfn(start);
+		unsigned long last = pageblock_align(end);
+
+		if (!pfn_range_online(first, last))
+			return -EBUSY;
+		ret = start_isolate_page_range(start, end, mode);
+		if (!ret && !pfn_range_online(first, last)) {
+			/* Every online isolated block in the range is ours */
+			undo_isolate_page_range(start, end);
+			ret = -EBUSY;
+		}
+	}
 	if (ret)
 		return ret;
 
+	cc.zone = page_zone(pfn_to_page(start));
 	drain_all_pages(cc.zone);
 
 	/*
-- 
2.53.0-Meta


