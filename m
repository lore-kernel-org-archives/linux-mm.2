Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43586C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 11:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626B06B02FB; Fri, 14 Aug 2026 07:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D64D6B02FD; Fri, 14 Aug 2026 07:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8D26B0303; Fri, 14 Aug 2026 07:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29E4C6B02FB
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:26:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47FCB1A0434
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:26:20 +0000 (UTC)
X-FDA: 85099646520.10.D6B8820
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id A50EA40002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:26:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+IYdrUe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786706778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJtGwm4PuqGEt1DhjdhI51bEUG2G1aKAyRx310ewmWE=;
	b=m5GzoxbdoQPhYkmORPfg9XDqRB8xDtf0PlE2fKDfhXoINw59pVKwdDmwfVMDyrnLGXaMRv
	to6JGzptnq6opFroiljI+CdAq7ST45Mq8bxtPK9qgfNmq/9wxKxdpKDjyM9nvjAaJRIJwU
	EOtxZxM5AG5dWTepgT5rk/OV+XBIIuI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+IYdrUe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786706778;
	b=D6JaX+tF2oo8FGpxNGNetoEUXwTIFogF1jI5juuQYbNfHDAECUM2HzuHcI8w3Y+tg3B6v7
	CLC/cHNEDJ5evCENSx1F4nScQ1SYoiYbCc5DWn4UEezqBl8IRE1tJV5SZ8oGmVE3tK3JnC
	9+Lgd9OQvdMSi69bnU6zLtXPJ6ps3bo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24CCA601E0;
	Fri, 14 Aug 2026 11:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9A11F000E9;
	Fri, 14 Aug 2026 11:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786706777;
	bh=XJtGwm4PuqGEt1DhjdhI51bEUG2G1aKAyRx310ewmWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e+IYdrUeYNO8ZdzLub1g2uoCjD0BVxWJe5jCMf/+HmXZVvDUZeOG8F3RsVKCG1FwJ
	 NtrNjMBrLU+4hycKdckQaijHqtQvI0ncIopHZIycgrmWYlSRDLC2wVX+S0UGuchvAu
	 mjMG1EMLGGnNLHhBzx1ycnKf/EEW8SdaPOeV7OounIUH8L0RAZU3KLsdnqLl6Un/GZ
	 3Bm8oa2NminSAnfv46mlgwFR6/zREyg5FkyB3WkH6LIx2Tz/19eOJt/ydpJzzJjjge
	 tJ08iYD9xZaaXkKbJJ4VZOZ63DJC+lW/9q/LXJPBHLvfHQJyvu3raga2lZ/d2yW6Uw
	 /cemAJx6Qj++g==
Date: Fri, 14 Aug 2026 12:26:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, geert@linux-m68k.org, daniel@thingy.jp
Subject: Re: [RFC PATCH 0/6] fix nommu mmap and add nommu kselftests
Message-ID: <an77GfTj_V_P_IlR@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <an74JAGcEuHXxr5G@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an74JAGcEuHXxr5G@lucifer>
X-Rspamd-Queue-Id: A50EA40002
X-Stat-Signature: s5tmsnsy8bxcnwaq7ekfdpyhbg8kk1qg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786706778-419050
X-HE-Meta: U2FsdGVkX198VA3YZMBFfp0IfrU4pTXctFgl1Poni6impsPs8JPxnpmFW8MsKClt4sSGWQtzqBMWTktUPr8A+mjVWP5ofpXC36FTHTknSY7kx7LojYMRHPRE97uLckcFLqNYJMpUMQ6D+dCzJB65Sh0ubpmn1H0Cu96pK+hDJr8gk6CwBSZOCdU27sPtfLRjKCiAHo/7kxsv6WL5kRO42NePJw5y3qTwT5XV2u7cOlZLiKLuqr+P5C6rRx7i1l29GWHmFqFecU+yOU/1MOSH7VCJRj4LLE7Zf5u/l39IDFghGNM6NhsyhQpWRV/K62Parg6ibm/Y13UXmUP+tXbXy9qJU2KkrFrhYCjyDFAjS8VDxAlFAsTguhhS6lIQDbBdz8ihT8uL6CXZNGvIHPK6hq5VZcd1+9hTCMXUYYSjkbyqKbEYWbciJAsYusCvTbKWGjakfke96Xa+XV781R9USDp/mKkQMU/3gpq9y1IGjoxF5zcMrDCNA1MChQ1UrrXRviB7ovq7hUp+U79yfJxd6HGVhxG4SS8hI0lj1eBrGnzX2qBZnLmDiZQpfBL322pc3x3/aetoe1ccAkWHPX+L/KQi0kALrkNZFpbE5Q+YWf9+ofA2l2N+q6gcK4IAJdXjBvHJJBUZm8zyXiqiCQYLC1MYvRd4v0GNHruUJuad6CwjNcYptDW4/Fmb5S48bHXG0ah0Q4Ku7+WcQzCcnBWfZShIuk/66lbHKGPOQIYq5waqxyfCHTyJfUTKo0YhK1RmfvzoKG9SRZhyxHBt0RciyQfl2QU6W5o5MoQ8ulJ33CjclhWA59DslIAHzKZ+OnaJpHaPsQSl0VSHo0l/FjHf5EMnYz6V8PKiGTlRWvnbzq+plZmK9hFjaqtk49r2d8t1gZ2jjhJZUnwLKGdPI2mXPtvb5DbFKDPImtzo4fO4ZjSW4twT+Hymyb/yhYnRxZjsXJbPHqDBgJTlQdOIN5t
 qMiIg/fb
 ERsw0I9y1AuxQ63izMsTGXxPpzEOLEvT1DtNkmCbckd85HoeAutxDmnrfmCldYwZ3XAflLbuGr23y2s34ZnueOtzui+MR3P4zL6nnrkYhxN/tKP26BZAbmvLzmO+e/sw6Wh9w1iX0jIohxtXs3mJiKPCYZWwDwGD6mQsiBHDqTxfVGcazDcPqLh1+om3cBo++HGkEzrXVxL0W9IjNM00HWXXxL6tilYwoaan/pnJpvenxAR7fMw7KkwV26A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 12:24:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> Note on procedure - please do just cc- everybody on everything. It's a
> total pain to pull down series

Oops didn't finish my thought here - it's a total pain to have to pull down
series based on the one email you get.

So please do cc everybody cc'd on a series on every patch in future,
thanks!

--
Cheers, Lorenzo

