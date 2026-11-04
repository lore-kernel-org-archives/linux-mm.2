Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39E1F606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G2dP9jW8
Received: by kanga.kvack.org (Postfix)
	id 5276C6B00EF; Wed,  4 Nov 2026 04:07:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9356B05B2; Wed,  4 Nov 2026 04:07:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EEFD6B05B4; Wed,  4 Nov 2026 04:07:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15C286B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:07:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 884121C3F94
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:07:41 +0000 (UTC)
X-FDA: 85396858722.17.20EBABE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id EE9C040002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:07:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G2dP9jW8;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783260;
	b=qBUyRsZY42HcZOi3txsBo8SPZpCHJp6+wUl/lBtZ/htAKGKqvnKue3Rz3hE1WPKwvGfker
	b7juRzWjPtZD5QTIT7Hwde2X6WV+Mj3EZc8drHAlUHsnXbJGIeVE1mpWnJWVlRWr27Cjcq
	s/JnX6Qhkuk0cv/Pbb+j5LPDTp8XkbE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G2dP9jW8;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wtgYPMXZXp6zUY4OHNPQsnexKANsg38h6IetxV4HVw=;
	b=jnLSlG65YuF07ofb+/5s6ES+DKcmFqw8lxyP2U/1dtJqaeNcXypzIr55B6s0mD7RBWRKcB
	J1jZSKvaJfeCYDxT1ACU2YaoN65xLo76ajrFHPWsCLgLKbI17yKDMViJYgpN0hPB1odAq9
	Ya1R1GwWTRkWaMiAZj4uw6mf1lLvU+E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F67D60098;
	Wed,  4 Nov 2026 09:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4D31F000C1;
	Wed,  4 Nov 2026 09:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783259;
	bh=/wtgYPMXZXp6zUY4OHNPQsnexKANsg38h6IetxV4HVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G2dP9jW8XN9fwXCrGnjt6PUjB94dMWk22P5oRER6/dYD3zXvvuzlKIrKLzPlfnYCC
	 qOcuBRM28rAzRCFJukigtV7OTBeLQcFImEoDeS3a5YMb8bob19T1P9EA2nb4kKdQ0v
	 WWHlHf/gkNd+l4NpDAM32yRLg64mUtajz2yXneujyfLyPRx2qQuV3v8Ma7iE4TggCu
	 hw4qQHy1lBXXlmkThiO3lpG/9nEypbtPLVCAmyrzUS9uiZ4azhCT29uKjwonTiORlb
	 ytNHnHqtR1POQ5gnAFwbKO4J0o16idIKO1z9oen/GYwHDy+SyUWj9m3HYs3YIT9dyZ
	 mamCDVhtpL9BA==
Date: Wed, 4 Nov 2026 09:07:25 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Huan Nguyen <nhuhuan@google.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, akpm@linux-foundation.org, 
	david@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, trondmy@kernel.org, anna@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, jackmanb@google.com, hannes@cmpxchg.org, shivankg@amd.com, 
	rientjes@google.com, dave@stgolabs.net, nifan.cxl@gmail.com, fvdl@google.com, 
	jic23@kernel.org, rkodsara@amd.com, bharata@amd.com, sj@kernel.org, 
	weixugc@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com, 
	yiannis.nikolakop@gmail.com, dimitrios.palyvos@zptcorp.com, alirad.malek@zptcorp.com, 
	ryan.roberts@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-nfs@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/3] mm: use non-temporal stores for demotion
Message-ID: <aur1xv84Siddlg3P@gremlin>
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
 <20261103223025.2482227-1-nhuhuan@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103223025.2482227-1-nhuhuan@google.com>
X-Stat-Signature: ekch5fmnnhodbfsmjuuai179opg3pc3a
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EE9C040002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793783259-571789
X-HE-Meta: U2FsdGVkX18YzixWgN8eX1QQ5ETlIg79tSVwGwgNb63qYG2SZPu9fL0FAh6IhIX/MWj1fhyFD8wl0VtdeLI+MJJVFEWaYqKTCzEKndurYdrVzB93hWxMWSfTMYWRfLXPM55iiuMKj/MwsNF9KGH3QQ+7TkAQWv/9vW0wfi3E5diOnax2oNzBSa4NdvmxTNf4biMTowokJTsO6QrDXGGNmrilX+j12lXiAZpCwJ3KjSqAD4ZQY8XSo/zjMjzWtBUco1itQYtChZZHcQkzxrksPZwJjVKj2sPCWwSqPOFv3xNF/KzkPO3OyGKLopSf92ylLXrOTZcaGK/ejXjj85aKOa/EBgva1UWWo4lFXNzuiZkxjxCDBsX+CJCAvhML5nSXICK5oQ5i05u4YgC+DhMSdgXF4MjS5x6xhpwDfNH9wzqL+5pFyn1OJn+yMOkEeCVOxks+nNmIl/SiDgaGMIXr/6lvVwhLz6VTmoRNkkyNFkAm3V8npW2Rsl6WjTvL/m6C8QwH1cI49U2PPCGeWG6c2O7vBbnOCwKnYLHtydmEV5XpQ1oXEk5VWN6NLsPmiOwueoqz11zHD4no7PjTabo6GKNn4gZWbduagY/UWFHgG9FLLSsFtl82Ro+0xdDjaECjOPojRIS3CqO1BAqzv1+p6qHGCLgmghnk10HKY+Aw2uWIM1TowSn2eDNYTt/otlnZLEtbqyo8F1CZUs8W5B9mRFNYijpkEbJulxxG6vulP3o+SFWxPgtTOXoGi4E8Resk0mlI5w4Hag/gqL/F7mKSSCL997+Zvy4Z3TozznnqqIkdluQf7nx5fP4tyT9pMwQcP/8oclFu4UDrJiyBoHFyYYlmX6sAkNTNfEKFAvs32uMz8AAEWM2L26crvuBKai6Ey9FaUzuuKMqaUztbnA6oKaUw6BRt5AUfjIvsK62jpEnFsUzj8HajCozT5NRfCH5C3VtuuYb2srWCCOJCK5o
 9jPpn8N9
 dv1KeCE2Dx6OatWvomY0Sue7M35k4eKM10IOQeHLz72KaZlz5go8iAc4kdeAwaB8OzjAF/0MjwJ1gg+GB6yWwUfAzg7sCrmk4UwjOIWVcAkLiD5mb6uGjKilqe4RIlD0qmHIzqe7I02K6Wf7sqleFp7dnDbuN0k8iniz3D7tdYAlR5Eygdv3iJ9vyM0HZ/6ZHhI5jKsssn/9+nhYOOfAQDHfI3Wfji63/nUzO3ZdL0HU6nivH/p/jKZHKlAe2jxyxe3A2nMHEapNuZGsdXEmttsWzl8orvAo4fsrvH2PbLc+Y239QA28ts26qdAz40SFpYbbH3M16QMkg5jfNUR0/0Dcc6B7HY0APtJZ32ps6IN/xketlH1MNnqoGqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Please always send new revisions of series individually, not in-reply-to
any other email.

The easiest way of accomplishing this is to use b4 [0] (the recommended
way of sending patches to mm), otherwise format patches like this:

For a patch series, e.g. at v2:

$ git format-patch -v2 --cover-letter --thread ...

For an individual patch, e.g. at v2:

$ git format-patch -v2 HEAD~1

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

-- 
Cheers, Lorenzo

