Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B833BC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B657B6B00A1; Mon, 24 Aug 2026 08:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D896B00A2; Mon, 24 Aug 2026 08:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53196B00A3; Mon, 24 Aug 2026 08:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79C2A6B00A1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:29:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E79F40110
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:29:50 +0000 (UTC)
X-FDA: 85136094540.03.68068DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 407782000F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:29:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqN0bgAv;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787574588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HIXWt6cHYsyYpDN3CnAjwEjdPOxdWvNmv8xtLz7Mp4=;
	b=Nhk0lTByVCV4Cw/fwWpKJTcI86AGgg+RYFK/LIQA3YNz3KKHETEPQFbCfx8Vx6u4ebFREX
	rG4ue8c5ZOBF7pgZHe0vBULRfkDr+rnKH4KVpppJz9FfuG2c9bVtd/EyN8e8n1Zqvoc+RO
	s92vnHuZH2HhZqRnYtGeRmhH+XAfqk0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqN0bgAv;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787574588;
	b=Qo1dWnQAyGVtLO0LBaQIFSqh6gl1MrlXt2mhblrmDxNaU0cM37PebWMeCGHY+8jTnRw+Hh
	ctUCwnpZVDDbgD7q/x0KqF3r/mbjbCavI2VvOIIDikVIbHF4hxVOYwN2nRotZ6l6bAgC8y
	AIMi2et5SeyAOD+TbsV0F19Lsq60d28=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B87C4062E;
	Mon, 24 Aug 2026 12:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3111F000E9;
	Mon, 24 Aug 2026 12:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787574587;
	bh=5HIXWt6cHYsyYpDN3CnAjwEjdPOxdWvNmv8xtLz7Mp4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jqN0bgAvWpo4FuZfnaVkmwwOy4A25MZ+xYiVkOk+9N1FXEUIWQVOhxKhZcmi0KFFp
	 hH0W6yLSkhhS19gi8Yxl9oPe+L38z8k4/HHUMNqtU7bSq+OtqCtEuWnaZ/QseMqppS
	 Qf7guI47CpnJFWQcvKPpb4Bo6xii81fnqM/7Rz1jXOPetvbGSiUUPzDkVv3KSysYB6
	 EFK75vg6x4crFw7RMvKpVk2D80DMSwo41LFL/9Fd4YmY0e0h42siXPJMBhsrRyV/fv
	 s1GTPpXEqNx3fTBngkHorvzYxI7be9lyFoMxj4zzYY08R+FDF+r92VDwL50SonhAGX
	 H90yhLEXF2pPA==
Message-ID: <e87ac26a-9712-4f6f-b144-b604b2aa643b@kernel.org>
Date: Mon, 24 Aug 2026 14:29:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] selftests/mm: make file helpers return errors
To: Mark Brown <broonie@kernel.org>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-2-sarthak.sharma@arm.com>
 <75738049-24f9-4056-98c8-b4075552ab78@kernel.org>
 <e4f8031e-20ea-46d1-914d-005595243f31@sirena.org.uk>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e4f8031e-20ea-46d1-914d-005595243f31@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j8fbdr575tqkoa1nh37r498rcon3g3hq
X-Rspamd-Queue-Id: 407782000F
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787574588-135849
X-HE-Meta: U2FsdGVkX1+9zYwKk5tJFed2sTERHbo5UiYEVrpDKIteZ7umpmn9P7ErTZVF63wrRW2BkxRFhw4R67j8O+EVQJjotVsHzfN/D5Tlk+IIMz3X4yC6ILnHgu7zVfVGfMgZd0exbM3UCbMHE2q3YHUUDdo2mDyFlRoijwMr6AhsYQwVe+k+enKE07caa0FHI6DZU/Q3s+3HgJnI9dNr2EA7L5CPVQNMCDErdXrCXo+aSIDCaK+7+9JoxQBtnr6wYl7PGT3fzXK/J2bTdfW2rRklevdLbTJ3vqT4tf830sO/SRNF8+8kQrdwG+z8jSYotRcWMUOYtnggpG+Vxwa5I8dSUEif9nISXMmLtp0/hsuluE8sMMhbmIYVMOYrnWSBbTBHrbXbJvqXNEoedMNOuZ1HWoMrYBMOtG/w512VtvQ/m6z3oeQdQlIDFwvUFvMfebrKQPwifaG+Ws802+cKhNbbldaqrv7lUZvn3z9QYmZOSSEzKTWgFBuroPPC1WftDtL2QB4GOjyw0taWCp+Mw/1buyZH3tDCPb1vXgY7YifwH7oOYPbrPbSlSIpxuffUwMyQHXs4z9vLURZKgrTzETmbk/IXQEPXTu9vM7N6f0RVRcTPbL6cK+0ukt8YPGO3JwO3BICTwR5UDv8bF0NkquyFeMmKCCSxcs41qtTqPwQSc3Ri41kyl46oZvFeW3CC2b2xzmu3bAf6ag9WFAUz2zFrT3sHjc7ZuIsDJZ1DjZ3PEbMSqQ0+J8eNdSu0FBuG7ZxsKIXAxGMPt1TJrcHsPFalflxNh/F0LrACHUhD7/JIs3rFE2jJq5ErvL82bEyGOIreoFUcCn5J3ksRNCPneGb+zPRgoJ/kEv1Qt95Fjg/nY7wtnm+Shaq+CsPGaeH00BmzvJfcq2Jt9XcWm+M7Iw84QL604MEo1qnnHoJbU4i3l+3C0u5NoUVs3WS3laTvj8LC0zu8zr6HkctrDuJzLqO
 COoedjEX
 5Vmy4ZwaJLBG2bskBWSE3G1PsHWT+RfAOcUy2ySEEJJt86qhQhlO+n29Iif8/p6yhuPOX9FyTim/8RegxmE+FC9C6i7ruxriuuCq2qI8PA/3V544xmJgeHl7bRYxaEJ/Dk8oUH7X2idsyD0buSVihxDfAgt1CQ9i4iw8wwJ6GpHnGJJMNJocT1Rk8hRIAz08HIFp5qmiBiBr5nizO5pEBIHooAdzxhrfsWukNt7Cjvs/hdjKonCbtj/GtfWRce/AIdTiu6mZ+CRdmpbM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 14:27, Mark Brown wrote:
> On Mon, Aug 24, 2026 at 02:17:03PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/13/26 20:12, Sarthak Sharma wrote:
> 
>>> +	if (buf[0] < '0' || buf[0] > '9')
>>> +		return -EINVAL;
> 
>> This is to reject any negative or hexadecimal numbers I assume?
> 
> That won't reject hexidecimal - 0xNNNN matches the above.

Ugh, yes (and stuff starting without 0x would not be detected consistently).

-- 
Cheers,

David

