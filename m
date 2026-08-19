Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E879C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 06:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4A0E6B0095; Wed, 19 Aug 2026 02:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA946B009B; Wed, 19 Aug 2026 02:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFB56B0095; Wed, 19 Aug 2026 02:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DFCF6B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:47:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1D0C16044F
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:47:38 +0000 (UTC)
X-FDA: 85117088196.02.024A4CA
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id B59DBC0006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:47:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Mh+ToL6T;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787122057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4WjkvsBQ0E8wD5Ds/jh+ZodB+Y3e1a9vvF6PPHb0eo=;
	b=TWH3vwi8H/EBRuTmH+Ba+0HrgpyoEmGTnItPH+vU3Tjyzm6GT4rWDxuLDw3lppHlmvtIEJ
	ahHj86+0FJEtDpZNiG46sb2v5JTw9/y8X1nNOzaMZGf0fOSaW/l9atQxS5v77JeVDNtIl+
	e4M0d5nBDoYOAW2TPnyErBMIIwSaAt8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787122057;
	b=OVyi340R8OWBGR7HznZh7pQ6iEubjOXdPK2GfQRdZYEA3+f5NFu2jLMOPTvcmejkXNnHAI
	oawZeK5CgRECsvP5V7hFuW1Pgv6ocneitbrndx1aVeKJzZni7fxg4M4DIBb7n+AH/wsilN
	ruzWmm+dni12j7P4Oe/nD8dCh3uX9mg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Mh+ToL6T;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-499acf0fb55so918315e9.3
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787122055; x=1787726855; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=h4WjkvsBQ0E8wD5Ds/jh+ZodB+Y3e1a9vvF6PPHb0eo=;
        b=Mh+ToL6T4s1nBaxaw4Le2g67kV5+/2JSnqNSIkzMCMiJfpjurNyC1/Z4q6SYHY0Jxy
         +ufYfWeHKhiOpwDhA07gkl0vYOt6zwmv/xdoQN/+FG6w4UkSUfEv5J/D6Cbaj6GNPzUv
         s1zyzL6Rp92TrzdRb2nZL8YQr5gVcB66+WMALivkxnhuH60BL1A5baWEONQh6BCWSk7e
         q39PEnP2KvWmEAiogTUsIHQZgj5nC74u1s0/q+IU9UsuYKCBm4rCyl6witBzHCcJXlI3
         OWxwFwHAuNf5ygO7qfGyA2Izv7QgL7cqXjx5UeSkOYCSj3xD21LxFHF6okqddi5UZ+Ir
         rMZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787122055; x=1787726855;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=h4WjkvsBQ0E8wD5Ds/jh+ZodB+Y3e1a9vvF6PPHb0eo=;
        b=V4Ekrkbf9kVuSkcvA/oeHJCuuc+f21vlH5iIJBwiscNYQPioSdG9tZNGXPehYjNYrk
         nxjIXUmpbwSS0E1RL93EDnMksM0YCSOUYpvgtVwCNsXX3r/jPCsjhG2MrQfcvmhEiXkV
         CIP8k84C0RHyLY9FXJNfAqGAuZWfX+rJwvEmmmjTOsZ7qyc3QV6GWZoiiR/TXlh86r/f
         ArZfF6y+nM1hES0x+ZTYR6S0K1y/zb0K5pqW2A6TqoMd0kWv88ZiPPO3eESpXvFBw55E
         rstdWXB1TJr+W6dUl2SNQlyPirkTtGgkK+W/wN6HHkPsLN2oyNFrEETmRa4tRrK4sWUy
         N3NQ==
X-Forwarded-Encrypted: i=1; AHgh+RpIhUvEORnl4sYYSNG7qNjw2rJ5k55Q6QPu0rgTM6xpS+LFkbOuTxD54tW7yoXOH+aDhwPyyIvW6A==@kvack.org
X-Gm-Message-State: AOJu0YxQvi6WkRaDJiGbBZNDns5ksv4zN80XTmWHraHUymt8e7wxXd54
	ZNSW3AtWux0X3zWOPEiik4bQpi0S2e6UaAMlnFCRfx+QYquTKF/mNBVdasGoUsMIV0w=
