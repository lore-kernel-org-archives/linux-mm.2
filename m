Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E22CD339BC
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 14:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1658F6B0006; Sat,  6 Dec 2025 09:52:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116A16B0007; Sat,  6 Dec 2025 09:52:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02BDC6B0008; Sat,  6 Dec 2025 09:52:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E56456B0006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 09:52:33 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 937CE13B37A
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 14:52:33 +0000 (UTC)
X-FDA: 84189337386.30.B2FDF3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E46CD16000E
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 14:52:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ikIe1NO4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765032752; a=rsa-sha256;
	cv=none;
	b=qD+8brEcdI05+yh+SoUoeuVcim3+5T4OZn2v0A9zz6XmZjEJyLf3GdnBgtapsTA5Xat9rG
	oFK1Udnx7jJ2s6pW9BBimcmloHj5Rx9no32rgMZh04da2q8MWrYhyQL6ZIazTvEcRZC2dj
	N8QB0bh25bRH8q4hZq/S/dPNZ48VHfs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ikIe1NO4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765032752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZqwMvBtUJWPrmT91INyPoIBLUBdh0zP7NqgxLQJ2wg=;
	b=46wbVqxSzxouUTHlcZ484P/fg3roktW3+FJopza18TcLG/oG8uWFLM0edz2joZBZCnYO3V
	bZpNk6azRaL0bjES2GEhXwViapC0R2W4GMY8rSfeBhcUiPCIoWsry6+RR2n2B2UUAfCNsc
	03dI/Wz83LscP94jUeu43oaaGllU058=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCCFF402CE;
	Sat,  6 Dec 2025 14:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74272C4CEF5;
	Sat,  6 Dec 2025 14:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765032750;
	bh=SEbZ80lBXdpClEDzmIi3Wv7dns58zlOZQfMpHJXSaIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikIe1NO4LSyNCV9jlh6K6+5Bb52VPYIF59Bem8EGre2R5FRW+JBRHmh73sdQ7V7l2
	 PME8Yzj3RduaGzq8CQThFLdmL5D3Id/Zuus6/W6B1zA7KHTeSFp+II93/LadudMZvW
	 NU+hkmuoJXMYgmXHA5NTW0BUajtZXwdZ12xzx0k/aYb7f3f7LNSBEHmoq8Es39NylF
	 2K70Q6idaIL/A0tP0iVK/dzkOj7YVYmqFWAYItsP+JteyBpKYsZgmnDQZEEW8P0/ND
	 fpI2uYrpRvIKpVlUU8UCR4FJMpWLATfS2wl9JEZpz/Q6qgId7Qnwr+vPPDl0fJv6c6
	 vTpcrMLlPpxLA==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	JaeJoon Jung <rgbi3307@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH v3] mm/damon/stat: deduplicate intervals_goal setup in damon_stat_build_ctx()
