Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F59BC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F106B00C2; Mon, 21 Sep 2026 11:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E61A6B00C8; Mon, 21 Sep 2026 11:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3DEE6B00E2; Mon, 21 Sep 2026 11:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D15316B00C2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:33:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63D7A1401ED
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:33:44 +0000 (UTC)
X-FDA: 85238164368.05.863F42A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id ABCB780002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:33:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="efgwaB K";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790004822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ECga6oDpoCruvyTKSpfjLdMo1wBocXlUoX6lA7eLn7Y=;
	b=UnO3Z4SYU8i5TDqOabWeWGaBWq/OTZyojWIEpkbnemMNX7eP88GzXZ1A6mB2AdS/p1wREx
	UwKLwRfB21YtW3uUJv+CxKFGSxLDOrMP1zVGJc7S3uk8074sz2IF+w2kw9u/fE9fhC0jYV
	NWtthGEFXjyQIG6FYv9KbkpjMwerYco=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790004822;
	b=ohl1HhqAT712BH2ttbdEdQse5ZhGqImSKU2utIBRWqVg/4gKWDBNbINZ1ztFqkrvIFLQSw
	eXz7byMVM9bxNc7saQB90tNv4cwGEIQ46iElSW+U7+4COO2AmVQjG+43jSrSqC5xLlKgym
	su2aEfzxEByVi9xDeQNixspdOu1tlus=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="efgwaB K";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=ECga6oDpoCruvyTKSpfjLdMo1wBocXlUoX6lA7eLn7Y=; b=efgwaB
	Kkp8U69RMu9ga/r9YVd2154V7Qfkh9sTTMQNQBFdl2dHB4xFcwxIAqj8a9RghJaLSqG2s4Z+fiFff
	zxWyOF6kYoI+Lv3SUjDp7cMZBfZl0qwMDpiKXBX/nsYvT9nIEdrJA29VspiDjz1BNCpaYmRHPYVvC
	n/HgcL9zB+Kj/dS2BgV1T6KCwegd86XvB589ElAvWnNFqyEm1D7qZaq/2xvqLg1RgDDzZRkgVtgzJ
	myGRxsnHIO4J99uyCl2mavzcKjOo6GzaD7GFdFmnU/GkmOlUXlFu1OlWGgZxsW1Ex5thke8SuE6w+
	agrU0syzmCcVpxgJwBh6LD0xeZFg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x8fvt-0000000D3Zy-41sO;
	Mon, 21 Sep 2026 15:27:53 +0000
Message-ID: <f3af5902412b9ff1c1a37211eeeb9c0ffc22f814.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Gregory Price <gourry@gourry.net>, Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Michal
 Hocko <mhocko@kernel.org>,  Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
 David Hildenbrand	 <david@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi	 <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>,
 YoungJun Park	 <youngjun.park@lge.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)"	 <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 =?UTF-8?Q?Baghdasaryan=EF=BF=BC?=	 <surenb@google.com>, Qi Zheng
 <qi.zheng@linux.dev>, Axel Rasmussen	 <axelrasmussen@google.com>, Yuanchu
 Xie <yuanchu@google.com>, Wei Xu	 <weixugc@google.com>, Wenchao Hao
 <haowenchao22@gmail.com>, Jonathan Corbet	 <corbet@lwn.net>, Hugh Dickins
 <hughd@google.com>, Baolin Wang	 <baolin.wang@linux.alibaba.com>, Tejun Heo
 <tj@kernel.org>, Michal =?ISO-8859-1?Q?Koutn=FD?=	 <mkoutny@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan	 <kunwu.chan@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, Linux Memory Management List	
 <linux-mm@kvack.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, 	linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn	 <joshua.hahnjy@gmail.com>
