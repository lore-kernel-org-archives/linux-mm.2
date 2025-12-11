Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F620D3E79C
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 07:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63FC36B0005; Thu, 11 Dec 2025 02:54:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9966B0007; Thu, 11 Dec 2025 02:54:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B8226B0008; Thu, 11 Dec 2025 02:54:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33EE66B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:54:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE5A616074F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:54:52 +0000 (UTC)
X-FDA: 84206428824.28.A840D37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3F8E4140005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:54:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZXiuu9X9;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765439691; a=rsa-sha256;
	cv=none;
	b=va1hdPO8oL5FdSd+pb/s7UU2pkc/OcYcSMrd5d2irmq9EPZ7G/9l5/Q1LF8wRqMhCmfB+Q
	2Hbe8mAl30OTIDLFlsc5rNyJjcsoQZlAUMwP66mkEsCgDa26O6DuPsyhx31vgXpPW8/8H6
	60ZRkXt9w16aZprNZTeWJ4MmBvZd6Oc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765439691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gP3tzCRLJlQuR0TheSY59M+kxNMB91GH81hqaDE9tio=;
	b=HQWWrFC0CjUWR5m6WmkPsjacjQq2XXxU8X9o/a+CPhRkjvBb9nNqOex8glvfdKmVAc1i4S
	vrsuw0ExYXYCmZkfU/SBBNqBZiShJYR+IvW7IBKE/+08bEC1b9fYI8X+Cer2AhN+PwW7dG
	tIIOh3tYWaHONMcuETLBtSMezZHYUJs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZXiuu9X9;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 38D5F60149;
	Thu, 11 Dec 2025 07:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5D0C4CEFB;
	Thu, 11 Dec 2025 07:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765439689;
	bh=EDeluHou9aG+5ofz/75w99Jw9fNkvfk+DkdrB9VQgSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXiuu9X9eSUWidUeB6MH/D30b2w4C3tHcMSJiWyCsV5B4bsl8MFbiq7qr5kIswMnQ
	 ntjDBpcGNPXtCCSQJhHss/StIVv5iETsCB3zT9E5L08DlKZs4AkFNbNKdDEn6HPPCE
	 PMZ8iWbbIzQ/ZGiaASKHStqIgyr/Q/828i9K1NvkUaZWe/etZlJbDK1kG6x6BpcSoD
	 hLlUA4ZkvOzNV+d6Y3iv0xS3katYPXh3bK7YjktIQArnHLxICUuWobMVkginDdnnWQ
	 qz+OjcgnLhNynDp9aZmzIY4TB0LP6SWAw+Err363aZiYT2aYqnjaOOEBK5bQPKvjRp
	 aOnmgfHCLg/fw==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: modified damon_call_control from static to kmalloc
Date: Wed, 10 Dec 2025 23:54:46 -0800
Message-ID: <20251211075446.75355-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC7epLcuK-58kaROWMof9dq3ZCm2WV218KGv7kcDMf7q-Q@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3F8E4140005
X-Stat-Signature: nwos79wsje5rzcp1dxer6ptx71gocwp7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765439691-151581
X-HE-Meta: U2FsdGVkX189iQPIQH3OSAYuxemLtEglxZ90k0cUfkRbK+WHx7NTrgp1vZ01W6tjtdTZuw8pxMH2UwENJOSxdXuIZG22uIGG/7SFeklbHbs0bkyzoBr6sR990O61BYItwcF1Lab2AA46GAXl629gmlJsKWvqPnv3TbIC6BUSPWwaLygsS1oNukxdGYN/DBoNehxhN6j39fCU8FhHMUlQlAyOtAAMHsOZWt6RdMEyrO5kUv3pkZcLTRUtpREMGd37Z3+UGUUpUpo8qR8dNQLwe8ZevjEZ/DUPS9xuBhhYsLLd3Xm1tilVK1SNLsfPEHg/T5bb0u/V/KCCE7L/evqNfCdPLq0caQOt57rzngCjAGFSG81pXS/j1uPRLPkH7nC6DXvSa43cKFFruSDJn0OWv9f2rfCLvWaPQhSCqBWjTwuupvns5gMkd0rdC86aGj7uA739+/xtVa+IHWqCg5KeMF+HL5ip5BzCxU3Ansy5wL6dwbx/IRAG5g2lzav3xILpEiiUU93kHNaE5RdctDYZp90cxXZJ1y+MX8GmNyEKJJ1Gg/NParvzd+E/fPPCUZrHCbclasKDFBnPQ5aLDbBkGgic0WN2nY2zfPc0ahqSR3M4bQqBMt2rCzy/8acMO0GOUlkuN5hmMjoe1h6O3rDWEjz6gV/xr6BOeVwqXuDZhEFARr6sc583zogwgkwqYzXGV2EzYL0hR/DodJkAln2L4jofdhC93QA7n25vL9rlaV9kWjf5GnVKGJPkiddlGgCpQTWFC8FPLZldmwpEJF4nvka1dhguKRQQAxJAUAVJIuNccANbOPoYh9d49ezkjX/0tf2RTvq7otLqvhvJiEUY2BbToYfyV76fK4dY0xQHHz8iu0ss51bFqOMP6uHnFxebmoiEx17hwj31Oj6SDqIEI1EVBZAXEB+UWA+EkloweAnyLQJo4MGJS4eAWMLeDEuWDpEdZiqNjpkeKqvibsp
 p4Xesfoo
 MaaEPTFaw45Gz3qQ4M/nNlNVn2h6o6pWq+68L7mFtodNs0s6OEye+8A7Dz9e36yR/o+6FrSDkRQskVptj3srFR5UPrWPegt83a6DCjdCvkl85Ro1GsUGg33oc78RKJhQdl8J9Y9oQvkZuNe1fhGwK8ugaPhmdkVaP0zNlTQIGmY6AjoXXUrBBchko8WH1rpMi6ur0Ei9RUcHuYVW06MCqk3BDlVCA2rXcZf6V0ZDIcZLeocoZRz29YtPvN1rBKxyhiuzntJZ243AD60o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 16:38:46 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Thu, 11 Dec 2025 at 15:04, SeongJae Park <sj@kernel.org> wrote:
[...]
> > Sounds good.  Would you mind sending a patch for that?
> 
> Would you like me to send you the patch with only the comments corrected?

I was just asking your preferrence, and seems you have no strong one.  I will
do that on my own unless you mind.


Thanks,
SJ

[...]

