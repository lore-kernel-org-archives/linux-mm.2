Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D0B1F532C6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14CA96B0089; Mon, 23 Mar 2026 21:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D64C6B0093; Mon, 23 Mar 2026 21:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDFE56B0095; Mon, 23 Mar 2026 21:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8DD16B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:33:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAD821A1067
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:33:40 +0000 (UTC)
X-FDA: 84579234600.15.7288227
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id BE03440005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:33:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hej2aF57;
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774316018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jPLmLxdc2dJpdMM6wOMnhCWJMGlUkfungjDjfJ+bmBI=;
	b=lw6rXVDyFY1x84SkDOTUJstboJMmqjT1tDjaH2oN+19JZ1ZZA3fjurSKnXgiEzLo5+pzCR
	B/rRI+5pA8KZZcdw/yrjGJhcNYOGPpZ7bR+ponjM6lg+2cuI/kbtDPm0TsO2d2Nk+Z34aM
	dnUOTv3jNeuuxxLO6owqU9viJ88+jWc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hej2aF57;
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774316018; a=rsa-sha256;
	cv=none;
	b=htj5UR0yUlWX2S5Dr/Pkocgaz6FvDZgPNsytvhtJcLWP3Klc90h7Mj02Y5t7yDcxNa4i30
	AQma4tlGbtGBcLZ1KQEQQjzIMBsieQnhXaPiPvWivybNIT7Puxcycrmhz2TviWV8gh2vgn
	fQkVxosTIE9vhBpy1StfDtfs0idvTQg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774316018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jPLmLxdc2dJpdMM6wOMnhCWJMGlUkfungjDjfJ+bmBI=;
	b=Hej2aF57DvTyD6TnuDCrq8OLRHVlBDT19CgOznGq88ImVjkydQeYmtTwBfqg5X0UU7Llcs
	gZrUiOJkV28ak0u6bWD8Omtt4rJs/Moh7BxwrAn7aOj+KWv4qXZQkzhWgmnSgRsdzvtPKe
	QN7csxwwsnnlznoMftVGQhCMMpTm1Jo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-7C3jhnUrPYeJDF0kgluDvw-1; Mon,
 23 Mar 2026 21:33:33 -0400
X-MC-Unique: 7C3jhnUrPYeJDF0kgluDvw-1
X-Mimecast-MFC-AGG-ID: 7C3jhnUrPYeJDF0kgluDvw_1774316011
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5ED27180035D;
	Tue, 24 Mar 2026 01:33:30 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 080ED180035F;
	Tue, 24 Mar 2026 01:33:21 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	chuhu@redhat.com
