Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E9ACD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22E186B00DD; Tue, 26 May 2026 09:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18CDB6B00DF; Tue, 26 May 2026 09:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6376B00E1; Tue, 26 May 2026 09:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D73426B00DD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:42:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A00DB1C027A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:18 +0000 (UTC)
X-FDA: 84809685156.29.2662649
Received: from fout-c3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf16.hostedemail.com (Postfix) with ESMTP id B85C0180005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="L h/i0Wj";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=oTrMbCiD;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779802936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMns0AizgHQecg/gLnkzXQPS/ehy7uDzfl4bVIRi2lc=;
	b=AHBfhLLJ7laBE2q46YavIe+k06uHPcbTyS2l5En1zGh1gu4m2RZ1zpQwuKG/wgXqQHaTdW
	G9fjgPrrD6TVK8TEwv5XAzPKVW2s9DLgwVMk0FLXEA8JgDqod7HUue2rgA8xO+1PN9oNKA
	6LjdZgPACPmo0eZDmqEUwmtcDzELAdI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="L h/i0Wj";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=oTrMbCiD;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779802936; a=rsa-sha256;
	cv=none;
	b=T8UnsxXEbPWrXs2XTBiZHzZf/ceSP+ddNMr/OXXzAQ76uzinkGjpFfVhk940R3GavTmGzG
	0D5Ix62BmOgHP2HPEkj79xw6S11l806vtiiE/zl0DcT3zaT39NAG87HNROE1cKbHIfKhfT
	uEAjR0LZXk0BECIo69Bj8LfGfITUzP8=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id DFFFE1D0010D;
	Tue, 26 May 2026 09:42:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 26 May 2026 09:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779802935; x=
	1779889335; bh=SMns0AizgHQecg/gLnkzXQPS/ehy7uDzfl4bVIRi2lc=; b=L
	h/i0WjyzFlu40Q8wYOpg3Vaielw//6njUGliCGMZkg546NsVchLAC0+NP/y8oi/d
	okYuItEBelB10VzcLW9XZ09vohNvVt51H4rO/NsWZo+A5I3vDr6/7+e0oiHwjuNT
	pylCSSUunOJQ43pznfGRwv+4MTnsWGbEalDBaIhW90ETdaFHq6MDm84AFhb5v8GF
	V1N8Vy1WL1Gq36+2FLmQFUJHiKzleJVjAfmwK/EOTB9ju93HdiIDxqMKYSv1X/Gv
	vP4tsLtj4qWE5BJ3+YDXB3mCYvylGoSNNmTjXYPZTT9F1hHu+xXw+VWSIwhrSV9v
	NQcn2lUFtwf82hzoGCq5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779802935; x=1779889335; bh=S
	Mns0AizgHQecg/gLnkzXQPS/ehy7uDzfl4bVIRi2lc=; b=oTrMbCiDXwaM81642
	AFjh9bkhiS17EDqd1OrjeR/LQq1EkdpUCiFoBdJ9XeVPFjkHCtUQBU5efjitfXcH
	isqC9QTWBG13h9738TiM/s3rm5QjcOUEvnAZcOOwBR/O2Qb4UhDyB6HDiUeR2R59
	o1B9xLtw5S2N6WmsUSebZr4sP9t/rogq44v2KneNesodSTk995nOOV3iyfEWrPDJ
	175/pa3DIl7t/e1lzZZEB3WGHnzHDh/Bd+/aMmcfuyeI4wG5QRr+C6fUU4PKwFip
	znF5dx17sRfvKBaCUwXFVt8W5Hemmr4YtV/tRhuL6XXU+tYgV76cf2H38U7wj4j9
	2ul9A==
X-ME-Sender: <xms:N6MVajqOL9J7cXq4I5xjqYb9N0BqSoOFseRC1zEwbAqlDm6M9Fm6Ig>
    <xme:N6MVaqORSxmfZ7rkeS3xHVEZYZMHpZV3jtoO1gU56fzL2cJEgu-4Ica2Y29ZI_HvI
    U_OVrF8BPoACdkW3T3s-nud99_5rINOzFHz7r4k7ykI6Gjv9AIh3PY>
