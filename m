Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5AAEC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E5A56B00AF; Thu,  2 Jul 2026 20:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248996B00B0; Thu,  2 Jul 2026 20:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110946B00B1; Thu,  2 Jul 2026 20:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1B866B00AF
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:39:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FBB68C65E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 18:17:27 +0000 (UTC)
X-FDA: 84944644134.20.FE413C4
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id A78CC1C0007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 18:17:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=cTOmp2kU;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.179 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783016245;
	b=LJX3tgk+XBka2qshi6yPeCzohogewUMmf69xHzZKAo0lfvS0AepJPT7Aq3BQklBWT5E0qg
	DVl0qp6chwGld33RdgKSUXiPTH53kmc0rAKUz2JtUgFh/J0/qBwB3vj4lzU3vJwxkTNF4H
	7hcWvnLvhNs8j6tGMarymsTCm8JKB5c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783016245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BkwYUHUs3DSbCk8wCkm9DtFHy390UnK0AksZfeOtqa0=;
	b=yEG04HjQJGPl5b8/6gHXlVTfhUMxFfRELwDuerKqWTzepnNQLzVzFG5HFpMRsGEaOipnIj
	i7Y9HNi9sm0pHOzq+H4tNtHS8Qi8upTZ2/R2MY9iDpMy3RgHtJpxgmufKrQp4lBjIHpQLy
	f5w1zF3rZpavrh5dCH2TxOfedmo5dys=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=cTOmp2kU;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.179 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e50979c71so209387985a.3
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 11:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783016245; x=1783621045; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BkwYUHUs3DSbCk8wCkm9DtFHy390UnK0AksZfeOtqa0=;
        b=cTOmp2kUQc6rZi0NK9A/+Xnyykzu1/23PBx1WtbxW4A/7BOJM3NUgBOuh/VJdmOYLO
         CBvVZh6wk/nFsHjNdlT3gcXjDvHvA81Lf68itxXOhzla2a2lkwaSAYqMEEErrL0lVNBh
         7/abn9O76leiwNoUWjDxKuUhRfdyBO/IjViYtnSww3bD53dF8bdx+EpQ11RdD92Hcr6Q
         9NbK5s61FXxghanaoswg3PXXmN6QTdL2KIH3MNfVHa9xl/TSDsht2FwzICdwZeUw5gAt
         vnBUM2j7XgsWwk4i8st5JXoLhtRCkjXpmnvIu1nDNSd4bo/YOlRAo7GpwZhDUPzPjc4L
         pAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783016245; x=1783621045;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BkwYUHUs3DSbCk8wCkm9DtFHy390UnK0AksZfeOtqa0=;
        b=mPOdlRj+8A9nsWfxPE+ZhUsspEpoROsmCYDrLIjZLUbmly6xPJ5CBNY6uflbZRUiBX
         7acbJqQnPWk55ESPmhzGfLGidJyoecXGy6p5r1zVhGUAHgUMIYEVqFMtG1HhOXS79bIY
         t4qBcCHg6AoJoeDoKR65SBBmp7m8ckEIWM7k4ABqJMZea4n2zH0oFjn5AACUaZ1DRP3H
         lRrogwE6TdOkVGNYOg54d4xlvaLqm3TE4gAnZPLsflvAgoouhMCncmz5xteIQxos4DpM
         qOYOREmmhgPICWFm+dCeg8dqIjAajsRzc9Mk2ZtGSxrK2Yx3xaY+JW+FOpvjbcOgNfnt
         EDZA==
X-Forwarded-Encrypted: i=1; AFNElJ86fBQa3AHpe3d0gn7xy0wy4/t3bx6UtzdVLy86AhcjiqGPQtfC99+PpDriCGsCJkQLW7f5zZ1i9w==@kvack.org
X-Gm-Message-State: AOJu0Yx36hVJ1QSt5BZm9ofrwfF+/SqbrNTiodkTJx57Lmx0wqdE1qJz
	wHj7MrzAiLZZmM2hLljxFP3qMLArxMqUjwEKcs61K6x5eUKHBEQq0VzhTHuCKH1ZCPI=
