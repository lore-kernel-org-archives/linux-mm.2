Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AF53CCA471
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 02:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D683A8E0005; Fri,  3 Oct 2025 22:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3FA48E0002; Fri,  3 Oct 2025 22:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C488E0005; Fri,  3 Oct 2025 22:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5BA88E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 22:04:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 441B51A09D9
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:04:52 +0000 (UTC)
X-FDA: 83958788424.11.1C36620
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3FB1C18001B
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:04:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PeBi0c6U;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759543490;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1D7C9zfNsAR/zhcIDvXmSkVC80C03VQ0i27Aj45Yc+c=;
	b=SenShUlHVkakAGbv1qxNT18pbbwXpH7Hd5MVEhIA13X+jebrOISLYWKlTFfcINkoN8ebsj
	z5y4LCDIBQ8fyJhLhdWt8yw1v4SmHiW/oy8YBLF+ogJR6wmy4qcONwr/KCqo0ASMk1XjqQ
	THwSXgH1jqcLN+sqS3rqaXc/Ylbftmw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759543490; a=rsa-sha256;
	cv=none;
	b=KWLz6KNJjvt3woSRoiCWnrVBxvXwzP7Q7f+51c1olygAssga8GpPEGWnegvqWOSq9dmQd3
	xlfUo9K+YRqqBPfqjlNTPdoka1rYBIJU+1dW0+q1ntHLEURI3mI0bc7BFWvPVY0OycOzQ1
	AeVh+h5a9Lr8HctPIDfA77K+BPjpWW8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PeBi0c6U;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b457d93c155so544332066b.1
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 19:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759543488; x=1760148288; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1D7C9zfNsAR/zhcIDvXmSkVC80C03VQ0i27Aj45Yc+c=;
        b=PeBi0c6UPtCqvo/UhprfeouKi/q5JDfnrgZcfZcrpBaOOVz2VeWoZ7IfC/5RRz+pWK
         8PUYCXzVcS1GUnEpv9MOmF4r6gVz6IujrCSl1XZ6P5JX9nBx6fhPm0iKRkEB088R23Nz
         mQNwWEordV7rv34YT6b2PT15kiBfDz3x4WUYZT5yJPTFkuknmXUJ/sFZuac9X83roQ5W
         Mt+dugiZCDD1KrS2rGBp3vfbKu8GCzl6ai6TLY2SL3g3h3ppALYywDNJ6/CQJzkXwURO
         7X7wZsfi/z/ov5Iy/kFJ1wtSLbgowo8lzjE2H7Yw0QQHfCzUnMne4KF6G0RK0HS/P61X
         4nWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759543488; x=1760148288;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1D7C9zfNsAR/zhcIDvXmSkVC80C03VQ0i27Aj45Yc+c=;
        b=Ul4Ng/PW2Kpo7Ys8QrR5mkJjDMk3QBvh2VlVl+neRmM/1WKBi+9Fsyk+2tGcT7iG8N
         dsFiOQfX9kGHAFwpf9Q++8Hu1Ns3Voz3o9zTJvgW/t+ksC/PKiJQGB8vNQnTW580MjN0
         okkWwF5NXvuqPA5qzz9Wvj1lYWJDZI312bnEwS4t5o0aTE0IZxNKmd9Zm9dN+epUupPT
         Ne1wOsCO3VEUVlh6hgM9/VPjgx9n5qDHCoqffsycCsizQk6bnl3gb02w8CjGI2N42hw7
         pdbKnOomCnqoelVvUWYw21N8okKQgR6gV6Ni9fyynXMmK4zTiSKahZCYuzkEqdVKDeG8
         pLDg==
X-Forwarded-Encrypted: i=1; AJvYcCXeqx/7sXLLsmA3f8fYm14PNZQNaqulSMKwisUKG7p8xRFBv+5PHlIjSgfIcMmgz1wLJdWts/CJRg==@kvack.org
X-Gm-Message-State: AOJu0YyCaI36o2gDBjnwuCCPXAn7/oaC+dR4tup7KcOybpS79aFbsLUt
	b835iAC9uY8CLtajhGYAI6Nf116x1MVpl+JiTjxtMGSFhmXMUE5YYvJa
