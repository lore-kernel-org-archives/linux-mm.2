Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F4E0606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 12:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=feldt.systems header.i=@feldt.systems header.a=rsa-sha256 header.s=protonmail2 header.b=Z6rO7xwO
Received: by kanga.kvack.org (Postfix)
	id A08256B05B1; Sun, 15 Nov 2026 07:50:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8FD6B05B2; Sun, 15 Nov 2026 07:50:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CF336B05B3; Sun, 15 Nov 2026 07:50:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6466C6B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:50:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5FEF406F6
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:50:13 +0000 (UTC)
X-FDA: 85437336306.28.6E1B399
Received: from mail-4317.protonmail.ch (mail-4317.protonmail.ch [185.70.43.17])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6C704140006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:50:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=feldt.systems header.s=protonmail2 header.b=Z6rO7xwO;
	spf=pass (imf09.hostedemail.com: domain of noah@feldt.systems designates 185.70.43.17 as permitted sender) smtp.mailfrom=noah@feldt.systems;
	dmarc=pass (policy=quarantine) header.from=feldt.systems
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794747012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVNyqoZPmWVu3SKQuwZrHrfUspenGyNr7ONwhLH90yo=;
	b=OoV6VKEAS+3H416LtXJxsiQfXbAO5NimQEcujSIi5xqsbe9nKYLb16l28hdkdtfIxDvmlN
	wzBhFNAjttXlfkfsyHuHrZRUcjalusIufk5/jAYp6L7pAJuC32DAShhLZjgjwRVKpJHhsr
	CwLZQJ74OPni20uFNG857P1xp1mWNA0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=feldt.systems header.s=protonmail2 header.b=Z6rO7xwO;
	spf=pass (imf09.hostedemail.com: domain of noah@feldt.systems designates 185.70.43.17 as permitted sender) smtp.mailfrom=noah@feldt.systems;
	dmarc=pass (policy=quarantine) header.from=feldt.systems
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794747012;
	b=l6lWunbHxiHjmxo89nKquWZnZ3kaGh2FRgbC54jUOWhcP2/lnVUEk6D9Si5Xfnk/pdvf8/
	lbEXvVfd8AJOKa0AHI9kwz5/uxCLgtCI5L6IhlZuhikvT4rXBMZD0VH9814pvBTtXZ1JVX
	3stPHoPcB2jelyjXoTzltB9KjQ4Efa0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=feldt.systems;
	s=protonmail2; t=1794747008; x=1795006208;
	bh=mVNyqoZPmWVu3SKQuwZrHrfUspenGyNr7ONwhLH90yo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Z6rO7xwOeaCPF1nl2j/O0ICdnwWkRxg7BDBC24YB/dCJaOzTh7lN8mOIwUnFE7x0m
	 QlmwWE8RMW+4XMGkXUXANKxIsMFkFZOE6UqZ/vJqNv1adRtH8U/m3LFOK2xzynVDwt
	 4/44dv4E/awHfcgHCwWVdW5CF5bv4CPVpM1qcjOqe7iAyDJd5fAKK0GhyQ7glao2MZ
	 Cg2D9U8fl6G3k7B5w6jZe9RIqkFJnc4LuaPjSptsiZiuHKVDfWZ2SgyxRnfXLCnN1x
	 Oxv9yjTksvsdk3/wnpvaB1Sae4rIaBIXuvPihdeexW1SB/93gyXAXRAIUfGhW+4tAz
	 A5y8IhP1V4ikg==
