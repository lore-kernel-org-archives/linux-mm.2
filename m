Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6ED2CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4218E0128; Tue, 14 Oct 2025 10:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E378E0123; Tue, 14 Oct 2025 10:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74078E0128; Tue, 14 Oct 2025 10:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B1D558E0123
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:06:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8938C14098C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:06:38 +0000 (UTC)
X-FDA: 83996895276.06.1562018
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4C9AB40015
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:06:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lK8uoZSY
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760450797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/V73HB2j0SB/c9ybjOOfbzsInvf4MCE5FolGwdySDg=;
	b=3hf0uae6dBEHob8cM2ivHtLVPEQhwUcTROG8TxcuZRuk2EQVbIeOyKVHp9XxI/Kb+MfI33
	sgBq9VBNr2QcwzZeaYvMk17OhEA8sesSDQF0IC5ayLtZ9qYNUFuHiEAa8i5Gwl4I+Y1tGW
	+riT+mz00aXFmn7q5Av3RZxtQlg8Upk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lK8uoZSY;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760450797; a=rsa-sha256;
	cv=none;
	b=I974QKNJZzIwz/7+IjgvJsbJgpZX36/Eyf3QxlY63JyP81zQUR+KwuBHukBaVaCdCl9h4e
	e0Ndmz3157XqwprHc/Nbdz3UMwli4xHJ/AA6HeuQ+eyA1UXX8mU3a98lYTdxXCrtuvfKUR
	CSZ3DGEYx3CgvhA7DPi8dTCJELx/bpc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=e/V73HB2j0SB/c9ybjOOfbzsInvf4MCE5FolGwdySDg=; b=lK8uoZSYpxxAgKRKV/Hch8ByIS
	EVXALti/OcHwaKhZzxpYN1cvdWxikT7SKQRge3XVTafJJd3OjMjoxORgfBybUR4FJoAvcx3hdgiQP
	gXE/pec3m+6ks+KKgnkEsB8xiSabU4tVrQK6swmiAIX0qZP/qgZ+AgOhAk0u2w3nuCVcWnwUx7JZn
	Op9Cirp81R0019U2e0Q+C7ycK39oog7XyMkE5MiYqpIJzv0LfyrzzUsJXW2LMg+Zm3NtSmP+7z1mM
	vOjgQ0c2xJlIx7YMUOisNNHfTzhkry+JzUsmXVtZLi4+YuLGpup5hzOhLOuC75093AZdIealQjdUw
	pJMyaopg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8ffM-0000000C1Ts-0nWf;
	Tue, 14 Oct 2025 14:06:16 +0000
Date: Tue, 14 Oct 2025 15:06:15 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Subject: Re: [PATCH 0/2] optimization of dma-buf system_heap allocation
Message-ID: <aO5Y1x82YN81Mh7J@casper.infradead.org>
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
X-Stat-Signature: wzha6pkwcjqrckzy9k3t3oqgcndm9x43
X-Rspamd-Queue-Id: 4C9AB40015
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760450796-417647
X-HE-Meta: U2FsdGVkX18oaZ0k2R90DY0KxZIpdJDvFA8QM+lvJz9quhwBod3q3RbQovVFwzdN/xfk+QzJC11dbhHUuCIgm5fCyKryxcWZMB8FPGcZTE5aW80jJrhYWCAvDiBtH1yulOHlA1bRnuLJayTGZPHaOWEyy+sOZoDD1zJf4uj8sMaNnZTlrMO7qaLAjF4ovXSuhXY9D75wB/w2ybPZGrArbRDxDrd5otbyboD1PVJz0v6HOTtMjTinS8Cu7nKoxvtnoEGomgjNoOB3u4G4TJIhqSbEXQT8nU+JL5GPUWIUW0y/6zo3+ZJ8FEZuWyBGN3aqH8xXMZkJpHmimrIZuy3B6Zc+/A6de/8AgMWsPF+RIuQtQM/n5F05L3oJp8E7LOIHdj/vGcGLNmjUwjUSZq+6MtlOWc39Ry3PCCfM4KGL94oUmBIdiUS6Cl2jXlD1wVKKihjcvmNmRbUowRdIUOaWWN/K77fnLiPjRmi+JVKKGkpr/6/AWh8J0PcqRWci1TouCPdZyzhz9nS7EY9ZmxZpxyQtGbq28D+CGBGA2RkY42ceB8zu7GsEI4QJsPbIsn3qyOU3bBhjlcbVYqzFyihz2ML/A6Tjf4awTO6EqbphcDKQEF9W06Yy+uX5pX+zPOxIbBLBHJMqNsBaKm/pkC2naQvqv8PiQ/vAP8u1IiCpIfkO6ycPC/wtoAx35bJ52u9tO7egjNlMED/XuOZs/QbEXwKto9gwmL9BYkqlNukbnmJqDHHW4gKWtVC3jyxixCSEVeKEDEkcRa6de35h1GrMctxjD+I6X2pMvmfwDB14S4dOaViNtCDcu3TNuqOcOHKg0mHcsCXbtIdBpffIIqt2xBbjo/6tS/7ZZUyWvUCqmbsC8SwkLFZg7cDfTQLLmlqA//4pCd3VLV2dZ0b58/yF4wM4u2cZt6XX2vePtW1mxQm43iDsN7BnJKBx/XBCSAkb8Z1jy2vMrNQuld88MdN
 nuC6pf2A
 tRNJMGEvPYccwOf/DdLiJf83SGIf93nSFnECTTZCD1atVUQ3XiUjG89Gn75OMZu6WYYV1XvN00ayTMzZ8GkIeKXjBBkLPmF7OU67YiOSkwJJldL3H5urOntZDX3U9qfCjNOLn59MK02yiKrX+028d5Vrpc/4WBrrTyy9ZgUbiJXcgp3t/iJxKZXoLYvx+wVPR40mp+d0O3Otb673teJLeBFX05/8jS3AXxHKX9Nid3Dluynu+0OvekWIs0e7yTKs0g8tz5WXI4LUzvdIfPvCWIF4k3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 04:32:28PM +0800, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> This series of patches would like to introduce alloc_pages_bulk_list in
> dma-buf which need to call back the API for page allocation.

Start with the problem you're trying to solve.

