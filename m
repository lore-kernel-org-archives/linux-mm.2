Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6491EF54ACE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984FD6B008C; Tue, 24 Mar 2026 11:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9366C6B0092; Tue, 24 Mar 2026 11:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8250A6B0093; Tue, 24 Mar 2026 11:23:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70D736B008C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:23:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F41D356977
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:23:32 +0000 (UTC)
X-FDA: 84581325906.03.6F33EF3
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id ED3F41C0011
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:23:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Q4WJfDOA;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774365811; a=rsa-sha256;
	cv=none;
	b=mw7MxRmhi6PpTTM4Q23qXhXDN2fAJHBDSP53mBkegPERfToHauPU/0yIkYuC5jl2ZtvMXT
	bYXsuZlJyLwQbhR18eHklgcLjNzZ1Wu9DKvX6TFZ/0sVtYs54W0pQnyZAGCCrhSaei614m
	7NMEflSWCe0HFWneXHUFewxYYuelMok=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774365811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dN9bTdcC5or2P8tjA2XnE4l+JSY6/+Dfgf14OK19Eqo=;
	b=TGeGpJIa3gnRcjcbjJCJQ1d9b8zNR8HZf/yUMp84XYx+YoAciGkuncsqjJc+jYzZDzctjk
	cs1N6zr0gBYmfrV7lP+p7bxAjAF7lgdynQqnBdFsynLITmtkiezjSrEIMJMaT2u9nwU0sQ
	tO3AqiMM+9l096MR8wcvrAlWwkMvsNc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Q4WJfDOA;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-899ee491af3so13618636d6.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774365810; x=1774970610; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dN9bTdcC5or2P8tjA2XnE4l+JSY6/+Dfgf14OK19Eqo=;
        b=Q4WJfDOA1ebvNl+Br0ntpqe2AfpR91QId2j+grQXf9al39nWpodRP8t0hzvl4Wxzwo
         LjEEAWCuCWQ+4oIF+/jUTFv8FvqY0VDdBggHKc51OpclNhem4jxExhYkYFgSvzNL6Z+Q
         j611hZ60I58eRIhrfjNVGVzTpWMYFVSQAY4g/NHmQWdzb1pVdG1Mr++1FhocYTI3ihMD
         hyULb2ZwVDIhVMLbNkdgoQ2saAenFaNoi37fj+cD/O/P5woqUUpqUIY68qEcOGlKN/Nb
         ZAI2cLULC44DP0DngNHZ4qN/BZ5SutkEsGlv4Fx27e4ETST19hI28FiNUX1YhDZkRZtd
         hIPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774365810; x=1774970610;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dN9bTdcC5or2P8tjA2XnE4l+JSY6/+Dfgf14OK19Eqo=;
        b=I6BuR6qXrLKmeVe8IH1LhhGDuaUtzk0AimWLkYlFHFqGn1AQ45D4WZeSr7kvuWZ4EC
         vDHJJGHltwZuaze9LdrZTsEL2C2N6Jc6yj5HnKwpaXz6G9y5dsDbSGSj5AIEcsH86qN0
         3IkZVvysYDHwxr0Kjvq3XivnOuxY/amcbJGuHl7sxuJb0SLUaHro3Ox7IfVDYWnKLj5j
         DIWjoE0TM+0dthGBaFLlyBsjAWwX7Ja9u2YwalyNVmhrlkqGQrCE/r6TkXZPPEny232v
         3g+vMQczKCPtUSJ2TTu5+7B6eOUfngQ30FkFjUQGZEmF3aod4/fXCb5rHmpHmnQEvxiz
         Fkbg==
X-Forwarded-Encrypted: i=1; AJvYcCXUaV/KuDO5lTBArXqa3qNisnq8u7YiPEbgcED/rlm6c1ytXmDP9OMCrvwKtkkXzM6nTPx5Yz6N3w==@kvack.org
X-Gm-Message-State: AOJu0YwZDXln5nqjaEI4m3gCRLqGLsJB3NLZTobAlIFbGnxGtAAdiu5H
	PuVnxUblSf2yNcNieiuw89LRFGqy6IpRxDeMbjSkVyWVdVfJGcLDhGMeugZHbxo9Gb8=
X-Gm-Gg: ATEYQzzvwKMC7ERUvs806jNa5XMXSlwtDaN3HzWPn9J1b0vl8F0kLotUIOcNm1+1YkU
	JaVO1MbBBoC8Ac969BErLmNMI8zjLsojsQHbLiSAd43DT3rGSHEq5s0gidFZPkI8pkq9bviLGm5
	mLLS2XkNsTX222w6eMxkCvao6Xx68ikzu9BVqyk5AffLU64kJ0AVUE8hiGrsY3hk94yW37GgdvU
	0N/JyBamV4eEQpx39CX0K/je87TlLkYT+xtWsAPRP/xHfN3ek/Z8H1cAEFH+SDLvujvLR7oz4W0
	RW8dq/d4nbBBlbZiJtDFezIWA+rw7YyJGR9hU7yu6WK7YfKgUgJOemf4tzd4Y7LLR1TLu8hm04y
	K3VIWdMOjIwcd1bX8VlNnKOT2UmveXHKxItPLWLbbXiRvtzzF9NDQeQtE7OayANByR+FgXOFcng
	jDJXypZVB2wnRAff8cnA==
X-Received: by 2002:a05:6214:3306:b0:899:f929:d85b with SMTP id 6a1803df08f44-89cc4b1be87mr159996d6.61.1774365809892;
        Tue, 24 Mar 2026 08:23:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:500::de62])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c85335745sm117576556d6.32.2026.03.24.08.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 08:23:29 -0700 (PDT)
