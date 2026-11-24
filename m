Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C33C606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=flapping.org header.i=@flapping.org header.a=rsa-sha256 header.s=fm2 header.b=nf0t66nR;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Jz7+1GsP
Received: by kanga.kvack.org (Postfix)
	id 57CEB6B06ED; Tue, 24 Nov 2026 08:51:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52DE66B06F0; Tue, 24 Nov 2026 08:51:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423426B06ED; Tue, 24 Nov 2026 08:51:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 140336B06ED
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:51:15 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F3ADA0BEC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:51:14 +0000 (UTC)
X-FDA: 85470149268.11.0A06088
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E3ED80009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:51:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=flapping.org header.s=fm2 header.b=nf0t66nR;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="J z7+1Gs";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of tomo@flapping.org designates 103.168.172.152 as permitted sender) smtp.mailfrom=tomo@flapping.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795528272;
	b=IrABrn+QT47m0rGQO8FZuI4qoQXp2DKBf9PL8FqbMLvuEJkc2USVK9fh8sG5BaPdUfkCag
	o8GxBlSyN67PJ7vtJr49796v3cGFsLhdaGwVIgJJTaRglwKa7lJTt46dgVVmPKV5VgzV5D
	FFWZjdpBnJJK4YSThNT4u9n/NfTfsHs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795528272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2leS56IQnLIsej7oHG8g76IpquyYA4RYdbGUPkRAZU=;
	b=HIup+fJKo9DpoRotwVu5GjZYD9cWB1xxwzpRtUKCoWIyXmtR3PRKv9Xm5UmhXF9Z08lVOg
	3dVEcoL2uNiUHXAnv4Ik+5qFAQR2gaBTi0ez1610AxOLazpAx2eu+f4+MqoOJn1TxP5qCc
	Kewtak/HDY27xGj3jtAREQHSo/ceN3s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=flapping.org header.s=fm2 header.b=nf0t66nR;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="J z7+1Gs";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of tomo@flapping.org designates 103.168.172.152 as permitted sender) smtp.mailfrom=tomo@flapping.org
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D5ABD14002F9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:51:11 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Tue, 24 Nov 2026 08:51:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flapping.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795528271;
	 x=1795614671; bh=f2leS56IQnLIsej7oHG8g76IpquyYA4RYdbGUPkRAZU=; b=
	nf0t66nRkx45Py3pEDTxf0Wkn9DTsmkoc6D69PO1HxEr8V39+k8heveqlX2POWRA
	qMRFCKLuuTTo7QtHW0zqsNyVX/Xudn48DEFTrZWzCeN6Owy6tk/gPr+s2txHYRWD
	wN1UebBYnV4fU6kR4KS2bxwwt9p8Xjrjg0PqCY0iFFPiPkgVUg/C6/V7jHfVaw40
	H/tdG6m33ZYuJuiTkjd5nZSxQ4yEQki+NdjKpLMR0FANIuMtF0XXp6dqqXgC20G4
	DjPPS9K1gFJrZ+LhOZFxxtX3LyF8QdM8HPAwChxCtwY2jUgcOxf+ZNksIjtDIqt1
	RlXT1eFikCzxUGsCD9GGmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795528271; x=
	1795614671; bh=f2leS56IQnLIsej7oHG8g76IpquyYA4RYdbGUPkRAZU=; b=J
	z7+1GsPzOwwbUcV3Mq59+PLaklhQvlyPkbv9zOTJmA1KVEFbTezA+nEbfCQT3Gt7
	OhHgNeuMq1a0IuUhFWHaBXjC1mDGmRh4eMApahBRt2/vy54ZkMN2I0aO8LOTzFqd
	EjqNW7AMhI38VzeyMHLQa4UZTxRpDAeEaHqeOEkw8TXmuLhWqrZv3l3tkOGriRyF
	ohr1Bqk2K50RnxrpItP0iEIf3B4Ds+QSI/rxE84lyny2RBMWIWh6l84mnlEGcK/l
	zZtfmxk82iBaSf4RcsyaVhsHH5dGvGpnwlUe7TZ86tUkTrDWZhyM9FPSTmrs0FZO
	opep8IiwiKTtnSj/mPs3w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=flapping.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795528271; d=flapping.org;
	mf=PHRvbW9AZmxhcHBpbmcub3JnPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:NNbX9ZQ25f29nV8YGbU8OQ7QjGpnGihJmC1cPgtp4/3TE+M
	8U98HQ9V3g/voACLzQuAGe2ZnUMk6LLH8Lg7F+A34Dsg90tcfU19Elsz1NLoSmat
	5Pmff4zKt+v0/husNlv98LZQuRCo5aKcOEHnxOCGL3jYsubXOwZ2WRgPbq2BmWw5
	9xSIgOYO6s2rf77C6xqfAw5IvR03QUlBqUAzCBaMz/+e0Bg8w5Zl8rYTjHq7BRwd
	SRJ6OCtjOLdzDqJzhU7Vjz4WkFYiXfVI/ZVgLqzKAH/IydLAeENdvlpw6Q3KlCfE
	p3f3xC1tpIKjDHBxmQA0yAx9i0KTZ+UTOH0NMoQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:D9JpEVSw3+CaR+/zAG/ZtKGfb6Hnu8TQl6NWW5YBUvw=:TpaMJqXcfF48sXXko0Y3mvjNFyU+4RRgqI8f/QjKVmY=;
