Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA91CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3188C8E0043; Thu, 21 Aug 2025 07:41:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EFCE8E002F; Thu, 21 Aug 2025 07:41:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D7C8E0043; Thu, 21 Aug 2025 07:41:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0E61D8E002F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:41:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF4491DCD02
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:41:57 +0000 (UTC)
X-FDA: 83800575474.15.FC290D7
Received: from lankhorst.se (lankhorst.se [141.105.120.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id A5BFC80005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:41:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755776515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pYeLiE1cDg+D1GpDNMOOqlSU3+LbDZ6UjOlVUZlZse0=;
	b=Hda6Z9S/jZW1Q4hC799oK+DX/GkRI1+sqcVXW0w70SBSrjVje8zOALLvRJRtILJvYMnj3U
	9J0JZPJCmBDckaWcxM1FK3cZV/npeVJ7vzUTGyc2ZxODAKJJId45dXXkxsipQKjzhcI0qm
	9pziGnnxU05q/9swQnwMjf/0xvb+WMM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755776515; a=rsa-sha256;
	cv=none;
	b=UwZ882B+ZrZ/7+fg4MXNKMZoDlK75X+eDrJthNoyan2P6bOk/YSwLLpO89w1bfm8TrYoCC
	eXT/w+NvYu7NJdaym6pvhBafK2WcxeAzDHHXmhcQjfFNat57EBAq7CpM4PFRt6xiy0NwMN
	ZjZ87Eq+hHK51DvOuKRgUVIBkJoVGpA=
Message-ID: <533447a9-098a-4509-9014-631af83e0e5a@lankhorst.se>
Date: Thu, 21 Aug 2025 13:41:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 3/3] drm/xe: Add DRM_XE_GEM_CREATE_FLAG_PINNED flag and
 implementation
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Maxime Ripard <mripard@kernel.org>,
 Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?=27Michal_Koutn=C3=BD=27?=
 <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
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
 <20250819114932.597600-8-dev@lankhorst.se>
 <a781f7781a9bf510c3707a5c9a235e1dab785617.camel@linux.intel.com>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <a781f7781a9bf510c3707a5c9a235e1dab785617.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A5BFC80005
X-Stat-Signature: azifiimjnjbmwemjsyi19me7fdgz1zn7
X-Rspam-User: 
X-HE-Tag: 1755776514-381686
X-HE-Meta: U2FsdGVkX1//uHlt3lh+33lB3WUZ1FMg5ydLg6MVDnws4fuBF9h4qlVlxdXvguQ3p+5fAHZvXAbNvd2PyuZvyOVuJIJhFRiYHl8ZUp0N1rtAQzgDM22wr8fT5WjogwbIEnznIbD0VwjJwHgkU5XfYVQw0unVejyg21GxDm7bYuLVVwTCvUfjfUPOJMFDLXxZm4X2uGy7l/YD0S1nOoBxlva2iqCGuF1KTHUixxnml7+4LuF4bDHW7K96+i8lnEFW2bYlrQzLFImRu2ZQLBhc7tJgDU3tDWmwzJAAuh0UwJ5x5jR5jfNmarXqRK74QVAFEA+pGw25xDL9X0+mq5Vuj2uveEiZz+vNdZmyBZ+j0KX3GjqVBGbR3xBrt8DzKMo/0PwlbDnxy0xe4937499cSv7idpBapSp9n8VBNtlp8q07HgIkWo/OSA0rPHtE3XjtHv9F7/bcOtYYvKvV2Ta68aSJbmGub1YZHBaKFpFgD1qQgsK1SEC4v50F0yR/B7g2St9l1Y79lvSt+ZTdpdj3nCpARA6ax6woOYexv1e4HQUy/J87QN2FmhuVRvW25OQheokxB3Hq7/uOu45h/5SnCiCT5puGQwZwcLeTQJM+FEZoghFm6z/Wc7FOkEcN9+iDCXANNWDWCjMTEPRQDz5WmH+15yaAuplJQgS6sR/TaZbRVHuZ1M+dezA9yccqEHHNIgKT1jI6UcQ8ZssJHqkCYFR+/A+6biyqSsYQM2tJFIJg3uW22NjgBSTAIucHg0jfeR87dtGF9ROgjahlESOp1MSVyw87ujC7HZB8MS/AtrB1J/IwEcMcUbOnfQCjESQhd0qWSNPKNxcs/agBUJ5slzmyJ53V8iERYBM/SrJDKBlxfHf8k4pm0uFwvVsL1cyvYCqqBC4lc1RvaCQsYH5t8/mcdhW82qOIzZUNc7CTAnhL4k7bnP6qpmFp+F7fG2OIqRcnd5ZMLxcxigN71fS
 Q5WFQkL2
 +NT7LyY9siANGrGZ6fCvVVp95EeAdVy+HA3LnSMUFgGlexAMCnV23dNYSV1KMJjz+n6YoTnT5G43u+8/iJfohGVoV+IY2/XKsLXVh/C3dPiAXhPq+VSmiOlh1vaWmw8+Li/DH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

Den 2025-08-19 kl. 18:22, skrev Thomas Hellström:
> Hi, Maarten,
> 
> On Tue, 2025-08-19 at 13:49 +0200, Maarten Lankhorst wrote:
>> Add an option to pin memory through the science of cgroup accounting.
>> A bo will be pinned for its entire lifetime, and this allows buffers
>> that are pinned for dma-buf export without requiring the pinning to
>> be
>> done at the dma-buf layer for all devices.
>>
>> For now only implement VRAM pinning. Dave Airlie has a series to
>> implement
>> memcg accounting for the GPU but that is not ready yet.
> 
> Previous discussions around this have favoured a UAPI where we pin a
> gpu-vm range, with a pin at mapping time, or dma-buf pin time where
> required, this allows for dynamic pinning and unpinning, and would
> avoid having separate pinning interfaces for bos and userptr.
> 
> In particular if we don't know at bo creation time which buffer objects
> will be exported with a method requiring pinning, how would UMD deduce
> what buffer objects to pin?
> 
> Thanks,
> Thomas
> For discussion purposes, it seems compute preferred pinning at allocation time,
so I wanted to propose that solution since it's easiest to implement.

I will change it for the next version, but I'm very interested in feedback
on the adjustments I made in cgroups. Those are the ones that will have the
most impact, and changes how effective min/low is calculated when memory
pinned is involved.

Kind regards,
~Maarten

