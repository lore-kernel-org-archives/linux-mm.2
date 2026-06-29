Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17558C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1D2C6B0113; Mon, 29 Jun 2026 12:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF43E6B0115; Mon, 29 Jun 2026 12:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31346B0116; Mon, 29 Jun 2026 12:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF08E6B0113
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:37:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43FEEC107C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:37:42 +0000 (UTC)
X-FDA: 84933506364.19.FDF66A7
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0ED5E100012
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:37:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026062701 header.b=f3ilMgWj;
	spf=pass (imf05.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751060;
	b=i4pBXKRS4dX1tHonKRjoQpIqryREo3bCsbYreJt+73gWraHHArDUOZn7jaQqLvtxufRxuU
	llkUfcRW5chQaI9pM2aK8xr3WavMGQoZnEXn2fFZ4p9uceu6NwLgXBSpXljtahWQKgE7sy
	Vq/oPuONIgPbFVdVtQ4ss93dWH5Roco=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hydOrMOVfJpPy1RK9SdrTaqp0nT1DvgDdBkLQq657fY=;
	b=wsNOiZtKS//onaKb7tDEcfH/KFQ7qQZRg7z9u6ice2e/zpxHYOW60xHj/g5VxrSWVnkZow
	H/LBb8C5LVSPVoJpsaNkCvYYWlf4Eu/aQeokqEWz6r1ZZz6DpRVeEs647Ymu89OC3as7kF
	y10t5EH3LMRd7lt/ubbn+APp1c5k/3U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026062701 header.b=f3ilMgWj;
	spf=pass (imf05.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from [IPV6:2601:646:8081:7da1:68c9:ba90:b2f5:8138] ([IPv6:2601:646:8081:7da1:68c9:ba90:b2f5:8138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 65TGLFL5618076
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 29 Jun 2026 09:21:15 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 65TGLFL5618076
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026062701; t=1782750077;
	bh=hydOrMOVfJpPy1RK9SdrTaqp0nT1DvgDdBkLQq657fY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f3ilMgWjXzS9yJM/j5yvFtl534nWjsXQ1K+RYDbfTNVHTUW2tT6ThzU5x+t5hyj49
	 tkUhwl5iKD1jacrqoLdQSvVrhMqsr3bs6C5ZYLGAJBcXkNsWMOEEf8BQbrgz53GXz3
	 zJxXdUXaXfuY42K26nze+Hk1qkQRdm+kmEl1bxxRF99jGzZg1kUUCoX5qSH3PvBy5o
	 fT/6QhfAsFDBG/q92VW15KqG9LhWe55+I+Vfc7LCHhuMpiFUQc/oFaxEX7HxmYul4z
	 jdAOIKR/2yNwuqhonMQZBx70o4wNCQfdvXJNtIajaTTwWokp+ver5Xu2wrVSKeINq9
	 WjsGvInCjmeUg==
Message-ID: <37a630ef-1574-4415-b42c-1d23993c6084@zytor.com>
Date: Mon, 29 Jun 2026 09:21:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner <tglx@kernel.org>,
        "Zach O'Keefe" <zokeefe@google.com>
Cc: David Stevens <stevensd@google.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon
 <willdeacon@google.com>,
        Quentin Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport
 <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13>
 <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
 <87mrwon5uw.ffs@fw13>
 <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
 <87cxxgly12.ffs@fw13> <5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
 <a1b4b0ba-45c5-4de5-855f-7474918b52ff@kernel.org>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <a1b4b0ba-45c5-4de5-855f-7474918b52ff@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0ED5E100012
X-Stat-Signature: go1pb8cnbbpajyu3tc1mrokuz5e5c9xz
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782751059-26677
X-HE-Meta: U2FsdGVkX18fzjikUI64DUb4ut8GFV0EH6w/A5ZIhwha69//sv9cX8pIUawNuKHh1QZFjqbWzsRIr6zfO3KVhA5xMe5w7ISTuw9tYWzyFe03zNs313S+/UoEddZxLOnfCtlFYUxoiEzIvp9F+ZhCjpJESnWSfXI656YuZyWEL3gFWiE4lUzKDWw5zryKn/BEpsupwYjsdNWZvXt5NZfVCThHpphR7rry2lyUaE+phj4QtajrI6qMrhw3UbkawDJKL4SLWx9bIF8SNWizjH0IaIx9pABabO2DZTLqestO/4rNtbap2/1O9HIf8s+2N/d1MYLlp9qfTWuM2U26WAEpfPz2jXzh6IbNZFIL9NXZ4A2uplvzBYL8ipkkf8RRdPEnFmMToUgk+zLbE6ruPbs9L7wpQqSUBkS6rJH+/AombiENqjUVQcGGhZeVI5/939sNNrJkPXJIdYwEO6+WDFQl/cXhhf8b0ujlAkgzUN0a3bv4iQdGKgoCua03XiyjByQ08t+vsYcf2HYJuuKYJe0apO6cK+HKMoHOuP0UDpj/Qh3T6xYdZlz6VQEufDKP9xMVrTzP8EX1V21G978rQSFiOMvzRQVzPsngevB5eDB3wS1mQF2O2YFxn/dJi64mZUGW/T8Tlgzrm3u/46sTdxHtPnYC/Ix9p6r9PwaOxaKxY9KHkOMYxRfBFMgz1P31fpFDvDUsR3jpeBkRahqPw8P9SuRX/wUpq/q+osqUbusCdjaxwwAmITOHZ1hxrd07u6p6zP3OAySDwc/uIu2fFiU3NBIga5C0bAT5E7XCpDGIwiTb64hM+nmlAsZW88n+dSU3G84Pk6eVfrJLRlkBh2bo9Pu7MsSEAm9QOCzVJqY+cJ6xRy+dMEy82i6cEulnO3NOZqDg++VQA8DLPYnXT7i/y0uBUyq05JdxqprF13jjkKdvzrdfc0mf1rerINVDUWITfrfRDJp7iPrEv7idG+9
 ymkEgi9Q
 FMmMunoECTzY2OnPMf+2V5R5Hn4YxaMCt0jp2Mfwxav5FDGWphzQN7vkIlP1tdrSUJezPlFrPKs3fAK98aBokXUFYLuIjal5EIApu4RvgwCiP1tyhFsZqE+xkIPUTikXrRWSuzZwQ4ozAoe4Qc9jzV+0gh9Or+BEGmNgOUAOVtI9YrjhkhRmGK9uZA00Ai/FAgbh8SAGm6rn1zaBVfh7fbsy8lClhdhMXyH1/jjlY6Yx5gH5pYH9a2XHCDJaHV3v+FAZn6dzNy+SrQrv5UBD4UrIu68Nj7jIy0D2jhrz6FVjgsbNKtQE57lJc4LKEANo88EUXdXlxTl3N44HBOaoS9oWPSGRJmCb1FZLbJe2s6XgcwO0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-29 09:18, Vlastimil Babka (SUSE) wrote:
> 
> But it wouldn't tell you what was the large stack? Or we could try to print
> it inaccurately, and hope the non-overwritten deep part gives us enough insight?
> 
>> There are, of course, more games that could be played with stack depth
>> checks on normal interrupts or NMIs. But those would be less deterministic.>

Less deterministic, but probably more informative, since it would be possible
to actually get a stack trace.

	-hpa


