Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6105C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEC046B00B3; Wed,  2 Sep 2026 06:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75A36B00B4; Wed,  2 Sep 2026 06:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3CC26B00B5; Wed,  2 Sep 2026 06:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 920576B00B3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:27:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 083711A0181
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:27:53 +0000 (UTC)
X-FDA: 85168446426.18.B07CC28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id F2BCA40003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:27:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxrxxMiq;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788344871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yCXEtMbZWf41CPhhN+cCLVvyaPkES51f+1dJDg0tIg=;
	b=WyTP4OI4apQTWJOW04yqMaairO/qJXyjoHF4S0BpDwNV1YkK0R/8nMEmjk3gKCv5cn5O/F
	niAVRvDIL2upb4P+FB48+Zrp8+ZldgGJk+nHao1rHO4kTLTyNkG88ZJmSKRetm6cqtFiuS
	Ta8aUcGnBH2CTIzmOKysDOiUEhBdBCM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788344871;
	b=TvScDq885FXc4npXA8eSfIwj6fXB3GQbDwZejQehNtFZbV1kjMSdYTu+S5L8sycI4oiI6I
	5qzX/SNd2Q4GUBCqWomQfqHiGTmrYOeGdQ7CzF2mZvNOt8XhuR0ZXjF3zuEpMwb3tbf9lh
	dXTXOLy+8Lh6mMPPiMb5ld26oyspJMg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxrxxMiq;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DB42423DB;
	Wed,  2 Sep 2026 10:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244A51F00A3D;
	Wed,  2 Sep 2026 10:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788344870;
	bh=4yCXEtMbZWf41CPhhN+cCLVvyaPkES51f+1dJDg0tIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gxrxxMiqXHG8N+4yKerHwBB/pvp37MgeQ92XNt95yPGnaobrGGz46ksvWkPW2DLi7
	 JVw0ibJxWDoinw6JtAfFib2MJsPthELI4EPvAQUKpEXTC6AsPpSCneAqe35vkL9Fm+
	 oDU2w8BOHWqqdf6CBoIie+QXlSuBOc1cShS7fHnbbJy8I3KoEsvyGFE/QTpyqq8RZk
	 BSqOOd4ngpoIcOWpwyzpiTIqlH35RhWXyHvyrlkYD/ooebmkyD0qnJDPaHk/Wr3/sK
	 Jzr/zxEibvBrKFg1IIj4GCQ4ly6sFOKpb0muaLRpqYvk12XoOGP91tsZIiDdnj1pf6
	 f4LxdrDTOAJBQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 914911980059;
	Wed,  2 Sep 2026 06:27:44 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 02 Sep 2026 06:27:47 -0400
X-ME-Sender: <xms:IPqXage4KrJbErzdbwvgCEGiSFp8li7OfCo3m2a1K9hR4o3Zp7eA1w>
    <xme:IPqXaklvHL40Z8-6jIuQmKUHV0BiVBe8U-y0ju3t9aiOLwR3pyWpbgsauZbgd0vWm
    RLvIMhK54LOi_MsZZMXbOf1uJzY-sFatYT7ppI5vcvUrejJcGXGzhsV-g>
