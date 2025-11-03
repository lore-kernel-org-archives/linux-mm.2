Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C19BCCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 13:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9918E005E; Mon,  3 Nov 2025 08:51:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59AC58E005A; Mon,  3 Nov 2025 08:51:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8128E005E; Mon,  3 Nov 2025 08:51:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37F3A8E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:51:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1D6A1A0166
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:51:09 +0000 (UTC)
X-FDA: 84069432258.16.5D7FD67
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2025D40008
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:51:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=bmiRX0tr;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of BATV+2890097202c651e5b11f+8107+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2890097202c651e5b11f+8107+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762177868; a=rsa-sha256;
	cv=none;
	b=PVH2rkrsGWdAUzoOfOdn2VFMaQt9UTkXx2fT0Mzxb1u5q/4Zeq5x7C25lmXtxTwBVSx12M
	0CFhY7a5cYmhoHWUcEtGp7V2LMyZ0BhLODc/jjTPRwbLhuCdLhKkbpjR4gcOxn0NjlxQtw
	eDprdYLl0eLrJD+uQ5PTfwzEJHziRjI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=bmiRX0tr;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of BATV+2890097202c651e5b11f+8107+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2890097202c651e5b11f+8107+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762177868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uSJ5MFtzv8QRsnhy/ddyi/son0cmHhiAqNrZLpnU6G8=;
	b=uaupO33WiHQ278sDhQy9IiV0Zqj44EqfrsSm3Uyeew1T7kGDA7HVDTvmBnuwdtLkYvXkrg
	XxenCNUO7L7zOcPzVc9SsMwyckxliJLVq0Rdm1dDwuD52E72Z6bKrrTZkbqbc8JwliUKmU
	ZYVeQE1XmD4NxYEU9q9FrMI5uPioDpo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uSJ5MFtzv8QRsnhy/ddyi/son0cmHhiAqNrZLpnU6G8=; b=bmiRX0trHcMFvaR7QUOgLfSZ3X
	Ns8Gpd/T/XZxm3vPareoub6JhZ1fweJZoAD6gvUKMrSoWfppLk1XnZAlCFhhhNZIF78W+FWPwpH/M
	sqcBljkLPcLnlLQdVBh4FS9JjOn7sqfj41XT6KQNpM/3Y1Intsgl0NraZ1ns9gFKY31qM2v4kQRrK
	I/40C89vXsKeKM1uaXpVADfAewVaoZ9UaZ8fL+2AnLfk41YHBXDABfytqmxBZIaqIriattecpHaWK
	IhCcgpy3mDnWbP1vzlvJZQ4+Cy657bMf89UR8gD0N/YEQEou8liJF2OTOjfSzNciStuHV3j6QiTIN
	1OgSN+Lg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vFuxc-00000009xaT-3sdc;
	Mon, 03 Nov 2025 13:51:04 +0000
Date: Mon, 3 Nov 2025 05:51:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/4] make vmalloc gfp flags usage more apparent
Message-ID: <aQizSPAvNGmgpnxa@infradead.org>
References: <20251030164330.44995-1-vishal.moola@gmail.com>
 <aQimnV815XIjV2JT@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQimnV815XIjV2JT@pc636>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2025D40008
X-Stat-Signature: e68pymfbjie5yptgrim68rrokgaexr1e
X-Rspam-User: 
X-HE-Tag: 1762177866-655691
X-HE-Meta: U2FsdGVkX18nnSVb61dLfgx2jsSOQA7tr4qbgu0+qXo21MRAPEUcRjqUQvwUc4kgo6gGLFAgtJm/qNqq+xFXo2d/xbSt4RrlburPNlQgoDZ0+qp4x0fW4Py8ei1GQFwOp8xuSiaPrJQ4vcYkjp5S7L7V0oxYxPt99NjeSK5BU/XV3mWYyhE6ZoGZMtIILQFDEA3Y6TxKYRKaWS3x71CxJKsvuunVBvsFpE6wE4il3JpWAhJZRio8HQv9Y0RKDOQQLEbNSg271YPF2juKLc30CNq3hbmYsSbzYsx1GjoFOukByZHX4cFQTMKECKD1FjwLQQmXVBMbDjwwowYqC+u8zOs/JpR8HurmSx9U9X2DTXG2kuxE/sBFMnsVkWH4Pw9zvpxYOQil2UdTVcfnyQ7HGuoZeJEBSDpJhxPWUx8T5GPVBeq8sKbPbAoJ98Det1a27xPVFbDjEOhYSDRJDHY0XmCE7Lcv/0maZztzDsnY3AGYs/cgmqpB7/YOMMQ0sWZB8D/4gLjw2IXJJgIT5C6wyCJRdnRd45h7ZQYjPSu4bhTB2qHXpq66PY+rB8PusIAjIh30vMsxuRHSNN3sqh0giid3YjLf1hkKZ0/vBbZQNBQ7VlegdSolDX3OPKkAogfGT0NTrJRyXJWT+W9b6xNkTkLA/taxes4TkmG+pbd/0JcZcF0Hc42WajTh7RMOFLZTk5GmkpG0PTsJHQNmnbbCx4FA4dTzu/YxujJBKrsJeltxY1Lyp9rQamYFuAGaFWFv/DGcNdnf3OmA/InZyuN39LFpf4y/yTS+8A6Olq+VHgdnolhD9WehwUJVfVZ1gzWd/IZPAh6hSJmUmY5eSf29ASXO0/xs4PM4d48hlnwvqDc+GF5uuKETIkCI2sPSavtFVKxOTLox8xqYOZgMXwo9yrjzorYNqkl2cgmako//D6FYlPeVIz0r5pJfTplw2hxBOfpEEHb+yBje0LEdDz+
 iKSdKHbB
 dXyStsgL1U/FYQ7lMK3X+WBseZJOZVl5CWVr2IVGuiuyperQcV7m2VzcJ7LMbujtP376FUOG7UCcGSSoJ9pGU9uZfbxo3OGGfAKjMnGaqCit1vsw6OkglhGHAdLUjufu4e/zoEo4k17a2C/iuuapDiPmkNU6EPYOmiULA2vPGL2BO26uwMDjOveYMzZa7gDhZ75wXDdWxKfuM/KwcwEfzamBz8cMzyuSwABjU6QEKjeRXSKDaqldxtjq94rIu/fGmGeKqNDd6yxaGN4+IKS0BcoF+TiWs8RyRrmHhaTDoRYIoJkRLL3VYKoRKUcpBa0vFbCCROqs5B/CkjN4cwt3AeFWM6Gac8tCp0daT4QEb0TZmi/3Txi/oHYvQZZimak5g2gVA+SO0zuyy4F+2PDFffqLsHyltTXnVOi/Pc7EwdlBE5X4i6hI1fiZYAaDnopIe8m7oB5beK/0k2Kig+mLxpfTMkG331RmDWglqg45FT6pBGw0CaPyYKdAG44nVB+jK2+jE5eCOEqYdETDwcxh+WpvFXoxo6hMPY+aBFPBSxHWYj58k5QybK6/ipyuVZiJJZN7y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 01:57:01PM +0100, Uladzislau Rezki wrote:
> > I did some digging and am not entirely sure what flags vmalloc does NOT
> > support. Is a better idea is to have explicitly supported flags and drop
> > all others?
> >
> Maybe we should look at it vice versa. Focus on supported flags. In the
> slab there is an adjust function which modifies the gfp and emits the warning
> if passed GFP is part of buggy mask.

Yes, explicitly whitelisting the (component)flags supported seems like
a much more maintainable approach.


