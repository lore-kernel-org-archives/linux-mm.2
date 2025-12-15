Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04EE6D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 07:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587886B0006; Mon, 15 Dec 2025 02:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5111F6B0007; Mon, 15 Dec 2025 02:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9156B0008; Mon, 15 Dec 2025 02:10:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 265EA6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 02:10:18 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C96AF13678B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:10:17 +0000 (UTC)
X-FDA: 84220831674.01.CF86E19
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf26.hostedemail.com (Postfix) with ESMTP id 68CA3140010
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:10:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765782616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=fCIuwvID6GzzeJdwHyZzJorabJVbU7FJKsZ1mYc4l4k=;
	b=gdaW7npDVik2g2iPtLcKwf7tg5GjTdxo9hlJFNXZ1oQ++WXchecAqyk8OyPJB2dpabuEhY
	ofDjR47IS6Z31OKo+lngKj2AQfTmy48b0Vixde9pEwxKHJDWQ4s6nNy/ByB5KGk177OJVU
	L798ma4GzvP05zSAVR56pbwy9q15lz0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765782616; a=rsa-sha256;
	cv=none;
	b=ipQY9HubX6XNgEWLvtyxAm5jEcHT6vbt2H0NrZcg85pS4MCw/KwuVCwyCEc6B8jP+cgSD1
	Ebjty3CEZDqUt1uwpFw9rzOVfJ3glhBBBrXPBJ0+wN2yJ9+S0lEIhGOV0+m/nZ7VOToLy8
	bfBMH80EP/Nsjr+FaL+Sv4HXPyQPMZM=
X-AuditID: a67dfc5b-c2dff70000001609-9b-693fb453d267
From: Byungchul Park <byungchul@sk.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com,
	harry.yoo@oracle.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	davem@davemloft.net,
	kuba@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	pabeni@redhat.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	horms@kernel.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ilias.apalodimas@linaro.org,
	willy@infradead.org,
	brauner@kernel.org,
	kas@kernel.org,
	yuzhao@google.com,
	usamaarif642@gmail.com,
	baolin.wang@linux.alibaba.com,
	almasrymina@google.com,
	toke@redhat.com,
	asml.silence@gmail.com,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au,
	dw@davidwei.uk,
	ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: [PATCH 0/2] finalize removing the page pool members in struct page
Date: Mon, 15 Dec 2025 16:09:59 +0900
Message-Id: <20251215071001.78263-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSf1CLcRwHcN89z77P0xjPLT+e+IPbcXWO0OXuk3PJPzxX13H6Q+Qwemhn
	/bB+KA6LnHT6pWJq7oqTfoyyfqxNUdskcVeGbg7FXHKZSWXMZKbOf697fz6f918fmpA4yMW0
	PCmNVybJFFIsIkVf5lStjmneJF+rqdgAmgYthvqfmXDrXZsQ3NoRAWjqWhFMul9T4O3oRjBh
	eYThs3kcwY0qFwGavhwSvjf8IsBgHEEwqr6NYbjbTkG9LhqGqj+S0H5eT4C9sAdDfo6HgA63
	k4IzbTW+4iYVBf2tBUIo/XWTAL3qHQXPjRoMg1qvED6a8kl4XF5LwliZhYChggjorlwIricO
	BJYGvQBcF69heHnVKICWjpcUlFgrMXzIGUJgNdtJKPudi6EiuwCB56ev0lk0KYSKh4NURDCX
	bbNhzuz4SnDNta8E3IC6mORs93sFnKH8LcVV6tK5ppqVXJ7NSnC6uguY041forg3A+2Y61F7
	SM7wPowztE0IuPyzTrx9wW7RxnheIc/glWvC94sSnCMFOKXQL3NU+wer0F2ch/xolgllH410
	oP92fDJNGzOBrM3mJv55PhPN3ml94ctFNME4Kbb9wY/pY38mim1psk8vkcwKVn+9gfpnMbOe
	vXnFTM6ULmXrGzuJGdfSrNqunHEA21VjI4vQ7Eo0qw5J5EkZiTK5IjQ4IStJnhl8MDlRh3w/
	UH3yd1wbGu+PMSGGRtI54v7mcLlEKMtIzUo0IZYmpPPFuTZfJI6XZR3nlcn7lOkKPtWEltCk
	dJE4xHUsXsIclqXxR3g+hVf+nwpov8UqFNTowCn3Tu3oW2f1jzzavUXXWxI4ttArHF6ubtm7
	fFVX9q4U+5T/+07jVvGqPVHgCNsYquuZsk6GaeMC0k/0C6Zi597Ijrm9OaBl7fOL23LLBkPq
	yw94/IKeSiwh34xpiZH8s52Bh4tfn5z35VBvqON0WKwzL9bsXVZ6ufXcgNIikZKpCbJ1Kwll
	quwvNeVonv8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRa0hTcRjG/e+c/c9xNTqY2bEgY5DdMA0030rKIOqQVFJQ1JccddDhnLKZ
	l6iYKbRK7WLWUoNZaaar5Sy3mVpsZlrByhsnuszWxTJZMU2d2mUaffvxPO/7+/LQRJCTXEAr
	VJm8WiVXyrCElOxYnx+x+95GRZT90jKoMBkx1I3nwM1+qxh8xgERVNQ2IhjxvabgT0s7guG2
	Jxi+ObwIrleOElDhLCDhp2mCAFvTAIJB/W0Mn9rdFNSZt4Or+jMJzSctBLjPdmAoKpgkoMXn
	oeCEtcYvbtBS4LjaKYYXjcViuDhRRYBF209Bd1MFhnfGP2L4bC8iobPsFgk/StsIcBXHQ7sh
	BEafDSFoM1lEMFp4FUPvlSYR3G/ppaCky4DhQ4ELQZfDTULplA5DeV4xgslxv9JzbkQM5Y/f
	UfGRXJ4gYM4x9J3g7t16JeL69OdJTmh9KuJsZW8pzmA+zDXUrOBOC10EZ649hTmz9wLFvelr
	xlyHfpLkbO/XcjbrsIgryvfgxJD9krhDvFKRxasjNyRJUjwDxTjjbGDOoPE31qJ6fBoF0iwT
	zQ59saNpxsxSVhB8xDQHM9vZO409/lxCE4yHYpsfjs08zGUS2PsN7pkjklnCWq6ZqGmWMjFs
	1WUH+U8axtbdfUScQ7QBBdSiYIUqK02uUMas0qSm5KoUOasOpqeZkX/m6mNT561opHurHTE0
	ks2WCg82KILE8ixNbpodsTQhC5bqBH8kPSTPPcKr0w+oDyt5jR0tpEnZfOm2vXxSEJMsz+RT
	eT6DV/9vRXTgAi2K1D3eX7V5+EJaxI4xds3Ucv1XU6H1uzxuV0ne4k3u5c5wcLXOq0yuD9fH
	7vtl+JBY3d27siT0Y+Ieb8Doj+MpgqSnpmlOdl32TtsNnERFLfKeSUhmN+0u1ymnnkdVO7W7
	SsPWdcUOeo7OinbVL7PSwsuBLc59hXfys1Fo90KWkpGaFPnqFYRaI/8LI6l0buICAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 68CA3140010
