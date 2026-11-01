Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2DF60A2614
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 18:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MvXR4gxh
Received: by kanga.kvack.org (Postfix)
	id 2EC3D6B05B4; Sun,  1 Nov 2026 13:03:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3C56B05B6; Sun,  1 Nov 2026 13:03:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3596B05B7; Sun,  1 Nov 2026 13:03:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F17386B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:03:15 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D5E6A0A8F
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:03:15 +0000 (UTC)
X-FDA: 85387321950.23.228B8B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D030EA0003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:03:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MvXR4gxh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793556193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7mhxiZNhkkdLt3oC4RT7kchnbf+mH0SO2hpYKZyskw8=;
	b=pVJIXMRD9FhYs6wh5Z+WaH1sOtu5Iy8jQhL5lV2t+SwEQwx0rLmpEh5GI7IJZiBGKu6tub
	4RRSqBnvm5NUKD04njflStXWL7cjPCgGfGHn9XqRpOBzPrnMAdoJSWPzH9qXV0olvZ0GQi
	HTB7XRzRinFajQlu15/7VRQZFQD2zYk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MvXR4gxh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793556193;
	b=D7qYI187OsbIl68TAJscAvuH8vkx5KYyeCe5VrIDLlTC/JY3dMLG1Z0MGUT4UCgubip9WE
	ZQlE0coM1BbZWfjgTK5mJXh1r+36Ctwg2NYnx38HA2DN5H2h1yE9LAsSwGg81fXd+IrTPM
	YW6c9OSrskahva1khjPVcJMVtFtLkyg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FA19601FB;
	Sun,  1 Nov 2026 18:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C881F000C1;
	Sun,  1 Nov 2026 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793556193;
	bh=7mhxiZNhkkdLt3oC4RT7kchnbf+mH0SO2hpYKZyskw8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MvXR4gxhOU3vw4FzvT9CnPA5agFpVNsjgAycsevmiTUy5qF1pmyHNG24cI/9DvY58
	 qjQ1K3AAF2CLMULaRFH2rP29YUCbUBW1GSXYw1M/q6SUu6UbRFQwKIunNMEI/IWmBm
	 jb/b7ZHvGJ+Mz2DEMSfL8B88Jw54YgcgmPa2Hdk5Z08l2PLprqCfp5dQnmkWw8qRz5
	 nagMwvEdGs/dVcR2uwKCSTv4UMS6UDPe8SFsJPYQNne6zxJcFEBVyzCq65vupn8qdf
	 DsBmYA3LjbuQTUFeXLkc8QR6p6jcIlNzpzp03UFF3ycMdrDVk82DUhTPkB5Y2CNoee
	 fJgDIpM0FyvXQ==
Message-ID: <e1e54f29-6c06-4e81-b310-d6a10114720f@kernel.org>
Date: Sun, 1 Nov 2026 19:03:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: Factor __pfn_valid() out of pfn_valid()
To: vrilutza@gmail.com, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Alexander Potapenko <glider@google.com>,
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>
Cc: Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Ilya Leoshkevich <iii@linux.ibm.com>
References: <20261101-kmsan-serie-v2-0-f97f66dc57ef@gmail.com>
 <20261101-kmsan-serie-v2-3-f97f66dc57ef@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261101-kmsan-serie-v2-3-f97f66dc57ef@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D030EA0003
X-Stat-Signature: bnrn6r7maxwbdbjpyehkaitiordd1snu
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793556193-972243
X-HE-Meta: U2FsdGVkX18gJUyJLqpIbB0Q+YDZ2Endy58UFtkNrYSbsskXlQm7P7Ot58nVy/1VWrcoPGlRH8FdUfHC+Iu0iGW5QxluspVixdOS7HEcRkMfGaNIH6LPVcVrvWFpE6BIPVcaC0PyGnEUz8VX1g+itKl2VFlMWrfhpzn99BwsrKeYzWkWb3lXO8Ev2YfUF+pACu7TJvcVNBSmcQnny2Esrc9acBoPipdrZ32Aa0laM0d5wDhZjN0y2aSkSAgrj/haNOoB5VINCWVT1j+PSL7sMO3aSnrkgoPHj5PQSfmgto7AwE4Cv2FwZnVu7XkCbkURx0vHPlW3FMWBM0sucgMT4xqSZer+PagLMRWviKGfduwNnA+QjTtte1feFLkD33XHzNo/FZP4GnGr3+VVJDMHAJLRR24Nm85IVFmP61EWQQaDlFmgTV1D/QcKdP4OWKu1o2JjZ8PYu9W0lT8GOz/W5rV9eYvxBi9kGx57viM0a0ZfGZUzdDJDgsH8M5WJBVEwaGS/PZZPDyhPW7/lQ4C0y17MTEYm3G7oUtWFYgAUgv6FYOaeFgnMYnL0SI7Cpr6EJGJGt7N11qXyb9hjdCCiE1kvVrJXMHNWtTKoA8+PgfExmmFgPB1mEiL6Rp7SitrUm2YRz7pCyeeBugbwFk/Bbbisk+qM7/DoVxltKyklZmEa+jcvycXBsAhqF53sMTQjNNRRD5exaIO0gMaxkrPl6FoUp68okkMKVXpAiUKfiOvH1H88j6P0U6lDxbvaAAx5c77+GWB/5IXt5lXTeRfsJvrQbD3DbSfehvtO5+aDMj6twwrM3CyheikAhR08hA2wxCaG+G2FpOOE2dTmcvTbYwuw4zjKjuZktCkcbm2gxziuVQVawyOVNWyjWKFQWszk4nF8wjUswKT8DfA2zM+0d8k92WwqyqgHberGnJARRxwvCqhmcO7JaHE7f6ETqsmJkqYTitekfD/+wxqv4Wi
 u24MUX0f
 BVo5me8nUChBukBdutzEa4X6O2R1Dvmp3icFtAHLJlrQhGmilfWCwfigmJow8wdTsNAuqi06YwtPkgDMr6HQgPQnaB+Oj5azil7fOlcICcly0zhtuhbn9lJt2nTzWU1rdL/LNOiIdB+WedUWHkhxyOjrc8kubKRfYpzcLWWRmiaBhV850rH/AFaseYm/WST86qJIXYFasySrim2wtD8YOYiiw326i70qziEn8V1vyQKoeF14hl0llQkyOY3czEdeMvYjymngo3VIlT1bkWI72ZelvUe5ipNUhSRQIwLfILExDQdSdrhpN33hTLIjdiIgfaN2R9NrlgXNhf5VzlW2fuiQmJsS1xa+PyKX/wx0epnfA/nZ5P8BgdeAB1hgjmk844+AO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/1/26 18:04, Viorel Cernateanu via B4 Relay wrote:
> From: Viorel Cernateanu <vrilutza@gmail.com>
> 
> KMSAN needs to validate a PFN during metadata lookup without entering
> instrumented code. Calling pfn_valid() also calls
> rcu_read_lock_sched(), which can enter instrumented code and recurse
> into the metadata lookup.
> 
> Extract the PFN checks into __pfn_valid(), whose caller must already
> be in an RCU-sched read-side critical section. Keep pfn_valid() as
> the wrapper that acquires and releases that protection.
> 
> This lets KMSAN reuse the existing PFN validation while providing
> the required protection without instrumented helpers.
> 
> The wrapper now also holds the RCU-sched read lock during the
> initial range checks, which previously ran before acquiring it.
> 
> Suggested-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Viorel Cernateanu <vrilutza@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

