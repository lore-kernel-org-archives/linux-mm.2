Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 412D9C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 15:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284546B009F; Thu, 17 Sep 2026 11:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2354E6B00A0; Thu, 17 Sep 2026 11:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 124996B00A1; Thu, 17 Sep 2026 11:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D57A16B009F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:32:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E49AA456E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:32:29 +0000 (UTC)
X-FDA: 85223646018.10.D5AA04D
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9EFE6C000D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:32:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FREyPwI/";
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789659147;
	b=tsTuQPT9VobQVlGi+Ybpx0ZQiu+L6NX2g6iFvxCTz06Bo4GslMdnWzJMN+xpBpmhSD5crW
	nxkaVAUF3fIIXXMKUjuf0WLFF0qPTqWJQME6JTUNmbmQgzxdamRxjIWw/+Nq2ZeDZUd7fo
	o5gCZuBxm6NwYNGDyQG3E7aN81ZSXzg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FREyPwI/";
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789659147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9o+h5h/Is4Nwey7TzHWzFOTMN7qfm8CQCTarqUGlzGE=;
	b=0wFceqCDTgPSi92/YaotJAGJ7Z/3+c6+mEGWV6VFD1mXvq4Bmf9WFg6zo3Ll4sCAX70KeW
	KqEQJ2gOWkudZtlICgZV6yTdy7xq5SR8k0qhBNepMazAY6jISlqMsB91bNmecS/+vHDof3
	EwCmFpLLE0cvSz3mPSeK+wsYz2kipnc=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396cccbba92so872833a91.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789659146; x=1790263946; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9o+h5h/Is4Nwey7TzHWzFOTMN7qfm8CQCTarqUGlzGE=;
        b=FREyPwI/GYwOcptqCST5I31v6fWt9M6oKMq6ioPWLByoTvWPgQWUksszgAoVucEaM/
         bblubOrmCRucMekDM8Hq+9dzUi/0LQlF6jao9tE+rKyuD4bJ2zQ71CwnEsIvQXpLZ/xd
         LJo4vNKpDhbGLgH74+zGEamKuJVGyBhcxcczHNdAvg7wXybnBHBgc59Fp4/C8g7BrMbu
         lEjoH8Og9jlQYwzNE86UwFDunEdNF10EZzePhAZ35NN2UXyL/+R8Yl5B8BabDCbGHPIn
         VNAkpdfKPoQDtpANZm5R4cVcFUU4ytpPO0ecIu9jFKaPJc4axCHXBcRbCKwGeVhszI8k
         MKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789659146; x=1790263946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9o+h5h/Is4Nwey7TzHWzFOTMN7qfm8CQCTarqUGlzGE=;
        b=bjCbqZEuAcQtcmxWcqhD9GBU0/8GVCqxwPDqKDLd2C8OzMDhjrTFlnYLkfaT/8J+/Q
         +zIAhc2dBHpJqlqn1h/O7j4CeRoBA+cpIMxRkUGL8hFEaMX9M5S0QymYJPp7iwUQANtG
         aIqN4eNMt1IRc4epyGjP5ESU74lsaQ+nUY40PF8RHh6x5ALuDVmTs3Cx0MNnLJ3/q06l
         xwrBkuCLtWtbxV23nfSAgQ1W6kdO+moVKmLlm+InvtjdvkPTkXxE8ZFH4xNIjkad80Ql
         4XewoPKVKxwTqYLgI9Hvx2V3aldc6EUMyDHOtDKcwHVHedzhBHJyJ46535+0bbU+c5sK
         JkLQ==
X-Forwarded-Encrypted: i=1; AKwUvBw62pPWwx32f07hOlaNctnwQLJUPr9sEepLG9S1kETLqB8R5lIk4CArs81n1q5wb58nZJglgu7AyQ==@kvack.org
X-Gm-Message-State: AFuF++kIAIjCjHkOOmqTiAk5WbHrWr1gUcZRIu74YtpV4mt8sargz8wx
	Fwi0sWlLtJlKedSwtf+LT9RGYJ1yfTrigeKS79qNUTkmMHh8EIR3sbek
