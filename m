Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FE25C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0F66B009B; Tue, 22 Sep 2026 04:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561656B00AC; Tue, 22 Sep 2026 04:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49EBD6B00AD; Tue, 22 Sep 2026 04:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26A176B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:14:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92D5EA528C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:06:22 +0000 (UTC)
X-FDA: 85240665804.12.4CC6F43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 015EB40004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:06:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=boAuJJId;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790064381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Zqym6D41lbWl1qqdDfB+XAdzgeIh7z3k+GpUxiR+8U=;
	b=JsSMxGPYDkj+b4sZ1jIgJb0RUJfeo43Okt/E7nTyi2Tz/RFsR67ogX5jBhZ3y6B7ab9Rcs
	1+tun3isI4R0yocCnVJNgG3isEbBBkvASEPonN4OIaokhUAmXV+/VVx/Ywj7Tm/0Zdw8z1
	2QKhslEwF47ahc62jiD+jztV4h35lZg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=boAuJJId;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790064381;
	b=uEgT80oUM6jclFBqlfTovlyO1iU04l+dFcMvkeFsPopOIULQ4M0/qXM+tRKLvCV58hMDz/
	iqaJd6c9Ar15R0yZhxVRh9Q7P6cS+3//Co8E+r3+TDmCSigga9A2bx0dmVNmT8YMkfTqRF
	mqC8eWEBDVANZvm4Uz3TEKmrztNUVt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 676F943C12;
	Tue, 22 Sep 2026 08:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268441F000FF;
	Tue, 22 Sep 2026 08:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790064379;
	bh=6Zqym6D41lbWl1qqdDfB+XAdzgeIh7z3k+GpUxiR+8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=boAuJJIdMAD71oRg7WZDTWVjhYholDntby3vKk/sx5VujBDV5U33SMA+V+QJ+C/bd
	 O04r5iqqH5hp4mir/9Jza6f/yC03jXf90hmAWRlW5Cs1Jv9qQXO2o7k95+J2KrQ7Ok
	 vhvPF+6d+UvKA8eBcUWUa8hrAO+xkf1ZhAJfWVEXaTSpKqR7Vn3tqKLz4bnp11TlMo
	 dV4aNrLLLbZcoTrqXkOpTGezNtyqtErFD/hBNoxFJ2z7huNSbBivcKv1PD3fI70fX/
	 Fb+B1OlWB9bUz/xPLgbMTG1s1X3YNZgACspNdfNMDsZQXM7FaY+1IWSuHEvBZRbBPG
	 A4M2rJqKOew4Q==
Date: Tue, 22 Sep 2026 09:06:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Park Tae-sun <ts930@dgu.ac.kr>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: mremap_test: handle ENOSYS for userfaultfd
 and add missing newlines
Message-ID: <arI2yv7TgtJLjMMr@gremlin>
References: <20260922065143.118702-1-ts930@dgu.ac.kr>
 <2e0a8157-a529-4355-bd7e-11ef0234b825@arm.com>
 <179006158019.123863.10328178989374348836@dgu.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179006158019.123863.10328178989374348836@dgu.ac.kr>