X-ME-Received: <xmr:N6MVakqt77mUVxs310CvPo27C9pw9XwT8ZPl9RTsERQ7kKbBYBjH6k86L8QasA>
X-ME-Proxy-Cause: dmFkZTFxd05FKSwjYK98sxjZfnEaguNgmbkO96E9/sUnrZGjGgye4wZmt/Ic6rtJdcHZIW
    3//FyXDnAPZWcDl/2m+5C5IsDZPk+GLuu2B8rI+uRVdcLjBSQaOOZLOa+wj1oQtkVV8Bhp
    WtmpanqdGSitjyrzT2b6Pkutw5p5iBbq4Ria8BSGQgx/cneWSFK1H5BjkBZc7xkAcAMQ+/
    Rv2g5eDEYnTPqdUCqfDdBxWdlbC/8jofdT6MpQF8/jX84rElnpbBbagNC4dRH4Bg8YdXPs
    U1r7XWojbr+m14NCpvSu3BQS5JVzG4ZMz6Z/lJcP/h1EeFr3j6rrld2ilI9JN6jONfrTDi
    KrlLfJIw7gUDHRWBa0ywlK/ws5yCGvvStEctD0yhIr0Hpbwwdocsu+rSRnrEjFS3T+q6sa
    FMGe+0pbTC1xm4xfvRr96mn0kBb60ajO+D/23+1g39fr+/TDyumsdyITPd0F6lJV263eii
    6qqCIavRlJ2JkYv2N+F10A4tQtq9TBZvaGvFWh81ZWXbmskdLa4dHm1VIncwP7KnwKu1T7
    N+g7GYFxvy4aaQqaURRtALRvYbDhI9aXt2Oe4AD9/0n29MVeJFCjdn3jBv4kuUJ/0XfHft
    NoEuOA7aJfFXHSLcl9DsnZRZwfJ3vRcS2h7//reVQBNqOG1d94BpxpYUOPEg
X-ME-Proxy: <xmx:N6MVattFap3vAGzNJHX-0vbtg5pLs22qkr4DlI3jmTng40GLWQXaCg>
    <xmx:N6MVaj1YBC01Mr9A9RQrj3gLy07zOLzNyoBpiEog_hsvI55Hr6SP-w>
    <xmx:N6MVaoHXXilLZI7IsPxaclRMO3ghz4HQVG0v_WC-CVvUZ_HCPwSlIw>
    <xmx:N6MVausQrO-OkAn1GQjGEoD9FbvU8NNkIL1HsY5F0KEcRx0KL0t2UA>
    <xmx:N6MVaiVw_Pk2C_dkTNxlGS6MG0mukw6ihq7OfdOPWYyIC5OmYbKgwrM8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:42:15 -0400 (EDT)
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
Subject: [PATCH v2 5/6] UFFDIO_REGISTER.2const: Document UFFDIO_REGISTER_MODE_RWP and 1 << _UFFDIO_RWPROTECT
Date: Tue, 26 May 2026 14:41:48 +0100
Message-ID: <20260526134149.2831720-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526134149.2831720-1-kirill@shutemov.name>
References: <20260526134149.2831720-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B85C0180005
X-Stat-Signature: hkigx55az4r9nz4adyzkb4kifu1spet7
X-HE-Tag: 1779802936-95142
X-HE-Meta: U2FsdGVkX1/1EgnpqRkEphvJQC2prVH3tA1USuSyvGZ5yRwotT2hxxGjUsQKcI0I2aAkWyj2oT73l6IImYu4HV7w6zNf1WnJ75GCeqrVoiJLXsVpYucDGHWtV4kFu4JaeMzAce3Yr0mtIODa1RBwFZRUHxIFGkB+dsGoAEwDvxGB4Ev/MMzxfbFdyq/WsgcF+5zzlnV4Y1F11HOXkP1PPzprHWtqBOgxq/qjL4eIiAqfBSgLJZnlhZ+GZlR3uurNVE0xYXw6eVk9UbWncUmMoNx0H4sR0iaypRyQa2n5g4O/9+ew+I8QIP7wJZOD67muVrUN0viOkfXjAOXdMys/0SHU96tp4/Jh5vzbeGPHdYLMr5OgHCEHAGBjVahJUQ1B0hYrVV+RuMjeI4PJ1pukGmU4c8hNEtXPDEHpPCy7Q5G8Yp0XnmmkTj93vmvtOkgaVKfXZSP8Z2qmvpwEFCCSdeIUhIwCHjKL0O0H47gGZm29RZF5+sr9l49qwS7Iss6efFTzyWwmlxGd+315vhGckciGZVDyV0Qko52+z5qM4z/rHxjjYADfMgt/Tj/+5FN3FVptbHTaYSIWfPgIBwPUafl14uuftArDVr9J656nR/nUsXPDIHax2V/5q8DNJw463q7P5E1ElBgLJiaYj/pHSngQ8s7BcfkGp/1JFf9vkzefj1HJ0ejFVxsnsJRFoaFBOTgtltEdOO3Lv+b5qumZNLGLjmAWA93WiVvZWWvdbMNAszEIvyq+qn4AGju7Z/sUdKESU6godIQNpjzAAqk6aD2RgOuB+BjqmW64aQdemtdgd0lval4WOt8FksKwNV1F6yEDnLqHASyRhAUoP4AU/nN0DKkR+O95el8dSFBir0/Bl78Q2BjmR0N//v4oqQaSbKL7jXlJxTlAlkYs6EJ+iFaEp7seWq5vi09hwth7DwnWd2u3ta4KP9A9ApOhnUe18RS7lE6E9cQsucHXbIw
 r5FkvVvb
 63t0S5IT+ZbRK4Au6TIpCbXPqNpfon9K5Ggr7HW5JkRicFYQYfdpfu8JjyiAtP0TmAGymXdeyx/UqTuR9WkCggRv4xs4L56MrPTSPthUlH5ypthrsHwpDWRPLNZUxZmt/OaWPkbVmKaFpwcohg0yJiG1g5l5Vq3ynV+wllCSM/wPjXqO0yfj3ZY00ePgPcIDzme2OCRVmBGx3E7hn9f33t0ArYjAwmkMY4vzFkwX+YYAQwVSnVR+f/HESnbDVbO9ZMe1Lvg+TOjdGm6qmVgezo60QKu6ZmI7GxO5OPbEkT22aySqmpuTmSPcgGFH1QYHhc+n7gHFiufqM/vrSF3XGjRSn5AerpJ8AQyCA6hjrxqDyKdrI3Lc8aGvEbItDyJUj8RJlAQccrtH3Y7jxZHFm/jvPzwd0lJpee/UgVYF+HB0jQEZxmqswT0Ef7iyKlFSdvINCJESQ6sUjyFdCAXvPhWo/CUfrsCjImxRwln2WH7CGhw77n9klgeitYTKjBUQqLIVdC67p2aS9RizsrU+r9CmwIeHg/xC/pvCGAso35DVlTKsyq7NdH2b9RGFIZheUQomXcT0mkkdqlhKvTt/68nThOEasfrSVZbMVxCd+QVdLYXM24cTSw4kEeSs9Px5Ejf2yQlgrqZvU9uV/Y9Tz59VrWhbekROe9GEZdfFPgPaFGM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the new registration mode bit introduced in Linux 7.2:

  UFFDIO_REGISTER_MODE_RWP   Track every access (read or write) to a
                             present page in the registered range.
                             Cannot be combined with
                             UFFDIO_REGISTER_MODE_WP; both modes share
                             the same per-PTE marker bit. Anonymous,
                             shmem, and hugetlbfs ranges are
                             compatible.

