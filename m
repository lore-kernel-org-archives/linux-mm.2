Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C3CC98311
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1F7D6B00AC; Wed, 23 Sep 2026 11:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC376B00AD; Wed, 23 Sep 2026 11:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996E76B00AE; Wed, 23 Sep 2026 11:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB136B00AC
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:47:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F22DA1A044F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:47:17 +0000 (UTC)
X-FDA: 85245456114.28.92E0DAA
Received: from mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
	by imf27.hostedemail.com (Postfix) with ESMTP id BC7194000B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:47:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QVRAKpPw;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.27 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKiW8rwP60FsF4fzVgU0x+yXAX8l7xFBn4J5o6FPZ7I=;
	b=JQ5Qx5Z3to+S0WHI8mpjS/VUXiaMC1m4HZAI3FtOm9TbtWp4huYnJiNLRL6iAQfFxvIhh4
	3anWcyYBoKvuSmwcamZoOBIYmhsqe3YaeJbUOlQpMEj0t53rDt6vqzeHPEej6buie9x+CH
	mCic0vNQT5EE88Cau95TwCwj6eSHXfU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QVRAKpPw;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.27 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178436;
	b=t/YC1T6GKUmgDFVLxANl4xOqXzvzNu5gzHAN843qNZ5N/lIEVLyzQMdtW0JLSJEeXzhHAm
	CBKeIqyYlsysM6E+5rN+mum9USWRVP6W0Blhk7Z4QMkkh1kcrvekLxZ8MWisAVHLyQmt1m
	W0Mg/sUBGdqMUkJV50asZw81/+zBUs0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HNkEwA1ANe2Cy1ef5VkR+k5aNsAR9SDnOLDe/iDUfoE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790178429; v=1; x=1790783229;
 b=QVRAKpPw9pB0VhEAsCwtrOwBZGF/JCoRGpiqsVVzoZ9QhWK5hxGAfABKcxhmvptQ/1Cs5WpG
 nI9r8I+aFU9x8Xd/aSJiFQdkp9dEUuCuBiL+5rxGXqFvr7q4vnyGhfbVPDK2ItoRnwM1oqIX8Bh
 kWAZfFcfgjma5hXGG0Q1mLkY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d5fec120cfd73ec7;
	Wed, 23 Sep 2026 15:47:08 +0000
