Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8AC606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=CmTQ43rB;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=X16WGVVA
Received: by kanga.kvack.org (Postfix)
	id 6AB786B05B1; Fri, 13 Nov 2026 09:19:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683496B05C0; Fri, 13 Nov 2026 09:19:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572076B05C1; Fri, 13 Nov 2026 09:19:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30F2B6B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:19:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B26641401E7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:19:34 +0000 (UTC)
X-FDA: 85430303868.27.9E6DCF7
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf16.hostedemail.com (Postfix) with ESMTP id 78DC0180004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:19:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=CmTQ43rB;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="X 16WGVV";
	spf=pass (imf16.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.149 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794579572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RoUJPoDvqPyMYdvLAx7wuzjFIAugHN09/qGUDFufoyw=;
	b=q5+GKqMePsrfWdNc98Ofc25q1ckHJ59niXeWC6dGXaIiGLWN8sprVrUcEmzBlYGVcZPepA
	gfKmlYPzoRhteSqpZO53F9MnfSODGuTLNyedAXwdNkOAKdkes51UueJa86KHxAGBUBOV4r
	uXqC2HfXlH0wiwJpXrEIpc/vZHNfGAc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=CmTQ43rB;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="X 16WGVV";
	spf=pass (imf16.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.149 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794579572;
	b=OJka/9n/MxI7GYV/fPIriNy/icjgE5oTwEHssO9oc+ksz8cyLve4nrt7OVrMbGPy2U4Tkb
	Oic7tID3CtUpj9bYtLX6rMFV7QKT6/q4n7oglKljbkncHZIzzrDMt+dm54y2yhRd+c522D
	KC4sUH4ome7j8xlE6AZ6bMC4eZsQej4=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id A1F5AEC1215
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:19:31 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Fri, 13 Nov 2026 09:19:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794579566;
	 x=1794665966; bh=RoUJPoDvqPyMYdvLAx7wuzjFIAugHN09/qGUDFufoyw=; b=
	CmTQ43rBhbkcxyywSU0bptwkSqP6To64HsK5B8YL54z/R5clS28bSUfGkTSQcfu7
	ALMrkgVPuiRH+kOqiFnXjy9YweGLaaOfBxMP4BpW81UtvpLMti/a7Id0educ0Ibd
	DM8NPg5hWfh/UWw/IQqjtdpITUfCsnSDVPj5lQgQU4QDYNTE0jPgO8MKui2bkX/S
	XPlLt4abhXs1qra3zkUV7Blo4jplQvZdgo62hBNtpNlJMMx3nswF/k8bA4rhpClP
	7TUt2m2aMCLcGoifqqhKs5kkhhEzblepw/XMd1GdL4XgD2awgyT1u68OmBq70fJT
	7X/GaJGfxBEgu7Xr/Uqncg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794579566; x=
	1794665966; bh=RoUJPoDvqPyMYdvLAx7wuzjFIAugHN09/qGUDFufoyw=; b=X
	16WGVVANI6Bqsy0uCsTe4x+zQiKpPZe9eSyhr6jGzPe9x9YMtI5yJqtk0MD6Qtwx
	HgjsfqvpN9S4SAO3QSsEXrCgA2Yo7slHfOaWzNH4FsyCkc4OBXLL6VpWZ1QYHFVw
	mnD1/dS00+PMLEwRU8AuZdgjqB6KU/vePt0Aq/pyfNkMqUWD4EQF+7zmJpX7ZAO5
	cw7QVJeicYH9lirqrwLilYF4cKHAV4vYhQ3tBBAZAI1CzUIwXIgd5OSzSMSpsBJF
	4Zip12t/GvuoJh8PCZbeswjzS6ZyYJ7xJdXKxcv8sss1InBwjkNSsAP8Rps8PZQi
	ogUOw8DKFMBW11XghO6ng==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794579566; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:Ze+fO84h53wSAo5VLLOZCIdE1ffPm6mp9TBiotqV6qeP2XP
	U5Ce6f/KMKoYGGfiD9z9Rp8Xq130JTf/bn/BviRma1UEEodXMtOpcCwHjg8FrMVd
	8aJNIB3QLgG3H6f1xCKEoiCInsr5egmO4vJly5vq4xa3yEqLSw1Gnr7qGeVYqrsz
	a7kXBYw5R0arySt8HZWr3/NNgCeq8JP4AhBnsZDZLHYoMXB/7dThSa2IKydX8iKK
	DnfvQH/n34PXD2OW7JwYYxS7GfjZNG0fcu0Ufgb1Y13L104+01s460GmqHZq+rNL
	/SfyANnG+hN152R6ZnUmAeq4q31iOJqQro1bQmA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:wtdkm8qMoH1idKb883rNB76Vp10NABjxoQnp9E0viKs=:B7YiVtR0x9J0dYjfQTIGq65fnKeg0k+9jyGvYJDIcmA=;
X-ME-Sender: <xms:Zxz3aq-1MXSyvJlOCToClarup4KSpOgP1q__TfAaeof1DJ7EGbrO3w>
    <xme:Zxz3alhpSD21XzllWkSwOR3KSR348xbE2yibNqdEB0YeMcy7M8JBKYqKDNTdxzger
    _38B3M9q9p0H9V28qGdaf0qrnkrgFr_WuE51I-lIz95KlzuGvEvLO8i>
X-ME-Proxy-Cause: dmFkZTEUbeBCFv6J3xC3FebRJK+AUjb1IUXCOcUbsghJIWlnF2ZS1EW33U0egd23z4Zy4T
    tt8oubCPe42K6/ZYcmo8IIGtXnOIXLQvQ8CfOmjTl6V72JTKA9OuPd3jnrjL2AVfappj7N
    OBDVVB/EQaO9sT6vVIyW6k2vsxKQojH/P/zhTVVd/rz3QBMxtGSn/U2miHCiN+XU1ZKiBa
    1s/QVDdylMFa2nHz5ao1iqgL9X6gx6uwA6ZFK2EChRbmiqCoMud4OUNILzDihLkGTl7d4G
    qsODNF1zNy97PzqR/G02uhk7UkJBnkt0cCaAT2mISpTzmrq5VI2NFV9F+T145g+uvSTQUh
    hz16/Cyr/49qmisNWrebI6v96Y74eYzmmdG4PY6JzSCKqsETaxSumpoHPv0yyMj0ATdAEJ
    BJoedHBOgjDhP4fd1IlCUfB+nwUVUH8wjTq3m4IvQ5ycs+SaOnrTBQL9EJQGMM7U8IJ7Tx
    2WrsSgur8WQZCAczQzcuGQuaZTb4hxwr//Bnyx01WtorUmZvopAJq5PTvmK/3jNGp8sMd3
    m8hHk6Tivw57m6Ive0LnTb9V8kXN6W/42Q8m5d+j86CIJ0MJnvS6ZHRp8jKDpwqOGvbGPB
    IDdOEL28N+nRtWvahSxAP/RoU9RnAsNc5Tctg+K2tqk1BfKm7AoYdZTz86rQ
X-ME-Proxy: <xmx:ahz3aurOslNFv6Oft_IRmYk5AIAoT625RsEdEdYDmDw5APrQAfcI4A>
    <xmx:ahz3arKTRtTdAJFiMhlYCfYL6l2MUwy-TcpVhcVVh5bdjDfoEiGOjg>
    <xmx:ahz3aqDq0sSF3jR4QAVUEUL9JSTSXwDRzKeKNF_QQiy_ZtgoOw80wQ>
    <xmx:ahz3at7xfymhRZt7mmM-4RZ8HMpWmu50Rbkbcj8nM5ma0o0aw_cp8A>
    <xmx:bhz3ak9abl_Xa5ZlTqbigXkWh38eXBJYNio0F0uX0-4ttVAB2dTVm1Uc>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 2636932A009C; Fri, 13 Nov 2026 09:19:19 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: ArjohY43VwOF
Date: Fri, 13 Nov 2026 15:18:09 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: sashiko-reviews@lists.linux.dev, "Arnd Bergmann" <arnd@kernel.org>,
 linux-mm@kvack.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Jason Gunthorpe" <jgg@nvidia.com>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Malin Jonsson" <malin.jonsson@est.tech>,
 "Richard Weinberger" <richard@nod.at>,
 "Russell King" <linux@armlinux.org.uk>, x86@kernel.org
Message-Id: <3f53782e-5def-4ff4-8d87-27b6d3b2a45e@app.fastmail.com>
In-Reply-To: <sashiko-outbox-212720@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-7-arnd@kernel.org> <sashiko-outbox-212720@kernel.org>
Subject: Re: [PATCH v2 6/6] ARM: add CONFIG_VMSPLIT_2G_OPT option
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1xajz18q7uo3rwak9x1sxc6daxpcdogz
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 78DC0180004
X-HE-Tag: 1794579572-10081
X-HE-Meta: U2FsdGVkX1/Hqcf9FKhGjNCxona0tzdbZVpZxG7X+HoFvH9cpuwvPZO56g/ie0uBGo0uNXKLaxbID1Zvdm62AXYl6Win+dXrpyG0cMR7QrSofOUA9+tj8bhE+eIFperKrRMNuPkT0CGMqa6W9yFSMzF5AlK9yI/Hf+HpRP0BpNHTRSOwXcfjLIVrgWzwL6a/DVEOCceYaKgS06UCVNjFlMwRGak9mdPRgkaJkv5oixCH3folCrhXScjUm7rAm5odqnT3ujhsg8PYJzIL4wGuUwT5Lfdu6IGh112NYlW6DR09CpaTJQ2/M7DWNF8w0PfROFGpfCx1CcKiCHUC/HVSn65xGrU3e480OStzS1iH0IgkgGLzkENwll2UyrGGX88UH0YSWyINYERyzC7BPKukVS11OQ0H9zcHP8pkytiW+1fHLYTh/m5FCPgukV4qkRNYGaA7Y+forOdJPIw0AQQPJmvYcd87hv1958hzcrdpCQ/fNrZLTRUKLmst99lgoxJ7S+9EssatL4JPmnB24CFIE10FdBg14EaP5+J9aMjXxkMPBmqTUuyAoc8Qh407lLqTMYPaemNjOVfd7aFCDnSf9fZYT3cVkQBlkrWCtDh1I5UqrFu4FYrvdejZxP26r53N+nIAZAEiEC6CfO92oDpmgT8WGXiIVsOoQutt6eEiDQiLgXT/0pnPJHKg2PaI4kopHxHH660T4Bm36IQY/BPr4cV6pQ6DOaZYFJex+ICym+usPLXyXZuEuXR7fgs1HjF9C/jx8t/4qG36ZB56S2iXpN09OaovU2vuOPi7G0XnA8wc+gRqpYAGtm7uoRurFipc2wSg/MLTB8O6vdMt81j4DEpHXaWsVKD+BUBkwy16oTh6Ok0YSJEc+tF98psk+mUqeSQolbHvOQEDHhqUyHKJfVfD0G36RvI9trm+wZf/W2E0oexuwnYra57IeChvCgr/DJ6H2ewuAAg7+FsexXU
 KD41HohK
 dQ8/3DLSCtU0MQZ3fWSmk1/8g35mWpak678gLzSsPsZU1OzH5dGhejpkY9EySnA0nKgFW6l/Rd9VVssi9flu40PWqBVk6PeRMoh06X8aZuuON1QzamrxCqr5nKzs4oT/eNZnF/gJ4sgVSNjCfgaEYdOms8WlL6+90QnLuFaIzso5J9724XhMDdg9nP15oKflFV9ueBartL/Y0FVtnPTuXcJ17hpRlLf8CetlwynwhJQYHT5+VN7XqepxeggGwKCOkvteUKojQlOjB1G1DQ/4fCtx0tnumijPrtd9PIqunpYGHt8h+NAMVsvKflw0nHyB1ZZXtqwqYMJ4OTh6kOaZUmMZW5EnbCjbBIwzLinc97/LZJIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026, at 12:26, sashiko-bot@kernel.org wrote:
>> @@ -1052,6 +1056,7 @@ config PAGE_OFFSET
>>  	hex
>>  	default PHYS_OFFSET if !MMU
>>  	default 0x40000000 if VMSPLIT_1G
>> +	default 0x70000000 if VMSPLIT_2G_OPT
>>  	default 0x80000000 if VMSPLIT_2G
>>  	default 0xB0000000 if VMSPLIT_3G_OPT
>>  	default 0xC0000000
>
> [Severity: Low]
> Should ARCH_MMAP_RND_BITS_MAX also handle PAGE_OFFSET=0x70000000?
>
> arch/arm/Kconfig:
> config ARCH_MMAP_RND_BITS_MAX
> 	default 14 if PAGE_OFFSET=0x40000000
> 	default 15 if PAGE_OFFSET=0x80000000
> 	default 16
>
> With VMSPLIT_2G_OPT, PAGE_OFFSET=0x70000000 falls through to 16 bits
> (up to 256 MiB of mmap randomization), which is twice the maximum
> allowed for the larger user address space under PAGE_OFFSET=0x80000000.
> When KASAN is enabled (shrinking TASK_SIZE to 0x5ce00000) and the stack
> gap reaches MAX_GAP, a 16-bit random offset can exceed STACK_TOP -
> MAX_GAP in mmap_base() and cause top-down mmap allocations to fall back
> to bottom-up.

I've changed it now to use '<=' instead of '=' and hopefully handle
do something sensible for any PAGE_OFFSET value. I'm not sure I understand
if these are intended as heuristics or if there is a hard limit we
can use instead. Should this be 'default 14 if PAGE_OFFSET < 0x80000000'?

      Arnd

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -329,8 +329,8 @@ config ARCH_MMAP_RND_BITS_MIN
        default 8
 
 config ARCH_MMAP_RND_BITS_MAX
-       default 14 if PAGE_OFFSET=0x40000000
-       default 15 if PAGE_OFFSET=0x80000000
+       default 14 if PAGE_OFFSET<=0x40000000
+       default 15 if PAGE_OFFSET<=0x80000000
        default 16
 
 config ARCH_MULTIPLATFORM


