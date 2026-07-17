Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C1C3C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4036B00A0; Fri, 17 Jul 2026 12:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E3E6B00A1; Fri, 17 Jul 2026 12:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51CFD6B00A2; Fri, 17 Jul 2026 12:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F53E6B00A0
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:12:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8EFC0120125
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:53:19 +0000 (UTC)
X-FDA: 84998561718.17.A5C0B37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D1D3F40004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:53:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EOKldVbv;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784299997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/oJ5Qf/VbHfBWLAM64QZk53YNO+mKq9utgzR8uUk4E=;
	b=zvVW1kfZdjBAhiswRJhP6Pm4gKVCVlZ7yzeSZ1JxivrfEYhVxDu6kBX4mAZMtZiL3Ptupl
	hUOJNcXOQw8N6W1kuEXeKUf0V3vZjLASSdG2APbPdXDZzg6iWwxmC2MDDnLjfkGZNAcGGB
	V1g3XDQ2v14WLkCGK7DgZ01DcWT/37k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784299997;
	b=wWm7Gmsig9cKWudX+KOM5tdjJmulsDvGVUPZ54ZMFQP9D/DzWspKkcoUonPKnOfduit741
	FpH36uiaeKAllMqB+UzPVa5S0JCC3w9UYFd+NNlBIbWmOnj/SCcm2MV/nC1TERrxMsxPfv
	1Lmuv2L4gyseXRkef+IWpsQ2P4Cd7ec=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EOKldVbv;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A7FF60A5E;
	Fri, 17 Jul 2026 14:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1426A1F00A3D;
	Fri, 17 Jul 2026 14:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784299996;
	bh=1/oJ5Qf/VbHfBWLAM64QZk53YNO+mKq9utgzR8uUk4E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EOKldVbvIfdnaD+P7TdPswSLRN+O9HifxN6uWB8N8hdEVWGAf8uN3yVuRNuqRgRfe
	 o81M2I5yAgWGhNB0EmRa1Isd2tZlGCfIFBKvn7Qw2sb3+emXasJS53nw3LwsJdAXEo
	 W1Sbi5NBo8+rHcsbn39WHpiBv1Fhj6ig+C911jyaEgdEstRAPNcKythrdY5GoKmKHz
	 BNndFan+L1ioUCt6RaHPT9JrrLZQPtm1Lv3TJ/t1dsj+fI1Y2af7/27oWKBYhpQZst
	 p1MqjL3tU+iVijQvuSWMbtSiVvfO8G7TAI5EZ2TK8Izeip3tCPQz3pPsHHI7ryX8Qw
	 0uRbih7+b2gfQ==
Message-ID: <e50fb51d-72ac-4ace-b532-5cf32ecd80f1@kernel.org>
Date: Fri, 17 Jul 2026 15:53:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] mm: introduce __ptent sparse attribute
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Chris Li <sparse@chrisli.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
 Muhammad Usama Anjum <usama.anjum@arm.com>
