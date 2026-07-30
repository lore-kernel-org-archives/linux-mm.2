Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8B1AC53200
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 01:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2406B0088; Wed, 29 Jul 2026 21:31:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52EE6B008A; Wed, 29 Jul 2026 21:31:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96AA46B008C; Wed, 29 Jul 2026 21:31:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75EF76B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 21:31:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03A0BC0824
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 01:31:04 +0000 (UTC)
X-FDA: 85043714490.22.F6AB311
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id CBA5EC0003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 01:31:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ugreen.com header.s=pkvm2402 header.b=LFeRryGV;
	spf=pass (imf22.hostedemail.com: domain of warren.xiong@ugreen.com designates 54.92.39.34 as permitted sender) smtp.mailfrom=warren.xiong@ugreen.com;
	dmarc=pass (policy=none) header.from=ugreen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785375062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=Ep1ctFJIAzLpSpUs09zKmwgmlhBGSpje4JqI7d6UWLI=;
	b=Q98GqAl4VKwECqnIwFDIcBX/I+8o2RtspW9rAV/xqii20C2z7n1oiYTjlXachWwcks2DNN
	HC9gMVvr8e2rYDLVSPX/2ihxdHvAYMC0oL9T/VymePExtBL6jraaUXvjZyGA7DxY+4ew5p
	mDxtnN0p47IvKeQzEqjb0pq+eLfBmy4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ugreen.com header.s=pkvm2402 header.b=LFeRryGV;
	spf=pass (imf22.hostedemail.com: domain of warren.xiong@ugreen.com designates 54.92.39.34 as permitted sender) smtp.mailfrom=warren.xiong@ugreen.com;
	dmarc=pass (policy=none) header.from=ugreen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785375062;
	b=0DC0ldbidZvs0yGQBt0jmE72JmUZA/GLWDzSJUqvpWthXSELeKb9rznNUQtETu1S78/kqW
	y+Ea8cHSN/vOj1z7RGi8PJVQTuOPg8PjZ9NPnyBJwEm1gI9OPjXYI/BFI7WA1+F/KIA2pG
	5SGygsEaOCe/KXMkdLAOIptNWhFJ+2g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ugreen.com;
	s=pkvm2402; t=1785375056;
	bh=Ep1ctFJIAzLpSpUs09zKmwgmlhBGSpje4JqI7d6UWLI=;
	h=Date:From:To:Subject:Mime-Version:Message-ID;
	b=LFeRryGVzi4Vp4KwC0mcP7JVIxAy8hYJ+ijFApf1CYBPKFt9QcZeI/KfhPKzVvl5U
	 OUxPlgoyr3CTWcN2sI1uUvPs7IRW4bbGEn8BlsbBn3iPtsMp0Y8s05vk3cUrqNbsip
	 2FqNGw6mdwGhefTukKUt2K5xwC7NSamuylQx1kqc=
X-QQ-mid: esmtpsz10t1785375055tb569efff
X-QQ-Originating-IP: 22dtDdb4cVWnBj3SD5YMRO1MS4Yt8TnI2QP7cdsr7gs=
Received: from DESKTOP-0F77FNS ( [113.98.201.214])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 30 Jul 2026 09:30:51 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 8734656876725602508
Date: Thu, 30 Jul 2026 09:30:55 +0800
From: =?utf-8?B?54aK5Y2n6b6Z?= <warren.xiong@ugreen.com>
To: akpm <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tools/mm: prevent page_owner_sort from truncating input
References: <20260729053812.882137-1-warren.xiong@ugreen.com>, 
	<20260729173138.fbc115b5285e1b465b055de7@linux-foundation.org>
