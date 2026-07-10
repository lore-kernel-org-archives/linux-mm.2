Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13C0EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BACD56B00A5; Fri, 10 Jul 2026 09:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B360A6B00A6; Fri, 10 Jul 2026 09:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73686B00A7; Fri, 10 Jul 2026 09:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 827096B00A6
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1930C40459
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:08 +0000 (UTC)
X-FDA: 84972993336.23.45B6E42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8ECC61C0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DXrXk6Ms;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LCoQX0bHg1OYdjWEvzo4RN1ftxPbEZ5h4yD4yU742Y=;
	b=xe/CrcI4J0ewSxsE+6XqnPnzT9sXGcgOZrHWc/5mfAH1EIscW0ieZVdXI3V9OPDK/w0dSA
	VzKNHj7ucciH7VtvAlv6rv3HCY5wR/nsJrzdbJL1A8mzSu/GzrksF/AvsylkXCuijLV/8C
	BLo+9fMv/N9UPRAsOi5Qjxxt153eMzA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DXrXk6Ms;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691226;
	b=1JzL8og9LBmK/qsod5czBWhQgu4/kruwwUGd8d+NSP+oO9q+9sD+7M4rPpm9TGpWKGEk8B
	BJlTmpUCjDohb7pr8a89L2oBAevaTGnK5jamzuLlnd1nEE1TjHDsaVNdhK997z0fje8uD6
	ILr1dSXsQn/+cpWN8DtAckCrHG0GoUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F0756111A;
	Fri, 10 Jul 2026 13:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2031F00A3D;
	Fri, 10 Jul 2026 13:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691226;
	bh=8LCoQX0bHg1OYdjWEvzo4RN1ftxPbEZ5h4yD4yU742Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXrXk6MsdFELcxNQ56FkZImn/zeom2zo3+oNJIEExxO5fnl51GzBBhviAI62KHZcS
	 VvKhN9dlzVqP19mmS/OrTcxeMvL+7RLl1qkRsTokHwUZPXEJvbeODKgQVAHr+iKUFG
	 HcDnzLI5hzMJ10+VBVk+tz3UUbptmOJmliAVAd2lh2+x8DEUtkVjysYRVL/9ndyxDo
	 frZnxii0FJ6AMG4yjpQjW/h3D4mvddEdzzspVLwNm8jn6ASMC8EZWkXmRu87fTze/Z
	 tKT9fp/HsjEIZj3qIOQlpnyw/JdNkx4enYM9V7RV5wm3aP92SWPPf29MpxABdUcfdF
	 Ab8/syLuxVcow==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH 17/19] Docs/mm/damon/design: document attrs-only monitoring
Date: Fri, 10 Jul 2026 06:46:46 -0700
Message-ID: <20260710134651.18084-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8ECC61C0002
X-Stat-Signature: 85arwdje886owoodue6opfmmkktibwde
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783691226-838520
X-HE-Meta: U2FsdGVkX18XKaBWlu8LR91AhAo40aNpq/yZDJ+Po01DODilo9lSX4kUu+PcJzRgzBDlTaPP3sphLhNtZGsKIAjrQGWCsgvrCQ+APOD5SOKNeT2pQVanF5cltaDntB2R3gZhq5a5if9Q3Bo1hu1PqzeEr0aYqk3GqEuvnd8T+q0hKAXrcFF+30e1eXUTaQlQ7jdvejq7Z+xx2+zS5ZT/JmkLIf7jTcgxOlFtcO1AmLS6gy98RLv+Q8qEvpjZqmOvfm3RLmEyhf00+TW9duKaqo6fVnMlMtIpO6iw/Lk3+gjvrKm8Wir1PG7tj/bGAfiEP0holWGVesZJ4GFTVBnp8tvj8p2lyCtH6CRrPueBXEa6hdEq0WsRGDJCbLEK/TLCgSLvZ8y7Jr4l9bBJxgW6iw9j558SW/IVJSdYgJMEJ/zamK55g0dSvAKswcGXxloqkh9qT+oJrBBcHrmq7/kzuHfO84FprCaPU5BhmiRoSNth6fjL5+ULtUHBt7m/sCmmx8XmJxpTgZ75W3NZEj0b1Mn0NgvVUorXwjUhnJ+P38YQkhlstRiurf4SgAmZbh0Ouj2d+KXpwfsb22kJ3GLvLvz3BTmLE/FW+tHP+hJEc1ykF8US/VnyeCUNpuiwDJOpdieTuJn0mTd5LvER59QOBRGEG5PYZy8bFzETu0X22O6WZkh5QrFm+XqPOvmuOqwYE0XaQHo9Tu/h06N8ciZZSeRhrFKNcTlsaDBHfYoRzBk4QDgiZE7ztq9jK0jatpccHGI+BGu8Y0UlDrD0xrOTMQjAj7TudQqtz81bQKjS3wSRyLcSQKXvqb0dxRIktFME/wOTfka6Furbq8UYC5zyfPbVIy7t57fcHQXtzDS3RxXZElyVXADVKXRTXfG2A3tlicfVXHo+E7FP8EB6fifaUIjzAP1a1GVEOmqvNiBXsCDt6dhbduU6GdcuhJJs5hyZ5B62Zb7UV3NzEkLEPj2
 ctHly042
 EptDR6TOcutdpO7A3Ney4nrw5g8KHng2TEdC2HoLbm420xo22j+0/iGjMtsl3oa2tYoSXd8mMm6o5d2WD4Fop6cAb5vN8rxn3YjlViUXzqDu3+BwdRFqZBUIJbbnWihNaypyajAO91coeriDVR9vLno3WMaYLZDLlvUCxFPNFssokeTfkcYi/m2sMurTIS3KZUqDHkGZVGjdduM3kCThytfbUo4Xl2aC02CB3Dxuc0YdEJ1fumRkXozNajXTFW2NkMmipFARLb0wKp8VkGjux5eUNeZv76mJtpgC7lo4vrzWzWsdo+VS6O9pGJPEAcypNcVhFAIpNgneaYLHlKWILIipTV0YnYhdTFJTYjUZ2DRvl+8U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the attributes only monitoring mode.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 457d6e8bc7878..6d79e7d69be84 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -316,6 +316,26 @@ Another way to do this for higher accuracy is using :ref:`DAMOS filter
 information in page level.  But, because it is operated in page level, the
 overhead is proportional to the size of the memory.
 
+Data Attributes-only Monitoring
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Data access is the primary monitoring information for DAMON.  Hence it
+:ref:`adjusts <damon_design_data_attrs_monitoring>` regions using the access
+:ref:`counter <damon_design_region_based_sampling>` (``nr_accesses``).  In some
+use cases, however, users may want some of :ref:`attributes
+<damon_design_data_attrs_monitoring>` to be the primary information.
+
+Data attributes-only monitoring mode supports this use case.  For the mode,
+each attribute probe has their priority weight value.  Users can describe by
+what combination of the attributes the primary information is decided, by
+setting the priority weight value.  If the total sum of the weights is not
+zero, the mode is enabled.  The regions adjustment mechanism uses the weighted
+sum of the :ref:`probe hit counts <damon_design_data_attrs_monitoring>` instead
+of ``nr_accesses`` in the case.  When the mode is enabled, access monitoring is
+automatically turned off.  The access counter (``nr_accesses``) will always be
+zero and not updated.  Hence the mode is called Data Attributes "only"
+monitoring.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

