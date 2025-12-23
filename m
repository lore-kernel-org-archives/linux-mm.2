Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6983E748FC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 23:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DD8E6B0005; Tue, 23 Dec 2025 18:47:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AB46B0088; Tue, 23 Dec 2025 18:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B9C6B008A; Tue, 23 Dec 2025 18:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02EA26B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 18:47:14 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99229138835
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:47:13 +0000 (UTC)
X-FDA: 84252374346.25.C9B1BF4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2D6DAC000C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:47:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uYtqOZKa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N1ertnlG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PxeFE5Ou;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sXBvebV3;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766533631; a=rsa-sha256;
	cv=none;
	b=0ovrg9MjOveVR29ahK0cedlh3QPsBilJxJHE5IQi1Jfq9nFwS55K6q8PSRvEZf8jA1jTa7
	G3iA4TI2NlflUKxITJ0G6fwYAF0ngHfIutyGE9iMaaRoHF4nq1O5QENzAQlWOMBA8r5Dec
	Y9kIOWz9NE4AFssm6qNy8DYuRz6frek=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uYtqOZKa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N1ertnlG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PxeFE5Ou;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sXBvebV3;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766533631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QoFJC5fJ27wzcTm+kDyJGI3Gu6MQAObPBLTfur+Urc=;
	b=NyrPtPi2bmaes/zhM9BZPxlrglj9Gt2sU6TRXB1RbuLQdhdHyTAeuXbJCT7IynGgwCqIId
	rH6c/1DDap3EiNZpSdMclFRavVOD1JRWED5LZqrZqGXZlO8Y9sf8I/c3LRNSysDErxlS+a
	uZY+zsUPNenWAO+sv69E/xCBzlCLclQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B373433A03;
	Tue, 23 Dec 2025 23:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766533628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0QoFJC5fJ27wzcTm+kDyJGI3Gu6MQAObPBLTfur+Urc=;
	b=uYtqOZKasgcah56E6+C//qsZhCKY+K3Ge43W8e/6BNLAW8FGdrPqEMsCCt3J9CPzXNHioN
	LBFeTXXe+NNkcWjticADKem/CJItlboeZIQuOQlp1QSUJvmn2UfCvkGyeoxsf0P5zoxqFU
	JSs80ziPkNdinUtSmC5SnGvDX2WkP8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766533628;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0QoFJC5fJ27wzcTm+kDyJGI3Gu6MQAObPBLTfur+Urc=;
	b=N1ertnlGiXSHQr3YfgV4qNBuiVCLwTd5VJ1NqS+hnDdV/twxcZIgJD6H1ppMLxG88H/sm4
	2KYuVQ63lH7yEGBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766533627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0QoFJC5fJ27wzcTm+kDyJGI3Gu6MQAObPBLTfur+Urc=;
	b=PxeFE5OuRDwy+Npu5QirNKJGNjUxM0hTbmcddEKNMQXV6Qw3b+F5ah81sbB4ZMbn0t9LRj
	E+I1aY8SvWvttcOpoe/a5v4Zk743TJMgBxxL+U0fdY31DnXM9xeJ0i4zRUrn8kI3ZIt4Ma
	JXzMCDu29ff/VCrI4n1g5n/1SvoKr9s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766533627;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0QoFJC5fJ27wzcTm+kDyJGI3Gu6MQAObPBLTfur+Urc=;
	b=sXBvebV3b3nN7kCSJuMlhNC/NDIOjicTapz+0z+fEFFc9/30Fk+nPBW4RqPP8BWFhWXOtT
	dLZ+Ax24OC2/7GBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A0EB513A54;
	Tue, 23 Dec 2025 23:47:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EXz0JvspS2kUXgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 23 Dec 2025 23:47:07 +0000
Message-ID: <0b5f2c87-c180-4ada-9d37-f2e3d0071d9f@suse.cz>
Date: Wed, 24 Dec 2025 00:47:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempool.c: set @elems slots to NULL once freed
To: klourencodev@gmail.com, linux-mm@kvack.org,
 Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org
