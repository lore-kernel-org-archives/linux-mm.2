Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A202DC982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA846B009B; Tue, 22 Sep 2026 08:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B9A6B009D; Tue, 22 Sep 2026 08:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669FA6B009E; Tue, 22 Sep 2026 08:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 432816B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:44:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD19EA63E8
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:44:49 +0000 (UTC)
X-FDA: 85241367498.12.38EE90B
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf14.hostedemail.com (Postfix) with ESMTP id 01407100002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:44:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R4SCx8JF;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2/mloYlrcJ4io0NzgMvmL7ZcyTYG1Hsn6kSPBsACzk=;
	b=M4zqFaYCKoTiLOVhP5J26uPRlqMfvyeMmqgJMNriW0sIpyG0Phe9hzmpOV8z6hKhu52zfo
	IewQV7aqt2uILhFuEExCB9Ox1pin8Uv3qzmFuZHynxOG5Fp2YBfPjPQ4pDAzMSGwQ/O9OK
	v4PQRxf6oqRz051EtIQdi+NpE0r3QrQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R4SCx8JF;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081088;
	b=1Jo0Qur8NScYdfDJ208d1nTQAc45rOmyl4IqRZ0xkgvlxJfk1c4DEwGXo50e9KBYKT/e0P
	AmMCg/qfyylddMzEKpboIxo8MzEmS5p3qoFvHh9if6qydR2crV/k8DDSYxEhkMS29I09lU
	d8RGoI2bj3WOBSD1kjehWiIgRHHW3gA=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c264788fd58so620903066b.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790081086; x=1790685886; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p2/mloYlrcJ4io0NzgMvmL7ZcyTYG1Hsn6kSPBsACzk=;
        b=R4SCx8JFRQhw0hZssLIrtBXMGgNftJXW6MH2OjSPNXRT0W0/jB9zhtE80MvQ8eP/AV
         7xtcT9G4o9wVikGLLg6pCJ3xEKH+X52/geljKwfs5MYmfTtJvK2H1pHUjipXmxemMQfG
         mTJrhggs0dlqdpQGA8xqh6qxr1+UFjls47VDOqPArxpLP9eP5yoeIyS4N0MeHT8tUfKs
         ePdg6TwZoGHJt/EoYCZRUgiEBNpTAmWqmRg3j8two5sexM9w1z18dOFMGclucteN5qmA
         FTe3S9eg/D7koheBXFXitN903SEn6miJddpNsRxK6wgKhTSN2L7glR4YdQZTC7piHprE
         Bbig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081086; x=1790685886;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p2/mloYlrcJ4io0NzgMvmL7ZcyTYG1Hsn6kSPBsACzk=;
        b=BXqjSFv+1HAks+njmFpjrvyYAHmPZplBz5WZqB3snevNQti3Q9t9x/aE70AkzsRBTN
         dUl9qnkS5yGsjDGe9vxndy/Soj8ApgV5kiWtkfASVtLG+qE1ZnOzOaqzOPJHczxcZAfq
         CFqoYK+v0+vsQHIMlGj7NghAs5yly5XoJgszMXK0B5jiB56ZxFacGGbaq+n6hr2GNUVT
         xBfX6rCnOvbYyS2hBnLKIiZTzHtScdePEsGGKxbC8qyH3LTmpXZCm31Mx/31UdqHDhEo
         N4cX+cK2ily8TIM5Xz7jI9jYRFGzbzL25FGpslu91+MiJGZE/tP+Ec61Kfmc9LoxFmvq
         7Jwg==
X-Forwarded-Encrypted: i=1; AKwUvBz0uVQP4JnGl8ZAeHQeg6qH+nzQvViG+8Cq1cFMUil4AaoK0ZZH0+h0H+47a64nGrt/bNNjECKaRA==@kvack.org
X-Gm-Message-State: AFuF++n+imLY/miVQec1wZ2chtfhnxopxPs8X4PuVz0F4KYP3Vow4CIC
	fUGN/JoSF3U3JrtoAXdx75i/xtAuoSDSVf7y3xa/uuaC7g7ti0FLzJIN
