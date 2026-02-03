Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE5DE87829
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 13:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DA9D6B00B6; Tue,  3 Feb 2026 08:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288606B00B8; Tue,  3 Feb 2026 08:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1698C6B00BC; Tue,  3 Feb 2026 08:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 059866B00B6
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:23:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B42F059146
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:23:37 +0000 (UTC)
X-FDA: 84403212474.28.F3A5004
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id AD917120006
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:23:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SLvfbpWw;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770125015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9jKCMLhYnPbhGwJQdPwGF6Ru9Db2nKOSg989VKRbuc=;
	b=MoB740z7zDgqmsdh7NNiRl4XiXnsj7KYdkOcWeXvGVQBkrh3mVJv2w/Sfpa1b+A6RPHXnN
	Lw2KG34CF+YhnSuvpcLvlyFcwYo6rpusm5xMSZeps/diyKeFV0Nd4klZc2wJ5uL/EkPIAd
	YhNMf4KYU2DWgtzOEQVF/NqvfdzEQDU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SLvfbpWw;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770125015; a=rsa-sha256;
	cv=none;
	b=bfE+9LlI2w3F2wVyUigH7HhsUiex0T/Gwdb5N+lEpADktYqwtNKcz8EdEh5/qfrEffJk6w
	xJVK0QsbdabrPEfw0bNH4l5kcGavpY5+onSzjTFL5AIa1F7ZJQaqBMcMAUxS6SMX8bW5mK
	MwAfL9CBo/dlnnY/H/+skJ0Xgbk9Uuo=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-480142406b3so41782205e9.1
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 05:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770125014; x=1770729814; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X9jKCMLhYnPbhGwJQdPwGF6Ru9Db2nKOSg989VKRbuc=;
        b=SLvfbpWwB8hpCQEYWYIBFue6oyVK3QfAfzAlMQh6tUgB9Q/pJnYDFmFDCOAx4cAcIB
         It293bZrsFl+XkPFcCHoStWT9FmcUOuJIvpbTdSMVtDWdmuXm/xjq5n+KS7bSTR4cZSk
         P3TC6JylhagidP5jIkbOCZBjQLEXNHIY9Fc9nVrdq4ktnuAmo73YDmz+B1ZRBBrGIhIt
         T6QuFCIK/0f3e07wJv0Z03QYKau8ctdGlbiuqCOGWfa004veqt2WPaaQd4al06vIMLfE
         o+G8BZ7S0VrQ0O640fcLaxhBoZuUfzzVuYS3brS8URRhTHFmo7UYGenTKLxHJ0y3nRHT
         WibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770125014; x=1770729814;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X9jKCMLhYnPbhGwJQdPwGF6Ru9Db2nKOSg989VKRbuc=;
        b=sFDf78q9jBJlY2ot1YjgF3SVne3X31alEZSuTXYAk8j9ZYQsitPIiFLpJzgm12GWo0
         IcMlxrLzjW7KhcDCucuADIpXR2cRy3m1FsmRg0t8llbGHDL1ysRu/KKbXf37qToXGLZe
         bTaiuQLJJrenfjeGyaBd35Znv4ezOpaVgwyg1nbUCZYSHJlI8+SSbLdZk8p3leCMzujk
         K7zznVlJtBGdXne0/muP4bsVOrlWN575OCM8/TfOqy4xb49r9wRn9zheMtrL0efEa73D
         XxRs+Kv31b7BUVLaSwxZJYklQjgOq9ap6DzBHWLI3CvHAvEcNGteh+qPeKLLoT2hfM3y
         P+3w==
X-Forwarded-Encrypted: i=1; AJvYcCWYl86ocByJ3p0RRW4vMCqTurjOGkft3G5mxOP42Eed4pYR+nkZxi0rWesVIuKhQBAX1/KHjY6gtg==@kvack.org
X-Gm-Message-State: AOJu0YyprzZ5tFb83CHasF76YRxcw7Hxdwv3NAC2/tc86WMhsj3QwBgC
	lXutHgRKwOZnqM73wCmShlSQeoYMPwflR/EMDfoQwhcHYokAL5Bq+f7RW5D0ZpPE/+M=
