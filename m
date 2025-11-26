Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C51D10390
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 09:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1E26B000C; Wed, 26 Nov 2025 04:09:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4925C6B000D; Wed, 26 Nov 2025 04:09:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CFBB6B000E; Wed, 26 Nov 2025 04:09:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A2376B000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:09:28 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8F8C89620
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:09:27 +0000 (UTC)
X-FDA: 84152184774.16.3A23FBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2B44F20006
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:09:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cjWuRKYV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764148166; a=rsa-sha256;
	cv=none;
	b=tlVjKMYWw0Vt1Y1KrE9XrqqYbaiCWIi3sykZaEhLBHaxZ8KEwpatzqoWD839ws2pQd1LXY
	EXSz9RUR6lByItjiX7Hl+AwIfBRlq43pAF5t7ULNbmBSmiiQ/JHKwyxH6ugyxodvfHtVOB
	Jb6hC2B1mjXd0hpxXSRCQ8Ja6655K0k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cjWuRKYV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764148166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Gr10CwKdtb4SleaUsOG6+O86zywUhhya1c7e2fCHVM=;
	b=8HCD1lcDqW0evdXuL3J5Lrve5J1c5Cy3Zsfbnlftjb543sjpq4Lm0UHR/G4Lzlcl6BMTwo
	2HSUYOPU4b46u2cBIWsQdm48qtNPhbpbuLc4C2+cwhs6oJfXanAmi+dfKkTreFabHjezzS
	v4tfUjw3bOYVvPSTKlZ7Oy0jAP0eATg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B68B60188;
	Wed, 26 Nov 2025 09:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D63C19421;
	Wed, 26 Nov 2025 09:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764148165;
	bh=LSOH9xvGOE6RLMS3a/VOtUotXTUqCCR101As0K7mTCQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cjWuRKYVWODeIMm55YNipFGgkaSKrRlJ6OUeRG2qxCY1qPyEj0QEbt1k9pJFfEY6O
	 8GcHT56EvhctFxwRiLhkxZVFTU5aaaaXLec0FVU5tFIaOoyPZ+N9bk0h8G7dfg+vSM
	 V42Cd73KUfnW8HcIq+EpztSNogL603gp9SbRM/GmwntbdnsNLm6DDrbW6M7UkC9bv+
	 R8CFTxUqTKze2HPin8hb7223YsuyK+HR8CCRDXw5WmhmZTQf8wU++jPCmrJTf+daZx
	 paGBqY1//RiYAde3PZgTVjevvWPAmrS8F6h7RXzXF3R0FsEPx99ATA/WGwkO2lwWWi
	 D4ngcBmD0P78A==
Message-ID: <506e7a41-a199-461e-91b1-035ebd5d5527@kernel.org>
Date: Wed, 26 Nov 2025 10:09:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: use standard page table accessors
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251126064723.4053-1-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251126064723.4053-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2B44F20006
X-Stat-Signature: 6ccgi87d7thgyqra31pqiuwxf8xkd5xz
X-Rspam-User: 
X-HE-Tag: 1764148166-197833
X-HE-Meta: U2FsdGVkX19VjUUWpZBn7RwkSCHDZPknEyrXRP24FogHViTDtg4yBxKdu1qpIeDLIQhz1swn3hXKsBgiAxfrW8Cz9xepukt9zW+qkPCAHXRytBl6QVGPvkYFLV9xRG/2YoVJAS9ecZ5VZprN85RPAOi1MEpr0oRvYbxO5ro131zTyltQAuV2wTYCONnPgAKO6dVCVmwFrCf+WD3FkHvm9FyzFL9ZHI5bF6Mo00mrn/X/0YfQZAFkaR+UgjKsEZjWZgpv/b2G/WGXcgzHhPFAZ9aPf1cLzXqne7aFguU7de+LCqIe40i5zmbw7rvflWrXNAiw524If4qYNF67jkapyQ3KC2cUyDuZl1XTfMkvRPmkhKwxyVllqq2WhH3cDOnoHkW22/xIqN/FDqsc7sfpV5t9l2FMMbSMpI4rzwvxejPDsxzTLu7q/ZaMzd8wPpIH0EcceD0yKsIwc2WcqHYvZ7xDmD2QXIlZIKihpqOEdQKo0h+i9fpyoS5lv+tJ+w7/LdkgaRIQk0gmuuNTGJ23NdsgzFlYzscE7XwnVJvOG8wuIkZO8raNiXkV7Km9YIbcvwpKgAwRHqdC7U/05xLR11uLBUvwDwY2zCCIKGuhogARmu3Q3TnUjAOH2yHASfiU3u5eCGktghohP1t+Xv7/8O2LNw5erDA2JQ7sL4K4VTKfEpGnxCW/tFd/hFxMJyjWbTKxSX18M1EZxsQd2WQ5kX4UXz1IwPZSA1GOnpvpiwdomEN+oXhNPQT3rSXETS9HsfOWPzT6JdRprkAjXghgu9ik2nOZ6+wprq9gyDlhXWfhuh5GZTsIqsiGVM9oufSmYh5EkXALJyrchqKJYC3NG14CiDK5C45CCnTVhwacVCT3Osd/qP/bnBgV2N3rjPEm+0euZTpv0weiFLn//coZuN46/Z59B8iKR35a+301k1oqqb72g156DeT6lAQQIgxNpHEI0D5tP9+uEioeUpr
 ge+Gkhnv
 5a6EOPBzeyZV0d8Obp/GxdRhQbZNMDq/Va8URszz87SMTkCswYcZAyHEj1+TejWqTq8LyFq90NDF5NajIDrM8MPEOTtOgLf8h4prn5Er4EDLJaeysIVDmliY44hrDb6J+inQHAzB85U2jh5vDB8WIAtlG7DYvU41D0GJocrVtULYBnN9S0eoG4C8K0HYL35hRg9jarPLDKa9MnjoZiJjIis2jF94gwRhR+1I4vTLxdgKlaL7/pWKzhSt4yp8/TEoKH4JI1l3SlP2iGZtevhNevGTY/Hgch7lLmXYyRaqjSR0TCI6ws/sqFsK1dQRAAMwxsKNYUImM7gvU+4A5j7iusf+uSXUs2MUakeAiZ3m6P6pcWhuxicvsJIm3UcDlqaJgL4BSamy4FqXMZTPKmi0XANP0aAfWRrVbqfoGAiYd3uVJyqH5TtoBfUKIp3WIH4gyrdcE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 07:47, Wei Yang wrote:
> Use standard page table accessors i.e pxdp_get() to get the value of
> pxdp.
> 

Isn't this covered by

https://lkml.kernel.org/r/20251113014656.2605447-1-samuel.holland@sifive.com

In particular

https://lkml.kernel.org/r/20251113014656.2605447-7-samuel.holland@sifive.com

?


-- 
Cheers

David

