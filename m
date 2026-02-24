Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAAAFF4BB72
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 18:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F10386B0088; Tue, 24 Feb 2026 13:26:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4156B0089; Tue, 24 Feb 2026 13:26:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCA0B6B008A; Tue, 24 Feb 2026 13:26:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C98B06B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:26:33 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4913DB2E4C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:26:33 +0000 (UTC)
X-FDA: 84480180666.11.D7565FB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 197A6A000C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:26:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E5+4dnoh;
	spf=pass (imf15.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771957591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kj/fGA5yp0dGoSw6F29+YuThvBFpON14H3YrN8gK7+w=;
	b=63O6xU6fDIOBClysI1aVhR3U95ko5IqoE+bb4HcHLiTZaMsF0QRWn4+JFxJk8xNpq8X4JJ
	w8IPiDziAXiHePhoRVD0bEcdhsF3zD3EWqzALjNlNhpyBe/vIa0YAnO5+jL27wBuuxSiL9
	fzyJzbN3xGqC1oURPwayOnJEw95VrQg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771957591; a=rsa-sha256;
	cv=none;
	b=2oQ5E+Lx5rhhAdfY3BgIRE3CW2yhLL2X8s9PIuITN3TcKa3rl6gcw6SyhpQ2TA8ja8A40S
	Q708DZGu5zR4LeXu+iKg972RRznlOO9qBJDlSKE44HKqow2MQ2cK3+mFddTDfNHDL+L0/Q
	St3mL7fwnSv+Kbj2UQbHICdnaxWUYmI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E5+4dnoh;
	spf=pass (imf15.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771957590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kj/fGA5yp0dGoSw6F29+YuThvBFpON14H3YrN8gK7+w=;
	b=E5+4dnohZPnezFlTJF/iX90se25eI1lTsOc2NLaIkrMUWO0xsZGr+TdKzUunW2/EIKXcLq
	mO79cV8XUwZBtdheHXn8na/FNx+QuN/9qDX+TlPsaN1VuxTbg+Qug5rbzgW+e+FTdB1an3
	zoyv/+WeDhnzi7NfJot9Qklvi8p+D6g=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-150-7KYmAGGrNIq1EsaTJSiqCQ-1; Tue,
 24 Feb 2026 13:26:26 -0500
X-MC-Unique: 7KYmAGGrNIq1EsaTJSiqCQ-1
X-Mimecast-MFC-AGG-ID: 7KYmAGGrNIq1EsaTJSiqCQ_1771957582
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 161F918002C2;
	Tue, 24 Feb 2026 18:26:22 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.3])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 149F61955F43;
	Tue, 24 Feb 2026 18:26:19 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id E09A4402DED09; Tue, 24 Feb 2026 15:12:32 -0300 (-03)
Date: Tue, 24 Feb 2026 15:12:32 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.com>, Michal Hocko <mhocko@suse.com>,
	Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>,
	Waiman Long <llong@redhat.com>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZ3qEHzgI8Zuv7IU@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <3f2b985a-2fb0-4d63-9dce-8a9cad8ce464@suse.com>
 <aZibbYH7yrDZlnJh@tpad>
 <aZ24eAiQpo64-0Kz@pavilion.home>
