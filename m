Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D400CD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A98B6B008A; Tue,  9 Jun 2026 09:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A786B008C; Tue,  9 Jun 2026 09:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470F86B0092; Tue,  9 Jun 2026 09:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 388EA6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:07:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05CD8A0559
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:07:23 +0000 (UTC)
X-FDA: 84860400366.21.E535841
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3B765C0019
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:07:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RYxHyMvg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781010441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHSHH1TAOou/c2SNAiKK3Gf3+G+ZYZOub2TB+ihqU38=;
	b=sn3XT5PHi1T2Xpuk5ZmtHN5vVI5mUk3Ed5FtYK/b+52hstxHCUpNLyPKHUWivxVuu+XseO
	rSOEtjbwjd0wirQNj9o+M3utu1Emn5Gpmh4iL7oqHhgOqOa82Ouuq8FsF+3wdJtbMcZleL
	M06ClaHzDWTjjQ+OILbTi+DVXIdOv4U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RYxHyMvg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781010441;
	b=l79M//p/REDW0kdddTdD2K2gRUh3nTc4UlNoAx37WIbwlreBCESBnSwLnm+0PIWtVBkmRl
	wQrmyDqK/udFDvT0zsh12up4l9zcW47LWXzQaunc+H+JGS3GgeIqsYJlMmt7JXnmEmyyBB
	4+9Ra28BF5eyX18fyUwcBpjs7bSXPgY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781010439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHSHH1TAOou/c2SNAiKK3Gf3+G+ZYZOub2TB+ihqU38=;
	b=RYxHyMvgF7CyQdh/FHyghSJje9BEyk+MDbj8827eoK4dPEpZTVyyJ9yVvpKCQLp6JwSa/g
	9JKU83AhsNXVElOHKaRofb6Ngf1pZXytYskpKdasEDTFGpn+wNt4AoBuO3ax7sWvL2eCGv
	Ws8nLzbLmzh6IzouBZO7tk3n9hHbho4=
From: Usama Arif <usama.arif@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 3/6] ntfs: Use zero_user_segment() in handle_bounds_compressed_page()
Date: Tue,  9 Jun 2026 06:07:11 -0700
Message-ID: <20260609130713.2851385-1-usama.arif@linux.dev>
In-Reply-To: <20260608210618.3437216-4-willy@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3B765C0019
X-Rspam-User: 
X-Stat-Signature: 9pip8nx6eo5gwkr45mpw15gc7of1f4ku
X-Rspamd-Server: rspam09
X-HE-Tag: 1781010441-195957
X-HE-Meta: U2FsdGVkX1/tJN7POq6oyRS6zz0O3A4bRHBfRd24NGKKBgWEFazR0F5e97uSRpP5drI//77ZhvA2n4hU0tXCIXQMBZFC/+vkOGhtzb4ic7gYTF5Y/l5mCQ9lmBqpJOUDDQmq7hcB2i7pVZ4z8cSQjBe2TE/OMQl1OqpR5qd/WzvVih33XgC7auf+Sm25ebLMWgAyzIrubJePF7+fyFI8xzTqCkEouVYkrGtJTMwumgHzx3ya1ktXdEcl2WU+CktAY+5ZGuumYyWD7uOSSaqnnXtT8gS2Vrvzc87+4laCAPM92o+1+kXDFfkl4qHa/dCx682SOCYqJw7iLnfeEzPoof0QEx+NZOSHR6aNhfmwJATRzdSvLMu+oGAdz6CEYhnjB6uZCamv4bfxuNDJSU4A4xQuEASWhrKsnVbOzWXrZ6UDVF9DdgXEXFDcJDr2qeeghibNnw3/Q2uJTatHobBTMtcBKa9lxpEURH01MsPqtLUGG29eMXr/BO2Sezk2Njgmfi5PRaDrA09f9oHa0EyyRkjNWydTjkXLuZGG83nvTrbeOzxzKkEUmmz5LTsQ6Fxun16kp4zyh1G+cCMO5JFTrwHN+Lu6Zd2Q5vl/Yk07eNh6Tq5HyoEe+ej5SD3Xt1YCmVBFnj0yITnS9a5os2hpdvCn7IJoSqQnSSJnpFG695/q9kEobH9tN1NeqO+OJuPm1Rail+IdllDICUlfwNMH/6VFfvNubBGA/bJPAKmQg7Mm9rIBHIoqy1znFxUelMXKAKHaV8BERGFk3tB+q6OzFg517eEw8ypMvgh/EzTH+g7kgGQoNAv3gZsa19mVntcDpa8SWqOq4vByMUwyYvBPga0ZuuhByKeM8RzMKRGtQCohUFCcl9Wbp/OWb82unRoy4AExIcR9rf4RWajaAk1qgV/JIPapon6vsYWz4v91ypxQ1gaF1ykRihJMrNJUrov2NGSeltzlPDLbaLygZOZ
 8cOn+7sn
 avMNXjsOtgdJ4d3Aek6k8MOLlvuM64MyRIlIOesDqWD0ZbSqNQ3NoRQRGU23sPmTjskZx9K0nOTBCllNz9hPX5kkX6Ngg6DRATE3FvDDfSraDisqsFO1TEC9QTLBHhgTnn6cq/iEDxwChBwg35lKBMPx6wLoXgPuzEi/dkm7dp/gCTzQXsgcqtUsaV8ebI5ZXW7lbAghfD90HaYc9VXH6EThi/AhoH25Ww66M2+En1Yfkqy2O//ifl6bSiURKLnoFMz8mzzF3xlnAPizRfPVxemJ+wxLfqDt2jZs7Mb5rtk6zG1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Jun 2026 22:06:13 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> This fixes handle_bounds_compressed_page() on highmem memory
