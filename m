Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A48C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 12:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54AA86B008C; Fri, 25 Sep 2026 08:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FBE56B0092; Fri, 25 Sep 2026 08:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA426B0093; Fri, 25 Sep 2026 08:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 106B66B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:09:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 17275805E3
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:09:11 +0000 (UTC)
X-FDA: 85252164102.19.B16BAA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2CFC780004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:09:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFLxfz7t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790338149;
	b=VTuidgfIW7OX/BmWp872kjF+8hZLGf0kiFve3o77KZ+rufCTANnq9ElOtceccMjXLI2k3h
	i9eKyhgdT7JdvOUihgnKwbFclBs4YKAp4UTPvCl4kjdQcLyW6nmrFhEnoAXZwTY0x8Wu2A
	RsL/MDb2IAqzh5uZVZe1+oqSmi0xlJk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFLxfz7t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790338149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpOatN8c0vzQ5XGVXFfSv8DKVf4rivauZnBt896FgHg=;
	b=u7govX6WQ9+/lvffhOFTPn4YNjGvPANHbvaCbC/qQn3EYoaL+VuPCb8nV5IIdUceJT0dUK
	NKWonfaCDKVfoeLXvAoJmv8r6ZEibFbsDhzmoUFswcqbDCQFhY6y7w/l/SvH1F8wBukgAo
	/P7qkVDo1TsTiVlbDjNtJQ/9d/5661U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C955460258;
	Fri, 25 Sep 2026 12:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65371F00898;
	Fri, 25 Sep 2026 12:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790338147;
	bh=bpOatN8c0vzQ5XGVXFfSv8DKVf4rivauZnBt896FgHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hFLxfz7t37uk7pH5vMDI/1xpq3m/TfoPjgAEzzyFhXiVwGX5wTVE3zad2a2pHObWM
	 6I6Q6lr2K3mRbRNX28Efh3GAXHHmIY3YYpn2B6Z2wR2wyNpFzBZ1Ix1J/+1vDdJlxQ
	 2isQkE+59O8Xlw00i8bK83i3Bheo3FtYcBO7OstX6ieuCPEksA4fWNkzCHIY2nH/X7
	 PGoKz2s9mawB5vpJ9wNo45/KqKTc/o1pzKByjAQNaB8vCP5zcdMfxTkUHqXQn/mhns
	 Wh9cEGNbH3lYlFSL2xTPz6nB1tY6rs2EeveZXxprkJu70kcro8FdK2VAa7oMTfWpMp
	 eoynUk0yJj7aQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id F0D01198003A;
	Fri, 25 Sep 2026 08:08:52 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 25 Sep 2026 08:09:02 -0400
X-ME-Sender: <xms:VGS2apVl0oCJHXSAF-WnG03V0OTkE3GA3JKk6_2wku0RZ0iOk6I8VA>
    <xme:VGS2aiNFpi9BnkhFuuvFuFD70z2eBlFObIvPb29IzL5mI2ZX4ynwOvzRE_LNUXFwx
    MxB6eWOboCuVpa1CHShE3eBEdlpVGjuVpHowmad4m6Ezn7y_bAq>
X-ME-Received: <xmr:VGS2aqOosTEEs-ZdT05pxKviNpAWr3_xzRLG8_wFMp7Vw5A6xBNjESi0LMg>
X-ME-Proxy-Cause: dmFkZTEA00vB4wCEuGFPU26dSeuaRUC5A4v8eR3RjG3bBqa5h9xJ9DkJKF4RfcLFM9n52q
    3k8DUPXRt4S1MUQEQlgs/wFXZV95oQo4U601e3eSYJKZG4Nhmud24uk7molK+3EfFBEyfp
    uDB+bzuPtnSdm3cfhWN7C/cKeLr/l2x069NPMBtTxphXRLuvs4rl/Oop2SUxPOEiACBaC0
    gVKF5BVz0FD5pmDrDLCObajhGOWXVLPB4W5+pGabl+YCuxbxl1db9bA3z/zmlyf/1Y3+2L
    bVts6vygIEw+WpL0zBkMy806BQB0UOjN5unt97CMkqUmRwIhB3ZHFNBhyJmHTKmaY59xgy
    PaoQcuDGforIp2yh/OBDcAuLeHTf4NVgu/Q3MiIOv2TZopVH0lk4R8KuKyPCu2sh571uG9
    sQPWLWpLg+PoxuyoKvDnj3hE9HeDAhnW3hojgqd3K3wL+y5rD/qo4gklbsa8cpwL188kU/
    PkrFg7Z10iDPdvydF0UxXu1cXW3SDAD7DkoSjDdZk52r6lJ4VuFRP8XOiCC01t/9khS7+8
    80d3XVP2yWba/CGFqlEv9Y9vYYaHPUtop786W0VSRxh4hYXHm6ZkBsk1pUW3rlfEVHeLs+
    E+BuIgoOa3tDknUGmMSn2+zWK6DrKkUYj1McN22x/IP5Ssc3bWGg5eEzG1dQ
X-ME-Proxy: <xmx:VGS2aoYZ7nFUadQ6kpGq7uDV0Tu20PSpPBisEuB6MM_0W2vrpxJVUQ>
    <xmx:VGS2atoj4JRTVSnU8vzq8ZHzfJromoy1OYGmojnz8W7_me2t_SvIuA>
    <xmx:VGS2ak9LMv9u5n_IwlQGG91twmRAsL4cPlt48wRftdAIxr4bG3jPgA>
    <xmx:VGS2alVS_NfEyFQwF6El4FGRt3qemk-R8MfkGXNZNCHv-aPFOPXyxw>
    <xmx:VGS2at8o0pQeT8R73VmmXOBI_CqD_RbB5258qJ3tDaj-yJiuehlpH8fX>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Sep 2026 08:08:51 -0400 (EDT)
