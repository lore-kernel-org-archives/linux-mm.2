Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FBA1C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461906B00D4; Mon,  3 Aug 2026 09:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2CA6B00D5; Mon,  3 Aug 2026 09:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2156F6B00D6; Mon,  3 Aug 2026 09:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBDCC6B00D4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:37:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FFB740645
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:27:54 +0000 (UTC)
X-FDA: 85059280068.06.8766286
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 97DEEC0007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:27:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AbfcY4u9;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785745671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+z9Du/7peIkWHVD90FqJtdry90ZFGmfOP9ki67NwPg=;
	b=PvipJ7lF+3lHJrl+FD7qisxZZ6yQOGnxcbweCTZEaRbQG5q3O5jnqC4zy4EzKqyGc3EcZ4
	S9CiRomCS33vY1vHnslIsOGgIFYvw+vRp2SsBX0jqNd5l8MIvH9Rhv8T8CWlC4jM0oKwQZ
	myKTy+V8PMNGzpIQmyfNLi6wq4feLBU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AbfcY4u9;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785745671;
	b=wfwp7QVUmgeKzqzgh4Bt0vDCf9q9aO5MJogC/uQdZjrDOwiR6rVou3N6+sorJAKUBAG0l6
	DDB7piiUCT+5yinm8FjIN1WpGA7KG9itdHGCnB0CDcsdYwY/sBVFmOitpxW4kRnP2uqSK/
	VNzVQ4UNEm+HYEB//YsiDcqenG1EM/s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 16528600FF;
	Mon,  3 Aug 2026 08:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC8E1F000E9;
	Mon,  3 Aug 2026 08:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785745670;
	bh=a+z9Du/7peIkWHVD90FqJtdry90ZFGmfOP9ki67NwPg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AbfcY4u9BcDKVXRy63CDlWEDBdxlRgHjcRAsEvPiZXCIpSaq69MUUu5eOEj2VAaeM
	 m/5glaqtxhPJxgzlILYfQGrxMAh/FY0A0lj1UYx/+BSwaPf6XmRSXF2+Vb5KzANGI3
	 2wQCS3qKKxvMnoYkKrcgGQJI2UjuuOaaLVUFodb90z9qvSGvBsMrRwLn9wE0EVvkKa
	 M1aS5ttx6UMMfMTUEct1Q+//SH8VbLkFd5dIUxBLghmZDOPeBXKhVD43o7CTMDY1Rt
	 HnFLvS/ehZb+9UMLDspksn3+LoNlFKjjP7nJmROzF0daBM3SUVrOEpLZl5Tdb3hEpE
	 IfOPj3JsNCWMA==
Message-ID: <f983f6ca-7d45-4316-94bb-8b4d0fd58079@kernel.org>
Date: Mon, 3 Aug 2026 10:27:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: only update lowmem_reserve_ratio on
 sysctl write
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>,
 Jianlin Shi <shijianlin11@foxmail.com>,
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>
Cc: linux-mm@kvack.org, hannes@cmpxchg.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
 linux-kernel@vger.kernel.org
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
 <tencent_1BB7A5C4D5EEA67346634417753190E92A09@qq.com>
 <20260801114434.232c97a74d9616c43aac2456@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260801114434.232c97a74d9616c43aac2456@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 97DEEC0007
