Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC9E7CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 14:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B53E8E001C; Wed,  8 Oct 2025 10:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03FD38E0002; Wed,  8 Oct 2025 10:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23178E001C; Wed,  8 Oct 2025 10:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD0048E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:18:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A428CBA57B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:18:36 +0000 (UTC)
X-FDA: 83975152632.09.2C5CBA6
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id D8C7640016
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:18:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GvIZtXz1;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759933115; a=rsa-sha256;
	cv=none;
	b=eg5Rno8zzssPW3xwGTiqEjA1xgzrI/w1T0d9u7N3tTcQn9criyVzLsRYHn/S68hN8fQeQY
	HLXTFNOEZ0uenzLXVfIO8hIPe8FIQPckqCMWB3Jh1li044J9eDb/ESDltxAVvGQMN/L4L6
	Z/0/aq26L0Si3ZiGm/HssJ31DsilQiE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GvIZtXz1;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759933115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5QJIQKG0sT9rZgBfipH2pnXvFssK3HlZCOf/vlaj8bs=;
	b=r3T4uuZjLwSpywc/DRxDyQE6gikA3fucw3QunlXDS4cxZ5wIL97K+THs84zBLifbgamnX0
	pXIWd6zaln57ifkpJwZny9LVB/7tZ0eNrzVYFqFexVVOXCduHlEmVF80WHX/iYAocZR0jV
	+M95pMmiT9ZwilHBwuq/xqlmcQWmCYQ=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-87a092251eeso11178456d6.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 07:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1759933114; x=1760537914; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5QJIQKG0sT9rZgBfipH2pnXvFssK3HlZCOf/vlaj8bs=;
        b=GvIZtXz15YPyzE1u+ihHkG0hhVfoexQJWrAnSDy6V69T2t/R87nBxmwg1OlVkEK1nG
         j6M57V8H5nMY5YMiEhkK2JkZNOcH1pQj8q4JgXkcS7dZ/B+F3lQr+LN5gIL2ySy/8Xde
         KTS1iRSdPx8yB5I+fprNn9my+X1tL/NrWYdsLFczycdjzczmb1T5l6Z0+oOYhliZo9Om
         Nnam8VrDYrZJVpKM9qcF3EP48wsSSB+woYhBPtLT2LFs7eHe9fXxvkqDCaxgp14Jr3ps
         0DEbHtsDmaHPdUfpwVS3C8UYkdXNsrdsOFC80dwevEPfOXXYHGGcyjvposvH846sBCqF
         18Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759933114; x=1760537914;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5QJIQKG0sT9rZgBfipH2pnXvFssK3HlZCOf/vlaj8bs=;
        b=ZiKI9kuVlBWAvjYK2spfYO9V7GFiZzPTYXH4t0rWCOIruI3O1/50PYWSXltGjYydDY
         AnqE8tGNywM/YglhRdu8s80PCJwjmc4J8s7QSphB7EKbMBm7xUXiMOOJuXMeFXlPXYpw
         9aCEaS5RjjRaFiVFCQnq8qDhMkGNOApQ3TwrzRySbaL8sTO+/LVspCM5kLbXokJkGmFU
         lRdh7JU2ppzxmjyoy9osuQJJNoe/6LRwOyot30tzEug9rH1S8hgffCpSxGlCxDK5YUUX
         CVeWrIDXeFfIKR/UAFRRFXIIwXeXkqReXKgbDtFIWXvhOBvk8oYLH77MW4Z6aWnGrexT
         8qtA==
X-Gm-Message-State: AOJu0Yx20AuCG3kF1ZcaTQwkN5gUL+uNyBSm4qU5/oo151gnCuYO0YXi
	+bGEI6dh2cmRuJ1FDvQoamJhs4I6pnKx1ufSYCUl+8gbCh2pN5/hZ0zUW6euUJ5d7k0=
X-Gm-Gg: ASbGncuZIdWtpb+FGkJr32doP5LdHMre2TpwX6TgYUrxG3S1xMCQbYfBbqx9/9k4qKW
	fQaRekEOazKKFOVA93avxXwIs3uuMob8sPP2ATtiSbgkyVzwqHIFqhS3xcBjHIwV4dXKk5m5ish
	Y60CFXxb9PZjb+IDtilkOhTHzdIflxfDbznOyoZTaqGTW6X8CaSwNlNGbJyfl7Vmb6uasQRh0u3
	zAHT2pAYrCGDl1M1dFcNV4TUP6Oc3yIjXDuH/9XO6Sa1h59oOS7ohHCKm0ur49SjbSfKTbo4WJm
	cug7MXgFNVzTmnGgTbuZc6Nn+bGEbiRf2JZSYTLmf+gGSBMzQTECiOrAZqeQbraB3/Fz6rxmmFN
	AZA43neWvBBzPMhyqU5m2u8aKOo/Y0v8IKmcrTO2Jp/eMNcVbjC6lKiccVLeM13ADR6DedudJfm
	XVNeSipxMnM9EoUPWh0AgWRulh2RapK0L6i+XQqlIt4GO7sFdIWEw=
X-Google-Smtp-Source: AGHT+IFNKG/GrbiRc1bEn8TWwx08M4SbG5dcVn/TJ2EzZl4DHVGIFZ6s6jij2fTulKfOfOsdd1koyg==
X-Received: by 2002:a05:6214:2027:b0:802:67ee:bdae with SMTP id 6a1803df08f44-87a052a63a4mr114908286d6.25.1759933113566;
        Wed, 08 Oct 2025 07:18:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bdf53134sm162645246d6.55.2025.10.08.07.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 07:18:33 -0700 (PDT)
