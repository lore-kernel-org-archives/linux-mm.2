Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B5DDCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 08:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4EFA6B0178; Tue, 26 Aug 2025 04:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF936B017A; Tue, 26 Aug 2025 04:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7226B017B; Tue, 26 Aug 2025 04:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 71FB86B0178
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:23:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB0915A869
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:23:17 +0000 (UTC)
X-FDA: 83818218834.28.0D0D77D
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id D580B140004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:23:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756196595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eoEgUhgTXs7cJfDCjUXiIDAL+Ic7fYFRZOTC/mkCXTI=;
	b=AMXWclh5OzMyRSJhyF0isMVc2GttqwfWAuwN04Pf7mxyTm1Vtl1eZUn8ZU26y823kNJoGL
	6FvU0rTZ5lRerVRoAn9TeP/6YhdDu4tK+d9ItpcTx0g7OWA6epKqzKnSskX0YEiBTlXOFG
	DEP7nS2AJHNLzGebddl0JZUbyBLScOg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756196595; a=rsa-sha256;
	cv=none;
	b=xhF4Ga7bZnmM/UtUK/pj6NCEZOHIbxx4BTOvuTiTDDUaKK+o/ld3hHZnDapnYU4c4fE3lq
	dhWubfeCNRWHmQoeLuhuUJJUyzMRI1yMFrl2RjSJZwNvywiBhgTpg5G4qhZ+b/7ALkrPQ4
	H38T4d5snGo4mzT5uS+YWBo9Kd3Wi8s=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61a8c134533so10961853a12.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 01:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756196594; x=1756801394;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eoEgUhgTXs7cJfDCjUXiIDAL+Ic7fYFRZOTC/mkCXTI=;
        b=I225bFx1Cqe8/oj5S8qlvNzM1Cz2fyrJSAz8EX0bnJOFbXNHE+XB4eReW6Rgi2XcFF
         bhV2ObHqD8ObVqehsjHvMP3Xz77mEc1oOaR1509Mo+4ORpv1sHuPvHduz8O1lmDY0FLq
         mtzO/fqaS2GswCO0cKFo13eCQOwLcFUP8Y8Nvs5bg21csfHOuGwm+mBh8uouiWYH3Yym
         uPF8RqNyMVVtQvuMoVS5fP6sXL/yPsWroQEY3f5aqW0+zREx2h5pGo2YBh0EaHArGuKH
         B9tuLmTdAQoQYxLgGX0LFSngvsWnqKUzoS12ucH3Cv7Wxz4rA0P5Di/S48jUmKfJRT+3
         7vKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWIfVYCn7JeDWhPQDdhZ85VvWYoM/jY/YHHBx2q1mzvLhCPh+hr07BWCktMBykT9lA5ZPqcpWCxg==@kvack.org
X-Gm-Message-State: AOJu0Yy2VmhX1NpP+c4wMvk+7I0mQVChoaNCSKjkSfsLqwy3O9fjeAdV
	SMkJi6lRBaal5UoAhFm3BTdF0z6Vgw6jIedj8qzwaIM2o/hoC13jP+IE
X-Gm-Gg: ASbGncvdtnoABdQPTiq6aOlwCFqBB+pbcQfJ6oYGvnkVzJZkTwWyrKyfp9I5yXNZBsr
	re6OF1/eSHembRPzeh2HurMmORRaobnGVQ076kwQZ7jlZ/JObqlYyVIRHilFantYlC69Lhr1caU
	rwq8BebSymiYSgFHnYJWmCaqa08Ua90oDOIn0CLH+/hfcW/+qJURog4gYS0b9UYIo8I/6EPDtGo
	xJhbK4DYypdAEokPe6jiSMCYsDwR2++qmZj/BNwWbNFozYT/ldFcnGqO2ZFNcAidOxk16zHUFoa
	S1BBZBhvn9bHdisL9JRCxjZGWvZCmpUMxx2Sb339U0/bY5ZDXai+vaWjgx9yg1A5S18IFZZnNXU
	g692PLiFDu7FP
X-Google-Smtp-Source: AGHT+IGX5sDuhW+5W6VbsXdfJT3rGtM8X/CzpCSqDXv2mDL8i0YM9mxTFCKQLQee6hpN7FF6DkcmCA==
X-Received: by 2002:a05:6402:4390:b0:618:2fde:8fba with SMTP id 4fb4d7f45d1cf-61c1b45c326mr12436871a12.4.1756196594167;
        Tue, 26 Aug 2025 01:23:14 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:1::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61c533e96dfsm4883755a12.18.2025.08.26.01.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 01:23:13 -0700 (PDT)
Date: Tue, 26 Aug 2025 01:23:11 -0700
From: Breno Leitao <leitao@debian.org>
To: Gu Bowen <gubowen5@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Waiman Long <llong@redhat.com>, stable@vger.kernel.org, linux-mm@kvack.org, 
	John Ogness <john.ogness@linutronix.de>, Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v5] mm: Fix possible deadlock in kmemleak
