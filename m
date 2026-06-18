Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60CC9CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461AF6B00A2; Thu, 18 Jun 2026 04:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439166B00A4; Thu, 18 Jun 2026 04:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3285F6B00A7; Thu, 18 Jun 2026 04:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 015EA6B00A2
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:47:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B6478FE00
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:47:27 +0000 (UTC)
X-FDA: 84892404534.08.67FE5BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id AEA5B4000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:47:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2napG4F;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781772445;
	b=QNVp4q1DBHfY0ksCr5bM95DFwbT5QoYq0+sUJnLA4/Jdd9sw/NT2m99hPhO1qgszjjTZIC
	/eRZDUnvTxDBiE5VHho8L78p/9uDCVMzAAvaz8AP7BqQgTItKW5qi84hnrE0sdXBcmY+s+
	+RMAuIYuPjJ0UrBq5TPdoiIZuVEK94U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2napG4F;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781772445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnSbWReKGTEDPoaUR3qOev0pPCPHLKT28K++dObk2Z4=;
	b=0RV1LdnXyXu54MaJ/AdrX5YcqBUoEwVLqv2DOUfwpWZAlK8VBpTS/YOPy9xGMWs2X08kYp
	1reMRTpag/bYTF6tPySPHACZLEA0/Fj6A2/MldgRiMwCcKu5bdF6JMjDkiWNk/i3L2W+Ec
	FsoTQVCSiCAhh+vtrNyKW9whEdiWKiU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D9CFF418DD;
	Thu, 18 Jun 2026 08:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFEA1F000E9;
	Thu, 18 Jun 2026 08:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781772444;
	bh=CnSbWReKGTEDPoaUR3qOev0pPCPHLKT28K++dObk2Z4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=h2napG4FfR/yPntLk9yltjsnQ1tWjH6S5xgCqt9ov3q4oh5HWT9ILBcDj7n1lAKVS
	 Gj3t0fhK8jL2HzUkqIXxVlJbp7Q5H9PYweet2l1FOjxfJbUE2mxdD6LdxTFYu4NXX6
	 3CH15FT9GJjMwegnFDDQjy+m3iw6Rs8AOxyjn4JNe7iiTFhUFaqhdtczAn5CB0620e
	 pPSshravIhP7l0D5iSUrj5wwSnIgZqaQcL5XFFzakD5gK2RaVO0MDia0Ibp/yuCtpK
	 OiMWdYA+VXlVBcibkICEFagANR9A52Ue+h6FmWNDLBk3aB/c7ddKRObfDVSlZw25Qc
	 8ZdFnDLdc/bFg==
Message-ID: <41ef0dce-e973-4947-b5e3-150fdb07f1a6@kernel.org>
Date: Thu, 18 Jun 2026 10:47:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] userfaultfd: prevent registration of special VMAs
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linuxfoundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>,
 vova tokarev <vladimirelitokarev@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260617194059.2529406-1-rppt@kernel.org>
 <5a993689-f730-406d-8515-8bb6025cc851@kernel.org>
 <ajOtfdGgFQYL-T6f@kernel.org> <ajOvwGs5xhnfBu-k@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ajOvwGs5xhnfBu-k@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AEA5B4000B
X-Rspam-User: 
X-Stat-Signature: aonpzfk15yah4pufb164t3gpc76me1w7
X-HE-Tag: 1781772445-731789
X-HE-Meta: U2FsdGVkX1+Xa0PwWcstvkcC2USQ56FnTCHSUfG3SX2Ly5tZp9xtUy+hfPVrJKQMdYLgfCoxe1tr7izyN/8EkND2tPJIXx13yqbNhtVeOCcobl1GUIuToy+A8Ph7s5sOn8mDgboCucXck2HX8febn26Vx1ICgzQ78e242lLn2wAsDuCRXq4QLhelxUZz8U7bwZXDqzfsSFLGYj7XHzokjI9CNZvUsbR8xC9gKqBm3iiGg/evRhOB/AWV3UG1T/fyGpmasBKAa/dWciYrQooNwIPaoxSvCN+ZSZLYHz7xNG9WXZkkoWq4SYIHcN5VidWDjd+a3FyXCFw0gMAV0SQKDKHGOXEslNOWlRm1IO8hqiRuBK5Rn1OZ6mUBm+kS1BZ/bnos4aFEg27TDzXqprjN7oGUtLQmScA3v99gn22C3Jo0jY18q2UbURyQN4HSG9/f++R61LECHaELKR6nvRhrgE/AJSqOmKf6lMXytE52/E6MSyOhmP49FWw0TGrU2gRTwB8Rffi/UUyW5Yw4+mW/BlUbChF1H1A1NPGCV7kDVfzySjB/DycO522NrGT4lexV/395x4r92JI6pbBsMm1IuxAKQPi6CRVPARCOgu9WgLwLMn2eiv03y5+zzgIyoM6nZyb3KU9LWUxr8TUd23tSwXHoAjMc0/J7AtfilaUgG+RHPcRIRkO6WkntVTB1hNzKccxKeggMe8UNeBc2ZOy+87/MLPzjxsY6NOXSIKPw1fdlzB963roNPQ1ndk83i+KLdjM8DtVTIYjOGQKI+Is4IfROJoRAbPdj1hzOy1F41IQbLJLVW391HV18RXJMgvbp2ouHdSj9kwHR/lO9cEi2Zzbyikd+UVIF3/wv0sduuReYRpAXNXmIah47lrsybp9DxmA/ZcCHYnXiAPRDUwiuGNMpxsUearJnNegZg8CfvcIYXBNrOOJiiqePEMdqdPMBDenKlR3uUdROWW2In5d
 dbWWwvH3
 WFVpJsKv0EVO+McXg6tarTqifgcIQ3Vatm4xZWo6m1tduQBZr/dhNXOtP+5LLAKSH4iT3qHfEmg9+PDmQ8oMccJJqzbnmfFUk34syMKLZfntrL0rVrB6h5oZyirH1F1lB0XeEnZnwVwVqgmv9AIMneEXeOhhCXeOcCjyFyP3WPaalM7itamVFML6UV8NfTFPR+mHkCAyNKjjKVuBbxWQMJNrUHzsVRBYDJ2YUORVr9O7ZiZkOgTdK7VbGfyY/0dyOAjFj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 10:43, Mike Rapoport wrote:
> On Thu, Jun 18, 2026 at 11:34:12AM +0300, Mike Rapoport wrote:
>> On Thu, Jun 18, 2026 at 10:19:17AM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> I'm sure you considered VM_SPECIAL, which additionally includes VM_DONTEXPAND.
>>>
>>> Would that be better, or what was the reason to allow VM_DONTEXPAND?
>>
>> By itself VM_DONTEXPAND won't matter, as uffd can't resize a VMA.
>> But thinking more about it, it's better to make vma_can_userfault() more
>> restrictive and just use VM_SPECIAL.
> 
> Ah, hugetlb sets VM_DONTEXPAND, so it must me excluded to allow uffd with
> hugetlb.
> 

It would probably be cleaner to just allow hugetlb, and then check for
VM_SPECIAL if not hugetlb.

-- 
Cheers,

David

