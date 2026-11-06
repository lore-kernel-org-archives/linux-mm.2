Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 029A1606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2140B6B05B1; Fri,  6 Nov 2026 05:41:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EAB56B05B2; Fri,  6 Nov 2026 05:41:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1014C6B05B3; Fri,  6 Nov 2026 05:41:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1B506B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:41:28 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D736680CEA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:41:27 +0000 (UTC)
X-FDA: 85404352614.26.43EC7E4
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1387240003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:41:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793961686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y2B3K2s4CMkhzGfN/sXBCg6vT5zF/XqqON8igl9xOC0=;
	b=0vtYWLPETn5CyhciL/OgIcJEIWT8Y2/8vz5qoIirUxNMdNWUNVwvg4OsIycLytc8oexeHg
	iGXRaXXpUoC6DH8Bx+Jdx11ljqfUsvzqavCSb9bvao0CxG1VcwZZSQGddwPtzGKVTh125O
	QBMEeUbdWufD/D7rUy03oCnrzYBTnzo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793961686;
	b=oPYx9ZQrBzyN7EptBJNOTGLlE9Io45qv3/9Oj3UhszcpNRXqhPDSNzJcV6rzQzTlDYP3ZQ
	APUL0boGYEv0ezQ8gnkredlM1aUlOiAQz1kxTf5XkEeHhw6pfc40SamqzuTiwPLoFAppka
	ljPcbdNpsRlSIWygSEbNTUVOtD2gHt4=
Received: by verein.lst.de (Postfix, from userid 2407)
	id E6E2C68BFE; Fri,  6 Nov 2026 11:41:19 +0100 (CET)
Date: Fri, 6 Nov 2026 11:41:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mengmeng Zhao <mengmeng.zhao@linux.dev>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, asml.silence@gmail.com,
	hch@lst.de, Anuj Gupta <anuj1072538@gmail.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, Li Wang <liwang@kylinos.cn>
Subject: Re: [RFC 1/6] block: refuse a dma-buf bio that carries a crypto
 context
Message-ID: <20261106104119.GA5668@lst.de>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev> <20261105065847.196540-2-mengmeng.zhao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105065847.196540-2-mengmeng.zhao@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1387240003
X-Stat-Signature: cbtq761yr81sxg64xxbh8xc9788hbhpd
X-Rspam-User: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793961685-978447
X-HE-Meta: U2FsdGVkX1/oUJVgivrhzj+QVpRBkm/8z/ocj475hK6Ct0BDH2ZIQL+ADb6WGS/b/EHDMTtUZ+8+9tjE1ybMjW2T5WYT9jmld3Aur8Y4VQGpHHVJTk2r2F/+MHiMSGS1i+MX7+J3jbJkPUbJu7HqEOeMOnrGN+YJCw4PTWN4OcGTue+vpesxOCucH0YF6nK1HKhxLqZpY/41n9TZze9G/VoRKmYDifEtD/tW8SXRZXAqPwvUb/lwmRpXRz6L5i/VnqDeLtNGpMuMiom8MQNKMqW+6Nf81RE3dJuKbSxOD2c6N+kfdAz7fBNipY7pHsxp850DS5gWmiDEEWK47Plws4qPDeJu3tvVcW8uDONnqknErrNLfGouC+QO31alcjCwEN0tEeLH2oDOjf4Uh1Cm2kYYvvr6NAq0qwxtJpEC1bHqVh8YJpILCNIFtepZilusbc75DLyjEebMRP6aDvMIqIOS9zgi0g0FHnoUmec64m9S9KAIuzC/+EPIBFqQP1JzX2Qebnojnefe1LCNhugyLtwzSWmIm4eB9TAngQgDYBbngHQOjQAQHKOY1RpFwBdFaETMnqAAHyQO9fj+WVoDJnmR5Qgq4LiGQsWQuBzJGR03iY97FpHBpA02IVdcy3LE18doaL0CUqcEwPJYhOLCNhO8uW5YxXtZVxiXrNzIKcbXTIOK7ed0kBoUtFPylqpjQ49TTOLwxZgu2oQHEjJfDR2uEzzdcm2r+ebojDj7s1JDrbrPIXmMSi5Ja/his/j01EHrKTMAdr5S6iR2qBlJALFDhkeSoN9i73+RO7RNw5EeViJ+NvEmvENKVKEsr+slGRGOc/WfXsdT/rlydTKfm564hCgOcJWipmDh7qZ5L3semPZYu7cDyC3pKJ1N7asqbiakRxrzCh1mZJsYh0z7sF/5eED0YVEJSvTA9YectqEnbA6ah+vfLXcvG090H+V0tZJ6Q/OB9Qf1DH+UcMg
 xLdTP35I
 dFhXaVykzAsLJCZYqYw+by9SPnzrper1n9hs7EpV6Nd9MCEOPsqGwH6gw/rkJBrBazJ+HQYpDTfqNu7MZ2PZp4r32XnaeJ7gJS/8L7CBPYkFQzSDFupEGWuMB9rHw4OpkJjUw3ltXqfhPoyjog4kLZvcr8/RnsWZLZ5D21z9GH0fgipw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 02:58:42PM +0800, Mengmeng Zhao wrote:
> +	/* a dma-buf bio has no pages for integrity work or contents crypto */
>  	if (unlikely(op_is_dmabuf(bio->bi_opf) &&
> -		bdev_has_integrity_csum(bio->bi_bdev))) {
> +	    (bdev_has_integrity_csum(bio->bi_bdev) ||
> +	     bio_has_crypt_ctx(bio)))) {

This could really use a factored helper explaining all the refusals.
And maybe we should use the chance to sit back and think what else
would blow up and add it there as well.


