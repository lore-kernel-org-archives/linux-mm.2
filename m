Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23AA8C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569C16B0093; Tue, 11 Aug 2026 12:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540366B0096; Tue, 11 Aug 2026 12:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457546B0098; Tue, 11 Aug 2026 12:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 278746B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:59:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF924120129
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:59:42 +0000 (UTC)
X-FDA: 85089600204.21.ACFC64F
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf27.hostedemail.com (Postfix) with ESMTP id CC4AF40009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:59:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="e 5CiQph";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=aTysU3L2;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786467580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/IPx4KtYlUFdbmjZIHL+vVayMdCY5hwV0MPIJboBbg=;
	b=S0DqmhyZJrrZuR5WBUwL2vr3zmD3/PiqiWt1Yk+KsBwPGBI0D9OYtH5dgblHcsZ0MuvHFw
	d+AbdHqEJvFqj8lMEjtAmhVBDVDEolcOsvwPvFbrmBsfFyi+pMCxP7/aheIObabLCQyC1Q
	VWJ4iFGlVKUFjHzviLvDBEl7Xn0Fd5o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="e 5CiQph";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=aTysU3L2;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786467580;
	b=zeu4oxRu5pvVUsf/bNuibXK+7A5ArENT6xXYlHDE8FDVGl2DfIQDem8VwkMfxaasLr0rww
	Vi6CM8g7X3TA+33Ug190cY87WjTPoxYxEryaqiibiINyKvsGMQIBwx98yfv8skaNoHjDCB
	sX564gJdN/2umln7jmZ05wjt76f3bLg=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id 530C01380437;
	Tue, 11 Aug 2026 12:59:40 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 11 Aug 2026 12:59:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786467580; x=
	1786474780; bh=a/IPx4KtYlUFdbmjZIHL+vVayMdCY5hwV0MPIJboBbg=; b=e
	5CiQphUz8BkmYjXYETqskSStaJPNv8tvT/ODXWdlx6QfdB1TP3xMcRLsnTVVoufD
	gol6hCqLPTjLnmzbeQcLELABeQomiW6YdYeLHvuaRtircZs8ruwz3bcP8x6aPODi
	lz+jAgoF1Z446UKM3lUwGgwWNRgc+T/Y5/pOVhEX5qI7oy28lIYEb3LpYMQ3/22F
	yIjHoIlbhA5VNT6lPbT2PHY3O5vinSwP219jHPKzpZNrhQG+gyewYld80Kf6ibB/
	T+xacI53DsWHraPzFu+e+fNyI/24Bm2I6CSocn/bjhudlLVh543ngN86zcAkVGU5
	4WIDIhqYGc40OEsbyADzw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1786467580; x=1786474780; bh=a/IPx4KtYlUFdbmjZIHL+vVayMdCY5hwV0M
	PIJboBbg=; b=aTysU3L2mtfRzQDtQsFHQjeGlLucbkOLenYjx1Mf3D5YD4OOmlQ
	yECQIG2pd3rTY7L9zY2ve7KvzT3A73wIQhSD8nu94UIdCv+MWI14CnZdRsA8uy+B
	YWSQkdUWd/bWA176oJ6n8F/ZKZW0LhQDroAKkZVjuIaWQqpu+IAIRp/0kK+lRFN/
	ZVDbKZQfzalZP4nqtSr1z5EbaLdnQBjzqm+I79PiWBTeYPWiQm3CGOjOD43ep2GA
	GSQ3fj5AH+/Q5sEOlWcSF/hZqSWYG8u+DFqU1h7qi2/ahBcnbgSWDUgx5dwfeT1c
	KFMoIQ9w/1cLTk1cfqVODqLZdnjelg9y7/A==
