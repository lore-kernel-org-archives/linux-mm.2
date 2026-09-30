Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85DC4CA5FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 16:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C306B008C; Wed, 30 Sep 2026 12:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5946B0092; Wed, 30 Sep 2026 12:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480986B0093; Wed, 30 Sep 2026 12:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 209BE6B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:04:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99D9A140134
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:04:46 +0000 (UTC)
X-FDA: 85270901772.19.18E7159
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E9DC1160012
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:04:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lz4HZ+iO;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790784285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xsjJ24tQ5ljmlVOO2mMMeo31KPYZe+omuEvM50E0/m0=;
	b=ROGYCy9mtykktZZBTOIRQvA2fhYtcop7NtHMrsDCgZ1V1i5Slbfj67+TNEAmC0DtNexuuu
	obnMjsjiH81ryi3s2y8gcOCMR2Cg+qr12iumptiB3Zx2kOjHypfl7EC4ZchR8wJc6c1wnT
	sL9NBBsahuPrcmS7DMZBZr5Cy2H5E/k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790784285;
	b=ScR2D+E8cEKfpFY8eeuKQ8Hi+mfqGHy4Hs06Cza789Bq9ZfI+cMkeEg8frBiX13X2+AHIK
	MHE/L80mnLC0XhTHEdTXDh41BD8WUtzxSfBsCgIoidPxH+7UxpKX+UloK45xLf9kYMFlU2
	IPaV9uBJrA0e3iDBWjGzXd2ZDGPQunw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lz4HZ+iO;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2149243E17;
	Wed, 30 Sep 2026 16:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E811F1F000FF;
	Wed, 30 Sep 2026 16:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790784284;
	bh=xsjJ24tQ5ljmlVOO2mMMeo31KPYZe+omuEvM50E0/m0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lz4HZ+iOkiVr5Au/6X2Mo17Q9HAJmzL7pxvLZmt8HEeXd+Z9M8/qIXkT/P+Ns6+2E
	 JDjFBNsAyUOFmpRRwxYmSQbEYiXcf5xdpuTTcjn8ivc7tipt1xq3YsIPa9tPD9r0hj
	 /bgtiFlQieMYRiqSfrRXUVy/3U5kQgTRV2iUOVXYKJbo7p/3PMcJOJf0xnBNaw+K0d
	 7GjLJFMwJ/XI1+XbUGrnrqKCwmoc1F0YhhXG9wZ1ArbLMW5I01xvS6dyKUrA3/ppIy
	 lt6A0kln3CgAjcM1gzHI9LJPjvPx1b1Dn1Z/75PbC3WLCA7gka1AVow9iv0BDKF4hQ
	 bxJaEtq2tiDcQ==
Date: Wed, 30 Sep 2026 17:04:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/mremap: fix two issues with MREMAP_DONTUNMAP
Message-ID: <ar0y2odPFkCLMKk6@gremlin>
References: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
 <ux7od2uydetgsu3dpy6mmilhqm5phhnk2ioxn54w3nb3feohxf@2jqovoqzfs4n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ux7od2uydetgsu3dpy6mmilhqm5phhnk2ioxn54w3nb3feohxf@2jqovoqzfs4n>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E9DC1160012
X-Stat-Signature: ix5yte8spq81k4fxp1p11x695a81jb4m
X-HE-Tag: 1790784284-636107
X-HE-Meta: U2FsdGVkX1+7ekQXl54QDU+71FrP6KP9Pdpw1XL+lVExOGrdSlXWMSgtO+WRfETIXmw0hD8gt7xYsMF9UADlcuy3ZJkRfq7t+Z/XczwfkQHajkQeVk0QfY1sgf8Ui1B2ZWB8bSpcG7oaSD3zUHJCpwXywbL3xWresf0apjm0OBIyw5+Ti9AMl5yXPOnMilY5JXZRXtU2fQ+p3pmuy20mIMf7yZ+c8ipAFrFZqB/U6pI+1gThesRpABcPJ+Y2jTZtRSznPLLASoLF4rDb8Zb+YprO+lZMGXWNFQnVZF43n8fZKZo6IZsipukv8FI7q0zXH3hmgGG9oI6e07wTvQDOawC8uwTRmS1syDveXVm8WkmD+t+MG+aD9+TOtmNTaR4cQiruIIlD/0fq4VNXH5nAxylkydvh8wWwhU4TOBGzeEljGzfMzVpQeOxwPLYT3qIjhS1ZFUONdjizUXE8XXOYfPstXRbBjTK/rq6OYWCm9eLo5+vdYGYiw879PZ9Ykg34D7+pn/ngtNDcCUIw8GcR8tk0XBPOPHXsOmuDkHfuMHeBjn6ZUxp7S3pp29nShWlgvUlDHVFEHmzMtlcU4tmFJn2Ce5W/2GxZR4JE8qveA75xDpWvAl4xqjjRaUp1o1qCaSQ1grv0Hmm/4lmE0aerzF6bIbSdedWEaDz3D1iD6IWHB8tfz+jqacJY5iye1ttl7z0LYMviuAtqsBMBRTq7DZfLl5yOHTMykFJL1/wdAxqdCaUPL58Lxs2FrrrJ9wz1NfH6HmVZeHUb8YeezxjdmWEfDE47sWy8Peih2eUPeIjrObXzT72JGUEjVddv7bOgPhG247bCDiwnXG7EDR9L6quoPzrtYfgwfssos48nY79t07l0qqdjIH8aPH4QIkLE/OuDutQI8gMsCCbdCZeNmoZt/mO4euuHEWFwPfuFFhSTBJu4XWs6H2624LpuWcd68hMKshV2JVoim46EYLW
 gEaypIIr
 t9uX55pvgxJYoSPChFK6D+XnuYDfDGq7DEWvj7xi1oU2MNcfFKLfInQljMKm/aFPLaPwbgoKYS5JJXB4UWKsv6nwI0kNXWZQHTGc01GIY7plsFDdtFn2shAPNUXrMpl+GHJbObexImGJF8P1IXDXOijyTm4/+Mu9NodHvC/qXtpVQ+ZFqFCY1GJLctfkdz7SeHAdy6fWg8/bExeSZwzk5dXkrlTxr3UXuzN+HrE6to/kwHyi60+rzg+xSVdldqL+bzITM1JcvQjRcENkJ7sGrdA1o0rtgY9dAcRhWbCbdqYXums9HdvBa211/7VzOT/Uc86xU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 10:59:50AM -0500, Anirudh Srinivasan wrote:
> On Sun, Sep 20, 2026 at 03:13:09PM +0100, Lorenzo Stoakes (ARM) wrote:

> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> > Lorenzo Stoakes (ARM) (2):
> >       mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge
> >       mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
>
> Hello,
>
> Apologies for the double mail. I did not hit reply all first time.
>
> I am seeing some failures in the proc_maps_race kselftests after
> this patch was added to linux-next. The failures are in
> test_maps_tearing_from_remap and test_maps_tearing_from_resize. I have
> attached some logs below

Ack thanks for the report. I'll dig into this and get back to you!

Instinctively I suspect the tests are making assumptions they shouldn't be,
given this series has the MREMAP_DONTUNMAP case split in advance.

--
Cheers, Lorenzo

