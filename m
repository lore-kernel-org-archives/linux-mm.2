Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AAF8CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8736B009F; Wed, 30 Sep 2026 07:22:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8693D6B00A0; Wed, 30 Sep 2026 07:22:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A766B00A1; Wed, 30 Sep 2026 07:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48C626B009F
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:22:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF2EB1C37D8
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:43 +0000 (UTC)
X-FDA: 85270191006.05.A35B881
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf04.hostedemail.com (Postfix) with ESMTP id D25DE40002
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="h/re0Uxu";
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790767361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NU0OQAMOUoLo7I1A1g/IyX/TQMOjf6Pp2QYWnGCx/48=;
	b=NrayjyZLu7KbqeQV8Y5XkWJLuuQqTTqFKgQqRPtkNl4Y11VSH7tHyeeStyvcbnfAdV/OMD
	OvMaYfSC7PLscK9XcZyHYdY97E4uS+sqiyq06yu2bbZi/T84kzFWHmsqLYKTRemOk6kIuK
	trgL694tZF715gN/W9iQWTPj10rtxns=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="h/re0Uxu";
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790767361;
	b=CTmC5B/zSLhj7KWT+ZsiemqK9a0qbGvm7tCKTxymIblzGQi80XYtLIjV1Iop5YFmWBUP5k
	/AA6UeeWCuymoPNbiD52bod6/6G1jZlW7gla4zGmEpmNReMiNYfx9LYvZ1QraeUMQvjADM
	OEX5sMjJ3yP4ag21Ebtvw3Mn5bs9Oio=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790767356; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=NU0OQAMOUoLo7I1A1g/IyX/TQMOjf6Pp2QYWnGCx/48=;
 b=h/re0Uxugwa2OhK6hXIoeL2/y2BAP4NFKM9YSsuKuE8HRSFjzsTzgKJcd4cw3wL8mPcw5U
 rv+HYfJAiubLCJv/kTynWkLUcIJ2T1TRmbDCDYZdqpu3fB2ZteCEvZm1+cMOgHUYhE/Okh
 smYvWYUYCgn11yd7FFPKZtz/NKvPvHsFckpn7luZYLSOd5dix6qIZZd3xQklBMZ1+IwQoL
 WY/5sPfQ4mn89cqushvLRYUoh1W0BBXCkkA6QXO+eGtYY+NWnC2v7dIlatcagPWuFffzbP
 Did6g7h/0Hu2syF8+WD4JC+pZl+2jsjtynj43ilFTbIKeUhBSE2DPFsUxo7tnA==
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<liam@infradead.org>, <rppt@kernel.org>, <mhocko@suse.com>, 
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <ziy@nvidia.com>, 
	<joshua.hahnjy@gmail.com>, <ying.huang@linux.alibaba.com>, 
	<apopple@nvidia.com>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Date: Wed, 30 Sep 2026 19:22:10 +0800
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
To: "Gregory Price" <gourry@gourry.net>
From: "Li Zhe" <lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26abcf0fa+aaf5ed+kvack.org+lizhe.67@bytedance.com>
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference with MPOL_WEIGHTED_INTERLEAVE policy
Message-Id: <e195b784-8a78-4bbb-97ed-168dd86b3d89@bytedance.com>
In-Reply-To: <arzR_QtoMPtM5kUB@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
References: <20260930072617.64665-1-lizhe.67@bytedance.com> <arzLw18RiTN6Hmey@fedora> <7df34f77-2c52-47a3-a495-d782009ab543@bytedance.com> <arzR_QtoMPtM5kUB@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D25DE40002
X-Rspam-User: 
X-Stat-Signature: xmz3u9ggtu6g669npjiryz49ytxkjr79
X-HE-Tag: 1790767360-777316
X-HE-Meta: U2FsdGVkX19rnFMXohZnQ8vg8wiDyV4xJr7JHFQJoui35HJkYGPTNQ45w1Ii/+QCqcpBAfpbd+N9H0KoEfQLsid8bCc9SP71x7GtytkiZD6PzbzU+b/6hiZlR8FptpWNryKn3jCdvvEupVv9b1wyAtXiAJEYFmlCIhwrzHOKjYOjDmT2X8lt+1VOsuehtEb3Rdw/j7b+md6U7a0p70LZpSyLdJ5FPBjsL5nNPIB5vdudZNlPw90X5DRY4CIsCKi7ArFp6pfiTdtnWAPndBlw0T/A9wAyEWxprsvQFOtbjUmt4LPcz6TreSjHMbdHqze/ZEhMt2nj3FQpaJI9W2C3L/CD1ao+x0AcEWcz0mcTohESdoD16FBZoFIe0nB0fGVJz1BPdZG4WqhXVX40e2adhvJJAs+5UzDBzc+JfrxEpafxwnkqNi2l3SqnVeAz+AFfLyHo/vds0EW4zDcfgChLWRgFosqDuT8ewwktFfU7up/+69hxdQXDLRuU3eJzOO2lI9zL74WMjBdvCMXT+IRfnF1yfeyJkvHTPE1vD7gXi8B1kRkSvrLNyhlcKISKlxC1GcynTULsPX4KXoldPZfDNko2ny73rpnz5La/04tLVrKNO4FvW2dLeKP3Z+4oljPRXzgc5eJH7mENMwjC2okPaMDflb3LN0ieiLFl1643x+jQw7QGtNwM/yjaRX6fl9KVbXPgqdnXUFcWRdZz3XxnvVnoSc8oVwPojwLGOkN0qONvk6ZspVDwVFY3t1dhlIUTzbqeCq7kj7dIoI63HazLeXTbChUfrtpO6uInsJY4GcFo7fP/MF7sWpFPBn22WLNdWjHQFkKLhtOaHB0qQc4MkUunRrHdShWXkx8baJinIj+UPqUXAVuhboTlkwAoqW3aYglVBPIG4d/P5ryhZeIy1JojlJNUZVFirgTevUEV5REnmlA0ei1QkdoVdt3Fq0pxeWJ1gqvv2mc6Al8egwC
 Vy4a/Adg
 MKKHuPEiKuQ0RQFM8g6ximzG5nSzHy97ILnlOIntNgPadlR2IVdtrKZY+h8F1Qvv3zARcpkxZtUfyMoxlRS/RSBzVtBsx/9resZ2ZSG7nBmRuUtQBM6D/f2uNVUuC7SXT8AJ9dSG3G0MaihA7X9DUg8QeqkayflUNX7zjYgQrskQ6qVgnMbgU0vhmIX5UVbVSDalpLL9kYhruVDBGnSNXmMuq/pd9RKS6XnrhrgzG64TxRbdZsPg3zMo3ckR3dMWey+Okd9lZLCaNtFQ8yu2mLKNi5npy8sDCG5EWfQvL+TaUeueG2A+mqOJcRGjkqfVNvh12WXidVPwhDeMwQRbB/ufDFeAnUuzxgVCJVRbQlW4F8VsgIdE9F0hEFJfyCyIBzZFH1VvEXKnhX5M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 5:11 PM, Gregory Price wrote:
