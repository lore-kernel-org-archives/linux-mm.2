Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B747CF532DD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0D46B0093; Tue, 24 Mar 2026 01:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2520C6B0096; Tue, 24 Mar 2026 01:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F28E6B0093; Tue, 24 Mar 2026 01:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF5136B0092
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:42:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7D711FFA2
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:42:46 +0000 (UTC)
X-FDA: 84579862332.27.9E501AF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 56E7714000A;
	Tue, 24 Mar 2026 05:42:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qQFeTJlz;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774330964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=c/hYDAMO1p9bwngeW+RdtCDFpETWMbNGLw4w22VCs6DgdauPwpAen5f9wFC7ESO8uoiTff
	9tz8bJv52wBzgtE2tHCSfQ3TdXARxhp30ToLr+ngW2sv+OOdvuoLnsw9D6mJ613qw3FbrX
	PHhqp6V3YfdoG0TeUvhlFN9C2j7/9PA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774330964; a=rsa-sha256;
	cv=none;
	b=v5S8vmyzrIZH8EisqEPBO5Jc/GzWYuMU/ESg0Emn9Gm2fCljFrTW1Xit4tbIE1fmQR6xR3
	VkYHwEDd3whnUZX4PcCXZozWMlCDYYkgxZhUQcH9CPdyY40BofjYdn0993XZ4qECVmKc2K
	cad6LWHR7ukuETsiN/3Rk0CivKiaiaA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qQFeTJlz;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qQFeTJlzyB8XD7CSyqWG4h7xpr
	fmMdmzbYgLOYphwXbV5fnnD7hUQYC2T6mP7De2t2Uc/hJxQPx3MecvEDn2YeYTkTUvPTFSeWVXqUE
	c26AfIUqiG8ugrvMUY/37vARh3kX/lMyW2BN5Pq9XqxPfdWElEwJCtEH58fplToi55p7eEfUnKVyr
	XhMY6ve4XOGBI1b0TgRPkHp20WvTZdR2IEENVsfUc8zm0P/x4E6WMvLsCeIaLiKXP+PBHQsseVkwf
	TYVtpSpTk5rCtgOpn3Spo1T4E8WYsiQ06wM0PTjurlQlKs5KzICqXUDIVHWSLZVLCyWU46FIS+AyU
	8EZU4hqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uXF-00000000bT1-3h7L;
	Tue, 24 Mar 2026 05:42:37 +0000
Date: Mon, 23 Mar 2026 22:42:37 -0700
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
Subject: Re: [PATCH 21/41] fs: Stop using i_private_data for metadata bh
 tracking
Message-ID: <acIkTafveTGFM3nm@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-62-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-62-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 56E7714000A
X-Stat-Signature: o8ys4qc7584hnjd71bqdtdf5x3ys4xqg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774330964-859587
X-HE-Meta: U2FsdGVkX1+1E6byT8f/dYp7OdJMn/Yd27pvvwtZGrVK6vc0bzcMsZVSr9CyWYbFkRwomYvf3xFAjOfjAknMsWK49TeOyandYBRlvmk8d8xC3lab8wnUmBcj++/HtFzjsE1O3AhkVCjQnVGsCBROBSI46v73n3mZFugrpXDSHUAszx/Z8rAxnOjlKhiXCwk1ptf6msOsoaUuvaqXNcezGG7SUkDAfJLB0+0DEOP+ISjbOPjLLcpjRROaVv64kM6ldJrmAB6VVToi9+zc8htnLITgkpv1N2CGVNU0d6/cpR/aixEnBdMxl/YuB4SYw0Z4SIwmOu+5zQjR/TSknX3owkyGD1Nu82jAhthQ845cZ7gyICGeQaoaXV3txw4Fetsf2j7NXkAE7gvqAjcObG7o5lw4YYhMgy2dRwf+B4RafupCATn0gsRAUJ7kI7SfPQTbVwWXMJP2+ss+8vZiQsTGXkyiPp/bkwscjcBfggdr9vtYsG07JILu1t+Uc+TEYc5J9LJMKsal+3yun95Z250+SmstGxnJ1MKDVqinX5OPnaMevZi6MI1xcMXa3N1jzoePDWaar3NNqWKm05wb5Kq7s1KVZkquxc3h6MNsiqMTU7yjPBIXDuR14oNKKy+FMcQgPd3GV4T3n42a9JTIrTQ5CNLZiSJ4YV6tQAdhwrLnoOhSY3ktcaD+1BL3kTYm7Ydj0ewFXaEsl4roVWZ+ZnDnBoeaH7q7B8vAxO9LUKwqkdNqaWLtanxLTdtakYQRmSQ/BRj9ko/9+x/4Qta2VkN12MBdUibNl7jr0Ws1OtINZtTfQoI5oIXqRr99TUZu1ir5pqUD5QoSH3g57Iw3xYVf9W1LuBpk8xfJyI9aYA2lrUNrBP0bWWX1n83ZtwVniddPMgHEakQ7nM1DTQssQz6Sg6HgO+Rnf2lvW0mUPn/laTG0n6sE2FHQzp4U6uJFAZdkU1pvtUtuH+H2YPgHabc
 br8ni5t6
 ecIHMClZGlEAgOZ0JFhGxND7xOWwr6hcdwa8/XIdWN2ve8rTC+yZggfIwVw/MJqUwlJxD4ToZKYoME7X3vIHNg9XHMBJjq1VGVvQFqEuXyHRk7dD1SFikgHS5TMSmomh7poIpX3aXDFvAoP35wW/n0sqdFf8F9kf534tcvPABfJOPsSv9EDHzqjLIa61Va1C7Nojadp04T60RNWAIFUWcusgZhiA1a4RTwJD5AE9+ZF0o9azwigiNzzFfl/iFTHzL/Bf5/G/smt0yYKiPj9MJtHPBJze/YB146qdvmRd8siym1sujzpO1oH4oLp8oIz47v6BGMFmzC83YwYY5kqQCS1zuBroTR2LmejHF1vauh6dEd1V8ZwisOuGbTmTzAcI/Qq3qld65/SJNdosvgmPEWGh0HW6I/ZVJ68C6uLbNTWPnIW3HcbyTE77qrHifGmaKtobgIGCyEvo3mFZnFstVRtqS5GXcv78WCNUmg4tca4E9bok4uDJuhJmX2eWSeayhbmn04x4z6WZTvOB5MIXtfC5/o+SPDrXH6HweqibnlsJne6WViVJ+R+0z/Yqy9cikBgSeCWI1T7zSGFHA4QBidBbq82beQ2mgLWKuLg+CGiClN2motmqsXIpnV/8APmApvSIuVADmxFqxCMHJX6/r+XvksFbt0xoH5hpmsjHnWZTCnwKrH16CLmW2QLuIq6H6+tFqqZtmZt5S+9HJpmb42zlq6csefVIZUO9uf1oN4ZkrexMlJ8qgQyy8BchuQ2VwqHMNke8eHeXRv7YADt7ILJt2GgcIKCQCrCdF8lhwlHQFW0O0PYoYBf+8E8OAK91JsQ/h/dpXZJzZ9bg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


