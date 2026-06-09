Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB18CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82A7A6B0093; Tue,  9 Jun 2026 09:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB576B0095; Tue,  9 Jun 2026 09:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718546B0096; Tue,  9 Jun 2026 09:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB596B0093
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:17:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B4C6C1E0B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:17:42 +0000 (UTC)
X-FDA: 84860426364.15.1092175
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id A0C9940006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:17:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qzP+LsnB;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781011060;
	b=UryVvRiUXAPJjL0vVw2y1Vwj802/trqyKFXbYqPbRXVpGxwwk/fBA37BHmie8Ae1XR4+M+
	vT9TKY5KAlaw+C6OH4NPhMcBPMB4zqcmL7QHjmyejTGwqfOp1bvsXZxXyN4Tp8TMYA5gir
	NpngWJzmVGk+2yby+OMz+51chrih7AA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qzP+LsnB;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781011060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxMQll+O4+monLTew5Xz8Mca5BpahKZtkIXA+xIMBkg=;
	b=qhpJnRwy0V2yxCmJlxPYQAt25PfY35n8yMbVPYDj7CUjtC3kuZQMV+yRhOc6L47p5ljgmp
	ZGhTnYodJnkivA+jV8KAO3M9M5eieMxm25c/cWiwxvKkuIs9/ZYICLgr8fioM7enY/4zKz
	M9TyipJZL7olclN/zo6++WH/IJj8mt8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781011055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CxMQll+O4+monLTew5Xz8Mca5BpahKZtkIXA+xIMBkg=;
	b=qzP+LsnBgX4txxd4qwDdGOWpue6NIQ2xu4zq3Q53ScsMs68zGHRKaMkY2OjNMz8ldO2oQT
	av/+QwPfsorh2XYYZ2ykQM//QUQ8V+BIwg7KuNtgsHJz/dqqmY0/sSYeWG3aKqQqNsSxYs
	F3TbbT+4EU5Ng2I4idh0G+xY574FQgc=
From: Usama Arif <usama.arif@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 2/6] ntfs: Remove use of __folio_index in handle_bounds_compressed_page()
Date: Tue,  9 Jun 2026 06:17:23 -0700
Message-ID: <20260609131724.3114804-1-usama.arif@linux.dev>
In-Reply-To: <20260608210618.3437216-3-willy@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A0C9940006
X-Stat-Signature: ttiff1b7ouhdza96e9eeuwhio7y3rje1
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781011058-202565
X-HE-Meta: U2FsdGVkX196mUttzPH8dfSia+OXJleHq0sR0OWfAEAfUyY3sZW20WH7DdZRQTm2DUcS8/MzJ6M5Txw7w98JQ009bRAFhIN6r2tDXPSYs50FobKmD8nYuy80yObPCWEXVEGTAT6nfzmojsAkbgXul8vaLCkgsGpBcciHN38Emp9qNIS6m3qIBNulrNjeONl3JXH3yZnukHhZYlbqwK7JhdYRiYZcG1RXvbMMtQoJPCDB4A3yMtCklGK+v01bF+QNUMoVDAh4iW4bHUTQiNqQRvCaw/htkeAdu2b6BZbW+xG3QcjKasa5Lg/ustuF21Iggtf/kpnyfst06gOLYfAiXi6lU0Zqpo82jv0BGBXnWLGpso2go5VjS+oJ943SvKi9DWENnVPbGVcgXeXX/Akg2Om3qd4nVXIy0NbjIeFPCqcYMyaq18yXj5mkrw8wx76l9oDJSmBu6wdUYAlRt1sduJMW8Irx2nd9RA38ydHFdhXBYZieuxBxFOCuqwPcWdrLiOVLnfQYIgGPgvTx1rQZhYTQXhoq82wx2QyY6CUhKhgfywvbSBWOVx70YeOtcHAZ+iIzmbksUsGQO4BxQLquht+HPhnQsunOBoHkXTfcnMiQ2OHFbnMU8NqsYyGAxuUE0dPNSymFu0XrlPzvbZaBMklYpu91NMtPP1wtZMYNzf6Ter6aSIJpHfb+m1axvyknfcnGwdRxuljS0fUsHtd7SovPyNlYMcJmzkvL6ysrWtgkUzeEYG2e5mVAyHerTNhD/Y1Pd0wT8H4RNiHKbJgVzI3zLjaCzctqtR8T+qduJ8T1qUZ3MssPY61LXo37G1HYNkyJCupOI1cnOSIbR+BrXz5IFmey+ZTb2aWvOtKKdOw9+O3/RC1INcvlh8XaTcESZcaxLW+xBs9aNoNqfSOj9bHZ6st7Yp3cPk4p16tAWLGrMj9R64SQdO/sgWuFPayJVG/sZH60ZZqIBUKQpGj
 ucDMRang
 ncwxoy0PacTdnIRUWfU/apstos8qJhltAaGme5nmdLmWXbJsSC60TVRnKNi4FIB8NjrE9JvMud3LrBG0yvA62IwBsg4b+R+QvGTg6LHo2eag7f1Bz9Ez0L7XXBBiM/oZlMymXGElB+mJAYNmWmpAymdG67ZX7LVnxNVmmUnI5aCUBKFFtRZBn4P+/fg5yKkmEn11v7A1zu1TH0b1r4lf61l/wDiGRskKRnaDNs0UBfJ6tbiivYJBjOhEbpUKD1uSaG9B26KMVDnSFdGWgauyLdNbo7UaHmAC4aBeuITsXTVn+fqk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Jun 2026 22:06:12 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> Nobody is supposed to use page->__folio_index.  Use page_offset()
> instead, and simplify by working exclusively in loff_t instead of mixing
> up loff_t and pgoff_t.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/ntfs/compress.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> index c904858dff3d..b279f38636d6 100644
> --- a/fs/ntfs/compress.c
> +++ b/fs/ntfs/compress.c
> @@ -105,13 +105,14 @@ void free_compression_buffers(void)
>  static inline void handle_bounds_compressed_page(struct page *page,
>  		const loff_t i_size, const s64 initialized_size)
>  {
> -	if ((page->__folio_index >= (initialized_size >> PAGE_SHIFT)) &&
> -			(initialized_size < i_size)) {
> +	loff_t pos = page_offset(page);
> +
> +	if ((pos >= initialized_size) && (initialized_size < i_size)) {
>  		u8 *kp = page_address(page);
>  		unsigned int kp_ofs;
>  
>  		ntfs_debug("Zeroing page region outside initialized size.");
> -		if (((s64)page->__folio_index << PAGE_SHIFT) >= initialized_size) {
> +		if (pos >= initialized_size) {

Ah should have raised my comment in patch 3 here.

>  			clear_page(kp);
>  			return;
>  		}
> -- 
> 2.47.3
> 
> 

