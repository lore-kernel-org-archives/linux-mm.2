Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9F5DCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 13:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0ED28E000C; Fri, 12 Sep 2025 09:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF998E0002; Fri, 12 Sep 2025 09:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5698E000C; Fri, 12 Sep 2025 09:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA308E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 376A485C05
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:17:07 +0000 (UTC)
X-FDA: 83880648894.28.31C3349
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7C1001C0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:17:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=V7hbJdPn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757683025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1QwMEVkzC77rV7TEVB4ZQxwruyo9VsaKM2Zj3Ph0wQ=;
	b=Ag7XWTJGzBnflIeVFhRAyyOxOYkfsAOykRWV8yXv2dIkxO70toXjgI344ClhRggTVfKK2D
	dRGQvKQrCLq6EUW2qcBXkfC/H2GrXswG4wJKwwzDWfzJlheTCAAJ6M2Hkq9/4MZAmWrMDi
	PiKhgWpEbQ33XWq+WA5nMyxVCCV+BWU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=V7hbJdPn;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757683025; a=rsa-sha256;
	cv=none;
	b=qJ2VAc8ukJZc2UmxAbW/HtGwOL/Oxe2b+sDQftnxsiAL0ztRIzJM2wiyrhy+tw/sf5Y2co
	VWuvPxlKO+ssBZfT0txNpycT6VIy+A5GcUkYN3Jfjow/GdH3mjbWT3VJb1/wg7TziWWKiL
	QBY3dRsi1mhj+g5K9Hst30lrrAGSY/I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O1QwMEVkzC77rV7TEVB4ZQxwruyo9VsaKM2Zj3Ph0wQ=; b=V7hbJdPnNgBvGak31eOz58Mf1P
	otiV4vFRfmengjQC3i3FF81bSu7SfBAe1eqxiJzNTi1R4gLaN8u0wpffGkz1JpY9jt3Yom4hqcBia
	EH96uZOoSoxiTz2Zj9io0vk5m2EHlsDzoA0vREw85DvJq2B06EH11KXlog8cNmVcJCJG39zhOd8bH
	mw/2V1agjKxuu9Vbd/bpA2oQZ2D7UqzEV3AGXt9sdRGaY3X9Wj3XwpXZotScYIF+ba+xeGTIUi/TN
	VO8oGIY/qzBSbT23U9PZt7aVPiRKyyRiP8iuAoGvZoxA6fv7XIBlghM+z0k6GaIFOdVxXRMVL3YMB
	LcM8h7vA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ux3e1-0000000GJeP-3Q7n;
	Fri, 12 Sep 2025 13:16:53 +0000
Date: Fri, 12 Sep 2025 14:16:53 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>,
	ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Richard Weinberger <richard@nod.at>,
	Lucas Stach <l.stach@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
	Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Message-ID: <aMQdRfcMGGZQrW1_@casper.infradead.org>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <5d2fec2b-8e59-417e-b9e6-12c6e27dd5f0@gaisler.com>
 <E986779F-C7AA-4940-9508-08601EE2FDD0@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E986779F-C7AA-4940-9508-08601EE2FDD0@zytor.com>
X-Rspamd-Queue-Id: 7C1001C0006
X-Rspamd-Server: rspam05
X-Stat-Signature: a4tpbkmkmzyrbbwejwcw5krs5njikow1
X-Rspam-User: 
X-HE-Tag: 1757683023-959392
X-HE-Meta: U2FsdGVkX18HgTGKlClZz1eYGHm3lqsMGIa04eWNVSzxwUrFidzbzByHcd1NQ+SIm4sOgG1u/A7sVWDnDiIKmgk3Yc5Gi8yni6GiQCubTHy79r8/BBlzg50YphEf6VqNi8lTlL/knz+fwJYZrh4ZN1x5B4VGDEZNvPKAQX2uHD7YVwyc8jWn6ir/gkYmN9lJPZHN1xF8zlAG2sUxusn9Rux4NmJO62JAgWdO2c4LErWHd9N1QyTLJ8MW2qFfq43VhVBfwOMZ3VLTomBLYbWTNUYqqj9426caBP1gRRZIkU7KZ8GuE3BaBW8KsuM9OwILQDbRaVSvvf+XNTOJbODhkSbaHPv7zlzn/2fIyY7/ioFnRwYiZPySwoh3RWef3+VjfRgBe08Hy8mOiGmgYQ1xI5mZygvt2OPSyD3HPtZAyH3ji7Tr/tIgkP31sv0oGbkPuWOLrNmkZmb54nYLqSgHR4G9cryzAIjF0gD4yi21nJQCH0/cUzKiQZvUYq20e8SjbMY56q8mRxPu9VsoKoXBKzQdb7xgwvY9IMcUTyVEQQvUTCgui9ZuaYO4gcg1DGN1P994AbbQmDoarKIUsTyVx/LyQgGhYn4XgHRJu4MtDmII+8SNulRB6d43kioy6UaW1iL/Gw3PUw1w99l30/cHkWQbKV9ZA/Feew8LiQINpqG7qwXf4X3AdhvxHF1Lw3oNL3lyStv8/xLIR5oxvBcgLqa4ZRT+8tUooYSEZT+NTGhM9k/1XGJZKAyzcyyotA7qVW7ZawYAOMtUi1Phz6YUzYpfJ1TONOhsS3V/s20rLY0CmcKkE/cKLh3HLnkN0RYqYbPnVGME36t5MFGB3lqWArerdpy1hJWti+SYyAm5Ye8pKHMdSv2a9UB5IPjOPUshBV9U0yQRj4oCQ02J0vNsq5btMlGDm18uA8HHiVMHBp3H1tZJdXrUXsr/U30DMZCL5Qo9SgTjzff5Rxo3DtX
 fuAZgAZT
 ZNdyryQNvvFjqKKjd3GQ8y5W9RKljjutJgXVF+3gPlq5qqsuq7ZyM5PzXh2vBm4R/NspOYnm7H3sll5sRaNyZXTXe1fnjmAb9NBESlsEk44repzFVniTimChydFJcr8bT4nR+qv9GF30xPwlOe/YrxfCP+4FQpSXVm6rw38iNIgUZbko2l5g015IoZ6uXEnfN7YJ1psYWT9vIeIowK9DymuxFT45XMeLFl4P1jSmDVRGUlAde7M8O13OcDb0UfJHGCBEDinKtSgxQ/CY2dF/hcp2ltJC/TeCn5NoY+bmIEIokL6jzz071BzwI817eS4laQFyTQ5q20KYMyI2oawVC773QEecxBJnJfX+uX/Fg+tHCtUg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 02:58:48AM -0700, H. Peter Anvin wrote:
> On September 10, 2025 10:38:15 PM PDT, Andreas Larsson <andreas@gaisler.com> wrote:
> >We have a upcoming SoC with support for up to 16 GiB of DRAM. When that is
> >used in LEON sparc32 configuration (using 36-bit physical addressing), a
> >removed CONFIG_HIGHMEM would be a considerable limitation, even after an
> >introduction of different CONFIG_VMSPLIT_* options for sparc32.
> 
> It really sounds like a self-inflicted problem... getting your customers switched over to the RV64 side is probably the best you can do for them.


"We only support configurations above 4GB when using the RV64 core".

