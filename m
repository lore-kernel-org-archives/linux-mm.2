Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB590C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 00:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4B76B0092; Mon, 13 Jul 2026 20:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B560F6B0093; Mon, 13 Jul 2026 20:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C3E6B0095; Mon, 13 Jul 2026 20:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85FEF6B0092
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:54:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0DEDD1A022A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:54:01 +0000 (UTC)
X-FDA: 84985560282.23.E3D45EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 190CE180003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:53:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dIdy7ooT;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783990439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mx4fDIBDz30G5ZiB41bQUQXLzkbvv7bupjE4vYMRmOM=;
	b=AXFm9O4QL6Kym3rsdAl68HPTX2jLLkQ0XpMy+vCooa95PTSWmfSeyk8tWTIzn1J8z3UUoY
	zbzl3unu/L+jIywL5k2R9NAJ6kzqYSijjl3kDnZiXftSsfWG4a7nmZx32fh1c0BXZQ58xB
	AwZx7S5r1V+7SgNzAAO4srUcrOemIt4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783990439;
	b=6S9XnbGdPhmJPDLVz7R/5KnBIDSUtIPXXyL5LgGtcBjtPV/VYbCIpCZxmhfxOC65Ynau0e
	5aMSAAAlFPp1WR+0GlRUlO8YsS3MGtHGxlmmhLa6YQLN44hpYmoSO074POzgsuwov5OjDb
	E6YBl0e4xdAOiQo1m7/HS6GiNaMtSJg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dIdy7ooT;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 93E1260120;
	Tue, 14 Jul 2026 00:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DD01F00A3A;
	Tue, 14 Jul 2026 00:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783990438;
	bh=mx4fDIBDz30G5ZiB41bQUQXLzkbvv7bupjE4vYMRmOM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dIdy7ooTS2TlXzMThT9NYsmvtOqeDEBZaNWg3KMCD4CGz/3zUYuzC9SCEX35g5gqa
	 OdrbJsM4F6/w4yL73WsemTorfFR4xpoIgpIV/6l0ylZEnR6okFD8LI/lAANuCw3V5G
	 Br9EtkM7JMFhvo6sU4Xh88vL75+dYRj3CaxTahfY=
Date: Mon, 13 Jul 2026 17:53:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?B?546L57+K5ZiJ?= <wangyijia.yeah@bytedance.com>
Cc: <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <muchun.song@linux.dev>, Jan Kara <jack@suse.cz>, Matthew Wilcox
 <willy@infradead.org>
Subject: Re: [PATCH RESEND v4] selftests: mincore: count file-mmap readahead
 on both sides