Date: Sat,  6 Dec 2025 06:52:21 -0800
Message-ID: <20251206145222.6302-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <924cfaa0-ad83-4d68-a6da-c1e8537b3232@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E46CD16000E
X-Stat-Signature: e51wzuqc6hx5drynq1478ndxww6gf3uy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765032751-730108
X-HE-Meta: U2FsdGVkX19jH3rehZOpHvmQFWEo8NIbvIPAu0g2t4GLLx/WQ2641xvEitehGtJlm86pap9Kmq1ILiGGi2KRx/Jz+tjZA1prSF6SGAsDIIjjNCT2R+T1Vp5cnxxWjI4WHia+k99GFD92+rS9vox/WhZMxT3bMGLze/qx2iRFPBhG7NUAFVv60vyH6/T7ESAW6fEoey9DVByF2OLp8Fmo8Pb+T885SOanJ2DPqwMIMIMPDRYPQjklTGLJgnahelM/YAblZxBDj684yRF4aToQ/7wTS/HVesg+bArCO3SrJMeWi2boL4cyOQK+RLOg5wSvkdx0J5lYs6bLvRj7B5w+Yq1Q7n1kkDdFW33pUATba22E6Be/O4Cy5fiQRpapw3OAt7fu1gYhW5w1EdFAk0rtEs5YzetTRPjCPEyVWARMk2sHqf/BnNDE8qAlKAzTAe+YCDeps9qIoDJXYF76rqhVGXO7RP1EX9aozX+H5GrTu4XU7SwzM6Jo1iDtdq55YjZWVAl91RX+3aikPLo1PmZbM0HpdszMlwYG70XBIHE4akjTRqUsr+dwnAIY9gNr3StDbpb7Fax/Cn98sPCgZKP7vHpwOGve8pyWVjYJi6UBKbGeulgfI8RD6gTgGlA22nCAE0wa9cDRYW7mEaAtGPm3dlX6YpIWYQdDJ+2mUdEij5bQnrfN8TtFcoefCf0QrCKdKhozNs53+VwwYXApC0ZgtKpyUENTRth31aZkF9FmhhbZzMIkiab91vP7MoTWeI8rb1uFxQCB/xF+W36WOPPztGPUmfK1kkDpxzSzs4BERTZOxeS0ToefKDyS+CNTy+lOmaOTUDvjvX2K4Qbkr+bi1cKDHximj03o/3leZXCCNW4G+fHYipETUA5ZblTnxH/SxT17KJjQYKJKBLgr3VRuc63lthPXFncOuNlp/t4edgqNI3tr5w3PVHpBugyKi1TO1RZ23E0j6A+drJBC7qw
 ZIDHRy2V
 4aG3WLEfwWxJl0sXJqfH1ZwLAFF//D1rk+gKYq2adzO7ywqA5N5FxAnwUdcIgh9Z9ShJmoLeBJOuaICccd+O4n3G4Mss7F5SwtNAOer0LF4kzZp8S/mxc3QXZumZBodoIe/DVpn/bT0BODwHfuhYw0F1IXyRGbQlico2LdMHt4Pif35kAfikr6dVqyjbM4nyD27fWy+Z1Xq/zeB6bGsZJQjJE156JTVvPFCMDPAY3M2EjwyYG2TvGkf/X6jWegcpEygMd3hPfJfR18UnygNu1l3HQ3NCuE38YyVgUGW+Eu5uG6SG54IIJr1S78V0S2GnrX+vd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 6 Dec 2025 15:58:45 +0800 Enze Li <lienze@kylinos.cn> wrote:

> On 2025/12/6 12:17, JaeJoon Jung wrote:
> > On Sat, 6 Dec 2025 at 10:50, SeongJae Park <sj@kernel.org> wrote:
> >>
> >> On Sat,  6 Dec 2025 10:17:13 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >>
> >>> The damon_stat_build_ctx() function sets the values of intervals_goal
> >>> structure members.  These values are applied to damon_ctx in
> >>> damon_set_attrs().  However, It is resetting the values that were already
> >>> applied previously to the same values.  I suggest removing this code as it
> >>> constitutes duplicate execution.
> >>>
> >>> Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
> >>> Reviewed-by: Enze Li <lienze@kylinos.cn>
> >>
> >> I show Enze did suggest changes [1] to v2 of this patch.  But I don't show Enze
> >> gave Reviewed-by: tag to the patch.  Am I missing something?
> > 
> > I added "Reviewed-by: Enze".
> > It is just minor commit message format suggestion.
> > Am I putting too much emphasis on this?

Reviewed-by: tags are kind of approval.  Those should be offered by the
reviewer.  Please refert to the doc [1] for more details.

[1] https://origin.kernel.org/doc/html/latest/process/submitting-patches.html#using-reported-by-tested-by-reviewed-by-suggested-by-and-fixes

> > Should I delete "Reviewed-by: Enze"?

Because Enze offered the tag below, no change is needed.

> 
> I have carefully reviewed both the commit message and the code changes
> in the patch, it looks good to me.
> 
> Feel free to add,
> 
> Reviewed-by: Enze Li <lienze@kylinos.cn>

Thank you for your review, Enze.


Thanks,
SJ

[...]

