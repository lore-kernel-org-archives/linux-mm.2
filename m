Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E80D606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 00:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=A+OFy+EU
Received: by kanga.kvack.org (Postfix)
	id DE1756B08B3; Tue, 24 Nov 2026 19:19:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6AB56B08B5; Tue, 24 Nov 2026 19:19:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD476B08B6; Tue, 24 Nov 2026 19:19:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 913CA6B08B3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:19:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA81940DC9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:19:10 +0000 (UTC)
X-FDA: 85471731660.23.C297B2C
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	by imf13.hostedemail.com (Postfix) with ESMTP id BDAA720003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:19:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=A+OFy+EU;
	dmarc=fail reason="No valid SPF" header.from=linux-m68k.org (policy=none);
	spf=none (imf13.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 103.168.172.151) smtp.mailfrom=fthain@linux-m68k.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795565949;
	b=OcXMdfrhjQVkfO9ds3BG8uK6ZE6LbFbT/tl3x1073zV2tn9j5fBZ7M468Z/v2LaJWeIzoY
	xPCw2W5awVKc77VjJZJLw09n3uDuPd9OGW7l/ej8SLajMhrfNlfhFvgjHehcXmRc85e11o
	UchTUlDPUzje7XlxA3vxnR31wTXqkr0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795565949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wr/AwtblOMezipaHToPhNNVLyAOn1X2fpKE1tESySCU=;
	b=j0zG7pnzy4oEVoLk26nviWpSm5+8IQxh1zGv4b30hcuk+Nn/CmAztIL9YAIXRhQRrJ8mX8
	ZE0OBqEZFNwXaMKgjMLjskDXbcgy/aySUIxdJlEM2UzAAJgiOTYBKnzXBqkn+J+woGQxE/
	WzdOwGWwrCj99wud8vt9QMaKr2e8Tsw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=A+OFy+EU;
	dmarc=fail reason="No valid SPF" header.from=linux-m68k.org (policy=none);
	spf=none (imf13.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 103.168.172.151) smtp.mailfrom=fthain@linux-m68k.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 25598EC0950;
	Tue, 24 Nov 2026 19:19:08 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 24 Nov 2026 19:19:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795565948; x=1795652348; bh=Wr/AwtblOMezipaHToPhNNVLyAOn1X2fpKE
	1tESySCU=; b=A+OFy+EUUuaCaPRNalAk6Vr3hEgULlXUbKwp5PU9QwIK5cXyjQF
	zSSoUo2/bCFQ41JvZxe9qCs5FMbmLdfx98Pr+ZQQwZcLIyIhetx2KjRZcys50nJl
	OV8KcG73HGzZKpGtx+BGoO/WFIH0lnBIj8AMUGEuRud/MUYiwCVWaU3w9dQLQOkD
	o9IenFi+ijBinvKIeQdUXIb5VNve/zDWnvCE2EN5RASTk5giAA1Bnoi6tgfUwDAq
	AJJPAotgOWRLBOwN4pTy+O3d5EpSHAyRT+SclQvzVmL+ASWF0/u74GlDkIeuv4ly
	zOLdCFrJXNXuQbRLe4dVNbfwhrn7guT73hQ==
X-ME-Sender: <xms:eykGa1_tL6iCKfY4hFQWmW4NfZw6gdGdaxUkEsAETB89BRz6lO9W9Q>
    <xme:eykGa2a36e5pB8n7v_5cBxjKoM0BJwpKrghcUmP2x4ztWWheChG34bMxKbjaACC-3
    PLlyIp3YnmW4Dc4PHY0Ar9EK6uhHt_2DhyY3ow9K2x7fXcXB7XfSDQ>