X-ME-Sender: <xms:_FR7an5SoV9M-_P6FikbkEqXCHkS-KEpco9_qu0ICTZollMUdSoYSg>
    <xme:_FR7al4ZbE9UxO9Hs0x5YraRl9jCTK8NhxyQ_pKL0T-70cHGPgIZU6QAZzaJPch9R
    uPFP-r0gleSE4LmdICTsdyBScE1CUjRmLVGZRMHnWI9uSvlMyBWPg>
X-ME-Received: <xmr:_FR7aoJUVo0GRDy5wvyAfD8tXYOR7L9gXNPHK4BCDGXBOuledr2bVm5HR5o>
X-ME-Proxy-Cause: dmFkZTFJB1O9zKJAg+fSg1tJ5bwBvVvABgj+vqmdhVx2D/MjfMXbwCFNKEbltsl8EEvEtG
    4thUp46lahlnREv9JgiK4QfbzG2pgttOEFqRUWh5mvKTEqsyv2D+4VlCuUKMQ/M7pyzPnU
    16IJYDjoXjq3+RPwxxLgh+AJBuNtME7bv4mQr5qaYllb7ykwd7fbeInQAqB4rIEC+3FeHY
    DV0SyexRRlvueW+vvKp24X9E6FOo47n0o0yI1M6QPP5Eun05sKXRPhrzy7P/g2pa1ezVEg
    VGlu267qK3l6duQTkkKjr8N+pskDWpTe+JopNqUrrJWllBpfrrg1hV/yz3CwqXXdMpEznF
    sQLaRe5uKf794ipICvZMteBuhmrMmfuhKr3QmVS/S2pXj2/FLMynLeShDS4aMln1w9EP0A
    pqvemdcoe4NzmD80VXDmYAtHDB0gfcRqKF6zsbDQVpM21JnEYSk1ydLXNVsMVav3GBIywi
    hQPnqaWFPEVLFxE1ukh/MfwZ49XADNiBFgicP+T/lGnJIqigoOGUyXasVesxWJhDCVUUJX
    LFoV4iyAeSWgJJ5H3bwDYapWuPihvRYAuoavv5svgiDBC8o4yT+GY+Vb+1vxHFbtrsCp8q
    GAQdhmxTnIdreJewmmPQSq71P9t4/nBMtAGyJloOFgCGvscFN96znGh4XR+g
X-ME-Proxy: <xmx:_FR7avEW04U0sNOB2QgnMzM1ospr1vsnsablPob81dailu1cW5IlhA>
    <xmx:_FR7at1mcIf2N0MVGWQtVENK2mhtgNwatXTGeRdPC2-sTfcbcIt9IA>
    <xmx:_FR7apzoGtZWKzvap_N_VJaFkYxbpMJQZmPqUU552ri0nUctduZbqA>
    <xmx:_FR7avFEmlPXpgXINeHsfcTH1K3Gyq0CXwak_cX75t8NSSB5OHt1zQ>
    <xmx:_FR7auXAGyTGy5DdbS3r_1xgiY9tAOZfnJ0zceQCJxF9wVk8hORK3Gf9>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 12:59:39 -0400 (EDT)
Date: Tue, 11 Aug 2026 17:59:38 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, 
	agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/17] selftests/mm: improve khugepaged coverage
Message-ID: <antU5wZkq4eoLhXg@thinkstation>
References: <20260807113647.3744609-1-kirill@shutemov.name>
 <e1364571-376a-40c1-937c-40f68b06b09d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1364571-376a-40c1-937c-40f68b06b09d@arm.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CC4AF40009
