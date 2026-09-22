Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD0C5C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50A86B009D; Tue, 22 Sep 2026 11:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00456B009E; Tue, 22 Sep 2026 11:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EFF06B009F; Tue, 22 Sep 2026 11:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 688B56B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:22:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09ACDC0512
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:22:32 +0000 (UTC)
X-FDA: 85241764944.17.01F901C
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D60B40005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:22:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="SJX/H7z8";
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790090550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+asX9Eo6V++D4JgVVikE/NaNyUA8WkaRzRJh4cn4hpM=;
	b=gawfvS+OUzpp94uMwBLcY6nl8W4EUmo60CzNwS1HL/oe4VSYkFh9Id942/41C+8OS/U60U
	mOD2ACJVGw4x8Pe2Xr8ojRDUGU1mSAGp4BE6/rSBm/tY8oytUyo7UHou0IaBram1t4PMpn
	Fqxcqc/2NsGWvmdKONnFswcykwSat08=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790090550;
	b=uNt0wZLE/B1z8f//310JODMMykmIszXosFAWOUFPtJfc5yzMIT8vTTnHEp3H0W8xMOZbAa
	r+gONCvvzaCzKG6oSDNVyG5issitK8aYoi2wjjDjeShRCvAu5e6snNAWik4gbn6gaG8Axs
	7xfQoBNgOQUuPlJPG8IZqTq6VNWHp6I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="SJX/H7z8";
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-9104e54b1abso105406d6.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790090549; x=1790695349; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+asX9Eo6V++D4JgVVikE/NaNyUA8WkaRzRJh4cn4hpM=;
        b=SJX/H7z8PIxmzfR48mL/TjS4Pe2BwPTugtpd6nN+X4gkJPf1oVi+4HsLPnJaB5nHoU
         109gmdWI+VALYgwOsi47JW/be9GgmQ6cYW5vg0vpuraE4qqug3TgakJie2k48YCBNGqA
         ssoS259+V8ebuoU5P5P7BrCb2WttVbfmLKe8515llyG5BB5LnLP4lglEnWcvcQUixDv7
         PSHGYSRAUTgk/AS3IJydx4n8fIVuUkZobCKAy4see3vIwVVWT6NiCieDfRZhbWXbcXqi
         V9106FtzYgS9zpnQ0pGEHuUcjK5C2uIKbKom0+/l4xVc+YYVDaHfPMi6AJXSAkxhKaPw
         G9WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790090549; x=1790695349;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+asX9Eo6V++D4JgVVikE/NaNyUA8WkaRzRJh4cn4hpM=;
        b=yrX4mha35Fzwg4NpTKJ1rzaG/iHo9UCo75M+9o2x5nXN6FGPSia+5XUqE0aZN9jmsY
         eyebmtPxTixEIhIs/5+chhnlgbAqXoY8UDa4MsW8GE3KaviZIW56OI1X5++V4FnglPIx
         F5ZCVp2g4BGsvBIHuYFMm0cOXKLsigV1BbEvVLD5B6sSXFCGL9L2cgdpqKetaiWZoLGQ
         6uHwkOyvRdXvAgNb6+A8j9nmXaPjWhVF7d3lYfN5T5QKhAdmB3rY8yKghMNokrH/499v
         SuS0ggvpcwaif2XqxkwYsqxU7ALFs001yN9Meh4ZqLV3956KXV4V4uU3Z/P5unVI8IRU
         Fhow==
X-Forwarded-Encrypted: i=1; AKwUvBzoa7YbRuPvA9rXjKqBd6PTE4ef28A+k3rC69K364QZSOfqfisnvqTF2PKo8FjDJWqd17KpT1DPOA==@kvack.org
X-Gm-Message-State: AFuF++nurIiJp7v9e9zVRM1Ilg7cUwdQIsdXoWvckMxXC7EwwSRGF1gF
	9LE287+u5r+WvUTamKhdUPodhPNJwfMuCP68NkWvOFRszkbUVDQD+p2yQSVcWPsbt+I=
X-Gm-Gg: AYBFou1ckVBZH/lFcghv2W3ONVmUQFcb2T8b7F7Zs01wQebw0UGlrsdJ8Zb9uf4wURu
	mAhRnK0Aihq0hIFgwvdWb0yl3/rkaIZtJ9U0Gk4UOVFhR1AO21iKwknz9uJbJ7qBudjnRIYi4rH
	disLlPXYjUsYftRseLpGkBh8gY7wNcPkS1cbSBk/gLSFz+B4qLkiMo+C/9yTb/+2HTbisNr6I79
	HoF+GT51GyuCGt2QAUL/WqHMuORR0kfKhPDzChTKaJOLDTnVkbiucKDRtdm8F0MJIdA5MLIansO
	XqxZhJRG3WnbEn7QGEm0br3hJ8FAWwgVni8KUFsFd+6YFz/USiGYxOGrmiBzDxY3NMDQ4dbh2si
	MjuMvvMr/QMUmGkjivxins/rlCM+0jwrPh7enw6SQIK3GAPDps8x6jLJ5Pb/tbMp39AjP/HYF8T
	qCOHEy4LRQMB2Nu0JarVCRQ0GprjRkerCrCjotvv2Bqo72REENgEIAmcbUE7apslBc5knqqYWNn
	lfYib6vnvsRBx7CnO1FEq1lRezmHjJ5bWs0SNzTwGfZQDlFiXhc8tDQK3ugZHqNsw==
