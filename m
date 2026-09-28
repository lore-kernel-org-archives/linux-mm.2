Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F489CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0D346B008A; Mon, 28 Sep 2026 05:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5106B0092; Mon, 28 Sep 2026 05:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21F96B0095; Mon, 28 Sep 2026 05:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 990F26B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:57:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21067A42FA
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:57:56 +0000 (UTC)
X-FDA: 85262719752.23.62AC83E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8C3C520004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:57:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZhBP8ZQ7;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790589474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gahcTOLE0N8cyBxKfVjqf2G88KQ6EJwfzOvB67dQrv8=;
	b=tO9fPOYnrl7YhJmLElFqHUSn7YyslbgV6M1UDXlzcuQuDizdJX6sGoEiCddeZ9siNlbVwq
	tL/EmnNe1eb0jR4Ezc/qdhaK3VCgr5f7W4utDudJvllwJl8Q90SdCydcfGtrzvK8mbGjlp
	Io0IMBFklvJp7Nfj3wfiBzSgxYEO9h4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZhBP8ZQ7;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790589474;
	b=Y+CI2gBkffR9CofQea7nTB260XQf1q/4jgAFHXj4X+La2UATsLymgYteY+fbYtsYdUuTnb
	qESIKq4mR4y9bZ0MDs6T0tnoxqlANk/D2oq10kNSyrsv73UlnXgiPfgZecqdUyTNE22ouX
	BGB5/F3a2GyBm3B9gOfs+hjX3+UE66g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C0AE43741;
	Mon, 28 Sep 2026 09:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DEE1F00893;
	Mon, 28 Sep 2026 09:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790589473;
	bh=gahcTOLE0N8cyBxKfVjqf2G88KQ6EJwfzOvB67dQrv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZhBP8ZQ7bV12wp22rpbYfnlD1HVau+UWZu8/dgQBY6zOsChjmQkcEWj/u7b+8W1Yu
	 8ZD2XM4g2irbOb0k7JpUHTxoNfwS+CqQjvhUDW6cdvsrsy8H9DbOGUWPWreMsFH21c
	 QN/dIes4q2CaXdIsQXBETt3JUUuMvit/pEiwHp6Y8e72LqVHLiH8wtLaEaoR214y5L
	 19D/Wfv+SNxNo92bJ5CzE2H1SO8sQWWoEyFxLelUc9MzDCjmkccV+iYRHQFAJ3blgq
	 dF25608NJaGJFrUNb09PsQtW5dUI6k11I9Ijk90qLW36hpCLqpH5rNxIzQQ3n6WgY0
	 FB+lguVG3lIfw==
Date: Mon, 28 Sep 2026 10:57:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/6] alloc_tag: clean up the populate failure path
Message-ID: <aro6APF7jwSAvohf@gremlin>
References: <20260915070001.113559-1-hao.ge@linux.dev>
 <20260915070001.113559-3-hao.ge@linux.dev>
 <CAJuCfpHJSwNhgotMVpmjVvdv=m52_7Kvzpztf0WcN0AaoSeGGw@mail.gmail.com>
 <60642a7f-2949-428a-8290-40d69c989a77@linux.dev>
 <CAJuCfpG3d7n=z5WnUQYZsqvrt1pemF8TFvGiGyZGLO7ykVvqAQ@mail.gmail.com>
 <CAJuCfpGeRdFY6UPF-vXxwHvP2+tN=BKgRkmLR3PMLuWhxgzPRA@mail.gmail.com>
 <1dff448c-9cbe-4276-bca1-d91283b0c7b4@linux.dev>
 <b8005c24-ecac-45c4-840a-fd282f9693b5@linux.dev>
 <aq1noAdz9U3tXH_Y@gremlin>
 <aro5L-W-439tTICi@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aro5L-W-439tTICi@milan>
