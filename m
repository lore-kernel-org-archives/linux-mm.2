Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 232A9CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158EA6B0005; Thu, 28 May 2026 03:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E28C6B0088; Thu, 28 May 2026 03:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A436B008A; Thu, 28 May 2026 03:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0F396B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:39:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81CBA1C0672
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:39:46 +0000 (UTC)
X-FDA: 84816029172.24.ADCA4F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id AAC12A0002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:39:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cr/+nxYs";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779953984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vf47YQ4QByV26FFRr586MdcaVOlWW/RnpdwboFherXg=;
	b=FBpBK6bBydN2mymHu7I7C/gAxIOpKucm8P+L8Bs80wbEOSUNimI0wl4j7g11bQCLuvemX/
	XxBHC56lJoyPo1TZSEJkg41D8h8DfZLucuRaubW7iQRMwYj7eDijjJPq8eSCpgVf6QUUmX
	+qZnHzIyPxcgc/44WxFYTqC4WZpv37M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cr/+nxYs";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779953984; a=rsa-sha256;
	cv=none;
	b=UAMEZVC7E5UYPueW7eufDM+F97Z5WkSoEET7Dt0oZg1Hro4b6uh4oez6YfqHlSlJskYtf6
	TUkbzk2TM4NiQpPMJXtLEcvr8I3kouKiv529PMmbS2PGQW2HVIsJs3LBhZEHpe7ijaOaS+
	d/n1weW2uK38FNPb6lglgRnQvs1PklM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43FAA605D7
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03D71F00A3C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779953984;
	bh=Vf47YQ4QByV26FFRr586MdcaVOlWW/RnpdwboFherXg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cr/+nxYszNXAqAEWdBtya9WVPXXYWQywtTHzZoUErc06Y2JzkuCnXorEcSio7GPyh
	 p6RfxcL+GvB72JDCXi5vaYTJpICFDbsYNXps0+nGPFxuHdtLb6IUZiWzPbhPq3ev+R
	 m9GNoAvVxYAdNhlbJWwMgXBUE5SxTwGxslfrBd5PtsQLzoN4e7C4Z7mS71SDmvwq1S
	 0jXCOaxYmYaOcxLoyl5chN477fHj66VDnDaceoVJBJ2W/7uCv921qTkP0DANVvzt4n
	 cM06SaeckqMWEfuPDzEybIpJVg1J4sR1T62WWs6flMtmMAl9ocnkMg6rNZZUXzDw9K
	 u3FZddpACOIFA==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7dc6fbf3e86so6019357b3.3
        for <linux-mm@kvack.org>; Thu, 28 May 2026 00:39:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/WRGPaP1fEeAMovbpvV3YKhCli0Jl4VPiiixxI0xs7hEWVSMoxVjB/tG1gXzPP1R21eLjKO7np0A==@kvack.org
X-Gm-Message-State: AOJu0YyN7wSrGF0+ce7vxRDD3gSCC0gNM2Bhfp4YbcZ3LaN/oBbk/cOg
	/jgmFQZKkCOLk7zLX1yqJFLEK6iQgOVouA6TcksTTzAAmHp2F6Cc1ZLksGoI1H+f0M98ksdO6Hi
	hC6O1TGJ1xsJ72xSt0E74akDpt3irFtk6hBoKAWxq4g==
X-Received: by 2002:a05:690e:251a:20b0:654:27b0:8881 with SMTP id
 956f58d0204a3-65ec961a176mr19845251d50.3.1779953983328; Thu, 28 May 2026
 00:39:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260515120019.4015143-1-hch@lst.de> <CACePvbVvhJ7Kz2wtUUu+PoNweOsq5XABSMqKrabX6FTdK2fpuA@mail.gmail.com>
 <20260528071634.GA1184@lst.de>
