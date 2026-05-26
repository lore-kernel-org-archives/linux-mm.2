Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 902F7CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A5D6B00DB; Tue, 26 May 2026 09:42:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64AF56B00DD; Tue, 26 May 2026 09:42:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512626B00DE; Tue, 26 May 2026 09:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE836B00DB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:42:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFC091A03B4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:16 +0000 (UTC)
X-FDA: 84809685072.04.E34FA77
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf25.hostedemail.com (Postfix) with ESMTP id 98596A0012
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="i Vj6noJ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=D8h2rzxG;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779802934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZgAEnG3y0hjbQQMr6q8X146RoFRjtg7tgfZ6yPqWYn8=;
	b=Vb82EC1d9tVS1oHUEhfgO+ny+75IWdEC7MLHZpdXwF3jIFAPN2MFUW+zdVOsKDx1Hlvq+O
	vGgPUbG1uYaH0lX6SzRG57ecSAM6bFY2cbzJS9ebvYPH5SAEmpXxSni+ol/81z1MOhAGYX
	wxK3VyF+m8llrBmTcOqgO2Zlo5n+Dcs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="i Vj6noJ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=D8h2rzxG;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779802934; a=rsa-sha256;
	cv=none;
	b=wUQyAPBHMUcveoqq7nfkZ4PRWr6fAJoAnlGvBin5tdJJF3u9zhsGSt4LjCBFfN19Nje38y
	8bgW0q4+pDNgPwS6gpEkcf3Y00qCZoB6HVxHYpraBq82P6SVuIYyitTbxd3WKazouzk/Ec
	DFodEG5E4uZy3iCdicB81F5NoarZ+q0=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C46377A019A;
	Tue, 26 May 2026 09:42:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 26 May 2026 09:42:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779802933; x=
	1779889333; bh=ZgAEnG3y0hjbQQMr6q8X146RoFRjtg7tgfZ6yPqWYn8=; b=i
	Vj6noJPoa6j+jlopJt/39Iqj+3OojOHAxHNiKUWgqlMHkWnNBRSvOYnB0VTRQQm4
	45wdxGVwvPP7X+LRj56WyM6HPaSIRAovP0GoHuKEqJRdA3rFoKp7D1zz8+MC3OrE
	Jzcm5Gzm37cAarMzaKYgwFQmgCBsZ/MILMO8Xds65rZwslR+EkaLCYi6IZn7bhXr
	n5t0ZEBBDVTwuo8SLJrqu+elKlW69LSbuJ8cIUa2IRJGdfQzttYGcsnooXot//s6
	EgWGIrHysgGIEbrl6fw2VjmCyjWdZOsSk2vrA6RAbuvKG9FUfeOxGD2TzdWI10JA
	EQ8BFBzX1UNHbcnJv7B/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779802933; x=1779889333; bh=Z
	gAEnG3y0hjbQQMr6q8X146RoFRjtg7tgfZ6yPqWYn8=; b=D8h2rzxGI58FoCBbW
	KFzMO4NJ0iSs8mz+W7JS0nFNbIPMYvKMHMinEbEgey0RlnAdXum7szbYcsIaU4e5
	4QTiksx+jn6qHn9HEZBnphKLU1VOPw4LXwp21hv329MVW2Du2QfsfvC/KRLt3S3h
	T5XKpd7JP6eKwECUHJQp/XNn+TxqHhjDs/XeXG+2gFPunrRcocwwS2oe6Gmy3H6I
	44dAB20Kb7BmK6lYu+vv076bEf2cOs/2Nr29CXE/9ayEbZiyLJIb5WvBIIL14s6J
	ITPV/zbtcin/pJYAiezB15aKVY+ppOUAMgfU54gV07+x6mHkT5MH8Z4EjMMqcBWR
	0AJlA==
X-ME-Sender: <xms:NaMVasUk7vg_XruyyLNSjFMISLFMK4i0jJmnhql9tQSgSUl1BkdPUw>
    <xme:NaMVasTesCEY6SxGi12g744x9a_UBpzkkQ2rzstazJ909PfTV9KX-iJlCecMVsHhw
    KL688SLHHSzJSGN6uUtzIuRgVQamBGaUijCnrlVPg0LmK9d7giMezM>
