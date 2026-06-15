Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B80CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 09:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60926B0005; Mon, 15 Jun 2026 05:38:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11436B008A; Mon, 15 Jun 2026 05:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FFFA6B008C; Mon, 15 Jun 2026 05:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF426B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:38:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30E4A1C4547
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:38:46 +0000 (UTC)
X-FDA: 84881647452.01.B3864EB
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 56A888000B
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:38:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ecOOYtfN;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781516324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oamN5hjWi+TCb5PPsVj9eSoiuDSUof3U7OYNH2/rvIc=;
	b=d4AmvXSx945CgJyVgEmtST4BjYWc98bOIYtXNr2DUAwck6nIdS/cO6ATfQEi8K6ZPydDZW
	jnPpnu6D3+HrsxdIGoU4aaxFk5LMxpBJn+RzH8Z+1ggH+3pspe7IqxHHejO/1boKF4G3kL
	fj1E3ElbuIpKOMkSPgICkmEzjp9q35E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ecOOYtfN;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781516324;
	b=R2fN/68hAfMvXzdOM5SCm5sAKSwNwkTJdP7VRqPh0hdbmZ0Ih0cP5hIwzA3V4+vc9OLYru
	Rghu2ei82p65DEJEFwbupKM2/5bbTfXVft9fcl6jvkHBK1F6MCf9xvsnwFa7hFCUN6SxCI
	5PWghYRFAN68/2vX+tOHtgB4jrNaWvA=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8ce9df31840so25655286d6.1
        for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781516323; x=1782121123; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oamN5hjWi+TCb5PPsVj9eSoiuDSUof3U7OYNH2/rvIc=;
        b=ecOOYtfNoYv8QUw558zEgQ/GwZcUD+ImDqQ3GphWk4ws7+tN8wV97cUSEXr3Z1VTZy
         FRy5hhnldDlmBKKNCXr1Eccfv1Xiw+aPx+s8vU3RYLsQWRWQrQIaDPVvygC2o0lPq0LI
         7p/2Q5NhBGVpnERoWdbBDp3Wf/UnJ68BiyJayeCfCWGwkHNhC9WOv0oNxyX26FRPR13p
         +RMhkG/w4sOYQb6LdWjCLyz30bO6b3gvVc8EAu+Ngt9nZKoYfapRQLh3lWh8wvsT3zkG
         AcXKb1nVb8oIulaBLodaAd5jk9/6pjcaQ37xp0tHOrrccVfTiuQNTJsa9x9UF62dZ0yv
         TFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781516323; x=1782121123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oamN5hjWi+TCb5PPsVj9eSoiuDSUof3U7OYNH2/rvIc=;
        b=mwcbMBFkXVo3IxBkakPrDJIlT0wkXGDSQUuCDFEHKtOXG1gNoo4770n28sydAcBSi2
         FAS+oovJ3yk8pfH7g+WMwPcur7WBaUWgopGBPHklWF4Sr7EF0xGpW4gRQX9dE9RAOIvM
         y213CZxGCAEDdg98n0Zy/jvR3oJUP6RXBA8N6izFsb6mjlXJ+TMI637s9tkh+1TD85t6
         wcj7YGjfRYWLFHvAR5PI3qFLCuW9hM3RZLvE3s88R1gMDjxEd5uj/jG6hC0jFf0mHzVE
         2t4cGyghnZg0CgvRTRgPh5CK7Ig79OOsJkBWp24Lfk/lCW8kInkl++Ujpb6ow2ucYqk3
         OHhQ==
X-Forwarded-Encrypted: i=1; AFNElJ/z9tyIMcJ2xACsmW34VvZhoCPh/8TVaZ51cJSiMb2+V8G8hIOOQmXIn2oB5V1wZmLScfKNh9oMxA==@kvack.org
X-Gm-Message-State: AOJu0Yym/z23ZTF/MapIUwFyeVbCtk/+F4qhkREPSDfxQfU65nXnSu35
	tMZVkIWitrWBIWwLlywj2eEGOQP/Lh8b8GEox/FNYxYQCe3vPCYFJYc8xl3lKBYlSqA=
X-Gm-Gg: Acq92OHL7RtEBZ1UHbo9vtCkzNUZ3Wt+L/UBxnhnFUoQmYrO5bZhAL+OZhAYrD3hZb/
	5l8ZcjSwoj/WIdYxHvlVBcX8vrfjqnskOzQjkrBvw9+tu5rD4evK0qqtUjCw5M0qWoKjNipH9ZX
	FZVpMu2JUUT4TPFacjrmljMiQVwFYIet26ts2f70d1ONaRbkhySI2kLiP3zz3pMEs6R0/eotb6D
	oUVN33zpWARqbVpQ+ASY6jOpUfXYeydOdD3WBpmeoxcbRBsUZg0EcyUJDGMtbELfZcHq7oyfekI
	TNq3ewZmwuMdSxc+h8kIbxcmCY5G3g2hYr4+lnPDNnaBoiohjXp5vtI2/XwSdRaO3Oqd0FBGfIn
	LzkOUOqYu7eAIBVEwlZD0RuY+Zca8iQbZGPbdS8ZbPWb7FZhMp1CoRg+FfiYx4/BJQveZgJrLhd
	p3rODPOFxvGD5w01GryWvZOvcsTVTQcFPKxFRrfAESs0g9EKW9zbRBzCBfzs3qgkVJ9xYof9ujM
	OrR0akwxKJtMuA=
