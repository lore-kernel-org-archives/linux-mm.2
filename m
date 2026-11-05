Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A280606A336
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gM+grsc5
Received: by kanga.kvack.org (Postfix)
	id 9EC016B05B8; Thu,  5 Nov 2026 07:23:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C34F6B05BA; Thu,  5 Nov 2026 07:23:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9005A6B05C0; Thu,  5 Nov 2026 07:23:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AE216B05B8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:23:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6F281609BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:23:16 +0000 (UTC)
X-FDA: 85400980392.01.B35F9CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3693220005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:23:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gM+grsc5;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793881393;
	b=JVnXrTb2LB4nvoNmx5XEsXaNDIaIgOkoOY+OGlb1v6uwsAnaOdzB9yX/OTy4nB6x07u16C
	bBu8+Nx0+dQgABS43d3Kjpux2NIQdnOLSapoE7lzAocwFrT2NIT7uKOiQlbyG4AVxjhysN
	QKO6xj5D48Q2c2aE2ymk9qfpqQZpMn8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gM+grsc5;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793881392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iivs6yaaggKZsHwVDovGVqLyO+85xXEu4nFRfS6NxC0=;
	b=q1Xp1kTiejvv3KEbkaQvKTsMravgmC8BHpb8pkJkn4Mwl81aTPzagzkMXDVCdohpOSvDPu
	NWu0f8WbGGJKJv+sjGUDh2ULODY1DrnAnXFfe3r0ZXe37NoOIRo6lssaizWG/lSA6ZXDII
	bZhykAXK85aWKeBQ1LMouvijeHZ9kNg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 811D660F1C;
	Thu,  5 Nov 2026 12:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2D91F00A02;
	Thu,  5 Nov 2026 12:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793881392;
	bh=iivs6yaaggKZsHwVDovGVqLyO+85xXEu4nFRfS6NxC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gM+grsc5ON2YWfiXw5ezs4zq1DkpkWsOpfchNUxTp5Yjauau4ZDwF7cL7o7EToXPl
	 nC+WM1osWOj5OO3sFsgXA1qTb3HYYqv2hgKXRrzURCKMh9kI+yqUhtZ7ZISUprdBxQ
	 qn/gKmcuMOkDiaG4k+ZZcqk0RzikRdHdwS2UozLLpeoqDaa1LeqAH4AOUrJihZRSRy
	 i1AEn6FrS/m3ncFt+sjkxNi4fkCSkTfAeAsdHUpGxPRnrkFKJ37iJZ+SoclQPuLnwT
	 Hfh4mDUlKgqfeJu/9Ov4zoD7vKrJNAuPJzsYgsUf16h4HIBdRgX3/U9p61Q0WAX5f4
	 wYnWj6MOCYXvw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 07E23198003A;
	Thu,  5 Nov 2026 07:23:05 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 05 Nov 2026 07:23:09 -0500
X-ME-Sender: <xms:KXXsah5AmhduVdWB4S3uLWUwrclaOsTAGJ1hCzeG9c9fSn8jHh0xEg>
    <xme:KXXsalAke7-fFetRle4YMq8IYHc5eBGB5FDnij_25jY99X0CC-njbr1tttFd9h8JP
    1y6TjY_Nf_koWTIyU6iiCG2j3zvhk38flWJpcNFcwiIaAPpq29LlYWy>
X-ME-Received: <xmr:KXXsau8HAM5gBRaf0RMhsT_ppQ4hvwsRAYTkRZY6GRgC5geiuYVcbGs4RfU>
X-ME-Proxy-Cause: dmFkZTGVfuvqVkxki9la42m479/fuAu38sqk3h0/RigiFu9otpD+tJDC7VpSSzL3xzhHJ4
    i+ve1m8wGeY65rOatgOHPXcpXjsv37rr7dyddgk/yAh0bDgP3MmmcTyP5UuxCqL85qvYUE
    o3u5pQ01TYYDV7f5IxieW8w1IOzD+rgpiA1H6Vh6obTbbIORbX53uFr2uTwYAKHk3fGKhc
    nUjO0rZPzPOpSVWtVYAS2TWWUq4Jccmsti9YwbSGeZjAh0LJk1kOnkCSKQRopjQ71bxgjS
    TSGO6CCKXZhNHP3vWoiLOPNjZ60UCE0GBZ8z69OTYOiPSQLPEiIPzed3LiNolFhPbCszcL
    f/CoAF9Trls1SHQheisn1S1ScJDviV4DEuNsNBLfv95fTgAX8v6vgvCreRGkH8ESGYfxy8
    XB0VYu1j3mN7Ij4AM65xmkHX4JdsLKgYi2YSDYI6WjbcUszx7D98PujZZuU08axwcKIlve
    MutaEkyW+7RyiupRYqfFc0ybLprdk+wh8Fk7lBIpjRv7EVUlKXMUH4fK1d5RLw1yZt8xCM
    vTz3hgZrIxi5a6ps1osb/rKlkbeDdEIk1OppWk03UpyETN25Lus4NntoQZ/GHpEiSSTAHW
    PMV+N7Rr9FDzshyE2Nm8p8lff+jZBylcqXHRcjehdSfMeoeMtchqTrNKC2jw
X-ME-Proxy: <xmx:KXXsakKwECBaQp6YIKiMdhdAWHnQY6OObcbfZ0Upem-6-rMA2t8BvA>
    <xmx:KXXsaox3VTERLmIqK8uA3xdOqqU9zteMMHMwPIs3xxfjxo3zFUnKqg>
    <xmx:KXXsanYXT6xYUUs4tUBL28JEM0lD1ryteMoQ6Hl6m-7A9PdroFozfw>
    <xmx:KXXsaguoNvSMWThtkZ7JTdlmVPLBiiIhcr6DB3xse7lBGkU3rVO1Gg>
    <xmx:KXXsahdf9sw2JKGUetW9Zd9TyIMCmZCuKoxCOns-DYLU_ULcggNNtVmO>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 07:23:04 -0500 (EST)
