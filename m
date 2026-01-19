Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10E0AD2ECEC
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 22:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CB006B02FD; Mon, 19 Jan 2026 17:25:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777FE6B02FE; Mon, 19 Jan 2026 17:25:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67AD46B02FF; Mon, 19 Jan 2026 17:25:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 541E86B02FD
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 17:25:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13E8357F00
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:25:21 +0000 (UTC)
X-FDA: 84350145642.05.4BF65DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5194B120006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:25:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmGzBhmm;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768861519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qS23eudvVzt1ADpbBF5gUBwHId5bYBqcp3NoGL7nts=;
	b=rlVO7P710k6/cGW1yk+lmvkZrbM2MZoJnFg5uS53Ede6tB2OjbEpQlJU/U7hrhLts4Ai+P
	z6BsEcvmZ4ISaNCWZQQFh4NLEAITnxHc9Gki5rVaCP3YxZuflyF4khnaMh4dmcw9VoJjLR
	0q3lhT1PcNreEa3gI8qak1g/K20uYjM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmGzBhmm;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768861519; a=rsa-sha256;
	cv=none;
	b=IGOxtUsXxCdrN/HlVrrjKwfT7Sw1OHcgNddfpk8Ul7RXszJ6ahl8TU8FPd1NVwwziqfp3r
	/3Na+BXIefDQINptDFzaz88y3KfFK5rxoEacAfdLv5uqD6NZ7xDqTzIGNTMPam8E64r/LU
	PVMeggGxTK5K6Lr5jWlWU/2fkI4Zv20=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 662B8600CB;
	Mon, 19 Jan 2026 22:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107A2C116C6;
	Mon, 19 Jan 2026 22:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768861518;
	bh=FAhDAb0u3mhKiWuTRu6Dbpf4eWwLQGrJyZKWWKJe3go=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=WmGzBhmmvAQt5l5PbvA8zaQPDgIuoNJskhe2N4F8kWZBPAyFdiTaUh/0OAgssMGd2
	 wmR9MvAzNiAjh0x3J/R2+upFQVVUoOV7ZvNeRcDxof0gAxpDlGIU3XZhrWxn+d/rXR
	 VSsdH/bnurWZxA7coDt74Hi4pzAMr1cK42OTzJq3HDfk2DF8vlS81Gq3/Pi3QNBgHY
	 71HZGZJlIPV0hfC/5Y0hpCXejNXp82PxIRri2qQvnH84xKv+ovHC48pyIa7PUaN2V6
	 kLD7UHibuKDHv2Y5KmPkLd3dt6r4MamPb71DAKpl4k2EJN4VhbZHHfRJTm8doogByw
	 BcwE41Ikj3k9A==
Message-ID: <7cbea892-0ccd-4132-af55-d72abd704d6c@kernel.org>
Date: Mon, 19 Jan 2026 23:25:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/23] mm/balloon_compaction: centralize basic page
 migration handling
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-5-david@kernel.org>
 <ca9e4ebb-e6b5-475b-8a21-a261e27c3ca7@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <ca9e4ebb-e6b5-475b-8a21-a261e27c3ca7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5194B120006
X-Stat-Signature: i9qxeriro1tj3amkc8bmydqmpco9cwmg
X-HE-Tag: 1768861519-351218
X-HE-Meta: U2FsdGVkX1/NMR7sKdBAHuOkOIqhaN6CyLmuM/So3l7SE/Wp2iI3htdZytSbk+fFAXFn+Ar4XkHoZ+LthYwnlIV2YNu8GOmyKnARMj+7hpbG1t3zDQ7zMkxrLcaCYgMuzNmbqmP2h5cd8v0QqMnhLmMe3S2oUOMFP6kI7QJjoYcj9KCAuA6qrlGAXR2eOO3SGTXeIeUsemmD7Egt8D9b3IiiF7QXv+oW4ZBeUjc9mp5WfVFFFs93VKS2O6gOl3vQEG8Lpb+UFUM/2Fz64yz4E6NdfM4HVy6ZsAPuxA8L+9LgjKyV5itAE2JTl/dmEv7dc1BQ7kDgEE1aVUkfrCNW5BTxdK5/RoHqpGUyRTtXLNZte5BOGeKVP0kPsGgh0108+mgozclT71jnAVc3MJ/VRUgc+BpYus/sJu/GRNE4C5Z+gP2guj1jLuOpE9ayfkHW5P54UCoHz3HpTLJFaZ0kJR7tAdrU/qE5qfTapi7o5SDVWAE8tKGhGaM4Gin/2/E7ZwV2Q7HMaZuLx6Hcy5LMKQxCzvzpGAQqYTskbjVEOZGMm+gxVU8eCYChEV0UpMPls05I5XPl/SmNatGI5knHnMvtOxxVUicdssm5XNurx6RzdKEH4LDul4Jd6YVVBrhv2NHGh+uEORKoCoxnmPQxLmYtR3o4/V5JO6X2ZxBIe2u0IAuhLJGgpkO0IqTIgqxISBvVRFbq26wuBLcwrYRCBb26qi/bk01U+HgyvW3lzNa3vuZpnGyRcaWW09wmFbp0sed3R3K2o9RllNkAL2WTX/jWJP+uFKKMBg25kFjwoYec9MFJoXjNojpoJrx3yCfV+rWf/IFTQ2RoTSPndsQ68hk3m43o6gMaTM5sUR1gy5jEX9ybgXDCj9mluxgjL8ijeNRYTTZfBX18Y8B2iyBOIbGHnRIDyiDdwgsDoWPc3RxjzOJcHBNMIU5BlyqBM5hkX4XBI0CGysNsLmTmp1Z
 rGrfq7l1
 c7nfNMUQZ1FBq3y5dAZmWK2uyVCCbj+9QgWNc2zOKmtsx7opZjVPnGZiUIeyhl1kCgxFZLvkNWL+EOejl5y6P39rvl7FvJ1rxGxy+EPVXas+xgMhPh0kAVdXQuLmY+1O+1IfMLy1xcetwstixOIzFzHRHh403EpDY/5k3aGwMoA5BrEzk2pOKyVOMZvDYx8zaYx4s7y6UHhi7a13/bHQMvh5CnaVU0dh0XYQsq6ylI/CwfDD2LrdgBh2V26oCVcAzzJ7WMeg2LUq/ZOvveAt04dHgL81iEj4yra/zyjKtfWLtu19nJnRHwYq4A8EA2ELH7qMYchTEUyT+vps=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 23:22, David Hildenbrand (Red Hat) wrote:
> On 1/15/26 10:19, David Hildenbrand (Red Hat) wrote:
>> Let's update the balloon page references, the balloon page list, the
>> BALLOON_MIGRATE counter and the isolated-pages counter in
>> balloon_page_migrate(), after letting the balloon->migratepage()
>> callback deal with the actual inflation+deflation.
>>
>> Note that we now perform the balloon list modifications outside of any
>> implementation-specific locks: which is fine, there is nothing special
>> about these page actions that the lock would be protecting.
>>
>> The old page is already no longer in the list (isolated) and the new page
>> is not yet in the list.
>>
>> Let's use -ENOENT to communicate the special "inflation of new page
>> failed after already deflating the old page" to balloon_page_migrate() so
>> it can handle it accordingly.
>>
>> While at it, rename balloon->b_dev_info to make it match the other
>> functions. Also, drop the comment above balloon_page_migrate(), which
>> seems unnecessary.
>>
>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> ---
> 
> Andrew, the following on top:

Ah no, I'll rather resend the whole thing, as it creates some conflicts 
in the other patches.

-- 
Cheers

David

