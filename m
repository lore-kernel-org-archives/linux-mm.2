Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD22FD064F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 07:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6836C6B0005; Wed, 11 Mar 2026 03:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 630AB6B0089; Wed, 11 Mar 2026 03:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512786B008A; Wed, 11 Mar 2026 03:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7646B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:54:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A14891406BD
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:54:26 +0000 (UTC)
X-FDA: 84533019732.01.ED819CA
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 70ED340004
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:54:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="McaSb/39";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=vbabka@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773215664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vi9Gsatd7iYRgsluFQhTgFHAqgoIXBEwFvUzAxjRWBk=;
	b=eAr7pIPkkORA1VtkYa7KXsCV405fONq6FV574Cam/N1ZO25J377YNGVDt96IA/NVJkranb
	HqpDEaEdEDI9FEpEi1k6dSeUTwrcfN8tOJw7QKgg3smqmq5HI6cz9r4DH3fsl7SFYR1dkQ
	BLWX01Qrgv9/UDc2R3pLr44xvQgvPsY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773215664; a=rsa-sha256;
	cv=none;
	b=Fsn7MOjAsIxaajWtl9Stuasx320eTf9L5GDTOAKAw2FY3Jk5+W1ArWrfoDe4uM7qTLfK7c
	OzjqB0e3bz89VEqVCIZQCXV2lmFpbig8kx3pfaRgK44pqM63g7sXKeyqxxvOX7Al+X364a
	AYxXzdQeOkeSqb9PZ9zNJv22vh392nw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="McaSb/39";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=vbabka@suse.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-439bad13a9bso860678f8f.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773215663; x=1773820463; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vi9Gsatd7iYRgsluFQhTgFHAqgoIXBEwFvUzAxjRWBk=;
        b=McaSb/394kvQ2Z3fG5JIqFnN2dipAPkePemuLL/h/1bbBoEMcnqpyT5veLwD+UwKTZ
         Az+bncEKutVs5LUERpYNvGGGm99Q5MhCmjUI5hWkbmuzO+kXW33spD/Y+gYCKJmoqkqv
         O4KkmpDctFmkra+zL2vsogB4MdcstYuRG1bY8kEkveyPs9FMa1TwnuWIsMvPDog500gz
         nbCceUD2hm6A3mgAuR7JAg0o/5euvtDuiIflskvYPv7qTbuyIh0umOY5SDp6zi/nb17v
         d5hnS+H0HIIHxhMyv9C7NwzJ+whc/oGGAtPSiAyDR4w4mSH3+kzyRcv7RGrHfMYyLola
         4ynQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773215663; x=1773820463;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vi9Gsatd7iYRgsluFQhTgFHAqgoIXBEwFvUzAxjRWBk=;
        b=Z1hcwRL+pe4viZO+UwsndUvzUEaQavwWOb/Z74cGP5acnPMEtc4+wp2nAolcy6j9xY
         i5bF7PhCRFrgyN0nsmXjeX4Bn5hJcaAJubwzMIbrhTzbS0oyNQ0AWf0c25Ly41fblMbG
         ifmdLqZfMICouUXZqZ4oi8bJiIVpK2fM5N9tWNCCfHktdkBXZUd/2NxyKYWGiJiAHvQw
         TaR/p2nMsuSf1PMIIOdJ47kU1GG1rdIrzrJVe6DPzCP4dRqMz9y0LEg7Gfs9GTUe2XN/
         D+doF+FQazjQEIaCTYUPrSjLxztkojAoh/WHBtosVq/KrphiOMkskPrLWskxm1cVQyel
         9m2A==
X-Forwarded-Encrypted: i=1; AJvYcCVfmlYTyF9r5K1d9BbUv12rp9fvTVwYS6H2s5645O5t36r1uPQTk5edLx5sLUfiv2cY3QHtfZssJw==@kvack.org
X-Gm-Message-State: AOJu0YzRoS6UsJ8LNsYHvpgid+q3lp1g6vy3F885Ay4SjBCUY6Tn6AHS
	xcxofbKc1bBtaknuraWiChixzo09WpQtQ+tuiDiShrLhu8EUi+7PpXsn9yP4j9Uk5oE=
X-Gm-Gg: ATEYQzyWTxo0pLRzM9/uZGa4tqnI5NzCH5VzaI4ZTQqIpGsopHNTfCmXRA4iMw9q2Os
	wuN7o7IgxeulwcrlxpUtx6w1s+/HPW8AKvnrrJsuz3MF3r8J4OMjQp7e7vMHcnW9OoE5rWNVNWa
	wiDyX1Nf0x/TNGsCrd5PHGnniyY9IrBTb1qfwhtFLFz9aA+g3GV7s4asldoksLHX/EkxjvY1IVU
	VPc2qm5FJProXVsXN0gevtwDdqW1klLOnyWqJc1w08HHI+lxzJUNAp0XvVMgeQUxT2vA3IgaNCv
	OU3u1p5SMeS10m9MzWEXp0ZdW2Dy2eiZ9WHco3ntFsAorMoJ3A4jE4DVoMk7bKDbKgIAfoigzYU
	WSz34uVpzN7PS3W/WAjCwoYcq3eT8RLZDbW39G9jhBTUaLcS9DU3Uye/wPyuCuv7VORzvhAhYUR
	XjtNAbs6ijZ0krbUTfV4DEaI8DUcCW1G9n309+di32jAmtANzU7Ylr+p4XOg==
X-Received: by 2002:a05:600c:154d:b0:485:2fe9:33a7 with SMTP id 5b1f17b1804b1-4854b109745mr12712875e9.3.1773215662712;
        Wed, 11 Mar 2026 00:54:22 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b66e3f8sm30497515e9.14.2026.03.11.00.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 00:54:22 -0700 (PDT)
