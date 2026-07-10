Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D56BC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 10:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A7E6B00B0; Fri, 10 Jul 2026 06:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DA186B00B7; Fri, 10 Jul 2026 06:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1066B00B8; Fri, 10 Jul 2026 06:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC89A6B00B0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:04:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D7631A03D0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:04:59 +0000 (UTC)
X-FDA: 84972433518.26.6F0898F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id ACD4E4000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:04:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ie60D7jw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783677897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgZnDAnuIUe+VsLcYkmYHoPuByp6JTttJ+s/wN6QkWs=;
	b=lu627sYp3dvTQttnv3w4tixwrHEBHKt7wWcNSDnhHd+pOIvFBgHml0HTMN9WstTIFQMyou
	pgo5p9UjXFuytJaeTVL5G5YkBN50BToAXFoSLStw++go/GJVrQhAUYLUmq6YUKOs+qFTQZ
	t+SbtUFq9kyTY027OmTFBcqMinT1Dfs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ie60D7jw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783677897;
	b=F/YqbJkZ8O6yXEUJBB5CFfntXhnPKsxZ42vAKguhGMEXKMHoYgK+irfAtOsj7FK8O75hBS
	dK9rVw/IdhAF4efJ/XLI7cdYSOlDhOYAZHf2G4XYq094bLdM4XMbSpV80wfNLdQrsY32zE
	9IxzrTzPfERuOTUAiafChGX7wnFwQ5A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D500D42DB8;
	Fri, 10 Jul 2026 10:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F581F000E9;
	Fri, 10 Jul 2026 10:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783677896;
	bh=bgZnDAnuIUe+VsLcYkmYHoPuByp6JTttJ+s/wN6QkWs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ie60D7jwHXr0cwpVpB39AsLHpinVOftBTuCsLvaFpZyd/bAHic2eYaQzzZ7GyrRcX
	 DrVQB+d5iuEN2nMy/oHP2o2aHmTEBM+zPzyMvxghrQMxRftKjwfVZYhTz4dwt6eU9M
	 DzsbXPdc8iGPiphuEaqBfob5oK5uocTxYzxLfqGvpvtpl2EDsNiG4NrC6hYD6ugexS
	 xoQiHWM8rmkwh22ZhZM8HZTyvDyvT9sqfCdgdjp8ghrskm5NP+Vy5OH/gj07yVUk+k
	 B8Z8eWFBtRK4ZXBmmFdd0r6SFM0yBL6yMgatt+C27DMK8YN4D4VQuzp2PyU+L7AOqM
	 jRYQ+xP65CmVw==
Message-ID: <292ffec0-6a6b-451d-8977-3a5217c65d2c@kernel.org>
Date: Fri, 10 Jul 2026 19:04:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [harry:kmalloc-no-objext-rfc-v1r1] [mm/slab] 6bc21472e7:
 BUG:kernel_NULL_pointer_dereference,address
To: Oliver Sang <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Danielle Constantino <dconstantino@meta.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org
References: <202607091002.cdfe5a08-lkp@intel.com>
 <afe80d38-950e-44d4-a729-61aa65d3c117@kernel.org>
 <alCddXaJ4HkjZNXi@xsang-OptiPlex-9020>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <alCddXaJ4HkjZNXi@xsang-OptiPlex-9020>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------V6m3WAHSMa9Jv1iiktisZNM2"
