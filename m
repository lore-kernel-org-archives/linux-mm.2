Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 767EBCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 12:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8776B00A1; Mon, 25 May 2026 08:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703C06B00A2; Mon, 25 May 2026 08:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6199B6B00A3; Mon, 25 May 2026 08:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48CF46B00A1
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:28:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C10F40240
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:40 +0000 (UTC)
X-FDA: 84805870842.09.5D006A1
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf04.hostedemail.com (Postfix) with ESMTP id 22F4C40010
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="O UORhps";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=QkGPupTq;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779712119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UCI883UKV5IeLX9V5yH4tQjyj41+l3U0FlaIxMEuE8=;
	b=FOgIYlhYGmzU17AJkiorqLoSqcrRbS5HdLrWmBXHPfeTFhMT6O3X2YTX852yFeNUNtr93w
	f88vzRuDuPjDjIbP9L3f24bK0Kb8AHcnvDfmxBQTIPxDiLt9vafPOUJxEKzJVn6JlCdFCp
	8zaPZYJNK/kYVFnGYxu687kim7yAHaQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779712119; a=rsa-sha256;
	cv=none;
	b=NcnZ4j56npL0+r4S3Rjw6QxLcTkPKPfZNz1GEwdnRFoUsJH4QxYMMNGf0QOsbgcVWjaiPb
	EJzQVS+hD2ajFlvuxudf3/EwtCFpn6qRJZ+jFdSJYoCf9l684Im+bY+XTEW27RBIJaB7Ri
	A19fFqTkWTK7p4uimEOGzxCnfAxspUI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="O UORhps";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=QkGPupTq;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4B4CE7A0074;
	Mon, 25 May 2026 08:28:38 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 25 May 2026 08:28:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779712118; x=
	1779798518; bh=4UCI883UKV5IeLX9V5yH4tQjyj41+l3U0FlaIxMEuE8=; b=O
	UORhpsx9c5QRCKxvNKVe9AJO9eY37joflDQn0sDBokaiVip1EDe0YRHDmdzD0Wxp
	PZOvMIGzyCi9jPvRPdgawR5SmgxlNu2Lo1V8cPMi/IJWAdbAEtGh3VdPHf/Fuohy
	O18rkqmkiilC6UBsc913DI7ET1s+8lfPHEl6FLOVwsqe5QDaC6m8ihTsdMLlb559
	Kug7LvKoDxWErrIvTxOMd1WUXwva55UFGSEfMi97wRMkGBZRAmeU5hETpBBYHJsJ
	E+omoeKg53Il6WkT65z4von8VkAYL4rPoVxvFlG5kMlk1a0JOyTKC0nATF+/G8GS
	hg8Iwv3eiJxfH8A4SipbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779712118; x=1779798518; bh=4
	UCI883UKV5IeLX9V5yH4tQjyj41+l3U0FlaIxMEuE8=; b=QkGPupTqMoGsrAR3q
	Q6n6zyRbTeTzt175NV4moLusP6A3Dxn5ZbP2fj6RSGw2w3LdgL05Tg/RUyrzOkl+
	0hwE3fyX8JXCwZ1TFpWjLGjKfesWHrLh0532QdZRoYj36ZBchfpyzd0WHXQqrbJu
	OLYVhrCkNCehH/HzVykSQVygsZxXpgogdcwZlxVqqLp/UaoK6TFq1d4ug0vwBoNr
	KHRftxH+SU+TBEwdOKJZ7OqHPgol+boxqVVwbqdti874l4E7SY3URGzgtiXhwhBI
	ciXXqOQiTLASqMH8Pz2rv5LU1WDVT4SeV7cgsGnI6qDxoY/GlasxI0nSUmT3Vg87
	ymf9g==
X-ME-Sender: <xms:dkAUakcr9_I-DF1u9QyBV2DIiyENay99FqcHqneOnRVkOo0ZXEmK0w>
    <xme:dkAUaiweX3PY-hhzpgx88QZH5W2lT22gbFCxpAvHkeYgdORlQeSYxzT1ql1KXU1V-
    PFiMQqYNUUYUISOshGxiIC_ou4TgHliGy0Gb-geQybj5ZO6Z9tDyyQ>
