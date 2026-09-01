Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44F7CC61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 02:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41806B0095; Mon, 31 Aug 2026 22:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E196E6B0096; Mon, 31 Aug 2026 22:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D578B6B0098; Mon, 31 Aug 2026 22:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B611C6B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:18:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BD66C02B3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:18:11 +0000 (UTC)
X-FDA: 85163583582.20.CB32EB2
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5A1D01C0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:18:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788229089;
	b=i0zryY0pdaJjmD6B5nDCd+iOSba7WQ8XtTGscawSDR5oh0O7eg4sbpoVd02ESOYESp84wZ
	KEg+Lvz/ICRejzeKY53euHTDue7nkYOawsITN1CiZjgoy+FzujY+fDosFBiCla9FfJMJ+a
	0wHtsiHPzJWnnWz7HJE8Kv7jCWI5FIs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788229089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jbfAJUaQ5g2QociN/kQcU2RWxpr2ei6+3CfE6ZVXnIw=;
	b=f9OHSQV6gNGVVGa/lfrG8NdabGJMWowu3quDh10R+Xqn7tWPJS1d+nklPM8y9p/VsGC1wS
	ZD8573H7ZVUg+r1AnvngX4XqxWFMblwUawo77ooEoPfAeE14yBWXF40Sq6FLdkK/waLI0E
	Ce/CPKkUhbiKHEVZ2gDlAMy2n0+MOaA=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hYqHy6yYyzYQtnZ
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:17:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A15DC40574
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:17:57 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgAnDgnTNZZqkvQ9AQ--.49297S3;
	Tue, 01 Sep 2026 10:17:57 +0800 (CST)
Message-ID: <70d1f9a7-362a-4152-b323-58ae010ebbf6@huaweicloud.com>
Date: Tue, 1 Sep 2026 10:17:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] ext4: Remove uses of FGP_NOFS
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Theodore Tso <tytso@mit.edu>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Hyunchul Lee <hyc.lee@gmail.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, ntfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-3-willy@infradead.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260830041901.2668-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgAnDgnTNZZqkvQ9AQ--.49297S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tFyDXFy5WFy3AryrCFy7trb_yoW8Gw4Upw
	s5C3WUGrW8Za40kFW7uw17t345Wa48GayUCF1xKwnxCF90g3ZrKr4Yk3W2qryUtrW8Z3yx
	XF4jkrW8W3W3trDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
	WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jIksgUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5A1D01C0007
X-Stat-Signature: 7d8cjrkguh5oect9nw4wxm7zj17ignkz
X-Rspam-User: 
X-HE-Tag: 1788229087-513016
X-HE-Meta: U2FsdGVkX1+mhIaQ+MoNXKnxnHOClbt9cNos9daeTbGHOWmBM42+0VEJ2BHr0L3FVqmQ/NiKE1Rl30eCDND5rYpfeXQQbIB1FcficVYN4i1ityH3pBu+c2sL0GqHLictIpjXjpqEFZbDc0H1XA5jlFP8Mt087OTgPezEsOwnIfmkCR3TocdTObqyzeqqYI5Az0+Iq50FhKXy+3hbVRKG/6aU/AFPIGpmffZeJbEjOEqGT3rlvCHm1kkKaarSawKQr9FGMcvzz56cJubbSMTI8Xu3uyQCpWA+A9B+24P3mCSW0A3qX/W1bxpY26ea4o9pI9JQsCjT9qYGs0QkK8leXJzOPHAQcX4O0VTNsMzV9A/w47dXe7fuiWIDMCqrEsguIq4U04hc6eontBvTviK4WZvJLhvX/FxOjrxkPTyEufiV0KHrZqkmm0a4IjMCMk3GEpdFyj2qPjbE2Nwn0Ozd03QKoGi3XQnUXml+jXTAUtwc+/xC7yFcdYjPBOgXcBVzhHAUV03sN+rSFcrwnMF28XLaUMjYEqo+OrWbOMgMeOEO3vRTtLkSzye3OOlWonQ9yjoGNXb6eZ18jOkmIevpS2byttUAIwFtWSwTWeuW1y9oSTMRt/+HtRkr+U0QiUeOAfMXyVZe03p3LYhFbegCG24R9Hxf0cV4mIBQDEe0dRi2TMbtrMzqBlVucKoCu3YJkxk7IrNubuPWQla1K6Ugyij2DLX+9/0o8ZozIGnx1Fb1foi5rgxhrphePkdevy3LkKZx6RBEp/eWsKmw+C/UQmLh8ADDRZDvIYP2ahYituNinu8DjttsfoWggiIEc/gYknOwJ/yRcC/UpKTBl6+hbtkGPBewTaS1MbAy80ptsxswazUSiM4IOqUNr7Gdlm3NRxV7qzQ3vEhgZQqaaDbxn3lTOqjL9lfzN9ArgEDMEvEje8JVkA8W2jat5OKduas35HdB0OISQOKjxtm7YkQ
 KC67vwwZ
 zDyrHnmbU7oq1OU9BOqGNocmWzm1kS121Oxa8TmDfFnH6o3Q2oSyOR1nWXdhWUZ342+JjmD74dRBhQfHhFHimPQwAbV5MJHJ6SQ51cA5PQV6YB39Ml44LKdBjkd1ANszSZvxZEPjZETbp/mkHJ/fkrXzeFfZRPP1BENbWqHAJW+/G2MGow2VPgfrpUhidtj4wFrG9uCXnJ1WJXukGmaeJHcsLRkJG1fgBkeJL7EH0AqNR2EeZSD4FqWzbEyJZUtxE4RokzoTN++085X0eWycJHyZoLZxkJJ6H6Mu1TJcTBcCUu1qBRYOFQZ0XDZ4tRYPfiWxI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/30/2026 12:18 PM, Matthew Wilcox (Oracle) wrote:
> Both of these locations are called while a transaction is in progress.
> Starting a transaction uses memalloc_nofs_save(), so we are already
> prevented from recursing into the filesystem and using GFP_NOFS was
> unnecessary.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/inline.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482..1884abb09614 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -601,9 +601,7 @@ static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
>  		goto out;
>  	}
>  
> -	/* We cannot recurse into the filesystem as the transaction is already
> -	 * started */
> -	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
> +	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
>  			mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio)) {
>  		ret = PTR_ERR(folio);
> @@ -734,7 +732,7 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
>  		goto out_release_bh;
>  	}
>  
> -	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
> +	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
>  					mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio)) {
>  		ret = PTR_ERR(folio);


