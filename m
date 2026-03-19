Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF29109192F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDCB6B04C2; Thu, 19 Mar 2026 19:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5C16B04C5; Thu, 19 Mar 2026 19:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0D906B04C6; Thu, 19 Mar 2026 19:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E257F6B04C2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:31:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9577A8C3C7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:36 +0000 (UTC)
X-FDA: 84564411792.26.06E5CF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D36D2160004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CVuqtNjF;
	spf=pass (imf08.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773963094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ximLUdMQySj4x5kyPTIFcDqELbetNp3kYtCJ8SizAEE=;
	b=PdmmnwZHH0LfCs0OXxiaH2JDPyDvqFNd84mHtp41j3f7df7q3FyuxBss9z11xnPF1MtnRf
	91z+HO6GzbHBNR95P7tfKYOI4g3JUl84DVWW//dYaaU9+2vKeUE4O1hakDzDcWEO1C/Jxy
	Wp5PAWfYZo8ErW6UWj2FFipmSwgoIv4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773963094; a=rsa-sha256;
	cv=none;
	b=oeKL8pr54Ifl5L4lv1tewSiZsAUAOboaB0wSb/M9fEwEiGPqWsXnNB5flyVR1FmQ5G/M1A
	7SQBSWAIQ0uRkzotgueu3WgrpghjRCwaJQMcn4E9ROmsFnA9uWuhf9i0l2CchZpuXMGW4u
	o0qJVh/W2htPY4bNQXTNBzHswxC9xiE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CVuqtNjF;
	spf=pass (imf08.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EC03C43ACB;
	Thu, 19 Mar 2026 23:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8E3C19424;
	Thu, 19 Mar 2026 23:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773963093;
	bh=2ceLYHitrpgWnbijBLEURAHrA3SxUbD0jlo2sSsj2kA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CVuqtNjFaPpOozcHQ0mF58SrW1xcRvHJ1UN1gqC0BYNd+HIegbIO7XleLF+7YguxL
	 9TDKoFqvqyOP4tDys+vTYocI/ji8rRjvUQf/Cl2rQw/e1piNSzXBezeMi8yoNlAb3o
	 xVhaaSxLG2VFUXOPfuJ1SY+vrHcBj/MVU7riKCdMk3Viu1LX1lcinFUIUBdcy84xfM
	 fCXd4jRrWkMJiQnxmrYGHv99ZG2qdINt+MCASHRn10VCCClzQh24dmch7hNXeUTLa6
	 leIj0kVLiUYnU6wCckdIaclYQAnLJUvuV7IaE2aqyhXp9SdWSTcDrSGWW/herYMFD2
	 Iq4hekz6OvrcA==
Date: Thu, 19 Mar 2026 16:31:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 willy@infradead.org, brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org, sfr@canb.auug.org.au,
 dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
Subject: Re: [PATCH v5] mm: introduce a new page type for page pool in page
 type
Message-ID: <20260319163131.2f160a5d@kernel.org>
In-Reply-To: <20260316223113.20097-1-byungchul@sk.com>
References: <20260316222901.GA59948@system.software.com>
	<20260316223113.20097-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: twfxjxuc4pyzerfzign1k6s9cnhoti75
X-Rspam-User: 
X-Rspamd-Queue-Id: D36D2160004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773963094-413153
X-HE-Meta: U2FsdGVkX18YhPSyO96XSAJWG9OFwJhEHPuOaP2DPmmzfcUS1WwJwfSRvE4E8X8Kjok8JGxs3AXvr1RWM41fiWya5Cr2dAW0mHBSLUb3XvBs7CvYTpzmSi7JuKXKYT9ee3fkwh1uHEPUIYxxcqt2T8WYDNFvdspwBy2Fjaun0lk85iC0CQaWQbCVk/6fs4jRdtoyJWKz1uF0JXjxcLNJQFGjrbrs96SwJB2W3rvZkSQmsdcRESRNQ7lsb58dY842o6U/+CoiUV7wRkn9+SsrZ+PGV15sQsHMKKEi275uBDH0j2pUSnpyf+AQjn63X4ttA4+C8XU/1t+433hLOELfNd2tlNuPLvztsPPTHr8l2Vy+3LEouckGX6xq6Wtyc8Q390gF2pjkctLzXqZLaB6+GVgsddDMYlA6jjd2aV5wUU/meyrCgks1ZPa7jXvkYEVxphViBanOZbRDPEeH7eDKpi1M0UKxjh0e46yjLat169suwegDHjM+D47fkLLDGoA7RhNiaieTWjNAAdFpM3Gzib2JWujkMZaM9EGPjD+d4KlS05M4fA8EK6QfQwajm2ITuYTTMnkw62BvdKtWziZofwbOgBHaMWA535NZC24c8cEPx9mcrRTgRKvBLNsj5D3HkrT1t7HwUA1+0IITQ9SljytPjVXtqHjEQsuRqnUFSCGfiqCFK7vYMrgh5ArDvMe+fSjldP9cEjlyFXyGWrjte2Ns177qSA+u3XwZBY5rzXJkS8fvKIMFLhRIjByBUfgYIKicdARPeP9IlPAglxOuiN0MGVEob6RnJLXFV5dprK7imF5FP2kJUJMzgHtaJLyAxY+jx8SKhAtwTvF4PjtIBRjCGHn/WhYJDg31sH3nczKj3kNN9MGcAIy4cMxWnjrAJ9umv9quKw3yslA8V+Kg1eyuQuh42IWrlKHDJUhR1OydqOfXAq7s+shoA+tJlVLq0TNvli9kEecUBlOUw81
 974HpKBO
 dnX4e4XkJlBfcENQPgMH6E0NuhDb40klbnZ+KNlrKME7vauFse5yUMjAVSfjBtDSsKwFwHz0a8HNT9F677YdZilQqMebW/mMm+kQZ2FRFQ76eSpznY07fTCx5heQ3mbNuCqJXY28OUqB6DfoBOx1GqbRDp4gSquQg/pSDIvf2sU0p0QGc3KI7MY1h80bNNvYFg4V2x+GcRNftQhOgWgnsvvERw77uOQ8Cepx5VklMwiqUWcu08A1ttmqsz8fiS5ABcZSvADFRuJif7VFV4Ck6nnteEJyKf8wsvZPjP7zud0Ic9Js2Mq8HRU6rVxJwtfh22QB5ub0BrEZ+tgkV71eFbn8jx5TvRD2B/H8/02dZu445T4aMIsw3+f9zNw5UwkvauhSR9HuVcZZOeyl5SIEBMGFK5tPrrNs8R3gD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 07:31:13 +0900 Byungchul Park wrote:
> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> determine if a page belongs to a page pool.  However, with the planned
> removal of @pp_magic, we should instead leverage the page_type in struct
> page, such as PGTY_netpp, for this purpose.
> 
> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> netmem_clear_pp_magic().
> 
> Plus, add @page_type to struct net_iov at the same offset as struct page
> so as to use the page_type APIs for struct net_iov as well.  While at it,
> reorder @type and @owner in struct net_iov to avoid a hole and
> increasing the struct size.

Acked-by: Jakub Kicinski <kuba@kernel.org>

