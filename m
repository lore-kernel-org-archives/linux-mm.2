Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62C9EEA71A1
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 15:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1826B0314; Sun, 19 Apr 2026 11:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9E56B0316; Sun, 19 Apr 2026 11:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5D36B0317; Sun, 19 Apr 2026 11:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A23216B0314
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 11:12:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E0221407A2
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:12:49 +0000 (UTC)
X-FDA: 84675647658.23.B7F0234
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7A97D4000E
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:12:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P+umiAyX;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776611567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVSK+fsISPqluFRtt7h7ZDht/v+GA+OlOcuuAUGLOY8=;
	b=1cl32KTwtXWJNTm6H/ah7zx/Pg2ohlDFaQB6+hdSXmB+7uSm/wqn2dlagg6asJqf1zVrUa
	KH3y/ukxwIL32PWoCjz1rFOewfqDNafXWqjnjAb4xMaCj1Y2YCr9dtUyiuVUM3STT7itCv
	gpM+4ek3S/ahRLltbx4Q8MTUNNmFfH0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776611567; a=rsa-sha256;
	cv=none;
	b=CPaC1yF5DQyGqwxWmQzJXx/tjr3tPTCJ4GyC8D95EUraihZE3VXVP1oUBaLvbsHOMDFbkb
	s5rd/koUFrExt09XQ/eld3Q99uRba+9+DRwmq3tko5LjLt5ac/SmNJ2YXyyqjC0t/lDcna
	lermMlrim0W8oyS5NJmL9zauwXw1AzM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P+umiAyX;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cb40149037so232574485a.2
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 08:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776611566; x=1777216366; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FVSK+fsISPqluFRtt7h7ZDht/v+GA+OlOcuuAUGLOY8=;
        b=P+umiAyX7D6grgVIILHkwtfgl709G8H29kizndKd/WG3uZi7EGtLiGehmJCjcbeSeT
         xiZU5ShsdXxM8ezfY14/exIFb4uA/Lx5CLBCaW/ZlMqyMs2Ip8RH9lPvDFLbQSIFpHXu
         CRkywU8r2SqDzjFMF6aUOww9apYp40PV4Qh4HcukVZptVlinJO5F5oio/qQPCg5GquSm
         KqUGFCtnQ+OlWClTin8G0gxxdhyzbnzYhfADz0YQapvUrvr8gFvgkoKoIj3t4/n1gGjf
         XFphpqoJOmkzTYkWtTSJiPaUrMQlyoB+jYoJ5Gxm/4MbRVfJXJZz2yp051HoErg17zjZ
         cb6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776611566; x=1777216366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FVSK+fsISPqluFRtt7h7ZDht/v+GA+OlOcuuAUGLOY8=;
        b=lCPQwCuHxdyeGNGwIPbyI0PAZPLy6c2pJl4MKpREWz68KdegwWYAdk6iMU/KslYb4c
         RjEoC7IhkNDRIk6EWlL5aRuDSVIJjaKst6SThlkKy60nuHOV/TCzFHjvbG6QbIZ68Qcv
         cV7hcG+3vjrNoNoxpBBkX4IBCCIEjwtFJsXyVbdehs0xzKDrE1mi7oE8fAhj7ZgT+o1M
         iyLDdMDb3atODkFMhKfoyN3pUobqRyMjW4xds/Y/YG7m3mrvpNw4VJqB2p6tiG4LJxFJ
         wBbfYthvbpWWZUtVOXsL4Izp06P7pLntQOfwghPk6kw2J3Vwomyi8uCiKuxybnNKBC9F
         a2hw==
X-Forwarded-Encrypted: i=1; AFNElJ/g8CvTVyXRMNVYAvycGKLyq2dzwI8AobxMFY9AGl3U/m2kvk46a538cX3owpOlQnwTMOiB+jlGvw==@kvack.org
X-Gm-Message-State: AOJu0YwrGP68pHe84XJVPhlohOxJ9frdzy0nJQg1K7Zs5CMPYCSLH1nK
	s2DL0932vFELtj9sklGMwQOmlug5XeRzGfzO1NX8XJBfhUO6o7PxGQP235r4qjZpyts=
X-Gm-Gg: AeBDieueRsTSvZHahAdBBqAjnMNg4yJS3gZzvWy0WN7ZMWpe3UoghKj47px1cpgmvkS
	pPpvTb1Tcgijd5PVN1CZlSsV0wKJG/QJikW43ANG1x4MDk/X7HPUFtHNQl/7TGHRk8q7SPeKObd
	uFFJdEEPxm1Wccz8sNlEj5uG7BMDeyoRA5TGJabZLgxB2AhphTLcGsPAUWqnAEy2CeisyftCYRh
	eAwwdqcotO63zNptCjWNv2p2kHXquQjJ/n411rlp7jag7wfvCd6owYosRpLwPiEC+KPqA2BgRNc
	/ZxH92JPMGG9hqFbD+7SoQVULM4lVa1AcBFupQwRYYTmhQHvhhHaJl7/4A5+umvrUG85xWj+3PC
	d+LlX0QD8Kjd5sagM9qcKnVd7r9Fk+3gfbVUtyoWK9bHw5JGUh40rfHF15LktVkf6+GgyHIaVp1
	FzpLK6/c6AC6Nh9orKFZPt9MP9MQm2Nrj5YaPmTwGeElOBMBNMizu1lbFVhBn84U9YxUG30xY=
