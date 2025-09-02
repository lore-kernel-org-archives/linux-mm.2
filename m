Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E2FCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C768E0012; Tue,  2 Sep 2025 04:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42D538E0009; Tue,  2 Sep 2025 04:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31BE18E0012; Tue,  2 Sep 2025 04:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8B68E0009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:29:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3D3613B6C6
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:28:59 +0000 (UTC)
X-FDA: 83843634798.19.BA5F570
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id D79BE100007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:28:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="lhgTWfl/";
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756801738;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3P/CGRELA2cwqjSr7vg0wYPdyQiu1PsJ2peMY1heJU=;
	b=GdWjxby3eTVN5I36SMj287lVNOC96eAEv5Bem6s69qG10NC0xWPbnV2qazIMaNkE82TJN7
	xM0ttXWBmVCsHNX4CTxzttKo4l/Z7lOa/ZNk8tZc/8idRNmSt/Y2Uri51L0BCurUwTPW9l
	jWLBn/CvHEnXYkJy8WGQPa6gO1/xd70=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="lhgTWfl/";
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756801738; a=rsa-sha256;
	cv=none;
	b=MxAs13wXMq63tvO+R2hn6ywYXgD6qYlZimwIh6qQtZCXJVh3xaBg9Qn5Dxmkkm5Ld5T1aL
	7N0oJaQ8tYhE1LUxtj5q7jiWdyxlSUZPrMfrLl3LUi/2tbRIr67SzuoZYamr5wVQ5uSAKr
	pBn3PqzFQGPNzWSEE5nmxGVuln/wtNc=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b042cc3953cso218293666b.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756801736; x=1757406536; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U3P/CGRELA2cwqjSr7vg0wYPdyQiu1PsJ2peMY1heJU=;
        b=lhgTWfl/qIrIw/InGneEidsfgKH9VuT8qZR14kX4Z8Ljt/b7E9ZEXJcPsmqT7fAHAA
         3mDkCpHTJvp010ur9GrNVeIG9vGLbWkOUfJ9pq653PZkbTEfS+DtnNNWt9OqUv4tEffY
         bxunOEIuxpaGESbZMmsphtbpHfgKNxLsQb8blU2fVfzf/SJc3O5ZaRtM/JWzxeLCWsE+
         M4lRwDAM13oXuQuI1OiXYGv6W94YErSOXF3N+TiT5Pi5SB1CutOibVqr5Bpmu7ToLj+V
         DeRLs/A2ZOUC1wm5T0D9SaJR8Ie6DRW8gF2GLV5OSrYS5N1TLiNkzCHdF1F4iDN+CgbQ
         8g0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756801736; x=1757406536;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U3P/CGRELA2cwqjSr7vg0wYPdyQiu1PsJ2peMY1heJU=;
        b=ov6P8QXgv1tEeKsVTmObNCPn1cCLioeuD0z3IPyaK1E+CPY4IygzM24dKwITItKGBr
         fKm/XM7kDtUHfga+04hgs6jisGKrSavNTsXnohntw4mqdecd0/kFyD9It9K6+ZIcPh92
         cPIC1Hxuova+x6vgnjV2V5biIaj8m45z894XQDJSjeM9115ZviAlI7zyfzgjG8wgkeix
         Q8sGqyhloWcTFGxpiI3yn6ZA4ZLLKKOgG4UMW3O5PfI0R2bP/6/rUllPbmkjJAsF6H7V
         G9iZwKFCABruC9tXqJAEG/X4hymesh1qwm66wYmn5+XQMeeH9Z04he4aI5QDGCmEedAN
         FnuA==
X-Forwarded-Encrypted: i=1; AJvYcCV6VKG0PvqW1J50BmFyJL2gZfds8J9d1S2goAfCm4a5RJi7b8FcEkOD5dwoA4Y0g7KsTpc/Or7dTA==@kvack.org
X-Gm-Message-State: AOJu0YyVzJyuvmJ9b8OkRZpX1Cvts+nrgsbHwwiYJilq/XvMQV1XX7xz
	ouDosqT43rvfLhUfjswvui4EQjNARCwfwRjML4QQoYIoMwHm1QF+5US2
