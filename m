Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C09331099B3C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 05:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F6AA6B0089; Sat, 21 Mar 2026 01:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CE1A6B0092; Sat, 21 Mar 2026 01:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B726B0093; Sat, 21 Mar 2026 01:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1253F6B0089
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:23:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A86A258DED
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:23:02 +0000 (UTC)
X-FDA: 84568926204.09.09B7D53
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id E61BC1A0007
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:22:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QB2NpBLo;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774070581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PcTvfZxxxHTOO8PPQsyM51dY96hQcI/WjTannbuBJtg=;
	b=IcHgXzCeCGdCxTpOKTwqe9oE6sBRgXnpS7ZVPcPnVYp92Ybpf7aLChfxKHEuQSJmnAhyeD
	zVQMnEb8U91DV/qLFp+6A+0TgDsn+NXzuhNs16wbGx2EY5kg0bWM8beQ6R/nXDmSP3zSHJ
	QUBTWwDETHGVWFBNre6RUi8hnMXV6iU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QB2NpBLo;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774070581; a=rsa-sha256;
	cv=none;
	b=5UnHQB2VfhSx4sEMoICAC2WdA1WZh8ichRyzQ9XcwVF2CK3nhNWUv1CuQ9dNAK4OVre3ha
	7Bg0dLzaROHdPj5QohoVdQR7T70kHIdTOlHX/XfhGURhpIcAUHUxPzKTVsIFfKpRNvUp5/
	HWwBxgogJvoIOOUQU6cYFUtJjpRajSk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774070575; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=PcTvfZxxxHTOO8PPQsyM51dY96hQcI/WjTannbuBJtg=;
	b=QB2NpBLoqG5Crb3aZk79xMM4k0qroaojnJ192NzCjvMrCkbuAFUKExQ6o0R9Qjtt+r2tx0Y1YAwQm2cqaq6xgvHVTS/DzmsBtPLMfFOBGWVnTYfM5cPFA+ZyX2G/g+w2yJ6aVcb3/5lH3xt3rWJr5LaGUVNJ54D+usGTPzJF25s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.O-uAP_1774070572;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.O-uAP_1774070572 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 13:22:53 +0800
Message-ID: <a9c48aca-fd2b-4b01-95d2-62607594d236@linux.alibaba.com>
Date: Sat, 21 Mar 2026 13:22:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] mm: change to return bool for
 ptep_test_and_clear_young()
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 akpm@linux-foundation.org, david@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <3fa94c3c89fd93fe22c8cb59967f064787d686aa.1773890510.git.baolin.wang@linux.alibaba.com>
 <ikarxctf.ritesh.list@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ikarxctf.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E61BC1A0007
X-Stat-Signature: kxotwgf4xw8g6w917jgyqao9xfywdnyn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774070579-898859
X-HE-Meta: U2FsdGVkX1+cOwzZquJY8nnNP1N3As9ZrptOJkSfxUY5AWR1OMfNwYHElsbZkXnzJEZ0Snm9gwyER4qXl2IEn9OpTbrJTkAkjxzekN6S5wFBLDXIMX9kQNW5ZBHgt/VhZwTA8pUBrQazYscDUtz05Z8YuJauMP6Bb8KqcLxYeTgxz5pmoliiE5Zlk6oa3j9ceys11HgNCu4wgDoU9RzBj2RW+t/+OuZnXD+fEz8AVDD7TNFIWnXH0gluyThfui37CWFhfihA94OZDi80Rna9gpfqZsVSN93Q/2izsgtEuBVeKD1sismd3i2feTkyMCP21VSfkib3+WBoN5S1friMI1Gt73p6Mw1QM1OoGxBG/5TTmpt79g+6zSZh6xLg+EnvRjwNHEW+AKkGwPyW/uLNESbflV3WMS2u138Y7egK2QONo7G1IPSVop9izTbOTC86ibSP5rIYnatEiJxgAmvbPi5MxJyLPJaxPPDbraqRg35vbp4rRyS2e31nEcltYMydy5qL2If0lwXyFlUd7rJQJ2m2B+kcWLcIzRQxYcruZWDXYmneaglQyK6hKw9yjxYy3NzE5+1wtWJF1+TK19iJ5kBrdQ3ylb39Oje0eMHbGE7dh7VneFm7rhU7U6AT5BBs6tSWDiFMBwXfsPev58ibqyHCBlscFe2ABM0pWVZ8cQiPh+8KQbNr0fhGb3wgaVFBfIda2IMgEOUZeCKrzMDayN6o+ChsftLsxB1R5tESDKyA57CwNDTM9RB0Vl75QM2edf8wNbp7I4QEws2JXJS8a7xIozIkS+TT2aQe1X3j1FNPUCigaiIBTv8/79FNgiTKVGFj+zoydWtSkWXt7hX1mc+y8RibkEL+D7ZKSBScypb9Pt21F/l1sNIzPFkN5At4yq676Kf9u4qatmqpImxfaw+OjlmjWOTZ6D8MxbXjgN/Fkcjc/SuMrApaY2mwnpmD2AAbA17ntVM75wYSBhO
 HdmWa/p3
 +tfAZ9839spViEzqZcvx1Ywk77Sxe7OYL8j5+X7ctFygTSa2LkHFTyT39WQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/20/26 1:57 PM, Ritesh Harjani (IBM) wrote:
> Baolin Wang <baolin.wang@linux.alibaba.com> writes:
> 
>> Callers use ptep_test_and_clear_young() to clear the young flag and check
>> whether it was set. Change the return type to bool to make the intention
>> clearer.
>>
> 
> Right I checked all callers of ptep_test_and_clear_young(). I agree, we
> only need bool here.
> 
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h             |  8 ++++----
>>   arch/arm64/mm/contpte.c                      |  4 ++--
>>   arch/microblaze/include/asm/pgtable.h        |  2 +-
>>   arch/parisc/include/asm/pgtable.h            |  6 +++---
>>   arch/powerpc/include/asm/book3s/32/pgtable.h |  4 ++--
>>   arch/powerpc/include/asm/book3s/64/pgtable.h |  6 +++---
>>   arch/powerpc/include/asm/nohash/pgtable.h    |  4 ++--
> 
> I looked at it because of powerpc changes, but ended up looking into all
> call sites anyways. So overall it LGTM (and I agree that we can remove
> the unnecessary externs from function declarations)
> 
> With that please feel free to add:
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Thanks for reviewing. Will remove externs:)