X-Stat-Signature: epjr5jbw9uuisqp9um6ns84fcq6d4jab
X-HE-Tag: 1765782614-79044
X-HE-Meta: U2FsdGVkX19qbZdQnM8rF005SKRbQBF6a8Bf26+cHevv0x9oWrL0kuElztMDu1YaVcShO0dP5LWuvX4lddarNi1t9R0cPH7iJwSUdv1XSwfYuRCzEzbxI0m78srTTg6qU657dLR38+sHQU53dL9pU+Aro9DIyCS/f9Fbf/nxFvRKWnhaf8y11sKyMUKO8vGtlvx/ZVuXGQhwn4XhZ/DA1uATnLSFdINF7hIX/OxubvdPFBRGejiVzFdCIXDrK6/qrgTJ4dM4EY2S16Ok1NlhpNqOjO+UB0eIe47xgOfSALrvIoGWvIX5j/QKh+ENZWSIgsjATPOjX4t/W3A8VW9eVdkwjGjBSmWxSvW7cPuVS7qGamuLsbTW5puaG9fxdnYP7atd7+V7l3kprRbFb+C81UFyp15YQCi5f7O0B+MazZN0Qkog/vA/vif8B0WpFq+WZtAzcA4OqI1HgYkyfzpyZrdBh7nitOhNzXsXxRfoxnh2HhjoWzI3xCnUNBcQLvUUCmIUiDQuS2G4ixHvcRhjUrPzL6R+1w6UKVFmqwq/SNlSU+S2SEnZNqfis6QUviItibHaDMHYq9tj+X5+MXKEI0ea91g6r0irqofUS1qOlWvYjT2kkihcb0Jz26qcgzI6FDEJ0hDA0mAE5zuzYfyuQibLUiH15sAjHjJuie5/eSjesMWC7jbhMK9wQblhHrzYp4OO1Uhqr0zyEaFYLNhyTIXZhAzinDaAIE+Fn70poZ0yWRuTuuUo+esPVKlcimqewVNGZ/IKDGUsfRCusDxwbMggEmlOWncu/Fs6Hr+XC3E1RVEO0vzTL/vUVBFU9vPnO33AxiTJNQIjCGKuCye/O7doGyrowo1MjpL/QDBvzZRZwo35VWKdgNk9FNeTM4hSEbzFvg6eXJT2qprtMYkO+SrdlyrzsM8WCradgC1spkIsxe40nnOfu4sFdHi4nWrlRn+qOoQg2b0fcrBuSLP
 Fc6m5oPq
 EQnKVt+L4RWuG5QWVpA30H72ZbWAAWKFDu4/fe6MMVs2Bz+jzdABMou88pXhpqS5Qfntq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This set depended on patches in the net-next tree.  Now that mm tree has
been rebased so as to include the net-next code that this set requires,
I can finalize the work removing the page pool members in struct page.

1/2 patch has been carried out in a separate thread so far for the
reviews [1]:

 [1] https://lore.kernel.org/all/20251119012709.35895-1-byungchul@sk.com/

Byungchul Park (2):
  mm: introduce a new page type for page pool in page type
  mm, netmem: remove the page pool members in struct page

 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
 include/linux/mm.h                            | 27 +++----------------
 include/linux/mm_types.h                      | 11 --------
 include/linux/page-flags.h                    |  6 +++++
 include/net/netmem.h                          | 22 ++++++++++-----
 mm/page_alloc.c                               | 11 +++++---
 net/core/netmem_priv.h                        | 20 +++++---------
 net/core/page_pool.c                          | 18 +++++++++++--
 8 files changed, 55 insertions(+), 62 deletions(-)


base-commit: d0a24447990a9d8212bfb3a692d59efa74ce9f86
-- 
2.17.1


