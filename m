Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4EEF606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XXI+cwHr
Received: by kanga.kvack.org (Postfix)
	id 9A0006B00EF; Tue, 17 Nov 2026 00:59:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9511A6B05B0; Tue, 17 Nov 2026 00:59:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8672C6B05B1; Tue, 17 Nov 2026 00:59:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 659706B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:59:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D99C8A0341
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:59:33 +0000 (UTC)
X-FDA: 85443559026.03.00313F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 223AD1A0002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:59:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XXI+cwHr;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794895172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5ds16V7HJoVCC6BTho835T+M7m7js7wzvD07D0ZXls=;
	b=Cve3nJEX4cKDfCtFyQ1a4tszVrGEiWj3B4AfKspk8iiXsrCCs7HGNNisuFhD34HRvKuXsM
	AJAej18vmpdogI8EO0zzq3zSaimWqfkVjlCKENYR5K5iPmToKBdHRpbe3iSE6rOCAg/6c1
	n/tUKEktgfRnKiNtSuOU7bfmrmF+ixQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794895172;
	b=TZLGCQFIWeUYUSPVSaVXht39LvJKYiSGAC+z+rtwxe5ITMPhcctB53dpPL1GH4uJIjB86t
	DfpghDIklegwSlGyc32GVRolI/vrK1e6ShGxNvwLjxW4IvjRaomXfUfYgMBhzXyCwxmcCP
	B7mf1iIm0FB5MqecNOboE521joELbaw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XXI+cwHr;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED004457D2;
	Tue, 17 Nov 2026 05:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E161F000C4;
	Tue, 17 Nov 2026 05:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794895170;
	bh=P5ds16V7HJoVCC6BTho835T+M7m7js7wzvD07D0ZXls=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XXI+cwHram8ZPzedqsb/euzHsl5kiqz+fssZSraePwGYIRAA/D1nWXwlXhCgVDRwH
	 Bqpl/3jkaXKh48w27I0moNPJDykWuWTRS5IApq0ghJoKTcl6/YOKSiU3FEld91TeZf
	 EaJFNROcTljpKL7ptXpCd/u6yw/vsGkDaRIMFzH4=
Date: Mon, 16 Nov 2026 21:59:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: cxg <evers_chen@163.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Shuah Khan
 <shuah@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 chenxionggui@lanxincomputing.com
Subject: Re: [PATCH] selftests/mm: Handle implicit read permissions in
 madv_populate
Message-Id: <20261116215930.f257ed2f010b4a4e9fdca410@linux-foundation.org>
In-Reply-To: <206b5151-c527-4b7b-8694-dd9c6cfd916f@163.com>
References: <20261112031811.56500-1-evers_chen@163.com>
	<64e1c24f-08fb-437e-80c1-e5b486d15200@kernel.org>
	<206b5151-c527-4b7b-8694-dd9c6cfd916f@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 223AD1A0002
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: unkz9o64f53915j4uswgiz4xqfji3drj
X-Rspam-User: 
X-HE-Tag: 1794895171-487397
X-HE-Meta: U2FsdGVkX1+o8kgFvQX6+/XrPK5SFt9o0zldwVTG0O/QtYbRP0OwCsSJRGSEXz3ueO5S3jcVDVI3pnmyXeg1fDtASi9xb/qkukz8ZiKAslOdPiyUak2cxbmyTAiePRBo3OkWOLIcgQ96Rlh9rjzCiUiFc9on+gyoYrlvBH8y6utDda1j+H8KRx8ABgjHswAj9t3t7YB8JbqQvOrVKeqWip0qRBha5Rvmsx0LhX3eOmCgQJx7zdQRPeGTb3ZvUy8wIeJNMrBbjbjM8azePyVsTn1IaGll4jqUTUXVTin/WzJXCogFEYU4fBDRyESyciPadkLhLptQTLBK7K2XVkjwl6NCxLek5/lp89Z+yDcRe23j+IwNXTO3BgR//iG9xo42dRnlhsbJxbtFAKqI+QEkkcZEO/j1M5kkFTMvT40JQRQqhKFfiEQEOHEKB8lyyhP0GLePvpxn6R7rzlyWp0wEDPRztap6W6gd/a0dC45AaNWTmAW85VMZIYFCE6+OFw6ECx6mpN9haQiYSyhW7A+BK574AMTiqdVrMUux16Dq/PaylHipi8LD2+d3tevoti3f3bOGjxNzcLjH78mmaDTzo/YuA6QbUdfLm15rhzGhKzBR/ecu/QRBfadzoBumxGxamv6LMXmsbP6nbw0eJQvQlO1Xz70SmBYtMd1HYKx3YDdo7n8jqFazGqikj6VJcbClpMdQUErYdvWefAk3htzWdfXJ6rTPYnvnlrWxWDFahaSplew1yg6M6WEWunBjdhlPocLV0m01w5eGUqaiTCfGs5Iy9iO0l+tK9t7M8w3kGrF2Rsu4QFkXVrrcStRxCq4BfAYoPT7QWvWbPML974atjt0lFInALbLhqhZsQQ3M7VFQw+yE4pDYF3EyKzA+HK/6WgZaA+C3S85YMUrfiT1F6upLzyXkCBmPOhi4nO5wKdDk+J9xD3/uW7/gtK2IOvGBzfduo6CYoifKS0e4hBK
 viZV5lYL
 zSCObVwW0/RAfASEUHKwLQVrOMlUcZKY7E6xn1Ax5jTiqXEEOWuRNF19IuW8iJH0UntW8gcfgjCoDzYMR72SGsEjBrjNEQoKyCrsBUcC+SAQh3OMmD2MNNFW+d06OFUE4/qiGxAh9+EoH8x93ebabSQNzdYvzVf67XBhY3J4oyHW1iIzVvvM0V//4hlChRgiadzohEFLVbkSkRrTRqTfilB3w3b8rNcejgygeVpbNjJOW1rFL4l8DaRagmP5DtSHfRoXId8g5KG5wVno8elqAwHsXWSIAlEiwgUFe86NlnS9ZVj5fm3OoRPU/HDyEVqtaYPJe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 15:00:56 +0800 cxg <evers_chen@163.com> wrote:

> Thanks for the suggestion.
> 
> Agreed. Since this behavior is specific to RISC-V, a simple 
> architecture-specific check is sufficient.
> 
> I've simplified the patch to use |#ifdef __riscv|in |test_prot_write()|, 
> removing the |/proc/self/maps|parsing and the additional PROT_NONE test.
> 
> The updated test passes all 16 tests on RISC-V with Linux 7.2.0.
> 
> Since the original patch is already in Andrew's mm tree, would you 
> prefer a v2 or an incremental fix?

A v2, please.

