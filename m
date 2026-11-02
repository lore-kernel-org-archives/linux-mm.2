Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC888606A330
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=xWMWKiVm
Received: by kanga.kvack.org (Postfix)
	id DA5086B05B3; Mon,  2 Nov 2026 04:29:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54FF6B05B5; Mon,  2 Nov 2026 04:29:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C236B05B6; Mon,  2 Nov 2026 04:29:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A80AD6B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:29:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EBD0160C04
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:29:20 +0000 (UTC)
X-FDA: 85389655680.03.EEBED57
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 74D71180003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:29:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=xWMWKiVm;
	spf=pass (imf16.hostedemail.com: domain of zhenghui.hao@qq.com designates 43.163.128.43 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793611758;
	b=Nj2wId9ZuHXxkr9DXzAYXBq7T5COsQCKMRC50aHUXfIkh9PjIT12zw77dO+xMhgzZUwEjh
	v0H3eFI7bzYB9XoqdIlSqg9mhTP9XePzgk1YGP7qLh0GccfD9j3d7lMA1eFjVOwijwHUgK
	9raRQ+O2wGFborup4vig4GrfcTKjBaM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=xWMWKiVm;
	spf=pass (imf16.hostedemail.com: domain of zhenghui.hao@qq.com designates 43.163.128.43 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793611758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rxxX0qla8hwD31pbvXQlK+1bs9/2ui2XSllowjYuYoY=;
	b=MuOrHhSoStz5bHPRHca5PnjKQo5iWtswJ02I94eFiLvcAz05kM1S2zhlTE/kyQxJF+y9ht
	w26Ccp3GfpLwxqUELD9OaXfcW3k0kh0762qwInL+JH7OP+7a9DTcc4K30avYqwLKi4YKlr
	ZeaZ0vPGWAV7tISXzSp9PBOziNlkeY8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793611754; bh=rxxX0qla8hwD31pbvXQlK+1bs9/2ui2XSllowjYuYoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=xWMWKiVmR4TWRLjz5V26D4ZiVQQDnJyZIPTesIcDxnwOEEf7RAm33b57kZhtdrlOz
	 N6vC9SQvPnFgAHWC+ba6UN3UVBjt/oNumXtUfj/kjZLJl2x3ZbIcKHZ2jnID+EXKeJ
	 7MVVeiz/VBtTyOHBeeIjKOn9fbdjbBjLI9s4dAZE=
Received: from [10.88.157.208] ([61.169.203.203])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 74BA5091; Mon, 02 Nov 2026 17:29:11 +0800
X-QQ-mid: xmsmtpt1793611751t4nne06do
Message-ID: <tencent_9125D3B8701AD20B318ED534FC1119659807@qq.com>
X-QQ-XMAILINFO: NtdA9nrf+Ds0cXQSZJ3paxv0piPaAhDTo018K5/oh91Q4O2tGuq3ACE0h5VgjB
	 4QWmoUF8jTASINayjdNXRZZFP75OwhKqw8R3AiF8bf34i2UJxNZCkkJ+JhPODCDHuXXCnryenDAj
	 S+vQVly7g82FkqplaK9xqEDLOKkvOsaCNFP9lcXGmmcwkqr8sL/V4oeGg/DMyx4eV0hE6D3XmFjR
	 e94E4TSDG7MYTHIf7hm2gy4sghHkPyoepqDU1XF0ixQbQMwJp+78GNGsUbfA+k+jqjFmJeXArPQU
	 lvwWQPdC4NQ9sn76d2qB5WaQcVJn6IBwvS3WHyy1w3aXTtV/L4ZoPXPp/M7IVVXY1dO0N6DMA5ih
	 hikz1rmoHV+f2zJYH5l9XSi+kZ2ZxihDFbjT8VHr51kCF48tXsscZjMgNkzskajCILHBgNWwvm/y
	 IKL1LYaQX0rShGPIgMpJO3+IYO/5irg8f6vv2q+c7/awbUGq1q/Ox6SCU6dVWaEcShVPuDhhyrNd
	 j7LKOdFUMTwdbx1gzj1Cx+QdH3APayWbYJlxE1S8bhUwcSeG0mK3El0eZPkkyZ18+m1hNFj0c4en
	 a3u4v5NjcjuOpTALIHr4MqJj4b21gvRYnq5CIJcvUytTSCE1gM8LtNDvLpZE7pEVwpfHRNtuOV6O
	 Md8cDQqsgETgFOsMwJqWxIuMUvs91ZjzCsZjmJf/Bf0zwkg3HMAgEi9ZCPrVL3WWCJeuWuMHh+fe
	 zqBUVCxazjtV6Q4KZ2DX6p8L+ww+etxUDQ8v/YgQXQy/J3SzWV9QOgh+cBbauXtM58khhblMDUrg
	 6cnHtEe2NOv4XfXvP7Il0yUBZNrAz/vf/EBJ1LaT9vDJd/2OLyop0X1RbHQSSbegO9vAj1BNaVZN
	 +dFVexczlFge4iuOgKpcBv106m0aKBZI+OKZ9xHwZ3SP1VFn/zwiPRaiyrfOMwsKGP/pLrt8jg+M
	 iTT3WC1/a+MakyQZ4J9i+3j1qCF/5u9Z7R/dVnlhbH8KUCThVt7hXs5LNbzgb/Cejg1Q39GC5C9X
	 jIwCCx1qIGUIW37L4yCJ1me4mJVLG18rBYVeBVnznoNX+WjPpVebr2VAv2w/Lor1wBbj+M90wLyr
	 KeH1qfCwT707i+LXx0Pm0A4NfD8/VLUqmk/LbewViaZgCvO05vIRMeXAZo/WGulKxzE/4KjN66VR
	 910tM=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-OQ-MSGID: <b23eae5c-0bc4-4556-8516-82d77272ecc8@qq.com>
Date: Mon, 2 Nov 2026 17:29:11 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: release isolated freepages on compound
 range mismatch
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <tencent_869149E9C4305627F0ED654860AC4DDBC309@qq.com>
 <5d79db66-2195-4f8d-a721-e1756bc6ead0@kernel.org>
From: Zhenghui Hao <zhenghui.hao@qq.com>
In-Reply-To: <5d79db66-2195-4f8d-a721-e1756bc6ead0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 74D71180003
X-Stat-Signature: tn3moaku3g7ugrf39k6rmbssdjbjsbtz
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-1.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_MUA_MOZILLA,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793611757-288844
X-HE-Meta: U2FsdGVkX19CMokriyyFTKTVKJCGxFXt8NaDQ4VhEgmLj0P04LY6qj+Klqo9Q6VJzDuHUq9b8DzZhmtWJtxTdcdLAH7SV9iYHirrVxm7G5F8x8LnAnyEuK/ktgzTZVV/r8IS54yb50zciEl7FBhqYhpPX+5hxLYmo6cplIpWxYfEoA0Gz11bruXwxtiWFYHMWxYd8r8Ba4ELt+uva0OP86cT/m8WxcRl4TKpM56iJI0EBSHg5LJ4WkDnrtSh5fZ79sM0lIhDULSDiXQUz2PBiNrALOb30XRil+ckuasTdm0zad5o74SBZn84PU+Jb5hGoAxN3p6cjEV621UecCFjP45pqxDTaPqz7XI6yrxclNkbhwEf7RdReBelW7kt6I43qp3QSnhf8UX8NupvFh2xAb+9W+rCZg6AMtYJv2BRlw7FB2KQGB5ZjSMqzOnM/uE4B8putFn/DOlyKya3tmTaQWdkHBbjJvzQo1aes7FNUg81x0i5MVk0E5jvtpC7IqDPMBrDUuJlOP1/TGm5nD9ncnOftNhrwRyn4Of73MSlkHQztecq/GsEuQRZheF5mOnvAoQogLNlveUT28GWS+rltpAlYN3gIoZh0v/Fc1ddcsPesk9gpDWuOs1xci4XbaA6BN9NmUdh8/9JWDg9EfzbNQA1kk/D6M7l8dFL5gCT4aCLCCCWr6SOBgowtS5exfVLDYeKnrzQj9Xbr8KJSWK9F+yBLbyGBa7IAkeCxNNAGYQE+/xbM8s+gLSEVhygM0YOn82XOMSXhpaXLmH8g9MKFD+LH66GfJfoebyg/VWeeOwSn7mM1LQ6Iz/ERWTcgDa21l8j9hlNZhGaFMrZqnxo62k4da/nY30LqDpMjcKudyJxEdwuYjjddpD/YgZclTY/4zyfco8g7ThSK3XM1/n5oDAzxc7g9Yfx1sEB1i9qrvwAsdIoImRB5VCNucRT7CWCNThMwlGW7Y82jtL5zo9
 Gb3lBmO+
 GOWBkvfTWZlkKYx7gGAsrfNu0xhL6yapjHXN36YCN5IeB3/WriqNuWZIViGlSoFvbqcKZnALWLfKSRiNwVIN7agdOeP6RT1P9JbFa+dpNrd3Dlzlpu79r3T6LugSlPPvqndopAux2SLlo6u7JM+sJb8RTkCnCykfdWW+LuGG2tqUE7LAZlsn5/8rCMEdpelQ+D6wiNnqDXuVkHorYf7SNP5AqpIEqX+SuTS73j2btSzb1GrupovG7jmmqMDOW+AgET/aw1HUrTNfy0GuDBhbJkqOkWiKh8wt37aji2AKDPkDZXPd2vuEwmXkQ5s2SFXzGR/9RhTG7vReTUBlbvpy8BEljfm1z+KS2xmMGYdJ27Slaf5N4aA4M5efOHYTZdvKMaaRAf+hUPFGa6QCisust15kX/FOUkfxl0Nt35xZCpylCqyjsWQ/RqAdnCCNAVJbraSKJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 2026/11/2 17:11, David Hildenbrand (Arm) wrote:
> On 11/2/26 10:06, Zhenghui Hao wrote:
>> alloc_contig_frozen_range_noprof() isolates [outer_start, outer_end)
>> before checking whether a __GFP_COMP request exactly matches the
>> allocated range.  If it does not, the function returns -EINVAL without
>> releasing cc.freepages, leaking the isolated pages.
>>
>> Call release_free_list() before returning -EINVAL, while the pageblock
>> is still isolated, matching the cleanup already used when
>> isolate_freepages_range() fails.
>>
>> Use WARN_ONCE() as well: the condition is reachable through the exported
>> API, and repeated invalid calls should not flood dmesg.
>>
>> Tested with an order-9 free pageblock and a one-page __GFP_COMP
>> subrange:
>>   before: free_buddy=0, leaked=512/512
>>   after:  free_buddy=1, leaked=0/512
> How did you reproduce this? Using a hacky kernel module?
>
>> Fixes: e98337d11bbdf ("mm/contig_alloc: support __GFP_COMP")
> I thought we discussed this in the past: if you are able to trigger the WARN
> something is messed up already.
>
>
> And indeed, same patch already here, SMH
>
> https://lore.kernel.org/linux-mm/20260629-free-pfn-on-alloc-contig-range-error-path-v1-1-496ff9ca22db@nvidia.com/
Thanks for the pointer, and sorry for the duplicate -- I missed the
earlier thread.

You're right on both points: the reproducer was a synthetic module, not a
real workload, and being able to trigger the WARN means the underlying
path or validation needs fixing rather than papering over it with
WARN_ONCE.

I'll drop this version and follow the existing thread. I'll check whether
the earlier patch is still pending and only send an update if there is a
real delta on the current tree.

Thanks,
Zhenghui


