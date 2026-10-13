Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB134CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 22:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A46886B0088; Tue, 13 Oct 2026 18:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8946B008A; Tue, 13 Oct 2026 18:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E97C6B008C; Tue, 13 Oct 2026 18:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD956B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:44:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D74CDA02CD
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 22:44:35 +0000 (UTC)
X-FDA: 85319083710.28.F300A40
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3B4072001A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 22:44:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Z psGtk0";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=g+QUGw2w;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791931469;
	b=SOs3AhJwpUo3nokjfgVe6chJyt2MkM0AYT1nEALB5sDBO1VVQmh1Fk9M/RDE1DQ5zGYyau
	ilrMimVAvsH6WL2z6n7epuKam8OyCghGtGdM2d3FejF4s9WraUs5uGd3L8dsy6ArddLiI/
	q5ihOnf4255KOry/qJurZ3gq+SCkBeg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Z psGtk0";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=g+QUGw2w;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791931469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1x+mA/8QRgttSFWuMxYzyxQ2P0xXPF95oS5eZcsEM1M=;
	b=7X1z4aNdMDMp2r1GNwXH63j3iPsd/Wb63QpgEQrYdQe83j7Gzd32DzYJRlcu/BKtJm0HLJ
	wbW1V2KTuZCCPpKMXbKByMgEVSzjbrireXKwhon5TBMa3BgUD+KY5d9m57Af4x23B6l5zE
	89GL4U+4CPPO/Fa+pjZQEozPG/n3iWw=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id 79DBDEC0485
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:43:48 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Tue, 13 Oct 2026 18:43:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1791931428; x=
	1792017828; bh=1x+mA/8QRgttSFWuMxYzyxQ2P0xXPF95oS5eZcsEM1M=; b=Z
	psGtk08TQKc71gAbZ5He+Fbk0zQgU2B+75J0+1G3ecGo62lvY+kk4sckBwPLOE8F
	0Cp0zkOP0YeRmOW8zE0FXDgWUtBX4GPtPGpsFtVtivhs6oYBEyGjzvfbowbP1ouX
	qIQILD7CdlvcNzQkW68wtvDI2Uv1JaH8xYS62VuYaAOxK4TBrKF6gd2JysC8rLOz
	3NprVnHp3x1BCQ5ScWLp0OtGp1tPoznp2vH6WFb/6xBP9EMLzQZ9nvNTXIAVBPqc
	VUqzCjC3xvpObnvvxLuOS5zdn6P/OhvSYi/yw7r261LTv9krjasnp7GMQiDPNcYi
	cPaTp2LAah2Hr1g4tet3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791931428; x=1792017828; bh=1x+mA/8QRgttSFWuMxYzyxQ2P0xXPF95oS5
	eZcsEM1M=; b=g+QUGw2wI9citw4lhcLc6fFEaTx6mxAeWfzBMVWfgXBO7aIfnlp
	YbJbomepCAvDmaue6mYnNB3qpffGf2sdDMZ9uY9+XKkQptCvEDSAZJ3c00ljEqPJ
	AB2pzffKTdihS0+voeJKdq2/vcKe3xifTnzL0yRSiiWBy8Jur6yBVUIsAVNu+eAJ
	hKZWtA+EYo5FFLgyFoLNOqR8UrPa4n2pjYTTbPzx0uqyiS3R8wavx02g8e1GybYt
	ea2x20HxKLOr54Hy5MHHlIMBzqIk7042fCd4gDfMqenZlgwt1XCUyokA7ZfDqngn
	qgo69eadzCS9Ut+06EoO/43ko3nqbLIf1Rg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791931428; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:ez8ZmUtD4a3MGjDN+j4CB0ZmpZR97ncvR7+6TrF9OtX2bXS
	j7rbDvCvh5opTLEfch+Bv3LpHKVEVK3mFYn+ZboMtvfzvdcvgGjyA7hsIKpMC+4f
	BgMvcmvWkBb/7MnEZIIHF4S1AedNNgTOVlbBXNiNPwjdlXjgn09Xi9mlFOyUi7X2
	6F1kOy6+8giiki0ysm+UaHemqN94MrTyh0ir2CkLKOPWxpEZX6kzgEraBDs+XxwM
	H8n9sFszdSxwtUms/ct/l4JTSbGUv1Oe7NycpvVVMn3Bv4zmuA//I7w1BeqWZFRk
	z1ywvtjmygCCkXYBhETnidYNlJuWnS8LlqU79RA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Om/TkPmp1oWaFFNnYd0zGc4VEtvT0AnDj9qfGTI2EvU=:PUR4UpMeXD5o4/cnjdMVjrnJKqQXVrCu2h1+WwuB4+E=;
