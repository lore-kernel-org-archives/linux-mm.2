Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC6B61075280
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 09:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1A46B044C; Thu, 19 Mar 2026 05:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9A56B044E; Thu, 19 Mar 2026 05:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F384D6B044F; Thu, 19 Mar 2026 05:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E61736B044C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:14:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8516B9815
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:14:23 +0000 (UTC)
X-FDA: 84562251606.06.22C39A2
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf21.hostedemail.com (Postfix) with ESMTP id C1F121C0004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:14:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E8KC75sI;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773911662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYXkNav1+HQX/FrEJ8HsLP07xF9bB7aK4BPpIVJxRmg=;
	b=vpLSqgnVM8Jq2wTOCXBz+MkxU/E+e86hhnSvI5SSHmne9zKH6aSjnsamRepJbnLE9l0Q8s
	gshvI3uHxBzLzPBK3EdGVYotk5Ao/pCkmViNManLOzKft0OC7GHFj7XhL/FfVGxDjMIrTz
	kajy7ERnjf7aOVH4oM2TA7wuQ3qIiVM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E8KC75sI;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773911662; a=rsa-sha256;
	cv=none;
	b=SzytBe54Z4M39iL0ZNbxMAIbKiYz9TZzzk1NJMuWm2sb6+YserCeG/FKuTqCR6XPclGT1Z
	0mFi7mx7o3sVVbHGeBV9yy7XRuTjszCaNmPlz7hO98jpykCgXezc0nRkzDBQGwmGE1uFA6
	6CGgWFaJ3s1GDypu5GsPF/8hpFMh71A=
Message-ID: <b963c391-8576-4351-b121-67ab9a9b2a1e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773911659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gYXkNav1+HQX/FrEJ8HsLP07xF9bB7aK4BPpIVJxRmg=;
	b=E8KC75sIn/igZd6wRapbByk/rIhF7KrGPQPN9fafPCaBRxPbu3ogIttiA+zoTIx+GELYXF
	USlQ35JZjtQYZCRexz7VHtTpRufNnX7u9/o/1WSXAUYzgLFcTdCmKmKUiFM7/LOmaWKnMl
	tpXn4ok3Bi+POS7vZBoGQOhjnUXA2EI=
Date: Thu, 19 Mar 2026 17:14:06 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>,
 willy@infradead.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
 linux-mm@kvack.org, baohua@kernel.org, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com, dev.jain@arm.com, ziy@nvidia.com,
 linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
 <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
 <10e5f1d6-077d-4783-aa16-6c8b98cb9e74@lucifer.local>
 <c3defcfd-74f6-4e70-b002-85bdcba44df9@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <c3defcfd-74f6-4e70-b002-85bdcba44df9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: C1F121C0004
