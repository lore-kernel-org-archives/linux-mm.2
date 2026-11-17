Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569C2606A331
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=FVdHXBU9;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=lFqzxq0O
Received: by kanga.kvack.org (Postfix)
	id 5C1A26B05B1; Tue, 17 Nov 2026 07:46:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572D76B05B3; Tue, 17 Nov 2026 07:46:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461246B05B4; Tue, 17 Nov 2026 07:46:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E44A6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:46:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A311B1A0417
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:46:21 +0000 (UTC)
X-FDA: 85444584162.16.7479B84
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	by imf09.hostedemail.com (Postfix) with ESMTP id 638FC14000C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:46:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=FVdHXBU9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="l Fqzxq0";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf09.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.151 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794919579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnxVKAW4+DdAcyfkrcKJtarFPNPOGVQzKeTY2Yur2CM=;
	b=4lbZR5I33CVg9alB8jjVDgDlTarq0Tcwloydsv/spJjnLTj7FJiPFFUB4kt+uovcyj+29M
	vlkDy0DNnddEDWYc70h7JWLBF3XmrZic+YduSR0UeLiuxO3MpUsdq3Zc6TyDYbtgUz1vB8
	K8FlxU8mKDvsAKVMAHULs8AkWtVfnbU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794919579;
	b=V+2Ref2/cgImeIMudo9kt5XdZL/amd6TDHwGTgkWjHKkwCTgWd5EyHv/3a94l52JCXbt7A
	qZg+WDOjAuxKhJf5EGn520CaFYLGBxawl1AaMCgXiTqNjfWmzMcIyWKHZQATPm3mXUqXI+
	U1I2HxJTsgxN8Con+YmT/jM8zNT5W4M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=FVdHXBU9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="l Fqzxq0";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf09.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.151 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id 8EB56EC08DB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:46:18 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 17 Nov 2026 07:46:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794919575;
	 x=1795005975; bh=YnxVKAW4+DdAcyfkrcKJtarFPNPOGVQzKeTY2Yur2CM=; b=
	FVdHXBU9EAHNkmTDKyYCnzi9b76B81eb0z7i0qH3PcPWGKFs/WX9W6JNJB4ToM+p
	weKy6T6F/+oFsSSDlPwae/ycxVZEjjjIt4WT6/eiD7aYiPkuIMSN1IOEhudtsc9w
	T/uqUaix7qCCqNbG1UUy1d05XBWTrNiGjE8kwUwpya16R276DXaL9o+rGTfXH3YW
	kBQQdgquU8Etnr2C3wRIH4+aH7UmzATRGWuusnVXaVrzr2mBPH3hYG78nu+Jm5HH
	oDt0SKqmvOnai6Ufj5lslD/w3uEhW7ZmvJuTgg4GyZBm9MimbFEhBrF3sJVhdRwj
	In+I822lYu23bBw6szr7Jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794919575; x=
	1795005975; bh=YnxVKAW4+DdAcyfkrcKJtarFPNPOGVQzKeTY2Yur2CM=; b=l
	Fqzxq0OIGtcTJH+Ayl9lhXsRi4hQonAG7Re7Lh1eS4Hew8SM7l7LGNux2pOHaLBi
	In8QgY7CX8YGfoIEY4FUv2xckMaoLoCXeWbDdI3RBWuAMA7WRtFGDLKHXi1d9He3
	HDC1oSzw1iUTB4rSAvYTnkGmY7+UfefJS4s3sp44lnOszLyp/v7tw0lYFyZNWyHA
	OQ+2NuhXafiup/56PJQk6jFklz/spItSyy+ij+OSp1Tpw3spw9SHu5ymUUEjmXKb
	rSKnHPnXq2TKJwcUjFlg45NNnhyRbKd+06GwTdv4KvaSlIPz686ryPINArh3aDxW
	TrQtUKx2Gv+HsLDCMLIYg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794919575; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:A5HjkA1remcdpSBZ8klzD/Ik7eun6ON6lq+0/zHASDx2rDW
	zA+VnumNOqehM0/dUL9TApVD5iNUJIIvqPEGFCH9qHcno66j9RiGM7Vz7DFFRrJt
	wm1C7nyA6n24+sMHwX1YtYS1HTJHJiG/WPg4j44EaPFsXHBUqX5hp5c1yrbij28I
	n36o9npSKy1zw2//GilEweheJ1Sfr3a7Dz862dLJoOWCD9LPc7UD6zldlcIkNRFQ
	ek6IC6nk7emUs7tn2MheVxR+dLQZL9un97SCumiSsjema2fzwjBsAxvlrzpxV5yE
	gw3MNVggUHIpEi9WVjHQkcNISX7ehXSigvXNVCQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:l9jwFaigUlP2Semq1pBSvPA3q9zJvNN8b8OZDwzhLp8=:UPUUtkX4R6DS9/Yu6LpWZqAbGWKyCTDEJxdw++jr0Bs=;
