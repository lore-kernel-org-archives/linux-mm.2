Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C423110F9307
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 22:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27C056B0095; Tue, 31 Mar 2026 18:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253E36B0096; Tue, 31 Mar 2026 18:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191286B0098; Tue, 31 Mar 2026 18:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 081936B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:40:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2DC01B7E60
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:40:09 +0000 (UTC)
X-FDA: 84607827738.29.A4059A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DEDA440006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:40:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E2lmhWqJ;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774996808; a=rsa-sha256;
	cv=none;
	b=cPBg1/5CCHsmGIKOB2d8kGtnC8pb4jf9y4Yy1m+RCz62BfRr7k4BoNXrObd+RLPU8NQqBe
	T+odhbYit3iQTrk3WXJopi4hJyS3Q/S8WNtMPqfYccQMucDquLUXTlA4nksUm6GhXR8GKx
	mdKNXlXZ5oNR4PvhD/Yn0hv1jmzPHOc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774996808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IFD7WZgFJWD+7FI2n24DlTa/YBUWCJoLQWxKiC5cH+Q=;
	b=kVh0OyykNsIW5PuuHAeuHPQc4d13wi5KbF1DK8hLF95MPKiD+R4Z0m74vOc92Wsns3W71y
	anXqNMm123YiKhDOa8bWiOxP7ocvlMpqwfsbKFIlSQpOTwuAztPW/E2o8PyHPlm6qeCeDF
	pqyETHP4RGpFz7q1Afls1w0idbOtKSM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E2lmhWqJ;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA27D4330F;
	Tue, 31 Mar 2026 22:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA53C19423;
	Tue, 31 Mar 2026 22:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774996806;
	bh=rl4/17UJ02DrCORAEhhWxTz7VUCl9Xg85++OigKCpx0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=E2lmhWqJngQkNc0t2bSGmbkbQ9CydxkrIfPDRpvweyNCbhBotNOv0k3eKUBcWEuYz
	 1EJCKHKdVMSa1Zc1Irfvpi5sOeF+xnv6TYAYOGgSPHveAttww4OWnJ4zmjNfUAzHgg
	 J1OWpqsoljMNSc1t9GEHp4YIxsDWTajqizST3nws=
Date: Tue, 31 Mar 2026 15:40:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Baoquan He <bhe@redhat.com>, LKML
 <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, lirongqing
 <lirongqing@baidu.com>
Subject: Re: [PATCH v3] mm/vmalloc: Use dedicated unbound workqueues for
 vmap drain
Message-Id: <20260331154005.4471389e14061f467ab1e433@linux-foundation.org>
In-Reply-To: <20260331202352.879718-1-urezki@gmail.com>
References: <20260331202352.879718-1-urezki@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DEDA440006
X-Stat-Signature: qfyft67s49bscybbi4itfbuzpcwsysah
X-HE-Tag: 1774996807-821344
X-HE-Meta: U2FsdGVkX18oZ5fr6UgGZRe0yLx62laYb7ejmiMZn0coVlSulep/mnzSe8/PJTjOE1Cjo6UIPDAGhihu8FzVkQZEZJHTDk6hZDGAPXRSRQiKg+Xu2Y6X2jQm0JFMpz7P+Gb8JWFBjUr0afwl+xqYW/LCKszvEzAIJ7GR8uWzbK4BBhfQgc4TdfBDswCdw1fuTY/Dp0dVrm4LvEKLBL4Lb4dGJpczz4WqDFHTAQXUpUWaJZW8Sc0pXm5fRKneT+PHQwaUUn4XjzpZvmY/qZIK00+5VZLtiaSkoni7lZ35/JgBm2G6xiivFJ1I0ME58E6qmW/CfPWa2WT7aqiU9NN/Nziu/R1SE6ucZgYD3sRSeLf/ufoLQYPPCi2Gw89R0U60KFeQB9gMwJ+vk3PRtVChuNghgt62+LO0Zmyi1r59/++b8lLH10lGDu+dNiXEaig4pXjUCP3kjjS2gzJ3yqdwuY8ZhDwIDjCNtDIIE9LlojmwGvwbTIVmxlvcwtcalfgyknhIBiv3S1DIEv/4iXfQtkMGGfZPvrfmVQOORG6AOR1aGW8ABy4x6addVRjclziYObGSCcA1Z2x/GMedQrulAUDQk8+lmaHjSfQ8Wsg5NwY3EAP0E+Vghg5bg9r/qUISyUGbGbYEzOP7Z+yEFcs8+1BIKKpZ3vcQhPtQ1DGMoHtVtWe52hzocG3fMwwtiFMTMYzHymf1TRruc/mklD52tNjjpfXJs95aZbBWgOo+uNcoIBFGYnshiZXnYEqj35++Xv1CtBW/8AHyUadTt46MbHMl28YaItbtmCZMmsn3eW/tus2I2S+85OfQN0SQ4ZvVcCvNgbBQQs2ltYNG2QweUP8RChRlDGZyjxCT6u2Fdv5oprpQe86DUUikI20SKYN5ChjNrdMIqgojskh1B2SzLn/D5qPCbaPnFt8SPECbGVoxHFkiI+lymb3PEJ5LTj5+LRfrL6VPuk0hZXDh0Q3
 aYB52GQS
 9p38AbTZ/+HNbds8mY8Fgg6zhu3CUz/zDHPkCnuxJBfUVZev8yH7YcQb51ioPHyS4WPWCMjAmMUzEBHekyrQtjZ3hshAC5pLQM36l5xuXM+KWH71oefw17l36iXCMqSeelsAzNt9HEOAbhp8QZwdAgp9Ctvic4szRZzev8PGxrah0TSJnaucOvYApVsAaLoUhHYgDRMe74T2xsixHSv/BBCOH/FwXsVbdxyySQWx3tcgWvxA3AyRTKveA4WxkFxp2h5IE5Uwh/RyrIQk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 22:23:52 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:

> drain_vmap_area_work() function can take >10ms to complete
> when there are many accumulated vmap areas in a system with
> high CPU count, causing workqueue watchdog warnings when run
> via schedule_work():
> 
>   workqueue: drain_vmap_area_work hogged CPU for >10000us
> 
> Move the top-level drain work to a dedicated WQ_UNBOUND
> workqueue so the scheduler can run this background work
> on any available CPU, improving responsiveness. Use the
> WQ_MEM_RECLAIM to ensure forward progress under memory
> pressure.
> 
> Move purge helpers to separate WQ_UNBOUND | WQ_MEM_RECLAIM
> workqueue. This allows drain_vmap_work to wait for helpers
> completion without creating dependency on the same rescuer
> thread and avoid a potential parent/child deadlock.
> 
> Simplify purge helper scheduling by removing cpumask-based
> iteration to iterating directly over vmap nodes checking
> work_queued state.

Great, thanks.

> Fixes: 72210662c5a2 ("mm: vmalloc: offload free_vmap_area_lock lock")

That was a couple of years ago so I see no need to rush this into
mainline.  I added it to the next-merge-window pile - it'll trickle
back into -stable kernels later on.


