Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F368FCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576B28E0016; Wed, 24 Sep 2025 06:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527CF8E0001; Wed, 24 Sep 2025 06:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF978E0016; Wed, 24 Sep 2025 06:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B54E8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:06:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF6481407AD
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:06:37 +0000 (UTC)
X-FDA: 83923714434.08.F577C09
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf29.hostedemail.com (Postfix) with ESMTP id E63E0120010
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:06:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="V 8qKL4I";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=DogKE0h3;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758708396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YeVmShso1hOIBjH1XRKo39NErYkmRiZZhQmNNqAXxRo=;
	b=TMiW7qMovwcdJCk+vk/IbDIaeCimLTuK5E6ha/C4dN1Uy9DBgWSVLPr2gKCNgCWrBAZudL
	QfP3UO5KJc46/n8prRRsk/70RaNwEPNM9bnNpW2a/KTFQlrhrMTUm/2FrfD+RdbVghYnu5
	LLcJR7W3GNryCBMRznP672FQAW7nE2w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="V 8qKL4I";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=DogKE0h3;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758708396; a=rsa-sha256;
	cv=none;
	b=fFCFSZCqV2UA7N34kFxWHjq9v2PwTOHHk7DcE6GWlRDIiumc+aYSKY5/H325VcU7jKxYQs
	FSqxEY5boEPMsMTY9SP1s7CJPkK6/U9UW/M7foHPWwdSXJkXNsuDTXZZDanKNIG32z3S9U
	WQFxYEYBOpEttPZ3oIN6qpBoM8SB6sc=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5A4701400096;
	Wed, 24 Sep 2025 06:06:35 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 24 Sep 2025 06:06:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758708395; x=
	1758794795; bh=YeVmShso1hOIBjH1XRKo39NErYkmRiZZhQmNNqAXxRo=; b=V
	8qKL4IcD3IaxYE3RXDH47KZz5qv0sVzwbQ4pFZIR8m6KkACQ2OsJ/tw9DYT8+K+H
	u6Mx3bJbdQHjoSS0iBFsGjT72OQdCV+6+hF0i/ISAJ0TkMURe927FtiEiDMURVx8
	WuxOwv+Qjp+jMFsxtioovPDq/B45zCBdU4iYzLg+ryMMXryTvD7vPoxRQyd1ydDU
	Upen78efQLTm1b2BtZ3wK6FCcczxZIY4RG1LKvxHFCKn5zLkp9zyms7DReAvETIZ
	UCzOZ8RC1WTxXH588fYah15aTuCcAkE5bSHEBUtqS+3FmdieBw4A7NWMF2PNdJct
	xa9V6XGv2DhyXmAtrxoTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758708395; x=1758794795; bh=YeVmShso1hOIBjH1XRKo39NErYkmRiZZhQm
	NNqAXxRo=; b=DogKE0h3xGmU8elEuDL68LPH/BrsmrWkD617JGZAAUHQ+s4EKFd
	961OAl3WNZAjlqwYOt+e2CSXo9zACLiq85oTXtWpz2J2UsnvlVdDXDSHc/0yX9zy
	ng3krvVjiiKp+qpASXyNxClOyki+zeNKYjEBVHAE6giB0sCRFIQbi9qHVF0rWc2Q
	w1VnFn3XqgE8KJJ1kQOTZYO567VxRFoUjGa9AuYKW+Wv51mBR0rwhUP/xmxwePgo
	QZ1oA8igiz6JAKgoNGpRS9RodFlI6k/o32vPN9bApwSZ1Un8Bd9U6rN9k31LFfwQ
	nYqu3O3ihNpATNMN2tkCGeMnNiX7XqTah8g==
X-ME-Sender: <xms:qsLTaKqq4mzqeH_x7AL1tswnt6aLqKMcrdph6fQ1YfVaIdfxerwF6A>
    <xme:qsLTaCVJHKACsegBZkf402Oq3oODyTsfp8iZbGa99LQE18kl4AVUpgtqJQD9yi6My
    JnHslOViXYraTBWGyZyocd5j5WgOP1FMFI2_rtKkFbW8b2PFWcZSw>
X-ME-Received: <xmr:qsLTaOijPxnF70sSEbTCpWHOC7w2B3n-dyHbrgrdV1PuQE7_WlUrKz-BEc0Zkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeifeefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfedv
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtg
    homhdprhgtphhtthhopehrihgthhgrrhgurdifvghihigrnhhgsehgmhgrihhlrdgtohhm
    pdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprh
    gtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgt
    phhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhopegsrgholhhinhdrfi
    grnhhgsehlihhnuhigrdgrlhhisggrsggrrdgtohhmpdhrtghpthhtoheplhhirghmrdhh
    ohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehnphgrtghhvgesrhgvug
    hhrghtrdgtohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhm
X-ME-Proxy: <xmx:qsLTaB9YPEfXWZcR0CXQ6KSVT8fHfRYkgCk5FpTDWPZ_8J_mgcKXOg>
    <xmx:qsLTaOSzOQcx2kQUduNP3K9bF-GCv8ZVBtgjv_eF74F7k6boAg1Jsg>
    <xmx:qsLTaGEUWhasl_63w3qGil6e_GJquURrnJW6idDu9i6VYfGiU6WB3w>
    <xmx:qsLTaKgw6XbB1mVhthto83zmwrPRbcepNU0h-RsuMJV_IBa_nO9Jzw>
    <xmx:q8LTaOnXOaLeadFQMAQ0SYILFGwzo1cu7cbddgzJKvD5tIBju-Rsm3Ag>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Sep 2025 06:06:33 -0400 (EDT)
Date: Wed, 24 Sep 2025 11:06:31 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [Patch v3 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot
 is !NULL
Message-ID: <viz42o4iscxkpxystnikuvfnqzwwfq3anivizgx5dncm4qyqvu@4kymskstues7>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
 <20250924004854.29889-2-richard.weiyang@gmail.com>
 <27storxu4seijr5smul3xx7pofe45ittjrchii3jtwbntalsiy@2cu3wf42drwa>
 <1ebbfe02-1cb5-4f7a-a640-68d5d95cb99b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ebbfe02-1cb5-4f7a-a640-68d5d95cb99b@redhat.com>
X-Rspamd-Queue-Id: E63E0120010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: bpeceqtx7c3jao97qi5dnzfqqwmzwxw1
X-HE-Tag: 1758708395-907404
X-HE-Meta: U2FsdGVkX18Esya4psVCWnRqjlmbgIXQ4fAVdUNmqeMkoQ32XBqft4PwP+u2KhQjiv76wL3ABWL/3OaQEFhEkutkhGHV8In2N8H2gv6qDf0NKpv0HJyryVmCSrN4PNSPKmi1qRfmKIPBy6cZ/bTsal5Kz2+KD8K3xu61/nCxYyVvVEMGEhBWCt+d4u2kyfL3U9TyEG368SofVxjuR0DSmJssOGLMY8Mb7xsbY6t9SNBdoHwDJRcKQKdk/9nTnmgiutqIAUPoB41gSs6uUeYbYqTnD3GPcGcl6VX6BQxZ7wMEP0k7+ElIDVyvX8K05qnmZ43NejvmqDmjfR/LGAZM/WzUAMieqDIjjFUpndLjVMvAnOTYFVJSZ4L6Hld0gNXksn0qFmaIoMJ9Bxw0rqvHDnjb7KHBBK7c6R62zllQG96iBYWs2UNiRvCLUuyc2o8xGAZbuB1Tmw58e/AZVGvAIOR1ET8ZyzsPLdVtqYeNJkRNK5+Gjsh4sLlbOswQ7v8AYZItvHtPlVm6mWX0f33v/QgjkZ9uk74MOo5g+OfsV0zzC3MjGamggrC8Qpehcv3WO7Swvv4qbNE9Gd+U0+DsvtfHfZtq7OzbqAwBQk45+RoUzuq74BR9LMaRTbRGQWW7Wm5v4BVnNhpxyhZjPPOrX5J+EgKHyyalcRINNKiHx8tmnnRl9oa5CIWbmzS/kCbT5tg1BkbhiCRsiYAut3edsr2lYfnSlK6mtJfP1K1+nbwftA7gMeuBmkwx0kQNQe0yJpVpGUQe9CwhTmDxaJLb5iEkR17T8DHDU8H5HRg3H+qNRWJX/3oYkNs7SOWREGrmVvyyepOODFtfaDSxM/iBRR8lSEpuzPV57yvPXmainSheoBhRGuKgPjW26aHmtMGeTN0YmsoMYsSNj56AVVxyQFMgBwMeXXknLfSI6LLjnNeT1kJsnFdI15kc7m1ZzlbxOxKygR6NPI/TC0JgWtL
 IVZvJ3lt
 aQJxf9GSPz7159VSmIhPRrMiGbIJLggMK6Xv4x2vswn5Z8hzancwybVwYIFcH/7wENbAUEt5JZPzxI6pirlPrekTaRxMHLv6kmpVefyTdiEPbW62yzYZOgyCbvVHzabo8S3XfwmjCkyFSzx3fq8WIV5m5p0incsllgUh/xjHJ3Plr76TtaEj34CuwVEpSBiiCTd7h7Aa8TLq4F2AOCiFTxxrgwTWfQFOGQKicqIs+u/H+7PJ0cL6Q3afC1QQ6H2F7gVgeqog0XuLWa84h8HHrjnW4tWB0QatHfLRt6HfFavLaiKyXHRjtO0qtrXjP1FmA8vn6XX5VqyogrYHg95ofmammBKoww37wxjiTlHQjA5CN7VrbuF0EJACi2nmcmo7rC400h+aUNHPo5CvHSJ9PazWyQZ/iGSAs+0XyG7onfhVFT/PVNg2oFs7LAEtk7QRZWUohacGsOD4PwCTaHo68wQm2OMCFqbFeOLG5u87GNuVZ0dV8j5ex8Qhn0PTJgEbRmf0FzKQ5YSpLHTVC0WRzW2TT+T7yO/WpqWneQQXubqMPusMms2nY/M8GbsYoWTmpzdw/q4X4D80t9+CcII5bLZPVsfqezlx+lmhrVvgLMkaNWy4aajxoGh6QEJ8vJB0fCMqNBuda27dSDoWuV38V+zX+zXMPzLo9askjDVA6teP090gp4OVSGu56TWlM2AGOaU6MNW7+4rz0f/ujhaipbVYQm8jlxYnA8HCVpabEw9A6SL+YUYtmsPLpumD3ly3694V/lRqUpHlkX/vBJzvWyDh5xFmWw2hT8Mu+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 11:40:21AM +0200, David Hildenbrand wrote:
> On 24.09.25 11:35, Kiryl Shutsemau wrote:
> > On Wed, Sep 24, 2025 at 12:48:53AM +0000, Wei Yang wrote:
> > > Patch series "mm_slot: fix the usage of mm_slot_entry", v2.
> > > 
> > > When using mm_slot in ksm, there is code like:
> > > 
> > >       slot = mm_slot_lookup(mm_slots_hash, mm);
> > >       mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> > >       if (mm_slot && ..) {
> > >       }
> > > 
> > > The mm_slot_entry() won't return a valid value if slot is NULL generally.
> > > But currently it works since slot is the first element of struct
> > > ksm_mm_slot.
> > > 
> > > To reduce the ambiguity and make it robust, access mm_slot_entry() when
> > > slot is !NULL.
> > > 
> > > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> > > Acked-by: David Hildenbrand <david@redhat.com>
> > > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > > Reviewed-by: Lance Yang <lance.yang@linux.dev>
> > > Cc: Kiryl Shutsemau <kirill@shutemov.name>
> > > Cc: xu xin <xu.xin16@zte.com.cn>
> > > Cc: Dan Carpenter <dan.carpenter@linaro.org>
> > > 
> > > ---
> > > v3:
> > >    * fix uninitialized mm_slot
> > > ---
> > >   mm/ksm.c | 22 ++++++++++++----------
> > >   1 file changed, 12 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/mm/ksm.c b/mm/ksm.c
> > > index 2dbe92e3dd52..c00a21800067 100644
> > > --- a/mm/ksm.c
> > > +++ b/mm/ksm.c
> > > @@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
> > >   void __ksm_exit(struct mm_struct *mm)
> > >   {
> > > -	struct ksm_mm_slot *mm_slot;
> > > +	struct ksm_mm_slot *mm_slot = NULL;
> > >   	struct mm_slot *slot;
> > >   	int easy_to_free = 0;
> > > @@ -2936,15 +2936,17 @@ void __ksm_exit(struct mm_struct *mm)
> > >   	spin_lock(&ksm_mmlist_lock);
> > >   	slot = mm_slot_lookup(mm_slots_hash, mm);
> > > -	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> > > -	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
> > > -		if (!mm_slot->rmap_list) {
> > > -			hash_del(&slot->hash);
> > > -			list_del(&slot->mm_node);
> > > -			easy_to_free = 1;
> > > -		} else {
> > > -			list_move(&slot->mm_node,
> > > -				  &ksm_scan.mm_slot->slot.mm_node);
> > > +	if (slot) {
> > > +		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> > > +		if (ksm_scan.mm_slot != mm_slot) {
> > > +			if (!mm_slot->rmap_list) {
> > > +				hash_del(&slot->hash);
> > > +				list_del(&slot->mm_node);
> > > +				easy_to_free = 1;
> > > +			} else {
> > > +				list_move(&slot->mm_node,
> > > +					  &ksm_scan.mm_slot->slot.mm_node);
> > > +			}
> > 
> > Indent level gets extreme.
> 
> You call this extreme? :)

Emphasis on "gets". :)

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

