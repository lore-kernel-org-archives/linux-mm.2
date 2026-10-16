Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA89CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 08:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8394E6B0088; Fri, 16 Oct 2026 04:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA4A6B008A; Fri, 16 Oct 2026 04:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1806B008C; Fri, 16 Oct 2026 04:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39E456B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:34:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADC8EA0178
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:34:48 +0000 (UTC)
X-FDA: 85327828656.24.3EEF7B0
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id D343980005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:34:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QBpMjcxt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792139686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wp1mQzm08hLd1tOFds5YVaqYtr/CBX6Juw0wzqMGF6M=;
	b=mmQJup+UWi7b2wS9PsmgoD7dZugWmsABoAU4yvp4SsSBJk05paqqHdx6qs1uclzFjXKv8t
	UuzJnVMgCapY7W+YDuRmpZtikkCBW3pInvOBUlt0GY7dw/xbRpCd/ONuDAI2XJU3eYItkQ
	t9+cP11jHeOL27wNxMoVaZZy8q7hFrk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QBpMjcxt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792139686;
	b=Bv61sHB0WOELTr0MSfKR9CuHE8cwuMwsDn9at1TpywtPNxr2oAZLX2AD7fFBkcwKZwrY0d
	jyDwMC7grgay937vdHOevSB/zcSfdXjy7kcK5cW2UJ8HjVBRsWcRVHXcq701i+s9RJj7zj
	qA3W5SuI1arHHl2n731Dojpp5n+LuNs=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48c4649b35bso1185360f8f.3
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792139685; x=1792744485; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wp1mQzm08hLd1tOFds5YVaqYtr/CBX6Juw0wzqMGF6M=;
        b=QBpMjcxtg5rRSCwjh9qzzKKM44QOYIFRCu0yfP/UdMoyZIwQ0I2OLwoQXOGQ1h64CS
         YsNwejEC4PrZAOHbPL2oqTaQFosbtmurXPhzcvdFfDGiG9caKlwXEms0mnQrN4blIhRV
         daWG7grVuhotpz3QnAG/yXYzFHywOPrDZbXah8mfqAIU9oKLx4VVFDivHRSb8gDEfkx8
         5fgX34DDNVIWCGINpCPbZzw/Tu8gFPgawC9BA2CE7b4XEyw8iwUPqEsdSngQcjHwsaNT
         qMMmG9zZsO/rLic6VVBwmDbPmFBQJdKrOHKrv0QN/+Y0VAm3EP7mpbJLVFC331cqCEA3
         pdnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792139685; x=1792744485;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wp1mQzm08hLd1tOFds5YVaqYtr/CBX6Juw0wzqMGF6M=;
        b=RADoX8rZFObQCk0dYbpTrM+7vApGew8hmPzb0mPRCI6Kk/iwapgatvST6T93+McMpt
         ourtJ4OBTmWe5b8HMcvzwy6otmt9Jw8zxRvlcFMe75PSK/WucO1j0lBIww2Ryu7PXlNY
         CrKI7NtDz1GbzO/up8yoY+UFXxdBGfXQz9+TLhHAio2MZib7unQzeN8HeH8RkjmOWyfb
         xIbUoib2ra+a7H6dx/intXhrgTfVFR8m0N4/VEAYS+tQjBqY3DSVmJaCAf2Y+fLy79uc
         mx/P5RR5ARYQbHBEL1hpgHZ0T0djr46qrkv/++IivO6KND0kUgl3VqR1LfzcVaHJcDAz
         /umg==
X-Gm-Message-State: AFq9FYJVNhA+NGl910Jo//+enJ+9k86sJy9P6OAQXzAiJRv3ywP9M/I0
	4qma8a4bP57jZrVDDfZRZm4aBp34yG1Vz2YnB/yWpDJcxv8fEQN+21my
