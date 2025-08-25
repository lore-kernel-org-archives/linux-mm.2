Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD3CCA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 17:28:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2245D8E005C; Mon, 25 Aug 2025 13:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FBE98E0038; Mon, 25 Aug 2025 13:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EAA28E005C; Mon, 25 Aug 2025 13:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EEDDE8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:28:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 915531A04E4
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:28:22 +0000 (UTC)
X-FDA: 83815963644.18.9CA6503
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2901CC0005
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:28:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EKYuQaiE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XeklC6BT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EKYuQaiE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XeklC6BT;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756142900; a=rsa-sha256;
	cv=none;
	b=u0Y7jlJtTj+LnGDS5Y8YkWkZCvBDVkqUcSvR3NqFNY1x3XYq8mgxYL0L/wdzEKVl3EKUHc
	juDhwPlvtpuXH5SsMq2M2/z2GuptJJRruGJ2kgBEOvk/cBkb/SY8xZOQv2/EilW/7Tj0TR
	8XgqdB7bFu+W7VXK47UDU4ctify0oQA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EKYuQaiE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XeklC6BT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EKYuQaiE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XeklC6BT;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756142900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBdpw05Tdmq/JMq2FRCZTN3DN/eorlXhV2uq2KklzcM=;
	b=EsszwJe+mYgAVd79i9ySOZfSNx23X/1dB2G+URsdxPlaOi4kgr2SD8FeapfYbr0VCpJn/4
	nnsC6AMj83C0h6WBoOT6zm5Mhj/kslqLc5EFpTMxIRu/XzI8RFLO3IoDw9Xx3O7AjVs1XX
	SFpNHrCIu3Ey/n1w33pr5Q8kDhBHiqQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 46C661F795;
	Mon, 25 Aug 2025 17:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756142898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RBdpw05Tdmq/JMq2FRCZTN3DN/eorlXhV2uq2KklzcM=;
	b=EKYuQaiEIqDfTNPa3w2R4wQD1/gGIGM1pOP4Aq0Q+stIsXt2VA5kIWpvH+zV8Le7XGNf+J
	nrUlY7sQvOj4W0zQx5kMWOCxhlUDsYlQfdwJas7xqlnLN5lN95pgWQhkjyGUYgcUcJrfoQ
	WzvxXmoFn+1Sryegsg4LdDpsNAgpUMg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756142898;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RBdpw05Tdmq/JMq2FRCZTN3DN/eorlXhV2uq2KklzcM=;
	b=XeklC6BTczPkLDNRTg1NOWP0+pRSKLe4V6VlM4lGkRwFl2SqFKB6U/mGdGlxIVDbtBeHbs
	0CajCdBgjM8fWvAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756142898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RBdpw05Tdmq/JMq2FRCZTN3DN/eorlXhV2uq2KklzcM=;
	b=EKYuQaiEIqDfTNPa3w2R4wQD1/gGIGM1pOP4Aq0Q+stIsXt2VA5kIWpvH+zV8Le7XGNf+J
	nrUlY7sQvOj4W0zQx5kMWOCxhlUDsYlQfdwJas7xqlnLN5lN95pgWQhkjyGUYgcUcJrfoQ
	WzvxXmoFn+1Sryegsg4LdDpsNAgpUMg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756142898;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RBdpw05Tdmq/JMq2FRCZTN3DN/eorlXhV2uq2KklzcM=;
	b=XeklC6BTczPkLDNRTg1NOWP0+pRSKLe4V6VlM4lGkRwFl2SqFKB6U/mGdGlxIVDbtBeHbs
	0CajCdBgjM8fWvAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2FAB01368F;
	Mon, 25 Aug 2025 17:28:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GJ1NCzKdrGhTawAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 25 Aug 2025 17:28:18 +0000
Message-ID: <eb2fa38c-d963-4466-8702-e7017557e718@suse.cz>
Date: Mon, 25 Aug 2025 19:28:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/slub: Fix cmp_loc_by_count() to return 0 when
 counts are equal
Content-Language: en-US
To: Kuan-Wei Chiu <visitorckw@gmail.com>, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, glittao@gmail.com, jserv@ccns.ncku.edu.tw,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Joshua Hahn <joshua.hahnjy@gmail.com>
References: <20250825013419.240278-1-visitorckw@gmail.com>
 <20250825013419.240278-2-visitorckw@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250825013419.240278-2-visitorckw@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2901CC0005
