Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD3110A88D4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 15:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10926B0005; Thu, 26 Mar 2026 11:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE82B6B0089; Thu, 26 Mar 2026 11:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFDB46B008A; Thu, 26 Mar 2026 11:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC3D6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:24:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A36413C209
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:10 +0000 (UTC)
X-FDA: 84588585060.01.356E6DF
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 18906160006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AFyx6quL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774538648; a=rsa-sha256;
	cv=none;
	b=50mxwrHuSFBArNi4CUPnDafYEF7tOuxEskEz8WhnDiYYCyWj61w7XEhpaUV2GxQsO3n2FU
	zawtNQild2FFRzR0hwDwqYMBWvnXVRafj1lXYjtvjlT9h0Wpa6cQNUog4mQ59YUTzpJG3S
	8SuBFH7APJShFDRYwnok9RmuJ/V6IbM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AFyx6quL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774538648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3SXFjDHalKyWonr/KBPjxaxh1IpYZ1fsMvko8xEISQ=;
	b=2ufWjSzFDWr0hDThxlXfOBDyMEXM6xZTQYr7ZxACRgX/mxlqih2OdKPKHdVucB7yaVaWB7
	SsP3TDZ/Y/GlCrSjwWr7ATCU3nZcJd7JDTudEMXQZ7Qbm0FJnypIU12u0koSsALVL5OT7a
	XpO3x4PMVspxP1k4sOuMQt5yjLrrXc0=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-439b97a8a8cso1088150f8f.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774538646; x=1775143446; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j3SXFjDHalKyWonr/KBPjxaxh1IpYZ1fsMvko8xEISQ=;
        b=AFyx6quLncd13kReuM+MChnLGe67JcbayA/haHfs5dnws5KIV6jC5VQiCN+SiY0Ep/
         zVS09beJRCfeVsJl+chaDIFrm0/NBBJQrNKTYYEFmPzL3Uzc8cen8HjwRH654l3lVPS/
         SqvwgCRELUifrUifnwxcetN5+uYoo3WOs3xprZIhoADVAfaHHOuIo8oAUirz80lHiZiT
         QiA28hLbq2kuvhVLMbmQCFOqZu/4Jb3wpS5BqjwO2cGYCqSrlslDeLIHRM/6kX9RGo3G
         T6e8dtM2GVLRjpP7dxQSgs30JUd/b9U0LXfEIEUbOlZM5XJKVPGoxstLAtQpHhhPUM2q
         2yZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774538646; x=1775143446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j3SXFjDHalKyWonr/KBPjxaxh1IpYZ1fsMvko8xEISQ=;
        b=ESOWQwzeZmq8nu6hT5p5iNdLoubWoJI3boeUYPhXyX9Y3xBNBOQWXnz28YglilPwFV
         pqKjHwTSe1RRaxx37/NBYeHGs7WqErq8trw6AH87SkqbKG4P+u31lorEcDYTGRtS/Ak9
         OZG9gcED/b4rP21JVxpIMdRjHolIznkkb7hVD4eHjXEkK6f6WpCLRLFflBHRQNiR2uGg
         c+lPNLE6vBxvZy0tT/GnSfeIOMVRc1ZEev4yTj3y4rsb5deM/keqdVwPsZGjXptl/EnY
         TP2lXQn4xaD/meVqd9XRFaSzbhgJMztyIt0Nm/E/Ay63TP6p+wdBRV8Tua5GsW6tgquj
         fgsA==
X-Forwarded-Encrypted: i=1; AJvYcCWduADbWWYBIlIMA7AwKAI6J2F2mEvzuzAw3W3mTaRYXVaUOuE4/mfcLKTf8k1urBEpy/AtvqFiBg==@kvack.org
X-Gm-Message-State: AOJu0Yzbx0vSbEs9K64op22M/cYxwtbt/DtDHpqoV6NgScrzt7Vwssh9
	iTlOq9UZ5JGFbuhq1ikjk/CQA++i3Oo/pZTekLUbOZq1XN73PPyWa7/nH0S6O7d1vHc=
X-Gm-Gg: ATEYQzwf6rF6mHsafRtYzMDzEk85AlsnuxSJ9GEUBsKeWHUFGTQF6P/h0DTCvbi6YyD
	lhPh4ry5nGjcsqWZs8ts6FzYd3Morp21SmoBSzSPS4mffztKk0bRVBLnUPwZDdM2EFI/pTQQMoy
	5udGI+IA3jZbHV5tHOCTtPrHpqy/rc0LY2EBKZzGAyfMeCYfMsT9jr5isWGPwuiaap4LAYm1RJD
	+zds7VBXIJoRjLCV8mu9AFmv8S4rxdiwZYt03O/JyNI4SzwMzTe9BdXTn5VZtTaNaAvF+Fxg8jG
	bDJBe+YYDg6BFB0GbI24SdoE+MwSG4ATycgTb1ncIdYeCkFj2ZSXQmg64eJkGYqgPsf+1suCVF0
	1picvjOO3CgUUuMJKnQjmDW5zaj7WDy1IZI2vpXyKcJZ5CvanB4HiCgNDNew7+sh6gsKhr0Qcfi
	dWmbU+9dnOP/TeHtULj8zNb/9/rgPkaoTZkU7Y
