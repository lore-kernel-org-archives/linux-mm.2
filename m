Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98C63CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 16:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB456B045A; Tue, 20 Jan 2026 11:31:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2D46B045C; Tue, 20 Jan 2026 11:31:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF776B045D; Tue, 20 Jan 2026 11:31:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA7496B045A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:31:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94E47BA87C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:31:18 +0000 (UTC)
X-FDA: 84352882236.18.33BF05A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D939B4000E
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:31:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lllm8gJK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768926677; a=rsa-sha256;
	cv=none;
	b=c2t/EDeNTUi+4PeDiXmcuS8oISdZy/IBG4uiNW0qDxOR1w6iH6gtvKgnqWGv4cYRpyHhwR
	thcGXYQytG8RLG9zjxhsvTRJuwxDHWP0uBuj/TSFBWWoKCtcL/2YnrESjpco/P32L5AxOT
	4K091ElDr1Xy+Cz08eWws0fq/0QwbPw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lllm8gJK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768926677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9bvytCEld5G8KAmP/gN8sR/WGKE3Vrlr77tW8T8mGo=;
	b=4AmW9UbZAO0vTUw9qn++wG5sUk8+N3/Mj4RzcakDl7Y183Wm0vC7Ho+oVaHSlIFnh8D/wT
	jEyB7CeqxksSH+rphNPWfl9V5+rn+t0YD1hBr1ZutQ1D6WYjSqcbrvQlQc/zUnBQTyt9qo
	EkmHhmGl0ghtI6J/rADSgd+X1cPHbDU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DAEDE40D88;
	Tue, 20 Jan 2026 16:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E42C16AAE;
	Tue, 20 Jan 2026 16:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768926675;
	bh=b+DEzrhzQLEZaXZekFtcaQ+EoJRPMgcm+b7GQK00jzs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Lllm8gJKsKXKIIbGa/8Mhv3Frwq887BG2Yh/JTKwz3Cs30xtnoRwE075kz3xMtERX
	 8VbtdWkRd8wwxP5YPBII0c5+/TxFnfnoWO5J0VWK2z1LEJcN+/JVeQpb3DHWY6LEET
	 OzS+5sAmZKniDDSXOJKC5RHqITIbB9bFf6b9yt5/FRwBrGabs4g0INX0mMVFG/gkfr
	 FFDWmgC9EXOvhj3znC5tjScmOclMBI2vArmTbFQ+2FX3nYuWFV+z6PgZoSZJYvHrPZ
	 Uw6nq+uPcpUyOkMuiF0eD8lwHjnxJqFJMQXhWOb0cZYZrk0xbG37uYBtMWZMFQR01U
	 heAP9PWzXct7w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Jason Miu <jasonmiu@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 6/6] kho/abi: add memblock ABI header
In-Reply-To: <20260105165839.285270-7-rppt@kernel.org> (Mike Rapoport's
	message of "Mon, 5 Jan 2026 18:58:39 +0200")
References: <20260105165839.285270-1-rppt@kernel.org>
	<20260105165839.285270-7-rppt@kernel.org>
