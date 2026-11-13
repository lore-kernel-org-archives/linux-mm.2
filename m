Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084A3606A880
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 07:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=m+raJt39
Received: by kanga.kvack.org (Postfix)
	id 0E4F66B05FE; Fri, 13 Nov 2026 02:20:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD386B05FF; Fri, 13 Nov 2026 02:20:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F151C6B0600; Fri, 13 Nov 2026 02:20:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFF026B05FE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:20:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E28A806D9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:20:24 +0000 (UTC)
X-FDA: 85429247568.16.66DE08B
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6ADAF40006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:20:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=m+raJt39;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794554422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ukC9+RmyKpMCoo2Ej2X50ZCe3RffRo8JS7sjMrz5b4=;
	b=uR7YmdjKlf4SVC7Nks0a35Y2O54mFvO3e1mHzENcBDj2KwIKDbpg8/2VkHkf+ORdZweZrz
	W0zuoX9/KkHLZn7R0osW8OoYMmV46+m3ckGl9YRTO6ceJQmdfDHDub50xaidtgQUC7rpC1
	ycQKS9L7WaR5V7/cXP6dlzhWS3iYfpc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=m+raJt39;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794554422;
	b=kiafokbYGLIG+Sh8W+N5/bRiKISGVyvDTarY04u5J9fi6xf+QuwqhhIJ3Lf9ErWqvKhJTW
	xdYiPfoFQmBrN5Qtq4n2HYp1o9zMPEjWtHSgq4HH+qGIe8dnDn6mfMtk4xaKHtFpWR+LNx
	/E2O2FUUvsdE4gK0tWfl9QhFqIyUoeU=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91c6ce60697so13335376d6.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794554421; x=1795159221; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4ukC9+RmyKpMCoo2Ej2X50ZCe3RffRo8JS7sjMrz5b4=;
        b=m+raJt39SHV5hlAMvZCfnOSTVkuHF9IkHpZ3ppIVdjA8vXsj+uhxym7NdgstMhqQpv
         8TB5wWEmtDZnj8TDea/ZxAAF1QoPqUk54Rq8ulJyF9+PvXV8A0pNTwCXAekIDnC/Jlvw
         QFkgwGiqwvGQc/bvoV44p9PIBJozKWwiJD6pGHjdFpPSk/uzjtpWnoJVqHSOtpRx89T3
         dCVKOmNJC5udlXMcee7dE/AVE4MXhmrGzZJM3Bkzi3LIhrabur5/XEBwkaCYDQWxJSns
         WvEGo3TGnu89zBby47jevrcwStw1c0Mdqr2mXsghYpeDVItjFnuoRWVYQmQrT/RQKeZP
         s18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794554421; x=1795159221;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4ukC9+RmyKpMCoo2Ej2X50ZCe3RffRo8JS7sjMrz5b4=;
        b=HEeQxMcx9tqJYn9BQjx2s70/ymisK+/BfX3c9PihZwfRCbUTnuJdu/Q7OczmAqJKLb
         lDDvCqsXg6EB2OkDPeY2SzqWftD236FByKpi8RcOAZo7Xtxmo5ySnxQTg5nCtTiM7Br4
         LXfDyKtyKo8uxPwpwFSP7HG17yLcxgp427xMWAcoFl5Jb0mRhG0oHTSZdBNOjBq0bWjI
         ctml906Yk7V9wRVkom72Jrg6KwM/3jhH2o2T7mDQ/sHjV1vp5IXlCSuP/Xhp5MfxCJiH
         2xK3OAh6CliEXRwOy7VFskruWdDOUkEgLtQylKMk2V23jy9mBRx6ykm1tlhP7qfuiYiL
         EXsw==
X-Forwarded-Encrypted: i=1; AL+hErFfBK+FmQU7Eq4mWXmFsDQTArhADSrgOloPjSE6iMhVY7ptpswkoyxK1lqLW7IEXCgQoONFy3DNyw==@kvack.org
X-Gm-Message-State: APuU4Z88uOs/0b/VQblVpdeYTa06yg1ZYE4W2XyU6wKx8yghyyiE3AOV
	wyu6iX0i+rDF8h02bGNF36UNnHEr0XdnB1jF7/Yn6ySIIehStgHVXAw7itzREHVMND8=
