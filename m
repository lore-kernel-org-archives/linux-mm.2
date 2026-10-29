Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E280D606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 09:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zix5f4Ae
Received: by kanga.kvack.org (Postfix)
	id F27876B05B1; Thu, 29 Oct 2026 05:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF236B05B3; Thu, 29 Oct 2026 05:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15D56B05B4; Thu, 29 Oct 2026 05:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B262A6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:59:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A7F3C0128
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:59:43 +0000 (UTC)
X-FDA: 85375217046.03.3816F25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 874F210000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:59:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zix5f4Ae;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793267981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U99SJ7R4mLLxhW7B2LnKG47mwU6pah+xCFdx+p50og8=;
	b=ffU25bsmCZ5UNjd81TTGQXldtWHEHc48q8aWArmHrEQFcbPHC2Z8S7Zs+W+5y67pHhUAI7
	6dPjcEaxkIGdoEyDTGFwWMSX2fxPKl/IoeMfiE9a5ZSSbQiTTRJLFWQ+qNyIL7SENsvq3I
	AjeKV89spS6XaYVgnQWiQuOsFxpKwY4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zix5f4Ae;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793267981;
	b=HZsytiomtURtMBJxYYitXOcK4YJVZqs6mhvHdfEXcxiAaBHM3kgz5ROxGwyxh+M7McQCNE
	DGti0+llnC0uecr7iUHzluaRJR8PMy9T+C+Mt34T0+Mtsf4OnZggv7PkNlSTOLakcGCSxA
	6VLGH4UUV+qnXB6pUrSOLWf2KQ/q6Ic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FAF660A57;
	Thu, 29 Oct 2026 09:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C9E1F01825;
	Thu, 29 Oct 2026 09:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793267980;
	bh=U99SJ7R4mLLxhW7B2LnKG47mwU6pah+xCFdx+p50og8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Zix5f4AeG0b26CGKytIaRSw6ZEc3BYP6FNOflQjshf6oQ3fBYtCcKvD418n2O4idD
	 VkC/KPqEkvzykEwu922IObYnxERDc7XkUgobdi8UU/njPjCnkOeMYsps1ZutSRPHjC
	 NglNsTidAbDJJpEd+mFmX4esNqh/qJDQs5Iscg94kEYA9TK7o3+hcpNKOXI3l2uXHE
	 uosyFJHk1JYglJomqxSnJlTghv5bHaGCcCFZlaG0/KesU7nluOqQeCvyb7UueHTHgb
	 o78V8/RjkWyjJux2U3iC9Dlb0a8P9ffNnfw3DyjkFsxHxmgQ/jPHwLIp72Av380LX6
	 yNYLu/4sTdw/A==
Message-ID: <1fc0caa5-43b1-487f-94cf-0d1aff4c03fd@kernel.org>
Date: Thu, 29 Oct 2026 10:59:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking requests
 reserve access
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
Cc: Salvatore Dipietro <dipiets@amazon.it>, hannes@cmpxchg.org,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org, matt@readmodwrite.com,
 mhocko@suse.com, ritesh.list@gmail.com, rvvandan@amazon.com,
 stable@vger.kernel.org, surenb@google.com, willy@infradead.org,
 ziy@nvidia.com
References: <arFBr22V60BMmVpl@cmpxchg.org>
 <20261027150002.318916-1-dipiets@amazon.it> <20261028144148.GA14023@lst.de>
 <20261028225517.75e13881be22461a8c94e07d@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261028225517.75e13881be22461a8c94e07d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 874F210000D
