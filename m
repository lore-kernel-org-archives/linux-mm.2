Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2060EFB7E5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 03:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59FCD6B0088; Mon, 23 Feb 2026 22:10:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D506B0089; Mon, 23 Feb 2026 22:10:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F7F6B008A; Mon, 23 Feb 2026 22:10:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB006B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:10:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA2D1160411
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:10:26 +0000 (UTC)
X-FDA: 84477872052.13.1CFD658
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 923E08000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:10:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TJE7WvVW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of sanjayembeddedse@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=sanjayembeddedse@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771902624; a=rsa-sha256;
	cv=none;
	b=MYCWJYY4TMo50PT7v9UoTDbQFQP/T5luwmjQSUFDkXnOYxPCg9729+nzQDZEG5ztmMQnQv
	W+N0W0/Ma0zfvrGrhQ45PTe6MLnzXjU/u6ma+JaMS7mh5aLxVdzKOV/GiTLL1Metlco+a/
	IJ8D/RW0QqQDxhat08DR0reK5kgxStE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TJE7WvVW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of sanjayembeddedse@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=sanjayembeddedse@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771902624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3NP+Kkkg36cikM6o6RU/ylaPgoFm+nRow4PTjcisMu8=;
	b=7YGLLWbHU3gs7hcfcAPZKx7wQvl0OQ0MboYmDGFPw9SmGCMZtScg6QRMp4Cpe8r7h1Gi61
	CtzxaxE6jRy6zxVOBp6y68JdwBrinm2xbdLc9I0w4uOxTZRsFK/2PUqgQmbf1ywWjseZ+i
	8fjTe92EyjJbDU/TFveceMPJFocOAQ8=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3870acaf78eso39958091fa.2
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771902623; x=1772507423; darn=kvack.org;
        h=mime-version:content-language:accept-language:in-reply-to
         :references:message-id:date:thread-index:thread-topic:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=3NP+Kkkg36cikM6o6RU/ylaPgoFm+nRow4PTjcisMu8=;
        b=TJE7WvVW9myXuEKj3GpQMTni1uJPFcyQIsBS896yefsq+pSZswVWcREFmCLHPQUbRD
         YRV8VscAGqSyMLSXkR1Z6+mQtbULjlK14wXxPLQTn+5b0GZ9wcVK5A5zLUQDJm3q/Qg2
         TxHnKwddMVq7ZBmI9aGiT958+avVer5OZWMKbiCabukJKIS6x74TvrywceGgtCcMZ9Ip
         MtgJj2KZ/PmnX3U5h5ITxq/xTZBDvze7FbL4M++l75k7VH7FK1n5bRlHk+RY7qCYwtOZ
         M109oUASD4K5xihZQdQB0TP45IWx7IWz75nj6rGYD3N5FGPXrsYY5D+NzdFkEEBVnKKj
         C8QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771902623; x=1772507423;
        h=mime-version:content-language:accept-language:in-reply-to
         :references:message-id:date:thread-index:thread-topic:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3NP+Kkkg36cikM6o6RU/ylaPgoFm+nRow4PTjcisMu8=;
        b=lCpHO5h+mwgAshhxnaiKWizTEyCaV+aTB9cmY6KKbXfzCmV5Yn8ArSVt+nKzuhZL8H
         FMsf6NcX4iW20sznHQnPT1N5bQ/brRlGQdG2VPbRRt6xBupp3Z5axI1WPFFy5mjrnhHG
         nuItCPBHWTP7fNVKI2O0W7cSRHdggJcGiLQ8kS45AR4aOa6L7U+moMER6SLepgCF5jQ0
         BjmzmuWXDkQ9DiHTsmfHFEWLlg2j4Yi/qSkOAT7p1+CTl8jU66zPr41bguG4wJ2ad+HC
         uI56Yu0jkssEO7tMzrzqz/IvGGZKQgu2mpbMDnWEq8uZlSBemZVvC0ZvuNNnPsIuDzF6
         Ow6g==
X-Forwarded-Encrypted: i=1; AJvYcCWVUqC7/IIZL7QAeTxfa+KmWvjCRd2zem2i78d/VNLbsl6FcRGXCMwiM97nNVX7nAJ3y2vSmvJjyQ==@kvack.org
X-Gm-Message-State: AOJu0YzzEqYzVywsr9CKds3R4s1S1Yaf0uCrubyhkrpkxY3UiohQ1HHh
	V0LuC+mMQA3TWRlfs8UyDdLU1bnSuxgT5yLSOL50tOGETib5ye6sBNkd
