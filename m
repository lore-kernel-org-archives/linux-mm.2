Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D7FD65C46
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 13:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1326B0005; Wed, 17 Dec 2025 08:43:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444AB6B0089; Wed, 17 Dec 2025 08:43:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FC7F6B008A; Wed, 17 Dec 2025 08:43:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5626B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:43:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B907D135654
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:43:13 +0000 (UTC)
X-FDA: 84229079466.12.193AF07
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 53FD520004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:43:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ybi8bsTq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="nj/6g9vP";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rWXg37lE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yELPvp4G;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765978991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBjgti/w/DVH81mtuH8uFCoRWeqR8Uk0Q5nkCd9uPVk=;
	b=H/EZJvGr5nLr7jPZCeDTuQ4qAoQ4jpxiEkc1XnmjzkfqcUgM/rxirz6unEcXmwSdfEQuXL
	/lHZoIpWBD0iVHNtUg7W1t2aQeuDkluWbhy5+wJXF73fND4FnsMAigJs9BqxPCBioMWHD/
	j5tKeGPce02t9GVE+gS5tP2I7ayRYwY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765978991; a=rsa-sha256;
	cv=none;
	b=78RTBqYiMBmI+oQa7Tg5fhd7bZaizB8HK7CRuSEFnjHmvY0XUmJojSUDlPBtAsbIaSjmoT
	qz5o9qTNI7OnKYM0bWRbkLg7HlPpbT9PQzOA991LKx0IIt55BEFM24AHxnhj+DdtrgPI8A
	ml6TZ3BMTYNKF0ZbwcdI2z8A3diYkZ8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ybi8bsTq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="nj/6g9vP";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rWXg37lE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yELPvp4G;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8CB49336D4;
	Wed, 17 Dec 2025 13:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765978989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FBjgti/w/DVH81mtuH8uFCoRWeqR8Uk0Q5nkCd9uPVk=;
	b=ybi8bsTqBVfBFrRRaqXh1WLl4CoYZxMnLRfsx+I3W7xFHLx4i51Ca//p9gceFXwDv/QmKH
	sJxKt7ciGhvdljjfOQLLSaQqugqM7JF+E6xO5dogt0ubffwDjTVM++BuC3V1aH0hZdDJ7Y
	5t2e1uOSJ9eWE0SIn8e2OPcAVmQ7bJI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765978989;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FBjgti/w/DVH81mtuH8uFCoRWeqR8Uk0Q5nkCd9uPVk=;
	b=nj/6g9vPZvvfB+fVnUCMfyYE2SBKJ2V0mOkoEl2zdMkmENasve3ByMkVULJrggMHDPouEv
	Gk6mDqcwJBKzc8BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765978988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FBjgti/w/DVH81mtuH8uFCoRWeqR8Uk0Q5nkCd9uPVk=;
	b=rWXg37lErWuxpeG/GaZ6hgEWx4/vITQfddnkTCm1nEvvt+LIyGL4fb0k9AWIHLholSFelg
	2HVpVDXGu6uEYtChiSf5DvoIwsqQik1mjR7qlDj5/IwZidUFASuUSxsFouPNQh235pbr/k
	8PMWa9d8c4aDs2teCwEINr3pR0icK80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765978988;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FBjgti/w/DVH81mtuH8uFCoRWeqR8Uk0Q5nkCd9uPVk=;
	b=yELPvp4Gz/ZYabrJ3OiTJPPR6MmiaDtT6CtpAcwdliGWv79/HgYwbv0rOwn1418wLJGlFD
	QZPXYe68PoSD6lCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 31FE13EA63;
	Wed, 17 Dec 2025 13:43:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 38axCmyzQmmlYAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Dec 2025 13:43:08 +0000
Message-ID: <776b0429-d5ae-4b00-ba83-e25f6d877c0a@suse.cz>
Date: Wed, 17 Dec 2025 14:43:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/1] finalize removing the page pool members in struct
 page
