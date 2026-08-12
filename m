Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C204C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471CE6B00E1; Wed, 12 Aug 2026 07:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448EC6B0145; Wed, 12 Aug 2026 07:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33ADD6B0146; Wed, 12 Aug 2026 07:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FDDC6B00E1
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:03:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C307802A9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:03:52 +0000 (UTC)
X-FDA: 85092332304.07.720254B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 48A162000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:03:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g+VTxEFC;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786532630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSfl6FO5TgTynyqKLLvS/Rpyer3P417NsRPMdDTQcEQ=;
	b=r2OD9PNCgCq4DSglcsmZzpzyweEvmZCthShGzxKbSaSR1bTNMoWm9TSJRtPBXUoYQ5l65s
	OXEX5pj+rTBZBkfZSQxMyByu1kcnpumPMRhHQK3TD3IfUW+IyQgXKfzJkeq/bl5uWDubZu
	wUbSonmxvetyV3KCNy3v04nVt9wSYcQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g+VTxEFC;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786532630;
	b=Cl2hDrgm7Eamq7g9yflD5PwELf05o3fkCrkRN7PGEpm73UzZAh7R9FaKIplm8QvbRB5eE+
	Xi4LrmOKep0KHvlqyYwpnPTNa93faIFY0Vv/Grm7yQ7KFgMHDUPcXdZ0Ulbn8cX2UivpZn
	6JyCex01RGZTWZAUkrWaYzYOwqR9ZqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7247540781;
	Wed, 12 Aug 2026 11:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1209F1F000E9;
	Wed, 12 Aug 2026 11:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786532629;
	bh=lSfl6FO5TgTynyqKLLvS/Rpyer3P417NsRPMdDTQcEQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=g+VTxEFC7LgOdvykX9xewDfRpD/O/lq5BU5xoEF6ouwQ8lF1gGNsURm+eX7md6F0a
	 vJ+yU1rKaW/0sPyuMcHlANbPiA4Nuj07Q7d3hi6FR+c3DXPwEY1w4NxdOCrdhBa/El
	 zy1sWCfn50C6/0UUZqey1bZkBq7Kc9HPWJwjSfMbBn02r4qB9OJn5BzLHmqVrKeNqF
	 Y0k79yd+/bRga4HHz70t/dfL5F5Kp39fGtesBp1dQynHdxtUYayrcAqci79g1xPxgo
	 p7VrczjwjbrVNkuEIsvWcjM0Zo8DFvXc5JFqniHaRKHVBt2K0deAeqD4xDds4STK5B
	 1EDHQ3BTDX1HQ==
Message-ID: <b7238caa-cc47-4811-a395-4784350ba599@kernel.org>
Date: Wed, 12 Aug 2026 13:03:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: fail the fault on a malformed swap entry instead
 of retrying it
To: Pedro Falcato <pfalcato@suse.de>, Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260810-swap-v1-0-375ef0767206@debian.org>
 <20260810-swap-v1-3-375ef0767206@debian.org> <anxRBd_LJaHmtzDS@pedro-suse>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anxRBd_LJaHmtzDS@pedro-suse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48A162000B
