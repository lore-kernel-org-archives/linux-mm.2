Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F10ACA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 11:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0BB6B0088; Mon,  5 Oct 2026 07:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 261AE6B0092; Mon,  5 Oct 2026 07:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150DA6B0093; Mon,  5 Oct 2026 07:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB9216B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:04:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8009CA01D7
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:04:24 +0000 (UTC)
X-FDA: 85288288848.25.3C621C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C18121C0009
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:04:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jM81WAzf;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791198262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQGvTuamVVzdOynNKDQKFmElV/3GB8rgmLRgY0GV5+Q=;
	b=IHIZfiYiEFQzjdbkcoRIncDyXgRqbg1ZNi0Deh50To1DIGPJ2sPpurtW4kYWeYnrT2woX9
	fhf3LSXyq3wM0SRJIZYSYITLGm+1Y8GNrP4Qq2SVSsBZZSq07XSSrpSGWBb6CUt94c4Gbd
	ZKAVl7s7zoK9PsJhKeE5jdRC35Q3OGE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jM81WAzf;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791198262;
	b=I/QcC01eE7pE8luibKXJhMEKCtsRBDz8s+nFfiuW8oPBHNvIRynIaGIbQe5AWHkkd7piPa
	VcF0HmMz9BQN7qZx+jIc+XdAXpzM8thDXNtXvCmx9Cl1jXdxskTApiqaYgPWSoGMFdf2NF
	pNF8Ur55ny6IgGeJkbhlx3POs9whDeU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48AEA60A70;
	Mon,  5 Oct 2026 11:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBA51F00898;
	Mon,  5 Oct 2026 11:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791198262;
	bh=hQGvTuamVVzdOynNKDQKFmElV/3GB8rgmLRgY0GV5+Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jM81WAzfzIcYqZacTuYKqh6CHKgtdfBO4m9hZjZvMVT3KUZAbhfwyh+CBEwQot6/q
	 xIoFBNHUSxPH2iLzPUEhWx39VOV/I9Z64v1VCEE4H0M0sNmQxcYOI98myZzaJteUHD
	 qMn8PCwkHx7+GJZvZ0Np2jAA0oGFz+4Eg0ne8hnrX5pC4h/k4KYxVQ5nzpNOh0CwVX
	 wSEz5pUht/c1FmJqcXXeGJJGIgPNAOp4+t1HkbHzlXgGsbuNa7o8+OKaqTlHnnjSG3
	 EG1BkyQuGIoHc34ifZSC0GrgAEeC3fnxsQIda2WEVu5pPguDTK/ClwgWsjiY5PKiqa
	 45uSBBUoUxK0Q==
Message-ID: <f162088b-6f80-4e5b-b250-dbf0eaa99816@kernel.org>
Date: Mon, 5 Oct 2026 13:04:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baoquan He <baoquan.he@linux.dev>, Baoquan He <hebaoquan@kylinos.cn>,
 linux-mm@kvack.org, akpm@linux-foundation.org, Chris Li <chrisl@kernel.org>,
 kasong@tencent.com, Nhat Pham <nphamcs@gmail.com>,
 Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>,
 Yosry Ahmed <yosry@kernel.org>, shikemeng@huaweicloud.com,
 chengming.zhou@linux.dev, linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
 <aqrHjfHwyEtRIr5S@cmpxchg.org> <aquWKJoP5JLP8Ci7@fedora>
 <20260917131712.GA1344@cmpxchg.org>
 <7bd2b824-4c91-4378-a817-d5ce475ea84d@kernel.org>
 <CA+mpNMkmnHrpVifBWi52f82KzhZZ501izsTeRPzvRr-i0su0SQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+mpNMkmnHrpVifBWi52f82KzhZZ501izsTeRPzvRr-i0su0SQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C18121C0009
X-Stat-Signature: gptzzm4cst7m4m5db433abmsrzoimgpy
X-HE-Tag: 1791198262-285073
X-HE-Meta: U2FsdGVkX18FtaWgRtwXI9cjYZDmTirHPNF4fuGfV/FRYPD1k8pFTwRxKQsNFMW2gLOpL6LA55IQd9ylG4mF3XDcFiG4xtEY2rgJjTWIdTl33XvzrK2dfdg6ghzO0dpeJFBx6AIla/Ij+Q9OI9OkKlvrxoPaIbsn2NglcXqZUO9LNc8txWs1zyDVsbrb9NpXGmzS+Pyb+KsG2Ui3ZBVD/+TVaft6gyM1A6b5Lo/Br38cHDcxpXb9XQsrWt3Vt2xZR4c+UNMSCa2oVhbg7DIAvipIpAIygsgGqWmTUsjd9OcRcUGhhsttTHYHDR+3ej2UWlO0jtQAkWcWP7cpn4OMuYbR+sFNemcTaWevwPhaE4k16S+VHyPM1FMUBB7XTXkh8wPE+wMS1gm6wjKzydw9nqo6wUERAYUDcgxXD0CdmkmAybq/lHA2UmomcZdUL4MpuPXdS8LJyY9BLbvb54YzBC9qEtWvwR0Abh0MYjPS9cTbVbiIjzgZQ9EA3C6ddjPLYnNBjC9MDVRdtzpTQTBhra8Quve3GIlo9l7JX6AKmgM5ZvIwi96cNheabinY75hPAaN1WxQ/tsvlMMfGkdVJEBFyHMswfEiXXzj+NnenmjENtowi3aYpEzpxAWFzW7C2+L2TdtIIZfH06eBwpazkyPEv4rVLWroYZ3sm535ViwqcnWPapq0woXtKQj6krU8WlJ6b08y8ZIsV3g4jUx0+Z/PX7j1Gmla2ypCocfwiWzK3Kc/nz0xUUjTmN/tFdZtLQ4FfEzaL9QvvzgEc/Q+B9q9Cevzw2ARTojy2oTf4Dg1gK1eyUMqCrKQYUapzx3MGHWyWv/LFnZw6BEtMeCc01qJ6K89TcTm6qGXKvOAMKLz1Q9bPMKUHU/aMd3dsnu+IfxtrCaQ1jocpk2O9OyIqh5ik/3Q6fZDnSIanwWInvLbeJL4oHrdNZ2q2KOrteFyFwHOfHxc3ufjPVoLOyV1
 3W8z0BeX
 sPrnnxIUhVdPC/MXSx2c6QTQX10AVAlRX6oR+ZwQhWL2mVmJP1c8KupO19bB7HxxvNuaP3Ll7xqtzrS3hx3tL9N3XuDMDJKGf2l5T08DGcYFf6XxT36mcjf3QNZ0CdUo5k0Nt3b17OZezWYwtQXZHKAgPy9NHk2x6MZJRJUaIBVkEYC6fHmTCebu22fUtdi7ahTAHXV6ZmaXHb4zZONwW9rZGqkAHKrENx1nDkaYlYgDefW7VGtCm7xnzk2226Dgx+gfcBroS1/DJkWhYFxuZI+iFhuinaYFcKU3lmdgD1Yt4KArKMY4rsEJaEdJv0oK5iPbkCsWXEGo+KOzB55K86v0CynZTS+7YsYo4Aa/01xCijWM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/3/26 01:19, Johannes Weiner wrote:
> [ Sorry about the top post, on my way to Plumbers ]
> 
> Yes I still stand by this. The proposal in this shape is not compatible with the
> cgroup resource control model.

Just as I thought :) to move forward with this we'll have to find a way to make
memcg folks happy.

-- 
Cheers,

David

