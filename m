Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68449606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 12:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=p4d3SJcC
Received: by kanga.kvack.org (Postfix)
	id 555CA6B00EF; Sun,  1 Nov 2026 07:00:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506E76B05B1; Sun,  1 Nov 2026 07:00:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41CB66B05B2; Sun,  1 Nov 2026 07:00:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA596B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:00:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BA8B140888
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:00:47 +0000 (UTC)
X-FDA: 85386408534.07.C8EE470
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2B7CC20010
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:00:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p4d3SJcC;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793534445;
	b=l6NpEJQUb4hMZUJgK7w+WI2Nav1FbNYIQfe2vipkp0uVSsnD6z/Flo8A25sKfev4nm1zms
	zXl5xsZvU84HROt1xo3EB9SeAOrfe09rwwv0Y4LEV4LvEWrvnrDhYyRvMIXBwUxCvj5oMl
	zo+DWdNRk2OYIhBfbxg/8KOLTXbOa+I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p4d3SJcC;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793534445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4WaSwcey/R3vXMs+GDt54aKbriYS8bmBNxUW7PZofSc=;
	b=eqSr6nP/UwXEYt5Knbka5fatdSHf81sPacNd9vYQ4dS/222cxndsZHp3oxFZvtlsxQ2OB9
	Mge5wiBJRCE3SN/uy3K15BLj5YqupwqvwcOBoLn6cdEz8NL9yokAYNh0rI86nMu+Cxs4SH
	WbP1uVub9OnFFPxBPhjk2movAjaKCko=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4WaSwcey/R3vXMs+GDt54aKbriYS8bmBNxUW7PZofSc=; b=p4d3SJcC8GETvQwvlIM2YAHZNM
	50vNGjHr4kdKhF+Ud1/ECNTKnYGCE6uX/VUdkk8t1KHt+TyeZE8LOlynoJwJhgspZtPeSiHnDy/iZ
	a6s5mHYGOmEeB6CP3S7QLKS0Kx+EBmijhMpqCpfZf6BwlxKH4iIwsA/ObsX03GXVT2SrgHGCefdu+
	bgs0M8/JjHCWrfhZ+l1jlnvCbkdJ4M81Iv+bVRjrH6OChOoirqKM1MyR+PY/Cm+Jx8eqYmLhV5vUn
	DkCB+G8h1oxJhhhRYzwGgAwqGBqZwan/KkWShcyyoD1EB3yzL0d44W92zJgL0K8+Kw0MNKrC+v8Nj
	FyPzRVaQ==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xNUEq-00000008eUN-42bb;
	Sun, 01 Nov 2026 12:00:40 +0000
Date: Sun, 1 Nov 2026 12:00:40 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Stafford Horne <shorne@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stefan.kristiansson@saunalahti.fi, lkp@intel.com,
	jonas@southpole.se, broonie@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] openrisc: include asm/page.h before folded pgtable
 headers
Message-ID: <aucp6NrW64B30tO0@casper.infradead.org>
References: <7e6799e4a26d4c87b28bfe1d0bab7d54.1@linux-foundation.org>
 <aubrobg1lV24DH4h@antec>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aubrobg1lV24DH4h@antec>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B7CC20010
X-Stat-Signature: ok3omfyopcs5kczho3jxxxyyziu38ndf
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793534444-105649
X-HE-Meta: U2FsdGVkX18ZOLBj/V/5MaMX16V2UHw7d7lRxJnhZ3TPR4vMho3XgCczQV894QhNrlu9RJmicPzQmtefuqYWN6ysStq4JDYpKkkgOslH2d0iIW42jtQI3MivhqEdL3jf/ImhI9exFoKsw6NM9Ky0ivCkY+3sGAjSnXhguYiS2gyC2+emj2qRKeIruKZ9GPmJa4iU6cqchl3RqLU+eM+5TEH4G606FmKAc2YSAWv5Iny471PwqZjyY+MvC0ghFfa1jHqofbq1CTYB5otGDA9Qjy/934SnVd0TYuH2pwB4jMgTc6KcxH5aVa1UBzJEzXqibuACV/EJDR7033E4nAs18DJGxjBpHFJgBSLrPinv4Kuf6XM9IUMykoFb3K0GcPJotAceexEG5QIqT7bR1l5ELdxufNzu+cw6JbuSC6blEJZtV06HBcO+jguriK1hDEjdRBUgBQd+7gVk4RHkRN01opmBNPom/CIBfcnPiqI8xocmAXNc7gtI8mTBsc6Ui0IcKH6Mhtv/aOtNzCiqTa0Y5yytWnq0KaLw6HCx62EkX5rxfjrzrNDTnZ0QISMUTJ2zWwCY3Fty9Q82NXf331bM05LuVINvsDOHpbcv9GRjrmp8wjWuI448GSpPoXv4H7FwLTAffLUD6Sp6/DXf0KXye488YOcGQPbv96bREx0RF12hpLRAJMOswkuc54iolyKRjL3i25gE4qy7DhciYzapT6WZ1vhdk0i2N/vPEhXVLo7XNTPGvfDxNlKb1lxaxkOYhsQJiIFKNIZa283dFAHNFxSsKcB+LimcB0Mng4DkDlfReLvzhBlaeqTllH4McGdAMncfEg0TWbr3LrIFcAhtNwtXSg3Y1ZWsxH22+q7ovaZVABF9o2BD4O8ieo86AC6zbTdKdqR38nv1TXnUNJODAcjkf8utVJ1RUDGHCDpu00/4fBFho5ERvB5CW2NpmCvaHJ7yvAVbKsejzb/wPZS
 FVCEQ1z4
 LDHQ75H0WvFFYQZxlmSpekCQEtK+fa+Y88Y+/duCOdymNY8PkX0FPqP77ESJr7mVWBOjV5BJ3DHamHsC3ZeezJyx26I1RbRtWmlDFP5SPJ4GLx2/bbRAvG0KS7d+JMz3AOYA5sZPdCtNCB+Z/bAxXDYM5TseVMLChbY1X/a+Zib6zIw3d41gD6n1T43bYjbII7yXI1YqgLD4bBpdbgx4V+NccrOFceVFfMs8sA2jIyO26+Nd6DSRU9uP4FO7JTLKrLfMLmONBDK/rMyJpIq3jKFvz3te0oTg2+t+wFRpQYsW+MRo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 01, 2026 at 07:34:57AM +0000, Stafford Horne wrote:
> On Fri, Oct 23, 2026 at 05:52:47PM -0700, Andrew Morton wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: openrisc: include asm/page.h before folded pgtable headers
> > Date: Fri, 23 Oct 2026 17:37:53 -0700
> > 
> > An OpenRISC allmodconfig build fails while compiling the DRM TTM KUnit
> > helpers:
> > 
> >   include/asm-generic/pgtable-nop4d.h:9:18: error:
> >   unknown type name 'pgd_t'
> > 
> > The TTM header cleanup stopped including linux/pagemap.h from ttm_tt.h. 
> > The remaining ttm_caching.h include pulls in linux/pgtable.h, which
> > reaches OpenRISC's asm/pgtable.h before asm/page.h has supplied the pgd_t
> > definition.
> > 
> > Include asm/page.h ahead of the generic folded page-table headers.  This
> > restores the missing type definition and allows OpenRISC allmodconfig
> > builds to get past this failure.
> 
> Hi Andrew,
> 
> Thanks for this I will queue this.

No, I'll take it.

