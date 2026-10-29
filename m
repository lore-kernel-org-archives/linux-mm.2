Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B03560A2614
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DTKijxHL
Received: by kanga.kvack.org (Postfix)
	id 60E586B05B1; Thu, 29 Oct 2026 16:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF706B05BA; Thu, 29 Oct 2026 16:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487646B05BB; Thu, 29 Oct 2026 16:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06FAB6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:53:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 307301204DF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:53:49 +0000 (UTC)
X-FDA: 85376865378.10.468C142
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4A30C20009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:53:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DTKijxHL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793307227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9X2/iX/Lqo173Vwu0EOcoEv3bNJRFgizimBaD4S5Pk=;
	b=4rva9B/SRc9Ev8j8/OIV0tuve3/Bg/xMz6DeZTpE41P/W5IOkoZ9hROcte01RQYWvXWmgp
	gygFGoAIK8sBNtQRdLHhB+ZbLADcKj7ZMziBD0Jkeeh/9xICNtbyV4UH/rBZkmdcR3W82v
	4qqZmWMlz2J+F6oEZIk/g2Dr112wd3M=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DTKijxHL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793307227;
	b=wQ8kZRQUI5c1YWWp2qjdZ00w8FFPHlt21EQZfa/3lHzBKrGsjQ0dO2xeon3uiMZTzXxr0C
	iwtv4qWhOFcpDNBadEHqNTpPOkSbDLNaJtBH6mnitaroenobO2TFjATB+95JensHqrRerh
	wyvpL4opYOVX5oxcuwYUMuDhE1iNygg=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-15943c9c005so2235565c88.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:53:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793307226; cv=none;
        d=google.com; s=arc-20260327;
        b=CRUFAhKBI6lNMkroFRJTEwmyIEZIaTkLFSAOdtkcT4PjfZ9YlWQXsPW3N6J8tfrsu2
         p9I/e1aG1JTVBriR1iMPExtTpxnCdzr7YP4VeXE+iGeuNMmOhuN33MV5bTNLdPM2H3F1
         OcanRMgdIZUkDb58IIqhljupsZVXFClaQaNsu4fSwjVSY4iCol+NRyymS/dOakm2Ty23
         nJfZCbyY5JNdEiQ8r4GdZ/hMF5hWZ9nCO6OtYmBhYpe05oA+gex4//2MVcHRqt3kpYVn
         Z5NUzkEdP0p3+uvac/4Fn2n6XuxlIPfyXlKrgsjQ4BkIm0AY7IveR1dxplCJwiRvR1Uv
         5IQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=+9X2/iX/Lqo173Vwu0EOcoEv3bNJRFgizimBaD4S5Pk=;
        fh=tkhQ6UztH0IBbRBUZ7gmKW14+O7g4m2ZM/sDLFo9Jg4=;
        b=ASosUfvgX83FM5PaG8oYNTuQuuK9Cg8leViDPjWw/oHq2C52OIuJm4Qw8S0JByrpHf
         xbFtsNWE0+OXVsRlz6GYai+I73lbpN+nozRys5XsbbGt9RFo69xcBYIXzUYxCZOclhpT
         Mnj6NOw9Ub+XtxMNDKfM3Rdk6EgfmtCnb9mv7c1r8kQTHbieQpACbnOQz9kFrP0pCjPl
         nIRXEN3ky52r2yTTMw6r9uA9sCYhQ0NDoVcxX1GvUjmKRWn3QCghQ3eX/2BR8pYQ2D9N
         YkXkExVwBe5jHheWpHmBS2xQopOO7eie9ZNPlf51wff9dvNJrVz99Ism2QSokf2NTGVE
         5xhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793307226; x=1793912026; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+9X2/iX/Lqo173Vwu0EOcoEv3bNJRFgizimBaD4S5Pk=;
        b=DTKijxHLD9KyLF4rQ8bAN9R5Dvmxx8yOxc0bA8D31PETWj72/oWwQHnSi6uqWZzHu/
         8LB6vXMZmYFjAb19IvfEkWdxJfz43k/d0e5ik3ykQ/Em0yDMrxj1wtSNvKsPab+SnXdF
         i5U0nhW7IyI7q44tSTt7p1RGJE4TAsa6Q8PAHqAKvVl230kgpGER7B5FIFeQbine3JBK
         K9SyR0dmmh4SWehqGTIOfFSicVsuAJIP/iOJKmOydMviDd9eKh5CUOwni46eZtct6ohn
         wvrRiCS6LIkRNDfeS3xALZvQG76X8Qi3HUa/BZC08Dp4qM81+y84e01mM6i6hwaRYYMJ
         oR2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793307226; x=1793912026;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+9X2/iX/Lqo173Vwu0EOcoEv3bNJRFgizimBaD4S5Pk=;
        b=cMfO9zcpGGRYLmg83CoSG659Cy5prfb3zZCWG90s1jBT7+gQ8EhTfIhVnilLEGpfbd
         UGdw21c7EfVncR3xc3RuB8ei12jW5Z0eZ01hGsmaBORcPbsSb+flctlQvJagVccI9vP1
         QLADLvGQMcZpoiRXHe+kzociL8ZC02sWjxd9EG2G49SaYsFO/UslEUMD+6LnGrTAzbg/
         yZfJ22U5wiIhiowOjs4ATU88nU3sRjb6fLpZK9r6s5DE8iy7Y4hjhv9Mz+/uCp8BRB+D
         FWwjiiob7t6BvlDMuofDFtM65jeO/qXsSkDtwG0JvjiqPbuMwbjdQtocQ7Kr1hVNtq2O
         ZbsQ==
