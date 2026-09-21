Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED24C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08DA06B008C; Mon, 21 Sep 2026 12:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061E36B0092; Mon, 21 Sep 2026 12:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4BE6B00C5; Mon, 21 Sep 2026 12:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C65146B008C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:48:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57EDF1401F9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:48:25 +0000 (UTC)
X-FDA: 85238352570.02.03D6611
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf18.hostedemail.com (Postfix) with ESMTP id 270EF1C0008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:48:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b="WP/+Nf4V";
	spf=pass (imf18.hostedemail.com: domain of hsj0512@snu.ac.kr designates 74.125.227.140 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790009303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmR+gFnwjwx9HRJSW244xTdy4CpVHKmXxMQ0vpvGnEg=;
	b=1UD4z75o3vG/y4e9t4bueeKbejR6oNx4d9W9ib6YVGBCMhpJRciUFMTvPTw+hqbDsfZ43X
	2MHSfF3mrcjy179kXe0GvKnifCeKq+BoqVx9KXFFEWu0nBp7cFTFZIQqdgMKRL84dpKwGH
	A0ZWO8kLt1WDXK2I2E0TD5hlH1Il/no=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b="WP/+Nf4V";
	spf=pass (imf18.hostedemail.com: domain of hsj0512@snu.ac.kr designates 74.125.227.140 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790009303;
	b=TDfj9K1revDjqEv5Op2t/jutFdRSIyc4wnH0r33OrvX39/Fs7kfebkbhMTq1FiHX0VR8OD
	6lOnjVk8NpBXP6efJvJ8Moakz7gGwCXKx7y305AUXRlX8Qfp5qiVbvS4znzIm+c0X6Wn5x
	j7twOkgnp+BKQya6g8EbJ/maGoOTkhQ=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-398b3b189e0so2788929a91.2
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1790009300; x=1790614100; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PmR+gFnwjwx9HRJSW244xTdy4CpVHKmXxMQ0vpvGnEg=;
        b=WP/+Nf4VfOqfUUI1pxsEdgA0gWyS/bFZU0L04t90xxTdJqaKk5PFDokF1zmYR3CCqD
         rx0WIPHe4kuOOlyhn7Bh0+hQGwtnqGE2OvWs06mkIVkOMs2BUhII3I/QTliQBo8WlOQl
         O64ny7IV1TwCG28W1eVzCPNQY+3qwdBbOYJUU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790009300; x=1790614100;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PmR+gFnwjwx9HRJSW244xTdy4CpVHKmXxMQ0vpvGnEg=;
        b=xphIMLPe5Msiky99Lo548qo2U3ISndhESyE1pehjWxEVCrzt+1UMN10FJDoqoWveIk
         1EIgPeXWG7qFs9dJevhNeZQSxdEeIL5gb8l36Je4K6spUCFVAoH7vpS2jG5YzC5RwE1c
         aomPglVWNW6ADvc77LF2YOWb0qoJrG2dj51tpbuhtZaD8Wz49bLcwOYMrTVKVDtyP+XG
         89SkUFOqg6Cn3jm4cfK9fCNVkvnmMvAaGWejDcP0l1ROwsCDua5ZwCLbRT3b4S8KO6Wu
         6vtRmZWReQ7tLggU6k8Iyoz7+0wNEii+vyR3ntFOlv5f9yVAdnmVcBEFt577g6ZIVkEM
         /siw==
X-Forwarded-Encrypted: i=1; AKwUvBwmL38WU2zp+TpwjsYH4ESCLm1Z6RJIanf46+VblUmb4EscyFiKYqeCTOFqM3XGwGzFygFPyG3reQ==@kvack.org
X-Gm-Message-State: AFuF++nKFXVTe8t73awW+oSaBtxTyVjYWauyavMKOY/s+qPY4Rg1lazf
	wUYKj1AMsZRM2e0Nt0ZZnWY5j8EexLCLLz7kUqZrjxTqnf3o7jXj9bSQksCPloVgCRY=
X-Gm-Gg: AYBFou14c2+g4+/7ytlS2H/xsreJmXNWIcuA0MOOhrjcYnK8Ov4KVgUxqXP/HCSiNXJ
	zzIOxckdsQoUlugzaxiHp3smob2Ab+R07B/4t/vtWhdJby7kDg/Ur4FfkEfE4YnGlTCQOVccoMm
	MS2cHXRBwiwLkXu2zoKj1m/5Om/ucrsjTQf1x00RZDj9AsC64xqCajssRlKglVb4aAiIGjalryi
	+8ZV15ze3tQTpEJL9OePT8sxLsOJtb86pehQXnRn2HSRJKQOYEs8d2jfgHdiwG+ZCVqTcZ8j9FK
	PqVcO0UWFXGOMOp2gMz/i/0vxGrNim9otPkOhxxE931+CVgG8aUUUfiDzSeJGPPWBiy4A6teQVv
	s9NE/igNYVM++MtvEnlJxQNpKtcHVxCEJsiHOKvvg4j8ZB6c6+uZ5rBoOWwdx0mey7l7CCyCU8d
	hyDeNlF97JZgIWMmbKo9kjUyiCXTyRh3muIOrxcYnZgbM553/hHHiR1inrMw6KjDTZ9w==
X-Received: by 2002:a17:90a:d888:b0:39e:4c7f:8b16 with SMTP id 98e67ed59e1d1-39e54cf8bdbmr17750548a91.27.1790009297592;
        Mon, 21 Sep 2026 09:48:17 -0700 (PDT)
Received: from 1c1aead48890 ([49.142.45.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0673209b7sm148455a91.16.2026.09.21.09.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 09:48:16 -0700 (PDT)
Date: Mon, 21 Sep 2026 16:48:10 +0000
From: Seongjun Hong <hsj0512@snu.ac.kr>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Kieran Bingham <kbingham@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 09/12] mm/sparse: remove SECTION_MARKED_PRESENT
Message-ID: <vpz5zqg5nwbpolxbkip45vxxdt3lni7j2haal7q42skc3b57tu@uh4cec4x32dq>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-9-008fc8d579fe@kernel.org>
 <aqK9S1hBpPnujgz9@gremlin>
 <eb5b465b-c256-4454-84de-517aefcd6d59@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb5b465b-c256-4454-84de-517aefcd6d59@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 270EF1C0008
X-Stat-Signature: 43jf5aftpkx88smwpgz7o1bdd6htd7ai
X-Rspam-User: 
X-HE-Tag: 1790009302-415880
X-HE-Meta: U2FsdGVkX18v5FT7WDt2+rhIospPk0/0X9GQgPGUQriCzkAYqruB4S9yDMTsYREUuNw/kjwCcBHT6zD/s9yJyNMkLMrrvpDT7QOxHDyYBdUn/DSKlMXDlR9NSF5IzV3dUmiNt9llscgHqY0rTm3fc/XFKKnG3GaRSILs8ue8rv73+IQVBbx1S0s1V+yaC3tzbwyU+Ey3G6suq6hjjErHHGstg/vQRWWnh61EdCpe/ik288oHsgeZizpbSZZOilaFJSo1BnoYeDlDESKRZIyfrZpTxns6SuwAwiBZep70Q2ZP4avbnPkMnCcdmX22Rl+3bRsFbZL+QSRWG+e4Cw3bjquusZdB5vHKKJGSECi+HlH4oqydm4x1Z/jf1GMHwat8XOEq1sheyYNbXoCfEJ/gl6TIgrwrIX3kL+xgUrZpmZ2i304V5WPqXQopF+WPN1DzHFjuuOmDnl5SrXycNvyetqNZuGYrMQlEp1G8ENZC3Es/qFtYytVUoOXnCvtwapcnIfZXbZThqhSXWYyg/nb3Mx1VBbn8rWKjqDOuQKbzQRpeHcEx0OvRnKKUSFoE6zhD+ctV7mpu/517XvYI9qkTZe0NQcO8tE69KP0ZChH9OV/3b5aHTs2Yl90M1aJ5k+ak5ShFKUnB7dYN2XnCmteHj3vWfUl6QyxALEOFwfoWky7qYj6RiUpGNoxIvGLrqmRIjDTWLe7VHUiwi3BnwytWv9m9pV5pOg/yt0wfnGNtWTTkWNnU3dcjCRKIMC7JGDs6roy2NS1vGHgxCuM9kn6nsJhbXN5BHD2Bqp80d4KmEjZb5GiTxTb1ZlJWRBDq5B4iefhF7wzUwm49xLlW5oBFYa2SmqOg0/8kzJoseN+GaOlQq37mRdKbEb3k7ubeFJD55oFIl6F4xocg1YYBdujl/Yb2PDXlY5v/qZh9kJxssg6XqJSDt90dd82KV2tvztjxf28cXQaEhx6CStfF3Sh
 Q8x3P3O9
 g0fUe2/D055wWQ6+i6cnKFuw3QkPAFDqnHZy8OuvgIPBL2NNjJUZhI5Db0nWvwameEpmRyVm7UM0xddlm+s25OwUCncIFtk3GSBvn3yLP96HpzzNi1pczNUyGD8fRwQhxLjaW+jp7XHflzbqWPKDElBvjtDtK0QOBsPeoVAIlskZJcN7NtL9nsJr0yMUlX96wvKsBZqF8HRvJgQ/Fgc69KRRmTGXlkAp6kgJq/PXTOU2salYgSH0zGvpapAZZyDJblIx/Q51x6vg42zera9z1qjRxTpcXaXBR9DVDuJj7mCSP905VoagDK5N5sAPfE+d9dVGYJN0cO3PanMeYIXdNGX37CSG4BI5jmhCm6JVnOJ5XSap+b3fm99gYuMfK+oBVBqZBMqKoF0PWGYDBWnhJJK9hGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

I'm sorry for the delayed response.

On Thu, Sep 10, 2026 at 05:11:36PM +0200, David Hildenbrand (Arm) wrote:
> >> +++ b/scripts/gdb/linux/mm.py
> >> @@ -76,7 +76,7 @@ class x86_page_ops():
> >>              self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
> >>          except:
> >>              self.SECTION_HAS_MEM_MAP = 1 << 0
> >> -            self.SECTION_IS_EARLY = 1 << 3
> >> +            self.SECTION_IS_EARLY = 1 << 2
> > 
> > Seems a bit strage given the code is:
> > 
> >         try:
> >             self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
> >             self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
> >         except:
> >             self.SECTION_HAS_MEM_MAP = 1 << 0
> >             self.SECTION_IS_EARLY = 1 << 2
> > 
> > Whereas other variables must be available with no try, e.g.:
> > 
> >         self.PAGE_OFFSET = int(gdb.parse_and_eval("page_offset_base"))
> >         self.VMEMMAP_START = int(gdb.parse_and_eval("vmemmap_base"))
> >         self.PHYS_BASE = int(gdb.parse_and_eval("(unsigned long) phys_base"))
> > 
> > etc.
> > 
> > Is there some weirdness with gdb? Or is it maybe because there are some configs
> > without these symbols maybe?
> 
> TBH, I have absolutely no idea and I was asking myself the same thing (but
> decided that I couldn't care less about a python gdb script).
> 
> This code was added in February:
> 
> commit 55f8b4518d14b7436f70defe27faba4eca0cd4e1
> Author: Seongjun Hong <hsj0512@snu.ac.kr>
> Date:   Mon Feb 2 12:42:41 2026 +0900
> 
>     scripts/gdb: implement x86_page_ops in mm.py
> 
>     Implement all member functions of x86_page_ops strictly following the
>     logic of aarch64_page_ops.
> 
>     This includes full support for SPARSEMEM and standard page translation
>     functions.
> 
>     This fixes compatibility with 'lx-' commands on x86_64, preventing
>     AttributeErrors when using lx-pfn_to_page and others.
> 
> @Seongjun, why are these conditional and the others not? Trying to support older
> kernels?

No. TBH I didn't look at the gdb script carefully at that time and just 
wanted to avoid a symbol lookup failure. 

It would be better if we remove the try statement.

Thanks! :)

--
Best regards,
Seongjun Hong

