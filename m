Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 705B8C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 17:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8E06B0095; Mon, 10 Aug 2026 13:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69F6D6B0096; Mon, 10 Aug 2026 13:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDB86B0098; Mon, 10 Aug 2026 13:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 300136B0095
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:39:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5711120261
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:39:08 +0000 (UTC)
X-FDA: 85086070776.15.7A89EF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id F3E8E100014
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:39:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XwJWbYMf;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786383547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jk4/iqf3QlrsL8m2XoV0Xf9bF4tI4hIm7T5gSdo0XHA=;
	b=bPYuyb+4thoQuAmLey0mItlW63ytpLq8F6oi+TLZKw2BlU7p0ZDAdxVbD3fonrqx3LmdX6
	+u4sq2Gh6jgrC7SFwKkTeVjTUVj5Zbu8+VQ1FcTz+tORTnU5+BGh/zlDxvISMI2moPXho7
	TGTOw1rnhh9G3MQzRf1Oy+riPhWxkeE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786383547;
	b=cWBWkdenU2/YNCXGSxAnz05ykZ+57WFYUt5HIWTb7djB4zqdA2POs+besuLiGbWNW/QXoJ
	dHa/IPkddeccePAB4/oW+MmHYKYTogSR6/bEjViVgi9yw6JpI06RBo2bSbovJriL5Wj8A+
	pXu65tnYLNdrTsdqUkysSxLOJNDx0Ks=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XwJWbYMf;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0669C4402C;
	Mon, 10 Aug 2026 17:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F51B1F00A3A;
	Mon, 10 Aug 2026 17:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786383545;
	bh=jk4/iqf3QlrsL8m2XoV0Xf9bF4tI4hIm7T5gSdo0XHA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=XwJWbYMflVEGgLIja1EWAoDBtXPLApa/NkhtMQDGRnVjjt8ci9J1uJS4baCLClDhH
	 JhCTVMEaM4RnoWd5AE7v1RSt4+WHhsIMue+11gnSAPlkTWA3jsm/MztKnqM9HYEeYg
	 F3HSfe9YPb6L13yci31ejGgFbBoYJK2sLluFBiRbBIi3K1112oKRwXmMH8XCDjiNUL
	 O4zDHyOMnNvMLmr5Ff9Bj2+8yk4LsoiqXXgEIHKDsq6F5hm/JS2p/xGzzmlILvoWnP
	 Ji1fJM1uOHgWg47TYrlX+f49ixOfpnWV5UxPoLlXiAw19dKwWcQVnkKgo3rIGsRrsP
	 InFqbiVqMUrdg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: George Guo <dongtai.guo@linux.dev>,  rppt@kernel.org,
  pasha.tatashin@soleen.com,  pratyush@kernel.org,  shuah@kernel.org,
  ardb@kernel.org,  guodongtai@kylinos.cn,  kernel@xen0n.name,
  graf@amazon.com,  loongarch@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,
  linux-efi@vger.kernel.org,  Kexin Liu <liukexin@kylinos.cn>
Subject: Re: [PATCH v4 3/4] liveupdate: luo_session: include linux/mm.h for
 virt/phys translation
In-Reply-To: <CAAhV-H4pK10ONo=viJyUJBiiFb_7pbB9LaNkQWH=83r+7E0iTA@mail.gmail.com>
	(Huacai Chen's message of "Mon, 10 Aug 2026 22:37:25 +0800")
References: <20260807103714.33074-1-dongtai.guo@linux.dev>
	<20260807103714.33074-4-dongtai.guo@linux.dev>
	<CAAhV-H4pK10ONo=viJyUJBiiFb_7pbB9LaNkQWH=83r+7E0iTA@mail.gmail.com>
Date: Mon, 10 Aug 2026 19:39:01 +0200
Message-ID: <2vxzjypx6fka.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 4jo7uimds76w6ktnczau9e7j3qfxmp84
X-Rspamd-Queue-Id: F3E8E100014
X-HE-Tag: 1786383546-83007
X-HE-Meta: U2FsdGVkX1/YNii2UuHKPuN5yvR9wifuru/TQM1thBsK2huStxVNmK4qc2AhZZzJN1FqvawDU+9wcduWKOtvr/L9lPIHg/kWtxaW2K6Vg28zcWQco+2CIl/5QUY3X4KQ8TUe9LJ9Kp90eqlr7q5w93jWXsUF8BF/NKtKuiu5O0wxis9Gzk/y3gH7p+9HbtASyVaptPi0ndsK8OXMgJ+azF2s3ZUxLue3vOk6xPEEmN87/w07ZSCLxWw50YgOh4+4kwcUvDiPX1A0+4VnZuPRq4mxgWA3sqfqKtyk7vg6lrDeA30QhoN0ZwRDECTGcf03Yeh2We3vsue3X8SHhNaMe0P5PFIXuAyg+ZAPiHEFm8wb1IZ77G0D45HzM7rbraMmn+CgtfALyBuUPys7HhYN0R5aKjdG/a/Tii+4a380NY6Y1SZlLKMxH1MLIBohWwebhNRZFwuhfusJhUmAo5NhJzQJDtOyyTXN7vxuEAa8qWOGudSLM86KZgUYvAt1Fm/KIHuapa7rDt6x7dROmV5rBwxaua7gHZBSn51M+Ga3HH7BhRcQujItgdvPOkbhJEtVTPAfUC6CrpgHXX53MPOimBExQRN8psL34jzw/1g8uTbCicrGIjGdeZyDjmQjyghodKlQpQL5p9tG/EiDtAEq4/zd6pZ1eIYrSZuH0jKW5rAWdBDhSxppvicIhBn471mbXgeWYs7r3gEZIhxs4/SXDGG34DxS0haNhRLRmWJsW8qW0J9lQTVQW+LHfZoEoAsWLRIAEHyR9NR54f0b11/egnZ/dwnLAjhwEquMoxBrANBDDTzqbwYexfyXZC0pn64jFTjV5X87dxNasW1nzxliCA7aKatqb+ogecjdW6k0jy2NMix1NLPlBYi4XlrB3HgGexOKJb57Um8gJD+NX4Kquti0AFSQ/SItHqqaSx+i3N9I3Jyy29AC0S+LsH1/H2OrF6H9NZc/HVsby2B4ERx
 wPD5V1vp
 4jtZ3k2lTJP2WItyKkqhJjTkhEAFZ04l360k9TaACAS748IrpX13g0iYj87GMU/tnWOMzuMjFmFClXiAkRTCixWou1Ub02Oce5h9giIE1bvwi/VLF2DpMD8jdo8uQ4lMbmL2cIe+YCiryMdGsRiRcgPfJyZM/2axFTLnaiSJ/hU9SSZ54fki6vbqernYONrLZl/4yONNUHkD2t6CsQKR+ysHayl6//m4oLSwBz7RgEdJMRbVEetkAI6P1L6LwNllp0xc7o8htR8AkxSQRZpm5KiNZxA2wzE741yX8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10 2026, Huacai Chen wrote:

> Hi, George,
>
> This should be the 2nd patch.

Agreed.

With that done,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>
> Huacai
>
> On Fri, Aug 7, 2026 at 6:39=E2=80=AFPM George Guo <dongtai.guo@linux.dev>=
 wrote:
>>
>> From: George Guo <guodongtai@kylinos.cn>
>>
>> luo_session.c calls virt_to_phys() and phys_to_virt(). On LoongArch with
>> CONFIG_KFENCE=3Dy, these macros (in arch/loongarch/include/asm/io.h) exp=
and
>> to offset_in_page() and page_address(), both declared in <linux/mm.h>.
>>
>> Since luo_session.c only includes <linux/io.h>, the translation unit fai=
ls
>> to build with CONFIG_KFENCE=3Dy:
>>
>>   asm/io.h: error: implicit declaration of function 'offset_in_page'
>>   asm/io.h: error: implicit declaration of function 'page_address'
>>
>> Add the missing include to fix these build errors.
>>
>> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
>> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
>> Signed-off-by: George Guo <guodongtai@kylinos.cn>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>>  kernel/liveupdate/luo_session.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_ses=
sion.c
>> index f38b5b18f3f8..31490ac7b63d 100644
>> --- a/kernel/liveupdate/luo_session.c
>> +++ b/kernel/liveupdate/luo_session.c
>> @@ -94,6 +94,7 @@
>>  #include <linux/kho/abi/luo.h>
>>  #include <linux/list.h>
>>  #include <linux/liveupdate.h>
>> +#include <linux/mm.h>
>>  #include <linux/mutex.h>
>>  #include <linux/rwsem.h>
>>  #include <linux/slab.h>
>> --
>> 2.53.0
>>
>>

--=20
Regards,
Pratyush Yadav

