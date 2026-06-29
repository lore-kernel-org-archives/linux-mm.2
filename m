Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31FAFC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7FB16B00EF; Mon, 29 Jun 2026 09:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C306C6B00F0; Mon, 29 Jun 2026 09:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D4A6B00F4; Mon, 29 Jun 2026 09:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD746B00EF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:26:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A985A0101
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:26:47 +0000 (UTC)
X-FDA: 84933025254.11.B60AA39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D522180002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:26:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hyOkg9Oc;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782739605;
	b=V18BxbJL0gNJJ9OXjhPJzkzNCnBKNJgJ5u8wUdnQipPQpdDMtHs8C4n+54nLcjfns/+n4e
	tTjqNy694YzNnJD6ydeELa0JkX3KEEXwPDfhhTrEG7uAe7GC9LbjCBswoFEP/oJbyZ6K9y
	6NL2q+v+NAXplvQIm5hTSSf7bz8vLLQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782739605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8ULakCzLsWXbut5dk0qJu4BUbPuCQCs0oXe/SzVkos=;
	b=d5QCdxSEZ0+rUK9znnXwsqRH8c4E5V0fnYjbbk4KLBKWVP6w/95zzkHoDnTqMe/AxTVaE8
	mYVD4TCBfBnfjlh/cDf3MzYipgprcPrblZjiGOF384B+VtOjNASRIUINHX8ERlx6cDtPdt
	o1lrBThcbJFwOXzUkmlvtuS96Hw9AUI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hyOkg9Oc;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6014640B0F;
	Mon, 29 Jun 2026 13:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C7C1F00A3A;
	Mon, 29 Jun 2026 13:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782739604;
	bh=u8ULakCzLsWXbut5dk0qJu4BUbPuCQCs0oXe/SzVkos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyOkg9OcJ2pdQbr3lKDnJd3n10vcR5hkZ12R70W40Tp+M69i1hJFYPRp/7+K27rj0
	 fm+4ODdXl/T2Aw1QEy+xihsoycDNcycYmv/RcxbSY0u2Nzp+i72Vj0j2GoLeCGypb+
	 H/CJqlp78ubNiCpI9a8RPFINrH0M7Gk9YIY33+wvocGDXcQoyGZVSYlDjuVWCZ4PTG
	 tEX3XQlU+iXk72Q+i/rVNPXSVYbw4gZsXD0yBm7fKGzMwYMG4aZ/1CwW4k1RuCgBS8
	 uWbmr0B66Phk3fM/sBsFQQeBKWbpOZXSQfbuX0SXzU3Emg2kMzVYGEHYrL7Jv136gi
	 tNVWvCFiMYR5g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/6] samples/damon: handle damon_{start,stop}() failures
Date: Mon, 29 Jun 2026 06:26:40 -0700
Message-ID: <20260629132641.159851-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628214900.243ae17b910c18a4434036d7@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i84hsgiuzw3rajaakj1kehguci9z5nhm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D522180002
X-HE-Tag: 1782739605-663489
X-HE-Meta: U2FsdGVkX19zsPS5iqhLg/unpRkbd9ataGqC7ndqsoo9tPDo/DXxaOEuO6dp6E+OCigTz6C7WepVx/UD1amF6o2TPL7stnGnSuY+QvHrpzZb4Phq5PnGidLuNjs4nC1VwOtJ6jfHh+LjLR1hpI8mAvmv/fX4Whp9yEQSZoPdSRfx/9n6qV4Uc+Y1XIVluQsSq5cctRoP2QHmKjteAB/15g8h9JCfahOUaCgSY6YSKTqDwjIMOY+l9qiNgCh1qCQoLiuqf/V0qYY+16RqgD+b5ZXCXvO9svNbnqNTR0iBXFnmXLUH1+hwJVrb/1XbFefH+juqUIDga4lLwXZUgxbCvjgfRcqvfPys7sS+/9PPBIWreGUePSyP+GRMDMgod7qpVVDr0DFEVJx2aIIOzQdn1gzFT0NbO3fRw7APo58GIMB3XqzNc0rxmBZNsJNQ/SerUA4EXazmm2cJvCjUBl5QhPo2wsYlSZKHYlhqdDCX2zmhXBFZpQvVKp3U9rfSxB5mHwDr3dYdEO6HFYKm6ld33m7wyyE5b73vEZmWXeKtcm0YHXxNFwGGDnXS+gP+HCSe8FPrPd7zrINiFsYGZ6fDdzDl+2yhFYVdd38nJ8W/SoXQyZTbX5bULHzNEu5AOxx/r6a3iCMJdvpblcNG/wRH9sh6I4jCNlvUGM+xE1lrOqq0WYk37CGhP8TMvaZ3G/HyfE/65qr+CUeFLUWBIgVWeEDzErwwSdsFzVLP+mD422Ua5Y+D/8O+qN9USvVVh5ddYh5jtmXOBr9SZ3+LmR+CCLjeFVFnVU0MgWx76Iw+16q+1dUOwS+xbru23jz052ib4B8Cgz2f30z1pf69LSNVruUt+zRISuBwAYBWeAADFzlNZK4JMwPR8QwwxrLsQj10vq79xdXHaD/m0b2MOK2M8nyVWBKfs5iXVuxVTTAfpi7SmFQ91a04FYSfXQjfDC54nVXjOhBDuK4P23orE72
 f4OjDQWr
 Q96XaD3Oe4TKbx9rZYuSpUo7Ag5rpbYafUDu7ipaOyytSZpd3izlk8U4+FCzqf3Bdoi8wzDI2+EpHCJZ8F1DztBDJtINdOKajODzbSHIjLTPerxSsX4+v1u2N2O48Xo1bTSE3AK3a0yb94wgDS85KLKsRUeKQSUrtk4SHg3xl3JGFebelqo/G4luBnuZlAHNIFZTU3Sf8YDFbFxy1H6P7lvRtq1V3XYoFRAGoLFQdtB7kYSyTukoIDUw6nxlZQ1c4WBDRZjFv+Zvk1LGAishJEwgCXJNs1qjmQksvqEOnKfkspncQgxhhfAWfSuz1tgADjQbB1vLHByz56SN/Xi+fwJ6Qgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Jun 2026 21:49:00 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 28 Jun 2026 14:54:39 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > All DAMON sample modules are not correctly handling failures from
> > damon_start().  Among those, mtier also has an additional problem for
> > handling of damon_stop() failures.  wsse and prcl also have a problem in
> > their damon_call() failure handling.  As a result, memory leaks, next
> > DAMON operation disruptions, and use-after-free can happen.  Fix those.
> > 
> > Note that only the damon_start() failure caused issues can reliably be
> > reproduced.  Reproducing those issues require the admin permission,
> > though.
> 
> So it doesn't seem that we need to fast-track all this into 7.2-rcX?

Yes, I think it is fine as long as they can be merged into necessary stable
kernels in reasonable time.  And 7.3 also sounds reasonable to me.


Thanks,
SJ

