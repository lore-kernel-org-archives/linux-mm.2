Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC93D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604516B00FB; Thu, 15 Jan 2026 15:23:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BADF6B00FF; Thu, 15 Jan 2026 15:23:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8806B0100; Thu, 15 Jan 2026 15:23:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3D62B6B00FB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:23:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E78871A0495
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:23:06 +0000 (UTC)
X-FDA: 84335322372.05.34CA0DE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5205240007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:23:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Pks6UDXO;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768508585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2QTLk/0m/cUhu9QnaOnHOjBCICKIkUhw2bNPQCIQPs=;
	b=uiEo2K72RSL9XhtQE+NqECA0GtlF7df/PQPC+oUpiButiBTc8fbZm4GZ1yQnR8LQ5lFa7k
	aCOlYRYHwZ4fmfD0mWtXDfXWX+vMIF/SBG54o7IWtugM2wwAvC8+/ojlrzDahfQ12ay9Iq
	JB1OEezmO7e61mmDnGaShIueX45WSlM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Pks6UDXO;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768508585; a=rsa-sha256;
	cv=none;
	b=sJmGz/tv7NyXre43GKVRV1JRm23hyu/Pbsiihy89zQV/k8TRlsU1R/9Spcb/8Y96JbkFtC
	0y/02+ZQGFpXhmbhmrS96JNAQ/v0WDbbfsopl9nsx3KGGFvNistvdG8v/NXshGc88Z7fX+
	he5mdhgtRKZX4tyUgoFEXVOkq9tGkic=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=o2QTLk/0m/cUhu9QnaOnHOjBCICKIkUhw2bNPQCIQPs=; b=Pks6UDXO3Dbrl58LWOA1iQFtBv
	/6EJ5UttoujI8CUHPwxntacJb2kLKAkNRyh9/SlfJOEXqIpAWm/88J4JEHq6emR+Vm0gLL5n0Bua0
	NsgrpuiOkkKmdsKoEuAtXmceAzZDBF4JzTVTwNpQKNrRAIHtNlsmlXOVQzxKHsSTA6O5Y08je8Wr1
	ZmEYUHBQ7hk4gWJ4SJpW6sCqjt6qge2A8TZ0WskP/X+tK53tl8Zc/hCSUpZd80Q6ZgT5sCCE4tY/t
	g9BwQ5oMxWLGjbdMdfpqoOSEx6NFFaQxorZqO5d44pmRKpwK+h5fKKPt1cvupIP4mUsa9QJihOpua
	s37tgNqA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vgTrz-00000008PEW-0xkv;
	Thu, 15 Jan 2026 20:23:03 +0000
Date: Thu, 15 Jan 2026 20:23:03 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Manish Kumar <manish1588@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix VM_WARN_ONCE indentation in page_alloc.c
Message-ID: <aWlMp50lLH8xhx-Z@casper.infradead.org>
References: <20260115201305.119383-1-manish1588@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115201305.119383-1-manish1588@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5205240007
X-Stat-Signature: rnmhj9juk9y86eufm9qsimprydkpfaai
X-HE-Tag: 1768508585-2888
X-HE-Meta: U2FsdGVkX18/WG/hGlMi0bsBVNdQylb8PtX0uv5RUnZrQa31xMh8KpM+JPGUa2LBDv8zsPe1SjyCJxr1sGE3jzT1MU/CG8OgsqpOIvC/XOqi5EDw6Qlnnd/9auRuAXV8SaMXZPtdRElylbprYC1PiVe+fVqAHRwBu1/jr2qf1EMpjh9qAIFTX7EIDpZWmDwkUQGlrCAx3E4dv3tXBZUHZg6CJDghte0N8ihbL1EKyg4FxiXmHMKKFMvp1REt2I80/feJsaca44veU3SWuAb9ERQL+jBwhstRngu7x5lxwt740Et5AQpI7zOLCcRJHGTYbBhfHtmbSISgdGbS6v1ZSwkbL0pysywlON2bJ884gdzBIPOBPpTL+oUahmfFirh3rjl0HXEjefHqU/1tXAoDG0DU17oaN6/VSGU90Ar/1PayrgPqFAwB4kIEQXnJ3r1fvpfZo/cmb0h8gX6C7k82eZY6s33I6xwwDboCEeih31UwNUK76VIV/JhKmCZCq6oPJzl+xNJtZE2RjaIi330S5XRLM1+XFJpp0j1UNJ+LrPTOWdRoNT6g4H/nN48eezIlpmh2empS825q4emlg9ZeHo9Z3cKIk2+1KpCBDZ8uAPGwqYMzzT8BuHtoN+5EO7s8hJSwfAAbbEbkCt/I8P0fZyLNJH/k4Cq2V//1yflSt/y13aBiFReFWBCNwSzLGNeYEQnl5T0OS6zSzuO0RPqsu2JxY8Tq4NO8zBqghdqpgccPtV31PettZUcd+eK6ziBgJSNK4+NEmTeXzMdR8UKSpCXb7B/LNvVkqIMw2n/e7Djjet3NK513ci6weFzEOiVYUt88uuaeF54Sohaa9kmr/3mYchxd399g8dIJpA1z8T/dgXG2SVUz54s5i3pk7v36mMaF6isHwNWTPscbov4A6nbqrghs0PdZhHuwJKLlC8V7C52voYsGDpZET0AlmCps276DS/YkHCd6ppVcIfa
 OS3x/diH
 qL9/yH5+DIF831LetCWwfVHGWencc4ubAl+ykIu1xs+8r8rQhlQPmdaLdbhX/fcTGwGHPibs9sE6Kc041lSMK1Rxjo6ST0KLqR7ma/6XneYoO/8Zur3D4LFgEyz/bBTmWT1X72iIgb8tR1ZukfbsSkbnS0DBP5aLECdmUbLq9CCSGvl9U3R9eyi94sB03XSOK7m7IYZfw3m9y95ZkVFhLKdpexGsrNtbdP3leNcbmGMgxn96WQrRz7wDAkIdaCtlGaWCK/SUWHzIdLcsQxOLz/kBXa7reqn8HjDLVMLlh9mioY1v7d+f/XIcCGjEtznbZSbVrGSlVTmqts2D9LllyJ8I5+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 01:43:05AM +0530, Manish Kumar wrote:
> Signed-off-by: Manish Kumar <manish1588@gmail.com>

Stop it.

