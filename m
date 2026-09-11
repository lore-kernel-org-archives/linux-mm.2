Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 733EEC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95F2F6B0092; Fri, 11 Sep 2026 09:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937CA6B0093; Fri, 11 Sep 2026 09:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874356B0099; Fri, 11 Sep 2026 09:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69A356B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:34:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 010EB16014F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:34:44 +0000 (UTC)
X-FDA: 85201576530.01.2A635B4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0D75110000B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:34:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ot8PSeur;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789133683;
	b=qgefChbZxHZXdVTJxaJrw6VjR95QBoUTi77mLOFckEgavoeET97FYCS6Jlx7DGFqqATGCy
	+lJwA2KUfr7zs4XWoA0Q6LUGA08hulan6m5sdTgq9f4Z1SfRKQryaB44aLE7wuMlDWXivB
	57wvY3zFLHnpnACBximX9ETJE3Y/pbE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ot8PSeur;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789133683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62WYyxS+9gI6RuDOSpD1jzvwTBSygxnPuFsZGOMg3eY=;
	b=hdsnIhwl5KU6lQ5eRrWiYlKBIAAdCvz8/V5t6WUSD8BAgdY2FFfmyrLhRf4MaxhlheWAzU
	N/p73Jis7o+nNebNHuLoLaX0IaFNZ+2CwNgyoHxQXdjKnZT5A6UeBAO5d2SNceQuoXrsc8
	wIa/E6TDIGbxXC2LO8XQo0GNSJIqqXo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DFB31655;
	Fri, 11 Sep 2026 06:34:38 -0700 (PDT)
Received: from e129823.arm.com (unknown [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 697173F59E;
	Fri, 11 Sep 2026 06:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789133682; bh=bnRhlOG7uJfn0zTtgUAfL8VaHyebIVtCjGBipOdWK2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ot8PSeurmDv/PG8wha2jcV1v/KJF74wyupEmOPFe8OdNtu3gb5v4ntaEBt6xBJLuH
	 xR/962+EVrO4e5oEMFLRz2qi5PH2MCjsPg5Xjk+jEOgDFpkI3XTF5dUlAIS2h5ttHQ
	 mnMpNoXQ1eoStXY4igAfLMZoyfUTiAoASspo2jsQ=
Date: Fri, 11 Sep 2026 14:34:37 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, david@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com
Subject: Re: [PATCH] kselftest: mm: fix potential failure for merged VMA in
 guard-regions
Message-ID: <aqQDbfMOVasuejA3@e129823.arm.com>
References: <20260911123534.1181501-1-yeoreum.yun@arm.com>
 <aqP29-H0iKl-2CVH@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqP29-H0iKl-2CVH@gremlin>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0D75110000B
X-Stat-Signature: n8ug4ueqitseg87umiqcnnx6o4ndxna5
X-Rspam-User: 
X-HE-Tag: 1789133682-354689
X-HE-Meta: U2FsdGVkX1+VZDnRQ3xk6dzuapzndhkdc5lGIxYX8ot+lqPNrrYZAujPl8nYaYE/TUBqyQUHaAlm1Mrk/o4y7reZY/5wyhTL0NOv2ZSL00VImQMygmsjpJKz1IPUI8dtwa23KJkifaSAzi6weoEGQrptO2a7SDXpJDGhu61O2bpSUSRyb5H7t6MsKMetILJ+hr+TG6rnk2k8/YMniIazvN+8dXdStuiu4KM8GnXDe+gX8KxB0xulYtdR0I1RrAGEQZOqsjP9LU6t1S15GrHRTsLpi7JCxdYS15+8YxRbxZ4uyNgZHmbVo/Vatwwr4yfB+3BskSKMvx2PAy1DKCbZU+Nddpb67ET9sQcI/guz6+YEnc4gRh8g7WnceqXpOfJKTFRXbewkCOhh3X+DmzEoIy6LHg/A1g2u6o0TBMz9oqlDQ+MOPOzINg+7uiX5K9xH9p6pJsb3sZTKvkc/srf2hlr0GtYMIMjA4+6jgpTik98Gvf4DjsRSYY0s+hMX9gh6pLZFQi7HsP2Qt4+X20t4xqTmSn7JhNrgNzIsWdZjaOBCdIY2vKQbGmsY1R4w/BQW8FwAUSSNWTHLVrMjJcOzQIuyvQdsMWWBTYTt1IUe2Y/iT5TSitI/SmfhlgR4/FJCUgvqT2DSMgBMgOXc2nTrYF45pLxCBqkrJ513DtTtCoO7zqsVhJ867z+A5Q4UjaWR3U/J6VU7Lgs8cGCT8btPNkTYbS1FdLlOGzBTLynPE5Fj64Pn+/Hoq80eIDaIvpib0Z0jLfrkrgdaNfnxP/uzbPzNHYcG3Ou2r0sgfs65tOpYDyc2R4Qeuih/TA+tky/P4LtskYvRoqMN/Lrxy/ran9VziMk8R0Dw8MN68oklmJRy+qXj45nf3wr26SM/SK9m9WGdFj8dVGfsqbM5YfQ9kBnwg4M7Sb0SMwaF8pCSvY1zwbrKSuTXotJzC0UOG9yLiQ+i2k+KwOg7bSQ9Adf
 kg3ARMqy
 4ro64ZvWgkALS86ydN1BLdvc/WO2MqvtJY4ojBujGy42dZGLAutWF+jb18CK0h/dRmsNmJ7bff4iz0PYVTHpfkRh4SU4cn2DIp17YdvgX4UB0nUhoV2j/FGz7ckpfmYlxqgbjsUWm6uytEEY7XaXJCeJFAhAIg05ETOxz0kBMqvz9eHR3V//Jx/ZEy5k5rG3lPW5kDF0g/Kt/jOm/gwjj988xsXOBJq0UY7eRC4ln5apS9D/XHlSmHoZgkSE+T7bONzyVu+gkmqkMLoLNQP3ACCXIWJCodKhz9vQI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 01:59:31PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Fri, Sep 11, 2026 at 01:35:34PM +0100, Yeoreum Yun wrote:
> > check_vmflag_guard() uses /proc/self/smaps to retrieve the VMA flags,
> > but this can fail if the mapping is merged with an adjacent VMA.
> >
> > To avoid this potential failure, first allocate a temporary region with
> > extra pages at both ends, unmap it, and then map the test region within
> > the temporary address range, leaving an unmapped page on each side to
> > prevent VMA merging.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  tools/testing/selftests/mm/guard-regions.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> > index 5c8ec3ca75d7..a28a57d34e97 100644
> > --- a/tools/testing/selftests/mm/guard-regions.c
> > +++ b/tools/testing/selftests/mm/guard-regions.c
> > @@ -2257,8 +2257,18 @@ TEST_F(guard_regions, smaps)
> >  	char *ptr, *ptr2;
> >  	int i;
> >
> > -	/* Map a region. */
> > -	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> > +	/* Try to Map a region. */
> 
> Map -> map
> 
> > +	ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> 
> Should be PROT_NONE otherwise it'll merge with the below.

It doesn't matter. since this memory is unmapped and then second map
at ptr + page_size.

IOW, though the first one is merged, it unammped and then 
the second is allocated at ptr + page_size, it wouldn't be merged:

  after unmap:
   [existing VMA][ 12 pages ][existing VMA]

  second:
   [exiting VMA] [hole (page)] [ 10 pages (for test)] [hole (page)] [existing VMA]

Am I missing something?

-- 
Sincerely,
Yeoreum Yun

