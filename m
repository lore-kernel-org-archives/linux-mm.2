Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 779B3CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 21:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15376B00E2; Tue,  9 Jun 2026 17:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5896B00E7; Tue,  9 Jun 2026 17:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDBB26B00E8; Tue,  9 Jun 2026 17:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC8396B00E2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:02:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53723165078
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:02:14 +0000 (UTC)
X-FDA: 84861596988.30.2F94335
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 46E2F40004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:02:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xWfqD5Y2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CjqYj7EN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xWfqD5Y2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CjqYj7EN;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781038932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0HeC28O7+Ug8YaDsg8d903XowQc1OEPHBViv9mHTYSA=;
	b=1tufrCJfBelio2m3Uw8WUuEIiROboZ3qE5I8tFXlBQc4jxMv41HnGyLtslcep5GxSlDzV5
	539giDzG4b+3TE9Fc9ZntPxWIoPbiuk+1VUl0nh1g+NdfuYEXccszK/BV+UIlD7RQoqiBB
	ZeJe+RuK//fgKxC1KW8RyYqxGdHpb8A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xWfqD5Y2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CjqYj7EN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xWfqD5Y2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CjqYj7EN;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781038932;
	b=0uE5ILE4FbXAN67wrxOn8ipGOQR2WEjTheTB+VztB/87lCiq64jf6FdM7BwUb6uG1lV/WL
	3ZWMB2XwrL1M8JpR7BtMvJLY1jrxMuZeSN4eo5YcQrwX0+lQnYKc9acp+EiXMs2qAj8ijh
	PrIdaHZFW8ESmmySwuVrrv3dIT0jnGs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B815B75A41;
	Tue,  9 Jun 2026 21:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781038930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0HeC28O7+Ug8YaDsg8d903XowQc1OEPHBViv9mHTYSA=;
	b=xWfqD5Y266ujaa3u/ujnjPxtdQngw8TF+jSluYS3sfjWo2dW9zcbWrjSG2uxjp/a7BdpEW
	WeWRdE8wIeWimma1pk4eONequ4X33eOmdH59jmhLk4nNlbfdgGaJ17l3HTna/Cz8tHzq9s
	NaDAGKIUuo2UemWQbIFs9L+/6VBKAbU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781038930;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0HeC28O7+Ug8YaDsg8d903XowQc1OEPHBViv9mHTYSA=;
	b=CjqYj7ENp3Nqv4vEYEVkbESMCEFIsZszAVaO+0bhtg8FP7gDXOd0bDXlY0o6pHDSFIy6+H
	brHXyEudAXDLzbCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781038930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0HeC28O7+Ug8YaDsg8d903XowQc1OEPHBViv9mHTYSA=;
	b=xWfqD5Y266ujaa3u/ujnjPxtdQngw8TF+jSluYS3sfjWo2dW9zcbWrjSG2uxjp/a7BdpEW
	WeWRdE8wIeWimma1pk4eONequ4X33eOmdH59jmhLk4nNlbfdgGaJ17l3HTna/Cz8tHzq9s
	NaDAGKIUuo2UemWQbIFs9L+/6VBKAbU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781038930;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0HeC28O7+Ug8YaDsg8d903XowQc1OEPHBViv9mHTYSA=;
	b=CjqYj7ENp3Nqv4vEYEVkbESMCEFIsZszAVaO+0bhtg8FP7gDXOd0bDXlY0o6pHDSFIy6+H
	brHXyEudAXDLzbCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DFBB779A7;
	Tue,  9 Jun 2026 21:02:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sWbHE1F/KGp7TwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 09 Jun 2026 21:02:09 +0000
Date: Tue, 9 Jun 2026 22:02:07 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Gladyshev Ilya <ilya.gladyshev@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, ivgorbunov@me.com, 
	Liam.Howlett@oracle.com, apopple@nvidia.com, artem.kuzin@huawei.com, 
	baolin.wang@linux.alibaba.com, david@kernel.org, foxido@foxido.dev, harry.yoo@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	muchun.song@linux.dev, rppt@kernel.org, surenb@google.com, torvalds@linuxfoundation.org, 
	vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, ziy@nvidia.com, 
	kirill@shutemov.name
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
Message-ID: <aih_EK2l8aiZQjjM@pedro-suse.lan>
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
 <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
 <1b6509a832dba9a7e24ddcdc23fb75247b267c78@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b6509a832dba9a7e24ddcdc23fb75247b267c78@linux.dev>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: t44rqckyxb6d1siez5cojy63twguaawn
