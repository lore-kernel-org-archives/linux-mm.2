Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94BDB606A331
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 23:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yj8E0Mt2
Received: by kanga.kvack.org (Postfix)
	id B576A6B0109; Mon, 19 Oct 2026 19:16:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08546B010A; Mon, 19 Oct 2026 19:16:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44936B010C; Mon, 19 Oct 2026 19:16:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82AD96B0109
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:16:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D1951A0791
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:16:14 +0000 (UTC)
X-FDA: 85340936268.01.C759BE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 92E8D40003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:16:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yj8E0Mt2;
	spf=pass (imf27.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792451772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=oWXp8S6+lnKG9OXZefu0eIGH6M8O+T3jLj5fDgMXlD4=;
	b=AHCgCd98UruWC/oI3jVKvYySOp8qbV/MM5K5TqIPJ8yfZbsavufk+BWn3Ij8WgPKMbUmwo
	Nl/9f2N9ELNlRJIMSmGmg9QCY749DOj+30z1ELyJuTgVgohOnE1myHrX7zapXRw/g9dAzA
	0mOUpbMgdI7XAJuevR23v/rQhCKS7CQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792451772;
	b=bFSwCv4wK8SgKyHluuRr//N+OZRT7NrAwmc9BWx66fzghCc6+sHgdgHv2lOv5eKfCHGafR
	O7TE6nHGQ7TcKVfgd6FCXx6WOvRQhPXoejGxLt17NTBvhzv4x68eyZ0nT+55kkn0r91RSm
	cY8D+cOF+74/n/eSoBZa5qJ9wAJA3Ys=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yj8E0Mt2;
	spf=pass (imf27.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C3AF644802;
	Mon, 19 Oct 2026 23:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7365F1F000C8;
	Mon, 19 Oct 2026 23:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792451771;
	bh=oWXp8S6+lnKG9OXZefu0eIGH6M8O+T3jLj5fDgMXlD4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Yj8E0Mt26r1hlorHXSU7tIS3zEuH6CJ2trD9UNv0d7P89ZdHP8HSCUejkaiS1sXdW
	 MWLlFUlif73r1EH1IC7pGUNthKqupAy/YM13xhfLdavHqsdbemvhUU8DO4KCImK4GK
	 PnyNAQh6sknDfiiBIdpLYOSJOCzWkJpIvvZkZvt669vs6DrdmBHagHl59jfF+Y/VPE
	 7nFiN3O4KU16R+RWep+MX1ErOP0F4aneaB2Qk4JoFN1SqFURD3w03/Aw/uodp3oMWq
	 hfVp3xtFGMKalcSrOnUJFpwMH9Ye1oDjKs6CatsPqr7Ranx1P73oIzny/IWpXNdUBM
	 nReOVvd5asnbg==
Date: Mon, 19 Oct 2026 13:16:10 -1000
Message-ID: <cf56648504bd10e4024dfd72d29d01c4@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, longman@redhat.com, ridong.chen@linux.dev,
	hannes@cmpxchg.org, mkoutny@suse.com, akpm@linux-foundation.org,
	mgorman@suse.de, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v2] cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
In-Reply-To: <20261019162138.3271947-1-gourry@gourry.net>
References: <20261019162138.3271947-1-gourry@gourry.net>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 92E8D40003
X-Stat-Signature: s1ugbyteuss9iba31w8c8763s8gaw3b1
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792451772-457102
X-HE-Meta: U2FsdGVkX1+Wvy4EaqT3JJnI8XFmoj73GgbMRhJkBhHKrfg9KKq9yzDY30gZ/Ad5Ti0KwI8tgpTPBLdNazEPq6slP1uOdNQ4bCkEKNaKq7Z9n40B4YhhlyuDUt7AIpm40LWxotzQ2dcljXY7ohuCUvGmUFFBQvjsRa/gtce7fUG2zp115yDMGr6b9Fnc+2ySwmHZHWFat4B4Qrx1Cm/BS0krGNKOw5h9DW3XgkkVjs952kZjt2xNHeLse7wPOUmoY/S2A3KzYgh0QF5WATNd4Mo4V7+s9G5llURnVwV4zWjeu760FcD0sKUUsGFrkIaAhgnoC6iYjRDeAkAVcvEHZuAd3CiDYlFTk/y8sqQRQYQh5bEXJwOhtADH4ywQNdoPwXfjskIlL2GV337YJCIPDLW6gOLvU6dHesEuNbEthhUJN5GIciVIkbljNkxljTd3qBzpG+kCTISnOcd8mwhIUt6V05SHqn37hWQTITH/N07YHlhjEUXbKZaepMNBIKMGDmnTHvnJAALot9Ud9Fga9h9HpPnawOQMEv+Nfd8b9LAnEXgf9WshhfK3kQs9t4KimS8X192nEBqgBJKTP8sxo4n9DqUTYgC2HtOWn1q9W3ESyph55yRQuX/mqxPJMxdlrV9yAlYLk+8NCmzWTTmamZwww4nLxCi9tZtxzaRse5kMf5O7yQdc6mhZxFQejdd6LU8VmsKTQJzeHBBpGyL2OHNsTpbodcZSzZZq4r55JWlJJTGYgRqDUjDw6fnlVoamqi6J/kqDSC80MrfPZdJWc60IRexfGvr+sKoWvO6yxSx0Hbs223r3dusvIdfc7Miv+MObdWBZNFzT4LUe7kLEiJZQTqFehNvMH/zyW6cdw0x++A9S0+fgpgvlbbQHEzLXUmejL5BKxf82IUxU0bdfROE76um1WaBOxWFjgyjwviSb8TpR4tcXXULRp/rqnnvfXC32/hWLwb3wJpYzbej
 U8ANuEOh
 gVjEf1Qfd5J3yZ7s3xKBPoRcdzjjNfU5caPONNgkVbe1hCs8bjI7YCEVLnqQ5njzqoL/DeDWuoc7QL4x/vcGsD3bWNEpQJMFYUGdu80x5JmedppHuv0xRxzb+IhrxuLn/097AB3IJV3M+u6T8rayp3aQCRr5xoDJd7BbidLSmW4X2AvqaxE8cBgmmts2zUVy/BihuxHAoDHLw6RLiv1ESZDFztJ7tdYmun3jPhapwgMzb3ZfqSYQ5GUJRHOLp8SSdNGd6wQNLtjH7tD0M//Cf0H6QQBijw6AjVg/HokL9kWnOXmofWYnFPqC1ni84yiUD7A3xe3JfHLrOT8M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Applied to cgroup/for-7.4-fixes.

Thanks.

--
tejun

