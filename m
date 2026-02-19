Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16798E9A054
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 19:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8C56B0005; Thu, 19 Feb 2026 14:30:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566616B0089; Thu, 19 Feb 2026 14:30:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448886B008A; Thu, 19 Feb 2026 14:30:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CBDE6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 14:30:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D46A916042A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 19:30:36 +0000 (UTC)
X-FDA: 84462198072.05.91F3E93
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id B7DD91A001A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 19:30:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Qxiby6qS;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771529435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bkc+W3z7LdbV7qOK0XaTDRftTDho1sOCxk9yc12rgDA=;
	b=yDO1VtQDfe2CUHgDc8tTmlCwaaT+YFcEPcbsBru0GgMYD0tN3fUbb2VBuoAb2h+lCcagRX
	r33lZol86V1SKB5ARHj/nS5OdCJlN7fW2QM7rjNy5epO+JgTTgVjA8nxCe6mbHzeWyU97k
	tEGMPss8rLCnzMAv/lJvL15VFuOvSFM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Qxiby6qS;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771529435; a=rsa-sha256;
	cv=none;
	b=V7qh3J8eq8wKUWj99ofMZGh87rShyERaSlFq5Ok/dfrQOQ7+DcGVusGAL5CIRf2c9keCwq
	vMyvERWL1qH2Buy43Bw1c5kJ1PfeXuBcciI82AQr7Zu38eneuhLbIqDs4JX1EeBRDnjLAp
	MX3zQL3Rqedf2SV2FVMkuz3AKms3JI0=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4836e3288cdso9157055e9.0
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 11:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771529433; x=1772134233; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bkc+W3z7LdbV7qOK0XaTDRftTDho1sOCxk9yc12rgDA=;
        b=Qxiby6qSSfRN5kEfTO1zXWpVadAGea4jdgdk0KSoVgs8IOvnazN1bYB216ZZAqZh3J
         rrhwueCS2Tv3zK0mj/29G4k9+J3q6+dAadVw5HauE9wQdhSVHd+vnNHUAotA6RH5gupT
         IWyqg66nEn8VeyTgAkdnkGpnOTJkwDM9LSxFFyWOje2rfLYvBDAU/IpklHeVdgMcbUnN
         GmQkbLUnUCPojLkemIijp59nfPw/BSPzmc9Rfgp8xMINj3qoQ34/hmEvK2BPJ+FUB8Fs
         4DDpFocaZAlb7mwIe/MWozRrf7Gl/DKWpQRxk9OrOli3ssUJ2GGyoUIY4HEEy1DX+CLi
         izhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771529433; x=1772134233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bkc+W3z7LdbV7qOK0XaTDRftTDho1sOCxk9yc12rgDA=;
        b=vHocaxWZV8tQhR6RbxCgn9rX+RWxHee6TtoMJUJtDu963kA3R40ZTNlW83LzG2wIzc
         wWm7lVGhSCydU2mg6TCRrA7fsENcTGrXG060rYnAIyutgqJUVfuKbAsmnr8lwXkzAAu6
         pjdNxP4RwUVr93py/ZDLpjBiie+5iE7HCPEFYULcCgRqo0pBQtMfobfEpuIl44Fzjgkp
         rdJoPbIvPHsEmUCLAhcXE7kaKR61yWKEQqReuzcZ7pA7w2qa+9A76u2YUJv1KRP5xJWs
         4RiN6Zbdo3OOQwdUxb6KPjOXasHSPWqzCBtsbOL3yIhFFQ+Y+ffYCdETYWtDCGdhPDZv
         rezQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUaa6NpmQW3U57/kEwoOM7JegLbNl0yt9T323EhAt8m1AeqCxfcovbBxTYYRmemhS0UzUz0Pf5uw==@kvack.org
X-Gm-Message-State: AOJu0Yzef6Sk7Bc716ZhyOhJ9wX1KPK7uvpdBDhLvd/zYCvBX7JHeeNC
	zyI4IH8EdKXuASmSuZwNbZwM393GBngqLaj9mrKSgbM5WYyrDDwLhoSwX5+IJ/2Tk+w=
X-Gm-Gg: AZuq6aJcaalfn9CHKggEinw93173aubkg3r4SON/CTPxeWMUoKNzcQsvdh2/oJtaWqK
	YDeP/gfBbRBG9+g8RtYj3GM3xoqv04Nbcvzr3SHjZ4TQE50XQVP/IuU0xJcVA/JZxM8hKFk2u8F
	9Y8cWg8wTqE6KMDI4k/XirK1CTmK+yfF1VWdNZulRCr5nzwvPtkss/+3ecHUGk91fwasbaFCfKP
	XH1koIUFb5hB7/mbvjoKbCquqxXQ7VI+OXtorFoBjGi/QaJcAUzZ2T7Zo7gRRaqRvzhm3PklZOw
	jwE09xslgzrXFayNUdW/PPTJte8u+Bu8c9fV95zfq+p0z7hJOBXE0BkIj6nby+Dzdc9GIzHQPqZ
	fOc0PeDt7ZQcwzUS/S26X7CNzYohg9r+G4esssPVNtlR2b1m1vVlsPGOENM/Usd7upL110jG4RD
	BbTCDHI2vMOTHfQttSToMBYCyNzI/OOzk=
X-Received: by 2002:a05:600c:8a0a:10b0:483:a2b0:d210 with SMTP id 5b1f17b1804b1-483a2b0d22fmr25084335e9.7.1771529433119;
        Thu, 19 Feb 2026 11:30:33 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31c56d8sm36582425e9.8.2026.02.19.11.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 11:30:32 -0800 (PST)
