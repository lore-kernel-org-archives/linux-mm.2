Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A8DCF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2486B0005; Wed,  7 Jan 2026 00:30:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4F256B0093; Wed,  7 Jan 2026 00:30:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7BE26B0095; Wed,  7 Jan 2026 00:30:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4AE76B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:30:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01F9B85A90
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:30:37 +0000 (UTC)
X-FDA: 84304042956.09.CEED815
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1617720005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:30:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KLW4BBSi;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767763836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rvuPAd4PxIStSgirZQIBqZEp2hOSYymshMWzdeGFLwk=;
	b=oxh3m7B8XKjfrCzU2H3wxp0wgcrEaFKEbltonWu2/PILKGp9TnhgP/AaloW6q2cROs2L8b
	GYbhYWlktkmOgGjWDMr1uHGRYjAPZLRVS91MSd8slXMnTo0K/8JmNv1BnEiRXRwcEFX7+6
	0ubl22ZhEhuGipPkKdNxVTWgSamQlwM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KLW4BBSi;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767763836; a=rsa-sha256;
	cv=none;
	b=BpyeiGJ7r5wbLmSvBJOM6dtB6rgnrxS1uH4/r9isg1bSGa/v78vEw9WtMxRyBE//7xElr7
	fP0WvbMZiVhX2gl0ersywxiSHf+Tkm3nL6DBofbQUTr0Nv3Kne4El6zTXLn8rG0QlCSTwN
	CGLrR1qvXY4jD2GoSYACx2hgB8fd7kI=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a09d981507so3959385ad.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 21:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767763835; x=1768368635; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rvuPAd4PxIStSgirZQIBqZEp2hOSYymshMWzdeGFLwk=;
        b=KLW4BBSiW4fVkWBdQ0sTB6mPt/mX5vcgkj+7X8CsoXZPKsmdQlJ+FdWp6rv5pesywI
         qcI5JnAWKrZnzcpZ2owUIXd3wd/cUAmufm/Ay1F+GyKR6P5Uv+gBtgTag5TX5RczPW3B
         QZHCibKnMezHSZTEYUHu+Jl85DgTIbayRf8Wg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767763835; x=1768368635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rvuPAd4PxIStSgirZQIBqZEp2hOSYymshMWzdeGFLwk=;
        b=ly3Jwqe7vMtWqOrQ0V91Ui2TlmyEc8d0CL9/Msq2EnuO51B7zI6aScPVWS2lJAHrcX
         Hl58mjYvNUKgYczfBFHLirwstPxW8VEbmwFhYJt7YXJs6SgXAzGxerBNa5qBQa1HdHSR
         gcvrRG0+W2kHM/ft3rcfN7rGRCURThseIeSMW+kOJNVMw2f+l09D5olxyTf+PgilZk54
         37cCNAsEYLfOvcZnPlHlXbrBzldBc2a8Hhth11HNN/FVeMoyhwktdr5CbwtibfMXBWDN
         Thb7KsdPZLyEPpTXYasMfBD4ucT2CffKDls88rv12khMaiM/HQkiAwOCaFwZIiNT0GFW
         Itew==
X-Forwarded-Encrypted: i=1; AJvYcCV/3l7lHWhgdiu1sgwZ7aK/ak1HiPdirXmn7hq7mtMOLEatn+nmnHkVAO1/dYLTZA3qQFzvxeZ7Yw==@kvack.org
X-Gm-Message-State: AOJu0YxJZk502C9hoz/4y1bjEfEQyPPFlL1eREuyn+w9u0pIX2ibWiF6
	1/6hnMxKsdhnObOMXPQgdVYnCrOtUVo/4o9dWkAaTicDZWosfyxrJVPIPNHyj65+MA==
X-Gm-Gg: AY/fxX6xHQaZNgI6Ke2/Y5fsuNkTTkJ0/EQ1adP5KvMNf0Xb/0UVvHpXAo4sFCX4sBI
	MFm7/XgElUfspyziIjkjLxeeYkFhgHBEkWY5L2HoFHyp4j9dsymh8dqB/aYE9dF1RYbq9JZUJUP
	692Qx3O4+GnpBaBVg1BQBYvJZrvB2OjXdgsT/kAXi5/rtdoLCHvnqW2KbKi91HNmRn+kPlVTyKo
	IP2vy65AvCZH4CD2eLI0Q1Lv2e1QlvQnfaP3hI4SKCBioaylikMfAZoTksFe7OqNkjlseKGrSQX
	b1ml9PXe3arTNC49HBXlhCTo2s38+yy9gg/8hK1gizOMnge/0s4cYkaT4kY/P5XBYvxMboZ660K
	i+jZ2sdWOlqpY+lLgabGkif6awN+xAAahDKwLU8PytCAfoKgZff6nJxdvDuhaZcych9C2B5xvhU
	vAfAq+MZ2FbjHUTNqUaR4GamT3mQuWTESuvAFCpGDZeygowNpq3LY=
X-Google-Smtp-Source: AGHT+IGpI0e/YgSaIkh6fla6oMd1DaWF8F2Wh8jSN8JIgna5GUW6wLMd4oRoydN93ixv66v5mr200A==
X-Received: by 2002:a17:902:da8d:b0:2a0:e7e0:1d31 with SMTP id d9443c01a7336-2a3e3992e27mr56514055ad.11.1767763834914;
        Tue, 06 Jan 2026 21:30:34 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c48931sm36918205ad.29.2026.01.06.21.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 21:30:34 -0800 (PST)
