Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6008FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 12:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E8376B008C; Thu, 30 Apr 2026 08:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF886B0092; Thu, 30 Apr 2026 08:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5096B0093; Thu, 30 Apr 2026 08:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD146B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:37:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6391BC0B47
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:37:24 +0000 (UTC)
X-FDA: 84715172808.08.444AFDA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id C338DC0009
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:37:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OVEuy04Z;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777552642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/YmOm364MLgKTekAQcMcyvI8WeWgw/tah25yx/smkI=;
	b=AObXCRe9bVbDFH3RvoqKBabGOkyb0BS0eT70zso6ypavElKYebPOK1k78QgqPQns3qs9N0
	eu/z7vlWlKHWS7Rr7Ba9wcqVnSokCgbgpDo8uZ61Ub54p8tls9lWrJ4gUP/oYPTDsVNnyr
	HeDXiUio5WO6mUOMintld8LsziikkGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777552642; a=rsa-sha256;
	cv=none;
	b=qIlcC3AWPinSx3g1RQuA98+pSJDWyC2UB8QmPBjml8aT5rMmtGk+ry+aSP825bXapFM9zI
	0JEyHSQmvHqdrnIJuW+h5MQ1w/G9JUp7l79vpdMuyKgvMbB+yWJb/svEELdf4lyq13Mv2w
	mvhpp4B4kQv2PK7n/tU7bnv2A/irs2Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OVEuy04Z;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z/YmOm364MLgKTekAQcMcyvI8WeWgw/tah25yx/smkI=; b=OVEuy04ZJAcBaKwk8cxrvq7Tt5
	XT82G1jqIw0PkdnsdUVlw+7QCza/twzfpnsx2kAqSxg7PTBm0kBexRmE2xwQdNMnRyEnteCqgWzIn
	pGkT+4EL2ASd9E3W3zW7yYDg3jwhiv9VQjK8KHyhy+eeJpz4dqkaLDP6PuXP1J2eRrmKWTk8F9tKW
	CawTIBqH87INZkKlSIMhv2zjWwFJnSYo+4xe4HesOWqi4rik/G82R6PqrkV5YTcbPWHu29MwOaGgj
	jzKa0vAXrEAUkOYciTPNLGggQqRFBNNvsXY3E40Q+hwIcMj9vZmSiwG6RsfdSJ+eO9OpzQbCzsngB
	wKLRaGvg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIQdn-00000007Dwg-0sn0;
	Thu, 30 Apr 2026 12:37:15 +0000
Date: Thu, 30 Apr 2026 13:37:14 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz,
	pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn,
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <afNM-gIqxpyJ6ro7@casper.infradead.org>
References: <20260430040427.4672-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430040427.4672-1-baohua@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: C338DC0009
X-Rspamd-Server: rspam04
X-Stat-Signature: 5igxnwqm57saobypsczjnfog1mo19ui5
X-HE-Tag: 1777552642-868833
X-HE-Meta: U2FsdGVkX18W/aZZ8sJ7dlnw1j53LlDR/u5O/cLMp4jslL5y+miNZmAM0BjciiJiZhcAwsjG+GTQSQUY1KC476xFBlLfCQAOXj9Irf7OQkNvGPYtiNjrj4lviNJXf9XH2c9nNCcGmE0IWiMmqNgu1Dec7o58rF6xm0GUyYdnUtpFQqFsqdymJWN2XFmng/y1Q0Dr/Jr2ymmpUhv56DcRSdOPd3WdkwXPNt+Rfm0yCNiQQj6pGdwi30aYHNeaDowZkCmbQVm6E7il9ft+1VjKPB+g3GtsMINOyiKQ+Kn07IGUbw+F/4lKQjiY+isxweSzT7JiwhVO1uap47LcgVUqtHj/BXcy/WIcpDHjlvS46WP9A0oCvgrb8zYzSqQZ6DzwQfNEZaNkj+z3FMNBL6Zq1qhGpUsXeoEYjrSXRSBHdoL/FdtyjOVnzUTiZyEtzwDSf/OCHCdmJ4NAdciQYYYOl8EpLyv5dLNE4p662t1VCSPSBXHqqPVSuohCj66BIJFp30H6R9nI8UaZh9StAhYT27UnZwjmD83R3FFrW40DihPEnacHyLhsmpRiaAFnGvX4TmToNG9P/pXWm4jbTgud00kWLJ/BL2/v9qAlCXDB2OaJTAcJun0mecw5YlFPMmXysIVVfoo83nY6wzz2JzT0SZByy8df3htXgOC9SEjGB+zkTFLymCuaU83ALRy+EOHxeEckGxPToop1lv/BsdriW10R+6VP83G8GiJXtQpjamjZKmNu6XJR8Fxv2g5pIJKOqS/o2UbL6uQwC8R1lumpQ+jB8jK8NbWCsPVhcNImeq56+8bf4SXgU7LAYSGDZpSFRwifmRxFThKE+oZhsKqr/9AhcHVSGPk+Utgy+DpkTEqfm6EfVJDHI377NZPCw24DhnXfutNjPNUb60RKFj/JSBy7LgFqFcKznLHEHoeqCNh5qPIFqirsQpofO2dQ4dUf/OddsabD879ThN9NnKN
 AbdK//jo
 2vAEa1s6eoJAHM7W9LDrEyoeuM/F1EzDlbzVn0eTXyqyPjIj3YWk9D4Q5cvah7z3fZbhz9DPG5H0nuhVg35U+GHMpkdrzb2oIj4Fv6HdpVICTHjv9EYdKtx9ka7rSjSiB+UuJeTECVjxi9BaGSgF5/2Z22Oj+hjGXWwi/vwnU6jvpRUTGZ2Gbd4S3HbH0T7yAY3IUV9IKq7GXpDnu+d/vv/tGsvCtv3eOq+Q8Z8ypd5U3BO0s2p5XtylWyFRoO37Vfrlwn0eHCeV3phFWaeAeufkkENb6X3qibeagjaNQVwa8EGCDR38cuo/0vIE1xZvNwFFRZZdK1TCtPhhRuO0Snae0TSjkAKoUaQkP95jXOmyKqXkdhX1WV4ye+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 12:04:22PM +0800, Barry Song (Xiaomi) wrote:
> (1) If we need to wait for I/O completion, we still drop the per-VMA lock, as
> current page fault handling already does. Holding it for too long may introduce
> various priority inversion issues on mobile devices. After I/O completes, we
> retry the page fault with the per-VMA lock, rather than falling back to
> mmap_lock.

You're going to have to do better than that.  You know I hate the
additional complexity you're adding.  You need to explain why my idea of
ripping out all the complexity now that we have per-VMA locks doesn't
work.

