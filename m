Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EECCFF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 17:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0196B0088; Sun,  3 May 2026 13:25:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50BA6B008C; Sun,  3 May 2026 13:25:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3FF26B0093; Sun,  3 May 2026 13:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C31456B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:25:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60BE314094F
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:25:35 +0000 (UTC)
X-FDA: 84726785430.29.A52F89C
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7C340120004
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:25:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MPM02kST;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777829133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8o9FalgtmoPunAjSjBWUFK3XFWYc8vHIp7TS6crtgE0=;
	b=rbl8Wr4Eb3akU39sIzcPILVR1wDEq0fY0QKG8pqZlpX9//0OefoZ7LELumECAoCU9gqRhf
	r8aAD85oLY8Ony1Ry2L1Oco+gULUzEoz9A+nW2Nm9V+7W3SaEwaa5/ZdpDkd+vkxk6VieF
	Go4IqFTS/l1irS76HSt5pHTl1/NG3R8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MPM02kST;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777829133; a=rsa-sha256;
	cv=none;
	b=yqWYhvs1T2SgBbFEkav3QamkAkNXNmjrJYBhHGSvMEjcKnxBKIRH6jFgULtQarCBujfKHU
	CZznsxWYX+bMu9Z9zKsXFjd+AH73nTLApkv0yCh/WA/vw4s1abuXsHkPvJJJn7brWlyug+
	JFHjxPMDN1B3DKrWinG2gX8rwoLIxhQ=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-824c9da9928so1428388b3a.3
        for <linux-mm@kvack.org>; Sun, 03 May 2026 10:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777829132; x=1778433932; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8o9FalgtmoPunAjSjBWUFK3XFWYc8vHIp7TS6crtgE0=;
        b=MPM02kSTqPXAeO4n8kCdDKULEiZIuJsnVpuHec7FZhiIbIJlrt8oL2EAiUfFLTKydB
         IEPdnmEoCKagAlJB+5yGKRozmbQeiG+U4EU5pdbKh7VEnAf9/wx7LYH8se3c+fJytbTy
         Rr9dfqNdMS+6ZG+MvOWmYZRkWPfKKM+KUIY+tD5bo/LuJ9LvG24YjzCzeOJdOLkm5NoJ
         vypUtyLcbXelLBBjgYGmoruJMQOI2aWYoULgf8WXvGtPlw/Iiea7RBO4C53t0EAXTEpZ
         RLWSOCBrRV11J+9I37LALjpsm68mOehU2s6o66npqTXdW2P7axzOZwtTZ5DpDW4rXfNV
         0G9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777829132; x=1778433932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8o9FalgtmoPunAjSjBWUFK3XFWYc8vHIp7TS6crtgE0=;
        b=pKOwlp8T7I5h6PBD0rIyRN8g11wNgevkheoo/rruUCreOG5sDUC5S+otNWP5/Iegyt
         wmdib77zO1tmsT5FoZmJpTZR9SY3guW+I0okLEH1q1qNbGXtR5ChILJQzPgxavIHh1SB
         9gE9PQYohA5AKicNoQG+VfswvDN7sVw7wfvSfKUtjF8a7l+LkFXZ4WKhNvscT+4WarWQ
         pLVxsiyDanBXWLDCbcnVkdl/0oUsAwJ8N6j1b7D+MfWwbYiM9Rjh26U0v1sdgCqWp59i
         3SBaH6rpGKcyFs6DYkhTZ6Fl/JWbW52fnHFFR4Elut66akZ6poUS3TZW8sv3FEnhWYRR
         yjmg==
X-Forwarded-Encrypted: i=1; AFNElJ/3fFY+nmy5e/tqEMOsNHeGNQn2TXg4jVo3nMFIGxp/YETUjn+Bs8YfkLbgir8vHV1twcfmP45QDw==@kvack.org
X-Gm-Message-State: AOJu0Yw8BO4B+90te+HTc0t4VLvZcfJkHylHDsyOQGMLei3SgBVwRmjF
	zLItspeiMIDlFSEWDYFdSaKlmx5IN4eu78pap8T5DiVSXoC1q9laI0ZG3GpQQDu7yhfCOw==
