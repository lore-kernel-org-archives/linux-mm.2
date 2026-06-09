Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DF42CD8CAC
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 837BE6B0005; Tue,  9 Jun 2026 04:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80F166B0088; Tue,  9 Jun 2026 04:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C736B008A; Tue,  9 Jun 2026 04:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 648D26B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:44:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2408E140497
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:44:05 +0000 (UTC)
X-FDA: 84859736850.10.54BAB52
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3A13840010
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:44:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780994643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=didU0eVpnw/l8EBq9zJ5F1TNzMhxrqnU6+dwxFNj6TY=;
	b=zW/aCewPtKdLGOkiIFtn42KFS6Qucidu0lZ6mcGbxF3L67rdUmP6yF9l+Lw88/u+pRnU9j
	dICwOzSTvEinGdXFt+LpQ44abc0nYFtjCPbN8Pru666lirm3fALevpAqinwYGunMvilN4p
	B5MfRTj1015sAaSEmppiU4+JXOIxbUQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780994643;
	b=SE+1twpGXVMp7WDP7kZVwK8ercXL8FmO+dIj5Lw3bZHfCeBa01Iq42d9PyXCtCvdvD8MGP
	wS42PH7iDt2K1lQK088iqIWUEg+G/FLX7iBL6mLaEp6WI6c8gi/cIiEMWzhiUJ79ryQtu6
	2M4LsiE9bSC9x72egvWHiMM57btctRY=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3BAD968B05; Tue,  9 Jun 2026 10:43:59 +0200 (CEST)
Date: Tue, 9 Jun 2026 10:43:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, baoquan.he@linux.dev,
	akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 3/8] mm/swap: introduce struct swap_io_ctx
Message-ID: <20260609084359.GA11917@lst.de>
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-4-hch@lst.de> <CAKEwX=NBdL3zZkKBC73ii1mFLY7ce==J3bd79G_nHjGnciyEsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=NBdL3zZkKBC73ii1mFLY7ce==J3bd79G_nHjGnciyEsQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3A13840010
X-Stat-Signature: dp3wfst6ee1kqfhuaybg5in3ywqwzak6
X-Rspam-User: 
X-HE-Tag: 1780994643-953095
X-HE-Meta: U2FsdGVkX18EU7ixKzB5VeipAym89AFK6JhD6CWUcINbtNBZMKDWGpy4f0muBJdek/aDSRij8qWP/ycgJ3PaLYI/CNPh9MLvKdtsAfe2gzuQdRrvAXrqCsm4dn7JMHBM5w4xvmXKB2zXQKRjtESduH0/NDFezhqZOcCIPYW205wH/z40QcfQRJHo6e5T6LnA+ebXq3nx0tfVQyZMbAT0Y0WpmYOTIQMLyz6SmpNY0/pT46p01xgRQ+1i5erhHU8jMx2jj0BO3mPKEudAcu7WqvDkJg+pniNkggLYCS4+nbHqSc7YEyLQfEe9j1HLxi6FaYx2igfY5hlQ8ktRPvDL/wbWO4BPG4+vH1Cj4zYpbAIwfdWvfVjnkld+0rl+Z/paeb0/jSfdqlusuf0i3SPiXGnkKsjxbBnYcV+7v9+BQ5QAjDNkWty2ifV4i4SycetdC/8hChmUb3N5o9XcmNxnJlVIeuXaEPmTu6PDHkU81owC0bbzNP5QM3dTrN14oJjS/rPFi//WwabCfDWIgYOMpvbPzLy2rm1dKQ2tQlAJDCWmDlVRHnXDeyrsUyr8Dw5GjbLUDZFHPDZltqSgynvgqJ9a4wbSY3WjOKDRuvd/XcBG+cOA12l/G4ltwcob7eVF97hZYf6aIkdudUfImD8ZjKdydcHKZW8wW5oHKWQNwm6Cxy7kGwslG5jOlF8zYt9TEdPkFR8PLTXgCJNqxC8KiTQCSg1FV/Wzpuo4LnMxtlV12I/eUv3c8i/puTs7ncL++m0QYii3KBKkx9T65CzyrheK0TUmIVvmBiOnB4RfBbsSiZFWInaIZ6xhhExNGyev4tTqQfh/c0kGDvOiBlmWy/sv/lsFZy3w4Lb5IBiWq29r+Ttpw7tORc+sxobk1wsVVMaZN7FgjVFYo/aW7ocgcQ9nhrLFe1aQSmWLvyQFOX36FEGRpU4xNrmEgqD1jB0ODgJaYUtE2gexL59FcfB
 8Mh5f9zT
 eSuyNgEcbFGcbdVf7xM6Ehw2QwYE9Sqn34BwdsQCQNvQtJeu+6f2FJBww4SXIJRr3s8+cL8Wusp2HclfSeIkxufpZuqgI/OmzYjrkxrOfOWuRKTUe+Yj/a2oNbNF0nT7henVss4JBc0BB6Cc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 10:41:56AM -0700, Nhat Pham wrote:

[fullquote]

Can you trim the parts of the mail that you are not replying to?
You've quoted the entire mail without any comment on the patch,
just to add a note at the end.

> Note to self and other zswap folks: explore batching IO for zswap
> writeback.  Should be fairly simple to maintain swap_io_ctx for each
> writeback round and pass it around.

Yes, compression should benefit from larger chunks to work on.
I think the same would also apply to zram (to respond to Chris'
comment elsewhere).


