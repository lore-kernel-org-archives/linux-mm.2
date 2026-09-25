Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A145DC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 14:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8EE6B0088; Fri, 25 Sep 2026 10:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD07F6B008A; Fri, 25 Sep 2026 10:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0EDC6B0096; Fri, 25 Sep 2026 10:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91E436B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:32:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1CEBC065D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:32:02 +0000 (UTC)
X-FDA: 85252524084.02.6FF932A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id 375FC10000C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:32:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=TCA6XtXP;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=1jXvri7n;
	spf=pass (imf05.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790346721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+JIL95sFEZcCx14lpDodVix1cIsP41lmjXHFkrMk1m8=;
	b=hMVaWJia8A8LgSYhOHxMzpfY9Ac0xNLVpm2PUI6L9pCp0rDaI+gtdcI6a4L+OR6IqQjTA5
	phoR+yXRpsfSPiTJDUzf/kvwJtargvmmMhCyAdUCLz56SG9pFowGDNmGNDnuDhQQYBn09h
	oKCyWd3+JVtXqkCHiukrkn939XhwGBI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790346721;
	b=icrROAaJD9VmV62csqsTfkgL1kfW6/DNifj1++7f7tzfSQams8hv5YjBgts6LLJF7CiM7d
	n/+yd7ZWZQjqAaeUD/IiPTDg792POVq/F83vRxZJEEJynUrFbD4NHQxniv5Ad6xlVP4RdL
	npWAJzHZPRvBGXg4rvIKKMbDpF+q7aI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=TCA6XtXP;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=1jXvri7n;
	spf=pass (imf05.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Fri, 25 Sep 2026 16:31:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1790346718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+JIL95sFEZcCx14lpDodVix1cIsP41lmjXHFkrMk1m8=;
	b=TCA6XtXPBrNcIzBwJB1OVxjDwrJMlTQjFnIgkDjDLiuDToIBh6CYJe+ZGIHF0BumDNfCV6
	gckLNBZucUEG7W0vYJ5iI+FisXiK6MgQK+KTufXkTo00upcujKiNh3uRG9iojSOO0qjeNB
	3eSIzO6mz22MIkCy7BbhnhvEt4Zt4crvRzuMAjP4XP6OGSWv7/ps0Jj1tUndZDdjj48NCk
	iQI/f063LdspiE2vCPXQv9c35zwKO/16OL+5gpMuo39Hq6Eiy2zHZivuRs5u6CSZ+Gyv5D
	4qYNfVzSzIVgaubDD9DixCbj/xbZVnhTReo70M9XGFJTNn7y45SQ692UGGQJcw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1790346718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+JIL95sFEZcCx14lpDodVix1cIsP41lmjXHFkrMk1m8=;
	b=1jXvri7nMuvBw5HCzlHfXy9tg9qEk4Ee6RqN4OBHWMweIUEmb+K7bBYft6Jmw9X0NYdI9z
	Qx0AvOQOmFx7dDAQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Amery Hung <ameryhung@gmail.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: restrict can_spin_trylock() to preemptible
 context on PREEMPT_RT
Message-ID: <20260925143157._HIZ9lrl@linutronix.de>
References: <20260919171443.90512-1-kmehltretter@gmail.com>
 <DLJHZEZMLW0F.27OPPS218CX9Q@gmail.com>
 <arIY0wMQjCCsqidI@gmail.com>
 <DLO3RV3IQUOV.21BNLF4QS9T4W@gmail.com>
 <c2f8eb01-7a10-4ccb-92f1-eece29c06cd4@kernel.org>
 <arZVV6Vq-ZJuCyun@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <arZVV6Vq-ZJuCyun@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 375FC10000C
X-Stat-Signature: 3i4coj19366wrjbyf1sm4ppedj1fej8b
X-HE-Tag: 1790346721-223364
X-HE-Meta: U2FsdGVkX19RH//rkr20WuBbzq0DtgK6PRmkWxCTmaR4MgKSVEnBjDeGqvwpre4xolO5dD2YkNBfBXaKh24I2OLuTAMzd0pf7NR3mR1SSQh3G2jbs8Mna90Lco0Oqmgi0Hd63Mao636bw0BG4G8XUPo+SxBZVPSHqd+wc4Ens8qyHSuCjRlUfcX17tcH/q+iQuNlhrZfQ9jkJofimd0eRWW9x/h82UHruKfTh05ykPmG6yK3EuRW6EaXo1zaS6W+oEt+oYAxtX9WxjNwKSWjgW+3L3YDBlBm/fPfrtat1J6ub8G6n1UaK+cJwlNwwI/ymqbyEVE8hsM5xhf5K8nwDWxYRqXkoevk+UookmZS9fGqZSwvhEsTsIcdorP53TP1q/F10XvM9FmtWCTOLo+ngZ61rlfLojZVJGOD0tMq4NmIYf9DZxCA+r0V9F/xB1Jy8qYMEH4+lSwBNFWzH2aB1E7GUm97TaK572zCbEcTt6iumE81KX11cr3QqNaRX65yzWTpwN9cR9WPJBwmvxrVOtB/lPI5AMpJkUoRInuxeIrWEdlEefKSH8mSmpTDviuszkgvWqg7heQdD/ez0yfE26Hs6qij2Ngg5gfiV4PfOOGPppERkfPf1eglgenw78tlHAjPC7owY/65kpt28fCnNFV7hPk0/wHds3jEMZ3Ae4t54udL1bSRVToy4c/kf41OB+0iGw/51X9TzPmajkMQQFm6tbAvO/I/02MaeiF/DwbvKuZm3zS+NkNuvOZUT1BYd8tf77y4SoF60X6aIiuvgReCAReQ2bV7pDm1MD6o+iAAXb8lmixf0CWLsL0WOimh+a+zAmZWZCK/nqzRsghQeVvayEXmM1o3BndPtSbBUfIi7X8wVw+Z9p/XSN8xZEK8X9MYm2pzYmZGbf7Nt8xerQ5MMAusjOrNwN5zWsQAHp+VYZNL1k46F1k7zFtdbEoZAtHTcoHWUnmGkBvBfHs
 9rlnCFOX
 SqnuUZ6GWzNbTGmZe5pUuKUirkWqV1rfg3rqPoLhRXWY982kdE1EURXIowUsZ+2wpylxChyVE0Gvg9JhC2G121XfR4sU3oY8YpDhpBumOWeMN0ndOEtvNgap2GH9Zz+tTxtTVyxgkJmBKHhsKvvQnVPhMGQpVdrFxPyjgxDkK/nqZoHcWv8ikqfnVc+z4DYnBaJmfSGgLo5NoMz9TFG7AE5D5Fwxnk6WYOmUIEaYOIggJ8FB/aSiqxYrZRRrbORmvS2RV54rgAhDbMGLqSmSLM6oMayahvZMwzRzJ9u3jgIXus6XnBdJ3+Rn7yQANXPVJtz+T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-25 12:05:50 [+0100], Harry Yoo wrote:
> > e) Introduce raw_local_trylock_t...
> 
> +1 on this :)

maybe consolidate first the existing variants :)

Sebastian

