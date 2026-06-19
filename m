Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF805CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 16:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9070B6B0088; Fri, 19 Jun 2026 12:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7E06B008A; Fri, 19 Jun 2026 12:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7E46B008C; Fri, 19 Jun 2026 12:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9C26B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:52:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C17201C4F5B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:52:44 +0000 (UTC)
X-FDA: 84897256248.15.AD11C44
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7927740018
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:52:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="bKyc/pzZ";
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781887963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hdjDLGlryqVwr0moNe7lsmTyx0ASJxTqJKFc2ZfLjBI=;
	b=hq1v3+1j5fMvWrNfw6t87AxJFBm0EenXvL/N53wtiCYvQW/8stJu20E9aGLIl1g/iX6m8p
	rmUQ6qNqjLtpvtGCsWHh9P3dsNXg7qsn6pGPJsa4mot484iDPGvf/L+jhTz89c3NfP8z6K
	s3p7ABAv14FPLycTpaGIJ0RwyORuBtM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="bKyc/pzZ";
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781887963;
	b=LI7aiXt7qAgLxJqVwOwsOen/oH2B9PKx+hkyPwm0ouUdRF3w0mHJ59z6ErctXe4jtteHXe
	THcwy6Sw+ZJfTYxNxQ9rOb9MOdn4d2vcLEnMBEkvgpzAfuPO4jzFl9aYneUB7+GnVzCJJV
	ggt+UdtZWy1T87A/nspT9EUcnbdN+aY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hdjDLGlryqVwr0moNe7lsmTyx0ASJxTqJKFc2ZfLjBI=; b=bKyc/pzZ1YVWuPzbPNCigqj8rD
	HraegruLXZEFA9MPV8LE89PEgKV2ec0lmFdrVcbMNJU1fQ+D5NL8HUSq7ZUKMFp5Gsw+LTVX/Y7Bn
	Q5h+Imphw1ewkt6tAJiKicvNaw2m3nrFyLbdId5T2VEZNz2VWUZNY1KkP+fHYmQzZRAvUvqkq+iFe
	6R3tffdj1WxbVIODYT8SzGM0/ZHT3dQ1myFpjRMnybvhozyQNmUNe6w1tZRmuS6OjynMaGs0LtQUC
	cmmQRxr9HAzMUhHuyxBjabwewGlOYqcaLL6r08/KXhXXy8K1cYQoEMBM/pVBNMQVdg6kn+ANm9u+h
	FT25tpfw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wacSM-0000000GYZF-3Kyr;
	Fri, 19 Jun 2026 16:52:38 +0000
Date: Fri, 19 Jun 2026 17:52:38 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Frederick Mayle <fmayle@google.com>,
	Kalesh Singh <kaleshsingh@google.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead
 to VMA boundaries"
Message-ID: <ajVz1nhMn2JwucMY@casper.infradead.org>
References: <20260619112852.104213-1-ljs@kernel.org>
 <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7927740018
