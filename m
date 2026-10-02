Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44928CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 17:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FEE46B0088; Fri,  2 Oct 2026 13:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0A66B008A; Fri,  2 Oct 2026 13:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC9E6B008C; Fri,  2 Oct 2026 13:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C573D6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 13:47:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4962FC0821
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:47:24 +0000 (UTC)
X-FDA: 85278418008.24.786E0D1
Received: from mail-wr2-f42.google.com (mail-wr2-f42.google.com [74.125.225.106])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7F8F840004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:47:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JMhX0hiL;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.106 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790963242;
	b=lUyuQNxh34IWeQbaT58XxI7NTG+8T4ePRpQBz951wtcQrIoZXgXCSoNgjnuJV5yhfklyjr
	+OJvF6I18qSc7YPgk5I0qZHiUsk7lEP8Vj0VomVkTSzC9zuudO4+xWBRt81GIlT/uwRxsf
	JfRRgLPSf+qs5vrU2p7Fh92Z/K8TIK4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JMhX0hiL;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.106 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790963242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsRwOVo297ZhJSI5g2vm5Aad4ipR9uH8sT9viLQ8JQ8=;
	b=Q/QJ5DLwLJeRHU22I4RgH9E8OFdWZtuBnjRqDNiJj85VtYBxLydgwv791QtMHX47GjYx+O
	tNnPzlNffDoqexYh0ejHYs1+FDm/oTmwiTNibca7trufjaDtgC6Tbx/4MJarMVyIjQOpel
	S8muWaCvdD71iWfywcdA8sxBsscl1Ls=
Received: by mail-wr2-f42.google.com with SMTP id ffacd0b85a97d-48b0622cc90so81046f8f.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 10:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790963241; x=1791568041; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BsRwOVo297ZhJSI5g2vm5Aad4ipR9uH8sT9viLQ8JQ8=;
        b=JMhX0hiLC2LIYNnv6W0MJj96X8jcG1QzSUNrtcCwbd8vDWGTT9YgUuSdo7oH34VpAd
         +iHripyiFHEgazhwzqsu4dW7cOQniSxjVQHhewW0ma+Dkv1WHrcGCDeIHCmBavFZXNnF
         43AFl+a8p84XMrxZa8D7BVnwkUT2ccg2nR8XNk3ZiLYeFqzN3AH6cbRVL3e1mNsUKDqy
         CBrF+77BVs3GksYg6edxkqRo3UEVkowdu0AYkenFR7byj8zTYdX8BCJkh+k05DN5+AyV
         DYBYj0CztaD+5qJ4M4JSJ96OGb6GWn0IeX0E3XSuezYJZBc17hQbc+j9IwuqeVw69/VD
         Sbxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790963241; x=1791568041;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=BsRwOVo297ZhJSI5g2vm5Aad4ipR9uH8sT9viLQ8JQ8=;
        b=bbHzF04b578SAdoDnIFFrKlEjc6VNbHYP0VvZG4nIkOBL8GTLFiWzm3YA50V00cEvE
         tkJE39mpSXK/MgmjPouqrvAgdFhR/Ho8/0LxsPI1s5lqyXExoYcMHX4E8R8q5O0UIlyN
         oWrsAV1pND2tA6GYroXukk+LNkcJ1ugk4wViFmJx7ZwH2HiMRQXtHAXHGfvTDe5Rt/eo
         tXl1UMAa8KPm69L2P0riTqBu4CkmDznGODiuW5+4NIDb+8FI/Y+GP2IttaHc5pCHBwZf
         zmYqjWShKcNA51IEBSfO9+cK+pQ/s9Er/ssYULjZuHmny03AEps9SsTa3N1mDGjER9m1
         lxyQ==
X-Gm-Message-State: AFq9FYLrPdg6GG5PFGTKHRIde5GirW0dchW3RIoD8XsH5roRBSAkNuog
	ACrsi5AEPr+VFPc1IszAB3QwKTDe2l0g2BogwP2bVc2OhoZ35joO3ajGhINYqLsJoRk=
X-Gm-Gg: AYBFou1T+pguMaBxXEpuTtk8pB5LMJ9x2p9RzgRpOYzFmur8fH9BAk0yifs+WhTi6Xj
	tRysVQwoVjMdt8XGFwBgAzIfji2YUfe+ynJRbfN0sF6phiCqz6V1RjtZ5iaMP7wV8xNvExZYd0j
	K2DQu2nCoRAkc1YeOovlVuzMAYNrY5Lzo6f3U8DkoB6ytLoA6j57fDh/8ZD761/H9uqBdy7Ksyz
	ffwP3/XJ+agebk+yeNfZmyxbrHRh1SiNI3UkDb0PCr/5ZoUz8Tx1l+5CW4aIj8pskZfN6V6Bhkr
	C5tIKKEpqI/K+jyUgg8U/D24aXmOiCR8Y+gJcHQp2kPFEri7Q68iRUTF8bh3uG618QOkZPSP0FW
	FJus6lHEQQEiZy2jxA1WeBKa+PQgEST5z+XgIhh8tGTGbdum/YIRdugDbw9VDxgt8usl3xZddV2
	6sVUNCBU6bcnjs71R+DcgkfRFJX40E6lU6s6JRjLjDJkJDnCsvF46zxT3fzJkNii32zWA=
