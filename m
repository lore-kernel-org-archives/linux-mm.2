Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E898C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68DC76B0156; Mon, 17 Aug 2026 09:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6660E6B0163; Mon, 17 Aug 2026 09:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2726B0426; Mon, 17 Aug 2026 09:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32F236B0156
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:46:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA67CA07B0
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:46:04 +0000 (UTC)
X-FDA: 85110885048.15.A0875D8
Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id 86E2440009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:46:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=AGIu3f6g;
	spf=pass (imf01.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786974363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ig8b2sENsh4uRBZuRVMIOvnD2w3jOwT8EfqPmaadLzY=;
	b=TeFsABAvn2MEVmPfXi+FZBBYqOSLC4af8sKjooTEqAGOLkOd0NNLyjUr/lUUZ9L3q0fVPU
	RbOiwCbz3v/aOAI2TOtCVMC13WQSW/lO2rsIrMZrd1I0ZwCB6aejhBex4xhwyyWLm678ge
	swM8s83QYkRAMKdbVKRNvZ18pA9eW7o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786974363;
	b=7QbPuEiGKAgCKzwmSdXHuPmFaXEUZjo4/EVQEPlfw1E5vbfKC+irCdSZW/f2/zWNsrpduz
	iz3x3Um4eVKg742O7oZwyAT4OJAHn/OL5PjhaPaOapTA+CL7cbQaj+YfNvRlrzUri4TrVy
	AlmIpx49qM31M+ZLUTusueamSdG91sg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=AGIu3f6g;
	spf=pass (imf01.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1786974361;
	bh=ig8b2sENsh4uRBZuRVMIOvnD2w3jOwT8EfqPmaadLzY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=AGIu3f6giLeq5unMffhjmaNuwQG+K2BpF+4ytiFS5wBUFnwDpoT+5nKLTQJTcVHJK
	 yYdVw8LyfbYpRLhrJnEsl/O0xUCrbegGEAZasN7B+G4R6eRWhVnK7m60ZMrGZeEy1H
	 ejUPu3tHSjFbEv3BRigCKoZeM2H/gKBXAS9wGIfk=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4hNvHY3gdZz6vL2;
	Mon, 17 Aug 2026 13:46:01 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4hNvHY0Chmz4y6W;
	Mon, 17 Aug 2026 13:46:00 +0000 (UTC)
Date: Mon, 17 Aug 2026 14:46:02 +0100
From: Bradley Morgan <include@grrlz.net>
To: Joel Granados <joel.granados@kernel.org>
CC: akpm@linux-foundation.org, hannes@cmpxchg.org, kees@kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 shijianlin11@foxmail.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, ziy@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_3/4=5D_sysctl=3A_Disallow_part?=
 =?US-ASCII?Q?ial_updates_for_erroneous_sysctl_vectors?=
In-Reply-To: <FB1BAD61-3BC2-4CF0-9345-6CC2E9EC548A@grrlz.net>
References: <20260814-lklm-partial_ctlvec-v2-3-9df50d26e477@kernel.org> <3A4FCA2B-2F42-4E8F-A328-5C1BD658B2A8@grrlz.net> <cwfpl5h47km6f35m5k7wa2pj3elciaax6i3nmetxcgws66qewq@fzygztolxed4> <FB1BAD61-3BC2-4CF0-9345-6CC2E9EC548A@grrlz.net>
Message-ID: <C95DE45D-776A-4856-808F-936D7642756E@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gnk16ee4iyrzfjb3bno3aimkotrbjwcd
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 86E2440009
X-HE-Tag: 1786974362-649309
X-HE-Meta: U2FsdGVkX1+2hbidpbhfHc6UA0IyOeLV1zRqDRxuMSt8hv8TBF8craqwv+8wwOllCy2FETdM9hvgbU1nI2gvSlGEYb29cKBDo6h12/1NEetAT/+giEbjzKCmKFjwf/MNv6YcBDMXSzIZ4B4CmN+nMxKFBjXfyOQXHZicR1Zcwq7JlZKODaa7I03+2RTV1cY8/lTZAmIcIqCzf2kPC8HRRNeaqdETyarjLk2n71zk50y16hh95cnLFH4KObz35d/qyK1BpesNWQpez9ZBR5iHao0gpegQltwOYU8w4njPCiawLFYoQjRI1op4Zcr4m7plHarAAF66QYyHXg17Qrfcio57p5jSF8Kry5D+ZXB7hb8/rLhiyCm/qGDiGuyTMUwWy4sDrqgiuy5oVK8wJ/SqeN+XOK5Jx6l+5NMCIq6+Q5Z07DsIVe5DJs0qbf4GA58+umLSKsqJEJaCkowhTlZJ2kMfOAxKQnjCPnU7iXbepgelMdPS7kP+AhxQ1JQkG/k1LqVyIsppcdSGwvO180/n/mMti7mhQPmu/b1jSTqmri0y4XlsOtWiN5kTGz5/qSDS7dlgHLE1BE6t1fWMvG/bQv6Psty6iN8CSUmJznrEMrd1jYrCK+PBzwUZro1xkUovu3XhXnECU9UpjmDyxcxGZ5xrbBH3vCvOODxQBnSUtQ1A6mEef8YdnnIMw4iE/gBJ2YLfR6w2rmuK1SkN0uFTuUC/iIsb3G+LWMOqvtax5Io2m2pc/Qn4zjRaoj1g3HZy3sHOJDmAhoQ7rV8t8Fp38DnN5T2UY5hqc0ieGyYGpda+8xfhrYXi9cy9Gt08pTWPr1/gYoN5qlmLEFqqFjY75y4pniOx5cS7VmU/M6mVpZ17VLTWGaueUsbmQ4cAvMdXznhvGWcn/t/xExglJ7cNZSb/AMer8coh14B6vWZiR6HxaQtcC0WEoNosfB2MN0Yrwl2N38Td2LkFXfpZtei
 bw2qFKiA
 WtKbv1SYO5Sk2MPd0D0s3cO9gGa3b/TxUDf+QHLeXzDoC6ceCVxr7DYYw5CNpIboh7O4XraGd5Kdb1B8dRXJmOrHiRfzI+AXWArLV3BtISXUzh9byfMAlUZXXb3MLsRL9Y1TCAgd5b3BpNL3ELokkZYw+dY+NaRhtcc9yaNZn4eVDzeXhDDVgCmbJislCkX1FQe9l30c2EylZ8ZqiDexhGDEqSMcg389iLY4ggLSTVoVSsKId4IeDUWXX7uJ0yq7Hbqjo34eC3A7eG61zB6kilcBxo22Cne3rZ7WVQ7LH/gPHqXcf4azs4gsgGSWUIQADRMELQcR2BxMtd985yXC0JS/89KsCwAFNT2buBBEtje2sGqQgWaFYCrEmqvM3SPGgxj3VfoBAyiCD87O563I26k7NrfAKw1la4O782zvRWSS1kRMeNOmJFpb3IzuoCJCkiQPjnVh45iJ2/Ag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 August 2026 14:44:29 BST, Bradley Morgan <include@grrlz.net> wrote:
>On 17 August 2026 14:43:44 BST, Joel Granados <joel.granados@kernel.org>
>wrote:
>>On Sat, Aug 15, 2026 at 05:05:26PM +0100, Bradley Morgan wrote:
>>> commit_conv_vec() writes the elements one by one, so a reader can
>>> still see a mix of old and new values while the loop runs. Same as
>>> before this series, so no regression, but the changelog could say
>>> this doesn't make the write atomic either. Otherwise someone later
>>> will expect the vector to change all at once.
>>
>>Seems reasonable: here is what I added to the commit message:
>>
>>
>>"
>>... This (The staging vector) does **not** make the write atomic as a
>>reader
>>can still see a partially updated vector.
>>
>
>Good enough.
>


Hmm. Removed a folk off CC:


** Address not found **

Your message wasn't delivered to jackmanb@google.com because the address
couldn't be found, or is unable to receive mail.

Learn more here: https://support.google.com/mail/?p=NoSuchUser

The response was:

The email account that you tried to reach does not exist. Please try
double-checking the recipient's email address for typos or unnecessary
spaces. For more information, go to
https://support.google.com/mail/?p=NoSuchUser

:(

>
>>...
>>"
>>
>>Best
>>
>>Joel
>>
>>> 
>>> The copy is limited by table->maxlen and only vectors pay for it.
>>> 
>>> Fine by me.
>>> 
>>> Reviewed-by: Bradley Morgan <include@grrlz.net>
>>> Thanks!
>>
>
>Thanks!

Thanks!

