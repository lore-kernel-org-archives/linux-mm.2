Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9A87EA4FD0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 253196B0005; Mon, 23 Feb 2026 10:16:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20AE16B0089; Mon, 23 Feb 2026 10:16:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137696B008A; Mon, 23 Feb 2026 10:16:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 014A06B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:16:51 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA3711601E1
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:16:51 +0000 (UTC)
X-FDA: 84476073822.03.E5462C7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8844920002
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:16:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=STvKH9+d;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771859810; a=rsa-sha256;
	cv=none;
	b=ezgEfoKEy84yYq44mQL7npV1HjcgS2vdYh9K1Su+D4mCpqC59OuBIyDAwVafoNFTQmm8zQ
	v2BjHEtqI4mLJdfKCZPS/PR1qNFqZ675zn3s8+jow1FRn5FutNyMv0oWQ6EzORcCYtjN//
	mPksiqa0ZnP7m+j/pwpIzkdgClq+mIA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=STvKH9+d;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771859810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOWWiSTBJ+8W+AutNJHrcWGiv44YuY0pgJy/NDewHkc=;
	b=30I984mot81EeJIvi0EPqBZHliO/qw9MkQwQaqip1hcnSC6FG0T2plUGlt2Y/8NGOTz1QM
	l8fi/70vWCRh/LAGDNJifpTqqY3bdNXTSmjtyDvYMt7Pz5nmO8dipRoiX/h8lekAuwd/Uc
	LykN6UPD0HBZZwqPW/LylXkm3nMPNOM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WOWWiSTBJ+8W+AutNJHrcWGiv44YuY0pgJy/NDewHkc=; b=STvKH9+dBZA8rkYJbk4S71s2ds
	y0bpFjipG1vxh8O2NDobLsCi4ZeC2cHBJKgp6o/s3G/m3GWXGN0ltMhIi1DUOTTqVVHJ1H8Eiz87y
	3rY84yFsMRcDk8okA36c1cidN3+5oyKwlYJZ5rzoua9Kcl5AVFfU+N9sqLV9WYhAmqC6a03ANjiRv
	ynA8OJ/YxfjXNRjTMeizzJrfjiboLNsA3pvCpuCxEo1EDhQh6iRKhXx8IYMpPYDJm8Ln/APPGTOCn
	kOQPSxUX4jIzLAc/JK3K8I9K7568CyIqItWGlT9olfrcRUhJoADsM7riQVaYmoQHj0tbIrrYnhLQH
	wD6HJnng==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuXfv-0000000Eeth-09hH;
	Mon, 23 Feb 2026 15:16:43 +0000
Date: Mon, 23 Feb 2026 15:16:42 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Sanjay Chitroda <sanjayembeddedse@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: drop duplicate kernel-doc for ksize()
Message-ID: <aZxvWlsrueUgWuOX@casper.infradead.org>
References: <20260220124243.3264133-1-sanjayembedded@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220124243.3264133-1-sanjayembedded@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8844920002
X-Stat-Signature: h3ksn5gnzsz47n5phfibykekj5oc9hsg
X-HE-Tag: 1771859809-487491
X-HE-Meta: U2FsdGVkX19RrIYrGK8cd9582QO90QdUZrZWteg2xhCZ1wj/SlTlOfiBn+pC4HdBWQqCfujOlaw0j83N24kON8Viu57cj0dKvq0QqnDOKqWT9Dfjcewo15fL6XRmw0SUOtxwAsO9DhPbrJf4z51y0xoJT2/Xy8BPRRhNtbyp49g3Hyq1gM9TCrvb9EVr0rz12koqS2Aa8/n3sHEmtkodOiduHvoHEkrgtEKxIJ9rMHClZAtrzPgw/HJDMPNL9OO/nK5YV+0QimBavLBNKc7XV5/3NuACFwVTa81nH3T8C/ua//+vsx898p8Ezdol3F6C3yFjxYFqxv7A8ZVZvDpVmydyCoqtF9R7WsrRjIksoRZPKrFjQbhiUHsuEN842UP7aW45K6yszLQ6hXfAa8SPECtUJvhj+eGq9ZgUnPlJzc2bnXHK9iLACexawgk02H8PIL6HeGtYype0Zqx8BuvgIflB0TjRIP1YI8eJgc0oymhiuDRY4IJ6hJG4n5C7CVGbzrG9eKUPut/Sd581aYAETD9FT2DRd7ceIYonxB1ycIelYzX3l06KWExCmGGHQswms3T5dSWPwAarID6JN7zExhJ45/VTUIEZDwRGccS6765hoVuZ2/R5WaNbD7pWEotsAkmRBb0tii7QpS9X0n8yC0+G026vSb6bNJAeWLyCK+Kc5/0oR3OhxS9iKEPzLegYg0oHxsOQ91M91F4bNLnR9v9LfPGk7fktc7m7KiagKcYKO6keAEv5OMeVxTv6dTVzG3/Lgqn5S/JDa/5wmrEul+1P7b6oBBvel2e+4WBXR0unfg26TeWKQcDbH1gJ1kRB+OXiWyWUPS/WUVlEeVxsnJCUax/ZGZqU6xNifs7hQZN3mnBFGOi4C99k6slxG6bJAJpXaEuxcRXPhL8CJADFuDI7FSH9Lnq6l5xO0/+NrsQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 06:12:43PM +0530, Sanjay Chitroda wrote:
> The ksize() API is already documented in the public header, and
> Documentation/core-api/mm-api.rst pulls that canonical doc into the
> book. The kernel-doc block added to mm/slub.c by commit
> fab0694646d7 ("mm/slab: move [__]ksize and slab_ksize() to mm/slub.c")
> introduced a second definition for the same symbol in the generated
> docs, which makes Sphinx emit:
> 
>   WARNING: Duplicate C declaration, also defined at core-api/mm-api:521
>   Declaration is '.. c:function:: size_t ksize(const void *objp)'
> 
> Remove the redundant kernel-doc comment from slub.c so only the

Usually we keep the kernel-doc comment with the implementation, not with
the prototype.