References: <20251223231054.16061-1-klourencodev@gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251223231054.16061-1-klourencodev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D6DAC000C
X-Stat-Signature: jxs69pgbe1fs4quk54x1qhdksirzt88a
X-Rspam-User: 
X-HE-Tag: 1766533630-189862
X-HE-Meta: U2FsdGVkX1+1cFSXeMoS4GWwwtyXmK9y1t51fDoBYoatzWv5KgtQDanC4cE15Bgn5qWxUmJMfYO5aFGgsvM1uM0LtcHnkmvnC2nF5uU/JYg78PLYLLrbuerMra1/yQAvyV8XjASjXXNvaGr7Kdt1YuvySLZCQrJvQy4VTXrI1d+H2g6ziY/eoH+YyzdTpvGFseMsqSLrdPpCA4wK9cved9BoagCNVXfBPIshIHfnvIRcUxMXkwdNjDA/8Dq7BXokOEHX2/csTtzrYmUIOOonbGR06zwxbAWeD+wk4wrsX3YH5bKNH55kkbNWRW59SBD2M0eoVqte+ZqPOem/QUVx+P4yb2VR6+OjhpWeApr6kXSAO37QmBwjDjdtC5Nd0fxjKiKbN1KoWJbh3cAMyfUBZ+ryLvnx5UXaRDFIY1bMsK8w8C2wuktxdf7HDkQ0a5t4rRpjKDzpl7k1QO+kLVxDEeDFxPjnUzYNdhG0qUOjfD3tZUOMQYWANvTycuLD3Ua+K5STgS3gUsriku5xdNGq3/dfPJlKLND/Hh2Twuz92PXtxUvR2jDbWIeydTUJDi/NiRueiDJV+t1SkI0lja1qj2J3gEIkzAldesWjiT2dCc9VMPFS7UkSRhK4R+kwedyvM8SrKPMOJWgaiF/LP6D+kJQZDx+dJpA+dcjbbcoA9/14HdA4Tdukq3RogrXY2SCCmXSt7uFYsUsEmhWq8E6A5mqbnGtnSwXBK3GFG6GCKNf9qy7iV4GkWxLRmYsPVpeQFp15GXgZKl43CmXkSSAuLjOsbfrnzD6pihrO7w2A4TrtcFsAn0EnhxLv6qT83lm+LXaYZo9Dwx8l05ZM2au5T+Mrl7SDRtVByaZ1Q3TPycL3eqxNG52YfCakLzKgtXwLWmQtp77f1rmugbyBykWrgFfLaA3vK+wb5azy8xGyq0gh1CsOYzjUTtRl/e/+2ZDXnXOLGu7OrqLNj/RK2AO
 udleBjYd
 m2VjJ+IipkK6desDRNmh6j4SbFjf43t+mpdYgUPmFWsy4HrkhMaedTU0+USGdMMvxAWQE3sdODcDmnOJm2InN3aNFAJgZCW7vjCPA4+g3fYZPvfhMGYZNfPwDYLZHJxF3e8+kQPmuqkZcgu6unBacQGeRJsiFYKjHh6UTiFBFeKJaB/ospOwIwPnxO0ZPGfSlZsy9AhjGg8vwkXl/9aonP8SiV/Gze41PGOIW0mNUE+kH20tI9vSBTja/zJnt+8ZJjCTgF0eMtCJmgUhWKoFPBrwPsxcHpkKCbyVItOUlo//J2Kc8+yGI0AFaag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Christoph

On 12/24/25 00:10, klourencodev@gmail.com wrote:
> From: Kevin Lourenco <klourencodev@gmail.com>
> 
> This is documented in the function comment as "...and sets their
> slots in @elems to NULL.", but it was not followed.
> 
> We need to follow the NULL assignment, because elements newly returned
> to the pool must not be touched under any circumstances by the user.
> 
> Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
> ---
>  mm/mempool.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index c290e5261b47..1a2060304fd4 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -674,7 +674,8 @@ unsigned int mempool_free_bulk(struct mempool *pool, void **elems,
>  	if (unlikely(READ_ONCE(pool->curr_nr) < pool->min_nr)) {
>  		spin_lock_irqsave(&pool->lock, flags);
>  		while (pool->curr_nr < pool->min_nr && freed < count) {
> -			add_element(pool, elems[freed++]);
> +			add_element(pool, elems[freed]);
> +			elems[freed++] = NULL;
>  			added = true;
>  		}
>  		spin_unlock_irqrestore(&pool->lock, flags);
> @@ -683,7 +684,8 @@ unsigned int mempool_free_bulk(struct mempool *pool, void **elems,
>  		/* Handle the min_nr = 0 edge case: */
>  		spin_lock_irqsave(&pool->lock, flags);
>  		if (likely(pool->curr_nr == 0)) {
> -			add_element(pool, elems[freed++]);
> +			add_element(pool, elems[freed]);
> +			elems[freed++] = NULL;
>  			added = true;
>  		}
>  		spin_unlock_irqrestore(&pool->lock, flags);


