Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2626078963
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=cKOYknYY;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=4+o1zQjd
Received: by kanga.kvack.org (Postfix)
	id 5714E6B00EF; Wed,  4 Nov 2026 16:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521666B05B0; Wed,  4 Nov 2026 16:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2496B05B2; Wed,  4 Nov 2026 16:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 013FE6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:00:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D89E4160861
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:00:21 +0000 (UTC)
X-FDA: 85398654642.04.6199AC3
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf17.hostedemail.com (Postfix) with ESMTP id 71CCD4000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:00:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=cKOYknYY;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="4 +o1zQj";
	spf=pass (imf17.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.153 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793826019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kNaDaN7VzGkf9l540YM+342pLPmeRVN7bIHtngSK/k=;
	b=64LemzA/tf5Xdq3BpdLMNnptvw3lNA+08aznx3+A1SnzyT//Ernn9md82Nr69ruoHUabn2
	nNp2iE5gknjyNlx2FxPiE6GAZmxK0ClYnvARHpHvsMxFGhWn/n4wa1HVz28PuzuJYFoDse
	VNNDeltmPRzoVtkrbSKgLqp6RYb8IXg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793826019;
	b=LIRnSQsZ9/hJ4yvQ2i+z1vC/lEzTZAhHN00wqACcKV0GbgLjSAUmGFgspSjegdLRTdwndl
	KD/U+2MznhOM3/Pm0EKeMa0bfZOhodJ1jxRxdj0V4Rou3avWzjx5MxFhywqBUBmCkeOuj4
	13jUV3tmO2a8T9pQq37/YXa7/Kgs188=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=cKOYknYY;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="4 +o1zQj";
	spf=pass (imf17.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.153 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4D26114001BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:00:18 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Wed, 04 Nov 2026 16:00:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793826015;
	 x=1793912415; bh=0kNaDaN7VzGkf9l540YM+342pLPmeRVN7bIHtngSK/k=; b=
	cKOYknYYKdTNm7gT3ervxg7QOU52Utgs5UOoxtrbubT1te5NsIbZVFPMKvQimH1F
	Ib2iv8RWV6UqdraJhvlS5yd33G4tYwFGshUdIGAdvuU3cFdG8rbWC3+KHemVIdXr
	NUc2JhM2u+Fuhup590pgyYcIA58JTAMOd7A5s6PKYEJ1G0nSYzo1JqwOw8UaY8u5
	i/e5W+IkaQrQVH55p1WK2J1BV0dLB4esSzLf+T0EU8o8dUzyZbsKE9LFW1LDbbbW
	3WekMdVJHEFYWXzfbmA+mnv9lsFDEQ8/WTpzFsEFp8PLVP/iIhwhjwYa5asbRMbg
	mwFkIJvImo19SYtH1YbLFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1793826015; x=
	1793912415; bh=0kNaDaN7VzGkf9l540YM+342pLPmeRVN7bIHtngSK/k=; b=4
	+o1zQjd3Z41zn3sTJs2UJJfBufYk9JKTqk39/upRC6nT7pcYjQfD/I3Zc3xUL5rZ
	yuWYIf/gUkcGIG93Az/bYc/7Dc36FemWDLmMf3KdtapwF2oa2w/hKyx55r0w2YUM
	V1EYzS32YyXpJWz9G1QAPLPbcO4Rj1H3ZHMRG+wciXebn7B5UGdXi7RurV8D/iRI
	Mn6GcSLvThSgYji/hJ1bPQnO+PItKOtN0ZsnHfstInXC5rC1hVaZ6YaPEsEdm0yc
	0R36LQL2uTJuSjbl9z/FM5BsolZktLXLkNXGb742PsVtn0O1xFxlsHd+7j9NJrAn
	JhBSW6gy6x+a9LlNZnrYw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793826015; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:VQs5dxAQ3E9XuUEr1jdpwBvFIZ7AE8BMYB+IYsMQzHX6avx
	bIKPbK8K6UMFoX+ptNeiWRy0EeVZf415PWskMe3UH1+cHXGS1jM/NdJAx8lYroPN
	t2zfvyFJC9+Cvz0O4rF8grQ7u5yACqZR/B8V6alkHpxxCusZMBZcAG0eWOMA7Wq2
	9QBsFFd+sQT+ufrApAfizw3iCD/qZ+1cLsFn3cDxhlJhRWqYvEqUSydhKaYuW95S
	fJqj4k4eMfvF0S9oLKroXTi0qKYNKa32PmUU0Qby8TSySBiPUgbsezcBCh+k5Mab
	ZtimRLhh8K1tsoyE9W3lHWMeFrB1KCthfEiXAJw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:fUmINlirdU2Tk6RCoHByTkIj3YlbxSUxiZjtoAUaQGk=:tYBOb+5dGuOjuQrd6XKBAFeuLK+8HRMkrzwfvErc19o=;
X-ME-Sender: <xms:2pzrapVO1PgXZib1J1FOBsiKZcp-1a2WMaiCzkWr12POCmkiMBllIQ>
    <xme:2pzrakYn6jOelhw810z9h7PtEocyxoQVs5edVa43zi1qGGxRlmYuFXHNs-zWUktAf
    1eaLGQCpfHbNQjIOw-5G3gdFqd4lzB-2-cTc4Rd0zl-ciJQRX21O57K>
X-ME-Proxy-Cause: dmFkZTEmmuOD0DZhwLvQ1jMu+N+9f1/bshj4za9fBQJ9CLi5nyqGXS3WVLocnYlOrqOSIB
    6FfId29nGSaJXnRDBuWEgopsKFsk9kKCdZMlOaAKHZiJOecJXJK5tvhHf4ExHC129SPRTn
    ywDnpmZfc6lQS9TUXA9FcCx2VPLS6+9LolLspxAgWuT9gBQtAauE01L1amFsAnhggz9Thz
    K4Y3OubtvjuJtHSnf7zo7wc1RCs2RvOov96x4Gnlg/5v1Dl92DGS7mO3qjvUBcf5+r+W1w
    M2Ah/4lcKnXI+AD7UM9xPoqDsnA90jhXogV/fJUgnmX/RUCq0OsQxlztOfBV5r2ctGxleQ
    P5q62C7C+Ai5m3jgBR8Ubc00tyJArfAVOnKr/LvHUrlJi8kOqvjG2g82xVHp9aqznRs3V3
    qL03F8W2Hy1HAOhL5fLwctcAInLF+bXJ6DMyIU9W9OVVQKGXo0PkiWCRWrFzYVMWb8g6fV
    eOAXmA93VZa4o3zcfq4qC55WNbV+Uz9zvISGAgRFmjFpNzNLlp+B8xe7yw0wZcaXUiz9CP
    FSjGKKuU4t5zdMcRPV6nUzYzMnaxK1H39SW4qpWKaXsgxT1D4VgfsnklufIjUbsHlO2R9H
    0wX5c25K5kQzHuWxQqT1Z6BAnytUuqd787ITw5dkM92Cg9y6+rLOuyjydRhw
X-ME-Proxy: <xmx:3JzrangpKATqgrFY9U5FKngYXRcRvPlOj3GrvzIj0yk4F1827md9hA>
    <xmx:3JzraqDv_f2Y3-RNnCmohuE0avDMpLZVmJc-xMja_czk7Lxx7RTNoQ>
    <xmx:3Jzrah4wqYWgSCUZ4-OLOKBLl26x6kjGdzjCooKYvcBTxAagK-vDaw>
    <xmx:3JzranGBXgwi1mFDP_mObr_pbEak_8hTCfhVqNcPvwprpGKJxslj8A>
    <xmx:35zralsJWlZ9ZXZAEn7SjmPWpVp6jklZ58NKQFrEjXOYvm9PpdyfvIPu>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 9380F32A0099; Wed,  4 Nov 2026 16:00:10 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AgP3mv5Dxly7
Date: Wed, 04 Nov 2026 21:59:50 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Thorsten Blum" <blum@kernel.org>
Cc: "Mike Rapoport" <rppt@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>,
 "Alexander Graf" <graf@amazon.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Changyuan Lyu" <changyuanl@google.com>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-Id: <34a03ed8-5b75-49b5-bfd5-e5cdf48dbfd4@app.fastmail.com>
In-Reply-To: <179382570401.2089669.6201187990672133004.b4-review@b4>
References: <20261104162352.140836-3-blum@kernel.org>
 <179382570401.2089669.6201187990672133004.b4-review@b4>
Subject: Re: [PATCH v2] kho: Remove redundant 0x prefixes
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4d31ebzo1weukiihnsb8143xa37ooweh
X-Rspamd-Queue-Id: 71CCD4000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793826019-745242
X-HE-Meta: U2FsdGVkX19NXW2L/2asVk/bvm/uuw1dAAiL6Yotuf+jnuvQUhi8X36/zPmvc/M03cv+oet5lQwUJ1S7bxndn2v116MLeki2g5i86fGwL8P+gG4AKBGo5LwAbeq4gpExaOC3BD4Wn06LNIN2cs3RLHzj5VXmZ0ZDCrxYORFEjYqRvVNwZ56p1XChsNnbMza/tab2K9gEfoXdf4TdQ8sfie+Vjnsd85jO+jMaqsoQWigYCKl/vVaVHtCW3r6X5IJv/YCKftmtX2QKjTd7mQMiBckI/Ltzq6HC8W1c/6F3Sck6qiILK4YxtQu1fIfCSyWS3l///IDgzLI3qxrsMRHUWgz/Vc57YPMr8xQnSnATnwQfIO5oqrOueyhd3sTi6n1PAa8EZBFamyi8e8o2nj2OXKW0LmObSsvPlPgvqRSiuJm7GKgGv1Z3nl5y+nGe3Df84Z6ayDtOPbT7l8J7Ec410Ox2qeJwCHXN+m7pJ/AwFJX5maxDEkat21ZoGoTC27GngwcJ+EtuwNLafTqtG8QfPUhRwlvL4omAQnW4fjPZ7i5djIato9rb3bFAK/8oWSNH05KTpk8+FUIjiVgoTnVTtiG6wVmuhUOGfMf85Zep8+k+37XOYrIBFAFjxW5kz+Yw52R2xnWmTUrnasPI5Jl3HnTsmvvYjkcmP/w0Dar+8Wmurx9ZwsE51f3p0VQLtkUKz2ayLxnfxM3M8xdUq28PeNXUABSFHfdX+1jWxv9ogsNm+UEk0QGEGbU6atpsxlQJvqriqsvf1vzUxfAX4IjNXaAUh01VZSybEz0yKMr/9Z8LuXaYx4Aqmbyq/l+7Ugv5+oW1moHk7Cq1LjTRQQRAmTSNNyvQX+jxt+5efV5I5aJMQx+t8mbvL57fz+32//sm6jVpKetnWbkf2WOZozmZWnoPvlX5s8t44+ZMkkIqMuKnI0avp7ttkwvlX92PBymGGzPNhR0wb9T6fdgj+0x
 kb5Hwjkw
 5MJPNC6/Pwr7QLESIfGnqHYVBKN0zgMQnyj7TQf0wADSADge/tJix7p5yuNNlgwE+rjExbmV3LHWM3S4UAfBLuOOMs6P9YbHyFnoyYJ1F7/t2AACivROhbHCWOXVqP7FnkM6B0AOiw7/oM0x1Y6paHlnztQJYBddzCi1Bk0+3YXfLp6Q0e7JLR/OP2JCoJKxHtnh5DsOclJEBpW0ZYxpxhRt2HkzATHaWPZXhGTj0UHfp9sPg3gLHxgsOhsyaHJOfLgQOy4y6UHawREVQsEB2JyuZRT+JoFR/lmCEiYNnMF0goXrUBZnTm4VRG+QBYLcsGUG7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026, at 21:55, Pasha Tatashin wrote:
>> The %pa format specifier already includes the 0x prefix. Remove the
>> redundant prefixes to avoid printing 0x0x.
>> 
>> Use phys_addr_t for size to match the expected type.
>> 
>> Fixes: c609c144b0e8 ("kexec: add KHO parsing support")
>> Signed-off-by: Thorsten Blum <blum@kernel.org>
>>
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index 6f1f55fe3181..6a7600a0a7d5 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -2010,16 +2010,16 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>>  	 */
>>  	for (int i = 0; i < bootmem_cnt; i++) {
>>  		struct kho_bootmem *area = &bootmem[i];
>> -		u64 size = area->size;
>> +		phys_addr_t size = area->size;
>
> I am not sure; having a variable size of type phys_addr_t looks strange 
> to me. Furthermore, KHO only works on 64-bit platforms because of how 
> our radix tree is designed, and we do not plan to add support for 32-bit 
> systems.
>
> I would keep u64, or if using %pa for u64 is still an eyesore, use 
> 0x%llx for the size field.

area->size is also a phys_addr_t, so using a local variable of the
same type makes sense for consistency.

      Arnd

