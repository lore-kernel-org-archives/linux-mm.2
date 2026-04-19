Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE637EA71A1
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 15:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10426B0311; Sun, 19 Apr 2026 11:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE7ED6B0312; Sun, 19 Apr 2026 11:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFDDD6B0313; Sun, 19 Apr 2026 11:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD33D6B0311
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 11:06:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4336A5A725
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:06:37 +0000 (UTC)
X-FDA: 84675632034.12.41E2A78
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5534A180017
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:06:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ePkBhrrV;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776611195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZlSIGpsvAcR+BL/B11ZZ19gh3Bd1IZc5Q5ftal4be4=;
	b=XZa87BQK6O3+rQU8hc9IrsqPSwaMD3odq/odDEQvFvc9ubF2mVR2sWXgcN9UH8CBAoRcpR
	tiylb1Dq0Re0YrsSC47McH7LZkSwq82s96pTItXBtFyAMBy8a657ndNu3RCD24v2cMqxOV
	/G86WNkb2cWkZpNUP+APUHw6MPJrCC8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776611195; a=rsa-sha256;
	cv=none;
	b=IY8X9DcTyv7gfSdoUwvy+e4WY7thz0mNwtL4AshYMypIDju45iAY0E75pPgHrYElooPutU
	FjQPiXg22C4N36WVtVjmrZJQm3HEk9VgqAY493vlUdZk9it/epAGLdPsxW9vPAhv8JHDD3
	vYKlvHXHTBdzcwgq9l6GQtfWlB6JDbk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ePkBhrrV;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50d6249bb99so19255141cf.0
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 08:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776611194; x=1777215994; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aZlSIGpsvAcR+BL/B11ZZ19gh3Bd1IZc5Q5ftal4be4=;
        b=ePkBhrrVT5AwMP38UtcDARa15NglZfQewF6j7Cv5EMjSIoTA2hoy0iJ4nNXmgfrFH3
         4519tgyFMCwBReUdBamdDPmV8KP+MUuzDtclbVOS1edUJnMqjlK/w7RO5n8Y5RWGE+26
         xnNcZJToU9AqSc5oFhqaHjC7XUsHL5xXkmNs5oXvEPqb6yewsVZYQwfS5QI642EXxZTD
         /8Gi1aAaKVaYWaTEVch//xaJE6Cqvzd7yXfU+shDvT8mM75lomJGV2WXK8w4B7PWxn++
         b1xuhm3ltC09FH10G/jI2hj5zvO3Qs31VXWJs7eZGlHKrzqpVdfNwQHex+MeIL0m5Yw7
         PJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776611194; x=1777215994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aZlSIGpsvAcR+BL/B11ZZ19gh3Bd1IZc5Q5ftal4be4=;
        b=BsYlQJVH13w5EZIpd5D+Gw3qjhIbdFiw4D40R9SUQwgvfZsbjsXPT5+62COkZm9SOX
         zUQb4lT0R2/a1A9vNsHLU0hXEp+kaMxMN0WLuJuMgxQKob2/I5M6UgIsFyW2W24b2pUQ
         lopJu/tp0yYc0CMooXzX8S1uTO+gZ2OMpBPpnEDf+fFQQsOni9kEwpiqUdNkQjaPhzsa
         tQclGcvUk8xks2tREuE3vwyvv+NomxlSbuoHvhVq2F32ps5W9sUIxgMvZWEaCAm6BHq1
         kwBeJqTgbcHyd6nTPMmOxA+61uIKDqXsR38JRytGsbVZJdagA5n2rukoookd2dkF9zgc
         mD4A==
X-Forwarded-Encrypted: i=1; AFNElJ8dwmdOqSdGh7vYL2AUVtkA4KFcOi9fcD1tNPozyuQl1rsbw2FxXX27hzW5PwSDS4HalhYtHaY9OA==@kvack.org
X-Gm-Message-State: AOJu0Yx5nECiAKniwuEMHdHuWa6Jsgmt53xJ/gnU9r+JHbhOxMF8AGJ1
	wBb+VZCHFk0bVaEEKLCCJRyK4INcmcX2WIIQDfQS4HOXZWN94Vf4frW4mYnu+59FdgK39bA0XR3
	zgK3F
X-Gm-Gg: AeBDiesu76s/vnHd65H4csOVKI1RWdJq5oBonpurnLg3LHAc/CONRE+bitjR6cJMzM4
	uZcexiCR5VnqUe3n2SgWghQ7JErmVNwFm7Ob9A+BYsI/1tNfsPZL9bENiCv1FWfMxftH3bAGCtg
	+QVCGzUA7P+SCRYUHexllztdQ+r2R4EuWeK31F2hrr4cFAT8dRjoIpTs/iDWDC9cgNT3avt8mHW
	T9qY3MefZtMHmaxk/UkfDNI3nZVufgbSMvarjZmXeSYyqioKE1ql04X3fdvPyEhoKSpJrJsDsXY
	JdKX2tc4EMg2RKsBOJfSAk2dQjyOkaSsHKgqGOVc/a1a8rGzp8egdZu0NnwzGuRAl8YGeAJZtp6
	BB2yBqkkGMrvcTuAOu1x8U9FibX8+dYZkSdQw/caH2+ekwf6yi+yvhfqBTeQcb4lkrwuyIwOI5Y
	Ud4f4gu+Wpt9yN3ZKczbjs8fpS2iA1tRAWzb0RFgjRMrCb7lkbiUniVPfyKiPKoxKyHWoIRr0=
