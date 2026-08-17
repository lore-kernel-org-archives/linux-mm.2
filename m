Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A02C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A506B00D8; Mon, 17 Aug 2026 09:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CB386B00DD; Mon, 17 Aug 2026 09:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3606B00DE; Mon, 17 Aug 2026 09:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 00D596B00D8
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:54:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8EE0A1207A9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:54:20 +0000 (UTC)
X-FDA: 85110905880.08.1F1E177
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id F0CE518000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:54:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mzkcPzS2;
	spf=pass (imf24.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786974859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVL9nbCJQZbVEyCg+fbUYuegcFTEntbf4W0jnv14ZwY=;
	b=1GLuW99xtZodhcxctIV+7AT3oedQQem28EqlWWlQl9+nVNhISbcPb00nZ5+VwohxuLcqLq
	simW1nOXB1swKgSU+/wefFoBz2r+HCndKeUkCgMQcl/N0dpA2uG1s5gNxjtWLqWvsVEJ5A
	+ZTCdHfNqK2XTJEc18wU/3ZhG2XSf9k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mzkcPzS2;
	spf=pass (imf24.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786974859;
	b=5pDknIuwJMHlnzHIjLR36rNEHGFDGt/sp2TIEQxcRcponxNVFd1aHtHuz+1H7sRvoWMjNh
	MuyX05G56blGAS2/FrZ46ZrxtOD3/WHGMhd7veNNwKog5IMmEEu9COhJzVwvubJd472wzu
	QMGqLTW6SSu+hO0/KoBUbK8TBGZfwtc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AD5842AAF;
	Mon, 17 Aug 2026 13:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB8C1F000E9;
	Mon, 17 Aug 2026 13:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786974858;
	bh=FVL9nbCJQZbVEyCg+fbUYuegcFTEntbf4W0jnv14ZwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mzkcPzS26UAieTbjjhDND9RbJJJohN9fS6apOERJiglp4bVTAKUcPVLWjoPXCiNki
	 JLBNklhzbQYeNIP/pTrx+MTd3fURHD8a+kQjwehQn39hVP3YpKYMT4Dgng+9cX2wDj
	 ewBHI2xVbqlIuasqa4JrW917AG4ARpUUfzfTZGob0TUy3mb781Kc9yPrElJRlqyOZF
	 xhafTecT0KNjqpPO0WeacuCTq2zvdjy5ZxT9iW/FYzOfW+PJGD2cexjYQ/rMA88xY5
	 CspoVrsJrMr0y/5uNx2fzwSYEspmauqLPXz/3xwm03Fzb6+gkpAgxtWa3l5twRYZVH
	 8yQOGv2enqBhA==
Date: Mon, 17 Aug 2026 15:54:12 +0200
From: Joel Granados <joel.granados@kernel.org>
To: Bradley Morgan <include@grrlz.net>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com, 
	kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, shijianlin11@foxmail.com, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, ziy@nvidia.com
Subject: Re: [PATCH v2 4/4] sysctl: Add 0013 to test partially updated vectors
Message-ID: <iahrpgl333k2cniihxiv4qbkgtalxmhn47gyzrq2xd7jshxbtd@cniqn2gdnqfw>
References: <20260814-lklm-partial_ctlvec-v2-4-9df50d26e477@kernel.org>
 <1EF80864-F479-44F2-8CD7-28383515F483@grrlz.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yhe6sdbk6tigebhg"
Content-Disposition: inline
In-Reply-To: <1EF80864-F479-44F2-8CD7-28383515F483@grrlz.net>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F0CE518000A
X-Stat-Signature: ch5iiz465any9domnifgzfekx7fezuz7
X-Rspam-User: 
X-HE-Tag: 1786974858-657951
X-HE-Meta: U2FsdGVkX1+bI31o4TEYmuUoDB3MeLEW3DsWeSl1fDnnz1JgMlatoS/BEsej8v5CfRkJ7VHIehFdXk7GAD4MoE5a9r5wafPdhKmISaAzz9hUKID8bEk8PWRdESdiQ0G2oMqsCrIr4phToEmz2R62y/MEStOSj1QIaKKv6km0Yt9YzPE1pmYipQiMhYQeHbBEP1kp0WAmp6i9qohLy2Ijbn8ANyulr8ABlM0+7t/i0xi/c808+AuEA5XQZ9Bau4O/R7Own5dSxN1N+jG85bJarUAnIzTS6a/Eknj7B6+iSX10CR38rpWZgAmrzsrV8fuRkkKCsrmufEqBX5AzY7mBHK6zulrn25Rmnhw2u7Eo153CAtHTJbM1e66R3VOV7Q8lGWgjqkwFt+TLlDu7DUxgvqpVEVwV1slxgbkYQUoY/ygfIoXqcyTUVb6GdHvVWWyk/QpZrzuIrwUgI3zLINIX1un4VxLZ7M901dVSmKpAQWLo11yeHiAZOb/OxwBdg6EVdA2xO744UXaaC2nwckz5D8rElDc216eCBKyO7E4fC3p81QpBlnjEieANFjZBMIprylTIcSODLmMCM8dBQe78tdsdxhJQMVwqF+vyPGgWgtVXZyemWBYD6WrDqgMmgNm645+NpDpTw/hdTD3gOUAUwOXRQPnuzN9x93nUoPSpQcX7OdraIuGYopL6vHZ9dAR7BL4fH0wmZtkaYZtWQy7NLLC3Pd2Egdp6gIho2UcrjGf9JH6/rs/SDyIElaJzJpp1EREV6S5ZIvrUOwohPLEvh+labO2tVC8CxGFVNutVyZHW4kM91/QWAJ+G5LqRlZBcLIEYiWw+LFd9B4KJoL7vP2yexHA0/NeS6EZfRHEnXzoGylAgKC4WJ2msY9AoCyq6MOyeD+IGxqgc8hLRaS/v28zn2Bgo5zK3RmiDTUIf3t1YxgBsAofjx7XuhJ/M/0BUELQ5sWo0f3Mlq1h+OXM
 I6A67IrA
 WRAosB4cbzstlpNLQRMk6rWR1NA9Wn+wEkMV+5rS+HBtg8mFsLtA8lioMn6/w2DpGsap7Wq/hTYLShXZQt9Ao71E3X9Af3fUBPXlLhLos9vXDV5/NPS1h8IU5h6Ty0I7Ys0Im4BleHs00RFEIinvWbvAvxSSdWk09sw66oHuWa4vM1X/J2FZkMQjJ3y5RUq9IwFLbXxkpLVtW47KIfjH/5c/qCiytOJ7wjzMwmnR8w3FgEqbvoqZrcUzbmdNsjKFGf4QHDSBXW9qaEqVISM9AvR9210cw638uDVnxNwTNP08/zO+8LXuWOPZfc3VYKo3Wg/J0Gvhg2ISKGxed16WFz1wegiT8fQklZeOPZtc/4/1Ja3k/m2LS5+XUCnonCY4a0LEJqUjNgyPMIrc1/CIYcWUypVLIVvx5oF2p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--yhe6sdbk6tigebhg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 15, 2026 at 05:05:59PM +0100, Bradley Morgan wrote:
> The test covers the parse error, the out of range value and the
> first value failing. That's the right coverage.
>=20
> The shellcheck disable should say why. The test functions are only
> called through the dispatch string, so shellcheck thinks they are
> unreachable.
I expect to remove this in the new sysctl selftests.

>=20
> run_int_array_no_partial_update() uses spaces for its comment lines
> while the code uses tabs.
good catch=20

>=20
> reset_vals() has no case for int_0003, so sysctl_test_0013 calls it
> for nothing. Drop the call or add a case for int_0003.
The TARGET is reset to "". right?

I'm reluctant to do more work on the sysctl.sh file as everything will
probably be replaced.

Thx

Best
>=20
> Nits aside, the test does what it should:
>=20
> Reviewed-by: Bradley Morgan <include@grrlz.net>
> Thanks!

--yhe6sdbk6tigebhg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmqDEoQACgkQupfNUreW
QU9kAwv9G9oMHDJ+90hHFBoMUPnpGpgP+V/sRCaP8YhJBX+tnl+p82nNXfffddrL
WmT9wH0JuPPRHSN3ZedgAe/+gWUez2DAUDK7ShH6QlTRzvitfW3Bi4g7A+KcgbAL
nykswCVYLvRPVIRBGdJMniG/25lwhBR+KrsZY2nx3YDw0BNTavSTCPrVId1FVJ8C
eOJw5QWyR5dIQR1gamOHqx+kF+p6Py3iS64LXB+2RrGLR6eRY1ge4HsG29/0q6I9
N89xYCLv4YAQroZOWzQyzTbbtdSXcYx4+If2bh8GUy/+qifSVQIQ5TBtrUpWuOaW
dVNDas3p8WRcAR5/89DxGdBxlMFPahyt+Xs3xxuXOtreEn5nHPf3naLBAq8TD8Wk
76kNx7YyZfPzi7wIGWhwtxMz/0/9muPVNNlQEHRKRJJknkjOyJxzWrmdL1ygovtC
f0ssEfZ4ZEn98LWDUaH5bwls8TPbTps+qrqv0+zdvJnwPhzXg6ken77xYQ22+wva
N2yP77lJ
=t+L1
-----END PGP SIGNATURE-----

--yhe6sdbk6tigebhg--

