Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C84CBCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 06:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 045E06B0088; Wed,  3 Jun 2026 02:52:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D3D6B008A; Wed,  3 Jun 2026 02:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E76016B008C; Wed,  3 Jun 2026 02:52:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB3336B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:52:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88D741C1036
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:52:11 +0000 (UTC)
X-FDA: 84837682062.13.EEC787C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D8D4A180006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:52:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J5OZ0l4i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780469529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xz6Wac4dFBhlZu9nlXxNnHAnl4msktquKY/eR4n6NfM=;
	b=YG1wcBfIMpseNbiCJRLHaG8ty5VIoJV/zGlPgeTOS1nYtAM4iSftS7WiM0tiGkcroZHy0w
	fbDMnnytulKx3eMgeRrenObWhtmR7gwvvvQjbEsQYV4awYPWnc6Iben0ahox3ljOMm2CN8
	h54/TAcjenC2sBrIM6rnmoHdnrugXPU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J5OZ0l4i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780469529;
	b=kAWmySc4REwPb3JlFtr1xQRWow7OCkvL6K8bg1BKeKKkFdJkbJgmUlLNlJgQ3lBcUe6qql
	iwTkQeO4I3LNlsvb7lADHqjKDbxOFqAvwn3mZBItAzlAjgAkLpfaKuRKzyhhJXz+cHGwLc
	2EykN/A+BXfQHn/fti2xM0CWOByiGHE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A5C56008A;
	Wed,  3 Jun 2026 06:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F3C1F00893;
	Wed,  3 Jun 2026 06:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780469529;
	bh=Xz6Wac4dFBhlZu9nlXxNnHAnl4msktquKY/eR4n6NfM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=J5OZ0l4ipDVsuhKD3zeAA3+kRDn3mJrhMzJ8bMuR/1HJU7Wvw8qy+Hr1TgSzT63Pj
	 hjdKNCqH1cgOXPvOiyWxQ+I33Z3qdEJiLFBnKvC48d6K2k083loJKmGhvgPX01XQpw
	 ECyf0L1tqscWRK3PfRZEYJqnebKN6cTT9P+YjaIbLGYZt6qp6hC2MFdh+VT7A396A8
	 +4kWhrv9hBq8Y6BZI3xYqit9B+uclK6AyOe1YMJpbRooF71wSo1ASk84/keYiTVPvx
	 DEqrX4IWvBMcZB+79jPqrAci9MAdQWc6r9/xoMtqFzoGNtPCZ9SjU4hIK9PrI9G9X9
	 Rh+uAzD4eHEMQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 02/13] liveupdate: avoid mixing cleanup guards with
 goto in luo_session_retrieve_fd
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 skhawaja@google.com, graf@amazon.com
In-Reply-To: <20260603032905.344462-3-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
 <20260603032905.344462-3-pasha.tatashin@soleen.com>
Date: Wed, 03 Jun 2026 09:52:02 +0300
Message-Id: <178046952227.468621.16091000479096712016.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 73tdqoiatuax7kgcc45m766u1rkynqbu
X-Rspamd-Queue-Id: D8D4A180006
X-HE-Tag: 1780469529-682249
X-HE-Meta: U2FsdGVkX19rSXseCvg0WalZYobzYBvRyOfTjMLO2D0gF/sxF8PzyVMUtCLLCoS6aswCe88vuLRwpUWkAY1kbrOtkzNE4cv1gfi6Wl7q/QigkVmDWEajSKw1LrZ2pVYQtP+25ErJH3OEdjXJ2tQCeYp00EeY/LBWAp5jyILmiHSl4VMRfxZBMjvilmxz+BvEc14z1v+1mhSA/mPU7h2/ZW/20SSjdsa3tkexKT4cXNbrRx9ZITHpcPB67mqrDZBhw39sGK7fVLCJ6iEdGb5QGBKeufFBQ4Jue/qTensfAUsBmVo4aUcgWKFPfwUZFHiwUyI17aWBswz/Sn70nEv300RxQJt4kElRWxXnYDOUw7ht+a1Z+uC3oWtDjNwm/i6gu9Ud+sDQoxAxa7QYPghcPansa11tKmgQiAA62QuBfYuCtxcVbysMxt1Jf85QoZdkHTXhD2hRAdxv8xxjVQkvaygUMH5u0fkpb2/U+ESX3UkOnNUaFZvkWz7Qiu+Dq5btel2uoMrw8SBTP3GGqTTNJo8D1J4Jj86kEFGuij86XJ3BeiiEs7I2BWmWTXeolxI+oDQdGj7zxXpWkPcpoVGYgQu4tDcIV1CGQnuQ1UoS4EmiUTpiIjXANUwjRVWiXIsOT3RI6ySBHSknUc/YQOf3oAU/6b275u2H5z3+tyoLmtfaBo0hAy+74XglhTt27idWvJzD1Hn5jjwAgq++qeXSLC0pH4p4Dk3WDxyuDvrtJOctL4V0I6k1rHyCyJDJClMVgb3Yy9hlxl6rXr5JL/0FQNG/lpYLr1FLqQqAadZhN4YtmYK64wE5TA/1DBhFj8RMBgUS24WVzDIvwbwBQEmAXBAeeZf/2W6L5Bc5hinneD9dxbC5qjchh5mtfygpWC31KKWpJNl4NNcfrMd508O8XISBxZ9tn23w7UdGLXyJMN5oxhXNaS/lL3I9iCBHt7a4O2C1vPq6dqRbD2WiW/5
 u7XFtdSK
 XtqwWYs6Hr3rvJvVrjJlvpXWyg6LJdAI7zsi9l4Rimgel9Nfebxmg9H8igKVi6UNExqZbHptcCNVo6a5vHVNfA3Y3NX6tgy4SVknKTM1jHx9ASp/X5KjGmQlgHFBSDprBJ0imV1SJj5/TWj4OdMVFt1so/pK5118lrt8svBDqDspCR7zvcte+oauaVPnpxH//knQ8+mN+fzDVh6KOuIRuwIGObCP9JCBbETOvxqvkoLfZaQITooLMTRzg2Q0cDoPRWzdD37++w52YJbzHc35lN6PonpOc1A/R6RuYJi6dYxf2yqN0hm7LqvomOomgd+3KKPb2VaQYrN5uFC8K4J1P9Mn+g+2T8UGKH4bHwKzdXJqe6fhlsU/toOxScw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 03 Jun 2026 03:28:53 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> Refactoring luo_session_retrieve_fd() to avoid mixing automated
> cleanup-style guards with goto-based resource release, which is not
> recommended under the Linux kernel coding style.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


