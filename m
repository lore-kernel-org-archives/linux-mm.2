Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0AADF588E4
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 127AC6B0093; Mon, 20 Apr 2026 10:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0B56B0095; Mon, 20 Apr 2026 10:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3796B0096; Mon, 20 Apr 2026 10:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7DFB6B0093
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:59:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2FC21A01F4
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:59:49 +0000 (UTC)
X-FDA: 84679243698.03.7FA4459
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id AD1521A000D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:59:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sQ0Ah6BW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776697187; a=rsa-sha256;
	cv=pass;
	b=fdvlmbt6iNQPNisRVVBKcvSr+ymS6ViFfLwR1g4ZcNhlA/M9xNAYIuaumBygltucAj8o0X
	YNP9WJrveRe2jAhJBWzyl+mV6CMm7/6kzXcm5x8Cd6cRB9vswCUDBbaYGDlFB59vJx7QQT
	6g4QyxeE6+BVJdCQ97S/CcXfxvk4rcQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sQ0Ah6BW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776697187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NjGKoDNZ/nh8tefbZ7tGVRxqm8WWbM3Z//Wew5MLjkQ=;
	b=0ezUIl4Sw8iAe7f9K1mdhT88uMx/9d8taG5QvVr4bOKzQ349l4hm+MrNlgJzGXjYacNxAj
	ljzbL+Y8bD55qcuZZqEM71t+3T7ehGIZBTCCGcJS33JA2LlfZ3vSJf16AZ644nlRefhmXL
	Xupjqx6ZsCo9JJbgo4cez6+IrcrEmrY=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-651c366f7efso3317458d50.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:59:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776697187; cv=none;
        d=google.com; s=arc-20240605;
        b=F9JlP/2qq5YliH0MVJeBrk6vRPw4Pp7GSoZQv7UzAUf7ZDcZYnvI0NbLiexg7lg2xt
         TcxVYEZ1wOdy/F6YfpiilAMnsBtOlN9zzPbGmV3IPQ8qI4JTw4QyH7ZYO4f3xlgsttTr
         eN+QTSWQVwAzrgqXD04vgIbf1aaD8XuWqbqfbXdA5dYx2qnVswbf+Q0RgSC4pezXXNJ1
         FrqmExv5m8VAvs6jjcHImFfnYHAJxSgrfAVprZGU0ZvO9s0SypRNSXbPhbsoXF3rWQjK
         Hy7npyKhoDCpKmna8X0PRrQ2jQDwZ/uterk3oQU75qDxgT68Wux02YLtFLcVo/BuZpxv
         PmSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NjGKoDNZ/nh8tefbZ7tGVRxqm8WWbM3Z//Wew5MLjkQ=;
        fh=vrGjb04ab35kLTo6a3cqceI8doHZQPb7nTvIr5mgCSY=;
        b=VoPZHFcRL7wit3FoIE8jcLABQPEahe3uVBENdoYsVZBFFvSBO+tQ3BPlv92TGRvx8G
         vicgWLrgpneEQe0Yl0wfMBAlGM5hJpIRrK7GNP6jUxaxXNbwJahsM33IiwTFgldvKImn
         iA/Fcam8llcFGrUWZp3mXnYqd+808eEXA3/vgctgeqAC0OiF9Lt3ev82lTaMtsZkbsJY
         zNt5qD+eOa1Ll+ukyAuXSrFnjVzwH9tB8jHHsfJaunsimBXYEntp2AxDbRTztkdTrDQ4
         uIfoEEHhg8Ra517aVW9VIqk3l937VO/ESrYjpKbJSsn3VwQ+/RCmgAOLORst8NmbqGWc
         63aA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776697187; x=1777301987; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NjGKoDNZ/nh8tefbZ7tGVRxqm8WWbM3Z//Wew5MLjkQ=;
        b=sQ0Ah6BWBGqDGef4VMDFPhm/ksYt4oyeewUy4uy4Z+FqUyGjZT/JmkJh5HFhS/MINW
         VzIpVijU37tBg+mbkzHvHHw8Y5nEaz7NtFAn4VM6Xu9WA/hR7bstohdZkAjc8sqtla33
         QdsJToAtyF+LjESody2CJFKu1AUYm83/8xQ349fOlHNb1AE71mhL4aRv8Fm6t6ENCe5d
         YGg0nCsEnd7K9OoPqfF8fxdYB+rO73Vw6Su/A22P05IwQGVTGnT12W1DvyCj9Y44IyUw
         UTAdunqLZlXIunxQ+DKqiw7ljD8fCCgPpUznT4u7+J9zmnlZEK3wTfWJjUwIzZViv3l5
         9KtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776697187; x=1777301987;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NjGKoDNZ/nh8tefbZ7tGVRxqm8WWbM3Z//Wew5MLjkQ=;
        b=lKpelKS2WVe+TJoWB606aY+Xq6FxNBgriGK5+x6Mnz1L31OmUzbRso7QmJBfUqHEab
         87TUq+2uyET7QOJ9Lui7fts9u1pZIPfj12hCZj6ehuHzsawlrU4dEMYsAvYX19Dz+hQT
         VFOraMfKGimU0EoWJ4jplHczkUILLFP3gnVhbvG42S+Do5bXnS3NAzZDYmDGLBjVcyXM
         r2cLWt+tiViZPiorP0Yy7q0aHgR//u3pQ2RtjkP1UPJPGo9hTp/eec+ugT4SBHBo9jWK
         0+qZ5feAkwAKgtb9o8auPaSkYD50LqhVvFA/ZOVK+IJ9sDBKVB77WwBcQstQa06eFUNj
         xrJQ==
