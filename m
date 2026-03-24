Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47973F532D4
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3C76B0092; Tue, 24 Mar 2026 01:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55E46B0099; Tue, 24 Mar 2026 01:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CF696B0092; Tue, 24 Mar 2026 01:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4396B0092
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:56:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 11A8114156B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:56:38 +0000 (UTC)
X-FDA: 84579897276.23.FF63FDB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id CBA80140004;
	Tue, 24 Mar 2026 05:56:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VnGsK9o0;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774331796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtO3UkezvPYDI1WseWZT+CQteeNIipdQ8FHfP2vxTes=;
	b=yntJMFYd65EVjOAdI4omJ3FxucSMDDTP43Pq6t1e+ADOPD7XMH4ooO8QpSzMXqxz93/ROC
	sYTMydjlFooCjcyz7qin7q/FjgoRAMdb6HrCM0qfJEtb1TG8/WC5rhyhZnpA7cV+OYL9mu
	X5tLRWwsIjBX/uLmnWLH41wydPkrBc8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774331796; a=rsa-sha256;
	cv=none;
	b=sBJj7KJgJGXeQ0zpsbY3jBGcqnWEpfjzPCTHP5vr9v5Hjy8QXRU+ssKGFpy8uCzg2WIxcj
	R02U8rXtjj33mpcs03bCOp5sRrK6bEIXooXeILu8MvOxXb4N4Q7j6oUzSp2lu8sU6zU3cn
	9FYiU5zBEPD4MWsjEYG6T0kQdXPaImI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VnGsK9o0;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MtO3UkezvPYDI1WseWZT+CQteeNIipdQ8FHfP2vxTes=; b=VnGsK9o0awm0/1LzaVAbykaRkw
	qZDn4CDccSHCQiyLLsYSKCs1xHas4u9P1CpUmZMFnOO6qAS5xYwUi2Eisf2wzMuDKZ8sc5olGjvMf
	40fdgQnRay2l7/FL8S1+WyeQf3fSMj5CZxMslBWSABpvxhmL+7cg4uYS9y7uqHvoAwXoHcX+WgHf7
	iuguqbxqwODOSesNkJkHbtM02yFjpAcnJI3ZgPr5ZFVSTzal78Sw0YTko04XwYvDi5x2DWIle26Rd
	dttrRYD7Jj5ZAzA0oUVF+Dy8pl1LEb0eGQlgNz3L6sRF2gYJesDj1NSosj6cRRm5BHvGMXzrhXFfc
	jKbz3UMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4ukg-00000000coL-40EL;
	Tue, 24 Mar 2026 05:56:30 +0000
