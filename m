Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E932D7308A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 02:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9796B0005; Thu,  2 Apr 2026 22:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C07E6B0089; Thu,  2 Apr 2026 22:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D64C6B008A; Thu,  2 Apr 2026 22:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DBA06B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 22:56:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC49E13A498
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 02:56:24 +0000 (UTC)
X-FDA: 84615731088.17.FFC973B
Received: from mail-dy1-f195.google.com (mail-dy1-f195.google.com [74.125.82.195])
	by imf06.hostedemail.com (Postfix) with ESMTP id EB67D180004
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 02:56:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xlhg0PQk;
	spf=pass (imf06.hostedemail.com: domain of wangqing7171@gmail.com designates 74.125.82.195 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775184983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hz6Sxst0ygp5nZC29Dxxk3ZmG9LEK2pAyjl/7LKh+s=;
	b=m23vyN6qWbJdOYo9hL+eVJWmaFLA9G2mwx/fOpRRV1OzLIqK/LwhSXDHyXR31GAeOM3Zwx
	KBUH9b9gefFOZtJTRvaGoo3glMyGLSM993Z/oTgHNKkaJzTJRn61h58kcq7xzmowGbwKo9
	RY1BFI6G5PMCFXLvFh18VNNE5zn2FUg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775184983; a=rsa-sha256;
	cv=none;
	b=O53JuXp+7FwvoLHvRdlVdWALTRpc3ytC2SNZCJHsnzaDYvOCVECkDaVGVsN4ha6Dbws6g7
	4Moz5H/UDgKE3oALAiNmlN7MqkKmJj0vyHU7lgbfPLIzSu23lcNMb8qq4GjZoCnnKXHqxU
	43o4TG2/Qzp3cZQAziZE9GY/9cIZDsk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xlhg0PQk;
	spf=pass (imf06.hostedemail.com: domain of wangqing7171@gmail.com designates 74.125.82.195 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f195.google.com with SMTP id 5a478bee46e88-2c156c4a9efso1894352eec.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 19:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775184981; x=1775789781; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6hz6Sxst0ygp5nZC29Dxxk3ZmG9LEK2pAyjl/7LKh+s=;
        b=Xlhg0PQkkBghGP7veqVJYPqiURwU/m2SiwYLth4XqJ7cLBTr6khvGV+xDtv61XzRaV
         JBOBX8QSzhx7fhpMdDlYpJmM/ZchRdHy40DiqqAC3Kg2K/TdaJ3lOmT+L57B3KZBXz2s
         Qj1qUBRM6GUp5Ey364UrdTNZeLurLbdS61NLPaEQgb9v2H3peCkXytlkuqsWF0vsNWmm
         Pyijf5WqoHPnNFonLCozJVLdsQpukYpF+3GmD7tVNZyJDatQl5N8FtgjGfKfpSxweDWq
         v3FPygW2X8psiu50ukaFVHLSQUiKrHdvq+tPMkYDGiosqrjgZvbA1DR99T8BVRUJj55s
         NXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775184981; x=1775789781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6hz6Sxst0ygp5nZC29Dxxk3ZmG9LEK2pAyjl/7LKh+s=;
        b=h2odGJrhR+OqY4xitO5NH+UZqb0MnHUsCc6jHmcpirbuZaGCLsz8XucSRWWp1ZVOAD
         8GmuQafFSrMsiNUmGU+8Dhwr8hIJzJ45mqQHGp9MS1gAN0HNDz+cEAJyllynJjFYzMK6
         qmbZOTCOMmNIea4RW1xLJpEL+Uf8sfScFThus4O/BcYU/MJgytU2WnLmR5YtfPeuJlAn
         XsA/dSCL5uI7BXnF+SRMhT9Lsk+QUSnPe3GZQXIBfHhBmAMAyiNnx68PY2XhqEtl0TgL
         OMufUJLgEUyU5yBvGHKHj63sl9vVHhaRw0lsIP8P2Vo0OXfgpgeVZPUTTFEI9FXJziA3
         t7CQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1Y31mBnnDF1dQgRY6JAbUwLfOQMDk7mHcE2ljUoHRC7wu9aT1f869RU6LNTNrGvKU328mbU4CYg==@kvack.org
X-Gm-Message-State: AOJu0YxapE5yCDt+Skuhzyuf+lK9g/iIv954+9zAFKdKMwIyBdQLQpXm
	uJHKXgIh3Xyruj69TBeHg7WUBep3yEvbjuVod6oatxPWQwkl7qiQfzUD
X-Gm-Gg: ATEYQzwBnvtAMYEcy0kZ1RQ8y7//4Alp1GbYOXu3XVfnp3nOX/jbq57eNDIloQyLsy9
	kx6bwr1u+oBmvABjhPinwsnJSCVBE1s8Z/gxqjq/ePwdZ6Vb4TxR2Z4XJoXWTI2OACRaZoIWs++
	kYkno+Q2wtO8qbgqw6djMpBxUrbxS0UdYXMX0TTH+VavWbKXxDtflc677ePpa1k6OoInnkESAKx
	YyNunlCMOuEsaocV/2CeXF7UJtTp6PLUT17L3H9JqIpv5fczpLPflWpA+6pSYx9y9NI/40AyoVS
	Ybz2VUiQTu+RjcWmCRtLV7KHhdPrwRzdbmr+Ru3oXppYpZWK1n8nRfCTjxSWydM64Y+lm2zvKdB
	qI5Vts7G7iWWgHDU5wdLgC/y2+JBvh475mJ+dPx0JAPaTr1IlU0RLdkwa96KGaOyIeXHmcvnsdT
	ULflrIGC/hsi7WwpMLivYsCtWdt2V2U8WoAIB7xyncuw+ehcKw/GuzNI0=
X-Received: by 2002:a05:7022:305:b0:128:d4db:447b with SMTP id a92af1059eb24-12bfb779df6mr685912c88.38.1775184981137;
        Thu, 02 Apr 2026 19:56:21 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.223])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12bedd70f18sm3637461c88.6.2026.04.02.19.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 19:56:20 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: urezki@gmail.com
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com,
	wangqing7171@gmail.com
