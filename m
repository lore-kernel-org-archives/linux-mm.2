Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87CBAC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 00:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10BF6B008A; Fri,  4 Sep 2026 20:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8706B008C; Fri,  4 Sep 2026 20:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6E36B0092; Fri,  4 Sep 2026 20:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 750396B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 20:33:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0FA77A0220
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 00:33:59 +0000 (UTC)
X-FDA: 85177836198.18.17C97CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 845FC80002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 00:33:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuLAAjU1;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788568437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqZyjY0gACNKMPWrtd+e3HjlFJmM3ZqUfgqKWgfrELw=;
	b=I7671T8c7CnVmIpBhO25PwQbmKAakPWC4TA86701Pp6dTbNRCQtAJDns9JtWMFC6hlfhtv
	+WKEUG4KTolL2sXkWp7PDns9XAzaJ6XHeqMsoY30cRpJ+P1ioxC2elEHhDC48CM26d/D51
	fTR754sC7J02Hm9QLDvxBqrbykx5bnk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuLAAjU1;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788568437;
	b=tm1u1cWC/jd3nsFVSOPc8wiOW/6xb1tHipmiLX/rrQCE0bXf1s6gIASY7jwqXrhm5cQNgC
	mIigC+L3tRVGyCtZEFpzgLS7l7bOgdTR++NFCnOmqvpcxmJ8lsNUI2Og6HrQJIks+odL63
	QWjy8vIr+ka/kfpyIe/I4KcIeq6QSxI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0144C600C8;
	Sat,  5 Sep 2026 00:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634D81F00A3D;
	Sat,  5 Sep 2026 00:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788568436;
	bh=lqZyjY0gACNKMPWrtd+e3HjlFJmM3ZqUfgqKWgfrELw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuLAAjU1Zr15XoZgzochh9RKcgfbGmjnrD2DgRFc4BVfns4TsfrUYVA0QSol+DLIq
	 vZgM5+D7jNNgnldrfBhpm/LZk1lzR6Z+v03OegylJ5435xcPJYhwWF/eesHVzTFWLz
	 U9//6J/I+YA8mm7joFutE8d2t+klB2dkfvPHJEXTqyj3/VYjH7M8kt1jVcucqg4DFe
	 5kNyZwCb1x+v1T4V4o5bcGnhZWc/f0t3YyGiWK0/jtbHmAIEeizYME8IdJjWjIThOl
	 887CypAmZr2JxTbJdOkPbCxAuWYW3hdgXEnVp+KsxdhDfHB96qmlVV46sAQDbT1vQH
	 yAQB753xtbK/A==
From: SJ Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ye Liu <liuye@kylinos.cn>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] mm/ksm: convert process iterator to for_each_process_rcu
Date: Fri,  4 Sep 2026 17:33:49 -0700
Message-ID: <20260905003349.68193-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904083001.553587-4-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m4oysj595cz1f4ecctaashhsxy66xr83
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 845FC80002
X-Rspam-User: 
X-HE-Tag: 1788568437-636485
X-HE-Meta: U2FsdGVkX18eA/Q9JqWScqR/4HsWpxYmPWKfAreb4u5Hd2ZN/4zijM4HPoY6Vf2jzwikEApOK1eRhd90ssFKF6QW5zVvEY8UIlLOyN9w0NDae9dEgr5WCmgDK+3Udq+GoLuOB+wAL0ll/FvQKCLY7WMw2JPNcqJuLQQ03D1DI8Ed0h9tg03zdRctTHUmVaNkUUY0tw5IbaRkt7S+cI6mj6OJK/YG57AJwWb+r+wpFm3s1Sn6Hvc9MuWbbwq99ZI/3HMYTQH5/+pLELMUwH8uncOGs9Tgh1KE1wnLH83b3N7LLQeU2w4D4G+z+m+NCWKuA7YLMCItHFTQOMIsP6OIKRuTvUbRCCWsMuadxIsiXrwNBjOnn7FnVHR+trqYz4VLSHYJ8pPIQpYTns3fiDgewG6Slh0IjaGOSTl+BeXjfQPMxzdNudhRnhe2rawLFMhDpHUycn6EtYSvJmY91nkZeb4PYiE/3DsJova62aJxBPie8v857IRd4JF3PtJ9jfD3h4ylhXDldEIzJbLVUP3B8a68YsuQMHAv9rEifFbK/MdK1N60fYrQBTf5hhjm2WWvt5Y6ISAb1QVcTyGS2Zbi3uGOWNmf3w1d42yr5Mawn44elmyHuOX3gUqMfhjlU7jLxLgjMy4N3zBjnzFHky8xypQukO4wWJD0zaL8N+wJYUgwfeuzVFp+H+4QD/OKx85LSGdMfMotwnJQCdkv4UsSIVWHDmEjSSFEPnmcRPJ0X0chjO13rcQaaFAFphgPhBnXHjzpgjGbVX4NVVALcp+GcfcZ2vcwsvwl3Im9+yhtCDafRoKlF9IRzjsBlml/cAurvwnxkwudv84/3agrRoSrTOVBlGs79qf9D0Aj3f65bnd9L6BV6Nrftr5Ov3rqu2YRNGDvIsJQOeS+zSZqAr8IHibaokJKL+PRM0grySbp0K/EnFvkhgBrcqKaCtFJ5C8Oq+0TxWIqJTe0ZGDzUQG
 yq40SQDG
 8mHIPaRSPsZyOlMHs8DKjng6rGYuH0Hocsu8gtt/pI6Gv7tOIToUMobdCSZblm1GtoSqEGLZX7hSTcRQ4TLj+rUjYWljZc8dn1yrHdePyegUBwbxK3p5DhIh58lTMQERscoaBJJufJuts8Ko4kn/4L1yo06Spa1odzl4f2NApmHmHaXLYQtudScj4hr7NJqyTdiCf8bYrzpYCSp4UOhm6bvNpfCQ1RnUBwEuW4xeSXg8znbRn85BcVy6mSX2fVegMOiAHEv+GkFJC4T3fTkiEGn7vdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 16:29:55 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
> with for_each_process() loop in mm/ksm.c with for_each_process_rcu().
> 
> No functional change.

Looks clean to me, thank you.

> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

