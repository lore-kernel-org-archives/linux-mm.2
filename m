Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62288CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2226B00D3; Tue, 26 May 2026 09:42:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A116B00D5; Tue, 26 May 2026 09:42:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90936B00D6; Tue, 26 May 2026 09:42:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 989616B00D3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:42:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3DB4E1401C8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:08 +0000 (UTC)
X-FDA: 84809684736.26.39AFD1C
Received: from fout-c3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf12.hostedemail.com (Postfix) with ESMTP id 522AC40013
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=O4qHJa0L;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=bPwWgEBD;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779802926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zBUCE6XPDUoHMvoGi0VrfXMvy96k6/ubKzatZEhS3eQ=;
	b=s7ESV599A0OioMM64Hj7YBEflONYXc6avvkXD2K/8EKJKSogpZpFb1IDc7st/NZqVyuqla
	ZK2zlxqZBG+Ngh1R8TnXKRM12OqyCFBGNP3DKdn0+omQvvJrmajLEHMwmHTwXyRzD0e8Rl
	xumhr7cI1cpUhIV0FWGEMpBSpEpQxWk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=O4qHJa0L;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=bPwWgEBD;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779802926; a=rsa-sha256;
	cv=none;
	b=hrTyHkROOyW9gtrUu6jCEv/54Qo2gSGjKJMwVBlx0unuNaTf8QrZuia2OLg7Oose2CHOJB
	Ax+43AY1wUzDP3bp6A71T3cAzJhiEtrxWngBV27WuU7j3DK1dfVKbIPfvpcIGUt7BK7C08
	DYlGWfW+qMo+P45dPFE6LulKT2JUmhc=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 281201D00136;
	Tue, 26 May 2026 09:42:05 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 26 May 2026 09:42:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1779802924; x=1779889324; bh=zBUCE6XPDU
	oHMvoGi0VrfXMvy96k6/ubKzatZEhS3eQ=; b=O4qHJa0LlCiBQM9u4ohssAKvF4
	6YvJRo0oBAEGVRz73X3dfkoHwlPBGeUUGRd5ScYRI7/6usLw2qu/iFels+zL7bn6
	BfKKaudsSKoE6F/DlJhwsUqefHDErOIP261sTy4EEZu+YdDsbVuI3jgLXogd840M
	WreVcAKU7PmCW602vMDfS8X0zy9VL2xXYCgtgAI/UDYqdHGPl58KaMGZRlTDoMv6
	pAXehyBECCkqI3BisPETtFUJVDFOq82JEwjD8R35cRF8iXBmdtK2j1Nb4v5M/IIk
	oVR8hHQQV1xw80AA3YpFO9dQ7YyC6dj8qrhVnOYsNlJfdhy0YXXCK+CbkR/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779802924; x=1779889324; bh=zBUCE6XPDUoHMvoGi0VrfXMvy96k6/ubKza
	tZEhS3eQ=; b=bPwWgEBDK4QVe2+iR6y5L0saHMRvx3tITyddIxveYXoEgl6Ufnd
	44RkG54JKIjnkEPaqVyLAP+8MPbvTT0JY8nrAhoibSeDcm+ycBj5WbCR0upqur8v
	qbweAOy/9usmAhx/SdLXL4lzM7H2g5CUnV8YNrW2UMVJsPloyv+gLZmQYzBsXoel
	fppEeupb8YfusfH2HYiSFN9T/TxI+7GS06iwQrrTv9VxwGu9XiCphdfeRMXPr7fl
	2uu6GdgaNIJqrcDquZOXlSjzOgriCiygC2loy/8fGo4yfUG5QfHFvAGfmvVlc1ht
	QnE5zsQCe96EoXU+lxMPzI+U1DeLa2VcwlQ==
X-ME-Sender: <xms:LKMVaqATU354xalLDM9nlBwdb4GpoFOpSbsC-64VWySQQ0sWEqy0bw>
    <xme:LKMVanH7NHesIFfpMKEESAJ-JRbqFAI1QegGX_XnFsDVz_zwdEZo5fsiOgiH_zep-
    SeiE_cKKD_hnElxhkxTOGdKB1GQz6kT8zq4xP2bZs1bPIjHFJ_JFtS3>
