Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BE4ACD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 12:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74EE26B0005; Thu,  4 Jun 2026 08:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7258A6B0088; Thu,  4 Jun 2026 08:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63C036B008C; Thu,  4 Jun 2026 08:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4FC1D6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:49:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 013C2A04BC
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:49:53 +0000 (UTC)
X-FDA: 84842212308.08.B3AB523
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 47C0040011
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:49:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IsuML8MA;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780577392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPt7WmdqXc8TmefIma0e17PhXj7+J8IItu6xxPYhLBY=;
	b=rRrHJVFRA0GTPWR2H82jXEo/sFzda3QEmjWvIrDpi0t0turzjwehaMePXYjWI2VfVPeYLs
	DapF++1kVeGWYvx8r+EZDqPbqWe++oA6BOmtH0ew1tT1QamGEs16yfopCVxSOVMhh2hw/e
	ITBEgwoidYfxmX/7loMGx66N1935Ynw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780577392;
	b=ZCd/IOE6oMsKTFFFbh1RE6hlaA7NbR1mNim2UazKoS8T5b7mVwdt33uX5AgdIfSq/6Ynaw
	Bdwmq2QBfMl9G0rrD3q2SJcEcHN8xNGBuY5ytovwbKg0Mo1mCi+IYagGQ7aNhiBzrlEOrA
	nFUVKZrSRGfvbmZFkIlaAywwP0I6wg0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IsuML8MA;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 196D043DD7;
	Thu,  4 Jun 2026 12:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EEE1F00893;
	Thu,  4 Jun 2026 12:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780577391;
	bh=CPt7WmdqXc8TmefIma0e17PhXj7+J8IItu6xxPYhLBY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=IsuML8MADwjAXf0QeYiq6ebS0Vo8GAiunm2wQqhXcztfHwRGwIoOMfeeJ5yONUzG1
	 TYo6cP+vGu0uzrAzwTMy3IZ9ZJL138OcLbLJhehdvOmn9UKekHZrydojGZJi9kNps1
	 RHjGLzvdJtOggWmZi2OC3DD/oh9LcEdfvHgamjbrJvF8YXzZ2OA/0BKRXZfKYNcus6
	 shiKG1hjjRaVwXvDu7Yo2yDpe1TFwod5QqOMMBOOOUQGi97yN7bNqpdgzk0qLq/Tmn
	 41MUFBnQV/ZQy1HAdYNOHkyKFtm2mSWxmgJOVliqLtTs13IiM07nENRiT4Jz8/cHuc
	 i84ZWA5e4BJAw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 1/2] mm/process_vm_access: pidfd and nowait support
 for process_vm_readv/writev
From: Christian Brauner <brauner@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alban Crequy <alban.crequy@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christian Brauner <brauner@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Alban Crequy <albancrequy@microsoft.com>, Peter Xu <peterx@redhat.com>, 
 Willy Tarreau <w@1wt.eu>, linux-kselftest@vger.kernel.org, shuah@kernel.org, 
 Usama Arif <usama.arif@linux.dev>, 
 David Laight <david.laight.linux@gmail.com>
In-Reply-To: <8e738cc8-dce8-4043-9b93-2bb867c43028@kernel.org>
References: <20260602100917.3641359-1-alban.crequy@gmail.com>
 <20260602100917.3641359-2-alban.crequy@gmail.com>
 <20260603082707.3831525-1-alban.crequy@gmail.com>
 <8e738cc8-dce8-4043-9b93-2bb867c43028@kernel.org>
Date: Thu, 04 Jun 2026 14:49:44 +0200
Message-Id: <20260604-ornament-sparen-biegung-e9930ee7444e@brauner>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=988; i=brauner@kernel.org;
 h=from:subject:message-id; bh=oHSYB+oD4hXjFnZRLLSBQY0UEHAn287ySYBd4bpRJmc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQplmQVWnNyhukcytGNM/Dl96g8EptptzBYcfWfd8vO1
 l7cm+7WUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJH4w4wM376ze4nnHuX5wb66
 sX359Q25W1njX5752hOrc8L/hV9gDyPD969fQlMdOwLZPl4QjtjncqHH++2r/vtW/39XHVsvcvg
 yNwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 47C0040011