X-Gm-Gg: AYBFou2mMfEO2bLXl3kB2GNsDzSlKH96PDPYvRDFJmXxlsnX+T0uq/0+wlYfHIF+gap
	iNJizNV0MoijAd9LcG2xwmpq/hEP+6Ijz1btJ4kBnDsiKozN7mBseutYlkcEEMe6K6RTIqObkub
	7MwzKc0vXyyUUCvK8E31ACJxn/g9cv3p6jMbGX3PSF+IJ8ERWECHc8Kcu7BLvGJTB2MWAqxZ4Wd
	9Kf1mtwt1Muc7xmtNsHDbkPqYzCsaNwH9BhDxFGAApiNdfI9q2aaML5+auuQitaOKRXYbIqjskx
	+HembyPpgJcrZZivl0kwYX9VG59iaxdwaHRqeAcGmwMcW18DLz2eNDFCtPZ5CMMfSmd8/ea/s96
	LAa+lhZd+2LbCHToWjnzmDPXo+B57e+0wwD0/8NEC6stG/dBZqVmN0TvtwHM2FJbnmGb7ArZRtG
	Gx63eK2GRID+pQvPcfSjMw+HIQnoz9W5jti3j+AXGjFHnp0qQZ5Pvr6m41ct9SzWe51w==
X-Received: by 2002:a5d:5590:0:b0:48c:6cdd:ba89 with SMTP id ffacd0b85a97d-48dbaaefa6emr31965430f8f.36.1792139685280;
        Fri, 16 Oct 2026 01:34:45 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd500e75sm3422534f8f.42.2026.10.16.01.34.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 01:34:44 -0700 (PDT)
Message-ID: <80ce78ca-d971-4530-afa7-43b0b4a175d1@gmail.com>
Date: Fri, 16 Oct 2026 10:34:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] mm/vma: don't leak the commit charge on mmap
 failure
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Adam Litke <agl@us.ibm.com>,
 Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>,
 Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
 <20261015-urgent_fixes-v1-1-42796911043b@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261015-urgent_fixes-v1-1-42796911043b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D343980005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: ieb5dxrnqdp85s89w87nwqf7zjodbier
