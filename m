Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83AA4606B3AD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=codeweavers.com header.i=@codeweavers.com header.a=rsa-sha256 header.s=fm2 header.b=AjoxTdgG;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Gj+EhfIr
Received: by kanga.kvack.org (Postfix)
	id 918516B0A55; Wed, 25 Nov 2026 10:42:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EEF56B0A56; Wed, 25 Nov 2026 10:42:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805446B0A57; Wed, 25 Nov 2026 10:42:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59B796B0A55
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:42:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E35A6160EC4
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:42:38 +0000 (UTC)
X-FDA: 85474058796.01.83C1EF6
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf03.hostedemail.com (Postfix) with ESMTP id A24A920008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:42:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=codeweavers.com header.s=fm2 header.b=AjoxTdgG;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="G j+EhfI";
	dmarc=pass (policy=reject) header.from=codeweavers.com;
	spf=pass (imf03.hostedemail.com: domain of pgofman@codeweavers.com designates 103.168.172.152 as permitted sender) smtp.mailfrom=pgofman@codeweavers.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795621356;
	b=i98O5Ew9qJaxS4/DJdsi2aLKrRUN7iha82oUzNARyq1awl+kkFhLYygVn3omtTBfDbgzTl
	A1G1kolumsPoo/qN0qB7ATcHZWabaUuFKyPQJysOZEzMcjMGRZqq7AkVxnWqhEAj97O0DU
	4u3ywHQ5iwNk/J1zCdVZvu6pVxKKIgU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795621356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2T/CNl+UqumwvNGn7wZeKbRuxVWx59FkRSs8vRgInCU=;
	b=fN39QEYkEe4JzvW6plLDzyNfRPeWIHiTX0vxahWi6wK3kyW6OJRvUAvPVIwmhW3j/dCPfn
	YQl5p7ua8xIsWb1LwzRWN0OX2pSfv+CkJboKCK+JYaIfFfvWqJrro7akXKB2zsTsFgzVDm
	O016q0zlhA6qh+oeR6LflCFcVUTTyFU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=codeweavers.com header.s=fm2 header.b=AjoxTdgG;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="G j+EhfI";
	dmarc=pass (policy=reject) header.from=codeweavers.com;
	spf=pass (imf03.hostedemail.com: domain of pgofman@codeweavers.com designates 103.168.172.152 as permitted sender) smtp.mailfrom=pgofman@codeweavers.com
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 227CA1400419
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:42:36 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Wed, 25 Nov 2026 10:42:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codeweavers.com;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1795621355; x=1795707755; bh=2T/CNl+UqumwvNGn7wZeKbRuxVWx59Fk
	RSs8vRgInCU=; b=AjoxTdgGPHaDL9l16VUtI4gx9tx7CQUl87yzskUeP0A64LDj
	WQjyUM66d20pTXoEVYZaGNBfKcIRyNIsgyZZCmSUotZE0A50M+DU4TO7PxJMqOrL
	+14QJbXmt4UFwA9JadchEVMth33IXQUsbdruKC8ZAIa8efH8wzKnRIj7oYzEI4Sk
	xjikiCGrGrg4rjmo4k8hgSNB0lnoz/BmD6f6vSylelje+R7sgHv141ddAj0KNoqd
	p1O9LAwLPSCjaYLD0eGWVuvTuZRHPdGsMI9Cbb9KCGMdEtWbz4p8L2lhP5phkqCL
	1VxEtEN/wvqjzN2BZVPTQF3TCCPzKwot2SNgqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795621355; x=
	1795707755; bh=2T/CNl+UqumwvNGn7wZeKbRuxVWx59FkRSs8vRgInCU=; b=G
	j+EhfIr9LLm6txXSplVxyNJkXsC4CCwc19fSErFnaVM2weJZ0BmtrOtJh6wbFmen
	ZvD5PyiIjn5zhxrOpiJpJDTvU34zNYo8fZzpK4uAIKTT7yo+wNkmy0d/H5tkMAeB
	9Z+2Q9xADOwvpZN6rqy5QI5l9VyCtxAgV364YqJU0lmgp61TrUg2netTQv0ewyeB
	wNXCk3+aI47Kw65e1YlOcWMdxQ/WPGZMgkQxGsX9lW1CG7jUJscOiQeFUCjxNyfz
	GPFJDAMSWYDYA0wsJWVjklam28cxj9IcCamuxG3xsVRDNF/vGnirjXSkFsFBmziJ
	OR+FdT9qsPzdAy1iftOsg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=codeweavers.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795621355; d=codeweavers.com;
	mf=PHBnb2ZtYW5AY29kZXdlYXZlcnMuY29tPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:Xxd32WsvoK5H0QUZbnrqmZyore9jnSYPU5p4uDETCJLzB8A
	AISqycsDC43OjuiEK/3rC4EmyG++uYuOfY96S7tbYWpdqwH1BpxZqQtZedN5lwN4
	Fsbu5E8AoGRNy3r/oNBNj8tRhZs326lSTi0fhxpYHO2zutRmpQlZeeU8WeZqTB4v
	sK3EiaUSH75qvbK2KNa6IwSfC9zjzbKcxftmPSk+Ltto4XN1EpW6kfmjbUGAyRMA
	Om4fuGfFlEzm3rjnwdAFZd2kCtvDy1Y8MAvFxzM9BigIHMjfaVJxW56qHzQPO49B
	AfQ8FedWADMiwgBkPpjGZY9riAFKkI63/FW6dVw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:cURZaRvm/M8WwMrBFfNYD1L7u23Qg1bJk6LkPT6yGKQ=:BN7VufvdK5J1/sbSPUTxr3OBpK0PKvBepcG2DpCD8Gg=;
