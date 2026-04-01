Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CA9910F9311
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 00:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6249B6B0092; Tue, 31 Mar 2026 20:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FCD96B0095; Tue, 31 Mar 2026 20:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5126C6B0096; Tue, 31 Mar 2026 20:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CBBB6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:49:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CEDC316051A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:49:29 +0000 (UTC)
X-FDA: 84608153658.23.C81817B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1AB0F40003
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:49:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PLS4hCbR;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775004568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FjlyT0Q9Ix6xnb98lTgD5dO4P0iGlDO80UM/3Y78Mo=;
	b=MYqiAI08reVVD0EVkRMIHLcl/4jaMwkaRUZLls5nb2/BLY6uLcgAWfrDsZ4JOtVIVjCl+h
	38I5ff4qCYXNckTtzVE1B8cjpWNB9YFDaRu0QIbFyAajTkVdd3rP7rcJ7n3ueAuAmjvfcp
	1Uzo8l+1tNNjLfm6BnOgs2itoG2V+fs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775004568; a=rsa-sha256;
	cv=none;
	b=xjQ5ETkszqUzdfBFcoG1WuzHY41VC+V6kimtRLK4x0aseUOzn1pZ8tumUdul1ZpAGkwyXt
	Xjs/+8Tws4S3uUwJEQegRkI/V6xAVWhzPgw+Eg/+ec/lbLnPqqG12chVhxVJBCDYvtjjA3
	MrZwyL8WjV8o7mtVON9aQ9aKQsNLYWA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PLS4hCbR;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81FCB600AD;
	Wed,  1 Apr 2026 00:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20D3C19423;
	Wed,  1 Apr 2026 00:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775004567;
	bh=VMYEXmQ31vZoaeT5BJqBEM7W7RxQf5HP3q4nS2rIaMI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PLS4hCbRspOTf3kxCl5oZZ61sXb0Z3sOjK4oQzOBTNxJmyUvD3LTxjueGtaPbuOnD
	 w6QA3iIrDJXL/dcU2iMc/jTcmFtSMjnhGc0X9pOJJYPC+UYXjjGseYbasBM/PRO7yu
	 cn6FC9+3rvOTZBAyNZGJgtyLzqrB6zqL2Htg3uTM=
Date: Tue, 31 Mar 2026 17:49:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, Qu Wenruo <wqu@suse.com>,
 Avinesh Kumar <avinesh.kumar@suse.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] zram: do not forget to endio for partial discard
 requests
Message-Id: <20260331174926.58ef8dc4d40ac12f8ce3905d@linux-foundation.org>
In-Reply-To: <20260331074255.777019-1-senozhatsky@chromium.org>
References: <20260331074255.777019-1-senozhatsky@chromium.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1AB0F40003
X-Stat-Signature: x4z9pkq7s5hdg1d7eobqfwismk7pnqyq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775004567-267535
X-HE-Meta: U2FsdGVkX1+kfK2H3Uhc4MIdTGgGLBkJxz1EfGyHPQSX3ZcKoGqHapiv+63Js9vAha22pUYwO5l6SAoBREjs7o0H9m9r3xiq+Jwrj1GuxUPcMnkEo255ueHIevZqvSUiwEvhcET5PYSiSnmq6N1+AzAnNPCTCRxsPCHkDFRdIxVxl5+9zwwqm6u/qtGSJE/j1nO482TNe092OwOazYtd6MPjRXTP6AodY6ZSbs/DCmtGq/CvSd3H6rnlNO5MtzT2yxpaar1R9Ge1Cr0nu6DKa/08rhLlduXz38hb3nwBaUzKxGZURN6XrJBuX7HWNwn8f2qBGVMTyHvYccmwSO5LnH/pf9dhXJTXYG69JnYWD35fv/lP/0tuHHd9rXF9OcJFjcaAYpF2yLaEQoTbR3JHSM4YGHkjC+et0vUDZJ/IR1qGRzRidWdplj3MlyApMZaUtjt9TRQEbKEcwaR7SKIW1UPxZm615bCcTZVsJ17BduhtZ9maavf6I6IRpW+gJp33iz/CPuON/5ye/nagdkOOPkYyw9GHYuaS/QccXSlqMXCmnScUOY9rXTE3UamisA/3kd63GBGHKI7bZf2dO5xPyQo9vZNFWNXDAOYB/LhT0bdylRw4DqeFUxJWbMxFYuIwW5rKaJ4li7x4Xu8kAhn9ptfLEWgIe2E1AVXErpjLP6R4TB4rL/BAIG/C9ORZJSNhonw8vG8Umhf1wqGfT9HWApS0MiGqUuuq8dbuNNVaH1ZLA4gqKOZsQVyUDCTIm3605eDsKyZYJdU1/3WIk79N6KHHARklHTutvy2uCppFun/ttma5+uODAlLiMapzkFK+LibZh4LgTg1mli3XapHCnfemseNBGZGtrZMGKTughktz3baqMViHh9XjZ+Yk5hKXIwt5IYUU+35WB/P7CTEfp65Mg7oFncApC3/Upr0Zy5rYJIy23u44yAmNYjoT7QTwHSt22kB6UpADfuJ1dOE
 nPCfNr+n
 trw+oCv/BZ7QdJCtPbxwhoyBeko3C0kQj9J87a8x5MwOql3nN5UMzUSqTLrwoxiKC371Ghc36/souamfK3vAtvgyB7WtjeUVNGLrGqMVHDM6mQ1das2PtDmZLsj/NDOWBCzaNmoe98cCUNRs7mKJ9k1cZlRcYQOV8IegLDfErEjRp5RrKIfJn3msTtTRBfTMgFfiNAhGUG9dunoepXyYI19QXu7m/Nl4/2gxNdtsYqCd1eC9dj/pS6na9g4PC6ErL6GbGru/AfydCznTEGfSqxpAjZO/A4E5Oqswb4HiBHD9Nye0PeE0krkvA6p8zAJ0hFvaefpuNu1McO7ELzD+kFl8IR8LMkN27Dfu0Fgn/JqM5Yr+iFE2qAdIMFiWomtuma0PYKe3xQAWG1wvd4O1gLp1fWlIpvr7cXqfMGRsq83blw8XoYLovDbdN8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 16:42:44 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> As reported by Qu Wenruo, the following
