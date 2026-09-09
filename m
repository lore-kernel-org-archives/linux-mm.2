Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DAB7C79FBB
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 655E76B0096; Wed,  9 Sep 2026 10:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61F386B0098; Wed,  9 Sep 2026 10:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CEA46B0099; Wed,  9 Sep 2026 10:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25F666B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:27:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71C0F401E0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:27:41 +0000 (UTC)
X-FDA: 85194452322.24.E526E04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id AB5C914000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:27:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n6q/LoUS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788964059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fyzwBci/JI68L7GwljQF21lnUjBdIooTvCklPk/4zM=;
	b=gzh/1Gju3jzRvdpKr2s/J9FYhYIsn5VrCX5kGNwwAVqDFHrhGhZxC6+6kVjJJo26MjXq+q
	2Akx4rKG+HjC/HinRs1S3Y+WXLjAEmvgAra03EakpuyfMZ/SKIQ/KKbRcg4WxpxQQ2bU/M
	fDdDbVMHxq2oUkaGPlrYqV9Ki8awPi8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788964059;
	b=r23mZCH9zSnwBll/ptGQr5hVcLaZZUws8jOaTEoNPlEzbNTxkKdq/EAXk+Sqgf0cFSgscP
	Sd79mRnsDKdXsu0ztW5K+qaP8CsqyC7CZlwoPKLv8ATUUqSh9L5/w5BzmjfVRb3T+emO+w
	K9Aq4qtZ2dgHycsly2ih34TTJZbEGKQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n6q/LoUS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C2876020A;
	Wed,  9 Sep 2026 14:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE051F00A3A;
	Wed,  9 Sep 2026 14:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788964058;
	bh=3fyzwBci/JI68L7GwljQF21lnUjBdIooTvCklPk/4zM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n6q/LoUS3HGC8qKWePM8SnXWE0lNaHny4wIGqHSjRoyNo0zUqlsiOuyWi2K9bEt1t
	 oG8G4YvYN+SmaNv6lebTPFdeADBRq30olOOE5SMDG9x7RoHZuvpjDkM92fX/qOHFCo
	 wZrrM8xsnKc957fBPsH3qd492I9+/MUfrm7e7o0wkSF3veqh2D3BBzNrYgdxx7Rhru
	 DM5XqE/t+kWc9+vFnMPdLZgPR9SOCvb7UAdEwRYBBOZqzuFwubxWFQoK7oSL3nfZss
	 9FCL5PAVYeWd96n3cuX8xbXyrmRlsgP5Ix+XzxCjGW2sgeR5llV4n0JYK/gkvIE1ks
	 j+2Ca2K0ybKgg==
Message-ID: <54a48bae-aa0e-4833-91a2-5b5908356255@kernel.org>
Date: Wed, 9 Sep 2026 16:27:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/14] treewide: adjust comments on PagePrivate and
 PG_private
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Richard Weinberger <richard@nod.at>, Zhihao Cheng <chengzhihao1@huawei.com>,
 ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-mtd@lists.infradead.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-13-6ae22f9d9272@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-remove-pg_private-v3-13-6ae22f9d9272@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AB5C914000A
X-Stat-Signature: thw3yfj9byex8pox9n9y9p4jrnnzi8qz
X-HE-Tag: 1788964059-412468
X-HE-Meta: U2FsdGVkX18ZQZCX3y/uXC+pZ6UcXHlNMsVeFPG0BNhPr7byfSgVVZ4pCT8ux4BnmLIK2hbYzf9yWIF3tYAMxCn+nPgTnfmal/9BGEUYKkECpYPT3V4aWQQ4NoZIF0LlUByIiUQXNQSWC3XNmtXoNmp9yGdShB25ujMjSYSmumpieZZ+8y+JCqQDaceBsSGlo3kYiW7DkRls53MaDOFS0x55mSRh+AqF18rQWV0nluRJTIiKKI/olGRn8WBx5lIeqybbvKwhcKxer0/Mug+d7jCMfE9NFm3rz3JXzMm1zoARc/QyCmZVMCl4S5oscUuDhhCuSa0c7Ds38+5Cw6YDZRE29k6deD5Xqdomfe/jNl8tPXfjMBcJgrdW8mikQy6fYTjn1AFUZs9Q2kn70fM9gJuQIraj3L8ce+2JM/v+Io1gdrprp8VUM0dI07u1cTS8A4pLTBRPfansSWdn4EgtIKkH01EIjV9sgL3B2HtJsweiL7RU89doAmEBM5lFDNqj2nRifF2AqUXmyfSwo72oA7fcF/lZwgikdomLKKxK3nvlrc0xPMbKD4oS7mh6pyk0FBP+eMm4YLcIKIrYeDu2ybm7b/L/wZgi94I5b5jk6mZlquVsVz4vMBij0eG6tBQ7TSXbgWkTUgc0IRNo914miUB63d1TrwW0zr6yTRJ7sFHKH+SI17XsI6OpFPfqS4cbPJFkLR/5Xo4OBeVx9OmLLhRCGP7days3q1ZbHCED0gVQihTOwUvyczzb4cxBh3gIyb0P/6hYMTtAvMJg6oiYme/5E2RUo/wzKIen46rVXDVlzbfhkS3csUIjNGPrZvdE8KVp2neVtcSQXX00bPdP/Sqldje9F5frdRzHLGksXlKCO0FrmhN5Yshomx8m+JyK97dOhTMGMg/GqZkpLyr37dte2eUpi3iycvNP7H3DZDHPxzbbaI9WRwbkazOFATJcx/UL+05s9ezsuSohsI7
 L1P/xWe9
 8ar1N8BZwkjCjAOV3hf0bF+JnZ/PK01a96OJ6uO8XIJnlMxvKOSxPfN+r0UpTut97zQNiBhFe7/lSiT1i0R4u6O/6sDU3vPO2YyoEN3Ggan34hcO/50MZbGqbQgxqwnvh7LGXOUTDLo4gvNlFLMr3Bzv2ga2dV5Re5+fqgIPttNY/kartQ87qbkckFJmKth9ORTZ67wszW2X++FFW2TqNZ3MXSgozHb8Q8OFEgXc7LvhDt1M4fhyilnf1AiS9IwrNZNN67udOat5JU7AnFAlhu/ub6yh8wYO6qsaVqyFt8gyYehwCY4u9L7Pa8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 04:56, Zi Yan wrote:
> PG_private is going to be deleted. Adjust related comments to refer to
> page/folio->private instead.

Thinking again, I think this is misleading.

PG_private is defectively already unused for all of these cases, no? In that
case it's rather a documentation fix. (could some of that go into patches that
convert away from PagePrivate, like in the previous patch?)

-- 
Cheers,

David