MIME-Version: 1.0
In-Reply-To: <aZ24eAiQpo64-0Kz@pavilion.home>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: vkjzIlOKKGHNypUxUUttudV5AlsNYsmGA49YfKceRv0_1771957582
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: 4sw4dumh4ka56sj9a4ewbsbz8dc63chj
X-Rspamd-Queue-Id: 197A6A000C
X-Rspam-User: 
X-HE-Tag: 1771957590-350868
X-HE-Meta: U2FsdGVkX1+r/qCegfOwuMpqa4y4HS7Qo5QWTgLpTPpppMgKsQBZKbnTa7h3/6Xm44ElIaBLC4y/fL6zlaq4bsYjhxF2mbqaZn/lWfnQrzKcoDYyJetwgtsrTa7ZY+y4d0BeLrgHCymWiAKIM6hUOBCXVJ+lk3SKcHfLBf/Bz3eXYfCDa/ZZgL8v/1sFbdkz/SD9NITSkbhvjqORcbq9tBon8sSnRrfh7r4mVS42+sktXZ09u7K3qFVmd0POnYeTMNB9sZMB/g2iZFQglI9xoKII7HpTcpRIf7a+PGiFjeGlzAT8EWCrWHVwQ3GcIT7aUt6L0JlVriEsNKrxenYhXdRzUDsEGVr87KiIcbXv4K/iH0d78OFiqwSIYu3XSRpULL1Y0cXfmfRmq93SHulHi7n5vJVZMXsHugTMdnlSVIwg0cfhaczXrnfUTBZyaFwzBtniaDR24YrHoC7TtTitoJeRZVEVG8XERDJP4ao48FI2WITG5jkEdMRxAF3yWW1SGpLD4MGGoa8Vs2y8CtS0DAuqRm60V5g5NQT+pP5xXV6Miyc0XkkZm2brBZ+D4wyb3pKSLcWDlPB10PNL5q0z4prLHXsI12rCv18bqjIlc82C1A0KdsHI/x9b5fp1XotSXwJBX7utBAWqKFU7nPO6hMOS77BZIav7vrgLMMEPh0ROLKErbO4Pf9l9ldHzb2NWguQ8aN3xq9Q22E+SoOt0UhrDk4Xq7KXozmWJSjaIbj+I0i31yxz+o30iTbcZagBqbqSPtvVt3+G+Sg9goAx+IrbfoFCJzhClBBf+niA8FSd3MVfOb5ZqULZWozVT2JsvBx7xpo87HeJqGbxp1I2wPJwcOv4aTXTX+dzm9C/htSpbw9xhfv7vwtWkc4de8aU2sgACE7yaMszzfZLEEfsKPokZ+IpMnUKgP7uyCbIfNJO7e+qVd7yde5QkYrr2xtGviptmn34j9pc9rubRZnZ
 GyMiwmBP
 c5/2uPdZBkBCjl4hKkorGUxgKGkutWkeacHXHrQbS6uv3ZOJ2E8vMzcyYRFMa745QnKBwBn6po6WsuB7SOeLwq2dxNauFaFgQYKl6ryL40sNsDeQDRJ+GhZa5XZZF/pAH6islF+yZ4OzGBWqcw46or12PegbmP0+O2JBWIkfITlgXGxPSmSvH7glMd0e0GSK1vn49itkWeriRj9tTDRk/AyVgcoxGiGPXeAyGWvQ0StlsBH+8M07dV49VTHtvneEYwEOaf6xDCA6HmQwxy1VSvCT71qseRiEVzRMW6C3NE0quRES92n2CW5ys/qp5WvzXZidJxYlaGqEDAuOUvzMBDaB/PaXIa4r+Z68P86O2hS1r8zAoMSyZcW9fGoUVsye25bDwxQho10Q6oclGFL3H8ff+3kbvNuonYNZY0euV2d920MSa1urhmer3ZJsYITUTY1CYgBdQstdm1gQFZOwBC1DwojKM7XTNgGbhr0+n+PXpQ/SGtlTf5XLS1jxlGdOOPR9ulaQ4hXQhKnCcosJVAWn93g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 03:40:56PM +0100, Frederic Weisbecker wrote:
> Le Fri, Feb 20, 2026 at 02:35:41PM -0300, Marcelo Tosatti a écrit :
> > 
> > I am not sure its safe to assume that. Ask Gemini about isolcpus use
> 
> Erm... ok fine let's see that :-)
> 
> > cases and:
> > 
> > 1. High-Frequency Trading (HFT)
> > In the world of HFT, microseconds are the difference between profit and loss. 
> > Traders use isolcpus to pin their execution engines to specific cores.
> > 
> > The Goal: Eliminate "jitter" caused by the OS moving other processes onto the same core.
> > 
> > The Benefit: Guaranteed execution time and ultra-low latency.
> 
> That would be full isolation (aka nohz_full) because the goal here is to beat
> the competitors. As such the software latency must tend toward hardware latency.
> 
> I wouldn't expect any syscall here but a full userspace stack with DPDK for
> example.
> 
> I put that in the 5g uRLLC (or similar low latency networking) usecase family.
> 
> > 
> > 2. Real-Time Audio & Video Processing
> > If you are running a Digital Audio Workstation (DAW) or a live video encoding rig, a tiny "hiccup" in CPU availability results in an audible pop or a dropped frame.
> > 
> > The Goal: Reserve cores specifically for the Digital Signal Processor (DSP) or the encoder.
> > 
> > The Benefit: Smooth, glitch-free media streams even when the rest of the
> > system is busy.
> 
> Here I expect weaker isolation requirements with syscalls involved. Scheduler
> domain isolation alone (aka isolcpus=[domain]) would fit.
> 
> > 
> > 3. Network Function Virtualization (NFV) & DPDK
> > For high-speed networking (like 10Gbps+ traffic), the Data Plane Development Kit (DPDK) uses "poll mode" drivers. These drivers constantly loop to check for new packets rather than waiting for interrupts.
> > 
> > The Goal: Isolate cores so they can run at 100% utilization just checking for network packets.
> > 
> > The Benefit: Maximum throughput and zero packet loss in high-traffic
> > environments.
> 
> I put that in the 5g uRLLC usecase family as well (again or similar low latency networking).
> 
> > 4. Gaming & Simulation
> > Competitive gamers or flight simulator enthusiasts sometimes isolate a few cores to handle the game's main thread, while leaving the rest of the OS (Discord, Chrome, etc.) to the remaining cores.
> > 
> > The Goal: Prevent background Windows/Linux tasks from stealing cycles from the game engine.
> > 
> > The Benefit: More consistent 1% low FPS and reduced input lag.
> 
> That's domain isolation because frequent syscalls are unavoidable.
> 
> > 
> > 5. Deterministic Scientific Computing
> > If you're running a simulation that needs to take exactly the same amount of time every time it runs (for benchmarking or safety-critical testing), you can't have the OS interference messing with your metrics.
> > 
> > The Goal: Remove the variability of the Linux scheduler.
> > 
> > The Benefit: Highly repeatable, deterministic results.
> 
> I guess here there are plenty of flavours. The only one I know of is this
> power simulator that relies of nohz_full. Not sure about the implementation
> relying on syscalls or not:
> 
> https://dpsim.fein-aachen.org/docs/getting-started/real-time/
> 
> > For example, AF_XDP bypass uses system calls (and wants isolcpus):
> > 
> > https://www.quantvps.com/blog/kernel-bypass-in-hft?srsltid=AfmBOoryeSxuuZjzTJIC9O-Ag8x4gSwjs-V4Xukm2wQpGmwDJ6t4szuE
> 
> That's HFT again and they state that they rely on polling userspace drivers so
> I don't expect syscalls.
> 
> But anyway here is a summary I would propose:
> 
> * Domain isolation alone is a good fit when some glitches must be avoided but
>   kernel work is still necessary: non critical high volume networking or data
>   capture, video games, etc...
> 
> * Full isolation is a better fit for ultra low latency requirement, in this case
>   the kernel is only good for preparatory work and interface layout between
>   userspace and the hardware (VFIO).
> 
>   I've observed 3 patterns so far:
> 
>     - Low latency networking with DPDK, eg: 5g uRLLC (should be syscalls free)
>     - Scientific simulation (not sure about syscalls)
>     - HPC computation such as LLM (not sure about syscalls).
> 
> Is flushing work only relevant for full isolation? If so I can't say which is
> the best solution between flushing pending work on syscall exit and doing that
> remotely. But if it's relevant also for domain isolation, then the remote
> work is better because it doesn't add unecessary work on syscalls which still
> happen in this mode.

Yes, see my last email about HPC.

> At least doing things remotely should be free of any surprising side-effects.
> But we must determine how to properly activate the isolated mode (switch to
> spinlocks) depending on the isolation mode which can be not only defined
> on boot but also on runtime (at least for domain isolation through cpusets
> but it will be the case as well with nohz_full in the future).
> 
> Thanks.

If you boot with remote spinlocks (qpw=1) today, then you can't change
that.

You could, because its a static key:

#define qpw_lock(lock, cpu)                                                             \
        do {                                                                            \
                if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))                   \
                        spin_lock(per_cpu_ptr(lock.sl, cpu));                           \
                else                                                                    \
                        local_lock(lock.ll);                                            \
        } while (0)

But haven't thought about switching on runtime (and don't see why it
would be necessary to switch on runtime). It is independent of 
switching CPUs to/from being isolated (or nohz_full).

OK will address the remaining comments and repost.


