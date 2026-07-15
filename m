Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E57FC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A8D6B0088; Wed, 15 Jul 2026 09:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208966B0096; Wed, 15 Jul 2026 09:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A58F6B00CD; Wed, 15 Jul 2026 09:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4CB96B0096
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:37:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4CC7FA012D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:07:55 +0000 (UTC)
X-FDA: 84990736110.08.6852808
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 560D240004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:07:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ai83GQU1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mAvO173l;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ai83GQU1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mAvO173l;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784113673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nioUefq1xbXjtodWxvKxZTWQPlbxpqryGWIKwDtgw9w=;
	b=e6dWTOva+AZu922HY6XZCOPmtQfoumyZuWsNN+kdq+UZR6q9knPSWn4v+6eJtTMlX2ejKV
	R+Cv3GIAPkr+lNqS4PnoMvU+mmtOGKBcaWIqvGvMbKXI/Wt8MmFKKwkLzheHOhKqI2Wh13
	6hofW3RCTnngSx9xLs1ifs8f3luaeeY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ai83GQU1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mAvO173l;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ai83GQU1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mAvO173l;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784113673;
	b=X0sgYqFGIEQSg1bh3DaOp+LsFT8NCUPxMEC6r/UcQ7MCVk7KK4yOaLawWHCPMBOHpnhQaO
	LtjGqSIxOt0PcnnMHqIOGpX2yZ+0belcjt5vPIoZLVeuB/7miVlGWQsLKLL8gSjD6cdLky
	0eqONCWiJOQRg82y6KM2J8eXQcKSFRc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 07A567837A;
	Wed, 15 Jul 2026 11:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784113672; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nioUefq1xbXjtodWxvKxZTWQPlbxpqryGWIKwDtgw9w=;
	b=ai83GQU1QSLW4HMqQLHqkTNNKJcdnVJeYTkcJczwLEkaWbE4HH08Sgzz4Zi3FfHHLXKF0w
	BUqWf9xtp+Poz7MSTvJxVILX1rJ1fg0J0/12EhNSXj8Ts27FocAgBdZZtHRJP2E0SYcjVW
	dRLsXyhi36zD9Vi640oinf7YuU/RvAU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784113672;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nioUefq1xbXjtodWxvKxZTWQPlbxpqryGWIKwDtgw9w=;
	b=mAvO173lFLygJBfvjytDRj9llSE+d8jC3KzkTwirCPAfOhdFiZxPmaq14VxHUPIQnWNtTe
	BMuK6oUQqZjAcqAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784113672; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nioUefq1xbXjtodWxvKxZTWQPlbxpqryGWIKwDtgw9w=;
	b=ai83GQU1QSLW4HMqQLHqkTNNKJcdnVJeYTkcJczwLEkaWbE4HH08Sgzz4Zi3FfHHLXKF0w
	BUqWf9xtp+Poz7MSTvJxVILX1rJ1fg0J0/12EhNSXj8Ts27FocAgBdZZtHRJP2E0SYcjVW
	dRLsXyhi36zD9Vi640oinf7YuU/RvAU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784113672;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nioUefq1xbXjtodWxvKxZTWQPlbxpqryGWIKwDtgw9w=;
	b=mAvO173lFLygJBfvjytDRj9llSE+d8jC3KzkTwirCPAfOhdFiZxPmaq14VxHUPIQnWNtTe
	BMuK6oUQqZjAcqAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E927779AE;
	Wed, 15 Jul 2026 11:07:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iqBNAAdqV2ooAwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 15 Jul 2026 11:07:51 +0000
Date: Wed, 15 Jul 2026 12:07:49 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Harry Yoo <harry@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>, 
	linux-mm@kvack.org, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH net-next v3] net: skb: isolate skb data area allocations
 into a separate bucket
Message-ID: <aldpAY6nXwgayHL0@pedro-suse.lan>
References: <20260702170728.168755-1-pfalcato@suse.de>
 <04debe19-bbe8-4b5f-9668-753d1f97832d@redhat.com>
 <ak4w2k4Woj55E0On@pedro-suse>
 <529e3997-d26f-4d8e-ad90-3329fe90e555@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529e3997-d26f-4d8e-ad90-3329fe90e555@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 560D240004
