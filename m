Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33934CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 12:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548FD6B03BE; Tue,  2 Jun 2026 08:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9EE6B03C0; Tue,  2 Jun 2026 08:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40FC66B03C9; Tue,  2 Jun 2026 08:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30F0D6B03BE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:07:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C52E5C2C3A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:07:43 +0000 (UTC)
X-FDA: 84834848406.23.20CE7A3
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id BFCEEA0013
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:07:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=Zlt3oNaR;
	spf=pass (imf15.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780402062;
	b=4fAp4tz+O6/8UBg+oGcEGI15Z8ORE1DU+niBBs7QJP1n0H4ainH/+IhXQxIlGhHtx5onIV
	DcorEOWfSZCfAKiLH6E8Cz+5vIebIu+b65Wa3x3mQusIxik3PjMGcnpOZgKzzLC5hpl7FL
	dcE3FbpQDgc4+L1UO5Sk1dKMoshkVSs=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=Zlt3oNaR;
	spf=pass (imf15.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780402062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vk7eeniepcURlDwWgLQyxmjRbTq5rFiyu0fmscCWkm4=;
	b=7tYQv0IUZYlJYwEd0oSHH4iu4TAlCKBB0XPYmv66fEFo54T3oDGEZB3VDWLiYuyvpKZbcL
	cRCe4gquqfejzT6Ucs+G7jQ2X65WSHxDv/RmnXHkUrBmQxyZC9ThHhdy8Pu3mGTHE7erms
	sGoMxWhPrfR1h59rqfBaUJ8K4DENLRA=
ARC-Seal: i=1; a=rsa-sha256; t=1780402044; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Ax36rWt1feL9QcFuFow0giDSRLuo68Ed+YUirk9L9RDYy5YcpVDvlnz+YDM5f92MgRMhVhOZQkyjDM0qb5fYftyvNVrXDy9dsNcd1+FHcDQOlBHVDmDO4OESlg4SXVguCtxbwSftXL5Ac06bmTfEN4u4M41hclFenHdAukEWlbM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1780402044; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Vk7eeniepcURlDwWgLQyxmjRbTq5rFiyu0fmscCWkm4=; 
	b=hZcMijGfu7IeE4PygN1oZx6i45maA3Xjumto6BEFB8C9KC9Z0lClj24hK8CCx9dLqvYDZBCo6nc7+Dn1eRzMXA5yP7NylmEIJe61ow9kicins43ih4aBFbnp/fH5uoQK/8TgKgwwCij+W4H+Ip6ptlZ+PqR+GboIvnh1b2YoTik=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1780402044;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Vk7eeniepcURlDwWgLQyxmjRbTq5rFiyu0fmscCWkm4=;
	b=Zlt3oNaRQWUMWb62kC/65uEnsBoYbSOLSdu5qIGlqqsOfY0rg6uaPABoEEcjQH2L
	MWZPJhxzl72HDznRw3AT+bR9LlTFss5C5Kz76bRbZcRLMZ5rwmRuJ7d2zZX5bmT3UDU
	yQ42a4N+U3udh0jbwnmUpHnDrihBmpCWTDZ8yaBE=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1780402040732884.3207521738933; Tue, 2 Jun 2026 05:07:20 -0700 (PDT)
Date: Tue, 02 Jun 2026 20:07:20 +0800
From: Li Chen <me@linux.beauty>
To: "Andy Lutomirski" <luto@kernel.org>
Cc: "Christian Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-api" <linux-api@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>,
	"linux-arch" <linux-arch@vger.kernel.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"linux-kselftest" <linux-kselftest@vger.kernel.org>,
	"x86" <x86@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.cz>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Shuah Khan" <skhan@linuxfoundation.org>
Message-ID: <19e883b2f84.6134d346323880.1325813164715871999@linux.beauty>
In-Reply-To: <CALCETrXqWcqn_79sMKnkyKOSAjg4AmcSHsuyH83oW8zJFoV6Dw@mail.gmail.com>
References: <20260528095235.2491226-1-me@linux.beauty> <CALCETrXqWcqn_79sMKnkyKOSAjg4AmcSHsuyH83oW8zJFoV6Dw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Queue-Id: BFCEEA0013
X-Stat-Signature: ebc64wmefkwzzghuzsgiyr3zx8h6sz7t
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780402061-568802
X-HE-Meta: U2FsdGVkX1/OZprJxK9vPxzNrh4XzRyeMqPaYifKto1+pV325KLc1k2T7rTNII2LE+2QXAYXUg45KVRGDfhN211zFwZva4w1saGvUGMkaQYDf1LpGZmYODtJb3CODpMLfoLJgRqygZeggV0MBFhg4jU0EAvWnmmxH9l4r1aU4kO1icz6ifcuuXeUeLQIcWxCapr5krwqx890GpAgFzoeiX6czUItGfQmDlp6lB5r/krC0IrsdszEJSKf8n3OUOv5gYFjK8wtb+3ky4HnmZCnM1jt2ZPksn4xQ+l3rggHHJ4yg+l6i4KVnNhtNTys5z5FyBVPBF1m8Fjz2ri0x5GoOU2iQuJ8/4UKRf01Fkut0YN58rODcLyaBwBvLIMzWNaLeQaV3UxYdb1RtYfk/y4AxYyHbuQ3r4+P2n6u5RkTGJe6RjCcb5ENv5FYx3N1O4kss3FdzHwXfLEB4WCxTUD8C3UC5engP0c1x6gkx0Krp7xU3hKDQk/84wVQeYjeyfIob5rjKAa765xviQw+syurCo7P0HTYL2rCr0zD5BQqs0x1/fhj/yD9sRR0iTiHz4R0xR8nUvpngGyMRN7KRE7wjmtl035CDGju75tpTNeHrG+d17NqKsU0qujOHMzNr5ctTW1x2ck1xuDmLIPOO/rDD0uuIw3MNfyBihPpxdPR8eJ6fDmVxgYqa1BPe+ZVU6BtsMK+0oWTiJngcWN4wWlUElgmfRrFlNmYI+kqn4lU/3XcPazGzXMp+CbM7VGH1IVbOmUqGOslsg79d5bVJAS4UgMZI0LQ69xp+dOv3eQOpJ2KuT2F1n0slCUE/W7AEGkcPJ1XzWIEGxFcPzYRArDnN8Beyhi4d9jCljLD8FRsAGNdqGHVeeMeKjwYJQj8RIxWdRlN9oX6uZ39wvOgNpAtS6XBvIOS1D64KROGLdkyekSonaF0Gf9WhF5lDAZNTQyFg4vxfT62kEFQPIQIy85
 JPyWsGxK
 Sw9FOB3zw0573dOgX1wl+fyTMWCHtKj0BgpUPMS47Gk/8+sC768eDk1CiOOLeXfJkhRDSEyOv/oa+PsQbIeeIRn4oLE0vThgycKMITgbi5QIifhmBy+t/HSS9tvv/xKwf7rF+30KCTzjzkg4NjUIuxXeHSH/PgNIr4GMZZ9++UJsnUMKJaDhJlxmrxU9ExM+/MLbjpzvi1IbAcswB304aOC49zxwqoRv/tT/yHZuDIPrg3oFEdnaXE9LAt9jgotcb7R418y3owTw+IFCJGtQm8z/L3cvvKaDXEscvPfbpxQ58fCY01mIxIw+w3kLYFbAi5IrUWU8JBnszwpdvsLvevNQ18TdjnAwi5J4WNNLWwazIEx/YVUGltmaNh+A9g23UVRtaqaUlic3JKAy3dp8nGfQjSbakJhztt/9QtOwQpFIbMJJ+g4ym8XMGQG8JUTZzN/wDsIzCBzslmsrX0rICYzl0m+mQ87k0W3DIuzhOVwgbh9gF6Yb8wdl5r7UuXTaSUSva
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andy,

 ---- On Fri, 29 May 2026 02:27:00 +0800  Andy Lutomirski <luto@kernel.org>=
 wrote ---=20
 > On Thu, May 28, 2026 at 2:55=E2=80=AFAM Li Chen <me@linux.beauty> wrote:
 > >
 >=20
 > >
 > > The template pins the executable and denies writes to that file while =
the
 > > template fd is alive,
 >=20
 > Please don't.  *Maybe* detect when it gets modified and clear your cache=
.
 >=20
 > Or develop a generic way to open a new fd that's an immutable view
 > into an existing file such that the fd retains its contents even if
 > the file changes.  (Think a reflink that's not persistent and has no
 > name -- you'll need some way to avoid resource exhaustion.)

 I agree that deny-write is not a good long-term invalidation model. I had
 considered clear-cache-on-modify, but kept this RFC smaller.

 > >
 > > Workload     Calls  subprocess  spawn_template  time_s       Delta
 > > (workers)    calls  calls/s     calls/s         seconds
 > > 1x16         6144      411.04          420.32   14.95/14.62  +2.26%
 > > 2x8          6144      666.78          690.08    9.21/8.90   +3.49%
 > > 4x4          6144      955.61         1003.25    6.43/6.12   +4.99%
 > > 8x2          6144     1048.25         1069.18    5.86/5.75   +2.00%
 >=20
 > This is a lot of complexity in the kernel for a teeny tiny gain.
 >=20
 > I'm with Christian -- a better spawn API would be great (and much
 > faster than fork/vfork + exec), but that's a different patch.
=20
 Thanks, I agree. A pidfd/pidfs spawn builder looks like the much better AP=
I shape.

 The cover letter numbers were from a mixed agent-tool workload. For very s=
hort
 single-tool runs I saw larger wins, about +14% for printf-style work.
 I should have called that out separately.

 I will work toward a pidfd_config-style builder next.

Regards,

Li=E2=80=8B


