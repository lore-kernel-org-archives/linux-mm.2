Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D42C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD106B0092; Mon,  7 Sep 2026 13:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E276B0093; Mon,  7 Sep 2026 13:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045E66B0095; Mon,  7 Sep 2026 13:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCAA06B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:23:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D5BA1A0265
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:23:11 +0000 (UTC)
X-FDA: 85187636982.26.7924B2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 928FB20002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:23:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=is3AQ3HR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788801789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jG1ZK2ISJn6wMPTOrAsRj6Xemqw0VX1VQJjjXEJrdqI=;
	b=h6o6976zVgt6Vyq0UbngICMNf4wxsBRCGM27rCL1Q905OQtFJgFT5Bmj5Ip2ArHz+Ouo2B
	syFkkgNbUwiPtiyLLyyL9KQDgYbOBYjPxG/Vt3BfjF3FboGdOlOYo6tU5XTdsNZQo8UdBf
	dKXAkbl/wlbZvD5sE1zxYG3E0XhEe0E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788801789;
	b=CGOs+Oq7K10EEh/vypYcZbXex1N+CIduxq+78ePRs5OJ25vg67gr+YeQYMhb0a58ZzutrJ
	3ZwHAKCBYOCrCtSi1KuJVVvbFUphJt4WijGtw3KP+TZuO3f9+BTrNP++MJI0Oe0MQXHcyo
	WctQ0JCKG89LMYf2wySNRBJUkPK4gPo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=is3AQ3HR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA61443B62;
	Mon,  7 Sep 2026 17:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85A81F00A3A;
	Mon,  7 Sep 2026 17:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788801788;
	bh=jG1ZK2ISJn6wMPTOrAsRj6Xemqw0VX1VQJjjXEJrdqI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=is3AQ3HRDL8a5qjAFDPNCBSxvXnEkEAF6pensEMfbTchD579zlSjf9oOqFTPjeiAq
	 5Jpt9yv5e2caI5XsQlAqevq6KgyP6qnMe9W5VzUptoAePYvJ4G9mM/kp09TNKWtQna
	 rMBEdnuwGeg1Vr++2Pgyf57XTYZcUoVW4hQPdktosMHfpiAqb8NXdrpC6kCZC8FmZr
	 emVfrv8AZ/2gXivDasel+ImYMDm/Az7CIgzitPAq4P/wr3vgd9uR6+WjwXpJgYrcXv
	 8ihuis1zkLjK1GJ/Mfj8XbmrHh3Vc2l2UwU2TqL7qIDpnTVJhrq43sPNhi5lPVazus
	 t6PJWoJgIElWA==
Message-ID: <948c60be-5e45-45b1-823a-7599f7c7fd38@kernel.org>
Date: Mon, 7 Sep 2026 19:23:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm: Make per-VMA locks available universally
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org,
 willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org,
 jannh@google.com, aliceryhl@google.com, arve@android.com,
 cmllamas@google.com, christian@brauner.io, tkjos@android.com,
 dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
References: <20260813193433.3318288-1-surenb@google.com>
 <20260813193433.3318288-2-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813193433.3318288-2-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 928FB20002
