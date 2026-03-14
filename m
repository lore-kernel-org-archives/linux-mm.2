Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1590410706E7
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 16:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C50E6B0088; Sat, 14 Mar 2026 12:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3727A6B0089; Sat, 14 Mar 2026 12:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E106B008A; Sat, 14 Mar 2026 12:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1475E6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 12:03:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9D9D160946
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 16:03:01 +0000 (UTC)
X-FDA: 84545137362.17.8548D4D
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id BADAD180015
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 16:02:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b63eU27F;
	spf=pass (imf06.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773504179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1nSbZ9JHxGXe1PY43kUIDIHZzf9qdHZvIas6we9lUA=;
	b=TInctz/cH+lv+JnZ4i+MLMTblIvld/V5xjz/AlO7KBV970in1+4Nj0Zr07J/Uj3ohb8n43
	dS61kPGYCXGEL7nJyceiWYhIptCCflmEwr0VSzB7Yv09/gUcgF4Ov3D45Thq7b2F6JemKb
	QDf6nvT8ZvmOT7opwTra+av2rqpBVQ4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773504179; a=rsa-sha256;
	cv=pass;
	b=NIEQjyHh/wNZ5FL7d9mtk/pVOVFOxR8oaa6gNVakaQMAODD1ndgXpmBfbEoUSV+ehNxL/U
	h81nOHrnMcZ4p5IvxYxAz/Xi4G9jbulq7QknD3Q+8sTRFLjNdw166PhgnlWVQ+FyhyzTkr
	C4oo13yGbtnVYxQOKP8FNcOTjdDciYY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b63eU27F;
	spf=pass (imf06.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-40ee9b945d5so2064005fac.0
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:02:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773504178; cv=none;
        d=google.com; s=arc-20240605;
        b=hB306mF3OpV5oBsx7Bmx/m9r12QaT6UjTyex+nLk//jP6vC8mXJmXK1flK/ZZImbkU
         9jd2AEd5kdIi1z0CxRsVn3rUkXftsj5f4Ps06vyrb3xUOiBpu0FKxStMBgdgVmfv+GeH
         e9sIqdZNmoeulz/vwRTiCu/mVwzw/hybIlMwEyTeeuz3FZJ3QBOzmKBIia0RGnKsOR+M
         U2zojdLXcx7mrn0Ei2Hh6URNCET0mhpgCfYqXdrinMhuCgN3O1yuTYCa6YzNlV0soF3n
         qV6O1HWgkkOCUGzod424A5/hw59wNu207F4tPJg+pQpiFwg9CFCZq3E9yjLsC9S5Vubb
         jL+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=K1nSbZ9JHxGXe1PY43kUIDIHZzf9qdHZvIas6we9lUA=;
        fh=WRLn1fb5GLqIggzSglsgLGHIlDA4rBIz5ATbI3cZCRE=;
        b=fPCNskEj46DlanNuF36z7rjMjf785tH/Z4GJ/DE8EBDVce0RwJNmG2c8O3P4askvxl
         S1NL1DXPInZvq8tcUrT5N+mw1wn9KaawSjwc4+riZPfchXDpMzz4ULAVhFOR7MUnGLdI
         v332u8A10DgbawDC/QVF/OK4QKPHZ6SQotRfWycV5MArJXcevc39V5bA9w4nnuo+zsBL
         IroCzUUwO8jtbie3WknjMIEVN+TLYHgcwRf9VvmtlnrtvcWVg/TNwPWjeEopR5qr43NM
         2sTof802lFX3MAMyg5aoCGlZTPBYrIOsduF+8NMNEBGKaaCTDH5quBNZeSpc8qoVxi37
         Tqog==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773504178; x=1774108978; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K1nSbZ9JHxGXe1PY43kUIDIHZzf9qdHZvIas6we9lUA=;
        b=b63eU27Fl3oBQOavltIlMqSvMXrX5cNoaqAm9bPeLD/W2a0H1JdMj7FDcfTrXT3q3g
         gDqD5LeVu7+CE81f97SxhvZXodA4bckcRaT/vzM5ZsyuvM9setwf5YcNkOefnV/y8Cmk
         2oGaxqMJa0TUB0XwucWH2VLuydfGwWCQktKMAapg9X0CCBI/mX+YHLkpP4sGqfC0zrhA
         RSe4zwl9p82pVk5oYD+2C23leoO+QBAsD8iZr5bbEmOth+3wNSZMMh8bI3qzS9lrkd2H
         koMc/GtHbL8uIvoEIWM7Jt3GIyp2ICpHsOAnRGFVv+Cf1UII1sLt6H+xtCMnXs+Iz+zC
         ys2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773504178; x=1774108978;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K1nSbZ9JHxGXe1PY43kUIDIHZzf9qdHZvIas6we9lUA=;
        b=qX1HP64t56y6fM/sJU7c0FVODTPq/Q+iCbCXBor1yPdFeAr1WSVqustiXpvqQgMLbn
         7SItFa7bp86h9EeY+vAWXGoUsDrIJCCDcWrgHHduEoaj9pwNvgu2AH3fspsP0WMmjD8G
         Y2OKq9LN4uJ94PTgcf8i3gZmR5gKLqIhRh3DDxEPQflYJwAqCg1XoiKOh8uClB2x4LZO
         ZNRVlW9W1ESmqUeZkwtDta3Kio5wPsbH/h3TpKtEpWi9dFlX0t8O3ikmZfmZCXrZU67L
         aSKc89YtrIM+ATas9+YWnx3mCGLlY9aN+Z0GjlEai6JLVAGHfyQvHfjqfjCW24gtSgdM
         QnOA==
X-Forwarded-Encrypted: i=1; AJvYcCWSfGvnQBivrVIA/2UGkiIx7JBrrfMcatDOqeykjMipOKcFHGAasBpDB8S+rtNmsL9kRjont5Uctw==@kvack.org
X-Gm-Message-State: AOJu0Yxja248dFextZqbIMNJyplmDIrtU+/wK3WTMeCPTMWshlsfi+cx
	Vkm7dS5mgB+6D88pfdCksrNdRgo5ODsY7VPhHEWd9CZ7ujUYobzUcrciSi8/b1BRcRiQQnlm9QF
	sSB9d3gUBBhifCLyGQ4tzcrQAC5GEqN0=
X-Gm-Gg: ATEYQzzewpOo3BVRmvc6Pe0kc/DifJtsVW5YqZh+crr449DKdolGB6sAZKfAOterEvj
	sowok5omeen6H4uvfiuGQBbXbrp4USRK/PyqQ8kv8G6krOk1ZVQGpPT97bvMa5RY9WCjgVJlIqY
	4Lr7SWkYo9NUyCpN8m4pEogmdh48bDICnhx5JEfUblJxFyhzx5t/znc/8IDVS00XvmlgWTTtEiB
	wNKr6L6XFlYIpNlZwqZVlcnKpdKXI0D0WYW9vDR2TQnDBD55tb/NVxIr1EeLBqaDkos34DLUSN3
	fQ5w84xOKJS4gv+twIf5oxKGNrrVb/jx8cICg/J84Btw0b29tLR0PMibCoNrRVRF1bPQJg==
X-Received: by 2002:a05:687c:4089:b0:404:b83:89c7 with SMTP id
 586e51a60fabf-417b93e480cmr4169901fac.44.1773504178550; Sat, 14 Mar 2026
 09:02:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260314152538.100593-1-xaum.io@gmail.com> <87ms0ajtvy.fsf@trenco.lwn.net>
In-Reply-To: <87ms0ajtvy.fsf@trenco.lwn.net>
From: Kit Dallege <xaum.io@gmail.com>
Date: Sat, 14 Mar 2026 17:02:47 +0100
X-Gm-Features: AaiRm53vF2z_1LkGKcLWkMd5jzeE0yJrpkWR1I2_02f7198yoOzbZrqld_rmUCs
Message-ID: <CAAZVx98Sz1MknCcMpQXxeGpUjXBDyz+0KyRuUiCXsM+3qzqpeA@mail.gmail.com>
Subject: Re: [PATCH] Docs/mm: document Shared Memory Filesystem
To: Jonathan Corbet <corbet@lwn.net>
Cc: akpm@linux-foundation.org, david@kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BADAD180015
X-Stat-Signature: tbgkqkccb8r9ia136zj78ioz4tbu1zpi
X-HE-Tag: 1773504179-633591
X-HE-Meta: U2FsdGVkX19R8O1YwUnTHF1eOu4a22EjMTqKdbYPpEyxCmf3I/p778vkc8QnFJl/yDk8eoyxAI7NqPMOdK6LOlSkvT/NeJDz/d8OFzPERYtFTVIT6ZV25Ic2sJuaYahssDE6cq4ikki3vlOPEKrBmc+pRux8l/jUZrxBrXTZPUtb8/JXzPSaIsq+piS3kipl7EgLqmQ8oUAQueSa7REMqt/0z218K5KZMLmCJpUQKZus2cVu46/9ktGjG8HKicryq5JDhbROqipSVdrOOznIjrXaQHlM9IBpZM2C72VDtjtc2vqHSsSgTOcCjzZ3ng/4R1X5fq9zatAJQSj+gatrXfVwskM685vnFR+fDN464Ni8NRlSwu8NnUsBd23Pw2R2v4w8H/Bo1Hw8mxqCngmLNYBb3CEmxVAM6rQRHUETu4LUExVCFLgI6+UrY0hvuhAT9Qm4eUEnOvdvqEBQdmLkCSJPjourCMpq537VvOmBT+0KMZG2HEG70x6ElO9CK2r3ZDsdAzyBEkgUXAgDGv182XN24WnnOkIMyeZSOEKD1DJwqawmPVmdtHR6cTUkOsC2sn8dRP/AUzUQ190MVacdsvYwJm60UWu9FM8bSZ/42xJOB8MqEGrlyasOcOTkD1aBeHoG0+XDxrh1ArWEiURF6z6Umvvslyl5DCx5oFFQxzLPvBcWD9UMAFOo3DAxiSfiTtZ075FDVw1VC7bIg6L5YMeD82SPJeldRjuMRmbTCIRt1OhIYSxBcRbXZceNArzHSlERjBvafCZ0WaWA0Kk1luvly2vv2UIg0h5ecbDQYe5JP1fQCy0Y5lZOdC8U+cq/m9aE/UfjXCFhmt6kjvpzkT/NamEmIPoEtG5sUI6euEEZ4jZQNgNV80PO/zJi3ioLqADbAvazVBYtiERoc1nxTRwJf0vPQjS6xd3k5pTfRHBo8kK0W3brx01Sf44ZmS7II2ign0cw58d9m63nINz
 7poxrUg0
 aAuUTuxhbwL99nrewaeYSGsgETinl26SKMzM4rwLsH4JS5knruylqU1S6l4TiiENN4eTnEGa567afMQoLmAIW+Bi/AwkpJ5+NXgUMHp+mFLZ+8fImu5fX+R9RjyylEIeKdC3jfOTIFaR0P3jnPg15jr3HKnSy8QeBHMD39exVYqU9OQsOyfWMfpsraO0tOpw/k4y5Zk2oXC9/vukRogWMoPl0s1YLIp6S46tRYyDh/ZJObkkQeas1cEWSXxp7PiiWCndovR9kZ7T9Gc51o6BXoNIgZe7QPbdSCkY+lM/sKwZjDzMlNy0KlPYNlHEGYgQBhA0xNbB6NfnY/f/5AS+zh7S3/9+B4pUVsAQEHKcLK6ZyyOaEr4hazSw4gSk//nYO9t8L7nqQzstjOcCl1En9MW1AeZw1m75XRo6nzoHo48jvXdA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jon,

The material was written with AI assistance (Claude) and then verified
against the source code in mm/shmem.c. I read through the implementation,
the existing comments, and Mel Gorman's book outline to identify what
should be covered, then used AI to help draft the prose, which I reviewed
and edited.

I'm happy to rework anything that's inaccurate or doesn't meet the bar.
Should I add an Assisted-by tag to the commit?

Thanks,
Kit

