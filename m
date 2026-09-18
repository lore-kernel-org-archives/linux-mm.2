Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 029D4C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F0F6B0095; Fri, 18 Sep 2026 17:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CE196B0096; Fri, 18 Sep 2026 17:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB176B0098; Fri, 18 Sep 2026 17:42:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C36056B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:42:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50A7A406A8
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:42:26 +0000 (UTC)
X-FDA: 85228207092.05.6A7C46A
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf16.hostedemail.com (Postfix) with ESMTP id 65DF7180007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:42:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lCbgpcm5;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789767744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRywDyqUWmgr7b+daClWkuC5v3z0QnlFIvvPsPbWZ5Q=;
	b=cT/JnvSpikZ43TxTe/BoLcACOecVB8nY8ya5IqZ83lOu++M4qaJAW2vbDd68u/fQ0lpvt7
	4EBzCuFywS0RRLrp2b2ArFqWoI5r0hLg1DN2jrZP/FDTw57gkUt0QEE7fhkjxQMPD7BEH3
	P483wOXBi+3A0pVF21p3TD3Qt+pvY2U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789767744;
	b=zPAhm2VKqIxHPniPG8XAhNhORJEe1v5Z1uh96jOgcMzLRDr5y7C6bCIxgkMz5KwHn95UAF
	39d8WYOf4hnBbX5Mth39ItqmUQGQqt4dgGCp72R66ejuZwxJWkHAkTpkxgx4KNtSU3iN3E
	cdAHU+afmlZSEkOLVD5bCdtpd4w5Q8U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lCbgpcm5;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb766bfd6so11128531cf.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789767743; x=1790372543; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JRywDyqUWmgr7b+daClWkuC5v3z0QnlFIvvPsPbWZ5Q=;
        b=lCbgpcm5OUp0ucNDFgwayYad0EvzRbyzDJbjmw5QKvEs/zUaqxLiwGajoJVy1UCfYY
         hk+7ZcjuMIIo5rwSiPHNB5eDH/nJ+tPACXmgPpGlv3YOYOcyD2U06y3oSzlH3uhLmo2k
         VOysGxrZKnNN2e/oS1ZdJRHXHVZ6JUYjjMcddG5md2dlZZ/rYTEWikIOOK9do58URgWe
         6EqTkpaKIfJf1bV6NClJmIMcTgC14c6RI4SuXCFADmOSMnmDHN0K44XfDR4/+JRFQbof
         J8kUdioAc2/TQh6ok8FOd4smC/uv1CIq7wnky/YSIrOtwkDrZqbzi8aAtfrcnBfWMAUH
         5CaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789767743; x=1790372543;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JRywDyqUWmgr7b+daClWkuC5v3z0QnlFIvvPsPbWZ5Q=;
        b=QQsc63lemGqBHMyFGMHgN3i/e9aQ3TGf/8lJ2XZEcq/BWCyTJknZHs4F0dAeQbP/Oa
         VT/GCsbm8puBSG1Z7VqrB8Kmr/jxjjaO2N80z7j7Lw7YiBg1fvENuNLfGE6gu/yZ+6z4
         kHqXX7EE22j2YmnaAilAuSQ1ESoq9hwHGt4UQtnqwpYXf7o1zsqyTDIXe9ojRHmO7PNC
         dziQuhr+usuIceCTryFVbnQyfO4mMILeWUU+Yz6zOfPOAa9xG/rAudcnn5NSHWTumbRO
         7iu5g5IfdEYldmJXFJmS4+jO7ktQ8hF8Lrsb5lnm6tSgIf9mLL0dse3xXhJgISZCYsZK
         rTeg==
X-Gm-Message-State: AFuF++nuUWU9bSg30XFzbl6QFiT4zafPySkXQxHOvXogReEo1FuHZF8g
	pXO2R9U4L0y1hyD/7cy0YoiJmSpQX2YIwChtWpVFch3J72RVh2PrtPYdmcjjXtywqWE=
