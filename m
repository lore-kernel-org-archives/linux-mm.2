Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DE9F94CB7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 23:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643106B0005; Tue, 21 Apr 2026 19:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F47C6B0088; Tue, 21 Apr 2026 19:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50A2E6B0089; Tue, 21 Apr 2026 19:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF1D6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:47:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 52E1AE658E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:47:44 +0000 (UTC)
X-FDA: 84684202848.19.597B638
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E1E6A000B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:47:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CoUmy2Rm;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776815262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J27y6/sO2Fe3myFR1yUXI0sqGjhpjy6q8belIS41YcY=;
	b=K7+ZGqwR5wOuQX1f0IMtFUpQqGHeThsyXAjQXv6XkK55Iq018/wRgQCbpIJFOIHo5hxD/K
	vzgJI5dddotiM5IeJdZl56Ye7/Vs8OtLQ8rkVn/nKV3ori0UpfaLxBxS5wd+xAR7XK4qGb
	zT+KIJT8NVmq0f7kJHW25ZDYqzLJk+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776815262; a=rsa-sha256;
	cv=none;
	b=L9G9E7UQuxxfs4D6jNSbv+J5OF67ZqoTbUApPx2GA4OKuMeqA30plAMsj/izTJ0MAChz/C
	sgYtLNhdd7lAT7KhcQ06wDZJOGTOFgCbfZ7TeOouSor6lApEqr6+gh0J+7x6FIr+6jR+XB
	xFgsjPWIjkOdirB9VM4pYd3Kh3BHN2w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CoUmy2Rm;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5AD14459C;
	Tue, 21 Apr 2026 23:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A570C2BCB0;
	Tue, 21 Apr 2026 23:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776815261;
	bh=n8P7NAk4MfaX52F6FocZC+IRnLWA3imvHKLgX6nXRSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoUmy2Rma6WejeMfLEwtc4PhzThuA/zydQvI9wcl51SkM0u4/qsFlzBi6r5FZ5qcF
	 GyQky8AeSNCLeDlpesEmoTSgEF/rTZwuBEoFcsxCY5+eXfAn+5Zv4Q6w72Rk546ous
	 +W0MEGCvVdNRtDDD9NP1LnrLwBUXQPQVBaLCpzju5656M/UH6DWk3HrflRhcarXBDE
	 0c+lZcqqqlj8LO53sZ05QK3+iuepD7BOrSqE+JXxHtpcIT3S2fg8XYSkgNfIBN3OTK
	 Q0icmdizVUcH2b5VsCStw5c9X3K3ruM7+BBzybMF5OVBVdrr7Zu1QFXd6EcZNDUs6R
	 sDI4F7m+YqZIA==
From: SeongJae Park <sj@kernel.org>
To: Junxi Qian <qjx1298677004@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/sysfs-schemes: fix use-after-free on memcg_path and goal path
Date: Tue, 21 Apr 2026 16:47:30 -0700
Message-ID: <20260421234730.2917-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260421070632.161808-1-qjx1298677004@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9E1E6A000B
X-Rspamd-Server: rspam07
X-Stat-Signature: bw5d4ofkwk5p8tzwpzac9uiyhk87gsob
X-Rspam-User: 
X-HE-Tag: 1776815262-800270
X-HE-Meta: U2FsdGVkX18oN14IGLc9epIu4jaY9phSKSx5mKTsndRy0nVNoTx6ikdXJX3LbP0zb/9BjM0mGcZ8ouGIuXZiveyCngf/co7iNO6EX7ZDTh0cn9H+x+JuAO7mTKC/28qcZDB7lsh1HHMdUsZziegkm+PLcgJNxdLUNjOYsQZg6kPrvjzWZhB6c61MzXL6ngdl+bYffhPa+/Zze0KQq8HDuwBOjk3xxvTZNuvkug0a0G5SsHU9vFI9TJMPdC2ziZRdI4GMLrBfytysf1pfTxAKAORebsVT6rJZ9PdIWS/qIoNViL8i/49U869sQ2/CNU7UogtoAmh//qRZixFCaZsqCUz5mjh8gnjx7ATYzow9+ReX3t9Eai5QcOv70hmik+LJIpVgxYFiCdRwY7q/rlo5Tat92ecMIiSDKF4R55eDOiMIoQmyEhQO/7COPjj03gbaOLMrkrR0KsjmF6zOzyI4ajaEfwrOMr9Q/kjE1THTkFVFZzAg6Yru1s1+RGd9OPFFeAivVB4ZOdazrsOPRb1H677l041MA7fF1znuDqldQhyDAJAYTMd0ZiNA0rMRI8+1G9qDPSmmdkEMQyOW1i6PyhdtDCj+Iexhynrz62P0CvuvjEQuAl1L2gc2+VQe0h2QKRqIBdXwP7q+v0GMIMgV3BVEBDmezz2QddRE4WUk9YRx2akzvbDwXXr1YmoBBw/N0T7EfWtQsrigAnOOO724Hcr6SbR+VgfKGRs379CkHNWo/8tZtEkC86C9VvW1vbOiwUm6Pqr1+ivCQtfrNNcwmIwCvBBoWNoFs5VgwA3zgtvrORkHayhzU8JnZGWJiOJEOr+SbkLkIXwhB01P4MENJdOkF4ZgC9rpsSj066Zp9hQOnnHpIWfaRwoQVb05k815jOafC/pwYsH9r8by+CmbGnDyCPil7BD5Ln2ilzsDBjPudAWMiH2fRXS3NwSjTqkqtn/cwtteoCkcIVcU4qe
 lCfXOAuv
 J0dsWmQwij3G01tcf51JAihY1iDXNWfMxQH36Y2Ecyxdeha5NGoSU7yNqAIvdHohNClV5hM2EFYoS70DJjwovzvoVLPKmNkIaFUakhK9W7uFp9DS+ncA7w5DKf1m3QO9LiFvoyHdpndcE8ZF2x/nq9/2wQ5KRg1KicLBuNpbr3z7WgXriPkKdnoRO5EUR44tQP/73sbgEx/BadxWHWdIYFYOKJhQ5Qq/AdqOx2vhMcABDfaNZpoNXqab2+eUyTFxtM8N93WfRSH5/NjZ02n6BCLCRwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Apr 2026 15:06:32 +0800 Junxi Qian <qjx1298677004@gmail.com> wrote:

> Hi SJ,
> 
> Thanks for the suggestion.
> 
> I checked the show/store race further and was able to reproduce the
> memcg_path_show() side issue on a KASAN kernel.

Thank you for sharing this, Jinxi!

[...]
> I will spend some time thinking about how to fix this properly.
> 
> If someone more familiar with this code would like to work on the fix
> directly, that would be greatly appreciated, as I am not very familiar
> with this part of the code yet.

I think you could protect the memcg_path and path load/store() parts with the
damon_sysfs_lock, but using mutex_trylock() instead of mutex_lock(), as I
suggested.  If you prefer me to finish the remaining work, please feel free to
let me know.  If that's the case, I will work on the fix while adding
Co-developed-by: and Signed-off-by: tags of you on the fix, if you don't mind.


Thanks,
SJ

[...]

