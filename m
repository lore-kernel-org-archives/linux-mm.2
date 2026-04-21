Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E29F327B0
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 08:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B393B6B0088; Tue, 21 Apr 2026 04:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEA316B0089; Tue, 21 Apr 2026 04:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FFC66B008A; Tue, 21 Apr 2026 04:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90AC96B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:26:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17F4C140D1D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:26:44 +0000 (UTC)
X-FDA: 84681881928.09.305190C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6151440008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:26:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C4YWv8EV;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776760002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dyc68Ji63qvbg+yr1FuIS96EhLCqxg6XMq3bztr7hMY=;
	b=ZlH1ZcmAAWXkdZ5Koe6v9qSxEsccw41oEhlQlmOxoUuvNeQ2XYGmqVMVEWWtrPPXOA9777
	lLLbnPluqkvbcjld62OlT3VgzGp0bgofJjP0J8W3pFUzdNU7ri3QjL1U+xA6vqZIZml33i
	QYrIaE0sKG3zqEkVqo6/3JLH69j6Jz4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776760002; a=rsa-sha256;
	cv=none;
	b=6qvESLerjbq4jryiuL6DT0rcWGAqLbUQb1zt8yKhw3imRPjSGob7bUVgqbjgu6OAiTLSDv
	RgO5UiQ0Uj4uPeVxLvuKXPFpc4FTO9xbkNi7865c5hqRJLaRtdn6LYxZhsMdPElIUJxj7w
	5FSxKnccpUh2lppDWdgcOAWRaFnQSN4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C4YWv8EV;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F20F60018;
	Tue, 21 Apr 2026 08:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DA1C2BCB5;
	Tue, 21 Apr 2026 08:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776760001;
	bh=i5m2CUR8QP6u+qST5Zf+eew7jsrxDzkoBpW3jeL85T4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=C4YWv8EVkYKxvs+uYNI7RisIRb0Ryh2Mc/Ha4ptpqfMnOKfdzwr+vvghjhXTF5B/E
	 /myt1Gg3WpjTQVouyK6ugDFu9ZZJRH/Cm4aPVpT1Xq5nbbACR1lEWiv65vTUP5cCZJ
	 RC6xtEk7s4XjsOPaLRt50/4EWDnaU3UDAYO1LkSTH7HHwtawIfmN/9tffnaDLYdFuw
	 1SRBMgD6/9VIZhapfC1YM8uxLZc9gxubUXUySGm1Q8avaVCixc2EyVVqM9emQu0uxg
	 xHXZ5qIu01kJlqDMN3etpBIW2TH+nlBKnqJVj5PfzV/hpmJdG4r/WQcGQ5Vmm7HHaq
	 QDbj+vE5aufaA==
