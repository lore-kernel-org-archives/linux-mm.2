Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4D89E92FC4
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 18:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69386B0088; Mon, 29 Dec 2025 13:35:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC8F6B0089; Mon, 29 Dec 2025 13:35:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7F96B008A; Mon, 29 Dec 2025 13:35:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7DCF6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 13:35:29 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5479A8C029
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 18:35:29 +0000 (UTC)
X-FDA: 84273361578.26.76A6643
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8E69B2000B
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 18:35:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJiTqQdx;
	spf=pass (imf13.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767033327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vtFPbWhdjZCTP8lIFtEwD2ZcNGsbPDoPMVEGnz9CGZs=;
	b=F10IHsTT+z2lkBnJN5GB1BPX95/Rgpjowsq+o5dEp1USHEzKB6iNf4/x8k05L2U03cYKEt
	xafKp2Yxst+TcKSN5MYE+ygK9Xv4TcIyQX2rYyYPx5G+RDZgClx7IBzdcBVYLXsnE6xwEt
	sIc29Bburc7GH14/cUbkBQKcc0ESHsc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJiTqQdx;
	spf=pass (imf13.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767033327; a=rsa-sha256;
	cv=none;
	b=6zcyiYpU1bLKAHEHVZ+mXRQ5PUqPOP7pHV6dcaLvLnurCrVNIlozIom0eNWk0RyntDXtgE
	MubpRxZKtxb5XErH17w1Scy4q5g6/Pc3MV6PH9gMvE8PImF8mzkMenU5moKldERu9Y6znT
	fExuG+Mn55ACpvnevNEyKgKQ16gk8kE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 69473432E9;
	Mon, 29 Dec 2025 18:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EF6C4CEF7;
	Mon, 29 Dec 2025 18:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767033326;
	bh=eG2cXpjbEn5KgR3sqGbsjKORgaU2dlYeuXkzKF8Mu+Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tJiTqQdxcxiahCt/5Na42Sqqnb6QMNXBFsKWCsh/jwM7SZm5uZJ6HLYmiAziNGUIM
	 bStVvsBKeMwq3158DF+MVo9QN/3PmTb3lyOHtcBb4uKosJIhW1HwdKEgIRXdhJLqIv
	 Aze3DO85ITf1QVHZwt8J08+vxDRRz+G7IJLe4q9AeAEu/dotyEun9ursQ2VT4iGuwF
	 /uUam40Exa8qQD64T3RwaQSpZhRY3Q8GKi1W2craqo9vuRBjDKQdEdaMErKFYMrgrL
	 I+Qs35NIYKKJSezvh7BHgJsqWQugepNS5WIMPfLeYt/RvPpPpf/xHw5lAuaNu5cPsR
	 klwqXccc4oIpw==
Message-ID: <398ca47d-19d4-4b26-98db-2bf283b6b0cb@kernel.org>
Date: Mon, 29 Dec 2025 19:35:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
To: Andrew Morton <akpm@linux-foundation.org>,
 Sourabh Jain <sourabhjain@linux.ibm.com>, Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
 Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
 Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, x86@kernel.org,
 linux-riscv@lists.infradead.org,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
References: <20251224115524.1272010-1-sourabhjain@linux.ibm.com>
 <20251228143533.33e2be2d6282d036f55e12cb@linux-foundation.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20251228143533.33e2be2d6282d036f55e12cb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8E69B2000B
X-Stat-Signature: sewbe15mq645yz7z9yird9yh6yqe31ue
X-Rspam-User: 
X-HE-Tag: 1767033327-611901
X-HE-Meta: U2FsdGVkX1+jNFp6sEdw+WZuDc8JMQZOf34qh+nDN9r4SfNDyBjyh6yPYt6NVsfySZ4hGeGY8pJoMoDFtPKm6bSvL9fhdJuSfsORc9f3KzOoj8sEIPvLsk+iWNyMsjicMY0mvO7vsKen+TEgUFUEECkfyklmqCE/2EHAxVkRaAFKAq41ZmUt/VEvDbaurdlnQXhS0yYeX4uRXr7cxZ0aTRJqLEx2YyPE/4+hq5fevD1GAhXDszfD1fljDgmTjY9yJsPoB/X5RpcztwTQ/ant1okrWaMLGlcF5yzeRXzcUDkenOzCry4GLBeYTOPGe1KqC+18H31mM8rfPv81RjQfWOs4sVS2fJ1asAvy17u2CUoTi0a/kzgeUDKA9qtTfCiPBTrPqw0BENble6XiJh0a4MCuxWSgJK0WXClk0q/VjFFLVsgQ864VHlurfmYiO3szz02kk0YgOQxClQC4d1uTmXzSs0n6Jlgb6860EJB1Wj7gn+yfIW+Jxy5B/C9Vsa0qpSDkyhneyVoMsRM//5AocW79TpqR3setGGAWVVsq9pJEIKPqZe1oHfoprcMEK9GPGN7jiI4wIaE7b0l5Xf3EcCOk1+AujUIPm3x/6KphVkvNn9n29Jaz8Lux7U6oNtk68buCv2e7cKmDNeYKZxKa1v59SQxSu+uZ8A0BG4uanHXHS6TJ994LwtjmZUaRop7qjtrBo2cRtjvLgzUlGfqS9yCRdOOi0ckaw+1AAR/vK73SA1P8FDMW92OGRn2OJPt/iKui1ZQZ5TsYhn1QX8Lwy8vpd2jMs4ENZWL6PT+6HQJaetz7S1mIFpS6gpEYH9iB9UFR27EZfATDhH7g7wDAYatjFW0IV70h/zgBLp+6dGenv830p4UZixI6T1JO6u6zWQplH2KeF4WsF48jkjxR7fiRyvuHJpQpA2PBgZT4PxUL5qfYFjSqgDASQmmOeru3XaEMN35ibJNR8zyHMCI
 +p7YQ3e3
 0SUJMH6LUn8vm4OQLQy1ngK4fSerKI3ys14f0zlbQTiQkRDj26mYVAk+iiFYKU3gUDS8HgEv+8muizjXbOICK/9jEPRbyO+6HiVuWzIN9nOPY3c+IZoHT0m83MDDeWfZ4EyVAHtFnv0er3r4ZpX7qCCovsOlFBJSpueI6oKkoc655iojV1U0PrPdOIJfXL0Wtaw61bjiJ47nc2sb8XOkf9jzVE9wOncin8esi9dZ9wo9sPVepxl9S4qLLNRj4X+/cb/nIQQKt4IkPeMBlxNH+hO68/MuzCNXJdhDyfkWRJJ/dX2yfyuB24Ct4JQKNaAZlPxGLnkSlr2lUsFVEPl16DAQEJhgc/NXob9khqtfNOrnv+RiDTSdyBMWmhh8rTBZxiRq6jQUKw8MoSDQQiIxlIx35k4z1moDP+e0OIdk52d6v50eKjqLPx6+9T2SArnwG/MoqnMcXNsmCgFYlhD9wdwMPm83JMhJEpHjqj4OPkQjx9NuYlj9W9kXHN53vSfnxz6N3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 28/12/2025 à 23:35, Andrew Morton a écrit :
> On Wed, 24 Dec 2025 17:25:24 +0530 Sourabh Jain <sourabhjain@linux.ibm.com> wrote:
> 
>> Note for backporting: This fix is a partial retrieval of the commit
>> mentioned in the Fixes tag. It is only valid once the change referenced
>> by the Depends-on tag is present. When backporting this patch, the
>> commit mentioned in the Depends-on tag must be included first.
>>
>> Link: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20250121150419.1342794-1-sourabhjain%40linux.ibm.com%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C93a8f925fc024ff9c3fe08de46616c3b%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639025581404027066%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3iVUdaMBWhExKkDiV%2BBfYufPTKva1dVikhyQShOq7mc%3D&reserved=0 [1]
>> Link: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20250128043358.163372-1-sourabhjain%40linux.ibm.com%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C93a8f925fc024ff9c3fe08de46616c3b%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639025581404053206%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=GamDe2R87SdpFurnj9Cmt9wOQtkGLgIO1z7nl5QPxgY%3D&reserved=0 [2]
>> Fixes: c2833a5bf75b ("hugetlbfs: fix changes to command line processing")
>> Depends-on: 2354ad252b66 ("powerpc/mm: Update default hugetlb size early")
> 
> This will be the first "Depends-on:" in history.  Which is a hint that
> we're doing something wrong.  This innovation will surely fool any
> downstream automation.  Let's use existing tools if possible.

What do you mean by "first in history" ? Do you mean it's never been 
used before ? As far as I can see it has been used several times 
already. First one was in 2014 with commit a0855054e59b ("iwlwifi: dvm: 
drop non VO frames when flushing")

Sasha, do tools use it ?

$ git log | grep "Depends-on: " | wc -l
137

$ git log | grep "Depends-on: " | head -10
     Depends-on: e2daec488c57 ("nbd: Fix hungtask when nbd_config_put")
     Depends-on: arm64: dts: nuvoton: Combine NPCM845 reset and clk nodes
     Depends-on: 058518c20920 ("landlock: Align partial refer access 
checks with final ones")
     Depends-on: d617f0d72d80 ("landlock: Optimize file path walks and 
prepare for audit support")
     Depends-on: 7ccbe076d987 ("lsm: Only build lsm_audit.c if 
CONFIG_SECURITY and CONFIG_AUDIT are set")
     Depends-on: 26f204380a3c ("fs: Fix file_set_fowner LSM hook 
inconsistencies")
     Depends-on: commit 045b14ca5c36 ("of: WARN on deprecated 
#address-cells/#size-cells handling")
     Depends-on: v6.12+ with PREEMPT_RT enabled
     Depends-on: 045b14ca5c36 ("of: WARN on deprecated 
#address-cells/#size-cells handling")
     Depends-on: commit aec89dc5d421 ("block: keep q_usage_counter in 
atomic mode after del_gendisk")

Christophe

