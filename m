Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1303EF531CD
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595406B0089; Mon, 13 Apr 2026 16:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56CED6B00B1; Mon, 13 Apr 2026 16:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4825D6B00B2; Mon, 13 Apr 2026 16:37:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31D196B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:37:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4C5957D3A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:37:25 +0000 (UTC)
X-FDA: 84654692850.11.7D59F1B
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id B3FB11C0006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:37:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ba43TYua;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776112643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27N5lR3KmoShUN2IsYTq303g4RifjWELwDNgjz4lxoY=;
	b=0q+1ADuB8+EmgJwxEqujqfKUUC16ms+a8vlJ6OHaOaZpFE8j+UnLIbIetwNKqXfv3qwVfY
	i9mxXhw1r24gF5rERfunTYaRpb4lveIMHmB8jW4TI5vG4n92ZpzVo3mdQ/cVlNGXrC0bMV
	kbQpHrx48VVm0VcfynPDiiY3ezXNSi8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776112643; a=rsa-sha256;
	cv=pass;
	b=4Oz94iPUmiQyoZKFUHeliR+zcJ2y19cLrElkV1FvCx3yR6L9EF6f2uz0X7q+n0yWRSSGTw
	WO6pbjBeHhodm2ltDpbksdUnsYzRxwFiMtLka1cJ6/T1oZ5ICmhLj3Hdjkq26mfb3bbhE0
	IB9WXzPX9j3D8N8wq0jxyXYzFnRebC4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ba43TYua;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2d7bdb5ffffso5113300eec.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:37:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776112642; cv=none;
        d=google.com; s=arc-20240605;
        b=fmngljk33+DTOQUdTurUaM4kGViuH/DZQ7FgFMvmroaxknZZCaaIaDrIayclSds1ab
         p4gyyBDbIvaih9QZrBoaO7jmEZS67445ufwCoqf2QU25bU8jLKli2hkSBYFE537ZFDSj
         1x+svrMn6esbCVAUXihpV41U4LXXNDBCkPW5VVhZJkBkBe2KA1F8DvvX/zFVfCN8Y9Tx
         1yM93cXOD1907NzoetwUgTRJHvuATMWTFfnGMKE3w/BiVwedFd8drCAg3lZczsnrXZE5
         NixR3bjrSCoq2Rb4hkjMoqAL8/abvhPvZ7LWEcjj46sD7Iq+ONW+ZRTT3WPNItnpw2l4
         SmDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=27N5lR3KmoShUN2IsYTq303g4RifjWELwDNgjz4lxoY=;
        fh=To2bgvWqZ8cmCtvrzOWxMhu9QAMSU8n5XKQHLi3/iVM=;
        b=QE6wI6dcrpu9bQhvoo/79twnLp2OYVCBJefZU42dLELWI1375JvqLzKuun2oR4YF+y
         x5+gAGuUat0VeC+QpwPQrBWmfHYQNgvIuf8MUVrCA4TPCv5N2pUNFN+aPD9qLuTfrv11
         JGxPFTsWh2ytnICsnYZ4QtDyXKw/7hmUeM0PmFrgRYsPSzRL2rRk2XF7qsv41KyqwxOt
         BQfPTflrCQPIhm2x5kitanxOlgSiS1sEYcjH8dfokQkhLhSrO445r5k1WjzKL6OUG6mN
         JWDhmXOOaSvd7f02QPlBmo+/SdT57hchYmqIrWNbTvme+GCrUSfV3XwfLLr17U17+f6C
         JE2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776112642; x=1776717442; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=27N5lR3KmoShUN2IsYTq303g4RifjWELwDNgjz4lxoY=;
        b=ba43TYuaYzXdIT/cCqPq/44LkhD3TiMJFMJ80ZIi+AeZRKStSvTpqaQntqiXiFy0Iu
         ZU3/Ha3s5N0rPc3Nw4A8P6mm0jJTvx307mwtxjuVvxcH/X6fvHjbHR54V3uRmqYLYMS4
         bHBBzl4sSlQnRIAW/FhTDj967kFkB/nlTyhCfHyN94TrlLR3X2IBcImLJz/CuPLCI5vR
         +VTsaOUPIDCQjybz2+My6oYDWu9rSOiZ1GRnGYYRr7eQgW4osXXqv495yFeWHFcY77Ua
         b1hqvh9WXFl5TL1+zhB5T9pYd8C9rpIDihxiumlWk2ojKa5jCub9HmeteXIjSfKRI3dU
         U6Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776112642; x=1776717442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=27N5lR3KmoShUN2IsYTq303g4RifjWELwDNgjz4lxoY=;
        b=NIoVS/F3kiUhsDNhvhY3j/w+xLy6eL8SfASC3rF8RDvrXin2KzJbIVsuB8TEPfXYpL
         Hcvoj7gDNhWeUW2k2RcOdblMWHFS+AT9w/kffHbJTuTEXsOvJWiACCcr+HdE6Hp0oEAz
         gNjBUyrMxFTFYYNNXIrjzg/tvt+j1wzmlzJxI/MGDuLKNnaOXtshKqsIZR8d7mFrbf9R
         xYDzIWQgRtFTepJ9goUvNbIj/KmWI/yKETfuyOcDG2j7GnFgeSQYCA3/O90nLA/MBG0k
         TcgIOONr/lcli9PQu50atWUxXUQSHuHi+ADDwvgvqKHI+YxWaJy9amZBln+tjDs0ws+j
         DEHA==
