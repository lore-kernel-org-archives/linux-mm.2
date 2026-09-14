Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98849C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 824B56B0095; Mon, 14 Sep 2026 12:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC266B0096; Mon, 14 Sep 2026 12:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711FC6B0098; Mon, 14 Sep 2026 12:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5F06B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:56:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8F20801E1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:56:32 +0000 (UTC)
X-FDA: 85212971424.17.85C0B92
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf07.hostedemail.com (Postfix) with ESMTP id 24B4440008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:56:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rv3inBfa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789404991;
	b=wpKgMzc8YN/ipc8A7znis1zUA58lQKEcky5D7j2qaD9UH3uMxckEBunIDt4rJh6uYiWRMJ
	IbY8TuMFnOBuQ0thure14XpWOnIlazJ2R0fT6RvF4vB4xn0KcqgnpwUfKsvPXnj3zxDxvH
	v2boXOxFojtxs0BDd+abTLjbVLGSNQI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rv3inBfa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789404991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rux4ku0a2LKW6mMx9aMrLV0v6wtNK1BD3wApxpUmX6g=;
	b=6xh/9+VpDwyQOcg8Ffl5ZIOrXBEHyPpdsxqulNbAi+kbI3bHfFoisGJF1RtR1iDTZAVH8N
	8iITLO1t7QMLejHmVoRU21AFbCAvFGidzY9sXc/RwRu8Ou30JVzbqdz3/ktiP+j5gpF1mM
	nEXpWMPxA9XLdARgZmOwye2TnWqH8Hk=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f6c7a4aso241025666b.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789404990; x=1790009790; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Rux4ku0a2LKW6mMx9aMrLV0v6wtNK1BD3wApxpUmX6g=;
        b=rv3inBfalz8fxL26JKqt7UDBowr77jjzYD6uV+CQxsMPM/LX3YCP1arzfAggNKcao6
         DL09ENY6r+CSTwT3PyEsVuPx0jJ59ep8cN9t0EIAbcglYX6u7wuO/zxHxbgLVIqk2koP
         V8DCvRE5qktPXTQf4DErp5b/JK/obl1sINoQK1Bh90DXgzNl6z4gpDyPqB5ZN2uZpUQ7
         NEMfcuvpfzw9eR9jRmKddso9ACKAVz9b+T/OrN6OGgC7NXKkK0idxg/WgoptVWEm5FKv
         yEl438KKrJiQV6yzJR4OARvl7HLq5p9rKkonLlr+iGGSMq+5TgIjE3SI4ZeUbZVOM9KP
         Q2OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789404990; x=1790009790;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rux4ku0a2LKW6mMx9aMrLV0v6wtNK1BD3wApxpUmX6g=;
        b=e3LBoVoM5FiLM7k7lRo2DGwu0wzdt8Bfiep1Bi02OLvwdmdSQ2P5TpQRKilbKjyq9a
         2o3YEMpP6QyxtxQgPFuYQUM5MpBD48diXiKJO1SosiE20/N4bSudAwNNIuOh1IZd5v58
         Paitanf9/APN7LqJ4nGYJn5q6U0DnB56yPiiEmZlXpdz8uZGyxXLI7+Bb5PKeSknALP2
         vB6nF6A0Ob+FUJ9E5y/Je43xubmMSNXibxF2jPgtKRtBJLzus9WLfMk8qewyCd8QDLPO
         SM8WMOeDKaoIYYAebkn/i5jwicR6YYHhDkJ50cySbpXeeyT6V1/XqVy1ePrvB0N8Pswa
         G2Aw==
X-Forwarded-Encrypted: i=1; AKwUvByNzboR2UfRi4aIBWAJggbO0ZvB4lce4q3bHM6DJjYnCbSMiHlMYJ6ighYWdcX9iW4StUxFWBmkbg==@kvack.org
X-Gm-Message-State: AFuF++l05VmJr6WtYa4Bn4dbvqKdcrPou9cNmh+GpIyjn6OwlETuJXIc
	KKSt7B8aREwIXqsDlELVNpiPIA/2JABvoHLfu/GlhuKqOZ76oDvJMQKu
