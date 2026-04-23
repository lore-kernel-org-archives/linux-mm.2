Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB73FC0342
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 15:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 369366B008C; Thu, 23 Apr 2026 11:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319BE6B0092; Thu, 23 Apr 2026 11:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207EE6B0093; Thu, 23 Apr 2026 11:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D3736B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:01:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 827BCA025A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:01:13 +0000 (UTC)
X-FDA: 84690133626.14.DFA5FD7
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf28.hostedemail.com (Postfix) with ESMTP id 18D11C0020
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:01:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=h5ORs0zr;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf28.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776956471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOqM+aFQLBWzHVmpig7PQVTE08voNvYM1pNEJGXMJn8=;
	b=ugpZc420t1THRn6z1pfjuxPhRBDs/J4IO+5BNyGwov0EwCMyXEjVpxyr4ZuPW4CGNTWLDV
	pnYtVuPt/H1N20Ivq0DtuRGR3pfjblbTHdgsWlF+Zm+HZz4Tdm4BRYf5I3ZAA6qh+ktZHr
	xKnC/NEbr57JnIo+AH7MzKiOWXy+xDs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776956471; a=rsa-sha256;
	cv=pass;
	b=0hpdDsoLMOey3vpInbxwukUwSQVBpPyCqpodcLE3UcHVR82D/GRfaoXdJi2SFrBGmj3Jv5
	ueqoFk/Jxt+ei+bTHgps2Mi559Saw2mcTIy7PGy2FGS4MdJGROarkYd+E6TuQdZMutKhqs
	fv8iwXPQ4wYs4r22gdxmpyXLmoagb1k=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=h5ORs0zr;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf28.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Seal: i=1; a=rsa-sha256; t=1776956449; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=f9Fa0hJG9XbpXjbrl/huquYVPvJEoIVk8aM07InHvF2za7EFfPHHeLuik+te1Jv+CqmCb1hdPSIDya7sE9JoSn3AoVFrU67127+thLOKaz5W1qz/Sly4BRTykUY4eyUrdQeqAbReH7Xadr32bsNGRRjX614D7BI293ZERqA8OdA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1776956449; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=FOqM+aFQLBWzHVmpig7PQVTE08voNvYM1pNEJGXMJn8=; 
	b=B78SBc0y937mYeZuCI9CsUq7ahYWuqt6aF8Q3vryRc5+99r4NsqyJ+uoUaA5TfHyfotIX3mT32Cwoi9n1sRnPOn/goi2y66HSa4YnPnBL4CuXBRg/PhGUJYDWmA6ok+BF9Cw54w9l411xKCtUQnw3cffhd2Qum3uEKdDJPtn2Rs=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1776956449;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=FOqM+aFQLBWzHVmpig7PQVTE08voNvYM1pNEJGXMJn8=;
	b=h5ORs0zr/STu0s4fmk0vhcj/mf0hRRJ55QYSfske2QQw37wG2nhCp65t+ARahlOT
	Ds6ZjunE1Qj3J4djnFpROQDqiioc41gwivrvxzpXeZs5z9auiKAlYSMP8PVXHFaBQBl
	Y/FrWiUMi3BwnijysP6sdr5B/YZSz3+oMq9Wz29Y=
Received: from mail.zoho.in by mx.zoho.in
	with SMTP id 1776956449233107.34930946984957; Thu, 23 Apr 2026 20:30:49 +0530 (IST)
Received: from  [14.139.128.34] by mail.zoho.in
	with HTTP;Thu, 23 Apr 2026 20:30:49 +0530 (IST)
Date: Thu, 23 Apr 2026 20:30:49 +0530
From: Aditya Sharma <adi.sharma@zohomail.in>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "linux-mm" <linux-mm@kvack.org>, "akpm" <akpm@linux-foundation.org>,
	"ljs" <ljs@kernel.org>, "Liam.Howlett" <Liam.Howlett@oracle.com>,
	"vbabka" <vbabka@kernel.org>, "rppt" <rppt@kernel.org>,
	"surenb" <surenb@google.com>, "mhocko" <mhocko@suse.com>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19dbadba1c8.6c77377a35913.4863321564078678922@zohomail.in>