X-Rspam-User: 
X-Stat-Signature: fyt7dac1dfdyyid7k8hi4u8spmqjwwp9
X-Rspamd-Server: rspam04
X-HE-Tag: 1785745671-170118
X-HE-Meta: U2FsdGVkX18OMEDKHqHXI0ToRGjuPJ6jd68NqfQ9HPz5JieYKlW7j3w5dMc1gFsxkcAulbbi77quPqFHFHIUbm1WChdq5hFMMpCeevtDcFdqG7q3RRldOHVXBC4VNOR9JSu0eJWcKD35paiSBT4PV/+RuUKA+npqbhtOzo9SSxQbg56xf1q6BYCIwEBIM6elaLY8UxldzyhCovrl2zmX5cf1pQ4NedCnhRulKvQDxf3dm0F46TTezvlmQKRd0oUEDJJnFooDEdBlTJUdaoJENKhXTGh8nfaX3eegyi2ZuT+HRqLsfi/3nVELtBkNv5U2fkfxNOQdE9ZUyAolgKsZ3EPW5HgqNj8/VGfcBqMzQDREbdfBalL89/aKIHYFnwfFsciFNA4elvxE9IHLiARede65cgpgwufJ7O/kvWufTMwSaYDjktwmIGPxcEAgNd84IyDyFrcV7168nQjSfP3vrk63duimTNHl2vqZEUCDyJKCB2J6PkRDcjcmnVLEUqqNIkgaNuQ3wsfxwxDH+LTldCrqraBsGE87sOFRZxh/epXV0VISkR+WvthQyiv9r9fvCgWPCDjMC5+eDPdJXKhu5UUBIy4lVJhFcVVfWFTbwGr5ecTVF/KnTvl33vDXM110fjF+eJk4Vn+Kv3mSHSn0aXHjiyiwU8Pj0nDJ0qbpwcGUt+AF8MLt6nScxfKFGTJZ8cgzCm9WC5F8RpckTw4TItIaR92o35n3uS2rcoRAVQcp9cLR/EKGN3zsCpTofkxWKYMmEcmT0ItmJ0p8cqF424E8W8Nr07a1y8pdg7ysD+RAdID6UbrIONqdC7OOsbH8E6qPlepwVI6ZgvnEy5iVpJr11r1SriKkhvdYvi/hYkCwoNk+wG03gE+xa6QeHT86Bwh6S+mC9o+5/ddNVh9zDs4sORkv11OWhMhDlUiWbpMTHONevVphoPqSFWbL5lWLTicHiIgallECg2SwkDb
 WG8tJWkv
 JuhTcs7iSwo1jWXicprUb9yPERfhbptfuFGfcrNH31E7WrcyyXcd5MfnsHMLLgkTlcBFu/PIA7Mv+hbWrIzARcXNtZrhkrfJ7cYPboVezGMsUSRPx19QGjEkG6En2N3O6Kd+Em1imOzWM85DT04k7Q3l3NS8FzcB3x9NOPIP4WIK1J22cezGSWwwv/q+xPDSAgAndjb17UGMzr6Ybo05lUjKlm2EXlaWH2FSkkQmptzuHI6QKQJ9GolQfJ0KlwQ/OTRFS3wXUfNUXcHk9sEix6kTr7wmyTh1dJJMNmoXY4pqddWc7CmnOkTvtE8kNFqVRKgtUGQKk6ceuBQZmMZTtrjZhbEeDg24yDcrL9+fp1hrqYcDgxuijVG8PlS+/ufhG2SNFmrK74WWgrgzhryUDiOPjwICwxmlQwOchml1LA8Hr2Nf417cwqQn1W8dR/5I1kknYKf0GbWfuLA7+2LvccrjwKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc: sysctl maintainers

On 8/1/26 20:44, Andrew Morton wrote:
> On Sat,  1 Aug 2026 23:11:25 +0800 Jianlin Shi <shijianlin11@foxmail.com> wrote:
> 
>> lowmem_reserve_ratio_sysctl_handler() ignores the return value of
>> proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(),
>> even for read operations.
>> 
>> Fix two issues:
>> 
>> 1. Propagate errors from proc_dointvec_minmax() instead of always
>>    returning success.  For example, writing non-integer garbage to the
>>    sysctl now returns an error instead of silently succeeding with
>>    unchanged values.
> 
> AI review suggest that this caused a new problem:
> 
> 	https://sashiko.dev/#/patchset/tencent_1BB7A5C4D5EEA67346634417753190E92A09@qq.com
> 
> Not sure what to do here.  Perhaps pass proc_dointvec_minmax() a
> temporary then copy that into sysctl_lowmem_reserve_ratio if all
> proc_dointvec_minmax() returns "OK".

Seeing the v4 [1] it seems easier to keep the current fixup code until
proc_dointvec_minmax() is fixed.

> But really this is a flaw in proc_dointvec_minmax() isn't it?  It
> shouldn't update the table data until all the data has been validated.

I agree. What do the maintainers think?

[1]
https://lore.kernel.org/all/tencent_B9556590D4B65ACF74C06897689A6E39F206@qq.com/