X-Gm-Gg: AeBDievfZJcOx3O8QN+sfrK2A/C+opD3dhNByczdSKFl4lGwEkdd0DXQzjV6QOf7nGN
	VWLQRAV+zfRlHfhLEMumYh0Mm4+8xd7cjnnV3i8DEtDKpgv/cpahJcHVKCju5nr+doRxYVLDWGr
	RNXrv69NqtomFjT3vGymUQuYm3sHLOAhc1p1BWErJswvDRoB2uGUB4aQChDUoTYIyUEemDfex+D
	JvVnoHqG8YJb2l5XePn6B1spDZbWG1knZ4WTFIiX3Hi0/8gZAccrdXK39ywGR2sfA+bA13Xi42T
	lbMdjnyzc/XbIGYhLLPgabY32xWrcfscztXqlbSYcG+9E0ogr9VlglWiMyLtkAq3aijTcVQaaae
	BoakOQ7YZj3FWqWN0h85faztrgFNUw7DJL0Ff1WrjVgTeEr7/uqXclj351fRK/2i62Wz+VNH05t
	uMEDCFbv2DWCuWGHhzPqjMwQLYj14+MWA015vpOS4Q9DEs1yrz7nXM82Gv2A==
X-Received: by 2002:a05:6a20:72a7:b0:39b:949d:6078 with SMTP id adf61e73a8af0-3a7f1a1d68cmr7007462637.6.1777829132163;
        Sun, 03 May 2026 10:25:32 -0700 (PDT)
Received: from localhost.localdomain ([114.231.84.174])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515b1fe12sm8672423b3a.47.2026.05.03.10.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 10:25:31 -0700 (PDT)
Date: Mon, 4 May 2026 01:25:25 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	lsf-pc <lsf-pc@lists.linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [LSF/MM/BPF TOPIC] Using BPF in MM
Message-ID: <821acd4c-d443-44d0-842d-26ff45e2f54d@gmail.com>
References: <7ia4o6j4c5y1.fsf@castle.c.googlers.com>
 <014f3c0a-7c6f-4f64-95cd-b7b69d804880@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <014f3c0a-7c6f-4f64-95cd-b7b69d804880@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C340120004
X-Stat-Signature: 9o5xdahkwea7xps3a5qe6b9f4w96nks6
X-HE-Tag: 1777829133-698569
X-HE-Meta: U2FsdGVkX19pB1iiE6fpHwVltPNTyk/DNqr6ogPlgW7r/bHCwZ+d/Dr4MsO8rdC4uSP5afbIAUZX/FYgr9GV29hAYHwrb7S3uwZsjyZlVNOoRAR61bbvnPDZpda9uRSJWnoSypEEVMh+tjX1ijFn7hL2t/3UasFAmdOBvyJQSht+la1Svk1P2uWnhZ7ea1el76HE95sD2U6qGZaCW3SG/ukTaDFTouPzaBVRxhii/gQfsO2zfG9kjz7esO+rV8t/xzpq487K9oAyecPFv8/+2mj+wZGMow4upwnSkq8CWQtFzvU2ZMjOpaR4WnEjJih44wW/5WnyuThO/3hRt16Sbc9f4dikb26d7BzU61bf0G+vdHIiP9m+Qj9PGHQdeSeNEUqNE2rI0eOjet9NdcCufYj289bxe1/+9/zyE3hxVurefuvfsfWafoc9q2NyabauDtNosvOhCdrytxCLJ5HtPd1CKmFRn0dy23LqRZgj2JXZbl0g4EA67VJNla2wMBKpwDJyRrnhJJInZ2TrJl+JNpm0wSN8vBMrlLB68Uk6Mc4f/OHYb5DMYLlSbpeQdLHwgjTMrn3eTS3FesKjs1UwtDnShv4nR3dIdUaZYp9LJkBcEACiio5X78CORKfEuoDkJmUOz62+jTsZHAP4JkLW9aB6NbkMoCpjnKzV9yjw/EXMG71af262Ad8QmluVgpJqaIm+AQ1Yh7E1rRN2TLke2itDGudBzl+pEeIebMim6ZrzElcmJ/04wCFLFYV9WKSlzV/0FMrau0woxQqFKAaIe65jJj/pPxZBWApZomVz4FPj3nTxNLdqfbZXRef1x+a3TB/eR6IbVLcEOxfJrFcuJbFDMaBPM7yY5tqimviHf3Et69F2tZQ6Mmy0EFfq2iNpSjKkzzWdR0chQIZO+h02ZvKH4JfkDuE3Ja51lz2iXjvuOFTsNJYcTnRWBvg+VQ/xZcLbsoMLNVVkB7P0lGl
 2xTXHOWa
 WBNaZZtpRwS6VDDayqxlRHGETRhBRfeauXhbVFrQk9iik2bBBR2ZFwBdq8VLA1HvsxZyTT2L9bNC+VxUBDTwKsJkWxocB2rpY/3iFssqn1CuoBuSScRvziZvgwir/RHpGgMg1rwV1YXAtXbpgNlTyvK7SKtOMbMbUuCrxakOR+LVsxsJ/AeIWU7FYLFyiM71GnWjqxpd0Zl21PSD9z1Qa1Dy7mJqADXUEPsVUx2BjF465k6ZsROTyUlR+Je+zyxqB2wwD++UcgHJ/Y4eJAZfUpoc8gtlmhxKIijdh3TlN321ab7aK4hmVcIneNY7sikI1UukoVbg2pFDO6IHapSxxrzjFDNtrapvJAOcGEU3hrUycCLWaL8dWC0wnfTM3FMSFly5jWfkjoyPlYfC9sJlLCuu5uA/paaR0ybohhd+pxKzxcVs0MsxaRpr7s8Vyuyvk1sX7fJk9aDAayT3fafsAGC+PqsbcTtbxOqSzyUFiUQn+ghLb3VvsJcp0g/ZdzphgwJ5ViKjnHDsIlY0IAlZ5zsvGRVS6j4WOdCV/tVmd/AQFmSxlKs4558JjPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 10:12:16AM +0200, David Hildenbrand (Arm) wrote:
