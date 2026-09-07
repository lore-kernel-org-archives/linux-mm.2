Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE99C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387F46B0098; Mon,  7 Sep 2026 09:40:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35FED6B0099; Mon,  7 Sep 2026 09:40:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277526B00A0; Mon,  7 Sep 2026 09:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 034076B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:40:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 938C4A017C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:40:57 +0000 (UTC)
X-FDA: 85187076954.24.61FD386
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8E78A180014
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:40:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="i /+uUs5";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=pIyY4zcH;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788788455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wi5+8qW6puz2y83/n0553V6h0M1VwJvxtBCvRrBB+lA=;
	b=dcMG68mbzGP7qHS0v3TP9e/ma2gKacOj3q0Arbu3He6D1PIgQNRLeKXApNbWg4BLq63yko
	XEXWRA6ySmz/f6bHU3N4YZh0D+mMTgTW4p7SfOAgr43cP3ykfk/qn+xQBxFeupRcbycWV2
	VM4zNPC2ayYVXI+CeZE2tHtEEnnbNh0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="i /+uUs5";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=pIyY4zcH;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788788455;
	b=exZOHfgYTWiWER2Px0ss6rq/lOHBI94h+BaD0l3FVnpu2x7tJMJGZG2LbiB4KLA/Ua13xB
	lC+jdHLht9/yQ1Vu1sf6XNlPDVZ5HLbhEePtl3leOh/p0e0qB9o2nQpkS8rMkluCR/+jvX
	mvfeJVeKAX22Ntd4eCj75l8Tx0/CyYs=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id 0CECC13800B9;
	Mon,  7 Sep 2026 09:40:55 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 07 Sep 2026 09:40:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788788455; x=
	1788795655; bh=Wi5+8qW6puz2y83/n0553V6h0M1VwJvxtBCvRrBB+lA=; b=i
	/+uUs5bhTNX2UOHY3PkZNUkN7KJifziZIEyunIDLwpyiaMOoY54spf4T2HZqvxIY
	Tm6mR5FipSTlXcSt/5IY5NG8xV1BVD3TESXh47wMgAJegIoT3v9YoXtEYOt70pDB
	tpyCCLkBohsfXJHHD1UauQRXzWQXvqCYOSDrNDs/f3/ZMiDC6F/t1XLSw4O0khVH
	SnlxkLH2cVzPm12osR1NMv47AAFqOtMBNSjJBy4gUA8F3dpNhGbH0dbBXM66BeJm
	UO9pPzfXexGeKU8AiMxDkIo/Ilit4AlIJ4IKzISiOb0Zb42J8a4+pb89L50gKXn3
	FZ/Z8ku8KPwVtOfKZ1h/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788788455; x=1788795655; bh=Wi5+8qW6puz2y83/n0553V6h0M1VwJvxtBC
	vRrBB+lA=; b=pIyY4zcHw/Oa5LRW2eablw/Y8cciX/NQdeBGfoh4UnqrBbokuSg
	Xo59WurYZmQuJbhndlHrNZnEWOkEGXmORwLKBYktbnZaChNCbp+LZBh9gZdAhiet
	edtQg234q82hrB7fbPh8GN1k6wBmbeeVRY7jT9I2AAj+j/zeiM5nyLhjkUgwrgh6
	vl3m/FxwsiNabFIqMwxPpuy/2XgL8TcPHfssbMXQ+iAsuQNARRn0WzTx3hdJLdsZ
	2Gbcy3PqA5J5Ip3fugcNgY+Nyl1TU/9swKdHduURf5+L0PUgJ11pVAEfSeUNvQfj
	nuUzOye28x25zBbpoXYejZ3jDHTa3nwBQrA==
