Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7800ACCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 11:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91FC28E0006; Tue, 11 Nov 2025 06:23:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8DB8E0002; Tue, 11 Nov 2025 06:23:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770D28E0006; Tue, 11 Nov 2025 06:23:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 603248E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:23:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5BF913B2A2
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:23:29 +0000 (UTC)
X-FDA: 84098090538.05.C3FECCC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 66B7320002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:23:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sQi5GVpX;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762860208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DyZ1NJyfiToXj9l7QABdQT+yCm3VKxencOa7ihEADv0=;
	b=Zmv8aS10l7nS8I9Kxc5gqCRe6weMBnS/PVcam7D2ZSCAGIzW8jnEw3A8ZYA87K0KWNs5Nd
	+pTKkC9n5ykoV2DA3gNAdR1khmMCO3duyzC265e+GE5FzQdVim/QKYHcM6iHIs4csV435Z
	U4srMi1TW/YG1hU2bB+rXe5/ncYEDms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762860208; a=rsa-sha256;
	cv=none;
	b=n2Di1fmWojArBbEpq+XSyMEwIMT84nhF+ensS5Nvosf92YORDsTuP0Ao3qpM/lY2z48E31
	xjP8fGbBiKEjYrpMo2BbvbwyzWMBeYeYz9XLG3SpVLAYLrXfnQf4U5Md00XpishrUJ7+b2
	bPPKkuxoxhAEeKg68FlOvwoLmZCaZTA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sQi5GVpX;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A6E361903;
	Tue, 11 Nov 2025 11:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759D4C19425;
	Tue, 11 Nov 2025 11:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762860207;
	bh=Thw9gqzu/5zeb1wIIdMk1FSZcopEkspAzVBeJtniQYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sQi5GVpX52PRCMj5gkIAH3YRXiiuANNgtGHcppPScXsYfdyl02sFfNzrO3aH+a/Ax
	 3TuLFVEa0u8rU2MSpSVNrhAuMVX2bSSoXzlUxvgfHAPpK9AN0v4w0qGvpV0F8jgPgn
	 8uWk759FEvUsB9g3yf1epocdoWilRVE9s3+GHQHDjLz3k1htz/iQPi2PI5XdOqtruH
	 4d1Q7M02OXK0Znvb2uxqv2F741E82EdwV82NP4DBWhgim5fkJDVA6Lu3t1buNOvchV
	 CStv+8B1S/nj4DSDhQfNCnELeTWHXq/7wXAT2BsdhKSSUSyRlamKFJ2E84bZRrghdU
	 kjp0x3ofb/xWQ==
Date: Tue, 11 Nov 2025 12:23:18 +0100
From: Christian Brauner <brauner@kernel.org>
To: syzbot <syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, bpf@vger.kernel.org, bsegall@google.com, 
	david@redhat.com, dietmar.eggemann@arm.com, jack@suse.cz, jsavitz@redhat.com, 
	juri.lelli@redhat.com, kartikey406@gmail.com, kees@kernel.org, liam.howlett@oracle.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, mjguzik@gmail.com, oleg@redhat.com, paul@paul-moore.com, 
	peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, sergeh@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com
Subject: Re: [syzbot] [fs?] WARNING in nsproxy_ns_active_put
Message-ID: <20251111-dozent-losgefahren-0a3a086b293e@brauner>
References: <20251111-anbraten-suggerieren-da8ca707af2c@brauner>
 <691317ab.a70a0220.22f260.0135.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <691317ab.a70a0220.22f260.0135.GAE@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 66B7320002
X-Stat-Signature: g63595ox8z3ufohs66pfzmhja96b889c
X-Rspam-User: 
X-HE-Tag: 1762860208-516876
X-HE-Meta: U2FsdGVkX1+/egO2kAWB4o5wjNLPryf6/VZ9SxAdQ29l3fuStAn0dVTTmt25KaOMYyvwWAIiKY1DarRfCakYGElapXOKX7ZOnfWmkwIsziBWaGzeTKF4FIuwIoTkX2f4GAz+SftNrHZtTPpxGvD7SOz0zTwcIO9bp/WWCdwLdXhEZ4rQ+HIhVC0qexn2BOqR/ojC7tYnBBEYrjXTWk07u/GFMYZNO1n7u79qOuOx5q7Gd9y5o4dtv/2RpwHki4TNkMyE5EiXZxOqJmgAQIUczLxHXwt19rNiOOrHLWI3WtBBs68vfRcu6OHMMsgcKhj7CEC0k7YNdeqaWEqoFe27P3lvV5gAepq/lsDAlVjn+r7LPQ53/FiBc7t4U6/nVMTRKKM3/Gq01a8kMlDiMTA9RaPQRdnw1mSSciD+Lvcumz/MQZnx71bdLu+rWCey1IDP5zR3Mcw4I7CbJUg2tPtb7UsA7WotsqUR2o/PI+bk9stEUNJysBnkgKeKK8YQ82lHRQN6zVudJA7kURIkjEv84JhpHasXvMmYzuqnHogF5+W6HPwutAAvvgQyQg2OZVYgxEt9F38kUQ9K3TT2PmItRwW+XxOOvaiWaBE5Tmvyr9eyMEl9U6laIcr8kbOKYiIHLB/7dlK0iQFV5zmhauW0fLzdWivULhwBBV3AcUMEgbQqpH6uLDlfhUn6/ZvmKELbtCozBoFq8uMttyq1qq8KQVSpRbbJVekfZLaNR099q9GSAAz/EGT4AHOnMmYrzJqVZ0vUi+1o/3gdim+NbdNVgU+B02F2eXyRqLE4GKt8A9AjgXG/YHHUOtr6w7CLnU7i+K5lLs8YEGSt3W+EdtNWLN0XvEi6hx2G+kPnT7uJyl1jzzGK/IAzanr3D6VBcNC7uWAjIxvI3Slg9dpdnJQRjqf8L+5304wrxI8INg/iUjj7Zwuy+4bZdbjIt7TFoFLUpOQ8iV1TtApdzCKkDUg
 wYlztWHK
 FdKJ86Fs7ICyy/QqZpcWH+/RBymxL11uQlK8eFNN7ckJXZp+4iJE8hOMc61lBWD8CDDlnb2qOqzyp+JMYjSY2Rs+YUMYhxv+24Is7uUgBcrjbPG+9vuNkONh2Ku2dkoZ659Lp9LFuVBtQ3dgC+ija1Rdth4ENXtowqFX+Qap/4uF4OYwma6PJYL9reWRw+Gr+3O/P/nh2ciw6G6AlFi+hQi3VmksoYOBIRxeqL59xGnM0MN13DIZIOhBTANkyr23QzxqKLUm+19LrsZDu++QM99y6iw1zC40dQZt/TgVVErXGJM2d6KpwNbmVYxpmKGXI0Oi6+33xpNAjEpjFqNayN9VffQvFl/p8WX60levzMrM0IT23W/pNkyxa6x3zFZAzk8MMIFU5gllOQamA4f1qaYR2WmblMgbZYWjgogfdeh85xGDr51PmPbJqiyByqo6WlEdYbzsvN9NcgUJsxgA5vPYfrDYD1xyiOR9uOo2MTsLToRA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 03:02:03AM -0800, syzbot wrote:
> Hello,
> 
> syzbot tried to test the proposed patch but the build/boot failed:

I think that's unrelated. Anyway, I managed to point this to the wrong
branch. I'll send another test request in a bit.

