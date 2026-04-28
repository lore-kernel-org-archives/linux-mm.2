Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 752D4FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 12:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906A46B0088; Tue, 28 Apr 2026 08:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5076B008A; Tue, 28 Apr 2026 08:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3A76B008C; Tue, 28 Apr 2026 08:04:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0216B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:04:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1731340105
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:04:50 +0000 (UTC)
X-FDA: 84707833140.05.02259E8
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0E38E100014
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:04:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dGeQjQdj;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777377888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8ao8CvWAerDIeNFQGwuEph7L8QgC5GvfoBjZJNskVw=;
	b=CX5ik/FJ9/N1tyf7U6hpcVmCMLNPMFcAqADIXi8OQvBzQ3wRhcaob1pogz3xnitm+jZuUQ
	pJQ26Hn0xJlTxmPyKY+kZd3ne/dD+Cx2drOZZNK64BLQvTwVlAF/wlo0SNYRlWJJTV2P3M
	xU3ZICemiBPEHSyVEzL4IQWj8JpHSzs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dGeQjQdj;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777377888; a=rsa-sha256;
	cv=none;
	b=4qIZ5b21bUYFoiy8SrIGN85lKCSYMHfpsNbf2wdFflcS9EFiff9o46nxTu4u6Y2qQ1sH1H
	BbATBwvvOB4ly445RF8cvgI731AglUeK+u72D21MdsMQa9HyVnUn62Zv2H8o6sSl81GGf6
	xYbm5dBsXIaRIQ5Uf0x1Q+MQ7qsGTsU=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5a3d1561e38so9315815e87.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777377886; x=1777982686; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C8ao8CvWAerDIeNFQGwuEph7L8QgC5GvfoBjZJNskVw=;
        b=dGeQjQdjQ+x0CHPqOrnJ9MFB8OVCoKVCITb8q54zHMa1xIKVJIzeurI2XVAEOFC9Zg
         6/UoteuXGnJXJivJaCQknFSgX98MPAODq6DmO8bXQmI9nVpfsuE5O95n9tQ+WkNH3YJq
         9Q21SiqDgLWRGsIAedmgeL3nRZ2vDaS40S3cVXAAaYj5uI8G/19BAnAALhpilk/oDqOf
         vZvdQK7uNgE4DS/3GfWfaIMksvQQbgOIs29I5cRwqItVFy9eGGY+JL4b3aH/POSib+B0
         mCIOhubFZN5fbEbq1wDSPrTKk/CQSNtq/LPdC/GT2ZZNwc/x30vN02q7hW1KWefyiUA3
         vMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777377886; x=1777982686;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C8ao8CvWAerDIeNFQGwuEph7L8QgC5GvfoBjZJNskVw=;
        b=OIOAGtx+AsOQVrL4g9ZgUuW5UzyJiSN9hO4l/ymNkL9iMGf7GcBB74CmIUtfoY3UwG
         H4D+0idyTlTLLzfbjNYP9gf0N4KTbyfZ+UqQ5TElFJdIhMryN/TIUv5LE8YLAG5MuKAN
         ZSSllLziy9XfLLx6e81g7EUpMeP6EbBEDfDF8/axHy105MsIDZQpmS4vbyM5X6x0mxBn
         P39GMbGlb218A3K0dHj2vtq56j9l1W7RdAfzHfy965w2wbFW6CvpRWbLrhkx7gJMdMLC
         RTd/DEsRUTvXT6UlQBHID9dH24eO+bqh9x+1oHSlz6Hwk4WBemUuZead40RNu0e12YrF
         o0Rg==
X-Forwarded-Encrypted: i=1; AFNElJ//f6uNfEcq7SvJ85cXRU9P9ehxZeQoquJhNrKNTRIpddnCp1asXO04q4S+wsiQhmltnG1y0wuTjw==@kvack.org
X-Gm-Message-State: AOJu0YwF4MC62wpf2QDbDiPQX0uw9gexLKQZFhFb329iZSToH9HaDU6o
	yQlmwA5o9H1BhwT9P9sPxEtU5RBkQwepzc/32kfXe0Cb4IQxtNRYpH1a
