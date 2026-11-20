Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFFB160A2601
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 14:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eyxudgy/
Received: by kanga.kvack.org (Postfix)
	id DABE76B05B9; Fri, 20 Nov 2026 09:19:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D35F26B05BA; Fri, 20 Nov 2026 09:19:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC8F6B05BB; Fri, 20 Nov 2026 09:19:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97C9B6B05B9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:19:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15DEC160F5A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:19:02 +0000 (UTC)
X-FDA: 85455704124.14.F5325F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 125CD14000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:18:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eyxudgy/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of mason@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mason@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795184340;
	b=Ew+FB8PpSjj/s1LY8xAJU/p/JRsJt7zeUViDnrDh6LGQJGZODsowf0xDF29wvQuwtrt4kd
	RXJK6zCTm265iXLlIs1qj0o93/45cGKB+PYhp/5KbblSYUFObfTBDnP1Y6PIyOl3yZ12vz
	PWGGC3Pywcb/KyvsT6ur8aLlhjJK/uM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795184340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Poxg2dNbemwElRcsc+guVsxtMBqsLvr4KASlDji/qhA=;
	b=F52h1Lhn6ZrKzKwHqKgp502Rl+qNsHj9vIGksT690urg3WYJB+79DdhH0d3aGUM6DSsdmC
	oJ+a3L3dppYARS01wiDT8JzdtTYeyXDjzQMDuaGgnGSqSr6J9XKYZgFzE+rYo53g7UKttR
	cC1T5CttgRrmOJCCiu6cA0yVadMy+aA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eyxudgy/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of mason@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mason@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8560060D2E;
	Fri, 20 Nov 2026 14:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDE31F000C0;
	Fri, 20 Nov 2026 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795184339;
	bh=Poxg2dNbemwElRcsc+guVsxtMBqsLvr4KASlDji/qhA=;
	h=Date:From:To:In-Reply-To:References:Subject;
	b=eyxudgy/ysxAxceFz08zE9ZACdlUIM0IcgM9abKuScKy5uOHeOQZT0lNHv2jJt8Ji
	 Hv54sfK6qRH3gcuiQsaumghSz2gOf93CVjrsgWRyWHPSNYs9WSeBt1dUY/dSsSG8f7
	 WvfgTfLmTpA4VGly7ikTYCenKbDAwo4qSAR2cag5nejcqebNPcqajsWE3tadia0vUe
	 dum6SUuCQ1quW2XCznFuKqS5LKorVpBwIMrSGOOu1j1hKRTSLspN3WZr+ZoQ0/SF7h
	 xFcPF5U15vMsIiKXIYk8jQ4vp97/rBLrqtEQoq2J3jYVs0Ez789qHq3CqcqaocNr1V
	 0/qdoZKVgy0Gw==
Received: from stl-compute-04.internal (stl-compute-04.internal [10.204.2.64])
	by mailfauth.stl.internal (Postfix) with ESMTP id 4BE02780043;
	Fri, 20 Nov 2026 09:18:58 -0500 (EST)
Received: from stl-imap-13 ([10.204.2.104])
  by stl-compute-04.internal (MEProxy); Fri, 20 Nov 2026 09:18:58 -0500
X-ME-Sender: <xms:0lYAa4ppQNax-ArNYzUaNZHVtgUynizfacRSV57TTTwtgLhW83nvAw>
    <xme:0lYAa5e_Beu9aquxb4vOnz4uefx9HGYa1Bi0T0FOuBYWMFa9_GldpITLZLWhAdhuj
    wuZMpob_H7SQZJ5DsxEkseUytWHRh81bbE7082jAt9KtTq_a6yb5aBoLQ>
X-ME-Proxy-Cause: dmFkZTEeNAq2VSLuDQSYZotlHslwllWV7LHuGQ/5EUABTj8EU+g5+PrSj1ZaDR2kW/6YAG
    zhJpGaW4tT3gK822JMUF2RTr06ElN2rBOAUuPHyxRwWbV0ADtqRKuW7MLvtKp6spEW6y3z
    8HV0YllRGmwGxcWyFcRVaZ0/Stu1RBfgqTsw4RBKMA0O3WU6TGLQYotH9fVJHrVs/Z06k2
    GfJ9o6g6WvjeR092GV6wJyGrTZ5kgSkOstM6usRXDFuDA3D4j8uXYZ/crAKQVlml0JYHsP
    aegxX9ZjB4NGrWkbFXRaaNjGgEC6IFBvtO3w2frpMZFF3K7gWV6xhcyem9ZRY4fNQqQ8hS
    xgy1JnEZ3ajW+NbL5QOlNXcQ/U2za+1mdlOmK6nsG6Iq74tJUQvmFX7pgHmn0IoP17Kqj6
    ivQugkyA+B01Z1XcYjLKLhrgjIK5mlyxWM8uXZB6OC6Ghb0n43k0V7WfxcPmHO15HHHtFS
    qHwDaYsuHWCdju6xn0ZAHlzrHY/yTC+sj2qH+FrNwTDp3hpjmK/heevBtcYS2Q9mJSMCPP
    5h0YaCEFdDDOFlpQiTPg76plMZD2qJ6u+HqYp+56FxZwoG7F6LfsdQ32CYFFBv+rykgViK
    ewWUU4lQrwwTrSbIR+RB6+9WmfDJG5EhD8kf6HcCs75Q0dz/2nUBeK2PLF9w
