Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB623CF65D5
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 10:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FCE06B0088; Mon, 26 Jan 2026 05:52:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA396B0089; Mon, 26 Jan 2026 05:52:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AC6F6B008A; Mon, 26 Jan 2026 05:52:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 772756B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:52:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E37E8ACE2
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:52:17 +0000 (UTC)
X-FDA: 84373800714.18.E3F2232
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id BAFE3180005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:52:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=FoeaBPY0
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769424736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOwl1LOtoKU5/PoRXFyQSq1478e5eRvje0/beAymu74=;
	b=xL/utqFnqmHR/Va884m8ExZiR8n9asAEJGA7lF8jOr5DWUUW4l6iIliYROeQpg1iFO/7Bd
	UusvmF3AxmnTkVUEevDG3gCf8sxlON7TEovXidL4+pcus369QXiYCtFFlnoqCR11H9EU9d
	ApJjbADkyu3FC3wr5uPBGoePdpmU1aw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=FoeaBPY0;
	spf=none (imf16.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769424736; a=rsa-sha256;
	cv=none;
	b=lKqFungcn1HQpoUIxq9H8hZB3D6fYEyK7qWjdMy70g+uqwvKr8/3usdjJG/G9w/XBG5zHy
	JiKF65c7kicnI86P13rg1cmHXwXZvIyyjdPrvb2Jyyes3GCoJZVH2t5hLlwpWvfa/v3oVh
	BZfOk4RnIBuMp9p19scBQ9Do4ELnBCs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JOwl1LOtoKU5/PoRXFyQSq1478e5eRvje0/beAymu74=; b=FoeaBPY0sUru0rq2ib8j3XoHP0
	jLisWlOIFORxUfmSwSfaBPksTO0/3iVT4cjfhskdL07owgh01DLsc9Vxkf8bEnYpffwyo7XjcMyfV
	LoXFCdyb2d/U03jgFLE6O/Pdnffd91i9BOd3NM0vnV7E1EoHsFeMFyqUDX5kAx5xC6ncJWcd6Cq7b
	wY38oXTrfyD0C1tJujuVRBPeOgbCDNdeONtJ8frbYHDDRQLthI38YiqGTcN4K457qBhgb1Cv8qy4K
	D9R84n7FKPlZZH813+eIw70MV1hqEOcLPZ92rcv4OZF2x/FE5lWDAQpQ3Dp/vi+7Y4hew5+/pCG5r
	M2foYQNQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkKCR-00G7ie-Sd; Mon, 26 Jan 2026 10:52:04 +0000
Date: Mon, 26 Jan 2026 02:51:58 -0800
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, riel@surriel.com, 
	kernel-team@meta.com, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4] kho: kexec-metadata: track previous kernel chain
Message-ID: <aXdGyXNUO0mPwJsp@gmail.com>
References: <20260121-kho-v4-1-5c8fe77b6804@debian.org>
 <aXICriRKbYB5f3li@kernel.org>
 <aXILzST3NxyYXW1m@gmail.com>
 <aXX_SxpI8Tuh6Q3V@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXX_SxpI8Tuh6Q3V@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BAFE3180005
