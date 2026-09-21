Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D980C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5106B0088; Mon, 21 Sep 2026 11:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BCC06B00B7; Mon, 21 Sep 2026 11:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC056B00CF; Mon, 21 Sep 2026 11:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 198466B0088
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:37:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5024A022D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:37:28 +0000 (UTC)
X-FDA: 85238173776.22.E113B9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E4F7318000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:37:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BPrU51ml;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790005046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2YbpZhKOEqqIeJ5MNm1/eFCzIuKS177EebPyER5xvM=;
	b=DvTzN4wPHEu5aOi82lr/51J4A0M296MvnIcf5iemCIp39XwvDung8iBzg0bcvO/8Y/gSmo
	dB7DdkVK2cNuC48xrJoG+G/MzNpnc+Z1HSDkJBVr4bX3MHStruwbf9hkjCNvd50Ns/fl7T
	UDgLYJEqY++ypFrw/JvRE6rCZEiKCpw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BPrU51ml;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790005046;
	b=1dpGXM/Wf2hVo7gRKP2KNNszGiqbrZ2Hp1h66WEUPM8ZWl/PS1VZYz8ycJPvk6ziGX48Ql
	onyeM4gXh3c+MV19AepScC8X/b3GIZbFJzH+it6lY6w2Oz+aUS9tSjxWeJLdTWlp/yBoVK
	jAuVLfE/kbZWx6n8p5hOS9UJ8Anp2/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D90E60120;
	Mon, 21 Sep 2026 15:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD0D1F000FF;
	Mon, 21 Sep 2026 15:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790005046;
	bh=q2YbpZhKOEqqIeJ5MNm1/eFCzIuKS177EebPyER5xvM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BPrU51ml8vIIactwj07Dux0oNzdKbmhqw8T059UZuEphfKvsGpj3D6+eZegKgLggZ
	 uSASuds/lCo4gwSwJXnywGj7axOHtzwjBRwVQoRIvM/x+9CaVLhZvO7ppPN/IMjyyM
	 8bxJ9ilC+IkQ3TxwozhB0Lq7obXKnCUfuAfbc7HKUzPSEUczlEnJjdKCpd3vjsuoFt
	 sCBLYesnrNi8JtszD+fWtkS0/H7kbqZnAlq8XczHWUZKU+auCCD5MESftiE0lqrjOk
	 jiNdlqok/FPZGRyKlNfeXBbuGApkfza15d3cU3X81dC2KsdDDnfEK1QJvP7ZgBgTk0
	 3mrUQb/LyjeNg==
Message-ID: <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
Date: Mon, 21 Sep 2026 17:37:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback
 completion
To: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org
Cc: willy@infradead.org, jack@suse.cz, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 baohua@kernel.org, youngjun.park@lge.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org,
 chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu,
 hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260921152449.629486-1-alex@ghiti.fr>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260921152449.629486-1-alex@ghiti.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: c65xr4rbhbygjh6r3mhya3x1sqjuep1c
X-Rspamd-Queue-Id: E4F7318000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1790005046-120428
X-HE-Meta: U2FsdGVkX18bcgY7Le42VMPOgsniJgJ/+1AAYNdFM6kl/ZrL7AYHbugQmeeQslZKRuTSq65x8dd9SSLBxQ9su4KoewZc4O0NIiOCXuG66m1qrARt6KHyFMUpXetVVyqTDrLTEkFPrDcoQiCnVvIL3eubwKytF+ikZJMMGFl2HidHPzaqyWT13fe8VG0w8NZjv3w9VSKnQpfDkiT8mxAUSL/DRnw0s0XzH6P61Gn9PSbkxt77XsmTfjPvXkP86yaTDX9wGo3KacPz1FaRr/CQGfO6k74d3b33jBTNdRTBBJNWAAYvKAg2/28aKhat+/5iAVdrVht12e95wpJHlrr84bCLdapmLOkgWcOgOSnNKMr42+7AgZpgtSWE8qOhZ/ujNgnMSv9SNtAq4V18NfXlV19ILsET8JJhDA3i30LWcuKMXNzhZFypZke9kSXVA4fKm2o+x+o5edYE/o0/enry83oGbn8tkrI1QtfNLcdKxrDNiv4Jzc0oXdoQwdybtUE61vcAGBbRDE2XBRIA8Fp8QOu2BwKH1Fe5/tDijPlkSnmxxLG9Jc/4OELf9F8lTN3bkW1BxUxt3UhJu5hmrIFG2lsd61ZcNRD6nFm8RTlEnOjcFVSIh2ykoqlkE9TD/ltcE9CXKm2vFMpohzI0YioG53DA1N0EavXKaYwD+Jn8qVKZ+XcBaPjpE10BmR9ZsC9V0GIuf57pnxIesSwE/LjrBFf+RJFmx51bIP1/48sFpEHbhoEOPzq7yPMK/ajOVPJBNOKEQRVcyDtRNrIMQHkILK7p4tISeNIGwhrQqkMv6Se46iVg12TYTrpAZB7xHXU3t7yB4JHW1okIugp1cn0HA8wjpFUzA69hOhoij0IEUHaipBb8WFie1nYEmS2hBNofUCzWCX7Qaa8is23ncpKPIQmTrcWANTNg5HRXGzBay7RSxYZWLhz6lMi2Jj2/uqP2xAyKC0FbK9uYQVwJCXq
 4aDX8r+1
 kHC3blixTo6+rMVycpmeg/eiPoRZ9yuJ4kdOvMIBCPN5OK7hHgNCR9+iRGCmEA/1olhYucKFiBGEOeuErZ7jIy6R9imtZPLPCCMp4iM5nGcZm9EbawbJzH9ShtPXwvLSz/NoQ1vJ1Ba7uacD51efrQd7i754HkgJ+ZypHRaqV+dOSA7qMSShmL7qTMvBdvc+ozmaTY09z6lXv9tsF5Du7rGFgkkVd1qoGkFTyBFmdjIhV7OAWe0kVkG2+WI/DiQQXguBQMQQzdIpYZCIWfkKhZf52vWc7jzJqi5ObTmt2ST8rGZNeG5RSmo/4Y3O/lIlyaazeD350uYa703IGhYD7cT3GsxNx1rgr8aDieF24PXXi6RZFJ3aqvafixub60ocBoxSv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 17:24, Alexandre Ghiti wrote:
> On an asynchronous swap device MADV_PAGEOUT only marks the folio
> PG_reclaim and rotates it to the tail of the inactive list once its
> writeback completes, so the memory is not actually freed until a later
> reclaim scan removes the by then clean swap cache folio.
But we have the same behavior when just reclaiming memory ordinarily? It's added
to the swapcache and only the next scan actually frees up the memory.

Wouldn't we memory we reclaim ... just gone, like in the sync case?

-- 
Cheers,

David