X-Stat-Signature: bmak1yy7er6i8neocsxpd8yfii887hp7
X-HE-Tag: 1784113673-806502
X-HE-Meta: U2FsdGVkX18Kk95VLyy35uA6XxIlvnEDzclm4PggErozLyf8W4i4WNH5tNIS+f763Jxv3RXJjq/tRX9SROiutyTnETL8S5Ibb3ZKW+wPR83rt9Sv8JQuPIBqi6KdS5Twm/bKZlfPK6hHZkjL9N8KNTKT9tp30qd90cgThTebS0vtZHhyjfeGgEo7AC/4ocONNlhqfZNLcHOHdnh+G45+N8Eucz6Vz8hUyMqqvPRWm2Pje5jGWm/PiZAzzZvz6/kTMYyN9k2/cfQw1rtZ0+6whPKgz1cOKIKWfD1nGFNzXX07u7UR91L8SLRW03g3fVQc7FUSnmgdrAUFw/RbDZAyFE1tjSdbR61kizfiRlqtma6wMfg7WsHZGvsYUUoHiiQn5tT9WoDW0JlEAA1qEB9AdpoUZyYPAHkEYA/39HMXdyjtjctMomDfJRJ4MySW/eb4F/c4UWo6w7vj8qO+9gpbLbaziMNSjgtdDbZOlG4autio+D33l3kyyXb0YCk1c9vTm1I5ttVu8wpzp7RoNRo06+KaF6ePo0jCNLkTVGDGN3gnL1F1DhLJ0W5SgxA2H5Ep4DS+I3QuF4xTuy+K4cLMhBMogRtjFfDJLsqpfPpuO9JHiIDjfvQHSbc+R5xqAfbHAF1cMn6O1D1N1H8VHraPsuxzxR44tenCs6PB/HpywJrRRZ26CMYRNWtSKLkaeK7TDL7oZ3SAlpgPtWeWVRj06xLr2S4gakLYIVaVc6AHjXYsn2Uq5XOEi4bQgsBD0LntNdlk8tXGh6Iea1jWYmW/m1FQ92aYGgl9lYCMElBhCQX4988ncBG9ip8CX3Z5i4OXMfXrOri4bHHyO38kyeaN13GLp729LuMTIbs9YMwltM4f2ILInMKg3grP4wiTR8yWT5JyxepR5rJT6vgf5BmamSXSes4qWoteebz4lffNqaiVesQdV+j7uNKTe107r33jg2A/o6xAICR4Oe7GpiL
 soeHEUKJ
 RiqvQSKbJjv28GLixH1Mf45tu0f4+Yi5Got4ALFar/O6w7s51vzcdN4Q5s5sKltDnJtzVjWRdeHF4XOG7Bim1EA8mRIxZDGPGRgnMTm394hMdgzZn2D+u/IP1KtKeDUufooEsxN9PXLOVVaVDNWmls7soGGQs9SPb/AaASUCRaLCvFLZOxzli3NrfV5XW6wi6aUOiVBXCYjhQWKWC67eA/0j2jRoPs7ns12qz83yPkq2ZKV2KpZ/gSeuHR1dN3CQl6NWyouG6ug4+9Hak/5/8Gm9hR5Fg7HMlgDOCnmrlZRrtTbzTqsi/plxzazJIEWVPGjoHYghB/rMwRIM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 10:27:54PM +0900, Harry Yoo wrote:
> 
> 
> On 7/8/26 8:16 PM, Pedro Falcato wrote:
> > On Wed, Jul 08, 2026 at 10:30:50AM +0200, Paolo Abeni wrote:
> >> On 7/2/26 7:07 PM, Pedro Falcato wrote:> @@ -586,6 +586,8 @@ struct
> >> sk_buff *napi_build_skb(void *data, unsigned int frag_size)
> >>>  }
> >>>  EXPORT_SYMBOL(napi_build_skb);
> >>>  
> >>> +static kmem_buckets *skb_data_buckets __ro_after_init;
> >>> +
> >>>  static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
> >>>  {
> >>>  	if (!gfp_pfmemalloc_allowed(flags))
> >>> @@ -593,7 +595,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
> >>>  	if (!obj_size)
> >>>  		return kmem_cache_alloc_node(net_hotdata.skb_small_head_cache,
> >>>  					     flags, node);
> >>> -	return kmalloc_node_track_caller(obj_size, flags, node);
> >>> +	return kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
> >>> +						    flags, node);
> >>
> >> Sashiko noted that some drivers may require GFP_DMA buckets, and the
> >> above may break them:
> >>
> >> https://sashiko.dev/#/patchset/20260702170728.168755-1-pfalcato%40suse.de
> > 
> > Oh, this is really awkward. Adding linux-mm and slab maintainers for input here.
> > 
> > Considering the current slab bucketing does not seem to duplicate DMA or
> > CGROUP caches, could it make sense to duplicate those as well?
> 
> Could we specify what kmalloc types the user needs when creating
> kmem_buckets and duplicate caches for the requested kmalloc types only?

Perhaps. But do the users themselves know? alloc_skb() allows users to specify
random __GFP flags. We're bound to see some random caller do
alloc_skb(__GFP_ACCOUNT) ;)

In all honesty, I'm not quite sure what the best way forward here is. The most
transparent way is to bucket those other kmalloc types as well, but that might
very trivially result in a lot more caches (and possibly memory usage) for no
great reason. So perhaps specifying caches might do.

-- 
Pedro