Date: Thu, 19 Feb 2026 20:30:31 +0100
From: Michal Hocko <mhocko@suse.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
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
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZdk19MqYhWK90Do@tiehlicka>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZcr255pGT3B/eaL@tpad>
X-Stat-Signature: ywxce9qxgwp8n4jzfyaqdx46guba1sri
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: B7DD91A001A
X-HE-Tag: 1771529434-579768
X-HE-Meta: U2FsdGVkX1/VKYnG2Lvvy2LPQRZNi6zlnMWSqgje3eCi4SsjTHZHuL37NKDHuIIdHyB7mQG22pV4c43K78mHg9wH4e/3d0KJBm+aFc857bfLz9A+ZjyFebDVA1LIFAAmF+5ZkWxrIYvPb4EkKMVH0uuKkdpgMTG/UaWgFyVJCnKDQeSNv8VZynU09zMTMULlvjPX84srZoUHOkylPgkv8htAMFe9JAKq2ICNjnQRWG7Ro1c0fBx6MoL0LAVXuTVMaAIiBn9SdhLRkU4PkVaRzqPEpq5qGqRAJ++I6YAGw+H1IuZdflObvwOby14PZpMQigmHEgooL7KcXZ0nWWfERgL29FzYFzhktfW8xxL/NDMTO93YAm0wisHl93BlSLM4qqdCio7uSK4m+Vi6EmEFhP3ns+8jrC/6WIrEMN6NZnC7z3v8eirbkplNk6troDisQiOD5oG+pLBzJSRT3VkHNH3pC+a2/mlDvT1DnLMi5SpUBafCSYjXcUL+QbL8iqnumbImGwjT0nEaGjtOZ1PbsOgpYUouNNYtAhUYhjm5WViEhNIYQ0OGdeLoynzBbdQ4aKL+Jyw7Sjc6P8UNSZgdPzi29voQkA7XANWvJUDn0KZY5RV/PCOlXCZVv+2sRlE1cVdIz9fFVVmWGIuNnsG7CvtpE3AastwAmzYvpAFDqhUbJEzv2uA0yeHPTnj2mjmf1KGK+Y0WX2DTCWr5/JCm3kzD07DKXKZ9Fyf6djlOXJ0plSVCGOJEO/nqCPM8D70rRJLqmtWhOHY+epPdGZjChSGwuuGNXrvQ++W5VqJtL/HH5hduO07b3O40DSHidbcLxM3Yhy2VlpVwhggskzIuejx84BXxmEQ1vZkoPXCkgCRK5SW3/HLISutA6NtpgiIPRvlLVl3KiRbmsHMipSVdfEay0dKAT7nsHMJEMPlDqJgh/BX3sn4ePEicVil/BpyGDbIg6GhfdaZlbvevAg1
 0AXeiBQi
 a9ZIvIN7RbKatew7USnFgUs1YDF4Zqi0v1DFEVQw/NM50N36QgednvGBi4GLwfcEL85Kc7wAKj+T3/pEm/jINe0FUE4PyvfzG4A37fikxI6iF+DSByxYB3r9keI7HrvWcZn2jDxHRKIKnQH2b3NJxHm/7Po3lNsWbvE69F2ZTMUiWHr+SFExOBLx4olX9HuOOfXeJ+2Pso4S4UQSgCurvcPk2Jfm9yskvPH88S0zvBjQjroZ3UqWvdDVuhzOLXAr0M8QAkB7WRHasfqTt/4wejQo2ryGuC4Fsr8l0VdjZagynfZiqKvVnGPpnKB2yN9gvazlL+hSeXVBRua/3iBowzw7M/rowZlqxN0cT4TZGuhnIs6xb89fdlKrl2hrCsmUwJFwgDZNSLNoM5zyNZ538F4lyO5oT8FqWQkrwx1q+8z7HnuY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 19-02-26 12:27:23, Marcelo Tosatti wrote:
> Michal,
> 
> Again, i don't see how moving operations to happen at return to 
> kernel would help (assuming you are talking about 
> "context_tracking,x86: Defer some IPIs until a user->kernel transition").

Nope, I am not talking about IPIs, although those are an example of pcp
state as well. I am sorry I do not have a link handy, I am pretty sure
Frederic will have that. Another example, though, was vmstat flushes
that need to be pcp. There are many other examples. 

[...]

> You can't delay either kmalloc (removal of object from per-CPU freelist), 
> or kfree (return of object from per-CPU freelist), or kmem_cache_shrink 
> or kmem_cache_shrink to return to userspace.

Why?

> What i missing something here? (or do you have something on your mind
> which i can't see).

I am really sorry for being really vague here. Let me try to draw
a more abstract problem definition and let's see whether we are trying
to solve the same problem here. Maybe not...

I believe the main usecase of the interest here is uninterrupted
userspace execution and delayed pcp work that migh disturb such workload
after it has returned to the userspace. Right?
That is usually hauskeeping work that for, performance reasons, doesn't
happen in hot paths while the workload was executing in the kernel
space.

There are more ways to deal with that. You can either change the hot
path to not require deferred operation (tricky withtout introducing
regressions for most workloads) or you can define a more suitable place
to perform the housekeeping while still running in the kernel. 

Your QWP work relies on local_lock -> spin_lock transition and
performing the pcp work remotely so you do not need to disturb that
remote cpu. Correct?

Alternative approach is to define a moment when the housekeeping
operation is performed on that local cpu while still running in the
kernel space - e.g. when returning to the userspace. Delayed work is
then not necessary and userspace is not disrupted after returning to the
userspace.

Do I make more sense or does the above sound like a complete gibberish?
-- 
Michal Hocko
SUSE Labs

