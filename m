Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2894F417F1
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 14:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 188326B0005; Mon,  9 Mar 2026 10:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136446B0088; Mon,  9 Mar 2026 10:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017B66B0089; Mon,  9 Mar 2026 10:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E44866B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:56:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E5A71C192
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:56:47 +0000 (UTC)
X-FDA: 84526826454.23.DBB6C3F
Received: from outbound.st.icloud.com (p-east2-cluster4-host9-snip4-2.eps.apple.com [57.103.78.213])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8908AC0003
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:56:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Ft8dy1hd;
	spf=pass (imf22.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.78.213 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773068205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOhN+p1crgw6WeP0xjnqp4QlR5PHq6mVgxA3ESYwIB8=;
	b=GbuaM4ra62C+QgdZiDM1I73J8xJdYUU+VcTJPK6s79rMuycuLNd7dgv+gFKD+JCFb8uqMc
	a/V2HZNpa2mIO9QF37v5ZyEzYuJGLX66Sn/4MbwV3BGvV6JM5SAliDaA+gAf3hA0WigFyv
	eHk7fk5z21NB5EveOfma0cifjelkvOs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773068205; a=rsa-sha256;
	cv=none;
	b=ax/S7e6k38KAFO/l8UrnwAWt/5BOQuSIodW6OjANJMV3uYZnKNKyn/cPTmMCGxwPWwDh9w
	ysAiPaIfiQ05UxBfJYThYPfvzCbmsE3dZLVXxRyDVotDStaUuVTeq9flmFOTsihqaB33AO
	4StkW6iJMwVTotwxgWKG5GGU/V3sinM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Ft8dy1hd;
	spf=pass (imf22.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.78.213 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-10 (Postfix) with ESMTPS id A38161800CAA;
	Mon,  9 Mar 2026 14:56:40 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1773068204; x=1775660204; bh=GOhN+p1crgw6WeP0xjnqp4QlR5PHq6mVgxA3ESYwIB8=; h=Message-ID:Date:MIME-Version:To:Subject:From:Content-Type:x-icloud-hme; b=Ft8dy1hdtfRvLHidYhB5tx4+gShDxqSwbmtl0qJod+n0yanjsOLOaY6msHIpZCWOao7mxg9c5K5Hl7ctgugL9OAuRtf4o4bvTfgKUJZKQmRO2cjbn5JngsxRgxAbCx0KBlJWXysoz64eeGN//+RJqt2bxQEtHrKOKeVZIhPvimU3ElkCM5+vjj5hV9FeE+bOGrYTahN8bBnj/GNM0V5Zw/+9LDC3qDn+iThSswrMWu8bppoeRqJr10qnk9hNq0hWGNXYjKR7ZKt2Pv6ut21Cp6OCSWeNx1X6Ffm2Eom+0FdpEuFYNJybE1yadJZ0TBiEa3QacBmX0AiEVBTjWjwNHA==
Received: from [192.168.255.10] (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-10 (Postfix) with ESMTPSA id 6965D1800CA5;
	Mon,  9 Mar 2026 14:56:31 +0000 (UTC)
Message-ID: <fe90adfa-cdb9-4d64-8161-7a944fe8020a@icloud.com>
Date: Mon, 9 Mar 2026 22:56:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: usama.arif@linux.dev
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, bruzzhang@tencent.com, david@kernel.org,
 devnull+zippermonkey.icloud.com@kernel.org, hannes@cmpxchg.org,
 kasong@tencent.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, mhocko@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shakeel.butt@linux.dev, surenb@google.com, vbabka@kernel.org,
 weixugc@google.com, yuanchu@google.com, zhengqi.arch@bytedance.com
References: <20260309122939.723610-1-usama.arif@linux.dev>
Subject: Re: [PATCH 2/2] mm, vmscan: flush TLB for every 31 folios evictions
From: Zhang Peng <zippermonkey@icloud.com>
In-Reply-To: <20260309122939.723610-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDEzNSBTYWx0ZWRfXzuRowVDcjuUk
 qZl28NjDKWtfu/wsXd4Y3NunQUv5km2+TXqCtSG1okUiZy+HRqIvKuUtu16oGWq9C/4tbDFhh0B
 EcqZxJ78rkpcy0si0+NkCjxyh0M54JijjRTQ+joHgzp0NrA0lnH+3/w6SOW7Ju3rPJoxdHJVmoo
 RV8VQf1FbTfoxZXmI2I8gcam8ITRjDYs7Ge82Zx5N0I/6hLePodDK2KtF6HkNkQ752+aXGVao1t
 d/oGDJpRbpSvVgFp1Kom07cQvOnmMcpj8LMD3Xz0w8IcbM/45J4XQQ84qoR1C3kKJBcE9McbuyC
 +7vsPrM3k+5or4GfGNOydnyYJncLxAM4+eCq6YU+GfK0wGsy5pqPQ96KOMz6h0=
X-Proofpoint-ORIG-GUID: 9JmmZQo1-hKuNE6_M7YufrYeXvfUBHUL
X-Proofpoint-GUID: 9JmmZQo1-hKuNE6_M7YufrYeXvfUBHUL
X-Authority-Info-Out: v=2.4 cv=Ya6wJgRf c=1 sm=1 tr=0 ts=69aedfaa
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Jl1KS0vY5v-l7LHE-VgA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10 a=J82S1U87d15UFHHUFZS8:22 a=Q8qS2GGGQ3of7AWJm7aR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=757 clxscore=1011 bulkscore=0
 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam authscore=0 adjust=0 reason=mlx scancount=1
 engine=8.22.0-2601150000 definitions=main-2603090135
X-JNJ: AAAAAAABFL7hrkCZ1z6QL4ty2ViOtS+DQZzwrrd8cU10biBxS+s5aaLwlGZ7oDDfGRBcze4snwbnqTBM+Q+EefJTgFvz7GkwpDa2qOSHPM7wXH4bTbxS6AeI+WVidncimh9e/1KZwfn627mo0mrMHbsTFelha3cKJcYlVU1oKK5LcVpQ2Z3ldlHs5IE0b1DkVEgmhYMj86678S73/4TCfHZ1dDDb5L0X+9Wnggk8VkiV/kjejiqwmB/DPWpEKx+lBG0K4n/ZHsoT8CvjaQHmhVVJTfQ9JBdkP2YjuyrkFK3+0Elh8/MnvuzGmsfBAocObUntcRhntNJWoDu0APlabmyOcusDe65thsQiEJos/bqGqYsBOG6FXYlUDkhPf90lSm2iyHJ3+/s9DvdJJ4tQC726Eoe/ReDRwEEByy0yTtfVI2aXA8tDhZlpDDwz73rfuYoZJo5lX13iIeZ5CL+iWo11xPBOuPoLJkVkIR5wakwnEiRbTQC/zw3AjC2o+hIg84z6hyKOT5KXxq+SSDFDtXg3rfmNUYnJ1Zgq7lBUmhasjTryGT9MP9Gu65G4hO5hJ3vY80bvpuJZScapJI8EHbE9IjlT7r+pYAFdacIff9U0r05Fy2lik5FtFD8qtnVV+gsVfXKiJWIcz+SQIRa4GDLO6IZcOq67zgb++AdmqzE08lEg0tOZzkmeB/IfDW04MY9lVhRhXN7GmV507hiBckohR3QstnD057ovhtEkjFpWzdwiwaRGH1W+c9le/NohvejQbI424SyeDos2e4PDFez41RSBCS9v1MwpqacmNzpJVrZauZEu6yZczG3m+jW9/3jhUUGAd6OeiofksLpBaoRuwJOxtjWUXQ9E0Q4jN/o5xlssmagguWOniYIrWMfDNBhTRT4+Ldr29Ga0e0b7uwsLxiAFvpxtgzME
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8908AC0003
X-Stat-Signature: np6hkp9bi7oax4q1df55a35ntwiaphd5
X-HE-Tag: 1773068205-370282
X-HE-Meta: U2FsdGVkX19u03fyim19Mvjl2tCxr1I3O6xNigfYVlt50g5vWvzbm0xffc4TX6ePcePw3PHFVCxUkPaOrST35q4T+YGqg5tj4M07F4V1Ye+LnduIhgw+3rDvbF+M5NqRUUUpo2dCl7BBkqZsbC8det0icbCgwD4REJuWx5Gwjvfsxgqawn67DqMCuLH0ryQg1vcbXMKjNrRPU8Sw1wbaWa3QuRDK25hqevXm2WxsYMdB4yEGJzfHoHH4xJQz3VWADcuqu/joSk3jcQPbIUV47fLjWkWlA0aa4VexKa2Tu+f0Wg3fPfjXqFAZjv04i3cjM4BFRB33UM9e10A3VWJn48qDKTrVoGARm9KauQyP3WSIFKGJStFc6PwD0/zVuzV+6R4evPo0vrK2BkS1XxyTyNaCUSXTKoJpWk8L4gCdWnUZOfA6i0YdjePzCVAWL9E75lptptfRwmERvSPepSl259+BNQq3T/8QaRERH2/661d4B+i/7fZ4ypSz9B2FbvDG+wRDg5e1DwMq9Zsu2mDqLqehIAfmu6dtVRK5cnI0QH5W112kYhm4o7QLh1MKYzWa5bWbB7q5bsbseEzYWP3AtztXYbTR3kYueuwo1Gh3OUoDh+SkVaYzWjkV9tl196JcvCPYMqzVjrDQEhDFm9zVA7uk/XSPNeYtX9PJf8zqj9d1LcQgujDRYyZsflC0oYRRsR2sC9fkjOacVs7N+M4of0FMYekaX+N7FP6b+X50bllUH1uvDo5Nzraa17b0UT3KNW7qFt0cEJOBgLoZDCqppRY5RHRDRTP15RMHvWCNI2QHzZcAQ8DkJWzGFL106G48P9wjfbAn7nNaBN9UmbGtb7HsOMlqUwM+427hi8MRJRSbfJQ31lOQXXC6OPt1mBP57b5Zh4NJcNGUorDtmjHNCBVifvbDVWi9YwZqABHuw0cgPi46OWgpOFbHLFW6Nh7+cCg6yzSpZJZjUZg4Sux
 9sujkzDP
 L7vLLpngHxOMhb6e6lQP/Ga3x56QJR+qdTEmsl1TaENEqSrjSlsZBcJiA3XCyGDgTNBdIq0n6YqRkWzc/xPgQbKwy5Ub9eQxkgZy7fOSEQqlfwdGv9MeiDObJgR0L8TqrWPqHdmvSbhMQh42yU02quPs+dYMZtiVDnzOUAl9aDzaJ2GWWQHeJFGXls6reetnxIJm2Kq231jv1DpCPXxvexgvxjwGN47Tkak0tabxKQQ2z6KU7pG41RzvmY7RdJri6kzGMk5O2d0rQ6lYCNrAQJ8Ik3jIqJ1TfDmdAl3sVBAHZheC90FZT6Jylrk9D6VyKAw/E0mFhY0/lULYIpxEOjNmsKwUEX/E9R8kB3m253dGr7785Qub/awuGz5coSWqT0/VEQBvAf2G+ejrkO7LPyqXWKCEs22NpV7KakV7WIh4oI0VC8CwSz+PzhJVLqK5Ow1b0z5cA0l9xrOyjbOLGRNmzLHTDpEzhTTyzTaczNf07fpkaKrRR3mlPB01XFyLetQMw6D7uNXESlQtAR92cR0C/SIExufTvBhz7oizVBtv0GQSUOLCQMrq3+ZTe32g4yiA+tMNmYRvyiGsLcd91NWnU1982tmnu2wMEPWcWAMGKEFD24kHVjSr1lkJGvAHzKZZN7swlv3HVPbm+tJFXwNgU8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

Thanks for the review!

You are right that the comment is wrong, page_ref_freeze does not exist in
pageout_batch(). I will fix the comment in v2.

Regarding the data corruption concern: try_to_unmap_flush_dirty() is called
before pageout_one(), so all stale writable TLB entries are invalidated 
before
IO starts. Any writes through stale TLB entries during the unlocked 
window will
have completed and landed in physical memory before the flush, and will be
correctly captured by the subsequent IO.

pageout_batch() relocks each folio and rechecks its state (writeback, lru,
mapped, dma_pinned) before proceeding. If any of these conditions have 
changed
during the unlocked window, the folio is not written out and is put back 
to the
LRU list for a future reclaim attempt. So there should be no data corruption
issue.

I will also add folio_maybe_dma_pinned() check in v2 as suggested by 
Kairui Song.

