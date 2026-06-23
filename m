Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16010CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 04:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF8F6B0088; Tue, 23 Jun 2026 00:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1276B008A; Tue, 23 Jun 2026 00:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8EC56B008C; Tue, 23 Jun 2026 00:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE9C6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:22:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF4031A03B4
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:22:51 +0000 (UTC)
X-FDA: 84909881742.26.E453234
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id 18B8B40005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:22:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Fa1+/U02";
	spf=pass (imf11.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782188570;
	b=AkNZHRj7p6crbPIW9nH0oZZuYTiY6nv7iW8p4z0AzFMDGGIYkGFZGF/HgarZCW8D1qJAwY
	SO+8vuUJQdGhRkSiY71Y8PNt0GbOjVvEusSzUFSziPOFbGfazkeI+d14uutExRQ1oLj/K2
	dHpmj2k63p8VGqMAy1zTcaZ1qfQGhik=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782188570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iCeZzcSVN670PFFl9OXDzKKPTpZS94DK0FINkgJfL0o=;
	b=sih2TA/6KaNI/MiVuSOlrOcth1Ewi1dhu60zFJhIxRGf+uHbNzvH/zC5pdZITG/lE+/PzJ
	R0Epc2yg0WAXR2FjyFJnm4cxKr12wzPkwmhsaRTMdcJtZjrNlEkQTGiNqMEoDqxsAiNuZw
	D+UHLpqgiyCqwc/pWeL0AUD3L9/6OSY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Fa1+/U02";
	spf=pass (imf11.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-37c8e7c8137so2959800a91.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782188569; x=1782793369; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iCeZzcSVN670PFFl9OXDzKKPTpZS94DK0FINkgJfL0o=;
        b=Fa1+/U02TlYe8aj9qRXcedxofKra4nU4mzcMSZMBu+27vIlVZvF+WGJ7yhV6EB/Umr
         55c00Ak/4IQHYlK6gW1dXNITL3OsjrY+iv/DxphgfX4TbGAbtn+8y4bkefHCSZuId3Vy
         ekp10k9iILjClBEPXoCUvtsdOQNb3BhQuXIoim+1APWqFHrWstN/Ows/ZZ5VX6ARg7rM
         NSiOHLy8BNZpEFws97+KNNxKfHaTorvz7/M+c60LmauSPP7ll9HW7FC3NWLSMfE7neLr
         o7klF26NL7bvdscIsfaFTCV9d9VpfYqmQdFcL6CH3G0WG2Kk3LPPhsjwqT3t7Pod+2kh
         Z5jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782188569; x=1782793369;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iCeZzcSVN670PFFl9OXDzKKPTpZS94DK0FINkgJfL0o=;
        b=oa4iYdi5A5kSOSf3K+vY3JmNjs0cSe5AIPUssG453X6/i7n+fnkNpvBk1UA5n/hKLV
         x17ntUne2aSw1oe/tIYzC+b8OkgNWaWIZvrLVGDvpYqqyiXijH9XiIAuSW1MCLpflJd6
         FoSHZHYfvm9tzX2xrjJg9amCTO6h7y9gv+Ub/ieDx0P49AA+63TefBvtio7QakmYKvRL
         piHrtnuElEhEjdMjbz/jDN8JNWatgDYOKV+qyl4BEirrUBqLLU5lMLW8r8j0k1YxRevM
         Glyu0tB0mvTyYW1M8/F4O9wWqPA67YPhCeptsmeK32Du4usK42HUbuPDXC0PiUFSZAaN
         Lc5g==
X-Gm-Message-State: AOJu0YyaGcS4epXIrKQ8m0bV8kk07UCd+7RhutADn/J7E2ZAS3mxCi3T
	zEnqkjF0f2HSD8cjxM9VA3C51h90pjIeQGel9/YC8S/uih6h56k6jR4j
X-Gm-Gg: AfdE7ckqmWW5plZtD2kJhob5dFMJY8FyEYPRuj2WL1s+jfR3gXXpt9QjPvH0iyyFUTK
	szla6uCoeyVhqRDcijfFvuEIWSgTd1PrCqx2p7Z2228pXV9GK5pXAVhBs9ADKxD74/0gH2iE6uS
	HPUiD4CKgyqI1iVaq3kyCXqOmOZdr0Zzq0YFcSyJ0t/82xM3myWbfUJmAaMuZ6W74DwoTYTs2fX
	m589cLoQdv/MmFKMTXiSzoQua9eIInntT7M9m6S4NLw/7lyM8RGT/pFTMen/7WcDOWaYy0tw57F
	8cKOfFSTqvQwZWEo0UrtZsUsTNRf4xZaDAS9A2wx/XnSXeqD8j2lpdldr/boQVz5s32/GsFs6uq
	uuQIRgOaVLBUIvWVuxgoQ06IUhD6eYbkkXKAEULTOytrHeDfSI1DMckq5tkDKDFfSkCkpHdonSM
	9BCbKESwZT02ZgKVs=
X-Received: by 2002:a17:90b:5346:b0:36d:5dbe:2a0d with SMTP id 98e67ed59e1d1-37dd0d30e19mr1352554a91.7.1782188568802;
        Mon, 22 Jun 2026 21:22:48 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37d1536b541sm11397460a91.1.2026.06.22.21.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 21:22:47 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v4 1/3] mm, swap: make SWAPFILE_CLUSTER runtime
In-Reply-To: <CAGsJ_4y++uh_4Dqso-fafywFCAvTLd-JSRJ8RZ6HvNLDkaLUJA@mail.gmail.com>
Date: Tue, 23 Jun 2026 09:41:48 +0530
Message-ID: <4iityjy3.ritesh.list@gmail.com>
References: <cover.1781843449.git.ritesh.list@gmail.com> <e519e98f51be2d310367e39df0935da79001e535.1781843449.git.ritesh.list@gmail.com> <CAGsJ_4y++uh_4Dqso-fafywFCAvTLd-JSRJ8RZ6HvNLDkaLUJA@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dhb6ys33oiiiqi67jsu3tj33khbsfcne
X-Rspamd-Queue-Id: 18B8B40005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782188569-664920
X-HE-Meta: U2FsdGVkX18YJ6cBe2sZyygXWbjr11BDQ5jRWKg6QKiLCW7/o9M5GbhvCd67TPkGAr+L6/aWsbnSZPGlXVVPN67TXiH/vw4LNZAExYMJvStn/86WLshMAyAAzVeoxeO1K9LhWWGt98wi3rrRpzkOPKcLIFcRoJeH/fnwiGW/TKxDZ94tXKVvz4scLgnYk5y2VvlC8H0rYVPpWDzwpibHovRWp+a6Ilg3ZzQEFCSA3hJMk8L2OSnsWj+le5kWFKNd8XEqYRy6k8Ye+Od0cfCObBsOfOziPTxbVCDovWSCx2ycDpdQcDLKy2OKq6hdt8jQz9Ryr3yRWobXWawcu2X3oDRMHyT8C8r4Dssb0EzNffgMR27z3kVXM1fCAuPKIiz5XrDiihvrOG+LnIH0e07sCVVpL+v4MPeAEnt5XIbeFpyKSPZiTECtcZTmrVjhtFX7tFjvOeLS8pfxoUo7QmSVGhVFWLNRjOSkJdY6uumkV9hP1QMmFsQYLqTXZATQMHkhOxDSt3ieWLbrFOVzpsWplNZjHDV6fAargQYC8zZysVtzqfgxHUlY6UY59fl4Sl+WZ7nqvReirCf/22dlbbxtVLgtINCkdDH8QvEKgcDBFjZ8HjlUYfiGxDp/xfMsc5lYg02TNw9yUNR2jpHqDIZYuYto1sVH0/sgzD4X3g9LEAAgZtkut11HC0r8sInb46elt4hlgohOhgbWSVpTg5oqscU9eoPXPdGjHDnWHT5/n59s61uDxf7LKM/nxY5DoXQacC6LodXiSCb8KqK+1xWEUl36rsu6Z21DtAmO0wRx501MjJLRQBk4ERdJrbK4H6wDBT9k0306CDzQ7XkDGFv04kMbsltHtgerkMu6aWDulcoPI3CYj/rbv3DDHKGDOYlSU3RksOYQz0HCWfHTNytqp/Jsjv9gnly8Q+XrSRE6Vl7GoNm7kWA8G006dLJaeRT9WMLq5NgAlIMJ40/cGp5
 rpc2VotP
 /IhWuHE2ftcRxmRsZhxMv6CnHHwW1K1eDS/tRraPKPq7zEn6To5dgtkQOxa3BhPv670t86tnYZXsS96GLm/qAZD6agopMY7Olx3Rv0g7uqeJsrJz1ioumXBYMRnjYpvC3+bm7fsb6D0qg9hpkl+if6DbGV4b8SnpgJoolfjcHR06F+XhAAyQojv6AlZaEcccRxYdbYkc6r7dEDbglMGcLUEDGbUvDly5yVo9/dt6JAim+EF7DEuAlLqnfmPPiW919yEoKaWDb1aX9TJd4AjvlHrc1jgcl7+7HVjHSTZv2PyjAKmuniL87MSbCw4zpd9osWXGjLrn+usC2HF0aNMjlCMyamoUX0RngRtRERDoelm5ltTwU8GvpDlq/McfwLNWZGYoPwhm1C5KPfyRwvjXX8PxvUlC31a2dKN3pr25qVhDVmGeoUWCo7QPmdm6zONYFdGKgqXc7SWgeD9OiYgg1q0svrrgZVmJHAmD2Jw42uhQoYgGYVr4/TXICquOnhKsaOb/SAFE19nnW3JPeda+tp5+t2H9CwTdqSjBPq5Hxw499fZN7sv/y4F4cWaU2W3sISjLpNIqd5l1rkR5n1imS2tNKog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <baohua@kernel.org> writes:

> On Fri, Jun 19, 2026 at 12:41 PM Ritesh Harjani (IBM)
> <ritesh.list@gmail.com> wrote:
>>
>> On PowerPC Book3S64, MMU is selected at runtime, so macros like
>> PMD_SHIFT are effectively runtime variables in the Book3S64 code. THP
>
> Not an expert on Book3S64—could you explain the runtime variables in
> more detail? Does enabling THP_SWAP on PowerPC cause any build issues?
>

yes, build issues. We cannot declare array sizes by using runtime
variables. That's what this patch series fixes.

>> swap code uses these macros to size some of its array data structures
>> based on PMD_ORDER e.g. SWAPFILE_CLUSTER macro is used for this very
>> purpose.
>> Hence this patch makes the users of SWAPFILE_CLUSTER to use this macro value at
>> runtime and also modifies swap_table and swap_memcg_table which were earlier
>> using this macro for defining the number of table entries.
>>
>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> ---
>>  mm/swap_table.h |  6 ++----
>>  mm/swapfile.c   | 17 ++++++++++++-----
>>  2 files changed, 14 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/swap_table.h b/mm/swap_table.h
>> index e6613e62f8d0..90e2a7852300 100644
>> --- a/mm/swap_table.h
>> +++ b/mm/swap_table.h
>> @@ -8,16 +8,14 @@
>>
>>  /* A typical flat array in each cluster as swap table */
>>  struct swap_table {
>> -       atomic_long_t entries[SWAPFILE_CLUSTER];
>> +       DECLARE_FLEX_ARRAY(atomic_long_t, entries);
>>  };
>>
>>  /* For storing memcg private id */
>>  struct swap_memcg_table {
>> -       unsigned short id[SWAPFILE_CLUSTER];
>> +       DECLARE_FLEX_ARRAY(unsigned short, id);
>>  };
>>
>> -#define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
>> -
>>  /*
>>   * A swap table entry represents the status of a swap slot on a swap
>>   * (physical or virtual) device. The swap table in each cluster is a
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index 78b49b0658ad..4bf11c5b87eb 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -129,6 +129,8 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
>>         .lock = INIT_LOCAL_LOCK(),
>>  };
>>
>> +static bool swap_table_use_page __ro_after_init;
>
> Does a static key help here?

That IMO won't give much benefit, given the allocation by either kmem or
alloc pages, anyway dominates the cost. Also I believe this is exactly
the usecase where branch predictor helps signficantly and reliably given
the variable is ro_after_init.

>
> Best Regards
> Barry

Thanks Barry for looking into this.

-ritesh

