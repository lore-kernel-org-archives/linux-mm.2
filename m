Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68A11FF494B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 06:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC586B0092; Mon, 30 Mar 2026 02:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3D06B0095; Mon, 30 Mar 2026 02:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600DE6B0096; Mon, 30 Mar 2026 02:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 530516B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:20:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB737160562
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:20:47 +0000 (UTC)
X-FDA: 84601730934.21.314AB79
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 51426160008
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:20:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ypJ2K2n3;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of BATV+d52e2ffbe62236f4cc0e+8254+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d52e2ffbe62236f4cc0e+8254+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774851646; a=rsa-sha256;
	cv=none;
	b=PCE1iR/2CAUa0bfnA4APbLkXbmjEZBMLkuZsx1WETQ3ise1654w2qkdAyLxxX1niYoBnr3
	hI8IQfT/dPz0DGejzHTrtNPIG5JrAspZhay9SSLKZVas56dBJ1SH5c1w6yYXo3Es2ODFVp
	rEdd5qW4zHmt1s31HKNu0jGSUymNd+8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ypJ2K2n3;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of BATV+d52e2ffbe62236f4cc0e+8254+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d52e2ffbe62236f4cc0e+8254+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774851646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETQSKJTY66rZCvnD09d1z8wM5Mh9Wrtt3bPMhswqLLQ=;
	b=6B0m3IHiJ0cbs0BMxvYVPJ6nT2blMM8j7ujJ4AHxi6/5PSqlKoT1GlhxAYCSjqqeOzx7RP
	P/y3HxFjinV05PbohHFeX03AfN2ZM1d+CkjvOy3pJw6x4NR6ZbLquOyqupO22Fm2t8R74+
	RpA5wqyKd8iDV7XFmhf62wPtPzl+Rv8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=ETQSKJTY66rZCvnD09d1z8wM5Mh9Wrtt3bPMhswqLLQ=; b=ypJ2K2n3gJJ19uGuH2CbJAT/b8
	1JVHZnv7DUznFgXYh7gro1fCYy2FPkhP8RWu+E407xZywIkSd5BI3nWgvL6uxYwBdPPrUvz0wklm8
	jcZw4rbLeE/F92oOHi+Ns+rwwVuG65Eo84U6zsHHOq7piFjzi14sP+FI6/fugkri/J2JAWToB8kjp
	IFkV1jGigYLnb4lNvL0yJAQZAdqgp14cxlIZXGRQvZDoH82zzzRNTBxpxfuAIPBdG0+VSRghmrmyw
	Jv1G9XXWoluT+uYJ4Unt/WpCItYeIAM2+Rom/Ndp0vreVhixLkkhAsVA05t3rkPJJvQC5T1RTmkGK
	5Q4eHRuQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75zO-0000000Ag3t-3nza;
	Mon, 30 Mar 2026 06:20:42 +0000
Date: Sun, 29 Mar 2026 23:20:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: mpenttil@redhat.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v7 1/6] mm:/Kconfig changes for migrate on fault for
 device pages
Message-ID: <acoWOnZh1NpVerCR@infradead.org>
References: <20260330043017.251808-1-mpenttil@redhat.com>
 <20260330043017.251808-2-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260330043017.251808-2-mpenttil@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 51426160008