X-Gm-Gg: AeBDietZPg5NDeOmAp0ok36NPsE22PWRi1kiml5Nq7aeVth/5tZSwOikD/dvJpNLNju
	Lm2PCZnDUHBInoA08wek+F83jeuDlxEPsI4MnhJ4WRe+P7UCQCqzhiKe1oxTuCeKj5m+VUBbMwz
	feEXWA7dExwac9cmVPcbWZhAULuK4Sabu+stiz3MPLnFJrosTWaVx7KrhjwKUDtq2hcCp5z7iIV
	ZHnv6oY82wwhxzriSZIWiC8tcLKLHrTwWGjuNQxCj7tctuoK8bmIixfjDh/KzNuBn/Kk1MEy1dp
	5NwpPvXsJwQPjrwxdzVAIRWBCkaDSC8pnCIRO65Q7s6EgDQlwoWUXOjTL6+sNgpXD4KyyK+HGMK
	h75evRn5lJh4VxjN+O33oIgNIo1p4Xq458ZB0Kwt/WZX2a1d68c0wkNSW+QMQV7C1Vb/ZqpdDN0
	2DgqoFsrO9ZA==
X-Received: by 2002:a05:6512:2256:b0:5a4:1a2:1d39 with SMTP id 2adb3069b0e04-5a7464108a0mr1125592e87.6.1777377885750;
        Tue, 28 Apr 2026 05:04:45 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a7463f5e38sm572663e87.52.2026.04.28.05.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 05:04:45 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 28 Apr 2026 14:04:43 +0200
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@suse.com>,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	Thomas Graf <tgraf@suug.ch>, oe-lkp@lists.linux.dev, lkp@intel.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [linus:master] [mm] c6307674ed:
 BUG:sleeping_function_called_from_invalid_context_at_mm/vmalloc.c
Message-ID: <afCiWw1Wb9zDBdOV@milan>
References: <aehdcxC14ycvY481@gondor.apana.org.au>
 <aeh2Ii9CxtgfsX_p@milan>
 <aeh_2WwIb8nAIcy2@gondor.apana.org.au>
 <aeiHkG7X_dieMdw5@milan>
 <aemTW8yiAe6y1tsQ@gondor.apana.org.au>
 <4e269fb1-cd6c-46ca-ac2a-168ce9fd06fe@suse.com>
 <ae9wFZp7dS8QF8br@milan>
 <6cae0418-eabe-4864-b87f-b1f953de06b0@suse.com>
 <ae-MdIOcSkfphbHM@milan>
 <afANly2Br1kIBPOs@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afANly2Br1kIBPOs@gondor.apana.org.au>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0E38E100014
