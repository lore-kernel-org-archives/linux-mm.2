Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6DBA606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 01:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gs4SaSdp
Received: by kanga.kvack.org (Postfix)
	id AEE286B05B4; Wed,  4 Nov 2026 20:10:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F626B05B5; Wed,  4 Nov 2026 20:10:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9954D6B05B6; Wed,  4 Nov 2026 20:10:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DCA46B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:10:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8463AC08FC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:10:34 +0000 (UTC)
X-FDA: 85399285188.08.11C2E3D
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9AE2080004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:10:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gs4SaSdp;
	spf=pass (imf30.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793841032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mA/5JmHeMYIVrBxf3oNqARmHAQK65wAhI4k5sCDPP90=;
	b=IH150ZoZ1d8eDrRUUDi+o3IQmiXXJMdh8tNRAELQ8aZx92AfwVg2PSzgINmSQVAtyNb0Za
	spMZyoUdyIQf6uRMmqpYiumIdtW0lbhv+XzgrAg1oKK4XzmGEoqMH/1th86fRH5iuj5wP2
	wQftk1kpTMlN8GjmV3289CyDzB5WjVM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gs4SaSdp;
	spf=pass (imf30.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793841032;
	b=7HKThCMQs+EGVNUwsBks6taDpbmTi2bAw8g+lDk6BC5xsih0rmE7jaNJDoKc3a1yGRhsrP
	BJnD3LRHAaawb+UiOzpT4fEQC1DcssZ1qiR6yi0cvqSCiHZh7WZUBPeL2hR2dAqfWwGHg5
	DJHSM8oSMZtOUMjxIcH6v5F0edYDzQI=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-33bb5afa736so174885eec.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 17:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793841031; x=1794445831; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mA/5JmHeMYIVrBxf3oNqARmHAQK65wAhI4k5sCDPP90=;
        b=gs4SaSdpBpNjuqpL1m58lmVBqbseA/P/PGojyMd7Hb/xxaIVtbLaKbaUKhLjgNcAdP
         ZIrfNIBHzrkL0BCoQWqypDnp4WjRPVUGwEQACr8hZvIbtzziat8mx7Rq5r5ww2gVbd/I
         c3rFfo6xRMrW53kYx2Zd+L+YSKrdMOpkBnn3JRUH9NFxMn2rdUTz9x7f6UYxL1iIfj2L
         REa4RYAu5nm9Luh3NKSv37OwloCWkz1DDLzKS8166QeW6fjJzniS3vA9SCvwCq/ax+tV
         KIYJBWbFjUH07H48Fetrr+kxHQamt0PxBda8gg5AUQHZyvhLE31dIPfr578Q2DYSe9cI
         96Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793841031; x=1794445831;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mA/5JmHeMYIVrBxf3oNqARmHAQK65wAhI4k5sCDPP90=;
        b=W0zj4PLdALsLZDkfgwRRyqayFGAO5cbFKjvANM8bAEJ5RbRAbFvf7j18s4navfm7Ws
         j/EL7pH5SY80L2q7vwvgSx4zdhVSXYa8scvXNPh9y+nUSu+q4mtkMLAQ2yL2zQBl1N75
         SpmNFqD3jCPNtUw6xtB2RKT1Jh07PjbeN6lWt/KxDusnqewLVNh+/VievlaLj1fOEkOH
         ml8xC+rHCZX0tEMjMy5ZqhUeFrela+qKmth5phpG5xwvxz4jAd1Gl+3rt9CQ5f3UN5N6
         tdC7/skrxd79nSYRKdsYYx22xzBtg3ewD9l9VBleyiwEqHDbgyBHg6xahc3t6MIeyV9p
         e7rQ==
X-Forwarded-Encrypted: i=1; AKwUvBzXax07p37zPuMSxxrFqEiMzhpt2SvhP0flHV40Z5kDezlPF9VYV6zMhqDNRaihhRKmhwsVCUE+eQ==@kvack.org
X-Gm-Message-State: APuU4Z8a4K15y9RUq5m6BBfV+ZOsmT0aYaotaXFrcwMK4Na+ycqSSZod
	pxsUymvkGp6xa9WTXzOWblhkpWQ2/RdKdSLIDnGU0hPsnajPpBTo+YRO
X-Gm-Gg: AYBFou06iISvFiC6OXv20HuupqHojTz4VauAYoJKbElwSa7wtXPwwyRuFopb2ZCAElo
	tSeXhpteKLYtJx0AbUZUApFtcUMUjasYMcvxQ7PqTET065meKA9ugRv3Z7cCQuY9p/EeFN6BRS2
	vDQ64d9tuStjSiauSkik6uDIaFR5rkNRRm+jaDREGr8q8hCW1R83H0m7+ggQzGUEAWaSKUTm1xu
	mA590xj1D5Dog+6B5M36woeEaG6l0+dbosy7tZ9F0o2B9a4dkCjbVTv7dyobdtfV6SrFGpNZ0yZ
	cMay+kLbjohWNjNEIpN88CQuTLDjCVkPq0li1QjirsvccaBd/0BWoLa9Wl34Y8RRWd9/mKYm4yg
	u7KgujfS1m91pd8gM19vcGaGINH6cBIejx+FMU/A3cWKAg6GUi/vUY+uER2EvW0DRXLuYvNKtPG
	D2p3WIbQKV4qOevn1v/38NrlTC5lGJod1m4qAg0tgQTw6mpT97E7MR1p34/tussvcV+rUHmtVb8
	sQ2/L/tdb0Z83lrr2FTdwYWo431MrG7i6CHToG2WBc73CGdTMZke0JJVyJl65bL8W7LiDIh4bwF
	+jBH913V/8CxVy3cHcQxiVIw0mw5KpgUUMrvj6MVl++e275ZLaeFd4bhAZ5M0rRGOqDF6xrNIMK
	BhjKrO+C1JPyC
X-Received: by 2002:a05:7022:7e0c:b0:165:be2f:c56e with SMTP id a92af1059eb24-1ac5b7dcb2bmr42937731c88.2.1793841030720;
        Wed, 04 Nov 2026 17:10:30 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c2d69asm10759440c88.11.2026.11.04.17.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 17:10:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Wiseman <chriswiseman@google.com>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
In-Reply-To: <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
 <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
Date: Thu, 05 Nov 2026 09:10:24 +0800
Message-Id: <179384102494.19062.12740032892044628762.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Stat-Signature: psjce4k7iwaymj3fjzbtsh78kniqkjet
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 9AE2080004
X-HE-Tag: 1793841032-367394
X-HE-Meta: U2FsdGVkX1+BBy/hVF8D+vo6JtpQp50bX3g6lwbmjdmf+uka/Ud7QE6IDKyYBHMNpO6gFXE0GLuT70jhUrAnxsD2zBu05txy5b3ozQHOWbKRcewKD8hUpi+ggSLiXCx3WCQS3ysCrKe5FSEPrrvQH7ZTHvYCmiRz1E7gq+GwhC0iofVDPvVr1k/UllQfVmDf0kRt1JoXbjNg5830rNo99GUWFcslYzHeof5Cy0zyN6el+k/pRD6B10cvJ43QBrjOSMkH/5tiwrDBBFab868Wo/lRFrf4j52ktJeVrNmqBZgoN1iWROk9T4S1QseonWDeCn/xLgWamubYwX7thp7ddbmfBtymWthMnAwuxv6fMb2qP00gBwkG9KGhT30ZZIBUUdBjAQdhDYh9Y5tM6j9g1dwDOznkoUEu7miHYyKREdXJJPiA1NFsBPZ/iYWXAi0BtpEi/rUb0meDQ2F7nCzjKJKmdZUaLX9hn2A40mPFHPsK9i2Dt23O7DErCm+1MSQXGjUekNddBMOzEPE5wnAyufC3OuxjL2XxVuEFkIwzJ8A7WTzPHReSWt8mnfDuXMop/jn+T1WG0y4delIVqavlVaU90FTaItDrAw/ZEsEIt3t1c5Be1A/GGRxsoME7nniwIHx+rAU+5yKuQZYFRe0+EvG/3iKmhmbtyuUOMpKlxBum6DWigTsjTwPEyHy+dYCfStzyf9dQsx4ZRCobe9T5pEscdFGb1SDlJ8AxUHscv/RwOGKMMsVGq97aALNhdByvA5Tb49YKBA9CWcavcrYJDGRyF/JuyELaA0eePwKCG+FL1eDS9KRT/uvnPraDLVkUx49iejJc7oRTXukDeB/RQlKEAbHh+fw13P6v8Mz7yQhdsfD0YtM5qOWjGVqWZBczAjPQPLPpjNC8XkVqQpyt2fLCUBBC/Mejw5VKu6lWwSGaGh1seq6rVIvSnQaovPnU0LdwDa6JIGno1ijhlAP
 FTyBZTM5
 1a+1+nJrqKZxrrd1GPtRwbrSn2iBOrAp2mkmnoI0mDvDD7DVvb4ngRdfnbhfP+sdA0OLSEHWHx6oHTr9HpJo70XgrhNnL7/Zj5iiIFv/qccRBKjfrn7UfhXREnyEJT0RlDLwucyoWyNPQQBx3WyWc/yFyGJRWtlvHLU2OaGcVoMSiKNDAFhLf3HzuAyr+NSfswI0f5dqJUiTA70RrtjLLd7Zk7PmguxTInJ7rLEhFDUu7PfCcMvNbgtZW6UoBUozogvKW1QTmtmrffPOQPZ8hsFtTu2wwn59noKHxWoQDmoE1UJuADqNtrT8ENfl2gUiAEImMag0B5x8AMZa8Jrh6/rXsaCuzBbrM4UXnRNyqofV6T9UwYKWwRnd9967M8eELZxcTRhQ8o16EpbJLd3i8GsZpO4LPV0gU8+2DACXMXTDaNAHLvGvi3XbcKScQvbzxzTgvXgLwE2gtZEa2jipMrCI3Md6Y4ouk/ECs+qiUTYlxSL+s4Pl46HZazXrTjZCgcfj7ZE5QyllI2renwQkvVAeCHr9vKYXRDqAbaCbvpJRFgzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-04 14:54 -0700, Nhat Pham wrote:
> On Wed, Nov 4, 2026 at 11:46 AM Chris Wiseman <chriswiseman@google.com> wrote:
> >
> > On Wed, Nov 4, 2026 at 9:57 AM Nhat Pham <nphamcs@gmail.com> wrote:
> > >
> > > Is this precheck basically checking if we can free at least one zspage
> > > of the size class before proceeding? Yeah the number looks good -
> > > let's add that, in parallel!
> >
> > Yeah, it just checks if a bucket has enough wasted slots to free at
> > least one full page before taking the locks.  Sergey pointed out those
> 
> You meant full zspage here right? IIUC we keep the entire chain of
> zpages around until the entire zspage is gone?
> 
> > two counters aren't atomic together so an unlocked check is just a
> > best-effort hint - if you and Sergey are good with that, happy to send a
> > patch.
> 
> Personally I'm happy with it being a best-effort hint!
> 
> We can also recheck after we acquire the lock (but I suspect it's
> unlikely we'll get radically different decision?)
> 
> Sergey, how do you feel about this?
> 
> >
> > > Ah ok hmm. Sounds like internal compaction isn't that helpful, i.e
> > > zsmalloc already does a pretty decent job at packing objects that
> > > there aren't a terrible amount of internal fragmentation in the first
> > > place...?
> > > Should we do CONFIG_ZSMALLOC_SHRINKER (default to N or to
> > > CONFIG_ZSWAP) for now, and remove it in a couple of releases if users
> > > in the wild do not complain?
> >
> > Compaction still helps when we trigger it between bursts (freed ~21 MB
> > before the swap storm and ~10 MB after).  It just wastes time running
> > mid-swap when new writes are filling those open slots right back up.
> > Defaulting CONFIG_ZSMALLOC_SHRINKER to N (or CONFIG_ZSWAP) for a couple
> > releases makes sense to me.
> 

Hi Nhat, Chris,

> SGTM, but I'll let Sergey chime in!

Thanks, Nhat and Chris, for the discussion.

If Sergey has no objections, I'd be happy to send a follow-up series
to make the shrinker configurable and add the unlocked pre-check as
Nhat suggested.


