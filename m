Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7656DFED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E380E6B0005; Fri, 24 Apr 2026 15:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0DB26B0092; Fri, 24 Apr 2026 15:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D265F6B0093; Fri, 24 Apr 2026 15:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C12176B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:09:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 908F11A02B0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:09:37 +0000 (UTC)
X-FDA: 84694388394.03.6C6D7FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D59EC40011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:09:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=isLAgSEI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777057775; a=rsa-sha256;
	cv=none;
	b=wzNHyiE31/eAybgvyPGYrJYUEbfp1iIf/l6g4vSK7Wze1Z4OG59WqySIDihVqdGnP4If8L
	1Wl3iJhqyTnBWiBcGW9EUJaKTTFnPGF5y18tIdajRYCBW5BKLddaioZb0G5Dg5eZQ8dJGc
	pKL2M71vTDwQF2+ggyniEHglFdZ7tQw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=isLAgSEI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777057775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=US9pjhi8xfLSQ3RrEDHWxOi9twZpnxer/YnSe9zuX+I=;
	b=LWep1izlY6rqoKgAjuRfZcmL6nKsA9Y20Vl35dIyLlctdKP7GPlZuG9NCZDFHK72ogDqGD
	oe+sLuFVPcvZOXH5kqecCs8Zye5nUvAO1ZD4r1ilwc8OqrJo48TF1yro7t6PNuRbPO5JZv
	4sczSOXyhpM//2Lv7ivGX+rZxBGsJbs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 25599600CB;
	Fri, 24 Apr 2026 19:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B10C19425;
	Fri, 24 Apr 2026 19:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777057774;
	bh=cunTZ64pvjCKgwH8htSk0cEOh+PrQSapQikRhhxQ2yU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=isLAgSEIjTaRFvzq1pCROoE8HoeIeCHv2Pm5XLY8LUqERfpOtEyFIzSj2kdSC3fPF
	 2EjHO35ZL9cOJTSodD6lhJ/ut8ClvU281wr6i7mx8UiMavdfYIeuqwnHS8N35mZUp3
	 Rrhifka0v/uX3ZxhZLQy/Jg6yxpe3yxKHPYd9YWZm7Z7gjpnPN3zb/zv2TOZsC3rnT
	 f68ek8/JlycJk8IcCSuT+zdhPSY8ZmnUHt7gzL+cwln8IeKwH9Dvy0x+9lXGt+VlEI
	 T3XHr0b35tgt9XpSWvwHHf2pHnc84Uo1HugZjn/rmx2j7hl6SNKsfVaoBaxCVICqHe
	 rvM49ucB6GO6g==
Message-ID: <4e7699eb-e101-4a25-b585-79a777eb7cc2@kernel.org>
Date: Fri, 24 Apr 2026 21:09:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent
 them
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Lance Yang
 <lance.yang@linux.dev>, peterz@infradead.org, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com, roman.gushchin@linux.dev
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex>
 <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
 <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
 <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
 <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fogzur5az46u3tzb61chq9oebad3srq7
X-Rspam-User: 
X-Rspamd-Queue-Id: D59EC40011
X-Rspamd-Server: rspam07
X-HE-Tag: 1777057775-630321
X-HE-Meta: U2FsdGVkX18Ee/WD1yr1jccQdtA+Ptw1Jfb6MY0F50WcJqngL6Yzs6eCsmv0AVTCFGSuO6gDmTIjMKiYHvqr3eIKifIMRnCtGjd7Wtqjn/B/0EkftDuqmh/mZXZOm6oCBUOFvVNSJig8JuOzpZoYWRfoZ/AWQ3bvsTmP32RstbJWombOR9bENnRUVdbqmouFj9L9QKT5uacqli2+kuwJ9s58U+JlxEkxy6DRMgR9P9ZSskTyY4uyBi7+sbzFdB192GEvevOJQiQ7CaGE6bRMzDjK3JIdt09WNEHLsL0Udfflp1eFldwZvHb0bfMD26PB9KDxAs1gslVCxwQCwPDcrsBtVgvanRFglgUmO2bxzx7upH6UdBKgpKezuBFal5E/yf4PF6RXGb0ptTSd2fjaVbj4MwhKmXBpZkQMWt2dxOVKlIHgZE2aIuYqv6cPuHpITHZ4naVg0mQsJk82GpTrABYLxraPKBWY1aQH90cK0F1Lg+DBKySgCpBeKpqZnYVt3SEc/QVu9WWwvVseQp2PqRzpUkQrb4WIimS5NNl0AS2nULhET3316oigQwy7XbcyGsmpK30YlOADbtJUZoLE/TgIpgqUETEytmwR8uP/hTXkQmC9uboczAkuWVlg1W248thhyFdspoiPseOvVC2dedPbCUv2KCMjw0VS8oqYGQ2f2hlI6jPlg60IqQFQmaLnlYIE2UFX6LgUqln+/jZ5qUJJwO0d01idXzPXKUGgj23d1OMimnvQ17lxCkKPssK7mWbH2EZZ1rmfuF+YsxdW35IcTX2F4rYsr+zHhmeNRnqTI6KvRs52Kdn1F7ewhwMsiRoJof45m8DvqgBz/eYiVcV5aDTiKqdb8+fEvPIZgaeDzLhCUrskYrpLRe2HzClydRxHx2C8oFQJpP98ZDaHgUYTPJ7ylHAQ+JAWzIw3HBWWf1vR6FQSB/DbTXGbIKy8X94/OG6CrTyoEInCHi3
 WgeqMpn9
 bArTf7ZXuk7446/9a5psgEamWMZVQp3akWEFSqVA+GgEQlukq3xTrBe8rbtlYZ8IgeBMQiKRSVr/D3bNK5LAHzz71mKpBZoTCWdYax4hlXrT17sB3/pOYOxdzlNR1hMnbi6wJEQufK+wXZpXExPN64hjjhfGcGKrCvt3w/GzOi58rusnHiJcvNbPhFWj+rzNyHZs2YpBHvAideYSZqjZNo2hhiVrZWnCtz4IAY4SNjQejf811VL1UnxB5WgHfDsiSRjb5yxrz0+JCFQM363c9IEu3eRiwYApLivvVshN1M+Keu1VoEYXgYV3tykO8qglMNxm0D9wMXBFcFJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 20:50, Yosry Ahmed wrote:
> On Fri, Apr 24, 2026 at 11:36 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 4/24/26 16:31, Andrew Morton wrote:
>>>
>>>
>>> Why do you think so?
>>
>> The most important part for me is that authors are aware of the reports.
>>
>> Sending them as a mail forces people to publicly reply to the feedback, and at
>> this point in time, I am not convinced that that is the right approach.
> 
> But I imagine it's useful for reviewers to see Sashiko's feedback as
> well (without having to go look on the website).

I read a lot of them, yes. Maintainers know how to find it.

I even think maintainers should  briefly go over it before applying to spot if
anything in there is still left unanswered. But that doesn't need a mailing list
posting.

I enjoy if contributors are aware of the reports and use that input in a
reasonable, like Zi just did [1]. And if they are unsure, they usually ask to
double-check.

[1] https://lore.kernel.org/r/15191F7F-0D10-4907-B963-DA4EA0E36EB6@nvidia.com

> It's possible that
> Sashiko is right but the author isn't convinced, so getting more eyes
> on the feedback would help. 

Forcing contributors to reply to everything. I don't like that, in particular
not as long as there is no way for contributors to run it early in private.

In most cases, contributors just do the reasonable thing: incorporate the
feedback in a new version.

-- 
Cheers,

David

