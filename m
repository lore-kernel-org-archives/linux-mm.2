Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B9DD10BA42D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 05:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF4826B0098; Fri, 27 Mar 2026 01:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCBEE6B0099; Fri, 27 Mar 2026 01:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09986B009B; Fri, 27 Mar 2026 01:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2A7D6B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:50:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60F1C140F95
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:50:58 +0000 (UTC)
X-FDA: 84590769396.07.BB973E9
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 82422160006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:50:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LrIPO8ry;
	spf=pass (imf08.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774590656; a=rsa-sha256;
	cv=none;
	b=cb3i4TQkuaZET2buf4O531HL25OvfViStjGcGEG3Cr44HecMY6qyXwKv1LbgqWl083LT8B
	nx/5KCCpQsk9/REu8cdGISHWbSN7vOucnZuDYOT278FmxsFU3ABe9srVaMLuyDyQ+3SstU
	a5QUk1ISAmlb51ELYh36LIi6xbrHBtA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774590656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/QKYZHcQVRzoD3H+dvFRXjD92ZagIwWgZbCKAQDMQpc=;
	b=j1vt2ENLJffg8VF+7iKnHo5F0B4FtbWYc9L/SN7ohrx0Y0QGNnGp0NhUz6bw57wfN2Y9bX
	WjPlBnI9l+wo0j6mgoMC73bx1TJXqXWaWoMPJCgyed/LZBmnxVsNZbdzY3PLMEWf1YAC2Y
	m1cELlEH8ZUV65w8UZkmItdoOAu4piY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LrIPO8ry;
	spf=pass (imf08.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b0ba3bfe16so15419265ad.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774590655; x=1775195455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/QKYZHcQVRzoD3H+dvFRXjD92ZagIwWgZbCKAQDMQpc=;
        b=LrIPO8rypuMVOBEocCMYbXakxMgQh7jo/VhgC5FvedluGDyP5nPrd3kbmDRtsUj6g/
         ZrMMdzNlnXGoovR1CWMtpToJtjnyR+Y0WtlA1bVyoRMTUjOy57adCZHkrsjIeflHA2ib
         eqDDGvo2M0Wttj9s13oOQ8D5DqS3BmL/rEv61TNpgnL0hJEEQcFFYZ43gyPjPc3U4dED
         KtEuhLj3PKF2FM/nzCWt6hsYAsHfbXFsiYUzBwjBMzPkh74URlFv30ombRa5k09Y9oM1
         oOTVtNx8GLcAcb4Ju1klub9CcnUyfMeoZy1K1Hxb+qPFIHV8hX/E1xjT/Oa38YaIQiPD
         boNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774590655; x=1775195455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/QKYZHcQVRzoD3H+dvFRXjD92ZagIwWgZbCKAQDMQpc=;
        b=K97FluHWsJGWxIWOXaG/QCJ20qbtUoJbtM9k1OEwlqO94uRNRz1bMFl3j7jELC6vze
         TXG+IvLcuf2SY7zRVwUd8tsxFlirF4YJ8McgKTvyXLrxgTogCh7O8zPk9M+X9D1YbYGI
         /F6HPNvkE9O2dTef8sRwK9uSx9mIas6K+LmW8V0h75ns6ZHz8VYcbo3HkNWRdCUtRaVK
         K71R+JM1jbozs8FfWWfAsOF6F2onP4PaYCi5RhDwRt21ftLqZ3QNpwh4wc+AlPFx6iV8
         OjabuqaslxRLKrDrgLUkIi3k7XdPCE6413PMXmURW0ko5r1RTt6wsZwESGeZx6PRXfLd
         RtJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDjk3Yfp7tDG2wESz4M4rFdgUqJtzeowABRyy9laW39+tRvvSVYtjL2+1JLNk0ZZQgdrcJi/n70w==@kvack.org
X-Gm-Message-State: AOJu0YzsEyq6J8dYH1OmrYl103DbAlfmxGfE4/bzINdli8nmblxF0tip
	taNy75/7kptoLQ7R4QL5lCpApc0pV2Ee2UqG2R9eRAmy7jV7d3hPUY0n
X-Gm-Gg: ATEYQzywhKO0cOyJQ49v6S9aXHZ0cLwN/1iKI4D9dk2FQtkgsk426ljd4tbEuzxXHYC
	zg3ZYZY5xCoaw1S2xHGT396UokH7cMcmpUYRVilqAzYoIBt2jtw20jQK/O/lZII9PBET5LStLVR
	Wo2nT3r4ca6EyhrssjDFIw5hmIVzoRP0/ZHUAZYEiWXwdbc21CXc3Y/5Bl2uMrOLddSSa0fdk0I
	93Ny9AHUawEpIKAzh7dZo8Swcn/7/0ASjhbKg6INKbQ/Y8zCP8IjYRGEq7hHW8b+1QXJWhReNS+
	SMyDxV+d5YVEJTIy0Q3IIvUSNqJcRBAcIemY21RDaKur3R31HRhUwevlcG3BW85FD9Tg81rCKmt
	5LAwNz4UJrvnvuocJpq3Pdmbw//yh9XIKEDL+UCVj00XaGS2shM88e1Bn+49flbR5gl+Z7PlloE
	DKCBhq4lZczsLJ3i9FpCTid6eezxA=
X-Received: by 2002:a17:902:cf03:b0:2ae:4d6b:b2c7 with SMTP id d9443c01a7336-2b0ce4ee4c8mr10673135ad.9.1774590655239;
        Thu, 26 Mar 2026 22:50:55 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc916b73sm59918045ad.83.2026.03.26.22.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 22:50:54 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC v5] mm/damon: add synchronous commit for commit_inputs
Date: Fri, 27 Mar 2026 13:50:51 +0800
Message-ID: <20260327055051.61731-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327050823.43382-1-sj@kernel.org>
References: <20260327050823.43382-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82422160006
X-Stat-Signature: nnm531ak7hnbmhd8inadzz7fxtnsibxk
X-HE-Tag: 1774590656-372125
X-HE-Meta: U2FsdGVkX1+bdOLRuDTjUbEz5AOtL57GhzaxuTsEI+zlKV0qGVTxRPxqvnIK+0jR3GFgbkpd9pqKM/wTBxO35WSC5PB7vMwbPsnRCMelLNyConwWtrmYs5aGdZeYNIlNfIwCJT2+v9iPuFsv13uSyFRNgl63p7DkMZJcotrUy+hACtlDwxs2xmy7c07/dE3sPOj29/C6oNJeoRgDPMMZ+r/OW5/JI1sSrbQNoGeSgoQKHK2GQBVKcnm5+aZcrcap8/IGFhyWcWOd9NyTBc1PZ29ch3rd3cmQPkY27kaieaSI5oFwNUtj3eE0XxO7dglLJanP0YCkgUNz826cAqinBs6d9f+wMKP/+t4K6HJtFRaBiBTpPgcUmY9KonmR3hoh9gPT5lc9S3/BjXwdc9bu7jt8LxKksT67IVdf4tkQjF0DP4ZcrGnT42FVq6JdhheWr4AxzowE55ElwlCJHZuGW6b70pZOYHZv1CyvMbMXu02DnHf/t/7p+HsGcmLrvo3Fn9sP2uJ8P6AVkNhogGLB5nSGVv1vD8j52Rzz6rQcJBQ8oe40loVq2ZMBfL81BJm+mrroMBR4/O3VOz2YdixlHVdiWcSVeffV7gd+42+Ls82rFywmQ9dAT96XTETJ9LZUzIV8bl516mi8JFNyr5YwCZYgr5rLufCG7aUaHFodY+h3VQBZjY1bK2UHQ2h4rel3Y7Svdm3sirX487dA1DJpzPpCsJrNvysxhNzjIzCccPjyuEOf9yEgBn1FZ8dAb7tpKGqlexf4k0EbtFURRBJami8q2CAY04mQqTqkysS4Kzn1/flcFFb1xMCEgMvGBPEcfK4eTZvkWDZgKAbP0Vg/KYLjKtj82cOcnen1XtvdxxqSc1eOzAKX0KKco7PxGVHTMpElNFOrXjQZuDtxkhLavEyETgIrYMp9Q8toFzdaTnxZbZslKoUN5CfMHIjr4a6ChzmhaM0g9sFkj42P1q/
 kyMXw/kS
 Fa1vzpF0T7iQsjCB4lV+u9aI3EmURLXcnra+FvzJgTmKmm97gR401eXjNFUKjdaV7LI4hg3myGLVBQjPcdMEpwqq239D0uBcBa/oaRkeicstsKVYn4Y803BjF1VBVNdxWKoTxTCI8e7g/jUH7zESuQH341bcxpvXn8CIvgxsfdOGMgBJi9Au19I8yX7D94TziBeYMctVoHLvgXpbIgl5SOZ+TujfUX1CHDqLSUN9UqnALHOxp7GxaPsTnK2BrSZytSHq50YfAhjRD25Kr5Tczzdl70quWtv4jRsatTAo2HX/yzjnn8smSH1TVENMNuZyluXGilMme1rP1824efkXJXU7U/r9tnoebsdbmZCl6HGCFRCzVX39g18cpj564fxAedratReHdOjHKjSMBn1jeD+VePaNbmrZNxzbmkkpaXJOt0Lg8LHiFGVd1jUuTDENH6InO7jPuJ/IsDtQ0ByI/vFXPrEQbXLbdmCjNNC/+Aba2rt9gzlJFnwLRwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On Thu, 26 Mar 2026 22:08:22 -0700 SeongJae Park <sj@kernel.org> wrote:

> [...]
> > > > I will add a patch in v6 to validate 'addr_unit' in addr_unit_store() to
> > > > reject non-power-of-2 inputs immediately.
> > > 
> > > That's because kdamond_fn() has recently changed to exit the loop if
> > > damon_commit_ctx() fails in the loop for any reason.  Refer to commit
> > > 26f775a054c3 ("mm/damon/core: avoid use of half-online-committed context") for
> > > more details.
> > > 
> > > Adding the validation in addr_unit_store() would work, but it could be a kind
> > > of whack-a-mole game.  I'd prefer doing the validation of all inputs in one
> > > place, just before the last damon_commit_ctx() call.  DAMON_SYSFS is doing so,
> > > by making a test context and try committing user input to the test context
> > > before doing that to the running context.  How about doing so here, too?
> > 
> > Thank you for the suggestion. I have now added the check
> > '!src->addr_unit || ! is_power_of_2(src->addr_unit)' to
> > damon_commit_ctx().
> 
> No, what I'm suggesting is not adding more checks, but reusing the existing
> checks in damon_commit_ctx().

I just realized my previous reply might have caused a small
misunderstanding. My intention was not to _add_ a new check, but to
_move_ the validation to damon_commit_ctx(). So that patch will only
modify damon_commit_ctx().

> 
> And, now I think bit differently.  Given the purpose of this patch is making
> commit_inputs synchronous, I think making more complete validation check is
> somewhat that can be done separately.  So my suggestion now is just keeping
> this part just as is.

Understood. I will keep this series focused on making 'commit_inputs'
synchronous, and prepare the validation for 'addr_unit' as a separate
patch later. Thanks for helping me scope this properly.

> [...]
> > > So the issue already exists.  But let's ensure the fix is merged before this
> > > patch, since this patch adds another exploitable path that can consequence in
> > > whole param_lock deadlock.
> > 
> > Should I wait for your fix to be merged into damon/next before I post
> > the next version?
> 
> As long as you agree about the mainline merge order, I think you don't need to
> wait for my fix.  Please feel free to post next version.
> 
> FYI, the latest version of my fix is available [1] on the mailing list.
> 
> [1] https://lore.kernel.org/20260327004952.58266-1-sj@kernel.org

Thank you for your confirmation, and your fix. :>

Best regards,
Rui Yan

[...]

