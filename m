Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D3AC44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 176BA6B0088; Wed,  8 Jul 2026 13:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E7F6B008C; Wed,  8 Jul 2026 13:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F8A6B0095; Wed,  8 Jul 2026 13:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4E0C6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:14:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D5FCC15AD
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:14:47 +0000 (UTC)
X-FDA: 84966259014.05.1917872
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8899F100007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:14:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dS1IJg0n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783530885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I81HX2GmopBIWHT1e1Dpw4r52DG7HH+WAATQwe2SKiI=;
	b=SqMu/+AMKQOFoWKAeUgEn1Gu10dzasZN6RHfqQX+hhJp9x8oSXNTXpM4sFfFH9aRACvPJu
	zkSoAJRulhVXj6veyV/1UAYC/5eSXuRwimKPovTXHIgKE5UDKsgOZLaqvIX7FTD/QqkhOg
	aXuMgvKebH10GLH48xAEHf9XDXTC5bo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dS1IJg0n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783530885;
	b=heA2xpUTpaW6WVg/beI37GHjTfenoMnsKDHmTDyiVOp3FlbqX24ykjgYjaqf1WfnnyaTf4
	QNOllfG22cCQl14mDBFSxnrK/X5/aKmA3DIDUiRX0w8OsOTdc94Awt17/BM/KBmRn2ZMEh
	iSclliRuwS8ueLy4KCMpm0JFkrT5rrc=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cacef7d299so2555ad.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 10:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783530884; x=1784135684; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I81HX2GmopBIWHT1e1Dpw4r52DG7HH+WAATQwe2SKiI=;
        b=dS1IJg0n+IftSkT/S+PBXj6wTuWOu2U6CSjdDnZnFjZhWcCtXqiL0O0kWTecQMF3ZU
         uWnyTx8gJ01xdROVSpwSRWJq4zbzY+CUof7/YJkf/EV0R9zV+m6Lkhwr/eRmXe/V/Z+9
         JRFDEMkMkAw+pIjmsdvPVSoSthGNcBN1XSmpYvukwwXSN65gUTiWoWOArnsHIAItuEle
         adbmEl+vUvFTTVS9am+lgS9FlaESSw609o8NzKT1+/bmnW8W7W4qS+glqLu+FjrnJJxP
         OE9Zyg52hrgeXE7sE2Z6EbLUieSu+Z+vasF9l80nNOY9VoZ284IasTjP1Y8maJ7qcFUX
         zUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783530884; x=1784135684;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I81HX2GmopBIWHT1e1Dpw4r52DG7HH+WAATQwe2SKiI=;
        b=O373WijzAlEngAzkQV+HtiVb44Q+1lnBtp/Lw0qMZKBGGrRIRfh6AR+drmYRZa4EHx
         SpSHftcp5Y4NazVDleiHTMzgAmQl+U3hamdyXYBfOzSYdq3xWbdAXTncJIVQkQ+L8PXX
         xZfqDSFBHFt8hjBT3FdBKKHUd2IbLQvmK7FsoGpT88zjZtZ855nNmuEKKTimpRPj1CyB
         s/xgE7pbQcETqfaM9JDyb1+8kFwvG5woez5WbDOa1FzvgRKoITlUx15MFCGqg3EQRaE5
         Zik/3nqB2vcaUGPssWcwuwfCDTd200GIfJ9e8I2WuiRP3SJs6+ag8E1DlaVpAt8o9h8+
         /4BA==
X-Forwarded-Encrypted: i=1; AHgh+RozxYEMXBjIWpcF6X1fpeXnurhIi587eJ+k+q57N7HvNNCyCFlc7MOxe1xk0/oTj2iwPvvvEkGOBA==@kvack.org
X-Gm-Message-State: AOJu0YyMNVkSDVdpjGgMsquiZR0GUuVwxUk08R+OGC/CmX50U5P0rWIu
	fT4QD0FMKaepAnS/xxKZnrK2IrDke5saVmQnFzXj07g+p34vGauwuYpmSaHOlwRdog==
