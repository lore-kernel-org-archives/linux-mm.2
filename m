Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D47AC8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 17:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9D3E8E005F; Mon, 25 Aug 2025 13:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D688E0038; Mon, 25 Aug 2025 13:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 915E68E005F; Mon, 25 Aug 2025 13:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9F28E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:54:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10EFB57F6F
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:54:57 +0000 (UTC)
X-FDA: 83816030634.17.FB83BA5
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2E2D08000E
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:54:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QFLLKoVn;
	spf=pass (imf02.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756144495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PALG1f/QrrclDqeCnjMHSh9ak08P++xF1J9dcSjVu/Q=;
	b=K4paF843lnPZaa9aA9W8KJoIltpOzsgzRKx2L49JM7ifTnFMhB1soT58nkl8HYDeA6/nzI
	Y/oPjeWmH6j4gDJRwAr02/XW9kjLZwPOUDMY8ozU9DNIGiPzOpg2fvHCdAuGoxjFoh1/f7
	6Egwq9YdcRLK2lLkXpttUX4jQWUJtTg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QFLLKoVn;
	spf=pass (imf02.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756144495; a=rsa-sha256;
	cv=none;
	b=AQPAlQ/IsJgIaEZSo1Te8brHgdMg1Iv3UBT7L/rNTCKzCrGgpCEOCqPH3XMIEaa2Ls1Ri5
	fSLU/IUFqxOj/ZsGfcV8q3RMz84lmDJ5P2CdrW4UJc/52H/ipXBd7Gto8S8amdC6I5IEmR
	L5p+VfqqCF6bhFwAUngfPbMSw7YIUA0=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-24457fe9704so43026695ad.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756144494; x=1756749294; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PALG1f/QrrclDqeCnjMHSh9ak08P++xF1J9dcSjVu/Q=;
        b=QFLLKoVn88zqgOUsYYmAy3w3r+feiWEP2XU2oWVT0WPXxH5EkvPOSKoCdKVXdIsZ7t
         SI5NDYr8Ypz3HYK5WkUZjhHqPwiaJg5d4TJIuPP0Grq/h+Tv4+a9Oync2Z2Y8B2ahaXM
         9MDdZ7aaNS44G9bgqmDq6VY/WVWDThsrByVEWC6yLvkkdDxoENsAd8WHC4jhIVot1mxZ
         zIhNS2E53sZQoaS08sEyO/S2mRvsmUW8iHnCMhpsGeQ+a5q+llETKR1vJyIUE/wFW9n5
         HGjb9SqXtBcVLiA+cIT1lmp0hemtwStBeiJctLXNEV6SsNz3xnHB6LD01Grj0JO3HVju
         FJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756144494; x=1756749294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PALG1f/QrrclDqeCnjMHSh9ak08P++xF1J9dcSjVu/Q=;
        b=GtxVvvMr2cPeLGDiYFGCY+phqzDG6aWHumFggmAG/4k5bsBLvCSDU6eaeADs0llfe6
         XKq53soZDg7qKwZ2aLf/0gciM0BTIsYCF0pRKDIVvcDAtakji4pW220xrHtKHvWEzMVY
         yrBibcmOqTqKHpfRf9HJGOLFw5pO+4cw9tu/RRzSfQLtJ/h2INV8b8SkeZH0e4gg5oaq
         hZRTZMLIbEljWfUW4saukU+dhMd3uhmRpWQ8zPTF129JNTTnTxwyJm5QpvqSm827LBnm
         4QflLxtDI//y3OJQPnK/WtOu1imzOPLMRCbqUfpg8uHMp+TxruuKOdSOEKvEu8iUktUK
         Tj3g==
X-Forwarded-Encrypted: i=1; AJvYcCW/4FNMwWcC1aQesYfDxvXrkVr+DpbsTfedKQI4hegUCzBraanLLCVhI0ZtBtbMhO1pRJURU0aJIA==@kvack.org
X-Gm-Message-State: AOJu0YyJUKWBhVnn0YRS4GmPi9UJWcqmYdRkPIZXyRsViFt5dyPBvCfB
	ZmvEvy+QleVdNTnu0gUrse+CKHDCreMI7cHaOHR0Mk8fwiA8C8F76zjr
X-Gm-Gg: ASbGncsEg9N68f+E9QucaCx4DJj/80D6ZYMlexr9+ahPIfHAaRXFNhIKS1IgaLQqoit
	6qjfVE77s1jNLf4Bbe1CFCq7/OejhlkzlVXbIF/uKfJoWVjXNWZb8g+TXzRLKCP100tmmgNFiyq
	YejUFITvZSrzeRMR2+LkhR1xBrX7kJvN3GAMW2f/wPHBPck3+DT3ZkDi0lvtLj08GyHXi75FLWW
	xC7w44HvIgyKp7qfPMcFZikQ5vMTqIBp7/1rnErioQD+l/BSsKRSsrepXCuJDDGy4Ua0sHsl6qf
	aaKUwO9ZU7Wzar9mL9zun/Ssv7JxAAPHcpRnuqmgpQG5vD8NHcZ7ad4yGKrxwYXp2IRDb5fP1ya
	pAJwPTaJn46Uiku19B3ROwangkl9S6QyE6DzbyrV4JLTViaLy45XgNbhS0ICW
X-Google-Smtp-Source: AGHT+IHqyWefoCtbS0gX6KgX4uuDcl9YGbvjxjelXwm8qZs/hpL1be/XcwM8tdZuLvSL5dxbQ4v1JQ==
X-Received: by 2002:a17:902:ef01:b0:240:52c8:2552 with SMTP id d9443c01a7336-2462ef6f40dmr182941865ad.43.1756144493845;
        Mon, 25 Aug 2025 10:54:53 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2466885efc8sm73686345ad.90.2025.08.25.10.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 10:54:53 -0700 (PDT)
Date: Tue, 26 Aug 2025 01:54:49 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
	roman.gushchin@linux.dev, harry.yoo@oracle.com, glittao@gmail.com,
	jserv@ccns.ncku.edu.tw, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH 1/2] mm/slub: Fix cmp_loc_by_count() to return 0 when
 counts are equal
Message-ID: <aKyjaTUneWQgwsV5@visitorckw-System-Product-Name>
References: <20250825013419.240278-1-visitorckw@gmail.com>
 <20250825013419.240278-2-visitorckw@gmail.com>
 <eb2fa38c-d963-4466-8702-e7017557e718@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb2fa38c-d963-4466-8702-e7017557e718@suse.cz>
X-Stat-Signature: 1jkze1598tr8xj9endzrtfqhjsowh1of
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E2D08000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1756144495-75116
X-HE-Meta: U2FsdGVkX18pibLqY7k8g74kYoOOGjW1T/w3m7Fk/SJl/oaVejj9GUyJY6WX07ZUbZLXNr4iQ5PIc3LaD5MNMz3khRpagbruwnqso3cnIBqEXy5xnIm+AJBiD1TFwQjXTYYHz7+Fin1+6NRPQd3vpBpQQZ4cF2LXVjQnHcOsv1+huaFoAIcxrLuH2HRLVFWkrWzAkrPMe7CR1Ym96UyvIN2GVyQoVzykI3TfETFs+Q/gOmeBkaga679Y085H2Pvy/V9Dve6Kqw8W1bO8EkLwSRxAPePlnVKh5HrsFPaUlTrFWFHE+Q3ZyL4uhI5JBrxNiimPsX96CnhX+q1MnahjsAA4rpcQrYMoQXOlC0utf836RKP7qasFiWpOPWV06dhS+mLunaceOTBhPNS82ok3lBT7e+CeDRinjghkqnX940FzLYm3aCtWes786kMZ+CiHGEP+uURBb+ofQCzo7qQjJIOWz9B9ZulDf5w6wTlnAcD/OlsklJW3fFFMH2khNRHQWPdS+ed9dDXhjlUj+04G682V6xZ3fMwEvvoHP0aAiJ8C42AbfUBHiwfQkJPNJPX3WSEUcUbK/Mj6Or+6aYzzAnRX9M/BbYYVHB1H+QiSvS2qFYqOpUiJMo+BWnvhRGZmWaiB5OpB4UMlf2bbm6VI9im0IQ7ZA/JuI5mWsPks5w8Z2hd6JpPTrYo5MU53C9GDlgtx1Y61wcW9feGYT9kLr9ZZyiUcKtb5ugOiYssy2cTHiVHID8vjEs29iOstaHz/eBhAVhagp0RZ/D3APQ1PwFSyMTvB8ETn1mT1N6c3qO+WQPZqvEsN826bnwpdzXP1qfeoPKkKU1AcMM90QSkwXZ7tsEafs3fQS/oKt710NAl/pnsyVNTAAu7HDIABVoxBWp+nNoqUbD5OmGfAfw/PTyaBtAQmWp+qZlINsqnNjaF/jde/WDGD5DT1gIQNjvPtLnE27Qs1eatXAC3rBU7
 DGx0lNN+
 TAmOyhK9cXGThFz0Og5SPF+zGl46V0xyP8Z2krXToFo7A8w3wQcLfxH9cbhlWzewI1AfH4Ygv2rUDII3d42aI0/fFRwR6eXiJpmEtHxdYr8VbxdF9Ghx6sZm9T9yoReIAU+6ijQCmK4A+k+bsWxx5KpzeT4j3mIFXpgaQ7spqBk1Nsmx1v5wxvVB1dyyBX+9b3o8FqB/xq2//VyJuV25qFQ/IjQ9FOV9X4SeHbTA41q063n+4KJuTwBNGuHCItUFpLqjm7lwWJf3zNRhFeJYOXtUgsmK2uGd+SuUXXRglEzPRE3yXSw9UZ7qiVkx3QcX7LcnOvhTD3Ay9hmfZL8V1M8Lln399APdAq+yZKPyHpmfbfJgCsKKkmksYjlpLsexlo4BIN+wLkc7dD2ooI6oHR+U2xAv5f4t2Goykcm/MZ+e8j9pPqCAuldGvy/Jwk21ZppLorRuV82aMIRIv6XIyJkjkdgFbRBWPzSUutu8aZ5FCbrHopyq1KLcWu4Ls0AccPvOxmrykWlsggqLFftyGrKrSF+6uMipE9DANph6qMwuw9IlKyaHWgsIXFBUHDsXRZ6mn9hzUSWt0E+/MN+a6Oexs3DjNTvNHjCWjnN7yF7xNZJwSqY82ZRlHzJJGAk6qrMaE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil,

On Mon, Aug 25, 2025 at 07:28:17PM +0200, Vlastimil Babka wrote:
> On 8/25/25 03:34, Kuan-Wei Chiu wrote:
> > The comparison function cmp_loc_by_count() used for sorting stack trace
> > locations in debugfs currently returns -1 if a->count > b->count and 1
> > otherwise. This breaks the antisymmetry property required by sort(),
> > because when two counts are equal, both cmp(a, b) and cmp(b, a) return
> > 1.
> 
> Good catch.
> 
> > This can lead to undefined or incorrect ordering results. Fix it by
> 
> Wonder if it can really affect anything in practice other than swapping
> needlessly some records with an equal count?
> 
It could result in some elements being incorrectly ordered, similar to
what happened before in ACPI causing issues with s2idle [1][2]. But in
this case, the worst impact is just the display order not matching the
count, so it's not too critical.

[1]: https://lore.kernel.org/lkml/70674dc7-5586-4183-8953-8095567e73df@gmail.com/
[2]: https://lore.kernel.org/lkml/20240701205639.117194-1-visitorckw@gmail.com/

> > explicitly returning 0 when the counts are equal, ensuring that the
> > comparison function follows the expected mathematical properties.
> 
> Agreed with the cmp_int() suggestion for a v2.
> 
I'll make that change in v2.

> > Fixes: 553c0369b3e1 ("mm/slub: sort debugfs output by frequency of stack traces")
> > Cc: stable@vger.kernel.org
> 
> I don't think it can cause any serious bugs so Cc: stable is unnecessary.
> 
I'll drop it in v2.

Regards,
Kuan-Wei

> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> 
> Thanks!
> 
> > ---
> >  mm/slub.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 30003763d224..c91b3744adbc 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -7718,8 +7718,9 @@ static int cmp_loc_by_count(const void *a, const void *b, const void *data)
> >  
> >  	if (loc1->count > loc2->count)
> >  		return -1;
> > -	else
> > +	if (loc1->count < loc2->count)
> >  		return 1;
> > +	return 0;
> >  }
> >  
> >  static void *slab_debugfs_start(struct seq_file *seq, loff_t *ppos)
> 

