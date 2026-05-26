Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04B6ECD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59DDB6B00DF; Tue, 26 May 2026 09:42:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C40D6B00E2; Tue, 26 May 2026 09:42:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D2E6B00E3; Tue, 26 May 2026 09:42:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13EE46B00DF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:42:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D52361C02ED
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:20 +0000 (UTC)
X-FDA: 84809685240.30.CC7896A
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf27.hostedemail.com (Postfix) with ESMTP id DFA204000B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y IQmmr1";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=R3GHLvlf;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779802938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OsLKk5eRpVociv1P2fTeir82WaP3/zQBawR3LPNnDkI=;
	b=GdMEQBF+Ou5Fw0fAAXDi0ovhrHJGyCoKyK9miEb9k7j9PD1CByVmRr8s4/ppxBNdajam7C
	22qNoPUsHP+XuDaJGO340IkBkddG1NPXU9rTkbiODYNctiz6fM2gzBnaH0aJ+RUCwWs1Ay
	qFYLmAMN09tNOqnGk8rysDHitywxQqk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y IQmmr1";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=R3GHLvlf;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779802938; a=rsa-sha256;
	cv=none;
	b=ACsZrn7sRMWsO7GiRMNFDW9UH1lHVyc8WFDar7SSpNphuJ0MunrlNUxaI9fMyVVt49ILIo
	oYZHAVoBTrIiOfhOzE6lJNBDyWCZ/ODdDFB01aqbZq/iirxwCQaM1vQnxSJmuPB6zPA+dW
	QDBAoGYRSVHIvdF/TmPn59cxtI5Ebw8=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id F1AD17A019A;
	Tue, 26 May 2026 09:42:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Tue, 26 May 2026 09:42:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779802937; x=
	1779889337; bh=OsLKk5eRpVociv1P2fTeir82WaP3/zQBawR3LPNnDkI=; b=Y
	IQmmr13Hi9/pjqmknecTwQJKj59QkHj7t1OoXmaUnalQfeTRBIgkNjWKBoadt0ze
	/R12tJimcQ9xtGcwfzmM40FD1Sxx5YRBtUlUcJKHLZGqIBFn0SC7G6UJyZ2fzTwJ
	dSZRFCXwndTwGZ0ilpMAJU5ElWPTD8FVL9ulvesMniLLYv2OF3qPNz9MnEIXWBk3
	AZBm0+p/cFPmv/qF4/vvLEupbQqP9WV5aKH7m5bGdp4GFEbS5u5XDdyhffD3chgY
	rQ+OBF9F7KxAEwcZ3qbYD/cCZgW/YHI5vbJ+n4i0n7919T0wEDrhlFZ1WnTjkTLV
	hltPNAkYNJDOHcXaR4ReQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779802937; x=1779889337; bh=O
	sLKk5eRpVociv1P2fTeir82WaP3/zQBawR3LPNnDkI=; b=R3GHLvlflq76XMCTh
	q0LXzq0OmDWbi2Rpy9GzljygXcEXa/XveQN3cw4i1py+1ana2AsjvdLuRdm4ZV81
	uqGQlj8WNr2iPMirZ7pBn6VWDDNdAH1h4riN1oZhC/yyFm48HRO6Sp+0gD/c0/S1
	ZkybZNVhbGIJovAXY5OThQYt7m3EicjJ3ju3dfN6MPBp81+B/TYpiHwp4mZGhBJX
	sRjdrRVRsv990tFXwi3T706InN3+FyRwGIYWBS0kC973Kwnl56lZv5FVC52yxtUw
	KFKOO5mgFHJdhe1B4J5fUoYgFlrhFILU4LhWvU4TMnMIMRgIny+BHZLL1XEbExcD
	RNuIg==
X-ME-Sender: <xms:OaMValgE4_Ps9oSFciMh3YJh-cVRRJIVhDgiZMt5xclGa_uiH2WvGw>
    <xme:OaMVamnQe5aCIx6iiBjAYqJDk113Cg74IdM5wmP-y66VIytkkpRNU521p8nvhxLf0
    H9Fc1tOvG-Y8RVHbT6EtcVLR9AHCD7Ooyy30s6RHZ9DiydfRUmJrco>
