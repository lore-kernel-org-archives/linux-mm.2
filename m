Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B1FC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73DFA6B00A9; Thu, 17 Sep 2026 05:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715936B00AA; Thu, 17 Sep 2026 05:19:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6548D6B00AB; Thu, 17 Sep 2026 05:19:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 420EA6B00A9
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:19:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0209F802B2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:19:53 +0000 (UTC)
X-FDA: 85222707108.04.507B195
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id C2197140008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:19:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=DicIUklx;
	spf=pass (imf09.hostedemail.com: domain of zhenghui.hao@qq.com designates 43.163.128.50 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQ/929b3BXM+aG41rDbwxkr0pM14Qh4yVfTaS4XVUAI=;
	b=hOYGq135yNFxnFmKtpIskPfQvHcLQEhgPpM4OlWWyuwhTGxy8/wrF/hHDv6DgHrsGV+0WX
	f1MvbC3fY3yu8TrogEeM7ajNGVOIBMT7RV1sIaEBGIOtTESx6OU+/8wTmhtxHc8Sq0zLhw
	wmB4REKWc5Ipd0SwlyGNMHlhUz/s1ac=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=DicIUklx;
	spf=pass (imf09.hostedemail.com: domain of zhenghui.hao@qq.com designates 43.163.128.50 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636791;
	b=HDJzmrG7qfRrk2sCKU7u64WiBzPwBFr2rBZaYeP+6U1z1pVVBDBkTgjmXRvWHgKLBVTeEu
	i9mREyXtCBBpVDtH1AFiPFHg1oUtNpPOyixvKJ/jdZ0CXDoNPfH4Ww0IZIFdM/qgxB9Xwa
	p79cJ9eKnYZHwjTywqOdO/auEC2cncg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789636787; bh=ZQ/929b3BXM+aG41rDbwxkr0pM14Qh4yVfTaS4XVUAI=;
	h=In-Reply-To:References:From:To:Cc:Subject:Date;
	b=DicIUklx3OEf3RMhVXzxD+5fVdmprJWSpoD/ylRR0FBpIOQtsGrEmoq4KIX073OLv
	 j4/favWUhiTPM9/5to23LFma/YrFvlLGcI+iR1g18YokapYdt53NEYQRXhUHpHpHWn
	 HwDg0FuAIw1ZvSPqwMTaV2iGtcrli1ClozJ3h7ro=
X-QQ-FEAT: oHWrrGTW1dCGJEu1CuC8+nIWkvSYK6n9
X-QQ-SSF: 00000000000000F0000000000000
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-XMAILINFO: M/7aYRxQgGxsZXeCbMYAWUelb60lOYUJYvqx6936emieKnrpY9QRsNjdmf+/sq
	 rNtkLhPANqaHq0sgZKb/WmpLko42XKqhQQeoIrKF3bYLHXOSJHJH5ytAIw/w+p9k762jdTPbFwfuU
	 yB77Ipwn0NvigQk8eEyVd50nwoCOnf/dfdSjYZaSo9w2+7hMiAxaUAUNSU+bWpoUbOs4HvE4H6Nob
	 EEs2kasCn8xXtUpF4eEhmWFhuiStgrzXLY+elartIU/aHLApOH7TLNLZUYATyZDpxtsW/6fkVdOi9
	 ut4EfnGr1J0Lgg64K/PP0mxnUI15muDDS5u0FVwlLtk0gEoZD81oLIRG2NST4bBnB3ll7nOvW43zW
	 hUncG/wMumbUirJ7Hs6ZsG1TCL13WAmWRXVUx6imr2i3nZacyNxx5pocrGIIxz927CafI7KO7GcFE
	 /xzCY+ic/RiNNGX3L9tf+T8Us4xWGY7SJjKm5oRKj9/tmPc6fsZ4ZBxzc1qnd2F7vSYIxv1FRQAoJ
	 ZcK0zdlspcIgB2qf34XvoZWIE/mQXLOeSx1Yah6tyO20r1FnqGkW6rSAqUJ9WIhL4zVpKr9dB4pWB
	 WEuliBpZEuil1A5shW/wyBoxMS4tBAGcL6NqbOteZBFa3dGgicTAkvYtI1Jzf9s+v+guZYYa4xhfP
	 0vxhbZPDqpt4v4zoMZmndmAT+qeh6mqEvHH36rmSPHsFxmDUDFK/umkBGGlqEx27q5mPALBYhrTZW
	 W7D5mh5nnAjutznNUfbOAZR0CBCEHjJO40ZcjNi7jsjrmngPP1rt5eTk1/RJtaToZ6EqfwNBCGyn+
	 Jv+hPlYMbcyVZum5Riv869QexeivzkGtLiV9DipfGyPJCdEZJonnBXGilleScBcyHPdbL39ZdmN+2
	 pu2vxqmYltymNmj57Rqpeyp/Cjd4m+YTgKHDeDg+4ORVMoX32cHt2cJDUVQMn4seFJPodfB5u4mbP
	 WsEWUm8eDvBk9P/DqwT5yHd1lAIUfTT0+ZDiMq9/+N7BdkdMiw4/8LydETy0/3535w/UcHTZjqAwj
	 aZySe9/C+3oxtVbO+R+hTVfwO+KKUKmFSOgx7Z2HCe3OEj0y6zLese1RE72n4r0MhLvpiSQ/dizRB
	 F/o=
X-HAS-ATTACH: no
X-QQ-BUSINESS-ORIGIN: 2
X-Originating-IP: 210.13.192.141
In-Reply-To: <178963086483.2200502.14463144472620315064.b4-reply@b4>
References: <20260917062837.558251-1-zhenghui.hao@qq.com>
 <tencent_0490E1CAA4336214AB70F813325F3020A608@qq.com>
	<178963086483.2200502.14463144472620315064.b4-reply@b4>
X-QQ-STYLE: 
X-QQ-mid: webmail339t1789636786t633797
From: "=?ISO-8859-1?B?emhlbmdodWkuaGFv?=" <zhenghui.hao@qq.com>
To: "=?ISO-8859-1?B?TWlrZSBSYXBvcG9ydA==?=" <rppt@kernel.org>
Cc: "=?ISO-8859-1?B?QW5kcmV3IE1vcnRvbg==?=" <akpm@linux-foundation.org>, "=?ISO-8859-1?B?bGludXgtbW0=?=" <linux-mm@kvack.org>, "=?ISO-8859-1?B?bGludXgtcGFyaXNj?=" <linux-parisc@vger.kernel.org>, "=?ISO-8859-1?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] init, hugetlb: fix early parameter ordering
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: base64
Date: Thu, 17 Sep 2026 17:19:46 +0800
X-Priority: 3
Message-ID: <tencent_770E6207ABD8F875322130E7A6D5E1CDA408@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C2197140008
X-Stat-Signature: t9wqmax3dmxymk1kt1h5nq6631bfxyq7
X-Rspam-User: 
X-HE-Tag: 1789636790-89404
X-HE-Meta: U2FsdGVkX1+odbC2sy+NBAEV/E3z3t8VA4lndymD+PN0uXV93AedJXDQHnd1PTPQjhxJHo0uyeG7gqdm2IRfRCpeLcPu0iczkhtMxwqsan8UZZpOJm5imYKu94B8t0m2wbvP6Us3Em8Lg1iPUBY9ErI/upwcOoc/pf/OFV+VSHz/JtX56PhVMgu36Z9owQmwUs5L+5efxhNyqznIA/zUHWNOPy0R/Y0+/0mxKxduCG1dmyPXk9m4tyNNMuJVZwy3owu8o/AQPnAQxTpkUuYg/Fk6SDrt+eBLThqPGxdTlKvUhVr0BWCBQGTqCnAKQ/4NRF933BORgNj0VeJ9ct0ZA7yOCJwtCD/Y32uBGsA6QSV2pRiz6qjR21KGRMGKjM4VsiAvtcR3/Q4jBDO0xzNNnz0P/fyAmn0zf/1lsb+/SjpPUwq6yjGh/frlyf2xxCqEl1qH7CQ38BTypZVrTLVbPxlRte3FqGjbvBHUmGyoka74D7pmfKAGjFoN+5U2Dksqq1WlQM2h4yEQ8r0jChcPlWxhNfvCaKWhBs4jSXE+vO8E7bP2tyzxdK8uYa395BW4zTm/8TR/XtYBaTyQHDyOtTrqe94CWWrXtCAghLCqFXjpVA0609iYMiKRjE/Yem14tUr4zzpqQo5l7Ex0BT9z9zClrEUEL9wo36TORzh+VxA1bP9+GMuRotJrlFC91C6WwO94rzigO0JQEo4Y9WOFFNU233tMaTt1vfv7vH0dZxY8dPME9U/c1wM3HGGRYO/3//oBrxBMWU8kPmE9oy6g9B27efAspGcL3C9Gsn0W89yoc+XMSvubeDaS9Q2h6JiTiS5WlPyEQfTQeG5MIgYuXfIViYU1pl/fUoCIv4hwF3KRKkp2nB8dwbUqL4e9PpfucPt1EgDv1UYChLZ649XlM6xBJOlTwIazYvEifp/jtTHfKUMk7fD6iZVkfVCUgOXYRmkBHjENKu2Y3WrsDIb
 Hz4gDnK0
 rjuJVoYE24nWudozcXxOPQqzsjBk1qq1Kr0tCRp3hAlUz2cWWUTrwgVsQk5jy2QUv2UC9rBpV3KYN5Q3hgCqtU7Y3jbe23Ikh5oxn3lt0UsFNWMdgy5w3CFtJZbV+hp6i4BqKdsJ/u0wqfEd9ij9THOKSToshf0iadHE+o6HS1bepXe9sCzrKi9cKOR+3/0u2msWgwY6S/UlT3ePUfDmGSrfCJl343nG7Q0Jxi6jhV7RimS8/+HUuW5BAyeF+dwHl7XNZQb5YaA35Tfz5+yz8lcx9VO5cJQ5V8cC13jsvNFv3m/7vp/ZGFw53zVbAnXwUdkt1z8X3J1dx9Cg2gMQnAtXsm26vAqZ8wR8mw1bB809raDD1wJhrZSGc2MSgXKu/ViiuV8D+2rMalsosbOcmsc3p2wdI1EzDQeNwPhDk/i7PyKR2ylihxUpTY6DbKwsHhXDZaa2yb/9X4baAwsjg4HLA6BH6NMcBpvlUI3Wmcc8NgZ8EsgxuO8GPwaMDerkcqXdXA4J6n18QafLFHIShJzo8Kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGksCgomZ3Q7IFNpbmNlIHBhcmlzYyBpcyBvbmUgb2YgdmVyeSBmZXcgYXJjaGl0ZWN0dXJl
cyB0aGF0IGRvZXMgbm90IGNhbGwKJmd0OyBwYXJzZV9lYXJseV9wYXJhbSgpIGZyb20gc2V0
dXBfYXJjaCgpLCBJIHRoaW5rIGFuIGVhc2llciBmaXggd291bGQgYmUKJmd0OyBsb2NhbCB0
byBwYXJpc2MuCgpBZ3JlZWQsIHRoYXQgaXMgc2ltcGxlci4KCldoZXRoZXIgYSBmaXggaXMg
bmVlZGVkIGF0IGFsbCBkZXBlbmRzIG9uIHRoZSBhbnN3ZXIgdG8geW91ciBzZWNvbmQKcXVl
c3Rpb24uICBJZiBodWdldGxiIGlzIG5vdCBuZWVkZWQgb24gcGFyaXNjIGFueW1vcmUsIHRo
ZXJlIGlzIG5vdGhpbmcKbGVmdCB0byBmaXggYW5kIEkgd2lsbCBkcm9wIHRoaXMgc2VyaWVz
LiAgSWYgaXQgc3RheXMsIEkgd2lsbCBzZW5kIHYyCndpdGggdGhlIGNoYW5nZSBpbnNpZGUg
cGFyaXNjJ3Mgc2V0dXBfYXJjaCgpLCBrZWVwaW5nIDIvMiBzbyB0aGF0IHRoZQpzYW1lIGtp
bmQgb2Ygb3JkZXJpbmcgcHJvYmxlbSB3b3VsZCBhdCBsZWFzdCBzaG93IHVwIGluIHRoZSBs
b2cuCgpTbyBJIHdpbGwgd2FpdCBmb3IgdGhlIHBhcmlzYyBtYWludGFpbmVycyBvbiB0aGF0
IG9uZS4KClRoYW5rcywKWmhlbmdodWk=


