Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8F4E83EFA
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 09:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327AC6B00B0; Wed,  4 Feb 2026 04:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DBC66B00B2; Wed,  4 Feb 2026 04:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D0C26B00B3; Wed,  4 Feb 2026 04:02:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 089786B00B0
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:02:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A41461A0711
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:02:39 +0000 (UTC)
X-FDA: 84406183638.15.AA17798
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8F77240011
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:02:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GLnF32ao;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770195757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BKvdMgbyHAEo+wOrGBnZb6vr7blKztbePG761zDzsA=;
	b=4zEWqeMQp2f1cIF0J0Xwm3BGJ6YYl23ptxdfcfkrVj1Rgf5EgQ7xLuGvYbsge2n1mt1sT1
	H3u6LUuz75XjbnCEH/ZWSBsE6fClaLyAmmqR20xS8VTQXir/D6NZHWGyifF7Ws+iLXC/OX
	moEkKin6xZnHLdu2hkP66VDxvZmUXHY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770195757; a=rsa-sha256;
	cv=none;
	b=ZltTxpcdTiq7oL3VpkBDwy6MLb2FrCmTyTLp1JZndo9gaKvNHNhNTi5nkyzskMy2YiS+3w
	BHAUsF0bGXaZkXWJiQmhaEPG2+oOo+9meXSs99si5pvVmhxSspyW/6Vi7urZTlR5VV/UzC
	iNT8V1LZqz3K5tT++MAztfa00ruFe5E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GLnF32ao;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4806f80cac9so36367865e9.1
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 01:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770195756; x=1770800556; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+BKvdMgbyHAEo+wOrGBnZb6vr7blKztbePG761zDzsA=;
        b=GLnF32aousD3NOwQQWyFgzDE6qUNgk7weLeV6JgyBgJQcb2Jmsl7TIZPKnu3H8vroB
         6L+tvfB+g01Be/sVr+J0Js81zuo0mAJIs2azZv4vKC+7Me8wNoc1LdM+JkTmW4Xg45i3
         R9FDJqMSe4JylKdB6NPSXbjQs346ng1n0A7AXl0ujLDKs42wy9P2zT+0ma90FoEJeaK1
         2CRo3jMrIpO4oqVhFUOjo52ErwtyBHv9ggpooHCVDBOKG+joE+c4Mhop8zjxTOmA/53M
         OxICjfL8CuhWGvZEd/alDVmA0RZBR/nFuGBBZaXmCKhRpvGGS3ETtRp+vHbicHoxgYTr
         hB8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770195756; x=1770800556;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+BKvdMgbyHAEo+wOrGBnZb6vr7blKztbePG761zDzsA=;
        b=v+e3EAFIgS2VtHgL/FvWElEU+araqRN+oOAy3orcIAHlXQ8vROgiThH1xUioMpdV9/
         AK8YxROLne2DHHOERc/An4b3wnfGNqb5dyPMTf4bEJ9EXv/hB3tf6FTimwvpRiDlXPHB
         sqIXJUNdndi0pMWGaVG+jBJ99ItqiKuAUaFYX37pDiiWwh5v4B5izFqJiHT+KSIENp55
         i0uXcCvOVUFZbDCMsXR08YSsbGsYAofXTKG/oO4fG7RU9SoPDYn1e+j7cBTst77XIjjG
         31jktRq7IMcmut92VLWvVF8/pg0Fsxup6D8P0wjzanvaxNl9stL0YbIWjRRFQdl38r87
         IpkA==
X-Forwarded-Encrypted: i=1; AJvYcCWcStRobiueAAj7UEHi8hlrHthhauElOxGMiJUsHH/NptR1KRT69Js/gGH1wbjhSl80CLb8nHF0ZA==@kvack.org
X-Gm-Message-State: AOJu0Yx1Zjex8JSQ7czPkrxCvyR6h0AaoE9VjXokpbCd/pEQqOutHV7v
	pXl1U0YjSS63Rny0iXBt/UvewuIK7jSaLTl+s5YMy0L+nEJosHg8PvWN/hLWZzreyCo=