X-Gm-Gg: AfdE7ck8kEjMLdl2gpLssrZy5us5XzRxA1InYri95MdX5ohRcVgdbPRxfklcZEm2+Wm
	Eu2qGtM3cLg13Grznhxrs1rUKhKoBPV9nyRpdkjrJF6STpgbC68SfQkf3X13RlkmK5VWGcSGzax
	3H2mMY9W6rb8SdFJQrqm+bpFBh5DawUa+8xmyYE8pkTXAk3TEPQiGfYkX8UCAl+MVo8PF0vQqM4
	UNnhs6NPKhAU7RLJzhnMwYNFK7HsN8W9STt76BVDDJBc559UEU/3H1/QMQFF6bDhieyKQMQubH+
	HukSNImRUikvsjk56KJN0mkPFMJO4OehQBxt7nffD83lnGaJzrlZlmwUZ5IoMR8ENYnrscy0p4q
	L+4P6CKjJO450keXqjG4CT5q9JBmKR6GaRRq4kSDXALACYutl1eusrGwVMO0WeJdW2oYz/bYJf3
	t6BrjKkNlhE1Jbf3qonHnMT/1f9RAnVJaqAIKjtCTrb8u4Crh51hWw3l17d/cUD25imcM=
X-Received: by 2002:a05:620a:bca:b0:92b:6805:918a with SMTP id af79cd13be357-92e7851c58amr1082989385a.66.1783016244610;
        Thu, 02 Jul 2026 11:17:24 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f4722ca4c6sm32096536d6.39.2026.07.02.11.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 11:17:24 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wfLyV-00000006QKg-1pc8;
	Thu, 02 Jul 2026 15:17:23 -0300
Date: Thu, 2 Jul 2026 15:17:23 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
	corbet@lwn.net, leon@kernel.org, ljs@kernel.org, mhocko@suse.com,
	rppt@kernel.org, shuah@kernel.org, skhan@linuxfoundation.org,
	surenb@google.com, vbabka@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 2/3] mm/hmm: add hmm_range_fault_unlockable() for mmap
 lock-drop support
Message-ID: <20260702181723.GV7525@ziepe.ca>
References: <178301344866.373695.16044452017467686329.stgit@skinsburskii>
 <178301356964.373695.14274584821659522979.stgit@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178301356964.373695.14274584821659522979.stgit@skinsburskii>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ni3r48xjz5gjqk93znxmarn6hijuq54q