X-Gm-Gg: AR+sD13d0D+AvRubLFyifdABwWQrOZYCjHFoiPlZbJPROJ5Upbe3jd+K93PDNQsRuCg
	VRvRh/PY9tR8ObkQl+Z7Vcl2RK1Ed0G50X4kfahkqLrbemuzMbX/G1ZOh5jbfo6RxYW8ezVBa0A
	n+rEt+CN1PFOVfeEkmqn2uuiEu5NG9wz4N4mURWZllnewglDaNPSLsrmMDk+P/Rl4VbnKE5hqZl
	ZwKPTUXSgc0xAFVkpWMvB9JV1/na5ktzxWxIhUhJpACejia5dc4xmvRmMXrw1m6mo5RbpD7quAO
	Y5BHSudE+7q4F8fQ5Z6C64BxzSAebb5SfL09idCTCHUpPsP6TZb7r9k+9wZg5AlZvrzkiiDuQ2J
	Hn7OrZ4c3UeR7MtoEZ0Z2hYPIJFUPFJst9gOBjZV+Zkz4k4935vFuCQwoLfaoOyYVn0JI1JuS84
	VXfPzn+lCMDZhh7cnmTyixbh++R3DlQH7ZQPtlNyDdQBPd34UJ+FCl9BawBmZn3jCfbjsFfKDNn
	A==
X-Received: by 2002:a05:600c:34d1:b0:499:49f3:77b1 with SMTP id 5b1f17b1804b1-499aa14a6a6mr39006955e9.3.1787122055272;
        Tue, 18 Aug 2026 23:47:35 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499a9dff4c1sm28169295e9.3.2026.08.18.23.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 23:47:34 -0700 (PDT)
Date: Wed, 19 Aug 2026 08:47:33 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Song Hu <husong@kylinos.cn>, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, liuye@kylinos.cn, rientjes@google.com,
	shakeel.butt@linux.dev
Subject: Re: [PATCH] mm/oom_kill, proc: replace magic number 1000 with
 OOM_SCORE_ADJ_MAX
Message-ID: <aoVRhVaG1vxyNAZG@tiehlicka>
References: <20260811033609.3992348-1-ye.liu@linux.dev>
 <20260818010433.65169-1-husong@kylinos.cn>
 <9a92b4c9-ad33-492a-b206-2b0862585c64@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a92b4c9-ad33-492a-b206-2b0862585c64@linux.dev>