X-ME-Received: <xmr:NaMVas3yl8X9o_VYrFhuh6KzJC2lWnBg_G7TfotqHFB2_ISNioKkk3MqvJrgNg>
X-ME-Proxy-Cause: dmFkZTFxd05FKSwjYK98sxjZfnEaguNgmbkO96E9/sUnrZGjGgye4wZmt/Ic6rtJdcHZIW
    3//FyXDnAPZWcDl/2m+5C5IsDZPk+GLuu2B8rI+uRVdcLjBSQaOOZLOa+wj1oQtkVV8Bhp
    WtmpanqdGSitjyrzT2b6Pkutw5p5iBbq4Ria8BSGQgx/cneWSFK1H5BjkBZc7xkAcAMQ+/
    Rv2g5eDEYnTPqdUCqfDdBxWdlbC/8jofdT6MpQF8/jX84rElnpbBbagNC4dRH4Bg8YdXPs
    U1r7XWojbr+m14NCpvSu3BQS5JVzG4ZMz6Z/lJcP/h1EeFr3j6rrld2ilI9JN6jONfrTSJ
    SyQeV7w65aRKzq3fBnxIIPQkmspjn/CUmINIZvvLxx1FLZaIKNRcDgy63odh9OK1Xxe7Md
    pjXgyqydCLKkufw9AMh8rqyu/Be2VcY+TYkoIwtFyBm07W7EKWFCnOfMkVBnpVKs0wjXaJ
    Kd/zWYolkK16tDBkptTELVnv1xHze1Y/94cpGYMK3HF+rth0BfJcsjasCFC+xICEkEs/oG
    ZTYiKd3iF4IkCA//9HzibnY0i06kE5owLLtdccyfyTKQPta8hFFjWYe1ZPMRbZ9hzTzn3i
    XWkSAZSMIf7A33R3xlyxf8PkyfZjYMvFdXpnBrQbVbIcJqSrL9X0/qKHEDng
X-ME-Proxy: <xmx:NaMVakdn8JyfSMlJigsXAuu2Bl6TGWlP1CAqNnaQSJfrgaJ8fGzkLQ>
    <xmx:NaMVasM6nG-xPa93tmU0gH-aPox-q5bzf53AFw9BbBrORKnXCWoCiA>
    <xmx:NaMVagWg1Lv42KfYnX8hw86HUFisl9X21N7bkC_dV950qib0Lcjgog>
    <xmx:NaMVasywWp5JFkLlsYnf2kgtjdRvh3qU-xRNGVoLlhxV-24-uWy74g>
    <xmx:NaMVajP_FD1UCOuQ9_0pUxIKuLt2UGqVfdy7QDxRBhMeo5_469nUnhRi>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:42:13 -0400 (EDT)
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
Subject: [PATCH v2 4/6] UFFDIO_API.2const: Document UFFD_FEATURE_RWP{,_ASYNC} and 1 << _UFFDIO_SET_MODE
Date: Tue, 26 May 2026 14:41:47 +0100
Message-ID: <20260526134149.2831720-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526134149.2831720-1-kirill@shutemov.name>
References: <20260526134149.2831720-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tcie6qkxst3b696soidjp9c7usjmpstb
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 98596A0012
X-Rspam-User: 
X-HE-Tag: 1779802934-554123
X-HE-Meta: U2FsdGVkX1+W+CVjQoorIBFeDr7vwcYEEvy4LinIM/03aVRnQul8z7mPLXhIHGQBpuVBDvkNWH9gAw1cTxILiQ0hixC3s6+4ft2XdGOphyVZncGQr3TwSJ1ms1r+7SjcuxHWY/2A60oeYNyxxJaBAEUetRzGmsddFcC6k0eqHiOjEri/qJ+5IuD7+NrbFGj79edw2nLhx3NNN9UQvAc/ze24VH8PU0p9MJQZ0WXZkhmqXP2iKcDA+6Euim+oJDVRf3rMkXJo48rPB2VtfbcEsNrGlp33gMilANWUUn9QjuDhG1KFytfjDZj+6+Lz/hVFQwSDBtyxVfXnUlYvMiJIdUqsxgMdzTxoAh6nKuMk0fD1YFq2l+a7UwBAS9pP6LSu/aZJlvRgfmEeIX60I43l7pEoF2CBaHWYzNgAtFX/LNd4ypHLI3HMIoZYob6//xqVTCH08wIpyF9L7LfRRSFiK+DgI4VgLsKGBEKgdEDxup1mUjPtsbIF0IaCCoukPSakUEjdSoisHVHIb5MzD7aB3NgDv7xciuN8/VF+3+uOjNRXRwFbdcB9LYK4EaOezLDoIPBgigzn8kxFQIcEB38C1C25p1TKrAr03AksuaTj4vBIKsbEoPwMq29mzQaj/AeI7bSZdeDbp/kpaAClEYkUKDUxYhO0quzBmsB5FLbfQdCEE6BY+soaBDYFlqv9Mv7mfCXqSnvYIU6iaQJe9I7iz9lJpubD0kxDCoOAnhuz2C0NmuuKsCOUR+viPiSxbijG+qWSbp2XZ7SbMvOd3mFS/rexCCUa8U0DFdS/Hn/OwykBpM8a+VaVBXymGteb7mj1AbNC/KUdWa4HH7KoUimLVOGPaWTWm1yKRvbrNqP/gWLR4qQKcrPTX9EERrdvmOmr0kipn5i7ZIQUJ6KU/z1W+TV6GodsafsoVDauybeKkJnbB2Pc+J40mo9eSqxbjruDosbQB8Y7phwC5i2AsBO
 X8bs3+1j
 9EbkZe4Qq8+MFGNG/6E3HmmHzTNlyvACgMFCh8PqxJR/RaPcVY5SYkeQ6nthCGpd1AN4CH7/wkzateLqJIprsQ3XPTAVe8ADakZAYbLKDomhNBkXggmkfwyh67Pi5x5fn5ghau8mFzbyvOE2ZlRBEaezKy+wGqxK/GM7nTrqHlO61tnb6R2QrTKgkdlQ1SaZYntMpYjZ83J82H48TqI5E0NPps3Bf13CiwagqtkJhh/Tn3GNvErK1cRTer5996eb2oc4zUPRaQN5cINWO5mA30JfiagsfDA0ppMTlDmfwgZBlwZMBuAvxmuiLooEbDeKVpJdznQ+qns+UcS6IuOf0AOfTXDA15ZYDPo0LBMeqiX4I/nTN4RpGM2111C+PN3RAkcFCXeMs5Ve/ACaWJi9bR87fF0QIsgSYr5p2w5oz2I/do1EAFYdrNcuFb3Hmbys4w4yiU421sxnYiv3c6qlaVhkxvhchy+63ps28eV+afoHaK7qz68jmwaW0BtvtoycXyGp8+2LBvxKHcJwy37+f+5REpA1nLPr8OnLBP+dshv/kvSWUGr1g9xz6jvQg/bQMWl7dhzADkscocqSt5WOgnBvfEu/4N1RwGd7xuUOhuWJOCEwPH9ZyqCYOL7N7vng+Y743HmJlVrjtP+1jhJ2q4VtZeb63jmcCM1seQJLaqEMHzmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the two RWP feature bits introduced in Linux 7.2:

  UFFD_FEATURE_RWP        gates UFFDIO_REGISTER_MODE_RWP and the
                          UFFDIO_RWPROTECT(2const) ioctl.
  UFFD_FEATURE_RWP_ASYNC  in-kernel resolution of RWP faults without
                          delivering a notification; requires
                          UFFD_FEATURE_RWP to be set in the same
                          UFFDIO_API call.