X-Received: by 2002:adf:f108:0:b0:48b:e50:715a with SMTP id ffacd0b85a97d-48b1273e612mr4581767f8f.34.1790963240679;
        Fri, 02 Oct 2026 10:47:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::7:9b19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b82253dc9sm6964307f8f.3.2026.10.02.10.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 10:47:20 -0700 (PDT)
Date: Fri, 2 Oct 2026 13:47:18 -0400
From: Gregory Price <gourry@gourry.net>
To: Anton Gavriliuk <antosha20xx@gmail.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: Poor memory bandwidth performance between NUMA nodes
Message-ID: <ar_rPzLhXRSA0AfS@gourry-fedora-PF4VCD3F>
References: <CAAiJnjqz+OB+PmUQBENS8ThnWHSAFK=p3EA7KPsy5UeabQCn-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAiJnjqz+OB+PmUQBENS8ThnWHSAFK=p3EA7KPsy5UeabQCn-A@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: dtuknmbjnfbgm5cijmpdib8aim4uitko
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F8F840004
X-HE-Tag: 1790963242-39830
X-HE-Meta: U2FsdGVkX18zYVHf2DabiS3OhOfXJFNRjBi6GGNYMcmPy/P1NOLisGNM7uctsjCH/9+ZbY/iM8T7zBJzwz1bDTM1i8FfmEdEb1llI7a7F5L90lGlYUjg7WG2u1OKkkQgy+G8vD6wZMDkfIfZSg9zNivuWGv09INsBKTZI2P5xvXTw4taztbptDVocfRN8JOsBS9LC+4E1emY/dSH2FDlc3geGkiiqCcyQry+2CPAAVbF/9enTyiGVPd2iUm7goAVcVfHHXcsIT6z0Nv0lC3W4CusYPFPF6tX0PMwdWGSp8Wn/aS1XXvC6yFiresbYpFaEExg+r7mRCf7UoeBSLbDy7qmqDgIOLbYSOY249DS3v+yMjR1S4teK2YskOCWH7Uf0vUHlX+DYYM7cvrna+qOIEAtuay6kwf/8gxGnu6HzovZNy3OyJM/1pPR+gmUhB4daehg2RL49XuGXeTAu/TjR1zQ8XyjAeIsgbR+Nb7VoeBj4vljId01WUCeeiLEE6kX4baHB7GesFRTJJPKVSQGAZDAb/YA8ugXs0YYR+pFjWKVbEW695NGN6f3vbeSza5/pz8JvN1108IC1LMVRAgH00za/R0iuOxkovk0R11L4VDz2nBHwJlCUPReV3k+8/Vd0yVO2gpqAXYxaJEeRS7Wo0nPNm26aeSKM8jNmecl1TFGfd7XQps8GXYNRoxwrs7sGOeqB4g1Vb3DEXbEDis9nRbhg13kXiDN1GFTQYgjTDlg30gvxpOI9Ab+p6D+NabIqCJVox7CGY+LJL3c9+qGXKNNJplYhnTuK8v7E61TsY1uSqYD0Hp/gxo80SaRfOtqz4tkhKNaelw4wKDQbxbVaU146wpvrgHdp2+GxZoYS5XfYG14ash7gOFAGDJyoWUdzIrM1aldKg/o9lliCghfc4rE8OxpfxQUzxBi9U9fJLO80rEsOzVYAoarS1DMynweLX2Y4ONKxMDkdWUhN9h
 zhIime2y
 6T+7YGMDRQTpzHr6ibyGpsACtY10rMpQH0AW4lXQnTixt05on7IK74DTNKHvwrC0qchpMlEzfSrG9u23iOmdIcV85tX0Lye8dEHZX4XYW2v1UzbodvPcK/33Dfx6D334tl9AXzF1/K4z5Ke2lpO0/xKtaxwkpTjdAOpONQ1/h5OTYC5MXVQ8q4HxiVyI27zq0J7w9onjbWcRGKUm2vPJLQumlHOB3ABLvYRpxqTsRjxdFNqbMAwibu9dMJya5jF5bJnpF2+BTh7M8Sc1elxGmvjEcR/oh3+tsPmZPY/7nvmGsAwwY9OcQ5FesSaGZZsLuCzUj5igWDLEPX7wtBX4p5uAKrlQFdUvyof3Dq0LoXZu4GDdCxbenfXJItwLfcgthTPtbf7KsoNMr5ZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 07:16:12PM +0300, Anton Gavriliuk wrote:
> Hello
> 
> There is Fedora Server 44 (up to date) on HPE DL380g10 socket server
> with Optane PMEM DIMMs configured as system RAM for simulating CXL
> type3 memory expanders,
>

Couple things:
 - if possible trying onlining the PMEM in ZONE_MOVABLE.  This may
   help avoid kernel data landing in PMEM which would be very bad.

   If page pinning is required, then this will likely not work as
   ZONE_MOVABLE pages cannot be pinned.

 - Optane has like a 3x worse write bandwidth performance than read,
   so expect it to be significantly slower.

 - the stack below would suggest it's likely the folio lock.  You may
   want to check whether the folios are being pinned and you're just
   hitting a wall because of the temporary pins or some other contention
   on the folio itself.

> 
> 48280162400 lost: 0/0 drop:
> Overhead  Shared Object                      Symbol
>   49.82%  [kernel]                           [k] migrate_folio_unmap
> 
> migrate_folio_unmap  /proc/kcore [Percent: local period]
>   99.52 │       lock



