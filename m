Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54AD5FEFB6A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47126B0088; Fri, 27 Feb 2026 11:32:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08236B0089; Fri, 27 Feb 2026 11:32:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E7F6B008A; Fri, 27 Feb 2026 11:32:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D31B6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:32:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F2C0BB245
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:32:45 +0000 (UTC)
X-FDA: 84490780290.26.C25B286
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf24.hostedemail.com (Postfix) with ESMTP id 45AB5180006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:32:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=UvJQORvM;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="h DQJW6C";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf24.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.136 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772209963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8o0TeKupqWBpq050X2z2KjPSahNrCwyfHa+2hao158=;
	b=fnMQRyEGerm+xPeVLuLYaIMyiSvmrl3o4Y2GB2FyGoLFtQvA9qAclDUe96ysFgCLFuISRm
	sgr5Cnu/1+ctBf1pSOpfMGY1d2OK22pedBY4RGL9QMwgwB/sywhAwv0yD3xZc4i6LkIA8T
	SPV7lrQ/B/5++lerjzLpSogCFEiJX7I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=UvJQORvM;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="h DQJW6C";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf24.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.136 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772209963; a=rsa-sha256;
	cv=none;
	b=jNr+mww0XK2IWLR51CD8awEOMNpMyIek29FU1P9Baco5FZ0Tp29cH1ss1W6+NXy60Rivgu
	AHMDCRtJlvQy1zxqOqz3NczhqcOYov6EHKkdam12nSC960igRHQVJZa08SJyrm/VNd3eet
	aqa1Yc1N7pyMvqzg+XUgt5o610YkEgE=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 471F51300DDC;
	Fri, 27 Feb 2026 11:32:40 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 27 Feb 2026 11:32:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772209960;
	 x=1772217160; bh=U8o0TeKupqWBpq050X2z2KjPSahNrCwyfHa+2hao158=; b=
	UvJQORvM3WSu1z7xDhvqaxf9hC6sa76YjMz/scZXjdy/L6YljiwPnaTuJ30TFex8
	PNntGEmwaqA+vIv0O+jRj4gyQ4JqJiAsTjaCPr1D9eoxzBb0MdI4dA9c8o/Z5v2S
	Q7gv4UM6c872LJRvs3yM96dYLdxOWYtX0T8q8F/WO51S2yri1/DKv0Rsi/6k4StV
	SJOkAcVzvRHWFuj8vjnWS4vJHiStYc2ycYxTaeRSSSYtEoMXjoX8B8uPGH7gahuN
	Wlz80WBR9iQTvIHWdFYAGZGJtbk21w+DNatLmEZw1qds3V2G/xe8GUqfcxC3fgKg
	fXkztxWj7Y0GgGnzi73A1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772209960; x=
	1772217160; bh=U8o0TeKupqWBpq050X2z2KjPSahNrCwyfHa+2hao158=; b=h
	DQJW6C9ZQsl+cSxSNqXEkYgt1MeeXA/LF+V/Q0vonxd/ZtKg+svWyiVt8Z0aQ9Gb
	oG0Z/DkH/k6F1SsBn4/xRb6V4mz8s20F0k0/F37P0D3aX3UnJAmUZGWONhKWbGHr
	QWgpqzs4CKH2WOJGvtuwZ5MDZGVF0YFNKXQtuIGYlbYDYu5u+xbmjDrbHTQOpYZ+
	JjbPTUa78tPkuJUWrdp9YRAKRCZXuL57/vIzkXCJbPky9cyeiKEwz6BQfcyR5LPy
	ns6iQ0WzaR1UssEeqJpnlymBANVKyhfpBExBaSeb0L6E8p7sLgfPncAbGLZ6auM0
	bwTM1Qb4qg6OGApznwbPw==
