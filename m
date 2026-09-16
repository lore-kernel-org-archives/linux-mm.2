Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4877C982CC
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 16:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DC2A6B0088; Wed, 16 Sep 2026 12:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D126B008C; Wed, 16 Sep 2026 12:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9146B0092; Wed, 16 Sep 2026 12:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55CFA6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:10:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA0534078C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:10:54 +0000 (UTC)
X-FDA: 85220114028.17.FA5E458
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 00DEB40015
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:10:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jR3nSyDO;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789575051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EzULl2Rsxwfe7EFb6MSMik7LenJTHelPDSDR0csqtEA=;
	b=QYhORqNJH+xr4xLjJ0MUdVmc65GdqfvKB/4eWRJqXkrhlQWd+TdCSjWWo0F6M/VooqHHnZ
	sISLTgQtbcQGAKWwdFqVpbTkCgINLFD7xWGI0ikv+MG0NIEQV/kIsSx0Hay2QwSHY1O4EM
	VuWTw6MpblVOSdX6/f2Hufw6vnWZJ+c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jR3nSyDO;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789575051;
	b=WoDokGTraFj/7MvSEXg5ypGl8kbAnR6pBf8KxSTFFnLBd/a/Xan3ogFr8siC48kbypbM6m
	0/7hZBAvptr9u/JeLJSI6PGK+0FjA3yc9J4GbjrHaW7HekkcDQ7De+vOKLzwHvS083Fxqf
	d8lXsBtb3llYyUUq2FTqPNWmcT3kxDE=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93a10f9a2easo194641585a.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789575050; x=1790179850; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EzULl2Rsxwfe7EFb6MSMik7LenJTHelPDSDR0csqtEA=;
        b=jR3nSyDOaWUpgu5z6vsD5HD87WgwSK5hObMRo8NMop4tCG4sKW+aZWd8NCDv5XAxBz
         Pm8OIYuuxI4VkQmdwIEzPjv6yDdM92XBGKZ4l6NYxjS15yKdaL39YNPF+gdtqiB6LQ3E
         KFPyW3XfOagnkZLeUNiBSoGjWEw/pzeG0Tjqkpsn9nRzOzpa9izibdaZxU7s3op2kqko
         HvxLQlPzliTRA+Otsuh6EtIyQMkA2n0nx7jq18WMijF/HLyuxR10lwkTU1b6N/IChPGS
         BXZRSAjmDLcv3dGp3MmCSAtbE0O5sXI9OrSnBg0RAnurop2PqTdbvpaoERIUERMNCEMF
         IY+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789575050; x=1790179850;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EzULl2Rsxwfe7EFb6MSMik7LenJTHelPDSDR0csqtEA=;
        b=CxE/hTjj7eRqGjLqNufHs9ETm+l2J4vGxf5HG/WuIvxfFxxH9kHy+WtAt3WVM/pAIW
         k0vYi4EXhSJDn1GBbLi0RLF15O3DoIqNcA+a8bNtvZ2YUt83+z5kdRbK5q1Hva68DLKh
         yLYpz0+LdkzZ4I1FVXPFzHFkiv39q730D8aApKj0eZXlkOwOmNU1ST2k9m5veUJcV/UQ
         vJGPpNi7bMI7P6Va+4uH49YT0ONMosg9o0anKvOso8YiMMjhMXuAkXx0hhhG3SUltAqD
         7i48kvOt4w+15rY1uY9DI6EFOGl6GHYIeBQIcO6tywEF5e8j4jA3p0Q9ZtZ7bpPpDnjj
         p2Ig==
X-Forwarded-Encrypted: i=1; AKwUvByWa+MwcvFxvfKj2x+ZqRgH+s5/Wq6hQD+1lIlyjFOyNcUliJzdG2QRK+HS+2bz4MRqIGJJF7wJYw==@kvack.org
X-Gm-Message-State: AFuF++lPwDvKmVXfm2Xb6B7yz/SbuX8NOQPdDXGe2dyVPKvKUB59Y5hZ
	byEcYR8fUb9/+L78TISB3z4WamwicQua90MfA+NoLAmNxzhC+CgJeVJ8mmavmK1N2jA=