Date: Thu, 5 Nov 2026 12:23:04 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 2/4] mm/huge_memory: don't queue folios when underused
 splitting is inactive
Message-ID: <aux08LjSkQTYKMOP@thinkstation>
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-3-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103212004.1356327-3-joannelkoong@gmail.com>
X-Stat-Signature: domxamax74buchp99ts8zpcxs5nkrajj
X-Rspamd-Queue-Id: 3693220005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793881394-772968
X-HE-Meta: U2FsdGVkX187EoQtnSl7PovT+2zL0X6OWIJnkYKu8TocaPMEnxEx0/6GFvdTckV4IALr2LAgbXjB3sz9nxcwGk6TfXFSUIahYTDEyAvMKRlGh1tLhpTnK+TJDbIn+60SWliq9UWpb9MpeAfko//teUmiu2Dq29/T2U+miQ8JsSYgr957S+1++v9UswFOPi2xGUyQ0ZZqLKEuyO9hNDa5gUXiZr0z85KiK48Vvb2flJpw2HjMqokbLJrD/NfYMBML8LLm5U+JYkE6jIoQ3qgGeBxvE/oDdI3tQ095ReUHKlfYeqMCRnV7eeDL9+/b1k5O8y6TEdmfAcjTExj78wXqlWYkALC+N6Nn34egzF2uZ4BwMyBkleq8DUKPzkkgl+mm7OfMKTx3/Sa8bXKbeEJuf+zBFwXSCc9bAYlTSCfk+wba/dHq2bn9uCoEUVxVbBOpjPDAocv/PdtU4M6XQ2ho/MIJl0E8boPrdukbWHtW2JpP3/vEGL9HgsWU2vjZGbD67D9thz311HWxfj3C9ZLiey7LdBJclw+uzfdCrO27K55B/A2YCwV7k7mp573QJi1RsYMg3v+r1T4QCL8C29kgMOvoz+7efUJ1/p+VaIoO4voQzdJmAJitsyOE/WRC54FneUIQcyJU4KDWjpKJwYEXjOV3IYh7oKalaYj4zghAFqh562QSmbpyEbANw3OpL/8yt5p8SpQeLgnsnGe+EPXwywyWpgEM5a8kQttUp81qyx+SDeWW0wMCX/sqYaA0NzRr4O/vksJCs1feU02rpk2mBuO2n9O16AjwjsxcpBnNMglzxNmOISGguWpXi0AcPaBZ70CcxiAfgkdgkHt7rzwBH1vM8EiO1hQGs+rsfFp2ZMWPKPFsCWlbMvQpZcTvUqtp/LwAO2IqQopwsWSbdVXnpQTF6r88gfj1XzW5H/eJ32uJ9BhQv6/oGyiEARV9bM4wvfRKnUS7CuhFu/eMZo5
 NDCIpoDc
 xbvjuHqt7MHTEjXmavpjScCzbcjLlzbnqoRLFy/CcslR1EEbyCgxEasv8EW7McsHbphb2nm5CzU1iTTKq45K9jnQqZbv94RpSn0JTBtjWsZLsmaTb49AXdgGQzalFo/+rnWBhc12npwTMNrm8aicf7MAr4Tvvw9RVrQAQWeZk1CoQoGPA5xMUqDRlD1p4bwh+p0gYKXr09D1adOhxwNnrI5gsiRIacnxYt+T+57nUo425rHX9NdbwjoqTpECO+Dqs8LToOzrMO456DqIgA1PJCBIH5IceeyCh6zH4s3wkrhtenbd1NdkXckuJP9QT+1kfklS7x95YzzVp3ljb5tHHqpJIETOvDPXufd+z5kzQwUyTHk1jAVvvP29n77AEp23GI9KSOjytm2zkB1MWDHR3I9Ty6WgADEmqhqN4ke6Mko6zU+atV17VxZ7FTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 01:20:02PM -0800, Joanne Koong wrote:
> Every anonymous PMD-sized folio is put on the deferred split queue when
> it is first mapped, so that the shrinker can find it under memory
> pressure and split it if it turns out to be mostly zero-filled.
> 
> With the default khugepaged/max_ptes_none this is wasted work. The
> default is HPAGE_PMD_NR - 1, which tells thp_underused() that any number
> of zero-filled pages is tolerable, which means the shrinker will never
> split any of these folios for being underused. They take the list_lru
> lock at fault time, inflate the object count the shrinker reports, and
> are then walked and dropped when they're first scanned.
> 
> Skip the queueing when khugepaged/max_ptes_none is at its maximum, and
> factor that check out into thp_underused_never() so that
> deferred_split_folio() and thp_underused() share it. Since the default
> is the maximum, out of the box no folio is queued for underused
> splitting at all, PMD-sized ones included. Partially mapped folios are
> still queued as before.
> 
> This also matters for a subsequent patch that adds anonymous mTHP folios
> to the deferred split list, as it keeps systems running the default from
> paying for that on every anonymous fault.
> 
> Please note that the queue has always been best-effort. A folio that was
> queued before khugepaged/max_ptes_none is lowered gets dropped from the
> queue by the first scan that finds it's not underused, so changing the
> sysctl has never retroactively applied to folios that were already
> scanned. Requeueing eligible folios when the sysctl changes will be
> addressed in a separate patch.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

I believe I've already:

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Don't lose it in case of repost :)

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

