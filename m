Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 389FBF9D0D5
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 15:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780E16B0088; Tue, 14 Apr 2026 11:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731866B0093; Tue, 14 Apr 2026 11:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620386B0095; Tue, 14 Apr 2026 11:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 500C46B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:36:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2C521B6DD7
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:36:38 +0000 (UTC)
X-FDA: 84657563676.06.772FAC8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 997AF1C0006
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:36:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SLF1dxu1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776180996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVy8CJOeLfr9BmuAq30K7dxK50W2CgA+FeGYnkkdt84=;
	b=HIi9bfPnS9p77GFR0POvcJT4sS2sHpQjVFwoc3heTjPmrczipGGpKKQgRyARsgWHenu2Pm
	oAR2KZH0t7cP/5SVJUtfVhFyx9bl3rf8Cg7Uttb2stL7XndXKZdCQdjEGkETxW+6Mwm8bM
	oMgDWKf2/cF2NnPKqTntLiCR4tnpO68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776180996; a=rsa-sha256;
	cv=none;
	b=73X4kxsOI7wRAIyepmq1bASbblAmGhUAKTiYZsxS3eY+BC5VXf/wnVk5KeuNr61mjPQPGm
	ZFNRRZGlSyzIlLJgMpJivdg1e9LNZz83Ay3XI8pAHTX14/dxu7w12i+DLoo0F1l1qD/6p+
	KGHNWhBuAfd5kvoyNGqS0DdeiMTJC8s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SLF1dxu1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776180995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PVy8CJOeLfr9BmuAq30K7dxK50W2CgA+FeGYnkkdt84=;
	b=SLF1dxu12Va+De+zJtFUKxmvUpRPHqbxd853g5wXY4fG2glLTuylC+/um+y694poajoNpx
	E/TH6cZhYYVtZMpVscXMB+474D52/O0gpyJmkY8lc4GEN5BLc4XMUo54mVsufubm3inPoC
	igdfCjPG5BMGsaD7bjAAdC5D2vgDo7s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-sT8hS94mMciEyL720cnwkQ-1; Tue, 14 Apr 2026 11:36:32 -0400
X-MC-Unique: sT8hS94mMciEyL720cnwkQ-1
X-Mimecast-MFC-AGG-ID: sT8hS94mMciEyL720cnwkQ_1776180990
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d77286244so1686166f8f.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:36:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776180990; x=1776785790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVy8CJOeLfr9BmuAq30K7dxK50W2CgA+FeGYnkkdt84=;
        b=mu4EFfCVfGxj80fSSGrwJqed7ybJFmhJkTLpsHs/Y2waCjBzaKcu3nH/FSiyiwxSTq
         tBOxt/K6E6JvXojsvUV3vRC4yKihLH2H4Acn7qlNT53pMVoUug0CsaUL9gPe+25ASTE8
         2k/9bZtgDjh5/qi9JAIfJXqhq3Ar349eXTz8edwrbusIix+L/U3LAm1NpoPgS3wo/Bzs
         TT5gfmktDOP4OKHGg4/weCeSpWLFD9CgzEzMgcKUP6xcHtC1a/gvXy+5xskCfPofen7l
         nylfLUXHrbkiwfipMg43y3IOyPS335fRNmahULAyP/TrROcAnksDzWTh3qfGrIaJV3ZN
         NIaQ==
X-Forwarded-Encrypted: i=1; AFNElJ8cTB+Y8S5KksS+pzRdXqPzEse8N9W4d5XP5WpINPp5tarzZelshY+TSATNpATN846rtIPGtaOFgQ==@kvack.org
X-Gm-Message-State: AOJu0YzG7+Qg2cs3GT22FCddVhFMlm/OifRckUPgtKWx9/VgN0XICW8A
	9NPc8iTF56PsmLMxsZMmIwFUwfS1khBDfnl9ERrkJLw6sCYBeisk+KVJOVEGAc2cASOBw0/0QYE
	DNLpnujIW0oBfLXCEfwBeHkRgE3ycgN20Dzx0yGM0NB0GxdcwNxYo
X-Gm-Gg: AeBDiesSz9VvarSed/SUSnrg9szfBGgagyZWDyOXfa8ivTk1RH8x2rrj0sfU0vTDSQj
	F99hzXKY+oRWYl2fYoqUiTiIG9uyn9ocYqHtN+tbLbPRCesgV6eMJk4rrsup73BDjxwALSIWNlu
	ldx/Xc+pJxSp9DSoPkSJELK0qFKdoXtknRKQgnKDCY1kQeA/vid2MK3CsvPOyr3g25kKgQUDsaD
	BvosTblCobC6NnYRqKV/53o3uZQ3YZZTP/p1HeiRaRMFLaCe2d1fXCCgdi6i01oo+UD9sULWS68
	g+ReDhhSXGTkZpm2lFyBl49o0Y7+uKzVWDfoYT7jg/zvAOV3B5mK+6zRY7ZxvssPIzgVpiid1FA
	Urr6Xj6rSRj5QGRSj5l7ios19RcvMY+QIgd1e5ouhu1c=
X-Received: by 2002:a05:600c:a109:b0:488:af7f:7751 with SMTP id 5b1f17b1804b1-488d6836508mr175214405e9.15.1776180989941;
        Tue, 14 Apr 2026 08:36:29 -0700 (PDT)
X-Received: by 2002:a05:600c:a109:b0:488:af7f:7751 with SMTP id 5b1f17b1804b1-488d6836508mr175213895e9.15.1776180989419;
        Tue, 14 Apr 2026 08:36:29 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ede1e826sm119796545e9.6.2026.04.14.08.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 08:36:28 -0700 (PDT)
