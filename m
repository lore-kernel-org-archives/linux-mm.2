Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A943CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 08:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BCD98E000B; Tue, 16 Sep 2025 04:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546918E0001; Tue, 16 Sep 2025 04:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435858E000B; Tue, 16 Sep 2025 04:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB2D8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:49:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A4FD21A08EE
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:49:41 +0000 (UTC)
X-FDA: 83894490162.24.9109C4E
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id 62B1DC0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:49:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=JGFqWYlz;
	spf=pass (imf28.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758012579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+l7njxo9rNJ/JdOr5wwUgtJsmJqQjeAK2bVQeoji1o=;
	b=i9A1xeg120qI88lgGqDGHtHr1X6WVPadq4wZndJUey9QZVOe13/nP1Xm3MK0R7YoyNEXrR
	wvQWC6KQ4Romvqfb8p+6kdNoIavQB+tdhLgqi2NwpjSz7/2FuFfJKRxe9VJqEMCNKudh6a
	krV/9yv3k68emIoG4PKPUDnq/8GTIXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758012579; a=rsa-sha256;
	cv=none;
	b=4aE09y+BBl8OJY9wznSRm2H2HdEZcyURyqPknhPYeI76zkyJEcAMjuiY39nnnwFccnQuKd
	RhscG/eMCqyKnrYwCNeDHAETIaBOjsVG5FCPl1YxBoOtd9HjdifX3jfqW2zUWlvf0qg/pX
	JxNC5eT/yJTZ0oLbcaGyEQJjH01nbzg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=JGFqWYlz;
	spf=pass (imf28.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b07883a5feeso890760566b.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758012578; x=1758617378; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b+l7njxo9rNJ/JdOr5wwUgtJsmJqQjeAK2bVQeoji1o=;
        b=JGFqWYlz1uxVDNeSUvu3Otb4F6jcZI/x3jRuCJgN5ldT3S5OuqwQJ4GY9ufqymSHYl
         8q07K40ggOIPZvYbhFMyv00bYFTBPDPplsVBvc7OT6SO160MOgR+Tu8RV2+ce7Pd1Hi+
         oFfm9z+3ZTSLCATG/9b6qimWEaPVWBDFTaiFPwNqD64yuP01EExVBdbSKu0QInLNNDMg
         X/9JStWBu943i18vCUALY9YpUOsFJ9aU7I5FcjqSWu2D6PxqIIing3N7dKH6VOFR/jSh
         9r6SuC9Gy5ddMfDdpChBPW6j/ZkRRgb74b3wpJZbkXtufjUZZvcO24lFzGCnwieisA/0
         w2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758012578; x=1758617378;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b+l7njxo9rNJ/JdOr5wwUgtJsmJqQjeAK2bVQeoji1o=;
        b=bXOKjPCsG8CUqq1fWYbWpTsX2pv3Za59R32GbiAs9j4Wsp71XuGJ0Km2VzN3eJSZGO
         Q242Zvjhphhmnk6IAqlp70vQoKVs7mJs7WL+zzzhmo6OU3VYAtCW+XUfgiWSxtxYXhgN
         XXxcX7Exu5wioc88xkYCNBwzYZuJI+I3eXVx4gRCA6zJQEzZvOn9OylCIdO+n+ADApIb
         yg9MAbGBOc7NausSOqAjKvyWg+BrO6z9Wri5JXNNRTBBM/TcbUcmobiHBg7xC/a0iuJ2
         eKWlKP7DpkuskCpgc1LHN59rG/qyRQnmrRyBQsFV6paSPm4w3668zmSPZGBq3NKYdgyi
         VjEw==
X-Forwarded-Encrypted: i=1; AJvYcCVJBGJREpcdxLKBLYVmmsunvm2qhGg/pA83i0GFTmODRCBFpWQxUJIEDVyqYr5SckKiOARJKkfK0g==@kvack.org
X-Gm-Message-State: AOJu0YyTKhKLqhQ1HKlsFIm6JKAp1i6k80dAZXHpZO+3qrAZEbuH7+rz
	SnI2bkRCtnXZ2nI9o6pjKF+SJhv827aw+74T/Yl26sRgIAW0BRA9+UvlQ0pPsH7DmSo=
X-Gm-Gg: ASbGncvfE1VHCHuqg+iCOis3sITNHqD3YUBSX/ViPY9/+8EjPAq1TZqgyZg7GKajrnB
	NJfuavKRtcsyt+hod+Xg8SgHuNKVVU124nPsWkvf4Uvx1Cun9kMam0FpcYtjCVc3Q5j82XODyC1
	1Z0S1nZAC6FU4wwSmdPGgyoB3TBgI6cEnxwLDJtZ9TxsbuUb8CD9gElS3h7o6xn4WDjfvxlnqo4
	djeHd4BsOrc/XtnL1iIetZJdgt2NVoKrse0RLE14r4qrttZq/SN7OaATW23u251/noeboiclTwI
	RkJeXQfZO6E9sm99uafmuRcVtWP8lGjAaIeBIsVCej7+BXZNw8jZR3W4F10H3t9uS34GLHIdqZF
	uf7geMEP/ZV5ptAg0EFAJbd+HNrZN4A==
X-Google-Smtp-Source: AGHT+IHgOJAo7l09zx6lpq7OA5lmd4gKsoEYN3davPlaYm9h05DvCWk5g9RP3GfF8M4IyLBJxoxo4w==
X-Received: by 2002:a17:906:6a1d:b0:b0f:a22a:4c3c with SMTP id a640c23a62f3a-b0fa22a5935mr830824466b.48.1758012577619;
        Tue, 16 Sep 2025 01:49:37 -0700 (PDT)
Received: from [192.168.0.24] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b32dd601sm1106547066b.60.2025.09.16.01.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 01:49:37 -0700 (PDT)
Message-ID: <cfac2d98-2214-4bd3-a4cb-9b319acb462f@linaro.org>
Date: Tue, 16 Sep 2025 11:49:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] Linux MM Alignment Session on kmemdump on Wednesday
To: Matthew Wilcox <willy@infradead.org>
Cc: Amit Shah <amit@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, Aneesh Kumar
 <AneeshKumar.KizhakeVeetil@arm.com>, Christoph Lameter <cl@linux.com>,
 Dave Hansen <dave.hansen@intel.com>, David Hildenbrand <david@redhat.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Hugh Dickins <hughd@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 Kirill Shutemov <k.shutemov@gmail.com>, Mel Gorman <mel.gorman@gmail.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <mike.rapoport@gmail.com>,
 Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>,
 "Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Shivank Garg <shivankg@amd.com>,
 Sterling Alexander <stalexan@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, Yang Shi <shy828301@gmail.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, rdunlap@infradead.org,
 David Rientjes <rientjes@google.com>
References: <426751f4-428b-ed01-509b-d13e719a2006@google.com>
 <aMhgoUvziLPNt_vI@casper.infradead.org>
Content-Language: en-US
From: Eugen Hristev <eugen.hristev@linaro.org>
In-Reply-To: <aMhgoUvziLPNt_vI@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 62B1DC0002
X-Stat-Signature: x7ccmoyknr5mqp3w7zdtmmzfjh3rhz48
X-Rspam-User: 
X-HE-Tag: 1758012579-625460
X-HE-Meta: U2FsdGVkX19LU5mm9rC41rm1C6jaTE8GcdLh3v0QZ1HOhGzWMY7QMlzW0gkpAk5SjUheF/o9NvqnFqWG7WeYsBpYCgdDvo0dlNZyYWbtSsvzb4CzzsKY0xEG9zkLwuYT80UzOW2re+owXwIFISfepDoD9jrxe+0rb7DaJxSvoCT+UV68zMHq9165dVmAkb8X4w3MsIK3bS1uIPE16Eakt1url1igqwHXiwpdnMObitjgJKnGCzAEzQLVenWIbLfcTyuFCwTvimS4Slhkm23/xL0HXQvVhGQ/25vrosRYIyLH2sj6g+BD8Lt2gma/35WOkxVlyordQaefpfXzHv0i/QnMINdxNyMXYT5X2CJQF9X1Lbxg/np1tc91RP98HXZqDPyZMRaHxPmoC90NRbsU6BDnujcxYvyCYPoGL1F1tAI6yZq1HmUviwpARpHj4hYPsfmLHCC1raVQ1qk9yMfN/GPl3hz/1Po9ZqgjDMorPwqDl90eW24RWsYaQ0jor67dAd9/esn3FC8yeRoTxpCeZWuheM1PkiSFeg4tISKKS6gQiWCFYzovIlfzMFOByKGvqoY5XqXZ3LRyv/JuG4GAQ9/32a6ZRw13q0Kq573vwujDKjDAk3VRg6VLwCINj5xwX5XiDIbN5f2zXPZ4EoBFjgcOcq5SzKL55Yntd7/fYlwlU6uE+kRO0gsZYv2HDkqcin4mNMG2rpV+iCL178i5JiNZNgf5PJkp9LrwZsHFvbcDdlTPP/0FbFk6T9O9s98lXAQbC+tlf462D5XhOIFSuoAkFbX4E1my96883OSArzTtgVttv3jEn3sNLqS7KeVbbUdcgSxRl/X9H9PjrkIMvLzZmFSG2JRLPJrs7wqf6CyLp1bO7OHD5rhTB17WuX2lF3uLSiobE+W2798kvSSb3ngsYbu81p5aHbI+e8y+xYrGkKc4YwdkWBVGfXVKl/EIwHSxxsa0/iTlBgpeZuT
 tbXmEcOC
 AcZ+t65rIzyLKl7kGpx1AfgLtgkMom3fkP3wa+CWPQpNAn0FGWfRMeqiLPZKRMipk+bOnaB1Tfx2Tac0ZeB88+/OOIItTJLXviBD3snkNj64g7AHMlHm+nR9sxSCmHu7s2Lwc+jXPWg+wzkDtiWFpPVA5i/OGjS3IIxRPxm549PqwkdNeIH5gqVjQphK5sTR1fT4lPhv20wIBkHIv+yna3Se+riroOqktNkufgPF+1P6dwB87pp38bzgNyeIunhEuuhxgdWYlPx3CerUTBr7g7gJzc1OE2zGNFt4GUOoW4qqIiYJ00Gr2twzFstFSZPB+F9rLaPGd+Ske1fnJYv/h2iMkNGZVvPZ72dI2hzKEd29KXSoeQOM9vSAYnD1UE8Re1s0HDRO7bar4sV6JdfqTJJelRgcB03tCoBmM+hOoaNi1djtnjJxSamCY/R9NFTx/0/GruqHxezt9lXmnllPbl7/j5hETJDT3psTlVeicaodu1hg1BZZVJuNe+9r5fRo/h6LaHAGuIr5AaZ5RSsIHVh5SXeb1slDTIt++UIXIyzQXfszqH3VqiPytMwBJgHNo8nrx/s3YOkfUc4j6zTA66iR/k1bscwzciGhztp5fR2xEGmM3W2u3zXAd7BkgoJFkerPWYObuk0f8Trp59qjKWTlW7vnJ1Zy7hE0wRhL36Z/j9yI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/15/25 21:53, Matthew Wilcox wrote:
> On Mon, Sep 15, 2025 at 08:58:35AM -0700, David Rientjes wrote:
>> This week's topic will be kmemdump led by Eugen Hristev.  See the latest
>> proposal at https://lwn.net/Articles/1031319/.
> 
> I don't understand what this has to do with mm, to be honest.
> It looks like a debugging aid.

It was suggested to move it to mm/ :

https://lore.kernel.org/all/0fa9e4e7-1247-4c82-8c0b-fa65b7fbb56d@infradead.org/


> 
> https://lore.kernel.org/lkml/20250422113156.575971-2-eugen.hristev@linaro.org/
> 
> is a great example of how to write a lot of documentation that doesn't
> actually tell the reader what anything is.
> 
> 

Here is a link to the v3 where I changed it a little bit :

https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/

I am eager to improve the documentation to make more sense out of it, I
am happy with suggestions.

Eugen


