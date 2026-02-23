Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24149EA4FAE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 11:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0A56B0088; Mon, 23 Feb 2026 06:26:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E8C6B0089; Mon, 23 Feb 2026 06:26:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4703B6B008A; Mon, 23 Feb 2026 06:26:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 310436B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:26:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA25BC2BF7
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:26:16 +0000 (UTC)
X-FDA: 84475492752.25.4E58D00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id DA785C0011
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:26:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UFgvymcp;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771845975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGqf2qwi7NORHRV6israjwuD6PzQni0n4UJJYcY2V5Y=;
	b=kyKZ5SZ+ZSWrYEOmGq0xYas0xlniT24CAHAUus/LpuaGgHRZiC61RmFf9p5XAfZCiuoEbr
	w5asoNA5istix0KrteXwd2qXTtkUOCxuHXqLGDQJ/s1NFl8QzLjyl8XI1mN5eeALphTS4O
	C2FWIuPywq6oxdaE3No/UTholM2YbfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771845975; a=rsa-sha256;
	cv=none;
	b=L26Srpptmw03tpyTzbiFNPfWCOLKYQqUXkIfC6HwAlllzNwd18XOH/KebnGvOsKBevG3Oi
	Yqktdojdi908EZhmgrEwgS0QxpEzoAkpmUlI3xDK5uhGm/PMpBIdnW0VoSKPQyTqdGCJoV
	qS5f+nWSnEm42hfI9mFw9PLJuGZBcEI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UFgvymcp;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDFBB43556;
	Mon, 23 Feb 2026 11:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C5DC116D0;
	Mon, 23 Feb 2026 11:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771845973;
	bh=aDs0xpDI+vbrKdBiEdrMpXir+Hl+rfLlF3frhe5ZXOk=;
	h=Date:From:To:References:Cc:Subject:In-Reply-To:From;
	b=UFgvymcp0RVrTIuY7ko5yNeNvUrMjuwgZ0vqGTrFO2CKK1OCuYxFHel9s5ZS29euX
	 Y+9XRwHjmGaZNlZ13uEEgJsvtB4qcMIBnNBYmOjjY1oj+0vSuqsIj6Kt7t5Ey8+yC+
	 /XHeKhfg3np7MaRo8JaW31RYzK0kl27mVTJvHeSPlin93nQJm97GoUpQCwBE7OcnJp
	 IIOLEUjzZ4T+mt4IO59RzjZq9LbdJBez/cLAf9jib5lVWU+2CfcAETAqqfwPyW14Nd
	 UGdhnVNUNWWaAgINjnNCMYLEGZbzocnr11HP0dedcjL9v+DyhacLEi34t7wtu1MChy
	 v6Y1+twzPT2pA==
