Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E76BDC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15456B0099; Tue, 28 Jul 2026 16:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6106B009D; Tue, 28 Jul 2026 16:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4796B009F; Tue, 28 Jul 2026 16:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC7D6B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:37:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E71D3A17AB
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:37:21 +0000 (UTC)
X-FDA: 85039345482.28.800AF74
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id 11661180006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:37:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=iVz2FmM2;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flDw3mHXvbZFxRn/s1tL+2JqlMEaoy6483IzE15ZFis=;
	b=h6Y/5tV38oOgQH83u64pNILsvMsgbH/JoGTJEMwoyS0cTDwSXgf5SDIbP3Qyz4scaahgWz
	Wp6bcFYKAqdrBcmKfM6BfDZfcHvu3x8YkijYpUkn6XCUwCsP9pdBCy7ckYVz16I1ce+TmQ
	pghZhEZFsgCcv7kC1nB/SzyA8ubAOWU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271040;
	b=wrC5VbHchbU4Hpgj8aBK74WosXvcRI8MSi6fMPuSab3FB3QFE5x2I2YpdccA/XjaM6Y8JT
	E0axRw6N2M6jFSWxXDlW+aKod3KAsatNpiBCbRZ+buTqoswn9nRNHr4/I78AJpX+bAeDli
	t+omPpeU+1+igM+GNsAnUv8fNvfQZcs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=iVz2FmM2;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=flDw3mHXvbZFxRn/s1tL+2JqlMEaoy6483IzE15ZFis=; b=iVz2FmM2MlDgOtcBCnBH0KIfPT
	InRjz/Yon/fuoNqBLblZolKdh61PNe9TBvncM1PqJVjSLgRfBI7x++++g51TYMPZh5C832nXdz2OM
	Kvsy28AZ3CAenbPyrGtHkIajZRHr7PKrCtVMV4iqlVVXX9JtK2y7qhzkqYD2NnUQDs6FBCBuMkYjk
	TFa0zHPbDY+X5vDusFqKvFlssAsSDlyRItQgLPoXmYCO+U41+qCvLBHl+xwuJvPH2qeXf1c+OYrZR
	EWA3aapl0jeE14MPu7fKXxjdNBOSoWaBbpjggijjvkDWLrsHW3NbviG8AnRxgat7HfgDF5LoP+X1O
	/qy8nm8A==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wooSh-000000000Sj-1tU6;
	Tue, 28 Jul 2026 16:31:39 -0400
Message-ID: <b4c8c579aef9b2098fdcb0c1fbfdc103b563a5d0.camel@surriel.com>
Subject: Re: [PATCH RFC v4 12/12] selftests/mm: add a slow-GUP content and
 COW test for mTHP
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Mike Rapoport
	 <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 	linux-mm@kvack.org, kernel-team@meta.com, Dave Hansen
 <dave.hansen@linux.intel.com>,  Peter Zijlstra <peterz@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Michal Hocko <mhocko@suse.com>,  Jason Gunthorpe	
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>,  Matthew Wilcox <willy@infradead.org>, Usama Arif
 <usamaarif642@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org
Date: Tue, 28 Jul 2026 16:31:39 -0400
In-Reply-To: <de6f893a-4369-4ec4-b47d-517ce0c29558@kernel.org>
References: <20260724222934.1463812-1-riel@surriel.com>
	 <20260724222934.1463812-13-riel@surriel.com> <amX19fK0YVIEonfI@kernel.org>
	 <de6f893a-4369-4ec4-b47d-517ce0c29558@kernel.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Stat-Signature: s9hg87mobqq4xt849ujhkou3pnwcpcpw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11661180006
X-HE-Tag: 1785271038-718182
X-HE-Meta: U2FsdGVkX1+NmXJ16deTJXUrerXl5pb2CfiMrkJsMxWu3ncuasplHlc8wWkrF7fw41Amb3b/E/PUuwTOCHvGiDV2sdTh7kIrcqeTooUNWNdtQJNYMWhumDz1ONtJun84RfHxD/gFGQkyncTs+C9LNdsabbRloFxJWU3x4t4hBzmfzXIkO8/HNwnPqobV5rW6r4+1UExoZ4scHQ9u/J9eYJYwEFdedkZE63ykqAIArdVUZ6nIEIr6w2PgsY35F4vzR8/582HkJC5F2l59LhHSIp6Kl9M1bUJNEGvxkXD6+oRxkvGi1L0q/MzhQcjgNuwrtx/X2sBGrKl3aruplEbeimzR4f9iqMjMpURV4bmSDXpoOmghFzqLx5483zG/KrPJLLOJH1Dp+bM/JtVYsEqGB4xgdMKRn3Aa5cnQUmt3aZghckzhILadsUPMgJpBSBlU71mCSHPm5PrAxjnTWf9BT9+m10ZYjmsgVdYXtIGJ0ZUirC+gZFXwpogya5gYmnW3C8bPnC1qjXvlJeTYbq/ghYMR3WhFT8cO0uQ20eYxzMz1hoHo6oneFVxo4pxwJXsgtFIOqfSIXOsNfmh423JpZKXkeT7kdRQlsgxFP2sJ7QMd3A1kgq5IUh88a/XbJvzud6V2DMsFkhNMBye9JLdqewO59bC9zSiW+Dm5nTl1RilzRLPF+Y4N0zcuOzWdhgQo9fAIy+NOkME6/RSjag0NDZvh3QZWS1DQEQhE8EHOcFz6dNGrFLkdd/HvcoVALzIwv4AqGxVLx4zJo74HQq/WEp2PV+bGcNZsGo2d2Eb9ZGB+cALcA6aUvFrwovnS2uaH+BkjgVhLhIR6crS8JrDh58C9aoNjJsfkkeVBIdIXt6E9ycPF/L8ANTJWl8pGqzFkStrbm+Cn1nZEfqC9hrGeW/50HWn3AshQHzsdN3BfqtaQfYEhzmC5AKMz23PLww25PzPFsaUo8QukvMOLyYM
 9GwHIl4G
 AYXacD3uiXKM3BsDP75vYkc+MDDuRwzGUeKjSjEalE0YHwlAqnpdPZFGmuH0OYsVOu3BKrj8oOBv9lTQ0Cr7r1Wljtgb0Muxw7ALNyrVBCAHJCIxqYU0eWUxuTAzAYknUSG+lgFlkzJ9NnpYDlYWOPniRGTnPCBpNSSSnQhel5EKo6fUiYi/9DBIKcfr5DW3wyTsmdqeA0HCHYFH+zIMPlLotKOH+32EXJuS3WJsihawE8tWgNlFDUA+N3nCB5quUCeqZYFUDWgOBvKudZyogc77u3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-07-27 at 16:05 +0200, David Hildenbrand (Arm) wrote:
> On 7/26/26 13:56, Mike Rapoport wrote:
> >=20
> > Please (instruct claude to) use ksft_* helpers for printing
> > messages and
> > tracking failed and passed tests.
>=20
> I'm afraid we won't have time to keep repeating the following:
>=20
> Documentation/process/coding-assistants.rst
>=20
> * Reviewing all AI-generated code
> [...]
> * Taking full responsibility for the contribution

I did review the code. I missed this one, largely
because I was focused more on the mm bits.

Not only will I clean it up, I will also make sure
that other people using the available Linux kernel
AI tooling will automatically avoid repeating this
mistake.

I submitted some self test checks to review-prompts:

https://github.com/masoncl/review-prompts/pull/89

And added some commits to kernel-style to create
clearer comments:

https://github.com/rikvanriel/kernel-style

I also tested the patch series against the updated
review-prompts and kernel-style guidelines, and
the issues that were pointed got caught with
the updated tooling.


With the gigablock patch series, I tried to edit
the default LLM output, and create something
vaguely decent. That was a lost cause, which I
do not plan to repeat.=C2=A0

It was an especially big waste of time with the=C2=A0
code that I was never planning to keep, but where=20
I had not thought of an alternative approach yet.

The current plan of attack is to add LLM rules
every time I get a comment on a patch series
that addresses something generalizable that
I missed.

That way anybody using those tools should have
those mistakes caught, and either raised or
fixed by tooling, before they even start
editing their code.

You don't want to review the same mistakes
over and over again, and I want to help
people avoid sending the same mistakes that
were previously made.

--=20
All Rights Reversed.