X-Gm-Gg: AYBFou0aygb8xAGmYQvLdkaYfBwFQEr7jXE2RwtiQePE+osfJyHycEmCPERKmFyUmgq
	Pxb0k91GHeUWpbZ5W2L0OFhkN0TQ85MwHKjeO0mK/jxbBRIJjbRcu51RqtjWrR6mT2F3MXyWNpm
	uIT/nIKULFcc7TTsUj02CXuMUgJFro/ZgNUQCDVoqMh/8/Gu5CmQZcm5RI6RuvokfNjt7Y4LfM/
	sn8nbqLkAgl7TQKgmsJiDl4vxNW5s5WdnCx4WDd/7xIalgaw8xpN9UljignrkppjRDeCEpEvuQX
	TNN6MFmZcKDj+NEh4AIoMHskzqoip+ovcjC+hLWwam/qZdDy4Zqw6+xpjDx5tbGRfIOVQa0DGWB
	oNwyMDSUwGLVFsbcckLORYzAkx3FeD9DCGXEOuWHyXbY8/CNm6hZ73y2aDzTniIdvAfHmPyIYAJ
	k6EYuOeS1xj3dbdByYhvAuD0eTO2zrl7D6znk=
X-Received: by 2002:a17:907:3f24:b0:c29:439b:d5c1 with SMTP id a640c23a62f3a-c2a1585a618mr1167923466b.16.1790081086414;
        Tue, 22 Sep 2026 05:44:46 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a9c580d2fsm74868466b.26.2026.09.22.05.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:44:46 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 22 Sep 2026 14:44:44 +0200
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH v2 2/3] mm/vmalloc: fix vmalloc_dump_obj cross-zone VA
 lookup
Message-ID: <arJ4PLGlF7uhNWOs@milan>
References: <20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev>
 <20260921-vmalloc_dump_obj-v2-2-73fceb3ed1c8@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-vmalloc_dump_obj-v2-2-73fceb3ed1c8@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 01407100002
X-Rspam-User: 
X-Stat-Signature: 6c3y1cj1zxh3mwycusodtuqdd8mwwxhd
X-HE-Tag: 1790081087-762186
X-HE-Meta: U2FsdGVkX1/YuISdk6yZBneMuxzyCVAcXxkrEZWOKlYHg0yKrqwd1KSSAKnddLv9HTqrEZYVlh2C4p77djKWK57FXiE/TBrh/VM3PRAqJlWYRRrhUZAs7Fe374KuuT2mLFjwFIVdk96bll6179qoPRb6TQoRWFrCnDsQDk6W+plGiRWt61eSVegs3Vuk0/OxLufsasgVMTOxVyzIKcTYhpXT+rFxGAoA44Ni9n6riXw+M/jYCqK50oStwStF/nLcpVqDr4y21NDD8AZfomg31jZEz31K5inD3YDr8/oCqiEvHjJbjpZ7A5vwDLCJWrUGiHC2l0ATYzTwxR5u7OQkFWD5U9TQUOpS8Ydxx/1UDEaaZFlBaRgaVWv2wvFeDWbSWr4/292g9EmC6e5qhADNNN3IkFBPLmw8E2oXRoIi+i+s7R/E6OqsZGe45F/3zklWNjEeVsv1ysSPsL6Ner9h+24g5JzDC2v+EeCCt2/YeVD6ilgBCb3RrLF9z60PQGmwL+24jWBaRQZ9HSySYvMSrTNJu/6Bl8kaoBP3vUQ9Lw7Lp1m1VCsKoLV1oOxvw89twgEp2EX8KlrL5VualNWhtY7VOM7y9qG1aVUHagMS5WtVWr7kcTd76Q+iiIPkMjQb3uowX90uksCRm9KrdwGvqiYLWjS421jSv7HPk/qWR2JzEVNGahGsPArekug3AhV3BLJk4/oT8UY8hu1OUt1HxLwJ+rmqDl94daAj6PJ5aaitI02kW267Mam3daOsotOqdw0KEPMrccfhn+2b/e32R8MEuIwyBha6u0RuKyOwtRa8tiApfULTzaHxodbFIuqH3l4g7vAbf6aXaisbYnClckt3mEe6UKn8m+J4DJ64gNsiLZ/bhONNBhdZOAN784sn4/cDd9AfDaV0j67JeBr1Axoluw7XyeM2gk/dVjhYoPRiS3vRa4FpxgwEDERwLKBLq5fnEjsFsUwcJxMQRqV
 qhcG0viV
 xBDM7XL889e90odIWy8iVXmXIByFYWWqdQHTckBPsbQI3kjhzKBH8i9DiLiZu/IS+xrmQ2U4Mszu21uX87WUdMUbsYx0bZE9rBvQtzBpDA42Crpi9TvrFeCYb+Y2GQTzvCX6xXcHINs1/Vvd5nq7hYi837QiPJ8OlgXVpyQpOsH9HTILVQjs0ANLqqbEjnBL0BKQkG4RKk+9bGLnNqFVmWoG27s01AJmSFlTDiy34AOWpg1cIFVVzOuwssibiRWXk1w3YyD7gVNbyPPl4iBj+CqYS8TCX2rCju/TdBsKNY9LF/QOS/geQ2lMtXpBphTVzJhBkLy6wB4nEnAhO5ijVs1MYd1CAe29z5OKq2U9luoIteg65bPl3ZjIm/13pnGJNguT9d5v85xs8gNEDPZaswp9JZgkZRtVIMnOMRdGqDHsp3cWOYuWcPu0vaSfvf9uZzTI5cuir44Z6czBp2TBXQv7nyceXwB+eTU2HIm0P7MtKWUMhg6QCq+y1oyn6KRd0aqMrfHm+5AHagu8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 09:17:22PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> vmalloc_dump_obj() searches only one vmap node (addr_to_node(addr)),
