Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D7B1C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 05:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD586B0088; Fri, 25 Sep 2026 01:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386396B008A; Fri, 25 Sep 2026 01:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C206B0093; Fri, 25 Sep 2026 01:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 074ED6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:44:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 937B2A0574
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:44:17 +0000 (UTC)
X-FDA: 85251194154.17.B350855
Received: from mta1.migadu.com (out-154.mta1.migadu.com [95.215.58.154])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE4EC100003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:44:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XLLTWw8C;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.154 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790315055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5F6F7qba1uzyjFZMv+EeaWChEVyxbKI9bB3fX112gzw=;
	b=rtQWur9ITrQtQUKsR5iPjLz4yS3HtqQOIopsvBvmix/v3nlDVSafMWXV+7Qim1oeM5+Drj
	hFmPUoqvgcERBCksDvuxr1qVxfwBoGy0yiH4hjKdclS40QUu2SotOW6tO9QMPcGGSZ99IX
	jKh6oo5NUhh1HEuWuOPQnnKOJd26DtI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790315056;
	b=O0K1mI1Xhug0JLBEUlJQJE/KrUw5V3ty8i1M0oj0iW/iVCe3juPLb9xvyuy7TkWeCqeedN
	wMIKNaJCY4NlV6JXvG/8620duXONZvs424ftLFPrq5rLYGPvZLnPfRTHy7vMfUIKQVTt0g
	ict8BV0zWwsFkVzlhXZGVZbLwKxls5o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XLLTWw8C;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.154 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5F6F7qba1uzyjFZMv+EeaWChEVyxbKI9bB3fX112gzw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790315054; v=1; x=1790919854;
 b=XLLTWw8CMCBodxzboYQbeud9j4W5k097vZbJH7Fxa+WDrz+DxDXwi+Z69cKGi+kHHwLD1P4n
 VNAwZ8rjy3gz6oNIX+HER+c8pT/1TjW5bqSq8KjvUQe1bfM0+Wl9bWm6Ft4ZK5cvRmkFVexga8a
 KK6J7qRsLTrFw1A3HhqE4vNo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 14310745666562df;
	Fri, 25 Sep 2026 05:44:13 +0000
X-Mizu-Trace-ID: 14310745666562df
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: sj@kernel.org,
	mst@redhat.com,
	david@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	ryncsn@gmail.com,
	kunwu.chan@gmail.com,
	lianux.mm@gmail.com,
	baohua@kernel.org,
	xueyuan.chen21@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Date: Fri, 25 Sep 2026 13:44:08 +0800
Message-ID: <20260925054408.10431-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE4EC100003
X-Stat-Signature: qsyj8bigtgbbrz853fbfaqzo4y7hjng8
X-HE-Tag: 1790315055-474438
X-HE-Meta: U2FsdGVkX1919/Th/F8wf1cYShyqKTGKXN79GDMg5GPrXDGqNzgsYqeCXJ8n6UHDpDkO2EpWdrP/hgPoYv/RWwHsx0RxvX39jWgf+7EhFV9xU70vpZalfQqaUHRX9clsOzSla/vLegKOe843r9X7z6UsLyUWUF2rAoqZskerk0/QF8SpOBYVaywzcAtbRLBZPmmYONNTIUf7BXQJEhBNO8YGyJsIG7uv0ntW0W5hC5z8f4QKaLwjOXdSASZHJyNkVfMSvnkf9jHykStvTlc4/7OGjIHhGBwiNCqlcmnvVzmyR2aB5WaamjKeVRAfLRAHchTLGvMyKqSpjoWoFbA2wSbLlVn286wTZcxMeFlOufPu4SxoZZqYhBj4zLA5w8z+MQ022uO0r8RJaf1nrhl23cm1Kjy2tnZLNWp3jUCLqBWrtIR6fUahoxreaoXs1roFveYVjgCFj8+H4Fv5KK5TdcBy5spFKDxmvft6yoI1xr7+/zMsCzVpwlqgoz1y3X6Xb7dr9uTRJoFjZXV3Dvn2oUOWTXuFAqcXhw8+XkyGDiC1Tci8DHOjST+OdOlok98Qw7bSDEu3H+/pMMGOgDkq7sdtdTfW99OwP5S+PxY1sQEz42iKLh1MWzXnSoX/npxUpPZNVjdBvfKI3Vi3nGt+FE6eSOEQlhTrqr+UKKp1ZWVTx2lI0LPqhRmqlarC6w6cpYDjVpAoQpa+ftC4FT2/oLEkna1UeWn0vyHg1DTME1ijlYB17EvCU0TM7F5o351f2rf5qD/+dCxWYnwpO5ukOQorj9htO6j+dPAg3A8KRrnpUW082zThimYC/M5lzywMCfgEcy0QpZ12QtnTtw1Puf3Z/8cwf/NZxgumMQPdEkNe0ZmPiV4zHN4rNHFezPMC59OeOyoiTpg2Z6vPoEBi394MvmsO4RcgCZkE/nyWWEbZqWAvkGnGWxk+z8nibfR9sj6xFmjwuS80l/jf1vg
 aTSO9Nve
 s1qXXnL+9aguPxQrxinAgllYo+wDQl9NzXhLpPqlayB1enmTjDyOERpx1s6AIHMFV3pyOMgG8zmC5tQ2HF/YfNIqHUy50bVZuF33e229iYzim10KxjmKQM2psSQpsVXsbW0m/wB/ec2mJHyBk6Qr/aZ7DW6u7UWL6dd+4T/ETW7f19lfKvDAeRXdSjqpVJgRe7VGjz37VQO0U2hWnWqb4SWE7xcyjWM7MUD5FfCCBMW1OuzNjfa67in0cDDMrZASkcTlbXjpZ/985VsJiCuVs9ECUmqNzyvlWTiMXLIq/376QqJYhgrBZmFiHm3aUehfAA6BQTBo3bGkWdxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

I was reading DeepSeek's new DSec paper[1] and found a nice use of DAMON
and virtio-balloon:

With this kind of workload, an agent may read a file once and never touch
it again, while those pages remain in the guest page cache. Without memory
pressure in the guest, they can stay cached even though the host would
like that memory back ...

The trick is DAMON + virtio-balloon free-page reporting :) DAMON reclaims
cold file pages from the guest page cache; buddy gets a chance to coalesce
them into reportable blocks, and virtio-balloon passes those blocks to
Firecracker. Firecracker can then drop the host backing with MADV_DONTNEED.

And it worked: time-integrated host memory use fell by 21.2%, while peak
usage stayed about the same, with no significant CPU overhead. Pretty cool
to see these pieces show up in another real, large-scale system :)

Kernel work still changes the world. Cheers to that!

Anyhow, I still don't know DAMON and virtio-balloon as well as I should
(mostly I just know the people who built them) :P

[1] https://arxiv.org/html/2609.22978

Cheers, Lance

