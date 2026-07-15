Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6987EC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 481296B00CA; Wed, 15 Jul 2026 09:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A8D6B00CB; Wed, 15 Jul 2026 09:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B186B00D7; Wed, 15 Jul 2026 09:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8F86B00CA
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:42:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0C80A0180
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:07:38 +0000 (UTC)
X-FDA: 84991037796.23.5A3FA07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 16E8A20003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:07:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3glXrb9;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784120857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2F8hSkyxebJB6yvztXLwkydTDbTUZP1WcynsWPDoCo=;
	b=vu+fjxfQJa5q5CM7e5JPDZnOHhPssiHNX4e271NNl59EBUR+Iz17rhRS7+eNibdIT2+s2Z
	0cai4ufXY13HPa5AIPTMnmtVwF5e0KXDnE9MuJdldDRNATYdn/A0mUknqoZOOVoBu813gf
	Zd3O+0DnEaP9+e9iPGlwoBlaJU3SUEg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3glXrb9;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784120857;
	b=mTIb9yavFinRg/j9/VgkVNSoIiRlULforqElrizTxnkmP9NzVS9y50IRZ0D3ywZhQ2f8kZ
	m7T+w6DaJaMQG+XdKVkiEdT5eAEXO6EKzHxdrYfPT1IpHZqgzuEsuil+x9VWHqPUSR7ie8
	rtK1wUFLpuw0+pMo517Gg+6LytX9bPg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C1736001A;
	Wed, 15 Jul 2026 13:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC761F000E9;
	Wed, 15 Jul 2026 13:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784120856;
	bh=O2F8hSkyxebJB6yvztXLwkydTDbTUZP1WcynsWPDoCo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m3glXrb9v3mZSRxk0REyXt42oVh1w7J7h0aRKC9T9OILn9Xy1ig6Kz7qBBTdVH+du
	 sx2c8eH/wkqai7SxX0lb7UrW59LohFuDh1VPy1IDmGLk4jpQx8d86NJz8Cx9WwN8UE
	 iv/otT8uKxl0p1q2WuodfZ4McHV3QVwS0IEDVn06qFaNL/SSuN2q1wUz28Qdx6HaD/
	 GcFvJ/b7flfjW4pMUa/yCxDWz37QuW2GTHDWnqsDf5ODBCd6ga5xpoQ7UhdG2CcK4X
	 dlVjnYObKT7rpzO+zJ8moBz+5KTrsmLoje3xP76Z0NgavA1DeIbUiCB0QEm5z7PwE3
	 JCeC5KzKFUSMA==
Message-ID: <5d7664d7-5b86-462b-adea-4086c21756c4@kernel.org>
Date: Wed, 15 Jul 2026 15:07:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/page_alloc: don't spin_trylock() when disallowed
 in free_one_page()
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Alexei Starovoitov <ast@kernel.org>, Harry Yoo <harry@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 sashiko-bot@kernel.org
References: <20260715-alloc-nolock-fixes-v1-0-fadc49952dda@google.com>
 <20260715-alloc-nolock-fixes-v1-2-fadc49952dda@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260715-alloc-nolock-fixes-v1-2-fadc49952dda@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16E8A20003