X-Stat-Signature: 4uy5dyejqjm1bty4y5mcco1r5jykd8t8
X-Rspamd-Queue-Id: ACD4E4000B
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783677897-787510
X-HE-Meta: U2FsdGVkX18PuS0h2YijbF4M2r6B57DG0/zJh41ApJENs7Jh2OkEeScVDQg5zCtWqu1vBx531MLP8s+2OTMHfj/x7v2qROGffOqH6fIqmc4hGjcpVwyPT+CipL/gmwSU37vIU6nGN1FwHgFFLeGGdgruLkqJYt+nHUBzPSSkNhxnBo4HtBGMofZIA7vlXSm5eS/54lB/w/B8zt2E3pQ9FZRY/2xsSVaaL0YzMbD0UAT5UqFrpXk1xGUUn2VwoSEfTse6+0P7y0CiR7Ys65iqZvkW+8FwlbDV8wj0qnxO2zfxPctGWaFF6nRgYRJ2txnf/liviPnD9yRdHk7issSxbqavmq2vudox18MXuHiXhEjGYeZJ/f7NTCae9OJvwXqppJRfVvn+ha7I7hmUkiOwKZDYOjROOjhvV7m/eUvXIdaq4mULI0WEQlXzoOwPRKiN2vTx0ae0XpbirywUS1n/ED8mxG0e9sCtqJbnpbPHB24kDpg4UF/zPGQph01wqVCMDP+uWmQ2Q9eB1Q3jqf4+zzERBYe8zHYgf7UqbZ+H0TCWhTniaEb40C7POatow0KQuwGo1Vv7gmiq1K3pnkxnH82BV1EFqQWxncNIsLSmgx2HSVJGLrWOA4xlhJaVqfdEaDVjIKsHINuxoMpcWNUveZESLdG0yC+3MdYy10YwJTsRySJFHxB2dJuuqW0q3DG61AzwZLlMBDc7ypdA2FiiDEX2GP/cw1dg3UW3j0qtApravGH6eNwvw6kw28fBkC4eFYoUv7FebGjh+WmztCvnnkCRcA8BUY9m+S5o+E7hUWgQi+jIqL9+MyqyBuXRyYvXuiTYUyT9KNjnBVRdKG7JsnVnKhwATnu9z0rryY3DKgDdp5XKeK00qn64rOcrbDC1C0kEF1LWpAT4QwnmufF/cdKVE9mffZjZXUVmqsjcoikpfQCdKvjomKypD6fRH65ex5J1iQLQMWHzk/z4qQi
 9vOQw2bh
 EBPon7o3uXEmlveGfXqf+wrSjL9TjDL//mXUp9DhaiFJu4xpumFzgEv72cTnCvZ/M8II9g02BHT0fa1LiC4xnc3aFw6TD1TfRHjqowflui8Mz3P949a1tA3PrTo67rfj0DSNjPcVU/EsbLvux+zWfF9NowiIk3j+yUWGlIUzpSrjmQc7qD4ZadVFZELSWb6PP/JqUi6HKPNts7/OKRcL3mNUq27ESJ3cv5jsaB506wgCPix335NzhCHEH6IbkyEnLvyGbNpo2BWuxb6RAD1som5MEn+stLMfKTw7o4FOwcKJfB+q+i0sPw5pCjrdNs5E1b5VCSJAdTmpwLPnkeF65rgAWq5J5SswLR84Cw7/WTLC6axK7ncbOpUs6awRiB870aZZoIA5qGbehMQEIohN6F+80fqNXBsCWlFbN5iaD02WTLDPDm9hNXaTQV185B73Tj0yl3sJ2PWEoN+D4+7Pc3N5YL8urlyqfsvyIo8EmrzLK9/i6zhsjkhWXoeZ8mYhDIzccg26tDex2BDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------V6m3WAHSMa9Jv1iiktisZNM2
Content-Type: multipart/mixed; boundary="------------iPxkI0pAlY3tmBSQs0WgtLW5";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Oliver Sang <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Danielle Constantino <dconstantino@meta.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org
Message-ID: <292ffec0-6a6b-451d-8977-3a5217c65d2c@kernel.org>
Subject: Re: [harry:kmalloc-no-objext-rfc-v1r1] [mm/slab] 6bc21472e7:
 BUG:kernel_NULL_pointer_dereference,address
References: <202607091002.cdfe5a08-lkp@intel.com>
 <afe80d38-950e-44d4-a729-61aa65d3c117@kernel.org>
 <alCddXaJ4HkjZNXi@xsang-OptiPlex-9020>
In-Reply-To: <alCddXaJ4HkjZNXi@xsang-OptiPlex-9020>

--------------iPxkI0pAlY3tmBSQs0WgtLW5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/10/26 4:21 PM, Oliver Sang wrote:
> hi, Harry Yoo,

Hi Oliver,

> On Thu, Jul 09, 2026 at 06:26:54PM +0900, Harry Yoo wrote:
>> On 7/9/26 5:48 PM, kernel test robot wrote:
>>>
>>>
>>> Hello,
>>>
>>> kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,addres=
s" on:
>>>
>>> commit: 6bc21472e7eb9f8c771ffdf86266aa6d9dcb1dac ("mm/slab: prevent u=
nbounded recursion due to obj_exts in free path")
>>> https://git.kernel.org/cgit/linux/kernel/git/harry/linux.git kmalloc-=
no-objext-rfc-v1r1
>>
>> This is v1r1, and I posted v1r3, because it was bootstrapping sheaves
>> for normal kmalloc only. This crashed the kernel but was fixed in v1r2=
=2E
>>
>> Apologies for the confusion, I discovered bugs after exposing it in my=

>> tree (force pushing isn't great, you know...) I should probably have
>> deleted that broken one, though. :)
>>
>> Will be posting v2 that fixes false warnings w/ memalloc profiling
>> debug shortly.
>=20
> thanks a lot for information! sorry that our bot still cannot analyze b=
ranch
> version so far.

No worries :)

Is there any way to tell the bot that a branch is broken,
e.g.) deleting a broken branch from the repository?

> we will check the latest branch in your repo before reporting
> in the future.

Thanks!

--=20
Cheers,
Harry / Hyeonggon

--------------iPxkI0pAlY3tmBSQs0WgtLW5--

--------------V6m3WAHSMa9Jv1iiktisZNM2
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalDDwgAKCRCGXBN6rc5S
1rNtAQDsPHuMpYN3I8TXdZ/lV71OWDWJ+P6u+SAkNGwh1T3ITAEAw/YZZDhQB4jz
0g+m/gEmAqFtRBolTTJBFnGyh55RIw8=
=ppkB
-----END PGP SIGNATURE-----

--------------V6m3WAHSMa9Jv1iiktisZNM2--

