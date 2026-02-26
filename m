Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 507E0FD8FCE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B22D46B00CA; Thu, 26 Feb 2026 10:46:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9A86B00CB; Thu, 26 Feb 2026 10:46:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98ED86B00CC; Thu, 26 Feb 2026 10:46:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 810F06B00CA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:46:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 550E01C103
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:46:02 +0000 (UTC)
X-FDA: 84487033764.07.8DF8499
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 80E6E40008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:46:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=awgZ42o0;
	spf=pass (imf11.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.182 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772120760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuTxE1p/1rypYy1lij4BdYhQVDSEtiYhB76DoENLIhw=;
	b=xIoZMHS4y9Y50F6up/gyQ6tpumrMjGGS6+72jOddhOPhsCsoF594s8dNcjN+jXcvmOjQGU
	ptcZ88hLZCtih/6phtQhdEGfcgo4r7AOynlthQZ6//GAG4TjD4voqlKuTBYl0HYRqs2aN4
	S66wRSfM5nVckxm522YryqCkdIbA/Wc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772120760; a=rsa-sha256;
	cv=none;
	b=RPISsfTj2VQdnscvIqROefPv50O76I/uv3yE2CSDxBPgUQuhG2NJTjRIWYMxL+3eXo012g
	/eTbNTeGot4H3ZpOqim9obow26U8IYhhu5miKhbSibUnpHKVeo2ilC3KaFSfD0uA7F2Dp/
	lFj3QIHRcqA4sT78pxsg1jli9AJz72o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=awgZ42o0;
	spf=pass (imf11.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.182 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8cbb6d5f780so99169585a.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1772120759; x=1772725559; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wuTxE1p/1rypYy1lij4BdYhQVDSEtiYhB76DoENLIhw=;
        b=awgZ42o0cLzjqZvts5wepFOdT50xusjHYNa7NQRSfcO+HPqYvyyUf5D0a3vJNBDNv2
         NK4c9coal3MZT0ChvahYiFygg2M0Ek0p7S5qmS/vixJJXDh3HhqsmocbEjrBJFIWjRfF
         l4QvXqqwFbb0QO8Ucb0mJUlys5AVbCpkvbCfcw3k829u1oS5RnljZIYf138wKEtAROfx
         xTtNpzFwchUsbLG5qDOH+TJgH7ChISc0zC+YzUtp9EZJ94+SFWPwFTjfwj5ilhOuYJkG
         tO0q1Z/WCO138BqVQRcXQE3voExewmYVVs2CEZS1b3VIxZZFu+KmPzK4T/G5H5RIdJka
         4PxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772120759; x=1772725559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wuTxE1p/1rypYy1lij4BdYhQVDSEtiYhB76DoENLIhw=;
        b=EoTbjEgvjD8mR/PfaMpxO+TZNsNUdGpHBeP2+aDz+tw+XSK+DZ9Z9ZtmDiG4LuiNiB
         gb66zw6xwwhNfcV720oyVWD18l1fnF03ncgHaBLRTXeO2q3iI+TBE3FFO/O2tuF8gCsI
         8xfbn8yC3s2kx6Cw3SUNoSASLOxtqpljbcKjkUl8RANv1oEBCuJIsR1JaPgRpyRUyz2R
         x1Q6IibFgjVIziQeTUnXRBpPU4CZdUXTU0PjEjBVcpY46AnnPLmeYp/76qoNPtMAmgRW
         JnsQbkOJCXvWVjUfJSzIZakJYXZmleNVpN9JWh3ughevZMF8PGEYzbXACkOivM3AcVM9
         SLhQ==
X-Gm-Message-State: AOJu0YxqaxBsz1+O+L89jRyiLE4qz3VmJUQWgEq9WmLmYceHVpDXpYuI
	OJQRPJizvC9vrM4vKpjXm3VCKMhWL6xMrYv4B5SNueqAPbMeO30+uspfECcPwR+sYw==
X-Gm-Gg: ATEYQzxX4LPX0VjW8W3oPmM+24OgNQdIqX8lEc/uCE5T1DeMyrlJ3ln63hBm8Ym8hoK
	VvhCZywVEuk67+2P7K8ouiA8vh9IuaoFtilF505AqBmZNwWnYp2+IGr9bAHmX6qEDJjIv7GwARj
	vwUn8R2J19jJI7q6YYUsWwhUPNj/iZBDCiEw9u4v6boh3Q4BVRvsjHcMmxJSrjfytKlL6vF+UDZ
	mPMjVhmFCX7qleVTHUFU9d28VoLgVnwV9duPgkD0BvjRj0+ZMQkjqPwnNbEjEByNfpQkjqU1wbI
	c43HLRynUWR1HeLxfFHQC9iOrQe33jmrBsMz46e1hXUm3kgVUrscZK5P3sp/2KlCe24lOkSqrNQ
	uF7bFhBWifd+HB93LMYZ/DbmmJtx72rtNWHsR+CZs2ihp/IJmOxL0fHlCB3XchVnEJhGSHvobJO
	ZMVlDGGoZrIa/c5JprSRPbXoTtspxwfJrrtHJMHTB0C+AyWEXZLpuW
X-Received: by 2002:a05:620a:1a9b:b0:8cb:4289:6c1a with SMTP id af79cd13be357-8cbbd05ff45mr585156785a.75.1772120759113;
        Thu, 26 Feb 2026 07:45:59 -0800 (PST)
Received: from rowland.harvard.edu ([140.247.181.15])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf67814bsm272731985a.17.2026.02.26.07.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 07:45:58 -0800 (PST)
Date: Thu, 26 Feb 2026 10:45:55 -0500
From: Alan Stern <stern@rowland.harvard.edu>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, Dmitry Vyukov <dvyukov@google.com>,
	lkmm@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Daniel Lustig <dlustig@nvidia.com>,
	Akira Yokosawa <akiyks@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Luc Maranget <luc.maranget@inria.fr>,
	Jade Alglave <j.alglave@ucl.ac.uk>,
	David Howells <dhowells@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>, Boqun Feng <boqun@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>,
	Andrea Parri <parri.andrea@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Marco Elver <elver@google.com>
Subject: Re: [BUG] Memory ordering between kmalloc() and kfree()? it's
 confusing!
Message-ID: <9dcd02b9-42da-455d-aa08-165e6ff0b921@rowland.harvard.edu>
References: <aZ_lJAqxh_hNGr_v@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ_lJAqxh_hNGr_v@hyeyoo>
X-Rspamd-Server: rspam09
X-Stat-Signature: zgdhx3pbdmobm718iy1tyyichbdz1m1k
X-Rspamd-Queue-Id: 80E6E40008
X-Rspam-User: 
X-HE-Tag: 1772120760-259552
X-HE-Meta: U2FsdGVkX1/OSaAI7dLSw33GJALBFCJBjbAuXi30sj05Q+h0YU16qjRzxQNcqg0b6hBJsdBoHCbUZsnr+xUKxFk+mWoMcURw2UjO7XodKzkMRMvRRb07ylIv5Gty25IB5tVNJ2yNuYKYLlqbGn85jktoXYruAaTRD0qLNfNpPCpI47RpqfYgL3YL5IgN09htN8tpi7yu8yOr/yqvvbZd00mqGtgBgBjwCYY3nz2iztakgQbmegNJT6trxnVYPAZexnpX6MowiHe6s2z1gANF7OdDYTWID2N8gX5mySNfLV1cWkbzU+023b2P6H3SsBKOTTqMJt5NkVrnuFsIkDPRubfC42MQ6Gbykv0rzlLNaui92lHD0DssouhbjhCT8ihLOIlMc2uhTNUPvhIPyP0Cg3T4e+5sngUFWN6cvdEMI1avpSJLh73nXDGYL1hWnUpMJzX/PdTa3ARo7vgE3wvECZ/rtTpo9cw4SC+iIZ769GZOiJq39+ipWNT89jD8GGytYqqcMmVSyXnEWFuSSkxKaQESYAU3BjasSx0Ife8hbeyf3NRHYBTtqjOBqa0NlYkJVLv/X9PXpsW8BoIZLYpORt0H6GVHTmju8AJ3x0Y9JzNfsnSotyxejD6FqR0PgYr0U4aP3RPG/RX+nyXuPf0T9rXhTyHLffRGISjfH/C/nkVUeHQ3BwfPV1QuxT3HzhX/hUoEbF2719bL2/iI/P8MykioXVltkc8PovY68FUo9+teVXXXsi9Jx09sbUv9Jticf2ZPIoYJwE2jqC5YgfvPBh+/5+dt2uNh7zjmJY6w5mjM/OuOrNk1i8G30AK5yXcLcwa/VD5zuxviDuYb+0nhlesR7lzMDQR2jkuXNN2Apm+OX944rC3JVQonBPicUlfQuExNyyoK9sSMdhRcTyGPrBERwc3MZL0ROHCzXOyEKdpslapf0gpoo/uVK3CIlsQC+uoKMwSW6UwenMdJpfq
 vRWZa4rk
 57TstsAaiCPyIQDeSQYw9Y/x3Is1sJRRQAguMTmL+Di65oW7d5r4kP10RjkAGlcsCrmYlNAkvZcLYUfjd2QkwwLX1Fr6UZhl3WrSDX0sSO/FGRHx5DR2UljuurP840AM+m1HLfUdbrxpOLd6hsegBGnjhHSKE2RJzN3BH1ftIIBmyYfVBTNRE/7/MqAWGUUIHrPttp9TwjMLFYBoWXPNcxehEi2RKvWmzpnfMBcR56kQnNup3fZEedTNmJ8NOMHnLo1+2uCzuGB0nSr2knFKlmaWvoBxJki05W+jwQc+bSN7myuDcOzPYPW9OPOdDgomZYT+9UA07yrAJqKHmoXeo0DKr18g2DWXl/s0xwpO+Xp0nQFLCkMRyj5BktrQoKs3mspFKcB38+62hZtFWBstI3BCun7VQmt++eSeb/eqbytPHwuwpvxaNZQOqv5jWJktpyiLD10MpMIBPDz3TNRg+1GuAUkInVhjbL9xA+257Ofy/AQcQpBG9kil7sWBkaGjFtyClxo4twp1+zsJmNKswlQItLRVSLyo03RGwr9+fk7vY8/fJEPkdw1zNG2QXSOiFGE+tWsVDGKXzBjX3hlo2yyjKVlbTc7sHOaIHLEMZDtoC29k455FqdcFEdz53QH7kDUrxU6HzRdZvivfGN4Ej0ldDQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 03:35:08PM +0900, Harry Yoo wrote:
> Hello, SLAB, LKMM, and KCSAN folks!
> 
> I'd like to discuss slab's assumption on users regarding memory ordering.
> 
> Recently, I've been investigating an interesting slab memory ordering
> issue [3] [4] in v7.0-rc1, which made me think about memory ordering
> for slab objects.
> 
> But without answering "What does slab expect users to do for correct
> operation?", I kept getting puzzled, and my brain hurt too much :/
> I'm writing things down to stop getting confused :)
> 
> Since I have never thought about this before, my reasoning could be
> partially or entirely incorrect. If so, please kindly let me know.
> 
> # Slab's assumption: Stores to object, its metadata, or struct slab
> # must be visible to the CPU that frees the object, when it is
> # passed to kfree(). It's users' responsibility to guarantee that.
> 
> When the slab allocator allocates an object, it updates its metadata and
> struct slab fields. After allocation, the user of slab updates object's
> content. As long as the object is freed on the same CPU that it was
> allocated, kfree() can see those stores (A CPU must be able to see
> what's in its store buffer), so no problem!
> 
> However, when e.g.) the pointer to object is stored in a shared variable
> and then freed on a different CPU, things become trickier.
> 
> In this case, I think it's fair for the slab allocator to assume that:
> 
>   1) Such stores must involve _at least_ a release barrier
>      (for example, via {cmp,}xchg{,_release}, or smp_store_release())
>      to ensure preceding stores are visible to other CPUs before
>      the pointer store becomes visible, and
> 
>   2) The CPU that frees an object must invoke at least an acquire
>      barrier to ensure that stores to object content / metadata, etc.,
>      are visible to the freeing CPU when it calls kfree().
> 
> Because the slab allocator itself doesn't guarantee that such
> barriers are invoked within the allocator, it relies on users to
> do this when needed.

It doesn't?  Then how does the slab allocator guarantee that two 
different CPUs won't try to perform allocations or deallocations from 
the same slab at the same time, messing everything up?

Can you explain how this is meant to work, for those of us who don't 
know anything about the slab allocator's internal mechanism?

Alan Stern

