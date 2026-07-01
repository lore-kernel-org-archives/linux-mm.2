Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8726AC43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5282E6B00A6; Wed,  1 Jul 2026 03:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA326B00AB; Wed,  1 Jul 2026 03:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3336B00AC; Wed,  1 Jul 2026 03:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 004DE6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:31:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83A71C1802
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:31:49 +0000 (UTC)
X-FDA: 84939388338.12.AF7FC44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AAABA40009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:31:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IHzOwZE+;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782891107;
	b=QeOjWlkzfXl/MoifpoFU8wNQFopNFlPgApaoIpuUShv7Nb8jG2XjmVDNMKVVelErU3XscG
	UkZm4zu5TKMFmLBMoW5sD0QxANX2MpnKWiNkgwwjU83+aUJ5bfDWVSRulKNndxwuqbWt80
	q2PNJKDjgiEa95KUFrJtXppjzPsMAdI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782891107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1/Roy/gd5abi7rQ7Y2xyhwflNKpb+1eD3pI7ypSC3s=;
	b=yFWNA9E3puFA8kObN2WQADIeIZTG+PfI1RPiunJaPfD/MjJZvlyPNLe1wGu6ns1BX/qLAu
	lXuq9Gtgnnh0cSNkQbEcdhdMBmrumfecB8vbVBCqPTH54GcngRSdpxpVK+XUXt9/Sa8gvE
	2qtUw2HMEjj4naLHxsbzp1uK/Sz0NPc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IHzOwZE+;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1CD543913;
	Wed,  1 Jul 2026 07:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA4C1F000E9;
	Wed,  1 Jul 2026 07:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782891106;
	bh=G1/Roy/gd5abi7rQ7Y2xyhwflNKpb+1eD3pI7ypSC3s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IHzOwZE+2TRu3VAS3ekDTfmRdl7r6/wviT1GJD9X+POvAFx3nGTJnzrmIiONVjNB7
	 ikDJPjLxIzhMkhalBoI1xALtxkQk8+8SMV6x4M9XFWldjVtDZXRXCCf9BjHHxesoyH
	 CB7aOPBxefEwMfdVEfD8uN8QjKCTC1F7lwv/ipJM/5j79p+V1zWXw6frsA8K1TLVX4
	 OOpG8HnJH54ZC0LuvZ+OidamnvFsWFGLK3OA6XAx6CEB5M5PZeI6W0LG24hz3K1Aad
	 rqAFWvnx44xuYt81DnmOiET88rUTSH0DkwbJN1w8WFH5PJ0q8Ye6Vort0a23KEWoPG
	 koWC8+Dth7pMw==
Message-ID: <46f9f24c-a842-48b6-ac95-add1942d086e@kernel.org>
Date: Wed, 1 Jul 2026 09:31:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Andi Kleen <andi@firstfloor.org>,
 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
 Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629192811-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260629192811-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: in46hz36g4z6zj6uqrpyk7anww3yusws
X-Rspamd-Queue-Id: AAABA40009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782891107-320744
X-HE-Meta: U2FsdGVkX19axl+7IQOBzI0gXWUKyDXDpHwN2BJN4uPKYPZ8LYC5K3emf+YCoue+7guqgTPh4aW0Ccou7BytwlGcTNktYMcZCAhd/Tq1cnFCgjuLY3ZifPSWfI0YT3YHlh/xinaVzfEjoi+2Vx1PDGtyImkbxFy+WZ8bkKcRV5vtxPgyl4Cr+p6XAqevH5bnFlh8HguhgNYvvjexQuQH+byy1YfN0BIx7EMqhGP0DNlidvHkGyqFw+RWIuU/nhprnLSNbcepnh/ofgl30XuFHkW+vUXqHBvOkYss7RD4sodWzEiAB9ErVVXV/E/nS//hOO0TrAzoOx8U4yKakc66F88WMf/JoL+ArEnjqx5Kjixr0UywkEsBKfv1+geepobUseYXs5JmINHaUnmH/b1En24lPyvp6VMOVURSkXD+tR3aflwYE3I+7Jf08amemMeaYCnxTsTGELJkaTwpq0d+xqRB5lYxydqx4jdak7qHc5yPLp2yiPIiGf5ZYb4EfoDXBSN9lRo7Xb5qdWBBL1yYUQ2qB6g3mg2esBqnKlZ0bAB6RihQHJKI/Ou94wYvZ3ONaKWL7MAHQDQNruaou4M/rX1XNyoJPxt+LB6DcT4jtc5avtKw509JzlmmIRLMC7l2T7CbbGnbKpRfmoGEd+P0B8kr/yw6qffIsI6OG6/ie5yKuPEoiPhzGjeqzkRMwS7LpPllncvu9T3McCTHZqTfRkBlLt2KGP11mtUldnvge9CXCWaS+AL/1ehVi2RpiuhQr/OXPnig5pur0DyYPZ+DmqGPKJ9CsJpWr3ymxDWH3wovuDyu+4mWJ8YIuo6zvpv24iVKgaCZtoVXtli8NlazQFxkSoMLFkfDBLTpq+SqhB/NLR+HvuPyunyt38/oXSsuMLcKhYC1ZpYaZFZpTfYxfXDcTKskIUSCvgV7BVm12PFhsEMLRbhcTZ4mI6SGING5MmR/5hZ4bzbrNlEi5+F
 fQOlGCzU
 oquJ76uH6sJmJZrzw3EuJfHf0zNYA6bbyU2ZhfCuuiapkkhd7smtVfv9/C8Y+W3l320LS0xy+p4CmfSy3ZNL+8RfKh115cf0DUOsdzX4jCr3Jo8kFDSqD+mmGUAobsr5y602GPH+am7K4kd+PPq2Q0wkUIFzSHpwcE5xm3p2FCjUT1ktdZUgdg1kNg83aMOVekSs+rNtkbJCCIVN3fRSOFlcucTlZqGcvMGjl7yECqKaeSnU01nXr7fCnTQOalKMHMQ2YGXMrHZgetghjCFxiLi0mmPRc1JWyKXFa/cicj/9hLlG2tztZpKQX7JOjdTnugqUlRlK61JxCjTB8KkBvXHtIwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 01:29, Michael S. Tsirkin wrote:
> On Mon, Jun 29, 2026 at 03:05:18PM +0200, David Hildenbrand (Arm) wrote:
>> It would be good to coordinate here.
> 
> Case in point, do you feel this should be blocking the zeroing/page
> reporting work (which adds more non atomic RMWs), or I can work more on
> that putting this aside?

For the zeroing optimization I think we'd restart with a proper discussion on
the overall requirements + design (e.g., options to communicate information,
options to do the zeroing, possible simplifications), as there are differing
opinions on the general approach ... and my gut feeling is that this needs a
proper discussion, as it involves folio allocation and severe core page
allocator changes.

.. and as GFP_ZERO handling is a mess and we'd need a bigger discussion on how
to sort that out.

That is, I'd want to see a discussion thread before sending more code to the
list (and ending in a sashiko review + resend spiral).

Of course, you can link to code, but it will make all our life easier to explore
the design space first before getting distracted by implementation details.

-- 
Cheers,

David

