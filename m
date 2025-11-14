Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D9DCE7A8E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906758E0013; Fri, 14 Nov 2025 03:57:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE518E0011; Fri, 14 Nov 2025 03:57:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B128E0013; Fri, 14 Nov 2025 03:57:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 72E978E0011
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:57:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C4DF87662
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:57:30 +0000 (UTC)
X-FDA: 84108609060.29.430C6BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7EFF2120006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:57:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=To4Kkqr+;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763110648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8Re3eB4fDwdgWvTwKhxyvfxNfZY1EffbP1BROq2u1c=;
	b=srsTIJHxeOhms3NXnaQyqrTdPpZZoCO0XDUTiF2iTVGJsYOYW9nLKfz+6wgXdD7wW/vIK9
	4xSvT/8vv9ttgAgZJWy9bKNYyNll6YvhYaMXIqUPjkXP0Djns8StLT0GuflRh/l/m9b3nV
	lV1WUndYpLA/2QKCpcMKgzgBEUNiMv4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=To4Kkqr+;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763110648; a=rsa-sha256;
	cv=none;
	b=AKUw/ePuHhodi6MVuSm9alc3tzH7EGpC5EqmbQ7Rk/GNPieurq5/taMwcanbVkiu+1piZN
	1brxBMZn1FB/puqgADGN20Wc+KuOhQrjJU3tBbC7CnmBLdIzg8vf9peRj+4rQfKkCz6Ycs
	yhDLCy26rIjteGmXy+PpaK0PuHRwgXE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D51036012A;
	Fri, 14 Nov 2025 08:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FF4C19425;
	Fri, 14 Nov 2025 08:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763110647;
	bh=368XzlnWR8kLrxRUK7EBdCdTiTfQn97LAfR3nFHllPs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=To4Kkqr+2c95gKtPy4kewCrPBWnMxgCxCbN+A0O1mulYdiy66DHdKldhOj+ltRBSM
	 vqg+MODYMmEezjqVU6DQZuL31nAKYUaaHxN7hTxlzhSYXeQjvun5zrQtiPOa0TdkwE
	 Qb/y/nxowj4bOrSDd3A57psqQgTs/XnbBxGg1GUkm3dzosbZgqqcm1tq4nSeOhcpKy
	 kJ7v2wkTe2IF2fL2N7TPkoBV3ps8A0Fwu4Aplf2MtDCcmAwPMhR/yQButCuDUpZNl5
	 0W5hoJVIqA5SKv8yGGd9OhoPNiZLmUnWhY6Yxii9AfgzbQzZ9yvOsE9eBNuI5/ZQXq
	 wAvtFXjVPoRvw==
Message-ID: <d0da951c-914c-482a-b5e9-93657b5f7a78@kernel.org>
Date: Fri, 14 Nov 2025 09:57:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] Fix the name of the source file for the "FOLL_WRITE"
 macro copy
To: peng8420.li@gmail.com, linux-mm@kvack.org, akpm@linux-foundation.org
Cc: osalvador@suse.de, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 linux-kernel@vger.kernel.org, dan.j.williams@intel.com
References: <20251114085038.191031-1-peng8420.li@gmail.com>
 <20251114085038.191031-2-peng8420.li@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251114085038.191031-2-peng8420.li@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7EFF2120006
