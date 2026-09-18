Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9D9EC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 05:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35BFE6B008A; Fri, 18 Sep 2026 01:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30C286B008C; Fri, 18 Sep 2026 01:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FBED6B0092; Fri, 18 Sep 2026 01:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9D706B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:12:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 671E5C0539
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:12:40 +0000 (UTC)
X-FDA: 85225712880.13.CAF36E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id AEA9B180002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:12:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ftGD2pL6;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789708358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8DAjgtMpLNxk2yHd6b1u5Q/Jby6PVUAZD7m3pX+Fo0=;
	b=8X4guRWNo24Kk84NI0+MHw7bhiUuopq1M7sgxFs/7sscVEj0o4s/6C3xiI+gUnRnJ6ykpp
	4PdQc8cKqtqtcty/smNu+N5FzqUXOVlRodPX3DmM8uQ6Dmm14REF32HAXftgJ/5E1eEUag
	aGtBrwwNGkl96dgnedqoFlGEkxGhYeQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ftGD2pL6;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789708358;
	b=o+S01Ku4qTbEQGL3mI3gDtCqlZqQzrZUj5Wq7FV0F5AHUBGVEGD+jwYB/9AbhS1CjhQwm1
	DPsM5EXlB+b8B8XVJupcBy2Kye/CIgmEkJeX9IvfgQb2M1hrNODu1Il1U5ZagMkIM9/r4t
	doikRdaWymreCEQIlnKls3D+tKXdEug=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB356601EF;
	Fri, 18 Sep 2026 05:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2CC1F000FF;
	Fri, 18 Sep 2026 05:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789708357;
	bh=v8DAjgtMpLNxk2yHd6b1u5Q/Jby6PVUAZD7m3pX+Fo0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ftGD2pL6l8DDm3npLoR/clYJ/KIxDffb7DMi1jjtu+pKopAvRHU/ymA+va6vw+Q+c
	 igu0P3dUUXSU/Y3JSDQT7BNUsGDapsFCjEZZmapi7ToJZzF+N+SN6oeeu6DSzasJ5T
	 uP2JVig55N4OVaxNIfzj7zIv3A9Cf4amT85F31wo=
Date: Thu, 17 Sep 2026 22:12:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
 jack@suse.cz, tj@kernel.org
Subject: Re: [PATCH v6 0/3] memcg,writeback: flush foreign bdev mappings
 separately
Message-Id: <20260917221236.c9044ddf154e1b757b54d8f6@linux-foundation.org>
In-Reply-To: <836b5192-ef11-4f16-8c90-049d570959a2@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
	<20260917155305.7a63e01ba3ed34ed0aea537f@linux-foundation.org>
	<836b5192-ef11-4f16-8c90-049d570959a2@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9mddn1pi81uzttc6qz5pbtfzwn77sf9h
X-Rspamd-Queue-Id: AEA9B180002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789708358-469078
X-HE-Meta: U2FsdGVkX1/IRSBt4o17rPmC2TS6a1eEcOQ80x0rbwsBaIC/y9l4pGFxXEOOHkgAvvkrbKnWud4rHzmB480+qYkZjO1foiBmmoLxNJ0WrI2TuFzQeRg3bTrBdRp3bX1WvbxNqPbTU99gEsG/gv34aFf1Qp7mxMULfeRXkDSlYFmu2dPS/L2j/xGdRYXrlNGiGpl0fgto7oLFozr2hPyOsuZ8/Oww78y6qMogsyb4kpstzkwzoaVGANKmx7CMf6n8me3Q4/hY1mn9+ZetS5k7p8gnkTfY06eueJGAoT38JQ8q3oC81giV/yfG0Y50Z6oaSKB26vmDTCJpG0IOIWOtari/aI0JwMMvKi8g+lTbtABnIKInZ4oXV5k5cu97iqNcOVC+foDcSKl+RY3cNTW/IsVoQMHhuf9iEFKPX3YPi7IgSxymJkOZRGnIIyr7zfUV8Kae7L12kz1hqdbjiheDNRoizDZ1Khx1YWlDPkb2ssKjn9fsy63C13hgCpA95URNYaKB01qRyYuRYATIU+W4VNS/jgNiiPzwj81SgwS7xd9k4E/x3Uh2P+nTaeeTLX2qerQxpaMT3QtZw4soDanevDhKYloegL1qiGBg0G6bBPgsPp+/kT7aDRkDgSBzVneMy/CBGMz59giExSqtdmYAmcMk6Jhgsj800IQfqhOouxn5jgG6F8OGFnywmaZlRK7BNzQTAJjgPpn0oSCEGXjHd5FDcZzW3JnP6X6SDkiHdT2ugIXAWg85JpGNg4KdtP2LE8ubZ9gTsokcU4tqDq/yNsGs0OHjwHsDGt461FNa58XdgDXH5mXRaQxSjboohwFiREudPC91iSu4RxjUbu4DdpswxzuNHPAgcH+Pz3c9Cy0CgzhABxjoUkrIOr+K0qRz6H4w5fFQrB57RcSGGp7kalJMXIfnQOogccGjQaOcQ7mI5s2vkfT4rfrBFGS4m3iFiiBnWhjtiuRIXZhS+6G
 kUQ5I1Nn
 2x6E8xxie3CGJyGj5745HaWWK/bnPXZ9OMdPRp50nMOxKc5CQE0IuAyjTSrgfC1WNbKExqWGz6XWngrZK7DTML+S2TeNmdqr18O5FULfLwUl56uq+B7A4pJ1wTzOyfwxxYXZzwnJ0NcYQYNP/Z3CfFDZZ2HhM8ZW3zFbATrNjjfkl98pXiI9K8jXS2pJ48wxI4LNZbFja7u/32fekQLN+ja3wjteUs2IzwTF09Bp5IwMILFGlMVBld3345eVTBSmn02ID2jOKcUQf/uhXTnbCMFPooA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 12:57:03 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:

> > Also, and most importantly, what the heck is "frn"?  Would the world
> > end if you did s/frn/foreign/g?
> 
> Emmm, the naming follows the existing code. I'll rename the new uses
> of "frn" to "foreign" in the next version. Renaming the existing code
> would be a separate cleanup patch; I'd prefer not to mix that into this
> fix series.

Well crap.  Let's stick with "frn" then.  Renaming everything can be
argued about much later.

Shall consider the rest of your email soon, thanks.

