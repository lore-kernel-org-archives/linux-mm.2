Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA528CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 18:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A948E0008; Mon, 15 Sep 2025 14:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CADB8E0001; Mon, 15 Sep 2025 14:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA208E0008; Mon, 15 Sep 2025 14:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE2708E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:53:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A919616071C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:53:42 +0000 (UTC)
X-FDA: 83892383484.01.5F5CDC3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 51F2814000D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:53:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cE53QFWi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757962421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGv20+6YpatpMWw8/yOnMR5Q6H+xnS/JGImMVszoFJU=;
	b=ZmN8xutVrT9Teoewx13pEMf9AhAo2c/RFtJGuFVmAsIp9n2TcwEcmxOF8g7weof1eEc7TM
	qJhYrU4QSzsnMaHzpn69Ap4HX2oysUf1I1D/bBLhtj4no7qUp60rCti655o8/ActYUxTRJ
	xVjcHcualdvyVBRhAyySmn2eWD8VCYI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cE53QFWi;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757962421; a=rsa-sha256;
	cv=none;
	b=1D1MhNqA0Nw7hniTDilTsHF+wcKRiLOkqCRJ33BiSwUGwmeXjkj9RqOu71igHf7MWb+X4I
	jalBc0x2pooOmPwf5MdlutdKxtKak3scmCi6kMHZKYcDRc/odaBMQ6KbiqJlS/50jiH1sw
	9CUKG8bjgvBk7wNPfJ/kIrxaTy9B/EI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sGv20+6YpatpMWw8/yOnMR5Q6H+xnS/JGImMVszoFJU=; b=cE53QFWiHwkotylHSnsIhej9tZ
	c0u8ZuRFEWFRxmxlpsiC4NOgQ6zyImRqsjkkyBZxUYTd+So4ptzD/qu38HfkL+hNqpCqo1Qw+Qfkb
	C0lyq8U4LwLkohUbfduFJzh4gMpxhYxfwX4o4JQ10EBtF8JfjPbw28KidMnsMg1Y1jM7gbz9QSWhH
	XDXnODRLvIQS+ORuHBPH5cjg7i0zeZXwx/SrZowF/8U2WjqEMZHahUq+YGfG2terKjFiXzZA53Zvt
	GnRYUudCZIz6TNv6n/MkY5EXgzNC1JIxwFInJUE3B9RPuQ/S4CKlifLP6MHHQKBrfcUQZh6FT/L1w
	S3il1tfQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyEKH-00000004cjJ-2hcv;
	Mon, 15 Sep 2025 18:53:21 +0000
Date: Mon, 15 Sep 2025 19:53:21 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Amit Shah <amit@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>,
	Christoph Lameter <cl@linux.com>,
	Dave Hansen <dave.hansen@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kirill Shutemov <k.shutemov@gmail.com>,
	Mel Gorman <mel.gorman@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <mike.rapoport@gmail.com>,
	Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	Rik van Riel <riel@surriel.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shivank Garg <shivankg@amd.com>,
	Sterling Alexander <stalexan@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Yang Shi <shy828301@gmail.com>,
	Zi Yan <ziy@nvidia.com>, Eugen Hristev <eugen.hristev@linaro.org>,
	linux-mm@kvack.org
Subject: Re: [Invitation] Linux MM Alignment Session on kmemdump on Wednesday
Message-ID: <aMhgoUvziLPNt_vI@casper.infradead.org>
References: <426751f4-428b-ed01-509b-d13e719a2006@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426751f4-428b-ed01-509b-d13e719a2006@google.com>
X-Rspamd-Queue-Id: 51F2814000D
X-Stat-Signature: yy1ijhshwe5fej3eejyaqbpu64pzm77o
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757962419-595528
X-HE-Meta: U2FsdGVkX19CMVO9o2u9GijVj+0rrvtwbcvruTRmzsVaZqX2nMevdjzyaFakVnM8HdgZd6kD73ahuocBB9SR6jbsdhGhMcjIR0RRFRX6xD7VbumxDKxNaRSu0rkdUNUZ4w6uYwzg2H+g5wUJZgM2J4xHSkM5jd19SHlcvCRW+bH+q/vMTYlrAC5lJV46OdwdAAvHM2JZJF5ToiJe55T8m9RVdi1MA3Da45eKUaDIGh0/pISVAnrEAVR4QfUWxh4CtAouuJsm/RObZtURiJxqij7khNPz0o0hI98rMquccnMn8jzQ2s03TTxtfrzOQErQKtVWWq9Bt2sd6EBOQF6xkWX8CxfPJ8RKl5DXHYlbwfQomvOWoBnohG7mMpbXZaP5WtpqRXTiC/8QQcFmnAFPvtibp2nch8/K6fdKeY5W4GxtPznwuc5jvFPYiWheU2gGNdR9kvuN2E5MECXbIueKPLqxz/X0Dyj+KM1iV+hkxoETaPdhtpaviWbjZokIBzZwmoJSWd3gfJBsZAChQC2APy6deppn0yAt41n5jNeCBUCOu0MzHHzJL9Wojz9IHHxydJm/ewvU9rmyKdHwYaEhXoPxNn32qWjsiOF1q+lOPf9ItsXKpo3YVgV4f3c5bbvvioa+pBfjBclfUJN8mf+RKuCde382eDBtg0oDiiyH+d69DVyhd4x3+xs4z7NGhmFNPTRzVAZEc3yzpK6+bxWAK90KHIgg9FIRyyqMCDzbmVgim/+J+rW1fXalikIvg6TgjEkaBLkSlk+U9AjKTFoIXTjM8vHRkg3O7SSQhTIhFPdWmwRy2p6S6ZijDkMedTXJHebbzP8V3Mwp07C5DIAfhukXpZ782GLCpzdGqTEJGTRmJY3+zTxtmWo1u1jbJkKbUUrhKhfJktvrvOrr1qdo8dN/25GyZ965mFRVf0SF5bUNVrB9KhYcYh3i1j9iXN00auBYzp1b+Av3aRkUTrD
 Y0e3+ms7
 leahSVud4ZZccvW6QljgQnnaEaSyJTtONTweACgMWZym9VRVZR0e8yzeapsnZyOT7kDPkzNP/lZexyhPE6Wf0ZZHAKQjOea0CtFMRILvyJQL5BxBTq+HHYprb71mI86kzcVDkGh88qQqnf+uuyu4oQKAQ9dv6IRdJ2bn+sUwPKtvCdPDNbL27EXEVNR2kt3sm7s8kL7FNrhPpGXtNsWRM7Eot+3g4mVtRsnB+tUo2d/C4UdKxqQNxkvIFqk2XzdT+F3FQswluGizyGy4VgQocxD2PHDohoMSKRJxzDUIJSIFu0tZEBt3GeZjadCiw6g4zjGOn3E3OwwI80HLA6yQuLirJbAHf7+mf7hVeXCStQNFV7xf6s6OxoG/+cdaozZZX9ruA+i4ltN3NZQKab81bt8DVR5zi/PDb27/h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 08:58:35AM -0700, David Rientjes wrote:
> This week's topic will be kmemdump led by Eugen Hristev.  See the latest
> proposal at https://lwn.net/Articles/1031319/.

I don't understand what this has to do with mm, to be honest.
It looks like a debugging aid.

https://lore.kernel.org/lkml/20250422113156.575971-2-eugen.hristev@linaro.org/

is a great example of how to write a lot of documentation that doesn't
actually tell the reader what anything is.



