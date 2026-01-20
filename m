Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F25D3D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 10:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597146B03B8; Tue, 20 Jan 2026 05:40:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5685D6B03BA; Tue, 20 Jan 2026 05:40:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4773E6B03BB; Tue, 20 Jan 2026 05:40:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 354B26B03B8
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:40:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D15701A049E
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:40:28 +0000 (UTC)
X-FDA: 84351998136.11.36E76A4
Received: from sg-1-100.ptr.blmpb.com (sg-1-100.ptr.blmpb.com [118.26.132.100])
	by imf06.hostedemail.com (Postfix) with ESMTP id AE811180009
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:40:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=nwjJgEYI;
	spf=pass (imf06.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768905627; a=rsa-sha256;
	cv=none;
	b=o1E4LcdBgqCLMUCFXik8FE0Ncjlb66sK0qVrua3JV06OuLRx/iPb9wCu9fD8tnGhlxfzI6
	gtk+s4PEdufXCrv8EQKc42DHFQ/OjjjmFLlEYnTvQcjtNB/Qy5HXH1Q6ILrKM0jxysZ7oA
	ZnxxCrfZepzR8VvlUIqzPwidB+iYYq4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=nwjJgEYI;
	spf=pass (imf06.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768905627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8w4+BdTy001uShPE7SVF7VvvXq4NVGP8qWYzo9Nwiw=;
	b=JDlBIdN7wPZyfslAfyWhej1c02ClQJokZInXY/nreOkUS2NSVD+LgaXsaa0iaPZdQZUoTv
	COEOTxud3R8IN5NdV4xlMEbyIyykSs+OL+JfdPrKfRpcUq7covS11gPU5bgbEzJxp4NkE6
	c9eTr6nWOrRfF3qGKCMOOkg9hZD2uos=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1768905617; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Y8w4+BdTy001uShPE7SVF7VvvXq4NVGP8qWYzo9Nwiw=;
 b=nwjJgEYIkR/EkpwgeU678wMUKG59wPyGPfiWUlCFoujwJV2aDy/5f84BDN78CWeanzc3fS
 g5emaoUJLPpBtpbYS88OMXlBj+LFQFvnABAqpDfZOauOpsf0xI8UKc6HodXS1uVtpxr85c
 WRpVGefUu5iJJWHJiZ3ymjotP9OoKsEJBAcluGOUuBtaKgCLQNf1kp/2ZPoL28XLKv97W1
 SzC6SWfh3UQdMyn9b64Ei/zpUloRy0XvBfnGHLxElp8gVYMEdNDUyhumzdTqYNlcLCQ7l7
 MC1n58xwMYRCpY80s3iVTIgjAilY4v3vhbsR+R0SF+1yTtZg1/oVtR1GngYhdQ==
Message-Id: <20260120103949.7673-1-lizhe.67@bytedance.com>
In-Reply-To: <20260120094744.5d92e34a@pumpkin>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
X-Mailer: git-send-email 2.45.2
Cc: <akpm@linux-foundation.org>, <ankur.a.arora@oracle.com>, 
	<dan.j.williams@intel.com>, <dave@stgolabs.net>, <david@kernel.org>, 
	<fvdl@google.com>, <gourry@gourry.net>, <joao.m.martins@oracle.com>, 
	<jonathan.cameron@huawei.com>, <linux-cxl@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mhocko@suse.com>, <mjguzik@gmail.com>, 
	<muchun.song@linux.dev>, <osalvador@suse.de>, <raghavendra.kt@amd.com>, 
	<wangzhou1@hisilicon.com>, <zhanjie9@hisilicon.com>
Date: Tue, 20 Jan 2026 18:39:48 +0800
To: <david.laight.linux@gmail.com>
X-Lms-Return-Path: <lba+2696f5b8f+c24623+kvack.org+lizhe.67@bytedance.com>
References: <20260120094744.5d92e34a@pumpkin>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Stat-Signature: d8mqaw5qijauk5g6uzb5gd54yxxcm1kq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AE811180009
X-Rspam-User: 
X-HE-Tag: 1768905625-621547
X-HE-Meta: U2FsdGVkX1+L4cLEJL7ixAyycCTgyGLE1k9xXEfBjRvwme0p2OpJwvdmHOi8zeebnK4rEXD6l92xSFlDElF1rvTjqrqhH0BUii9WsLjifVgX7WCW4lsIxp+xbaJSZ3ohJ7mqZj0EYnii6iYOPJth5+xVC3/i/o6BxVyW5eWnWYlsB4DXWFQ7bHUa3T4OE5pMw+WiDH+0T3N4JbrdQ36scBS8oCDuqvfvvopbhvxnjXt/8T8UVjwesJjVuIccYZQK2DuwQXAm1MeLdXPgKvRL7EkLyNwL21A/EtANdohuoa9wvBJ+6p22MJnBt5BlwUxkhCkTEAm5FCjbRHUYnEPEBeToaYnlRaGATdtAi6VMh3Bm92YFHjvulL26GbDD0RRkrVyatJP9NVsHlfeOsx9j86i5a+UHLfiAjPt5mmBsJp0SBX5atxWOklh4nx2Bb1wxbbI/WsGGvjV1vouo3pLCIT6d6SWvSBmNBXGEg5kAb1sqNKJBJoP8mt0CeTlYQO8Ga79W8gOIIOmxeUQ1wH5MU6WGGPgKPAjAPssJD0v6zCYow16mwpQZChRVZc49rJg7/GZrzrjMsOycXTFvyyc5Mvpsnfgu09s5LFPmwg6DLheGGOZUlNs+0N9SRSRyToj9RtA/JZmLvw79Fh1wvqxPJM+Oac5ocFpidyqCAxZZGzgQNCaPSUC8D/nGauYp/frNVSi+y4m1KtCOoAUCKzZDW93sJxoUoyAVUyDuMrTpo5RGO0jxJ4MLgoWFVsTF7RHKUJB3SNANS8CFH3f9G7TIysH2RCQzzJdFRNQwp0ytP5gO2cryfsuduCXBVNFuz3kDE6lCa9hlpTxceBuauC0UbM2eCZ26aZbRkQwzdgpxNtQwTPIoP6Vlf6L38nclx+Qu0n/h4EOXNhno0cXGXMJsZ6bngVVKGrbp4r/+l/S3bcWzFEQqYxzu3T6IFAeedrsksahqjHHWRR3RvpW+Y7t
 fhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026 09:47:44 +0000, david.laight.linux@gmail.com wrote:

> On Tue, 20 Jan 2026 14:27:06 +0800
> "Li Zhe" <lizhe.67@bytedance.com> wrote:
>=20
> > In light of the preceding discussion, we appear to have reached the
> > following understanding:
> >=20
> > (1) At present we prefer to mitigate slow application startup (e.g.,
> > VM creation) by zeroing huge pages at the moment they are freed
> > (init_on_free). The principal benefit is that user space gains the
> > performance improvement without deploying any additional user space
> > daemon.
>=20
> Am I missing something?
> If userspace does:
> $ program_a; program_b
> and pages used by program_a are zeroed when it exits you get the delay
> for zeroing all the pages it used before program_b starts.
> OTOH if the zeroing is deferred program_b only needs to zero the pages
> it needs to start (and there may be some lurking).

Under the init_on-free approach, improving the speed of zeroing may
indeed prove necessary.

However, I believe we should first reach consensus on adopting
=E2=80=9Cinit_on_free=E2=80=9D as the solution to slow application startup =
before
turning to performance tuning.

Thanks,
Zhe

