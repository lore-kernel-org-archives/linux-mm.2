Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B8DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A14786B008C; Wed,  8 Jul 2026 09:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99D036B0092; Wed,  8 Jul 2026 09:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865086B0093; Wed,  8 Jul 2026 09:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56A846B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:36:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D894E1C0D73
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:36:23 +0000 (UTC)
X-FDA: 84965708646.06.10EDCEA
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id EC82B18000C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:36:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bwnCS62h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783517781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyj4hWA1vtXNSml0ZMlyH4/ogXNrmE8njxVw7g3pFsU=;
	b=8WOEflvLdOAgC1LQH05ehUn9WlNb9or8AKFbSx8LxnNqJAAH98LrdrnQm54YHYuDsmdxwe
	DK016XjuxOYEHRPEUxKjqNf75qoSyGRWJjdohOoLz8GbYJlSFE2JhunGbHpuy18U5AQkCm
	kMoasIU7DAQ6DMwcztlYK+LKUSEn5mY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bwnCS62h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783517781;
	b=osZjJ0hjXR5pw3l2aRkGN+pmI19W5TcdxE1sYCdHimzjEIhgaGp1grmn0RAvOdv9J1NLhk
	oGEtWbaXD4JKex37extAjJoqUC/sL8MmGnw5TTC/4gwNtuDz2eG7wh6VikP1n3lCcklIAg
	2MH4NHMwpbDrW8b6MnxqqhOlGxDV2u0=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cc6dd436c6so7149125ad.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 06:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783517781; x=1784122581; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gyj4hWA1vtXNSml0ZMlyH4/ogXNrmE8njxVw7g3pFsU=;
        b=bwnCS62hWokwwYZ53GA+m5sJVagBKV450LcHNnSmODjN4nvNI3iVbI+4O89ATP/2gY
         uAAdwvJ+fDlkypLLLeV3HDjKAV2wAXaxkON61Ygt+9EYsu1hDgVAxINPzJjFVmOqC1oi
         PYJLOSBt9yYbU0qhlGdjUBUUW6s/U2XMwUPeP+E1UtdBK+L8RUfl5BazSdZTfP8E//HA
         wQ/wH4TcFvu9q2zCDGjLt6FGajDcBr11brIhqlWw3woWK7miYoFPiKJW11w0r0tY++RQ
         z7PBnPnkZmlAlJf9QJ3h25U6ejVbssrjfyw2str11aAZZP65Unb3mi3mHtKKZCLaIftX
         zfsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783517781; x=1784122581;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gyj4hWA1vtXNSml0ZMlyH4/ogXNrmE8njxVw7g3pFsU=;
        b=G8khMKW4TpIl6e1o1Xkv/eNVoncf3OoW//AinSF7Px096vT+u8QjkktXcROlOaDTVF
         YAIUWIQnE+ePcvNwmT1yhmCJb0YNGIoiGLZ3NfGfGy+aU0rVe2HGNm+rN98Q+kfFif0p
         qTVoHfyUuBaW4v2z3UfiONIQNkTivHd7VGoA/cF/bPxw4pbsdkc2RaDOUF27zY1Usb+g
         9uLKkWsnlkdVoC09wxfpXhpFBKXpZCndH21XTnGBegWf0D1nzb7oKzwQ31raLQBErpY4
         r0hTBVP2sLta5otnJiRIu+5nyQip6nKFG+PU3puYUJj7jusmGcos3KTTiG/uawu4P/mi
         5Kyw==
X-Forwarded-Encrypted: i=1; AHgh+RoZ72cXVPTbAZG1R8I5GuJkss9TSzYw07VdPb2JNZmXtkjQ+flleq9DggxKZ2UD1hnSFceEzlXU3w==@kvack.org
X-Gm-Message-State: AOJu0Yz72i/NBNaS5XYYexAyTYMWgD71rbBGbU3OhbqjNihBPObtD4NL
	rQlBJ9RaLJWVvZzOQyIzitbcpLobUvVCADVCC3ZrqxtkgjKkywr/SZw9
