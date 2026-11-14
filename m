Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4CA7606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 06:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZtCC2qn/
Received: by kanga.kvack.org (Postfix)
	id EFE336B00EF; Sat, 14 Nov 2026 01:46:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E880C6B05B0; Sat, 14 Nov 2026 01:46:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F5B6B05B1; Sat, 14 Nov 2026 01:46:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD6736B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 01:46:07 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A45BC0374
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:46:06 +0000 (UTC)
X-FDA: 85432789932.10.44F68A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 13333C0006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:46:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ZtCC2qn/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794638764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHbcITGOkxyEh3nCOC1u0s4lDXjvYPiyn4teM7lM8pk=;
	b=r8SDI/pFzkJv7mThRFAGCekGKQi9T0B6fCBQG+mZXH1F3NdUJQ3JBM73ENb1+0A+BvIFCk
	kY1svSXHjEwXOJR6y955JGlM1OKBr1S2zkSDdDuwJydnOJG8RwYKrqaY8MWudmCyM/wJFJ
	fcbi4MGtZDmiyrJC/uOWKSpvanWxwvw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ZtCC2qn/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794638764;
	b=IkINhZ423fZdESlkmjEVtteg1D6c5Ec75aYb5uy8vPpB1LhxmemhTqQL/98CF9AN4m2kra
	jGdZOZwu7KbMDGrJsfPFNnlUD5y9kC+6hBsd6s+P8blRMAPVD1iCtu74nC1yLMxad0tNz/
	UgJzYLYuquK0G2jHKBb07oCXOUiR+zU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794638763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iHbcITGOkxyEh3nCOC1u0s4lDXjvYPiyn4teM7lM8pk=;
	b=ZtCC2qn/uyy2rAWRpJ1H61dvB9FmrX4WXCPpBxk1p0PJITykd+Vky3w2uAglfdYtx8JAEJ
	AVOULBtXLigh147Tu2oe1Qp0byB1F2CyffNkRn3sTN6hZ4u6v6gxZinbOXkWp51OKqM0Gf
	Zn8R3f52wLHUhaXi39kLi0WCTj2ETtQ=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-uA-OED5nMcOpA4cEuArsmQ-1; Sat, 14 Nov 2026 01:46:00 -0500
X-MC-Unique: uA-OED5nMcOpA4cEuArsmQ-1
X-Mimecast-MFC-AGG-ID: uA-OED5nMcOpA4cEuArsmQ_1794638758
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5c1595d5031so1084294e87.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:45:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794638758; x=1795243558;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iHbcITGOkxyEh3nCOC1u0s4lDXjvYPiyn4teM7lM8pk=;
        b=Yrn7yIXAe4/8ecwptk7UsCrcTKvhiH6NDutGYOoizhwUhDI4wFBfnTozX+bfkkgjF5
         TrjGsKp1S4Cpx8oQyAvFYJaYWWfww7FADy2U+q3YVoTl/ZEt6m+u7HHmaCS5Vd2Jknz5
         Fa0aBn59aeFhdq6nubzkZ5+G3kZSiiykvQxu+3cCVNCQ5AReQpgg33VGHO7O40y17NYM
         ac9r8eDKiqt5WJjPJyvKUKt/Ji7RguwZiAuX8994A+AjzD6oxSs/74IgjF48bUiD5PhC
         fxf5T2Mmva/qpVRXcERi/qptBYUFSdQ0wJNguzvfN4GIx9EMpYVigtAsVddU37z3/9DB
         CdYA==
X-Forwarded-Encrypted: i=1; AL+hErF9Grj2+ahPYL0LU8ji0w+iyWc4xuP1oze5fBtyM3mjJTuuXCYfV4zFTfJ9GRU657astIEMxpQDJQ==@kvack.org
X-Gm-Message-State: APuU4Z9G0s0sAJvq6GLkjXRLbIJKA3m2o2eh4Pr9WiaIBDGiCkpxnIc7
	aRCYXuzGg+7yAA+uawJC1POskcGGNEHtDNyYjEdHQYHjXWo7DLVDxWb12ljt5P2J5debYgKq5HH
	miJa07b0sIdosQiJaVoGcfDz3pmn3usG73DMAs14eEXOzFlIQQgQ=
