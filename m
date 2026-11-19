Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2C2606D6DE
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=jxBs8QIz;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=2YS139lF
Received: by kanga.kvack.org (Postfix)
	id 1B6ED6B06AA; Thu, 19 Nov 2026 10:41:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18DA86B06AB; Thu, 19 Nov 2026 10:41:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C046B06AC; Thu, 19 Nov 2026 10:41:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D560D6B06AA
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:41:50 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 26B42160B32
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:41:50 +0000 (UTC)
X-FDA: 85452283980.18.C9E2465
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4EA2540014
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:41:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=jxBs8QIz;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="2 YS139l";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.151 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795102907;
	b=H4mxtAxNUktPPjGWdUSs8oeOZLPpSBjhPlf8zIDUyo2XyBjGVETdOtuhMaqLy8tsYwFMse
	W96AcFK5Ht3RMOLAisQAWl4Q8dflxcgKa4UED9RVg7pdqT7PRqNZiGUxg6GVOTm1Ufp6PV
	cSmYmHs+gaKNx64AotDWCVLSXHZ0ccA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795102907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B90skwYd1qAmd6vMKCEeV0qmpHWsdX1OY5Q+tOw1v8k=;
	b=MPCo8DOx7tYc+qeciAk934tHhIJGyCNbHK9U6K1tnAT5kppD8NcncQR/YisU99t5CQkVJm
	MdhUq6sfv6efkAeU4X0l2p+EZf9GAKGpd5RkHVYFcUFJxXZYOeYp7GYr+RtTtg8KekqMC1
	2pdTkq8LA22XQDUk/+gfWJI8Oo6iOjg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=jxBs8QIz;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="2 YS139l";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.151 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id CE568EC08FB
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:41:44 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Thu, 19 Nov 2026 10:41:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795102900;
	 x=1795189300; bh=B90skwYd1qAmd6vMKCEeV0qmpHWsdX1OY5Q+tOw1v8k=; b=
	jxBs8QIzA0cRfP5Vyv27H7cm/Mgi2VLx+9pXZf/uUtuZxWU5R7hk2YhivLz8e+l0
	Dr3BmhpPvjCU43mmBeOHDIoCrUF26KS5s7bb9ZA/spMjm88qxIrnSmWheGr4ZvDN
	oGYg2e5QaWf7Wryhzp4vVkmtpCXQ2f8Mr5ZaOXAuALKe5b5+ND2kHefB8Jrl0WLo
	X5yGG06pmih0n/YjABV2WTk73/IcZKZLx0yszpb8Wb1QVQBbQLFXYDehGVlBnl0i
	XBVsKHwfqsu3o93tg2WPt1TyCnQGaB/c87Ymc+AHVLUUgDM/LMeJQ/dLj5959qHE
	eYMbO1oWxILiLKKmIbF+/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795102900; x=
	1795189300; bh=B90skwYd1qAmd6vMKCEeV0qmpHWsdX1OY5Q+tOw1v8k=; b=2
	YS139lFRvGoiiNjtE9oJ8CsAxkEm+Hi2UMvQUE6hsulPeutovXmasdKtXvINVHY7
	V+6KaaSjf4Z6N7uLNpnvtDuBjRHtwn2vfzfMEL93jdAEXdbh0MKvbocWHZQHpmM3
	tHp4Xh9tz4AT8o5ypSeMpk04e3g3Fb8xNOCLoHfKrVS7U6zZnZNG9c4fjPF7txQz
	pFjTuIK3mPH8Lf+gbPf/V5MuUIGTf6hqaR5dnxbdGkVp+HFQ75jomfna3sNCEezl
	FszscMm70xUmCiJEzEB/nwdhD974kan+M3LnHMqrUAHLwBPcfMCUz8KTC3oZ7ULQ
	W4893cFUeIKnGP9MwVo/A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795102900; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:fu4sUecTiHd0YeBZjBAGAfIl+xNOl7y7Kn6VaoCHAmjMplT
	WwKo/rOvGZfjlRFFXU0tqDCfXsIstN3WMhMVOULe/YWRRGKY4FG19f0FN7YjMKD8
	U14eSxtTIVG/nWIxUefDiG0Hlfsmp82sWdkuGxSWAhEmBpuNF0fM1Wu1R9V1ua9m
	q6Chh1ST/fmdy5U5wxm4fbo5diIw60gR9ZCO57vyXH6jxPP2Oj+ZMkugYaf70osL
	G646dj/OwDZDlNKlNciHSgdaWWWSb8qfXDwXXWpGFrVoMP1JU3bnmvxqBB5QZ/4V
	q3Fwp48Hr2PcY7Mx8NCEOlVDJXSoRHAB6YPXPfw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:cqK5PiLMkNzckENgfaCg7nbFyFe9CIzKtv2VFzo4Kk0=:PDLbKJ94g9ptr4Hqb/6hre2VJV5CWdTnyy9JTZKadEE=;
