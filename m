Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947A6606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C8D6B089F; Tue, 24 Nov 2026 18:05:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC6E6B08A1; Tue, 24 Nov 2026 18:05:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2F76B08A2; Tue, 24 Nov 2026 18:05:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8CD6B089F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:05:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18C3B160CAE
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:05:16 +0000 (UTC)
X-FDA: 85471545432.23.4279421
Received: from insect.birch.relay.mailchannels.net (insect.birch.relay.mailchannels.net [23.83.209.93])
	by imf19.hostedemail.com (Postfix) with ESMTP id A31D61A0003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:05:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of brad@sim.vu designates 23.83.209.93 as permitted sender) smtp.mailfrom=brad@sim.vu;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561514;
	b=IEipg40TI+VnZWqUGQHszdEyVi0WJsFwbQDkQws/Me0ZAZHxGtvFPkG3/MIc8TzukaFwIB
	GyK+2kErhoJIRcVOR5qZb+zdmNR+LfIIEQs0fXLiNbN/uk1+mQ4TcjjxYc0GRwijK6SZIi
	BE+X5uxXa0OpTN0JHUFPyjqV0gr1MJU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kp/deucgwzKBnen3+3AgwDCnzUqKLXSpu8EfTUn6Izk=;
	b=b6qTduAnbEkGBR4rsA9oIyChDuNTyb4vNYDET0VSsx0UXH+i24wQgV065n85auJEM1MOC1
	Pg4zAT+N2l83N1m1awnCWFTVqT6DLNxPUUhJAgAymNFbAWL+ANwAUDju3jx6XHPI4m9JNM
	EjdzHYUSlZhpnAz348CQCXbvQpavjVs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of brad@sim.vu designates 23.83.209.93 as permitted sender) smtp.mailfrom=brad@sim.vu;
	dmarc=none
X-Sender-Id: instrampxe0y3a|x-authuser|brad@sim.vu
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id F0A55642983;
	Tue, 24 Nov 2026 23:03:00 +0000 (UTC)
Received: from cpanel-010-lon.hostingww.com (trex-green-9.trex.outbound.svc.cluster.local [100.97.173.43])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id F13E2642996;
	Tue, 24 Nov 2026 23:02:58 +0000 (UTC)
