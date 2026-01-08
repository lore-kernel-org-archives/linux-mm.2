Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3223AD14886
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 01:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B2B6B0088; Wed,  7 Jan 2026 20:06:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9683B6B0092; Wed,  7 Jan 2026 20:06:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895536B0093; Wed,  7 Jan 2026 20:06:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 776186B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:06:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3982114052F
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:06:56 +0000 (UTC)
X-FDA: 84307007232.08.DDFBFFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C7F3640007
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:06:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmyBdwU0;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767834414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRzA62amR9TXQMGUP5rp4JUim4m3+4kYizqo4z+41+w=;
	b=mp5SAQoVXL30ZLxvZ9JsQcf4iiNv5cbqbEevcl+40yXXWzY08Fi8oOBeX807mjLrZvr3kc
	jBjVDZUq1NF7RbDqqH8wlXlfoSn9bw/CENt47fuxpNb4Z9oDV+VN/mCesFQlJIwafOtmaH
	liTFA8bPnBYOyQc44Xkq///FHucaCpM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmyBdwU0;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767834414; a=rsa-sha256;
	cv=none;
	b=4z6zalTe18XtP7Sfgz2NJQtsl21RbrGYKl2grZoPRn5adcdpR9e/hSqh+2CusAX1xGywRV
	3m1y08dmkpi/BR8E0lF7ti8Ybrv+bSEZjnHC9ViRWUJQ0iel9ztgB7HVkwvNYCHNbrZHVv
	RnDtUEd6DH6vXyJGxOJFtIh0Y+zy5/s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EA3FA60007;
	Thu,  8 Jan 2026 01:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67569C4CEF1;
	Thu,  8 Jan 2026 01:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767834413;
	bh=j08Dlj1bBoeLCSSKPIfav64GBCjVLleA7aLgxebYpeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmyBdwU0f6fvtiqRTTYsTAW91UHc0CYcIFyQZo86wGk3qq9YwwLKrTphcA4jZyOAr
	 Dstz1aob3LXgig9TVoUBIgdAo+k06l9Kqx5WQ5j1K7JrSHxcXoo/kDQ41IMQWtFMji
	 B9tnW/6MYdk+V2W3NAY+TGtc/BAjPgkgbgj3D/DB7H6roJlto6JdfwkvWgEe64tIfD
	 pa9/9z9Vfvjw+g+oNBY2YDCI+VMM7kEkEn1LzaEDNL2QExHeuQar/DBJr/F6u7lZVp
	 ipfsIEFzl4oJJVnNjc2A6ptZytOpgp8ADfsjDdrvR3anMehC8AgUFoml5Iu5CLXax+
	 xX5NxSABgrdcA==
From: SeongJae Park <sj@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Usama Anjum <Usama.Anjum@arm.com>
Subject: Re: [PATCH v2 7/8] selftests/mm: fix exit code in pagemap_ioctl
Date: Wed,  7 Jan 2026 17:06:50 -0800
Message-ID: <20260108010651.80083-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260107164842.3289559-8-kevin.brodsky@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C7F3640007
X-Stat-Signature: pc4smk58g48gqb1jt8hb8zn9gw3rmapk
X-Rspam-User: 
X-HE-Tag: 1767834414-589103
X-HE-Meta: U2FsdGVkX195nzuqifoMKneSsxsBuahsHyPOP2cVbGwLTruikLwwPF2C71ba7/Fa+XKfjnslcHu1x/b33XVoeCUOF/O7C5SzIZrvuqs2YQxhRLPAFAEHD6cdy2+uuP2+ZJKacmU5j6995uzgJdtcu82QCuScmAmNR+usk/1R459MVAvgcgX1fss8wjQBF2HL5QOHVL9yjAdjMNpYDlgDeeUlfAH9eugse0g/RIHdYOGwZCrzUdYJrZ7XQuowKtvQ9+exvE3ADl/Li0MOeJseeJNAlneXgj1BXUNCUMmn1LqRNfoFz2Kr0r2Psafi3GzL6xaWfndrF5EcdIZfL9HXNVCp3V6lNq606tRgl1xOuO0oNW7UrAqYIMlXcrViBimVDzuDNeOm9fN+54bBTLMwDMuQP6EWmKV/HudtgbFaBbu5UzDEvkOlCeGnXV+vfArVGMRAmnc7WmXNf0KYBT/koxAfTfBmEOxoqck5BDf4w3rB+h0i8Jt16VfPTpUocuOxsXbvJLNeGvJ3GbBLnzjWSbwSRHajLmdj8SCwRAXhAJi3771xwz7yYnijOMwFYssbQ3DuhM8YE76o87PZN8sTNoOUlytAcDKewd6v7rkF40QRiqUsJ6gygJ3x6Z8qoMIbMDx0UixAqU1NdoXvLvP3JNufZv/a8gFeGziG0DZrtnNUM6w5IyBe1BGZh9+fYYhuBBMLi4KHvt2rcCSz4vTZ9cLRBf5nsum3L3YhR2O4w+gQV2+E8EABV8EIytG+Yl08RgU4D0KaEuCyNhEyLzmWacMmQMHMG6Vp+/S8cr+IxVpgN9qhp3Slb09JPXucB5zhHfqI8RaCX/LbtMoxoxPygxhOErTHcTN+wu5DkLw+GbrltW3Nu2+yfhTMsO64qUM8qhQgB7433FWbEh8HdjDkRlAk+s1nxvlEIrZqFj9VfgY9iB4snYm0TkGGGxQWIHouZ+OMD6+PPuc3gLNPEJC
 AAIQAYL0
 vm+A6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  7 Jan 2026 16:48:41 +0000 Kevin Brodsky <kevin.brodsky@arm.com> wrote:

> Make sure pagemap_ioctl exits with an appropriate value:
> 
> * If the tests are run, call ksft_finished() to report the right
>   status instead of reporting PASS unconditionally.
> 
> * Report SKIP if userfaultfd isn't available (in line with other
>   tests)
> 
> * Report FAIL if we failed to open /proc/self/pagemap, as this file
>   has been added a long time ago and doesn't depend on any CONFIG
>   option (returning -EINVAL from main() is meaningless)
> 
> Cc: Usama Anjum <Usama.Anjum@arm.com>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

