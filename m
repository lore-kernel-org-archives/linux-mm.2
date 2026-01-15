Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70EEAD44C59
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 15:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82546B0088; Thu, 15 Jan 2026 10:12:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F906B0089; Thu, 15 Jan 2026 10:12:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10F66B008A; Thu, 15 Jan 2026 10:12:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D6C36B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:12:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4777DB8FA2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:12:12 +0000 (UTC)
X-FDA: 84334538904.27.75B9731
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id B337C20005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:12:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Oe+Td0k4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mx9dEdlM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Oe+Td0k4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mx9dEdlM;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768489930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=elMJW99Aqg4ZRWyy1Tm+k4UtFI51uPd4F2wPebrnoJE=;
	b=cralG0PCUQQzoEFR1IaLvwe+KyB6cLgpcmYru6HMmvFXSglXaEMFIQUwAZNPupKwgzgaIB
	Q/riIfVmcYyBirfiKAzP5s0jph0kEGgcHApFmcJmxGq34p0Tn7zYnyHQTkWmcIkRdy1+QV
	r0XKeT97yPelyUNuvxGAx1cDK8RZlQk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768489930; a=rsa-sha256;
	cv=none;
	b=AafNIZw/JX+yS5J2q68JD0b0k0PDsP+Q6ayUh9cL7VdeSSiA0dXLpr6RMkk9uDNNkDhdub
	WwnL42XshuQI6tAEH9dIdnsqXynyFXshIUsn4lGhPu9LLEC0ArYfS6FaeBZAfhxAjVdTd7
	aBWTOv2RIjt/mDuUp63U4fcnvRo34Kw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Oe+Td0k4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mx9dEdlM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Oe+Td0k4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mx9dEdlM;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 180513378D;
	Thu, 15 Jan 2026 15:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768489928; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=elMJW99Aqg4ZRWyy1Tm+k4UtFI51uPd4F2wPebrnoJE=;
	b=Oe+Td0k4siueCAsRxJcSWG13AYEwgZmBt4MjPLn/ErgQduOdNQaNeDReMgziQyt9VPjEBQ
	/e/rmeGCyEW+3bRMbDEKEWZqWgu549BUF3/Dxrj/sgu6iNi0ccSK/ehNgwnx/IhVI2AkMV
	taFoo144FRRkvT5LEj852ZaeOToQ9WY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768489928;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=elMJW99Aqg4ZRWyy1Tm+k4UtFI51uPd4F2wPebrnoJE=;
	b=Mx9dEdlMxlDTajoEmQddG6KEWY6qemdZVY7P0pu/xijFOWgmODVF1WXJnAb8iqS0NMCjyM
	kPh59yqkbDtbNoCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768489928; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=elMJW99Aqg4ZRWyy1Tm+k4UtFI51uPd4F2wPebrnoJE=;
	b=Oe+Td0k4siueCAsRxJcSWG13AYEwgZmBt4MjPLn/ErgQduOdNQaNeDReMgziQyt9VPjEBQ
	/e/rmeGCyEW+3bRMbDEKEWZqWgu549BUF3/Dxrj/sgu6iNi0ccSK/ehNgwnx/IhVI2AkMV
	taFoo144FRRkvT5LEj852ZaeOToQ9WY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768489928;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=elMJW99Aqg4ZRWyy1Tm+k4UtFI51uPd4F2wPebrnoJE=;
	b=Mx9dEdlMxlDTajoEmQddG6KEWY6qemdZVY7P0pu/xijFOWgmODVF1WXJnAb8iqS0NMCjyM
	kPh59yqkbDtbNoCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E790C3EA63;
	Thu, 15 Jan 2026 15:12:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vcoBOMcDaWlcEgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 15 Jan 2026 15:12:07 +0000
