Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 634A4CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 16:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7A76B00C9; Fri, 29 May 2026 12:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7675E6B00CA; Fri, 29 May 2026 12:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D206B00CC; Fri, 29 May 2026 12:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 539B16B00C9
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:28:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE5131201D8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:28:42 +0000 (UTC)
X-FDA: 84820990884.24.E5C24F4
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id E3B0280008
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:28:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xjlGjQBm;
	spf=pass (imf02.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780072121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJT3raIRjb+4PiHI6wkOCTwp3cpNLe0MfnR4Z0jMrqY=;
	b=VU713wcO7l20rkgZ1izXbd+aA3yFXjIQoQvFByr/Y+AEG5Im7k4zXJNKUoiroTg+D1MXE2
	rqi0E1U7SJO6J8i8sHcetVQEdvTf8yA+VSHljJ1OV5s5LR8H6j3+bdCtzqMRbcEr7vnd0R
	aSXm4jVN5jrj29ULlPHcvA/YehfvTew=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xjlGjQBm;
	spf=pass (imf02.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780072121; a=rsa-sha256;
	cv=none;
	b=nSdnh3o9WIulPaPpfGgOHOCV9dxMfE2LaEF5LS8aOkD9B0PBV4BgHAFO9HxOz5XtWOoAWi
	KLYeXd1ieOEWyAInP1lYtvu0WHMULWc4GBJ9EAlqxsqMnqYpt8TPaJlQiThr9sYJAgj/aA
	fCQL5s8t8aBbp24FuuuRB9wzaqWEYeU=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780072118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gJT3raIRjb+4PiHI6wkOCTwp3cpNLe0MfnR4Z0jMrqY=;
	b=xjlGjQBmKF5y84uYtAsFejFz5qjru1Isy5d6nhq/A7noCKI7NCMWs/WO3MeY8Ja6AgTyan
	CCBovkPp+npAOWibn6+0DL53HXD6seuSPEgMKo17SDe4INqz9+uQDXmyKjdOpq9xOoWLcF
	4ALbbELDM3PVa+dcwtEmJvyWa9sWRZg=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 29 May 2026 16:28:34 +0000
Message-Id: <DIVAWG4YOJEE.31U4C9AB96AIK@linux.dev>
Cc: <akpm@linux-foundation.org>, <chrisl@kernel.org>, <david@kernel.org>,
 <hannes@cmpxchg.org>, <hughd@google.com>, <jackmanb@google.com>,
 <linux-mm@kvack.org>, <mhocko@suse.com>, <mikhail.v.gavrilov@gmail.com>,
 <npiggin@gmail.com>, <ryncsn@gmail.com>, <stable@vger.kernel.org>,
 <surenb@google.com>, <vbabka@suse.cz>, <willy@infradead.org>,
 <ziy@nvidia.com>, <melotti@google.com>
Subject: Re: [PATCH] mm/page_alloc: clear page->private in
 free_pages_prepare()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Li Wang" <li.wang@windriver.com>, <sashal@kernel.org>
References: <20260301013838.1699247-1-sashal@kernel.org>
 <20260529050231.1849697-1-li.wang@windriver.com>
In-Reply-To: <20260529050231.1849697-1-li.wang@windriver.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: swbn6wwm3i6m7yzs7qn3f3nri4db659h
X-Rspam-User: 
X-Rspamd-Queue-Id: E3B0280008
X-HE-Tag: 1780072120-986318
X-HE-Meta: U2FsdGVkX1/m4fQamQBPTQYsllCUCjwyHPV4K1SQ+J1+5vUqQTOM2Xzi9zAH1owZnP0lPC8Fx1dC7iREtDuGC04igTbWW0E8CPhutlkZSXmYTIEWyRuDToTZ1n7/FB2RgurYjn7ivsup//w/8ROy8+Kvu2UpIUKzqqPU0HRLqTVY/LKLv6HT3mPVHpDT5KRa3Kp7jQbCsqdolxa1OIcZPj1Gm8xgy29b7UfLfWrWtT1wRYZqRIeZJdDZWoJFhbUqjht4tkVh7lgofI0ubFRgl8J6pniKybHWyvnZ8Fuh1eFKjiYJkAvlNBDpp2+MYpTyeUFzmn/Mwj4GqoVKEZkq1+cMeu4CbjqZQ22OeTHb4xpYP6P1Hmbc6Uw8DypgQeUIFOka3AAvUUhIzUtsV+aiLDe6rD3aFbVkyRWlC88gfLEIorDlttgzzpL9VwNjblcIub5Cokzuu1gB8sYOsxGJeQiJCoiO999IZlCVsvwZJB20vKvXqFy6Z+a/D5zZi46v3XCCJVg2946pxwbipoV5UVaNY68VUbnx16CzfVOlTblZ2jr4Yh4T4azj1W08h5ENaoilhtm/DXN5MghN+9pHiQkhpdMR7iHIGcVaY76zFF+7TGilXvwRj3b2HGZV8jZZKA/eDp0vt1SyCdQNfWyByRduNieNHjIWdkwS3hhUA7gJwY8a7L+Sb38AtSVwQ1F3ejyhQ6YsbcaytH3KpbBeTtn5e0rhQsOkXKinYSutn+oiB6SsGz9ENHQIjfccJM2XXN+8uNXcztyxhI3AeEIrecrx3u7fsHSQbKPMpq2Yu21L78cyw7DLuKUAQj9RVZx9E9kt5Fim45vvuw8tqO1RTDFFGFE36+oiUN4bgYCOUIIoi7yWkM6ml2aKWm4ny9KkGoyxCEw1gu8sRc1juVFI5vqZEjRE6xkPDTdq8Gphlc32iacKTGMxr5TBxl4AuqBa/eS15d+1xG7KwREXokx
 zlre2O/v
 5IzxD5CuQ6VQwqnmj9YVRwqZjJOX7/vqH7HP+Mrhqea0WGkrCxdybra+M6yMh11gUERM/srOC+FJsTO7iUIxPpfo9zbHFjpqx/46SU0VgcQ5MnFTPpQK/MfbEBZgxFB55RtswCFvTtUGXS5SqxQifn2LP+XK7VtJveR56397SfoHkJA3NzH2lNHLi/658euEQqsbXYc3P7L47dnIzufutwRr5QqKiZjxeZFxKf2/E2HDeuarT5jIuKE5q0BlI2RCA9BhNeRMS23w+V+H7OcqVCkCA1y8AFeAEHr23nlpiA9XoMFClHPjT1IdbrPuGzCCwUxEiYB9jJBLSO20zaoUmjunEhRQ3e14JUYbSZPnWWzWOQ4PaKhlfYSvB88mY8K/AZsYn3w6eemfaIhH3vlwMiaj7pvWsFyO4K+NIAYtwythFCSoKXRfOx0xVLwHuhrNLcW1V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri May 29, 2026 at 5:02 AM UTC, Li Wang wrote:
> From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
>
> [commit ac1ea219590c09572ed5992dc233bbf7bb70fef9 upstream]

Thanks Li!

Sasha, this version also applies to 6.12, can we apply it there too?

