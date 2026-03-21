Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD207109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7086B00EC; Sat, 21 Mar 2026 13:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 187FE6B00ED; Sat, 21 Mar 2026 13:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E146B00EE; Sat, 21 Mar 2026 13:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED20A6B00EC
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:48:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 630FF8BF5F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:48:48 +0000 (UTC)
X-FDA: 84570805536.13.F2A423F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E8577100002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:48:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Sx6HnV4i;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774115326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/X6/ebGf8UYIFVhst4O7aixITM5ZuPLWY7tc1neX8u4=;
	b=LGVXdobNFjtlzyz/UTOCZzMEt9McSovguOCJrRE/jUdczaDMC8IcD3YduFEO6tv+Ff+o//
	SEj9kSH157rtRJ8yqnedE+vGE0fBL0dcHKQsfNSC6gri1h26zCt5EFaAD84jjV6ayPdt/l
	c9HLuT24sYXnxw4l6EB+yovsSda7wSw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Sx6HnV4i;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774115326; a=rsa-sha256;
	cv=none;
	b=sQRlD/PctIJvIEeykE2ctLbTQrWLIE9I1/vPM5k9EiaT0XazXRdpfc/on/Aub/VQYKRMK2
	9/yeBqXwjBlg9GNciYGsEvafi+IYdaEJY9uP//fHhNw+ohNKUce2oAEuLTpqEf3mYSi0Ts
	5pmVQmkFe1EUlLovk1i55Dat4Akx26I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D42760097;
	Sat, 21 Mar 2026 17:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D067BC19421;
	Sat, 21 Mar 2026 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774115326;
	bh=Qn4P7Wc4x9kE+8cjSdoyrRePaM836rZYOOkl0UskwA8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Sx6HnV4ikhL/5tAaZfzi6fJisvDZEYEM5Rrzj6ruCxcBze/Pc+Wi4CFBK+cBCy3Dk
	 /Vamp1P92kLM0RtY0+xRv4W7fZpWQ7bpQwG433W1oIykfKFVeBjAxnoQx3guPYIzI8
	 0OC910ouGJjPsbhuSVs39aStHV3ESa1nNtykqlaA=
Date: Sat, 21 Mar 2026 10:48:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shigeru Yoshida <syoshida@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky
 <senozhatsky@chromium.org>, Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zsmalloc: copy KMSAN metadata in zs_page_migrate()
Message-Id: <20260321104845.452d0f903a52d45d3b76894e@linux-foundation.org>
In-Reply-To: <20260321132912.93434-1-syoshida@redhat.com>
References: <20260321132912.93434-1-syoshida@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E8577100002
X-Rspamd-Server: rspam08
X-Stat-Signature: 1pidj4bgaz578jip3159xnc1uqixbfww
X-HE-Tag: 1774115326-93938
X-HE-Meta: U2FsdGVkX197OJaX/tWwWNNScWtjwMyCpfuJW+srfzpykd4Ude1nO/SRfIbSSn7XA0b8Pu1bwWyBOGiSnXSikmWK8HXTdV6EdSPbCdJ7Iee6CXmYOqHGCnhqNNlkiTbwq7H0g/4oX9Ouvpr3JesFQW7X9uR8hM+kFP1lzUgfgDN3OIV3i48Yt0bN+NfxKVAZE9O7bolNuXN0YeBHJZjnn1vpEPDtVCQa6waW4CtAUG1HKa4O8bz2/0h7bch8NI2S7joaKoVys1a1H0g/GV38o0nVPf5RFoVxe+PieaKNhb8XJhKPuHkmy02OpGk4y+DX3Z+DbWVaa/+LM/xMCbW+pKKG2pvrju45Uu+ZqsjaJMZMS8xwlk7lfxTM+rDJKXNAgFfrhdkq0jvKi9Ym1QhbwyLr07MJecq/mHg3kRlqysbAiq/sAC56yEkQwckHl/u3fsZ0wXlY1mY0J2QlOCfUK7a00a2CrUbbtMOry4cJPkBPGeQpWLGrq31l00LU+uFJqbS7h8w7E86qKmVcKqoX9EpcfVjIPlmopvkPnOJmxW4VX2d0jHuJ/uGhVbqdRxSS1boYJ8sANTZ+UhvdR0yJDFP8FYUHVMtHIlVEvq/vRTG0skNnQXX7T/E9yqhCTEl7TQ0UkeJVYZ87mObn7Iuq5VDR8NBUQ5iFNcA5LtyWIbjMz3UOI0wAmASVoChrsyCF/bva9cXfpiEOsz2bkaH/iX5f+rHAHqslhxzGCxT8FOl/+nSy9rOI0GeAEHdM2ue/PeCUC5+F3ea92d/xvTJh1CmLURMvViMZsWnsdVkp1lKaG142JoXdfmnAZmQPG5N6Y94gWfGOwX35ucPAWpnaXCASNoR4mwWxRrk5vwdIw/DRfHK1O7+mUU/8FofxkLh7W/8bOOiu5CnROFEvlb2aUvV6s7CW4QDqbzhOHZ39TqPhrW9Rx4NDHgm6Nfj2tuSCvwn2W8dNBtlUwmKWNtG
 xqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 22:29:11 +0900 Shigeru Yoshida <syoshida@redhat.com> wrote:

> zs_page_migrate() uses copy_page() to copy the contents of a zspage
> page during migration. However, copy_page() is not instrumented by
> KMSAN, so the shadow and origin metadata of the destination page are
> not updated.
> 
> As a result, subsequent accesses to the migrated page are reported
> as use-after-free by KMSAN, despite the data being correctly copied.
> 
> Add a kmsan_copy_page_meta() call after copy_page() to propagate the
> KMSAN metadata to the new page, matching what copy_highpage() does
> internally.
> 
> Fixes: afb2d666d025 ("zsmalloc: use copy_page for full page copy")

That's three years old.  Can anyone suggest why this has only now been
discovered?

>
> ...
>
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1741,6 +1741,7 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
>  	 */
>  	d_addr = kmap_local_zpdesc(newzpdesc);
>  	copy_page(d_addr, s_addr);
> +	kmsan_copy_page_meta(zpdesc_page(newzpdesc), zpdesc_page(zpdesc));
>  	kunmap_local(d_addr);
>  
>  	for (addr = s_addr + offset; addr < s_addr + PAGE_SIZE;

I assume we'll want a cc:stable on this.