X-Gm-Gg: AfdE7cmk2r+XW+r+Mj6GS9Z4INk7PKu6sY46jZJMHSRNN6X7M8/p1tUTFAlKlxgNu4+
	RdMRn973g6hTZFFPDYYtieFQLbbo6RPVnsNJ+dRyeb30BZDJzTY0x3O2mCoBjgAkLlQ3cWxjnz4
	TrnuZfwY1BGzdCBB45U1Vca/gKNgJjZxms5W7+dOaoN1MXjUvPQA3oARr1YJPiiUEoAVWgDz5J3
	WLKOmrxSq1WUBNJBgz2UV548k1Co5YzBC03BFktEKD4Y7re2kJLZ8l7vnSgX4e9cldT5lz1m1WG
	L9vPC4QWbN24/bW21mRTJi3VDDjR2pa4rx2bImrs7kiWIPr0gijcXRtERaq5OvgTuEYTT3UcRKJ
	GsN+woeiJ7rzJMU89x+QY7kLa/c/QF6taycHIH/gVPOMYeSGBIMYifyyOF9z4fgNUnhZB0ilePe
	PLoTAkvtgMBiEAizcHSD92jpQlmSGjHkatzZiSq+o5l2ic8WkJ1BD1jF09ItuDEQbCQN2s7LL26
	VzC4q9iQqLPk+BrkBANrDx8jcu2uaNA4kMSOsqe0IaY
X-Received: by 2002:a17:903:38c4:b0:2ca:cde5:29c4 with SMTP id d9443c01a7336-2ccea587847mr23958075ad.47.1783517780714;
        Wed, 08 Jul 2026 06:36:20 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d5c804sm28186045ad.82.2026.07.08.06.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 06:36:20 -0700 (PDT)
Date: Wed, 08 Jul 2026 22:36:17 +0900
Message-ID: <m2h5m9txgu.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: geert@linux-m68k.org,
	akpm@linux-foundation.org,
	willy@infradead.org,
	liam@infradead.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	gerg@uclinux.org
Subject: Re: [PATCH] mm: nommu: point to the write iterator upon split_vma
In-Reply-To: <ak1PTRH3Ee7XyMAF@lucifer>
References: <20260702012546.665383-1-thehajime@gmail.com>
	<20260705152708.582fd8d87561f600da23c0a7@linux-foundation.org>
	<aksn5J8Nr0JIsVpQ@casper.infradead.org>
	<20260705222343.5d5c78cbb54839c5efcaabf5@linux-foundation.org>
	<CAMuHMdU36O2UqfQkbbgOVSH5KFU-MZ_WO3jRsLumkUu22iC7vQ@mail.gmail.com>
	<akuS-6zegY2XBa3f@lucifer>
	<m2o6gktgvk.wl-thehajime@gmail.com>
	<ak1PTRH3Ee7XyMAF@lucifer>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EC82B18000C
X-Stat-Signature: izr1tr4d7ynz73fk4wraxn6jburr96yk
X-HE-Tag: 1783517781-385037
X-HE-Meta: U2FsdGVkX19Be+sdEtiip3+WxtgVVDWq+Zxbktl3RYeLLB1GgeoO6IC5UvkXvWEAlPtSFwixzYzbqSaO8VkiOS948QFhye/gQVIeUzc230uwBF79DCnXoyLyAYCfpklvXJuo+qKMfLR5J05I+g0/qeSSSqTenCGYvmfJIiuXpekG5NDVgDosu02xKkAznv6iyh9ywfAxnQYYTg5i6k/3s8fz7kTX/PSJ0awfbqTenphjM2zWA2tR7gAyH4eSU/7SWQoJr60IfHce/1QIkBv/IWqsrMccAM8Pu2qcFS7dc5S7PfhjQedzEM6p3D5N+W9jDAkKtlMT9qil7MXDy4qxAgeLd9k06hzgUsKBRNd4v8gmNVom2m7VWNSlkzf7K/YfsQ92trvjR3/qKPw4NZ0PGYGYGVNvzPl4BD6db8bk2PcKVgt4mJ0I43BE5Ylt2tapoVOKeCb3F+M070cEnlAerjHIORRBnFhvBLUmtGDoM37YRc1J7wVcXvlZjLByHYU8i1s9Dd88hJQ/HLNsdJ27E3Z3s93RGrL6wh2aMwBZ60BHEYDHwLHdT8eSAA5pyDUE6fC6qSqesa0nj/yo6gkKYmTMTst3Ef87AUV88hPX+MbULVofHO9jLqEzwcFxnkw1xhFealy7KLjCdnj5RpKndYpvqW+s5V8W82Jw2svrW+YgTzhia1jmxEkAJ4L2c7MlZmM40Q7ulYg9tnNXYveGkLET+pbiHCSxpGuJkdGPlP9KTekBgkiPRdda4p1EetsjBcSAj+IuimLF1H7W3IlTRfRrQIUL3pUDAG4QSMwuLIwpFu3KLm6XecSYvMZgqk0QQkX/38jELQgSvRRINYaFSuLOB/er9QkTAodCU1j3rytehS2FrgJBkc7Q8Vf5Va2d/rLAOv1vdmbk0VrBnDi/3TalXu+/hg0ClPGDhAxRq0BuN/jNNl+V7AdHEwDSzdMme0oyb2ut/jdbm9Ug3A+
 9gGRfiM7
 UckSFpBVo+SPxlr7HJUNFjcPTTTVs8O6fu10mDVl4c2R7bdbr4YEgphpeff1krNOK8rk8BZ9twXIhzKdlmJMoyhhWujc681slZCecbCzpw1586s9yH5Ig42xHPqKA9gCaowrbWBasneDYg9zoAV40Cf2BcyDlskvN+KOCtpbzKOT3i+GsV1oc64bFYbME6rq2NwgVA5UmrVD6KMBexLgMSvuzQAWMBoVgSeoyFaZM+ZaDEp2cu+AwmVX99t8JARuSpf1mmW0f1FPuO79vITqKuSuXo0JiVzgig2IOuIHnF6eeDXXwSlUTt9n3ugjBQAuwj/akur8tfalxqVsu/ODu5vYQ1Tv1sVmdC7cKdU/B774F5EsFwm2IVBCEbCW9xDkUx6BECUh0basGB7e8rOIBxQALAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello Lorenzo,

