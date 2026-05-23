Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79661CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7866B0092; Sat, 23 May 2026 13:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAF936B0095; Sat, 23 May 2026 13:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBC06B0099; Sat, 23 May 2026 13:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 872A66B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:29:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F33440BB6
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:29:30 +0000 (UTC)
X-FDA: 84799371300.25.3E0BE17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 96A1F1C0009
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:29:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PTcJJqqz;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779557368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dC7TBO9DtzsoaEzSvaAQuFc9cZ1hcuyyrjvxcLSBsWk=;
	b=m4iGEZkaJJ10wPA308OF5GUBvsuf/sdcW8HNNA5UHCN0XY6H9P0Opc0yWV0GDTR41aZBGy
	Ajf8RVU+aph1+Opr/dChYVHOpMqhXmHVl2pw7orDoQ89g1WbVwGnPLJyify1paa612kkHy
	eybZvMkOyiGJWWEf8NguCM3WPNCbFXs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PTcJJqqz;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779557368; a=rsa-sha256;
	cv=none;
	b=cHwjmB4DW3j/dqOUcbu/ZUCtWUCiB1VyMHZSqgFFl0odTQ8YAqvg8OqMHap1j6ao0/b3LJ
	tju0RI4AXUth7Jo7TqapqWaoyOBS5VoEMBjAT5L2R1yHnU5QPbxJpohSbWBB0kslSJZqXk
	B7dJL6dsS+cwofVTk7064JJxRG2JhKs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A340243B49;
	Sat, 23 May 2026 17:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2984A1F000E9;
	Sat, 23 May 2026 17:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779557367;
	bh=dC7TBO9DtzsoaEzSvaAQuFc9cZ1hcuyyrjvxcLSBsWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTcJJqqzQ1SKdxbrz+AfNbRfxYYbiVtztm5bXiQrjsFL79rMbwNgfwnNyWzP9qXV6
	 1hHnH8sQUsLSIrY05N3yd6r2AgeCfbP9uJ6fVHY2vH06S+S8VgX5//h+pif4YwgSsS
	 D2thfMu+8v7VFVHpg6TXuib7dW+wXD/mb6qF6J6sid8B1PtU4A/3zMEBvCw2zoUxv1
	 T081B5s8YYjaYh4faNOxw3V9au/RRp0wWmp744hAcC5hx9M6Aw/Fwcb6SzUhcg3j7P
	 jGowPcI5hJZKprtegItynRXFek7He1MMmHnACIo9CaIG2eSZbMJE3e9RmhCItuxZyT
	 zIij0czoL4MdA==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
Date: Sat, 23 May 2026 10:29:19 -0700
Message-ID: <20260523172920.89354-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522145518.158910-4-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4h7xr1b4o4kpn61ge5b3cxuoicpqhu8c
X-Rspamd-Queue-Id: 96A1F1C0009
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779557368-636915
X-HE-Meta: U2FsdGVkX19sxU6QPGB0qFMvADrvAl0A+Q85rmwngiNp8NGhe1m91urtPlxdHXwIb2kG5nrtZXwgxTXtLp25pImWv05Ii2sYgVoTNc5C3SF2E/OpdiKnyLs0MtUViMNDdQQraZDsXyr/REjnmDb0gu65sHqZ495ImoGPGUhpr3rStr5C5hzlvDNI0avGGBKxymloFYgrpyu1HvZiRLY9Gk7zbEHWSFw5yJep+KcUO1JxN7z1gpWwCWSul7aiZcUR16/eLoDIsYKC9ZDIbZTfOenv5ZO+Smz+4XRBGONjj+SJ3tubk+R9/myArNkVtdpBcbGvl6HC2xgNA+HEBAOFEdQlYfptfxX5igWnbs6K6v67zYVsdm/YsNI3P7CONNXdF4iGPVYJEUk45e8RQOnzYKbkKrSuTIts1FNXUOyP24+aeB7xyeeu6mZJEnTlVW/R8CbHp4Q/gJi3DIFs2+2Vv3vCjJRa8P6rQ0Lhn2ei3lxxiST2S7IBHV+rVB15uUyy4+p/W7FNWkE89+XrUaYTeHO8SpZih4hqdfRsMCBD5bZIyVxE68A7d/zOFFDz5jyT7ecAJgpWO/7hi812Wq9ecX6TcKGBrExqbBzKT58NUqc0hbK+F/vy/0qUP/q+0EVMPa5U+9pcDNpUBrLMsj1N5DaXz5TrFiFM18xYfkI6x+0ucpX42Ut11+I6d1of2r2FVE8JB5QHdQDr7oQzEHc/v2PF1kIe37uCZBLcmIJUdmDCH4Jb2a79EV7lybq5ZYVv4bADNSgc/J5U2wunLM6iQELCNd4+Ij0LIK6+uEQWSRuvi5y1Dk0FH6PzKoleb9JYlzzL7XqelgoKDSK3T8IMqDWehyOF1TCvtY7iBx1PqDEzgzRHT933HoKfmBMWqEObwB7DkZ+eFwxp+8IvqhL3H74fFcuTPSDm1Z9nXGX25+sn62Z3N/Oj2KsWOtRFQged7k2TojKL1PlmFsDNGS+
 CK1CslP2
 lLFzEF8yWrzlpaJdRVm46HSbceBY522ha7PfrPG2X3rp8iV92M5FC4DV4AlPmF9CVnpfhgNSbqEG81U3K6JcH7DcxJpPQolBajp4WhSQISYGlk+UPxLmE+r1npi9PyJPv1JxiyHP1Mi+l0v1GjHfGVc/UdGvGZZby2GM5OzrY0dL2Sx4Nrq0J1o1TOJgOHEp+2TlDK6Db4fozmArZkYpQuOKadYFF7NBj+Y/d6LiNCjt0yuo30ZXplNpCEhcW4PpZycMlxYq1Tvsa+JBOwt9iIi2kNdCyYCmdsG+tfL2OMMVAHeAqaC25XbRhRBZD9g2gAj1X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 14:55:17 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> This patch introduces a new DAMON module (DAMON_HUGEPAGE) which
> collapses hot regions into huge pages.
> 
> DAMON_HUGEPAGE operates in the virtual memory space, for a specific
> task. The user is expected to supply the PID of the task that is going
> to be monitored through the monitored_pid module variable.
> 
> DAMON_HUGEPAGE uses the hugepage auto-tune mechanism to increase or
> decrease the aggressiveness of page collapsing. User autotuning is
> also available for additional tuning aggressiveness control.
> 
> The module also includes changes to the DAMON compilation, so that the
> module can be enabled or disabled.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  mm/damon/Kconfig          |   7 +
>  mm/damon/Makefile         |   1 +
>  mm/damon/hugepage.c (new) | 343 ++++++++++++++++++++++++++++++++++++++

If there is no clear use case of this module and this is only for a
demonstration, I'd suggest to make this as a simpler sample module.


Thanks,
SJ

[...]