X-Received: by 2002:a05:6214:8501:10b0:913:ffb2:e8da with SMTP id 6a1803df08f44-913ffb2eda8mr33729806d6.36.1790090549126;
        Tue, 22 Sep 2026 08:22:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9140250d233sm18031886d6.41.2026.09.22.08.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:22:28 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:22:26 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, 
	willy@infradead.org, jack@suse.cz, liam@infradead.org, david@kernel.org, 
	vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, yosry@kernel.org, chengming.zhou@linux.dev, kunwu.chan@gmail.com, 
	tz2294@columbia.edu, hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback
 completion
Message-ID: <arKdGMrUixIb4spc@gourry-fedora-PF4VCD3F>
References: <20260921152449.629486-1-alex@ghiti.fr>
 <arJYmwKnEu-djZlK@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arJYmwKnEu-djZlK@gremlin>
X-Rspam-User: 
X-Stat-Signature: dw63ydkub5ytecr3dsmii6xa8mbqh5pb
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2D60B40005
X-HE-Tag: 1790090550-475376
X-HE-Meta: U2FsdGVkX1+e7E+zM7QVv7AF/451i2acvTAU40HM1pZFigWiOLgNQMosepktMHFdSswZl+TpQYWHKv0U/LzxW9nlWqkKze3JheyUs9nepeFz92uMwJtY9pNtJFCt16MA5EUltOOVVzJASuvJZSFM9B9DFpAiTig3V0zxy70h+LlIGrYjZn0JH4DcX+zONF3LpoyfBWMJ+TzS1GVz8W9SyztUswfOKy0uglNmmgbfv1ViUZ05HSeOqImMiuLKV9Bzz8Vp7GM/7qIExlUoXBAW65aoZNEc9e9rR2u8NAwvCqVvzXKG/B9WQgcSwmxgRwmx6z3dd6XKK6bBiPRN0U0kIYrG6vEWXadheDqxtsZAcYvx3qhaqQpOhDXu3TGRzuRKaQwVyly8ovyjzC9V7IhGEA7GOoFGuN/CgxixD8D21RrPdnv/J8SQxS/kr5D26o3YjYFqqAe7LHvtzdMuWr28jJ9lAYWAf0CWO4NNliAWmi3VN5R+6mVNkK77VRS7RbU/9ElINGgETmdNXWbDjOZyLcuF/JWidvrieVv/fsgYByfyiZoXACYH2dLpUo4UElfiN+BU7VpmYwAjE3iKxeUEn35oBaR0PKjDVYHkfo82oe/8xPgsN8mUaemgfiiXI8j/sROvsDlc0VTaOjH8pagVI55rxutyohteOnoK4vCIPstaa7tB05Ue/NLXixlr+bLXc5UZGluoRlovcePn9OcYl2gW06QXm0tNN2KK85wo+JYFsYZT9phbFxYZXW/rVnP93Xor3Zi9IBPWEWwcWir4LBKFyMkMbynXZsu6X8qaEuQjecNUfhEWYeP/bkSkqPjmG7tVc4sgyvz8nEH5FotjLmURQgbMGwpN0cdXdvI/+ujhSY4PGG9qE4tTVOmBvo9QCZTEOpXmwoEMsTymcAoLHP4uWJbfHV4Y6L/Jfi9OCoBorsuioHA2GS1SM+FjGHPTfPkMjRlvNNe6BFxVEde
 ToBe9kZ0
 eVnP2POSsG3yZsSt7evMMIwJSTRD7XgWWB66qcJDQx9mEc5DlqNm2sgiMMiZtzYPnRnEytxzMHDgA+NbUFZfOIogpPiD5rcHRxbx/Ewzf14P/E/XwJd+owoTPKJO3lQThEIdGxczF/uEyBZo5GdpdwpfSUOkxD55WPzvq13Iquw/rh78aRO8eBr7RJfWk8mnnMFuAQvMzccn5BuvUKgV1qVZulzgapegvK9yYmfOJPvqWP7p4h5fne0M+l/BRlMOkJFyr3RLDpJ8yK/ZnqT8oGTrTk4RlVZ0DB/P1/4GF4gpmQ955ILI1fnUOC83t3mlcCC+ToCWMYdgbFHEWOvyRIBDpko0qxIrwTypVBjplpIoo6q7G1ov42nv9PqatoAWj2sTu+OZvh7Mg/c+ZIZQ5JUw78T80UtBnM3Fdv1wnpUHug0CEi4mQC4blfaPGsuw574F239OfHZWGgCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 11:44:20AM +0100, Lorenzo Stoakes (ARM) wrote:
> > @@ -554,10 +567,12 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> >  			folio_set_workingset(folio);
> >  		if (pageout) {
> >  			if (folio_isolate_lru(folio)) {
> > -				if (folio_test_unevictable(folio))
> > +				if (folio_test_unevictable(folio)) {
> >  					folio_putback_lru(folio);
> > -				else
> > +				} else {
> > +					madvise_mark_dropbehind(folio);
> >  					list_add(&folio->lru, &folio_list);
> > +				}
> >  			}
> 
> This existing code is utterly horrible can we maybe do some refactoring before
> adding yet more functionality here?
> 
> I feel like the 'pay down technical debt first' take I had in THP is pretty
> valid here also.
> 
> But also, yeah you DEFINITELY need to separate out patches here.
> 

I will post my refactor today, sorry for the delay.