X-Priority: 3
X-GUID: 61322DCF-8E67-48E7-A106-D9FA4C8DC271
X-Has-Attach: no
X-Mailer: Foxmail 7.2.25.492[cn]
Mime-Version: 1.0
Message-ID: <6F7F6EFFF40F9C63+202607300930523706768@ugreen.com>
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:ugreen.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: MRPQukou9wBmHD9i7zwp0rKKeTmqnDJXnxkETNsxUjcf3qLzDQXjsy4+
	cLJbyD1BV5M0oOcpTQtCwgZtmINKKssqeYOiucerGjv5DETQ7+4QmM4vkMWu8y0BKI9mzjh
	r/GGv+nSavYTAzBGkkyT1RX87882VnfpjXQa/ble/PkNycZqAcFLWvKFxgzIiNKT9viwtwg
	QU4pD5eb6HjgGUnHSGxH2xYdOi6HqEw8LaxtY4dXdYbjFWWvNKVhdybC6ZVlh079ep4U4P0
	QRiVoz16RojWrqXJHHUvIUij95LuXB0Xs/j35DOkAMMp0EoTTjZ+4fmk9T/UTaNv6/GmrJV
	xQVTSVK7B7JnN2ejct6EffCUeSe/E8YuKwEh0kRa2ZvKTPBNjjvaQlUrc0loHWAnUEdYbUM
	F1ZcD32N5hVBePTVNu9eVL+ogIddR78mcWBwoTeQBqOUQYbKo6lbqnyYDb5Mo1wPq7ad8Vb
	m6CuajSPDhxBfFO7rlRWK9CY1a2USDC02hGJ4sjZIQVDKReeQ9MWvWdbhW1XtyWcUQf0yHy
	XAzsdlH49B34zD8Nb2ErF1ASvx6T/zWnEa8EOlfxOxfGk0iHXud8cplgkgAZxTJ9V1GuBVt
	3OvomnD3mIa5tPAVsLfJ467O+jsPVX7Ni3xOYH+SZUCkL2p0bcVJZsdde+jAclUuUBzSAmD
	8DMFKdfSfZDGPveS6xSaT5xF9z9b3A88XqKa5goTLkqMFWvN6zzw0TsAsXAfJTyiLCSSzXf
	xuTiiOxgTaVnjwNdOht9QnGoPikQ8y5mRoCbAj6i6ja5VBB81V3pw9r6gyfZo4XsB4r/xJn
	eq0qcbmRB7iiZ5OUlgM6/qe8Bd2Dz3i9lGV+5cFb4SNquWUfJ6WVimrlCxzP4TGx5LrLgBI
	65cAAmKFUpGfEad9Ptn9a24sV1ILgQQR4zpYFkl4326bofzdQfpjI951FeBPC0oo7Ong45i
	/rQ4kSB0orsHEQw8YQPdLJJBADGYzeneNVF4=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Queue-Id: CBA5EC0003
