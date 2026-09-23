Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EB03C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 22:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B306B6B008A; Wed, 23 Sep 2026 18:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07BB6B0092; Wed, 23 Sep 2026 18:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E946B009F; Wed, 23 Sep 2026 18:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8452E6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:54:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0BCD540175
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:54:12 +0000 (UTC)
X-FDA: 85246531944.12.2CDDD0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7077F80002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:54:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gYiiLuGv;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790204050;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpax/13k0jxkQdS7/A/IMz8DDLbIlyvkUqdfAGRN0Xc=;
	b=CVU+cgK58e9kcGpEC5CLVY0DPeD1LNjhUlIb5d7q77bcJH7mbK6ZtcuOO4PW1+k+dPU1ng
	tPuJBi/0rXOAn/gcP9guzOQhYgTr7g+JaoygNB0NzaVQUC2oCqseMPVKBePXwsPm5DxWwi
	bEunFJL4adNkJo7t4sMztpsnLf6ILuE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gYiiLuGv;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790204050;
	b=AowwazrJngnOA0kp2KaZgAiIlwUCC9edxV0UFRoLgtJC0eJHUPPEXU0/SBelkZarDiyYBC
	27iruFOToc8Ad0Iq8TZ+TjEbA+RQDFzRtg3HdMq/JXaqwTWlzDdBEYbWKXZmKleoUyWbJA
	Chn6VyrrdaRSMMDa+9Y/vn5+TxjS1PE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D912360008;
	Wed, 23 Sep 2026 22:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD201F000FF;
	Wed, 23 Sep 2026 22:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790204049;
	bh=cpax/13k0jxkQdS7/A/IMz8DDLbIlyvkUqdfAGRN0Xc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gYiiLuGvstukngP8msMKYZXuDIplTIHYq4g75NWD3qcMZ8W6gFbfZeTbQajsP10w/
	 wtanWytSJ0RBLmG2/0YqNDt/DoEz8IqN4QhScpT0ro37i6GhZEenIMJPzeG4qVa12h
	 aHJjv5RpU9ucXK6i51V1C0nouwOcpGq/Cbqvw4VCVpptJnlB0rynvZz61v9a6GAOo9
	 1fQJ13yXCF2PIhXYCuDZhV8VCxhh8O8Tv7FQVa6xesTQiVDbNLQq1nnC9WgkpO93j/
	 XcAyKHpwcW+7BIyCuJgpAI/CR+efXFvzPWXZL2sF83/bqRmELqcvmXObLUvKO0nJ5H
	 2FoAuE9i8MC2A==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 2/6] shmem: add tmpfs_create_mount() to create tmpfs
 mounts internally
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pratyush Yadav" <pratyush@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "David
 Matlack" <dmatlack@google.com>, "Mike Rapoport" <rppt@kernel.org>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260923224408.3745689-3-pratyush@kernel.org>
References: <20260923224408.3745689-1-pratyush@kernel.org>
 <20260923224408.3745689-3-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 22:54:08 +0000
Message-Id: <20260923225409.1DD201F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7077F80002
X-Stat-Signature: gd3q9dx5qhg9th19nwabknh7or8mechk
X-Rspam-User: 
X-HE-Tag: 1790204050-198113
X-HE-Meta: U2FsdGVkX1/6V8OHnU5iGbQSr3+bzFmP2MIgUTDfn6O0E/QnxDOTb5c51w+JwONLve44aKp2kx5QskUVeB9fExhHkH4ZNK71xNCuhxDp7fcNQaLWyrLRo8G+PKJKnpXoJI0cLJNb7lQZFvSZ8ZNKvxeBqPa0jUA7glCEUM0xve1E//HBFN/6+oU/l+7hTsAVKopvWyL0XKeHIusi5CVeUaNzMOlPS4doyNsqPeC+6dhNzsp2XOpyn+PWD35Pl5mgz+Vyk2EgPfV14qFlBaLmdDnR1aVyLGDVfJC+EZYiU+0W23zvSlz7Smv8oJ0xPy39JQvtSg3IgEP6Do9DrUp2MNIfxEPF2OkxNIQPNon5v0zjx1n4XObYxBpuEbWrnQNPMM92w9xp3tH4muqn5aAF11CaGNvuwviLG8JMPjvynk7Jf+8L7vihYDQm2hB7xegrOlu8Ho6aF1bS7X6C+cyZqU2OL6dXOV1JL39WZUXC9CawIhimAlJpRJCKZ2u4D6DZFyw/E7CVtuNCk4/je5uTUmUE8sK1FBiJxJ/bLGncgYbzJsSF1sChC87I5OqqW4UVcgHAVXmS7YJ1ujomH6fu/j+zyKWcGEIzZzxXMOvsYQ+hx+XFdRLO57z78WFT1g310eHw8pETvAM2s100/Kc3e/fdf4Ty1SX5B2eDrT5ikSyWzRY6vTkd1Z4Htifl2Qs3OIRSDe9JnmglvxjAd6XDg9SB5E7iBQRD8GFcqiqU0RIeaWcSKBlnV2JVbN2ET5P6JLA2PmH1WZtVloBIbtUMArzZ5B6LHxlrvTXDyAThb3Hxmp03fwd0iVsZ98XEPwDhdEmRh8otcMZpjTBIaz+nr9OOeXSU8woO5srdWUdCihdDTQhY03XVd/RbR0IoyBzgKGBhRFaoTGw20gQN4hAQ3rjQP3CztT691xNt186Zei+m61FFhRZWYrk7rmEF5F2UsDgND6ZchVIe98Ue/Q0
 Hrx4zq5D
 TrbJmzJjsJfBVd+p8+P4qhSHxjHzIT1/rWPB0H5J2qZumlzA0D/5vUcjFwlVUT8x5gYUAY2v0NGiJYgYk4UMRtdMVdff3iPjTR2YG3TEjBcMWE9lMd+aVJL2/DgZrAZN0oxZNDZMU6Ae9qluooYFDH3kABZmA+UIoATDuTNe98mU1zpzRiCXI7udJsVpP2vpQTA1ueA8ZyQdjLKNa9GAK3CrGen2yPkuEWgUmYH5JtwOMr2r/XQq6TVzsx9GbKU5P+sbgdcFu4hXHuTkCM9KUV9/LwZmXLYbe83PQ/4UXdqtlwFPCH01tHwmjeKP26nyfWWqaHI4NVOFFbDHUqf/abrMbPVEyTa44tgNomOYB6iCi6AU2Tl8mYXp6CwCy3sO8chih3k0viu3Qzxb732blL/cOKM5+mT545NaM0RNsGathvekLbmQ3bIR6GvC4DIPZTi3ey95K10lPt8r6G0VEG5v73BnQe7Z3VQj95vt6IGsE4LB0GKDRfIIJybFMwgBwwlVbbRb+R+xOvwKzSJMv39MATbHzEsX1qG/e7yFbLVh0+N/vuj4bLP/zi4pK/yIanQXXXSXI284fQ96nSQev7IK7sW9BBcFnXSjjJfCWohg502EfRhl+QMrFHpTrdCcQRyGsdzLRVFUtNQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>=20
> Upcoming commits will add support for preserving a tmpfs mount via LUO.
> While the retrieve logic can create the mount by constructing an options
> string from its preserved data, it is simpler to let it directly pass
> the parameters.
>=20
> tmpfs_create_mount() allows creating a mount with the specified
> max_blocks and mode. The function only takes max_blocks and mode for now
> because that is all the tmpfs preservation will use. All other values
> are left to their defaults.
>=20
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923224408.3745=
689-1-pratyush@kernel.org?part=3D2


