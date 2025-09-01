Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0694DCA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B248E0056; Mon,  1 Sep 2025 09:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FBC48E0008; Mon,  1 Sep 2025 09:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ED038E0056; Mon,  1 Sep 2025 09:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5588E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:45:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 011F75BA8D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:45:07 +0000 (UTC)
X-FDA: 83840802696.14.5E46521
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 468212000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:45:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Bm/3jFxP";
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5tl2cgKbzTAq83aNx0hElpL7R8GlOEgOrdA6TvIQ8ak=;
	b=OGq+cJhJC+QLSZHMoRC1hM8m6Js1CI5seYNaVSKQNRAz8UUWDRYFuqqV+ewC3JS+MKE6+B
	h6bKQvFx8zbVHy1eNhY2HHj5tlQhTdYuUREUoGgePk/wQ57+GBVWvUuBgVZy7ddtYTB6Rv
	wZfeBKxq7NYlPECfSfeANf2g1dQCcI8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Bm/3jFxP";
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734306; a=rsa-sha256;
	cv=none;
	b=1HhIzhRhAOeCAV2JeBS4e/9N9KXFz8YR7zvKpf/SDzdncOqAmAYFOacfkTHh5GQzOWP3d3
	3dACqwd/lVD7mlRfAdWfKOCdkR4WjsZBpqic3aHyHhYDJTKcRt3wDkKsp0b/vTjp9uHOCf
	gIZieGKN5JF+uxAVjxdmcFUDftshkSg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 71DD0601DD;
	Mon,  1 Sep 2025 13:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283D2C4CEF0;
	Mon,  1 Sep 2025 13:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756734305;
	bh=foGamXMOViIJn4G3j6IQOX71KSnPTeGQ3yBpqoRM1bo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bm/3jFxPdO3TDTc6l4dEWpafE4Ax0voh/4zrCE265vf2efYVcM6izsEAOEmBDIw2S
	 6IklfZXNBQmbCcAxXaFtfG23f302OLNHm433bVI0cS1TTbdks5iiBzbvkwgqWvB6ku
	 HGY8M8PREeQTxRGlBV3057vbbTo64F6EtjD4fgVBM5GWMeMxJLUhumLnq3tLxZEkhR
	 wpMoMNL68N++yJvIyqd5dIxCRXt16H5LhD+9LMPR08sNdA8x92A6nyLNNwXY5fYXaW
	 4D2ZlkCKsMQBPurmWa639x6caci0/AyEQAb7tZBzb0NLPuuy2+yfWyPnMLZSEN+iLK
	 QlgLXyxfLq0MA==
Date: Mon, 1 Sep 2025 15:44:51 +0200
From: Christian Brauner <brauner@kernel.org>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com, linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com, 
	svens@linux.ibm.com, davem@davemloft.net, andreas@gaisler.com, 
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net, 
	jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, jack@suse.cz, weixugc@google.com, 
	baolin.wang@linux.alibaba.com, rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com, 
	broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com, mpe@ellerman.id.au, 
	nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 00/12] mm: establish const-correctness for pointer
 parameters
