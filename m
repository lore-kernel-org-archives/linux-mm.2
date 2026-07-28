Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E6AC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 09:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FCD16B0088; Tue, 28 Jul 2026 05:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AC236B008A; Tue, 28 Jul 2026 05:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14FFA6B008C; Tue, 28 Jul 2026 05:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCB866B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:35:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA94312030F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:35:13 +0000 (UTC)
X-FDA: 85037676906.17.B8FC6F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 43F52A0006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:35:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XcOVQ+En;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785231312;
	b=RTnYJOwGeHVcZhr0XT2NqHdHnXEBClW4rD+Lk/TLgWfRhWuasxhS9JYDbn1gPljkls0Z/l
	YP32fsLaSWLytQTzgmsJS45SQsa2ptizHNMpmofQc3ulpvBzaXFxZqr4+Ez5DEr64LA820
	Q2xsqEDvuoA6ALfEH5iTvx38rMNokyY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XcOVQ+En;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785231312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GYVJ658TmEPomu3zIByvcAej3yYIJZ34wXSqsRSLkJw=;
	b=qUrRIZpPdKFKWm6diD2u9+h6p54o7OdpYF26pDcQmcX24FFmPcIe2vtjtRNxxuc512OC+H
	4Cu9E/Qgw4+H8VrtQz95z9P0bz69kiEcriEmd6kTLj4FCzPP1TO2CGe26KpB34H4jbY9Xb
	mNEoRDrUYoNOUTNleLKJvH63mtj7KnU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A81460A8D;
	Tue, 28 Jul 2026 09:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A5E1F000E9;
	Tue, 28 Jul 2026 09:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785231311;
	bh=GYVJ658TmEPomu3zIByvcAej3yYIJZ34wXSqsRSLkJw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XcOVQ+EnYR9klrC7g4BgM59+H5wtMYUtvqM+B7NUXGW3+vWPlKUb2HFy9DN7Yxk3s
	 elbuulsbOYImOAEPqtRICkC8btLirhRECHXd3LmQvob4Uw1w84mcYyGSL8eoishzmG
	 9RQFoNJMlYZyfGdvRalPHW5uZd/sTBqzGMHVPJOg/l8+a+PBlZf85J7lerXmkPNO7x
	 MpNWzrQO8EUZmoLkK94kyJ0fg97QZKC516h17mlVAgMESN0p5W8+PEath2SsXWeeYQ
	 MqwtX4RcMj+FDkpL9Fr6GmlRqaTwSf1thik9Nunvy6zF4Ecyj0WUuk6stCRGQNFKIb
	 NnOTUE+tSJkdA==
Message-ID: <72c235f1-e707-426d-97f7-be520d6eab66@kernel.org>
Date: Tue, 28 Jul 2026 11:35:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
To: Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>
Cc: Breno Leitao <leitao@debian.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
 <20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
 <ee4982bf-ff45-8f0b-3b76-7ca19228f12b@huawei.com>
 <20260727212402.09baa9381ca426273fad4719@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260727212402.09baa9381ca426273fad4719@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t4cmcqw14495oydfu6qcj78prutzpk5y
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 43F52A0006
X-Rspam-User: 
X-HE-Tag: 1785231312-930614
X-HE-Meta: U2FsdGVkX1/aOOSzmTwHmYj5ogre4O0/7IWDcbmUGaXcwflgrQG9rgcwUFXKxGAS3O9P7bL3hFXGPCc4yscK9kGR6wpb7zSL3YGXM+csm6BlKUgIDui7idlWGeF4hWUX/5xFOGs3vCWhJXle0oY5nSBI8afKdjC13oAgi3k+UOREq1+kHIood966l7zZSqYbNlHjpc9pFIP7dAWag6krHQ1XuYLThpB8o3gZVNhYxeGlTDc+G+Lr6Dt38UYgUIReWZybuhV+mQRAMrqaexbFE4Itj7H9f/vb5RAkDBxtuXQepE80KNguEaudXa83qCEBLKVDW4FXVH0k3KrgzNgu+Tgu5cW22sOIdN6IxM3vHkvTadx/nLG1ZfP/2USRS51aL1asDcA1AichNKtMrvQ0nYcOPI0xEUBF07skH3qwykSx/SvVnyKd78UWNXRnv+9ketTNpYTQFtnH7NkgPraL7R5HNr+99HVk1Ka1B0VIu40raBPPdrKg44v0M6KOAsiVY0AyNPJQfXlaKGaWXAKSXckMii9TwCcU62jqDJwmD0NWSAxZoDdxPs+fynw0rOgdAV/jn7l5ZojbGdnr4ii8O5TykrP88Xih0MX8RVFdF6rxuCzMagParRmNp6TaGj5NLU0xoWhUq2KrOx1Xxgok9JRrYbywGqO4TSB3TQZ0ZkuWyo7UFW70m8rk2Mg/zCBUYEuXSL0q0TScts0aPQcUh/fNSm7N6iskgvhjylcmQVWqGIhRJ2spL0JZg7ZsSvvZDXgt/lWyAmDKpKoJheEH7sXKJQ46OkGIpXQFkfPm77T7+Rwt/U8SibrGcXjTTmKC3n88tNmEq6eJ7GMUzKyvClvcx2EL/8tGNhUA2QBkWB3YRqSOl+hMPgCIVwoEnch+BQGdF1pGhHYYFgE9qjKyvC3TM19MWwmQw4hSRaGt+tYZ0Nr5ztgxAdK9dL8sIVRPZLvaTSEKXsyI5CzcfPI
 uc1Sk3nM
 w32Oyqu7rfwZBjl6Dv4GTRsCIe2nv7rm8qNYAaqQCCXC4Jc2rp00yQuYbK/R4k4m/8uuq72TjR+fqZnnyt1BgursBs8hl1XeT1v7g3keTtU9FnTmGr3mcfsrzn6kRE3m82xXs15KLbtk6bVBcTWiGvb0s/ApftBV2nG3aZXnKztlPxT2XTGKTPOldtQnBAYO81w+oCy2TlHP533LmIccV/hLAbqs496oguUNZw1jZ5xyiEoePBUsLn43/G4RPJoD01OwYfxNqaBtPc9AFdIcnDWYohIMPujTDhqIfDn34HEkEOe/hdST0Rds/vG0/HSie/dICvvB4fAyqLmf5jkRseBfsr1DjzKNbURoHXGqlsv8Bj4ni2G3YxYCu1/klob5YHG/2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 06:24, Andrew Morton wrote:
> On Thu, 9 Jul 2026 11:34:05 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:
> 
>>> The script is intentionally NOT wired into run_vmtests.sh: every
>>> successful run panics the kernel, which is incompatible with the
>>> sequential "run each category in the same VM" model that
>>> run_vmtests.sh assumes.  It is also not registered as a TEST_PROGS /
>>> ksft_* wrapper so a default kselftest run does not opt itself into
>>> a panic.  The script is meant to be executed manually inside a
>>> disposable VM (e.g. virtme-ng), one variant per VM boot, and
>>> requires RUN_DESTRUCTIVE=1 in the environment as a safety net.
>>>
>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>
>> With Mike's comment addressed:
>>
>> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> 
> As I understand it, Breno would prefer not to rewrite the selftest in C
> at this time.  IOW, we stick with the bash version for now and add
> "convert this to C" to the todo list, OK?
> 

No, seriously, this is code we have to maintain. Better to not have this test
than have it.

-- 
Cheers,

David