> On Wed, Sep 30, 2026 at 04:59:50PM +0800, Li Zhe wrote:
>> On 9/30/26 4:43 PM, Gregory Price wrote:
>>> On Wed, Sep 30, 2026 at 03:26:17PM +0800, Li Zhe wrote:
>>>> Allow MPOL_F_NUMA_BALANCING for MPOL_WEIGHTED_INTERLEAVE.  As with
>>>> MPOL_BIND and MPOL_PREFERRED_MANY, keep migration constrained by the
>>>> policy nodemask: if the CPU's node is outside the nodemask, do not
>>>> migrate the folio there.
>>>>
>>> Why for WEIGHTED_INTERLEAVE and not INTERLEAVE as well?
>>
>> Thanks for pointing this out.
>>
>> I focused on MPOL_WEIGHTED_INTERLEAVE in v1 because the motivating use
>> case is to seed memory across tiers with a configurable ratio at
>> allocation time, and then let NUMA balancing/memory tiering adjust the
>> placement based on access patterns. With equal weights,
>> MPOL_WEIGHTED_INTERLEAVE can also cover the regular interleave
>> allocation pattern.
>>
>> That said, I agree that MPOL_INTERLEAVE can be handled consistently as
>> well. Since this is still an explicit opt-in via MPOL_F_NUMA_BALANCING,
>> unless others see a reason to keep MPOL_INTERLEAVE out, I will extend
>> this in v2 to cover both MPOL_INTERLEAVE and MPOL_WEIGHTED_INTERLEAVE
>> with the same nodemask constraint.
>>
> Looking at it, is there an actual reason to limit F_MORON at all? Or
> should we just lift
>
>                  if (pol->flags & MPOL_F_MORON) {
>                          /*
>                           * Optimize placement among multiple nodes
>                           * via NUMA balancing
>                           */
>                          if (node_isset(thisnid, pol->nodes))
>                                  break;
>                          goto out;
>                  }
>
> Out ahead of everything?
Yes, that makes sense to me.

I do not see a reason to keep the MPOL_F_MORON handling limited to
specific policy cases. The flag already means that migrate-on-fault
placement should target the accessing CPU's node, and the nodemask check
is the common constraint we want for all policies that opt in to this
behavior.

I will rework v2 to handle MPOL_F_MORON before the policy-specific
switch. Then the switch can remain responsible for the non-MPOL_F_MORON
misplaced logic, while MPOL_BIND, MPOL_PREFERRED_MANY, MPOL_INTERLEAVE
and MPOL_WEIGHTED_INTERLEAVE can share the same migrate-on-fault path.

Thanks,
Zhe

>
> ~Gregory