X-Forwarded-Encrypted: i=1; AFNElJ+W2+pUMIiaUTKbb2eOvWPdN0xqPp2R1Eou2aUym2rtHE0NqEwJqAneJ17ZSRa8pO/fmineP0zfdg==@kvack.org
X-Gm-Message-State: AOJu0YxPEu8tcAQJSLEIQ8rrK/LpRvJlRo15dwkezOC3/r5+EPjSZGCK
	Hkqtnu1qWEWAk0XucxpmgbtZ+wW5UTE5S1NLb3GCkobhmi1l6Cja+jF24M3mhlALAXPATthBJLX
	WWr8ZO99IxyaZ5By4RTX42LxhMIH8vJk=
X-Gm-Gg: AeBDiesiH3BFZ5Y0wLWV+As60pSwFnf87GEwIjUzAjVOtUmF7oAVqTWVlEGICB+Fqcf
	+3Lh1BEbfKT3msJ4padw7e9IqyVwgOpC12rFDLIfq8WDO66+cVidcg7oM+FEMQGzBvdE9kiI5q8
	Zc7XJHuI8pBKos1cv3y7kd0Jt5lnEJMEcTdKl5HhAVDo+2y6lsRzWbOYhkrDrlBrYntKQxsqTvk
	ZHO+3QPH7xVWdQrRceDfunOmOyIjN3I6J51IN6vGYk19C7ijIXp7xix3vtpAjHDGGIk5Af9Gg91
	Ab5ybmc3k85yJrL6
X-Received: by 2002:a05:7301:1e83:b0:2c6:1557:9997 with SMTP id
 5a478bee46e88-2d58965fa5cmr8485135eec.14.1776112642351; Mon, 13 Apr 2026
 13:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260331183351.29844-1-kanchanapsridhar2026@gmail.com>
 <20260331183351.29844-3-kanchanapsridhar2026@gmail.com> <CAKEwX=PMbbuMeo9Ppk=cW_hAthZ-cf0rMjALsETpDZzDj6oYJQ@mail.gmail.com>
