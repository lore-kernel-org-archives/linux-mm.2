Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15272CD3424
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 09:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 511676B008A; Sat,  2 May 2026 05:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1DC6B008C; Sat,  2 May 2026 05:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8EB6B0092; Sat,  2 May 2026 05:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6AC6B008A
	for <linux-mm@kvack.org>; Sat,  2 May 2026 05:40:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B39F3C1DBF
	for <linux-mm@kvack.org>; Sat,  2 May 2026 09:40:18 +0000 (UTC)
X-FDA: 84721984116.11.98D4960
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id C75D7160002
	for <linux-mm@kvack.org>; Sat,  2 May 2026 09:40:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Twge+6o1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of error27@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=error27@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777714816; a=rsa-sha256;
	cv=none;
	b=4T3xEnLBLQxerCUUMD4PP5ERKUYK+2ShnDXxjGnB1jvsfGvFwvdCj7qVuUgDOu6+Ww8RDF
	GRatSItP/PPzcATtQnrF+LA4jizWKsxkaa/YGE45mw7B1X1RNIo5y/Xe3VgxkkehmA+hab
	6C3hEJ4phwm7qHFsRpqXm8K6RuIi1gA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Twge+6o1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of error27@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=error27@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777714816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xWxxzhKBAmtcwBT63aGnVt/i27b3I+bhzf4HGA2Jwck=;
	b=m50yeAV1vm+pDWXGU/Fe6tOCzZnB6MTSlEfCyq0icOlT9GegrPbtSYMWK2E2EOBn+Ee/gw
	1FWULUiRsYsNHuYQPPG6SuiidK5zpW6+zsIPJHYAsl90v6jDJRoY7fqq7wTQB9uDSaBRz4
	8JR7RxpB9+MrQblydU4Xl7MASx6dIqU=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so38378775e9.0
        for <linux-mm@kvack.org>; Sat, 02 May 2026 02:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777714815; x=1778319615; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xWxxzhKBAmtcwBT63aGnVt/i27b3I+bhzf4HGA2Jwck=;
        b=Twge+6o1FHEs5fdc81gLMSAIhfuEcincCgQBrQOMqaCv34DRsAT7pzGLkIrYW1y0I0
         u/QTzqHXR041rXWvYFqMOFYRaYA396GKA33Um4sxWLqueqFBCjbF6y0GYof68UBq3CDt
         t6JYqQ7zwEe7q/ufo20ng6MO/mBjcklKMadfXeabyyMml+wcZ4GoPEqgM5YE4vWrnw0M
         kYZ+vejxFKTlWy5JF75ciRPdTAcqRCHh7dJCmYeaT7DyxkaMw7qxInFsqVYKelh0fB9O
         YaJvcVDGiob7Sb5RFRXSkVJfC6V4K3ptjghc9r6/DtnazRTgU7DGk45aDH0IdzGsf+Kw
         ma1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777714815; x=1778319615;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xWxxzhKBAmtcwBT63aGnVt/i27b3I+bhzf4HGA2Jwck=;
        b=dGTQfCVnWghZ/OCW8dEPRnpB5oMdFrBV0ii37wNsze/GEIbrYJYtiXwo2aogzL5XyZ
         a+Y7cE5soBxeqhm5ER0vVg5nut54V4gu9VIpWS1KYvQEkOvFlwl9BXbV9iS7JtUcTlF6
         pTMKysZPZbRVOF4wzUXJ2xRvXfmG4ufiKmk62IvDvNMa1l1EV2mb3zwPZhiE85qdk5MW
         BZiZ4DZ0rfD196J3sJ0kR/N1C4qZZ+QIA1yfUGqaYeySsVazqVzIcVlzlEu78VcBRVvg
         zSJGd43vp7dC4DoQ9ac7TmylX/QZcavNg+81ZGaFAIR3Q96T98qQ6eJ5WpJ0tHysgLHk
         dWvQ==
X-Forwarded-Encrypted: i=1; AFNElJ8F8X9873Men9sjCD9H5iUVn9CtTzF1dUIy213ckIwfsNl6IUipP+JnMF/LW7GsXGIHSPRUyfLaFA==@kvack.org
X-Gm-Message-State: AOJu0Yy3IIF7d5GuAl43Np6YMyyU9KvbExZzg56M/xbAQqzF2YMWlM0E
	yFWP6OP8d7MMyncudUAsH7gFxf9dDTKitvHKuV58CU0biXsCDanXz8Yx
