Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3609CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 06:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8AC16B0095; Fri, 12 Jun 2026 02:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3B986B0096; Fri, 12 Jun 2026 02:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51476B0098; Fri, 12 Jun 2026 02:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 969A66B0095
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:04:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 29FEF1C3AF7
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:04:18 +0000 (UTC)
X-FDA: 84870220596.05.F30A639
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf11.hostedemail.com (Postfix) with ESMTP id C0DB54000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:04:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf11.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781244256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g4ZENs7xcaxMJZjfFITnj/IGoQky4IzHedjNRXllLT0=;
	b=nWPHAea57qMJvUc+LmndzixA9zht6GQIfrQwzwt1mmdimEQFKjSMQypKM8iJWyfAaNrrYX
	4IY5xwy8UbjGTASJnoXHDe4HygEb0OkwMIzLvDiJWMNlYJL3WROWX2tTnfHiwY4kb9h+iC
	TVBygOf/+Emqsti0KMjUqlVlxltcY9c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf11.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781244256;
	b=NU9F0EOQQ04z/8+xQk/q8KtJictoZh2WvhYaONBbmGipk3dBZM9CUe0weneIXkiTaaYcNx
	8FQpGiVae4Kj7HNFB1zpnXsunqCJonJEE9YbmMOGa1Gx4u/uz/jTnDVsI057/fYYdxe6LJ
	6sggINVqhaN0TOB9W/ki0Vc0Z4yTtNs=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gc89067rlz1dd8B;
	Fri, 12 Jun 2026 14:04:04 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gc88x6nQCz1dd8B;
	Fri, 12 Jun 2026 14:04:01 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 777DC7896;
	Fri, 12 Jun 2026 14:03:43 +0800 (CST)
Received: from hsj-2U-Workstation (172.19.20.61) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 12 Jun
 2026 14:03:57 +0800
Date: Fri, 12 Jun 2026 14:03:55 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: Lorenzo Stoakes <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <surenb@google.com>,
	<mjguzik@gmail.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<shakeel.butt@linux.dev>, <rppt@kernel.org>, <mhocko@suse.com>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <linux@armlinux.org.uk>,
	<dinguyen@kernel.org>, <schuster.simon@siemens-energy.com>,
	<James.Bottomley@hansenpartnership.com>, <deller@gmx.de>, <djbw@kernel.org>,
	<willy@infradead.org>, <peterz@infradead.org>, <mingo@redhat.com>,
	<acme@kernel.org>, <namhyung@kernel.org>, <mark.rutland@arm.com>,
	<alexander.shishkin@linux.intel.com>, <jolsa@kernel.org>,
	<irogers@google.com>, <adrian.hunter@intel.com>, <james.clark@linaro.org>,
	<mhiramat@kernel.org>, <oleg@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <riel@surriel.com>, <harry@kernel.org>,
	<will@kernel.org>, <brian.ruley@gehealthcare.com>,
	<rmk+kernel@armlinux.org.uk>, <dave.anglin@bell.net>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>
Subject: Re: [PATCH v2 1/4] mm: use mapping_mapped to simplify the code
Message-ID: <aiuhS4iyBxx6Kcag@hsj-2U-Workstation>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
 <20260611061915.2354307-2-huangsj@hygon.cn>
 <airZn524Ip8VsWra@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <airZn524Ip8VsWra@lucifer>
