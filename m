Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6430EC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 11:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9746B008C; Wed,  9 Sep 2026 07:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B11B6B0092; Wed,  9 Sep 2026 07:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0756B0093; Wed,  9 Sep 2026 07:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24A296B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:18:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53EE9C013D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:18:14 +0000 (UTC)
X-FDA: 85193974908.27.49D9B5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B4E7840007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:18:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FYEQtAN5;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788952692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zOEjwSnsDLGfG/pdeBNOVWeruweXwfJsxl7v7zv3/yY=;
	b=jejA0xLmoraX1OXpJCblFALYbMXaE93xemxG3gkbiiHrpWS1WL8M3wM/SkgEXVXNzpqjr/
	twBS3/ciKNDO/qqwqZoaLFAUTF9ltbSOh/sVrb20c5m34vN9EG12EdpUrm5PpUakmQjEw2
	+J3bkkEdtZKSx8sZPrhWQne88ZZGxa4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788952692;
	b=jmaGlAtlBjs/snNNvgAdkVQRi+X3XkQf1j6spJ44yHFmBsZ8E07eI31rd2zbXEEBrONyhJ
	ODNbB98zGQ3aFI51lO3CYyFk3E3oNW2vz3kydWyE7dq5uRyNoKHMRn0cPWfS5mVPfKg3gj
	lxXeU/vJyKmYq7GqtQfNxuMEZfOtIiM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FYEQtAN5;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D5E95439AD;
	Wed,  9 Sep 2026 11:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58591F00A3A;
	Wed,  9 Sep 2026 11:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788952691;
	bh=zOEjwSnsDLGfG/pdeBNOVWeruweXwfJsxl7v7zv3/yY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FYEQtAN5KmjTi1SPWjCLNXNqio0wiGEDLX4TLQjBVpZfHG7P1KfnyXuYvshcFpa1S
	 B88U316k4f8BizNr3hFSBOxDd8cJZr6XPwT9l9/0v3VCoc4OHM6bNxB42X0HwTPkTX
	 Z0JhFCO2OTJ653bQH13UfQn9EEIXrjHMqV3g+ZwMLnG3vNsnOwSI2RhmpSi7bayd80
	 0Aj3rIGzOj7DqyKVvq9owikr+ZgBTi6Uglul2byZHt29aUPqYs5DAjbzfO1ULdk4nW
	 BW+Z1xwRgM+Be/vH8ixBWG1Dp0FaNGtcrS+ixLXtXwzbMyOK0sBQn39/QlaVyFovYw
	 XmfmFxwOK8ycw==
Date: Wed, 9 Sep 2026 12:18:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Nimrod Oren <noren@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <aqFAOLrybtyo6dd1@gremlin>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@kernel.org>
 <DL9XL8T6UG93.1T1NSJMI8PISK@nvidia.com>
 <aqBiVp405v2srvSa@cmpxchg.org>
 <aqEUdmYnnQQRC8yl@gremlin>
 <20260909113836.6cbe8d17@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909113836.6cbe8d17@pumpkin>
