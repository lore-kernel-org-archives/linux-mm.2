Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE4DC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67FE96B00A0; Wed, 16 Sep 2026 09:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631176B00A1; Wed, 16 Sep 2026 09:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548C46B00A2; Wed, 16 Sep 2026 09:36:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30CF96B00A0
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:36:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95CDF1206DC
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:36:53 +0000 (UTC)
X-FDA: 85219725906.21.50E6F1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C275D120004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:36:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VMrwujIi;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789565811;
	b=G1K92D2g7GhdYgtLKrSlXzk7m4RfUERTisrMS7CmK2pbycBLasrr6YZt3zNvB/JGKKkTTF
	ZNbCHQwgHEOXFAu+vziK9vmJJBiLZ3Wp5scj0etOfJxu/6hxLqfnGZBzEFF1DfmdZ+w65b
	SCJ6SEXYJDT3SzEpRGg8LpRzz2BJmAQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VMrwujIi;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789565811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIOwNGA0MU/NVfhrdRk/6kNhj0M02kW7XmE+rQcbLdU=;
	b=o99zcoDZcfjcjj6TtGhWCjHsq1RjUA+3mEVHSBlRJoqTkyKKA9mbVlUjCru4PIrQf7NkhB
	iFCo4HkZsS0K3nbPP7RRlt+KWL5FVmx4HUmWTQQww9rMdnq5KvgW/2icRznHtu7uo5R017
	sYKRENWNGoepfhKzmw2DleGpuvWYONc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F5F240C2C;
	Wed, 16 Sep 2026 13:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46AF1F000FF;
	Wed, 16 Sep 2026 13:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789565810;
	bh=aIOwNGA0MU/NVfhrdRk/6kNhj0M02kW7XmE+rQcbLdU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VMrwujIiBik3+7HDLtAyBMSxqEQWSXE0OgnntRCHHaB5GYadUH37/KcxMw42L3T8L
	 nJdH3tcLXAVs4Zikcm+jbbIYjZSLbXaHWS/xq8G4GZ5h2jvs15Ic9dCeORiZksuSSr
	 hoOYQBXv/yIHBQClwmbsoOMdFkGzkb9askn2F3LTRlvt61DFyEAtnT9S2tGXL1rzjW
	 GcjRh09Shyk8i6mjZ95MvwynQOq9UOtr7zTqtph2Vg45+QF/R5CEdI5vkX0THYygg+
	 GokAyhksjgm6lKVLOXdfIevQ2BzHUnLqpFdYIcYQLFdU3NaoLkru65InaACrorxf0K
	 vYtXjGRLlD7ZQ==
Message-ID: <2cb3bb6b-df38-4568-987d-8e71b3244279@kernel.org>
Date: Wed, 16 Sep 2026 15:36:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 03/14] arm64/mm: Route all pgtable writes via
 ptval_set()
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-4-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907035030.2839978-4-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C275D120004
X-Rspam-User: 
X-Stat-Signature: nwcqogcbio7ugz9rxsoxpnedzegmhs7f
X-HE-Tag: 1789565811-539574
X-HE-Meta: U2FsdGVkX19X2JhtKXu6RabdjMM95QaSDOhj9iar/pHrYQRLrxxZp94DOV5e7jKmaZSNOUqItyZ34fWyEi1KqX0UFT6gs09MrlZiloqN6UrYPHmmO2Mj9GYUjtkmm6IQ8AdjDrK3ty42o2/UCCmCzyDnAxDiUbX1ADgO2JqoUUfo/H/VAODFLdoHB8lqZ0Yf3xEq6DSN5dNtDZkS11+YCZFZpBEehNe4XHeM4DQnPdr6Kt6VqkWYqnYhQ6YeW1iBzBsSIeKUzFyTHnodD6+wyAukC8gg9smgERqMNcv6nbDLPG7ZBZLVljPPR1Gl9FHqEbQs8dNm7UwVLRtQE1uWpihNGdiaIPS5umVnQKLc0Uw9SF6owx0Df9rh+gxrUTgQSjg+skt6DAd11fXsUFZP1AdlYv0WW/xx3yOU0/T65RL88c6ABtibOtCul0mJxrI4VWkoV/AlsukBk7+se8lP9e/IZCbL4/Nl3VBhk7txZjrv+7lyrNFNKS5+7CR/6w+fgJdriRluS7wStGdyAI7CehGq5n5iJrahcO7FN1sEPwr0U/n9NgwltE4cYIiwSctN2hHptNfgbjJHvXd2yvtp+pM1jloqL8y0cbuAEBif14dV5TajwlPnvXCUHK/QI1WGMOu3Horqu8uBcA5tNz55Nm6DvEVknV3ZTr/iS457bBbgZWeWp0zYEXqSD64ZTqS4NMazrnIYXmtOA1Dr8CIiVZQwTlO0UmeFVaq9hbamcVtTXRSSOxQSVKzYnwSyRw+kxu8fzkqfMpxbxIQOEsFnOXEcdGfMZVWOYJM5tLHJawxQ0n+9RzlB/4VZxA7Oj1/zK+puTqVCRJpiakgYJlMfUJshH11RGf7Yb+1pEgngj+sXjgTgPtj/hwOwuMjysNuHaxPOMfVyvQh/XmJqwTc39ebdpOQZDKtPILOWV8S26tVQ+ivuHhL25wphVyJv6vCejJJemp69FfqVNFcD2zC
 SIsOGnn2
 dpSpjUS9yyiqX/5pXhNQ/m/+YtDktBMBPUe/vq0mWJgvFuJEQggaEM6rPapV7k9wDGpUzMy8Ex9875+sOIYsuoj3a1ZWoA/Pytc0ubtzemsT00aW7ARDAB909nhMdbZuBfQLcbLPw1ESoCJ+S1pb6Foxgts3jsjTHouWo/VQZMyZMTv9nUg/Xz48nW3S43pf06zP2lFdfNzgsx/Ikx6xVVx9hJcraRX9CbbOOvD99XQfjla0pHwZFAqCFTg4kSGJkkf+SEmGvnkfk1x3/dqVkZsuyg8ci3zui4b9S6jwlv3QVKTpMXwk3M0YFKgtRUgvli9HkUrcuYGtDzIEnLIyQXIouLWjGIALVIIttMPlS3/cXYL61iHKDTd+214ZGFiT3TJgcKiqX5LY1y3PaCJ5KGVbO3fuP/Poa3GQzl62RacYLZ2gyb06xNk2LJie2DhbXX0jX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 05:50, Anshuman Khandual wrote:
> Currently ptval_set() is defined as WRITE_ONCE() but this will change for
> D128 pgtable builds, for which WRITE_ONCE() is not sufficient for single
> copy atomicity.
> 
> In future this infrastructure can be used for D128 to maintain single copy
> atomicity semantics with inline asm blocks.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