Date: Sun, 15 Nov 2026 12:50:02 +0000
To: Shakeel Butt <shakeel.butt@linux.dev>
From: Noah Feldt <noah@feldt.systems>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: mglru: splice all generations when reparenting a memcg
Message-ID: <20261115124954.7146-1-noah@feldt.systems>
In-Reply-To: <20261111000913.22943-1-shakeel.butt@linux.dev>
References: <20261111000913.22943-1-shakeel.butt@linux.dev>
Feedback-ID: 113045274:user:proton
X-Pm-Message-ID: 7a8d2dffe38d7e29b15abfa03649c45efb904402
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------b27fb500e8faeb49fb14a6758c7ae9d2468896a3db128a3af62cfaa1f52b3fb9"; charset=utf-8
X-Stat-Signature: cyxpdws7cm9rxpgaoj5ngc47j3h583qp
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6C704140006
X-HE-Tag: 1794747011-723231
X-HE-Meta: U2FsdGVkX1+1cYpJKsM80VYxiN/YwJ/Ga0AxXV6mGeXLB5fOz3GfXMu2oubzBvMB3JR9tUbuvJrxpSikWgfylBmlEzK5dg3mt1uTVWs3AdFmHGiE6ygjycUr4S8rXP0DfMVoxaXgR7JWc7OIP1snHYx7ZRZ+HtbcnFW2JV3x9d3C1EFlhYgcX0POv19gHySq1w5YI2QEA7pcd9b5TusY++wT51uFtAc3Qjl1aQH1q0rsCuab/U76u1eYZYCZnnFEoZRpklGxqbJMUU/hEbM9n7OohjmQ8pNvIvqxauQHSodRhE92lhBFf+7IA26eSczMll6QuvC/E3DpKtDdBTbBkyDc2f1dyhHxMBNOmtWfMKNnEoqx27ONSJADumzoYoqWb62hMr4IQ31rOOsia9N60wtnqfrvnhYP+0TfP7TQXMmKBNlJudxi7lFosvFyModginENOtKQfp92SpYYupk2zUSLyspyr+WmBZYaB9+Zp97WfBtTbnmG0KkBIPTHY1ZRjoP0K8h/Ycum2/9krZrY2UQ+kNuDHsJnWLBR+TWHwD67apKAu5EjM+qPfZJopQ0G6kShgRJJzEkNTYvwa6RN+1K9iyMzh4YOt1aedlkr6HCEvRHULsQ/GcVJaoej07BPy0Ubc3Zu424Pyy4vqpoPIHQo0YyZb0/RqdCmGB4tsmwGiSlJ2NrpuvVMusjy1Fv8nGxeH90nLo8r+Ti9WtzmOYZ7sUVaAWKytCTDvAZR0iVByAjbI70JQBcVzZaGHUZP+jWKNH8FYej4cSXzdCE88bdZeznNvhsUdkl6leDE3LCywcovUZwcN4XkgQ3iPEPq077RM7Kd5/bzOI1yCgm3+UfPmOMJDxj7klUpqHfUBp4/VyIxYrEDGEa7Kt5oRlVR4rMum3apHNux4B69L+nFtG27XIzpWpXYnhNQqRChaSJO0Peq+vcTh3I2Eq03Yo1BJh9puAopFKyezy5NBWZ
 uSQxbdQX
 VCnUEYJQY+mUTy+q8hRP4E7c/hBEA9vgG9Z2Dvpc/JjGkq0ehjMvcN/rYuS7kBrKjl8CM/ZqmfWxLJ+Kn42DzxuDTIMPwEojKgPf4ERHbyMlimbWjVDF3iLH/o6yFJbkZaR9XiguZtK6cIOAHTL4GApWt70Vqs5IogvTiZtYPkNSTUHO9flkhZL/ge5/yWrabD2hD8IqDkY8ZsiHdD5UJRancjLjs3yUHI6zd7kz7NhXjx4xlshicP1piNxr2QwZIcfA4bWSQ7oaIh89LRlrgwHMdWQJMB0XltsL421YC6w28oZcOuBSSBU9c/gxrzFL+YOFFSn+wyt0dK3nuBWD+EvV1lFTPjtBj5CsJbmlwlFh6x0w6Xwq4B8NykW+yDEaVb+pqrmmg0FXdFKzKZ2gPvclMvocuODn/WR5AiJL31riuFuiMLkInOzPco39qITGDKtqCIh73MZBFS+Xm5q0gpKWwVKdv3/0BhLjbTso0xRiWmezOdfI+I0QeCTNYOwONZdyGI3zGe4zQlvFlBRc8FVB2sOOtsAwuWIuP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------b27fb500e8faeb49fb14a6758c7ae9d2468896a3db128a3af62cfaa1f52b3fb9
Content-Type: multipart/mixed;
 boundary=05e0afd5b3cdf604dd06ded9ef01d0c6e448bf611d31394ba37e012cc31c
From: Noah Feldt <noah@feldt.systems>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: mglru: splice all generations when reparenting a memcg
Date: Sun, 15 Nov 2026 13:49:53 +0100
Message-ID: <20261115124954.7146-1-noah@feldt.systems>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261111000913.22943-1-shakeel.butt@linux.dev>
References: <20261111000913.22943-1-shakeel.butt@linux.dev>
MIME-Version: 1.0

