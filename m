Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 668B6CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 04:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AFB48E001D; Tue, 14 Oct 2025 00:49:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9605A8E0005; Tue, 14 Oct 2025 00:49:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876218E001D; Tue, 14 Oct 2025 00:49:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72E088E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:49:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0264B11AA58
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:49:11 +0000 (UTC)
X-FDA: 83995490544.27.1662059
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf23.hostedemail.com (Postfix) with ESMTP id 760FB14000B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:49:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf23.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760417350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/EGNBewWlX776z4za7Ii5NXJ1S+NChZ3ujpMAaM3D4=;
	b=uzdcpkgH4KuR5A/0/vZcGCKztZYOSubStHXrdyTlk2mcGPHT72PoxVEDoedvyJNG7ZXgDT
	J9ZHtAMdqyMnNcdjsbUVETWhO06r9IDfd/IaTAn8tRkFGVAdcCcSw+tWSzGr4lO1SzumYi
	O1j3ch3Wtt0qZ6Smrw5Z3GL4TzZ65hQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760417350; a=rsa-sha256;
	cv=none;
	b=pzhmFaLXGlq0UnIsqhecmVOJiTRCM2x2K0maCaP4GmDhyUrUIH1f2ydIUifXlfAj2iaJt9
	f2asAFAcxPCinK0orNxdqFab6QdDwMTQejAifEPN7zY3oOyMtdiQ38sZL/oby+WJdFvG20
	V58UmsxE5HJiRD8kmgzqhMGB/KQ2vhY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf23.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D0523227A8E; Tue, 14 Oct 2025 06:49:06 +0200 (CEST)
Date: Tue, 14 Oct 2025 06:49:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Hildenbrand <david@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org, v9fs@lists.linux.dev,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 06/10] mm,btrfs: add a filemap_fdatawrite_kick_nr helper
Message-ID: <20251014044906.GB30978@lst.de>
References: <20251013025808.4111128-1-hch@lst.de> <20251013025808.4111128-7-hch@lst.de> <41f5cd92-6bd8-46d4-afce-3c14a1cd48dc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41f5cd92-6bd8-46d4-afce-3c14a1cd48dc@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam01
X-Stat-Signature: jd85b3sztme4qxphuagbsp4fs5w93t8k
X-Rspam-User: 
X-Rspamd-Queue-Id: 760FB14000B
X-HE-Tag: 1760417350-756173
X-HE-Meta: U2FsdGVkX19YbPea/plGiA0DJYVHoLfTPe6vBagIP0Nr+fAbqn/tZPbOfZhNxMdi6VgDdSLr4awGhM2lb+tvKREPkhm+Ck8tylWTkDYRocByoeJgJdjam499AJewEinQYdxak2f0jy6geIXLWdP5uS9BTPMhfE/0PpT1axfErEvcZ67XhmgpEwWNXXmSOsisHzdCDqD8vHRVwhSCJly8Osscg7+yYGLS6knM8MaH8srblr93BQglcnlCN6reI6TzH6sQRe5c/xpPwWyVNLKUkhTkoUsEu9sQR1sIaH3Q3j0Fqj1AII9FIMU/WQ25gR9/zbw+GUZGom6RiU0sHSLmxB6roDHZZOZjNShQZxlBoLj2NYotIO/lo9BQtFyN/pUFatSZ4hN8PR6Xk+rJI5ztI2qEPUGfRP+1L6ZTPKnG9nCiRj+CxJOdrbAMrfB9ABnw6nB4p6vQma2FFKE+VtDaTOeiUTSU7nzy3eqwCSZwvNvPMA+oMUFRW8nVn/9n5b8F6kRd/7CQs4NndFnzQsEh3+4v/Nu/8EZJTa3lq7TPhUlF0nAPSs8Ol8VG59p2D+Yfvk1nJ3t851FpJVQpAOufLU+zM2EY10FQfznaFR6F8Q07E6xl9sJZ+GpnccassuMOn2PxnCt+ZwE0rFFRMoy82BEsb7vlfXuK7R2OpI4d2Z2r18JISXG30mgzCnSKusB/7igXbJQJAD5Geb2sd4XEL4mxHa3s93EE4ZsJsTznBLBwlhl+HC3DD21skrj5UfpnzpnWVInrCUMBtcsQ/1ihT3816apiYd9OThSYjPBDbhMmEZaKB7ta1z4Rb+++hOItX7h9QAjLvOpT9u4Yx29tVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 02:48:48PM +0200, David Hildenbrand wrote:
>>   +/*
>> + * Start writeback on @nr_to_write pages from @mapping.  No one but the existing
>> + * btrfs caller should be using this.  Talk to linux-mm if you think adding a
>> + * new caller is a good idea.
>> + */
>
> Nit: We seem to prefer proper kerneldoc for filemap_fdatawrite* functions.

Because this is mentioned as only export for btrfs and using
EXPORT_SYMBOL_FOR_MODULES I explicitly do not want it to show up in
the generated documentation, so this was intentional.  Unless we want
to make this a fully supported part of the API, in which case the export
type should change, and it should grow a kerneldoc comment.


