Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D79A9C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB896B0110; Mon, 29 Jun 2026 12:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A793D6B0113; Mon, 29 Jun 2026 12:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918056B0115; Mon, 29 Jun 2026 12:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 619C06B0110
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:13:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D347AC0781
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:13:26 +0000 (UTC)
X-FDA: 84933445212.07.F66341E
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf13.hostedemail.com (Postfix) with ESMTP id 929BB20009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:13:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026062701 header.b=zatAi2qn;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf13.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782749605;
	b=t2EFRByDKjira3ufYNKVyr8P+TZhq3uunGDhIIEU8EDEYSmC4OG/lniJ0NidISyklSOA7K
	fOr+qNq6KnTwlOnKV/tqtvW2wEzQIcj5ECjDVkiCx8HqFdI6ndT2Ly5UcWGMcPMjAwJRzp
	wEGkgd2RvAFI3GtuBH6OBoO1QnUcTLk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782749605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3i3FEnio30NeNI1+7nj44U+v/lnb8a98mmF1ess0D4c=;
	b=UBepI2b4wNKuZ5Pfq5cN4UnW6JaPH+HhWKZWygmS3lb8S9vu/S3ixJh105rAZaHT4jVbEl
	++3irrow2DenonAle7vO8BA8aHp0z1zZHBAwdmmPdVF0Vp3VU0woBSCH3Nz2pzKMsk5Kb8
	wEsFBtaw9NB1TF/JTytlyuADjwvPZoE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026062701 header.b=zatAi2qn;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf13.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 65TGCiEO601252
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 29 Jun 2026 09:12:44 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 65TGCiEO601252
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026062701; t=1782749565;
	bh=3i3FEnio30NeNI1+7nj44U+v/lnb8a98mmF1ess0D4c=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=zatAi2qnAxGGYFa2/UTNj30m/Q8DHyhcopozjIPDF4TT993qNFjHJZf2nb96cabTO
	 V0Mj9i+jjYtlb3i1GCLfym3nduXSpr14Tq7qhji/6gAmS/d+lV+aZYiAPQO/5HOsSF
	 7jdi207qkl18TYAwKvJEgmff2NBLSrZRUajeywbrzupe6BhWSkvnrnEiu/3NRfcPft
	 S1A0XRF5ktc4ocvU8vl2QwUAd5ncWBXwCbXP1zuqbMGmA8gUxIdlUm0YcA+hyfY8ja
	 cIKZJ2vH1KYxVAV2RiW29A3GLHI4UuSZiTD2VePjM/g3SxpeuoKgmLkgZpIm2IbZJT
	 sFCsR615ISKDg==
Date: Mon, 29 Jun 2026 09:12:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner <tglx@kernel.org>,
        "Zach O'Keefe" <zokeefe@google.com>
CC: David Stevens <stevensd@google.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <willdeacon@google.com>,
        Quentin Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
