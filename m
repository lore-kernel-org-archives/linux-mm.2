Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CE85C88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2510C6B009D; Tue, 15 Sep 2026 08:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2229E6B00A5; Tue, 15 Sep 2026 08:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138756B00A6; Tue, 15 Sep 2026 08:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4C456B009D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:15:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F20B403E9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:15:51 +0000 (UTC)
X-FDA: 85215892902.01.BEBF44B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B3414A000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:15:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ngAb15T/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474549;
	b=suxiYMOYW63iEfJxhrAsA0+2u6pEU18jj2n3Tk4uIHPH9po/K9aAwr+ee4KOVJ4+7Bcyed
	8ZAqFSS9ncNHGJkwNQIpC3y5vL7WGQ5nOKqTS2ihIHHP+2dT1R7P/t+xi8AtZ71C+gFjq+
	myuegd7GJni566j22MrTY2ZY0mdNw0g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ngAb15T/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474549;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xCl8jNs77PZZdSIvmzClNS4N5YJKQYnamGutVTepnCk=;
	b=OwLbe66DTIxMPTHJGL3T7ZyA2RPMCyMeH5AQz5Tdw8mdja8yHcE+XFH/JkgfLC/9WBwrGU
	055la+xrR6cWM3WOoMMbr+12l+lzZUcoeQh1NzdX9u5nxpjlQCu8eJsbDHj90Xbpkoe+zi
	cNI4EkK/6d22trf4nVgVgcKkOvmV+UY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C1CB60261;
	Tue, 15 Sep 2026 12:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D50C1F00893;
	Tue, 15 Sep 2026 12:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474549;
	bh=xCl8jNs77PZZdSIvmzClNS4N5YJKQYnamGutVTepnCk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ngAb15T/yAkTwE1+YE6SOVKj8Rli4aHVUkDtOhNqgXnslknQomnBjXDhGUUHHgw5c
	 t1KNN6ZH3zr5Gtf1iBmlLvi1+EedRg6qAtTNkQ7kQMdZyxrotp61A/kxMP1IsoWP3Q
	 0HPEwAzkXmBRniukPUCUyctzd9pxcukzIZA+ewzHxw/boCKe1Jar8qJFg1/aKtu5I/
	 dpLp1T084yx8feJuPVTuB36srOvPtJerVeDd4qv1zFiywDAW7LoZnflX7kr4TjuMev
	 HM37MdMxXfwNOlWakuuKYP5RXCJcKz7vv76rj0gWBeGPIn4OJc58aAB53O2zHvFgkb
	 1XTJ0zBTt12SA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 40/50] KVM: stop putting descriptors back on
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-alpha@vger.kernel.org, bpf@vger.kernel.org, kexec@lists.infradead.org, dri-devel@lists.freedesktop.org, "David
 Airlie" <airlied@redhat.com>, "Ingo Molnar" <mingo@redhat.com>, linux-snps-arc@lists.infradead.org, linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org, linux-um@lists.infradead.org, linux-hyperv@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, "Peter Zijlstra" <peterz@infradead.org>, linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, linux-m68k@lists.linux-m68k.org, "Jann Horn" <jannh@google.com>, "Oleg
 Nesterov" <oleg@redhat.com>, linux-openrisc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, kvm@vger.kernel.org, "Jan Kara" <jack@suse.cz>, io-uring@vger.kernel.org, linux-arm-msm@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-fsdevel@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-hexagon@vger.kernel.org, linux-sh@vger.kernel.org, virtualization@lists.linux.dev, linux-mips@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-40-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-40-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:15:47 +0000
