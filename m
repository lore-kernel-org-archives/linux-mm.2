Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F322C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 05:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3B66B0088; Mon, 20 Jul 2026 01:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 055156B008A; Mon, 20 Jul 2026 01:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE9B6B0092; Mon, 20 Jul 2026 01:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B828B6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:30:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3231D12077F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:30:14 +0000 (UTC)
X-FDA: 85008029148.13.AD05C8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 37FA240005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:30:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CrjiPVEQ;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784525412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUTjJ7TAtZ9PryXizZrAnM48pnSQ1wB+EIgKQoSKNGk=;
	b=qTUbW1zYFkgoj0RbEN11wRqzFQFFK9+1TclbNuyavSW+EwqV7wrfecoxhaqmTq5KORUsbv
	SqlwFWlBjIl2CHz46C57q7e6QSIFI0gvZZHVyN+13Bw3jkk+/LpFutQj3iut4fA8VsSLqF
	HzlONmL2trrj5M/bHfJIcnNoCpAmZg8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CrjiPVEQ;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784525412;
	b=tnD1xr3scupL5kZ5y+Ngat0aQyESpdGN4Fz2NSMMbMRNySZdSnbRaTGxU+PaUeslM7IN2M
	Ox2cMZrdsPzUSBnQIgbQgrwSeTJsGx9Rp98I0e0Mv93tHkDQdZlyWfBfVRlhxtpKJLCKZQ
	FD3FMgYLDNLIfBBL0ag65EMwkkE/KJ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A158260103;
	Mon, 20 Jul 2026 05:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC87D1F000E9;
	Mon, 20 Jul 2026 05:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784525411;
	bh=KUTjJ7TAtZ9PryXizZrAnM48pnSQ1wB+EIgKQoSKNGk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CrjiPVEQlLqpGI/wgwzQ5ssXg4Bz3qTdYTz4saWXQIfSgQtzeHIHQ+BoSc0elbnok
	 KxwMYXrYLxA/xag4WTyJfHBjKLkcVX4SpaBN4N5mKynfdtlVcBcwz0yz5KzjLIhUvu
	 ibq6m4hogIqiCGZzN2MnFgvFm/16qGFu/D8IhFdM=
Date: Sun, 19 Jul 2026 22:30:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <ziy@nvidia.com>, <david@kernel.org>, <luizcap@redhat.com>,
 <willy@infradead.org>, <linmiaohe@huawei.com>,
 <svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
 <chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>,
 <sunnanyong@huawei.com>, Luiz Capitulino <luizcap@redhat.com>
Subject: Re: [PATCH v2 0/3] cleanup for stable_page_flags()
Message-Id: <20260719223010.dc6851665fb226c73948c69e@linux-foundation.org>
In-Reply-To: <20260720033021.4091944-1-tujinjiang@huawei.com>
References: <20260720033021.4091944-1-tujinjiang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 37FA240005
X-Stat-Signature: j693itrs8dqtygmzkz7g9sgb54wpz9sb
X-HE-Tag: 1784525412-373610
X-HE-Meta: U2FsdGVkX1/cgYURUcp3j35GDHvX7gFSIQZgT7Fz1ALP1fBmOGaqUEVT+UQOJEQlvk1TTgkg3wwiH/kkYhSB9V8zOz81uF91KVr9+hJUKrZR0wx9n5Ho3WmDCE7pLEUgsN5beEBn3z0/pYGd1ncrqjvOTAffwz8HpuQA4oor75B02ocLFmvwCI66TLPqNiuZZjm2moWJGZWqWIKK6y0wf2JiNRWByUSd7pQnh+3jM/dC7uWb0ehR8ULfHckFDgJm+AV7s8jDYCMHt6j3htE/VwdtKtcc9AAGAWGP1tYft4vFEAZ7ueMJr4n1tQ3fuMH717rfRWYAVVnFDe21MmUKwEmTMj0h58qyObTDMK4cAmJdu638YxiZasp2fIbZTIrBhvH/zwmiQcC8pf7smnSvgtmdkAKXxPpGSaWjlSju+7AbJ/Mgh896lRPDgSgMydMm8BUbu4E4hWLHrzRVSNOycp4Fa2f485NgFBmXHmJ7+XVqVz0Swae32inz8s8vTrtI2Kf0MERq6y4bQlZiR7Z731aYrEvlmMs2dfaxyqDQx0h4hHZtqtgoFaCdIB3jPAPrFa6RLuyEwIqbJREA6+nlTTSnXbKBcISBiGp0leWwU75nzw3ub9FJcWSngrt9MHO7HSuM33SnYRG71o1BzHneFw+AP1M9k52/BaQj9dXmzvH6xk0RJLV+yPPVb91HHalWLbhjpzL9u9+xJh/YSS/edh89BFoehHfY/N++TCr7kf+eol0xlyk+TdZExiSpPqFTUgEdiw8kukTknEU1Qc/dU6DGsV3q+kkEq1qOBJc0P5lX16PX7U3uGomJL4A9qAW2f8DJWE+R8OnX/I/3DhiIpfAqXJtCwYshGJwkvM+fEgfqrL/pZcRgcXFOg7Jar0Ulu4Uvh57TUzrJVO5LnP64xL8OR3+34rUEhS394Mhn4Uh475TlmvMqgZwnZQxlOI7WNEbr/RCzu+Q8QbVkihU
 tcXAzIbL
 u3DOgirtPaCnaMbwzeQbZOc1FMKXy9Fa20p4CFzRZOx8HhsqGAUyDlJhvD0iDSLf/MdpCfR4KuWpGkbNTfAP1EnqTELPGT5uY46TqNkZ8/ExVjhFS9as7uroRVCx6hrTf2vqtUjKnjnDU0NNdCW6ET/fHHGY+yk1B6wKQWWeqOyF2fNJNbvadfGG98FbYBhA6EcSaZEHNU6vyMpczIobHD5tLemUEqm5n9POwAWI0X748AxpPMPTOB9hVH6vN8cTCuELH+YMm2GDZHrV1PuatAT2HwOFM95DIUAPgyayWta7FuRkev8DK7mzPOvQLbVvJyutkRqoq9LFlZDXCsG/T20t09MYhn/CfTbstCGnothbyCyQWuRIcMpJoow6VRqbCLNV0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 11:30:18 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

> This series cleans up stable_page_flags(), see the details in the commit
> message.

Thanks, I'll await further review input on this series.

AI review might have found a couple of pre-existing issues.  Arguably
both are around the page-snapshotting code:
	https://sashiko.dev/#/patchset/20260720033021.4091944-1-tujinjiang@huawei.com

