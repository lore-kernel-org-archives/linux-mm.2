Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D7F4CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 09:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69CC58E0048; Wed, 29 Oct 2025 05:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674BA8E0045; Wed, 29 Oct 2025 05:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1A88E0048; Wed, 29 Oct 2025 05:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4EAE88E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 05:23:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF51649796
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:23:54 +0000 (UTC)
X-FDA: 84050614788.24.2F56A7B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 20A7D4000D
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:23:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GA03knUk;
	spf=none (imf04.hostedemail.com: domain of BATV+a01530d85467cd1df9ce+8102+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a01530d85467cd1df9ce+8102+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761729833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Ih05HK+8ZsKOo5cQ+utqVaq+hUnBg4xFJaxP/XkN4A=;
	b=62y9zNcM98psE037YVSlbcIRRnUBI0yG0+KuwUxObVpgkAXvOO9wdiLu6Nj77AJAeFnHC6
	pTUVsfSaJi1bjkeU7XR/sOb0YTk1wwaXQ4Kd9wSX71j8mHmLkET1XcimisTe+XJfnjv87o
	JmbjiyPWfUGNzV55ni1UmnUWLtLJSjE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GA03knUk;
	spf=none (imf04.hostedemail.com: domain of BATV+a01530d85467cd1df9ce+8102+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a01530d85467cd1df9ce+8102+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761729833; a=rsa-sha256;
	cv=none;
	b=xh08rqOuldT+jAahdVRHQMKGu8C0xA73xlZAC7+l9VloRW3as4nNES47c8gzfAJG/za2RR
	oww1OC7WL6UGxFCxqGwvFw+4HCcODI6y3KH2VMhSnAZKsC0ZVMRgho7TK4pRS0A5HLaZHX
	nKMPabfH5E/HVv7w7oQGcONFWa76jm8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3Ih05HK+8ZsKOo5cQ+utqVaq+hUnBg4xFJaxP/XkN4A=; b=GA03knUksWMuLiHmkDJ5EtiFSg
	wtcTt2zLP5rdVxMJlL5t+2bQPR9r1FAu+7TxdPT1FZoVd+9zZqS8DvVU3U58tlcANQo3Ijlxm29r6
	BIL1s0m3nl0Oj5zeyYWGYkRZrAQgYCgg7EwQeFKub1LK86Uy5OSqSsuBN38/AYPS3gZpPXq24K0x0
	9hFELXTlQiy0mJ1/LIvBFNKdrwvGhc6WAtCupQZEw8eVo10iVBdtQ2tvC/JcnCTHrsd578Gj8mAoI
	DiiBs5ov9+QgkPuCXSJMAiWBqFr+vrzwt270IQq6w3w9rvz7L7t9vBla6YL+/OiGk39CXMbQYj+eu
	RZXfs7tg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vE2P5-00000000TeR-1TcB;
	Wed, 29 Oct 2025 09:23:39 +0000
Date: Wed, 29 Oct 2025 02:23:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com,
	peterx@redhat.com, sj@kernel.org, rppt@kernel.org, mhocko@suse.com,
	corbet@lwn.net, axboe@kernel.dk, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, willy@infradead.org,
	m.szyprowski@samsung.com, robin.murphy@arm.com, hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	minchan@kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [PATCH v2 0/8] Guaranteed CMA
Message-ID: <aQHdG_4yk0-o0iEY@infradead.org>
References: <20251026203611.1608903-1-surenb@google.com>
 <aP8XMZ_DfJEvrNxL@infradead.org>
 <CAJuCfpH1Nmnvmg--T2nYQ4r25pgJhDEo=2-GAXMjWaFU5vH7LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpH1Nmnvmg--T2nYQ4r25pgJhDEo=2-GAXMjWaFU5vH7LQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 20A7D4000D
X-Stat-Signature: 531i9rs6u4oy3k5foga4zb1bjzytfod7
X-Rspam-User: 
X-HE-Tag: 1761729831-763998
X-HE-Meta: U2FsdGVkX1+0e9mM9GLQtymcTzsG2A9rfjOdX+Yb5NGQ35rrYamTiDy3Jp3rgMzIb3KOeZi7Vm9FFcPFTI2KzrDg2lTGoqsygKs0fQ1izZZ1nPlUpmw9nMZRp1oE6j5d1DIZ0DCX1BJbSaWam39gIeRu2es1wLbNLKhk1EnUbVaxbyf94hqsatp8Z+Dcb2yGIUuOYfZ/jzRqDeA9WWnyPPxUHgwhqouscMjnSgCZnk5kVvBSybsTbBGJDrk5ng1iAtt3sacLBE2l5+0HtXQ/KSG4IdmY+YITylA1XHCenYToU5qoEZOSIjHbiv4OPp4Ju4NqF60avMpo+4OzTI9D39xSmoDn8s/MOhZX9a5EEF1oOUEsOW3L8smvGva9jipGbfyShpuMeDHB4gJ2fi6/Kl7882uKoWyRBZug+w1WG/xpzbgdN3OGN2zZbMCFhKcIGRDJL5g5Dyl99XRD+M65gHYlc/GYu1ztf2stvC9/qqcxFS73pksSD7r9B81nOBRw1KOxrI7usNZua6iWEIc/JNzVTJ/XVqH+SlXx+3R8iS2499qO/UKBRpX+pLGR957oqElmBH8PYRK0EeFifBg5j+FGksMbKreYnV2S1z2Y7vxBHhDAfCimyrFFP51OkVoNVJAMf/StZdS9AR5WbX5BVXogm7YvTMrvtBT1K4KxsRoFq/p/t2lTBLth/QqxIG/Afg8FaBJ0WzAtQNwwpfqMDcwO7oJC3p7Oe6dI/eNs08YsWVAdcGydoJx96QUA1l+v8eaNG4wBD6xn8aYGrh52wZnBJrApih9EI4BdxXOesfPO9TY9uCEfsU0mIgLnrBnkD1TKcmhajIy+/wouS1g4s7KrEFn23QCd/a8xjfPdva10YLxaLiam3tgoVWbIDALo6PTPajfP9SxQkdX3EpVhMJzqJ4yq4xx6iI2j+GjlZPf41FT3dPMWGe2LD4EkakWAv2VYSfyCmShVxUKMkFu
 0K3euXvf
 gduAkY6IiiF9Z79ZPJpfh7TQOiw8S/8htQs2J3tB5GEEtmBpA274OdV31/AfyDjhthAyKqmKSHwFFuQ/t68g1zxKEC9adpeDQBc9ovFoLV7viDyhEKKeiJXKGqufCdXlvzQMp7NTexk33oJTX41SEGZ89wtyU94tNM15z1cM87bMZ6Ae8ufupXtkj9QatX3sIcDt0iVvJ+KREBBmFA4cLgQ1VJ75VzLCmDg+lLxN9dsuqIsweAhuYyMyUxH4t3CDukimWE7sD6tk1OJnJnNJgG1Ud5MIpwF6bBhOmvrJhjO7pILFDqGxBoIajVxp8RCB64ygc5S3Q2Oo7C40MLjClRzFEfU2jxNzdnZ6P4Ng+pI8dBpyRE6CiW+/FlJMaeiWzhR6nUKaZCSoOXaKLnOayPwcjQFQDAZrzI8P6o7eeHhsqnsLettFKVOkrt9R7fBnm8VEd1D8Ff4lkBnIP7hhKJJkpXfP9M1AzvkXiY/wWWD9Zs0TIYnmDjn/mbtbl7QxznXrtuToIjNTW15lWJ6UYMkrXHf31dyuFSBj+Zqr4Bb/5ibw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 12:51:17PM -0700, Suren Baghdasaryan wrote:
> I'm guessing you missed my reply to your comment in the previous
> submission: https://lore.kernel.org/all/CAJuCfpFs5aKv8E96YC_pasNjH6=eukTuS2X8f=nBGiiuE0Nwhg@mail.gmail.com/
> Please check it out and follow up here or on the original thread.

I didn't feel to comment on it.  Please don't just build abstractions
on top of abstractions for no reason.  If you later have to introduce
them add them when they are actually needed.