Subject: Re: [PATCH] mm/vmalloc: fix KMSAN uninit-value warning in decay_va_pool_node()
Date: Fri,  3 Apr 2026 10:56:14 +0800
Message-Id: <20260403025614.2032877-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ac6PKPR8vMlIUdwT@milan>
References: <ac6PKPR8vMlIUdwT@milan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EB67D180004
X-Stat-Signature: 3wpqzceit1ez91689jhksssiiiua6ie9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775184982-499349
X-HE-Meta: U2FsdGVkX18Qcx52uMu0bZEFK0Glrf6HOpOZrBS8NPi0JEqhDl1opP/8t2AVP63pBGQJ3+Hk4+SPpudgoN1tfsesrpAIKZ1nOL7KQxTnX3nOld/Q2WT5s7aB/prYylDdmlLS5BI9+z+ROD43y3LM6TZ7AYL+Z+9p6uMiiskLS0L0AAF5fGkHZ5v61vn00+V//r0h10PRzQYtR0yKh2pBrQgUVmwVKaN/JK6Ks0QNVloEZC6Y8pZeXiZOytQm+PqmXjFEqxHp/mxP/QqpeGDdKpARtIyZZfR/01XHTHtnkDQCBxGZzWo2Rcxzq3zJLXh6m4d++Ww7Q4FxSdjh//xCQgmjAPm8No8M9eqMDC+Bu9LxDuJN9dt5u+YgsPfcfaE6wq6wk60ZxwvzkspyusHQaFuviadFcJxr95hCRA2PJhR/CDVu+k6oEsKMum3Lr4nkbvPZcfxwW8OzpqEbt2D+5xqYyLc0nfMf5/xVmp/cmPtyIMES0CLwkTZqHP4DMjqtHu+dTcwBNIEbI1QpUE7xIOABGpT5860ngksk9VttqFP4lGrlO9dle/ynhqOGkAEEtetC8BDZvDZiOo6CVYCgBqN40eZQgyJ3ILjcYl23hBnXUXJl0GyEdXVySem3GTan9IcNSSimAethuSXmPvxM80VkYwYzw2DFO+oRUhHvCgRpvkk52yrk9WRNqFdsJA2d4V7840kQj2dADJvdp/Qq5/oZJ9ihdjAtYKNEW45ECrf3gxahpT75AjysPOmU0WyQcy7pkt/Bnsb8XHBl42uSaFmoHf84Xl/FeLtaGGscVXI4ecnkBGt+4SCmWnjLuotijZsKmgmHc8O25GpJhEKURfv0dKl9CeETNYFSwCMyK/R1lbazXj9YmTd6cdu8MaQMd09ykFwyl2piTQDFjTFoe8o4k5Z+l5NF28UK0fMa1uXFlAlKxRJymI6a7FYjijFwSMymGIsRlhtv4NYRIte
 HhVNvS8p
 Od2wX7lBiigOy2vTOfI0qic256Eu1yZ7pULguL7PPdg30XrxhCBGH1yYFVJ2JcB59TsrEOkJcnBIAowa1u2RMZcVFimWI1p37TGH/iScfkWhCp5lGPgdTdi5qiYqV0hpq7zG45HUgIb1M96gV8EiDTDY45hIsPC4EO0hVCxZCHUaH+4RQbQ/fw+IJ8ABb8PCjSv9CXevnZ1IwgMg4wFyilXPhsjsNVZHYaHKQSBLYvicU3WXW3gvu5SxwOiZHHDHkcvpzvjgGZE2xb0Gcdxuu9brvbUHuHKf3Z8vvPaFkulOZ+q3O8jEgH41+Ccwn8zsV+G3H29CxZpOiPZX4ZIt6Gsd4NSkkaPYNwopo9a+zyVfWuCGVZOwEdUItUEDbG00JxGeU0Pxu65J4Cw4kfXW9S+IMQ3zET18cwWos1x4g5lm8prSM0h9B6VY6P9SjEBoMFFYp8jgwoSYqkBgDNHrVguJG49lYDD5NLFE+kiJ7aHBb1RXnqq82QshBxozyj7Gobd+zOY+2PQcIajcLd0qGRn5g3m2b8F81uw1krTagagwdnZS6eHh2YsUTiA9saY0mEcQakMqSuUq7HL3XKMjxgboD5Mj6BXqy0VT83Sg6FZpVXWDeA+jhdlMQdX1Q6GSyu7gbruqrF6753O3BKFyWPvDwjnaBHR9lKnju+Q+j7GVHBMWuYDPPNoE+Duliu0lLSdo1U+hJX0yUtfitRwnpeBdnu1KOPgO/OGjrRYl+6HBOLKWStbUtyLgydtiGkyWI1cEa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 02 Apr 2026 at 23:45, Uladzislau Rezki <urezki@gmail.com> wrote:
> > KMSAN reported an uninit-value warning when accessing vmap_area->list
> > in decay_va_pool_node():
> > 
> >   BUG: KMSAN: uninit-value in __list_del_entry_valid include/linux/list.h:-1 [inline]
> >   BUG: KMSAN: uninit-value in __list_del_entry include/linux/list.h:223 [inline]
> >   BUG: KMSAN: uninit-value in list_del_init include/linux/list.h:295 [inline]
> >   BUG: KMSAN: uninit-value in decay_va_pool_node+0xf78/0x1dd0 mm/vmalloc.c:2255
> > 
> >   Uninit was created at:
> >    kmem_cache_alloc_node_noprof+0x3cd/0x12d0 mm/slub.c:4918
> >    alloc_vmap_area+0x327/0x2e30 mm/vmalloc.c:2065
> > 
> > The root cause is that if node_alloc() fail and the va is allocated via
> > kmem_cache_alloc_node() by alloc_vmap_area(), va->list will be uninitialized.
> > 
> > Fix this by explicitly initializing va->list after allocation.
> > 
> > Reported-by: syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=37b7f6cd519f7fb8d32a
> >
> I can not access two above links. Are they valid? I would like to have
> a look at report.

I recheck the 'Closes' link and it's valid.

> 
> > Signed-off-by: Qing Wang <wangqing7171@gmail.com>
> > ---
> >  mm/vmalloc.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 61caa55a4402..8aebbb51e178 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -2071,6 +2071,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
> >  		 * to avoid false negatives.
> >  		 */
> >  		kmemleak_scan_area(&va->rb_node, SIZE_MAX, gfp_mask);
> > +		INIT_LIST_HEAD(&va->list);
> >  	}
> >
> va->list does not require to be initialized. Because:
> 
> 	spin_lock(&vn->busy.lock);
> 	insert_vmap_area(va, &vn->busy.root, &vn->busy.head);
> 	spin_unlock(&vn->busy.lock);
> 
> when a node is inserted into list_head, its next/prev pointers are
> properly set by the list_add().
> 
> Or, am i missing something?
> 
> --
> Uladzislau Rezki

First, va->list is inserted into the list_head when insert_vmap_area()
calls link_va(). However, if find_va_links() returns NULL, link_va()
will not be called, leaving va->list uninitialized.

Second, even if link_va() is called, list_add() will still invoke
__list_add_valid() which reads va->list fields (prev/next). Under KMSAN,
this will also report a same uninit-value error.

--
Best Regards,
Qing