X-Gm-Gg: AYBFou1hdk816wSnhOcgrG+iB+iqxp9KCV2Y6o95+2GdgXOeGCDVO+ew4OPcuET6NuO
	NAOkEaXb78XTy1D4HUcMkyQcurwMVRhvw6jQYrAAjLiGnAi8KCHrBd5OAMh95vc0blppVIlUeQz
	sZMcP+C7JFwE7cdVvEK9qXr0X+yYFkAg0RNiYnR/W9YZqc1oGda0ArEyvwCfm2fCOf3KFudTDo1
	X2h+gjlxixZAXTs4FwxPpTgsEoTtjNB7y9XqrXTu/UCKXofLxIy0S73CbM15R5kBtR3mOWxdtzs
	D9imRJcKzYYjKlkIiUcsLSsbFLhzow04+YklITAzJjuqRXobaaIyyHj0JXwJc/j0bAtDZNGeBui
	yebSj4BwKjaai+Bf6fCVHj3F0KCWHf51uR9jdLK8qrDCfRnLg8QgbhyZF9vvy/wi/QqDs9S7Dnn
	TNdFmn4Q8plG80qNYZuyq5OYrsG5h4UKXcc4aTEgyoUYvI03mlw7YX2LwmIBjNAaYGY7Xz8ouCL
	tg=
X-Received: by 2002:a17:90b:4cc8:b0:398:c292:ac80 with SMTP id 98e67ed59e1d1-39e1e330a2dmr17225810a91.10.1789659146260;
        Thu, 17 Sep 2026 08:32:26 -0700 (PDT)