X-Rspamd-Server: rspam01
X-Stat-Signature: wor595oxwgwjhxqsacb7h91c7nr7asne
X-HE-Tag: 1785375061-433339
X-HE-Meta: U2FsdGVkX19s5Y8aNw8up/SDEr/gZL5eM8MY9UOoJC2qxsL1/s/PCwEgi9YHKEBdcMPzwy92g9YysfXQnVke9pI4TilgzH2yn3X15jZPp3Zmp5tpu96vEojbNB45Ei//ZFvFlN1PqpQcdO38Nl6FL5YuzsNhOLAk4YBG3mvzdgLqj7Lub1e5v/R3CCQ0Vxe2zAXEk0mg0MbvDqdWllaNtVUbxcia9J0yoV+Ofrx0DtwqrInk2Y1yXucpZD1hz+FNLsq5JYwyrhVhK16wYu7ZVJbOOaQu7R+CeyC8oVqnraQXepjr6VYYHVggKRo2O1YAi+nfU0nNlPyCpgXgk5WRVhiGKYsnh0JFLwwg6fKmW4S2UCaVlcgHg3+LTQgIi1/aliCU0lZfOMm/QkRnnHwW0PES+wGMsH9rCEUoaxQ2MYTDv30Fuu7TQdxp1+7/sQXWKg0PzCTzP41qRd2Do5i1USzfuUUSAp8QKmKBeRxKbq1UtLLQFJ//J9tIkE6NEtf5EaAtOCqih/OML1l+jL/frbWX88skdFG9emdrFLo+s/u4B9KHZRDw70iIAYqmdfERg6gwzK5wZ3YFcvKDZXchK3LTMQibk3c0RcO3etYbXPOI7H6DCWcV9oXJSaFKh8tlbw8Bp8q10z2gGN0epeumvvwm6lQX1PFoJ7xR3plyI2jCDr+YjadVOUaYnFC+Ny+/NgCwyn/8sMkaDGRBU9T8XDB+3MJMwmcfxflOIhik986ip2Nr5BxdaZ1Jv15HYDCWB8+fas9L7SpXE7/qGBtGn3IYxxk1natq9H8G5ckRaVcVQbUIrTxdanaX38JdsbW4Hw9DdGGYOakag+2Cy0zbH6Uzt7hPNA7b/jfH9+rZAMNuykxImWQOZrGmp56Not3GOFmjgt2qvpw3RHY3FW7RHoauboEYEES+YhV6wbdzxKmdxgPMc9i9gtrgcPpF9lgFjXYtpgF/u/DkDbFmP3+
 7viRpku8
 khByuYUMRUu+c+/uINcRiBKbt2JAjTrA3qK0ik8jrT1iphGb4+t93Uiq3iWjhEzcC9YtdqpUii0QxybYyA0wLCxCC7c9N3JxRnOgvDFy28UF5+VS73tIsftKcjjq82zZzkGFzXu02g4Ak1JWgCWeJK09OiB0os8d0WkkwOLXtZiT8UNlYsQ0KIA5/ZXRb3CnUkv+08xVdqkOPIHmgeTNDu8JrwEUa+MJdF2BJqWnnZ/Ysh1hLQF0TrWvIVBkKwRBDGEK1vVv/rEO81BsevL3Oj2kH3VxF/iawzRPsia45QzHJQ1P+NaJnP2gvkIZmGWEEHUVuDaIEK3j4XJp7dwbbO5J34kVdYwcMs1jxDUqrNFuSAZE+SPLgasALPYs8fI2wEK/I6JFmfFYm+KPh0469XnGLVB9nSkpKqIGaRHGUo5bHfhGqc4yCCXRH0UcOSyJG0VGxCQ6R2I1ly/sA13WcbRmIYmwdZBBZSYbPe7cIGNUaVmFnpH32WQR7mrWAemseildk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBUaGlzIGFsbCBzb3VuZHMgY29tcGxleC4gSG93IGRvZXMgc29ydCgxKSBkbyBpdD8gV3JpdGUg
dG8gYSB0ZW1wb3JhcnkKPiBmaWxlIHRoZW4gYSByZW5hbWU/Cj4KPiBGb3IgcGFnZV9vd25lcl9z
b3J0IEkgZXhwZWN0IHdlIGNvdWxkIGxvYWQgYWxsIHRoZSBpbnB1dCBpbnRvIG1lbW9yeQo+IGJl
Zm9yZSBvcGVuaW5nIHRoZSBvdXRwdXQgZmlsZT8KCkkgY2hlY2tlZCB0aGUgR05VIHNvcnQgZG9j
dW1lbnRhdGlvbi4gSW4gbm9ybWFsIG1vZGUsIHNvcnQgcmVhZHMgYWxsCmlucHV0IGJlZm9yZSBv
cGVuaW5nIHRoZSBvdXRwdXQgZmlsZS4gcGFnZV9vd25lcl9zb3J0IGFscmVhZHkgc3RvcmVzIGFs
bAppbnB1dCByZWNvcmRzIGluIG1lbW9yeSwgc28gbW92aW5nIGZvcGVuKCkgYWZ0ZXIgdGhlIGlu
cHV0IGxvb3AgaXMgc2ltcGxlcgphbmQgYWxzbyBhbGxvd3MgaW4tcGxhY2Ugc29ydGluZy4KCkkg
d2lsbCByZXdvcmsgdGhlIHBhdGNoIGFuZCBzZW5kIHYyLiBUaGFua3MgZm9yIHRoZSBzdWdnZXN0
aW9uLgoKV2FycmVuCg==