X-ME-Received: <xmr:OaMVaphLaPIm1nlqOcSP6Zo6-dvSMvI6S1QPBMVcVCNNA6LOrNuJuBJQsd7pWQ>
X-ME-Proxy-Cause: dmFkZTFebpdVMuqqHqVmfQKbOAMdw1OrzoDFkw5F0KVVLQLdoATDDnETM3ABKU3fZFbAhq
    ivOhGd3F/GKCWFsC7lb7jcb0TzZ20tAuRRzd8pH4seIyyjwZAbFlVBqhpwenTXNiZciUKq
    AZ3ulPZCjI4GxskBu4nz/NuCT5ViOZjnnSKr/tYs/pWVzmL7Aev6dKAksR9KQEKxM/++4t
    MQ+8SDodptaskec3qEvFLnIaT2T6Qk4vA6SzpmOWsrh0KQNy/pTpXcQxOR39FDTmPN6QI5
    NqOCLpoU4Hzex+wBXhNOecuxefna5LLr/C9ZF4FT25jcytpvdxwmSYAleisYq0gnvSm8jC
    aoMggufi4UvnBhKquplPRidR9TDBQ+LXMYzHQ7GqVh5XhlWxynUaOhrXQcydURspnuosn3
    G3b3xIZEkZ6nX/ERgwj7pIShyLLLIRGokTBbKiRQhObndwvLB0/OMeljz8nmC6ziXN5OSG
    LD+OjpVO3l4ChsMIors5Elzuw6hQamb0imrgPaZqZfqGlARcln4gWQLEPV3G00p5dhFG8p
    ZSiSRSEG1V1fGL00w4rp7xu9Eybz2DKtQvs925kM8elugplDlfCr/EP5KSVOWQVw7gIrMY
    bOgYIr9XSyq5HXKDxHLnjCPHMzZDGBEAadHOwYNAHoMtOAh4GZQ9aHLtFW+A
X-ME-Proxy: <xmx:OaMVahHB55r8vDvsvFbAj_XeakDetu8PjO8ziM4igqIvEWCDkgFZxA>
    <xmx:OaMVajtS7EHrcToNhmTeNt2zs2LmMsE8PN5pO-fM1Lnf_JnJGXsGZg>
    <xmx:OaMVaqd85jRrFbpKP4v6Unbn7xHQ_XQXjNZ7Lp8Xa51WzNe4CPbHuA>
    <xmx:OaMVahmG1emroFfprchsNxJ1BqME6uXSFINY7AYSLQOrM4fcXSSXpg>
    <xmx:OaMVavM5esFq5C3V3s9BotPk8qFcAZa9jnErnCuTuS1c6bAekfWQaM4k>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:42:17 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: alx@kernel.org
