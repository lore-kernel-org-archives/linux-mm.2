Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12824C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A2888E0002; Mon,  4 Aug 2025 09:58:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9529E8E0001; Mon,  4 Aug 2025 09:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B098E0002; Mon,  4 Aug 2025 09:58:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F04A8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:58:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21F78135756
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:58:14 +0000 (UTC)
X-FDA: 83739229308.10.37A8741
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1AE6940007
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:58:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZhMnbanU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754315892; a=rsa-sha256;
	cv=none;
	b=mKz35AOfy+EFgAQU4GOd5tC+hQ0vERxlym0YZOhTR6mBrXeMNXxpoIU+kzpPVJ1Vf/U4aQ
	HB21f+xHDYv2mWO9FugliMD44e4gQhUIOyDPnwwY3tn6cRNTDQIs75wtvDoAhIuE1ng94a
	A04PgugNDxJIswaDxO0uhramF3M+8j0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZhMnbanU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754315892;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6nH9mwDo+SKs+eu5EAc+RFrOjQE450AHqVhPXYjbMU=;
	b=8SnwV2Atc5T2cUa0mzFPOxtavPoKjE4ON0UszbliGA/9dcZyPz6Knb8amV7Fgnnzq8tHdL
	XAsIrhKkCaFJvLWk3yeB4p+Wg3Gx1dbTMjIvAhdjsluEABGbrlSzqspSlnJKGfhDMa/hx8
	7KwOGQQcLq5x0PhtLfuZbvt8KJpY5nQ=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-af922ab4849so623053066b.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 06:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754315890; x=1754920690; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6nH9mwDo+SKs+eu5EAc+RFrOjQE450AHqVhPXYjbMU=;
        b=ZhMnbanU8xog9CXymmCOeohAJrieSA8EriW1I0hBrdePZo297I23UqqCLPwzMFkKsb
         X5uNwvTHYB1vx84UpDrllxMnMsbFprNsVLRQwlGACRIpt9uKsrCOxKflWoFtCSktaSO5
         +uFkDVF0JOi6Qn2C+F+GO1oDjgeefViI+6IEjoT5JLQhmRhs3W9kGPgvIih560x0B1Sx
         Kl7Bn6+hHu3LPazp9zHM4DK0oi3Q92cCVbD4IvlRDGwPOxs4E8gmO6HLDO1EIA8+wxdA
         5mJAVMsmrICdU/rltXCtC6Wg8SC8WxWbHz2h6BtVjjr/nQ2SDzIn4RFyizarBKODiPyh
         dq7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754315890; x=1754920690;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R6nH9mwDo+SKs+eu5EAc+RFrOjQE450AHqVhPXYjbMU=;
        b=cW7I0prxlrmaRQmJtiM8R/I8BuM11Bqz6IP2whLJzVI7b4+L1e+fkteA9HYjtP+Zme
         Y9KUMSvsNt1Ej+rloRUyabzA27FY4cP1b87oGCSYbSNgUHJh78EsTVduzzXuRJlPPtpO
         r/k1dIj3aaEUxXF0B6ZCPc11F05yL25dMMthKHFgpB95t1KgRCQufdGX6XKSoXwvBCXy
         OxM5V5OYQ9Hc66YskEvGO7qkrq019J36S8c64H5Yv/662CqxOXXUoX/VS8uDyGu6XcbK
         MveCmtAPpx24ZETt8RByDO+ysj6BIhs+iIQqBEfTNYZ93CrNz/WXOCzI89H4ig7RsZGE
         xdpw==
X-Forwarded-Encrypted: i=1; AJvYcCVujzrq3/Hh1Iy5Zx7P5FKNxaxK8nNT30b0un04kuJOBwAHZDNp6/YhuxwOR9UFIthrYpzsih83Xg==@kvack.org
X-Gm-Message-State: AOJu0YwgzkH+kOG0WyzgsVLaYTaRK2bHmwD+DG3ygKV0YrLTticQ9LQx
	UmuGdJcjYLrY2MTmuV1rvE8vRVipXMTBGrO3/wPZT9UzjrV/uvHZZ/zz
X-Gm-Gg: ASbGnctE1/f4uNtjPn1aQwtX7Dp/Qgri0/1q3KItqGy7kmEJFLNQ1y9gxxIG2M9Iccw
	nf39p6FhwMN5asjsd4eKHAzKZ7QfF1vJSe8GVkpCZtYvVVQsAxKQQEVEgtKbHz6ccCwQ0/oXmNL
	jOg9d1mcqiowKRCzTsyQTmOeIIAtC1fzf0zq39aNKlgLztBY+DO4OwNKRmEay5oSrxsfCVX3Z3/
	+g6463+nGuKN8OeTR2Cgr8h41sLFddXAi9/g2stX6aJWLxGt/6hUtc7GU3KNjarr9EvdEwMqKCy
	d5LeX1wkQgfjspmSUyImDe8biPbnJ4VNV3qwTZQkFIcE5p4feGlJulySBXkRMshRtBhOYJDOm1N
	PsQHKGEoKYHfVh9nFcWxQvA==
X-Google-Smtp-Source: AGHT+IEeQfY3MSWthT8Ao9kpQimR50e71iEaYl05yEUOFTDVHb2+wzyiUYPcn/Ce5Figlv5HoD2IZQ==
X-Received: by 2002:a17:907:1c1d:b0:ad5:27f5:7183 with SMTP id a640c23a62f3a-af9401b0eabmr1088550966b.39.1754315890155;
        Mon, 04 Aug 2025 06:58:10 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a1e820asm732638766b.90.2025.08.04.06.58.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Aug 2025 06:58:09 -0700 (PDT)
