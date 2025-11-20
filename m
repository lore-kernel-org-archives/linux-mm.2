Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 032FACF649C
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 01:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CB66B0010; Wed, 19 Nov 2025 20:03:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144486B0032; Wed, 19 Nov 2025 20:03:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081586B007B; Wed, 19 Nov 2025 20:03:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB39A6B0010
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:03:11 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0F671606D3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:03:08 +0000 (UTC)
X-FDA: 84129186456.28.0D03714
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 177E318000F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:03:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d0EiuuaB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763600587; a=rsa-sha256;
	cv=none;
	b=dJAVqiXbxKwF3KBIbG7SqHuzIip9tU6lFRvqKxMqvFm98XCdYCVvDo3xBzn7X52tjSuJ4L
	qwOLGYNIMBwIuqQ7H+W6htFTjvh5OAOZjBOJouk15FfFAOpFOAcvMrtW+2z7CvD3spiENP
	0DKkxfQ0hwGVPKQPrL+9PwnDMQ+QPX0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d0EiuuaB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763600587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1FxhRsN2boAMAQbdfFCvomkSRM7By6r+cfbP774rR8=;
	b=IX1k7CjO+juzrWmtL7XF9FNvGc14l5vg+amR76vdH9oJo0YbMIkIjDayKQsjewr7bRw1OY
	vTNCeTaW4xkhpRXtRFjPkcDNEcoCfHYtToIOklvQ5vJRZL3UnJa6g6gCIyx/AGLFCIP+th
	KYRdnMERcJjUsr9srOBiBCBVLL7QcDU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE90943E34;
	Thu, 20 Nov 2025 01:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87263C4CEF5;
	Thu, 20 Nov 2025 01:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763600585;
	bh=V+jX/8QopxdSDO6O5TNU3aEQhlUYE8ATtCK6XEKW5RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0EiuuaBz/OpXfei/3z+GvVGzAHjTn8GeJe/V4wbTymI8kxgG7CQW5bgzOyeu9NfO
	 slXNTBw5yovdT8DtaQVJBTZ8wu4Q2bTP2lzDfWD73Lqxm2fZZ4bIcawdaCrJvTd13R
	 FHUubmE24/9h/onBi6fJCZT3EJWbxorAEYAbV7eH3Ooc0saYuzGjhEa5APcFdFqDS3
	 dg3Qwsu9vMDW9yli1a+tHxPFZyOZUYGdhMqqzhIO/4xdvGAk0SRS3VztlZ1MHkcA/G
	 7yg1s/tm0TZItoH1Pu32NXu4EMgTIq/7FulmI9gx5reEeaKH8za0LIHLZVg2bLx2u0
	 eIxNMXBYDlsQQ==
From: SeongJae Park <sj@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 0/4] make vmalloc gfp flags usage more apparent
Date: Wed, 19 Nov 2025 17:03:02 -0800
Message-ID: <20251120010303.74537-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117173530.43293-1-vishal.moola@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 177E318000F
X-Stat-Signature: jw8j4c9hs6xw4tz7x9toapcokwmwkmgx
X-Rspam-User: 
X-HE-Tag: 1763600586-660437
X-HE-Meta: U2FsdGVkX19HkdebZKH9xuGKsfOaUk9NjH0UN0vg83Q2S8CQOHZe5pu69cPZe+yrPK7pzNLctZzvlBq9BmjR4u/jo/l43DKEjLrSiG1XiJ3eKgRLLefU6Y6b3GAAWXzoDHQ7/zCPhWfrQg9iqQGYWAgxWAUKvfrFxL4mJ0M43IvD1R7eTSrkne76mh97iaUnzkAC2evwm77MCTeYAj7YiddIfPFSgHK0MHLsCQ6bHdlqXa+DPDI2qovWN0YzLIJgZnY0qVmfhtB04xjM80vEeWONDwytdr6drhx4LRjWq/o7Y0etltkYW0Adu+ulDcOnlG9l7s6ImILMflMcRGdK8RpB/WvRVjFGA8ODj+zahX/6BKsMz357CGFw9wz5LMbyiH0f+s3uj4Ae0t6mrywZOZWl0Ztw+kLNnEbHzpImFJl59SSqR9LPOl81/rp/v3rlErFOkWqYdQkVQRlgjByQNd2y+pWSv2PX5bX52ScXeHN1NnlR6TJT52kTkfC83b4/UmNCTgYFS3WLP+Ur2GfZZ0/s9COw7iNtL8HS6tI4XWlr234bDVR5KTrEMi2Klf4asiMJByAgj3YvIFt+m78CvqirQ+Np1Nkm3rWce2DTiJO7zIOgfTHaCUiNQYdXnk432xIp19ZG17tRlhRwjHmlLUlnS1h77zCmdB6XmEQvV8rFSoxXcmc1xBOoaNc1Y4P0oVylSRZc2iuTWZ938UBRpNWaGdjQGZg4Y2bGjWVrMM9NP4rSzHUM0hALfEwPfjoCn8jhLreZylw/o7EHFHYn6QtvhFf46aBrcgnJQMuQRpTjQKG/lIqlT47H+CIGw9C5e19ipBnJsTpA70WrBpiD5AM59EwZFEFD5ZpixnyXa9E1q8BrP0c73ysDsbCUFi6erggSluTaDvRvzaX0y8Xa6yH0jbiltgSm4P+7qYTRn4g+8hthbffuR3QZazJQXCWveEdsIxrHow0uL+WVj1H
 mmCGf3ZK
 dplHOI3BbfnO45Tkbyi00nrj056zZ+KmjiF6RU+dkkqoqgerkz1YE6vMS4Z7LGLcQKd5PZyKp0UtdnYal2nth2HdtlKFzZIoRwPe/MB4+REdxtxudEAE/8+1f6zNhuRf2FAasscK5FoOvwbMfI+N8Q4sW2nqviE0acTXLCHyaeehvb3sffpZMvUMJhYJiiEk5V+fz3s4Ko5/GuAN9kGeDaXeDhCQyqd/nGIDNTJiAx7rM+1FMy6vk6YchDyy5RYPoTEZyCSrNuPsMdxydlkz210vdhCXPKjreZ1DNuNNu3LNqv9StX/I4F5Me58NBtn7ooNgRD3hIGPBuydg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Nov 2025 09:35:26 -0800 "Vishal Moola (Oracle)" <vishal.moola@gmail.com> wrote:

> We should do a better job at enforcing gfp flags for vmalloc. Right now, we
> have a kernel-doc for __vmalloc_node_range(), and hope callers pass in
> supported flags. If a caller were to pass in an unsupported flag, we may
> BUG, silently clear it, or completely ignore it.
> 
> If we are more proactive about enforcing gfp flags, we can making sure
> callers know when they may be asking for unsupported behavior.
> 
> This patchset lets vmalloc control the incoming gfp flags, and cleans up
> some hard to read gfp code.

For the series,

Acked-by: SeongJae Park <sj@kernel.org>

> 
> ---
> Linked rfc [1] and rfc v2[2] for convenience.
> 
> Patch v2 -> v3:
>   Only changes the whitelist mask and comment in patch 1:

I'd suggest s/whitelist/allow-list/.


Thanks,
SJ

[...]

