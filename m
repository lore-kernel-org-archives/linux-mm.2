Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD4B6606A329
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 09:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=bynmu3xb
Received: by kanga.kvack.org (Postfix)
	id D96F76B05B1; Sun, 15 Nov 2026 04:25:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47E86B05B2; Sun, 15 Nov 2026 04:25:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0FBA6B05B3; Sun, 15 Nov 2026 04:25:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 953A46B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 04:25:02 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 192A5A82A7
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:25:02 +0000 (UTC)
X-FDA: 85436819244.04.50B1319
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 88D24A0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:24:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bynmu3xb;
	spf=pass (imf15.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794734700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9c8p7xnMkOo8VygGtCf+xkzjwVTSeX+xnVktgNDwVkU=;
	b=WuslQFniV3/5tzWRtK0bStCa6xCUNuh1W9j4deZ0bTLRNEhT8sEVn9XN5nVcvL75RuwrWU
	vmaz7QqGavE8PPNohTx9NF6V7/xrcppErggtBnn/mItGOiL9KDailgwma8iSfEtVNEPfox
	VROi9dGLcnNk56vOve/bUTFhvEzyorI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794734700;
	b=PtPjC7LQsEtjyoWt8JyveyYctnq1fATOtw+yP7vpL0h7byUqyW2jD2JDZTaHaXlbhJqRBr
	dMUUQhZDJ5ydaVRiDHppHTsBdS80R4hITOZBMcOQsayTyN5BloAGjE/ILyPLOvha0grqnT
	xW7OcaUWKvcdK46cIZDMPrYrT49nkpI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bynmu3xb;
	spf=pass (imf15.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794734698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9c8p7xnMkOo8VygGtCf+xkzjwVTSeX+xnVktgNDwVkU=;
	b=bynmu3xbjk1GpbFUvUfRxAk3I66xSKCAz1br1I7i+RFko0Jot4WsLyI6Zd66BqF9iAzle1
	zw53xSHivjAabTVskoHLi8Td/ZIpK9vR73zD5jHpQkgHC8OWt7C+5I4PACJkjurYLYvA3m
	EAVHEtU25zLjvYwnDRkEAQOx+5lAbo8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-b5V7DB4fPta3X835wjsbAA-1; Sun, 15 Nov 2026 04:24:57 -0500
X-MC-Unique: b5V7DB4fPta3X835wjsbAA-1
X-Mimecast-MFC-AGG-ID: b5V7DB4fPta3X835wjsbAA_1794734695
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-3ad09084d85so12962801fa.3
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:24:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794734695; x=1795339495;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9c8p7xnMkOo8VygGtCf+xkzjwVTSeX+xnVktgNDwVkU=;
        b=Sd55hK08fh2INSVyVdG3stcINm6kSD9HwXpJkzGdXquHHlDlcDOZuGXkA80NPEMtqI
         ZeEz7iBhKBKwYfpK0eAnRCF1NimhaWZWDYCthX2k36agAflQK7RRQRTWZsv4ORi4XJ5+
         4E6Dm8b9TtnT5fEOz2l+jlfmLCCbATb52kqKCK/JVG/rkkUhpI34kjEmdMgar+nCUBo1
         tNQuyuUiZjO70F42iy+Yll+/Ud0+sZcoifj+K+8BAzYE6iUU69m+w8b7W5TofJdoy2t8
         Y1CCbeu4+He80AKE/56UHQL18usT7Yv6s5+F2hvxOV2TYoeLCxbUgN7kHL4qjW90DhVZ
         rt+g==
X-Forwarded-Encrypted: i=1; AL+hErFhe7y+ewPhU6Jipno5NR/qsL9nSSM79JZMQSWuXvA/FbAbOZwNZWn2KekIeGNp9R0UYgeqxUB+ug==@kvack.org
X-Gm-Message-State: APuU4Z+wNqDataqf0GdWtKW0jCmOQebQ5HY0MxTjRgfvuTrwFHqnl1T0
	r4VbrR/trI8R+ardUeQiA7kavgGoOWTCn8AAnqkg1mhYe91maJIJ1ZkhMZ0+1HUOKorrWpzEJw+
	yjrt2rOh0cWyAHP+TcpbD/+4KXrlpYeMlnfg/45T4mMH2lK6Vxi8=
X-Gm-Gg: AYBFou0ki3V/CGq+uBt6aOIdPsG4XnUlIa63tY+TUc32YGFAhdE+qQwQT+wPUJ3Xlo/
	API2LRBMo9YVtSF8x+mSlNWmG1Bb1BzRrVrApygtq74sat1IvLlgHetZmHEXpiNYc0b5z+BjPi1
	7WHVmDVAImy3eEE4uLbp+SSLyJax5xXJuk1xD3aY5bMwee8ga0FnoZpgSsZlEXZuob8C/hubTU3
	RRCqJMPnidEVLvjjLOeezOtrw69d8eeHhqxOH/MKPvXruJA4nkBpZI5ve1OtfUnY5AZzWJV/RD/
	SlBE2rky6hD8J58vCx5dXGQDfcyK6MErLVdAJEPrw2uwOiZm+xqSHLvYJbs+k1OvpDATSQC2w04
	p7SIh1SCIds4wBIi32JzLXBwiCZ1ZDR6mx1bQDEP0OFJSxerz/qSBvtRUBRqQPdtkkfTmnNDIyC
	I/fGHI
X-Received: by 2002:a05:651c:211b:b0:3ab:1639:9a75 with SMTP id 38308e7fff4ca-3ae2b4efaebmr20844941fa.11.1794734695433;
        Sun, 15 Nov 2026 01:24:55 -0800 (PST)
X-Received: by 2002:a05:651c:211b:b0:3ab:1639:9a75 with SMTP id 38308e7fff4ca-3ae2b4efaebmr20844811fa.11.1794734694918;
        Sun, 15 Nov 2026 01:24:54 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae2b780517sm24261081fa.15.2026.11.15.01.24.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Nov 2026 01:24:53 -0800 (PST)
Message-ID: <607bc1e3-7f12-429d-8b0b-a24f77b3762f@redhat.com>
Date: Sun, 15 Nov 2026 11:24:52 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/13] mm/migrate_device: don't collect a range twice
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
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
 <avfrWjzLQdDcmXO6@parvat> <8c79ce88-7730-44c4-92a0-d760d6f8e9e1@redhat.com>
 <avinH6zgTzpjMCrf@gremlin>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <avinH6zgTzpjMCrf@gremlin>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JdPn2UM9GuxcLJZGGjfp16fSMK5X1unahdnE3wf73Tw_1794734695
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 88D24A0004
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 95tdkyswsgqo6hhfca798xdx5rrrdk9d
X-Rspam-User: 
X-HE-Tag: 1794734699-968670
X-HE-Meta: U2FsdGVkX18VwPXiseJRnZCMprtK0d8xxae0sifCKSAYRYyBE4r/hy+VGR/x19S5vg/za+Chncq5sNYulC3tn7XEjjHN3IMgluCbGJWiSx071r7o+Nvb0zSKnjNcffnjuGiWXgI5/918//1gtqgnbAklHepmHY10fc7+lv0DyDmczrVT6DL/HRJ+uXtFsX3a8Qewqa6zr2/trxkrUi0NelerBWp76mbhCgkTRj+RvsITDe7fCXvDHQS8z3HPzakCTN1gevhLfCOb0B6v6YoP7GBdjMZrlgM0X6mKfBTJy/RvnbXnWfMfHmOE5PXWLMDythJH7xLul0MvLZIYLacC+Mzs09YTq2AUm+EVOn8lnl9F6WHjyt0Y40wL1oGJwaohSOPaShtsmq6M8iyAHiJzFwgjcDB4RUhJV+7J59Ozl310tuSuk3mOTT/+3n65Hvbz6kXoj45DiaazjSBBi4RVrBLjO+6EODS5khvb2+u3K//sZVCvkFeIA834UBnUMgA54PBWIMw/eYjmHATllVPfiKlb70g1OZy79z9mQZK4QRLXOwBAXnCCmtysB4N/xkWrOdDnMHw9DUHXnxmCiRhnkIZ5lxFbW9rOcok1DHt7VtrD0YpjA42Stn96lbExN+P+mD9fvA2G48s47Pudhyv28oqJqQywtpsQh4NNagqXcX21tz+aH3x3IYIW0J1poftXlFF5sYKwargG6Btt7MFAMzpT0qS38U/r3WrQnEDKejAEYuS9d+X7CdsF0tjqhh3HBncfkQdGpfVgAqAZIV6zfP5Ej/zizYNLe81aRW8X8EGt6xUdnxw8R3WIVbHrm3gs1z0igXtQdNcuDs+ZkvIFB08BWI8+O+MiluGakx5YYyEGSQaEqEzivQEb3fivyFpsC+W81sxo+qF8Cz2tTuXEOLg5TfnS5613oVLzRraoSqWGc7Sb27sWfNcAhi2NbUq5imUJ4MscWrwMUlXaRuq
 /f1N6SRg
 V24He94HQUQFxs0f6V5Bc4+xvbOTiYyyCuLhpg/VrZ6Q2taoMR9FdnyuOEt09LoRBOvs+vzzeYnUyj6PqU01lGeH5G9g5d+Qy7VaNfG2+l2N+92lPVQ6V2JE/eJGDanIbOnUEdBvFoIAi1xDI3LpJLBQVtsfA4pXO0VH0NU39BcADZ1HdpzxwzLXaTTxtvY0EhVAjrcvCcofDI4KcqyulKkItOB/eipOe3ICIadp7WIg/mLdJrZbqzaUdJTizWzLRto0MkqjMCxSWlTXnIoI7AbMOg55ZXANH4l2Y9h0nW9evNxBK0tO4LvFPuppxKs8cDHjTfOq9e1vPGwulK3e1rV6qw5DU4Sb1TczHRYlsxMa1rrrt1Q0U3OmN8VPNP2DU+oZSBmT8G3L2KcZaxtgzJ+gY3Ej22WOWVjNTXDST6JrsnLGLr6P914DzWlw1Jd4fIQlvT1hcJwPCh9RNhiMgXUJn6j+rJGKXhOGTwHBzeswWQSgRPyGuAQq8GQG6YfE1vEhz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/14/26 20:34, Lorenzo Stoakes (ARM) wrote:
> On Sat, Nov 14, 2026 at 08:45:55AM +0200, Mika Penttilä wrote:
>> On 11/14/26 07:09, Balbir Singh wrote:
>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>> index 9e5dab8e1b77..28ed706109da 100644
>>>> --- a/mm/migrate_device.c
>>>> +++ b/mm/migrate_device.c
>>>> @@ -257,13 +257,17 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>  	pte_t *ptep;
>>>>
>>>>  again:
>>>> +	/* [start, addr) is collected if we get here after splitting a folio */
>>>>  	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
>>>> -		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
>>>> +		int ret = migrate_vma_collect_huge_pmd(pmdp, addr, end, walk, fault_folio);
>>>>
>>>>  		if (ret == -EAGAIN)
>>>>  			goto again;
>>>> -		if (ret == 0)
>>>> +		if (ret == 0) {
>>>> +			if (unmapped)
>>>> +				flush_tlb_range(walk->vma, start, end);
>>>>  			return 0;
>>>> +		}
>>>>  	}
>>>>
>>>>  	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
>>>>
>>> Is the intended race a concurrent MADV_DONTNEED reclaiming the PTE table while
>>> PTL is dropped for the split? That would leave pmd_none() true on retry, entering
>>> migrate_vma_collect_huge_pmd() through !pmd_present() and taking its hole path.
> Balbir - yeah exactly the PTE page table removal, and it zaps the migration
> entries installed for [start, adr) too, so those don't keep the table alive.
>
> And yeah, we would then see pmd_none() on retry and
> migrate_vma_collect_hole(start, end, ...) would appends entries on top of those
> already collected.
>
>> I think this is "ok" for the fix, the hole is collected from [addr, end).
> Thanks. Yeah addr > start, so it's not PMD-aligned so always ends up in the
> per-page path.
>
> And if the split happened at the first entry then nothing is collected yet
> anwyay.
>
>> But couple of things follow. It can't be possibly collected as
>> MIGRATE_PFN_COMPOUND entry, only small pages. And the collected entries
>> in [start, addr) are wrong ones.  Finalize will recover, but the
>> migration will fail for those.
> But that's true for any zap that races after collection started, so there's
> nothing for this fix to do here.
Yeah agree this fix is fine and good for stable. To collect the whole
PMD hole a rollback mechanism is needed.
>> These all are handled in the HMM walk based migration series.
> Ack great glad to hear :)
>
> --
> Cheers, Lorenzo

--Mika



