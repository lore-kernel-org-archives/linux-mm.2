Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37D95CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 17:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935A58E003F; Fri, 17 Oct 2025 13:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90D6C8E001F; Fri, 17 Oct 2025 13:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A4D8E003F; Fri, 17 Oct 2025 13:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 730338E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:14:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1C2716022A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:14:36 +0000 (UTC)
X-FDA: 84008255352.05.E3BB418
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id E6125C0009
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:14:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=k7QNxodB
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760721275; a=rsa-sha256;
	cv=none;
	b=MynmDlfpe2Vov07lvKQunb1IniHiGzmkA8lT/Qw0fXpeRc52mKBT85RvHDQIoWso5AImpE
	B0UDtkMTbOdv+n46ZcshYrDdENBIgfl8/66l12NNuZAl2Gmbvf29XhbrkPQkj1Z2RNmOmy
	/s8ZijtXx3J1myw0C3foSJbBQb3Q5kw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=k7QNxodB;
	dmarc=none;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760721275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fydJPMy/8eXN/HfxrYX/ccnK/kRSfy8GG0DyRBEqDRQ=;
	b=iIt6GAWleE8EEFkhI9Y7MG8RRf4hMmLPPWUxxjztj7V52G+cT0ktgI380pQTqzYRwqAIsF
	5VeoOo3UJSQ/LmtPxh5t3RhJMynPd69Jco8qwih0LnU3GZTGmDMYbHrNZa7pKRGPaAF3lp
	Nndz2Iskh/ODSeA8aJR5quBaxoEDPIw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fydJPMy/8eXN/HfxrYX/ccnK/kRSfy8GG0DyRBEqDRQ=; b=k7QNxodB8nfdc2ZSfMTg0+DVHw
	vG8HF4WN3F3TEFU6DIoc/7u92XhZcqLWj/S2yTLBo/4tLSrjB7sCcN0DpUOtKtYSg7t3Y2ilkIQzb
	mR5HYxeKefygr+/yAR0hO5BGqWCPfZHn3LEoWWDGLmRBRzRipfpanNhc8D0ydeEFP1asHvMmVtw/Q
	e9dFAFz8JmupuvykpqSXSHtPLRS916xRT+6pGZeUCR0UdjDWcl4kbfNNy58NtE7+2AFRL0atJzNHz
	4i6Iz/rGQTnf0rbMH4GbUWW72rL/rs0Mi1f3HyFwBqTizDygCFAR5DuM7vw0jKI0Q4676fzbvyoZl
	1USTEZoQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9o26-0000000G9ol-0rW2;
	Fri, 17 Oct 2025 17:14:26 +0000
Date: Fri, 17 Oct 2025 18:14:26 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>, Zorro Lang <zlang@redhat.com>,
	akpm@linux-foundation.org, linux-mm <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: Regression in generic/749 with 8k fsblock size on 6.18-rc1
Message-ID: <aPJ5cvOlcjB_H_zk@casper.infradead.org>
References: <20251014175214.GW6188@frogsfrogsfrogs>
 <rymlydtl4fo4k4okciiifsl52vnd7pqs65me6grweotgsxagln@zebgjfr3tuep>
 <20251015175726.GC6188@frogsfrogsfrogs>
 <bknltdsmeiapy37jknsdr2gat277a4ytm5dzj3xrcbjdf3quxm@ej2anj5kqspo>
 <aPFyqwdv1prLXw5I@dread.disaster.area>
 <764hf2tqj56revschjgubi2vbqaewjjs5b6ht7v4et4if5irio@arwintd3pfaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <764hf2tqj56revschjgubi2vbqaewjjs5b6ht7v4et4if5irio@arwintd3pfaf>
X-Stat-Signature: fazwky8fczxuabupgedw7pqam4gcb6r6
X-Rspamd-Queue-Id: E6125C0009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760721274-872683
X-HE-Meta: U2FsdGVkX1988qvsLjdI2EGwVr8feYAkBLjXYZNL7X04Oj05g/u9XIxrm1Wv3jmV0DOZK7DVX+NnZXizebc3kIszMq0gvBFNAm2hf4HZ+LoXVPKGOqTX7tKwMpvV3o6VLqCnX/z5IkHwnOsiToLxCsejaP+NhZxuOAcGCvoB7F5Gjwq6L52WBmBUz7qXTUyuyVxWtA8lcIwjnGHW6E/NgYZF3SiuaYKmx5IDrPaqdCTARCRpJ+nzCjG1ESKh40nN8Q+AK56j9Fi6Ickt0DuwxXupbD98L13o/OncwDKqhrn03wEKtT8cEAvt+2Xr0xhcYu9Qb9QPhUQrDHv+DlN0AlpVdDjLMPQ7feMlSK0LgwcAuueH1a04hktF7Rz6/AravKd98WeTobOG31/5seUCIqTSHMbkLvknbNvVEISdyD9ukD9Jemif5MLNzpBLzTUgXaXOVy0IAflwQDAC6m/KokByFhU8WikhUuypYiCY/NGDqK4yTx1bVjpVlI/j6h6NnWLBr257osXEjfZ1mPl2FhouMiqPknnvb5Fq0xI9H2VI5OmyrNzDT+nhbRBrcfk8c5PTP2cSkUrj9QX4VdLuTv4c3cawXrnQgzeg17WD77h/kj5Mh9GQUco2kadkzl8AEEq7hrS6SM+Wc2gBDCQ+zuctSGFZUTbg+iByxZmldO849e8TIzqzrhLcti9+1CBgXDrsXMiTaEkSmNRVqIhJsU1639EgP6pvj6SyiPSD3BdSrnGrPaI9UiYM727Hj8rQykper3kNWqzDeY4c27ONjlDwKNlxEQ3CK/jGRhzhZZNu5FoHKvatf0tIgvO07hSGXteEBcKSsIPwIbZHUlnyLSXMQpDijvNSScfKJrGtdzQD+6nDyoS8luxlYKRl013V5l2JxSNBYxX0W7XT4bReIOWx6gfUOvCLdpSboq7aKgKFsGF8BHOIsbqROKP6JULuEAy6AcoTNPiruWrqa9v
 vjmL96m9
 NyH9lJGz1X2ajnjnL/Nlsfp70BQDn1FPdawErBknrOAQaVK7e9ChhqJ1eZGxd36fVNzh2atKqarUq5YDk0ufvM1DBwy1xouUmu8Ql6ooocLIrICDGmKF697Hp+qS2u0gzuoybq+TN58wsKFyVMeOapEK4YK6BxSxYhWpG4A/XWIPsZmE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 03:28:32PM +0100, Kiryl Shutsemau wrote:
> If we solved problem of zeroing upto PAGE_SIZE border, I don't see
> why zeroing upto folio_size() border any conceptually different.
> Might require some bug squeezing, sure.

I'm travelling right now and don't want to dig my way through the POSIX
spec to lawyer about this.  Last time I looked at this problem, I came
away convinced that it was a POSIX requirement that page faults beyond
the page which contains EOF must signal.

Even if not, it's a QoI issue and we've invested significant effort
keeping this guarantee.  Please just fix the bug.