Date: Mon, 23 Mar 2026 22:56:30 -0700
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
Subject: Re: [PATCH 41/41] fs: Unify generic_file_fsync() with mmb methods
Message-ID: <acInjoDTJAz62eUp@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-82-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-82-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: CBA80140004
X-Stat-Signature: jsjhky56rodm36ekpig9gitgcbpod39m
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774331795-294398
X-HE-Meta: U2FsdGVkX1/UPnEfCH/vjzINZ2IOP7yg2VRlQ1xf6xahTpCz1oZxeCBkjN95Eccap/ed9r7iKKDp+P7GYohOhH1ZyjHGXIwto6h0xw71ZkTFP0k2jKR4UshLZFL1hO2TUt3qH4m9cJIpK6ynQVjDz3xlVWBLENvG5XyGO8caoog5EchiwIKFTMQy9Alnh6nYcAh2GUvjM2FsZhKoJuvRqRZZ2PRe12G6iioT7V316eNuJmavwO8M3uuFZp6oy8nsYGuSmnyzRiko6iDp1JQWBYpzWIFLM0U4SXXjL3ffZDoOGJSB59l/98oE5ZuV8yJE1d6Eo5LL/Mpm6HHJvwTXmzaN1VzXYtmi5P1tsyRXHAeAeUhOszIB3XLcBfAk+VAJdA7YWbKFwR+Fk85LIPOn2080s7WF6b3YiwaX+kiYjV0Qz4MNkdJ3FR5k5HmriCHbBgt+8pcpgfkEYNEN8kACDQnj6lwVBBCMnAXGNPFI4aTx6pGVq2mj7AZ7/0y7gSIk0yUnYcZU9i0/Bok39UWKVl8yvd2PIrpJ4WD7DwsT+C55lPwA3SSNFTe62F+2sPAK7ALeL5PcKXy3Ke9zXkR7UFQ8XNp9Bc2Fd2m9sawzvXDoCeom4jyRQbt4mhYvmNDTEHTm0vGSEeRJ+ZnMDiWjKIr2DRqJ/UDwMi6ndPxI9D6PGH474efNCim2wbZef7j2Si2s7Ahny7PMdZqJeeEHOW0Uo1DmfSgQTJweq83AaxLq2bDxons/GanU8MVzFzRen+EWjCkzTfqzplstTZyog1r26Dixclg1MILXqNuvkwFua6a0CLI9aF/pjRnFHoOjlgWU3oN+MI1Lj0wJJ5m7qs4E+C2Ge9PaK0lOlG4lh0XX3l97EM6gj234Ky3+3h+sVgUvHfO1/mJibyduHfcCEVWyZO8h5Cm5yDk44SfNHAMngTvPQUnYvzX8GrgOcOrv4lzPzuSyoWYhfB687De
 Zc3oSFN1
 yMey88IUhky4fpq5O2wU0r1HffoJqHsHmyFlVeC+0BrVipMqLzkMOTGd7bmFq5OIFqK++99iZ3MEnFDjEgAZMmJ2TxQjVYU2U/ygd1DAOKpwyvK+di/sugXkQRr36hqIfGYcXe9BM0gQEGaanqrcpCYxWI4SMM5xXK6xSUI9EkxFfFuAzeKy0CL4/J6RKWskMwk7H7UKRe4SUuliX4Zp3V7V0Ub9Vq4TmwAwTNFvITsCUAa477Wqg3XwHg8nqjpaekD1k2U6WTheYO11F9l+xDucEp8n1VGlbCZnNqz5Su2/VE2dwIKIpM2+gME/Gboi+fznvPowrXI6SHeZbVp8PauxeQsIvVQOblT418wthXDRiqbpSXbxjVnWSOWr8ioV1FxmKjHhMc5+OPD5IoJxUI/KEZa0N82gUEAVxskgh7+DKf3Jgmrek4bpan6nFh+Og31ay0XSaXblK/FtvcAAJOtcEw13Ft095wpt1TvJCuiloLY+VplOidNkx9mJ/lqHPtZr7DtpiI3vKHDHbycBqL7+6+5dJHEbI/UeUQf7jXwdapSiEivcnd6+eyHDmyCKUYuFhBGNUlwMqg1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 02:41:36PM +0100, Jan Kara wrote:
> Taking inode lock when writing out the inode seems pointless in
> particular because there are lots of places (most notably sync(2) path)
> that don't do that so hardly anything can depend on it.

This is really something that needs to stand out clearly for bisecting
and documentation.  I.e. make this a patch on its own and preferably
before all the other refactoring that already is affected by moving
between the implementations at the beginning of the series.

> So let's remove __generic_file_fsync() and use
> generic_mmb_fsync_noflush() instead to reduce code duplication. Arguably
> this leaks a bit of buffer_head knowledge into fs/libfs.c which is not
> great but avoiding the duplication seems worth it.

You could just pass a callback to the generic version.  The cost of an
indirect call should not matter compared to the rest of the fsync code.
That would also be a nice thing before all the renaming, as that means
we could add the version with the callback first to unify the
implementations and then the file systems are switched away from
the buffers fsync variant to explicitly pass a callback, or to not
pass a callback when they currently get the default one.


