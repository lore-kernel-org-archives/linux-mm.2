Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5297C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 08:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518FE6B0113; Thu, 22 Jan 2026 03:34:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA596B0115; Thu, 22 Jan 2026 03:34:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427266B0116; Thu, 22 Jan 2026 03:34:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E33D6B0113
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:34:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B10CB1401A3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:34:34 +0000 (UTC)
X-FDA: 84358938468.30.FF0CA9B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2A66440008
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:34:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2moXo0MM;
	spf=none (imf27.hostedemail.com: domain of BATV+561f00ef1fac768e3611+8187+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+561f00ef1fac768e3611+8187+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769070873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wyKG6mSVnYVdf6WsGgp/YJqBxiUMWc/coML45itFX9Y=;
	b=IWTaJI8DV5sEg+UPOwdbCteduXV9xTU765RNaa7DUIfTzlsTYtpQDFB3Z5v9IiB/JlK0g/
	P18euAvegLIoddA+ehzOtoZO7BXqjF313QISVi1L0ZHt/FFX7+YYUc8zn335hx4VZO2UOQ
	vahK8mz/5yeide/PYi0kceeftn2BZ9A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2moXo0MM;
	spf=none (imf27.hostedemail.com: domain of BATV+561f00ef1fac768e3611+8187+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+561f00ef1fac768e3611+8187+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769070873; a=rsa-sha256;
	cv=none;
	b=SALcQR3Wg1CcxPCp8TPDeiunVjceB/q4haOqwYzWQpvDHTdyGPHlLAigMxT7ESdsYsR71j
	fVHyThYFT4k0A714VSLEAdO+WSeG8z3Ror9Eo7CJx+LEul9dw5XpIQKktNFe//B3ssWtiA
	7eqj/5iUGQu5g1aPzuUbCC+c6ct38PQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wyKG6mSVnYVdf6WsGgp/YJqBxiUMWc/coML45itFX9Y=; b=2moXo0MM7AqnOr1r91L6tzTt0Q
	8Y4djegXXpfVa/iRYwy5+HfmImkZq/F+jqFu0eN101xM1Pg4Yrcu22qbT5qeBmFHTF99Bh2iU2yqP
	NDIWpRfPtHUvqb5CZQ+RrNe7mFT79LRaVE7alJFRxUFZva1lmQtuTOHuNG5guqb6Z3G+9W1HzS61b
	vl/P6QVlwyhzxjm3wXWTGtIw+fewNWfjVG8hDKxyaCGgvJuLMKdjcaSy8KvcI0wt54yOVytH12+GO
	H/T+2MD+uAlklTccD9cnGVXmeGOjcl+CCavvGFgDqXe2LExL4CnOnZPvlEGe0Q+98/UPz13rAA08k
	2sNAS85g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viq96-00000006epL-3gs3;
	Thu, 22 Jan 2026 08:34:28 +0000
Date: Thu, 22 Jan 2026 00:34:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] f2fs: improve readahead for POSIX_FADV_WILLNEED
Message-ID: <aXHhFN-feFYFcKYu@infradead.org>
References: <20251121014202.1969909-1-jaegeuk@kernel.org>
 <aSALfvLUObUGSx-e@infradead.org>
 <aSCpzRW8mUhNnjHB@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSCpzRW8mUhNnjHB@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 4n3t5ke5tnchb75bf4xyzf79g7qe5npu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2A66440008
X-HE-Tag: 1769070871-475197
X-HE-Meta: U2FsdGVkX18xzJ5/qFWqFaBt87Q/u2/+Lle0ckSOZrrKgBO/UnNeWlV3JmE14pOd4Gh92j6NJQd3Gmx6kRdesxdoa77ycH+q3Y2Buw3YTulPf8pOWDo52VH2pLNewDEOfLHohE7CpSL8KG7+fFzUGZd3e9DtFyLpcgOcYemxbF5+N1hl218TC0MOA8/3oeAmQEeAkDfVDVFcNFPc7VawAIRtcKtQwLaqcuQC21br84QLCcnzP/S49zivhL8EzRFgr4rHH3LTl7GDUiezb6pid0ko96OTnNoyV8OwB3XFjyhJMDlfUEi8mj/XWpSB2MBjiIiz8v0Yap4RdqmjhSUtDLJKUhmHdXRe8ZGsWaebLtJCvu/5S9vPxP5MtRmC7vBY347ZLnd5uK2MRLODV6Y9ht6lAvNX9ZL8HUyYX7JnHHSUCFu9swvA+FsGY9I2r5hmzHg+pTg+witY7vqbDBzX+pusNOwYFhOyeiBKiL3bpkKX4XebMm6TQlLhD3bL/ooo5mVK7H49hS2XkvhgBAADEkSbkZWQ1/8HaUnDR7BF2XCkiFC7fI5B0NoHndez7OgGQ3z0AybSW74EOG/DO1xlStaBLgGgG75TE+FM+0SipAItkW9X5xPik1eXdR69hqECrjQ2GF+B7E1Eir28JXC73QlUaa6/wQk64GHvwFnFisD32Kb6VgXlAVsuyrbCLAOuDyoTTC464PGS62EiKWqJedTCI+JAp4JiZW14W/wibtgRaPEyNSD/1JETmoUPGNNFjm0bvr53+g5bbTDulBm8yMtwqvkf8smDsmbNIx744A1TwSoWbDCo0mvGcQ/ROYv2glTEAVOT+YezN2sG0bP7RIOSBQGjP0wAYOxVrCKHi7Xjpt3iAcMcELx3HddsCxwHn09FCE9vAa+wAbZqEOxVTKtW4o6uQZSn2lSN03yQfCXeVJl1AP94lMjQtzHYmPgZpGLOG5gMG4AdDFAUzx+
 4CBFU3T7
 xNKCea5TytgaMlQHpgYlViJLLkkZDUPwScuGzmpHn+Dzb3Xb8FmDyhgKrlreO4LXelVw33sWZMWgrwZ7LjnY5g/lq01QGqSkpJrZjr+RDr3gRZ/Ml7eiJjLXLyeRYnDAsUsqlR6br/YvzEW7YCHSvU16t/tunfP9IduPtIANxPznLOkcIj28Yua/Olp93nq2bMYrzMkzZ8O8rUH+RH3ZWjvY9PDOMirOSqE5BA7/MkA/g3SyvD3mQduIQ168NdmKzA4R/t+oFhi6wyJCSwwfgw9Y+kYe4kGLpOqVQnibfV37xPkhrGSNeEeXdQJm+gbzk+Q4roUFO+b+gFsZiHto0oXWcgcFagEPjqodHEMpAd2FPPzTKylwYGqZYaKydmeK1WKNb6ptNAunb284/ZWXIWHUEmTvr3BO6IxUEoFul+Ajxk/BVyc0gH2WVgbgUv2CrXPbz4hXGH5eFckyG95QP+Hgbz02LHmi+tOWri/vymALXTJf8XNN6am0nxF/a5bAnfNvZSzpb0Gl7c6Ng0Fg+nbjF3fI7+bfB+N49YpMbm1nhDHg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 06:05:01PM +0000, Jaegeuk Kim wrote:
> On 11/20, Christoph Hellwig wrote:
> > On Fri, Nov 21, 2025 at 01:42:01AM +0000, Jaegeuk Kim wrote:
> > > This patch boosts readahead for POSIX_FADV_WILLNEED.
> > 
> > How?  That's not a good changelog.
> > 
> > Also open coding the read-ahead logic is not a good idea.  The only
> > f2fs-specific bits are the compression check, and the extent precaching,
> > but you surely should be able to share a read-ahead helper with common
> > code instead of duplicating the logic.
> 
> Ok, let me try to write up and post a generic version of the changes.

Did this go anywhere?