X-Rspam-User: 
X-Stat-Signature: cquhttgjdp73w8zd1rk8n9d5jie6d7s5
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B59DBC0006
X-HE-Tag: 1787122056-863396
X-HE-Meta: U2FsdGVkX1/yMsbRwnnxwf9RPlZXabua5EaZa6F1ls4BnAUNGsaqtZf821tGeso6oxLzqJPylGxuLY1IrMs/qzJxjv2ZK6ZBEG2sB/GhH2Mxc5ybu23IpdAaeWd+BT5GYbAR0y8bvrhPpo1vkdu/ohBVIe8tMf08f4s+7nE+cwMNI5RTYRypWm2Da70YdHlZ8Z4hj+DbAnnHa7dTWmCWFwYx/xaPKxwvTozsq+7IREAdNeTs8Ncw8XVbRPBqb5bSdTtWBxqasRF/kETI8dRK2I8N+F4/nPWTmTJrSFFeVDKGjVn9RW775fj1tGwY0cCgktiTRz6iIlYSaGvIN+TK8Z94E9mlJCwpFBDq3HMQj5FHr5ArJ0/AvMr4Pg+AFtTsMi4JnnU7yOHIF43btuSDsna/3fAFOuf8yRxlUtDF/Y2HNitj1zNIInUx1fXMYAyki9jbRIWV5vQ7QpotKd3m4/Yj4P9aXujWEyeLsgaYFkAkmguWjs8j+su34+ny2rlUpJVoduzhmdJxQ6y8IJMizeH+ou20VLVGlGqVaUYxCDMkVlcBEivqd+YVU+5IK4RZTe7NLFBY8Vt1KfKvMDrFMB8ta9956GhZxEm6XqJ64Lr7VLY0uUU97PdTHjjJZZVuDQejWbIwgHEMZKilXPPuQJ/kBjUI3FiGxwRMzUvgNa/1sEliamGUP2GqCtbyaQ+Ax2xj6L6jMD63S2GqXTyfPNNhUHApSEMbU6rPMHXB16vHD1bnhu9rjyNLS1/iQV4cjuZdpt9D1Z7yDIPEcXZJ51847wBorLM9sRIQUXoY/BE6ZuKVWhFJP3lpXoKyJitC7M++eWfuxpkY1XqiU9Na3Y/gW+1EqPD3DSj3xwyxXUWbbEMrwiCo2Giu+zeHkKokHo5zaZem4sGwh+embLNyzCLH67ModutGVKz731KemOqfsscwgcSELXLnkW+QZUuo0uLRkyq+otTVnIkVjvi
 DmBJjEC+
 oonV8vTMZBDVznP8tAqZlhLe572HqtTZze6f0dnScEqz6jVah5Iy5jFDZ/VS4BpG7BspHHkuXOlNsZeClQWoh3jhONeCa5zN9MXVgSatrW5IORWX6xoFuamnePE511y8eJhLZVuWFQSQfXPSymPUEwIkxKyQ3h1UGf4yToyAr9zEFs8Bv4I54wRw2X9Up8/iPSZY2ZQW+NNgtGbn/9M5Gryv5vi8OMroB4Puv+1S/ZgGFhnWzJr/eJQ/9tLXnv9vLwr03HOR8Q8E6EPS2N1yDwEQzwF9AE772xZLew1tzjdmwUWxy0p/m8ChabNY6twmJ+QnhSM3FR9AWRYj4nZuGu4tGWE74hngUe9BDmZ98+9M4H+QrztodA+TJoIm1rUcu4+x5mmq0sthODPyX6NaE81gx96TEDigDaUolVpidKy96tkY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 19-08-26 11:15:52, Ye Liu wrote:
> 
> 
> 在 2026/8/18 09:04, Song Hu 写道:
> > On 2026/8/11 11:36, Ye Liu wrote:
> >> --- a/mm/oom_kill.c
> >> +++ b/mm/oom_kill.c
> >> @@ -230,7 +230,7 @@ long oom_badness(struct task_struct *p, unsigned long totalpages)
> >>  	task_unlock(p);
> >>
> >>  	/* Normalize to oom_score_adj units */
> >> -	adj *= totalpages / 1000;
> >> +	adj *= totalpages / OOM_SCORE_ADJ_MAX;
> > 
> > One thing this line hides: for a memcg OOM, totalpages is
> > mem_cgroup_get_max(), which can be below 1000 pages when the
> > container limit is under 4M.  The division then yields 0, the whole
> > oom_score_adj contribution goes away, and a task protected with
> > -997 scores the same as a best-effort task with 1000.  The -1000
> > exemption is checked separately above and still works.
> > 
> > DIV_ROUND_UP(totalpages, OOM_SCORE_ADJ_MAX) would preserve the adj
> > weighting for small limits and change nothing meaningful for large
> > ones.  This is an edge case, so probably fine to leave as is -
> > noting it here since the line is being touched anyway.
> 
> Good catch. Yes, the truncation for totalpages < 1000 is real, 
> but as you noted, it's an existing edge case. I'll keep this patch 
> as a mechanical replacement and won't address it here. Out of curiosity,
> are sub-4MB memcg limits actually used in practice? 

I have seen containers as small as 20MB and they were suffering from
quite some problems - e.g. charge caching on different leyers. I would
generally discourage people from running containers that small unless
they exactly know what they are doing.
-- 
Michal Hocko
SUSE Labs

