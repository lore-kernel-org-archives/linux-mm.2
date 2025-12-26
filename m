Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93A54E8FDA0
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 08:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA336B0088; Fri, 26 Dec 2025 03:18:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E016B0089; Fri, 26 Dec 2025 03:18:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49A26B008A; Fri, 26 Dec 2025 03:18:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 902196B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 03:18:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1BF561676
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:18:15 +0000 (UTC)
X-FDA: 84260919750.08.4E8720C
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2302F140008
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:18:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZpJ+9k2Z;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766737094; a=rsa-sha256;
	cv=none;
	b=oce6TtKjEqFXyhS57TsRFSh9s5qx7fkyqvkveWQluZFdCpl4f9Z4pThG/rXWEuHU1O9g/v
	GkbB5GPSoM11wgWe4UqkfozAUI95fczBnIXnTc6iqYXLEtorybyMOGyovyqc9jj0nTiMEL
	gThydWGo3zf6VQg6jr9Al4b4T8l6YUM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZpJ+9k2Z;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766737094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JH36Jd26SVBlEkAhzI6oalKPXgcV6AAodm3CS0hr3WQ=;
	b=qXqcLY4z5jMpSU6zTxcGY1FXtbUesnxj2yiKYdZNrlnFTNlXKTmh8GvqkMkkjT6v2hyg5l
	xFrceuHNMby6PGve89kNKeUYyNUzhOEp58yagOor72PZLa00nUgTnJCWgRLkpxSFV3Zft3
	uRN/DMuULNMDqKCN26AIeXjJRqt3zQM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766737090; h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:From;
	bh=JH36Jd26SVBlEkAhzI6oalKPXgcV6AAodm3CS0hr3WQ=;
	b=ZpJ+9k2Z+YgWMehdRDRUdctvWqKMs/pmLGsWASqS3DSsQnjWRsOdw5JJfi6jJxJEKv/w/yRrpygpYNNiauWBs+ZQ3pIj5b9Li1FUfVhqto1qUDR9ewERCxI49ddnSi9hHv0r/q50vkdBf/vtP7ziGlO/8CiM0PzLkeo3mtuJh3k=
Received: from 30.74.129.66(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0Wvgx7kD_1766737088 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Dec 2025 16:18:09 +0800
Content-Type: multipart/alternative;
 boundary="------------AERpyX8l517h3WNYUREJdZEf"
Message-ID: <915dc88b-9131-4520-a2f2-facadc887bbd@linux.alibaba.com>
Date: Fri, 26 Dec 2025 16:18:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] arm64: Kconfig: enable ARCH_WANTS_THP_SWAP for all
 pagesizes
To: Barry Song <21cnbao@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com
References: <20251226063759.4020782-2-tongweilin@linux.alibaba.com>
 <CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=k8FSFgbH3Q@mail.gmail.com>
Content-Language: en-US
From: Weilin Tong <tongweilin@linux.alibaba.com>
In-Reply-To: <CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=k8FSFgbH3Q@mail.gmail.com>
X-Rspamd-Queue-Id: 2302F140008
X-Rspamd-Server: rspam03
X-Stat-Signature: 6quitzobdrwdxdp9f5uo1uqrn9h3db1m
X-Rspam-User: 
X-HE-Tag: 1766737092-660937
X-HE-Meta: U2FsdGVkX1+CdX1Jp3JbF2UPv2GbjPvAC48omJww5i6/SSkH5/GWZwO2hIN0N8U5c6XNC678FiauHWSOy16WNW5N0R49AHAaACfkAJwnJ1j+yLAiDhV1tkr+kcsyvuzCZhdRc6CyTQ747soorsibGDX81KJoPAVzdis/gaefr8Q+xfp/iczUcP8zAHjxMueGWWTr+1jcNYjVSuYiMmeRj+rNoATHec5etx4K1h0glJvvIHRsBEUVNAwVxJ8/paLGsqk58pWA/IehMaSY+s2GEiAshcoFTsRmdnCFjsptcCCZovBQbGUYxtSeRCbFlSwycv2U9FnkeV1HePSEadltSNvKagDai/OmCCmUjmJYDfJfgYKtmgQntaixbRR4Ag0EenLu4iLw9Ew/wMLB0efV1d8QnQb4aqoyMW5U43u859XGw9FF/2+7RInbZoAVd7D+Lvk+a2Biwv21hT6K5jwxFG+goTGaCz4hUX3U6MNfAJR6dOz4Y0wGO3VYe19XmFLMy6g4ohDOZFkSZAKW8eJ3PZCkRF7oamdk+iCcprHcLtOlvLrGwUY7HGdvD+jCS8rnq1Tucwawp0pWpywqqHudN6mOVE6TIWx6i1+D2NPwjlmHTcaj+NdlYmQOJYsZ5KZymtVNIj5WGaa84aTi1DDJCSdrquP9iav3ks7o2CElNbL3KaMkZ7LN4I+ahayc7OhfG8w9SNn4aAmnOiCGwM2Y/m8OIp3lXI4EVZ+4UcskWwtAVPtQfcfwBI7xXygmvN9cmnhhvhmy+ZxHzMOCDAIRo1wtijZ9djsJ/dKWL0C4kmUbg5jan11WuQNMIZCZCaA+39VhDQfKW5/ysE2PWxpmzwGxuSVGaqxegiNav/GLqoU86HPekdfFMjTjaZ3rdrdrdFbH5Zq8dkUGRVX81eNsT++N+tVGsX/Tt//chfBlpshMltsYWGdQ9KIPuOG7/CB7MSntmn5+ANpQz+IBz4x
 rfF625U7
 SIGLI8ppMfLKBmErNgUWxNSZkedru8kC6iTNsEiZezps4h1Dbp4gRZZ/LrKXsH8Wrb0MdTXqLHJexliwaJTfRHHf5+f0ydEsSo+aCAGxiFVbApXXUdMXZufippPq1OSDKnLBIZbclxh9/4JZUZ0XMIwyZ4wFEqjnmcM1c02nDv0z5OA0Kj++dzIqRvT87hpT4HuKBvXTUDKvc62LSKTVsLi7LUJsmaP0JYtK+VNzZGyMvC8aUO+jugt1FUa3JQ17t3lE/LBDmOQvaKzSTZjUvCXwlKM6q9rTb2yhtzyC95x2NIx7shIcXYg1pgNlmTE09GkpTkgG3PWtKR1si7a+m6BdAbgrOkr3uAv/af7bCZPFWjK8NHtG1YCFWKCnZuOHUSTzidtPtanh6x65NDV4YFYKmKkkd5tcBLlbNENTO7QCFtRcWBNhDC7rR4CqtNqdgOaOzZ/KWtEDMddJoyOrmq0C++QIKPRoJFlsYzJcSO+1hFqn/qdLJhQ+KHZ8mgZCqlILGWK1paTCCaYN7SLRKLUCGh9ZcGQE12wBZ81LmiVc4DIlX6Ug6SUFbLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------AERpyX8l517h3WNYUREJdZEf
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/12/26 14:52, Barry Song 写道:
> On Fri, Dec 26, 2025 at 7:39 PM Weilin Tong
> <tongweilin@linux.alibaba.com> wrote:
>> Currently, ARCH_WANTS_THP_SWAP was limited to 4K page size ARM64 kernels, but
>> large folios requiring swapping also exist in other page size configurations
>> (e.g. 64K). Without this config, large folios in these kernels cannot be swapped
>> out.
>>
>> Here we enable ARCH_WANTS_THP_SWAP for all ARM64 page sizes.
> I no longer recall why this was not enabled for sizes other than
> 4 KB in commit d0637c505f8a ("arm64: enable THP_SWAP for arm64"), but
> it appears to be fine, and the swap cluster size should also be
> more friendly to PMD alignment.
>
>
> #ifdef CONFIG_THP_SWAP
> #define SWAPFILE_CLUSTER        HPAGE_PMD_NR
> #define swap_entry_order(order) (order)
> #else
> #define SWAPFILE_CLUSTER        256
> #define swap_entry_order(order) 0
> #endif
>

Thank you very much for taking the time to review this patch during the holiday. Wishing you a happy holiday as well!

I appreciate you pointing out this optimization. 
We initially noticed the issue because, on ARM64 kernels with 64K page size, 
if large folios are used in shmem, they cannot be swapped out as a whole during shmem_writeout() 
due to the config limitation,
and are forced to split instead—which is something we wanted to avoid.

It seems that this change will help enable better swap operations for large folios. Thank you again for your feedback!


>> Signed-off-by: Weilin Tong<tongweilin@linux.alibaba.com>
>> ---
>>   arch/arm64/Kconfig | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 93173f0a09c7..58f7b4405f81 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -120,7 +120,7 @@ config ARM64
>>          select ARCH_WANT_LD_ORPHAN_WARN
>>          select ARCH_WANTS_EXECMEM_LATE
>>          select ARCH_WANTS_NO_INSTR
>> -       select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
>> +       select ARCH_WANTS_THP_SWAP
>>          select ARCH_HAS_UBSAN
>>          select ARM_AMBA
>>          select ARM_ARCH_TIMER
>> --
>> 2.43.7
> Thanks
> Barry
--------------AERpyX8l517h3WNYUREJdZEf
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DUTF=
-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class=3D"moz-cite-prefix">=E5=9C=A8 2025/12/26 14:52, Barry Song=
 =E5=86=99=E9=81=93:<br>
    </div>
    <blockquote type=3D"cite"
cite=3D"mid:CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=3Dk8FSFgbH3Q@mail.gm=
ail.com">
      <pre wrap=3D"" class=3D"moz-quote-pre">On Fri, Dec 26, 2025 at 7:39=
=E2=80=AFPM Weilin Tong
<a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:tongweilin@linux.alibab=
a.com">&lt;tongweilin@linux.alibaba.com&gt;</a> wrote:
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"" class=3D"moz-quote-pre">
Currently, ARCH_WANTS_THP_SWAP was limited to 4K page size ARM64 kernels,=
 but
large folios requiring swapping also exist in other page size configurati=
ons
(e.g. 64K). Without this config, large folios in these kernels cannot be =
swapped
out.

Here we enable ARCH_WANTS_THP_SWAP for all ARM64 page sizes.
</pre>
      </blockquote>
      <pre wrap=3D"" class=3D"moz-quote-pre">
I no longer recall why this was not enabled for sizes other than
4 KB in commit d0637c505f8a ("arm64: enable THP_SWAP for arm64"), but
it appears to be fine, and the swap cluster size should also be
more friendly to PMD alignment.


#ifdef CONFIG_THP_SWAP
#define SWAPFILE_CLUSTER        HPAGE_PMD_NR
#define swap_entry_order(order) (order)
#else
#define SWAPFILE_CLUSTER        256
#define swap_entry_order(order) 0
#endif

</pre>
    </blockquote>
    <br>
    <div align=3D"left">
      <article class=3D"4ever-article"
data-clipboard-cangjie=3D"[&quot;root&quot;,{&quot;copyFrom&quot;:&quot;i=
m-native&quot;},[&quot;p&quot;,{},[&quot;span&quot;,{&quot;data-type&quot=
;:&quot;text&quot;},[&quot;span&quot;,{&quot;data-type&quot;:&quot;leaf&q=
uot;},&quot;Thank you very much for taking the time to review this patch =
during the holiday season. Wishing you a happy holiday as well!&quot;]]],=
[&quot;p&quot;,{}],[&quot;p&quot;,{},[&quot;span&quot;,{&quot;data-type&q=
uot;:&quot;text&quot;},[&quot;span&quot;,{&quot;data-type&quot;:&quot;lea=
f&quot;},&quot;I appreciate you pointing out this optimization. We initia=
lly noticed the issue because, on ARM64 kernels with 64K page size, if la=
rge folios are used in shmem, they cannot be swapped out as a whole durin=
g shmem_writeout due to the config limitation, and are forced to split in=
stead=E2=80=94which is something we wanted to avoid.&quot;]]],[&quot;p&qu=
ot;,{}],[&quot;p&quot;,{},[&quot;span&quot;,{&quot;data-type&quot;:&quot;=
text&quot;},[&quot;span&quot;,{&quot;data-type&quot;:&quot;leaf&quot;},&q=
uot;It seems that this change will help enable better swap operations for=
 large folios. Thank you again for your feedback!&quot;]]]]"><font
          face=3D"monospace">Thank=C2=A0you=C2=A0very=C2=A0much=C2=A0for=C2=
=A0taking=C2=A0the=C2=A0time=C2=A0to=C2=A0review=C2=A0this=C2=A0patch=C2=A0=
during=C2=A0the=C2=A0holiday.=C2=A0Wishing=C2=A0you=C2=A0a=C2=A0happy=C2=A0=
holiday=C2=A0as=C2=A0well!</font><br>
        <br>
        <font face=3D"monospace">I=C2=A0appreciate=C2=A0you=C2=A0pointing=
=C2=A0out=C2=A0this=C2=A0optimization.
We=C2=A0initially=C2=A0noticed=C2=A0the=C2=A0issue=C2=A0because,=C2=A0on=C2=
=A0ARM64=C2=A0kernels=C2=A0with=C2=A064K=C2=A0page=C2=A0size,
          if=C2=A0large=C2=A0folios=C2=A0are=C2=A0used=C2=A0in=C2=A0shmem=
,</font><font
          face=3D"monospace">=C2=A0they=C2=A0cannot=C2=A0be=C2=A0swapped=C2=
=A0out=C2=A0as=C2=A0a=C2=A0whole=C2=A0during=C2=A0shmem_writeout()
          due=C2=A0to the config=C2=A0limitation,<br>
and=C2=A0are=C2=A0forced=C2=A0to=C2=A0split=C2=A0instead=E2=80=94which=C2=
=A0is=C2=A0something=C2=A0we=C2=A0wanted=C2=A0to=C2=A0avoid.</font><br>
        <br>
        <font face=3D"monospace">It=C2=A0seems=C2=A0that=C2=A0this=C2=A0c=
hange=C2=A0will=C2=A0help=C2=A0enable=C2=A0better=C2=A0swap=C2=A0operatio=
ns=C2=A0for=C2=A0large=C2=A0folios.=C2=A0Thank=C2=A0you=C2=A0again=C2=A0f=
or=C2=A0your=C2=A0feedback!</font><br>
      </article>
    </div>
    <br>
    <blockquote type=3D"cite"
cite=3D"mid:CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=3Dk8FSFgbH3Q@mail.gm=
ail.com">
      <pre wrap=3D"" class=3D"moz-quote-pre">
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"" class=3D"moz-quote-pre">
Signed-off-by: Weilin Tong <a class=3D"moz-txt-link-rfc2396E" href=3D"mai=
lto:tongweilin@linux.alibaba.com">&lt;tongweilin@linux.alibaba.com&gt;</a=
>
---
 arch/arm64/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 93173f0a09c7..58f7b4405f81 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -120,7 +120,7 @@ config ARM64
        select ARCH_WANT_LD_ORPHAN_WARN
        select ARCH_WANTS_EXECMEM_LATE
        select ARCH_WANTS_NO_INSTR
-       select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
+       select ARCH_WANTS_THP_SWAP
        select ARCH_HAS_UBSAN
        select ARM_AMBA
        select ARM_ARCH_TIMER
--
2.43.7
</pre>
      </blockquote>
      <pre wrap=3D"" class=3D"moz-quote-pre">
Thanks
Barry
</pre>
    </blockquote>
  </body>
</html>

--------------AERpyX8l517h3WNYUREJdZEf--