Also document the matching argp->ioctls bit, 1 << _UFFDIO_RWPROTECT,
which the kernel reports only when the range was registered with
UFFDIO_REGISTER_MODE_RWP (which itself requires UFFD_FEATURE_RWP to
have been negotiated).

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 man/man2const/UFFDIO_REGISTER.2const | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/man/man2const/UFFDIO_REGISTER.2const b/man/man2const/UFFDIO_REGISTER.2const
index 50064c954b81..ded57cf301ad 100644
--- a/man/man2const/UFFDIO_REGISTER.2const
+++ b/man/man2const/UFFDIO_REGISTER.2const
@@ -72,6 +72,20 @@ .SH DESCRIPTION
 only hugetlbfs ranges are compatible.
 Since Linux 5.14,
 compatibility with shmem ranges was added.
+.TP
+.BR UFFDIO_REGISTER_MODE_RWP " (since Linux 7.2)"
+Track page faults on read-write-protected pages.
+Every access
+(read or write)
+to a page present within the registered range
+generates a notification
+once the range has been protected with
+.BR UFFDIO_RWPROTECT (2const).
+This mode cannot be combined with
+.BR UFFDIO_REGISTER_MODE_WP ;
+attempting to do so fails with
+.BR EINVAL .
+Anonymous, shmem, and hugetlbfs ranges are compatible.
 .P
 If the operation is successful, the kernel modifies the
 .I argp->ioctls
@@ -109,6 +123,16 @@ .SH DESCRIPTION
 The
 .B UFFDIO_POISON
 operation is supported.
+.TP
+.BR "1 << _UFFDIO_RWPROTECT" " (since Linux 7.2)"
+The
+.B UFFDIO_RWPROTECT
+operation is supported.
+This bit is reported only when the range was registered with
+.B UFFDIO_REGISTER_MODE_RWP
+(which itself requires
+.B UFFD_FEATURE_RWP
+to have been negotiated).
 .SH RETURN VALUE
 On success,
 0 is returned.
-- 
2.54.0


