Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B71C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 05:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67F336B0096; Sat, 19 Sep 2026 01:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629D76B0099; Sat, 19 Sep 2026 01:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540056B009B; Sat, 19 Sep 2026 01:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CBEC6B0096
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:44:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 922D81201B0
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 05:44:17 +0000 (UTC)
X-FDA: 85229421354.30.DAD2DF6
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf24.hostedemail.com (Postfix) with ESMTP id C3C2A180002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 05:44:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="MHRD5/hp";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789796655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eycts9u1BqM6pEzcHLiCKEjmginPPloZHsyT+3j+oFc=;
	b=TgNL47rbccOWHUUP1/TgZ3BwMISXtKolvYk+GF4MGYMObVvrXfTvll/ulvk/sN9PgH+Jvr
	DuGYHmwXN8JqqmMEWR/wChAohL/UWBMGRrcf1h1tXGuqmFcrhBo3KauaueDY0onkArsWqk
	uFybqtNCNor5OXRD/jCpY56KcK/NcAc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789796655;
	b=AeD9pq3CEtIw+FTh9jaUElR/7ZZzGrkjpEQkP9XNUh2ZPNxx5OuQiOfPWLJd8z2G1INhvC
	c9wIq5v0mJJaV+m7W+CGnTv042ZPBRK+y9Tq7m0BOFJpof8ZXJ3Flr5i/4qTLxHqFd36d1
	ZM4IKuX4jEgExzBoQqLvGOQzluY0cds=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="MHRD5/hp";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ccead2aecso6940615e9.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 22:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789796654; x=1790401454; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Eycts9u1BqM6pEzcHLiCKEjmginPPloZHsyT+3j+oFc=;
        b=MHRD5/hpVyvLO8E32unOURuAZzQf5VtQmxdExO7JAC9A38+kUWrp/Xy/BlDcJfkWO2
         jImVT0wM0q6i/hiKBcisrts4SP/LRnegPEJsI2A5pIQZqbGmuf981qVVgD8/0njIRt2n
         E2Ge7G+NGuZZPI8yU6Ghib2gIFD2ikils4bcl3FuscTi2LLu+yyKHRfIDLE/zz87kAJb
         fzEDM8DJet0lMEyndZTepPHvsWUOWm0ILlvTbY8yteg6ZFn1Pgt6u5PTcXUP7DkJh/bx
         E/uJlVTuwZwCAw2HqTo7yanZ7Onj8GBEvRwNcllgWSY9qMRELBBrCKfsXgujODgsn/Gi
         ijew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789796654; x=1790401454;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Eycts9u1BqM6pEzcHLiCKEjmginPPloZHsyT+3j+oFc=;
        b=IOyqY4E2YSFc8dq6kX4+KoQCVxMkrFAHN1X07JzicFgeA8qgiyzuqxF7lt/T/h+ICh
         uc2DMK4l7wFbZW8THZv8roPrTifUF5KIJ9jurEIjyowYojaj8g6+e8IgMnQYhlUG13Vn
         yE8twWJcSfg/jt+eaz0k1fwlxJTFlJHxS9rMYyZYwHKpSj2Dne7vO8sZar/f4OWm4sk+
         F6kPr8o44vXTYFThitlUY5teaSgyrmW9EYVsQF4VT8jNtK3l15nkzR4pOI+V/Pu4ttEU
         jemXRLIFYJ0fHG62Xu2f9EzWyT6oaNSQhdFWbh+pUtKPPpHzpzHc4ny2/h60Bu5M6T9q
         cq9g==
X-Forwarded-Encrypted: i=1; AKwUvByFFzoOMu5kV0yMrRgk2KJ8r1WGusflnNUIrqfPlfmvYrCcEDw4O6kGPwx97HtxnWXTCYD9wzKt8A==@kvack.org
X-Gm-Message-State: AFuF++lNk5xhzjj4einf8QSlV52FSahQDyN7FQXMsfV47Bcvx1uWEZO3
	Uot7QCGZAchhpAza8WiLbgcHdZKWg0/ofbBcF9zHILVa+eyKlCuDrMTC