X-ME-Sender: <xms:J8ehafZlsZOjc3_GLRFi4h5tWZ_j39o91QnUDyRJrItDzcwi7KraSA>
    <xme:J8ehacD4oLMaXgiufHOx7RuNmUZ2KcT58IQXmnadBxkzX7loWOuT_Faz9z10-R47c
    s_mMj9iSe2a56NsAIHTwW5eXMvsyKiSrrmFI4cRQULuNzzQFJSrFQ>
X-ME-Received: <xmr:J8ehaXgvfUMoIDFx1-N0_S2LZI5xIUBVR4hia4g9tz0jTB1PQar5sxgb1Zw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelgeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeeftdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeegkeejhedvtdelledvvdekuefgieelgeeuleevhffghffggffhjefhfeeh
    ueffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepgeeipdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopegumhgrthhlrggtkhesghhoohhglhgvrdgtohhmpd
    hrtghpthhtohephhgvlhhgrggrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghj
    rgihrggthhgrnhgurhgrsehnvhhiughirgdrtghomhdprhgtphhtthhopehgrhgrfhesrg
    hmrgiiohhnrdgtohhmpdhrtghpthhtoheprghmrghsthhrohesfhgsrdgtohhmpdhrtghp
    thhtoheprghpohhpphhlvgesnhhvihguihgrrdgtohhmpdhrtghpthhtoheprghkphhmse
    hlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrnhhkihhtrges
    nhhvihguihgrrdgtohhmpdhrtghpthhtohepsghhvghlghgrrghssehgohhoghhlvgdrtg
    homh
X-ME-Proxy: <xmx:J8ehaZQZcL6lZPF1tlS2vXNQrO4J8CAoDaz7yWMPTyzWglyUwjBO5g>
    <xmx:J8ehaZsrct2tN8zKyTrWREhB4jzHQ_Fv2oAmSJc4BikE_AF4Xj42xg>
    <xmx:J8ehaT_vdDuQ_DgLxEW0346_iNl-iCv0_xBOZodxKDVm2Tf1CiGErw>
    <xmx:J8ehaVYG6UTWYipiljkmMYLzXh80DAKiM45iJealDLXXbTVMK8PklA>
    <xmx:KMehaZfMe4KUyMFYKfHfXG7vObZA_yiAuEBY2xndXJSajNdx2KREBiW2>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 11:32:35 -0500 (EST)
Date: Fri, 27 Feb 2026 09:32:33 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
 kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
 Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Lukas Wunner <lukas@wunner.de>,
 =?UTF-8?B?TWlj?= =?UTF-8?B?aGHFgg==?= Winiarski
 <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>,
 Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?= <thomas.hellstrom@linux.intel.com>,
 Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Zhu Yanjun <yanjun.zhu@linux.dev>, alex@shazbot.org
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <20260227093233.45891424@shazbot.org>
In-Reply-To: <aZ-TrC8P0tLYhxXO@google.com>
References: <20260129212510.967611-3-dmatlack@google.com>
	<20260225224651.GA3711085@bhelgaas>
	<aZ-TrC8P0tLYhxXO@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 45AB5180006
