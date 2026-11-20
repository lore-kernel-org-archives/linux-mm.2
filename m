Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D78F606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=lrd65nOG;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Q8uM6mhI
Received: by kanga.kvack.org (Postfix)
	id 656B06B00EF; Fri, 20 Nov 2026 05:17:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606B66B05C9; Fri, 20 Nov 2026 05:17:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F69E6B05CA; Fri, 20 Nov 2026 05:17:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE2D6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:17:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1F761A0E9C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:17:06 +0000 (UTC)
X-FDA: 85455094452.08.4B76094
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	by imf22.hostedemail.com (Postfix) with ESMTP id 67562C0008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:17:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=lrd65nOG;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Q 8uM6mh";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf22.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169824;
	b=iamAE4VRdd+fsGMvpotb1UKPqhImTPSAuHnYXZi8TpF4OlmS8q51VoEiHKgAiTRHUX71V6
	wWpNCKtoDyqvnm4GkQLHdbQh4S1M9eIknSg2kQqlovF4IEKYUrXzXty721pQnY4HvWB1zs
	9LY69HBL8zQeflE5LYwLdnjUNziufn0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BuXhlSKg00a4CpooMZ1asDKzuO5wnOZJBMwl0XnHxMM=;
	b=MaEyrN1esIh9TUaJcLdqCDglu4c8YkPb1C3QvmaUNN4Y/ns05HXvMbQQ/OsV3g/Fbde+0F
	BLY/hZcZklXeyKTeTNXsucm2GQwP7pvKJfCzM7ITbj6euKNi90raxmYA+gkSI5Xc047rkL
	3ynUix7vMuX8PwkMhFx/aJLoBx36Ud0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=lrd65nOG;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Q 8uM6mh";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf22.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.stl.internal (Postfix) with ESMTP id 7155F1D00399
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:17:03 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Fri, 20 Nov 2026 05:17:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795169817;
	 x=1795256217; bh=BuXhlSKg00a4CpooMZ1asDKzuO5wnOZJBMwl0XnHxMM=; b=
	lrd65nOGQ9AxiKwcDko0U7X04VpVb1LuKQt1QNWwZt0YHrnppMe8HKr/arGQ5Eok
	GJaoAyJSZjbckbedw7e1Oqclc2g1DtLaTVDhZGlfXkqste6iWwZ6jjl0M+qwOzhX
	jGnRgCvEoMzqHu75ZG8aGjG2xm44k3ht2Ct/sxNZ33pxo0nPgPSa+ijt6OPaBafx
	NqxpaxgqqZkUCXtLV63vB5CY5Te6TlDhOVAbI+rleV0aWuvVzMwcx/Veo6nQNQCs
	AqGnlQeOcNNSTlMBl61Wc8t8vJojatC1pSaCnSYJpBxIgXYx89D7QileDGMTyz08
	5IaSgJMhIzg2lqw9BD2t2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795169817; x=
	1795256217; bh=BuXhlSKg00a4CpooMZ1asDKzuO5wnOZJBMwl0XnHxMM=; b=Q
	8uM6mhIZ+PPM0igHpEfaxmK2pe/kQKgPu4mzjzvu15JZhYLNgPEH7gSBXoS0naLN
	oQaMGx1HlklWuW+jNZAisHdjSQPeXnXA9qc8GNSvyqSOSYqAEnr+MTErHWkDYWa8
	A7KrK1MybzJNtP5/1eeSu7smqdqBNE4daJLL1/1wsJBuLSzzJTXXViBZlMfitj5x
	hE6596YuPnlR/D6pi8sQhAUXwov4eYP06gAXWiuVaCgC0KHLUHecu8QBytE1BymL
	rkCcZNb9QRAQ7AFbkOvXisI3uBFNuHFoKMIW/d7IRcBfXCpnhVI6Gy0UuOzhWSMl
	xxujL+gZNs3dVABK/KXjg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795169817; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:HYI7azewRJxcKItuYkWpocONyGDvp0IpHDUB64zTgnOnsC3
	a4jwG99ivBxZ8QcZn3Kyrrn/9ASNoCeNdfPUv3zC5HBsNY3PSrN8ia8J2nmRrfQq
	0s2KgAMUyhMsMnytWsxZ2t/Pd+kYDT1FAsLBYnldJSOaZHE4lL77uEyqWLTf2Squ
	527WZNEVfNgtSrMCzzJx+IUHQ25cvZhMW21HrDpLa1qhIB8IhlJm6TvYqWyed4Mw
	Y3U3xRZtDoLZ1siJGYWNdq6UIxkgeeM83VVjHQ6yN7+yhNFr8tPE5+YnnKsGoknc
	QLbtGiQ4exAoBnOnvWRLRCbvRer+IkLRJ/Q+TYQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:zuSsEhmCwr6Wvsb9X06BQFozbRPwmHJVyho9pvXTxSo=:mGu+cZMGELOH0bYyds92Q644h116pbc8B12xMlx7qxQ=;