X-Stat-Signature: bnt7da7snk391uf3ugd1i98zcqty1awy
X-Rspam-User: 
X-HE-Tag: 1769424735-49566
X-HE-Meta: U2FsdGVkX1+ZEEpZnAA5SBXnoYMoPKeHw00gG1DJlCcB2V+wf+Z44HpKCVhI1KXOeqItL8VYFZMPEoKPkW0sG7nvS71uKn6RRBm4Gkru1sqtMJNUgUytbHKQXJeFU5SOJcAQ5V5yvatjbBicPP65NsrlrmaXVL1Lp60wTIL7/Y1QdpqqDnqHnwTKcP7aTbcIRrcTu3tYz6cG2rrdWTDrYmNsfyaHqAk665Ts0iWdZoRvAqCaOwDsB28HIVJuf8pH1VC6oPfZWzR87DzNweja/FdwKkwTuJQLwda31L2pTfQrAnRc9iEJjDZmwLBW+hTbmVeKMZpCc16KneUJu4I/0jBmc/CCE4FHghK3r7rqqZ2NtJa3H7Aok6EP//+VPHtg7HNoOfJq4IC3REHxmolGoHNo8upCaEv2/15jfodAF0zzgX70WwQO20oj3dWbWzjA8ClSR1NnW0kNCMlbwXcIhwXl/pBvLp2pGQSVO5wr3bfPgTQfytHtmEYJi4nQa+2Is32h278tlS/wTWC580Wo7frxjc/nbuNXJwfkWyrH1vTPt66doqrcf9iEvpIeRXAEVy/XKqmnEOilQrZXGdsvJJ0IGSENQ5jiPTH2+7n+PHUmUyLuE96kjPNLdSc0vkvdjOUP7rUfcZS4ZsM6Q10KDNXkmc+k1567hf3KiiS9s2+PVHSzOU+Dl9vPiWIqKxngPEKp4rzu3/cRSJNAJX6jNvpwVmkduVhQhfcdLyROfyjJVqvSm+48m/buXMZeyRmPeFMGZfln898ev42Q8c3tb8+oVxMduqJ23C8E0NsnzPwy5KUvAYDH3ht193ZpVAM0PPsyg1pAwFTiaSGZNIWDpKvhyo90fXU3vEZ4dFmqs3wW3SN7sjn2a8x/e/jZUJHX42ibiIYqgF1rlRCxiOUa/VYgX8JTxLGIqsrIx9o6qsxP1adEIuZYrCD6520cpaAUiaNbWpY4A/GD+u7jLuw
 fDgm4cre
 jXk9yX0fNqgIWYPQgRgQyi9dgXz5S6BLm8BV6dMz3lV0/w211whzv0nMuk/TT+18SAZVJMu7eoGd/trDynK39/X7LQZzYAUhfSlsDNWvylc3yNMs7YuFqvAzJCf3W/dAiyxz+Ta8G8H+pCB4ZdXoGhCM2Ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 25, 2026 at 01:32:27PM +0200, Mike Rapoport wrote:
> On Thu, Jan 22, 2026 at 04:04:55AM -0800, Breno Leitao wrote:
> > Ack! I am planning something as:
> > 
> > 	commit 90e098ca0d611b44594f08e50ba1cff3c932dd2b
> > 	Author: Breno Leitao <leitao@debian.org>
> > 	Date:   Thu Jan 22 03:47:23 2026 -0800
> > 
> > 	kho: document kexec-metadata tracking feature

...

> I'd move this section before "debugfs Interfaces", other than that LGTM.

Ack!

> > > Can't we move it into the existing if (fdt) below?
> > 
> > Unfortunately, that won't work due to a data dependency between the two
> > functions.
> > 
> > kho_process_kexec_metadata() reads from the FDT subtree and populates kho_in:
> > 
> > Basically:
> > 
> > 	kho_in.kexec_count = metadata->kexec_count;
> > 
> > While kho_populate_kexec_metadata() increments metadata->kexec_count:
> > 
> >           /* kho_in.kexec_count is set to 0 on cold boot */
> >           metadata->kexec_count = kho_in.kexec_count + 1;
> > 
> > If kho_process_kexec_metadata() is moved after kho_populate_kexec_metadata(),
> > the count would always increment from 0 to 1, ignoring whatever was passed in
> > the FDT.
> > 
> > Restructuring to call kho_in_debugfs_init() earlier also doesn't work:
> > 
> > 
> > 	if (fdt) {
> > 		kho_in_debugfs_init(&kho_in.dbg, fdt);
> > 		kho_process_kexec_metadata();
> > 		return 0;
> > 	}
> > 
> > 	/* Populate kexec metadata for the possible next kexec */
> > 	err = kho_populate_kexec_metadata();
> > 	if (err)
> >                   pr_warn("failed to initialize kexec-metadata subtree: %d\n",
> >                           err);
> > 
> > This would return early without populating the kexec metadata for the next
> > kexec, breaking the chain on KHO boots.
> 
> How about we rename kho_process_kexec_metadata() to
> kho_retreive_kexec_metadata() and add kho_process_kexec_metadata() that
> will first call _retrieve and then _populate? Something like
> 
> static int __init kho_process_kexec_metadata(const void *fdt)
> {
> 	int err;
> 
> 	if (fdt)
> 		kho_retrieve_kexec_metadata();
> 
> 	/* Populate kexec metadata for the possible next kexec */
> 	err = kho_populate_kexec_metadata();
> 	if (err)
> 		pr_warn("failed to initialize kexec-metadata subtree: %d\n",
> 			err);
> 
> 	return err;
> }

That would work, I will probably rename it to kho_kexec_metadata_init()
or kho_kexec_metadata_setup() to follow the same pattern already there.

Thanks for the review, I will send an updated version soon,
--breno

