Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E86C606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FACY3Odv
Received: by kanga.kvack.org (Postfix)
	id 900686B05C1; Sat, 21 Nov 2026 16:00:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8296B05C2; Sat, 21 Nov 2026 16:00:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ED1D6B05C4; Sat, 21 Nov 2026 16:00:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 551356B05C2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5DC6160583
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
X-FDA: 85460344536.28.74C2234
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5E09DC0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FACY3Odv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294827;
	b=a4JyZfW0CYGkoY3w6EE0qQw6OnzJUWPTjE8LtvDc3dAfNC/Snyh7DFX0hRJOOEFzj+JP6/
	M6lvDppc+RT0R+SbFp4Y2OIMNP0MOMVN2kB/JOz53V35Y7067OYtWSenrNOOqiNNKoin9O
	lQtNHxDWxgKffjt2G/bK4ny09quPlCk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhM0wpvk6HrSV8qT7cTup9dT9Z84UAe+LdIPivh0Pb8=;
	b=tKd324d0Lg1aiNs6o7Mcq8DuMVKh4CydWdziin3Gm+QByyO59lDtZWzmUU6FTrNQziPyqG
	4jp57K79spN/aJoELh+9eeKUKF986KP7Y83plHQUcQGwkguFQcItCBL9YQ/xwP+Bebso6h
	sFgN9vFdos4I5Gfg0tR2sROB1pKVF+w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FACY3Odv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3315261C79;
	Sat, 21 Nov 2026 21:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF65D1F000CF;
	Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294827;
	bh=xhM0wpvk6HrSV8qT7cTup9dT9Z84UAe+LdIPivh0Pb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FACY3Odv8r8pIhtlCkmgl3mTj84UPmuLOl2P7+rvoftobP2l/q2H+iQGRMrcRlx45
	 JJVvRFZP0kmtptPOCp1jsZD9HLGjnBh6TlegADLDlMY5+ySjo/68pzLQn/sXacZY4E
	 A8VoHGDa3TJKzikoQPZnrnzWj16vYt+/V4OWZO5KqZEM2wovcftipk98+PQkbP4Kb9
	 fZi0lKa0hILTAT+f0aq9JR+8V++CtkBipB6DSQ9sNAU476rufq/6aeB9WzoauxIiWW
	 UeuGcLsJekDK3rne/4k4Q1Mkem5ZTbqs30kSmgqz/xFjtiX+wrlID6k6+Zb9NLAk5o
	 wdX9aMy7STQOA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 17/27] Docs/mm/damon/design: update for report_made probe filter type
Date: Sat, 21 Nov 2026 13:00:01 -0800
Message-ID: <20261121210013.130397-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E09DC0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: a8k7k75xs6tz4sywxr1u3tjh9h9a6jp5
X-HE-Tag: 1795294827-810582
X-HE-Meta: U2FsdGVkX1/k/tkEtcPeI2Bv1sumWjKgKWECPsq3QgjjygmlFXwlM8bOa4t+aA6uKxcqoWpXRjTjztHfoS9THPHv/t2cpcyvUYdhZc82wdf+1qhcXPo4/POwcBdM4j/RdiJnleIVHbcHpkRL4gEksY7pD/BghonfUoh7T5JxkEabuFU71JSiWSyxfeR3XuNVhe8jWPn4/Iab7Nbby2v5e99N5p/1lzbDSOj2gMWzW+rvk6bM4PlKr8AcU9eKxwNUmxUnKCxJWSZyFULXiDYODdR87XgICztWCInQRAbp6F81tXzy6lFFYmAwUYF9sUc4o6B6SmGczNInrMQWGwJD4feLfrtQ3d0lIyGC3aUByuFPB3byrMTrxXll8TKZ9HDRQ+i7eTm0E99mXlpOvDmVjBpaheyPn8QcwOlUy/TNX4ccoJv5UPPbcId621w5rMXzYmvjGBAdI8Yd2mmRdGoUfEgJAPQfqatxYRWKsLeXit4r5s9EhaJA+oswBF9q7FOpuy7NNfdzACz0tYFk7Fwy/ULFYbg13rK/UpTFjvvOdK637XVjicy6gesniiIOaDZWh4kT/ES+PA8IPe9zyl6KEZv/HNEsQiCeVEc0U2TcCcb+Mf5tXjZco/lQ1MxYY6AlG8E16kW7Q9kbyKjN55Z+AN7moaHMRmxj52TJJ7UlT2tztswV3LOD3PAzlEtdOpFAPNdZBdDyX0TlfbrK8/5ywlrlNPULRYYduXGzqoVWDFvjXr7ZOeGCnv833kqpd5DT8ScAXnSxlC4+nSLL+HU0GcEMar9LKCNurs5gy+xNgAjinbyLC85NpT/MaKRGenDKa+aIN5/Tozk+eC+WtYm64H6SkXhYa9mqZYAvaH8GqDzKv+HgyAmZzUG4mFo6f00hKribdKZyWhcEQkjrZTwYWRvNzZHcmYJ9ajmBcPUV2viloZNgl0C7JwkRnA+jbf17S9il9XbEvlemcNAXFWU
 X4gQilJb
 pZK6Fnf/0xe+pBXk+9og4wrIQ8021df9uumLfZ8+/KhkqLSDuPwUieU/IrCFiEElPCbAQuCFOwhNd60hrEgMkrKjqGeY0DXi38VYumnaQ2SDLy8j11VwP3UeQ26x4f0INJgHwJ3nfcuN/bo7AdzrYjUsYyTY9fzLVGdy/6CSl04nW3NMfx5ACUEw5sy6xuYEO0cFlBb63SKqC/mwQwI9znS2BsBa/7i7e1p9mrjX+g7yGFnuq5o1wMypgP2G9BA0QiA6x8FWPLi9KXYu5CTd+0WCa1cs6DK62i9I5fT8rCovHWI2uOwI19o/pthCi/IRZrPCJiN7XdcfKCqQu009X+m/5B+oDrsAhFVi2XanU1ETSU9L+OVMueFpHUdRh3vKnxyqqn7iONzIoI75CWKuw0d7+wWDa4Vl8r5W5OqS2dVgCGIyBzi6TZuFbbAkTFdolA7apEi13fUyHIjM/n4zQhr2zu3K9Na+LPwYVRdR6lyfTyeyuEybJIGzydK6IrhTk4e2u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON design document for the newly added data attribute report
existence type probe filter.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 5a75a69021a48..31ca623385718 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -303,6 +303,8 @@ supported filter types.  Currently below filter types are supported.
 - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
   of a given size range.
 - ``active``: Same as that for DAMOS filters.
+- ``report_made``: Matches if a :ref:`report <damon_design_attr_reporting>` for
+  the memory is made in last sampling interval.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
@@ -382,6 +384,10 @@ depending on the type of the report.
 
 For now, no report type is supported.
 
+The data attribute probe supports the reports.  The probes can be configured to
+hit for a given memory region if a specific type of valid reports that are
+associated with the probing memory exist in the reports queue.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