X-Gm-Gg: AYBFou2MmnzHWy3a8REJ8rYIENuAqdWzuYyNT0mfdPGzEvMNdis9HLjYEKnRUF3Wy3m
	2bebA4KBGCIrtSoQ/IGClKXB5OOqwe71z3VACLGGxl+6CtRCfINkGO87R4oq+ZLoNloz4Bu+qcq
	UzgIYpalv0+AeVbb8OoBAID8WwKP/03Gtv+YHBNzlrV60ZMAX2nIrqet3N5sTKlkYjfsOUL9C9p
	/X8SVRrqrRnDnP9YKTB2l4vaL/BKS4Z+ogNfiYunHwM8yCzxCgJLTEL90kYtiANX72a9h3zzWKP
	6VdIZQEV9xQfUNs3umlHfKTCg/qutes0N9LOvh1g5qq4gQNixdTSLhFSuSKiPFChRdr+SHoZi1q
	oqr6Id6yh0NNIR8tHiTkLuPN3Bu44zDeapVl6oyQfPRXXQVNrDAnpiu7YgLnxj+Zj5ax5lGKsgw
	wNYlmFFEa9f86aV5Lkje2zYczY+xZwO/JtdNXhE+ZlDvhFL1NeU4WSTul0vRnJiGwhzOxwVtg3F
	6an9u4b0QZPs2z4MNt/8pjxMBsxZ5y/Xvuvx3zhgfOAyA4yINr6odTzJSjMD3pOvw==
X-Received: by 2002:a05:622a:6094:b0:531:11ac:23d8 with SMTP id d75a77b69052e-5329e444f66mr69085321cf.49.1789767743500;
        Fri, 18 Sep 2026 14:42:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532ae750944sm6431301cf.25.2026.09.18.14.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 14:42:23 -0700 (PDT)
Date: Fri, 18 Sep 2026 17:42:20 -0400
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-team@meta.com" <kernel-team@meta.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"ljs@kernel.org" <ljs@kernel.org>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"juri.lelli@redhat.com" <juri.lelli@redhat.com>, "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>, 
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, 
	"bsegall@google.com" <bsegall@google.com>, "mgorman@suse.de" <mgorman@suse.de>, 
	"vschneid@redhat.com" <vschneid@redhat.com>, "kprateek.nayak@amd.com" <kprateek.nayak@amd.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "nico.pache@linux.dev" <nico.pache@linux.dev>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"baohua@kernel.org" <baohua@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>, 
	"usama.arif@linux.dev" <usama.arif@linux.dev>, "kas@kernel.org" <kas@kernel.org>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, 
	"rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"osalvador@suse.de" <osalvador@suse.de>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"raghavendra.kt@amd.com" <raghavendra.kt@amd.com>
Subject: Re: [PATCH v2 0/4] sched/numa: stop VMA scan filters from gating
 promotion
