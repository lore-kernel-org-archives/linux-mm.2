Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07FACCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 17:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D34E8E0002; Wed, 10 Sep 2025 13:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9C98E0001; Wed, 10 Sep 2025 13:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF5A8E0002; Wed, 10 Sep 2025 13:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0AD1C8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:51:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD492139308
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:51:06 +0000 (UTC)
X-FDA: 83874081732.25.6E8FBEC
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5B2E120009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:50:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=hpe.com header.s=pps0720 header.b=DgTe6o5R;
	spf=pass (imf13.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757526664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/geJMzrD/stAu84GwKoohScKyZtKCpH1bmIPC+CipSA=;
	b=qcfTmV9cvTlV+yYy4XMTGO6QUXAiUyK4OJDvDHJtjGA7a1FBpAOu2+LHtT89VC/DmFZY9P
	riReyBkwGQh793qm0/g4+eBKyayLsdoP1jC5Nx0mGMuxEaGTGYUZLssjge+WS9o/GCmboL
	EWJoF9dixPddSFQ2PkxpUZbVlZ5d4LE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757526664; a=rsa-sha256;
	cv=none;
	b=WA+6hBLY7tRoano3sz7xyr338WBaRvV4fcLGjUaKBU3TKNa3+AtNgbjzN1RvvApfdc5MqG
	Hv3FZ7nJ//nW7Y3Cw+wOvczw2rt9YeNvbfeW+rXsvz5TEW6LhnENTBxnSRdThysS2d95Yl
	HSmof6NPpq00LIuatoyHLnjdXtGhF84=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=hpe.com header.s=pps0720 header.b=DgTe6o5R;
	spf=pass (imf13.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58A8X3fW019889;
	Wed, 10 Sep 2025 17:50:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=/g
	eJMzrD/stAu84GwKoohScKyZtKCpH1bmIPC+CipSA=; b=DgTe6o5RviA2xUGFlw
	9GQjI4Kd3KwBC0VZriEmVdQlIMCYRHby/V4q+bmpkqrBt/USkrKGwByxWsTjhDQo
	GYAQHzDpAol8ln8jQ+8be/wABj+Q56y2Fe7YT+0OrZYUOWYQKEJH6aayZuxHKaPG
	citMYwtAATrDEO3vLDMUJuGrbEdgMQvMpiT5PFoepx2MlFscwc9pPbYTovshCJK4
	tGa9BiEnSbyyjd7qP8zRiM9orGoy3uKjp5/VXBTR5Loepkm/r91cur8HXFH9bBP0
	kKsUYDmN0Lgepwp7kqyWAyO+b+1S3STyGE9jCs8EYsOQZhJgkUe7ru6H9Fzf8Txq
	jEzQ==
Received: from p1lg14879.it.hpe.com ([16.230.97.200])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 492pbmbht8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 17:50:08 +0000 (GMT)
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id E781A132DA;
	Wed, 10 Sep 2025 17:50:06 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTPS id BCD60808B9E;
	Wed, 10 Sep 2025 17:50:03 +0000 (UTC)
Date: Wed, 10 Sep 2025 12:50:01 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: akpm@linux-foundation.org, corbet@lwn.net, david@redhat.com,
        linmiaohe@huawei.com, shuah@kernel.org, tony.luck@intel.com,
        Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org,
        jack@suse.cz, jane.chu@oracle.com, joel.granados@kernel.org,
        laoar.shao@gmail.com, lorenzo.stoakes@oracle.com,
        mclapinski@google.com, mhocko@suse.com, nao.horiguchi@gmail.com,
        osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org,
        russ.anderson@hpe.com, shawn.fan@intel.com, surenb@google.com,
        vbabka@suse.cz, linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm/memory-failure: Disable soft offline for HugeTLB
 pages by default
Message-ID: <aMG6SRckMsnQH7ov@hpe.com>
References: <aMGkAI3zKlVsO0S2@hpe.com>
 <CACw3F50yTvMphcp111Qzh3PKm+FYoXX9g_sLpV5TPuubqK2+Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F50yTvMphcp111Qzh3PKm+FYoXX9g_sLpV5TPuubqK2+Qw@mail.gmail.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA5MDE0NSBTYWx0ZWRfX70fGiEohJ9bP
 lIvn92CIdAh7lj4EcZGMnRtHE+i1TJkGazCcTQ3KuwLV1yjg+5JMJhdnGK61fDEBWZA4mRSfWv5
 wwjvJEAcdRsP+U7PaPjSej75ufZDgAzBbQywpi+6w3r4fL61VZYH4om0OZxO4re2+QZdsnePLiA
 O/REblox6VzhnCQ4Ju6r/ljAhowDTyRvSJt6SiplkP7JRKE/w03OSuQ2s1QGeHrvZv6Rna9pPw7
 RRJBOplSqwwdgwOs6/eOJJGt70pVZfIylDgk5kHeIA/JHNOrxRh0zGxBYDclObgjYRUic3+5nHl
 6DLW6iAupZgv8qYRC75kR4NlBZbSjlNUs5v3u0WdvCdqSpaVCffZYUYk2r0bFBxuUWrWazpDgGY
 xi5hsyTB
X-Proofpoint-ORIG-GUID: sapQoHVJmJuz9U7H9ppYAnZnn-khBFFJ
X-Authority-Analysis: v=2.4 cv=AOzi3l3A c=1 sm=1 tr=0 ts=68c1ba50 cx=c_pps
 a=5jkVtQsCUlC8zk5UhkBgHg==:117 a=5jkVtQsCUlC8zk5UhkBgHg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=MvuuwTCpAAAA:8 a=jDLjrVBNiWNpbI7x-vQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: sapQoHVJmJuz9U7H9ppYAnZnn-khBFFJ
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509090145
X-Stat-Signature: f1atq54aiammaiut9pcjbwwxdyfzj1qm
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B2E120009
X-Rspamd-Server: rspam10
X-HE-Tag: 1757526656-42010
X-HE-Meta: U2FsdGVkX1/qp0J9r2QpVntPOz0BUVbIPuCv6ep83FoHqAqzmgIxLum3d3376wgsU4rEPp2cefya1qCZdZVPEUAY2IDhAf/eu36RiAk4Z22O9j22clmOBI0y/3ts+mtc81eFApxOSJV/RGOZOKqa5EvsZMU54GYJ8n8bX1IhYcJmMullkfFFo7/5G6GgldOuDJhcydC6vcxKpb7amW4mMU9GwLtqC8XNXDiNDj8E5fur7oh04ujYjwDJX3hz6ucX8++OXHhaxXUUWROTPr8B12ihxDJfwljXqhxfZbOfP3HZMUU/atUKtJgcJdOEu8QDjxaKEORIDJmnpEA8Q8Rj3zS35ssU1ibM/83gIcu2Ik6/2QgjiuBSe8n7uxoao8z+jH6XJDvKmWHhwUitMVoQBSyTdzri/e8r4eSKllmYGJCJHc9gVVarhuA5hFJOQVkf4Z/SOqUelviuvwZv8cmM9Oa2B7ZeY4CxyCQEZ5jKfFyeJkz0TGsPnEgqMcrlePMT59ZOw+h9j+frpUPWRRxke/mf0E34QzezqctHknpOGGjeswFrLRc9AhkRjN+b6MUtqUYp99C9FYrRm+RbDG9r0MC2Blnq85iJ3xlEmCi5RZgfnmEy6DMcsWyoipiQUPolGEGyZ6Fl/IbgDLZ/nrSA7CXFY8naXzPGSgmlYt+z8UVNyCu0/ntu2D0hM1uIqNYCmroYiOyZUozsknsWKpg0Do7a3WAL9B23vCcOCbTt51fcXeAIVnnOtovRzfco+uaAb5FPDeMn7sYH7r1wPo67LbkdHvYdOvyFSIV9HNckHOr2tJbyG19oYvLU831dThw/Mt6alDsP5ps2lZaBqyq2Otn6w0i5QY831oFVj5UNpfZ6oaAuXi2uCb6cgvtHsi96Oou43QzqaB/1JlhinkCKN5fKm3T9fohhXxPQUhoASVOdQWKNBgFcZqEqXJc5w8vl7dHT8h+h47utm0WfkYq
 UoSgWojo
 ptXwbCg6Rn6m1qhTWOQaMfJT0FubVX4BMxfyM9UEARlGm7iDnAhohNG0MNdl7FeNxcj1gSthceOr740QKd8YNFvr004Q9mdwKiHR0Y1oT9QYhBIqxCIDVVGJDk4ce7YvcfakPmTE+f/ixSq7Lg0HfpS84KxF2ZzVyJZWJ54iqkID1vaEghjaac+8+820XRsFT0Uvl9VGg2UaRHJp+cKoG8+pbqqNdbmxu/IXiTRqRAXC74sGqm+d56uQFz8RaIe7suMkQyItj2lUYt0zmJtbnUFCCfGIsVnknGL/boqs/+eS1qjoGJNMSsgfpoa3J7CyuPbgyy7q+9bYQwpqsq1meQMBvdYKHov1Om47n3A9FhKXHbOQX9bVGWkageVpqte2RLBAfO6vYp+um758C2/MhBQ2lSoBMePjdfnKUU/qnDLQDPzbuau6Jepn4GRyVQsFYP+0C7iK6q3s1Fq7Mle1q5r+wkEMg3F980KHEaW8WpmmTBP9bJF/8TOW49z32mJKVqPinQZit4ZSoxXgUOLbkzKGeZ5b5n/YVQvMgwk1N09Z7Hv62jAaUSllYWANpcVOD4XgjKb9TiV/UOWaUkMLRjlbNnALAeTQOVL0k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 09:44:24AM -0700, Jiaqi Yan wrote:
> On Wed, Sep 10, 2025 at 9:16 AM Kyle Meyer <kyle.meyer@hpe.com> wrote:
> >
> > Soft offlining a HugeTLB page reduces the available HugeTLB page pool.
> > Since HugeTLB pages are preallocated, reducing the available HugeTLB
> > page pool can cause allocation failures.
> >
> > /proc/sys/vm/enable_soft_offline provides a sysctl interface to
> > disable/enable soft offline:
> >
> > 0 - Soft offline is disabled.
> > 1 - Soft offline is enabled.
> >
> > The current sysctl interface does not distinguish between HugeTLB pages
> > and other page types.
> >
> > Disable soft offline for HugeTLB pages by default (1) and extend the
> > sysctl interface to preserve existing behavior (2):
> >
> > 0 - Soft offline is disabled.
> > 1 - Soft offline is enabled (excluding HugeTLB pages).
> > 2 - Soft offline is enabled (including HugeTLB pages).
> >
> > Update documentation for the sysctl interface, reference the sysctl
> > interface in the sysfs ABI documentation, and update HugeTLB soft
> > offline selftests.
> >
> > Reported-by: Shawn Fan <shawn.fan@intel.com>
> > Suggested-by: Tony Luck <tony.luck@intel.com>
> > Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> > ---
> >
> > Tony's original patch disabled soft offline for HugeTLB pages when
> > a correctable memory error reported via GHES (with "error threshold
> > exceeded" set) happened to be on a HugeTLB page:
> >
> > https://lore.kernel.org/all/20250904155720.22149-1-tony.luck@intel.com 
> >
> > This patch disables soft offline for HugeTLB pages by default
> > (not just from GHES).
> >
> > ---
> >  .../ABI/testing/sysfs-memory-page-offline     |  6 ++++
> >  Documentation/admin-guide/sysctl/vm.rst       | 18 ++++++++---
> >  mm/memory-failure.c                           | 21 ++++++++++--
> >  .../selftests/mm/hugetlb-soft-offline.c       | 32 +++++++++++++------
> >  4 files changed, 60 insertions(+), 17 deletions(-)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-memory-page-offline b/Documentation/ABI/testing/sysfs-memory-page-offline
> > index 00f4e35f916f..befb89ae39ec 100644
> > --- a/Documentation/ABI/testing/sysfs-memory-page-offline
> > +++ b/Documentation/ABI/testing/sysfs-memory-page-offline
> > @@ -20,6 +20,12 @@ Description:
> >                 number, or a error when the offlining failed.  Reading
> >                 the file is not allowed.
> >
> > +               Soft-offline can be disabled/enabled via sysctl:
> > +               /proc/sys/vm/enable_soft_offline
> > +
> > +               For details, see:
> > +               Documentation/admin-guide/sysctl/vm.rst
> > +
> >  What:          /sys/devices/system/memory/hard_offline_page
> >  Date:          Sep 2009
> >  KernelVersion: 2.6.33
> > diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> > index 4d71211fdad8..ae56372bd604 100644
> > --- a/Documentation/admin-guide/sysctl/vm.rst
> > +++ b/Documentation/admin-guide/sysctl/vm.rst
> > @@ -309,19 +309,29 @@ physical memory) vs performance / capacity implications in transparent and
> >  HugeTLB cases.
> >
> >  For all architectures, enable_soft_offline controls whether to soft offline
> > -memory pages.  When set to 1, kernel attempts to soft offline the pages
> > -whenever it thinks needed.  When set to 0, kernel returns EOPNOTSUPP to
> > -the request to soft offline the pages.  Its default value is 1.
> > +memory pages:
> > +
> > +- 0: Soft offline is disabled.
> > +- 1: Soft offline is enabled (excluding HugeTLB pages).
> > +- 2: Soft offline is enabled (including HugeTLB pages).
> 
> Would it be better to keep/inherit the previous documented behavior "1
> - Soft offline is enabled (no matter what type of the page is)"? Thus
> it will have no impact to users that are very nervous about corrected
> memory errors and willing to lose hugetlb page. Something like:
> 
>   enum soft_offline {
>       SOFT_OFFLINE_DISABLED = 0,
>       SOFT_OFFLINE_ENABLED,
>       SOFT_OFFLINE_ENABLED_SKIP_HUGETLB,
>       // SOFT_OFFLINE_ENABLED_SKIP_XXX...
>   };

I don't have a strong opinion on the default because there's a sysctl
interface, but that seems reasonable. I'll wait for more feedback before
putting together a v2.

> > +
> > +The default is 1.
> > +
> > +If soft offline is disabled for the requested page type, EOPNOTSUPP is returned.
> >
> >  It is worth mentioning that after setting enable_soft_offline to 0, the
> >  following requests to soft offline pages will not be performed:
> >
> > +- Request to soft offline from sysfs (soft_offline_page).
> > +
> >  - Request to soft offline pages from RAS Correctable Errors Collector.
> >
> > -- On ARM, the request to soft offline pages from GHES driver.
> > +- On ARM and X86, the request to soft offline pages from GHES driver.
> >
> >  - On PARISC, the request to soft offline pages from Page Deallocation Table.
> >
> > +Note: Soft offlining a HugeTLB page reduces the HugeTLB page pool.
> > +
> >  extfrag_threshold
> >  =================
> >
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index fc30ca4804bf..cb59a99b48c5 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -64,11 +64,18 @@
> >  #include "internal.h"
> >  #include "ras/ras_event.h"
> >
> > +enum soft_offline {
> > +       SOFT_OFFLINE_DISABLED = 0,
> > +       SOFT_OFFLINE_ENABLED_SKIP_HUGETLB,
> > +       SOFT_OFFLINE_ENABLED
> > +};
> > +
> >  static int sysctl_memory_failure_early_kill __read_mostly;
> >
> >  static int sysctl_memory_failure_recovery __read_mostly = 1;
> >
> > -static int sysctl_enable_soft_offline __read_mostly = 1;
> > +static int sysctl_enable_soft_offline __read_mostly =
> > +       SOFT_OFFLINE_ENABLED_SKIP_HUGETLB;
> >
> >  atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
> >
> > @@ -150,7 +157,7 @@ static const struct ctl_table memory_failure_table[] = {
> >                 .mode           = 0644,
> >                 .proc_handler   = proc_dointvec_minmax,
> >                 .extra1         = SYSCTL_ZERO,
> > -               .extra2         = SYSCTL_ONE,
> > +               .extra2         = SYSCTL_TWO,
> >         }
> >  };
> >
> > @@ -2799,12 +2806,20 @@ int soft_offline_page(unsigned long pfn, int flags)
> >                 return -EIO;
> >         }
> >
> > -       if (!sysctl_enable_soft_offline) {
> > +       if (sysctl_enable_soft_offline == SOFT_OFFLINE_DISABLED) {
> >                 pr_info_once("disabled by /proc/sys/vm/enable_soft_offline\n");
> >                 put_ref_page(pfn, flags);
> >                 return -EOPNOTSUPP;
> >         }
> >
> > +       if (sysctl_enable_soft_offline == SOFT_OFFLINE_ENABLED_SKIP_HUGETLB) {
> > +               if (folio_test_hugetlb(pfn_folio(pfn))) {
> > +                       pr_info_once("disabled for HugeTLB pages by /proc/sys/vm/enable_soft_offline\n");
> > +                       put_ref_page(pfn, flags);
> > +                       return -EOPNOTSUPP;
> > +               }
> > +       }
> > +
> >         mutex_lock(&mf_mutex);
> >
> >         if (PageHWPoison(page)) {
> > diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> > index f086f0e04756..7e2873cd0a6d 100644
> > --- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
> > +++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> > @@ -1,10 +1,15 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  /*
> >   * Test soft offline behavior for HugeTLB pages:
> > - * - if enable_soft_offline = 0, hugepages should stay intact and soft
> > - *   offlining failed with EOPNOTSUPP.
> > - * - if enable_soft_offline = 1, a hugepage should be dissolved and
> > - *   nr_hugepages/free_hugepages should be reduced by 1.
> > + *
> > + * - if enable_soft_offline = 0 (SOFT_OFFLINE_DISABLED), HugeTLB pages
> > + *   should stay intact and soft offlining failed with EOPNOTSUPP.
> > + *
> > + * - if enable_soft_offline = 1 (SOFT_OFFLINE_ENABLED_SKIP_HUGETLB), HugeTLB pages
> > + *   should stay intact and soft offlining failed with EOPNOTSUPP.
> > + *
> > + * - if enable_soft_offline = 2 (SOFT_OFFLINE_ENABLED), a HugeTLB page should be
> > + *   dissolved and nr_hugepages/free_hugepages should be reduced by 1.
> >   *
> >   * Before running, make sure more than 2 hugepages of default_hugepagesz
> >   * are allocated. For example, if /proc/meminfo/Hugepagesize is 2048kB:
> > @@ -32,6 +37,12 @@
> >
> >  #define EPREFIX " !!! "
> >
> > +enum soft_offline {
> > +       SOFT_OFFLINE_DISABLED = 0,
> > +       SOFT_OFFLINE_ENABLED_SKIP_HUGETLB,
> > +       SOFT_OFFLINE_ENABLED
> > +};
> > +
> >  static int do_soft_offline(int fd, size_t len, int expect_errno)
> >  {
> >         char *filemap = NULL;
> > @@ -83,7 +94,7 @@ static int set_enable_soft_offline(int value)
> >         char cmd[256] = {0};
> >         FILE *cmdfile = NULL;
> >
> > -       if (value != 0 && value != 1)
> > +       if (value < SOFT_OFFLINE_DISABLED || value > SOFT_OFFLINE_ENABLED)
> >                 return -EINVAL;
> >
> >         sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
> > @@ -155,7 +166,7 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
> >  static void test_soft_offline_common(int enable_soft_offline)
> >  {
> >         int fd;
> > -       int expect_errno = enable_soft_offline ? 0 : EOPNOTSUPP;
> > +       int expect_errno = (enable_soft_offline == SOFT_OFFLINE_ENABLED) ? 0 : EOPNOTSUPP;
> >         struct statfs file_stat;
> >         unsigned long hugepagesize_kb = 0;
> >         unsigned long nr_hugepages_before = 0;
> > @@ -198,7 +209,7 @@ static void test_soft_offline_common(int enable_soft_offline)
> >         // No need for the hugetlbfs file from now on.
> >         close(fd);
> >
> > -       if (enable_soft_offline) {
> > +       if (enable_soft_offline == SOFT_OFFLINE_ENABLED) {
> >                 if (nr_hugepages_before != nr_hugepages_after + 1) {
> >                         ksft_test_result_fail("MADV_SOFT_OFFLINE should reduced 1 hugepage\n");
> >                         return;
> > @@ -219,10 +230,11 @@ static void test_soft_offline_common(int enable_soft_offline)
> >  int main(int argc, char **argv)
> >  {
> >         ksft_print_header();
> > -       ksft_set_plan(2);
> > +       ksft_set_plan(3);
> >
> > -       test_soft_offline_common(1);
> > -       test_soft_offline_common(0);
> > +       test_soft_offline_common(SOFT_OFFLINE_ENABLED);
> > +       test_soft_offline_common(SOFT_OFFLINE_ENABLED_SKIP_HUGETLB);
> > +       test_soft_offline_common(SOFT_OFFLINE_DISABLED);
> 
> Thanks for updating the test code! Looks good to me.
> 
> >
> >         ksft_finished();
> >  }
> > --
> > 2.51.0
> >

