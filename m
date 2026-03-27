Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 707ED10BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D87346B00A3; Fri, 27 Mar 2026 02:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E936B00A5; Fri, 27 Mar 2026 02:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56FF6B00A7; Fri, 27 Mar 2026 02:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B62046B00A0
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:24:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CC81140CDE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:24:07 +0000 (UTC)
X-FDA: 84590852934.11.E87F980
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8336840006;
	Fri, 27 Mar 2026 06:24:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Akq7hqCe;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774592646; a=rsa-sha256;
	cv=none;
	b=6ebEZ97vdvmcqGc0+LYLsCUN+6+ItEpc0RI2XWVgpIjICnFKQZyX2takFz78mUqI36nuVC
	psdoDksmjM1UdlZ8KmzwpIxqSWsbboLkNp0BwU6SpMlDnzSGUsX4oMXy+O4yR3fYcFQG46
	T5/z1EtD9w6pxOYCGRr5yb9F+YSkzsk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Akq7hqCe;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774592646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=0cnLvaj3bOJhlCTspvrd1d0XeHQjYjnJ5rt8dn/1BDKtX1NeNdV8aAqWDbA967o9QIK7pp
	EGEOzADHs8MMelyniVbaSvGtb0U93/hsSsbMstedqwWVEVqxdJXHCTkFz/hkUhZ/LjRgst
	5DRTB1IRvksp6zmVH7JIRPE99Fu/8cQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Akq7hqCeq3L7qJY8xekif/H1IL
	10s/6mD8TowYHAs0Mh0fmyrkIZ0peWfvGTGNTCF+cErSPOUsAkNtmgFnPyV6AnW6wmjGUAZ4L66KL
	8JYNKgvXqMwpNaBCB0eNNjaEqkZvVKgOSpHYo0QSvmGp2pCEgBE8m8yaThFWOMuq2S3o9WujStozx
	rMN/mT7p4HMrslSDJLbee31EP2jPZkFb+Nb/laVv9ipJT0izhceDcAYP9BJhQPT7qzXo1gyOlNjPu
	tZ1u+hIcVpbYpbgdaHfORapU7b03WBQk+uKrxgZbFkKyQxKW1OzDeTjnvACv3vtnLkrzihA5Jj58F
	jv7H8M5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60bx-00000006ogq-2aDS;
	Fri, 27 Mar 2026 06:24:01 +0000
Date: Thu, 26 Mar 2026 23:24:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 41/42] fs: Drop mapping_metadata_bhs from address space
Message-ID: <acYigQf8HR6oRD9q@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-83-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-83-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: naey37mb4bguhje3xs8b697uwjoruqm9
X-Rspamd-Queue-Id: 8336840006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774592645-349912
X-HE-Meta: U2FsdGVkX1/ms5Wf71ziDsy9k312lbkRSz0IsppSUYkKL2NNCjAjdegYyITsRm8lRcNEE0zponlXxhpYAtBICmBERGty5czxbaUFBjuSvsliTM55iUtqBW7kCIfTwHBVOC7q8yVeP5EdUwjC7G4s5vZUmCBa8ihjiKjSHRkE0LbdW6DvP1bWrfnInTz3uK5BmJ4mhVlHkqQxGGYJIiMFizC4jrYd0dc1T2DWIqDgALdiHwhzhBXhHoxCKXH2ijL9wvnbPUCUZTRWcSPgoCalLE1pcnuWAE6grpS1rtforh7DGmaJ1srG6dMNzwcuv80eGzLcKp+WmJyJv8WqowZgg+VzXUDLpaAsmRH74OcVXGpjENNWeCNfyPj4s2HOQBOnk890qoCCA40oF15UzmdM3oUykk0kUCfV6rUdie6Si6Qh7ud4oPQATAlFOXZMJiU+mY1ejVqs9XcCEw/njmzJYue7Fh3TP6vyHixC40qjUMbx+suFGlqVECLXUkZ/2yjQERa3DTGHWjjgRgcU1i5VTN+S8Ge6WoNrfOxPCeQ2kBQXlib+TUL84JQmgW0tEW04pqi7nH26VHTaOozOj8ZST1/m4Zh2RBP6jwhMc/FWcnmkVblid3i8cz2b4LoTWbMjJT6LxKRbT4v9X4i4c5DMpLIVWkovaBMdggz8f9yNJoJ7mQg98wtozr/Sx8m+Py5NaFewyDdU5MVmIpt3Z7Pdye0ELxgJfMqKrErTJq7CIasaG7//yfwQIHixJBc0kSCIZnqLQAgeAN512qhIEArRP95LOuiEqKNmGJ4j4S9LAV6qaoQAJq7qVmcmUxyBHreFHYFmM4AhoctCsq4yLbSzMlEDLU45Widhq2LFA4KyZsd1iRDUNXeCXXxGVuUW7lLX2CW7d3aGfn9TI4iLKi6w32CRNEtPV66Y/+QlxiI+GwMzQW/jiR3DPTBn52PXwY3xxEkegGmpky238s23HDZ
 DfKDtw0B
 GuOaPMkrWPIEl9ZDInwprtL2C+Ep7KGLd43b0WLgr09ATRrm3+PwEm+5/4iTP7agL1bTsDKyhjy1axAgn98/aN5WNVwO+JfHRRpyrbDfCvfVHiRf2kyFoQ95d2XfLhcc/66RsQQsMz5d/NSnVt9LWNLmnb1RKqbuKbXMqLGmCFfEI/hV9gvW4lZB6Cuqz8Hx6JP4H6Zryba95Jjj5RsOP7mLrHU2Tu0627dV49C+feiLdK5c1C2ekcO42YNOwbDqBpEEwSOWtMOvo2lLlvn0B7dhCaby00PjtcTRtXx5DvavCLCYz1Fs6vGifIgm4qAlcTe7CWXwlP1s0JYBIdTh6asJpjMw4Vs/t//DLAB1e6fczKfYFSXZl6/bBoJboqSLWSN3I6XKvijZlw6DhlDP8Iojbbl+u69177obXZyrCa1g6C7/m5yREQmkQC2p5Uxg9/83qjopRiT6eNb2FtRyoKObJsWZ1eOiEoCMS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