X-Gm-Gg: AYBFou0Pihbj3n9Dynv+VcwDGXQY5pLP7VaBTL4+680cEHMtTxlX5DYu72FegDo5Ap+
	OzPk7ShVCc8Z3Q46PF4tfWiPDqiB7JTLMzcVhypiMxIH4zutoXnfDkQA7Y8UV31VKUqmdCHy2sk
	9gYVLXHTMN5aS4gHYwHqowN+MAmHFHqNl2moHs7TpGA5UtzPDdfXs6NrpIZiHItzf5d5zXdA1Of
	2pPIt4/Ib2p10EPaWyx8NrFGJL42UsJZgAuHi6JQmTtgiu3xn+pQ3KQZ3eMhs075/t4dWTq7HAa
	dza0Euna0oi9bj8gB8oVMIOHK11UrNdYc0vztdBLaChwouP0UeD3i2aC/i0Pj4lSe9fZdq0QXXt
	n/quedOD32E9f8yJ4EpQa/KZff93N/rom6sn+eae1XSGPm6DR0lPU7DUQIBnWgSOv84Q9HyZk9E
	Mnu17Q
X-Received: by 2002:ac2:4bc5:0:b0:5b6:4ae:5b83 with SMTP id 2adb3069b0e04-5c1709ca612mr1930569e87.33.1794638758309;
        Fri, 13 Nov 2026 22:45:58 -0800 (PST)
X-Received: by 2002:ac2:4bc5:0:b0:5b6:4ae:5b83 with SMTP id 2adb3069b0e04-5c1709ca612mr1930526e87.33.1794638757811;
        Fri, 13 Nov 2026 22:45:57 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c17133e3acsm1466215e87.45.2026.11.13.22.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 22:45:56 -0800 (PST)
Message-ID: <8c79ce88-7730-44c4-92a0-d760d6f8e9e1@redhat.com>
Date: Sat, 14 Nov 2026 08:45:55 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/13] mm/migrate_device: don't collect a range twice
To: Balbir Singh <balbirs@nvidia.com>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-5-50a2ed382b61@kernel.org>
 <avfrWjzLQdDcmXO6@parvat>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <avfrWjzLQdDcmXO6@parvat>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4obiKaBJFXnrbDdpA4KZVTdvemv1fyppPfBRhLjGQks_1794638758
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 13333C0006
X-Stat-Signature: j8msnjg11bpyrw558hokia5bgnp94he9
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794638763-147172
X-HE-Meta: U2FsdGVkX19PX0b1+iI02I0G27TUmDD8yaO2NqxCiX0vFXze9BpsOUlo3TopoguJ7iorlcTOxpBGRlwSDoL77CYZC+ShUYkJINC0YwZkwmQvldvzh/cuAQVzdjWaisobhK7arC6k0hcon/wTGgsFRs8yFuimZe0kZHlone6vA774pXy9ftLODjOhxX0UtEvf2R8DNZcZ9X3yTvniEyKxdXCUYU4Qu6FMDUJ49ElGLprwAbi79LoTrJ6fwGjlYn62FEj8V1MNwAweVVDr6O/02E8CqchtjRJBr2zr4o08s//qvGARwyCm7QaTYveEDCCFWbD17dGPUpDNtsagTNI82Pqur17MiTZOZZz3vxSBLAuoVFxXjGh8Lw2unrpT0sZ09vuINwXLEqNFBeR5OjvtxmXtwmhoZFig56ghm7RG8Im3UrREhJPjG5X68osKYLv0Y6h6vzalVtOLdOwuKtw/ao3wsfZ4Ilt+bb/5h9SV5RFbNiXQoTUVeCVajrQMkBXgnkN8H5FmYsltI8by5nqwi+IXaIFeZeQvHHu0JQhnIOzFCue4FySCsADxPvuHCo5HkatBiPJiK19GZeNi+lkTUrdULWijD5HL71NhlLcA9LmUiVPvoLoWCJGdnX0VKp+45IGCt8Xa3D+DqREKVCrlPXlFiZjaKofNPUyBIRNng6IQyVglaGN5ysJdSPe0fdDbrvAA/r9EOOl1oen4PnDeACATSsEb1P4U1VqE2bYaak6Km5QyQVXdm9pio50H0YaRB/nq5e9PMpNo/t73/vD3TT8gQpDnwRYJOKLNDxOZ5aIDAgTx94cvIgn5mZzVpG+cfKFZBnf1fiPs1qV0toL8stMUDuEqZRzrAMN6Mh+MSZ2lrjLlgKP4Z18q2nUbKyLk/WslKxVYD6q/7jrS41NL2GoAhnDbfn2/j/vMUwQvIL3caK/D8WKqImsRXYMZGhHIStTe5xVjVWUBYM0x1Ta
 jrU2viF6
 rpubPnpTsuxhSHP36z13qQU78ZI63dngWN3n2FHA6hEDmh+RlY03ds/sF8HTag8w/RSWrxBkHfd88TqjWCJl4tmpJ9fqSe03B6oV10ai0L64sgeqbPHhAvQLKVCF78stSSWuKvaovgdIw1BT8QHB8Wo6tBi+lnK35LVclY3+X/lvSYux8AIbjZEizG7085mWw3VrKDx1fokfu5vKyFckMcxFSWi/mtdgzszbTmRJCy6DQw6GNTw/veaVSWzl5k8wZJ8IKZV4L9vYl358bMWCYgd87q6tGIcsbGYrl1O0jSRQhq2/W6wpMLIdJOX8FpBKZdWQsy+LvjmpUpK/y8nqnhgEd8yFhRvc0FF60Jgj0BLiPL20QQExYqiBRF81OxxXyyOQL+Rsjgk6mIF0whZbSUtz3r/iwcJBAolRwBSvuifeJMs+3LpsYKBLify/QlwZcdxcH9sYARtlGGCXkmGy1aj/0ynUywch1tB8J7HQVG5Z7ACaPq8T0GSzHe+4cBesmxySPvgR4CSSvRxNd956EhKaTC3SDxxuuhT4+vbA1N1Y2/Dzwn6ChK21Vys07M9hQUIQeWC/ShZOsS13vdAX0Mm3GvQdwy1AlyjPhr/qa2OD/AxgDz/NdYN1U3ozglSG/e+lnNqPUEtQ6EHNs56axkag3LQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/14/26 07:09, Balbir Singh wrote:
> On Fri, Nov 13, 2026 at 09:45:23PM +0000, Lorenzo Stoakes (ARM) wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> migrate_vma_collect_pmd() drops the page table lock to split a large folio
>> which it finds in the middle of a page table, and then starts over at the
>> "again" label. The entries for [start, addr) are in migrate->src[] and
>> migrate->dst[] by then.
>>
>> While the page table lock is dropped the page table can go away, in which
>> case the restarted walk invokes migrate_vma_collect_huge_pmd(). However
>> this is passed start rather than addr, so [start, addr) is collected a
>> second time.
>>
>> This can result in migrate->npages exceeding the number of pages the
>> caller asked for, and therefore in writes past the end of the
>> migrate->src[] and migrate->dst[] arrays.
>>
>> Fix this by only handing over what has not yet been collected,
>> page-by-page, and flush the TLB for those entries which have been
>> previously replaced, similar to the other returns in the function.
>>
>> Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> [ ljs: cleanup commit message ]
>> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
>> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> ---
>>  mm/migrate_device.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 9e5dab8e1b77..28ed706109da 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -257,13 +257,17 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>  	pte_t *ptep;
>>  
>>  again:
>> +	/* [start, addr) is collected if we get here after splitting a folio */
>>  	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
>> -		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
>> +		int ret = migrate_vma_collect_huge_pmd(pmdp, addr, end, walk, fault_folio);
>>  
>>  		if (ret == -EAGAIN)
>>  			goto again;
>> -		if (ret == 0)
>> +		if (ret == 0) {
>> +			if (unmapped)
>> +				flush_tlb_range(walk->vma, start, end);
>>  			return 0;
>> +		}
>>  	}
>>  
>>  	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
>>
> Is the intended race a concurrent MADV_DONTNEED reclaiming the PTE table while
> PTL is dropped for the split? That would leave pmd_none() true on retry, entering
> migrate_vma_collect_huge_pmd() through !pmd_present() and taking its hole path.

I think this is "ok" for the fix, the hole is collected from [addr, end). 

But couple of things follow. It can't be possibly collected as
MIGRATE_PFN_COMPOUND entry, only small pages. And the collected entries
in [start, addr) are wrong ones.  Finalize will recover, but the
migration will fail for those. These all are handled in the HMM walk
based migration series.

--Mika


>
> Thanks,
> Balbir
>


