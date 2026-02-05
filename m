Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F0BCEC1EA0
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879116B0093; Thu,  5 Feb 2026 06:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8306E6B009B; Thu,  5 Feb 2026 06:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7597C6B009D; Thu,  5 Feb 2026 06:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 633836B0093
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:18:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 030C358EFB
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:18:09 +0000 (UTC)
X-FDA: 84410153940.04.AEC8CAA
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 477BCA0006
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:18:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TRtTsc7L;
	spf=pass (imf25.hostedemail.com: domain of 3bnyEaQkKCMsr2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3bnyEaQkKCMsr2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770290288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z01yRtpRz+f8+vWuZfwZd3Dwpe3AoEMaMACYc8SLy3w=;
	b=0Vlzk8rNf/g48V2fyQIUocEdLCYu2dIRYSBcIDRNZWg351BbmpLLFDyR+hud5YrkTVYTI1
	Pe5trq1KaJfgIZ7bMmi87K14svKRtU4wwn0ANfD09FlQg1cotcUGljLsg7ti+/3iez0NVH
	+Gh87DS6anMDNtPeYqYB7Ku+HxtFAfc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TRtTsc7L;
	spf=pass (imf25.hostedemail.com: domain of 3bnyEaQkKCMsr2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3bnyEaQkKCMsr2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770290288; a=rsa-sha256;
	cv=none;
	b=bnBIxTCohwDrDCsTuL425srax5cD5qYvqqQLzLp/wfJj6mLGIibQuUlqkgVxKu+Tfn7aZz
	Dw5MjYnlUkFrZ/iho7XglUMJmin0xTXjBWFdJBsywG2+KaDA36UMGRX15rsd/548QJNKWT
	MRPnAiO2XBByeHHCS1qYgOPX+U2xGRo=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-480711d09f1so11089245e9.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 03:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770290287; x=1770895087; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z01yRtpRz+f8+vWuZfwZd3Dwpe3AoEMaMACYc8SLy3w=;
        b=TRtTsc7Lf4qLOPBBKyn70yjEzArrXiCpxNH/tKoexYdy2F9uPERHfNHm/1p69twKDt
         j0o51Rdovob7xam2OOfzcnkx5l5eZD2kN7RnjVmx4OPETZICiIbOpsd93MRb02+zc+4F
         yg4o1NrHvHfGolpVJIcRGvrgADV4TXZKZHRAdWU2ICaHPiC2ikWfwQOjVSyWbsFNGdR/
         hvt7yqPGmyDAxyspg9s3yUq59YmebZOUjCCwuj8+5l+ODmFNsooFbbBR4gL67k0a3I0+
         iRwWdlumU4dbvw27Bnb0sLcl1UQBbuyR8wHIu/yr+l4NHaeP44R2VpmZP4drSWfbm1tI
         lm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770290287; x=1770895087;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z01yRtpRz+f8+vWuZfwZd3Dwpe3AoEMaMACYc8SLy3w=;
        b=jDvnph8rDGzPFfPDA9xW66uH6/2fdJN+7X5DkZKNpp6KuyB/b0GXVm/ACSSpCTSJp8
         bRgwwcqimYxM0mcQ7TzD/FV7J7J8OHNiBiNbFWiyrvI829phfPwjmm5uMtJgM6hMsxqY
         7TiVgYXOe1JvnF8poOXA1jki5PivSiaQLohnt7X08P+wk2QRqIULHEksCOtG2OJlBkyS
         MkdcwzRZMSiBLLl2hWrWj2x7y5E+uMzb9QpGB5ogqr2fFVUnBXmgvWcHuRiJtlNViARx
         XvG878airFUHBycg5PxYab/iw6lxDQ88HX/s8vrUidYpF23S69akzVoNTJjIPonDlF4Y
         MNFw==
X-Forwarded-Encrypted: i=1; AJvYcCVvZj1NkS7rVGxuzk6WBKzg05WEkT1VrmB2Kt9NboSWrQ05MxAp5qcFXxxdBXnT0hhXOXb+CfSobw==@kvack.org
X-Gm-Message-State: AOJu0YwkCyImznefUU4SP5c4xzQXVgYiL8noaE/tFhfy9kXvC8/Re+h2
	3OD0xA50xcY01M8UYUw2Cl2By8C3BrJIkYJql6kBoCC7XB5zP+U4T8vD/KiTio/A4vNZbWkCdQR
	NRnRq881CRcYumpuWbA==
X-Received: from wmbjt17.prod.google.com ([2002:a05:600c:5691:b0:482:dff5:2424])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c1a:b0:477:a246:8398 with SMTP id 5b1f17b1804b1-4830e93ea4emr80378215e9.2.1770290286698;
 Thu, 05 Feb 2026 03:18:06 -0800 (PST)
Date: Thu, 5 Feb 2026 11:18:03 +0000
In-Reply-To: <2f908340-a983-42c7-bb59-2d6f3a80c834@kernel.org>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com> <d3dca137-2e4c-4a1a-bdec-63cc2477bfda@kernel.org>
 <aYR5J0ip2MdD3nMP@google.com> <2f908340-a983-42c7-bb59-2d6f3a80c834@kernel.org>
Message-ID: <aYR8a09XUh74tg8l@google.com>
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
From: Alice Ryhl <aliceryhl@google.com>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 477BCA0006
X-Stat-Signature: 8dkbucg9ajkftrhq7rccxtniqb5e1ieu
X-Rspam-User: 
X-HE-Tag: 1770290288-886868
X-HE-Meta: U2FsdGVkX18OoqBauopbGqoWuZKNYZT67m200TTQI3HoEISasYkqwCUg6TW00vv+B0iNncpfQY7k6vy23MJp/qlBm52IsYOv6QYRvyBjjUZviIOrzv5BqqgYXVCYcTaPmTT/9uZInX8y4TSnj8nYUBNKlLj57GIpFGPZvXsRTWRQ6/kVkWJiWTBD0fB87XA37bI7i0sb/ei0aLlnaHIIcaXpEBe/bhErbqXxycGAoz3tfby9ZgvaxVzyeSyi6ViPCxgs8nKLNIDHJJj06isfCM7S8FQnRUmHGKF45aeV6yPRZ+uPGf8GmP80bp0HSL+k44GL4+vXVzjcnNtFpkUURhZ+IMt8xgVCGdgxhqrkcyAmsc1PTVU6S6VSlAUqV1lVP4lK1CmYmhpctNPDNnFv/1NEIy7Yjc/C6UFS4OdY0Loj2fxRQ1PlXZhl9gcqiVbnGCToDQ9ZfHxkprx+ttbhjdz3TwXSVHVq+xtH6kAxmynOko8Vs4xx/H1i9BqS2C+w89qSVuQL95swEjTUaTK0QiDgiuejhhPok4BjJOAjjc9DtxLVmYAolJ/9P3dsB7uKhiNFTnrgD+JnH8NoTW42JPfD775SwZeQBUwwKE9/kwS479xwrYEWgrigWvYKgrXi1M/VzagziMKd5vZzyo7Ah51iiqhb2XB//L6E6tDxWd4mWBxhAyEduG5WB0pg4mIAtOXC+ia2z24ODmzXoudGm3OE99g2ekwWrRLrUdRndy1ukjHKP+CKoCoxGklHYYKT7GAzw5WszfYhh4O3eeeClqIQ5bgRPAPPjeyjwrBTj3glpiuh0/IJc3KFZuX8rGPBsZpiGB9OIZID6A7TvscoX3C+dDOT9ORNOBSXZxykPJX2Jv9B4/9WtNeeH3/g7AGYgIhzAt29E2pP9UaSN6oQfFApdDabFoupvr2ehSNo+Bq4suuK3wlo0AptbMKEPGxXm45Or8W57a/GxaOn7NY
 8rqOu14W
 ZK7l24HTQwL/78YDicV7VV3DqfS5lIXMNW1r4Alq49QHzTwK8ihya8J22BEoKSBV794gRDZmDQoyzBE0w4X0ER46oXVKxy5vbM11NOI4D89oPbJctOUJpIQTj/0t4i0l0uA92Z9vh89aG1U0fKfo5tzWRds7DcH9n7BynrjchZRl/C1vsOBEsVyoYCen6JkRzsLy0kHm1bqm7JIjOn+dyaxa+nFnPt2HCeukNqJ1n9q2AWc2FbvLBlViewzuMyVDfA8a7Rwb8JQcjRi07sqy1x2UlJvnpMhIhRJs2UIFuocArH5jBqdBWBIwzp9H7CG8GdRIbxS7xmWUBGPtVuWv9Yk5/iY5yj8EP8+WJPUzmNJjVG0PjzswWtNttk9LZHDou/cbosiFA2wKOJJfG4iTQoFoPZUxN2DGu5kVjBraMmuPoYQoWWy+l6v5oGSgV/NbTwIojmMNmVF7dAbnNTqyC0YghZ61+66Q9IeN+yl2lMHoZxHOJ3xAnNi3iJkhRYj5kfZh/4cFQRnusV0PzIG4URRrLkSYZq3sgrMARbvSHBgnY5WvhbbcBmPVoPl9TxoHzbzU9Id4z5vfMrqYQW6M7nhIsgjOwywPDq1ksMyhz4GqX5VoScH/8q8H3LYAW2ZrJjH4NYv4zSbb/kWCwSoAdKMdg1mnBo81X9AFb12+mMFBHvllVro92+i54UDnAyrBR18bUS/gXMT7RHjc9knKX53rdbUMgkLKhOb3UBtSIgyfgRgQEieJ15h4lpf6M9M/DbfC0jetcW+r52xY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 12:12:23PM +0100, David Hildenbrand (arm) wrote:
> On 2/5/26 12:04, Alice Ryhl wrote:
> > On Thu, Feb 05, 2026 at 11:59:47AM +0100, David Hildenbrand (arm) wrote:
> > > On 2/5/26 11:51, Alice Ryhl wrote:
> > > > diff --git a/mm/list_lru.c b/mm/list_lru.c
> > > > index ec48b5dadf519a5296ac14cda035c067f9e448f8..bf95d73c9815548a19db6345f856cee9baad22e3 100644
> > > > --- a/mm/list_lru.c
> > > > +++ b/mm/list_lru.c
> > > > @@ -179,6 +179,7 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
> > > >    	unlock_list_lru(l, false);
> > > >    	return false;
> > > >    }
> > > > +EXPORT_SYMBOL_GPL(list_lru_add);
> > > >    bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
> > > >    {
> > > > @@ -216,6 +217,7 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
> > > >    	unlock_list_lru(l, false);
> > > >    	return false;
> > > >    }
> > > > +EXPORT_SYMBOL_GPL(list_lru_del);
> > > >    bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
> > > >    {
> > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > index da360a6eb8a48e29293430d0c577fb4b6ec58099..64083ace239a2caf58e1645dd5d91a41d61492c4 100644
> > > > --- a/mm/memory.c
> > > > +++ b/mm/memory.c
> > > > @@ -2168,6 +2168,7 @@ void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
> > > >    	zap_page_range_single_batched(&tlb, vma, address, size, details);
> > > >    	tlb_finish_mmu(&tlb);
> > > >    }
> > > > +EXPORT_SYMBOL(zap_page_range_single);
> > > 
> > > Why not EXPORT_SYMBOL_GPL?
> > 
> > I just tried to match other symbols in the same file.
> 
> We were probably a bit too sloppy with some of these in the past. But:
> 
> davhil01@e142025:~/git/linux$ grep -c "EXPORT_SYMBOL(" mm/memory.c
> 12
> davhil01@e142025:~/git/linux$ grep -c "EXPORT_SYMBOL_GPL(" mm/memory.c
> 10
> 
> So just go with EXPORT_SYMBOL_GPL unless there is a good reason why not.

Sounds good, I'll do that in the next version.

Alice

