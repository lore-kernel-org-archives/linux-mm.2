Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32021CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 20:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CEB28E001A; Wed, 10 Sep 2025 16:49:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87FF18E000D; Wed, 10 Sep 2025 16:49:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795158E001A; Wed, 10 Sep 2025 16:49:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68E4C8E000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:49:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B9811DD5D9
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:49:12 +0000 (UTC)
X-FDA: 83874530544.09.88CC257
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3CE51C0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:49:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="HPy6N0i/";
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757537350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KdKNnUqR+FthWHSkVdu+kDWg2jegsxHUPzCEEZJSG9Y=;
	b=BJIZYIK7eT3H+jwV72PbFLmf6dQs5ZDnnAqzn/EoQq1300eiBVD9N2kCph3KF3SXxIfAL2
	scGgX5FrgVY8hPV4GoWqVxAlOQDuMvLqQlCgqdCXBlqHyGhNJgdTELnocihug4uuPjnMJv
	Cqv54p6mUfWaFN03ITLMWHChvfWrGOg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757537350; a=rsa-sha256;
	cv=none;
	b=3JlJcVqwWCvVRbI4aQQjkePtnsqw0lTWjs2K+NorVexoSri3T+PrCI9BkyTAyCNa+VVrC4
	+vOXtwUI/MVCUwpIvJ/8ix3rpDAMU+JFksRynD4SfheNY/wKYnyack5vY+n6RKbnMD+JQ0
	cYap/yA9XgVWMXZGmkP7c0J/NJUdPKk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="HPy6N0i/";
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-80a59f06a4fso1069560285a.2
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757537349; x=1758142149; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KdKNnUqR+FthWHSkVdu+kDWg2jegsxHUPzCEEZJSG9Y=;
        b=HPy6N0i/1JRu/fAIXMJKTFvjkIT2PAL6jfi1wTGD/UjVJuXfklc9C0bFE21Bc8J5dn
         Szfqdcv13RuCXYMajox+W4IsIrnsx5EY92yKAIiuTFLYLlJMLaK6yLAS3X8tWgh1V9Cl
         fNAnek+tB3Tdi95pApTRss58r8vPO29ZZW3ioUnQwtJIOn1SWqzftUT+2TI8PSNoAiZ5
         wvOAQ3RViIlbA+PJST1mRYd2JJCRCpzAcr+GVxebuWcMsWp+6GDCZaae6I76c+ERLRLo
         rm25SfHUpmse/r51ww+SdhGtYySXQuhxpuncfS1kDO6UXAox1HtWNwb5VunDeMmzKNXf
         KCoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757537349; x=1758142149;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KdKNnUqR+FthWHSkVdu+kDWg2jegsxHUPzCEEZJSG9Y=;
        b=jUiKxma97THkTKAJ09bdNMkA3SrJgWFUK2n99aitZZZw2wTMX5DL478ky0quL+RN40
         PgLEKMXrQhJJ9K8r2A+4ap5MgjU31eyanJ44J3lJINAs8W/gs4xLbY1Xia7NL+7gkcfM
         ll2iinbLQozwMKGMTbPEzZaq3IZsnqGmPcVs5m7fw1KuIeEo9bGqnqcT5twv4F4M85pQ
         cXZyxY+qLXNSH/CpYE12zrN3YBpeKHbrIYFQGS4zboEO6Iw4zn1UOINXvf2cGIDUJ80r
         infjBDkkpsAunl+bd9I0LD8rXNtjcZm5IE44jfMUd9EbV20II+yHoRPXlSlVEADifDiJ
         ailg==
X-Forwarded-Encrypted: i=1; AJvYcCX7+QdSnL+ryomGiO4PWzKfqLYbDcGrva9ykvqLmr4RHZxhOLr9XQgNoEJs1LZpkpcvSH/d7HcK0A==@kvack.org
X-Gm-Message-State: AOJu0Yz9DW0ivxlE+qQOtwX5Y5xjBUR8krNYeqjMzxGZkYONBkSWCpmj
	DJUk+Fvgv08fRVc29BERxxE41VKcQ82RFXIHJdQFm6ECNlkrDUM0eL/g
X-Gm-Gg: ASbGncufhZ5mQJkO5bn4/+nUo3xFnWVts1fh+OYkwYRJUsFhlWaLlop6Aj8tpYGbzYl
	fZ+5tFnAdh316hdYNqBsJWjrOrucBdVTIlkXSVw3cMMXOMBcxZaqRU2orJ/TTzWyFqGvLhWOLA9
	UW5XRylMPdtWz1K9eIybKWHQLH4BUuaAAupMdK7gsRk6tOOXHS4NKqJLXBVHL56KMneDALkH+3z
	1ck8/VAtYynsr9I+rfL3T0l2GXaiasdk8n+10Rm0IsY9L4Rao0v+v7mfvpoosqHOdez/Nhc/sVo
	lz/CN8m8hBhbcz6bSUfd+CnMideX+Ukw1AjrNh4zhSJQ2J+UgphsutVFGzJPZ/WvIxdQZIFqJoV
	ifPzdWGOFW6fNkYnbcDn6TtKS8iDaaAYrQPUDnnMe
X-Google-Smtp-Source: AGHT+IF5t9CgVNGthj48BfL5VlbkBf29lx5nVEid2Z4AgsD1UqZumkmImiNnxSRYun/vml+FuDG4AA==
X-Received: by 2002:a05:620a:4385:b0:815:3483:21f6 with SMTP id af79cd13be357-8153483258fmr1982394485a.72.1757537349179;
        Wed, 10 Sep 2025 13:49:09 -0700 (PDT)