X-Gm-Gg: AZuq6aIDzVJ4X7wxKH8PDVX1Ah5tVdBybKtgMXPmaMI1DOONI+8IIMmE+IEAtcjJnN/
	YwSTiVwb/wic7rCPOiPlmXs7+bLwcU1Cj37Xs5bphmMhGNmSWvrj+wtcKHsPuXKxM3YCgM8XErg
	kXbXfn39LxVnbdNr4YRAiC+UinuHH9DUFjG9PVsSiANsPNBxA/4rteWBzINOHzGLTNaufDI+kTH
	W8YwLk/+iF3OpeeWUxVCgJNNM4v6tCk/5BLGEWWoXyLkHRyaWl3+1Wc9+sGDbcz/zEHmwNxPH6f
	kqWcOoA2X83KG8ioHxV/iOe1HXqY5XFRooOhzwlmt1d1qRsCrCYKax72Pqh4m+30Zp4hz8anFkp
	wX3aqFKvF52Pj4ab5wpq6hgOjKFLeMvZhiSO+3xaUCeIVjsA1HC6JdduZUyLbyhqxEb31DXkrKJ
	wvAEIENmWn5y+Z54XyGXYsoF/7
X-Received: by 2002:a05:600c:34cb:b0:47e:e779:36d with SMTP id 5b1f17b1804b1-4830e96d019mr26114345e9.23.1770195755513;
        Wed, 04 Feb 2026 01:02:35 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4831088d318sm50023575e9.10.2026.02.04.01.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 01:02:34 -0800 (PST)
Date: Wed, 4 Feb 2026 10:02:30 +0100
From: Michal Hocko <mhocko@suse.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
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
Message-ID: <aYMLJv64GOh7coMK@tiehlicka>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-11-roman.gushchin@linux.dev>
 <aYA4pH_nIBZ-ZhLL@google.com>
 <CAADnVQL5g8imKNGbHGQ4HA8_qNT4MYwM8P3aCTFUG7uwiuTeuw@mail.gmail.com>
 <87jywuwumq.fsf@linux.dev>
 <aYH21HhwNvWnFB8O@tiehlicka>
 <CAADnVQ+uF4cTVYYOYBEDWrkLXJJkru_FaRttFskHRUpamktMJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQ+uF4cTVYYOYBEDWrkLXJJkru_FaRttFskHRUpamktMJQ@mail.gmail.com>
