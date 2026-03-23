Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4E83EC01A6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1416B008C; Mon, 23 Mar 2026 05:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161F06B0092; Mon, 23 Mar 2026 05:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F956B0093; Mon, 23 Mar 2026 05:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ECF4B6B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:16:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 992C3C2DF1
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:16:01 +0000 (UTC)
X-FDA: 84576770922.13.51B327D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E97C280005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:15:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CJtMXh/5";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774257360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4az/vG6NYGXqJnZbacYBDqS1u22yYydfMdFjf0wTqE=;
	b=yy0n9N3/7I9ywfWEsaR+1zITnMcFUbmQwYIeDfj9aKCaSg5Bogf/fU+u+hSDxSDdE3LYg6
	WbyvyOWs1VOxqJWiiTndEFV16h4WosXmY1e/5QcNp/IYuy2DVpFQx4g4abQHD/8e3Wm61g
	8e3Ngt3of2ABVNocbTlqyOLW8PjM7Gk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CJtMXh/5";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774257360; a=rsa-sha256;
	cv=none;
	b=hR1Bfjl/eXOUSMioLTHaIZtAH7CjzkpN1xuJgy2UIF6L1SECzesBZGqB3/RICuSWJQaMD7
	7ELELmTKlBX+8Xw18kcyciqxUNXlgIBcNMd78lq++v8EKYPoZFSLm2LATjnwYM1WQIFJvj
	3QgKB7stoDhSXDoTa1UN8osxwyhG8MQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EF4FF43C38;
	Mon, 23 Mar 2026 09:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E088C4CEF7;
	Mon, 23 Mar 2026 09:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774257358;
	bh=j4oYL6qJr519y4GMgxzzl1Iz0AsfhhSjwBXRqi9M9rg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CJtMXh/5mFNiFj4N7gljp79UzC7Wpd5PCIO2sVXOs96THnKETVMu9Lk7GYiT1Oe89
	 QYKlimeGSQI7cU22q9Lo9Xj4FqZG59zTvU1V0lScbAzodg3fMhlKlU9Yy4U5US6Xsx
	 cCrxEUYN6Dm7A0kQIMG5gxV2UaHBJnibkBMCSmgwFFqqcoZ6xsZaKVuG0w8qntu6eC
	 7I1h40xtlN9afAJiWZgOmZ5ExJzeia7CQ+4jelBczCbubPRmvTrnCN7OENAquYNuEl
	 RqxMVsNUbw2bB+jM4oowzF8+AViqDmHUGCcAWX/vV4lKK0rJk6wo2Kf3tT8F89Au3Q
	 jyTDe5OsPgVBw==
Date: Mon, 23 Mar 2026 09:15:56 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kexin Sun <kexinsun@smail.nju.edu.cn>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org, 
	david@kernel.org, mhocko@kernel.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	julia.lawall@inria.fr, xutong.ma@inria.fr, yunbolyu@smu.edu.sg, ratnadiraw@smu.edu.sg
Subject: Re: [PATCH] mm: update outdated comments for removed
 scan_swap_map_slots()