X-Stat-Signature: x6bbpp38e5yxf6q6czhwrnxkht11udan
X-Rspam-User: 
X-Rspamd-Queue-Id: B4E7840007
X-Rspamd-Server: rspam03
X-HE-Tag: 1788952692-510903
X-HE-Meta: U2FsdGVkX1+RDdtmKhYMaZV3pubyCoMSXTs3fiwDGSMKUq3oc+ewzsVWTDZj/3xgSor5GDiGyDfcUSG7bCK1Pf0+oH7dHDp4ypvdyFFwTmYGB/Ra7C9G/nA6VHkxxQEYjJFmC6ddAGeT8O0kMTIZJrTC/j4Dx80BF1jvmGE0JcT8HHe8xF47K/ol9w306Q8ojIIHUgMradhNY+TwJmXVe9/3ntdYCj8Zrc0jc6c230Vt9JjT8n/bUfEP7yWJTVrZAf9QXbi0uRwFD1c0+RsNo7E5IW6u4PK7XiB4DQlHPyVf8IbvvzLApEKmtrALad3R8CVbv98NhXIkPRSJiNy3s7V+Lb/hAv0eX8eIeKp5/BXc2I0NeFoyUV7F8QDY/Ywf5gXHMI0oIYiN3y6D/+Xc6AvTkQ6/dtJ2OTdvnpoCdvsNpPrja6WdUGhxg+daxDz3D8+iAmcHBPLE6Zj4q0tO1IFznKpAe3X6P/Y6ZmuwWJnHZPKdobq2Mn9YxUWecpi6sz/Bh3GSMvOlx2Qv/Z8WDdgiR3MYBDj18Sq7+0EX6DehbnR92sTAePs/Ik1hWfAqkjg0pv7OwY6cOSThkNX0BCkZEPdi5LpmZ5kyCgDHtMO6oaShv7Ynn9GejePxWvqd7u3Id9KI9ySsrGJ24Pm15qb1PwOp2Y/xVSUXZN4TAyFRlJR/Q+dkQHpt0twOhGxNqLdCZCluSWeUtDRRjpFPtCAdc734O6KhvyFeyQ2SnsCT+mKK4WFEjAI42ufShX6n3tslE9XEcLjpyHg41/O/mPjEILHLUx6Is1Obj7eizCgKuGtX6Z6/6MXe82uDZsCaqv4mtZ9qZFpkK6GNtRoCYAjsBIlrvABE+qwV7uuKUlpRVrIc5rdp+pKkPqZ+d9Fdw+gPcGkn+xiZgOmr/ayaPO8BoMLSF8ugDz+FEUAZCwjQRbQXwZzWLAZQoDxbpQB9m5cDE099GwgL2ssYdqM
 RcI5DB6o
 9UcjvBlMH0J1I+SdxmGtWB7MDKVEgXrQABjfVcYHTtPh6A/CHmnVrwKNmzxtmwrRnKY10qPM/poFNIsugoAKzRH1I5jxvRAKMr19SKRtsvfkRuvRXOEAjiXTMIILp3iBxhLtV9NwxC0gM+bmb5ECZanSTrbKExvxe9U97d1WXzuYouOX1sfCXNtJDLP982iEROoZIo2myZG7HQPIEG5JX8HcxELEippwJWtAPx/4/QbLBWZN5+66RQyAmw46oeP3pMW1NE9YKoUIo5Z9n6I5DFph+qqLgwngUd+hOW+I+u1VAWFIkphdlB7sd4z1qEk0E0gGhS+Gfj+Mm++uxIl/K2jT3WnTaE8RSvJs7Sjphtcrj3tZzUK/vCT55yYqOPVLS104f/0LgQf7Xn98pw+HIamzWOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 11:38:36AM +0100, David Laight wrote:
> On Wed, 9 Sep 2026 09:11:04 +0100
> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > On Tue, Sep 08, 2026 at 03:30:30PM -0400, Johannes Weiner wrote:
> > > On Tue, Sep 08, 2026 at 08:24:38AM -0400, Zi Yan wrote:
> > > > On Tue Sep 8, 2026 at 7:54 AM EDT, Vlastimil Babka (SUSE) wrote:
> > > > > Given neither of the patchset versions achieved universal acceptance, could
> > > > > we try just disabling all the automatic (re)calculations of min_free_kbytes
> > > > > the first moment the sysctl gets adjusted from userspace?
> > > >
> > > > Sounds good to me. Johannes, WDYT?
> > >
> > > +1 That sounds good to me as well.
> >
> > Me also! :>)
>
> You might want some method of restoring the default behaviour.
> Maybe setting to 0 can be used (if that is just silly).

I suppose the concern would be an embedded user for some reason enabling
CONFIG_TRANSPARENT_HUGEPAGE and then defaulting to THP ->madvise and getting the
bigger reserves before somehow disabling it after boot.

But I'm not sure if this is something we really need to worry about?

>
> David
>
> >
> > --
> > Cheers, Lorenzo
> >
>

--
Cheers, Lorenzo