> On 4/28/26 01:57, Roman Gushchin wrote:
> > [LSF/MM/BPF TOPIC] Using BPF in MM
> > ----------------------------------
> >
> > Over the last decade, BPF successfully penetrated into multiple kernel
> > subsystems: started as a feature to filter (out) networking packets,
> > it captured its place in networking, tracing, security, HID drivers,
> > and scheduling. Memory management is a logical next step, and recently
> > we saw a growing number of proposals in this area.
> >
> > In (approximately) historical order:
> >   - BPF OOM
> >   - BPF-based memcg stats access (landed)
> >   - BPF-based NUMA balancing
> >   - eBPF-mm
> >   - cache_ext (BPF Page Cache)
> >   - memcg_ext
>
> There was also the BPF THP control.

Hi David, Roman,

I submit a new series "mm: introduce mthp_ext via cgroup-bpf to make
mTHP more transparent"[1] to implement BPF-THP, which has excellent
performance data through stress testing. For details, please refer to
the patchset cover letter.

Although I did not attend the conference in person, I have been online
throughout. Please feel free to discuss any latest progress with me
online. Thank you!

[1] https://lore.kernel.org/linux-mm/20260503165024.1526680-1-vernon2gm@gmail.com/

--
Cheers,
Vernon

> >
> > There are some obvious target which haven't been covered yet:
> >   - BPF-driven readahead control
> >   - BPF-driven KSM
> >   - BPF-driven guest memory control
> >
> > Despite a large number of suggestions only a relatively small feature
> > (query memcg statistics from BPF) made it to upstream.
> >
> > It looks like using BPF in the MM subsystem comes with a set of somewhat
> > unique challenges and questions to be answered.
>
> [...]
>
> I think you are missing one of the most important points: Unclear ABI stability
> guarantees.
>
> One the one hand, we are told that there are no ABI stability guarantees, and
> that we can change hooks (add/remove/modify) any time we want.
>
> On the other hand, as soon as there is some ebpf program out there that we
> break, you can rest assured that there will be trouble.
>
> In the area of THP, where we don't even know which hooks we will need long term
> and how they would look like, that was one of the reasons why the BPF THP
> control was rejected.
>
> --
> Cheers,
>
> David
>

