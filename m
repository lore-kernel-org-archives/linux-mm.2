Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D105CCCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 02:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00D018E00DE; Mon,  3 Nov 2025 21:47:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24488E00DC; Mon,  3 Nov 2025 21:47:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60D48E00DE; Mon,  3 Nov 2025 21:47:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3B598E00DC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:47:46 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8260813AA2C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:47:46 +0000 (UTC)
X-FDA: 84071389332.27.5B9F12D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D8EBEC0008
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:47:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ulXY+Dx0;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762224465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1ozK2WLgGus5MRn1cDh8wVhYS2nt0ltlERgXG+Ih80=;
	b=evorENOkJ8RgwMJO+RaRBG7h2YLfxahdlSU+InMuMMwKBh984TaMXzvG4fuqq3lEq6dkyT
	T65OXHTLXNUMG021m0fcPZCKnd6Pk0wx4qF+xaY2X/RMPonFrTfFwybObOEMbrXlgGVj3L
	nSH7fTgU3uS6ohy6PmcDKIafQ1Li/I0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762224465; a=rsa-sha256;
	cv=none;
	b=G41VIyiSUMuFAeDp6wwLPfCprSuy4Sg3GctgfKv5UPk2MTf7WLUe8BO6FuadYU27ADd6VG
	OO66IxoEnGa4644lKrOgoxaVsBoJQZ4NBZcGtGc+ETIZJls2+uMtRxPYVUWlg8QhTE/zFj
	+EpFo8Ubd9h2whoBCZ1XWBctT0WoUf8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ulXY+Dx0;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 191D9601E5;
	Tue,  4 Nov 2025 02:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB6DC4CEE7;
	Tue,  4 Nov 2025 02:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762224463;
	bh=Aq0A4s+Uy/ELDjmPRsdvDGJIZkiNPNcjd+vWWv0awuo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ulXY+Dx074aqU438BK/rGe0ov/CSzMgaQbm+CTcEmwZDGUg+PqhGSMSrkIzjumw/E
	 66czt4Xn8IpTygJ7r0A3dM0xxQIoI7FepogiQXjQ882RimY4Z/ZtvC1aiY1jOsZYsO
	 +Kpfaz7P8mz13jPg4WStd2QCIDp+e3Yw+NyesBfw=
Date: Mon, 3 Nov 2025 18:47:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: <ankita@nvidia.com>
Cc: <aniketa@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
 <mochs@nvidia.com>, <skolothumtho@nvidia.com>, <linmiaohe@huawei.com>,
 <nao.horiguchi@gmail.com>, <david@redhat.com>,
 <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
 <guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
 <kevin.tian@intel.com>, <alex@shazbot.org>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <zhiw@nvidia.com>,
 <dnigam@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
 <Jonathan.Cameron@huawei.com>, <ira.weiny@intel.com>,
 <Smita.KoralahalliChannabasappa@amd.com>, <u.kleine-koenig@baylibre.com>,
 <peterz@infradead.org>, <linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no
 struct page
Message-Id: <20251103184742.441e98e93c5ed36320c4f41a@linux-foundation.org>
In-Reply-To: <20251102184434.2406-1-ankita@nvidia.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ro387p44wfuhorpd87woisdgfh4hmt6g
X-Rspam-User: 
X-Rspamd-Queue-Id: D8EBEC0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1762224464-432623
X-HE-Meta: U2FsdGVkX1+2ayrklzze9dSGnGd6TTBnkJKtRSIE2tUBni/Y5iWYizyjGGzjSvSzuxouqehsMYZOpmLqjhDnVDO0I/WkzL7jC6NRIdky+5UyLQGSeUdjUVtwd+0z2pmkPI1ZACDo6syUzMLO4h+pgnb4WCsKzkMb5wzkUVzvXmKJxmbWq/x7otqs7xK42Xb6Bv0dwDSerHFmqVF7u16QdkKC7kAmDr3+ulJiLdFpt7x/2dMmvQZvWM+SKLLsTFaT+q/iTV7Hbr21Hjn8JMW2ipcRi9UbneQBCtEF2SAmurgf67GM31t0/jKhVMZ9Yx5+4sxSg89a9uYsyjypUIIgA2VvX7eTn31Qpq1rmAJW5hStt4asVNQj5QkieCWrAvzKf9VW2HLrEmhcom2ZYTardjADk2Sn47DCO7PihyVtegap4se6dpWPAwKG4Bf4SPV7IHmNpty76S7Ys/aV/P0tGoo+fH4Y1InSwvUJlbbfmhtxnoecVWVpJw1/D5fNJkOmu5XwgLkdCDb0LhhD0T4fwhaBDKNNlIJqVCoFoQNh4LK06sQzndLjOXwnNTFWmlSHylNQfAAD0tmsn9B+g+BmoFV18IaG0ECMqA5lbpq+HZrbf0NEur9Qv41FGgaFi9J6NF3xJ3tVqd+uEaHaajF7X/vWeHs9cjJ3uauu1ybIEChbKF1JXCbPWaUba+on61Q39AcK5+p9TbzTPqfI41srzRtJOdfK1hHcrf1cpxhH1b4UCAqngJkXf94Ok7X9j9ZfqkyKCm6JL0e7/ph/hpLXiUjgPffu0XR20fZZ+AXf21IOlbSNs7QELuOsq5IuVqKsJ7cd4f7Ukm8mh2zb5YFoyHeNqgQhFUUs20MQVmlDD4fV4Wo9P8exo9Nxf0bTOrZSXXN6py1xjtGy0sZkJJBIWmbEQ669n7NsPojKnNLiMsQCmhGRdctJmzaZpj4TdjUulRQ2psTurKc8I9LVQyY
 2rlEZSEc
 QhJsYTAxirrudjKzgr6vuEzjzH3hW3qSJJ9EPbgcPTmba+VdwoMJrBLBR178impM2rTanhcY007acupXeUaQTDNvj34duFZQQPleuc7wBkfHqL7brDUR/pHG1Qb53gtszrJxqwaX/cePCOwAi4UXezBA8wQlL6E5lM5fw3aUKAqCbxAffyMb2jCWzZn/xpqLTu1N7oTbD1JT7FrdY0egBb9OLDtIHF3hZc4EnsvGaulv2Jg1uNspVpx6W9I7iJYw+cf1Sz1L8T74YwgkG0YVQ6sHeS6qh8/OdyHS68qlj5dNJMRaYwg2cp8duYIe9NFhFC0KOmIMifuEWQP8u4UKGGUG7uA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2 Nov 2025 18:44:31 +0000 <ankita@nvidia.com> wrote:

> Poison (or ECC) errors can be very common on a large size cluster.
> The kernel MM currently handles ECC errors / poison only on memory page
> backed by struct page. The handling is currently missing for the PFNMAP
> memory that does not have struct pages. The series adds such support.
> 
> Implement a new ECC handling for memory without struct pages. Kernel MM
> expose registration APIs to allow modules that are managing the device
> to register its device memory region. MM then tracks such regions using
> interval tree.

Thanks.  My knowledge of this material is weaker than usual :( But the
series looks good to my eye so I'll toss it into mm.git's mm-new branch
for some testing exposure.  If that goes OK then I'll later move it
into the mm-unstable branch where it will get linux-next esposure.  At
that point I'll monitor reviewer and tester feedback (please).