Message-ID: <fv4epzbozkpbyuaqt37zt5th3diwmav73cfzdap5kx23j456im@7u5kw5eip3xd>
References: <20250822073541.1886469-1-gubowen5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822073541.1886469-1-gubowen5@huawei.com>
X-Stat-Signature: fchw6pby5oicj5rp3peu6zbwbqaw7hbt
X-Rspam-User: 
X-Rspamd-Queue-Id: D580B140004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756196595-764533
X-HE-Meta: U2FsdGVkX195pZjFX+tUxMrou3bUntNfRiWA3NBTulqZv6tjKgjkqD5G9X5Ds4sRS5NFYA+bOrzJyXSvMDgKzqxcakgBvSRSucWKvMo2GaGbiqxX8mwmILECp/B5UahNdcApJP5KxYzTfXeJLqZDGpIe5JPzJeZjF+hY1HCMl/+R4VvJ2u5OKSGScJREICzWAannKk9lH8/mZOLXhw8WdyGaL1WQxg3mViBhvVkRYy8kT8dLKTfa3KQZP7HtYsnAZV+gIIJEhr/G/QynZTCq0OSNLiHRXEwvaqS0PUcbrziJG6A2vUO20sOt9AnR/2J/VB0uwmYnXI+yk94cbMmEADVQlmYgDeukgT75qDej3dSRUYHv84Rt6DncxloXGhHn1JA8oC73jvORTFHlu5Vcrq3KbCtJwU47kQSYKHe6hHMVLWnCxIiMYtUGNgX3g7/50U5yg3wcZ4G8dAuJbYheCHYOyRAUf01LrDQYso0QR3CePO/ZRlSWfg6PnwP4BMB63jSNKRW34LVP3noOsi7G9Tgd7kI+uw1k0i+r45S2BRJL4hFCRobGI2tGP8w6/CSdWkKR1/ldytV1DuepMEhrK/Us8cCXJCFJP9K5Q12+roqJckGgmg53AxwFIw8nX2z4+AdnXpEp3fBLBlat7qwFA6s9uWZ2FBD9jkfBYBboSNEIuxipyaW/iNtiJl0LoYL6IOtrCKwRhPc8/T+CJaAhAh/n9LxxX0t8UbdOkZ1ifP/Mr/V3NVO3qSDPvyGSSdz7XDkIBvOzVOsmt08zAse0T26SLD5mBYjdLka88tLRuPKFyJrP2E1EakAIgRWkhjlbNeazxNDeBulJm/uF6y8qORTsaHr7sMTxtaEjNpi6SElBmywbQUUVEhlPZfNt4RLSnrxQpUEI7cMLTCGwGK2+X3+STn9G0IjhXoV7UZ7vMNMy4mhWyxMPLP8madipc+JsxTKbYkwgz68RKO9mq9S
 lEOYHwv+
 1/uOAi3y2pIanjhix7ZdardrBZpX2lA5cZF3fMk4gdGoiXjvBREFNC9ezXCMfJ1LtFYZygGrll/hcJvb5kD+eImK5x+nrjSVLi3oCh/biBjl0QSyPLzgRiXwYoVACU40p9+TD3R+7+SWYd+lLULtq1HxLcizWhvAG+TNuQp1jcITBvX+TknDar6FOD04Lavpz4nJ0ETqhNDPbkP01GDJUtAQSLSyFiTK0fGXE+4HYmvS5l16SVfoRxEpNM40pzo196krpxvb0ZEwotYNLE8sFEgH5s5cyLEkzuTsqSFETTQOifaGr3l+OKMhXsI+8AK0aTh7nTtd2tCBLzatyp+PH6yty4wwXmWynguiLikDE7GsWHMMpFwor+n/LSX32T3cU7iyGi8VhW/MFjuvuyCzhFc3oFeTrMuCGJk1nRe7QKOOHs5pPqyVb1gKd19wibmoAiKmRrnQe7HX0kuU9ZuUH4oygGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 03:35:41PM +0800, Gu Bowen wrote:
> There are some AA deadlock issues in kmemleak, similar to the situation
> reported by Breno [1]. The deadlock path is as follows:
> 
> mem_pool_alloc()
>   -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
>       -> pr_warn()
>           -> netconsole subsystem
> 	     -> netpoll
> 	         -> __alloc_skb
> 		   -> __create_object
> 		     -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
> 
> To solve this problem, switch to printk_safe mode before printing warning
> message, this will redirect all printk()-s to a special per-CPU buffer,
> which will be flushed later from a safe context (irq work), and this
> deadlock problem can be avoided. The proper API to use should be
> printk_deferred_enter()/printk_deferred_exit() [2]. Another way is to
> place the warn print after kmemleak is released.
> 
> [1]
> https://lore.kernel.org/all/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org/#t
> [2]
> https://lore.kernel.org/all/5ca375cd-4a20-4807-b897-68b289626550@redhat.com/
> ====================
> 
> Signed-off-by: Gu Bowen <gubowen5@huawei.com>

Reviewed-by: Breno Leitao <leitao@debian.org>

