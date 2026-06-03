Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD2E7CD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 09:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9C66B0092; Wed,  3 Jun 2026 05:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5ACC6B0093; Wed,  3 Jun 2026 05:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4A7B6B0095; Wed,  3 Jun 2026 05:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0F5A6B0092
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:21:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6373E1A02E4
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:21:23 +0000 (UTC)
X-FDA: 84838058046.30.A46781E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5FE89A000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:21:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7ZuQvg9;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780478481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgLV3qve7G1GecGSZYkHdq6Ku3vCzMZw8vqb7sfTuVg=;
	b=4mpOQpwpTuGOni7bY7WATwpoQZjnamLyF3Ps8gkljDzkeFDzwg5LoQhrsr7B9DrIhTAO09
	6C7AKs2FhMNS9SfcsoY+gj3e+1bXXwMv2HSroiBIEMiV+OcUhaNoa4o8pqzzWgTvTmyIJv
	Zz75nqoga7hv2Ehf3n5ZZ/bie0monw0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780478481;
	b=U5NjDvJlbnejpVGrk93bbfrMvgegyA9DBjlmEkSHe4RZA+66WXg9t21tCdZ6qxfIxS4h82
	2iJp2IMH3BhwNtxzaXvC9/8+vAcQ81d2RqdrznTjQb7n4rKpdDmwIBpqlXDUi5E/1kgaKV
	oJdwnlAYihrP3vigei7NWg0y/j0NAOA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7ZuQvg9;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A15B244517
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FE61F00893;
	Wed,  3 Jun 2026 09:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780478480;
	bh=fgLV3qve7G1GecGSZYkHdq6Ku3vCzMZw8vqb7sfTuVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y7ZuQvg99YxIloP6JuBlb5bV2STnlPBaqT7/2KQ40onPIplPQzN+u1eNkUBKbS3mh
	 68ZjCVbpYMx+GT/1yIJ4ZD+OE9VDDnSGY79gIly/SU9Xzmy96B0nl85Sn0XhnmBDil
	 1P7v/fkS+PYsr1JN0IMTUKQS1caGnwmKOej9bv/Pu61IetFM3gwokV8KJuCn5TLYTI
	 IjmkXQOkzQo1kPOnbfUW7plYs5ta0Qxz+MpAhx8VepsbpMoL7aJZ43iaV5uOR6Lv8S
	 EY2JQwqep9ilqJlDWz2Y74z58kyv+Ei5r6gmXJVwB1kQmCZwB0K35ztJkOJ/BPBVZI
	 HLiyrfT0TMXCg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 93F99F40073;
	Wed,  3 Jun 2026 05:21:19 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 03 Jun 2026 05:21:19 -0400
X-ME-Sender: <xms:D_IfamWVoxirqa4wUoyUf_9YNIIdJUGWzX7UYNabW5tH_V2oQvC_2A>
    <xme:D_IfakKXqfeOCg-P0ks-DD41OmvWH7GuH2WTF8ALVrVfp2549FJU1N_6H3f98UW_Z
    8TAld7-XJftPGCnZFgE7sHBWuN_iQiGLuNUiKCaT2wFA862g16uPSw>