X-Gm-Gg: AYBFou0Cc5ZMdITR4yOzJbzAXvIWTH//Isbs6syVsWlArqjXWb3UncT/5pW3Y+prP2A
	cNUenn5uLki+YcQPo3XkVXyqEEw2MzXSyTEFVlzcfEq6986yXrk7mKEYNXBxeKQeyt2ADeeVQaT
	+LSfR0EsgINr9WbceKky4qK73yOJiguLJGvrpxf6VBALU33/ul6Sv3NznNQR/8qGqHa6QGRfKwb
	jKQs3+PdBBFkOpacb+BzpN/M3B3Hr8HcjCWOVimgok5xcUfkeB0QhEiUuUK/DQCE2J8t7VvNc1K
	CeVq4+iKV+DqvnG02s7t0/qZi00/muzLxSiCscWlQ+g2lVnWOrebfROEx4NTqZzlO6Jzplubj55
	3fc8gqa0uWp8L1nUcB0ga/VnKnne2YETn/wlTNOZ6OgIkK80vvUlPeVKLB+bQ5anChh6XeeJ09P
	OUHaBKOtb49MJeyiolO7a3FsIy3TVlGtliIFbD6qOHzDTlVRgfe8OPBOCeXE9h/S3D6P3KjeMWg
	Z8L4R+3wJhbY2CrWwi3v8YpLqkqzEhepefUfiO1ShXzKqQT8RvwHIs=
X-Received: by 2002:a05:620a:1b83:b0:93a:1196:ce5 with SMTP id af79cd13be357-93bc63ec899mr23113285a.33.1789575049934;
        Wed, 16 Sep 2026 09:10:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b782562c0sm248094585a.32.2026.09.16.09.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 09:10:49 -0700 (PDT)
Date: Wed, 16 Sep 2026 12:10:47 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, wangjiexun@tinylab.org, 
	sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqq6ey3DG9h5NIDZ@gourry-fedora-PF4VCD3F>
References: <aqqbB_nFAOGenDhy@gourry-fedora-PF4VCD3F>
 <aqqjW5dpyznijYLh@gremlin>
 <aqqk89oTigJ9LS2N@gourry-fedora-PF4VCD3F>
 <5437871c-d9ee-49d2-b24f-965c73c29c3e@kernel.org>
 <aqquDtEZL1ndymGN@gourry-fedora-PF4VCD3F>
 <46d923e6-5724-4df6-b0d5-8dda7c547f6e@kernel.org>
 <aqqyhkZqcXDUrzeb@gourry-fedora-PF4VCD3F>
 <4fadcda7-d96a-4cd9-9b0f-5d387b6f82af@kernel.org>
 <aqq23i9824-GWdhg@gourry-fedora-PF4VCD3F>
 <9b50a047-b5e6-45c3-aee6-551896b52eaa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b50a047-b5e6-45c3-aee6-551896b52eaa@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 00DEB40015
