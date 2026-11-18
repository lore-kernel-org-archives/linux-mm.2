Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45987606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=hY0cg1FT;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=NdLzUikL
Received: by kanga.kvack.org (Postfix)
	id 6CE596B00EF; Wed, 18 Nov 2026 04:36:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67F156B05B1; Wed, 18 Nov 2026 04:36:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546DE6B05B2; Wed, 18 Nov 2026 04:36:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1536B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:36:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C81112067E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:36:25 +0000 (UTC)
X-FDA: 85447734330.05.557218C
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf31.hostedemail.com (Postfix) with ESMTP id E2A0C20006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:36:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=hY0cg1FT;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="N dLzUik";
	spf=pass (imf31.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.149 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794994583;
	b=aXZDh6RI+T0OC/asDLBjPx3mySEJuhyijDMecXl1agw6cVzpIW3FTsxhwjqKL8M0K4wiA8
	3u0Ejp4UwYtGKfvBUPWDjqC+yfPjWPZRsiVoStnWVBPHL8ViWN/GILURcH0c7ee+BIeKB1
	aG5Q2dcAfIq2hOmTGycFl449uuh+RK8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=hY0cg1FT;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="N dLzUik";
	spf=pass (imf31.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.149 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794994583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2mQBQ33z1KsDMc+pR3S0sbDWqcmwvNnw98/YbWY6Vgg=;
	b=QL4crRLV98BxA0CZjG35MdWi0Mxl2f3PYo1Tve0qmc+eBaFFeuInoQOBnTpAsfvpSWaDTp
	CxIHwQW1/duzHYGv2EB95fa23P/RgZoEfE3+C+bPXiBJdtAQMm/5gDu4TiFK1BXp1o+Ob7
	ngqXStBo1uPxs6Bzc+6vvbOVK1XIIxo=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id 0EAE6EC086A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:36:21 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Wed, 18 Nov 2026 04:36:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794994574;
	 x=1795080974; bh=2mQBQ33z1KsDMc+pR3S0sbDWqcmwvNnw98/YbWY6Vgg=; b=
	hY0cg1FTH4racKaWvIOlEgV+3ibm5cdfC4arsYwWM50paSp+cfgdQHDyiQTGQyLJ
	CjDavGnktywfqjHoUQW3zTLD4taZwcUoizQ8/SG7wbvyGfniuNWiY5UgClE7OevV
	6Vg4ROKSIeJqcTMgs2pw0Z+xAhB/0eNQoFRIMGEwTV4m7N2eDeCpRCJ1BTw0Y3oR
	lM6oDDZuu3BwG1FaczOsFlo3nmi8hDlUVS/lxc7Gl7nrH+c6rL4TziFbYxcQEYo0
	5niQgvMbAJAVhuq1oJNAwN6H7EZCOIgNBoXEFHfnVm5IrotI8xml01Je7z4bylfI
	YxxP1dillPOEy53JeGHOiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794994574; x=
	1795080974; bh=2mQBQ33z1KsDMc+pR3S0sbDWqcmwvNnw98/YbWY6Vgg=; b=N
	dLzUikLgmD8Wd4XWTBGCKPGlUOsIjTMvpGUXvoRFPWkApDtOPU1m7bw5PURRKry2
	Q4PdQqN8a5X7dVF0iN9pHNrRWkfOXb1jFwxsJfUPgVcbmJZqW2iUKrlgFsr+0aCJ
	o4DSWYEib1vX9isWUwz//sBUEloHNvzhSF0QbEhW10Gr6Dq4fS2mSlw0HdH2fzkD
	qB8SlI1rCYgTfZYnpBLxiQwBHXFnj1N8ameYPh/G7aLAAWr/3TQiEGF/NvpSCmVL
	14eWmQ14GKDwrHnIrtq8Z6lMa9yujxFNdx0bSqPQ7agR/T0XHtncFivvqFpQQndo
	PAOQCcRPtA0qUzgmd/Ljw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794994574; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:WKS1/Ll/mbCPjhcuzvTZh8UOzOOzX+RnBlADZrQHasNMeHq
	/rdQyxOZunwBelgfXF3kk/YMb3UcViElXA+TnMySRWbuvRJaGvhbh3yMFZH9iXKO
	qeEMGjB9PPmcU9NUmW2LBDvr8x+2ehkz1sJFaalcjJjZ45U1qawma05mnCM5nLXc
	Nl6t+ng+mTHYb2qs0IBm+TxVrdHD0yg/B8HV6b+/9TkB1avfpRCCbPBvMU27ZDcH
	+4ZN9bYQWAQYRbC0ftoduKXuncOJp9vRBkPir1IkyKgibV1AqTiW9qXTu/Xw4iIR
	Do2CPwp+icj7Dj5UTTpZ3qJt4fuxi6IL5ho1gqg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:HfcOAgMRSlPfnYHMHGFg0O2RHYquchhWXnrzcd8wHLc=:W7oE1wJUH7Oalu3XxlvPqzvmDnopE3WD1o/1CV0Acr8=;
X-ME-Sender: <xms:gHH9avxbCxN3Y3HB-wNWWryXtadEGupHObkc4JNEJ6KcjR8qnZul1g>
    <xme:gHH9aiFmWYACe2eQmcXNmntK8gZzRRnmLFi2ZinPpGbQO89Vf4iHby30Wtz5rpQZC
    INlQOLWPOIfmV5BlexJdj9rgVdA3mgIwETSrImeuOvbAGDKoh7BNm4>
X-ME-Proxy-Cause: dmFkZTFiiNU7tN5BUspUavcyXaAT4wfainQ9khtZHy11VY4vR/s9XAWENoGv/Y9xJ4E//7
    jGs42O5jEYzUcCI76uMc6JEsCNl+iSvu9fvVXL0l4Y+FHf8blz9Ynkg7G5ycV9Pog4x+Y7
    8MXenFO9n+qdiX4DQ8SfDyhstTLrIGCcaVAd2J89Ic4kUKc4rMsRhOBaSbyFnQ/tK+xNQK
    nT7gGkMIJ7p8v9Zvpcdw3EESg4CmYwnbvDcoDItsNGbMfXj7m4hJUX7c0i5+FP5h0y3JNC
    CoFr7QmIpXPHs1rhvjpqVJl3eLsSrEfnQY0YJMmp4LXCVdEmT5LJGpWpMQBYZJJ3Qfb0oa
    bS5l067eLegm5VBlMGKkcb14np2cHVT+6gz38AADe0Wn2/eVODGdBH98M+kFdG0N1BGyZO
    Pu0BTbgMVkRWdZ2yDPgJnzyNOcFznrOvZwIF0OiILcRdLymlo90NpAGzpBPPCZd5F4TUI5
    SyjnTZIXsJCbeKk7C97GuJrxHeqFXrB7pgFR+o3yLKECAdBS5G0PgXTND4GgNVqz5VlnPq
    MJVPwuzo6CIq1siiETenKIOFgPAI/sQWgK+8N65g/qtwKWfyxidXFuXwrhlPH1EMxtX/1G
    e+X72pKC1queXZKiqPfoMZ3C1WVLkmGi7KBWQjYioE1bop4DthPAOCAjrcXw
X-ME-Proxy: <xmx:hnH9atFDpi2ZO4seCM-4CSrPlD_Yo0TwxdCoiUNw9l8GkdAf4vmokw>
    <xmx:hnH9akpKXjBXHOmwY2AyPz1Wy_zdrMVP2ZXQcJTrzRNC_PVQofrpfQ>
    <xmx:hnH9at167xN61Zsk1DGewG95H_y4IOi0AhesGlWeh7yuhuFJ-vMC4Q>
    <xmx:hnH9agD0Qggwx3gpCYAl6vH3MiDorHZLOHONMEur6LztWO2Yiyxb-A>
    <xmx:jnH9aunyC_X9Zb1GExHtNUevXV7MFO1URD2orrXZqckOTEMCfIs7cNL4>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 3245232A009F; Wed, 18 Nov 2026 04:36:00 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AOQI5y7BV9gB
Date: Wed, 18 Nov 2026 10:35:39 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: sashiko-reviews@lists.linux.dev, "Arnd Bergmann" <arnd@kernel.org>,
 linux-mm@kvack.org
Cc: "Andreas Larsson" <andreas@gaisler.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>,
 "Jason Gunthorpe" <jgg@nvidia.com>, "Linus Walleij" <linusw@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Lucas Stach" <l.stach@pengutronix.de>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Malin Jonsson" <malin.jonsson@est.tech>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Michael Ellerman" <mpe@ellerman.id.au>, "Michal Simek" <monstr@monstr.eu>,
 "Mike Rapoport" <rppt@kernel.org>, "Nicholas Piggin" <npiggin@gmail.com>,
 "Nishanth Menon" <nm@ti.com>, "Richard Weinberger" <richard@nod.at>,
 "Russell King" <linux@armlinux.org.uk>,
 "Thomas Gleixner" <tglx@linutronix.de>, x86@kernel.org,
 "Borislav Petkov" <bp@alien8.de>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>
Message-Id: <0829a44d-fab9-439a-b80e-4791fc72ba0b@app.fastmail.com>
In-Reply-To: <sashiko-outbox-218801@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
 <20261116124832.662455-7-arnd@kernel.org> <sashiko-outbox-218801@kernel.org>
Subject: Re: [PATCH v3 06/10] arch/*: increase lowmem size to avoid highmem use
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E2A0C20006
X-Stat-Signature: y13oi4jzzew5ji9xnu6koococisxdbsp
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794994582-802712
X-HE-Meta: U2FsdGVkX1+w+oIA6NR+7nMgfZXhBMDele340Hv65d5bhWAdsb/x4EEFPeQVdxHB1WMkzdf5P7JmYM5AtHaPQ58suzyEApxVHCUyrhAFdwyxfleqKrKzcniaxNOSxOV2XKij4ULb/7QIDxO3VM/FZdHngWdFphafG4KmsZR/znLo7pAsnfArcht3+2obOZZKjSLo3Y9tIxoD1zc77P6RngLEIUVYdAlP9+cHl8z3cEhU7wisDmXcCGDjWnUDlFlnJDy4Zxgr11T31MEOVt7y1/Q8qawc0LwPzgpYMg96lwMsCWGON3sqOpb3YQ8Wi5c0Lq/q+/oAWX7aGiX8X+JQceSWDGMPZQgzC4wWYLOkBGKE4UCpOCpryIUk8OTg1N5WEkePe11pSh5kHH5vG4nP8Hfv75k43AKdQ9t18epYIVCUMgQtaYMMW7D3DdpsQmLrukvKNVUeyKJ6Awfrw13wck2XMtdDaLPfQud2tANcWYhqCDgECI4+lMx5kioqmxX4fHeXH1vb5uadClSdE8EVxALDRsfYuJjgFRvoXywS2ztCw3C4HsKFgsMlIoPZXUwrKZzZer0KoYCVC95IqdwOp8zLZ/RfLkiDb1U73FdzxrRIiGfsTcnqmNGE9cXPTEo7or0lObuQ57V5WWt7gOwhqJO40HqjCJCLjjVD+s6iCRY6aKZNqM/PgUtygy8OrmLBzRKgIndEqfljRyem3bR6YDGLbfrKBUjCifl+vAVUX4gvCgCN2zTJGA67DOZwWG6ci910XkAEtEl+f6ma3RtBo8wTZD8f9uJd2hDODQhUBVOd+avHW1JeIyea6JzXhXxUUEhpnWN/9rpNAySylf6qjxEUN/0Y5tDljfVCDnJenDTQCykK/DAFbMJKpm4OjYG825p3/Cw1cUvoIKdyWDT+FXy3sPMGDV7By83RinylK50GeYyHk5L9peH2MmyP5vPio0e9EGOQFJgp1US0JPM
 6AU44qGA
 FdMi7BxFcr49bYfd98D439xmSTip33crnwE3K0o0SPAkc4WJRfPgyYQ93YzmUbxvVMPPk7p4Ck1v5ZrzASwFx/stYnmweVv4i5v3oVuJUlsjE0m5G4Jq0BE2mrtmZ4e2FZ+JGmWXgVEccTZJg+oW6VJNxdotKnIHkNrGh0N9giZzSofLJfyqhdaV796UiqvtrVDmA8urcFG/j3bE0tWzo2ZMIQ9A49PYMn/9HtHhSl5AtjI0sCiC0+WA6Ibf5sDM8QtocDKv1IvCsKEsB+7rlxUVa8MTZq7bJH53IqFBCend2ELUQc4T6uGiAzb3V6tH4DdyVp9miEFZFb7KO33wZzolcqBsaFJ9pqHldZFX2d2wKXU9JCo8+xM2IV62xmITNsyr+C/txmRYMsN8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026, at 13:49, sashiko-bot@kernel.org wrote:

>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index c3b6cd6556069..1eef831faf3a7 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>
> [ ... ]
>
>> @@ -1207,10 +1211,10 @@ config LOWMEM_CAM_NUM_BOOL
>>  config LOWMEM_CAM_NUM
>>  	depends on PPC_85xx
>>  	int "Number of CAMs to use to map low memory" if LOWMEM_CAM_NUM_BOOL
>> -	default 3 if !STRICT_KERNEL_RWX
>> -	default 9 if DATA_SHIFT >= 24
>> -	default 12 if DATA_SHIFT >= 22
>> -	default 15
>> +	default 8 if !STRICT_KERNEL_RWX
>> +	default 14 if DATA_SHIFT >= 24
>> +	default 17 if DATA_SHIFT >= 22
>> +	default 20
>
> [Severity: Medium]
> Can the new default values of 17 and 20 for LOWMEM_CAM_NUM exceed the 16
> hardware TLB1 entries on e500v1 and e500v2 cores (CONFIG_PPC_85xx=y with
> CONFIG_PPC_E500MC=n)?
>
> During boot in adjust_total_lowmem() and secondary CPU bringup in
> __secondary_start, switch_to_as1() uses the last hardware TLB1 slot (entry
> 15 on 16-entry e500v1/v2) for its temporary AS=1 mapping while
> map_mem_in_cams_addr() populates up to CONFIG_LOWMEM_CAM_NUM slots starting
> from 0 without clamping against SPRN_TLB1CFG:
>
> arch/powerpc/mm/nohash/e500.c:map_mem_in_cams_addr() {
> 	...
> 	for (i = 0; boundary && i < max_cam_idx; i++) {
> 	...
> 	}
> 	for (ram -= amount_mapped; ram && i < max_cam_idx; i++) {
> 	...
> 	}
> 	if (init) {
> 		loadcam_multi(0, i, max_cam_idx);
> 		tlbcam_index = i;
> 	}
> 	...
> }
>
> Because PAGE_OFFSET is now 0xb0000000 or 0x70000000 (an odd multiple of
> 256MiB), calc_cam_sz() caps each CAM at 256MiB even on e500v2.  When
> CONFIG_STRICT_KERNEL_RWX=y and CONFIG_DATA_SHIFT is set below 24, mapping
> 1GiB or 2GiB of RAM reaches index 15 and overwrites the active AS=1 entry in
> TLB1[15] (and wraps the 4-bit MAS0[ESEL] field at index 16 onto TLB1[0]),
> crashing during boot.

Ah, this would explain why Richard was able to boot using my patch
with 1.75GiB but not 2GiB, at least if he was using DATA_SHIFT=22.
Hopefully this should still work as expected if we force DATA_SHIFT=24
for larger lowmem sizes like.

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -897,7 +897,8 @@ config DATA_SHIFT
        default 24 if STRICT_KERNEL_RWX && PPC64
        range 17 28 if (STRICT_KERNEL_RWX || DEBUG_PAGEALLOC || KFENCE) && PPC_BOOK3S_32
        range 14 23 if (STRICT_KERNEL_RWX || DEBUG_PAGEALLOC || KFENCE) && PPC_8xx
-       range 20 24 if (STRICT_KERNEL_RWX || DEBUG_PAGEALLOC || KFENCE) && PPC_85xx
+       range 20 24 if (STRICT_KERNEL_RWX || DEBUG_PAGEALLOC || KFENCE) && PPC_85xx && LOWMEM_SIZE<=0x30000000  
+       range 22 24 if (STRICT_KERNEL_RWX || DEBUG_PAGEALLOC || KFENCE) && PPC_85xx && LOWMEM_SIZE<=0x40000000
+       range 24 24 if (STRICT_KERNEL_RWX || DEBUG_PAGEALLOC || KFENCE) && PPC_85xx
        default 22 if STRICT_KERNEL_RWX && PPC_BOOK3S_32
        default 18 if (DEBUG_PAGEALLOC || KFENCE) && PPC_BOOK3S_32
        default 23 if (STRICT_KERNEL_RWX || DEBUG_PAGEALLOC || KFENCE) && PPC_8xx && \

> Also, increasing all defaults by 5 unconditionally
> reserves CAMs for 2GiB of lowmem even when CONFIG_HIGHMEM=n caps
> LOWMEM_SIZE at 1GiB.

This feels like Kconfig is not the ideal tool for calculating these ;-)
I've tried to fit this into a concise form that doesn't overshoot too much,
and list the calculation in the help text for reference:

config LOWMEM_CAM_NUM
        depends on PPC_85xx
        int "Number of CAMs to use to map low memory" if LOWMEM_CAM_NUM_BOOL
        default 8 if !STRICT_KERNEL_RWX && LOWMEM_SIZE >  0x40000000
        default 4 if !STRICT_KERNEL_RWX && LOWMEM_SIZE <= 0x40000000
        default 14 if LOWMEM_SIZE > 0x40000000 # requires DATA_SHIFT=24
        default 10 if DATA_SHIFT >= 24
        default 13 if DATA_SHIFT >= 22
        default 15 # 768MiB lowmem, DATA_SHIFT=20
        help
          Without STRICT_KERNEL_RWX, 1 CAM is used per 256MiB of lowmem,
          with STRICT_KERNEL_RWX, extra entries are usually needed for
          smaller sections depending on DATA_SHIFT. On 2GiB lowmem systems
          with 16 CAMs, only DATA_SHIFT=24 (16MiB alignment) can work.

          The default values are optimized for LOWMEM_SIZE of 1GiB or 2GiB
          and could be adjusted for smaller systems:

          2GiB lowmem, 256MiB aligned: 8*256
          1GiB lowmem, 256MiB aligned: 4*256
          2GiB lowmem,  16MiB aligned: 4*16, 3*64, 7*256
          1GiB lowmem,  16MiB aligned: 4*16, 3*64, 3*256
          1GiB lowmem,   4MiB aligned: 4*4, 3*16, 3*64, 3*256
          768MiB lowmem, 1MiB aligned: 4*1, 3*4, 3*16, 3*64, 2*256

>> @@ -1242,7 +1246,8 @@ config PAGE_OFFSET_BOOL
>>  
>>  config PAGE_OFFSET
>>  	hex "Virtual address of memory base" if PAGE_OFFSET_BOOL
>> -	default "0xc0000000"
>> +	default "0x70000000" if HIGHMEM && !44x
>> +	default "0xb0000000"
>
> [Severity: High]
> With PAGE_OFFSET lowered to 0xb0000000 or 0x70000000 on 32-bit Book3S, does
> LOAD_HOST_SEGMENTS on KVM guest exit leave the upper host kernel segment
> registers holding guest values?

That should be addressed by my update in reply to Christophe pointing
out the same mistake.

      Arnd

