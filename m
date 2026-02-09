Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58772E81BD9
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D066B009D; Mon,  9 Feb 2026 10:25:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A856B009E; Mon,  9 Feb 2026 10:25:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8686B009F; Mon,  9 Feb 2026 10:25:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 698F86B009D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:25:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C7341B2857
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:25:48 +0000 (UTC)
X-FDA: 84425293176.03.2FA1C86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 618684000B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:25:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=seVIAz06;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770650746; a=rsa-sha256;
	cv=none;
	b=bt6jQxkPSubXQkoBXW4COwMCY/fAEyqF5QNYYTYGV5jz1cHar8fugzPsgtMLcAqebiwuQm
	h0DXQRxCuOnbwVQJgPAX6j9EhVLyRQ97R4HhWwamwMRBSTnvvnqLxVjkK1rGt66UJn8UzZ
	BnyNQGpMRGLrhefIhVbznA780b4PFRo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=seVIAz06;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770650746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4BzZkV7IZSA/6cO1gcoL8pcmNo5X2EanQn/RYhI+DQ=;
	b=hWqlc/sBVDVSO/5BpZvfWDZrHkgFBstaIMelwNV9VdWQDHQZABLbePAvWVceCRP/V1TY46
	pHsLZqMBrl766sHSJWyx4kE6eRW46LFUlsJZZNq1cPvRsd3LHo6G+4wuR30FGCenhF+ZDz
	qK9EKj9n/gmSDRJLcRfXaoa+KF0OOsk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B294060131;
	Mon,  9 Feb 2026 15:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67204C116C6;
	Mon,  9 Feb 2026 15:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770650745;
	bh=ma+Qb27JkLU5+aWKRXV2EHzborEgIJHMgEqcWWa8W+A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=seVIAz06FJ4S6JCLyie8xRn+U8cb0dC+kvxkBKZDdPdmuqerI9dlxrz9Fc73Lv9Iy
	 ypwt9GfXGNmyLwO9XLvJvY6Yn6UM097mtI9XnJr70d0JWSHAuzqpePRqx8KvUonc4Z
	 y9D6agHrhE0R4idt7VcL/E1JrZRuYb/shzlXsIK2IS+YGWaAE8FGU7gy5b9Jlu3ViD
	 aFTIJ6m0Irb9C1p2tJrQNQsOkbOHr3EoXKjYX+koGcUcQlWcSWs6WYgDav03DyVZqD
	 GZWjEY3lDVkOoBihyTt9zn3KfA51m4LczeE0W4M8YAMgZzU04Wzavb0jMoj6lBzwkW
	 7TviaigilWwlw==
Message-ID: <81cc2fb0-f6a6-45af-9463-c5138f742455@kernel.org>
Date: Mon, 9 Feb 2026 16:25:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 618684000B
X-Stat-Signature: 38gotig67k8hd6yyf5ddetc75jyfegow
X-HE-Tag: 1770650746-507172
X-HE-Meta: U2FsdGVkX1+eEbeu+BN7VI0j9uzJy9K3yuTj4AYy8Y+jFT57h0G4czPM7OZFqE48fp9OzhzcaUka/tfLP8sxZ5OG7LQBIdw2XRMjZI/XoCItHCensHcagQtggwtfdQkFfZDHKjGPwn3Kbthe9j7f/pU+69X/WYUioCkCh2iBhu7VM5f8rAFHFkxzsb4VJMln+XZm3qxW+zRhFCUHZIU2XIbtY64KLETMfT3GQt3ziPmSfGNDFsNTbhRnByjedPsgtnewx3EDP2qcNHRT9FWGj3MYMHqaCcE4++kqdC2EJmXIUk5iRl9GVriS68yBsvIHs1Ug4Y88v0Ep80MAGDAeFJ/7UaNXBUR3WgHcMHUXZjNAVAkZfM0UHbUZK8Kn/cw9+/wG2gNDGKN03tZVG83JbPZR1Cmx6MmZ/8l9yQd/aY2ugRQ0mae6fQqkeZEVYlN/eH2V1AhY7IpMM3uH1rB8lSGLEyXd/CcEbhbvapfvtliSGcJ1lTQXVv9ko33oJMMyLfeTohDs4HtrNTdyOLTFBBXl6xJmEwjtyH9ozUfBKbS0TncmQl432y7bcSPa/wC2wlByPiNe/lO1h9ubUSB9A8OiK/ykr8UKxR9shM+meQrQCH/ExDdQy/EZPlrfj3DCnKTt1jy81eTZ4zlYsaZEFWw24iaXB3//sHh8tXsF/6tkr2YZtBr/sBLhP2HLjyurndjeKlHdBFIcGG/7285ISwSrjxZglu7Q9J2GrxGyo717D6UZygLHhrTYB67F7xDo7VQDb9/q3LUY+AlT8vaJ+rn/Hu4OvZlFLtUE7bP23J0SosIm6MB1HAXGGxuTitY5koriNzG5TGZKNdAlWYJq5Jqh6ERuP7XRrPH8Upwe4EZFEdURTsmIxBvU1EPcCNsPpMzG5xxbQuZcZaCCnynaVhKJ+SdwlI8Uuk+vCIVKIo2HjQyQbM4BbgyagURrGHjEoOFLUQTjsilyu8v4C0b
 yx0/b+hx
 TTdulZ7X1fepb1Cstavp3N1rv0dAUaznhsaioaB3dcCkPqRhlJRqhJsOBJ0IPz03dxVXd1zHsJT3U24VJ2E53zMDGB4VIsfSesMB8zK3LN6eGcWOuD9BypLJyjm3dPssHp7oQZfIiYU9R3+kNuKEZCLZZjBO03cPOUelVk00kqlyqMqDGlzRiVeZD5MBZUL8zauVcfSNEdmLfZG7/i0mdIxizNLGZmOfK7vIKaVDEU3tsJtOYhBK3+d3WLXIl0RJA1O27JAuwwiJMqkiJ7/Z+/KiUZG/mCC+Q5+ESddzs7NFb7JGx95LPvVhXR5auPHEtHiAAzgCOiKeGAQWGt+zahQEToBhcL/yGzMxBwFjEri5NjDjb+RBoALM2kLIsRdDFC0lg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 15:07, Baolin Wang wrote:
> Currently, folio_referenced_one() always checks the young flag for each PTE
> sequentially, which is inefficient for large folios. This inefficiency is
> especially noticeable when reclaiming clean file-backed large folios, where
> folio_referenced() is observed as a significant performance hotspot.
> 
> Moreover, on Arm64 architecture, which supports contiguous PTEs, there is already
> an optimization to clear the young flags for PTEs within a contiguous range.
> However, this is not sufficient. We can extend this to perform batched operations
> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
> 
> Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
> of the young flags and flushing TLB entries, thereby improving performance
> during large folio reclamation. And it will be overridden by the architecture
> that implements a more efficient batch operation in the following patches.
> 
> While we are at it, rename ptep_clear_flush_young_notify() to
> clear_flush_young_ptes_notify() to indicate that this is a batch operation.
> 
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

