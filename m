Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB1F606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=e84uq7aT;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=ezjc5d4i
Received: by kanga.kvack.org (Postfix)
	id 82C206B05B0; Mon, 23 Nov 2026 12:32:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DDA36B05B1; Mon, 23 Nov 2026 12:32:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5496B05B2; Mon, 23 Nov 2026 12:32:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 322BA6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:32:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9344A12093F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:32:10 +0000 (UTC)
X-FDA: 85467077220.26.0559CA8
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7C25E140005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:32:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=e84uq7aT;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ezjc5d4i;
	spf=pass (imf09.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455128;
	b=31Yb9Zf0bUcqHgvXdo2li6D8SijY0upeEn1zb/kAhKt1whJ9WaHNrC7EQIGKKB+W2hhn8J
	Psu0z2r4PNZtmTxIwT4Jm185zy0KV/itktrk4P8LM3I7/I+1GcRUTq7ko4qfNh8Qdl2/OX
	cuLGyo0dqQ7JpAZ95ZDucjlCJh2OXno=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1a4TM24Bx37KhzPX0EKcngcxqi/da9ANdKbxr2maRdo=;
	b=KVUj2xS02HJAdjdATuXOJJ5aZPCt9M/QaKVOXLKHVZujNsnyocodwYfCv7Q4juadRSnzSR
	gkQ4kZYIcE61rEStgeJSQ7VUNxyNzANUgWFVnlJffV6lLx7oOP9mst1Pd/rQ3WGVKlXEmF
	J7pA+byZ7twJ/9LnSpVcGVmCxf2o2Aw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=e84uq7aT;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ezjc5d4i;
	spf=pass (imf09.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANFXhGB1229217
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:32:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=1a4T
	M24Bx37KhzPX0EKcngcxqi/da9ANdKbxr2maRdo=; b=e84uq7aTN+paLgiRpBNO
	jFpZrFwSkNAZb0pLrPBFBMpeq7xY5VF5Ke74YGVhQQhgB2XMzCUH3wtB+DektBiR
	qPo9ynkIbzCzlLUmkih4RkrbewMTNmaLvk6XxPhBoaZ8L4ukPmaKxPqpWeBbJLLc
	uelcoHkyG8W6GveecAnwBSg3Yp8SkpLpDehjKoA99YhreNu9TwIUWlL5Tbv8AAM7
	bQOYm9/5nWyXZcsZXTj1dP+reEx73v7sueTzpgokaO7URE3kspWKIKGZsluDsTH3
	+sZgnA+tjE6t19HGhCCmkFQBefGvug9EszN1p4Ts6fdQLWzQIgVR9TFNWu/q/bNX
	NQ==
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com [74.125.224.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j4h32uxpp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:32:05 -0500 (EST)
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-67c58f18a42so6480227d50.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795455125; x=1796059925; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1a4TM24Bx37KhzPX0EKcngcxqi/da9ANdKbxr2maRdo=;
        b=ezjc5d4i4YJJhW7JmEC1DARc6CSCQtGzn6KHRsnS2NBq4CLWIXvkMExlqo1GX+XCks
         ByfgoE74HKz+Y6um4eQY4cR7QhzPqRDjFtvBPQqLeQvnwYjpnSQgBja2Z8srqZXebHm4
         ADXJDnr+ZFvfuHrJ5TqhxI8+psSXweRtI5W0Ae9ehuOQ7j99KTGzkBhzW8eBqIpAczrQ
         1xXCgThT1UxsgfZ80lE1ddisHAQgYHlXllEBPOoT8fip+dR8EkMOLneqDa76AaRb6Dq7
         Bg9xV56ywkW7ofB2T+MRKXGimDjTZJ7/8Os0WeKZ6X4x+qt7E841klvpXCmk5Sv3xqAf
         Gs/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455125; x=1796059925;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1a4TM24Bx37KhzPX0EKcngcxqi/da9ANdKbxr2maRdo=;
        b=GVEJRDnslneTZXcGAAXiXbHD1ZJRlW2B6R/1QBrK3SRpaKa6SQj3y22Sv69Hg6XHYG
         qTGTT2jk7iClmxLscsd+V/iKs7Cn6kpfyGTLGmNy4FiyNpDFSJJVbKXZisVxhuwyzLSR
         +3NyS1fyYZcYjmOU9nPMAuEi4GyGBhmaSfkRKuy2Vqro33uk+KCso0A8qRUWsbg+P40C
         JJH0W5j1Kv+h9aEDG3JwVoDai4O8s7UkPKK5oqZYldDuOUFAJD/P7XDYiQG+tOMnfxFI
         PrjnsL7E6XpZhh0O1BnRarcbrY0vppZctVjPVi2Ahl11ha3lC2Nlo7yh6O6mhgq1X7di
         f2hw==
X-Gm-Message-State: APuU4Z/EPEQYM45nfIQJZMy09JRQ97HKOZI1Cl8ogQRwhGMHRFJ4VXNL
	t09+OGEt+4eOJ6XgOGvd1/VXmgRPgOGF29qImX8H9fxi7Z8OxDRorYrEDWrjNtjSq9kfLGGfSpn
	11seax7iCC1JjRO2IYMzKpwgYpnBaXmjKQ8rKULC93G871Ow4
X-Gm-Gg: AZFdTZc7cT0rA/d+mUC8K6iRjCiRF6PGTtKifV0//pgWD6rY8TCkjk5Wnmai3k7SfBK
	zv51mPDoObGNi/IW6XWeAr5mQl4AdtTJE0sj+66rbGM0Xdwa6fN62hpMjP24u724pR+5SYSTjeo
	cIkKF9hbO7xTdSYGBKLMG8P70b2ebbvBQlWMr7aMQL7Gs68kU+RpaG3QFUG4KaxTT2UFb7b5T+F
	mjNqr4GJkGdwQjyt1O1NeNznhxZ0j/okWbn4DBTpnIMzehtTbyDjKWZEd0KJsfa+I6rbsOiZ55m
	lwAsVPI2iUO8g0wz29zUTPr046dhkSKUQmtdzmgW7rU7a5LmAfyPd3OnyCotq0xBZ0sWsNkKPaw
	G4Jl+rkFXTdRqCBOWijoCxw2LVfBqfmzcET5ZlMqQbVkfnAzmVxGQToPt3bnk494jI5gUxF3HIi
	2/yZmnWTul1+JInwAu9cusCqlnM7McdB8Hw0SkuL6TLzF/TVVg2eSs62r/30Tdt1b33KWVLqZwN
	CYoEewCo4KC721kMIihcoMveLTAyLL8JAL1S9fpiaZQoJoE99iJoqS5vLaIDX6k/tE=
X-Received: by 2002:a05:690e:1209:b0:67d:c588:e55c with SMTP id 956f58d0204a3-67df42cdb00mr3845658d50.5.1795455124704;
        Mon, 23 Nov 2026 09:32:04 -0800 (PST)
X-Received: by 2002:a05:690e:1209:b0:67d:c588:e55c with SMTP id 956f58d0204a3-67df42cdb00mr3845632d50.5.1795455124303;
        Mon, 23 Nov 2026 09:32:04 -0800 (PST)
Received: from [10.206.149.246] ([129.236.230.139])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349f2186sm113214946d6.29.2026.11.23.09.32.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 09:32:03 -0800 (PST)
Message-ID: <625b9f25-9d9c-4445-8920-b8a4e549127b@columbia.edu>
Date: Mon, 23 Nov 2026 12:32:03 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: fix swapin livelock on a mismatched large swap
 cache folio
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
        "David Hildenbrand (Arm)" <david@kernel.org>,
        Hugh Dickins
 <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu,
        Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
        Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
        stable@vger.kernel.org
References: <20261027-shmem-swapin-mismatch-v1-1-84e30aa3b9e5@columbia.edu>
 <3c61a49f-6a0d-49eb-8682-aece4e7e7226@kernel.org>
 <4af8b7ef-8028-4b98-ad21-5620f8b92f42@linux.alibaba.com>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <4af8b7ef-8028-4b98-ad21-5620f8b92f42@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: BzDRf-orLWTmdioNnpeGKDNb0Nqwgq1r
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIzMDA2OSBTYWx0ZWRfXwS1DPBT+mYhQ
 Sp18rnSi1URg4RdrAtpCITROJ1vnagE5Tk1GtrVRbsjJZkI5/YipJt7o702YXXfBrLNiClC7MOB
 6Yx0N9Bjp+CHlWEbL7W/9OpYdwkLjdQCvR/F22JMi0oRjIpuTPJ8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIzMDA2OSBTYWx0ZWRfX0rAKa0DFgBzi
 l8JAuN9JNoyE/FMx17axeRKrFy/r8Tv/au+ub58eNadTfDUExBQ/+VyOTY3UWSFUXMbBoudRi0u
 Eqez9NfQth1VHhUgyStXoDKV8vcCB9AiNKM2nnZueKuxnyvN9FXmdTLxf2C1JrWvuagSSOo2x5c
 Y7eTc4/bcFf8g+gmYYM9FRCQOUVL5KTcQIFp2oO26Of6HW2bdBxTRkfwkyCbn84nOgQvKsJq0qL
 y9IzZe34smMtYQsQRrgSXfZujP+uXZfhfvepwc9sotlEREcd6DgYFrFzKlRtcLP1++6pZqpwZoo
 RlD48d93aScJ/zIer576Uq2AcLfNDMfsQP1fSBDIhar3LssW2oRtvkACWe00BaAh0+1yM3kzjhT
 5q0O/ZLzDc9r2m0newMXcsFCcQVI7yBTJyhOXK3JT11eWTS58aLM6iTmhk0zQ50lJC3q4bYPNYA
 hXm70dEvWgF0bxXkwOA==
X-Proofpoint-ORIG-GUID: BzDRf-orLWTmdioNnpeGKDNb0Nqwgq1r
X-Authority-Analysis: v=2.4 cv=HeeB3SE8 c=1 sm=1 tr=0 ts=6b047896 cx=c_pps
 a=VEzVgl358Dq0xwHDEbsOzA==:117 a=0AiHgshebfoioin7TVvpCA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=VwQbUJbxAAAA:8 a=EcUMADH1NWUpQPqG1_UA:9 a=QEXdDO2ut3YA:10 a=QYH75iMubAgA:10
 a=uujmmnXaIg8lM0-o0HFK:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11975
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 lowpriorityscore=10 malwarescore=0 spamscore=0 suspectscore=0
 priorityscore=1501 impostorscore=10 phishscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611230069
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C25E140005
X-Stat-Signature: t7io1ezb5gq6smhqa4cn7hakzrxn1p8e
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795455127-981307
X-HE-Meta: U2FsdGVkX1+Kt+uMOczGq8PcqF/AMDAuPjuWPbciDyRsSdYs50Mre7dnW+EcTSmlFH19uGIb+AcfBDzOVbrH8ha5kwuz86/2+PCIlwOWkFC85qyByRG8M+C8/YRXYajix+HvpcF4Nhgg8q8ek9PzIxzcm1UAGFdKENvgNavuc5p2HmfipMuIEDv9tSW1l/fE2iltRhESzojox25Qrq+7z6bxeOOgKc3BkssU2ic8FtnoZBZTE4CaMGDkwJt1lzZsSMy9OkvpmhSxMuz4RtQ1sl4FgyYWpO5WGw9kh4vLA0lYZrj9fPtrtXePvNXjaCL/VS3JzjHN3qZ89PX8RChyGYfiaBlRDFS0V1XaWGbR9qAe4zj9ncighPWdIeMbmTGeKo36+bAkWn+0vCV9ZYNhb07UxRDolgYS/liouqt8AA3lN8R2Fsf+5lJuWjgWYYrb/hfykBJRgIiZt0cPCUw2B0DbsZIaIomkn9v82/PmXlkBHBotgLEEcZj9mrisFrGWzsLGokWB1kXmuHUApA2EqzHJzOd21EWcuj/q52xUiB9x7I1maSDC6oYWtg2ReFUMm4Z3TYp0Wo+eSEfxEDKPNbyRZ/EOarwZUW0bsXLaHnMVBL67Wqy8PCm5rgERMWPY2zvTHNnk3RwFRsfpRinqlc/iOB9LSF6ZkwowHc5atyWQpmuzR2CKOfSpRuA/Eg7HEv43vb6IvloWj6Qp0lFHe8FIgTaF4v77erQSaW3SgywFlov0FeTB3rqra+lTro0GDxRMnnx4gSvQKJsdcOdNppjB4fgpkN0dJI2BiiLSNUq/EQrW1b/3qsy6zDzmNzHkr8YqvOrBxkljxUfsoN2SJ+jxZXt1adtKZYG6Y+l7pBsmwxVBwbV2MIgYWK9OparfMKpnoEXMVjJKGBsEQ+GVL9GZ1VNUrPtKMvNLNpNkAbr3PV2hMuEV04VGhSeTdxDaDdP8233z4mvblJKfRLF
 lI433c3B
 MkDwAtI/t5mQYKUly/eflnabV2tK4JL8KnbY8v0F2V9k29DiCaGm0/0T53JNn0j88hM8rQIYsM+Ds7VtnJze+AmqORddanWNVG0TDj5whPAAaIpsAJ9dk0YL1AeKB0Bqe/dyFC/peMPResd9SfSvfJBKYLt2wDpDKx6pr0SEIR5cwiHmdzW/wHkXAO/otBmu4lLv0Swp0E8S+94UYbN41+v8vKV7Mu1nF6ak/4MxWTlZEoB2ZhZnOvi4ABk5rQa0ySLy86QCTfb4+23UbixrqoJ61C+0BbqqZUufxbxJeBLMxV5Z8ph90ybfIYifGuHWeIg0RiUvcagolGnzELvHIMxGXi2p/q5duEiWEDMzIv6YhrtR8o/BgY8qgg+2ePfxoh0Aq9ieLwxN5PlfiSwZD4rlznImucuzMH0e3LzABa0wsr3TPvKj/RWwVqp95BmxmyC+h0Nr8KfwFrwZHeVsLrgUvzad2cSQmTETPdtWiMpXdlRjQaxlyyCrPD4iSu16WhSGaImQXHZQASwdz1n4CR59xpJ+2an1ce4J76bKcN5UCY6RQWoP48LuOTOVq4HeV0XosZW958WFdE51a1p7t/Z4iqrzWmLw0DUmdMNBSgnJYbq2XvBOWEKMGqp32cm2TIlbMPCok2fqO6Bet2nflhNSGX7Ze0E3ECk5W++mq5sgCNbViJRxyHJBwMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 2:18 AM, Baolin Wang wrote:
> That makes sense to me. If Mani has no time, I'll take care of this fix.

Thanks Baolin, I was actually about to send it this morning (and just
did!) And yup the race is real and the patch fixes it. sent here:
https://lore.kernel.org/all/20261123-shmem-swap-write-failed-v1-1-41a0115dfbf1@columbia.edu/

Sorry for the delay!
Mani