In-Reply-To: <19f5f950-d0f9-49c2-acf6-7b0ab277ab23@kernel.org>
References: <20260331142936.229667-1-adi.sharma@zohomail.in>
 <20260405171834.15971-1-adi.sharma@zohomail.in> <19f5f950-d0f9-49c2-acf6-7b0ab277ab23@kernel.org>
Subject: Re: [PATCH v2] mm/memory: update stale locking comments for fault
 handlers
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Queue-Id: 18D11C0020
X-Rspamd-Server: rspam07
X-Stat-Signature: 4nd95zssbw4pjqd5qgecawigz4uz7mux
X-Rspam-User: 
X-HE-Tag: 1776956470-967545
X-HE-Meta: U2FsdGVkX1/GoIy8Mq2ljIDsMi5Be+cVUDiSBuqO8zC4a4SvhRTXudIS56AuN+U4WWVrbITw1yaGVS5q2nUYujxcXRmu0k+XIt21HzyS8iyjkBG5VcnU4B60RYRSkisWkmvoldAWqGr85iUXBkHw7YWjX78K4eZd2CbtWacQPMoLtiH22aaV4O7Jop4m9j07tQK1yf7VJQFCyy1v3VJjsxJNfrrk7HF6X/oOR4kbg0Mt2RUhTLUnu2GuOqJD3+/epm5H3iwaFYyrpE0vFGFGnbCdRyE8xlIR+5JuhOwiVUaiFInHAsx2GQu79jPRQ79xfuYIZ2HXUHUgq2eBhVMlXOWMwtB0i4Qb8WHTX0SQZR5zKLOFF5y9DIJcSKrAWrCm/Cf3BJgA0RC/8q44zedyRcXlhWXtpPrjrGl/Ac3JD1SRVY4F3NGK3bVI/6tb19BnR9tEVr1lNOAs+uiPU0lV9oWHeCOuHsii9SyB/QY4GWFT2XGGNaXzFNYdKSJPRe3aoR0FvJXuWXlJazw46MksG2pilcIX1uXoAWi4JKhkmdiMnHNGSB8BPj+u80yGpx1EJCvLS3vSAKCBlbasgguwhUT6lWwncMBUF6ZDHC8/KFgFEjWufG4KTmb+nxkJxeceyFNnyq9vLV7fShFlx/4ZBzCBpPeS5rRUy230UETzHalvuC3G4BfdVx4FzxOKOT5t27RWlPctoP/ZgOBCJtLi5QxJs7CUyYjk+CEy9Ud7PABh25JrejIrEfSSGZU6iQyNjTp4+UuILXzC7vdFhzCqpZMRvLgjHWbh52ldo9g3euOsqNTKSdpA32iaYIgW6EKIv84CVlgmge0trHYwEKCkDBeFv0Z0UKw/CghiVKzKfMbb2oYDfj7v9xYRhZ5ruo9Op6ALLXF6p+P8o3noJNN+TESUm7GLOqqnUMlnSU838bPH7bsV4kLWPSOcR2bWiL2+1z8wY+rCr3LZvDUaHjf
 wb/SYrWx
 dYBL/PHfUmlPz/gjc7VdM4DjfHeSnH1pqT+lFsCTX8Rd8uiRDQ1R2B3rJ/m/9IUhB+17MExWDxBocomCFPAzVxZAIUKXAWtVozpv6Dg3yEx++px3upidXyVwy/2AbrDeHzIp/HplRbXHWgEnkl1EgYZmDZFWUeKEq71ce7d6O1NY3lC9vqxgyTVW2m3ZdB/jbz+GnPMVxq6DCO1lgHNPgxSUeRxOB06ybjKpLpXuM2ziuS1ygF/QWvFAgkYzk4ZpUm8tm7S/sd5JZ4jSR3F+oA5IboFByU2u6IwYHnJk0UdnqniMMek6EhOBxRvZYnHWAMHG7lq7YkcHzvxRJxCA+1vC28kdCgPpM+aUzCZBnBMrN0a996hZaAdfIGhxLVyB7+btWzq1whQSQ1J+DImQHObb7Yb/iXqOl/faG1Xs4xyfb/y0TYArDZx6YLqlhL5+LvVb/CQfEnl1girxdtjKZnoPEXCJ3EVMv9s1zxmLBoZjRdIZAljexmqtrk/2gONxqE4VXBZD9eOOfy6+T8VlfwmmkcUUP5gdE2GUQiVCPqCUqIDEgjNyMgzOUtG5m7PEHMJF+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Understood. Will send v3 as a new thread, not a reply.