X-Rspam-User: 
X-Stat-Signature: upcmrub468r56xdpgj4itkxz7b7zzse8
X-Rspamd-Queue-Id: 015EB40004
X-Rspamd-Server: rspam07
X-HE-Tag: 1790064380-642120
X-HE-Meta: U2FsdGVkX1/6WRQPFlTudabjbsndSgRH+N5+vyrQ9QBAOjc34Bm/GjPZV+RPd+GpfP3WEFCu/H86ynudfVofFCewJtdXHE/kOIL2SoCkyFWLHb1DUCyCmk/sy/gZC/ynRZQU97KwSZnWGeQqdCm//G3asS9eGiZZBwggrNvz9YqRdlRZycixWhvotMmEaPMFLFzJdgHZCQjUYU9LIquaXdmSUFmc0VCbZo4UPyOqxAjtRu9fMXNWMvwsosy794atuzdUd2XKSRSIZPJsUeH2RtMWnk6y/i/qqs1+nOG2xphGgGfIHU5ZBgahPSLEfrd+V0ypFAH19PW+wcjgOKfOs30dty9S5DXJIytXx8qyEvZZpC8jK/AyipNSeF2YlxY+Dzp+zMSEC83kSERf90MQd5i3dqdc+2bdFHQx4SRODZkh1OAQrY++Ajg5hUeHxXVxWOsXYKBpXeNiqkffnk/3YxpiktVNbHh7Fj+hPwxYZaLLV3wl4F5/lguQao1brkP/hGMdjaNHu3fdQvVvPd8wPnmzdsXfNxZrx3mH9eC29T+6Tgg9nFIUgWZSTIMdvNFMLn/Nsp1FrOep/C48IFcijAbb3GLacnVWGbysHwN/NFLwI95ksHyenP270oXpQFNWgKX0nPOgFnZCLXqXTcKY9bVo7sSSmHu5vRXzCm6PyVwDFeb9IanQqeEthukOzl+iJaC8LIbQN0F4LkRGmwDhMLq/gHa79/mR0rY++bz+gb39cJF1mm2vYoErVV6Y23b3FpZSPgjWNswLfRMBNYb6VSGDcMnZ0nttTS1FjUTdXj7fZxrAx5J69ijH6WE/+4U22XfcNfkEgxRRPZUXYY1+IJq2hMoNUsztrN3ATiYpwEcyYejoaOqNXQPS5Ukq921+YChrRs3Vxq9a04jsId2354N8ZEn94hBbFL6kP34YDwdmhjFSC8y5LKRuAbibsfjBbfIqkNAjJRYo2jo/+d6
 PuamKUkd
 O1o3F5Hv0DQ5ew2kkr62qf5jDNX7JIi3uQ18jxLEnpA8e1a2HJyWQn4n8fK/zQIbrn1C1RmDqoGlgyz121Z/o8U50FeTVwLxSDR28QwhAc1UNfJ9WGmIKPudYi+KvwdSq3S+VrN/Y1KdZMQK6S+uDJQw1TfiewVjaaEXnccleHkWsGYYfzWnjM5aW3Dk1DdlXybkztuaZH8yT+pE3NNCkOhfJ+LBRNoB7K9F5tVaIHijk1VXjdziduUrYkwpLoO6nTYWXZXXF8aKAArZLm1x2wu5sicCGejdsXE5ojOvYOWekvKZBqtPlxiwhI+uEfG7iy06omPDeg7gChOg1/6xWHoh9ko44n6LVXLyZQzfwlI9wHkg4v5vNNpAXPl2EnJkEy9JfM3oWKqGpdfqUw8FLx0kKYfUAqTjEKAkcQxWPpzVELRsM0pbk09hRvlgvs8V06ey4vlNXIG9y19gbdjoaVgmLQxpmsGdKvT8k9ypLFhOYGaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 04:19:40PM +0900, Park Tae-sun wrote:
> Hi Sarthak,
>
> Thanks for letting me know!
>
> That sounds completely fine with me. I independently ran into the same
> issue while testing mremap_test in QEMU on a minimal kernel without
> CONFIG_USERFAULTFD, so I'm glad to see it addressed as part of your
> larger series.
>
> Feel free to add my:
> Tested-by: Park Tae-sun <ts930@dgu.ac.kr>

Additionally, for future reference - you were missing cc's.

Fixing this is easy with b4 [0] (the recommended way of sending patches to
mm):

$ b4 prep --auto-to-cc

Alternatively, you can use scripts/get_maintainer.pl:

$ scripts/get_maintainer.pl --nogit-fallback <files-or-patches>

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

Specifically, the following appear to be missing:

  david@kernel.org
  liam@infradead.org
  mhocko@suse.com
  rppt@kernel.org
  surenb@google.com
  vbabka@kernel.org

>
> Thanks,
> Park Tae-sun

--
Cheers, Lorenzo

