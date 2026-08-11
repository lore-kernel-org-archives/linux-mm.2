Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02321C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54496B0092; Tue, 11 Aug 2026 09:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B9A6B0093; Tue, 11 Aug 2026 09:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D423B6B0098; Tue, 11 Aug 2026 09:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B25CA6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:57:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 31809A2793
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:57:04 +0000 (UTC)
X-FDA: 85089139968.11.6EAAB4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8AA584000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:57:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tbm1G6jB;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786456622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EZys2aqS7rZM1vX2mH2UpGd0DfOQWYKd3PES5jlHzo=;
	b=upS4jTU6kfBEMv3AUKjBhy0mOFP8GQ/TNxdVyJ4loHsdScLsWKWt9BCFdPjjfFSlYCdbz1
	mXrERWM+kUmIN5uKqGhYED5a3cupgCZ8Xo53FYOIDCGEbxESwH3CfxSs9iYQIuh/DlN8EV
	n1//sa/DLm0hfrhwMS8lGQpI2dWgVbw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786456622;
	b=4QTFhBpy7V7hsKY3fOGpX2VwcAgzyDYOI17ymsjaxcFRipgyOAEE3T7JzDPZkkb8uRqeHs
	vdPEg20owhCm03bvRa4Sy8XZNzdI0xxDJFvMZpZpmOnLdora2Tqtm5jYF/XXrfUCj00GGq
	+L0TojWm/y/9F76IgqJ01pfyfU7QAno=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tbm1G6jB;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 04CBD600AD;
	Tue, 11 Aug 2026 13:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E6E1F000E9;
	Tue, 11 Aug 2026 13:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786456621;
	bh=1EZys2aqS7rZM1vX2mH2UpGd0DfOQWYKd3PES5jlHzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tbm1G6jB7U0RLXAMd6QA/yQkQ3/AttRY+CFxiV/rY4vrq9eYO8ecMDJlLnA3vL4o9
	 Y0pofMBO7YFPumBy/x66NWf30thw/+ObLnq7Ggo7sQyNwTfnYG7ZjMhZKi61s1U2QB
	 mCdYb3Y33I98WoDGgLLNBOmvklgqr11xFkol+UeKdsv32wyGoKvWTn+1RaOZx1iAZ8
	 1M+Uc0DkN7QUeESD/WeqAblOuXZXLcoUiWeQ5kasciC5GzE00L99nxsp0RfUQWs0om
	 0K6dFl7Rm6XFuPyLZZyLDKyh+sIl8Ec0gIfrZ40fDxTw0U10KjL0KnT5gYpz5WT8sW
	 S/ev13yt3u6lA==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] docs/mm/damon/design: add explanation of nr_snapshots
