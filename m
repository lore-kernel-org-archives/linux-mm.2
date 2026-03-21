Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A156E1099B4C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 00:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB17A6B00C2; Fri, 20 Mar 2026 20:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ED4E6B00BD; Fri, 20 Mar 2026 20:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5256B00D4; Fri, 20 Mar 2026 20:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B02A6B00B6
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:08:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 158F2C1BAA
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:08:46 +0000 (UTC)
X-FDA: 84568134252.01.E388F6C
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf10.hostedemail.com (Postfix) with ESMTP id EFD9DC000E
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:08:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b="UFF0HC/H";
	spf=pass (imf10.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774051724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBghYJ/F/Pt0HxiS5MRMUDhDiTzAi0jLjVNvoL6gXyA=;
	b=zIiRNxNNh+bEVg/BSCJsIAtxyGbGBBYmFk7mNccIo26BZhTeuTbplIhWjL9onVNILf9l2g
	nje+L5vWWG1WsKeQNIx9isi9SkxgJNkcYxfqp8vR8GYQ1R7jcwATZvrLQ2yv5SlDAU5sGG
	knbLNAcKjWx3j8bI/ApWgMaFBJLUhXo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b="UFF0HC/H";
	spf=pass (imf10.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774051724; a=rsa-sha256;
	cv=pass;
	b=t3oZzbWLvhfUUce0unzuM6wvDQN8sx+spo5X+kdQ+4SKDUXySCIASpCrnuDMIa2RTOb3hX
	rPsZ288M8elbTcWuEvlj2evbMOD5gX7wxnCV0NY5arRtK4cB+2JrIA2nMMhCkXqyYF5ORA
	xGrAyRUQ2PhDrUcbqF/i7gYx6FqoBto=
ARC-Seal: i=1; a=rsa-sha256; t=1774051712; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Ot3VSSaZu3w0EJk2kNRqcxvTnv53LkYqqERkISePoWgewkbjZbAwV3h0F+F+2zyIHcUe8XdLO9DK7O+im/Ktl2D8d51WLN1ROhFKwy3lLynJ5tQ3ywwRNMpqTV42JLsWSYbg+FEomTozA2NUoNR++OWHaA7fI8CEZtWMJ1kwJVc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774051712; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=pBghYJ/F/Pt0HxiS5MRMUDhDiTzAi0jLjVNvoL6gXyA=; 
	b=dlUw2tbsGohlZLAfHNQr8yE62OnPQB7Q+BDktR6gZaNFmD/TgTERvxcf6/9AngvudjSElPDlC1BltmoXAqvEs8EtdJLD9VHSmAv/oVIK5xY+ra94dA73UUWF8MR6yglL8VyzxQSD1TSBsCWSkVXFyQClHHXafhukEfbj+nAufuY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774051712;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=pBghYJ/F/Pt0HxiS5MRMUDhDiTzAi0jLjVNvoL6gXyA=;
	b=UFF0HC/Hr4z/DfDIlT35DNLMP6jx54vRe9xKtJZYe049HIW4Ht9JEjtUrwUyGx0b
	uS9q/yTnXxipvs+OOCfijUZrsVAAowtga3hS6R0ykOSMp51R14d2ifptodqEyWOaket
	6rhjvNL1gHASnDAcY0NE7ga7zSDaugVPDaUCs5Xw=
Received: by mx.zoho.eu with SMTPS id 1774051710629882.7436884050414;
	Sat, 21 Mar 2026 01:08:30 +0100 (CET)
Date: Sat, 21 Mar 2026 00:08:29 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2=5D_mm/damon/sysfs=3A_fix_param=5Fct?=
 =?US-ASCII?Q?x_leak_on_damon=5Fsysfs=5Fnew=5Ftest=5Fctx=28=29_failure?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260321000255.102944-1-sj@kernel.org>
References:  <20260321000255.102944-1-sj@kernel.org>
Message-ID: <6902CC73-84EE-4C1D-9FC6-F54C7C378387@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Queue-Id: EFD9DC000E
X-Stat-Signature: 884in7kjteb4574u4khd5yn5bg474dwr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774051723-989458
X-HE-Meta: U2FsdGVkX1+ztwQzXBVkmzevIVw1raMsjOJsXU8UdxTgkE0uaanTVr56N6vb+wnM2K2R2JOygdah/Ey3Vs3FEuzpxQrCEbUCslTv0cMiXPp015+13QZyj+XvRxkVGrQr/hweSitTgalU4UlBrroZr8xZ6YufgftKhIsIHybvE78dkC8m+jJvuGiKjVZIf1KeJCH9STn5keE44h+9F0FsOU8+vm2dy5Nl/tXiEwXqewNc+xlHi8YQwN9+IowvBXKW+bbUEd2iHh/v/KCJNNjgDUAy8+kzix8KGe1znZBYEebezy50zU7ejBtif+2nBAjU4k4fi370/0PKmoc6Zw1ErI7xTLJlF9ymfwQpc7EufwssX4sgNVeBDKf7mQxHusYk/9lD/D6L12RpdIFRh0/Ocrfb9x/23UDZGCt0Ag1L7vNt4O7/MxuEFeiZxRYSvF+1lf2tpjOIeBwVYnvcs0jH6WsgUZzP+RF11jvWZG7aYYHEPEr7OcgjjCQPj0rJv5xtk7MdJPudnrZOPtNIpOXg/enZ17qxObcZ19o/BPNKxDhwToz/44AFLQrz/CzJigt4BbytobByIWn6/tnQ+uTi63Nl3KHMI84OdGGy6kGmHyewFnRqe+gwgJEkBnQ53WmXW/9CjlGt/O0aVPpY7qeJdJBp5ePYyKalRAjSrqJJW7I2fCUlVpVpZIgcKrs+Xn+UeBzjyVd+1dtKY+0T7Ry15A5OqsXAsE+ff0ixNsgQqZoZoffqyAh4g+CPURXjYSxS0ip8wCpT48DtoOIlh3o9jmRbXamex3UUcwuqmVblzH4XRVoBH/lV1UYtb8otaAzwTtO9PqTc48gLpTCkrT7g6UTPqIN4B9Uk1RAgCTG5649t/fRAp4EFGKWycX6m2RrjPnogvyABbDBUo+9DyM1uUm2MESj6vzdFxn41sFBe+u/QFVmeP96ai6wzugliu8N+O+OzTF7XHdSyG52FAod
 JTHWR/wA
 +aREsgvAzwW/OWTrn0kQDZ9Sne3B8jyvfXLibfXrbQosBp62de4vyBC+7oF5tJNv7ZuANYOrVpr8BEMNmds7i3TjpvYGjXuT7uU8cv+jmCA8rccy5Ep2U3t91+HcjUM0IXKMPq0Q1nM8CeH1UP5zbbPHgGHsOrzmugVilBYyloh2KJ4xisAMSym85ZbqxoonevRsV5TGt9I7hhxiWn0KWmC3lajBxxt+KvGRJr9YBE11xD93N+W1clJviaamuu46MfGAQmS+50kr7glw954XbcU7LqmtOsrlYUzRq/3Enn2S+6I9SbGqSFF8H5Jtz8BbD/cXJGOoMNqT3MC/KuSJTmmTiTc8BpSMIU4kUcftwwRUZDsWLQe6yX/s3Dizo1OYpOaRl9GcvZVbcC5cuJvzff5s20MlvTF8przQ7TIDwqTva3oxY2sO2ZdQpyrJPorVDBZingzA4Pb51e4SyOr37/VcHA5SL+xg+lvuLmFIA4oElV9nFvmirboMkNEyKa6+9L0bcmWcWyjWZ58gLt+Hc4T4qDKVn189VbycZ70wAGCEdW/c0JIChDq2BHOS9N1+wCoOXGmgW1s8xsr3pd7NUP582XQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 21 March 2026 00:02:54 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>Apparently this series is only by a mistake, and therefore a new version =
[1] is
>posted=2E  So I will skip this series and review the new version=2E  Let =
me know if
>anything is wrong=2E
>
>[1] https://lore=2Ekernel=2Eorg/20260320163559=2E178101-1-objecting@objec=
ting=2Eorg
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


Only the numbering was wrong, like no 1/3 2/3 etc=2E Im a bit of a perferc=
tionist so i nitpicked it

V/R

Josh Law

