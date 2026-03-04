Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4B9DEF8FFC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02FC6B0005; Wed,  4 Mar 2026 11:18:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDAB06B0088; Wed,  4 Mar 2026 11:18:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10A16B0089; Wed,  4 Mar 2026 11:18:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCD586B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:18:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5FD36C212C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:18:01 +0000 (UTC)
X-FDA: 84508887162.12.B3C370E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 76DEA180008
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:17:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gJWg7Mfo;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772641079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9s3iJ7W1PvNcL3qq79JrCIO45K1pukAhTpjcpyAIi0=;
	b=D4byN6TvvidW71qQ+Uc3L6OGeqDBwurVFtxjOeF9+pvqpQYbpofBro6wrGT7wce5ddsvU8
	9YlngBcrdxNe/7YHJvEuZe9pEzpxxIrZASWjHDU0yt27Zm8WXhkAdTk1yTY8k8FVs99XC4
	Pm2G9PDfG3wwz0RqFlJL6BnSqo98KsU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772641079; a=rsa-sha256;
	cv=none;
	b=gXPqcVxQBwih6Y+z9dZtQtEk9O/J3xkLhw0I+3yZJcdS1zo0NPZOg3Z18MX6+tajhIFfhn
	NOqu+meamWPR0weOFRAEssIbRdAw1HmL6z9qIY5BEc8Duv/UYy1J0aCH6Pv/iJU3NTFkIU
	fMNdAIbNelGS63nfC6yjtZ3z+5bmN9A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gJWg7Mfo;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AA43360018;
	Wed,  4 Mar 2026 16:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05BEC4CEF7;
	Wed,  4 Mar 2026 16:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772641078;
	bh=irP1zCajndUvqw8KEkFg9hIfdy4mdHxtl4bf03OkYZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gJWg7MfoeotR5EQAudycFraVug7RT+wdqRbOH8tUKtEobCUi412sDxOGKssN+m2PK
	 M30U8uRRjPp731bon7gswjGoC58vFTew7eAHyVEmsbDmABKEWsgbBfXbFFHnHasjKX
	 IbFHnPOK8t0gFANg8TNbT+QOjz7qeGNAnLhujRrVMkA9E7uGIjMTA1XnGYOiZbwE4w
	 5BG+V+ppS50OAFk28XeWv2JKRE4nD/kxWuV8F3BwWzuMm7YWHY9Q/8PygXgosHbW9l
	 mm71BHZcn5+/UKwHmtAeLqD8+lZyjg+rJl8PQWlbc0uKyiizOq1iFQ8lLi9hbTcxnW
	 exAKGHyQ3lPnw==