X-Gm-Message-State: AFq9FYL1dikmwnU7Ex7hHCJwUh0mldTQbRkDcwVsC8vrWDjbwPWuArhy
	KWCNxm6qc/h8DuzKYEjhkandOcPe3hrg4qxoh14KHSRxVROXC1B0GSbDLrsgz4JDBALEPbHmNRH
	aI6557V3PUg+HqCvF82uy1oe1MNUQVvhi8akT87J1
X-Gm-Gg: AYBFou0nU6N/q41BUyXX2Y+mnWJG3MJw5px3hIfAXV4w4xk4SYUvFx+GgIm1Oqnhba4
	Dy8/KC3ExrECM+KKEj84v3Dn+qfyv2/72YG6RFhtOo5tbOHELNxixwXxUJxPb+b8rynf107tmuN
	s0qcMwtlzPF4km92cv32xGrl6556idBovKnVpgPsvsqcFMHmgly4Tf4/UqWX9FvawBVvXY+Pnnu
	PhKMF8PPCyGp9/vG2NUNkY/631jIj4J+F86mxjLKkhOu7dweNzru8A50OKiaiOg2leWijoWeoEb
	RyHUdFPh4+105UmN+nTGAxWHIsEhwZmIStqX2xSZuB7oNf7bXwIoq2ZcSBGZLMoiIdfr/oulS/n
	YbjHNrhpfSGU+qBGCUDVApFzRFjpnwQGC0m2jqynIaFdznW5Hwd5gfHOQojk0xCp1fHgDWpIbGw
	sERZi2chhWWtJb3b0O53iJfMM=
X-Received: by 2002:a05:7022:2522:b0:1a9:c9fe:12c7 with SMTP id
 a92af1059eb24-1ac5bbb4b85mr358477c88.9.1793307224406; Thu, 29 Oct 2026
 13:53:44 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 29 Oct 2026 13:53:43 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261028-fixes_hugetlb-v1-1-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org> <20261028-fixes_hugetlb-v1-1-a0a033db180f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 29 Oct 2026 13:53:42 -0700