Message-ID: <5ce23372-c179-4b98-b338-fb6bd807a207@lucifer.local>
References: <20260321105814.7053-1-kexinsun@smail.nju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260321105814.7053-1-kexinsun@smail.nju.edu.cn>
X-Rspamd-Queue-Id: E97C280005
X-Stat-Signature: 5hq9481qic5ws5di4qeo8z8ukokxbu8z
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774257359-274649
X-HE-Meta: U2FsdGVkX1+4BQoH0ACdXojXTxYFLptR7yDR+3AhxjWTv24s9peq04d5ZQtujKKLjo6jJ0Bu7OmbdX7MhEYfVZNVlwckPupQkCDjGsQNLUU+Jw6987DI42o7lxA8hs1p0FZ6P5eBc69QT7opkX9dkKxO8GtzQpH4TWq++MqchsLNiAg+3FFcCCuyXczyhUT0gxaumzEXlPhjnYbjJfEI/vRCw8rT4cMFqQxjolHX1ABRWkvPuGcL1giB14+1y+ZQc/m+Qn6iC8XMlBmRee8LMr9QULRkIdEZX6zlZdgXw7vOTSzw/GtIJiRlbrnws53uf+1XDHxrDlvd9sqVAgYoFMAYqlkCO8w/N8D3S+pekoSfs3ylmAI4mo80pQDwLtbLVVwnfywIp2VT7tE2/TkHdAIzuVVhgWCpXWnNw/0wp9UHhMHAi08mvbcpM0Kwvg2IstbhEcYz1jfHk3mZLsN5CzL+gv+b/1vSF+IJCmOCD1GrI1mY3JMvDU1elgB5tWYjiOk58ClBnJNFeVCgBJRVBG9x0JCCVR1g4gTsj6pz0WcLBBj+Otxl4GBh08EyjMN7fqVAM0/7PkcfQTq7htLtx2X/D6kbuG9BAK4C9s606KH1EqwaevuR7eIlN4HaKkWWHxB8rmYThz7gJlWJ4YbxeomY9r6hQQWi3q6uBCb3xv5J/T0pNfdvMB3DMx0/nUApRZjiLCDcwT/W/tnGF9z68s7M6IkNtymDmRO3Ub63w56V/z5bdwjPPxR1MW8Zz2CbWqEFdwGkMjA1ntUd2ozzE06lj5m1LJz8BQ89Xa31lJW+Gvzcw0d7sdZdxhyDdrrG1ngTgEdPQjRjqeEVSGVwSEsxyYUMCNfS+kLaDdVhQBDXaqRYZk3MZDH5AkmotwDh9gMr9sBbq/q8S6CNk0FL8Cs83hZxL2VIv08gKzXjxSzUH0xa9Q6HJlxz93FV8uQR7FCrDWFoJew/bc8hWzH
 SeBWK4P/
 hihvMbBxAQZfrwZXBvjy0egXIqip4TbsSHxgXVZpE7+ObQ1/RjmqpkBTS6pPubBwofnJJkqtg0Gj8Yn+yveTxWxpt/I/yZvYpFRT7BjJlyCueY29eju91Rg1Ckkr1bbx1h6s1TJT8xkWQRts4xWbW+YMOaV1mOeUq859OpNcjOyzn7bjev4t2srn1SuYkWOeS27HtGWTIXqCbqrcozhJuwoSlhbWCTk7pUaQU/0Y2pPsRFcRlQWvGNs0FB1SES3I10F45HfblZrgokaAQQ6VpWeOwtPFz/Khrt8CP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc old email address +cc new

(Gentle hint to send new mail to ljs@kernel.org :)

On Sat, Mar 21, 2026 at 06:58:14PM +0800, Kexin Sun wrote:
> The function scan_swap_map_slots() was removed in commit
> 0ff67f990bd4 ("mm, swap: remove swap slot cache").
>
> The three comments referencing it simply noted that ->flags can be
> updated non-atomically by scan_swap_map_slots() to justify a
> data_race() annotation.  Since the function no longer exists, drop
> the parenthetical reference while keeping the data_race()
> justification intact: ->flags can still be updated non-atomically
> by other paths (e.g., swapoff clearing SWP_WRITEOK).
>
> Assisted-by: unnamed:deepseek-v3.2 coccinelle
> Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/page_io.c | 4 ++--
>  mm/vmscan.c  | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index a2c034660c80..330abc5ab7b4 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -450,14 +450,14 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
>
>  	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
>  	/*
> -	 * ->flags can be updated non-atomically (scan_swap_map_slots),
> +	 * ->flags can be updated non-atomically,
>  	 * but that will never affect SWP_FS_OPS, so the data_race
>  	 * is safe.
>  	 */
>  	if (data_race(sis->flags & SWP_FS_OPS))
>  		swap_writepage_fs(folio, swap_plug);
>  	/*
> -	 * ->flags can be updated non-atomically (scan_swap_map_slots),
> +	 * ->flags can be updated non-atomically,
>  	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
>  	 * is safe.
>  	 */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0fc9373e8251..0758ef3b100b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1070,7 +1070,7 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
>  	/*
>  	 * We can "enter_fs" for swap-cache with only __GFP_IO
>  	 * providing this isn't SWP_FS_OPS.
> -	 * ->flags can be updated non-atomically (scan_swap_map_slots),
> +	 * ->flags can be updated non-atomically,
>  	 * but that will never affect SWP_FS_OPS, so the data_race
>  	 * is safe.
>  	 */
> --
> 2.25.1
>

