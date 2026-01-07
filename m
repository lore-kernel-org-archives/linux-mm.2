Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F12D0D175
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B16F6B0092; Wed,  7 Jan 2026 15:55:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D7F6B0093; Wed,  7 Jan 2026 15:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A896B0095; Wed,  7 Jan 2026 15:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B39C6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:55:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1AFE8BD83
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:55:33 +0000 (UTC)
X-FDA: 84306373746.10.07BA728
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4C8F920006
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:55:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BevhwU23;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767819332; a=rsa-sha256;
	cv=none;
	b=AGHnlEtfA+58otei6Hr+GuNxwh6PV0s0kZXR2JXjBCIZ+wbx4dknni937gPjHJzrh1fons
	2tIvWFtuoMTJoI2vFdu3uvdUxSooDuq9XT9rlHcUoMiXyrW3J0cHGfXqUxCqtdGDGBJNlm
	u8nq30rm0wrp4ZdSR0hK8+yWHLgwmjg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BevhwU23;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767819332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=onCYdfBJPf4AnSBVwJ2/aEqS6jrss/1BLUDHPeErKyY=;
	b=bJ9SPBmCkxPcrhMwvC6zv8xedF9zbD658Am8QO61JQ3caw6brKOdb+1flc9Cg5wVXsp5uJ
	JR4v2DFp0k3U8Bwvgu117F+J2iyXGdloD1kQ4X+IMknVlbyeDma5wsMUS5l8CX+Wxn1jKV
	GDXBA15vgND41aYlD+rkgU+nvdCQPQY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=onCYdfBJPf4AnSBVwJ2/aEqS6jrss/1BLUDHPeErKyY=; b=BevhwU23jXy7xBnkUWiBMQhaqv
	R6sPWMjAr+rKAe7A0FmmrwGQv87wr6BoDLHGWK8Nirt4cOJxD5bBnI35sVUwaPAYpEyAsuiNfb3R8
	SqzrIjpgDFtsdRe2lfF8B9YclMUz2k1wbV8XvIsPjhpckjjnWI8WXoss9bqrZB9sFAvS3rNelehfw
	wssT0vUTINtXtevh7HAcwg+ZgAhiXpPf/8xaaP1iZy7/QQQKySUM9ZTwKqbpkZ+XiNH7cvzF2RSFf
	MSyWMP8oEPS4/pJTR5cK6CrokTWx04RcATzMyJd4Bzdn26Ap1tG7V7pSFRlASMD/kA9LL3FLizffP
	YnMkACxw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdaYu-0000000DwPV-0E06;
	Wed, 07 Jan 2026 20:55:24 +0000
Date: Wed, 7 Jan 2026 20:55:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
	linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mm_take_all_locks: change -EINTR to -ERESTARTSYS
Message-ID: <aV7IO8-trMSI1twA@casper.infradead.org>
References: <20260107203113.690118053@debian4.vm>
 <20260107203224.969740802@debian4.vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107203224.969740802@debian4.vm>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4C8F920006
X-Stat-Signature: pboco4m5ghofyi5dtfu1iaj46jt43hxq
X-HE-Tag: 1767819331-897753
X-HE-Meta: U2FsdGVkX18aGz1owkMUXqm7SWKURUxeeF0onlXMgHZoIeuHBfFQHEQFP+0dwM/lKlmMDA21nAV2KkqB+HDgUhJ9/XETaMLtF0l2UJvxqqNoqtqquogWv4HVHhynD4QnI+Z3GU5roIMakXC2Nxfoa15ajaEGcRNG1NA+RRFD8vnDfw9rNNscLiiUyRa/g8eFF7Ilr4n6YqFGyYGJf+Bzld4m5xrWV4ibtLS8km+ynzMaIZIwYBpcuFtBopmSZxGE11EVwK1lt60zY7JIwwiWO/kJ2Sgx6tXpBhhztxSvtzNdXaP32ACe0cQPQSKpMh5Fe7fzsDQIGHWkZmuAKc1VZfbs7eO+NqaW7s/3D+CB+x1ZKBSd8xyAAot7qbC36YTTmoJVu7pvizSCnPYX+fe/wqYdTPeaqGzmYPdsW+vmJwhuY2QHsue3w2Y7MugFu1QwXPG/ZrWib+5t7oLMszJT8dH9JvBQwOGqkvF73kOAi543Y3vA5whwgxTObEWnRhfrdfLtzmbGGPnThD5u5nVud+LqXn5iEHRtpIQ0eMKi6x1tBH4I5STtK6k4rMzHDN4yAc0e1+a6g6MlzWqaYzU3LyyMW+MdjgO05u1TuuwHJShmxWHPsjBs/ErR06/x7oM/PCQVFFryyclGhXmeeRhW4s9rxcStzpdNO0lirKcWXkv3G7BTr6AVlHTX6URF8Q5KzTNHRdtlPeIk2a4YJLs0x6hZsNsjUitqPhuSGtCaH6samjxC3sb4f6TN4IIEj3rB25cK2qgcPdyq/veB51JcgTvtcYDiA2q+XrGQ9hyNpCNOZcVJ4AbHmkMVvGFMh6lntx9V85b/pD/4EuwfiuX3gdMPCu+/De+8t4/+na02ANCG/iJGq6n3hT4wBHXlQk1GuymSUkKotTn2Rf9A9zJbbcXVzd7T3cfcIffjSXS/f1NWDB9Yj0rHHVvLSzTHcFS0YpVf73AdtwEpNGBTK5V
 2CvTHirK
 KdVOFmdEPVQ7aiKapzv6Sq8iMictNI7Zb+SY2O0q6net/BHVdCO2us8BEQgT2EsBNfDMen0OOWoE+1ik/B7l923liSn9vh6fiFKMRUo6LLjBJ53KoXUUi1GDj72PhnfcX+U3vm11XwHWrDFgZuCVBNgHB1x8JpVBQfzUEyt2Y/5K6QBx88maF+L6KDVoDOqvjMFF2xUpuXW6v5lO7GnrBE4CgiOoLJ71GoUiTJE9RE3BZXj6HtV8EtMdl5f/WJZQjRJ3xZkh8zori3eIlrbh3JtpWjmqM9sMWR5zbJYJqL9PjABM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 09:31:14PM +0100, Mikulas Patocka wrote:
> This commit changes -EINTR to -ERESTARTSYS, so that if the signal handler
> was installed with the SA_RESTART flag, the operation is automatically
> restarted.

No, this is bonkers.  If you get a signal, you return -EINTR.

