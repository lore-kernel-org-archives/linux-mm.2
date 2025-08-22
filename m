Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CBB9CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 07:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8380B8E0075; Fri, 22 Aug 2025 03:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8188E0056; Fri, 22 Aug 2025 03:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689268E0075; Fri, 22 Aug 2025 03:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 536F78E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 03:49:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC819140693
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:49:01 +0000 (UTC)
X-FDA: 83803617282.20.34CB9BF
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4A48140011
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:49:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Fp2rwnMf;
	spf=pass (imf11.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755848940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKaEMpPuKCdXj1YABKlsM+e9rwjQYLBCTfcoKZ1CBJQ=;
	b=sSK5/RAtYLD0m44At+OIJVAfPG9hZ/YcsXdzZOEodXkimb8ItJraeLV6M/rrx35rj7ppcA
	GR4tV+BLeJiIHi3sxc5jM/6PlQgA6Eei7itdpN10elQCJYf6LzOm72Q4BriMRXa+iOa+LQ
	lnsG6NYCTyR0TmVR7YfKjcYPNyD07kM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755848940; a=rsa-sha256;
	cv=none;
	b=vTvef4dyJtkTxdPaid8K5Xe0bqcnJmX3Mby6gziUD8aoMAL44wd9a36f8nElX6NnXGtU19
	S19hoxD6ny+FFkh5Q9pzuZbMaRrUnxjXyQejxMcu2kzCpFxZhk38U7JySgnkXrFLnVb5rq
	nopyBKuMpTsgwFF4kWrqBHTaA89MZrE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Fp2rwnMf;
	spf=pass (imf11.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 9AF88A58860;
	Fri, 22 Aug 2025 07:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C402C113D0;
	Fri, 22 Aug 2025 07:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755848939;
	bh=DKaEMpPuKCdXj1YABKlsM+e9rwjQYLBCTfcoKZ1CBJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fp2rwnMfgYm3Mwc9vNBEaDhcqV9U92FWeYt2cDhRA1baZAoOE1Ev7FD71v3nwXnJk
	 OjfUY4zHRe0bwRSBxikudVXXxz6bi8ufsH0oG6jzSLP2brGkxRGrW+J3tNbntpc0te
	 V+SNXg2kteePexWsJXeFJq2Gw+MGQsOOQrugZGPo=
Date: Fri, 22 Aug 2025 09:48:56 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: fix the address passed to notifier on
 testing young
Message-ID: <2025082243-stooge-spendable-53c1@gregkh>
References: <20250822063318.11644-1-richard.weiyang@gmail.com>
 <55735a20-1048-4c04-bcd4-45eff0079f61@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55735a20-1048-4c04-bcd4-45eff0079f61@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4A48140011
X-Stat-Signature: uf9x5t6a13tj7swj9gdscwgcemxuzhcn
X-Rspam-User: 
X-HE-Tag: 1755848940-140453
X-HE-Meta: U2FsdGVkX1+QRjD2dJ7NFIYF0f1SnBZbmRiWH0ZLoD8ZwSyYrnRHKB9yGOylzX4/+h63YtiB4bu7AU5iLbdDGgX46QQFzbedgVRHynYkT8SlAYI9tugoRZAyMBEpm6eEP5qADgO/qAbqUM6t3myF2e4jwrgnVzFJlt/RbAeyXKZlidUSPccu+3sesZ/ZosbMyQO/XvKCIV3eyMXfMKjS6UO8q/87qxk4qan0Ix1khFRnCcDM/QrjJwIdWEfW7iX7dBGm3bbu/t7m9C+gWqfpSANRQFBAKnBFj03ALjms4O7MXiQ7QBw75JxowftB56W4Tdt7vrCyfuEv/l3GZE0B9h4kjyFDxQdfi767ZYAPPZj3dPUfBU2eCn7xUUpo39+4ABiRFrXO0jkhWBIXYcB2Yjk8hLxlQ/hPSuK4jQF7U/mEdy85RxE7LFoiUi+zajgjzzO4UAJIT7VMsyq9pLVedXrnu9wuGGYmx/DX1heT2ZqJ16ZJTbPVw4FUXQfZfwo4U0aZ4d4DSqa6F2L5lTwiPKEbq1pbBeJcgUU59LwoEx84qqRgpxsyNjFnMgzMV+1HpgqsOfwo8IJU99U4/x7xNdAG48L9miTbf3Obdd1RivNjL2U5Jz3V+GJ6d8bBIYYdNGIExCvPRi6CVi8UnrV65gcBCRgRC0VbvQbm3nu45S+F1k5gfKOsOtHa1gCxpqASaoX8hAJFOILOT9mXsQmoR8t/ftHxfhvgGMQVwCrFpoMsnhnFqB7CWhWbx+3nPqWk7AIAporeO9snp46hgIAqsitwiV2FSs2ESpslZgbvzmqAQ/e0WpiwURVaQEtBQSTxpQn5d/W6xeYJQxeQ3VIAXRTzaNfaQjm/4icleXEnLxWD6IAOYF1ZHNErc6ITNd4CqdBFmXofQtetsmeXN4Nc2ltKIr6Jw2Tiupcw6ChWoOft/Om5EZeMo5ZVMiJ1vqm/0GNPx/ahHB+mwm7Bb/C
 MnaiwVdK
 kmOSdn/c0zxcWgE+hhQ14y2Rn6lw/Cz3p6b4FnlF7/oHMjpdaEZKY23YlpOqov+2h3Me+GDrRPZxKluye2r+rBFIRy0AgMxK+pBj0HYBmiSNiIPgKN04/UiSj3r9qj9jmzfNg/Y9/qg0Yg/WSGjcyclQr/IOoqsIHgOx4q1dK+zQRbM+h07fGVo70c4A+XPYfymyG+tnDs9AEpCWR5uu1/kyYgJHdjSxhcI/5a/KvF/pD/2MPkR6DVH4+MjG18ognVS2ImS+cTk81wdh/hUQ9oxQUYiXEffV2szWwUHnkQz/xTwdQz/nXiBz8d+5fR5lnrfPyo/9kW5kXdiLvvHgZ6yd/Rx2T8ZGa1cSiMTOjnKvvDOdxFGUnFxjKzWmAsPJmqLGQMJLmJ0VWl+s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 01:08:57PM +0530, Dev Jain wrote:
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.

Now deleted.

