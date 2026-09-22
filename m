Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21B20C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 03:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4718F6B00A1; Mon, 21 Sep 2026 23:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FAF86B00A4; Mon, 21 Sep 2026 23:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C57E6B00A7; Mon, 21 Sep 2026 23:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0476B00A1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:46:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 197F28037A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:46:25 +0000 (UTC)
X-FDA: 85240010730.24.9C5E86B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 56D19160007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:46:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QKsfj2J6;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790048783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZv0n6s8W4RcQuBAt0aC0jgduTzFU5fp+QZdqfQumEI=;
	b=PuiKVnHXAZtlsWKxFlbdnSBnltBFi262DUFRp5zOh9LU5gHZUxD6a+TpNzqqcQpbFdN9T4
	baAhtqQcp2hmpKRci82Z8xpwuqQ+GFSH6ISVRoeknF9NQl6EzvjDkNLBiUiPjxl2NzVUJu
	nifqGkdEK6/2z6eqweAGPYkl8a7mFMA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790048783;
	b=2ZpwogtdyUbk2gzke8q5SBl/FP+kyfTr4obk0/YIcR6xekljtzJcq/7kTYssr5gHc5kJT+
	ktA9zCOF8Qel/PMA3otQF+e4UjpUAgvDJG1YR/y5prgdGXilcySbu94cDX4pilSnmawPVO
	keFHx4uHyCxpH4OXTlCFcOJLrK/kkNY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QKsfj2J6;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 56977600CB;
	Tue, 22 Sep 2026 03:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC041F000FF;
	Tue, 22 Sep 2026 03:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790048782;
	bh=zZv0n6s8W4RcQuBAt0aC0jgduTzFU5fp+QZdqfQumEI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QKsfj2J6ILwU9ERjb2WSsLzQ+4ZA89gphCmxkl3jxiHXMBm7NuoMVUVgYKnsN2ywU
	 Gkgh91/LRroaj3w2+ok/XBcq5qcYhcCA3il0AhkkdSPV/f3rEiy+6pIrGuEE+K68xX
	 MZbl0T5T9gWqm9j4MwityESBQo0HAlVb7H4P1PIk=
Date: Mon, 21 Sep 2026 20:46:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Kent Overstreet <kent.overstreet@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] alloc_tag: fix a leak and a deadlock around
 shutdown_mem_profiling()
Message-Id: <20260921204621.6724aba72798c03e19c235fb@linux-foundation.org>
In-Reply-To: <CAJuCfpEUYztqobQDHt9GwJZOcn5JrOs49a+8AVpu_ySUG_KkyQ@mail.gmail.com>
References: <20260817062726.106511-1-hao.ge@linux.dev>
	<20260826203914.347c42aa00081ee9e0eb858a@linux-foundation.org>
	<afa606df-3d5b-47c2-9972-f3e0c2e13c12@linux.dev>
	<af33dfe1-04ef-4bfd-8c79-0593b24c6bdb@linux.dev>
	<CAJuCfpEUYztqobQDHt9GwJZOcn5JrOs49a+8AVpu_ySUG_KkyQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 56D19160007
X-Stat-Signature: z315t5ab8u8ghh144jmytmf1mspj8z3u
X-Rspam-User: 
X-HE-Tag: 1790048783-417223
X-HE-Meta: U2FsdGVkX1+FYPA0G2A5D/nUF0/uSJ+FyhsWWfIyLuDLPqzxbXuq0AqWJuU9RfNQB22dtMJFddlbenwDEY8AnMOVRigU0v92VqMr4oIrbNSxuFH4yxMREgix90GIE9FmiUmOmaAoLjzTqEcJWjHJgsnclDTqM9rnlT1QwQQdJlm+u8m1KGFXDxGxMQUPfD4BBqfAUWD+Mec1M5vbUNdZISArmh6liRIAd9brqkjCmwFZ1Ei5awoZEkulGHxmK3An2bNTo5QY81b9VujCiYVHd1fcki6ygBxWjyUqcY/HbWka62AblBUxRy5TmSMyJpbO3/hpjKhXXyKL/p4IRg2oGGoWhN3uiNVHZIZmK1AblJoiIqyLba1rTCGLzDxtWuprnexRTjN0aOWT4bEPOpbREzJSCYO7JgV22TExDDU3tfsJbGu8WyvGiDP58r3YoUU7qpXEo6xGGRLjGmi4B2u5fYociMoJACLJY2KNQvivO2lhhjfcv1sdoFb25aSY+gxllRMcX0EJNmQPybl0fqCN7vhjxH+vX2galHXpS/bcwQvzRqTuppCQkVY65zRUSB24PTYr9I16mO0De8YDg5COSd1JRfnVnrKTh1CozlZ5fje/ppOIjbVmILSPMiMLZ8gn5hCkcbfR7lLHveXw6W+/2O/yUPlz1to9YRborH9yTobFLEkmrA2y7qCxB6enwysOfk3+CJNawi0SsT5fW5PVWcElwjBsjE3lpFomSlP646/B6G0gEG0Ofn/Ut6SfP37nmIpuR8qg3x/RgN3oNWUhFLcCm1cOQg46lpafnj4a9QGAlmKWi+29pAsHJiHv3NYK6EQjPVCC8y9IbP10KQtLrprIcK8t6EXWzxiz69SnLjeAh6ZHBKStw/d/UfqT5e7jwXWbf7ZLvqyCG5Dv9T0gk53LU7lYeUSpOofvwIgeNoBjtTCj4jrKXa8PfvnoqPwctvhISqccXr8vrNfvPXR
 5x5irziW
 oy4jXhZyckKs6cm9fYqWZ0IcHxCwOSLbsIufl0ORzY4xq0uxGZrCxFqguwp81ubrPTY3NtKn4ihsbRPVCwu7mbXGBV3bTQjXcZWrqhrwVbExggxoGUmXgxbo9qoInZ3XJhhP8B4NCO9ZF8wyUg6WpLAs2xkrMVCjRy7Y9ZTHak3Qm7MajsT2+as60uTecjRm6GSrtXan8BAGTdQyKSgFKCOBB92OkGYRDu9GHsYCRrDpBhsM1JbqaM6wpPMYSpWkTmok+Aff8scuBOkf3pCZJbS53X82Af7RqnsiLfb5hLaj4mQmHXkjilruC3z6sk1zApmpcC+3R0cKg+I3uTMoM0V8ZQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 07:36:27 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> On Mon, Sep 14, 2026 at 7:49 PM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > Hi Suren and Andrew
> >
> >
> > Update the status of this issue surfaced by Sashiko.
> >
> >
> > round of review.
> >
> > Please kindly help review the folded V10 version.
> 
> Hi Hao,
> Sorry for not reviewing earlier version of your patchset and thank you
> for pursuing this. I saw your v10 submission and will start reviewing
> it. Due to time limitations, completing the review might take me a
> couple of days.

As I understand it, this 2-patch series "alloc_tag: fix a leak and a
deadlock around shutdown_mem_profiling()" will be replaced by the
series "alloc_tag and module codetag section fixes" when that's ready.

So I'll drop this series from mm.git.

