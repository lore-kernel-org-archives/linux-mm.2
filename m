Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B28606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AsHi/Qx2
Received: by kanga.kvack.org (Postfix)
	id 679EA6B00EF; Mon,  2 Nov 2026 06:17:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651C96B05B7; Mon,  2 Nov 2026 06:17:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5675D6B05B8; Mon,  2 Nov 2026 06:17:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 363696B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:17:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE5B580C0F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:17:37 +0000 (UTC)
X-FDA: 85389928554.07.69AD54C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3C0634000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:17:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AsHi/Qx2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98mtjjP6T0N40qxadFzZsPcAOe5fNReHRi+qcwE7x8c=;
	b=dSDbUtAqsqMpR3C2OQy25HRZ31S88MM/J8B+IARBqyuoYIZgMaEA9bIWUsrVHv6TZtIi4c
	zLMZanKtE4hMJTITv2eg9z498h1n7+ApfKC1FFv3QRTxlwD5j1VPziT52HvIppTDeOAEQn
	yA6IxSzY93qvOXdZTp1STlCk9uxrgKk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AsHi/Qx2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618256;
	b=HweSGvbYtt5+E8JZF4GuRI2BhsDHlzefpN3pdrS4EZrm6CwY3TzfEzutfThpPKMumLSJy2
	IQZESTSXCxZRngV4qdecoww+7yMs8G0n6CqPQjN8fZeT555YKaPtRtYTbPiPvtiMPDiB8q
	65l7u3FbqWfct15xyO5XvWrhPpq7ZRo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5D5660DD8;
	Mon,  2 Nov 2026 11:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E662C1F00A16;
	Mon,  2 Nov 2026 11:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793618255;
	bh=98mtjjP6T0N40qxadFzZsPcAOe5fNReHRi+qcwE7x8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AsHi/Qx2ZHevaNXslSNOm9EKf6X6V0ftbOX6HR1O1Ut/SitDhhtgdB8pDo7eMfdJz
	 c0BmBifEZ2p/QEhYFssHfPNUV/72ECarvL4ZRdk/m89K1jCnQaJbGhAP+3UuG0cINT
	 cXlOZGAzQtYwUKZq21WO1FI/kSBipacfwos7VC6HgnrIodCUHBUgySobjkbZMTf/AP
	 cN6ZRzqzAicSVmLmwBej0HbWhD/P93bxzhCXEqMoCYmhPnEezmQ4GmHfXQXfHxBrgo
	 XDW3qe8Zn4QHNLOh+MCwobqRV/OHvLsuF1LU6ubBC/I2fECjV5FtsKe29vzyiGCIek
	 Z506YYD3O2RxA==
Date: Mon, 2 Nov 2026 11:17:21 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alistair Popple <apopple@nvidia.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Byungchul Park <byungchul@sk.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dave Chinner <david@fromorbit.com>, David Rientjes <rientjes@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Matthew Brost <matthew.brost@intel.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Nick Piggin <npiggin@gmail.com>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
Message-ID: <auhw4mBAqzKU_-DE@gremlin>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <1c46e678-1da8-473d-960e-5aa22d4d7e73@kernel.org>
 <20261101123025.4d8133d5321820f2202c8f1a@linux-foundation.org>
 <1b4d0299-4232-43eb-9229-7d2a2a7ce2fc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b4d0299-4232-43eb-9229-7d2a2a7ce2fc@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3C0634000C
X-Stat-Signature: o3h3594i88pzkg55qka1katn3rohrohu
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793618256-710909
X-HE-Meta: U2FsdGVkX1/Zl1gcZ8Rg13UPhtaV6sqg4QX1WSdKI+2EZs6ewBLbDOdXHkmFZb36uaHz8+IUvqB8yNl/PNoyzRSDRVowUwAnAWfEwLtCgOfU2hTjsLmJg7hsomfHPrzBr9EX3r/HA0KrExTsI7p3etoFJq9zO5uCni+rz+tbvKO/igLdQrzhmlL0LI3QJPb0bz4ShVPON+yA/aYwDQ6LBSrhudOWIxYh2QVvJxEdTATUlNhhG0R0dtE/oNdsI4eJ12lJo2PE/vU2I2PJqiYG23epQkoTk2D45S6YlubDr3okhUq9Z3f922zFeeqcIli6lt7XzkmNt3ln4ZtV/FBTbaM2G7rqunL4bIO51Q1FPEl+tzqe+75ClLtZi/OwC/AJESLRDVk6UMKdW7NN+pWCX76ADovps5uY1cCaOy3oVA56H/39Bc/awztjyJm+Q4F1UXFVabC1xiobbKhmYiKtz3+ErJ/PgzsUev6Pk6rnXSI+Oi00rFUvoafoGTfuEP9WxQ+3yskQfzGdSEn0phVNmlfh5niQZH2AJYAlN9BETrK9Bs7gDAi7ZVSkkEGYxao4VavSFWiI2fFvti42+FmvhB1o9a9y7m78heFzYATSnsOLF6RGr7jlRiyGJwg9hkKAmx4T3k/XpSImvLhqxyBXuO78ARYvqx4ihMOezmn8gvlVq/+rLZxqbrPkMMl7Gss8g0pNE8NStk6/6+pBb457fGqSi194Dvri8TwfQK5Q0IfO3hy7VTkY1e2hvt+kJ65K/AB7c71wYXUc8rXsQNPg+gcFiQqlxCecpd6DReeubdjN19LfzSlDajizecrfosu/vHjGXz7fqdqMQBBwG73xLOiG5LlqBSmApWUO3eMnrON0YNimQsmvpl8a5y081x9vlvLq63XckhLqLKq+0hcyYNWU80DlzQxzebs+f6A283o2q47XgvzJqMrnnkup6QnW9YuAVKZAAA4MrzKE5kI
 U3J53w18
 OAQjJXAU4xuDnqFYJwkq9KXO5N9pilE53p4bf3QbTBMTGpRijUK483r+O2sRW8sv9TiaQZL2sHv0BGCs9R9K/YpaozfDR+AdveDTbZggaO+0TfksCHRpVOAUMPwPIeLPCfp54jZ2idoNRruMnQt3/RdpNnYjbyQANXOYR6jHQ0AuHw4Sj//0KGqwJmaZiOrNCK7nAjtT2tmSb6mTmNGoMYp6A54wS4U0Z8ZGIje6IX1NpYmkfM78OHOeRJVyYv3sigEPTRE4yidOO63JUma0/EOOfjNpB690mOAww/Y5Y7P/Hu7goa9nh6HDJxvA6MqG8zVUf7mt8wKIfx+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 07:47:46AM +0100, David Hildenbrand (Arm) wrote:
> On 11/1/26 21:30, Andrew Morton wrote:
> > After that I need to have it whack away at selftests, shudder.
>
> I am not convinced yet that we want that for all tests, which is why I left it
> out. There is too much churn that's not really relevant for a component
> maintainer POV.
>
> I was rather thinking that maybe we'd want a MM selftest component (likely for
> the later MISC maintainer) that picks up the usual selftest churn. Component
> maintainers really only have to be CCed on functional things.

Hmm, but some of these tests are establishing important invariants. I wouldn't
want somebody fundamentally changing what the guard region tests do for
instance.

On the one hand the churn (especially now) is annoying, on the other hand I can
just ignore mail I don't care about.

So I vote for tests staying with components.

--
Cheers, Lorenzo