X-Gm-Gg: ASbGncu4ntiaF7k3v2I9Kyh6vo8lG3UJcehe1tZZFXeaekzAIJn7nbwnDb2OVAj+APU
	uPmwJ92KaEaFWmEb6oBu6BuaWndUhxMetIKVmR0FJrRiZu0LGurT8wNsbS1U6KGxPqbWcRV/VPt
	uu2dmRWOFhqZ2OxPPajF4fzm8vb4gMe3DWrQ/CcD82PrSl8tZxWpRnVzKfCQZB0y0mI2gAeMFGB
	QIuudexpvINkS3DxsqxwnhzmnUrsC1QwicLOhiOpdyHYBrtuN7PEo89NSdzXK4Vky9HmLNGOcNk
	51muq1VkTtcUyLJMIviPrVi+mZeOqxOzCVLwb8FC+ZEYm8NKHwzCxAiq+O4x+JJA7BY8Cc/a8j9
	FdE1dGJLFdkrTTEin0AIps13Z2BIJLNfUQEIqDRgRRQlO6Uk=
X-Google-Smtp-Source: AGHT+IFb9rOq27uofOw29r92S0PkBoN7HR7b+VmwnUYUoa6nyVqak5YoGAa9Gh2DOlkMJeWTVVZPVA==
X-Received: by 2002:a17:907:3e03:b0:b04:59d5:fb78 with SMTP id a640c23a62f3a-b0459d601aamr40455366b.62.1756801736121;
        Tue, 02 Sep 2025 01:28:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b00e4b740fesm818710466b.47.2025.09.02.01.28.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Sep 2025 01:28:55 -0700 (PDT)
Date: Tue, 2 Sep 2025 08:28:55 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Zi Yan <ziy@nvidia.com>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
Message-ID: <20250902082855.muyi3wlxbmkcwiu5@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
 <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
 <61E58B7C-23D0-49FE-8D0C-CE0B672114E2@nvidia.com>
 <0a0b0018-9427-4201-bf53-6aeb251bc482@redhat.com>
 <1D88E773-C11E-4F28-A13A-1A681898198B@nvidia.com>
 <5a796574-0a3c-4040-b0bc-3ff757402759@redhat.com>
 <20250902025112.d2n3o4imeptppctd@master>
 <dd30710a-a210-44dc-93f9-1e7ddf096251@redhat.com>
 <20250902081342.rthx5sopowmg4hyb@master>
 <05f628ba-c24b-4180-87be-e5a577dc4e4d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05f628ba-c24b-4180-87be-e5a577dc4e4d@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D79BE100007
