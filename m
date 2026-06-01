Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B481CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 01:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 573356B01A7; Sun, 31 May 2026 21:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522F66B01A9; Sun, 31 May 2026 21:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439886B01AA; Sun, 31 May 2026 21:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 317056B01A7
	for <linux-mm@kvack.org>; Sun, 31 May 2026 21:52:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF5FC8E79D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:52:29 +0000 (UTC)
X-FDA: 84829669218.24.740ADD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 17B53C0002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:52:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KYRH/paM";
	spf=pass (imf28.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780278748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZcu83wQUzh29/MUzPMLQS8Iv0nVsOwsxAWqxDDGj50=;
	b=dtXz5AxNqEvwuuFNEiL4ayz7xGGwrx6qU0rEgnhW88Iwzg832xTeqziuhtg0iJvwqDIRHB
	KsaixCw0QGCmTinXrzgB8r1NzZJu9sq3hC9dhx6Jal1t/RuNLBvM4YwnsUjwR8HcbiMnnE
	FqcTl1gckKe1PubgBldFBdVwm0MsQYk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KYRH/paM";
	spf=pass (imf28.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780278748; a=rsa-sha256;
	cv=none;
	b=uc9lpEkUzHMVQIhN/AaljkEKmumzT63vs3YOGI2A1jpjO+06iRSUj3jGdLgnai81qlpzmW
	Rnqaa6yRnCwIzMcnNXUByad0DJkcO/pdnFSk8aqU24k4aNNFOqJUNnPdn3VJXiMTrCjbqC
	4GEpRygn7y9uEb8YJXYZnuH3GOmTFwA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 074F7402EA;
	Mon,  1 Jun 2026 01:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8DC1F00893;
	Mon,  1 Jun 2026 01:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780278746;
	bh=vZcu83wQUzh29/MUzPMLQS8Iv0nVsOwsxAWqxDDGj50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KYRH/paMfV8BeCgbYfsHMCWqDOtr++JkRKX25dlTAVmIboEGh885kBK9CuL9tV7tr
	 8pqNVZlKj2Z5eqkBjCOdCp0sLKsojv97UUmTic4Gw9ws96ZOStR0P5qLHeNR5VBGoj
	 3LqQJbi8ZclVXzUncbIJ1wqdlIzloAzt9PJuFY5D6+UiIWk8GmIvoBVVeICbzTfjsC
	 Pd4h54Ftu3TrtIx88YUPUiS7ncpHA0KUeMphtpkxg9lh+Ru7ktMSIfDkYD33de5fyM
	 gU8LQy89ioRQGwY5FsyGgbwGBRpqJv7qJ25cTr4qdLpzf66OxtRMqTcc+ABTwEWkQp
	 AbzOUsuArFnkA==
Date: Mon, 1 Jun 2026 01:52:24 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, Bart Van Assche <bvanassche@acm.org>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahzl2GM1OGsBz9mV@google.com>
References: <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <f4e521ac-2381-49ca-8dcc-3cb3cf3ffaea@acm.org>
 <ahaPDHiXcJoVShPv@infradead.org>
 <ahcU5xbVy7xjps02@google.com>
 <ahkl52N3RDcusCNd@infradead.org>
 <aht812OhSPFqIBPK@google.com>
 <CAGsJ_4yJihngSY0GNcc+MwPHJjpF1qCnS8-UE1GwYoNDtEm9mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yJihngSY0GNcc+MwPHJjpF1qCnS8-UE1GwYoNDtEm9mQ@mail.gmail.com>
X-Stat-Signature: cnthnoeit4uz9zd653p3xix8iszshaw8
X-Rspamd-Queue-Id: 17B53C0002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780278747-509625
X-HE-Meta: U2FsdGVkX1+AXzfTommatJ87DdYFF8kkpjqIjRRXw+KcwxxkAn9hzefcdU9Uk0Xpx0MGp741oSL0BOgCB4VnGLSNCwmYPULuiVUU+wiFUd+x94ZcXX/+l17/Ah9truIKG1hFuZzdC9iOjR1VUzfXMTHe4tF6+1tEphTn32wVdqhRrmZS9jjD4rCvY4vmZvJDPAcQVMExNjmyA0a/WwJU1Tf60VYar1mdPF8I4bg7MYCKkQIzYoWGr7Jpyx9Q/BfBV3tU1JRBPRs6e7mImP6xhNeB2Jj+lVK606nw0fGCnkslpsfL0nDjDIM1m6uhQJ9toNTGNv52J81R1Hx2iEsWZFOudNdOQCRMQN9AeUSC57h+XxBQel+4piu+O/PMUrrF33al5duRaN5vuk18OI49FajnGjfP7FWdtt/pyPIMVTfavww7LRflu3P/9h9JTnxc5zKh964W4N2ZP5H20sRheWofr75g5swZU7bpYO1ySvqwW5gBlXuhJsSSbh+mFvHMn4OnKmzDQgtfCTUSn8wg88juxLdMyU3ID6p2IeHGNWY20mn+U3oNfwdZJs7H25Ptyl0Oz0PjrMnuBCFIK4EUWRAr81Jp5LpmK8LH5k9crzIZ9ohW7taENYn/bi6qTE/fuCRMxiDCMH6Gh6b8e6xhYj9bRTA+aPkD3JOg8NhoWDGfXeLLmWQ8cvR6VRp79ZUIp97iz/oomYGvqTzXyMVxmN9IA3qOXNGT1B98PVlZIEu1d01hCpxczDtrR6vdm5KGHPZtmaEWJXCzjlLMwXlMNHfNJHGj8zcHdkcDKXd+y+cY+OmrZ+qCk1u0Q2V+ZUdcHeK+hg/UWolLCM3+MsZWo3gbR6XicLqVRPOT737/J/uTVkzMUg+IlQcOZ6iEVBgjZDCLWuOWxwsSs8x7mWyy/z+Kn1VUR5kYsEegAxEMwGN9Ta3gR3tigHEeObXP3ZKv8eaYnCzbupiFQ+B9QrM
 Jw4WzUPe
 GO43fK/3dW69/bG0iA2Rz5HX7ANGz6+FDOtTlE/gd9QQdDT/rpMRxtQRGph/czyQ7EqI2Uiwl45Z6LkqklLe5WRmcs6lh14ePeB5MsEJLZHxfgHT4BJW1dcqVKj8UUMReGp/UVVKOcHLYQjiW1P8BKIw36qgTeCxC6TtW6K3msI9lv060sr6tjGohqdhvo1AQhy2JtRCQkADpRZIeEuIhYrd7sfupilYz0oQ7k18IwYq/IXRl2/fGuicYqtZoESf+y9HUiQC7bZbta64zB8d1bDZlL58FFZHWLvKjkY4goi3rjHjzRCNrRq8Osa/DMXVHXZ/5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/31, Barry Song via Linux-f2fs-devel wrote:
> On Sun, May 31, 2026 at 8:12 AM Jaegeuk Kim <jaegeuk@kernel.org> wrote:
> >
> > On 05/28, Christoph Hellwig wrote:
> > > On Wed, May 27, 2026 at 03:59:35PM +0000, Jaegeuk Kim wrote:
> > > > F2FS merges bios before submit_bio, regardless of small or large folios,
> > > > since the block addresses are consecutive. So, I think IO subsystem was
> > > > working in full speed.
> > >
> > > As does every other remotely modern file system.  But that merging is
> > > surprisingly expensive, which is why using folios gets really major
> > > performance improvements.
> > >
> > > For one doing these checks to merge touch quite a few cache lines.
> > > Second, devices are often a lot more efficient if they see fewer SGL
> > > entries.  I.e. having a 1MB bio a single SGL tends to work better than
> > > having 256 of them.
> > > The same is true in the kernel code itself, both in the submission path
> > > (dma mapping and co), and even more so in the page cache handling
> > > both before submitting and in the completion path.
> > >
> > > See Bart's patch about how long the walk of the bio_vecs in the f2fs
> > > completion path can take.  We had similar issues in XFS even in the
> > > workqueue completion path due to lack of rescheduling, and these simply
> > > go away when you do the folio manipulation in larger chunks (LAZY_PREEMPT
> > > would avoid the need to explicit rescheduling these days, but that just
> > > papers over the symptoms in this case).
> > >
> >
> > I see. That's also super helpful. Let me kick off the large folio support asap.
> > Thanks.
> 
> Hi Jaegeuk,

Hi Barry,

> 
> Nanzhe has put significant effort into this work at Xiaomi over
> the past several months. Large folios can now be supported on
> non-immutable files.
> 
> He has conducted extensive testing on the Pixel 6 and fixed a
> number of hangs discovered during development. He is still
> benchmarking performance, but the implementation appears to be
> reasonably stable at this point. We can run Android Monkey for
> many hours without observing any hangs.
> 
> If you would like to see an RFC, I can ask Nanzhe to send one
> as soon as possible after some cleanup and polishing.

Yeah, I was about to reach out to you. Let's do some discussion
offline.

Thanks,

> 
> Best regards,
> Barry
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

