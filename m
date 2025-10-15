Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7797CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113B48E0023; Wed, 15 Oct 2025 05:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4918E0002; Wed, 15 Oct 2025 05:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF57A8E0023; Wed, 15 Oct 2025 05:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DEC258E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:38:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8D7B1A0B6C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:38:29 +0000 (UTC)
X-FDA: 83999848338.09.176F089
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 27894180008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:38:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UCLZKJmo;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760521107; a=rsa-sha256;
	cv=none;
	b=FsgKCj1QHV9exCGELVG/IYHU0qrCygN9tM23hxeKLX4ThjpH8J5FTXeMFbO8HeVdTen/XK
	2zL7N0XvHjm+j1JbH8WIziiomVxpEv2n7BijZiSjesM2rkWM3KAzGykZlOvEv0L3Sufvgd
	MkoXbyXAvgU5o0QnIyIFIDWftRCniVw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UCLZKJmo;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760521107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LSnX3eo6FeCXOk5qdLNLUhr/jZIvyBJy0HqMaf4vWMA=;
	b=rjzBB9ZyUByQ0hAqQX/iCOWly29VjOx3hyYkTy1k5WFjc7pn9bDmbI01upFgxo0J+xz3zb
	YKp5drmJg7hMaOjLLWKpdP4ieX7+yEQpJKCtb+FXkL+wkXbINU19sHQttzOFyggAVnFtfy
	+3uGTjpJQqWYYyEnnMzc1XWoFthtOqk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760521106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LSnX3eo6FeCXOk5qdLNLUhr/jZIvyBJy0HqMaf4vWMA=;
	b=UCLZKJmohisr2446hUmwLcuF+prgRCBLRNbeYD2CebpXW+783QzI4iSr/WsHI24jrp/lST
	NYCywG3tMP9c+R3RzTyeIfnX4leDwGDS0AM3SLE+fG3mHxAzb29sdri8dRCuNE9lnen/Ap
	MfPgTIskKwserzFtIqUo1O3FqiJmIPk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-qfDvlYZOP3eoHFNESKj3bw-1; Wed, 15 Oct 2025 05:38:23 -0400
X-MC-Unique: qfDvlYZOP3eoHFNESKj3bw-1
X-Mimecast-MFC-AGG-ID: qfDvlYZOP3eoHFNESKj3bw_1760521103
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-85709cdfab5so2656525385a.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:38:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760521103; x=1761125903;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LSnX3eo6FeCXOk5qdLNLUhr/jZIvyBJy0HqMaf4vWMA=;
        b=bcTuESuZAnd316T8jnvhJ5VMvO7zIP/yHTdCxfAD406DHi35aOZgNaK8+l1ctlmU8Y
         PtD7B/rmtdnqvVY9VWzQlD9Brvn2OPM+4JxWCCLvU/PbMgesAiUyl7F5GrQWTJo3RNYZ
         T/tAxZyQZd0Af3b7NNkiamM9F/qjk+o2dGh3siu+dhl7u1WVHYWTVisZ8oPHbGh4eMTC
         FdV+wx6R1pJSpMbzGyW+heFZ8Zh0youfbWeiAW1b527XfcHJ9t7qltaf7pFIyoCRDoVz
         MMPOB5GFy1wR9SQYZ+RoC6LkuPEkg8xmPVhhY1awMFJzhnFB7sTgpIVZ++6EHS4sQn2Q
         LwNw==
X-Forwarded-Encrypted: i=1; AJvYcCWfG1sKKFZzNbLOjSB3AIL+tHduvPUXQIYP/DMXiHGjwUb5grUS+Dt/oCx1Lepr9e2h3nNgm9CfJQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4+bolLgAs1QCnEWT68tEhRb38MsWMMGTMce3ZfbnPRuOyawW4
	T3U+4kGzNtgXH5oF72oNipIDh+cgKBNvhuBQhYNuxOSQRynfQIIGSnpQUI1zeRuv5RMaeYxPpt+
	/Ta3Pr+wSiH3cHVHt6T2GEmVjZO9rRPrye+xNzu38zhYsHZyEzm3t
X-Gm-Gg: ASbGnct8viXrHfoCwsNUGdevLc3uYAZLPdnuuqggtwtP/B6uiPXEKe94Zogoh/2SKpF
	SQKieiogGuWru51LNFoPiKYAreEm1jkhLGKyj4FcVI79fSASV0A9ja1VsyDLhm2oH7h2+4Bz9j8
	StVAWhkI73p+KG6w1Yq07tZXTklYLbFx3uIkv71lfCAQ8Y7iUhuRDWQOWRvP9UcJ6EngCZ4C4gP
	aadtm/SzSqGzqQl+5Vn+S2PLAAenRJJZG/CdvDr2EFGEKiRnGrveoK1hYn7uzn90+VSse3Agl7D
	F7LAEqrnYLLhnfuLyEjCS4+dNpYOUdXDo303XMcIVLlI+lfV1NbLr4Ccb5SQHM0=
X-Received: by 2002:a05:620a:bc5:b0:846:1789:c1cd with SMTP id af79cd13be357-8835547babbmr3728923185a.70.1760521103304;
        Wed, 15 Oct 2025 02:38:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9YggiDFCkRWPoV0rFabAjs5kcH3qOcSU9F7Oo4eJx1pRUhYsQ2aCSSzNGyC7YFs1DlLlE1w==
