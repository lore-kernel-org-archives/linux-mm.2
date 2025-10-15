Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EAB4CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65B28E0014; Wed, 15 Oct 2025 08:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D048E0002; Wed, 15 Oct 2025 08:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A528D8E0014; Wed, 15 Oct 2025 08:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8EA9A8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:09:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D43B115DC5
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:09:42 +0000 (UTC)
X-FDA: 84000229404.30.FF352EE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id EBE4820009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:09:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fXrwPuT6
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760530180; a=rsa-sha256;
	cv=none;
	b=KshV3fC0lp1nFKQvoeVlYTNkXmmnGGewj4RzvRPuv64XDw5dj54JP/wquim/Uv2UVl70A6
	dnL9V+SolHmsT6U3Kh1EecxmBVvNLNTpEn5OQcVNGMxfVneqIJkgmTeix81XKj5i7ZzSWe
	2D0TuNPjvTBHfhWk1RXrr+6Kdk5RjEY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fXrwPuT6;
	dmarc=none;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760530180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9Fjl7F3VFzXC0O48M5wncgrl7psHc5HnBqdo1yCEm8=;
	b=5dqfs4/LFRMv5DD67AygK00yuW7ADCDKmd+7M3gyfQedjZxpytIIYu2511WWMqiTBnXzHQ
	yIx9DEpfbt0jfue677SXBNHyt1pdO+5N7zSFaXX3o1dMJXd7o3Q+oumLzzZIrpWfRhXp9Q
	WXFBjVhoBZf5D+d9tzWoFYpF6py8W6A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f9Fjl7F3VFzXC0O48M5wncgrl7psHc5HnBqdo1yCEm8=; b=fXrwPuT6D6NXjiEVl+QjBGjMhZ
	AS1I9IN66rWe6YhNQDOmQ0rvfm8FzszVFXWhrLrz5IbriMPLxINEhtc5OimwSOCU5tzWqQ03V+IBP
	F8OtuPSePY4QAxn9qo80PEAEZDZhO/+k6sHLjEfz4V3CG1wKodBvYTB5HiL4JarqvdRDE7OfJUfmt
	qQaUOj+87E62ZC/sDwzNNjQVEu30qM2/bwdCDYsUzvSEebjJ9pFtqASBfSeAoyPQ3kLecj3amW0JF
	0vgv7kuKoIH/k/hgcBhBFYP1UhHTeypycpIPuk0gyN3vM6N+h8+yfb3ypwP3zvjaI7fZpAppYRvox
	ztMLJw8A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v90Jz-0000000Elb2-34Jb;
	Wed, 15 Oct 2025 12:09:35 +0000
Date: Wed, 15 Oct 2025 13:09:35 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Guo Ren <guoren@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-csky@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] csky/mm: fix build errors cause by folio flags changes
Message-ID: <aO-O_2lhxZ8I78cl@casper.infradead.org>
References: <20251015064759.2993842-1-rppt@kernel.org>
 <CAJF2gTTgG2DhqLC2B6URsNusjzcwCaxi-k=MUZTc1FTEHbaf+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJF2gTTgG2DhqLC2B6URsNusjzcwCaxi-k=MUZTc1FTEHbaf+g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EBE4820009
X-Stat-Signature: jtkkn3e43o1q97n3rx9rek9yf7ahx3ic
X-HE-Tag: 1760530178-195006
X-HE-Meta: U2FsdGVkX18wCCF2P99n1BkRRCJvD9lbEgQBwZ+9Ba3jNXLfx8EB+SUKUU3h2JzuAgHua2Lw+/Xllvqks3Vvom2qAxa1uzL9GOG6wxDRFYaPwvPKBMNiXPW2bh6IOMvYT2KxS9dcUPpt5vfBJ6dRFOLbF6TukvmdD/ckzezxP3Aygxhn5mDOJVkN6U63UN6MmYZycOtkAkT0ZuwVgVhh3r3/rSBpLIsEBil9ecnmAvodhk6u08iWdeirXYAukuATaLvDYeENhMddxxq9nDfofLyf2+XFZXwy7Wdx42Xkw3vA/6JtWy7ZzIyggozKQZSWmYDix1yYt9ayXT1J5lhBngrEtBOenq9NVHeHlijkYLykQNMGGkdeqeYyfCqSUAxQ5tCgtiHHoX0P45uAHKw3RCI9K+MyUbe5HxbrJ3NQprNxQ9myBMagw41xpuzMq3KQ4U36u7SAajGV26DIJDB6Dye3K02SUQVznSoepVFmvu8rN7e3lsuUaA8tEstMX5K/2d9Grt3e2AL5D96b/38l6rVvH+CLQinpx2MOx98x9BM/CfTnHD36nVnzup8l6f3d/tLYek+e6RkCozhCauSw8zemD0cDbxhndJg/ModiCHoYy2sFe9Be5SaiA5Z8oNGiyoL27XGLcu16oL2m/LPRaaP+Q+A55rOGEsa4JykfCnaC4anY96qoicSPReZ8FupfBapkWUlVVdXHngcRH03sW5my387DXiNzXVIO9T7jVRcRW4c1SH4smU8+RgnwaVHBhW37mnDhIBxB9YJaasqmH/KqpQRPw7GdIYg6ixCT44SosMGqrtBYbPnJPuZ2V6hHDp89pGw3LUAo08zarkZIrTcIkgE4qDW/tUR2umb4W6agi+9NQlk0Kh/v18Oz+24yeBYQXNfNNsrewv0CDrAGnREzNaTIY7kizAOKCYmzICs7woTN+mTcqjTyoFZU8PcB/z2o0c1S0mFQjUFb6AL
 nQ/m7gMN
 4DfPEG/hqBieJnsxORWEd5h3CYBjZd1/D7ct2Wanvx4zvUG3HjwExS0EBlgF11GisS/YFcvq6HrHOwN1Pdaf1BOB8wH+2LSfSD8MHQbMRhYuL2nWLWXXRr8GEbAz0m2VNWvcYVBJJAae42gZk2W6QrQRqupd+Lf65MLeoI44lyfY8e28ra0k7zzNDUUNgw1WiJtBCkBeD0njr13rJZVLdNt7KBF7am8+jlqVOjK/lGEm/0HxDunnUTHvFX3iEJHUnGFFa15n9CJThjLM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 03:51:53PM +0800, Guo Ren wrote:
> Thanks for the fixup. If you want to go through your tree, please add the tag:
> Acked-by: Guo Ren <guoren@kernel.org>

Why haven't you merged the original patch from October 6th?

Message-Id: <20251006-csky-folio-flags-v1-1-a91dcbdbf988@linutronix.de>