> but a vmalloc allocation may span multiple vmap zones.  The VA is
> stored in only one node's rb-tree (addr_to_node(va_start)), so an
> object pointer in a different zone than va_start maps to a different
> node and the search misses.  This affects any allocation larger than
> vmap_zone_size (64 KiB) on multi-CPU systems.
> 
> Iterate all vmap nodes using for_each_vmap_node, like find_vmap_area()
> does, but with spin_trylock instead of spin_lock as this function can
> be called from atomic dump contexts (OOM, KASAN, RCU).
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index df42d8a6f058..30c610f678dc 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5278,17 +5278,29 @@ bool vmalloc_dump_obj(void *object)
>  	unsigned long nr_pages;
>  
>  	addr = PAGE_ALIGN_DOWN((unsigned long) object);
> -	vn = addr_to_node(addr);
>  
> -	if (!spin_trylock(&vn->busy.lock))
> -		return false;
> +	/*
> +	 * A vmalloc allocation may span multiple vmap zones, so the
> +	 * node whose rb-tree holds the VA may differ from the node
> +	 * the address maps to.  Search all nodes.  Use trylock as
> +	 * this function can be called from atomic dump contexts.
> +	 */
> +	va = NULL;
> +	for_each_vmap_node(vn) {
> +		if (!spin_trylock(&vn->busy.lock))
> +			continue;
> +
> +		va = __find_vmap_area(addr, &vn->busy.root);
> +		if (va && va->vm)
> +			break;
>  
> -	va = __find_vmap_area(addr, &vn->busy.root);
> -	if (!va || !va->vm) {
>  		spin_unlock(&vn->busy.lock);
> -		return false;
> +		va = NULL;
>  	}
>  
> +	if (!va)
> +		return false;
> +
>  	vm = va->vm;
>  	addr = (unsigned long) vm->addr;
>  	caller = vm->caller;
> 
> -- 
> 2.25.1
> 

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 89c327a6ce7d..3719dc02dcaf 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2511,7 +2511,22 @@ static void free_unmap_vmap_area(struct vmap_area *va)
 	free_vmap_area_noflush(va);
 }
 
-struct vmap_area *find_vmap_area(unsigned long addr)
+static inline int next_vmap_node_id(int i)
+{
+	return (i + nr_vmap_nodes - 1) % nr_vmap_nodes;
+}
+
+enum vmap_lock_mode {
+	VMAP_LOCK,
+	VMAP_TRYLOCK,
+};
+
+/*
+ * Add a comment here.
+ */
+static struct vmap_area *
+find_vmap_area_lock(unsigned long addr, struct vmap_node **locked_vn,
+		enum vmap_lock_mode mode)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
@@ -2534,16 +2549,40 @@ struct vmap_area *find_vmap_area(unsigned long addr)
 	 * addr is within 2 or 0 nodes we should do extra work.
 	 */
 	i = j = addr_to_node_id(addr);
+
 	do {
 		vn = &vmap_nodes[i];
 
-		spin_lock(&vn->busy.lock);
+		if (mode == VMAP_LOCK) {
+			spin_lock(&vn->busy.lock);
+		} else {
+			if (!spin_trylock(&vn->busy.lock))
+				continue;
+		}
+
 		va = __find_vmap_area(addr, &vn->busy.root);
+		if (va) {
+			*locked_vn = vn;
+			return va;
+		}
+
 		spin_unlock(&vn->busy.lock);
+	} while ((i = next_vmap_node_id(i)) != j);
 
-		if (va)
-			return va;
-	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
+	*locked_vn = NULL;
+	return NULL;
+}
+
+struct vmap_area *find_vmap_area(unsigned long addr)
+{
+	struct vmap_node *vn;
+	struct vmap_area *va;
+
+	va = find_vmap_area_lock(addr, &vn, VMAP_LOCK);
+	if (va) {
+		spin_unlock(&vn->busy.lock);
+		return va;
+	}
 
 	return NULL;
 }


and we use the helper in the vmalloc_dump_obj()?

--
Uladzislau Rezki

