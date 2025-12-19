Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A12EE66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 18:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE196B0088; Fri, 19 Dec 2025 13:18:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84E96B0089; Fri, 19 Dec 2025 13:18:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7A4E6B008A; Fri, 19 Dec 2025 13:18:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A49776B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:18:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43CB7140372
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:18:47 +0000 (UTC)
X-FDA: 84237031494.24.4A9BB10
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id EABC4180002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:18:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=U17pHvF3;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766168325; a=rsa-sha256;
	cv=none;
	b=DSFeMt5NM/S0TA4lxm4nE6FImx3NZJsu49phlgbu4AqhgZtKvlW/2N6qfrTDFSSp2iCaol
	GYvRMpXnoOo8vaNqBqIdRKhgQkBovBMnxz2DEXD9vSY7J+IweGRkJ6jXUo7zh4FyIFDr4J
	krf/ZCg8KLKJ0urEFuOwL6AFPpH5jF0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=U17pHvF3;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766168325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4gt0/vKfnYmYBnHrbbkqhkPm5dR97qK0YpD9UaChCw=;
	b=Wy66imOU3ELDnqyI8Eavji1ML3Al+FCcrIHnT25dzX9IDKKxi8Ic/ZUFNDL2W78pHzXcmx
	RE4n2Fs36UqYKhBFSbkCfiXKXkGq20jS9u6gyLav4eUwyqR+jHkcackyQdBrp/zO/SztAm
	8YkyNlyg5zbpjBSRd3NLwHUuLDszce4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y4gt0/vKfnYmYBnHrbbkqhkPm5dR97qK0YpD9UaChCw=; b=U17pHvF393kTtYtWU0SYCDXYtx
	CgCzp4g2y9oP6AeHn1cLDGd2jBBTf7LHfIY+iOoewouYenAEkkZcA+fz8lchh+CYyiRCdYivQheoG
	8H8AGyaxiNxDtIvPwuSXbL4KiQ9sKDwZMuYKGwPnwVI2/oLgtKr9fNxTJj+phG+IzV8qky1Sae27t
	D89em6BGeFqB+VdsyC3mW4Nf11Y9EU2GY0X07V8YyfD/A0EP0oql8SQ4HMSw8nWMfTyUCQnNMPJBu
	G5l7JfdpR0LwyMTkolUhmISt23E2sUnNfsd4Mdtt26Y3xbnGURuKciTatiTwM9nh6ETQ7GOOTr23s
	Ijr+4z3g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWf3o-00000007w0R-2ao1;
	Fri, 19 Dec 2025 18:18:40 +0000
Date: Fri, 19 Dec 2025 18:18:40 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org, muchun.song@linux.dev, osalvador@suse.de,
	david@kernel.org, linmiaohe@huawei.com, jiaqiyan@google.com,
	william.roche@oracle.com, rientjes@google.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com
Subject: Re: [PATCH v2] mm/memory-failure: teach kill_accessing_process to
 accept hugetlb tail page pfn
Message-ID: <aUWXAGC1028jRKEY@casper.infradead.org>
References: <20251219175516.2656093-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219175516.2656093-1-jane.chu@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EABC4180002
X-Stat-Signature: c75k4ps9tdwb1r9rbotqwwsjc31p1grr
X-HE-Tag: 1766168324-766181
X-HE-Meta: U2FsdGVkX18cRdarBCRq/6jZQvgeHQN8NGadMmq+siz5vtSNQCgQO7rO/qCIoL608u1lq4VQEHyaDlDzecmzundcdrMWfRRqqAb3eLWOy07BM3zdYq6H7qzDivE7Z6lrPc/f+l2T5kxO0YSOptsfZcBC4Wo8TbTOvqcvn6fkneI5K0o/TIkxmjPrzftm3mYD/4KNw8Kva8/gtwbQIF/dlAQrfkTlku+p2g6Rel2UD6AbrKopXC/VJsAicrAzyMWzgF99WTQ0938UOVFtnzXJEU7aMd9V2y7dPqU6PBpJOcCWayB7sMihU9XAT4D1VUCqW6TOOxqiNOlJz4bTtfY9q3mCNAoOeVeNVLdin1rT6eMjFhM3FRGywYUhUs7yK0n6f46DZuQJsQ1bFlCHzXNfTtIebPXB5bO6V7NUvv708jlGBj5zLsYagmn9ps94WoLxx/kMlz2elNpY5TDtLxKlV9MrM2/KA2z5FaLo/93PRap/7vG+3nZxHljl633wljTdmud/VhtwEKxV4GBVbSPVaFEu7/nHoWa97dZoqzCq1Tm0XhPpwFU6LAteXXTfDkL51FQX+GleQ/SEoNAktABHhaR291tZPOoFdyS13V2z1CDrEoFtJELdxEj52UkLIwHra4bfxWDEVe256yc7O4yje5wPKcUiecg8L7hP6MPhjliHLi3pxmpGjWalG3mzJhP5A+tn+y9Q9IaSl3SOXlz9pB/gFjOrhRZD9kcfdYcdQ8tsPtB32VMinH8bEE/uObCbgEUiItCgZZ2Pca3tKKALJ3zuTQ80mJ7yCKsjN5bBdNh+5DqKSlRiVO60qbmACs49bhA7ILZEA2tFXBrxMBs0yvUAxR36fn9YmFLb/h/DBZb8j7Ths/DQd19CcwO631l/6mtspgrDE56hVfAFF3D2sjD1AM+nNSTbrw5OKf0cetQdQEX8uiuaZvwCo8Kd2kIH1i/l+xfKwKqX9d6HwaO
 NykW7Cu1
 QeoU+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:55:16AM -0700, Jane Chu wrote:
>  static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
> -				unsigned long poisoned_pfn, struct to_kill *tk)
> +				unsigned long poisoned_pfn, struct to_kill *tk,
> +				int pte_nr)

if we pass in huge_page_mask() instead ...

>  {
>  	unsigned long pfn = 0;
> +	unsigned long hwpoison_vaddr;
>  
>  	if (pte_present(pte)) {
>  		pfn = pte_pfn(pte);
> @@ -694,10 +696,11 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
>  			pfn = swp_offset_pfn(swp);
>  	}
>  
> -	if (!pfn || pfn != poisoned_pfn)
> +	if (!pfn || (pfn > poisoned_pfn || (pfn + pte_nr - 1) < poisoned_pfn))

... then we can simplify this to:

	if (!pfn || ((pfn | mask) != (poisoned_pfn | mask))

>  		return 0;
> @@ -2037,6 +2038,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>  		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>  	}
>  
> +
>  	folio = page_folio(p);
>  	folio_lock(folio);

unnecessary whitespace change

