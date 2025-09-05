Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E254CA1016
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 08:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 788216B0006; Fri,  5 Sep 2025 04:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737786B0008; Fri,  5 Sep 2025 04:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D106B000C; Fri,  5 Sep 2025 04:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA636B0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 04:13:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8C791DE930
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:13:20 +0000 (UTC)
X-FDA: 83854481760.16.AA432B2
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id CDF588000B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:13:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=bByfPBbN;
	spf=pass (imf30.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757059999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSnxdvmxv5OZzacM5YRTVKlEc3w6IJ1a52qN8HrYzSs=;
	b=g916QMRYSFHJTYJ1bdgmw7cCPk74R+RJqDiiwQ5ozQPQiYr5pYLwS52pPwCIQ5abBnHxjr
	wle4e4mef6ayUDY3NfeSSS31itpopb4n9t55uGaC+BW/pvnPNJmBTgIIxsFpfhJovwYF2N
	5JSay5vcIAzHYBi/4Kwm2/ptReVsCpk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=bByfPBbN;
	spf=pass (imf30.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757059999; a=rsa-sha256;
	cv=none;
	b=Zq155ZEIkx/WzyFrBzsdTQ+Ru3n0Dhnz9XLquZ+o7EdHD2sdfk0DWXHE5wrEZeNqaj+wcN
	pg4t4jC0lY/p4eukoWMe3w9JdEWUY8mWS60RsAAxbs7y3I1DmLf8wXTZKums5OySJe7CN5
	Q6VX/YoLY/WekyGajcWqbAiGvxtIpQQ=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4cJ8HG1R7Dz9t9S;
	Fri,  5 Sep 2025 10:13:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1757059994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rSnxdvmxv5OZzacM5YRTVKlEc3w6IJ1a52qN8HrYzSs=;
	b=bByfPBbNPy3LOaZu4299ZPvVQcOCGpwTSU3XkwjU9PcEqxl1+jVkVtDr6rOnmsU7mzdGI4
	bZNu3b9jXEUYrWWgupX92Jye4aytaM37Cyi90oLZkLzYvnFIO5pBISZhNOMxMWJTmkRsD0
	ORGzpoQqrRBjS8ZuKZxamSYpjJuHrDRSpt4GbvR6J1BHtgQfX5FWWw73Iwue0GcvXCHVTR
	R9a+t6DyLpSMyisd4QAPQh2VbMlqhKplwKCZs1Fa1VEjg4PoNNszTKsBH2x4y3DGXeyan8
	/L6iF+NKTfZnli0i39FH9ytKTBRCYn7VHA/G4o0/O4U3ZK8OjpEdtcy0/ylh6w==
Message-ID: <e8d5eafe-db58-4b78-b029-de6a59fc4fd7@pankajraghav.com>
Date: Fri, 5 Sep 2025 10:13:05 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v2] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Zi Yan <ziy@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org,
 mcgrof@kernel.org, gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>
References: <20250904095129.222316-1-kernel@pankajraghav.com>
 <2psecfvsd4lbgcm6aflifi2kc6gof345txsvk7wtsytre5ehqt@4wyru36aaeel>
Content-Language: en-US
From: Pankaj Raghav <kernel@pankajraghav.com>
In-Reply-To: <2psecfvsd4lbgcm6aflifi2kc6gof345txsvk7wtsytre5ehqt@4wyru36aaeel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CDF588000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qk38u818iqbex8r3w8bo7xn6i75ntoy4
X-HE-Tag: 1757059998-731536
X-HE-Meta: U2FsdGVkX1+M6HElv/GEG05Gh37ziuqU2UKLu8a3OU5FjuKI26WgLuk7lE4EdznazfM3zn5w/f4q5Sadg1uTHNJ1rHMx2zgQO8gegO8vveFlmpACn9abZ2CcKggncE5JC+B/sBHsPpALgqzKENzUIpBUhXnQG3DoHFu6IaTcW7JfDe7HSOR3Hz3oDvzZAeab9pBHaEqQ5JvNGLQdXfau3JUkNKQIc2HGwXg3k/w/FiXhak/vGGFgqYpuw0rugdVWOXRJgvE5o9aiozdXiSilcuMjKMT8L7r9e2bnI2w+hytqQn4Lua918XPNMHlLdpgIy8Q6ZgbotC9jhm7dmOT515BmNh1V2kL9HC6uYz6u4+X4t1mLvvxIUaISrjTy6rVxiEWTjRYmHwE6P3PH678R2sTHokHuzuVzcbPGP6IZweGhBecTGi+a4kUfPWV19QJdG8Z5Hx8OXFSI6WesSQ/njJlWeMivy06RYdfJCIhsPes6VtCmOzOQKTvq0l3xtVdDOrapvZSOJdMBZ9WuDUXl+/KyBKlSuDqKbf1CdjxlO34qlVvl/hsl5oEDWZ7YGOLp1urvDXzXeNNVNReYtUio48sRcwxIuz1T0B8RmZNExskb+sy1DbH2WpTRV6L7vlZF8FlQatnoYUUJZs05LUFiZwmNHNwU+4zYtC+FueO4y4Mr2OOt2dK8qe6PC7NHD0HCLeXRIVXrbb6ClBd8ozfUhRj2RlOe2ZuZTGHQHX3usToegE4WgTxreulOK9l4PfBawVcuyfmjPuH2EJEBJoE1f6wlcPFvSPiyi5FBdE+Ry3hgiLYIEwjNAwnaNWwWorAU43iOXRo+6ytAldish+JLmEM38ubEaOqUruSptFNjEgNYWPeTkMslL/soyQHev4Y7tii8SMF0184G0F9DPehchYNGMFXkPw5z0l+nUZUjU8ZeX7xj8Zh+vMR7Y60RsWc66nR9YBZm72JAwgQwiBy
 G6LBayJM
 x9QOyZdwq0e6oblZtYzXENLv0+9mUL0toFL16liDxSC7+Rm/9nLATy9QmYC/LXWkFwbywkaiTcmJDmNCs4DzQrKIzCq9Uuwd8dPbtC1OwZ5QCkYcdXqHvcne21CfAA0Voi9cBhjMNHUKfTOtxSeav/EhrJRJC/Rlh0H1g3lHc+XGIbQQCntSfDg3ismZohjenwsdq5WCm+R8ILAitv7QCPCwfvLvuadD6aVwRgOc02Xd4YZexFDrHETNY8oX4JkFQIdzwwjVYmGN+hS33v7D8QmmUH464r7VF1+pFkAeXhmJApjJ80iKM69FB/8qqCtZ90oET5Z3PJKIzkSMlZXz1Ad/hrtk3+MnFjKvyf6o977mNKOzRO/gWupI2lzaBg9XGgJjz5fZzNwOWg20=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/25 17:26, Kiryl Shutsemau wrote:
> On Thu, Sep 04, 2025 at 11:51:29AM +0200, Pankaj Raghav (Samsung) wrote:
>> From: Pankaj Raghav <p.raghav@samsung.com>
>>
>> split_huge_page_to_list_[to_order](), split_huge_page() and
>> try_folio_split() return 0 on success and error codes on failure.
>>
>> When THP is disabled, these functions return 0 indicating success even
>> though an error code should be returned as it is not possible to split a
>> folio when THP is disabled.
>>
>> Make all these functions return -EINVAL to indicate failure instead of
>> 0. As large folios depend on CONFIG_THP, issue warning as this function
>> should not be called without a large folio.
>>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> 
> Acked-by: Kiryl Shutsemau <kas@kernel.org>
> 
> Just curious, did you give BUILD_BUG() a try?
> 

Yes, I tried BUILD_BUG() but it actually fails the build because truncate_inode_partial_folio()
calls try_folio_split().

It won't be called in runtime because there is a check for large folios before we call this
function. So a runtime warning is better in this case.

--
Pankaj