Subject: [PATCH v6 0/6] selftests/mm: skip several tests when thp is not available
Date: Tue, 24 Mar 2026 09:33:10 +0800
Message-ID: <20260324013316.2590422-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: kGVcojxesn_FQ9aOgfz5y3LyZ9MMG02aDgAdB4nVu3U_1774316011
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BE03440005
X-Stat-Signature: yi3bn9tz57uxxp5gueir331qtsheok3a
X-Rspam-User: 
X-HE-Tag: 1774316018-445601
X-HE-Meta: U2FsdGVkX19ptYCDERhE9tqXs3EPMWa48hdQG2uAX9lJsDMNb3X2l5aT/SJIcMMbSU9RpD9+zoeYIch4B5d7YqWHjdUmmkhlqAIlNtZahpVRkWUCt5ic2HvJh3LjHQo1WiGv/PHpAGxBSOggJGyQ4OlKph1KvmGVBBZAJfsUgdLaaZIG7hvoh9CDe0/ecNO7tBElSeHAD8wNwaVtyLcOs8vdUlhFXfZZ2Lr53NIrR/kYPX7AIO5oKejUkadFxKOK6sDuwsix9H3gDKTUlMGB+AzFy7W3+QRVghzJlNyjY9h/OIFNJGkEEMelCXQR10HYl10WakhDdszbfkwHzHVjPNuIZdPsemfmKQnCkce5UMzY0BqHzaRxNp6ln7LkFc0aVzRbGH+jzJs/4E2qvzue4Z9KwcDLmCJp9GaS2ywI5XYzfVoWlYYRdO7mgMFM8Pme/VAjOnwl32/eXKPONVo57An2ylilkrDymjpLzZIXXSokGjrpY7zzvc6cbzUexYUt/3QAGT5XMkQVZIkyuZtYJ3nke/7Uj1RksP+GKI0Y3eUNiCoiLVFcD8YkeeJbiU1m/JB5jlGWCSrDPDeKu1HlaCubvEAz5bxSpD6IkgKqarwIoX2PfUVdGF6LV8BXOpRdWvDcuP/q8zM9INqnrV2rHmch+BdRkEV7RaXHWwUwhBNTE4k2al0ZsO/4KWe2WHPrPKGTbvILDHeMZX9IMSqaQXVDyvKVX7weQ4A3LalK5UHseUeyF/3H/4hPgjzOlTOI1mh5DW7ZIX0Lte4qeI9u5a3BpmGV++IqmwzmSvtc2UPcSmWqgRbglVYCeo3CkJrUvwSBMM8cSfv9sNG9BvyTRALALRzPn6gyAGaISePGWkfzEkFu2xqzW5L6Rbl2Oj0VKNfMoR+S3fdPPuLaThZVjuaRIAgMHTixijZjAnmBtFwpu8/n9FREfGcmRLLoorlje02bXTmyLowrBtrxsbt
 M3YHlwRi
 ogq4OamB9j0uwfc2J6j80iOcpN+GR/Erdo/tkxpbiHmTYf2v3aIKBNf086KP1rwS3uUwvK+yLOcwYrfr7Q+HK7J1+R/BKgJ3n+DHOTcDS8lCzb/WQ32YLUhjq74DZ5KXoOHOC8IrS2eu/1Zi6z7r5mLQp7bygKj3tK4wAGM1XnVm5bfF1D0BNY+UWO99KgiNVv6/d8QHhsL0t5vORFp+pQ/MDhNjOU+OEsfbsSItnfGWDSfUeb5rbiFQ4lCKpCpfW22fJxeEkxQXBiooKfXU6G2+5gbhn21AzogfiWEDKk2pMz7x3DITggxawIb8i4q8Z+fU7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are several tests requires transprarent hugepages, when run on thp
disabled kernel such as realtime kernel, there will be false negative.
Mark those tests as skip when thp is not available.

Chagnes in v6:
  - patch 3 add reviewed-by from Lorenzo
  - patch 4 handle the errno before and after close(), suggested by AI

Changes in v5:
  - patch 1, patch 3 updated reviwed-by and acked-by
  - patch 4 adds new patch for robust write_file()

Changes in v4:
  - patch 1 update to use thp_available instead of thp_is_enabled,
    suggested by ai review
  - removed reviewed-by and acked-by

Changes in v3:
  - patch 1 update commit message to show the log snippet with where the
    fail happens, change the 'false positive' to 'false negative'.
    Update reviwed by
  - patch 2 update reviewed-by
  - patch 3 make write_file to void return
  - patch 4 and patch 5 updated reviewed-by/acked-by

Changes in v2:
  - replace 'false postive' with 'false negative' in cover letter
  - patch 1 and patch 2 add reviewed-by/acked-by
  - new patch 3 to add write_file() in vm_util as a common helper
  - patch 4 removed the {} in if block, removed the write_file helper
    rename chunk in v1. Add reviewed-by
  - patch 5 move the exit chunk to the front of ksft_print_headers() as
    suggested by David.  Add review by.

Chunyu Hu (6):
  selftests/mm/guard-regions: skip collapse test when thp not enabled
  selftests/mm: soft-dirty: skip two tests when thp is not available
  selftests/mm: move write_file helper to vm_util
  selftests/mm/vm_util: robust write_file()
  selftests/mm: split_huge_page_test: skip the test when thp is not
    available
  selftests/mm: transhuge_stress: skip the test when thp not available

 tools/testing/selftests/mm/guard-regions.c    |  4 +++
 tools/testing/selftests/mm/soft-dirty.c       |  4 ++-
 .../selftests/mm/split_huge_page_test.c       | 19 +++-------
 tools/testing/selftests/mm/thp_settings.c     | 35 ++-----------------
 tools/testing/selftests/mm/thp_settings.h     |  1 -
 tools/testing/selftests/mm/transhuge-stress.c |  4 +++
 tools/testing/selftests/mm/vm_util.c          | 23 ++++++++++++
 tools/testing/selftests/mm/vm_util.h          |  2 ++
 8 files changed, 43 insertions(+), 49 deletions(-)


base-commit: c369299895a591d96745d6492d4888259b004a9e
-- 
2.53.0


