Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A052CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 03:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A264A8E0002; Mon,  1 Sep 2025 23:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6DA8E0001; Mon,  1 Sep 2025 23:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EC848E0002; Mon,  1 Sep 2025 23:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5988E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 23:32:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3334140AA7
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 03:32:26 +0000 (UTC)
X-FDA: 83842887492.19.46A0A98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 77F4F140008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 03:32:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJgDiPPd;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756783945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wAn2CMKa0ObAxdVGK1llyeFShqljWQWF8wUPDUeDFqw=;
	b=O/RD5KEven17ki2acmlIvW5YYFHZ3uNmK0FR2xRRn11mD9Utyyb12DfKU638gAau9OteKr
	cVnvpQyma4/j95LiJjokVvRI4DBJQ8K3Xde+8YDmfSoe12mcdJqt3VgclUQ9e8Fue3Izf/
	mL+H4SUX8qruvumWx9H1vmwz2yCHurk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJgDiPPd;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756783945; a=rsa-sha256;
	cv=none;
	b=YA8hSqroJ0YHpp3i7gNsK2IIEhfyEzKpW3vF9bori6sJgqftgieI/rBfVVIoV+ec6Rlcf7
	EtxnnkifpdW9b3k+HZH1Bh7Xp1UjB6nwlXWNI1NrdME9IARJ/a6DG95bUx45b1Skapw4AZ
	ziVUiJqOqKQEKh3O/Y1BB5dtINurXEM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B918601F2;
	Tue,  2 Sep 2025 03:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215CEC4CEED;
	Tue,  2 Sep 2025 03:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756783944;
	bh=fegH1/gwaNMNYRF8NJuFdKpdmiRliTv7HKIA3Q/BmLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJgDiPPdSEErrTCR+WJuesV+fAJi7IJvAmJftY3nAQ7uR8/ifVl5Q43YdEuXohd1V
	 31omAMNcXsW4m2yCN3+x9J8ScS31Nfk15nOEHEA7eyeEdyslrND7FaHxhHkVjrrViI
	 5NWbPoG9wmR2QLaDDJyT3SBTRXV5iA77n6Anv51mzgzZW1PNtVpZqc0xUiqQGJjR4S
	 1RLgFAu2mq+FCGxhvC1F+O4hztv9vbq/kB1LiAxXOmEy5vlMyqT2eKyxpxEy6AWMTa
	 zbP9vq/R/i8+F8AvLEI9arXqR/CbaeTFtWg+NEsXeoE7kLA0eAemJ7FNUi+YryTOmt
	 C5WvFEt0dml+w==
From: SeongJae Park <sj@kernel.org>
To: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4] tools/mm/slabinfo: fix access to null terminator in string boundary
Date: Mon,  1 Sep 2025 20:32:21 -0700
Message-Id: <20250902033221.170618-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250901044955.3902815-1-kaushlendra.kumar@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 77F4F140008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: u8qx84p9y9aw9pn4b4tdgsuzffs8e5mk
X-HE-Tag: 1756783945-956889
X-HE-Meta: U2FsdGVkX1+FgVG/N/SAIH/yflyAI/P1n/F2oNGfP0Pt4cmGx3Hc7dprW2c18WH8mqjnlytfrejwc5uOPmczYy0cflxnDZ8274MIpT1BZSyHvTfSuVOeiIWVAhyXGo09Vph6f1ITFCsIF4o8hVQpZqYfB7eismfRvD2L71bA8AuNtNSYxdXhqaVdajypUUBxlvQllhZDu7mdSzcEA7ZTFIkJIigRawa1q0YFiU1JlG21hFYkyDILyl6fRe8Tz8nWl+tqjaLp+TouXvAhVLjvjzUl4zj9vg/bNfrl8B2xtVrK7m7P28+XTuaNjCLv3uTq041JvnwbtztUhW/gy2nuKhTnH6y+CJl/XlMqTcWt467qA2YH/9kD7NlrzmTbPErpPJDbtDI6SL/37nnp8IxlCVvFUd+oN/uY0EmFBtMJXtvhxZcY8KR5d+I8hMSBo+8rujOCoEfOgw9V0v0v1q2FdpphhWwLUGvT339Ofqfo6IV89kOijrf6KOwMBb1deDzhxoSd9vSj59w/bZ0O7GGst7ISmyCHZjEi7XHYyzG5FQlSTvhl+GFKq+finnih25FPNy6WF1cRepLLjtrpW1z+JtPmXYZ/J6ZLR4NwWsFtaiIhjBLXZ4FpPfR2QFA5LwTLvCJiZvk7pBKTlPPFBijbcNUW9A2W/0egEwE23JFOX+p9zOfOHSDbBnLxCs3TcN6PTEDBwIXbJuEKEkY5e5XZrv1SuDUiVnJ03EJk+j4t5OZ3TSPRzIiUme6o+/w1kYWmhuTXAmlG3AA9VCeW30FObtCD0k9J+OLxwafW1iqduvKWCbLA7WzrM2PxwDHdHHW4bcV11K96udPz9tutGE//mrY+8SdoeyUuX3t6XgvS8fWavMrvmERHcZg2k9jk3k3/POFJYENqlmfNWddsGBwYlayqvvYLi4CnZi8PHqakx+JR0TIN33O66pdbGqG8oVWst47IoatGAH1fSKykvz/
 llaZCxuW
 lpreMLc4Q+J4hZuszJTsnTQRWiJ0xJ8JQKehULx7Xqd1ici532+YPvbGJZD268aAGPQGnUWz18LJ34AHMlmXqKhXtaIPwbCUYjueFe/ECx5rfjpP8lht060b9ojd4p74BYw+d/91fXBHtIfOk1O6nPKpKerEAXpwhJlFl218YxUU7InxniRb3cLtVLmKAk8jX3l1dzdQNHW3SxE97+gXvKH7BhKKOjFE8lE9qS5zmk+o4MzJracFeD6pwYQD3E7v5noQVOXgo9SpvWsiD2i+hs/NPEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Sep 2025 10:19:55 +0530 Kaushlendra Kumar <kaushlendra.kumar@intel.com> wrote:

> The current code incorrectly accesses buffer[strlen(buffer)], which
> points to the null terminator ('\0') at the end of the string. This is
> technically out-of-bounds access since valid string content ends at
> index strlen(buffer)-1.
> 
> Fix by:
> 1. Declaring strlen() result variable at function scope
> 2. Adding bounds check (len > 0) to handle empty strings
> 3. Using buffer[len-1] to correctly access the last character before
>    the null terminator
> 
> Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

