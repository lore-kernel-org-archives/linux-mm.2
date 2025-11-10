Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD526CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 23:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28468E0006; Mon, 10 Nov 2025 18:08:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD94A8E0003; Mon, 10 Nov 2025 18:08:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16A48E0006; Mon, 10 Nov 2025 18:08:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC6028E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:08:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A6DC585A0
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:08:02 +0000 (UTC)
X-FDA: 84096237204.30.589A0BE
Received: from r3-24.sinamail.sina.com.cn (r3-24.sinamail.sina.com.cn [202.108.3.24])
	by imf20.hostedemail.com (Postfix) with ESMTP id 46EAC1C0004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:07:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=COAMALKP;
	spf=pass (imf20.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.24 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762816080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6J2qsI+c35WtaOkxN/9+MAOp0J/opKX9W2NtQHW3OuY=;
	b=Khf91X64fKsVMrRcsM+SnoKR1t64lP/bVrGRqLSrmx77kJ23mhhkdRMWhgeHFTgJVdHD1i
	ugTIZkkGqrFH99XSK5xLTbQV8bMgdBTBW8hsaSA9dL4tKB1dcTknQWRZgiI56SX7WNnib5
	id3EEAa10n2p5bccjLwwpbDZVLnUG7U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=COAMALKP;
	spf=pass (imf20.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.24 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762816080; a=rsa-sha256;
	cv=none;
	b=Mtugko1bZu2745T06WOPWeP2hz+A4TSfyGqlPGTeVMg2aIcytYND67bYV3uQIKqCjlqM2h
	E18LEtIDvLqCUVXHJ9aKBYrz6W8eBRV829Yoc+/u4Pn340nBnlWQrbGlkpjgHHhzbNWttW
	eRsRoXZXKTTKzz0cwg4F5GY4QhI77YU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1762816079;
	bh=6J2qsI+c35WtaOkxN/9+MAOp0J/opKX9W2NtQHW3OuY=;
	h=From:Subject:Date:Message-ID;
	b=COAMALKP5MU2IUMA1/UqgGBXuEHkb1EyshuUiup6CgaPe+ABSwBwxqSW2lFcx0wPH
	 wBTedaSACEMJKxBwnmHn5qR1/8aoM0qDaJ7tl0DJEikKLMwzyC8/RucwLzLuq+yOhG
	 MKIFWw3iMGUSW3p/Vxzbew+I7mhMD+6osbU/9lPM=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.57.85])
	by sina.com (10.54.253.31) with ESMTP
	id 69127048000031B3; Mon, 11 Nov 2025 07:07:54 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 7443926816316