Cc: linux-man@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	kernel-team@meta.com,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH v2 6/6] ioctl_userfaultfd.2: Reference UFFDIO_RWPROTECT and UFFDIO_SET_MODE
Date: Tue, 26 May 2026 14:41:49 +0100
Message-ID: <20260526134149.2831720-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526134149.2831720-1-kirill@shutemov.name>
References: <20260526134149.2831720-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ategzqayfcqhh68xbg1wmhijbwuciinf
X-Rspamd-Queue-Id: DFA204000B
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779802938-146568
X-HE-Meta: U2FsdGVkX1/v2wUggJX12bLdiFv+6qPTN9v5amGlhTu/SPrN+m9VcsOTY8/ZgMIC1oaKF0C/t/6uwm0Bf5GXZGyNnD/3/O3sWAY9CtRgk6AnFX99OHT8MmPPfHzR8ULWf3rB1Aeja067Fy0uG45NnObacQPwNBvYBVmr5FzeYWBEOibfvPVyScXC3fG18bMT6ckfilCYjjYf70jaPFm4ewTqcrAAm0fac29HhpUIYoszNxb+5jwMqVWmRKmQiDjN0WepYeHipm7UX2V7JYqav/n/5KFnmDhb3sUPFh87loZBikRxXkVpHY5wLrxrqY/NWL2PEOUSQhBWXuPdvKUvgLp+RLt4iHA04WAnmfaHyMx/gTTIrcWIy1Aouhi0W6SjsGP7YkGyTMvnMnHQ5MKq2BUNfNRK77FOFklU7ojBRQa/G2DaVBV26rOP+mG1j9VBVN53JkAbf1zbkimU5TSnsslQaMRtHWyjps/jEuc8jeO9IRa25fkEqUAM3QrM2d8Bh0qPm6R9xrtp2qJLgl3VubI7yZM6c4qPjdvCTa1yWusIM01rJjp5RCYqwI3YFWaCV5AkIffjzJQJHSwjuc28ELRm/KkvlgbO0GHY0nWbVnu+hVn6PqOiDPyMmyMK2wnEQrX2xokv2RimJNPZwkRYZe50WoWpFPov37LeOrLTj7umbozwzcdN6613YFC1LFVxzJpVC3WhUQJN7XriZvFNw5XtR5AXHFZdoo4sUZDrsJX8g0zb6TXW2OH9If5BbUPVSmV2nRjoO07dIABx/0CfbsJrzCqjNmplp+f/eYen2ls/o8Wfi96U80cDqPuvR4DSX+y03QGwY0OOpoGJLoJG8IJQnq6mxg0yHe/QtG12lVBxrTNl+jiBn78/0K4Ae+rbjmHw8gY+s7UR0l6xOMb97HsXemoJYzFQgPxgYR/BW8sQk5nA5JOVV4/RvF59EucBITjJBFST0G956Sl3Q16
 OupMdECK
 SHUvZqnWeA9PuIrFQoy7ZAcvd9tOzLDAOvXoZ9AX6vPNDvwJ+JsfBGth4sXq5N5WUk9PcGocFkJxHBTNsB17Q2VfwOYnOg+CmgkfOPW9xw2KnQ0a16kU5rFLkJtyV+CKn/wVUJ9CeLwIicuOFaawIbJpQKcurqmgWYA+Sz4L41IJVvIyoAAApCamhMDXFI2cwdq7HOxDe6ZzVrCIZ6R45ffVdc/ErbMhfu0oLDo66rXSCmO/AN9NaDkuYQ1wPHadrPciqtECMI+AviVhmNRfjtJFQEepwTFn9keLEcyQamVq4jywzNV1tunHWE/6X+uAJobMgstKwBqfur6obJjj77R7BYuxMx4EngIWwhTmFD1h525ZRCjdgbofd1dqXA9qGEBFaHDX6+eRdtGUFkmMRDGKbSbeoFOsRdZfWq7/ZHuGBOgBpQb591lMmZpYPkkoAbEp7bbf9rW+o6L/ckohF68AD57aB9L6nSE7KhYpVv14mVoWk4dZH7gX3+5kN5qHHlEQ+Dy+yqC/4V4z6jdjl80oT16ooxxGj74tIlbAau87lN5yh2g+h7xBa5XDJ7kxOzrrcTITW5k3IlnOhCl3exqHpQMhEYmHn5yY7nsS0SYIi97iBzga4AH16crHOdftqlfq7aV+LtjnAl76s3AtAgEorkMRZTS0XVOC17T3ILxpIYxo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the two new ioctls introduced in Linux 7.2 to the list of
operations supported on a userfaultfd file descriptor.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 man/man2/ioctl_userfaultfd.2 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/man/man2/ioctl_userfaultfd.2 b/man/man2/ioctl_userfaultfd.2
index 37553cd7a88f..fb57fe222979 100644
--- a/man/man2/ioctl_userfaultfd.2
+++ b/man/man2/ioctl_userfaultfd.2
@@ -76,9 +76,13 @@ .SH DESCRIPTION
 .TQ
 .BR UFFDIO_WRITEPROTECT (2const)
 .TQ
+.BR UFFDIO_RWPROTECT (2const)
+.TQ
 .BR UFFDIO_CONTINUE (2const)
 .TQ
 .BR UFFDIO_POISON (2const)
+.TQ
+.BR UFFDIO_SET_MODE (2const)
 .SH RETURN VALUE
 On success,
 0 is returned.
-- 
2.54.0


