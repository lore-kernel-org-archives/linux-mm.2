Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B573D0D177
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 22:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFAD06B0005; Wed,  7 Jan 2026 17:05:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADBDB6B0088; Wed,  7 Jan 2026 17:05:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E79C6B0093; Wed,  7 Jan 2026 17:05:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8EA5D6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:05:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46A5A160294
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:05:10 +0000 (UTC)
X-FDA: 84306549180.01.7825E66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8DBB840002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:05:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A+FG20a6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767823508; a=rsa-sha256;
	cv=none;
	b=srSaZOzhuoOxZn3RyvCQWqqf8Y9TRrKNIyzB+TN7QbtfJtsLGyCcZmtlBgurIT7YuA6U+n
	s0SftTg0GtbrS29sggzLDgKp/bMDDYYybM7U3c1078Kkdr+FYWZ0LEjparTI92aY+qDbCx
	78MXxwoRdu0ckm5ras5+Ym+Dg9XSyRI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A+FG20a6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767823508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAOhHx4pazvekUHuDbez3aHMJK5VvyyRiD+yAHlmRC0=;
	b=JjrqBnFhtP2NCPwTT7Qnhmb8N1RahPwegdFBLTz4gdph8/rXyOQoRuQi21J8PZgfqQ7dWz
	fcS7dEHT9bwCROx8IvgmR2sBrLx3ehc2INWNmuG5M2XVBJXKdNo+1tPp5FXCEyBQJFsbmH
	o4D+yXpM/qiuXlW48cJpsEQNIANRtKw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E4B1360007;
	Wed,  7 Jan 2026 22:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EACC4CEF1;
	Wed,  7 Jan 2026 22:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767823507;
	bh=cNpSkJ/syd9FIfSGx8jBCyKWKM75SLBKpkNnhkjpFsI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A+FG20a6FOU605GFudEuM/qbtlH8ADbP0iXTWUvdUxWehUpyxNM8mJ0Ab/kmlBpV8
	 7vGZ+KtM9SKvbT9uPj2my1p3+Sa/oG9SaLNV3NO617uS5OzpKOk36ohOdXGlQL5fgk
	 59uL9n5hiCdFD4SkLgYAVJj3aMVJIZP9Yi3u2qk61xBuNKzUDGsWKwYx0vhgPIiQ4Y
	 yAbDBbL3PK0gJRt6x6m4HEdU2S7Xv5YQ9Vqc9XNbWdkyUZkrbgtBo1whEFCOXUzupX
	 9/1zhEjsKx+ovwtbJzBH+RoS5x08KVf67f65fiOjbf5yuUPDwtxmf6mlyzpu2T7ian
	 PlaEunCn7xdVA==
Message-ID: <ff498881-4bff-4c77-983b-76124adfc78e@kernel.org>
Date: Wed, 7 Jan 2026 23:05:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] amdgpu: don't report an error if the process was
 killed
To: Mikulas Patocka <mpatocka@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>, amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <aca0147f-61be-30a3-eff5-cb981222aacc@redhat.com>
 <7ffacc33-9233-4fa1-a7d8-28fb3fbb8061@lucifer.local>
 <06317034-2677-d2ca-b468-841a2076e84d@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <06317034-2677-d2ca-b468-841a2076e84d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8DBB840002
X-Stat-Signature: 99nrstsics4e4i3qf8hzbm8sqs7mcw4t
X-HE-Tag: 1767823508-423271
X-HE-Meta: U2FsdGVkX1+LTY0/RTojMzLElB1yCtZfoe/suJj0GTv2NPJggn8pgy6CdKvalU0J7fIxKUFXlIvSbDh9LHd38cBeb0GFLlz5d7wTHvXMFDAensjLrbkCzW7ZSXPh6HOCGXIQY0hILk5Ja2dkyugMpVoZS+k6g3yJY+ZtFEVwVjDeutpal0ua3Tbvm/KoVwfOEL/QCeLjdZzBHTXgB1OzDFWOHKTy+TsZrezlKJspzx+U5SMJZibS5Wed90PdJBTZn14p9XwcVW+D/ryUihX9iNmWl9c26Lc6MCtJ4OCu+/hNUIORkOFgS6W2wJtz3UMdEDmDVY7PrIaU51b6lQhv5hDuwZBweRZ+XRKo7UOohkdwnlrF3Pu6mnfz7VijbqTQnW6/4YjnTufmdNaleeexUW4mjRNh55rROgUpuau9rkziPJbTWxOQiLhjbA1fXzw7lI0HYOjbMyJ/L30wZh5nbfCRLS6nK2JrfcqvLmmrLCWkeY92IZlvhUTMahUenTWcZRuhA1EewbPl46fmdVln17RsuF40yvyDqh7yDTO7KpZ33X9OqyukFFJ/y+6zkA3qGyYXhZ1JWEb2PT2rlJFa0ltrgpwEIFgnFcRhPsMcvmDO03RMj5+5/A19UuC8Vneuggel2G5Jlcgum+xeFCGYzQ6187JErl/ajhD61Fwd+SOoYapkG70dvYiMu9w3fZDswRnDRl1lG/LCOtIdKFTqKM9+X4Exl4UEMhKgyDcN6xiBqnpA0lyMrf/quFhAw8niYENRMuuJN2RVVy/HVmEUPJ4TdJbArBhSPPj+b2DetX3SjeR/HKFFlZX2BlLQSZcB+R+6l55tE4ckmXrUaIE1bf5SPrO62uM7eZfOjvqWCN99E2L6NymqeRD/gL7bHb0hSQdQ922sBC7L2EQjySzBYjxvuuKYlRsZoFH1adS3pM9B3c5/LumFibxEFz2YdDgui/PeWJweKcDAjC+EgmD
 VAakRZ3h
 3EVSAHnJVMFEJ4a7HgIa7CD0a+7HuF2IiZmeTJw5i+dwevZ8FWnkTQPGcK13GDu8zBG6gNCCIlxIIZUDzNoRxi6km1R7oSzFRFOX48WzZiQ1VmBzJJwyC/ImLWuOVWpSzclWeyEQqqWy9n0SBLrGU5dcts44DZqFBtTDPFgTqOTjKaWlT+1pLQ4ugQz0JB3q8+D35dc4zsh2cg6xJYVdxzxpQTHW7lgiHkPLRLW5oPBJ6oS91Zb696r2za85ZpURwHVFWFNwz3WL33IdTl9PHeEMNTQARw/MJL5If
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 21:29, Mikulas Patocka wrote:
> 
> 
> On Mon, 5 Jan 2026, Lorenzo Stoakes wrote:
> 
>> Gentle nudge to ask you to please thread these series emails properly in
>> future.
>>
>> Use something like:
>>
>> git format-patch --cover-letter --thread ...
>>
>> Or b4 or etc.
>>
>> This is a nightmare to try to review without it.
>>
>> Thanks!
> 
> I don't use git for patch development. I use quilt. I find git quite
> awkward when I need to move between multiple patches and update them
> independently.

You mean, multiple pages in the same tree? I hope you know about "git 
rebase -i" and "git commit --amend" :)

-- 
Cheers

David

