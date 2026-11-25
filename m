Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7836F606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=mG1WdPQe
Received: by kanga.kvack.org (Postfix)
	id 94D7E6B0947; Wed, 25 Nov 2026 03:53:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD686B0949; Wed, 25 Nov 2026 03:53:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814036B094A; Wed, 25 Nov 2026 03:53:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7736B0947
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:53:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB757C0E32
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:53:23 +0000 (UTC)
X-FDA: 85473027486.13.4AF3173
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9857F4000C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:53:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=mG1WdPQe;
	dmarc=fail reason="No valid SPF" header.from=linux-m68k.org (policy=none);
	spf=none (imf04.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 202.12.124.158) smtp.mailfrom=fthain@linux-m68k.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795596802;
	b=xtNMkZSfz+M/XKwx0+RAhBiK9lHXrSYUYu/CBbkYX/5+QuVxyiFXQXEr0ladhc7Vx0Puev
	y2bhQv3AfhdmYG2yIHBeJAxSZSvHeyJ31a0JJJXFu1kqrRt2Xb/7vu1LOjqmmLHOVUWutG
	2Iz38BVKRw86o47aYkfHc4fmoZqZoiE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795596802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nq5Ty1n7WI1400BfK5t4dJ5itvlOKXYtVXJbOMjndJU=;
	b=EqjJAJKgrJTAvDr4n2GwOkbP/H7K8yMqzshefplFe7DFzyX5hWRT5zujjJUsrFLHI8uZZR
	9NmBYXo8EujgVHKWr2PTWKjfZwlJASyQAztCGvSBt/FGK0uid3B3dbqQJS6WrYJkQScFh3
	70214SEAJ2mQ2M796zFX+UXzb+6Iyow=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=mG1WdPQe;
	dmarc=fail reason="No valid SPF" header.from=linux-m68k.org (policy=none);
	spf=none (imf04.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 202.12.124.158) smtp.mailfrom=fthain@linux-m68k.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 72AFC7A03DA;
	Wed, 25 Nov 2026 03:53:20 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 25 Nov 2026 03:53:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795596800; x=1795683200; bh=Nq5Ty1n7WI1400BfK5t4dJ5itvlOKXYtVXJ
	bOMjndJU=; b=mG1WdPQeI7YENxWxm4IAEHymREVU21ImpiPjBt0RW9IODa7x4Wb
	9hv9sd6h7PrD/SVlxVxyG3G4OkQULTOQKxtja9rmwHfdMHcsEqg6jR4H0s7p38Lm
	GM2QKzfAqid1b0mNUlqZdkDB0nc9XLEKMecW/sZBqWcVaWTnwhiL9ApaJhnRjj+B
	fZjBdJIhfAfm0YD6KcxJew+RY56DpEdALb/R6ohYaz+gUqXdEZNIKZjnZVUcRUiv
	UBCyJCeg2YzZjZPYm1MZGGRixjqFTJunnhVtFQgYEgkkQ7luHGftrj6nm5aYGr0P
	i5iQPpdiSdQy7JwZZMlPf+Cy3KIfn3gB8Cw==
X-ME-Sender: <xms:_6EGa2Il-wIV7KtGZYc5LNSgVbgUCH4Do4VHv3Gib5RHjH654nYZbg>
    <xme:_6EGa61Ch2jE8OBz0rSxN9kJG2Kq6SvcHMBtESNrLD4d2eggtwHV8MIXSSkkkaY_8
    q5a5baSLRtbSrChu50zIQdbWPmJM32EBX3zFuiH343sor2R0bJWgnU>
X-ME-Received: <xmr:_6EGa6m06P7zk-ctlH0W67gUurH-fdJD1fq5AmR1YGFNWCH5t016r6kZXdRyZU3l0VNJ_tD0apC5iPJ3efwC3mgU77GSw-7E95s>
X-ME-Proxy-Cause: dmFkZTFUA/bVlCZCxsrJPN57JQkSodsFTremyaU8vLIrFvsXwTNWYk2VNB9uZ9a2iI5Z3C
    fkg4XZJYnM2zUNLSxNJmL/LHiuhLaEM7I92MUT+pCIdHx6dou4NJgT4ApWZ9ZqFc0B/dbu
    +fD3sDxsarhJdXX9MaiesjmZnzfVENUmNYVIgCddxnecxd2d4lxZXNPYx8Pbtv7Yoksaxl
    IZe9LbNGNhunuBqUdau3bUUNG0WB1j7fGS3Lxg/GdBswdOelGTFXcJmk/TGB0zGe0Noxg6
    R5kLVS+IQmwHUo9CBfuJ9xu4Vm3I0b2lDWBLH/tbrkVHKJZTYhn2JvYqB3O542KHaBrdY9
    8wNi8VNdi9+NudiWRrEVaKqM6KrW4Z0AY3BTox8wR20sbkivRpmFAaE+5dF5+KtrY9ENkB
    UIjziclwSdh/YCSomPRWsvnBeWDk9IQdW33hAGrW91gJlI4S3icAFUrDY/VEBCoKeXd4kk
    COVGjEst/ei4z/VfDFSn6enbiGe2Fon537AQfb86SikeVuBd7ImRiARVzR0CkC6c/f55A4
    0n0C6jSXm50TtyOjOx6mN0/rPzMpNQJwa2H5gfR1zBg0Q4UGGBgGLiOCAu/0GeT70ZDrr1
    3oM7H1uFHCsD5PJGVLi1z3eQV6GW9gPE2d5nnBVTMCgErxG+w0ndMvj50E1g
