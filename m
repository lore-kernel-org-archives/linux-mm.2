Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB2CD6AAE5
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 16:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1E76B0088; Thu,  2 Apr 2026 12:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9CB6B0096; Thu,  2 Apr 2026 12:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11616B0098; Thu,  2 Apr 2026 12:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFD616B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:05:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85E89E0E79
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 16:05:55 +0000 (UTC)
X-FDA: 84614091870.05.64F7B52
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id F2CA418000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 16:05:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="e/ODv1rn";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775145953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMeE4O3tYspnb1+uRYcEC9JhynEoZ/6Jf/EDgOFDWZk=;
	b=xZTD1fDkLvA04Evi2ETE16iCtxgVaKeOxeF9PN09ThLPUg6l0gRG360yOc0CEXyDeS1K1w
	Er+lRlsVdjbZh0rELijnhJdIwD4h0isdDlyujkg0xAApcwXjLESFwWu4Th2jBO18ktQ5r6
	9LdxKgmKc6AOKSczNGU4WJj3qeR0QfU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775145953; a=rsa-sha256;
	cv=none;
	b=Q40o9PDYGCqbsLTzlAtj9F5mWRu5V9AZZAcOu3uH0+zqm7bVCOkBFrD0OmpEZwJDc/WyhY
	nJgWWQqGZX1MYTPBu5si7VPvy3pVlaS56NO/TA4AhMOp/K1cb01HpJm3f4bnR2+F68QR/o
	wg9VrYDBxMM67C2eVRaexp9xhNLmykQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="e/ODv1rn";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-38bd3c6c502so8676781fa.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 09:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775145951; x=1775750751; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VMeE4O3tYspnb1+uRYcEC9JhynEoZ/6Jf/EDgOFDWZk=;
        b=e/ODv1rnestEekSshWE8yJCBHGZZp/km+/LXH0X/QXBKiQvkoyfb5T0qPUrDAcvyuW
         gw4ovtbcBNWbmcoS4DvmGX46qXG6o3ZMUxE7wHBYW8xwyJY29yALOiM7g89qG45rdqQS
         5nWbcsAOAevRyrlYP1i0HWes1NWE9kV74wP+ZB1mb4N+iaeV0mhDBXAXD7zfcan93Zkp
         i9BUkdw8vb6NX32r/Ii3ccRPsv/faeNW+K1bkV2t/gz4JB7tkRD8L0c4q9cKMk3Y4WtD
         +9Cqxd07W+Rv/nAuOezMBDI00jNcMDZDS4DzQUN4WH3jt1pov5803GP6OD6fsG2pA7xg
         E4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775145951; x=1775750751;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VMeE4O3tYspnb1+uRYcEC9JhynEoZ/6Jf/EDgOFDWZk=;
        b=K8ZpP9zZrfhEBd7O9vUNNpYdmfmmGwCgTILjxYeOKeOEp+TqVt0sP97XItlEaCmJvm
         O5QonfH1Xy1XpP1JHndFhklUeEepWlSFuNGiMkj2iA+2RMFMWmh5r62nXs9+osv1pijf
         D1WqtH4RfrmIvRroRl06W/UPpZ780ufDSumt+Zg1GHKy8kIv7FNVn61xyY5mz/qJcOIm
         RF2tfsKBnH0Uk64iwFzsG42CdfB++EpM8lSmCBkjkSXSDkXNq+KR8pGPnqP/ry/X5HNJ
         hRqrSg+zvzAzZu00a+y3YN4ky08F4Wn1K6OgLq/+hY0+j4C8F5RxwbQaUc7wcd6+JgpA
         DFOg==
X-Forwarded-Encrypted: i=1; AJvYcCX4OJ3c/8T+WvjNUNNZSb9WUUVyfZGqL242VhRGWKwYC18cvuwtDQ0VEvY3muXJvJEO/AfauzrXCQ==@kvack.org
X-Gm-Message-State: AOJu0YwLgUx9fGYu+IpNM8ZPjA7IPPxXNrYbPpVoa/Gz8Gy/Gft61kX1
	iDv5g7CBLv/qwVxiidW0IBc5RpUbM2QNDgtap9Oq5UrsYtR+uauDGvnG