X-ME-Received: <xmr:LKMVahNqwKxM-dz-ysnIDvarxzkmMoMaf0i7no72JDWYDjmtlpBPxJIHMtvmtw>
X-ME-Proxy-Cause: dmFkZTFmW/hFcTNnzxlDjoX7gVDxK53FvI9aWc6JsyW51xajIju1oU3qhaizmUtiElI+lL
    r6xTZMSyW3U3HRBcZUReHyqEMJWuCVat5liN1gg/9LzPivQfiTe4sCzlpadKLK8GO17j13
    yEQUMAUIJPxMaPxsJll6LpCCfFttl9LX07IbdLY/0MTxhIk64cy5ztiUivEvBJuGxwOSTP
    65z9K8iL2sQtBLOt1k7QiK0CBqKnbOivXhXhmkmUqIC86fj9Q/tLRbmA770O08ofypFZxx
    5XngxhJHou7y+BegZq1/PIRykPwIlZ/MZxupfTJ806rYmB/sPPXQk+LMkZoFRGAqQKTGka
    a/LRW4kklAF0HfwEzb0rbQZXhG05KyRrU2Q6KtKyz7MrX5PxGLnuaDT1U5L2LLi6bC56MJ
    Bed0WrEI0KFWrYtbPl31U0YCV0vhUqhsKXuh0cB7ihPsiTXgiUcXDUF4uxWhy9v4Ier7p7
    mTkFkTLxYHH8U2Tiz9xO1dDY4tfREIV4p8Xf0O7gRmX0XUn+3zY6MtWeaOOJ0teS173uTT
    oaxj8rJyRBUXO6lt1VWDUFuoofvEfVpG9AyZQNzJjifhpOqeJMcWJlyqbL4GTBHpCvWDBf
    yUT8wK0HVHbU7MNet/qZJ4y4lpBFpEwiwsSkSE/okaSN5ZsBStpXTM7EwspQ
X-ME-Proxy: <xmx:LKMVao7xSr4x7gxd5utLlRfq8R-YHPpxFP013RtHLjuV_LidFBSjLw>
    <xmx:LKMVakidVq9Kw1J3zXgB2mQUt5h3mugKkffwMRywZYvXVgiqzBr51Q>
    <xmx:LKMVatddMfl0YNzNp6sa8NSzTpombhqRZ7t8kxn0BudstL6ZoFZaiQ>
    <xmx:LKMVaswajzF9jGAjPyQ9n7KyC9UagUkHMR-jZ47tpjb6Tf5tkZy3Og>
    <xmx:LKMVapYp3G61uiIapETj7FaOuCmLA7hncas_6niO-LoLPAMQGytIK9Jf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:42:04 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: alx@kernel.org
Cc: linux-man@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	kernel-team@meta.com,
	Kiryl Shutsemau <kirill@shutemov.name>
Subject: [PATCH man-pages v2 0/6] userfaultfd: document read-write-protect mode
Date: Tue, 26 May 2026 14:41:43 +0100
Message-ID: <20260526134149.2831720-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 83obyzg1dq8435muf85getg7xa4wi8mx
X-Rspamd-Queue-Id: 522AC40013
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779802926-788080
X-HE-Meta: U2FsdGVkX1+fmMyahuAbxSbgR9VuWrtzpZJKPguM5HI7l38n8SKBrVitZ+6kGx3JPpijVt9nFEmbTRZRa6mES6kDTbmX8uwOe9v0vBGi6DtEtZWkRx+TmMFH8TF/ffgys/UdXAHpWozpX/eLRpakcnQ+AkUc9mDIC1LdADEqZGbp3mZd88MuOhncS0mlvXx/s9pCIFpOUT+vgRGG5vogHC1tTszFc/YBcPlTU0aEtagS2ved9FT+P5tDci3DnuE3ilLG4z1iifqby4dYIORPtEvTzvHd9NdOqHrrKXnmU/mhdcdT1M+CkNqbk7xsghJGQoX+AMs7ZjKNiZbWoSx7l9uAYpmp0mY9TxJSJ/QcxrB45O4wfJ0HKttWajGmRPWSGTD2d01eqefDpAAsDDXN/NXqNhsaWP/qYEPzUsovE5YYTpKNSKfRnxmFG0mdBXEYvhhMiel9Crv4FN3/NVpPAvp+DvlnFEVgg5CGGjC1FFGqpPlTqUlUpATOVhBmliTKTM5JkfttCmUK5IR7uxfXaCvzk+708gjA/bUiBFZaHaW0quEq07BbxMdTAwHNqdruWhANSSUNgca2/TuiZDVIS/yVOoAYU1qLAV12Nnzd5L8BzqT+xO+tQE3Gii7OXyLCbKF+Q7mWEJSy5BXSBrQdvM6ZOrr0zmLuUA8/QrOyo0TGA5wvW71CE74J5MCm+8rQeTAxyIZWsefrrSktBZ+HqCrjSVsPLrJEUy9vHk9cBJWaEEzCNJb8ha10PY1xkc2uil3l9wGRlQZAB/+GAPJmE8S90+TPbsVwIWVwYh/g6jYJFpeKYSgjA/yN4c56qNWqRDQ0mTqeTh0mw+m6/zKeIanln1cLnjWv7vmAwA20/2bT9keHjmxJBsRykWI6dD5U4xJ58s4ibuGmp9UropIZEkj+45DJkfjY66I623pnvwoVUhOqKRbjia6hJ49pbi+qr5DvgG/frLf8mp8LSwX
 VoXYhuUH
 zHTcSGX5oJjqHILVhhg5/jp8fdSDIFtT5gwDPhHBm5XKYeo4UhWuMGdZi+Gp0OBKKA5Lyv6LoEWkSROmA/S+5RetsER6aASkDXI6Io1Qq52go/9AYtT2Ier/Gnsb5SdKBsx1bfscC7l8Qc6pIrnH+v2wDtvF1Pgb27r02iIrMaNwfIq3oT3ajQn2aLXG9OX5UC90pRMfityaKC840uCOoHNhRgvhZIbccwiXqBJBkK37fPW07aChoYls3nEuoV4FKggSt4hNZBjvmy0b4qSox5bTiqaX19qd1P4EA+DF+w2diG7X28UaP7nNZ4dbJE09CY6k1ddrCkGI4cMfaOQU8RJD5VgwSfIVuEY6xXgEG3Q1gLDncLgQtlugXKg3h2S6YJj2OGnB01yOU9oF6HpG0lV2O+5VPeymz69qmhqUZ1NouOlB18wfRbPMP9eAaNMSQgPk5TLh+ZoSc/qJvOVzJn7p0zwptK4re3bWZsNn7GDAf3CTJ9WFJbb1FlgQ45aLT4Ojl5hT2qwMznWlske6Q42otArMsBuytb6wtGiALCzAKY7yrDG4y1ECke3XvgTIFvqo6Gxvy4gqZhE5QA96vP7sdKO9RnD4Rl9chtCfJbX02KC3z6qIlfQlRgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series documents userfaultfd read-write-protection tracking