X-Gm-Gg: AYBFou26eQ8/cK5Lq0rgXhf9uVmggzlQ1iYj8FsDyXR78bqFb99cJrlfI9gHfIV4kOo
	lHtPmk9G3VqkFM/ouF9xkqOGjyRK8Oq/b1yWpUU9F9id7V7iCdG7dhqeTQGFHa2SKuhaiCbzqDp
	78DRvuCBLBGWcZ88XnPsgauuJrjZceN6+ilvXvXHrrKWaKv8hfTgnUVVMUPRP/E4YnClXyfOH94
	6/hfPCDLe8klTBHV6TAMSsbbjTAaglrqnF/X5g/iYjXs5v5Sutp6m6vkuqQc5AD4R08v6i+Mvma
	lf6T4kue7BFPQx3nPmg7aNoeZPSN42cvkRFgEtnjG473zL8PhzcKXxWwSW+gIkckjw512mdpRvu
	zUORwsHlLuAve8gkrzsa/pCwruz9WXvMATUL88hGe+nG1e8R97Z6A1hlY66Azign1lzzpcChOvd
	ym23fziGDRl8zXGn8XB9YwM1dWib1hj6JQK5MlJ7YPqCQdlJYTdYKQTJ+js+zoYqXiiFMcJ5sp7
	6J83LoDDDkX4w+dncMaDaWJR32EboCaY7orF8PN2/ce4zZg+Ihn8Bwv4XuOyq6JUqxeUcUetr3/
	TiI97TDddo77cRL8DBTAdKCnVFpbNDrCrQHn26Z5RuCilNvYpbx0xzUwQN+pUqT6jOpthILtDKz
	wJnG+bMlqELnnywfNXs4s/61kNohSLA==
X-Received: by 2002:a05:6214:c46:b0:917:a1a7:6369 with SMTP id 6a1803df08f44-91f24198eaemr24969396d6.22.1794554421464;
        Thu, 12 Nov 2026 23:20:21 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d614b4sm14297636d6.18.2026.11.12.23.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 23:20:20 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC v2 1/1] mm: add source selector to memory.reclaim
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, 
 joshua.hahnjy@gmail.com, ljs@kernel.org, mhocko@suse.com, 
 muchun.song@linux.dev, rakie.kim@sk.com, roman.gushchin@linux.dev, 
 shakeel.butt@linux.dev, weixugc@google.com, ying.huang@linux.alibaba.com, 
 ziy@nvidia.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261102070440.16262-2-lizhe.67@bytedance.com>
References: <20261102070440.16262-1-lizhe.67@bytedance.com>
 <20261102070440.16262-2-lizhe.67@bytedance.com>
Date: Fri, 13 Nov 2026 02:20:20 -0500
Message-Id: <179455442014.482102.4069329165987986914.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6ADAF40006
X-Stat-Signature: pz3uhjinf6y83z189tkh6kwkob7cgmmg
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794554422-980503
X-HE-Meta: U2FsdGVkX1+LeOzXx11o6oWu8yCtQO7jeUDcpk61miVTc3yR6ERlku+msCeFbJmC+nrDZDXtKSIFvbY/M5Y5R0B+eo6vIVWuY2igS55SVjBAIBy2KwsZxWruV+IficBOHfkditcVN7XI5r45AfOv7VbBKAcqi7i/jmnSfwFqdXYuvebGvTjfuxgtEv8bLcSnHwONh758hWRz/52OKNaqurDQS0rmkntTuy4lm4X1exdM/Nu4FuWIyAnnHEonQvX9+qwC2CCxEcSbpmY1Frm1wN2IaXpgIUCfJlHyWRFsTkf2j6VIlViEsNVgTYp0zqtfSjYAaLsZuQXNPmNjoI04aeAnqDNZu9DYOo5iSFR6xo7U0ITnTIydwUHPicUUoBl6e084kuh/mPg3zG0mCMBPj38c0epmuyGNnSTbcL5tUZGsqJ/KFQeVn1p/biFHUJ2bj7eg/WyTdDxtiM1Zv7P0udnfNDWv3PJ09tTO+CzWZTANByG4ReV6lZg8RT4ncMJQZw4Uy4TyAnOpqZzOzuM11JgFog5YBrGpPFXCxgiJEuxdE+PL7HN69XjarMgqaAJKCi4sL44u1IWoeX6bYK4RPrEJw9kxX8jDJbplr9vEShXIzSE8tx6Vz0NNJVIQwhek3dXTczYvv0i3LTTxZd1WGBFhndbPTIRcwSx9uqRuEcnFtkfdJIciaqLVLfrTNsl8JVlT1iKsUAu4UpgKHpZtIErPkSPfFs+uCzXtHs9y7GM/Od+M9cbYclRTJU1g1n567NOStJhdtIISmsQFimgG5B6ULY5lnqkFnFDhgPhKtnM3mI5z00ZWj1a8PRkCMkZuJ5ZrmnwabS9OFR45W8akvA3A+VHzPMKvGy77s1pg4sy271jmHRIsgFXYpIW6G+SBKQHV1C5hXBUzHoH5GXe9SunKgV6IL8TsXnivf5WfTLjVJ5njrSEh8YDll3ycDf4JthHXFsdxcsWY/K7ky90
 tykmUeGb
 MEoHWdRDZq7Rtw/C1tZ/0W9wlM4kMeeG5aFZxV36md/gHA6G4uD6nPUes18Fjmt047gJazo1pCVa3Xp+WrcHvWqIAoPeTq6FXd798TH0fj3+sadtSfSgpsxOr08kmdLSaqqApDkYhjLbX354cPRj1ysOAJWE19GAdqWhVe/b7WGhk1qwwQHq6A2XENT1vIDKgndoNljvBB8SvAOWAlaQWC7S8pxOBMAus892xNtIVlkfO44gjnaxBaZ+1M4MSPLP35t7una0F9+L22wdSbil1qnOtZLQjY+RoAaO047VVF9XG/YyIcSsvo80lpqsBNgbtutQVDs1xrBmoG/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-02 15:04 +0800, Li Zhe wrote:
> +	Specifying a source value constrains where proactive reclaim applies
> +	pressure. Currently only source=nodes:<nodelist> is supported. For
> +	example::
> +
> +	  echo "1G source=nodes:0-1" > memory.reclaim
> +
> +	This reclaims memory of the target cgroup resident on nodes 0-1.

you buried the fact that you want to allow source=zswap in your cover
letter. I was confused by nodes: was needed here until i re-read.

As Joshua mentioned, i don't think you need the separate cover letter,
and I agree this is far too long for the proposed change.

---

When I asked for testing, I wasn't concerned with the functionality,
I was asking what problem this actually solves. performance? fairness?

Shaping the distribution of memory is neat and clearly works, but why
does userspace want this?

The interface "lacking flexibility" is not a problem in and of itself.

I CAN see why you might want to proactively shape what data is swapped.
Let me give you an example:

---
The global node reclaim interfaces allow us to put pressure on distinct
nodes - which lets us shape which node is swapped from first.

Example: node0-1=DRAM, node2-3:CXL

  echo 1G > node2/reclaim   # swap from CXL
  echo 1G > node3/reclaim   # swap from CXL
  echo 1G > node0/reclaim   # demote to CXL
  echo 1G > node1/reclaim   # demote to CXL

But the memcg.reclaim interface only allows us to pressure the complete
set of cpuset.mems nodes for that memcg

  cat cpuset.mems           # 0-3
  echo 1G > memory.reclaim  # makes progress from any of 0-3

Presently, proactive reclaim iterates nodes in node or fallback order,
meaning it attempts to make progress from the fastest node possible
first - which attempts to demote by default.  If the lower nodes are
full, this demotion will fail and we'll swap directly from the top tier,
which is (presumably) warmer than the bottom tiers.

Enable source-bound reclaim in the memory.reclaim interface so that user
space can have the same control over memcg memory tiers that global
proactive reclaim has.

  echo 2G source=nodes:2-3 > memory.reclaim  # [z]swap from CXL
  echo 2G source=nodes:0-1 > memory.reclaim  # demote to CXL

This lets user proactive reclaim to target the coldest memory first
rather than preferring to reclaim from node0 first and potentially
swap out memory warmer than what is present on a CXL tier.
---

With this, you might be able to demonstrate fewer refaults and less
DRAM (node0) memory consumed by zswap. These are clear benefits.

I would argue that memory.reclaim should operate this way anyway,
and that would could make proactive reclaim do this by default, but
I could see the policy bits in userland being useful as well

Performance may not be the only reason you want this, but you need to
help me understand what you're trying to accomplish.

-- 
~Gregory