Message-Id: <20260713175357.02fb4b78c6a22c17e2001035@linux-foundation.org>
In-Reply-To: <20260713094319.771550-1-wangyijia.yeah@bytedance.com>
References: <20260713094319.771550-1-wangyijia.yeah@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 190CE180003
X-Stat-Signature: moewo9djkh5tkc88iwmzj9oz5x46wuwb
X-HE-Tag: 1783990438-849726
X-HE-Meta: U2FsdGVkX1+LW4J3gPjKnhFe22ZX4TwqPH9AllN6VR4X54E6V5H+twgP5QaLf0uYCyIZYsq12CwvCC+q0d3yZRvC2BV80zU+qvPtD8YLKMsF65+0pHrzUsmz3SDArve77GDDGn93owKBEFz0znkh4lo5TqaaQvOno536ClbDAdxvfXVTmFenNMQILiHhvKeBIzGP+MeI7pSTFOSXknzelQ30HuddhURIncxNvynox20shF0gMmh5suLJpLonwrLaZ1nkkGOYZfZMtsJfjGciAjcWRNydp8OAKPGj8DyOCvmmWuUw7jSYoqhWbLEdf4RR5PCmWTO1vcsq+nifsU4LJyjJGKsLAvnYVT1BWtJJx6r9CwRS1GgTpB/HrIeJOBZDPMQosDdhU4FqI1jR5Q5YaqaoghwQkBLEJqM4RWZp0irxo0ADaYk8kCGjQCxrLWbU2NqvR6yO4fqtEfCf48pdwQMdTo10UItdVmUrNfMzwovbjKXdHfOVZzSuo7Dw4L0etYenCcDHzHA7wRYRBWyA/SHBYHMNK2qwQhoAg09iF0S78te4j3210/G6S2U82FXmiyxhlNKMU9ugIeOEisM+SDVfpLORbETO+zYeb1uNn9t/GPlGO64EiHQ+ye+u8uFr/G6Cm9aYFKJzgLhY1lZOj2/N4V6VUCpBcirRxJLgUPMdx75IfEWr/rlDWS1fYXBDYixYaphzOluESrjEdPY+IYzr9h8KV5aiE213dR6sYUtsaW9raPdDoL2UhJWt2ktbZrveL3whyT14c+41+E4xg7O3CLREZXrTuH0GWNS2wKvTMpX+2NCE3xdCyubahOzK4sac9Ld+4ha47QrdZxaW/nDAB41g/EiQaRTbcwcG58BTvoizKsZgMJoLQ0v7+l+Wt0DNCdGI+2/iM0VCoXfAbJDMHEEa89EJ3GDnzJZmzI7YCJqDVIrr0ujz4gl5rHbhBcqS3TYhu4xBdyYO2NV
 FC3VEVu1
 7T+0cQRKUjrCRcc4eW4Uk5uXacCObUoT5iVL/UYVRJjNI3Utrsorqv35R7hg+TFfdo06txZ4914FPPDecC9lwlqfM8Q6FbhLG/Q29vRN+SK07dZrelaLkYwNnkS82HYFIguJ4amEoPVOXx6yTWWOSjebQ1AnpBrZW0gloYLFgyNbHKrXRUujDQcvgwOVMDrhCY6MZbEuEAEEhYh+Xx5HoNy9ZEruCnKH2d/un7RGjL29x2Asra4d1g/wGgZ2mG0ah4lEF3nAF5AQxAhJ7B6438vKLWk7l9fYkKMY5wsk9fpQkjgN3hJT8WcrMPl1A8P3bOI0PeK73Wr4cOXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Jul 2026 17:43:19 +0800 王翊嘉 <wangyijia.yeah@bytedance.com> wrote:

> From: Yijia Wang <wangyijia.yeah@bytedance.com>
> 
> check_file_mmap() faults a page in the middle of a file mapping and
> expects the mmap read-around path to make neighbouring pages resident.
> The test currently counts only pages after the faulted page.
> 
> That misses valid read-around on systems with large base page sizes. On
> arm64 with 64K pages and the default 128K readahead setting, the
> read-around window is two pages wide and centred on the faulting page.
> Faulting page 32 makes pages 31 and 32 resident, so the forward-only
> scan from page 33 reports ra_pages == 0 even though a neighbouring page
> was brought in.
> 
> Keep the existing readahead assertion, but count resident neighbouring
> pages on both sides of the faulted page. This fixes the 64K-page false
> failure without teaching the selftest to compute the expected readahead
> window from sysfs or other implementation details.
> 

Thanks.

I continue to have bad feelings about this sefltest - checking on
internal and undocumented(?) behaviors of kernel-of-the-day. 
Pretending that these behaviors are ABI.

But oh well, if it causes problems we'll fix them.  And if we're to
test this at all, we may as well be more complete about it.

> --- a/tools/testing/selftests/mincore/mincore_selftest.c
> +++ b/tools/testing/selftests/mincore/mincore_selftest.c
> @@ -243,8 +243,10 @@ TEST(check_file_mmap)
>  	}
>  
>  	/*
> -	 * Touch a page in the middle of the mapping. We expect the next
> -	 * few pages (the readahead window) to be populated too.
> +	 * Touch a page in the middle of the mapping. We expect some
> +	 * surrounding pages (the readahead window) to be populated too.
> +	 * Depending on the page size and readahead setting, the pages may
> +	 * land before the faulted page rather than after it.
>  	 */
>  	addr[FILE_SIZE / 2] = 1;
>  	retval = mincore(addr, FILE_SIZE, vec);
> @@ -253,6 +255,12 @@ TEST(check_file_mmap)
>  		TH_LOG("Page not found in memory after use");
>  	}
>  
> +	i = FILE_SIZE / 2 / page_size - 1;
> +	while (i >= 0 && vec[i]) {
> +		ra_pages++;
> +		i--;
> +	}
> +
>  	i = FILE_SIZE / 2 / page_size + 1;
>  	while (i < vec_size && vec[i]) {
>  		ra_pages++;
> -- 
> 2.43.0