X-Gm-Gg: AeBDietNhjCvAw6qOCvAq9tKMM8E92GuPNFSrOzbXj/YDlFoCu7XGIsbPLi2p0/GPE2
	aUKScjleD61YHJSfl0GSKHKkaeZX+H57Di5QghV0zexF686X3cwkBT7J0n1PSOnWUrkwpz4Jf6p
	BzB10Uq8CqiXzmRp+ac/VnSkz+twHR8axS4zahLifrwuQE5ykPz+XOnUjX3/2x9yYBz7ZQNFXa2
	QIbJDH7uap6+0cJRP9SGFirkEP/SqZIMFHxj5yv8mvo+QZKdZbwO7BwvMaUseAchGWCb+SHpO2K
	N2HU9Wn2xnZYftWb0QQh+lmgXb85GRZSECx0asBXsW+t15tzc4m9zD3vZ/6MXM3MW5i+5EXOiBn
	ydrmyEqU9OjQiVP1x0oCwTMIUTsQh9inTdF4g9SiT7ugU+nHyl/cXnESBPiKiE21FmrBUvgLyQF
	ac2OYyRTxPPZYfpGcjFwOLBV1ACPQbq8u87gZQP5iI
X-Received: by 2002:a05:600d:16:b0:48a:563c:c8e2 with SMTP id 5b1f17b1804b1-48a9852d292mr27498815e9.3.1777714815081;
        Sat, 02 May 2026 02:40:15 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a81b99127sm180583055e9.0.2026.05.02.02.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2026 02:40:14 -0700 (PDT)
Date: Sat, 2 May 2026 12:40:10 +0300
From: Dan Carpenter <error27@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-mm@kvack.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Subject: [bug report] dma-buf: heaps: Rework heap allocation hooks to return
 struct dma_buf instead of fd
Message-ID: <afXGeq1AvqFY76MY@stanley.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: xfw8wa6fbq5tkqyxgcsnb5xbp6xkry19
X-Rspam-User: 
X-Rspamd-Queue-Id: C75D7160002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777714816-237974
X-HE-Meta: U2FsdGVkX1/SrtzKxvVS1ucRbK6Z71h/meibqyqxAUZTUEvaQjP9SFuoZJaWc7xTGlYPepXD6iTSDxzMGxl82p722Jwj40WGDIqQuCYzFDXGZ6PyyGTwqMLUOG+nu7Yx+8LeTgQezL5IMy8nvBsz/G0v13M18shNnm4ryxDi7RVlld3mDft+nrQxzdILUc8ilQIrzmt8qJvFjoCLZDhfZff6FnF1AgUuNhfnhAAyVLLK0PKRgl/RKLHoSlNlZHsh5PlsjKEv2UowVptYsRBbcqo5A0dk8J5EckGcxXzYOY9LmqC5XBp7dExYOjpc0SkURQAbuXLINZuCFQX/9GL8+K6j05HYcM93UHbBtKSMRaLJ4cAR0DlbGPFoTBI6AvYHgzY1llQAeKJ0Q3ii61tkSysf5eY7DyggUHfBM4y9dEUFmzw1tpx6pndV4QeMIwB5YbDfeWdDJYPuAhb7b4hahMmQn7NvHFqiL+tqEX7rQBuQ0rgX8wxeP+a6flRuwnKr8sRkW+94msAgNTe5wnpTuXhMwWDWbdJRyYu5OPbuEHQ27fnTQFeT5ijl173D+sSk53lZhWEeyJhd1vpceLUDbq5vtiaAOBifnPY/4XEadf0oICFc4i3k6oB+NyXG+FxJRTxLzUEm6weKESL6jri4KeOLY9yUnWVX9kS7sDZnOpJ+cofrWfcwp6CkGWVGlnr4hDC1stEj/o714Ux2pK0n4mGdD6Ese97xJ01NPdy8SQAwf+P9ppEngmqLDdcaUxy5pMlCHD8WheyW8/u+vZnDerHSMDNuhE4O3khOk4dYGb+q2vVevELlX3FwyamvOt33YYo1v0PBtzM6QIrgQUBsU2htBwauOF3Cei29ADpeHVR7zRHy5d15qdQ1VLsaRJd6cCmDJznNHJJChmMlsUqJVHBhMFszJ6lWJxFS2/ElUpIMOj4F2M9e3XcFlm2ZHT31CFSFumuf8WMAxj7Fw2t
 clv7Cpmk
 JuJrA3N4MYvoxXgmFzTyzNsSriyMm8mGCQCVQqokBUjOpSmf7HxTuLik5GrSTi0pyxKpdyzWlRXdcmRJLegZPpFMUWf87QSXWBO/VCGS9Q4wdmc/bN9xpTppLIMLji9EvJ4GeOghQpdT0GmhIfIXeA/2PYNRMvFvIVcjrcPDEDTpcJ4CqtjfXZkdMaJY/hO1DaKJIkgv8exxT1L+vVIDEXHGkw9PQYmWqzC894ZkGQdr2q4AygFakhIFRTdFkU8JXNLfUnB2y9wtsjV3WiWAHiMhDkoKN7N35YWWcaVS1gB69mGKFN4Nz3cobqR4tghJmnKeWkIkXc0nI2N22rbnMFARwsY8DEc3w+zVAy0OmTlzH2Rp9DsaPrP5p8QFNF/RPJzLfR9QkXDmhCkgYu3qHNp563/FP6Sf0QRo8Zs7eF0i6hWrGB6YRbK+sbblb7mOGwClKAaoaDCmUVQ6miBGxjy+RKarVJF750BBhwaTzCEUpWFqTPSaLS7Rd0n3VfHWmPbSfyZXfa7Q/w4yOxDKfWXe280DzZpAZ2XR4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm not sure exactly who to report this bug too.  Probably the mm
