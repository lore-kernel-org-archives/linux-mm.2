Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF5DCF94CCD
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 06:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11396B0088; Wed, 22 Apr 2026 02:07:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2486B008A; Wed, 22 Apr 2026 02:07:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD79D6B008C; Wed, 22 Apr 2026 02:07:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D0C4D6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:07:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7748E1A1096
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:07:36 +0000 (UTC)
X-FDA: 84685160112.05.9576E1E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id E174740008
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:07:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mhQQAfKH;
	spf=none (imf12.hostedemail.com: domain of BATV+0547bc4a5174ed997a0e+8277+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+0547bc4a5174ed997a0e+8277+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776838054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMW8Vx62O/6nF3nfk6vYcn+eHtMGo9C8VQwZfMzOmSE=;
	b=e/Ly1MQFMqunHKImIb4RqC1MP/7DkgJLBNvzkwbuCKJL6h9Vojb0m3N8TvM9XbFWiSJn0J
	9FP83vplOf75+cIk7t9QIlzINAgSUpZUAopCctTWMKeoCsHAtHyjmVqpJkYHjagxvCJHsM
	77yodKrZq/+cFTEcUu8lVdH5+xxcwCc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mhQQAfKH;
	spf=none (imf12.hostedemail.com: domain of BATV+0547bc4a5174ed997a0e+8277+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+0547bc4a5174ed997a0e+8277+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776838054; a=rsa-sha256;
	cv=none;
	b=QTPQu9sANSAp5fjCTHvkO4HS9LdKcO1ir+RzJ9LuU/J7zF0LpW2cm7ZBecQCCl+UAslAVp
	gS28Poa7uiJxLaE71F/H9+lgc8VRvwdJuxhCxsGQR3P6DCogONnCQDewmSLFyNjMNKzhvg
	VHGgsznLQMS51ofo4jyCFi2pSbn0o28=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iMW8Vx62O/6nF3nfk6vYcn+eHtMGo9C8VQwZfMzOmSE=; b=mhQQAfKH8wq6MdiElxLqzE+Grp
	5N8rUZoz/v5Ad4W+KwXlBCbOqnKpP3GMR3VmbXI1gRczQIYGeIrziKkQ5qd6LFYa5urpf4o1Z/i1i
	w5XCkns9AfiRIlEhTa40BVc80ghInlGlWpYSAvlQxa8+zRUjwQfCfwBagKynbTNYsU/RYbqjS4Mpo
	1hZSCl6G5FP/2UR3x1zkIAbsvxuZ+TNnmJHNNmgdtgtXNPHbcsKCOTpZmRWgt4M4W0RE8zndZQZVr
	9CGbdfSYhgIOg/TIX1KhQugVpPFEWjsOFMQL48VTDosr/0QOb/Eu0AGuAnZUs7B0UQjqJLpYxyip/
	ZZsxOZ9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFQkD-00000009e5R-3tOZ;
	Wed, 22 Apr 2026 06:07:29 +0000
Date: Tue, 21 Apr 2026 23:07:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Salvatore Dipietro <dipiets@amazon.it>,
	linux-kernel@vger.kernel.org, ritesh.list@gmail.com,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] mm/filemap: avoid costly reclaim for high-order folio
 allocations
Message-ID: <aehloU-hKZ3VDhbX@infradead.org>
References: <20260420161404.642-1-dipiets@amazon.it>
 <20260420095106.86ecdb685cd31e0847362512@linux-foundation.org>
 <aeZzP6iQel-tkZOu@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeZzP6iQel-tkZOu@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 1iqf73x353r8eyz7e6w3qrsn4q5fu1pw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E174740008
X-HE-Tag: 1776838053-425472
X-HE-Meta: U2FsdGVkX18ovbpL5zneHFbPeX5wP9sdtFyXC0HdSEDHa+uHVIoWxSOXaJw7ve6kZnE6Hud/Mff9yDAHiYZrQKWPF4skCjtTCmRFsWMxE3TMcea4Ec+Bzfa2KCCuqKO/fsozPD3LWbjKs2T99My9tG9b0AzEO52pQGU62mcUvDPOrcHw6z1fbClfYZlSDkF2ngkaJWEaXHlau0qvnwNT/eGBZg6HxFzMLMG2N3oe59uqocOv27UxoSbceYprczzonNxKbgmmFocRU6G2KAkn6DTH8XFYB3GsVNkEmP2dOrRsn8kVncSG8IP93ujtm0V/c9NQndPEUj1/G/rE43NDs1i9d2rnZ7NKLD9OScon+Dj5/uU94yUwDATEsjrl/3+2/xKI5PtF84Db72o4DdrMBWDmkxC5O1zHcOEqztTJxI8Akof2zx8BOgZ/eGcS07ApiQBrFY8jH4wRUEY86se/0zRXd79hvrh6Vf1KAOkXNcrxkjCMUAy7wqTIsH3krvJ3u2Mijf1sMSA4azNxzHJh5qDULm1mCIyJStl7Z/YvdAoaQTgzjUby53UdIoAnnlkHzPwZekyfgIMyQIrx8bu2fcJ3iEVecwz6/2OLRCRPusemiwSuv8s7N8mj8gGki9dgKb01kqDUn6rcJyUCR3qosI79ZQ5ZKNiiZlOcmhHf46IENs7mn9V/PBTkDDXf1+tF5KMp1cAltPHaSdQ9ZTJ7BQrmZ4ObTVYIhNAmlfsqzQ6wKXALIl46a6PItmKLhoEDRYj0Sq0vO8hhHznmOAs6CVXFan74FJP01pyz89bSuMBh5aKnTqmpeMxpVj5NuOdEk29kondEBepwCzSVjtTZkYHmej7XdGBOCzcPRQS7wtBdRVvRaTwUhUwTFBA4YsDIzmh7+4SD5JOhF/ovSAz5gsCJklYqDMwTBBzab2q3utj4ndUCwnPEZySh5iFrrxPyTAqn6K8janEb5ls6aGV
 a+uWNPy6
 jlEFUaUKSwvS61PH01npSyeoCAiPYVzYtNMml+xLU2Ti8U6hWgk3LxOCvMT1hvowZGz1A2liv94fZnBJgLydnhTV+pqZzbLnX6tyOv56artyLGLQnmcvyFQ3+h5hnvUJLbHRPXXdWnkURLCPl3/34Zv0cfNIalFYMcfpVq/VOOyUP7nUJMQbsZQzVdk5OokVeFNkX3RaQKCSB5P2SfX9NnV9MX1RWSKOHtyll6w+Ey3U4Rq6uKMOGe5LgQW8W51Ow8IxExUrxxbDhVk2EN54Doe5TEzjzOl2oXlvrk1KNx1+5vacEikTA9pwhIo1LAKq+wX8UbIs7bMaJZ65qZ5JjQBi+GVyvHKT2AkigI/q9anhzULPwrQBvQrwyMbW6z7tQvza2Scvn5LnCMaKfvZnAJhEOiyR+wvN6VZYLNgxH1/3ojP5U+urp9LxmMjoRhynqYQHkFn/Kw/CUzsxSeS7X109f8ASQGSw/gY4RMpnNNynbjz9yH/UzC0D+GZ4y0W43C07oIjtUi3dVuTB3ks5jn+jZ3s8HyHKDr2Zej5suMuADa4J9FNVp6x76hdAnh7x9DkwX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 07:41:03PM +0100, Matthew Wilcox wrote:
> > 5d8edfb900d5 came with no performance testing results.  Does anyone
> > have any evidence that it improved anything?  By how much?
> 
> Christoph reported it doubled write performance with NFS once NFS was
> converted to use it.

For the right workloads the same is true for local file systems.


