Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E142DC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 19:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71C96B0092; Fri, 24 Jul 2026 15:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C22886B0095; Fri, 24 Jul 2026 15:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEBA96B0096; Fri, 24 Jul 2026 15:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 817E66B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:02:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0ACE21A0113
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:02:45 +0000 (UTC)
X-FDA: 85024591890.08.E5CAB39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6161340012
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:02:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ptz1Bosi;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784919762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IK+FSk8TPRYJ8bU7YCHvZXlgGoXXp9viF8QREY8bK2A=;
	b=BebrpKANjNWJnR6VroF2J2wSE0TZ9QKA81XMIZkhb7XOar1Xp86ip5bP2GXTXlHcarlw8K
	aLObrsl+eSzIZddEoDiKOZxDEvyrdoTGPIi+oJA3OVK/bFEt+AgeTMyNCIom4kxNX/MRFn
	ZiI04NOb25ktIY/lDn2EeOGBjY83wCQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784919762;
	b=g2oThBkg+GleFP2rvCFgwR0bXx5hNtStXt3g86hj1iUN4DrWfQ2mJHPYw/OyLrXx5CiNxx
	DkTxsWSDrfn89665R+ZxyUrT35U6zd98shRNvQd/GrPQEbZSAa42aquVYwwqXFjkx8i7iv
	BsDlsrhUN/PBA0ojO/6HHEEJfNH45fk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ptz1Bosi;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF9CA600AD;
	Fri, 24 Jul 2026 19:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8871F000E9;
	Fri, 24 Jul 2026 19:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784919761;
	bh=IK+FSk8TPRYJ8bU7YCHvZXlgGoXXp9viF8QREY8bK2A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ptz1BosibiIn4xQQwLjKo3BnaOcPfV6rhhcYiV9E0tVQr1ebj9AaATPuktt1YMa6p
	 NaMrcLUwv53NewAAEPiyiHMoSk7vkiiB0EE3Sncs1rIeHWKheOhGTaeM/DAwlpGSL2
	 3Pn+rWC8gd7Vsf16ucfAuB2FPgAKSbo8DdVuGoqXmzIFOk6eLj2kSZj0WDadOCwXdc
	 K2CDPS0o1VGEXKZagR6twix6FaFsc0up8E3JLmtNPw31jmWBJUJb9TKsLw9nGFI+eF
	 JVA4Y7lW5jnTzroJLHlar+e+3nmnNtXikOQNIRGLflmz2NPq1zymA/LPX4qf8tb4pG
	 e+504rZ+cTzEw==
Message-ID: <0abb768f-cd8d-44f4-aec6-a4971ea5f104@kernel.org>
Date: Fri, 24 Jul 2026 21:02:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: fix gup_longterm EINVAL error message
To: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Shuah Khan <shuah@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Sarthak Sharma <sarthak.sharma@arm.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <8A3ADC563A32EF67+20260724065929.1474539-1-zhaozhengzhuo@uniontech.com>
 <23557F4CB8CF36FF+20260724074603.1479243-1-zhaozhengzhuo@uniontech.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <23557F4CB8CF36FF+20260724074603.1479243-1-zhaozhengzhuo@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6161340012
X-Stat-Signature: o3ipgmszzcfxsdrdtghthiqzg3xd7d8h
X-Rspam-User: 
X-HE-Tag: 1784919762-184731
X-HE-Meta: U2FsdGVkX18kCaQh0e3Z7YbJYJbhmy60QJSTdMakCqBBnlzcjbCfli3vKHDz3uhsAUrsSxW+/08lWnCeEiXHzw38Q7vCYOBAzr7SBUuZjzZlNuxqW4afNz2BhGP6ccA8fZ2Xq9d1MEvVC673+z8+NiHKCzpYqbyFJchvTrvcpHIod+QvdBuJ6WtCDbf0ichZFsXZbIiCQFKrnTRO3zWUdt6y3gRCfdKpTGsTd8Z6B2rVLtHw8b6rA4hLIbX9adKgX1iHQp+WJ5bG2+xMGvVVQNXTGO1v+FJv3rWgQUMqo3PfHdb1bwiHqquacOdgCz7CrDweEsTFRJkgi7/mLjT1BYNsDQoab6c0RqLZbjEKT6TTZ8DNFF9D3KuhlzEXoKIs+X9gEFZEbd0Vx2PjKzfG8p+wygHX88SS738LlZe25DBKAK1RvBU00xNu6F4leyegUqBtrQAFSPcAKnKQ6Xd3fqFAVPAnyFsue1IBdqsgbH3KQ0aehiglqtZjhK1ztZSL9Gcy42+rDd8z8xOTaJc7ZZE4+NQdYAVpNfowukAdmDM3Sgm1ua3IxeMak2VbLXx7VRTvwSvgT8KLXleP9D8ElkpV5CPAup5NnzRoL60OS5Wd/VIpDjPWRP0aMyVApuGkIsCL6pH6a/D4xNXWdL5j4Kinvvk9Eb6aRjOKOBdstzVcB9fc3ZwUegIGXUmI+ko5tKTp3Zjx6jcnZ8oOoQlUGFbtSA1zcbbID5Jb5UyUFh6Gz3Tn25jjkzx4LwKOfFXLfImSA6kf++1N7HzXDx5Hfh1W51mU7Us4JZ12RpYjbKzcMzZX1ch9XG96VR0g6V48NPNXJglAW9K/iRecmX738gu7zyWVut3hiW5nT8jhRLnKyrkP0Hbth/IfUY+NqX89go8+nyiM6rQ997De05YJ1xp4UaB4UIBkk7IZ7L6LpzxyZTBFw1wnUGi9vgB2Zl0GXRDimlAcLdOZbE3Duk2
 0NxwLqLJ
 SNj6cbywr+opz7MFdVaNcgBUOETZZDpHM5PLTqkn1MJ8waLf3sWLOgV2lNFFdlK+TnlGlUpNW9G/uUvI5iXe37+9roCQDrtoOMssSIhlzYRu57jp2jC4De5GlM2hhj9FXWWLAhZzzYyiKyuVGJDTmRiJCgfn48xxMYNYRy8UwK140Mwwj284XbhbR5dHOmijTNEK79d/uILkLmJmvdQFGAdQYkeKhXMOjFpxxhFNua/grqFommLxG7DdXMS+I0FxiwDwOcVsQumo6M4Sr+8N3J7/zj9Z8eyKERy4VBV09yK2Tm8V5e7jIvVUT5iR26cl9vgMdT8SHdboc61w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/26 09:46, zhaozhengzhuo wrote:
> The gup_longterm test prints a literal "n" when
> PIN_LONGTERM_TEST_START fails with EINVAL because the string is missing the
> newline escape sequence.
> 
> Print a newline instead.
> 
> Fixes: 800ddf3cd74b ("selftests/mm: report errno when things fail in gup_longterm")

Drop this: it confuses people that care about backporting actual fixes into
downstream kernels.

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

