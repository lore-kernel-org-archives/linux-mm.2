Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DB5D60A262F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 10:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E676B047C; Tue, 20 Oct 2026 06:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF64D6B047E; Tue, 20 Oct 2026 06:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69596B047F; Tue, 20 Oct 2026 06:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A72456B047C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:50:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 307A180113
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:50:56 +0000 (UTC)
X-FDA: 85342686912.23.401A0A4
Received: from mailrelay-egress5.pub.mailoutpod3-cph3.one.com (mailrelay-egress5.pub.mailoutpod3-cph3.one.com [46.30.211.244])
	by imf06.hostedemail.com (Postfix) with ESMTP id C3D5F18000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:50:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=TsZPhoWh;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b="tp/VAhUi"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792493454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFG2HP/YgJvzmwkELEIVClidnUuFRBnAC4gyPRz2wIk=;
	b=paveomkpGvANYQX+9BO/jbhYUbTzDG7RBLT6o9Pd+TmrRXtXjbHTa3gJKfmoZ++IaL74QZ
	5C1ait3ZMJq2QF7vGzdrCdIg3Ouw1ah2Hr97hpQ6zXFsHdyEdQjS1iIuuLynDHwHe/hpae
	+Y50b5s5MPnyQg/Vy+KO57zIJQLN1Cc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=TsZPhoWh;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b="tp/VAhUi";
	spf=none (imf06.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.211.244) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792493454;
	b=Mf46tlpPHBd4Y7vgc1GyXCmZ4+OkbdkUAT1+qLeDk6r/4FkSUbnLJPItqQvkqUxdD/e8RQ
	uFGWp3AcSMhrt+B0CA6HBhtOarJGX2SZXByzsTifefS6FHXSpryzu5AP/oDeoVJtLvjaL+
	1iM4hq6Hq0/qnAreu7z+DaEPXJlaAw0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792493451; x=1793098251;
	d=konsulko.se; s=rsa2;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=aFG2HP/YgJvzmwkELEIVClidnUuFRBnAC4gyPRz2wIk=;
	b=TsZPhoWhqMXIicwc2lJ4IPC4xnem15qVHzBv+WFP6oa2pWct0sGIG5UMNCXDgdi86QMuAYqXoHXqS
	 VBRdpN3+20zeIkThWxTrtB52UbDLmRxu/bMcuMmcCcJgliTP2XgFFUG2gGvlmFbD1CB5lW+FC7US0y
	 +Cmf0ZV1MYrtW/DyTi9gMjbyE8ww9luZG1g9DJhseTm78hAlIru0O2+vEPsWN+wWKrAhhD3BUctyfX
	 S0ugsMFS+0nTcvvRm30JZVPqx9W1cXKexntz7RM+jQnR8ZlIXdv1TVO6BC2yJL6zGfn6XEMNQR6JJJ
	 RIIFaeWXGsGgWIJdsw7hjfpMr6BqYaQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792493451; x=1793098251;
	d=konsulko.se; s=ed2;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=aFG2HP/YgJvzmwkELEIVClidnUuFRBnAC4gyPRz2wIk=;
	b=tp/VAhUi4TNkngibwnUKSs2Y4t6+oPnbu7f0mPRTfQVjREKprNg4wzy5PQQGvKlfTmweZmqM4eFz/
	 1CwP0erAw==
X-HalOne-ID: 1bdb834f-cc74-11f1-ba2d-33fc7c51c1c8
Received: from smtpclient.apple (unknown [2a02:aa1:165e:5a8:ecb0:57ca:e3fe:31b9])
	by mailrelay3.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 1bdb834f-cc74-11f1-ba2d-33fc7c51c1c8;
	Tue, 20 Oct 2026 10:50:50 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array after
 concurrent resizes
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <3a034d40-e01d-42cf-9325-8c1e4a6db1b9@kernel.org>
Date: Tue, 20 Oct 2026 12:50:38 +0200
Cc: Harry Yoo <harry@kernel.org>,
 akpm@linux-foundation.org,
 cl@gentwo.org,
 hao.li@linux.dev,
 hch@lst.de,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 nickolai@csail.mit.edu,
 rientjes@google.com,
 roman.gushchin@linux.dev,
 vitaly.vul@partner.samsung.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2F07BE53-D6E5-4988-B1BD-84AD2A05DDA2@konsulko.se>
References: <atTh-yyVIPQ-zNWJ@thinkstation>
 <20261018160315.1465504-1-vitaly.wool@konsulko.se>
 <atTv1tg9q9n92kZv@thinkstation>
 <F846CE95-6D2A-4D53-9C09-5C8630E2C8A7@konsulko.se>
 <3a034d40-e01d-42cf-9325-8c1e4a6db1b9@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: Apple Mail (2.3826.200.121)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3D5F18000A
