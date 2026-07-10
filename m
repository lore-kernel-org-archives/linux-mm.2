Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 286A3C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217B36B00A1; Fri, 10 Jul 2026 10:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1336B00A9; Fri, 10 Jul 2026 10:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08EC06B00AB; Fri, 10 Jul 2026 10:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D15F06B00A1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:59:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F1C514047A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:59:15 +0000 (UTC)
X-FDA: 84973175070.20.6DA6188
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id CE4D91C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:59:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UAET3Lve;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783695553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kaHO7iM2fkBkcPXX7E/p4gh+FXOCsDoSAMVqpwRtKPM=;
	b=7IBZaV8edogUv79GtB4FYKxXADTCNsRkkKp+ZNf3HPgWhxYQ2kakeDihSj286ifCdPAZ51
	NchY8uPBt5MZGPUTge6DtDlOtcqNv6+fAdnCjUvW8P5KxAGUkK8oXmZRZB8q7esbOttMom
	6/uX59DHWNWeybJh/jjwjcXjNhWZZxs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UAET3Lve;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783695553;
	b=6Nrf/wvMYvQuruP4Yn0u3ie0P0XdBji3SerJOOoioSnzSEXMBzwMa8sDzJ1q//Y3wmBbPv
	/IYjbLJmcryrbRM9x5Jfh7YYa5GLD5mYT6ln8o+C6b0zOXcOXK/XW8Svdq0lpXM4ZaFvBX
	9t+0ev6s+gw9MWLI8dYrIO3myVnHpug=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A71F60052;
	Fri, 10 Jul 2026 14:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5381F000E9;
	Fri, 10 Jul 2026 14:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783695553;
	bh=kaHO7iM2fkBkcPXX7E/p4gh+FXOCsDoSAMVqpwRtKPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UAET3LveLjWX8B68X5OoBzwl8nLMnCMESO6AiBDf0f6br2bu+FSY99ro2+vJfAz64
	 DeRRmqxYubZ+aPo2o4mlrNDX9FsHGuEmWy2qhG53I9Rek1zIkK66Cq+mOMEOuYpHQp
	 dD8THo33ClgqdfHTq1T38PApc4m22RB+YxRdwdWwIALG5HPuP643Rw8eActmjWHK7v
	 kNNkfbzUpIfTOfTCHUeRWYnmxvsqN9tcLnlTLjMuZ2GFJ1TfdA3cDiBjpxdxjoclTR
	 qviEB7Y2/BMljyFgi75PuxISbyXnh9ZD2+cM/qv+VTd90REkj5HFX5D+bOys/r6NB1
	 sZ+wBLUtR32Lw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/19] mm/damon: introduce data attributes only monitoring
Date: Fri, 10 Jul 2026 07:59:04 -0700
Message-ID: <20260710145905.27704-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tcadwq54obujuwrri6dgpax1kmik3zgm
X-Rspamd-Queue-Id: CE4D91C0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783695553-65692
X-HE-Meta: U2FsdGVkX1+0AtJpE6nZzcCHbTxkRnU/hqlylU2q2g95BeTcEHtrXyI8Wxo5ZkSM35lgHVWKkVmHXUEmziCT/eM71r35IkbJS8XEvDoWD8oIRtqhE6Ez6gNYURdECCOcuI4APUCVdvLt4W7oGtc8Ef8CgCbVndlShTmdSgPobZQc2zRBsye1VJI4ZYIHLGX210atCbUYTpz/Xy7hfNtLZ4enLBtXtPOo2q5wgrdBIzqGwIPG5T/+Ira/Kg2pfSiskJKYykK+aLufjiNHORN1DLfN+1VPvTW+32YtaQH7jkCFQ+HvjrRfPjsFHtTe3G7xLTcQ09lE91zb+Wv9YvDwU2bpSp+iuRS/ms/1i0XaGKzQOLt/fuZCf1TOdNa8vsFq9mDzONPDe51x23NiDImfCBHdLMTOL2o59Hbhfjv5qeSGCZTovmZtskb4c+r1HsWS4XyMUFB6B/mf2YB6xodAxTSCaZ0ghxnhJjd/sJMpkHemo6PBUrEZZEimKIZkQwBXUfCKNuJIFszq5Cn1uaGaJBVIkM2sGNuPlhSrjz5lVjhgrUd5doooohhZU16ezf6XwSoKHPptb3ARbp78ZnZ8wzPnvrhhavZZhsbg9/vgqvCGEB/HVzgSA6PmzywQ/zUCrUVFvqOJYJUl8vNGBFQYgNOkOKmHqn4G0sHQ/jqQut9Jpj35lPXEgCZMvvVh3VL514Ix9g7wZ0DhRpHM8+KXRSU1nS9lX339wkg52watKY1GhX7CAqzidQoABRDsvGV1L2s2gtTbqqOeoKGo3hc4OqtZWijJ4vKFD/xUnMU3N7MHfBT7d7/P0hRc3uQsw187Rn255BrDdDhhQVs8PB27CFHHzSa79q82YAGLVT2rHOCGDf8sF4hyWQWrrD6e0vj3qJaCfphPKE+SGHPC9DYjcxpZJcfmRWiPNNTa8811WWXFNh+3aumCD+Im6UzlfjvEycBgD/3EpHKE1nITeM9
 j+0upMLv
 oDeWfUsl4y2jTDsx6USOqvtN1/b8TNRBu4CP4/Nw3/ellegDgCPVHsGD2lON51M55ekWJWm1qB+1DpD6E5y1M6ncQj3/pRZWmUPRqdKTkUoQUmFy5Q0iwQaecUlV1+hCBc9nObsnNx8Vi9L0aUwZKVaN6QS5BC7ccYGn1sJ85aQn9iNcVmy+WVP/VQnfOW45ygwKF9TmVZXK1rcgB96enJs1lUXV5sbGpwlLbzDoKeci/cfNBU21l6A+gyfxmoTAPPdfq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 06:46:29 -0700 SJ Park <sj@kernel.org> wrote:

> TL;DR: Introduce a way to get DAMON's best effort accuracy monitoring of
> user-demanding non-access data attributes.

Sashiko found no blocker for this series.  Sashiko sent findings to damon@
mailing list [1], and I replied to all the comments.  Please read those for
details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