X-Stat-Signature: z8d1gktq7nmmwtgo6rgrjjcpx5qc7urs
X-Rspam-User: 
X-HE-Tag: 1786467580-76483
X-HE-Meta: U2FsdGVkX1/kXLX5ncBW36VLR1lryk4UnxaJ1UZQ+Ge4402mQ+A7Z+S/uctX/KEkP5nX9jwFrKBuh97guW6vnhCOt4JoJhHvpxk7g7YY7TQKuxe079fkqv+AP1MiVKwaxQnug76G4wk+YHHrzUVNkP8p+334olWHoxsfCdalnv8hd6f4Ro3wt016a/div/sMBYAAD7kEkkIRZPkMEBo1BSZb7KssVQcBzFAnzg/aTNuY5GDMuxl6Ms3rmNf/wBgGNk9ofmiv6BEPiOsxFKLHl3+0tz0U/EWYffk9vurhIbf0UdxKsBNn6uXGTeeehcG1P1DbOSqyb0apfKLGCjPTX1n/a7nQstcVcn2/PQ6gf6bGVNGhPWkDM4CiBBc93ywvQsPCWe3JZYczBEw6501SvbXiyuQ4zq4Nr75eysQx6AZExU6DHB06K/n/5sMoKP4bhCeEPNs/muSym53T3IG0gqxng5AlW0oBNoSbRu4sCFI4EHhweAzrihIouk2BUW8Mftp4P4YGCZCnPNO5DKmAxiW7LKvxmxbucUTJ1bQpwf7t4lspHJuEBNjYAbFEMc23WVbgNVloYEvsK1A2Jwca/G6Rsbr5O02iKqT5PaUl8t0lZ9njg1Vc5b1fmHQX36yTW5urf69T+QqpdvcizoEjmQG86eCQ3tOF85lrPXEUm6hbQeEGKm4Hy1YZLlcjFkhF7HsGIazuclpS0PgepnBBmkbV/mJ889C1PJ3bgTByJ0YAVqhFirJEZnDpqbUMzoeLVXSPECsxWmRiNcCMPfJi0KQSGGH8Phqh1Y/cofKDSxZ8AW7uonZI0ck+k0d+DaVkN2EOf5XBi4B6ji9/kQqD+j3kUFtYSzZUVKvkr6uf2GhXk3XoeJ90pwetNdmuch53ioFPq6wRlMzmyPayhBEjwZlsZdoJejo4gr3qB5wrYP//ekmJgkx/iAuvKA/FnFMyJEpYh0+rzYycqPGpgxT
 qG93Zj8B
 Te3rUro1AvTHFuHeYYD/E7TE9+DaSvKa2QL9dzPPKOHferj+e6MoPKY7C07Av+hLXdPR0yYPPtgmtBqMS+gaTmsEloZK9/aWGdotTvePu24mS64wxXX8IT+Fq2DXkRpIlq83jG7F3QyO57Al+nsmc9bMBNFg4gOZkx7Hw48ijr6G9HGzlFeoi6dqQlmTA4EvOR/z7ppom7PP7j/iAkHTkwLalow5ZytU+L+z06tWYQyuUB362nkaq3SZdgj4QCwCLg/rKIsfWO7dLQaNdbeoogBQUs/P3dtYeXNkCGLCSmJghj59qAu1/hunCLq1CeNbjeX1ImDeM5neioU1MtxDBWBNLgo+u94tSwwLMr5AknnnntYihw5vTeVb65k9kgLbUZeL/oKfxQhbIkMirDSPk/3OpedjcPxRv7oQuz4N6yoXlMHH9OAzchngODvbuY1R2Ci4K/GFiYfAUxtbQliYRHSHVLix6Q+xTKSAW8b+9IhGTLyzqd02hzXl8jUE1e3MI+O7+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 12:40:51PM +0100, Muhammad Usama Anjum wrote:
> > Tested on mm-new (8086604be973), with KASAN, lockdep, DEBUG_VM and
> > page_table_check, in 16G guests:
> > 
> >   x86-64 4K     190 pass, 1 skip, 0 fail
> >   arm64 64K     228 pass, 5 skip, 0 fail
> > 
> > The skips are structural: mixed sources declines at the smallest order, and
> > at 64K collapse_compound_extreme and the shmem components skip as above.
> I've tested them on arm64 vm and more tests are passing instead of getting
> skipped. Hence:
> 
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Thanks!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