X-ME-Sender: <xms:TpYFa95o8FEErg5eeixvlLNQhy8VYGa7yeeWVFDeF7Hdj7ltPkvLaA>
    <xme:TpYFa3Pkvb_JYoLbHMdzuTb6L-LOCHABhxyACmWzIo4yf0N1A4RcNb8N6lrYFFUol
    ut2yAdPAuEbZJBlFItYyP2vTnhhTo57Ttv-Uan-h-t8p6MHF3X8DHBm>
X-ME-Received: <xmr:TpYFa2E5E03mncl9WGaiVx2jUtbttJTUM1CyUc_vqFX6QmUjyB_C3qgGsgSRerag2qEyPoKie1Cjp8DNOmu-4tiW>
X-ME-Proxy-Cause: dmFkZTE0UfNEf42WvoOd8/pMDjanKDvg5ggA/8QYZRpTGyDZE2iDpDcj9KwaiWeySkT2v/
    +aab0vcJ5y0oFBP/IXHAgtWEeZHg7rPCCA5goQnjqn4feSL/EiBX+RnggQ+fl/B6gjXjaJ
    5nEsXSgiSBnnwRmmzZzQl4oidB2qprS8eFrj8Srt58NVWKLh06NrorS8NT+cXjVbczW2l/
    NA7Ym43EioB90BMmvsX/HgeYgbw001WC4rQ7tRnihNHnQl6HY3aNyG6G/B9Dkubtdy5nre
    i0uou/iVtJmT70jTxboR/OgLMHGCgnk+1WBlA5eZvYPMCxknt4qx6xMeA8AoOLmyElsEH1
    uUYKJJ3aY1Zgs+cnBqGMGh7shIBCdhNkkoYNCd74+dMKhKVODkIeqp0ShYkmO/zaj8xH1l
    Tj6CFw0taOCrt/sWGL8T5BNcFN96DOL7vQ/EhGR8A18vZO4uu7o+6acvD6DcHp1NprQSLg
    zZf1RCxnINvxX2aAxptI5kNvdgyJm+c74OdBexAWY4EdQAK/fCKnA8dW1YQhxTZym6UFw2
    Dft2VqTF7AgdGRWQ1hWGKDrjuXVjg9nFkww1x3tfoT7Rvsb6NExqNgWgGY2qW4Kwxo76NT
    DJFMLZTU1BAfOTLbK8BLMzkdGexY4wLvdh+BjaMOV3LgYlCS53i5Gd6TYH0g
