Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3316ECD6E74
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 14:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 783ED8E0007; Thu, 13 Nov 2025 09:48:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C128E0005; Thu, 13 Nov 2025 09:48:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699598E0007; Thu, 13 Nov 2025 09:48:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 591E58E0005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:48:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02EC5140A30
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:48:15 +0000 (UTC)
X-FDA: 84105864192.14.3586EFE
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf02.hostedemail.com (Postfix) with ESMTP id EA2DA8000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:48:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763045294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+yu80aoBjpgyBfkACdMGKdLtOv3coC/l3MU9V1i7jMw=;
	b=eiizvt4pL4cZUJmW70AK7Rxx6JgX2yUTTzr7SbQE7VA1pU7GkHw+kCeKYNXp5D1a2yls+s
	Ed92+XQfUNN6OSoMkSc8TNyKbA6U5wLJy7kPa37dugyW0epkoJUj/3hqGb81A0DKOslhlo
	2TMWePyvI3vec0HelAnuSvzphfHVyBY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763045294; a=rsa-sha256;
	cv=none;
	b=oexhaz7VmKE7fVt/f06wOch3t35niN6JcsTpQwPbXBZmRZNxyvf2GxbiXuClQxpTvGriuL
	0DzCbtf6M+CYYZvdJlIVfME5NdtO9XbZB+DGwt92ViqN5g4Y2kV5EEZ/u8L4k7HdKEYUTA
	TwX2mF6R9Ue/ClAdYoaON/Y3FSzaj68=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8A319227A88; Thu, 13 Nov 2025 15:48:07 +0100 (CET)
Date: Thu, 13 Nov 2025 15:48:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Oliver Sang <oliver.sang@intel.com>, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	oe-lkp@lists.linux.dev, lkp@intel.com, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: poison_element vs highmem, was Re: [linux-next:master] [block]
 ec7f31b2a2: BUG:unable_to_handle_page_fault_for_address
Message-ID: <20251113144807.GA31071@lst.de>
References: <202511111411.9ebfa1ba-lkp@intel.com> <20251111074828.GA6596@lst.de> <a90b1707-b97a-454c-bced-a25068b28325@suse.cz> <aRWMT6DTNhAdudn+@xsang-OptiPlex-9020> <e88f9909-cb5e-4205-b4cb-461fdd71120a@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e88f9909-cb5e-4205-b4cb-461fdd71120a@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EA2DA8000B
X-Stat-Signature: nowouzyzpe54q91zfztx7dija94hf73j
X-Rspam-User: 
X-HE-Tag: 1763045293-640405
X-HE-Meta: U2FsdGVkX187UrgtTXNvS7UDnzWuTV6//re78xErd+zf/Mp5mExirM9/pLBjhDMvLT24wfiWN7fRuB4CBoKXoatX/tyuakz/+VyQoYomGwvJEYSplBO3JHOfJiChwkIDJLE1ZBSiyEcdElI3GV4YLE30YT+Fo3jAT0eTq695b+EwtL/seCrciL9JnrnZW7xBjvLd+2MwRfgwHgr8Fd7olMOQn9m6Yt0wBR4lOmHF5djIwELEezI66JQ+mhxHyLR47gmXduZ1UBbh+mdmTM8fcJdpdACr1F2oBB9cDMiV7PJApeRsTw5nn8rpw2NxdSAGSRSoZ6JDAs4zZsEKsQsjQWx965egAz4n5EO6jpQoZYZr+97CLh46wRr+aGpkPGvpMWeLa0IE46EHHRqJiiwgQIdDNnFQcJoX6CitLSetOCuMb0BrktcmW7daIuNGx3PCgV6yXvVNHNXhHng3I1B+rLEmw2VeukEy9sU544Fs910hRKDiVj106Paay5Knh/Cmw9VxZIqDp8PMZNsFGkExUbCV/F8HPhKNJea5o+rPxJLKEpDTswj9+Cg5yyvX8I3MW/YvCJBnr06MyLzCjinz3DCwb/0dO58NzRNQvjPn8BtOuVTYwDYnxDYqc9iXbHUvAxmPLOsvt7hWjZLN6W4OgK1peQy/YM8R4HWlF8WYnEfOKUnGhzMdzlXKvX6290NiryrPUch5tzZX7LrHH0rRi3HZD3Yff/kDxiqkyJW3BQcamea+JY0et2G4zPiatS9sAIIi0q0VCU3Aqy1u10OkL8sr6v69326rV5bqcbjHjvQEZ0005coNVli3IsDMQhTO5wPLA9tSkaWAGrGcHpfbgow78zrjVOWuSYuVejwVkYcfFxL2/ojZi/cxQH5eEaCtaUbA0zp79aE5NTVFLIAGbqZjudE3wwx8bYhqhLAIWEfIbw+E+/VCpiOuBakYVT3xmMc/4u3V1zGPo9VaPle
 5OhXTLN/
 9FlJLgdw4sGzwjC6X0RKOQiN73i8QxT3ShsEpMglcKpoHNNTtT73dDyyNtxziMAS5xLkCXhm+YYKfzaENGsvP4xzqwVpaKBw3pkanDIW/i3ZyvaoRtP6mQYkNYmHrpdnVpVgW0ANvC/FEtJ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 02:48:06PM +0100, Vlastimil Babka wrote:
> I'll make this a full patch then. How urgent is it, Christoph? I suppose
> this is related to the bulk mempool changes, and we discussed the users will
> target 6.20 (7.0?) merge window? So landing this fix in 6.19 is enough?

The trigger is a change in the block tree that is in linux-next.  So 6.19
should be fine, although getting it into linux-next ASAP would be great.