Date: Wed, 7 Jan 2026 14:30:29 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <zpbzxfmxy2eflg6hfsfcn273h5bjgyxbpnlem555ln2kab3nga@ucutuf2ywwv6>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
 <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
 <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
 <vkhwvmazwys7dz7m67fil7xlhevdsc4xbvq3h6nknb7rqojjis@vx2c57ylvl44>
 <ofjlah554fgcc43e66djtysmnagd7gduqutueyauipovs35qb7@mw7keptebqau>
 <5smqbald5bollibqjsvqw2tfngdoiiucurikdgqtz6xjb7u7vz@7p6hskoixaak>
 <lupjar4x2wz25knuntywor5oyx3ksyhh7g7yv4apmztn47ayep@sncrwg4gjlut>
 <tzppylvpaq7lk4re33h4niofgfwiziibp3jdoos2ofeepxx5yh@sh2doyzze25z>
 <u6dy6oa6ztghy7ozficimubhb2mwppcq6gosupepnn63uu6oq7@qyph3nyq7las>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u6dy6oa6ztghy7ozficimubhb2mwppcq6gosupepnn63uu6oq7@qyph3nyq7las>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1617720005
X-Stat-Signature: k1d5ixu3dmdqyt39eoqypyp3dowbkbr3
X-HE-Tag: 1767763835-25304
X-HE-Meta: U2FsdGVkX19jnPazgARAFqN+7w6/sghJRFyuCI45eMS5cFHMGqhXhLAdnyGrq0H9QY9mDVam2n9aUmXG8SzQsaos4ui0//jTkjkJpZZjJ/GuZP+QKhyoJLF3swlgvcmgPlHAywv9DDMUdj2FeeOwoA+8YmSmUdVF8r0hO/oxCmO2hCHS9F6+vPJxxIZLQIDZ5OUVNTn36bu3zEx+o4sZrDTOiYzjWH10JnjEw1azr3p3ODuiWjWPvCEOT/ZVWbhQqRGh6rrdfJllieI2AjTiZSAIdPBumS/QRw0+6Yc6yNIxdd60Xf0MmYVfs+qI9VAaGVi4ELv9p51li+g9b9AqueOOR5iggFUx00WmULuWO/ZBW6TmWs8l1mo83VystfmpfsRWuOQFHxAiEmfHA5iBmXjvM7+9YZrmg6Dvq166aIwcQ1eWpoJ5kjE2XIdgJNeXwGnYL7X2hrqfpNiapwZ0qzQaBg/+Nq+4k/XG38djR3WEcbOatE1ZtnMDsbDn++t232OxREGkev9++MQAv3Z4yISR9EtkaRgVLrHjnFwM+bFaJ5iw04aNSsdbpLM2jAaZVN3g86TfVUWVaZZFYJZXdiHDH7ApAvLrwDqUJ2zBl5fC5d7GNTsWyH7eKExMZkhCfdLXAE5iCz90YIhHdi6CgnFier3KHCTPYcq7OvvbKTE4zHeOA569lmHQv6PLedgacUJrfqTGfWos13YsoRBCiHo6t9EPjbGyuQe7R5DirSHDnSW8gBBGkg+D8aU2fR2ZJd+LfdLF1GLDBG0uW63vS9ScqBN16BXJ++eLKM/45mCPaZJHjINI1TJfIu89BUW9GCCXBnSN9cYKE7UUTJTfAQDcTjIgPbaG+zbUEZASvRKb6+EkJk2K8+pWtG9r+HqURlFPoO746xcqIVj76T1BZk0ApJm9EjC+iRYhb9MVupcK1bMKG4J97YYePEJ9T1wCFRoUScM/eZl9Yc7bSl3
 +4tDXfc7
 RNb3mw09426YdbJeTTyn9liXUyIbbpFycGK73EoEgIIYRCJUblUrOYNcPBf77/+V/2Bxn+c9saQEq2xskQ5HNoIJn26QiP8OBniMIXB1qo6zxRI2PAi5EGYtVzg/Oo8a3y00yENt/JwVHHZcCQG0h05FYt6zJzHeTtVn+ayClI9IAu3yuYUHf0U0ROWfJQmQn7aF0/HiaN4wAP70+mK5gZE7SPZwjjLjguwS5jRgga+h68iyiyz8fA2bj/hCwtmDvauX/vHkqbscVgY68NSuegdApbSoRVJkiF4Vr5BTwyCh6hDWrsM+WA1Ict8BmsvhM2YYn5SxeesX977Ft6onMARbLX0kGHTMDnywwmMI2YIjIkt4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 05:19), Yosry Ahmed wrote:
> > It seems there is no second page, it's a pow-of-two size class.  So
> > we mis-detect spanning.
> > 
> > [   51.406310] zsmalloc: :: size class 48, orig offt 16336, page size 16384, memcpy sizes 40, 8
> > [   51.407571] Unable to handle kernel paging request at virtual address ffffc04000000000
> > [   51.420816] pc : __memcpy+0xc/0x44
> > 
> > Second memcpy() of sizeof(unsigned long) traps.
> 
> I think this case is exactly what you expected earlier (not sure what
> you mean by the pow of 2 reply). 

So "pow-of-two" I was just misguided by the second memcpy() size being
8 (which looked like the whole object fits exactly into its physical
page, which I thought was happening only with pow-of-two sizes).

> We increase the offset by 8 bytes (ZS_HANDLE_SIZE), but we still copy 48
> bytes, even though 48 bytes includes both the object and ZS_HANDLE_SIZE.
> So we end up copying 8 bytes beyond the end of the object, which puts us
> in the next page which we should not be copying.

Correct.  We increased it twice: off +8 and mem_len +8.

> I think to fix the bug at this point we need to subtract ZS_HANDLE_SIZE
> from class->size before we use it for copying or spanning detection.

I just re-shuffled the patches and it seems to be working, passes all
my tests.

