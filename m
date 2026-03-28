Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87EDA10F3DEE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F114A6B008C; Sat, 28 Mar 2026 13:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9B3F6B0095; Sat, 28 Mar 2026 13:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89206B0096; Sat, 28 Mar 2026 13:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C91246B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:34:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 813C6B3DC0
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:34:30 +0000 (UTC)
X-FDA: 84596171100.05.A93A718
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id DB12C2000C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:34:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L/oMVVgn";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774719268; a=rsa-sha256;
	cv=none;
	b=Wc4PpHdJ0u3DdWAFbGFmDXlFeuj/UDUMPOqP2B0rh84SvICX//qJqJEAAubAzjqTTdutxB
	EimruY729HnOnaZGpeIQS/4aU63xGYqBnJeQtI5PVWn8+ijIFkiw26LZ0pNxlGezzMHpK5
	0c5VXByZHArnGUtNzHrGi6tazMRwLBE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774719268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCbhZqe2SbBOGlqKsJFEE4tI5alXWaM7nbnyrEwjYo0=;
	b=NnqNvKSAyCa8sQWQUe66rD+Jn/lzNPCJw/hU9kp2wzaTpkZvf3JJ+ExukgE2Mds1ZO/+GV
	PTGBR8nedEZHPOmBrDqmeULlPR/xp5ei6IrlNF75vpQpYChb0KOKVmKDKJC0Y08EKV8XBE
	Ae71o34VeEmYCw7rpud4IArD58Lb7Vc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L/oMVVgn";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EEB960054;
	Sat, 28 Mar 2026 17:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C859C2BC87;
	Sat, 28 Mar 2026 17:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774719268;
	bh=fOA5Uccu62gNiQq1drddmXA4wHftfEy+C4gnJ9Tes1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/oMVVgnOa+nVGaWZBR5fpmlzGs25Q+kUaxddBMl9zcA5kKYdNuTVr3WHzXn/7UrG
	 gPmMPyqIJx97iyit9NdCplbHlLptwBHGUkO0vR6zq3Swb6yTQK0S5sNZrX2xgp31Hy
	 VdzeAcY9j/kxg8ANEYVh1QPNyqd1VVpsFplaoi6x6zh7rdeMqycK/h/OH9860+cxBE
	 2jQpbw0L+aV7MSH3H98g//Nz80KH1/kzVi6eur/XgG988L64rpbIWWS7zNxZjdrvi7
	 FFMMUdZTXgiLovI+DKsSQbgC7wN+sh85I9Z8e1FxzBaHcJBf0K4pUP2HBHauZaKVMi
	 QxVB3M56fohpw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [RFC PATCH 0/2] Docs/admin-guide/mm/damon: warn commit_inputs vs other params race
Date: Sat, 28 Mar 2026 10:34:25 -0700
Message-ID: <20260328173426.52911-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328172415.49940-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB12C2000C
X-Stat-Signature: f4bshjth356y9cen7rhzartcmszh1mb3
X-HE-Tag: 1774719268-273520
X-HE-Meta: U2FsdGVkX1+CG4cWI2pPyvg2yu5mRozBlpDXQS8ikKzt031QMfkqujvqocAo9GbV8K0Mjf4cM/htmYDU4KGIeweRvBaAq9kqhD+f6/yXZmPYZIud81S+e1P4JYNhe+9IzHdo4xMrBz3awUYCTX7yxHIApTfOij0s3AiVdGvIICGw/9Dmg6FwLPZiM9zrniFF/etkhw5BeEwRRHgeKkz//BAv7pazLnqputz7unPWmuhLm7j4k8lfaOZV47BE+O1f27tgEKc+ozira3M9L8DGviMBNvFIBFjrqQyi+gFGyR1D9u/TcIbRaDVsi9HxYJo97cvd5uqBn/XXxiJRBMX+z9DY/KQNqev8i0wRDBGFH8e++hZJhmgQFGgy6soIaUMOE+jvFU+UwkpgG9BT/M7cYXSTgNmQSJo4PJtB5Rqawyqm9PgoYihOik/4MkqiuhyINrgzYgaQRgftE3uLw0UTnuRQa1LY8fn7PPvMTWG12AUCCGdVo3P2jH050XKzkn4OxzcawBnF89dWNp/6KozojNbLHHIO2O7dtkB+hF/Hh4+jry8b5pxKv9DI/do2gm2vL1zHU6D+Oom2Hsr5EMsK8qzD0aWRDbBf8yDnGi0IkRYJRAt7uMszRQZD6vcd8jzBaqRfCiMqlQ98bQSJlOwejExLIKmfyi3bwb+a2jNXl0RXNxEVjDEa7tZOk6UnrhlSdFUP/NR9a6OzcFZRz2SkWDNMH0Rvcj1Bw+NMS3j3LkYFMucXx8G6eB1z41vNEfbF33J1G/gy1/qmNsx04hTuKNV3+WsdVztUgq/GHRHEzeA8koZpJJ4ozliypThg0O5ZhOHw5EP2LAferijWToeZSra5scVyf6qp9+s0lgdcsrZoBMdBCtpHCJScFeTJ839SusJg2eWAz4KqSkqOyTKgG3tAE2+Wt/BEmqc+1O1qzssyFMgAb//VJoeNCFiPWwC/1PqFYjSpjYAQUXR58Ti
 5FC1xzwR
 GMW7g/I6SeD0gN32ZF2dScKmwBtv8rRboNOVXaOs7IQo3AClfV83w8pIfco3hc2STY5/3ZjgW1rb+Wn3Biy6egAADefH/Z0J9+fWR9Mrq5NyFdN9+gFTvBkbpb7/tMg2o+b4H3JBYGabHrREID6mb/TkTglUwqr0DTXrq61Dr/Pfn8K1Umft89NzasLRJ9lwA7czgajPdpAZcyQ5y7L/vHQtDBiPvKDoJkXL+nv3WJ3eXJn09/XgR+EkmjtXa4xVECigjyUGNiUIXh7MQ5IH5tncnMvl/ndEiu5x87RryqHBFeLjKT5I60HSxaVcpeCU40xkEUO2S6nULKFXGMn7wQjWDgta2XJ8kWSEGtEbHZ7DQt64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260328172415.49940-1-sj@kernel.org

- [RFC PATCH 1/2] Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
  - status: Reviewed
  - review: ISSUES MAY FOUND
- [RFC PATCH 2/2] Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
  - status: Reviewed
  - review: ISSUES MAY FOUND

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260328172415.49940-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