(UFFDIO_REGISTER_MODE_RWP), a working-set tracking mechanism for VM
guest memory landing in Linux 7.2.

v1: https://lore.kernel.org/all/20260525122816.1956804-1-kirill@shutemov.name/

The matching kernel series ("userfaultfd: working set tracking for
VM guest memory") v5 is at:
  https://lore.kernel.org/all/20260526130509.2748441-1-kirill@shutemov.name/

== Changes since v1 ==

Addresses Alejandro Colomar's review:

  - \(em -> \[em] with parenthesis-style spacing.
  - Semantic newlines.
  - "user space" two words; "By default,".
  - "returns EINVAL" -> "fails with EINVAL".
  - "read-write-protect mode" hyphenation (1/6 subject too).
  - .PP -> .P; awkward .RB MADV_DONTNEED line -> colon-list;
    one identifier per .RB line in HISTORY.

mandoc -Tlint clean on all six files. Mike Rapoport's Acked-by
from v1 picked up.

== New UAPI documented ==

  UFFDIO_REGISTER_MODE_RWP    registration-mode bit (UFFDIO_REGISTER.2const)
  UFFD_FEATURE_RWP            capability bit          (UFFDIO_API.2const)
  UFFD_FEATURE_RWP_ASYNC      async resolution        (UFFDIO_API.2const)
  UFFDIO_RWPROTECT            install/remove RWP      (new page)
  UFFDIO_SET_MODE             runtime mode toggle     (new page)
  UFFD_PAGEFAULT_FLAG_RWP     new pagefault.flags bit (userfaultfd.2)
  PAGE_IS_ACCESSED            PAGEMAP_SCAN bit        (kernel docs only)

== Series layout ==

  1. userfaultfd.2: overview, registration mode entry, new pagefault
     flag, VERSIONS line, and an "Userfaultfd read-write-protect
     mode" section.
  2-3. New UFFDIO_RWPROTECT.2const and UFFDIO_SET_MODE.2const pages.
  4. UFFDIO_API.2const: UFFD_FEATURE_RWP, UFFD_FEATURE_RWP_ASYNC,
     and 1 << _UFFDIO_SET_MODE.
  5. UFFDIO_REGISTER.2const: UFFDIO_REGISTER_MODE_RWP and
     1 << _UFFDIO_RWPROTECT.
  6. ioctl_userfaultfd.2: reference the two new ioctls.

Order: new pages first so the cross-references in patches 4-6 link
to pages that already exist.

Kiryl Shutsemau (5):
  UFFDIO_RWPROTECT.2const: New page
  UFFDIO_SET_MODE.2const: New page
  UFFDIO_API.2const: Document UFFD_FEATURE_RWP{,_ASYNC} and 1 <<
    _UFFDIO_SET_MODE
  UFFDIO_REGISTER.2const: Document UFFDIO_REGISTER_MODE_RWP and 1 <<
    _UFFDIO_RWPROTECT
  ioctl_userfaultfd.2: Reference UFFDIO_RWPROTECT and UFFDIO_SET_MODE

Kiryl Shutsemau (Meta) (1):
  userfaultfd.2: Add read-write-protect mode

 man/man2/ioctl_userfaultfd.2          |   4 +
 man/man2/userfaultfd.2                | 174 +++++++++++++++++++++++++-
 man/man2const/UFFDIO_API.2const       |  31 +++++
 man/man2const/UFFDIO_REGISTER.2const  |  24 ++++
 man/man2const/UFFDIO_RWPROTECT.2const | 122 ++++++++++++++++++
 man/man2const/UFFDIO_SET_MODE.2const  |  98 +++++++++++++++
 6 files changed, 449 insertions(+), 4 deletions(-)
 create mode 100644 man/man2const/UFFDIO_RWPROTECT.2const
 create mode 100644 man/man2const/UFFDIO_SET_MODE.2const


base-commit: 9a4bfd0e50745c2649b6291db40b58e37c9c1c6b
-- 
2.54.0


