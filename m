Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07932606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 16:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Udmu4xv5
Received: by kanga.kvack.org (Postfix)
	id 0D8456B00EF; Sun, 15 Nov 2026 11:55:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0898F6B05B0; Sun, 15 Nov 2026 11:55:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB0E6B05B1; Sun, 15 Nov 2026 11:55:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFBB36B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 11:55:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB456A8221
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:55:08 +0000 (UTC)
X-FDA: 85437953496.02.AC071B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id F05F31C0005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:55:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Udmu4xv5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794761707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m20EIIwxT41T/fFa6Vq/LrIlpT9IXPr5QJgmc+YKdJI=;
	b=zokJstp9rnW7iO6PEbqM/JkVJuPMPDlGvYx/Q8CJHwJCDor3ikWXYPDbf7q3nkzOyNDaRu
	gGvoFcpGxMZCXUE5h4R9uSJtjXE/HGvXPTlpM/8gyt+IPW3rv3icYciGCoOuRLEeG0eGCz
	Bl0dH9RznjrM7ihDnmtkKEbMsp3l8tQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Udmu4xv5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794761707;
	b=i4eXiVEhF1Z2lqdGmgbT7fbFu5+0OdEXMuceeiwmOx/924BcmsQXB3zJ4wt8J1AX8708mb
	rVIjmOfyrlefsYphnk/Zgzj8DI1MQba7pYPY8wzn8tq0kf+dDdTs3QPHs/do9F+dQ/KolD
	hXX0t/9gva+CXInAZBRw5HnFnMzwXBc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F02560051;
	Sun, 15 Nov 2026 16:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428CC1F000C4;
	Sun, 15 Nov 2026 16:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794761705;
	bh=m20EIIwxT41T/fFa6Vq/LrIlpT9IXPr5QJgmc+YKdJI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Udmu4xv51KQf6LUkw+fPEBbDQqPjjdSC25iF11u6fG8HwmqO91dFbCQ8dRo6f87NJ
	 KsjMcPUBY1qPtnTu5+HEO7hRzOJfcIBcNIFVdreqfRSLFtqB1iIi0811YVR3zeiaRe
	 JiZc2vou7QFILany/TI7zxc8OeyY5aK6C9mour+lDn5ACPgCPENe71N+mBZiBjo+0U
	 +3CenoOy8LDVamRnnqCwI0fDQw9tPxAQmaqYS5u5fedlN38uLqt7TB57RuEOCLLZIt
	 FmQjQ70PY0vSwK7GOevb5VHYnGqGEaA5wwBFFu7vKhwdg97EPniUyymiOeDHmEpOFa
	 WN4J++/7qBFYg==
Message-ID: <042795ab-e8af-443f-b34c-72c674c0ea32@kernel.org>
Date: Sun, 15 Nov 2026 17:54:54 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: add vmf_insert_pfn_order() and vmf_pfn_order_ok()
 helpers