X-ME-Sender: <xms:5r6eairHXcEPWqFqQ9aA7X25mTKkRb0Tpbippijc-XtZI9gEvdewVg>
    <xme:5r6eauQTS7k7TxSer6hWdU1OhWxMWVnZTGTZr_6onaeba6rbJbknBMAjv9w6tTZIg
    OqGHLcYmSJAvNaKYiZCAO5FdbusH0q8ZnTUCBgVeWmR3W8Bgi4puRix>
X-ME-Received: <xmr:5r6easwVfb55BaPQgDIWv-gKcmWRpxDOQvcXcLYT4HKC83wX-Psq7Ds7mHA>
X-ME-Proxy-Cause: dmFkZTERvVKHswdGsGm15ml65Apd+MP1QKrRKABRUnh+cCgabGwk1x9rxW07letJPaeHr3
    cFJXzrGLGRRI30Vt70l71GZpwYOmWaGD0DtIy/yoYt5+9f76K45Va/fNc6+HYFRYJ7eA86
    3PD9SgGEKKUGGWSmPdla5v0zegD0baNdRM2Q3eTy7eyFP9IG7TDVbREaRGuPEun6FnIpa3
    L1YNQh+HtIpUPWlYOm2YxJynknLrH57N6p1vIjyk43v43Zzm4zhYgYxHgQboItb8I/njYY
    CMlLQ39JSt48hfgD8rBnCX1RZqOa1WGC3i2lSDDjopPd0WtxYYeqmtWxiR+hTOLb9sV+T+
    ndlexVpY+QQS7gb7JeGSIOTBToC0ubwLLV3OVMPhDxJ3qiwLvbX7a/E1h1BB6hItpClMVH
    tSXy0fRMMa/dKVbacdGcepajZx5byJnMW4YNoqlRPy+76gtrGC7Bdcl/I6+xgUfgZDfVa4
    a4xKeoT38eOANbiiexcg2lrJR9bLU8nWur2FdFNpdjpOSH61bcI49du3rA4D9k05K5F3gm
    365JThRcGOEIF74YOdqtWjS5j65nNRE5UOMnBuSpjmZnksiNi6KI1H05rNlmZeRa/L4yrE
    IIr9SlFSunGygK64vwlMIMJyRzB1y/eBouJuuaT/LnjftyXoRAM2yCUW30Eg
X-ME-Proxy: <xmx:5r6ealijxDMZ8Gk8VnB8BAUn6qovSX2AtsKeG8pGn5xvmMziOCt4Zg>
    <xmx:5r6eag_s5r6gw6d9-Vd2yI5qmLDCpKJPiNJ7adn9ulEgFLtIOtuodw>
    <xmx:5r6eaqMYAyJ4Vuy3zFd0vTLolT82fFF8P3GgQGKQHxWJFXUH2slhUA>
    <xmx:5r6eaup90Ai5mtpyC5HSlw-IynqRbfoVE7lDFr_lhL72koTtjqnzhQ>
    <xmx:576eaifHfxa550yqtgvMGughymCUeF5Nz1suZTXoi2IzfET8dbni2ErX>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Sep 2026 09:40:53 -0400 (EDT)
Date: Mon, 7 Sep 2026 14:40:51 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, 
	usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
	agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 12/19] selftests/mm: parameterize the mixed-source
 collapse case by source order
Message-ID: <ap6-0z4pmy3p1gKs@thinkstation>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-13-kirill@shutemov.name>
 <178721523517.2799959.8628888160176030191.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178721523517.2799959.8628888160176030191.b4-review@b4>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7dqdsc1u7c9db6bufnnr6pihs81xineg