X-ME-Sender: <xms:rBj_aqaGtwHUeudDvg3WxR4DEB1BTFIPp7YQsWl6UAtkPo0y9TGVXw>
    <xme:rBj_aoNMtI6tj7q3bAgadN6dl_fKAOqckIAGABersr4FFnr8JwkKfuzRgoHZpU9kU
    pDnbFe9MWKlo7LBgQu4oFiRh3yp8BSN_9WDBxpo6_rz8rLbncMuquz1>
X-ME-Proxy-Cause: dmFkZTGhxffOCKON5IDM7Hol7QKiToOPnne2UeAT+FsCmz3R6i3Hgq3Jan1P0d6FqT+qjo
    iCZIEOB6f5lnrCHI4o4vRFSt1L7+HTKcGr7QtGEHeICoss0BI1XhhqHJrigSqQFW7dq2HL
    7Rk2rhBtNaspcSiipyqCP2/czVK4QA9YLJHv+/fDvHKSaZm0rrSIjzLBiLDjJXvi17arWJ
    QnkrXiS51C2TDiiAqWaXo3FN7Ta6z9IX/Ag6g4ZbxR88bPXD7DLzbZWBkpctW9YIJjBCok
    kjpjJDN9r56ACjf8Jwid1kuZYRpjhhboc/eB75i+uJMPjZEWOaw3PQEKErEKN762tHV8Aa
    529teFEBUyfqqupt1LcliMumuqD3uSVX6co1EbcH2cp2yR/Ih6aEWp0Qx068lzv+R1yDLP
    sGO4gBS2KSTBEgdTTw6g915PHBv5DV4vZ172ZYM2Aya5MY07W0WlnW+Zl8sDOWjmP+FJFx
    DIhRiP8mLb4SxNQeWycgzdKw29lUrlnA4U+PwuXtqzzbx6I2x3Aue8N03WaJSFPWznVTck
    krJr4WJUDINASA9FM2ECeYzolHmiXppHdNdkbxbyZr8uInMu4vNx0b96vbew89iiXqgO2y
    q8WTdYfvmPgts41KlqjaSVwAoE2OS3pGApdG5XlBr5RWzh57+2y+BPH92lvw
X-ME-Proxy: <xmx:rxj_ahfv8VBMqTglDmN7YK3JRLurqk2byWctVi7rYqQrdHPHx0PgHA>
    <xmx:rxj_akzWuOJdHmREYyeup7ZXGt3NCk5Q9OC7NmP9JaEDQE7-AImPMw>
    <xmx:rxj_akEOnSMorn-vHSp4Y90jKOOaNHvPk4OT5IxKSOU2OmSwmTGX3w>
    <xmx:rxj_ar21H6bhJCqdoucIDzu8IPpt__63s0DpRZwhYKBSdz789VjFPw>
    <xmx:tBj_ak5Yp4mt2ns3XUMTLZN-yrtIM5uObcBHY_ZE4z2LrBuprcmDH6aM>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 8351B32A009E; Thu, 19 Nov 2026 10:41:32 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AQiCUw1cg2MN