> 
>  getconf PAGESIZE
>  65536
>  blkdiscard -p 4k /dev/zram0
> 
> takes literally forever to complete.

I'm wondering how you measured this interval ;)

> zram doesn't support
> partial discards and just returns immediately w/o doing any
> discard work in such cases.  The problem is that we forget
> to endio on our way out, so blkdiscard sleeps forever in
> submit_bio_wait().  Fix this by jumping to end_bio label,
> which does bio_endio().
> 
> Fixes: 0120dd6e4e202 ("zram: make zram_bio_discard more self-contained")
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Reported-by: Qu Wenruo <wqu@suse.com>
> Closes: https://lore.kernel.org/linux-block/92361cd3-fb8b-482e-bc89-15ff1acb9a59@suse.com
> Test-by: Qu Wenruo <wqu@suse.com>
> Cc: Avinesh Kumar <avinesh.kumar@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>

Thanks.  I made several changes to the changelog from the earlier
discussion (Anivesh Reported-by:/Closes:) and added a cc:stable.

0120dd6e4e202 was a few years ago so no need to rush this into mainline
- target this to the upcoming merge window.


From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not forget to endio for partial discard requests
Date: Tue, 31 Mar 2026 16:42:44 +0900

As reported by Qu Wenruo and Avinesh Kumar, the following

 getconf PAGESIZE
 65536
 blkdiscard -p 4k /dev/zram0

takes literally forever to complete.  zram doesn't support partial
discards and just returns immediately w/o doing any discard work in such
cases.  The problem is that we forget to endio on our way out, so
blkdiscard sleeps forever in submit_bio_wait().  Fix this by jumping to
end_bio label, which does bio_endio().

Link: https://lkml.kernel.org/r/20260331074255.777019-1-senozhatsky@chromium.org
Fixes: 0120dd6e4e202 ("zram: make zram_bio_discard more self-contained")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Qu Wenruo <wqu@suse.com>
Closes: https://lore.kernel.org/linux-block/92361cd3-fb8b-482e-bc89-15ff1acb9a59@suse.com
Tested-by: Qu Wenruo <wqu@suse.com>
Reported-by: Avinesh Kumar <avinesh.kumar@suse.com>
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1256530
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-forget-to-endio-for-partial-discard-requests
+++ a/drivers/block/zram/zram_drv.c
@@ -2678,7 +2678,7 @@ static void zram_bio_discard(struct zram
 	 */
 	if (offset) {
 		if (n <= (PAGE_SIZE - offset))
-			return;
+			goto end_bio;
 
 		n -= (PAGE_SIZE - offset);
 		index++;
@@ -2693,6 +2693,7 @@ static void zram_bio_discard(struct zram
 		n -= PAGE_SIZE;
 	}
 
+end_bio:
 	bio_endio(bio);
 }
 
_


