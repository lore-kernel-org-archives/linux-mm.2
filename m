Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D05FBC44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3F36B0088; Wed,  8 Jul 2026 10:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984846B008C; Wed,  8 Jul 2026 10:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A286B0092; Wed,  8 Jul 2026 10:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 609D46B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:34:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE21E167F62
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:34:13 +0000 (UTC)
X-FDA: 84965854386.13.DAADFAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4BEC54000C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:34:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gkp8WN81;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783521252;
	b=wE/CpgQfiR0k52rYehtkOSz5PfsZ1Oi1zmnyUMN/HfPiwtg6T6QDXYaF9S0HrlUV+1OhDZ
	T5qxQ8O6AM73ymBuAAS+FKoZDjCGTesDDbjxtEH4DLj3oIV4pMCUq9VGkeov/F4vS6rQQF
	opP4tiK5isI/WYm7VLlTF4iK9WO8ii0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gkp8WN81;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783521252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMl/Hl9vchj200XFGcGCOCkDW3TMDHU36nBeESh9U+g=;
	b=ggaXU1osC9rgUfqimIpuw2eKUklXjLT6bNIJTY6eR+YnQ3Q0hzknLrUvAhPKw6/KNi/67C
	mg0d84XkSHKogmXakvCpNeCcngQHiYPtHE5UBkg9aAk3KG0yeOydUPzvEDYb2GsATkP/ZV
	nY0an8a+Z+1llfReKLkXlLNddGvs7/I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72D2143F3A;
	Wed,  8 Jul 2026 14:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977651F00A3A;
	Wed,  8 Jul 2026 14:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783521251;
	bh=yMl/Hl9vchj200XFGcGCOCkDW3TMDHU36nBeESh9U+g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gkp8WN81Xw1+3ZEkuWvUYxFshXJZ/yQOPS7JoVjHAG33Ow3qX6AMrvVMPVydpxbJr
	 NjWhiPqXSxGGTD6P1tK49i1Iu88eYDUyp5560l8rg0In5aPnqZUp3veBvqCFfhYPw5
	 jORC0MmWPIsTYbmOwLQu7NQ9zwVmIZ52rxC04wkaDcUJ8nj1eHp6t6hpmlwQq3h3vI
	 ksb525Q3DGV/pcBOebrChZQfScER8OFD89JWU5slohAEvMjcJ+dHGk5VKJdHkrvCFu
	 PCcu51S1BU+7AI8LN7lpTDnbUWWzeTz4Wsg0ynFQp7YbluiF/mC2mwovOdkygZ32n5
	 SjiWo06DMVvVg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pranjal Shrivastava <praan@google.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Samiullah Khawaja
 <skhawaja@google.com>,  David Matlack <dmatlack@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
In-Reply-To: <178341290876.3292146.16538284698967245356.b4-review@b4> (Mike
	Rapoport's message of "Tue, 07 Jul 2026 11:28:28 +0300")
References: <20260703020832.1731864-1-praan@google.com>
	<178341290876.3292146.16538284698967245356.b4-review@b4>
Date: Wed, 08 Jul 2026 16:34:08 +0200
Message-ID: <2vxz33xtmty7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4BEC54000C
X-Stat-Signature: 7w9yofc7e9wpeb73yhfkz75diu8ib66j
X-HE-Tag: 1783521252-703705
X-HE-Meta: U2FsdGVkX19wMOfNPrGllBci/MuKwpyClJHEgAe0gAluGkq0IHjHxwOzFPus1fsTuxE75JUKl+/iCWumpnjjNmvd+p0K0C0PJ9cQi22H+qPvXa7PTysjCY0Xccdlyih/zrPz5qqteB3WfgKP43IQ+0XX3cbQ3qiEQuHpS4zlRK8J0K4eDDM5TfFr+yoDRGl5VEBmtWf2g3AMUkh4xXBBR7tNQcyVzVA2haPhCAVeCc1u20NUfPcE9+ngvjnJ5ORsgMCtHihY2NaAe90NPS6tJUu0lm1KRtlMoGB2XSvvFM2cz9EhsNTfyIUaN9ohpemNKbEB7qImv4sMurR8gNQkrzkHTs9dsnqxuQc/os8myMBsDNmvqGTdVTHmdsgs+q/gyK/+U7OltlIBxigb28SybGzCruhSnrZ865qhrtzogaqFxiFh96BvAnalO5HkhIelJaoCpLSTZzjJqOP+YUQRUDJWhAx+9osW5zYD8heQiKRMEMYXdopHjWMYjtvBYwU8oUhDDlK6gxmO9RydErk8DjEsZVQ8boO8PEmyLu6u/dyS/nsH267vggfCjtOu3BJBTYDhcEuRHFNJhLHuCfpjmMvx7CS/yiTW+xQOCRH2rzuaW4Z81MmxKkwCGbe+d15r3tw0lFS7f/1682d6caINIHmRcaMRteN1Vj79LomRB4W3FsSbEdQZFnHOBARIyG/z2S5WvaHLW2v6cLXfmAlNB9FfTvWYF2aLi3wYRrA8e1kTD2k1+UmpJJsZ1UdsWzPNmW6Xmw44uUDC5lnyoYRWu9dytPeRoIzJ3aKPabMJJe/BMU2v5GJx3rY+IIbIh5oW1S4HrYtALA4OHFEc4hriNUa/7giBPwsJEa3zcTIpvp8mlPVQ507WXyZnW2p84xA87ifyAHPkNSUjRdFhn+eqLT7tc/Ld63rKjATA/zcd/Pyih8pMpNwmigUG25xUshq7s9QI6RBdUh73RESKdN3
 M3yQwCx/
 E5Y12xpX750vJI7Sl60rDjUFVHgNictWTmKVMQKdWRfl3UNeAwHNEpu5qDyrWL/1KMbhwwt/D7tEcyBTRgHWHEYvC+2lnwvSAL/4P57MC6FK6btQbGZOEIHpAknP2tHVJH427F62qsYSbv/OWCdGQCdKsFaAeYsK5R2BPBKNPOehX5XSfV2fKtgvVx6KAkTzZP591/cG0HJnPk8WdwEvSCkh7zqIn6PORgLPzggnMdt64x2Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07 2026, Mike Rapoport wrote:
>> 2. The type bit is preserved in the high bits of the KHO radix tree key
>>    (Bit 63) and stashed in page->private metadata during boot.
>
> This brings a broader question - what is the best way to deal with page
> metadata. This particular case requires only a single bit and luckily we
> have a few spare high bits in the radix tree key. But what if going
> forward we'll need more than a few bits? Do we need a parallel data
> structure for the page metadata? Or something in kho_radix_leaf in
> addition to the bitmap?

FWIW, I am not convinced we need the extra bit of metadata _in this
case_ [0]. But in general, I think the answer depends on how many pages
need that metadata.

Storing it in the key has a side effect because it increases the memory
usage. Since the keys will be more spread apart due to the metadata
bits, it will result in more radix table pages being allocated.

If we need the metadata for each preservation, I'd guess we should just
change the leaf nodes to have more bits per key instead of just one. If
the metadata is fairly rare, maybe we just do a parallel data structure.
Although parallel data structures do run the risk of going out of sync.

So I guess it depends on the use case, as always...

[0] https://lore.kernel.org/kexec/2vxz7bn5mv0n.fsf@kernel.org/

>
> I'm not saying that a generic solution for page metadata must be a part
> of this series, but we definitely need to consider and better sooner
> than later.

-- 
Regards,
Pratyush Yadav

