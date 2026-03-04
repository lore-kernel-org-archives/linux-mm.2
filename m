Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAFBBEFCE42
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 20:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A826B0088; Wed,  4 Mar 2026 15:11:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C86A6B0089; Wed,  4 Mar 2026 15:11:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD4C6B008C; Wed,  4 Mar 2026 15:11:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 092F46B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:11:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92C8E160238
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:11:30 +0000 (UTC)
X-FDA: 84509475540.05.4D73C88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B5CE12000D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:11:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=izJ+p6y1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772655088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=J6waCGFocoCok/yvNYbXWxbN/haSRxVjKdjv8/s5P/U=;
	b=vswiApYJWwDvX2jIN3Vx1h0OCjeOgB7rn4z5BeAmAYcfZljurMEEvK+0m2GtGIpV55UsNK
	sXy5CtL+xWOAvcFVNAekWuQl+Hsx2pmj8fwKkU9pQnsWAUZt2ucmr/MUcEpl96ZhnkfUf2
	QWYtuqZClfmFcaT5rLMEI8Peoqdq5Fs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=izJ+p6y1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772655088; a=rsa-sha256;
	cv=none;
	b=Uq2qi8KNprVcH+CWjgU3v3ZiEW1r4b1/il4cq1HjanHwxdBYa5c5AW2HSXJK14I84YHKds
	LSEJPldu4VhGNGCX7TYTI2TPkOUh/x4YPe3atkgEHmejMxqSrv/XBF1e2wy+66t1lL5zBq
	KG4DwCWEHqzc+0em69G67/kaWxtAgRE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FEAA44234;
	Wed,  4 Mar 2026 20:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B97C4CEF7;
	Wed,  4 Mar 2026 20:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772655087;
	bh=o0fLUYhZXbidKVU4+nOwtfYhDaEcppAxzGJFa+FMj/w=;
	h=Date:From:To:Cc:Subject:From;
	b=izJ+p6y1fGV3WeOB/5UVyeAPuj0ezYvVHEdPPewgwcIUmmkfM5E8TCHLLrBdiwLzn
	 GL5AIipii9oeqCklhqVuufNa0f1Bsz2/kVbzK014rUsdbwHFFSTRED7jdXrCZfNbxO
	 S0/P3Deqt5UNt8ppIl/gZzFWVgH8gapB7gwV0I6xW9BPH6bPmifSQkPeVXJLyhDmCa
	 6lVl7eX2F2Gr/gJfO2zi1Mu0D3nM8DbMb7HIH381FuxwKCbSfBzN8HPq1X34h7cHSX
	 jsorHgqfBXHCwPIwV7lRhDRblqfyt87thVq9vZtk6pNo4Bnrg7iyEDNySHcrBBrQsN
	 IN3sXhibwk9/A==