X-Stat-Signature: 5aq3ne5srzrmjd5jg6sng314erhuq7is
X-Rspam-User: 
X-HE-Tag: 1756801737-281874
X-HE-Meta: U2FsdGVkX19NikOXhe4mIu3DtwnZnM+2l1Jw3jGRt8mP+fvpXuj+Vghr1Wc1OZY3oDl5/cseFxv3qHGuggYJYvumFDPFTAVgR2pafn6jTMFgStYYWK7BaUOCqww5DTOJBY8TYUhEbVTugiLqiG78l2CqfmHNTyFhh13WFuGDZJR6Fmo0c/ex76xuKNn7RCR/Rgfg+YSk4KdZ/cc78dDS9jntvZmnS7ujmYn83UFPgNtZg48dzoTZAOrMagHGaEvWT0aAYZzuVJqIPOm/A8DMxZM4y9ejSAHh4G+JC4KcbLYBcPsBFntXJDtbZbSk3QzlOsVsUpudvuQjKYSYKYARYR1ZtdZWjMJmHy0YusS8j8DF7rxaM+WXpnZVXCbQgqKQnSB0OqPA/eq9sfO7TRNAUoQQmjLB1ZunoIRO6uQOD2MPtXxGBPcZha6/Yvp75axmrjJNqf3Dqc1/mEVE45OvjGUTrqWysSdQsLORSjiSnesTLZqbpfsczBRATlp/TgvL9CmXw+1EvhiSn6oDM8SlwxlOgx/H6HvZ/nNBEVhWliNDpxIQt0c2ESkQHHc7fllnSpHqkegnBYbzIJ65/MXK0Fs0MiTeAgnvJm2EyyZzj+LFkEH8FKcR0134hUc5SWmJr6v3Fu63WHyuHWErckchKED8ApHt25cN3C/Y08bf2EkTeRbU3NIJMQDxMqvbcW4xtTnX7vsf+/ZLJf+f1osabaeq4V7ba/XoqfYmYW9V3H1kcv5zYF8sXbM1g+v9wakJotqVgSpxt83Y7tIsS2w4C7+E1w1OY7gNQFO0uVmnZ6d3KX4ryTMcEt6PoTSxLn8oUdGvINIQLCoujZZuqsklt9RVd+zFglwaYViOU2lkfUq/hFiNRUbXWCeBRCERu8Xyv7FUFMt65f1+ynXTCO9LEr8L7bH9iyT5vJMDaYUPcY+IuAiJVbKOTzw8E1Sx7CWDVgHrF98ca20leMo2RnL
 9+M2HKqX
 34JMX3XFLbPJlxTytN841TRaS5d6q+njMdw2RZ1dRtw/VDIKJGuhlwtXVkBrecA6Fqiwv/kJ/jnCs2wvXHl9yTraEvhFvCdxEhl7aZJj0NRhNZjCdsoOQtBmAVqcHKHP2rUgj1RjVixRldEwRx2n59P46F99WVG9A6nNprQ/MpZRQKBiEfMpgsnVQRRpVscQ2Fpq/jLzf2kQVta7SdYrjUghcJMntdhpi/FY8o0S0h3kxNFdhdc5L6a9yKeOabkmG4g+g1bad7RmWrIa+uuzG5TCkb+uRuO61+a7zUgzNXA7uwfmuYgNKsbWqcbQlJqEk8SoA8GkEAe8VEzsMLo3L4/2RLOmblrzaF5nYSm2IEoai3DuYaIPxk3+aAbl3mJvnlih/GENA7FppntMyOleGViYNVrk2EXh3mLUjXI+XGKmmtOTXjiTENL6U8lFvGzaGBWuuG+yKjbz/VCmwZrRrADP+Np+hdfrBi7+gmcLyiH7YY/VjsQ6Nmo0b5uA9oDP131WNjsslg/eltFc1bnpQVQ1sWNMxgp/WfFpOx8NM6uGZblNIVQ6gkNPVLwNpKVVzj0ZEGWLtzZ/R6UcHDvEZDY6UTJIM227TDa0YpZiiABDFl9cAHNR5i0sNthEUfQoeYj+QixSPzSTtj6sX5ZUsA1TMx7d5zIG2pb5y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 10:23:51AM +0200, David Hildenbrand wrote:
>On 02.09.25 10:13, Wei Yang wrote:
>> On Tue, Sep 02, 2025 at 09:49:48AM +0200, David Hildenbrand wrote:
>> > > > +	/*
>> > > > +	 * To challenge spitting code, we will mremap page[x] of the
>> > > > +	 * thp[x] into a smaller area, and trigger the split from that
>> > > > +	 * smaller area. This will end up replacing the PMD mappings in
>> > > > +	 * the thp_area by PTE mappings first, leaving the THPs unsplit.
>> > > > +	 */
>> 
>> This confuse me a little. How about move "and trigger the split from that
>> smaller area" to the end? So that I know mremap convert to pte-mapping and
>> leave thp unsplit. Then we do the split.
>> 
>
>After spleeping over it, what about the following?
>
>+       /*
>+        * To challenge spitting code, we will mremap a single page of each
>+        * THP (page[i] of thp[i]) in the thp_area into page_area. This will
>+        * replace the PMD mappings in the thp_area by PTE mappings first,
>+        * but leaving the THP unsplit, to then create a page-sized hole in
>+        * the thp_area.
>+        * We will then manually trigger splitting of all THPs through the
>+        * single mremap'ed pages of each THP in the page_area.
>+        */
>

Much better, thanks :-)


-- 
Wei Yang
Help you, Help me

