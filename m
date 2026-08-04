Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C31BC5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003396B010C; Tue,  4 Aug 2026 10:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE746B010E; Tue,  4 Aug 2026 10:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4036B010F; Tue,  4 Aug 2026 10:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B48C86B010C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:47:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D31C1A0161
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:19:34 +0000 (UTC)
X-FDA: 85063492668.07.A42A870
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 342442000D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:19:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UbW3RS0t;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785845973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnG7feqGPr3glInpiahRtXG3Ss1XHoRJf3kN867vDlo=;
	b=IeW4l2nTMUmZoWY7qvEqpGK+dIykWFukSaby6htEsyKlfefJXl4HRhjJrng1nTAsMxcCrk
	44ZLRlGdXe8IFXLf8FhMBeRouvs1MehpKQAwoFn64AuG1JzmfdCackzbQgWs67sJmoyLaE
	Mz1k+lDeoTb4ysy2CDkYvsceGbrQx9k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UbW3RS0t;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785845973;
	b=IS9qdUyjQko1gwbldJoqCJfDvUGs39mlm5C0iPeuHQRV16JdEO0itfPJ7eTx0WEe40YEO4
	A6tCXLSVExkaL3ryp2TCYzuIFydofgjPCrYMRUCX7VxlD/8lXUW1IHK7Ubegkz/R0C0LQB
	jzxnD3CrkFrybP4EPdl5y0JT+KS/QYQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADACD60A59;
	Tue,  4 Aug 2026 12:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A571F000E9;
	Tue,  4 Aug 2026 12:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785845972;
	bh=YnG7feqGPr3glInpiahRtXG3Ss1XHoRJf3kN867vDlo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UbW3RS0tmox4G54zCmQhTvzkJ4nFCysh2QS9WiBci8mLUuJqlzXrOhHKldYkM3eV6
	 t/HB9Ei981t0S/PNR5BWOot1UWjzcoU0xSFrUTUYUlr4yckN9/ZqnNv9TeS/cDYMJX
	 FuQ9chnVxPPVJ6c+gBV6ctzfr49seahePZCqOt0TeYm6RMcGch9tqKPZy7jhVrcY6d
	 mD9Pl3bM47SYND+5PV/FhkLPniPNt3RGWE/Y6cjTTKmDLF/RmpZ7aFyk+RxVFCyOG8
	 lzqcqXBgVUGCbluEJAOnYXO22o9MRpNQ+hqgQkXI/Ho/t+QkA9vqoZBRbDgbfEBPA/
	 O5oVcmeQdhclQ==
Message-ID: <4b9233dd-4f1d-47e0-b583-8e1436d4a074@kernel.org>
Date: Tue, 4 Aug 2026 14:19:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFT 0/3] mm, drm: ensure .fault() does not have to be
 followed by .pfn_mkwrite() for write faults
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Michal Hocko <mhocko@suse.com>,
 Sergio Lopez <slp@redhat.com>, Christian Koenig <christian.koenig@amd.com>,
 Huang Rui <ray.huang@amd.com>, bcm-kernel-feedback-list@broadcom.com,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260731164341.1109827-1-pbonzini@redhat.com>
 <8d94897f-0f56-4ecf-bcc8-50bffd6750b2@kernel.org>
 <58fc5ce1-b6f5-48df-bd3b-054443c60cdf@redhat.com>
 <f556ae97-efaf-4e7e-b4f0-0f90087c8555@kernel.org>
 <CABgObfaCTroScRykMHRk6fLktzG7CT2Prp2f-CCCANfuagv_MQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CABgObfaCTroScRykMHRk6fLktzG7CT2Prp2f-CCCANfuagv_MQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 342442000D