X-ME-Sender: <xms:kUz8agq6XN9cp_cqSuE7y9Mt7cCL-O_s_rnO4uahNRkbmFygGMr-yQ>
    <xme:kUz8ahcGZ3IXoi7JVaLiQhj5qr40JBzC0_-BB55wmm7PqcxHic-0yOggIZg9o4rU7
    0WKcAE3pi_56824W1PZ0dPuT_157Cq_BNjGUXXJQr1QW4DSdDwucYrw>
X-ME-Proxy-Cause: dmFkZTEQ6l2HKVovdikndXCQnuzqOGyZJgaZz86ZLw177hPDftS30oVMEijNYMV1UfTvYh
    gsPHRgVgloyv3vsz3E2nQEt7/GZAQYru/bf7ixTMTpCdGPjwYRslcw0pzEOSBfusBs3rkd
    j5qv+iImW+0q3I8QiJ69Bo8VRKVEHoVvQG7wh8sowDUoa23IdW56CbW3JeJAuNl2jUckYd
    UHFheAed3wq4x/srblo0ST6uiFq9n0zZ/Au7ja7VFUzDA51GrdgZ3+UjpWx9nwR0c+Lrb6
    EcjyS+GLwHLnF9q+1z1ikew4hX+SJ/p+zE3/PdhMhAobNRsagxN77g+3JM+YSJ76/ZMBKA
    hfEjtDJ3ezkKBwi2DZP536aPnz2iC9efLlmXPYMsb/JWSwEKqyDdW7bjVcX837dtfJMP47
    r2teeJ3cbcR2+F9laJAkTs/1vT5VWhovexqg0uVYcTHAbPwY2QXRVx1B+6KbXexIDp6jAs
    3a1HN75YvgaarUavgmHcpMMf7sEJhVBvXky4LZHtaqsTNDCeQ1UsnCzbCRXggft3Mf80kD
    5ODjp9nFtwX5Axz80fvLxmOBm1oScxUQ7gGKx+GqmZihk4vgmS50JC5jONrTd/Of3plHx3
    loPKDYlcZV93QFS9AZPHj5BxI8wMi6NB+GbZxL2wj5+jaQLCnkBsjBn0JQHQ
X-ME-Proxy: <xmx:k0z8asnbc5FinHeSZn-pp9JNrkdpjs0lcPYJHc7RbYXNcqmjsa-ZEA>
    <xmx:k0z8aiOpgUMwS6oLAjjlc7yNIPQCR3caegdZGbjDvFF-nhJZBZjLlg>
    <xmx:k0z8am6XXv8jjTDdPcNNfqR4kuTwVWz1nWnFcPBYmZdyb1VkCZxwGg>
    <xmx:k0z8ambtKBqrdnGPGaDjwl_K9BBiQ69q-Ze9JYtIHmVj_xYREhR9aA>
    <xmx:l0z8aogw5VB-aSa7rqcut_3EOCZkhoCbRstY0fNmO-LuibVSkqxZ5QjY>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 942BE32A009C; Tue, 17 Nov 2026 07:46:09 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AqUefEB18S3J
Date: Tue, 17 Nov 2026 13:44:50 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Gregory Price" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "David Hildenbrand (Red Hat)" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, rakie.kim@sk.com,
 "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, larips <larips950@gmail.com>,
 stable@vger.kernel.org