X-Gm-Gg: AYBFou1xgIjdge5QEgZC8ehH7mmDINFS6yyN+ZB7huByXdtEjd2uoPwmwSdgHnDFMJI
	ue4E1H9SR+W38Scwq9E9PrniS12OOwUuS+whZmEyuHWPyCfPM4KzTS6pwAgcWPZ5t7eL/fuvxQQ
	7G/AE/oXDex7d32FbaWQHOko0o2tBi76AQny2tGjEAQxmzjMLvs6BjQm7YUbgAfhkDf14Vg6xk2
	zGu5jmghiZ5W579KkuerZI+5i+9Z+VfOrK4KKka/vbojrW+9vZlN3cgxkuyp/OKqgbxAsvvzAvS
	qfOhBHzpsAf4e2a3nhk9zvsXnkv49AnfHfwNax2ljsIRLcsAQLzL+M1WARA+6p2Scb5jPzmDJKQ
	/Z9PrNiXoVCmbUTODidyRbfCs2Jy3YmeGyG7PdsAQ++eSOo7eP5/E0xu25iLCqrfl3iVEf7jwWM
	3rIARcL1kZk4Upc3dBlxz/y6yBC/0T4l9jnNDoTFmoem9ChADhq88ApVEn7AVb6r9jHi2nwapw8
	+wh9pp/YIs0s0t/+yWaDwGy25yErS8lw0nGAAMw6lSFVLBhkiXa0Ym9iF8IWib8POxLe5l3V9N7
	kidcwjAeBPBWQYIgo/mEFJQXX6T6hQa+1I4SiCXPfeICpkYuFl7uxL+pEDFPZLR0LXbDNy8Fmyt
	RuVEFN81sgE8Cm04=
X-Received: by 2002:a05:600c:5250:b0:49f:bd0d:59f5 with SMTP id 5b1f17b1804b1-49fc5746338mr64293805e9.18.1789796654317;
        Fri, 18 Sep 2026 22:44:14 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a017-2b01-05fe-203b-7cd2-a640.310.pool.telefonica.de. [2a02:3100:a017:2b01:5fe:203b:7cd2:a640])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc585920fsm251972985e9.4.2026.09.18.22.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 22:44:13 -0700 (PDT)
Date: Sat, 19 Sep 2026 07:44:11 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: score an unmeasured PSI goal as not
 achieved for the temporal tuner
Message-ID: <aq4g5W58PgWLqJ8p@gmail.com>
References: <aqm1ZPUHiXf9PFWq@gmail.com>
 <20260916001311.101024-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916001311.101024-1-sj@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C3C2A180002
