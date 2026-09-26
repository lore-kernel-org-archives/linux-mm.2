Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9B97C98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 22:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495E06B0088; Sat, 26 Sep 2026 18:38:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446856B008A; Sat, 26 Sep 2026 18:38:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B9B6B008C; Sat, 26 Sep 2026 18:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 151736B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:38:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75162A70F2
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:38:11 +0000 (UTC)
X-FDA: 85257377982.15.274268D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A7A7520006
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:38:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K51HL0i0;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790462289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bFxyzzyXqj3aj03Ubo6Jx6MSJUth26bSWFFY7KZup0=;
	b=gEgVUJZKikvQMogyaP2kbmGaJHiN8BwXbCupNa3r0UjkbF2LKNrOt+o7PjUbpOR4VftPN6
	LpamcxX8yj13xTfhR7a1B+UVJ+QlAs6aEXYHNaol45MYzZ/p+n/cswFW1cTtVAuCahJKAy
	oId/qDJo4P/ElI35MqdAmoja+VG/Rsk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790462289;
	b=KoJI+LzT07v+iQdsXvDn+OYIDfj5EJV/kwhrxY6miMF4ZJFhdSBcQqCM3YcrZaV5YzEz1n
	1+WOhQCSyZx9IG23eJ95s4/236e4Tjoo/tWNOvRdhyoS11gpWq8u3PLmWtWC4Y1aggq+q0
	/YZxRsYU22ltlWuTRD2KNmPCrIWzLCs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K51HL0i0;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D245B600D1;
	Sat, 26 Sep 2026 22:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA1C1F000FF;
	Sat, 26 Sep 2026 22:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790462288;
	bh=0bFxyzzyXqj3aj03Ubo6Jx6MSJUth26bSWFFY7KZup0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=K51HL0i043qp5GObk1DG54ddTyC//ZM9QVrL+Qtz7CUaxxCQO0dgY4vT6dtLv5153
	 u+n4V2T24bfkI+yIcmrCc0Bst7G5QYiP/+lROESaPbwrBlkNkYPQumUgOwWCn3xfdO
	 Cbe4aI8QB0Cw+2O100cCoJY1xo/gaCJmoUERKEQk=
Date: Sat, 26 Sep 2026 15:38:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [patch v4] mm: vmstat_kunit: add synthetic benchmark for vm
 stats