X-Received: by 2002:a05:6214:5907:b0:8cb:e63e:2a45 with SMTP id 6a1803df08f44-8d32c4eb32emr217014056d6.18.1781516323361;
        Mon, 15 Jun 2026 02:38:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (158-94-182-130.mclarenap.oninferno.net. [158.94.182.130])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8d301c237e8sm108166456d6.17.2026.06.15.02.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 02:38:42 -0700 (PDT)
Date: Mon, 15 Jun 2026 05:38:38 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Farhad Alemi <farhad.alemi@berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Waiman Long <longman@redhat.com>, Farhad Alemi <falemi@asu.edu>,
	Yury Norov <ynorov@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
Message-ID: <ai_IHvyptWPcTD0y@gourry-fedora-PF4VCD3F>
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
 <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
 <8d3b4561-92cd-4ebc-8462-5fb0fd659e8a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d3b4561-92cd-4ebc-8462-5fb0fd659e8a@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 56A888000B
X-Stat-Signature: qtmfcsp8t7z49kuuyacwa6dzceuf5jpw
X-Rspam-User: 
X-HE-Tag: 1781516324-246800
X-HE-Meta: U2FsdGVkX187Rb6owNhNboFQRksWww0fjGfWD8+t48hSqhqdVSbLY+SeFV/9LH4VCV49dSp+clti2aI2RN4jyxtbvtgdL8O+SPVteDhg4va3n7sL/IFrNbkA28EvPh+BCn9/tEtIKDvyEsjA4tt6H/Z5+ixzlfu8izQdmrpACX5sC28w9jI2tPDHl509oKXpczAoFCq9A/acVKK25d6rt122b2qwnQd88aK5ZbbMbnMFNQZ0z/VASYZtX5dhVGGyzKTpO7NPc5O7hf1RNQlEPR3btfzyVO8xSaShe4BGZLgI7kBuHOsUIWG0tjYAP3u79fAkwg1aGh0DMuXcLs+mgrAo/sGfBOzl/7SSPg0f+KumBTrnoU3MRdwru8WyNOXY0PiPDWxNP1ooYShDPXUG3IA8l2fiDhCA8r7xkL/JWt6wGHa1k2Mp33HulgZOPXbWQmqIMlI2OdKUpavlOgGaeJi1PcOUAfk8ER80W4B1JIEL4rp4eSofP6y4ldWdtmBOKUMrXEvc8xRuz9FrdjJaoGTPCQndaOgfc9lbWd58jR/sOW0fnXri5TAf70dqEDm8bsDUN+5fDVlRyk5ztjnWQCJ6wGi3QLFOrqkgKJgF3RKQQItHmb+g0Gih7yOR9CZJVYKwwhq1XJhKn7oGc7NeQCmTvvRvdhC6sHEKzifCmIgtaLq855fKWKsYEHInXvE0BKFftpY71Df/ELMv+P/4cJb3E7zg7pRnB36d4XS4PUwaiTXzATgaR+HaY0yV0Gj8Mh24n+WHz9UkQX2zTStyEQNsDZGCXRiqeU68pK6dGPiP4hkeXwFZvvZ6e9it+pN2jekIv6n5oliNUYDJnPDXg9NGeRNHDuraNIaREwELO+chjPSpThXI5GbgZZbZ2TYDldnJsw5k/rvOxvfRyvybHTS2A6RTnrd6+2cozeY7qgSpHVDCNfyl1HAdc46zoMhaa8NgrOSIT6ZhTxmTqUY
 ErJUbRNg
 ywlqGcNIKImF9x5zLOSras3CcZmlra3oX79aWI54TPSFsio2G01VTNS/l7kZhhPDyz+2Zzjggnfx5o1M5HR8ISesIrsnQXaJUCEfQU/bUcD44/EktDMFHeMxiu1VLk/r1//PD2Th9Ktg5wvSjlAsAtOKTMEEyogH2tJfmamHJWntyb6WRcIn2N6+tLPnQ38+FTkydQeqvDQIuDFhLEOXt+aoY6IW57NttkdNK7RyKIZRisnjtQvkxECSUHtDmjTWEMoCAIfwFFuVPhwd/6L4pTp1dLVDNqjbKuwUFg61PbGtJr55AnpdbWX3iuFXv796WjZyYhPlNfXig0KFjggi9+zr4rCUnrTidYBUxHMdY3EJ96BdfiGqo1wQ4xGjtB9WEiNwTJsBHdC1QzvhChu8d++JCN7eOrOj69lXzRY39EG6ePX+gBGUW/XRA6ExVjVIntKLyPZMWw3Ik19A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 10:08:51AM +0200, David Hildenbrand (Arm) wrote:
> On 6/14/26 15:25, Farhad Alemi wrote:
> > 
> > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -2649,7 +2649,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
> > 
> >  		migrate = is_memory_migrate(cs);
> > 
> > -		mpol_rebind_mm(mm, &cs->mems_allowed);
> > +		mpol_rebind_mm(mm, &cs->effective_mems);
> 
> God this is confusing.
>

All interactions between mempolicy and cpuset are horrible and
confusing.  Much like Lorenzo's anon_vma work, I have to keep
notes on how this whole thing doesn't just spew SIGBUS constantly.

The short answer is: mempolicy is advisory and cpuset is strictly
followed - in a dispute cpuset wins... except for file backed memory,
then everyon loses and nothing is consistent.

> Naturally I wonder: Why are we not using "task->mems_allowed" (maybe cs vs. tsk
> was the original bug?), which is effectively just newmems?
>

Short answer: task->mems_allowed is protected by the task lock and we
don't hold the task lock for a foreign task (not-current) over mm
operations.

Long answer: Reasons and "Stop looking at the spaghetti, it's going to
break"

~Gregory

