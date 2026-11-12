Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73FAD606A8B0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P3e+l8T0
Received: by kanga.kvack.org (Postfix)
	id 70F8F6B05BD; Thu, 12 Nov 2026 04:01:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0016B05BE; Thu, 12 Nov 2026 04:01:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587D26B05BF; Thu, 12 Nov 2026 04:01:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2879B6B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:01:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDB374030B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:01:19 +0000 (UTC)
X-FDA: 85425873078.21.839719C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id F0C76120005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:01:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P3e+l8T0;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474078;
	b=0SUdVH8SNg34mkMYJKsNfS8+xQVLrWNXk3gRkI2sQsBMGynLpO5ITRELUPevVPNJAoRkVZ
	03gvL9VQyO7uabdWjxfrfKvBcQ2Ggqt6S+erDZMXF9u2Up13W2Xfhwz9hlcTBhe6BAUV4N
	M5U4L18x4D1DcxOwjNIbtS3ukeDdtnk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P3e+l8T0;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ui5EsWi10MV5QskRl/qxkNOLjqI3UUc/3+p5XFeUbrc=;
	b=d2GNGzLuj1DDYvrWhYlGlG8Mm5qkm4jR1/9uf6CXA7uivZKM5yNcugqP+zZLKWyT4ug4gR
	BuLMiPkT2E0n0f5PARTOm5rR3/rWKcKhYtC70VFKLh20aN4RX/qD5MO9TRNDzRyU7EPw19
	cDP9i9G87DNjAWYI0fJ2P5Ij99lCObw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E335410D3;
	Thu, 12 Nov 2026 09:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DBB1F00A0A;
	Thu, 12 Nov 2026 09:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794474077;
	bh=Ui5EsWi10MV5QskRl/qxkNOLjqI3UUc/3+p5XFeUbrc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P3e+l8T0gWTQb/C7XKzRiBY8pIKQ9krHWSQey3gWmvT07gJb4AFbqD9UhUewo471g
	 XEY9QYW0g7nZRjYvUgpRE4T8D5lBHDPWr1XlwJrVi2olqY+EODn/0zsfm1wJ5y+67V
	 HhPF++bqEkrHBuiFXLNcOEmM5jajda3NTpqLT3qgQZ7HM7TX95ZOuTaUslLXHs2eW8
	 NSP+NG8fPY5Uw0/qUVBSbvHEy+LEWOYR+aAKHQKGY+Y1JTdkXJcB+7FPjUs6i4zScq
	 k6Rsb5kL5gMbQX1pnquucYeGPftg6vODKOs1CuK5fK2R2aLWz1PX1fZxwxlqMSat6y
	 6ck8qsAfMYUiw==
Message-ID: <6f5d77fe-213f-44d1-b5e5-551de03eb903@kernel.org>
Date: Thu, 12 Nov 2026 09:57:38 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] fs/proc/task_mmu: don't read young/dirty from a
 non-present PMD in smaps
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kernel-team@meta.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev
Cc: stable@vger.kernel.org
References: <20261111113904.650722-1-usama.arif@linux.dev>
 <20261111113904.650722-3-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261111113904.650722-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F0C76120005
X-Stat-Signature: yyzi7g5pd88m3d5indfhpzmghxi7txfa
X-Rspam-User: 
X-HE-Tag: 1794474077-915011
X-HE-Meta: U2FsdGVkX19FXIfL2JIDqlG7+XK6zUXw4qYNwZrViTq5oMDWB9X5xZTTGBjdzH+OCbkO+/iB2ItTzJG529VIaAlYNgdl/5CaERthkMMxo/d90QOcYVdfYshB/D4F1+QG7+ExoUM4M+1xNuIMI69jl8zyzm9BTcWIFW09RgKcESZTBUz5GSwPcrERn/dKa/c5P6H8GUw8h3YUK+xmTrntlZZ7cCw4BOjkaLKZ7OE9nymPLxsFeyovPGzClN8/yEuwg24ATVP+b5JCYU2t6nkHyxv5StdGefvHRvTEkXD+O94dCJuXftc0twkZdpKYpy08ayeNbXMTlZkDtw/eJmhWDjIt/z8Ol9EEpYqS8eCTj7R56h/2ua/OMZH4WObfZdzW399Y6N+NXhIT++2cGD/f4pQaG7osUhut3eKIwhIypo1ZOMd+Ew/X7KeA0RoSDsZYVQTCi8TLcvtq1nd3f5ZusJwxKpt2a70kis8wywCMb3kscuP00cjqSgee6Paf+JRILurVeRixUu7ji9UEhOcf1Bo31/TxdZPx8dm4SVT2kvbZ7M1egv6nO3cbvQUtv0BZa7b0UDbjQs3e9sSeMVM5vdKC3NKtChDfwO8zuMFyaoksc1LtSk+oaRFAhk9b4IE2azBwP2xo67MezXZH1nAGNk9j70NmG+E0z3O07TtqCBFthyMm6p9PON8vSjKtbv0VNE8Ou0Yxa1hjymCpw5kiUoytCSdB3ImpQXvusIuVx7dflVP4s2omoDQ1witkw6HcXwxWI1kQVY/GPXfV8KvvUe2SK1KwFUpjcfSjrIYHoeru+6lAtLcveWrY5PVx+Y4rqUZV2K5W0uslPQOlroQFj+/wsmPD2ZCaD+dTktakfmZFi65nQAkuwzvIxVatL3kBqPr62k2xd039KmjsQr2/C3spslP+8t5cP+gFQ0M68B+NHJSWMrC+/UnisZ5d0EM3dNs4eiP0MkDNzUshPLV
 n/dhYri0
 b79ttq80wTfsyTr9p7Omo3VFK9vSbceM0KZ5IE1uNVd3/o2rxI6NG0v+zs4CJdGE4WjkIpb+9MN8T+6qpcx6z3wxqMlS3g8fAIgBaD1WvDSse/19krCAB1TVwGUsK6vNN1CYfM8B9VVXF2SLjjmmIVUTJIIaOuoLv3rCHHVCDHDr3VQ35fhk68qoVdYwdQGEvSVdbATr6b+hDxJx7u4ofNNTE2tiE/Hhvjldc2MK4B5CG5Q5My9F21pPRVJbVAMnbfUryhpoUA22eNKSib4RF4L0K2GTbdtm1L/38q5d2vha5zr8hWuBIQCM6+NAcuSvyeRkw813yPqcO5S48d97BCsiyAuSDAZ09QubUNstdBG4BK0dEM3rmFfsgXjzk6rnI7t4wOWHP1EPxEIYRLfESqrdAHnVsS/CK+u2iAkXFEZV9iwo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 12:38, Usama Arif wrote:
> smaps_pmd_entry() passes pmd_young(*pmd) and pmd_dirty(*pmd) to
> smaps_account() for every PMD, including migration and device-private
> entries, where those bits hold part of the swap offset rather than
> accessed/dirty state. smaps_pte_entry() only reads them when the entry
> is present.
> 
> On x86_64 the offset is stored inverted across bits 9-58, which overlap
> _PAGE_SAVED_DIRTY, so pmd_dirty() returns garbage: a clean 2MB
> device-private mapping is accounted as 2048 kB dirty, and lazyfree
> accounting is suppressed. pgtable_64.h also warns that the hardware can
> set the accessed and dirty bits on non-present entries by mistake.
> 
> Only read the bits when the PMD is present.
> 
> Fixes: c94b6923fa0a ("/proc/PID/smaps: Add PMD migration entry parsing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

Yes, thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

