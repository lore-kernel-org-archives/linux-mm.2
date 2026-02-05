Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8E05EA7960
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 04:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035666B0092; Wed,  4 Feb 2026 23:21:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24F76B0093; Wed,  4 Feb 2026 23:21:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4E5B6B0096; Wed,  4 Feb 2026 23:21:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D27076B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 23:21:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FB491403A8
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:21:09 +0000 (UTC)
X-FDA: 84409103058.16.4DC70C2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id BB6CAA0009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:21:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Wz8AMAVV;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770265267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y2tFEy3z3glBmjFywqTGELnuWPy3lvOOwfDR8W9dcTw=;
	b=rDq7tWnd/Ho7drm6YSBcUR5HRFn29MgY4LlzRj5DOlkY5MFY4ty8nX9gL76h17gOZzBMcy
	1m8mqVn5kB6KRDmE61cJhsQVOftmJgYDH5wD+G5PhmomAwyKbzv0gEJasgCkyHpc/wIPQu
	O9vHVwgYePQ1SEphaNjBxHp7toFPBTY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Wz8AMAVV;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770265267; a=rsa-sha256;
	cv=none;
	b=6Nceg4jjheVzsD8/nulyqlPzt7Yw/mRdSgXdZgOhvRcAvPjY5occgMtV64xm4vGxAJuErt
	V6ukBtRXzvszGI1slimXZqXPnB3CmgavHMRW1azacckWuk8AHUOVZCVfzzbnCgnmHIMFam
	bqqhRhFqLS5N0nwy5+Cgz8M/sSp25p8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=y2tFEy3z3glBmjFywqTGELnuWPy3lvOOwfDR8W9dcTw=; b=Wz8AMAVVSNNLNqMIjRrrgRRYmA
	xyM9MF7p6Blv4bmZnyJPelp819CHCr2YnrFkAdPOUb72bQLqnUTRGXwyw/8CGYKrF7WwyfyTLTdNa
	5uRDa1yXzXsJR+vwVwrWUjqciKDT5bY8lq5Svdo58Bl0qR5YtVNMuk/Y7TBwMp9+DeClRbQybjrW4
	2Lh3rpoyCrYDgDmTChM0D0mQSg4U1PyTeEPXLzoBnWMsuMlinMd+W+Kk+skKIhAh3oIbCbxl4h9H1
	Ym+LT/bf3KWRi6d3xbwDKAFMcK289DjMNTTdiCpo8Lr2dUL/q37LBl9KuOBVMipa2DRv5L1h05AtN
	HwWxAgNA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vnqrX-000000035fD-3V2K;
	Thu, 05 Feb 2026 04:21:03 +0000
Date: Thu, 5 Feb 2026 04:21:03 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Kiryl Shutsemau <kas@kernel.org>,
	lorenzo.stoakes@oracle.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
	baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
	vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC 01/12] mm: add PUD THP ptdesc and rmap support
Message-ID: <aYQar8YiejRNCqE4@casper.infradead.org>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-2-usamaarif642@gmail.com>
 <aYB75cWO2nnTx2ch@thinkstation>
 <63D23D5F-AF35-4199-B52E-DFFC16DFDF91@nvidia.com>
 <05d5918f-b61b-4091-b8c6-20eebfffc3c4@gmail.com>
 <aYQZzw8kJFsy1mMW@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYQZzw8kJFsy1mMW@casper.infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BB6CAA0009
X-Stat-Signature: o7yc76dsn6o6i7p8iz59us8saqcz5y5j
X-Rspam-User: 
X-HE-Tag: 1770265267-388010
X-HE-Meta: U2FsdGVkX18jcYpg4I+RmyWkhbxYOPbcXsRChUUlEu9Jk+LR1umgp03PK86sHp7H759QkYX0Fppv612hKRXnQa7/F2nee2gtuBBHr+M7orLPYEq9XoNghCvjERgB8sTvp0JY5XpMovZnDICkjN8mIlQ6JPTMfFflyjToqkQbmC3Z7q3H2Kgpjlvf7wn+POMCfTCmjjY5+M0XAdX4EpwuyuInmilOJnh9H42umqsUifEMeIxQggqKEvxFwZ9YlZua1cM12m789huysJaEFwJxkoacVjs+q3gfeB6piPN3MUm19om45QhlNKTlJeV7aUV5PPVmH36EjKEju1rWl0XK7rQb/u2vSewYy3/QUCNjJzQcuZuSoKg9E661deySbnbRLD9FKFg5jjrUvKxpISBMcPmxZwvWFkq0gUSwqEoj77NlC9NGqFyTJLD7UnUk8Na9adb7+O5t+lx5dw4Rc4ibiacXmu/yekJ3t/FxYRK1VQwQEQVDJRsDZ6RHPTECPRxKkZvSvr6HJC4se1zz5WOttXlwRcnvwVU0l6bKVeD34+qI1Xkq6l543Jo2AXq7d1EehATlkgwswM8RJUHfG5b4ibgzXWRjoYgwlNPotut4s9LpCLAwsZfeQbJPGv3/gPGY9WROODMHB8rJcAB6jZ9PGSaT0GsuBoNF2FL92JYTUEsEOPgwAQEZ/2/lk4dZZmp9762UZRwxQyO0WsZ8zBk9EUVbCH0Yt0lSq/2kiiqkC45B3JPreEEwsSlQfrPe4KynWEoNiYK5ltjirRo2Wn6VSY3hIZzO2M2L2KyJXrD/uqxkyEpaSc91Uv5FicYARYMFjL0JX3Qm2vnuh4tqpYEtBH7SEWxCP/fNTNgaf0ZMFUlcfp8jE/KhPKrHnu3jFZw0820T5z2n+ZYHjWLghuMuKfKe0JT0NDUiG1+m4AwCHLqQTzVfaLzDYekeDA1m+s9xKW0rXkPUxtzdzzru1At
 13A7zpg7
 ysGCeet5rsmqjCNqigzKLyJpZzl/iIo6rVvdYKrPtudvATN/2KF3fg4yOSTbyedAKhWwhHEw0tzPie20m7D/micF6HlNjK16QmlWzuNGsqx7kSTlp0XzVFKQxNcSCPbLozG8qL4K0jKzM16pf/SpX77ATrGTv2jAJYTasnaObaaDm4yJyxJOTrhV2JZtT5T3fKi8bTvgRDkfIIMqlrYDLPUwG0jcT+dV1PJtO5T/ICtdN8FqpBpcDm4Y/Q8NLdj8jiwDA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 04:17:19AM +0000, Matthew Wilcox wrote:
> Why are you even talking about "the next series"?  The approach is
> wrong.  You need to put this POC aside and solve the problems that
> you've bypassed to create this POC.

... and gmail is rejecting this email as being spam.  You need to stop
using gmail for kernel deveopment work.