X-Stat-Signature: rnnojrd77txxygn4ohw96oo1oucsb4it
X-Rspam-User: 
X-HE-Tag: 1786532630-667043
X-HE-Meta: U2FsdGVkX18PekR9/SNGO/HCEZuB+gC2Kr5eyclgQUY3Ewsva8jN1o/uY+DomZ97J9bzSm3Rgf/sPffywnyWeJRkubcvLKk8dugICYL/b4Ue2iEV0i+611161XLp5qYI7P+t4ncVhqJua+k6sVKW20HvWb6yXhwV3TsxfDw3djWPY32vbRvUIFz+pr7WWsFc4YqLKl/x/VfvajlvmxmbJIgm7Ez4keuA+ZOvnOQ3Dy7PTA9/qZmXOWY1tnrqJK0k3+WUDkw85u2AsRmXp/MA9f9diYn26RNYHB73BUX3+nnYddWV16p9qKRLtqLf+f3y+DJILtN7OGp7DZJZ1/t/NSWCJgrHuiGgNDV/oGRL0kmYn3NpoV7JB/dOfVjzcKT255xmBxgTkMkKQefvyHGx2D+q20gnyLaDd5fh45ITgW4nMIydKJKdoDm2CavRv41DsPtVljLS6KmXMXgFofFflsrWcXk1512/UYQ8M0V9fzSIvt/biZs8mpxUqMVccOV6Dnq2ijDCwYIEa1eMjD7ARUnqiRx8v79LFUzccaUHzhTeEna2jdSHTz+A4JIr4Y/Ns2FT++4GRFHeyzW9JYhT6y7HgsCaOqRvm3DW1hJTEB1q+9+omtwDQ2Iaosrkr/SsoWNAVjss1mZYpExtp8aaitxdqNG497L2IqIWEGuH+0JSM83g++/KRc1s8VBHYMbmAFaS0Vw6mA9t83EDs2XNIBO/5bgZXNcfL94i4ZBTS77xUk+m4YzGanz906C0fWBw65Mu8fr/wMN6hQIGP5MWmzWdriTEsB+/13s66vX5cCVPV066kQfdtlRBXUg4ty239CNpXWeM0s/8IMl7WORXjRv0mA97hh5kDnCoHWYpa+yDwqKUX245wLhDeBe56BIb2hXy7ACMaDJanrK/enTgDb7eBZuz003tqKEQ9I8AW+JUyJwHHhE8chYvJXzdyErQpnefwaqyjsjo2gzlv5Y
 hUvDBrmR
 SrDbBm95hpvTFfx4KTeCxWOR5MEgNWaOp+EJA1PFnAaTunyelg7fNznoob4sHg8Me2dakWLuZJKJ8i2DBkw8q1a7Wzxvm0cUnh0PVgiXs6M+mDRT4cbjhvket3xNqgKm0FJE504gFa9UM9lN7XxtLzu8acetP+jY9nliyv97mwaoxbUUwL7cis5hJjpIfj7qBjJ/FxUooQaED++AB72/4jyLOeVpqW0QhOYntWev7CZbAy2iBKGUEBAsp5niKe4KY2iv/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/26 12:59, Pedro Falcato wrote:
> On Mon, Aug 10, 2026 at 09:26:51AM -0700, Breno Leitao wrote:
>> do_swap_page() returns 0 when get_swap_device() fails, which the fault
>> handler reads as "handled". For an entry that can never become valid
>> the retry takes the same fault again, so the thread spins until it is
>> killed.
>>
>> Return VM_FAULT_SIGBUS for a malformed entry, as the sibling arm
>> already does for an unrecognised non-swap entry. A NULL return still
>> means swapoff, which is still worth retrying.
> 
> What kind of SIGBUS do you get from this? as in the si_code. Out of all
> the options
> 
> #define BUS_ADRALN	1	/* invalid address alignment */
> #define BUS_ADRERR	2	/* non-existent physical address */
> #define BUS_OBJERR	3	/* object specific hardware error */
> /* hardware memory error consumed on a machine check: action required */
> #define BUS_MCEERR_AR	4
> /* hardware memory error detected in process but not consumed: action optional*/
> #define BUS_MCEERR_AO	5
> 
> I would say this would fit none of them. The default (AFAICT) would be
> BUS_ADRERR, and I think that one is quite overloaded with meaning (namely,
> with regards to memory-mapped IO past EOF, or EIO on file IO). I wouldn't
> love to also use it for this, IMO.

Note that what is discussed here that should usually happen unless kernel bug.
So I don't think we have to worry about the details here, really.

It's similar to the VM_FAULT_SIGBUS handling earlier in the function after the
print_bad_pte().

-- 
Cheers,

David