X-ME-Proxy: <xmx:TpYFazRTbWOVpr4HJPoEDtEjiLJXoT9Qr7lWP_kcCc8zC1eJ4AZI7w>
    <xmx:TpYFa2TBHh0H4DSamR_JLhXP5Ja3D5bD42zQhjeOjE5vfPiB8S5i9w>
    <xmx:TpYFa2cIrioyKWRStKVarpAUCWt0Tj4JVyfHAHqZb7lmPCiiLOwlww>
    <xmx:TpYFa6fQWaVwHO7_BE6lIqfj3Ac7mLyCkrrun4yBSrMrB08LVdr1Vw>
    <xmx:T5YFa3Hj5GuoO_IfSI0PrZKYoRkEIVEEccQBLsAv_rKZFYqhF2WY6LDs>
Feedback-ID: i51fe4b43:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Nov 2026 08:51:06 -0500 (EST)
Date: Tue, 24 Nov 2026 22:51:03 +0900 (JST)
Message-Id: <20261124.225103.2152350984946270550.tomo@flapping.org>
To: mbkchelofficialdev@gmail.com
Cc: fujita.tomonori@gmail.com, ojeda@kernel.org, boqun@kernel.org,
 gary@garyguo.net, bjorn3_gh@protonmail.com, lossin@kernel.org,
 a.hindborg@kernel.org, aliceryhl@google.com, tmgross@umich.edu,
 dakr@kernel.org, daniel.almeida@collabora.com, tamird@kernel.org,
 acourbot@nvidia.com, work@onurozkan.dev, liam@infradead.org,
 rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] rust: bug: add warn_once! macro
From: FUJITA Tomonori <tomo@flapping.org>
In-Reply-To: <20261124132707.101769-1-mbkchelofficialdev@gmail.com>
References: <20261124132707.101769-1-mbkchelofficialdev@gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5E3ED80009
X-Stat-Signature: xbzptnoreuhjep56z3wunndat6m6itx6
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795528272-116306
X-HE-Meta: U2FsdGVkX1+imRT1jpXg1oGpvm+VJzy6CViFid4NMgI2UmeOYnuzJwwoUbb98iogzUAaT7pFznnJjFAZ8dXvxEa87d1xvfBLt1e50iwA/zwPirjXoWOqFvmoA6mv8+Jy1kIT8paT3yRmHROnUEgPfc5q0x0rwH4m7v9jmolD27Qogl8SF2Cx/tC7vOpz1qUawbBmajnKOybA5ZeMQ/B1xkwOffdtM8zsJgMWTb0JSk2UhfyGPbq6TSgNQMvE+GRwnm0hntQDkW/fyIAAtQaHd9tc/+WTK823VEB9KCgfNQAa3mOZX5RgJ63KTJ/NgDpXuhqsMZ77EViGXr41aEJsvO1CcVwfu7eIZhqQk+lTEiUq8XsYpvrEapi6pRWjCab1HUtfgC7cP4zNzwDjlPmNtciRSRC5lQIGfqxsl4Ym2enESxVMnvIZkP52yadEQUQf64E2MDclQY6xvBMIGg5IXAl2r+ESSLmXc6KOq9jWeNE3MouRgWvhfX4nxazxkyHzkBJpOznKXBRf7J+hZxNrnRahnkqlJGfE/bMVBwu8e97ApuHOdrUgZ9KD+D86eOZ+Y5gydUHZjOn+x/Ho7vf80qRqxmVYfyRE2glOGVMK/PCoGuyHET/Zl4Ugl+k9XIIyAmQspmrGLoBGg0lnYExUDJNQxhQWud1akPqfDsRfSyUC3y8bava7j5D/4RTUMCRstk91Qi3A4MaODelmclJ6TueEMnnvAwZpYdtCXKDxd1r4TMj1IKjc0Lyj7uaEeCPyCtx5JMmAnuHMhGNeTDOICwTeu2HoOl/UUVbsTq19Xtg6fFD4tIXIsXWmQdWVLm1ycuHRWNkS3SxThZjDMV2LjzUxPluU/l44wkBfRlxnyFSzxMBHwVL+1k+iRjM2G2hB+8KUByT7e8qcv/QkAtMcF4S+C3qA7aJPtBV+b1+kHAI4oaZoLmiE6H+l6qzVFV4k/DIIJjCSkYpY/x9HjNd
 A8Lt8dYf
 NhF5zODJLHdkrKUWKV2ipXonFP54XuofJAxLsvGcxyKAZTubc+LgbG4LpB8V2IM5kvsRILlaLQtZY+21KXrUPFsaHLLiE+8+wG3x5t3VctTo2BkgOsPvj3NU9ZvGlTmpV1rF3IxccMyPlwDExStDM4dJ14go/mdrFKQP6XTvKaMVUE+7+KZie0L11bQ9RCPTCIJHGyBT5JOJB0+2r2EZwxLGDYPoq1sCdBdGQJB31zryHELSNuUz/OpOpeFvKRtkR1pyjFH/qj11/UDxIY4ZVUF4BMTKJrhXtvxMOwv3gXNOvVlGQtU9NrnQ1ABE9S92vMa+vvdydgQjoOU5WBMujqPHMn8Zuy3tFgnKEBw5aiisIxWJybnfyz2dcHbDka+9hy6f2cCvPVJ3Il/q4GN6bq7lxzKfnfny4+5HbdcVhx9+6IJ32nO49ng29UlkyyZ9Tn2YMlzDNDdcVQDX2G2aRr01y8A/sjRxJFMksGV5vRVnwED05OmltQuSq6H4kNV291WcwW8DgxqvRiWIGuajszO8s20bfSc6a0RHmqznnSwdSA2XKKu/5mnJMxtYWZsnCdWOnR2Nv/i5LorKdGvV8jGZs59xGao5vqviA1ARTu3l9Cy7e/jPUapbjpsOtHGcVp0sdPomd+itbF6tySNy8exwBwEWmDLOWLXF09S1oFvoUW2UrWL14ZxE9sZnTMaMizipx6YjOhb+z5jQ7ruEzD6Ts7cMQZWNZdHyf2Um4mHqKKaSewDsAeTP17i4odb5wH8VxZ/KfDNtMj0w0Sm5+gzuQyI3QRuTky90SsEb2kOXw5PW56e81TVXTgvLdWLpCTPCYfXEzuQLBIkQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 15:27:07 +0200
