Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE80FC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEDB36B0095; Fri, 21 Aug 2026 05:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F0D6B009B; Fri, 21 Aug 2026 05:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68046B009D; Fri, 21 Aug 2026 05:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 802076B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:30:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F04BFA0418
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:30:34 +0000 (UTC)
X-FDA: 85124756388.24.129517B
Received: from mta0.migadu.com (out-17.mta0.migadu.com [91.218.175.17])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9A6C340009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:30:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E0GKCBAq;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.17 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787304633;
	b=LjRInUJZTL5iwL9FmFTaKEt41BDQJaGt08d9Snqj6Lw0Oh7UBPRGPHJJODYtF/FBf2EGAp
	KQ2BTjHxx69SAFg3gOQsEAWrerq7ZtuoRYxrLZvHW2EujSbM180XxREJbnfZgCVkioB27b
	UeKid1sIQkk+tjP2GkAeLiUYPGeKCYs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E0GKCBAq;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.17 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787304633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSK040sBBU8kGgBeKv9UupoXrEl2KRZD2AS7NSHKRMg=;
	b=3Ryex/cQygU5PXiAMn12ESEQkMcEF4UZu/yPjFlAtGcP9pNG8DLoYCqOadg7F8ykxz1Ce0
	FIO113wz6O5ABUv+wr9bXQqP0xpaDHwCzemySI9rakzXuYDqostRIcwFpIRK98auAyng2H
	Ie8mCf+3Nqg8ENaYibY/vxa/b89tyqQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MSK040sBBU8kGgBeKv9UupoXrEl2KRZD2AS7NSHKRMg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787304630; v=1; x=1787909430;
 b=E0GKCBAqiwbGtxef3NvQTA6webU0djEJEbmRMW3kJepwZO0K2vpnKYCpWnBCsVoC91lzIKKk
 luGJQ6qeneRzs7TI4DcD79zi2XAZOVm5rKgHYyWPNR11oM2w36F0kdCCeAUkxga4Q9JSRF7cUhq
 6RHhASl/dwLrkPTwpbozZxS8=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (114.251.196.85)
	by mta11.migadu.com with ESMTPS id de9d4864cbfbb597;
	Fri, 21 Aug 2026 09:30:20 +0000
X-Mizu-Trace-ID: de9d4864cbfbb597
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 1/1] mm/hugetlb: do not dissolve gigantic pages without
 runtime support
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <e29e8bbf-5a10-4868-87f4-09d48625f6e6@kernel.org>
Date: Fri, 21 Aug 2026 17:30:00 +0800
Cc: Longlong Xia <xialonglong2025@163.com>,
 osalvador@suse.de,
 akpm@linux-foundation.org,
 mike.kravetz@oracle.com,
 mhocko@suse.com,
 linmiaohe@huawei.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Longlong Xia <xialonglong@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FE0445A4-6591-4169-998F-D0F810A78277@linux.dev>
References: <20260817162039.1511838-1-xialonglong2025@163.com>
 <206cb1f2-b66c-4b7b-b0ad-14cca9d8e0bd@kernel.org>
 <F06EC17D-2A3D-43DA-968B-1DD4E1253EF7@linux.dev>
 <e29e8bbf-5a10-4868-87f4-09d48625f6e6@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspamd-Queue-Id: 9A6C340009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 1pc9t4kfyn9m6g4k7g9tfjc7hizbgjo8
X-HE-Tag: 1787304632-780034
X-HE-Meta: U2FsdGVkX1+sIbqZbsCtoKUpt0We5Z8QOhP29V+JgjbQpga18JN+EtE8VS1i6K2p7okdZGTeiTDGeYm4gAU9RoEwZR5z2QvT37RxmIL8TJnwPBKQSEMtE94X5lxTlGOIubaBrtD4ca+AJ6qA9pxGa0+5YjsZOslVVhasLOdy/T5EnwzOhbIVS0gqIOknrjHu8DSI4Je0zfirViPMAFwb906RNaFh/lfNp9by4ZLrAMvWdiVPJ7iKb40Q5/Oo2w7ebHMrMhQpquVoFmedIcQQ8SktvDgCvFDI57d7s9zh1hwGaEPMVE3gjMbkkmNkmkRpf64tl5Qm+Bsx/oA2pA64nIgAcIq6hR0KDJn0WzrUMFMdkVA7kWNOuI4hIhFkxQJy0wAA+kvaskk/SfdGb3gPrs9brl7FZlvOPis/jD+3RTigyiUoW9AsXbgyoJsYodkgeSvOPusE+y482gqcMnckUU6SXvEFKbCJnmbh79qiD9WJbhE6h5G9RP4jrh4E37a6fhX3782CiB/S/9VHD56B4JCVhp8SPUpokld8RCWTF03iPDzSnQvjog4ymTgD1DWKCXHwwG9QAGC7rwBfplUgk2F0iPMq1xJSUoiG4TbM5xBxDHyuLrZ8kkfv8gb7xlofoqZq1O32hnxwPdRq4LF9AsozD3D4oPYKymCQbw+i70V6dL3IsVANzAeZTMtwHbTTGkZjpkXGD2qiS6kCj5ddwlwTK9+wvgebVajenTizGVamVmoFIVuqHqONAPJx9CsQP2UdPbrknBsOVmHVIk2k/uErJz3Qh2icF/Vtq+BBQ2SE0594Y669Sgq9UrMycWw5EOHApwfjE4zM6yAy2LnuWAdRHZfiKYjvfXSkAacLhYGJty8NF7ZRd1rDeCFfi2Ha2uc8PJGoAksKfDoxSn4rfYmKeVEbAaIqrHtY3RCdCukeg0EyUNXSCSU0bx1JWbL4wm9PYi4nuyx/1IgjHP0
 zM0QJk/T
 aMazVMCdcRtTU5uuIrh2CxhzP3RQHyGTRmgR5lobEt0tTXnpyYKX2LrfXiJrreACHbPJV1R0Ffn+SX9FaBYDpjNQA/4Wif2lj2j+EATNcdCV6uBSmF1+BU5L9iX9AD+GGz9z4yy+FRcqRTeR91kOrdJmj+ReicaH57zeezCfcoqMcuz5mQCxey9qnDaXDEnH13cYSVC+4UOw5lvqGYqgH1Gl44suBvL//v0KnDnbC1M0uynbBTTaUv0C4PC0+25+cZZS8jdhbVLanoO/GLaU60Rg5XUaTpA/RCFqkGzLeg+rXmTWOc6XhPzxJSRU/3c1gcw5QSARSUd7ZyO2n1taJlsDytcGU/i1WAPAkoeL7Y7qV3xPJW1jwGVpoxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 21, 2026, at 01:33, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 8/20/26 11:38, Muchun Song wrote:
>>=20
>>=20
>>> On Aug 19, 2026, at 16:52, David Hildenbrand (Arm) =
<david@kernel.org> wrote:
>>>=20
>>> On 8/17/26 18:20, Longlong Xia wrote:
>>>> From: Longlong Xia <xialonglong@kylinos.cn>
>>>>=20
>>>> dissolve_free_hugetlb_folio() doesn't check =
hstate_is_gigantic_no_runtime(h)
>>>> though remove_hugetlb_folio()/update_and_free_hugetlb_folio() =
silently
>>>> bail for such folios
>>>=20
>>> That's odd. Why do they silently skip such folios instead of warning =
that
>>> something unexpected is happening?
>>>=20
>>> This screams for a cleanup unless I am missing something :)
>>=20
>> Hi David,
>>=20
>> Sashiko actually has a pretty detailed description [1]. So I think it =
deserves a fix.
>=20
> That's not what I meant. I agree that its a valid fix, but I think the =
code
> should possibly be reworked to not get silent rejection from these
> functions--IOW, likely the callers should make sure to never call them =
in this
> scenario, and then VM_WARN_ON() instead of handling it silently.

OK. Make sense.

Muchun,
Thanks.

>=20
>=20
> --=20
> Cheers,
>=20
> David