X-ME-Proxy: <xmx:_6EGa1i19lL7_1sroUhxgWQ0REvtDIQmTRHg1JZ-jbKZ18O-UNtLXA>
    <xmx:_6EGaxSUjz5XPdSGgyKAW4j2tMGAs3rKbfh1_uzW_HL4C1LkLWCFHQ>
    <xmx:_6EGa_9LHK1iUYfaauOSmFsr9RDSoJ1NK76AW-obFmAMIfcxhV3kgw>
    <xmx:_6EGa6P90XGX5J9kk--sudaMc8H3_BBke4hKkmusjrUbEUQs6k5PoQ>
    <xmx:AKIGa0eaql-mFaqeRtd6baB4XvuzSOi0uFT--W3-9z4vMstDHmKVRcM6>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 03:53:16 -0500 (EST)
Date: Wed, 25 Nov 2026 19:53:11 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Bart Van Assche <bvanassche@acm.org>, 
    Geert Uytterhoeven <geert@linux-m68k.org>, 
    kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
    linux-kernel@vger.kernel.org, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
    "Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>, 
    Nilesh Javali <njavali@marvell.com>, 
    GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
In-Reply-To: <9ada54e5-d80a-4d3c-a491-87e7a99f2ac8@app.fastmail.com>
Message-ID: <cb52daef-8182-1821-60bf-ccb6475b613c@linux-m68k.org>
References: <20261121034304.2dPxVKzk-lkp@intel.com> <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org> <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com> <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org> <8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
 <85e103fe-acca-0880-1be3-cb1e7f79f9a4@linux-m68k.org> <f0ec2845-245d-43ac-9c96-242e0d1d11ea@app.fastmail.com> <9120b892-6a31-d161-381b-809191017bdc@linux-m68k.org> <9ada54e5-d80a-4d3c-a491-87e7a99f2ac8@app.fastmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspamd-Queue-Id: 9857F4000C