--05e0afd5b3cdf604dd06ded9ef01d0c6e448bf611d31394ba37e012cc31c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Nov 11, 2026, Shakeel Butt wrote:
> Noah reported list_del corruption on single-node hosts running 7.2.11,
> which already has commit bf4ade7dbd76 ("memcg: keep folio's objcg same
> as its node"). The bad pointer is an MGLRU list head in a freed
> mem_cgroup_per_node:

I have already rolled this patch out on our servers. Since then the
panics and resulting restarts from my report have stopped, and we have
not noticed any other unusual behaviour.

Tested-by: Noah Feldt <noah@feldt.systems>

--05e0afd5b3cdf604dd06ded9ef01d0c6e448bf611d31394ba37e012cc31c
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="publickey - noah@feldt.systems -
 0x9B02BBB4.asc"; name="publickey - noah@feldt.systems - 0x9B02BBB4.asc"
Content-Type: application/pgp-keys; filename="publickey - noah@feldt.systems
 - 0x9B02BBB4.asc"; name="publickey - noah@feldt.systems - 0x9B02BBB4.asc"

LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCkNvbW1lbnQ6IGh0dHBzOi8vZ29w
ZW5wZ3Aub3JnClZlcnNpb246IEdvcGVuUEdQIDIuMTAuMAoKeGpNRVpuV2ZveFlKS3dZQkJBSGFS
dzhCQVFkQWpjOWlieHJoOExkN2E3YjdBM1hXUnZSdGt6V2cwcEZUaUpDTgoza3J1ZnM3TkoyNXZZ
V2hBWm1Wc1pIUXVjM2x6ZEdWdGN5QThibTloYUVCbVpXeGtkQzV6ZVhOMFpXMXpQc0tNCkJCQVdD
Z0ErQllKbWRaK2pCQXNKQndnSmtFQlN1OWFxLzJDcUF4VUlDZ1FXQUFJQkFoa0JBcHNEQWg0QkZp
RUUKbXdLN3RGM0s0QUt5ZXdZWVFGSzcxcXIvWUtvQUFFSjdBUURaRlZLOGpTa3FDSk9oS1NsTVp6
T01Ibk4vQjhyYwpHZzlXei9UdW1lejVwQUQvV2l6V2xGem4xT3NibzBzV0U3L25FLzRMaXRKS2k0
bjlObUVGczRob01BVE9PQVJtCmRaK2pFZ29yQmdFRUFaZFZBUVVCQVFkQTc4U0JLZkc1Ymd6SjQw
bVZxTmNGUnhqc0lTT0ovVW4rZU1TaC83MkQKVUVJREFRZ0h3bmdFR0JZS0FDb0ZnbVoxbjZNSmtF
QlN1OWFxLzJDcUFwc01GaUVFbXdLN3RGM0s0QUt5ZXdZWQpRRks3MXFyL1lLb0FBTWJHQVA0anZ3
YlBacnFSY3dzRk5VdWI3aSthSFVTY2pwQTJIazFUdTBKTG5HWTlMQUVBCjRBOGQrWGNsdEVhUEtp
Vi9sbzh2RFdPaFBBQVBhbTFuQi8wQWhlenh1UTA9Cj1jQkVoCi0tLS0tRU5EIFBHUCBQVUJMSUMg
S0VZIEJMT0NLLS0tLS0=
--05e0afd5b3cdf604dd06ded9ef01d0c6e448bf611d31394ba37e012cc31c--

--------b27fb500e8faeb49fb14a6758c7ae9d2468896a3db128a3af62cfaa1f52b3fb9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

wqsEARYIAF0Fgmr5qnoJEEBSu9aq/2CqNRQAAAAAABwAEHNhbHRAbm90YXRp
b25zLm9wZW5wZ3Bqcy5vcmcJY1tpAvGYVk58XJVYWNHrFiEEmwK7tF3K4AKy
ewYYQFK71qr/YKoAAElkAP9khqOtjveDcbwTuViuCxaBhfOSAVQoH+cQF9d0
ekfMBwD/XqKUWZwBK1v+fl/e6jrZ0dwuxvsCOdhSvhM1UKKP4g0=
=TNjw
-----END PGP SIGNATURE-----


--------b27fb500e8faeb49fb14a6758c7ae9d2468896a3db128a3af62cfaa1f52b3fb9--


