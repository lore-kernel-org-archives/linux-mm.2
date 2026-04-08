Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC99DEDB7D0
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 01:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02ED76B0089; Tue,  7 Apr 2026 21:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0067C6B008A; Tue,  7 Apr 2026 21:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85886B008C; Tue,  7 Apr 2026 21:38:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D63766B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:38:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84FA1E292E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 01:38:58 +0000 (UTC)
X-FDA: 84633679956.09.FDC0E5A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5E846C0003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 01:38:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bbNQ7dLx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775612336; a=rsa-sha256;
	cv=none;
	b=D0EwTTGbH9yM2+Io4rYzvPCAV4yLZRm4B9M9cvu8AQBwmBNZuBHh6VNm7VdSUvhdIAYbW5
	lRxa25FZko5pvkr3LbctsJtGiKOdmgWIp6Z36KVMa7PbYdTDYG4ctHZm6QNGNVhdXcVEUg
	ef7mKqPv7rE/UQZr7dieS86PycJC6os=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bbNQ7dLx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775612336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0KJ/NgB0Ojo2aHtP+IOyiMd2ituEthuu9DnTYaHttBg=;
	b=V1Jn3gZsRKr676MQ2HdB8+HK62MRcNP79c7yvIc4jA4SZumPKlnW+V3xCxQsrd5nWBO7q9
	Z7q0OMqYlPL3YS6tKBn4ChgjIRDdrYCrx9p0ec95oOf8MMeQTcOnycALq4o0rFlhl9bVUE
	txYQasBVgSWnhxHc4p/jdMALk0P3980=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775612335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0KJ/NgB0Ojo2aHtP+IOyiMd2ituEthuu9DnTYaHttBg=;
	b=bbNQ7dLxHdMSgTyTXyNJ5ooqFMDJiBplL9qjZ1fWxFbGqBRJ524Ehmz7eLSz3cw+fhsHKj
	SFfbP7/+Ch5rl8vHE7fA3TdpODaXqwDfOncodZDKAvGt7FC83KgoP991r1Fl9WFkMfMgfM
	KOv2QmXHD2+wJvB8GUtRRt8B2EUloFI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-2Qb9RMGOOu-tgCd1e2KupA-1; Tue,
 07 Apr 2026 21:38:51 -0400
X-MC-Unique: 2Qb9RMGOOu-tgCd1e2KupA-1
X-Mimecast-MFC-AGG-ID: 2Qb9RMGOOu-tgCd1e2KupA_1775612329
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D756719560B4;
	Wed,  8 Apr 2026 01:38:48 +0000 (UTC)
Received: from localhost (unknown [10.72.112.14])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0D511955D84;
	Wed,  8 Apr 2026 01:38:46 +0000 (UTC)
Date: Wed, 8 Apr 2026 09:38:42 +0800
From: Baoquan He <bhe@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>, linux-mm@kvack.org,
	akpm@linux-foundation.org, david@kernel.org, mhocko@suse.com,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
Message-ID: <adWxonmfjvcwXMg8@MiWiFi-R3L-srv>
References: <20260407110002.204755-1-wujianyue000@gmail.com>
 <adUTC-7iyOAUlhR7@cmpxchg.org>
