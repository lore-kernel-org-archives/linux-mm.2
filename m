Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 014A6C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F15B6B009D; Thu, 10 Sep 2026 00:03:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C98E6B009E; Thu, 10 Sep 2026 00:03:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DFAC6B009F; Thu, 10 Sep 2026 00:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F9366B009D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:03:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE31B1403DF
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:32 +0000 (UTC)
X-FDA: 85196508264.20.53DC343
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5937314000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RpWI6tNv;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013011;
	b=BoR4dqbEpBixJFrcjb8CkdlxrKBFhPKJ1RQcM59nkEF3s0QsQeiBFg8hsqTSt9ZgwkagY5
	9u3LPuZqgs9/8XfuJl0X2Ybp8zj5dyyPLlX31Xe0OMh7pwXBAOjHiqXYcikQubzgIqQ4/1
	bJqUFaft5Na6BCXzMXd7Iq59Wk3RPxI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RpWI6tNv;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/q3LnB7iB4S2lxLwjnJON3GEVnAZWX6/MrZWM0ze7E=;
	b=XVyHuwExPDk4tmcS8L5UtY2VF4TE49/dGQvBnVR63OK+UuDB7Zxn5+awV1wwb9ap5s5wd9
	n2BGDR9FR33q/Vh9obRmQAezqMq4fep4xC9KCrKlZyKAgVqK1tufS9GmewiX7mo7coXHwb
	nvMXE9AWwxzr/SGa4IvL32Ux38ZxM/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 985D144796;
	Thu, 10 Sep 2026 04:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5ED1F00893;
	Thu, 10 Sep 2026 04:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013010;
	bh=0/q3LnB7iB4S2lxLwjnJON3GEVnAZWX6/MrZWM0ze7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RpWI6tNvgvWTzO4BrOIHfQxzMwCpsBSf6iQt37YryEJ+3MipCGOhmc45wQ3Xk8HKY
	 VV45/IGLrV8l+H3svr8ExoPuVyXIvBcAdO3wni3d0JrdFVSPwYnxJf6b35/T5u1vdD
	 VSC+zlXnIMwaLWOMmst3JVoYcfzuXIzIT8x2RFT67gcEWJF+qQsccCNU8ZKmL69lx5
	 3/e6FSduRg6Q4shY4beBcbf+roTCu9UpwXasGNFV1yrEwwo8Wq43DVDgbaWSbfai7q
	 /wIOKWa+E+m2vbp72DmZbauQAFFO5x2r+bbBt3GKn7QSrxvOmnBGogjR/a1iNH9TXP
	 9T3FaI9Lk5pEg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 7/7] Docs/admin-guide/mm/damon/usage: update for probe_hits_wsum DAMOS filter
Date: Wed,  9 Sep 2026 21:03:18 -0700
Message-ID: <20260910040319.147037-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910040319.147037-1-sj@kernel.org>
References: <20260910040319.147037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5937314000A
X-Stat-Signature: hsedxdpa9rog9szptj7xpdm9rnzjct4s
X-Rspam-User: 
X-HE-Tag: 1789013011-491475
X-HE-Meta: U2FsdGVkX18MXlKzwI7ouTS4fYkIXeA83NNJtD8Fw0uXlgIFryDmc2HtsZmdjCs2aUmXg/phVEv7ZH5OgEOjSeWXPfSxZUjeiUX5rjxbuhf8lS6c5RzjkQVIsVTFg3iTJpIIhVwGn0lu0S1TSidTQO5hKhSbX5Ci/5zTeNYK31t/8KbpvUpq6QNZM+lowXa0nzKFiThw/GkVx2aiBoAIpw1+K2FCVR/XyY8j1aCRJMPmIu8KaHKEXP938MHnxuY3YWmSMWkUmA/3QZoUAGJKSqu06YhEbzYnLDzUln9rNal1qs2ywEaFSoFITPJQw2hwEjel0j/pTVpIFtsh4PMpeqflvO+3FCH1L/iVOtiu8rD9+1eQ59MNZ6ZKCswKBx9N4oEJ9vj3/Z/B6d+9rfRd4UHxthQhqyT79d67CR770U61VdU5hsY+LoduZhw+tdOlg22MBo2Q5Hzs3jDbhSrAIoF8zvgG7mABmAwPFdygaRxUF7pfsc387/nSQpf28FhwJSqKJbFCuN6vfWyN/bHaZ6ByGSPlDoKeADRRK8bWhKFEyeHc6q2WgE2H1m5Dn1rNibJw+x7eg/6NrShsttt97CapJmSc1FyIdlDDOZ7hEP+JXiw8CGIYSvtzp1Llo+abLxw8sw6Zu8TUc65h7IxqnPFN9O7LrpxL2rb0kY+Hpu7kJEPDmrTZu/w9xacaHqsVdM3haZ6BW7p1Dv+ZplI/NxSqH5qAkgWPJpVefwfwHOCW7W9+GthWAH+z82fkNWR/gAmE+vkkNIpXWgsBfEBOEDIMLbqbk5hdQzQE4yYhG479KlKi2uHdyKGbFI5HjRCgz3beTw35jBJnKxvV7S6cx8tl7o5+fT+j63qTYQ8DYVb/U2BG6l5mJszGM7P+K4tmJoTGeST1+84Zr5ZRFlq+Py3JJAlRhyLyPAQ21CIL1rxqvViaoQUIA966lqDV9+YMy8bePOPKgKdHRAClOmv
 5TrNmxhz
 A1oxexpLXX14cIyqUAiaOTfPtpJfq/v9ctfxeD7FmcW2W8TwHKR9WCoc1AA5AI3q2pXN0NPfGXjR2s5sxyrfewavdQskVYL2yz9uDuto1x4NHSJ21qbIET6Yha5NxuABQjqjbFWwrSTd3wmKJvBKZRZB9R+sRrZFylF5mqSK3D0+jGBssPAC8QcKc4KThkcXhf1X8rEPSnTyBtdIVa5lI1d8VkaEN6vJIfbDzzUiVIXVOCftXWsLVmZUnBKYxfJEiw5SxpUIwdeWLsv4g88vmy/gooTNJ+RxXY9Zu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added probe hits weighted sum
based DAMOS core filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 023c6334024f8..d3e37400367bd 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -551,6 +551,10 @@ and ``damon_target_idx``.  To ``type`` file, you can write the type of the
 filter.  Refer to :ref:`the design doc <damon_design_damos_filters>` for
 available type names, their meaning and on what layer those are handled.
 
+For ``probe_hits_wsum`` type, you can specify the minimum and maximum probe
+hits weighted sum value for the filter to ``min`` and ``max`` files,
+respectively.
+
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
 ``memcg_path`` file.  For ``addr`` type, you can specify the start and end
-- 
2.47.3