X-Stat-Signature: bbg8u7f79rbk6y7r1ccw3anr9zi3fk3n
X-HE-Tag: 1780577392-974123
X-HE-Meta: U2FsdGVkX1/njeDG8WPdY6nQwKkskp01s86BZs4zxfKc6v6FyEDilAY0tQ8BNH3whGMMh5DXY02bpi6m0ccqed/WzmHNmEBukjJWmFSBBzfP5/wWXbFjo4faf99H3Q3LNu9mmGcMcw8xqhhSOCbNCtxjL0aet5rvlGbK/rOtZGCaKii+K+ITGKwoUXs6ZR/zT5L7mBIYvC35SLTHksjidHxwNj46GOTHmbfArKOsNFHtWc/1kUr1SkO2mIt/7sErl1mCJwF4HUjfLF+19vqENHTIF+nPMtwRHiVVtyjs1LkcUzZsXo7Vw/fBh+WoTrfblMf8qjGwbTIi8oxk6jrKb/hB7fj4PdnDT9JQpix8MIZXevaH5LQlJb0cXnPNEnVBf8ugFNKvWq2PNKYrWaiJbRSTfBVq04RWxgSsJkWaIF+oJV0Of96MPqszfZN8Q7lDqLXJApQ2aKYUlQVUFPXI5pFcB7pQR8UTYOBB/8JsMFNWpmPvQ03e2YBmcxM4mnfmea8zTG0zdBFrU8m3SK2BcXgRk1QU1zi4zT4mMeVTyuZbQAYGtKdlJ/HDdSGoBPyzq8ED00FtDMjaXVHVWqeHHUMRnTIIdGFggIDw8bAask1XxKV/jNSXEADu/bDyO0jhe+oYklk1PfK3cGvBmQD0Vc+i9yuo4uG8ynUUWdFkE2T1gDGNGWxlVn/My1eGKkLEzOb0YY6jsov1qqwwm7O6j27zympELAonOoJkaqO1DhoYix4EkcU9zKDU/3szTJrJ6YZaqi6Juugze+5jPuxHr8d4W7zwZuUxlnWOcVzT3GaoZNeK1vZltEewp/OPRd5hAyzhKnjRQ5QDCU3KXgH+XvHMDNIhYkNTVjT5b7ipJP+mVbAsWGUn6c2P0NHUsiLjqKdfV988/j0aqzweC/pXR4Ul9yjL4A7UCyQBtrDITSFSO0QpjOFNWAKLFy0ku4NdwLxCZVfJaiSp4Shc+RF
 2OJjwPxQ
 Su7J21dKxPaa77/eyMXcS2qx2OTu+P23fuFvy81tYS6QhCraNixpxwBAFWFviTosDiLtePaw9b2MbZBJIEk0A7QrXiBnwL8sNJX8+orP7kPUR59Egjksuq8bHcYbhGTHQrbT0nJOzsOB5/KQqe1Vl8NRtflQFryehCLaJmzDmqHzOKczCdMvycVzlZtcMv3+JtFWm3x2PparoW1qMWn7GdWR9vmWyjBOb/ZfNaL2GNLMg/e9oaN4HbX2izCbvgwwrC87LTdwUym9HLJrzTSgPdSgaTmbx8ZRuvssbGsk8mBr5soU+XbpINxHVXe+dV1bVgeNXtujhNWuIa+ITMdxoLhSfceQjMnrSwr48gHEiNCpxVWPH1zbSe7pcaJi0Hcnqy+URs/uv1oGO40k7OdB1zEuc/qOkBdqD5eqz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-03 15:54 +0200, David Hildenbrand (Arm) wrote:
> > However, the exited-leader case is a real limitation for profilers.
> > OpenTelemetry eBPF Profiler wants to profile a process where the main thread
> > has exited but secondary threads are still running [2].
> > [2] https://github.com/open-telemetry/opentelemetry-ebpf-profiler/pull/376
> > 
> > Using plain TIDs (flags=0) would work, but it means users cannot use
> > PROCESS_VM_PIDFD in this scenario.
> > 
> > What do you think this patch should do? I see two options:
> >  - Address this limitation in a separate future patch that fixes
> >    pidfd_get_task() to use PIDTYPE_PID when PIDFD_THREAD is detected in
> >    f_flags, benefiting all callers (process_vm_readv, process_madvise,
> >    and any future users).
> 
> Extending it consistently for that scenario seems like the right thing to do?
> @Christian?

Yes, but I cannot vouch whether the mm operations deal correctively with
subthreads.