X-Originating-IP: [172.19.20.61]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: gic7bmx4iofiztcq4o6u1i7gptdruac9
X-Rspamd-Queue-Id: C0DB54000A
X-HE-Tag: 1781244251-674855
X-HE-Meta: U2FsdGVkX1//joGKsHf8M4+VwGrF9qiFLmSDpTNGWRWKWCbR6ZvV4UtOkJyh8NKctpsAdf0DTXulcj43Cp61aq2LJBfifJh3w/24Qpli6bFXHfApGIF7uutkLk0/zDCvQTzLvWrEWYWuoq0447QrhZ709A0xmPDjrnpxWVakm+WzMgIL3p9sPfrBVrLIIOAxS+cvggUB9rzMyzd/D3R3XQnj0KPbPBFAIIWfJcdz1VY4YSfKRr12lsXEZsR9E0aIYejmCxzpM1AOLmbN0v/6WtrkD3JgzZ8Dr4ecam+Hfxd1SzKJqK1yIJ5jj8LYgXTTwFwSxHLjGxsvSt8ThSKXAOL61pYtHkHAQGb1Ysw3LfpYVCXLv+VwrtZHIUKDOMi6ens8v6ccfr64aLmceAMLf6AnSIzgqweT48EBTUpRx7X06oSLNjzgmca3QUb8bMbaWtLorlPcMjCdL4t0ElrPDZ3KiWh3sNQDageQOoySH8mUh2LTDyHGXKiuLGTU9CeVK8UUeUtYovK1cTpkErf1E29APGnRdmImrNCV0qLWhmHzX9HaBGc5bpWR2ZBWevNBjpOdpqEYmHOeVznTsYES14SKzHwEZWL8aM09I7rwLzqAr+Erq4BncAKaLY/uzhVD73UShkZrs1OKV0zIitThAHYA9Uj15ueYiiyFQwvyLxzduS53cp017VGxlCHP+kYQWypMyt6X0nGVksJBjgGiAj6QYG5Ji9kRvnLxHlQnvhzJ1HSsc1qFlgjahLucoNoCee7sZs1yuJYU4tgloDHEbf4EWeR1Iimli0ynvPCQWuNAx+V/wtLRDW385indnmEB3CxEFlm2HvVJsoVfZmbYsV+Mk43JWRZXDNuEdfgBG/7IAgTGObFYN8EL4AzcjLfEO3z1vpXp+aGc7EAJ9PKyl6ixL4HPDTh86/1P45pHoRyUgKwGhpVrs944sO5wQOkb/QPu52J+IW3Lur7Qbul
 KKUIJ9CF
 PE8TlsdhNAF5xp6qz4dN6RNzvaVEymbMbx4oQMkyuUnDD3DwSEfOj0pebu66WV2/EMH96oD0dKwCCnIoRW51+tZCU5lefAHomKS/MlyK8PaU3ODvj8SZe3W9wug71CsM1zAD+y0e80o/r70V3o84ec6P6tpBy7eG1WPNOeDm1Rq/DTyh1d/HNJRFqbNqG2Yc3U9fD9vEhZN4b/HGwNHZ4R64o8rfgcz11/i+1cisy4QeWEqzJsHcw+EZhmI3zvAI+s/daqHZdybLZdXlVUqryV/Z/dacyUtChaPmP34+nTy3i76i0WzW5cFumO6Tr+TVe19AorR5ttFZniLpKNIK8W05JXrBVgN0l/wBI+G4qH0njjF2+oFrgOEy4RpBhUwCZdmIChoFL4VKyBm2OK+ZKoIqE6TkYpu58CJ2J/LcbTQMzJHErCQ9Oijdfz3LLYsbN4Q/SeBHe6BbjtQBjGceQSrHVuJIEr0NuGBA54VKdsQSWTKyZ0Xs2GHn1ZjP13rFp/wiYU1z7mt/Sf9gOzD2wYlc3PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo & Pedro,
On Thu, Jun 11, 2026 at 04:52:54PM +0100, Lorenzo Stoakes wrote:
> On Thu, Jun 11, 2026 at 02:18:57PM +0800, Huang Shijie wrote:
> > Use mapping_mapped() to simplify the code, make
> > the code tidy and clean.
> >
> > Signed-off-by: Huang Shijie <huangsj@hygon.cn>
> 
> Yeah as Pedro said this one could just be sent separately, and I in fact
> suggest you do that :) So:
> 
Thank you Pedro and Lorenzo.
I can send a separate patch later.

Thanks
Huang Shijie