X-ME-Sender: <xms:ER4Aa7lO5umD3sr-TKj5kNGsKI8wBBtS2M0-dcWs6QtR_INEScQoog>
    <xme:ER4Aa5qO5F1L2_61uu_MvkmwxazML4N7Mc_FqW7UZMVVmx1YZDxLOyY8OYVxafOMj
    iVb3ctbJB9I15cT59eZjmavKzKCG0gdU7o4-3haWT49Va9jnMKoAL8EdA>
X-ME-Proxy-Cause: dmFkZTFsqBHJi/SORwcvKmFMVQF2oUrONn+po8KdzOVlSsbWms9cCSDOyBdd56+KzfUPQU
    2X42s5779mPNAiTMVFZUPGbqhM7epcvvR2MPGjDQwB7R37oOEK6tyVEgkAL7/q+/ahPVap
    NeH2VcC5R7jB0RTnG1Mf2Dp3losR7T5ymz+62cELWGnddyd/9TmS2hLGCCPFOT5LJFqs3N
    XaIpXbn0r3peZdWBHWif89mdsRbh6/6AtlmeDrI+6RoG8+ZTrrW7a7OeLDd4lvsOR9buT0
    D74Tom2Bnx4DC4bbrg8uwpPgVgjhsMivxjn6icPGINxpGvShklwxxvQK4VaHQFSiEraZMC
    xETAMYCZkJJQQ2961g2sx20Cgo3KT/REaHIBg93dlyvDPTYn4ur1skahcTcN0G+xo4lB5h
    ajQycmI5rJa1jJ67KtVQhTtLu/PyG7KYa5VQdg61bRYFylTI15GsoRWoLB/X0XWajtTaPT
    GZVkANeDrHXq5VC3N1G3W/KVvRZbcd0BX6oPQAVzlRC4virYfMcesT7+o5KWxVJiBRM9r2
    D49vQbnnm5iL8fO+nwGExVlvRBgp7+XCG7+/D73eB/IzBx5Iw9MehaCYHZyj9FGkVt1139
    Jbt7Gy7yFQiC6enD7KLL3y7PkgQIKWNIgd5bFoqlpGFqchPZqz9/JPpVpb6Q
X-ME-Proxy: <xmx:FB4Aa_gaDQRwBXTEb7PnmRSAAfHySWI73uaIt3LlMbF_hgd0Sz5JYg>
    <xmx:FB4Aa7dv1ofwPwh4m8S7HRxw00z-m5ye4xEC11hBQoYFuIX1wKaqIA>
    <xmx:FB4AawIAi8H2OVdVYypI9jeNC4RSz49wPwT2tyNluL4HA1rxUHiLZQ>
    <xmx:FB4AawlAszsQNztJyLAKB2253IZThabYUEdU2GIy-SBhBfVSHiV_uQ>
    <xmx:GR4Aa_RsJ4-fSKP1fJY0RpYuvoQ3kE2ZxFN9vRS21E7SA4LIFs585KKW>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 600B132A009C; Fri, 20 Nov 2026 05:16:49 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AQsIS8mXxcAZ
Date: Fri, 20 Nov 2026 11:16:09 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 sashiko-reviews@lists.linux.dev, "Arnd Bergmann" <arnd@kernel.org>,
 "Gregory Price" <gourry@gourry.net>,
 "Andrew Morton" <akpm@linux-foundation.org>
Cc: larips <larips950@gmail.com>, "Zi Yan" <ziy@nvidia.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Lorenzo Stoakes" <ljs@kernel.org>,
 "Brendan Jackman" <brendan.jackman@linux.dev>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Jackie Liu" <liuyun01@kylinos.cn>,
 linux-mm@kvack.org
Message-Id: <45a71e8e-0c8c-4b5e-96c9-be6f2ad0e364@app.fastmail.com>
In-Reply-To: <3b00e53f-b4eb-41d4-b3e6-791660da3342@kernel.org>
References: <20261117211635.2472067-1-arnd@kernel.org>
 <sashiko-outbox-221983@kernel.org>
 <c420ec17-b297-469a-927a-85934a05fda4@app.fastmail.com>
 <3b00e53f-b4eb-41d4-b3e6-791660da3342@kernel.org>
