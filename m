Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E9F2109025C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EAB16B0089; Thu, 19 Mar 2026 13:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C606B008A; Thu, 19 Mar 2026 13:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B31C6B0092; Thu, 19 Mar 2026 13:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25D636B0089
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:14:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C468256E6F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:14:10 +0000 (UTC)
X-FDA: 84563460660.13.18304BE
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id EAC384000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:14:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="Jk/VekBp";
	spf=pass (imf27.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773940449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zr7XIjoFEzFLo+wdlJ0zAdxNaSX14JFeqx60xnzIONE=;
	b=1rNkEqJkdm2Sc490PeBfnbE3+tbdR02zFzmxu2D8+kwPNgSBT3oTAK1H2i/tzzSWt143Kk
	B+j/Js5bqSw9csPBHoEmbkhHObW4AWOH1Q5msomLAEVPj0waWV4rWWmkENtUEQKI+8Sldp
	mxbXTnjYVQHH4dGkSF23UQJtuooWgVY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="Jk/VekBp";
	spf=pass (imf27.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773940449; a=rsa-sha256;
	cv=none;
	b=qLjOcragAo9oJXQzRIT+QyFc+892q84Nxa7rQUZSTl7WP2xXtz441Kd7Hhlym9kQh6S8Rw
	E0C0WuSIfcyY4doNVipH1OoQzR5aXOtKHiI8sAcjl4kS6gi+jnUvv2AugjL6jWQdH9n3/Q
	bYZvvXwhS09P65zv7dv0NRLj3k+uo7w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=zr7XIjoFEzFLo+wdlJ0zAdxNaSX14JFeqx60xnzIONE=; b=Jk/VekBp7Mu6/Z5r7C7bfs5J3z
	xIpxduH8DhP9bWUuNhGEiuOf7800lXE5iKBckYqEAR/kqtYnHZLQJXN2XwgOArzn4GFUvsoamYYIN
	YBgxEhxHxvUuWx9LHpIAPoo6A4xwolHV8xeaqoQOILKoJJfFZL2owVypHflCBJyfzxF0GtJc/hx4V
	Jynd1yKmq/txVnwjqPJo0QtWeOnC1SsU219fJdBTisb+zFpXhfFS7CpUSZ9DcEx/DWdXsJNmJrKWZ
	D21r+jyyvwnmfnayWZxFIB5r5943bQyP05iSkMZBLk2wcN3GUHcKZT5OKXaMBx0e9CSaN9t1BsWgo
	hiYxrSmw==;
Received: from [179.93.15.111] (helo=[192.168.1.54])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1w3Gwe-003Qxa-1g; Thu, 19 Mar 2026 18:14:04 +0100
Message-ID: <9066d011-7dd6-4d2e-26b0-72f83d3e5862@igalia.com>
Date: Thu, 19 Mar 2026 14:14:00 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 2/2] mm/memblock: Add reserve_mem debugfs info
Content-Language: en-US
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-dev@igalia.com,
 kernel@gpiccoli.net, Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>
References: <20260318190816.1811325-1-gpiccoli@igalia.com>
 <20260318190816.1811325-3-gpiccoli@igalia.com> <abwlsdgNWtDeasLT@kernel.org>
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <abwlsdgNWtDeasLT@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EAC384000C
X-Stat-Signature: a84nmnb9kmghuchp85ifwb78889bsscu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773940448-399923
X-HE-Meta: U2FsdGVkX18j8MHi86SZLMp7gpLEH+TD8xn94XhNhhuyDRRxoGOf4J8l/gYMpDZqjYtuvMtLp/4AnmEeBSFhSOZq2VZ4kyjNe6q1sIFKOGtZHvgqn4B4uHngKZlUoH8gQddN/QdhboVZNaM8ljpYCCJpzNQqxUNbOhTTp1GZ00BXj4I8FHIW9eQV2CPg40Q+lTzQEqtVYXaJkEyvbRPaF3CF5l+MzUVXKj2Ga9mJej2CMfURoQNXofamgEq9i8jqVycRE0dpbnE2kjPlrkCtjr3pvNQEmTZmYBTSYNsUwX12Sa8X/rihSalnR7Te+J+pe7SNEZgIk9HF7TySvxwzh4QRLAUXswaBjhoStPKXOPiDPx1qIMbkIhU6+k79gJxcVuISreErYO2XWoC2IxGboW4ZxFkUFU1GbOnHA/7ZXZ1TaU8cLffeTeSIiVkFYoe1gBif2f7JXcPDvUBxJdxtZ+LFOTkD03FjG9o4OgaUcm5ZU3SZn9O0/68/+DV6NWcfT1PH0gMY2AWWKueSi839L2mZFp0NwpCDToVYFPvP4wYQSCbvBdeQFchjfPaj3XyvyGcl8/0PDIAyW1O7Ja5qa812QIWrageH0cWHBskGkSpl84B6Kqzucxweeh6MXKfCv85mrNmVF3CKX5xaM83t323+LhJJH0abRJ1wWSdiJljVnDap3cdT/0ETvMG5o2jII0biZPZkoH2gBzt1kRbRPEdKuwBzXmrr+pbvyROWaHGWwqhgfayM3tkMf8hbNLFWo4opjqAIaqe+/jZSmiUXSKMye1HxyYCNGiRR+NVN9UP0njhxRdhiCJS8TOfjQVUFWA5DrF+yCH9DPcBSt8gYMKu/3kSV97lBH2pku74Oh9QSYEfyZJ+/xTzyUtsjxidgGuul3PuibNm5qtBb1iWYLsdbsDGZqwqKOJ9U5m3QvNwllGimeR3TQMnlNwmkItfj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/03/2026 13:34, Mike Rapoport wrote:
> [...]
>> -static int __init memblock_init_debugfs(void)
>> +static inline void memblock_debugfs_make_dirs(struct dentry *root)
> 
> This does not make dirs but rather exposes files representing memblock
> arrays.
> 
> How about calling this function 
> memblock_debugfs_expose_arrays()?
> 

I sincerely couldn't agree more - it should have have been a braino, why
on earth I called it this way?! Apologies, will respin soon...will wait
until weekend in case someone else has opinions.


>>  {
>> -	struct dentry *root = debugfs_create_dir("memblock", NULL);
>> -
>> -	debugfs_create_file("memory", 0444, root,
>> -			    &memblock.memory, &memblock_debug_fops);
>> -	debugfs_create_file("reserved", 0444, root,
>> -			    &memblock.reserved, &memblock_debug_fops);
>>  #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
>>  	debugfs_create_file("physmem", 0444, root, &physmem,
>>  			    &memblock_debug_fops);
>>  #endif
>> +	debugfs_create_file("memory", 0444, root,
>> +			    &memblock.memory, &memblock_debug_fops);
>> +	debugfs_create_file("reserved", 0444, root,
>> +			    &memblock.reserved, &memblock_debug_fops);
> 
> No need to move these after PHYS_MAP attribute
> 

OK, your call, will change it in the respin as well.
Thanks,


Guilherme