Ivan Tverdokhleb <mbkchelofficialdev@gmail.com> wrote:

> Add a Rust counterpart of the C WARN_ONCE() macro. It behaves like
> warn_on!(), but additionally sets BUGFLAG_ONCE, so the warning is
> reported only the first time a given call site triggers.

C WARN_ONCE() takes a format string. This macro is the Rust version
of WARN_ON_ONCE().

> The macro returns the evaluated condition, like warn_on!(), so it can be
> used directly in an `if`.
> 
> Use it in Vma::zap_vma_range() to report an invalid range, which
> resolves the pending TODO there.
> 
> On configurations where warn_flags!() ignores the flags (UML, ARM and
> LoongArch), the macro behaves like warn_on!() and warns every time.

C WARN_ON_ONCE() warns only once on these architectures too. I have a
local warn_on_once!() patch that does the same on all architectures.
I can post it if needed.

Also, this patch does not build on UML, and test_warn_once fails on
x86_64.

> --- a/rust/kernel/mm/virt.rs
> +++ b/rust/kernel/mm/virt.rs
> @@ -115,8 +115,7 @@ pub fn end(&self) -> usize {
>      #[inline]
>      pub fn zap_vma_range(&self, address: usize, size: usize) {
>          let (end, did_overflow) = address.overflowing_add(size);
> -        if did_overflow || address < self.start() || self.end() < end {
> -            // TODO: call WARN_ONCE once Rust version of it is added
> +        if crate::warn_once!(did_overflow || address < self.start() || self.end() < end) {

Miguel said that "Erroneous Behavior" cases like this should use
debug_assert!() plus pr_warn_once!() [1]. Also, the C side uses
VM_WARN_ON_ONCE() in __zap_vma_range(), which warns only with
CONFIG_DEBUG_VM.

[1] https://lore.kernel.org/rust-for-linux/CANiq72=tKVD13GD2Bzmt_LnC4SiOX1nkHQPcz2BS=P=b23e0Yw@mail.gmail.com/