X-ME-Received: <xmr:dkAUap-Z0QDNUwLd5l0hoT7m01WYgpQwseiGqb-EzaykZe3YJniKJuk_z7q2uw>
X-ME-Proxy-Cause: dmFkZTFmLVSfYhEWaVm8N1lz0MjOBghKLhOnNQasw0tsXAFLPpbR/4+mrCYwWk/E423Vc2
    6B1s9iPuQgs3hGAiq/KhPqohuBMRIerNkWvsfuc3WkOHbHUNY5UmaGor5ig336hIeD+vak
    qB6bs2DTG0sfepDSzSArpLeFa7+n1qOspSUGgNQVB9KbSSFSgvHhLwD2o5NL2Su7Xc1htX
    UOwFpxHBdUGOki2ZYo2cYxe64jTF4NfawVkw4Ja9Vghy7E0XBO4BxqVYRhKiY6uJ4G3d/o
    hkvinoVmY3c44Mzh6S5sf4JfJ6aY+LIcesX0uapyNnoENtY2BlNnzIGDNJPpi4n9s/a/UL
    dSpsWW/8nBXvFgGBrz6dLhQdKkoLtHbkplQJ6QQvbRgWfvpQWMISKc4eJdXhEWnSNaD0/3
    qtnSolhNUM8DScWHAVBc1parFGL9kCBHiO3SS8pHbjbGbQS62UBRafqY6MYtQoYyGZb8oM
    GjdrK1QlAmH/I2HPhb/GmEqAcimdAH2bPWfWD0Ya+vu4Do6ylmgsnpjmLt+jn/zLncKLuV
    lS2sZZ/p65JWGhe3ZVGL2H2466am4kUvfJzKrmeLL2PjTO7MjOU6SDf7GsF99j1MgubNh7
    nLbVVjQ4E/N/qk1vbYOihCdadMSMNIbGjt5+uvZaj0PMKv3C6sZg1CIJvMCg
X-ME-Proxy: <xmx:dkAUagxETFrRe9-kD2cc4kmPpmBOelImsO-r-b-9GTga6gPor2le5w>
    <xmx:dkAUahqZyXYtPVUMspMYf1_c6Sy1NQ1KtqqaYxR3l7OAWQpLIEh4Cg>
    <xmx:dkAUapoDXjw8HxSaiEm4-IXvta81PujczTUfA_vAmU0HzGQpK3lSgA>
    <xmx:dkAUapBN_JwBcRVSeM18txP3KtJqnG-d3voBKieNF6Djnj4sCHF5qg>
    <xmx:dkAUarpVB9kKlgw2AV5JGm0vQzg8Z_XO4CEBmU0Fj_NC9VDIAaRnDUk7>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 08:28:37 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: alx@kernel.org
