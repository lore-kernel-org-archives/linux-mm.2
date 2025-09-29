Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BC2CCAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 07:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72BC78E002C; Mon, 29 Sep 2025 03:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC788E0002; Mon, 29 Sep 2025 03:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2518E002C; Mon, 29 Sep 2025 03:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8B48E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:54:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10CD8580CB
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:54:25 +0000 (UTC)
X-FDA: 83941525290.04.161B99E
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3059E20002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:54:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="lbzm/jCo";
	spf=pass (imf13.hostedemail.com: domain of wuyifeng10@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wuyifeng10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759132463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpcKd5YxcnzPWub1c59hP9DnfaaEVNC8mAfOWVNolfE=;
	b=oWb+NDCTyu/IPdfiA6YzcwdLBTvVRU19sgxcQgxQq2XaZhahvQ2iNWgcBPUf+kxeSd/Yt/
	PJc2uX4WwPPqvsc+VxVKO0IcvbLVEWdxj5BRMJ06tLYvEd6j7UizesJqGmCJ9ADk2n5h1Q
	gqp7yt4goQOwM2a70EwdQdCfaNUA04Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759132463; a=rsa-sha256;
	cv=none;
	b=7DOhUdArlTfF3nypnuK/8U01O5wg4ARTk2MJ9Lf+Pr/7UmJCeQMmNFuQEOso4uZ7pDd+e8
	L2rjpe3fYCYb0Ar2/S5hs/ABu7Tsb1QYWVJhqe//R5ePRZ2Q/OTVXtdCA67nPQx9Ujk+kc
	2bTRtMrY1WMz+iJxCGtyL2WQPv1oSx8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="lbzm/jCo";
	spf=pass (imf13.hostedemail.com: domain of wuyifeng10@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wuyifeng10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XpcKd5YxcnzPWub1c59hP9DnfaaEVNC8mAfOWVNolfE=;
	b=lbzm/jCojxGm+tuh7DX3HzENiFf8e++p+7SXz1E4lzwOh3RHvJPzjfaIIXEF/qk6l3ggu7zVr
	ZdGjtQxyCtWW/XtMQy5Dbs4MENoU6OiRJgh724I9iZlcmL3AbPvAB4vFIFoOEL7c0MaJdSjlk6b
	uxOH1Pgq+Nr/9ScTXLPoezo=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cZtk42Cnmz1prKB;
	Mon, 29 Sep 2025 15:54:04 +0800 (CST)
Received: from kwepemr200005.china.huawei.com (unknown [7.202.195.182])
	by mail.maildlp.com (Postfix) with ESMTPS id 17907180064;
	Mon, 29 Sep 2025 15:54:15 +0800 (CST)
Received: from [10.174.184.156] (10.174.184.156) by
 kwepemr200005.china.huawei.com (7.202.195.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Sep 2025 15:54:14 +0800
Message-ID: <1ff65e11-bbdc-48b9-b703-c3038c8aa280@huawei.com>
Date: Mon, 29 Sep 2025 15:54:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [RFC] mm: Is flush_cache_page() in wp_page_reuse() really necessary?
References: <7a217590-1e37-4d80-9c5c-1f7d2c2b556c@huawei.com>
To: <linux-mm@kvack.org>, <akpm@linux-foundation.org>
From: "wuyifeng (C)" <wuyifeng10@huawei.com>
In-Reply-To: <7a217590-1e37-4d80-9c5c-1f7d2c2b556c@huawei.com>
X-Forwarded-Message-Id: <7a217590-1e37-4d80-9c5c-1f7d2c2b556c@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.156]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr200005.china.huawei.com (7.202.195.182)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3059E20002
X-Stat-Signature: 1byjgr3drpsgs8117gxccny8brc9r41m
X-Rspam-User: 
X-HE-Tag: 1759132461-706217
X-HE-Meta: U2FsdGVkX18kcufjReXujRuBWEldCQ6tvMB1uX11rIEJoRUuGShYdOWBcDEiXYUu2wvlqt0eA6ERBIdDWT7jWukAn0PnJvYVh1pAu0S7hMd1FUHQCDJisDHDY9vF/S1g6Jl7heHxS0HX8xnP0sS7VV3Ul6Yq+5Crlfou7oS86hfAcRkTV9EU3gyA0+0y0E9oxfIN8vHUTWbmoAJpkE5k6HTM0K7iFhLvt3Cpc22RJ/qbsk/5w0zCvGlZSZiXD3JN/xB7lfbNP/iuolOhcLrVa/VJjThbAAx2EPKPVpOCOSxTOCWWRLE786syxJe54fAuBlau0U4kWl6X7snlJJPv1N7JyLyjHQ4g6sg3kHP8wOejF9E+cbWYUjjvIZCe+T+B3cQzrj3Ro3W5I7VpHF+wFahwJlcrp9HaIxwTdYsYXxbYS7gHM5N+Q+47BbJLolo8izY2P26D3pUcjX7LeiMYMpvgVFGQ1obQmV5jc6JOnmgdwkOmkn//5R8b195VxnNddewZGV8gOM0ktFG/EpNSDz0lluXQOH5FbrqqXUtYs/L0ERhQnv1QJ9j+O2mURr3TJ3oJQPe2DiREw5DIpJeLeaMdIM/LDxYxmfyoCluiOkBPNARafPte8kT4Zvj9GNjZqINL4XVYE7exLNXPhamDpYSbsh5KrbvTwZnOD438XLKiY3SRZo6adNfFgokanHWHo6vSQn7wmjqIO5HOOfVQzpSvHLhFjFHN+MhVJPnR2ledmLDOjcszaS9bh4H4utIkWgzWn4T1PhYfKkcJvw/rAcQg8HiCAS8+sd24AUW4I38newwkIWQ2qO8wk1y6anSnijytieNTZbBuwd0GkOylMsFgoGB/mRVIkUOJIJ0Tx4FQbpQhDm5OL1b42v1yMBO8PTLsvcUmpk5Ej8tcsV9aH4XuOuERbHHyEjQ4CA7Gr/tC//E/6AbphiYi63QlQwK9aq7lmiUzLOAcMygv/KK
 7TiOL9NJ
 NdXwuxbMXdFZJYOzUsXz8GvIq6Y9Oc0Bs+8pckJJvgQuWELp6tn+PjdWfE7LKoXQpZ3ycoIx04awKtYRWoVfOWFnNL34esPN1MLS298SvjHW+13/+WvSwV2XZogJwcX3ivKjxMRf68pNLfzxHgsTADdV5MjsltJq48WqddcbN3eeoMhFZt5Ac59L/U1AtF4pAi1zpFetm9eesLIA/oxT9Xx5x1SFWHbjcJ8PhY21/VcVb5lpbRyRluZQdUx6aEoYf2QnLvnaS8tj9hkHcBi9LcsbxdNtXv35W2X6iDn7TC201hPEkJ4cR0dnpBJcAWySiUbKt0l4KD3rzmkl60luURQ9pubNG0EOSSdHtcp4PackzTyi7E+icVbwO3R4kVNGCPgJtP63mB+fDnWWVGusEr1CTougbr7JidxfahlDkkKmTN5BktigNNpu+AV0eNrnX36GCJsRYi6a5kIuLufe5V+KS+nJlG6L3ilIyISoMRvUqfCL5nBLRP6lBfsN8ISRUIopHzNoUPm9wXg8muDfa/VIkL+8inEKDw6axpIhjrEB3jYlgHL00bfHnME3UghIj2oOgHmRMJAMJavw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Forwarded] This is the email I previously sent to the maintainer.
I forgot to copy the mailing list, so I am resending it here.


-------- 转发的消息 --------
主题: [RFC] mm: Is flush_cache_page() in wp_page_reuse() really necessary?
日期: Mon, 29 Sep 2025 15:29:37 +0800
From: wuyifeng (C) <wuyifeng10@huawei.com>
收件人: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
抄送: baohua@kernel.org

Hi Linux MM developers,

I am reviewing the page fault handling code in the memory management
subsystem and came across a point that puzzled me regarding the use of
flush_cache_page().

When I referred to Documentation/core-api/cachetlb.rst, it describes a
typical sequence in a page fault scenario:

flush_cache_page(vma, addr, pfn);
set_pte(pte_pointer, new_pte_val);
flush_tlb_page(vma, addr);


That is, first the CPU cache is flushed, then the PTE is updated, and
finally the TLB is flushed for the corresponding virtual address. This
makes sense: when the virtual-to-physical mapping changes, flushing the
CPU cache is necessary to prevent stale or corrupted cache from affecting
the new mapping.

However, in wp_page_reuse(), the virtual-to-physical mapping does
not change. The function looks like this:

static inline void wp_page_reuse(struct vm_fault *vmf)
{
    struct vm_area_struct *vma = vmf->vma;
    struct page *page = vmf->page;
    pte_t entry;

    if (page)
        page_cpupid_xchg_last(page, (1 << LAST_CPUPID_SHIFT) - 1);

    flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
    entry = pte_mkyoung(vmf->orig_pte);
    entry = maybe_mkwrite(pte_mkdirty(entry), vma);
    if (ptep_set_access_flags(vma, vmf->address, vmf->pte, entry, 1))
        update_mmu_cache(vma, vmf->address, vmf->pte);
}


Since the mapping itself does not change, I am puzzled whether this
flush_cache_page() call is actually necessary.

A similar situation appears in do_huge_pmd_wp_page(), which handles
huge pages. When the system reaches the reuse branch after the relevant
checks, the code looks like this:

reuse:
	entry = pmd_mkyoung(orig_pmd);
	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
	if (pmdp_set_access_flags(vma, haddr, vmf->pmd, entry, 1))
		update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);


