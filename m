Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE0FCC6B2E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 04:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C246B0092; Thu, 15 Oct 2026 00:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724096B0099; Thu, 15 Oct 2026 00:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6601D6B009D; Thu, 15 Oct 2026 00:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 432176B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:45:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5D2280897
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:39:04 +0000 (UTC)
X-FDA: 85323605808.01.9805DD7
Received: from mta0.migadu.com (out-77.mta0.migadu.com [91.218.175.77])
	by imf04.hostedemail.com (Postfix) with ESMTP id B466640005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:39:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="OWog/lXA";
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.77 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792039143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ay+mTbjIni6Jtl2VgmlzM9iMuS4nPtZOGeeyawWpl28=;
	b=so+uERMihfQxsaVHdUkwfI319aw8zMgDPU+SD+wzYbdJVjbx8m6V2uuRbFBIyYK9tVu3B1
	r1/XbCy/8o1vEfxW76cGoZgGPw5M3sboD0qPlQI8fk0mwr95TFcqMj2Ha7dpfu6IZ7T+PG
	5Aiiaf39ZRVrepV/o4siaAua3SnDMcg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="OWog/lXA";
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.77 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792039143;
	b=zkm8eusrkzd3FUmF/hTlN/D1QoD2kCwk7a/ecyJwFWCaaKuVkOjYiN+ZkvUVGtkkK3pe/M
	FZarenmmEQESs8IRYFSkn2yf4oGId4uCHudZ4YnvAOSW0CAsm1/GsEY4eV9OLQrGXV2KlK
	iiQBmrTgvNXQYTGvmwnJbVKgl9mVafw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JFsUqK9yz6nBN5iUAJ9e32IybN4bnnnH2DWUUmALfcY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792039141; v=1; x=1792643941;
 b=OWog/lXA5VZDLVF2pC//6caNS6Gvc5+UTbSLxt7rmHASGKodDgbWh0jqO8VrlxwhNhNXf0po
 dJxunqEMNUAEMpmu3A4xCJThaX7oxI7HiTyt3MC3eED10wnAgb8IuFPBJXA26TC/jgwsz0IuH1F
 jVaUw3OnfHcjg7V3P1yXWABk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 90cb0f3fd8c9c893;
	Thu, 15 Oct 2026 04:39:01 +0000
X-Mizu-Trace-ID: 90cb0f3fd8c9c893
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kas@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com
Subject: Re: [PATCH v5 3/9] mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
Date: Thu, 15 Oct 2026 12:38:56 +0800
Message-ID: <20261015043856.57881-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261014171145.3292736-4-kas@kernel.org>
References: <20261014171145.3292736-4-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B466640005
X-Rspam-User: 
X-Stat-Signature: naf3usjk5zpnk35bruq51sngru95m4y7
X-HE-Tag: 1792039142-871102
X-HE-Meta: U2FsdGVkX1/6hB+Jl9h4t7/UpQ1JpElgNzTw82paKkDtO/dOAFBhPPjDW+8VoOq7/uY507IUC5cDNNAZZ7sPzTIe/a2RFJYp+VW3f8gy5rWVvrx/7lHRKU1zg3luTWj/2vfWiKCwivioFTPc1xjyP66G5dfnz6N78N+j5/SLTAXfx4BQ+Vc675v4ps6TPGRSFb4SLKw+eFUY+UypVFP2ZwSXSY2o+J8MmnPqh/jAuyptAsa8B4WowjOc+2W/kBVQ1fEYOyQHUY/fwc7f7Vz4uAeAJfs7xpqID21JdPqs/chzD6bENjTqE7Otg9mPYeM181LBcuvJtkog9yT1iCL1aZaoxq4ARBiqlpdD4cr1uGJYEx0uG1qW83XYI2YgTlEClhkF3E5yYxeOFMk0oe6FVuuk/YxyUG0vXct5KYnLrqCBzjF4Uz6rRYk6nxsXxGx8pyO+CHZrw7xTE77VYAF71Sefi0Ir8jr3Gbs+uAqTrXFH+U9WoEcF0MTvP+Wl9suO8y18y/71eLPRxSg6u4bV2/HTKOtpis+TQQn58aRi3d4d4gpAX3YjF/qeLpa6hYQo3b8HmkXVc4MqedyqCqGoZ5y3mOVKNguts8cCY5niQ6Qkz7gbldp9jG625S/oCxCZdEPX/Yj7FeQxhBp6SQLYgluZctDi7FZsBw9A0YFP5sPIe99JAzrQQz98ikdHMaaCBN0PPdWbFiJjXps+5w0F1leFm6fJhlU+KRcaj87TW65mxW/XgJaOJQ/2ty1YEYqZt9vQT4jY3XojZCcfovhbQSLqroWNFmZh9zvgwNgbCeD2rov6yZOkU1egXb5HOJKvyeSydA6xcPc7F0ncg/29jdk6clct/FyfKPfBrE+nyzBk+zbiHcLDo72ErJ5XP149tQwAxaQ+rXif3r2xmaxLHHxk2BzAUSX0W/Bx/2VE/7qV8Abo8LAarclehwExcpDNDo9Q1H/MbdoZFjmOqcr
 HHRQFH9g
 JOmLhdgBy5IE+NiC8IMVww0915FuSD9HH38AJ8QnaJfpfpMKZ1THTjHUCv2LadD259aT0eg/GoGdYZwJYxu/3i9dE4dRd77txTjbaasH3F6lCoSfr2vrQEEF3iLo0eiUteF+sDy3zky/voeFc4vdT+20UAAWP1DqwVvPhfQ2bYE3tGK4J10LTp8Et4lZd8CzejtgMiQIJSUtwwWR/2Zr+2xyeCEKiqrwJ2DBKDcE7YabgR6dj8+UKI3Czi56tqkWzYTUfFRdVliBO1u+PlQPVCqOrbZ2jyhWqx/tLj3NNAFtFaJPi1C6i+HB6zvfjjHeSp0kbj93Ah7eznhXqzUM4CPZz2KK1N1mEkEW+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Oct 14, 2026 at 06:11:36PM +0100, Kiryl Shutsemau (Meta) wrote:
>The name says less than the bit means.  A set bit means not only that the
>PTE is present, but also that it passed the other checks: uffd,
>lazyfree, anonymity, sharing.  The PTE can be considered a collapse
>source.
>
>mthp_collapse() then reads the bitmap starting at the PMD order, so the
>bitmap is not specific to mTHP either.
>
>Name it for what a set bit means, and update the comments that named it.
>
>No functional change.
>
>Assisted-by: LLM
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