Date: Tue, 14 Apr 2026 11:36:25 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 2/9] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <20260414113505-mutt-send-email-mst@kernel.org>
References: <cover.1776033471.git.mst@redhat.com>
 <ea67e39bc3aea1b0b491908f851ffce25154cd26.1776033771.git.mst@redhat.com>
 <2155527a-e077-4b71-80ee-d735f9984f60@kernel.org>
 <20260413163233-mutt-send-email-mst@kernel.org>
 <244c9779-b4a5-4d0f-9eb9-ef0ec873e0f6@kernel.org>
 <20260414062015-mutt-send-email-mst@kernel.org>
 <8900872f-39e1-44ab-8440-e91ce3f0523a@kernel.org>
MIME-Version: 1.0
In-Reply-To: <8900872f-39e1-44ab-8440-e91ce3f0523a@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WEpe1NE2S2KdJF1Cm4J_Xq-gFZo1nH1mEu72TgFgUac_1776180990
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 997AF1C0006
X-Stat-Signature: o8i31iffxyu9aryuwb8ykogfqby7iwic
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776180996-321206
X-HE-Meta: U2FsdGVkX19rVBAzye9AoicJ3yKhpVSCivNLaMrQFKum13T3HEh5zu3CvU6AuHF9EwUq8wBlbsZwiX8pGE3Qm7Ysl41k8SzzCz8PtSMAMGT5x4OEeaoIP8fNPP9R0G21rHrQnRIOjZBjLMvYvb90baEKhe6vYMrIEayqvBV5Wdc133tHSfqXz/bI9Epb+ubq6ffUCOGxEudITNVoIAwsyKiQVvgjCycdKl+f3cspc9El72TuxJDu2/Q5jjQMEY4SGAZGUvTAbP7IC9sJzJLaolhmhVK+obG+dzHt+9fTKVFDxFi/KW5NTAkyjg2pDWX1qTSo5ovo8Jibby9RiswnaAU351W28E759ZlpH77KVr9mR7XS4fRA5iq0foqPUrsgqkX9d2t/CJx8K+LrTYEOdoDnXRkuHvn1oiNW2lIsugMXEh95ZTbUghZT38krqTiPrpRa0OwKCf6ucPQo/28gvyldkh2DuizQZj6ngx7BAxwoeTEbjYCjzZljeyJ6pj/od3hR+cNoIt21LKil9a1yPWUsxilPtZ+tIjeJRSiLOYlwgM1oSb7lPAlvj7b0f9HEZ0fYnjKHNhUFzJnWaR2KnlJ0au46FpBimg/QyEC1TKb1aWBt4QDnqEbH1+Y3Nu6DmWoPClyheAwGA36E4vIkkiZf+DNp+zjPEtVKHxEK67l3WJB1Y0MdS3r3jBFnj4WrCnTgrZzUECSjrGAiRxflf1x43uzyiVnz733jE8b6xvXHN361SJAsGDVtGZ8J+qrg324J+7EotAKLKgefJ/PrlvhHJJ+9rHHWfS0M2xHXG5KyoKhDpwsz+pKpuHwhv0pUgViiK6MPbS+A/eR+3Di086/VIBLKfc5Wt48adNpIEAe5TAlYv1LEm/Ahg7B4dW4O1QMonLqRsGhsiceMcxh0uh42nVnjgY3rqoC3ziyNKbGTXPU5EFmElE3LUHv5TptoddK1hQnN/H+CEpLRiDC
 ZyOqJxqt
 f8jXOpY3lbujGPNvjnu5Og7tXIrzE5E/LDlV9opinYMF+cBzFNtCsYCMyuvhJFdWwnpPleph6KA2aMaRJECj6SdCZt4eQpxBVxSM1KnCog/12gBc9zeWCwoegq5n553r6BucvZqlr19Sh9NsWU1JcyCRnX/skjKKnWoBtElg1IVcI5dNdD8czi8eb+7eoONuQBc5dusmwXG25QHgLzHkm9/8nYsG+FVbo8cY+flDYFSumVc6JH3vkc2iORYvYhIH3sYBJZyVYsHxWVJqbDgFmnJ4208QnsVhai5yTsVjTpwVjePWOOt6mPw+NmdBJkoJ6okBwMma+Z1FQv43BwobgbuMUqgIvYdrcOyGQIxOYNph+ztX3hUDuEHVGBtQXGIps2KTa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 05:32:16PM +0200, David Hildenbrand (Arm) wrote:
> On 4/14/26 12:22, Michael S. Tsirkin wrote:
> > On Tue, Apr 14, 2026 at 11:18:02AM +0200, David Hildenbrand (Arm) wrote:
> >> On 4/13/26 22:35, Michael S. Tsirkin wrote:
> >>>
> >>>
> >>> So here's an only alternative I see: a page flag for when page is in
> >>> buddy and a new "prezero" bool that we have to propagate everywhere
> >>> else. This is a patch on top. More elegant? Please tell me if you prefer that.
> >>> If yes I will squash it into the appropriate patches.
> >>
> >> I'd be interesting to know how this would look without the GFP flag,
> >> when we don't have to leak any of this out of the buddy.
> >>
> >> -- 
> >> Cheers,
> >>
> >> David
> > 
> > But the zeroing takes place outside of the buddy now, it's more
> > "reporting" than "leaking".
> 
> Exposing some buddy internals using questionable GFP flags, however you
> want to call that hack ;)
> 
> > 
> > You mean, moving the zeroing into buddy?
> 
> Yes. Such that it doesn't really matter how we maintain this information
> internally. A page flag is probably still nicer for that purpose.


OK, sure. Let me just finish testing, and I will post.

-- 
MST


