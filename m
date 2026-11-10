Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A35C606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.a=rsa-sha256 header.s=default header.b=E3LOkK27
Received: by kanga.kvack.org (Postfix)
	id 7CDFB6B00EF; Mon,  9 Nov 2026 20:49:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77EFB6B05B0; Mon,  9 Nov 2026 20:49:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FDEA6B05B3; Mon,  9 Nov 2026 20:49:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DE1A6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:49:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B269B1406CA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:49:26 +0000 (UTC)
X-FDA: 85417527132.15.77BC872
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1419C20007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:49:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=E3LOkK27;
	spf=pass (imf03.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794275365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGP3oQkxG3O8JCUGO0KxGDQL8mkVh24OfjeHZDaL43g=;
	b=PUWHp5o+q5eyEAgatVPyjP5OxxPhBA1blLU8Htpe4N6d6Z3QGgAYORDR/uoUW6q8i/XghJ
	dbbPOECYii2jX9LyvuEOF83Mly3n0Yu2lvzr0gUf2bPd6aRI512IBkX/0Pzda1yr7rLGOe
	mz4e6XfJ79X2qlCUOpWGdzujg5jb/HM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794275365;
	b=T6C/xZivw40kmzOY03G/NmtxWrwHAnGhO3xP3dwMdpJbSj3mmkaSyroYyWFaVPfEr0s7Ok
	JC8jVc85qx821Pyz54MQeB3g6m+FPtFVGIA03+OF/j0MOYnrGreCXciTrmCaTTgy2fEL1Y
	EYQESchce9PUsuGKpPrhz3fburZYg3U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=E3LOkK27;
	spf=pass (imf03.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1794275364;
	bh=7OfvsyWkqHG1aqQLcvzobdPCzMSRDAQfKu/eu5xKdxg=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=E3LOkK27gn5eHFSrMZGs+cczhqLC6805mjcsN8xtgdjPeEK39Tyh6Pui2Eni6eJYt
	 er/7/IDmt3Kr2ehckzAsUPgnbhD+/0YW3U+gagGWKiNjr5GmPoeFhsPznVX/S5Mjcz
	 RjyzV2yPPBqYqrTs13Y1J+bOw2nJxNxMd1pwXDOw=
Received: by gentwo.org (Postfix, from userid 1007)
	id 0122F402BC; Mon, 09 Nov 2026 17:49:23 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id F29EF402AB;
	Mon, 09 Nov 2026 17:49:23 -0800 (PST)
Date: Mon, 9 Nov 2026 17:49:23 -0800 (PST)
From: Shubhang <sh@gentwo.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Uladzislau Rezki <urezki@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, 
    Shubhang Kaushik <shubhang@os.amperecomputing.com>, 
    "Christoph Lameter (Ampere)" <cl@gentwo.org>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmalloc: reject overflowing vm_map_ram page
 counts
In-Reply-To: <20261101201659.c6c07375429df81081ce8b0f@linux-foundation.org>
Message-ID: <d6fe4283-0d6c-5fec-2252-af68b2c46b83@gentwo.org>
References: <20261022-vmalloc-reject-overflow-v2-1-0db7a20c53f0@gentwo.org> <20261101201659.c6c07375429df81081ce8b0f@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Stat-Signature: nj1qmxk63ix111qtx976ptx9p3zhpp8y
X-Rspamd-Queue-Id: 1419C20007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794275364-116079
X-HE-Meta: U2FsdGVkX18Gz6huqlQ3RCxLE88YI0MXA3vZ8fLb1Cyz45rE8Q+PnGZqo6C7/ebfqaul/KTdB5O0YrgDahBfFHX+yjI4nUS47eIJkgQRl3HiNlS6RRPP/F49G3BRA5xQETl+PsMpDJcHcJqikBrnqaldvf8CkIFhu4VO2Ap+46AsuMPGlip62ElYNkSlgAoNGq2ANVE8zRpmf+JE1r9cowdHtn23TIMBcaDUeXbDaJDXC7Cke4bq9l7dwy6dJP/5sYiDICq/LL9vROE1D9bv2KkaUtzfTKe3b/KYE+m/oWITTEY9eACMUbzIkHIA75BvvE+aNr2HH7shKQH3bpQlTrYuQm1uFYPhhlEdLwXNFUixJh6rqrGMr2ZzElKmuNDHN3yrUDWff5+a+u+9hHDcD7dBcA2HHAvU3Q2gnadh+XoLWkxHBRZ9zkH9CF4aEXxLu06HBZyWLMut6akm42SsUA3x0AQOYyBdZSgjk8eS/z4mFHd6M+PtrJzbPg/TuOQJ4iyEOPwKyAAq7jpGXGf7YpF921v4AkS6mCUaNQ0kZ29rm4WdH0OJnIAsIAJI8oVEqVHjhwMNtXG/3GVTxW7QazqaYmtbDW0wTLPkbwjFmCIuS2W0T58rqcDlk8jt69FzXEyGGNIiaMiQLNxuxNslxEPpslR/KcvF671FWWB+LK/6t722oGsOMB2d6Ebsc5TbvO34b+eIn5h87LF+qCOOQvZ336FTM28GULiR8uVMJEQaWpHn1d1bT4Jn62p6p+HbgxjsPWZSqSpCmA5dcTcQlQf8PLHO9t42LM6weIQuzL+YdwWf0iWNVOfO1f8zUp4hQzI1eD/V85A5/c2HcBG07UmrYS4EnY2fEkGshs4Y/DpSR6G/baMTanCrvX6LXhq5Hir7h/LJD7cPv8/jAVQOcgSWgFvggwJJwpAt6PYFwSA3QP+/QkdYalzgIXIhitCFzTk3yXKd1zw69xnC6bY
 IQUXowui
 5C2disesZWCO82fjwT7fbow+G8XS4wkLt+OviU3xAzqivt4UtTZ3acGvL/4mB8E8Aq0kOfb8jLQDILFCmXXmy8nfG4Hj36n3l8GTIWlcWb4J0DfMRQDGI+K+ILk85t5TeVD9jmF34qQBrHoDCNXjwoQo/4f+dgW0WHdplTLVGMvfAQkP+7j5DO/l2wIWY2gI4D/77uZXzNRooQXvMOln6qVR6f+H6MrHC1/MzdBRkbVnpFWYTpwEbgKdwYtRWu8DG9+/OfUJcQFzwgeySCyDrpHhVD41Vk1EVpYF7LjX/tovSpUqw8H6paGLs5MbkXYuSOF03QRjLGxOVII0Q1EAZJw89OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

On Sun, 1 Nov 2026, Andrew Morton wrote:
>
> Is there a case where userspace can actually hit this, or is it a
> theoretical case which can't actually be encountered, or something else?
>

Reaching vm_map_ram() with an overflowing count from userspace is real
(as noted in the udmabuf path earlier), but actually hitting an oops or
corruption remains theoretical because in-tree callers don't access
beyond the truncated size.

The changelog described what happens if a caller does access the full
requested range. I can send a v3 clarifying that the failure mode 
is theoretical if you'd prefer.

Thanks,
Shubhang Kaushik

