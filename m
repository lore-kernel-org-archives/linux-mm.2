Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E943CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 18:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB456B008C; Fri, 16 Oct 2026 14:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB24C6B0092; Fri, 16 Oct 2026 14:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6DB6B0095; Fri, 16 Oct 2026 14:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A96816B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:37:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3290914052B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:37:13 +0000 (UTC)
X-FDA: 85329346746.29.CE101DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3E6EF2000C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:37:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DHfIra/8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792175831;
	b=0V+rTXUCD4C/VypS+p6GJdFd9kbdDE5qNt7aH+6u1mL2oh7WMR6+wNfmX/bFV7fkhFgKZz
	daMsssqg6JT/YJhOiLQOq99IyDeRJXmRvAm9uP3BrACMiPdM3li4ujasqcAECVsgC4T816
	iG0NcEh0DhUOQlyh0hODsOY8sVeGRlQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DHfIra/8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792175831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIiUJXN9ppwsapWTQHD1yCndjogup7HHozzrqh+lUJA=;
	b=lg1KAzUq4a7gpx0L91Z1OMXH3gIl2zP9drU1A+R/HmKM3P5eMn/0tBNX1bPFMYALixQQap
	yxwF7MDrCtGWLrOxtUEgAKqxu8a7sOhAbeq/adB1d2M4U+zAWUXKX5o2C5uIKvS5hPXQEk
	Xce8U4GRuhgLzrnFJzLwLU4S4sTPzHw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 900C160A8C;
	Fri, 16 Oct 2026 18:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2381F000C4;
	Fri, 16 Oct 2026 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792175830;
	bh=CIiUJXN9ppwsapWTQHD1yCndjogup7HHozzrqh+lUJA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=DHfIra/8DDBY9NEOmDC34f0IWRiCWQUFgm2ia2dkDR4BIZFDpcKVccz5FSyj33ieM
	 pSiCfXE4c763I4tQncLWoKw8kB8EOYZHCiLTnxhBjgXNsF2Wm+a+Ke/dSyuAQWPtUP
	 mBgO4alnEiT+A8Zlcj+PyQGNMxpBoghIyVQ/FiLd6LGhvFPn+hnBsL08IgqQUlSmT+
	 yJOgiY1dBXSNgvPJs9XqkORQihBHWa26EBNpyAeVvBV4B9O6sfnZB3je6TQ/NTKqHL
	 l3WIaAKpmIXF7mAjV50xHgTQK2QAEju0o2Ax4G5Dbb2iu6t5BkCyeLmNavml/+87wB
	 yufh+IKY3119w==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 387F4F40066;
	Fri, 16 Oct 2026 14:37:09 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Fri, 16 Oct 2026 14:37:09 -0400
X-ME-Sender: <xms:1W7SajU3o0eeHnbLq_R-nZ3cwzYqDZgcK8Op0l-SWP1tPw9ymPn04Q>
    <xme:1W7SambzgtoQhowgpzo3R2EQjdSowPnyqY62iTk6C1VrJrs9_wCGf15s_hJnkZCcG
    ZOOFpHecisWfxBhEXrdDWNUm1Wi4HN80oysMi1zokTNMbcXa7fb4XaV>
X-ME-Proxy-Cause: dmFkZTF0/FGLHdPDrCIUsBYvGPyL3FJjefzp3oaq/lWe9hAuun7mjGxM9pgPdoc8pE8lKs
    AXwkYsD6zXi40RkJdxsRBjkQSHEuVEbviXM69lVg9OmntIgwdXMryYauBV8uivqQF+1lhx
    V0NeHxDAMi4bV23cmHo/P+ahu05RioRyPAO701+/iDH9rzgVznl1f4nruiU8V+1umOcIv+
    IamWE/l2HMLsiXucjg0Y9Bc7AoM5Rs/3RAQx8XRmMTFZhMVCz8AHb5La0ss0/ccMBccyh5
    grUWWENMnHpdWjqlySg7DwLKpNOCBYEOnfINZe7ygHbqPiuIuveHti6zgeFHXq2ym6OYjM
    bKdz0bzhIdp4+W9geta6mzvblf2GZD8LKidzG/VyQ34hO2PAIN8nDGHt/lA9y1OAHULpyH
    m9ezCkmpZTJppZFncyf9nj6a49lpteS/TMlpOtMJjmnou5K+GoQ+6TnI+IxPNNnLsCluXF
    jHnnVRuoJaklbsJ7DdR0UfzCKsCQTb71QvD6yDHuMlGR+27lQVFEsGLBAhsVrw7Ih8paNf
    vVPIL4CChVX48e0RGumBXUxRC2Rbl/7cc6haSHKWxzIFvX64D7/Zow3ALo2Ii2Xj+GmUX2
    Gg6+E1zZhU80vbYSqVtFHsE8TlQbiwZeCVwTrnAC0HXD0HEYTHToX4hjPR4Q
X-ME-Proxy: <xmx:1W7SauCorEqsMwLc6E-mC7T_Pp7WOvdts2w_5cQFv6OyWuA5gmJTlA>
    <xmx:1W7SamytNTzEQshhTLrW-ExKd96-5qBuhVYhZpqzwQCu8VotUn9VWg>
    <xmx:1W7Saq4iiFtZ2ECW2a5yIdZNgjZSjyUqEbfq0JQFH6qsOYHsGcM9MA>
    <xmx:1W7SavzqaxuA3_h3yBrOsb4bv_h4tRpAy5JkDEzn0tD6hguVU5ovuQ>
    <xmx:1W7SameQLJqUrOl1YaweY4BF8aK73IS0MEztY-O-N6viTihaAz8MH_4r>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 13A4D782738; Fri, 16 Oct 2026 14:37:09 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A1bjWCdmgco7