X-ME-Received: <xmr:eykGa26dPrTldkuWvYkhqHkF3NVVf4dPbeNZiv24zW1w1zSeB3Ehl1noqfpv7iVDmZQ0vCJTuvVXDRiUtlj65bmnR8BGFQZyHUU>
X-ME-Proxy-Cause: dmFkZTGrW6LrIh0rLNM8P2g+NO5EOoicshNnE+dDGFrHyT0MXESmCjocTu1qIWMfS8NlqM
    bgT9CMk47QoyfTIsDlzp86qjCusJVoEBMLSzM+vqYQhQZAflWqtmV95qzk23nZryhkAB5k
    ahCGzQUfukZx11BSY95RJ8qxyjl3AK4nzNmMQiGvcZ7SRFM2MBNixoy4WAaW/Uvf/QXmVA
    PX/7JlOZF+Kd2Pl0qNv1hKmCWlLBuzILcGi7UMb1i6XTHuuQ69nRoGldUbUbMT2LGNT4ps
    5znsXyMvOdWQvuFriZqFqHy3xJ4Kl2jU8jx17p/Mj+Hh2Fu95NdO1ZvaqfqFV0TpJP8BpL
    pHCXcXh1pJVDu5LimxSGVGOcPCrIKjURry+OJsf+dJD3H1ttzUSiEn2MHe9zVDyZaItRNR
    cTl8Cdc3K9I8Nmf0C/Nui5HOXf1c/S+94ZcsTU+HPl2j1FbI/t1Z+fudyF+RSm/bbj9sPj
    YOcJ2PGjHE0BCQ/juGgJ3oSqpPAFr6+kh3rufOCI62MWSmfdu0MxH8YGseAX+IenbMyGYm
    Gre7scjR5zJlbA9kRkHMRka+DnxWtRrYgBdCHr9/z54rC74AwXsa8R5S8Zatsr1mDLOSQE
    W0sg60b1XF9GnSXkEH+MIAcmwgV6SfvZJbTtygRidymu5p3Eo3+qS2lt+O/A
X-ME-Proxy: <xmx:eykGaznPRyM130R-V3gI77TvNupoJ1KqQ9EXapdxe6Ht6B8T80YdQg>
    <xmx:eykGa-G-w8dlmI8h45dxeiuGAFqd1xzxum7U7fR1vyYXXc-tbWs5zQ>
    <xmx:eykGa0izwjHfGW_o2-CzjCu3LMpWDlX61HlHeysgI0qkYSORPDgCKA>
    <xmx:eykGa7iNw_LwEEXfPRs0AMVGAL3N8ywF3zPlUUSYcFTAb9Iw5A_S7Q>
    <xmx:fCkGa0Z5Hhfnf3QsqjRci6Y-Qigmwrrw1s1eMgjThIeVrfPeVHnc6t6O>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Nov 2026 19:19:03 -0500 (EST)
Date: Wed, 25 Nov 2026 11:18:57 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Bart Van Assche <bvanassche@acm.org>, 
    Geert Uytterhoeven <geert@linux-m68k.org>, 
    kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
    linux-kernel@vger.kernel.org, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
    "Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>, 
    Nilesh Javali <njavali@marvell.com>, 
    GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
In-Reply-To: <f0ec2845-245d-43ac-9c96-242e0d1d11ea@app.fastmail.com>
Message-ID: <9120b892-6a31-d161-381b-809191017bdc@linux-m68k.org>
References: <20261121034304.2dPxVKzk-lkp@intel.com> <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org> <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com> <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org> <8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
 <85e103fe-acca-0880-1be3-cb1e7f79f9a4@linux-m68k.org> <f0ec2845-245d-43ac-9c96-242e0d1d11ea@app.fastmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: BDAA720003
