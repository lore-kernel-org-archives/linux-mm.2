Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D33C87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 23:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96C68E0002; Fri,  8 Aug 2025 19:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47C88E0001; Fri,  8 Aug 2025 19:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5DC18E0002; Fri,  8 Aug 2025 19:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C50908E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:26:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 451E5136ED9
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 23:26:57 +0000 (UTC)
X-FDA: 83755177674.02.26D5B3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B9008140006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 23:26:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jL6DM+f0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754695615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=boTngEeMDt1ckTfkQ5zWQ7oRzDlq4xklCwuVuPlzH4Q=;
	b=mB/3L7fGHD/rpd06W+FTHHnjfAyM3mPv4oscAloJzRKGaKHg2RX6pK4PEJ+/2LPox39uXd
	xWjHIeKSVToeBjOFE1kEGf/VY7HMReFJSbRgdf9wIEWj7YX+LOmI2RHCF+1EtE7ZqgN/Yh
	cnVYjHoBn29EGu2q6bnH2IaabWFlGSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754695615; a=rsa-sha256;
	cv=none;
	b=zk6ePZTzW6FphFy8+Db5UQpjbBqOR9tgwYktlfLkJWxyHUpFT8QcvCfjZRQYw1JBWDcDMZ
	IGIoO4ahHJGBEuBZFIzaCHeYuthMc92lB3mSNhTy/X5K0LWiwKNh5SMxYyqZWl4MyBDqQi
	x2ejzOwWRLaICXegiq3FN93MWxIvSO8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jL6DM+f0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A4DB61455;
	Fri,  8 Aug 2025 23:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C85C4CEF7;
	Fri,  8 Aug 2025 23:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754695614;
	bh=KFBtPZD28zjWCeCW3N/MBJ1COAMg+BR6ai4xLjQzuBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jL6DM+f0wSE4G5Z0slaEH/nY8VWhi58k6Q6ZdDasfPklTv20tv5Q2a4RRU+WqbOUf
	 10kWAHGgHLvfzrBebWtvknmLTCW4RrxZokronUH2adSF+oZMsaR6i32khxeumK0BNY
	 A/l70J/jSdLGhpZs0UJ5MHp8v80DaGbaFGXfYawB4YHjZtZXnMLuHkMk1PVBecmNTI
	 2FjwsgJYtJNyWa4Mp8CAQ+MPTI7IEPhLw6/VvemwxUmAwniBXbFW1SOo4IvKNIjDn0
	 cD08vi4+ZOvhFAPoH9/Wa5jr8GoSAEmOtKdj3qWn7VcTxvnY5+dfqbRGVjX18fugrl
	 A5HctDdvVOPpA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/core : fix commit_ops_filters by using correct nth function
Date: Fri,  8 Aug 2025 16:26:51 -0700
Message-Id: <20250808232651.51186-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250808220815.49644-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B9008140006
X-Stat-Signature: 8cixyf1aiebq6ayb1s9zjpymqn331kzj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754695615-200831
X-HE-Meta: U2FsdGVkX18ar3qr/6o1WTPVr3tQ6wlNmlM4AUGwCbkNK1RfCB/oro8+5m+NQoL5dh694Xflx4JCudGTbRESpZgnDEEkGu93+1ABaIsGQCZQMURALr6kqME04xtJSd5u5LghbX1raH7kglHx6QbVhlqgxGF+xHZOu1wpnKYFBQhNKFQ+0swQNS0yPo65QuYC3iWbRA2FqSKq886gWRZhMY6pOWmYbahZw4EhqcHYmxNO/Fiss6+HFSmNAyBgw0v/i9jRQd/8/NLRKs122YO2hM/TSqGkzQUn8m+MxAUfl5RcNwAWlkCWlp2xXcZUX4tPk/g1bkT9ivIyFd1zI0vi5bl2a2Bs8aQR32zL0JV+J90+oT8xFRiudAiTKeQswp5aRPiHPaty3ObzRKEyRJtRj0QdEtpBg22qpCVp0j3ZCq4Wl0FD9UXG0YQ6a34URpxJN2XE9xXKIpBl2rO3l/AFJ3kmfxhvJLW9UZWI62czdf/iCg5aBdI5IjjAFf01GCYrgb/0evWln+/n+S5MvxUNO/gGjK0QD3a301JtPEvYZQdNghH+pcxonTrxRRqs0sFG1SqPMb33xk9dLfnrxEkSjusy2aEByD5eibg/VchEZd2ZlzbvM8B4aaotmMlpiotRp+8zX7oimLcoM206uK2tx/aSA2BvpbPixvjzxHJk0VsoOypv/2G+d/WpQJ2KhzPNaJH5eTwv1DD+jlK9Q83OqIfBHBFh4v4NNnr6rR0MWJwI3b2ezHjd6D4SeiaIppAESFMquMBoWm5SQTvvbyv2vbrr8X5Qrs//PXdUvbXRWYh9EIYVrH2IhXg3DWlIR8rIin7EM2V82/SrNrKQ9BSBexBuN3jBFcjkwX1APe+3we0/GdwEPNqNZ3ycervacyXUEI+fH+FwtEA/PMd6EJW6/WJvBgoO3J8MURaWCxAaqsarLyTQ9O0mfcEIV+9xfyjRQu7SLPGM5Mn2DTHCpvt
 OzuyHC/0
 hnrUnXsB1+ShsMuAxs1pO+7Rmk5qRFHaTHRYtm0MRw8W6oG7DxfPTtwJze6JfnDtiG3jG5WaKeO9pdm4L6ERH9/eBiS3P6KLRzZ+i7gQT5MNjnK840lB1tsm5daysbAEVua/eL+zxd5jVm4V6Fdid9Hn6Lh3xmU6VTXG46HK7Ul5gpNEexrQx2FqG8jsiiaFCf27/lVtZxQeqsARJS3IeHSxQCguVbCXs4niWk/MLWYNSYBTkvcNZKr3kWJHgzLVpqV+2bcCtRsUL5ZyVKAU6HGwY/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forgot saying this, sorry.  Please update the subject to not have a space
before ':', for consistency.


Thanks,
SJ

[...]