Message-ID: <aq2s9R9I-Y9D3tx_@gourry-fedora-PF4VCD3F>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <DLIQQNUL2RTD.IGN8MYHYMW1E@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLIQQNUL2RTD.IGN8MYHYMW1E@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 65DF7180007
X-Stat-Signature: mgux7xi5ud6zurd8jkomqpaqxq37xax6
X-Rspam-User: 
X-HE-Tag: 1789767744-741541
X-HE-Meta: U2FsdGVkX1/2WbfBskiu+bS+LV5ZKWDCMqCIFc7T0poqx4QS94RM5iIO7dYuPLeN9NM0nmx68Co/NLvFBMqAeIyQ5Ch+ySjKOVkZ5O0rurxO5U3+i97APlQ30LqLHTDQU8hcCLCU6n7CwDD47UzFXDGX0LzzZcXgQNs3aOc83xQmUc4kP+OG8xQsiHN/Xixa5yCe7VNlFuNDx4Fvx7mmaSLyridyOgX9yiX51OwbMyx1sa4XE5/aUv3W0UpAyyT3YQlDRPz5ZOLV7+ZyAsiDioqVMQh+N5os0H4WClKTuEGaHm0p1AWRw6VWr4V4/vzmDe5b2b/CKVvQ1td0dIEibs+QInrQa64CL6OCTcUciC3Psx3r5gAw33TMXV5SM4jrmN4iLgKnmUBT7wMXWAN7D+vCoKNVY9QkDEdGl9Xr18cjVVYUz0pRUynros0GelnIJmEESF/tyaMfB3BU9w08toGkUgwGAkGzXEoScaT9d4T+YrOHx17cjPWjGJUL5LqUWhq+IzwWg4bimUzkpwvvE+JW0SGpyA0Od8MnzZgvn2CRVmRYkOEAeIXW7u8G9SPO6XeSpTBnRWOFcnJ6T1EwbiGrwFOCXZ57XUQdWzC2j31FlwmsLGJXE50KLoqGKx2qwoZckdHYqBa99vAy5Lkp9VLvmcxiMb/mR/QoPh04nGqwSQW/OEr0PM1gaejHNqx/AsCMmVDyLQjcSgN8atfJJkwSYkTLydNwBzyRk1uVMDodD9DUgw92GSJ3JWX3/d6JJ7g0bA+Ik5JcrQkZYfkYn4jtDGbztULRDaumRb6R0P4ly/WcuElwWpuiJow7z0AcOE6gPzLEGaWgnuN8dcMokWuJ6i0L/al743XKsYnoo4d9NNU5fBMPdUYuWreIzh/PzQODuYc7kBnRz2YbrRjsPJizhSj2dVcbp9eGiAc4/NNt1KTn/NSUc5RQgSJ3iwe67uFy7tJVuxlzgEEvnOw
 OuJNwBZI
 3fiUFSfHGbTQrRmqn7E4u48oBqBDPqiMtOSxW6B9GEpsiBYA3CD17Nbm48qsVcYq5mmNjsNevzbQCkDP+4h2y/T4EahDnfCOVnswmivKR3AN6ybiFdlvrDAl22bdMXywFspTjv7d7GcTWqSU/NIVmdOGGwEcxFSotusIsVrYLzGrCV2ixxhx+eln0LurO2aSylaE/Rqi9d2zpGv9r/C/ao0jRlZG/fZqcwI8YfwpqDsMrnTxIHY4h5gue/i4KHR1ke7+UiLcUryHPHNAVPMLRKldnx+gG8M3wqQx15KjjOtsKxHTtJT0axbeqT2FUJmV02CGuwYOF8kJDiTQTcAmQZ5/KUvnnkLqTc3XghzPDt+p5OTZSe/fEmv6APZDfSfxpriCqvvlCQePDr7NbXkyVcpQjMlBrgCRTmYeaXXaNO68O1sJZXorx38E7JJ5oQYNz7CgBGdMZaQYGA9C2HdnRSpQCOr6S6znIMBXoWVUH5lKETzQWOoa387oe59VD7FeIQrNPSIy/0kgioOXwzFZlCCZ7UO4m+mzWY3ILK6bLjmYsDmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 04:56:34PM -0400, Zi Yan wrote:
> >
> > Tested on a host with 768GB/256GB DRAM/CXL.
> > Ran 2 ~430GB database workloads with large (>300GB) shmem VMAs.
> 
> Do you just launch them without any additional NUMA control or NUMA
> policy configuration, like using numactl? Just want to understand the
> scope of the issue and how well the fixes are tested. It might be good
> to have a list of expected behaviors for people/AI to check against.
>

We found these issues while testing fairness controls with Joshua's
tiered memcg limits patches [1].

We were seeing very lopsided bandwidth utilization between tiers.

When dropped all the memcg extensions and tested these patches by
themselves, we found that numa balancing was completely broken -
starting with Johannes' shmem fix [2].

Otherwise - No other numa controls are used on these workloads.
  - no numactl
  - no mbind()/set_mempolicy()
  - no cpuset.mems
  - etc

These fixes impact the fault-injecting side (spraying PROT_NONE),
not the fault-handling side. So mempolicy and cpuset doesn't really
come into the picture.

It's more of an internal-consistency issue for numab itself.

~Gregory

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/
[2] https://lore.kernel.org/all/20260629163337.1264881-1-hannes@cmpxchg.org/

