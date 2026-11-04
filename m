Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A324606A330
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=c5jAQldw;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=gNw6+e49
Received: by kanga.kvack.org (Postfix)
	id 572A76B05B4; Wed,  4 Nov 2026 11:29:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529896B05B6; Wed,  4 Nov 2026 11:29:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4392D6B05B8; Wed,  4 Nov 2026 11:29:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 219996B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:29:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A55631607A6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:29:21 +0000 (UTC)
X-FDA: 85397971722.25.5DB6D5D
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf01.hostedemail.com (Postfix) with ESMTP id 68B8940005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:29:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=c5jAQldw;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="g Nw6+e4";
	spf=pass (imf01.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.159 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793809759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LaiQAira6LJea59JkTCLBB0qD9u3ETiU1WU+A3oJQUE=;
	b=FoDXlSNMHEh1XmjbjGhyWJhGHvMV2EHQW1HYnChe4xhog5SGHR31iWIaRvUR9apDIOaqqn
	qHDEhAVSNVdZmmwE7ymlK8j2UBkmam1OmkIsdnA9Yob4M/BWWQGMGR/8tBOCDWO0Bf1j0A
	Y7ZhIDyPuQ90iLWb3dh0fGblUySacYA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793809759;
	b=QqsfIwyFty7YKn+uDDfbjLfZV7d1OMkITMcE9Z4s0q/3FCqLx7VK5KOnuc9tBb5HeN/1aT
	OafQy1tA394Q68nkrVXbq92gkFsj4hiVb9SqI/yLpI7wX+2eA02lpHbn/+xBVe0tsEepA5
	8SteMZuJV+33UtrZnTOlDdwbNq1C488=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=c5jAQldw;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="g Nw6+e4";
	spf=pass (imf01.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.159 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8E7707A0108
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:29:18 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Wed, 04 Nov 2026 11:29:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793809754;
	 x=1793896154; bh=LaiQAira6LJea59JkTCLBB0qD9u3ETiU1WU+A3oJQUE=; b=
	c5jAQldwwgfNnO5PGIb2SVCvwCRVrFn0AlzKunbwhvs1uypMH3RhKhsfp6lsD7vh
	2bqcD+fRJ6Ro3ct1cv8aIHCwflXsZFuf6ieUiT03qy5NBel1NZmPUPzPK0IzAzRh
	RiwW8q+X7tly4os1ahAaRhabUajpsrZPek80Los65hailxoxHZDO1CubmR5wOZFV
	vdsHaH9jdnVw6SmQCiFZRsBnuJFKnnsV4/egmTrrmUJYPXp3YupKcXYdBvyDb98Z
	n3oNyIvmA945r0eraN7VFXYuvbAwhHGwMf08fEJpOzuBSomjhk1Wd6ZzYhBuOuPA
	Dq848O8cOxZdxov4Hx0X/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1793809754; x=
	1793896154; bh=LaiQAira6LJea59JkTCLBB0qD9u3ETiU1WU+A3oJQUE=; b=g
	Nw6+e49H9+mGLS37jkQ9yV2KqwmOO0TtosTC9yMm3VJQvCxVnyBB1P/fKSrz0S5X
	19DAs/+K2r1is0sDqBvE7ef/xFLwloc4lJCd+mJvaG4G7bCjX808ntks3lIk6ROc
	cJ+IlCuQd+SOZN5EyxA/thcnWtLLGPuaNmorrUUj3OTK0hWCWwexkm62WE/CZw9u
	lI21eAp88Zd/5XWnnLV3MLHwk3QtPPEtSmRmsE+e/LmGBpgvArx1lNs1yDPBd06o
	vUxRdl1VN2SMGnh4cChp/LFjH+B8rbgYFfWrUChSH3xou4PZ3BAtzvZBjHPZCIOn
	NxiSAVVXwewsxMfxezD1Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793809754; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:J7QRTuLdncfeiUDn6IYOEaHCpOfTpLXUHYqZGG/wWCmSnaB
	Koon+6r/tE4PIp32TsS0b/lY+lV3QplgP9At3Gh4rU3oUXCGZMxK5XWUJj1Io9Cq
	RsebRKdEhBUwjZp3ievCk+fZ7icgm9Q7gc61Gt2972BAr5E6CUX9Mf0LsugXcXPa
	EeUKmboda6CZHEKzodW7X9sM9K4Xl1mSCP09nUV+/w9vEXFO0IX/QmcVJL2xtyHv
	SH/vFA1BPKG8y4kUANJ6eCFrQYXK09dkjRD6icVw8zt51PNokgvoKowZdyqZ9kE1
	kyYU1eRsQVxDsLb442LZcY+6IXxlZM6thNXLAGg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:EL3Gd2i3YhMp0vFuwH/WrQYooSA5VSKcuTfRIbM04wM=:LaiQAira6LJea59JkTCLBB0qD9u3ETiU1WU+A3oJQUE=;
X-ME-Sender: <xms:Vl3ranwSd_CykXkfKt_DisDilg4d5ENtLvR5s923aJuWzflU5eJaxA>
    <xme:Vl3raqEaLcs3p0xIklBe_kdOatnAVtJBGfzdGDeXfP-4l2039sFGhGyJj6LSkF8Ar
    2hbuMLLOjdHgZVIybpvYYx09UOO7Zb-Wved_JG7Sv2wsBzAtihg_es>
X-ME-Proxy-Cause: dmFkZTFH3IypNSuXYh3Kd74bqwW9a3lD7bkOwTRBwylmNrIwAT/Vx39h5sxOyk8YBaSEZz
    xzvHXAYiNUdZ462ifvJfTSJqf91mHwxbEpFrPXMj1SHnj4aDidHBfYvmdBRdhvh0/PF8qX
    +FGCYX+gKEh7CGDLNwxbtVgwqJruBNp8XHMf+TMZGOQne8JrvnwZCetPfQkOD5+EGGoMVB
    i5t9gZhjOBTBFO3jzM8Vekg6mA6KqIVFvH06ObjWAQ81Jf3Ti57IDye2cEHmj7kEXzUqyA
    /4QFAKLHp3mu+XBx8EG5H5mAbNWXF4jgXOdqGLBP4+Wv/YNfC1572fnWbAFvBi43/YU5NM
    7IIUxNxdMAWVIpotu+ptvwKET/+uHDJd71bv8K0TDpMF7vB/gyGDH1Rq5PKPMlYahzd6Jb
    u0CDbP6TmvPeo92Q3pkO2fYYBFLcS69KkVaI8LXslUr+jvc+dJcvZ7P5LRrVsgrbtcNq0Y
    700mxh+Zf7ZTNCsLuo6G5Uc5HTPFtCd24BG6Z1RMx1XI4arIvyWVRvPHj3nBjWEjgwBw7t
    1nF1eR86yNI65ea9glVmwA+tAdRWS5n4iwRaurZurrVmqqsATLEtljzUfKkQCWuL2O8Kro
    qef1ZgLBCxyqSnae30OfExhtiQHgC7DUjo7i8BECYPzKdp4Cfomn1bTx5hng
X-ME-Proxy: <xmx:WF3ravNYn0pPMBtNVZ2bgjPadk6SgfgsM1kYdJ-IZ2KlPBkEu4C1QA>
    <xmx:WF3ranWahz3oPRDUywFK761jpK9YNubOerF7kYQCFpjlvNFlXgH8eA>
    <xmx:WF3ranzyz6N30adHDEAyUTUYxaqtaXtG_VMEf99hlyORLZgnTCmvaw>
    <xmx:WF3rau9oMC-j4FQHSfUNHyNNuvuvWuQ11Qj3eJHgHLLBTfQVHHZo4Q>
    <xmx:Wl3rakdMjb9ALM8TzZT31cm7vg5FWCxysTNlakVIHZfPzQ9xYXHB_LWq>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 848EE32A0093; Wed,  4 Nov 2026 11:29:10 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AgP3mv5Dxly7
Date: Wed, 04 Nov 2026 17:28:50 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Thorsten Blum" <blum@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Pratyush Yadav" <pratyush@kernel.org>, "Alexander Graf" <graf@amazon.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Changyuan Lyu" <changyuanl@google.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-Id: <be6ee9f8-ae2b-437c-aa04-0390954f9adc@app.fastmail.com>
In-Reply-To: <20261104162352.140836-3-blum@kernel.org>
References: <20261104162352.140836-3-blum@kernel.org>
Subject: Re: [PATCH v2] kho: Remove redundant 0x prefixes
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 68B8940005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: n3bn4bqiiw6ory3c44sjhhqxhs898yfg
X-Rspam-User: 
X-HE-Tag: 1793809759-321723
X-HE-Meta: U2FsdGVkX18im/IhY/TxE2L4U1ZFVpEDtdU3MdE8WemO7QLW3Fz+Z7Ox+wiK4qGUUOVOzNu8pa0l2ZJyQDA+PU/X90ffMkqOOB7BXeNq6gFhv/spZpQ+7YwZc6P2wJNWg9QD8fbn/VYK3xoNlnYPW/UgkndRpQheHI50/QtKxm/uBktHLXdztOSGUZ8NW/LbDESYzu/hPcRtcK+zfeKPQfNt5FR+00i7tNW++nnzCzh5LBlZCwI/GXpFvWqyuSdOz8O1sEdWY7RZfAavLXq4vf5kN3sV5oidgCXsTlfYnKUAud49+Le00KiPHU8rxx7ptepcbIG1zUQoeaAKUOPBQJXOpTCRSzvUItWHBL68+wLhyGD1T9ZVSfAWZNi25PPgqL9FVXHMKwpq3i5aNSVNlMfmmk79ypY4/fDHar61oG9LXLY77xq1nPZqccTakm7bPCJKpkeje2T2wtTfYHG00nAU1Bkw0xmyBDQSNixPpIPCdKwVIJlJTK/6M+TFvzhmvJFoaZWkn5R3yf93BkbRiHzedQu6jvQIgprPlaW0tTVBzP8hD/MMry829v7IBnQuIlgpqQiWa3Y3WEwyRoWwL03jbt7JTxidNXywpu9x7a/L3GiovAy5FTXJk3PPaAl3yFpN6nS5IoyPIP6M2Vdzg5/ZguRa1HwM+UP38S8BOsdL52DVo/c/3XFzGhIl+gneZJYqV6I9ZaCDcb15gQpmF7CEUW9w33yjG+jXi5dhO7QX8XPUmMnN3aqqAQe4L7QhjQFC2+LP/irP/082HDwG9wv7VmpqgAp3NXohnRtr3P/cwfDDnOZnB+YJiCO2PnjxrGDpW1j+3pLzsIGvOVfumpzexIricZuQdfhKi9MzW4H7cdR8pcwi+XmzrCrjDWISQVwDlxbq6gh9GJ4FHzvJD5kNCYn+kQ4sa6obN/ssePUmVywWdEb6tmyDfpziowdGBMow3kKQjpR3lb5C5F+
 HqwdvJ2c
 stoOYx0cvoBNzgX6eTjrLKilmyO8J+WEdB8+fKpvRvEuyU3u4s4cD3E668Rz6umfW5ggFI5elJabrmLWoOgn+A4tagyMCY1C+By3P5/yJzggMCWT80yGzD1Bk7xlPz4bb5IKveiNvVD3WcTmeQmK0Hh3+E0ZTGcfUTuTYAmXY4bfOFjW6zcKXBBVjaYOQg4Ul/joC/bOTLKBMEVSEnKW+ACBDuh3f0G4ESIV0XsDgJV1litE9LKrehepiMabvIJ2z4KaCk8O4hSyE5cILDTsWDt/3VLnORqNoOgpO5PVqOzD+hdhZWIX77WHOcDcqJ8tQEVEd/Ztt6VForvWKygAcK6XfpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026, at 17:23, Thorsten Blum wrote:
> The %pa format specifier already includes the 0x prefix. Remove the
> redundant prefixes to avoid printing 0x0x.
>
> Use phys_addr_t for size to match the expected type.
>
> Fixes: c609c144b0e8 ("kexec: add KHO parsing support")
> Signed-off-by: Thorsten Blum <blum@kernel.org>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