X-Received: by 2002:a05:620a:bc5:b0:846:1789:c1cd with SMTP id af79cd13be357-8835547babbmr3728919185a.70.1760521102732;
        Wed, 15 Oct 2025 02:38:22 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a23693a0sm1357643785a.53.2025.10.15.02.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 02:38:22 -0700 (PDT)
Message-ID: <52c8ac78-7a79-4a92-a371-6fb4520a84d9@redhat.com>
Date: Wed, 15 Oct 2025 11:38:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm/khugepaged: fix comment for default scan sleep
 duration
To: wang lian <lianux.mm@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
 Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251015092957.37432-1-lianux.mm@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251015092957.37432-1-lianux.mm@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lY3GcuikdC7p8LOmA1algLUzeSjrP3ZlAqLh3a3Xn5U_1760521103
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: w5edsfxjeathmypwiw6k4ch38mxmz8uu
X-Rspamd-Queue-Id: 27894180008
X-Rspamd-Server: rspam09
X-HE-Tag: 1760521106-28572
X-HE-Meta: U2FsdGVkX1/QcmA7KMaR7hPks0XcTB++wcRBgI2OnEuGkJFL50Vm3htj+kZf6atS8Dy5PNkUbuOkdbsO675eTmRox5glN6UN0B2mgNlQdtndOJbPmbYnuoqPWG7cWfkyGAQ9AZxA/r4kzV2VeZDR8RBRku+NAtg3+b+ZTPdPiHRssEj+Rp3He6PFG2SugYvQDue7/VVe2z348SBr105mgmyZ36N40UCoTOVid2kr+y6gW3Uf9XCvMohDdJ1lQBtFEUDErt4ZbcnJXHS2gUOO4PSLv9ZjjAt1obCp1bwgejwG0hu1+yHn/ewEeYdrF24KLgi1IorZhrS0Sx7oYnZbowaaj+1tdK4vBK8kK8wsbG8pK/9niN8nwEAHR0m3FwJUMMUUe8qlYOHTzUojUEg4TeMkYJ6ou4+GVDlwz78ICBBlmQ4fpsXw1oPigEModAWnhqQbOLJf1bnXUggVHkMUXQxLBEmwzCIkIgvBE86+uRMqTJTLHx04N3EZyT2cSzzfBUtBBpT3b+KcOENU7FpWZsh3V9NRHb2v10TR3AQgsNVq8wQiPRuDsv9VhDU4PdJowui9JV/en28ppfqF0MNAaVTY11SDr1ZNoHJTyhDyAjMjYBLey5gGFSrrn/JI+0uq+PbyjG/EqWvzynEOY+pvJQwMrz3K9aTX9441jjT49fY76GLrHAXfHw1isIwtePJDxkWoe3r7x3gBA+72ibY2hI55ItAV0dT5vgriYbjYgdBuYci6Ot66u9ZU833Hl5Dy/W2Egu5AZ0ODFwf6fs43bzQhtJKQsGMR1KGBr8juxuSdtOAXlMT4mi8O4eoqTp4lYLQVW6ZkD+F++QwcuXgzP4A0cmyArEDDDpOIYZW8FmM5YkuAPmx2QQ7tdvZ1xGGvxzrXEHvnEfmacFpt2htHhODw7ZlRnedJHyVcwWIefvCV4jKo9hqyy5Iz30F0tzpTMPsiVpjXXFckSQ5D3+Y
 DJXxDKE/
 aguICA7y/tTydG5HwhE8y1jj5cLqO6KgpR43cV0ye39+RA6QrYdfczAPLcEd9rdgMj44d5wx9pG5OYXlJddFWDLoW/7xCdKzbxGEpbeHzGHs8x0Yl3Xow1b6W348RE2RcQpreB4OV+bqOumqMZfSjik0/y8wxbkq2w/12/kIKFUwIk75dVWc2X7tsz0SSJW7xw0TtsgfxNtKBABD+vnKOy6v7mKq6+9h1YypMvV6KBAUWsqTXbKS9/5J5GameX3VYjTskH+Xn/zicDT838hs84Bbv1uYcjxgmjMHuV8UNWYzKZJ9dOSzRW3sIMoxitsq+IuA2YzCciqDU+M/W7O17A4iEg0OYYYtEUjz6dMlCtHPrVuVXNHhPB9j2nR8crSroFQu9GoFy7pQwqagGplNFfcUQBJwEoUyG5LRnpPCbxQ5lp08eNtaQA4YTsIXeOAdx6Ys5RMMYe1xQVOMrz0E03h3tbMF1E0XnIIvayoiSaODOj+jPgsLynA7PyjNNeCeO1i5I2P4pXyAKFVE5ewAV7a5zbl1d7tY3Z+QlT0tMpe6mFPthznUZylUrMzFZypAU742F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 11:29, wang lian wrote:
> The comment for khugepaged_scan_sleep_millisecs incorrectly states
> the default scan period is 30 seconds. The actual default value in the
> code is 10000ms (10 seconds).
> 
> This patch corrects the comment to match the code, preventing potential
> confusion. The incorrect comment has existed since the feature was
> first introduced.

"While at it, replace the magic value 512 by HPAGE_PMD_NR and use 'ptes'."

> 
> Fixes: ba76149f47d8 ("thp: khugepaged")

I prefer to not have fixes for comments. It tricks people into thinking 
that this might warrant a backport.

Likely no need to resend and Andrew can fix it up when applying.

Acked-by: David Hildenbrand <david@redhat.com>


-- 
Cheers

David / dhildenb