I'll apply the wording changes ("held" and "see FAULT_FLAG_VMA_LOCK") and send out the v3 shortly

Thanks,
Aditya



From: David Hildenbrand (Arm) <david@kernel.org>
To: "Aditya Sharma"<adi.sharma@zohomail.in>, <linux-mm@kvack.org>
Cc: <akpm@linux-foundation.org>, <ljs@kernel.org>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <linux-kernel@vger.kernel.org>
Date: Thu, 23 Apr 2026 19:57:21 +0530
Subject: Re: [PATCH v2] mm/memory: update stale locking comments for fault handlers

 > On 4/5/26 19:18, Aditya Sharma wrote: 
 > > Update the comments for wp_page_copy(), do_wp_page(), do_swap_page(), 
 > > do_anonymous_page(), __do_fault(), do_fault(), handle_pte_fault(), 
 > > __handle_mm_fault(), and handle_mm_fault() to concisely clarify that 
 > > they can be entered holding either the mmap_lock or the VMA lock, 
 > > and that the lock may be released upon returning VM_FAULT_RETRY. 
 > > 
 > > Additionally, make the following corrections: 
 > > - In do_anonymous_page(), correct the outdated claim that the function 
 > >   is entered with the PTE "mapped but not yet locked". Since 
 > >   handle_pte_fault() unmaps the empty PTE before routing to 
 > >   do_pte_missing(), the comment now correctly states it is entered 
 > >   with the PTE unmapped and unlocked. 
 > > - In __do_fault(), update the stale reference from __lock_page_retry() 
 > >   to __folio_lock_or_retry(). 
 > > 
 > > Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in> 
 >  
 > Next time, please don't send as reply to your previous version 
 >  
 > > --- 
 > > v2: 
 > > - Simplified the comment to concisely state "either the VMA lock or 
 > >   the mmap_lock" instead of a verbose explanation (per David Hildenbrand). 
 > > - Expanded the scope to cover 8 other fault handlers in mm/memory.c 
 > >   that suffered from the same stale mmap_lock comments. 
 > > - Fixed an additional historical inaccuracy in do_anonymous_page() 
 > >   regarding the PTE mapping state on entry. 
 > > - Updated a stale reference in __do_fault() from __lock_page_retry() 
 > >   to __folio_lock_or_retry(). 
 > > 
 > > 
 > >  mm/memory.c | 49 ++++++++++++++++++++++++++----------------------- 
 > >  1 file changed, 26 insertions(+), 23 deletions(-) 
 > > 
 > > diff --git a/mm/memory.c b/mm/memory.c 
 > > index c65e82c86..2b407e3f9 100644 
 > > --- a/mm/memory.c 
 > > +++ b/mm/memory.c 
 > > @@ -3742,8 +3742,8 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf) 
 > >   * Handle the case of a page which we actually need to copy to a new page, 
 > >   * either due to COW or unsharing. 
 > >   * 
 > > - * Called with mmap_lock locked and the old page referenced, but 
 > > - * without the ptl held. 
 > > + * Called with either the VMA lock or the mmap_lock (FAULT_FLAG_VMA_LOCK 
 > > + * tells you which) 
 >  
 > "Called with either the VMA lock or the mmap_lock *held*" 
 >  
 > Same for other cases. 
 >  
 > Can we shorten "FAULT_FLAG_VMA_LOCK tells you which" to "see FAULT_FLAG_VMA_LOCK" 
 >  
 > ? 
 >  
 > -- 
 > Cheers, 
 >  
 > David 
 > 


