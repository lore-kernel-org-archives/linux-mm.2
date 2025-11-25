Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D61BD0E6E2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 13:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA986B002C; Tue, 25 Nov 2025 08:14:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99AD36B002D; Tue, 25 Nov 2025 08:14:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863516B002F; Tue, 25 Nov 2025 08:14:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6ECDE6B002C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:14:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A8EF160116
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:14:02 +0000 (UTC)
X-FDA: 84149172324.28.CB6416D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id B888414000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:13:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nNClBb7Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MHD99YQI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RmF5flx5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xFmW+6qF;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764076440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dY3y9e39G0V/vOJNZLFNIgz5t6q/0oo4LUV/hY7PM/A=;
	b=Pp1jl2MDOsF6w6fTyAnp+3zCn/yJB673l2iCKHLLZEvCnO512GsKHO8N4rVpR1wk1/5Wko
	9h6s+J6Mn38p/Lpgpk+u9aV5rXeIhlN+SIXicMC9V2QAiJWD0sVyGx3e9cYfrdg2+jBA4i
	HeQdLh1f28q1AX6dkxm7gQX817Wywt8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nNClBb7Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MHD99YQI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RmF5flx5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xFmW+6qF;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764076440; a=rsa-sha256;
	cv=none;
	b=0J41tqr7qfXW7/mu5ACmh9GOn+4yrj/A13NbtjMYsmU1/mYhqJNtkdHhzVd6SLiTwSijsM
	cOzNrkQA7dCv2U3gIdh6RNxtbHWFHJT4fb3Ux5Jlwy5Hs2Szm7PLFGrCvwLUWlQhIVdzxS
	58K2a2XaoNLikj8L+0GKrHWyRo3PQKo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F051F2281B;
	Tue, 25 Nov 2025 13:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764076438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dY3y9e39G0V/vOJNZLFNIgz5t6q/0oo4LUV/hY7PM/A=;
	b=nNClBb7Yf5PO6p3iFBQ/TCH1DKJzMYgoY0+QIHPe9zBUM+GrSBrG6BhtZiGpUGhDlI5YmF
	0lomObOmcCXDSe+smfP+RW3BsohKM7X23Fw7aKRR9IUjPG0PPn4XAcOL/JxLljMdN4BQOI
	MCSQr94P6ZFY3tMBfol4T4XT8z4NdyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764076438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dY3y9e39G0V/vOJNZLFNIgz5t6q/0oo4LUV/hY7PM/A=;
	b=MHD99YQIR1loqE5dlCqCQa80/Psu42pgL7svS4Fc9nWjalTGEvYSe4qg/kuSW0Sl8MwcaD
	s0sXI/GamdmbNvCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764076437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dY3y9e39G0V/vOJNZLFNIgz5t6q/0oo4LUV/hY7PM/A=;
	b=RmF5flx5pWU06yBKeNv250zQRRZTjfYlibK+urcf2LZzWoaRSm52qwxmm2SYJOiwgDj/in
	XPNTT9cm/CTRCKNgis32B2pwyyhg8Bk5i8rHOF/UHJqhKwopWg6SobHdgqo6oAnSukydhj
	rGEB/wie7jPRFFqPjAHYtAsO3VJ7H5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764076437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dY3y9e39G0V/vOJNZLFNIgz5t6q/0oo4LUV/hY7PM/A=;
	b=xFmW+6qFQv45ykkOaGWH8D6npVhtmWflNa/MGguEUfcUH2Dwj6vpAGJPvon12RUKmGkGkJ
	F18XpP4B0dTCu9Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D795C3EA63;
	Tue, 25 Nov 2025 13:13:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z+SGM5WrJWlgGwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 25 Nov 2025 13:13:57 +0000
Message-ID: <ecd8d2ae-e764-42da-b883-5c5495eef388@suse.cz>
Date: Tue, 25 Nov 2025 14:13:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Remove unnecessary call to compound_head() in
 alloc_from_pcs()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <20251124142329.1691780-1-willy@infradead.org>
 <aSSuf5OG41sOGryI@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aSSuf5OG41sOGryI@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B888414000D
X-Stat-Signature: 5or8r5ww3igf5ieop89fjy9yh4xrxd6u
X-Rspam-User: 
X-HE-Tag: 1764076439-772152
X-HE-Meta: U2FsdGVkX195mjrUWJemlJUcEPtp+7RkiuGDOHjFsueLyKN4FrxNQJKQZTljII2G+7J6maKu5AYrXs8nDkHiCMLeMKzf4vkbKcdRkAJUmXMUWLzHTTRFn3OeDwMh4ChtSvNnw6Q9GfqZSAZKTFVpBxmRzS+ZQEo5kBqKPtkEM5mVVBj/E56inrcCm3ymE01FAKmvw+Au9YC/ZBSA+F8QXTiVqJ6OUtFj+G0/+FF1RTHEk5Y2qb38CnMAYcMept8pWtp4S3gyWKvDlLY0D+c5XwZIQfXL5+Lp9KsyOUWwpHCJ4iOE93x86/qQUx6OEbxVqGDnlEizwKIxVHU58ho1267MACVKnjsJwM4Nk2GUniksBOaPy0uN68qPJ1R21JF37cBEEJ3gADJliY3pKoXiP2UwlTSU6+AQpBl/6ygT2lesiT8B0TNyxAqg4HlNnWOG5tSBUw0Im1E6XqArx5pHjmuJZX6zGB5EIZc4qV3Q0JHOaJ6M1+9Xs3vohV6Tmg/ScsxXilVrOZQHAKaqQTpKez9outSyEhyFzBNH7h9+VCNk4noraNo1w+o8TryQoBIRumoCTzB38jmE0BWtEHNh8CEjlkzOKVG/mGRRVh887ysUuDp57XSkIAMQNq3X2N81w+ltLwOCUKwDPPERedgxopP969LtdI7UJXfhufuHFDQ11CJorcQIYOq8rJhr3bjl3glCpfiyl8d1A5esLmwhLDbPuhcVO9xUMs9mAlzQIFRkSxQaA7Mt/dQ24dvqecYmXAeZUIiXZwBYmzm9+/3uCjFEkrujpPMGLfmTJAVS7Eu9Cw+3I/EmJr8MnySQRZ564xkMeRtxIfdFgXtYHapUPE4l+BUnZtKweg6vsL/6kghdDd7gAQLlKyjfvwXPdVR9tRlzpp6ToQvXwvfXBU80faEWeF5hPOKOWq9W7zmb4qmAb8yH+oFbnH/hoGP1J9Hk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/24/25 20:14, Harry Yoo wrote:
> On Mon, Nov 24, 2025 at 02:23:27PM +0000, Matthew Wilcox (Oracle) wrote:
>> Each page knows which node it belongs to, so there's no need to
>> convert to a folio.
>> 
>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> ---
> 
> Nice observation!
> 
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Thanks, added.

> 
>>  mm/slub.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index e4a02586dacf..e6a330e24145 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -5126,7 +5126,7 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
>>  		 * be false because of cpu migration during an unlocked part of
>>  		 * the current allocation or previous freeing process.
>>  		 */
>> -		if (folio_nid(virt_to_folio(object)) != node) {
>> +		if (page_to_nid(virt_to_page(object)) != node) {
>>  			local_unlock(&s->cpu_sheaves->lock);
>>  			return NULL;
>>  		}
>> -- 
>> 2.47.2
>> 
> 


