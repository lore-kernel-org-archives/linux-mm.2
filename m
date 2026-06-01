Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D93ECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 02:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D6516B01FA; Sun, 31 May 2026 22:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687E76B01FC; Sun, 31 May 2026 22:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DA66B01FE; Sun, 31 May 2026 22:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48D886B01FA
	for <linux-mm@kvack.org>; Sun, 31 May 2026 22:47:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6AE07120603
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:47:22 +0000 (UTC)
X-FDA: 84829807524.02.F5A8004
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf05.hostedemail.com (Postfix) with ESMTP id 74AD7100009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:47:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=i4uWgPWD;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf05.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780282040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0j5y4eHjA2s58keIUCJbqELrbC/VcqvqjEm+eO/tp38=;
	b=kHm4mqjec2PMbwI+NiRIiC2K3VTgBCSM5+WNBWSR/CviFVtCxS5trKQJ0uwvQYph2EDPET
	be1QFVt6E9DT2n1fAXeOGEqqrLJ4kV5jGAS1/EVjQQWPuc0g6Wdun1SGknQIVt7CmXtTBv
	OSRA9SzUwfMh9y6AwikqA/mQpaUG9fs=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=i4uWgPWD;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf05.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780282040; a=rsa-sha256;
	cv=pass;
	b=JFijZ21aRFnJZ5thKvZLiAAL0OJnKIoVxn2sLstJSsuhB3m5UzoJ6G43HF74XQdhVrZ9W5
	GrvYqMokGArN2Xtc50//HaUl+dLXhgbz7I3L8Zgf2AzniZnazKV4l/mT96A/a8dDxm1bbE
	cBFoBIH0F5wL+2Jcs72mguWN3/gRs/o=
ARC-Seal: i=1; a=rsa-sha256; t=1780282022; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=VhevDLX+jcvxZX+UlQ+Wxz0FCFg+LjBiWzNfXWyC6bp6Q9wQBLfvAwEx84FhSc/2nYZEKzb5DRlJDZSC+u9RX6eI3lcoTwaTP+bngDtffMdxgy0dHAfNBeTwuHnvSQlf8j9fVwRw11AyP6yxXw5XpOCkIiIvlEkwtWG/5/Z4d9A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1780282022; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0j5y4eHjA2s58keIUCJbqELrbC/VcqvqjEm+eO/tp38=; 
	b=lSbIdqfNnvt2r8wfFWL9TJ+mSRjbsNaoUAeAFJg3rV8UeQlrUH8z8wrM2DJBd7PlbInrPAjQ4JwEphoQnD7v2eRO2MXq2PDbzWRcJaeXyF4L0qVs4Bqqb8Svz7eFAY2K5Y3KGnaH4I4H5pxLkHOCyGl6Q85F+yD/E/pRtJko0Ok=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1780282022;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=0j5y4eHjA2s58keIUCJbqELrbC/VcqvqjEm+eO/tp38=;
	b=i4uWgPWDiFQiBL7nZhR4Fm2f/IlUPCFd62QikIjgStAEislo+YBK6vlj5POZsB6L
	SDFxCJQfURcxOAO4XbXQQHGZW6alw1m02iJZzYSa4l2UMWxuMeb+PCHrQ/VfjKbqJsW
	AK8cifPY6TEdUz6yVwpoT7hbCaJbJ8wLp6um5Q8k=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 178028202051664.08529719843057; Sun, 31 May 2026 19:47:00 -0700 (PDT)
Date: Mon, 01 Jun 2026 10:47:00 +0800
From: Li Chen <me@linux.beauty>
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Kees Cook" <kees@kernel.org>,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-api" <linux-api@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>,
	"linux-arch" <linux-arch@vger.kernel.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"linux-kselftest" <linux-kselftest@vger.kernel.org>,
	"x86" <x86@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
	"Andy Lutomirski" <luto@kernel.org>,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.cz>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Shuah Khan" <skhan@linuxfoundation.org>
