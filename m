Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB3A106F2EA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56AD6B0089; Thu, 26 Mar 2026 04:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E8F6B008C; Thu, 26 Mar 2026 04:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943D46B0092; Thu, 26 Mar 2026 04:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 830606B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:18:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EC44013C0A0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:18:15 +0000 (UTC)
X-FDA: 84587511750.29.9B48A73
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id DF44BA0008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:18:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=an23oVxc;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774513094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vuszBhP5EPCTmqOQyNyEH1Awc6FBRdrN/KwuvW52PDo=;
	b=IVdRUhHSGT22Kkw9Eu+SnYypjNMMOFc9zud0cLGal/goDBEQXDUNQQbBUoQ8AjQajrpBP1
	Cy6mWIjuE7TOpqRZ3833mJKMWfrgu8ZHE1OFq958TBVjUXUugsMuRDFeH8Z6TtazAP2d5g
	HpLHxA8Yrak1EeJcG/A2MXCh9szd0XI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=an23oVxc;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774513094; a=rsa-sha256;
	cv=none;
	b=m0A3LaSdme/xU/08ZAMJIWGnV7uzfmbPPfpZGO4WfLCB9olgs46/x50xozOkYiYE+8bz+R
	NbO2gw/fwkBZedKAtgY+Hmd5qI7NWn+oj4ZnQPdyTh3t6bGPlRECSTXihyFAp1HEUhgThe
	z+E9I/MQO5kqg2nS/dRivHj2E0r9YeE=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-439cd6b09f8so371404f8f.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774513092; x=1775117892; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vuszBhP5EPCTmqOQyNyEH1Awc6FBRdrN/KwuvW52PDo=;
        b=an23oVxcI3mdubxNgKhX6mfess3LlozTUarpCAdmj+adszWsi96Tb5e9X7GFAi8bMG
         2KT9RL0eubU81HlQRuOei8vw1B4zMdXqlRr9YXgHBt/f6J43tP0+NlBjL/AjW4mc26ex
         3M2GcC44DsFbO1xBTwIIMvOLoxIfsefbdfDPoljqhax4+OlmmHgJdno4MTL7QwMBIAWC
         Boz87Ja3w8z7IYYbjOh0hZZGWoWbu6KWGGMflGKbVethtn20wzukqKleiedaKWptw3e8
         JVbKNcoXfb3nYSqVjGkAE3zX0jNyiCPbzfTyXNQpDTTGOWY28IBReFRfKWOAtv1tVT5b
         Q1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774513092; x=1775117892;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vuszBhP5EPCTmqOQyNyEH1Awc6FBRdrN/KwuvW52PDo=;
        b=qbMyovtMUZSVbWdriRGm2gieuiujvtzHqb0/20PevQ0FNY/7nWp2w1OvC14Ms7e15A
         BZ2ZWkJQqB4IkSzJmmEtQtnL/VGs/+beLY3qH2TWGBP53DKYGpF1bslZz55vv9jGZiLZ
         27NpSm6eLW5uNmgbg4klhl13FBryKK+4mXct+Unbyk5wiPhnGzOCmKKYFoWb/e+Hwwvq
         7r9I03XuGuiaTjc16cXn57bu98Wi0wJc4jP9dcew53EGiAaUpJEcgACZOkIaHmiUoyFz
         4vHWSQaUrHGPbe2t9CCx4wfx+7bF3KOiPwoTEoW2TkBvmppJ0ADKCpjLaWlM2HFsUz0w
         Q3Ng==
X-Forwarded-Encrypted: i=1; AJvYcCUL7PBNlXoW4gFvS1TzMUS25tyoBpDY2Camb6pWuiwC1GMcjcekgirLiIj7vU/5vY5lVxyKjwo0dg==@kvack.org
X-Gm-Message-State: AOJu0YwEiNermCM/80k7/75+INB8Ir+0DHxMIkOG/aod5lyc8f/CKgGb
	zUQQvMtEyHVt3ndax0FLd2o63RS4cQCrggpu+CvE3ZA0Jc0NnZMrJJ7O6pWzfjaIRb4=
X-Gm-Gg: ATEYQzwR938TGTm5SnMkNhejeodThpgonIJiJdu5h5rubDGlIsz82XYeZUPrJFDaoeq
	VRqZGEVxeEGjTbCqCB4hIcaK9gUUNMMbQqkL3MxLwdQj+XbVgWy4mpn/+R5sdArbPDanNG1c4Lq
	LiOvLkQHkJ4hOUqT57vQHrFJayAi8Q4/58P0Nh4GpwqERXd5JQ55tQfc+jEfTFBuHDDij0K0CkM
	MkMC34zRIhcTX887wddqREJO3jUWW2vVwzlfsUPOFgnO3kS0Q+O8HU0ylcZ1XJZrk75c9moSRZ7
	Vwq/YY9p4YkoJxlY7Gl4Ytsj8nxjDaZFdcRn2PFxurFhZ7BB25ZiYK/cBWpdQyitbH8EXYsbY8K
	em4gHLx6qzeaT58Dp+kUhfGNee8JpzjgdGQTOeJ3kUOwsdYqpmRXNPOFAmQa20BJXG9Qsoc2Q/q
	3nLMiVVr1AMock4OV3IBL7ouNr/O9/kMADZfBnxTWh2WoVQ4M=
