Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37016CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 924148E000F; Wed, 15 Oct 2025 05:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D48A8E0002; Wed, 15 Oct 2025 05:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3458E000F; Wed, 15 Oct 2025 05:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65A338E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:02:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3213588B58
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:02:43 +0000 (UTC)
X-FDA: 83999758206.08.3D4CBD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8E4C11C0015
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:02:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jGLnoEpN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760518961; a=rsa-sha256;
	cv=none;
	b=frNm/724XNRtgVIUXkvm+r9TdbNzK/X2JplLzlIkQVDoQg+BOqLDG0X4LER+6h6vrj00sB
	+UjnMHFPywj9uSG6cLX7Mby/YUASnnOC8jMCugmxGQF1HJPhhKehKbngUlmAujG1i/qGzC
	Cu/CbA8xoNELpS2PTMwRlreBjR9ZsE4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jGLnoEpN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760518961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxzCRrc5WtwQ0LVfF0axsM6ttkL4cjtbeEF+IehadFQ=;
	b=ae7z09iAWkptvA70YwVPgfJrP6CuTCkcpAcUaEMZyjXxmaH8vCT6HPndGZbCvNjSeMxbg9
	D3T0P5SlS9TUr1GRbkAdB9j1gKH2aVKaRIlPsxpD45SxJn5PWhCgr+xhpGTP4s+ZuX1TWa
	DMRkUT9S3cwobVKxfmO7H9NOpH9s3Fs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 85AC862541;
	Wed, 15 Oct 2025 09:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28134C4CEF8;
	Wed, 15 Oct 2025 09:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760518960;
	bh=NnFyGjBoL4vGg7ADG2ActUbXLTE11O5QDFufreKmw1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jGLnoEpNwn1R41Qc3IIZWGmcD6MeEK4GVqMrDhSSc8fN7VJuVkNMDCZ6AQflu63GG
	 UK0nFSVBkXOxB/KgPc2mfZ+1Pa47f9DwOlOxLuWdZ0cEnY5WCIqelN5Gbt4+TgnOKJ
	 WKw11Oz6Xpru/Ylb9p+eAidWCosit/ZcLmNoa4aUvNQW4V75q42xXScHUgf2MFvkYl
	 D08bz/w7rnbxImSwUzRViQB6J9yV8DznSHr0alrfz+/UDiJl9aEHUX9NyVORrhAI8d
	 +q40uiiZceCBnd0y8AcQcgQB4GOeHjv2QUvMJzA8vWbPAsCqNpaJB0JUVBA9F8rXNI
	 aAwTNFMgrDruQ==
Date: Wed, 15 Oct 2025 12:02:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Itamar Dalal <dalalitamar@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"riel@surriel.com" <riel@surriel.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"harry.yoo@oracle.com" <harry.yoo@oracle.com>,
	"jannh@google.com" <jannh@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>,
	"shuah@kernel.org" <shuah@kernel.org>
Subject: Re: selftests/mm/rmap: verify correct RMAP handling of COW pages
 after fork()
Message-ID: <aO9jJ-wGR5ANmKZs@kernel.org>
References: <SN6PR04MB4048CF9A242A640B29A588EDFEE8A@SN6PR04MB4048.namprd04.prod.outlook.com>
 <8c2c9721-e2ca-488b-b7be-c58170f6ceba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c2c9721-e2ca-488b-b7be-c58170f6ceba@redhat.com>