X-Stat-Signature: ux66787pjtfz4qatwzfyr58gagr4hmpo
X-Rspam-User: 
X-HE-Tag: 1763110648-337859
X-HE-Meta: U2FsdGVkX1/wh/N63hq9mIn5vh/P6oL+ay8clEfHeJqnU15Jgmbr+hDm6uwge5teP8b/FxIgjqHQPE/OToWpWS0MPrDTzFPb/HsYhgF9VkvN8Cq3V1ztZ28diEGa7TagcBhFPWbDtXII6gHtyvP7C411oCo3m+5yGgiLikG5sPcgLtT8UIYQy9rrXr2fUSnzwWqR20HaQ12kKbcm9w+3iAupg/QotycWw6Dez6n/q5lsWHyddwjAQmbZlbWpTAMHiXq6NONNiscR8RZiGz5EfPqWjso02WOkoB/F1Bw1sALq/wfTPsOEWmGi++0Eo/R6wcW0fmGSeRHA3yphqlSU0ay8QAsjFjH0jibeB45YXYKyMs+S+z2vHHOLrTzY+1qwZY1j7nLR+wBhLnoYUg9AYzfYLAv+ESZqUY0GHPTO15Wkze05oiF62TbGG3Ie80wB1SvtiX/jaHHbKDBhQcSm82dGrLfbjWVyLi8tgedgFqdZbFbPav8UA8cAK85kIpAcmvRAyYB8T4Njz33JWFqtzAE8DyuaGZU1Vc00H4B5h5ZfqUqaI9sQ3tDQiDznu8g8EiiGQaZUJjDA8xZ+1ra/t3Vq+Y11lb6oR7dvrwpPkwv/A1d3o1B7ll3xxfff8h8V6d46N5KG3W6WIS5eWk9d82Zi54jbRNws8xtSMuZOWo6Wj+32yGL6Ul1eW6x1Dt6JaIMEPrzWlUNUJqq4cjk0d69Cxv740QJO9xmXZ9rvB6TYoNSMCdxiQulc1T4QrKDujt0rfe3bYzoyqQhx3cyIQy0/+kD1xbQ7WPqK8I+WRChKddJRZUkXfz22x3Dk0Pw8k5IeEYNvXN2FcVKCOBkJEoT79bnly2Bg0+39JVo8FlNULYQBfahp9H4CMbaGu9jusLq/1OUBYjnUX7NtvdiTzmLClH14Jbe8GYd4uAEeGSKrhzRzG/hN8WJE3xFNVvcPE1UYsvAr6UrG9UlyrA+
 gcqp9uEw
 8iZo7OY/4lucnYhmlIMFzcZMUVD7RVDViczRz5rO9sFpoKuH4HyxZJQI6r2U8Yz3AWwZNC1/w/LQSwWjahv2lVsPzUAWDFxjvTHvJNXXgY6nqcwig5VNRMl7f7KkV+9K+58f4T/XIX/8PPDOLvb7NiHNteoOvszdK1QjLxF3vKFCV7LtdWXI3HsNNp+7xp5nMb7YNhecP3BZ6W049FgXA6Zbe9TSz5ETn6mD2A6ZXWa17T1y9803Ta5t05FR8hYyVS979x0HmtYssp8oCOGe7XT3HXKXnF/nHg3jj1ZfYLRAg4EwXLrz+QH2LMyh1Pk6Q5Afek3piTpiVP78VIki4u3DSu7uYe5vCL+zBUdNLo/gQWTDU2FWBKjuDUOUhKNZmSLGKNb3Jg6Ucq2iKi2e5MPUeomB1kPw6ekkCETyPcJCXfmXvT0Vi4VP8pwOuRsEHaiIHQxxY/hBxG38=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 09:50, peng8420.li@gmail.com wrote:
> From: "peng8420.li" <peng8420.li@gmail.com>
> 
> The 'FOLL_RITE' of the copied source is located in mm_types. h of mm, not mm. h, so fix it.
> 
> Signed-off-by: peng8420.li <peng8420.li@gmail.com>
> ---
>   tools/testing/selftests/mm/gup_test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
> index 75f7134d529d..9cdcd10d3f6a 100644
> --- a/tools/testing/selftests/mm/gup_test.c
> +++ b/tools/testing/selftests/mm/gup_test.c
> @@ -17,7 +17,7 @@
>   
>   #define MB (1UL << 20)
>   
> -/* Just the flags we need, copied from mm.h: */
> +/* Just the flags we need, copied from mm_types.h: */

Can we just avoid the exact name and say "Just the flags we need, copied 
from the kernel internals."

?

-- 
Cheers

David

