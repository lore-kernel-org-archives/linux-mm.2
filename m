Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB91A60A261F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IRTz4jQD
Received: by kanga.kvack.org (Postfix)
	id D10146B00EF; Mon,  2 Nov 2026 03:31:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A2C6B05B1; Mon,  2 Nov 2026 03:31:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAF996B05B2; Mon,  2 Nov 2026 03:31:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 944F56B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:31:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 94DD81C46BA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:31:42 +0000 (UTC)
X-FDA: 85389510444.30.A6B812B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 00FC94000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:31:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IRTz4jQD;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793608301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asm5I+sfPUttfOOUyQuRrhybkytQ2qy7ADtMO6u5DAs=;
	b=de0aFVgSJsyff7cxEUfwJmKEJl4dVGdlo26jEZWUAdlyjM9YDBnFgjf8vq609xlMQe6EXf
	aGJngM8fgpLrLV9SAnqIWRlscz8iBtH9oO0le1GdVktlXzWOfy0n+Er2X5mBMrbkHrPrXd
	0Z3eqX8bl4iLuBjOmcrlYlT0U9+cVKI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IRTz4jQD;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793608301;
	b=j1LBkqWtzXU/DPwAA8EIVs965w5EPTbw+R3JiNVUb3zKtNyPJVpKvbH5KDGigARJ0RrSKx
	8uQf7YwrLyXYYCp+pdZnaAgKTXh/yMisJKhG0hGGFX32Mc7535g6stLG2XoVPz30Au3pxf
	AN4XKBDYZJV5q1HaU+QK2pC1ECTpmNI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9117260EFF;
	Mon,  2 Nov 2026 08:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042751F00A28;
	Mon,  2 Nov 2026 08:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793608299;
	bh=asm5I+sfPUttfOOUyQuRrhybkytQ2qy7ADtMO6u5DAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRTz4jQD/g0vyTmXW8SgFr+mx2ZMxV5elbfqiHfFRZQfX8da2mZqhqa71iVNqCvEU
	 wjQIGqvEBd3LBBZJMgF+UQ6ob6MZszSR8m9vL7BO9K77pBiLA9+P1AM/HvSyMuBcNP
	 3GnoKsow3INw/q60rMIZBEmSsd7YqyyK3K8IqDiUYWQs/EzsNBCbgtqNjxNytcZS01
	 aCdxmUEGudKc0mw7MZGgs+6hVdMwm9Lpj8nl4pVhOLzsaZGmqZU5ioDgVdS8PfC/5p
	 f/3hck1mR/buPNLy/IZO3SEY9Nmba7npSH01XgWfjBFX2SjSPkNFljWDiUNfPFe7uC
	 WjjmxeDf3tZmg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH] arch_numa: remove redundant nodes_empty() check in numa_init()
Date: Mon,  2 Nov 2026 10:31:26 +0200
Message-ID: <179360819349.1332963.9866845658836946677.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261016143557.307080-1-ekffu200098@gmail.com>
References: <20261016143557.307080-1-ekffu200098@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 00FC94000A
X-Stat-Signature: j1oxgr4iy7fa7ipcka481f8b1bry8zib
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793608300-933703
X-HE-Meta: U2FsdGVkX1+D2RZOpKjzYqqG7X+OdPqOari8mYFVaobh23ZoH8m8wblCBPz50rgV/ru1LWnkJ3HpLnLFX6mTWBDQVrTG/QDBmXenRJmqOKzh04ESQ4hBQki3h1nmaygSDzcLrbpVZR/O0nselsmNeU4FP0El5u3xXo1Qq6sbpWGyNJyloRdMtmsEVSanES3Yb//iu7Qzge+lEZvE/ulGWlVRSawi1ODzDaUnmOnIS58xFsgFwuMA1Y7bmCj5tY2UVafHwFkQowB6yAdAVMPUtZoSp3xNxxnOikjlyoOHVEE+FW/96RsM91CH3j76VG3rTxfe1jEAnl6eMLgW1rSYswQalrrcdHXcwf9OKJ5xePoXr0uReX0KvGNjQXh3VvawX1LgXH/7bREqkI5McTCsdLeevsdbCHefu4QES7o7KRy66YLMkGn/8Vxbv6DP6bFb8za1MlwltBkkxot1p+AiZxUVXQUPy64u9/YO5yIlFSlNM7JADDLBiG1inY8qe9jXAo0xKShxx7Mt4aSKMmj/eWIZta9IcYNOL3VT8ltylUQd8khzaL8qhxFLD7KpaATXo6eB3DlZX2GYrov0cKt93Tla81xCbOGgWS4bRXCf3e9DPbcws+pMLvg+tOTYQIjxVmazpVwjyi+qOwqT3vSZfJasIWFK45/g0llh3RE62UOmv8lrlBDZTJtbz4n5irnAzm/LDMg+8wSa1PslEnSYcq+nlGMzGkATfUriytR2LAHn5cJOykvFGHNXvOQmk27AqG8rIfxKz91KOmh9qFgnoPPqJhHjr2sP8siEiceI/h9kU5yhZJ0MDz5B8n37Qi+y4J7izqs/wtSbwB7sBWOHfrBmkTMxDJ3R+3gIONbm9rhi1roDDDXq1bFVSjWJ15KrPobZsXgQWHavHEXAG2fUZi/9BQ4e4B9lYIlm5TUTjXTaYkLnYByyZudOUa7m5yeeCToHyPS4liaV1zGqQBk
 Yb4DDK1/
 Q221QSJD6nZhSE3ZN9rh/6p6RoG7GNAe6M1xCWBiymKEoQS+svcM6UjiFcMwT+YDHfCAZipVXwcmMePTvtrpFBIkUJGpVAXW7LQI+E1XmsZWWTi4GKIvS0lg9s/43sT1pr25D/LD6xEz5SUuVTDJ/HtktVMYp/1oVkA7TQtf7UPh9Odo38fImHqLhfIphfDfYTcXKo2o0TGbh62ZW7yfAmi8fpUg/pS1s7gpkOJss+3Enz6wm4Bg75rrxcTrtUKMmxHVByKNIK1aw2HGBGyjNwxDaztq3iSCJ3Vrb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 16 Oct 2026 23:35:56 +0900, Sang-Heon Jeon wrote:
> numa_memblks_init() returns 0 only if numa_nodes_parsed is not empty,
> so the nodes_empty() check after the call in numa_init() is always
> false.
> 
> So remove the check.
> 
> No functional change.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/1] arch_numa: remove redundant nodes_empty() check in numa_init()
      commit: 03de248a2039eda42d9cff7e6bd1cf23acdf98d6

tree: https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock
branch: for-next

--
Sincerely yours,
Mike.