Message-ID: <2ae32797-03a8-4d05-b510-615ae0418b28@kernel.org>
Date: Wed, 4 Mar 2026 21:11:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Cc: ackerleytng@google.com, amit@infradead.org,
 aneeshkumar.kizhakeveetil@arm.com, ashish.kalra@amd.com,
 dan.j.williams@intel.com, eberman@quicinc.com, fvdl@google.com,
 gshan@redhat.com, jackmanb@google.com, jackyli@google.com,
 jthoughton@google.com, kalyazin@amazon.com, kevinloughlin@google.com,
 liruxin@google.com, michael.day@amd.com, michael.roth@amd.com,
 mike.rapoport@gmail.com, mvaralar@redhat.com, pankaj.gupta@amd.com,
 papaluri@amd.com, patrick.roy@linux.dev, Peter Xu <peterx@redhat.com>,
 pheragu@quicinc.com, pkondeti@qti.qualcomm.com, psalian@google.com,
 seanjc@google.com, shan.gavin@gmail.com, shivankg@amd.com,
 sidtelang@google.com, suzuki.poulose@arm.com, tabba@google.com,
 tatashin@google.com, vannapurve@google.com, vbabka@suse.com,
 wyihan@google.com
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-03-05
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B5CE12000D
X-Stat-Signature: pm1jt6dhb4sttoqffyjd6mmjm6myrp9k
X-Rspam-User: 
X-HE-Tag: 1772655088-955435
X-HE-Meta: U2FsdGVkX1/kGDRbumAy7HBdwKMtgMkL9XYCxlh2mgqry4cUVdv8T3hrKRz5afZ03SpFLsOXbt/nQdZ1oXxfMvxr+Pp0pg7OQhuOBbI/kPPCgd3eQQIuvJu1oatosjxO8QZ58upWQ5vKIAeqr1MkdWdLCsF2ludMO+j1QKVzR4iJWMrCooNc/pZ0xJDGxpG2Ehg9cCseAnltCxzpe6B8rMn0ozYjtWW9RNPZKBWJYkzEY6A1whnB8MBH0L7+qsPjSNub165yNaRqzd0rsVeGK1A9XZIHIaXxewkE2xXJRoFDeaTqz2/gVdx1wYL+7LyhQaEjugT3USB3OX8pDmGASc/51HAYRWSZp6dhy3I6AVMR+gW+Xtvgu7c4AopRnb5aXnwwhMrbpf+zH9eWAngsI/f3Rp+/iQhUGBtlC6W2ruIaEWTS3pBCyqzJc04XZFi2z8Q/+gEDQ07dCkal6CK3EYaVp1ESL9zT8kIWXUkfPv4bYORX8UVTJfAvvE7MfDoz7gPEluUvypQpAzufkJdr/YxhEPQGHHmhWQKm8w/lF7pcH1k2wdmO01vs1b+vI/k0XC78k6NeDf/k6Itb9eAardq5emnn2E5PbFc+DYjvhTgOaSohyXZ/rHwyWL8YTsH+6+OPbtDx+QsfCTMMsGrLyh/lANVtaQ+wHAsWU3ZcZ/EykFatla4NHgVvKcqC/fKLfSgUojvtEfyKs3X8DHNSZ5uBBKRJz2iJhGvy2PM8iK02d1mWCJcrp+W4jLW/Ud4+GaUQoeI2MFVvfCE0yTi4aYMSCp571MoDKF8++PlFpVqpCCAb9MuWVfgvie2jWWDJgxtGYgMdUbSnf2If4qekLEScxDL1M7CbsyXG1a7QrHswcOP8iUTM7mxaX6ZarUFQRPOfB+VpZHY2iVpDWKg8nlM7VijV9qtveGQOC9Uet/IX3Fezo9LvVU24QNO7uMlFWomPdi5M7wrGjw6PrT/
 gcU+QCq5
 nsth0SELYsP5fgf2GUI6RVg2YxVctsfDLj3kscfFM6o250JewSl7KrDqVbZpf2FKXGixnesqIyCyuDFiKl/EvsU1wpD7xN8Os7s50vU+wKEBERq6g6y5s0Fq8bupUToKKz1xWayLTgWchAqjj/mdatI0mm1JPHXDVft9x1MyRvsgRh8i0LGyjp3zkgeAowZJbAmqTLRqHkGM1fL6/k+knXDG4cLIJ0nvhzNn3PcIQe9tNL8Bxb3mvE6XSUx/pyFApMGCjgtDjm68q5zlCBn0Is4CPH22gE4puUbK+7vAITa2OGcryGz7sevKbfqQfMV4YqpNUQN56hefx0PC+NUU3Cu1dF7iBiFi/CVpwQ5ZNzIdvfLm7X/fqaLjAubCBsb7tHChPYnHRe1Q5zNb0hj5VoglzdoJYx2bwO8tbeagLlZ7edQ0fiKFS9PSnpRrujalJ2xsb+NY/eSIH46dTf0aovW2aX0ZB91xKO2Ne3QskIncRnFUNg5daTyz2zUx7yGBq3hBujr3+UEyrR6k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2026-03-05 at 8:00 - 9:00am (GMT-08:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
or Ackerley a mail.

For some reason, google seems to randomly drop all invitees from the
calendar entry ... so expect some annoying invitation mails until that
seems to stop.

In this meeting, Ackerley will give us an update on guest_memfd HugeTLB
support, which we were not able to squeeze into the last meeting. I'm
sure, other things will pop up around HugeTLB support and
expected/desired timelines.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.


[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing
[2] https://lore.kernel.org/all/20251203144159.6131-1-itazur@amazon.com/


-- 
Cheers,

David


