Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D9FFCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B538E002F; Mon,  1 Sep 2025 05:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70BF38E0016; Mon,  1 Sep 2025 05:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3E18E002F; Mon,  1 Sep 2025 05:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 474388E0016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:32:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15D2E160749
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:32:38 +0000 (UTC)
X-FDA: 83840166396.30.A7E7654
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id A9BBF10000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:32:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tG0qZUBr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+omu4DM0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tG0qZUBr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+omu4DM0;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756719156; a=rsa-sha256;
	cv=none;
	b=sgT86oxIAgdY7tTVOY1rNCnWi/tmvG1fxVi3ZozvQ/PxS0YR8ubEYmDGIur8C1Mvv4Y93L
	rFSNtgWusgRIhqJQh2mnXS/K8wFa0t+Ur/CRaz4g3Cv9L8EUWPvnddfSh1HYH9hJvFHO8Z
	M9D0vW0uZoJ2ufJCprgNtzn/ijWfALE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tG0qZUBr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+omu4DM0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tG0qZUBr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+omu4DM0;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756719156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/lcAibKVHoe/SFW6wzymEv+7fqREhXPbeps/a+UggU=;
	b=CeIyR9sZqQoi7jwmkPxlyYtLBDntN5CV7wHmtr+P6kcSrgieBtNR4KzTpjlOBb9HRFho0h
	z8nxkoDar/19aaWgijcdzzQmbH1aIhRrv0j3NjAV1fl1exUVkfCBrIq/VDyy2BMQESmx/+
	8FmH1r8Ci9gkEu3pqe12CH0hnZqZ9/w=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 24CAC1F387;
	Mon,  1 Sep 2025 09:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756719154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g/lcAibKVHoe/SFW6wzymEv+7fqREhXPbeps/a+UggU=;
	b=tG0qZUBrPhsyHoo+2TIDDhcbS0ANsOegVRZnFcUAXuJI7xqKzZQ0vHO4lwwzJWohgJPyJO
	0FtfcQGlCKTSdEai5zY0InBtU/ouLt8pINxx2/1l7Ko+lavCUawIpA/pb5Kz8Oedp6Lauz
	jCTJv8PICO38mKfFVWSndFeFihnqhC8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756719154;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g/lcAibKVHoe/SFW6wzymEv+7fqREhXPbeps/a+UggU=;
	b=+omu4DM0soeEGog3QmUYjVlrtJrtIz4ik7V5ELraprWzBDHtW4Px5GIjCPYZS2YreTPIlN
	PbBXEpEVOzpoySBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756719154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g/lcAibKVHoe/SFW6wzymEv+7fqREhXPbeps/a+UggU=;
	b=tG0qZUBrPhsyHoo+2TIDDhcbS0ANsOegVRZnFcUAXuJI7xqKzZQ0vHO4lwwzJWohgJPyJO
	0FtfcQGlCKTSdEai5zY0InBtU/ouLt8pINxx2/1l7Ko+lavCUawIpA/pb5Kz8Oedp6Lauz
	jCTJv8PICO38mKfFVWSndFeFihnqhC8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756719154;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g/lcAibKVHoe/SFW6wzymEv+7fqREhXPbeps/a+UggU=;
	b=+omu4DM0soeEGog3QmUYjVlrtJrtIz4ik7V5ELraprWzBDHtW4Px5GIjCPYZS2YreTPIlN
	PbBXEpEVOzpoySBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB6FE13A31;
	Mon,  1 Sep 2025 09:32:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AlmnLzFotWgKcAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 09:32:33 +0000
Message-ID: <adb9e55e-0023-44b7-bc88-ed95be8dc71c@suse.cz>
Date: Mon, 1 Sep 2025 11:32:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer
 parameters
Content-Language: en-US
To: Max Kellermann <max.kellermann@ionos.com>,
 David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com>
 <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
 <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com>
 <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
 <244b73d5-39dc-4bcc-a69c-8ae3010b40d9@redhat.com>
 <CAKPOu+_wQ9DDHOQDtFeXU7ZqwvwxYqXNqWeSP3zJpfC0Cm2YAA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAKPOu+_wQ9DDHOQDtFeXU7ZqwvwxYqXNqWeSP3zJpfC0Cm2YAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A9BBF10000F