Message-ID: <4242ff70-c5d4-40f4-bddb-c823675fcb4c@suse.com>
Date: Wed, 11 Mar 2026 08:54:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] Introduce QPW for per-cpu operations (v2)
Content-Language: en-US
To: Marcelo Tosatti <mtosatti@redhat.com>,
 Frederic Weisbecker <frederic@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Leonardo Bras <leobras.c@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>,
 Mel Gorman <mgorman@techsingularity.net>
References: <20260302154945.143996316@redhat.com>
 <aam1cHq3_fb-T1HH@localhost.localdomain> <abBQ40Zkk76Zej8i@tpad>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <abBQ40Zkk76Zej8i@tpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 70ED340004
X-Stat-Signature: q8n5gebobpoa9a8qey9h6ys4xbipz6pw
X-Rspam-User: 
X-HE-Tag: 1773215664-232197
X-HE-Meta: U2FsdGVkX18tX6OPFF4H5vQ2FZFjbJPMae5NRtBP+pvf6EHnIM2tgvHX11L7WdWVwNs1BxgupD/ii0lh+3Wi9l5Rui66NbB/m7j/Xr67RLBS1FTuWFeqszpX8QmUTkfLJne3AgBlczFcWw9bPsG4NztE+6sRd1r8BQfSHowvtg4lphWEzx33utZQu3x4QtsCMmM1uTwBh0XAjmyj1RnhE/GHhwWM14vrzvglAKiSEDs7RghBiGVhpTEvOwQVgqIaP6cdl7l8koTCeT8WX8DUfpDyaZFLprtihzZbYhOnVFjRxTKVIR2iRj8HdXD8zXNUuYiNTj8J6uUWN+U+b9FUlvvH/4QaArCD+z6RbSUsHod1Px9xJb6yVQR6EFiLG++HFYvizO3l/A9b1Os1kPjSV1TBNQWGW6whpJNZchg6MrHgpAfZrH+2o5UCzD+/h0PQ8HvuijvAtOdBTcSfmlj0VFWiAv1KfjmEfovI9MOd/qFtay2YykCWEv22aKI5dL8nnHSn3DbcDT638NqzSZ0u7WyrYqcME7bnGPpBF/s3vVMiwRquGcU3fdMyF61jRWWCKiLtboEMf9eExSGlAVpmE/z1Tl0WL2p616FSppoP6XY4bzlB17ze++cDpra5ht1ZqB2zYuSMiNQ0M4j35+ANFic/jfHy+VQqI4eQPqO7zb18NYr7E6YHsgMFLBHBR0/msG4LX1Fgtkopf2cpil2uwDsUCAZ/GNBqp4a0K4t0pb0yRDbYwOduZuLjW/AGMVdVwyobaYURujyzmlz6sVzK8v5sbRxDvHud5adjNXJFBbaAZMkSbo1f6XFFr8wqIgTQ45RCcj3xE8497Me6XqqlzQhXwwP2uvufm3bETPj7rj7Qzsfl92uwkAEZQWgueFGlNQ+uWstBKT78qew8bLjDy5eiMZ5e1RorxuSVGIVJFBqIfjnppUtlSrsGbw+RR9t/wwSSNUaLBfUjZ7VPCTN
 7bW7HpK1
 0pw8+mucKMicpi8vcg0CS0rpUqyr3ckLiEWVViCzfUTM7YGWQtdrXW5yx7N8dhb6LoBWNX/58k7dFG3DGVGQzJ9dcgsbVR4Db3It4AcHkORtYz0xSWfZp7EkbUCSTTPiz5z7OapNV7Df/0ryeu1vCp9QngEkDNc7Pc6UKO0AI2xqMQCAJCF8oUI2qImdu4tmQ0hTKRNHG+Nf/mtsB2AxXyCFTBD6AX7KQcX/qTbYoal537kjDlZ3RiBDMXoEFcIKrDj+OEHT5OTqqBaDroWzeILBtufEbbRsJTo+eyiw75qerfsOsXzDVvPlidygtGW2X4Fw6/D+WT9VQ7SGjoPEZpRXZlUyphylotLY5D2yalJkgXFYyoDZCJ5EqnZCBnv9867kzIQWpLphO8zKV4agIXSwDzwL57gQTVm6kywHO6KHY21c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/10/26 18:12, Marcelo Tosatti wrote:
> Hi Frederic,
> 
> On Thu, Mar 05, 2026 at 05:55:12PM +0100, Frederic Weisbecker wrote:
> 
> Can you please be more verbose, mindful of lesser cognitive powers ? :-) 
> 
> Note: i also dislike the added layers (and multiple cases) QPW adds.
> 
> But there is precedence with local locks...
> 
> Code would be less complex in case spinlocks were added:
> 
> 01b44456a7aa7c3b24fa9db7d1714b208b8ef3d8 mm/page_alloc: replace local_lock with normal spinlock
> 4b23a68f953628eb4e4b7fe1294ebf93d4b8ceee mm/page_alloc: protect PCP lists with a spinlock

Note that per bf75f200569dd05ac2112797f44548beb6b4be26 changelog this seems
it was all done for the same reasons as QPW. It's nice we got the
trylock-without-irqsave approach as a followup, but the cost of (especially
non-inlined) spin_trylock is not great, given that now we could do the
trylock-without-irqsave cheaply with local_trylock.

So that to me suggests it could be worth to try convert pcplists to QPW if
it's agreed upon as the best way forward and is merged.

> But people seem to reject that in the basis of performance
> degradation.
> 


