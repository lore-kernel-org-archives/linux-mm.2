Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A298EC56206
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 15:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B371F6B0005; Fri, 20 Feb 2026 10:10:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABAAD6B0089; Fri, 20 Feb 2026 10:10:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6416B008A; Fri, 20 Feb 2026 10:10:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 74EFC6B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:10:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE139B6AC1
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:10:56 +0000 (UTC)
X-FDA: 84465172512.11.1A14454
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf23.hostedemail.com (Postfix) with ESMTP id CC9B314000D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:10:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf23.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771600255; a=rsa-sha256;
	cv=none;
	b=J4Zp38evpVLvlAU7m5w3Xx4ZP+CmDWcbLPOsq1dIkdR45iFL9nalFtPCpXCRn60b9TQsG3
	UclZu9ypGpD7rEaa92Cc5GpxlxMb0KS0QFbtiaHK2nL/X6A3xmVmXbqFL+WRdYfVinR1oe
	qzC5tv2/AhQzuDTDfs+frq1nQWiYF4s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf23.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771600255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nXcYtcs7D5m+en4RUmtKRReycKapPxSBEVRUuc3/3Xg=;
	b=buukg4H0eCtjPasNofiY3NJvJT1Z0eiXaSz0VbsfgyjC8WxuC9AZEsOJzfLTzJnJXAKRkp
	DMGLk5dqb71Xf4t0ik88utyYymc+SBcF9T3huOB0HqfZY1sTUjPIgaowwkdli/sxyNekvw
	hWaHVy7BCOCQqtJA/pVC/QeMbxd0uZ4=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 71F7668B05; Fri, 20 Feb 2026 16:10:50 +0100 (CET)
Date: Fri, 20 Feb 2026 16:10:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	Andres Freund <andres@anarazel.de>, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, jack@suse.cz, ojaswin@linux.ibm.com,
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <20260220151050.GA14064@lst.de>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <sjuplc6ud6ym3qyn7qmhzpr3jzjxpf6wcza3s2cenvmwwibbxr@aorfpiuxf7qy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sjuplc6ud6ym3qyn7qmhzpr3jzjxpf6wcza3s2cenvmwwibbxr@aorfpiuxf7qy>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: cs53ightzkq86khbm8kz9dr8qyise875
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CC9B314000D
X-HE-Tag: 1771600254-893320
X-HE-Meta: U2FsdGVkX18aMiBxQ1ew1Lges+V/qX3UQJS/qXUmwUlNm0O6DQzpi6wgvcsAuu5/fuNHar71jXkzImeXRMQVdw6oldgvfTOLqNiRM+4DVUuOkG9viarqbmQ+U+K9irnvePMAxyMxkCwCwsfwLrIeD8uj+VlVbPEIOSiRyHQfQRphxzfy3nmXFi5IkEQ8xYdtebY5ELuYrYgubh49rFvBpsSaB2BwatbLCSDdbWhr9s5IagNWbOTExq1l51NkxZTTPKFuxwOpj+Z+QYSEg0Fcz0nClu7N0FFl/KtjeMQ4bRALV0K9xzBF5E+RUK9GjJGGarBwi5w0p79VLifPhOLb4WEdZzFcfJtrBGxDzE5MfF/6aISEyIAfHDOVnWr64qNRPp+XXlgovYT2cAwcMpv7xJwSklyza8H2KGGbmq/mmh+rklH24pWXFHlkuAAkIhEOh/x+m+5lhUKAKQy8dbrJp6pC4TajFxhx+eEKMCHWEhwq+55P+Na7yvvlVjP7oOqyKX0CrysdVI8HbnqMT24Qrocxbltiy1FuiNgbRThv5Ix/ANqZw/U8qwPp878iZrvUot4hqGD1/5TFAj5/4c7IzDRv6DFvBg9IrIC4e2cljRE9GbHwqRax6aOK6VReg9R1mzPwTSchzjkrzbYTwWhFYu88ggYGrOkJ6cGLqfHL95rHxzaOY90d8Lp8QNgURJgpTuQLTdu2ArjcF7oAC36RN+JmDmUiUvtPhxN75UXKwyb5yTjFLJBR9vtZHx4OFJ1w39cWxa5cvzg4VEMT0M888WyYXVKqAkwYSoxfmULGomx2uufQZBPHG239pmMfxCySQsGdi/1XvcU4liY6IcLOyrleOOPfp/gNLYyZ/kKwg65YDytFCjVvNgzW6mFqpmOqOr++t8eEJ+vlcU/GiuGDO+19LcwI+JCpGCNrCW2vLfrQhNCoULO6jY2FYBy2pCpQ4H57xzqJ29CvcEGv4Ms
 qoLK9rtK
 WqhB7DajeOJXvfemurubDbKb/peYCH/mBV1KCNdpQ2LucY0b/RWIiVajKqpcn8j/7gkjAwEoZaJg795SusUJ6UYVHONLT+qdA4EkZUFGZ+OFp92hXoHwyF347aSjFkgOmTcJ79b/gzi7YHKcu28R42nDDaZTjJ+nOlj288EOvVoS2f3Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 10:08:26AM +0000, Pankaj Raghav (Samsung) wrote:
> On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
> > Hi all,
> > 
> > Atomic (untorn) writes for Direct I/O have successfully landed in kernel
> > for ext4 and XFS[1][2]. However, extending this support to Buffered I/O
> > remains a contentious topic, with previous discussions often stalling due to
> > concerns about complexity versus utility.
> > 
> 
> Hi,
> 
> Thanks a lot everyone for the input on this topic. I would like to
> summarize some of the important points discussed here so that it could
> be used as a reference for the talk and RFCs going forward:
> 
> - There is a general consensus to add atomic support to buffered IO
>   path.

I don't think that's quite true.


