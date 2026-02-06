Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D0F9EE20A6
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 15:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892A86B0089; Fri,  6 Feb 2026 10:29:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 840566B0092; Fri,  6 Feb 2026 10:29:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738EB6B0093; Fri,  6 Feb 2026 10:29:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5CEBB6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:29:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F30F6140210
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:29:14 +0000 (UTC)
X-FDA: 84414415428.09.4D3CD3A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5B99DA000E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:29:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=m5INnH5Z;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770391753; a=rsa-sha256;
	cv=none;
	b=BQ34bVbWLi1drpLf+x9WH3ENlztf1qaBVAKY8o7Hr8vFYbHgIkj32Z9L66Mdk2IsSVfLV3
	uhS/cCId2f3p/jdH5SCXjsJQ3Esg+2l5xF5OKU0nKBnM8p4s+zVwQq1Ela8+vj6VgiGH6y
	kXrkfr06TbXMeJ/g9wLBZWuQnIxv2is=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=m5INnH5Z;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770391753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVUop78ux91cHyjHUfguhbbjHSQTp88xnWvceiJRFLU=;
	b=nj9/M2CRrM2P/hEELRtVBuS3foNrIn9Mh/tpmlIDcay2tFpi9jDQcntmhlQV8Mn4xIkNCl
	ggBJK4cw3ygNJVI3d9N00fzi4wsZ75g0JeXVhA03oMCXt/+HE5JBq85dLRoybLF+RloDkQ
	xsWPR0fupuPjYYrj1A8LedYpG5t5Pho=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AVUop78ux91cHyjHUfguhbbjHSQTp88xnWvceiJRFLU=; b=m5INnH5ZnhfPYYArkaPSoRjEVh
	4N46sjbuTj/NJTBffuAyHjahVfHjHwPxqs9xsKjiDJ93ymlkOYxeW5zjGllWxGXLxttZx/pDHdHus
	3G9tXXoA7o57DwEpwnJeInxVGE7zPbB9w/uuYWX72BNiYd04+XEFBzdMSn3FpsNFrf3nrihKqjPcu
	w97WSSM18X4OvIpS7DNI9JR+v25D66+vmoYbkEZxtexQGi3Eu15715q1lWJi6bw2HUNnaEcJZlPF6
	ZRcDqA2OK+oq4K3sCL2qsA5+ZCf1DVCIXDc+02JsSS/FXLaDZQcyWIEX1A8lFalLeURFMRUNG8OvI
	bYp8Yn2g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1voNlb-00000005Ozj-3NPX;
	Fri, 06 Feb 2026 15:29:07 +0000
Date: Fri, 6 Feb 2026 15:29:07 +0000
From: Matthew Wilcox <willy@infradead.org>
To: xu.xin16@zte.com.cn
Cc: david@kernel.org, akpm@linux-foundation.org, chengming.zhou@linux.dev,
	hughd@google.com, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: ksm: initialize rmap values directly and make them const
Message-ID: <aYYIw3h35HOqodAb@casper.infradead.org>
References: <202602061522548871ohgXN8z0qq87sTSX-yZc@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202602061522548871ohgXN8z0qq87sTSX-yZc@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5B99DA000E
X-Stat-Signature: axkkxxg8fwinzwtsz5n5unafcaxnaq1y
X-HE-Tag: 1770391753-992310
X-HE-Meta: U2FsdGVkX1+Yomx0Uc/0/Rutw51GypSZ+wEUWvsciIbR/W+HEyHtmJeKVTRCPJsQab6+S4E0Rc7ODkzQzsg2ObDrjWZ1TwKVPjBNIl5A2fDKbb3aSMNYj050epteFiImcMp6PTeHi7n3KyOmvUJI0wm4F6qbPxuPR7mas25kwkidcGmn3Q598QCMjLWEm3y4PiDohJcFVopg3H5UieVRvuY4EzocerL333yTcY5C6o5IdvKNmd7OImHhaE1dSZZ+/eyhZienjCC/qPAOaGEU6Sp/ygjxQYXrC8Z1zKPxQl3l48tIMTBrJajhWR0do38X/LEQfjM3YuhlKcI/zTJWEOgl+VLbgn8EnVZWM968GnASa3ZQ9NDJIHt00m27Tyya2OKi7hr2oAYG1wMTgIp/uGEKK5qa/ag/oqvY7Qspf1sP/x4J737mLiH5bN/YdSlKpMoxohQjQP3WNhWv7ecHOXHAIVgSo8CqunAPwAvRDSOptH+lrbNesWE5A9kX7Buve5+JIFQz32iI9ij8GhduFJRmIsRQ0FPz2sVIk/nKcPVVJP7Xd0oRSXq89yVNIFAA9Te4JXL5Zm+MPRri2FcDgHuZc1Pg2Kfe3A/aHTrELVSPDFbKZ9S1Md9rVDxLraPE6ynUo33ZEzIszfygXHLUbvFWAYKb+UsTcvrs+9+ld/mjwgC8pPQXzJuuSmiwn/JjbdlG3RvYOHsh6mvkWX2hZE9BVgwchdXGs9cZXTDIb2b48f0wbLpBKRWjcXkzxjW3Z6lZTCBLH60ziAKzI51oXvnhvrBhURXuiyxzNFHIlu0+6GCrh7y7fnIc8OdVb2KoELKWLmGpjr+7Lsux26riqkx6+zr57vfX9IotAHL7jGaqtmElF30S5k1DabkIJbDyflpbOXiSy1468gnmfNxbkqOXj1PmnwEz4isj3x0N+I87zT4Qm2SzCvUtwKBUetkdLObj10nD2GxooU7q9d9
 6ilWxzVn
 /0pIDs5Vsj592tKr0ErRlknk7Kp9mPWDw8TVh2RIk/E08do8ltlQRfhWHTFq6H1Gwl074FQD13pZXbSXFaKMDXU2n8is4U6hxWgxDcHu5iOu4DQzFNjAVPilfQG9EXeqv5eAYazoJeghKlBm4UFnIPU0BWTcLQ//HkIuCko78VeryQCEBxcPeO8ojZg5owlTAHK+09v4TvtyOTp2V/g1mS0CqZ/GfTkVmwKC8HZE1RLKXX5890iUuGc+D/+DJHKNX9HsE7BXs8cj2h0OIA19pjzqhxz6U69Snrcdogdv8os5L4m/5mFgLL8WwYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 03:22:54PM +0800, xu.xin16@zte.com.cn wrote:
> make them const to make code more robust. Besides, since KSM folios are always
> order-0, so folio_nr_pages(KSM folio) is always 1, so the line:
> 
> 	"pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;"
> 
> becomes directly:
> 
> 	"pgoff_end = pgoff_start;"

How do you know KSM folios will always be order 0?  I don't.  NAK this
change.