X-Forwarded-Encrypted: i=1; AFNElJ+zBz+COikBoOvSWh8StqNLM184xrVdVSJiTzhl9G4JtUhpaaF5g2ml8G36bPAoj2jdnplj98woYg==@kvack.org
X-Gm-Message-State: AOJu0YzetOKdOYYD26zX4a2X4isKVOmWrKZmolxxaLD1i6+uLm0wZDci
	4g+DUSS96IsanYS/HRINlNN8tKQskEemATW3mfZcDpmHk3vQVep0Vi51xlmLXAF2ZuQRkr6Jsa8
	Gw+xU/cD2/9oSrGgjD3OWJKTy79mDmqE=
X-Gm-Gg: AeBDiesDblXTI6ggdwPs12LwyEu0th5Wy2bPiqOTdkROoJ2NfSpUM7oR7CmX2qxhOCB
	7WncypmbBZUQmaK9RxrmnUzmxWMc5NewW7x99bXfFQfU4+pwODKwo6+6ichvK3BET7WERZo31Nl
	cuiTRfwSDUcYtZIda9+TNPhXepouas4wwUtr0aOEPw/lJ2SVllSdIOqVICyul35vmOOr/7tbINP
	Zh1Vm9rVHOg8hdfNpD2aIsKMP5HCVcZyEOPIE8KWpW82q6gay1ySop45OrkvwiPzMejwlPnV3nf
	45dOG8YXsSCjiGSHtT3sW0VqMN5weOhIsGcgRYGrq1wvXdzlWlRk
X-Received: by 2002:a53:e1ea:0:b0:650:367c:83a1 with SMTP id
 956f58d0204a3-65310869b4dmr9283697d50.21.1776697186668; Mon, 20 Apr 2026
 07:59:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
 <20260418163358.2304490-4-luca.boccassi@gmail.com> <20260420-unbeeindruckt-besprach-910fd241c32e@brauner>
 <xpi24rt5ek2m2wkhv6celu75hgtgte2x4jhfkjar4gi22r7bdh@ilbxbhfxmm2v>
