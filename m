Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672BFCD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5976B008C; Wed, 27 May 2026 02:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2FD76B0093; Wed, 27 May 2026 02:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF72F6B0098; Wed, 27 May 2026 02:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0C66B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:32:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CC298F405
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:32:04 +0000 (UTC)
X-FDA: 84812229768.28.CF26FED
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9500620008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:32:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NUzqHve8;
	spf=none (imf03.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779863522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWhD6NqGWQeaAF9weLMiDIdx5fT308tj+4gRK0S0CiQ=;
	b=FHicU0OOG7Z8UiTeRZ3UGym0bLlqWY4VbABNi0uzROfkK/oXodQUIO2K8Kf07adjpbmWYb
	szAJUFBJLNShHe35byeTEqPEkxV0iJZC1ywIhPkTDfIOLOWueN15vLBkspMEDnEromeFml
	JHjGcwcZY9GEdy3ueI1u4xyxr1HZoEM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NUzqHve8;
	spf=none (imf03.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779863522; a=rsa-sha256;
	cv=none;
	b=QcFV/n4Wx7gbcUSvPIagTH8awkLzU/fv/nvOluHDNvDyHH31HOVo1ZW4C7/Hj/+83VPf6M
	vaCpKnnWFK8O6m71KUK2bTdEq6Cp+lrEHvjKM62zCpj1H/+lLVEHU9q8CnN3nPsjuQS7zb
	7oyMUY7/thsRqTN4HFmJFzFS7WwXzfo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nWhD6NqGWQeaAF9weLMiDIdx5fT308tj+4gRK0S0CiQ=; b=NUzqHve8UC+23s3rUSjCC3Rq5Z
	KvOYLnH5KIouDOlaogy7L0fmNrUmy3yijttvpBzJWa34SwE6Ts5eOS5uZ1zQ1kwMkiH0FCTME1B5v
	343TQK3949E+T+zXA3en4J0yTTU2Y5tU6fB5QuMbUJd/5ETZzIpFVCEHjbHjZalxiwm0udRHofEPu
	JoJ9lz+Twd7M0Ycq+jimrec5bxUKNGPtkxkW4SYh78xE5r/tNgL3P1R+4wRRh5mkSL2rn9+oLSsUi
	pm7o2iyAxQC9R6MV1khw1ig6MyNgg3P6JHfeaFj5IfJeeQlXPWtEWzFdtFA8ygTTVW300stpZHCo6
	RoL2an7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS7o6-00000003PEM-0j4G;
	Wed, 27 May 2026 06:31:58 +0000
Date: Tue, 26 May 2026 23:31:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahaP3p1ZTBIDAuhH@infradead.org>
References: <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <ahYWKH9-ybDlZuJd@google.com>
 <psj3kr2gcze2yll5xdbvyyzxwcwhds5gh55poobpkfxrkpbgr7@ljdindismzd4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <psj3kr2gcze2yll5xdbvyyzxwcwhds5gh55poobpkfxrkpbgr7@ljdindismzd4>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9500620008
X-Stat-Signature: snemd6ajadgsc6ofwa5uogpytjzrgo5u
X-HE-Tag: 1779863522-999423
X-HE-Meta: U2FsdGVkX1/cHuFknmTyna8vkIJwV/4x8HbdXC8orlETwTtZHXJERTKHiZ4XWqEN5/FMHvED2H0R7jiRV8/Bi8SmMlkd23p2w6jTFmzZ28h/gxnPhwAMrqIVC55pmzBFk0msZYwnBNYLfGmuEDzc5ju/xsU250N7Dysk/dEU0s9NJQCr2K4iKsxGct7Le/kCC5ni6j46+h3ujKlVaxZAPSIf+c4r5Rc2wTyxE33lxJNqPEklCuOn8/G4/ggJnJF63bzHxbhfVM86zG6NtoMJZN1t/piieR9lYAMaGixNauch4FsMs+CAIdZ6Xn3k6gpavVG2l2fypPZL4A8aTNRR0/EKhMhAc+FqlRd5AZUaX0Ir1Y+4sJVY94/bs/X7V7ltnkCZDRdXFGGufopkjCg9A1zoAbVcE89TeXk4W1ZC21FhSUvMgmKbw2ZFBEoLecNgaYMrIAYKUQtFs+WRYtAlbVNbpG2mJ7DnS1E0BFCiBzLiEZ6UXjk69iQNTFFa0IGF0lOCrPNgv+OmTiplfWRLd6hfPKxyZ/QvPRrZC9jj6a56yvT9IH6hBVnF/z8y39fYceX67W+zeeRGiKKVbA6sXIDHCOYU8vYhZ8NAH+tUYSi7AWP7QO85v7E+c1hVdB/IMmm3rDpBfI/2iB7aNjM9UN0veWJZfEsbkB0/aZKffho8By3lOeR5Hck1E7c8GPxE1E3RsLEjngtu4eSqDHvWoYKw75Whm7iQ74i7kT0/nk+Pf9Bt36icHWWVQIxHQ9W1PPUvfAx7QSruAMHftql1uyZoEKD5cq1CCtPD4e/twYaux4jMImMOMGJxRa6RDL806CRRo3TrcgYYAZLaBV3mtl6ZezwRVgyPZ9ppBxsc64gqojOT0YTlegSOzVMv3oWHfOST+UrHYV/DIFPfNF/4yN0pPAo+12Eb9BDrzvIyJtPRgJp7Y4Q12cWb/FSqq7FzC0R3KBzRJe23+dzjhtE
 AVtObpgg
 zyiqsxNjRtqITU0xAaNUMRguoKb35s7j6pCQ616i18JjPONy8QA825yPzbQpKJfOg1UZ/No+sBAAU7sKPG2ncVKK0epeBHbv12Vibw5rJIuiOo+R1Pcl160fO716iA9RieJkiKuCWnqbiF7346lAdIHc56WDurzMiH0S/d7nFSayx72DgkJ2CXFGMWKYCeBa/FY1GOqTK0k54i1viQN/5Ftm6yUVoXNXkxuTCeL5iqSrPekLD1X4FOPKW+5ugB0njitzqyuSVE69w1+cOptV1NmTu3eQ+Git92kbCpQXVdmtp7oXzvnU+lbMTKMU+EqlnPYzE1m/vd/anfqvcNAO5gboaOBFWaGQ0UxNy6Upvla49EEm+OFy7fmVnk0LtPdjFDRI5wLWrji8NtQr9WxnemVgyhubadB3og+69VR/U+HFCtBS4qBVAtEcMRogNCnwxHz0FW2AqV5PrkQio6KpIcCxHmAIywkbG/8wz6Lx9CM56bFnAdmb0pq7XVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 08:21:43PM -0500, Theodore Tso wrote:
> The bottom line is if it's right after device boot, there are simple
> techniques that don't require hacking up the f2fs.  But in the
> demand-loaded case, calling compact_memory() is the last thing you'll
> want to do.  You're better either asking the mm to allocate the 4k
> pages, or do whatever compaction it can do to just free up 2GB worth
> of folios.  (Calling compact_memory() is overkill, and only makes
> sense in the context of benchmark / proof of concept demo.)

Or have a lot of clean pagecache using higher order folios that can
you can instantly reclaim?