X-Stat-Signature: 34cg6f6adg7fmw3oem1qmjyou9czrerd
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795565948-582004
X-HE-Meta: U2FsdGVkX1+2DNEpYXzrDIJCzIqn/Zhyy22EDUZxsBpGH6OfKFvqNKXgtrTuWLy11p4GJ0v1B/WDMJyj3WJmcW5R52JB8jnTMs8aOr+OvfX8GO/02KpUHIh0W4ZsNrxDn7FExMVtwKMw1rx1SsKCxHSueDtOQeG6Vr2zr2bwA8RcuM0BIOXPAYv23xlpscw2/kdTuH/3lYExfVyLnCoodwTO182ExTqjbmgN9Ly7QgorPWUeWVofGzLFnyV8vIPnieOsVlhkxIUZF4K6x5iSYHT2cgP8FHERyaX+ML8WoAnHosgFH1lLuxRvNl/iFYGDmhfejydVLUqhWv1Y9xs4WY04bslRP57NexS/96DdfmfGIiZKgYX5JFmUM5doCvMt8pzPUR8zeRokoJvfaed8Gm2mFwscnB+wcc1CkxTjuMv4kKuW5Z+h5kazeKrYyKXlwpS1xu21w3gSvxteeOIDA9m+6uDM/I8+RNBqGscRpgr9glOFLNaWm+LTJcRQDl6Gc1XzvdrkrfbvK1AmN7EpG5pVHb4a5U2zhoGS5OmyRQ7aUbZxipLE8WBaN4kfk6PiBJsn5f+JHLUoNluqT/aW18X8jwsAE4sJsZ8Ql3k7kI3vvFE3Cgg0n8T5DNZRldwByEb79s0GBevzTYFX17TXjZ60ZNwd9JjQyw2lL+jbsTNcf+UcSWsUSV4uVOu0sGf3e/nKBcObZVy6fcNJk+Bw5EXVHLMXWNJn9hxbXsrKxANdNKZ4eT6bm6ilyZAu+VV4y7qT63MyZahPmlGHFhd0jiiynxAY4Fu3Ufpi/94TC/bPdvEc2feYdoeyjre6fy5PAEpof9AHCKzlHlfdJ9rnq9mzwQofN4da0nfVrLJokS4HP+gAJRW8FyKqqig5YT/ru53GxhD/oJ+Jrn/30BekK83kQD6LFKqm8X5HhtzF87D2pfWzdK/wkleuvIZEWKkuL5TQtj/vqechKSQnc/5
 rYhZVIJA
 n+F1kkr5+pat+NyM4ZWSC3kecGfi9jjy4QpHAgpY1QQswDomR5Wujw2gUNWSfz5OJkaR3GuWP29yx1vzEc98f3r/hpTNtXy65T/PTImqwAFG2d4dvub8cXoEdy4l8Z75LknGn1gKy/zn2PsPrKw+/tZ0fK8gcJwId3o+rObAeE3h1HkSm2jY5HtAbCJBg3dfHh+aTRw26YQe8/j2d1lIcTcoAEVSihSdwTuIgIaWNt1JWe4RNLIDvyUgTLrujYqL1y1mIkVO4NMO1TWPE+7LiAAy2Yb94IRKDR5XQIYf/ub2WNa0PQSmPHllYi2YwKAYwpm5ZkixuTY1zztSzk3FszRv5k63haw+7G5H6IPLEG/WYf1d/L3RQpgdE3b7f1pbBsHsQwOV9xlvelo8EXjqXGtxoDnlu9ualSmhtqLZuj4b/5BM9+Au5MMY12OJNN/GCYCv5bf3ZvuzgW3GDOMF3d/2hHCsPPC8rUsCQm2v3ChIEtuLuOuAti8DR07/73W7j3dV71XGSj4ozeCj0vIxWF5B+kYY0s5V9K/w0JmoZp+8MMu+45pxPswh0EIhCh38BtypOv9PZNlwsQ3JhyMgMRa8G1nZ945fLy35ffDk2k/NeqeshizVz1EQ+PQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


[Cc qla2xxx maintainers]

On Tue, 24 Nov 2026, Arnd Bergmann wrote:

> On Tue, Nov 24, 2026, at 04:31, Finn Thain wrote:
> > On Mon, 23 Nov 2026, Bart Van Assche wrote:
> >
> > Sashiko-bot said, in response to my patch:
> >
> >     Similarly, get_datalen_for_atio() accesses the array out-of-bounds 
> >     when len > 0:
> >
> >     drivers/scsi/qla2xxx/qla_target.h:get_datalen_for_atio() {
> >     ...
> >         return get_unaligned_be32(&atio->u.isp24.fcp_cmnd.add_cdb[len * 4]);
> >     ...
> >     }
> >
> > I don't understand why the patch from your LLM did not raise the same 
> > OOB access concerns.
> 
> I suspect that is just from Bart specifically calling it out in the 
> changelog already as a known limitation "Do not modify the memcpy() call 
> in qlt_queue_unknown_atio(), which still writes past the end of the 
> 'atio' member.".
> 