X-HE-Tag: 1792139686-81526
X-HE-Meta: U2FsdGVkX1/eAsEnK3JJhE3o44pGZqNZSUOS29XpVOiIkdj21C1nuStLHouTfL/IHwVhqIFCSj8vX3EbrLDRs2UmYb50B3G1VnTkVSUQyuePrwhQ8GPRhRmwynN3zZQS0RMwW7HI6uSVSFAqxosL+6PFhMwKpJ4Sb7RG79Ueu4B/6U8FVHN2GzRTzlXK5hnmYH8mYnW4BGSQxDNCzyRv77k02dBxVcFkutW7pqbQCV6VzZsia2zR/IZMcz0UAdIS3XwpsZhy7IdFAf07BBF3Jha6xqTqEY7GIn60KdN9dzeezORoJ2MHWJV7lWBXTLy+Z2kQUGcL+wmD12PzwHIf4jb5ppfOtQjTAUMbb60XCfz6X0JMPV6BKN7VFHTrM4lcw6sGrwdzYsRY2JxRjF20S+GllAyRmwkYGWCOiJL6VTE62dn993VmWk/3d2zAzawPqObqzQeOONKy1e/UnoBUqvUKp4ZITbqk9PBN57GOfJye+qOpvBBvvHSjTHHoZ5lg5KTvprYs5wCnAa5jR5y9753n0GfFmpFKstttqoVya8pqZS9mJCIHFeJBuSX4WXNeYEHD8UQnS5DiJD7i5g5vposmaKoIpaPzFPSaT/pnAq1jIWV2hYU/n37P1sj0BAnkpTaZ7OOuN0VkS0MMyHk+ZfNqwmNCNo2OoPMWPdnu9dabi76h/VJqai3uYR6NbROqKhc0iB7ga/G5iQqyKmqm1SprFhyvJoYSIgi3/IXLhi2/LLaRHt6xQhIdjvQRERrVImg0n3ctSMUYY44r9B+6GlO5Mnz+pe2q13N8XHWrF9Y+KJBaJjJTf06jfvfzhveciIvI0FgONu9nP4vf4TLEf58i/Zd7jDnVwpVdolkRhGtZMh+nJT+4d2c7FWXQ3aOqJFUfSLg1T+8H1BtW+nM9k8sKYgm33ZVn75bqKkgD7ALk7HFr2Q14+kaewQff3ygMI36uJsPtUnY42KUKkUz
 ghoT45Bx
 d9VnPboyuxGttN3+YXX5g2Ych4oaYQ82mdFLSfQBuf1QtFaghUzDFijK3+3PSuXh7fmd2qNG2cDQunwZ7g6DbmrV19AlnHQMDCPxCU4tuVtvUfKvCPB7Jc9sHnWPZqJFSmzRGg7S8+a6ms2Q0bRBzJ6YdFeXunVy71aRJBYQpbMQ3rciaPo/IbiMfDbmhWCMx030jP51pOKcG9cfHxRhUEHNiheewJHkSdintapL5IcNa2eDNeIKN7uMBOjWk1hNY5fewkiYp+IukqQZVbtfa1MtW3/HTttOKQ78dVUhXbi5EFPnUbgmGi4BOSCYF4uo2UtDiTfYmbvvHrgbe1Ypc20U4FSK3NzGhmMq2IzAJpl36JBEmLNJ/QmDXYstR17PpCf9jKP2P6qSLLJent+COVjiGlbxf0tm/daFlBMA5apJgGxIjXdNbQojz0DdGOjjFayUesJDbde6bc7C+aCGemmdDOD1uoo62o9e3jNWE2a7z3FvpPNBLM58vROPQwEl3xwYViDhsd7K7TN4XBcg54ZmgzMYB18J+gU7rehA+sV/J2OXdAnG40jvcU3fUE68EW1yKB1mEbFl5PwRigt6ChD3KkIzoLBTO5vSwxNNwapq7Qx8J73+HxeuA/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/26 6:07 PM, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> When an accountable mapping replaces existing mappings (MAP_FIXED),
> __mmap_setup() only charges the difference between the size of the new
> mapping and the VM_ACCOUNT pages it replaces. It then zeroes
> vms->nr_accounted so that unmapping the old VMAs does not return their
> charge, which now backs the new mapping.
> 
> If the operation fails after that point, the error path returns
> map->charged, i.e. only the difference. By then vms_clean_up_area() has
> zapped the page tables and closed the old VMAs, so
> vms_abort_munmap_vmas() cannot reattach them. It leaves a gap and
> finishes the unmap with vms_complete_munmap_vmas(), which uncharges
> vms->nr_accounted == 0 pages. The old VMAs are gone, the new one was
> never created, and the charge of the old ones is never returned, not
> even when the process exits.
> 
> No privilege is needed to hit this, only a file whose mmap hook fails,
> for example a socket (sock_no_mmap() returns -ENODEV):
> 
> 	p = mmap(NULL, len, PROT_READ | PROT_WRITE,
> 		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 	mmap(p, len, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_FIXED,
> 	     socket_fd, 0);
> 
> Every iteration adds len to Committed_AS for good. With
> vm.overcommit_memory=2 this lets any user make all further accountable
> allocations in the system fail with -ENOMEM.
> 
> Once the new mapping has taken over the charge of the mappings it
> replaces, it owns the charge for all of its pages. Record that in
> map->charged, so that the error path returns all of it.
> 
> A failure in __mmap_setup() itself is not affected: it happens before
> the charge is taken over and the old VMAs are reattached with their
> charge intact.
> 
> Original fix generated by an LLM and sent in private by Josef.
> 
> Fixes: 4f87153e82c4 ("mm: change failure of MAP_FIXED to restoring the gap on failure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ david: call variable "uncharged" and make it const, adjust/simplify comments ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

this LGTM.

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