X-Stat-Signature: 8tuueegi939yb4niarri1ifc7d1er15r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1785845973-271711
X-HE-Meta: U2FsdGVkX19kw5bNuCXEgHibj2qx8TrrWmw4kTTUMWfYfUMgXtW7mX0y/Eo1kLgWATZgDvk04aN9H/LVDFDccTNAUUNHCyelL9Hpn/RKhkBoGtvVvVRudpzgW6drc6htAF750udGDBFne+DVZpNXNFWFSRaS8dPAN/eT5PIk+YhQr5Ku+R2C3zQemIueIUesvLK2fTyIz1QtUTMXt4/IWhw9A7/JC99geIHK1YQIbQVTfQVlJx/GtHeAI73PttIdUKNkRK2bss6JWD20mImenrRRuP0PDfTuVaa4tbkkbeGVbhAGyr/KksGcPb3yed1esUITOJPjHxja4zWaeWH+rDiuTZ8PrdS0s3P28iT336gbJokSnKyKbrtuuFPh3O4S6wHPixv30m11TOxoQYA8cRYeqVO7TtWimWjIVY2VttM9XF4lV6r3vokyF1+q1fzrCUI6vRPYQ5aLEFrK/DC1p8B8du+Kv0CUj/6Kccw6DU2KHwW9H87G1OIiHXWUG43c1SkklxPSZbQILaqpl9KK72oC6bwZ1PjpeUU50cBLXe4PalyO33Fcsh/CFDbF5h0GGg2mMWaKlqs5UNsw4J6Tnlwsuzs4UgnkOXhJBqwIg0UDK8KQxS3am2SvqWCOnj8rp7vdF2/fOFl94EDxZq0lw+IqIlMNoHKfuoa0t0lRPs1EHjwUVJ1FUFpE6McIJBzOdrt6doMJNMZ0ypIhOg8iBa6u2t2P9JiBWmCNrOPOlJ8MQEWKzZKu+qj6QKWbV4RfNDLLlkVFbOBO9++OL8ja/prKvio8wWjodUU2nXQoZeUTM9DwpMbQLVhGIkLa1Cz4PzqbVoD7lmBxs+YAJ5m+QmzFN4zVSbxWCbtHR0kY0uVGAkfERs3SDM1dqKq+CrXoXfYRvLmduZKpGWFbIHZDNzdKONmSRRU/424kVXbmenNR6n0Ykunh8mzJIkLzuvG/kNAKBPxQB8O4cC4amPg
 SETjuYU7
 /tofa+IeTpM7HDqxx2p2cf0OoGBVdbIZxnsLKBeHfIvNAG2XSkoYiT7gVEs6qe8SmfCQXho+CxMprqg+BC8S2EbaGyYXf5AwhJNu7Ww47fyXzWcuXi1K3L7msmkzVvpWO2lsk2G810jzeziewseTmdSWpl3acuOVKzDfBFpbQJhkkm6T7G/rBGhFLaPYhAc3LJ7sg643K7uHmd9vY9aFUVB7PBd2xhN0Mkk1ius63SA716qymGb/aI0SDu/qdHnfQ4fTii8hpPQmyxF95MVs0YTHR+IyFQzxaQ5oHbOeQWcNcQ52641GHZ644MysYRLJsg3j9qQF6ZAYvwD4+wnSBgHpI29H4/ArK7bgQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 09:50, Paolo Bonzini wrote:
> On Mon, Aug 3, 2026 at 5:18 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>>
>> I was wondering about the following:
>>
>> mprotect(PROT_READ)
>>
>> followed by
>>
>> mprotect(PROT_READ | PROT_WRITE)
>>
>> You'd similarly end up without the writable bit in the PTE, and apparently there is not really a way
>> to recover from this.
> 
> Why not? mprotect_fixup() calls vma_set_page_prot(), the PTE as you
> say lacks the writable bit (unless pte_dirty(pte)), and then the next
> fault calls .pfn_mkwrite().

Ah, if this works, great. I guess I was confused about your explanation about
fixup_user_fault().

So this really only about avoiding the second fault, makes sense thanks!

-- 
Cheers,

David

