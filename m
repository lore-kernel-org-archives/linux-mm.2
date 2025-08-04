Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2ADC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 18:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0EB6B00A7; Mon,  4 Aug 2025 14:28:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2883D6B00A8; Mon,  4 Aug 2025 14:28:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA196B00A9; Mon,  4 Aug 2025 14:28:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D29C6B00A7
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:28:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96A7681697
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:28:49 +0000 (UTC)
X-FDA: 83739911178.09.8587920
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf17.hostedemail.com (Postfix) with ESMTP id D165B40004
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:28:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of cmarinas@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754332128; a=rsa-sha256;
	cv=none;
	b=hHrpnpJG1z6XOKtn2m38vDeRERYdDo7R+xgdpmjkwD8jDJru5XGKLAy4A7wZ9s3cjZ987/
	dPkTvgu0jajqd86yYXvQfp7u09Oq3e4k7+N08tI5GdTSYpYUlGzoqDl5/ye2s0JpWw/kX+
	+FpfknWO3m0cY7iEDfK9p4xDiY/ARpQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of cmarinas@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754332128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dAN+Q6z4xYDkwzhyRANAgXGazj/lNfVPId+ttt9Jaos=;
	b=K92bmUc71j9vQSxCZ/u/PseQbVOwJh7a3bTq0g8ulR0h0m7y3g9nlcz4/shvCQlvxHpjBy
	INxi2zomsdiWXg19PdTuHZGVqHCzFnsHXqKWyfjPNptqGRepxsqnOhg/pZw7l7+m9l9mey
	K5fFNsnuW4o+46JkI0jKo5GMsRnO83Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id BA7515C629D;
	Mon,  4 Aug 2025 18:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AE3C4CEE7;
	Mon,  4 Aug 2025 18:28:44 +0000 (UTC)
Date: Mon, 4 Aug 2025 19:28:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Waiman Long <llong@redhat.com>, Gu Bowen <gubowen5@huawei.com>,
	stable@vger.kernel.org, linux-mm@kvack.org,
	Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH] mm: Fix possible deadlock in console_trylock_spinning
Message-ID: <aJD72syGyJs203Mw@arm.com>
References: <20250730094914.566582-1-gubowen5@huawei.com>
 <20250801153303.cee42dcfc94c63fb5026bba0@linux-foundation.org>
 <5ca375cd-4a20-4807-b897-68b289626550@redhat.com>
 <20250801205323.70c2fabe5f64d2fb7c64fd94@linux-foundation.org>
 <aJCir5Wh362XzLSx@arm.com>
 <o2gpvdtxqrdfrsbayorvzvjqcreb45puojpgfye7dimbuuvbdt@gxquukahrxo7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <o2gpvdtxqrdfrsbayorvzvjqcreb45puojpgfye7dimbuuvbdt@gxquukahrxo7>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D165B40004
X-Stat-Signature: d5qsr6auaxnb7m4mqisf5x1n7k3rfizj
X-HE-Tag: 1754332127-488484
X-HE-Meta: U2FsdGVkX18pfvlrbwzDeKNvS1AtaW0CUXxNAiMK3DouqXJ0oNDAbDgsBcvN72ztEXpGigOxcyZSgf/mYd4EwfC7f6mhXCCnAgsqn8w37YAv2oTz5+L/jTtEAgZCPjBqXOy2+tyJ9wsy6oyCtF6dK+SQNtlPbTjXJKIhh4+C8CJenG8VydYoDRadZ8AKxyp2N7GRJvl2cjTsIB0tIEH/Hdb/vZATJzdBBbN64ZAJxc/5gveNHDFfJal5n+FyDApWuMAP3ONNOYZDVXOICjO2yX8r3W40frqOh1omVrRFKT22ec6ggSjusw+cyY0VZ0HKz1VViGTfTQVCNfHDU16qO/PkRiBmmFnynOzska+Jmthl2m00A/NOLXiEewWyuKNh9wJutYUa/2IavHXZn9OzS81RZEfCJP1l4hBWTL6+VnUsrIYAIAhqdmqmLKpR14L5Up/AZZ0UJNFEf81bOdN5euBuJeOz8oKWZkONlzTp4H+ZvpZU7i3l+XlDVICusw7sSAHXcobJduCfp9Ir9GxAF6TgBtV0bYy4rUwuGI8WbwjWEKNLLrHVwKgOaLXEEKBZvGUZdzAjt0sziHc2fpdSNzMLuFG62TAoiEE2dMBF7XplUqaiAz/ORNZbATH67+CNHD6So3Pqb/NWtQMBFVZawVxUoXhjKlgH/FDEvmcn4c7XUrxw1ud64AJ8mquvtlGz21AQUsIT50Jh0V/3ZChLVukOv+UF0QCIp5VdGKiCG3kjqZxgsaxa604mVG0ot+ExzqQinAJPRaMq+nlzC9K/fB07/Zb+ZwxUKkvNvy7NSN0I0/0FRI1l91MRjXzQKuY3+wlX7lFwAzhF2yGDv8B70rrzuDlsHbOvU7n6t9qjGFpPhS6N4k5B3TgkVXOusKBOk2voAnxA7PgwmHPNjGNN0+25mM0WB3ip3k19GVxRAVgrOJrwumXD/ZxpaLkfAVGrZVw5k0M0evDDvtKfnGi
 WsWEsHuJ
 tqd3CiNiUpsStQhGAOFC3nCa80yRdhz44/iZ6teO1EYa/ywH5P335iYc14r6wMY0+M/Vc0eN++YAe4U1BbjXtSM/e/xoX0EM849PScEFQWHrMi0Y8pTB8xZPP03FzOwEwZHJmwPgVmRSZRRGpNsMdItBTR+rGa4Z9WwCjCcmKuMyCYtLxQyWWP/Sa4XkyxD+PbDthvQHkW2T77JVSkELev03IjoCJ3zdqzYnASfK3U3V794G8xWdgF2wpY1pioXmuxx7o5idTb3mOOJtl9RzqYKZiAWOZupzP6WG6EEck2M0FDQdQgkg4rGRoxtODxcyO1zfgsCrs61CnmZLl3xtFvpOnUT+jMjfa/VAJFg7wnUNzBfaPoYhl3DrW2dax9Vdwhs2cJd2pXs8iqfg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 05:34:10AM -0700, Breno Leitao wrote:
> On Mon, Aug 04, 2025 at 01:08:15PM +0100, Catalin Marinas wrote:
> 
> > I'm surprised we haven't seen these until recently. Has printk always
> > allocated memory?
> 
> I can talk about netconsole, and the answer is yes!
> 
> weird enought, lockdep never picked this issue, and I have a few set of
> hosts running kmemleak and lockdep for a while.
> 
> This time was different because I have decided to invstiage the code,
> and found the deadlock. Still, no lockdep complain at all.

I guess it's because kmemleak is quiet in general, unless problems are
found, and lockdep never registered this combination - printk() called
with the kmemleak_lock held.

Thanks for investigating.

-- 
Catalin

