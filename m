Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC92F54ACF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 16:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E17C6B0088; Tue, 24 Mar 2026 12:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B016B0089; Tue, 24 Mar 2026 12:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132CD6B008A; Tue, 24 Mar 2026 12:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F28E36B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:27:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1266B7E73
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:27:56 +0000 (UTC)
X-FDA: 84581488152.28.2A782D5
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 76294160006
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:27:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=J7v9jX1S;
	spf=none (imf08.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774369674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sq8nauFKHr+epxRVCaZfaCNtBTPkuVzZwKmOS1s2fHw=;
	b=nP9C4dslqd6jXVrQmDrI1adzbn/gILPih9LApWqJnK9vzVOdBk6ujGHt6zqj4VY51fFXMD
	nycCAtCt0muKDYt+AmoJPHHtp2QLrZucFiuf/in3c2WZC9jSePNid5j3Hgpkqlk26OEtpt
	nxkzquaHh2ftYdO2+jLie97ITTQ0qdw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=J7v9jX1S;
	spf=none (imf08.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774369674; a=rsa-sha256;
	cv=none;
	b=FP0OLyrNhg6WFU+7p33PFaqTZ14DYVC3fs7A6PBMx4Ky68gPNck6smE5mIyW9Y1z+q3g6c
	8JWeU27gWyjQOlxjekY3z0aksX1ERzzQuN3CRKR6rEQR2pNUv4X0B3i0knhklobnuUaiCF
	iAyBwAm/UTr2wsKkoqHhJ93T3JPFfWU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=sq8nauFKHr+epxRVCaZfaCNtBTPkuVzZwKmOS1s2fHw=; b=J7v9jX1SrDW9d9yC3274YRy9Wi
	nSSfzJyg5ZiwMyknerSZut0hhWnr/TSuMrggoO5HecX53ALDZUZKqgU8RbrP/bw/qGxIPVjzEotkk
	VxYa9xzM6sGSya1EYid39dSd2fCvcqxa4whTnZeyukbw/T9RRDg97fncaRnMFycFqgdWhSSv1VDVs
	Mjq7bTnj1MmPWQsdOBv21FIamoQFdwJ5XT39qk9HePbhX+UYS1trDohk3HFn5WEb/VgwiSitdMKvC
	GhF2gpPpvV9OZmIyrfxCTTwF/+rXnPTKPawTMuVVrMyGkFMcJl8/BfUiDeeoLD0e+RwXiw32Vz/A5
	W6s9WFvg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w54bd-00000001t5m-2OJw;
	Tue, 24 Mar 2026 16:27:49 +0000
Message-ID: <31b9b7b7-ee21-4671-9726-cc439d88f508@infradead.org>
Date: Tue, 24 Mar 2026 09:27:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
To: Akira Yokosawa <akiyks@gmail.com>, leitao@debian.org
Cc: akpm@linux-foundation.org, corbet@lwn.net, kernel-team@meta.com,
 linmiaohe@huawei.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nao.horiguchi@gmail.com,
 skhan@linuxfoundation.org
References: <acJh0Sk4UdjaTFLh@gmail.com>
 <2ceb291b-3b18-43a7-9d51-5c752f1eebf4@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <2ceb291b-3b18-43a7-9d51-5c752f1eebf4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 76294160006
X-Stat-Signature: gdb6u73o37t16gnewb7oxpcpb8ujbpg9
X-Rspamd-Server: rspam06
X-HE-Tag: 1774369674-108231
X-HE-Meta: U2FsdGVkX1+SX61r5YgDyJmtsgA4EBOm5E9esGEoUWsy23clHYqR9sjtuFDCss8FJg6K2NsFSEnlrH/DsSJqBcFVJpnXjzkccAXUzD835JFB/ffk9fFdKrlkGeXvah6QyM9UtQAw9muNfLVhjN8UYEoB3TbEqNpCKEPy7zM8GCR4Axq078oKUsG/9icPwFa4jn8wpArimmCLdsd27kwnhmXbXVsjs9b+drio1w0a68LSSKCaMo3WXfRtVVeve7BF7N1ZD1INWMyATF+VInDLVl4Yyweg7lSF+KK8/TXN1Q5YH51eN5qmbWjhl2Tdm+J0IK+t1zk/31s+w6J6vhQ/6u/d5qcfxy6tt8O5+BqFtEDoIb3bIMiB3V0jBpk5HXRcYmnP8VWdQosl7kbWDz2saxmmNLRJX/PbgrQcQ4XQ2ymune46JIS8+GGI9ogOr9xGVtWQpgFkO1KX21VZ4hncnIup8QxMrU7b9LvYiiMHQivBwb498CIdttVV+kwHAtR6hGMJhzjQpurZujK170iPQ4LEsV6zI4daL+UZWuzaAjTZHMceLCTlVx5/WvMjByvRepcm4w8KdH8t/QKhXnJPDc/HvNLqVfcJKKHd2a65MktDJWx7ljm88ddbUCvSOukH4/fOBaxOgSzBXTrhYSKhxEdlJ7aVzQASRRSEFBVoTJQz9wp4e8k/M22i9F+ZVjgnS7gTbSJEh7IRgWT12chlygkIrWqZP/xsfFM3mqmBCnt3BSHGReGi3ucK5vAO/UU9Elksnql4XQfLTwAyI90YCcx8rP5jh1aJOR/DXTeRtP5i1J3DURN68f0nXyeTLVxs2PT+pFCj5zaNCmk7TBKqJjZamM4L+C8gQup+fIRCDSaadq6+buF4/ZSTATWt+z6gCTa0G+hZFKGU0gIFHPinhwd2uc0Cz1qGYbDSHHXnXiDhIyWM4Qlpureppwg3mr9TtkPl5FIdGEnFSX5Qejw
 NM0O4zbi
 jhjkJXmhGwNCBjTsBxglf+Zbcnc+Xb/wDHXdGRAhQgQgsfs1qU7yB+t3AjMdvJtW4DOro3BWzPwKwG4YKEfRTEVukgXUKpyNwt3xClynmPTE5BTip+nxUn4iQsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/26 4:48 AM, Akira Yokosawa wrote:
> Hi,
> 
> On Tue, 24 Mar 2026 03:09:25 -0700, Breno Leitao wrote:
>> Hello Randy,
>>
>> On Mon, Mar 23, 2026 at 09:51:55AM -0700, Randy Dunlap wrote:
>>> On 3/23/26 8:29 AM, Breno Leitao wrote:
>>>> Document the new vm.panic_on_unrecoverable_memory_failure sysctl in the
>>>> admin guide, following the same format as panic_on_unrecovered_nmi.
>>>>
>>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>>> ---
>>>>  Documentation/admin-guide/sysctl/vm.rst | 27 +++++++++++++++++++++++++++
>>>>  1 file changed, 27 insertions(+)
>>>>
>>>> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
>>>> index 97e12359775c9..3310fb8272fb9 100644
>>>> --- a/Documentation/admin-guide/sysctl/vm.rst
>>>> +++ b/Documentation/admin-guide/sysctl/vm.rst
>>>
>>>
>>>> +
>>>> += ===================================================================
>>>> +0 Try to continue operation (default).
>>>> +1 Panic immediately.  If the ``panic`` sysctl is also non-zero then the
>>>> +  machine will be rebooted.
>>>> += ===================================================================
>>>
>>> The table begin and end lines must be at least as long as the text (may be
>>> longer). Please extend the =========== lines by a few characters.
>>
>> The HTML renders correctly in Sphinx (likely due to automatic column
>> expansion), but I agree the raw table format should be properly
>> structured.
> 
> Just to be clear, Sphinx is behaving as expected here.
> 
> The table is in the form of so-called "simple tables" in the reST
> (or docutils) parlance.  The rightmost column can exceed the width
> indicated by "==========".
> 
> Quote from [1]:
> 
>    The rightmost column is unbounded; text may continue past the
>    edge of the table (as indicated by the table borders). However,
>    it is recommended that borders be made long enough to contain
>    the entire text.
> 
> [1]: https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#simple-tables
> 
> So, it's just a recommendation, rather than a requirement.
> 
> "Grid tables" have a stricter rule.
> 
> Hope this helps.
> 
> Regards,
> Akira
> 
>>
>> I'll send v2 with this corrected.
>>
>> Thanks for the review,
>> --breno

Thanks to both of you for the edumcation.

-- 
~Randy