X-ME-Sender: <xms:JLTOaqk7i97ezJxaF4nUjxp6H32O3BTQxUZQv2p0mkeVnEu3nAuo3Q>
    <xme:JLTOajXZjyleNVkH-hvkJwzn1Z3uv-3FVAvZTsdmBxZs7zvR8D0JDD1n1URv7vgeA
    XBLXmt6mz1eyQdJfnUKSoWQNOgBtPQmqJzcxF8AWCm6qpsYbzr8kOuk>
X-ME-Received: <xmr:JLTOamTy5kRDDh147IH7aw7x9dlR8VOBWQCEVc7XDaOFKurgt_yOEg5HY3U>
X-ME-Proxy-Cause: dmFkZTF+qcMsV6L7rd+IYj2Z92H4Nvz+YIi8ffOn+Tmxw4G+DAJj5Ue2WS85tg6EnHOF2G
    qz1staSdEmGQ3ZCUytTn6Xq3zEj/HWROE8CXdQoI5tivo7SK8xeFYTZkCRkbZZ1S02ixwH
    NZiUdpgNkDbedD9tkrgJF1SYNmgGWp31dQS9Rdby9I4u2ihgELyJcdEgr5kKVdSXxEonFJ
    xf8rmSSSKb6ulWDPEf6NBt2c+Y/vv3Ee5Xfa2O+T+fsgMLd5G0i67DniPVNSIokNE4W4ls
    Y6jPYTEmginqFsqsmc1kAiAOTYcEaGeVijQRlCpIqVndc2czP7yFAy/smtuqB9eX5AatJ7
    AWAQQw8+ejsT68Xa/UxdKrAzQtndJA+SQV6h6wsALQQGLE3L4fydRE0cea0Hwne+nuVIuM
    QTQg1EoPVVI1F5AY1wck/qLyxiNGKsMZFOahVsarZkhE1uCaRxwsczv6eSO1KtzFjYpY3y
    qILcLFruwheiT5VIApkgbB/sZ5+FFRoZAibJdkK9E6xHhDGfXVRNY0p3hUJdB0nQZAlaNS
    4oMQj1h1IXRHxfyxMG4cQW+DjXCrxa4usGs5TNBwckjqQYyBeqTAdumy159e/kBy/t3+J+
    iyz7EP8CR/yVCMftvuFzQ1chdLI5eSAyWBrB33pI67uDWBzDQZJvAZuCBsVg
X-ME-Proxy: <xmx:JLTOamC_Cg1hx2NSvf2LjovrzCK2Z3M0Al32xvDDyRWd84bGye76IA>
    <xmx:JLTOapRXLH_gAZglbFWsc5PQ8P9-bRF36nNRqDLx0CE6p6tql5QRcQ>
    <xmx:JLTOaoRhn1tD4wUbrfOIaA6kB6hiUYsvDypoa6KrGG67pZz2EKzJ4Q>
    <xmx:JLTOanK0Q_R3humpgPBIg7dzr2DPT7NlyCd83Kg4_6swboovITSlZw>
    <xmx:JLTOaqMvCQS9WPeaqIA_5-vfaSRINU7SEgPfyOa2hFzqaBC5rhd8Azrz>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 13 Oct 2026 18:43:47 -0400 (EDT)
