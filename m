Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B39B960A2620
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NtixXTCd
Received: by kanga.kvack.org (Postfix)
	id BEFA16B00EF; Wed, 11 Nov 2026 03:01:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7436B05B0; Wed, 11 Nov 2026 03:01:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04456B05B2; Wed, 11 Nov 2026 03:01:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9416B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:01:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 275CD1C2AC8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:01:32 +0000 (UTC)
X-FDA: 85422093624.13.CC56F68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 57BBB2000F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:01:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NtixXTCd;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794384090;
	b=GloK6GRJrJvw4WevVpggjFzXoKG+abTyi1rod8XIBkaC7LrxfVCZgjeM3oB5f+NjIS8G0G
	Wjoylu5YfRcPIny+e9yz76CjiOIxH7ZVQc9NxrM+5ggZEWUXWvd6yHJvfPqwMyXRhJp5jx
	CwWla9ZG7lVk+zXecjR39iLSPQjTOa8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NtixXTCd;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794384090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVc2ZYCD2YVNqPKyUBpSmxHMrCi8kN4CJjrVjuTDtsc=;
	b=uTe4MA2xq6oQAe8RoaFOk3bHD+Dh9s+HWHUchTjU2niDTj261Y9Diqjua/rQdHXQIhOdEr
	l2LAYuE/Cz19dbL1MjVPB00mX1D5qkTQqA4g19nug9go1d2bZqSyrgVpTupz3LvcWUVZmh
	tVhKPvhZNqFvB2nS8wiuLBUKehvS5k0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 94848469D9;
	Wed, 11 Nov 2026 08:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550741F00A05;
	Wed, 11 Nov 2026 08:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794384089;
	bh=FVc2ZYCD2YVNqPKyUBpSmxHMrCi8kN4CJjrVjuTDtsc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NtixXTCdf8MJ+bKDKsGFmiGcAh39N8+LKDUfqngLVFCZIuWCdMnte/fpLO4HoaMlX
	 TDYBDyigxz0oxhUcxrEM7MvXTfwkT5OJfCkVAz7cxgC1Ybnpn6kiB4Iz4qjLL45DUx
	 fKx9qpoPtcfjTDjAkS7rC7VdNlFnf2/1enzRdNpwQubaGVX2xqf2p2No+kWNOHBjmo
	 W+Rzz7sV0oQse6XrrUdv8o8CiUqYooJGDj5fvpk5XIvXQkFjH0qgjQhIJx0e+33xTP
	 3wBMpPXaP/i37xgxljs4+Pk+bM+IbiZoBx3A3sZhop+07Dc1ar1Ni6jgjWZw9QIkMJ
	 jeydSyhEbR1ag==
Message-ID: <ae558242-fb88-45fb-96a7-804b38753ecb@kernel.org>
Date: Wed, 11 Nov 2026 09:01:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/vmstat: remove unused folio stat helpers
To: Shivank Garg <shivankg@amd.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261111-unused-sym-core-v2-0-3edc7fb8581f@amd.com>
 <20261111-unused-sym-core-v2-1-3edc7fb8581f@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261111-unused-sym-core-v2-1-3edc7fb8581f@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k99bhi6nbh9gec76nkp7jz4d5zyob1pz
X-Rspamd-Queue-Id: 57BBB2000F
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794384090-140515
X-HE-Meta: U2FsdGVkX1+Eqfx+PPbEXw/rmFUvj8s8hX/LpArHMzW5F7R4WcrqeyMnUyWuwMf4vGh6GgMjS/RY4u8ZEFh44sqOcn63qZf3cgP0psYNCOBkKbOdqI6Ad7EzTS6klV2rPU+52JefvV73aHT4ADMSke2Famr4Kigyh3/YST9M+CKZYuMDCUvpdyyplNS8Pb5UdM8dixwhVRUlEbvH+oRICThGT+aAojhanYyeWiDdHNPGE+/3d8GyyfKTlVsAsQn3MK9qCQt3J/Nme+8z0+iibgjwQCPIe/pRgu1y4qvyWfIhZaqZg/Hos5EvjHsmTu6AjGWRtkaJfNeQ0XZoiMyS6iOJ1I++sCZpWRsoL6aEvn0fKIsTn/jPDRH8hASg5JpE+3KLvIeJnaQJTDwCgCDi4Tpr1NUtosxjye5bAE8CA5LkYmnDjvJxN6Lo/auNlY942AiIcHIrMc7RgV5GFts6isSm2MBkUFsNJKJ/LH0szCQ1G8x+2cjoUl7hjdtuQk3nrPhB2F28H0tnolvVaMRuBYoFtkij1/NFYJIVR+QAVm3RAC8IanBn7dLiHzeTR6Ys30qdG+1X0+Swsy1Yf6o3FYZlcAHBCxZPQQ7prvsWKvEp0PlnnbjIM1orzPlpaBZG0Z6KQN2k9qwbOSGkuZ5lpFfLwy8+CUkbpnrqKyiKxIzz7v+Z0TThXcT0DaAEUYYkqm2ZA44mQI1R36Tfjl+7VrcFpTFngNfiX90BAuOqA2xQALLAXGNgYyX10vsH9sYb8Fu5EyZZ/EIlS5NSNANHOhlWD4YsL/h5Ebcwwi8Z4nNG7ukan3gP5Wju+13IrCjZ9GZEfd/EaiMPStZXeKFWsHuts8j8ur7Fe9EsMv5DXzcaoCadpN5v9zd/qxcR+bASyBCf6VWLQyVLDuxRUYZ+0vtv5oSRu1nZRIjmLgeZ1jykqRTt3uo8Pk7a1z3V9e0G2IYKDm+ZQBMRuv4pNYF
 TGJF9+H9
 7dfBirWLV9+J86XyfnSPpZhmAEtoMyR6Nks4jpsADVnqv+c1O2Z7WazO6hWcoNLhcrXh9/pD8iA1rrLfvzNAVE0koC0HYbsJDQIa/iXcXGi9OwPnfbuVowVKHJm9Bti06xZGuJ5Yxs/PELEijHt1DR1lIZGahMTK0vSyVLrT1whCf+6r5qm2z+vkCsdFPVTRmWNdSx+D676yaBMx0v08yDoAzJld8qls6UPS5VmPS13yNXW7jms9USJh+2QjpL6nwYj4JEcgdx69A7/M1Wzl7XgkLA5wljAjorLwdDyKXAAewv5X38YpjEnnAM28nue5uLQ5/S2cvFU5DsdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 04:34, Shivank Garg wrote:
> __zone_stat_add_folio(), __zone_stat_sub_folio(), zone_stat_add_folio(),
> __node_stat_add_folio() and __node_stat_sub_folio() have had no callers
> since they were added in commit a53e17e4e97b ("mm/vmstat: Add functions
> to account folio statistics"). The last zone_stat_sub_folio() user was
> removed in commit f1ee018baee9 ("mm: use __page_cache_release() in
> folios_put()").
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

