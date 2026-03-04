Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97397EFCE2A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A36D6B0088; Wed,  4 Mar 2026 12:45:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 071F16B008C; Wed,  4 Mar 2026 12:45:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB5EF6B0092; Wed,  4 Mar 2026 12:45:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD1EA6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:45:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF933BA613
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:45:34 +0000 (UTC)
X-FDA: 84509107788.11.6B63A6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5A0E11C0007
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:45:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MHMcgw84;
	spf=pass (imf20.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772646332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNkWCLZVO/R/KkvpTujUJ3BKfdAzr6K2wWaVXdZpqM0=;
	b=j6V/Rjh3NQyuWmcmI5YhGaAjeR5QhdqBfc4x1Oc6dEw7ZFUxC3oi5bDEkT4Mc7pxPgxc6X
	aqPFkQ/V6uV/5JNrATEwq/Sh25pL/zgnVohQk3tthAfksCujQtuLA3v49csP3asfusQxX+
	fbE617ntTB8Km/Fs0TpRfWAyCLSVCdw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MHMcgw84;
	spf=pass (imf20.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772646332; a=rsa-sha256;
	cv=none;
	b=XH/RXcUidYfmRNgevrKEY6XXrCh9iflQnWtcBXDg3nSa7TCCzfwY+zhkL4l0f8jrCW0cUc
	+PP8efS/FF9sr6dzX+y0nAedefb+w9J0xUo2LXZykNkZM8o0J31LHwbfk5cMLtsaVNWdDd
	fePdZKKhyIE68qVEUUQTkdvW51Ws7wE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D6D543960;
	Wed,  4 Mar 2026 17:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C91C4CEF7;
	Wed,  4 Mar 2026 17:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772646331;
	bh=hNkWCLZVO/R/KkvpTujUJ3BKfdAzr6K2wWaVXdZpqM0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=MHMcgw84pNpi+4xbHZkfaKt79WhQqTHhmGYQpiQqGCXmz6eVI34ZBHrOTFKn8O9KG
	 9SZw2Ks3OapLgEgEHbJ+kwgHVZ9RetmpfkWxEUAIbuBwvgUnr5vrZdajUtMg2OzbMv
	 T5sX71Y0bRd/ZOaaoPlohRaYfm+eZvtod7Mf+yAknHDT7b2mWqQf/KBL0EpJ9/kI4i
	 C1QsKOVgL5CX+nv2drefdCu73+ZE1TtVhsPYj8c7yIGxqiBLCykq7ERw4kXGaKKDg3
	 qCQVSm74KqNEFxOp0yu8vCvFZjTKzUVPXOL/uABTB1Wj1szknofSzXeJPuV6IVccE9
	 v9b5NPwb0nXnA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 95EFEF4006A;
	Wed,  4 Mar 2026 12:45:29 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 04 Mar 2026 12:45:29 -0500
X-ME-Sender: <xms:uW-oacZq077lgVTkMOUj-dUmbNfI0CFO3UK3vCOq9sewwCz6ZRLYkQ>
    <xme:uW-oaSMuCTAcMPMdY2K9pOm6V0vrj_aGoWMA8lPfrYYvn17WTgehsgPqUOONxZ_9a
    NnfXZcNOCkFlNv4Hx79VJC6C1yjdaxy44_GMdxhUt2dnGdJwez2lQY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieegudefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopedugedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnh
    esihhnthgvlhdrtghomhdprhgtphhtthhopegsvghnhheskhgvrhhnvghlrdgtrhgrshhh
    ihhnghdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepthhglhigsehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtph
    htthhopehilhhirghsrdgrphgrlhhoughimhgrsheslhhinhgrrhhordhorhhgpdhrtghp
    thhtohepuggrvhgvrdhhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:uW-oaYUW-HFeBsSWBCuImA4czvoe58enckRE8o1gOQuit26bFJsvpw>
    <xmx:uW-oacA44J5IPwPqowvfeqBBjt_qgVWNF3W49UwEcqqMtIN0JXLLlQ>
    <xmx:uW-oadeun30kpt8nXeBr4Mbq_S3ZZK53JplF5gjKWptLAl-SUks2bw>
    <xmx:uW-oaboO8ce97anv0TZImuVWjBeAPz1YbCFdeJAAKHtXlwTM903y1Q>
    <xmx:uW-oaWTROfWloc601DO2gcNnQFVbnxDc9KpSdzrTQv1eNoW4K0nww2Yj>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 6AF94700069; Wed,  4 Mar 2026 12:45:29 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AusYBuezkfp3
Date: Wed, 04 Mar 2026 18:45:08 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Dave Hansen" <dave.hansen@intel.com>, "Mike Rapoport" <rppt@kernel.org>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, "Ingo Molnar" <mingo@redhat.com>
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "H . Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@kernel.org>,
 linux-efi@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 x86@kernel.org, linux-kernel@vger.kernel.org
Message-Id: <da9396fd-f321-45d0-8af4-566dec32707a@app.fastmail.com>
In-Reply-To: <e3585441-f225-4a60-9c48-aac2753eef36@intel.com>
References: <20260225065555.2471844-1-rppt@kernel.org>
 <aafqhcG67FoNrF41@kernel.org>
 <e3585441-f225-4a60-9c48-aac2753eef36@intel.com>
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A0E11C0007
X-Rspamd-Server: rspam08
X-Stat-Signature: c3qar579yqxce5gh1z5kqm7i5e3o9yz8
X-HE-Tag: 1772646332-453677
X-HE-Meta: U2FsdGVkX1+ylzyHG0zEBPcyChdJ9FUDm2dWu5yOBXtxw7iyOziPtBhlzg3QYwz9DwnLSn2ujCBsWBevE6bH+wuF3PlfwSHD8QHLx3eYgnhJ6ILk5sYAJZudlcVaY/slZ+PezcGtHsnNUviwWPDnNEa5zHy8NRI0PMpdev7AM/MOfjenR3j5Dj5+X9rj5xW00CEvN+ydh6TZrajY6tPN96kAuY59+0jfcPuI4VN4lzuvXAIBB+rhUX+Zfum9Cc2Dmr7D3pSmUg+xrYv+xP3186VsPfCziP4XZWLaRt2ARz2MGU9a94VSYMAxarTD40aqFRJTU+167fY3ymkKU5ZgXLnSbnivDep3tqkOfswnkFpgvq+Cck2xKbxfK9txvH4LIObN8G7ochyINFgyAK3dIQBwDzDoxaURP/yL5nKjojsj4neSkbw0xVmXwK63NuVkswxCSI1shEOcDvXdf2td02tFdDI99msIXw10Iw4+xZWVKa29JLZ3fXe/E/yzyicWnjp6q8isWRw+HUP+S5R8/pm4kpijnAi6hnqKhbreEE8CJWDxgyqkskglXgVMt97J/13A3hDBtXDqWyqOvR5AYVA0WiQ5EocIsQ39XXA9iG5UWFk57uzvj4ZwdV0cUnBIC+wfZrOq80btKWXF14e/bDHCzL7yY0R6xiSJoyE6JTMdVXfqOvEEaoM45gnIcPN4PdkehhYww6ziNVEZrp/8gpT/oyFDUZP5/JEwOn0D8zbohT3vL5m60Rr2gi0aJoRqSeWDBnPAdGI4Jw11AonPKyIXsc2nRmY3ritNPJ3kuP+L1owMFMmW5j7DYpkimSyIVTGXqj7KSViPt3CB3hKpcQPY3nxUmpACa0+mPQbcVkofyOptGGJdf4Mm8z4v2jatG0+6Kygdl+kxuMIwwod5MZSmHTE5D5Qv2/7peyQRs/C3uml2zS4xbBEC7Q9s5CpywBEwlVp0dtDs6rRuokg
 8nKXhoMV
 3gwIv7j+pqck6949O7zxZmC9/0sI7KNKLlJKVbcuxCqxiSeeaFD5GcJkiuXesTCCgzGvRL6rxf0hb3XKGrBfNTDtvLYKX8jxWB2ij5YWV/BzPFLHmdtKaUN28hH4XlO9eBkCA7l0Q45+IrDU2CkDcTxMvYyCUDx042uNeDXtJ09xgj4WV9APmsxgTy+0kQ+pRnlAj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, 4 Mar 2026, at 18:44, Dave Hansen wrote:
> On 3/4/26 00:17, Mike Rapoport wrote:
>> Gentle ping?
>
> Ard, I _think_ this is one of the efi things in arch/x86 that you
> normally wrangle. Are you planning to grab this?

Yes, I will pick it up. I'm planning some cleanup on top, but those will not be fixes anyway so this should go in on its own merit.


