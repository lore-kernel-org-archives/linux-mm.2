Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE64F606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 23:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=1LLocZaI
Received: by kanga.kvack.org (Postfix)
	id DE3D16B091C; Tue, 27 Oct 2026 19:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB896B0922; Tue, 27 Oct 2026 19:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1BE6B0923; Tue, 27 Oct 2026 19:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A12606B091C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:55:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11A1440B4A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:55:10 +0000 (UTC)
X-FDA: 85370064780.23.67C7C89
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id C12D640007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:55:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1LLocZaI;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793145308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vj7zCX35JT4jkXfawg+CKE/Afwp2p1ZmDlu/iEQuq2Q=;
	b=oA17h4oYmR0RwTL+1H0jLI8YMEBxWmS6ZrqZ0hjSx2tcwUpo8bv4zl5vxdlxKde37HLiXF
	gBlo2U4DBnTl/En9SyyR+cXs36LJS8KtvwAoclmELIAEHhbVEaAEI8LxwmteoOP16fyOx9
	XlTDXLluRhiFz/NZNLKaOe+lKxiVeKA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1LLocZaI;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793145308;
	b=3jerdvJWuJP4f4RJ2K8ku9O8A3dNrCdw1WZZMvDGfZeBmL+Ljdm1HdsIXmpb5vuQOgsH/q
	gBP1YryIuFHMJdsIYb65CcCZANFaQBSVym6yNqclGIXtMp5gNM7QOn5ajJBhXUQDOErK3K
	iZAjE3/WLy9lqfGb7xQVod3XhbqvT3w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=Vj7zCX35JT4jkXfawg+CKE/Afwp2p1ZmDlu/iEQuq2Q=; b=1LLocZaI1ii529MwHFQECtpVM7
	wXCRYCv6btan4eAXQ1pXZgAfJ1jUKnaSF0clE14mVbES2ixOadHYMEIEyi4DOxHkn0A0FkNibXRPc
	yJDJALYtVIx1AfQoed4ybWXVL4Z948P1hrMUGUyDDR4w5AO4s7ObNBIgf2hdfQiyHcYv4++J2NXGw
	2oowa2p4qHY45EthYqNPTxnv6KqTUFoQEejSBAndLL/unU1Akwk0pX7pkVbEBlEnEQqd5ygaI+AoI
	C4mso0DcRjPnJtus6dJb0M6XLgcAmkT4LnIb2QJRriKiY1QpaMrzNBzVqnyaRyez8O49jSJh8IBXN
	j33Q/VgA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLr0Q-00000005xuP-1dGN;
	Tue, 27 Oct 2026 23:55:02 +0000
Message-ID: <f34f14ca-21bf-4ae4-9e7b-da7f72d1b134@infradead.org>
Date: Tue, 27 Oct 2026 16:55:01 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shmem: trace swapin results and order fallbacks
To: Xuewen Wang <wangxuewen@kylinos.cn>, hughd@google.com,
 baolin.wang@linux.alibaba.com, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, corbet@lwn.net, skhan@linuxfoundation.org,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20261027094014.2432692-1-wangxuewen@kylinos.cn>
 <20261027094014.2432692-2-wangxuewen@kylinos.cn>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20261027094014.2432692-2-wangxuewen@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C12D640007
X-Stat-Signature: 46cpuejus85hz3qsac5e698spzuj57ms
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793145307-168312
X-HE-Meta: U2FsdGVkX1+Sd80twokKuLBy4VQlyTJYSnu0kixUJIiaf2ROObLvHQoa/VWJVnrgrCQUbWnj2de3mWrWH9RqeoV86dG/bjQaOZEmE63u3P5Ql0SNaZqHu51HCZjoZoVV+dH4TgQ8cyuLoba/L33z11zVzlVRMKI5rkZVYOLHvwmnGqffIA4HYuRPDJsPEQu9IjuKrcr7y9vslHZKBLag0BPFH35o90Rj0mzpT92HduM+fWKZBAwAP0sKmEiTda9u8cT5VThavx+5KVNy6NLKJBtpOHpEeF/QZi2Dd1S2DaklFLXxry5vulFmlQ6MjHKNJe9UcAhY4YQiz0YH5mWw0fxg06tCdDTcEuk+HPEct5zako2IQBaIqJzTzHRhQDAOX+F7XXSznJTIo+PdqLF6J2th+GrpfKpPb0BL1WGEO884CGGYkGbLuokTDJbFRuTJ4r8jYvaUMZJvTet5vO6G3HfKPgK3uJBJ3o9loGu6J/WC7Akx9Ctwj5RiFoy8PH0Ot63kXnGMpV83yQ5qxlRiVHvebcxIvm65poYURJQAs0huco1H8DXyfXyuK077hXeD+ecsgMLZB1ZcJS7HM4BfYnumwNIJXpyOQcBt9KaBsXul5GSEGb7Ih2+GvW5jseUwyRve/BZgLUdAmY9cABm6KZ1RcvjAQRmdRs9PBfpw8lCzDJUPVUjO1r+ZotIWd87jWRWQbFEFxn3dLZHDHWnkY5NIcVuBuxAR2SYfzbhaoUv+oKDP0ma1Kc8mHSn7twJNlxHmjPqDdP8Fx18fhGe2g5KrD5uT1ip3Ep9TgAl9/uNi8bn1j1smjVCmEVYIWkJax2/Qxic98BymBBzIuB0Vbw0jxatQw16UhIUatd7Xi3ddUYZzTw0juHaLzB/yskDA3OSShMcWyT0G/aAmLanUCV9fDUXsmApBrZbfGqrS7i4K7gEeM3/uhZMtKBbOIE/JnHBXUdkTJBvf1KxdiZW
 I/E9K/5N
 KdzqE6RpSACFj4tWbs7/yaVEfLu+Z+YMgrr8exdJv0lj0WtrUQ/ndV3vubxW0EnTZAES8lKe1wDSD1XqAxUh+nmHBa1dYiNmSMpKsuqeGJZYuJx4mmXBaG+lSZrbaH1lhwvQfC9rDESULGZrlV5nEZdp94kYQdugClhmr/Mpfgd6z+YHaR3aEQKvm+pxPWI67PemiMllqWOdAztTXMTqS9kVuBxQiuS6hTZjKVg2yl3Om4uNPGC/R7qDrReqUIv+heulNJteMMJedxQAOyOFh+guFzgkPnyVIBTHI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 2:40 AM, Xuewen Wang wrote:
> diff --git a/Documentation/trace/events-shmem.rst b/Documentation/trace/events-shmem.rst
> new file mode 100644
> index 000000000000..45da82761360
> --- /dev/null
> +++ b/Documentation/trace/events-shmem.rst
> @@ -0,0 +1,73 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Tmpfs and shmem events
> +=====================

Underline is one character too short:

Documentation/trace/events-shmem.rst:4: WARNING: Title underline too short.

Tmpfs and shmem events
===================== [docutils]



-- 
~Randy