MIME-Version: 1.0
In-Reply-To: <adUTC-7iyOAUlhR7@cmpxchg.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: rnT9nheWv21yY3wBdkMWRO9ChQAt74URPbpu-_j00YI_1775612329
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: rfb35koph19jgdr9q9qhxtmbi4qursqa
X-Rspamd-Queue-Id: 5E846C0003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775612336-311384
X-HE-Meta: U2FsdGVkX18TTvP1FNjHRudm2LXv4+DxSxVSY5RABIZZqhzf3rz28RWINwiNJq6cDWXUfx9w1z2nakslZdjDOj5RchD0i/vtYfg5WUBqlOTfwfCdFw9Nn0q2s0nhO165krd3Us1yj7qYGeWEYx5Hat4J2uYMTbSjzdacV9tkNFd8yZ0j2TwPBFaR/oPUIFswPNzL3GTOGytCfM90OBUs87alyky2TJyOGzsIw8x4U7MDy46LUb9+oVMT3BRzpsRYgJj50X91qxhW69KxP+5E0c7X/EYFWQZi5mTlJh8ld4/GlAHyDUCVpbEym5f4wvmYhx+aPBbnZYh8+8BLHxyG6Os19DgraXP7ngCRukn7l3aTE73GoZ2HUG635f04melNUp7igmHpJlNelTYTH8nFJ7EDNXFWP7SQIrxmS9+KziHD6VeMpe4OtZA0KOUvp9jeN/poNaOsftCyEUXBqg4q5gcGe734H/1bTEZ/9Lm5NeWiIKaVU0OoDDBDvfaScx1H4lUuemPBQjq6STU65nZbjADKCDnydsmliy/7nntZ4wZdxvvTjb/lu0VWb7CLymKOxH+2yZIIkmRhGN5zINJjYotrM+JVQs+N+MidiLYwDsdMyLaKlzwrKAK8DrTo5rHB91IKZTLgCvj2DNaV3Msen4KYP9VRxiwylGWKqJLQg3ZyD9UWcFT580ZqVPV8qVNmYlCP//R/5rLgXoRcfaxKJX7ccXkc/oFx53oioVI3s12al0ua0eZxzw3C0Qoz/OEy0FeTO+z8YTnV9uq4LwK4tUXpkYA+lyjjVTIikXqdeFD+NRme6jssiiLZDn86mjKxxsPfcpgkEb/4raTDucdEc7GMAVhV+CtBSWprQ4YLqecTPg1bKAwqjHWi5XvCtuxjmnKVdQUMum9CABQfjJ5WD7vf47EJ7ZVBPo32jtC5xcKnWcBlRrR5uhLrANwqGIGOcGAFvOv4yuSrgdT8T3V
 AxGholK/
 neQ9KXNMjZcIYrDS+0pSJlMfket3xN81+thp5aSTuSxwj3wPFduP7LDJbURymf0ENcPl/KFg0qReJi5rRk8yARNNSGXleccVHYWPRY65R5oFqG5RdtWkhvSxErhdPT4rqexAkPmkZuXCZXUHFNBI+HwRp9JlCe3YpMIeVkm7R3XHm2oot/qKf9NiFUVZTrbeC44R3ZTSJVSKkbrpudSi6gUSDwdY8lkNZc1KBLqmexk/PeukibTEafU70kpb8x1YqgJsvLzpJRryjdIMmt+9+lCmt5FTGU2KnDCOsCTEojSRxHz1ZQ4adc5cRFgZbbX9H3ai0vLt40fq9UxH3QENK/7swbefDhb8dOP2uW0zWPpaxqhjiyxHbDTYwuqZHJmP7YcM2wFtuP4/mntUjYCo/546gXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/07/26 at 10:22am, Johannes Weiner wrote:
> On Tue, Apr 07, 2026 at 07:00:02PM +0800, Jianyue Wu wrote:
> > All allocated folios are added into lru lists for later reclaim whether
> > they are file or anonymous folios. However those folio lru operation codes
> > are put in mm/swap.c which is not so appropriate. Because swap code is
> > only for anonymous folios.
> 
> Ironically, the only thing that doesn't fit in this file is the swap
> stuff. The page_cluster & sysctl should be static in swap_state.c.
> 
> The rest seems thematically relatively clean - infrastructure for
> managing folio lifetime. swap.c is not the best name for it, but short
> of finding a very clear improvement I'd just leave it alone.

Can't agree more. We should move page_cluster & sysctl and swap_setup()
to mm/swap_state.c, and rename mm/swap.c to mm/folio_lru.c or something
like that.


