Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 753A0CD5BB6
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD1D06B0093; Fri, 22 May 2026 09:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B911D6B0095; Fri, 22 May 2026 09:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACD5A6B0096; Fri, 22 May 2026 09:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B09A6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:09:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49F4D140853
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:09:45 +0000 (UTC)
X-FDA: 84795087930.03.1A6B039
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6F23C1C0010
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:09:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pyFlsOsI;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779455383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQj1Rbpw/H3Oe/sDGMgX6onZ6xyYKXcG7QBzM5CpJi0=;
	b=aWzL6S4Rg0So5pw7odhBPodjJ3NVfYV72zDa24WO9iWHLOUUebQt9jwDWNucUx8BQHi/mp
	YdzRrAGkcWu7ub72Yq66iUvXdqqF0zlFD+kjBTwXzqv75ApMvQ3ONYAsLGAaMeY9daFHXm
	lLJZm/02t//jMyuAPqFjgU9uhB4IQ7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779455383; a=rsa-sha256;
	cv=none;
	b=kGKRnEmEjl7nUom1nt974QjgfWMvc2SMP32x5SzMVk+pBwVL17kO2+VnXLWj0CaDvDArPK
	mTcVeSjE7DEsPwd5HUPE+tN5C3Ej2Gp1z/lIID5veb3SqFEm8SGUXgZgKx5qKhQ4fGE3xa
	7M/xIn9zgfeCTx5Q11RDj7PlzAnKeDI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pyFlsOsI;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EQj1Rbpw/H3Oe/sDGMgX6onZ6xyYKXcG7QBzM5CpJi0=; b=pyFlsOsI1W2H+d/c1dR87cu4A1
	nbk3QdhQ5igmGpectY46XehGUF3atPk8mqBTiAMYhp+RVUaHnf7U7vngJ2F4UAUNwxrJuFWL2uqdB
	d/WzjoEOMMz3D7k6H05YXwgJRsOWxWdJDddNXfpSrUVVgHRj5tJE6frgLHjiVX5xx+Bd6y6rK5bDz
	BjnT1OR4KHVpKXlgod+qjgxUoNjEidgt2I4IkCQEqjwx8IU2B9gxtaWWSot0M7QRZv1MxzvStf58r
	evpBrKrXC124rfJ3AuHL6Tt3FC+WRpKb7tjf8+PbXNt3tbgW/GZM31sgXDj/od4TakCYHwR3VUGW7
	FSgIl7pw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQPd1-0000000A7eI-1OCp;
	Fri, 22 May 2026 13:09:27 +0000
Date: Fri, 22 May 2026 14:09:27 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, bhe@redhat.com, chentao@kylinos.cn,
	chrisl@kernel.org, david@kernel.org, jack@suse.cz,
	kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org,
	lianux.mm@gmail.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, liyangouwen1@oppo.com,
	ljs@kernel.org, loongarch@lists.linux.dev, mhocko@suse.com,
	nphamcs@gmail.com, nzzhao@126.com, pfalcato@suse.de,
	rppt@kernel.org, shikemeng@huaweicloud.com, surenb@google.com,
	vbabka@kernel.org, wanglian@kylinos.cn, youngjun.park@lge.com
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <ahBVh4NM2uoyhPNm@casper.infradead.org>
References: <ag4kj84EcKqamdB-@casper.infradead.org>
 <20260522023305.98223-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522023305.98223-1-baohua@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F23C1C0010
X-Stat-Signature: 5janmifr9okd3rfnc8bcnigujzpi6uc5
X-Rspam-User: 
X-HE-Tag: 1779455383-279910
X-HE-Meta: U2FsdGVkX19DXSll8VBx9ORSYwPZ0qLixNomsIxgoHn6KgCMeFUKLfOf+ay0cxtNHUEAbPmJqeDvhomxYDh/vHspkj4sCI0zWCeViI3pX1bq54xO4fMRZ3ZF258Oslh9CdBcpQ/nwcC/tXo7fBHrmpfslalXs0gPY5T1FIPtswGhEdxH5ECGoEkpvKUhyoi8PHUJrPRlp8ogrf6viokpEVi2adZ/gdlVk9JY1EmGpg437+011cXN2XITubUb95p3ksXlFkduDeQVR7BPv1W/KjxHkAtdNoIv+GYhiCJ6Ju3EJ2+7JJyY6F7aEVCHSedbFX09hWPVVpjri8/ZYsDY2Yty+jq/JhCwwwuE3+E6QjS5ObxXlQDcLJy7q67c35NYL39ki5hAmTeZL3rwUqJEo+1aukqoUW6FW3h6vmZhadxbJy3Zu91MantpM+ahHnHW9WmrSm7caMWej1enG7MgVfXeCXLV97rRICefC7jHQDwcTd1VNhwb3XGessCuPDWIu1UYPe77TYe4skwRd6aIag/FB+Z1viHbXADSLwds1Vai6OUaeO7ySLxUSqwHRqVLsk5ADT3Sh5/V+EDbFsJ4urMsNhWmsnGFNIRZO9kH6NqaL+yMhJcceT1L4rqkbQSX7tmATN+nqqizW8h9IM0ReBB4vWuTyxqaCYM6z5V5Y3vzAn1eQcOmMDoDtIAxbBdYWYxIBJ9G6z1Z+Z4qnQRgXKaot9T97aG6FyTaEbxaV0qNSCfoHsktRbvSigE6TwF1NRDxbpblUndH3Ah+IqoGAitkUrTTgTJfMIMp4sB7Nz/w676DiV+u/rbM0Ud1re7lor9QIj8XIdGIDQWvnSdcGaW59BRMqJvAnESXRJ7UtmdmRDkln55fcMkKyxg6wy3L8CrsbnkuduCRM3zyLu0TnlV5RcpHpfQxhXTnoqfMk3I5opC9ypMd8O9zNswjcK7UOf3AAADEQ67Yga21Gd6
 1cL8jzxR
 SbF7KDc1IMO0hY0NozvNEK74bveLZ7FjDPA359BmaQY0iyKdHbke3lKV2yRTC51KrJMX2LoouclpOBygEc80gGpu8K69wTUMM5OPErVyHSn4uJJwdwGmJfEyPxtKv4lrUlH2PUlUbJaL7sLu0zqvgRNDRk2hAk/oanY/HW2vu69Rl+3gkE6C0jUn4uuF+GIOTSzzJOcsM32PwW0zJ0YCp5JbqkWmIPyvheqp6pffVFinRPZmSnM6kYuqdlTZAzKX+fmiNuyXowDsapqnBDbapjMx2yRpWXFuK04JGmCSTCiTU/hhsYs9pKXvQ3bOJOtgJSJBAee9mjCGXQ2UZcuyeLv6nRcIaO5v+PJRF8HMZHOnMFevZaIcxxJJyJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 10:33:05AM +0800, Barry Song (Xiaomi) wrote:
> need to touch `filemap.c` at all (probably because you are already
> maintaining `filemap.c` perfectly):

I'm going to give you one chance to apologise for that.