Date: Wed, 4 Mar 2026 16:17:55 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/2] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
Message-ID: <f673ccc5-1121-457b-9b9a-f719584b4875@lucifer.local>
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-thp_logs-v1-0-59038218a253@debian.org>
X-Rspam-User: 
X-Stat-Signature: msir6y4dgkhmtbfuzmtu7j3kyxqzw5g9
X-Rspamd-Queue-Id: 76DEA180008
X-Rspamd-Server: rspam03
X-HE-Tag: 1772641079-552019
X-HE-Meta: U2FsdGVkX18A+isi6/481VpVLL2iFW2eE/5ew4+XRBm2kSIZgw+LoaCx5JnAfmDL5wVe3pDJA2rTlDl2lFgRJDMylNAIaF0uYIGklIhLCZ0s+ansshg5X1S8U6TOjdYdNycufveN1lUUGa5zehFsdfQOkqrW1jS/04McInNpzkOPgC/OlCALWi2T1RXf6XRp0KiiD8K8pHtTPknmmpA9WIJ4dONL6UKaFKuP3sBdmrK5k+bqF2wiYWx6eTAdJmfYQJmVNMT/GJ5JcEGRtGkt6SJbikSIhysz8mwQnrbyhw4d+r3tFNYG1EA+0dinWgd28onDQAm8He5w+KAFyMwrPtMf8dTzy93z53k6I2DmUtRKgSabSVdY7YUdxi0TrQwNqLuGMBFfQPFJSxJc1vah/etaq3Ho1YcAQqu/nNCwUxy2CgkoLMd6sMXk5jv9jwYiRvuqw5pvd5l8LpllqhaAY++bazI3m2bieoVoeemIWlP2Klu++PonOJxcOwlTrm3ANEqYRkyzigXEEFpeymZzsKPRsssN6I/cgVy5asWMnbS653Nx9S3D05F5TcPtiEGajK7iwEJuxaDdpMf/NOg7mB6TyOShduNV38XIx7+I3v0PT3d2DYDtlEoBrw0JUN8Mp99UMvWko2lWj1mvFmMa+K4GtJMLdcvgotVdOMeVwINQOXoMfU31sM4O1yf7KE3h/3ohFl8b+aBrO/1nMtEgAtRiSILVpaTT+1IilR8MxpOK9Xq0cp0tMEGfYsrCOrsJgNF7ouhZVo0ozFZ3vhvSL7P+TWRySEGiAUqetm4lreggKNb5OD2oILciyN82tqmpBMZUINP3Cv49nTUO/k1AoGn7/wu0cWC9DWJQrp6jsLQcwaKX/BQJezy4YGx7423Nfh+5bCfpuffyrg2Ykw5tSR/82lWuu5PnsAn7a8vg9edELgtnarL3HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 02:22:32AM -0800, Breno Leitao wrote:
> Writing to /sys/kernel/mm/transparent_hugepage/enabled causes
> start_stop_khugepaged() called independent of any change.
> start_stop_khugepaged() SPAMs  the printk ring buffer overflow with the
> exact same message, even when nothing changes.
>
> For instance, if you have a custom vm.min_free_kbytes, just touching
> /sys/kernel/mm/transparent_hugepage/enabled causes a printk message.
> Example:
>
>       # sysctl -w vm.min_free_kbytes=112382
>       # for i in $(seq 100); do echo never > /sys/kernel/mm/transparent_hugepage/enabled ; done
>
> and you have 100 WARN messages like the following, which is pretty dull:
>
>       khugepaged: min_free_kbytes is not updated to 112381 because user defined value 112382 is preferred
>
> A similar message shows up when setting thp to "always":
>
>       # for i in $(seq 100); do
>       #       echo 1024 > /proc/sys/vm/min_free_kbytes
>       #       echo always > /sys/kernel/mm/transparent_hugepage/enabled
>       # done
>
> And then, we have 100K messages like:

You mean 100? :)

It's 100 locally here.

>
>       khugepaged: raising min_free_kbytes from 1024 to 67584 to help transparent hugepage allocations
>
> This is more common when you have a configuration management system that
> writes the THP configuration without an extra read, assuming that
> nothing will happen if there is no change in the configuration, but it
> prints these annoying messages.

Right.

>
> For instance, at Meta's fleet, ~10K servers were producing 3.5M of
> these messages per day.

Yeah... that's not so fun :)

>
> Fix this by doing two things:
>  * Make the sysfs _store helpers a no-op if there is no state change
>  * Ratelimit these messages to avoid SPAM on config change

Thanks for taking a look at this!

>
> ---
> Breno Leitao (2):
>       mm: thp: avoid calling start_stop_khugepaged() in anon_enabled_store()
>       mm: thp: avoid calling start_stop_khugepaged() in enabled_store()
>
>  mm/huge_memory.c | 48 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 28 insertions(+), 20 deletions(-)
> ---
> base-commit: 9dd5012f78d699f7a6051583dc53adeb401e28f0
> change-id: 20260303-thp_logs-059d6b80f6d6
>
> Best regards,
> --
> Breno Leitao <leitao@debian.org>
>

Cheers, Lorenzo

