Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A9A2CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 13:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96E386B008A; Fri,  1 May 2026 09:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8BE6B008C; Fri,  1 May 2026 09:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E78F6B0092; Fri,  1 May 2026 09:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A0516B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:16:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2AFE31A0E23
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:11:51 +0000 (UTC)
X-FDA: 84718888464.03.446169C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1CDFEA0008
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:11:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Mf7Gn80g;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777641109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9M+0koZGyeMrDWlcqbUSzkQEEcLB0oR5FUlNLZhoII=;
	b=ErpHhb1xQU/R3b3lp07sDzXOskAiYUziqAKxfJn+JlnSF+MkTZqs7ETJCQ4gUXSTTGZvHx
	aUDdobIlbc9ubPEmxeqLoEu+f7M5MphvhoIJ7epNkwlhxuQHg+cRRskSm57q8Mw5R1hpfQ
	cSNFYKf5fpu1hxJORzHZ/TgtA4R+JOE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Mf7Gn80g;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777641109; a=rsa-sha256;
	cv=none;
	b=sauRUWbKtvAZ+vx1w2Ihtun6HNQJ+jbV6uKcNgXI76Vqd0olH++yBeZ9MigWMeADesDwnN
	/KHSwv3bmcSw82u2TO2+QQ9PF+jej4hvNZeAC4ORiNjX170QW2413Pz3VNfVz1DwzmBbi7
	sTP/kuFggqkE2Ss4gcozb5m1oIGf44g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A3B360126;
	Fri,  1 May 2026 13:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1694CC2BCB4;
	Fri,  1 May 2026 13:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777641107;
	bh=8SKkSzZgrAa+ZpppgM8vJNeBTw3pwJOHyXuYiFX1uCg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Mf7Gn80gA7H4Gd455riWj8Pblnwt++fG7P7xV82SSfaPlYei2kIpQsWJyHxW8EgI1
	 UIsg7idtTxfLCcffyeXo4BjDylh4cwoc9qTcX3Nw8oNujrTUYiG/v6vv071gCfoMdZ
	 sFjZLS4DEz4disHye+Dd6MK4Nk4vWIQTKbFMDIv0=
Date: Fri, 1 May 2026 06:11:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederick Mayle <fmayle@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, android-mm@google.com,
 kernel-team@android.com, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/readahead: simplify page_cache_ra_unbounded loop
 counter reset
Message-Id: <20260501061146.6e61392d125cf1847d7cc181@linux-foundation.org>
In-Reply-To: <20260501011908.3630802-1-fmayle@google.com>
References: <20260501011908.3630802-1-fmayle@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1CDFEA0008
X-Stat-Signature: dxaxsdqmznkzmm6rhpqg7bemfb1bdz99
X-HE-Tag: 1777641108-721891
X-HE-Meta: U2FsdGVkX1+Ubam6Bg2b3+h4TJTBr9zFXmAoZl2doYzfhoVpBso84mquAD0j9Ow50hG+B6OscEV5dak3VBhCI/dP02GsuHF6QnjNj/7zWe3sq3b9pe/oR0jD3zXQAmRM3EJ8c8GgJKGUf6+6QfGQ8ne+R1g+aXKQqowOZUZB3R+OFfd5V6jKlO3XJOOlwU8kZRuN4+jaR9pdYh0+uoQ9mvE6FBuST2lOxEdfeHCltwGBXbQL2yF2VC2VmHqu0UQBHBqGCIn1GxaCbZvcjyJx1rDHHss+GUeQfXRU/HlEImCz2NiYvcBvIIr0beWC3de4B6Iz6LBU3WVEGYnp/ktF89QKF9crgAAUX1ZCjuhP90V/V+f37IRIcMnKRP5azBhG8HndbQ5DRCIxiQsl72kC44mKXW7S1ikkCqLlrmh9qpVIF7PiLiDiM/KDRBjAZfO76UZiOVN2p3vZRKJ2ESdxK46Nh4ja1Df/fREYs7ba6rokpYfqw7tVpPGwKgh4sUcfYoNrwKoL2C4iwT4YYRo6C2J0ceSJhLDpD96PbBM77T8jrA4HcOU5NSqVfY/sLar5QDdz9ou72J+LlzfN1oEsxkDrgT+B+/I9IL4/sMGAr8zuXl0KkddrDmJFpQb+zu8c9AQWLZIM1U3INvv+eQDzzlyV0qeMbxCcyXokyWkh/6GADtdLhGeep8bmbMdsp8+FTJrjAj7zcbex2dAFWWtrYFIIgCrWM+EJ5+q4Hnjb4PBpXEPadav0aISjdQ1KKURUJY7dA6+8RBGTn8Bsii6fRzz84Hg83vmstFEDJKmgVR1SCJli6BgrHD/sK1sHr6Dd+IEov0mps3uIK9Mc5THkRFt+DED62txyfjFzPKvo20gsOOIeN5TUPXjr+BW5RePJbAbGDguIKvjPlQ2iDBPteE4o+hc1KrXZhWgQPOEn7kcATJjnFfPWqNXD+/nOD53pwi592PtUEG/7hIj1Y2W
 vOuXa9Fq
 isshE7YcJ5WdFnomLyqEJPedacfqohDacmpzQ1v9k/erXANTPjEWYrykwXyDSCzat4GIaWEbWcWx2hMCvMe1VHPumSHgp/OYLcQMUiRDkJTbI032Wiy+h0H916dnNWrdF/rLv3fdcc7kcvI/2YSfURgs5trbPUz2lt7LEeEqv7ittUZOjen9f0whmb7Sj6yJaAJj7QTySZYePeDLMWV2e4LDWdYqBq+0s7D2SCVfx/izdS4QvMJG0ucWEknZleo+EZCFwqFmVKRYyEGPaUVX403SdeJjAkePyx/1pr5dAagFuerPE4RXlEEw4nJyf00mwYyPz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 18:19:07 -0700 Frederick Mayle <fmayle@google.com> wrote:

> Minor cleanup, no behavior change intended.
> 
> `read_pages` ensures that `ractl->_nr_pages` is zero before it returns,

So it seems, but depending upon this might be a bit fragile?

It would be better to make this a more explicit/formal part of the
read_pages() contract.  kerneldocifying read_pages() would be a
suitable way.

> so the `ractl->_nr_pages` term in these expressions contributes nothing.
> This seems to have been true since the statements were introduced in
> commit f615bd5c4725f ("mm/readahead: Handle ractl nr_pages being
> modified").
> 
> The new expression has an intuitive explanation. When filesystems
> perform readahead, they increment `ractl->_index` by the number of pages
> processed, so, after `read_pages` returns, `ractl->_index` points to the
> first page after those already processed. `index` points to the first
> page considered in the loop. So, `ractl->_index - index` is the number
> of pages processed by the loop so far.
>
> ...
>
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -270,7 +270,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
>  			 */
>  			read_pages(ractl);
>  			ractl->_index += min_nrpages;
> -			i = ractl->_index + ractl->_nr_pages - index;
> +			i = ractl->_index - index;
>  			continue;
>  		}
>  
> @@ -286,7 +286,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
>  				break;
>  			read_pages(ractl);
>  			ractl->_index += min_nrpages;
> -			i = ractl->_index + ractl->_nr_pages - index;
> +			i = ractl->_index - index;
>  			continue;
>  		}
>  		if (i == mark)
> 


