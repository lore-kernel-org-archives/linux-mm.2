Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6F2C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36AD6B008C; Mon, 20 Jul 2026 05:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0DA86B0092; Mon, 20 Jul 2026 05:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFBBA6B0093; Mon, 20 Jul 2026 05:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A1C7B6B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:21:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E1E91207C6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:21:23 +0000 (UTC)
X-FDA: 85008611646.02.D22CE4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4F6DD20007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:21:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J5fXfbMd;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539281;
	b=X9uNO606XIeaTLc89IH6OGggH9Xpwrve7WVl+s8Ki1+hkELoHqiGUe84pnY+8wlaWdqZFa
	8y3h01qY/Qiji1S1XGGe7jejH1DCMHvKVwJnux3Kk8hhKT8d5bZDX0lcTA6lYqGlvbqEil
	R0sG9F73S/vzEJokvIit6dOJUY2BQu0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J5fXfbMd;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsD6RQKo6o8ERJ4b5lXSpLDwgwVwFfi80l67FMzW9xI=;
	b=SJiQBlEYiFqoDkRQyGjpY6+CjdUV4LpeQIAW/WJlDXsThLxxUQijzQqBAtSrkEXkKqM6n4
	Zk99RMwPL+F+CcpS/fObzPpaBV+j8MTOg/kYDM00DrTFBQj2UkQuG0Rvb+CSbgzjF8b3Uv
	FBkRQ7ZM55hfseMAIfcZ6jg4Kse2+fI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C461433F5;
	Mon, 20 Jul 2026 09:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C871F000E9;
	Mon, 20 Jul 2026 09:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784539280;
	bh=BsD6RQKo6o8ERJ4b5lXSpLDwgwVwFfi80l67FMzW9xI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J5fXfbMdF6/qZmVtOiMbvlh/59624Z0BW4r/feOd8wk1YPQuVeSBcn9eLgzPdMyIE
	 W07w5i+akLhChRfMzLZ6Ar/w9azHkH6AXMwuWYiVMPjSZ4S7ovQvp3rkU0aaGO6jEk
	 bkiN4WH99PqJTRxUJEX96RT/T3GdspGdSYDUjCD2NU2sidq9yAMc0Oa3xR1rf/b4Pw
	 2c722t3WbyKMrzA2a4Zk94xSwqdYX+lnBTAaYJRG8MPNs95t+3xitHppdcZueG6/uP
	 2sKbMQJEtZQxCxKFKWqM43e0EYiEDXmakQ9k97CYM7siHc6K1TWmwsFY1YOpcwxUMN
	 WA3T9KrTKoz8Q==
Message-ID: <60c56272-4c69-40ae-9b5b-4ad8d2750824@kernel.org>
Date: Mon, 20 Jul 2026 10:21:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] mm: introduce pud_is_huge() helper
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Liam R . Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>
References: <20260717091347.1144789-1-wangkefeng.wang@huawei.com>
 <20260717091347.1144789-2-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260717091347.1144789-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F6DD20007
X-Stat-Signature: nk3y9bbiz93nco7aeied4zs6m5aahhon
X-HE-Tag: 1784539281-695202
X-HE-Meta: U2FsdGVkX1/k4ZP1y7R78fEXcRPIbrenAwoB1u27B/qUc50WQ1LSh8bPPlcyeoMA7pR3PKVdRBGsSSyIkNiMMbK6uOxUb24opNl489OMG45FptDb7FCKUTVG6aqFz6tmxM59k1GPr7pZEVzbvttu2K4+bthehCjNOUjIy0b30iwRQ/Ru19/AcV4gp3sP1J1qGwh4CzjFfKIGStRrXJMkgwzdUGcxgaVh+qtmXpDwaUQxS0qJzPFv/AQHTlP+7a64hcPxGD88Y4V/zbZFVSsX5hvQTIJgtXfUFybZAaCkcl1s+z3EHJm4DcyWd2Pw91KoMcpnHHkYA5ftgMY8yFK23UlfV8C/oNg5b1UQzwKxwe+zVpGlLsbyJYY5zq3twkusgzfSULaMEZ1Kerte99Uqvwtx5xMG/RtVs3j+pJPIeHIAC9P/3TFzj5dfLdzxJLo3gDJE6HxG/WZihAw15W3j0uEwICZafVlrNm9KSeCfqaQglB6gOCZkRO+8Z8692LejTygrQYLAIzNmkck4yTuAK/vBQUN8t952gDHMygL8+j/Orxq9weGOJCtoevv+NmunnW/GNV1fLCA3h/vO6EZajVqUWKGJfzi+6lZVXlvn0QmcAb1u7HZFY/XgqqNRucfTaCcsPB2Yfvdz/HjfAXihqbATtQJfQogBlu04F7MKwKuVTXHVKFBu92cQOoVg3DeFI1UC2IKEd3JAKpCSioRUp4dCtvSP8n+2O78k4OCQN7jgH9yCRgiLBe2kYTaVYbyMFEqFm6/x8RarASB+stVrWcfHwoFKpKNKsHyaIQm1aqZH6TsMW3Bg/XrG//39+ECDWG2oeKqvYsOSlIwOsi49m+P0ngeakg7vVnoQLLm0JWWOmBubXrrrT2QqQgHexlM/aorl6wHeSNQb7ZEi237taAchYtOaEkqNYI+by2jS/oUXBcwMj6jsffVX6t2dDEM0SBvWQDlbepvRewywl0X
 D/ckvQrD
 yQHNxYFmLFd4w0DnsE6R8l9tKPdLGA8uEEj5GIj4SC2X9UOiEaTpTWSukXy5wpndDu2tc//tk7rwFV1gqRXcFNVQ5Qq2ObdQrAfsSEtVsjVKjoSAqbfKUcsIE+t1aD9oA/SWz/5tJvhMn9Zf2APNG/7RkuqBtgHm560A9Os9cc1RlJcPJF6oplOrORH3UpMJ3h0hL5/p6A1p2FYiKAyaG8+Nqkyup46VmM6tDwFUtOL+DQ1FjXjigugJcfx0GL892tVgPiLpOn2oIbiCIujOG1Li5k1uXty/G3jgYRrZmmsd9tAgauUExIzL7vv8gbR/WydlHciRRXy/40/1KIgmTv3fJHS2JkB28IDLm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/17/26 10:13, Kefeng Wang wrote:
> Introduce the pud_is_huge() helper function to check whether a PUD
> is a huge PUD or a software leaf entry. Note that, unlike PMD, PUD
> currently does not support transparent migration entries or device
> private entries. However, the function still includes `!pud_none()`
> branches to accommodate potential future implementations.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---

One day we'll probably clean all this up (once we figure out how :) ), for now
this matches pmd_is_huge().

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