Message-ID: <19e8113d290.893abab26142069.5024234139508454104@linux.beauty>
In-Reply-To: <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
References: <20260528095235.2491226-1-me@linux.beauty> <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Stat-Signature: et4jpy4n9khdbc1msnrt9sxnko91xg55
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 74AD7100009
X-HE-Tag: 1780282040-554079
X-HE-Meta: U2FsdGVkX1/LrROgXwPG5yNC1af4cWdRKsaMeKnXz/aa0uZpvVe7UWEr1PC4EY6TGFqO+zF07AiNI0+1wYFPs/ocPkEPEgmlIr3ajKYYo5DG3VZuh5jZBv34S/MWDeTK1tq0/EFi7JBtu1tjNN3SwQFwkdZccgdHnpNSXUHlL8XJvqYiuKEaYjexIUE+O08gHv3KvUj+WPv2X3sbvwE25KCttkNFFfVa60DmPMrMdZwXeDDCLUTqKhvUreXFmuw1ORTXxRocw0GAnqCwqnki09XmJTJ38I5iB74PWjpTDjVn8JDgPH2BuIvAE4rHAWlbjz3hetw7/MeMchwoIyx2+LBv32mLB891BsJ+4/Z6g9nA26OC7rqkwtfvwluI1XCL4aKtUVwmKJfJ9/MiYIMGCiK825oK4nnTvN3MChB9kuqhpNz4AjaiuuqF/NkUteUF/+ASTnnJuGV7GjayIm/XOqDkFFsVS30ww6qTrhxjLDQwCfJ9tuko021f9HXCZ2JVg2ZN09ltfiD8NxiRwzE1uPUuXaf2a2xQWEFap1IuhZ8VoKkKYeVBVIuSfoXFcba2mWu9yK00jOaZ8kpMp/Ia7/hW1CYOFNtrglrds2h26m8/PowVlr7LBYEEVf/+/v92YDUz1xhiVXK+wL7xkIcc35mMjp1LPlZhNW5Ru4lW05rM34dH9zdeosPR/yS/KBqyWMkBEGJUDi4EJQRcp0QYGDi+M03QpDdSgK3bAAMfirG9MAv5e4FF/Q4h1Ra7/W4oFOFi6bX9rvrV7qWwa4eNs1OeuGr8wxi+up7WFUhPutxziF/KbJugVVvDxfVZHbs38ZYu/Xsa5/FbSbeN2F+4H9CunE3qM42KoKuMHQ6tTd/AyQ+X2dS3oNH/XXRuewqFPyLrUd2i/xyOwZ4KdP/ovQOtyfAJwmVcb72OAJEPj0ySbTQBFxuJT9PmzcbZ4SLzAppEkXyvTN8px/3uii9
 hEdYp5Ua
 h0OB8vvGZ+n9mD2uAbRZgFtOjM8r6OIPvgqXATIfP8qeYbVLAyYwXmglgM4hiVfo6YEXXPTyqNU5+8v4zxPKrwLQYkHXkoXlMK/yTt5swB1cLDfWA2yFjPMaGasYqCcqtjAvX+nwrki+LaUDbnlW/WSKkbdOWKkgX0Z4hczU93C0iHDFSmyvzIMCSVn+SsaRoWPmAFhQohBQC6KpkZ9E0qTj5AkTkhj2U1oe/+oosnPtniTg1j3ugJ/87FCj0BQW/yfoNRWkCi+E/ee+qO+d6wjFb2l4PQ/AikAbUbFEtT8ykoiwyw9Omrx0OgiqPt4bS4kbJ6Q0tsn3ut6oB1MXBEuFWQ+3jVxYA9AkmK5VFBSKuQTLaLyFgGCzrudjchN6PwoT31YRjHPNOfxzBKiABPmVqi5A2Sb0WQdiQRjD6LzsMk96P6/f5zjNSg2m1xrKrcACGfq/DNEExpqbyRs1M4fUaWm7DpjxogzJPN8juEazN4bbmwD5UzcfzO03dZXLDPh3a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christian,

Thanks a lot for your great review!

 ---- On Thu, 28 May 2026 19:02:53 +0800  Christian Brauner <brauner@kernel=
.org> wrote ---=20
 > On Thu, May 28, 2026 at 05:52:21PM +0800, Li Chen wrote:
 > > Hi,
 > >=20
 > > This is an early RFC for an idea that is probably still rough in both =
the
 > > UAPI and implementation details. Sorry for the rough edges; I am sendi=
ng
 > > it now to check whether this direction is worth pursuing and to get
 > > feedback on the kernel/userspace boundary.
 >=20
 > The idea of having a builder api for exec isn't all that crazy. But it
 > should simply be built on top of pidfds and thus pidfs itself instead.
 > It has all the basic infrastructure in place already.

Yes, that makes a lot more sense. I was staring too hard at the "hot
executable" part and made the cache/template the API, which was probably
the wrong thing to expose. Sorry about that.

 > Any implementation
 > should also allow userspace to implement posix_spawn() on top of it.

That's so cool, and this is a really useful point. I had not thought about =
this as
something that could sit under posix_spawn(), but that makes the target
much clearer. It should be a generic exec/spawn builder first, and the
agent use case should just be one user of it.

 > fd =3D pidfd_open(0, PIDFD_EMPTY /* or better name */)
 >=20
 > pidfd_config(fd, ...) // modeled similar to fsconfig()

Reusing pidfd_open() with an empty target is nice because it keeps the API =
close
to pidfds, but I wonder if a separate entry point such as
pidfd_spawn_open() or pidfd_create() would make the "new process
builder" case a bit more explicit? Either way, the configuration side
being fsconfig-like makes sense to me.

Thanks again for pointing me in this direction. It helps a lot.

Regards,
Li=E2=80=8B