X-ME-Received: <xmr:IPqXasFSxzaGD4AvAJEdG0rgaQLGuswn0uETU682P4TKInmYm6QubOPKm6Q>
X-ME-Proxy-Cause: dmFkZTE0RVQvOarTCWlrgtMFcY4g+ghLUV5agAcTe10FZuLW7XPlGE4qzbdXSL9ojwVExl
    s3MhKzqrOpq+fsQp4m96k5OEOv92yI9u2cuHCBmZKj7bkqBMUCNP5lLOmEQBwdow0uaEIT
    76+/U2gmiWeVlVsju3SI8TFoEL5ILBspKcSCXfXEDfiW00iu1Zjm3huIPyUxAV/n0Wq7P+
    zmwosbm36xpLKPnkqTXYzZGzTnRxQh/NH5eMlfEWL2aRt98x9DbRRgkHLWXH299/xp9wYw
    qLt9x634AldHJAJH+UHhFAWUvBb17VO9KmArtvcPcRePPRkFj51h/spo059p7H3HTWlsWF
    Ngj2TcZq0L8u135ZyFq5+kuJMMOJC7j/27l74E/BIvE3Sr3VzP1FtPIZ4Q65SISHrFzGZP
    eLpTcVxRDW7ILUxYu1SrevDqByaWieTsIJe10FOkcAS5X/FxeTb6aCVtQQBlQiANCroOWA
    81XwwoGLvzPOkcD/bBNl4/gEJIiiEN5lwLt8V6fJhzgNkXiEEQ8zQI/ntYHKANVcj+Dre4
    WP92rJfsZ4JgnME7kEZNHxqIXcghGK8iWrI6dMl/XenZAdlXyvANZ64Mvwnc1rig6JoLjb
    HJ2kByDjZhWqJ0oenkLPJb00cKNHb5aw3zAvoGOU3SsGe+Fq8xw4CVWBGIeQ
X-ME-Proxy: <xmx:IPqXagcFjpYnvYrDK9BXR-p7DIMTpR9qNbx2e0ce7PCwWh13CJAFcw>
    <xmx:IPqXaliySbyJqk84XJOxAu8st28BmZlNd18wsIvem2Ob6Rrjiz62uQ>
    <xmx:IPqXatXtTRGExWE-w2UAq82OtVBomezN89sgRrlY5GvUOaPIOS_ivQ>
    <xmx:IPqXapJLb2Z5cA0YcOaVmPvWnbTybMBwKrMNL7nd1BjIPti3x9OvXQ>
    <xmx:IPqXagqjrxZesAiLhFkhEnRe1FpoqPbMHYhSazBROA_HNYKFmxXGVnu8>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Sep 2026 06:27:43 -0400 (EDT)
Date: Wed, 2 Sep 2026 11:27:42 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: James Houghton <jthoughton@google.com>
Cc: Lance Yang <lance.yang@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ljs@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, shy828301@gmail.com, 
	zokeefe@google.com, hughd@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: Don't collapse uffd-minor-registered VMAs
Message-ID: <apf5xBqj5560JlMD@thinkstation>
References: <20260828094703.11081-1-lance.yang@linux.dev>
 <20260829052606.49470-1-lance.yang@linux.dev>
 <CADrL8HW3=n8VqW+7YSb2kyhkHidNKGy32+2s7A0OfF+oYoAifg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADrL8HW3=n8VqW+7YSb2kyhkHidNKGy32+2s7A0OfF+oYoAifg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F2BCA40003