X-Rspamd-Server: rspam08
X-Stat-Signature: r6ukqcgkbsxdee43fid37dbh7as81h1f
X-HE-Tag: 1773911661-966892
X-HE-Meta: U2FsdGVkX1/yHr/wU7stbIA4iBugEh+FdLCdpz8+Q0lRE3RQHIX2S7/OTEN535MQBemepA5O+BDWTppd6eFrjQhL6020NieVAZ1uewQW201kz2TUoJDCsX01w6YEiIZO03pznWSralre/u7FbvF6TOQxHPlX3toZCWtbKHp8qxLSiy2HI5K/uNrj3XPH5NQQn/4LhCgpIiXw0kU7DvziLuv23JTMi0PQN00QfImgOqemVp4dij2qNfEsopF02Jc5N0NZ8GZwTHeoIsogU8iyqHU/xiw7oifCoPvupdNYmMy9+IzN7pBCBUpnkYdVvRkxgvwWFcS1koPxYUU6baaVv6yRK1zuBsJ5muWG4YGe1EgPW8CGk/XluSXh3nd2UeaS4G1xMj3i+jsB9iavHi5ehXRG7+RWLT58fcVCCqwyf1/xfdR/yMO6R2cn1q9Eq2WTvR8OXX+639xXqHCwpeF4yC7K3bD2zYQcBskchIafnvwm7llgAka20MH2xW1pmvKhI5AhC/0Ndy3PKn3cEdCgPCSsox9ncxqVS+1r8BYy7EKJ1+zLuHDs78+L++o0s3iPowwYhLB4AfQqaxxudVuvrD58M4XdZ/NXKGkMDNGmIEiViSrLQRuPY9KRHz+zL9Un2WkuNeS9/67TB+MC8+tQ4I0w5jrS2CK6U3dWlWKJCZZvZYvf4a4BML8XlY3NuIkc5O74Kw5tyiYMTEf6kmLGy0Z3tKTnT2tTuC9U4yRGCZwBnnNO13kR57rm3dLXEqldbayHJRp/DKPppLRvn/fO4NiNTuuoviI/nBtdmtBczFZ9UjUhheAQR3Nk1c6min9RYQp7/QCelP1OzNFSWPekYvIdY9NQgtM00vv7PZfqrq1XKUco5yIvNHaxLEjl+ZlyWpjI1xgkU60EbvswLPljs8qc0416XfKt/QRNaqw+mut0jx9x9fB5sBOmla3+A4Xk8nWpAyb8TMNDA5UzMr+
 5JgCAv2N
 LhYap7HrkChysaBNYeKKU31QtExvX9V55CNfVpEpcTeEfywhMTshY5COt+Cq3rxiVBxjAA9H8QMdwo0Ie5mujWzW6wn9G8v2rUaEFLe1Fr8pd3Ogl6GxQYqoyGhagvA3uPEdL5iXzdHkWV/o0Tsle4P97EGPCy7EMbX+rRDWSPlj6r/EdRtaZB8hkR0jGJH75moM8JCiZWk8xtxcCq9MaPLV68KBNLBqWCWMlMPCejRZDnE7xkKw7V2tGxIfBYzUbwsUGQuyumPldQHI7ii+9rFCNwsqXtTafW9iBE8oobB1YWsvw65hCVlvsz2tMai7Aa6ZUsrhR83NYvbjn6H870MNdI+f3R81d45Hw8AsD40wo1YusmcQ3lu/LyTDuGCPY50irGpks7CuA8hJagC8oNnClP9v85ULR9y5E7nD5cwmOkuqSRYy62mEvFMF0e3GEJ41Q7a7rSBXLr1wuYmgmgKUdgTaQXUHWHrQusn2FX97hNemi+4jWl89MIcC/b7eabbL0yB5fe+o/llY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/19 17:00, David Hildenbrand (Arm) wrote:
> On 3/19/26 09:53, Lorenzo Stoakes (Oracle) wrote:
>> On Thu, Mar 19, 2026 at 04:05:38PM +0800, Lance Yang wrote:
>>> Ccing Willy
>>>
>>> IIUC, this is a dup of the earlier report[1], which I looked into back
>>> in January. The root cause is the same: collapse_file() calls
>>> xas_lock_irq() without resetting the xas state first, tripping the
>>> XAS_INVALID() assertion:
>>>
>>> #define xas_lock_irq(xas)	xa_lock_irq(XAS_INVALID(xas)->xa)
>>>
>>> static inline struct xa_state *XAS_INVALID(struct xa_state *xas)
>>> {
>>> 	XA_NODE_BUG_ON(xas->xa_node, xas_valid(xas));
>>> 	return xas;
>>> }
>>>
>>> Added by commit:
>>>
>>> commit 43b00759f21b10142094d1ae5ff65cbb368953a3
>>> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
>>> Date:   Sun Dec 14 10:53:31 2025 -0500
>>>
>>>      XArray: Add extra debugging check to xas_lock and friends
>>>
>>>      While tracking down a recent bug, we discovered somewhere that had
>>>      forgotten to call xas_reset() before calling xas_lock().  Add a debug
>>>      check to be sure that doesn't happen in future and fix all the places in
>>>      the test suite which were carelessly doing just this.
>>>
>>>      Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>>>      Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>>
>>> I posted a HACK fix at the time[2], but David pointed out that Willy
>>> had mentioned it likely needs more thought[3].
>>
>> Hmm we shouldn't leave this bug in place while working for a fancier fix??
>>
>> Can we get _something_ going as an upstream fix? We can improve whatever we do
>> later right?
>>
>> David, thoughts?
> 
> I recall Willy mentioning that the issue is likely a false positive.
> 
> IIUC, that commit is not upstream? So it only triggers in linux-next.

Right. That does not appear to be in upstream, I only see it in 
linux-next :)

> Which means:
> 
> 1) If it's a false positive, upstream is not effected (no XA_NODE_BUG_ON)
> 
> 2) If it's not a false positive, upstream is effected but does not
> trigger the XA_NODE_BUG_ON

Yep. So this particular BUG_ON is not affecting upstream directly.

That said, syzbot will likely keep hitting it in linux-next and
generating noise for us until it is addressed there ...

