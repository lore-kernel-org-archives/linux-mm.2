Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CBADF588C3
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2346B0005; Mon, 20 Apr 2026 08:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99EB6B0088; Mon, 20 Apr 2026 08:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4646B0089; Mon, 20 Apr 2026 08:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A0CAC6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:35:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53BF0C30DE
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:35:53 +0000 (UTC)
X-FDA: 84678880986.06.36EF424
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78A54C000B
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:35:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j0BMAURc;
	spf=pass (imf10.hostedemail.com: domain of 3pR3maQsKCM43887G874u7008805y.w86527EH-664Fuw4.8B0@flex--joonwonkang.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3pR3maQsKCM43887G874u7008805y.w86527EH-664Fuw4.8B0@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776688551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7rF8R+Cm1/VhrNzZCKXUuMbhfYj1uhB1Hlo6ydY99s=;
	b=l07+92XWYJuYGIqcD378xmfBoVZOyGDVzJmCjCLaQDuLAlqP4LWfPosYqwjOHZP9GBSB9V
	+uf2EdXmUi2zK4c710I0UlRaMy5p939XYL3cviQGv8WmF9d4OMp5/zjpdA3vaYmNhPVB0J
	a4cIdbTucV/JrUU7MIHDRMaYpLRbAzA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776688551; a=rsa-sha256;
	cv=none;
	b=iW5ujcYJmldjZ135AkK+tYdkrym2vKAnAemLSmZrluFJbuMuUtFPB+5Ic5qIzPBkPQoQ+T
	FMKOHUteMSYmW5Pc8dPEXebh8sYZviT5mm9nc8B9f9WrDQuqQn+IPZGW57dSMb/h0U26mS
	YjyGtScdNGHUhZ9FdxRk7P81oYaCvok=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j0BMAURc;
	spf=pass (imf10.hostedemail.com: domain of 3pR3maQsKCM43887G874u7008805y.w86527EH-664Fuw4.8B0@flex--joonwonkang.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3pR3maQsKCM43887G874u7008805y.w86527EH-664Fuw4.8B0@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c79744a2d99so1050331a12.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776688550; x=1777293350; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a7rF8R+Cm1/VhrNzZCKXUuMbhfYj1uhB1Hlo6ydY99s=;
        b=j0BMAURcl2bXrhn3laF7b0NA717XIunwkzK9zpvloAUF/kSmKPhJ7nvowmCvIUS/5P
         qr0R7AX7Nfz9tE8aA9b4BbzT71ggr84smDfjVCT0lJNnZe46d9SVxB53OhisqBHnDNbf
         Uq45jCiKkT8ESxknx65g4JVRDJ/3aECT/nXTA0JDISuTMidOwUVnEqJdftSdE7zgbGcn
         DX9iJsYqkLLUMXHleFSlEv517y7piO5mLiU5xmJMhTrxliEKqCk5RuSUdGAxMeJvsFlE
         cuSTMP6P4/zULzWi+81bbINSHGVSCopUnyhrRUd2Q/6k0yt43ubdaSWmuDYOPoq02yxh
         jn2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776688550; x=1777293350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a7rF8R+Cm1/VhrNzZCKXUuMbhfYj1uhB1Hlo6ydY99s=;
        b=eBGhdDZ+63njJsEgR7h1v9sohOXyJqpIMvZOjQJA+ee4NoANdVrYjci3qMNQ6aeOPZ
         9gcFh4QuTg6+X9kICRNvNe63yZ/z8hQNBLEE7vrd//q6hIkbs2IscfDRGqorGVFyMQJz
         ABWiuOM5AlM+9RsRsVBcTl0ISmCC6eMQyH6nBGCfzUE1kP9/5vYRhl9x/+nuEu0Wv7k+
         FgxzukuhB3+PajwlVA3S32svqb9eKzaHgVyQgX3s0x8AKbke3RA3GDEz7iMt8NyjwY31
         jDUj2DXCqcXSUMJtxr9OjWSV+y0nlSa4HyZc2t2TH38U5LAzeG9anf0/tSbFrDm6ifLw
         Z07w==
X-Forwarded-Encrypted: i=1; AFNElJ9wVIF5u5msaOUbxroMX7ucHCSrjmzvjEjiooxDFOEatQZ9aLvUHU4Jr5WNlXqGNDrNcC3j0ZI+Eg==@kvack.org
X-Gm-Message-State: AOJu0YzFzgBQGcOJTXaZBcIi8vs8O0iOlDZYaQklfnduvbjDlZI6rynW
	0okoGMO1NGhOJXOV1nd/7NRukaBQcW07OfAy5ui8aONT1qqbOs+plegLANvf349aOZkPajj7rex
	akz9QlFHnzOiGZpZuJ9YQyj2Nbg==
X-Received: from pgac10.prod.google.com ([2002:a05:6a02:294a:b0:c73:9919:c4fd])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6685:b0:3a0:aee6:acb1 with SMTP id adf61e73a8af0-3a0aee6af6cmr6488139637.26.1776688549982;
 Mon, 20 Apr 2026 05:35:49 -0700 (PDT)
Date: Mon, 20 Apr 2026 12:35:48 +0000
In-Reply-To: <adfrXdWJeuqDLWFM@palisades.local>
Mime-Version: 1.0
References: <adfrXdWJeuqDLWFM@palisades.local>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420123548.2116177-1-joonwonkang@google.com>
Subject: Re: [PATCH] percpu: Fix hint invariant breakage
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, dodam@google.com, 
	joonwonkang@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: owug9zg71mucipmce4gtjkqf93n9c4x1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 78A54C000B
X-Rspam-User: 
X-HE-Tag: 1776688551-774606
X-HE-Meta: U2FsdGVkX18wMs5nNSWM895ZtGMS3RRu4RwYRrSmdDVSbjWotQnYhk2YTECFMK4F7ohIeqQLtpjBikpN8tf8SkFUQGqEhOdPeOwfbtpMjdxTijvYID41+Og9sOA3w/R914yDVMPFWuxvWH2ZV5UwWJQKNkdbk6qjJqY5HncK5pziNFzHrQxV0R/kHURK4aKSnoZdEf4K8LbX4Elv4yNrk8kFQVfF9Cy68NS1XEHwRioNUTSTIfFsqZ5+Pmh/4nUXS16XV0LyG58ZFIClUwWj482/mVGWgZVLQNP9OjEL6ewQGUn+vxsmRp2tIDKmrFVeT32/Ff8WpUpT66Ehvm3NULnOV2xpxzBzJVZDblJwi2UtkracTW4+tbsjvb33BBWWQfSe2Zmb+ER7bTijYOgEGHnQIBuhVLjCDiS7b7zyLkoZdhJTeeLV6QIVEZRgzsqLWF5nLEXKrkwWApp2a2M/zLeEcKuFuVRBJAjIoU9T6IA7sxi4eEQ4Mm8Z9EgR71sInZR36kPaqunPLssm/nhohDFk8luc+eZQksX4X4DWZHBczxGhm9+9wKQdI7+aWOWkd4J+0VEfXTwTQCWqKiBLghdr+6dNIgBbA/2+HrFFmucBluEbEKi9dXDcaxsW13Wlnt9p6xLmXsDbyYYlwjM+4eQMqyz5oar8PtkrK0CdmhQ+pEwlLil/eaObvQsKIXh/xBXxnMlGwa9UnPX7ms4s/wZoKdrU6FkXN4Oh20CppVzs1MQHDfjgBv3IARibGpkGqtgKKGgnP63ZJg0piHZ/iNHM9az+HlQM8D8EJP90y4P9iSEDn5ZMPlaLQFXQoJT/DQzQfScvbW0dZXjf2BoWDb+4jQBzQpNo6T/mmqQpDcZuyb7oBSofp+8Hx3gMFFURpc3lIEH15Ro/wXvZaPdfPpD8N7NBceUjPmTVNlwDvjNreT3qHiscZxCHl+3Cnqby3XHZJisvPO+DqmRWPNe
 ycJcKg7I
 8kaVbrsvCHugHGdHh7FwYndtHHj/nloeQuAgpGTv+bDFWj+N9jxcafmEv/fIZoAqYTmSaEJW9C9NHIIK01587TlUvbZ6zyb7hZT4Vu26s+TMMpGxLdM2DCSfdirxodAGHJnIdVOY+Cbn2dGMb0P7uH4D80+i6r/iNurjfJ7+jOVqRBpE4/V1eqMvnTHaLrECu+oszOg071Ewbv5m6A1K5YoAql49AT0SMIK3lT7nOYmgyls5hoMepkeVCFdBv12yZbZHulc1lR2xJkH1K24FDJnvaoDEP5f8d+UN20TPNs/1MJ7+Sug2LD62SWFUqSlGP44bR59ePSbxs1E8cJ+wGave0ZSpEAw4+pYg+vZTv7yfiIqg6isjzQ5fN4o+QyWcJ0rOW7TQOkd8/Gsq/QVga0/B4wuab5jxbF8ieCYiusLmiIL7bzSfn5//VSxRb6iCLLWeLnw82pDg3JyDGUk05fQ0p+SJnwFZ+kbQLRxpwV1fAeOGePQ3zm3x/UTNDuFM/wj0NVloYkbVKGSgaH298X0AziNBA6KXj2hb7gY8xD+PFeKUMawXFqpq9dFSQqO3PZPEAisDvsJt1/ugSPFGfSUUNcYV2goxMNXitdYF5gY7OietPUh5cFa80KZkVKArTv+ilT5Xm6hSG66wZE8RORRVnhMX2zAlNpDC1BtaAA5nIe1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hello,
> 
> Sorry for the delay, I've been a bit sick.
> 
> On Mon, Mar 23, 2026 at 02:05:14PM +0000, Joonwon Kang wrote:
> > > Hello,
> > > 
> > > On Fri, Mar 20, 2026 at 11:52:14AM +0000, Joonwon Kang wrote:
> > > > The invariant "scan_hint_start > contig_hint_start if and only if
> > > > scan_hint == contig_hint" should be kept for hint management. However,
> > > > it could be broken in some cases:
> > > > 
> > > 
> > > First I'd just like to apologize. I spent an hour yesterday trying to
> > > remember why the invariant exists and the reality is this code is more
> > > clever than it needs to be.
> > 
> > Thanks for taking time for this and sharing more context. While you are at
> > it, I have a fundamental question on the invariant. I had deliberation and
> > discussion on what benefits the invariant gets to the percpu allocator by
> > its existence. My understanding is that if we put contig_hint before
> > scan_hint when they are the same, it is more likely that contig_hint is
> > broken by a future allocation, which leads to a linear scan after the
> > scan_hint for hints update, although we could save scanning upto scan_hint
> > when contig_hint is not broken. On the other hand, if we put scan_hint
> > before contig_hint instead, it is more likely that scan_hint is broken
> > while keeping contig_hint, which does not lead to the linear scan for
> > hints update, although we could not save the scanning that could be saved
> > in the other case.
> > 
> > In other words, if contig_hint breaking allocations occur a lot in general
> > with the current invariant, the performance may more suffer than without
> > the invariant. I also think that there would be no strict reason of having
> > the invariant.
> > 
> 
> I think the original premise is that percpu memory is quite expensive, 1
> allocation costs nr_cpus * sizeof(allocation). So we do our best to bin
> pack at the cost of faster allocations. We could always just break the
> contig_hint but then over time we could cause more fragmentation.
> 
> The case that triggered this was netdev needing 8 byte objects with 16
> byte alignment [1].
> 

Thank you for sharing the points about the bin packing. Although I did not
fully understand the relationship between breakage of the contig_hint and the
fragmentation trend, it may be helpful to reference the case you referred to.
I guess you may have missed the link for the reference [1]? Could you help to
provide the link, if you intended to leave it?

> > So, could you clarify the necessity of the invariant? If there is no must
> > reason, then I could post another spin-off patch to remove the invariant
> > at all so that we could simplify the code and experiment the result. How
> > do you think?
> > 
> 
> I can't really recall the exact reasoning for the invariant, but it was
> probably along the lines of wanting to not lose information if possible.
> 
> Say an earlier area becomes free that is the same size as the
> contig_hint but with better alignment, we ant to use that as the
> contig_hint but then we either have to lose the scan_hint or keep it
> with the invariant. Given the premise above, I believe we want to
> continue bin packing, I think the general idea of scanning next time
> around isn't the worst thing.
> 
> Sadly because it's already there, and has worked for quite some time,
> it's kind of on us today to provide data / reasoning to delete it. I'd
> wager that some upcoming work is going to change how percpu gives out
> objects either through some sort of slab caching that we can revisit
> this more in that context.
> 

Understood and thanks for your detailed explanation. I will keep the invariant
as-is unless I have a clear data point to reverse it. I sent the new patch set
v3 recently with this in mind. Please help to review it ;)

Thanks,
Joonwon Kang

