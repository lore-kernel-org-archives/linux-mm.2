Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E03EF8FE6
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0B36B0088; Wed,  4 Mar 2026 08:38:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE4F6B008C; Wed,  4 Mar 2026 08:38:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6863E6B0093; Wed,  4 Mar 2026 08:38:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 548666B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:38:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DAAA014057F
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:38:11 +0000 (UTC)
X-FDA: 84508484382.14.6DD884B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 90A8620008;
	Wed,  4 Mar 2026 13:38:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ebsPMKaT;
	spf=none (imf13.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KcnJZ5GcRmxZSNqRVZ8ueAG/BKkaYuYvTpHl4+/qLTA=;
	b=7KUjz0dQNj/4F43we1qDJljC5JFFT1Yl/OkNQfEN/2oakdhGgAb5tr+8/cZnTXYawmDL9b
	AB0DD6xaWEoFLTtLtc24TvELs7i+1Lvd2FVhKRLfEM+XG/3jf0B3ebrNMfh3ldPWMQT/RR
	9R5FteJpKT5am5D6/DyGz326527u5mM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772631490; a=rsa-sha256;
	cv=none;
	b=F0AHLU02tEfG05NBsDCZTEPZYVqnKjvCIvf5R77q56+aWmavdZ5bnmWMaJ9rDxF+N0Sy/P
	xPaf/1J61qh5QMsBgPNStxyOyFboanaTDnVBepO0XUvOsVrBtzDJ//oQEOmtNfKVOSX5EB
	jjqye1Y416012MeVuNGJ9ec3dQ2Ap5o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ebsPMKaT;
	spf=none (imf13.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KcnJZ5GcRmxZSNqRVZ8ueAG/BKkaYuYvTpHl4+/qLTA=; b=ebsPMKaTp9H7t/hQ92QY4u1DkG
	zKuhWcKM6/QbdMthk6UntN+XsckWYhbqpeXouW3CD/VRwr89pfmjZsMSgT/m2Ce12xpz9PN2aJ9yQ
	leWM1BsBc6hkYy4nMgzB3B9XxhkA8x3Ns96/0ESGIG3Gg54CPdFBZd2cA3cAhxhuNU/kdCp4Zjf/H
	zKX4SYZjHaOK5eqQvVn9Edh9eUXLwgrx/buazH5JiJJFhID7L3WPr2QtJ0ihGotqnVIYXfsxCJ9kJ
	cRchsSLhwhfZP8Ivkg/vFPUSD/+ERzIKBpKKn1f93mq4rGsX1xRcRN/XlFOY+Xe90/ygmn2GH696I
	rz51RF/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxmQO-0000000HG8S-2KEN;
	Wed, 04 Mar 2026 13:38:04 +0000
Date: Wed, 4 Mar 2026 05:38:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 17/32] fs: Move metadata bhs tracking to a separate struct
Message-ID: <aag1vDoCVwAlIKPq@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-49-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-49-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 90A8620008
X-Stat-Signature: fhoo1qec35t5d955oo7byahzox715y4a
X-Rspam-User: 
X-HE-Tag: 1772631489-610544
X-HE-Meta: U2FsdGVkX18qFxKRzSb0cgGeYWZKTSoCyJjcLlvf5oNC26WKPPTn+eMmAbRgiIHLj+vaEmPLsGeV6EJKzltNo1/zv+BnwPcLZQjbYdHhr/URxROzWHpaiEFYAseQJZZvgEvmVhZkeXRI/Umc4A5CZKjL4E8VlQ1i73Wo5HNYhWb4wavmgtQMZjeWuexCAazrSHwOTEPJp8RSGK5sHenbz4V80oHCAwpzHjf6MbaYfsOL+zMAEyiORv9p+asytm9JrnI3r/A8Y5OvGLsTiLZ7gc9sI/RzD+xO5nLs3jGFYupO60OGCy4NeC/LpomXUnzSMdPpOYbxfBWfzCEUcdVzYCQH0tWZxolgFRI+fuVpYUwA5C9DPU4O7F+7329S00tq2tRI0MDTeNeSCUQG8zKCFsUdsVhvW/iSn9dWX7+hpMs8JK5M/RUI8kPeMfHILCsZasaLaSUOFup6tmy6UpPN3HNgwA/SiyXSsstL5Ih97WlywJzzTjHuubTrFtUKnT3jbNWbTXpG7XZGQWlST2Qcy9UyXIas+f3nLReyBY86D2pPs4JH/RjrKxQ+A3zYqeq8zWR3k4+rx++ovCu+l0ZKgXgmMqdyVn7munBJvMnLQvNN+VjpFMdVQU+5Zcbk8FAp+ivFjDAKTOu3eQyknS4C+ezre0dd4A+pcg23Rj9Lb5hVKc/HWoaackuu9C9Dx4hWK3pj/Ph/znyRExZ94zAMzsIf/SvH5EBqB6Py+szBDy3QeUocEq2DlUkBdXXWNLmQUP8RHEiokisN7nSLpUEOuc+GGJAN0mF5FBpes1ducbH0smbMWHk/XeSt9uqTOiFn6JtGl7QuRUNrZaM6yNYD+DqPlAArMy+CppdlaIHP5PALPJBK/ZeTGzwYviVqn8VzTb7N3MQjwfrit1vZTVTafg63t1fAsqP71x1m+xFV2EZe4Xg3KB19Em9YNVVYe9hVRxAeSLONwdL5mH06WZD
 jbeUwPs9
 eSKElanBLmZm2uKph/euvsMHBS05XaS3v5ESrvmRof+g3MbJGXL5OPjf9eBsYj8KV3K4NCZBOWq0I9908Yw4SshOu+J25bDfii3jcYmP3JwnxpKA1eh6bXHQa3CstqYeJ5JGAnW/cwBTPOmDnTTW5HayJDjkraNUsi47oY+iYCDrtu6+hgVfzbK/Q6xHINij5TjAvvw3Nwie/RH1fHF83dgMl4fUdJYhx70ixsJdRymjBAGz2ZoOGF1kK78fkQOuMw09AGMaJbVId6zQGJwvpDrlB8l1Lqr20eOHhPTF9M9aiiQK2c9TrirKk7Lu7Pb5FRjnQCsFxcCNtChHV4WP/jvfrl9qAUIhg/k/XfpLsKbBqqxiSQ1rzJW2Rmzro4M1Kk6jVofqPwYT6k5rgZPec9BIHLXjMtnAtpLBb5U/NhE4wfhKxuvNRDZ72ku928OuSUirod8IoIhHxrdXg7GgHE8EPfd+3Aw3UjnvzoEpBCYbN/qmRzlNj0YMxykAWTz1X6KfGSk8gFRnllAqccWSYkP5pZ18nKUgh8TZdAW5Go2kWLPO2fU8BCk/WzUVmNHAsBWeI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Maybe just call the structure buffer_head_list at it really just is a
totall generic list of buffer heads with a lock?


