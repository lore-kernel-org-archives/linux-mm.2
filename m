Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDB8606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 07:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm3 header.b=NXmQYgQf;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=mhCAzoiz
Received: by kanga.kvack.org (Postfix)
	id 10AF86B0920; Wed, 25 Nov 2026 02:25:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0954D6B0921; Wed, 25 Nov 2026 02:25:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77FF6B0922; Wed, 25 Nov 2026 02:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B212E6B0920
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:25:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15FEB140DCB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:25:55 +0000 (UTC)
X-FDA: 85472807070.15.F558BC5
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf05.hostedemail.com (Postfix) with ESMTP id CD8FE100007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:25:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=NXmQYgQf;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="m hCAzoi";
	spf=pass (imf05.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.156 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795591553;
	b=XHWbVKG/+Akxn1TKR/jHMZHrRX750nEo5ZaQ9LOqUPcz2os/RYOfFWhnCU4n1KQwy9643l
	5s6/1ebZWAPzC5j3EWngAWYB0QugiyCmYijbDkBXm23omoD5a7AjWr3BCEaKAJdrAlvLie
	qy4vEI5DZZL+OYWi0C7kcIzbyws3uig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795591553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=areUyV5IGaUVKzShNrXTKucydKXnSUiEsCYf0gfgVEI=;
	b=gZx1SPVnR+RBbaXsNezjUhaBWPibv0Md7o1BzyVRaIaN4UY1Y4vPbOpBGaVaKPi7E/VmYw
	4Ad534N2i2KBOFVwdtwqC6WHPoM7jNTReyeDF4I2I8z/X7oR3x6/oiHWEtGNaNKP0XuBgs
	3h8p08RBlghfQfSxFZZrRa0auVVGHfM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=NXmQYgQf;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="m hCAzoi";
	spf=pass (imf05.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.156 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 15F421400435
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:25:52 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Wed, 25 Nov 2026 02:25:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1795591549;
	 x=1795677949; bh=areUyV5IGaUVKzShNrXTKucydKXnSUiEsCYf0gfgVEI=; b=
	NXmQYgQfDBGtJJqA6lvVi0OJb8T+mYZTwOFSzroe6/oEumlIDMoOoBVQyvMptNTV
	M5GurofGyGzpx68W0qorKdy4R/xlR4nuXhn5n/LsH91e9i9qdE+OM4swCxDK2pRe
	WHQkVYGq8tSKTHETaOuAO3Z8FoXI6HFIavffF537didW3kxqWoIcunaoADoB6sBk
	yi6VVuji+82nyUQ5kT3qmYipitW/tzddzJkvxNyS6f8AxnBir/6VtMjMTwgnHSiQ
	fqNcyG9LOxd9zhHwAqiRihNk0wARFFva+wqOs9XsI5BtsVhAOTmrFbcVCXOgzrlU
	ea7/fsOx6TZ+BV1KuL4Nzg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795591549; x=
	1795677949; bh=areUyV5IGaUVKzShNrXTKucydKXnSUiEsCYf0gfgVEI=; b=m
	hCAzoizhQKruuk5LmFRQz2d6hn2R1ksevvfdior23pCqGCzg/BtAT2Go8+nzfNeu
	RhfWZihDkz+MljWwSE93SDxX87KckydiZQ46rEk1J1v0qcB1d0cB1rI9d2olDzUI
	wEW3Cpuvf+NS+OX9f8B5I1O/dx6GdJkGRsbFI82xUidwKGBgrRTBva4FYeSRIaHU
	O8KX4B/vRG7cStt+nMcV6v7pKcplsDtDd2pGQB8dBO7/a7514VNMZyYxRi9WCXMu
	CjE4O8Zu1I/fE/ogBKLToJrDWtuMsN2lYbcPAeJL9C3Jd+fKi5MzDtAP8ML2mA8b
	5hnotpSYgwwpsDz7ICkWA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795591549; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:gyaZRTnah0NwAK2Wf/qNkZZGR2KceRhbQuZRIV96KlQC6xh
	oAlE53+xyigLUwGI/Vbc28Zx3qx2LEV32aEdIqQX18BsUd/rutynABzM+ZSo/BpL
	y0ihOISisDqVVNVYQIk+MCnsmkQqdQdkyFiXCnQrcakda1AprtDVDYb+Ddre4+0d
	mFOSOufI9kmP+txHt+GGrO5zEfhte4mhXuS26wmIKlT3Pe/Q9/ZnKisG1Q+52V69
	5QBIs8z9LK2aqIHRRnH9S8oclBt1rWzBeOJs3D2EfqNeWkqrEiLugs1GWYr6yNnH
	tcHw65pUPJYCHfwVenmXpNI1rFxjEwZ8NLfT3rQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:ExiAzAI7ZIHsP3YwjQVuySluz/eigJ9CVIPb+SsDzuU=:qrbV5AJknoaupQ7zjDTbd8KS55zbU4af6v59P5+eBLQ=;
X-ME-Sender: <xms:do0Ga6GSJ35BWkDWp2fNfsaepR0LXFLtkcELH66KvHrOuyTtucC9eg>
    <xme:do0Ga2LokOoqcjP5nJFPguJ2BHyK7iWTQMVCke4O4omZ9B4ofEz_wGBv6K63B_cjc
    pXDSEAtTEPU56NTIZ6JUuo5HtZDg9fUERtxCd8FuaJKzkx9L1cpo2fL>
X-ME-Proxy-Cause: dmFkZTFZPq8SB5M/2S0yRtLGK0naaJDyEBcCAUFLXlW46+6wD18D2V7n4HzSTDFK4Zu1Kw
    lUGCTgRUyrsxhkAV+GljK6xyWGLMX6/po0bC24OTwhC/yvl3WbamZka1z3vH7mEIP2a+BQ
    r8p0BLhaxT1fv3BVPIZxSuB0NrZA8SBu7UDybYkk3RTzXTm6YGwzm2dav7RsHa/dNgBYEC
    YwhP8Dl9H1u3n5tS0gj4z7i5ITr+MMdY5LjaWGt24PBOj8tqd25FfpcFWI52efMkFvlXLN
    hV4JKd3Am4eI0FqzMtG0EnQJohRn7gz778dU+o0s+7DdgeK2+Wh1J+MUnGN1Rn7mO+ZdmT
    4IDUMWZnjGt8qxGM6Bg58JGW/gHqSlvYL/PjPdsE7xvOR26o0QuBGjASNOaeF8H8wOdYB1
    tFmBZa6aX9U2hB6XcOngW+Jz4N4UV1TZ6B1qZuMoRj0b34gf0HQ2W9sZ8KDO50YFmwFVpg
    IkiFPfqb3nAQUS5DTaqJSKCJnk0r57xA6VPqprSgrd/Nqg9cvFs3Y6jCaU4q27ehrWJuYr
    04vbgl0UUFovYY6lThKmmCbFbfM1dtQg+4wHu47UsA1c5cxR4XQ/2AoRhEUju0NKGbdOER
    ndp++75cb5519xDNdHN/VoHlMTe0mNy/RZGkWXsxNkmPj/HiG0T4SHCpI0og
X-ME-Proxy: <xmx:eY0Ga6S26rUQ_4ScmJ0YuJyWGJBwfBk5Umdal-Mg-2zuFJhou9LDNw>
    <xmx:eY0Ga3BprrMbUkf0SGxUGKcE0aMP0HZDS05EUNpxte60g9jvjbtX-g>
    <xmx:eY0GayvMvbdOEJERGQ8GvkbNHA_XslY0D_3LbzpTxmu1UIMgsFd5Ig>
    <xmx:eY0Ga18YTWLRREiBOs4qyRbQofRmBO4GOwowD1_trVaFXUz_EQ41bA>
    <xmx:fY0Ga3CeXFNz_4ixcslQkf6tb9EOKpaiJf7FkdwjRDMoKYnbLD2IBBDY>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id C30DD32A0099; Wed, 25 Nov 2026 02:25:42 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AzzadY2dYG8o
Date: Wed, 25 Nov 2026 08:25:22 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Finn Thain" <fthain@linux-m68k.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Bart Van Assche" <bvanassche@acm.org>,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "kernel test robot" <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 "Linux Memory Management List" <linux-mm@kvack.org>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>,
 "Nilesh Javali" <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com
Message-Id: <9ada54e5-d80a-4d3c-a491-87e7a99f2ac8@app.fastmail.com>
In-Reply-To: <9120b892-6a31-d161-381b-809191017bdc@linux-m68k.org>
References: <20261121034304.2dPxVKzk-lkp@intel.com>
 <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org>
 <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com>
 <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org>
 <8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
 <85e103fe-acca-0880-1be3-cb1e7f79f9a4@linux-m68k.org>
 <f0ec2845-245d-43ac-9c96-242e0d1d11ea@app.fastmail.com>
 <9120b892-6a31-d161-381b-809191017bdc@linux-m68k.org>
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r1x91a8x98ipri5hpmssotxd7ufudn63
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD8FE100007
X-HE-Tag: 1795591552-288496
X-HE-Meta: U2FsdGVkX19WfzRX80DnjU3gHNV7SUYuftXsYvavELTFUVO4E1+y6T2WWtjX5ODVccRksa5tIP/tN6Ja+nGP4j7zoQH0UfVAryiX6+Hl5M72mLE82jxmEhvHlqxTPqcvAqjNnHVDTha0ZKA2F7T2SLZfXGfRd8RGRPtuqjBJRr7OBstGgltU77ErbN/U84F894Qj9MxfvNJDLLgHfhvluGqQ28woQq2us5GgBWnX370s3W8UJOTdim8gey2Fi4tkbFUYV0ttZRKtG8Yi+sSGGpA1ZPLW0XxebKl23/lg/1P7McarXiISPmYz8d2jXsZptxQZTNJ+t9Je8jdJVZ0jwpBkn3g7M/w5j5n6N2VFQMJMzY7m8MbM4e9GwF8gN11OqyK0gyfbtrTRhAHhxACYiVr9+V56T/b3prysmDXDHkP6nOhr/rUCei/ASsI0yAt61lzIkhgMQ6Z8JhAsyqfhU9NLdGboAS/rYTM+pGtGz6oC7DB8ZkcshMLdelSrq9qobsDiGqsNvx6h90stQoC1djDTIs+iRGlaiEAyGuG6KsPo3LWGiFXxlwX3ouIC4cwOCA3Of5bKmAcrS6ctSnzrI88W0oflH+Qf+eTrionb5HOdguqFxr7eZkLJPdjeby35f5RaEjvFhg87K3Yy043P8y+nR6quxwmFZ5GbrYTr55Nwj8nwWJ2qXeBKO0esfpPf8qKE52UenNfDQS5O7gC1/olnUKg7B1Dr9jp1JOc2hojQ9aFKbtvn0mb0AdC8LfyVZKX1z5u24DyyFgtjmpRsLineYpFxj9Go5JcrZKwmvoz6fvbck1S92IsWsohbEPH8idnUX34QIVwEp5s6oghIzvVHwb28GBW4rZA6KXL2KwUyA6SZxykLKcC4iBAGg5j6i5Ckp0Bmrx2IGdhlEjiU+FQNw1uW3qd83u0wFCKw8RIqtT2sJKpYZH2JoPJaeN1PJRVeVvZz4Zdd7YX6LKR
 4MAioq78
 /n9wU0/gUV8ALaSpf1mXU94SkvZ0fWjOGtH+ubpoY9z6T8NH5+x9M1KZrfaEyYlL05Q3z2GlORqkysW6Fk9yrviErFFM9FKVmLt2Kn8OCnaxQoBl8bz/uHZa43Ama4PL2Jmp8gaMVmcUlXTiRws1NdoF1ga84DXiqWKvDp1A2P5a6iMpuFRUaRQiucaRGAf4Z41IitRBi7dwFf6HNagWj6D1cxq3Ml/PCYcL5cIMFoD+2qNBZJD9/ao6gRJ4gN7CrQnICr3zRMBK+vt1ObL8R3c7feuHIZ/XPOYI24jMVm3hGAEnqhk62gz6yMW0lrNnVMAOrDCTgTnI7op6nS/4tLb4PL8iELvPOpWlbGmiDv9i5DCPbSeGMNz8gOiHm34LjGs/CyLmxO5lq2YGlGVfojHXmfwNDp5FdsozjcApX+XhKDTS41/w7snQv4MnA+P6iOjT3dC3yT3gLX9PBEKC9J0CTLNcSthZ0TYZxKHs47HwePy3ypMTaKh1jNYekUeJqBFAMo8BGvX+8+rDFpbgHCbgGa04TiPOSprdC9Gt/9lKk1LlPcmUgfqLwuVgmlTVQOFUx2UECBd6nCL2ZZsw9ltiGX5PPzaQMY+dV3MYZNGpnm4KHUEFwjaaxSsR/zmfuu//zTTd8bKzrGJU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026, at 01:18, Finn Thain wrote:
> [Cc qla2xxx maintainers]
> On Tue, 24 Nov 2026, Arnd Bergmann wrote:
>> On Tue, Nov 24, 2026, at 04:31, Finn Thain wrote:
>> > On Mon, 23 Nov 2026, Bart Van Assche wrote:
>> > Adding a flex array to struct qla_tgt_sess_op can prevent new struct 
>> > members being added in the wrong spot in that struct but can't prevent 
>> > new struct members being added to struct atio7_fcp_cmnd. Neither does 
>> > the assertion. So the "remove" alternative doesn't have all the 
>> > disadvantages that you might expect.
>> 
>> This is probably just a difference in perception: atio_from_isp and 
>> everything inside is clearly marked as a hardware structure that is 
>> meant to align exactly to the 64 byte cacheline, so it would not make 
>> any sense to change its layout and add more members here.
>
> If this driver is for x86_64 only, as you seem to be implying, then the 
> right fix for this build failure would seem to be Kconfig:
>

I did not say or imply that.

>> qla_tgt_sess_op on the other hand is clearly not a hardware structure 
>> but an in-kernel one so it is quite unexpected that one of its members 
>> extends past the end, especially when the other three instances of 
>> atio_from_isp in data structures don't seem to do that.
>> 
>> >> @@ -227,7 +224,7 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
>> >>   		add_cdb_len =
>> >>   			((unsigned int) atio->u.isp24.fcp_cmnd.add_cdb_len) * 4;
>> >> 
>> >> -	u = kzalloc(sizeof(*u) + add_cdb_len, GFP_ATOMIC);
>> >> +	u = kzalloc_flex(*u, extra_cdb, add_cdb_len, GFP_ATOMIC);
>> >>   	if (u == NULL)
>> >>  		goto out_term;
>> 
>> While this does make the current implementation more correct by having
>> the correct length, I'm worried that it just ends up establishing
>> the complexity more in the sense that extra_cdb extends both into
>> the padding and beyond qla_tgt_sess_op.
>> 
>> If the driver is still actively maintained, it would be nice to
>> reduce the complexity instead, in one of two ways:
>> 
>> a) make atio_from_isp naturally aligned by dropping the bogus
>>    __packed attribute, 
>
> I don't think I follow. "Natural" alignment would be at integer multiples 
> of the struct size, right? Moreover, the correct alignment for a hardware 
> struct is a question for the hardware vendor, isn't it?

I should have been clearer here, I meant having it aligned to the
highest alignment of any of its members, in this case alignof(u64),
which would avoid both the warning and the slow byte-at-a-time
access.

>>    so it is actually at the end of qla_tgt_sess_op
>>    as the driver was written to expect. 
>
> FWIW, I think __packed on a hardware struct is at least as desirable as 
> portable drivers are.

I can certainly see an argument for marking the inner structures
"__packed __aligned(8)" or similar, to ensure that the members are
tightly packed but can still be accessed worth multi-byte load/store
instructures.

The way the __packed it written on the outer struct, it only causes
problems but does not actually enforce packing of the inner struct.

     Arnd

