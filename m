Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 533FACD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 22:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458086B0088; Fri,  5 Jun 2026 18:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1E16B008A; Fri,  5 Jun 2026 18:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D06B6B008C; Fri,  5 Jun 2026 18:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 181956B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:06:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4BCB8CC8C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 22:06:25 +0000 (UTC)
X-FDA: 84847243530.29.F2BD93C
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id E5C38100002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 22:06:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=PLn4vmsu;
	spf=pass (imf14.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780697184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dlFga+Oz0ksDU1MPUq6Cr6bGtopVR7dn8Q0PHzd5jE=;
	b=iMfd9Pga+vqm8z2I+sAZYUtgph27ORr0hoiiQ3zyKk99g9FeghM5ytAnLPwvquMPnFkS/B
	LrdhujI1P7de6Lqr/Lr1+RKSdgTVilIZuJ7VargTCKpkVEAcZ0Ue66/1DNKEV6yuACCKDq
	y/1gbuJ2/ZdEC7JCFw6oUUmOQ+LTjEI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=PLn4vmsu;
	spf=pass (imf14.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780697184;
	b=YXp7jXSWgfiHFl3sI6APOhRD05MexkWB41wG6O2dqA3RbqlTWuGOcrnZf1pmqHiQlvwpf/
	B4lAsyYGGM9V0DeLNCzJQFcuwYFjcf+xibBfxEvdCK7J8vMTIVA7gaJXE+NWa86Hv0PW/k
	5EVQsDCOh1Rwrw90VyB0xbKwEIrgOAM=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id B2A7C20B716A; Fri,  5 Jun 2026 15:06:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B2A7C20B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1780697165;
	bh=+dlFga+Oz0ksDU1MPUq6Cr6bGtopVR7dn8Q0PHzd5jE=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=PLn4vmsu0/on3FCK4E1uJjydGEvJ31dEBCE4GBE1Xe6tfbCFog9VpNfz/Jzxs6X0S
	 IGtxK99fv5m+xh5JDAk9kx6SXi/V/w0BdxeA2K7AKomswNR6c/mQFyhRe5niMkW7NJ
	 gtLcZ+JR1R9RpKTnwafLEM0cI9bYG/82pkb49aaE=
Received: from localhost (localhost [127.0.0.1])
	by linux.microsoft.com (Postfix) with ESMTP id B07C13070552;
	Fri,  5 Jun 2026 15:06:05 -0700 (PDT)
Date: Fri, 5 Jun 2026 15:06:05 -0700 (PDT)
From: Jork Loeser <jloeser@linux.microsoft.com>
To: Pratyush Yadav <pratyush@kernel.org>
cc: Mike Rapoport <rppt@kernel.org>, 
    Pasha Tatashin <pasha.tatashin@soleen.com>, 
    Alexander Graf <graf@amazon.com>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
    kexec@lists.infradead.org, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/18] kho: disallow wide keys in radix tree
In-Reply-To: <20260605183501.3884950-3-pratyush@kernel.org>
Message-ID: <fb7ed559-557-b8c1-1f6-5f879feab0ec@linux.microsoft.com>
References: <20260605183501.3884950-1-pratyush@kernel.org> <20260605183501.3884950-3-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspamd-Queue-Id: E5C38100002
X-Stat-Signature: kieqf8mgufpz1q9h33k411ked8b7zhok
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780697183-120617
X-HE-Meta: U2FsdGVkX1+WdQmRPJI7N/xpNDfOqwDpNiD+Rsu4Tkf2OH10bQZktRQhp6DvXnL+2LedMPyzfe3CggG/yWzap1WsllZhnQmC1MLP7xJ30kXMzHT2SF1LZcexaUxOBZw4BRzZsVscH3VuR0pRJkMJt4RlCLmadCj+1o3dOCXcjt2JQ2+cF4QaUGdgrJYNh/Uvi5uog50EccoTj7hF3JI0OLHZYdS+9vx8fygBQUMGedfcdPgAhwr2fMgLRk6usNWgZp/k6gScgPMssKT5vIdr38SyaKpFu5WT2xNO8JSnidh4S0vJg58D1VvZRiT2fmTXRthiifrmAfGQxT5oQtv7Ym1MVIJn+79JcY7I5IcpVdhjvlCG26+ycykuH2S7E3BTgK8tNAgyhQ0otY6V0FAHIRVVv8JsLjHonQN+wS3qIrgX74fuuoH2vXKYS4lM5uEf2SPcvgF0K9Uy1aERWTXtlbZsvE0CM7gTLjQ1kD+tzUcPusircWbGKrTuXA5YVEZAqUV/oQ49Vy72BcNL42lmWQ/HrOH4KWvh90ZktFhNlCEEH3SgGV0XZ06wVdCaeifwd8mQSZKNqvn9j3cSujieirjbZMOxw/hAthUYix6coawwS24oycUuG3lE7SyjLQ70LO0YUrIs9K3ePRX6NuE1Cp+KlMFkZvNFQbBZpwKAzDE+UT3eRZR2HKPTN1bRrWyIqi/vWEEAlpOu3wYCJ89FlJUUNSb2knWa4Fl0ffnRfO9thD/CkYWdzNSGYsASpEXsla5+8/YF7F/fzkUv2LSTMWN9DEUsWM/ak2Jx/4o2orim6JAurvb+57QUnBXjLAcEOGgrF97CqlgFEh32Yd7bhvOJj2cFCmnE/eHb161RVuNtKa2YAnhCQ+j+pTzop5bvaaUTiPUU83Nu5AqA5xu5AJs5SwRiks+FmT5212yJ389jpnYVAj+g0Aws0EVUTZIH6S/TOyuQVHI+y9crAt6
 +2gDqUC1
 uSqNPMHcd/8CHKYB0UGHKG/NtQGYlim8+7a6oQNdZKWC0CnxRQFyCvi9bbfUNm+Zl5WDBEER3vikmh0S0KZZBDhkPYZ2zvmN+aXMOypSVQ0GfQvpP80/pER4GDAG+elW/U9b+UJdoE4GIK0Z5Z61/0Z9TMsYzfqI5rXVaAFx0jZJ2QvruGNzmr5611r+2ABQ29mPj3TpM84lSEQDPznhU3qYbx57tjPnI2b8YUK6DOiN6fbyTg8XIx5676IscLlBPH7xB9zjRksDWOCMkwaH2dbQAGEb3qSA6KmXHnH8dgb/62pSFbzfjsFyGlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026, Pratyush Yadav wrote:

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> The KHO radix tree was designed to track preserved pages. So it does not
> provide the capability to track any 64-bit key. Instead, it limits the
> key width to how much it needs for tracking PFNs and their orders.
> Limiting the width reduces the number of levels in the tree.
>
> KHO is not expected to be the only user of the radix tree. With the API
> generalized to allow other users, now it is possible to add any key to
> the tree.
>
> Check the key width at kho_radix_add_key(), and error out if it exceeds
> what the tree can handle. Do this instead of increasing the tree depth
> since right now there are no users that need to use wider keys, so this
> avoids memory overhead and ABI breakage.
>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
> include/linux/kho/abi/kexec_handover.h |  8 ++++++++
> kernel/liveupdate/kexec_handover.c     | 12 ++++++++++++
> 2 files changed, 20 insertions(+)
>
> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
> index fb2d37417ad9..6dbb98bfb586 100644
> --- a/include/linux/kho/abi/kexec_handover.h
> +++ b/include/linux/kho/abi/kexec_handover.h
> @@ -278,6 +278,14 @@ enum kho_radix_consts {
> 			     KHO_TABLE_SIZE_LOG2) + 1,
> };
>
> +/*
> + * The maximum key width this radix tree can track.
> + *
> + * This value isn't ABI itself, but it is derived from values that are ABI.
> + */
> +#define KHO_RADIX_KEY_WIDTH (((KHO_TREE_MAX_DEPTH - 1) * KHO_TABLE_SIZE_LOG2) + \
> +			     KHO_BITMAP_SIZE_LOG2)

Love the auto-derivation of these values, this totally makes sense. That 
said, my lazy brain complained a bit when I asked it "so how many bits can 
a consumer actually use?". So I wonder:

1) Why is the value not "ABI itself"; it feels like it should as it
    determines client behavior.

2) Would you consider expanding the actual values for the most relevant
    architectures (x86-64 w/ 4kb pages, arm64 w/ 4k/16/64k page-sizes) and
    put it in a block-comment?


> + * NOTE: Currently only keys of width up to %KHO_RADIX_KEY_WIDTH are supported.
> + * This limit only exists because current users of the radix tree don't use more
> + * than that. Changing the maximum width requires changing the tree depth, which
> + * needs bumping the ABI version.

It takes longer to walk the tree. The current implementation is a good 
tradeoff.

Best,
Jork

