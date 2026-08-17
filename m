Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BB3BC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7EA6B00E9; Mon, 17 Aug 2026 09:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CFDA6B0156; Mon, 17 Aug 2026 09:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E58B6B015B; Mon, 17 Aug 2026 09:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9E1D6B00E9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:44:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 839781A07A6
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:44:33 +0000 (UTC)
X-FDA: 85110881226.13.707AF8C
Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id 39DB14000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:44:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=Vzn4R5BO;
	spf=pass (imf07.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786974272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+JMMRGB4tIrHKBKBuop5+/Mj3FgWMwZrxRtqWLRuC8=;
	b=5RuchjJ0LbUS08JzqJXnewwlN1lJdnyiCto+wRoPf/vQuXN7SmGNrMz7PR/sDvk1Xm8bbE
	bPqS8TwiIjqQApoyG+YDqRo3UHUFGhtBIzwQ0uvwZebggXiFcNjeRztJYyRoEYJcQw/z4l
	5TqGPxmUeaY79XfjsnNMa7P+KKsiSmI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786974272;
	b=MzgxFhGDhD7wo4ACyIgq7druG0AExKNQcTjgT5KtqUM5qx3eS4elgI5i07+6tDa3jug1+v
	dn6+yEQb8lwalc67Cfgmk8qfJqYPMPfYo+mcpi5XMtkXxAgm9Qf0t1lSRxl0VvTtLbfAm0
	hO5/z89MfpQk/ol8xk81umyuCdogNoU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=Vzn4R5BO;
	spf=pass (imf07.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1786974268;
	bh=W+JMMRGB4tIrHKBKBuop5+/Mj3FgWMwZrxRtqWLRuC8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Vzn4R5BOzaninZ/+mLrqCepFUMxd3r0Rrl4vOpuFbjcPOYgpjX5+zJLUB0e7WhUpY
	 1Yfzv1rGV03mkgrZUnlrJpb/il5Pe7nFzDwxARc6DkfF5VOVzzqZ228IvSVO8RU4/2
	 Oh+Nwvr9Wvivnbd1TFGvUTnWWxizhNnikPzyCbEw=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4hNvFm1PnBz6vKy;
	Mon, 17 Aug 2026 13:44:28 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4hNvFl5Krsz4y6W;
	Mon, 17 Aug 2026 13:44:27 +0000 (UTC)
Date: Mon, 17 Aug 2026 14:44:29 +0100
From: Bradley Morgan <include@grrlz.net>
To: Joel Granados <joel.granados@kernel.org>
CC: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com,
 kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 shijianlin11@foxmail.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, ziy@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_3/4=5D_sysctl=3A_Disallow_part?=
 =?US-ASCII?Q?ial_updates_for_erroneous_sysctl_vectors?=
In-Reply-To: <cwfpl5h47km6f35m5k7wa2pj3elciaax6i3nmetxcgws66qewq@fzygztolxed4>
References: <20260814-lklm-partial_ctlvec-v2-3-9df50d26e477@kernel.org> <3A4FCA2B-2F42-4E8F-A328-5C1BD658B2A8@grrlz.net> <cwfpl5h47km6f35m5k7wa2pj3elciaax6i3nmetxcgws66qewq@fzygztolxed4>
Message-ID: <FB1BAD61-3BC2-4CF0-9345-6CC2E9EC548A@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6jjp1aizumnd41cstbp4fhqesu3au454
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 39DB14000A
X-HE-Tag: 1786974271-901689
X-HE-Meta: U2FsdGVkX18wtYm3F22zyoSwSQ/JlU+c/EkghoRTbBl9xbb2djAgN/PqwspXJ2vYdrzLkMYJpHcGPn+QsbhNFckOqfNbbeAA2GMi4xdSv4v6WpQBi7hywQiM8oYYuu24gSmXozxLBWkGjQaFjB/houIPU6kd/R7yIBMTAxa983TzNbpTz5+TUHeppfhjPfvicmAbzpmnzYwuETLS7IRPwoWVK+0p4HvjAEp8Dto7lQeEk5J1DaYmQ4O0viJEneaMEpN56BsDUgZnGaQ0etnDXNAXIcO0mtvK4D6P08giwVgtmmw0F4h/c8Pp7c51VJ2M34uVfEQzNhIVhuKTFoNyqkCQhkNfQx0j4WXoIDpZHCFFUDtdjcA3kwJhppfFDlecpYdP7Z41vhgTqTJc2SgGvAErxcKHGX7VglVLHeLsYsD8itFF3JALSiBWDq2wMo+o535KK+YuVAmHkNAoHkSbRnTHfAkFr7x4ayDjfVZy2IfmFE9L8PpGcDkZXC7FjLWZkdtAohxUuoQZTeZ0GFD5vuxWCHDt7yhmRsodUM1jipgPWNZjR8A1iAI4dAd4nSwSYhRRL7f6Hy5vw2YtzipKQASXJxAGhdSKYa1zBLj/mobDTBqOW2t/srCB2Oq8wWXIgHiqqDuf83/0WBU4Wod9E0brJ6s2TgAz4Q8vsgtaKpjZzMz/EaYqowiFpx0pYxX2HzpQnV0OHl6hDB96bNnFAkvRpJfNl5dQC2K//6pzgEwaEdj2BWaPtqZJ88DV3q7CmWVqAxCsUrmKvAGu1OxrxH2JBJD5P5AGLdnjw0+22dImCUhZ+jz6ske5Qd2QYX22P24l5ZVbZJIS5RZFXJqZRqurKhFgBrZRHxpLKTBQ2CW/uKCBao+dp9nVk6maXjbjnCAds2Sidn70cBj4uByrfrv7ATZjnA4bU5NzWQ78Slfw+rax30isXvf3jKITx3+AqGkc0rT19oxC+F7yRy8
 XrUyElnF
 g52NVG0gdqu+8RGffO+tqWJZfDab3pvrpJWiSl3u0rOWWH7q/RKPCb+akTi4cxEB5LdPxkCEZXzc10TXT4QvC7aopqmuV0pxBtDt8OtHtZm6nwfQrTZqpKWCRLnZCplnrXrOGBzHIe/GTanO094G5NHRSMHDZV7k1HtzgIm65Q5BPiNqc6smccH5RmV7JNsY9IPeUvLF36MHEa1pyiHIfJHYarwwxSxfzBFR6et6Fln0eyOB4+UNVtVemPMlpm7rtJQQI93LEqRbvkLsZmT9QUczv0J3yZoKUTdlmYXlndumazty101ekMKtKNjfQtGUAPaoY4ykXtNjrKC5Lls3Cj/SnlrgKtjK8044eeKtRdS94LkPqymZ6KymV7iZ2Musy9eqmhBss94TdPixl+5XfiLqPH6R1tCydynyUuZQxjw0V8Vr3rxpXzvqysQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 August 2026 14:43:44 BST, Joel Granados <joel.granados@kernel.org>
wrote:
>On Sat, Aug 15, 2026 at 05:05:26PM +0100, Bradley Morgan wrote:
>> commit_conv_vec() writes the elements one by one, so a reader can
>> still see a mix of old and new values while the loop runs. Same as
>> before this series, so no regression, but the changelog could say
>> this doesn't make the write atomic either. Otherwise someone later
>> will expect the vector to change all at once.
>
>Seems reasonable: here is what I added to the commit message:
>
>
>"
>... This (The staging vector) does **not** make the write atomic as a
>reader
>can still see a partially updated vector.
>

Good enough.


>...
>"
>
>Best
>
>Joel
>
>> 
>> The copy is limited by table->maxlen and only vectors pay for it.
>> 
>> Fine by me.
>> 
>> Reviewed-by: Bradley Morgan <include@grrlz.net>
>> Thanks!
>

Thanks!

