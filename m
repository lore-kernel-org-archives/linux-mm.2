Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D7ACCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 06:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1DC6B014D; Mon, 19 Oct 2026 02:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3826D6B014E; Mon, 19 Oct 2026 02:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 298276B014F; Mon, 19 Oct 2026 02:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04E526B014D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:46:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A5601405D8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:46:12 +0000 (UTC)
X-FDA: 85338441384.18.0D8E01B
Received: from mailrelay-egress5.pub.mailoutpod3-cph3.one.com (mailrelay-egress5.pub.mailoutpod3-cph3.one.com [46.30.211.244])
	by imf20.hostedemail.com (Postfix) with ESMTP id 294271C0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:46:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=zWPyn5VV;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=u1wLz4gp
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792392370;
	b=owaEui3GtyorfiYmagglTNtuMby2Z+t7eIY+7xflNp7VKElsOFrKmdDeBFLzqDD3EGpwrn
	/eylhsyX0QqPBTD0dco4HwFQk87+Ke2uES+9l5bdh1AKineJQt0coUoSUDguw2Pz+ovdn/
	Bih7sshHb3t4pXQ0wXy1gUYDs7z1o2k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=zWPyn5VV;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=u1wLz4gp;
	dmarc=none;
	spf=none (imf20.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.211.244) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792392370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIc5wdBzF7Eo3TwtmXp7N5ocviEXanEWtYba1s8mAqA=;
	b=Tq5u9qf5cnbtfzRH5D9fyqoW7SkpA8frtO2CzPCeQXM8JMCsIjoXFrlCxR/5xMPbgzVvKn
	jCGfoxsEtc9A6zKKZdxsDWCgR+RbVccQs++WkSReu0wrl3RhaDnUuhglaumYVAlZ3UO2Hu
	CGFW7HFWW66t0Zc+MaGWONfaxrO+5Rk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792392367; x=1792997167;
	d=konsulko.se; s=rsa2;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=ZIc5wdBzF7Eo3TwtmXp7N5ocviEXanEWtYba1s8mAqA=;
	b=zWPyn5VVjxNThWaLK3VxKa7MX87RgJsHeauOB2NOJH4XAfhq9lv3QPM5Bm2nAinxdLmxBmFJUHcAw
	 vtk38mk9Bfx9a1RR1WDTSxWYewtbh4MmDUn5BUKq5vTg0vIId9boD9lnWW/1XFueXGKR/Mp2GB6qch
	 hdPJDdtSrvwaDd8MOzUsgebYw3zkqCRWdxKYZDtTnqiQM7CfO+TL5RZzcPGDKgpjcGTMeRXFl/rBMv
	 pvcLUa4PZQlKWuc/xq/RrnyUNwlztSQjfSgdvjY27cb7r3JmysniqrET/TluBU6rSHH4IDFugYpKyp
	 vIw+b37B0VtFGktR5E7YhL1+mPHFFlg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792392367; x=1792997167;
	d=konsulko.se; s=ed2;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=ZIc5wdBzF7Eo3TwtmXp7N5ocviEXanEWtYba1s8mAqA=;
	b=u1wLz4gpXoUAuJpMAj+IXFrZCLOqwGRpq8AgLAk8C0dgc/x3tuGTB7PUcQTTs92W7dTnVy8FSTPOh
	 emqdoNdDQ==
X-HalOne-ID: c17ea4dc-cb88-11f1-8312-1db1c303b0c0
Received: from smtpclient.apple (h-158-174-93-34.na.cust.bahnhof.se [158.174.93.34])
	by mailrelay3.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id c17ea4dc-cb88-11f1-8312-1db1c303b0c0;
	Mon, 19 Oct 2026 06:46:06 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array after
 concurrent resizes
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <atTv1tg9q9n92kZv@thinkstation>
Date: Mon, 19 Oct 2026 08:45:55 +0200
Cc: akpm@linux-foundation.org,
 cl@gentwo.org,
 hao.li@linux.dev,
 hch@lst.de,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 nickolai@csail.mit.edu,
 rientjes@google.com,
 roman.gushchin@linux.dev,
 vbabka@kernel.org,
 vitaly.vul@partner.samsung.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <F846CE95-6D2A-4D53-9C09-5C8630E2C8A7@konsulko.se>
References: <atTh-yyVIPQ-zNWJ@thinkstation>
 <20261018160315.1465504-1-vitaly.wool@konsulko.se>
 <atTv1tg9q9n92kZv@thinkstation>