X-ME-Sender: <xms:6gEHa1QAkayTti6HN0OFfKwQPGa1BPrrw7NsCd8Ycad6ZkTZlWtcag>
    <xme:6gEHaxbbbXleaagPBv9QS7P2HcxhSTLsTzSn4wvpUU9MelJhCxT3Q7ELLKiwKXWb3
    LN8PGyoyjXgZnAprTA6y9AsINUd9Y3trAn1CqLKD2WH4rKPQDXea53O>
X-ME-Received: <xmr:6gEHa6W6_cwg73WM5HPDf4C14jQG1HYUnno3zkvCX1BnvH5FVR6tuXe7MmuxUxG3er6N5g>
X-ME-Proxy-Cause: dmFkZTGjFUdAYxBm6lDleXbMn4poc217ZkkD9OM2CkIIK084tWBA7U1ZgeqN08eo6tVNuL
    r501i6BzagUXxew9r5JxbFRq4TIRdwnfQYxVWkm5ItSmC5YLFXaQUKe82FwnNqC2VxIZ+w
    l2e3a1oWHqatq4QS4gJPBFqY0gm8oudgxkmeM4oHS4hko6Fhoqr+yQH93UfiYf+DQyuLWe
    30QGi8b02LSuSsPSU2YbIgoRvqak0WoW5K3o/d3DQKLe3ouPDjA88fxBjCbYKEAddqKKTS
    ZaaLdAKckBujouTeX1OBIgaR/lKLovufedImVZlI/RtpI5pnABEtXXQqs6V0KRIeUEhEN3
    6VUfRlwJ7yxVYhG2HCcvYIOLMEewK79qNmI0Iqh/y/fK7Q09jB1WeiOfZIOfxLwOV6UYXc
    YjKWRlyn68x1eBAADUxE7O8T78YMMArUDfic/x93udRjiZklQlS3wUPEZutfREMIJ23HN8
    DomeXjXrM/MxUyG7NJcydROEmZIj+vdtTwWCznglKNrpSoqV1N4k6H9jWtYwSMA6Ef4yOa
    ZiHu4QFfTXmFAigjLWOytp7rdB4PAnEEuZj2du8t2nT3C/bqnxWUL7hOtiUEWLRWKivfTy
    +9NhWklXTBbUVT/IKK/IL3q/iGXHDYnbiR5JthHCYbR1D3mKOganPw6HcYHg
X-ME-Proxy: <xmx:6gEHa-WpWhNX6-A7HRJiJSbjiqLRGZ17LDLI03RPubv8V5Cfs8rkaQ>
    <xmx:6gEHa886zMrdApuIWSFxFqdr1gtuE0DCJwPYC5CKzpXYdMvqYVXghA>
    <xmx:6gEHa7oFMojoasLO2H-NHaF9fx3PvttC_wPpNZbLd9HoekjsEfMCZA>
    <xmx:6gEHa4c3qg0G6F9lADUgyJBcjO6u6kf8lx8F72n6rPx8hnI1cunh0g>
    <xmx:6wEHa3W51IMKQEfcQ47UTrm1c3gRInrKQQiTEbgBUlhm6XGxnozb0ZWT>
Feedback-ID: ie0f64b70:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 10:42:31 -0500 (EST)
Message-ID: <0308f0ef-9989-4a9b-aaa4-2a3169ac1f02@codeweavers.com>
Date: Wed, 25 Nov 2026 09:42:28 -0600
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: fix soft-dirty false positives in mprotect() of
 large folios
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Shivank Garg <shivankg@amd.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dev Jain <dev.jain@arm.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <emmir@google.com>,
 Andrei Vagin <avagin@gmail.com>, Bharata B Rao <bharata@amd.com>,
 Daniel Wade <danjwade95@gmail.com>, Yin Tirui <yintirui@gmail.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 wine-devel <wine-devel@winehq.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261125-b4-mm-soft-dirty-fixes-v1-0-538e3cdb618c@amd.com>
 <380e029a-2d9a-43ee-9048-c4b490c11f41@kernel.org>
