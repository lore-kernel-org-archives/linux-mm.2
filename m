Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CEAFFD88D4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 00:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2606B0088; Tue, 10 Mar 2026 20:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7B0E6B0089; Tue, 10 Mar 2026 20:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933946B008A; Tue, 10 Mar 2026 20:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 723C06B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06452589C5
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:17:06 +0000 (UTC)
X-FDA: 84531867252.16.209AAE1
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 179561A0011
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:17:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RIjQfZnJ;
	spf=pass (imf19.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773188224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAc0Wu4l1JF/9CE3rxRioBbsVeC7GaknCsGWnSGnsWw=;
	b=Hq2PGq9+r19RVwO6PSDCvkll840MKsrsE/wLa2E1ZDUQf9t8gCO66GBXZaoMS+/CipfYC0
	SMWoWp5752GMV6FaKtrzVJjx6Fw1/ID1RD5GYjMW3p5mUTlfGNwW0R+7vxwJGyZb+qHukt
	jnI3MJpAEwK8PE6dlKInZs7GOccn7o0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773188224; a=rsa-sha256;
	cv=none;
	b=bUweoIGCezfRdnUPiDpN6AfFL3Inr8FEeLjnqUZQhFyl4wtbEtDglR8KnYy2gV15ZnDbuk
	0s8kpflQoJdJZyeKasj2eERR9OBju340aCIpfaqpeBpCTDjlOTIbX+lfVDlZ/KA2faux1D
	44suItEyWNUsh9dWzuI7IhJkdy8l3wM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RIjQfZnJ;
	spf=pass (imf19.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48539cbb7b1so19997215e9.3
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773188222; x=1773793022; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EAc0Wu4l1JF/9CE3rxRioBbsVeC7GaknCsGWnSGnsWw=;
        b=RIjQfZnJO7JXhihCVLHIgC4bOWVDJdRJqOLYqJAdtM3tmUb2fNbAlVdoDJqx5RGVoC
         JwCo6vnHcVPtHlASkYllrFbtyLuLG/Ch2jMSPMMkMSRpDcULR4NrV3MPMeEw5/zVe/WP
         eG1J0O4dagnYUTw5gwdyx1V0/JaZrjdu5EnbxoCm4ODtGYE0QpuaP8x6FR4RZ8DevSQI
         Qa20it/amaD0pn+XpqYhhKIMGoxEycXxdtozcSrxO+lU/bU90IKDS2Hj9qmpvxIVRNkl
         1HaOjRLRnXcKGTrHxj2AWQzlxtNClBIpZvjUHXch/m20RRjN4Sv9A1njMa8rPCzJnz6j
         Q0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773188222; x=1773793022;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EAc0Wu4l1JF/9CE3rxRioBbsVeC7GaknCsGWnSGnsWw=;
        b=RQuJ44+7b4nDQpjvzehbbwztKGWXlxE66xjvSJHvAMGODEiYiFy+vrRaQwSjOuBlHe
         fp82mO52/Cs7NvJes5aIcLBVCeGKV5jcSJWm8oQl+g6lvWQtuJsqQ9BpTJrO9547QisL
         XFfW0lKrpppQqi6XzEoB+gXeTIC+1W2Xgxj63WCk4dYTGkMW1NdyjrBpWgr2Wbv1qrrK
         OhkQab21uqWIWqKeZa8c549Lglau33aul45Y+brcrvnI/Kvbn9FLjuqV/gmt9p+AcYe9
         agio6eH7Nz3DmsYctaao9kvC6EVznfndhEZqVeSS6La62LMxBWE/49w0z6sEFyrLb2Lw
         W+yw==
X-Forwarded-Encrypted: i=1; AJvYcCWnwhFRU5CH3OkUh5vi5XrPxePjCJ5uudtn6oiSqy1LbVvhxA9yusqgfJjntlu16P7wfsnMzABx3g==@kvack.org
X-Gm-Message-State: AOJu0YzMVcq3DFfZjZxDEtCx3DYEz23+OVQAXaZV669b/apImB5vUf2/
	rOtTOIcJ1v+nxiI1wdTDTED6ukK1tNy3yc9lXL6YkhLebVHTSBqlhj4/
X-Gm-Gg: ATEYQzz7Hr2JGzHk1SE/FWjqaeCo+Sy7zsPJUb+ZxehS/8tLurRfFqcmnZAoAgmimRT
	UDULnfsWl99INdUS2GN/54BXJAixsqMLGg398OJu8Qjqu8vU2pdxELjQbGdMTEaObQWTTVPx5R6
	WKxKDM391vvRsuSXrqUGCZTggA32LolxY2rCxSg4JXIFDm8IZ+szip+/TK3euXXN6Nac9FhekLT
	sFgbrRBJufYwFkuHI1YQdTz2D2O9wLVAZVZbqZSW5FBt+79sPMXRP//V5IMkqLwK8d0oH9jS1GL
	GldR6dOeSYWSwMeREV6r+ozC76KqOkGhOUZyp9Dlfo7HSupy3alV/OlRmow7MZIHuqlzEYBkXmq
	jgW8Hb5X5s5Iff6TJCu3G0+xozMHTlJ/4Sm8ukEi4TDEweePDD7Zap4e9WUKW/WfKn8Hcl5Qw2+
	X9vqx1KtT38/2biuOyz0SCAlgD+ke+Kr3dKao=
X-Received: by 2002:a05:600c:46d3:b0:485:3a03:ced1 with SMTP id 5b1f17b1804b1-4854b12c404mr10656345e9.28.1773188222254;
        Tue, 10 Mar 2026 17:17:02 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541aa73dasm283494525e9.2.2026.03.10.17.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 17:17:01 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feun <boqun.feng@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush work
Date: Tue, 10 Mar 2026 21:16:52 -0300
Message-ID: <abC0dEOh3Ba2qI4u@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <477bf592-489e-45e6-a386-6b3fdb289c39@kernel.org>
References: <20260302154945.143996316@redhat.com> <20260302155105.214878062@redhat.com> <682380ba-c8f3-4023-928c-2152e934f8db@kernel.org> <aacGBc9x+zn1tluU@tpad> <aa25OmY7HlbU5kDV@WindFlash> <477bf592-489e-45e6-a386-6b3fdb289c39@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 179561A0011
X-Stat-Signature: kybctm5cdm34adcgnnug4g9rfrp43cym
X-Rspam-User: 
X-HE-Tag: 1773188223-387871
X-HE-Meta: U2FsdGVkX1+xAcjkwaEELvDUkiz2Us/FZ4z0bpz8PtSOt9LVzMhUtFRzKeTLaVVp4ONlBCjgPwtn6ikl2k5sWEf4CrMdJ1IaVLoI3vTjAd3D6ZIDmVpdIYs8dl4AHHcoloynrdV9Y7z3XBGaNXC2+98X+BJIofImfitfDFpGv3VDygdWbI5sXDxLC9qgkizMTFFK+c4Q9QsiuthSOFx73YbGAuXS7AhCc5W1uIZqeAVIWh2SXZAvFVb18AKoLrnCYsDyTYVLb1WfXFONZF/amF/LhO9t9UgGZOv5n2z7N8sS9v9DKRqhug2vsMrw9PETwyN71/VSsYmH86v6O8B4QdTi2E7wBsE/Pm2iQq77wJZhn/AXXrKkfFLTWDHO7gOE/QmQRYXvU/uO7P33EhkicjsnNGCoAwFfLrB2o+p63PhbKlohx9wCfscrnfpsi4mByDmKScCHWkRmog5Y++AhRtYBnoJwOryas/sCYRzs+kGUnAOv3YnHfDTDw+6GdLbyv1C67LeO8t13zkSqWbrxIVgvIe1YsFuVxP+GT4j7Q9MVYkq/Bmx3wF2nvL5dJn7v5vNyTwIP+5DzrLCivniV90MJ2wu9k4c7iaWSQeUAxmJprioOjSbtxlPEV0Emx7GLqPlEzxicPb3nBJOF6ArTOQUF2mG4Zq0JPDSTUnC4934fUNrEPHCRVBu9g2l/+pFTGRtMnRdFPTcyS+S+mDWp0TRQ0He+XYrixfGAw/XNmzBJ+ZQ+7MuGZvJ/n5dk0hSEtTz/xRWnT/f1oaY1qUHW2FYzhony/jo0g96tlvMeZUEoiS5PX/RSWwRJF7PEFr/lfKM/H1Mu+yD5rZ7/gQ857fmLQVE38QKpGFVNYIoG3X8g4EkAwBDgTiKBfcd18qQaNLfBmUZj2lwOI27ciW4mFNjXfW7K0cMQjbwbk6JJmIOMEPbOPf101M+QKNACJd2MYdr72vAX0s6r5t3npY7
 m3nWSddk
 8hngW7MM0HOiPPYHRM52S9TkA8qEfVCR2/7fT3OZPKwSsVvwaq9cmlDgBz8pZRSQKp4IDUDVC3WBOKOk3lFEfAgmHrcLnKTvs0x7LTPHaFAzaZsNF4t9Gwj4vNO+1qN8ZVMOl5LY8pYvLbqnskkg8BHjnwj6ehmiL1fq6nwFUI/CzIjzB2s4vMoExiuCYqhicyyqiuGH55nB9HKg+wunWTp7/9/i/h+cmdo57I+rnJCvvdEnc3IwUpMI7Mtqckop9RaUCzqxBn5YIztuuQbYQaIceF40D/a3NEjJ6om0GxsVAVdTl4ER+sWocXZKKX44QtG4A3b7Luatu+aM/oogYClTaM/KSxUsfpwpIPx7wlKFMWI9o3flSi5DWGAMLywAjtlH4hsuxxhbCJEp+J49dhyfksLo4PI7Wjq67aFXfFIecs/t7UGvhomLXgQ7FFhJvXhjPxrnJNJcCwrwMqKUL1ZQmeLdxztD1WwKKiU3NN2hnAf8CNEYxhF/Poh2DVUXTtyLaARmBUQan4ruPulWbHcwHRNkjXYeoHc7zK21aRKTY1lHg9tSmVSE0aRvKvx4r0lYdlzFyzFpQTl32MzK81Ydi+7qip3neJhSINhT21tJZOFceKB72fq4mEZDNnJlvaq5n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 11:14:23AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/8/26 19:00, Leonardo Bras wrote:
> > On Tue, Mar 03, 2026 at 01:02:13PM -0300, Marcelo Tosatti wrote:
> >> On Tue, Mar 03, 2026 at 01:03:36PM +0100, Vlastimil Babka (SUSE) wrote:
> >> > On 3/2/26 16:49, Marcelo Tosatti wrote:
> >> > > +#define local_qpw_lock(lock)								\
> >> > > +	do {										\
> >> > > +		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl)) {			\
> >> > > +			migrate_disable();						\
> >> > 
> >> > Have you considered using migrate_disable() on PREEMPT_RT and
> >> > preempt_disable() on !PREEMPT_RT since it's cheaper? It's what the pcp
> >> > locking in mm/page_alloc.c does, for that reason. It should reduce the
> >> > overhead with qpw=1 on !PREEMPT_RT.
> >> 
> >> migrate_disable:
> >> Patched kernel, CONFIG_QPW=y, qpw=1:    192 cycles
> >> 
> >> preempt_disable:
> >> [   65.497223] kmalloc_bench: Avg cycles per kmalloc: 184 cycles
> >> 
> >> I tried it before, but it was crashing for some reason which i didnt
> >> look into (perhaps PREEMPT_RT was enabled).
> >> 
> >> Will change this for the next iteration, thanks.
> >> 
> > 
> > Hi all,
> > 
> > That made me remember that rt spinlock already uses migrate_disable and 
> > non-rt spinlocks already have preempt_disable()
> > 
> > Maybe it's actually worth adding a local_spin_lock() in spinlock{,_rt}.c 
> > whichy would get the per-cpu variable inside the preempt/migrate_disable 
> > area, and making use of it in qpw code. That way we avoid nesting 
> > migtrate_disable or preempt_disable, and further reducing impact.
> 
> That would be nice indeed. But since the nested disable/enable cost should
> be low, and the spinlock code rather complicated, it might be tough to sell.
> It would be also great to have those trylocks inline on all arches.

Fair enough.
I will take a look in spinlock code later, maybe we can have one in qpw 
code that can be used internally without impacting other users.

> 
> > The alternative is to not have migrate/preempt disable here and actually 
> > trust the ones inside the locking primitives. Is there a chance of 
> > contention, but I don't remember being able to detect it.
> 
> So then we could pick the lock on one cpu but then get migrated and actually
> lock it on another cpu. Is contention the only possible downside of this, or
> could it lead to subtle bugs depending on the particular user? The paths
> that don't flush stuff on remote cpus but expect working with the local
> cpu's structure in a fastpath might get broken. I'd be wary of this.

Yeah, that's right. Contention could be really bad for realtime, as rare as 
it may happen. 

And you are right in potential bugs: for user functions that operate on 
local per-cpu data (this_cpu_read/write) it would be expensive to have a 
per_cpu_read/write(), so IIRC Marcelo did not convert that in functions 
that always run in local_cpu. If the cpu migrates before getting the lock, 
we will safely operate remotelly on that cpu data, but any this_cpu_*() in 
the function will operate in local cpu instead of remote cpu.

So you and Marcelo are correct: we can't have migrate/preempt happening 
during the routine, which means we need them before we get the cpu.

Thanks!
Leo

