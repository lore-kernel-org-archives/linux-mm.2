Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A89ADCC6B2A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7EA6B008A; Wed, 14 Oct 2026 09:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741096B008C; Wed, 14 Oct 2026 09:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657CA6B0092; Wed, 14 Oct 2026 09:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41D296B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:03:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFC51C0558
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:03:10 +0000 (UTC)
X-FDA: 85321247340.21.F4907E9
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf30.hostedemail.com (Postfix) with ESMTP id C87678001C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:03:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf30.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791982989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iin1sIXMTAV2H+wRnzOVuAnJE9D4MJ8lBRCW+3XOhE8=;
	b=snEvaA2+lRguVhwLIw70arrerm3oolv+y39nqphe5/uzyytwlHYWPs7k1lJMyzNe/BHee/
	ss/olnY61MunyNeu9UUhJ7tx7q8jWHLjt5KJwafOlaTpcGn3ANNcNkGUyoXPrkQ8cATwQq
	jo6Uk3hgciBoF6NK3AAwWwTqR1kqFis=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf30.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791982989;
	b=uOoJoqAwlbTRVKvQZRQqi6j8vOalM+ZKVR0lLpIVNF7vzdJy2s9xaIb1JaGkdekXuAU5E8
	HB/kVbcc28vj/k9S3NG/G+apqB7LvfxFLti9BWPFsnwhI5bkbO2GhFCUT8TyXb8gcyoMqr
	zJFHdX/Lo6h4HMfE084CxQiDuwiP2to=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8FF64227A88; Wed, 14 Oct 2026 15:03:02 +0200 (CEST)
Date: Wed, 14 Oct 2026 15:03:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Harry Yoo <harry@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@gentwo.org>, Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>,
	vitaly.vul@partner.samsung.com
Subject: Re: [PATCH] mempool: optimize mempool resizing
Message-ID: <20261014130301.GC15407@lst.de>
References: <20261013091408.1231786-1-vitaly.wool@konsulko.se> <20261014084528.1280968-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014084528.1280968-1-vitaly.wool@konsulko.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C87678001C
X-Rspam-User: 
X-Stat-Signature: e7hqd7stgwk9sub1r5mx6jaxeku615qd
X-HE-Tag: 1791982988-991648
X-HE-Meta: U2FsdGVkX1++BNMOh2+SBhx4rUbD63mfFcerdwuyMYzqr4DsW5OSCANjWF35lSdlRUReQdvQ/HfQCn2qwInVOnWpS43SXY5OMGyLC4U1nwz+syea42YKDhIj7fDMB+aSKF9Jf+CqAE4oZgqpZJF691+tqavCz9yHXQKtBvBjnsNAPQRwp74nu+l/DZ31Y9V70avekXwqWh/iM7TNz91eyiwc/DDhQ0EjPZvM9KJYSePGhgExRV1FgWWiEFnQ7cYuul7lo0n4dnIVx9jI1sgTd9USeNJzAoV2hi2nrJlwXfVcVgJ0wfcvQ6dicyo44ny3HQDqLbKf9LCAK5twNm7hr1CciovOCh8X0m0y4J+4TKEM1iEopmocrEVhL8VmTr1ildBEDX9owyaoI7YPNwrqmbzXwlRI/BgNQS7ckBe50jM79SNU2WCcvUcdsComojNLi3z934M9hVHCtTQipljsF1c6N8UVjuVPYL2ZJZ7oN2LzATte4iqQRoKny6Qxxx1dcd+L48TgPwg5wsBr0AtJFWe8INbgjgEYFeFgS+mFR9SMBYJiixCdnhbaptyYGqujJT2ytr8taG+wvQqTNStm/AFSeFQCiEBW2vcwqWwDMzGc4IWYcfPlK1Q8iHwCTmxRhXJy7p1uJBFDm/wcom3x43mOfwjwk7/FLxr4F1aLeD5Lg1FoTPECtV2XCvb8VpK1EvNBqjUBPdNvkSTfd+pqzSV2UlIS85hw3eOPmJzUd/JbI61q/32XVWJmtZK1+8eNF8Wqz8xgSO5PwQO2aUAN40d45zFJx3ek858Q4CxsdFizamYSWyxL0ZyWTFT960YtHcjt/94X40DVHXuSID1tuXf0HzvzepeJIzMk0YETtiOGcWaLzw0MNTD+o0k6wjHEMrbLeUUGwH/3Qwyuy0J/WNkOAGdWXh93o0ySwukzgGWZjBAclxEfiza0Iii2xIDsM24N2xMWF0NHWJrL/gI
 lPWfOzI3
 WvFS5/r6PYUQeKpXZ/FOfczO1krvkZkI6sQlAuE5hW2myhqLptIUFbAQFzcepdpTygYxxV1NTHrjb77HCcz+dCBE1f2fe0zgdly5SekswKfiYBoL5UCbqVuqcdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 10:45:28AM +0200, Vitaly Wool wrote:
> We are using mempool to store a large set of preallocated rather big buffers. In case
> of memory pressure we'd call mempool_resize() (via shrinker callbacks) to reduce the
> amount of memory occupied by that set, and when the situation stabilizes, we'd go back
> to the original set again.
> 
> Imagine you have a mempool with 10000 elements, and you have to reduce it to 3000. Then
> if you at some point want to go back to 10000, you'll end up reallocating the elements

Who is "we" and where is the code?  This is a highly unusual, not to
say most like broken usage of mempools.  If you need changes to support
such a use case you should include a link to the intree user (or bundle
it with the submission of the new code).


