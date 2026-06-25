Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77FCCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 04:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCC5E6B0088; Thu, 25 Jun 2026 00:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7D306B0092; Thu, 25 Jun 2026 00:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6BA86B0093; Thu, 25 Jun 2026 00:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96CD26B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:55:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A58D1C338D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:55:30 +0000 (UTC)
X-FDA: 84917221620.27.4AD70D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 648EA18000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:55:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=k39ubIYC;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782363328;
	b=S2X+6XDdoN6mgadkTXtngm7d6RvK5+sRRNdmIHe3ZwNZp22D7Ib0JVd6sY1WQrk6j2KxHi
	c7bEog9eZ9D3d0QKl6aL+sii9JOJ/fosjW0BADsjjDPyz55p+r5IC+Aq+27NZTlkv80p2/
	bHV8aIk9M+vEwX7xaSBCanpxCCekGHY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782363328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ik2m8/imiD/kJWsba96vvHBONj+BHsLpIB1uKAUvSoE=;
	b=Dqy6Uv5TonOP2sP/TcQTSHsDA0ioa78Hp9Pl8smf1Vm/DlNRF6371YqLBKomkYSI832B0A
	iZNK0oRyeOXcSY/SALOFg90eqb4zqNln+jmNnZJDmXHyr8eb7B0W3eqapVfdjwaB+xnheh
	KpyW0B3FMR9YRWgyvNrHp8gtLPXcr3I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=k39ubIYC;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C38CD60018;
	Thu, 25 Jun 2026 04:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0884F1F000E9;
	Thu, 25 Jun 2026 04:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782363327;
	bh=Ik2m8/imiD/kJWsba96vvHBONj+BHsLpIB1uKAUvSoE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=k39ubIYCvKvd6eQOfBEnNPyk3KX3fE6gevVRpWMgPbfWR1BLVKAsluNKxhlK1pVXb
	 QIaibRPE10O4s8KeF58gh4kYGFWQUMzjQC0tZoPhxJXxwVkMyyUIgq2U/5xpG90TBs
	 4dgAu526VsIOkRY/RRIRBTPNu0xmZzDmtECm/kK8=
Date: Wed, 24 Jun 2026 21:55:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Yichong Chen
 <chenyichong@uniontech.com>, Ye Liu <ye.liu@linux.dev>
Subject: Re: [PATCH v11 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
Message-Id: <20260624215526.ed20169b440c62d71a3f9d90@linux-foundation.org>
In-Reply-To: <20260625043101.338794-1-zhen.ni@easystack.cn>
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ojpbaahh17nc89ke31xpec176oxbgmyb
X-Rspamd-Queue-Id: 648EA18000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782363328-565754
X-HE-Meta: U2FsdGVkX1864tKl5JJLMZSUwfibxIr251fZFf4avsR5uKmMoKIb+LjP05Kr1Cs8zzzC9+MSrnKF2CcDNemKQz67XAanC6x3wqH4fxqSRb3W6JDeqkEEZ/A+JFtfGisORXSTi8Tf9Z3Hib4F372vouBEpS7YyINuaYAr/dg4YXsXG4rbxnLekyG65UMA+uZjzqoLC1dpf+uAK/bIiYgHBJOYApQANKc5lRcsVGMU/8wndFzVl7XwcG1iZqII4N9Alhc+2XbTPM1YJxef6GtCtA1hYlSgAmObayoFSE6yNeKWVqFniXr/+BD0jS6RfoS6Zgs51zRfaCAEcfgrQ6U6tllib/BYCiM8nqlGZ0njtXdD2QaevOFZ8RUleLjWGuQjbo4YGIaQH+BQXOQE2GgYWo1N3ln3GiY/MA6oMKdA9b010OR2OcGyoyBY/rN9knn/uaYlm6l0r13q0NnOmUC431c7ciQqjItMdG8HUpSNVb8KXO3NeLJvtZAutw4n25VPrbGH9yxR7GoVHM6unlBhJo9Am1ne/9iUVW1+L/4ZwKkQAoqb5cF6i/h2o3ltvElh1Xs7RrQLb5UkqeI2hjncphAlH3CAOwiNxXUya2swJcqEr3o5xoCXRQhrgqUgnBszMco2C+wUEOut7O6fv7lxhW7yYygQ51WYuWMfDe4olVl68bMQSSONCuXADGcrnQL4GHSzU4bQd0RtQhLM8Raxvtxdftts5Hya2ewPCoe5vZtijPduqBaDG2dFIXInpaLu/S9li5rTNhkoyEKQj1f1BqsB775N/R4dO8LchjOkYogacOsOKF+ZpV+9bb94f5XcHW0qBS2Qh1DMJNjpWx8f6IKY/0Oa9nYzfEB9uy6V9plOmpMGu8626waBFhtB86j9oPAMh/fbfRKoju1kA+AFCJbP9bXV1iETaCyNhJz2p8TW7DaSWc+gqoA1PdCN07kdV5sw6toYvxRrvOTLXqR
 T3HiFLHm
 EOSk5+nYaYq7D7qcgArX6fplWg6Wslr7YxD57QrqDBDkQ3GRyip2d1xgmooUIe80Fg/Fs7h7j9K23TiKZ7GFQQRrvF7+osJ+1nc/SfMqott+58Cp4yJK6q5UAcsx3vmByryk7X3Zv2gJVG3bzLAXN6S9mT4xuwyj0LlqPue1Pmsx0AZc5ZLejXaOvG2J9p1o46oxE4aUI9bkGTsrkk4fgce5SfOnsa86N6G0P9bWho2lBAKHYjQt4KYJA1YTKahozTQwd7HUPyT64Ku6CRWZ3KqF7cUnjeGBnvmu34QTdDLa5hfk5dTg4cfdGYIj9VEolHRWqWhHXIsDjzmWDHN8eyoOVajjW5gEqcknX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 12:30:57 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> This patch series introduces per-file-descriptor filtering capabilities to the
> page_owner feature.

Well, I assume this work was inspired by your own operational
experience with page_owner.  There's no better inspiration than this!

Review is thin (absent) at v11.  This is typical with page_owner
changes :(.  I'll add the series for testing while interested people
check over it (please).

AI review might have found a few things which you might choose to
address.  Please check it out:

	https://sashiko.dev/#/patchset/20260625043101.338794-1-zhen.ni@easystack.cn