X-ME-Proxy: <xmx:0lYAa3LJE_1_1kYG8TDQno0mKYKRkVrHnUYHDTQwWk1NngWa1GHqJQ>
    <xmx:0lYAa3sYTZGd2V7vxofmmf3aLiH7Du-85z1VrW8eB2T6BNfLl9-Ksw>
    <xmx:0lYAa0In3NAuo8j-6LNDdfdRUR7ZIhVh-Wm3GQImQduWlh3YcSqMEg>
    <xmx:0lYAa3MET1bljaf9K9oufBRWoT3gSj0POAnJS0U8N-mvIBb0CODRwA>
    <xmx:0lYAa_UOxu1-G_5SgV6lNFg8P7tVpi1waBzTBnQ-YWD7LSFsFfQrjfqs>
Feedback-ID: iccae4b50:Fastmail
Received: by mailuser.stl.internal (Postfix, from userid 501)
	id E848FF60084; Fri, 20 Nov 2026 09:18:57 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AtZKXeeMT6c-
Date: Fri, 20 Nov 2026 09:18:37 -0500
From: "Chris Mason" <mason@kernel.org>
To: "Qi Zheng" <qi.zheng@linux.dev>, "Hugh Dickins" <hughd@google.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, qinyuntan@linux.alibaba.com,
 "Shakeel Butt" <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-Id: <9b68fb81-c2ea-40ca-bc23-ae3d1a2e56f0@app.fastmail.com>
In-Reply-To: <73a452ad-4346-4f77-a2f6-4c801562c050@linux.dev>
References: <20261119193656.88678-1-mason@kernel.org>
 <20261119193656.88678-2-mason@kernel.org>
 <73a452ad-4346-4f77-a2f6-4c801562c050@linux.dev>
Subject: Re: [PATCH 1/1] mm/shmem: don't use the memcg of an uncharged folio
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 125CD14000B
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 9jrgzctf3scm3qbbm1uygnozbkytsbxj
X-Rspam-User:
X-HE-Tag: 1795184339-126374
X-HE-Meta: U2FsdGVkX19ZdDam/6y3lxKRhR3a8wLQoIC3PnUvNTHxS9zSuh4CkMQhGV8YbLO4CqAL6J1UPIEb95FixCl5LfO5iwp0EVUwGdn87TMkGOEcY4t0aZ0IB1ufSgkJnwGmKEJxrokXSaEbakMfwAJqSm9Aruh4PzjoL+RMsiK9ctv3p21qrUWxJObgBdIx0HPN4ipnCXXDQDz5ennf7J+E42prbSbdkaKvR2Zr7+G6GdtIdYgbBrQHR3u/HdSntooT5BrCGv+zwbdnGnI+jlCLZQRyArjNBQvqChfEd2tN1vMAT99fLBReRKFcAUi/ElEyTp1iargTe1PoABhGtP9LPBzT3De1u3XXlemMqYiGflbz+4i1OE6Qej3/GHMRu5aZx8MVwg90pojt9fHbpzVHpKBWnnTxZ//n3G57J9CeIKqkxWBgKi32iDsR3KMpTgENHTWTsBf1YTsOLP3ZNSFY6h1zGToO6afWCGUtgysHOpDvVdcydG8sJ93iVv1l6t9vNmhtMQVi8WTVYHVXP6e3kMy+VcY+Vz4gUAL9kdY+AM2znz8Mzoxpwm4ImqdEwgrXQhoNiJ8CsCB5avw5uuN14FpxL7av5F0ncItKfaQn8OFHhEb4xRKu5iObhcAa8B6zod/n0tXn4pLku43z4Lc3Kds/B9PaZb1qHEYduetb4nNR4mP/BIILQHs2NOFNFBO+fkUnhKbQ0IhA2oJgsL45xkSCHn2dMIfmWRsEZ81ueN8RyHqVhpO3hJQDn8hwxd0pzKxdzJtXadu8UsaP63GxbuEh15cHFeH1m/Qax9jJCKVBww5XfydG3JSUE5P5w+BbpXM8TQ1vYQLtOTV1MTj0zdkTLO6U6slS+ScC46cLJtKClKDSZi85t0ehr/r9tmruArDRb3mB4kfyZ65KdI81R51WDK5zodKlEguhUdgQ2LuGT7aA1KUzpVHb4vHtNV7vxWWOSwjuqYJWc1Jl3XC
 r4nXz+bt
 A/iUae4jh5ublAvFnUqCDita2WuofA9ODwpLr6nvHF8L56rXA3WLuEnLbcCgNwaW7Gxfr52yWYOE8sdEDcwDweSS+a1LHn3MhV2P25jQti6QSA97AZp6Ff35VTlRyCwhjh9KRuguCdGjT1Xfx+EnkWpG9V3z/opzihv45PC7lfVmZ4xahf7lT4ksgQafdUEfuPwZwpqrQ5R00JB+jGj58Kmqn13F8saD1Slmhp8g+/SNx4fQecj8YL4H/Q6I3P4+ySyM79hGLvqG5MeHE2FuDfiBHCUQx/LdAdUD33GqjolSmfyTQPEKwPow+lvd1DPCW5juEvQ5IpMQy/Kd6pw5gWNDv2YHF3OStD8iA/EtzOQa8zVD+8XX+a8EOEqZK23xi0p/ft42+ZCDb3bjKfDN18D9+WEVUKiEV91f8Otw6clH+aa0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026, at 2:10 AM, Qi Zheng wrote:

> Some nits below.

[ .. ]

These look good and test well, I'll spin a v2 with them included.  Thanks!

-chris

