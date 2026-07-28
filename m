Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96FBEC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7852A6B008C; Tue, 28 Jul 2026 09:22:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736546B0093; Tue, 28 Jul 2026 09:22:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673436B00A0; Tue, 28 Jul 2026 09:22:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EACE6B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:22:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 060B01603E8
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:22:15 +0000 (UTC)
X-FDA: 85038249072.30.47EF36E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 278C14000A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:22:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FrPIU76G;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785244934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1sJavEPudU+OUEHx6GFAB0ZMrxFOTjDav1o4MCgxz9c=;
	b=5NVgPEEymUPHs8ka5THlqXBtcH0hMqWX22Y3Cva4Y1OsK12Xr2838g5Z0FigwMzih4KLqM
	Rwm6TCXUgi0VUqlvjt092WJrVylF7nyvWsgn/zPx6NS+JirPG6kYfO8XkdlqQ/qTR0AQGB
	KUuKrFQ8MzrCm4dl8XloYGEyaUvgDNI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FrPIU76G;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785244934;
	b=aKBHXDp1W4Nbdfkj/Jbr+IFfsIp+TO2JypkW4sVVyEEHSipePbd2Tjkc9KMpDsp4dXtrQ0
	O10pjreO9PqcRulFFYTdblAsJJlYzljdgOlQaSaR7iilQvoRb37NMQK0Z9kZy1b3zfY8Is
	fIMG2aEHEGRFaI0C2MQiK9RzaYy+8hU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1sJavEPudU+OUEHx6GFAB0ZMrxFOTjDav1o4MCgxz9c=; b=FrPIU76GLS5DXSBE02ydrmWMJ9
	Pgsno8a+Xt51jt/rM/d32DR8Pjs5vU+CDoRCN8xjNu3e7OYu0QkXevaITuKQU0bkX6jZXVkW+av50
	1cZsY6xw6ytvzYFsRa13dqpgp4E19xOr92mJDmyzyhR6/84UGQ3kL39Tl+J/oqi9GwVucquawcA3+
	Uvyk837KZQ8Gww98DQS1+txFrTxkk5td09vxtvMNfQY72dMfMwN8Jr7KQTOu1Dm58gba4UrEbwD1n
	1uuNXpgFJjJCxZFMijEYUM0K4mIi9mZiSIakuaJajNIp4ULuv1dZtxwFY2CD+/9mDCOQpWWsOSHXj
	LWnespRg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wohkz-0000000DIUA-14sL;
	Tue, 28 Jul 2026 13:22:05 +0000
Date: Tue, 28 Jul 2026 14:22:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	Kairui Song <ryncsn@gmail.com>, Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Chris Arges <carges@cloudflare.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/filemap: __filemap_add_folio() restore index before
 retrying
Message-ID: <amis_VNEmkifOAoI@casper.infradead.org>
References: <562fbfa6-dd6d-0b6a-2461-ed2ff1173bc8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <562fbfa6-dd6d-0b6a-2461-ed2ff1173bc8@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 278C14000A
X-Stat-Signature: kob381a9ngri9euoofhdfrqcyxk1bifs
X-HE-Tag: 1785244933-827395
X-HE-Meta: U2FsdGVkX1/2a7UGUNQB0eHoMnffEdX5XfvXnn+jWriNjC0yXQ0QSTN2uR4jKPv8+WtTAEhUeb2opfi69m2nMJYpbcnN5pcTTRi4FepRLPkWH83qvpl6Xdb22RaI262AUAq5o1K+3+wdsnKtSyCaw+dNHFhkrhE4scIr8VU003/XrywIPLvBD2v038C4b8T7Hr2KgCMeDnURkqEnmzza/tggGD1lh0LccMlErLu2figoOJ9Ee5difpoX+iR9AvZ2WevQphheIhT2U7yKV6ngZYqdpnMqUVE5Sm/KS+UH614CTdFlfrXbUL9xArlWQgd2ya16FXiXpsRvNVUHawJ+noKPgq0zeJp+ecdYIQUKGQgi/3FnnrSrrSWU3YBZBBVPTEbo6n5mAWz7apF6SgPoaJNZc4G7x+z7U9pLQPt4+2Wuo94rvtRCfeJKvOjE1/esKnn0P2ONztwd3Hf7KUhtpksw719OMopqk8+MFWRlM9C5G3rXTKWr8XsLKCTp+M0OVhNtTaQGoiMizdPwOpxEBaiZNYMtxeiSu1kPpIcnFEVUFBVfI98NfxaRLtNP85QNn7qUB/6/S3vyMtyD+2kpF+5Y7+DmnzXUVctS7EeFb01yiIJn5rztD+j8xdFgt1eHhDq8/LJqsxvBWZx2Ks9vdNHhH6su1f+4j6o3cUwm3Tu9fXbrS3HVaP6upoYzfzUEYjy/dzp/Mu3OirN92CN1gsInwGN53yyJrTwhtASM3c4HvPdotueARa/TReNKYdWxA5qbBsQPjX4VAylh1eXpCet/27p4gFQeG02EFVb0flre2qa0tStM6faEdaONZdbwJTZXHc6HSSB5be+u5g4lq9g0P7mEM+tc6HHiiwkAYKp6fASdyUTtSJMi2PqIaheRPOZyOVMe+KqtFHAgWCV/Vnahdj73QEP0klDMt02M/xq7SRwgL27nObs6ZOu8o6zYeAZ9pjcggyVjmBkE4AD
 zqnUJOaB
 HaAw2jMphPkI5DI1BySolilz1qOt25Y2sx7eBsE0/G8aeCo16ESSs5uGEOEzjhY+sRxQvJtKdsz8lrvVgVvSjM13lxt9Yfqg0leQKvP5pOKUnOdDCorBrKd+5WrQDt8KT/nvOr+iAd+kNXquS67pfBn7T1LmXy+h7181leaYl+klNVQZDLBoT6ZvDILiJn6OJb+t2Dq0ZmlEzuyKNm7fwNWAEUUS9AbJupWhzHoVd2559wQ9Km8NgDfJrx1OuFg5KYR8NPJuY3bUqmh45fMN9TCPDmF6u1JwFeEZq8zR6X343J2A2HNh0kGzQZ8ZhtHvW7r8x9yp0tlLYFILD8b9Tf66W975FmFNpldyfaJW3xBXzU2LfEsZzUTumZsvdjuik3JPb4UE8D2iGZtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 10:24:14PM -0700, Hugh Dickins wrote:
> Production was suffering from rare SIGILLs and SIGSEGVs, executable text
> found a page away from where it belonged, !folio_contains() bug hit when
> debug enabled: symptoms not seen since this patch went in.

That can't have been fun to find.  Thanks, Hugh!

> Fixes: 200a89c159a7 ("mm/filemap: use xas_try_split() in __filemap_add_folio()")
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