X-Stat-Signature: mc433oh8arbfeseah5nwdziqsybctrh8
X-Rspam-User: 
X-HE-Tag: 1756719155-828537
X-HE-Meta: U2FsdGVkX186eRJZKj7AmxFfiFQ91A4B+lvO+bLcU30slU8EzsOtvwyDdoGaN0DTtBbu9fKeGSzeOYLdmO3IlHqQqrlf8Uc8hk1YUGSoBwcmFFjBLOZJb1YKYGeib8EhrUbosoo6Jh4m9/YeoSjSaoxQpUUXDG5rml0vvi2qkDqkFXtTRCQVgg1pgwro2el47vvTAJqPUxYS6M4+zofLh8uBrC7N7C2vmydPm5nAotwiWV7qi+LhmKL8J7jyhZ1cAT2Ch0SBYmwHL9IrQzRqvpbd8XA/vB7szH7F6pocAwNV79sYQ31lYYFuFtRWUsfF6iEIJHBXt+Ca89lyn8oiL+Mw2A3PKhQeFkUksWQk3nBvf2QJpCLRXAU3NYD0eUzAOkB0KVyugx9Z6PD2p1mm20urB40mDIujQwatdARde0sZclgiPNV8eOKsmeN9DE7JAdqA6ubW1xA09WCNry2h+CbJe6FmOueRzikh/2lvUzVbYeHzMYzOKU0frW0Qa6eS20ApznmZzDublI2tX7P+L91YC5MO3wfYBw8HLJDj2sdaFNLoW1bWMo6M3kutPQlB86o3736QoByb6zp56L34O5A4eTU1D2sSGgrtBmJ0VwGTzx+a6OLc+rvaoh1123YaAl/esv5NfP9qPioXixdWvIm2hfW1F9vtpXN5VGb+CyGjou05wENnJk7oYuvtzYhcAmqPeGEDI1ID8kJQFPK9Lc7KyeBSjoiI804v4licRYKULaCs75H7TstNXUv0nC8/bMsPO4C1rNocTOKAyUNSM0wSCJNPZ6+6HWXJfN9gqrZecuzT5HtMEzA/ir7ZcC+eIy6KACy9tnw8kzHtWnghPezap2YWebljXVR4PJGgBZqA/o3Szg1S6B+Yb7/QdDG5HSI3TNT5wNQG3Q7Eib89OFzlShNNezIdZYNB/ko4bxLAXpyoKHEq3PT1OxkWEBAzOZ7BBs31GJfMC33u3pQ
 ZTHqZkGl
 2PeXzg2cOfsFtn013vwq6VfIsmbi5koEaVKRF4GD5eCR4aQON2WSq4DOzDoClJ/UXQbhvNs4jEalavTik/t9lXO1S5+8i55zRu/xYGpJ29Gkh5bUOMuSyVcrNhL5e9eBo2+qf72hIXyY9h7i9pcx18xIr093DOcrMw5DejsxxpDpgJoexgSeU9Sk3Ft6WOaLLaHVrk7DDBGAgyQDaViSDu8yckMxfSQCRd8ETlDrsDz/MIflVa+qmvS4SxVn8ONlp9LgDvn9aJfNqwaHHLiop6I+meN1Q3S4tV8WKqNJz5lqu0sI4wKl3tQ3uk6XDCjiQ5qhzYEwXRlw4Hyan2mH5/x0RdtOCpcST6Mf2w86Y/PkAyAw+b1WF+ivwV9f+yG0E7AybjOa6cFFyvRcUxw4SaQa1/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/25 11:26, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 10:35 AM David Hildenbrand <david@redhat.com> wrote:
>> We usually write complete sentences, and there is nothing wrong with
>> repeating what the subject says.
>>
>> All the time it takes you to argue here would be better used improving
>> your patch descriptions.
> 
> Sure, but first I need to know what is really needed. Reviews on LKML
> are often contradictory, and it's easy to get pushed around from one
> corner to the next.
> 
> I just posted v4 with longer commit messages. I think that's a lot of
> unnecessary noise that takes a lot of time to read, but oh well, if
> that's what you guys really want...

No I don't think we want a passive-aggressive malicious compliance.
> (In the days of LLMs, writing is almost free, but reading all that
> redundant or generated garbage text becomes impossible. I think it is
> harmful to have so much redundant text because time spent reading it
> is time wasted. But that's just my opinion.)