Message-Id: <20260926153807.ec8a4ea8cb362e4f583cc9b4@linux-foundation.org>
In-Reply-To: <cfc1edae-8aaa-8fd0-95de-af3d4774c6dd@google.com>
References: <cfc1edae-8aaa-8fd0-95de-af3d4774c6dd@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A7A7520006
X-Stat-Signature: ej4q4jw376gmqh6fnwrnsf6zxuizwr4n
X-Rspam-User: 
X-HE-Tag: 1790462289-260651
X-HE-Meta: U2FsdGVkX1+4BOGTAU4XMBVvjqytJQrJg2MtTBjdtvJFrzCc+itcXmq7EYnBmt9UmEv3x/vvvHJW7TbUSg+qY43+kH9vUnJYmfNpJDHgJGjlw36/QaGWG/R6k+KwUL8GxrODdDA49stMF1vUoBCBFKQSxIh/bbCOVzYQe59dZtclJ42QVQ+1Qc/IbjzCmjaYkc+G11iYa98Pi2Jq2AT1lKcjX6OymcFLFjPKSSrK5oo0FZipelNltAHgFk+6gLPlJvbwlONUV58Ld2cvt6KTMcju9Wpg7l4QXK5qK2HInmp4VxaDDBBxoRJXXD0bI9eYlMFqtwO1G12oKQzvrYPmWpo1u0tfnsIkCpwWGDZY1P1SU/eCdemjSNH7+TqXrcdmmHlX+svkE+Is6xU+nZHCJSjOCkZ3ra0ndA3eB8DIAXnz2rUfy3EVnrmNgUkL0mtFz4RsEdNdDCBk4kUpyI+unQRM1ZUjPBL4YyfEhgGLTuqzmQrL4jrtYAFD3Y7CGQNU8WaxgGjNE/wxfgPpiS1PCuIFry5YgPKzU8tEgrdQVf/aCm4eCX1I6wKAgksn1tf5H1In3I8QEqdbhzVtoAK8rvNI8okiUJvsSconz9K+GxPnK4t7pPmrCoMWneXzKaem9zAXAmTwIpUU0y1o9DrdTNeowlvnZF2ZfZIVfVR1olWptEDKWKCsizp47rpHghdUwI2nTX0SaOqyqCCYc00Q0Kxlc2+c7PEx5eyXz8/C1NdN3/u4TbCIkt3I56ptWamPhN2eNDDNOrAtM51U24SsdrHdFrwYeeVc+pm8HJoOaLPyslHYe0kKSy0tpWyEsEcyaAIVOUcBU4zd2mr3W1ZTSh1Ozs7GUoXh1QsffY3c296w50ZK0zSB0+0VFkjkBTESCEdq6KCIy0uyZBZbjMJqIaTjGjHwSMgtzgQT21FOC8WtpNofY2A5ZZzlMQcoj7vE6HJLJMt/gshLwD2A8/Q
 CSQIpxMv
 LTSxazb4zkHCj//o3hhIoGJBt/r6zHQlokTPvZqIu09sV/huJ7tQpxBRiCX1TDj7pxJNaNxGEEzNa9XitmzEjlV06JUytcoXxVpHl9H5veFUbKD6/mG4yyKjFcDqy1mabwgXE9FFrxgJ63Z0dRjbdaJtyedOIP4Ht0ZtkcS2FlPcZpprOI9I0GDFDQ4NikV+v991rsgE08x8ITSMszda9UC36QnO9jskDoPhDj3dt9hokUoKpToH/jzRlCm2AON5cLRucEBEMyIXGN/MVdQBMwtZ5uVycE9Q9f+fKU5nzpiWc8ygYReBmD4DuxR5GNfA+M7BGcP3OUWxCCTDIk5wprSuyPDKOn2aS+G1hadMVoWqf1FWDYYeBdoKK0Zzxf/z4+cnzPhBG7FNLdhgaBpvLyT4rJG1sp0eguQfK1RyPGEU03/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 13:39:52 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> From: Christoph Lameter <cl@gentwo.org>
> 
> Add a synthetic benchmark that can be used to measure performance of VM
> statistics.  This is used to analyze any improvements or regressions in
> functions that are frequently used in hot code paths.
> 
> The test is run by KUnit or doing modprobe vmstat_kunit directly.
> 
> Sample output:
>  KTAP version 1
>  1..1
>  KTAP version 1
>  # Subtest: vmstat
>  # module: vmstat_kunit
>       1..3
>       # vmstat_test_inc_dec_zone_page_state: 10000 ops: inc_zone_page_state -> 8 cycles (4 ns/op), dec_zone_page_state -> 9 cycles (4 ns/op)
>       ok 1 vmstat_test_inc_dec_zone_page_state
>       # vmstat_test_interleaved_zone_page_state: 10000 ops: inc/dec pair -> 17 cycles (8 ns/op)
>       ok 2 vmstat_test_interleaved_zone_page_state
>       # vmstat_test_count_vm_event: 10000 ops: count_vm_event -> 4 cycles (2 ns/op)
>       ok 3 vmstat_test_count_vm_event
>  # vmstat: pass:3 fail:0 skip:0 total:3
>  # Totals: pass:3 fail:0 skip:0 total:3
>  ok 1 vmstat

This hasn't generated a lot of interest.

Can you better explain the value?  How do you anticipate that people
use this?  What value does it offer?  Sell it to us!

People could use it across kernel versions to detect performance
regressions/improvements.  "kernel test robot" appears to already be
set up to track this (eg,
https://lore.kernel.org/202609230824.7a9189aa-lkp@intel.com).  Do you
anticipate that this module will be wired into such projects?

Other than that, it seems it's mainly a developer-centric thing?  An
individual developer could use it to verify that a proposed vmstat
change doesn't slow things down, or that it does speed things up, if
that was the intent.

Will google use this internally, or will they do so?  If so, how?