X-Stat-Signature: op79jgt5739tn6a19rhdskkxbch68m4s
X-HE-Tag: 1789796655-388261
X-HE-Meta: U2FsdGVkX19uO6MFHSlxZlxrU03GGgL86y/hK8eZHVUcCPsIKh3WXyjdqBskBhPYPuJJtyZLn6dNes6U5lmbIFujjAtqjUO+mFkiyoG+U8iGphFwagv8q/Taj4ys9MmoHTZQ3NnGQ16UcBYiGxaaddQaqpUXg/5BTSvULl8+qYaxhZxIk0if17Pf9+5qE+ZjTxSKYbtF0/IoyKC4RPBWjWYh87XS905lg6UiOjVSPMCIvzPzkDZCpxn2sWFZ938JYqItRzcG5hgh9SP5FwyGyThOkVjbkp85v2GjllzTV5FEGFPe9INtJVzTd/qhMylB+QBJZZk514mRk/jJ/i2Y8B4IqJqFcrXuam5HAet4e7JbrDsVm38z482dK99YDYbcXgtocEfvzw/7JpHu2BqeEQ6RtGZ3GZsIiqlilsyk0IFH77cfghcbG8+bnUB2/gCvWP/1nogbxqLpWLZ00NwRIR0zPLBjHszULaY38RrUoqQlje0tba9WNBhHzZui27ShbQMth3NOv/WtgZ2E3isV0DO36ZxsO3eM8Jqi8W4nr1PL1XG+QcmBabyEoM198W9BoBnqm2okGJA6jFMBFci3+A0vQdfPcUBGCgiSm6Wx98GCTWS7XwkJfMkHiZ5Iw/5D3bEjtZGVpApE1MivoFqcEo6qz7KkX0D+J6bgJ6bLsi7sjU7j1FTACskTxnxTmPn5000BoaRHNAzGRvptTxLwLgAt00EsUohHBmMT6B3ZyGjTOQFCA4Su13+ygSUP3c1MQq6CzrdHHyXvOlS2FfYGgCVwUdkF4p+P1cNQjtemL8tK6DvZaypL4fHtflnSK3GFefNXhF5v/3TUwn4bs+I9PCdH300EMqjkiQH14mrUxJhNXgG1AzCApDgcPPophm/mdnPRqWNqIV04gPpA9paYfSoGDH18gtwLotQUa9fwy3xR7z7My2h+kUXvcoYMR7o8Dw4h6mt4y1QNICy4XSO
 tYM+b98X
 16kaGJ2cFrYp4Xs2e0+nhfGqVCbJEZ5vJWVTtNFP69ni56QDJe7pQXxE5ROLkuesGyZmkLqYL5acqxFHiQNpd0uEVy8ewx2kAT2suI8SNv9J19PAXIBuzCHHv6f3z8SgIkRdDPHSpgQ1hXnbqGbXKBePZu/aMyLxaIkrIUMwW1oRwE6lX5Jurpy6RjMiKr0BuUR3lzBA2qynwkCH1bfbqhwlGPanCkVJlyLkSqNQC8VH4Nn+RRMqr45+ml9C3SWppVnhHsm8IAgD3y+MbaBbzOs2IzGZSyCvovppLBcg3RH0JGlCrwMKFKpBq/42JE+EtZIxgrsbrXiu0KytguMZZWrO7kqoqCtDAjUC2z6dW/aesapIAdH5aPDOEJ5LDauqyac6AfBDTVixEreFfFNo0wptimYQ34AVyLWAmjTa4d7yUajZMm2N2oHfqCfYAB/YE2SASg3MyUZP2CNmz+GGjr38m0lFq6+2iUMoJu/lms4Fmhk2qx6wk1oqswB+9yJZpNqbiP9mRozDatgVum/unF1HN+8MaPpfCHVX8/4O7zlk0mC2rSQY5L21UCPPzdqj2yNMR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 05:13:11PM +0100, SJ Park wrote:
> So I'd still prefer to just making no effect this round.  And my commit was
> failed at doing that, because it didn't aware of temporal tuner.  Maybe we
> could show whether the goal was achieved or not, using esz and let the tuner
> show same achieveness?  What about something like below?
> 

Thanks for explaining the two concerns. I am still new to the DAMON
code, so I may be missing something, but your suggestion looks good
to me and it is simpler than what I had. I have prepared a v2 this
way and will wait for your comments before I send it.

One note on the first concern: as far as I can see last_psi_total is
updated in every tuning round, so commits in between would not make
the measured time longer than the reset interval. But I am fine with
your approach either way.

I would also move the last_psi_total update into the new helper, so
that the helper is the only place that touches the field and the
unit test can check it.

While testing this with damo I found a second problem. A full
"damo tune" still gave a zero quota for one window, on the unpatched
kernel too. damon_new_scheme() runs damos_quota_init() on the quota
of the caller, and since b90408ef1163 damon_commit_ctx() passes the
quota of each running scheme to it for the test context. So every
full commit zeroes esz, esz_bp and the charge state of the running
schemes. Please correct me if I read this wrong. I can send a
separate patch for that.

In a quick QEMU test with your suggestion and that change, the quota
stays at 1 MiB over "damo tune" and "damo tune --quota_goals_only".

Thanks,
Karl

