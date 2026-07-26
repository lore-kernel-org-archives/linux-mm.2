Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CEDBC53200
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 08:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09DBC6B008A; Sun, 26 Jul 2026 04:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04DCA6B008C; Sun, 26 Jul 2026 04:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FEC6B0093; Sun, 26 Jul 2026 04:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C18306B008A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 04:24:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32DEA14048A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:24:25 +0000 (UTC)
X-FDA: 85030240890.18.3D00DA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7D76F140003
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:24:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=naYCHlv2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785054263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1h8J0+r+HKDH96f38eGX//+FYYpw9kc8NPw1oyEbaDg=;
	b=ylFkMPlUkDR+0vpcrXRKkz/AzChhpm+biMphuHF0yxeItHxkNz5kdVE66DTBNchntQyFLM
	HTfvY4UQ3gz+eQf7L3V28yhPPrvsZicGzkaKQywJImwDCp3Wz57VcUX6GqzBBoBSpO/jAy
	ZdBIpYHubbhDMT99f47KqcP5y3avX9w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=naYCHlv2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785054263;
	b=j68SjFrhMDM2P4vJ/hQSmBX6i8cS2xt45rOTRIe19bnDun3umq4yDaCbcxaPKHueQx+ek6
	8wBn/cqoAmSRknIe7i23YqTWcZL7q/qkvebJVem5HpXE35Iy1pULn+Flbp6qxqHR0/cVJo
	q2SWQmuCTjfZuJxawv0cm864i+5x/dw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C015640AEE;
	Sun, 26 Jul 2026 08:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CFF1F000E9;
	Sun, 26 Jul 2026 08:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785054262;
	bh=1h8J0+r+HKDH96f38eGX//+FYYpw9kc8NPw1oyEbaDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=naYCHlv2BL4Vo5IMZ+rucI1IUcm2W+5FvAdPLeFy/8TMfofkrUngKY0lHlo/vG6F4
	 Lrr+4uVz6/cfuXZg0bnFRsvN2neMPceWNnPfBHNLESE+J5QuKgZ1YioVZSyBz5oJtJ
	 ze2up/U4UFtMocCPZjFKPedCx8NGK25mUxbyfXm7gzZOOz/U5J95ePcwWQiSnduZia
	 ZyS0JORzuiIOFYHqZDSK6REAX4/Td3RhawVi2D5joirUlDtFDsZ6vA1RSYiIc4ixK9
	 4TddXhyhT4jfAdrJmhVXMLJFQ1qORwSvUj8wIbVzE81kkbXNMgjtbTKzuymVgH9sGl
	 Wlt66JKBy459Q==
Date: Sun, 26 Jul 2026 11:24:19 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gou Hao <gouhao@uniontech.com>, maddy@linux.ibm.com, mpe@ellerman.id.au,
	npiggin@gmail.com, chleroy@kernel.org,
	maarten.lankhorst@linux.intel.com, mripard@kernel.org,
	tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch,
	bharat@chelsio.com, jgg@ziepe.ca, namcao@linutronix.de,
	ynorov@nvidia.com, sshegde@linux.ibm.com, nilay@linux.ibm.com,
	clg@kaod.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, linux-mm@kvack.org, gouhaojake@163.com,
	kernel@uniontech.com
Subject: Re: [PATCH v2 0/6] remove dead NULL checks after GFP_NOFAIL
 allocations and fix xive use-after-free
Message-ID: <20260726082419.GF12003@unreal>
References: <20260724022851.466017-1-gouhao@uniontech.com>
 <20260725202632.dcb325658896a470df91cf57@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725202632.dcb325658896a470df91cf57@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7D76F140003