Received: from [172.20.7.106] ([63.116.149.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-81b5e5bfbd5sm353061285a.41.2025.09.10.13.49.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 13:49:08 -0700 (PDT)
Message-ID: <c2efc885-8b23-4ef9-8eca-05f17e158fb3@gmail.com>
Date: Wed, 10 Sep 2025 16:49:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] alloc_tag: use release_pages() in the cleanup path
Content-Language: en-GB
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 shakeel.butt@linux.dev, 00107082@163.com, pasha.tatashin@soleen.com,
 souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250909233409.1013367-1-surenb@google.com>
 <20250909233409.1013367-2-surenb@google.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250909233409.1013367-2-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3CE51C0006
X-Stat-Signature: 1pji4b1g8qcm1p1aouphda8mu1skw63r
X-Rspam-User: 
X-HE-Tag: 1757537350-314712
X-HE-Meta: U2FsdGVkX19UoQtsB6HUo7xawrUOnsAkNk/fi+i4MgQSOlHy1UEwa26CwMl/SfpCHhFWC9l7hDrCwZwIPcWvmJMwm5aQSwbAWhfwNcZabjRyECXzzezRMg1oPc3JXX7Aoj+qZGNI9dOWfgGGDrkdcxleTSHaYHoqyh5JPtFeGkjkfxzucnNsfc/NvmP2BinOCFbjFt9hNfZcQx0oak/X5rlbJQoYbpNuuZRz49M0HVMcdqODYFfV5d8igRjFe0wzB0elV1ONGREFf1ua4y6ntxj9xWZpaSA6BqKedE8WtW2F40WrOkhVGywR4kFleRwkcLZaz1UDfo7sMfsVqxJrIP6y2g1f8smgJKkWSV47T/mI8OYQ4FZxvX0KjJpxU5U0+sKOaYQQoBtXz79rLtVILSAJPAhI4VRkFGoSc9z62eZmmLI7v5/TdEfL89RiintNuT5IFPEP36tVbs7LN9Ad/yVFrTNITlSQYE00Lr8Pt19LSrvPnc2ch404YVvaFEnwMFCB5zAAZASF9AhVr62nzGablUbaA6b1VG0UJMXiHHG04iBffP3624M0nMVNlWN9Lkkgi/oCYNpnDa3jCSv35ivRSCdoLWOfKnUYedU1vgz7ArrgFWbe1v+t0yy5gO9XW9wWRlbsNqpMub/tiwCLbaanZJ5BB9RYIRLsmnV0FYj4WzevmoIt5TMuCCXJ4sGIZ0eh1HZzaSel8+5EJedwiTbdTBiv0KfAxImFQfY0H4fgR2kjqn/4lvcWtrGYIGksSJ3qbqXr7DWoKnedLZNaN5takOpimyBhiFKYFCJBo55i0BWJCmSLfsz4a4QByFo8AgEr96mlXODkesyf2d/LYtoTDsrdTxuiPI+MxIMAFePVX1Ob9xdhaC0ukOodJmWJStXPTRi+QHwJl+P500hbxFr2aJ6mODBPRz+zsdoLUbL8/u2A+nzdhkciR4wQ/ANkXIBvIgl/KcykBfErKYD
 uSi9Ghur
 kSqNh0jJ1si9qG3YdKmANgREsx/mQzNQ0y4f2LMKwFqxi7yvhRkuW6isSBmuWcJKUQy+aukti+TBJjPZmP4v0p7j/SC4EUcAhvC82hDqIFQlp4DC0UIKpITRMN7K9su6whZ/LBC2GF2D+UGL8/rTJHEPX6Ukh3tlEraPFg1pEAkkV2gmUX5ZwSHyUX0UO/fwgmUXj6fpwBF9Gw7PwXhnHqGfiJAVyJ98pxWljm7bYQmLQioW887XYJG6IaizMvuAOHedIRnyVWuMErOhF9gZRVH7JCtBD3Id8snQkBVEFAc++efyn6nQnjYRMsc8gScP2iUQMrykEGTO2byKfcCBIm4EPtKV1JJ7JAWEixWtGtMy2Fi0YonY9+zIR5niNz/rSM7X6LYAErPBsuct00IxER8d6jwAM6J+jstACQsBZegC6299gK3FrrP/qaXMcoOQ9ka0ehLp4CwT/0Rbflz7AZATtsmJDvLkFvAIQcFUsLHKgnryoo+9Cufk2aebHt5OOR2FLqD81jWRQlbWBX0KqnXe7lcagLsFwjjovZs4OHIbneoTmYPsBRvahj8n971+tYtTIXChuLUW1byAkriOSvwGdOpCdcn4Sgg1qAHABDDmy+V8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/09/2025 00:34, Suren Baghdasaryan wrote:
> When bulk-freeing an array of pages use release_pages() instead of freeing
> them page-by-page:
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  lib/alloc_tag.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 

Acked-by: Usama Arif <usamaarif642@gmail.com>

> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index e9b33848700a..95688c4cba7a 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -438,9 +438,10 @@ static int vm_module_tags_populate(void)
>  		if (nr < more_pages ||
>  		    vmap_pages_range(phys_end, phys_end + (nr << PAGE_SHIFT), PAGE_KERNEL,
>  				     next_page, PAGE_SHIFT) < 0) {
> +			release_pages_arg arg = { .pages = next_page };
> +
>  			/* Clean up and error out */
> -			for (int i = 0; i < nr; i++)
> -				__free_page(next_page[i]);
> +			release_pages(arg, nr);
>  			return -ENOMEM;
>  		}
>  

Maybe this can be done in free_mod_tags_mem as well?

