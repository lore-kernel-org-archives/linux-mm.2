Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B6B606B128
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Ln7e1AWP;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=rhPGPUCZ;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wTzFlnuf;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=zfj8vy6k
Received: by kanga.kvack.org (Postfix)
	id 552486B05B2; Tue,  3 Nov 2026 06:09:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522EE6B05B3; Tue,  3 Nov 2026 06:09:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438656B05B4; Tue,  3 Nov 2026 06:09:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 181906B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:09:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FAD140396
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:09:26 +0000 (UTC)
X-FDA: 85393536732.15.70BB692
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7B92A80003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:09:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ln7e1AWP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rhPGPUCZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wTzFlnuf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zfj8vy6k;
	spf=pass (imf02.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793704164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qarcZZQ4Pvpd+Eskx/ZkJsQlIkAUMYn0G23lRSUKBm0=;
	b=TLnxv4lqlz2lfM2ouxtN5XAd1+gg8wOaruT+TH3i90fA3QyrGHXRYOBe6fk79lpmBTfdjz
	4mubQJHPWf/yRJolLm8smCOIZg7T7pJQ510YwYEoGEb1OLACVeAqFGEGb4SaHSmzYjUu+i
	9JZB+0qGS0ewjRoHFC9w4HqflutW1c8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793704164;
	b=S9Nc4h+uSGpgH9PKwHo7p5BvWbmia919rpLRinDiN/oZz2pe7829eINNSl66RfCqm+pgJ+
	PzpURI7byZZUlaVV+60dO6h2u1p4rWpefH30XIheiITKypF/HO1FAhAAEXobmOLO3qQCDE
	KezUAt4ii5brUC5gQivuzvi/nDhmPm8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ln7e1AWP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rhPGPUCZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wTzFlnuf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zfj8vy6k;
	spf=pass (imf02.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A7D801F851;
	Tue,  3 Nov 2026 11:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793704163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qarcZZQ4Pvpd+Eskx/ZkJsQlIkAUMYn0G23lRSUKBm0=;
	b=Ln7e1AWPqeO8tey/St9gMxw10zhgzRhc1E0p2nvZhQtEV14ZmWpJVgF+m29cCeKL+vMeWh
	AwxNYUaIHh8FuS4VEVaDKyYdAJIarC9nSWLtPrfutX1ksDb927/ks7ay3EOxy9Qq02+LJh
	1er4GydxR8h3wKecEqyfOQ/nozZFjvQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793704163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qarcZZQ4Pvpd+Eskx/ZkJsQlIkAUMYn0G23lRSUKBm0=;
	b=rhPGPUCZar1qg51irSrmQHzi+MOh+2VhGXgHXgsGqvA7LbbTMBC/EfNjrbW398wrMLlMC2
	jxxEwL2u6nJXhDCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793704162; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qarcZZQ4Pvpd+Eskx/ZkJsQlIkAUMYn0G23lRSUKBm0=;
	b=wTzFlnufB/O28OfM/In9u0tun+XTcYCPxKNYphDoQxX/q1Wn0QyGWGwN5TH10K+vvmZLRQ
	9UZZrAEtROwLE/zMUGXnBzPvqru88IfWaDbjzjYe1FsRoKeFMifbNZ3XKx8oShGxAhJWKp
	zUPqtsbpDv+D0knpvzWDGE+7xh/os5Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793704162;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qarcZZQ4Pvpd+Eskx/ZkJsQlIkAUMYn0G23lRSUKBm0=;
	b=zfj8vy6kaGRbelluWH4W02FeRwUOKocR4zt+QWcBMhrTWP/MobG6BkLFjqU1YdkyottYX1
	oquHdH72L94+peCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2DF861350A;
	Tue,  3 Nov 2026 11:09:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jOBJAOLA6WrZLgAAD6G6ig
	(envelope-from <clopez@suse.de>); Tue, 03 Nov 2026 11:09:22 +0000
Message-ID: <b9ed9dd4-a1d0-466b-a6cd-89a4e70abed0@suse.de>
Date: Tue, 3 Nov 2026 12:09:17 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: don't zap secondary MMU on
 permission upgrade
To: Sean Christopherson <seanjc@google.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com,
 linux-s390@vger.kernel.org
References: <20261029143336.390231-3-clopez@suse.de>
 <20261029175203.5bdd51d7@p-imbrenda>
 <df9dc526-4275-4784-8a0c-2e4fa8e96402@suse.de>
 <20261030133939.630e29af@p-imbrenda> <auis0SaMkRB6odsK@google.com>
Content-Language: en-US
In-Reply-To: <auis0SaMkRB6odsK@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -13.29
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: aw4bed9drdosockkn7torz831go5ep9a
X-Rspamd-Queue-Id: 7B92A80003
X-Rspam-User: 
X-HE-Tag: 1793704164-452266
X-HE-Meta: U2FsdGVkX18qtsBFyLIAV6II+3k3JR2EwShlJC2AYVNbpJbpZLGy9GHl971HXNhw8KYVBnfAycaFwjzJ8K36uuJ1mOXWt3+VwtjYXPkPBK1LsNwnzNlmSePpafeAZ97meuvek7Dqwq/hCLLgFcCHyA/a7G5omM3s932Ztv5cAmPNnZv0wmCf4wMh4odoZV6KE7hV8yEuo8ctGyZZGk6cj5Yzfcwz817XYPQCjZKRW0Y6k9n82iUGOnbxsvIc5EsD+e/5BOC66MXr43SWKnUFCXXGLN4Jrlz/8DqtSYRumuew/ob6fgQcWIh46AnJAEcuukDo13tGZt/ayaCfoE+zt4DcfT65B+d3isSPqmjNbSYjCiAy88FqJwvxJCTHPEAJO8w86YOOGfGHLa/8P4GA8Pqqy6LCCq/+PmuPl0/7gfFJKtBUgWUl9UIKkcmSVKhaFy9ZSRTS+l42qD23wM6T8ChNggr6RrejPpSBsFyBsZ9/vy4/L6WkBYLtLaOdHc/CSW7npYDGO4jdFnFn1tM8N0Is3WfH6FBFpmQewV2kHdhLlkQeQ6p6FuQ7B5qLswid9Tlyb7XuluCf4m5LsGnw91UlaM82KOSM6oH6BAtUAOXEPCxyvAUWUziDisTzuo/E8hQ5+Jxn3l4d+CadFn0iecQ4ulmPKplZ2Ik2ol3f95o5k74AqDJV/+UevBpUwVK844ZEO/C5u/zBd9ZBtZug/piuEuTpDgiDRcgbhrjrkINQbNLmiY3dNF6nPNkz+0bA/o/pJJAW8RVxZ3gOy5X9cXvV1prOThDsfo1ENyEla2Q9VSKuAhL29y82ipZ5if79hd4foRbsU0NcoVnotBVbcyuw3wo3tzN5CLZ/hjzoBhcmcQtDe5Qfx/0GNYkaRSOZBv6aPQLs+d/0/3qChTO2euMCwLt2l1d5ol+oQbooJ5XNziwuWXnmRswLqxdx9q5S6uV8HSiGQtJdDWQt6ng
 SdG41unJ
 1iFWb417NzXoETNjly39k1NjK62q5mBSJd+21XM/jhPmI6Y0D990gMNTr2wuuL+MBTMErZLHuhtb+TO/sFdiHlbMDp3FyzUoW3UD56B2b9Bu5rJs/j/XvbEcaonLByERXDqEc7OzMkqWUKR9Rk2Itb2oD6Rc8O/PkQd0BL5KxYhFpdXOeydifH77wAgCnrs24m6lQd5Q99qE3LooOLsSfTbf0vMNMIfnj2uwXbDslcIEpdfhl7YKdKirp0rThPRYEOw4kcF2hf0YJaJCptl05GgPeoSLFvJ/scgQ/Yuc+blf3/VRn9R6St31DvaNf7Kw0hEsv25GNFaFpibf3AjslMVthSEfZWZCZ6vXzNGi1rp91Bmo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 4:31 PM, Sean Christopherson wrote:
> On Fri, Oct 30, 2026, Claudio Imbrenda wrote:
>> On Fri, 30 Oct 2026 12:11:07 +0100
>> Carlos López <clopez@suse.de> wrote:
>>
>> [...]
>>
>>>> regarding this series:
>>>>
>>>> on x86 you don't care what the new permissions are, because you're
>>>> updating when re-faulting (if I understood correctly).  
>>>
>>> Correct.
>>>
>>>> for s390 it might be beneficial to know what the new permissions are;
>>>> of course we could look up the vma and find out, but since you are
>>>> already checking the permissions, maybe you can find a way to also
>>>> convey the new permission bits?
>>>>
>>>> that would make our life on s390 easier :)  
>>>
>>> Right, getting the new bits from vma->flags should be trivially done
>>> from the MMU_NOTIFY_PROTECTION_VMA callsites. There'd be no users in
>>> this series though.  The rest of architectures still need the notifier to
>>> tell them if the change is an upgrade, since they don't have an easy way
>>> to grab the old RWX bits. Passing the old RWX bits from the MMU notifier
>>> does not seem trivial to me either.
> 
> But why is core MM even doing mmu_notifier_invalidate_range_{start,end}() in the
> first place?  I.e. why add MMU_NOTIFIER_RANGE_PERM_UPGRADE?  Just skip the
> "invalidation".

I briefly mention this in the cover letter, but in short, denying other
users the notification seems like an overly intrusive change for KVM's
benefit. A flag allows users to opt in instead.

It is also not clear to me that secondary MMUs are not relying on the
notification in some subtle way. In fact, Sashiko points out in reply to
patch 4 that the notification lets KVM retry the APIC access page reload
in case userspace shoots itself in the foot by calling
mprotect(PROT_READ) on it. This would require a really weird VMM, as it
would need to go looking for the page's address, but breaking this would
be a "regression" nonetheless. I will address this in v2.