X-Stat-Signature: 11ex3pc9jiyhs3whfy4mestwqc1zxcp3
X-HE-Tag: 1784120856-404822
X-HE-Meta: U2FsdGVkX1/0sJ9nE0xFXmUFywGBtr6kUGkYpDTYnkED0bDckiK1O0N7kL5kWLfsjGkMwrDiTZrItCR6klsHJy0eR58MAZ1UalrA/JUrX4N2MiFKfhd2t5rftwCrogLfGAMEoXuuh1nl7mvvVPDzCAOZpb/6IS3/F5c/AGLFq9Wcyng+vyrrEji7AZ3OVYM/mz/48nxun/+HqQKfhZImeakA72NtLF8B8OtALMGk1yvlwvziFPklJF1RCuy1+u/WqSn4woElnen/EHm2OUC8Dr6IVI5IYFO4sY/AVcFSN/bFTlvxmnfhN7CdGpRd4I4eJeWpyA6Bb49OzhqzYo+wP2jgiMR/YcUOQ9PovH34CC/IRr7zGjhoKyM7X8c1bAvn2eP+sMUXDtwwXaE0W9st/CoFU4A2i6tBzT6V6mvOCd3/tt/a5pcwkqRlTa0Ogra4H9OaqzQmtsnnFnjQ0YumDJTCBLk5ozKbNAlGOgxs0wfJ4X6on3fVY3+H0wFHojC84TegzIWXiJcShgwLIJNbtFa6SwNg2y1T6l0Ap7IRPC5ZmojKtCp1L31Z5HR6LAbc7dHADx0MvAr3bwl4O1VeNSKoUsE/4DJyDvBYKHlBCEJ2tRzpCmnBNmQCECEOKui5P2pGRwQuyFJMqfEOCUO8v5lGTupwfc1PXN8/GaSwW32NE/WyGts+ogxvm393ibI0F5thOVwpOd3Z77RxYyJN+vjjNSnBZqzVvWyAO26sEHuFHQXISgv3Ad/jsKxl2NTLRVQj8MZYw3KoSl6xIai0Y5FUK5kB/E/U6la74DfrGClGpxgjCRKEQi1MJqc8UDhLNFZXANADfSgM4yZkcuwSHaBwd47y6QCjxWtahYT8R15MMLUOTnCNn7dw72dSYrQ4On7zM24J/LWEAw8CRIGUJvQA4aT6lLUPgs9CsFCnOljLaEdz9KuUtsf0EG4BDCBOUajAJXu8XH/LcqVheaG
 j4hvz17W
 gPG6+pXhdW4p4fnbVtl/J9FmT3dPg0nO0F5sf79ua6VvvA9PEMA4l1ediuv4B9+0WH8jOhd/d/AGNmj22UOu+ZrOxJQ8TFCyTB2UD0p5h3ktQJphpWnxTH4aedv3tGbCkkurbPVXfOIYxSS7EHt8/G+Khqfz5F+fWovWaMugzuidL+dQ7ODBBmYtIRkAMto4uFJZg7Wc1jsHG+HE8Zq2Y17sjTBPPdAAbKqcS44xXTuKvu69m2JQbd2t8OV4ACQcFeO9HLEcfl7QakOr2lpyaEaV+aXABbIlFkoQ1eBVignIsnOVxhjgsrNJqjR/F4gzp32foNQtmrm69dsR9ejbs/DF7Ot3Y6284Rm5ZMUg5p9W2hbARF9b7T3LvyQoc7+LWYhoHcRJ4yatrF8Sc0BwlBaC88pmkApAs+Vwc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 11:03, Brendan Jackman wrote:
> __free_frozen_pages() checks can_spin_trylock() before entering into the
> main free_frozen_page_commit()/free_one_page() path, but before this it
> can get to free_one_page() via the !pcp_allowed_order() and
> MIGRATE_ISOLATE paths.
> 
> The !pcp_allowed_order() path depends on usage by callers so might not
> be possible in practice. The MIGRATE_ISOLATE path probably means kernel
> crashes and privilege escalation if anyone ever did memory hotplug and
> BPF tracing on a PREEMPT_RT or !SMP build.
> 
> Cc: stable@vger.kernel.org
> Fixes: 8c57b687e8331 ("mm, bpf: Introduce free_pages_nolock()")
> Reported-by: sashiko-bot@kernel.org
> Link: https://sashiko.dev/#/patchset/20260710-spin-trylock-followup-v1-0-affb5fe5ed00%40google.com?part=2

Closes: also

> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5f9873dfccc5a..46e5ea59c71df 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1559,7 +1559,7 @@ static void free_one_page(struct zone *zone, struct page *page,
>  	unsigned long flags;
>  
>  	if (unlikely(fpi_flags & FPI_TRYLOCK)) {
> -		if (!spin_trylock_irqsave(&zone->lock, flags)) {
> +		if (!can_spin_trylock() || !spin_trylock_irqsave(&zone->lock, flags)) {
>  			add_page_to_zone_llist(zone, page, order);
>  			return;
>  		}
> 


