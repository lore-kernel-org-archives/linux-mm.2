Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C4F5C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 05:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758366B0099; Thu, 23 Jul 2026 01:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707DC6B009B; Thu, 23 Jul 2026 01:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2B16B00A1; Thu, 23 Jul 2026 01:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 317586B0099
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:27:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 958DF1A03DC
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:27:11 +0000 (UTC)
X-FDA: 85018907862.03.4FDA0C7
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf22.hostedemail.com (Postfix) with ESMTP id E1B15C0002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:27:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784784430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I9+CxNIc1xoLsL8wclpNnvJkHxel3okV9VRmd9fADf8=;
	b=J9RP7QAKW4nMj2lDJvfmYyYynY2JGlsf3EQkw4I6pS6rzvlA3sE0xAVbG62RP/V24aB7C+
	nVH+l1KURfcUdQRasxyRCv2yMOKL0kSIofi9W6KZOci4iJGT9/WYnE8Gv+O5chqKm725V1
	KYgYuIVpPLWov5iH3tlE8b8FzsZsZg4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784784430;
	b=zgW+cHk+AUm9s/GRgJAiWzimm96tTK14ydPH7ciLSZZZ/i6EXqx+tq5PchZzHlQZi10x+i
	o5pUfzQ7QAKTNyDDTNPAkY7jTA2zFgVtw4u/Zx/TCnoW9nzoAl3sfgap+XsJtPPXPJI+DH
	x+FzzRf/ZHU1BzsAxjzNyGyZSmldRWM=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 03E6F68D1F; Thu, 23 Jul 2026 07:27:07 +0200 (CEST)
Date: Thu, 23 Jul 2026 07:27:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Usama Arif <usama.arif@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, baoquan.he@linux.dev,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	ryncsn@gmail.com, trondmy@kernel.org, anna@kernel.org,
	sfrench@samba.org, linux-mm@kvack.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/swap: add a new swap_ops.h header to allow for
 pluggable swap ops
Message-ID: <20260723052706.GB7565@lst.de>
References: <20260722130615.3163560-3-hch@lst.de> <20260722163218.1240273-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722163218.1240273-1-usama.arif@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E1B15C0002
X-Stat-Signature: fc6hykuofkow6weenkaidg6k5edyrw5g
X-HE-Tag: 1784784429-255956
X-HE-Meta: U2FsdGVkX18fO0JDh68VKI8C8HsTR7N8TyIfUR/fJgF4EgdPQ1pPS5CmrvdStt5+NB0GVQFKyNMZHNPDUqlbzbOE4nOk4qxs/J8daEXSQt9KtAn55OMpne5SegVYkOCQdYQZP7z4BB3RksoxDpG7BLhPXvK5us+RPyaqdhp8J49f45HitrLc9TlZXJgmpUZvIP3CfSWcliCknfIde9c0fH22DTlA/SZXdkK9rqfuwB7MBt2EJ61Mq44UU9QL9eYnaYSYAcg5oX4geQ8vc6bt9QiToItDAb8UM1OZo+Rd/8RxC/slSLLVYHyElj8zb2QaWD5v45UYJb/nzUm5h1v5jLi04Gxrq+UQIZYfIpIFj5l2vJGoUD+0Td0JjCaM1uQlwpIBJcuBNmS7q9aBJI99/IAMoNx/P+9XRJgRepWItkylBo+XoJIyHJ3vxYfhysTAJaitzOcRB0XaquRZ5vRPHdn7liIysqcdHW/Rd8LkH5LU5t0y2TIxE2YT+jCtqSRqQfKQgjlQnW4OOOFWd0GXGjjuS/nbXtvSiu2C+gfOWuW+5ICA1fv0PCD+D/T4J460ik6C6n+mTJ6eZbwzigAXXc1NUcf+TxWLMCI23B4DFhyd6ncUGSJ1SZStRKhzzfW4V4MXmqmuHVPTWB+c7+XuuBxMw8slmYlsO2FMU7QHgOVGysVclOn/oH1zR+Bh63TWTGWIBOZyjqOWsKTQA6hPq5mA2Oa5bh6TB6nzbwr/ONLpdmF0/8KsDTsVP8Mc4UzK3FBg9SXuzBLG5/5Jy+lCirtubmhNBIX8G8AmV9nv2zm8KfTXiLhhJOpxLT0Iur7hJZRAWqWFIr+kqXMRlhntw+xIoRzKcY6v9iSMhakIhLKQDHeXJAHsuZNrChyf8QPKxab/Vzu90SXSJli/D4R1dM/S63JbjMN3zulf72A8u3JYrsbmwuIPm6+piwXXA1hPg5KF0nsU2/DEOtSJnyF
 QI0Clxon
 gbikTb19UTVwFA8jeaxWLKlkw48YncuHczjDzU3lfDtFNapTAp91YGtKO73xCQHaevo0Pnn9NtGVZJs2NojgL2/BB+P59ZMH6Qd7QVYFvqk5oywMM+aBSE9T4DIoJL2qQYVA4Kjo3IrP44+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 09:32:17AM -0700, Usama Arif wrote:
> > +struct swap_io_ctx {
> > +	struct swap_iocb	*sio;
> > +	struct swap_info_struct	*sis;
> > +};
> 
> zswap uses this struct, I think you need to include the header in zswap.c
> as well, good to check if the build is passing with CONFIG_ZSWAP=y

Yes.  The buildbot was nice enough to remind me of that just a little
after it gave an all ok...


