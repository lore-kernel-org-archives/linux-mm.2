Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8001D3E77D
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 21:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB90A6B0006; Wed, 10 Dec 2025 16:36:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69E06B0007; Wed, 10 Dec 2025 16:36:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9803E6B0008; Wed, 10 Dec 2025 16:36:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8848A6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:36:56 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A85C14066A
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 21:36:55 +0000 (UTC)
X-FDA: 84204871590.04.031EE62
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8129BC0007
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 21:36:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sFMzM11v;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765402613; a=rsa-sha256;
	cv=none;
	b=yU83vcPmA3y+PiTMwpjZgTDPRu6TldfstdwH1W0HD3HHvSFn9K9Fb9Etn1yRwuVZJYoxy9
	O+3QGjj42fcMLZSfKPhVPAC44D/pXsRD6SbE7YPB26rOamZVjrOKRDfzXtZ0l43/+NqfTk
	FGELFKuoDZpx3AO5ja+yJTSwqEsnDCw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765402613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xlOZX50xQnNhB5PiCw1+XOn2uJxjLtZ+AKBHh/CL+V8=;
	b=Rb0YwCfm2MG2tY+oygRdE00nqkW50nHC7R59jFhcMd3vyGmACLzpOKtlcQ6ro1FOjjClOO
	h/eZndkMChRnDmbq+tpfVkinMZ4JpVV8gJo/CBJ6M/3KODKibE6QdBhczUrrBs5C5wWFfG
	lWaTYNpSId4eTlGL5FZpNopwwSV0C68=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sFMzM11v;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xlOZX50xQnNhB5PiCw1+XOn2uJxjLtZ+AKBHh/CL+V8=; b=sFMzM11vJrI4ZVJ1l5sjMWw1Tm
	+0404zmyBebadt6fVmJfywgZuccDmE0IzMrk9r0iKPC30jFHWaSdPHD9NH3mlAF/bHn6AMoYUhLkv
	i7pvm0VnlkKW1EYAqpzAIekZdx8kwIitn75Tt9A0qgPIP1B0X8NGBuVrYqbyp6D+7GS4i5//dTy1g
	h/6N3oy/iXfZM7/NOXF6azHxiZAX9PE/J54FIOOsGCIrlxwjr9geLbtxxhhd2KelMMZu+TxEHxJmh
	f/9g4uBQDUBw/LWWwnEiYI/p5I2gF09hVqXdT2BK8mrGYEmNxXcqu75CX/eeSn1SYvBMkRsMFLf8z
	FQBdWV/g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTRrX-0000000DN8l-1uUR;
	Wed, 10 Dec 2025 21:36:44 +0000
Date: Wed, 10 Dec 2025 21:36:43 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Deepakkumar Karn <dkarn@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Liam.Howlett@oracle.com, Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pagemap: Add alert to mapping_set_release_always() for
 mapping with no release_folio
Message-ID: <aTnn68vLGxFxO8kv@casper.infradead.org>
References: <20251210200104.262523-1-dkarn@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210200104.262523-1-dkarn@redhat.com>
X-Rspamd-Queue-Id: 8129BC0007
X-Stat-Signature: 55yk4pdwazn17youdwqnkyyzin9a3x8n
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765402612-448825
X-HE-Meta: U2FsdGVkX1/mELQJq0Pw3SnqXMFfvv1TQFJyJUjNpXTC+7avRCiKJK7nuY5ts0Q9kfd42PK9MOOoPOrxOst80kIIfDD/CUq8w5JLhAomSNunXZxAdCM7qOdt/UdEbkaYZXBgnOY8kUOuXmU+SAWFDGimalohH/UJlZQ/i/EJegZQe/1fuNmFkJjQKcNbRa0KO2v1qrU3oYjrq5PmNZgPxdthB3nLkQAcjIAfcNe287O02r+dELwQXUAXX6T7xc0HL80WzcNvrkkw58ImCvVvhOXRMqmJzgmWdU/Ldpml/iDd2xQf8ZeqKQVXDljsyVZWGIAjxNRjR8wHjo9FyL3ZraLDZVOKyawyO0X93APzQWbYxa7AtygUpDBIV75MJ9kC0MZryBlI8CQReXepgHd04y3ds0h+uqCvEAX0/KQjw71QsLlQ0mXRWsueE78Fc6jptR/So8uTrCQPovR685uirtXYZs7pAHlexO6V0zWUbHJp8869BAtTRiGuuCQGGWFtDO7UkHouhhFtPhkHuBLuIG4j/i/SkMwILJFkVWU0oWmPT2IwAVHFerVQq1xKxkJQLLGanZCrxPNV2UnFOvuk3FE94XZCPEV18/0m7GVgIUGIFFER2SDa7pWPXYiEoZghcP/rqH9WvgmVDITZmFlLqBJRn4T0zpeunWIQpFmbpUDtqzlmH4TmoxOyGDjXAaZHNK+Rb0w9Rr6PRJdXir1jSBeupAmznhIznJM1CMLifZANHx1tMSgVTrjmtW9ZI64o31yh+rZu9ua8a/0iwKTqwssr61r9nFM3qg01+T0sE4MJ+H+63uFY5kzExSUFLs48mhOuf1QrHhEDISGwblwX2wzPWz0XTep/VH+omqUJXhaLu+gQBg9A+i2msO39aPiPE+gIKV5IxgxQ9RTLKICXW00dqLl5QVYX/D4cVoErlvFUHPgoKEXTXBDqMPriehBrSaM9libMnNizEBn3Nk+
 ph4yRv/x
 7Rs4Eu47IVBrvp4QBvXok8sieYXRV6/08JOT/Bi3Z7RxB/Y1Vjla0h+VGZ8NAu38Uaj2AKDh58/04JXNIHR3GomCawWIIIABZSrXL6vLUCfyyg3mtwWOGveCbLtbN/6QyFGiqcp/XYbC6k5sXTYuiydNWnWAt0ur8TpeGBrefU1b9Z/PFel+1YGNA69DiTSzBEf5segV9lUo9a6PdoP3VkFJ7junNIz/PPKrhoP2D+gb8SP9wZa99iGYZ+aLwXwxhsruThoKMFXXwH5dBc8cD8VcdlxzsnuFnessqqXI0Murg4CI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 01:31:04AM +0530, Deepakkumar Karn wrote:
>  static inline void mapping_set_release_always(struct address_space *mapping)
>  {
> +	/* Alert while setting the flag with no release_folio callback */

The comment is superfluous.

> +	VM_WARN_ONCE(!mapping->a_ops->release_folio,
> +		     "Setting AS_RELEASE_ALWAYS with no release_folio");

But you haven't said why we need to do this.  Surely the NULL pointer
splat is enough to tell you that you did something stupid?

>  	set_bit(AS_RELEASE_ALWAYS, &mapping->flags);
>  }
>  
> -- 
> 2.52.0
> 
> 