X-Stat-Signature: xudx8a4g339uaes5x38f8i3ixyof7tdh
X-Rspamd-Queue-Id: 8E4C11C0015
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760518961-67212
X-HE-Meta: U2FsdGVkX1+EGG0JNmbrMXad7T5WZ2RJvfBQcRnYfDdt87Yi8me8NU1uGS9kook7MipauGya2WsHAtaPY0+KrJUg9nin7/NTD/S5m8tbcI1VCyniwtP7tV7YfOQCp0bsVQlZfzPEFT+X0/7VhHk3FiyBh9WpHigYMl7239M4xMX2aBOQsnFg0YnZRsXm0FoY9JoV21UkqyXX49Yb3UfBGh4fWSEjf7o7Kxh+bgFLaYGjECZvz2/nvg3fRpS2g9A/DMY6ld8K1nEK3JSJqtavPs7XTvijlIMdtK4qOGBbEYJmMEXMtuSDAFvpt8qILkwxk04KKjlqC1CfflDNRDNrGd2Q1m3L4wKQpG8hXI/VOgqklf33cd7ovXh1wtP6DhI6w0ZLyf4vo7VUEiO1guG092V4wfBYXjhxMIOpwMX/v4TnBOiCyJ48xAcgK/AHDGAcAUVjju2WDMrlMBhXhirc7cDCsuBPs3Sq9Nad3eraEfoYYvu8edANCx51Scct9HNGhzZ2nmS+6ceidl4bIvkhc1LCcds3BhMlQH9ehZWBUEKVOY0qbNQF6wKpkkVlNhBastatpyvD9EbUSvxXSTGgGlsRiDkIrvniuhIOS91ZbEIXDO3tP/OoshTI1OXWsJp8o2txSvyLNK2OLbXFaGRd1XGj4Z1Krar2GdUpOCc4A9JpfQnBe+GWNPMi7vEx+logxuvKUxKeHcr/DMGCVC314OF2L5T93DTP1ej8bWkvtmRDidkzxtgqxzIktXulLSzXBUtrdL1vNhnV1TqWWfXH4BaYE2jPfNq0ibqXpS086uxoEKSbrXdJXIBj9ePMbP1XiEk6b7c1NhC3itjMlUW9X4kxBNMc3JQ58S4B4A4GEUSxt/twQK33vF23BQ7EeXW8pEsDp26NhpO4JR0ysyN3HAVxExykbsgNFfzUgvfJfA8RnyC9SUmpMetoUcvxN1tvu2VFeAVbCbfZDgJGBF3
 ylj6JGLd
 GKsD/4sGsQjdky2fHcsMAqdeE48EX+uavswuUuWJjV3qypzseWufZCc62aBdaZlTTvP0s2gAbWJOlb5WxJ9i5X0dnL3Hh/Oqc2jN/XxXlEZBilbSNj6NU/ZVYA9YBtoN/aOmezbfcfH50j0SrlKxp+UZAd0UQTPiSIjHogWy2r08COXERrv/ngGJtE0pomFnKCwPqAb8Phd32z6XQ49/1iya79nC0Hilj/j94kcptUO812PZG704jqtq6vkqgYdKy1lAFB88aA3nYTZuztH9BryGebTgkVeqguuO7ivfIAUW1DUrhyTWhaGz70rjzEymgkz6T3AqabYCBi25VSFDJUJOBl7szI/wa2Ow2ZGguoQjro7irYM7UMQLrFpKbQP+B+ll3QxqiHGoIZlQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 10:49:48AM +0200, David Hildenbrand wrote:
> On 15.10.25 10:43, Itamar Dalal wrote:
> > Add a new test `migrate.cow_after_fork` that verifies correct RMAP handling
> > of Copy-On-Write (COW) pages after fork().
> > 
> > Before a write, the parent and child share the same PFN. After a write, the
> > child’s PFN differs. This confirms that proper COW duplication occurred and
> > that RMAP correctly tracks page ownership transitions during COW events.
> > 
> > Signed-off-by: Itamar-Dalal <dalalitamar@gmail.com>
> > ---
> 
> Se my reply to your other patch.
> 
> For the next time
> 
> a) Use git-format-patch that will automatically add [PATCH]
> 
> b) Use versioning, e.g., [PATCH v1], explain changes since the last version
> under the "---" the
> 
> c) Use RESEND for resends, e.g., [PATCH v1 RESEND]
> 
> d) Use git-send-email to send mails out
> 
> The b4 tool might help as well.

And

e) please don't respin new version as soon as you get a single feedback.

https://docs.kernel.org/process/submitting-patches.html#don-t-get-discouraged-or-impatient
 

-- 
Sincerely yours,
Mike.