X-Stat-Signature: 7ozudjo8fd7edhx1yyunajyqcnut1qfi
X-HE-Tag: 1788344870-437446
X-HE-Meta: U2FsdGVkX1+vMyMyrrYWoAjgM35Dd3guwrT51Nd1/E6/WVn5tDeEEINvZZ8iN3HRu2Dsb2hKCqugtz9WSweitZ4PMX4d4kVF3PTgmChEbr/C/pq837dtZUjlxUjY+AMEIPnV/Iu/O2TFPzFOfUNzJt6T/KXq1DN0maLRDyzpxIAlAcQRb1+96TAVpVPfbPJ9jUhMajOk9q4CXzYCulEc94AVfyyUKTApvy0Zini/1ydoyYOYqIX0KzA8gxASyBRbObAwQlbzeZwNQmXbY4VYXTh5qJQqaIWgfE4VIbbbMr8GKkdGfa0SzOCe209nHaiPUicGnibNZKN4N6LBAX+lB+G9Ujhdk9uNw9TS8d61XqMKK6lqiV3jlKqIzekxyEieG/QYW/aVaqzEdbEqNA0b0Uyq5bRLLagvJUly6oGVaIqRC6xKo1N/UK7SrEu1wsiU+bvIEJ0C+4ge0Evn9Yys/CO7cWINuSi4AJrSGkiv6deXlVP8OQk3Y2NbDUHWxdkp7LoB4vT/AC9sHoGo75/iLWM0KSJ6jfEtaTSQejcYocoptdmX314ZP/9yC5vQzrUWqEmJeq0Wxe4mo28snlDGq0nBi51IyaGm1uIv/tbXyfr0ZhxfuOdjrDpEuiWCY/vNuusMZKkZ6ztkpkLt0yFrw01UK7tBdrnPFv8PdbHu+RMO4jN8iOyRnzPgrM83V+Y9SYsKVVYbnv9/4oBC4MVTSzwZCqJBjB69HJZAPzp4zOnY6sgdyRIkK49EZq5pKhResAMlKLQNqYVVgl/8Hz/Ne67rRCccZiMCVISpwcLMILAjhmXaH2FpKNRa362tBKxB9fEj/UIzWjo1lt/9sgjV8VHgC5CpZXVHbXygz8ptfCcgtqlNJHKwws2Mtf/O5qXpqhxa+XO21eBZWZ3+5da0b1YmeGZyE2gkH91smh2fw4WscKOeMYDHSZYijoWXJT+cwWHxkbjgeWhQCwoVOnm
 V8vh4c9n
 EcuOhZp2QI2M1JpUzqeGFrNidr/SGlR7I9Y2EdZwTIuOqkgTo/iv5zO+nvU4A9MQ3xjhWJGBqt5jqvhmLuTBa49UeoWHC+/acKoKzDffqc+iw6ttYc74k6lYP3L483fM1d4nd4cXqkWMEi+Mv3aK9OkseZOGj0xigROrywe/d0MWaFc1dheq9oeJx832Pnft/EFSV1KN1G4Xu9p14fJU7/MVyqTgY0DpQHFlYa9mG7vfAAYJZLUUgwUqAQtIQe8HPa6DHOUC0kSgMYxkX8AUvLU/8E4LWh5sUn96momYRs6E0FBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 09:51:33AM -0700, James Houghton wrote:
> On Fri, Aug 28, 2026 at 10:26 PM Lance Yang <lance.yang@linux.dev> wrote:
> > >On Fri, Aug 28, 2026 at 12:50:04AM +0000, James Houghton wrote:
> > >>If userspace implements post-copy live migration using userfaultfd minor
> > >>faults, this situation is currently possible:
> > >>1. The VMA for guest memory is userfaultfd-minor-registered and nothing
> > >>   is mapped in the page tables.
> > >>2. A stale copy of a page is present in a naturally-aligned THP (from
> > >>   pre-copy live migration).
> > >>3. khugepaged collapses the mapping of the THP, installs a PMD.
> >
> > Ouch ... I missed this earlier. The problem is real, but this commit
> > message describes the wrong trigger.
> >
> > Background khugepaged calls try_collapse_pte_mapped_thp() with
> > install_pmd=false, so it cannot install the PMD or trigger this
> > sequence. MADV_COLLAPSE passes install_pmd=true and installs the PMD.
> >
> > So the problem described here can only be triggered by MADV_COLLAPSE,
> > whether it comes through madvise() or process_madvise(), no?
> 
> Oh yeah, you're right. In our downstream version, `install_pmd` is set
> to true for the khugepaged collapse path; I missed that it was false
> upstream. Sorry about that. :(
> 
> So we can definitely remove cc:stable, there is no bug here.
> 
> WRT the semantics of process_madvise(MADV_COLLAPSE) and normal
> madvise(MADV_COLLAPSE), I think it makes sense to always disallow
> collapsing of UFFD-minor VMAs, whether MADV_COLLAPSE comes from our
> own process or another. UFFD-minor faults are intended to be resolved
> only with UFFDIO_CONTINUE, and until someone asks for it, I don't
> really see a need to make MADV_COLLAPSE actually work to resolve minor
> faults. I don't think userspace can *rely* on MADV_COLLAPSE resolving
> minor faults either.

It is safer to go with stricter policy: reject always. We can always
relax it later if there is a use-case and reasoning about the interface
is solid. We don't have it yet.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