Date: Mon, 21 Sep 2026 11:27:53 -0400
In-Reply-To: <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
References: 
	<CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
	 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org>
	 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
	 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
	 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
	 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
	 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
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
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ABCB780002
X-Stat-Signature: fqxton8mhw1ktmyupu885gwy9g4uri1k
X-HE-Tag: 1790004822-348055
X-HE-Meta: U2FsdGVkX19iAaGGcQkDU+JKock33G3ES4Xr+1jV/RJRHKQXSY2LpAs733jmdBFIpSy8sRQdvRAejuaQpMnBzmPuQraAvU/Bs2XsiVbI1LtEGuRFHxo1wKKLbYbWlor2wD/hs9OYIFfq2/CnNn65J7z4ydy4jQKfFD/ouk50dtHzpy4exxvBAh3ek8Q1o/Hjj2mUP5nr+F8VZhDPiUC20jHmV44GIufmBbWVnybjTrBnozkwI8+1zPkVGAMAuaxeKYwB12+lBl21n/vGfbfhPY22kXb9D99aXcYf/67gWB2RD3pZSETHELMHxm+yY6Wrhlnd+8Y+ea6b4gq6CE86E5W3BMeMGl4/RKy4qqoAdxr/PyMud/N4wSxlR2JgPQEyCACsqdXNmmx+Ch7DgtFstZU39AcuHywfH3wX6MOeA0GwzWLdoousUqjQjSac5+f/QdrD08sncTPskH75G8gtHXUxJFwuvRaDMTFMIJg9p5bVTOG9pohtpxu8iEuJKgQqHwDCR3Ij/2mk5C3z4X1V0w/OlpY+xlgUuc34ZquH2Qfp/t6Rvaf6o2bysNz0H+0i4cp39D81LMOGKjgfJtHkFUl8SSJ/nxUATuXIA3pQq0LL1Hf8xbg8AZidq9Mzu3RbK0k8hMDyTbXQ4dZblpna4K+5SjGX60Il1G0QSQtwQ91rmolqQqd6vBOcLztDI1kpSm3d9xmymudKBNrJx2B64HMSdj7UfrvXnOc7iwOf3ixTqf7I+uUMZKHrqHlVSSsgSNhi1fgLQ3KynutjvXGQeRLVtge/Hqa0URSaWl+ydi+6zCT+p2buBfBpo/1gin0VBsYCJeLU/K+MiSL1ysFMZx2bRUd1KSo8SiyrRTp4YT/PFUOPFu7tmlOKME9Il6RXalUgVBf788NLrgNLT8/pVXF2PDVoGE74cwOfluexTkV+tus4RzYKbGDyFaoKWvDS7y2OIG/UlvJaOEpTS7Z
 HMFgHjt/
 3EQ4vqX53lBsZzv8nywRbj5hFiDvMNp188Lqq/apc/UrLJCoySv9sGn++hY+Uh34MTU8Q62gICIIlNQtXXi92kWJl8ePqecvSu4zX4n6c1w+DtF5uMhQ8pxTVBiLNVcDDDPYRWNHYXzvkVr8KnukhEx6SNdyMZoi82n+3WbIrQ07X1EkS4Zz/0Ibd4mg/nLJ7OTa+22w/RyORsTFvPNH7JecDz9by+O7lIHa56XaooKDkNdXmQJgU3M5jKVnqsnKbiOxFysj0Qe4YzMIPye/WKsnDm4fb14Rz3xpBjApZpJUoyQOeDm9BmB5TZrhKLA44WUU82sUN7RmAQmwPFCgq9EZUE/S7KjOUzZTT6lnD8ExSdB5eq43KgbKI0zA2zPC9dFn+vOTaXOte4iRledy7PlnS6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-09-21 at 09:27 -0400, Gregory Price wrote:
>=20
> In short:
>=20
> =C2=A0 memory.swap=C2=A0=C2=A0 =3D logical swap=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 - workload/SLO limit
> =C2=A0 memory.pswap=C2=A0 =3D physical swap=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 - storage limit
> =C2=A0 memory.zswap=C2=A0 =3D compressed memory=C2=A0 - RAM limit
>=20
> This would preserve the existing memory.swap semantics while allowing
> both backing resources to be constrained independently.
>=20
My first thought was "this is confusing", but
after a minute I realized that most users will=C2=A0
never set those options to anything=C2=A0other than=C2=A0
"0" or "max", and the few who do only need to
touch one of them.
=20

Some people may want to limit a particular
workload to having no more than 8 GB in a
place that is not directly accessible.

They would set memory.swap =3D 8G


Other people may want to limit how much
memory is used for the zswap pool.

They use memory.zswap.


Yet other people may want to limit how much
physical swap space is used for a particular
cgroup. They use memory.pswap.


Almost nobody would use all three.

Which one you use depends on your use case.

--=20
All Rights Reversed.