X-Gm-Gg: AfdE7cm1e4l7z7YFcz7tc4Z3X28CQbbGbToQlJjcayvnoZNnBK44mUQUoxiC0BpFDQ5
	PGjR2uSXiTPWf0C8oLPAhwNjpBH1WGbif0G5m3thj9zsIAE9YlIggG9a73+91xBt1SfUUS0eEbe
	u2Sk8ALKzbC4iOv9eNc4Oi1vdKBPXhtfkDu7JlHc2FM8ou6EjvbJmhEzjkufflhExkrU0RVPyXu
	AJtljER09UY9JVuESf2T4G94nbZ3bab1irOSeaMKHDRwdY+kQL8OZ9h/viSMACcp0p70LY7lDbT
	c4n+T71jtETcRSnPEyZxZFv3mlxW3LhyK2vLu1e/sKZ5N5bWyeQTVFMNelken/fa39fBApw4uBC
	d5LZlHvT5BuGoURoyttr+YcSADH17nq10j1Y9iqiIla+UB/yU9NeWBdnJGnL6r2UacvxOLxRacU
	36xbKFOssz9P2A85qLu8nJdZU584RJDnZbkwOhrgv91MCZnRr+1ApKxlsdEShwu0O+poIGG4EiC
	JlOexfOjbs=
X-Received: by 2002:a17:902:cec1:b0:2b0:b0c9:96e2 with SMTP id d9443c01a7336-2ccff91bcfamr243315ad.21.1783530883940;
        Wed, 08 Jul 2026 10:14:43 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b6162esm7529105b3a.11.2026.07.08.10.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 10:14:43 -0700 (PDT)
Date: Wed, 8 Jul 2026 17:14:40 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
Message-ID: <ak6FJf8jUGudEw0c@google.com>
References: <20260703020832.1731864-1-praan@google.com>
 <2vxz7bn5mv0n.fsf@kernel.org>
 <ak57VeunO8qd4wEh@google.com>
 <ak6DUC7NsIZ20RZD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ak6DUC7NsIZ20RZD@google.com>
