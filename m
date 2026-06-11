Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFCD2CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D5446B009E; Thu, 11 Jun 2026 07:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC776B009F; Thu, 11 Jun 2026 07:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2736B00A0; Thu, 11 Jun 2026 07:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFEC66B009E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:33:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC1F11205B7
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:33:50 +0000 (UTC)
X-FDA: 84867422220.17.E155451
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id F0ECB160011
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:33:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkm8cpTB;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781177628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usVktg4Ep0pJ6k124plZbdxXdTrNHQJx7GVt+EoeuAg=;
	b=4p3ZQlx3PmAYG597wp6L/Wxpj6gmAK9a3sdgRLbGau3bRbxTEJfHTj3MyPSvH5Bzb88ZFd
	NHAVEodgf46ZeTW9kw8LZ1E8SnFcE2G2Bqn7B+W/mOlInHjAYuaI38MPz+7schr+Cr/bOP
	y6NxklcV2rKLNOg3dIi8C35/D4ptpz0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkm8cpTB;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781177629;
	b=jvB+8w2Q3d2SzuNdSuGLhPPP4wpO+GixNm67APHORLgJ9yIkhw3kzEQALvtJvWmooZja4g
	r7aiyza+wx9EJSfKlTceJ34tPxRqpgEkR59QA7/7HUSP2RDmZBsktTp8uVqhjvcCyG7EQ0
	+/MDPYbM6ojr4WF8GS5xpxftoLUgWQU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52BD960052;
	Thu, 11 Jun 2026 11:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED641F00893;
	Thu, 11 Jun 2026 11:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781177628;
	bh=usVktg4Ep0pJ6k124plZbdxXdTrNHQJx7GVt+EoeuAg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kkm8cpTB1A5RwccPz6eytGdyoqWrVvmW3GYxi3VnUyEfj48yvlQo55r9KF3GMSYAw
	 yjtQRlqRyUU/aRq7QI1mOvqUV2hGZIr5168a2Wxrqwjhq5RcJ9T8FUvAM97JWRqLrZ
	 /z5pVmoVRsAUBoc32R3nE/Gg3BGFRcBVehbbe8AMbVgS6SRVIjioTmbNJdeRRNud9N
	 3gVLPhgvW7HxXV3YMF2hTGXE8i3MdcTGGzlWliXWvgBMDQoal/vsMjl1st3ixk6l7k
	 Fj7Z3SclRDrVdqP4Py2cnD613sLFVpw4v1pbvSCJ5apoo6DfXl7zKq2g1SK1ZNkO6Q
	 XXyx0BXs0Jt8g==
Message-ID: <4dbbfedf-f575-47ba-91bc-3c0998845c63@kernel.org>
Date: Thu, 11 Jun 2026 13:33:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Miaohe Lin <linmiaohe@huawei.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
References: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
 <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
 <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
 <20260611023208-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260611023208-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F0ECB160011
X-Stat-Signature: wp3g8itciwy6ddyzb8s8eirs31jqffnn
X-Rspam-User: 
X-HE-Tag: 1781177628-388379
X-HE-Meta: U2FsdGVkX1+rVQ2glV/8DQMW1qmGYYUns/+vP7DvjbvG2inXFS9/uQzXP4T+5kxX0a926XuvBC88IaHEBWseYVcsD49Uw+Hb/lRfw+6LpgZ6hQgwzJp/OBcl14fzHCq8ieJoyAAifxbN3hzRBC5yonWB+CYgAAxggHcqN6BeQ+vTX04GhijkfU7hvDvG+eSiNohMb8Yj3q5Q1Eb7NkuCUChW8WXo+5nGuJtZm4+8U2RMg75DmBrrWnlBqbulkZ7+4nm+92oxG8w2mqIan7PejO4+KD3Sd8EwiYFFc9xJxKdJLkt2h3Tq7kc1jRsuMJX17HcZlUg3fL/rMwsmatMBATxoIe3XWSVotY/W5Dk8zDwx0sRF7N3X7tqeFY84CDkr+IIi+IZi2vKOKvyo6gd3Z2/HPE0ym43eR1+amyQHoIDMbo1b/0QZhIExDPwc7kEaZJx8hwX9Isx/MplaRMo+X+C/teSCFkSs4/0qd3DCYkBsYQl/arnWl0BUqxmkD36M7rgdPnJVymoebGv9X63pQLELZeUWHJcIrn3cBQ/irRHv01eRy970k0ouFR7vlC7Igf/EjMulgalnT7dSo79BkppMfhNGZRpfpiymyc1q2Ab4x2cO+wErnopTVIltsiyKtENwNeW/s5WmbGm/REUtcBrtV2UPS4vL5MFLUPHSzO2EGHPomrC3eJQhuMDrd+kUsT5rdyxElublrlja5is2y3e5AnptTuvKF5wZdTpd3clDSu3EEHDRTdhAsTNvK+3WWDt3Rks3hoWI47TzLbxMchjk9Q2McIroqDmjiX8FEdKDrgNzk181yEpGfYkwAynos1LSwc6ztoE82TKEUroPaIv0sHr+OvzK4eJOHNz82JvH1izORKbwHQkPhrEVtUe5g5rKNdkF6L6hZGX7eLS5BA9P9gPnDeXG0yq6TgqmvWHfbM40ywfSLtr1KPEq5Jju8JhgsnCaSaLoVXGL1bH
 zk5Xz1ew
 RCPfvA3SbA1zyCA9eaENrIz6eF8ELKUkYrXEMrXfEuBpq5MYnJJDw9/mertO8Hx0oCRdwcYKyjWvLUTIH8dWLbDrBeeTCejH3fHFuP5p9EwdzyEGzK+2xeKytxeRBIN4tzOPgNb5OpbinPFvkoPLlLpAnpBp8FzAkzJyiTH2wvoOOF7xCG1FG96qS12fF4gAjp/4KGbKvOCwxwG3jMAsLCohcOPbRuutGdLTkH0qyW+ATdsRAZeSg3xngCMC/FE3c+If2RBczQ5FtDEyW9EbgcJ71RJfx6Q8/lHe35Wq5a0Y9RsX+nZGbgZ4ZBlGhimRWU99TImm/mwUJNUKp8vaINZmo6QrOGRjSGvrHF9qv+c2fQ7SIk7bUv5OQkYHaaPvf8/qIu+OIiWwD6fFC60dfj+JH2da0TWf5tUDO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 08:33, Michael S. Tsirkin wrote:
> On Tue, Jun 09, 2026 at 08:38:09PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/9/26 20:10, Andrew Morton wrote:
>>>
>>>
>>> Sashiko is saying this doesn't do anything "Because
>>> __free_pages_prepare() executes entirely locklessly".  Did it goof?
>>>
>>> https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com
>>
>> Battle of the bots: it's right.
> 
> Ugh it's bot against human - I remembered we have zone lock
> normally in alloc and thought it helps and didn't double check we don't
> have it here . The bot wins (

Heh, I was primarily looking whether taking the lock would be harmful, not if it
would be useful. :)

-- 
Cheers,

David

