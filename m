Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD05F54AA0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7AB76B0089; Tue, 24 Mar 2026 09:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03936B008A; Tue, 24 Mar 2026 09:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA676B0092; Tue, 24 Mar 2026 09:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 712596B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:17:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1BCB3141581
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:17:28 +0000 (UTC)
X-FDA: 84581008176.16.051A2BA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id 86F00180011;
	Tue, 24 Mar 2026 13:17:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=c4MIb9Qk;
	spf=none (imf06.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=c4MIb9Qk;
	spf=none (imf06.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774358246; a=rsa-sha256;
	cv=none;
	b=Rtx/8YvJVDBmko8XI1veAB9GWpe5O9rMNoz1luP7XcR1UhCXR55vNsObKpoazXwE9qjhvp
	ny7Nudqy0092yDhXqGmzuVuVY9EMbnb7lPVzmsgyJjHDD+CZg6ARL+Drd1PJElDAuaS+YW
	nkOzp/0gwtoo9ycwUHOu1jOjKzaxM/k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774358246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2r2P0EuXUIpFebfcqs+V2aJI6SFcZOJexfLphbr7J9s=;
	b=yKumHDqr4M8jliJuyVtmV2JMmKpbTRq9nnyZV5jQk2UqlAaB96H343e1btmCm5DstJbfMI
	KC9Ll9bmyYu2/D8EQfRj4OtpPd14n63ayhPl4jCYzd9kqaxizazgxyz2QeyZliu5owj4RQ
	QXxBV18l7RaIp/TnH62HBS40TP3GH3Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2r2P0EuXUIpFebfcqs+V2aJI6SFcZOJexfLphbr7J9s=; b=c4MIb9Qk/bHbiz4wX6m2X6msJr
	oxY4CmAVyhXkZn2ex8skBdsVMy6D9fHjgZGKyDoZhixt+T6XNn4ZuCPCY4RodYRopRi6Up8Cx35gV
	ksmFcaJu7gz5f0Zgd6McYixFQc6T++IH/jHp7rATGG9fJIvVL2R0Ml80Ry/Y9cVKqRRPn+WPAajUZ
	tMFv8tbnZ1kC0DTmK9CGA9Nv4WNohsUA/HrMyF5rNQ353MYz7h1fSM0R0/niBS53UuVp3u5Y5um0p
	XYJpneQzDASBCOWBAFFFIOjxNfzgzXTm9A5xbpwlXZxSZ2biNZcmoO1+TLZNvnb6KcU/M2lMHEjqU
	U7uzKpsg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w51dE-00000001WkF-24HP;
	Tue, 24 Mar 2026 13:17:16 +0000
Date: Tue, 24 Mar 2026 06:17:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 12/41] fs: Drop sync_mapping_buffers() from
 __generic_file_fsync()
Message-ID: <acKO3NRw852FdGUO@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-53-jack@suse.cz>
 <acIjxUzWFstarlwv@infradead.org>
 <ezdm6d34jqdrcohk7o6wycxvvlgtf6aqenwx5ffr3plfagdbzi@gibz7xwr6yhr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ezdm6d34jqdrcohk7o6wycxvvlgtf6aqenwx5ffr3plfagdbzi@gibz7xwr6yhr>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 86F00180011
X-Stat-Signature: dhsijdxowtq8xodrwjyp5qwcx9u6gsyz
X-Rspam-User: 
X-HE-Tag: 1774358244-323832
X-HE-Meta: U2FsdGVkX18CoK1NlC8XTo0qseaAx2Sb+U2Q2IUNJO3TskGsqhLUVkW314OJXSbkxZCEB0Fxotor7u556OHz0y5P3QpxLJp1/8ZRVZkwDM5uAAbZdseBoMN3lRzoX3MMfLyJs8JSFEGNQTz5G2ZyVDjo6rS+wwtKmSnvyipi2sv015WgFkRXNtP+XkDY9352MMEzCT9TBLd0xy6ECpRNZbJg60Fcwd1B/H0esjfphFI/0MJfkxcU7qFQ2UoKLhRMSlKS9J+fg+Yuaih20OAPDggcuMBdsgs7JaEkXBW+sX1f62kyjGBRAbrE3oU15yhJlfnf2dSEYsPy/UftBu/PayWq+EVsSHKYEWwdowTFXInP7L1ah2RZy48SdZlcuDRfph02HSQDHxUSfPDiBAWX+RISIl1ntINogSdFo6SLy1lWCuvzcd2RknyFhsd66GqYvLqhFAZkWuq0Ks4po+961ABPDUtjdYujyyAsuumOt6au2fjdLFJOO7oVzLWYBYRT/E2AZjvuseURZ64bQVLV6QEhg82dS0stdqY3K6GTgPw0sCNk1bwlISxoqJj7+PW2ChQUclRwxLNAfz1WtNtKXJEbkA+ZYBK2egUrmjxAt9VLSQYqkrHm1kXkYT2wNQTaSKpE2k1uK/xciA60JEGMk6wS3hTIMohpU4XVP8gAs7bQz7Mczj0Mw389prxTHb7QgGzTvYa23bqZQZbMZ/yvziUQXULPdcedVM4tu5Puzer90gk0CioirUv6/Cu29nZcXSw/ewL/tQKrZeavcGTyuVPCWGb5b6LR32h2NeezNBJ5GZ0U3kk7Oupk23Zo+i1WqfuJeE5HNh1io/1ieECqcg/Br6pPHj3xElSHf5ZlqtUT2LAr89p9YQIE+CLJtEe/8CItqqi2F4nUyYPhn0wlnJWasLoEP4d1BY5WYhIrNyGjC2P1//riidYpPKcU/oGPoOD2c4/IKMjjMDXr3uR
 q54YPxaL
 C1Gfu77FExDIA2mPyivkr9Q8bwQPzKaX/d4Z4BPysetWNTQwpEO/Fv/cqsXh+RIaF9kJbJwjltLoeOhINiycFTDC03tor+Z1ZGY/yfuR0z2Dv4sEmeTZwH5NhgMYRychc51CIdO+fkXPv3PjW9RbETLKATZa73t9vJ1I9Xq6vEBYReQC9GcfS1V+AcWkwknJGCGy8ky+FMTeBRRPqfn6CKjYMN0JRgaVNTqVT4TeE3P/PHZDa4udjNF4P8t/b7C9dk+EaHV3ARvGpa+tnGriAlFoFrHnQWtsko6BjYc7vjz2yLbC1pbZYQKRRyjMdqBZVLGo7kCffAyud6GJsJUgQxjWTLZYgI3vCoRVQLr3pmp1/2UestGEtRa07IkjRHSXDtB2pjbTazVKcWo7aOZaMMQLrh/YtpitCMfXAfijAgRxGkESRg2VGB3syjfSccmCKyVLKGpMnM4YAtpSj8wdUwLZQIHanXmbGhCm2pNDNiOZfy31yU/0IUsJhT8wMzxFInQ0ekcZq79+I6h8fIBnC95Ggim/ZHhZlx1j6rnH+EkRsRb/jst6Qk6A89eknDHZNDuMcXn6qI5ZmziN+BWS5JnyHHeA7BiunyhbsGAjp6nvddsM1w0eXdrgS0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 01:34:57PM +0100, Jan Kara wrote:
> I'm fine with simple_fsync() name for the helper with the trivial behavior
> of writing out the mapping and the inode. Code wise this will look somewhat
> different given what you've suggested for the last patch.

Yeah, the pitfalls of going sequentially through the series :)

But sketching this out I'm not even sure all this makes sense any more.
Maybe instad of the allback we should just have a helper for checking the
inode state like:

static inline bool inode_need_fsync(struct inode *inode, bool datasync)
{
	enum inode_state_flags_enum state = inode_state_read_once(inode);

	if (!(state & I_DIRTY_ALL))
                return false;
        if (datasync && !(state & I_DIRTY_DATASYNC))
                retun false;
	return true;
}

and otherwise just open code the calls int the two implementations
without any callbacks, as it feels cleaner to avoid the entanglement.

This helper might also be useful for other fs-specific implementations
later on.