Message-ID: <20250901-ungut-geerntet-51b9f03284be@brauner>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250901123028.3383461-1-max.kellermann@ionos.com>
X-Rspamd-Queue-Id: 468212000B
X-Rspam-User: 
X-Stat-Signature: t7a6mjnqozbdke1iyiz8tksiwk36jdpo
X-Rspamd-Server: rspam09
X-HE-Tag: 1756734306-191587
X-HE-Meta: U2FsdGVkX199VO8xSAFmoLKtbqIA6353ajbSaprrWWeKFJcrtrxDD2gKa0rzX49ead8YWiJ+17w+SIJFNdBZhdcRd397IeO5pTO03hUdsqSyvaYUMDOv1ledhTTIjYsSkvpPrrpo81D4RyJTxJQ9dr74D3/EHBbDO9jGXb5jxDFfbAkzH5JrD/xkGUeM1dsZs0RtQx3zX8rxXaIr+Olei92IEI/l4dLoqeO2K4CbO4YfGo19c0Hw9c6KnIidbWxaPpJIRbQQJiXvnit2kKF9C8+c0PhyGi9US+plLLQRCfckdrL2iPJN65Y9dqwP74fUgbx3kE3+0//Hxmt4xNkNAEzMuBo+iqz9GXr1vpP298S3aX6804SoZ1kms+yXTwv7PbbJ68NliwZsiA27mVrvK+bhXQg0jpF/+ok44cTm3tIfUJYpvD+EFuQfiTaqJcr4HlMqyLgRrb/t9wJdO9PxEYT+dRdLFf4EWaSvRYEi7Mab5+ufoVdR5VEVQu3VP0kxMFf3IDr2s9e0Txko2BieieAOVF1HNcPLhk2aMVVfyhf0UkQyATtnnDrKMGc9OOW9wp5LZ5pVIKk51t4SOrVcH7gReTlX2IzHiVxv5imWOyKJIlMhuz75g1GGZAkK8IaU8Hm+9hFISa5j4IcFcjSyO7GwpPHizg6wg46CxxE10F0vMPGa//ZVH4QqV/TbygGiNtZBR5U/1W0f/ESzyIfiqqduuIJVzjfsMGAPHYq+u+hLjx01hOJJyBIpYyJL4HD7zXpDWlxXI1QFXqgtzAZwcJJ4WoPaExDDvCxGskm5Dn7mHOBgCahKAvzxZboF9yHDCg3bBnOiET1GpFtLn1rnj3/Teh+vVfwfRRIovDuYJJ7Z/JB+CyhUy6pXb16ChLw5bqMfrns/86MHn9tnqpsWchtH86rmAAx/WGCuJDhQGbFyZCtyHqxX6tHr6n10JYYALyIb18b83s5yANjWLT9
 06Mz/Ybu
 gjaiR9qqikVnZsR9UFf7WRTJ3mi6iLqUb0akLhLblXj0+qN+ejNMKyBXh8GaZC5BfJcgA1DESJvJ83v9t9jT8kX4JhqrDO0X0jFftfmptnKgDU1l7MGi8qMqV+SdjdRqiJMKvVNCScv7CSWVQiO1ZFPHqaFqXrUrZ9sOlUSBnaCPSrOhG5bTHrAW9xQrSYDGvQPKADiDWzbUxvPa6N06YFFbq6u4HBGzyBNdz+Cl0Yl6D+UWLB7zw9GTfjc0BO4DplUJrU85BrT3qrD81FEdOeE68Ybesp1M0U3ScxmeAjLtqpWfRmMpVjps3sV082sRlUaJrPOwA5BgnK0I8ry5CytEgsIRaHOq3y0sEkdG8/9yeFzo/YUtZaUyVyUlOwHAOS2U1X7Iqw0yzpykJ/DJjzmk5Q5AACFvOrJ20R6OvzJmTAUGBjU6Aj3bh6HYmBINwvGWs7MaYshQkWeA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 02:30:16PM +0200, Max Kellermann wrote:
> For improved const-correctness.
> 
> This patch series systematically adds const qualifiers to pointer
> parameters throughout the memory management subsystem, establishing a
> foundation for improved const-correctness across the entire Linux
> kernel.
> 
> Const-correctness provides multiple benefits:
> 
> 1. Type Safety: The compiler enforces that functions marked as taking
>    const parameters cannot accidentally modify the data, catching
>    potential bugs at compile time rather than runtime.
> 
> 2. Compiler Optimizations: When the compiler knows data won't be
>    modified, it can generate more efficient code through better
>    register allocation, code motion, and aliasing analysis.
> 
> 3. API Documentation: Const qualifiers serve as self-documenting code,
>    making it immediately clear to developers which functions are
>    read-only operations versus those that modify state.
> 
> 4. Maintenance Safety: Future modifications to const-correct code are
>    less likely to introduce subtle bugs, as the compiler will reject
>    attempts to modify data that should remain unchanged.
> 
> The memory management subsystem is a fundamental building block of the
> kernel.  Most higher-level kernel subsystems (filesystems, drivers,
> networking) depend on mm interfaces.  By establishing
> const-correctness at this foundational level:
> 
> 1. Enables Propagation: Higher-level subsystems can adopt
>    const-correctness in their own interfaces.  Without const-correct
>    mm functions, filesystems cannot mark their own parameters const
>    when they need to call mm functions.
> 
> 2. Maximum Impact: Changes to core mm APIs benefit the entire kernel, as
>    these functions are called from virtually every subsystem.
> 
> 3. Prevents Impedance Mismatch: Without const-correctness in mm, other
>    subsystems must either cast away const (dangerous) or avoid using
>    const altogether (missing optimization opportunities).
> 
> Each patch focuses on a specific header or subsystem component to ease review
> and bisection.
> 
> This work was initially posted as a single large patch:
>  https://lore.kernel.org/lkml/20250827192233.447920-1-max.kellermann@ionos.com/
> 
> Following feedback from Lorenzo Stoakes and David Hildenbrand, it has been
> split into focused, reviewable chunks. The approach was validated with a
> smaller patch that received agreement:
>  https://lore.kernel.org/lkml/20250828130311.772993-1-max.kellermann@ionos.com/
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Seems fine,
Reviewed-by: Christian Brauner <brauner@kernel.org>