devs?

	drivers/dma-buf/heaps/system_heap.c:499 system_heap_allocate()
	warn: passing positive error code 's32min-(-1),1' to 'ERR_PTR'

drivers/dma-buf/heaps/system_heap.c
    459         if (cc_shared) {
    460                 for_each_sgtable_sg(table, sg, i) {
    461                         ret = system_heap_set_page_decrypted(sg_page(sg));
    462                         if (ret)
    463                                 goto free_pages;

It kind of looks like system_heap_set_page_decrypted() can return 1.

    464                 }
    465         }
    466 
    467         /* create the dmabuf */
    468         exp_info.exp_name = dma_heap_get_name(heap);
    469         exp_info.ops = &system_heap_buf_ops;
    470         exp_info.size = buffer->len;
    471         exp_info.flags = fd_flags;
    472         exp_info.priv = buffer;
    473         dmabuf = dma_buf_export(&exp_info);
    474         if (IS_ERR(dmabuf)) {
    475                 ret = PTR_ERR(dmabuf);
    476                 goto free_pages;
    477         }
    478         return dmabuf;
    479 
    480 free_pages:
    481         for_each_sgtable_sg(table, sg, i) {
    482                 struct page *p = sg_page(sg);
    483 
    484                 /*
    485                  * Intentionally leak pages that cannot be re-encrypted
    486                  * to prevent shared memory from being reused.
    487                  */
    488                 if (buffer->cc_shared &&
    489                     system_heap_set_page_encrypted(p))
    490                         continue;
    491                 __free_pages(p, compound_order(p));
    492         }
    493         sg_free_table(table);
    494 free_buffer:
    495         list_for_each_entry_safe(page, tmp_page, &pages, lru)
    496                 __free_pages(page, compound_order(page));
    497         kfree(buffer);
    498 
--> 499         return ERR_PTR(ret);
    500 }

The problem is that add_to_pagemap() returns PM_END_OF_BUFFER (1)
which is used by pagemap_read() and nowhere else.  The call tree
is:

system_heap_allocate()
system_heap_set_page_decrypted()
set_memory_decrypted()
realm_set_memory_decrypted()
__set_memory_enc_dec()
__change_memory_common()
update_range_prot()
walk_kernel_page_table_range_lockless()
walk_pgd_range()
pagemap_pte_hole()
add_to_pagemap()

This code seems sort of old and I guess no one has reported the bug
so maybe it's a false positive, but it feels like it's asking for
problems to return the PM_END_OF_BUFFER.  There aren't any comments
on any of those functions above explaining what return values are
expected.

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter

