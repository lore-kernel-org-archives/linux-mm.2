Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C2FC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 17:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5247C6B008C; Mon, 10 Aug 2026 13:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FC656B0098; Mon, 10 Aug 2026 13:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43BB36B0099; Mon, 10 Aug 2026 13:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E6AD6B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:44:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B8E3160182
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:44:57 +0000 (UTC)
X-FDA: 85086085434.15.75CA152
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D67EE14000F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:44:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDhG6LdU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786383895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MP2+23zFvL9Yev7WTv4ThtH3GwLxgP0jNN2O9q9lsco=;
	b=M2WlAhs4d0oURrTBgZb14ubfgXa1OLGJQjHYgBJDpMAgPfgppszjH1xregAImJVzaFjN39
	WYkZ6aV9YMQPMGzDLe5EHOCl0/MKkQi6NwJWHXHFnw790kFALOFRiVC4JJfrPAwgc7r8tG
	c04hBm6MfA8gCAbHSnFFu4/OHJ5kUR4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDhG6LdU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786383895;
	b=hDxUXXetCcmW/Ln6ubGLTmt2Zux1RTFawS4ZezLhGz3eL3kJinjUCmb2KBOMFI05afsO0X
	QD3XWn6iIxz9eiuw3ITiqrKEl0niHt9INbYBx2pTpkYTxMwtl9CI//LThw/5H2jLR3joXG
	vtGGHMmuGhwEU5gJJOcUBM6jc4+ETBc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 850D2600C8;
	Mon, 10 Aug 2026 17:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D551F000E9;
	Mon, 10 Aug 2026 17:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786383894;
	bh=MP2+23zFvL9Yev7WTv4ThtH3GwLxgP0jNN2O9q9lsco=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TDhG6LdU+xmaROsqFck3hBtm6iNfonUwi9trFk34RupcKybOSt6P84/qzbjudd9Wu
	 evlBRW4nJ4HD0cll3MkA8vYdh0GN1X0UBLa8kl7uNslZW5quVAfTSogtkkhWJqAYuj
	 j7BA3bAWZpBSUxiQmPhfKrlPUpF8ouMqV6yQJoBzflBNPbfXGT9B47IkJtk2usAEJb
	 5JCsFPUcg5MjoJAiS2uk3tAlrNLp3Vdpc70GQjFvauDt/Wta74NeZghnfO0ZnasdzM
	 QKHvsZnV5iWN4njlQb4AEJEqQEycrrAzS7XJi2Nk1PiIGxYlteW+dasD4OpI51JJA1
	 lga2SFv2CjFQA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>,  George Guo
 <dongtai.guo@linux.dev>,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  shuah@kernel.org,  ardb@kernel.org,  guodongtai@kylinos.cn,
  kernel@xen0n.name,  graf@amazon.com,  loongarch@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,
  linux-efi@vger.kernel.org,  Kexin Liu <liukexin@kylinos.cn>
Subject: Re: [PATCH v4 3/4] liveupdate: luo_session: include linux/mm.h for
 virt/phys translation
In-Reply-To: <2vxzjypx6fka.fsf@kernel.org> (Pratyush Yadav's message of "Mon,
	10 Aug 2026 19:39:01 +0200")
References: <20260807103714.33074-1-dongtai.guo@linux.dev>
	<20260807103714.33074-4-dongtai.guo@linux.dev>
	<CAAhV-H4pK10ONo=viJyUJBiiFb_7pbB9LaNkQWH=83r+7E0iTA@mail.gmail.com>
	<2vxzjypx6fka.fsf@kernel.org>
Date: Mon, 10 Aug 2026 19:44:49 +0200
Message-ID: <2vxzfr0l6fam.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: ggxkkeyqwxhp8qec39uaiewq84n3abff
X-Rspamd-Queue-Id: D67EE14000F
X-HE-Tag: 1786383895-893219
X-HE-Meta: U2FsdGVkX18Oz+35X3vkQfR1Z348T9zvSetR6+EsypyArhgDGr/1dMD0oKYR85W23QUW34uZrBJtv7Xr2nhnUfXrx2SIsQQawe2tCLyuQbA45RJq2W1nOmiWbQwBIo5Sr99/POp50kIT7/oAO4bLVJ67M3KbmivoKKpkNjruPMjiEeL021RVNqQjIlwopp/ozo21Lmb11abJETzBa1YIHOjHZ/Qx/kjbpA4R8FM6S+WiPsDMGOPJ/RFObd/V+Dwicm0SHsbFC0gdJtBZ8OPHyephQ/HfPYsCN4eW60JE5bh3qrpV/0VLNfJBjZ30jtRF/QhmQY4l/Qi4EwxOvBrE+JJ2G9gx8Vl8yFXVohoRurNbUtGv/J7HlG/5WpiGlkqcBNI7daL1WafhY4pyWkQVSfbMkx3PWW/7us8idjCsjt8I/EZAdaX9d1DCcB8LbLAAycUsccZw7ZjDT3yb8JJVv/dd7PJaDs7GiY+emJVXD7GazDv8Wmo54nIjIvbF7UQRNKvbl51L8cgKdufjap1mg8CCU574aRQN9PydC8CkNLxLIHodDnGYkaIm8yS3BoP/0awev57KMC2ZaG1HFvBP+iTIZOUmWy/PSfexLLUuIXLGyyq6qlaAdqQ32cWDtLDPD4rqVYt04PZs4U0YyNTkHh2dJ7wrqMDDrVyyQgrB3ZtkBdISeynxfAO36uqn8UAEWwGcMFQcDbVniE+tU7Xy9iNNe7SKak7LqhYJRFSbSJx7eRc7E3qS3if8tiAcAmcFoYtN2ztGD6WceiiIOZXfsY3Ad5RO+D0IKiIBJq1WP1NvzM0v71BF461okO5WW3aPZeESPAdueyOad3schhs7lM3RndX0Jyr00HFEwWr8I8Jvv/QP8/nGxGyG+8tC/jOf/vJRYjgdOIptlbPPBt1KUdDivPApgXZRH4HP744cyOCqJ4g2PfmYp0KStKxMb65tM2qxRNDI43Yuv7aWHPm
 9/C3VeWW
 lV1sqOHzo0oXgcz2mm0QFwwELiDgnuStbp8NmaVZKmZTmAt9vdsTJr3J5PPcw4HUwdp5rM1+gBB+Vf48zAWGEm1O4j8dcgqZUd+WUTJQjNMdG0FTM4Mtdlk3RIGdpo3buYbBXrAHJzveuFFs/NpvppZNr8FuUMyN+68y5OoPYNtHNGgL+II1bow2GFPOw9iqtSYkfpA1gzQb/jU7HdQZfS9pKbUiJEwPkxVJFQ6HO4ct7u5emTE+19UqIziVKBOA9KsRUB8tc1FaY3tS/RTde6FlBRAoZMQjof4qHvPCWC7zTmautUH/pH0Wat09rM8KlDfoLK0ADOvVxfe1pjFKHYvhwTf1wScAKYYYj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10 2026, Pratyush Yadav wrote:

> On Mon, Aug 10 2026, Huacai Chen wrote:
>
>> Hi, George,
>>
>> This should be the 2nd patch.
>
> Agreed.
>
> With that done,
>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Actually, I take this back. Sashiko has found some problems. See below.

>
>>
>> Huacai
>>
>> On Fri, Aug 7, 2026 at 6:39=E2=80=AFPM George Guo <dongtai.guo@linux.dev=
> wrote:
>>>
>>> From: George Guo <guodongtai@kylinos.cn>
>>>
>>> luo_session.c calls virt_to_phys() and phys_to_virt(). On LoongArch with
>>> CONFIG_KFENCE=3Dy, these macros (in arch/loongarch/include/asm/io.h) ex=
pand
>>> to offset_in_page() and page_address(), both declared in <linux/mm.h>.

https://sashiko.dev/#/patchset/20260807103714.33074-5-dongtai.guo@linux.dev

    Is this description accurate? Looking at luo_session.c, it does not act=
ually
    call virt_to_phys().
    The implicit declaration error appears to originate from arch_kfence_in=
it_pool()
    in arch/loongarch/include/asm/kfence.h, which is implicitly included via
    <linux/slab.h>.
    arch/loongarch/include/asm/kfence.h:arch_kfence_init_pool() {
        ...
                    virt_to_phys((void *)kfence_pool), PAGE_KERNEL);
        ...
    }
    Could the fix be applied to the architecture header instead, to prevent=
 any
    other kernel C file on LoongArch with CONFIG_KFENCE=3Dy from suffering =
the same
    build failure if it includes <linux/slab.h> before <linux/mm.h>?

I at least don't see any virt_to_phys() or phys_to_virt() in
luo_session.c. So you need to go and take another look at what the real
problem is and what the fix should be.

>>>
>>> Since luo_session.c only includes <linux/io.h>, the translation unit fa=
ils
>>> to build with CONFIG_KFENCE=3Dy:
>>>
>>>   asm/io.h: error: implicit declaration of function 'offset_in_page'
>>>   asm/io.h: error: implicit declaration of function 'page_address'
>>>
>>> Add the missing include to fix these build errors.
>>>
>>> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
>>> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
>>> Signed-off-by: George Guo <guodongtai@kylinos.cn>
>>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>  kernel/liveupdate/luo_session.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_se=
ssion.c
>>> index f38b5b18f3f8..31490ac7b63d 100644
>>> --- a/kernel/liveupdate/luo_session.c
>>> +++ b/kernel/liveupdate/luo_session.c
>>> @@ -94,6 +94,7 @@
>>>  #include <linux/kho/abi/luo.h>
>>>  #include <linux/list.h>
>>>  #include <linux/liveupdate.h>
>>> +#include <linux/mm.h>
>>>  #include <linux/mutex.h>
>>>  #include <linux/rwsem.h>
>>>  #include <linux/slab.h>
>>> --
>>> 2.53.0
>>>
>>>

--=20
Regards,
Pratyush Yadav