To: "Farber, Eliav" <farbere@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20261111113045.35368-1-farbere@amazon.com>
 <20261111113045.35368-3-farbere@amazon.com>
 <a242ede8-71c2-4f75-b5e5-dcfa98ab25d3@kernel.org>
 <BY3PR18MB47227EB15146F8F16E1C005BC6702@BY3PR18MB4722.namprd18.prod.outlook.com>
 <29bf5516-36bf-490e-ac35-d89893fa61b3@kernel.org>
 <BY3PR18MB4722713137ADE7A59A1EB81BC67D2@BY3PR18MB4722.namprd18.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <BY3PR18MB4722713137ADE7A59A1EB81BC67D2@BY3PR18MB4722.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F05F31C0005
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: bc1oqzrxu6m19xc5o5qpp9pdxkrn74cb
X-HE-Tag: 1794761706-732780
X-HE-Meta: U2FsdGVkX1/XbKkfFhwAw77ruRnJ6lApmwVs3ZPPIM5nGS1R+fCVytCjSm0njxVmEORaE8BPUtMRRfiAiyd9a9MKf/wnMu6X+xRha02SJSjWSDrlloNhUuaGD8It2Mq+YGTi8DzQjinqBg8Yw8JuZmEDYan8oo64m2K1JHGC5w6yjZnMUUcRE/x+A+Xpi92KbRhNq7daZbSzDaxxHeb//+DiU33jxuJ/BjAYZQp+53YfqrXTEzObq3GyH1P1sb4d6fwaImf65orSKOLH3e+S5MeJ3Y7X/NlxL0qkM52EKMoKtFuMevC2BSJc0IDxTXKJxxg6QKG617LLAfIVBL4NIRBylIhbw4B8mN4uITmaScy347yU1j2VvExrhxfciSvuHBrB3aYG+7opthnC7v29cFK/zEfyJ2qTK9/rAm1Tsz/2qDMVrHM2e8FmwfuF/a2PYDvqghrhz5ECgMCHDQsxLIDYH/6NC6eu/xryOM9eXYkHBcHMIqL0IdCqPRLpqcDlhX+9oFHnODiNkiYH+qd+BGXKcJQMn3HTSiG6/3pKwtrYD7EfaakQxDWCnceuzGLZEbd2eGffm9oK/KGi2SHL7oS0H3zKUSdXKfQETdfzhg0SkyTBZFY3YXvum5MvhR8zc7plbHlHnh2W1P9FuX9QK5vG07EIMowQN2Z6yHQ3OBS6BA+PmiFg5WD86LjnGlPVE3hUvbDAdmEMJG2YzLP9Wssj4+fwUTrE9hlPzbIgi/kQVzugm7pL8axK+rtoa8PBWa5d21oWk5B5NYhp9gAlAOCukm+udGQufaXjsP1aQlGA2UZRAD6TZhPfagO8cYQtGJM50Wr+//FijSBXZo6j15h4Hig3ARXsy2EtQ0pEMeo6+r3Ip2hNlfIKNwdOHMR/MJu2iVd1daYcnWTr16gj+Zuxvs18qTQX7zEJoJBB9gjScTwgZAKNhZR5sPZzquVPjTb6FDQwr5oZr+A+isY
 5Qks4SUF
 XHijwzKQgadN2klvVTUllVeQxhsfZN+PIZgTHiOq8Jgx+O06wqFKoKrE6vr2ukw9psp8W3og39fceofCN2h7urY15fD3infoRSqnscrkuOLSRSa+gpQIzyd6+Y3ZNqFeLts+7lCQFuCD5jQ8E4Zevj4Mox3HBYWkT+QjQLLJXmrrAHsvoPQzfFDnylEgZ+naROZTSWEr7LMSK5C3rGklGRN6zhV1/XGD9daO1mKhaV48S3aG7NIQ4ENdI4W56YnsXn1kZ8/Ih4E3+rXzr78NwwEo7Q/HJtzpgdyb2kUHOadKbu9oUUMDNWsu3P7qbmR+mdG+OHdi+9wtSiQXhh6nszLOKJX7nLJQK6khu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/26 07:44, Farber, Eliav wrote:
> On 11/13/26 11:39, David Hildenbrand (Arm) wrote:
>> On 11/12/26 16:55, Farber, Eliav wrote:
>>> We crossed in flight: v2 went out about six minutes before your mail, so
>>> you were reading v1. I posted it to address sashiko-bot's review of v1,
>>
>> First, wait for human review. Always.
>>
>> Second, read Documentation/process/submitting-patches.rst
>>
>> "Wait for a minimum of one week before resubmitting or pinging reviewers
>> - possibly longer during busy times like merge windows."
>>
>> Because we have much other priorities right now :)
> 
> Understood, sorry about that. I won't post a new version before I get
> human review, and not before a week has passed.
> 
>> Before I reply to anything in here: did an LLM compose most of these walls of
>> text? :)
> 
> Yes, partly. I used an LLM while working on this series, to help with
> the code and to find bugs, mostly for testing. I also used it to write
> the text, and that is why my replies came out so long. I should have
> kept them short, sorry.

I don't want to be angry on a Sunday (I'm not the type of poison), but this
grinds my gears. Your commit description is schloppy, your code is schloppy, and
-- even worse -- your replies are schloppy.

I'm not interested in getting work-schlopped by people that believe their time
is more valuable than mine by feeding me AI schlop on the mailing list.

Please rewrite your answer in a way that doesn't make me hate kernel development.

-- 
Cheers,

David