OK, so Bart's LLM has made a suggestion that doesn't improve upon my patch 
except for contributing some modernization i.e. the preferred flex array 
style. I'm not sure that's appropriate for a bug fix that is to be 
backported.

> > Adding a flex array to struct qla_tgt_sess_op can prevent new struct 
> > members being added in the wrong spot in that struct but can't prevent 
> > new struct members being added to struct atio7_fcp_cmnd. Neither does 
> > the assertion. So the "remove" alternative doesn't have all the 
> > disadvantages that you might expect.
> 
> This is probably just a difference in perception: atio_from_isp and 
> everything inside is clearly marked as a hardware structure that is 
> meant to align exactly to the 64 byte cacheline, so it would not make 
> any sense to change its layout and add more members here.

If this driver is for x86_64 only, as you seem to be implying, then the 
right fix for this build failure would seem to be Kconfig:

--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -29,6 +29,7 @@ config SCSI_QLA_FC
 
 config TCM_QLA2XXX
        tristate "TCM_QLA2XXX fabric module for QLogic 24xx+ series target mode HBAs"
+       depends on X86_64
        depends on SCSI_QLA_FC && TARGET_CORE
        depends on LIBFC
        select BTREE

I wonder whether the driver maintainers would like to comment on this 
possibility.

> qla_tgt_sess_op on the other hand is clearly not a hardware structure 
> but an in-kernel one so it is quite unexpected that one of its members 
> extends past the end, especially when the other three instances of 
> atio_from_isp in data structures don't seem to do that.
> 
> >> @@ -227,7 +224,7 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
> >>   		add_cdb_len =
> >>   			((unsigned int) atio->u.isp24.fcp_cmnd.add_cdb_len) * 4;
> >> 
> >> -	u = kzalloc(sizeof(*u) + add_cdb_len, GFP_ATOMIC);
> >> +	u = kzalloc_flex(*u, extra_cdb, add_cdb_len, GFP_ATOMIC);
> >>   	if (u == NULL)
> >>  		goto out_term;
> 
> While this does make the current implementation more correct by having
> the correct length, I'm worried that it just ends up establishing
> the complexity more in the sense that extra_cdb extends both into
> the padding and beyond qla_tgt_sess_op.
> 
> If the driver is still actively maintained, it would be nice to
> reduce the complexity instead, in one of two ways:
> 
> a) make atio_from_isp naturally aligned by dropping the bogus
>    __packed attribute, 

I don't think I follow. "Natural" alignment would be at integer multiples 
of the struct size, right? Moreover, the correct alignment for a hardware 
struct is a question for the hardware vendor, isn't it?

>    so it is actually at the end of qla_tgt_sess_op
>    as the driver was written to expect. 

FWIW, I think __packed on a hardware struct is at least as desirable as 
portable drivers are.

If the host ABI places padding after the hardware struct, that's a 
non-issue -- unless, of course, there is a bogus BUILD_BUG_ON that trips 
over the padding, which is exactly the bogosity causing the issue.

>    Note that having the
>    outer structure as __packed but the union and the inner
>    structs as aligned is itself problematic and can lead to
>    undefined behavior, if some code ever takes a pointer to
>    one of the inner aggregates and expects it to be aligned.
>    The only effect that I see from the __packed annotation is
>    that it forces expensive byte access on dma-coherent memory
>    despite it being fully aligned.
> 
> b) rework the driver more broadly to never actually do any
>    accesses beyond a struct boundary and make it work with
>    sanitizers enabled. One way to do this would be to
>    have a separate isp24 atio structure that is not in the
>    union but that encloses the actual maximum length.
>    Not sure how this would actually be done, but it appears
>    that the current design keeps causing problems, see e.g.
>    091719c21d5a ("scsi: qla2xxx: target: Fix invalid memory
>    access with big CDBs") which adds more complexity around
>    keeping an extra copy for it.
> 

It's not clear to me that UBSAN and FORTIFY can actually do what this 
static_assert() does. Maybe that's another "difference in perception".

I agree that sanitizers are worthwhile but I fear that this horse has 
already bolted. Surely worth considering for new code though.