X-Received: by 2002:a05:6000:40c7:b0:43b:4396:674c with SMTP id ffacd0b85a97d-43b88a39bc5mr11889230f8f.55.1774538646054;
        Thu, 26 Mar 2026 08:24:06 -0700 (PDT)
Received: from localhost (109-81-31-149.rct.o2.cz. [109.81.31.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b919cf2d3sm8479963f8f.19.2026.03.26.08.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 08:24:05 -0700 (PDT)
Date: Thu, 26 Mar 2026 16:24:04 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kairui Song <ryncsn@gmail.com>,
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>,
	Gregory Price <gourry@gourry.net>, Barry Song <21cnbao@gmail.com>,
	David Stevens <stevensd@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	wangzicheng <wangzicheng@honor.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <acVPlB1Y8IR-RKCg@tiehlicka>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <acTcStxrTCWAN6Dt@tiehlicka>
 <acUzMdxCDfbuyv9J@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acUzMdxCDfbuyv9J@linux.dev>
X-Stat-Signature: scrcdymfqchgmu9g717pfjgbedbokway
X-Rspamd-Queue-Id: 18906160006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774538647-818715
X-HE-Meta: U2FsdGVkX1+5cJ6q287inppsdu16QNzVmwFczi3HItixY2ezRSGxYs4NqrIsGec/ALFhRrctXSAodmfZK0E78vSr1jEXmIMK2MTTdZ+hMFRAvv/mLraiehX4TWruZhaPjJhA/33+c5KyVEuaAlH+4qRc5NOhjHLftH44Qj8wYIEPWAyeXjIEcXli+4ALTm8ZF4fqvxnQpxgZUSluKIEa6Wm7MpbheFPNRYsiIdAJks74df3l/pImB70Gp4mKKrnIVelXASdJyHyKuZwCcWi/LRoaiZnZDUdx5pESsDbPWbvgnIWU+wWz91HKwyo4s16ArPX2XgovrlpbvOQXPMP8eR4ZiJRjjxpI1efh3bIMvJX7BwfSerUR+ckuygukxUcwlPnPVIAkYrnZxm8rjNbEYEogOHBN6u/4XiB25iQK1yRKw5qCyu508CHFyib8ScjiR+CaJgSsYOodz4yE4tXm5ztFGyuc1wRBGOGFUQTg3Ut/Y4SeFtkMxOpJFix7I30l/fOVT1qzosNj11uAayvoO5AdGJ932Cgv4TgO7qxOKt3sDipxpw/IOXB3ise5a5A7alvgpeVasf3tNGSpP1jfDy0Px4ZflcFusr+OJHUat1LDgRFEAMzVPF8LIBI+mrXSRqqt2Sf7iIvm5TA4ORH68U2N6cyxojF1JmdepWrw3/HLPQAifuME2AE9F0FZju7HDTI4qc5uIJPZNsZ/VqtoBrAZlBuTMPL/j2Ga2of4zm96qLL5EXvXm5jS8PM0PfA70zXPWndRxw9s9yH6/e5n1VQvN9kew6Ag/KjmTTE/1a5CzqWL3aeY9hvzIOBiGRwp9K2BbE7hGeAk0x+DwNaY0D/IEvheIMy5GAmVLqg68yUTzozarfaXohPqgWxCq9icdUCCut2xmIk5w+dgjER3pQtFX6HOfwU5bbewHJqebTAdkANHjVZP8jESzDqTmsACMW/e7BBt0MEEyTnuMfF
 PpK/P62X
 A3isFPhm9pG6fW6nBhnjDPpmoDwrJqymh+U3cDkAJnb8MYRHNuVFjEd9j1sl7AcQqtMeH4Cp6vEhSl4OI8F2rSCBw6+3JauG/xx2aSTECwjMVAGA0NEjWLWzdpuNpdbvo0me1Snge6fbrDnonMjnIBUf4qLm08rBvgdF73sNP+EWadydXMWA/7Nrg71ESEr74WvTnXiuSTvHDFgVpPXDB6h7Hcdw41LCoARw+yxboTJZJu/KAUmr4GEe28r6PRm/7FceMXuYsXBSsU7b0MWCr3jJctGdd9VQOltr8iLyNgw8o+0ywdH7Gn3hynU7YsukYUPeOLllwbxjpiX07+bY5WY2masc0z0YVxS7eMXsXRem01jdtr6k2zXJlIxYoTmp7CjEi90YezOBV3HKnEiuzh6WyRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 26-03-26 06:44:07, Shakeel Butt wrote:
> On Thu, Mar 26, 2026 at 08:12:10AM +0100, Michal Hocko wrote:
> > On Wed 25-03-26 14:06:37, Shakeel Butt wrote:
[...]
> > I think we should focus to make a single canonical reclaim
> > implementation work well. I.e. we deal with most (or ideally all) known
> > regressions of MGLRU. 
> 
> Here we disagree on the approach or steps to reach the single canonical reclaim
> implementation. MGLRU is a plethora of different mechanisms and policies and it
> never went through rigorous evaluation for each of those mechanisms and
> policies individually. To me that needs to be done to have one solution. 

If my recollection is correct from the LSFMM (2022) there was a promise that
MGLRU architecture should allow to add extension and eventually
supersede traditional LRU. If we do not see that happening then we
should re-evaluate current MGRLU approach. I do not think we want to
build reclaim_ext architecture on top of the current code. Or are you
suggesting to achieve MGLRU through reclaim_ext?
-- 
Michal Hocko
SUSE Labs