X-Rspamd-Queue-Id: 8E78A180014
X-HE-Tag: 1788788455-819102
X-HE-Meta: U2FsdGVkX19Da2sBtJEPUYioj19glMbDjYOC49rnRzpQt0m4eLkWfJ1KjH1LuAwUYoex71UkjZa6LimpSAEFGNTj2zfNMH+wXbUHZaWZwo1a5mZKKfmTLOrXOaYr3j6J+TMjacOMsBOHAaexfXOJUJc3GS0KjbOi9+4yXS53FyDbtiIMVXhWykkEpJHk3+iCy6n+R9GKzp3OHQui+l5zCQOeUz5GphzjmL2e/nMO/YubkxRe9Ypz+PzKI42ChNKtJTGYn5I8YbxtsAOvA9JHBkGGWTRalzxtHv2ZQM/9I5hY2H5MpMtmdj5e/ZPsRZQ+bbeMoRo64ZlYbGYS8YP2nxN0Q/Lf/3jvfjmVEqsJWk9PovPf2QqqUSptB3n5+bNpRzjz2+jnhFGvCGFV8HmqOeB8d68jno9rTu4hp399YFDOpQJGMNYQ5bROIx9ZYDtSZGom+wua+Xv5wN0sPdS2rDay0buEGSaSBiChku4ZHpnmxlFe8QZarVRGUOVWP/z64Qz266Ha4EItIHlKaOCmtBpAr5Ksssl3lPkPl1zrXxGAFSrzmSHohTWzARCjKpf9Vy2SmtLA0eQjU5j0D5/PdUDfS4pgIDC6Ven0nftZEjx3ZJ/+/Lkbz3A+8DRyAC3vmqiuQLq8hpHhpJNPYZwmt58ekNXXarDxAQo3AzHtekXZjYJXL1h5VvYPcKSD/UExSDnlxq40I/3+mZecPqzj9MqN+ZR3nxtSAqGFPz90dbwntw9Ru9dojHxhjpJzDPJmOCLv9+zTfwfwqHxDXBmCCHiM/Zf2Mo7MmKtw6CCQ1TE185A0IaZ1qbf8x2+k9bsrdLYsshuuYbmuc7hcK1jN09gcXt/oZlShqbvd6zkRj0S6dYYKnb/njCZB32tcSloCeIoi3mUJaNqTzND/YgtscKt2KGjRBY5wzPWFq/k/y/ClAQqZ3pz9//pYBeORXiIHXnBswl6AtHry/P+0iAB
 4VreywUX
 +ekeJKLK85l2gjE76du/imEGzPAm23m9hqfdnYmawSRTc1JgDuXPzqLTl4E5ybYNuKJhk15dXajrSDG7aLIXZm/kR2dgaNZEiQAK5tnsgAdEQmIGiC+00hWTouKc1rtJ0B0EH5xhrna6siaPvRdWb/sIp5lef9+znQ3XcfduU8tcq4u4Laz0dxDrjnlrFtzxSVs1P2b00Xpo2AgzjE9Um2LJ9o7BcN3c1pEHQ2gf12ORKRhMDFuf7V0C2rpEZ+g33ow3qGfNNtxSv/7BL/0VjkfXIGGIIpXd+TLSyKmCGJxzEn5LaQyqIiFPPoF+E9jbiCr6ThWhp7WHHEuvu5eYW4uqG8onzLOHV5cpml7jnpy4uHdSo94Qf6gdjdjRUC5JLvPx57NVFiRwxZzgHQyRKsQmc4g5mODTfFblH9bvhZrM85Ly92RaO7BBcsJe2KOf1RGAK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 11:40:35AM +0300, Mike Rapoport wrote:
> > collapse_order_mixed_sources() faults its region as order-2 folios and
> > collapses them to the -c target.  Order 2 sits below the contpte threshold
> > on both arm64 page-size configurations, so nothing in this suite unfolds a
> > contpte source on purpose.
> > 
> > Let -s name the source order alongside -c.  The case then faults at that
> > order, keeping order 2 when -s is absent, and the source order has to be a
> > supported mTHP order below the target.  The other mTHP cases are
> > unaffected: mthp_push_target_order() enables only the target order.
> > 
> > "-s 5 -c 7" on arm64/64K then collapses contpte-mapped sources into a
> > larger mTHP.
> 
> I'd fold it into the previous patch.

I would rather not mix new test cases with changes to how the test is
driven.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