X-ME-Received: <xmr:D_IfappJfcQ2bXl7jSlWIynDNOE-CU2xw2fecCe-s7e40E9LaegyvgHEBg_rLw>
X-ME-Proxy-Cause: dmFkZTGE78CzW0IUZCJ6+NkcZ0dLIyp0qtrQ6f1qFCEwHUdT3FoVqs/RhOzjFD2CzZiP+w
    UZcBx1AJ2T3lSILTzz0RD0vi5Ak/QTV83P71jaPaNS6inZurPhY6FhKeza8gAB/Qya5A+r
    iyNzakbBbGTv7Cu7dnBJ8fRRLtHmhFuXpGIMvPiNzCY7V/AfgmX7+2N0e6rs2Pzx/R3T1z
    OKf1cNIWC6iZzltCZtQ+EJEAiHFlvr/ik7QvW+hiaL9rCbtbNqSC79SurWqYwCLdroTjyM
    zelQS92nT+OPUeuZYGOLV0sE5AMufRlRgPq5VMwZ10Ue8eCg5o6r4Afij1nX4Jn+etLQJ2
    na6WfHQ778ybBsqNOSkFnKPD9Z4REAsQZoprAkXkvM6de27qpocSVI3uHT+iDVb1qr+bB5
    rFa/1n2TgN3LVf1I6XzcNjCf27lJJEvSabdzejt+byNU5SSdSWQ7NsNx9BbnR2/DXBbRjb
    xnTAiDun50qp1SBRNtBtFVQMBeELKHpH4XZ/shgpVfzVAkDz212tApkhfVyhiJAUOCJUpJ
    m3FO0kBYOmQe012cTsmibWu3T7Ei8hfXI+QwFdpJ9F12AzVaSg/ZRoERGJeqsy6mmAhqmL
    pro82W1EeYq94vSWZI4uuvHj7tS0CsLmCO0O5D+4XT12Znm7lNVmgaZyTFjQ
X-ME-Proxy: <xmx:D_IfajyEb8qUL_BxBmlhtHoPVC4cV-kMLEcl6axxtIinjvKqLr9ZHQ>
    <xmx:D_IfaltDMhvS9NM-oExsyco27eLRd7bX6rwpP1zXBn5qxKT4e3uWpQ>
    <xmx:D_Ifak3uOBGNZ1myrrCeRZ0pRhQp8GAEp_pq9NlPKLo5BDb0LTFDHA>
    <xmx:D_IfalDGQm1ETpzBadc3jS0rdCD7g15-OEfY3ECZ4JyyYZTAGixXuw>
    <xmx:D_IfaqDvxxrKJFKCazDCpi4PtS6Wy3r-POVsBDO7p76wz78kIcYr3tAi>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 3 Jun 2026 05:21:18 -0400 (EDT)
Date: Wed, 3 Jun 2026 10:21:13 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH 0/6] userfaultfd/pagemap: pre-existing fixes
Message-ID: <ah_xuV5PUKTfT5ua@thinkstation>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529173448.40a37785ecbecb6868fdd6a2@linux-foundation.org>
 <ah2S7MJ2VK6R-NSN@thinkstation>
 <04875b82-6671-4f43-aa59-190fd09c7108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04875b82-6671-4f43-aa59-190fd09c7108@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5FE89A000E
