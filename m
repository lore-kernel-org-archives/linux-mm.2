Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA6FF99C69
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 22:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165626B0158; Fri, 17 Apr 2026 18:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116B26B015A; Fri, 17 Apr 2026 18:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C9D6B015B; Fri, 17 Apr 2026 18:09:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E4C566B0158
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 18:09:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9945B8688
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:09:55 +0000 (UTC)
X-FDA: 84669441150.28.6C39CBD
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9B504C0008
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:09:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VjmH412k;
	spf=pass (imf10.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776463793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yi0JgmK3R35yP16fhb0/s1gdWapAm05kYmMX0/wAIk4=;
	b=KCuFjpNoOsrkmCy3f3vSR04+O10HhpsOcD3AiRGcWMgJHwBHYYfesr1Xopxnj2rCIzLZ0o
	DUFtTlS7L/MAzoqlV//Q4SmogjSVlD+/6xF3PPNh7fF6uKqKGBP0Hric/OOoSL6ulDsiQR
	vJreY9ockhFGn9NZDVMDowj6G3QOsaA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VjmH412k;
	spf=pass (imf10.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776463793; a=rsa-sha256;
	cv=pass;
	b=cjZb/ES3isGR6a6Vt3h1ZWBDcisGeLzurIxp7BkIOaDnb1hL5UZIC59zemqOnYuRACw5Ss
	ohuKaXApwMLr+h7CKDcgS8YokBiAy73AWAHijKOJ2AIaG3i027uSfMwRnEQg5ljXbZIQp4
	9Djp3tH6r+rtv27nUPzmU9WlCdi88ks=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-79ea87af213so33333887b3.0
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:09:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776463792; cv=none;
        d=google.com; s=arc-20240605;
        b=kN8qsbOXTNYqSCCvTwxcAT4BVHJXaR79QXNdFZreHtwSkbkHEFKzsEx35amu4lg4hd
         xmrsXOL9ej1SFE1ZoEMsTfYdOaSw6CVdFU7jNdvILF5YQAuAEPocfvvQogtN4KddI+z0
         a8oT6sNwjx4HA7AKAjrx6MTgBaW9xTNvtoujIOxTAMZaQL4rIE2gwhXVGAP60COtffcH
         w2dLBewYtT8hhU7+OTrD4IBqsNe3/rl1gNWrDKXMbIjfM+qhKYaHYrimUyq7OW1wTYjJ
         E4jrw/HM/GWujbqyQNYItf/1qrSAGz6MqgO1R0HoOpNgv1+sctRTf9DTrSccrRWhXg3R
         lesQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yi0JgmK3R35yP16fhb0/s1gdWapAm05kYmMX0/wAIk4=;
        fh=QBxo3sNyCWNWNiwmyLnazbGS/QMA8zgVaqbnX/6aFY4=;
        b=Vm1Wa+jc+E2UmiXL/8HO92JWXYhgzxu6BDAqtb+235WJV6P69aLERZ4gdXhaXCIroB
         T8VJmLNF3ZzblhOIEmYvobJuOz2ct4Qrw3zkaTm/ElHmCN6aRb6qm146jYK/E0NqT0vV
         frbaYnX59JuNfPvm2v5/IEt//MShHrujJNhmePNAUx59FKQGa8aGkScmLDWWHu4DQCKG
         07k7f+fx7jB9CtiVwpOOH5gaYu+iT5JrwzbW6yWbA1d4CE1uh+rXCMIny4Qv4QeGtk6T
         uvxRTJnfEiyL6K+nyGnbyDFiTUXLGiO7Sfp+skCz9yGnw+6XFQ0Yt9TV6PIQ+PuGnUW/
         euNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776463792; x=1777068592; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yi0JgmK3R35yP16fhb0/s1gdWapAm05kYmMX0/wAIk4=;
        b=VjmH412ksJYmQbkvN6f5yj3svbAOeNay3c8k0o16I6BbiD66cp503XdFtZprd3Pk45
         turnmMlw0bHAsAgE6+SHItrTRbYfrtoeos2w0J0PkeWERdBPsfF/uzjfI1niSlFEfj3f
         3SpMPrJwLbPC8yRn7+ukMeTuiNda18lgEwezT4+WhPBHkYhrGSja+05Yft/3pYUH/ymm
         zZuC7ppmWWIC+C1dxuY6EqUJ97SOJcAEt/7kLgFpp0OXLYwkENCsFjRSwOaUpEy20u6P
         /VSqap9B7Q3aDQcWLLZHMYoHn3krm+GUPRomlQA8NtIgg7UJGFVURkXfMQDBqopObdNn
         H4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776463792; x=1777068592;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yi0JgmK3R35yP16fhb0/s1gdWapAm05kYmMX0/wAIk4=;
        b=JHt+XRlch+7TEjV5bnA7Ktofpt46nKkvQOXm9mydLyARpy7sedkSG/0k758a5tsdGw
         2lozt+cvLOoMlIXaECpXS8uEP28ZYqTa1nnbkE1ZAeH5iMkM0XnK8XkXwh/lZ8UZorKr
         UeeZH037fJSHNz+nFfVNP/GkuhgJcTJtmu179tCSaCyEx8U/6wlhjdAIqJn9tBFBW8Gb
         tbTqgqMUMIkGkobDPL+MWDtK1tEmWdrYz2YBmXK2wCYyFa/54I3C7L0zCcgrZroF41ZP
         JvzmkSVJFAs6U6ah2jTvkzjZuKY+YMMYDfXQqKKr5ENreLakBR6K0jg59Oeou70zDeoN
         zX6A==
X-Forwarded-Encrypted: i=1; AFNElJ8NORTPm2Ng+Ntl4So6W6uwfMJe9OKOLxKPsmRpBi1KpSIRd6OoOP8qR3FWEw/19qXXR76LDKSgsA==@kvack.org
X-Gm-Message-State: AOJu0YzvPTMOWll5lTngZzP/LDf8GWy0MQkM3nKVwPbd/JNEQAXXjSqf
	BIQECL+5hdGONo5VIPSv+Sslq62pg622xvr8Zxd3fABkrGi/NdByKuleCz3bbhLAZT9+TxFrK+k
	hmrCMWrhNNtixltw6dWrzi2JN3suEUnY=
X-Gm-Gg: AeBDieu2MLaTSVKQW2oKqbqoZ3Cx0EYpv/cZcz0kD+/nchswjR0WDCa4gX24mWM3+Lg
	of4y3NZWudL9h9T0GcpIh6GDifuKzagKgywZP6h5mMJF7yo50uIFVeti2UoMA8nusfAgTVC7jVu
	Y4qiiFhd6lTDcJ83xj2Q6zxMXIsoIS3cg/ZJ+ypmkzVdfpRm3sqy2n2llsxxSHsNFKWKPrlfR/5
	zTiBKzfzjMDkZgouiSQhPpAuyDe/nBljKgbn9o8SseY6UeIJHkZiq6Axhxtgzgz25gKtVPME8/m
	BjKTSh98nGoqzgOscoj+Bi34v5+tA7br2pGmfCrvbhCb0jA18LaF
X-Received: by 2002:a05:690e:43db:b0:650:77c7:ae81 with SMTP id
 956f58d0204a3-65311b3180cmr2291569d50.22.1776463792619; Fri, 17 Apr 2026
 15:09:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260417003856.1525287-1-luca.boccassi@gmail.com> <huu6stumzw7ziu7i5qsbpo54hmvd4j4g6fge3acrulhwekw7ez@mjjf6psjty2g>
In-Reply-To: <huu6stumzw7ziu7i5qsbpo54hmvd4j4g6fge3acrulhwekw7ez@mjjf6psjty2g>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Fri, 17 Apr 2026 23:09:41 +0100
X-Gm-Features: AQROBzBVsf_pm_6AipIBiyNFG5DebocTS5kvjb_xvXWGq8-zQoaXkmR-0dQWyzs
Message-ID: <CAMw=ZnQ1EMxobX+=6yC-h2_LQuwhtcRox=0hUaGBkUAmzWiX4A@mail.gmail.com>
Subject: Re: [PATCH v2] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pratyush@kernel.org, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B504C0008
X-Stat-Signature: sxxcqibpr1u8dn1pin635heiotutzp6e
X-Rspam-User: 
X-HE-Tag: 1776463793-429583
X-HE-Meta: U2FsdGVkX18qur8rEVUPZrV1CL76sCoi/YsnzTW+cWZ7DfciQykvHD8rnS5maPHm9YJKkU2as4ehH3z8PUm9x8lTsWz8E0Bo6DQ8xdTPeCy0l93gO7T9CyogwGh6QKFgKir4Dbn/NwthQAAFUjKvLrLxhyD52LcZYCuytNfYcbTK3Z9LU1wlpgHJNs4X97fE6JJXa1xNsA4P0ftsgS+plMUD6u7KHhAFPCLnv5ORLeqk3aVrI7hKagQbihYKA/Bd3RN9BuCukeIFTKexVEWSvHjmjWjQ4JcW2LeM1xKP1y6fvtCbrc5I8FzT6mL5P4Q87SXfShsP3KJ9WRtrkM+WOvbXCau4XrlEYmUemFa3LlaeM6Po70in62S0jjoXC/KDZkZUKae2ldQF36vcyfzus85BnNye8x4Gx+ny9gueMxUeoXJocLlFp1Gwmmgrvwg4o6IO4uHqr+RsFuQ1XVVMVZ9jaCv8DPS4kohMI5wBIyqcm8dRH5QGTNABAkPWOPtCr/ZwVQ+x+n0/XLWXu7D5Qj8HCgwKPN7TsRLFLZLcUR7J0URAeAKHk67hTIkcb0eQiraJSwL8OGWiJRWpAcabb7ZkPCfEy56PUSUbLAKZrPhJZMFecnizbHqZQ4YdRLVFaJWmh0jwUtzSVybi3Le/LiNh+riNPG0m2kQN9bUgQKoVF0mZE1oMPU4nHDstp3NehXjQoZeW4KEGOo4PjSIiIcUHyszUpoFL6nbqQd0Xr7VeuylXts4N+ZwoRq+TMgAJ25qf+sKWAu+4IJpeedKxCtYJgBDCD24MgmUXfawFEAoLvFxmQveyR6VjZJFv9lqrh9I/llz0Sc0U3m680EySE491/C0LWeHKNHl3tGQrZTxKlV6tENDs33dr4aRovtvy9naJcJjjnbDNLFKSXiY//6mIJFyiKYioj74mCPhdCe0l5vDJNZm8MFzeIzQwjeJ0LQiF3nFUfT0/tenxZ29
 bIrYW/9F
 k+HtOGhiCUKfIZ7Qv7r4/V/yH8INhQJzhMEqET2VOg/GcEEffUL5NNT6eT66eJit0lZePBPSI0wxR2rsmQHbNIWHshZt9BEkM7rmfC1UfRP9aaHKBoCChdqXMO9odUMgO+bwDwm/s6/3q6uqGXvTe6aMZHxpjabrCFAretXQps9uYBwvuGXeFgH+i/OK6FTZAbdEvACf/fBpc+sKZ+l5QMQb7Kns2NbLMr4HoIi7J6ZIuI4fVRiBlBRnXBPuT3l7dPaGleEBTHOWGe/z4PKu+RWcZYuntuu/ECIsXxdmyxc4v48XgwTgw/v90YMRulMEgbu/yNMMv0Gps/dPrznJc/VPZkkJE3p2PkGN133gzf7vpYtDt3iyDTAiMGxSeZjEDDmt9+G19uvTA4JSiZHExvvXj2liIsjoVhq0XRZcsgTzg+kCCGxlVjjdm6y7CnkzjGumI3+rXIfZ+Q4IeKjYd6SpsIOiRIzqyxFsBPdmnyNgRZrFQ7l0EMf6w/djXCfdv7H0fynoIR0TAkTpY95E1vNI0Yjy/72gDAFJMGCA2ZRriPa14MBzV5wqr13PsoLTiGxR/cFKhnKOl1azIgXLB94v34pIZOvx5i6+lEEcpy17HxguFdICIMRq+Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Apr 2026 at 22:48, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
>
> On 04-17 01:36, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <luca.boccassi@gmail.com>
> >
> > Userspace when requesting a session via the ioctl specifies a name and
> > gets a FD, but then there is no ioctl to go back the other way and get
> > the name given a LUO session FD. This is problematic especially when
> > there is a userspace orchestrator that wants to check what FDs it is
> > handling for clients without having to do manual string scraping of
> > procfs, or without procfs at all.
> >
> > Add a ioctl to simply get the name from an FD.
> >
> > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> > ---
> > This was requested by Lennart and Christian when discussing integration
> > with systemd for LUO management.
> >
> > v2: apply one fix from bot review about cleanup on error path:
> >     https://sashiko.dev/#/patchset/20260415184536.1155220-1-luca.boccassi%40gmail.com
> >     the other comments are invalid: luo is not a kmod, and the write hooks are not set up
>
> Please split into two patches, and also CC to kernel-linux.

Done in v5. I've also merged this series and the LUO_SESSION_MAGIC
series into a single series, as they modify the same unit test source
file, to avoid merge conflicts.

