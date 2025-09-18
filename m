Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECAB8CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 535D58E011B; Thu, 18 Sep 2025 09:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CF18E0112; Thu, 18 Sep 2025 09:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44A528E011B; Thu, 18 Sep 2025 09:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 279DB8E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:34:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E7E101A01E1
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:34:47 +0000 (UTC)
X-FDA: 83902466214.23.B19FEE3
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by imf21.hostedemail.com (Postfix) with ESMTP id 950B71C000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:34:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=lunn.ch header.s=20171124 header.b=mffiEw3N;
	spf=pass (imf21.hostedemail.com: domain of andrew@lunn.ch designates 156.67.10.101 as permitted sender) smtp.mailfrom=andrew@lunn.ch;
	dmarc=pass (policy=none) header.from=lunn.ch
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758202486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2WK7RF7NsYG+8NsyTTvySh7GNGT5jm6UcDa778flAEQ=;
	b=LprMH17t5ffUEmKdm3i1HMQuwoSdjiuR5Idgyyb0GPl/zTEawLvSkB6HZwFErqSmIo0kxV
	HOLdZRQNiq8q9zFTiJoXhZqJEB+IObzs38NKibmkuJJkZBC7giM2rFjzo5vnX+IMnmq47v
	xO600iCH5og/v80dbcMHMNgKd/5GKqA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=lunn.ch header.s=20171124 header.b=mffiEw3N;
	spf=pass (imf21.hostedemail.com: domain of andrew@lunn.ch designates 156.67.10.101 as permitted sender) smtp.mailfrom=andrew@lunn.ch;
	dmarc=pass (policy=none) header.from=lunn.ch
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758202486; a=rsa-sha256;
	cv=none;
	b=KzKG8PTQhdRTLIBPnt3sU2Cpn30VQXLRfztzMLZOq+TfmhtVhZyl7XambdXWNFesKjfke/
	oTTZhEOgyzojgKJMenDnLcd4pKzWjdBM8rMa19upTIh+RjHPGJJEteazK+OW8sL4CL4eTO
	5q3PM0V0FbxuP6pG5zc15eSTrKPazPY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=2WK7RF7NsYG+8NsyTTvySh7GNGT5jm6UcDa778flAEQ=; b=mffiEw3N0Xsy0iehgYkPk5d+dg
	sWKIhv5XK/zUNW+x7cpwzMKn+fWVigxBkekrLwF/YIOd76oce1YtRzHGNOghxSvsx4TZKrO8BB5yX
	oA6G/OA6kjESeDYNowdA/HoKupolfgZZgm9ZJ1RTWZMa7p8eDc9puB5qodRd9gcxhoms=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1uzEmL-008pSt-MZ; Thu, 18 Sep 2025 15:34:29 +0200
Date: Thu, 18 Sep 2025 15:34:29 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>, ksummit@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, imx@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Richard Weinberger <richard@nod.at>,
	Lucas Stach <l.stach@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
	Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Andreas Larsson <andreas@gaisler.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Message-ID: <ca6fc8dc-d1ee-41a8-a1c9-11ed2907207f@lunn.ch>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <20250917125951.GA1390993@nvidia.com>
 <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
X-Rspamd-Queue-Id: 950B71C000A
X-Rspamd-Server: rspam05
X-Stat-Signature: m8hu6j5i948frogauqcpe6nrbwd86ui5
X-Rspam-User: 
X-HE-Tag: 1758202485-35102
X-HE-Meta: U2FsdGVkX19/F50QU9rY/W+VvEgChkmza0zrUOsnyOl3Cm/bMCy58ZA+PV3oA5A5Mj6hPkzR6COD0ix5b2nPBkm+FNkdCPADNPZ2xDW8u/U9dErTjd+peWPEL9WXW7un4bpEqK01YkNpS/YixlSIHaWfPPUUlQwTVv2Le84EyADUMpXvVXLP9aPid2NgaAok2/0y0Sq8xaqZ5KhJYKRmxEmdVmQPE1TOTCxW/eQHV9OVpnu2IRukMgemrQmX1LL/OvmtwHIZr/ZJ6cvEePYikPT45IIpopqf+b4MfhfGZPwg/QINyjKzmfFyTSZV+n5ZWB7/PMRLWWRc07x3eb7ULbxv3MphBcBfAd3S0BZdxI6JlZJHxk9zNcNcNtDkoDr1vbv3cqG+TLP98IxBMu/3b1XAnuZT+Kw0Ua+e+pF93t9wFEINIX3CcTxZCMdt2Axl95emCdCn1Ymjzbr9MBbW2qKasjoDKuhR14hD42uJRKXCd3KhXRr8OCBhW8gyKap6ykpd3zcs9K68+WwdnXNFgCliG96iYyKbQGINo5nZLCh4FAbYz5eym7KkxECNwgcRHipcMjMrbVrmMBq+fEOrfSUxrMqVwTXu5zAV3SsG5dHZwE2oU3rqyXju93rcdEJ6KHLJ7xCYrUBZtyz3Rp4d32I+JINdjh7h4F9MKMldI+JILwSk/f3f8w/2MwigTey9/KazcjXVQOjM4W+e5BlBiFWp9DBSEvDzHlR0lpxLYoH5gluzgs7SkCEeEutKGvxdkhdRDYbkEA1RJ7zei2HbBiEna8IKIVPzWYWTEEVBL9ro3SaoYxWbf9mwG/A36Qykee04gOcbMVdsvVSKj05feArRl6SBdc3eGy8qS6jG0h9UhwEeJyPt+sOORYQ7TojA0WF8r3oCao2McPsXDpe6TSa9E2PGlq+XPB+u8O5I0hiSn14pzeXNi8Wmxb+Cms7PahGJPimTnnx5iTB+gf4
 DkIGJCCc
 XIY6M/SzkFa5ptCjjH9zaHI38COcr8ZdX5GGO73mIxQ7SbgV/gNSx/qFuAGZGfZgtfuSbERFCaIwLPvBbODRwXGoPHWdlblj7h7vRKODPYlULxmEg/vuXYOI/1jyVUTnDm1bFW8Fo3cLZQv36o19o3MGBQ/AwOHxhWvYzjqBmXq6211cvqofvm8JjCbHX4ddDR9kb7MBy42YtxdkrLgMrd/7nfPAavsIO42BHp3x3c8rlruCZBI7Crw70aSTCFLw5hmkPcFbcBLPpf7paKk6rAv+oII92+dqs294VS6Mhmvhn9uXXwpMvl6mjGom+HkkjXbtjBtHzRbeiwqw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> * Marvell mv78xx0 and kirkwood (armv5 pj1) were fairly
>   powerful in 2008 and could support at least 1GB of RAM,
>   but I only found one machine (OpenBlocks A7) that does
>   this. It's unclear if anyone is still updating kernels
>   on this machine, but they could /probably/ use
>   VMSPLIT_3G_OPT if they do.

If i remember correctly, there was a design issue with the OpenBlocks
A7, and it would not run with its full amount of memory. To get a
stable system you had to limit the RAM. I don't remember if that was
just with the NULL series, and it was fixed for mass production
devices, or they are all broken.

I doubt there are any mv78xx0 machines left, why where never very
popular, but there are still Kirkwood NAS boxes around. I keep mine up
to date, put an LTS kernel on it once a year, update to the latest
debian sid.

	Andrew