X-Gm-Gg: AYBFou0Qtp1+h+my8Pq5j3a2DiKNaOV59ZuFSyM5Ewa+33t+mVUcEU54jZ758trxO/f
	O9x+L+BR1TlQpCkiWtO0w3TtJgGaz8YipdEA6Jvpq/NkX679MBruH6xQ/T+QJACXhgLHPgkZfp4
	u5cthKbtHbZXUlI0QTVBAayfP60jCS44DuZnXlkuq+arCql4xkTUIoJcNwqGX0IEZ5njEyvq8/A
	V4A6pNbPLDII02oaEjwztQM+4PUnGH5L2931Uk6fvBj6ylHVAv846g6s37/eq04jAIYEgzZJRi7
	f2R677OTkOr5RVQP4x77L0bjUrllZGiEiZYCb2VTmRQvgfIlMr7DslnY212+fe8luA5r5J18HCS
	x+0AlZOP5cnRWUQdqL/GU/RMwMnisemrnrZOw1+1MRx2lB+n4gwLS1IveIrPCTHCoC1d/ky+kt2
	K/JkT+pcSeoSRLlnVfjrK5Q0rZ1Pf4Vbc7B/ht
X-Received: by 2002:a17:906:c144:b0:c29:3711:626f with SMTP id a640c23a62f3a-c29b86f69c4mr214406166b.24.1789404989584;
        Mon, 14 Sep 2026 09:56:29 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2965c4e8a1sm467527166b.6.2026.09.14.09.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 09:56:28 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 14 Sep 2026 18:56:26 +0200
To: Hillf Danton <hdanton@sina.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Dev Jain <dev.jain@arm.com>, lirongqing <lirongqing@baidu.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] mm/vmalloc: Use dedicated unbound workqueues for
 vmap drain
Message-ID: <aqgnOoOjWxRtaqxZ@milan>
References: <aqAZ4H8mauWw4JVM@pc636>
 <20260909010851.613-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909010851.613-1-hdanton@sina.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 24B4440008
X-Stat-Signature: 74rf4ay868fdyc7hkskt9iup5wrzri1x
X-HE-Tag: 1789404991-393472
X-HE-Meta: U2FsdGVkX18oMOz7jpW70ZAJVEVvguz76eXzgflE3cE/QcQFv1Hce+uHGoA2PvKp4AO3dK1IR9Nx4lBaSxkbtZvDVOiyrYtItc/TZHyWpwmsnghfcUsEmyJAHogQqwqoFIju6DW8UbuieQy7+cfCC/npdXDng2oAzk+/n6+YPWWWrgVmHkvP1e5ppY32DHQOJ2jh5KZcuEueRnr2JYYR6Y80RK5OBDT+bMYboQyLS0ZraMtvxrpmsoKScaKvc3pIbN1xWdFPEdqQDy44z3mjTO80S91SPNOuM3ZFl0wSNhwXkshfyWlHo0/r8TBMJ7qxYtRoKoSy/7SPh53QLmGa5KUbUOrFl0NzdAm80ksz2xqHx/hBc0Tl8K62x0ZEZ7jBqF/0Ey9HCiI/ePqw8SdblitS5RrGvnhWN5kJ4tY0f/2EVH15e+EVFWxzXVIxe33kTMAXC/dg8Rrun9ns6V9pdYf76RDRm/QrORJ+Alr7gry/PSc1TXC0WlWsO5/U6e3ApONwIeO+bg3aLpt6ZW7KM2NervRJPA6TgqvuCqapELWvwnv3c00Os+pWGOmjtPF58tz2lypHBBKiNqNQxgxsGQR/gBvZTGJ4ABPpdD0/69OiPMFfNUb1Uqj8xlVGQPP2owWigIJSLeXlKY3lSp+nzzEb9KU4JcisxHnFYrMqjEwX0Xhq5ICQT+47fRxZvDgt8rG0yCufg+m2D6bafuTKg2tIrdNiJPf7Xo/OlD+HC5AHTH+hR2XNPtRb9SE0atCK5TPkQpjpuYv65VIt338vy54DDNTlHvD0vJ+d/tsEYwoiJ4M18O5H1tayqUskgpMgy8k147psfVUumrmFRS+DnqZ0Jy2n/UabfoWuZ1OltqhOdXHps6g+dHYhopAQHhh2IoaUniTU4bLyhYVwlQJd72K0sbkvUJP+CKezVrPm++xMRMP/LYYRioIxQEx2D2BzPq6Ppwu16s9u+v4RgFl
 qQgAcZyc
 oktfxfCryyNU21b/C1gWw716TaLBN9trXz/mSErhckhY2HgT0g9Gl0GOF5CkhbUHZnmCFZ5l+jrubke+G5EmQhDeZApNm0pUTpes5BE9dZbkTF4T3pTPxoIiIdjSFJga9bgNfRNGDLQCeikjZZ7pvlrekmECqXxn2mURQAhxWYsAwQiiqBohK3NtimsnhUpWXs7gUsyT41jLZeH6tZF0UDQuYN68bYvvjiwQe/GOQef5mYmq8GXrvku6rnhhpAHeISQfAJEywGBMh+WGLYc6m0vcNKooplxpPpZgVwTEsNoF+z6qMz3fCw4RLRpAcZoKkP7BIMaY8nTGeDUJZ2pT0aOjGMwftOXDhtdjE053c8I1kf44cFYC08COn54FRTaGpdKwT8GzP0DDv78Exc5euzXQWTfir/RzGkvBrFX12RTscIeOdMgQqTgd8KrWquTS/EiNSagyrjD09YLJFmdsVgTW9DGIRezGTLqgS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 09:08:50AM +0800, Hillf Danton wrote:
