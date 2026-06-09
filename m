Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFAE7CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B836B0005; Tue,  9 Jun 2026 06:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21CD86B008A; Tue,  9 Jun 2026 06:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133736B0095; Tue,  9 Jun 2026 06:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 014476B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:28:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A51081A04D8
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:28:48 +0000 (UTC)
X-FDA: 84860000736.16.7A376A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id CA9438000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:28:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyGbmwbd;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781000926;
	b=pqBY7KWCnHG9b5D4VPnwgXt3Ysv0y1bri1fR7OPeyMyV6GwVJd0b5yuhhf/o+23LiDt+NL
	/ivJewvNupx/dsn96Ad310zKd7xT0YCr0NZcJsO2PBSiEe4NeLRYLYfbuzeuTDsLoINisQ
	HtUbSUTYo90Of+qtwzvDAMjDQzCFy2c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyGbmwbd;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781000926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SHoQ7xNtOaoKB7nux+V0oS62sZyKCmF2ZcVQ8xYDiU=;
	b=YH1ZnGZ4Hq015UTuh8gyvwRQOjd3T+c7OYJEjxMFsxyVZHmZ7L4Tz+ZZQNt8dD2nKVbeR2
	obLhq1GqJjxyZOsBTXiQqzq2FtFh6l0iOQs1BHOVlcDJB1ASrr7O3YN9hREKLu4pIE10do
	7wUkyLjzUrBPZYRpfsHzVPqkdvVpqiI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5EC0424C9;
	Tue,  9 Jun 2026 10:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FF31F00893;
	Tue,  9 Jun 2026 10:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781000925;
	bh=+SHoQ7xNtOaoKB7nux+V0oS62sZyKCmF2ZcVQ8xYDiU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SyGbmwbdd5XrvGBPC4jzaUkgTIRls6eJTjJbCdxY30m55XrPAhK0fOXmpf3Xill0n
	 EQ6LfKs6LC3lXC5srQa3fIvZMXhSmgFjSOv8BuCgmrKvClxJEhLfBogPR/ZJFRPJRF
	 mVs1/2BXEl40pOkeJPYO1QiFWRoCSo3BxQksl73jrMrw2X8G3TVw7yPmwpwPR6SFwU
	 BWHjrtumql7CDoKF7pQM6F8ZfNNKOyeezEUfvXtWCy8p8y0Jh8/+whKFTPEw71NGzZ
	 2lk1uT8omaO+lX36OijgsDFyLMFQjivuFDKMedHWy2kzHagTNuhwunsHOGIYgvax/E
	 csVdx69VZgUMQ==
Message-ID: <c10c4248-87c6-4997-848b-cb94a71835f6@kernel.org>
Date: Tue, 9 Jun 2026 12:28:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
To: Andrew Morton <akpm@linux-foundation.org>,
 Gladyshev Ilya <ilya.gladyshev@linux.dev>
Cc: ivgorbunov@me.com, Liam.Howlett@oracle.com, apopple@nvidia.com,
 artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com, foxido@foxido.dev,
 harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, torvalds@linuxfoundation.org,
 vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, ziy@nvidia.com,
 pfalcato@suse.de, kirill@shutemov.name
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
 <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CA9438000A
X-Rspam-User: 
X-Stat-Signature: 8hd7jziehre5cdiyxa3xukcb3n3rid1o
X-HE-Tag: 1781000926-806289
X-HE-Meta: U2FsdGVkX1885cDsJptsR0ANFB8lBiC/Y28aVqh9VG2anzl1XMcOMpuFUnhHiukSi1nsb/C03aeK/Ol2cqnY3KjKp+E52VW3/avcMShe0MzSpCYVDKNKadDr/GwFWL+xLBkt/GtR6eVlXlYk4HHoVVVxZz+TzK0GInHKxpemUh2Se5PbFb49fFXcdDfZHwFV+kB1UPvxYkI4phrxxNr8xdf8muCxbWhxawbaVVy18bZS3Vmo8DYiQMvwHYVpAJvMOMl5w91dOokQsyOrX7ApIS0B181UBPOh6DNtr800bLcTrmlnDUeMGM0cFnTDqwkF79pDArMSdxMxBCiIoh2NPc5InooUmExVrQW1CpIhnFYcOXpWK7sKvEzF7j8gH9fpxxX7H00+C588uXPoPISDNt0X35HLnGdYHzgCFJ/D87qIQ3Bkrb8PcQ1sD1waso47ZGgmK/XCHVmwm+a5a+W9JIfh/WoKdJKG3cbuvD6l7VXHyhDqtv+MwlrFNcUcfKPBJa410MeBOGckZMyVcbf+FiSoofqnA3vgTL2Hp8npEyxpsZY1veVHDCgdBQEpqzMRMHiMK+qYytIcC6S8AF4W0Edatql5V9zTv4VtVgv+W6PWrjQriReetL7fKwNAEAwSm7vGAkaZseGGjVSYFfNiRDpp51iDREGFCrcfWelueeGlJnxfbWci0MYgcfw8ONlXDetwrwhTHldq0wXM6lWi163Ov/3DNu5HrtgaE0/VZZAJB/yuGaVJSCbEkJhFE3ynjsPb5HDZzWoKz6xcfDOZ73O5sxOUwARQmqwiAv60+28bswwdcCC5RGPffeLLVrNOfa5JNTZVIf7fNLaHl4vIx32cNgNAfjhNJC/BDWlfmUfWunyQBRMOVormB0BLI3GZObo4kAEUXISi+uCvuFhS+B0fY0a8JlvASV7MDfsQYANSnet8jXGv5wz/ycvTcGuoLHeMlWbCutHKp2Xa9hZ
 px0Rw5o3
 92mHVw7bwCV3gD5Anf3Ns7Xyc8CbFiDGFtiwO1O5heAI6vATM1sIr3gg6sxHmMNHNpgC2justAz6vuXuyeDrmoGV+F3kr3TT2OjGmeClfg+jcezZlEQFTgDX/wd3KObevRpPejDD0ECnsd+vFyLZOsb4FNKKKYEUSglZ5hTwf0f1pjlprv6JzXXpztD6QcQWKqf3n89BsuqFA1Rq+TRMmDEPGcTeanbaKBhfzXMr7OR+GKEKg3LV3NvZKSkiyrP3C1i0BbC4oCoRDdIeKni+WwzUZzIYLD8rIMqyoAncZ05FnAmexn3NVWiC0ghMheyOYmcEc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 00:47, Andrew Morton wrote:
> On Mon, 08 Jun 2026 21:53:01 +0000 "Gladyshev Ilya" <ilya.gladyshev@linux.dev> wrote:
> 
>> This patch optimizes small file read performance and overall folio refcount
>> scalability by refactoring page_ref_add_unless [core of folio_try_get].
>> This is alternative approach to previous attempts to fix small read
>> performance by avoiding refcount bumps [1][2].
> 
> Thanks.  Nice numbers.
> 
> AI review had some things to say:
> 	https://sashiko.dev/#/patchset/df26082871b4c65b2bd38d409026237c08572836@linux.dev
> 
> I'm not sure we want all those new VM_BUG_ON_PAGE() calls in the long
> term.  They look like development-time assistance. 

VM_WARN_ON_ONCE_PAGE is usually more than sufficient to catch stuff early during
testing.

-- 
Cheers,

David