X-Rspam-User: 
X-Stat-Signature: tuuijpzqbuhxa9mkz5si6bg6e3bsw4cq
X-HE-Tag: 1785054263-942318
X-HE-Meta: U2FsdGVkX19F1kk/Uo0tAtmzYEvB3lvlDOCw93Iys133hw3ouh2rI5doSkIBQq/xCavTWRbfmnEzCX/V8pxjkd2GPOSE48I2FxWbEuT+OwFc1WB9kXY+WodNOw3gjrXJjyDB+E+QJ32oVqUbmNtCMwyXMV6MGRACF6Z564f8RfrJbsptJ5vEHSAx21E1ehjgk86wkO+xF3GzagOljVqDbse73sO+pgbdnMCvmYAVNeWurSJmrJ5uNDiBFtoqWvYSns+bfjbyiwCgIK7P3HNDum2KQtCdswUPAjHH2Z9nessGFImiq3t/UWeZBGBW0bnnpJ91Xtk73ooqoDcaEFmw/bYykp7r87cDOtEQ24M17qJyBoKJfEUCz23AXGRMAZnPSiLHIixa8Eb4i/ScXoPmpH5WQtAhp7m+AkeQoj2osfNyayVX1ZhdqBBPV7Ps8sgAg4URhje9T1UKlLtGeAm26rFQUKT8OVHORzOnjl8Fbc0fi34xloBOgIlCPvaIBhELcQrpt0TlbPZZp/zKQ5yQJuGNorwqtPYu+ei7mukoVWyeD9GfKLx5dsUXO0qykOY8QQ4BNrSt5RAB984a+fWarIZBCd4XJVaIVy8zZWv4HCIf1FaDur20dmjxlgaqYrxkAsjpdE+OETG1cs9v1/yuqfPGHxAWFt0kybl72c4UWNq2zpn6lijnzOqzj+cfJEmE/YfhR+915DTYYI2f7z0xa0Lulv2SsvJ1JeEuzsprNQsSjbvBPcoICeI9mUPryTmQFUpOZaVI3LXTw24nUB61ZjUVQXp6V2pRHZHdYHnkcsUfFU4VcZsFk135M0JBphY+C7fe33kqe9Voz4Unc2HPxLAN7AEFANnHkgXnO7z1JTJ7QIkTfSfcmi1Bwyr0l6blF8hfK0d5e9zj0tmMwj1h1U89SIYeXOWlrqRycbNzhjm/gj4SK/yrEnkqyu3VPuGQIqL1gnM1+fAXsi39KeX
 TyIQZtRt
 2OthKiYH92/MH5Qv1MKNzseq2Khyvy2jTnIfgAGnfGZxVh9oZUpszp+tg6VPecQ+e6JEbcHMgEywEQMY6/XL3uj6+bK1vJFYKgyT2KVi5LuxapLkIOGuHkovJHXJyg0fXEEZ7QCTWp3EBDd0GS0G+9QTPByfDrIpqA0WWlkmB4FvWrwI1UjGtyZPc7oXmEt26zJLkE6JJVtixa3rqIt0ZsJA8y68DoSRyPTjIwiT2mkdzpAt6KCghaYfjHclmqX63eiPrqJGIg+b0Hdmk6l1Mpum85IUDWNYJHcoHdxNpaKyGeoxl9taRnzlelo1J8Oeuvlb1ySrkQpPCR2Uyld5qbnOkCmPzvabJs/a8RHcQ1JYNfCNTB1YgrNxWknSyC2T0UfctdTs5rZl5u7/3dgMNjSU6nUrTbIs57hmVy3Vbk1uPRXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 25, 2026 at 08:26:32PM -0700, Andrew Morton wrote:
> On Fri, 24 Jul 2026 10:28:45 +0800 Gou Hao <gouhao@uniontech.com> wrote:
> 
> > This is a code cleanup series that removes unreachable
> > NULL checks (and associated error handling) that follow allocations
> > using __GFP_NOFAIL, which guarantees non-NULL return.
> 
> Sigh.
> 
> Back when Linux ran on an abacus, I added __GFP_NOFAIL because four or
> five sites (file systems) were infinitely looping on alloc_pages until
> it succeeded.  I figured we should move this operation into the page
> allocator so we could easily find those sites and fix them to Not Do
> That.
> 
> I made it very clear (changelog and code comments) that no new code
> should use __GFP_NOFAIL.  How did that work out?
> 
> hp2:/usr/src/linux-7.2-rc4> grep -r __GFP_NOFAIL | wc -l
> 241
> 
> So much lameness!   My immediate reaction to your patchset is "No.  Fix
> the damn code instead".  But I've resoundingly lost that fight.
> 
> 
> Thanks, I'll scoop up the entire series.  If individual patches pop up
> in linux-next then I'll drop the mm.git copies.
> 
> 
> 
> AI review has a shower of possible pre-existing issues.  I'm seeing
> use-after-free, double-free, leak, system hang, NULL pointer
> dereference, usual stuff :(
> 
> They're in powerpc and cxgb4, if maintainers are interested.
> 
> 	https://sashiko.dev/#/patchset/20260724022851.466017-1-gouhao@uniontech.com

Regarding cxgb4, yes, I'm looking into it.

Thanks


