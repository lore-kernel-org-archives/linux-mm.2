Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9189BCCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 01:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8CE98E000A; Fri,  7 Nov 2025 20:41:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64A48E0006; Fri,  7 Nov 2025 20:41:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA16C8E000A; Fri,  7 Nov 2025 20:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1AEF8E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 20:41:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 44C864BD59
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 01:41:35 +0000 (UTC)
X-FDA: 84085737750.01.AA4257A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9412D20003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 01:41:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I4EA2HN1;
	spf=pass (imf03.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762566093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ro2o7XE+LFxsLLXdok+j9SfjbER9VSibdt/INzc4iU=;
	b=lgWhracI54gXXWKdWU0kN9fK36ynFvSlCS0YTE0NK+7+E0L/1ONBNYJS01pH7wq3pNo9KA
	XUjoBRyPbhNq+539fUXN3Mi5y3ehQCRivkuv09c8ASoYcE2yQXs9Vk+hsB3rEdYejkAQj/
	Nbn651SLqKcQPTYK45g902hon5crTrk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I4EA2HN1;
	spf=pass (imf03.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762566093; a=rsa-sha256;
	cv=none;
	b=Y1sqSUqQrq9BfUtgpi2jD1AyKVLjgRm+gZHa439+sREFE3UOpR/NrFJ1lKtMX8R3gjx1Bq
	d3TIlxPkV22Ns/pyZx8bOfJAfFgOCmt05UQ9iWj7DsjRQGBwTOfpYTHbh23EHIC8xPlprR
	D9XmxAUOuqNT8CmRjOigMXBo8zbQ/B8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4456443B16;
	Sat,  8 Nov 2025 01:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EEBC113D0;
	Sat,  8 Nov 2025 01:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762566092;
	bh=bZZGPo2E0msSloBOkeFeACpuzgCC3k9FCP1TtsatxaI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=I4EA2HN1xggEwDDY+EXXjeuTilUUVALnglQLg5zXBbhd1yvhPoCdwFWeQubJDPAfD
	 y3NuOuh15eivOqBrC5NW9R/erOX2PrG5kdAphHgZAJKLP+tlz7mdlRksYtvMzMJu2X
	 MgvuHswuuxhuknZuovUsvwbX1K0ZS1iaIdOTGnknf0YLeig+4uroSN5muMwksb5JF2
	 A2f094CKNKnI0a1QHYkgu0hGk7MzhAhRLaFd/TYCSkMsvVcUy7kFVeqROi1LFqezJl
	 M+ZgXQoAm7PEINoyJGzndzB3iHFArwOaWzWRQE/94FXzdWhJ3zwanQ1y/k1CeEVzeu
	 Cc9MjX6Hk5dww==
Date: Fri, 7 Nov 2025 17:41:29 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com,
 dtatulea@nvidia.com
Subject: Re: [RFC mm v5 1/2] page_pool: check nmdesc->pp to see its usage as
 page pool for net_iov not page-backed
Message-ID: <20251107174129.62a3f39c@kernel.org>
In-Reply-To: <20251107044708.GA54407@system.software.com>
References: <20251103075108.26437-1-byungchul@sk.com>
	<20251103075108.26437-2-byungchul@sk.com>
	<20251106173320.2f8e683a@kernel.org>
	<20251107015902.GA3021@system.software.com>
	<20251106180810.6b06f71a@kernel.org>
	<20251107044708.GA54407@system.software.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9412D20003
X-Stat-Signature: hhoczihhnukrsac4y8a7w79szsgfk715
X-Rspam-User: 
X-HE-Tag: 1762566093-888376
X-HE-Meta: U2FsdGVkX1+DUe6GAOFVxizY+jfscNzehsT9xBM5mv1PL1JXfV9k15SYx1aQCezUc2WepIePs9DoBWA0GClzXlMjf8f9MQyncGKwy7M0QafeSrLevWXoFYkGCngBRavBsnyZ3ga5e3K6e5lfU/3GhZK8Ad5V51EoVaQAnUUn6igVVbItj5yFR1ufvVwp/4ohvr/PkDfWG63UfwaRrnKj1HhFbWghxgBf8iuW+f0PN2XqXbECuNtMN7In4ZNqu1qo0LSXkvv0vq1NgdjPU/h4nP8+spCN2hG8P+tXcFbaqc2y8Xf3Fm3NwDeGTVhiqkF1dLi3oz1AQwhwQew3YmeO7cg20sWw63gZqYWsjcAcjSKKMqVAGppGhzyfACF3ciD5GwmWEc2xczI0ciLyjoRO9CEpP9e+c75XHYGzApzntYWfSCsivBC1gbx0csE+b84f0rcv6lvKRy9Dbbs8/zIb67Kot0ld+InkfBkaWDNKzBrlCAJOs6ROGdI0fx+HK/R47GXrQX7bv0dVR969U97h5kbbtMKUAzkReizo1+ftTW5ffMvxkOxNMWJuwh1TjfnLu1OAUoCpqo/dOjGTFhTEWna12HXLCPTwX8nZF/UtDO5MQGqAmOxUEXYJapznWDe2Kn1zsnf/pbJf9OT9sNKwhdeemjT5gW7E57SDxDSkk+RFg53b2BycYLDZuXY6XEGmFpBAh8UaIKILw++P6qNTUttbpfHHJIZIrsFY4ZM1Xg3Jpr8pVhKPHLkKUdgBzrcPuoDMqAXxolEuQUIgZJt2EUFG4ozVnCD2sG/8ofyOVfpYyA6fHumWQ9h54W24L2K1hi7f5hLJRDwxnWiW+anQSRySLQpmtVQoI7EKtzkFUzq6xHJlb6gPPqA0jV43jz8hu4PKMWKBkXab9uqll9xgCXZuhj5ZXY2t5mHiOZ77M0PZuJqTTc9uukaMzCCJ1nff9g9X0gXkGatemNoDpzY
 yUxdgQw+
 c08I7UGbGf4agSyWJT5kHXZPWX+OAjqklD3aWXb3jNV/QZ+/Soth6zRUBpazFVlBdJ0e2D9jumSueBv8WUR/d9PEVYWX9kkAxqPoQ3yP55ZCE64/0s7sa0H9yCx2sCGGlJDLjs7He10cK6+IV4vHU/sAF+NE3s9woJXsdj/MteqAhLzAkCAmG69eLNeV9SntP801cXDM4eebmh7qJU+w5vW/037mQr6Hv0pnQzRbfpKoGyndUjDlEnSSKRD03ki4J2VnB6Sa/S/tyJKq6M4LfIJG5dvwxIjDBjz6Ec4savxJOnCwbvUCsKxHiy/cnUVKcqzxTBUmSB8yXubDCnH+1tt8wKhOMbythsHTLdUW4S0PJ5gQoDedq9SkAaNAGGNLPbmhn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 7 Nov 2025 13:47:08 +0900 Byungchul Park wrote:
> The offset of page_type in struct page cannot be used in struct net_iov
> for the same purpose, since the offset in struct net_iov is for storing
> (struct net_iov_area *)owner.

owner does not have to be at a fixed offset. Can we not move owner 
to _pp_mapping_pad ? Or reorder it with type, enum net_iov_type 
only has 2 values we can smoosh it with page_type easily.

> Yeah, you can tell 'why don't we add the field, page_type, to struct
> net_iov (or struct netmem_desc)' so as to be like:
> 
>   struct net_iov {
> 	union {
> 		struct netmem_desc desc;
> 		struct
> 		{
> 			unsigned long _flags;
> 			unsigned long pp_magic;
> 			struct page_pool *pp;
> 			unsigned long _pp_mapping_pad;
> 			unsigned long dma_addr;
> 			atomic_long_t pp_ref_count;
> +			unsigned int page_type; // add this field newly
> 		};
> 	};
> 	struct net_iov_area *owner; // the same offet of page_type
> 	enum net_iov_type type;
>   };
> 
> I think we can make it anyway but it makes less sense to add page_type
> to struct net_iov, only for PGTY_netpp.
> 
> It'd be better to use netmem_desc->pp for that purpose, IMO.

