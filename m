Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3983C79F85
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 11:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE66F6B0088; Sun,  6 Sep 2026 07:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97376B008A; Sun,  6 Sep 2026 07:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85B86B0095; Sun,  6 Sep 2026 07:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5A06B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 07:02:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A0C0804B7
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 11:02:54 +0000 (UTC)
X-FDA: 85183049868.15.49630AB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 809E2140006
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 11:02:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OObkrbZY;
	spf=pass (imf09.hostedemail.com: domain of nilay@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=nilay@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788692571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1IxLtMyLl91TNarA6fdF5T0e/R6TVNbs54mrrqU6HI=;
	b=MNIxdgdFTKUFqkwWkoOxit+DpHh0SF2ID69qEe0v2G5lkWY+UficQwwZSoqe0mq5DVm06m
	2EiZvVyortZimbPzXF5kbJaStidkzC0ekJF9UTksmzXUCuxpRHdCNY6sXvlLMkSOJme/kO
	hVNWtMD6z4IOXQDBjYJkVfFBdjS8FPo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788692571;
	b=HP5IzFiCO0/8mxIiVPA1zZBiz6xExgvrdhnab9nCrFE+Tfl+J7Gp/GT66FhuzoPr4Iua3S
	v4vZbvHJ3Ns87nmQoJD04n03i4rot87OQXYMtpysEOfLzBlKpBynR50KuJttnwJA1m087m
	eYqN/lrv4CwxNi+lwwB8xatePCnI/qY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OObkrbZY;
	spf=pass (imf09.hostedemail.com: domain of nilay@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=nilay@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68602PR3579824;
	Sun, 6 Sep 2026 11:02:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=X1IxLt
	MyLl91TNarA6fdF5T0e/R6TVNbs54mrrqU6HI=; b=OObkrbZYzPkHj8C1IHm1cw
	B2in3kabJ0rpEBPZUMcEI/J3JEfIWf91b/UayzpycbxPgumYL0Wz3NLzbOu0enS+
	sF1OWRQjnW0WRl78zKzIaO0ahULX4Fde40kBqJDcGTpCmcw+NItG0AaykNMbIu4d
	N+eRt5eKZiFzxEwPKztQPCLC8nU3yAlvNrdz12npnfNr5FjiWX9XrwdnYUOwuDub
	fgUNICAKk0eujyxgr6A1bWYBM6eX3cVnNGPEarlAM6+Uoqg1SNNNhqLOmxPmrh5y
	l8ixxo+KuAYphS4/kYrLgthTo7z8nq4NPNHi8VEvR7LXZjFtiRaQNeyi1MCNYzdA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbjrbx43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 06 Sep 2026 11:02:21 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 686AuNY7025863;
	Sun, 6 Sep 2026 11:02:20 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggymg11sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 06 Sep 2026 11:02:20 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 686B2JIk14811848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 6 Sep 2026 11:02:19 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 54D805806B;
	Sun,  6 Sep 2026 11:02:19 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 903505806D;
	Sun,  6 Sep 2026 11:01:59 +0000 (GMT)
Received: from [9.61.37.159] (unknown [9.61.37.159])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  6 Sep 2026 11:01:59 +0000 (GMT)
Message-ID: <d88a132d-177b-4d54-9927-3d16065c7b60@linux.ibm.com>
Date: Sun, 6 Sep 2026 16:31:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] blk-cgroup: move async bio punt state to blkcg
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>,
        Tao Cui <cui.tao@linux.dev>, Jan Kara <jack@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
        Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Dan Williams <djbw@kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Ira Weiny
 <iweiny@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
        gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
References: <20260823133045.970199-1-yukuai@kernel.org>
 <20260823133045.970199-4-yukuai@kernel.org>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260823133045.970199-4-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E7T9Y6dl c=1 sm=1 tr=0 ts=6a9d483e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=dSZZVhdJ-k8saxBcLagA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDEyMSBTYWx0ZWRfX1o5srX8k5MDO
 Qxb88bQbQQ5VjAC8W0ZmLS/FWvxDhHiuFXpmwA/LQnASHjk2pG3Fc76wsNlyo8Uhf/hUJaPRm6+
 DmBsZZxV0GGw1IhcFahi7eylI9awyx8=
X-Proofpoint-ORIG-GUID: 5uBq-q6HYJD-e2NLAJZ1n9AYoAJq0C2V
X-Proofpoint-GUID: 5KO3rSrRARleln9R8wOwhFqA1IMpf7-d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDEyMSBTYWx0ZWRfX85mhyvthZZx7
 TzUmMgNCnb7TchmNWsbrRuv3Gorv2/vurZ0nGyihr2AhCtn1gWQKsaD9XGLfVaCnyx+Eb9md+hs
 gP5DV/GbS5KT3KoxbVB2h3PFT7knHTE3xyDEVZduhr8qwiTLbOg52xngThVa3NZWXXafcg6N3lN
 C5EZtWo2/ggCTLV9xFtnQ6qkIGDMYBQ+zVxujXVUfG3mMto5Mde4wjmXatoVPMroxuT6zTRDf1V
 YSbbcAhY7vOBRKSyNhHnuNvrcLsUegAisrdkVX/oBGVdwphlLzf45zZzQMKXAJ8MY9QoROhfmjW
 D+aE4RyM98U8SLR09fYL32ODNR30XoOBgptJuC2elr4hdCRhEzpxcsFJaXfPBtg+McldK0QWsbp
 Ss1RqgBY08Iq+iQvKDj328NPcFZfgeScUIK7Kz3ZLK2PweQ6Uedpjc25K3UzzvZGDbu+x7mM4/O
 5nCRgYBPwPvBRQ2ZIYw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_08,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609060121
X-Stat-Signature: rdk69pi8cdnm7t6mbkddj8arc6id3aua
X-Rspamd-Queue-Id: 809E2140006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788692571-222930
X-HE-Meta: U2FsdGVkX19+YNOssi8wQ+JFv7nzrjQF2aDY67osbO+dzzlP8aoBcyqCrq+nT58qzmiTSGM2SWecijae5HK4sd1kNlhxn7GY8DEjLt3cbYQwdU/7rEVolT3ZQ0vkdkztlC8icxoYVri8w/cWEiQ4EH1idzFbLcPyqnhp7AS9tfwE/QIsdAqVb4PybdaMNuYjNB77dH4lwrhImAXAlBoDANfWvBcAJqztUB1T9fjt9KQSh1z6uul4scuBoz+5v8OZm7WHm7/pTQsV06UmeZCNiA0vkx98QAL7bpEV/UN0y80pKSz8xOCQYuzFC6rtCWrWR1gdYqXJrenOFHxx4ZMMBeWWhwzV1ELKOQ4yJMlLq1YTx5g+hC/ZRMUDXdS6C1B61oc2HM+eBmp1Gp0SIGmkskqAJWWAEAYcOQ3Kvl3CHyPdAZGQzcrNzfkvdcUeNDLjW2ZUAyFtZGG2qAdGGOWSV4zO4X19O40mfDXpWFzSo+u/2Y5tkm3UL4gc12RXJUDlAElKB0ZJS3r/LpSzd5dMEyrTqbVXsQoccM9NaSns7w8fGlVMXpMKa/k/wpqZ6miU/2WgawWWFt2oQMWPXhgasUlMbRbH1a5yfiWhT/lb47zb4M7E1XKh+j7xRak7CNt6YQB+4qgqYOmIP2lDTBBwUztPj6OwjgljHD5sfSSQ9cEYW3Om815jIlpF3IAkRwyFXoHqNY1z2jtWsEgBAM3WCxRww2J84IbWYsOMkUsUD9eyR+YiiyA8Q49l93p8VyWMcvy6J/gvbEXX+TkLiSujE40rMSgmIKGPtR9xZR+N2uKtlzQv8zhUCONTlQQzwnevCCsrHo7B89TrXx9zH9mGDCmAZHIBY65S5WFDuB3TsTs2SKCYh8a4Wd4oMBfmmua08Rb/MPaR/cnLq5kblspTdOpBRdKbFoLn1kTIEQYuBdr+O8cfisUE/Zj/AgD75J6lyiAJVJVhIT9SEAhZHFC
 /FgKVsR8
 O4XaNAfQQKCuDB/8Zjx7caJNdcLWufx9w96N12Cgs1qz2nbEy5Zo4b1Ea7JV8lTvu3VMdPB+/l9LTZd4Z1tapSyyUWfYG+ad4AT9BTcXg9vlz/gMT1wp9F/mhClKrSi7Vr8uefaazH7XaH0bWul+O9ksQhu1DF2aZMPSTVmIylwWXJyIr30HKupbrqcNmzot1RafIxsg8pROqVxqTAyH9y2eICeu3SAj37nVjF5lffQx16TF/xyWrWu3QH61xhnMfKnhPlQBk54n6cPnmcenYN8iBRKb8Y3HaN/Gec0vv8Vub8WjN8CtGGMeOtbFWzKsWTsLrEM46vWv9WNGPz48646+LPjHl0YnZW5px5RXWLC7tyA1uAtAImP+gj3k+S9zpFlS1Fs7LgAYZTpm6wxVh4oaJ0VNVXkrv9EioLID+VqB1tbM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/23/26 7:00 PM, Yu Kuai wrote:
> @@ -111,10 +104,15 @@ struct blkcg {
>   	/*
>   	 * List of updated percpu blkg_iostat_set's since the last flush.
>   	 */
>   	struct llist_head __percpu	*lhead;
>   
> +#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
> +	spinlock_t			async_bio_lock; /* protects async_bios */
> +	struct bio_list			async_bios;
> +	struct work_struct		async_bio_work;
> +#endif
>   #ifdef CONFIG_BLK_CGROUP_FC_APPID
>   	char                            fc_app_id[FC_APPID_LEN];
>   #endif
>   #ifdef CONFIG_CGROUP_WRITEBACK
>   	struct list_head		cgwb_list;

As I mentioned, Clang context annotations are now officially supported
in the block layer. Since you're touching this code, I suggest annotating
async_bios with __guarded_by(&async_bio_lock) as well.

This would allow the Clang thread-safety analyzer to verify that every
access to async_bios is properly protected by async_bio_lock.

Thanks,
--Nilay

