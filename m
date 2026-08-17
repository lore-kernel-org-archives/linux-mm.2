Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C9ABC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A8D6B00C4; Mon, 17 Aug 2026 08:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9722C6B00C5; Mon, 17 Aug 2026 08:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C546B00C6; Mon, 17 Aug 2026 08:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 547D36B00C4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:43:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C25D41C1A4E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:08 +0000 (UTC)
X-FDA: 85110726456.24.C0AAD5E
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id E359BC000C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ls4fv6kt;
	spf=pass (imf22.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786970586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRrI0ZiNFWDC68LZNy9rl9u6YO6/uPndbIK+uC0O4Y4=;
	b=gVFlczFDd+uq7IP5oxOO/DdfEe8us5cU7/nJmTwHrG2DoxIEBkvrO9t6pCLQBp7wM4cZ5H
	D5LV0l53dW2Zw9S5O1vVWXQ22cQwiweoXyX3OW2y3r57OHzgzOnq7TBBDG3eybNvu0J8lf
	/fq00evdvfqIojWX4gI78I0b0JWrphk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786970586;
	b=VFblwHQCQpnUdS2AgLo1hexJp29ovPnCfpEc8hRv6xDJFMMUYG1hB1cBaV+tHi3AKSGWmD
	FczKi9SCiZKPHu4x9rqTSKb5XcsFkh9lT3P5y7h/jpFp62NFAGezuceCqtGgMkRfY5kbyE
	WkV/jzwbaqOve2Ru3m7/n8BB9AD6u0E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ls4fv6kt;
	spf=pass (imf22.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c1712a04ddaso552196366b.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786970586; x=1787575386; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sRrI0ZiNFWDC68LZNy9rl9u6YO6/uPndbIK+uC0O4Y4=;
        b=Ls4fv6ktWaSpsgnKCH0E9VqidpLoHCgwvUgVKXj0AZc0TK2wxMuxxHir3ce2pvGZRt
         V/rijX9Uh51F6xH9+cg4VVZ5T/pnrfGA93MhbX1NTEKxc2o84fnI0MaiqYeb9jOUR708
         XoE0ex9dMLAPpAhgs7a1UEtsOqSNapNz6sOpaP/zDx+ij+x0cXGFSXehpswyb14pzB46
         qEuKTOP1xRqoCQB0Gsj+PwKhRavFaKlqjQK2DNH5eEj3RRp+35fluXeDmJY/g5umXK/R
         2ZuxYrpfSl9MEwM1m7SZeb+RHg0lGPPwVx1Q9E4QWTzTE5fiRyJEbUSr31PTF/fjGE+I
         ow0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786970586; x=1787575386;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sRrI0ZiNFWDC68LZNy9rl9u6YO6/uPndbIK+uC0O4Y4=;
        b=HaEu8Zm4dXgnnMD1DfAIIVC8sdEJTvT4kc3+9Lh3By4qtAvJGTKQt4PaAwz0Tav6cn
         +ZAc61Bm+Qk+iJDYk7PU8sQQ8gtwbqSQMlXwvo7eUE/sS7T2pPHUlZHZVs2jtH5sSxN3
         ZS2XdDs1cGCOAl2Ytp5oE5nCaPo8nw2I4bhGSMoFG4Nxc17eXiuJ6qMR1P09+LejgTrG
         Wk/8i6419xABg9cT3LawBD5Wkp/AfiVTd2zhqI/W6huh0Mrml/iZPigrHDsqfaSaNYPL
         KEM0thZQuUoX3j2o2a6NHdY7nHn3ILRS6nr7ijoQrguIeAfNd02zqi/31G35yewRAUYW
         gPRA==
X-Gm-Message-State: AOJu0Yz6tln2Sm0pUJ8HfiXXCkr0NdnNSUpM9b9qP7EOj4sJK+V+D8op
	3yp/nQN/xO7+d0SV/jb7NULttM4tbjGPjxVGiF4iqwSMLrmFIc4njtO+
X-Gm-Gg: AR+sD11ltaCVuTjeC/sf9L6hv4VqUm6ZI5Vkp9/ytKEawrYaJ789ly5Zcu8EoLtxqKZ
	NMluOd4+LPZbKyLwngUnIlFoo8lE+ueBFtyoLD9ufUv6xNqCob9FrMCt7Z79/ILwSx2z3WsObWb
	aLYuvj0xxgnFBecsT6xcjnu6I0e88Bz5Twcy29u09++HvLutcxWB5Hy6I2Y7DRMojpzGgB+dO/F
	iJL6+eArK/JNTSqOpYigVuC65CmeRylwJbniIdTjbD3G6Ucp+jYBq/X+W2N4F8uwiPEPw6ROoqR
	LG//5soSSB4sG1lj9nqwO1uGmkhGUhjSyelFiKZDhhTLYc6yjs3kUrYCJiShpoMns6FhFj3c4a5
	oSyiXNxxeuzcgoYCU2q89fONb7ReJlGArJjhsiC+CfjFRbxCdXFrnW+vE+S0hZaOsE+Xc5cQMnC
	TJy/TYxjaHOLTuL05NhQn7bBl73+x+UMUY38L1TyohuUQOlX5cpw==
X-Received: by 2002:a17:907:1609:b0:c16:b87:de64 with SMTP id a640c23a62f3a-c212a1250a6mr1202678666b.15.1786970585499;
        Mon, 17 Aug 2026 05:43:05 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:3861:1e5a::306:a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c217feb99d4sm52626266b.22.2026.08.17.05.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:43:05 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Mon, 17 Aug 2026 13:42:46 +0100
Subject: [PATCH RFC 6/9] mm/slub: materialize trie-backed stack depot
 traces
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-stackdepot-trie-v1-6-53870ca1651b@cloudflare.com>
References: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
In-Reply-To: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Stat-Signature: c96zkbokfea8jomerf1rybnxxuafn5to
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E359BC000C
X-HE-Tag: 1786970586-200211
X-HE-Meta: U2FsdGVkX1+QbqMG7rn240ikzcsdF4C5gdI0tEAYaKpc3b1W2BeI44g1hXfr6NtnY/pWjzBQoOjLYc4sZv58nnfCcemgrwqimXtZppZy4+zEK7y0JQ6sPhgQFV4dxhp8B1/4LT6nl54oyje5oil7wtQF+KhD7fx44DnvTYJflqAfSKS2lV/3KKczZPqSd2eOzCvYf6Peh4uAdIAecisrwABOHwK3SiGu/6mxCGRnesmPBFkWNVnVw6rLWNxRmbb2Afw+fpK6jAzibnHs6JynCAz3vzUljVo6FTfxFtJkPCAqanlLAayaJvqddQnDF2pEYkvceD121i/aoFRmUCRIBUpFmacMpHINLEAF+ELZvTOf2NrYiodgmqrMGUsSkGlX2y4Y7Vip6UkvO5rqa4zVMFJUor0UCfNvRRz3EbKZ1ifmpjEMjdaeBFtOMmuGzgPExyesDfhkWmktWhKRZKfROAU31mZvglc8J4gzVUAsehfcajGU0bTzX35Yzm5N6LRxYHjYsvCKRWYaAfk8KUB1XB7vNrGKWObNpadcIpeZSQMdZa8F7lX6yt0mOOUXCIiejK7vs7LCBL+J40Co1l1uGUO42zp4Bx2c19lSsbZgOsYMMA9B3pxnVYVJtzbUPBKX7BNZf/VfjPn/2BkAfSSDhEyW1zQaG322OG2oB6UyZEb7EBGcgOYC4Jf0aY6jM4Ft/CFJEgbYyTubXujxZJT28RdoTaxmG6OPTGFtkm0nMxpV7ZRcYmJVWRwRJ6fzPLdkwvLEedUiFhKOovAhbJQn5gb+UjGC5em/X7MY+S5BchZQDHZM+wN4jCETaOyu4OYH7J7YWI0tKuxaZete3/bR8ejzT29JRV9s8MiSpQeuU+cKg/8JFVFtBbLJjizSCIvY97ShGE1nvo7usJh6D/gEGflLT268/zj9mG41++fW9n28qmBQYb6e1n1fyfqSMLkMjLgDqkARLvz4Xn5txDF
 k18omRhG
 v7m65Y9dB5sy5m2w2tw3UEdI2LrefIy5bSML8LVoWFyNhc7ilbawcWhOkShcNyr3PHJ8XgHJIIXSfbCTQpQxC2wnvfozVNF/afwY3hjGw+fATU2I/GL+hDgklyq5G7ZITFaFV91CiI3XxgGE0vDFfkeJuS66+iL1QzQLx68DrGQn8lp+miAhuyDkwLeZLSsc/F3GyT9NKhiF/3M/AUrcz72Wx7YZg+QbmzPGm6ZgnnARQqf5kC3Vx5QzxoyoExDfSdi9FyWBkx9Ub8UUJTrHo53ry7TT3WtTYmIlNBvkxv+1FFtHKwv/AJ2rEYSSqdNy0P+Ed+8j847hL/WTkKQUmdcfDXhZ0xFbID/D9nDZV9RkiBJlJa9CdIC6596Ct1UnIXf6XwcyEy3ZduDEgFtGL3QeTXvmx0ILbBAgQN7mMwRRe0nxr+GDGPIpLzWCf0XoULWXnmqBpTLpVUXxQraqda5/z6a6XKmlVrbh8
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
index 422bc3e12c02..138c3bc473c9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8093,12 +8093,12 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
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
@@ -8106,7 +8106,7 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 		trackp = get_track(s, objp, TRACK_FREE);
 		handle = READ_ONCE(trackp->handle);
 		if (handle) {
-			nr_entries = stack_depot_fetch(handle, &entries);
+			nr_entries = stack_depot_fetch_into(handle, entries, ARRAY_SIZE(entries));
 			for (i = 0; i < KS_ADDRS_COUNT && i < nr_entries; i++)
 				kpp->kp_free_stack[i] = (void *)entries[i];
 		}
@@ -9815,12 +9815,14 @@ static int slab_debugfs_show(struct seq_file *seq, void *v)
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


