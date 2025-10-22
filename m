Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D447DCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D5288E000C; Wed, 22 Oct 2025 14:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ACBE8E0002; Wed, 22 Oct 2025 14:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EAA38E000C; Wed, 22 Oct 2025 14:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED6C88E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:24:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2E2C11B097
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:24:09 +0000 (UTC)
X-FDA: 84026574618.07.0B690C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id CA42B14000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:24:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DnOyrUwt;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761157448; a=rsa-sha256;
	cv=none;
	b=JE245je8BhXgRVr03yWv+3jjyVjyV1oq1fkjeuhxHD4/VuB5caXznkTY0OUiBe89Zqf887
	fJNcHq1inJBQzUCUqhmsYHUgvtgknTR8BEedKPxQEaV9sRnzAPLiw0dRNJ1EazqniAEbbM
	X8jFIVxKPy1Yc75JwQGSpRFP5VXkoDA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DnOyrUwt;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761157448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/C10TxjT8ThRh/WrSd/54W8ca0RWViFKfn9Dh2kGc30=;
	b=VwmL/EIwAV+MfS07tQs2Oab2L+kamCfyUVbPccOcSMmHrkFslMGt1I8S8toAx145n5dJfs
	4D/ZAhj3CaTcKsxkycXd7iCmz8vyjufjGZ69e8SuBharUtd1ezlIkAHnwmsGIdHgqoo81h
	PbpbnBHnxlnCidGSwcz1LCsfQ7SNTnE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72C5D432C2;
	Wed, 22 Oct 2025 18:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7753C4CEE7;
	Wed, 22 Oct 2025 18:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761157446;
	bh=lN16kSfzrXPzyaR7YDMKSTzasvBepHm3SWk9ngJJhSs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DnOyrUwtRAwzJloHfIE5bmAiAyWXeBHZ9/k3vL9S6xEPKYSyTXIxJdo7XzKzTwln6
	 ma4xd7hPWcgBS72Jz2UDN0ayuGVM3OSvZIFtEGhvHO+ZvznXRZKk5J4ZzfIpKfYb6C
	 ISH/gBZ7zPEawCQIJXr8OpfNLdzCebnhUpJG2o0Y=
Date: Wed, 22 Oct 2025 11:24:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, brauner@kernel.org,
 corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
 pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org,
 jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH v3 0/3] KHO: kfence + KHO memory corruption fix
Message-Id: <20251022112405.8ef617335ba0387f0608188c@linux-foundation.org>
In-Reply-To: <aPhwMitTY9De7md8@kernel.org>
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
	<aPchmxfh4ACM0vY2@kernel.org>
	<CA+CK2bAHH1tzMEGxAwbmrLnLTzJANMntRu=cp0J8-n101ER7Pw@mail.gmail.com>
	<20251021135331.8e0185a173a5fa40add60802@linux-foundation.org>
	<CA+CK2bDPLAS7EM--stHkZkx8FSgYBjDOz6FdvWBYrdHwZpZZjw@mail.gmail.com>
	<aPhwMitTY9De7md8@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CA42B14000F
X-Stat-Signature: th1rm7ykomm4z15pnmttuz44r39mt67i
X-HE-Tag: 1761157447-920593
X-HE-Meta: U2FsdGVkX19TrS80QeG4LRyxSVw2Pwc/pKUWdx5VWqmHtEE874GWln5zNRG0MumZXQLK5dx07rBaoJZPWuIIucGMdv/KUWSyeiAgcsrfyDEndXexbql94C5OhRxc62hUbtRMK2XC9gCY31Xem3ieKlArfIS0vQlUhyUwekLaUq75w8vX/bT7SamTJ+DmKqPd1YAb3p+8jneMjbwu+SZgV3rHOAELEHNeCo4qFFfNDZI/+IvLDDSwpK2iMJ/Wq5lBY6O3GNgI9mDRDnRoVYoowy8Ci00GS9izQcW67p2N3OTPjJ6lJPs49gi7z7pk6iWCayWQqx/2misAX/CVacHdElUXnH/VRbBe3yEtn2VhnSFWzeCK4ucKvDFLdcPrK1NKhMg4Mvq/9DmSL4Dh28BNHjVFQ3tG5v5h4trX4qTtYm6wRxN7sARl9JkKrHWaGC5CbJrf0KruSaseSBaYuWIMySs3eGmfLTuda98v8o91Cf5uaylEp18LzGl9lP0sC1nNNbuT49oHcUrumRI0t+iNbMKckA7ypwSuMxwExPOg9axm7zIwWQzPoGMgkroIBRuHKyiEFWcav0jEwr3k5VLVphw+Jq+utsA8H25VBCQAvR85zzGXE9FwrokRTu1fVL9dfzD9XhiH+eRtGMpfHfsESopchwlHKn8NGcYtAdO5WfA/9sCY8KeH2jKnYiBbDRc6BODzWBbvcMLNQitgUQXHJq19yTWYK9P0NOd/AdaQG3jUoBJzqWParuBL+pC6V4deTOV02x1oaKSIUQBfMbvD+7ezVLVhlEO05F0RdEUbU9tSS4JtyHKoS+EMsqPbCLoo9TtZEbjd/8kG8LPD69g39x4ZCldl5mmaW9Ba5XDl1OzBLP4S4YqcpW34P0hTbALYBTZadfr72o3hp+aAZnN0b16dMT8e2M2kMU/oA0xXMolA1RmlbBVIOHSxVYGX6fm0X/ce1sWiPzvRteR+JeO
 hpFhxcRp
 kvJ2OHARwLBL7kQbpEI7K32T1RoReRa9Wd6ySL81hRJSJjBAiZFeXuJ46reqKNUTCEWK4NzDeKb7dwWwldIDnlvtapx94Zqb0jtUPiD8aMI8fVm1uBQoiAyxD1iX+ASi980mp0RG5hH8wCLyc2+6UEaWgSq/0Y81nEKF+TFQFHS+G6bZDOPUrUFjNVPHzw0gRJHZnIPKCBaW0W1lf61eDvPKy5wiYXU3++jux3AsTu6wo7RLNdeZM0NPh7q8bjIDO2zdkwQ+ZAHCbNUa9FwDznfWdVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 08:48:34 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> > We are using KHO and have had obscure crashes due to this memory
> > corruption, with stacks all over the place. I would prefer this fix to
> > be properly backported to stable so we can also automatically consume
> > it once we switch to the upstream KHO. I do not think disabling kfence
> > in the Google fleet to resolve this problem would work for us, so if
> > it is not going to be part of stable, we would have to backport it
> > manually anyway.
> 
> The backport to stable is only relevant to 6.17 that's going to be EOL soon
> anyway. Do you really think it's worth the effort?

If some organization is basing their next kernel on 6.17 then they'd
like it.

Do we assume that all organizations follow the LTS schedule?  I haven't
been doing that.