X-Stat-Signature: b5bu55ojx51y3wwuxtxm4qo4j53438qk
X-Rspam-User: 
X-HE-Tag: 1788801789-17144
X-HE-Meta: U2FsdGVkX1+0T7IsxWCxHdeAdL8U991LE/XnxjB2y5jgE2DB/4PUnOLHr9GBZmoWFEYOIqMzgcLZV90j7XWBsPQd/HywjcYuNfOEcVaGrtT3cLxOC8Icr997uGz61dF6olPDVXeA9xiCCY8ydZMJTopy8pQauZ6e9NKT3gYb2XBY6iRqjg1XWUjNZ7R7aAcsi8CFY6vMx3WMrtWafvbpUi7BFfJZvRyN4+QJQYSwSTxy80Ne3ANQfSQZHfpuoTjgnCs6CJJ9GnzzahlMjzjk/1VPbKJBjqexxA+JgwRY74neZTxO/EOriQc8PaysCydyuqLrwcTnnlDFte/E6QZ3aI0tyAKXuNMJCORNZ6ffvkvtwhzeOE8wQV7OsB/Iwftgw7kwo6hI6o9ALNISk7ZdLSTwk3EyFkYUlKELgOKjg4UU7719SlLFHbRkod59CutgrNnv1baowN6J8B3UW/ivUTH41Wiqv2MFgKmXKWzzg7qPtSTl16BjoKuOYlhf7t1ZDommxoAbMd5yivtZujGJkiltsQ0QWGUaZit7eO9zHYCFzenG8xZbPf3gs4sQ6HZ2yC5bZh7ev/D8LnuBwWtv/38KHewVc7xhaw37qnaKf1LpF1TqJASlXQkbEkkxmCKOnG44pgqiOE0dXa1inyN4WffI+y1CBqea7P0C4pgSDaxjPshlbsWkcvjNetJSh+uebfNeUOrpRiu8+RkMJJWJq4Srw5560duyBRnp++h0zEI1BOXPPwjo+gZVpzaGDP6ZCf4bCESrcBmUf9o0Kbl0juYu9gSL/BCGhk2LMHN63aE4NQrI6IAhcYSb38TuwNT7fyLsEnh/N2uH+nRuQ1iCI4jUN2PV2Hi/nLq0SD4g14ShLuAuQWqfuAEa2gkdIP8/qKEYoPx3YXyNPEEfu5XG4HH83ry9oqi6aeBu2h1pl7h+NQhUG3OH/gf6bnNxGG/klp5fVgx4W9FDiOKDonH
 LDICBzJk
 tZHvWZhUakGKRiLvHzaceFgp6uUYqkO0bPgQi/fHIhCRy7la74gn4yK+lJm/VO/3f61YxVN6MDeYRV5uQ4yqtqLN9YNxR7LniFl3ldb7sjj38qs6h2LoGhL3RyA+Bu5U+RqB+VO9nYcZbMInZOtwNOiJYvziqDP0flV5bt44cv2Lndk8jnt0cf2npcAOlitXmMMxGrXqhwdZJay63Mr+saCXS/OqHgVJtdJHHiNh/pjtcYRa/H7OpECo8lWb1YfiAX9xhAYdjNVP5xvcf61HTnZXwmcDApZYbkpg5sTqcK1Y/vCnCYJenRJBmeQhVcjHHGe6ZDWua/iFzSYwIw5pdvIJeorUe7BJ7qEq6D3kWTkWbtimPUJVLh6TjyMQhjMIHXesx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 21:34, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The per-VMA locks have been around for several years. They've had some
> bugs worked out of them and have seen quite wide use. However, they
> are still only available when architectures explicitly enable them.
> Remove the conditional compilation around the per-VMA locks, making
> them available on all architectures and configs.
> 
> The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> when the architecture started using per-VMA locks in the fault
> handler. But, contrary to the naming, the Kconfig option does not
> really indicate whether the architecture supports per-VMA locks or
> not. It is more of a marker for whether the architecture is likely to
> benefit from per-VMA locks.
> 
> To me, the most important thing side-effect of universal availability
> is letting per-VMA locks be used in SMP=n configs. This lets us use
> per-VMA locking in all x86 code without fallbacks.
> 
> Overall, this just generally makes the kernel simpler. Just look at
> the diffstat. It also opens the door to users that want to use the
> per-VMA locks in common code. Doing *that* brings additional
> simplifications.
> 
> The downside of this is adding some fields to vm_area_struct and
> mm_struct. There are likely ways to optimize this, especially for
> things like SMP=n configs. For now, do the simplest thing: use the
> same implementation everywhere.
> 
> == Considerations for NOMMU config ==

Maybe the NOMMU "support" could have been had in a separate prep patch (where a
lot of the description below could have been moved), making the patch itself
just mostly a removal of code.


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