X-Received: by 2002:ac8:598c:0:b0:50b:7113:7170 with SMTP id d75a77b69052e-50e36c3513cmr165474591cf.39.1776611194283;
        Sun, 19 Apr 2026 08:06:34 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e5d5ecffdsm2643201cf.29.2026.04.19.08.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 08:06:33 -0700 (PDT)
Date: Sun, 19 Apr 2026 15:06:31 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	brauner@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/6] liveupdate: reject
 LIVEUPDATE_IOCTL_CREATE_SESSION with invalid name length
Message-ID: <vgyxmjxbquino2fc6hfbzcp6nc7vdwgf3d54tngwb6j2m377ol@q7hjmecgm4dq>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
 <20260418163358.2304490-2-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418163358.2304490-2-luca.boccassi@gmail.com>
X-Stat-Signature: qz5ztbjafd188bz5dqisbcrg1r9shrj1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5534A180017
X-Rspam-User: 
X-HE-Tag: 1776611195-303168
X-HE-Meta: U2FsdGVkX1+XX2mWoJWIcdCyYRNC+C8OkW4UK8FlGOBnlnhg05KI8J8q8wuKHe/SrScDG1zyjRDHaFv9W1uziYXnN02oGrx+rVuxAdk52+dTiqL6n/UOTE24Mi9WUfxqa1xEQnmWnT5pe6r/nIryjEf4OkqfOCK2y+o/nx9Rh4PqG5mp8MROIy3orTiiDfZxdZiRTUuS2vrkKY/GZ+MDoArsLgJ4LHNwzQvprsJzSKCQNyqUT/pGqPDsvtUdk+zyk3K+V0MP9KZIMje/0QBbHYsDBqMRc+C9GXkQfyZc9rcuJTWWy+dNj6Qt64/ga4utF1sBJP4vjxU3UPQJ9FrIFsouqWEgUX4fVpkSiE9UMmz8T2OKp8c7zWI0KUotGvhemo89ltPqZNl3/RM2ZoNLkbZ5DYXdma33N27Y7m0pDgYGB/zOvamkWrch9hjihpc1McYtdOrvWiVXRS4uQ13DD9QU8cFeGFEw8R28BEkHHSlghd6cjOhZ37AhhdOsPF+kYMkGboUSWzNWi1abFxNjtQPD7hHpy0zPTUs59ICKToVmIGCXdwfUPaBxu4QxSfAaBMYAV4opGns3IhTbNt36UEQRWAnPWFXvTnm8HHiN1NMsbs7wzgAXwy0N6IZcZnRcjUqLhFYg5IH/Ps0s/5/sLQ9Jzug2u9pK6fFpJ/VIDR68OSO+XSl0Yr9VhUrzQtQtGcdJSjQdDa9CmM4291yGnbNOFx+GIi4mlIZyAgDatQIO4BdooNncusBvw9tMdwBLxzbryqfChswVtErrjeea/Z2Z2Q9cUGRKFNG4QKWj6F18SRK4xtV7uZ1UjLVxDCcnItNiMVpS/g1K41lCOuyEugHsMZOIUgM80JFgQZ7MlEFn0ViQmarcrGpEID43LaEHpcZcbskyJFYCpIoiZzjNNBsf6FIILYNuK1mwQiYTMHG/ZdxfePHV3sVix9Yo3gX3T7qnecB4Pvt3NpqxAJg
 bjWa1J7T
 6xGdGNOybecy+wotIyWD8ZcLblMBKqu7v7F91s900SjcvXqiW9vyxX9ZYPXnSC58CtfdE4l4/NwIS8juYTTdSQi//tPNr/ySCGZNf5cOGIWcuBKuj/l9PDv9WBM1b78XtwmVK+SsNK/BXS0omyJXK+GFRgVNlKDXTFFWg5twYfXERa51M86Lk76/YWCrAxAL9T4xaC3jV8SCO8TcCM4+ZqzmAb0wxhirNcRdBMjx8JwX5YI4tmkbwA3Bk5bBvrEDG3xl0EwDFU8GlUhUAfB3g9UR/1fVBzhNnZ+OcnlwAbPIHRdKX61kGFkvokdbNegPTsnFs4enfxk3VOgxk+D6QJD0+4er2p1wglaPAUso6YT1Ar1NVTegtRKeX9oOcbxm1tuSK5e2aSn96nrQTmS4jBYR/z+YiaHcwjOZQ8iyZaxfozGlYU0whv50o3twtAJqyz7f9IqfKIIm9acYBIb8AgY3QcgpGqQMoUUMtGoPr97spGFAmRSP4GQ2xJfg7luyoC574
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-18 17:28, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> A session name must not be an empty string, and must not exceed the
> maximum size define in the uapi header, including null termination.
> 
> Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

