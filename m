Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F195F30947
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36C86B0088; Thu,  5 Mar 2026 06:38:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3936B008C; Thu,  5 Mar 2026 06:38:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91296B0092; Thu,  5 Mar 2026 06:38:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 974026B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:38:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61254160838
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:38:20 +0000 (UTC)
X-FDA: 84511811160.29.6AD583E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7FE5180002
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:38:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=blyCeddb;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772710698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jd+AEbDO/tNg1ocpHiO5FiIrmxv+G7tEXy86IvAlriU=;
	b=nEvDp2DeQbCtiLG4GnjXh1dYu471rBbCTK1tFMGdJBIfDI8zSXXbgA4QC9f7PDUuDP+x/l
	Qzk7CrWhD8EVeI3u9yEeus+3b8/uktC/l1bnGbEWXhMj7FAp6q+aTOCQ8Q2ETc8cDh3oX/
	TnWgz0ew8E9WH2JcBMpTSUIGFBt/jxQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=blyCeddb;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772710698; a=rsa-sha256;
	cv=none;
	b=Es1gLeYRTKwNBoUBwGB7v11xgw5Gw8nSL54pY1AOoV3mTXEwVNX+LjG4PFVXazMkXqz/qU
	5A03t+wkPD3l83B8Je+77t2JvNV7hJwGPOPpRBnK1UhjIRaxA0dbwxCYRQMgvANtrSOUPg
	fuqMkj5fZ5mSd0NECwKXvhqwH7isE80=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 78FA1419BA;
	Thu,  5 Mar 2026 11:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87350C116C6;
	Thu,  5 Mar 2026 11:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772710697;
	bh=C20lIEwPoCerkwyMRarlqpSodbjC8Ej+W/hHRkHxDEQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=blyCeddbhXH09i9sDmRdbban0y+/dhur0vU3rcQjQgPZ1eg1/J82ULhk5U6PISSos
	 GJAMAfiMiOnNsO8bpszR3tjaE8QS7JHv2OmaKeV6LRvNkWWbjw8HQFt4DKmugPwKHG
	 5J72IdDlzfw+dbx+rWLDxz2tDH7Zh/R51II6rN8Kd9uUwk+tdp4nFXDUpheL8rqKiT
	 Hpf3cPxFbSauzExBq3uNorsi6gPgPsisBYaPqCrWDSYN46ZlzcWuyV0tH6Ot8dDWDn
	 OxKUsM0x8T3LazwLLHfPIttL5NVJU3h/DtXWIcaF7kwttN9FwM+DseimjULsTJYfyl
	 ibm3lEvSiMZkQ==
Message-ID: <05a26f9d-e7eb-4aa4-b5a3-d485945f81c6@kernel.org>
Date: Thu, 5 Mar 2026 12:38:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: Tytus Rogalewski <tytanick@gmail.com>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
 Jens Axboe <axboe@kernel.dk>
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org>
 <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
 <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com>
 <e21e21c8-e28f-45b8-8ee8-7e74d6607b73@kernel.org>
 <CANfXJzto6Ewoj2qDQ5OJEMAuxVcfFcvuxbtKChentqvb2r+jGQ@mail.gmail.com>
 <e2ce4df6-ef2e-4a0c-aee4-86d9614017cc@kernel.org>
 <CANfXJzt7yGZZcuBjmazU9n7V8vupMSLNm+qCiZxcrmtUZicR1g@mail.gmail.com>
 <CANfXJzthDnrQJoCQWrfZwK1Mrw4QZv92ZEzsOy6WGqq3zCYzHw@mail.gmail.com>
 <0dfd588c-3284-4310-b1cd-aab54567f0c0@kernel.org>
 <CANfXJzs29Zv7Qw7cAiEzDLdTJpQEbm6mPeLTpuZkErV5GsDKfQ@mail.gmail.com>
 <ed3eecfa-a8d7-46fc-bbcd-025fd73e5511@kernel.org>
 <CANfXJzsh9m1xHszB3vdSUxfOHpxV6zNDs_0DU=kjjFJ6szEpJg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CANfXJzsh9m1xHszB3vdSUxfOHpxV6zNDs_0DU=kjjFJ6szEpJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FE5180002
