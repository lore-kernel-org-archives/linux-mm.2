Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C187CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 457596B0088; Wed, 17 Jun 2026 09:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407D76B008C; Wed, 17 Jun 2026 09:16:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8116B0092; Wed, 17 Jun 2026 09:16:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 030CA6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:16:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 772961C23EB
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:16:14 +0000 (UTC)
X-FDA: 84889453068.22.39C033D
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5B32B1C0007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:16:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TPpvLmYX;
	spf=pass (imf21.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781702172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fub6QquxlM+JuEtju5tAKgjI7OpBkhLjLUvWM+isojE=;
	b=VhonUKoQ3MDBekD4uxOWgzU5lH1Auqsg6nyM833doUl6UCyBgdrd3A6LKlkQukk0jKQkio
	kQ0Ui16SoTnkJf0G/6BO5JJ9Phf9zwJnhZo/LF97rD7EfmVTJBR1pxvqiV0jD8ic94qJzv
	2pqaj3/tgBhO06qOEt1X/gkYIr55b1g=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781702172;
	b=pVJpKsvenCBCg3/VmhaI7Au7jOmhL93xS+1+qnzcNAtbtbb6RtkpAsG/HvRS7lbxofu4QK
	0nUTKCIUBWl2FGpe4CJgaGkxYqrxr2TU4o/F5keh53eP4mMZXoFzH51jihw18MmYlx+8Q/
	Hd0rPccjE4mFND8v/sL0sfgQa0x1IVE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TPpvLmYX;
	spf=pass (imf21.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-13807d2f898so6126758c88.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:16:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781702171; cv=none;
        d=google.com; s=arc-20240605;
        b=Ht+ZTT/oHf625VJpWLU62UmcC78Eg9eEiRjB6r/fJMKMTcebSRXtx9/SQ+G5vySNA/
         7NnD3vi14AW03DNDJZDS6npfjMr6lgAOmlb9P1JFLCVE5oC68Cvq46T4ZSIl/zUeeRFG
         AJPMwX4gq1XE2QdadWb5sTYkYVkwtSXv4HQdZlHQNPTK0PqaVYB1twztW0QU8iG4MrdT
         p3tUpsjvm6dr/iNkNwWnxyQLp+FE52PO6Kwa/BaTHnGIO276/40xdcfuDQESEWLIAcCx
         JI4zGkb0zbnHON6kAjkJ6FGxu97ovUlHiAGnA+G0lVCFeiZpayxIAF7GDtVA8NcMT3f5
         PPRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=fub6QquxlM+JuEtju5tAKgjI7OpBkhLjLUvWM+isojE=;
        fh=yY4SpnR656lifEmjo4ElVdL7w8wVcAeIwKZh4zzxZeg=;
        b=IoFRLCokVCEUe0IPxbaGgTWsVOHTa6brZ4TsJ7vPRFl0gBcsVatk67XoSwSwKTodtJ
         hEJsAmfkye3phczXLc7R56gSvdxT6ZADFe3qx+6+jdXfVCIQIzy00okmU7e08mujsWBY
         glDkAcwFJxTsWRLR2VGVR1G76hdUfntHhzToZ6RtLctjSMQsvsvWJEplu6Ow23wak1Cf
         vmHLuyNBWpUn6g/gF8tV9CGTSBvy/f3A1NQTpymlkIf9K63Txr339qqRFJJzd/lsF3dy
         kOGdQdsYup5RMqbg/+/Kx5/AD8bF9XTDbJzqeZ70HIAsQkrON9ny+HMcNBMmqPNMIC+T
         fLHQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781702171; x=1782306971; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=fub6QquxlM+JuEtju5tAKgjI7OpBkhLjLUvWM+isojE=;
        b=TPpvLmYX1ynlE5/KVodK9mw5wNdGU+H7rb4+osM+z4mecO+QUro3y3VkT8+HLxgA9V
         th155LyzYuLForaqKLB5PLdvHxSQh43dRjZf3JYbM4rgzLi2K9fEWsGyv9ANWc81aJuQ
         wqY8XW4FRRTn9AMJcDmBvsrUvsMy9xpj9orPZnCEmK3QIv72AvEnxfmcclnaA5320Elm
         shq0s27YcpB1dp+3S5eoFMxhhFI2OUcINnAVmrpKQZRRovbM+OkeAF4WfJkEBvUazd9n
         +4hXM9/O7thDpvFxQrzTVkv/mCupouctE5UnKI22J9oDDWETrsZqqXE+FdtV2K0C6uSA
         anHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781702171; x=1782306971;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fub6QquxlM+JuEtju5tAKgjI7OpBkhLjLUvWM+isojE=;
        b=Q+6hARedb6VoO3RYnd5iStjkvEPJCofp1IDSJ2iOU4g/3mMKu+RgDIq9w0MeqGfAh3
         HHwESa++YkwWS6MWejqvKay2YPClGx1m8zA6T/mNQm6DLhY5POQ6NcQjKWrqiUj/b14N
         fK+09xpmbaQKwj+VtqlL5klcVjhAL8BwqHTVOk6E+p7CGo2tgkIdkodW5kWl7cCMx6tI
         jgdGJQhRgEkKzcFV8J4ASTEU9rigMul7406DFFz5OkXlxs2Hhw2nX6+qrUMbCW72WksC
         NCYv1Q9U17U0Mcx9ANeRnnfsuyGYMJo6W9mduV2xbLbixux2IupU/AYeXMKcCWcMWJO9
         N2dQ==
X-Forwarded-Encrypted: i=1; AFNElJ8fegPGbxzF87gQ/glWcOXilMK4N+6WQEd8SV/oXCh6GjJzj01pU7McWbLVCeEiDbRv3KglyqESLg==@kvack.org
X-Gm-Message-State: AOJu0Yy8zLNx3jTkdZZwqKVVV48U1Xi1l4CqFXtihNZErGCzN8soKAo+
	KEhnZ4CVVeXdxHPz+C592wkVl8LR0RjXr3Z612433FBKEgBSIgc6cUUrCWtt56mbq8g+VgV789i
	ZR3FhMqFbqzLxunL0nYKE5C0WrTCm7bLTP0evX3He
X-Gm-Gg: Acq92OGeeAeE2dX55fTODtwPil9/aPTBOXsbMnBhGEkjyziU5in9/79lVOTOYUFVNwM
	2WnEWYEctDe2AAiWvycdvsI2WuDJAJDooerd8It9TYc9jqfODvLhlVkHZ8Ljnjy631kamxsb64P
	Gz0m8tdPg6QrH/3+WMA3cpOCYWX0a4UwJZ7AsSGS2qxjlutr10Q5x4J/KG8lxVeiVbroMgaW1vb
	JLmiYaEhj44/9jP/Wr5VLQ9yLBkBr7lUx7PnmQREnrlyQGhf2W1JW/miq//RPRwOJQPwQeVf5Wi
	qHQD5mYKy7f7275uTTVJ/llFhENIprtfZ1d+Fv8=
X-Received: by 2002:a05:7022:6988:b0:137:f875:c1e8 with SMTP id
 a92af1059eb24-1398f69ee3cmr1393217c88.19.1781702170186; Wed, 17 Jun 2026
 06:16:10 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 17 Jun 2026 06:16:08 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 17 Jun 2026 06:16:08 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-2-a5bc7db5a9b2@google.com>
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
 <20260602-memory-failure-mf-delayed-fix-v4-2-a5bc7db5a9b2@google.com>
MIME-Version: 1.0
Date: Wed, 17 Jun 2026 06:16:08 -0700
X-Gm-Features: AVVi8CeIxcUL2I1aQ_28O_B-smEVzCOJCXmIuSPuXbp3acKL7-ICRYmnGlJB62Q
Message-ID: <CAEvNRgHXJirznmAM3zf2LHJgDWpLOAWY1v90ZcX9_ytRzuAZ1A@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] mm: memory_failure: Allow truncate_error_folio to
 return MF_DELAYED
To: Lisa Wang <wyihan@google.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, vannapurve@google.com, 
	michael.roth@amd.com, jiaqiyan@google.com, tabba@google.com, 
	dave.hansen@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5B32B1C0007
X-Rspam-User: 
X-Stat-Signature: 5a39fnbb8ex9kox3jwrkuzm57paqy8cq
X-Rspamd-Server: rspam08
X-HE-Tag: 1781702172-175371
X-HE-Meta: U2FsdGVkX1/mHoRcLLTTMlZ9pwg11FRfTQopS6NTqYWTM9HD+Yxs2MJZfoYE78XWTZwRyCUC9+k8blgNxdhHZb4srtxhIVwpHl7i6ppxeJ93G81qgA5yVPEEmEBCAabLFaxZnIhLRaR5VnVa0C5hqMfCN68BL5Xrxs1kuyHqBHOoeJGXNSW2m8rs77O2efYD+REaZlJ2DIDbcfkY0upBkE1lSKaKUX7aiJdJQjQTbrTWCRXZGMCz2T3jyFgmuqpNmr1kSmkbgvLl9JVHW02kaTzlteC0pwdvoHHLWmCma3yH0dckC/WtYRwHE9ZeK6+YGv5uyq2jY5PoWZmFExMDS9kjnbbn6KxMxTt66AWfGm4gWuX4/NYv6pM3oHdwHXAqKFk+gtseS6AoI37eqcgJC+4fv/UMyj70peNiWBJ4bVCZzXK/FZNnhEP8gGkjjRTGjNAuqbd6rQRmteTIK18LhfPzxIP1EoDz2/Si0wDAlDslN+Net4/qffUO+kJWQ56y2l2kgyQICo5HGnu6Li7Wwcmk7L7JBttUFHOBZ7h/Qp3UTD3XwuiyQdzJM1fCNmRaNwJQ7hK/Y1RpfpD2ecBeD5eVENIJAyxBgmY7UFOsSy7nOZuqzFGHrlw3JMgBJO7rEaRuZDrQj0ewoC/rO7z0Wvdumit/0ydFC3YLdeR/DmWGG1h0h8O2nJLSe0N61EHR8NxmRLwQTICPzCnIdpNjIEjy/hsNpdqK53U5JSrKm9/XHRHWFABOphp0pXOplPSvXcCwrjhBdOQtPWNogNvi3kj+olvm2GEa40mEeG2BxXfco9zIuwdd+rXHs7UiXOAfLm1upNR/9nCNJ+evHYIp8+k8UfRFVjF0cN+fiO4BKkxGNuuCGUZiYKrRRGHhzXxhMU3Okv0+8hzBGDHzzEzmjKTX1A6SJwi3py2G2fq1M5oqWGhxzy59wLjowLH1rt9zL5TqW4xmDQWi1iX5caT
 Hcak19i+
 WlB8kZsdBKZyDzW49zpa21zc7aRFhZKXwYljwfZN5EsF9gowCU1XLpSRO85tGp8NO2mGr1ixq41sFW9mUN3GM0lqzUSwBCbUB0Ff2dYmJOMsOHtoDeSSZI1dgCMmwsbXoR0yJx80X+W0UF40rl2Po1j72GNiNDEiwtivsLyDvxRDe/ScKyYwJQI7u6wb12Dnj0947LvN6SZENw5xbF+A5bd/loqbKzZN9h8G8fWCY4rf07ai6MQcAlSspOGWCfaMpr6vDXeGZErIW2XHk3+JjfkKaVg2f09WiEDN095hp/9VWYxfVaUbFcnajrg2YDoQ2nGOt5gx11vXNzGTpr1+8Eesn1QBi0uI5/2h2l7qbIYFnEq08egsArccaACK0xcRtCQxEwoQ2lK4X9E9MwhTFlQBo8gVq6ZjkFwpeIpsQW+uFt/kDWz+FEJy+N8m8v6OHEaU7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lisa Wang <wyihan@google.com> writes:

> The .error_remove_folio a_ops is used by different filesystems to handle
> folio truncation upon discovery of a memory failure in the memory
> associated with the given folio.
>
> Currently, MF_DELAYED is treated as an error, causing "Failed to punch
> page" to be written to the console. MF_DELAYED is then relayed to the
> caller of truncate_error_folio() as MF_FAILED. This further causes
> memory_failure() to return -EBUSY, which then always causes a SIGBUS.
>
> This is also implies that regardless of whether the thread's memory
> corruption kill policy is PR_MCE_KILL_EARLY or PR_MCE_KILL_LATE, a
> memory failure with MF_DELAYED will always cause a SIGBUS.
>
> Update truncate_error_folio() to return MF_DELAYED to the caller if the
> .error_remove_folio() callback reports MF_DELAYED.
>
> Signed-off-by: Lisa Wang <wyihan@google.com>
> ---
>  mm/memory-failure.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 2e53b3024391..3aff0c981fcd 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -941,10 +941,12 @@ static int truncate_error_folio(struct folio *folio, unsigned long pfn,
>  	if (mapping->a_ops->error_remove_folio) {
>  		int err = mapping->a_ops->error_remove_folio(mapping, folio);
>
> -		if (err != 0)
> +		if (err == MF_DELAYED)
> +			ret = err;

Perhaps better to set ret = MF_DELAYED directly so that it saves the
reader one step of connecting err == MF_DELAYED with ret = err, but not
a big issue.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

> +		else if (err != 0)
>  			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
>  		else if (!filemap_release_folio(folio, GFP_NOIO))
> -			pr_info("%#lx: failed to release buffers\n", pfn);
> +			pr_info("%#lx: Failed to release buffers\n", pfn);
>  		else
>  			ret = MF_RECOVERED;
>  	} else {
>
> --
> 2.54.0.1013.g208068f2d8-goog