X-Gm-Features: AclHuK_vfygndkmig7dtJT75402KjRWCrBeo-qQvow0jlIneeAJCjzWqgPCqOeQ
Message-ID: <CAEvNRgEY1uNs7F+ZPpcbx4Tgg=9r+f6nYpPsnm7em0+2YMq6cQ@mail.gmail.com>
Subject: Re: [PATCH 01/15] hugetlbfs: fix integer overflow in fallocate()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
	Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Peter Xu <peterx@redhat.com>, Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-s390@vger.kernel.org, luojiajun <luojiajun3@huawei.com>, 
	Josef Bacik <josef@toxicpanda.com>, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A30C20009
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: gxcs9zfuch17qo785xgjft5pq1hmebfi
X-HE-Tag: 1793307227-104234
X-HE-Meta: U2FsdGVkX1+EAr5xDx00cE5CUxsJSBR3jwVpv/l+cVPlrfr/+NQW2WqiJHhbPBClKeaefAs/kC/yNVKAXbaYP2W/xSwi7dzYBZ/K0rmc1PwmEmezw3bTRrD3oNKjsCv2im7He97c3CtN2YItrqnzI+3r8U7OR0v4W9DfyiVCAq0ANzQTNRjaIfarZdpw04O4AIzGZ6I73VUcPPuJ2+VX7A0z730P5Ha44LW2t4uQOF8Ys3++wSV87ljky6tP9LI63uWCla9jJFRtmeP4+V3NX9phWrLwRnLSw/BDr0AQMuqZxFKKz/nf6nC0dEVPveccRxOgkuWNqM8aOZGMJphp1IEXDqQI3HWadA7L33xo2yekgfwTRgfU7/nF4bzVM7bhOWgDNp24W9J7N4tOrzsoV1vH8o9sGALsrFWCdkfV/m7QdHmauUkNo67l3V9r+zOYmWsUCmNL67iUilX8+AyxHviMV+V8lk5XkbwOJrCfEgPmNFEkU5pYyQ0za5mH/YlGtf9YcQDXVZhgCKMqQ3C2KcZGAHmP6MOdAwt4GCqPeiXxQo8/OgK7soaGyQGc+VvrAEVnHk6zjvrCvGjV7qaHhIwCB2OXxtKNPPHROly6URskymAOMk9BXDPKYuEwIXNZjCy7FdfwUlVlbHJQkBgryaNmxc8QdBTkOxWxCrSkzdZToywRlejJlgTKLeoue+SnOCVizSbvzctHguH4pIkwg+ejKXpyCHSd5OCmXFIpTDjJmZxi3oDxwZS3mmc4WO5HD7mEFr8Ax/W9AvpyhRwKwlg5WipKSlDPyWBCAvj7xS+sgWsrxIvxSxa5toZjjw3n8dW+GpC46dK5PVr79hO99UJFc8WZxRrh/k/Kdy6jl7Xf5rF3mQMw9maIazm4RZpMoVz5dhBk+fX434ytorWySrRJy7Z2WjSk1YIZcnNjfCMyi7fCmjO0xSPQWCKVC4+avvVGCO20eA0nTGQ7OIj
 S/jcScBG
 nz28Eqq2VTM7n0A+Tl/OGYEAlvO0P6nL3CTQuOeEzCtoaaje5Ruv1O0KA8nVI80nadO7iQt4VncdnPrywvuyniw0HeMQNRHkyLG7roP1fLB63pAAg6wTGEctjasKyNFz3PX6SYCpwimc21tnsqDgked6iiggX0fqFpo3T2Y2VHzoLsrKd5JcWXhI6euaB3CBNSVAfDjmw518snajDPDD0j4WdNGE2YD9pV55vfIRRWi98k44yRuQ3jw1NgtjPvF9v7+ElfbRu6bfNVc6o6wsEveIobyAth16xZrDBLQUp51vIikSf62hxShuukvkpfGuwRLMf8ymSLPJtdty+Xe7sg/xQEriCfPdpqlvPnVr/NCMmMETdvWGCPaLgAgsuLhqx7k5+orVrE3JNGqa+paivHoLTrrcnABY0UbH3bZhl1unPRyn4PS6Rh1y8Z0HI6qMtOHufkudOhTYkayFrXSv7k4fCsrEZPPMYWIzktn7yYcim5+T5nxMMV9rCuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> hugetlbfs_fallocate() rounds the range end up by adding hpage_size - 1
> to offset + len. vfs_fallocate()'s existing overflow check only makes
> sure that offset + len does not overflow.
>
> Once we overflow for valid endpoints near LLONG_MAX, we can get a
> negative temporary result that is then converted to a very large
> huge page index.
>
> A one-byte allocation ending at LLONG_MAX can therefore consume all
> available huge pages. Pages added beyond LLONG_MAX are skipped during
> inode eviction, leaking them and triggering the BUG_ON() in clear_inode().
>
> To fix it, calculate the end index in a simpler way that cannot
> overflow. This also fixes the signed overflow reported by luojiajun in
> 2019.
>
> Backporting notes: without commit a08c7193e4f18 ("mm/filemap: remove
> hugetlb special casing in filemap.c"), remove_inode_hugepages() must
> include the final huge page during truncate and eviction.
>
> Reported-by: luojiajun <luojiajun3@huawei.com>
> Closes: https://lore.kernel.org/all/1554775226-67213-1-git-send-email-luojiajun3@huawei.com/
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Fixes: 70c3547e36f5 ("hugetlbfs: add hugetlbfs_fallocate()")
> Cc: stable@kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  fs/hugetlbfs/inode.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 01c4d6f44ebe..5592cfc6cc8b 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -721,11 +721,13 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>
>  	/*
>  	 * Default preallocate case.
> -	 * For this range, start is rounded down and end is rounded up
> -	 * as well as being converted to page offsets.
> +	 * vfs_fallocate() guarantees that offset + len is positive and does
> +	 * not overflow. Avoid overflows when calculating the end huge page
> +	 * index: set it to one past the index of the huge page containing the
> +	 * last byte.
>  	 */
>  	start = offset >> hpage_shift;
> -	end = (offset + len + hpage_size - 1) >> hpage_shift;
> +	end = ((offset + len - 1) >> hpage_shift) + 1;

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

>
>  	inode_lock(inode);
>
>
> --
> 2.43.0

