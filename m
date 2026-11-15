Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4A1606A332
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=lWT6b5dW;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Ryh0U1mL;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=lWT6b5dW;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Ryh0U1mL
Received: by kanga.kvack.org (Postfix)
	id 513A76B05B1; Sun, 15 Nov 2026 17:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49D8E6B05B2; Sun, 15 Nov 2026 17:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C836B05B3; Sun, 15 Nov 2026 17:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A87F6B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:00:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65BF11A083F
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:00:22 +0000 (UTC)
X-FDA: 85438722684.10.C4C7C37
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 404F8100002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:00:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lWT6b5dW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ryh0U1mL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lWT6b5dW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ryh0U1mL;
	spf=pass (imf14.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794780020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1RSqXe5NSBqTmAqgI8yQZO9YY1N+JiA5u+pgxFt2XGs=;
	b=pzojTtpIS9JQQjKPFyNa8/PACMXWQCo+xEwXZf9O9hctKVvQHunFfSn8fOjnVQdI8zJ5Lp
	JVsZ2f4z4Ebk0n9nCfQ+th7kCg8P3VoTXvw6WAMAMgU5oHM59KYF96uguws/XSb2DDGHUe
	zBYUjNu/xKyd5u+C4p35mKmSFir+65I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794780020;
	b=P6Aq6DcvuuRFluoCkxwEjGLAnAmUWoS5C9p1XXF5NKNUzvyu3+FOp/TXIbon21DjzlGug8
	DKqfSdBQtyW5z5PIPJoqd6su6m84kuihf3eQLuk4Z9VKd3bZKz9ndakF68XnNkbMa6y1t8
	kJ6+G9J295Zz/YXvDpMh/DLfzzcuat4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lWT6b5dW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ryh0U1mL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lWT6b5dW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ryh0U1mL;
	spf=pass (imf14.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0C5861F45A;
	Sun, 15 Nov 2026 22:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794780019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1RSqXe5NSBqTmAqgI8yQZO9YY1N+JiA5u+pgxFt2XGs=;
	b=lWT6b5dWKL4zHWCtNzWw4QbP9c2lP277H/TJ4gs21j9HdqDLwKhCuTdOPoTvq/W0hKti9N
	qiRESjvlUKws885BTsvURzshHmxXehtvXR2uyjE4ltBfq3YZqLH8r65sMV7sIeXAW7lFpW
	Ax5ukyMJonFfG3Nki741rMlwANhsgC0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794780019;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1RSqXe5NSBqTmAqgI8yQZO9YY1N+JiA5u+pgxFt2XGs=;
	b=Ryh0U1mLig3r/y4YnBhEFlh8FmJ9siMCFCE6mh+qhd9Jfxu5Tzs6a+eMWexV2xzYpJf/b4
	RCEFROmkX4WWK0CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794780019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1RSqXe5NSBqTmAqgI8yQZO9YY1N+JiA5u+pgxFt2XGs=;
	b=lWT6b5dWKL4zHWCtNzWw4QbP9c2lP277H/TJ4gs21j9HdqDLwKhCuTdOPoTvq/W0hKti9N
	qiRESjvlUKws885BTsvURzshHmxXehtvXR2uyjE4ltBfq3YZqLH8r65sMV7sIeXAW7lFpW
	Ax5ukyMJonFfG3Nki741rMlwANhsgC0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794780019;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1RSqXe5NSBqTmAqgI8yQZO9YY1N+JiA5u+pgxFt2XGs=;
	b=Ryh0U1mLig3r/y4YnBhEFlh8FmJ9siMCFCE6mh+qhd9Jfxu5Tzs6a+eMWexV2xzYpJf/b4
	RCEFROmkX4WWK0CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 51406134F4;
	Sun, 15 Nov 2026 22:00:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 65LNBHEr+mrobwAAD6G6ig
	(envelope-from <clopez@suse.de>); Sun, 15 Nov 2026 22:00:17 +0000
Message-ID: <343d0637-d88a-4505-b7d3-37b41c89a9f9@suse.de>
Date: Sun, 15 Nov 2026 23:00:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] mm/huge_memory: honor MM_CP_TRY_CHANGE_WRITABLE in
 change_huge_pud()
To: "David Hildenbrand (Arm)" <david@kernel.org>, kvm@vger.kernel.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-riscv@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com, ljs@kernel.org,
 imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-5-clopez@suse.de>
 <136002e1-646d-4607-be3f-b6a6a869bbec@kernel.org>
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Content-Language: en-US
In-Reply-To: <136002e1-646d-4607-be3f-b6a6a869bbec@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.50
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 91na7iz5bgfhw9p3msne4rg4z5i5jj9e
X-Rspamd-Queue-Id: 404F8100002
X-Rspam-User: 
X-HE-Tag: 1794780020-160664
X-HE-Meta: U2FsdGVkX1/GPsUJ1jxVFP3VsN+snGZBrE9t6BlnG6jcBV6A5uDQf/d0FCrTULccjrTNLYuAzhUj8isYJwwvIx8KuYRaelszaElmXLO6zir5RCA9RX7eKVolV24aTpRa2bIIVQxUSBUZ73Oo5FdfyL8LN47zLAS0XeD04KU1TByLx3WuggEgGDvdCCWG3fCtr46hqyuV3aO1nNfKlQoOgYrnfFO3B+s64gfm8Q9tK2GSvyFxLGpFOOaLmmAq62B/NqhoL2AaMWcvcJLFDSQmY3kK15XAisqPsx/vQ7GY2Kd8N1HoJHqm93MQVQ9c92tK7ErXb669OUbGctuLjcUcH2DUvbNX1b+lIpAp6klpVN0foxelN+vb4zcCK9atkWIMxbWHI3VrkTpLRW7Gmk5S0fQwcxerxH7PRX5dxb2jbalC4/JLFKDh6gcT5hX0kG7mLiEvHJKJNleAG1amQAVXZD+8xhy0FpOpD6pzkn3YvLlZAzI+kyY5SZhm6kGi16awqVFbMoOixQc+s0gQdAe6d21Vn/VGslS0yEhnNm0GQ/1O+NvEtT5bFBJ+vSRqVsS4i5WGKrVNRycX4qLiDtoDbczox8xVPuyoEDdHeV5qqM7ZEKLycRaBABtVYtFRWPwGU+CKMgjVPMgMWGaeidddaWQZaBty9FWyFTEsuD7gIoOnb76FNNiJaRpp5bag7DPpFh8/3eVfrHdol7xhDJrgFHzxE/xWciYU/7F5FYJcggceFVXvISfm+cram63mtJYHpJxnVmg7LJ6RhjYSynWDsU+v5cLtKp7dFQmzTsx0RsWG8LzuN+MkPspkcV8aAnQvRI8gbmsFPwVjpkuBkUCYPxElROImpltdGv/3OPTTGrw02k61YMkGBm3plhDrVL9V0Ihll8fwmQ0w8g0X4LVsWC2vii3vdI6BOEcuZ9fYUll4llZKMUyWz3UcY6hJSsoxz0IhoCOUjO7DD9GS1CO
 QHzFWlEN
 OV9qtJNTygzl0yqENrSjy3fnamE9HaBb5FwhJkGmROtH0KXQoRygslJqLCa3BKysBKL5+H7n8FNrRrtH5c519r81rX0EI5CvkC2EIiBzLDgty20HV57f8oO1d4Sput3fb15TFZChbNcCcuBCryHWaNeEGQ+RO5VqQ2TCn5koZAewyrAzrVYWfUE50eWZc+Ixp98WAYNuQQd4UQ4LfwMraZE16DjzLP7CeBsiMrckIAESRAsHwPczh4bkXPRlrxhxWCPgpej7sq1mH0U8Tw+8OuYsEbQ+fRrNr3N0frzivdHBYr4rgErbszJPGUDW9fJElzDbr8j6qnEVopOg3iQUfautqGFsmfUxDLCQ68ntVLMUIbXMh4CUsbi9GKbs8mTA6fOJx6iUhZnyNpi3BnuDwP3AMTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 7:58 PM, David Hildenbrand (Arm) wrote:
> On 11/12/26 15:20, Carlos López wrote:
>> change_protection() applies vma->vm_page_prot, which lacks the write bit
>> for CoW and write-notified mappings. MM_CP_TRY_CHANGE_WRITABLE makes
>> entries writable again if a write fault would only set the write bit.
>>
>> However, change_huge_pud() ignores the flag. For example, device DAX
>> mappings are write-notified once soft-dirty tracking is armed through
>> /proc/pid/clear_refs, and a protection change then leaves dirty PUDs
>> read-only, so the next write to each of them faults.
>>
>> Fix this by adding can_change_pud_writable(), based on
>> can_change_pmd_writable(). It omits the NUMA and uffd-wp checks, as
>> change_huge_pud() bails out on those changes.
> 
> Again, please keep MM changes to a bare minimum for your work.
> 
> If this is not required for your work, please drop it.

It is required. The new flag is not correct without it, as a protection
change that removes no permission bits still write-protects writable
PUDs. I'll explain this better.