X-Gm-Gg: AZuq6aKw4Ili9MUbOmMf2RdLnNgbd4YCxYXkt+tDUySx0WKQc3LskmhYvSOEFazeDMG
	esKjFgwsKXc7B+IAq2u3IiePgbX0qQ4YptIMguKty4sxOlK3Mn1huyPeh8X85xl3ufK6DI4iBuc
	naAdHrrQ7tsLG+6ofPt0GfTRBg/GNM46+oYr6W7z0croLeAX4vttpq+fDKHz/6H1yyNCHI58kRu
	31sPz0WYH9ddQsA/A3uasR8kTcYD6KznAQ8CJdcTiof4dt3Zo3kFJ1+jEifMFFidjwxjA/hzG0W
	VV/K56hmTY9a9qVqahRXQwxQuZkxCluipKvKct3H0w19T4wuDWlMuQZPzRv0inDq2oWZT1kB4A2
	XYTGTNLtiHoJiOgtKXWNFtc0W4LmzEDYi+fn5YToXvY+m//U4clqFUWjQ4oDYyk0R0CSa+ErqfR
	8BDKQO5UlNGgGHVPb/E8fI6Eim
X-Received: by 2002:a05:600c:a087:b0:479:35e7:a0e3 with SMTP id 5b1f17b1804b1-482db48f2ccmr215249685e9.30.1770125014093;
        Tue, 03 Feb 2026 05:23:34 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-482da903a30sm149018775e9.1.2026.02.03.05.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 05:23:33 -0800 (PST)
Date: Tue, 3 Feb 2026 14:23:32 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 10/17] mm: introduce bpf_task_is_oom_victim()
 kfunc
Message-ID: <aYH21HhwNvWnFB8O@tiehlicka>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-11-roman.gushchin@linux.dev>
 <aYA4pH_nIBZ-ZhLL@google.com>
 <CAADnVQL5g8imKNGbHGQ4HA8_qNT4MYwM8P3aCTFUG7uwiuTeuw@mail.gmail.com>
 <87jywuwumq.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87jywuwumq.fsf@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AD917120006