Date: Thu, 19 Nov 2026 16:41:11 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: sashiko-reviews@lists.linux.dev, "Arnd Bergmann" <arnd@kernel.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Gregory Price" <gourry@gourry.net>,
 "Andrew Morton" <akpm@linux-foundation.org>
Cc: larips <larips950@gmail.com>, "Zi Yan" <ziy@nvidia.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Lorenzo Stoakes" <ljs@kernel.org>,
 "Brendan Jackman" <brendan.jackman@linux.dev>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Jackie Liu" <liuyun01@kylinos.cn>,
 linux-mm@kvack.org, "Kees Cook" <kees+treewide@kernel.org>
Message-Id: <cac60b9d-e969-4933-8b0f-85b7983ec838@app.fastmail.com>
In-Reply-To: <sashiko-outbox-221984@kernel.org>
References: <20261117211635.2472067-1-arnd@kernel.org>
 <20261117211635.2472067-2-arnd@kernel.org> <sashiko-outbox-221984@kernel.org>
Subject: Re: [PATCH 2/2] [v2] mm/mempolicy: replace copy_nodes_to_user() interface with
 put_nodes()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4EA2540014
X-Stat-Signature: cmyy3t57upwuyuess9zwftdkoxhuyeao
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795102907-579553
X-HE-Meta: U2FsdGVkX19sH+bpsAvPFW4sQWyTX3w5awmyBmrJWZci2Op5/TYWYJpfjcH+3Mg839juYoObkEA5oBktYdpNbqOZ+yPPO9C65by1A3HfVfwBLUXexesS50Dc30QQMkSykhZB5+hkOvgwyKZa2kRmfVut5GiR9r/qk583MJRdz91mRAYXVPXFA9N010KGpfiY7zKG4e8ALN8fO0KwbbRjSQyuzLQOqw805BOjc8Nw/Mq+GVnCT4/4Bdvu6GjXJdAoqgAIC1vP4r7tOkxaMlvzzWPNfh6Ge7FQs63uQN+Ju18++oaHjAp3Vq711RvdKzQx1qtb6ZvYkHuzCey2Q+yeDAXUBXJ+eotXRee03KRP+c6WkLcQbR+aUoadO+eQg8RowEYXUlAl+3JXL8o1UekQ6/0NZ1BfC0jVuRn0+8uSICYPRzBnSEPrRQNr6/qTvEYMZzDYBwm/Xi6tTE4Sp6rm7lzcn25EOiP1jf1uFO7WavVB6wGn8TMEQuKYJF4QvDSkoqD3CwF237n9/ZYWqj3vciQUWiH3qETwsipSD1lEDoYmCLDQW2Xb9eb/PeI9NdqeFmWPNSN2YEKCGrAp6UadqNr8HMjqeO7jzu+MNxWG8toawcu9RPxTfmxDqKBJzP12Mu+7GYURCy3TiQ5fAorF0JnzJ8EPEAN08bwxLsW8V3Mn17nCtXD4wuYO4LRkoG6520QGUmoJobE3u1cFVPLzrlzpGo5GsLsv7fEVbxtHmRnfMnYPwL3zwzME0FwxUi0yyygTXiPkhadrP/2ChKKiqHUZynHeI3SMAqfTdCkLskaNT7XITPQvWOf9jN4/aG//56vxHWmkrjpHPKPAbrl6KQ64syFnri8R4hraHt7judIpbx/bgT2ZowS/nKf9b7QoRBeTlrMY010YlYYlC0LadNM1kLyudFuh90WexKyg0SIGSQI2rcDUWiTB7TfqO5Wf3riLaQkGZBkcOOXiNqN
 0YdjQjhM
 MzuE4pimDDZoeqP7vdO4TL+qpBR8loaBr48caOfdqNv9jCSrn9gpeLO6GTSt8JlCygaWW/0pTONeW6+xt13jQAG78vYe6VaMVZhvQtYdgOanU0fkc06YzAfAqbWyqG4281tty+BdSKwYTRsqCiFru39lMQDCi7Ypt4Bi4LUl//nZTOFINPog1DuRRR1fEFrZZdnVm20puW7dhIljRz37T/9VehRs4eBmDbHldBaUu0R5rlsQeX3KI3hcb0+Q5b08EGpdfaUZcqGuXn2BFIBic91K2YGsBGd+FxPCDYr8scV0gq532mKZPTHqC15+7eJDuODJvzUgLBQmZ7cvjEg1g9rvb+Gyvj+cDXHaAau4yGzbKsRIZ2PTdzaj7Ol4oq/ifYkHQ5y17bnLVdOOBMIHlu8dAstDAHD2VN3h4R46SZ8wTtS/Tbs4AdchzA6i6wEoSBm1pLXCpwU4AY7VZDDLtcFlJzclUgSfxnDxswDmMxzn0gpOWl5QprQJE6Q5i/Kk8xyTfj1GHRNS3oB1NQOtpO8IOcahfzQUcK03fiw+bMjnAcWEf8TquR9al9dBZSt3T/DTzP0Uw6eqfU9cw5b0ClC1eQvcZH+7mhphKw7MQ3Oo4kGBDO6tuSUMR9hQeSEvbNGDU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026, at 22:16, sashiko-bot@kernel.org wrote:
>> @@ -1733,12 +1736,12 @@ static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
>>  		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
>>  			return -EFAULT;
>>  		copy = nbytes;
>> -		maxnode = nr_node_ids+1;
>> +		maxnode = nr_node_ids;
>>  	}
>>  
>>  	if (compat)
>>  		return compat_put_bitmap((compat_ulong_t __user *)mask,
>> -					 nodes_addr(*nodes), maxnode-1);
>> +					 nodes_addr(*nodes), maxnode);
>
> [Severity: High]
> Can this leave a 4-byte gap of uninitialized user memory in mask when
> called from a 32-bit compat syscall?
>
> nbytes is sized in unsigned long units (a multiple of 8 bytes on 64-bit
> kernels) and is not adjusted for compat, whereas compat_put_bitmap()
> rounds bitmap_size up to a 32-bit compat_ulong_t boundary:
>
> kernel/compat.c:compat_put_bitmap() {
> 	/* align bitmap up to nearest compat_long_t boundary */
> 	bitmap_size = ALIGN(bitmap_size, BITS_PER_COMPAT_LONG);
> 	nr_compat_longs = BITS_TO_COMPAT_LONGS(bitmap_size);
>     ...
> }

Correct.

> When nr_node_ids spans an odd number of 32-bit words (for example, 1 to
> 32 nodes, where nbytes is 8) and a compat caller passes a buffer with
> copy > nbytes, clear_user() zeroes starting at mask + nbytes while
> compat_put_bitmap() with maxnode = nr_node_ids writes only nbytes - 4
> bytes, leaving the 4 bytes at [nbytes - 4, nbytes) untouched.  In
> addition, when maxnode is between 34 and 65 on such a system, copy is 8
> (equal to nbytes), so the copy > nbytes check is skipped and maxnode is
> not clamped to nr_node_ids.

This all sounds like it should works as designed:

- when userspace asks for a larger mask and only the first 1 through
  32 nodes are set, nbytes=8 is correct as it copies all eight bytes
  of the in-kernel nodemask and clears all additional bytes.

- When maxnode is between 34 and 65, userspace expects a 64-bit mask
  to be written, which the kernel correctly writes from the first
  64-bit word of the on-stack 'nodes' mask, which are always valid.

Setting nbytes to the smaller value as I originally did would
also work in both cases but seems more confusing. The only difference
is that it would pad four bytes explicitly with clear_user()
rather than copy the zeroes from the in-kernel nodemask.

      Arnd