Date: Tue, 11 Aug 2026 06:56:53 -0700
Message-ID: <20260811135654.4901-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260811101841.804596-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: eqy4htqz7a1brhikimj6j1gtn646b348
X-Rspamd-Queue-Id: 8AA584000C
X-HE-Tag: 1786456622-927613
X-HE-Meta: U2FsdGVkX18G8GIlEmWOf8/SrdS+YZaXUZXVvb0dIEt464Wb2nXjl5e/dKQz2KdiFjdERcq3LhjNnej2uODyALfDYqjag2xnsGPy3HaCAC7R+32EEhsB8N8grWBK8kZMBUxYyZ0gLipQ7cxrKzjQtA4pylcDEwl8esiAEc8jShh5tz4D8FKXP1Z4GmvNQ7Huue5NJM7YvXHtCCnVsKtRnm7WrvbFBTZWmJR9ZvBdBFKVQZTfKyj3Bb1KSTE2kukgzFSE1plHTNpcVSjopXa66aWY/4X6IdlIe9Psxqt6tqs1XNSb+rqXDUhtSJwXX+Tbjzt1FfGRdT10PSDebdgU7VnJPC2dfeyRWXLp6/bGhwNWYwzfureNZYJJmDGyZAwa4mIdFOCDNyf/W+GH4P8qlXW+6KkbX80TxB1dYT+1rxOSZ+bObYm9nDcGFcd+f8wP0ddfgHvWVIcIdEz/+8jtRxh61WNy3QKrT2v5XRZwCamnJ4DMdYKW30jZAbH+EnvgCNduIq37P0F28IABLPZxVbkIeutIVpQkJbkYEa84xyPUQEy9lBJcbwkkzEHQ5V+vz3R1nnW3Gz0mBJZeCeLmhvirPMLOOF8l9w6qqcSuuaut5mjXiJr0huI6c8qTmQGSpu8T4Mv+i7g6hxAj5iW/em6mKrsQvMbhlYMMS8DYbuMSYJLdMA/9Am9LfGpf3PpMVsPGzGLGdME8BgLQFvHhcNvhtunce1ORbF8YVCM7zIg3cHAuME0mPVuhLnS7CjLviBue/94n9y8q9exIfj6oz/zekYoguWd7DcP4htLpg85fdu+/IjmK3su3rhx1PJw4z8pD2Op5Zs9sNpsArJe+nFVbNQKghbhAeFScpR81L+EDtQ2bRtGvpGe9YmaUPhdwrYd8NVsR8bbO/vs51/QL/XjjxNcfypm0ihwmlzV3BK3yrTU2CVuTcIsIhy+aKowNOKINl/PdoOUU7/S7gBm
 pjpMbtAe
 oA4mEALIv8Az1QsG7muP3a1EcW7876CrBS54lSHub3TG0RNLHlWhWoJJbDcs79nOY4f/IAO8CFlkJJ9UoapFF010FbvHc8Cf831oFfNUwiKc5daCjY2Nhv+5dnVFuwlTLOrchgAnKcEsYY3124AOY8b8dVPBcZPmJRDN4GnOjB8J6L0wM/r4aIAjTV2wJRsoDNcOuBmyZgOaSgG1MDOc2I+6yKVt8aehKO13pZthqOopaLBcbx3HkKf7GoR5ARcsieHeQ7x0HDed1Eb7OXA1/i7Nyf/N5FCfa3M96Kd+UWeKlO8wBt8Cy/EXb3sMLPFSqsm2n5jtRXdVljjm+PZAIgGyge4JHSo7cx+X20Ba99fJ30AGBLirPr8lu4HHGWju87kHn495AjDDOIORW/RG0wizDvqMZd2X1lcnTycifhCXb0bPSBHkb1LEcNgnqhcF0KvsJNqgzzTWhy8XVOLURM3iZAAfsu23pCr1V9rn5+oWfSA068TJpJGTtOrFnJedQitEOtLmXJEEmvNcGg1WjHzYfWKSBBaZwnZx9BwNxsCqlTmEGsbE5oUtmHGVaXW33mLfBDoV8Gn+uKSKvQXbyCm2u0g4AKOzUu8schRnYC3Uk0IQQXXBqxbRLMiHsqq4JSyhLWaGsAJCJyQmiizX0meiDyPIU/0A9h7Stp31A4cD7mQG7Z7Qu1/JXuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,


'hkml patch check' [1] says you forgot Cc-ing below people who are recommended
by get_maintainer.pl.  Please Cc all recipients who
get_maitnainer.pl is recommending, from the next time.  'hkml patch format' [2]
could also help you doing so.

I added the missing recipients to this mail's recipients.  Because this series
is a minor change for only DAMON documentation, I didn't add them to the
patches.  People who are interested in reviewing the patches can find them from
lore.kernel.org.

- Andrew Morton <akpm@linux-foundation.org>
- David Hildenbrand <david@kernel.org>
- Lorenzo Stoakes <ljs@kernel.org>
- "Liam R. Howlett" <liam@infradead.org>
- Vlastimil Babka <vbabka@kernel.org>
- Mike Rapoport <rppt@kernel.org>
- Suren Baghdasaryan <surenb@google.com>
- Michal Hocko <mhocko@suse.com>
- Jonathan Corbet <corbet@lwn.net>
- Shuah Khan <skhan@linuxfoundation.org>
- linux-doc@vger.kernel.org
- linux-kernel@vger.kernel.org

On Tue, 11 Aug 2026 18:18:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Add an explanation of nr_snapshots to avoid misunderstandings.

Thank you for this patch series, Liew.

> 
> Liew Rui Yan (3):
>   docs/mm/damon/design: accurate semantics of nr_snapshots
>   docs/mm/damon/design: difference between watermarks and nr_snapshots
>   docs/mm/damon/design: fix typo of max_nr_snapshots

I requested changes to patches 1 and 2 via replies.

[1] https://github.com/sjp38/hackermail/blob/master/USAGE.md#checking-patches
[2] https://github.com/sjp38/hackermail/blob/master/USAGE.md#formatting-patches


Thanks,
SJ

[...]