To: Harry Yoo <harry@kernel.org>
X-Mailer: Apple Mail (2.3826.200.121)
X-Rspamd-Queue-Id: 294271C0003
X-Stat-Signature: 41hqxhmsppb7wpyj7ktuws4jsp4baaoo
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792392369-265023
X-HE-Meta: U2FsdGVkX18XE51OJo/pcY7WQsRkOb3cLFyNApyV/eLcQp23Kw2PfDSwsHhGZblSLYmGktM282jnTaZeHbzUKGxI/Cv9DVwnmSZOxyQd5kiSTOSvrLRwZVWM4MfjvoZU0NRdVopCBdzxe3t0KrN6hdaJ9m7BNkvRI1gt/f2vUvuwLIViF0mOiIpzLh3skMxrKaYHj76QmrON322zhvvMFSJP3XdVitmXlhBpiFDq7k5nhI2ddSwFt90iHxYJJgxiL3N7HM9tI5ZTP5zsw55xvYJL4hhVEgpHKPNWa+5gqfX/iQ4R7ab0BD7nTKUfa3u2WI1T2mjq+xf6hxZCuh3WfzArUBKqWKIDXGQm7jL9sgylQk3Qk+X5ID35+8b8S7hT3pFmnCfrkgSm8DPtIhTH4Kyn7Lxah6UWVR65e3/lfwkZkbBQ/pGrYbTrZ15pbF98s6G+Rapw3u+TmQ+WNDTeI3yoxo4XXWW7v7dwt462hIh6/rM3D0/G7fyOqOopz5jwwEFiCHhfgQACWftUspx5vj88LFwgoW82hsnuOIVi8T5ok9rKmyAvnUpeVxgLtwrBK/hY1QOieqAr2m+AM3kJAhlXVY8h/yWpgsr+hT+rMjHr2PG+qe1TQr+uvpOMUZmeU2NwlorGwJh3AebUd4KbcE2T1oDRUh0z6poWDQfsUcNNiPwTL3H46e9n4WrjpaJu91N1oWRnnBJGPtiYpRJmc9GIkije49KHaou5393LYgfBrq8eLCFsR9vEmwOAFT11KVREElmp5Ost1qjkL3yc3Kjpj1jqJF+kl2Tn+01phK/cpI+3t5WwM8pBX73DicJ05A9IfExbJbvgrXs1L2Zyw4ZrxQ0pJX8VO2T5a1t/A5B1C5pLEqenW8Viexhov5zdVuRSpm/hFKmpXqfG/5tjC8oX1rkiohStA9O6AZPclFhM0q4nM4I8Ur7Qo5F+6dWDhLp3x1qbx265tbk7qUV
 YWlEQjdZ
 goffMJq0QF2fO4mxDiES1RbYH8xvlJsAAIKKvpVXrpoYdw0zS3ExDYKJNRWc8/28IBO1u70/w0EkMElt9eswshWipuHBDNqzDpHNtxFmsXsXrBsIEq48HPjgn7l+p/ZtIcKTQ0gzMdcLjmw2M2F8iQCqhS9TLZfM05GUpd38D8J+knuZbKJ82thhv+mGJcc1amrq/7y2jkytvFogzPZUAQ7oMUy9hfyd9DJkInc/Xn33eSMPx58lmO97h7MYmMBqx7hAHCscj61BNGski7Gib4Sj7BoNtjH9V4nX0WgCZRAY/oNTbFBK6yjSDpIZ4d2W6O/J6cXnNhq9vV3T8qdabZzNczFEWhvlQgzY/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 18, 2026, at 6:15=E2=80=AFPM, Harry Yoo <harry@kernel.org> =
wrote:
>=20
> On Sun, Oct 18, 2026 at 06:03:15PM +0200, Vitaly Wool wrote:
>>>> How about we take my patch [1] instead since
>>>> it isn't prone to this bug and is a nice optimization to the =
existing
>>>> mempool_resize() at the same time?
>>>=20
>>> It is not a good idea to squeeze a bug fix and an optimization
>>> into one patch.
>>=20
>> Generally speaking, yes. But that patch had been submitted before the =
fix
>> popped up, so there was no sqeezing per se.
>=20
> I mean the patch you've submitted does two things (wihch is not good).
>=20
> It should be split into two patches that 1) fixes the bug and 2)
> optimizes it.

I don=E2=80=99t think this is a fair statement. I would say that the =
patch I=E2=80=99ve submitted improves mempool_resize() to be rid of =
unnecessary reallocations and data copying, and that (improved) =
implementation is *not* prone to the race found in the previous version =
of this function.
=20
~Vitaly=