X-Gm-Gg: ATEYQzxWsLhz0s/UtoI893/kFpHPrE8qxENHO+DwjMWimqtJPnHTiVevnd3F+jM/hqA
	iaZUbRw/NjeJV3yX4CtcswNV74PLe0groVXRkIEAIfgc3O8QHKM2IfLI/J3gE3wdYlP0e5/CJm/
	FArUfn9SMIdlcyi6UIkml1u9CaSEIAuhZ2VmO9LEseB2eYxcNIhLhIBiO/UALQI4dgouJ1NrXQf
	wfC5rX91vkv9F5CGefOO775UXln4mFNEa9ryhDKSn5I75qvOEK+TH8hXY31ZC8GcCtczhRKloGB
	toR6pDkxmLFj1oOfM5hTPPN90Eq1d2k7hrqN/NUqiGddhJ5mfpYEdDOy3tP21GBmwB+l15sQ+PC
	iZxcp/EZQjjk+RTq+Dzfy6eMVC5FKLlJSy3k93qg95MA40sv0yZFpGtVIMl0yWe09INdxCd4Zn7
	QfMEqS0z/mE6d8w7FTUDzAQMPG1npQtNOtedSSh7UNzUnECa3KAUb2SI0LOam1Ri0vQn82a+gZa
	SmHPN8OqDmNqkhP6IZWZo/J
X-Received: by 2002:a05:651c:f09:b0:385:d0b6:6c44 with SMTP id 38308e7fff4ca-389a5d4e888mr27362121fa.18.1771902622347;
        Mon, 23 Feb 2026 19:10:22 -0800 (PST)
Received: from GV2PR04MB12295.eurprd04.prod.outlook.com ([2603:1026:c11:cbe::5])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-389a7af4da9sm19778791fa.43.2026.02.23.19.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 19:10:21 -0800 (PST)
From: Sanjay Embedded_SE <sanjayembeddedse@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
CC: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton
	<akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/slub: drop duplicate kernel-doc for ksize()
Thread-Topic: [PATCH] mm/slub: drop duplicate kernel-doc for ksize()
Thread-Index: AWRlLTY0JThdV17bDOAK2El/oPGAYVhXZXN27b1fYGo=
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Tue, 24 Feb 2026 03:10:21 +0000
Message-ID:
	<GV2PR04MB12295091C5D832887CBC4C17EAA74A@GV2PR04MB12295.eurprd04.prod.outlook.com>
References: <20260220124243.3264133-1-sanjayembedded@gmail.com>
 <aZxvWlsrueUgWuOX@casper.infradead.org>
In-Reply-To: <aZxvWlsrueUgWuOX@casper.infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator:
X-MS-Exchange-Organization-RecordReviewCfmType: 0
x-ms-reactions: allow
Content-Type: multipart/alternative;
	boundary="_000_GV2PR04MB12295091C5D832887CBC4C17EAA74AGV2PR04MB12295eu_"
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 923E08000D
X-Stat-Signature: eakzh8ccb1aj4tpcdytknjw8yoibig6q
X-HE-Tag: 1771902624-773442
X-HE-Meta: U2FsdGVkX1805f7FGQjHqlmxaFmaTVegb9o+ZWdslgdH8IXU8sdQbAno0AnYFquwwMrP+4WqYu3y4en65aLG572+lyMr+u86H62e2UBHK5cst4Bk+HWfuGBjaBfsLl99l4dycaE5VEAVnTsjl0Xv6EI7/7LsoXfswWANKmgeaeEH1rnwed01x5MTyofQC41QEXgO6fjY2AiJSc8Oc+lx8wi/chQ8Vg40J/iTuMHDLUtAXZtu02CxB57Dpxuxz7ZlofmjVfFFmH3qamdmo9u2Nh41+ZK0PyZ0vK9Eh1SaeRlMQmy1zOiutkDC+McdD+Jghei3JuUWtIXPB1RpxwJdcbQB5a3Rz/3HLOFWJjCXwfFlix7fkSXCr7cNH9Y4+td7WIsUZZZXZAjb4zFyzHCm35kH4wX2jn4fNrZSnhCpz6Psc3pg7g2yOtbcl4JAgb0DV1BlTTKueVwDzN76IDJk1w6jk5uCdIpZHOSlf8Z1SBQUukQvihTXZ7vIKOm4X4qExwzuim1eEa/tu9HPCPjgIzCxi8xf5cx9jilZF5OL1z7cq/Hir6TqQSAX4kPgGqyvjPQk16004ZLQy1GQsZ7VNKcuQS1O/p75ip6SrfvFg2S2M5nUScB5HeaNB3vegH35Gi0NmYhQ2ABmShRNdeYfSdpNi/nB1xll/kwS32vQX+s5dLJqWKm4SQgL7fVGYXMNf8CXtq8SFzaqsV3Ce+1H0gUHeZh7UZE0D0UWfuQz93Z7zazIBPrLprwz3y9ZfksPyHBQ9x/m0JVCIjrR07eVdYWiwVn5cLo4jaKKZ2zhS0DJLaVcvH1eh9sMhIq8HeF4ZJXpjEiJ78FYmbEOworgA04oXCp8A3xgQrJch7dC4ToeEuhDan8gbhKxRRO4+wd58cbjD5VKG/2WnDYYY0OJ7TR3xX23g9tNjwjT10I6gadnU40w8yPEkZAnp/0OPgwaKW9eS+jRhbceRHMQvl2
 bJz4HkNF
 x1EqNs3grBVzHTxYcXQSTjxuzz6m75xgQMFAIvjP1h9pM/KoQqGErXYpSHedp0FgBgQCQjIZQUVyyqXfsdglpRW/bMyhPnBi4/JSdRokwC7QfdqZ3PsdnyzCGswJ1ia9pujEsFEAQVfnDfhKVdRwhqsSQ6/HMwrzrAWAHMUpFvdVW6EKBfIVf6MOfLF7RSdOTYP1MHBhSfjQmyPm1RflX5M0wGOOy2DfdPbUeDXO8R/3ycLf3UZSChqzWJrmH8mBM2/1CdnlnqHdIvk8fcNMMIgYRqNi6tcXraFAOr/nfKhOnpzzkggwuWHjMEV2B2mIjyGnD6X5IPhD0By3x51/YiTXQf1VfufiNfXKKilGkglkCtTuZsHxRKMjvkgw2X9qQ0FBkKTMd9xSB1HLbXKoNDl+VazluYTWbHeAoZR9U2AVXiNjq/4l02f071iHlvXnuQuEgXQbrZ69JLlO6MOvXnAKfDm2lNd+8Gm6bW4DoIOuv7Dnv7GGxTBW18/p/Qo/Wd7Malqw+qOvr89LFbQRHYdPKVRApT468aQp3KMYFTfeVa5tYDzt1A8Izc3f+TqXGso6f2biQwQiBR9FqNQPOS/t/gGhGC1Mbv5uuU0/DHEyb5TAEhfABN5wwXa0Zvn13x79n6mwnNXQT6kkPJOB9whOyQdZgtzYoedBm6MkPC/51dqYTosmYUvmsEwV+cS1/U025V37wFvD1Whc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_GV2PR04MB12295091C5D832887CBC4C17EAA74AGV2PR04MB12295eu_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


