Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 202E1C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28996B00C3; Tue, 25 Aug 2026 09:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD83D6B00C4; Tue, 25 Aug 2026 09:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0176B00C5; Tue, 25 Aug 2026 09:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94B586B00C3
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:37:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06C18160425
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:37:44 +0000 (UTC)
X-FDA: 85139894448.28.C016BAE
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4BAF880009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:37:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="nJtI+U +";
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787665062;
	b=aN6OOMuRyjCpqV2zXhriF5j0pd4jyN15u1/8I8c7aRXG96gkvGvRYqPQbvxk/0jUyULgfP
	f0N97EfvuG2MGNtDPYJwXPrMC+o344FkTxZwz0h1SSfvLCEYpAswa4kiy2LBE3o0lDY7sL
	aJmPL2thEXeIZdzso6RfEXWmnb0SnWE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="nJtI+U +";
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787665062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCW1SrRc9TdfDbK0btXS320EQf/SwGeEdsMu8TkCBi8=;
	b=wucxDPMfY+pgjcYSpdZKmNN/s5DKt9BAnQ5Psv7E+VyxXTwLx8znNmO0nn0ITal6ycYtnS
	YiC6rvHRzlOAThXxkCu8v8H36ohsP75b17EC78RyuXOOOLqRqMOMohpLSEL1/ww51FKTKw
	oKm88JpjhZrZTXiCf9QRRGy9xWC9f2o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=pCW1SrRc9TdfDbK0btXS320EQf/SwGeEdsMu8TkCBi8=; b=nJtI+U
	+skEo/xtAPNWY+Pt/aZ55afKPl/U9qwxu+GZvWaL5oKWwGKHChMkl63naXjMRF2NPMrgEL7jQVnlV
	TySRY2nVE/aCJMdcjOg/HlwxXqaZ6Z/toX9y/ZxkkX4sIx4yHSWwjPn299Pi1FA/wiM2L8rO9nX3s
	hS7eRw4ernxPTnRFK+9WX9POFKleZjBl2H6VWZXjlofGHuB1x935cNJEoeeU17LoTsXeXZ0lcXHda
	5nuQwE9GjbSrgwtGgEla/eG2pfXC4B1Lf+MtEDqedKHUyeQWPsvfOQrJfjLG0Zcc4uG0UFv7XJfIP
	xEx7O6lFYT5rhZpAgxLbn8pW7GvQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wyrKv-00000004DAx-1RiJ;
	Tue, 25 Aug 2026 13:37:09 +0000
Message-ID: <a10c74df79e1db6a9a2448220fe4c4fd6a0e5bdb.camel@surriel.com>
Subject: Re: [RFC PATCH v3 0/8] batch lookups in follow_page_mask()
From: Rik van Riel <riel@surriel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, Andrew Morton	
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, 	linux-mm@kvack.org
Date: Tue, 25 Aug 2026 09:37:09 -0400
In-Reply-To: <ao1JwEAeNcP9OyKR@infradead.org>
References: <20260811025157.1632867-1-riel@surriel.com>
	 <ao1JwEAeNcP9OyKR@infradead.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4BAF880009
X-Stat-Signature: hnhcc57uxjkh4ku4mp9z9jrmzgs1pypr
X-HE-Tag: 1787665061-468959
X-HE-Meta: U2FsdGVkX185YspbUd6zGa9IfoWSkL4dqIj4O7+KzRJZPQL4oBphI2E+/aDfkIY34qhHFjFI3aNY6gWhDYCnnsyYuOWoyQFsm9J6bWTSYQKMBJyihbf9y2Sg5QfJv7RDAO4OjoshfmxiOs3GZky2w3N+ymjWn9upAmaHq1XNNzvch8LBOVzMrBIHTnn/n3zu4JnZG4Yu2Rv+B21bJQaXB3yS35VqDWLKE/zQkIBF3dXv5RwzJCaw23U7X98WfmzOKjDuIHH0C09FjsVSzwk15bk5NSoPwhJltkC/0o7eTmJ9hBK5b+096OL/iZE9GupU66kD4mSCXvvQLhBqmRyBVdQ8QHkKbx5x6hpIL06i9Yx+5EKWbQaBnd6Tu45JFiHX7pyTo4cXEMWvcHbliWNSzTb3KFPx2a3wIFOtt1I0hPMGH5VNV1jPi55k6+zejP1LywiTD53EPky2V049EDQpsw0OZym21amyy6eaoLWVMcfglSVxnvxg2XCr2zGHMt4rOtfqBeVXcA2GvNouzRmiXh9pw19/x9R4EiztSGVct9U2SOFU8CQd/A1VNmQYYcBuPlrxg4iNgXscfoN72ljmcxPCXM0+/I8cVmi+8nDZTKpxEFK3BPtT7SBeRIAorVM4uIPXuPyv5odqxQfosNMhtxyCIIw7KVt3zALDMqheguPuRHu0UUepcVdOPskutYoA6XO1b+N81LjfTvensaUNpYz8OO5eGYxFI1mLwylxNEXPP6EWlcdLOcAXw6VzLc6+p6fkWPcBNZFf7wAS2773KuEWuJX6BCCB/5ZYvmlDn5zq977pvmwyl2CkCl8LVQ2BXZdSTT2PHSknwjXU+XLmIyMkXFSC6bSnAMj1l8r9J7c0+NtxDE6UtuvDezRQ0NpeWKOJJDZZ4eRx0uyUTAd3HpK3v1Kk57NzJPpvRtGI6O/vySwfIgd3+1usUvpVl+mJ7oGgb3runtUaif0OZkc
 1JeqbGSa
 SpPHNQtIOflKx5tMKLpJQtLhX66wuZkMUXNWkyimih0NQI/ChJTiO0Y+2xK0/xTeGb0j2rwLFf/pspzTl22BKysN7mDtdgkTTVhOxU9dNZS4vfRI25krvwRRIJPzvRwLD+vsree6cAE60rIFVkWhEsFvU8IYSUWMZw1d00FtAJSOlb3H9doFHa0FMo5+LnJBOBvAo6VVQw+neDqMZpLg8jyzv8V7v6eqg9iqMTV6D4VLb/AKPUJldsXSZdpLnNE94BkIN0KDdmq4PzbMH8hheWrwAM3ToS+OVcmPhrMs+pcYYU/8MTkFWuKxMDwcxBgCoTRCk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-08-25 at 00:52 -0700, Christoph Hellwig wrote:
> On Mon, Aug 10, 2026 at 10:51:49PM -0400, Rik van Riel wrote:
> > follow_page_mask() walks the page tables one page at a time, even
> > when the
> > caller asked for a whole run of contiguous pages. Every page of a
> > large folio
> > re-enters the pmd/pud/pte walk and re-takes the page table lock.
> >=20
> > This series changes follow_page_mask() to return a page count and a
> > fill an
> > array of pages, instead of a single struct page, so a walker can
> > hand back
> > more than one page per call.
>=20
> And what many including the most performance critical callers want
> instead is really a single bio_vec.=C2=A0 Maybe we can go the extra step
> for
> that, as it would reduce the number of calls into gup significantly.
>=20
Which code are you referring to here?

blk_rq_map_user() seems to end up calling pin_user_pages_fast(),
via iov_iter_extract_user_pages, and it directly fills in the
bio_vec's pages array.

Is there another performance critical path that goes
through the slower get_user_pages() path?

--=20
All Rights Reversed.

