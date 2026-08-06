Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E76D3C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37216B00AC; Thu,  6 Aug 2026 14:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF06B6B00AD; Thu,  6 Aug 2026 14:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFE8F6B00AE; Thu,  6 Aug 2026 14:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC56F6B00AC
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:46:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3CBB5A01C6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:46:45 +0000 (UTC)
X-FDA: 85071725970.09.41D035B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0A55A1C0009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:46:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wxALH0zr;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786042003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/yDdM+xtBIjfhLSWDVmVpQD0k85o3q8t4merW6u7QA=;
	b=C6foemTYLX5MMPx3loYkAn2y6SKzMHio6GUFX7Hn26gTbZKRHTx/yzjHWFTsdCMHQjIT+5
	mKNrDLCkMgDpD/zPg+zafhnwTEOMwpNNoVeb1btGm9t6s11as3GJ8IB/SQohLsI9Yo2kg9
	OEPY/q5WvBZX3uJHnVfhbfTyulIVq2w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786042003;
	b=U+yRCqWOtmis0gsxN3HJnIu3fetRnIVLMKhR5kfsuETzjT7DW+fM/oxUGlOgdTlrEyun3O
	S0Z2rnRc+UYMI4clnvrU9wyGfy8aVevrsilVii/EOqMfDhPWWAEe3KMrpr8296Cuek9zoD
	P92aMd5EcAw804vi+SQ/vdh4Qk4DEDw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wxALH0zr;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22F7E600AF;
	Thu,  6 Aug 2026 18:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A54C1F000E9;
	Thu,  6 Aug 2026 18:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786042001;
	bh=Z/yDdM+xtBIjfhLSWDVmVpQD0k85o3q8t4merW6u7QA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wxALH0zruJBk2K/lSFP2gs1rsnRh8jjzXCMoB4elwdkVMBhwpQ9JsLIptsJh/UCaN
	 uHot1HJSGxHahs9dQSdAVsVGblouETBr45OgZ/++2STIvJrkTWXMzKZ3nBuZsInfJ1
	 Uz7Xi0EPqSioHVu+NEkLH3UIAnvFT8tVgalYhnVI=
Date: Thu, 6 Aug 2026 11:46:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Audra Mitchell <audra@redhat.com>
Cc: david@kernel.org, jocolema@redhat.com, raquini@redhat.com, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah
 Khan <shuah@kernel.org>, Colin Ian King <colin.i.king@gmail.com>, Muhammad
 Usama Anjum <usama.anjum@arm.com>, Andrei Vagin <avagin@google.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests/mm: Fix soft-dirty kselftest supported
 check
Message-Id: <20260806114640.722b8b12d32f0f62a238e5ba@linux-foundation.org>
In-Reply-To: <20260806181843.1839943-3-audra@redhat.com>
References: <7d6b4401-e230-4ca7-b64f-c1277fa643b8@kernel.org>
	<20260806181843.1839943-1-audra@redhat.com>
	<20260806181843.1839943-3-audra@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0A55A1C0009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: efsfjik8r45zq5rocx1bzokk8kt6hpat
X-HE-Tag: 1786042002-111031
X-HE-Meta: U2FsdGVkX19s4ZhcnOJmaaLCeRPeSm0DcyNJRtja5JgKLRusTlWQgQ6JHaKOtxiv6srGJRzE6x4c36wUJCklhMfwusjx8NiANKStyz4UTeqZdzgYQO90MOHj7g8+VKE8+fVl7OkYJRLz94kRqs6p1MGjrgTJq2+uWZ4MeGmS12Ps1fT/5NpKnQflZoMEVlRW5H9Uzxqt5URg7BdgJc+oWcLUK70uUQV2IaJ269jUMO0I/NnFG0watfgErlI/KMci8Fqg93YTFpEmi6nn+exLFzUzIlTXX4CfLWQnWAzsnnsxJpalCl/X4g2YxJsexKp/8K3AK1Lxp3GLU03KTsnqXNZxyil/qHPBQh6GBLsZ/eAc1/Kj0dYyjjCAwV/1wd03xh8NyZGvJDNAmgamF/7rY0ei6HtsD1vhng77oXAg0c05Mnxd1Gg8jfCgyC8kzKW7UK4QCL2BB6MhvHzCaPHavftKXFf3WRl4nJCfhL5OqojWyVuBmIqGiXtxST5bN610XLSKR8EGMJdNUbywr+dL7l0JmMDOwoxzuwNy7CBkwnn/i/PiR3TgwHQHb7w5s44dOa+9dapQWYOb5fM3ojTCahidVomUU4+9VCccZc77HngkoCNYDniEvEi2+pnLK3LBRT91gyb43oUzyJWerZgY5q+ODbJsc0oN+fWS1D1QUvkfnzhZ53pvzvIbWfcmzIoZaHMzwbJeAcTmRmlrKdGglXujZ1C+9q+tV/Y1k/Zu1KoRhd6Zo2oPhj11Jdu+iWwtpqEH7XokGBKfjIE2ZhSjdDxqwjaGZ7ufrW79Vd0c/7umtSrh0NdLpjMQw6KXzgWYsPt+hawZtHEF+SuRtB9JEu0vvplCjO+oLHXqI2534KdyUBNy/e4G84s4/KQeLsnW/RlV2eeohVSKEFmFihoo3vxPDpeZcDtiTu1eb79Cvo6ebeCrI3fSNiSsYEPeHBQeonF8Seh9LYIEpAzv0pv
 9F5+P5wp
 UozD/x/NEw7MVgyxe+62z5xJkDj0fN0lvbZKHQBeOyv7qAZPGWGmlxOghHg6BgnxmUSI7W7DHrDRHnSdIZCDsYb5trUVB0pNOGweaiOvw+6mT9eSowvpdsF8CpxM+VsTVuLzhWAxJL9OHYtLWV0ayUIDN3wOKYfFyzU+XQ8OC08hodbyupJpU3M/1qaco95nBO7QMASMOC6uWTEvf7rrkGt9BxYgSv9qmFmZZ9BX2tK9pK2vuKyLqtcFMPCQ5M/SiFDVEn2bJiGgljUVYbfMPPKF+yIJbjcIlYIpK+2fMaN79Bl3jRbOjqPnEq5a1klW0MnghNmw8Nkgg3qi132920f0NMQ03wDixXhtvBo5g1cOokc5DEKwsObYGzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  6 Aug 2026 14:17:04 -0400 Audra Mitchell <audra@redhat.com> wrote:

>  /* `start` is any valid address. */
> -static bool pagemap_scan_supported(int fd, char *start)
> +static bool pagemap_scan_supported(int fd)

Thanks.  Sashiko points out that the comment is old, so I just removed
it.

