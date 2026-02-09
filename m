Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BFC6E81BCB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BCE86B0005; Mon,  9 Feb 2026 09:36:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540536B0088; Mon,  9 Feb 2026 09:36:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40B366B0089; Mon,  9 Feb 2026 09:36:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3696B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:36:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B89DF136DF1
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:36:35 +0000 (UTC)
X-FDA: 84425169150.18.61AF63D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6872216000E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:36:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dm0BzZ9O;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CPXnsbr7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dm0BzZ9O;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CPXnsbr7;
	spf=pass (imf08.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4fvPua73wst0xbmQzOlPu9X6W7c/Wv2lY9Itw+jOqw=;
	b=l1q+6ERG5ySJzs4bXRGJhJQrxyMZT/ZxbD/fQCy/txEOoxj30LcL16BGNZmuAYfYxZc5ha
	iQQBK8KYK7oRf8GIrnkoyfwtNfxDh8n9gKUkf27qIkI9UK3S3ZwdclW2XOtee9gm9ieto/
	osAC89ZmsfcFRBL+PJJPDgfAdYqfRh0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647793; a=rsa-sha256;
	cv=none;
	b=mQU0+laY8DwUU5QmFkQVYpIn5590vNbMeEYtEIfelPOMZlY8UgjIWUpmLWoe6THT9AIBP9
	0Q2xqdy4ysmvcGNATfj/S2zdW/SDwz6Yx9DinY2zTXzVqi5oKL0Ycv3CWUvgQhNKG+SPu2
	HhJ0UpjsRvaSOXfNm/enLOFcKRYJAVI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dm0BzZ9O;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CPXnsbr7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dm0BzZ9O;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CPXnsbr7;
	spf=pass (imf08.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A3B473E71F;
	Mon,  9 Feb 2026 14:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770647791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y4fvPua73wst0xbmQzOlPu9X6W7c/Wv2lY9Itw+jOqw=;
	b=dm0BzZ9OOlQWYn8J/Hn6Beq+bP6Pnlyg/YyHSLnpnDzSgG3CHCytJ7EtzKG3X7mCS26H5e
	v6O2KKTzMsThOC5DPmnYPFdfDI8j5blhddutkoPoSJiijx6ixabGMvnAGLybib5ogkgg2f
	bZbCaAOzLFskUBGlhnqQHkGo2D5q2WA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770647791;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y4fvPua73wst0xbmQzOlPu9X6W7c/Wv2lY9Itw+jOqw=;
	b=CPXnsbr70r/3SQPsSAYP2jft+anOypNQkfov0j5X77MpuDSsFKjT0ddXyjURrk0sV0UQSX
	wRp38bSLaZnQC3Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770647791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y4fvPua73wst0xbmQzOlPu9X6W7c/Wv2lY9Itw+jOqw=;
	b=dm0BzZ9OOlQWYn8J/Hn6Beq+bP6Pnlyg/YyHSLnpnDzSgG3CHCytJ7EtzKG3X7mCS26H5e
	v6O2KKTzMsThOC5DPmnYPFdfDI8j5blhddutkoPoSJiijx6ixabGMvnAGLybib5ogkgg2f
	bZbCaAOzLFskUBGlhnqQHkGo2D5q2WA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770647791;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y4fvPua73wst0xbmQzOlPu9X6W7c/Wv2lY9Itw+jOqw=;
	b=CPXnsbr70r/3SQPsSAYP2jft+anOypNQkfov0j5X77MpuDSsFKjT0ddXyjURrk0sV0UQSX
	wRp38bSLaZnQC3Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5128C3EA63;
	Mon,  9 Feb 2026 14:36:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6JI6CO/wiWn/IwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Feb 2026 14:36:31 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,  Andrew Morton <akpm@linux-foundation.org>,
  David Hildenbrand <david@kernel.org>,  Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,  "Liam R.
 Howlett" <Liam.Howlett@oracle.com>,  Mike Rapoport <rppt@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  linux-mm@kvack.org
Subject: Re: [PATCH 2/2] io_uring: introduce IORING_OP_MMAP
In-Reply-To: <efa7714d-565d-41c4-af85-d7a89e7fa399@kernel.dk> (Jens Axboe's
	message of "Fri, 30 Jan 2026 08:55:50 -0700")
Organization: SUSE
References: <20260129221138.897715-1-krisman@suse.de>
	<20260129221138.897715-3-krisman@suse.de>
	<efa7714d-565d-41c4-af85-d7a89e7fa399@kernel.dk>
Date: Mon, 09 Feb 2026 09:36:25 -0500
Message-ID: <87fr7a9e6u.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6872216000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5914s43e9owmqtk48n1r4u3jcys6sehq
X-HE-Tag: 1770647793-494606
X-HE-Meta: U2FsdGVkX1+Q08Fa88i9YVDQoQgLMw2idCR34b4Xv1Vq/HI2+qOaHPSj/cSv6KnG1S7irjG85Eni+T/bvJrPvRI8vzlYkmsobofxwI5b7q3wtgcJFPTKvJUIuF2xLgiy+9EB4P/kRd5aKecKdvXm5ePtxb/uBdaU2KKYDdDXrTnIjVa/fEViWYETDp2026v6tumTW0wtRL1eCAiyBGpUvoRQ0fUhGG/UsUpwkruwLUqyScuOgbcNyc8sfJXUTN+/vm7ju3kxzR+n+EB3DnEvoO6ysDbEnNT5HboHLzBrwZc4KI5J3Z+CVAQktFpkD5bwcPWalw0hdiE7gSqub5MYo5d2qesWk9I7WRq9gYf0h2LxLqVP3SQVAHoLlafxHgal/kWpmF1FdxW8wmQ5fsYxVn/alDXm52EOE/nNDJ06fKiUhpXPeoZ1qC5YczMcI+Ue/OhaHVHFC8eVGbTUYHqsvMTJLWblAyJV9yuNkG+VdCwh7KZRfASNYfP3sdGlr8T3R4qoVSTckww33vg7DYg1nzEiS5FUe3ouyLlTvwOcaA9BjbleZ8BYgWvtknG5LU6wXKe8KxWEdHt0Z9SCSUyrWGlXDuQa6M3t9OBc6QeIyhkGfDkTuPtZDYWM6wXLPDH73HebrfQRVGJ9XBsKTWbrVhOUivr3hPQgxjS6W1lQT0qc+ML+TgxRuCWfpB3LK+DtEMBV15TB1yJ8Cj/jESqSiYx8crT67b5mUu3hdvTxqVIufD4JCFFMiQBKDTNknOAIYhKRpolKUF+mC3kaa/fqgt9crNdXsy9lOeJnJySKxZDzLgRJUBf5rpoFmHun24fr7Z4+5XYIRmAobv1/gwzBO4XrtnIBw1jSYdw7CZBoxfe9/yvlOvxPyqxQBphER4dBIJi1umDALqJlJDUFxzhuToPMku3uiJFj52yRqFwcMM3ge8BWSwwiaJ+mPM3dDHoIa/ZJei0cnSaCKDl1m6o
 A73X0yqM
 8pPujwzoxjGDfdVrRzS+GkIJwVKQB4fExB1Zvkxoqz6XomRMQa75kBLQQYsB5Jyd/iiHtMtzf8RC8lbaW6e25XyDl21gqJLtXhPXM/N/XzWUwcU+HMbjygY2DyvEPxyKw6TEzRByV15xOAxcyP4HiKxTHIenMlMiK9wJ8QPYcVM6Aq95z3I6vvm9iCus/pPxMhSYh7CNtvEtWlV/hrKVWhpITpDdIe7psZUicENFzhh1VxW15nJIxW7xOfnvyRjUylPbIhmPnDnxSAT1nH4DRDahFzuPoi+tkRZF2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jens Axboe <axboe@kernel.dk> writes:

> On 1/29/26 3:11 PM, Gabriel Krisman Bertazi wrote:
>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index b5b23c0d5283..e24fe3b00059 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -74,6 +74,7 @@ struct io_uring_sqe {
>>  		__u32		install_fd_flags;
>>  		__u32		nop_flags;
>>  		__u32		pipe_flags;
>> +		__u32		mmap_flags;
>>  	};
>>  	__u64	user_data;	/* data to be passed back at completion time */
>>  	/* pack this to avoid bogus arm OABI complaints */
>> @@ -303,6 +304,7 @@ enum io_uring_op {
>>  	IORING_OP_PIPE,
>>  	IORING_OP_NOP128,
>>  	IORING_OP_URING_CMD128,
>> +	IORING_OP_MMAP,
>>  
>>  	/* this goes last, obviously */
>>  	IORING_OP_LAST,
>> @@ -1113,6 +1115,14 @@ struct zcrx_ctrl {
>>  	};
>>  };
>>  
>> +struct io_uring_mmap_desc {
>> +	void __user *addr;
>> +	unsigned long len;
>> +	unsigned long pgoff;
>> +	unsigned int prot;
>> +	unsigned int flags;
>> +};
>
> You can't use pointers or unsigned long or unsigned int in a uapi, as

Thanks for the review, Jens.

I went on vacation right after sending this, but I will follow up with a v2 shortly.

-- 
Gabriel Krisman Bertazi