X-Stat-Signature: rzsqdc9qdaxf9n1mfaurypzafbntwanr
X-Rspamd-Queue-Id: 8C3C520004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790589474-182607
X-HE-Meta: U2FsdGVkX1/Gpz6hnb2wdL5NfJ4CmRgb8ykjbKzCMMqzuOtcQVr+XUv4NN2JbgVJxpz3nwtyldRz3wXxfWvKZWvvjjyE1BV5oKCDh2tbwCcC6oFWJ4zvj8XATVxDSpXjQZXza3UpkBxPEADQcFl+FR8Gpz1PH05RjDFvGhfWoCsMwnTcJF7tTxAuQFOlkIOMUAl9aavE2BhngdoY7o93Tzpj1h6vMVqods+HVCEgUzi9x7sTbW1EcIm2LNN07LvA32XHmL89QXs1mecH+gqa5O/MlLFS434goXYbyWL8pAsXTZXyafG7SsIruWw7BMjG3+QJ1PGD6AZu7HSS0CvDhhRjXlYd68VaFxbBCq4Is1887mfGaRhYKYC5YhaDDfhKRzvB0z2OnwZV7U5hD368XFbY/Q3gi/tt3cQ6hQ9GRMVCoO5YfFKBDfq8Jl4CzpK54m1IFNa4OCQHhb1fYT2FGWK2brd+PipBIMxHk55fGiUsg2ZNkmzSmrff/+I8KUHbFQtClT/9MKuEEk8xzJDGiAu70Kxr51WqsXad0mm3WmxddIilVnn3rZVjncnqTOPRqpoquh0fXIj9rxh34BhxgYRPhQrM1UCujUK6XMmadB2CYRo8R0TrQTZlo6e1Kr1SkUh9bbAFrQpzX3DDOlvfa0YsMN/WFs18P1pbV1JIhgF6HThx6xWs+n+2v+BvDrw5IJgEeaw4CXdIxvTWlLSmRGJIuHt9vk5tTS5xUw9lxVaPR3gEZaMeNoQJAgYTXG6IRBiIO4atPAX1hGeeVrW6dmvA0REprzGBPbzaHOH+XSRBoJKIZEvY7hOzWYjBgabZUXOIeFFWARDYFGrIFkVRmf0epphJQbjo+jyKWnfTheQrrQStS4YDd347QRoZ20+uiLZ7vdgZ3ribLWsolEAZEmtA45Iy7KmJ/KKk6L8IMMpaPtxThdbm89P4I9bh2K6nuDk0G66/h3yODKPH+yr
 w9Zz4OJJ
 zuVRtn4MC1Efwx6NDAFJgo5ZDDUYwlHqHUr5IOEvIifyGiuDZx3ER7gmFNxFobJD/I+i6gYVTk4Fo2wEfhAEFpjzhcrM5bfMJlNBSKVWTutuwYTBFc1jrCnM47aTH/Bsj/VSSv2WVPo99XQNM9sr2Cwfuo45Z1caeayTHMIDElD1ohvoHq+UK0GeyL2RnM0ZBn+5+r7Pe5YttLTKEHjbTa2sMWTbvvFtCrHHSO1Lp5n0NbjSJKIAMc3E62gFr9AOGfbQ8padYjNV0DWm0NAC0qHQloUFSEDnSSuLXjLCQa4mCZqW8XGCPWQAMtyXG1dKIKrMK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 11:53:51AM +0200, Uladzislau Rezki wrote:
> On Fri, Sep 18, 2026 at 05:35:02PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Looping in Ulad who is best placed to respond on this.
> >
> > Ulad could you look at the below? Thanks! :)
...
> > I think best person to look at this is Ulad as vmalloc is his baby :)
> >
> > Ulad, what do you think?
> >
> > Thread is at
> > https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/ for
> > context.
> >
> Uh.. I missed this. Let me check!

Thanks! :)

>
> --
> Uladzislau Rezki

--
Cheers, Lorenzo

