Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C42D7606A334
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 06:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cem7dQAN
Received: by kanga.kvack.org (Postfix)
	id 9F25E6B00EF; Sat, 21 Nov 2026 01:54:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2A26B05B0; Sat, 21 Nov 2026 01:54:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894416B05B1; Sat, 21 Nov 2026 01:54:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53F706B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:54:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 247A98036A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 06:54:06 +0000 (UTC)
X-FDA: 85458211692.23.FC7C3CF
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 54DD4120009
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 06:54:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cem7dQAN;
	spf=pass (imf29.hostedemail.com: domain of thehajime@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795244044;
	b=SidUT2782JPWc9e0nJxtdkEcUAL5rlBp0VnBcjBrAV294oF1pzgZAFf/SECNIu7S+qOQqB
	Re0gUkbxS+BuU61bxTa3YhbCKWUI1hDBP6UXdZYTC95RFp7g17UviWeryYtSqJZdT1YPyW
	u55tBi2cjSeJo3anMgAW5zzqq0oXXEc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795244044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOcn2a9o95bTTvR/d6VT1xfcJk6ReR/3XyMDIzZArlI=;
	b=Wgh00OZZvcb8mCvu7L76NHXYYUFBeDNuPm0+IAPFrHSs0z2HGJ2HaGdJc17Mnd6bjLdaUy
	v0c53l9LL2Omc+46ooxDVjipjeT6spZE2h9CZXsQSR081mdroo09VO39EtWAFeVOCd+zjd
	eOxxc5gjBWBjXvzjSb6kfL3G9aGxEzo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cem7dQAN;
	spf=pass (imf29.hostedemail.com: domain of thehajime@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1a2761c69fbso3417775c88.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795244043; x=1795848843; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MOcn2a9o95bTTvR/d6VT1xfcJk6ReR/3XyMDIzZArlI=;
        b=cem7dQANE/fN1rR+wDDLW4UOPcr99HA7l//Hel1uxeO0QbV+QybxxqD0p/2fqwCfoq
         bHajIuFoX2oSGlD3t51/N45k6SaUppcAAqPzl8svJjqq0Ams+Ts6pnMnm+8WO8TcDN1L
         mjg8Lmo+Zlo5gLo4cfDWLzsmi8TEJmMF0l1Y4Fmw+MLgJOwGgtIvFdT1lO5EfVjdRBfo
         ySH27Y3anoVqYT9XHzumqEl1I0Ho/Rbm4x49YgwkJcHW/2pw//uDGROwAO5rsvw9+IwL
         pwR+Pz450Gs/ugS+MBDRaGQZdOy6hsqBYqXciYqce2LSI5l6UGOUwQLSWbwDJ0kjQz85
         WsfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795244043; x=1795848843;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MOcn2a9o95bTTvR/d6VT1xfcJk6ReR/3XyMDIzZArlI=;
        b=ISXrTYepY8FxtsPyGYaBXJeIIpoYeMY+v1A1cBbkH6yP7QB6Joc1DtlRJDPZ+oj6sX
         g6BEb2+RodEWFe3ObXG7TjCWu1l8OSRU5xlYpt/Aibp5uZfzDnoMuPsl9ve6OwgTJ9ky
         w7PcaM+b1/SQ1hUdvDPN9i/sJ7eHH0ettusTbujX/UuqPg2gN6+u/4hrNSUdlynJyCzT
         3uc7gitoIDBCQNl/GOt4pkgOCVng3KF7drmP75si1bInUOR4X5K7O7MaZQ4/EQJUny85
         heAZj12YHJjVyAOXCOii52wCt1ddxtAYBKtbP9IygPyuEEdI1nftc+tNMVa8tvMedwTh
         d6BQ==
X-Forwarded-Encrypted: i=1; AL+hErG/c7DpHJxupIrCDepv4IEvd66OhxNTnVXdn89gRKZMp4uQUAZp+FqL/UT70WuftpsKxVC+NqbEIw==@kvack.org
X-Gm-Message-State: APuU4Z/rdvi0kz2xwavnCpXEgpBVlH72mEb2WnMqDWUabEHC8W2c/tNj
	LR+rbTEHUghv6uDUQ7rY2eeLzzCLnSDs1lqWMB1rQlnT7+1zAgP351z+
X-Gm-Gg: AZFdTZc1do1uO/B53gFXEipwlSjQN27pQGiSs48+CdWdVermJRofZ1VrH3ngfkUNoZW
	awOYVnGXDNTGJWRxvwbpBdHToLo2UCpjG5R4KAB9TWcZZeF5NSayVq8jl0b62teDKQWVDL2J0DD
	f6hwwnfaOjQqk/XIjKVGFFLuYhFq9I3i0xMbah2AxMcfDNhzwu5hKUK9tp10qwfkmG+un4/mGm2
	R+IgEenDbaZRgjz0z10vGOHH5T4Fq8XcY1XcJOGaY53VoTtGjx8LkCy/9PVNXS/FCB/fmU3GrWw
	eNNaS6ZmdilY/njyGuAmvUVH35rgd4mwMUvZo8QAdl/EOT9LBXsOoAhzTJLroCoC2aXnhObxI8J
	bZrkLX8VYfTayezP9QbCTn7JW325fI0W27dZq4yhJZqVbQgbXlW5iCB0+VBduQOQCYbI4tUAdud
	FEcTQZgL7EAR61SPNBjKb9BLBcdVGvC0nF0EZX5p3Y9nj7bmD8Zn28NeOudRfTI55UwAQ2MvHXI
	1hii8SAmWGDt1mFPtYK1a4Bq+qlG2FHb9mOx4t3JN04ObR5BuzT57mPkvj9y+7lIGSECsUqCZ0E
	6WyLH/ACC0awwfc3KOhTTSPNsq0Oxe27O2O5FZ/jX3nC1alFviQ9fTuN+uu1A1AnJSUWnTCuNCa
	AiuFDTGZ4Dopjyd+dlOLGmyYEOjYH3WZGsZk+HG9TES2gJfribUEsCA8jVpGHw51kfMs+Yb1gWH
	nK9fm+nuhz/tiyhVPILA==
X-Received: by 2002:a05:701a:cc85:20b0:1ac:f84d:403b with SMTP id a92af1059eb24-1b5568bcba8mr5469021c88.8.1795244042878;
        Fri, 20 Nov 2026 22:54:02 -0800 (PST)
Received: from mercury.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b562a82b3fsm5852102c88.5.2026.11.20.22.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 22:54:02 -0800 (PST)
Date: Sat, 21 Nov 2026 15:53:58 +0900
Message-ID: <87wlq6smih.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: brad@sim.vu
Cc: ljs@kernel.org,
	liam@infradead.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/6] mm: nommu: fix do_mremap() to correctly update internal states
In-Reply-To: <20261120221021.789792-1-brad@sim.vu>
References: <m21pc0qquc.wl-thehajime@gmail.com>
	<20261120221021.789792-1-brad@sim.vu>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/31.1 Mule/6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 54DD4120009
X-Stat-Signature: k7n97op5xjznx4txtqqdezqg93mfw7sh
X-Rspam-User:
X-HE-Tag: 1795244044-731470
X-HE-Meta: U2FsdGVkX1/3DBH5SGmj65ryysDVJY8HJaJkd0FpURND154L7a9edUIL63UwFoWsQXfYwT88g/161PF/sVGld7zQ1XRCxMzLqWh2Xjta7tEN9MUWRkf6YD4VtRYprMc2My/cOUiNkude3C7uozrPm6VRjIQjRBXU65FCyH8wwlasYdvK2npaevsTMfnVuIU1mcGJkgfReIZpcssbh9WrlCvjPMvapcbEbqesNup31S0hWVTxifKNVCFuVF1PJZmBFhUCOBDFrTCQqGKxURN83q3LTep4nbOWHHamzTU3RSv58plhcAqOInUS++Fglfm4/w8cO2/jMT+n6EgvAp5ySB/a8+a8GnPrcGVcnn1vZcrjtk3IIrlDiW9UaKmDz/Q7S8J2rthoyrQkoCPJmvjFSqO/m9afrDQaRxyursi3VoLBr9+Ivg6CiI8jvDom8QPNtJOAMcLLYKUeImvbkpQxBKK0FW16qJET1P5a3Gdlq8LcHKOmysehc8OAXIQMkSxIQxtjBn5m9/frCzgZiaFdiiR+hEX+J0eU11Nv7jsJp1jhRDHGWElhDxqqe4lEoOrpcvJPMqR/aL+vzhVFXxmntJWxAWDBr9OyBj0Q/vn7wkVNBFSy5P56TYNE9k5JOJk+q4efs84o+QSKE8RHdBQd7UOchxAEblv9fvu4HipgSj6VDpC2o9v17YREpZkG6cFBY95x3Feds7VC4B9U9zRFWTnJm8RwEgUFi6kxp7AhOVt4kwzaaON8TzBRmLlSx/RacJiM7/9PUWqe0yvb0uxN6xs5yI3pbx4uAo7NxcV0EnhMC34xtG5qy39R5X7A7x4pnGGVBqDePiIrIklIeg3K0o3p+YZQX7RS43iSPIPztn975YhaBwV0LgkHN0njz+JtuGxSENaP/siGCqhvIX8jCt1pTgtpJQJ4+xXNqMGB3jsWhvdMsX+gEEuUXiebHKCfDfgUW7d6ZvPBlyVffzX
 bQ8D/igH
 8BIdJ/Tsqpfm1o6CYLPhwYUfC8zp6yf0/+A7WkOG8mFIjj5s2owBgSmeqeUhPyJn6c5HYFii8bFh2GuctbIKpa0gCmTc4htwnulQocNXRWkqV8tzI+0SfMD191I8nCOMwJ0yG3JRWDCb8mdET2eZquDgBtYwMaV/QcYESD1z/mG+/uew9a6iaRJxO0w/cFXvw/sGRbihbm0qLHbrqsGMjiwcbPsr3Lf8FT24wwpj4w+BGlKeaWw4LtFTr6hB5UX7sCiaZUkFlRwqiE/VGErEvy1qnawz7JFQpN+q/3onDFA6RTlVRLIUkCovs7ZB852Y/skNg8l9pCYwtfApVViiyrzDTish8dFI+MtzrbCblGf6OFx+LBNJUGaGnORowA9GtDAP6U7dNLxmLHre2ZS9SHuQBneuuhS8kG3giUR3w3ejEzZugRzy77LKrIltnhRIRe4V/Et7H7GwFHwp7M5fRHMPh7D0aHlD1mzLCNuDUZ+g03oA2uAUs0YIXmysGW3K6HzGdsYHXPVjeyooCJCxMeZfBDeBl4IM0lEqUiQvwxD3//8F3mSpAllsz8HfcxHxVB2mBJY1kyFwbmC8AfESD/kK+RxLL78eFr36RFu3QvgnuF2vaUCuNyqdZ8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


Hello Brad,

On Sat, 21 Nov 2026 07:10:00 +0900,
Brad Hawthorne wrote:

> I hit the do_mremap() stale range on an Adafruit Fruit Jam board
> (RP2350, Cortex-M33) running 7.3.1; the code is unchanged in 7.3.4
> and in 7.3.5, the current stable release. I reproduced its
> consequence under QEMU mps2-an385 on today's mm-unstable: an
> unprivileged mmap() of 8 pages, mremap() to 4, munmap() and exit
> gives SLUB "Object already free" from exit_mmap(). On the board the
> next exec then faults the kernel; with the patch applied to the same
> kernel it runs on (11 of 11 runs).
> 
> Following Lorenzo's request for a minimal fix-only patch, I have one
> that only keeps the maple tree in step: it clears the given-up range on
> a shrink and stores the VMA over its new extent on a grow, with
> Fixes: 524e00b36e8c and Cc: stable. It leaves the i_mmap tree, the
> region's pages and the rest of your series alone.
> 
> I don't want to step on your rework. Would you rather carry it in your
> series, or shall I send it as a separate patch with you on Cc? Either
> is fine by me, and I'm glad to test whatever you post on the board.

thank you for asking carefully,

I'm recently delayed to update this patch (sorry), but not removed
from my TODO list.  It would be nice if you could propose the patch
Cc-ing with me ofc.

It's good to know that the code is running on cortex-m btw.

-- Hajime