X-Stat-Signature: 5y9rj31aftmzxj5xj7kb3gy4mot9hnr1
X-Rspam-User: 
X-HE-Tag: 1772209963-965940
X-HE-Meta: U2FsdGVkX19oWPvRwDjmlh59TtxDK4DMQY5RvgDN3TEe5KzDivmNLkgDmd+3ZVsvt39hE2H9HJfmts082YeLaU9+jvxyDgISUzfI+mCXqZhbKhVrdKpYCciUVnQt9x446eRUemZg7u//mLe3gvaspq4bPEtxnh+qjPc5+t1vaPaF6JXxO/Uz01v1KcFpPGHsXVI86Vl5eGzO6rEZaIsTOZA58xqj2bRpgJ3krlO0zdU8Qf6yBQVsk48tS4GwqrjHEfnMsbdDi9+d68CdIqJQFQZ5G0Opbrjw/avl2aDUvC3poUwAo2AwHBc9Keffoydnx4ckS8SoXVDTWJKp75yhrYm/0XfEsaAAHr5Mn7HVKt4WEoXK9Q22A01wqwVqBKB9sBepaNUl0aKO/R3MDtgQQIXx2eKXWsuzXxpkRwWw/1m/7ZMSmZ1o0VbvwUDLnOSF1brQjmsVovHGI2b879U2G2fAx+e4vX/luL/4lnMwO7UN/E7PtRzegUri/z6hK4DgObye05PWSt//0TPKYG+Pm50/zhU2LvdBBXz6mSPAvWCj3GW6cs0x/7Jl7cAya7AjVv8QV6PBRHs07FNxO9mFh9gfXc3dDHW37D3vhVek/P+1PhGoEflkAl7zek3VvqdMArdVdcl2oOsbLYT3ixVS9/XZrxf0L1ROD38zVWZFYisrsb5M0v3FFmXT3zgsMZKmDb7QKneUfBEWnvTQQW9Q/1MDvZXGNfWbXOpamY+ky++O8HbHtmAOMBY8YDe7NsZ7DtVTgHBym7F255BI125QmxB1m6td+YH0Es+VT+BdKOHz//uPtDklrzwzAUWPdwhgsLcmjRLFrJrhcdyhal15zEPmUqSkGKdtNIzNdhduBsFmsvGbu82L5N5B2W3OGoXdcU/x5IG0L7odXuzE1DT+Wy014SwhAkgCT2QtdZlNL4FGODFF7lzbONzXs2wfLZuWsQL6K4B2ANq0PrbDgKW
 1V2YpDnG
 Blg889AX5MdgjQl3dckB3MBep2pZaknMmclrkpam5AOwyRcAKiv4I7Fc5K26Nt6On6IgQB3OEwMPXYzkCK/V2AN99SQpGqiHhC4dCCH+9FoCIc7xbe9SMSoUeRcwQZFAD7jOVhFCcX6FMVeAGyq9eid1X0zsxlHRjGRTXYoayC9ktItlcfARevsq99Xty6xIHehYLfbJ1FiQZSZA4/z/0aeK82Omh0qWGSP7XZBevy0R/kUiIOhUzsfCJXOiQ7KrczJztblYKXuHqSM0mEFhVGsNt7F6MyYKaRmAAeGlnnZUKhabUfC0d6f5oMWJn1H/4tXgqXHC1jqIH/YFtU4eGpt3OrREVBkkAaRHW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 00:28:28 +0000
David Matlack <dmatlack@google.com> wrote:
> > > +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> > > +{
> > > +	struct pci_dev *dev = NULL;
> > > +	int max_nr_devices = 0;
> > > +	struct pci_ser *ser;
> > > +	unsigned long size;
> > > +
> > > +	for_each_pci_dev(dev)
> > > +		max_nr_devices++;  
> > 
> > How is this protected against hotplug?  
> 
> Pranjal raised this as well. Here was my reply:
> 
> .  Yes, it's possible to run out space to preserve devices if devices are
> .  hot-plugged and then preserved. But I think it's better to defer
> .  handling such a use-case exists (unless you see an obvious simple
> .  solution). So far I am not seeing preserving hot-plugged devices
> .  across Live Update as a high priority use-case to support.
> 
> I am going to add a comment here in the next revision to clarify that.
> I will also add a comment clarifying why this code doesn't bother to
> account for VFs created after this call (preserving VFs are explicitly
> disallowed to be preserved in this patch since they require additional
> support).

TBH, without SR-IOV support and some examples of in-kernel PF
preservation in support of vfio-pci VFs, it seems like this only
supports a very niche use case.  I expect the majority of vfio-pci
devices are VFs and I don't think we want to present a solution where
the requirement is to move the PF driver to userspace.  It's not clear,
for example, how we can have vfio-pci variant drivers relying on
in-kernel channels to PF drivers to support migration in this model.
Thanks,

Alex