X-Stat-Signature: qkt57f9xztzu4h9zw3ozsfmg7k6x1gg6
X-Rspam-User: 
X-HE-Tag: 1770125015-954213
X-HE-Meta: U2FsdGVkX18dIWXdg1OYxSW75bF5wK8O93TIoWexkzrPofUawCqUNRrGRvIvVjA+50szAl2fFqz4nbBH7f8scndYA1W9RvMUXFWTChisyahd2/LYIuCJczvmk9gykzNvfIOUuEHPwgZ7RMsKzEJb1R2C+WPtB1PjzqKHSL2LORJ2iC3hXAsUe/Vjc8n6Xq6x0l3PrH4kB7CZw86TiSEBxtWkGS8Nw0KtJpbVB/lgOkyLz/kq2NfHDOI5heEe2LbKbsmvml2b7j5PK/SaFzUyFLPv9+qyx+J26T0ecjRD5HT+kqf6kngxldGPUM4DXRDTEpIJKClb6pmI/b9Z3I8K4+hmtijafTmCBKonc8xcMq+vExxq6AHMkB9e73ugZAXXV27DSKdlcJLJsSyx/sS63UN8vrfV77lEOqDNwe7brsd/lno3/F4sdH3CCb84lgsJuvIZ3EI1FqNIz4GVsbt0X9NZ8LOOfXeBugRWGxcYqDzMdZMvRoOxyWnayrlcyXTg5hbXooEfxUJ4AfTZbe93jR735dbbnoSI7LsUKnt0AE4JzIj1uUArlu5giR6N7/Wra56wQtoW1oU1px2lyqrN7zI9lofe2Jh7rSsHxQMA0JSymYAowa5qxfc7SsJ9OfO+inlxuFVHDkgVPy+Ol5iVTwmJxFuM5mxLsd16ir/X0V4aWhCG6xq29t9OhMzuduXvTe7SI+Bmkr4NbLcrCzEo6DGUmo9UOUIvMupdJGcHKrXmPy+SURAmndsCPB++M1Ch2/jk1h/YtKPinSFOesJdqK+lEJsotCsv1Cs65dEJPZI/5//UH8pDf7wOzA1ZnS+kFdvFaCqDVPoUZUALOiVYkU/UvV1HOVuwO+lbaW2qzUu+MyrSkHWJcu37u1ZTtE/tjIoOqBJkNmjDJ0dTkdOsBvdwoQqgyGgZjnPVXDy+X1t2YZDDvvBBaDUsUh13wzWDKh5Pxkqa1ahdaREVUjb
 hvisaitr
 IfkcJEU66+uKwDpRSYK94LpKqS2Dqno2TrLNeS1Vx8ugDv9aZgI/9/km685OUdEO37oLIihgSmYU8Kdg559ueN+KmpJb6bNZMlJ1MZ+sFpcIqUHmItQOJeulrSL8jXQTzTVMQKSZENyG9XF7i7yGEj6QR0E4V/9wew4Ths7cgbejWyslEwYvkPSan8dWcioa+Nfg224RefBjHQ4GDPi0xTnSAYvbqx7kbE10+lYTMI+fj6UHfIGraLklaSNyx6NH8R+fai4EVT3tNys5UsP5q32v9hnRZG6evxcLBQSpulm+Ca2daRKfG/u/5/VtrqH7QRhyiCHeWpIMUYbiSc6GrVk+R9/Y+9JVLl7FWyOuzePznU2vm5UAIv86k7PA8zOvjAsrQU0i+/DWlIfQPNB8/gOekfeUKZaWvN0yVCTbYbYdux7RnjREZ4c6fC0swNfjK9ShLPurG1Ej8YDuscHKVw05bk4vD6wsrCENteWN7AnTohovhhA23dhXvHOp//wy0ZWchbG8SAaamPwSMhTIC3ds5kYS/2AbNzOhGTVL1CH1E+IwIh66hFUDDj02Ml8Bnrjg75f9Tc2j8emeO9I6KC+gdlN67AqaxEK65
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-02-26 16:14:37, Roman Gushchin wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Sun, Feb 1, 2026 at 9:39 PM Matt Bobrowski <mattbobrowski@google.com> wrote:
> >>
> >> On Mon, Jan 26, 2026 at 06:44:13PM -0800, Roman Gushchin wrote:
> >> > Export tsk_is_oom_victim() helper as a BPF kfunc.
> >> > It's very useful to avoid redundant oom kills.
> >> >
> >> > Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> >> > Suggested-by: Michal Hocko <mhocko@suse.com>
> >> > ---
> >> >  mm/oom_kill.c | 14 ++++++++++++++
> >> >  1 file changed, 14 insertions(+)
> >> >
> >> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> >> > index 8f63a370b8f5..53f9f9674658 100644
> >> > --- a/mm/oom_kill.c
> >> > +++ b/mm/oom_kill.c
> >> > @@ -1381,10 +1381,24 @@ __bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
> >> >       return ret;
> >> >  }
> >> >
> >> > +/**
> >> > + * bpf_task_is_oom_victim - Check if the task has been marked as an OOM victim
> >> > + * @task: task to check
> >> > + *
> >> > + * Returns true if the task has been previously selected by the OOM killer
> >> > + * to be killed. It's expected that the task will be destroyed soon and some
> >> > + * memory will be freed, so maybe no additional actions required.
> >> > + */
> >> > +__bpf_kfunc bool bpf_task_is_oom_victim(struct task_struct *task)
> >> > +{
> >> > +     return tsk_is_oom_victim(task);
> >> > +}
> >>
> >> Why not just do a direct memory read (i.e., task->signal->oom_mm)
> >> within the BPF program? I'm not quite convinced that a BPF kfunc
> >> wrapper for something like tsk_is_oom_victim() is warranted as you can
> >> literally achieve the same semantics without one.
> >
> > +1
> > there is no need for this kfunc.
> 
> It was explicitly asked by Michal Hocko, who is (co)maintaining the oom
> code. I don't have a strong opinion here. I agree that it can be easily
> open-coded without a kfunc, but at the same time the cost of having an
> extra kfunc is not high and it makes the API more consistent.
> 
> Michal, do you feel strongly about having a dedicated kfunc vs the
> direct memory read?

The reason I wanted this an explicit API is that oom states are quite
internal part of the oom synchronization. And I would really like to
have that completely transparent for oom policies. In other words I do
not want to touch all potential oom policies or break them in the worst
case just because we need to change this. So while a trivial interface
now (and hopefully for a long time) it is really an internal thing.

Do I insist? No, I do not but I would like to hear why this is a bad
idea.

-- 
Michal Hocko
SUSE Labs