In-Reply-To: <xpi24rt5ek2m2wkhv6celu75hgtgte2x4jhfkjar4gi22r7bdh@ilbxbhfxmm2v>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Mon, 20 Apr 2026 15:59:35 +0100
X-Gm-Features: AQROBzCDWEaOuMvM8YwyjtBG72XsuHWKgq2-c-ABNz3Xm8hWnI2pTD0W_boZwEc
Message-ID: <CAMw=ZnSc5gxow9fnLjOGjFTXbkFPGhyupTOPsb5U+gP3znN7Nw@mail.gmail.com>
Subject: Re: [PATCH v8 3/6] liveupdate: add LUO_SESSION_MAGIC magic inode type
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Christian Brauner <brauner@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	graf@amazon.com, rppt@kernel.org, pratyush@kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Stat-Signature: pukahz5kjzkqzh9xttymyasi1xnrrbf3
X-Rspam-User: 
X-Rspamd-Queue-Id: AD1521A000D
X-HE-Tag: 1776697187-80001
X-HE-Meta: U2FsdGVkX1/rVDbFoPGIOMRKLJ9T44HbtnEJkHn2NEUPb6GyK6u6yarAGyno3rXdLs047c+knl9FzvomQYnfiZGEmcPUcRjIBt7K79CpUUj3MmTgsykv4PsOTCuh3BIJETUWo0kwL9FF3OC2BhoTMA15o6znk3/xRn5LO+/JH3TaJuxp9crw2mr+GNf6LAwRHOo8GVXj4eBe6/PIGTtgKUyHbTHLLa31zG+VcJuytsWNGK+eMl506L2MyaYfQCe3G5CsuJ5TyAOZ1XV0Sb38oTcJnzhUcj3L5Td4/MpClY7VsOVCiQPVSzCeoiMQFXlpDRYnnXUfv2CBxyst7zsE6Mg7IPdCpEH6aiBfL6HWUGETIITiVqVq0mC18I9nmViaBgJkHarwzG/Ay+E7uHQ5QB7rMZ8Pfw/mOxmdso6ZO4t5CPMlqPMDpv0ZSJUx+FAoXUzOVcw4OpEW4irp5eHxZBDBtfFbQgdmeUvGrt8eJhvZZvbQfQPKX+QF/wzWPVtRdie4sW3QywjVNmcHTG+NR0/rC+dHjBXN/R/5zuY3BoEojmaMbJ/GV162OXsCOwdDcrN7MkEsWjlQGo3QAjBdTb49gHKiy7/688bwAv4oE0gxJXs6fJA30rzLRuQ8nY6FDFhJmhuS6F0hrmR8R+gMzPkDfi532EQD/0LxmH/2tyn0WICEmeb3cuRnjrHfV8ig07v0Hyxm5/qk/1IGk/RJH3/3Pl3p9u2GQB4/rsbgBU4/UYd3AHyF5uktxbv6G3BIZ+k+txqOAgNWc6Gf8j240qkHKud8q0fOWSTSgO2hETovo3Nu5pZy+Vjc/+CiwsJal1mrUcYK5ejqu2jpn+UPZ/uP7f95uLg7pregI60abWSkZKMGw3q6mYj/95f2eGR00HBSadbP4/7Xd8pW7aIDjkSgiOUbbOZsp4VtEIbuCI5ac9Or1Lf1DjTr5hACe8EBXdcgmg7xakvD5N6lDVU
 pbXIAlzk
 9z4yAvs8rk/UiGFq3J6Uq5HXVnC2C8H6o+54i1ZkKuAzMvPKVxfTT7uYfnEeVrjAVlR0edEs3neKL1UUGNTx7qR5/fqq2IHrE6avt0RMsnK3J1pGWHhJfIs7b37s9ra4NNRAWjzaGvduo2Cgp+PwnNtzI5u+O/VPL7rpd/wLFqCTNADJGIv+7uPkzNPS3d3NGAMSGuMzuGhxxzMrSSjw4m/ptPpxI1DTsnpg6+jhnZn87w3Dw5mM7eE3Mvgc3EIde+0U9/RpZhaPWp1oijHcOO7TWBTOkJExcrlGCy0DdKmJACjV8ZWgV+J47r7OiMo86NywTSIHeak+3yt2OAeN/UNAlBjR47VkOps8ndWl66xMjgdPpySotM28AqZKbm5vGgVgpgbkWQtc5uRnnIXuxX2PiYKNdF5or17r0dFAnoCYxvjztn1fvTNroZdYWnV+S/PZ2SlGF/yPRP6BEu7HZ5WWk5GInhP9Y+Pl4ECSOljlSBFvmGeKb+1vgFHufSkuKoT2djBewegVGfRjKsUFeV+T5r1vHRX9Tx5ghCRPQDdFPlRW14/G6ZfOF4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Apr 2026 at 15:55, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
>
> On 04-20 14:26, Christian Brauner wrote:
> > On Sat, Apr 18, 2026 at 05:28:20PM +0100, luca.boccassi@gmail.com wrote:
> > > From: Luca Boccassi <luca.boccassi@gmail.com>
> > >  {
> > > -   char name_buf[128];
> > > +   char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH + 1];
> > >     struct file *file;
> > >
> > >     lockdep_assert_held(&session->mutex);
> > > -   snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", session->name);
> > > -   file = anon_inode_getfile(name_buf, &luo_session_fops, session, O_RDWR);
> > > -   if (IS_ERR(file))
> > > +
> > > +   ihold(luo_session_inode);
> >
> > Right, you're now sharing the same inode among all luo sessions. So
> > you've gained the ability to recognize luo inodes via fstatfs() but you
> > still can't compare two luo session file descriptors for equality using
> > stat() which is a major win and if you're doing this work anyway, let's
>
> Luca, is there a specific use case in userspace where we need to compare
> LUO sessions for equality?
>
> Christian's proposed solution of using unique inodes provides a standard
> VFS interface, but it introduces some memory overhead and, more
> importantly, a performance overhead due to the extra metadata
> allocations required during the performance-critical kexec blackout
> window.
>
> I do not mind adding it, but I want to verify if this equality check is
> actually needed for your userspace agents, once we extend this, there is
> no way back.

I don't have any use for this comparison as of now, and cannot think
of any future one either. So I agree with you and I think we should
postpone until there's an actual use case for it, to avoid the
downsides.