User-Agent: K-9 Mail for Android
In-Reply-To: <5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
References: <20260424191456.2679717-1-stevensd@google.com> <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com> <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com> <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com> <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com> <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13> <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com> <87qzm2b39k.ffs@fw13> <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com> <87mrwon5uw.ffs@fw13> <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com> <87cxxgly12.ffs@fw13> <5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
Message-ID: <0B5CA679-18E1-459A-BF92-C60707274233@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 929BB20009
X-Rspam-User: 
X-Stat-Signature: 7hwj5e1gy9n61zpwpjdkwocbstek76du
X-HE-Tag: 1782749604-798933
X-HE-Meta: U2FsdGVkX18qPYiltvt4AnJAthPIUpSvaNp4y4qkbfe/GcgY6bzaD96WpWT4Q8Xp+xaKxvlb6EA3i26MkDWK0Ewu442qQhkzl7bLSzuvuJ08u55i4Jrvzu9WFrhivz1LOYWH0E1W1gKhrNTNepurdlTMg6QyhrABEAHH17tFbJn6lC9dynZGluLAOgRN1oor6Q8OgsoXi48qWDaDnNwpR9UM8b4p78m+0D+pmtAA4J7Tfccq9ZlUnFeULCDuQhjhFrVEaZDPB4kkE9BRoF5l8pIwPdwb+61+sG6lid7yT/Az9ev2y0Q8yzDLjmOMB0dh+JWTaKw6RDkAotfDKDjwKk0lRuINLpLMI1ue3TyOZUntRm5aTNJwpTNObyHM37O3jx0f9GXAXWhWl/b4ndXHq2FTuX78K7yicUV5SvQglTcZwviqUdNYK+mzfjW/trDO6JBrZOqKrxcMRkE0XzhqJ5a8oWUAJgk7Hyda06canTJv6qzeSvRLs0qI/Jq8pZlzwSnZV/5fqpyfSyT2dcOywqSChKmOwimPhk0d6Qj7ja0GZkd64TGPyCcdAQ2peJkqrRu9mVkY0N/d7gG3u79q7qu6T+g5rRy5PQZVZkZqO9osqLpAX7RD/TFgnPx4zO4yGtEbh6EoQ2csTsh8QM4uV3YRBqoPlHrJTfbSlXGqlUngs9F2LOf5QloK7qnRe//QhTnwl1ZF41XAVKUMT7CvMxIqrAnt98yhGHN1L2gy6k1Yx73A3iqk8aQSlcBnCwrbJP11cT/9MreVF4oMMStI9/UWb05CjMXd1oR4aqu7dApkt10xuc9un499cjh/onjZGAmwxk6Rb1iyQjtkF3nCvWelCCj7InYAP/MwYubBPIkY3GqltjWCR+f3gaulzHH7tXcwvGTTOnOuQnh/PlSb89oG+n8LRN7zMONJzLGNLq12MDF0NlsdE688UY8wMr8rOQgo2m9q6rZMsr0Km9r
 iu6UeNc/
 C4GCSBPHSLYTTOaRSRiKFNSsSpFsur501kHAjAM7R/9q7uK6oRuVdpRPZJMwWo6ex7iVsb9aNZ6IozYxuXlZTtJp2yUEvzHWsmkIFfbzogWOiE273XCNwshjp3+v2K3oEUYFIImwba/b0uz1Axv5ZBV6MgpMiwnW50I1r/zOBG16kvyTtj4ul/28oVeIyHIigwGqVlwcspGHBhvUqmoN6MPsffE/w/ud4dO7f10ErCKUc6jSLtvM8YrRkUCSD8FWzzbvJgfU1pkouTV7qlYC7N4uXUVwk/h8yhJvDMVhMy2pz2HjXp1MB/T6S9Au4ADQT4PFQVCX2+G51FIM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On June 29, 2026 9:02:08 AM PDT, Dave Hansen <dave=2Ehansen@intel=2Ecom> wr=
ote:
>On 6/23/26 14:58, Thomas Gleixner wrote:
>> So as you already confirmed that the number of offenders is really low,
>> it'd be definitely a worthwhile effort to fix that for everyone and als=
o
>> make the compiler people to get their act together =F0=9F=99=82
>
>One other thing comes to mind=2E=2E=2E
>
>We have debugging options for looking at max stack depth, like
>CONFIG_DEBUG_STACK_USAGE=2E But no distros seem to turn that on=2E There'=
s
>also some ftrace stuff, but I assume none of that is used at runtime eith=
er=2E
>
>Do we need some max stack depth instrumentation that folks will actually
>turn on? It would be nice if we spat out warnings when folks went
>through 12k (or 8k) of stack so there was a chance of closing the loop
>and getting feedback from them=2E
>
>It could be done with really little overhead if the vmalloc()'d stacks
>set Accessed=3D0 on their PTEs and then checked them near vfree()=2E The
>PTEs are already getting touched there, so the cachelines should be hot
>anyway=2E
>
>The granularity would only be 4k, but it would be so cheap that we could
>turn it on universally=2E It would also be 100% deterministic=2E
>
>There are, of course, more games that could be played with stack depth
>checks on normal interrupts or NMIs=2E But those would be less determinis=
tic=2E
>
>Thoughts?

Having a cheap stack depth check warning would seem to be a good thing=2E