In-Reply-To: <CAKEwX=PMbbuMeo9Ppk=cW_hAthZ-cf0rMjALsETpDZzDj6oYJQ@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Mon, 13 Apr 2026 10:37:10 -1000
X-Gm-Features: AQROBzDz4taWpQoAeTGAg5PNNxwzGdOcRaQguloBFmBrSegVi7p8AwF4X2KkvxY
Message-ID: <CACpmpoesdy3QyTD9rOPz9cucGuPzgSzhJwQnTF-3wpjQJUgg4w@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
To: Nhat Pham <nphamcs@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B3FB11C0006
X-Stat-Signature: rgh67t1wf4q7c9tj9pgynj4bpkkknn9c
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776112643-79
X-HE-Meta: U2FsdGVkX1+nsEeInXC40LP/dMjAI5wfLdofmRcR1ft0ODJ5xny5gRQSDAxqFafo8VIfPnz6D6F0lLgoaTrfGLwA8WhOMG6ZTqKvCPaA58bJDGY5qdahf4WHsXlwuWKL6iw6ur04INV8XuLiQ0XOdIbrHB+DtcNb9GmSAc41A/dkNi1c13NfCXIt/zrna2+sTzJjBM3Dsn0EvjufxvzKbH9Bb+SJLHJedHPQKQ/o+dT7m8xzkV6iGFoHunVZb6ruArVYUr0bsMtqnFOBwGYyFipo8yvuY9QGRW/T+JMa+ol0+nKTLyq9tTBJiHhV4gk/zTslOao0xpiLS7lsvmnjwJY5Rxhdcqy1nNwMp2TPk9xeg2Bfx4i7hcaOBB8DK0t7ySHPa51rKQZKduwrCxuvVxYwnAk5Qt/Ei174BsaJYPyTtD1NsokUM44ipSqKQDxTFT6zvGUXzRcNrgZu3v8KI9AeO+uC02M4qzlfWC14RZTm6y0NUTeJQebE0ObIWRgWWc+ZURekEYr55AoDNuu+jsOHVs4bcipEItn6VMojwGRwYh230EUpSHvgLA1guqQytQAVrq3JP1XqIIEnAdzaSfbtuUyaDkBHZREWwimBVlWsbBfOrJkMuQlw/UR/LItVSgi1oXgSW77MpYZ1kjY94Lg/jm6p/xzGyyyhLjD9wGtBLh34T86q4HjcR43OL6grVPfa68fnunXAE0qm0zVYr/rHgbYjaf8a2/9LdEwZ7jN/ltwz/oJiX6MdCzZb3WjsHhAohWzRVcMpUFHrLY59h7EeAGSXNFCUHbn3Os6he6i+cmOOdCCddx4cixdnQavSBaHFNgOZS2A5Yknar4jhsPLIMuxevqi8f7Z/OGIpN4zsVWCB5aIQQyUwqlhbgXJruUAmpvHGyC+vgw3uymLJJFckTmq80/batN/BXTw7qoZ83m8M+g46gKVuE3i2jMaZQjIWwZ6VsZTUBIvuRpI
 f80IplLH
 Y2AMQoZZu5M7OyzF1uEyrl9eCsyutIBBMzH4YaI2zuQR2PFuP7K9JyGYZadK13LGuL1iZH06cZlXGfCdPAlYBxPYUAuugBF1L8+Kt+x5eOeDbwrFOjuLcaqVDX5ZatNIpPzlnkyKRWkm/0BBGr+8wAfuunTtmFwBimeoIBBTWGvDb/ZSIdJ9oCdhoxwJn98owlA5KmaUtaycZxm5MF6RGXdKdSCvS+gsZ7iE2qyyl+FfpZFyfUO928aKHnY3QQ6XHn5BPzQ3DPljqH6GWZLKWq/Dsge6T0CWJjFcFuIDiF33YhtYJQt0Wn0m4MoPUXY05bQXTPsr7a+zWGjN29jf139/SwfwyqwybzsKOfYFvv5vmF81PhjpwaAiKdsZF36s29qbfRysq+7RPj/nxjZWtp+UKZtVYbEDjeLzggK4lnZC96PLrhUcr3hv/gtQGPrGskzAwyskvz/cjzlWNvHmcnEtfsxSCafYY9UnPvtOUyIkzOBCcHlEOYWJQ3fYkiS2it1rDFqljfTz7hJpQhopI9Vjtb42f3xlDtVyqQrGzudjZ/awxs3sQXpCnREOnFeCUd4TIZ63Vohx2HQ7nuQ5LmQMTLKBBNCH/cpyy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 12, 2026 at 2:42=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Mar 31, 2026 at 11:34=E2=80=AFAM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > Currently, per-CPU acomp_ctx are allocated on pool creation and/or CPU