> as page_address() does not work on memory which has been kmap_local(),
> only on kmap() memory.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/ntfs/compress.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> index b279f38636d6..89067fecf5a0 100644
> --- a/fs/ntfs/compress.c
> +++ b/fs/ntfs/compress.c
> @@ -108,16 +108,16 @@ static inline void handle_bounds_compressed_page(struct page *page,
>  	loff_t pos = page_offset(page);
>  
>  	if ((pos >= initialized_size) && (initialized_size < i_size)) {
> -		u8 *kp = page_address(page);
> -		unsigned int kp_ofs;
> +		size_t offset;
>  
>  		ntfs_debug("Zeroing page region outside initialized size.");
> -		if (pos >= initialized_size) {
> -			clear_page(kp);
> -			return;
> -		}
> -		kp_ofs = initialized_size & ~PAGE_MASK;
> -		memset(kp + kp_ofs, 0, PAGE_SIZE - kp_ofs);
> +		if (pos >= initialized_size)
> +			offset = 0;
> +		else
> +			offset = offset_in_page(initialized_size);

Is the else branch over here unreacheable as the outer if statement
already had if ((pos >= initialized_size) &&...


> +		zero_user_segment(page, offset, PAGE_SIZE);
> +	} else {
> +		flush_dcache_page(page);
>  	}
>  }
>  
> @@ -222,7 +222,6 @@ static int ntfs_decompress(struct page *dest_pages[], int completed_pages[],
>  				 */
>  				handle_bounds_compressed_page(dp, i_size,
>  						initialized_size);
> -				flush_dcache_page(dp);
>  				kunmap_local(page_address(dp));
>  				SetPageUptodate(dp);
>  				unlock_page(dp);
> @@ -758,7 +757,6 @@ int ntfs_read_compressed_block(struct folio *folio)
>  				 */
>  				handle_bounds_compressed_page(page, i_size,
>  						initialized_size);
> -				flush_dcache_page(page);
>  				kunmap_local(page_address(page));
>  				SetPageUptodate(page);
>  				unlock_page(page);
> -- 
> 2.47.3
> 
> 

