Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4943BD2D105
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 13:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9994A6B0005; Tue, 13 Jan 2026 08:59:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A266B0089; Tue, 13 Jan 2026 08:59:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845A76B008A; Tue, 13 Jan 2026 08:59:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75BA76B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:59:43 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1AC481A0145
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:59:43 +0000 (UTC)
X-FDA: 84327098646.09.538018F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 83B59C0008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:59:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EFlaAwY7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vOW8eTPd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EFlaAwY7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vOW8eTPd;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768312781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fsxGz7lXxf9Fc7o+3YTmQDIIh2zdHHfX8+mDLHhYXuY=;
	b=25omg2K36WKDVecP2onkTxn0FDpdGbSqKwGEb9h0w4+0hDsKLm3GjPPr3RY3Noju0K1XjY
	HKma93uzE3PQaGkJLAMJ+Q00ytgAKkTErwllfIhGSc67RJv4BS3S0LxGpnoNtgXmnaeSED
	gQqGiaeqz6FHlnbqslU4VzD1aS5OzkY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EFlaAwY7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vOW8eTPd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EFlaAwY7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vOW8eTPd;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768312781; a=rsa-sha256;
	cv=none;
	b=ZCY3AhVW6qbZwvNlfHD+qzlaUArHEBMGnMUJzvNVVGCd4Z/Ici37wVJZaocqAhSOJcu+As
	pgaySpjvcEdPA5Lh6Q53QPcWRri5MqPXLPeLW8vJrRlF9mgTtbpIdQXO+JwcypmIoikeVw
	gntRjFpYurvvrIDIG1daJmBwuNrS3pc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A356033681;
	Tue, 13 Jan 2026 13:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768312778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fsxGz7lXxf9Fc7o+3YTmQDIIh2zdHHfX8+mDLHhYXuY=;
	b=EFlaAwY75zzBevnmi4U8yTk0gl++rzWcCywlgFbs+kNoT3c7aOkv+lb5xikamLmKm9h0UW
	J+lhtEMWUczsEOe0IZNo9aFhVctN9csVOhOSWtXHHIhSON9vU0Okp1OZa2OaYtbFNg1Orb
	c8tLcVLpkZ3qIcDj5I8ubVMGakQUxJw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768312778;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fsxGz7lXxf9Fc7o+3YTmQDIIh2zdHHfX8+mDLHhYXuY=;
	b=vOW8eTPd4fmF22JWfMzdk724fqgp2bTTyWjjn5g6EBh52VRgWGaWh6P0u1/mIqm3WJrSrj
	s+/1xhbkC21JMkBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768312778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fsxGz7lXxf9Fc7o+3YTmQDIIh2zdHHfX8+mDLHhYXuY=;
	b=EFlaAwY75zzBevnmi4U8yTk0gl++rzWcCywlgFbs+kNoT3c7aOkv+lb5xikamLmKm9h0UW
	J+lhtEMWUczsEOe0IZNo9aFhVctN9csVOhOSWtXHHIhSON9vU0Okp1OZa2OaYtbFNg1Orb
	c8tLcVLpkZ3qIcDj5I8ubVMGakQUxJw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768312778;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fsxGz7lXxf9Fc7o+3YTmQDIIh2zdHHfX8+mDLHhYXuY=;
	b=vOW8eTPd4fmF22JWfMzdk724fqgp2bTTyWjjn5g6EBh52VRgWGaWh6P0u1/mIqm3WJrSrj
	s+/1xhbkC21JMkBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8FB3E3EA63;
	Tue, 13 Jan 2026 13:59:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bPbZIspPZmnvMAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 13 Jan 2026 13:59:38 +0000
Message-ID: <ce970598-fbef-4b58-bde6-fb099f1cb6be@suse.cz>
Date: Tue, 13 Jan 2026 14:59:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: fix kmalloc_nolock() context check for PREEMPT_RT
From: Vlastimil Babka <vbabka@suse.cz>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, lgoncalv@redhat.com
Cc: akpm@linux-foundation.org, ast@kernel.org, bigeasy@linutronix.de,
 cl@gentwo.org, clrkwllms@kernel.org, david.hunter.linux@gmail.com,
 harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev, rientjes@google.com,
 roman.gushchin@linux.dev, rostedt@goodmis.org, skhan@linuxfoundation.org,
 syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com,
 Hao Li <hao.li@linux.dev>
References: <aUVTJyd74OoCtSyN@redhat.com>
 <20251219135143.7337-1-swarajgaikwad1925@gmail.com>
 <56598d76-02ca-490f-a100-0f223fb5717e@suse.cz>