Message-ID: <8c508b65-3b80-4b91-afa0-145b44686b6a@suse.cz>
Date: Thu, 15 Jan 2026 16:12:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/20] slab: replace cpu (partial) slabs with
 sheaves
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B337C20005
X-Rspam-User: 
X-Stat-Signature: hf7uo866kxbpcnagy3rj37s77buuwy8m
X-HE-Tag: 1768489929-381124
X-HE-Meta: U2FsdGVkX1+AfPT50bGdp+2FZNS/JPnGkglfGMSU3poO6Dm37N8OkupedmqaRdWw1HbpjmYO4UgFCYkttxq0g97npedRPrkwLdbUJ/tm7jZp39EjsA73Lv3vy0pGTpF4DznWkH5b1vncCFmKmjQGt+9Ljmqk/LtCtgf2BypjdsSUzcF1doq5hgoTdG2uGtyFFtQLmI2srPniQ13PGOy2+7r5TnkCb5lCVykrNHLSV0f/nD8w32PerOwplRFBeyu3t8dWCU63l5ygL5+2s2KL6x0vzYGw/Y92GIkWjlxbW0Ano8fgZEZbNO/P2AflRdmNitCw9mF0tVQejwhKxzfeWUz03/xmnHAc9RhHcu9wjuJZbmt5FUK2cFTiIlW8H4BOFDtlNI9tCs2yp08X4+O0Rk/xP7y7jRXsS19ZXJg0+O7R05UBGXVh98aWCDNNKcz8vJQ2GZSylt29QEwK9qn9KIr71UqlMZR+IpRAKHM35RDPPtIKmQIp7RqHdVbo7hMEBiwT72RtrmXZSyDeem/IAgUaVqUTnIyWrGwptui/lCer6ymEHoSBr1HL/xfo/0GlTpnnoBVnGnywSb0VtbRTmQimFRK2tfo//qZQZHI7D1hlx9pe1uYzlR6yASpKL+WMdSnWd2EIK8vfzDoHmiNLDYZipb/3S68FP2jPk9RLDXcETn+dul3kySWEtVKl3fsgbFCB6g/igdQyQPKo1KuxXaLTLC9RTgsMNRl2RAg2ff8ckbHHUpAgKfJZirImRmaV2IsgWIBxzSCnx75QSLV0+cYW/AuHkmfSWuQLM8dk/NdSReGsAG4C0e5MQ0xMRWRh3V77NwEYqKPMqXOLzf3oGKUYflJW6Yn2k5nUj0erVM4/kJRRet4GFXIrw02CqPY9Yehb1u3YFrbdXIL7qLoRTvB7H++9CONWIbBv0ci5H1xwQTIHAJAZxlF7gi1lZSH3bSduszV+B3zstPbH7fL
 WDseartZ
 mc+BzbLc02UgXa/QZv0I6Big0oL0RcbRiAupSz0uzpG82eHagoeCvbbVDoG69J/Gzje04kead0ktP39lC4fk/aeToI8kqINAqjUqidaFPN+EqH3s+TU9oeo9MlFJ5Veswy3mcA3KVHAk/TCnDO6M4QQ7qj0eoZLQYmJTb5jk47ZdtSWGoGERxYnnDcn7JP1QbxoN2KbAW+61XC738Gx7HJCExgrZb1HiJpArjT6F3C+b9dvzqY1aRmTgwX+yeu+8gNOAHLVlN2TzC1feCd5un+pwI+BrFLjT9WX+YjlEqFzaXnZ/r/6AYkggNww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 16:16, Vlastimil Babka wrote:
> Percpu sheaves caching was introduced as opt-in but the goal was to
> eventually move all caches to them. This is the next step, enabling
> sheaves for all caches (except the two bootstrap ones) and then removing
> the per cpu (partial) slabs and lots of associated code.
> 
> Besides (hopefully) improved performance, this removes the rather
> complicated code related to the lockless fastpaths (using
> this_cpu_try_cmpxchg128/64) and its complications with PREEMPT_RT or
> kmalloc_nolock().
> 
> The lockless slab freelist+counters update operation using
> try_cmpxchg128/64 remains and is crucial for freeing remote NUMA objects
> without repeating the "alien" array flushing of SLUB, and to allow
> flushing objects from sheaves to slabs mostly without the node
> list_lock.
> 
> This v2 is the first non-RFC. I would consider exposing the series to
> linux-next at this point.
> 
> Git branch for the v2:
>   https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=sheaves-for-all-v2

The current state with collected fixes:

https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/sheaves-for-all