X-Gm-Gg: ATEYQzyOX5vQpmO9pqg80MHQpVFeDLcvMvmdPqVpYY6ZcNp37hqHuEb72O5KDyNSeba
	ixRf5DkT+rLjOgnmupVTDGbEmzA2cSITfIp/2M3xwPmbPX2GO4wGtG5Jlspt9Y08WHLIN+dGl/1
	1dImoLiViwSVPWgU2FGDxHNqC0y2oqn8gEKJWuIbYyUM8uW3vlqKdPACnAqFf9ix+fnhKGEMbcD
	H0PwqQtgdPpckFchs7gG0hWp+DBQx4G/TaHc4pQqnKF1yVnUiZQ1yIAuK0MdjrU7pns0nYKck59
	7d+KPLroPV1psFd39wC/H4U1ufJMTFFjbHY8C528AoQAyDkCb/zwHdL8eZZ9vHmVzCsCdF7QlKY
	F/qRtoU6c3ZvsfIhXu+Hhutq3uCrN0fsasbU6nbZgKvoNEw2QsZwQwlVXDI22wk+4
X-Received: by 2002:a05:651c:3242:b0:38b:e048:57c with SMTP id 38308e7fff4ca-38cc2f3898amr32309411fa.7.1775145950759;
        Thu, 02 Apr 2026 09:05:50 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38cd1fa77c8sm6209681fa.6.2026.04.02.09.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 09:05:50 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 2 Apr 2026 18:05:48 +0200
To: Baoquan He <bhe@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
	lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH v3] mm/vmalloc: Use dedicated unbound workqueues for vmap
 drain
Message-ID: <ac6T3MS23Up8LJHZ@milan>
References: <20260331202352.879718-1-urezki@gmail.com>
 <aczpyc7sxzBL4MQn@fedora>
 <ac22zMBjWgQnLfpI@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac22zMBjWgQnLfpI@fedora>
X-Rspamd-Queue-Id: F2CA418000B
X-Stat-Signature: 6ahe5u48n7r99d6hf664d6o7gh3sdsxw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775145952-211437
X-HE-Meta: U2FsdGVkX1/MbZ2O0RW3quSVFrt/hfiWZklMULU6Phu0MgcTH3+JqlVQTR3lcoiKLL7vfJxQKWmxFCm5UPMg5nt8lx0JSuVTrfRtVx0Uv3izdPkq2IrRadi061f00BDgUBjA0oOf9SwHnv0Ys2c5cUcFQn8dggxpC1KiHYFkXv4T0axs0T7ApmcOhFbNKwOoeZd1Znp47H2AnrMykiop/ZJl2KW+iDUDWmYVpPD9zLPJXh+mQwRPr8hW12b/TIVNo0odm6wtrHr93XoV4WGaWQgOiHwxLURuYDGdDDli8lcZ+66bBAJmXotg9EfAZgYaUqVPTQwT9LDAmDsD4ho5kB0gSepD8yUQBsknr6IcZyfxTP/01SrfgQzKdiDAVHJVOktOcPq2iaIaHPse78dztNWNpzwWySJKnERww+H/l3r/nXUuBzZd2QIh2/lI8rfJoGjer48uJFd7NVZ9Bty6IlGsrBnX9A7rZYEDdcc5ZrQdCzb3PpIwJ+gb2hfn0oEOUZ/K0EAX9VAhaQtNGrtq+DvCZIWUgMeoO8xIScXlpsWM1MKFZ6fGiHQqRikvnrZxUHCI/8td1N7j4Oxiw4MpdbDlMVRG6hXGS1kTG2pMWcQh8ajaFz/OKG3lkVJ5usoR8MeoCwp3gTxVv1zsxYkw1i1N/obdmUkoNK+fENP/A7qOc31BdJIxemQss6Y9kueqtVreDjO0vn1xPKORjegZQh/cZ0yMdsvVuuAcGHAfb0iT3e3pxwolxPiGqJXVzC7ZEqTUK3Zasqkea/tNNbabbFezQ8iFK/2Po4hK3a9u2kvmMdnr59fTeSrrUvUhVCOdphL7oZS8MHNmYpZcvoZZXOpw569YWdcA7nizTVzEuRxYxC0HO5TGU9wAkS1A5Q3tqwt6ilqmM2f9llT8BC00cf5Pf3HJS3SqA324rDVy8yMPsdpE84BQhqv5DlTPEuLmnU06iWRwRuQ7HxcGrys
 N4g77TUb
 Vb/XJ3OG/QaMxZ060KAKNe3xlY1/ocV6FfZzXisu+/Xmhx/e652y3lrIQmiUxqiQVqGTHhwQ/5kLOQiasArrZ90+aAtU+20DVWKPH7reGrdGXulE7vCclyrDJ7+NHZHuFUO9mUsfxbTqVviVux5ViV/dUvop6Ac5v4rhxsVtQWtL3r+fIaEi1zcGPH9hF5DLJAgK92O22TfGGnXDOP4KLuOxc84DJly/gp67YPm6HhSJzjhueW+rpntMrSAkdeqhSO0YyvU3EjBAXn2Av0FjrI4+Ujn0EpbTdDMvlbMYDeV03SifRXTLpuUyQjCoZc9YxqYWrZjncGszHzvf7GZn52WyP9M/6LuaB/eKlHNbxxMkzdDvM5eFdsT2aOg65yCIxqMXikNOyCSGJ7WuNWz9fVekDB68UY6qbep2bs3IJcyF34/RP7OJPnmFw1nc03HPOL7pRvyEP7x5wip9FGUB0hEFPMwABHZFe9wNJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 08:22:36AM +0800, Baoquan He wrote:
> On 04/01/26 at 05:47pm, Baoquan He wrote:
> > On 03/31/26 at 10:23pm, Uladzislau Rezki (Sony) wrote:
> > > drain_vmap_area_work() function can take >10ms to complete
> > > when there are many accumulated vmap areas in a system with
> > > high CPU count, causing workqueue watchdog warnings when run
> > > via schedule_work():
> > > 
> > >   workqueue: drain_vmap_area_work hogged CPU for >10000us
> > > 
> > > Move the top-level drain work to a dedicated WQ_UNBOUND
> > > workqueue so the scheduler can run this background work
> > > on any available CPU, improving responsiveness. Use the
> > > WQ_MEM_RECLAIM to ensure forward progress under memory
> > > pressure.
> > > 
> > > Move purge helpers to separate WQ_UNBOUND | WQ_MEM_RECLAIM
> > > workqueue. This allows drain_vmap_work to wait for helpers
> > > completion without creating dependency on the same rescuer
> > > thread and avoid a potential parent/child deadlock.
> > ...snip...  
> > > @@ -2385,29 +2390,31 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
> > >  		nr_purge_helpers = atomic_long_read(&vmap_lazy_nr) / lazy_max_pages();
> > >  		nr_purge_helpers = clamp(nr_purge_helpers, 1U, nr_purge_nodes) - 1;
> > >  
> > > -		for_each_cpu(i, &purge_nodes) {
> > > -			vn = &vmap_nodes[i];
> > > +		for_each_vmap_node(vn) {
> > > +			vn->work_queued = false;
> > > +
> > > +			if (list_empty(&vn->purge_list))
> > > +				continue;
> > >  
> > >  			if (nr_purge_helpers > 0) {
> > >  				INIT_WORK(&vn->purge_work, purge_vmap_node);
> > > +				vn->work_queued = schedule_drain_vmap_work(
> > > +					READ_ONCE(drain_vmap_helpers_wq), &vn->purge_work);
> > 
> > The new schedule_drain_vmap_work() could submit all purge_work on one
> > CPU, do we need use queue_work_on(cpu, wq, work) instead?
> 
> Forgot the specified WQ_UNBOUND on alloc_workqueue(), sorry for the
> noise. Then this patch looks great to me.
> 
Right. When a worker is created for UNBOUND queue, its cpumask is
updated so it can be awaken on any CPU. Scheduler decides.

--
Uladzislau Rezki

