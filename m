Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38873C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 00:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF518E000A; Tue,  5 Aug 2025 20:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD6EE8E0001; Tue,  5 Aug 2025 20:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A147E8E000A; Tue,  5 Aug 2025 20:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91AA58E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:41:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C276135822
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:41:05 +0000 (UTC)
X-FDA: 83744478090.29.B6DC02B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id A9E8D20003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:41:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dtrJ36BC;
	spf=pass (imf03.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754440863; a=rsa-sha256;
	cv=none;
	b=FaS5GHSnLCSs2w/la2sbJ/YsT1/JxFloRBm5cPfe9Sig+W3jIHvpiDUNIHAATokEaOY28p
	hqY/5n1D1GKnCd93ilthc8+DS8GKwh5Sg1oNdVBJX/A/zxgmL7HrmreGXErTD4zF0+tBtV
	iERgBOMRY7964j+rYhj8cawD7nljq6s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dtrJ36BC;
	spf=pass (imf03.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754440863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFOUKfyF9eht2Uz3lQBAC39G9bdYnu6PboLaGAsorNE=;
	b=YHwbqPJvxkqGzStlv14vq6qE5iyygu2LWDO1GUzGaUqXT491QtEH3mN+MbDEA/X7XQRbqw
	u+yRP85DFm0BAvEAUkmZevXM4wJltjM3AjNT70gw79u2Jg91KpMekTXfApfzmJGerLXekI
	nvl4xLitqmhlJwDqQKS6Imd0JWzEKco=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754440862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kFOUKfyF9eht2Uz3lQBAC39G9bdYnu6PboLaGAsorNE=;
	b=dtrJ36BC+QvAwu9ziiRQ8Nv+NuFuAIIQwjdcnHBdake7x9A0cWCMXfu6VXWTip+Uqr+QV+
	0q0X//L62XHrwUTwD2uBiaiEEVaFC/asQv/P1ZoWqNH6msaxdTRXqjsGDTsVSh0sLDHjJh
	04Naa4P+xSSPDi71IXbh9rYVRj/YK9o=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-MrFJnA9kMfiA0l6Wg5ngPw-1; Tue, 05 Aug 2025 20:40:58 -0400
X-MC-Unique: MrFJnA9kMfiA0l6Wg5ngPw-1
X-Mimecast-MFC-AGG-ID: MrFJnA9kMfiA0l6Wg5ngPw_1754440858
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-70e5e6ab756so71872917b3.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 17:40:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754440858; x=1755045658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kFOUKfyF9eht2Uz3lQBAC39G9bdYnu6PboLaGAsorNE=;
        b=QtYPxi1xMFnpwkWm+TP2VCkC6t31tRLiOvZITDQwmGp218ILHa3+SYZKvKoITyJZWc
         lPSLuc9aPkRbnLbDFubwGHrqqx0OvkLbVBHSF9K6jacTSHpp/gczqNhzInePZczg67XW
         cGN71PD6yn/RB17iBoFBP3TGMGBqxrKVShCdylyB3AXqTdrA8+oqzGn7fr5jgg0gL5i8
         DQlslIfWF4L/RgB47zI2hOc26w4K2o+nnfu/DjWHN3L1fM2HggGNj77Z+IHaWGts3w6a
         13bOP5KFIThTwG/nn+DMaC8MOMMAhFZmG074mTRt7R6n3tOkVXIZ3qDyqdkGXVBp7w1w
         DWAA==
X-Forwarded-Encrypted: i=1; AJvYcCV+uYhVMpbjGMSZBCBqFe7kBOVnkJ3Y+/fS7mtK93TgnOkt0MQCyGR41dbyE37J57uEVXfmKwcYmA==@kvack.org
X-Gm-Message-State: AOJu0YxdwI1S09swg/jxn9jjg4AEAed59aedmQxGEfo/lD9WPOlg4BVt
	ztmSjcJ0Yj/hpuo98NgrLGfOXuZI/9XNZxshc3hTY4m1w+Hxb5QRpgeDG1WtzZkdmTFGeGBrnO8
	MCTYs+xUG857e0S7dNKC65TeCJ4g5c8iYguGRmXrRyL/tWkHKktrJ
X-Gm-Gg: ASbGnctU/QgY6ujEylZsSiYfL3w4xY8aqwcE1eGOxkXvzf6kyqmt5NnBas2D/d6bdYI
	dibbgjouXwvMSjst1v1/zLQjGJpEXjDAsDMoeeWud/I/TXwNAphLYvwHxQNsQtttODagbNffrdM
	7hhP6o8tHJ/iYtvTMk7N4Q4WM85eOOGR67ywpKloOelGfVbM7A+tGvkW3xxC1jzbCEM6X5Jujxt
	pjhiHddcg6K7BddHelG+7RE338wEDezWCdrp62dOFhnBFAShGlkEkHaj3DTOqJAsXxuigNrNyVE
	wi8zeTxHS2KiLIz+jUDcPCCSl6Y8aM7+
X-Received: by 2002:a05:690c:6186:b0:71b:4739:9d67 with SMTP id 00721157ae682-71bc96f338amr15082517b3.4.1754440857863;
        Tue, 05 Aug 2025 17:40:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHku4dtclIuv1XK8QUtmPlV8XuTKcYcnt2F/++IvmdFem+YdSw119Wr+7uOLta+er71F1OKg==
X-Received: by 2002:a05:690c:6186:b0:71b:4739:9d67 with SMTP id 00721157ae682-71bc96f338amr15082337b3.4.1754440857503;
        Tue, 05 Aug 2025 17:40:57 -0700 (PDT)
Received: from x1.local ([174.89.135.171])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a5cc2fesm35969157b3.72.2025.08.05.17.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 17:40:56 -0700 (PDT)
Date: Tue, 5 Aug 2025 20:40:44 -0400
From: Peter Xu <peterx@redhat.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
	aarcange@redhat.com, lokeshgidra@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
Message-ID: <aJKkjEYmeq93w35-@x1.local>
References: <aIz1xrzBc2Spa2OH@x1.local>
 <CAJuCfpFJGaDaFyNLa3JsVh19NWLGNGo1ebC_ijGTgPGNyfUFig@mail.gmail.com>
 <aI0Ffc9WXeU2X71O@x1.local>
 <CAJuCfpFSY3fDH36dabS=nGzasZJ6FtQ_jv79eFWVZrEWRMMTiQ@mail.gmail.com>
 <aI1ckD3KhNvoMtlv@x1.local>
 <CAJuCfpHcScutgGi3imYTJVXBqs=jcqZ5CkKKe=sfVHjUg0Y6RQ@mail.gmail.com>
 <aJIXlN-ZD_soWdP0@x1.local>
 <CAJuCfpFzP_W8i8pwL+-Uv-n+2LixgFrzqn2HsY_h-1kbP=g3JQ@mail.gmail.com>
 <CAJuCfpFEf92gTR+Jw+1wcCcT0fEt-SP193NHzpyxVXJA=VAwng@mail.gmail.com>
 <CAJuCfpFeSVq+hq4JRJStLgFfQgmS6SQ7zoFsj4=SeQT89r3TTw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJuCfpFeSVq+hq4JRJStLgFfQgmS6SQ7zoFsj4=SeQT89r3TTw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YFxQ9s0lO0nkj-miSlEoiVBDRLTuNOf4iSdY1fryPkk_1754440858
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A9E8D20003
X-Stat-Signature: ikca4zn1nrrb5ri7rcfrfb4jxojg6cjg
X-HE-Tag: 1754440862-156204
X-HE-Meta: U2FsdGVkX1+iC+ne/tVCawSIt4DqWI2FSjehV29f0YaEglZVXDSlyZONHLdQKs8fcIcBWGBXy2TY+aKVD4GyGK4UnjCzFVUQMpPNah4GNreO4o1fFBpgMqzbX1S45IjnYHbTS0esk9XVJ8nPPnhMwxe0J0AEuamEfwBaQZ3xpDqObEW6+fynKlRtdU9Lw9qiauiy9ElsQ2X4gwN29JHcWEBmvr8NWfnmLRNXYpDAQCe7HqM5ekcTkCSU0D01uZG3LOZGTCgGYf0FTd2bruQrFoUEBkEBdWVEHjLME61VwVyTRUJp43ahIibCjSCygCxfMRk01wcHafMpJYPoGjLK5A4CTA0EwzVzLAnCFVZXNUIIJUVA+V3fgNc1SxDxW5HDUqjqcaSZFNZgGIMz/N1I35g8PSUr+LTYZ0K7RG8ly00GXjZs2DnGdPE6rdRizpq3/cLsmFFzKc4HO1tVQa8R2cwk7RCWaKUbckVxYbj1YUkZYhX4bwWlOql9UUxWUnsnG3NXTJBXUybsnK7aYPZD4PKuAHy5XAvlfK0SiA3KyfZSlWt4ALp6vdRQKhwOIVKn3H6t33YaEZezj0tVMeBmLeoiBrMBE9EcR/6m5WxYFcdjzjTdHag4G0oEzlPREChdW7kcO1SfBL8Q5Q7ZOiB7vC1sP67WMwmh/CqTCHDDjn9pWgqyO8diHmYM2/8cE6wZg6SWnAcnyCuB6rSPWxv2SOVmky1oNRq0obfiXVUqmSzPMBnPE+F9rNzfraVyBbfi+77rgHbLfGdszbau5a6lKyuIC209oQxiFwnG1bBzSxogf50lzDaMLbaVVumB51kePPgLrIsKHa27dnpX9EzjB2H54M+RCqBnDYbkGwFUajeoNKV2RGwQwAlJqeX9AAwxJ4J7ebfSoq8kr7Zvi5wFBstQV1saRATeUnzVxuHaLbnsdWCOR/LIanefw57C28aMEvPGsNK3sDtbU6V5rLe
 +zW3HidY
 XzUboDMfJ4DclHIRIIGQpOIqALm356Y/7EYrWSybr8DdEE6uuQbnaZEEleYcqg4Rf9t74o4u3T2bouW1DuMr+7JkZ2D7rRJ88eVjJmm1uHMhjYd+M3DoiSqJwdULkmpi2+uZICokCo22Bsg0a9iGtYJ0Zok8D15VVoLcNvx3gBOiSO87cuY9wpi7Z3ELInDqXP02i0SLhEkgiBf/mfv6uSVQAYT8dQpa5neWHJDzlMXcR53NAgivzI8UPdPBzqRrZDVVJVx60fJxjW8kw+xgsTrha5O2QWdmgcGcdKd00/3z7NdHDnRlmQp731yUktGHDAU8QZHnhpcpmlXtl3cfhzNyp6dMR7Lh1sNqNYklinfUaQC7by8LPxKPB+6pQVi+MfItWIZpEia79CdNvG9pxP5zUQYW7nvzJ+CdQ0TSNCcqeXswvhtK0/LGFe0KXXSwyIzd7NCtV3pwdR40oaHXkl8c9nDwW5/ZB27Ye+uQxdB9WpQW8amGhTHair3c3MhQGrxqGJDhB/KbvrdBd58wipyIdOnf8AS/a90YsKG7KWXzrr2H0FxJ0pHXtxsgiZfeSqKjzx8Uov/KpWhev1oA1mwu6b1VJqONn0W73
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 04:41:18PM -0700, Suren Baghdasaryan wrote:
> Ok, I let the reproducer run for half a day and it did not hit this
> case, so I must have done something wrong during my initial
> investigation. Sorry for the confusion. I could have sworn that I saw
> this case but now it just does not happen.

I'm wildly guessing you might have hit the numa balancing bug I mentioned,
that might explain what you mentioned previously on the testing results.
It might just be tricky to reproduce:

  - We'll need a valid THP (pmd) first in the MOVE source region

  - THP needs to be selected by numa balancing for a check (marking
    prot_none)

  - (before any further access..) UFFDIO_MOVE needs to happen on top trying
    to move the whole THP being marked as prot_none.

AFAICT, task_numa_work() is the only place that can mark the THP, and when
it happens, should see change_huge_pmd(cp_flags=MM_CP_PROT_NUMA) and then
returns with HPAGE_PMD_NR.

[sorry I am still pretty occupied with other things.  I can try to reproduce
 together with you after I get more time back]

> With migration entry being the only case that leads to that
> pmd_folio(), the only check we need to add is the "if
> (pmd_present(*src_pmd))" before pmd_folio(). Would you like me to
> check anything else or should I go ahead and post that fix?

We could fix the migration entry first, then if any of us can reproduce the
above numa balancing issue then it can be a 2nd patch on top.

After all, so far we didn't yet prove it, either some unreproduceable test,
or pure code analysis.  Meanwhile it might also be cleaner if we have one
patch fix one issue, rather than having one patch fix two bugs.

What do you think?

Thanks,

-- 
Peter Xu