Content-Language: en-GB
From: Paul Gofman <pgofman@codeweavers.com>
In-Reply-To: <380e029a-2d9a-43ee-9048-c4b490c11f41@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mjpmmbfi5w8fxjqzsc1uauhs3ic7wdg9
X-Rspamd-Queue-Id: A24A920008
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795621356-6349
X-HE-Meta: U2FsdGVkX1+r53HhUY6rq4uRhIZ3RuYHKJkVUbOf2DiF3wXiVDofVIn216sQW0Re1B72QKvRTBH7TxH3U1HccYcbJQRSBFS4aJoeX9F+Ojiv003MdOJTnYfY4En8oe0PiQhmupLb4JFNDpdQAUEALJiRO2W3FAfB69HPINQenUAQA31BvpvF2JvyWlDLUlZgtGdzcHZPwf/JgJX85niTZOuwGnmybLea/yflOJA4aJwn/MvLYGYdfgiP+7IZ9GOqm6W2uihSHjzOgd/8UGjh1g1RzZiKe6qn77uG09gCLEk1cQK1Iv6m8DdzfXxvyE6+gXnaDmG+qBNVTnYFOpGhPt3uoS5CQkQd327a4XAfml5+PLScMv2SSl6bFggAYpItwDBuUUl/TctN4Cq1kLck/42thPJwiS/t9WThIn33zauuUcmvqdi2rfB9tnsK3TgwTOHJPXr846L1IVyo3GVHS+lw/EGNhWXIUHwpfL1FNo7gl8O4FnS3PZVQFjEFl/YhDhZueuaLzj0OApoF/9mWK8K+F4wF9zOkA4CPu1d8aEexc1I5Yk0dlL6M4esi5ywVS67zLaDB0OueS3W4TQiEPvahFh/crswMNeD0/B05V6HeblyKY6qnBAufJfn37lzWwSIagLps9Jm74Dbhp63nlEK8geUqG2miArCwkWXFG0jX/J8w077Pfo40R0Tv4wu8blxA93d4trGrPBhs7eZL26bablQ3QhzoZoYEK+EfDTIFGoRmKGNlEffUT7If2vTzRKwhISoORC2TH5PjEnLhTETaf3BKZXbXPP4DD3isW5SdpZ08ATfrvKed7/HpjUOakxvg5Uyueu+zNN/EW4hJLtm7gb1AIN4Fp3lr6gUA3hAmPepadbSmommYQN2rBDboEOT4qvK3siEsG1PGpkex7ir5k8eWmRgkpkfmXXm1F590djVo8KMH8ffiy7Yx+XdQxM/xqG9rkow0ODuM3+R
 UIiCig6f
 bS2c97G1deg14/ShLeniT3ABBBi0GGvvFTtyYxleZRHl34OFascG8t7iE2bND4g1Nttgjj/q43Gk1cr5QQEAXAl78Yhm1aLBeMEghLEPRbyHCN1kKshCRkOheD31XXx/o8s/wX0LloKIzypADqrtuAsfrFIoGJ7FOjaEoFQ3G7oHZwavS6glntMNxPZRUhLMvcd/YywHTyZh35ogbnFqelI++1Xt7HOuG0+oepqT3aNsm/vAusRMoFTRKrsmI35QFcfluj8wxiYHWW1f1Iiayjgog0y5bZQxxA6XAT0JEifCgNCgEdIjOPMvv8SM5iAddV4U7dXjVwaapVjlxCq6QWSqQeKtonDssS7E5TbdLt0rRr9UOVXLET0x1HdHXCHm8V3qTNdL/DOoq0UHVGewvVa23xVcuyxbpENSfJbFkLeNoZ0IvK4kBayn4Q21zWrVxoID7O/GTqv2AoNSsQHCcnwKyRQz8y8YoauBGGXFb+lsczdk0KukqXQ9cYmMj9+lmj8wK7/gQM3DqjcEhnpwtceuG9885DsSDNO0uB3KKIfT/4wsWMf6eDw5huCfbITDNBHBntyj8oO9nijJ7po3FLIfrbCVx1RMq501tpILyiIxbn1qNGYWRHKBKgJ7PEVxs3spiSWhelKD4oOQiMNYJ5QAUdZZB4YTqEPtWXMVYejW3DNE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 07:43, David Hildenbrand (Arm) wrote:
> On 11/25/26 14:32, Shivank Garg wrote:
>> mprotect() handles the PTEs of a large folio as one batch, and marks the
>> whole batch dirty with pte_mkdirty() if any of its PTEs is dirty.  On
>> x86, powerpc, riscv and s390, pte_mkdirty() also sets the soft-dirty
>> bit, so after clear_refs, mprotect() marks unwritten pages soft-dirty.
>> With 64K mTHP on x86-64, all 240 unwritten pages of a 1MiB region are
>> reported soft-dirty; with my fix, none are.
> Why do we care? Just over-indicate soft-dirty. It's valid, and the whole feature
> is full of holes and buggy as hell.
>
Do I understand correctly that these issues only affect the old soft 
dirty feature and not UFFD WP async (UFFD_FEATURE_WP_ASYNC)? 
Over-indicating written pages with the newer UFFD support is not 
expected and Wine usage of the feature requires that. But I guess it is 
not what is concerned here?


