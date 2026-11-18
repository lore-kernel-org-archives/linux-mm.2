Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E322D606A338
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IUbRBr/X
Received: by kanga.kvack.org (Postfix)
	id 40B016B05CB; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E2526B05CC; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AAC56B05CF; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F206D6B05CC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 995F31C37A0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:40 +0000 (UTC)
X-FDA: 85446641280.18.A1D1125
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9BE8F100006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IUbRBr/X";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968558;
	b=Sdco6BnEUTsPD1exy9jsCU+Yzj5K8VpUDUG8lGmV8tO6PNrObIufOehoT8FKgYPidU+twC
	ikWPDyYvlbMYCpgFNS695DDhfw2XDxbcew9MwBj9eIuZNSejXF+clmyJC14+L/I+Q+mUpz
	cYOPNG5txKbxpxoYV77DH5h6slxBR6A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhM0wpvk6HrSV8qT7cTup9dT9Z84UAe+LdIPivh0Pb8=;
	b=sBpAQmJ6YBmvpSFSi4c4dxIVtZ7H8xSVAYk8bidcURI0q1HUQr2TuLRsCZ/JbC/xhUJ+CS
	KZKWC2W/W2PUPo4hhA7ugqmxu5LZYKXIdqwa9pEvZSeU8pnCjw5WIiaYQtyz8nIi9yhRxl
	wPT7u+YJUjA0QCCxJnUbB9WyFNJgHfE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IUbRBr/X";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C74D4075D;
	Wed, 18 Nov 2026 02:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1204E1F00937;
	Wed, 18 Nov 2026 02:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968558;
	bh=xhM0wpvk6HrSV8qT7cTup9dT9Z84UAe+LdIPivh0Pb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUbRBr/XV2gsZZvAvde7FgDlNEltzdLuUysM61B3vw1NR4ukUsoVQjsIFw5Hfvgt3
	 kBdZSY79+CxXBvBxnHLYqgFyF51ijM/5FXQ6Bpj0+wve0oiBJM6YVOhXI8xBHIFQZq
	 b6UY0QvXihgylGdkBh7myElKW/bz7af9klHgEFvY/vZDCgkoGS/celJkgi8c/gKgC3
	 OKk5NAOtOn7hqBDB74iSYVVQFr01tFpANqVGqCiO6smjnaM0i65Lj+oN7ws5Zapfap
	 4O9woMI7t7fOEaAg4mHu+DSvvM7cdSbgKzlaK76C+RRQxjtRItCtWiAjQyc3rk/tI4
	 eJW6qntWmmP+w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 17/27] Docs/mm/damon/design: update for report_made probe filter type
Date: Tue, 17 Nov 2026 18:22:12 -0800
Message-ID: <20261118022225.100659-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9BE8F100006
X-Rspam-User:
X-Stat-Signature: ikf7w5y9cry9jiewzurjporycxdqkxss
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794968558-373856
X-HE-Meta: U2FsdGVkX1/4C98zK09Z6Aqt4UqN4GJoh8orzp3s9gfRMg1ztvTumyFRartUGyCdgYxkaB14kSjRNbpfn3d1++/fjfEs/vxwsBX3uK5rw9J3ZIEiKWml8oUnsvAwZP4l7F7f8T8LsTjHHF940gFWBeiPJoxoOOy2xy+sCNMwrMEKJq9oluYFLuuVlUElUIfFtVFuMuVTL+NGev9qfCXasdFnm1Lj99QEA/7cPvaKq51d6vvWEmRIMzohbZspVi7E3KUTxGtlcbkN9jsObTFG1HcTwHjFPNLNXxRALjLvMtXk2UDz5AzXb5Guwyygt2G0FCg0TJlQmUh5gvPRERpyNsa4RVx/2uCwSH4lkpfdkjXxm8FdrFScxOH9uMar9mwhjPB9+2kue5iaRWH9XXaefj0exFbwq2G7Dykc2FBuJ16888N2saXnB6xEVGT3LyRDH7jDi/+MI1AMylgcHYF5RINMz/2qiLE8yIE0S9Y2vuTlMcuKOJ49l8AZwOkEMTV89vz0z/b051lTaFBMstTQhig4p/DNxVThoRlP10pVW1T6hTD/KowMkmlvnvaj75RhVjd5xuns0rfv/E7IcgXSeI/qAw0V+0Snk4/WruJPhnrG5JPv0fi8MC2a3NbRHzMCR2gtwlxNPTCWVdeQlvKWg8UHETTsHearnYHW5jjxGbOfQdAbUWDmSzDagl8ox/Nm+xSgI5uxiLnC9N8Glp5WwGuuCP6sosdiIMwLlYoPgjBx0MQgf36sAh9hL0/X2iaF0GO0GPAmA61VyI0zoXqSfOvh9wc0abm4OMnyRKnYfGF1E4kyKhUwAhOBjZ86VHLBj5ZzbeLjRCCbMaaP8uLRJFtoXdbwx+PZkqC3QRbqvoiC8rErSvD8wVwl+x6UDlncjmgqjpL8loLCIIbKE3JaZQ+v0TYASeh6Xi+Ycu5LaycQYUtMz3i6l6QatPBIFyjEVEIjSOdJ8zThD4Iz/XG
 C0wJPrcR
 IgOls36mCwFJcXaRqR7+7TcoKr4fGpPqzWrafhL3IbB74IJhXZOdV20BKUp6SasnJYUOpE0UX15MwucQR6pUy6IaB5DkNXVJ4JBWkzh+IdEO7xuVd9jK5JiOL7w0MR/pgJP6cKCX4PL35U1N4QMeU2zcTlmcJUVWWjqQZbOM2FWLi5nwzhYQ1/E23M3aNpwqdMdFrgz7kh0cL5O8Z3DWgofNCYz6+knk9DEf0Ya+w2pLHGdN1eJ+8301Ek+OMUS/GTB0uQPAs7mVNgYc8kEXdLMgHoRbxQAfPaw95JRu2WMTH8QGVqreWSDGSiWzlt2C3naeqLIHd3VtHxNkqvAk/dbpYbCmAY/t7woMNKuSPxlSuo7wDFWGnn2DqTpgAjnJC2pPA0B69d8a8ruI=
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

