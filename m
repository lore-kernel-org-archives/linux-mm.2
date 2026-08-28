Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C4DC61DD6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 17:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2376B0088; Fri, 28 Aug 2026 13:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893F66B008C; Fri, 28 Aug 2026 13:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AA5D6B0092; Fri, 28 Aug 2026 13:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 544CD6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:18:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8FD51C1E16
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:18:58 +0000 (UTC)
X-FDA: 85151338356.28.51F0399
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8AA5D20009
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:18:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="aTjNCdw/";
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787937537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BqH+mJJNouchoXYZ3ssmFPqelP6Ak9OqMh5GOTj380=;
	b=UpO2AB28nIhpUNWkh7qMgmDDrf9d7NSiKoMlOxy20mozSRKleUczaz7RpsqJrzRj9MP9pU
	PdlqXKblKIe7f1yh6Tn58VeJ1GbmsEubrU4F2/BfrcNK7TeTtfEFmHNrOISMftuM6hJx0n
	vKIO8esKIzrjTrBXsNkZxrByHxgSHBk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787937537;
	b=aZy6zuyiqWZvGsE3fCgzufP2rFnlWlAVN67E6O6LIrOp4bcCp/v78WhSSVT3XMLBS27i7z
	DEKXsDCY00U5IhwXn7HTb16+dqq8aKLaYwIJ5c5Hf+RMtRQ6osFp5Avo6MQgjhdCL3Wo1b
	/EmZwYLj9R4f3GqRGgNql3NELgupUUo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="aTjNCdw/";
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7BqH+mJJNouchoXYZ3ssmFPqelP6Ak9OqMh5GOTj380=; b=aTjNCdw/YGw05Q/oUS1Im69fx2
	NCgNclO20G6mjnMW3wmg5sB6riqPdFzxFRvzeoG12sIVhotmWyZJ8+JSYKV2ePeuNkMT3Tg9ZRBtB
	b8RHKJTS6T+1sgDMJUYPiDRlHQ8pKUFAAWvLoakKiMkznOae/ZHmWRxtCIO6eVaRkksR+hGYAHecG
	J5iPZlgeWc8g8hmpKopRr2+FWActEqW+GPRGMu6lzO3oFewq3H8597bNdsqzvxuFnzDRmcfunbGzq
	EI4sd3bjiO/zRXFdIX9XozaySNA8ECCisZlpnO/1xdOw1BzW6nVhiUdAhFIIzvvvTIEDnh3GJz2BM
	nyFSajqg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x00EA-0000000FA0u-44QK;
	Fri, 28 Aug 2026 17:18:55 +0000
Date: Fri, 28 Aug 2026 18:18:54 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [GIT PULL] Remove dependencies on pagemap.h
Message-ID: <apHC_mHJ3wsJPEgy@casper.infradead.org>
References: <apG8g-5krNRUFUuD@casper.infradead.org>
 <CAHk-=wiY22BnQkAMMc8-h6xaRksvVAbASpg=pj+=kVaXXQYo6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiY22BnQkAMMc8-h6xaRksvVAbASpg=pj+=kVaXXQYo6w@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8AA5D20009
X-Stat-Signature: iefw4k7soqkiybbnpw4jp5eagggkqpsr
X-HE-Tag: 1787937536-744417
X-HE-Meta: U2FsdGVkX19laFsK1gEHwifstb1NXMN/Shjo09fAhCjF379HRBZ6oAkywpP+fWWRI3DSdfOECo/TMbsH97DeT2rfSy3inZDW8udbN6FFUt2j0P5TI1XpOKMNKR/0quhgv7MWPvZ3g6cbHyQiY00AepcLVlP+ZQuXezdL4hXJSgQJCoFuR08xDRnMNFt1GzLQ4RAvEefbbpJYqA4hPRF+Z1cq4fYcI9upBo78ooCuxlu16yU31akSeeK0zg2dq/KXAHnn45rbsPjy3PRzj2C78qqesotF3+gSiB2OMqzouX4S/IK0emhgzQpsybJQynICfWin4kQsxr4QNqa94c34n1LLR7ixbUNqFimTLTLgG5sOfbQ8a65GSCohw6mE3wTcnQM5CORwWRP1PXb8QxSpcrt45G6xAQ61L2cuLMVvNlbIKfG5NEv7g58jBKqYhnFcjq9a2Ln8AyKkJidUOqigySD5R7HnzKNat3Btph9tjcodHM2Mc+Gmronrnhw56yoy+e+nocKCyIEYOxOQZHGG/yAgvE/mWMEbIehtrjOq84wTKWa/VZjq/yBQ5FjxhtdkgtzPDkg8T8U5ukDlMLORjwDcW9Wt5BFsORqKwUB1ZyYOMp07M0lfW/Q8UZlnVQI1ZUqZzLYX0JFY1HGFNrFf1qslgPdeGzJOKHcn0DcTglQZ6inqI/dSC9FqvECegj8Ze5rNH0XoMbVpq8TkSC+uZ8j6BeYep712rfSddBl7kL5nhOfAMGQrYezC2AuRbFnGeRdRSaxxUPzGoEKImMXI82aSyWrBRkFmYc5dc5lDgy6dOhte6cFYtHlOZl6QWWlk1teP7xADemnwJRqjhMwmJV7pCn4oHfRzHo6XWcuga/vvtzk6Zom0lCcW8ddKWtBahV6Iu/h1Bip50crXtVwoO7YYc+Tn2mNdB0qbf+jdmg+89ZTd90LFCVXhgALVL5Wkz903sBx8oLImOFZfk4G
 +5Vwshsx
 4VRJaCU1NcminHxhBJjU3Fiu2fbBFxhabxhtWXnnCrphLi4a+z0Js0Y9QJ3EF4aKfzkua9xZuHQEwIPPixQPh5mIqFSD/hwJGaNTelcxR7A5ckg4fpCoUmg5xSFN/A+brkb2nrPek8I1YY5SpXQ78ISHJWogBIPEwJUAqJftjNNO7v1A5uaX4X7Qtg1t0gOwrWIBeR1JDLlRzH5+HEJV2IFOpsvzphtBKAZxrYwqvu4ZTTIObW1xYBpmULzlsTBxTeNiT16CBQKTYOnOPNUfv1LjQGJ/mPjHXAdtSEh1xTQb9rWP9eYVqOT/MGmxWSWIwEwoz7W5d1tjQZFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 09:56:59AM -0700, Linus Torvalds wrote:
> On Fri, 28 Aug 2026 at 09:51, Matthew Wilcox <willy@infradead.org> wrote:
> >
> > My apologies for not sending you a signed tag.
> 
> I'm not pulling non-signed stuff.
> 
> And it's way too late in the merge window to try to fix this. Make a
> new key, and we can do this next time around.

OK.  I thought you liked this kind of churn stuff at the end of the window,
rather than having it create random unnecesary conflicts throughout the
development cycle.  Have you changed your mind on that?