Message-Id: <20260915121547.9D50C1F00893@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B3414A000D
X-Stat-Signature: 463q58r3stnf5xw78yqa4zk83xzmkqie
X-HE-Tag: 1789474549-358128
X-HE-Meta: U2FsdGVkX1+3PL1B0qLzP3maUwtZha5CLScpKcSX8Lu4UWI+JAXOSLZpENgGAtBkrOGAoey0PqZNNms9YMRlWYWueq4PHXWp2/H7RDKwEAkH8BLgXnH12esGl+sGbtk3KVb3YkLh4Rz9PoWFTk+WnH/qWO/gSGvEZWJ1zV//53NZXqBFU2UG7bjMG837JX8OqMplcI7+ViNaF7uC3VNjKAFvYc+dYoF9ki4IjnmSlH2UAEeoculDaMgAjcuYkLos1GMuKQGHbxtui6ZM8Z4vIrBiR0POvvsIFpEi49Eo41MEhXJY1cAxFWNStyxpW4TzAxq4nW4hATiK5HkH5fNXobpSZoZppQrt4UHaYygfS5N4H4IzyY1lgu0tke67sea6ebCljOMxainUpiREk0eLVHeFHrjFUdjHT0EpSIfiefcwca5DbB+6jEotu/DIBo6oryKOAu7XPlUc81VFkKZ9nNyh9RDy83My49i8GZlb8cgK+lqIOLXhylq/Y9wVL4suRmWslm4OYbszURBzcHFOaO9lXsrH7GTu90pJQLj98ESza9OkfivbnVr8B9rN7O2DTy3+8uBrtbVBdNGpvX2Vgs2qvjMi6SyDSP7XDxi9zxRPUxCYW5IUrQoSUXYfR6WrBpu3Dbx7pPWuIbrh8k2K32pZVJv0MUo+t/i4U88Y43WqAPXoBWkUbNGOR7/yt4vUtn5LDLXzDoB+RKSyz0b4YeqtQQXX6rNXj79+parKlzjxMNwCc84P+Jq8DdEBo+toF2mGMZe3pLQUL0T1TcliKB4CPm1pbfhC9xj1YPpYsCUGB57MusxVyaSBH3XR1MAWo4xFffGwos1m3zszJwYHWNEu7lXd7hUMipTbhaylpMIdnneepTGDlM5ECUmMq+JHdWULzYSrNsOixu8kNXlk7x0kdaROTzUZj1qUO/0nA4c+kFd3ZGyBkyKJ5R0K6J52csHd56O+4QGlrnOAxNV
 CrnbeWc0
 xKWI5O3VZCUopTRmJrDQPR8kSR4OnCuAg0k5CAGqV83tN/xuxqTbsCLnImi0R+5a/WmXLA1JDWyMHJztk2XvRDFHpRJLnrL62JIDEK/1bCLBDni3ppjXEt22GO4bgaV8KY7cyhdBhoz1aXUQF4Olyenp+sdnHKe7V7+P4Juni8LJ2kbKSxJKsPg8yiVpMoyx8LCJL04+mS4VLeFecJlBEEDLkVHharuVJujaWP8VBQ0oPb62ftXndDiyHYMgMfIbVAaYlYlvsXcxazESCOPAZRpli6jBOX3Q+fXZ5hGvRP0ORe2yESqiXH0k4uH/B8ZdNym8SSE3KO1BVpIfwfNBJ36Sx6E0BvcgdklmLEiDW6eD/zWmb9+v6v7fk6uofzV4gW5BeN+gdp77yhEa8M5YI4CgHZaTIH/aUHSfebcAArSXWGg2YHuDI2FQ0eMuSNzUGMm3nWU+8yTuJiDcpWTxXgKc2v1EU8k2Qb3Vhe/8vXGn/E9Z5X9p0nAMOwHL/lB2zzdAEC0EkRT3YpdZvcNXoix/i0r3ixkC6Wv3x3sb7QRpdS6SZ2S3ql24o3WqW01lOItHLmPm7KIcgx70tskr8Jgn+xwz+R1s5gp0rx5aTPLfkvB8so1Kt2g4A8mwg35nxkUprLzmDVD2iCnKeDxQXiNV+ZoF/Rp6RlugHsULWvEvgZdVHg3csk0OET3AqlWyy4I+r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Rely on the fd exit path machinery.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D40


