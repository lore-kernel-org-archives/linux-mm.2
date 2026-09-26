Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 185EAC9832F
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 20:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3C06B0088; Sat, 26 Sep 2026 16:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A849A6B008A; Sat, 26 Sep 2026 16:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973BB6B008C; Sat, 26 Sep 2026 16:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 792306B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 16:53:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65F17C0597
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 20:53:43 +0000 (UTC)
X-FDA: 85257114726.04.459347A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9D491100004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 20:53:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="2b7/uQsB";
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790456021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOHXpoVJktgoXiNd2lBMhvoj+QPbhugd1lhqrechpaA=;
	b=zwv/Zx95EJiQrlpQyoo3qFNPhE+iUbx+E5tenEFkTAX2qIXVMOjTj8HhF+4BFPhY7ODv4J
	0mV63kpHmddIB3ufPh9FKPjQvmwYBeItWoABBcWTbWxvsMQtEhVg6cVBSL5KxfyADyS1pw
	ra6gZ976CeLgyAf/ajbStIB+AcqFT0s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790456021;
	b=UWLMobbCAeH9orzuO/YxzhiqiPLP3hbpJLaWCqzWYdBcmNJ4M0tlNPhhulkmtbvIeIvgK6
	OJVkJWZSW1mzw8Pv4Y1P2LwubkqXNY0vRGyuh5Z+ZTg+3nFQucv4B8dw3/xevUKI+KHX0R
	hogvSP1Wy1hXOz2GrfQUXUenbl3x9eY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="2b7/uQsB";
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BCB2600D1;
	Sat, 26 Sep 2026 20:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7491F000FF;
	Sat, 26 Sep 2026 20:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790456019;
	bh=jOHXpoVJktgoXiNd2lBMhvoj+QPbhugd1lhqrechpaA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2b7/uQsBtfmamje2ZnA3Wz7qnXy4GegG7TJLMryITbr2jniyr3apS0NNjFW75J07q
	 GStWjGo6dTHbYXha6YZoTAFFT5buZ6kv/jh4gPom/y4LHo5MKWaWVMgpYFAMpMs1T9
	 kAzbzmtBhJTzTDz6bB5oXPPS9NOH/3VAoMSzPI1s=
Date: Sat, 26 Sep 2026 13:53:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Brian Geffon <bgeffon@google.com>, Minchan Kim
 <minchan@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/mremap: fix two issues with MREMAP_DONTUNMAP
Message-Id: <20260926135338.7d7ea1d29a89351c964e5897@linux-foundation.org>
In-Reply-To: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
References: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9D491100004
X-Stat-Signature: credcqg7k7pxebp9t7ixy9xijodnj3an
X-Rspam-User: 
X-HE-Tag: 1790456021-120525
X-HE-Meta: U2FsdGVkX18WgOeNNxSRumOdWdreFvKF+BRSYVC/T+gPWNeIsB+AiBsbPCMncsZuZph6cgeZxRKH6gNYYfbnFQWksG3ME1Vaz4ele2VgGY6lcawAYL2BiYv05ZS4Pa2HURiut0OVejcJgbqp3jHq7HEVqcycFUSmSPCtzTxiEasxv8tBqCnDci3DSpMI3sqiDbTo7U6hJeVtsT6q6cLNWDmKD9CEsxdypUmgTx7bvF9MeYZD0hG3Z48yRVV2b61v2IT5gQSHW5WsBgun1i5Mccq+iaVk4GLyIpjcH6XwrIuJYpgQSt6aNDQGkkS2qtliQsrtP3LBbRZoYnKbpVV4v61On6AbbeTHnAagewfL0RkJ/0aRXZynVkx5KE/57nJM+kLyKkkS/unZhSH/bBjkt4fEQKSegu+bL/tgTSILpxt/aQ14us/XaJfDGSiaii2+o1wm/3sdtTDi/Yg72a1A+RNT+zs8LIz8AW/TlvncnqIVdKAF0T46Xg+Vfu2rlYZSXGl9TWLw1SgfvVUKMRfPPCHL6nUSRb9wcB+IpJlv/71GDRQvtZYG8NCaT5IxT+Z0oB7Ra5xIIEHeW8a7zW381hZKOR71gnogOm2kQ2TYku7Qwr09VUZW0owkvUd3XZQ0Vqy3v5rzUYSA1N4iamiTfvHrQDXYiBqG5XrhfRkFsdUCXGfLlGout+8iEiv2TZOsEduI/z1hkRpseLc0jWGkLA3zE2vLnA3YUerNEZFbpPPHlMZFYM8rLte8KRrcv+jMUhRMmsobNpFXBcTa6upG7BLtW5bwiEeT+pQInw2hPp1QfwT9YmJTq5QjFYAL7V3e+PU/O14LkZlgHBUIJ0RlQL1ow3qzhVJ6s/cR4E6d+EumcHI7Ecd/CBhlPJD2n9z+irVL70LRjO6EQaU+byp85ZwroXnVcpfg8VtVKBqKgTd65gu6wp36Qy6L9nAGZ5wg2IBU7qYd49m5tOvdiEu
 9I1eYcYW
 e9wJA1Pd+ykKxCedrD/Oij2+30v+wekzscvpgVeXKHKiBENJsC2x5Rd8JfajqPfqwrKzpNpGkyObHAXOhe3Bv83oVLrJBoJRM55kNVET+lUCBNaUtug8gXcfO+cGtLxdorxDcx/Wp5jgLf1ZozMl5vJp7hGpGZTa9UVl8TB1+xuAUs1dcaviZRf11br+rpJDxgBy1m3JC1S+Xjh8sNkAsxUMNr5QoCWwndr3IW7PwVjFskDAqmWrybVeWoGOnIVywoaHgQ5kwDaoze2DvWMYOKH4jsSTf7y9W/iiCI9NqbbA5IHvfcIMgG2vhAvZ5VUip6+NqQaraMJEMrnzYhAJCZYNPGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 20 Sep 2026 15:13:09 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
> operations that keep the original VMA in place.
> 
> Historically this has led to a lot of bugs where non-obvious interactions
> occur between existing mremap() operations and the original VMA.
> 
> ...
> 
> Both issues can be fixed by treating the source range as distinct from the
> destination range, which is the definition of what MREMAP_DONTUNMAP does so
> is appropriate.

Can we please have some review of these two cc:stable hotfixes?

Thanks.