X-Stat-Signature: qnwjfjgbzpb1js393ksna74jch5aqdea
X-Rspam-User: 
X-HE-Tag: 1756142899-44525
X-HE-Meta: U2FsdGVkX1+OHlVgTF4NcskwwnqbfTgREpR0p9Uh13emiZTRwRQkvB6icSi2xnyrQU40U6FWlCi1DrKN7UMl84/cyPvxd43dL8ztGqkxs+7s8biuccP1xyuZRH0/C/7kp1ODhVdYVQ+9olrclgJT7Voe7PQZd9FkfvYFDfIq2hJrV3sqZ6dtNyf5RtD1QHyUsIe0+tWV5vZN4QS0/f7QCoVN710oS+mJZ87INuZ8I5FCHNGrmLbMo7v3RYfIIpPe6LEHNMYvrQAVe34fo+ZbEP5RAFqdvCzimhJyVAkSSJlmm3/4McF8ZfvEYiZZs2xK42pqLyWjehIX7KJBxUFqFlXAUXUwoICR3k7WG8a2EobUFaWPvWBO8xRzOYv7gMfldarDnA+8Px3wYN5fsYvDEPcxw1KGADNcWfYfi6EoiHkon31744e3T6NqwsbeJJtipaAa9GpoFwx/malw4A2CKyuLPa+a88XbODJz6EIRpivbso7vSm/D5JT6r/Q4bLFfKOlOtXRnuw8bw8LsL5aZ3aQ4z8YIhzb4zw1KJE90waTLXgn3evgQ/+idhSpiF5Iqp7rLCHMlLnm8lSgDdL0Vaph/HJVjBUREQSPuYyXA8ig/wcoB+Dyas1tVX3DqfglMcsxr3NDNVEOfxgyGja3BBR3dCmJoXbogEQhLSYEEy3WhhsYeZEHEb/z7k7ZbfAe4uY3xaonLQDcAsz7K/oMwJXfcbivFZL5q8IOX6fTAABBQfjLJ6dRMeyrJVmAEekitqTWAsvOn0p4h1rH3dB8Duh/99rTYGGFecObJVvaEdooF1wlzzPc/Q/jsYjh44xVpFR2VofAoiqHARajGK2JQ4YAD1piguuFRE5zRlgwJq7djJ4/NcBWrlMR45JaGL/fp72a7UqFjIl6NfOieala5azMJptxo2owA12hAyT64kZln03fuNyMBPZS7JEOtApF1bwuoxUKSc4p9g/lMst7
 yT78Zo1O
 VrO2UVE/p9EX0aOJKwVJFdsT8ped2lAalIXNgIRL1XEdlMGl9Bzc//MXdpyM4rk/Rzb8wzxbb9Iyc9gXSIIWYf6hy7U1A5BxFYhttj+4MiwAXlxY2iVIK3uqoyVikPYca3gR1bjZVplAQBbu1L1iYSKTpugDS20eKotMcHxsBmAmD0W/+c6sb8DsaaFQCiaeBFuEdnoY3zl2uxVEibFgIXP8kXUJ6o7epIBahFpSqYL+0ZHDQJCV3CDz/1tswfPckD1ysftYrLYDUJr8IE3/fsI7t2dDxdMJIk0pge/+9XYVOjdkCvBIXsCyHTGA2VYG8ITV0LBZAFi705mRzgW0OwfiFlWc/h6mwnkL9S6HMsi2Y8d6MT6jLoelWZtF4aBFHNbkQpU16zSexd6GhR1A+g09417dYX8llc4dykrMGzwB9FCoOeM7zgPvDSnFpqFEnaYpAeQKlAKe2o7I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/25 03:34, Kuan-Wei Chiu wrote:
> The comparison function cmp_loc_by_count() used for sorting stack trace
> locations in debugfs currently returns -1 if a->count > b->count and 1
> otherwise. This breaks the antisymmetry property required by sort(),
> because when two counts are equal, both cmp(a, b) and cmp(b, a) return
> 1.

Good catch.

> This can lead to undefined or incorrect ordering results. Fix it by

Wonder if it can really affect anything in practice other than swapping
needlessly some records with an equal count?

> explicitly returning 0 when the counts are equal, ensuring that the
> comparison function follows the expected mathematical properties.

Agreed with the cmp_int() suggestion for a v2.

> Fixes: 553c0369b3e1 ("mm/slub: sort debugfs output by frequency of stack traces")
> Cc: stable@vger.kernel.org

I don't think it can cause any serious bugs so Cc: stable is unnecessary.

> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Thanks!

> ---
>  mm/slub.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 30003763d224..c91b3744adbc 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7718,8 +7718,9 @@ static int cmp_loc_by_count(const void *a, const void *b, const void *data)
>  
>  	if (loc1->count > loc2->count)
>  		return -1;
> -	else
> +	if (loc1->count < loc2->count)
>  		return 1;
> +	return 0;
>  }
>  
>  static void *slab_debugfs_start(struct seq_file *seq, loff_t *ppos)


