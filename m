Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E033FED3C5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C595B6B00AA; Fri, 24 Apr 2026 08:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30B06B00AC; Fri, 24 Apr 2026 08:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8516B00AD; Fri, 24 Apr 2026 08:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 95B2D6B00AA
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:58:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BE4786838
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:58:02 +0000 (UTC)
X-FDA: 84693452004.10.B596C46
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E82D80002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:57:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YGYqdgg7;
	spf=pass (imf02.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777035479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BAMvzBr9PpZ2bB/A/ote6Ozsw5WPfV8bnQ2HyE37DFE=;
	b=t/bGiPm5cNlewAvRBC5G74CuoJoBhRy5fzMfv7j6xyyW8BLqQ7U+nIjrmAHJu/QKBH6rCL
	k8qORdMYU+svqKDnYrP8NDCZs609L9l6fHJDcpFyIyxkHzG62MXJPg5KbPeHntn+EFuCnE
	Cxpvk8Z5bKFqOUROiiPp8Xx5oFGW43s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YGYqdgg7;
	spf=pass (imf02.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777035479; a=rsa-sha256;
	cv=none;
	b=O1b/o7qoF/dTlwPDBZ0jHqjPwAbataHk4XjPwznZyVpRcftPMbREUoE8RUaC9ozen9nBz4
	f/4XFIJYTLQ++UNlHrK9nOSWGEHlDKvT4ppJxZ4ttSun/TOpa7V1LRwpIjXqCOcHqGYMp5
	EcCoybgSQnOtvCLmLmJj9Tl3kUdFT2w=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63OATY5R3229409;
	Fri, 24 Apr 2026 12:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BAMvzB
	r9PpZ2bB/A/ote6Ozsw5WPfV8bnQ2HyE37DFE=; b=YGYqdgg7okj2m7B4COfw4K
	/V9eMifa6vh7vmf52XYEaYa8PjTxD5Y0F+tMj2hDvL2iDh8xgKYPyT5BDjXv6Ts8
	SKDz1LD5HuKI9Jta3dxzkEpKy24hZG7HYjYF0kvdZFnoEVCWZf46NO2k2IGF2Wru
	UiCu09n7/EshgTtYeUbamXQzw2rkLMiLg/AwQgyXsakOkOMM7k8jIjOlK8x/Ie5V
	SR2dLdknVu7IN16e+7qe0EtF/1NCPyrIVtY2WC33L5hJQEM92erR318yW6Notm69
	Mozk0QIeDOH0HGLxfPbUd8zQ0OKwkVEGfooDOoR/eg9ACQN0qbn6Ic3yAdU3WzKQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu2dvm7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 12:57:23 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63OCoI8F020780;
	Fri, 24 Apr 2026 12:57:22 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dpjkyaw82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 12:57:22 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63OCvL3M8061482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Apr 2026 12:57:22 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC76F5805C;
	Fri, 24 Apr 2026 12:57:21 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 79E8258058;
	Fri, 24 Apr 2026 12:57:04 +0000 (GMT)
Received: from [9.39.16.100] (unknown [9.39.16.100])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 24 Apr 2026 12:57:04 +0000 (GMT)
Message-ID: <250e68f3-3664-4148-bfbf-52fd4230a3b9@linux.ibm.com>
Date: Fri, 24 Apr 2026 18:27:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 3/5] mm: Hot page tracking and promotion - pghot
To: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
        mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
        raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
        sj@kernel.org, weixugc@google.com, willy@infradead.org,
        ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
        nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
        akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
        kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
        balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
References: <20260323095104.238982-1-bharata@amd.com>
 <20260323095104.238982-4-bharata@amd.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260323095104.238982-4-bharata@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: sMyrz2e779EOeTgntvUSy2MKw0RE23lY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI0MDEyMyBTYWx0ZWRfXxONK/29TmSiq
 Ia6+dSa3ooJ8ulbojH5YMbSP04ts6wmjr+Zob5V2e7jjuQkPkvkr1D93oBnCFJJHJwGDbfScZeb
 fRk4ZfRhFeUvYuST4zSnewqLIZaFcFAKXD0WHdCBUJ4bjzqgw8YAiFQyUgmkJ70fuMMBr784IVN
 M51NwajYXaLVnDt5CRdbP67nNGS3oLF1oT4YHZtUcFk2X6lVUitjK3ezBw9/nRLzk5SmvDwIBQI
 QyAevbFHbIfBbJ8AOoIzj7AY8J1/jdfuy8iVVROD8GYEjqnNGLWqS5ZKYqO6vnXHhwXR/v07rb8
 S4MpirainUxpvDpYVDhaYgrh1CUqo1CFPVgAYhrRE5uZtdU9OlrA+QCmurBCtjUMEQgMlF//FLw
 a9ykWuyfYpweL1wOJ/ANaFYwDlO6LoBgYc63h/VZDoRkABwp2KQCqppIsiiFcKw2S3vFBp2akps
 myP7Kdw0Vxlj6E+5JVg==
X-Authority-Analysis: v=2.4 cv=C8LZDwP+ c=1 sm=1 tr=0 ts=69eb68b4 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=zd2uoN0lAAAA:8
 a=ZCij31U9L89CqtK5npcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Ql9zLJUPQzcVDxOcEUBFMnPkZpP6xtkt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-24_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604240123
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8E82D80002
X-Stat-Signature: 6kd3kn5zx7spj8mgpuh8n3sh1mc3ma48
X-Rspam-User: 
X-HE-Tag: 1777035479-888644
X-HE-Meta: U2FsdGVkX1/6q1vNRmET4TmULx3+sEdNs8dDdsxAhjllIytuFhpJ1wLeVdoNs0Z1FYvbmTbisAAk9eI6IVxh4qN/CzxMsdEGnABMX6rEniF3E/QzqjzsHr/JuLTbWiMUz5J7VS2opNquHLSGuy6yahQIdsWkMEldMQVg5kp6Dau2j1yy+cRucDyht9L+pcBGxZS+s+ovtVnPi7jGasoaYid/rf/EYjUqbumCZ7eEnaUd7ZLtKeVtO/DioHbEtOXd026rsdgKnozrNbBiMMYlTaWzN3VJpExnP/4zNTjxu6Eb2tSu2guFh4Oe3Xxj3EU60Dy8z3eATAD0j5540xs4wn2vCxBPKfR2QxH5znVCL8R/+UqFI+FTMFlCF4D4hsMkRGADBCyTMMr/YtMvb5NDoFsVPfQSMfVud4MTG3Nia90zr6GSlXmNNSiV2LhaVwNcq4nILqn6ZmMhx/2sRPa87PlOpvPM2eKTVz4tedIZeout3tHgVyVIWdmd1vANOG3/qGhNWQ9h8ASLqMSTb1dee0xXk8DI+gSNWLa4Ytsq/uPD9kfQaJu461DTcJ0Dg9SEEGMTMLm9Sttju1SUTbxJZ1C29+n75+nL5aFP8yOB3bbqx9FF00ILIZNxOrmOtLPGstQqT3wIiZERXckwAShy7hpQWri/VRcmstmMp5rGmf5+xi1XVNZ2kGk4T4mFN8qLoXevlsHfLGfew4igb6ZnSPoAwosIngpQzKezdCzbbGgXYA3OtI1Y2iF0uykUJWgHi19y5MVrcf8875muRzOWgcBMAEJy5HZcJAV2oYRiaw/7lXhT4qG71hNVhCppukgH7VbBec4K6ImXwkdMAqnYz/J+HXSBxhnRyN6arIzy/LMoCvbqJuQOa4HJM1HwMquTbCEz2Hr70dF9oN6mZ6S/di1oB6eesITwb/EbmdfmbE3/Wxhw10bE8FfA43MP1aqslYzstncGQdY0ISC5yna
 jZxJkuUL
 Dfy7qvZq6EhZ9iOiUO3oV0kOafFEu7YwsP3qhEgh5sPXeYRAoFtzpyqh6dPM/lQjTiMTFXk955VlIultT6JKz6O46e2lOiFgB2iVZzGCtfcghUPoPZNObpZGk8fCiavJUG/RWqEphdthmkXIcRaB0mdhk3Z9c5KuK4ohcqVECGwPmKbyX5yZlYq23S9cli1nOi53LVRAz99j+VikSDsd6Y5XOfC96OVo/OPqirT8li59gg8nA7LOpK2+oa65ZENhsuV4LPwGz8KvPk5EOc6vuwRhFa9Wu/j7Z6ubG+2NvVol1KuiJ9DK5qJGaUUt7ZaetKRjh5l8G8Rc/0E7W+3en+0H648s5J0PxkY2Jh1QDiZjCEiXZwfa2Xw3kAQfjwPa0bgOMVJ1OmlCZZJLZPM81FFUDeqN6Lhnc/U1B7j3vNvcsXj5zZxpG/OOWig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bharata

On 3/23/26 3:21 PM, Bharata B Rao wrote:
> pghot is a subsystem that collects memory access information from
> multiple sources, classifies hot pages resident in lower-tier memory,
> and promotes them to faster tiers. It stores per-PFN hotness metadata
> and performs asynchronous, batched promotion via a per-lower-tier-node
> kernel thread (kmigrated).
>
> This change introduces the default (compact) mode of pghot:
>
> - Per-PFN hotness record (phi_t = u8) embedded via mem_section:
>    - 2 bits: access frequency (4 levels)
>    - 5 bits: time bucket (≈4s window with HZ=1000, bucketed jiffies)
>    - 1 bit : migration-ready flag (MSB)
>    The LSB of mem_section->hot_map pointer is used as a per-section
>    "hot" flag to gate scanning.
>
> - Event recording API:
>    int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
>    @pfn: The PFN of the memory accessed
>    @nid: The accessing NUMA node ID
>    @src: The temperature source (subsystem) that generated the
>          access info
>    @time: The access time in jiffies
>    - Sources (e.g., NUMA hint faults, HW hints) call this to report
>      accesses.
>    - In default mode, the nid is not stored/used for targeting;
>      promotion goes to a configurable toptier node (pghot_target_nid).
>
> - Promotion engine:
>    - One kmigrated thread per lower-tier node.
>    - Scans only sections whose "hot" flag was raised, iterates PFNs,
>      and batches candidates by destination node.
>    - Uses migrate_misplaced_folios_batch() to move batched folios.
>
> - Tunables & stats:
>    - debugfs: enabled_sources, target_nid, freq_threshold,
>               kmigrated_sleep_ms, kmigrated_batch_nr
>    - sysctl : vm.pghot_promote_freq_window_ms
>    - vmstat : pghot_recorded_accesses, pghot_recorded_hintfaults,
>               pghot_recorded_hwhints
>
> Memory overhead
> ---------------
> Default mode uses 1 byte of hotness metadata per PFN on lower-tier
> nodes.
>
> Behavior & policy
> -----------------
> - Default mode promotion target:
>    The nid passed by sources is not stored; hot pages promote to
>    pghot_target_nid (toptier). Precision mode (added later in the
>    series) changes this.
>
> - Record consumption:
>    kmigrated consumes (clears) the "migration-ready" bit before
>    attempting isolation. If isolation/migration fails, the folio is
>    not re-queued automatically; subsequent accesses will re-arm it.
>    This avoids retry storms and keeps batching stable.
>
> - Wakeups:
>    kmigrated wakeups are intentionally timeout-driven in v6. We set
>    the per-pgdat "activate" flag on access, and kmigrated checks this
>    flag on its next sleep interval. This keeps the first cut simple
>    and avoids potential wake storms; active wakeups can be considered
>    in a follow-up.
>
> Signed-off-by: Bharata B Rao <bharata@amd.com>
> ---
>   Documentation/admin-guide/mm/pghot.txt |  80 +++++
>   include/linux/migrate.h                |   4 +-
>   include/linux/mmzone.h                 |  20 ++
>   include/linux/pghot.h                  |  82 +++++
>   include/linux/vm_event_item.h          |   5 +
>   mm/Kconfig                             |  14 +
>   mm/Makefile                            |   1 +
>   mm/migrate.c                           |  19 +-
>   mm/mm_init.c                           |  10 +
>   mm/pghot-default.c                     |  79 ++++
>   mm/pghot-tunables.c                    | 182 ++++++++++
>   mm/pghot.c                             | 479 +++++++++++++++++++++++++
>   mm/vmstat.c                            |   5 +
>   13 files changed, 971 insertions(+), 9 deletions(-)
>   create mode 100644 Documentation/admin-guide/mm/pghot.txt
>   create mode 100644 include/linux/pghot.h
>   create mode 100644 mm/pghot-default.c
>   create mode 100644 mm/pghot-tunables.c
>   create mode 100644 mm/pghot.c
>
> diff --git a/Documentation/admin-guide/mm/pghot.txt b/Documentation/admin-guide/mm/pghot.txt
> new file mode 100644
> index 000000000000..5f51dd1d4d45
> --- /dev/null
> +++ b/Documentation/admin-guide/mm/pghot.txt
> @@ -0,0 +1,80 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=================================
> +PGHOT: Hot Page Tracking Tunables
> +=================================
> +
> +Overview
> +========
> +The PGHOT subsystem tracks frequently accessed pages in lower-tier memory and
> +promotes them to faster tiers. It uses per-PFN hotness metadata and asynchronous
> +migration via per-node kernel threads (kmigrated).
> +
> +This document describes tunables available via **debugfs** and **sysctl** for
> +PGHOT.
> +
> +Debugfs Interface
> +=================
> +Path: /sys/kernel/debug/pghot/
> +
> +1. **enabled_sources**
> +   - Bitmask to enable/disable hotness sources.
> +   - Bits:
> +     - 0: Hint faults (value 0x1)
> +     - 1: Hardware hints (value 0x2)
> +   - Default: 0 (disabled)
> +   - Example:
> +     # echo 0x3 > /sys/kernel/debug/pghot/enabled_sources
> +     Enables all sources.
> +
> +2. **target_nid**
> +   - Toptier NUMA node ID to which hot pages should be promoted when source
> +     does not provide nid. Used when hotness source can't provide accessing
> +     NID or when the tracking mode is default.
> +   - Default: 0
> +   - Example:
> +     # echo 1 > /sys/kernel/debug/pghot/target_nid
> +
> +3. **freq_threshold**
> +   - Minimum access frequency before a page is marked ready for promotion.
> +   - Range: 1 to 3
> +   - Default: 2
> +   - Example:
> +     # echo 3 > /sys/kernel/debug/pghot/freq_threshold
> +
> +4. **kmigrated_sleep_ms**
> +   - Sleep interval (ms) for kmigrated thread between scans.
> +   - Default: 100
> +
> +5. **kmigrated_batch_nr**
> +   - Maximum number of folios migrated in one batch.
> +   - Default: 512
> +
> +Sysctl Interface
> +================
> +1. pghot_promote_freq_window_ms
> +
> +Path: /proc/sys/vm/pghot_promote_freq_window_ms
> +
> +- Controls the time window (in ms) for counting access frequency. A page is
> +  considered hot only when **freq_threshold** number of accesses occur with
> +  this time period.
> +- Default: 3000 (3 seconds)
> +- Example:
> +  # sysctl vm.pghot_promote_freq_window_ms=3000
> +
> +Vmstat Counters
> +===============
> +Following vmstat counters provide some stats about pghot subsystem.
> +
> +Path: /proc/vmstat
> +
> +1. **pghot_recorded_accesses**
> +   - Number of total hot page accesses recorded by pghot.
> +
> +2. **pghot_recorded_hintfaults**
> +   - Number of recorded accesses reported by NUMA Balancing based
> +     hotness source.
> +
> +3. **pghot_recorded_hwhints**
> +   - Number of recorded accesses reported by hwhints source.
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 5c1e2691cec2..7f912b6ebf02 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -107,7 +107,7 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
>   
>   #endif /* CONFIG_MIGRATION */
>   
> -#ifdef CONFIG_NUMA_BALANCING
> +#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_PGHOT)
>   int migrate_misplaced_folio_prepare(struct folio *folio,
>   		struct vm_area_struct *vma, int node);
>   int migrate_misplaced_folio(struct folio *folio, int node);
> @@ -127,7 +127,7 @@ static inline int migrate_misplaced_folios_batch(struct list_head *folio_list,
>   {
>   	return -EAGAIN; /* can't migrate now */
>   }
> -#endif /* CONFIG_NUMA_BALANCING */
> +#endif /* CONFIG_NUMA_BALANCING || CONFIG_PGHOT */
>   
>   #ifdef CONFIG_MIGRATION
>   
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 3e51190a55e4..d7ed60956543 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1064,6 +1064,7 @@ enum pgdat_flags {
>   					 * many pages under writeback
>   					 */
>   	PGDAT_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
> +	PGDAT_KMIGRATED_ACTIVATE,	/* activates kmigrated */
>   };
>   
>   enum zone_flags {
> @@ -1518,6 +1519,10 @@ typedef struct pglist_data {
>   #ifdef CONFIG_MEMORY_FAILURE
>   	struct memory_failure_stats mf_stats;
>   #endif
> +#ifdef CONFIG_PGHOT
> +	struct task_struct *kmigrated;
> +	wait_queue_head_t kmigrated_wait;
> +#endif
>   } pg_data_t;
>   
>   #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
> @@ -1930,12 +1935,27 @@ struct mem_section {
>   	unsigned long section_mem_map;
>   
>   	struct mem_section_usage *usage;
> +#ifdef CONFIG_PGHOT
> +	/*
> +	 * Per-PFN hotness data for this section.
> +	 * Array of phi_t (u8 in default mode).
> +	 * LSB is used as PGHOT_SECTION_HOT_BIT flag.
> +	 */
> +	void *hot_map;
> +#endif
>   #ifdef CONFIG_PAGE_EXTENSION
>   	/*
>   	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
>   	 * section. (see page_ext.h about this.)
>   	 */
>   	struct page_ext *page_ext;
> +#endif
> +	/*
> +	 * Padding to maintain consistent mem_section size when exactly
> +	 * one of PGHOT or PAGE_EXTENSION is enabled. This ensures
> +	 * optimal alignment regardless of configuration.
> +	 */
> +#if (defined(CONFIG_PGHOT) ^ defined(CONFIG_PAGE_EXTENSION))
>   	unsigned long pad;
>   #endif
>   	/*
> diff --git a/include/linux/pghot.h b/include/linux/pghot.h
> new file mode 100644
> index 000000000000..525d4dd28fc1
> --- /dev/null
> +++ b/include/linux/pghot.h
> @@ -0,0 +1,82 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_PGHOT_H
> +#define _LINUX_PGHOT_H
> +
> +/* Page hotness temperature sources */
> +enum pghot_src {
> +	PGHOT_HINTFAULTS = 0,
> +	PGHOT_HWHINTS,
> +	PGHOT_SRC_MAX
> +};
> +
> +#ifdef CONFIG_PGHOT
> +#include <linux/static_key.h>
> +
> +extern unsigned int pghot_target_nid;
> +extern unsigned int pghot_src_enabled;
> +extern unsigned int pghot_freq_threshold;
> +extern unsigned int kmigrated_sleep_ms;
> +extern unsigned int kmigrated_batch_nr;
> +extern unsigned int sysctl_pghot_freq_window;
> +
> +void pghot_debug_init(void);
> +
> +DECLARE_STATIC_KEY_FALSE(pghot_src_hintfaults);
> +DECLARE_STATIC_KEY_FALSE(pghot_src_hwhints);
> +
> +#define PGHOT_HINTFAULTS_ENABLED	BIT(PGHOT_HINTFAULTS)
> +#define PGHOT_HWHINTS_ENABLED		BIT(PGHOT_HWHINTS)
> +#define PGHOT_SRC_ENABLED_MASK		GENMASK(PGHOT_SRC_MAX - 1, 0)
> +
> +#define PGHOT_DEFAULT_FREQ_THRESHOLD	2
> +
> +#define KMIGRATED_DEFAULT_SLEEP_MS	100
> +#define KMIGRATED_DEFAULT_BATCH_NR	512
> +
> +#define PGHOT_DEFAULT_NODE		0
> +
> +#define PGHOT_DEFAULT_FREQ_WINDOW	(3 * MSEC_PER_SEC)
> +
> +/*
> + * Bits 0-6 are used to store frequency and time.
> + * Bit 7 is used to indicate the page is ready for migration.
> + */
> +#define PGHOT_MIGRATE_READY		7
> +
> +#define PGHOT_FREQ_WIDTH		2
> +/* Bucketed time is stored in 5 bits which can represent up to 3.9s with HZ=1000 */
> +#define PGHOT_TIME_BUCKETS_SHIFT	7
> +#define PGHOT_TIME_WIDTH		5
> +#define PGHOT_NID_WIDTH			10
> +
> +#define PGHOT_FREQ_SHIFT		0
> +#define PGHOT_TIME_SHIFT		(PGHOT_FREQ_SHIFT + PGHOT_FREQ_WIDTH)
> +
> +#define PGHOT_FREQ_MASK			GENMASK(PGHOT_FREQ_WIDTH - 1, 0)
> +#define PGHOT_TIME_MASK			GENMASK(PGHOT_TIME_WIDTH - 1, 0)
> +#define PGHOT_TIME_BUCKETS_MASK		(PGHOT_TIME_MASK << PGHOT_TIME_BUCKETS_SHIFT)
> +
> +#define PGHOT_NID_MAX			((1 << PGHOT_NID_WIDTH) - 1)
> +#define PGHOT_FREQ_MAX			((1 << PGHOT_FREQ_WIDTH) - 1)
> +#define PGHOT_TIME_MAX			((1 << PGHOT_TIME_WIDTH) - 1)
> +
> +typedef u8 phi_t;
> +
> +#define PGHOT_RECORD_SIZE		sizeof(phi_t)
> +
> +#define PGHOT_SECTION_HOT_BIT		0
> +#define PGHOT_SECTION_HOT_MASK		BIT(PGHOT_SECTION_HOT_BIT)
> +
> +bool pghot_nid_valid(int nid);
> +unsigned long pghot_access_latency(unsigned long old_time, unsigned long time);
> +bool pghot_update_record(phi_t *phi, int nid, unsigned long now);
> +int pghot_get_record(phi_t *phi, int *nid, int *freq, unsigned long *time);
> +
> +int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now);
> +#else
> +static inline int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_PGHOT */
> +#endif /* _LINUX_PGHOT_H */
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index 22a139f82d75..4ce670c1bb02 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -188,6 +188,11 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>   		KSTACK_REST,
>   #endif
>   #endif /* CONFIG_DEBUG_STACK_USAGE */
> +#ifdef CONFIG_PGHOT
> +		PGHOT_RECORDED_ACCESSES,
> +		PGHOT_RECORDED_HINTFAULTS,
> +		PGHOT_RECORDED_HWHINTS,
> +#endif /* CONFIG_PGHOT */
>   		NR_VM_EVENT_ITEMS
>   };
>   
> diff --git a/mm/Kconfig b/mm/Kconfig
> index ebd8ea353687..4aeab6aee535 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1471,6 +1471,20 @@ config LAZY_MMU_MODE_KUNIT_TEST
>   
>   	  If unsure, say N.
>   
> +config PGHOT
> +	bool "Hot page tracking and promotion"
> +	def_bool n
> +	depends on NUMA && MIGRATION && SPARSEMEM && MMU
> +	help
> +	  A sub-system to track page accesses in lower tier memory and
> +	  maintain hot page information. Promotes hot pages from lower
> +	  tiers to top tier by using the memory access information provided
> +	  by various sources. Asynchronous promotion is done by per-node
> +	  kernel threads.
> +
> +	  This adds 1 byte of metadata overhead per page in lower-tier
> +	  memory nodes.
> +
>   source "mm/damon/Kconfig"
>   
>   endmenu
> diff --git a/mm/Makefile b/mm/Makefile
> index 8ad2ab08244e..33014de43acc 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -150,3 +150,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
>   obj-$(CONFIG_EXECMEM) += execmem.o
>   obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
>   obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
> +obj-$(CONFIG_PGHOT) += pghot.o pghot-tunables.o pghot-default.o
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 94daec0f49ef..a5f48984ed3e 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2606,7 +2606,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, unsigned long, nr_pages,
>   	return kernel_move_pages(pid, nr_pages, pages, nodes, status, flags);
>   }
>   
> -#ifdef CONFIG_NUMA_BALANCING
> +#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_PGHOT)
>   /*
>    * Returns true if this is a safe migration target node for misplaced NUMA
>    * pages. Currently it only checks the watermarks which is crude.
> @@ -2726,12 +2726,10 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
>    */
>   int migrate_misplaced_folio(struct folio *folio, int node)
>   {
> -	pg_data_t *pgdat = NODE_DATA(node);
>   	int nr_remaining;
>   	unsigned int nr_succeeded;
>   	LIST_HEAD(migratepages);
>   	struct mem_cgroup *memcg = get_mem_cgroup_from_folio(folio);
> -	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
>   
>   	list_add(&folio->lru, &migratepages);
>   	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_folio,
> @@ -2740,12 +2738,18 @@ int migrate_misplaced_folio(struct folio *folio, int node)
>   	if (nr_remaining && !list_empty(&migratepages))
>   		putback_movable_pages(&migratepages);
>   	if (nr_succeeded) {
> +#ifdef CONFIG_NUMA_BALANCING
>   		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
>   		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
>   		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
>   		    && !node_is_toptier(folio_nid(folio))
> -		    && node_is_toptier(node))
> +		    && node_is_toptier(node)) {
> +			pg_data_t *pgdat = NODE_DATA(node);
> +			struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
> +
>   			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
> +		}
> +#endif
>   	}
>   	mem_cgroup_put(memcg);
>   	BUG_ON(!list_empty(&migratepages));
> @@ -2773,7 +2777,6 @@ int migrate_misplaced_folio(struct folio *folio, int node)
>    */
>   int migrate_misplaced_folios_batch(struct list_head *folio_list, int node)
>   {
> -	pg_data_t *pgdat = NODE_DATA(node);
>   	struct mem_cgroup *memcg = NULL;
>   	unsigned int nr_succeeded = 0;
>   	int nr_remaining;
> @@ -2790,14 +2793,16 @@ int migrate_misplaced_folios_batch(struct list_head *folio_list, int node)
>   		putback_movable_pages(folio_list);
>   
>   	if (nr_succeeded) {
> +#ifdef CONFIG_NUMA_BALANCING
>   		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
> -		mod_node_page_state(pgdat, PGPROMOTE_SUCCESS, nr_succeeded);
>   		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
> +		mod_node_page_state(NODE_DATA(node), PGPROMOTE_SUCCESS, nr_succeeded);
> +#endif
>   	}
>   
>   	mem_cgroup_put(memcg);
>   	WARN_ON(!list_empty(folio_list));
>   	return nr_remaining ? -EAGAIN : 0;
>   }
> -#endif /* CONFIG_NUMA_BALANCING */
> +#endif /* CONFIG_NUMA_BALANCING || CONFIG_PGHOT */
>   #endif /* CONFIG_NUMA */
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index df34797691bd..c777c54cfe69 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1398,6 +1398,15 @@ static void pgdat_init_kcompactd(struct pglist_data *pgdat)
>   static void pgdat_init_kcompactd(struct pglist_data *pgdat) {}
>   #endif
>   
> +#ifdef CONFIG_PGHOT
> +static void pgdat_init_kmigrated(struct pglist_data *pgdat)
> +{
> +	init_waitqueue_head(&pgdat->kmigrated_wait);
> +}
> +#else
> +static inline void pgdat_init_kmigrated(struct pglist_data *pgdat) {}
> +#endif
> +
>   static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
>   {
>   	int i;
> @@ -1407,6 +1416,7 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
>   
>   	pgdat_init_split_queue(pgdat);
>   	pgdat_init_kcompactd(pgdat);
> +	pgdat_init_kmigrated(pgdat);
>   
>   	init_waitqueue_head(&pgdat->kswapd_wait);
>   	init_waitqueue_head(&pgdat->pfmemalloc_wait);
> diff --git a/mm/pghot-default.c b/mm/pghot-default.c
> new file mode 100644
> index 000000000000..e610062345e4
> --- /dev/null
> +++ b/mm/pghot-default.c
> @@ -0,0 +1,79 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * pghot: Default mode
> + *
> + * 1 byte hotness record per PFN.
> + * Bucketed time and frequency tracked as part of the record.
> + * Promotion to @pghot_target_nid by default.
> + */
> +
> +#include <linux/pghot.h>
> +#include <linux/jiffies.h>
> +
> +/* pghot-default doesn't store and hence no NID validation is required */
> +bool pghot_nid_valid(int nid)
> +{
> +	return true;
> +}
> +
> +/*
> + * @time is regular time, @old_time is bucketed time.
> + */
> +unsigned long pghot_access_latency(unsigned long old_time, unsigned long time)
> +{
> +	time &= PGHOT_TIME_BUCKETS_MASK;
> +	old_time <<= PGHOT_TIME_BUCKETS_SHIFT;
> +
> +	return jiffies_to_msecs((time - old_time) & PGHOT_TIME_BUCKETS_MASK);
> +}
> +
> +bool pghot_update_record(phi_t *phi, int nid, unsigned long now)
> +{
> +	phi_t freq, old_freq, hotness, old_hotness, old_time;
> +	phi_t time = now >> PGHOT_TIME_BUCKETS_SHIFT;
> +
> +	old_hotness = READ_ONCE(*phi);
> +	do {
> +		bool new_window = false;
> +
> +		hotness = old_hotness;
> +		old_freq = (hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
> +		old_time = (hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
> +
> +		if (pghot_access_latency(old_time, now) > sysctl_pghot_freq_window)
> +			new_window = true;
> +
> +		if (new_window)
> +			freq = 1;
> +		else if (old_freq < PGHOT_FREQ_MAX)
> +			freq = old_freq + 1;
> +		else
> +			freq = old_freq;
> +
> +		hotness &= ~(PGHOT_FREQ_MASK << PGHOT_FREQ_SHIFT);
> +		hotness &= ~(PGHOT_TIME_MASK << PGHOT_TIME_SHIFT);
> +
> +		hotness |= (freq & PGHOT_FREQ_MASK) << PGHOT_FREQ_SHIFT;
> +		hotness |= (time & PGHOT_TIME_MASK) << PGHOT_TIME_SHIFT;
> +
> +		if (freq >= pghot_freq_threshold)
> +			hotness |= BIT(PGHOT_MIGRATE_READY);
> +	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
> +	return !!(hotness & BIT(PGHOT_MIGRATE_READY));
> +}
> +
> +int pghot_get_record(phi_t *phi, int *nid, int *freq, unsigned long *time)
> +{
> +	phi_t old_hotness, hotness = 0;
> +
> +	old_hotness = READ_ONCE(*phi);
> +	do {
> +		if (!(old_hotness & BIT(PGHOT_MIGRATE_READY)))
> +			return -EINVAL;
> +	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
> +
> +	*nid = pghot_target_nid;
> +	*freq = (old_hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
> +	*time = (old_hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
> +	return 0;
> +}
> diff --git a/mm/pghot-tunables.c b/mm/pghot-tunables.c
> new file mode 100644
> index 000000000000..f04e2137309e
> --- /dev/null
> +++ b/mm/pghot-tunables.c
> @@ -0,0 +1,182 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * pghot tunables in debugfs
> + */
> +#include <linux/pghot.h>
> +#include <linux/memory-tiers.h>
> +#include <linux/debugfs.h>
> +
> +static struct dentry *debugfs_pghot;
> +static DEFINE_MUTEX(pghot_tunables_lock);
> +
> +static ssize_t pghot_freq_th_write(struct file *filp, const char __user *ubuf,
> +				   size_t cnt, loff_t *ppos)
> +{
> +	char buf[16];
> +	unsigned int freq;
> +
> +	if (cnt > 15)
> +		cnt = 15;
> +
> +	if (copy_from_user(&buf, ubuf, cnt))
> +		return -EFAULT;
> +	buf[cnt] = '\0';
> +
> +	if (kstrtouint(buf, 10, &freq))
> +		return -EINVAL;
> +
> +	if (!freq || freq > PGHOT_FREQ_MAX)
> +		return -EINVAL;
> +
> +	mutex_lock(&pghot_tunables_lock);
> +	pghot_freq_threshold = freq;
> +	mutex_unlock(&pghot_tunables_lock);
> +
> +	*ppos += cnt;
> +	return cnt;
> +}
> +
> +static int pghot_freq_th_show(struct seq_file *m, void *v)
> +{
> +	seq_printf(m, "%d\n", pghot_freq_threshold);
> +	return 0;
> +}
> +
> +static int pghot_freq_th_open(struct inode *inode, struct file *filp)
> +{
> +	return single_open(filp, pghot_freq_th_show, NULL);
> +}
> +
> +static const struct file_operations pghot_freq_th_fops = {
> +	.open		= pghot_freq_th_open,
> +	.write		= pghot_freq_th_write,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= seq_release,
> +};
> +
> +static ssize_t pghot_target_nid_write(struct file *filp, const char __user *ubuf,
> +				      size_t cnt, loff_t *ppos)
> +{
> +	char buf[16];
> +	unsigned int nid;
> +
> +	if (cnt > 15)
> +		cnt = 15;
> +
> +	if (copy_from_user(&buf, ubuf, cnt))
> +		return -EFAULT;
> +	buf[cnt] = '\0';
> +
> +	if (kstrtouint(buf, 10, &nid))
> +		return -EINVAL;
> +
> +	if (nid > PGHOT_NID_MAX || !node_online(nid) || !node_is_toptier(nid))
> +		return -EINVAL;
> +	mutex_lock(&pghot_tunables_lock);
> +	pghot_target_nid = nid;
> +	mutex_unlock(&pghot_tunables_lock);
> +
> +	*ppos += cnt;
> +	return cnt;
> +}
> +
> +static int pghot_target_nid_show(struct seq_file *m, void *v)
> +{
> +	seq_printf(m, "%d\n", pghot_target_nid);
> +	return 0;
> +}
> +
> +static int pghot_target_nid_open(struct inode *inode, struct file *filp)
> +{
> +	return single_open(filp, pghot_target_nid_show, NULL);
> +}
> +
> +static const struct file_operations pghot_target_nid_fops = {
> +	.open		= pghot_target_nid_open,
> +	.write		= pghot_target_nid_write,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= seq_release,
> +};
> +
> +static void pghot_src_enabled_update(unsigned int enabled)
> +{
> +	unsigned int changed = pghot_src_enabled ^ enabled;
> +
> +	if (changed & PGHOT_HINTFAULTS_ENABLED) {
> +		if (enabled & PGHOT_HINTFAULTS_ENABLED)
> +			static_branch_enable(&pghot_src_hintfaults);
> +		else
> +			static_branch_disable(&pghot_src_hintfaults);
> +	}
> +
> +	if (changed & PGHOT_HWHINTS_ENABLED) {
> +		if (enabled & PGHOT_HWHINTS_ENABLED)
> +			static_branch_enable(&pghot_src_hwhints);
> +		else
> +			static_branch_disable(&pghot_src_hwhints);
> +	}
> +}
> +
> +static ssize_t pghot_src_enabled_write(struct file *filp, const char __user *ubuf,
> +					   size_t cnt, loff_t *ppos)
> +{
> +	char buf[16];
> +	unsigned int enabled;
> +
> +	if (cnt > 15)
> +		cnt = 15;
> +
> +	if (copy_from_user(&buf, ubuf, cnt))
> +		return -EFAULT;
> +	buf[cnt] = '\0';
> +
> +	if (kstrtouint(buf, 0, &enabled))
> +		return -EINVAL;
> +
> +	if (enabled & ~PGHOT_SRC_ENABLED_MASK)
> +		return -EINVAL;
> +
> +	mutex_lock(&pghot_tunables_lock);
> +	pghot_src_enabled_update(enabled);
> +	pghot_src_enabled = enabled;
> +	mutex_unlock(&pghot_tunables_lock);
> +
> +	*ppos += cnt;
> +	return cnt;
> +}
> +
> +static int pghot_src_enabled_show(struct seq_file *m, void *v)
> +{
> +	seq_printf(m, "%u\n", pghot_src_enabled);
> +	return 0;
> +}
> +
> +static int pghot_src_enabled_open(struct inode *inode, struct file *filp)
> +{
> +	return single_open(filp, pghot_src_enabled_show, NULL);
> +}
> +
> +static const struct file_operations pghot_src_enabled_fops = {
> +	.open		= pghot_src_enabled_open,
> +	.write		= pghot_src_enabled_write,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= seq_release,
> +};
> +
> +void pghot_debug_init(void)
> +{
> +	debugfs_pghot = debugfs_create_dir("pghot", NULL);
> +	debugfs_create_file("enabled_sources", 0644, debugfs_pghot, NULL,
> +			    &pghot_src_enabled_fops);
> +	debugfs_create_file("target_nid", 0644, debugfs_pghot, NULL,
> +			    &pghot_target_nid_fops);
> +	debugfs_create_file("freq_threshold", 0644, debugfs_pghot, NULL,
> +			    &pghot_freq_th_fops);
> +	debugfs_create_u32("kmigrated_sleep_ms", 0644, debugfs_pghot,
> +			    &kmigrated_sleep_ms);
> +	debugfs_create_u32("kmigrated_batch_nr", 0644, debugfs_pghot,
> +			    &kmigrated_batch_nr);
> +}
> diff --git a/mm/pghot.c b/mm/pghot.c
> new file mode 100644
> index 000000000000..dac9e6f3b61e
> --- /dev/null
> +++ b/mm/pghot.c
> @@ -0,0 +1,479 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Maintains information about hot pages from slower tier nodes and
> + * promotes them.
> + *
> + * Per-PFN hotness information is stored for lower tier nodes in
> + * mem_section.
> + *
> + * In the default mode, a single byte (u8) is used to store
> + * the frequency of access and last access time. Promotions are done
> + * to a default toptier NID.
> + *
> + * A kernel thread named kmigrated is provided to migrate or promote
> + * the hot pages. kmigrated runs for each lower tier node. It iterates
> + * over the node's PFNs and  migrates pages marked for migration into
> + * their targeted nodes.
> + */
> +#include <linux/mm.h>
> +#include <linux/migrate.h>
> +#include <linux/memory.h>
> +#include <linux/memory-tiers.h>
> +#include <linux/pghot.h>
> +
> +unsigned int pghot_target_nid = PGHOT_DEFAULT_NODE;
> +unsigned int pghot_src_enabled;
> +unsigned int pghot_freq_threshold = PGHOT_DEFAULT_FREQ_THRESHOLD;
> +unsigned int kmigrated_sleep_ms = KMIGRATED_DEFAULT_SLEEP_MS;
> +unsigned int kmigrated_batch_nr = KMIGRATED_DEFAULT_BATCH_NR;
> +
> +unsigned int sysctl_pghot_freq_window = PGHOT_DEFAULT_FREQ_WINDOW;
> +
> +DEFINE_STATIC_KEY_FALSE(pghot_src_hwhints);
> +DEFINE_STATIC_KEY_FALSE(pghot_src_hintfaults);
> +
> +#ifdef CONFIG_SYSCTL
> +static const struct ctl_table pghot_sysctls[] = {
> +	{
> +		.procname       = "pghot_promote_freq_window_ms",
> +		.data           = &sysctl_pghot_freq_window,
> +		.maxlen         = sizeof(unsigned int),
> +		.mode           = 0644,
> +		.proc_handler   = proc_dointvec_minmax,
> +		.extra1         = SYSCTL_ZERO,
> +	},
> +};
> +#endif
> +
> +static bool kmigrated_started __ro_after_init;
> +
> +/**
> + * pghot_record_access() - Record page accesses from lower tier memory
> + * for the purpose of tracking page hotness and subsequent promotion.
> + *
> + * @pfn: PFN of the page
> + * @nid: Unused
> + * @src: The identifier of the sub-system that reports the access
> + * @now: Access time in jiffies
> + *
> + * Updates the frequency and time of access and marks the page as
> + * ready for migration if the frequency crosses a threshold. The pages
> + * marked for migration are migrated by kmigrated kernel thread.
> + *
> + * Return: 0 on success and -EINVAL on failure to record the access.
> + */
> +int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
> +{
> +	struct mem_section *ms;
> +	struct folio *folio;
> +	phi_t *phi, *hot_map;
> +	struct page *page;
> +
> +	if (!kmigrated_started)
> +		return 0;
> +
> +	if (!pghot_nid_valid(nid))
> +		return -EINVAL;
> +
> +	switch (src) {
> +	case PGHOT_HINTFAULTS:
> +		if (!static_branch_unlikely(&pghot_src_hintfaults))
> +			return 0;
> +		count_vm_event(PGHOT_RECORDED_HINTFAULTS);
> +		break;
> +	case PGHOT_HWHINTS:
> +		if (!static_branch_unlikely(&pghot_src_hwhints))
> +			return 0;
> +		count_vm_event(PGHOT_RECORDED_HWHINTS);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Record only accesses from lower tiers.
> +	 */
> +	if (node_is_toptier(pfn_to_nid(pfn)))
> +		return 0;


Just a thought—could we check this at the beginning of the function, 
before the switch case?


> +
> +	/*
> +	 * Reject the non-migratable pages right away.
> +	 */
> +	page = pfn_to_online_page(pfn);
> +	if (!page || is_zone_device_page(page))
> +		return 0;
> +
> +	folio = page_folio(page);
> +	if (!folio_try_get(folio))
> +		return 0;
> +
> +	if (unlikely(page_folio(page) != folio))
> +		goto out;
> +
> +	if (!folio_test_lru(folio))
> +		goto out;
> +
> +	/* Get the hotness slot corresponding to the 1st PFN of the folio */
> +	pfn = folio_pfn(folio);
> +	ms = __pfn_to_section(pfn);
> +	if (!ms || !ms->hot_map)
> +		goto out;
> +
> +	hot_map = (phi_t *)(((unsigned long)(ms->hot_map)) & ~PGHOT_SECTION_HOT_MASK);
> +	phi = &hot_map[pfn % PAGES_PER_SECTION];
> +
> +	count_vm_event(PGHOT_RECORDED_ACCESSES);
> +
> +	/*
> +	 * Update the hotness parameters.
> +	 */
> +	if (pghot_update_record(phi, nid, now)) {
> +		set_bit(PGHOT_SECTION_HOT_BIT, (unsigned long *)&ms->hot_map);
> +		set_bit(PGDAT_KMIGRATED_ACTIVATE, &page_pgdat(page)->flags);
> +	}
> +out:
> +	folio_put(folio);
> +	return 0;
> +}
> +
> +static int pghot_get_hotness(unsigned long pfn, int *nid, int *freq,
> +			     unsigned long *time)
> +{
> +	phi_t *phi, *hot_map;
> +	struct mem_section *ms;
> +
> +	ms = __pfn_to_section(pfn);
> +	if (!ms || !ms->hot_map)
> +		return -EINVAL;
> +
> +	hot_map = (phi_t *)(((unsigned long)(ms->hot_map)) & ~PGHOT_SECTION_HOT_MASK);
> +	phi = &hot_map[pfn % PAGES_PER_SECTION];
> +
> +	return pghot_get_record(phi, nid, freq, time);
> +}
> +
> +/*
> + * Walks the PFNs of the zone, isolates and migrates them in batches.
> + */
> +static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
> +				int src_nid)
> +{
> +	struct mem_cgroup *cur_memcg = NULL;
> +	int cur_nid = NUMA_NO_NODE;
> +	LIST_HEAD(migrate_list);
> +	int batch_count = 0;
> +	struct folio *folio;
> +	struct page *page;
> +	unsigned long pfn;
> +
> +	pfn = start_pfn;
> +	do {
> +		int nid = NUMA_NO_NODE, nr = 1;
> +		struct mem_cgroup *memcg;
> +		unsigned long time = 0;
> +		int freq = 0;
> +
> +		if (!pfn_valid(pfn))
> +			goto out_next;
> +
> +		page = pfn_to_online_page(pfn);
> +		if (!page)
> +			goto out_next;
> +
> +		folio = page_folio(page);
> +		if (!folio_try_get(folio))
> +			goto out_next;
> +
> +		if (unlikely(page_folio(page) != folio)) {
> +			folio_put(folio);
> +			goto out_next;
> +		}
> +
> +		nr = folio_nr_pages(folio);
> +		if (folio_nid(folio) != src_nid) {
> +			folio_put(folio);
> +			goto out_next;
> +		}
> +
> +		if (!folio_test_lru(folio)) {
> +			folio_put(folio);
> +			goto out_next;
> +		}
> +
> +		if (pghot_get_hotness(pfn, &nid, &freq, &time)) {
> +			folio_put(folio);
> +			goto out_next;
> +		}
> +
> +		if (nid == NUMA_NO_NODE)
> +			nid = pghot_target_nid;
> +
> +		if (folio_nid(folio) == nid) {
> +			folio_put(folio);
> +			goto out_next;
> +		}
> +
> +		if (migrate_misplaced_folio_prepare(folio, NULL, nid)) {
> +			folio_put(folio);
> +			goto out_next;
> +		}
> +
> +		memcg = folio_memcg(folio);
> +		if (cur_nid == NUMA_NO_NODE) {
> +			cur_nid = nid;
> +			cur_memcg = memcg;
> +		}
> +
> +		/* If NID or memcg changed, flush the previous batch first */
> +		if (cur_nid != nid || cur_memcg != memcg) {
> +			if (!list_empty(&migrate_list))
> +				migrate_misplaced_folios_batch(&migrate_list, cur_nid);
> +			cur_nid = nid;
> +			cur_memcg = memcg;
> +			batch_count = 0;
> +			cond_resched();
> +		}
> +
> +		list_add(&folio->lru, &migrate_list);
> +		folio_put(folio);
> +
> +		if (++batch_count > kmigrated_batch_nr) {
> +			migrate_misplaced_folios_batch(&migrate_list, cur_nid);
> +			batch_count = 0;
> +			cond_resched();
> +		}
> +out_next:
> +		pfn += nr;
> +	} while (pfn < end_pfn);
> +	if (!list_empty(&migrate_list))
> +		migrate_misplaced_folios_batch(&migrate_list, cur_nid);
> +}
> +
> +static void kmigrated_do_work(pg_data_t *pgdat)
> +{
> +	unsigned long section_nr, s_begin, start_pfn;
> +	struct mem_section *ms;
> +	int nid;
> +
> +	clear_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
> +	s_begin = next_present_section_nr(-1);
> +	for_each_present_section_nr(s_begin, section_nr) {
> +		start_pfn = section_nr_to_pfn(section_nr);


I may be missing something, but in pghot_setup_hot_map() and 
kmigrated_do_work() we seem to iterate over all memory sections. On 
large memory systems, could this become a bottleneck right?

Since hot_map is allocated only for lower-tier memory and the hotness 
information is primarily used there, would it make sense to skip 
scanning higher-tier sections?

for_each_online_node(nid) {
         if (node_is_toptier(nid))
             continue;

         start_pfn = node_start_pfn(nid);
         end_pfn = node_end_pfn(nid);

         s_begin = pfn_to_section_nr(start_pfn);
         for_each_present_section_nr(s_begin, section_nr) {
     }
}

Would this approach be reasonable, or am I overlooking something?



> +		ms = __nr_to_section(section_nr);
> +
> +		if (!pfn_valid(start_pfn))
> +			continue;
> +
> +		nid = pfn_to_nid(start_pfn);
> +		if (node_is_toptier(nid) || nid != pgdat->node_id)
> +			continue;
> +
> +		if (!test_and_clear_bit(PGHOT_SECTION_HOT_BIT, (unsigned long *)&ms->hot_map))
> +			continue;
> +
> +		kmigrated_walk_zone(start_pfn, start_pfn + PAGES_PER_SECTION,
> +				    pgdat->node_id);
> +	}
> +}
> +
> +static inline bool kmigrated_work_requested(pg_data_t *pgdat)
> +{
> +	return test_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
> +}
> +
> +/*
> + * Per-node kthread that iterates over its PFNs and migrates the
> + * pages that have been marked for migration.
> + */
> +static int kmigrated(void *p)
> +{
> +	pg_data_t *pgdat = p;
> +
> +	while (!kthread_should_stop()) {
> +		long timeout = msecs_to_jiffies(READ_ONCE(kmigrated_sleep_ms));
> +
> +		if (wait_event_timeout(pgdat->kmigrated_wait, kmigrated_work_requested(pgdat),
> +				       timeout))
> +			kmigrated_do_work(pgdat);
> +	}
> +	return 0;
> +}
> +
> +static int kmigrated_run(int nid)
> +{
> +	pg_data_t *pgdat = NODE_DATA(nid);
> +	int ret;
> +
> +	if (node_is_toptier(nid))
> +		return 0;

I might be missing something, but since this function is only called 
from pghot_init(), would it make sense to check the condition before 
calling kmigrated_run() to avoid the function call overhead?


> +
> +	if (!pgdat->kmigrated) {
> +		pgdat->kmigrated = kthread_create_on_node(kmigrated, pgdat, nid,
> +							  "kmigrated%d", nid);
> +		if (IS_ERR(pgdat->kmigrated)) {
> +			ret = PTR_ERR(pgdat->kmigrated);
> +			pgdat->kmigrated = NULL;
> +			pr_err("Failed to start kmigrated%d, ret %d\n", nid, ret);
> +			return ret;
> +		}
> +		pr_info("pghot: Started kmigrated thread for node %d\n", nid);
> +	}
> +	wake_up_process(pgdat->kmigrated);
> +	return 0;
> +}
> +
> +static void pghot_free_hot_map(struct mem_section *ms)
> +{
> +	kfree((void *)((unsigned long)ms->hot_map & ~PGHOT_SECTION_HOT_MASK));
> +	ms->hot_map = NULL;
> +}
> +
> +static int pghot_alloc_hot_map(struct mem_section *ms, int nid)
> +{
> +	ms->hot_map = kcalloc_node(PAGES_PER_SECTION, PGHOT_RECORD_SIZE, GFP_KERNEL,
> +				   nid);
> +	if (!ms->hot_map)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +static void pghot_offline_sec_hotmap(unsigned long start_pfn,
> +				     unsigned long nr_pages)
> +{
> +	unsigned long start, end, pfn;
> +	struct mem_section *ms;
> +
> +	start = SECTION_ALIGN_DOWN(start_pfn);
> +	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
> +
> +	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
> +		ms = __pfn_to_section(pfn);
> +		if (!ms || !ms->hot_map)
> +			continue;
> +
> +		pghot_free_hot_map(ms);
> +	}
> +}
> +
> +static int pghot_online_sec_hotmap(unsigned long start_pfn,
> +				   unsigned long nr_pages)
> +{
> +	int nid = pfn_to_nid(start_pfn);
> +	unsigned long start, end, pfn;
> +	struct mem_section *ms;
> +	int fail = 0;
> +
> +	start = SECTION_ALIGN_DOWN(start_pfn);
> +	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
> +
> +	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
> +		ms = __pfn_to_section(pfn);
> +		if (!ms || ms->hot_map)
> +			continue;
> +
> +		fail = pghot_alloc_hot_map(ms, nid);

I may be missing something, but after pghot_alloc_hot_map fails, we 
continue the loop. Would it make sense to break and go to the cleanup 
logic instead?

-Donet


> +	}
> +
> +	if (!fail)
> +		return 0;
> +
> +	/* rollback */
> +	end = pfn - PAGES_PER_SECTION;
> +	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
> +		ms = __pfn_to_section(pfn);
> +		if (ms && ms->hot_map)
> +			pghot_free_hot_map(ms);
> +	}
> +	return -ENOMEM;
> +}
> +
> +static int pghot_memhp_callback(struct notifier_block *self,
> +				unsigned long action, void *arg)
> +{
> +	struct memory_notify *mn = arg;
> +	int ret = 0;
> +
> +	switch (action) {
> +	case MEM_GOING_ONLINE:
> +		ret = pghot_online_sec_hotmap(mn->start_pfn, mn->nr_pages);
> +		break;
> +	case MEM_OFFLINE:
> +	case MEM_CANCEL_ONLINE:
> +		pghot_offline_sec_hotmap(mn->start_pfn, mn->nr_pages);
> +		break;
> +	}
> +
> +	return notifier_from_errno(ret);
> +}
> +
> +static void pghot_destroy_hot_map(void)
> +{
> +	unsigned long section_nr, s_begin;
> +	struct mem_section *ms;
> +
> +	s_begin = next_present_section_nr(-1);
> +	for_each_present_section_nr(s_begin, section_nr) {
> +		ms = __nr_to_section(section_nr);
> +		pghot_free_hot_map(ms);
> +	}
> +}
> +
> +static int pghot_setup_hot_map(void)
> +{
> +	unsigned long section_nr, s_begin, start_pfn;
> +	struct mem_section *ms;
> +	int nid;
> +
> +	s_begin = next_present_section_nr(-1);
> +	for_each_present_section_nr(s_begin, section_nr) {
> +		ms = __nr_to_section(section_nr);
> +		start_pfn = section_nr_to_pfn(section_nr);
> +		nid = pfn_to_nid(start_pfn);
> +
> +		if (node_is_toptier(nid) || !pfn_valid(start_pfn))
> +			continue;
> +
> +		if (pghot_alloc_hot_map(ms, nid))
> +			goto out_free_hot_map;
> +	}
> +	hotplug_memory_notifier(pghot_memhp_callback, DEFAULT_CALLBACK_PRI);
> +	return 0;
> +
> +out_free_hot_map:
> +	pghot_destroy_hot_map();
> +	return -ENOMEM;
> +}
> +
> +static int __init pghot_init(void)
> +{
> +	pg_data_t *pgdat;
> +	int nid, ret;
> +
> +	ret = pghot_setup_hot_map();
> +	if (ret)
> +		return ret;
> +
> +	for_each_node_state(nid, N_MEMORY) {
> +		ret = kmigrated_run(nid);
> +		if (ret)
> +			goto out_stop_kthread;
> +	}
> +	register_sysctl_init("vm", pghot_sysctls);
> +	pghot_debug_init();
> +
> +	kmigrated_started = true;
> +	return 0;
> +
> +out_stop_kthread:
> +	for_each_node_state(nid, N_MEMORY) {
> +		pgdat = NODE_DATA(nid);
> +		if (pgdat->kmigrated) {
> +			kthread_stop(pgdat->kmigrated);
> +			pgdat->kmigrated = NULL;
> +		}
> +	}
> +	pghot_destroy_hot_map();
> +	return ret;
> +}
> +
> +late_initcall_sync(pghot_init)
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 86b14b0f77b5..d3fbe2a5d0e6 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1486,6 +1486,11 @@ const char * const vmstat_text[] = {
>   	[I(KSTACK_REST)]			= "kstack_rest",
>   #endif
>   #endif
> +#ifdef CONFIG_PGHOT
> +	[I(PGHOT_RECORDED_ACCESSES)]		= "pghot_recorded_accesses",
> +	[I(PGHOT_RECORDED_HINTFAULTS)]		= "pghot_recorded_hintfaults",
> +	[I(PGHOT_RECORDED_HWHINTS)]		= "pghot_recorded_hwhints",
> +#endif /* CONFIG_PGHOT */
>   #undef I
>   #endif /* CONFIG_VM_EVENT_COUNTERS */
>   };