Date: Tue, 13 Oct 2026 23:43:46 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Ilya Gladyshev <ilya.gladyshev@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: Improve page refcount scalability
Message-ID: <as6vBoWQGglxXxb0@thinkstation>
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
X-Stat-Signature: 7ho8iierp8minaz4z6chi5kb496ky3xx
X-Rspamd-Queue-Id: 3B4072001A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791931469-745670
X-HE-Meta: U2FsdGVkX1/UILxvfexdg2rw94mEylYNNndZC+L2Jhebz5GdOfUrimJLKVoh5pATfePl/SkBVNksalMygHkbI25fGsY5i7Mhvc5Y0KrWg+wmF8HPfXdcQ6QOMVnFB1H8hK9bK2afa6VE4b3V7YI2jLKd3JcTgm1n+3k5rNGBCMsExDJhfQblfrhRhbypQM+rChOUNWuKp6n9Pc3sAMgj2dSMauf/ySDzlJ0emU96bxlvqVbEhhZ1D8a928BQbln0gwUNU8tviz38flEg20AeM7wiMeti0LRIcrXNB+K49VkuTQdYGxuAiJw2x7ZWcua2AgLWcrkLcZmbrMgriC+ZrOlU1Xenmfq26XBZMZqfMKUqyjH0GMeTU9hpzMAi4dEY0PTKp1EOZkTuOrV7tH3qmz6vqtggUcXMHthTaO8l6UVgHWYbeBObxz3vdzLtVS7+tUwBcYOqg0cgaNJ1DKOnqUNbNFN4RVLu4YiRb9IvPJoDloZ5cLDPf5wEQk0M4X8eVKFNm10B/cYjvIP6GrqjDftJ9YYEWZ4ID4m+iArKmlo7vW8+MoKXoVOhDWY7mlOCrjOlVOFKgABbSK9KtihcnaBgnqhQ3mHvBQeY2tMAuic6k3kDCNiWDpSh2xdrXUEM8iOXKB/9r5xvIK/RGCC00e+tNCHoPwOURCzILUJNreyfJsgA/gLW6B/BlwiFyAfXwKw5PO6XdeyNlGF+eiH0RQfBfrrkENAADYbliworjjjCbBRIjwEIayBUwunCk6we4ZcWj2XjMQDlHDcoMA0wnh4NoG7Qvj1Azp0OAzcjqYZfaoRfiLPsCukOL72o5zlgYop57sqdshqD4JvDalebYf+Y5N5N3MF6MXCa3XUyeJJWhFsW0oTN5b4HLx+5qT32iyriCyqA+CKi006wbqB2CvArsX45K3oibOYVvgKQpWv+fI/MLP+44z0FESF0p95YPpqEMH5EI8MZDlU4mKW
 dOCAgaVo
 Fyij4KdxAgt0lFCTWniTBmLsHj0MQFnTEEvoQUvzKdc8v+zDlomm/Xi21yuz6APpLWcdmSMIKoFGCr6tALQhBKUUtDFDBTGUZi+xWY3JGThJvJfwhD2cXA/AAcu8gBx4Vpbpq0aC65IRNbSnKlxWKdJl4zDIPWE6YB5CING2AkwtAEKx1ZhmuVvDQqA/wqtusxaAcY4Z689Ho8E5K4r1YacdrkJm7b8ZfL8cTd0HCaE3+IQsQCWMS6L6ERHMtzSKCZmb4I3wXaFmzGSvr/7+ZJGIhVfrkq2sySaOXgDuKi1t3K7SgM1BtDnJ05CTocOiCj/M1Lk7byf5Dj7LlyT0JyA8mH99uAo2KxnQUWoj5pbLbrGWQWSvouoamPzfUlrxqdQYP4iTxk+1EFLUTscfNU2Zxnk7BSCG5eAgDDmmEopgXOvkqYg/fS+ArFZGC9gqpR7mNnhMdMcgnNkNOD7dmlX6d80YMhAZBO4eLE4jgTTvvspYZz4uqSJRy+mq5WF7/NeYv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 11:43:14AM -0700, Linus Torvalds wrote:
> Comments?

There's a race in filemap_read_rcu_batch(). If the folio is replaced
under us with a new one and then i_size is extended, we can read data
that never got written there:

  CPU0                              CPU1
  filemap_read()
    filemap_read_rcu()
      filemap_read_rcu_batch()
        folio = xas_load()  // A
        test_bit(PG_rcu_free, A)
        xas_reload() == A
                                    fadvise(FADV_DONTNEED)
                                    // A leaves the page cache, its
                                    // free is deferred: A stays valid
                                    write()
                                    // page cache re-populated
                                    // i_size extended
        isize = i_size_read()
        // i_size is extended
        copy_page_to_iter(A)
        // we read from old folio
        // data that user never wrote

We need to re-check that the folio is still in the page cache after we
get the new i_size. See the patch below.

My branch contains a few more changes that address downstream effects of
RCU-freeing the page cache. But we can come back to that later once we get
agreement on the core mechanism.

diff --git a/mm/filemap.c b/mm/filemap.c
index b85de94a1b6e..0d9fcc35dc64 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2956,6 +2956,8 @@ static bool filemap_read_rcu_batch(struct kiocb *iocb, struct iov_iter *iter,
 		isize = i_size_read(inode);
 		if (pos >= isize)
 			break;
+		if (xas_reload(&xas) != folio)
+			break;
 		bytes = min_t(loff_t, isize - pos,
 			      min_t(size_t, iov_iter_count(iter),
 				    PAGE_SIZE - offset));
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

