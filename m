Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A921C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 09:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23F066B008C; Mon, 28 Jul 2025 05:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EFC76B0095; Mon, 28 Jul 2025 05:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105BD6B0096; Mon, 28 Jul 2025 05:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 025A96B008C
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:28:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93121130260
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:28:23 +0000 (UTC)
X-FDA: 83713147686.02.678A850
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 56BD214000C
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:28:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ioWZsHh7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ZVY8ht/t";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ioWZsHh7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ZVY8ht/t";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753694901; a=rsa-sha256;
	cv=none;
	b=4fcv3NweKCUEt9qkwtZsLZ1K/eg9a4Dxt4sVkFWbTha3M93ZMRa/2qFGmL1ElvvQq5vyEk
	nOKdKJJbl6fuupjaW8/VSwAcWJNjdTXeU/PjYrYTSiIcRt1O1sdYO55y5w2jo0tNmAab3D
	7Pqg94UQgLl9ZhUk5dRThrmmmwVB7G4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ioWZsHh7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ZVY8ht/t";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ioWZsHh7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ZVY8ht/t";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753694901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjYo15ietrTmGWvWcwTpqo5y+WyN26WO+iCcHTM/8SI=;
	b=tLymS9So61TM9GWyVp+z7Dgt8AEZBWtkFNmcnHZk5tr4XzODCNb0BUN9/2XkjmH1IYpxJK
	UKH3nzhw8m45B+AI2LYevE8+sVyr42h2qqT4qrAekDysPEx1M4Z50YimnxDeTnw3xmHK7b
	iNt4Y6QAb4Fhmjf3uqlM6kszs2EoNHs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CF2E5211E8;
	Mon, 28 Jul 2025 09:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753694899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kjYo15ietrTmGWvWcwTpqo5y+WyN26WO+iCcHTM/8SI=;
	b=ioWZsHh74FPZy5H5yUw+e8ewR6lhBj2FB5MoHptFtjEHVvUuqNSQDFzVK3anmHh/WC4F+s
	kAA+O9UfzikwL8MNBm6XZUI+a9PXndQpsdpZ499Ld5ppm0eaHJTfg6hUtEU6e/McUOE8iy
	NhJcUnipkTtCGHS1HNOtYubywmTfLGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753694899;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kjYo15ietrTmGWvWcwTpqo5y+WyN26WO+iCcHTM/8SI=;
	b=ZVY8ht/tSiPXpV6h5mOtv0cZNiXg+8NVSh/3fqq9iKzOwOkbcgfm7iui3B3ewFBmd2aRWm
	fJdF34E1+6wx4WBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753694899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kjYo15ietrTmGWvWcwTpqo5y+WyN26WO+iCcHTM/8SI=;
	b=ioWZsHh74FPZy5H5yUw+e8ewR6lhBj2FB5MoHptFtjEHVvUuqNSQDFzVK3anmHh/WC4F+s
	kAA+O9UfzikwL8MNBm6XZUI+a9PXndQpsdpZ499Ld5ppm0eaHJTfg6hUtEU6e/McUOE8iy
	NhJcUnipkTtCGHS1HNOtYubywmTfLGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753694899;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kjYo15ietrTmGWvWcwTpqo5y+WyN26WO+iCcHTM/8SI=;
	b=ZVY8ht/tSiPXpV6h5mOtv0cZNiXg+8NVSh/3fqq9iKzOwOkbcgfm7iui3B3ewFBmd2aRWm
	fJdF34E1+6wx4WBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B3BCC1368A;
	Mon, 28 Jul 2025 09:28:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VthqK7NCh2jBLQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 28 Jul 2025 09:28:19 +0000