Date: Tue, 20 Jan 2026 16:31:12 +0000
Message-ID: <2vxzqzrkckkv.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: D939B4000E
X-Rspamd-Server: rspam06
X-Stat-Signature: dg9p93xg5moudhiwqa6o4yyeocig3mwt
X-Rspam-User: 
X-HE-Tag: 1768926676-541549
X-HE-Meta: U2FsdGVkX18K69K5q3jePKs1CMS9n/faLFWP+0+NwOdpMcClHTAf24TWZ2pz29VpwIKs+nhMwrPhB2+g5JlmtknMpoY+WOWq9A1OVoP262vTX5U23kII1P2quf2JzerX96VSsw0qW9RyrvlHAxjrEgH6rughsnOjVYKfkTmdN0HQcwsSP3RMn3Dol57ur1PFqch2VNUyMgRBYK18a4JDAjjjA6x29rNpprcA5z7S9f8DKZck2EW0Yv40zgRSKT57cTfo5lHJuUl3TO7Ir1Bl8+MrRmxqd1kSQKRDvygJg2Qrud47/oH2ke03rxer14YzPL6EFdtNYYcsOLqSBvsUZqXUMyaRTdPHllu0Oz+4rLMRPsvZ+ezhNdVpPC16C5gAZr1gqgDPCGytEHVCVWcEYRAkD5vkXnQYoIZlsSoxf70JVam8RydANYzH2ERlpUVyiFvKHsTGX9mun+gg6jiWl4CddSDEkl5mygY1UIWQpwxAv98ATq9Faf2OwvvuWcqV4pyYVkfsgN5Ia9xsg05sroOM6oIfmGEytKi/qTpoza4lQUqxqKt6NeEq3hAuJNcFMxXa3NvvMtUngKejPN+gMS7W6PEjFC6MmPDac4QPollrSMT3Lwn0vNoJOr5ynjiMaE1bctumznDlAvbT7kUkYGblEGcIlgOA2I0A7R6dWohyh6rrHhsBTuG2nrwssM82MCAfneVwtpTytcP/n3xbnmeed8VN2d0QMiPoJumAh4dNz9P3jBeDBkCCge/8v0HOvPbB2GHNX02ShTHBBgaoBhqWWBZ2LcuknrCaZMIHtMuck+x/x1PUtC2muXuc2Nd01O828Dl5M0LU5r9iRStE6haibdgW1LU0MewDsDOYGvJm8B4d/LF+oO1J4MSRpTRKoMDDySOs7c42+CdKSocju/GtqY/0Ceh8ydxHugiWco6WnyVO1liGQps1ep1SH1YlFvX+iLdfNf+XTu1hFdA
 Vwd/gylH
 6toumrwMUGTOVZczykpyNuVCPIPKg8xgz80v4uffcufs9wsRGlQjqJ7YG/2t4vv6zVnB/nKLNtFQx5cLPc+BbJIt0cMT5yLwZq2ucFjWUWtaGtzr2QBlPy4h+Q+fHFCw8HFHVwJjR0HcnLhgNQzjm19LFk7RqtMy17ZDvkOU+oIBbbf6/L0gC60JvTiJdJy5jdQG6+XlmV+3vYudBG4VNnsqHPQf51ikX4QDMR4X4Bus+Hxc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05 2026, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Introduce KHO ABI header describing preservation ABI for memblock's
> reserve_mem regions and link the relevant documentation to KHO docs.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
[...]
> + *	/ {
> + *		compatible = "memblock-v1";
> + *
> + *		n1 {
> + *			compatible = "reserve-mem-v1";
> + *			start = <0xc06b 0x4000000>;
> + *			size = <0x04 0x00>;
> + *		};
> + *	};
> + *
> + * Main memblock node (/):
> + *
> + *   - compatible: "memblock-v1"
> +
> + *     Identifies the overall memblock ABI version.
> + *
> + * reserved_mem node:
> + *   These nodes describe all reserve_mem regions.
> + *
> + *   - compatible: "reserve-mem-v1"
> + *
> + *     Identifies the ABI version of reserve_mem descriptions
> + *
> + *   - start: u64
> + *
> + *     Physical address of the reserved memory region.
> + *
> + *   - size: u64
> + *
> + *     size in bytes of the reserved memory region.

I think you should also mention that the name of the node is the name of
the map.

Other than this,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

> + */
> +
> +/* Top level memblock FDT node name. */
> +#define MEMBLOCK_KHO_FDT "memblock"
> +
> +/* The compatible string for the memblock FDT root node. */
> +#define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
> +
> +/* The compatible string for the reserve_mem FDT nodes. */
> +#define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
> +
> +#endif /* _LINUX_KHO_ABI_MEMBLOCK_H */
[...]

-- 
Regards,
Pratyush Yadav

