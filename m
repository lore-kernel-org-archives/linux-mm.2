Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518291112242
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 00:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E37F6B0088; Wed,  1 Apr 2026 20:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7943A6B0089; Wed,  1 Apr 2026 20:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA6A6B008A; Wed,  1 Apr 2026 20:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5837D6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:00:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CFCBB8A928
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:00:29 +0000 (UTC)
X-FDA: 84611658978.28.D601260
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EAD56140013
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:00:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WNY8ajYv;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775088028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NnAv2ylWWtqTtbfSSHJxW33XfhptCRWh0W/W5ae+zM=;
	b=bhtkGCcUjD6R75RMjMnLgqZY3S2RJydCXYbRYzTAaRZ/lKrlIyHpUwEtDnVv6sUH2KON7X
	q0SJ/HtT8k5gy5FIM/ixH7iKkBtYwXLYsBNNl8TP305GJgFYFduK4N8OAxCIFudZDSqh91
	UYPQgVZ8xdyX2AbO3I8RSG5BdfOTmF4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775088028; a=rsa-sha256;
	cv=none;
	b=WXSlJCqCGYQdQEWj+LVnWdxwpXkQLEjYlnT5YT88Trm9Ox2/rYr0qjR2NXkdBoDd8DreI4
	3CADmUbHNHSfUMa//whlm/I12tbedTlUd92yaCJZ1zyTs80YQrYez8W3v2JN0p+Gx/7CJ8
	W+ZTEYilFn4MRuLm5jbHpSFAQ37UE8c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WNY8ajYv;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E9E8B418AC;
	Thu,  2 Apr 2026 00:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88579C4CEF7;
	Thu,  2 Apr 2026 00:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775088026;
	bh=i79hwwT6zKxmRxtFSDcoXB9rUWpTjOucJBix1IQZ/eY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WNY8ajYv0qRM+foPycmGOikUNp4tRrE+Tw6NNGDx/31w5/yIobbybJ5sdxXHvJlBa
	 uHnbPPB7ojWqEDwL/JUnqMWd1Lvy3k/aF/b0N75ehjK9HDdlGX9ScCGu/2g5bkWysm
	 lPXHIwuesy1Ws0shpvOLxl22dIPB78+XIzAg9nZg=
Date: Wed, 1 Apr 2026 17:00:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: zenghongling <zenghongling@kylinos.cn>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org,
 kernel@vger.kernel.org, zhongling0719@126.com
Subject: Re: [PATCH v1] mm/percpu-internal.h: optimise pcpu_chunk struct to
 save  memory
Message-Id: <20260401170025.7f54cd75ea7e69eebc2ede30@linux-foundation.org>
In-Reply-To: <20260327090013.38042-1-zenghongling@kylinos.cn>
References: <20260327090013.38042-1-zenghongling@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EAD56140013
X-Stat-Signature: h4adgr5xzdh6ob1t4i4gzmr39zfht8ik
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775088027-864348
X-HE-Meta: U2FsdGVkX18MqDs7v4jc0G85djsUu6GB11lAzI3nolPsYIj0dlET+rIm7tX0X67u949b+L3yIkPDZPJUSz5JrQ4C8ayedyPuoeS77JChsw6P0zNpG+GSRPsAzwE0vhkQJ749eYleEd3UVfBVD3raL3hnKqG3e6txPf8CXwFPkkF3pwps5q09bJbv8SzTgbqohsMwXfozV/yJRpfukaLtVmSDcQ1zpxa8W5cSQmPPXVCOBxITjzqCpIcFiBdTX4N9rES11PCZ9pN0TINgebM3ICAramVZ/64xq9a7PFlUA2PzhW9b7yAgV4AOkztp+s57UwrEVBrov1D0F2K8TY5vxZMIuEgv3PPjbS9GYCX7snVnfDJxphADJ6SPmkIWOl4sGi1P5P7ezT3MFvc2huuT2EU7Uyqlm55ri4U+X5Ecc244jqF+qW9I7jr/NLdAhXV/0D4tYSi6yxJyEHGKHs6HCMxIm5kGzFrQ1I93v84TAMWL5J3MFEq3ZvWP6pnX7XucBxi3LdwAzEjUqWSy9SmDWi0+Kk22cFUgj05DvZ6n2Qgj0qciEek9Pcb6JL2RnwDNRCdev+z560tHg9CjBhUesYlewjOMus10/KOt3qU2BSjXscMRvXtSAqY4g4TI7VROOGr0uITN+RISGu+F0EnQKuD6lvji3dr0YKCfnI1DQeyBtwr4AgbSPHYtNBlCqAbt/Naz5UerBxaYmQ1iaiSCoO+fssxuXh03VZzRIit0z0gQ4DMjYhASuWv19aU0nSDDmzUYSuVlpcAreV6Sw2IElOgjQDmL9GNejUkADO1Q2a+CNmR4lJWOqa1b/q5i5XYc7RUESmJ7c038bJ11/1Tu/SJ8A1/4SBDuC7sZx8y/vXqlqhARGFVtI+NoDAodBWdhdees1DF421S940xnsyDtGTjpicN0fvI9CQbWUDR8cD4jDDt5+8bY8klbkf/YxdJRjdrF4cD59ugTYcgVv4G
 08AcRfnj
 gMUMo8KSvOr0ueEQqDym2qoUEGNrYFptqQlVuUutHdneu9x5C86wEpeiNASBSPoxHpijSLXqZlGd/KrCHj4KJHknhuNY2VESBr/oiE2475mc+3RJQIet1r2tNs2e+I6k728S25K3bVGa5bnFMi+JqTYuQi9t9Dq2WHG4U9ievxv93wTe6HX1CEypq03HlbrPpZ/Cvv9VUJdVd76nSPF/5LKrzEA2vEF4Ry17IrKTM7Zoa7yTW9xWa2YQawRlaMYGbCmwjs/7XLxG2UQcyRZpb153MSsUEkSz2SMYK5ycVAndwbhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 17:00:13 +0800 zenghongling <zenghongling@kylinos.cn> wrote:

> Using pahole, we can see that there are some padding holes
> in the current pcpu_chunk structure,Adjusting the layout of pcpu_chunk
> can reduce these holes,decreasing its size from 192 bytes to 128 bytes
> and eliminating a wasted cache line.

Thanks.  There isn't a ton of activity on this patch.  I'll drop the
previous version and shall set this version aside for consideration
after the upcoming -rc1 release.


