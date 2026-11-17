Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341E3606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=QEZlqEdW;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=xjk0STV/
Received: by kanga.kvack.org (Postfix)
	id 46B286B00EF; Tue, 17 Nov 2026 10:42:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41BEA6B05B0; Tue, 17 Nov 2026 10:42:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE7B6B05B1; Tue, 17 Nov 2026 10:42:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 056576B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:42:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8343014045E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:42:08 +0000 (UTC)
X-FDA: 85445027136.08.1B5CDA1
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3574FC0003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:42:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=QEZlqEdW;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="x jk0STV";
	spf=pass (imf28.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.152 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794930126;
	b=b2NOqUsUPefrCEOwFAx2c5uPUaXfCqBAMdOyGMZM2UcDmsvidw8v7dWI164+X7XKQMjzFD
	+SeI8uWHiMxak3ulCJKqrXx/MJKCu+gkJPBH9+FCkSCL6wuu7U50CKdDzgEsBkKT9Qsv30
	7g/3MtIp8D3jPkAb/Sh8R7PJ1ngM6LU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=QEZlqEdW;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="x jk0STV";
	spf=pass (imf28.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.152 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794930126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ll1OJgMTfmbPO7d5RPNU8rQH+se51A5k26zqVWnejZw=;
	b=FNHVV65iGXPFifo8OF37jHJkspEnAF8iQoB2DZUNSGUmA/mD0eGOLXALO0Mj5njJQp+i+z
	baN1tPxOy0eblYOTkUrH9XloHyNIdZ9KPZ8+a0iRGlxYaWwnitPnXc3PigNSypCWpJzNnG
	g/EiEOBUdXhwGuYp8wqpgoy/hnZPqtk=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7D5F61400162
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:42:05 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 17 Nov 2026 10:42:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794930118;
	 x=1795016518; bh=Ll1OJgMTfmbPO7d5RPNU8rQH+se51A5k26zqVWnejZw=; b=
	QEZlqEdWmLc2QEeS/BvIC2QetEO8ShYZ8QZ0rgehqZi2X19nuUaFAx+esxJHgLnt
	HVTPUJLjNLC2N7WtnFZR0QMqPeZ4KruDB3miKy5rh1lKpSNLuqrcp780F93wnkdp
	gab2EWwAv8xyOGTR/Torx5SHoEnu8LhryEt2CtwNzMg/q6if/vFpC6XyXmDxo+9j
	hMolatYINZtvg4s/5AGp3ec7e3505ADuPFWsry1m4NFISDIx0fi2ZdqhoP2y7mxD
	Fybj5ryRQmmOPXg6fLVhUr27Z1bhna3g0S0U8G44YhZ/h3OT2CxSCqb3g1zYtbHB
	EzHG8WD8/AwMJe/Qk2KQ3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794930118; x=
	1795016518; bh=Ll1OJgMTfmbPO7d5RPNU8rQH+se51A5k26zqVWnejZw=; b=x
	jk0STV/L7B3O32tU8VWQ+CXfuJNPCEgZftRy6OCtYsguLRqbFWxi8TcoLDMess9D
	u7YjlWVhKHXW7Ez8ZujQNovmIVo2avPQC1xH7fK0iehkA4Cg4+tUVd9GhVk4AXSe
	iAP5DPYQ1ltZU8fXdllavVvDIlH0brQAaLrHMwNQJr4PZD+d9o/txnf0rBw0+61h
	WfJKoINsTt8fSQKUD2C5M7fpa3e+kkbOZPKq9c8nOZL+uS5NxQnGb9lP7F0zp19e
	Z+U45BXjDR9EPtbOv4gpqPHnmp+3cf0fFX4Uu2yxdovwgCRELzokQqgvmxUOsGvT
	MPa0smRqY2s+RbOinkIJA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794930118; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:IdJUgS4PPmOeUB8Yb6vxnSDtuH0VJrF6xjLwak7lfEvOrMm
	KeMHCi/e/I2aBtzAGWRuXdxhA1o5VQmT4DQdFR7QIVqm4jP2KX2k1qcHH801YAR0
	P9ILaH0LgEWI7vVI3pHhF31UL6IyIlSGWbQXDxvNKXU/F+nbnJ+/cBZq01kYGlGC
	55mKkSSZ+MK0RfHWLJLfD+ET/nbSkFDImXNbGYTTeiYZtItX1dgmgkVB5U58RxBK
	pGMgnVfHkJ3ShkNq749ztou++FO0U9WX6utOrI2BnsAGCANRErL88dPJQJGCVMnJ
	RKgxWOHNQ4MSI835EvKp22roMrcqqvnwL4uwYlg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:2E40Akz7CxLdmuHlTptnFJiub4jcCNuV3dW/pONaNOE=:XQKkVDqsZ6QAFyQa7gMxgcUZ+KiF7YSNEoDW2ZGC3Os=;
X-ME-Sender: <xms:uHX8aj1ULntcAUjkLkyeKKS2OhHsnYaZboc_qTKkPmMb_Rh6xj1BlA>
    <xme:uHX8as5_M3xbsNzHJjlSvktxoxnwpOJmqi5r_0lEtCjqhB5l-ociCBTlam_GSGS9P
    Wsk0QaMd_UCkjc9EPKz8ZHIPqIWuwy9Mbnpi8R2MQFfJzvmv4o-rsxg4Q>
X-ME-Proxy-Cause: dmFkZTEeJL0hwSgutYTXOLa07funNRvMyPcPnJNDU5g67C7XEeTwvtKXcfgmBe6zntHJIV
    hWVxBCJPwJrqa6fhior51HEG1Y92Mns1888jh4KZEm3IDFBQOvSqu8ssEeQzJpNx2oF84s
    4H7Uj6X4t7fgv6Fjn5AQ2tudTC+laSaiRXUul5xFQjHYC029RvSS13/d+dv4wwBj7Yn3HS
    x5VmPMgGXww/TIVieDlS8BCq2YnZ4rSLiQ7s1Sco1S5nUwg50M8BHdy+cVwTlIJQwqsCuK
    EomYhXWiNLeYHbaHt/4WnYcbuK268FwZlL0axh3zm6ezRWHI67tZZrzPUaKVXr8vMnSDBP
    cZniHB8BHCzNCmfI4FaQhmKAKQN00ak5GaXTEM7gXg23kxhK4HlLXfcWokveeAMUi6sm7P
    +hwELaock05KDm5SwW6DvgqSzCdyoX+3fVVkaVyOJoKFbfhfkGB/t/f0FiBVqPJX/B2uBM
    OnFeY7lW6pC6aX+lD2JdAqV1Ob6LSU5l2Brc7WXHHmwsCE5U1DsIyUOrP2/dx6MXbYu4/7
    LZno59sHVe2sYLlQtO7JxYvGTvtc2xBgf1/zkTUcFbqMVNltrUVgS7pLPreEqmGsPn+4uw
    TcuZSSv4Ot3WyFWSNCKpCQ5gMoOfu8BVMGFOEOe0oatIX9e8yLFWiAE2mxlw
X-ME-Proxy: <xmx:vnX8auYuKawXISghf2SS_ele99TK-xlZAaQoZNwnjO3teiGw4mk6uw>
    <xmx:vnX8aqMLx1SreMXPhKf-edBV69G0ugydCrfVeeWBQeqNzqHGXnCoZA>
    <xmx:vnX8av4gTQP6w5zLly17IpnwDRqE3w7EqapVYUYeSjo771u0PdjAcQ>
    <xmx:vnX8aqN1FiwixV-u1II7ik9iaKq5xJw6Bi9WyoII-D6I7ewjczzIHA>
    <xmx:xnX8al9iigkUpsfbrzzYnNp6MlNkTaLHYYtXFBUbQ-3FEKV4pkbZlJ1a>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id DA48532A009C; Tue, 17 Nov 2026 10:41:44 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AwZDIwU2rPTF
Date: Tue, 17 Nov 2026 16:41:24 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Christophe Leroy" <chleroy@kernel.org>,
 "Arnd Bergmann" <arnd@kernel.org>, linux-mm@kvack.org,
 "Crystal Wood" <crwood@redhat.com>, "Alexander Graf" <graf@amazon.com>
Cc: "Andreas Larsson" <andreas@gaisler.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
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
 "Thomas Gleixner" <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Message-Id: <93593ec2-0f7e-43a9-9166-dee90a9cd2c3@app.fastmail.com>
In-Reply-To: <14e28b99-12dc-4000-a704-8b46cfeb3c0f@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
 <20261116124832.662455-5-arnd@kernel.org>
 <afebfaf5-f3ee-4234-875d-e5ebf1ee64fd@kernel.org>
 <83495d02-4e09-40f0-94fe-e57a1e73d1a3@app.fastmail.com>
 <14e28b99-12dc-4000-a704-8b46cfeb3c0f@kernel.org>
Subject: Re: [PATCH v3 04/10] powerpc: kvm: allow flexible PAGE_OFFSET
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wwzbotq1h69urkof687yg1cfnqsyy5pu
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3574FC0003
X-HE-Tag: 1794930126-195870
X-HE-Meta: U2FsdGVkX1/0+Lka95lOEuLgJhOLUyZ7P1fiR/g1BrPOn/5/1ooA41oHV+YUwa8UrIgJnkrdBQmCh6cerQX5gq2x/hVzezXnwliGXfHHPdzsLrRuPW01Kl9CymX2W3NjSWQ254wNohqDboV/cDgMna1mUAGDECJWp9WemYmGGRlTLo4uHkFQIUzROANLgk6QPyuBpaHM51JNxQh571cQ2HPUJSFrQBZRTHtPesRh/NKi3mGPFRiIKkWcHXGURNkWVfMexg/6ovjXWkhlFGzpTupsG3R6l8BWJ7alQifGYC4CBXTNgnZrxEc31h5kB1LKeg+LMowTddkeJba371H5ohbOiiGL/WxpsGSJiBsiU1cOz+6qRX1GRIPdeiveGmY4zxxebNcRp3ckRDYBhgLJHWr8kmF0jNKHjJXDxSbSJFH6XbmDYbiuAf3DoDqbCkbeF2aayP8idk9C2h4mE6/ItEXlxrDJr/Jfq718kPPawCqOqGOXFvzm/xNkN33M199mt25uhm+phFj+qDOGKpO+20xh9bHIca3TApokDkP6ZDt6JESJcAtHcpE+zrLjpUgpr9rnRwAHd5IThsbcS6sYWNtqfMdRQX2U+iKWP/upavKCgMjIRmBxUNdgrlmDzQVsx/gm1LU57/XMVygYcR6wv/Ou5HDRonlSIbmyZY1B/EyXCL1jG06u2L8GYGL1d04NekIt6YY4svgY42zriyXFdbw59dRbhUKp4IGQdtfmlQoFMCb4HW73umPSfK6ApIpMX6T8tSpte3gn8nl57bn+zRuQx8Umnfeab0aRfR1mz5Ek1N75YprAf61n4P+eC0SRHCe3uEfHWglojTHM2W8Kq/E/z47C6Hzv9u7kPFJN1hn+QcG0qOOjwdBPE2IzNFNfjh+wYgvakZnJQzzgMkDRr0PVOPpEG+Yl/d8WT6SOgGdMv2pF5NLPiZE0a/pCS+hywuYuM+Guss10LUVSRVO
 palBqBZ2
 3dUxUUd6M/wKee8NNzpui1WqtQj6GG6AKZZwSu15TJMgvepMPZq6ZgYQEWpc2UlNna0gaPrtb4kc/iE2CYJosoGdTqcjfQqbaMO2VF1wOHkHSBJWoEH62Zz3RVsBz76ig4YLufFwmG65wm6jHegu96QmsnI0HNtWUCL3aw/RR0IIm2MMyHtq3JYMQUCthJO9NP6TQR6YT6YkUIRDZdRZ7hx5CLjyXw3vV25ljXmlCt6n1u43fZw6y3A32OxlFQ/wqcimNG9BPCurs85Xc812xrtuUoTu6MINQYNLUTudmESTLhoR+RK4bnRD0SQiXMXG66joiZZYL9XRQExHah4BKT5JRau8So8xlS4ZcggHVgdsTkQA3th47W/amc0ocCKP/SR1a54Pl4xGxygg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026, at 16:11, Christophe Leroy (CS GROUP) wrote:
> Le 16/11/2026 =C3=A0 23:54, Arnd Bergmann a =C3=A9crit=C2=A0:
>> On Mon, Nov 16, 2026, at 14:38, Christophe Leroy (CS GROUP) wrote:
>>> Le 16/11/2026 =C3=A0 13:48, Arnd Bergmann a =C3=A9crit=C2=A0:
>>=20
>> --- a/arch/powerpc/kvm/book3s_32_sr.S
>> +++ b/arch/powerpc/kvm/book3s_32_sr.S
>> @@ -107,14 +107,12 @@
>>          KVM_LOAD_BAT(2, r9, r10, r11)
>>          KVM_LOAD_BAT(3, r9, r10, r11)
>>  =20
>> -       /* Restore Segment Registers */
>> -
>> -       /* 0xc - 0xf */
>> -
>> -        li      r0, 4
>> +       /* Restore Segment Registers, assumes PAGE_OFFSET is segment =
aligned */
>> +        li      r0, (0x100000000 - PAGE_OFFSET) >> 28
>
> Fine, thank should work allthough I would have used 0x10 - (PAGE_OFFSE=
T=20
>  >> 28)
>
>>           mtctr   r0
>> -       LOAD_REG_IMMEDIATE(r3, 0x20000000 | (0x111 * 0xc))
>> -        lis     r4, 0xc000
>> +       LOAD_REG_IMMEDIATE(r3, 0x20000000 | (0x111 * (PAGE_OFFSET >> =
28)))
>
> Maybe an opportunity to replace 0x20000000 by SR_KP

Ok, changed both.

>>>> @@ -115,7 +115,8 @@ static u32 get_host_mas0(unsigned long eaddr)
>>>>    	mtspr(SPRN_MAS6, 0);
>>>>    	mas4 =3D mfspr(SPRN_MAS4);
>>>>    	mtspr(SPRN_MAS4, mas4 & ~MAS4_TLBSEL_MASK);
>>>> -	asm volatile("tlbsx 0, %0" : : "b" (eaddr & ~CONFIG_PAGE_OFFSET));
>>>> +	asm volatile("tlbsx 0, %0" :
>>>> +		: "b" (eaddr & (rounddown_pow_of_two(PAGE_OFFSET)-1)));
>>>
>>> I think this is not valid.
>>>
>>> With PAGE_OFFSET equal to 0xc0000000,
>>>
>>> Before:
>>>
>>> eaddr & 0x3fffffff
>>>
>>> Now:
>>>
>>> eaddr & (0x80000000 - 1) =3D eaddr & 0x7fffffff
>>=20
>> I'm probably still misunderstanding the intention of this code then,
>> my reading of the comment was that both 0x3fffffff and 0x7fffffff
>> would be valid choices here as both are below PAGE_OFFSET and
>> large enough to alias the correct set.
>>=20
>> What are the actual requirements for the mask?
>
> I'm also struggling to understand this so I might be wrong. My=20
> understanding at the moment is that here we are looking for the physic=
al=20
> address matching that effective addr in order to find the 1:1 MMU=20
> mapping. The particularity of booke is that you cannot turn off the MM=
U,=20
> so to simulate MMU off you have to have a MMU translation to translate=20
> logical address 0 to physical address 0.
>
> Therefore IIUC the correct calculation should be (eaddr - PAGE_OFFSET)

AIU that would be wrong for PAGE_OFFSET=3D0x70000000 if eaddr>0xf0000000
is a valid argument here, as that would still point into the linear
lowmem map. I've added Crystal and Alex to Cc with their current
work emails, maybe one of them knows.

     Arnd

