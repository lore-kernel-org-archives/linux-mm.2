Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1562CC2A072
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 08:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67F306B00FE; Mon,  5 Jan 2026 03:17:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602DF6B00FF; Mon,  5 Jan 2026 03:17:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5019A6B0100; Mon,  5 Jan 2026 03:17:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 301F36B00FE
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 03:17:36 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60C8814141D
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 08:17:34 +0000 (UTC)
X-FDA: 84297206028.03.8F4D856
Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
	by imf24.hostedemail.com (Postfix) with ESMTP id E8A80180004
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 08:17:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=hdTqEWRZ;
	spf=pass (imf24.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.209 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767601052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q8PYrconV/pGJiTnOLgaKM2tzH4gfcBembmmbwnpvAg=;
	b=1RN3jm3fJxzeFXqYlRD+T4dYwtE9YMNd/l/cJVGBD4XpOjZzh5Ei1z5nqL1p3rfkDA/FMt
	4D+Xacipp6T6ORhWdtOXAYuKBMiwakmZ83UaO5GGnBEX3PDf38ED89PqLb271niDj6znJU
	ZjAc0+jBhUD/hec5eyTh7hMJiKB1t1o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=hdTqEWRZ;
	spf=pass (imf24.hostedemail.com: domain of realwujing@qq.com designates 203.205.221.209 as permitted sender) smtp.mailfrom=realwujing@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767601052; a=rsa-sha256;
	cv=none;
	b=US5bopw/NaOpNlngKzdF9li597F/ajVSRoEvdQYVKO2yLdEpbTeNh1BBKRUi0PJX2PchHH
	F5cLik+qEjhWeja3eXneyaDTKjCWeRPz5SopOn9KJUJDkn9odyZdSVgztJINL+4RnS31Ie
	904fi512JnXMWeIr2CCWwei8AbJoOZQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1767601049; bh=q8PYrconV/pGJiTnOLgaKM2tzH4gfcBembmmbwnpvAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdTqEWRZZWPDJwd3bZ2B0A7tSviL085doleiZq9OnhhTf584ryjuvVTtVm08gs58H
	 BgOUn0GfPZbCg3C83HXjOHDI88rD0fzkiHVA822lU0DgkJkVP2G/q6xvKuDcEJJzsr
	 LFSwVZb8zXDZ6ypIp+skuDsg1ZuXezvu5uy0p7Fk=
Received: from localhost.localdomain ([61.144.111.35])
	by newxmesmtplogicsvrszc41-0.qq.com (NewEsmtp) with SMTP
	id 45A9DAB2; Mon, 05 Jan 2026 16:17:26 +0800
X-QQ-mid: xmsmtpt1767601046tk0l7qgbj
Message-ID: <tencent_D4B501852276CE87F53409B3B5F3C9E1AD05@qq.com>
X-QQ-XMAILINFO: NmRjDopJZVxOiiFfNjyLDiYDUwlNR5+8OwxpXYAXJbW8qwmg8vv2SEkbkJsbX2
	 wYqNjcF+OIx010iKB4ApHEReDpa+28vnTwSdNNr7co7vFj0pZWfIjedNG2bv/niz++w+2PG1QAgH
	 a5F7455f7z7shUrT/1eXFFuvA+scWhR+jOHw74V1ISIIz23jOnRnVvjU4Tg4bfhh0GhEUVaGmwAx
	 HegTb2zFKG1F+HMUp/boF/OX2mlgP+kGOz7MBVygSUki+zQ/BxbKb4m3e/pBKSye54CKsnK766bd
	 ejjwJJjXwToCkcw3+d8U26jy5HSmnhiLyMIW/bTMEQJZkTCKPcBkuQHD3OHCL9nop8F8tZXh4DNW
	 EDrx060/F5WTGGvlRBInzlPTnQCPInk6RpnEGoKx8wBuBOLeNzRAoclXVHdpmYOBEzOwdnnYZ5Gv
	 77dWhxFUuag4y73dX4pv0VrUPDrzdEguIzbRntAzGUvgKWeTcEj06l+jQAUc07DFy0k/oiYBnQMy
	 +8hlip++5/uG/Q2G0op1UE1oo/1fOgEDZooj28h088gef8dLeMRe/+Lm+svomIwmp0MS7V81XQd/
	 6OPiAym5XNua3KHtIb79qqx0GEOiy5aB6bwNi3IZDPLUv90puw/D10o6RXtCG2UEiKNHZUVNOF/X
	 HGzGSrfb2PZkbmZ4Rkez9r1KCvysaPgDc72h7v+dVEhsTHsMGlJBhTLgvlB0BgGnZ9/5Vzk1bKVG
	 YyJUZGY2BtJrtsQMb45NiQj62zTwb6BaIKliw0zD5NP9ymZr9IAWEbIMLiIQwYbuXPpwXIsFHx37
	 WU0HMaafcpEJZp+9x/O0I17FIL/BHvwco02yjb9wQ1DYi3eKtDgb2OKTC6sjIX0apq0Koz80h96O
	 14hMnrF+d9DgO+JmrMYdhGLF5CQqcs3KLm/lVuFBErZr+Rp5aBYvUQeAatwsRT+6OYgW3w0kSctA
	 BTq+dA/9+DRpd4qhW3E94UdCENLAlE14L4RbidLowwkX/Z3g/CTQuX9njzVNUC5s6JS45iVzElzW
	 vYigj4ttrJr3eTlxx5VuwSbYaPOV3+sam5dZ/3Ynaz5xHB/haL
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: wujing <realwujing@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
	Lance Yang <lance.yang@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>,
	wujing <realwujing@qq.com>
Subject: [PATCH v2 0/1] mm/page_alloc: dynamic min_free_kbytes adjustment
Date: Mon,  5 Jan 2026 16:17:19 +0800
X-OQ-MSGID: <20260105081720.1308764-1-realwujing@qq.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <tencent_C5AD9528AAB1853E24A7DC98A19D700E3808@qq.com>
References: <tencent_C5AD9528AAB1853E24A7DC98A19D700E3808@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E8A80180004
X-Stat-Signature: h9bxtzyo6btmpnrso38hw1uy4wngyxw8
X-Rspam-User: 
X-HE-Tag: 1767601051-921401
X-HE-Meta: U2FsdGVkX1/2Hu0yy2E9PotY8bdMAlMAohNPK90DhixJZKuqDKxwEnk8i0gxmIU/6qRDzDgKx02u9/1qWQ5UwRlnlDaSlkEnoGQTq7YVyuL6j1eY5KQT8uLwQy31iHFivvrn8zZQo1hLyOqP26ixgGxfnx9cEQWrLYk09RK+wc38IIJZPA/zd7qvso2XvpqEj+NTLwBAShofMNpRb707CbpZJf16itUii/nRUi2PA4HRmzia7xtFUdpQxC9i/gIx/yHGMGneeDUMfaN9dx2UmTtfbswIL0JLHfXEq2YYh/aUC1eJIgmlcskGYtFktM6q3DoCdwBOGlYQSaS47CETNHh3djS7X3mHbSnIC8FbxUhBiaNWSmlBBakLY6oHpJBKV9ZVaV/DPYHylq6PH4fDKG2H2UTd4/9QbBfTMYgoBX7rFCH/wcMQlivQ9HZxsJlo0MU2YdWXXXTx4hi689MxvBHiUQ353XLjK8J5X8paifg0n/je41sjUpnBl3cA2J63GqrEm1tVgAMgzZil18ApYl6fscjAVs3j0S0in5xKhvg3uME7QBA/sNd+POwDQHuZ8YC5loi+AottWxXPGoPus4MTriqCdgUrrfaavgyxUWcVzzTsYhg1gYjpOCVyd8ZLm5RdWuX80sFBeAi6JxfAMSEtMXR5kxXPV62E9KqcPoP2slwY3nBIcEIU0iWqf/1XKuvXVmjGohNf1W5FSUOX+vXwtSjn80tnwTP4ZDXcrWZdR5Kp24jX8lbqsP1Y9NRqFK3/l5yICVEilH0WU23gqYAY5p2Fr97RlfVmoI5XX786mBMeNYCntQt75ZbWVDoyioqSE3/R0UhO4B5QWI3z3B4K47vWdkAzeytXo9Y/l/LVWDhJF65HnxSvthzXr2cNl9XmxUlYInhxdQPsl2pDY49B8S/Oi+jBFEZCI6c8gUQaBIVruj3+YsQeZFs0UbwVBUVceNtHDV7EoC5d3Um
 nwQLt0n7
 j63cF6HOO5C8ICZFEgXBu2x1YCyLA8TB9Wt9wYqeprnwTVa9+0Fh6E5wS+wx8GPc9p3Ogy21XMSsFRs0+PDt31sdp37cgH7OSSaUDCzFBjTPOjmh1fj0Ty319/0bNkXAlHqX+lVHJb09wXZJiXKWmqhuvM6EtN1VKbvBEwgaEkkKQZyBCVRw1iMjejyAoyI+7xqooRlcrPNaCQeeTC6eM6qW9r3cr2IXcwCmI8m0K8kP6iNTeSSO7JOsKx3ZAwt3qCVJh9iWb+uHxF/4EVXUm2O6CDz+SLbZmMWK9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v2 of the auto-tuning patch, addressing feedback from Andrew Morton
and Matthew Wilcox.

## Responses to Andrew Morton's feedback:

> "But no attempt to reduce it again after the load spike has gone away."

v2 implements a decay mechanism: min_free_kbytes automatically reduces by 5%
every 5 minutes after being increased. However, it stops at 1.2x the initial
value rather than returning to baseline, ensuring the system "remembers"
previous pressure patterns.

> "Probably this should be selectable and tunable via a kernel boot parameter
> or a procfs tunable."

Per Matthew Wilcox's preference to avoid new tunables, v2 implements an
algorithm designed to work automatically without configuration. The parameters
(50% increase, 5% decay, 10s debounce) are chosen to be responsive yet stable.

> "Can I suggest that you engage with [the networking people]? netdev@"

Done - netdev@ is now CC'd on this v2 submission.

## Responses to Matthew Wilcox's feedback:

> "Is doubling too aggressive? Would an increase of, say, 10% or 20% be more
> appropriate?"

v2 uses a 50% increase (compromise between responsiveness and conservatism).
20% felt too slow for burst traffic scenarios based on our observations.

> "Do we have to wait for failure before increasing? Could we schedule the
> increase for when we get to within, say, 10% of the current limit?"

We considered proactive monitoring but concluded it would add overhead and
complexity. The debounce mechanism (10s) ensures we don't thrash while still
being reactive.

> "Hm, how would we do that? Automatically decay by 5%, 300 seconds after
> increasing; then schedule another decay for 300 seconds after that..."

Exactly as you suggested! v2 implements this decay chain. The only addition
is stopping at 1.2x baseline to preserve learning.

> "Ugh, please, no new tunables. Let's just implement an algorithm that works."

Agreed - v2 has zero new tunables.

## Changes in v2:
- Reduced aggressiveness: +50% increase instead of doubling
- Added debounce: Only trigger once per 10 seconds to prevent storms
- Added decay: Automatically reduce by 5% every 5 minutes
- Preserve learning: Decay stops at 1.2x initial value, not baseline
- Engaged networking community (netdev@)

Thanks for the thoughtful reviews!

wujing (1):
  mm/page_alloc: auto-tune min_free_kbytes on atomic allocation failure

 mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

-- 
2.39.5


