Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 197A9D74EDE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 538796B04EA; Fri, 23 Jan 2026 10:05:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510866B04EC; Fri, 23 Jan 2026 10:05:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F12A6B04ED; Fri, 23 Jan 2026 10:05:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB316B04EA
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:05:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C32FC160352
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:05:44 +0000 (UTC)
X-FDA: 84363553008.17.3E6B87C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 46EE88000D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:05:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kxYb/0CD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6dVihU6m;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kxYb/0CD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6dVihU6m;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769180742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlC7HHueZor/U7Npde4G7pF20WIMElU5hL0MI5pxlzs=;
	b=yGlUhRjICQ2BNirZL/A/DuKqmXgakgQMNj6o7JnNQVLqRaaMw/qHRKckMxC6urH3ZLaOLr
	sCW1jqM1vFli1gkRcWC5p8eJOdSondKMlaVBDJTEDlwZnKeD843bj1QlrNVFlXcgDXvDdS
	G68GRTVcaxPeNAAg5TbWqM+NGZd0yAw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769180742; a=rsa-sha256;
	cv=none;
	b=dbyXFSe0AeZTwNOJLJiMNHyu5X5sml3+Bdmyw6l4uv9UtedPn5yQ3bg3Z+MnOqJiMh6vVy
	Q9kflNmVfl5idCuK3eDLu393yaafWS2p6c1dLoYrp3AstHWXsQ1xLNkOmVT1hImm6XIU7K
	1UPR7aTemfX2cRQB9m8p8Hm84UzJmfc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kxYb/0CD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6dVihU6m;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kxYb/0CD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6dVihU6m;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5C7065BCCC;
	Fri, 23 Jan 2026 15:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769180740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mlC7HHueZor/U7Npde4G7pF20WIMElU5hL0MI5pxlzs=;
	b=kxYb/0CDUnhhYXA+pTV95/6fj0GARVz9eVVBJkUCO35L9X7EsgJ8V7KR9sfEv0/HbTt1mk
	o7XWzRW4epqOCNR9eOxAweyhUat6NYnuqx0Bmwr4mxcCnNJsI3ysFTy+nFAqXW9gfod0e1
	CaEFMWASuwmJIythw6zmjqsBOv4aC14=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769180740;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mlC7HHueZor/U7Npde4G7pF20WIMElU5hL0MI5pxlzs=;
	b=6dVihU6mmdkxErDZMZcyhYF8jXXT6pwa38eVosWC2M4UpdPe2bXkDRTNCVcvr45c+EWixB
	otWnnhOUbrswB+CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769180740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mlC7HHueZor/U7Npde4G7pF20WIMElU5hL0MI5pxlzs=;
	b=kxYb/0CDUnhhYXA+pTV95/6fj0GARVz9eVVBJkUCO35L9X7EsgJ8V7KR9sfEv0/HbTt1mk
	o7XWzRW4epqOCNR9eOxAweyhUat6NYnuqx0Bmwr4mxcCnNJsI3ysFTy+nFAqXW9gfod0e1
	CaEFMWASuwmJIythw6zmjqsBOv4aC14=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769180740;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mlC7HHueZor/U7Npde4G7pF20WIMElU5hL0MI5pxlzs=;
	b=6dVihU6mmdkxErDZMZcyhYF8jXXT6pwa38eVosWC2M4UpdPe2bXkDRTNCVcvr45c+EWixB
	otWnnhOUbrswB+CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2DDD1136AA;
	Fri, 23 Jan 2026 15:05:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zBPUCkSOc2nRTQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 15:05:40 +0000
Message-ID: <8d0b797d-6cdd-4ba7-a6f2-313f51500884@suse.cz>
Date: Fri, 23 Jan 2026 16:05:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 03/10] mm/vma: rename is_vma_write_only(),
 separate out shared refcount put
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <c51d6396d78532d85a542da07ba783bc838b852f.1769086312.git.lorenzo.stoakes@oracle.com>
 <6f45d01a-7586-4d8a-8339-fdfbda4c971e@suse.cz>
 <CAJuCfpHhVOC5kzapSPtvUHGy3jMr8DyjPba7tkSv5zOWotvcQw@mail.gmail.com>
 <168cbc6c-5f7b-4324-8d45-d9033613a67e@suse.cz>
 <825b311b-c4ea-4abc-be10-1301d4f5da88@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <825b311b-c4ea-4abc-be10-1301d4f5da88@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 46EE88000D
