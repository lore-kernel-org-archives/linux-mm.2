Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF6AC88E45
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE9A6B00AA; Thu, 10 Sep 2026 19:51:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98CFB6B00AB; Thu, 10 Sep 2026 19:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883F96B00AC; Thu, 10 Sep 2026 19:51:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5686B00AA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:51:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B2D644049F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:51:30 +0000 (UTC)
X-FDA: 85199501940.21.FCC9D32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1344420002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:51:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVJaDbr7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084289;
	b=idqiuTtnpIUxk3Edp0YgYaRZu9u4XEjW29hnzHEFC7NuLNE4gqyD7BjojiX2pf3Ckqg90y
	hDo+9DBbB3D4S2It0zSCU/JNMs7sNo5tskzRrz//A/uKEPfRHWOM95QZmZ3gjRI+0GyXyE
	I13iLG9Yto0X6fUJuEpA6fAz4iuG3hk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVJaDbr7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=EchVdgHD/jaEOcGNwu9K1D/RE/PHTaZPan+sGsBz7Hg=;
	b=HHbc4MOeHC1pyHzOresAOrzvZYDsB4MfWMjX/tbjLpXIZNx/TL31/Bnhy1EMDH8KUlwDEQ
	rYYPbDAwDWs1eMxfJh+KAa+NCs5h+FbYnXf024bOMYTZD0yiMIVzw3ZiKVah79klcEBxdG
	dA5Drdk568zGcYKbdRhKe/Tqg+4MFPM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14449439AC;
	Thu, 10 Sep 2026 23:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AF91F000FF;
	Thu, 10 Sep 2026 23:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084288;
	bh=EchVdgHD/jaEOcGNwu9K1D/RE/PHTaZPan+sGsBz7Hg=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=eVJaDbr7TDZmKSMVzTSzTnbr6LHPdVB4T8TxUGUgkzVL2dnOJj+wLioEQMQFNT3ah
	 EDa8rpCFBgV+rnysoPzaOpgFMxYYbo6Pqs9IDGAnRjH1SCRWeQAno8HW7ro0Srunsp
	 TwjzW2QzUsiPSGwBN81N923kRd+vNzY/mtS3h5Mgqmm0nw5zmAtkqRGBLWuvO0dk/y
	 T7sC6NnhLKcVOV0B9w3Q2t3F20Bkgj7A8yWD4vKMGvehrAyuHIexfk0nS8hyD53iNM
	 M3Au8yPby2Gvs2mOCaOtk75szaMwkTrZFJK3RlCxg0htPYfabgJWieRiyt71eR9ILS
	 HiP7AziEsSSfg==
Date: Thu, 10 Sep 2026 18:51:26 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 06/12] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
Message-ID: <20260910235126.GA367952@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-7-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1344420002
X-Stat-Signature: phcqiqqep61na3ncx8kt7bc7x78cx9rk
X-HE-Tag: 1789084288-145353
X-HE-Meta: U2FsdGVkX1/gz8SQ21aI5WSvtsml5jg/uhv9qlbiA1tEM01o19LaSIA4eXq/HiszKw2JsszZclaAUB3YCex83ZuNeHw79yTGebHJg+CaKacQEKJpNTGdDs5BvOwnwK3IOOwjfhl34SrLEZpI074uLdSSSZwfxLhDvXEvgkP6CQw09ceA3zeume3bLd2L0Ebr5scfwTdgkf/kcQMvg3WptNg8I3dKEzmo/1JDiB8gfqPYznb7jwUX1EjId7LoFEDHlxwEoh1CEIa83Mt+plZUfp362Ah44z2sN32aso+7fX02M6n+mGq1wPHLJgskF4ZzZsFlTRrE8ucyITpdyI/dMwjLfrAW9HmzZ/aB2Ki1P7SaCHdKaoMYvTXLz7o8VhUfinccDPdsO9KC1FZKnFvSvBDRKojLUuS4tfCvHeobKtgdetHzia1fHVC6Dm/rZzVpO2mViUEWRS0LuDpZdA1HOlWouILuMMdS9ZJ31cucOdQlXl4TWsjAbSvzPnKmCLOeanzDspRi9/SouSqA+7EaJsPy573DmGNETo4SMaZ10QwKRcrreoWJ0H6kjfNa4NISbcC3HcykDXdwu8tscffqXRXP+sRYWiAVZ9mrsaeP1w3+FNbxdOEN8RKsZn7gpIcNOImSgA3HOY/T2vYJ/zTu2DCrkdzlCKP1OC/ASK33c/bP9Spfj1dhoxPBYpdThUIPmWd29qYj+E+vo279E/Ulss5LS0GaMat93s38lbxiHQimpne6JufY9+nfvjl8bjK+ti0p1HOfiDREyQ7xvn80vOAZumZegqPfcACSajnvvc/2JBrw8FxwodiKazOAqt3RHjOKFnDumjRFKlw+IPTFfNWMFZ44jF4O3KKPam3iHJYLMKkNjH7RFJEWmU6wMKRxYFYye5ozNR4ZH9WOjQAWO5B/f9+pTzwsq3MI4uZGHwY04VaBBZJLusmp/6EEDW05lve0trxC+IinUWg+CfB
 mU5926W4
 lW3zuS2yNoINnmJkQrnoo7FTlfvHizObEK+Ba+AoiBc17c+Z3MslYVEGeX9RDQx71rc/SECctndMLg945VR1YWGUEXb8ugUJJ8eB7bmDCNHvemU5dvgstGZnyZrlwhg6sbFUvxmqafx77ITYO6IBOdbHXkACapLDsM7DD/55lJcMFC+UdQKQcXRDujD2zfUWND4S8ejYpM6Omi0FONo/SO781V/iQYciIeRK1GbR9P2qa5iu0Pp3dqH7lw673r7FISQhr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:10:00PM +0000, David Matlack wrote:
> When a PCI device is preserved across a Live Update, all of its upstream
> bridges up to the root port must also be preserved. This enables the PCI
> core and any drivers bound to the bridges to manage bridges correctly
> across a Live Update.
> 
> Notably, this will be used in subsequent commits to ensure that
> preserved devices can continue performing memory transactions without a
> disruption or change in routing.
> 
> To preserve bridges, the PCI core tracks the number of downstream
> devices preserved under each bridge using a reference count in struct
> pci_dev_ser. This allows a bridge to remain preserved until all its
> downstream preserved devices are unpreserved or finish their
> participation in the Live Update.

This seems to hint that we're going to allow bridge reconfiguration in
some cases, e.g., for hot-adds.  The simplest case is "leave config of
all bridges the same", and I thought that was what the previous patch
commit log said.

What's the benefit added by this patch?

