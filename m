Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58F7ECCF9F0
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 00:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B2D8E0092; Thu, 30 Oct 2025 20:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5429A8E006B; Thu, 30 Oct 2025 20:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459B88E0092; Thu, 30 Oct 2025 20:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30D348E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 20:47:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3C8F12A9D5
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 00:47:03 +0000 (UTC)
X-FDA: 84056569926.11.1F94457
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id E657740009
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 00:47:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="c10/pLPE";
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761871622;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5AQ8Z+tfOhuXO2xdxhxePQBTPs3FHNq4yg2hFuZgTZc=;
	b=IWuryli2H3khJm8Z5sZ8SDxqr83b5RHSinQwcPCOriBFAEUPlBM8BcEQPEw6wHbVgHixs8
	oymIF7+yQobydcQvpkuroWcQBulWYIHDaC4Osh8bQ3fWhPPCh6U8jengGm+84QoejBDa+3
	FKStepoItu69xtJqiPKzLMXJx4GDYqU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="c10/pLPE";
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761871622; a=rsa-sha256;
	cv=none;
	b=PHoon3+OOcH7XUqCUVIe9k+dcRoUIkOcFG2xMO3aPXwQgG5X6cffQUSGK2KRa+huEkHgDv
	ket72wNIeK9FXslo06t/CrLrPNEyqMaqWCWScaXN7zq6B5cykRoPKRaNr4MH41By6L+/qH
	eOPfiNy63TcKxeSvIuRXiXK9IETtpew=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b6d3340dc2aso467377866b.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761871620; x=1762476420; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5AQ8Z+tfOhuXO2xdxhxePQBTPs3FHNq4yg2hFuZgTZc=;
        b=c10/pLPEwKxkyVQ1qMQ5BdruN+P/jvk+MtEKYwiVwAFRb/+iJhI/EZELDAPdQgChSP
         lQ95xiNyYC8hwbWWiAUjh1pJlMYARKZrTnzaNdx3Q83pqPABDj+1WQVZxToY4nZtOTWo
         mDuc6u4y6vB99/6bAQ7BUGhtC2i5Z6EkM0Jl8JHIL2OuHkMZAKVwNABrz5QNUczuLpni
         IbkYBUfCwUDoKXUa2lPBQmkUTmsT2hJIBbZ5rT73ciZuvgctD7Hr4dn3k/UkvcuyNsVp
         xOVP0qgbjBtJrXbiKcZraoRV51jtSLSASgFbtRhps5EIsGxO+JS6B6B/gLoI9R5T+apw
         wm+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761871620; x=1762476420;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5AQ8Z+tfOhuXO2xdxhxePQBTPs3FHNq4yg2hFuZgTZc=;
        b=lC00Wwz7PGGHNyzCOjIb1m6uoQApnEoX9GEIKWHL4YvEs0jBn9nt6AjT0dosYGClYA
         duCVn9NSZ8bSwuO6M0JaXKmza9VBR4X3OjK4qowHg5eMr+7UEnCHkAtFSuu8r5hGreK9
         S7TqDW2BTl7mPcvIs/I2W50jKWKGyDgNthuxkYv/BzAyCPROh6iH24YddcAYOfRWGFjH
         Q5xY3W6syWtiUcW6TxZCTwVISztqg00Gbbf6R4cazNdFGjBV0MrkwVlLQE3n58fq1E64
         SswLlj6jKlieA671CvkPOmVOCcWCAfp1qjcmtBQnHemZ1H0X4BIpl6pV2AzOOqv8n4/b
         6Maw==
X-Forwarded-Encrypted: i=1; AJvYcCUhhqCGmOD+3AiSYAkPpcJ2jAPi5qNilFpXygiM/U8VOcVAJ+DNx9DHlMJbVFbsJgdgWMYXm+E3Gw==@kvack.org
X-Gm-Message-State: AOJu0YwvROXwLK/WHU/ooEausZCEJ3tpdlYc6Q7dkfimteOS8KzRkS5r
	QsC/3DORN/hBix5S17Lvaj38SRwNFmS2bZ2xUIPO8EAC1KSXZWAwS1PW