Message-Id: <3b9d974c-18d3-4113-b7a6-1f785f19b318@app.fastmail.com>
In-Reply-To: <20261117101910.1820066-1-gourry@gourry.net>
References: <20261117101910.1820066-1-gourry@gourry.net>
Subject: Re: [PATCH] mm/mempolicy: limit compat bitmap reads to the source nodemask
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 638FC14000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hwkjkjf1491s4oa6hetko8px8icktnfq
X-Rspam-User: 
X-HE-Tag: 1794919579-873806
X-HE-Meta: U2FsdGVkX1/oUIGmhIVgpnH/UvZJ/AqA0XWFWst3yLD+/M9JSavds6E11qfhvfukNknof9GVOO2b/e5f/Bm/uwdRgWooP8GDMyzZNBzNJkejDUrt5DrXGQOh3f6PFffoWyidPXZPgVkMnReuIZVmW2qaXGPEk/LlnQk1kJuIuCR2qWi/i9n0s/xajgoVRJgp8coPRSjH/KWM4RXN2J8DTTOQjvN9N24lY/WWrEScSgkaAHrDpi3Omu3ZX7UbIXeZhqEcorYHDiJQWkOgEk4QlHYUIRII9q4QwwqZVrZlYMuZVoryok4RCz6bhjiHxUk3PmOKDceiHksJf2Z7dv+lMvDVNTWehMIfCyxFlEvMkSyGv3phT1fbFzHMekugDLLQ3RD/ptyO5619BxVcKvWX/e1JuKQ+aM9Zq8PnAGbQ8hshbw4cQXEhAdzsTMRKTByMdk7t+Hc/hbtXMhP70ABK9qhSICBdgNWUNYe1C0b8wRmJX6tf3qoQHC2176l5YqHOCBVgdaG3fZCrc79zvSvLBJtXnE6NsUIALopugmgNNSBLA6QePL8UGBa/CePsR/36wVn+P2Acw8FzyKMZAnkpMkdwKtE2cKN912kL625GPQFU+YvFBO/a2XPvOBmaY3vL44lqsN8MWPULAzn5YH2pE5E7knHBxwmhhVV9ZfsYzhe+Ib+vfatQrBKX15ncpCDmzq/f8VT5La9kZH5hcDTTIxHHHK5FYiKMLvm4F1MPPBypyQOMvONoCRoK3wheSDw+CsKLhRRCV9owyDljdfHsVwlJsxBysyV3SLJyGo9VEtpBiNvAEqlUYHoezW0/uaYQlL2rBP7hY/l4r8G6rdeiMzJuDw5p6tHtPsC4yqCaLWuonATALJetL+cAw6xWomqvUnCN3WB8/jbCi6Aan1QSqcO5LJj9ZmXZSUyuzMmOQCXl8yziBnO4bvYLmawIyYRNfMTpuALY5E8KRc40s5P
 CJmlBVX7
 0/SogPMRL98cDB/cMfc4bRIJ0XNGg0+qujDr9OdVeQtceKzfKOhaYK98/nL5VbGMLmAggFDgjPa5/w9+P4XzPicHF2UUBTGz5gWc4Kde5y4dtXgXNjQGgxwJn3wbDyZ2CsT5VPeA4fksqnURM5bCV/QTra4LTKKC2SubdoEzPy1Mdl6YTrdBdxbexCqoiyY0zig9FogkFtG5J1u46c4eQ6tcBilOgWc36Z5PfUw6ft5+vBg2y2JR0C5sseZY36a2zeN5H9cMtiCWG4T7RipEyu9ti4uMOs9JipEarxP/F8yzrNfUB1j9XAWX/uAiBhFbeHRSHvHHWxXrVbtH6gmHZPLs9vMSG8zvHU1tU6c/+r7YhGpKqBAQgw9e9dA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026, at 11:19, Gregory Price (Meta) wrote:
> A 32-bit get_mempolicy() call can read past the kernel's stack nodemask.
> With 64 possible nodes and maxnode=65, copy_nodes_to_user() computes an
> eight-byte copy, but compat_put_bitmap() reads two native words.

I don't quite follow the explanation yet:

if maxnode=65, shouldn't that result in copying 16 bytes on x86-64
and 12 bytes on compat mode?

It looks like compat mode adjusts the wrong variable and we should
be doing this instead:

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6d662a9a8c74..f9a7be9f4432 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1749,12 +1749,12 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
 			      nodemask_t *nodes)
 {
-	unsigned long copy = ALIGN(maxnode-1, 64) / 8;
+	unsigned long copy = ALIGN(maxnode-1, BITS_PER_LONG) / 8;
 	unsigned int nbytes = BITS_TO_LONGS(nr_node_ids) * sizeof(long);
 	bool compat = in_compat_syscall();
 
 	if (compat)
-		nbytes = BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
+		copy = ALIGN(maxnode-1, BITS_PER_COMPAT_LONG) / 8;
 
 	if (copy > nbytes) {
 		if (copy > PAGE_SIZE)

Now in the maxnode=65 example, it should clear 4 bytes and put copy
the 8 byte bitmap.

      Arnd