X-Stat-Signature: aa6r8ifqyewg5u1ikwed7akoxeqzygu1
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793267981-993223
X-HE-Meta: U2FsdGVkX1/paT+LyUQAN3tB8Y+6z62A4fonTLkBaqimGsT94eWtcku8WNFLTt/JrT1ig/dFOChRqfjIudK0YibesYxYZtkEY3N8R1Ejy91IJ+s2f/bv9H+bKu7CG573QuVVh5AlRFn3ptRWkC5MgfI3TKMIjMyjx8YK3KxnZOHvZ0vmjgKGl4PQ+ctNLGIjrkACyvZskNide0xMfEaY2D9F/PJdVsRZj85enXMpl7BWFCb5gpQ2yu4Zofrq5CuNypoWSQhZ8W5F0JnlguMhu2nmEEtmnmnmyZlXQR3WMkEkNT5Jt7sjo2wT9Bya1Y2qrNj3D2NI6R1+hEk24bzDtXrbqTXN9MTuiA/s8QR+6RSgR7IJ+xbbClAAukPzQGBqFZFzAh1OPkhloUnAa60DWIg+kBVLh4jUYQaOK3hjSVxMQ2Jgu72/6l701MLsKrI7AXy8CtjY4U7m0gx5vMgAq7MRNf6WeueqwKTptaw/ZswDaRxpKSLmWs1oqHBgx9SDuLyqf2cHp7+glzWFIT0XPVaUdUT7If/AqcYWVnMJnNJ2W0WlKhTtm4JKU9B/tjp6C6ujI4VQsYTrbTCcd9X6K8CZXvHR14EzG39lo6aqf6deW1adx6tNcHugD1ieB+yaxy5QQrrVB9FsQ4V/kVlhT5cWD9SRswR1HKtZT7m5C3+raxtJ1ncuPIJsJztON6Gc7ttQzx4fag3CgKSh75rPX3Njxz+ckxHMiQQgNMmNYmQm+Attb3MMRpqLSyv/FAEpANGEoUQ0qDJeLrrNdd4QSnb+aw9d8aewU7iP9VX+lpyycL1TRl8kDRB+yq96he8gV9sf+zZF8iTdZ+uXWnXLUQ9YRLypn2wpkqk0RkbiszLM/RI+MnJmqzBmKOocXocwSVe3i/CCAWqxsYGFs/W4FPrAhS145o0M1vGeSoP0MffTBtA04sT8kwK1ses5iwktJVyiwen+xi4eYTCnsL+
 Jv8qMBVX
 OJLMZmC13ZO9EodGZ0cYWyQYvCcCL6fcM6nKxGY/F+ZXSpazQSoDJrGssfGaDykWly+moz+DcZ75P5DBQa//wobEMHW5O2GaggGbOIrw+Mk1HCHz9a9Q9ojFUM5uGA72BYuN2EWhoYY4lwhBZtzfTSD6bpCHKd8ccQhUopSUjMDdjOb0skHFo4ew2C5D8y631T//aqtcnz8PUEe+agCf3rUfVShADTCYSI+TSk4wxY7/6oI/GWxbcfLokko1PNqUeoODIM/IVJCmXDKD806VR0pszvT+F3vU93REl0PXWb9RrbdfDSNuGhsnY8cexWlAGZPq5yRMIAQ45i852k1PPxPLQBbGKYrPJp8rSCJR6SmeDFX6O1/ErOngmrFku9b8mrxU+tK38okKlM4kewOiN5TRIuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 06:55, Andrew Morton wrote:
> On Wed, 28 Oct 2026 15:41:48 +0100 Christoph Hellwig <hch@lst.de> wrote:
> 
>> On Tue, Oct 27, 2026 at 03:00:02PM +0000, Salvatore Dipietro wrote:
>> > 
>> > Hi Johannes,
>> > 
>> > Vlastimil asked that v6 of my page_alloc patch [1] not go to mainline
>> > before these two patches land, so Andrew parked v6 at the tail of
>> > mm-unstable and dropped its Cc: stable until then.
>> > 
>> > Are you still planning to work on 1/2 and 2/2, and if so, do you have
>> > a rough ETA? Or would you rather post them as a separate series as
>> > they are? If anything is needed on my side to move them forward, I'm
>> > happy to help.
>> > 
>> > For what it's worth, I ran both stacked under v6 on v7.3-rc1 and saw
>> > no performance difference on my benchmark with or without them.
>> 
>> It would be really important to get some fix for this into 7.3.
>> We can still perfect it later.
> 
> What is "this"?  You're referring to the performance regression which
> Salvatore's "mm/page_alloc: avoid direct reclaim and compaction for
> costly __GFP_NORETRY allocations" addresses?
> 
> In
> https://lore.kernel.org/all/9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org/
> vbabka indicated that Fixes: 281dd25c1a01 is needed on that patch.  The

"that patch" being Johannes's and the v2 you picked up has it

> patch I'm sitting on (below) has Fixes: 5d8edfb900d5.  Please clarify.

It's correct.

> In
> https://lore.kernel.org/all/c6e2c1e1-a285-406e-a2b6-c09e05df91d8@kernel.org/
> vbabka argued that Salvatore's "mm/page_alloc: avoid direct reclaim and
> compaction for costly __GFP_NORETRY allocations" should be a 7.4 thing.
> 
> So it's all clear as mud.  Can people please clarify?
> 
> I have hannes's series "mm: page_alloc: fix reserve access for
> non-blocking requests, v2" in mm-hotfixes, planned for 7.4-rcX.
> 
> Should I move Salvatore's "mm/page_alloc: avoid direct reclaim and
> compaction for costly __GFP_NORETRY allocations, v6" into mm-hotfixes
> also, and restore its cc:stable?
> 
> My vote: "yes" - that's a pretty obnoxious perf regression.

Yes please.


