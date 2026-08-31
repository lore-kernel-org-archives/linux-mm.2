Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78428C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 12:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5C96B008C; Mon, 31 Aug 2026 08:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CD826B0092; Mon, 31 Aug 2026 08:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5C26B0095; Mon, 31 Aug 2026 08:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FA826B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:32:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FA7FA09F1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:32:48 +0000 (UTC)
X-FDA: 85161503616.14.49B795F
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6C0D9180002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:32:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WmpDWcMe;
	spf=pass (imf16.hostedemail.com: domain of libaokun@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=libaokun@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788179567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7kMVnx2LblB7BHqjw+a56gGYnnF9uAQgrmNwvR5plE=;
	b=7fHuYSvIwXmAO0xRCmebcgbhlkNCB7Csfn5jaEpXMfMeo9Ay8WTs8j1nME/jC78C5n31cS
	SRh8rKeKr5RBjSU2JsetEe0mRA5qAPFzMvGcUW/pQHCSHJrUyhhqjh8YGRH36PSg1kNOVj
	y26T9MblUXx4777RPzbaaJ6IC9+c+gI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788179567;
	b=HDu9l34Tl4BPJ+SQFQSaSn8cULpNAf9IJQPokHZoSu4/qMqj/R9fqdDl0J+m/LwYY9dsUk
	wGz3IekvUwaRSTiHnoExbGiYYbuqb7Bl19ntGWNJzNRDFPDVgmg8hIlM3ARNpyJW/C8MY5
	I5exbmPuut5pjX+17vmlBahr3ZLgeTw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WmpDWcMe;
	spf=pass (imf16.hostedemail.com: domain of libaokun@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=libaokun@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788179561; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=d7kMVnx2LblB7BHqjw+a56gGYnnF9uAQgrmNwvR5plE=;
	b=WmpDWcMeDT18m0AmkXO8QDGK2sYnHgGPTtyS4hLdv09g9gWiEasAJKsB37n5C2qEpBFWIg3Tth0dVWqvBrLIldYh9gdpN5lvpvRlGVY6SJCAOM9q1pBhFlrSZz3dZoBviUY/woq61fDp7/pxqLls+G0CBgfmgoU3cnvNCnCUPnA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X9yvEG1_1788179558;
Received: from 30.221.129.244(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X9yvEG1_1788179558 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 20:32:39 +0800
Message-ID: <156326be-7d4a-4bdf-b0c0-030dc951af2e@linux.alibaba.com>
Date: Mon, 31 Aug 2026 20:32:38 +0800
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
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260830041901.2668-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u5sdme45rz3ufbax6j5qn1dzin8zy33p
X-Rspamd-Queue-Id: 6C0D9180002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788179565-957837
X-HE-Meta: U2FsdGVkX1+p8zCF7kADSh/CvE8qA9qsnLn2nRgFv5CMEM1fADA3ZJdbZHgoW2/vYEKtAlYzyfESAgm1jqm+ywv2ilyzoP0GFVkwxoMSMnqYDoLqhhxB7gEv2fomrmNz2hNBQaI7X+CqLO79mWVvx1jIkfMO5djV9jtoykKzOFQrfmt9tWqo2+E4jp6vQwvIB1MX2XzNrIMYpVIfCIzespUVEt622O90pTup5R3evCZRPCEcPvum1w1439kGN0YGVxY4CI8zD3avYqgi59gjLuAeBaNhsP9M2hh1KndMikJ92zb99dUiMFFnyh0Jqt3yQFRFBEkIcu+XLjGPzlititiRNyY6GREwfKfCO9QBVbhrOUtvsEnAQ2BoqyO6yanA91DSUASnqrShUgwNDmf1Br2yYMTK7SRb6c+/kfNugbv+8MA57mAPcoZy8sjdIAiryZPaZyYqIcM+5nyNzlzcYXMMxiGmeiZ8fSotvqbN5FMB7S+4NP4idtQ0U0PRojwng6D+jB1v5xbhSM1rrSTrgS4xbptF6QjIgUOi8c7FA+bPX00tZKqJ2QJyEQXsdclxfANZJCn6lDRyDL13GF31aprpfUTJnRLuLldDA/qB3osls+RsIbEc2vpw9fFZw0o1cCrSi1RYpOrO+44K1nayneduJ3S91C1UlGYTQjub2Rn/Tp8faAYIxZ6+fhKKOVy9eE18OAIktxCcHJ8TuvCMRDkfXFCjFC9GM1h8Syy8F1rCTAC8liOultVTmPqslMLku6GckVDeohtqINEj43wG546bzaOQ2lEzESHN6h8BRw3uyRDxGMVUejTbRpwaJ2VjDEWR6+cQlAhPVNcOVJe7Vl+s3VOT8siAvjhPktjnojcTD/mmt03VtBhWoRJ+7SiknUmVd5CA18KEfQyTgSrPkbSbyRoE1OYp90JZ6Jg9WSsEbz0Clmjy6gQcxd65HtyNBrmuCklLf6Evxib22Xz
 X4quXyDR
 2zTki9Gh9jFx9uDSdK9DOlBtxwOrmXVy/Atg4RiBiYNNPCyTzoWfwtxbVOjmOCNdQKE11lwfROuOAYtWqvYYuEHg5fMHjjLz5MLCbS+47L+iLo0AeAC8ov401CXEfIOnzai5fqyWF4OCRXNdijXhK7wUAnmkwYx5dzY/qiXC73Wlr5GNAVIpiiMOUGkEU8HfR1gC2Dz3797VERrqWYoaWuBhFlKKYEPioOIO8brocO+yoqMrLxIXYShAUDFc2g84b2OY8PDd1VKB9IILiseKiJGjdYYJIO+tvtoXfhG0HLSGQlYLNqK41+OV6Bkl+VO94C7WRaprtPKqOGtJf4PvEHwjQj2zvRRy+MydgBiNLXsYHxhSVgBfAL4UV5f3ZjMgddn88ynk4ESBCBOId3qD85C33rkBoYUbw0/PMyyq9qlHkHBoJr5XviWgb3pwMv3eSyl3vg7PPW6WCa+gx6oO6yjxaSzblTVvjbWXdrbtFZoXIqlQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/30 12:18, Matthew Wilcox (Oracle) wrote:
> Both of these locations are called while a transaction is in progress.
> Starting a transaction uses memalloc_nofs_save(), so we are already
> prevented from recursing into the filesystem and using GFP_NOFS was
> unnecessary.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good to me.

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

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