Date: Fri, 25 Sep 2026 13:08:50 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, 	Andrew Morton <akpm@linux-foundation.org>,
 Baoquan He <baoquan.he@linux.dev>, 	Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 	Pratyush Yadav <pratyush@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
 	Marc Zyngier <maz@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 	Robin Murphy <robin.murphy@arm.com>,
 Steven Price <steven.price@arm.com>,
 	Sumit Semwal <sumit.semwal@linaro.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
 	Russell King <linux@armlinux.org.uk>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
 	"T.J. Mercier" <tjmercier@google.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 	Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 	Christophe Leroy <chleroy@kernel.org>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 	Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, 	Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>,
 	Rick Edgecombe <rick.p.edgecombe@intel.com>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, 	Long Li <longli@microsoft.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 	Vitaly Kuznetsov <vkuznets@redhat.com>,
 Andy Lutomirski <luto@kernel.org>,
 	Peter Zijlstra <peterz@infradead.org>, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, 	linux-media@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [RFC PATCH v8 02/14] mm: Zero memory during shared memory
 transitions
Message-ID: <arZkEugXwCtKHH64@thinkstation>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
 <20260924100529.1398790-3-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100529.1398790-3-aneesh.kumar@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: iqkzbhsboz3fitjz6yzoeug6ekh5bo9d
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CFC780004
X-HE-Tag: 1790338149-278732
X-HE-Meta: U2FsdGVkX1/vUWyyh+waJpN6U0VFb8d/ygYg2SPJ9pNCAbv7JJ+txFW8B1TwU9iS1VNmYjK1yHhiRWe0Gh1aFvVzCBmvkDWdhWS/yWQa6WhaTkoqzTbQOpXIUqIZpiZoDR4EQOD50gLIzJO7Ds225z0wtUdoq6vBvFfIswr0eDeCQhYoQnADi3m0jgVCSsjJZtVVHY9FA4mehOmL8jprjjGWdtKGQDVZDVPeeilwOtqQZHqYQxMUJtd1jCCsWtNtXYvvjzbM+SkDfkqlJddziG5B3THwY2z9eJZb4ScC+ogMPqrXvNzGv0I9s6pflHjRJNBM/OT2sJhqAbSRysXmR/L6hBAS+Q0XS4LrWhhSZ/AQvLB5AcxoJjntUt+p8+L4f2rT713IVl3CmaE6hUSWJQC7Ma4n4dQcGKys0EDsI4Vumo1VQC5re6+SMf+bok6rA8pPt0YxtmrAEARrytmw+8PMjC4sUImxorXW5czMhkXJYIF3Dh08HxGb59T5oNFbAzfU7TS/KJd04N0qMGjIXn7RgxGARwzFQQ0dF8tbskxSqPGoMcj5L5smeBKHoPTC6nsivcTHKgQ68DQAFCnY8M3OMOjS8m4aZ8uHH7y5lWXIgPeXhHpUo6PUc1t+zBffaETTXlbH7MLwr7xkjzQAGfbccOCP/djpz6RyEMLMfVpzqvRVRG+k6tCR5pxHHEb9lXFdYBkyhKaqnhDA7BpdL1scfgmKy5XZCrzQbMRMIQmZufkBFpStYNLvsMcJah9Jpd2PWOWEDMuctOojqW7GQlSkZ6/w/kdNjy9Q7vHCoQ5yxfqd/HQGor1a7HllY1ysB2twEqj7+GQGo43oka3cU0ElXDpjsSXk1TRM5dH6jpWZ99h2ZKZEGhsLIIWAG/AtjO/aPOzrLFU8cYBy1CUWKiKXrlJV7zoIuxFLJlldn7MGI8gI+15vB3zrGQ6qfFIY+sYRte0yacbS+qA1/Tm
 R4N3vQyv
 xg/0vbWfBHMsAr+9tVA7Kgv3qh87H5ah8issJ/h5drgxSYrhcuRyd1aUKa1OY4wyjsBp0mJI7LrTXu50h8Yj7i+suT4pTa4CBJWQdcg75RiLBbYIjM/fe+X6WTND0JfaziZSgh11V8Kd8PfqBhilPJFEZ3pFUHDJQ2UuT761kVeJZNC7nr3t6FVRreLQIV4kwdxdY6+Be70mbRrJ2W66/squ5z//G9RqYiLwWWKVMI9Tdpd2AHFZj0OhsorEudduda5L9QmxtRvPScS73o0rVUNz2KTMZArVRYR1tibnTFp0y6JdZcaDUpuNmD0Cynsvzd/LjYhNNhxx42+dJSOeeCVAfdMf9F5Egckr3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 03:35:17PM +0530, Aneesh Kumar K.V (Arm) wrote:
> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
> index f904a636d449..1f1f39082391 100644
> --- a/arch/x86/coco/tdx/tdx.c
> +++ b/arch/x86/coco/tdx/tdx.c
> @@ -978,6 +978,9 @@ static bool tdx_enc_status_changed(unsigned long vaddr, int numpages, bool enc)
>  static int tdx_enc_status_change_prepare(unsigned long vaddr, int numpages,
>  					 bool enc)
>  {
> +	if (!enc)
> +		memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
> +
>  	/*
>  	 * Only handle shared->private conversion here.
>  	 * See the comment in tdx_early_init().

This doesn't make sense to me.

On TDX the memset zeroes a page that is about to be dropped.
MapGPA(shared) makes the VMM back the GPA with different memory, and
what the guest reads afterwards through the shared mapping is whatever
the host has there.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