In-Reply-To: <20260528071634.GA1184@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 28 May 2026 00:39:32 -0700
X-Gmail-Original-Message-ID: <CACePvbW4D=EoZ3ZK6w+-WAZh4fUdX9btb=CL2jDOSYcghS-YZg@mail.gmail.com>
X-Gm-Features: AVHnY4K9-qjQQR1vlrQVzNol7kOjRHosNDlPrg9vLRKIWHh5Gv9DAYLtQfRm0Zk
Message-ID: <CACePvbW4D=EoZ3ZK6w+-WAZh4fUdX9btb=CL2jDOSYcghS-YZg@mail.gmail.com>
Subject: Re: RFC: better block swap batching and a different take on swap_ops
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, usama.arif@linux.dev, 
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: miconxgh3ihnccfwkkyhpcdz3qpp9889
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AAC12A0002
X-Rspam-User: 
X-HE-Tag: 1779953984-546367
X-HE-Meta: U2FsdGVkX18L73sxuubOw8JrreJlL3lEp4XuEttNX1+LIdUNrTF1i91MP+QhdHuJTQStF0kYPGBjsXr11sVcR1I6aNxCtzyfRS+QvMbGS42QvdaX35vzl/gdfPJBOdlx4reNnRWPUZguM7S0NzGzrvq/Zd85Mf+ovPigIyBu386foo49IlPRqTXkqfmu8IuSVXThCqbgLfVc/LwIMsSNyluYZtF1EwkX4wn4FSXOHxTDGnl9kDTH3j9j8VlD/u61d0fv/CCO3mX82v4tbxB2oJXO/9O6FIB/HK+lHhxVLRiU/UEE5YDtbQLZ3GbBDbcRZ+QIFVG+kls3H2g/APbp+9R6tK4CGKhNBvgxsHCClCLCGzO+6SEwEMl3ytMIsr6NwiRlkMSH8nppzWSaMkUGTYgdFn25MDsyGLVR0Afi0lw21mIuPgYPnTBWAYAnfPFUoN5HnVqa5hDAzd2RGicnpsIDf1qQWn3LkWyRAT/I8nYIvwGGCRtwR2y1Xjv39ZnLs09nDm4VgRklycDK4VqOF0q+BRgWv/j+70Cyu7uA0pGbE+Yon8+Hvnp7xLyEt56f4KlC7e9t4GaI8jw8BlXYs06D5VYSwPOBYPmrt/NbZPhHFMwyV1e+ojps25v9AwVni0rwGl2h1aN0dQv/14jnt7qnLgMSCUw2GP0J3Sox8W/64BZtOSrybCd9xr4CkwNJN7NNJiirhk2CCOm/lxHAHUFdrTr20a1atFcHWebhbT9+CjEdd0rboMdNGU0sfRc4g9gxBUK3ZKO7h57W3ln53/R/BNwVojmPbCH2XgbQeFldIL9D5W4xJQCPsZ8xlbuDn7fHk4Ru/K/7+KLmqkZBDwlgKzdiDOcws+lgyf0lhYq+1w05t7N5EeZ67ydaT72DaJ6oroh+tr922rluFtblp/PUEMjWL/R0QZTfUiDO0UUGYUY2DAotvf5f0Lok2mkuD0CKpCEJYI1bCYcdXBI
 SvmRvTv8
 uPeA0oaKe6fNfWMKJYT/hxxCoiTyzfpqB634ASYxZkjCaaSeXZmyXpvQqmQ1DUGlXIujy+JJYcMhMtGKknbNG7A0vvthKZhwy6k306lWMnhIVGWBmxFfGLiuYY96NTg/CGARLFtf8FmvU/4VIOIoNQwc6PSt8UxAnTJ1TDsuVMupPKzsIEaytTAogn+zOnOXD2Ut0Vho+gckdgJG48UnkcnkQQsMp6wUXLmMr7ufjDprNoavob28d0DcIq/3b8OGe4x7fBN2uGAxBa5UBoJC73to3ZHEADn48u5nfBvjhSDH+huIIckRvsqlXLg6sOTQLP8jhJ6mfF5lbsKVI3dTBMu/yh+Tig5L93jcEbVLUQqiTbwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 12:16=E2=80=AFAM Christoph Hellwig <hch@lst.de> wro=
te:
>
> On Thu, May 28, 2026 at 12:10:48AM -0700, Chris Li wrote:
> > I like the direction of this patch series. I suggest you send it out
> > as formal patches without the RFC.
>
> I've been planning to do that for two days, but I'm still waiting

Glad to hear.

> for the buildbot result as the buildbot seems to have some delays.
>
> > One observation is that, this patch series aims at situations where
> > block io merging would be beneficial. This makes sense for the
> > physical block device. However for the memory compression based swap
> > interface, block IO merging might not offer additional benefits. What
> > do you think about a combination approach that allows the swap back
> > end to select whether to use bio merging for swap or not? The end
> > result is that file system swap will use your swap_ops flavor. The
> > zram and other memory-based swap backends use an API that behaves more
> > like Baoquan's original swap_ops series.
>
> There are two approaches how we could do that:  make the can_merge
> callback more high-level to avoid merging, or offer additional hooks.

Yes. Both are possible. I would need to see the code to get a better
sense of which approach is better.

>
> > We can merge your bio merging swap_ops series first and then design
> > how to allow swap backends to optionally bypass the bio merging as a
> > follow up step.
>
> Yes, I'd rather do that when we have a consumer.  My impression so far
> was that the main support way to do compression was zswap which sits

We also have zram which runs on every Android phone. Its usage case is
as important as zswap. Eventually I would like to unify the two, but
that is very far down the road. One step at a time. In the short term
I want to clean up the zram swap calling path.

> above this, and we would not optimize for low-level compression.  If
> we have to do that for some reason we can do reasonable optimizations
> for it.

Sounds good.

Chris

