Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A273C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874606B00B2; Mon,  3 Aug 2026 09:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825556B00B7; Mon,  3 Aug 2026 09:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED3F6B00B8; Mon,  3 Aug 2026 09:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 483176B00B2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:32:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D93A406A1
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:05:02 +0000 (UTC)
X-FDA: 85059676044.28.40E960F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 82C75180007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:05:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+nsVYnU;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785755100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSclC3PexhFyC24ms1bFI3qAAPSJzj7fNSSmbcM3kdc=;
	b=i2gmBo5shEI5jh7on7336aXcqogpx/ZkCace2NYbXRTXF5PIho8mXQy80kaMZgq+wWdIrG
	nB5eJiigSvznX8Do6H5CVXTryqxPQHsnP3kInSwtq3KhYD7yAb0W4JXykcu2b07dHMQ9LM
	PZ4kyzMbLaMGYnLJJw2aRKqtvSrxmIc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+nsVYnU;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785755100;
	b=41D4NfSVIVXoTUkIuEfg47vpMaA7/bUpK9fTPnVLgh/ZKB01tvPj/Hjow5L1IZ6mbAdsWI
	/G2Z53OVtsGOzHGQggdMz4WJErpZY+5mmjYGSst425+I7rlWs3jXE5YJOIf4MKhltafdn7
	65UJEyE1+TLuX+zX399ILkb+YySk+Zk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C4CF543FFD;
	Mon,  3 Aug 2026 11:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2641F000E9;
	Mon,  3 Aug 2026 11:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755099;
	bh=CSclC3PexhFyC24ms1bFI3qAAPSJzj7fNSSmbcM3kdc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Z+nsVYnUwqIylKDUiKbZFMu5IoWyM+rHGKWzwxhVTZ8be2ctWc+ho7BRpcm2dKCNO
	 8hMepafUAxfkEECNtSqjgjCk4342A+R+vf/0krTVFmztk50mqcnSvo46uToQHs3lJP
	 ZlnQfGtzHrhyWiMQnp1estwur3gL6/81q5JVuY+VY77mM58mETNeoh+vj2dxnJnN2S
	 TE0rhi1+4tZz7uqYjdeaoGa8+Su2Nv6cLTkYDBsnmFbeL0PWoXS7ntTFblpvD4A/KF
	 VtThhPwcMhv/jloqOxxAcUfcnFnPOHAYsPDhxKWNKAXaF4uggOoQU9jjx59cMX+1Kg
	 shrICogUvxqsQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 04/16] selftests/mm: add order-parameterized khugepaged
 collapse cases
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
In-Reply-To: <20260802195254.1937477-5-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
 <20260802195254.1937477-5-kirill@shutemov.name>
Date: Mon, 03 Aug 2026 14:04:23 +0300
Message-Id: <178575506331.1561566.14498717581313061864.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 82C75180007
X-Stat-Signature: a137p8xso5k13autqts94xk1fjeqmnsb
X-HE-Tag: 1785755100-971989
X-HE-Meta: U2FsdGVkX1+DMeaX2tCXWTWr1jJkIq3cRYOSXb6P/9ORihv/k65OrgqjXnFRzLUa3CEfvXuS1mJDd7bW/Tpvrbh6sJGSRrYhzJKgRd3uY3sbiNS9kNk+IKsJGDW6M84Hm+e2LEk6okuTrYjESXK1BNDm6CrYBEP5m+BEmaLaTtgum5h3cF382cTU2WMwrSq29eXiGVQviqmKoHoJGmR+cMii5TTHEFkMIdrH5I5gBASZJUYkKFFhSB/1Nlpwo4/EJH3C817XxR6RfBkij5RrKcgMgcGXyC5bsWGrTaFrJIWtryHyB1Z3G9FRmedS34gwcYXHUoL6KlJNl7MvIfd/8drzTQps8BRg95LWMXbNz7ZVlavx2+vtPLg3EXe3wlF7u1kts74I4HBZr4wtfhVxFwq63iyTSQHsqXSy6IUXMskmluw9RT56z7ehFpAkLbr3QFbPsghpONDxSYG8U4BU9qpHH8o2EIHoBmeTyVlEXkOkOST+pdwfPvd1DZ30P+ysEQJ0d+KbLxqRzzVM8/C7nHLsxrDc7MAilyNTDebzzD27hEr6/OvqPtIxRFI5QZtGMWNBGz2AM7oYNAfytukjdlxhpObsKf01UMGRloTaOkhR2kkjXLYZLf4tklql73CxqYr2yg43cZDSfrV+MdZ/pma0UFiMQNPEZcV0PdxwfA6bl50yN5YFDmB3iFqNbsQ8cgBtqHdT3v+rHsSABiKOPZfePRLwKJTL47cyua2rrE0gVG/QWiBbcVKZWfESh/PPEZTGh2iWEhevBf0KBRHPdFo2/ycK8IGrcnl8pmNp+ZBdH+EPsZzrV9KMpMrcoD1M+3X0LdKg8ctBryK7eO7lmKrGK9xZVQYpthQtPMpKg9ADbMQZfJs0v4nEWQoUGYriuYGpHFVmM35/aHGzUMlBVywGB4wCMYvdMJYOJWsV8g34/f4K3Gufxg6O7HU0Ar1EkLDeslMc/7k09mwq9QW
 MsCpqVqz
 jiiBiD3qRyVdRYT0XTH0wjaIVoKk4Ii+Tgn7v1QsrEbS4CEa8JqJT7oWwuQXKLVn0OBAfQD5XVHCmQhG8RSCLcPMIqUGJJfP7nRBYZ2y+Cu60u71Pm4UksqTKSrUkInknZO278sbtIkycHEsrX8YeVMIPLh+JhxonYy+HJyn3S2+bYcv5LR6zyat217nh3kqMAMGyiqOpjbIJjBSC3ZX5Ai8KF4roM98Bc1rP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> All khugepaged collapse cases are written against PMD collapse: the
> regions, the thresholds and the detection (smaps AnonHugePages, which
> only accounts PMD mappings) all assume the PMD-order product. The mTHP
> collapse support merged in 7.2 has no functional selftest coverage.
> 
> Add an -o <order> mode running order-parameterized anon collapse cases
> against khugepaged. The region is faulted to order 0 first (the target
> order is "inherit" under enabled=madvise, so pre-MADV_HUGEPAGE faults
> cannot produce large folios), then one full khugepaged pass is awaited
> via the full_scans barrier, and results are detected per aligned
> window with the vm_util folio-order helpers:

Having options is usefull for targeted testing, but I think that the
default should be to run all supported confugrations, like e.g. cow test
does. That's the point of a selftest: check that everything works.

Can we refactor the existing code so that simple 'khugepaged' invocation
will test everything it can before adding new options and tests?

-- 
Sincerely yours,
Mike.