X-Gm-Gg: ASbGncuTP8r2yAAy2LdHTtkpSimIP+JrgL0LM/GWSzV9hXdYHEDou8kUjQA936FF6BF
	o56qlHWRJrumbCwn5OY3fJ5KiI9fuHHxv4WEF6Wd0uPhNpElcdwwfeEJ3S+SPxSZ98b1lAAg0ps
	F5RXRd/IR/MHO4QutJFt69cSLLXd+wZiPsmmCPW5jzyG/xLlzoMsdOAsrPh0opw3zapuWrboxMn
	IqDfQKPM/vsxvJ0KefSgskIWn+FVNxfhCzXx8ucjey7vhNAvQ2pYv8r4isHvWkrIuc/1Mqu/KPH
	r3hoK0ZiRyzgryd5KDpLs5LgEJ7nT7hqpgDwbuzMBJ/dvyMUBm29FIdyaZadjcARfuD8qJu4PFp
	WcT+DSB4qznGWwC7va3bLzyhE77DPJLOhAsCXSHyZ8NioMw==
X-Google-Smtp-Source: AGHT+IGdf6+OJ2c9+tXrX4oHWR5q+E8r/dTC8pl8N733c73y1ngTRj5iM5bJ0CancYL7rUU+jL2oLg==
X-Received: by 2002:a17:907:3f8f:b0:b3c:4ebc:85e6 with SMTP id a640c23a62f3a-b49c146e65dmr579667266b.10.1759543488268;
        Fri, 03 Oct 2025 19:04:48 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486970b32bsm588129566b.50.2025.10.03.19.04.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Oct 2025 19:04:47 -0700 (PDT)