Message-ID: <273a3376-c45a-4d41-85b4-9c4f3428f268@suse.de>
Date: Mon, 28 Jul 2025 11:28:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>, Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <4057479d-6ece-49a2-b823-99748e8c9c35@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <4057479d-6ece-49a2-b823-99748e8c9c35@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7b54p8hxcfbkea8doa44gxnhbqz33xfp
X-Rspam-User: 
X-Rspamd-Queue-Id: 56BD214000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1753694901-285221
X-HE-Meta: U2FsdGVkX1/pBwz3krmepn9nmIN/MbzDysiZkxOe/5tGPlBRlmtVaHytCILKy0baj5wvIq6UnOJkWZ9IKoqkvqksDmgcrXWvp3GG99PhKiX8iAYoeuJlTQn0khoqvVLieDiaQT1YANwACVYqlxr50s2kzBApeZNeveD+2fw8QA5vcSW7QHr6JojM7FqS/B3TvvC5UsaMjV6NSy0DPSkwqLZBBDNqTNVHeubRuYbdLxMzBleFyurMedf78syaRzh2YlX40633KeacIeFuboLZWqtMlFszwpW6ynzkEKVuE2Z8Vz+tiu3o4noX1slcky9KJ5EqInYtlk611gjjNkdTqMgWCa5o7SgXse7kEGCEAZq760KznTlJNX4ERZZAWY9+7A3DVodnjlxckzDyr03NRmVu14JJllfbT3Nx7jS0PEuqhvhkjFlr7hIrvfMv00xkOb8xgkx6XHUg+b8TIfE7OoUnmjUXx/MJmJy4ogM2Try5o9UsSOLhA4MwzhRh0Lpb8l4HciyxxdDGV50nlZcapLWxjwXVaac0h+IIRKXVLhtsKTvEXhhl+HanfbwlBrVPexIJrw9Yi2Eux8BaDPzR59DB6VkG23jNJqIe3pQfhvX7Q7I9T2Lmrxk7LUoLXdB5dBCjSYc1cH9ozF2g6RUHQtgKKhA4NWn2yqTN6vYy9DnUXvY5piA6uC13F4mwZZbC2Xl/QcUU9Rj5ozuEVK0o8BholEOxdQyVXb9p9ztZtKVhEVgTnmciygP6tNjoS2YhBGs6RHIMwE4YJPtT03i5YJdB2NSOLGBI3oya5PiNepz+uWZEYyHyr0CuuGPRVhKQOHR0alf2wD9FJ6ULnJqXALum+TtPi5npLoAm9h0TYDrxJZ+A+AHegqt1uKzVuYIhQ2R7taKgraKpDdQT+HcNLVMXyOFizJZtJ3GuWo+/RMPF+xhf+O4Q+Rx2cfKU+c0hGH5zXqC/UWH5izrYyWc
 2Y4B3uAg
 nv9PZtWLV+EjQj2qNfaMgIdCZKv6uB+tkG/jtg2iFN38oR67uaXLy+fxWNfWZxAeNQfLkl/soOCQaIp9GkfKKtxXAOhoOvMAIE7WjtHb0DJ9OBQ5bHtp1x1E+C5dYwVBFWhiFqmSyRZ+1/sAw4hPaQxq+SGd7rHYUMELpS2SvdZFG+mQu6NVWPPGn2wfb+MoS22fFM62zMsQVJb8gmt4cU5/4SQG04OH7UjIGvEbtmO4CIdQHsOZ9Ja7sDGAhO0AjmWN45awuFi0IUwYu0QYQGEWsvji6doXMn5BUr7nxpREua4KSWC7xBi1XeqjF6k86EShMUSnP7801SJGZUKJyZ7TzdyK80FyoqP7BzHKugrPw19BXUz8Vtb+GSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/25 10:44, David Hildenbrand wrote:
> On 28.07.25 10:15, Oscar Salvador wrote:
>> Hi,
[ .. ]
>>
>> One way to tackle this would be update the ratio every time a new CXL
>> card gets inserted, but this seems suboptimal.
>> Another way is that since CXL memory works with selfhosted memmap, we 
>> could relax
>> the check when 'auto-movable' and only look at the ratio if we aren't
>> working with selfhosted memmap.
> 
> The memmap is only a small piece of unmovable data we require late at 
> runtime (a bigger factor is user space page tables actually mapping that 
> memory). The zone ratio we have configured in the kernel dates back to 
> the highmem times, where such ratios were considered safe. Maybe there 
> are better defaults for the ratios today, but it really depends on the 
> workload.
> 
Point is, the ratio is accounted for the _entire_ memory.
Which means that you have to _know_ how much memory you are going to
plug in prior to plugging that in.
So to make that correct one would need to update the ratio prior to
plug in one module, check if that succeeded, update the ratio, plug
in the next module, check that, etc.

Really?

> One could find ways of subtracting the selfhosted part, to account it 
> differently in the kernel, but the memmap is not the only consumer that 
> affects the ratio.
> 
> I mean, the memmap is roughly 1.6%, I don't think that really makes a 
> difference for you, does it? Can you share some real-life examples?
> 
> 
> I have a colleague working on one of my old prototypes (memoryhotplugd) 
> for replacing udev rules.
> 
> The idea there is, to detect that CXL memory is getting hotplugged and 
> keep it offline. Because user space hotplugging that memory (daxctl) 
> will explicitly online it to the proper zone.
> 
> Things like virtio-mem, DIMMs etc can happily use the auto-movable 
> behavior. But the auto-movable behavior doesn't quite make sense if (a) 
> you want everything movable and (b) daxctl already expects to online the 
> memory itself, usually to ZONE_MOVABLE.
> 
> So I think this is mostly a user-space problem to solve.
> 
Hmm.
Yes, and no.

While CXL memory is hotpluggable (it's a PCI device, after all),
it won't be hotplugged on a regular basis.
So the current use-case I'm aware of is that the system will be
configured once, and then it will be expected to come up in the
very same state after reboot.
As such a daemon is a bit of an overkill, as the number of events
it would need to listen to is in the very low single-digit range.

Udev rules would work fine, though (in fact, we already have one ...)
so I'd be happy to keep CXL memory offline after boot / hotplug
and let udev / daxctl handle things.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

