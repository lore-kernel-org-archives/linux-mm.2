Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E236CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 01:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35AC58E0003; Thu,  6 Nov 2025 20:33:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3D68E0002; Thu,  6 Nov 2025 20:33:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D27D8E0003; Thu,  6 Nov 2025 20:33:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 093298E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:33:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 843A313A5EF
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 01:33:28 +0000 (UTC)
X-FDA: 84082088496.06.939C0C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CC0A240010
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 01:33:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HZDtFRxT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762479206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZayirRmEwjWryOGURcFd+hjW3Fe06QZIYzeYdkax2M=;
	b=3vULPpBct+Gs8mPCTbcUNoIxu6KYIu+wDlFnuLgo3mlknOSwptXZKkf6pkBLdIzb9Ipn40
	R0AEigDo6nr+22Olu4anFUJwv6oE+Dm6PA+pY+PYuDc7YNVnAAhcLRZGwl2BujbNfi7HbZ
	dUhtbP3uTQ06/wnsJcIaVc61bVUB3uc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762479206; a=rsa-sha256;
	cv=none;
	b=33BA/c3ltNtwsQXM/bHb38ajQijTRCMy7eKjfAOoluQdA7BC/IVN29OhgUpNFKlHMuDoiM
	U0fgMb0Cv/bn/1C0Gl+rqyIGIDVmHyWhhTR7DIzlDc4zv7FQTqV3DQ9M0JMs+QA2l+ltT4
	j9gH+tkRXWXv5X4Jd0KgVIfGjknIhvc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HZDtFRxT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8788F445FA;
	Fri,  7 Nov 2025 01:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2743CC116C6;
	Fri,  7 Nov 2025 01:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762479205;
	bh=PK7Z65DZGnYLDCAiL5Ph+9HVPYcOYAtAYKPp1a9+thY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HZDtFRxTxzd3xikS/f+aycu7YIXmI9UGBNqjJz6+mH/rWmM5sdTd2jsJMxzcCdzq2
	 hyDD7hww9hoFo5X224lwyesdTFd3RRyYt3gp0GGgs7Uhe+GOyUeZZj+wSkl469Kh3q
	 TSiNFhkZ6AAHXrCeg54DIWesWe6qwatLr5UXZ5XhbnUmacVzzwf79bZz9Zms3ooyP4
	 kcRrom2suZUgXqhwfDEcvFI1pUj4YyTVaUX2gMSPvI/uC0JfIDRpT/WRkIDWLW9HBm
	 82ZMVREYe5M7qwXkVriF+ggbDIg/oN1dLDh3xCTKsX1Ko0LLnuHQ4/BSTEO0jOzvab
	 LPE5mWFmXkW7g==
Date: Thu, 6 Nov 2025 17:33:20 -0800
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
Message-ID: <20251106173320.2f8e683a@kernel.org>
In-Reply-To: <20251103075108.26437-2-byungchul@sk.com>
References: <20251103075108.26437-1-byungchul@sk.com>
	<20251103075108.26437-2-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iqpchfegihxx8jpwhkuhqo5acr1q5dr1
X-Rspam-User: 
X-Rspamd-Queue-Id: CC0A240010
X-Rspamd-Server: rspam10
X-HE-Tag: 1762479206-334184
X-HE-Meta: U2FsdGVkX1+IPVQzGPoe8BRGMPtskMJZ2DkZxAoIGqG4YJ60FvphThqE0aZxOyfKA+Q+uVTJkrtDf1EK9R0OUngzDbbPcWvDB8aYztm6Ez4MWA/uJK4Uu5I1qBn3sj1nAQl2gYOOiVy8dLVTp5mi/JRnU/a1tpeujMf8UsU2wMkx6Y3PTbqS/0niAT3DsaCixB8ho2Qxs0+2O9kQy9As7IlfTsjLnXJVNjHUCPThxK3NfLeMH6EYLiVAVSMA/kLmk9f5UVq5F+Wk00qwOsZGsrK5GMoK/wJd22/0SkcnvuMp0uNAK5wgYz99tZac5WbxeYlz6Q3pqqO1cPEfpgMfI3Q2S1CMTh/tHbm9gpE5tm+V7bmuP0aH+gvQtyL9DKvb1lDeCZTsMz4UGQULzOvxjK6uiDWLgRCo9xqjyJnHh3IWuaAEDfOLtrzbTE+tXS1kYeZv7AbhPAfKG3UpINEe9BmWPcgzR5ePSINoEJJP2qoU1FL6GDJ74fb0Lz5jpDCDdU4jD61w6XRFsgMDNVFrfPb2WyMurz8t1YuVUX9CP86O29ZleNJPawu//zWiVj6IvgCtKdrnIs8bkWhCLXZpbvBG+G+9pA5TNbXHbv7waAvwlOaAfGkafkwn4dI95yPS3iVF5zTEldhZcH0XYGMmN9XM3rMDuazghZV2tsIQBXsgiZorGjIeStxdnlKGFEwIEsY79thqiykUDzWH9BmwYxYsE8sc5HACBgD73DnxA0+eDhsTw0zcyyD01UaU9t6/L4DfWMLCaMHo9MqNKbemIlh/FPeLmbgoMJOqz+jV4j3ixQ6dPqZPWcQjCSd5khf9d3jNu27n6j0ajgqaTzTYNW4ZwmqyFFYbJYe3qJhllD6C6E4dy206uIJuVlBracQGLRXKJc4YZ2U1YWiDJXxX/2JkV/XO0CqjSXLUZ9X12jAEui/Wz8XBvQhl0JmODVh27RvpewpJiMK+UGI4TpU
 D+WVce/V
 69YhHfcz0tek8o16o2HLTaoy1muGQZwObEC5z4r0uhiBuik4UKuAaMw3Yn3f1WI3zZ/R1ffFJr+Ia5pGKOwX4AosYSTPmAhIPRqHEmRmRTQ2IhecqUJHSywyMJjRLkWd2Va0tgd3KuyMt7K+1JZFQ09TsGzNkAuVhQs9Vp9AowY6C9+0vifIftLBwQJMXWqGqDz/Fm9vTaZzy9xJZNEGvWxLUUhwdY5XhN43koSztWd+RZJ4SiC6DJVG5NXzojwZDEMit0mc6SE1MTb2iUxQjeCVk5351N+pzTewhwttkHBTxMZYfnQXhBKxOcJGbBWctONgkVJ73DXL3um84J1X4D96Vcownu6aSS898nqP/dkvwJzk9XzW7N2YgUrV3aZNeDU9U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  3 Nov 2025 16:51:07 +0900 Byungchul Park wrote:
> However, for net_iov not
> page-backed, the identification cannot be based on the page_type.
> Instead, nmdesc->pp can be used to see if it belongs to a page pool, by
> making sure nmdesc->pp is NULL otherwise.

Please explain why. Isn't the type just a value in a field?
Which net_iov could also set accordingly.. ?