X-Stat-Signature: 1ao7we8agsdiwbc88dimbpskbbbqx4z7
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792493453-651535
X-HE-Meta: U2FsdGVkX18J5YLNyVhUV5pjppN1FtXKWdk7RtzfcS6N1xCkiDzDTjHi7aefD+foO/kk7kQ8lzfGoJkr8okP8FHWBFSmjGoTtY6HQMExcGyETbbHnhlSh9oaLeBUQMy8b9FbX0q0PPt8ZB4hv8PicpN2DwSwfUb5V1LpCzxNKmZa3Kch/NaWygTdSPid/5DxFyCq4I+1Fyg6cJhz+eQkLFyzMIX1/iRzqQYPj88E04L6szY1cWlhDukHvIWKq2831TGYRqjh9gsMWDePY69r58tGroU9O9jjCX4aFOprPTTLURrbRAGnCaJFvn/l8o5/v2WkLJoX8E+XFvYLkMAm13FL09/r/C8puZ0nouATrSHzMzYhaPo2cO/YoO6ESkMU75tjrxwfYVVJ0mlZNcER7RnQqCuWjSOOHP6ylvqmALepnoJ1CVJscrHf+tmTjtljGEpVEcAtaZ0/3PFbkeJce5HUsCuxc8j60IdKx8j0O8DQ0FlG6X/tlA0hRO9IkAL01hRtqqabyNZG7mTyb1vLjqlC9vusQamFQKZmxtQxS7mqP0BjABHIg/zfinc/qBubsHd1XBhOgzzYQW5QDzFMIH5vTFRH0um8ktAX7Cza5x1lKwxwSUETnB2QNENC4IDcgPpcOWMVt1EZym3Voj6TztF5ifquvyA45mCU2KJ0Vx3If21wU0o/FZpERcdwfpoB5qvfanB87bS+zvMPm45VhZ0UGh9ldEQXwqv4hq+osGlY4HkLDKU2unOPnZIs0Ol489P/xozdQ3UiXAg2vQw2Ouf6nhenWYVbHK0qHtXkUvYRtqGCXmkBJ9EgVy+CAe76t9drlifwoYL30PKLU2cwV4BNQ4sWkjdYGGFaW73LDryM655UC72vRKHiBYbTOLW6BTOtwS5UOeoaTBioDwl/xk1gg9XnG0thu44Z8aIBzjAiwcQqM1unnLqOLgJnpdz307QeKKTmqcKD8KEJEKq
 0jU2p5FX
 HGD6Fc4sDh//YAGZxAPSjTHb6epCheWjM92LXDIOAeWiHTQfHf/IkIQ/fSl3XWID1oaCje+B7Sq5oZHZr0uLVdpZU3G2JbSdnbXlhwvY11v5+TPeBqMT0YNjxKNWDgL6gi1aiHqypZJwNnyTYMPDcIt/+4sgsSpAuSkJ3k1ZR1ye+qibLf/8tFxFl8A6hS2U1Pb/9Q+sFcUQrmyrYUWN73eENjom77TnImA4w5gRyK8pRQU1xdefGzk6kkhzhOUQTC6e1QC7hyl2bifDIrkMDx/vSAYq+OZb/o6OXTpxPl/3bUhZHQl7B5LsTbhF2TdW3dZVO7ufWTf+uf4Y3GIpoHHGjyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 20, 2026, at 10:27=E2=80=AFAM, Vlastimil Babka (SUSE) =
<vbabka@kernel.org> wrote:
>=20
> On 10/19/26 08:45, Vitaly Wool wrote:
>>=20
>>=20
>>> On Oct 18, 2026, at 6:15=E2=80=AFPM, Harry Yoo <harry@kernel.org> =
wrote:
>>>=20
>>> On Sun, Oct 18, 2026 at 06:03:15PM +0200, Vitaly Wool wrote:
>>>>>> How about we take my patch [1] instead since
>>>>>> it isn't prone to this bug and is a nice optimization to the =
existing
>>>>>> mempool_resize() at the same time?
>>>>>=20
>>>>> It is not a good idea to squeeze a bug fix and an optimization
>>>>> into one patch.
>>>>=20
>>>> Generally speaking, yes. But that patch had been submitted before =
the fix
>>>> popped up, so there was no sqeezing per se.
>>>=20
>>> I mean the patch you've submitted does two things (wihch is not =
good).
>>>=20
>>> It should be split into two patches that 1) fixes the bug and 2)
>>> optimizes it.
>>=20
>> I don=E2=80=99t think this is a fair statement. I would say that the =
patch I=E2=80=99ve
>> submitted improves mempool_resize() to be rid of unnecessary
>> reallocations and data copying, and that (improved) implementation is
>> *not* prone to the race found in the previous version of this =
function.
>=20
> But it makes the code more complex:
>=20
> 2 files changed, 28 insertions(+), 16 deletions(-)
>=20
> without an in-tree use case.

It does help bulk-zoned, e. g. on a device-mapper table change that =
grows the
pool.

~Vitaly=