References: <cover.1784292223.git.agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cover.1784292223.git.agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D1D3F40004
X-Stat-Signature: fs7ucatiwxm6d3s8ytbmnc8rse6iwozc
X-HE-Tag: 1784299997-216833
X-HE-Meta: U2FsdGVkX1/mnaEuLAvjhlDbRqsp9pJB20SJm7WJmNZQiqbQAu9G+ESUPBZu562FJi1ax9OctDhA9HUB7LeePqHW2VJe9wlfQLd17AvbCbTHyvkeyUDprgAHzSPZP6aHnvwdTfb0MRsWI0GVfLJFb6BKmGgrozKzo6S+QNGmM/nNtaI0o+dT21mlPllTzJXRNit0ZXgsyRt4soG8rBWvnud+80BK9QNw5O81kP66Lf/38bomleOkdT+vZ+f+LPLmQrYJukZFZJAJki7ffdM7xdv2kCcgrdfi7LGd+M6NHqaA6sPEWbTalnZ5I0Bw5KcswzjpDNvsqgJGRlLmR6SIB3UNcej+6FpagIkOOwtVYMU20IoMMd720+KhXo4Cvtoy0eIxZWiS/iJmdeipJ2VB29FUNR0AhH2AjF8pcgpgc4jC2pKgh4mIyaOKRsRvuWjunPpqQi/0IOtadP72azGWxGD7uqm5K6LLJ1PWzjZZeMAqB6wr/Idncm6NWZG90ttDWYyzWp65HB8RO1XrckYmZzMYVBPJhxfdkmEYLi879GqfnP2EcMDItNmx0R7Buv/ysQ3jIQLrBWAoTxkw9wDUAh5LOd4L0jQBQSYfNFYgWnc3Scc7XSAGgLafVawSk2F0eRzSAKnRNV6vC/OCKjzkFwEkYBVIvDJnUwcGlQRnNzourl9xdyR9yjIa+V4MweOSczLZYX6mHe9iHOMZBStwgew2dnvIMHm0O47vJD+ouqe+ypOA5/mS+5tSoQGDz5/nyEB+BfGQn7VxwGqbNSaZWQ+Oq4lGyo5w9oRgs9SVP/Ub+TQxOrPU6FAAzybsufkjGHq0AvazcmIApSSXvCW5HRiKIVTTF3spzfyS3f5jgeZiPIE/NCiOa3Y1WWiMwmYWpJIvnkjwX9fvaW5+5dbvADP8FQhE5t9Km+If6M/zCLIQ0eA+f+KhV04n11L9t7H0E9ytfe9KGzxVcDUICJj
 oGwIgNP9
 HPWiu0wo/I8UOqGJTHqW2z7MYXnw21h9Rz+WcZdQwh0Jb02tWwvmFyilTmgh8puBONS/8gEqSsIuaYeiX1Fjtlg60mMGxTD35jYLzwzpG9JGRgPsJAoIB2POwNLaenGeU/2IJjk050RbnehBhPuV4dSCS3QiyERpK0b7ctY+i/STR2khJ8T0VDLLGpfqF1JLLApC/cUA3DPRE8AqBtK4ajsUYzlNhDBXY65pV48XO0uLDSv/J4u8AU9Iax4Vo0nknXvS66gw+8I5tHmGxU7KxNJErq2odsRZAcYgK6JmhxfPeMFs9BirtNcCCfFBd+GwaX+sYiIcaE9OvBEM4DHLRqJtDUFcJo7khPgmjbNT9fRH0Ebx9veUnmpcc2+f2xbaHfV2ubuSGa0Q0Uu0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/17/26 14:32, Alexander Gordeev wrote:
> Hi All!
> 
> This RFC is a result the implementation of lazy MMU mode on s390 [1].
> 
> Heiko Carstens requested some mechanism that would rule out direct
> dereferencing of PTE pointers, which otherwise would bypass the per-
> cpu cache on s390 and lead to catastrophic results.
> 
> This is an attempt to introduce __ptent sparse attribute similar to
> __private, but to be applied only to pte_t type by architectures.
> When used with C=1 the modified sparse "dereference of PTE pointer"
> warning is emitted.
> 
> With using that new mechanism I was able to identify direct PTE
> pointer dereferences, which should not have existed after commit
> c33c794828f2 ("mm: ptep_get() conversion") (and its follow-ups).
> 
> In addition to ptep_get() and set_pte() accessors I suggest to
> introduce ptep_get_nopgtable() and set_pte_nopgtable() variants
> to use when a PTE pointer does not point to the page table, but
> rather to a copy of the PTE. These would allow dropping unnecessary
> checks on s390, but is already the case for folio_pte_batch_flags().
> 
> Patches 1,2 are independent from the sparse rework and are good to go AFAICT.
> Patch 3 is the required change to be coupled with the sparse rework below.
> Patch 4 is an example of how __ptent was implemented on s390.
> 
> I hesitate to post the sparse patch itself before the rework is is agreed,
> but I am CC-ing the sparse mailing list.

Usama is working on something bigger, whereby we introduce the concept of pte_t
and hw_pte_t in common code, and allow to decouple them on architectures that
really need (IOW that implement it in their arch code).

On architecture that decouple both types, the compiler will do the type checking
for us.

The prototype patches I saw looked pretty encouraging (at least for pte_t, pmd_t
is more involved).

There is some information here:

https://lore.kernel.org/r/6110202c-057b-4701-8c04-1a76ee7bb9ab@arm.com

And I'm sure Usama can share some more details with you to give you a better
idea if that would solve the problem for s390x as well.

-- 
Cheers,

David

