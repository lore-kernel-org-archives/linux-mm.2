Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D1B6F3381E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D73E66B0088; Tue, 17 Mar 2026 05:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BA96B0089; Tue, 17 Mar 2026 05:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62646B008A; Tue, 17 Mar 2026 05:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B58E06B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:13:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D47D13B385
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:13:00 +0000 (UTC)
X-FDA: 84554990520.27.72EC74B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7328114000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:12:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="AG/3HAK4";
	spf=none (imf09.hostedemail.com: domain of BATV+6844032b00f4c4208e8c+8241+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+6844032b00f4c4208e8c+8241+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773738778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJgFDdVVNtRZq/ve183e/9QuXJnpu/Eq4FFwP2YIxlQ=;
	b=zlOpxvYhr2HMn60V+wJrInwPZ+aiCZ1/ks6ktwpN5ZPPrN2ibtyA4d4E8KZk5szuwNy+eM
	MjUYPd8zSx1N9rbuI2V6LBbodHFsCW8M8/TDo2jTwEMBToxXYYbBXbAqQmUWP/SNI1ZKso
	7cN+2FM6sODWyPR7sZqKMTMwDPWQwKs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="AG/3HAK4";
	spf=none (imf09.hostedemail.com: domain of BATV+6844032b00f4c4208e8c+8241+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+6844032b00f4c4208e8c+8241+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773738778; a=rsa-sha256;
	cv=none;
	b=GkK4AySqNKm/y8Qqcg06rD2umB92EI9aqm6aVibMQOLmDFw9ENEruu3aBLZ8cEIrqWtDEk
	JJZ65RELBP8BOlM2j30zTJQ9EjReR3/tvmKdTBiyV7HmVjuXVMoW/Bv2OcEWh3wDhY7+5E
	CC9iU2fWaghaaFdwJ23w8nsshtRsXAw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=fJgFDdVVNtRZq/ve183e/9QuXJnpu/Eq4FFwP2YIxlQ=; b=AG/3HAK4O8ayyVuOPZnyB2Uh9P
	tmWEwIZEROjZynpvbdpq+DNRMbvkY2gybeTuDrtfY1/+jnWqz08TGfzJP533FGrx+D8zlGC0KK+eW
	8IUU9Ycke52oz97aq7wtzygtu+Cqrfs3Ky3ics5cWclSxsoLrPtk+otIY8WuqG20IB0coqQmKBkpy
	H5BH34XfTk19Hd1e984MffKBwB6b+R0adtFusadkFbMEY+DB9Ab+WKP4lGH4vJVQxTesd1JJ4hTcP
	7SsXxzngnle7K2ehUDtH+F6iBa2NbXTdiR1u6h3KtK094IoHBra+tjt3/4rg/rhEITBPz3pbbceiH
	L8dxodpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2QTr-00000005ouA-17Aj;
	Tue, 17 Mar 2026 09:12:51 +0000
Date: Tue, 17 Mar 2026 02:12:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: changfengnan <changfengnan@bytedance.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	guzebing <guzebing1612@gmail.com>, brauner@kernel.org,
	djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	guzebing@bytedance.com, syzbot@syzkaller.appspotmail.com,
	linux-mm@kvack.org
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
Message-ID: <abkbE_zh79iCd5zs@infradead.org>
References: <20260115021108.1913695-1-guzebing1612@gmail.com>
 <aWh06YoiJrR3-J-X@dread.disaster.area>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com>
 <d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7a4a183.1b5a.4776.80f3.36cd4d9bdb3b@bytedance.com>
 <abeb4474-8f3a-49c4-bb73-50f2a633d179@kernel.org>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.b89f1572.8ddd.443e.a91a.9f6964f1a150@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.b89f1572.8ddd.443e.a91a.9f6964f1a150@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: r4j7kkd33g3zp84356qzsya3nh3rc47s
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 7328114000F
X-HE-Tag: 1773738777-546598
X-HE-Meta: U2FsdGVkX19jbY8OIDnxWp9u50PqzHxze3PeX33HU9utxeePCuqrAJwrK/3lHFsAVqMeOd400sdbAxH3kX57gRiwrEfSVXEDKc0DynCrPqRT5P0tdGqjliQoeG274jU2Xxrxfbyt9DGuBCr+t7t4/EC9IZOBdiOMWFLqbpFvo000aujkgTISKzXgklm/SGh6zXkCdnKujXfIfL+hpdGvCY/f0KIN6gUM5mxmAG8izVN4i9CgQaAcCQ8l3VZud8p6z3OPxzKHM4cnUqNA51aUUsnXYk4ZDGItwqgI40u1bKax3nCyZHTZk31veJFBONRCHKdICuMCMAjs8lCLUdExgZiHl542bEZDUk5gGERR+9y9RIMncb5+pE6sFYqIXCDofPA7v3hmpu5KWQ8PCo8BCEz7BuihK8g6UXjyU4/ZbWZMn04RKxoLaHoHSV/oOK9lO2MOoT7KHkmQE73Q/YZIJDBBBN/nZvwyIy8AE8XBRyVGQgvnxDnyxda2bEfsYRIE1mgiYAidCHc9RFinA25OO8ySxN4JGRNUMPcUrJEYXCVtDKgPnCOcfhFiRE1wx6PbUCS9o4NEJS9yejh8x76ZcHboDh9OFuSKVLVEY5Kt5ip2z+eTcQQ3Mbff368namFN6ZefouugtBTklYfIB1BRZe8gpEq8yXdNvdwHrcraRoNzBD1H2370j3RiQ1GBJJ6ibBax4Z7ubZ5Qtwdc1i+w1dsXXOXfFnT8Vl9FW6EqYFr1Zc33GLAnjR25JmhGHS2irY6gbPwCd2qS6b2/1PfODn7Rlah1Y5txKrqUj0GAw5HyPvAelK1AnMIbVPKyZxKZA+4KJAkJLD67CnFFsaCxnaz2i48Tm6iypNf/xUC5JTuKOiJQmz+KitCJDus0qYVG0ga19w0XOZNzMi5rq0ku7w0mcO/vwa4vZoDPzvJC81qyCQrbNlji4VGUs+ZWRdfjin1+cjmSCfw3FP29I2E
 qre1s3MY
 UnEF4SZ3imGqdd9lClpa3sh4CJ07ILR7veYvUZgPJ59C43RTQ8246l4Acx98k4mr1fc6XPW6HkZUWv2ryRZfAVv1Fig7JfNEUX0uz4av/clNdu26H9jSWXID8PPMYO8mvOb+KnyOWua0h2rQPSasiro6ZdcHtbIK/gGwgFHNmV7JkePgVB6iiMKpNiTT+yXAHGQbMnW1kgyFsIbYbj+jf9ZtLo542AgGnCYR2nUmEyrBUJANBep0jmT4DzGYlLb4P4JRG7AB9VzfUZPx61Cy+GdDD70QqSc98GvNMjAAFjmJriIF5D0c0zi6Blv9e6dwl+R0lB03kMQ8r0dipmNPm/rwCWP0uKCgOmD5Dk4kxgHf9GBzuBl1Bav+7cOlUCDIsSUmzzRFGiynzsiE0iaa4DlWfM9FIn1vRn8LkwyIU8RL+q91j4eHUOAnSRtgetcgU0+2rN5Embq6tYlcugoihmKLCv5BsAhYvV9wGU2pWTKR36HkyfHMQ8j8kT/z2wl8WqXvjAIUl8XEHQK6mfo8a4AoFPTilHfDquitqLTWA/ASe8/s8GEn7YcGOfv911bHR1Akk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 04:33:24PM +0800, changfengnan wrote:
> > IO is not my area but getting from 1.19M to 1.20M doesn't look like it's
> > worth the custom code? (possibly from 1.17M to 1.20M it also wasn't).
> Yes, at least for now, there’s no need for a per-CPU.
> It might be better to replace kmalloc with a new cache, but my tests so far
> haven’t shown any performance improvements.  I’ll look into it further.

Does using a kmem_cache help?  That should generally be a nice win
anyway due to keeping the objects together.