X-SMAIL-UIID: 4FF7BC97C0A44A949683DE4B3C1BD111-20251111-070754-1
From: Hillf Danton <hdanton@sina.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/1] mm/hugetlb: fix possible deadlocks in hugetlb VMA unmap paths
Date: Tue, 11 Nov 2025 07:07:43 +0800
Message-ID: <20251110230745.9105-1-hdanton@sina.com>
In-Reply-To: <bfe5a925-69ce-46af-a720-14e1d2fd30b5@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 46EAC1C0004
X-Stat-Signature: 8djknp6zg75c8nmj6g9ex3msjxagywtd
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762816078-731820
X-HE-Meta: U2FsdGVkX1/qhDltDk6UhmfSxduqVv91Ne29j9ZyVIB116IIm+8/X8/b8D2KdbhV7Qyr9rJaSHu4rEBkr5gGAeo02d7Ij+0RL6HYZASG6CyfQN3EktRRdVkT+ZNhHPzK6iwqhy2pmWfDus0FT5TbkkccQDQ7OOVC+VLgPlhVBoANea7dziVm+eQK3c3kzZDkTahr9x6kzLRAq/rV2X4K2fM/E5X2qVk6HGSwk+chGyyZSnec7o0SHQO3zuD40cpdyTRLPNlzbBxoBu8HNgL7U5TF0pHNQEj0pyPhXyNY334kmFXrdhBXCRbfzV7Kgl+u668kk5vYQX1cWTy5/xQPHyh+lrLiHTfsn/2KRzdJzTiT2JJqQfuGJ+6hSQ5sbALQry7eq7PVZkOmk2u6OC13/X75BZQi0rVEmG+Cimdt14Q4epi97fdoONtICbGCQ0OwMPsebju7QD9+wYCsghVaJB46H7So/cKzNU0RhztUSwCMtTeaQu6OSSjoB+UWfIaOKja/poz19rW12MrmDd0Xs/zHFF26MbPqRN8qQp2VsAwqSEj1iuGiCjU0YpzT0yPaCCdhYVXpCOmZqFuhiA6rmt9xuVa28NdjHqSa3x/b4LN7ediZtd1Oo5c+U4RMoyedcqcFDVOBLfyTENiWr+TSEN82Jw8JkbBHeDHjKGTd1UZdESb+c47Fi2LDj+M5b5PAAtpPXoT6K4XMxnuG4al/QwEX93EYUvJSneMZTbw+Ln+oWMVQ2BYimdG7LvhBHt6uz/PykNUnt+8d6k39w3oziCUDbA/8THsUht+XjgwhKyNkEVNw+ZWVOzb2VUHOzd4rIonZ4vkn7aBKHQWRyG0RrdIFezO+/sAl742btjMage3ewNNQc1zf90mxYIKraRg1dC+EOKUW5YeyLVK5iuCje1QviHBNW/Cwmc42w64DdyIgcqm5Y85FE26T3U7oizihwFOnQOhL/8hjitlNVQe
 29RY8DgA
 mGN6MffQMMR5z/pkQk61tUaQ1Ov06+2KKS5Ti0E+SBqkF0rXSAbRbYVXyhpthen5I1oTqUoiTBTzpVhkfTy6rRNybsCX/56L/GHpi0JyTH+Q0Hx0FKlyuuhGWhwtFEMK83Vw5Y/aY42wKusekfRYPvvP85Oq/9za565paGKND3XZofKqGFDmVy3MTWSUrFC/NEtdmgdZaYMYy5kQty8clE7hXZlA9NMo7F1qMbWwRy5Dw8BUaSNmZ6Y2/d2KV9Ie2tUeNdfAPYDWRqSF17NGFgiLG6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Nov 2025 00:39:29 +0800 Lance Yang wrote:
> On 2025/11/10 20:17, Harry Yoo wrote:
> > On Mon, Nov 10, 2025 at 07:15:53PM +0800, Lance Yang wrote:
> >> From: Lance Yang <lance.yang@linux.dev>
> >>
> >> The hugetlb VMA unmap path contains several potential deadlocks, as
> >> reported by syzbot. These deadlocks occur in __hugetlb_zap_begin(),
> >> move_hugetlb_page_tables(), and the retry path of
> >> hugetlb_unmap_file_folio() (affecting remove_inode_hugepages() and
> >> unmap_vmas()), where vma_lock is acquired before i_mmap_lock. This lock
> >> ordering conflicts with other paths like hugetlb_fault(), which establish
> >> the correct dependency as i_mmap_lock -> vma_lock.
> >>
> >> Possible unsafe locking scenario:
> >>
> >> CPU0                                 CPU1
> >> ----                                 ----
> >> lock(&vma_lock->rw_sema);
> >>                                       lock(&i_mmap_lock);
> >>                                       lock(&vma_lock->rw_sema);
> >> lock(&i_mmap_lock);
> >>
> >> Resolve the circular dependencies reported by syzbot across multiple call
> >> chains by reordering the locks in all conflicting paths to consistently
> >> follow the established i_mmap_lock -> vma_lock order.
> > 
> > But mm/rmap.c says:
> >> * hugetlbfs PageHuge() take locks in this order:
> >> *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
> >> *     vma_lock (hugetlb specific lock for pmd_sharing)
> >> *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
> >> *         folio_lock
> >> */
> 
> Thanks! You are right, I was mistaken ...
> 
> > 
> > I think the commit message should explain why the locking order described
> > above is incorrect (or when it became incorrect) and fix the comment?
> 
> I think the locking order documented in mm/rmap.c (vma_lock -> i_mmap_lock)
> is indeed the correct one to follow.
> 
> This fix has it backwards then. I'll rework it to fix the actual violations.
>
Break a leg, better after taking a look at ffa1e7ada456 ("block: Make
request_queue lockdep splats show up earlier")