X-Stat-Signature: yadstpdftzp8p6ywhx4bmrbnozymsepj
X-HE-Tag: 1777377887-697837
X-HE-Meta: U2FsdGVkX1/454fvzeWGCmHbdQWIRHJZ9FHM67930shfLllERlnkxyeyBdvncKn4Y7E0JQyF4Z+8LRxqa+wLL2lkq4UbBgGrVN4mHUZ1mmENlYPAKj3jfVQ98RyrZH1Nbji7gm1O4dL48J7MjJZUUSseP//kP9mODl4KcAGouZzWR/31uq/c5aIYnLEioUyvsv1MNHqyVNPZloH+J4nNoPoVfnreffPwwFyXI0wMmvdiEQ+0uTmi3YwBEqeeXteBRzD9CDMPhjWqpD6sJLdolbssHDgnRyMRKLwI7c92iMqquXeWRpGi304OOfLj/Q2B9gZwWRxqJUEPFI2ZwMaOMhdRoYwYO/oT2U/xCiQwuySmHs2yz3GXuFo4lejdCGu0e36GUyjun2M1puHVT37KUQP3U291FfL0SuZfWTVOfKUQcyb7OX/vdvPHmJzY0bYY0o9opM0vdW17kPoHm2e86tVBEf3XApi5lY6v57vEdn2yn/ERsQgPcjV2J1LopWpjVTbeaQiRzxthWVyH7RFYHjXtMgJ1xsFJooUrze0ZqhnbA0w1w8ht33F4KhqM5E1lqFMA5qwcPamGCQY+QWdzY/roUW9HDXSUV75/9701LStW2sFJrH7GnWogu9pzWqPBOZRa3jdsq6Dp0hfShYOUiy5eMvPhUJaigIlbT0qS6MsnkmHdCKGiqhnuOCybCp5ZUOUvPsw2npffH+qH7ysySe3HtNcGqx90kKYRGVyt9ZNJwPRU1QRTEwjq9FIUjEOgueuxIa64q2aS7OMSYSt12jemlrGk4vvB9Jy2de33oWymw1aNppS9FboXoYpgDuMfB+MrKZxoDupBjftAbN7XnOg28r5+6V0Dpb71ax93phV3/NOG+PdwUUJaAa7jIulQg2hw8kfV2cENt+gnGmoIro1dB32dSy75kIfrgHKmrfnxLJz4lpTCQfATet7G5I/rqr9m08w0jfOCzDCtZ1H
 ae2xETsj
 fbblzDaMoEWZmkUrexA7bxxq9n1XJ2rD7zJsZM9UWEgYYlfPxnKehZErikRzAYtfjl55xHkYSdhcFQggKqbwtOGh71/rOTDbKV43CLFiFb5FjWMnDTPHs5eGrE5N0Us6jy7Jbiw6Ri3HOgfkWVFqOZEyiKkqAtjtRpLy4AtqqOoxQS2gm+TVuuGQTOMx5ratHWkcQsvziDAYiiGrFy1Q0meJFrAvONY/CFcu1q6Nun7hMej8Df4TwTuEUO8eg6ez2nGnMuWoLfNfUFsHyIJLuDQtK46qcDgbV/CiKhfDOUEbrVkq5ipjb1BU/1aFyN2Lw7Yab/6F7pRB8H1rffJGQqruf/B8G0SAjO2uOlhVsnPPISQK5ty/9ItM0obE4D1yNCJMXWkplOz0R3jQo4LaqlaQh55MfP+Bg8M9c3D+dCKR8mSTOKTgpdF+1veVYvWv8StWbKNgM54H8/XzLmX/BnIHg7bxYFYvLfgZE1meXIRpbrg2V5hkoDrRM8qQC+9333s6WGLOUX5SdKEqE7QUHVx7cDd7rixLkPvuZE8F3V92YylFq2WNhzPdrmv0a6qlIWZlOnJ3udRZ3BIw60Nu3TiuTKha7pG/ltgxjoXf6Q6VqqujUc+7x9ea25+kIp1TAZaDD29ZUyO4RRaHeVAzu3o+lOhkrvNkSETQXvyDCbc4FHNTBE9BOUi371XNCfTo7IVBZwI6hgtd6J2XfQmF+JOsClx/Ok/Lt/2ajranNelC1Myg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 09:29:59AM +0800, Herbert Xu wrote:
> On Mon, Apr 27, 2026 at 06:19:00PM +0200, Uladzislau Rezki wrote:
> >
> > Like below:
> > 
> > rhashtable_try_insert()
> >   rhashtable_insert_rehash()
> >     bucket_table_free_atomic(new_tbl);
> > 
> > the patch for rhashtable.c can look like:
> > 
> > <snip>
> 
> If you want to send that as a submission you can add my ack:
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Alternatively, could you send both patches to linux-crypto and
> I can push them through my tree.
> 
I will send out to the linux-crypto mailing list.

--
Uladzislau Rezki

