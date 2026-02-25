Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C1C3FD45F9
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB6C26B0089; Wed, 25 Feb 2026 18:58:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D746B008A; Wed, 25 Feb 2026 18:58:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990736B0092; Wed, 25 Feb 2026 18:58:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 883876B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:58:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21EC91B6E9E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:58:29 +0000 (UTC)
X-FDA: 84484645938.06.99A74E5
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 396361C0004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:58:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r+tOENyP;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772063907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQWBXTWhdLgoq7OluVHAAR5bDFt9biBm7m+9/q6MXhA=;
	b=rifmF9XHyz4Q5RJZ/JSpQHp1iBWheFbSmxMEsUT4nnUZZcD3h0f59qjUzL1i0l+dG1iqnr
	bGbjL9JvRWag4zfO36Vmgafg7UR0kgFxymuYKQuZDyFyiqu3WbWl4D0PMTdMngn9cRJZFZ
	StLn5Z7q4UWhrZpCRNujZ441tgbYIOw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r+tOENyP;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772063907; a=rsa-sha256;
	cv=none;
	b=V8Kl2dZR7O7+osVNQRP52JoWwR42SDFkRwqLf1zVg8hljUnVScGFF690MpM1HZK63Pj123
	YUz3Jpq4OoiPYS9BNtljC6cZl0uGwD1iL9TRw01PU3lq0ZAQLynNo3iYpSAlpNwm4ecfDe
	DvfLdqNIijfkC0TENurIq37xWIOzOio=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8cbad8e6610so20281985a.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1772063906; x=1772668706; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QQWBXTWhdLgoq7OluVHAAR5bDFt9biBm7m+9/q6MXhA=;
        b=r+tOENyPQOoGGYLKuy2S5QW9hGzytCin5SNWKWcRpnIBYWT/HcAA02aVvuqseT8gGd
         0RRoG2uG1OX4QbTWDDQ+VYtPLNQALZaqZt1A9CJcF80rFQ4twUtpv9hU1eYXkQqaC6LV
         Sv0j/iLjmq5Yenm1fDCzZ12Bt4GxLlkMY+IL4ScGPp3wKwue1xTxuSDGZhxE5wEo6+Vo
         OkOmA5+wQzpW263IMdjPbMoJPVUhcWy70GkbfyXvzMTmlsYyUAiFzECDDGWvFmvY+HLK
         +Zv61Lz4/D2QXQg7UkrTjgOqjErhaM1Sg6Xpncdchcc55GV/q8GQhZ2ME8aIpul6j45a
         gmAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063906; x=1772668706;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QQWBXTWhdLgoq7OluVHAAR5bDFt9biBm7m+9/q6MXhA=;
        b=nLMhI9JwoyGCheInulobMlHHjB5JZWOR+KbjLHX3a/Pe1nm4ycxHTFpOaPGbHNUAuG
         j8DPJz0qnH4JfTqX7EWIIIXyuNQzdOc4rcYXIzE8A7vHEtn+6aGWa2mxTzinfi2BfTR6
         hA7vUujo2dXo77avP4KpruKgHFCeohazh7lM9pjzyjusqxj4OeTprTnIRD2z++SllWJl
         UMlZQwZ0Ol22EVYzmvALPeUlSPri1znWJ08cfDMkxqIz6OGDzcCmE7wlCodCacrk23x/
         Q0IIAiQ5p8H1eb9fMk6s1aMbcMnogfpZJORqYuwSrc4dr+QwUdxsMsffd+akp9Gt0HCh
         BmRw==
X-Forwarded-Encrypted: i=1; AJvYcCXwo+SvisixNosSiMXHdQKmJFWXTOcxmUYQVqDfp61t7TZSggQrvFjChS9ecE4/QRcmJpy+yZw2Jg==@kvack.org
X-Gm-Message-State: AOJu0YxAZ8WTNRnri6hWI6YLY5spIR6+j51hP8i955rbTG4M/SIjlD+r
	cwZkT5Vgq5Ev8PPRnEFxW364icULAwdPWIkBwjCFQnfIE1iVXCA6mBQq9/TnP+6Y1Cs=
