Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9806ACA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 03:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE06D6B0006; Tue,  2 Sep 2025 23:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8266B0007; Tue,  2 Sep 2025 23:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4ED6B0008; Tue,  2 Sep 2025 23:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0B576B0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:40:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4FF0EB9A3A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:40:36 +0000 (UTC)
X-FDA: 83846536872.21.32281C9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 899D140002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:40:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KtGZM1kk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756870833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xS4AE9kCT2ByAtc0cNk8ehmD8+ovn4l5cjIeWujc7Gw=;
	b=SbcT9gt3YVvIoK6Yvh/GtJLw2v7cZxoPi2E2UC0unL/xiPuxQo8Ba5wZWWZtIyH00awByS
	c2FKWfqFFoAiGAaaTzeK5WGa1c0Vlqzl5XacyJx+DHtjGgACgsg7kwK5oVcg9Z4OtVLoXN
	wW96aq7PNMngADyx7hph5QkrKgT4x3Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KtGZM1kk;
	dmarc=none;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756870833; a=rsa-sha256;
	cv=none;
	b=6gUbUlz22fgzSIThW1Re0X6UGhmdM8iD0LkskzZPk0jRV0I9/NY17DvIt4NtxjYcV21+9o
	tEcJtFTkcnn392QJTbH+kMmPDC9rUoZ+JV57/6Nfw4prn3q45Ad6vaUyD8Myfv8KsRDbYL
	wKPBwfmPdDHO/LW+wJxYVJy05X/2TDQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xS4AE9kCT2ByAtc0cNk8ehmD8+ovn4l5cjIeWujc7Gw=; b=KtGZM1kkX55R0FgrR4kaOTAzRl
	bJaTOVMEshIttRJDIvRajsiDF8KhksF9ZLCQFY7X+dEQ1m5r+16j9o1dIKd3EMZkUGdr/H+D84RkS
	/gD8lY0x86l5ndk81qnA66OTKJo3a0QAuW1szZApVitCkpOqP8CPDXeGNbophgK4UZ3RjH1680s5p
	KkozDrnr5YzNCx4LhwOeFWFvxytelYkBdSn/IWsfaby2ZlanltvZ5H2KvJGDWQh6gvutMWmLAlVh/
	1dMgEBFM4rViBQh6E+fp2XG8z2F+4ux9SYn+73bg2eE0u2ntViYMC7XEn9DeCdrHNOOFGlyIS/PSj
	qXCohDtg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uteMJ-0000000Eh4P-1FE8;
	Wed, 03 Sep 2025 03:40:31 +0000
Date: Wed, 3 Sep 2025 04:40:31 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, llvm@lists.linux.dev
Subject: Re: clang-22 -Walloc-size in mm/kfence/kfence_test.c in 6.6 and 6.1
Message-ID: <aLe4rwzXhnypHSSm@casper.infradead.org>
References: <20250903000752.GA2403288@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903000752.GA2403288@ax162>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 899D140002
X-Stat-Signature: 43cxe8bch81mgjabxi1hnoaubghwc55b
X-Rspam-User: 
X-HE-Tag: 1756870833-510942
X-HE-Meta: U2FsdGVkX19kmOh5oLUzh+d5zIn1w6gcKglNxf1oEh7kGUgMiATB0Ph0BpDQIhXwM//ZT8MlIANACM/qHeLyyzyRJVqIYQ0gxO4cNf8gN6fCqrzK5sOE068wBK9OaHDjr92NR/PUZX/TbVJC+4+Tt/XvKVbFSxQjnrLeFnu1Dgdubcmrp/6K6/SCFrARyQO2w9QSqZ9j9Kvm4pdVinWNvM9zSIR48pkYQfRcRFSMJAxmeZGu/RunH9uN91iVfG992mDtIh6WPEyqbpJjuyC4FB7l8JvkcVsvxQyBy6qNaZ52tAMMoZvt+QzWKrooU7FvOatLf2zbIJJz75lZd2iFuBX5Kxv8kQrB58jbmhOewtvGbezpfUOPkNsC2mB2N6nfHeAacmLdB2MeiOhg7jOuMbYKU7hFSJwa/J+uMgJqFOSChkWAddG0eeE56n+RDqqXZ+PEWobw5bbnQfTimUCGIqET33nLItbgoRo0pTLHq6cfd5lafkUkufHB1KKp58eUAYjlSt8f15Fu1WBrc8GqcbLfVjC8kW0xW9JcYOyztdOcFomOK+UbZvyiTrG29DppArg4q0OmzUXLO4vWZm6B+sQzyQByAofi02yDZ8i0s1T6Svy2RkvtemD3b8brAKv7LV5Hu7pgEW98pZakyHSpSX4n82uK7ASdUMUpTAy0HS/g968EIWWwe83FPUCOAunxa6kPykp1N9HJ0l28HJgE3Qvn3jYmQzgtQeQ2qaCMjhMITY8N/LBllBM2BLym772GXQzbMuWn31CJ80K/YzXNfGijig/TIVtb1jKSyZUriOj3h6eztLBXoA7lzragQxgbM20OeTre4cLQi3zxtkN0LADXqr4Oqcjb5AYbgi828ZQBaIwzNjZNoVmu+pjIubGxfB8UR4DO4Xu6WcF+/BTX5ieqxjbOYi2SNOSuktRiRRLUkDQWSlDPk5c2qoKwYfFAuvWFfTYUqyCrvvsJVaz
 LqQCUSm1
 Wp6XYOPME1wAn6nTeJUL3W/uVqJf9OHGBd/hM6fo90r12lZxMUGrBqLvT8lD2XpJEmWDoA4TAbro/qtFFXtunX1uhXoo3KNZt+j881+aS5ZkSoFt29w8qT8n0bsILS6ONtBADZf1aQw31zLYxv8Soc0zshA3kPMGLeUBgU1aTICZ2sS9t0sp4+bNsu4ARwYvTqkKpqbtjnKihweRsQ43UdRjtTS89OsAs3Kzm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 05:07:52PM -0700, Nathan Chancellor wrote:
> Hi kfence folks,
> 
> After [1] in clang, I am seeing an instance of this pop up in
> mm/kfence/kfence_test.c on linux-6.6.y and linux-6.1.y:
> 
>   mm/kfence/kfence_test.c:723:8: error: allocation of insufficient size '0' for type 'char' with size '1' [-Werror,-Walloc-size]
>     723 |         buf = krealloc(buf, 0, GFP_KERNEL); /* Free. */
>         |               ^
> 
> I do not see this in linux-6.12.y or newer but I wonder if that is just
> because the memory allocation profiling adds some indirection that makes
> it harder for clang to perform this analysis?
> 
> Should this warning just be silenced for this translation unit or is
> there some other fix that could be done here?

I mean, it's defined behaviour:

        if (unlikely(!new_size)) {
                kfree(p);
                return ZERO_SIZE_PTR;
        }

so we have to have a test which checks that it works.

