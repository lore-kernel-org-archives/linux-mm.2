Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49032E8536F
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 14:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E1D6B0005; Fri,  3 Apr 2026 10:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917616B0089; Fri,  3 Apr 2026 10:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805D26B008A; Fri,  3 Apr 2026 10:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE2E6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:12:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BBD01A0360
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:12:46 +0000 (UTC)
X-FDA: 84617435532.07.A39F37A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 760FBA0013
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:12:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=owPM0zQQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775225564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jIkGGXbQv/txYqXGkFoSltua+ZK9+VXm570t0dxiTBk=;
	b=wJccP502v0HobcZ+0BdJrU+KuYHJJp/oMmwuLyYwbpIHcu4XzJR75cL3oNvakHHDcP+aGp
	Msoq2T24LsUWJ2SHky1K07alD5v+zTVluB5FxnfU43UEgKBIEhRQ5VOXUTt3CrOvnj6Pc7
	OnDks22fs9STGw6QKeW2eaVmrbtcnTI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775225564; a=rsa-sha256;
	cv=none;
	b=nD4JgwJihYtNg1KRHeFr732AW+KfbrHvg0iNNspvFyd14x5IxMz8jJcCr2wMrYu4/Y2xvZ
	O6Ftg54XPbQDFngAo+YEAYei5k395/WwCMd5swEXCJG8t00O3tyCCH2ZR/iRJyn0YdZ9KB
	keb4L6pQk+Dbur23/XhJJSAGluQGnfo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=owPM0zQQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DC1060121;
	Fri,  3 Apr 2026 14:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13583C4CEF7;
	Fri,  3 Apr 2026 14:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775225563;
	bh=Wp0rUchgEfo3aH/vpLC2bON7hvYn0ruFcpGR7D1KSbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owPM0zQQokQ22BSvz35J3xN2jUybaeYxIuZW0oHmducsrHIcOroyklEND2AJZw9sy
	 1zFg8l3G5oIsbSykmZNmyIrRSW6x+Ws9IIoerf0cXKFP3dtI/4c7gOtX9oMFMU8CDg
	 Z3DX+Jyz/T3YZKxyol4IKcVXrtbFGcRpRt3Wj0NSvFHdGXCBthD99a8hM/0+1WQhD8
	 naJRAAFL6ha+Ln/VW40ixEcDvWO6rCAnkgdyCL8ooUDEhwdU2IW1vy1HeWdvF8g5hH
	 L9zP9CVBrXTCBH49QfdzicHNKPD0bB/VZpy9WWFgEqcUa2vF4Wg5vf5985COZDgO89
	 LUNLU4/d9eJAQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/damon: validate min_region_size to be power of 2
Date: Fri,  3 Apr 2026 07:12:41 -0700
Message-ID: <20260403141241.50759-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260403140942.50643-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 760FBA0013
X-Stat-Signature: h6mnank7nzry5thtwr3jsd8zyseqy13z
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775225564-496518
X-HE-Meta: U2FsdGVkX18WW/91+uruuRwDaqi/L2VjpZUpRlGVGx3OnOCNfZwJWii6I7yB2wR4/y0luWHbN946F2y6pCBiTdjxHS/C6TokdmGUoQpqe453ENPrG6UJWDrw/bFwD8yoEX8QGKdmsxbXaamZpR2dPaXSRLmBTcIMd8eqxqy553L++qfE4Jnbg2H7NNFjvuXy2DqUa0pSGITCvWjvY8HEhUJPVa8R5CCnOqvK6SpMDps5svv3yn/3maZ/8HAfSW53s1G5cDmsi7VH6EGfHtonhKXk6H8Iqgq5yZ1rVSjQ3NccXbsRX4F9U4C3bQTM0zrznEpnFnL9RMX3yxhaiJg6OAH1WgmKIlGZurpX5iV1sk2FDzjrw1zyMIjmXuLDG+FNO8/BoifuTnL20kQazQ8oAvKqx6ATiYXkIfYhtV1CPvaFGuAv7Fg4W3IsO5OsR02ivkD3V7zkkkpypN1IHfrzbx6MFy9Hh5TIwzB5Njd6i8gFWAlFPnLkAKh6722y8+zDDd51A03gxTwrfug7eGVb108P5DfZaDUfHNXhOe8M+7D02jlWJn8qAkUkal86yYL5aS2t4H9xchpcs+qRhtYryxbSpx0J6c4ljR6vntbw4oPgA4dvOCrvGbfFqukyjQ+/CE3dyOSfHj1qzS5ti9j7pAaOvcOcY0nfanNWSphpXniczjIpjLCCFb2rr2ZxIg7CD2XlPYjBBDOFHWdikIbmR5zWtPs3NKwedLtk6Bc6dd3wKNyTMm2ljROpTiXi+8XDezwBOi2oQMbi1pEOJWVwrTWn9NVUwzPQIylz3ZLJn3Fus0L6x/0PRUTbTcOVwoBi3Kd4IbgDn71tu7ZFpSRBq64vChgwQV4kHbNyG6UnhL4yVr+kwNSu2Y+UoXKK3j2fgnMSh+W0XXF2djRX1EsNeA9x6agzLF+fwdfXOXIjR8sfTt7/thRZJF21VnGQsSCtARLZBDmNHTMGlXdgCvO
 etMekjpS
 mKcK+/5fNItofHqV0z1N6KTztgI1VwN1ZX/hKO6uFv1gJgQ8WT567O8hfLITfSOK7p74eMS9orDFsrgBkKUySnn3Fjr5iJlEW1tezs06d2Bc4FcqjdWSd1s2qZKawfJqfCDJHIwgpgE6HpMXtrKqnZsVnyKxsne1D0IbL2urnPjrZmMEKbRI7HwyLNsAtW/aMIta8G1jSsm48tVEbRD0iuTxUHcQ2IGjlEjWRAJMzcTHvzFFz94NcpZ0xpyQeWjzOcmYa5BO5fEYq4vEr4qz5ZlL4Rw3rxyCxWhxPRbu5rWzslCyVJ7JS1VhKMmv3RzorZiCP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Apr 2026 07:09:41 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Fri,  3 Apr 2026 16:29:10 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Hi SeongJae,
> > 
> > Sorry for missing the discussion before sending out v3. I was too
> > focused on the code and missed the context of your questions.
> 
> No worries.  From next time, please ensure discussions on the last version is
> ended, by replying to questions and waiting about one day for giving others to
> chime in, before sending the next version.

Also, please don't rush.  Let's take enough time for both writing and reviewing
of the code.


Thanks,
SJ

> [...]
> 
> Thank you for all your answers to my questions and requests.  That all make
> sense to me.
> 
> > 
> > > 
> > > [...]
> > > 
> > > The code changes look good to me.
> > > 
> > > [1] https://lore.kernel.org/20260327062627.66426-1-aethernet65535@gmail.com
> > 
> > Thank you for your review and patience.
> 
> You are always welcome.
> 
> > 
> > [1] https://lore.kernel.org/20260403052837.58063-1-aethernet65535@gmail.com
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

Sent using hkml (https://github.com/sjp38/hackermail)