X-Stat-Signature: 5m1ddbb4regnmi66b6f4ibjpbax6mr1q
X-HE-Tag: 1780478481-599832
X-HE-Meta: U2FsdGVkX18OmwGVHl0avQ4bD7aUz1qPG9UymA8epE+d2UtEVbs0MLJUJY8ieUExEKxR1mdxsXkGLL3uKfr2ZC4cKUagjeeY+MgppeZG6ERIY6+iQHGdiIZPvjACufezPudbYEGaSlNI9/hYEDmHDDnO8okq5D7T5lZFu2jlsSpURXOwk5HnlaseP4GoA7fWb5gs0P4OcIjZ4ixmZN42jpZj0mqb8Zq3WtF3DKGNbcNdLjQ7osMDhCiyWeTM52cYOY11ZOLhTU9c9qiqSj4oc3oDfmdz7vC+vBI6aPo4QEXNv6n9LY/0ShqO0bCrAd0RL0n9E7tSk3S0PSRIzfROB83odTWfyov8Ro5N+O0VQ7gModd2UrzTez9KDwbbdsCflajOSj22PwpG+QTb+pUN76gjPilKazMXuqfUO02It0yPAdQPSAdDyrfxBowEbNqhzrSkft2FNlxo6Y3EraUmnVE66cUhwGAd9a1pZB7A7oONwUAaFAsecOXVMfT3FXtQXbu07JqgD9acev5It0kXdM+ztgWpPSCJ3bPBRMS29It6IvhqgqMdHaxo78b5CFETQcz8u8RH+8vRzt66KSuOsH4jAXUxYxR2veBZxNp51fqNC1dLWlsUwR55lHi5b6p6AdfA7cuogcdlM9PYeo0mNbJuNlAOu573gy0Akawlz8zTuFOWYFSkLfTKV/aMvcVfe/dJ8a1j9UnHyFiQddc2mQ97k8xKMWntIdtaT+3hu7kdv0gdCozcAYOTvWFlCkiyQu4aS0psB5twQgbFqiJ5mIMmpl9+/QTU5aKlNWwlG4XuxQAPNX1x2tO9CI3aWY2tNdEXU1HTH4YfIFDDOTV3XuuTsW04FY9KTIFpfpkrKTDM3jjDFvw0HSrYFuiBDmgf8fIebEh/vlPIJ5XMzcdLkjsJsYl5HzAmQgGw5M1Vu3BWFv8BA2uO2Nw1bb48CuggwUFvWmbKc+1vJQHx4Oz
 uY6tbh++
 iQdOQ4pHtAkoRslrX39w7+R4kcqseX7hHA/TXag34kXyEz9VQD3c+Y1tebf3dDVimVEgKhHVHZzFVmKZlGQVze5VxqeoPXgx6fJY4w8fEPEn0vfv0D8K7xz6ZbnJw725tnQ5D8nNv5BdYC13ezuRB/SqhyIjGlexXDoizkXwxsz6MhTuiu9u2zbzWWLkVXiPCDksXkK5d2UOujM4k8ouoUtRJkv3XfNdev+oeYeUup0L2zSLPMYfPqUVRH+A0LvcSekBjkJVZAV/IMNzBOACqyHUYetX/bi+nXSuASasczqnDFkrnIc/ZMC468AL3qcrnLvOGR0QVZioZesZFxbjDKJlyBndTyqRa8EF1y9GP3fs4fjwODLtEyvFycao33Rxb4tCbafYiypJU8x4cQemUylMBVJuiSViSvlgtWOjcz0hSQqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 05:04:31PM +0200, David Hildenbrand (Arm) wrote:
> On 6/1/26 16:17, Kiryl Shutsemau wrote:
> > On Fri, May 29, 2026 at 05:34:48PM -0700, Andrew Morton wrote:
> >> On Fri, 29 May 2026 18:23:24 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:
> >>
> >>> These are pre-existing bug fixes that were carried at the front of the
> >>> userfaultfd RWP working-set-tracking series up to v5 [1]. Per review
> >>> feedback that fixes should not sit in the middle of a feature series,
> >>> they are split out and sent on their own; the RWP series is reposted
> >>> rebased on top of this.
> >>>
> >>> All six were flagged by the Sashiko AI review of the RWP series and
> >>> carry Reported-by: Sashiko AI review <sashiko-bot@kernel.org>. They are
> >>> independent of RWP, apply to mm-new directly, and carry Cc: stable@.
> >>
> >> And...  this made Sashiko point at other stuff:
> >> 	https://sashiko.dev/#/patchset/20260529172331.356655-1-kas@kernel.org
> >>
> >> I can't figure out why four of the scans failed - "View Raw Log" comes up empty.
> > 
> > Seems to be passed now.
> > 
> >> It's concerning how frequently Sashiko is finding pre-existing things.  What
> >> would a full scan of mm/ tell us?  Gulp.
> > 
> > Yeah... :/
> > 
> > I will look at the new batch of pre-existing issues when I have spare
> > cycles. I am not sure I have the bandwidth to find the bottom of this
> > rabbit hole.
> > 
> > What do you want me to with the main userfaultfd patchset? Sashiko
> > failed to apply it because it is on top of the pre-existing fixes.
> 
> I suspect it might have a minor conflict with another incoming fix from Lorenzo
> as well.
> 
> Probably put it into mm-unstable early after the next release? At least I think
> it's not in mm-unstable yet and we are approaching the net release quickly ...

I guess I would need to patch man-pages that got applied. I put 7.2
there...

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

