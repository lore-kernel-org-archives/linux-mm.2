Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C134F532DD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11BBF6B009B; Tue, 24 Mar 2026 01:43:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC8E6B0098; Tue, 24 Mar 2026 01:43:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0092E6B009B; Tue, 24 Mar 2026 01:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC7BC6B0096
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:43:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E70DCBD15
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:43:47 +0000 (UTC)
X-FDA: 84579864894.23.1255419
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3576F20007;
	Tue, 24 Mar 2026 05:43:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pBg3WXbP;
	spf=none (imf13.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774331025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=vvN3BZlTXQ+ji+c7NDdovaQwRLxYLHhOIRHqkOEmzBdn7xsPYJjlsvmlD/YbxE91i15K/l
	TlW9sbk96m3Vrx+HKfJNqeQS4l8QA9Vz4P3Es5lssmLKOYldEq7uPUQDG/mrumKOOlgryU
	TXtPx0i7RR4Vm1p1NvWknH5fttT7Avg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pBg3WXbP;
	spf=none (imf13.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774331025; a=rsa-sha256;
	cv=none;
	b=RilE2+w9blONOT+BqWfesTsHNnxNrUP2NSm1ygR3y2swI6hgCP4DsSgeUOoAY+dfK8NPNF
	RoaWO9oMPg0tJbyT3+uV35dhhpwp6dT9B1ioKXVBs73Ki3UpEEnMUdmCZpGXEdAPzXxOI8
	TLLKFxmpkjFN2xVYHDmyw/ZDhPeZGvw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=pBg3WXbPnZv55WxBVyYRkoDwX/
	bhO0iH+lvaiDDmwAyc0oFQ0HRIISS6eLW2R4k/Nj/jCpSvKn0YxJt/uDuDpK0IndKu7Jy5Vlc8tvo
	YnwzD30uubsKFUTEhfipzSOXDxxlYV1n+8zpnEWVjwSfXegb1Sy4iwosuZyXDKey5Ool+RL+byTpa
	bwkUEoTbsvlFqxwPp1ZFRp1yiLTWdbWpdiGjVaBNl0iXbKLtLz7yzucfJ9t/0lYAOEpTIVSlYYZKO
	agX5bajDkIelu9eq/ZhUaAW0f5e3D00GmTO9U0Mi80khdn63tvr2LmNxYQLhBEs36PhPnrh1GG2vm
	aCp3YIyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uYG-00000000c14-1EsZ;
	Tue, 24 Mar 2026 05:43:40 +0000
Date: Mon, 23 Mar 2026 22:43:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 23/41] aio: Stop using i_private_data and i_private_lock
Message-ID: <acIkjM3_-JrY7QE-@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-64-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-64-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3576F20007
X-Stat-Signature: xghhjkysr83up3zza1x4z7w4i3jkpuda
X-Rspam-User: 
X-HE-Tag: 1774331024-41451
X-HE-Meta: U2FsdGVkX18d/pwIQ6GMFYWYDDGF989A7SvUF1ZHTBcwChbT19b6FlQ/jUH02C8qoj55oqhl7Nw8Ko9A+ZxAYqAdvXcYDfzR82/lpt8Dyeu4DNXCMRWNDszNji/ljxQ1uDQka+9eiEZorPnizSTqOFvT4v5EZpS5+S3ACX0zzYJu5xFgUy056uc/F8pLqfm2RUN89NzTNIET0I+QccbPuccUDA8XaPYYYTM8F15tKIu7PJ/x3VeLyPbLL/V00pZPnswpAT3JiMo3owJcrGPMAt4ySLUS9Y1XV70CMUe+jQlzfwJVb9yIMMHWS6SGrlXk2tr6p6yzktVkTjM6W7Zdf8l6FySdYymOLaSADWLwdOXBmBXyB4QKXgBDFQvaaC6aOtw65ujjJnbTGcJgR+VTHc/Tl9jHhWz3ogm6ON2wYg3HvzuE8790REkb7ua49NyY4lsLHLPC7KAQXcJla3CXXHKDpWiS1VjV2sTZlRjIJ1SlFBNm+mCzHRn4p857zBLK+k1cuxAALh4l/pLD+SPwzFda+heead69H5YVnPXgTBWp6m99lnJvNZkjnMmpEDfiraPA6IpN45bVNTieZMur35MZCddLEO9HLjrHcW9VH++KLKvnDAHxL3YEZ3Ek7Au/T79QrZhDQyWnaG2Lhl+22AbAI5tHXlIe9IB0q46Ry+2Um7Msj5AvXQovhhsrFO8iOqB6ikBBPcYXQApXfoR90RfRuEFSpBnM8/dN21BuqXeVPAF3dFiY22IxtGk4SX4Yj8sXIyjZRd4gPRZG20POlEBnViQRFhPT9EbZXRYU0EHNoqL3IBHM3N1sjQej4Fz3FegCLvbKILUuxe+oOxr6sdaYLgCqvvoj7tDpwDM6QeE+pVBrMI902+IzRhgNnfKlAfa/d1h49dczefkgbvcBdGYmNs3q/HH5spzIpH2oqILdft6hUZeAHAYzqSx07/i+h9RMAgbeDOo6T/DbkOw
 OnlXfVQa
 3thG/CCCwEVdRLKCO2rZwmsh1R1i7bY1jKpXQMuRbUK3FSdJK7nhsGqNLxYIhmDId9V5N4NTQOYXiTsx4g24tGHFRsYeHYzKujs4bb/Ovf+L31ORF71KQYT0DCJtuct2mllCJe1TAA4jwIIXFlOcSLNELnkA7+IGAK3Q5TlzXZXKp0umG8cPtng1hEi9xY8qDbkbNcyEWzit7lxSJn62EeMNLdSoAFNEfe0mqE3SZaGgyn52pm5/vzvvCtZWwB6anfY9CWzNzBaCkEbn+vky2aBcHpyKB6xnECFkgPnjAcMZexWl/gVDPSMl4tNePdSDBsNLSxOM4nN0ifalv7KfyA2G3quxqKjb/qLu9SGLHjmE/tgv1HE1e86KK46+MYIEJJwgg9hgYJq7oAfjC+JO4tQtqGoo0Tp2l7PbpQYzLgw/My9tl9DEuUJ6d4FaDgAL/dS5qmcB87wGcGDWzmvKUavgZlLQFx98/VUvLWNMoumnJNqMJ+zx/zEXMUrWvMLhhi/Cjc4+RiXdwyWeTQ8P52Be4eh7DQWHRmTpk+wNE2d44H0KfaC32rL7NLw1clVcfHqRVrTPZ/Rl+6QUwr4WHG2BUBsLIed96zUX6V760AC6zZSG2IcWiiV9w+4t0WTNZW+WuBeGhPWIHDoYGDv42imUlRJlUOTa6WJnCYNxmQhvu6ifKyDAyZDcSIteCu3Tagt2MHXwvRuk5c5iCQX28C7qe/i+UNOFDdJ5iReWq2Sk9l/dqeBK1Kt9SiygVDcf3eO605xw6I0Q/I6pXw1dBfEavPyVGr8FzRp+LVeDWKXzh2ZYeGlc/w/79Vgyc34++qdvrFJojVn+HCTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