> Usually we keep the kernel-doc comment with the > implementation, not wit=
h
> the prototype.

I agree with you, Kernel-doc comment should be present with implementation.
I have observed that multiple kernel-doc comments are there in slab.h with =
prototype, would you suggest to replace all possible at once ?
Or with reference to reported warning; we can keep kernel-doc with implemen=
tation and remove from prototype and rectify commit message to highlight id=
eal kernel-doc practice along with existing commit details so context would=
 be better clear and relavent.



--_000_GV2PR04MB12295091C5D832887CBC4C17EAA74AGV2PR04MB12295eu_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body>
<div dir=3D"auto" style=3D"font-family: Aptos, Aptos_MSFontService, -apple-=
system, Roboto, Arial, Helvetica, sans-serif; font-size: 11pt; color: rgb(3=
3, 33, 33);">
<br>
&gt; Usually we keep the kernel-doc comment with the &gt; implementation, n=
ot with<br>
&gt; the prototype.<br>
</div>
<div dir=3D"auto" id=3D"mail-editor-reference-message-container">
<div dir=3D"auto" class=3D"PlainText" style=3D"font-size: 11pt;"><br>
</div>
<div dir=3D"auto" style=3D"font-family: Aptos, Aptos_MSFontService, -apple-=
system, Roboto, Arial, Helvetica, sans-serif; font-size: 12pt; color: rgb(3=
3, 33, 33);">
I agree with you, Kernel-doc comment should be present with implementation.=
</div>
<div dir=3D"auto" style=3D"font-family: Aptos, Aptos_MSFontService, -apple-=
system, Roboto, Arial, Helvetica, sans-serif; font-size: 12pt; color: rgb(3=
3, 33, 33);">
I have observed that multiple kernel-doc comments are there in slab.h with =
prototype, would you suggest to replace all possible at once ?</div>
<div dir=3D"auto" style=3D"font-family: Aptos, Aptos_MSFontService, -apple-=
system, Roboto, Arial, Helvetica, sans-serif; font-size: 12pt; color: rgb(3=
3, 33, 33);">
Or with reference to reported warning; we can keep kernel-doc with implemen=
tation and remove from prototype and rectify commit message to highlight id=
eal kernel-doc practice along with existing commit details so context would=
 be better clear and relavent.</div>
<div dir=3D"auto" style=3D"font-family: Aptos, Aptos_MSFontService, -apple-=
system, Roboto, Arial, Helvetica, sans-serif; font-size: 12pt; color: rgb(3=
3, 33, 33);">
<br>
</div>
<div dir=3D"auto" style=3D"font-family: Aptos, Aptos_MSFontService, -apple-=
system, Roboto, Arial, Helvetica, sans-serif; font-size: 12pt; color: rgb(3=
3, 33, 33);">
<br>
</div>
</div>
</body>
</html>

--_000_GV2PR04MB12295091C5D832887CBC4C17EAA74AGV2PR04MB12295eu_--

