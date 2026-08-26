Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA0FC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174CE6B0096; Wed, 26 Aug 2026 03:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126AB6B0098; Wed, 26 Aug 2026 03:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C006B0099; Wed, 26 Aug 2026 03:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA6F46B0096
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:42:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46DB01202C5
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:42:22 +0000 (UTC)
X-FDA: 85142627724.10.FAB2C7C
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf28.hostedemail.com (Postfix) with ESMTP id 76980C0006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:42:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787730140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EBw4kRen2wZza9YUsJTSJgdSI+nBICOSbjg2q6aFv9E=;
	b=vhhCDlx+AheuWda9XVEw14Qu7HJpI/pvO9oYWUkdWwxelBs66SSy/v5NMM4QZFnnwJ9YEn
	ZXSLY5mLEaPS1VXY7U++xW2a5hzKLrFpDRo5j7A03R5WWNcYEv0th+9lltQkPygBsw9hS7
	Uo1E9y5kKbf5HpfzTOISoqQQFQlFASQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787730140;
	b=NUvLbmy4m6uyXAZQvBciwqgP7mRjMXjMgmy9GQ5bpVOG5r5xwFoaJBLyD8Dk9nIcrNQiTU
	A4qmmtcussLs7Y+QkZOL1dDHCE/45yFez4iPjI0KRldZWYgd5BcqOqvkZcUsPeL49ZrWBZ
	qk1Y6o8wHMreLMfw1u/sqL3Ru2ROXOQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AB4F268B05; Wed, 26 Aug 2026 09:42:15 +0200 (CEST)
Date: Wed, 26 Aug 2026 09:42:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: Removing ->dirty_folio
Message-ID: <20260826074215.GA18668@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com> <ao3y8TtEGjniZ_4f@casper.infradead.org> <20260826050733.GB15122@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826050733.GB15122@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 76980C0006
X-Stat-Signature: n9cxytcp15xjpnncwtqje31ic15syhch
X-HE-Tag: 1787730140-976872
X-HE-Meta: U2FsdGVkX1/YV2lKa9BTygop/+1A/V+xSnR6j/3EkKn83MShVfiXue3f6iFv+PfV08ZDV07JsLfjuePpkipIp7uLf6El31m4qnMk+gdgrEPrR8h4VK8eimdCBQdB25Bzz29T2bdvMkP6lz7lFj+9ucXxNeqgOZL19ozj8Jo6sSrFtnxf/YjXZ/gX4+0NMxlZx8CHGp5Y4KbspX/JCY04Xdz/Uv6mBPOCa+JTuto84wPfpCPEbUugkeE6FayfKNOmXEGmaFHFcpS9YTV2IACsRMhQSUYlgONuJ/vv+yYag67hsHw2PbtclDIy0p9j5RdAxJC0a6JL5L4OXWIDVnTsez8XQWZW78xQRqcMT4uFRfaZ2fqbHy0XIraOsbqLaImrXZvtR43+vbdoVp63oR55EIePpgzuP1e+2niJ5ZdznhFcXiTwZKrxcgTROcNWzuJPEgRcxFylA6thVmIdG7/4coiePuwNTgHu75zZ1+svXCsX/cQ9sKiLf02/tMPavOsUcp/gP3mmGXZNyqFV0Mt2K+DODHH6b5WywA74SiS1uVqw1kPufsBMAqvd7OwmZ20hkg1IovcuKyHxhG3CmrV8KgLsvSKmJwv+NW4HW+ri6RxnsCf7sckVL5P4HhGBQhmgSVWRDbuDi12Oy1NjdEU578j4LeBydtN5/O7TgOoV4icCTaYAKvfyCtxiB60VaDjJXdI3cUf/zTE/XqdoK7ZFKmHPjyoptIuzSjpf5c0HrouZiLWXtKrdjFij+3iVAGN6t9argtbOvStb+wXtQpqVVfPf+r8ubzK4hBbR5WM6vniqVvIf1SA39VlsH6cUjah+2vhGCxAvRGXrShqMJo/Ls1mQdtFJie5eGFAYxLncz8uBIMd2FSDMo+8Wbc9ZJ7zLGz0z/wybj6BtHmYLGoNQ5z7f8fDdrXahYbJdF/sFF3/eucry+iacCyqg3Qfjf2wewK/KjuOhjOzwXnBxHbg
 ArMwzn5Z
 tjoKLQ2eORIG7Ix85Mo1s/XVd6AKPguN1gAeH2+yUFw1uordZH239JDpr0DlL70zu9hM10d7RDaKTta1mu77eYT9kcw9x0S+9AsNzA1HY2kLCefmJX/3xQwr/uKqjg7re2Z7vDe07xV7GqHo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 07:07:33AM +0200, Christoph Hellwig wrote:
> The interesting case is FOLL_LONGTERM, as it can pin I/O for a much
> longer time.  And that also means IFF the user of FOLL_LONGTERM actually
> wants to be able to persist data on a shared mmap, it has to manually
> dirty folios one or more times during the FOLL_LONGTERM pin, because
> otherwise the file system would never know there is dirty data.
> The set_page_dirty call in ib_umem_odp_unmap_dma_pages is an example
> for that.

... not to forget the epic boss of this genre: vmsplice, which is also
still using get_user_pages_fast/FOLL_GET through iov_iter_get_pages2.


