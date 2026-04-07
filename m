Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3941105D98A
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 22:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88FB6B0088; Tue,  7 Apr 2026 18:58:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39EC6B0089; Tue,  7 Apr 2026 18:58:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976C66B008A; Tue,  7 Apr 2026 18:58:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87D716B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 18:58:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1763E589D9
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:58:16 +0000 (UTC)
X-FDA: 84633274992.21.FBAAE08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6D89B180002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:58:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2OIJWI7;
	spf=pass (imf24.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775602694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qu1Js3ToTJuxtvoJXzKPuunDi6jw1one3SxNrcZvlMc=;
	b=sTaiVMT3eZqMsd7idPpVGOmItNYZxcRiH+cgv6ROFX/CMvsqwMLslSf/oJ5xmvjyzqW56R
	4fAJ3ysnp+LKy5t9tW14cSSIaU7X8kpq42axx1zhc9N2flJOmHkhjvgj1FcXplCYLTI3VN
	pJ3r9OyATVUe3WafKVCeSuyxeVoFh80=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2OIJWI7;
	spf=pass (imf24.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775602694; a=rsa-sha256;
	cv=none;
	b=cJSX+nb0P7bcI6k9yqKjbHtlgoWMYRk3mZ7zfScOb+syltC4O/7MVe3D+WSykrw7ViBX9v
	EZdVWmfZqIRZgxpmj/bHW7bP+blmubzLQqsACOKJKfkkQmiODmquB8rR5iGuyOMGJ0hGe6
	zG8TTmNvWSoKRDhHJInxelFX19ZKoHY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4173E40D84;
	Tue,  7 Apr 2026 22:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A7EC116C6;
	Tue,  7 Apr 2026 22:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775602693;
	bh=37xMryUjFIJ4OPQ3axPGjItRm6RjQqDybQiLZIPuX44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s2OIJWI7cUQMuhxlgnIVevRFIb1sCVmdJyn84HJfsIDG6A1rjKn/t6SwHr3hu5znj
	 FqlH/jmE/CLkMrarpjLnxET2A6q6u/+J7NQrJo871hN4bvdX7rSSpWkW8eEsVQKvqf
	 U8VaRavbM/jbeSIcTKZ9r0gvGEj8ZlekZiQkxmC2fh3qP1sACxjLyfRBV4KW8kcFmp
	 +8ZwPFcN770mpRKVdOkbHLfaEvDpuTY1Xv1Fpt1fdY9yA3SpJhUo9Lulv0Np3VmR79
	 DwOt+kULTaafbpefBACpVwEnJLkhNDt3ecrrcT4uNDQ29Awmx7q9hI2XgoRxSM38GA
	 XXi+CjrhrUBbA==
Date: Tue, 7 Apr 2026 22:58:11 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] f2fs: do not support mmap write for large folio
Message-ID: <adWMAzmaHiYzSTzN@google.com>
References: <20260406154940.2407853-1-jaegeuk@kernel.org>
 <adSTUszGSlEK_IBv@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adSTUszGSlEK_IBv@infradead.org>
X-Rspamd-Queue-Id: 6D89B180002
X-Stat-Signature: t7sbbncesjao14ssws5phyq3s59txmc5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775602694-29650
X-HE-Meta: U2FsdGVkX1/zMyBnxl7NLijrCiQooI0+NL4pUZiFnnto6XbE/YdknhISVoNzcCWu6StWW5/hfYfZKny1fpUKhfzwiGFU4VdiXPfNyWP/JGvJTqYGA3l3ZxFLeF55zAgxuRCTBugnqhfN3ae7kJKQOCVU4958eSgfr9wBcnyWPL6PUqD4oaxo/wkCwVbQCZFXZXLFrwuP3o3fhQMhClHlJGPjrqWFSuA2kl0M1HXoD9PUqi1PR9hgtpDlzWrfFU089sDHX7IlRSQjpHa75A8YQmXRP5Qc3vKQUlYNYhmmZl8sNAkddw3vcZqEcmBKBHIGjMfWmsCFE9tmty4KMWfiKaFzQqWvny8n/Mzf5Ju7fdgXO775nIJvPzKUWk8SpzXmL6/dWSpuERa6iWAYpyARD/io4GrFYDIWPlKu5VY/mTKSmNbQZZrtTxitg/ePte5KET5ud0kK+VRNHvGF9ysc4bVaor/voYzJlcCpsL9tF22KzI1mt7PKsGVLCx76j61VO0SQA8S4f0mqcxJ5Ur79rHLVJIspqDahZRIG6TqL8ZqEdkHuQCbuDtT9NDJwqCr5iaEWrMKn6bIcFRS63Lfn4Fxme7s54Kl8KcD5yQC+8XcEwxEVBMgGhUMCxd32v3hk5h+ly0D8Sn1HKRwq8udNiYbLNi1b0sT2KdzbNAYzwvvwGHaGhoBC4Q02e+HbHVWoziwsS8uWYBWooGgH6V80uilDsSQ0hLzwQ+cpZSWSceyfRk67FZ4bWv3tQz6ss/jo5z0fGDqEYkFhcfadoDig+D3ryoId/AI8eJkcA30QZBnEX17qnE7zvkEcA83z813uBkjNbHYnYNOtI2mTeJ33eXhQjQyfnSfl+fzXlXnQsH/HA3fs9ZtKpur6FYj7zEZDLP9Kv012D7D9m6viUorav9tTqZsQ6h8uoVYyXkmKhrMs5j28yYvLe94CFcfcOhtW5LKMLSTjH0oN2uF5sFd
 Aur9JZVh
 kRfs1XyDUhVHYzUM9k7AJpC0Xrr0AfdWVoQxu6wfwrb4fWAytTgi6+k7jD7aTub5mUwsyL3SKzPCkelwZWC4lO4W9FA2GIm9TzLzcFQ8ERWfPTgFSI4KOTGnussct8d8WfAJIF8AEfofwt23cAL28MCxa2RczJ4HK+yHyZWpcyyG2aYS1bFMe2bvpke8Rcie/x0VTo9Dzs3iQClrmhCpmMfo6Ve3byR9h1rVo6pcuJ/1joEnly8959+D4IWeLQ64e6z/hwWSJqE2RMhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/06, Christoph Hellwig wrote:
> On Mon, Apr 06, 2026 at 03:49:40PM +0000, Jaegeuk Kim wrote:
> > Let's check mmmap writes onto the large folio.
> 
> Why?  And how is this not breaking applications?

Since we only support the large folio on the read case.

> 
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/file.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > index 2c4880f24b54..edfc3a374c40 100644
> > --- a/fs/f2fs/file.c
> > +++ b/fs/f2fs/file.c
> > @@ -82,7 +82,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
> >  	int err = 0;
> >  	vm_fault_t ret;
> >  
> > -	if (unlikely(IS_IMMUTABLE(inode)))
> > +	if (mapping_large_folio_support(inode->i_mapping))
> >  		return VM_FAULT_SIGBUS;
> >  
> >  	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
> > -- 
> > 2.53.0.1213.gd9a14994de-goog
> > 
> > 
> ---end quoted text---