Received: from celestia ([2402:1980:c3f:8e4f:9945:ef6a:453a:80bc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35def1f2sm5655462a91.5.2026.09.17.08.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 08:32:25 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC/Discussion] mm/damon: Implementation for paused kdamond
Date: Thu, 17 Sep 2026 23:31:53 +0800
Message-ID: <20260917153238.76020-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915002836.101895-1-sj@kernel.org>
References: <20260915002836.101895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9EFE6C000D
X-Rspam-User: 
X-Stat-Signature: 78115oawqhy3ozkyi9jjo9zudf87kqjj
X-HE-Tag: 1789659147-677523
X-HE-Meta: U2FsdGVkX1/kM0rjbDeMg+FvhAeZ2g6LYi+A+iVz5z9bFMx7o6PlPvLmHVMVs9F8ntrXpP95N0FGnYg6cbROb9k4UxagCDtEtxd8DgA5jpY7nXBFqW6defhbc07ufuGpoCkqEmo4WZLTrpNOQs4DBnnhVKqX9HszTf0bSUZCh3A6jAZ2RakFg7KLNTL/A5gReZrLL0fSL5PbwKK5SEsw5VdUEBChVvs1i5tSLt+oTVbmkuB9u4EhXM54g5+NOhpWko9fVFaiFy/GRd/xa338QFZa7zlbWqcWEqstGof5NI2OH/PLSd/FyU7QU+c/GJOGIG7HfYzmla/QR2/c4/QzvxMpxX2RX3D72bqHnX2Jxc9/aFLVPF5ax9o+woot0d/SPOUcrvaJ195S/k6uBqTIdEhAftK6eC34PHbhodmoq4KFWGLAn/KjFegco3wnY6x3iMhZf0jrXfN3CQiEsg3qlI9AeLwpBc5xnOKdaaOab/OK2HyIa8k1+Rci7K8Y0ZZ4l3xrEoN+Dq6h32uxEeTCYIn+caLrhrGkcF6fYZSEwnRfc6pR5sceQRdFN5fZDuWyE3jxx6wMDlJHTvoicND3GuHhnpHsV1JHoet8Z6IPET5Q/nN1WnuTErsaqDLehBgpAWN9yTLWAZ6wPvadQGf5C69PjZNIL0Xa/vYSYuhTXsk2FtuzzeGOm2mag/OGvmotDC1TiITKuGfcKNMPDLYT7H1D/uvcfAK65QNlUQvYM+TFBfR2HttW+piMtQ9ofxeQaCAX2WBBNWrMtFieNEDGiRlk2K6AXluuUpHpSXHEb8fck1DBuJJJlXvsLpztnDoeFpdNjBV5sxfs81DSVwBFM6ROZofEti8sIUmqYxGmgEcdn0tG49DfinJL0C6qNHT/cX3JQQgxaprdxRvlCDmV1iDnEUgM+C5T65hmnHsOeuDKti4l4RLjr8JmgP9qzMTa6sKik0PvSDj6ov7Zolu
 dhADJB/4
 PkV7dHFjNrx7RFTmEQPSNJMtKd3Mf0Ef4Dv3AxUPIll3t0+dVI0ghVUl1Yqc5n8IZ/0gc5h9fTmnWDFfrlOTmPfdsXPsL1T+hMus162bNXYsmcbYAoWAcKvNWxtxGcXnWBD0n/INyfkgLwQpKV4xa9eLXFnkR2WfqSIXhQxpNmkBk/uq98O4UMsidSn1Lz5opbRIDVnV5gPJwcqO/pum1yekktBz4tKXMP+Vu/MlSzT1NHBMIDcfGmCAJtoZPpqNURnuJRaUsg4XgsGBRjPVNVI/iPSTEIJXMRZXQeALh/YAvHTMkklEUVhphh1bSIlR1QlyGaKbkLjrxECIx4GHBRu+2NawYqBYdgyaFBxnxZUqAKsD9mvSwRc7XC18GYWVGX3WNA9N638hIGPZJ7AF13aYt+9hzCjmn5wLqvas2Epux1quwMPjtdKhxVrKlQ01pkgVU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 17:28:35 -0700 SJ Park <sj@kernel.org> wrote:

> On Mon, 14 Sep 2026 23:35:10 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Hi SJ,
> > 
> > I noticed that the current implementation for paused kdamond is
> > periodically applies online parameter updates by kdamond_usleep().
> > 
> > I'd like to know if we should change it to waitqueue to achieve a lower
> > power consumption?
> 
> I'd like to make a data driven decision :)
> 
> > 
> > Previous Discussion
> > ===================
> > 
> > I noticed that when you introduced ctx->pause [1], Sashiko asked the
> > same question, and your response at the time was:
> > 
> >     "sample internval is 5ms by default and recommended auto-tuning
> >     setup makes it hundreds of milliseconds.  So I don't think such
> >     change is required."
> > 
> > I'm curious that, did you think it wasn't neccessary to change it to
> > waitqueue when it was introduced, or it wasn't neccessary to do so even
> > after it had been introduced?
> 
> I guess I thought so when the quiestion is raised.
> 
> > 
> > Asussmption
> > ===========
> > 
> > This is just my assumption, not a real use case I knew:  When 'pause' is
> > set on an Android device, user might want DAMON to stop running
> > completely when the screen is off, thereby reducing the load on the CPU
> > without losing important information such as regions and age.
> > 
> > The current polling may make it harder for the phone to enter idle mode,
> > resulting in some unnecessary power consumption.
> > 
> > However, pause feature is only present in the stable version v7.2 or
> > higher, and since the latest Android kernel is 6.18, this highly
> > unlikely will affect any Android users.
> 
> If whoever comes with a data that require changes, we can discuss.

Thank you for your clarify.

I recently backported the pause feature to my phone.  However, due to
Android's screen-off mechanisms, I wasn't able to obtain any valid data
during testing.

Since we haven't identified any practical issues with the existing pause
feature, switching to waitqueue isn't neccessary at this time.

Regarding the documentation, should we explicitly explain the
relationship between 'pause' and sample_interval in the documentation?
That way, users can adjust the sample_interval value when using pause
feature based on their specific use case.

> 
> > 
> > [1] https://lore.kernel.org/damon/20260321202858.98091-1-sj@kernel.org

Best regards,
Rui Yan

