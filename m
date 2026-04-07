Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E56FB5178
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 01:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5963C6B0093; Mon,  6 Apr 2026 21:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5460D6B0096; Mon,  6 Apr 2026 21:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F316B0099; Mon,  6 Apr 2026 21:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7A66B0093
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:05:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB724E1E5E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:43 +0000 (UTC)
X-FDA: 84629967366.18.0A3B134
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4F9DF140012
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hDELN9Uv;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775523942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uH80Rmw+ixDbvW3zicOB375OvkF2JK51os98lxA73xw=;
	b=Txlfe4UcQP4hwn+vktyOzqquBLKFJqrAJN3rjnAImONdrhS94tcOQbp9tH5P7oAvZI1lZw
	06a7n6HZwauiWTgaMxGPrw0ev1LQifZoBWoZtbiRDwDZc1AOeVGzO1ioM3swr/aFhytlJF
	MyeckfW/PcSNmsIfXV67wwediiCPw20=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hDELN9Uv;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775523942; a=rsa-sha256;
	cv=none;
	b=AbRqkkDtee8O9Q6hWEdkLulLwD5qWJA0SZTfJN8LOltFovFvZ6ZuvgJY9D/IW5z6J6UlHX
	vPXaJosdilg6qWv93u4l3Tp11+6hUckbwPs1aKV7lf+k2KGAneZjSegMlH9zT89FxwEy2/
	4jqTUu20CxSMuzX34C2TLmInmKmbTnM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D69A16111B;
	Tue,  7 Apr 2026 01:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1176EC19421;
	Tue,  7 Apr 2026 01:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775523941;
	bh=88ilcTiVHxOBPfSO6beti3cUyMc/KjPaTfyvCKtApUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDELN9UvJpK+m+DGX2EfCnEss58wKhuhwSkXuXXfP4u2MlMgI50oaavE+X3D9m4Ii
	 x/0jSuwR0bxO7Q43A39xQR0NgC3NfLswQiOYBwmtNAPtNWpl+JHAs4kma3iZnqA9Ku
	 DOh/2wMSj2XDQ4zhp0Y4MWdGLmWMQJouoHplXMIj/qXsni5a9aI9VEUAGVYpYZvDCk
	 vdm8i1uahCo51+NmKHsK9xE9hRpXnEyZTqIk5iUxRCdpBuhDaQySHVj1Xq2FbLeIEI
	 AMyKymwt82Z5nKf69ZKRGYLCQte9tUAF9qCaY05ln8FlP7g0oE7Wcxrm9IL927az2F
	 j/1xc51FzywWw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [RFC PATCH v3 04/10] Docs/mm/damon/design: document fail_charge_{num,denom}
Date: Mon,  6 Apr 2026 18:05:26 -0700
Message-ID: <20260407010536.83603-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407010536.83603-1-sj@kernel.org>
References: <20260407010536.83603-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F9DF140012
X-Stat-Signature: jih9jm7rtgiygi16mxe15duoiksqxxan
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775523942-470469
X-HE-Meta: U2FsdGVkX1+8wrXs6bVGlrmRyYyO9LUz3x4us4IxCLOXAnPjiEJ4zZmnAC/0xlgiXu872luCdj05Atc/oVrQhXtgLiQ5XDBG4GxUqqbx8JwYHoPNQguEuoQ+MQHovhxf5sPT5KRrpUWgbf+1v/11TMfB9wfYBr0vq1gnji5TdU28Xr9vI2bSY1BvfFmvceqc/5ePQf7cACwLIAPXNpV7bQRVWKBx1CDrnZDipcQdU8SueAZsNT6TV8t8Mkt7zQLZCt/gIWdnlzWWNfmjIfj+vpGJwNmk/+91aG/Ku7+Ja2o5RG/DBD0wphSOs/HuRpFpQjEw/+e8VOfnEAHFeLahqCW+MhotuNstfU3if1RW0BUtYxSGNsmoXvFDhsgGjZKvWY2LYJPLHCCd6vA4L8deBD4jzZ6ohKA9QLcRpPk8tmkXWms+ug/mpxhmQhcJWFkggYRdekHLbnlwuBiLn7+nR+fYqkb/MY5EIsvW4nkTsSSqdJ5wWmU+gVhOk8ys7So9ceDPVCq3eBb5nPlFN15rLqqre9PjrhY5tuI1CAdt7jj/ZAqLco8nji9wyb/+MiuGZBpjWLyNEdYgMf3z7ZUhqa211WsQn+lmkMBAmGcEfJOLwbNxdvkX3+hBAByO2zTkbU89DjhfkiMG6DY98+EUSUiyus2qX3WTrR8yGF95Rb4cnqSBiwkdMWitSvHeKtnGRTZpDYjdUQt0ks7FzJOVJkKUp4CBUzJvFqiB5S6TCAtb2FpEOKwiedFIFB88AtGzxsMGgXmqcp+KE1dk+YIPaDoztvr9uUxMXOTJifPlhaJgqCnspboYfSPLR7Ssp2bi/KZeMY2vP/jJBE7tIdKYX/+ywXaRGLBkbfYRUNV+YKXYT66YTMuNHfJEKY45pqeJiQqqU12XbK7Fk9ohz/HyyTuJw0Lfc6BYODWMn5jhjHg0j6ivIQlJzfYJolI0EOT4fNiePPbZsj1jFm8eJ2x
 TgCpzTtf
 4BULrIilJYjyJ4AdY16XoGe6xJe8AATvSgZq9oK1EQb38XLbQRnxxeokCcFX26WFokfMQ6xUP2jM3cChYzADsri73C9xKodquopP15/6icuULi1vvss9bt22qEgzbflZmFGHnz8NytbT0eGM8bg6xLy106fIZJ5RFjANeKr34Eg/07Nuss61JwDijguASd+DMaR6husrtNjTBBhhnoADXYSuvZ0MrmSMdW4doyKwBeuHTDsi1EGVLS80i3d/tMeH5USIEz6oh/EjlS2ypvZQ6H2aJLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the DAMOS action failed region quota
charge ratio.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 510ec6375178d..94e898b671d15 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -572,6 +572,28 @@ interface <sysfs_interface>`, refer to :ref:`weights <sysfs_quotas>` part of
 the documentation.
 
 
+.. _damon_design_damos_quotas_failed_memory_charging_ratio:
+
+Action-failed Memory Charging Ratio
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+DAMOS action to a given region can fail for some subsets of the memory of the
+region.  For example, if the action is ``pageout`` and the region has some
+unreclaimable pages, applying the action to the pages will fail.  The amount of
+system resource that is taken for such failed action applications is usually
+different from that for successful action applications.  For such cases, users
+can set different charging ratio for such failed memory.  The ratio can be
+specified using ``fail_charge_num`` and ``fail_charge_denom`` parameters.  The
+two parameters represent the numerator and denominator of the ratio.  The
+feature is enabled only if ``fail_charge_denom`` is not zero.
+
+For example, let's suppose a DAMOS action is applied to a region of 1,000 MiB
+size.  The action is successfully applied to only 700 MiB of the region.
+``fail_charge_num`` and ``fail_charge_denom`` are set to ``1`` and ``1024``,
+respectively.  Then only 700 MiB and 300 KiB of size (``700 MiB + 300 MiB * 1 /
+1024``) will be charged.
+
+
 .. _damon_design_damos_quotas_auto_tuning:
 
 Aim-oriented Feedback-driven Auto-tuning
-- 
2.47.3

