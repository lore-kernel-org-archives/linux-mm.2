Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 545DCCFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 05:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB53D6B0028; Mon, 24 Nov 2025 00:25:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3EEB6B0029; Mon, 24 Nov 2025 00:25:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9069D6B002A; Mon, 24 Nov 2025 00:25:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 784466B0028
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 00:25:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FF49572FA
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:25:18 +0000 (UTC)
X-FDA: 84144362316.16.9E3CF23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 796B74000B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:25:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhFRjbNJ;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763961916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRuBmt1neOVKf6vfrE4TeRdWQc5dt7CcjiY8tWWNg48=;
	b=F1nX/7/2Ee+jVmRWnz/EIFti3gIAt3O8SbRK0uBM6VhORfLt1hp7Cj4LD9+akAtyCQy/9c
	7gM7YEIOoCyUesGi1weESQk0doDIlCnX9/+MtI6MaW7GgiUWzCGSPUWkraKghmQGdVR+Lf
	9TvDY7vRqvGctPGRJhyZC98wwB9y6q0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763961916; a=rsa-sha256;
	cv=none;
	b=4Y7sEvP0CuVqsgNvAbKLz4VHcVgmpwpi0HxlF50m8zBGq6P4YJyl1kSt7RL/C4m46pEFLB
	1EajnmKOrkLA5m3FyCo7z/cnP8pR0b4DZAs/k3dEZrjjUs+52sYOVzAfed3uUcqv695aL+
	Ki/Xj+8cJuSrqoJpOTnai3M5jAB3f/M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhFRjbNJ;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ECABD41B5E;
	Mon, 24 Nov 2025 05:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903C0C4CEF1;
	Mon, 24 Nov 2025 05:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763961914;
	bh=hL+WuH16BodbGdYWuFoGGzwEFzfedl2zaIxXHQ/7Fh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lhFRjbNJw060eoWLi2/Kwsm6uYipzROQU74BjALZaDsbs2kf8nJfYdXhoSf/DhSCy
	 wcYfchkquawskyiHSEaSupeop0R3M6TiaUFEitaxBBw7fikyI2BjmqPX1TTWSO53t4
	 6k+zodPUDaiYy8SL3EcWlbQ+ZB31H3c7ylAeWvi/Dfl/gW1pESvWZmStm97TVdletG
	 tHGUH9HNWcXPe/09wKDEsH+MGWhBMfcHWA12vMSXqFifdncJOj48O/vsVhGfCxbfzn
	 QT7U2wSN0rRcaeSeOmgtIpiTwVdi/iXHGjWjcIRH4WihsB8MqXnGOoVeqTmXI/gxPX
	 hfQm1K4vovJWw==
Date: Mon, 24 Nov 2025 07:24:50 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v7 16/22] selftests/liveupdate: Add userspace API
 selftests