X-Rspamd-Queue-Id: A78CC1C0007
X-HE-Tag: 1783016245-994222
X-HE-Meta: U2FsdGVkX1+HY78UEPKRKKA7xBbXhzov7q7sFUR+ZMVbclbA4ZBuYsoh28WcfU2sk7evA1dloryOUQXWlzu5C8RKAOJvnfoL6OR9r9lznGIwvME2l+JRwmiU4/LbANGBRNTB6QV0m11DFW8YDqUY62DUwz87aA1qnye2sgeSldbueV3M6s/LzAWEs3sSk8KBxRTOk+LPhmXYXW60/2ZUszpA0x+Db9dJZlp/XYv0OEycd5oVe+r/AIpJSd86hbw/wLPp8IqbvHwarfkVR3aX/SLaGOQlC3mSgVHjrdPBrKFMroaJqrQzJn71QJqDmC0uIEpJx5kQX0gGFIAOdCMb33P79hLsEe+nYOu8kvKqIPXKo6CwbpM0ErcpA/ydkxwu+uPeowVoc+yN24uLitbhRbWrjiQhT03OUzTYXkH7SIWcvjtLNYdi6GCe2hQWlq+hQzfh8CDqMbVaDMWeCiYw1X9DsalA/6CK800DgAYJM2nlvJs/ySCvLmYjaGnTkaIVgIOcy09SPuS4LNR6KZqZM7/kqqSu2Yr92UDY/5jyFgadhrqM9OUQirfPofxQTIXLSWsDh2KaIuZR0oMBJ3gGhoGxz8unIzCS/xmY56mDsm9NgyMO1WVZYt43eTp5wV59sm/kCOb79RJeMj/xuPPtZspCzSeG707LYit7xXTFpQChnTdeazbO7fQhuVoFKbt7n3cWplbEkAk78wpv+p0aYMlND3uNWoW1tukWCYmY77oo9vP5IhOP2BCF8TKsO0u0mvjqpBD8LfRWPbS4oRQ2hswd/bYJrszT+O8c9gbNGQZQ375mkX79PakOuBKlvbPIt1MTKJk3GJPuAje18CD99jvRB1pMdo6ccIcUysHAdAHqQObK4c2qXIBjeZqQxjgZIWMJE5iK9pcQ4d6oc/+faYsPWeopPi7DfJCqCVoJN14F4SMahqFZsgDqrKXqnkMj2GdmJqwlAXGyHlMW+/f
 aAasyvQX
 P8w+h87sB8lFfG067+O0YSozPcOEmhCVhKgNfJx6/HTfAyIDUBe7n9irJxZrfgQwJ/1tuv3xXFTZKmMRubXRBtO3HWMQlk0jzCnDR+WLyq6hPoHnpUVfvtj5zDwdi/xPagRE/20vAeX1Kkm4rfywSDLQUfZKi30MHFvbQ6r5OBHP5FjhQONNqK0Y5+luAL0wwynrAUqPkGQ5naGpEswk7c97CPPHNlc8PbItmwxUD5jejfvpSqLwXN2C57cHXHqRMQkWM9Ycoo0AQRp5pZ6x31CCS0c1uWUEYBmL3S58OM4tPGJox/j72F4JWpxE/FPhCj8yO+L012aHa0S4Gkn4gRme7og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 10:32:49AM -0700, Stanislav Kinsburskii wrote:

> + int driver_populate_range_unlockable(...)
> + {
> +      struct hmm_range range;
> +      int locked;
> +      ...
> +
> +      range.notifier = &interval_sub;
> +      range.start = ...;
> +      range.end = ...;
> +      range.hmm_pfns = ...;
> +
> +      if (!mmget_not_zero(interval_sub.mm))
> +          return -EFAULT;
> +
> + again:
> +      range.notifier_seq = mmu_interval_read_begin(&interval_sub);
> +      locked = 1;
> +      mmap_read_lock(mm);
> +      ret = hmm_range_fault_unlockable(&range, &locked);
> +      if (locked)
> +          mmap_read_unlock(mm);
> +      if (ret) {
> +          if (ret == -EBUSY)
> +              goto again;
> +          return ret;
> +      }
> +      if (!locked)
> +          goto again;

Why does this sequence make any sense? I think the caller holding the
mmap_read_lock() is some historical artifact, shouldn't it be pushed
down into the hmm function itself? Looking at the callers it seems
like almost all of them want that.

I can't guess why drm_gpusvm_range_find_or_insert() is mucking around
with VMAs, a hmm user should never do that. I think I gave this
feedback many times.

Also, why the goto again? If it needs to loop again it should return
EBUSY.

> @@ -715,7 +804,7 @@ int hmm_range_fault(struct hmm_range *range)
>  	} while (ret == -EBUSY);
>  	return ret;
>  }
> -EXPORT_SYMBOL(hmm_range_fault);
> +EXPORT_SYMBOL(hmm_range_fault_unlockable);

Don't export new symbols without adding users please.

I suggest you add a hmm_range_fault_unlocked() instead and convert the
places that can obviously use it to use it.

Then maybe come with the unlockable version with an intree user and a
strong justification why something needs to hold the mmap lock
externally.

Jason