X-Stat-Signature: 8nad39bziyaxygnswxrce9nrn87mi4pw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774851645-386913
X-HE-Meta: U2FsdGVkX18ziPabdlaw93nzWywRdmKX9AUWcPc3tkjgsgDMNICYG3j3D9dcJeHTvElHMTnkphnflXIUHHH0BMRzYTwiGVktk0x2QZBIreYtaFDMpdiKtSQ10HPHIs0u3KRJGJt7yzUkXwxchfD+Z58Eg1Wfwy4l36p9K4ja4fluRSAfs4OECfPqTIEhvfzKK1jYwciYl3NAyjEbR83xrLc48r1njJLDIle8qS9hdURf2LtpV4gQxhKDnpXNware4162NpcqrcurGhgiRjGnABNVkq5puIhnws775fFMqm/USz0558oUnlqM1CwYKRCo8jLaPvyTawzMlswvJEWGo2kckPko/0aM2QzKm6xGgL9pMpCOeoYnn2JrhZ7khPbe4ieE+aZAN0aDDfPJ2CY+ysPQvIYPzeyWqHGnWaIiS+jdH4gsI/vwhjsIkuoeP/7fmUA0R13awG0KMd85+rqJ93KKfExxDdQVqzkzCKvAIeqzsbemEorWrPQXCz5+vEBJ4fAWZonAibggaM9QNbBbL5pSVTDnZp+clioFrjI+XUslR81TOT/rifBJ4jga1fWiqIAca6Y/4X2trx3OOxfvRN7RG9U3wRdCUnwLKLaB0FqY07vyfpxhXPacWc9fg07ZEtn+0yYq31FgOKtxs+t7/y/MtynnYDY9nrDSXZ1sQKnISxRg+vISgPXGdqyvLahemxNPMnYLaEQhKSWMG/ZMbJzyG+9K34N/br9hOnY4ZYWpuUGp+TV6DfreEFonKS4RxfsKouZQFsTIcq1Z5hf5wWiepJ4bVSF38Q69qnExwfxCR/yLa/B3fr+ltVltcMLtEUVeI2MC3gUw6uNoDuzu6uNQmTiELA+1ADsYuUbVn+GwFrvXxHPS101r+TOH72epcSQzoJWRMd2GZXWs39+a/6aqJefzzIGdWvcigJJ8+cevUo933JNem6I1+nuwW57CWdUg7eillddxRzYZZI6
 4EGqJFgL
 sPf/m8DlQvMcMbuMqBDm90cvHDUmebxMyAyIP7MOUukjqKyom5ArYFNOkcXebleZ2Sm2YhOJopAu+DndJTUsAISVxKCv3S/6F9U0E38qL8ZWkC6AJ7f/gsN2Ovu7JJ40//TKiBqf6SbfqbnbQJt3iZyqgdTZuxnZRozuJKi7njmUqxI9SUBr+UsCr8rirKyJJvR7pqljArn54R1mqZ45QiKOXJ816aVWby+gUOeCGomb9a2UH7z1JWb0zmUo/iNboHCqQMNnsyUIIXOCJoGin9tZvZ70L9tHX/9yRvuQKA7TRacw6GNejAMHYzifXYPw/YGG1diuZJzWZr2MuNPgqZ4djzTfA84KLU9jBrX4wU3/nH4swO+gegt9YUKMhSWm4YNgNJWO7V7N5YfQ6mCQTGKKMTK+6t609SOYtCDZlW259QM4VakGBA8I7hnya+AVcLCWdtx8UEdXNv9akD6awkiSnFfd/iM5I/WDyDsy97Fui3IGX7OO07jJG/EEmrzjsnR1csTGWRTalTJ/3wydtsAB2ZJqU52SwAoHHV6sn831uBiEMJK5EgVcMYQbtuIkg3USZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 07:30:12AM +0300, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> With the unified HMM/migrate_device page table walk
> migrate_device needs HMM enabled and HMM needs
> MMU notifiers. Enable them explicitly to avoid
> breaking random configs.

You can use a lot more space in your commit logs, ending the lines so
early reads a bit weird.

> diff --git a/mm/Kconfig b/mm/Kconfig
> index ebd8ea353687..583d92bba2e8 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -647,6 +647,7 @@ config MIGRATION
>  
>  config DEVICE_MIGRATION
>  	def_bool MIGRATION && ZONE_DEVICE
> +	select HMM_MIRROR
>  
>  config ARCH_ENABLE_HUGEPAGE_MIGRATION
>  	bool
> @@ -1222,6 +1223,7 @@ config ZONE_DEVICE
>  config HMM_MIRROR
>  	bool
>  	depends on MMU
> +	select MMU_NOTIFIER

But either way this really should go into the patch that actually adds
the code dependency anyway.


