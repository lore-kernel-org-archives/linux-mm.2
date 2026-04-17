Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FF48F99C63
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 23:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373116B015B; Fri, 17 Apr 2026 19:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FCF96B015C; Fri, 17 Apr 2026 19:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EBA86B015D; Fri, 17 Apr 2026 19:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0938A6B015B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 19:14:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18A57566E1
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 23:14:54 +0000 (UTC)
X-FDA: 84669604908.28.11ED1A4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 51D301C0004
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 23:14:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=a9l8y6zK;
	spf=none (imf21.hostedemail.com: domain of jedix@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=jedix@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776467692; a=rsa-sha256;
	cv=none;
	b=P4Cgc1OzQ6ESe4cg8DtJCQLm6Vq///AMNwG0ZPeP1u2xaM86NkFXF1wA/V9chLidg1ql1I
	VvkcIROc8nBp7intxcnCDbtBA04YU3UGhVTTZsmOuYkSoSIm7spfrtB2UvCXy7Udf0jV8D
	i9k9j9Kdl4SBLL963B/slyQqsxstR74=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=a9l8y6zK;
	spf=none (imf21.hostedemail.com: domain of jedix@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=jedix@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776467692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wFdco1Ipo++Om9fQ34nLKqA5r9nO//VrtgBnQNq8aE=;
	b=RYLNup9U98qd9boOMYhAuE02nrgEPRNH002q3jUA+OwIpEHvRutwShInrdotLQH3vW9mVn
	iidhaFeVQRK6jTJYq+A54Zgs2UmfnvUZOfdMT2T6SUMwWNJ3Y/UGtydmBjigtpK5+iC8WD
	BT2fl6h+59BLmuvVvmfyoiDArfaaKEM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3wFdco1Ipo++Om9fQ34nLKqA5r9nO//VrtgBnQNq8aE=; b=a9l8y6zK+Kevdi3BKW+LMpqWLY
	lvj6ncQ7RinG6Db0lSWBD3ZQhO1Fqg87SPrWpo0OR6nJPvO/nUj4ds72oMqj+rVztHtbqxiqr1FYP
	8Qp3LVS7uN8dqMGXS15jeSWxPz+bgQIhodsonVMDMZHcd8nyhQz9c4hI/DTxxoB20RIoJ8d3VGhGa
	OAGCvqiiDvUupi9WpD6KuPIFeqUBhLncWV9TQKPHfGw/UdvQGp71onMgsraooIaVUgudM0iUhcmQS
	n3HcxYOqeveqTgABdVZfT5K2BElO815ZDUZ/D9cQKqhI4OHtI10V9353KPjlBWW+9uW7WsP3Bvopw
	h/bBj50g==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDsOe-00000004YO2-0uVr;
	Fri, 17 Apr 2026 23:14:48 +0000
Date: Fri, 17 Apr 2026 19:14:45 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, Ryan Roberts <ryan.roberts@arm.com>, 
	Christian Brauner <brauner@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] Page cache tracking with the Maple Tree
Message-ID: <sdpiedmwabh5l6r7vmyscxadftwsmq7dteolarlfvca7ks4d3m@e7f5fnrw25dz>
References: <biynsvpcamct5fva5nxxdvc3q43dqi72jotpyasvrk3pumdz2w@7okprmuwznlo>
 <aeKO6bKupHa2bgWt@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeKO6bKupHa2bgWt@casper.infradead.org>
X-Rspamd-Queue-Id: 51D301C0004
X-Stat-Signature: yecoyecsot166zmrpy3rht84h7wfkhbj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776467691-396505
X-HE-Meta: U2FsdGVkX18Sk7tfBCeB79cV4Zfw35xA0B7Br8Ak3fUtn/T3ZZvaEmpIRQdKAQ3w8Ze1+7OqDfwK6rk5ylI7rdzEsrg6xj2+RwHvQn62dmHkq4lqVu/kaLfm9gEuiqK5N/0Cvkw+aYWe8z2lBazwRKMw0MAZCyKLIRtueoQRpcsEbKN2AFY0uuZhP+PdzzlyViCqj14AnA9jeOb4ET0A8UZLcRuw/kxWAGF0ft3BMH3mdiV2rsLc3/TJ1n4zFGOG3G84Ga+j4YmuJZrLsm/lNHezj0Ltt5q7s5rA4mtN0n7moBfNROF5wvd5VhQenAdIay5SQKJSt/KWdvMTcd9yYXFNz9TSjaQoNyPhaNAma1+0yLNTuYSeR2TWpuqV1WtPzO0FwPlkLSkneSP5IO/KMuwFbD49e4Kcatm2DbuYMKtDFuIGRDljV0UhEnEUpoACfhnJ9QdMh4pc4G+ZLdFuOyi4UnLa4CKNaMOkbzv4Qsm1+c5MyBnuDCw5uWerj6kYURK4HBR5wFJWnyqsY311B9a3IJ+R6sPCiRd3qeFf0i5tQu+jWJeSWlpgoUCQi8TgXhxfN6BoGYQBHqPHKriZJVwEzH8u1z0Xx+YqxhmVv3QvKBlR4wKlRmqzvX7ac022NcwDCW7xFcRrG1wGapnyQEQXt62fNyDyzrceijgnx43tvd8EKYuer6/e31mYICI2kHi2GJv+BJXxjoWuRsLSVn5S5mMiFuJF5l9UwryqTHdPARm9Uu5VaIgOcEQFrVuovbd3X86xxUKYkkqpS4G1pbdFJhD5LWHwH4c5nYeS8f7vxfdohT6bOpN5BHCLuAoX4tc/cCoyd7StrauwrS68aiBO3pOkiyuGSW3Xf7qOyStHIAZ71h4YICvWZgQ7TZn+4oPu4ouldZkXTMD13PKOzyqMtGF7SEt9ER9/XrR3BsUGI0WUiXrG3AY6KN7mnve4mQQfz5WE3yNnupSjjZ8
 IEBUwNAB
 peK3CuTxKRIOF/oDsSnIyzGX6DjfNrztOcGb8Rfsi2/m30Xcb+ABVIghgZsR6r0IxCK0vJx30qLmER+PPt9/LhCrVrXNY6JxyJ573rUR0Z13rYhDES/XW/x+I/cnU08AVQdNv0+YIwd6YZOiNepDj4KTT7BLdtk9AiE5Xb+eSGjGrJ4O/7D/+fR5TGuXJXLtZtFbG9qzynWQM77QxCuGy6aktP0Pp07WzWFKHdM9YimHfktJ1BDtmR40YfNhA01p5gFX9qYsgw6ITak51OcCPukvRoOceQOjfI9rZBZPPff7NuqfW+RahOXgWhpEwduepszvR+QuillkOLOBYlXXWN1JT/nJzjz1CYoHbe3SChya2gtFS6nvDH8zo0uxSruOu22vCCVSf/4qOmjc8bagD5RYCV5yM9DLpsKlvY+AcwOInWWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/04/17 08:50PM, Matthew Wilcox wrote:
> On Tue, Feb 24, 2026 at 12:10:26PM -0500, Liam R. Howlett wrote:
> > The Maple Tree needs some enhancements:
> >  - Support for purging shadow entries from the page cache
> 
> Liam and I hd some preliminary discussions yesterday around this
> and we'd like some feedback if anyone has time before LSFMM.
> 
> For those who aren't aware, when a folio falls off the end of the
> LRU list, we store a shadow entry in the page cache in its place
> so that if we access that page again, we know where to put its folio in
> the LRU list.
> 
> But this creates a problem (documented in mm/workingset.c) where
> we can fill up memory with shadow entries.  Currently, we embed a
> list_head in xa_node and add nodes which contain only shadow entries
> to a list which can be walked by a shrinker when we're low on memory.
> Ideally we wouldn't do that with the maple tree.  There are a few
> options.
> 
> The first question we have is whether it's best to keep nodes around to
> wait for a shrinker to kick in.  Was any experimentation done to
> see whether eagerly freeing a node that contains only shadow entries
> has a bad effect on performance?
> 
> The second idea we talked about is that the maple tree is much more
> flexible than the radix tree.  Having even a single folio in a node pins
> the entire node, so it's "free" to keep the shadow entries in that node
> around.  But with the maple tree, we can be much more granular and
> delete shadow entries in arbitrary positions.  So we could (for example)
> keep track of inodes which contain shadow entries and purge shadow
> entries when they reach, say, 10% of the number of pages.  Or 1000
> entries, or some other threshold.
> 
> The third idea is that instead of having an injected list_head that we
> keep a tree pointing to inodes (or even just maple tree nodes which
> contain a lot of shadow entries).  That's not how list_lru works today,
> so a certain amount of development work would need to be done.
> 
> Liam, anything I missed?

The only thing is that order 6 trick can be removed and we can support
any order folio.

Besides that, there are some ideas on implementing the different paths.