X-Rspamd-Server: rspam08
X-Stat-Signature: pxbi1m6wayg48rsr1zyg3sp653s41f6r
X-HE-Tag: 1772710698-240132
X-HE-Meta: U2FsdGVkX1/zYRGor5SJFX/a6YSLlEKSdiyXqSN9EURRh/jNatzumr9jgjk1c1cOT/5GATd3VX9DxYh3TwU2Nl99+DoDmDJSP1iP0mkTZtwbwtvUBmKOA4OWda3F4xAUOZiXNcxugUhkUAJihcZBQalWyfMEypZ22FP59MVR9PNOQoiK1vvN4SDQMtenK0H3ENbB8uwBOzqwLoBWk7x73nq4AgrIgIFgETXhVai4NAIadV54dAZBvC0/vXfxhtHpBokS/ELkxuCnO7sGFLausbobvsWgh2gUMp4BJ/DGM2OnDJWUBicbDZiaoyDjSKtNEvoTG8YCQ3hYg255YTEt577HTy5R8JgTOCoi+PhUEI4aFLQ7jYT5vbRTe0v2v/Pk8DQXXUkAq8R2AeLO9PWboE2GRAf3SggSZwuTWDRm+2QhEWpYmzQ3b9ohKCmV9ScQnfToOI7Si7qxeMHZlBMpOr1CBeBYO26EcY+IK36+uLc0/TRXsYIFByOtpdDMjUOqLv9XftIlTqvPQ6yq1yNUhnYz4QaoKChJv4uQJSUKgyGRSwonpNJ+LF5Ta6+4G0MaUYodqNRrjHVgq+jUKbnWTdXCYF2DYPETqfA5mfXJ8CbBkhM7VnQoSz0UAOhX1HwElI75zERAHB4RtDByokqL0xEqqPMVKMeXaKmnxIj1+gDarrTTDoV6rDI1j41B39zNxBxQS2r/tNQ+sgG4kOCRFpO3qJ1qcRaLSuE+Z7ScVU7lwBu8KYwQ6DfcRpu8Wj0Aq+XfWFuNWroVr/NF2SwMS9sLOylaKTh+SIJ9qD+2cfzEfFolwfHSYue89ylMRGCH+wrDjw2HEgqyOstblazuXznAS6i0829pM5HRT1a6WECSUUf1GYN3tgFIHhwsx97VRGU6KTGBBfphbG0IIObm8WbDXjsSj9OqFyrLeXq5S6E8PHlpHanQ8Uu2gpmXPWF9hfN7/RW9HYIiPElpNIT
 JDmJlG+c
 /YVdV0sa8zIfKhnHKk47vIshcKd0OOOciI6Uw+Gf6XhQ7hrSgD6A0zE55Viqvzt2dZjelq5jjHuq1t+9n5e0CecYFQ2Wi8W388CqmdqTzWlQZMh22Yas08m5ths9M4rPxjdMWp5BlM5u1QGM7SuAJdAteFZhEEkXqEEKBb0Sh5Rxb8x4RL6BSh/+PIJYCaScygollBciiMSRe4TiuBudtluZFG06av/gKkjdz8rFJ3nzr/e4x9AhZ9BSCCm+qE74/6N4sCBY2P0ItI5v87A7aFHpO6hKihxBHsaDBgznEFAK1yeU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 12:34, Tytus Rogalewski wrote:
> Well, i would better not as i would have to put this on production as i
> have no idea how clients are triggering this in their VMs.
> Cant trigger this myself.

I'm confused, during your first mail you wrote "It happens on multiple
servers (less on 6.18.6, more on 6.19-rc4+)", implying that you did
reproduce the problem on 6.19-rc4+?

-- 
Cheers,

David

