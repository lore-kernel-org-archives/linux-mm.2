Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA45CC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9415A6B0095; Wed, 14 Oct 2026 04:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2B86B0096; Wed, 14 Oct 2026 04:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1496B0098; Wed, 14 Oct 2026 04:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4725D6B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:51:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B40E9120470
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:51:40 +0000 (UTC)
X-FDA: 85320613560.20.55DCC79
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8939540006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:51:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=H7Q8uwOd;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="u XnuJTd";
	spf=pass (imf07.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.159 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791967898;
	b=HSQwVMyapYaaitT3uZGFFtdunxi9sar98eYyWpYhf1SV9Z3E9axRhckMUuw8bCFwGK/IdF
	0o19fqdCwbyZgXHLLbsirpT9Ivth3ARlhw0FgqOvsLlvOAeSJ7rWXuEsOXytZuyM8IxYxl
	vWqem2WGfytL5OraSQ8pZ9GLiW2kVi4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=H7Q8uwOd;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="u XnuJTd";
	spf=pass (imf07.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.159 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791967898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+LFPCsnRJvUDK1wOaRGQjPBjNNnRquMTT9sppD5pbc=;
	b=F4qbozqf65HQZZ+bJRL2EOqScCQoaSIKspdgarWMO1J0od4EgYmfEWkdhlwzYktei39Adv
	Wg5TpEx1V4WmY84PJNfR9WWb1G3P5lwEdZx9kzo5KBtPUB072Ec6HXqbw+MnJOKTwIW/Qq
	Hq79BDl7jcgizkPEqnJsfN3zSLuiG+k=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A2913140008D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:51:37 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Wed, 14 Oct 2026 04:51:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1791967893;
	 x=1792054293; bh=s+LFPCsnRJvUDK1wOaRGQjPBjNNnRquMTT9sppD5pbc=; b=
	H7Q8uwOdfZ5NC7b7Lsvv01U48s0aTFncOG9VIwFbOOe5N47jIwLMWUYikw7JG0Ri
	jrcbi941SLOrQHyadwOo9J7mwHjXWjCgP6vsitQLvr5fs26jfIhlsdCTH711ASBx
	23JYMgTbTlqSTRZI3pWC50O4XBIv45l9M+qBXXbb4jJh/nzSY8kc5XjMLkNSQN9j
	xbc8OdK308x1/ZYi4EUma+kejvWOPE+7OSj2utwDhspTTto8/6nw7uftpLndrqlD
	6y30BvDBAHBT1ihJ4+1ljsIYqTxWgKUK3woEc4r3ZSnmqGhK6zHvn8MxmUT0JuQk
	1qPkDHu8wa2A5OtULYto0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791967893; x=
	1792054293; bh=s+LFPCsnRJvUDK1wOaRGQjPBjNNnRquMTT9sppD5pbc=; b=u
	XnuJTd4UKSjZwjkMpcFrsaHYu29Z0NIP/lmiSEym7AjjBr2of1MybzODN5jJQySl
	Cj3ndxvY/MpQSneJPdqbgYGLIsNTxTVU6Lt+TrpnFCAa1QglxhctOhnuEwGHRE2n
	MRivEGXn1M1exXKX/IG2qdNhDxm2MDUERFxgXCHVwjB/O+fttZgVOuO7smVImGg+
	QYQja4c48Bh683vML4JGtxsNy5NoVW204pM8Dn5K9JzdHvIkigl6R4qeRPWO4M4t
	6JRj7dWOHyIFaN0luQ9vE9Uh84q5Z63QnsDlEQvAZSxYziGpBr8Yscsf7Zs+XFbP
	ywdTrJjW48Fs/X5+jVQJw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791967893; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:A/BIh5YYPswXZjGaYAp15mReR+Nt12cLxgW4rQACarfyZA6
	a7U05lp8RBMgdnUI1UTP1J1TVf3y1+hUYEoJX70RlZoPO0IIOwpHrMVUQjIg+deG
	dalTuNsU5FHwKRZQQOVZOyWox3EiuooKdrwsH8V6VPtWWQ7r8N8+Lx1SkR2s7Fwv
	PfmSyCZsSWgLhksCyoFmZ1YiTkeV+vNBT+/ZsI1DTWUOFYmSEV0vSJwnbnjmNCj5
	vZxIaZ5epakcXqSElU/8/D/SR5MZPVVtVUdyYEdscKfRWmeH0Rdf6c+v6Smaa1VD
	dYSTGaEjS2MNMTLuYTX5HaIHM37Mkg42VlZtrpA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:v6jLbFLw97rgSTMbKiy0NdGsK2y8cjSwS8WxYzPzZMk=:M0aObq6bJgje0UT2uUYtzH9eDNb/TIATR/h5EGpBzx4=;
X-ME-Sender: <xms:j0LParrUFvTBU9K5I63Y-2el0ciOVViHHyk-Kq_Ou2Yh2hcmMvoRbA>
    <xme:j0LPageD3rN_ND-tLI8Og7jolQ8CvuytjspA1jFXB1IzvLr0ZLjWp7ZChrJ4OGzri
    l_C-NceuDSiwG9FaRPinYr0IFnRKdutPSE9NowvdAkbJUcqI5SZj_u5uA>
X-ME-Proxy-Cause: dmFkZTGfLAdL0vxkYY9Ttp8RamOvH+ay9++SlVeOLJK84cLH+pRPHm/ENjo/I7LTE8S1CS
    Pt3dYazVhuhFGQGkwCmAnYYyN2w7mdq8y3lgN54SKGHyb3aF+4577m/Tl0GQ5FAxX0GVGz
    4Z7n1u2AxTAhSmN/KjfRXoFBFt5cDn8bvvDfOyC93p7I5Znsg2Oxh7HIF437xkWy/OP9h8
    KXiWYFfh9U1fjnFV56J+aeDhe4Qvn/DtUgAeGCpOfq1JTPSP2Mn6y/OdTpM6Q0BzDsSzpq
    qmhdDTB0vEA3lzY+dRnoDMgr1oZ16v9QXLvTx8RAPx8+WdFl38hiqqKh1QxfSt3nM7VzUT
    wW4qwdfnUOGClYvS5UpYaaqIQuMcjfjNP8qxSn90BOqzbmjxxGa3nBrtBpLJKok/SPnuMs
    WGS6raSYS7nXd3S3c5sBTKaB79nmVExOo0fxhAbLNJPhgWs+OUi+SHZ49g975Vksf2RFt1
    B4Eey1G0WHJEYzpX9tDIK6CMe2oX7qxqVlU9Gf0ncOv/9Rz9Z5QdxNMTboTLIv6W1cMt/B
    GjYIxcTXmyxAmiarQXOZKDIvr3ar5oAmnV5r0BxhIbKg/UjeF/NxfFaIHAqne8Jobu7rqd
    vjo4SHyOQni/1IUBfAq6ZWzUue0th1TqM20pp0ltIbnkGn0UTeRCI4YfQ7lg
X-ME-Proxy: <xmx:kULPatM4VJ1Zwhq655jW2EEW3xBlfzHEbFjBAkoxfR_iU95aYvE_9A>
    <xmx:kULPar2WUvss1AKYri0cURhIrYpDA_3JivpX165pibkxZYFreSNE2A>
    <xmx:kULPapQXn-HDuXcQZzYvyCI9G7Z6yfo3mcHSgeKc45ZdgeqgBxpWyQ>
    <xmx:kULPaulsjdHffN5dkWaQGazC0dX4uVEwOwhf_UwhFQfMHFP5CrYCaA>
    <xmx:lULPat6tNBS87e05J6rt2D6fCks1s1cE8x5Ay9Y52WC2KUjFub3YZUjp>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 2DBBE32A008E; Wed, 14 Oct 2026 04:51:27 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AAmuA3xfg9N3
Date: Wed, 14 Oct 2026 10:50:41 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andrew Morton" <akpm@linux-foundation.org>,
 "Biplab Raut" <Biplab.Raut@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 "Gao Xiang" <hsiangkao@linux.alibaba.com>, "Nick Terrell" <terrelln@fb.com>,
 yann.collet.73@gmail.com, guoxuenan@huawei.com,
 "Nathan Chancellor" <nathan@kernel.org>,
 "Nicolas Schier" <n.schier@fritz.com>, "Kees Cook" <kees@kernel.org>
Message-Id: <e2afcf01-c77a-4da6-8f56-237d97abdaf6@app.fastmail.com>
In-Reply-To: <20261012203257.614d88c12146544aa6487b4d@linux-foundation.org>
References: <20261013032010.2453893-1-Biplab.Raut@amd.com>
 <20261012203257.614d88c12146544aa6487b4d@linux-foundation.org>
Subject: Re: [PATCH] lib/lz4: add software-pipelined prefetch to decode fast loop
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8939540006
X-Rspam-User: 
X-Stat-Signature: tmur6rwjdmreitzqastd49x88csbm1mw
X-HE-Tag: 1791967898-648279
X-HE-Meta: U2FsdGVkX1+iCoZOImQZg8aR0YQJepLZEKZLl1OAD4AHruiTJdhBWOE5DPR53LJrOHewPo3I7PPeNr6iVsDdE39wn2FDvzIB3kG6ln7DDcqcRDTIbtBCluvT9YHMH+husWJVMOqA+cYXLvQ2yog3THWzrnzRC6yw7+JhdQqJpOsWm/kmBr8KZeAMVUZXD1zYxOphxNuHEh0qFWnOzFJJVsse050DhJMkiCNja5EtFWB5NGa4LNjvsdc5Emy93dcH+YCsxqTtco5GnM/TzT1r5IRKUL+thnkfuV/EpPvBfVy8hyK8sElphjTF+l6bNiZb/OzyrRFi/nkkSgoREgilEtDjOzW1v+ayZAyDsyJtPJZsO13NBlKCgG1ivopOzi5XqW1+5IoWQjAUHVPTR62IxYrUu7k4Eee5G/nDbcnwF9I2OKnhsE4P61DwWLNOtFCQamYLPawCpZCjXaFCUaMX92NgnTVF4UhtLU/oTjcC3qEPbjA1jqBIsMhinBLPRA3MsC/rGb7dVlhfvfifx/UXvxDUPVapcgLyDpTGBniJF+sV0Ck5wzm0wUn1pgJc3am5U+aK4kmkIroFX9QESukf3ENbB147u0CEND7rCbAWtUReIhNdbUTtjby5h79gepR7de9YikDtyDpJiPBOXJJ5HgfWEwuOyoe7tgLeYD1IFyUECQnjR7KbwQKw0kBHyQjTSN99cwea9S/rOrmbW84CCLwoqWWOhQbwL17WKIuM/kqKHTtdKGbUe5ZyHn0K9CHV2+XC2OXSEiga09LDcQAc7lr9CTEG+cJAdgTzxbpJdZ2zyJZOzWC1OcJMn2x8yDtcw47gumV93I/w/T0jvAYAvswBqqJzD3l7ZdFCBQpbjcrIjpBQAHmcDVaNJ0LWn55Qi1sBqZ0PI0SWAS+l80CqDBG2KYGuI7HCTEBmBT4ZaPu+P7rO4QEuC0excn6D9GvdLnqaGnsArNrhPZZZSpJ
 RWXShC04
 DEhEo5JBExMzSYwFTY8N+UlFNYfJbO75+ZRl21RDk6yFZj6UghPLXNi7pJEdHgzh+c5IhcDQ13+Cqph70ZXXnFGkp9mov1s8bbRqeE7fiZ78XZu9+TODHil7HM9J0A55vjeYVQlFbCD2yXboPExDQFHEix0aYMSadN6RmnF4yF2LKrwqKQWMbD2BV59Ldl8B0KGUASKYl/xDC8llbqgmkjgAy+45wxCEwnXWpNsE3rhj8SgPQBT2l8mvgBXVXXvmuQWWLPZ8Y8D1Pr78j6YgPiqJZCI/TTi/IGVGIBAzNRSlA17v/EWEruuvKC8kbuDAUCwyH0N5PisKStUDaVeTimXMJc8mebKI2IDmr5acC3F59X4B+lga77ezLy4MCtJuZozNBRDq91Yu1ebosIvSjv5zfPDdRS+ToAQh0m+0inz0Eagh8w+PxI3yoQxl0WhS1dMZLMWxXixrTywL13C8NDVQ3ziJhMKNQyNE/XMdT+gv0E2gPCOXlPs+5W+n3ElbtaA3A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026, at 05:32, Andrew Morton wrote:
> On Tue, 13 Oct 2026 03:20:10 +0000 Biplab Raut <Biplab.Raut@amd.com> w=
rote:
>>=20
>>   Kernel LZ4 median scan:  1.0994 s
>>   Patched  median scan:    1.0472 s
>>   Median paired speedup:   5.09%  (range 4.19%=E2=80=936.99%)
>>   Patched was faster in all 15 rounds.
>
> Well that's nice.  I can't actually recall a case where prefetch made a
> measurable difference, although I'm sure there are such cases.
>
> We used to use prefetches often (10+ years ago) but it seems to fallen
> out of favor.  This code is a prime candidate.  mm/ barely uses
> prefetch.  Maybe it should,

Unfortunately the patch causes a build regression on x86 when using lz4
compressed bzImage files:
x86_64-linux-ld: error: unplaced orphan section `.altinstructions' from =
`arch/x86/boot/compressed/misc.o'
x86_64-linux-ld: error: unplaced orphan section `.altinstr_replacement' =
from `arch/x86/boot/compressed/misc.o'

I see that the zero-day bot has also reported this[1].

The problem is that the prefetch() helpers use SMP alternatives
that are not available in the decompressor. This has been a problem
in other patches before [2].

Not sure if there is an easy way to stop the decompressor from using
the alternatives here, for 7.4 I assume the only option is to drop
the patch and try again once that is resolved.

       Arnd=20

[1] https://lore.kernel.org/all/202610140857.6jRIqXf1-lkp@intel.com/
[2] https://lore.kernel.org/all/CAHk-=3Dwhrc-ruKs4Kt90EGzKd+pYhZFKs6bgBV=
CV=3D55BK+p1nzg@mail.gmail.com/