> On Tue, 8 Sep 2026 16:21:20 +0200 "Uladzislau Rezki (Sony)" wrote:
> >On Sun, Sep 06, 2026 at 11:50:24AM +0800, Hillf Danton wrote:
> >> On Sat, 5 Sep 2026 17:27:17 +0200 "Uladzislau Rezki (Sony)" wrote:
> >> > drain_vmap_area_work() function can take >10ms to complete
> >> > when there are many accumulated vmap areas in a system with
> >> > high CPU count, causing workqueue watchdog warnings when run
> >> > via schedule_work():
> >> > 
> >> >   workqueue: drain_vmap_area_work hogged CPU for >10000us
> >> > 
> >> > Move the top-level drain work to a dedicated WQ_UNBOUND
> >> > workqueue so the scheduler can run this background work
> >> > on any available CPU, improving responsiveness. Use the
> >> > WQ_MEM_RECLAIM to ensure forward progress under memory
> >> > pressure.
> >> >
> >> If the dedicated worker will run for 4ms on CPU2 before the tick irq kicks it
> >> off cpu, the system event worker on CPU2 has to wait at least for 4ms to handle
> >> 200 events for example in 1ms, the net effect is the same as the current scenario
> >> where 200 events wait for the drain_vmap_area_work to complete on CPU1.
> >>
> > It is scheduling decision. We do not want to tune any prio here.
> >
> The difference your patch makes was checked without prio cared.
> 
> >> 
> >> Different workers does not help to dramatically decrement the micro seconds
> >> the drain_vmap_area_work takes.
> >The problem of current approach consists from at least two problems:
> >
> >- doing progress under memory pressure;
> 
> Though in general a long running workqueue work is a wart, exceptions exist when
> mm is tight. Just like kswapd that becomes a cpu hog, it is the right thing to do
> for drain_vmap_area_work to take more than 20ms.
> 
> >- do not schedule all workers on current CPU and let schedule to find
> >  the most attractive CPU from its point of view. For example: less busy
> >  RQ, less energy consuming CPU and so on
> >
> Nope as UNBOUND has nothing to do with cutting the micro seconds the
> drain_vmap_area_work could take.
>
This patch does not use queue_work_on() semantic thus i do not want to
queue all helpers on current CPU. Instead scheduler does balancing and
that is it.

Or you prefer to tight all helpers on local CPUs? What is you concern?

--
Uladzislau Rezki