X-Received: by 2002:a05:620a:4015:b0:8cf:dd93:acbe with SMTP id af79cd13be357-8e79040e2e0mr1477924585a.24.1776611566564;
        Sun, 19 Apr 2026 08:12:46 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d69ae320sm681290985a.20.2026.04.19.08.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 08:12:45 -0700 (PDT)
Date: Sun, 19 Apr 2026 15:12:43 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	brauner@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 6/6] selftests/liveupdate: add test cases for
 LIVEUPDATE_SESSION_GET_NAME
Message-ID: <w2z3mt3ghjmcejgzg75hsgoahvmzrlj5jls4etbm4z27mtnzgr@yldyrgmjzul5>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
 <20260418163358.2304490-7-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418163358.2304490-7-luca.boccassi@gmail.com>
X-Stat-Signature: 4153ed8e7ekcjfeue185uqxcx3ctbwjq
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A97D4000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1776611567-474106
X-HE-Meta: U2FsdGVkX19sLeAkrEAENB/0PUHVl4LN7ygsVZRtdYX7tJ29K5iLjrqMGNAjLMiHxeIxyYXRrgJnRjW8/WhSD5dPHNotAgTTjQkqJGQFygxZpMH7K7EKaUG1GQLF9Tj+iP+2PRYS30IyueTOFxyOMU6IgxUk7WabYu7a0CaxNP9weT7wvxfDp0zVRhMff3/DZzFgYkrhsYXVeFYjJq5ZQExGQN6xGserJGpWqJxgu2cMSbRLR/AgM0WtBJKNDHHUbQIdMqgJ6/GuqFNTF7tVn4Vio54oYvscNkMcFsTaz6ltkXG0srtGACqKOlyAVLv4Sk1SwhH0X4+KnurOQ0+gvEqO2aQeAAS8JA3zijg2SOJ0MxGv/Qh+WXqUIvevIvanVysXCX3SlWOFjNk1OuVpj1HG+OCYN0zaLiciLL7H4ovCv7aknCgyL2TsAXj8CfLVsL7dKbySX93LB3iRgjZDXI1mKHR+1yBzfZRvPHImwTAsHDaPNsSO1yMzE+E1iIq6Ea/wUmiNRD6+rKrYaUOSMetSnVLMTDZxwjf56DBSbmEuD2nxXUKuBtp5BekGNBqk8cIj9/8sb7TyKpw2EqV3BbHAVc9YtO2K/OYdU5cbQweFbAgdBFp/X3jnDe+eVbtwXV8P+971sSNQPSwfjFjEVWy61vZLrEKPR4+jXeh/z+hsaK9Qy/cYyxXWj0GbbfJm1rg+dSKFN3b36Yc+7p1pazpH5E27CY7VhO9fQpmTxSvSp+We6+kgWYUTDQpEH3imsOLIdCSaxS+pg3JK9/9hG94DkmCQk74wRgo12Fq0fH8nGGdQBlMtnPnO+l0XDZqp1Bk2ZgKZtlT/YuEOL1W5lguZh4VABL2SNcd+9pJzZPAloGgd5QjpaE6+Ro8OnVVK2xG7EUZG4TI6l4VrGYSwJhd3Un5B7sZE9IdtWgu2h8MVQPw1GlVPjAnH/OSYNnsVJxnNCxITNNriYy2fWdt
 Xozp91Y6
 g9niDsQ2Rxm81ONsm3dGkEKUD/InrhQCCRfOJexM3YkzzmEea7utOurYh+ZEbeUFAoEdhJZBDd7BD6fbta6oximgiN+TnEekcd0QgI31x+fwxjmA4x1BSpmKsli3GxVC06hNprnwvGmyEW0MzbII0CRSyZhozpre7rpTIweywz/r4wXLAEJ9L+H5FKoE/8lcRwjnCynay3e0W54+IYZmtTJnPDijEtwu34bdlUAYUqEkdV8xdScQmIeTuWu1KqgKRdGPkbfJOH1QhUxtP7b8RKc5I9DgCCHtFPvqd/qLuoGs4dCbSYDnokc92Ibud+p+iz55D3k52JGjN09KEb5uqzr5J60NQFfdEzPR7NSauFK07Ja0oGCSb1oGYCLLoWmj57lcjYsbyd2EZMyPp3xCL1C/aYhoXN7y22gWRMxks4YJDXJ0YGvaDCl/6KKUGFMUnwYr/J8cEPwuq+SNzSEg93zJ5lfaV+BDb2y/10IJGYPbYtUFpsH5B59so52gzEEXmGRpYuwtyjDOx8sB6l/bb/WD3KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-18 17:28, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> Verify that the new LIVEUPDATE_SESSION_GET_NAME ioctl works
> as expected via new test cases in the existing liveupdate selftest.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

