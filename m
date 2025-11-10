Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDEDCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 18:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C3A8E0003; Mon, 10 Nov 2025 13:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C108E0002; Mon, 10 Nov 2025 13:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B608E0003; Mon, 10 Nov 2025 13:28:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E3AFC8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:28:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72A9B139E38
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:28:06 +0000 (UTC)
X-FDA: 84095531772.12.C4EBD04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9CB4E180006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:28:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lb8b3mZ0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762799284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OxSQmP8A52Hwpooer+AjKZmQcq4QUe9xE+FyJ42O+uE=;
	b=X7y9J+4MYyOTc0Rv9mLNXd7Pz2STW3P6TZDQaTbbxrMCXhd7eBS3vJ/3nAlKcw9Z3Eq0T6
	1KRZuZYsa5/mH3H9/WR0SeLwTLPtC0FGi5Nxn2RuImcR5U6159sZsHiloCx/1Ch0zanPh8
	5zdCuI1XiRtrs2u7k4HQ55wjutDAHHk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762799284; a=rsa-sha256;
	cv=none;
	b=Q+sJMm9rwAFYdBw6+zxKwbxXlMWDBCd+/6H6tXkF145WRwk0a6hTbl+qAmT/0hefc154co
	0evtQyjztIPl5rxO5p7nJ5yIpxbBZU41bNVfuZeaUAFqc+KD9oDLRpHw4AupCHDOxql+qW
	NXCh5JsUMVo1CnqLaslgYnqkGTWv9mc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lb8b3mZ0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B09794035B;
	Mon, 10 Nov 2025 18:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C2AC113D0;
	Mon, 10 Nov 2025 18:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762799283;
	bh=9Za0s+jRH4S1Z2bulO5fzs+8YHVqt4OhMTO0L/jbjMk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Lb8b3mZ0SnK/L1P86vnjLalv72ylv0BWzsMxAb3TmQ8ePx/x48jOCMHYWPPtlb3vg
	 z9a2wH0eZprNpxtivM0IEAAgzZNLGTO0np+h+sMlv8A1g1HjBSrdFEvhv/PAEy6j0R
	 Bly+Pqn+iRKpcLGSHqimhrvciigzyyr1ZdMxl4urqDzBdAdj68w4OwfR6EZvDIUQ9e
	 iYDMgfjc+K3/5KLr+wXJLmEJb48d2Jui0NG1Z9ggQkzx+8y2YdoQg7w8MMhpQE7ocw
	 lnjkriSQ+T0ZzKDZQ2Qwc1qhvIDERKl1t43X5XzG6F+CEs2fT6xvXShAqCyqSLbghx
	 a6WfrOCzE8oSQ==
Message-ID: <669b8132-3dae-4f0d-a3e0-7c73a50205a8@kernel.org>
Date: Mon, 10 Nov 2025 19:27:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: rename walk_page_range_mm()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1762795245.git.lorenzo.stoakes@oracle.com>
 <c684d91464a438d6e31172c9450416a373f10649.1762795245.git.lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <c684d91464a438d6e31172c9450416a373f10649.1762795245.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4ufj3fxkp9gywoy1iw1wfqkdxpbctd5f
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CB4E180006
X-Rspamd-Server: rspam10
X-HE-Tag: 1762799284-155244
X-HE-Meta: U2FsdGVkX1/GLDvEvx+L0yAB7atib9mMtQOnG75G6Vz3XPNvmGV6NbbJ3iVaoOEruIoRDCyHX1TLgzaKsMsjRzc7LTfARrUqVGEgOvjaysPfXPH8+jvyXHCtsnM3qAPfWIarjqO1NQjfIW2H8/PnBn1YR5tscbP4iJaErbbJScN+g7WaB34yV0oxknymJUgLUEN8sp+Erpg+4XpJWBGw65XTLh8qwmWlUyx6jX/YZJRgc/uxxTZGlUlRxWvhTXObN7l66JuCGkmPQs2jIpCvC+6wtqQEWIrVU/IzhW7xLZciB6ugBez6S3HtpYgqbaym1tw/y7XoPE1is0NXSvz9AfDk6qy4CCl8Rc4T3b5Nu3WeHt9juGTJH4k21VrdPJKBaTgo7PN09sS6zAKVFOv5oMxXwt4rAynRl04wKOe+JVbgTUNY/6xYjVy34pLZBrYUUsgqUmfp2RrWFlKD9G4xnfk9OrojEPJ1oUc34PD2BcfE8a/+kC5NPw6NuSXfb1HTU1GGc5DyPA0a2/Fe1rGxfV6zN6TNWKMRtTtkwD3/n4dnLzINghiUjfGQoyoKBFQ4p/VpEQvjZtZntAgWyUBl7+azreTpKer68bOOmSk6dfeWbCYzHFYEPeSOQ0QM1H4B0NoC5r0dBgEFVTI3Sk5E8Es3rqXnH4lJCmoM0LA9O7iFADvsGCRjKgd80RCHd+AyG4luMCoOE24huZzEPpH6aFNd8iNFoukI8fVcqeKyvLf8ltiocmmiQCu8jKuqHBgoeQ2mGH7BSeI2+3uuX1G33MvEIytrcrnCIn/THDSWADJXHZQmoh92BgzhBDdrqz6F7o4ftNO/fFHoW+znX0a6uaYxe4yCO2fB3HiccLh4/a975tVmPVS0q8bWJ8xwnsi9ygxb2BvDXyAVNJjgSJIK7/54gXSFy+hyTeOyG4aqWkq2rcZi/W53/SJAFSa2RsyFMQT3zhMzN3EgFH5ibWi
 CzFsSjkG
 laC+GDnzSUOs/7GUB4NyngQOZwTNhgm3Nwv0674pDkMsmvwaHsFYIpBrURD+mzmZFoF8PuYvpFKGryogDzz9GrWisBzW3d+gYHAeE+/bi23wmbXIziHRvyKSid0iJsaiZ8gHBrJiU8PFry+5og1Sho6dLqsmYNKx5F6RMKIMM3RvsrnAOz/mEgSy+PU5YNrkJrp9veAlwBuTAxnuyTT0nYP2UnEypA+3gE3HZpqR6Px4fx7jMO/Bsfgu36+9w16fZ7SZbIE1q0sAbZ2+NCNz4mMO9gndgwYq+xmrF8gLogW5i7UZLGngBd+lttHCg3GVfw8SAQUd2WIZhHDYwSySrYsLPyi4mtc2+3Spc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.11.25 18:22, Lorenzo Stoakes wrote:
> Make it clear we're referencing an unsafe variant of this function
> explicitly.
> 
> This is laying the foundation for exposing more such functions and
> maintaining a consistent naming scheme.
> 
> As a part of this change, rename check_ops_valid() to check_ops_safe() for
> consistency.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

