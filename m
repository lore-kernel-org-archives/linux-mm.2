Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B32F3C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 20:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8BB6B007B; Mon, 27 Jul 2026 16:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888E66B0088; Mon, 27 Jul 2026 16:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79FE26B0093; Mon, 27 Jul 2026 16:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CDE46B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:57:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCCE44014E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:57:29 +0000 (UTC)
X-FDA: 85035767418.13.41C3C57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 19E2440007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:57:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yKFKCEZf;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785185848;
	b=Gy9ZsEroNEFtFBIMO1XwyPILquMtDNI82YtwASPRSGJU4G4Lm36y5OzDp/hYbdtZrxADzG
	rT356iebvGTpZ71h6sj8e9Vq5LgDTm2dNKJPc3WwG1tH8c6FSoJQo9vvFIQKG3dyOVjr7y
	E7m73+2WiG2q+wEFzoZIgIbPKThmQeo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yKFKCEZf;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785185848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OF5Uf3cVWn7wLKnpneETbEEB1Qpfc2UL504RaB7hyhw=;
	b=2yL19jfT4wYEOl7j3m9wKeErKk08hdYuzRAyP+1vtlPYlzhUL5kYKiAc91Zsn6/7wdSGbr
	sH65WIreZ62ndfZBO8FelmaUPQP+YbwxOZVLyxwpmeZxn1IITDGsyl1vyQOngP2kZgwYkx
	2JEPMz/Z9nVZFPB1Fp2OLKWZA/WSwa4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD374401F6;
	Mon, 27 Jul 2026 20:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3423B1F000E9;
	Mon, 27 Jul 2026 20:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785185846;
	bh=OF5Uf3cVWn7wLKnpneETbEEB1Qpfc2UL504RaB7hyhw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=yKFKCEZf6F5mJkslJWLI/BlA6of6bYyu6IrjDON3svjBxhluUoCQFFes1u3EUDPGx
	 iXttUtdwG9rBUBO6AKyOMQuyzMTyXI7xEXOiEFxgJM2XTLzQiinZxTY3G2sVgh5nms
	 PlKsTh5NGicxZ5Gvcs4UIqaUus7cwp/avHOO2XLI=
Date: Mon, 27 Jul 2026 13:57:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <balbirs@nvidia.com>,
 <bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>,
 <kees@kernel.org>, <mingo@redhat.com>, <muchun.song@linux.dev>,
 <rppt@kernel.org>, <tglx@kernel.org>, <linux-arch@vger.kernel.org>,
 <linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <x86@kernel.org>
Subject: Re: [PATCH v8 0/9] mm: optimize zone-device memmap initialization
Message-Id: <20260727135725.694139f5ecad67752b0985d0@linux-foundation.org>
In-Reply-To: <20260727123429.5673-1-lizhe.67@bytedance.com>
References: <20260727123429.5673-1-lizhe.67@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4ssyackafrx7jf6qg83ro1q9wgwuabso
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 19E2440007
X-Rspam-User: 
X-HE-Tag: 1785185847-112804
X-HE-Meta: U2FsdGVkX1/9E3R2DKjhVAXLbkg7G7ZjTnJe9XC0Ygg38tsIPEWhSss7Q+3MAKzXE1mRhE2U9OLE4lQ9JxVUVZrqwDuvxamhs4pHYWpZZaQx9UaPITYSVENJsxm7dArfxz/h+djPbpcd2uKWyXRc5dKbUdsfV3rPv9sWh8ZAt3sRR2YHssxDkYtwL70xChhbLe1t6MT2nz39DeEasYd8YDLH4OA9jLWq+0UTNRk44CxjsSWdwAZhUsCwew06sOpGN9LiMl2aHHu7wlrHyS8br+MkIcTzhC9ZAZI4+GVVwAkuL5tjGo5V4RHGGs9VU4iNDfzHR7qvCbV7nV6wvUNonVqRWXvE8DmHt5JFMh58BDkE9HLb6ZiZtpk0VBe70uWzvOGkYmaRJCw9/e3aMn4meqmVWzjLXV+aEjV+QNyydHfWODBcQcRoI+1Gl3AGQrM5KXarlXxrKn8czYnhLAd7x7/0kKo2hlarsvJGbieNIXqDokwGbvd027l+wpF4P78iUogF2QF+ycUuuk7T4pkVlpwXHartIzzrWiOktAGkdk7sE94URZhiNxOdnb1R93G9rUAc7ByAy1vbL5l1wsh+cevL/Jh9L6keWWvM1OKRuc3YnGfPbcs2wsAnzLynuOBL5EKYwYvAJGPPRGgQpZXoOrjE0eXbjwF6V0lfOdYXR6zuKPlrckUEv3McTiUwiVQldaeqBekRVRF2pE7UjqQrwp6geVWw+E0PKh7RJFEhnMuN4HZs2xGWZFthESf3qruIr+kpx/a2MJHNNkH+PRnggZ1UN0dq4TcYf/4qFTyUGJQzCBsB7kP3ayHyRXb3JOCw0XsWf4U6STMue3xN1uvhurTVeQd4euz2JtzoQEpi4eDjHlfqFzpfSZA9gCyZMhqLtwa85D+WnpFhKkodm7Aj3P/jbgbYtQEVfOBLb33eTxKoL6cxSDuc6ptfCxoOBciHiucfTmTmjYybXENLRNX
 GvLpccKM
 PLEMKxmv+mh6J7u6BT5agu2aqFCix8OIia0fiiGs9PqQPtEOhYeD5r269s+mQh5r9ozwsKbnLf4uWCm0qqAfamjweHBlLH2m2rbccvX8OA5BlCDdR9Y09CjNmue5OCR5crfUo4dWw6XOiFKUFi6q7AJW4flq5eFBGR3KwWYi2eldqSgMSyMe9siI3hMv+aImpLVcOIo3bfK1T7xbJilIHqtXlrK1n2UNcpN12sZr+H214iqHJQP5Z9XbC81BXJsS4Bcq6daugGUOKyeTZOS2QOf+q8MFzvpeuuCTaEpZbUf88+25odnmcaKtwJwPzp1BU3gXhbEXhsSxQiu83fHNaa7O/DA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 20:34:20 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> memmap_init_zone_device() can take a noticeable amount of time when large
> pmem namespaces are bound or rebound, because it initializes nearly
> identical struct page descriptors one PFN at a time. This series reduces
> that ZONE_DEVICE memmap initialization overhead by reusing prepared
> struct page templates and, on x86, using memcpy_nontemporal() for the
> template copy path.

Thanks.

Human review started out strong but petered out later in the series. 
This often happens.  I'd prefer to wait until it fills out further.

AI review had things to say, as it often does:
	https://sashiko.dev/#/patchset/20260727123429.5673-1-lizhe.67@bytedance.com


