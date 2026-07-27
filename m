Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E406EC531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E986B00BC; Mon, 27 Jul 2026 10:38:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B981B6B00BD; Mon, 27 Jul 2026 10:38:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAD6C6B00BF; Mon, 27 Jul 2026 10:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2046B00BC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B4EAA07B4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:41 +0000 (UTC)
X-FDA: 85034812842.19.EF38DC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2B4024000E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vy2NiFEe;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjqVhtQyye+bbFZP93YpIQ5LAq+rT1MA3lQj7bnBnXw=;
	b=bG4pEhrwpG5nlMX98ZAIFbirI0ZXXLd5ZEl6JMHojcqqN9nIY5924KUBQlKnNKe+c5EC3J
	Mxg6G3p9M/eSXfoWzIEygLBQnFnQehTLtOmcGQPZ7xfSRtvHPxNbujRdKMTeU5CnYuJL/D
	vivbsJUd36mxcdunV5ASz+O52SJdfWU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163119;
	b=nlKgiqNpgqDsQrxMPBU04QRqojs8iRFXkXRY5AARigelq9dwtXdPBZh2JGmX+PmjmK61qy
	cJwf0pKBLjv/4XvcnhZZPVBxw7FlQnVsDa8b4THzTEEfZzlA1gKcLVszXTzpmx+4MBDnHR
	Rak0MzjbForRVM4kTlIzuhGcydwL9Hw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vy2NiFEe;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4D5560A75;
	Mon, 27 Jul 2026 14:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B421F00A3A;
	Mon, 27 Jul 2026 14:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163118;
	bh=PjqVhtQyye+bbFZP93YpIQ5LAq+rT1MA3lQj7bnBnXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vy2NiFEe4e5jcWXxT1TnBUrVXckIaTIQbeaEdxEEzmrBwl/C+y6ZlwBHGl6dp8frT
	 sTFxJXR840JnUDk44qudbuU1OOFQp3JzNh8O5jioW4KRpWCLAk4aSwFdVQM2Tf3/cj
	 oi8FrWVrsQuezzne4EqnhWi7qXMWKmciBkp3h9m8hbkLemMW4R7F2fWdFa5kxKokr9
	 gtHerF476UNwQ/6ZrV1GVTJu9pQwbnqtgWG9BYVU/xy0xTQwr4DnRQvcI+uj8HqLgZ
	 Zl3VCrZX9rQ3En8ycMESUHiqVVx4eHtkRnjgv762/0FkEgbZpbE1yXgLvOv8akvlV/
	 g88KSFvhGPqnA==
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 16/17] Docs/admin-guide/mm/damon/usage: document probe preps sysfs files
Date: Mon, 27 Jul 2026 07:38:25 -0700
Message-ID: <20260727143829.86236-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2B4024000E
X-Stat-Signature: c18m6tnefngmqm6hihhp66r7y6ufdfzt
X-Rspam-User: 
X-HE-Tag: 1785163119-581269
X-HE-Meta: U2FsdGVkX1+32ZHzCVjqB56i/mFlYPBEcEoxjQFVzIXp+1J8ayndSC8m65Op9/fsybWW16vKggY0ocOoLYbz2Ar11YBC7+QK+iY/hD0dXBPyzmV5HXmcm2sf5y6q+yLCYIgntEwh4i3gG4R1oyw42azFmkPmuhNb/FIs3cWobKwgpB4ibSf7IFdHtJiMdvPE8tto5eq+L8e1i0cqLCz/qAbhfx+tye0u9ukuW40wfGAEPBOtnavbH484TCW5kcbdj27xLb4JVSxilhgbjzZXus6HAut+dFC4Wt3VXV01UoZC9sNfO15bPfH+xscS0Lkx9HbJ68QTRK6mQtUccYEEmx2mavuK+//yh8hsriPStrUEKNGRT1dKzifFnNs4WGVxr+c74JPjUUh7uE1yNR+2CIL0So45hdn62joucH+u5cEW9iXZ7LQblXkEmef7fJI1XWRR1zRHGT0f1wQuiIc1m0IeH5z2KsG+HmkmM1ufRHRK/tA+1WvT+BiJVG7SUlvCbwk73pCjIBwnCD96xS8Ip+BzWtSD5BxkwAutEamjuIeswQCoi0HS1dL7iJ1PwWduki6+m+FWgFwg6z8o0LU18KlPJlMzsmdtwj2tqh3ip+I7BLJ5UnfhE9l43te21q7J6iUlLZumjFiGbX2pFJveQIhLBZEfhyNkOp1oxh4zKYp44lRzqduPVM6/uYcyWJFX7jhGynt8ELnf+IIKc7wfJnp4Yb0GDe9kfz1w9U+XYHoMrfmsGCiTDJgOKMY50+/6hc9OPSJmMGCDFx0mv01U2UoMs3AxPRZHIFax0oJu0VIbKQavAB3GvuWvwY/oJiXOiADuyA5njZBS9OU1+bGMLyMrR4DDrPUYhCmSqw7FQd2Ljoqu6DH+emCY0rrTzN3R5iHOyYWwOXD2M6lxFtCdM8TwgVYmkX2LPYw0E10sTNQyl/JgQq6R1yp1/pWSl5H6apPHBpOFdgk6Uvch5e5
 AKrYjxJc
 u9sNDZKgtzQe0aqcK/9CscpaeQCaXH2ZSvuDpYgAdA0s1QxUBao2AJjWzzCENl1NrZ3a44+InCG0gL9LmFyvY/K8iM4A9z2jxC3mMDw/u0QaQw7jy8Humt/BBQw+T1tnkTpNT5ejCERKWZ836GnNdx/2c7NF5bn9AH/xvIhdV6oWZE+BeEi8IhohlOhcCBlk6FHYDJ6WGLH9nLQ2/A2SkaROUXRIaJoDytmjaA/P/7PUVUWxYXwLtjH0C8oWR/UrKQ+eLaxdHVzuhBInYrLt/4Vs2fb2d8o0wV1ia29dNBwT0Bi/032VDn9XoGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added DAMON probe preps sysfs
files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index da5f9afd08aef..023c6334024f8 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -74,6 +74,9 @@ comma (",").
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
     │ │ │ │ │ │ │ 0/weight
+    │ │ │ │ │ │ │ │ preps/nr_preps
+    │ │ │ │ │ │ │ │ │ 0/prep_action
+    │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ filters/nr_filters
     │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
     │ │ │ │ │ │ │ │ │ ...
@@ -283,9 +286,18 @@ In the beginning, this directory has only one file, ``nr_probes``.  Writing a
 number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each monitoring probe.
 
-In each probe directory, one directory, ``filters`` exists.  The directory
-contains files for installing filters for the probe, that is used to determine
-the data attribute for the probe.
+In each probe directory, two directories, ``preps`` and ``filters`` exist.  The
+directories contain files for installing probing preparation actions and
+filters for the probe, that are used to determine the data attribute for the
+probe.
+
+In the beginning, ``preps`` directory has only one file, ``nr_preps``.
+Writing a number (``N``) to the file creates the number of child directories
+named ``0`` to ``N-1``.  Each directory represents each preparation action.
+Each directory has one file, ``prep_action``.  The preparation action can be
+selected by writing the name of the action to the ``prep_action`` file.  Refer
+to the :ref:`design doc <damon_design_data_attrs_monitoring>` for the list of
+supported actions.
 
 Each probe directory also contains ``weight`` file.  Reading from and writing
 to the file gets and sets the :ref:`attributes-only monitoring
-- 
2.47.3

