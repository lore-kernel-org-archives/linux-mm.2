Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43F73C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37FFF6B00A9; Wed,  1 Jul 2026 05:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356BA6B00B4; Wed,  1 Jul 2026 05:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2943C6B00B5; Wed,  1 Jul 2026 05:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 038906B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:11:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7ED7E1402B6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:11:09 +0000 (UTC)
X-FDA: 84939638658.09.C796860
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf03.hostedemail.com (Postfix) with ESMTP id 306B320002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:11:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=otUVHkUn;
	spf=pass (imf03.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782897067;
	b=r6nVtl1hdQD7g9+9pfAv0dAH39ilRKS7jZNDPLdRgQ5V7NOi/zrL4GnTiPzp3r2X3CxMBJ
	dxk/oX3vSqkmhycKNKt3sc1rEB/aMtrjN3y1Ip8CKEYJybCcmxlcev4Eby5RD3vL2dpTVO
	DvhjV1nxcIPaiTfP7ghfVBdI2Yfz6x0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782897067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRLxtG/kc8K/XUw2VuO3ZU+13HZ3XTj222MJKdjPSm0=;
	b=qVNWM1ZjNgODUP5UkYzHwNoOhNncZ12PUM68DmsiC9qdybbpoXQj4RqWL4EdFo/5UPovRC
	e2k19sJIlpGLXLXA7BSxkOT6xOgLX1PjBVp756K5Wpf3KknDJurpfQKToolQlyEO2ZEPAD
	bPHfYbvNwuSe4pLTs7WrMHX+gaNopTo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=otUVHkUn;
	spf=pass (imf03.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782897063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yRLxtG/kc8K/XUw2VuO3ZU+13HZ3XTj222MJKdjPSm0=;
	b=otUVHkUn2Guey0Wvyu2MA1B4h8xq2ByQDfQCYsdwAZjvKqm3ZUE4SIRI4A5DKjVE8oZTp3
	QnNLAOZIrM+lu8Mts/B6GKJc+M371Y9Gq06sdfyiXdCYAFgzTwbn2tW3BuPNSkT83QSRxq
	VVEiQsEgWeXrkAgpooWxsVQOjLwWv58=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 01 Jul 2026 09:10:46 +0000
Message-Id: <DJN497WOOX18.12R5SMHHVM9N3@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Hao Ge" <hao.ge@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH v3 16/16] mm: remove the __GFP_NO_OBJ_EXT flag
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-16-57bef0eadbc2@google.com>
 <e0ae6be7-4e45-4c4a-9663-a87fb260564a@kernel.org>
In-Reply-To: <e0ae6be7-4e45-4c4a-9663-a87fb260564a@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 306B320002
X-Rspam-User: 
X-Stat-Signature: c65fahsafyuq9ty58bp1kp5d9qtxaien
X-HE-Tag: 1782897066-797394
X-HE-Meta: U2FsdGVkX1/xOm5pA+4RRAAyctw/Vu6u/IzxuymarBD1dD+HJCOhr5IdKMrXI7tK2s1UeQG/xlqFLp44bDFclNYdGIeMTyd9y97cOSuMbi0pALShOL0RC5D5Z4Ak78KgQ/NRaB0vp7+dh38MXM7IXun3Ea85PeFhfSXyGEJjiWZrkivkRXZk3LhaHO9Y+XqhjS8KpF4D+yjpid3OcrnC3N86ma/5Tpo1DIdp2ZnkMXXCetxOiWvIpDHZD5g+WLn9ht7u3ni+zPHH+BytTYKm7EVqEd7MLg65F1eaLFfOLAM8v/rdGRa876a/zwT9YHpPMyX6KiqyWu9iaAY6m+cEqMDhKS9Wlj5kFP83X7UOMzX/aSRefy7adZNqeofLJR52/drmPHTa77CumMI4rDp5PKwYQFVvBFVvRLmRIP7PSCRgRNSWPZvrkCFzvfacusUaewQsvz3aTRfKkjVjVp6gU8HKGCRWz0sRr98lczxneZY2E49phpAGHWnfzhHY9bs4zbzf1+uUWCWZKE/CLed+5WOBhUY+H4jXBDBTgRqXhkuMK/ZBvMUqErWVH0CezgWpRh6nUl5ADCLPM+OFJ0VZXitIToDvgOr5/5wGWiPGKna8BT43RBsJVqvtPtXCC0yxMUSi0IWO/Ll7LBAxgQaluRaJ//TImpZ0uZU2SRkvMWHJrtAy71AJntJSE3segD6FhmMOOJMCPfBdR9t8e1ymtAShoSNuJ63uqZMHK0ztfn3BYNzbjdkrI6AoCeDtIvOl+bMoIhmZawkRJ8wVTr2MFzBhVu4wqjpodsXcLWDWVvNkKYtYW4CHxd3sBsCXvxrDvt4v0gIRHscpMrbWsKt57rS7IkAMWcNAN97ciuDE32uAFSQ9/bGIePds6OPorbLw2I91T0ZB8YfCoEnVczHdIctnJFWJIG8et/mzYYeqaykFkw5FIrbrzHEh1WZL0I1SV58Mn/9hdKNNFJBMMZj
 FnspvHrk
 aKiasfw6oPySHBMkczzQiEUtaTb68/8kAJF874AlY4snOmp2dp4xxXm8mHKDbgE+UyYKwP0/qTCY9Z+05zzhy84zHfcaJGV+I9ArflbzgNMEm3JLiczi3a6b99WoHIXpA0mYJ6ZBFluHHdb2oO0YWPhjuYNNKHF3wrvUrE40UrHFvNRt8TcGtoSr4VTIJnAFimEIQ/ZpSlvgnRg5A92s/BUu+vBkdIjjfryr9410/0vK28iNff6FxQP2K4RXR9fVvKJQEhMRyfIAt+WOJlD5dJGYQogCV2S1SzoHf9LzPOIIkbSG9VwqQiXgmiy+W0iNTANapjWWPzG6RFnKwTXXBaXne9RxaMxMRSLONSkZtDF9EzeeQ732ltGnYVK7kqIf7tOl3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 1, 2026 at 8:32 AM UTC, Vlastimil Babka (SUSE) wrote:
> On 6/29/26 15:12, Brendan Jackman wrote:
>> All users of the flag are converted to SLAB_ALLOC_NO_RECURSE or
>> ALLOC_NO_CODETAG (from __GFP_NO_CODETAG which reused the NO_OBJ_EXT bit)=
.
>> Free up the flag bit.
>>=20
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> For a correct process, there should be also a matching From:

Hm, that's weird. Maybe whatever weird idiocy I did that caused me to
not apply the whole patch, also caused me not to set the Author
correctly in Git? Anyway since then I've reapplied it and the From: is
showing up when I format it with `b4 send -o /tmp/presend` so hopefully
v4 will be correct...