Date: Mon, 4 Aug 2025 13:58:09 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [PATCH] mm/rmap: do __folio_mod_stat() in __folio_add_rmap()
Message-ID: <20250804135809.chyyluhyua43k6t3@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250804064106.21269-1-richard.weiyang@gmail.com>
 <c9dc9322-c439-4f3f-9f7d-26529e94c882@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9dc9322-c439-4f3f-9f7d-26529e94c882@lucifer.local>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: khff7tmqsye8upesisw4ggm1dy4dkctu
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AE6940007
X-Rspamd-Server: rspam02
X-HE-Tag: 1754315891-774792
X-HE-Meta: U2FsdGVkX195RKa1sZV3Q6IVXlJKYMHTj0rEMId0BGg4SLziaUuHfiTLPVyrvG8tLWifwlhjHWSKq8L1d0ZmDmsahWOIStF3vPw7Pc+b5T/j39yQQYCJfO0un1CL4wc7YtSQmjjJ733NmZd7TYAybJp2EDzNs+jqScgDQ7zxY2x47yppONjVdLp3jSGhBBbyzEGutDZjpvCgu/lrrusTHVX108fCY3/3rI3PvhKKkdkaGVZW+L91aJk0Dh3xL7UjCvF+zBkLeC6HNiR7iviATVKCjBtMdAHYlZrD/g7ksXtCIR6G0nWlhDpN2og4nygwwq0xq4NjQJl4/a+w/dDBouvMsrATKiRjtFCsKSo386/UAAgWqI8OmgFTIZNmluawR2t95QImJnaY9rU1FCpJmXN63kSxhL2oGMHVLrIisyhSVxpUIx4xPcw93fKVUvZZCwdcrugj9FypObiAeufVT+7WlnL42ae1Pfr+SDfIe8JM4Tws18RAqZAJO+ZEvc1g4ku+SEF+mgoxyv3NdSObSRWJS+umtBFqTiMt8Kc75MbXDNQDynEjX5DbcFmv+50seqwJxrzAga89JgFFXdWBXqkbg7JZdB3Rgac9ByrSGmUgtQTiXKTq5QD7CO/+9iiRSBTj1XOf+BoHZyhk0vcBhlOfCNQWcZtSHQaeiXdCJZ+mWO3jTQr4vkup97VZFm9tiWm+g94ZyuawwfRoJu+YR5WsN/J2uFp0fQslq/r7Zzh95EzNeTZCGQRFItUVgb99tAcjtlKMR4kb+1nNzfomoRtK1FyAK0upmSGKRM+wHO7IRBW6DCG8vNMdZ6wF9FNdhoHHIV1yeJOd76wjVWtGo0zKEGzyTQkagctW/4yNyUYGSgfJl9TdJkvUrUQcNylEb3ciKLMjvHLo1gRLhuW9aXYBZha/ZDQqgAT/kwinhKL2GrnnBUkgP47eL0Pc+98A0yW3LcBnUSV8VfGEqzS
 cGXdV1Pe
 fNOvJa1uACPadK1c3xVSuxLQbDW1gcvbiC9UYvNjtPSHqo2uPSiYQAj8+t5ahAOEEVqmBLu30hMUKzcITu8W8hf7jITaKnuxPtfh+3jMSimrNdS9GGl1qt+rGIk1TWNwlHnUyKe4PmUJrAjFeYPzPTyOXnMGlS9e01Z/yzfeoYuZU/AKdWY8ud/MNhI3ZMKAtJee0/bWzc2q058VfN2CW5MW/6o/5Z4ja7nZ89myvVHX2+T76BamQ/8ozGmsQYLS/1OqWsJsycjYuug7Y6c5KBKmTYuJSssYS4rchb2XO9XQttPefoDHSf889NTvzB+Br62WORB11Rx2GwWk/4UdYnfeNByoYuC1L+swE3M6bF6C91jXRigfBMjO99DT6DVlooKNe+cUCk8d+5QaHpthJaZwchXTMdkuugmgokJqQHIwUL+302lulzOKwnGMvnqJw+wffj0a9wrwUExxrh8eCG1yxqTkW1DUpQ/qe5dGReQOeOs/RSTL7DWho0977X6nMkARt0TcYaPT+QxI6dOlpaug+x2CpSE0KwiIPs5LG9pYtSXTvSQSJ0UwHV4CQ0PYDlQlxeddh1AFvjOtuDql5I0xy+iersPSG5f0AiAQEpT8fyaUEDqSDgB8Rjb7lvQ+N7XCnGzg7EnhcPDMplcElMOMzH9UiKWi5NeCLEtcjxt2fgRGf21yTmfz1D1h1zPslNszDBm3miJGB0Hy87WeNC5aEgkFmFEiPMAJeARE18Q/c4QW+UCjTXh3pCmMoFKYuS/dpBHUYuNF6pOBm2FNRBkiC+8w7As6LhQ9Z6SPdjIZeQBE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 02:20:10PM +0100, Lorenzo Stoakes wrote:
>On Mon, Aug 04, 2025 at 06:41:06AM +0000, Wei Yang wrote:
>> It is required to modify folio statistic after rmap changes, so it looks
>> reasonable to do it in __folio_add_rmap(), which is the current behavior
>> of __folio_remove_rmap() and folio_add_new_anon_rmap().
>>
>> Call __folio_mod_stat() in __folio_add_rmap(), so that rmap adjustment
>> family shares the same pattern.
>
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>
>This is fine.
>
>Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>

Thanks


-- 
Wei Yang
Help you, Help me