X-Sender-Id: instrampxe0y3a|x-authuser|brad@sim.vu
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|brad@sim.vu
X-MailChannels-Auth-Id: instrampxe0y3a
X-Continue-Snatch: 32cdd8697f597c43_1795561380886_2841758545
X-MC-Loop-Signature: 1795561380886:1204463361
X-MC-Ingress-Time: 1795561380886
Received: from cpanel-010-lon.hostingww.com (cpanel-010-lon.hostingww.com
 [18.130.191.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.97.173.43 (trex/8.0.2);
	Tue, 24 Nov 2026 23:03:00 +0000
Received: from 162-195-230-196.lightspeed.wchtks.sbcglobal.net ([162.195.230.196]:53986 helo=epyc.attlocal.net)
	by cpanel-010-lon.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <brad@sim.vu>)
	id 1xVzXL-0000000ANIw-1Adt;
	Tue, 24 Nov 2026 23:02:56 +0000
From: Brad Hawthorne <brad@sim.vu>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	david@kernel.org,
	surenb@google.com,
	shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	thehajime@gmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/nommu: keep the maple tree in step when mremap() resizes in place
Date: Tue, 24 Nov 2026 17:02:34 -0600
Message-ID: <20261124230235.859633-1-brad@sim.vu>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <awXMCqK5H2TOlvtf@gremlin>
References: <20261121083139.803682-1-brad@sim.vu> <awXMCqK5H2TOlvtf@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: brad@sim.vu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A31D61A0003
X-Stat-Signature: 11triy17qoc8zffbq6ujnxkayxp14m4f
X-Rspam-User:
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795561513-73836
X-HE-Meta: U2FsdGVkX18xMKxoh7VqEBnrv4FuNy0LkoZSWNIT9vN9dg9E+V5RNeIuKlgVSXTuI+ywxoIERHK8Yrz68SJEv87MCGL/szbahA4p4sPrU18fs1CowYj+6TW6SfR326DjwJWps2WxW3XbzCufm2L1Ac43OmIdelOoCB7OAVlhxG0+5EDLjF1DZsie+oLbblpy4l26/l/9MFXAm5xXpGiHMSUk65VtgjJNk27VaOecRM2OhoFJpTnrkyBxUhT3tkYINQS/AxCA1mVsW8q+++MpaZrPE/epICIxWpm/v5hfy/Xzgnkzt6NTmfSgzBhyDYXbkSX/FMHy0TWw2ysXUlqd+fqstwu+iSVN2IjEw8GxOt7Vrb+V/WECjKbJT9ghRNk/9QXV7/PL931/glkrZRBzoLJy0zty3Np2NLWphqpRrowDX46fOPX5M4wdzH2LUEvrkM6pLgAtJzzIzL121YJZPtcPqCPOGfCulvtFazfv8qcw7GPqiPjQ6D2fbqLLZrZq6eVd1Tu4zbBmyRCZeWmxU6iFoIDCznf8N29R12Q2MetZTqIVulF/BB5ekwsiKo4Fr4i0bm1ewVmcR2LVI4LlI8tu2pI95Sp7E+NYk19y6ApajdqUuhszkXUlObzXkYv++9gBOmRauK/jCbA6ua+zoTFuWyNacxPPAabqis0LCIQoSVJZf7ogGUVM7DtY1mstp8n34URwggzFLBGsv6SBxsxA/0B7z/Kf667YvCdCnO2MEBKNSHtbW4xR4jHNGFPBV5z+1F9Z2qc4DbKx9dRl/bMDJ20sFX/fDdEvv+Fzo2sSMK9ALo8F2BUIZ9J4bET+vLG4FHUd5xg/GaZqCqutdzHHOr2OaMh4N+I/5qWFq/YG2phWDA9sh2AE3ecbcPcsqvcUwXzdzEh7tv3Yhgkg5l7hcmJfJxOB72NY/tLbthARwI6Qh7sg9iFrTfj3zKDxAxxuR447T/2SSSU82t3
 fz1giRZx
 8Gkqh2MeLliTqFRRoaZPs9fo9Sg9UOx+Y59sWuqye++vElzCGEu2TGlVeFwQrmmh9DZPCVYKftFA/mLo02c70mfmBGf3grZjT+9rk8J2blTqlgc2sPhyUVA0odT1HkPqLW/QdGJtcquezNgzf5vmaN/ndFnqprYRaWxDoKy8yqgThQx3KcQY18bNNQxrLLkQ6njxM6qD8AVjGzzeXoBqKSjx6t2ZIkD/ob1YEIV7g3SaXObpLlw7iUuklz6Ple82CLuOny+c2HMkDiNv7FxO0+zIZVqEHQSKeTFphTCQA1BLGTrf/84WaMZuakhFvrCWNM70e9PxMOuP1RWOSmoQH0vyQpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thanks for the review, Lorenzo.

On the points you raised:

- The comments: agreed, they go.

- The unused iterator and setting it up twice: you're right. The
  iterator can start at the old end, check for an overlap there with
  vma_find(), and do the store, set up once.

- The preallocation: there's no lock here that forces it. A single
  vma_iter_store_gfp() would do.

- The casts: they follow the rest of do_mremap(), but they aren't
  needed on new lines.

- Why the tree is updated: a shrink has to clear the range it gives
  up, or the tree still points there after the VMA is freed. Once it
  is cleared, a grow back has to store the VMA over that range again,
  or find_vma() misses addresses that are mapped.

That leads to the question that decides how small this can be: does
nommu mremap() need to grow at all? If not, a grow could simply be
refused, and only the shrink half is needed.

Understood that it won't be looked at this cycle. Hajime is working
on nommu mremap(), so I'll leave the fix with him and test his patch
on the board.

Brad