Date: Tue, 24 Mar 2026 10:23:27 -0500
From: Gregory Price <gourry@gourry.net>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH 6/6] mm/memcontrol: Make memory.high tier-aware
Message-ID: <acKsb06lnywch8DV@gourry-fedora-PF4VCD3F>
References: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
 <20260223223830.586018-7-joshua.hahnjy@gmail.com>
 <90749965-ebc8-43b2-92e3-baec5f6e3de0@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90749965-ebc8-43b2-92e3-baec5f6e3de0@linux.ibm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED3F41C0011
X-Stat-Signature: thm8395okxkuocwcoftcwf1g8gyctbmk
X-HE-Tag: 1774365810-856940
X-HE-Meta: U2FsdGVkX19EG8IrHoVp6XFqCr6kIoF3+579SHJIos0BtjMSxiylxVtu+7K0f9YkKtnYeT7nPwA4Y7yAdNy7st8ihBHXiDpWgCOBJcTb9HYQeGiDNzQhZc5FSfu4N8ciazABY+csOSYKmFIWk3KFuZjkyO0KhnGzVHx2T1DprerOkQDl0yzaBO/bCT61W1vmOWGHF5c3zhOl9COFTcI2FrWOuSX0AjTHQadYqNAi6giQlUso3jZ6XKoAxhE5yf2LH/zxwZwtXT9LflpvKNKOw4Rr57CcCqjB+PlMTpmxIz99mGtHjDYQagrG+xf2eo8EBfrjsRLh0gkeFbU9heaoebV+jG8at0BOd4u/8ZZn5SspAF2QeeCrTedBW+UQWNJjfrSxLru+i2pdqQhztx5FeCGpJhCdEjABLL0HIjhqzKRV3Q7DX70D8FUOv+fAF/YE1locDeOD9z7IFreY//9gTyny2jgKUb8+JYBJgvOl+zyU9Wbvp66h8KKOrr8iEocGp3kzMmYM0rQ4mesUY6+FCMjnxgLgTvJFPCT5CAISPEMHCA5Ju1J5/bxe9AQ9LtMH2AE8Ve7X34ebXefcOynHx0wQIMW643uRdUFKaGtNAZMNZci7lnc1ATrNyab8WFwk3Ay2Lp0mv/8+j+AHh5fLmSz7+0iChvHpr+Our7kQSUjg3PvORZKGBo3HqZwJ35FukCl/mIy5qZlleAklQwKLxMy4kVkXsM4Zj++p7xHAjgdfWipUlQGjI1W51OiyDcfVoIDQXrLIX1utfFQ/50dbvofmR0gRsBIYfZYnR742dyLfG9lOGB8J8+zcUa0UO8FgXawlowGUDr23YFKFyvEQ2l6Qh//GQXpTA713MwSxB0/B5rDpB6AVgTBzI+3hNSv4jFrZSZBLTGbkj9TlFrX2SW/UQXMCTQqlBSMSJ2JENOb4SDos5e2gKb7tdTYJ8niZbjdE9DhyLD7/a44tran
 uCvuhmUT
 X2boIXDNjxVpuWFo6AwDyzY7K9kCYxFFlBOAVjtkNPRitNAt6RWhSYEd0NjofXTKiRfrSFGWZX5MMyzhlIZZXjGP8+j6euaqg7FLH+rrHiMbShKTXOJHj3Fp2CXYsFt/uzdIX999JE7mKyzh15m/AeTJuW/AzYqMfccMCERxVFOiWhbOv3upi4Tmtcx5xnEVGeZT08NyhF1B8o7kwFq/W2hPVpSDZOKFPV4AAb6KcqIMv8reU5j0zoq5pHTRdfkqqITNJgEYWz7f9Zz43lBkdZaySWi+hw68R5HQujVEpGv45xuka5UORyjsmY/zv6MjsdwwruDXwbK2p3/7Oy5AXoHSKonLEGxaqAaoC6B2ZGJgoLf8Zgvg1c9rXYaEnadqLTFYqt7c9wcbkKuh1ojhtE6pDBKS+osVMA3WSnHIwe0BQJ1tUyq2Bo/DktTMfAyBlyMuf2ekUX5pFlDDIdm89npBwjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 04:21:06PM +0530, Donet Tom wrote:
> 
> IIUC The intent of this patch is to partition cgroup memory such that
> 0 → toptier_high is backed by higher-tier memory, and
> toptier_high → max is backed by lower-tier memory.
> 
> Based on this:
> 
> 1.If top-tier usage exceeds toptier_high, pages should be
>   demoted to the lower tier.
> 
> 2. If lower-tier usage exceeds (max - toptier_high), pages
>   should be swapped out.
> 

This is not accurate and an incorrect heuristic.

Transiently, lower-tier usage may exceed (max - toptier_high) for any
number of reasons which should not be used as signal for pushing swap.

driving swap usage is a function of (usage > memory.high) without regard
for toptier / lowtier.

> 3. If total memory usage exceeds max, demotion should be
>   avoided and reclaim should directly swap out pages.
> 

This is also incorrect, as it would drive agingin inversions.
Demotion is a natural extension of the LRU infrastructure:

toptier active -> toptier inactive -> lowtier inactive -> swap

if you do (toptier inactive -> swap) you have inverted the LRU.

As far as I know, from testing, we retain all the existing behavior - we
are just managing a limited resource (top tier memory) to manage the
noisy-neighbor issue.  So...


> Should we also handle cases (2) and (3) in this patch?

No, I don't think we should

~Gregory