X-Stat-Signature: moyg4jwmojk645t79bdnwkiqbxo7rtr5
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795596801-306822
X-HE-Meta: U2FsdGVkX1+Br7v/YEe/DjlmNy2Zw1lFENdCuFCjIF9vViJmcDCqrWOZPU3XovhbSUT0rTNbRX34omb4AeRCHxWyA7qQl+3j6P2oC4UCYlP1S87eWclKTxo9XiFfHoCWM/jg4uyDe9VL2MW34Mt1YRXIm3TptIX7DuWSAfPrbn1MpGTqwIsYKYXwDHdv7mMCQFvx1sw4BHH9JkpGJVBBn1IPYPXr/RQ6We+P2F//ZzWB3cEKVPlhfu+/eUuxQmyfqChC1ggvFP/QKcC2ocMYjtdT4zWNrXwxIQs00Lo0vKsKI8uoZd7JStW/IlJDZKvEBMnVpVl39GOniG/TEdc2+FiQaw4nOsBN132KB8LvcHDeNnC2c/go9wL9qRIjCvBAzAQ4qh2mgV551+lMkCJ4VOGTea0KfNhLljx6lp3oNuMS8HpKobXWZ4pZxGSyLdJmEJXtaxrG3WX3xaynr+MMffmUugkmEeD8qUighX4afmaCRwp0HCvv7VG2O079g3/W+JtxSHcIMOEndtHOqO6/Xjz1yjX7RXxHQfH59F1ovG0Z9KRXcNIEqEYAiv1shfflFxpDiXoFlSr6NgW7UlJmo8vEBF8vyaHFNvWXG24FnrYZ5TIdFly1wlhvVAa2bAoTJXUKnNmxO2I9V36qzRg1Y/jbuM740/HcmQ2+1Lo0G97szu0FjPm0JjQ7ImIZ6jVVHEvWA9RcUmSI4QdR/aOc8+H9Vob4Zwrf3dqoNy1H4YeQNXQ/GEXJlsEiKG+x2v739bCCqMU46fYj+OZtorPsgf/UOY83V0SgxVSe+Nn1Y18PObKY60Eo4MOaYi/9KHCIFZ/hv6g4qTutC2F7o13rev3eMuWcFayH71qcqilrxk4toC6D7xetCFrHLLCb3gHK8PseAv9CvUOx/yCODEX8annPf1cWdf0COFXnyQkyYbzD764Jw0WbjQd8QA/nQx3JSpsoQEiuHUPcLyi01VG
 KQDEk3Og
 7pxpaGy20/5Ju3EwUiWn5Rnxo6aN2PIeP2oyvfDFGK2gBRZYhFpvuvlWGEDrGBZvTNpugg7jBSsLZWxrtRd2wxEaRHrOLYQ7OItI7uUJ7Dkf0LJ4v4HptxRJLsbztfsb1256h2VzK5S+jGdC7lqv/Td8bsXU+xXsUK6cMSfJxzbkzN3simiM0WkbGIQ8XSIbzZtr8rLEoziAT4gF9pmELNxZe2s5byFXBe0wpCYd8kQ8CExCr0SI4di049xIWFw6A3dYlHGRkPsyls68UkQLEFTPtLm6iUTVrGEKyC9Bs42kFAejKon+zAmdz1vNCxwrFkRcbo/XxCgEpU/fQYdnRK3rWJGef5zATKy6dA0dD+8TRA44ZDW49CCG5FWYtMpsimUKePlK5Kf+Lv/vT+CuecQz7YmVMWyPbyzNyFzyFdTsSS+Jpym4/aMtx0ODf/bgowGeXJlKZM1V5YblfAGI4n7p1DT1yNslthR1D2STetBVNVyuiRsljW6ordKQxyRAFUsYXZZu885O7eYQK7RjQuJEm3+/QTLeNceVR7DXOFzYgyq7Io12GB4SAc76XMCaY5k1/Ym+n2asCt2Uw3SlIAAezggcHPZMwSWBxYKZpeRdxiwEvU6RMBzTumQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Wed, 25 Nov 2026, Arnd Bergmann wrote:

> >> >> @@ -227,7 +224,7 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
> >> >>   		add_cdb_len =
> >> >>   			((unsigned int) atio->u.isp24.fcp_cmnd.add_cdb_len) * 4;
> >> >> 
> >> >> -	u = kzalloc(sizeof(*u) + add_cdb_len, GFP_ATOMIC);
> >> >> +	u = kzalloc_flex(*u, extra_cdb, add_cdb_len, GFP_ATOMIC);
> >> >>   	if (u == NULL)
> >> >>  		goto out_term;
> >> 
> >> While this does make the current implementation more correct by having
> >> the correct length, I'm worried that it just ends up establishing
> >> the complexity more in the sense that extra_cdb extends both into
> >> the padding and beyond qla_tgt_sess_op.
> >> 
> >> If the driver is still actively maintained, it would be nice to
> >> reduce the complexity instead, in one of two ways:
> >> 
> >> a) make atio_from_isp naturally aligned by dropping the bogus
> >>    __packed attribute, 
> >
> > I don't think I follow. "Natural" alignment would be at integer multiples 
> > of the struct size, right? Moreover, the correct alignment for a hardware 
> > struct is a question for the hardware vendor, isn't it?
> 
> I should have been clearer here, I meant having it aligned to the 
> highest alignment of any of its members, in this case alignof(u64), 
> which would avoid both the warning and the slow byte-at-a-time access.
> 
> >>    so it is actually at the end of qla_tgt_sess_op
> >>    as the driver was written to expect. 
> >
> > FWIW, I think __packed on a hardware struct is at least as desirable as 
> > portable drivers are.
> 
> I can certainly see an argument for marking the inner structures 
> "__packed __aligned(8)" or similar, to ensure that the members are 
> tightly packed but can still be accessed worth multi-byte load/store 
> instructures.
> 
> The way the __packed it written on the outer struct, it only causes 
> problems but does not actually enforce packing of the inner struct.
> 

Perhaps there is a way to alter the struct layouts in a portable way (so 
as to avoid the build failure) but it's simply not worth it.

There is no actual bug here, that affects actual users, to justify the 
churn, or the complexity, or the regression testing effort, or the 
fruitless discussion to-date.

If there was a maintainer who cared about this issue, perhaps that would 
put a different light on it. Maybe.

As I pointed out in March, there is already a comment in the driver to 
make the bogus BUILD_BUG_ON() effectively redundant. So, at some point in 
the future, when I can get interested again, I will re-send the same 
untested yet risk-free patch that I sent back in March, to remove it.