Subject: Re: [PATCH 1/2] [v2] mm/mempolicy: fix copy_nodes_to_user() for odd inputs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67562C0008
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: hw6krangtg63tdc64jq4bye47jd74wd3
X-Rspam-User:
X-HE-Tag: 1795169824-765494
X-HE-Meta: U2FsdGVkX1+nEM9o3mNTNVHjnnXcVfBqPzkEmjzeuAu+h0ucqd5TvlCVDEUQAHD2+6V6A0vPme8+XZg00s3q7fUQo7NbsWbLyToJp6lanppyHcZO+ydntVEw45Kv5nqExnnokWayRPiJoc12V8c4IH9u4NnlnhF43j6lDymbrh1CzsH7blJefkKgwz5xMcnFw4zulULL1ejCUctxi+xlLlm/rQqUg+PIVHxRmTj1IyCKNsFFGeQP+Y16AtqtaPzzgYQxYSNmnq6bUnA2ahHipRIWL489/Lx6wxO/wub+AQRGr3JsViKGpn+CwOXpWxb4nFknzUL5GdjsJE1P/vhsLKJHLPbceVhPtzWB0f8tGL90oasQc2prEyKpaHa5uskEBpwtnFkdMn3cS0uUHbbzzrpVqbKkgPjmA3ZpF/VkM/AVvGMDetuoTQ+3om8aflLRhdanRvpiTXnrDGTEM8oZtTQtrX0igw7ifx1x6CjutPIgGx29n16PYEnRZXlLnHbR2hWw9ryJJCCAoBwKeVGGOVMN2jOXPNTG+ZhZmsFBVzxP3hLf9gutH69u7pLC+/5uGNIeDdvFOgWLGGpwJHmh4C0IVfVLezKzftvORCwFS4H+UJKH1KpZKQz+iwnJbGwsSg2ycmfsICEl04+IJvQhgjSsH8msVL+YHg6mHOW6SG/Qx4qG5NJPJqoTjPfphOfmMI2eOeMXK+N91pq5+ukDcqy16BoR2x61PWSo9OAybpILSGkcMwoCF9YbYfiTQ/F+h5qYLalwnfaMGsWYON6s1hHqIQqLR8io5163KTlYXtAXLWAmKKuZHYOPh1Hh+pw4rpIM0u6X5fA7T66og2WQf9PUserMFzWmcNlloZkhLreahMfkVKlnivI2SsxkzdoqTQBEHbz2QMsKaYkywjpa36Pr6O6JlHc+h6DDrPHyItu8Ry0OUEGO1QJ2dPz2X4Q99fS5gzmTu8953idbW9t
 dbHBltSU
 iENxFi7SmP+12iqEE/46NB//4FV1yFfcp2y49WgW4ntNGhprk9eJRRmTv1WshEFAe5d63tPTXJjFIW2XFPuDM/4+fRSCyyZG/WYIvS1Yk0CwQKm3oUk0z6Ug41frWKO9SGjRAxzrrZt7lszAbzRJGvUaPTaW1QC/3EmtbxLcFL6r297ZPmk+AuriJY19tn47S0vahAEy676rfvWxLX++zlXLIkEVdE9JfSJTwT8fwdkLFapUCm7gpRhqh7mCIjfpe5XgNtLMIzEeBX2hjSHzJYjEJRy/7DHbGpKyjo7D9542zjZDd/5zyu09y9v5Jy+/BZWSc0ICALWdEjhw4+7x1zkxAIJH86qt8v+fEv7GWBPO1of6iyOyilqMdE0pETH1a/RkC5fufV4nEjEGXuirt0pRaG5uWv3hGGLhttdlBAKWiWkqOTFLxbirMtmyvG0Wohp6MM38UVN7McTIMVgYh/MJbKvW3bXixAyhLQ/DDGOcd1jhajP2I1uL7u/yX8uLyQx0Q/yIXIA64+kWgVn3C2BlzKnBhJJP/95ubu9l00X8phOPJQZR6dt82mxk0P2spmQbahbWn9pt9xtep0T85V6C8qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026, at 10:55, David Hildenbrand (Arm) wrote:
> On 11/19/26 16:52, Arnd Bergmann wrote:
>> On Wed, Nov 18, 2026, at 22:16, sashiko-bot@kernel.org wrote:
>> 
>>>
>>> [Severity: High]
>>> Does replacing the compat nbytes assignment with the compat copy
>>> assignment leave a 4-byte gap in the userspace nodemask when
>>> BITS_TO_COMPAT_LONGS(nr_node_ids) is odd?
>>>
>>> Without the compat nbytes update, nbytes stays a multiple of sizeof(long)
>>> (e.g., 8 bytes when nr_node_ids <= 32).  When a compat caller passes a
>>> buffer with copy > nbytes, clear_user() zeroes starting at mask + nbytes
>>> and maxnode is clamped to nr_node_ids + 1, but compat_put_bitmap() aligns
>>> maxnode - 1 to BITS_PER_COMPAT_LONG and only writes
>>> BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t) bytes (4 bytes),
>>> leaving the word at nbytes - sizeof(compat_long_t) untouched.  When
>>> copy == nbytes (e.g., 34 <= maxnode <= 65 with nr_node_ids <= 32),
>>> copy > nbytes is false, so maxnode is not clamped and compat_put_bitmap()
>>> copies the upper 32 bits of the kernel unsigned long instead of zeroing
>>> that word.
>> 
>> Same as my reply for patch 2/2: no, this is fine as the size of the in-kernel
>> buffer does not depend on the word size in userspace. Copying the extra
>> zeroes from it is fine.
>
> I'm not convinced, especially given Gregory's test case. It's all a
> confusing mess.

Right, I see now where I went wrong: 'maxnode' is adjusted down to
the nr_node_ids, not the number of bits in the bitmap. So my patch
was wrong, and Gregory's was correct.

> I do wonder whether this whole function should be thinking in terms of 
> bits to make
> it easier to follow. A bit more churn, but at least I can understand 
> what is happening there:

I like this version as well.

   Arnd