X-Gm-Gg: ASbGncvOpNzyFsIyCIzZ8E1Jc/tlzpeOgY3oMGXUPjXF+ywPluWYKcI2EPP9ublMYwp
	2RJxumxHJAbJ07Yw2HP6JFSFbvVxGrjM79sIZTL3worevfWorYKDPxiGhYaB1Szdf4SdHY2rRY8
	YKVCSqrfMFmKLTiA00nDueQ5++wOw3wvYllwydyCCTW2VFvktRC0VuicqAnF+2nKQQIs1pZzrKe
	voFNS61EdUrDCUeEHgvYYMOfeQ2GBQLxUAG2szyC6Jlf0s+K44xIVgRu+bWZyu07cFQ2VfdMnJn
	TldXwgI+Dw6p7lLf2zSBcSWlzikkorH5q+mXt4wjH5IKCJsswTZi/GG71Ig4dVU5gBP2iie9tr6
	5VXx6jt2nfma2hDMRx8w8NQV+zAuONXC9e8ark1PgiDvJtBwsg/vOx0eVVsl3OUAfD9BwnuPx90
	o=
X-Google-Smtp-Source: AGHT+IHi6BEBy0AMxw54ueJJMwoRZIZT4u2PPJg8dmvIkuradAkKPXF2yoGfMmq/I6j1PpHGs/aFpQ==
X-Received: by 2002:a17:907:6088:b0:b4c:629b:aa67 with SMTP id a640c23a62f3a-b70522030bfmr538023566b.32.1761871620011;
        Thu, 30 Oct 2025 17:47:00 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b70779dc143sm26524466b.30.2025.10.30.17.46.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Oct 2025 17:46:59 -0700 (PDT)
Date: Fri, 31 Oct 2025 00:46:59 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org, wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v3 2/4] mm/huge_memory: update folio stat after
 successful split
Message-ID: <20251031004659.xbtssliy6cfwxpo3@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-3-richard.weiyang@gmail.com>
 <9d035053-d1ef-4284-9d27-fbc28cda26ad@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d035053-d1ef-4284-9d27-fbc28cda26ad@lucifer.local>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E657740009
X-Stat-Signature: inmsqcpjne9qe6gijas7qt8d5atbom4r
X-Rspam-User: 
X-HE-Tag: 1761871621-740619
X-HE-Meta: U2FsdGVkX1/OTui+aMCREWBJvKkrty732rBg2s1xWejPhE1NaFIdW2ppunpeL3nYNkPFVbfQ49bwrl6+ueJNOu2XWPYrmEuEyFkN8iLXafNvZ2RTC0cyibHfqTJ719OH/l1TG6iaqGBjAxIXqY3FxAIzXZgdtLN4vMdxOgOVIF/cz1Wk0SlfcG/CJ9MdaKmds6+BGzRV2Qb1zaJQwzgOZyAIh55EYmvwmg2UL9wzvyX6DjIiQ4NLxky/qUIsfBVdCTj297RZc6juthzbJIwhMTjX6bv3yt3gsTpW3zJSEZRJubti3KvY5H8FTQXZfq7vEsOzxZLu3w55MyqjSBHNBeyh1i/85UWkxgd4+jtWwfqpiXBsR2uAp7QZsS8MhbZ0C9nsy9GJCELpAVECfecXhL4p4YXEMJLUHT4WOtnaq3jcuXVPGRdCDYtZwSqONhK5RSmmM5tepHWTcEISu0QZlrLEGK+PUGM7WE+kG6KzVVCy9WaeE1C42xNkvDuEMthREBXzqYY4+T1bO5fACeYoiUBxnxwENv2vVf+fHptbJCgkEFyNMvOfcxNfJ4W3j3mGOKXNwRxaorMsxHKN8TLvJgJ4FQVoG0BZA8guhPz/Iqj06hxk9nHftcmBb6X4VEVKVfyQTfMGrESxYN+ZU9ozjylPsPYyEBJ9H3YUAmpnlg4ZDu85BSoJMKPWSXJfv9dJ0hdQJMm9oUj7KzQTvZueKmnNn2BUj3LMmBG521NHfT9TOAjqgmSAiw4mn3jFYzV9PfkEHqCu/pNn0q2Q6JaQnxl2pO8Cb6vdEFfjv4oX868ErPbtJddOAm2haSUF7hirAnip2dSnLNP+m5PeMCSLSo8EPZYVPBEZ942v2zXMFN3Y8b/6QywNcE7wYgOiWPIf0bufndAzR/CxQ9oPenP0YoLssTTQV1gKcghhOOrfa6sI0dhefyPFVBKNpGIn5aRdCT+4Nre6nLjq5+bbCIn
 iUUE0j0Q
 qMlGuSxHCRyJrNghc1FKOy6HO+U9kAT6EnTs8zndFpAdq69Nprnk7HTbhcauIoSwtA63kDJMrvgSC8m8alELX83EZeTvsCzc8pNNMsqOlewt67fcrXZpAkPbGIKU+NHy2BMgUyhLexq44kMqnXLcupZIbVek5zQ52iFbUGv3Wa3Z6tVvbWVKNoSD22SKAKFRR8jXrx55nALYdtaMPxZLfxfAmZ207odei38paYh/gX2oKv9VOVsnebCAMacUf4wpMUC+q+tqYXcu23811RYj1chTb/idb9liEShEzgsIx4CJVyrHnxaE3ihHSBI9mufZHXtFhUdnJd/Rct/lRKXZFpbIMpK+DksUvDN1Xx95qERxoeTlcZtDBaNfrLE6smPFkZu8D8pEI9i+0ROZng0jejMT/yeE83QhqrhyI10lON9tEecZvwdQgQL1gJL8Xm1HbX9alt7wuDNXpBt8WH4o7PJrp0hT2QiKG2dbE4jgOuoKs13OdGWu956SH97/9MyXEt+ADI3G2b6YFwy9hbPIJ7hl9T4o5KWZB6yxZtzliZu6hq/dfiXGTGFVmdx3+Bt9pXn/hSy2BEKP+sCeBJuIZEsuvcuqEvfPBpzhI7GyInOLgwg9ioBpgfas1eoNRV1/KD7bJdLeKArTV1AQZkwlrYZTO9s6WQ4hL7jPgP/qMjr2X6BStaQTmluZ+6YG8n86cevy4PJDWhkSsD5JTXl/omoN45ctlIe2+5QCQDroMmMQ7ieRe9Hpf3VRKMLT8fV5ijWwc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 03:32:42PM +0100, Lorenzo Stoakes wrote:
[...]
>> @@ -3636,49 +3631,32 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>  			else {
>>  				xas_set_order(xas, folio->index, split_order);
>>  				xas_try_split(xas, folio, old_order);
>> -				if (xas_error(xas)) {
>> -					ret = xas_error(xas);
>> -					stop_split = true;
>> -				}
>> +				if (xas_error(xas))
>> +					return xas_error(xas);
>>  			}
>>  		}
>>
>> -		if (!stop_split) {
>> -			folio_split_memcg_refs(folio, old_order, split_order);
>> -			split_page_owner(&folio->page, old_order, split_order);
>> -			pgalloc_tag_split(folio, old_order, split_order);
>> -
>> -			__split_folio_to_order(folio, old_order, split_order);
>> -		}
>> +		folio_split_memcg_refs(folio, old_order, split_order);
>> +		split_page_owner(&folio->page, old_order, split_order);
>> +		pgalloc_tag_split(folio, old_order, split_order);
>> +		__split_folio_to_order(folio, old_order, split_order);
>>
>> +		if (is_anon)
>> +			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
>>  		/*
>>  		 * Iterate through after-split folios and update folio stats.
>> -		 * But in buddy allocator like split, the folio
>> -		 * containing the specified page is skipped until its order
>> -		 * is new_order, since the folio will be worked on in next
>> -		 * iteration.
>>  		 */
>>  		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
>>  			next = folio_next(new_folio);
>> -			/*
>> -			 * for buddy allocator like split, new_folio containing
>> -			 * @split_at page could be split again, thus do not
>> -			 * change stats yet. Wait until new_folio's order is
>> -			 * @new_order or stop_split is set to true by the above
>> -			 * xas_split() failure.
>> -			 */
>> -			if (new_folio == page_folio(split_at)) {
>> +			if (new_folio == page_folio(split_at))
>>  				folio = new_folio;
>> -				if (split_order != new_order && !stop_split)
>
>OK I guess we don't need this as in !uniform_split case we use
>xas_set_order() to set the order, then try to split, and if an error arose
>we already would have handled, so split_order == new_order is guaranteed at
>this point, right?
>

Sorry for the late reply, I was on travel.

In non-uniform splitting, @split_order represents an intermediate step, with
@new_order as the final target size. 

The check for split_order != new_order is necessary for the final split
iteration.

If this check is absent, the logic that updates folio statistics for the newly
split folios can be incorrectly bypassed when the !stop_split condition is
met.

Not sure I get your point correctly.

>> -					continue;
>> -			}
>>  			if (is_anon)
>>  				mod_mthp_stat(folio_order(new_folio),
>>  					      MTHP_STAT_NR_ANON, 1);
>>  		}
>>  	}
>>
>> -	return ret;
>> +	return 0;
>>  }
>>
>>  bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>> --
>> 2.34.1
>>
>>

-- 
Wei Yang
Help you, Help me