Date: Wed, 8 Oct 2025 10:18:31 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, corbet@lwn.net, muchun.song@linux.dev,
	osalvador@suse.de, akpm@linux-foundation.org, hannes@cmpxchg.org,
	laoar.shao@gmail.com, brauner@kernel.org, mclapinski@google.com,
	joel.granados@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aOZyt-7sf5PFCdpb@gourry-fedora-PF4VCD3F>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D8C7640016
X-Stat-Signature: g9x1zkxejap34z94gsxfy8yg131qjjhh
X-HE-Tag: 1759933114-313455
X-HE-Meta: U2FsdGVkX1/KM7I7JWJunm3vtjo2bVkenq2T34PmurkQ4s+Ku0Wf/ixIG+5tdLm9xfXBMOgFTt6sbJvXiMPKxpk5rhoWfWxORzYv+++TBTAQBS66pktz6OegNhO7ayGBZYF8Q2BGPJRnfqIJhl9o7er5dLbs61+1VtBRm8D0gDybiDqRl4qQmxTstjxMBKKVBw3V6iXFpCiOrk+d1PH6MckXjRpoArbYCqJHRqtOkPl+d816iGE+zpP+GHGHh08OdMAX5hdgn6XqZ/D8Q3CmHwY14Hwsp64vayG6qU41hYc8XiAD+zJYk/h88uH0B/1RmOWd/VfpBYEV5UOaUaL7bagVwzbdJk5y3ZsevxIAE5Qrr7ZXkUIksLj1yhYA9H7EW8+iN/f/BgnfsFr2gUyD6H8N+ECAsF1ngPeoHX+lrfaARC75WlvegGj+QIWwgatLWmK3aOTKsxHZccWTBbhBQK6B7z/vycc/r0zWPQkGy84OrTVNtL8TxxkP/2zlY+uoaMLSjQ/4JCdfsDxBrWKwmy39TS0/nT1iAOm5YHq42mgk+IzMZeIhvLKaHoE8WlsYgGxrwHiwm+njVQbA2NkzvKBtc1xnvVdOmENeM8zNxbVOtijlMT3Y73c8QWQSxtAhSxGS08PArupmaDq3UdLVSQw9SFd3WE6LN4m6dzudR9QZNjvSJaKYD4vJqEnZMQIYGo+L0pUYOYgbg2dIZGUuUSB76HLymGZ1kIdpgx5T5vFzkInFcCgImOxZHj64u3oU6eU9ca7W4I/tfSshQO5AAdMiUiRUX3DLeoT0n37CGwn35VH22YC55/KPqP+2TdwVxwmBP/UbEBIz6+xTf9SqYW0lQ2fRQdI3jQXjA9JmdkvRLt5PySNlHEknPt6LFtosF6HBXPGEUFfqPQhcCU0YS09EAtshjg1/eCdcmr0kq1Wg3KGZGlXt8hjHQ3rW8+0tPt8g8YiplTztJ8d5qTy
 xH410FDx
 BuSKvry8KYNZ6iokbZZeYihHQtCQQZJ4Jt8UkMnALCqyha9hDrkN8lvULluTGiKNETey7zUDWtnlKwsJm7w3ciwaK+7IJuLCs75tWATLO+PDi4wFbiUifedLk9MxRB0QSv1gMtpgUTqWDsYwAEwynGmAlUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 10:58:23AM +0200, David Hildenbrand wrote:
> On 07.10.25 23:44, Gregory Price wrote:
> I mean, this is as ugly as it gets.
> 
> Can't we just let that old approach RIP where it belongs? :)
> 

Definitely - just found this previously existed and wanted to probe for
how offensive reintroducing it would be. Seems the answer is essentially
"lets do it a little differently".

> Something I could sympathize is is treaing gigantic pages that are actually
> migratable as movable.
> 
...
> -       gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
> +       gfp |= hugepage_migration_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
> 
> Assume you want to offline part of the ZONE_MOVABLE there might still be sufficient
> space to possibly allocate a 1 GiB area elsewhere and actually move the gigantic page.
> 
> IIRC, we do the same for memory offlining already.
> 

This is generally true of other page sizes as well, though, isn't it?
If the system is truly so pressured that it can't successfully move a
2MB page - offline may still fail.  So allowing 1GB pages is only a risk
in the sense that they're harder to allocate new targets.

It matters more if your system has 64GB than it does if it has 4TB.

> Now, maybe we want to make the configurable. But then, I would much rather tweak the
> hstate_is_gigantic() check in hugepage_movable_supported(). And the parameter
> would need a much better name than some "treat as movable".
> 

Makes sense - I think the change is logically equivalent.

So it would look like...

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 42f374e828a2..36b1eec58e6f 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -924,7 +924,7 @@ static inline bool hugepage_movable_supported(struct hstate *h)
        if (!hugepage_migration_supported(h))
                return false;

-       if (hstate_is_gigantic(h))
+       if (hstate_is_gigantic(h) && !movable_gigantic_pages)
                return false;
        return true;
 }

And adjust documentation accordingly.

I'm running some tests in QEMU atm, but it's taking a bit.  Will report
back if I see issues with migration when this is turned on.

If that's acceptable, I'll hack this up.

Thanks David,
~Gregory