Date: Fri, 16 Oct 2026 14:36:48 -0400
From: "Chuck Lever" <cel@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Jeff Layton" <jlayton@kernel.org>
Cc: "Mike Snitzer" <snitzer@kernel.org>, linux-nfs@vger.kernel.org,
 NeilBrown <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>,
 "Christoph Hellwig" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>,
 linux-mm@kvack.org
Message-Id: <ca089229-de04-445a-a40a-d4559ad4908b@app.fastmail.com>
In-Reply-To: <atIQkYA0AZg_z53_@casper.infradead.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
 <20261015233309.42999-8-snitzer@kernel.org>
 <1299ad92163f2eb8fecc06165b3b52f7904f09e9.camel@kernel.org>
 <atIQkYA0AZg_z53_@casper.infradead.org>
Subject: Re: [PATCH v4 07/10] mm: add folio_mark_dropbehind() to mark a folio
 dropbehind and account it
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E6EF2000C
X-Stat-Signature: s8idfb6brxfqw3mffzbek8kfpqbqjdb7
X-HE-Tag: 1792175831-734527
X-HE-Meta: U2FsdGVkX18womnmVKZ/PrSRYHS6rSsQTAH1RzCUOmugn3Z8yP63S7r8AebJTpNly801vplLElcVIecY6/tkJaUCuR7D56ty+PyoAVhWoRGs6+Y7KuwGGHMNCmY9b18/M7mNC3Sl3pXkfMPhtvLDpKdfWN6jRoggx9wz6NCB7A4EpLgGs6DvplBLqRq8HdzNFWoL0jL+4q/YExdS4ECt5bdX7H79mODEXffQwkVsm5R+gUtC6S0g2c74/OTg5JVTdxxMRsBW64ENikPA4kKfjnV8uepoCzgie1CmD/ElamGI/dakPdcUHKX0H3zY6s2wfDE0+Pjgm/Hnt3G8Qm5pQ/7uVFudzqm3c9wAdIIqjAJuUelTds8SlBXiWn8CxcJXTG5DUV9LpnH4Krkq3o25QfaaXyC+TlYiJp/GRStCDscblJPiGrmjb3UgNllMCmPfbdbMbaDLLo6NiE93HU6LHJ1q/I4fTYMA30W2xNg93VxTpn5lTWpdHn5kL7+uojX6JgBAO+Aa6qXxzfr38xAFYCIO79vOJcTrvKVYhzSl8TZWiRlI2H8LXOpDhOCly55bkgtF/cwWyn92mZNbaXhHXCltOyeZiACFLReuOcD7zkUwjqigWCOFBuQ2aaTAZl71DaTX3uOmReKtMGJhb7SUIruJedt3Sm9GKezIEJ4OWz770mZhCaxrJeWYcUophXahV3oBfDGgCpbUjt7Qxv1caEudFzCa4RENEevASZlKXoH09gHNEVdpZrLmjXkANEOe8MVVhYd4LSnhGMoAeFet0dx2ypSjwmX6cmqaXAWBbuFFki+yrEGVeVpKyXRV+vnb6C+cbtETwe+poBN/JkuqRPWyS0bYUxtIxkF73AJg/gDUbIg1C/w8XTj3GZapG9W56B4Vgv3ro+Jc0ol+ymbWdzJu54OJHXhp8pJauvO78xAVvsfqafHjAn9ofxZr3KBrhqRJHOcWUvvXSEQmVxD
 UYWRkqof
 pVqVIBtUfBBoOqDHVExQyHz9P/3kZvbrtkINFl4SCW6s9KlZzfc5B+Q50+63ExI/1m16xVhnpWn4PZ9ZJOYOMat0UzCutdEoeiy7+N4SwbUYjt76lRBuR/u6d3jR+wANAUfhnW4m8CMO1gr4Vq1kbBgntFXpGnvCZdOKuD6n9+YmYajMKOXG95lyXEhMyp3hjXZ5bMQ5kOONm3UyQXTaoSL83CGMM6wSe4w1xxLvDu9GxpSuqZjmq3NoZwMjWtJDXYolotSYvhvrkqTbL/rf8kWBH7aeLlR1JbbzcncjQdmJr9PhyeeEyZEMKiMEW3L2167ysjbydbkOavNjFHwzJmj/E1qxRK0zf7XdVYJ8Tppwmq1cI9baa9ZHVyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Fri, Oct 16, 2026, at 7:54 AM, Matthew Wilcox wrote:
> On Fri, Oct 16, 2026 at 07:08:41AM -0400, Jeff Layton wrote:
>> This patch and #8 need to be split out and merged via the mm tree.
>> They're related but the rest of the series doesn't specifically depend
>> on them, and I doubt Chuck wants to carry them.
>
> Patch 9 calls folio_mark_dropbehind()

Seems like the best plan would be for me to take 1-6 and let the
MM folks take 7-9 with an ACK from Jeff and me when we are happy
with 9.


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