X-Mizu-Trace-ID: d5fec120cfd73ec7
X-Migadu-Flow: FLOW_OUT
Date: Wed, 23 Sep 2026 08:47:07 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
Message-ID: <arPyspcEFNkqfNyr@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <CALOAHbA4EgGw_uWfbXD0Q87exP7ek=z9ENuU_ARgb+DgBgy1kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbA4EgGw_uWfbXD0Q87exP7ek=z9ENuU_ARgb+DgBgy1kQ@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC7194000B
X-Stat-Signature: 7q93xqyg3q4i8ha88nt5r6kf95oatqfe
X-Rspam-User: 
X-HE-Tag: 1790178435-952250
X-HE-Meta: U2FsdGVkX19yOY3pNbA6JX9sOV6KmZTVdpy+RSb24RgCwO+SkAtQuIipsw8LGUYD6IeA1j5Ob/E3XDduM08lipKBX57F3YlgDHUjIo8ES9dD3LSWyhUTBQxhmCOvcbzjv0v7qtj66On+E/A7in4VZUo1qd1dUkxJXjimPqlYmWlK+ewlSbRZRUqt7AMNggktFzQQgIvn/LyYjCwfozSvcRXTfg/lr6awEyJAmCRVniSFp2Pf3+wYnk/hBOEaMCcz+S7Ce5y1qdBgHST022lG+ZvRRFXGWMEqZTCz8EZBPvUIUtRJj9vdg7i+InilUpcv2slpGGotS7XmqEpzFrNWfeVFouMhT/OCzjqRIPNLhrCEt3KAFdxBe1nBQHMMVPx6CZynN0DXzRWRpE0S3DJ/RAqaL9QLRb+lW+sflDvXR9vWDhLp6GriY59w2rnETsmuEcnw+Hwh5fwdDH792Bmo9Km4bUlcNBZTdbgmnX0UE/lgKnjetIE7Pwa7ImRTjBDLoYc+tzhjZaSCasMNT6oSQtNUCZlx4h1SUjqUlC4Ptu7vJFuBLdvlnateu/WTvhsJhyCHNOt9GVGMsKKIJKErfeOEx+Br1mbuBm5ZAq46Ci2O0yWiAJeWBMvARDUPPq4ZPZBpTamxKZiEnobI8NYBa7Or90iXIkVR40KgTUmxsoknbPhQqXYSrVbUS1PB+jfoNn2DCxWIOvsJZc3dUASgyr8a3EVKrYmE7pRflht9pcKwp6UmW012xLmwTfw3doSsPNE1dskUDnpdp+iT5aScNe7SSUz8B5wt0Kps2QK+bocWVN+z3J9TgJe394bLz73YwOjQnCAM3DUVXzGLHcd2Lyg45fM/8EC4++H79vZKQsd6eDRnZY8Z1GVHccu0rdPgXiD97dLmHCcXD3CXfWnNHwXBkyDv7IJNaaHbfEby7EQQ0CYGSaXrm/SnqKe/Cu+IF6ujhiZK6e7CZmnhxeB
 2+Lc+JSH
 8TPi4YymoM83KMxPzo881PRNhE2M7cdMkTdm1JF7zEj6XtbdRpitbsnIyyqOxg1CLyaQ7Lcc6lIJCnPUL6FJQtSB1ZfSj17yxj3iC6+IxCxJXelQd4mUOfeGcqkjWMfjTpEAlEIdR4YMZv7JJbSbUf7QJx2UpfK8OVi0Vb3U+5h2kQgC+immE9joTCRHLo0H06AgvwwARRT6aBGT4zAjUqXQkXn8De8xxWKlJzifB6nEu8dWCaQi5IKoMeqtESEUmahrv0/P9t6a1yUk/QQc5Ht8T4JqB21JZbo+wOiufP60eLmqULtHGQQRPiwHWgIaZCZTzq9ULmSKDywc1/1FhT3pRJKAaluirvm4RkxaBGQmN0b/B91UNyVc5vrDIyBfcmUtipuPHdDmhByK2bHFk/yR3EwxnfPy6ykI1eerv4nvSmS8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yafang,

On Wed, Sep 23, 2026 at 09:07:40PM +0800, Yafang Shao wrote:
> On Tue, Sep 22, 2026 at 3:30 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
[...]
> >
> > Known open questions
> > ====================
> >
> > The semantics of memory.high for remote chargers or kernel threads is a
> > grey area and this series does not aim to resolve that.
> >
> > Another open question is whether a bound on debt deferral is needed. At
> > the moment, we think that rather than putting a limit on deferral for
> > memory.high, it will be better to handle that through an async worker like
> > memcg->high_work.  We aim to introduce that later, along with the right CPU
> > accounting for that async work.
> 
> Hello Shakeel,
> 
> On the open question of how deferred debt eventually gets paid: would
> it make sense for the policy to also notify userspace (e.g. via
> ringbuf) when it defers,

I think the notification through bpf programs is already possible and a bpf
program deciding to bypass memory.high can already do notification via ringbuf.

> and have a userspace reclaimer do the reclaim
> through memory.reclaim?
> 
> I understand one of the concerns for the async worker is CPU
> accounting. If the concern is that the kworker's CPU usage is not
> charged to the target cgroup, the userspace reclaimer could instead be
> spawned with clone3(CLONE_INTO_CGROUP) so it runs inside the target
> cgroup, and both its CPU and memory usage get charged there.
> 
> One caveat: intermediate cgroups with the no-internal-process
> constraint cannot take processes, so this would only work for leaf
> cgroups.
> 
> What do you think?

I think all of this is possible without additional code and with this series.
With AI, should be very easy to prototype it. Please take a stab and I will look
into it as well (time permitting).

Thanks for taking a look and also please let me know what other ways you think
memcg can be customized through BPF in a beneficial way.