Message-ID: <15109c59-3339-4ef1-8528-7735e674255d@kernel.org>
Date: Tue, 21 Apr 2026 10:26:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm: clarify that we are not looking for LLM
 generated content
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Matthew Wilcox <willy@infradead.org>, Harry Yoo <harry@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6151440008
X-Rspamd-Server: rspam07
X-Stat-Signature: kq6xkhme46f9xmrihqi7nuqk7yipzy6i
X-Rspam-User: 
X-HE-Tag: 1776760002-465124
X-HE-Meta: U2FsdGVkX1/s1i1E856N4JVBz25uLw0oJKcCjaL5nbnnhXhjDFlbaCkoN9n/EILlmikaeeNPv0QrrF/+YUdh75XAPCN2yMx1xhM1vOCgFXzSVeAxcVRKn8iRj2t01EsXtBw2+5pvH7HotPzOUtekN8o0ZXdR/9hCKCSClenTFINUuaInYqn1zSBpzTD9h94lUZFAbxzzOMbz/Ul1gj2Obciy9LYvd+hWd5y3N0izpGU+PjWNUNuarro+UT8rXr+wzlxJYVYHna2II0mg1lyXUbRTSlJJtbdS7BWp94afqrHV0pJy7zc90yfrA1KzmwcE4TaD8D3WgPKlNTuf7kss/NlbpYKS0F8QNjkWPEUvejGlQNmTF8MCI9vnkc37HUBAyPsaoX/gvQmEMFuVKzjYqA1vJ0pJYYsl5Ir+MO9P7XEi9Yv6aZHeLemU/Mlm5PN867+EThmE/U0xVgZinJRynxV4tvZKICy/NyNqepdPjvkXOshzPsQuKO8L83sWUGd0z/Y0a+O9hFy/WWOHotdh9tAHBr8QaSK/Rc8ORb8Cz//gnvpEc3qQ1B0dz8OIl7OtarV+PIYTPnYROWRjRPovI3uDwDIkbnp5nWr3Rq06W6vZ6F1BgcMHTvDYj1KYLoafSQtsb0gLeNuUz6NWk3aSg1j8QDiwfe84oAjnKPAvQ25xt+av2IK36rMmf4qFQsD70C4zGtZtdUQ7gw7UoMG67wV5zKKHxg2J0oUWV7+8TytO3MlaEZtwwOYOLRS9UCagJVRNkLr/N99rupeXmxBFEdm9aT+EeTjxPxnFNTWB3M0fB0UKAFQHI2mmk07Tl0Tnx1irIh8HsRMvpvX3LTUO9OdgE30K+eNxm0ECrB2z+CEx+9B9O1zDaC2GxtSEACW5WTLPDLLOXRi8aEDcDJ2+t3pUmMImRxuZQGZrHkr+GUtnUseY2nmBH3QlSRs5VztwRuJfCidhHk8kw4JmJ6w
 SHU+2pBH
 DySbVKmfYcbnmCgjw0witGHApMkggNs0dkPrUw0m5GGjw3+yy3NdExBLM+C3DIehj3fZxn/1P0FyOA8y06kc43QFk72JnNx4stIg/Ep+rnMFO2qzoCpi70N9IrnmOsI+kuJvGiPeEXkuF0OOmpjZPDO4cAoKDyJNL9fmDbeqbxKW9F/X6yndoS0YJWmh85H8PR849H0+ZNZhVplQ8SYtyPcdQ8h0/7R4YojD1iiOhSzeYroke4D8wtTtZ4nzxw2adwmdzI+FA/pjWRbbfIw/Q6q15OhT8A7X0KPp/22C/EdbYWIle67/FyDbY3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/20/26 23:03, David Hildenbrand (Arm) wrote:
> Let's make it clear that we are not looking for LLM generated content
> from contributors not familiar with the details of MM, as it shifts the
> real work onto reviewers.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> ---
>  Documentation/mm/index.rst | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> index 7aa2a8886908..13a79f5d092c 100644
> --- a/Documentation/mm/index.rst
> +++ b/Documentation/mm/index.rst
> @@ -7,6 +7,19 @@ of Linux.  If you are looking for advice on simply allocating memory,
>  see the :ref:`memory_allocation`.  For controlling and tuning guides,
>  see the :doc:`admin guide <../admin-guide/mm/index>`.
>  
> +.. note::
> +
> +  Unfortunately, parts of this guide are still incomplete or missing.
> +  While we appreciate contributions, documentation in this area is hard
> +  to get right and requires a lot of attention to detail.  New contributors
> +  should reach out to the relevant maintainers early.
> +
> +  This guide is expected to reflect reality, which requires contributors
> +  to have a detailed understanding.  Documentation generated with LLMs
> +  by contributors unfamiliar with these details shifts the real work onto
> +  reviewers, which is why such contributions will be rejected without
> +  further comment.
> +
>  .. toctree::
>     :maxdepth: 1
>  
> 
> ---
> base-commit: da6b5aae84beb0917ecb0c9fbc71169d145397ff
> change-id: 20260420-llmdoc-21bf5fadbd6f
> 
> Best regards,