On Wed, 08 Jul 2026 04:15:53 +0900,
Lorenzo Stoakes wrote:

> > as nommu started for embedded devices which are not easy to test, I
> > agree that it is also not easy (in my opinion) to maintain.
> 
> Indeed.
> 
> >
> > indeed, buildroot images for nommu targets (with qemu) are available,
> > but running/testing each of commit to the kernel tree give me more
> > than 1 hour to rebuild the images (including userspace build with long
> > flat binary conversion, etc) (which I'm playing under github actions
> > with riscv-nommu).
> 
> I've struggled to even get the buildroot images to work in any way. Right now I
> don't have a clear nommu test setup other than building nommu_virt_defconfig for
> riscv.
> 
> >
> > # yes, should use ccache :)
> 
> :))
> 
> >
> > one of the goal which I am with nommu UML (*1) is to provide an
> > environment which can be tested in a simple way; runs on x86
> > machines.  An extension to UML means that you can also use KUnit
> > infrastructure.
> 
> Yeah.
> 
> Well indeed my raising the 'please let us pull this out' was initially a push
> back on that, because if we were going to pull it then that work would work
> against it, but then it became clear that that dream wasn't possible.
> 
> And that makes your work on that REALLY REALLY USEFUL :) so do cc me and ping me
> on any respin and I'll try to find time to help.

thanks, will cc from next spin.

> >
> > LTP (Linux Test Project) dropped the nommu tests 2 years ago (*2)
> > (which is pity), but the reason is similar: no maintainers appeared
> > when the project asked.
> 
> Yeah and it's just the same thing overall with all of this.
> 
> The companies who are apparently dependent on this need to _actually pay people
> to do some even rudimentary testing_.
> 
> nommu.c is co-maintained by me and Liam simply because we have done more to fix
> issues with it than nearly anybody else recently. It's just a burden that we
> took on.
> 
> I'd far rather see an invested mm person take over if we do indeed have to live
> with it :)
> 
> I also wonder if we couldn't find a way to implement it in a more maintainable
> way, perhaps as a 'virtual' mmu system somehow?
> 
> I simply don't have the bandwidth for that myself, unfortunately.

If you meant that 'a way to implement it in a more maintainable' is
about the code structure, the current nommu.c is reasonably
abstracted, which contributes a bit to reduce the maintenance burden.

I thought that what missing is a resource of tests and eyes to look at
those test results.

I agree that the tests should be done by the people who are using the
code.  Moreover (and ideally), the code should be maintained by the
people who're using.
I think I can help at least the former part.  For the latter part, I
wish to help as well but I'm still a very immature developer of mm
subsystem (who struggled with addressing Sashiko reviews...).

> > I wish to be here to improve this situation, both mm/nommu subsystem
> > and LTP, as well as any !CONFIG_MMU code in kernel tree.  This patch
> > is actually discovered during LTP (re-)integration with nommu kernel,
> > which I'm going to propose to LTP.
> 
> Your work is appreciated and welcome, thank you! :)
> 
> >
> > I hope this helps a bit.
> 
> You're definitely helping here and again, much appreciated!

m(_ _)m

-- Hajime

