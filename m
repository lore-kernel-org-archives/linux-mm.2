Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBEBCD68BEB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 08:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443016B0088; Thu, 18 Dec 2025 03:04:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F07F6B0089; Thu, 18 Dec 2025 03:04:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FCE56B008A; Thu, 18 Dec 2025 03:04:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BDBF6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:04:14 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B06F013C2CA
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:04:13 +0000 (UTC)
X-FDA: 84231853986.25.A1E2C85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 070A114000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:04:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ScuoED96;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766045052; a=rsa-sha256;
	cv=none;
	b=hpn18RgtX+jmJA2FPZvbEVHH4L5MKCuqz9QsBTPneqq79uxAX/tSFbMKKB+QmmNwDlR2dy
	SHIBiYCRCKyCnsWR1LZe8RFlZEd28Gxp5ng/xPnQ8K4C1mNJEDfLDh+D3htkWgHFqRc0ZQ
	b1Mtf1KLL0hXlS8bF6NdqaTQXdwraHw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ScuoED96;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766045052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cuWpJ5wSCq0EIudCwf5u3hR2vCSQ4dXz1kxn0i62oYE=;
	b=kMQg3f34ZK2VopTOg1hy7fDTvi/VMUJaomlC79j/jqNFLMgUgRgJEU4IFg1mMjxtvCnYEn
	Re/qL3fDzZBINnaEGbhFTxAqilhkEWp8PsrVv6N4/2sROKmpFfu1T7UUL/aK3AY0TQaCPA
	oqeC5g+dulqgojTXsmuZOhOmKB35qHA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 66565600B0;
	Thu, 18 Dec 2025 08:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8893C4CEFB;
	Thu, 18 Dec 2025 08:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766045051;
	bh=P5j+XO6ZjaENjKuewLksE3ekOUwMU7DjJUpX/8fUNP0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ScuoED96KlGLH+e9ca2TdAAkZ2KycpUFFJ/O38GUWklvk6tnVbCBdGx8S2Vb30hhv
	 Zf9b8xtlWa0Rk+w5l6h3GAyJCNQlyJHG6e5Hh7YTfJhaz6roIEfXA7RCjrsaKMWGsT
	 UCMdVRE6a0PI/h2JNy5R7aKyaIA5P6rbX6uKE5He4A7pthdfD9KnQN8TCc3vSp3X/7
	 WQfxRQJVdoGC/8gncvRhLfvqHNvRY/fXo+sYIhjwUm/HPle+gkgh+oSYbZac5VaLnW
	 H9I7sXYLItuHtAEFrLIf0lPR68ACfIpzjKGyFXOcbKq/O5yBU7TTkKlOtNvzjq4NRk
	 fSKEpO/OYzA8Q==
Message-ID: <0d4e08d3-db9e-4b0e-8229-9e7ac1b58708@kernel.org>
Date: Thu, 18 Dec 2025 09:04:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] selftests/mm: pass down full CC and CFLAGS to
 check_config.sh
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 John Hubbard <jhubbard@nvidia.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-3-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251216142633.2401447-3-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 070A114000B
X-Stat-Signature: nezp8ympk5kzor7gurixoa6bkmdtccss
X-Rspam-User: 
X-HE-Tag: 1766045051-341356
X-HE-Meta: U2FsdGVkX1+eK7ppHcDIs10Uwe1j4QcdwbmwLN8hEao4zaQ97aKjx1dEFTaQfYtXHlDz7FI4zW6frkevPQcLT0Wg1VJ9itAK5+xerbVePS/1fy7EPVZJ/gQcZqLmKfS6lMqqzsB0wz3hDv6iYP5UxTCewXlwm61q1AUiSPIKKUXny1ZNfVyHqNPpM29EhXXUDEB9vGw2fgzI1RqgPjxxn9zOVPAAg9QqtYbK4IYEKltMUw15xvFjNFk3vR73VVCQsmEsTKGg/Ixn5JOb+TCVkI+/2chXrNv+ufgxzEpV4wBN/6m84ozOv8z0l0uNuwJowgkPCofFZc2wqAD03Kx34k7ean1jIXaczpwU0l6sDdgZyE+iA6+O9+6iohJfj5TmU6m0rigXvccZKP3efxo7YzvSk+tMh/kaTi1Mz3YWv49fNBOVfmOus9Z5SErxPVdk/CctLHRx9Pn8FJHwRw26ap37MvS28jvPThkxuGjAvptlVEWmbrE1vzsQC6MH3XVcOkhlWsb0LgFWKEnYRqKUvpSlz9HEb/mKkJLoTNMJLb/tfqtQ0vdoNTsUEl5+2sxXypt1h+rJiUkc4uGP7MgXQBu/4NoFnF7DR5XtrCx9kRTIfKa3ctzWMBTzxbN6C4OwFIu9GPWlOfu/sPu9EB3UZBh9YlrR2e5RI9TrIO66bbRJtjSp/EMm2wTp5EzVD9U/Z14YpYBP4IVj1wWjBAUCY63pQdUUaBTdV3SoNrngusL5+14XrvsYRnLLNv2FiRDcxe32ivPTvm0d6ncoIJzMyhq7dQ3DGwEIxywKGa+NvezTAiI2KFrRvCLWqS6wKG4kMbReD7rkYNdSQO+mnuXuDtE31E8zFRBGnr7RyfwO7/ozN2kQePLx6EKKHim5XC+vcs4GtNNQ0tP2SnYd/Tlo0xxb3lLcnYMEJfQUYp/UIDFrCNCY1Qk0+Dna5tdAO6nqp5sWvt6ZT7WvYAMmmz0
 9IhkeVbY
 tpNKCcl4KDoWozIeeeMQdQzKxgmHRtYouu/usp5fRcfM5nOblqNllVpaARXgzC0dP30fffbTG/7yczdprxE0V6I6srmI+RhNIOma2GrRsixN5IPvU5C3WIBCaz7EIqIGafh+0i+58pWFd1azcrAJqc4xNDknoGS8DwYHi6ZftuUv73batTgOloV+bZlByw8E1aV+AvhlrMyHEWYLoffgpJZ9mPZDhmTZWyApmT6bqr6Xj9SeGRZjep1He8vTURoRQAQnt6DC8enU3RnVEgomM+lZJjNR08XLCIEz+a30FuJn1gGCYOBJuqGmM3Dzl6QHP19SbnS6W+f2eLTAmZlxF7QnAayqZpz+DktFcd+7iIdR5adDkYCZs87bLcN8Q9ER/3BCj8cc5GtriAkrDwP5kgDe1W3YOOSPNhN2ita0MtUGrCFFC8eyCC6yTiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 15:26, Kevin Brodsky wrote:
> check_config.sh checks that liburing is available by running the
> compiler provided as its first argument. This makes two assumptions:
> 
> 1. CC consists of only one word
> 2. No extra flag is required
> 
> Unfortunately, there are many situations where these assumptions
> don't hold. For instance:
> 
> - When using Clang, CC consists of multiple words
> - When cross-compiling, extra flags may be required to allow the
>    compiler to find headers
> 
> Remove these assumptions by passing down CC and CFLAGS as-is from
> the Makefile, so that the same command line is used as when actually
> building the tests.
> 
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Looks reasonable to me and I hope we find no surpirses :)

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

