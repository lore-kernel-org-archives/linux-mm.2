Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFC18CA0FFD
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 20:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32D098E0011; Thu, 28 Aug 2025 16:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304E68E0003; Thu, 28 Aug 2025 16:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241308E0011; Thu, 28 Aug 2025 16:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3478E0003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:58:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 955D084C77
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:58:48 +0000 (UTC)
X-FDA: 83827380336.18.6250604
Received: from lankhorst.se (lankhorst.se [141.105.120.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 990351C0010
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:58:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756414727; a=rsa-sha256;
	cv=none;
	b=ficl+s9LezIc0RnmrYAF60oL9MHHg3qBFcYZVTwYbM/2kmBe+JQEp7ZprDsgDKVps+yAK5
	KhKuPAwXbU0P9XmZzt4y86qqSNdLyX+73cCcuNnhFwA3gQeoM0yaAVJfK0q0zi68hZCMFC
	bFw8C8S2pVWbZopfqJmNUw7f3MxpvCg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756414727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JFYJLkp97EF7qrqNX14/wB00q84mIg6ZB7hGvrplA88=;
	b=zeQJKgLnfohHCX4MqHtFM0PvczcMZz/2vnU6adIZYKjLXWNq91A/hNlMaY4C62LeH0KWPE
	5RAs0LXqRAuEwcms3ZTCrM95ouYqv3eCsuEX0EPawpC3g4TWHd+rqfkI/3qGD7yd8v/3Kk
	1aNlXpWQOa+RL8KGfGnN7f1uzTQqXu0=
Message-ID: <a85dd557-9dd8-472d-806c-3606b053cfdb@lankhorst.se>
Date: Thu, 28 Aug 2025 22:58:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] cgroups: Add support for pinned device memory
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
 =?UTF-8?Q?=27Thomas_Hellstr=C3=B6m=27?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Maxime Ripard <mripard@kernel.org>,
 Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "'Liam R . Howlett'" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Michal Hocko <mhocko@suse.com>,
 intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org
References: <20250819114932.597600-5-dev@lankhorst.se>
 <qd3ioegpvmrrrwdy2qntxznyrnwq3bhe74lmuxio7sy4sjggtt@tm6nqds3pyvj>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <qd3ioegpvmrrrwdy2qntxznyrnwq3bhe74lmuxio7sy4sjggtt@tm6nqds3pyvj>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 990351C0010
X-Stat-Signature: nrck66igxuchsio4e5mmg66by7itzrid
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756414726-2014
X-HE-Meta: U2FsdGVkX1+Nvof/vT1ro6RpYJC67LzyOP6Yp4Pt7o7I1qFGnWkvE/Kr8FHBI5l773ML69LxlYnH14W0gJpkF9kdAULEhjgHJNZTAGXFB4+RVufIBcbEvQ+AgZe7PiDSHmWU5OtulP7P8n3cWYDwxh06v/5DWZdaJr8yPvpQgxSY6X32qqyNFuAN0JroBvHuIp407R01iYGzFk9dvgFdsUiFetNNYA6f/skI/UcQ9yNbtbssqbTqtMXr2GloYqpjvmwQ8LrP7wrSUeEgeg5XSa5CdOVe4LQAXMB/l4iNt1TWewZB7jbwc0JCTthnr0dyy8jW1eRXfcVpx0uouIjKwzkF8qPpcfX4ChkXUa6IA5oHfPgAF0tbPXBPGYQpJoFMj4WBOomRJjch9BloyQzWxB+rDRNagvKh3DOgmjTdipnxo9UxKC0wC9EctMfTZfkVvkJa6OLctp2l+0Qn4YLgE/2te3YYUvIMH+4fz339bSVEmHpX2RAR6Tk1flBeZevoh7kpmfY0e8duzSMrU0iPJb1LKNY2c8D6XBEvi68cBdiqEmo42IJ3dxGGXX4iQ2wdcT611hezPjAu5hb+2pGStZ5KMHezV/82Ke0M9FBxXYiw0ZmyRBU+DUtaf3iGrsMqVTICl5UBKHxuCh/oY2mHqFKeaz7VlVRz9rNzFGA9R4O89s1kEKmhsvII0tG1Uzvo9hneItmeXyd+uSkjmTBWxWSuTb6pnhevc3uR4F3ey1/f1ktllCzUbFw9dkL05an3qY6eLuSUfXkDObVoke8UMvZH/ro03SaULCmjoRqLJVqdmHuIeCWyzCk9baqOqIkQNsaQdtmgNEY/47UO0RLv3yml+WgkKyNCBVV5XZbLY78TCVOYT67yjrZQJEAg7RJkVfSBSp73r3kc0DxF3QUOjuK5ybnQs9hVpFk14HXbLPUYyyuI+YLn6t1zJdfnpFjJADHx7BqLpwNrVPK08jY
 u6CnEPEW
 gjwOKbhI45M8ccGTsJIu/mG43xA+nUF6obLF2MvrFsiK/oK01mGM1l7HY+G6Qzpdd6oWv+Stel3xxPCz+vot5rGL4oQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

Den 2025-08-26 kl. 16:20, skrev Michal Koutný:
> Hello Maarten.
> 
> On Tue, Aug 19, 2025 at 01:49:33PM +0200, Maarten Lankhorst <dev@lankhorst.se> wrote:
>> Implementation details:
>>
>> For each cgroup up until the root cgroup, the 'min' limit is checked
>> against currently effectively pinned value. If the value will go above
>> 'min', the pinning attempt is rejected.
> 
> How is pinning different from setting a 'min' limit (from a user
> perspective)?
It's related, in fact you have to set the 'min' limit first.

The 'pinned' allows you to pick /which/ memory falls under the 'min' limit.

>>
>> Pinned memory is handled slightly different and affects calculating
>> effective min/low values. Pinned memory is subtracted from both,
>> and needs to be added afterwards when calculating.
>>
>> This is because increasing the amount of pinned memory, the amount of
>> free min/low memory decreases for all cgroups that are part of the
>> hierarchy.
> 
> What is supposed to happen with pinned memory after cgroup removal?
I think for accounting purposes pinned memory stays pinned,
otherwise the idea of pinning is lost. However when you kill all
processes in the cgroup, that should solve itself eventually.

> I find the page_counter changes little bit complex without understanding
> of the difference between min and pinned. Should this be conceptually
> similar to memory.stat:unevictable? Or rather mlock(2)? So far neither
> of those needed interaction with min/low values (in memcg).
You could in theory implement mlockall using the 'min' values too.

The page counter changes implement the following:

Lets say you have this tree with 'min' values.

      / '5' A
X'6' -- '5' B
      \ '5' C

Effective min without pinned pages:
      / '2' A
X'6' -- '2' B
      \ '2' C

Now 'B' pins 3 pages:

Effective min:
         / '1' A
X'3+3p' -- '1' B (1 + 3 pinned pages makes effective min 4)
         \ '1' C

Same for applies to effective 'low' calculations.

Kind regards,
~Maarten


