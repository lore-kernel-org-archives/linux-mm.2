Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C37CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39F18E0013; Tue, 21 Oct 2025 03:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10698E0002; Tue, 21 Oct 2025 03:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D5F8E0013; Tue, 21 Oct 2025 03:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5C288E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:35:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 893E01403B0
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:35:52 +0000 (UTC)
X-FDA: 84021312144.17.53CE345
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E3A4420004
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:35:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ZF3m40Jn;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761032151; a=rsa-sha256;
	cv=none;
	b=gkhoxFlDhAbKBrWNhCF2sZKmIDN+Va7w3Ao7NQLqSigo/5C5ZlejmfnwanijyTe9kHmL2/
	8L7khaLx7BQV5D/9IFf6FwTER2CrlWJ4wqAr3paUDIlzirXvJHrm5d5Oa5ADn8yqcA3Z2r
	GLe1jsJ/bPQonB61Rz1fjbTcgTk+bnk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=ZF3m40Jn;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761032151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7B4EG+GYERNCpjX1n0M46GkpBfwPZdXIm4EbDU6ZSzw=;
	b=2TpeAmnGTCMDkCcQ99nB8qda1vkuDI7GDEGJhYJDNULESoC2XaWMQj+sV/J/dXwM/HH0Ya
	kLrWUeYKBmx2r5DVFPpW/54q2Q19GaQ8sk9LpjrLGacut/qmk0Mvj0qsi8mndoG7uQdn7d
	eAa6CNPb9uipbSxt4k10XJj2rx0cm7Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C703A458E4;
	Tue, 21 Oct 2025 07:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296C3C4CEF1;
	Tue, 21 Oct 2025 07:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761032149;
	bh=X7cRHSjXRGJM7wUbMm04IaWm8HIAEs4IU/+DZbQNmmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZF3m40JnrkJq0Zzlrd/gSWdkTrS+ITLiIJ3P7bgYMqVPXjZmxslmq6eQr0R+IjNVK
	 zFgBRM+8jrLmktKUGfCZLDORZcoyLGjuVDE1ufeVf0dvCe1wWXfFIZn2WuZ6HaYoMN
	 CncWuoeFy18c5UJIW8HASO+lmdYsqxmBBotPfVtY=
Date: Tue, 21 Oct 2025 09:35:46 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Gabriele Paoloni <gpaoloni@redhat.com>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	safety-architecture@lists.elisa.tech, acarmina@redhat.com,
	kstewart@linuxfoundation.org, chuckwolber@gmail.com
Subject: Re: [RFC PATCH v2 0/3] Add testable code specifications
Message-ID: <2025102111-facility-dismay-322e@gregkh>
References: <20250910170000.6475-1-gpaoloni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910170000.6475-1-gpaoloni@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E3A4420004
X-Stat-Signature: 4dp47ram348ga7m71gpo38mm4oc8op1n
X-HE-Tag: 1761032150-435848
X-HE-Meta: U2FsdGVkX1852DkpIU8aA7juTqgAp3oQl10f9QhoAMSVg7lXDwUpvj4YKTPIx2lpMJuYQImMmW8egSY3Imm9AAM8F75clTl9SaBGwkHxmx8d1MG0CgG0vFwriv7Kl1jp/KuPnpVTOI6BDTK0UF6DdloIS9erxcq5UNlww1Nbj1OdsW4JWqFewD8BNI3Cq0Z5S7uVlu66LWMKEwyJDZeFgj9LIvOrC36a5SLTWIK0+DkdPqJJs1Gn71zZtfN4XApXZ8sCchrkyvRbfvdt+spFlskRYvgog2e0O+UC+xbfqBDUhnvdH5t8sxtc0m9fsNCIPBthT8Vlg09Ib6eI+ubcVJVGS0ueZd8DnMGbWTSaFJi7kCYcNYSIQeT/nn2WR332YALBTpJAQkxLf1awSuWm29EN4MMxZ9TQwcn0tWoCDsTS5gMXWiAFLcTINFPnEHxnhZSxEeKCC41bldENMrlYd0R86bA79dgsCt2Yg7EOANgKoiBh6+WIAhRQuNankX+ZxETwyIfM7Z4SjXOpwHSS+TY93aZGJyXZ+rO3U8XNNzKdtvPmHh+Amnf+8POzbmyTA9KisWoBxgNlM1va+rndVuStKWqzVWelValgPTCMB7osDIIKYzEvSdMTqkyOA6NKLLFsqI9BVCBiCpm+dD24y5I+lpx/50nqGZ3Oe39cPyPtqZnMYs8Hv8U64/5/8uFip/AXhaTdvY5KVtMu1eXfduHFaUVc9fPnkCiq3bdNmp06YTvconcwYUbMRULjDo84TtO3OmLKbHahclDlCkuWxzNNbjdrW0C7lT9PxXoNbuf5XA6V8RjLafsAYc0nMR+SUOgZF1sXZ5FkGjJ1dzVyOC+Bi4/094nTf3nZhhbOcemFk34DDRcQlmLn4lhoYuO4nfNDEblFcD0hkq6KFUc0RrhSut3zzuUuRofc5iW1X/BjKCRqof10vxa6BiU8Gxhooh4CUqmByW1SP4rhjYc
 NVuSZr5j
 CiVwHo9nb4fE1h9gBZTOAFauPEyuqHBB4OrGX9n8TTX6XJr7UdqbhqcGeDed65/TjK4T2k+txfGIVKFBFEEn7bNSTw+xFW2maZ7NImPouUNY4NKzHMlPUWSGWAWzTlwu0bE9y7Tm+aTNOaDIlneOaj5179EtrwPNLwFNCA3cxYnBvV55ZVF+SNB2k4KIgzcQjDmahlZXMxHADdhK8BVUtfTL846jWb4W287dJIvXUAzXeBbM6Vx/RoUqBxtWHq9+4BRlb5h3W0BhpCyHt2gaV+lhn9zgAp1EOQI5g2lnMk52MbhXUTRepsr5yIieHlQ5/OFOZ9cQFsHaFjynZyV+p4OGtKf8wjODqWt8UNJmoa1e3BhF0gkdLDervzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 06:59:57PM +0200, Gabriele Paoloni wrote:
> [1] was an initial proposal defining testable code specifications for
> some functions in /drivers/char/mem.c.
> However a Guideline to write such specifications was missing and test
> cases tracing to such specifications were missing.
> This patchset represents a next step and is organised as follows:
> - patch 1/3 contains the Guideline for writing code specifications
> - patch 2/3 contains examples of code specfications defined for some
>   functions of drivers/char/mem.c
> - patch 3/3 contains examples of selftests that map to some code
>   specifications of patch 2/3
> 
> [1] https://lore.kernel.org/all/20250821170419.70668-1-gpaoloni@redhat.com/

"RFC" implies there is a request.  I don't see that here, am I missing
that?  Or is this "good to go" and want us to seriously consider
accepting this?

thanks,

greg k-h

