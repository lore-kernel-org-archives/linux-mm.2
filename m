Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2BFC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 10:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C3E6B01A3; Thu, 24 Jul 2025 06:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC746B01A5; Thu, 24 Jul 2025 06:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2F46B025F; Thu, 24 Jul 2025 06:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F31B66B01A3
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:54:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A71DAC0349
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:54:30 +0000 (UTC)
X-FDA: 83698849500.10.BF74DBF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 40919120002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:54:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yTWcuJZ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A6Q+Ll3r;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yTWcuJZ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A6Q+Ll3r;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753354468; a=rsa-sha256;
	cv=none;
	b=wy6XUH+EkruQkZgkfy3ofEKR0B+5eHbfv2r+hrJggRTpOnK8gyAKScWJva5von9wtLiTI4
	4Vxlhem+YrzRHA+Q23oZ0ZbjrIf7FLUT4OHvDdwARJ5ThMx/1SmjZZ9h0d5HyU0Qpbh7/d
	XpUfX4uQpr/bwXyoeb1oylDYooyhhbk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yTWcuJZ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A6Q+Ll3r;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yTWcuJZ1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A6Q+Ll3r;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753354468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MnTbb83fMEQqePlK+8z7J40I1jbxEB517acwflv6VHs=;
	b=mld1prbDvYaMO9zUTiTy1nDoGqONJc3/N/QLgjJoxf4bgEJov+KcHrggoTat4OEsVcSCLp
	pOYFUUOWaNELbIivAjF7nSzl8wVoaRAOmYmjncBJmWjcei9tHG857IQMGxmo+3GEqrhqHY
	YHQThjdcZsFGc1iAV7b+6eM2o9oNH3U=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C98E51F770;
	Thu, 24 Jul 2025 10:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753354466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MnTbb83fMEQqePlK+8z7J40I1jbxEB517acwflv6VHs=;
	b=yTWcuJZ1Liz6+HI7hdohJZmVzuYMnOU+BNueP3Ay+K+gopXRiPW8stID6x+1hTGYDtqt/z
	l94bdOnD25KSe6FSkrqYceTZcdOuMMtbu/Rte9MyGL46DcdawvmyHs0C61glgFOMgkuAPU
	FkGOH+R2O2BSHEiPlb1mhX//wm0s8T4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753354466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MnTbb83fMEQqePlK+8z7J40I1jbxEB517acwflv6VHs=;
	b=A6Q+Ll3rRKvQ20Qot9B2rLxjhuBMp7Es+T8ENhFR7gQOoUCkXbpOf/4zXdAx/k8CKAAkAj
	FmAMiOw/Bsq4F8Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753354466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MnTbb83fMEQqePlK+8z7J40I1jbxEB517acwflv6VHs=;
	b=yTWcuJZ1Liz6+HI7hdohJZmVzuYMnOU+BNueP3Ay+K+gopXRiPW8stID6x+1hTGYDtqt/z
	l94bdOnD25KSe6FSkrqYceTZcdOuMMtbu/Rte9MyGL46DcdawvmyHs0C61glgFOMgkuAPU
	FkGOH+R2O2BSHEiPlb1mhX//wm0s8T4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753354466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MnTbb83fMEQqePlK+8z7J40I1jbxEB517acwflv6VHs=;
	b=A6Q+Ll3rRKvQ20Qot9B2rLxjhuBMp7Es+T8ENhFR7gQOoUCkXbpOf/4zXdAx/k8CKAAkAj
	FmAMiOw/Bsq4F8Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AEDFE136DC;
	Thu, 24 Jul 2025 10:54:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nj0UKuIQgmh2bgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 24 Jul 2025 10:54:26 +0000
Message-ID: <c5be8d13-59ea-43e9-9b89-69dbfafd4a9c@suse.cz>
Date: Thu, 24 Jul 2025 12:54:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/gup: remove (VM_)BUG_ONs
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: John Hubbard <jhubbard@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Peter Xu <peterx@redhat.com>
References: <1a7513cf-4a0a-4e58-b20d-31c1370b760f@lucifer.local>
 <e898e52e-a223-4567-9514-b4a021b5d460@nvidia.com>
 <72bb36f2-65b6-4785-af9d-5b1f8126fc78@lucifer.local>
 <2f866f12-2aa0-4456-b215-08ddc9b13b1e@redhat.com>
 <3dfbbd63-697d-42aa-8906-539d74df9123@nvidia.com>
 <44af8f5a-2d94-498b-a3e0-31f5dde74538@redhat.com>
 <20250606184212.GB63308@ziepe.ca>
 <f2d8febc-cf95-44dc-9f01-b28151fe1282@lucifer.local>
 <e5e88da7-d7c5-4a10-9318-76c1e38dd0a6@lucifer.local>
 <20250607134214.GA158671@ziepe.ca>
 <04f52d21-baeb-4286-99eb-99edead514b8@lucifer.local>
 <8ce6c104-d2fb-4fed-a108-224a6113c227@nvidia.com>
 <b387a3c6-1bf9-434f-a255-6e92269e6ba5@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <b387a3c6-1bf9-434f-a255-6e92269e6ba5@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 40919120002