X-Stat-Signature: pnpkyns1iabmdfreoiiauazougdw4da9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769180742-948646
X-HE-Meta: U2FsdGVkX18zm9DYeEPhaWuwXNcUk9VjEe3vsdTAzBRPeo8hE9TkrzSn15J/G1yNgxat4uqmssr6pVBMftykqeStHso3laL9V03fZu2Qn9cGAOoIN6knwp1DeoOtwLkEuT71+rA3rDpX1Hg3cWCOHaNN/bdSuEt6hNSyYAyQRBbsxhxBtirNHTtAOlQdkRQImQJGf61SQmfEcXbbtzSUIvnYn7JKGUhk3Wk2+RbgwqgSarixJ6zq78XDmb+R59vC7NVjGjuSjaBMNOowa/ZqZs41wNVwzFmbJ9s1K7ZVss+iIy03FyPXZPD5eOY5jTmCHIuNFoh6wt/4HjwxzG4omFaRvqKOWKjlyFcmuItTwgqByNp3+9fjx+WYlY/Nlba09gWQbvzBVncacD0LxYjPnUwJ7TL4t3adEl3YtpKgdCOOunVLIL3AAnE8/q6gkATEvpmDKRGXNtd6SoVuXH2UquWSc9PpsRBfII8t4DH8ddOqNtRFf9CKF6OltCWB/Tbkjn+6meNzzQfAFMKBkIOZz7yVKA4GLcKhQircrA6eR6S0k8eLefZ5TMSA5xdAcSMSbElln7BKurwgnEiXArMaShqGaXDz9EYcFtvwX/yetAav96PRYcqtbogxoCmtPmspEYpr6r2SbEH/T6qAKoYpt/QAQJxanhanhKWm4kBtUVK7hT5Efgpx3avctD3xFUoTj3a5STr9aqMAOvNdxc+T4oFk3NB1tb7kJnHPhkDERF6b4wyraX8W47sEiD8xsspiNDTbLS/4eAB3lU68SY/m7zPkWWic2eJ/Q1hlePcVaOvHmBZCzsAjJ4sPW/TRpvEY4cl6aUknt/TIpPME3ad7oC3GxAok27v1EuPXCOer3j5gdcJQvdYwiyw5UTUTpm6C128+QshCUQZs03c5hYPCaoSFENux0IW6x2njIULJYN3Bydgk3+WMuMeDJsldQPcdQ6e/rdWd3yiImQN1cIS
 t0llD3N+
 XWXeOR91BXy2+s7F619y4rpnVNYSMNMWOI7I2MrzOhI38JNtECQ1WzDTqJM6MZpDgto0EoxojKdX7IfqOW6da7lLpA+UugSyVgkOh+vJ5vwbi81nVUk5LKUh4LbFsk/Fom09pvICw9mXevDJcYrNg5rcn7mgWhP6NBhk0DrDe86YetvNGjMPWaRtsQjnrnd2Wp7bsqm2uMJpeOsUxh4uuzDvGOfXq1rNr352T8uk6yc9M94Rm/UnAAYuBQYU29BDniYCMWIJDeIwmqb3J6HRMleHJefNAI+TwoRmFtEvDIrTUv+6Y+dd6IjGKlowYU2lg6SCERq0yiQ9oxh/22ysDeqLMkFNYjCMfbOfKlZJheMtVV5XBnLMUDwlhEGITLFxvp/l4TeF5jTAN7d5OVtfzCZq2JA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/23/26 15:52, Lorenzo Stoakes wrote:
> On Fri, Jan 23, 2026 at 09:24:54AM +0100, Vlastimil Babka wrote:
> 
> That's kind of horrible?
> 
> The lockref_put_return() seems to encode even more in it:
> 
> /**
>  * lockref_put_return - Decrement reference count if possible
>  * @lockref: pointer to lockref structure
>  *
>  * Decrement the reference count and return the new value.
>  * If the lockref was dead or locked, return -1.
>  */
> 
> But I guess it's still returning, it's just a weird convention, and not one
> refcount uses, but perhaps because that uses output parameters.

Oops I missed that -1 detail in that one, didn't mean to copy that part.

> I'll rename it I guess on the atomic basis but I just find the idea of
> suffixing 'return' on a function that returns a value really... horrible.

It's because I though it's common that things called _put() either return
nothing, or if they return 1/true it means "that was the last ref, we
removed" and this is returning something else.

But I admit it's just my feeling, there's e.g. kref_put() like this but I
haven't done a full research.

> Thanks, Lorenzo