X-Stat-Signature: uub3zitrzpysp8f9qftdfubpsotq4d7h
X-HE-Tag: 1781887962-555209
X-HE-Meta: U2FsdGVkX1+U9NFeHroi+TcOUwNK1tonWCWZjWcZ6KRRIChsWDuw7acFs+m6f9vvbaAMHtU0AP0R1yPP3WT0vAkVgs6kk1QvKDK5uibwUTRZH1cCbIrF2qGkRgfjB0hfuQpyGRUnkMxxezvVh1OaPzcjm3vXeSqiQ2GSU7rxZ9d9RMVKTtOZkP3fYveCUh8GW3aCoR/pgynAZPGYRbzG55W1pstabR8IyAt492mPic2ULAATKDliaAe7oO9phtihVlozEiwZaJT54Y1btyptcP9NLd7CrkDKdppu4i8N1L8s9Ry1Qq6POKRU0G87sFiGVEvFQnB767OxvgvE6AwnwKiBHINFVNgvRWAlrcGmua098KdSca7OAzgai13le20U7S9wZsq5ViugbpTDY74G/9EWT1tQnTJPc+oKySGEVdtvJMjI3e3F1SkA76wjaWjSLA/1GHdPvfKzp133Mnz+h6q/7tbVA+gAGITCF1mUZrFjq2NohAaskNQj1S83ApH09ZFvXsJ5DlnVf9uOOPk2bPNNfG3CVRK2/JKYDZN3i3yjU1U6uPjc7G4QeMLJqP4LfrEUJSoFuDBPSidX7cs2NCAlMdatinq29RduDGn5fkVuGy6pNYOCVQKbxg0EjRoDzKrNbjTXjRsHl7Y2kusOgV/XBZezKvjs9JcfKyAAIDtm3KTtYozPjRAdv7iCN2Tmx7B1K9ONseJIQKhX3+q/kDFk2sDK36F/FkfvcQrKGWFf2XiWMldf2gEB7PK/VLfriq0hM1dkcnSFJ+GkIz8PlSUznMFbStMjqDErkfKySknXh5QmNd7py1M6nS7wNZY3l2dVpglY5auLOZs9pOKvWPrezpOqOxLv6o8spR4ZC/s7I63D7xkSTOtyo4LO/bUwWdGefQGL5jhPDEJXgh0e/l2R2fgBRtukOGIy/foFRZzZg5qXZcR7zqZRAkI4jkuI55SNubA8Jaks7KiTAIO
 HGQH9Zes
 AiEt5tOdqikWZ3acJTHAf1l/bYdpW5XrmDTewFCJeu9oEtUosRUIr3xETzTDGjuLVZP5RxTNWgFnwzqeOyWUVofmqo0VrGh/KGSb/EShY5lmO0tepTjc1I6/ERgvjXULCLESJVn3hUhRj05wh8Gl89WR/VgsG5BdIq8zZY+PTn31qQlJVaXux4jNzddYYXHUjuIIZJH80kgZCsxRyefaBQSJxYDoO6adezA6P+2m4vITTmB7DFiOntr6ZJOyiVI/0fWRd2EiO7fCQXNKFXFPDuAG1P+xIqvaqgqbD7+9sUwW4wpWuAaLdBIj0Wjx1LSWKGmsfjNTHHu+EjkN3dGdxhKruAr6LXHAz21PA0nqauI1qxtw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 09:37:11AM -0700, Andrew Morton wrote:
> On Fri, 19 Jun 2026 12:28:51 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
> 
> > This reverts commit 7b32f64bc512b40b268776c5ac4d354b325b3197.
> > 
> > This patch caused a significant performance regression, so revert it, and
> > we can determine whether the approach is sensible or not moving forwards,
> > and if so how to avoid this.
> > 
> > There was a merge conflict with commit de97ae6222c1 ("mm/readahead: no
> > PG_readahead on EOF"), care was taken to ensure that the revert retained the
> > behaviour of this patch and cleanly reverts commit 7b32f64bc512 ("mm: limit
> > filemap_fault readahead to VMA boundaries") only.
> 
> I'm a little conflicted here.
> 
> 7b32f64bc512 avoided readahead of "file pages outside the mapped
> region", which is clearly desirable (arguably a bug fix?) and we care
> about performance of executable mappings.  Whereas it isn't clear that
> we care about whatever the heck that test case was doing.
> 
> IOW, the revert might make the kernel worse, overall.
> 
> If someone plans to get down and analyse that test case then come up
> with a new version of 7b32f64bc512 then OK.  Is there such a person?
> 
> I'll park the revert in mm-unstable for now, but would prefer not to
> rush it in until we better understand what's going on with that test
> case and what can be done to address it.

Suren did that work.
https://lore.kernel.org/linux-mm/CAJuCfpH_Fp=J-m-kVZ3VVmqH0cAfNX6CQKWt3XmAJq1Rp9sFwQ@mail.gmail.com/