X-Stat-Signature: jb673s9y4x9muiaie7ut9jesr1utos7p
X-HE-Tag: 1753354468-72604
X-HE-Meta: U2FsdGVkX18B6cr5R4AvcJA0rFvPKcqyNTrcSqeQJWK50uZuEhepTQMKrLUOnfYWO9MOui4FwI3SJ6eujsndMghPRE7MFRyXXvIREGNF13qBlBJrPZP0XG8DL3+klhJwg+YSs5wxejwzG8wRF5WrLOt7CtSdcBgAxW7oYyXKoKMyoiszD/qzTMqEzDl+OP22gmT3BsLa85LxBXZvzXiwdVgw+qXfAijUWVPCAd7303ce0r+k2iS0uWHcfoiMClYXVg7AgJJ+b9RflSXFkfWBuH1EgtALLSy5c20Bx6S+6HYumgK0dwT9IVARMNMVjvtrjvyxT+YAmqMR610KPBGH5IIRc9hyyR1ZRcWwGUYuIiMvIseW1d4jDeqgEgssx8ZBNvY+9zPkjGG6qgaTIEQU8LwLlfnNIaVkXI8QqpdmWKaZ32RSyQqsySqw12PjxUFTp6bOC9WtKc7NFXSMgNa5z7sWg0MMC3i4Mp+iH086fNg+MtzTdJggqGBK4YeALU2oX8q0FqqwhzZkUj/0JpnZ1ee6VVrQFgHbVoWXr2V9YCuFW0+9G99+PxSMIoBt4LimjsocM7LF45wP+VAAUAVgqDTQJk7MRckWfEJjbgJRLKPJE57e2i1yhNamRoqfx2iIQ/JyZ2qV0+7g/g6AixIu6dgsjF5qfmr27oOGOoiWmKCTF8vpqPpV44nL5q2lEkU8o9VlKRPiYl2Eianezfchay6VcKyPhJazkH3RL2+Pj7FnWyLRM6HV5IDSW0HaaxHrpbpO4ecURxaLyDnmvzkrTGcft/KOXh6RczWa9eWCrH4oA9X5bt72qDtpagpXklKAazWCAO3JLuuwASNa5lKu860B2cmQ77U5OwI1I5vGcK0Z9QlcF1OeUkOO9IrOrWGU5hE3lRv0zF5N9KwO01cEAyKi85NEC/J4pznq5FioVWnTQF3FAACQq2oglpGzNYwXz/pzudxqKwnG6JUcaZL
 ZhBHjV+0
 Xn3RhqUHi7X29/Qs0YGVH4rL7ksfJtYaN/lD7xVRvfBFX1eYXWiZtLwqOEMwy2CI4RJO8xrwhaAEz+KELvXWGLHqYR+kDW7BwXNRuzdriR0lNqpjlfcTKFq/4TwDiUu9mHwGyGKiQPwcBRf5jdxNY8gdqgJFhh5dsEKXfmhrfk+4XIxXffYPfwd12Ne870TGeGaS+4MBLUS/u4EOHGROixZFCKiCkv+i97QXfa4PYENFbgDpRZLg/w2xxX/PEmcIZGSumy1TPqMxgIvdRXN1y+6qAE/A3wbrJvzqJ8iUaDPxNl+JMuuBArDsagXIkV1PPVv2kPLTyIDUbx+M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/25 11:57, Vlastimil Babka wrote:
> On 6/7/25 8:00 PM, John Hubbard wrote:
>> On 6/7/25 6:53 AM, Lorenzo Stoakes wrote:
>> The worst part is that if you go to reproduce a problem, you don't
>> see the next warning in the logs!! This is devastating, especially if
>> the site makes it hard to ask for a system reboot. (If you have
>> ~20,000 nodes in the cluster, a reboot is not a small affair.)
> 
> Assuming you know how to reproduce the problem... I wonder if it would
> help if there was a way (sysctl?) to re-arm all the _ONCE warnings. It
> shouldn't be that hard hopefully?

Oh hey it already exists, since 2017

echo 1 > /sys/kernel/debug/clear_warn_once