Content-Language: en-US
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
References: <20251216030314.29728-1-byungchul@sk.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251216030314.29728-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x6sm7j154gkqfft6uzd6dj7strc6azma
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 53FD520004
X-Rspam-User: 
X-HE-Tag: 1765978991-89348
X-HE-Meta: U2FsdGVkX19OiSwHfzQq3Yx3YpDn3/QtS+6pZNs1qCPdsi7vKBK1htTbGnviNe4xCleuFm2WCeLcwoXEP6RA2HrNMleFDYq/cK/ZuMRVtM1ex0pwVSFv+KzZnsMTIqZeaNN7cxqi6Q9s0JfhggPS3/27Kh4odWtArtRY9zEt+KHSq7GaHt8jhdlC8ogLfB9CGlUcfwfJkxkMdfTROniNoFlkldSPd1+EEWa1EAPsNnFZY6dFcEK3hT2gdwkXiMgRN24nG9/2W6dTYX+RlV41q1i0Pm3odSh80YA+7juuEdlZkmsZJuBsVsomcUmYmHZ0ZOVEGs/spuWzgT/E0mxTHeKQ+n4ytYPQv4bZ25m/rr6vAU+xA5cXB5xnssKvStHJuovQFyeYO3Vso0Z/edn97hrQaCThyzmh9I3tBL0BoxrbzF1sgY3qjOogZsLtNFw48ySmWgjHmNsLJKqTN42mgrq3MSdqm7RU1MUaEBPftqmBolngX+KfPxzJ2ziuKCFSF3nfnDJRCvoKPh8oEHjRTnaAgCwGtI4ZJP1IAapxbuP2skNNJhj42NC3R0+2dY0FnAR4Nhlejli++8plfYNl8Boa0hsRuF34LBUntMZMO+tTxqaY9mgz4NwtjCTNVDSlTGyMNkPmAXckSP9HvCishAfd0cOes9kB3Fm2lN+AeG3T3FL1M6vSoLH81FMsaWQs5i0CNEMdz+PQRK4zS3/yQsHAMtTjK/V8L58fiVKFn+KIRnZca7RVu291pdA8nuCz6b29GvR0jfz2yIZ3UaCxKzn2Oe/rq/Piavbq4dfVvb5B5yv6csn8VGbYzxBt/J0uwAAnb8Xn0qxlPKZNPvo0V5CqGB/COjlvRg1vbTLT5+7CS9jbz+ipgOZTs6bZ8scnnmHjA15RhUkSFz5KDFixC3VzMIFWmK3xPj5HBVbADud/Zb6EY6cSdZau0miMs37RY9mioD9zpoJ3be822SE
 jRuxj2RG
 VOadhtADm6OtLX21JpUw8PMWZ7irWdMLsjyn9pufZu22kx5cydpFTm6AlQAoXui688LC12uYcx5yoD5LANXYuwl1CPnYiociyCeRdcOW+CymhWRpbS0VKiQpOZoq5UZf7Fm8UMRwY6byWLIhxUPwfyfiWlTI5iRxfqhd4AEIE/UF5qeA8b3iaXsfu3yto1Rc/BSkmhNatw+AV+ZngP/ZGEZnKq2e8jWx/6aXEOW4RfBxl/EgLWCDRNH4ProSdgn1RKYT+fqe0Y2Ejr8223pOrHlHT4qTlgZlfO5myvhrihxk8C2LatS7JAH1mCjRn8qDBnIOf/MzEEixYAFiw26xbqmsqtJEmZylAhvgHOzh3h+DGl7Zy4KNKokaHWKeOdst/7RwLewm0HSmTKe5lM2ewb/OkDruePaWEhg58Qvc+ACaINOU66yCJnRrOI+uAE0OI4Qzi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 04:03, Byungchul Park wrote:
> Since this patch requires to use newly introduced APIs in net tree, I've
> been waiting for those to be ready in mm tree.  Now that mm tree has
> been rebased so as to include the APIs, this patch can be merged to mm
> tree.
> 
> This patch has been carried out in a separate thread so far for the
> reviews [1]:
> 
>  [1] https://lore.kernel.org/all/20251119012709.35895-1-byungchul@sk.com/
> ---
> Changes from v1:
> 	1. Drop the finalizing patch removing the pp fields of struct
> 	   page since I found that there is still code accessing a pp
> 	   field via struct page.  I will retry the finalizing patch
> 	   after resolving the issue.

Could we just make that necessary change of
drivers/net/ethernet/intel/ice/ice_ethtool.c part of this series and do it
all at once? We're changing both mm and net anyway.

Also which tree will carry the series? I assume net will want to, as the
changes are mostly there?

> ---
> Byungchul Park (1):
>   mm: introduce a new page type for page pool in page type
> 
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
>  include/linux/mm.h                            | 27 +++----------------
>  include/linux/page-flags.h                    |  6 +++++
>  include/net/netmem.h                          | 15 +++++++++--
>  mm/page_alloc.c                               | 11 +++++---
>  net/core/netmem_priv.h                        | 20 +++++---------
>  net/core/page_pool.c                          | 18 +++++++++++--
>  7 files changed, 53 insertions(+), 46 deletions(-)
> 
> 
> base-commit: d0a24447990a9d8212bfb3a692d59efa74ce9f86


