Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED76103A9A0
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 03:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEEEC6B0005; Tue, 24 Mar 2026 23:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98356B0089; Tue, 24 Mar 2026 23:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86FA6B008A; Tue, 24 Mar 2026 23:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B78B76B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:00:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E01AB7B78
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:00:05 +0000 (UTC)
X-FDA: 84583081170.29.28AD9E8
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id A06DA140002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:00:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kTRQfc4I;
	spf=pass (imf09.hostedemail.com: domain of rientjes@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774407603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLCYT1BBJZAVEfo2dGruLL5s+wMzYpDGhybdNbcCskE=;
	b=uPkp45U0yuy8xDBNxkOkjV/lSB5/dBUO16D7W7c+9CLYRs+TtYe1EtfplspDomVedLAU4W
	ZOITuRevcHz77M2qa5k3jgBJ6L4tZLrgKSChXr6nf5ATuUgQsBvlW7m73APbwIe6UE6imF
	gYil0DL7NjN/2Hn1FcLKfuXXi1ez+GA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kTRQfc4I;
	spf=pass (imf09.hostedemail.com: domain of rientjes@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774407603; a=rsa-sha256;
	cv=none;
	b=dR3BQjHmyP4YaVxjpEXKIilI7AIxbUFnYFjcXJQdCdCuAP37A5/kWblzsAnppH1N2ECPN3
	geV9TMjBEiPIMFOVH5YutJdcxyzmfxbnTS08JZ0lk8H1mEM3j9Ay6HOJwPGsQSpPtrXiRA
	cVEp1J5fbY6xWOg1Ie5qhc4dBqhdvFg=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b04c9e3eb7so47065ad.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774407602; x=1775012402; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GLCYT1BBJZAVEfo2dGruLL5s+wMzYpDGhybdNbcCskE=;
        b=kTRQfc4Iv+fI2Or1lT/csXLbltxmFPOpah7XEeI95DzO5wORzSMDsW2yk/T5LZR54k
         eVoBvwHkmhzl+tYKnf3H0+DzEG2bE3MifGEPzvGl0OjmSXXkBDwDQYaB9xRYI4YOXa4X
         mLAZWwaGXNPXAjo5Kzo6MDL+mS0QDKSWm9EP957p601hFwQ8JAfWA7Z1ONRFGuZo7Dyw
         aetE3IoIS/PaRTI137PQ4mfZBV5RqKbut5zbH5Yl2Yvv39+9ScA4pKmAIkPRTid45fZ1
         wyVugM9pe6AZRJ/hjCKUan46MItmcXF/EilWFLtsWjCAZ65bymru39gbiKpmdzpEoZqc
         +xCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774407602; x=1775012402;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GLCYT1BBJZAVEfo2dGruLL5s+wMzYpDGhybdNbcCskE=;
        b=e7tqjNs2ohGvoiXpHkSnHQWiZVC/zK7K/m5mIaYniX5I5Np45BqXNujywPt86GE4pO
         e3/cMf0pbMxcEVX/wndpG4tU27JwqF8pkgHDUeS0EcAOtqZSDqct3nvEHPXLgUlvvDfr
         DXTMR4m73TuNz0tF6o6OMknnCxzLD5I/myVcmjEy4prdVGzyTk74uQJsuRyoe9mRcHcW
         sKa//k1T2cauZCKi3N2hz67pO7eo39zhmYczS28GcRxaZ1qwf2ZEtLWwDkitR9istZ+p
         XuBA4P0MgT63xR75bxXkLnjmg+diUWH05DiV0kIwSn6w5mRt3VOCGqPvbqEXcT3PuOTM
         XVLA==
X-Forwarded-Encrypted: i=1; AJvYcCXBqMTf4N5SH4+Cs26YHuDK4KR+/tgyOzQrdzqcuwLo1ZKg6MY6NgT2piSmFOe9HwsAI6/MphXzxw==@kvack.org
X-Gm-Message-State: AOJu0YyuZEPNCh6ICh+fD8n/EAnjZe0j1rr/wWxfRbhCz2B6ZR9LwOEd
	aW13UoZqo1mf+z7saCN935M8Vp92I6uFEnthdrSArYZe4BpTLrSNl6eJFadLThw81A==
X-Gm-Gg: ATEYQzzcMmBYP+HGb/PQUPA++22Vn3BofnHN8yEFzu/Xc6WXeMW6yjhfckloozUyil3
	5wHv0K4AYTXcBZ+yt7l4YisHVGx3uLJvjMaMdoGxAO/V4cPyF1obI9r3+ofD7A4V/wSI90HQgAY
	GSJqFrtmeaJ9urhEs6ROo2cGCkg7jqmA+bQDG38QDWEUPg3R0ESSXiKoMSpE9pohm2VYmdhLgup
	VGiAlG+mRh+0CtZSBgpmGqgT1dV47m1AlL6zVwSWf2n03QcxwK3mESjVpD3+yYCcKfiRmdAcPh5
	2DeAJopjEzkQpAY8YvqYzxKMnx+6OTihTx3AM1CN94EDjEFnRnMla6kk99XdkMq1T/MifzqoxWP
	KJcUur059WcOmu9am5oGTutW7bxH9q8LUBFkkHWaGbjFrM3UqbKouFv5Bs8qcnfVLeG4th2DqYb
	hAkXo+0s5bKyFhDobRbGMdzqO7/GN+KzcYvB3ZZXQiw60QMgwVv3nr1/d/p1ioT2afHwMGtEX4a
	r7FVIYYdyhRa9U5h1OOgtmPV21H8/jHx85BEVwtv8Sfuj6FWg8=
X-Received: by 2002:a17:902:ea12:b0:2ae:575b:2345 with SMTP id d9443c01a7336-2b0b2a3f61bmr1084935ad.9.1774407601650;
        Tue, 24 Mar 2026 20:00:01 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:5267:b1e5:66fd:936] ([2a00:79e0:2eb0:8:5267:b1e5:66fd:936])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bc6881sm16083424b3a.22.2026.03.24.20.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 20:00:01 -0700 (PDT)
Date: Tue, 24 Mar 2026 20:00:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Jann Horn <jannh@google.com>
cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
    Christoph Lameter <cl@gentwo.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    "Paul E. McKenney" <paulmck@kernel.org>, 
    Joel Fernandes <joelagnelf@nvidia.com>, 
    Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
    Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
    Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
    Dmitry Vyukov <dvyukov@google.com>, rcu@vger.kernel.org, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab,rcu: disable KVFREE_RCU_BATCHED for strict grace
 period
In-Reply-To: <20260324-kasan-kfree-rcu-v1-1-ac58a7a13d03@google.com>
Message-ID: <a77995fe-4fa0-3b02-6800-3e5a98c800bb@google.com>
References: <20260324-kasan-kfree-rcu-v1-1-ac58a7a13d03@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: A06DA140002
X-Stat-Signature: zfz5dufzij5x9utt43cgn6cpnr36kqgi
X-Rspamd-Server: rspam06
X-HE-Tag: 1774407603-737294
X-HE-Meta: U2FsdGVkX19FULNJbBL5JQX0DpGwh7dGybSW74JeStj2Kt3QJik49WpnE0g8XbSEjtBDwmWlkBC6LCgojugQItL+LovsEK51cPVD6ARJsY5SPx/hWcS5kae0uE1LDi5vmd4I6WFqo/80NIcf5RB/ZmHp/IZDzM8it7HIl0pSJgw0uHinGSkWWQTmlMoD3mztLLIlBGiu95fxI30fQohdUTgUFhqOBQScPc/2oPiee6EVrdtoKkGSpSJ6JGqPdafnJ7woXbkuBMQqQqNL8iIk7KK7UPX0fTnWcQgjekXsVSH7f9ErnLq81ZSofvMT3V/GnpiICOGuoI/UM3zrCLNS/f7WnL6SPodTzsf3wdQMUWk/D/7YmSuxt+805n0uWx8Z50pAeAPgOkQR6b05YF2Xr7+jI44p4DN62gyfbb/USTNpdbAX+wKvPdvHRiNWNti0/nVnpFQnM292bvVcK2CkBwzVvLbwq5878KQVFt4K58gZA3DFdD6GzqCXE9+gnnNM9J+uVJ9QZHcGK48xGt5Uk8g4nz5TjgdkvtfFRsSf3NqjX3oUtod+t5ZhIkuG3l2ZTaYLrUa/qedjq/mAe9dJHGrFURtPlj8TmgQ9a4zOBthGgRa1o4jjCjPYJE3w/sCpgkV4o66Wa5AenEJy0kpJnmeGcU4Y7ievcseNSVnz8rlz6WKj4Su48aBSa6c+o8dvB1SPx2irM3jHN6zrJqFf9cbis9aoh18Ad+4MYdGOE+IyMHaYRDy1SkPMRbUq8koInuyfML6eZM4wooU7+qcZ35kG3mx5ZX6zo5LfVXcUd0g0ikAy/KG1a82jNzLEg8kH/JW4ux1vRXPHpLddYjRfZGng93TMT4eQ2cOjbhREIzQuZdYIV+rlzAb6bLfJkbMHERLqjGX4cyQDcM6TBUJNjL340DDDDTyI+bJBzDzTZ/WNAp1U1695CB/obZdIbQ8vGUZamhXeys79VFpDt5h
 CV8ukzSu
 LJfItw/pailGVuIu52jdgJIHOLjcrSmLRBWcGWRQEAI2yTLD8/pG+vGXoVjlvJdBlgRmnAiWZWGr3gLN18IHGd5EmB/7hz2YP0u4CQ5o885cpgrA44DBGEkrMMETwHV6sZJFgeJ38/XTaPy6qmrcVXASEu4MJx3cf4rrhfO4YbAgMO9UNzAN+xug+dgMgHxn7GWj+VA0l/7jKrCi+FhnIjn7/00F1zjBgJRLztkoY1FWMUoo1Ahbvw4lGJas7iGBWNa7JQjYka6smQqBpbMoQ7FvIMjEhlqPG1LxCvNLFy25QlJPBBI8JdYcTpi+2oieH15uSh4VmgJYJCVOR5fVYi0M4oi5PwBdQIVBmMOmnyq0IhEDMj5zR3VQ8cPL5ZjZ8hSbj8WdDPChT53X9UChcEQ4NNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026, Jann Horn wrote:

> Disable CONFIG_KVFREE_RCU_BATCHED in CONFIG_RCU_STRICT_GRACE_PERIOD builds
> so that kernel fuzzers have an easier time finding use-after-free involving
> kfree_rcu().
> 
> The intent behind CONFIG_RCU_STRICT_GRACE_PERIOD is that RCU should invoke
> callbacks and free objects as soon as possible (at a large performance
> cost) so that kernel fuzzers and such have an easier time detecting
> use-after-free bugs in objects with RCU lifetime.
> 
> CONFIG_KVFREE_RCU_BATCHED is a performance optimization that queues
> RCU-freed objects in ways that CONFIG_RCU_STRICT_GRACE_PERIOD can't
> expedite; for example, the following testcase doesn't trigger a KASAN splat
> when CONFIG_KVFREE_RCU_BATCHED is enabled:
> ```
> struct foo_struct {
>   struct rcu_head rcu;
>   int a;
> };
> struct foo_struct *foo = kmalloc(sizeof(*foo),
>     GFP_KERNEL | __GFP_NOFAIL | __GFP_ZERO);
> 
> pr_info("%s: calling kfree_rcu()\n", __func__);
> kfree_rcu(foo, rcu);
> msleep(10);
> pr_info("%s: start UAF access\n", __func__);
> READ_ONCE(foo->a);
> pr_info("%s: end UAF access\n", __func__);
> ```
> 
> Signed-off-by: Jann Horn <jannh@google.com>

Acked-by: David Rientjes <rientjes@google.com>

