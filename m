Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D80D1118F
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 18:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44CD26B009B; Wed, 26 Nov 2025 13:10:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423786B009F; Wed, 26 Nov 2025 13:10:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 360736B00A0; Wed, 26 Nov 2025 13:10:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2678B6B009B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:10:43 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E561D1401E7
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:10:42 +0000 (UTC)
X-FDA: 84153548724.27.E119803
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0D0D78000B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:10:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=UwduLDd2;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764180641; a=rsa-sha256;
	cv=none;
	b=40E62WWMGMMYsMDtX6XpBXDgR19lsA2hdgZXtNXtQZiYL+nsqhpJpl+hEJ+GTjkr3fs92B
	o0csBZB4c3HmonUWUSSYu0wDUY7Si/fni+wXGD+BxKxRRybUtwRaGPdESBHWBVYuexRAZD
	oH6NaGFMSdXO8UsPKns6qCZ/nNdDGLA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=UwduLDd2;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764180641;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXnZBmMMcBqaL+DvhiYDDvgc0bvBDpQl+0qRcxV/rMI=;
	b=mMT0G01Ha63/BNMn022ttDJAes91khHxaeKqDW1PdDQqxIy2I5DvS/WM0rq67jDIXzrkbT
	mXHJ8i+Nocb0XlEzXgcZ/dm/hftaU7IZUI266a2wn85wrezarBmUaYbEqbS72xHN9mTp09
	DM8n756jea2qwZ2FP30zej6SQyCPHtM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DXnZBmMMcBqaL+DvhiYDDvgc0bvBDpQl+0qRcxV/rMI=; b=UwduLDd2QSBZYnTFsQNeZ7gUhb
	ugR7BEq1Awwb0Sl1pJANgCHa9RbW5fJogb979YgNPHGV9moAmTbrJ6s+dLcDAnnFOkdE4tVuubBSH
	1VmQFY5MTGbuZQOjMR/K5XUeGRnPdTc96EEZU292HRpDwwwP/7Qp6fj3DKKvaETaf3TfjYtpFLcZh
	2WxqQkz0AeUZ06OWl+kipIg5QxxFnOtma8Aeti10N6RW81xfDSQB5RODA2zZdiOKlBpbAYz0kgd0d
	w5QRtNcGq0hOCNpK0/DWciUgfLnpEdCNlBBC2JezPucP0NYoOXK57GRna2MFXOhCuGmbsTWXDf04q
	5dglf4Yw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vOJyJ-0000000Gm9v-1MMj;
	Wed, 26 Nov 2025 18:10:31 +0000
Date: Wed, 26 Nov 2025 18:10:31 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: brauner@kernel.org, jack@suse.cz, linux@armlinux.org.uk,
	will@kernel.org, nico@fluxnic.net, akpm@linux-foundation.org,
	hch@lst.de, jack@suse.com, wozizhi@huaweicloud.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	lilinjie8@huawei.com, liaohua4@huawei.com,
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com
Subject: Re: [RFC PATCH] vfs: Fix might sleep in load_unaligned_zeropad()
 with rcu read lock held
Message-ID: <20251126181031.GA3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126101952.174467-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126101952.174467-1-xieyuanbin1@huawei.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D0D78000B
X-Stat-Signature: u8g7u16fgiymat6uebzidkwjbydnqxzs
X-Rspam-User: 
X-HE-Tag: 1764180640-321292
X-HE-Meta: U2FsdGVkX1/LemoW54UV94ELDcJxAWRE0EBJ2f6zzKrEp/nEceeGDngN/lXGYCIWPzDzu18FOYaCrUlwr+hzcVUJOlvqaMvQhZU8qY+u/z9bdXfSULT9dBuaT0S/hsBIsqtkz/xeA2LDNU7sh1H2mVjQDDCEH7r/qE6XtB/OOPzh33sWCLS803v3NIaBDn2eBbK0+NEHkHh+6dPWidbiDLE5BvTihZ+FT7Z9RsE5BEywrjHOz8HiVlThOLEfrLMQX3zhvAp2YTUEgCbqbNyNeQ2DvV1ci2keV7T9j9hqjh6W24fpRpFHZOwONFso80BtMaz83N5wEQgc8jMGLnCjjgpI0TftGp3VT70yavwXmkIj9p8CF/8TWLgLJ0tMeUVRAnpAFsKhjmwVxH3jzAEHPne7PH/Jz7nLwqKPSVOyWNXSaFx+XnvS9Z6BibZ6ChY9QGIrqzAXlQaIKsJgcaTBQXb+5hj+m8OTfyjdsLik3tgt6QzEvXSu15EFrMATrV8dLB43w69J1UYbIT+MZo8Wx/6kGEP1yxDw+gnptRgxLNAw3eejaU6vNERuCvQFuZxVkXw0uZwiL+h1N5udHw0Ye548uoqkPqkBK/FerOsjcNk493w+R8aBXhQ9xnPoCGggp8NSiZkKfJyRnZkmkevwI6kJsZL5DHTJwwF1r0pOP9P5ZmgQKcCOI4qt1CT9pE2/jT2P3pfHypsbmXirA+3lBTh178kvzjwxijokq+UDCPVI1UzU1g15mNhwLAtFVu+PyVXU+v/XnJAtNJNH4RZFU4Jm4OLwhuSX5V14E7JuPIYRG61NUt/K8LnPp1W2SX0dP50PvCih7/TklaCEx2ihkXi/XyOXOEoK21luknm4dUfWbT4fJ+cL03u4wo4Bsttvy9E+RmxvBp8/54K850glX1deuRJme8M5jflsh+iB6M4tBC6RViOqiZWKd9NiNnnPWfsF7eLSDlriDICIlfa
 7c5shlvU
 Mdb1akD8dE8ZLB2IZaaHrUhhbElG2xg4jG2K93mLenZxhzj8Svv8JVkajemxOrjkUbPJKMVe9134GEGGYB+YDfDN6wsRlJXIFKOSL1lBO1VfmrUOCwF5H/bu7qU2pi1FHQp43H5uPReSfH7778gOnYWyTeaiuOiCPbcrpeagh6VtZ3CocQtPw5HDpiG8pPpoGWDrn4r6O7ZXftxt7Xa4u4a+o51ZbSkx0OAfPgY25Q2x6llGxdpKfYb34GU1IPvha5lncS+sn98E+pbh38OYWaQMdZ42AXNpypESSMApcjZw+YXKIvJr/JNKL3B4NNYhbwJJVQc0VPJMBk29iHOTgItHTfgy6WG5sWKl1YTj/IoI7zYdk7HgKshvJdKA4fSVW2bPpW26YKX6uzjbhpo0fCydAYEDBiRuu2OIphfGgKdUw4A/CtwtZ+2WlcL1bXryrx7QCWHglJJ9JPzaQ7NZpBCIwIwwH/IQGBUcnWJX+y70N2eA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 06:19:52PM +0800, Xie Yuanbin wrote:
> When the path is initialized with LOOKUP_RCU flag in path_init(), the
> rcu read lock will be acquired. Inside the rcu critical section,
> load_unaligned_zeropad() may be called. According to the comments of
> load_unaligned_zeropad(), when loading the memory, a page fault may be
> triggered in the very unlikely case.

> Add pagefault_disable() to handle this situation.

Way too costly, IMO.  That needs to be dealt with in page fault handler
and IIRC arm used to do that; did that get broken at some point?