Here, flush_cache_page() is not called. Instead, the code relies on
updating PMD access flags and calling update_mmu_cache_pmd() to refresh
the TLB.

I have traced this back to the 2.6 kernel, and observed that the
`flush_cache_page` interface has already been present in the
reuse-related logic since then.

It appears that this part has not
received much attention over time, and the invocation of
`flush_cache_page` here may indeed be redundant?

code in do_wp_page (linux 2.6):
	/* reuse the old page */
	if (PageAnon(old_page) && !TestSetPageLocked(old_page)) {
		int reuse = can_share_swap_page(old_page);
		unlock_page(old_page);
		if (reuse) {
			flush_cache_page(vma, address, pfn);
			entry = maybe_mkwrite(pte_mkyoung(pte_mkdirty(pte)),
					      vma);
			ptep_set_access_flags(vma, address, page_table, entry, 1);
			update_mmu_cache(vma, address, entry);
			lazy_mmu_prot_update(entry);
			pte_unmap(page_table);
			spin_unlock(&mm->page_table_lock);
			return VM_FAULT_MINOR|VM_FAULT_WRITE;
		}
	}

So my questions are:

Is the flush_cache_page() call in wp_page_reuse() actually
necessary?

If it is necessary, why is flush_cache_page() not required in the
reuse branch of do_huge_pmd_wp_page() for huge pages?

I would greatly appreciate your reply. Thank you very much!

Best regards,
[wuyifeng]

