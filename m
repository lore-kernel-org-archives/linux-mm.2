Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35CFC103E162
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 11:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DCC66B00AB; Wed, 18 Mar 2026 07:23:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318E16B018A; Wed, 18 Mar 2026 07:23:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0C16B009B; Wed, 18 Mar 2026 07:23:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 037E46B0189
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:23:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A5E459EAF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:23:31 +0000 (UTC)
X-FDA: 84558948222.27.F286FFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 957E8160002
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:23:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VWTaMfIe;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773833008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxKk1bqk2oQ4HAEz8aj5BWtjCaqmfnEHcuLVuUNlWuI=;
	b=ZYsQgkxmyUcaA0vpvWXdY4zGvEPuhf0r/HNI++vGDXnTxmZzy8ZAM9oOzdwRuKcpiqmrB0
	SU0fxfSi3FMXyW8fCJNozcizJRweajKuHFh/WyBvbrDLkcBrjLuEXcFpEINiN3jR9FomTI
	jU2waMe/SD89cnxB3c+45oPAipA62ik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773833008; a=rsa-sha256;
	cv=none;
	b=FUabAtc8mRbpV18qaFOL/++jo3Y/Vj9kfNclXDqeb0IyKYpFRUrcvuPMm97+YQzTSDfJOj
	XjwCrnEJVzgrJ6EFqcpfhdNuIQ/uyeYS6iO9pScDJHfhw11/cbuBCymPtV3G4GmKMOi+rn
	Tf8N+G3Vxm/nJ4ArEKgqXbEZtN4ohCg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VWTaMfIe;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29B9D41B1D;
	Wed, 18 Mar 2026 11:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A872CC2BCB6;
	Wed, 18 Mar 2026 11:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773833005;
	bh=FxKk1bqk2oQ4HAEz8aj5BWtjCaqmfnEHcuLVuUNlWuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VWTaMfIeOOP/lMAc72JZ9F+C6ooFvDGxsX9IT+IW/oxsmvCObH1t8P56Gzd6D1Nch
	 GavoV5Iw/Ua+zcBh0fKeEQ4mL3EuvvLemdYUwTVBlBGrnCGyLF5ebxhFhvlZGMI3d4
	 NsFeXYqGnlXFE3mvdlI50TqCjv7RzNnL7wR5ZqGa9+38NIxknWiQO2PaE2Eb9O3aTS
	 ivQ3yr1Agx4vEDL2Yy2AIesQusfHTA36CGNagDAviujkZ5OVJxNqDJVUrXbwc9TIZ/
	 7jHrdmNtHDe0OxywaKB0yBCIa20Tx+cA2bjGVtt0Rj6lJRPrNfu1BoxnoaQGXr6Y5j
	 wVXfTH35RZxPg==
Date: Wed, 18 Mar 2026 11:23:20 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Jiakai Xu <jiakaipeanut@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, riel@surriel.com, vbabka@kernel.org
Subject: Re: [BUG] WARNING in unlink_anon_vmas()
Message-ID: <9f192045-f348-4341-8a45-867f4fd34a0b@lucifer.local>
References: <CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com>
 <12501051-98d4-479a-8f10-547b2c08ad59@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12501051-98d4-479a-8f10-547b2c08ad59@lucifer.local>
X-Rspam-User: 
X-Stat-Signature: amh1rj5aek3n7z3zdddcp6ado66b5yh3
X-Rspamd-Queue-Id: 957E8160002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773833008-685062
X-HE-Meta: U2FsdGVkX1/rBZc75z4OYXAP2CeAo0dtLIxpx/J2HDrKrGInV3FVpAS8YSf55shehFU7alOdpHuRl8v8SeuPPXyh2eXIxs8t7tFASC5iz/VpDtj6MaEvb6NcrEHaXFqq71iMWlb2PyIlGsSqxZTE/kwDYtu/bBQTKfKkWS0z+R8j9irdg1jRVXTLEld1OaHl92m+8oxEHcSEQ9WrPvaVsPCuNFm/kKNPoX7dgKX0zjG1jgRTdVFdpcRKAWCdIXDbq54rQ9xvVEbPqcOIenKTfkm3Hj/OdXQSdxaBjd9/q8Zl6haJ7j3pGgupfXBAFpoMua/lhOt6uVEhgxcngcqd1DKbaqWfotyiBiEjCGnaIkabUg6gdcOplqPl4azU+9H98WuLB5YHq2w3BcbO4iSEgexlGA9Wm/4rSHWuhWbniRzXQTGW0PlBm36AvsO0z85tc0jmDZjLezCTlnztGXxoIuAMuimUBJVIT8HP5NBAz7r3pUZhBMpQ5mQUB+hGQ7Y3eRkrLUVVQxvdXsc07c3anfbIlRskKXjIfsDwpSNAp0zFff1KzaNAntz1MX3Yh+wBYxt2PCrzZOtb9hd34GGKuab7ZPOk/S/9Obl0ZCtNMpN/BJvVHgH89s9CEgXrdygg7Aqp9prcRuIn+LBtz8x4C13VLBP4RmpSPaxvmk2XuwRcKHTTHfRrG3DlXnMD7RP03dNTANe3Qh1Fh4U4lcyNUaWu3EPKwdiofd19N8+KIC3LR15IA4pUR/5K0zHzN4SOhv0ndd47E+d9EXWdV1auesksxYrdddUr4Plq2ZnAuM2vUVcaXbjd94rNbLXOAoCR/tPCSSKg2HnoZz7QQa38ag/npfNVney7MDihmF6CMRIpwa5OXw4ZTG/elJ7/oEnJQUnPOlQo3c6HRfJv1f+BvVQ9Oy2KqEO25qtLSEjujgs0/usRA5jdfm0vvUvZ1VgYaRoavUvJRw4nwt+SjAY
 VwctkPUV
 VHWFJUstlSFILaXS1YDLCOm8WJm7OzLiGf7JxqfKzMkbRx+AlmKJsZ+KpPeQImpB0B8h40Y+vWGtX/S/3T6KC37JQb1p46hLMVUlwJotTMwLI3ZADi0FiNysW2AOUhAoNvEihWU9qDx1VCdqHV7A6JG6eJDozsTqXFZmkVDN1fyxL1ccUZU/EIlCUuPsjK3yPBtW2KEp5p8tilbEOvQfCd9ntYWpvWCunN5kS0NzYw9HqQoeZubcKQlqbc1g55PPqUXyJ/FjoMoYny/IRtChUDIVH1wYUmiTakbtI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Wed, Mar 18, 2026 at 06:42:49PM +0800, Jiakai Xu wrote:
> > If this turns out to be a real bug and there is anything I can do to help
> > with fixing or testing, I am happy to do so. I hope this report is useful
> > and sorry for any noise if it has already been addressed.
>

Do you happen to have a copy of the full dmesg output? Particularly looking
for where the fault injections were made.

Does this reliably repro for you consistently or is it now and again?

If reliable repro, could you try it with the upstream tree also?
e.g. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ at
master?

Much appreciated!

Thanks, Lorenzo

