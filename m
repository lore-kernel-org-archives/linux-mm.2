Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE664CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C088E0006; Sun, 17 Aug 2025 22:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3F98E0001; Sun, 17 Aug 2025 22:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431078E0006; Sun, 17 Aug 2025 22:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3056E8E0001
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:41:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D56011606A4
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:41:29 +0000 (UTC)
X-FDA: 83788327098.11.DE1E900
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2664A40005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:41:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=irwfAP3q;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755484888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWGUmFZIiJazV+QTeUF/il937zdE4XYBcDoWf0FZ4AQ=;
	b=qgvEfbhOy1+m9NqD2R40UBPstReGus4e/+WH0/4hHBG1MxAZfSF8KKzz9LhIoOBU3FlUhc
	373x82W5zPPTCz0zCeJvSMoChWXX0pSQwkmVen9Pa5Xaa6UAicCFRM40RIjjv49MQkzl4N
	jE1n6ZBsOvwZGfzvUU7CcwpvfOjkDMc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=irwfAP3q;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755484888; a=rsa-sha256;
	cv=none;
	b=a94VyLyRjrIHRvzecxJJht96ISJyqogySMeW30+90/N0eSznFAenMuNJ0CHDclh2J4Ouds
	s4r5QaSHZHDUFXMcyQasSvdkIXHuAT6uefpyTrIukm9kcV56G600okpWwWcW2zTniFuVqZ
	pcoTejcxAqowF7BP3Pxq8pR4YgyrAtM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 442BB5C0F2B;
	Mon, 18 Aug 2025 02:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF60C4CEEB;
	Mon, 18 Aug 2025 02:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755484886;
	bh=XwyAzBzkyYUsxtoUqwoehmkxeFNQI6xkaYZl2/saPrY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=irwfAP3qz5AAci8Aq0upT9TgWRluvcVPAPaXRn0dO424y2LSvfTdlD7Ny590XBTCt
	 OVX0DbG4jariBuhxW4GWKWzNCfI8CnP+6HkbLWGJTSfTj2Ox91qSgIAfuMxi2ODrWi
	 rwGqhFGQq7TZAS3jYsx1x5Ku4obXi8PzrMBNik84=
Date: Sun, 17 Aug 2025 19:41:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chi Zhiling <chizhiling@163.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew
 Wilcox <willy@infradead.org>, Namjae Jeon <linkinjeon@kernel.org>, Sungjong
 Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, Chi
 Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH 1/3] mpage: terminate read-ahead on read error
Message-Id: <20250817194125.921dd351332677e516cc3b53@linux-foundation.org>
In-Reply-To: <20250812072225.181798-1-chizhiling@163.com>
References: <20250812072225.181798-1-chizhiling@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2664A40005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jq5y53a8py915gj67gk3a1cdz8gdmjsk
X-HE-Tag: 1755484887-558344
X-HE-Meta: U2FsdGVkX1+z1DAbSSqv/tX9oU0GgSK2Uav6YNkYhCZDvAxiGnmMER2Sp4zqRC6MD/QxRLuO0h3tjlNvVO6YurqpgYGtGDBJ3VRzTFnKlbpK28thPF2m5oNPjE9kkrdJC8cgtGJVeskl9n/304auEJga2afACbTN6mZVViiXOjHS638JKQGx7AVpy61gzLEvfsG6vZw8jqcjcLRtwCxIkPUunUnKwkIDw6w3C0Vv0EHt6OT5QomgIAvIkoDDq0bVXdGfYmI8yV1bELDCCAhzxG4bb1EDGgx7p4/NfhHAKUTB49IgrtNiGTfzB1wQVLYOM9Qc7cGIsU/Svg10+G+VVQQXYvOyjJcHsckqg0foXZddOy+NCFD+aSyAzGuBx2tAA/wplMF6Pd9OFxI/UJGj/p7HwLgatTGmzxRHKGntDpQzZOhGFrJLMOgTzgQJY+UJHmlSTvDRRopEEXqlek0y6yCRaYQf8rCgO05/kT1QdkoWfn19XEaBRdqHm8Y/GRh3KxVWyfxhtwP/Z/oL69MajLKDFGacnP5GuwLw2DbVjJflW5WwxeSwD/XUoxUcce1ca89RQQSmiJjUhrQLiV0CFWMxaXW09CyDReUQZCxnhzzD7aZmvXpnROjqePPCnCR1rNpIP29HQEd6eMaMNjr30TirQODfHC+XAcepCwIi8nQXKnNb20+a9rT2LBFN3eTQ/LDpDVwe5dKc8/Vl/CLOrvmyMqST5wmlgTzQppTAch/9j3mb675kVGiG9e08BeU1oxEbBFoEhfzhRqSStcbS0l2EWzKnLqGXiuiFhmgMSJ52JCsRRaTBrT9CUgvVg560jv3tMRP88cL6SCejaseoenMfWg0coFdMndZvGB04bOOYoTwnSxxUpNRp7KnzvM0uA0U7gO8uxixPL9tkqsF48TQdl28EghAPRjSN+oHe8QM10bY0jXIggKnoutgyXTK/8gWiTapq1mcLs6r72TV
 XTda/rIG
 NiS5DziJ6ZcJyFAmmeYhGyhHL/4N9RFURVoXKHU0VWTSoSX01QnElsY/CRPgvaT/Ge8I6daWY4sGo7RmQTeg5RrTp6yS2HcOUJaEhO9nlO/b3zfbI1gqLvL0phOpfs9QL2JcgLwA3MUL+exZdTUKgjqmgdE9qEpLy0qIsW2RNuZAg++usnm5YetCsnRR/1JRpi2NPs0ztbP2oktcifNVbkjl62xxfDY/XzbJqzBWoM139PRCez78/Zqts9cs7ExhFisCr740/JyjvDXNOZv9SJWU2Nw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 15:22:23 +0800 Chi Zhiling <chizhiling@163.com> wrote:

> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> For exFAT filesystems with 4MB read_ahead_size, removing the storage device
> during read operations can delay EIO error reporting by several minutes.
> This occurs because the read-ahead implementation in mpage doesn't handle
> errors.
> 
> Another reason for the delay is that the filesystem requires metadata to
> issue file read request. When the storage device is removed, the metadata
> buffers are invalidated, causing mpage to repeatedly attempt to fetch
> metadata during each get_block call.
> 
> The original purpose of this patch is terminate read ahead when we fail
> to get metadata, to make the patch more generic, implement it by checking
> folio status, instead of checking the return of get_block().
> 
> ...
>
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -369,6 +369,9 @@ void mpage_readahead(struct readahead_control *rac, get_block_t get_block)
>  		args.folio = folio;
>  		args.nr_pages = readahead_count(rac);
>  		args.bio = do_mpage_readpage(&args);
> +		if (!folio_test_locked(folio) &&
> +		    !folio_test_uptodate(folio))
> +			break;
>  	}
>  	if (args.bio)
>  		mpage_bio_submit_read(args.bio);

So...  this is what the fs does when the device is unplugged? 
Synchronously return an unlocked !uptodate folio?  Or is this specific
to FAT?

I think a comment here telling readers why we're doing this would be
helpful.  It isn't obvious that we're dealing with e removed device!

Also, boy this is old code.  Basically akpm code from pre-git times. 
It was quite innovative back then, but everybody who understood it has
since moved on,  got senile or probably died.  Oh well.

Also, that if statement didn't need a newline ;)