X-Gm-Gg: ATEYQzwlXzffkW8Y5VmAH6x/NWNUs4n8wPv1lwG0xLyokUdaKrndtYpjPxMSY2bWr20
	bWGtW14Q/rUJT5RNB8tQCfm/06szxPQMJbgRk6FxGdEZJy7rvY9vgp60GHSHCl1fXPPrdbXiNyJ
	qs14GzBMwZCFOr4SIKwFSMpn9F3VO7m4T3l+MqqejykcAoo6ETtO51j5dJxaaUd69sF+p9VD05g
	Gx3uY3Bm6L95Qhrp63YBzmEWi+Sd4UuTUZBacApmc4DSZCjdfA/ZJ+qZL/rc/BSW8rknneZBRZs
	H8sgckUSyaeUXOO+QLANJXb1DDi+cfOTfI7Mu+UouMfgoJeGIUKf0PeZMmw0gNIGF+FOY2s/KPI
	bKSkWEXf0uUFHv7e64CK0ALplt0i4i57pH191Qur087CO5zO0uLGNZzsT/ROXo6Us6e7QLmRPLx
	enWU+GjpoZ8OEK2dNIoWdTZ/jUbxSgl1X1J3txt2l4wh8XaUOAjxjcOuDn945QBBeoRdi1Y7rqD
	nl/l1qhxg==
X-Received: by 2002:a05:622a:314:b0:4ff:8da6:2289 with SMTP id d75a77b69052e-50745f165famr3302881cf.27.1772063905968;
        Wed, 25 Feb 2026 15:58:25 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50744ab3f52sm5660571cf.22.2026.02.25.15.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:58:25 -0800 (PST)
Date: Wed, 25 Feb 2026 18:58:21 -0500
From: Gregory Price <gourry@gourry.net>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>, lsf-pc@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <aZ-MnVVNGG_cOvxE@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <fzy6f6dpv3oq3ksr2mkst7pz3daeb3buhuvdvcw4633pcl7h6u@mxjgiwpg5acv>
 <aZ3BEn_73Rk8Fn7L@gourry-fedora-PF4VCD3F>
 <aZ92AvAg5boiSVw1@lstrano-desk.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZ92AvAg5boiSVw1@lstrano-desk.jf.intel.com>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 396361C0004
X-Stat-Signature: d8ytbijscyn1njsocardw7bomm5o4era
X-HE-Tag: 1772063906-460513
X-HE-Meta: U2FsdGVkX18hFZZx0s48FOtA0xg4DXYkxtLKCHUuTUahxJZ3k9VrnE/oNfYguh1yTiw8bDIghrs2jsrC0AmYg352/CqgfDbRFNkLnFT9K03LlCX1KmUuFWXUiE+MqIh4Oxjug3PqTPXX5uj0ptzMUqXraHNfDd1xykk/WYIsvf90+Om0FKxypkUSzlCUiJfWqKfaMMye8WRctqZsfuFEPiT7BbXtw3i2NLFHRaju5AAJK4+KkVlK/yTowmjUb9Fz9g9Ubpzso089X4oXeVAlLwRSxd+XaEhdiq2mNet3i9tvalRtM2CcE23x7Q6/dtjjPNeqGGWJJXHR77JkWRAzsprg2pLPiVAdNH+M1m7EZVV/URjQUp4i+D+1B3CS5Fpg7i5a3DlB4h/qKUCttqWe53UzHrTdTyvUswyy8bcxGPjEd0BkZwSmacV2khbXj1wQ4UsWSQWnKa3yDH8UkbO0uHDvLY2vX2Ga8MjShrStYEUIYmAo5JTTnM2aFNGB9uq8pvH5+pyce5IcFUwi75GjLmd9O8VeE8CgvI4/KxlmTLaXZzG34HLNOKSwmi0vuoqV1/niiQzwaLF2GLwZ+0O83gQCUIbss2wAA6MLQjNIlW+dERGHavxEmYHxkHTjlUYptnPpAHfn27rG6hxGsnyURORIlJj09t8lQ9tMIZquVKv+idrG7WTBE+SRW6Q5G56bPGVdsThg/GpTboqBW3GkNz1cpYpUk1QkTMMzqiWuiTOQKjz+un3O5lp2cgckSLLQ8XEC4ghpIDRrglT62oGIBIkm/LVs8CAKPxg1cGaALr12aUJpRO1hvjaIMIgV3jNarB4KQeitpw8xT3opo4d2kDZa8nKXBpOQ449dfZNu03xlc4SbpZ27hmJoyfPnFTP5WE6zqyLpB+7ALOhqMu5Tf3LIsu9+e1vmcqCGw8totTvtrcvW+ZXPT1d/kUB1HiauIyR2B1acrKNENQXnQJz
 4D6USSIu
 5AQOgp8wLNk9qqWQ74F+rKF9YRuq2FFwewNTpv/3ZWuFeaLaqcFtL6jwCyDhreNwqjC2tMrnEDVjpVX+QRvzF+ofQZ+MiHRlsVRTzDPBELQYspE+p6Xdg+LlE+diK10nhbodem7Jj2p39FpoF/PGT5v7pfnOLzRa5OWJBKT0UijM1AEk1bTjqn3zxvloSYBgx1Gt6WD0Ebuk3FdON0GHjASrM/Y3WXFt4k1YAetmn6NNc2kI2TUISOj+n+nGNl/Z+QwZkttlcTeg95Ywj7kvsfHpza/tlU7mLA7aoU3fdnSmZ32PNXFAvFRBLSXq6AJDMcsnggGe9nF7E2IFh6g24mIk1ULHjNbfU1c+56g1vIgoYPwgfUfGWhN8bCyINR36DNMkGiXUo5UT4blwcdVKogLqdjtCNm4XbnkFAg5jvMl7OCqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 02:21:54PM -0800, Matthew Brost wrote:
> On Tue, Feb 24, 2026 at 10:17:38AM -0500, Gregory Price wrote:
> > 
> > The idea that drm/ is going to switch to private nodes is outside the
> > realm of reality, but part of that is because of years of infrastructure
> > built on the assumption that re-using mm/ is infeasible.
> 
> I was about to chime in with essentially the same comment about DRM.
> Switching over to core-managed MM is a massive shift and is likely
> infeasible, or so extreme that we’d end up throwing away any the
> existing driver and starting from scratch. At least for Xe, our MM code
> is baked into all meaningful components of the driver. It’s also a
> unified driver that has to work on iGPU, dGPU over PCIe, dGPU over a
> coherent bus once we get there, devices with GPU pagefaults, and devices
> without GPU pagefaults. It also has to support both 3D and compute
> user-space stacks, etc. So requirements of what it needs to support is
> quite large.
>
> IIRC, Christian once mentioned that AMD was exploring using NUMA and
> udma-buf rather than DRM GEMs for MM on coherent-bus devices. I would
> think AMDGPU has nearly all the same requirements as Xe, aside from
> supporting both 3D and compute stacks, since AMDKFD currently handles
> compute. It might be worth getting Christian’s input on this RFC as he
> likely has better insight then myself on DRM's future here.
> 

I also think the usage patterns don't quite match (today).

GPUs seem to care very much about specific size allocations, contiguity,
how users get swapped in/out, how reclaim occurs, specific shutdown
procedures - etc.

A private node service just wants to be the arbiter of who can access
the memory, but it may not really care to have extremely deep control
over the actual management of said memory.

Maybe there is a world where GPUs trend in that direction, but it's
certainly not where they are today.

But trying to generalize DRM's infrastructure seems bad.  At best we
end up with two mm/ implementations - not good at all.


I do think this fundamentally changes how NUMA gets used by userspace,
but I think userspace should stop reasoning about nodes for memory
placement beyond simple cpu-socket-dram mappings </opinion>.

(using mm/mempolicy.c just makes your code less portable by design)

---

As a side note, This infrastructure is not just limited to devices,
and I probably should have pointed this out in the cover.

We could create service-dedicated memory pools directly from DRAM.

Something I was exploring this week:  Private-CMA

Hack off a chunk of DRAM at boot, hand it to a driver to hotplug as a
private node in ZONE_NORMAL with MIGRATE_CMA, and add that node as a
valid demotion target.

You get:

1) A node of general purpose memory full of (reasonably) cold data
2) Tracked by CMA
3) The CMA is dedicated to a single service
4) And the memory can be pinned for DMA

Right now CMA is somewhat of a free-for-all and if you have multiple CMA
users you can end up in situations where even CMA fragments.

Splitting up users might be nice - but you need some kind of delimiting
mechanism for that.  A node seems just about right.

~Gregory