X-Rspamd-Queue-Id: 8F77240011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: u5pjqedmz8iqtxpg64wt1r5so1ajnfxh
X-HE-Tag: 1770195757-351796
X-HE-Meta: U2FsdGVkX1/AQSYGXZZF3sxrgXUTtVvHURY9m5rg1sx8beJ3hR8Z/br7ZGqjERtJjqsN25e+k1xNOCrYoXgP4tYIpQHc/623Rk9u/nrRxZOiRy/8PikIH29mNdH5IoLVZGWHW5PbX8WgV3A5wkoWFSEqxEmGf8uLQPI4QuBvhKP03EarsYfeySy06hStQE6dqeIqdD9vBqwynabMLkQb0QfS6yulisLzuzKqRvXGwh+4NPWx8wg3reXkVYrJm3i3eJpR3pX3Us95TPbTbQ9fNWX0HrWbrP2mcVYmdARAbkEXb255LNyyw8F1+eRxBC5ev/fo2MunxAbJN44hA8SgFIBjPqL/MBU6Bn21Fa8JPUnQ1mMLu8SygjNOzeOs/J4TmGuQMDGZtlM7LwB0j12ecPYjm07qRqj2plTpA5eGTS/Rt30hOxjyWhaXuYQmAddQrCHjG2RARdKFjRnry/wN5X9eAGKkG8fZ8qGzAclJHKVhcihu5ptou5jF+jLZh43gvQux/9r+/XYBjQ0ws4KpOvtNgQvGJYyi0hA2Td/keJ6w/awXBClUNbuJVRT3RvecUdVjoG+jpqlBYWgAopgcVFNy3bik5ZNF2u6ITqcRU+iAndm8VheEhKBn+qxtiVnJqtSiTxqUkxRdbneUBXuW3QFDa1R1gmqms4bHHwC9vV/M3x5TItZlzWCHWYR95IeZs6f84QOEADhA61oO1egvFudvbRG6UWUIO6M3YmrPoj7jA9dKSwW1W6yGrk//vr1rv3K+fC0OGCUny3RM4rSsU4NIvdAkxFV9RE8DP3nv5jrQPeFnlOOb0js0UipeAFqFPVmCgw+G03TGFJ1YShcNhAge5h7PaF/cjLVBKFTZp3mJ+Cd5UH2ofJS8LZ0kZN7Y6jrzp6bSBIcBg3sJd6d/k8SDe5XFEYuuRtFVcfNhAGdtWeORaHSPG3H8O8fsu5moZ2n4wsCFqmONTbQ+NvA
 s8IJujWM
 5FoYfWsnitUm38Mxbe5OHZ2EulotpJTF82juLPUacr6gwhn60iW+R6ZoXUQkOCZqRCxmjiQQFRGZGatLJY+9lHNnqcDWTpeckL2zCopSxP7ub+QxfhuLSmHWZtY/8hqXxC+a4EHJh3T9WjHf3P9cQhuLd+dmoVuGoX8wpOyO89AzZ48oapHZluXolA7U9ilg7Q5AbbMmS+mTNhhdRRvMo7BAu9BRaR9wN28XCONfwLfsHWT/zj6uctArJe7I0YgcXSC15Oo90DIV6LBJ+xU2RAYVCAKnakVRJ1rsbIXNtOlnKyKm3HYTc1sbVvh26BZcxx4lIaXgMqZulAwoUaJDF9JnBIKg5k3F1dmpRX0Mf75nQ7JasXOl+bY8LNF1uPA60rtPMJV3Jf4RL9wqQq2J335yvuGvvNy6R/9vuxtldd2bjwfouXfMpHZe5/rPvS5VCDrxxq3GcEWFMb6Lc5POKtSuf/+FsT+09kaum337OlCh9MX44drUYEUFiSrz5639BcI3lvT05p/FeZIFBi0LnfJa9xqPTUF9Y87CcCHOGyqpqQt6SkXXdRq3Y9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 03-02-26 08:31:19, Alexei Starovoitov wrote:
> On Tue, Feb 3, 2026 at 5:23 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Mon 02-02-26 16:14:37, Roman Gushchin wrote:
[...]
> > > Michal, do you feel strongly about having a dedicated kfunc vs the
> > > direct memory read?
> >
> > The reason I wanted this an explicit API is that oom states are quite
> > internal part of the oom synchronization. And I would really like to
> > have that completely transparent for oom policies. In other words I do
> > not want to touch all potential oom policies or break them in the worst
> > case just because we need to change this. So while a trivial interface
> > now (and hopefully for a long time) it is really an internal thing.
> >
> > Do I insist? No, I do not but I would like to hear why this is a bad
> > idea.
> 
> It's a bad idea, since it doesn't address your goal.
> bpf prog can access task->signal->oom_mm without kfunc just fine
> and it will be doing so because performance matters and
> static inline bool foo(task)
> {
>   return task->signal->oom_mm;
> }

OK, so my understanding was that BPF can only use exported
functionality. If those progs can access whatever they get a pointer for
and than traverse down the road then this is moot from a large part.

> will be inlined as 2 loads while kfunc is a function call with 6 registers
> being scratched.

performance is not really crucial in this context. We are OOM, couple of
loads vs. registers will not make much difference. It is really more
about code writers what they can/should be using. OOM is a piece of
complex code with many loose ends that might not be obvious.

> If anything changes and, say, oom_mm will get renamed whether
> it was kfunc or not doesn't change much. progs will adopt to a new
> way easily with CORE. kfuncs can also be renamed/deleted, etc.
> You're thinking about kfuncs as a stable api. It's definitely not.
> It's not a layer of isolation either. kfuncs are necessary only
> for the cases where bpf prog cannot do it on its own.

It is obviously not clear to me where that line is for BPF progs. Where
is this documented?

-- 
Michal Hocko
SUSE Labs