X-Received: by 2002:a05:6000:2892:b0:43b:50d6:4f00 with SMTP id ffacd0b85a97d-43b88a0d20fmr9477723f8f.30.1774513092147;
        Thu, 26 Mar 2026 01:18:12 -0700 (PDT)
Received: from localhost (109-81-31-149.rct.o2.cz. [109.81.31.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b919cf1c4sm6189811f8f.23.2026.03.26.01.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 01:18:11 -0700 (PDT)
Date: Thu, 26 Mar 2026 09:18:10 +0100
From: Michal Hocko <mhocko@suse.com>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org,
	ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
	mkoutny@suse.com, akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 0/4] fix unexpected type conversions and potential
 overflows
Message-ID: <acTrwjrv9Eq8redq@tiehlicka>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <acTc3JugF71I9Eep@tiehlicka>
 <acTlkB9WOGzVJCEo@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acTlkB9WOGzVJCEo@hyeyoo>
X-Rspamd-Queue-Id: DF44BA0008
X-Stat-Signature: 5t3f9bk89ym9odtitsc7hw9myc3eiuzc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774513093-135695
X-HE-Meta: U2FsdGVkX1/t2WFDr3pa2/uQ7RdMLG1c+81ZPJjfMomKhgw4qKiEXuO6/tyrQ9tz76JcK7wrGlPqV8VU/e/9YeM2S5RGUkgbHHMbWxWjoZf0Mzbb6cmw0lpJfRdkN0X9MSlGTtE+S+OL09v1BaXowJY7qtFYbRHDg6UWVp4nhukfqVEnWbQdVOeiLUX52ZYcwc18nyD7fl9WRQ1Pk+xxGtw8k5u8+1s/lKGUV4QnFMJfniYHEwUBVe9tA43oy9XgLQt2F8z0kLSyENIteFy4BoCYAhDR0MuNDxmJ2JIc3+azr58jMD2cNewjQnuD7N095uyWD8pgSU1Jy6KSeflTXHPaGQrrFixPLgMODTqlhEKOqfdt4VEVGyzx2tShjmdbH2NBxGXQdyuzjjj3FV1Du1txDdyCD2nvBOCnYiMbKo3/UNryAZdZ4KiXpSPEDtB+0Od4pWk2Yk7FGHNY8ppZTc3zDrqC2UygZ8SJEkgX/oVjeTILyq8vG2GTNFGjMJgHHXew5uHNla0Ou3DLdWKT3KtuQHBhUNkEtiuzRvw+beuAzUddjPL4MXvpwmZ+81zsRkI3OmIGuUf0LfJ2MSXvEYZYCgkXviopOittYHrCmBxq/tMBgUSbACjwbYFHzKuRa1EwZHHS5oDwic33wHRT/S6v4YPkh//ZRQYkqKJmFIYzyEiMBFef3MAm91rqC8CkxGbDo4lDSR5WRU4vYDUDr1KjljIK5KgQUzCsQWCbHBjfeibF/mvgE6ReCd6SxmqviDCwi2aNlaqMzqf7hZAUzW9lejYpYmDJ+U/0tiOE4rEk+VRK0RfThCyhyxLtQUixqgjk4rT2q2OppyLWHCbr5xIcK0rppb4Astda2d+yXXABvzLGQmB92I1ZMbKjNDNobXCOod006rl3/0GhFQ6tBzRyWwOGh1lc02VHqcCU9g4VO0NPAv6+PooWhVaUneoF33Vj7ZivsIP//mxUoqV
 hbKH7r2/
 qiFJFqyLvFLZZhLDcTRFQOIxkNrHKiMsAnxUbVpCIInP/OCcjCzEORnRoE7mKUbXG8GcwRD8SfiVFzG6qQ5SIcLAcv9XyXHyXn+YqPY563v4owbA9Y0qckysApQ5QL76hFFpjK9HR91r7EzIP0H8pchcAoB6kOz/8tL0O4Kq0huRjr8vFg7c3A2Ok0X7v2uRrbLFjFEhh+Qgo4CplzhbhRoW6Z/4VLjjxVYKkPZwhxqk6AJIXYEijxmxYR2k78g+opruVJKmtYCOsZMOAkFwiVUO3z+FxTl0Ur+8aZoxP8VhxLj1vZOf+l37i96hMcEG+Gfz8sQKjoaHA7kTqfaJ0K7VroINW6d7Fiijk0ppW/0xyay5o0YhhquB5vHvC6VmjjLzaZDNp80JsjnVJZDYZToCWjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 26-03-26 16:51:44, Harry Yoo (Oracle) wrote:
> On Thu, Mar 26, 2026 at 08:14:36AM +0100, Michal Hocko wrote:
> > On Wed 25-03-26 22:13:21, Qi Zheng wrote:
> > > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > > 
> > > Hi all,
> > > 
> > > As Harry Yoo pointed out [1], in scenarios where massive state updates occur
> > > (e.g., during the reparenting of LRU folios), the values passed to memcg stat
> > > update functions can accumulate and exceed the upper limit of a 32-bit integer.
> > 
> > Is this a real problem without reparenting? In other words is this a
> > follow up for that work or something that we need on its own?
> 
> This is not a problem (as discussed in [1]) without reparenting.
> [1] https://lore.kernel.org/linux-mm/138d9363-ab0c-4f5c-bedc-b326f5aaee91@linux.dev

Please make it explicit in the changelogs and/or make them part of the
series.

Thanks!
-- 
Michal Hocko
SUSE Labs