Date: Sat, 4 Oct 2025 02:04:47 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, wangkefeng.wang@huawei.com,
	stable@vger.kernel.org, ziy@nvidia.com, ryan.roberts@arm.com,
	dev.jain@arm.com, npache@redhat.com, baohua@kernel.org,
	akpm@linux-foundation.org, david@redhat.com
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Message-ID: <20251004020447.slfiuvu5elidwosl@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
 <d8467e83-aa89-4f98-b035-210c966ef263@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8467e83-aa89-4f98-b035-210c966ef263@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: te66f7ronujtyep1n63r6btfkhpm774o
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FB1C18001B
X-Rspamd-Server: rspam10
X-HE-Tag: 1759543489-901891
X-HE-Meta: U2FsdGVkX1+Pkb4fg2p6tPQ/NWZ3vr2jQGWESpF7UIxLu8vv4A0FOFuABV7ND7n+C9neOSNf03EUfK1lQiJDMbwNunXK7dOPSMvSvxjA5nlkm4KpyGEx3nfFA1vEG7jjFcm+yhakDSJBnro14dphw8f7kZCqTy78erDmRQepUZiQDxieXeWe2O1+2DQlNS5RldIR4Ci5nJvjkE4avHcR0/qXkHeGK+v4HQS0YX8Eo9Pq700x2qcN6Fu+o1KCUh72aLJjXL8XeTUYtnlGn1yzMfUkSWC7K6ed0rD6CYxBdLyhyC5oq02acWCPomk9cNQS5oBHUFiG+U4lCDnwnYVx/VqjgenwpTkQHgIiLoRZAkc4Fx/KNqSlYA9VbltG977cRt7FK1Kv0VmmTHeQdsmJa08WyNqDhgDcklzApxk5aftKQHUVNNgY5N80Cwp1huw3d4Ma0Hkghuhki4Pf2wDEZt+F6ZqG7wPqQGFrr67+0NW13tFEBLMOxGF2BG61xeoo5ZWJ4IedjyM6TYCMmTcsW6plMXz9PVlMXUBsDONymqkdI5wz0PRgZl5NM7mzATbHX3NtaVcyeYuLGQAyFtz9jyxqq9U2q22uiFYGLKsbMfcnIlseQhAs4yUYKdXsT5/JY04iQ+iHd90uCUEFD/oQJru4/iD2KcMnyJbmZyb6DgCJsLn27D1LKpKbcxHwHzLidFDrm/kF1IbLPKhfbgoyRJ39Iuq7w/xRa2Dj8aShaQklGWg3qFggFjet5sq+3FOj1H9+nxQvBNGyERdCgzuVdHkryd0+r/WKQ0unPeuq/2Xh5DzZZH6TIKaUIM6cVIgfxFyBIIQVbC/u3nEt6GnuAeJDWf+ObIz4FNkr5E1leKPZVBS4d73jTS6FfsMDDKK9PF5b2tKspCiR0ruBz0AeCxtXNRjDLXDIpugQkX6gane4pgjg1upwRjdFvFqEL83dQV6xgiCk5O/zrERsMMn
 v3zrbnY8
 euVcgiykmBojA9H0S7CfOyNOW/kEZTIQ6rEjAmLVSrWloYie4aA1axeKzp3HjCiMj8elnpV6XuSrUIEmtVk1PNTluVxKaIJ32hPYsdIBpbyoSOv8qvmJdr0WJUfR5HXOjQ50ovZQSIxLNtWtcPuPvLZrylm/a13fVALQmoik4lDVY+DuIWhjLK9qfyBhSN/6f4ajtClrpNVJtBcmtRHbxxW0GGiAFkmoB3Yo/W3MKxlnHMiF6j9Y+owpO7zcnR82YRZbPRjJUDcaGvFR+Joe5ie6uWqB8TPkeimJpThFb7KO8olfc+/HHXd7kdXLhQX5n0YuRcK3wL7LzQcT3I7r0Hbspo4ekNj/7JZQay9BuTXFVvRBzIsMUowXSuGwWzS5HMABb4V8DiuAkDm0mlZNPqhWJ0q5Iz/KE8UgwAYQn3FIT5wSqup1xrcaDJSvxRtahl7SH2lYrJ4YZc2QPEkQfXNj37QYzwOtK47bLQ+yvHYQetH6rMHj8vXiYV0LnvDy/LsurxRQoyxR1TxaoBRccfVGktcoNByCCdYmSh65oW5jV/XsBVB+S0Miy8+WDWJnMMXn2ryMUXvhC6T6d3ajxIbl+Yoshvh96nvJMmAWIyBie1eNb8jJxhjxQBG0u6KCUNoIGFf7glvt3c3sFFb89R2DPETHfjr41Pnv+bQnJkZRT4huZGg6HVKlIXy+TvGpAMntit4bBnqVSaFQMs5oRzBJ5y6+ErnMzusnsd3QT3tDcvd9Ia6D3ddX+62skDoJh62mh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 09:49:28PM +0800, Lance Yang wrote:
>Hey Wei,
>
>On 2025/10/2 09:38, Wei Yang wrote:
>> We add pmd folio into ds_queue on the first page fault in
>> __do_huge_pmd_anonymous_page(), so that we can split it in case of
>> memory pressure. This should be the same for a pmd folio during wp
>> page fault.
>> 
>> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
>> to add it to ds_queue, which means system may not reclaim enough memory
>
>IIRC, it was commit dafff3f4c850 ("mm: split underused THPs") that
>started unconditionally adding all new anon THPs to _deferred_list :)
>

Thanks for taking a look.

While at this time do_huge_zero_wp_pmd() is not introduced, how it fix a
non-exist case? And how could it be backported? I am confused here.

>> in case of memory pressure even the pmd folio is under used.
>> 
>> Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
>> folio installation consistent.
>> 
>> Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
>
>Shouldn't this rather be the following?
>
>Fixes: dafff3f4c850 ("mm: split underused THPs")
>
>Thanks,
>Lance

-- 
Wei Yang
Help you, Help me

