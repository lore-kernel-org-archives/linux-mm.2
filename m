Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B031C531F4
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 00:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8986B0005; Thu, 19 Feb 2026 19:37:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167886B0089; Thu, 19 Feb 2026 19:37:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068656B008A; Thu, 19 Feb 2026 19:37:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E208E6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 19:37:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D6491CC8D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:37:11 +0000 (UTC)
X-FDA: 84462970662.13.FB6C9D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id EF37120004
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:37:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NYilZCpv;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771547830; a=rsa-sha256;
	cv=none;
	b=jAdefff9322scv+xeMGMX/NKi5ALPQn0RFnE9L0h9+l6W4gpksVJXINDF79jUaEGKXsE9/
	KbxoLnEEmYiIdFz7WqZp2wut9qqFK8qAKMncJJvhYsWyr6PSMMZq7EacPWs64g9ZYePHQI
	QSmGp22yRJ5mlAk1uNblCCOwVqlra5g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NYilZCpv;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771547830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1etmepsH1Bvev3MAuV8LszpOjPcfS+qmkFAJa0JyVM=;
	b=dOVWLmZLLRx/r/Qlkm2hWDhX+7INFN83rbZ4tHyL7V5oHjtUNKg7tcHB2y77/pMBnKoOOl
	4aAeBaZ1Hq5uq2xytAoBO91cAgho6Zu1syv1eU7yc+knKbG5GZy7c+/Su8pcmDI6CIFogH
	IDUvVJD51uPaxKbg0/RyREKDvbYj0qU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4761060054;
	Fri, 20 Feb 2026 00:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9095C4CEF7;
	Fri, 20 Feb 2026 00:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771547828;
	bh=g5CMc919WnT/Ko+Hr9rTvMXTR42y/i3Uxs7t4e11M3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYilZCpvnYHvkEY6+Ja7rnwuyXlDPgevW4jqRfGlevYbXTrf+G2qi0bfyPdDrmtOZ
	 pkUp14i/iXeh+wJ1za0qT3RHDcDQw5j/84hDTbiFDo6bC3q6hSqr1tGpsHOSnDuak/
	 7jWfdx1ioLDy9q5HnnAj+JjBzaIhuuIzHOiXRBXETAzzKyphDUIr12gSOAUp4bWZjH
	 jM75ABYgzcjQ2TMtGDCWjGRW/0BlhajGKr0M0QYN3cazZu+f/TcgZqDisl7FdJVVT2
	 njG8edirz/S+BUvObbLKP3IQPQimxeiXSTvGD6eNnjlET7/2ksfQ9EToC7FtSk3HJo
	 jNmRbZLtVoqug==
From: SeongJae Park <sj@kernel.org>
To: =?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix typo in the comment of mod_zone_state()
Date: Thu, 19 Feb 2026 16:37:00 -0800
Message-ID: <20260220003702.72962-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219234407.3261196-1-mssola@mssola.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF37120004
X-Stat-Signature: n1nts5jw4uxmr9sctejyax183o9dngw4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771547829-503303
X-HE-Meta: U2FsdGVkX19xjW5rWJOrkbnga+gzkPY3HF2ibbK0jDbx23kv3xehj7ZnJxZrB4lpieo/SF+rYswVGBe518HXCxpR4mJ2pbqoEGsJYodmzKM2H5AHJSJpF6RIC0VKCt3JiGA4Zc8CdqKxRXeYOsgVxXcBHDfn3sUcVuLJx7C3+ONC97plKaVJHkNrF5tGgSKXur57TSi1XD9Q5q+5rE5WIKLLoUgSu+BX3h/DqGI8dCRfzgtFYET1kO51uTRoShS8KtzwxBo7QWRDSgmjPk0ZOZ7XgJbejGMg5Xge48PaS0tly7OSj6cHduxwzNGA+qqDzVUhQ15MhyNFGGP39AXZkSsbvRj1GKctOrCdhRdWD7+/IwjhYHvXGX8y4HwBoSkEWj54/wAvrRdLh2gvFLGuYOpfO9AiErLJqcjq6UjGH8AkYuwletKUsd7WYYb91GnavaKElA+sOUGC6PZF7FfdDt68I6+/PgbqupDCp1P2jc9TwbDMLEmMXCI13rs8eoOIFr7nNQOzp+YXfEm9BHoKUsLoaM8JRYHXL545GUiVchNmEWksj0q4Tblu/MwYt7iPOn8nLLlmVijAX4/2sLkN0JvpflDTRYaFIsUs2wcah5q7ye+RjzN7M0VmStpP1fp8LYqgE1AK9AduMoFk0IpHxBfH7UqlBIYvGXqJHBpa79uhDmBuAORMArNN2zXWulw+4egPBqr4gHNuGVvK37OkIbEsViJeRHi4hBC6o9xijgi4qDxozryzzJaGKcn4nxP0mO2CQ4E49KnAS3MfP0dxZbxDox4mKCLAoMR/vK/kDoOV2RyeF9QolYsZSZRRJJPcEJqpNwvwdlP7sdqt6ujff/Qpk1wVolvC3kY+Yjwlns4bPN4ivDhvAILc8LpcRlHLo2jrIPZHv7QYIwmEE2vLS4Nwwd4E84K/RTiUB61z2EQRmaXGop//fpCkVq1Nu7WPsIWMEN8J4FYoy2I+bEM
 9lEAIt5B
 g5O7iucXcUIA6woGxSZDhq2r5S8/AKuq+dmIZBnJD4UjLlG5jfi2w47OQmHXl9AmnjEJw9wetYue6/uHVo0Zmo74uz9MEYPkdHJgn46T7PswM9SkM3bKM3Z1y3pA4IdgIOg/7XV+sUHw3YMTbGFm/RE5BnT7UmFhe/k7aBw3xG/7X/4OBQsnej5bYCISvVbxJQapUMXQKHFtUuGLRC3Ao6r21s1Crm/V2LheZ/0jxsjKceDPs8e/IM2QkW9GTBfp3zWdakxxe1Xb9ffAJhqbnS4ywTGGkp31LP51NwgmS57UiBMKV84WVTR+xa4K9gEcZsnnW2Z/Scy2tOF8/Kb81EydW2L1v/NLMIwYHXsA3LCJhgPpFr4zpn0ibXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Feb 2026 00:44:07 +0100 Miquel Sabaté Solà <mssola@mssola.com> wrote:

> Use the proper function name, followed by parenthesis as usual.

I'm not sure if it is really a typo, or was speaking about the general
this_cpu_cmpxchg() variants.  Either way, the change makes sense to me, though.

> 
> Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

