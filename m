Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 751091099B58
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 01:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E136B00CC; Fri, 20 Mar 2026 21:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834F76B00CD; Fri, 20 Mar 2026 21:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772826B00D3; Fri, 20 Mar 2026 21:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 685D16B00CC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:16:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1D6BB9B1F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:16:08 +0000 (UTC)
X-FDA: 84568304016.09.32D1255
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2F9D31A0002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:16:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zP5Pl6mI;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774055767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJZKnVkaccFV12UVDk/YFRRNm2HtvR9A12GJBWTZLv8=;
	b=fL2+Tgn1VhqUcPDigmfbhpgLusybqWz8sQlV5vjZktv6505f69TTh2LYbnhAgqrac2xN1D
	4A3NZQx7cGwaJXsRDtVtsoRf630YZx12empMGOPdzTqHu0el40p0j7s5nAqS1ev7hmR2MW
	Vv2vUv2BYJ09X8CCiQ0P8lrG32rtG14=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774055767; a=rsa-sha256;
	cv=none;
	b=nwEzaa90GYMo6wppFjNJ5IaZv2qviDCGJDYi+5zcqumEVV+PHLr1uMf/x37Tg6LBWOP3QJ
	uXEf/XVOHXj4fTYE8d0Fmnx4DAhViNgYTT2jo9CD97eO7ROnVdMcXMNCmTD6KPJmSdEPkk
	3j9P6salHxV4WaRx+lnpI1oY4PLq2t4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zP5Pl6mI;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A1A060126;
	Sat, 21 Mar 2026 01:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A722CC4CEF7;
	Sat, 21 Mar 2026 01:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774055766;
	bh=CjNrAlHfSI/kjoViNVqQpDkjW1bNshpQDZf8Glk2/PQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zP5Pl6mIQtnUFVdxCSnS62RGX/oVqA081EVfgKz33z6aMaUO3qa7SHUZ9Uw++glBL
	 IvuVsVl55hD486VsU/shY7mEFWYXXGmUJ3dVBCZpwouLr1CDX5HvAsO2cg28Vw9uvG
	 PhGvz77Gobd/bpfu3lkArjYxXuWmB4pkswP1eRDA=
Date: Fri, 20 Mar 2026 18:16:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo
 <tj@kernel.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Shuah
 Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 James Houghton <jthoughton@google.com>, Sebastian Chlad
 <sebastianchlad@gmail.com>, Guopeng Zhang <zhangguopeng@kylinos.cn>, Li
 Wang <liwan@redhat.com>
Subject: Re: [PATCH v2 0/7] selftests: memcg: Fix test_memcontrol test
 failures with large page sizes
Message-Id: <20260320181605.206f5453d2bdac49ff6b4742@linux-foundation.org>
In-Reply-To: <20260320204241.1613861-1-longman@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F9D31A0002
X-Stat-Signature: rh745s3gguonxozd51gzaob4tonwjh7q
X-HE-Tag: 1774055767-66592
X-HE-Meta: U2FsdGVkX180wSfdrhPkZrPx+SRoFjuyJs4BXatSZoXih3YsaUBkmcBAXKsByOyQl07jEt46qdADC/fN1UZH7mXOObzzifKqSIe2KOchlEq1YQfaEbGISUvmf8aWwBmZMSgrTu6TC8eQthwaJjrzFxH+HrbHMTwYIusy+pY57q/21HCaoQnEXS6OCXD+MEk7dvHUxuehbjX0SbGyzN72t8ll9Q1xrXr6W2CPAv9/tXQkzaD/U6TmNAz5tEIaczqt0XKS60zyTHx0PuTRDJW4ti9FbEuqTsZfSgEo1WFHM6Sa3MjLc2K6C+fo/7C3eCl4Hb+CkQdE9LH4iZxD2aAGGJvfGRMyKpYB7iI567Lp638p30a4QMS7pocEpxsNLUgASOCtvCaZTB+TbMF0Zp0aEe+/Oj5rHNmVFJ9Qtp1KnCw37n40gdCMQGe2MJTKRsvyf7zM/rw7mcymmexRMZ//gDsSzJRmuk/+ONv5Tb2jluWpNqRXVRXHqhI6ihULAmcGp5sw2MdK+6HuQeFLrrAGmUH+szO3nXKscpMSuvK4U6I1h4ysxtZZRMjIEqew4zrl84e8rc81U+wEMyK4xCYu5I7nTTD8cEuFN5ZvcAQqwStPu3Lclg5EOcLRbdKFYoLkn5knr6hRnJffGUr7YhKHjLhRdPAhz9vd1XNHdlOGj5yR3XJxgI6w15zeEqviDEftyIXW62Vcaicsnq2Xzj4qSKrSBwFbbCQ1KCmCk+g4dcbW/kK54a2iJlYxBiZLqq27dWXjRogYEgHAhXnCdVHzqKngmHoHi3Xh8VZsl29BFtNGsChqcbkQ41Yj3m+hl0OzAClqToOCevHM9Rn/I0CsIVhRUDzin2g7gpcfRWHB8s6q7iHT5N+YpolwmskyEKGYvMLVHoaP/cGnsdQyltInRmPxjXW3JANhUgdzbM6evjqqsYsRhC2F8CguL3cE+SAuJjBrzHrGFJ5NetgrZdy
 l0qk/W3I
 qJi2Z8u6th0lfVqwCtSKEPTx7LLM9lt+Cszw6btQS7I5pXEQVjK2nz4ylvfvCxGuPsF+G8vUgQa0bIJWUlsg7oLDP0UzlzIEz1Md7hGk3lFrR4nOcW0jLY3bRd4dQUVRKxwDojRY8beWB2yRc+N/yA9Ks0PJ475VoZE9ajq0/S5aCmlqw/sUi4P/cCGn9bj13/PbzqIIhlOQCITI5ItZ6fQC9JLB1DRoKmQe9YPyFb8vAQwhfdtxzl9juukgSe2D0+tHEi3sOYzgOmPo+dQ3Y7KG+DnTlzS3wP16YGgPXwQXBbkERPFAo37AXKxqY9gAY5IiqJIait32e53eZ+y1c1nIJOxtD3H1bL0r0+lXH7ocSc1OKILf52WgBgKHQM+zeMm+0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 16:42:34 -0400 Waiman Long <longman@redhat.com> wrote:

> There are a number of test failures with the running of the
> test_memcontrol selftest on a 128-core arm64 system on kernels with
> 4k/16k/64k page sizes. This patch series makes some minor changes to
> the kernel and the test_memcontrol selftest to address these failures.
> 
> The first kernel patch scales the memcg vmstats flush threshold
> with int_sqrt() instead of linearly with the total number of CPUs. The
> second kernel patch scale down MEMCG_CHARGE_BATCH with increases in page
> size. These 2 patches help to reduce the discrepancies between the
> reported usage data with the real ones.
> 
> The next 5 test_memcontrol selftest patches adjust the testing code to
> greatly reduce the chance that it will report failure, though some
> occasional failures is still possible.

The AI review is up: https://sashiko.dev/#/patchset/20260320204241.1613861-1-longman@redhat.com

