Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C47606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WsaSxFIM
Received: by kanga.kvack.org (Postfix)
	id AAD196B05B0; Mon, 23 Nov 2026 05:37:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E086B05B1; Mon, 23 Nov 2026 05:37:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9743E6B05B2; Mon, 23 Nov 2026 05:37:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 740F26B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:37:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA17BC0869
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:37:41 +0000 (UTC)
X-FDA: 85466032722.07.35556F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5B343100007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:37:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WsaSxFIM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795430260;
	b=iJIsZRxVPnBbIHv/p4r7dlOE7wvAMOB1YQp9aP1LvZ6y36cHfLP52i0tqMQ723VcTRDIzj
	PM5LpBF3BNl9dJMefsvMdoRisOSyoae5EF6sdVSvxnQ6ZL1P+XAI9Ely8D1urZfhmu7GzJ
	je9LNysLKPSAH+F5kPggwamcMLT8AWc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795430260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwYlBRWdZ3gFwsHepnNOkOBTBycCVdR7tH8mv3xZmo4=;
	b=FuSsu66gkQvPRd+xaIhvZIvvTpONZLfLKsoOj/V0AcXwAQujiZm/60K89lmjUCNpx4bcH/
	HhGaWfe4SiAKfKjGLbSudTMttSWNO//MZ4hzrH2kdndx9dScFvUjNddlSTkZ7HI431cgEU
	YzFzsmcY3D0625pyj6l26c73Pmsfp7A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WsaSxFIM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B45D43F82;
	Mon, 23 Nov 2026 10:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA7C1F000CF;
	Mon, 23 Nov 2026 10:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795430259;
	bh=mwYlBRWdZ3gFwsHepnNOkOBTBycCVdR7tH8mv3xZmo4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WsaSxFIMuIykh52LUipSEAH1TwSfSoxQ+xJxDgTKEj0yNFSvtHUaBADnVCWu9bhen
	 8VCQKJnyLAVhvLsc+XbeS/LFNWNyBPZdZNMUjCCEVQyBnp9wzxj6hvLUdzVXGA94Ey
	 fcAYs5f7A4zTcAYSDwR4tMj6JNVu340DwTrPN5yqJmxBe1rzVjurEQSp1ZmTTrxKGw
	 5bw5BRrSzo05JVuuH7vW75PBkJlWAVxSJkEH7xTxCXca3ZODd7eyyPRdRV6t2BzUKM
	 G2mmxjYYiQnYEjE7Eo6AjJxmndU9WisRyYS1UJxkRE73Oo7PEH4lUjWH+mX+WU3yWs
	 kMDMtBHJNtXjw==
Date: Mon, 23 Nov 2026 00:37:38 -1000
Message-ID: <80074feae68df690b254531b3768d096@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Kurt Lin <lylin1023@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: cgroup: fall back to an unlinked file without O_TMPFILE
In-Reply-To: <20261105011824.1143947-1-sashal@kernel.org>
References: <20261105011824.1143947-1-sashal@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5B343100007
X-Rspam-User:
X-Stat-Signature: ic8qf4xc9zfyx5bfzmgc9qywp5hd91ot
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795430260-212419
X-HE-Meta: U2FsdGVkX189IRmk2Ql1HD6JSZvnL3fcjqFYakA3OVWnUUOYjM9NgkpcmnXAYgV/HJEoNTYkbfXjy/M+FNlaWUyDp4/c2igWxliFW/v2ID4EqT5omCzMUu6ddZwKm5DYqF37cqRIslx4JAXXp6vr37mf+X5pOSoswU5qE6QgP0ect8YgFu9jVqlX/n5o4WEbAugIzS1iLc9++iJItFrdVLa2l9GSsbg3JMG0tHl9/1pPpU2gqApYm3x/ICIgjOsmVUm4PCYF9cSS3IihV457ioS8dFm4pxzqq3qyp1QeNBneSEY4XLQ+XUmIC71wz1GRsITZ5m8kzsz6qpdaHO0isk/fIIgwPDUsxil+goJsrrYyTbNqeht0spTjBnU2aNEiagCI0T1MlpuL5f8tQJWXGmOMJpavwnY+3SL3rRYlOVKn7BfQeWZnBOeVXfC3lFLFJjX8dhqgYvSxZ8UJhMTNB1SSwTHiBwJ1Hcwj4suT6T3McOQKWS6Su1hJeh6WLSi/q7TJTHFisa9oCg75mkbaaSq/82+dulfwyycvjq4ilG4v69HkAeXy4SbF8wF7Z0GGtxyhb97vHOSjHQmOem3bxe6EBzYJ/EKoBKdZ+O/z4Y96D9ktMz5bBZSp1hrEDMiQiCqT5x4hyW1bCCn/GiUdN4B4LNT6oFXyvrvek2FuOOAY3eF02GXaRo37LPvJ9FkMhCfBNSx0UKJKHbNhTgMSvHthK1Dny5GdVeFnUT3Ni6iodViijjBCscKUUV6hdJW3sgDSd8g9EdPk4hy5oMuAr/K8+PkDaFnBnIAMfCp2JqfvGKr0yYZcVg5axcaaxNAF9Efoe7Pl6clBT9hweFd2JM65xKWl87fw8fSBOoKe0oL7aAjWC1ubJ6hfN6A6ZUNzTg4LAgm7NspBNDx84jQWu9b1UxpRpOpUxZCL8hJQFkmllKeHCgOSJ6zu8bJNdSyToqQo8SwHSaSqs428P/k
 P67Rn05q
 PDaJgYy8QVTIXPK6mjYjSpm4FxcaoX8XxmqMKDK8UyoORaVCgvQ70Sha1eGSuo0ChDPyzUp+NIu3Ol20bt8Tks+HIxEbY8EzL22hBu6Q9kz+pR4+gpsvewXAf3fO+g1EyztNhOTKiio2RSrK2Kadw66sRfGLofMWM6tQlY0p8gE4aBhB8QX+KPQfGqz54tBuUlWl/qMjnYp1n/hB60kn4H95XzxHZIWcCtpAtBryQqkdbhP8lOLNAWNR24bT6yTRznwu5w03qiKsPWpfhFEmji/AQV//FDmhh2Ue7hlegjROBQUGxdfqh3tgfgk9h8IdkJEePh9dzRRIUc+mDcYT9jQ7mVcO8XZ3xdJ5VIWrdtPoMtGkjv8bya8ltE7g15gqlr26q775Csc6zVsGAzVLvxIX7vxGycD7TVLd4kVNytGiNHF+fG9aUAHr6cFYVoCEm4lR/j0h3siNhlTBNGyl/DQWkLJUYXhplQPRt4IeH/QvpyLrTKs3w3rmNfePDbr8Ql1Ru3HnO2E7HAlsD0Z2KYyDk+IHHeFS16/CC8NAIG38BIFclitmQZgXEGneC8OE+FdAlO33bdf/YBvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Applied to cgroup/for-7.5 with the Fixes tag dropped and the following tag
added:

  Tested-by: Kurt Lin <lylin1023@gmail.com>

Thanks.

--
tejun