Message-ID: <71247244-73fe-44ce-ab05-69c852f3aa1a@kernel.org>
Date: Mon, 23 Feb 2026 12:26:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: lsf-pc@lists.linux-foundation.org
References: <9d5af75e-e41d-4052-bade-8e51c9622523@kernel.org>
Content-Language: en-US
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Subject: LSF/MM/BPF TOPIC] Deferred folio splitting: extend or remove/replace?
In-Reply-To: <9d5af75e-e41d-4052-bade-8e51c9622523@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DA785C0011
X-Stat-Signature: 5a5w8u76qxouh74jbcxe4m4jan6z5te8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771845974-640154
X-HE-Meta: U2FsdGVkX1+ynqxMOoeeOE+DxdvwKxo+9FuW5eMp6hxEmoGTjnYtLKxu55TX6zmB7qdRAQXJqMV1pGoDFSDwQIwTxR2b9/4WmdFgW9NCQD1Qdjf7gCn/iFTT6yg4kd1+zKKgS+VCMM+VuxPylGUb+CHMAwDuMb8/PX+l0FMjQJVoBN80LtnKYzHe43WSllUlUKMFqN4HmmxttCeQTbIT83HVia/L/hKgymLRVMzfQGMp4Ulowgr9zea75HDRWBkdQnXSJoC/tYwlXXH9jZ0oiWeDVqre56+005hhKhqU44F4zuuB0OxyrV2e04t6lef4YTyBjMayNAe/IzxAV3+IaA5rcjSPm6OQmrHkGTlFXAZaZfQs55J7MVvmxChjySYT2L+BDjKUrWE4Qjz1TAxTqoMHiBS2jenwcYR1fS4a7l0nJNr4FgFT3qksWUo/A2/HbltUpKKr3iSAIDEchKYo1IVQpZBG2AVNwSlp1fgw0+57PnFgWHVBA5bwEnLfSM5lwo1pcQhexdbB/0bVqncI59QgqNaUTJhtImiheNlCcffNbJqujDf5pXPDNDBvJ2pfpG9HMTyyEPam57AiPduQNN31AH9oA4f6KWlbTQ34IW3Uy0tgGM3EpRTZ10/7k4mYASmR5bFv0iMhv6zGeGzbS0IViAN1FFutys2X0Nf0oGZGS6YaTAQEbJKQNcMDY6FDw8JPa7dsybkiR36XsXRoDqzV/ePfNXxOWYu+/BpHTbzkFz4A/7inrEtD/CaFI8OKqHX58G1yTY8rsV8NxFxtNj/fngyFq8FMt68LMKXV9H7QXTrM+kB1P7yJ1Lp7foz+CDxVUrZsUIaMdRjUhhP0Uk4gMwSPKeKm4LvzecCdw9z1lDDfsndKWYpOqueXiLZW4wGfjtC74vSzPcSGUbnAc/BTYu4gplj0++V9zay4+C3b9YGYvbD+P6Db/FsSpTWB88LW28/0JnBrBzcqMoO
 xfrZa5NF
 Nu8YKyR/dGk2mKEME32wrYtdgnyCK0dOkTj2ZevwRt7zs849w0zVEG/jwdZoZLoJUHxpDrLCjxvsDWkI3zjFRnG+WVxNLeYOXx4ryq5j4EF5WaEKMnnoWPweG9LS4vXTVymqjfAUJU80kFT1Wwm4EPenH6STmp6Xw0l/FWC7SDg64eXquNST+oQyv1NDs/um4KTv32bRJyWIIfi5nn9YEY1jjck2KIEPnCTPH4z9iyPXlYT9euTMBNV0+3u87Obja1hjmgrSx0/FS02S4ssk4Tq+gt6pILV20IO82z8kjWp3jZHXW7jkxu98Krw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

the "deferred" folio splitting mechanism was originally introduced to 
reclaim memory from partially-mapped anonymous THPs under memory 
pressure. Partially-mapped anonymous folios (often) guarantee that at 
least some memory can get reclaimed easily.

Ever since, we extended it to also handle smaller large folios (mTHPs),
but also to scan for mostly-zero-filled mTHPs that can be reclaimed by 
replacing them with the shared zeropage.

Nowadays, each and every (m)THP we allocate gets added to the deferred 
split list as default, as "split_underused_thp = true", which is rather 
suboptimal.

Historically, handling deferred splits has been rather complicated and 
error-prone.

So I've been wondering whether that complexity still warranted. Could we 
instead just let LRU scanning deal with that and get rid of the shrinker?

Or could a shrinker instead use existing LRU lists?


We could flag folios for being
* Partially mapped (which we already do)
* Possibly over-allocated (unscanned for zero since added)

To prioritize processing them.

One of my motivations for looking into this topic is that with 
CONFIG_NO_PAGE_MAPCOUNT, we can sometimes not reliably detect "partially 
mapped" folios and only know that a folio "might be partially mapped". 
To figure out whether it is actually partially-mapped, we have to walk 
the RMAP.

While I could extend the deferred splitting mechanism to handle such 
partially-mapped folios as well, it would imply taking the deferred 
split locks more frequently when unmapping pages ... not having to mess 
with another list might simplify things.

-- 
Cheers,

David

