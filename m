Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C6A6C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 19:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 439536B0092; Thu, 27 Aug 2026 15:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA866B0095; Thu, 27 Aug 2026 15:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FFFB6B0096; Thu, 27 Aug 2026 15:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7346B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:35:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15988A2EF9
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:34:59 +0000 (UTC)
X-FDA: 85148052318.19.DD0FCB2
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf10.hostedemail.com (Postfix) with ESMTP id 317A2C0004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:34:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=O60MxtkZ;
	dkim=pass header.d=ruivo.org header.s=mail header.b=G9k9m6ZD;
	spf=pass (imf10.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787859297;
	b=B/g+D2G53H3rblUOdt75KZeI9lcAyqONyOti1GRS0FzHc4OS75IwaTiYvsHNQVhlMdekdU
	U9l27/V9ANDUgQ7s1P1UG7LVcs0kG4DCI1O22xXLSapbru3Ht95T8JYQFKjO63aJ9afWeD
	UAQzoaBPXs5vhTcJOhglfzCSgGa81iA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787859297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KF8eG6yL9IPcIRS4KEZ1iIria5ApUC3/ORacVKg7uaE=;
	b=yxqIxhTGxCC2tvnFvEPm4iwYs83r2CMbw0GJtO5WmphQ+L15F6LZ5jOT+sx0dVynCY/Are
	cIpAQO5HNU/EHTzQmg8zfYy8l4PWznn4+k6ovdNDrNGfcELC7YkLUBLIUgvNX/wMJrhSve
	zBXHvR16lUwqB96WaIw5fJqeSE+Kbt0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=O60MxtkZ;
	dkim=pass header.d=ruivo.org header.s=mail header.b=G9k9m6ZD;
	spf=pass (imf10.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1787859296; bh=zY41CuTpk/sIV/nrxvxfCBtHdO3PyEZycqoh9slEt3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O60MxtkZZNjH0Fyo6HZSQBUrVCefrSdclip67e/Z3rCfbkERFNRUvJ07ln2dO9c/U
	 dVPZD0EGhgPI9F0oAkG/kSp5d16NXQ3dW9phvQR1e+qXhCnlPZSnbivS3lxKXSpfM4
	 ZwmU7naVQWcqn9FLbVALSxRUYjDsaqq4qXcXkH48=
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id 8461152844; Thu, 27 Aug 2026 15:34:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1787859286; bh=zY41CuTpk/sIV/nrxvxfCBtHdO3PyEZycqoh9slEt3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G9k9m6ZDNEzB5pVP7m5et5/62ScAXhE0AhsO22+18HuX4AjVNj7tZMe8JjEDQLuW0
	 KI0TEGt1YY7+ss1kNNEwg5m00t2BbuH7gfYSJePa7j4qj9KS6X+yYLiVD68QMC1ADR
	 zzpVKmTRVGdFKUSDh/s28kAj0O3MNqFffWk+o+r0=
Received: from jake.ruivo.org (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id 1526852609;
	Thu, 27 Aug 2026 15:34:46 -0400 (EDT)
Received: by jake.ruivo.org (Postfix, from userid 1000)
	id 06D6115C6A88; Thu, 27 Aug 2026 15:34:46 -0400 (EDT)
Date: Thu, 27 Aug 2026 15:34:46 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2 0/2] mm: gup: cleanup gup_fast call chain
Message-ID: <20260827193446.GO1736962@cathedrallabs.org>
References: <20260805035847.936054733@ruivo.org>
 <dab040ff-e495-4e7f-9932-c60b8299b89f@kernel.org>
 <20260827191042.GN1736962@cathedrallabs.org>
 <02cf0864-9a0e-419c-abdb-361bf32f43be@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02cf0864-9a0e-419c-abdb-361bf32f43be@kernel.org>
User-Agent: Mutt/2.4.0 (2026-06-19)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 317A2C0004
X-Stat-Signature: csyfpojprecy8f3snxjwkcq8bd6nr5ga
X-HE-Tag: 1787859297-957354
X-HE-Meta: U2FsdGVkX18+xnA3tmF1DOwGG3sIVsMVuhqe2hfV+0UV1TR1/WV72mL/ZHDdWpds95ITqqbhDKr/183cNB0huLQnvU6bxsHyG/5bK9wfmv5RyTKtGezCRrIYPjDE4HdygjrPJ9Mo6c4vQX/IOEVEKG0yA9P1g8Bbx5/8CDbBdh3c2h0pnl4U7w027fBolY7vQJIdwEkVdlN1IbyOE+46fIMDH3eVeC4eMo9Q8+nf0lTERrNx2O+FgTNyOSsTY3kkdGFYvndea1G6F3LhedShvYJ64OOaq2jY4hEmcoO2Vm1oD+uXXSw4vWDD1rcKzgEOY/EAHcZ+wbZzBAaut691TZo4GCaR4yjuJPkb7YH3x63tZV2lk7G6VXfjISgJ7S++f3+OVadUN9NsoyIRzBLABp56iRuBifQU7ucEm9XeL8mkVMKhG9QWJw94Gv455a66SxrTBSkshDrdAIo0089GSmsy/3goDmR/RUR18ZPGa40P7ae0X2+aiQAHRfrB9FGcer8CNJK7XBi5sZJCRwkoEBDDtLJtmFBkBNU/oZIDuTucnQW/STLWZWRJgNRy4Q/8Uzh6QzP/hHrmEwT1cOgqrU9sw7l5uXcse9/8W3/DKEXBY45WOGsDrp+y6nKhA/PdkErU+pIKT/KHhPbuePOEM7SLUbG1VYIhgkooRctmMig122T2KIqMxgv4odMXs4lfxtfB4h+pGIQ82uRSorlpXo0E5fCRtYtsH/BY2vhrbQ5zZm4piAE1XrK2zbBzKh5cb9VWwobdEQljV/3tyYiYkJUSUfawyRIYqOK5gby3C338JiIubnWr9srQc9un5MyCEXfIwn0BaAEAuQzEXS4bjBhh8JChgfsnjmAPfYZ/mxqujQh1pKuBtYbW0qPnGFsD0aJcysrZKQTxz13jCj7wKb0NW5Pyl+K1AA3+pkiZvCowp9Wb5Oxf8RgKkC980ioZScZIipcXkv697rNmkE7
 8Lb554pU
 OrG0vINqVsv+e5t9Fq8LdSCKzvvkLjV0+rmahDxwUM64SdD3i0s2UIYsUXNpEOKk8P5xAdcLe50lxPYW5Q0VIv/4a5p0qqW2A3PpB69bB3r+Pkf23kTJ5zyTFCwHP9tSk0gJyuTZ6cPfLtvI09qIFcXH7BX9KUCZVC9nalIXmHd+8Y7BMcJE2Fx8GUK3qgbvJ0fi3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 09:16:54PM +0200, David Hildenbrand (Arm) wrote:
> A resend would be nice, so Andre can pick it up (and somehow sashiko refused to
> review IIUC).

Ok, updated it, rebased. Will run all mm selftests this time then submit.

-- 
Aristeu


