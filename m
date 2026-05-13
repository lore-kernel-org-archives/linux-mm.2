Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 439A4CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 18:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB396B0092; Wed, 13 May 2026 14:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C1E6B0093; Wed, 13 May 2026 14:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9516B0095; Wed, 13 May 2026 14:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89B306B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:56:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2947A4042E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:56:27 +0000 (UTC)
X-FDA: 84763302414.13.A81C9E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A8D8C140009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:56:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W4cJmax4;
	spf=pass (imf23.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778698585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=3XP7+1gvy2nvDpa9N+OY2Ze/EP0gzbGbM4YUZdAwdQ4=;
	b=ROEzDYXycPFr7vxkoctFIaVMAzvQgKThPCbMKGWv9W/lHiyua9zVveg0ur4C9MF4qzf5Ap
	NavhzsT6XvS34911HVxJ25aMlORJqUR61lGjNBBPywfxSTylFTHxYoPkGkPHue5kv0tQM2
	f7s/1BXvX50q9bojfs1hbICvkiMWeHA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W4cJmax4;
	spf=pass (imf23.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778698585; a=rsa-sha256;
	cv=none;
	b=5btZxRjgmIeQeT38bSyufFukEqaP1BFg87XU+Km5GWU3gAvgKaFFaUy9w9aJiXrgTJ2JRo
	2Bkse4ZbaLMlveyhlj5LDgmE7ERXXU2IWuHDIEPmzCTZww+r0cuzN+MyPjQZMhPQ8QpHb/
	JsJ9jp8EqpdiMMFAwkYCBgrdOra2TNU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17030600AE;
	Wed, 13 May 2026 18:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96670C19425;
	Wed, 13 May 2026 18:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778698584;
	bh=wTrLs54NJavpihFJmz9gK6TVNlsv2cRsIBg7e41SG4M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=W4cJmax4qpCr8ho3QRHfAOe9TTwxw9iQ73o0MaaFEy9bfV/004IBLkaxRKUmXLZEH
	 pz7AdgKC0dZ+BVFFP5eeDvim+qPfjK827wTfIq4qIe+iNPo5GjmukJNuRKCk2YsftL
	 bSMtsP/yIAuDAWiHrDcOqMQ1YqYPEBHQ7P/uuOZx+tHUxPiUWPMUmFu5FwrCkV1Hxp
	 3drrm6rmlxXgvXqWqyKUomSLaLWZVs+9QKAti2iS/Nts8H/vTS8BqWChGDOnEObfHK
	 3uciQ1ixgofA17q5nmX1VgQGFPeARw2gzQWZcs05Rv9fCRDx0Z4dwxt85zp64IPMBI
	 k7i5M1FvIxwag==
Date: Wed, 13 May 2026 08:56:23 -1000
Message-ID: <2b655b3d0a05c1ea21f39d7b10694ede@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yu Miao <yumiao@kylinos.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: Fix error path leaks in test_percpu_basic
In-Reply-To: <20260513023907.179097-1-yumiao@kylinos.cn>
References: <20260513023907.179097-1-yumiao@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A8D8C140009
X-Stat-Signature: mczid1cqw4hbyp85tc4gb1pbkptwg93h
X-HE-Tag: 1778698585-911595
X-HE-Meta: U2FsdGVkX1/tFoVLAhpXHRgABDNYlLqS3fdoUbjDQLtvWFkZTaSuheDssUayOFV0PIdzzzS7/TzVezqREGjgPaivDXrLcXChdekGVu1aar/onTcc5m3BZILBRkqyDm6hUnK/wTyhokgrsets4Rps8mUZAQcCevbwV7ophywYSNIjH9y6lTXO4XB9PuGTfYqZ2hZjp3wda+rECfiZl1ZkELliScup+kkDlF8e7RXqFc1eGO6TxsdtA/PKV6ILMDkpvmIvvNZgFvnu4jPZJmJAjhxFcz1CFLDqULnn6OhAJYat3khCH7xNlEyZ9apRE7StQ7hH9MvLxknczVuVa8GQQokFUtA5GvXgaRNkHyExpQJJXMzhpNIUfuezcv707CNbR4Q7M3TnAJ25oqV7ISWN6DFcF/+6DGaQXVHSbJZLoZgEPV+IgTErqzdvddIg2n8USnifwlsDeTLUPVuGPXrblwHKNp2MN1cIgZ7cqxdA6x9v9/D/PSivYq4Ldyj5EoALnshoGx1/KXkcRWqC7d821395QVwZVYhtNx9i7hfzEVIEv2edtXsSqXi1bCyiNiej5a0hhHRGKVRODzko8dgfKxdXcpEWQFIbEphsAFei2km8vf6uHOaBbw6YwL+F8VPHuITb9hTpypkE9ngCZ/vFKiMyoHGytar4VvKt0VtdLKLkwYRBJqd2Pym3i8MuRZN+vfn4QeMiX1kVnvpNFeweedTz0W+itpVLRDhUNK62G+A7CuUUOI6/sU4dP0KZZpDn5hIB602kqavsAAEWEY3l125uZSKGTd/wsW5ET/0lbHvJuRrrFsW8yGT7BzsZDbJ0WtB81EbpI5GUlt8Mjk5MbSzpJ+reHNax6siUGbd8lUKT+yiaE8j6MCwGl1GBrtZPkT6lb6ljAZH7BMT+FH6jE+ewTKzNSOc5THOcuz/b+VbFMx4wATIn2Dq6jw3VolBDLI6E7VRAHNSKiRPDF7f
 pz+I//NR
 HbYbS0VQc+r81U7rsfySHqtsBAeJdfDWKYSAwxyTbdSkPmvfcpiqXThXwzD+RW5fMzWLQpiXC6jT87a+nSoIq1HUXHgJJ+YQ+Ltdv2w6ZJkAA5sy7GRWSB0N5AAM6/OcVGk6oZQDqw8RoldcM6J2WgCyyZETAJo6PlGSi4ugqzZ35+tKRUiYdJuAcx9dqWGM840h/BUDVvD0hEqYV3LUCiE1SyRgAVjo8JAoyzmpTsSFbFGP4Xz3w1f/xkzdGkPju6eT1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, May 13, 2026 at 10:39:07AM +0800, Yu Miao wrote:
> [PATCH] selftests/cgroup: Fix error path leaks in test_percpu_basic

Applied to cgroup/for-7.1-fixes with the following Fixes: tag added:

  Fixes: 90631e1dea55 ("kselftests: cgroup: add perpcu memory accounting test")

Thanks.

--
tejun

