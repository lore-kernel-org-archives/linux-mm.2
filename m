Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41C3AF532DE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9576B0005; Tue, 24 Mar 2026 01:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92636B0099; Tue, 24 Mar 2026 01:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97F1A6B0005; Tue, 24 Mar 2026 01:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 848A56B009D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:43:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A21EBEF06
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:43:58 +0000 (UTC)
X-FDA: 84579865356.12.7C0D002
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0418BA0008;
	Tue, 24 Mar 2026 05:43:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wRirh2cb;
	spf=none (imf25.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774331036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=eqcQRneRcrpRxRWr7AAIvXmu96GVCSPBaR7mM1Wd36F38gIwCYYdtmqgWurQDyLIF4/4aX
	Da4svrcxwe4yBjaum/7cRcX5ElULjU8IltF0oVIpVnfTsPTwNJDOECEVAK2AuKZ58iRwbt
	CBuM9d+4/eQWT85/Xc5MXhtzyxn3yqw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wRirh2cb;
	spf=none (imf25.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774331036; a=rsa-sha256;
	cv=none;
	b=JNlNQmOPTuiShDIzMSmB9US58KBApyLS/pJJcL9pF08YOHo/wb2UtgBcOAfcVw+QNTqJqa
	6kqm53eHgumsLGVxvTgxQ1Pu4/5xkudpjAiIEt03ZvP/SPMFBV++YJtE0nux2TcN0UzBO8
	TdPWLcPD7DCLiovkRrdWiQB4VbWpFFg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wRirh2cbRmbNh4cH4jQekvG4Vd
	Yw+iHCsdPctdRsY5U1ZIjA2quHXNt5vLTA6II1G/f/JAbZqTtQEYmBFgh3k0BK2nuWt048dTAQ5CK
	x6TSuMvZ+eWNoj93CMkcw3PU8mO59Bh3h6S+0uvIRAhtw11N9AotNAJPu/Eb+SDM8M1vi/a6LdvFy
	EvZ5EyUJwXE4iy9ps6IrRRubO9jTDG6C/UochZE43jIf3x0yq9G8CslGdtmDcVlEB0jdr9ND2Pqxz
	9GbfCgk5+79N0zBOxa5yoxyKbGZKZ5uIY13vsXz5JkZNt7GusJn+WdcFKGASah9g+41+qLmyu1br5
	mMQM4UYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uYR-00000000c6u-3u5z;
	Tue, 24 Mar 2026 05:43:51 +0000
Date: Mon, 23 Mar 2026 22:43:51 -0700
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
Subject: Re: [PATCH 24/41] fs: Remove i_private_data
Message-ID: <acIklzf-LT-3ya8g@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-65-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-65-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 0418BA0008
X-Stat-Signature: kbam5cb5smz7aftbk6gricbz11m8rqf4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774331035-487198
X-HE-Meta: U2FsdGVkX1++DEtLoVseX0hsEyiUsvtpyj5D/nOtJS1sRNuvcgW1q1fjYrM9XJJHvdX7toWa3LqMWz/25aa2yrqwnI6+hUOj1c4j1opJ+ivfyV0DWuWRpV0Ls1ZroTTQyyhciY4comv3lTI9WDzHHPXH9fb4j9NRn1krdswaKCBwC474ptOg0y1BlLuOT1IQfHpFsr+/JWy/vhePMaKKwUsCzD2cCp2bq9AajknRrURmnKqZuRMutd0tWtzbrNSVxQpm+4tyceHmwmY5VWrNtzTrVHv/uO6uTmaIRXvsLM/W5GOWi+cYsDJCPrRjZiZJ+biHCUMLdU5dNPQ0IlOHqpwQYcj+Q67swMJvIEFdiShyB4aLbyXILYgrTIHt1TqjNJMikTT3JziEJJCUwIX2gac9UrzuxMEIaB4HbU8uNQ1YXDCsyIl0R431jhGOPU7Hvyo/StEdJ1NnnQznKtHYVK9TvTdCez83iHJBvbRyphfflXlX+4J6Dfy/6WGxnxM1FsK9yVU2/DWbtyrwPcAoHK+jvb7SqvL3ELgg+3MOj9iuaG7KfxA9bx6GGjm4DH2ZGnGGGv0UhP5+PHBduMvAqEPaT+k5MSfgjKks051XWXQPo4z1/MaAiyhrIxJpQiCmJQSr9XXAaYtb4BodTK1GpyBXlJTSVUEYcpCvDdkA5TUNXv+7TGuNKB/hueoZ4gT/56rH+l71eOvrGVFstzgUjzEJ0JE7NMBpTzIH944rmM8bBMVainiKiiDgMGad25TXxR7XmCKv8wr6FkiwgBIDfWeoiBpKaWPUSEyyUN9BJYyx+oDveGMxMXFewUa6m+l1KiznI7UYuc1u7Aq0AHPZyag9C+2CHNkZzCMv5TCwQ5u93DVFOOB/1I1ifIBrS3T3OjSEcYy4GmLJIn0A3Zv579lgbdoudhswD94qPjL7pGj/WKKv0A8FHhZUdcmSTGCjxdlwrVICBzRiuEo4f2V
 NlGf7CkF
 d9pocVwfS+A0K549qx7/czs7ctzWdRy5L4suHQit5R6xJya5i81beO9olRtNOnYqkHe+YNVpiWZugvO1C3QR4/0quvrBSPjauwdEW1Ph58523FwGXrXYG1pim3adHigx8XMY/SFSZXeEQjxDKcbCWB329x55dyuBIan7zhbvAH8lSIDhzEOKCn7rAXbKCYCib/nySoCjelk+APxBEUkSC4bCIag4sYYH1taBR87loyWKk/JsBaH3ed0vOS6B5SxG1yvwsWziHJE/zBpgt8r+Ai3xjd3F9QvJO/kZSjcz2DFkDHC/uVgYJZX3BQ+zr4n4d/P3uLkFbcKDHmd5Ed7ATTN6Yos+4US2sQlcPh7Im3lhDxRp7K5gtDItwJd4/U5S1uEaNHKFVEao+6+ukfhX+UlKrCZM4p2kaALPuJRpeoc+lrSJhOIT65rm/u+BII7IUpD3/s5uJO18mcMNPxtjpMSbhPtMcjr26UfZsf0EDItXKNSsE5d5MVe5VVmynOiurTdhc5H7C/YKl/CR1b2FhHGR6EYBXHwhV+O0mYUs4zA3icKORCYUGv+YKQNIOG3ridZ18Gtr5AlWGrsLu3X+oEKG4BGtrDamgUdjUFNWl+WyLR98obo/1QTXZ1iq/cWdcgaMufDnqVCMXj4EmTmhtRT864Ot5lCOz+PdVbYpfJmMxOSkpGmEL9Z1dnBreraUgHbDXbu4Acpo5ENb4QfZG6ltG5yunWKLe+rFrG6JA2um2pJOaGKbProramRc5U17VqVCEzXzBhJa5aC9GTtjviKxR4VqDzfTgOwTlsEQuo+x3s1GcLu1TT3JxB13d9kD4Jba9pXBwKdO8ZT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