Cc: linux-man@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	kernel-team@meta.com,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH man-pages v1 6/6] ioctl_userfaultfd.2: Reference UFFDIO_RWPROTECT and UFFDIO_SET_MODE
Date: Mon, 25 May 2026 13:28:16 +0100
Message-ID: <20260525122816.1956804-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525122816.1956804-1-kirill@shutemov.name>
References: <20260525122816.1956804-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: nmbwdi9wb9873hijdcroiawh6jp9roua
X-Rspamd-Queue-Id: 22F4C40010
X-Rspam-User: 
X-HE-Tag: 1779712118-634596
X-HE-Meta: U2FsdGVkX1+TqtnP0sXGUSBqWqLeagLe4GO9QZbanphaeW4JJIBPkV25Ku7+/m/4lZpufEZXxO0wbTucxi8Gz/M2LEFeFfa2S6rsSfIH+9sE2gC5MpHnN9V1GPNQqJm7PTIxk2R0giaOOvP7d0QLTvnIU/NuSCT0veRoqbRrcl3zgKPLP/eAqAngpBehxWfffDAt9OdPVTYFpHS9iMN8vYXnlmtm4w/C/gJ/btHX4YA2wQZ80LGwS2FXkNjcmbJ8lBoWm55wQV8G91VUq/v3bZuDspirocLwF78GKl56yJcDBEyGSeOfmUbMJc6j7Ztq5IxiKLDqnwwXGi2EbYjZancEI1eycJ+mCjydWUPTcUm+1jwmoLp4h6Y0t1L3mIFs0VKv39knKO9n7PVReZ5Ce/zuVFv5XtJiVo+whUL+ECX1KoX97YRBv9fpf1ABQZAiJIq0bmwsyTGIxHRCLTeOUsTsIrylPIcSeaUYFGyOgx6L23DKaz6qgkrvdppT9T42czGhXfzyfjsbR9LMXQUcfPmTxv873o7jPKnqHP8Oab+P1zxoLuwVu6WELtGwts5oEaz0VFx7iy3LVmd4K3D9u/nH3+DOFv43W4dusVzcVWpZBkxn8XiAr3lkKoilFYJJkSVuvDUnGKMggIozDybFoNaNdb/p9kfUteJRc4PAsR+DLmidZZs2OxrraNU/XPoz/DBuHqsYgI2kChnwNfBJWf/l3OOjjehXhCAdrxszY240hXA23PSXolDDBKiD9YLDyUS6zFBr3N51RA9nsHaQdpUGvuvbJZGOFqUDSRqFwuu0nkuRY4ifJiGVFPalEkoFa3iKibuv8oQ+aZJqee/H04mvRmaUGIQGjZ8mSt79wi24X/8ItxFVw365hVET7+b+hbUrsb7QbaR3iRKf4ojglZ9j2qQ7fRxwg1XyHS0zFCtEoH1TAcKqcp31Gp11e4+Xg2TeV3kpKcwWGota8ee
 qnujpcln
 520pYX3YCkbFnoApCStOnw0h784pgeoooZf0qngRGU89v/lJ2MHooODqxLC3UnAtmkRwBNGVzafTe2ngQZIkgg+fcco/TQx8dLOD1G3e65BGwh6NSbSuijVQfJNdhGfnI4EnB6UV2vz1RKcEMDAdl2rCyj4YvkJnsNcoWTYBEFe+1X1Xmsi+ygyj54PiCEaXfynNtct038JDNCqErxeoDNO/HLuo6pwIwVZVRpeQCoZFTF4NNuyBqnmj94YbTVJ0dCZOTQ7i78Dhc3CSBbhYlHniZAlE2QgAWBrSyygLWiF6sNQ7jdUAS39sto4rwcCUzrjiWTSt74iP3rtTefDgP00MweS9WzKQI3oWXzO0825y+CrVHQBcbLr5z0Cxqqg+gnTVYiYXjp8cwnCioPAbm4C8T1qo4XIJv6LV286gPDkZaZxP1/7e9ijscG3K3drHEcyMOaFgR/rlHXRkzEL7qT+Ei8/4r7yEW0Ul1P6ISLbpk2+1i+fKNntoRpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the two new ioctls introduced in Linux 7.2 to the list of
operations supported on a userfaultfd file descriptor.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 man/man2/ioctl_userfaultfd.2 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/man/man2/ioctl_userfaultfd.2 b/man/man2/ioctl_userfaultfd.2
index 37553cd7a88f..fb57fe222979 100644
--- a/man/man2/ioctl_userfaultfd.2
+++ b/man/man2/ioctl_userfaultfd.2
@@ -76,9 +76,13 @@ events.
 .TQ
 .BR UFFDIO_WRITEPROTECT (2const)
 .TQ
+.BR UFFDIO_RWPROTECT (2const)
+.TQ
 .BR UFFDIO_CONTINUE (2const)
 .TQ
 .BR UFFDIO_POISON (2const)
+.TQ
+.BR UFFDIO_SET_MODE (2const)
 .SH RETURN VALUE
 On success,
 0 is returned.
-- 
2.54.0


