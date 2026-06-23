Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7E82CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499016B0088; Tue, 23 Jun 2026 05:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44ADC6B008A; Tue, 23 Jun 2026 05:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33AD86B008C; Tue, 23 Jun 2026 05:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07D116B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:56:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8828B140439
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:56:45 +0000 (UTC)
X-FDA: 84910723170.01.205E637
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD4324000B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:56:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="U/7TVqpe";
	spf=pass (imf11.hostedemail.com: domain of 3WVg6agkKCEw7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3WVg6agkKCEw7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782208603;
	b=gB6J7jn4aoetbpFzja3+O6lgU/nF9tVtyZGFBDzF3sELeiZSyw37+alQS1/tPl8ir4chCK
	X8I1z8nBApTavnC3lYey2WLNjlkw2Vuqu7jpexXLM4AGAlgerKc4KzwLQ0SKSx1pm2e8MP
	J7YOJnEj7AVnulVMdjaP+RXpEYLw5Po=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782208603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7l5YUe4iMmfyIV/63bKF7KguYvHwDoEqvDEkpS8VgM=;
	b=8WPu4IYFbS+3nYvX7Na407rqq0VqUFGrzZnNrlnxjXv8OHAhNdTf/kGPIXLYdoPJrmnjYE
	4gRA0k9j4C7qkoHKVG3wfVIXGqls43u1IVF5oSFdVk+RTX+w5FRa2N2gkdcXOvk31q2f9F
	UWy7EH5IBofuw38ZwMImhrTN/2ewK9U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="U/7TVqpe";
	spf=pass (imf11.hostedemail.com: domain of 3WVg6agkKCEw7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3WVg6agkKCEw7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-695c0775f8aso6737393a12.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782208602; x=1782813402; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K7l5YUe4iMmfyIV/63bKF7KguYvHwDoEqvDEkpS8VgM=;
        b=U/7TVqpeabPFoBMo/vgMJ54WZtFCBX8Q9MMwUA7OZ0QKD8HPXx+oBZLgHrmD9doyuy
         gzFIgWDOXoGu87GlaWdhVQb2ciZunPOm9QS8GULrPIrOtRiwjNxtqRF1UiaEMUVWxNFQ
         DK4tB4MVwo41e1f19sfGpd23bBmByTCPhM233041zN/MSntMOn7O4BX62L+cYzawdIh/
         r3S0KEISOPIw6hnMa5KiQzM2peywAAOchulMLDm0une0ARTGmpmIFhWlCoP7bZ+xzXgD
         /EVvI7gI7cv56F5jyBvYqvogCViTfyU+kobZRTAzmjLPO0UXmZ0L7u1S6M+N1gKQ2dNp
         a1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782208602; x=1782813402;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K7l5YUe4iMmfyIV/63bKF7KguYvHwDoEqvDEkpS8VgM=;
        b=c/k/PEQgYxDx/qtZZx62RG0K8Nbky4HBtIOfbMe0O8mv6XTb93ygO52SZ9dgn+V80N
         nbHAVOwwX1jANfMHDjPR1HouDd31sEXCXVTVtSB8D5+ZTMZI5+4quRgsQTZq6jJgKlcA
         HycD56JxQ6wPu7TNe+epUUBsJU5gCGD4BPz03KzevIAkwwV51Nskjo9Vhb4nlMnF/CHa
         Fqrfv38x7kC6I4gb21lOaHZma4JgAqdtjEPNcOaap/KLE1uMHBMkUZ+y10gLrpTZq9WB
         SK3g1be5GRDzSHDSyhGgwjCj0ozge0eNYcV5lgA6jLwlLfvLU0+o2F/Ah5DIOCLhwouO
         116w==
X-Forwarded-Encrypted: i=1; AFNElJ+FHK7SC9Thcq9k/Uu+sNa55kM6jMZfsTwuGWiS/y0LWSNvUez0YZQMw0yGS5wDcnKY2X8kInT2gg==@kvack.org
X-Gm-Message-State: AOJu0YyTFTETPr9joMeQzfXrY1t7o4baYPDM1kEQKs0Gv+H4LtEB6IYm
	lp4XsXboqZqHb9KYX2qglmlUAErQNoYJ2NJqU8tFsVax4bxu5k1KiZW5N3RNlFqPhb2RIKIxomX
	7WrHWgCn5Bu4nnSBlDA==
X-Received: from edtr21.prod.google.com ([2002:aa7:cb95:0:b0:695:4c2b:47b3])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a50d:10b0:697:5efa:ef21 with SMTP id 4fb4d7f45d1cf-6975efaf64fmr5571985a12.9.1782208601957;
 Tue, 23 Jun 2026 02:56:41 -0700 (PDT)
Date: Tue, 23 Jun 2026 09:56:40 +0000
In-Reply-To: <178220761164.162773.6384380547612711985.b4-review@b4>
Mime-Version: 1.0
References: <20260622225736.2961438-1-tarunsahu@google.com>
 <20260622225736.2961438-3-tarunsahu@google.com> <178220761164.162773.6384380547612711985.b4-review@b4>
Message-ID: <9huzpl1h37hj.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 2/2] luo: Update serialized data to use KHOSER_PTR
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CD4324000B
X-Stat-Signature: o7zjtfjxrzzdf4tfuqo3zwds6fw1cws5
X-HE-Tag: 1782208603-891074
X-HE-Meta: U2FsdGVkX19HU/Sv3ABRm3iW5idZ/CP8qAS/BvTi/shZvYSmWBTkqCBQqNrte9Sh2/S9TONKo9+hiDcrdrUz93lfs3JRcdNpzYafYnCIUyVnWKHoFIAMkJ+hoYqnylnO4BiGWaGCraQi3H1oZL1N0e9QZJRtfBDnje0hqC0ZL8W3sYX6/sOfkl8ks9Cw1HnjialIeq70qfwsLz2ohDsWrXWHerzA7Fai1rxv35SVGeXoHMQlRzBzRDK/PTMsJceqHPtRpx8KuEkuEiwZtSmj6WGz0+Dc7/LYLCxXB1r4LBGTXSMzJ1fXtS+XDilpDSLToPBaK611HJrSMS0DZXPxrhu0vqFXtOJ24QFmlfqLmLqhDZZR6mQMINF4e8CBBuOBI4UfE/SFjhBNciaADV+btTKs11Y3GjL1axCSFOtUpWji6NNpI8apGuzU7bVTH2BgWtrDZSx1w/63KwxDcCT2Xaayh6QZl8i9MgiE8OPiy8QSaSgk2n1Sw2JOfa3/pP11g90SwgyQ5Qe1b1gVx6DpcWyP62YYTROHdq+FBOVB+mlk4BCKriqCOhZfPkZgHfK49jSMytePFiotAyxs5ZWEx1vZusyK4+wEvT9HgxSIkZzeFUSWEFbiFOKY6EUTd7A9sQIn38gViPjO5amWC92XbzgbWX7vMMnfu5g/Bqad8ZRDn4qGN3htnBAeWZoAH8WG/Q/oSpP1fDShXdFT48YX4TzwQl0XN7fk9FLBsDbpnSjX8459XRvT+1ld+5G6iFjOaJ/AjYY7xb2I08uzdsAUf5s/1C/5ecpfxqHvYLpruIAUqDE4sSglV9UlVKWX+jUZirqXSOXHrBOJ3DAz0Do5Ar32Xv+GMLxQ9G1+taIy8F98c/E8Y/YC/JG0LJ9A/uPNMSaexs9ondOE9ppIGduocHiTo4YexZ3pz98TQJu765qrXdLppyu3fH0gzR8WOOOSkzIAsFCkS/Bd625WXzH
 E4coVx/5
 fEa3w+OCsVauFhhYA+bEo9bV6/IbkjaRHmLFM+EzzzqbiZ9lsk1+SEmbNUjMDQIiHbHaonCIwhsW4yEO0lLtPvRHsIJ/q+AqLGuDSiWzN+o38RgcltOTueZKu5gU19uPD9FLmwswLMhqUys1EBBOhlGj2lLWO93EgCFgRvnlQWwmJFhdejImIndxJZuIRspmduCZ+prQJDYGfe0XL3a2FepsmV8S5fQRjxgYvHLImNzvNkUoGolLYxNsHJfdx4zzbMudESeTjqKWA+Q84uBR3u9dJ2V5WgjIausQVQxkPJfVZ66OwVim0bnDCsRnsmr0+/nloxSX4Wn79MF3BEsLvoDpDeGMmtDS2cfurNRzH+IMiufNgy7IJo/ZFE2ZgmrMVzHIPcRD4LCDvoHXOoiaT+Dey3uP+qHwKHpgMe4T3a9iLOHp/VK94vY92xlN7VFzYtzwVqgOtbQJaXLzIuQeEmK4AgqN7pllELy9msrhEk5qF0bRXlkvfiqbp2F63KfAGtuB0rnvyTPkrCtLrD4dqueMDsVKKIZobogCoQduQOFYwgobjxRdLiK64ioBpt3fH/XZVauQJONLUBJ9qhb9B0cSkYQFdHNJnJzsf12hgBBgsUDBKjUvVWnq29lsIWRhK7CLWcCpz8mGO3a8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> writes:

> On Mon, 22 Jun 2026 22:57:36 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
>> Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
>> This series also takes care of resolving the bug with memfd of using
>> phys_to_virt before checking the args->serialized_data value.
>
> For easier backporting the memfd fix should be a standalone commit that
> comes first in the series.
>
> Other than that

It will break compilation for individual patch. For example, memfd_luo
changes are hard coded dependent on the args->serialized_data
conversion to KHOSER_PTR?

Maybe I did not understand, Could you please explain what you mean?

>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>
> -- 
> Sincerely yours,
> Mike.