Message-ID: <aSPsIgXuJJvD4RSk@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-17-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122222351.1059049-17-pasha.tatashin@soleen.com>
X-Stat-Signature: gcth4d31b8fmpjk3fpbxercdeuz8q948
X-Rspam-User: 
X-Rspamd-Queue-Id: 796B74000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1763961916-781432
X-HE-Meta: U2FsdGVkX1/6ugt3JOkEylj/fHHmIagmO7oBoUTl3CDHAd4EeKU4eMp1x0mUY+dndvIViVGJwPPp+znjMVCnkbq3wDlPGyE1LQekRPFMVCfl0cwOM2gMLVEmNRz+8MLjl2XZlMy0dQy8xAJ1PtsstR7sovOV48xIEWqAqQVD7eHG2LUlxXxswvkU087g7ViUV3iHOaStheKmWe3eR7zUHpiux/bjAIQ+KggKEv1MYFpdZAZJK+mkshpquwPcQUR630To3nPflB+7LRgWtcInsdh5bJzjSR14eqgFHnom9yNQGpuj3Pkk1TyY0uuTjiiwzpBuFH/FWaIAIaIZ44JNJRDJA8JVRIeAH/Dax5thdkS85J1aq7VGzpkVUUmcFhgVEcHYCJo7T5/2V1LheU401AvDhIMoS0Np9WPx0MnuOjrMz33zffCkBqYsAOETPF8bMWVII+D0np/dFIMRxkHpr92VeJeYuL+QXpD8zzor4k8nlkiQsmb/mjJuAAD3N54acV626o+TQ36zTsnBbbZ8/hUs8dmj0ybGR646AURjq9CWn4mPZ7zKZyM3H7TNaPk4obmNTJ6k4bXubX7OuoEU1TAryZL6GmXx6l4+NMQp5dkjQwF1Z5jo0LYrG8YSGJGuESmjufzLnJtI2zy0UZPS73ddmukY8A9/g34+KJ75esbECKYE06gnXT18s2LO5EPG9oUZBvIQtcZO8N1ac+3UOLwAvprpPFqdsiFE3kNV/FGJY4FgajXGYRyg1ccqFT/8PNk/DHfiL2NP8EznNi0x+lZfX1nSZZ1PwZK99ZmZPYG4UAJtNB1Jq0fZE/Y/jcW6IZY/ws9PJlQB8kZcFP4R5wOszSz9HAV6SiDoMBo9vHrO+09Zd3fJCLD8qAtPACXTUTyUCmUodpQE1ctZywOd4OesHtsGdlyiVx+fMK5gV4WTUljCTfNc5WLv3S9WfC8sm96grX4Ey9QvjclZHtS
 5FaOLXgy
 V2bIh9LUv9aOrTabYpCSlYF7gfHg4xabiBYnVGhL1ZNSSZZrd9o/1SooRDOu8RuWfda5N+qD1b0HfULNOMh2im6cA4RjarZy8C8TpYPF1K6f7nL/LgoDv6+fcMS1Vp2XOG64i861q7vtZMV6tsfg94x5adYZsqhmiWZzYumU1XSX4ODP8EP5ZlGNgw8KBp4Smw6muiqpVc1+2se0AsYlx5Abb1k+dHxTbGZkinExmzfsj676OygoXmq5ZYroWDgBZeC04svHlQTV1XmGy35XjUMhxHjxHG2hZ+OSKPiRlV28QZxli4OjZ9RXd+rej+hEpmtsxQsLcR+hQGu/qEOD8YgQT2CYUrJpEQ1fZrt/24RzD1p4L3KxGORSs8LkJU7prBFoq2/okV0vZ2B1zsHkNsAku9JM9DcoQufvH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:43PM -0500, Pasha Tatashin wrote:
> Introduce a selftest suite for LUO. These tests validate the core
> userspace-facing API provided by the /dev/liveupdate device and its
> associated ioctls.
> 
> The suite covers fundamental device behavior, session management, and
> the file preservation mechanism using memfd as a test case. This
> provides regression testing for the LUO uAPI.
> 
> The following functionality is verified:
> 
> Device Access:
>     Basic open and close operations on /dev/liveupdate.
>     Enforcement of exclusive device access (verifying EBUSY on a
>     second open).
> 
> Session Management:
>     Successful creation of sessions with unique names.
>     Failure to create sessions with duplicate names.
> 
> File Preservation:
>     Preserving a single memfd and verifying its content remains
>     intact post-preservation.
>     Preserving multiple memfds within a single session, each with
>     unique data.
>     A complex scenario involving multiple sessions, each containing
>     a mix of empty and data-filled memfds.
> 
> Note: This test suite is limited to verifying the pre-kexec
> functionality of LUO (e.g., session creation, file preservation).
> The post-kexec restoration of resources is not covered, as the kselftest
> framework does not currently support orchestrating a reboot and
> continuing execution in the new kernel.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  MAINTAINERS                                   |   1 +
>  tools/testing/selftests/Makefile              |   1 +
>  tools/testing/selftests/liveupdate/.gitignore |   9 +
>  tools/testing/selftests/liveupdate/Makefile   |  27 ++
>  tools/testing/selftests/liveupdate/config     |  11 +
>  .../testing/selftests/liveupdate/liveupdate.c | 348 ++++++++++++++++++
>  6 files changed, 397 insertions(+)
>  create mode 100644 tools/testing/selftests/liveupdate/.gitignore
>  create mode 100644 tools/testing/selftests/liveupdate/Makefile
>  create mode 100644 tools/testing/selftests/liveupdate/config
>  create mode 100644 tools/testing/selftests/liveupdate/liveupdate.c

-- 
Sincerely yours,
Mike.