X-Rspamd-Queue-Id: 8899F100007
X-Stat-Signature: iy778uzprpgibykte7i15w1npwfizkes
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783530885-637531
X-HE-Meta: U2FsdGVkX1+2Z3Qt03ItLQmjER0QEyvoy+vts1qLWtXrNHNS66Y2gvVkyGY7kkwZM9fiytNDDyGsN0gSJVlQlbv0VuyWyyzOqYDnNjJlakCXYp1GTDNxKAqw8xc5kk3pkbgvYEue+wtCDf+d9yj+GuD+Pw1+rQXpKa4ILiE9GuCYHv17lGo1bsbZyufm09Ns9adOwOvcA+NpV9zu8VGLN5FD6bXZLexclpPomQdaqzw582uFNdEl1/GZzTKjTKjW92RIWV7glX0LsgxYlQ172c5wAZN3ARUdX/24kRV77jHtPFGsfc4lflRkiFpul08sTz9dp99O9dlMhqiMu42jQDCBHSFsvc9PQ4Frcr3hdxg9qN/aKhcJO//snhCGKYeOzDFtZW5LXf8Vm2tHVPJRWVc6CTddVFp6woDO1EUHY8Y6LrLcSqI39vw0ln0nCeAmQsXFzEm4czyLDULv2HQN/LusBHhGgryppIaTYOlbSbwbj4HljdKW4pGoGk6qGkC2rgjJojez4CUw0kCP/rCiy6QJHVy3OoYjhEWie2Xh1RpWCT/xr3RuUoCqlxSwiE9zV8q8S4ipPXc338lxqZw5NfP7B+w4W9VoqpAuF5K3xJg9HvOiMk30cwvCJ/VwHR8qumVroQL9r0vqvhRkjMox6FPBimQBT4F8a+Z+543O0Dvtvw5Sku+zFMD2ULuhn0bHsJoxw9t46U7Wv58C38JpLGuAzd8W6zk7wBU6XAdWQ/NlmcJFLwYJvtV0zr5q3iiq5P9kC0NcpFMBpQslI4qm6TRNncOOVzYJoFpb7qjxrWAStjzj193Alca31OtjsHYFzU+MEj3Q+2klEaz15e2PCFK/NlfC0N9I9kRe2ElcwoVUSbtaNwmKN1/FKQXzk7bWgJ9Yxc3DqIlFDIbxG/qjSwDE22+vl1ogCmyBxJzR2ruTQUfZnpvIQraJDWTSqXufhKFkxwrEJNNs7NQ3N4T
 oT3tB8+7
 RJ3f3psykVxUVX9dsJT66HhNBtaxMUGr4ARPyEIEVV0U9eU3mwBv3stPJQOJNwroeGwVN/d6EJ4nKqylycls9coD8Vq/tH3mmpyj1+TV8bldO4tx/Pagixy06bhA7357XygyvsQcq6lsJUW7j80R0k008gwt2AHM/IUArhNktN2urPT+oBO8DaUkz+ES7c4+xKO7YRDsrOhji1XgPOXVi7S+z//unqp021lH8HzjU/heyaEKZT6AarKyNMzUZziNQSsB8pF6n6mLqVvGzbf7y7k2zB5RbvszfSfliaE2cSAe+sjuHkJIyh1by6Qe24SrywuDkpNlI8Z/K2i45r1Q7/F6/lP+Ofb5fafEXclH9c8EeDhM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 05:05:20PM +0000, Pranjal Shrivastava wrote:
>On Wed, Jul 08, 2026 at 04:36:46PM +0000, Samiullah Khawaja wrote:
>> On Wed, Jul 08, 2026 at 04:11:04PM +0200, Pratyush Yadav wrote:
>> > On Fri, Jul 03 2026, Pranjal Shrivastava wrote:
>> >
>>
>> [snip]
>> > >
>> > > 3. kho_restore_page() applies the correct refcount pattern based on the
>> > >    preserved metadata.
>> >
>> > Why do you need to save the type of pages in KHO metadata? For example,
>> > for pages or folios, we don't store any type information and leave it to
>> > the caller choose the right API. So reserve-mem and kho vmalloc need
>> > pages, they can call kho_{preserve,restore}_pages(), and memfd needs
>> > folios so it can call kho_{preserve,restore}_folio(). The radix tree
>> > itself does not hold the information. The caller knows what its memory
>> > is supposed to be so it calls the right restore API.
>> >
>> > So why can't we add a kho_{preserve,restore}_page_multi() (pick a better
>> > name; we can argue about the naming later)? Then your driver knows it is
>> > restoring DMA buffers so it can call kho_restore_page_multi(), and KHO
>> > takes care of initializing the pages with the right refcounts.
>> >
>> > You won't have to muck about with the ABI in that case.
>>
>> +1
>>
>> I think this makes sense. The mm already relies on the allocator to
>> track the type of pages it has and expectes it to use free_pages or
>> put_page() or free_page(), so it is natural for KHO to rely on the
>> caller to call the right restore API.
>>
>> Lets add kho_preserve/restore_page_contig|_order|_nonsplit and the dma
>> preservation can use the appropriate one during restore.
>
>Ack. I like kho_restore_contig, I don't think we'll need a preserve for
>this though? Preserve doesn't seem to be preserving refcounts, I guess
>we could rely on kho_preserve_pages and the caller can use
>kho_restore_pages_contig() to set refcount correctly for unsplit pages?

I think for consistency we can add both, even if preserve doesn't do
anything special internally.
>
>Thanks
>Praan

Sami

