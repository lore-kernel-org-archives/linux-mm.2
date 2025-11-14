Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DCBFCEACD2
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 20:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B9F8E0009; Fri, 14 Nov 2025 15:44:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7237E8E0005; Fri, 14 Nov 2025 15:44:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6602F8E0009; Fri, 14 Nov 2025 15:44:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54FA28E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:44:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00A4189502
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:44:54 +0000 (UTC)
X-FDA: 84110391750.22.7F983D8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id C654C40014
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:44:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ox9zZpYS;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763153093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avhP2BlDV0WsSq481d4QOJ4qj6ZBZ4/qUpQyCVpZucI=;
	b=BLC3G3c33MSRV5gnLf38jS8CVUMOy20lloWZ5YDFhQ+PXAlkQCZjT0TfJaDP64S/OS5CWP
	tlthu0m3Jrj4Qi4LTvol4J1FTlw4Rez3fvluhIYdHv+UZr7cpPGZrkZ9YpkbqVVY/T92TG
	iUZSn8q4l5JF0XRtbFZOmbVtkS4tUws=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763153093; a=rsa-sha256;
	cv=none;
	b=OuIpNqarLr5QWLMBhmzgI68kQ+XjeykCRlib9tcE/ddozQo0S0+RiGsIcHI2ULl84V+fd8
	AtJRBj3u+2jAkiJ6P1iBnYDL8/fBGujVFop/gLaOEORM4Tz3WL3809lp7g2vsMLOpd8Xzs
	eLmTLhFMbF7W1aCUZeiTdUdKgev8H2w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ox9zZpYS;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=avhP2BlDV0WsSq481d4QOJ4qj6ZBZ4/qUpQyCVpZucI=; b=ox9zZpYSOeDXSI8JO8p8p0xM9L
	hk+LKitvAWv/vcxVHaSHG4VRyN2HpeglgaFVYC8ij4y9mu0dutl/n3Bl0123uduvNbDUUaQxLeeCQ
	4EOtj11TOd1NgD7gul5dqRT4uiVVbsLIgnj63wtKc720Gqt83valXqg1xSAhYu6aquLE9KJuiFET+
	DZnVDzOSue8dzQW1YSilSNS/4IjyIJSHBZeT+JrBK9TO6PR5s02OrBlmDQqdan/lP/z+E8F7WAcZ0
	IPy6/+Mx2PdD/bKSY6fmbKPbOIOcyWT7JES4G6e9ZlMf/FAd5u7PGoq95gQA0XlNy3MG9BVsfIiij
	mqbMKMIw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vK0f2-00000009u54-04RV;
	Fri, 14 Nov 2025 20:44:48 +0000
Date: Fri, 14 Nov 2025 20:44:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: ssrane_b23@ee.vjti.ac.in
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, eddyz87@gmail.com,
	andrii@kernel.org, ast@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in
 do_read_cache_folio()
Message-ID: <aReUv1kVACh3UKv-@casper.infradead.org>
References: <20251114193729.251892-1-ssranevjti@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114193729.251892-1-ssranevjti@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C654C40014
X-Stat-Signature: ixb88i5qtgi1sxydiwmsafkjhg8skhz7
X-Rspam-User: 
X-HE-Tag: 1763153092-616453
X-HE-Meta: U2FsdGVkX1/4GigBaD1hRH95iDCYNqUmlv1EQfdViKuxXa9NXALRxuISQaImj2tfhqmrRukWkLK6jMdUT/zKMzHNLCqUn8xBfg1mGihCzXy2dQCsAo2J64ojadDaLWtxTw15t2t2JrA4TIgeggScapbwO9vEhQ42UnQW3qUYTu/BhPt0ZJ1GcmzylVAq/4Fo4PqZkc2/hml/Y7ujUf17LKbkBupqLOgHT+MAUMa0ZBP+/nZhAlwb3a2q1raC8bLkW7xNWBoEu+4pu6OXzo7Ea/UJC0U6cDm+Se4qxTWyLVf9aGvD+/LpVZsviWFnTZRSN0qR0BkLoSVRrSmAd9QUEwpDc1zzwihW6WaEIchbwjWMxE585VPOA+cAReQIm8x0fISeQ79GTZEU+B8Wobp7jgrHxQucW7EbaY7dvWZDWKo9JVhStXYxUcKnn+Dlxcz4/ZLYSyvEyU+MsJRX9qQYnAPB0+PBKctfuZEgqvpEV10yR1IEmcCvIPbXcnmhQc/ttMQTYuRGA4adtdWZ5EnS2Loe6LOkfTnTKd/ZkQHmOD2Hd5thFcU1EqpyjQivD3tzLjKAJBAjGOKbaGlVguzrgEJCwgZgspXDfqWB5j+dCP+qFRs4Q01aAA3/GDq2e5xZum+0hmMUCV4WnNkGhYyAqQCSIP++sQeZMa1623MeMSGeTAiunUV1NL5dJdRIrMcCZM1iKWh8sFBdwnW1+UCrNWjrsnY4C/1Rls6Ozy7vE5L1HsNybP6Bf4H1dUTG82lHz44NOqku0OkwXOxLVvrOI2xxw+iFrJgRcLWKNyrh4AMUf12YPzisnwnhy5CU4pQIEbh8VpfjuIehPCFzTi6dTKhIvBT++v+ic9TD7daFXCQI9xpqjHo6aHMWRy7tnYNSFMpthYduTeaSzKvc2UZ0bFxWtB2oiqa4mZTXox5yHikNZ6MLYtPjWiu9r5/i5ES1jRqGCBH8LClhEvIpZcf
 ikmGi2Il
 vGGypWq9HPgdibNrC0v+nwQ963EtJ0lWdAxcHB386v449gU+Fg/QJN6wL4RIHGMdPiIi1eMTuM2bq3sMhaVFUgPZ6XtdL3UnWKwIUey8QrQiieZDQ6ToWBEN5Ycdez/qd7E1XlqmP0wm/9GP7dB3XGnKQOL9SSf8wVCzeXb/9pTUBCO+CcfDsi3OV9GbJwha5NkRzOZebi5oWsP1r61T3QhZyOFBTSPaRAiDyibExk2oVjIx9D1CMXip48v65hr8pKXulbyPIl6g2RXx8BnKBGIfWr3gwGCCXISTVTrisksLT67yPbQvPTGo70fWJcXhC7pBOLiyJ0om660lTRCGmNxt+MF2PiiMYovQpoVUFwmgPQJ6vN1o3vAGJbxQk2hJk2TnPOyA7Rjn5kbc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 01:07:29AM +0530, ssrane_b23@ee.vjti.ac.in wrote:
> When read_cache_folio() is called with a NULL filler function on a
> mapping that does not implement read_folio, a NULL pointer
> dereference occurs in filemap_read_folio().
> 
> The crash occurs when:
> 
> build_id_parse() is called on a VMA backed by a file from a
> filesystem that does not implement ->read_folio() (e.g. procfs,
> sysfs, or other virtual filesystems).

Not a fan of this approach, to be honest.  This should be caught at
a higher level.  In __build_id_parse(), there's already a check:

        /* only works for page backed storage  */
        if (!vma->vm_file)
                return -EINVAL;

which is funny because the comment is correct, but the code is not.
I suspect the right answer is to add right after it:

+	if (vma->vm_file->f_mapping->a_ops == &empty_aops)
+		return -EINVAL;

Want to test that out?