> > hotplug, and destroyed on pool destruction or CPU hotunplug. This
> > complicates the lifetime management to save memory while a CPU is
> > offlined, which is not very common.
> >
> > Simplify lifetime management by allocating per-CPU acomp_ctx once on
> > pool creation (or CPU hotplug for CPUs onlined later), and keeping them
> > allocated until the pool is destroyed.
> >
> > Refactor cleanup code from zswap_cpu_comp_dead() into
> > acomp_ctx_free() to be used elsewhere.
> >
> > The main benefit of using the CPU hotplug multi state instance startup
> > callback to allocate the acomp_ctx resources is that it prevents the
> > cores from being offlined until the multi state instance addition call
> > returns.
> >
> >   From Documentation/core-api/cpu_hotplug.rst:
> >
> >     "The node list add/remove operations and the callback invocations a=
re
> >      serialized against CPU hotplug operations."
> >
> > Furthermore, zswap_[de]compress() cannot contend with
> > zswap_cpu_comp_prepare() because:
> >
> >   - During pool creation/deletion, the pool is not in the zswap_pools
> >     list.
> >
> >   - During CPU hot[un]plug, the CPU is not yet online, as Yosry pointed
> >     out. zswap_cpu_comp_prepare() will be run on a control CPU,
> >     since CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section of "enum
> >     cpuhp_state".
> >
> >   In both these cases, any recursions into zswap reclaim from
> >   zswap_cpu_comp_prepare() will be handled by the old pool.
> >
> > The above two observations enable the following simplifications:
> >
> >  1) zswap_cpu_comp_prepare():
> >
> >     a) acomp_ctx mutex locking:
> >
> >        If the process gets migrated while zswap_cpu_comp_prepare() is
> >        running, it will complete on the new CPU. In case of failures, w=
e
> >        pass the acomp_ctx pointer obtained at the start of
> >        zswap_cpu_comp_prepare() to acomp_ctx_free(), which again, can
> >        only undergo migration. There appear to be no contention
> >        scenarios that might cause inconsistent values of acomp_ctx's
> >        members. Hence, it seems there is no need for
> >        mutex_lock(&acomp_ctx->mutex) in zswap_cpu_comp_prepare().
> >
> >     b) acomp_ctx mutex initialization:
> >
> >        Since the pool is not yet on zswap_pools list, we don't need to
> >        initialize the per-CPU acomp_ctx mutex in
> >        zswap_pool_create(). This has been restored to occur in
> >        zswap_cpu_comp_prepare().
> >
> >     c) Subsequent CPU offline-online transitions:
> >
> >        zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
> >        valid. If so, it returns success. This should handle any CPU
> >        hotplug online-offline transitions after pool creation is done.
> >
> >  2) CPU offline vis-a-vis zswap ops:
> >
> >     Let's suppose the process is migrated to another CPU before the
> >     current CPU is dysfunctional. If zswap_[de]compress() holds the
> >     acomp_ctx->mutex lock of the offlined CPU, that mutex will be
> >     released once it completes on the new CPU. Since there is no
> >     teardown callback, there is no possibility of UAF.
> >
> >  3) Pool creation/deletion and process migration to another CPU:
> >
> >     During pool creation/deletion, the pool is not in the zswap_pools
> >     list. Hence it cannot contend with zswap ops on that CPU. However,
> >     the process can get migrated.
> >
> >     a) Pool creation --> zswap_cpu_comp_prepare()
> >                                 --> process migrated:
> >                                     * Old CPU offline: no-op.
> >                                     * zswap_cpu_comp_prepare() continue=
s
> >                                       to run on the new CPU to finish
> >                                       allocating acomp_ctx resources fo=
r
> >                                       the offlined CPU.
> >
> >     b) Pool deletion --> acomp_ctx_free()
> >                                 --> process migrated:
> >                                     * Old CPU offline: no-op.
> >                                     * acomp_ctx_free() continues
> >                                       to run on the new CPU to finish
> >                                       de-allocating acomp_ctx resources
> >                                       for the offlined CPU.
> >
> >  4) Pool deletion vis-a-vis CPU onlining:
> >
> >     The call to cpuhp_state_remove_instance() cannot race with
> >     zswap_cpu_comp_prepare() because of hotplug synchronization.
> >
> > The current acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock() are
> > deleted. Instead, zswap_[de]compress() directly call
> > mutex_[un]lock(&acomp_ctx->mutex).
> >
> > The per-CPU memory cost of not deleting the acomp_ctx resources upon CP=
U
> > offlining, and only deleting them when the pool is destroyed, is 8.28 K=
B
> > on x86_64. This cost is only paid when a CPU is offlined, until it is
> > onlined again.
> >
> > Co-developed-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
>
> Lol.
>
> > Acked-by: Yosry Ahmed <yosry@kernel.org>
>
> Thanks for simplifying this :) My brain always hurts when I have to
> handle CPU offlining for per-cpu structures. I had to deal with this
> because I added per-CPU caching for a structure (with reference
> counting) in another patch series of mine :)
>
> Acked-by: Nhat Pham <nphamcs@gmail.com>

Good to know, Nhat! And thanks for the Acked-by :)

Best regards,
Kanchana