X-Rspamd-Queue-Id: 46E2F40004
X-HE-Tag: 1781038932-574816
X-HE-Meta: U2FsdGVkX18yFw1EBknosrNddMHb/+7k1UaU/8JYsmKO+BE9Z+hIpt0NKnJ2uqUJsQhrTGVwVR2fesarIhLj824erZZ7rr8/wiLz+tkGZ7SyZtg7wQqYM8YPEawD+eiQJsWvVMCR1XHIOcDCkHLj66kt+SGXGaAlO7ghy8jcJESiE+hpGsmTN+J9IAdqfvCpRTNUCv+SPmrH1AAP9fQ8r+5HAYQBS+/425CJt9ry9R96tM9qevjWKb/M1D4wFTzqB+b7gSKa/GVe3NxyUK6dWBUxd9kXILHqXtsTQjrgGEV4fil9Jq4kx5yghJklThgi8Z8MPDGnsF8xKDNfPAAM7yPOAVxG8ijc72t0j2cb9TKULg37n+1Nk0FGrnk8maQVPd/dN/3QFq2+IQm47MG+26T1aFfrl2uH2tQtMor0Fd+L9dFq8dZckUS39VipQzetLc6liMrqgjDNY5xdT/sl3TuhtQbkyaEwCtuLfEY1vfdP0PUx+fwb6yT+BYJ8e4/M4dra9Vrzcn5AGrvA3lSVxPIaxkiMjH/VQ67k05I96K2/8sc66mE0XKBemaxcBYY5cLuNRNRibEJIgeLhAjJjrdbQVfDLZxGjtDlcgMIvlsJfC//I+SQUZVSDSuChTPIls2JQgKEIgnFx0qPuxuUPEpHINgndSftk9NdPHDRPGx154iIQiOKvAduWb/xx4w++69p66R+R6Aze74MK/BoxRoNT/toBDCaVbjx1SpYgRmBdL80TUWYG8ed5iqJclIpbM+elCdzMz4sHmiCrx3CLliNT9/wKPnHUg59QIoZtyZ4+ByhSTVNgzVrIt6RT0Lh9tiXAMAilLEkBRo4+crfsvIsnQ/c8IGOyzN5RpJi27+Zlqu3EnCYnPw+ZEK6FzoNM7jKVA3eCJCM6hKUHiLGbJh56qbs5w9hga/Zg8OOXFBQUR957a/z6Qo/QBErUnKZddy8BnBwEVvEN7U/6NPH
 nLldf+53
 IL7zNeGFbUuHDkbfWfrWcbTTSlAzXaNHc21OxUHDWLrdzi87L06Yz7cAoUJ/nyayel4DhdMYlP6SFMk9sjSROY+wvTDLhcxDspBKmyNLqNo8QGt1KBSUWDlI7VFp1jSQDyf2mItTS9flABAbnetCiYbhiv7KM7MyBEFb6AD4yKFyH3Jqp2oSFmbus1dNeQWGOXVGxeJLtZwkKdfehcbZNkITp2TvVUBhaG3Ktz5qDDF11+ceG8n/0Jjm5WtVf7zLf2lbHwbCzul2ELjUVEP/TkV+Csp9wFqXSFVvrT0txg+5Hx1Bdpimw4+J0atmUTb5XuLprrj4cxIC30no=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 07:02:25PM +0000, Gladyshev Ilya wrote:
> > 
> > On Mon, 08 Jun 2026 21:53:01 +0000 "Gladyshev Ilya" <ilya.gladyshev@linux.dev> wrote:
> > 
> > > 
> > > This patch optimizes small file read performance and overall folio refcount
> > >  scalability by refactoring page_ref_add_unless [core of folio_try_get].
> > >  This is alternative approach to previous attempts to fix small read
> > >  performance by avoiding refcount bumps [1][2].
> > > 
> > Thanks. Nice numbers.
> > 
> > AI review had some things to say:
> >  https://sashiko.dev/#/patchset/df26082871b4c65b2bd38d409026237c08572836@linux.dev
> 
> Will look into it, thanks
> 
> > I'm not sure we want all those new VM_BUG_ON_PAGE() calls in the long
> > term. They look like development-time assistance. Perhaps you could
> > make those a standalone patch at tail-of-series so we can keep it in
> > linux-next for a couple of months then throw it away before any
> > upstreaming?
> 
> They are cheap and can catch bugs that are very difficult to debug. So
> I'd like to keep them, if possible. Maybe change to WARN_ONCE, as David
> suggested.

Fully agree. I think it makes sense to keep these assertions for DEBUG_VM=y
(which no one should be running in prod anyway..)

-- 
Pedro

