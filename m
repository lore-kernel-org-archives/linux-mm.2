Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A937CC6B2E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 04:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E4EE6B0099; Thu, 15 Oct 2026 00:45:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BCF36B009D; Thu, 15 Oct 2026 00:45:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9946B009E; Thu, 15 Oct 2026 00:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77FE46B0099
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:45:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14A3480894
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:45:43 +0000 (UTC)
X-FDA: 85323622566.28.1945CD7
Received: from mta1.migadu.com (out-168.mta1.migadu.com [95.215.58.168])
	by imf15.hostedemail.com (Postfix) with ESMTP id DEEF6A0008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:45:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XaJP8who;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.168 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792039541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3l7QKMJtPhgo403nhvFGNHdmnmQpumBYqoYqI0Fb5q4=;
	b=JzGtPbwFpPj/JSlRXBzsBVJOMASX9zthQDJn0fJylujk3h1mxDwpWLvxwb7w35KJJhKzQX
	JkfoJ2RDAr1vh4ncy1AZPF2wDdbyRA1iM4pdVIAJ7oDWROauZm6jllUh/Z9D8auNvE1htz
	3WptqxgCP8MAXvsucxcfmr2t5lURmQc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XaJP8who;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.168 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792039541;
	b=iq28UpfuP/qQM1CUTRu4ejL+S9fM1piYu4LHMLgIUfwksF7Jixv8HDLZOePyIyu+UGA35g
	/pH2tvqrOgyNSymz3Zi8LmytsKrKBJuXfiFNNXu8KRLC60S14PIAZFBdvWy3Ou9UCaVWin
	2j8ajqtcIjwotZV5H13YDo8hBlbMMsg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Zwdqyn7Po0/V3YhxFxmEYdA8u2MbDZLmE5svy+085sA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792039537; v=1; x=1792644337;
 b=XaJP8whoD8zIwv8Zmxv81EjqP1MRdtt/6QYShjsgwUh6tbednZAbaWz+z4QtAagX7qWHLX9v
 4RQwC4TH0rgaLOOj4KX9nQduvniSzyu3nFUwDY9eiUqnBJftj5g+uGeHb5QA8eIjQOOp8OJsjD4
 n1qxPJSI4qYr2HoPuEe/RB5I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2f3efe6c18917ed9;
	Thu, 15 Oct 2026 04:45:37 +0000
X-Mizu-Trace-ID: 2f3efe6c18917ed9
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kas@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com
Subject: Re: [PATCH v5 6/9] mm/collapse: drop the collapse_possible() wrapper
Date: Thu, 15 Oct 2026 12:45:30 +0800
Message-ID: <20261015044530.58786-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261014171145.3292736-7-kas@kernel.org>
References: <20261014171145.3292736-7-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DEEF6A0008
X-Stat-Signature: nryp9uibkqyej46sryon8f8npxzxiebg
X-HE-Tag: 1792039540-424889
X-HE-Meta: U2FsdGVkX1+AparavkJyuWklFCAKsFM0uEmo6/5vuPrZVNpLc/iXLtanOG7k+JDm3kXfSutMb8y9szrVT4VzP7ELzfR+uX0PTuGblwMB2QwoGwAKAGl0NQj2kyBUoNP0rhx5khiXFFjwveBJz3NdYvRIasYA67eDujMD7p8U+PCDOIA65TCOHuU6S2bCKsrZsUNLdxFtI19583LvA0exYt5LrN/sj/fSF6qnSuMfGmAn8/ZLxD0FD/9DAE8PHEyPg9abvso3j3AeqIp9fbzjyT6JpHSFT/ygjbQSnbFqhk4VCTYrEjCak+ZraM7jPLZY9k30DuRGGnr+P4LVXnv2kBTuMiXWre7Bas6qgJxFalCwvBCcqfpfqUxaWlwZ3soQbOi//CvJQyWoflZUQ7s4mgdLZt4U2l0K0A6gSrm0AD6INzVdvwzPvUEA1ZHxfE/VkQcVfFWedBw/QGDCcg06k4BY8Gx5PFSuKkqTtGmpaJzDjsjZTCtaltRXtomTFJU+mlyGEyspbFYwLDA5YkmV1c7JNvdD4BNsXw2SZZzlOEQTprygqfwKBd5gY7p61g6+RT4Ilw0zH/nIUWvk/Q7pBnQ8VTtkw8KskRH+17lkoiS8Bf69KILR02HnvPC5kVVpDW+69aQKtpGZNxWUeo31wIzuZ40/BrL0PHpBZqC3Cx6Wt7fwSgzHOH0+4CeJPEmG3hGYaNZmwlahzi2ABI0OphvHG5a53BsfC+RUxay7u4Sgj4Cux2gb05BFbD/b6zXOjT63HHQuaCSmmpNkbxLH6xTEYsFheK4ZhNMYc4NB7kzYP2i6JEVBfCMJAXzWimlfN7iqLLJlwEnHfaLkpzKlz/rhFN7BCA+C7p6ki9TrUZPpqWk8HGMuy7FvUjWx6Rc8TvyV49nroIS8meU84xupwvReP8weQKy7wJb7gFQCCsu+O66dv6qBIQDehNMKqqtldNPEC6QiuFhvFmJjDs4
 gb3RP0Vu
 gdpKWppun3MM2xqcr204ltBBf9b1GpHQumRynXbb6vmiuLl8cYumWGwR62C9MO2BeGjIMWEwsM8oV57GMLuRmvpE+KUA3tT0jUF3NzPO6CPSXrbcIsaJ8Benl2em6SLD8ufRvpi0J5fNRX0lGmwxjeRIAKuw1JpyBA3kDWU1J5z4RIG7R9+b7gH01e2fSOPN2bYGT7XkchipDFUK/UcWIAPI+RF0R2e/uRBlSqfbBFQWR+KhgMlaPxn28++9ytrN4/Eo7DybZfMOSXAVMIHC5PBVeJ2XOV/ZzITRuMDD+y2n7unUNRrYTiHYAFn6sAgT6Dz0jenKi1k7vkXOlOKUN9JNGqATvN1lXQAKL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Oct 14, 2026 at 06:11:39PM +0100, Kiryl Shutsemau (Meta) wrote:
>collapse_possible() only forwards to collapse_possible_orders() and turns
>its mask into a bool.  Its three callers can test the mask themselves.
>
>No functional change.
>
>Assisted-by: LLM
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