X-Stat-Signature: tnudcitirk58jyt5odeupbtab36ohp6e
X-Rspam-User: 
X-HE-Tag: 1789575050-481151
X-HE-Meta: U2FsdGVkX185gshjsni7L7tLcxeWwV8wx+sLnyqIhEVIvuKSYem2HbbA0xGvyaAdG5clr7L6q6aDXXzZqrOUhQDNNkrKW/kdf4uvFbi1fokhlbA/w0+PFD4CL/C3F6bKlgC265XGpAO26fDy3/SPxdfDEeeXakcq+MlO4R32YdrTklhJX1xypEXeRmfYfOimsGlup+1LE77dA9YFmu1+BzRJcdQK7AWBWzpUWlvDIv+u9KS7rYpxV7FPUkw4xrtoVAOvEYJiAyGQQQ5vpHCY2KmkHujCt9CWLAa7OkbvTVWFF5hAac+T7PJjlWeOUAQuDCqQfLwcZjmY29zC0ZC56fuvOonthdWncqdgzAa36+hDSmAJqZe+MkOgm6mXZj+5uPos9juuCMUMiGC84cJn+NocFltdQ4bEmFNGK3wVhordCVYXzVQ9QvPrOlC0MeBTRIj4/Zjdf7ioR3Zr5ZYnAkJaJo1G910no3esjlbt0gBRvorcqCuyN1VV5ItvlYrIt9snbE3spnZFKFeRb0r1CXuxlvJ9ipck8D+yq0tteve0awtAnjSJx0SQvOw+xHdW6CyTpw6jjQ+3qVi2QenqjJyzLyCpT2g6gnNthahOzuooI1mQ6IyRDXgVnj4eG0ACNdsE4xAPs9ZP+rm9LjgaeQjJvi6rJFmxmtgr7ww6NIM4PRzWmB6EsPymBgXg6+z2Azv1ZDte6J6jkkjUbGXLs843jR2dCXZ/ORKxLq9YmacUv863hkIyTo/tsEehfDNrvrdzabzsLr5omrwp5XLj/5RIduYpgnVVl1u5sSFKJWckvqupdm1KQ62ecTb05p7BfQ3R8bzOfBOGH0HNrBtZt/V4yYZh+Rl4EB0jk453adeeOInHf5lEZhl7SWF0e3npEfFkwHHULDX8xcPx5Q7FoQ3MaInTlcv8mUuAEoraDTpIoATCLKDSghETgUh/x9f2KPWZSDmlTWB37Wojh7z
 GeIl4fHY
 fvmpWgeUEH2Y2/Y/224fzCT2jWtxwGXWbeUfwQTLADweyS2Ph9x8CO5/aobjJ4FlGtSUQMfoHE0U/V6jOGS5W2x4PIK9Wty4CAGOgABNg6kdAmDmZ8638U4pH994m4JAhtu7jkm8bJTN4RkxeFbqTtZ7DPGlnyHHzeQqVW6X8AC6Xmzp9YBTwomX9Zd5Jv0L4icpf2glc5QL4IEh0DW0Ow7sCQ+imdsGde+n8APTEaCa9wip91TMgO6gUviyH5De+QhKHJvOoGQgqHmMI4a9T/VrASzzfIzJKP4tNm/H5nDTLvxIRR8PXC1mN6gG5DANvYNC1fuAoJ6ewG2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 05:42:43PM +0200, David Hildenbrand (Arm) wrote:
> On 9/16/26 17:37, Gregory Price wrote:
> > On Wed, Sep 16, 2026 at 05:24:43PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/16/26 17:19, Gregory Price wrote:
> >>>
> >>> You missed this part:
> >>>
> >>> "I'm trying to be careful about not causing a bigger maintenance burden"
> >>>
> >>> I wouldn't do that to you :]
> >>
> >> I just wanted to make it very clear that I don't need another schlopped gigantic
> >> patch series in my inbox that I'll mostly have to ignore because it's
> >> un-reviewable ;)
> >>
> > 
> > I would never :]
> > 
> > But *motions generally at madvise* if this isn't schlop i don't know
> > what is lol.
> 
> Just to be clear, I enjoy any cleanups in that area which are well written (and
> your track record shows that you do exceptional work ;) ).
> 
> I would also enjoy a properly stubbed page allocator as well as I envisioned ...
> as long as it's not something schlopped together and rushed out.
> 
> ... of course you would never work-slop me/us like that! :)
> 

It's fundamentally a bootstrapping problem.

Regardless of whether an LLM wrote the tests for page_alloc in its
current form - it's going to be schloppy, because the code itself was
never written to be testable in the first place.

That's the actual problem we're all dancing around.

~Gregory

