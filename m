Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C69EC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6B886B009D; Tue,  8 Sep 2026 09:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D266B009E; Tue,  8 Sep 2026 09:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B964D6B009F; Tue,  8 Sep 2026 09:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E20A6B009D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:14:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31DE680691
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:14:02 +0000 (UTC)
X-FDA: 85190637924.29.4F9558A
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4A08FA0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:14:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BHaLIz03;
	spf=pass (imf15.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788873240;
	b=yJnHl5NMLqtmfX2/DvRomV2Hw1toRk4vNWLxS9bDwpC/kErwcR/2KIaycwwDWz2V1DyzeB
	D0HUfNg0TlHg7Zbm055cjN8NQ1B+uHR0ipCwFQu9dJja1T78rKEprG1/Qn4I5IRQIcCWk8
	DXdBE+A8pic53Tqx7lYl7e1KeihIQYk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BHaLIz03;
	spf=pass (imf15.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788873240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feAXqKN1iMgDWT0yxjPZBEzrVPGz+wLdhMnnl2MxBJE=;
	b=eLjjXEMvY6rmzTbnGt40KdY0Sot1wulB+bajX+h2N1lKgIC1NYbD2uTl+SQL1XDSXkgCs0
	rmvIf4DP7VNP23XIOEABvsGT50MRgo+eoZN0XmFTUXocHTgMHpcJkeXsWxOY8g0rVg8PZz
	dEAr7OGCWCXU6johsBPEENOSe8KnWZ4=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2533d83e3bso793433166b.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788873239; x=1789478039; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=feAXqKN1iMgDWT0yxjPZBEzrVPGz+wLdhMnnl2MxBJE=;
        b=BHaLIz03DTNbJrY8MueL8TCnmSRBStkOI7pYRJT44hqJMP7pqEteAsN247P15JiJOi
         1D6KhkHGbNMlcfqUvPFc2fhUJRormY2jFQbtJO4axbs0r/3ncNHouVewDSTGfUFc8oVY
         0nMgcQHnDu7Z401HI+TgVPoAxPKlprTdCKvTGzcrbLT8ByG5NPpGlGVgRwmtzgJRMJ+V
         oKP3JkoDDmDGZJ2HMKRj51F2/s/Uv99BoS00snbjYz90tLkU8Ev/Z/PlvIpx+HUux+5s
         kefoa0UArHNNpXZWlUPPVhORSN0lARVnMHtn2mrl8BjMNP+0WOULGyzgARQAPTcgDo67
         SxFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788873239; x=1789478039;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=feAXqKN1iMgDWT0yxjPZBEzrVPGz+wLdhMnnl2MxBJE=;
        b=QzRFjh3pppv3+HIRnGengrUl3Qcq1uhvg2XuOahgwTTG3hvP7+Dsu+p8PT7/cniexU
         9U9vshFTI7uqQNzyPz/vkunvjnLZ99teq8SZYDXcT8v+NW0EYmrKFX3qR/VwOwTy5/UE
         mDx2/+2ck7XRovjahvdJfCvTHAJPl+BsHZClZdlcT6yxYpMx7yUNaOI/1391ysyoIBxc
         XWibDPy3OpvL6JX7US9FtECNqgx3HdRHtUJLhay/sZpOsMnWJqFHoG/NWNVAgCJS4PFd
         bdtrASZiumCmzDpgsytqxQxKKW5k1CZ4FEWxf4amIy6nBZOU9IG+bDghbxwhAU282Cz3
         ZALQ==
X-Gm-Message-State: AFuF++nf23U3veudbU46kbvPJ61PjZmpFkzPzdJZSbs4iCkx3CL/T0Jg
	dcc5DWYVkjFBQocIE/94ohbEbLiqkE76qhbqD2itld29j3r42p5AJfO0
X-Gm-Gg: AYBFou1MJWYijvI6eCHslHTXWdw+IyKveNydqUPqMM9q3/YhBr/LsjGA3YehS4je/No
	v3e1qq0Ob7YKrookqenkpVkdAl+6cuompCIoCuaqyDFlIIN+hW6j85OjMWThaVuuRY7hoHfYNEH
	I6dEG92bIWr7n9L4BFGWLMh3250Bt9RLg0C4kOunC+ddHBTwfsTJorFPlLRM9Ea0gwgaqGbjh3G
	px2/k/FhpVSHTu52bET+Kw0oRkZHcvIUh/KPE0rVceEs0jJdyoloB8N3kSvD8UOkvEN8km//hRO
	ckD+jNp9Cjk30hWiwK1S+Ydi9bbebX5j6IU8YQOBqqTh8e84ax8gD1ibeUdI9JxwJJCcTCCAoO9
	6789s3iMroyiLupzOKgXxzSqLKM451GcwXzQtbaeKryCdlk/UhV0AoXsKQVrNBQhMBdb98jwaP1
	UndV5536ha3oAZJ336v7xCJ3XBaNEfXAvpzXXDNw16eDTHZRz+qA==
X-Received: by 2002:a17:907:d87:b0:c25:504a:1e25 with SMTP id a640c23a62f3a-c260cbd2d02mr1995012366b.13.1788873238868;
        Tue, 08 Sep 2026 06:13:58 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:37a9:1e5a::306:1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d6e1c93sm625170866b.63.2026.09.08.06.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:13:56 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Tue, 08 Sep 2026 14:13:39 +0100
Subject: [PATCH RFC v2 06/11] mm/slub: materialize trie-backed stack depot
 traces
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-stackdepot-trie-v2-6-1996d5cef732@cloudflare.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
In-Reply-To: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4A08FA0006
X-Stat-Signature: 49h7w91mcq4zdc47whnb5mucg6o6epq6
X-Rspam-User: 
X-HE-Tag: 1788873240-764696
X-HE-Meta: U2FsdGVkX19l87kiZwr2E8vEcLA5KNd1Dvvhgg8rbjkqnlanyfxlcNN0ESsFtlTMgPke8W+NsFnBTtkElUhIAn9fNmCM6k+pev5hay5TRcvTxTYTIhC36jWh3aD+rxfSWCO0zjw31hRE2jpmbutfer1Tp+WgnGSK9IqkAJa3mfVKjCxksQqWEc/tYRicwR37Y77rE15HMoplQgl02hMvFB+TVuPk6pOxR0B/zvWPOOJpWcWf/Z16Pne8yJZRP+0vCNtWdWXH7BY66aaGj4sd14iZKppQZFUGazFKF+8BRG1HwWmQTIMJrXdXCm2pZIRYYIhRMWXpfRkAmMyJHgKoKSIOV0aBaskDXi4t3WgjrlcNgEfZiZ9iQlrNUbPSkPvwLJ08MdJZj0u4IR+GF9IF+CnZ+xZNfmnJCQNAL1udChB6RSEblpV2UiKT7hWXAnXA3ud91goSRmOUGwFu4R1AtxXAVEOd79uQMVh3mH7mCt6ZJifg+ngLMSdFf5Q7JAFu9buagumAxTkp8F6IQsLKlnCk6noMUpoRmhLH8nok8jp8CHIdP7wGs+L5tU700L1BCZnHX6tG4kxJFh5g4E5ji20UPDvFVP+n2XNcxbMBJIuMqe9R48kKRlyOeV2d3hpphS2G86BQQ8tBu5M/yScaobvtjzJgZY0gSw32A8YR7eYNZL8fiZFWbo549gZCxl/mWvIXrk/e6xYD7lbKnt618x+64QJrZI0+B1XFugCvBk+ToNY12/LbquTWyXNBaJEDdeXwdg7878yX00Wz3QcW/RJoFJmUqt5yWyeXVyvEZfFf0lXY1G8pgJC7fXWsa7N49fTyOPp3diA2zDYetn86M87dCoGRXtrNCgm+e8sZtunTOnrXBWXIj511tGqHYf1Jhv03FlYGEOvPT3XRuV3/+tE2UMe0TJvf8YyYdceFf+zI1mKXdknuGFMyDdiD6fcPfBauVWzC/33bpBer1X2
 tMgmF42p
 MI7miiUtworiBabdYo6MGBMzX6xdE4PcB7Sih7wsZqWF/OXQAdbNuCAaM3NhGWEmlzjqOf+38YAbRmdUCn2gOKB4uD8LUZszJWDPGrwbmsbXtulgfe28w4Ytp/Miyt625R1ZUxzZ8Rzw7vfFhxPgeQ+friWVOWsth1SPGVKw6FMmry2hA0Lf2TB80Da0LZUXjswmxQYOEsKqb2nvw6X9/tbwBrSzZW/R9CWM5JxlTdjqLQwh5Rm70VG7pG96umRlCuxH/6UDoc0oMUK8g3L3L+GoW+kVnF74mFYM0sZ+CP2pXcAr7GcV0eOiQpDimq9ymWzIr3val2F9xlk/A35IeSgPCV6urIeu796UEXi+SqC06xLZEhhKxCW80W4VIbkwx7shGy9iRi0D30syh9G5tLTO0FMU9eNZJsTaIEq2ZgeQCCgyJoP372Ny7Jub+zX3kfSdM+X4DXNqzniZWPGVuF9DUo3cZa1icW6be
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

SLUB owner tracking stores allocation and free stacks as persistent stack
depot handles. Trie-backed handles do not expose contiguous stack-record
entries, so __kmem_obj_info() and the alloc_traces and free_traces debugfs
files cannot use stack_depot_fetch().

Use stack_depot_fetch_into() with TRACK_ADDRS_COUNT-sized local arrays.
This matches the save-side limit. Keep the existing KS_ADDRS_COUNT copy
limit and debugfs formatting unchanged for hash-backed handles. Continue
to copy or print no frames when the fetch returns zero.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 mm/slub.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f9b56cb439e7..4aa1c5a45718 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8198,12 +8198,12 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 #ifdef CONFIG_STACKDEPOT
 	{
 		depot_stack_handle_t handle;
-		unsigned long *entries;
+		unsigned long entries[TRACK_ADDRS_COUNT];
 		unsigned int nr_entries;
 
 		handle = READ_ONCE(trackp->handle);
 		if (handle) {
-			nr_entries = stack_depot_fetch(handle, &entries);
+			nr_entries = stack_depot_fetch_into(handle, entries, ARRAY_SIZE(entries));
 			for (i = 0; i < KS_ADDRS_COUNT && i < nr_entries; i++)
 				kpp->kp_stack[i] = (void *)entries[i];
 		}
@@ -8211,7 +8211,7 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 		trackp = get_track(s, objp, TRACK_FREE);
 		handle = READ_ONCE(trackp->handle);
 		if (handle) {
-			nr_entries = stack_depot_fetch(handle, &entries);
+			nr_entries = stack_depot_fetch_into(handle, entries, ARRAY_SIZE(entries));
 			for (i = 0; i < KS_ADDRS_COUNT && i < nr_entries; i++)
 				kpp->kp_free_stack[i] = (void *)entries[i];
 		}
@@ -9946,12 +9946,14 @@ static int slab_debugfs_show(struct seq_file *seq, void *v)
 #ifdef CONFIG_STACKDEPOT
 		{
 			depot_stack_handle_t handle;
-			unsigned long *entries;
+			unsigned long entries[TRACK_ADDRS_COUNT];
 			unsigned int nr_entries, j;
 
 			handle = READ_ONCE(l->handle);
 			if (handle) {
-				nr_entries = stack_depot_fetch(handle, &entries);
+				nr_entries =
+					stack_depot_fetch_into(handle, entries,
+							       ARRAY_SIZE(entries));
 				seq_puts(seq, "\n");
 				for (j = 0; j < nr_entries; j++)
 					seq_printf(seq, "        %pS\n", (void *)entries[j]);

-- 
Git-155)