Content-Language: en-US
In-Reply-To: <56598d76-02ca-490f-a100-0f223fb5717e@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: u3bdrpc4qwogfbc9pssmrf843w1cwdam
X-Rspam-User: 
X-Rspamd-Queue-Id: 83B59C0008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768312780-41818
X-HE-Meta: U2FsdGVkX1+yI0EmQma1Wm753SU255Q9WAV8P21p7hinsJnrGeFiQ5URoHroZf4XlQwQNMKPHPxIKErv08gqSbtaKe28NktEYSkzCE6yWWJrDmHGeaU/DpBoMWjZmYUGNJpmfBTxLvCAkQUgmyy7lPPZ7rMhTIuV/iNEVO1RWkHGRiiDUEBXTTpDAeff8qordgV/gkzaRjYA+o+geif0dqCZG/9rRFJG101XSKMWKs/EmzBFmDSydqYiezIDZnzVjKbaIMvmgApUbWxV9Ca2biyFvelWEiljHvWcCREMBT1069jvqAfHQlF5vVBakpxlCeTJP6oXZCcOL0QJv/6a3ZWC6DwCs+u4o+CKFpL7FGTxOCET5XdkUfMKEQ6k0SAH0/ufymTQVubZRkvML1ohH7vOZ9hKg4Vin8eJjfyCeK88dsG6wr0fJmzK+J9/aCijgsuCVvE+sZLzGBIprS8j8rsuhhanmLZ3Brvyt0PjFvSTe3fSim7n3bPhSHg7NzAm10N9CL6c0z3BGS1JS2c7NjN466ZFOPCOLYxZ+ncqRNoJ8oOswGRIKaiaPwac45WXslVxqFUXzSi6N3pb1YhqMSSqxMPC2Gb5sKPD2isIfcyxhb1D3tVVALbmUgFD8ar3+lL+5VNpQtqm3FioLOfRb5tygLf2KO3Ip5knxYHAjs84keJGi8uVDqLqidluRW8Z2Y0wzWkPkXQhKAibO/PHpj4YZBT4R+tfupsfIct4bJuPoEfjeWRw6p4tjBIG0g947L5b5RHO794KR3QMsTrxQ6N/nSeS/5bmqhbvvTx1hJJO/RMFMuIfDBF09Bl/iltFWPt9LZrtJ2aI0p4UU82jthfv1l0y+DyH9ReRtR30VKGHuNIIyx+vraDfkMghMLNGjA8zmzn8cQyTucUsaAQvKODx+c43lGcGlVibQyvfKutAQjX6ghWDHAL/rkBuJkwT4G+Qlpu0IIaKhzWwp3M
 yg5nb5Jv
 SRwdzCr+xy9UeifCrlYe8CW7LehV6uTs55CuSy2eDA4T+5Z1dvTrS5NAmztbWsUtkUatKCx/9AZDX8zpwNXiFjEpH4rLc3k8zFcwurXYIZ4Am4ShMTBib326h8dyOBla/lirGv1r4m8KpJYzOVSnRt/wk1JBUp02I3qKe6KEOg0nGGH6MAQpGMncsr0JM+Ts0J07M9Ej1+fLAkje/xLW327X948YD0fW/Uq0471V42EepSv7ffTdvcOf6FWMyLJmKS2RLDkxr4h4XjjyjtMc3bM8p7d5860j5Vad1lslArNNAMTJ/0buXMSjWXp8NBBfQudCW3UE+qRubHPdUAPmGtSOBn8ujjdCkKmaobtzSSYE8aUlnfztow06LZszvNhBjxCGNRAoOye5pO63ArAQyWCY1Qo2l7vZdPaq363ZPJBTNcGmk2cLnhTrxQG6tLhj7We0SwzqEmU2Mmyc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 8:19 PM, Vlastimil Babka wrote:
> On 12/19/25 14:51, Swaraj Gaikwad wrote:
>> I agree that we can simplify this. I think !preemptible() would be
>> the most descriptive choice here, as it directly expresses the
>> constraint, we cannot take a sleeping lock when preemption is
>> disabled.
>> The updated check would be:
>>     if (IS_ENABLED(CONFIG_PREEMPT_RT) && !preemptible())
>>
>> I'll send a v2 with this change unless there are objections.

Ping? Are you planning to? Otherwise we have to do it ourselves as we
can't leave things broken?

Also Sebastian do you agree? Thanks.

> I think it's the best solution for now, so please do. We can change it back
> later with sheaves, as Hao Li pointed out. It will limit PREEMPT_RT
> kmalloc_nolock() for now. Steven explained to me it's the tracepoints
> disabling preemption, but that will be also improved soon:
> 
> https://lore.kernel.org/all/20251219120607.7371034e@gandalf.local.home/
> 
> 
>> Swaraj
> 