Also document 1 << _UFFDIO_SET_MODE in argp->ioctls, the
file-descriptor-level bit that advertises UFFDIO_SET_MODE(2const) for
toggling UFFD_FEATURE_RWP_ASYNC at runtime; it is independent of any
registered range.

The existing page intro already describes UFFDIO_API returning EINVAL
on unsupported feature bits and the temporary-uffd probe pattern, so
the new TP entries do not re-state that.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 man/man2const/UFFDIO_API.2const | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/man/man2const/UFFDIO_API.2const b/man/man2const/UFFDIO_API.2const
index e894114bb8e2..46ee7e31fed9 100644
--- a/man/man2const/UFFDIO_API.2const
+++ b/man/man2const/UFFDIO_API.2const
@@ -213,6 +213,30 @@ .SH DESCRIPTION
 the kernel supports resolving faults with the
 .B UFFDIO_MOVE
 ioctl.
+.TP
+.BR UFFD_FEATURE_RWP " (since Linux 7.2)"
+If this feature bit is set,
+the kernel supports read-write-protection tracking,
+and the
+.B UFFDIO_REGISTER_MODE_RWP
+registration mode and the
+.B UFFDIO_RWPROTECT
+ioctl become available.
+.TP
+.BR UFFD_FEATURE_RWP_ASYNC " (since Linux 7.2)"
+If this feature bit is set,
+the kernel will resolve read-write-protect faults in place
+without delivering a notification,
+automatically restoring page permissions
+and letting the faulted thread continue.
+This bit requires
+.B UFFD_FEATURE_RWP
+to be set in the same
+.B UFFDIO_API
+call.
+The async mode can also be toggled at runtime using the
+.BR UFFDIO_SET_MODE (2const)
+ioctl.
 .P
 The returned
 .I argp->ioctls
@@ -234,6 +258,13 @@ .SH DESCRIPTION
 The
 .B UFFDIO_UNREGISTER
 operation is supported.
+.TP
+.BR "1 << _UFFDIO_SET_MODE" " (since Linux 7.2)"
+The
+.B UFFDIO_SET_MODE
+operation is supported.
+This is a file-descriptor-level ioctl and is reported once per
+userfaultfd, independent of any registered range.
 .SH RETURN VALUE
 On success,
 0 is returned.
-- 
2.54.0


