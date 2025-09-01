Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E26CACA1007
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 18:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488218E0003; Mon,  1 Sep 2025 14:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439278E0001; Mon,  1 Sep 2025 14:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3275B8E0003; Mon,  1 Sep 2025 14:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 214368E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:22:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F36CBBC8E0
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:22:14 +0000 (UTC)
X-FDA: 83841500988.09.3AEE390
Received: from lankhorst.se (lankhorst.se [141.105.120.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 77F7F18000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:22:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756750933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XpbvmIDUJOs50T4vE1pbVtzJQkix95RSUb22ostwp+w=;
	b=f981PPinGtjVAIBupn4v8mlgIzcOaopIXm8E/qbRgJBETXJKXk7YnML2VWvHVhUCWvpqC+
	YoKK/c7l3jXKJM1e0GCfKsyAaXym0UsGjs7vPz9vfM23/UTnNdcAf8wptX18FF7Tlr2DtB
	2NXT8ec6bNA4OMGqvXfCxBURIG1W0wk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756750933; a=rsa-sha256;
	cv=none;
	b=ZQlxzn1aqovkxZEl1UlWf3Kxppa+/q1nWoIiR/0lOlzPxtqeDV8BbMpxT/JhJkfN4WG/fC
	N87kFDdi6KKfSPR+SUoNCez2hU7AwIG56jbMYONkNZxx8V4ocLVuZrmqnIPAGiPjaytaXP
	icv21UqgS3ZMDiPSsViXNgYfITmRcFA=
Message-ID: <0d8199c3-8c3f-4838-81dd-ad191cb7afc1@lankhorst.se>
Date: Mon, 1 Sep 2025 20:22:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] cgroups: Add support for pinned device memory
To: Natalie Vock <natalie.vock@gmx.de>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 =?UTF-8?Q?=27Thomas_Hellstr=C3=B6m=27?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Maxime Ripard <mripard@kernel.org>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?=27Michal_Koutn=C3=BD=27?= <mkoutny@suse.com>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "'Liam R . Howlett'" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Zimmermann <tzimmermann@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org
References: <20250819114932.597600-5-dev@lankhorst.se>
 <25b42c8e-7233-4121-b253-e044e022b327@gmx.de>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <25b42c8e-7233-4121-b253-e044e022b327@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 77F7F18000A
X-Stat-Signature: inbpsbryrdxdoxior86xp35shh83msh7
X-Rspam-User: 
X-HE-Tag: 1756750933-727288
X-HE-Meta: U2FsdGVkX192uUpX1TsqX4RhWOCD0YBa9NMvXIfrNcNHXKQnAHIBlYt1OIyXJyqw1fP7ogejyeT619vIUQxOjBeLjVe1qB7mDtegaRc7vnqqH3FjpT8/8dnNwqkNh5Ao6dm77kMvpyFfITdBLhVqwU5XpnD8DVknc0NuP4eWLKvRk7/28KGRIrINXu8+kXI2scEs1InjatWSLIIjjVCGh3DTw09bCwTYJx/nWNi7kI6vMqe6ooMwN6CrPjC4cuIzzTA6C4JgyLpe7OBrRH/XDDsnism3QkgKVhtFRRxDjpGREu6Z4EJIEsU4gMwWqVYvtS7+UtgG0V+g4ngK2F4YQ+FM0UykJI6VYVdQm9jCaANsYpZCOIkbvr7ELz0vWeYb766Q1rMpM+Gozhz+78K53EEbFsS0O5HgUq0T0H7Ngd9dRC5FbQW4gwU0ckmZ0urbahzghK/OJLI6LZJ0GHXTEvovk1nRKXhXrRTDZ62h6cYmZjHnugpLExXjMautMctnbVphWm7ARK4EoL7Tsy3KmSMkx2boP69kygmErVH6lF/xzqLdMtD3bNy/aRQI+yjOiyAYRSRdmSCQw2JFjfiSzl3DXHJz5cRh9pRTzCud0ylm2C3dBCjCKic3L0qyQTb/9/eOsOv51woGVmqa/7KcpgSFbRuQ3JkdSEBUBzomnJ3YesBspCCYDSJk36gJ+8Ioj47hYOL2PnZ/Ap0kBFjm9x6OkEA1p650eA/+Xpiu+TPKy4nz/H8FJfSGutLgS9mFJ0mu3vl332Hu5HH9Ja8tJ4yoaTz08Lzd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Nathalie,

Den 2025-09-01 kl. 14:45, skrev Natalie Vock:
> Hi,
> 
> On 8/19/25 13:49, Maarten Lankhorst wrote:
>> When exporting dma-bufs to other devices, even when it is allowed to use
>> move_notify in some drivers, performance will degrade severely when
>> eviction happens.
>>
>> A perticular example where this can happen is in a multi-card setup,
>> where PCI-E peer-to-peer is used to prevent using access to system memory.
>>
>> If the buffer is evicted to system memory, not only the evicting GPU wher
>> the buffer resided is affected, but it will also stall the GPU that is
>> waiting on the buffer.
>>
>> It also makes sense for long running jobs not to be preempted by having
>> its buffers evicted, so it will make sense to have the ability to pin
>> from system memory too.
>>
>> This is dependant on patches by Dave Airlie, so it's not part of this
>> series yet. But I'm planning on extending pinning to the memory cgroup
>> controller in the future to handle this case.
>>
>> Implementation details:
>>
>> For each cgroup up until the root cgroup, the 'min' limit is checked
>> against currently effectively pinned value. If the value will go above
>> 'min', the pinning attempt is rejected.
> 
> Why do you want to reject pins in this case? What happens in desktop usecases (e.g. PRIME buffer sharing)? AFAIU, you kind of need to be able to pin buffers and export them to other devices for that whole thing to work, right? If the user doesn't explicitly set a min value, wouldn't the value being zero mean any pins will be rejected (and thus PRIME would break)?
> 
> If your objective is to prevent pinned buffers from being evicted, perhaps you could instead make TTM try to avoid evicting pinned buffers and prefer unpinned buffers as long as there are unpinned buffers to evict? As long as the total amount of pinned memory stays below min, no pinned buffers should get evicted with that either.
That would be setting an eviction priority, that can be done but that gives no guarantee memory will not be evicted.

Kind regards,
~Maarten

