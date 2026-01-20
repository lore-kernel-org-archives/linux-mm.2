Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E4ACCF2DD
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 15:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73636B0444; Tue, 20 Jan 2026 10:49:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3DF26B0446; Tue, 20 Jan 2026 10:49:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6B1B6B0447; Tue, 20 Jan 2026 10:49:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C38D36B0444
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:49:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64BECD2401
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:49:24 +0000 (UTC)
X-FDA: 84352776648.02.C2C33F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 95BD0C0006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:49:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZXYUZUgh;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768924162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sedTFGR0UIxMIY6PBuudToOLvbWS3cx6h34dkkTHn1A=;
	b=IzzaACIm0jFjQG2jJlHwJrS6ehgBxIYt94Vlf3zGwXTynGQRKxRJBByd6+IkSu48/jfBqO
	clME7fBC56phVCucPvNZSglHVXRusqgGxutRh6tjUlheWpIz+uOh6yt/DxyfFNawLcX1oh
	XwXxFYErfkpgKFfCaH+esRhH44KB1MM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZXYUZUgh;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768924162; a=rsa-sha256;
	cv=none;
	b=n8VR6P0Bs8+dHPqdSvf36ydKai8mZu/lplqWEGgNZ8QnFChsunrR8pK9zpZB+FUpq/se+p
	ln2Ffix0J9HGIXJcATGrLEF5aDlobgeOhXuVI66GozDemP6jfMyHaNYqRefhAZXX1mqbX+
	quCHxoqk8k5ickhOaO5m5WiHJSJOX4o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DF084436E;
	Tue, 20 Jan 2026 15:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645B5C19422;
	Tue, 20 Jan 2026 15:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768924161;
	bh=Y/AbB7KgatkBwFOqIeCh37bW6yqZKTt6YIephjTthpE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZXYUZUghgW6RMboSc06ViBc7jvzZ9CGg4hucUHqCbYExeJE0/Hvu3Tk/xY3EewL8h
	 75PVDNC07Yw5qzGqyTG0NRtfrBvsWL7L7lugWh1Ewg+Rz7ep8WZG+qHc55M+edrcM2
	 5KZd1kW90br4dzAtum9kF3SgS4tDj8zqGQkmhDix3v37vHRymhdgIY8ZI3lJlxxYER
	 HskWglueLRn36V8/lAsy2MJhJxi+WrU8Omo5KHKgXWjfP/a6LxY4Y0CZOSoe2hVgia
	 NIaj3FaQEv8+Z/tZD0P/bLVFMn1AbdKmvvPjukxiJnE4LhckWdiaSc9TXVn0Ng2vU5
	 PWDIltP8LEeqw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Jason Miu <jasonmiu@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 2/6] kho/abi: memfd: make generated documentation more
 coherent
In-Reply-To: <20260105165839.285270-3-rppt@kernel.org> (Mike Rapoport's
	message of "Mon, 5 Jan 2026 18:58:35 +0200")
References: <20260105165839.285270-1-rppt@kernel.org>
	<20260105165839.285270-3-rppt@kernel.org>
Date: Tue, 20 Jan 2026 15:49:18 +0000
Message-ID: <2vxzecnke135.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: qe1g9z841scwwqeruc8mmd6ffbhu41mr
X-Rspamd-Queue-Id: 95BD0C0006
X-Rspamd-Server: rspam04
X-HE-Tag: 1768924162-836314
X-HE-Meta: U2FsdGVkX18Hm9tbMK+ZhHRCvyO8MCHNdZ0A6GIVS9R5B9ezWLabRqrfm51V05dgv1n4VYSupA+ASzcOj/DcwgIAlXO2foFFPGe7oNoh6kzcH6ibHUf1C802XXd5jlHHxrB8LGo5BdXECrPEJt5kXfks53wDFN5M25K+PomLc0T6ZeJgHVGhPh7oM0LZ6SJC3EjUFkVKmldpi4WaDpnzSRWX2KO6Y30qFUVTKGL6J6tkb2yq5ftFQI7F3JHdtHsYep/sbqlPYrHSMtcxQxHp9P2vOH7p49U+w1ub4JX7lJgmNFx5XUpnKrYpfM6jZY0PQ6Unupq5/1G0i0XC8o1FY4IrS7MRoRtBoJctew+Z/BV6hXdi1cebJwTTsDT8BC9PFF2pAPSFR2Bdzhl5nCL2exx4PM7b8Tkh36Nlal9hhGpQHgY9f+p4kDo7ujNL41/mrbOJn0sAAlSsbKXy3cfsX7b2/zPayrjNxDqRm9qMRyJguKy5H3EynrLo3zKN7GEKulklvgGvUnbo5H6q7mbWLpEilDOsEkXuiOFREfokoqgUhsRRD66iZ6ZOJ0sEAcJmcTJ+i3/wFDd9kA17oyG6+lGFjc8pKdEs1/HZB//yNjHEyOcFsgPKxXmpBPWhzr0EYQMKZGXFJzQByB4FpTLydzURviHBWRYk43RlsMWRXHvJ8RKxNNkV7pxZYYDeR0Mo4oWCtCHrY08l9Nia4HgpWwXcL/5br+jZKynN+Q+e6w9rFboNpzZEFj3vHC/uT9XvbcxUZKnVhixkjQ/UAGbjJnNBwZT7v+CPwclLq/r0qHM3QZSh2m5HZjqr8TYxaaYAD16iQENZ2O4CITWh8JFNIssxv4KU5TbcYO/bw3Shiug+0PfhXrJMjDSmWSWNvEB1SezsiLNjEy0BVkZjJsId93c6Dv13+SUfhMYRoMzZUzWiyJKhn+D5fNzFjGXLiD0gfoJGi6xE73LFcmlQ9De
 GNZv6YjM
 2IGnC2Ku8EoW4gDswsyMD+Iorbnq7HWXsNKpqjJ2SsPr33Dab6HfRaeITb6b8ITxh/iS5GRleAShLQeg2YD8++rjGh0cJQGaugKgneR/ODOe5HP0tbaEfO+aGWfwf1E3D2GaC627A1wKQXNnEX8VuiOL+o3AKXBveQPB+I4NbMRaOm1jfQxyfIHDCtbNw4nfFqB1H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05 2026, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> memfd preservation ABI description starts with "This header defines"
> which is fine in the header but reads weird in the generated html
> documentation.
>
> Update it to make the generated documentation coherent.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

