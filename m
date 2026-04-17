Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B936F436A3
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 13:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C426B0106; Fri, 17 Apr 2026 09:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C55F6B0107; Fri, 17 Apr 2026 09:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4B66B0108; Fri, 17 Apr 2026 09:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 470726B0106
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:35:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A29A5B5C4B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:35:38 +0000 (UTC)
X-FDA: 84668145156.06.8D41238
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf14.hostedemail.com (Postfix) with ESMTP id 48C40100014
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:35:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=cdK91qmU;
	spf=pass (imf14.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776432936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TiVTfnuvDojoSoEcAQ5Uy/PD0MLcQeI46LN0hZrAiWM=;
	b=wJfO5Y6Kumpr7zMjGzRkLHHOUhJA05kvlhmV7N3LQyn8IYeMwm6T/zLOV7wKOJt8Ce+mqO
	F1eYFcJOK+EOIdxSpimW5YhZp+GmHYDcfSLZZMwNy3si4JWEu45SiCeufAut8ZeH6SsNrT
	GWpJlIY99z0m5ewi12KOQZzYtfB3o8w=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=cdK91qmU;
	spf=pass (imf14.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776432936; a=rsa-sha256;
	cv=pass;
	b=2uhUoDHGahxuC6FHLpt/et7g1yDUASIMR/VFQRF1R50oCl0K8eHV/7gN2n1kiWuHSh9dCJ
	lU0mDg8iE/0ycoqo/wyWnW6gOkAFTDK8thcpPlMdH2QIAp3nx738xEImDpbUjiouvkWX2a
	BXUGW++vmgMVbS4/isQPzOZX7zcFVZc=
ARC-Seal: i=1; a=rsa-sha256; t=1776432914; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=RNlwWYoA4xm8+AlebNPoPsBmJnAuP1CEfzgsBCNbts4CRijr4hLamDaFHMD1IS0++Dc5a+hzpBxirE8/Enl6jWC09Te+wr8fCF5/AfTnoY5j8OiWRssuR4Ng305tNlrNHvNqUrbUBxacKvieiD67+kpP6He8tcKOBYduKKEkKHw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1776432914; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=TiVTfnuvDojoSoEcAQ5Uy/PD0MLcQeI46LN0hZrAiWM=; 
	b=GZd4rW6RM1CQuCBXJNJxFUKqiyiyahFQu6akiHwmwLCE34BIpTH1Dfv8ylsYYIFr/ISWDsV68GduBWi08MmN9F+uDTsdClszjBi4ECJsrVbqjHqY6Ne6aT3Wr3Yc7IyKU1pRaht/IpweRKH9+2b8YeWfjyTLgY6g7kMGtIKncLI=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1776432914;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=TiVTfnuvDojoSoEcAQ5Uy/PD0MLcQeI46LN0hZrAiWM=;
	b=cdK91qmUCuvTc5EaFOr14tbQBd9sfyuIid31yCQcmIEWYZJq80eVANbK+1ueeI5L
	lhNoTmY3LjTlDDJcQTrX0NuHc6iU/Yf0fPxDhjvNESLluwe7TgPKiyTEX4GS/5aICLQ
	+d1cUc8hCWAp45TU0IR97XB9uUrkPVfuFLR5P+hU=
Received: by mx.zoho.in with SMTPS id 1776432910895996.0047809156262;
	Fri, 17 Apr 2026 19:05:10 +0530 (IST)
Message-ID: <85a9f419-7f1e-41a0-9e8e-67aae7a1b0fe@zohomail.in>
Date: Fri, 17 Apr 2026 19:05:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/4] mm/vmalloc: free unused pages on vrealloc()
 shrink
To: Uladzislau Rezki <urezki@gmail.com>, Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
References: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
 <7d16f260-ffd0-4e45-b66e-9e7f71332466@zohomail.in>
 <ad5yE0sgV1HJsyaC@google.com> <ad_cpqx38LtQPlX8@milan>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <ad_cpqx38LtQPlX8@milan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Stat-Signature: n13w5amdzi6ayhmmoh1majertkk68yhy
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 48C40100014
X-HE-Tag: 1776432935-164982
X-HE-Meta: U2FsdGVkX18tcQtA2MJ1gMBzjrg2TuhEf5GSIm8VT023NN9AUbeVPH3/631enH25Wc+WpyP0EymdJJca1N7WrUUu79NGxbLKNc1nmgGqic6NmK32r9CKh3BN6RCx3dnlBttenNkikuGkRBnOTVDDaSWzP+Aa+8c5jlqQoy93241s7Qh8DhN9s7STwoS/XqPyyGGFwiq5yaFVBL7Z8y9Fsi70HsS5EWKySA9S/ZqE1tcnuHKnnCzspZybcrJSUW/bfRPmrsMx5/S3uQOhF/Q8LrqAZJ4H66+wPUGMjBHvahnXfH73Uuu/xAFJJk7kuPvs2Ag9f6sAvjrzJHDMEyrkF4Pi84OrueW4VIo5jMcHaY30r+VQ+TKjmkGJrhHXA8QwlUgeq5vv7p3cAfYshiqMKBlfgwRem6hRfE7YIxuNW9uLhIrKQCsUfpSXrxek0ajTpmhVfeylh1LCElC3apE+k0rmPmSTnv2J9fS9gEEmNiNvdofspnobhs/uP7DvSTNVQvQ6d7WYg4WMr0vC87mGChXhHDh6pMzTmQ1o/cQ8HlCb7HqVLrl+hauSOA/rd5N2cyccHZi8QenKw4mdkhRt+OGZx1/7zPDLz+OWfemquRG4zkK9P04eex2q0yd7DAAlF+vMGEh/r07KamMsZhbyYd/RPGjXpOQ4qWCeG+XmXjiK0tKUaSoz+fdAWsqaK5ArMo8vOoNFzfFwleeI+myKGY9GQGcaJOmvh2wQmnUlxpxWfJ0Axgy51VtUAhEPZ9Mr4SnF+GkhiaA1HYnc9CLZ/NT/+OgGq4HPB6jgWCw56zHEvHCE+GYZuNQ3+CpC2yptzj//r4fGuobVGJX2MkALn+OEtnAbrlckhUfs3MFNUnyGrOWzivOYuaDXeK6DUo0sTpvdaSB+7DRr60JuUT5kY2E38H3b2+DUOdwRgQ8BDVjGGQgziQ8RWN6INEpRHDs/jsnJhNt4hkNgGsK/Z1j
 ysudQjBf
 IaMit1feMTzZi/5Z2FCjt1FYb1Imb4O5CIdJkakv7ac4P7zuLkduUxfrzFz8w+ET6XCKW/pK17fff/W4r1hwP198sSrKo8xHx7l2NqasJX8x21gwI60lFtkIBTNnLcqBtXurJ5O/fNCArln/P2kL+//QiwF/zgTxmvnjg7h5S4k1usmWdH2PXu2GnPlcnWYv2Wg1BIe0KOIQZrpbfkGbCTaW4gU7W19+ZKc/fqlZ//8dl32M2HUlf30EAkpbd1gQFdRPNgJxje4zs4Ld1ZipwxETnWMuC/Qs2K3bJiArJdepu8yVrAZiittrby2kRYqI/XCgmQUU3przfcD52zyAISOmQRioKg3GPZLUNYvTNSrwyt0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/04/26 00:14, Uladzislau Rezki wrote:
> Yep, the problem reported by Sashiko regarding area->size and vread_iter()
> is correct. V10 does not address this.
> 
> I am not sure that reducing vma size is a good approach here. It is
> widely used and we might end up with fixing even more corner cases.
> 
> vread_iter() and vm-size calculation there should be fixed.
> 
> --
> Uladzislau Rezki
Proposed Change for v11:

long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
{
	struct vmap_node *vn;
	struct vmap_area *va;
	struct vm_struct *vm;
	char *vaddr;
<snip>
  		vaddr = (char *) va->va_start;
  		size = vm ? get_vm_area_size(vm) : va_size(va);
		
		if (vm && vm->nr_pages)
	            size = min(size, (size_t)vm->nr_pages << PAGE_SHIFT);

<snip>



