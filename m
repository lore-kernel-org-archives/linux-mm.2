Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10B9606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 18:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=YFljydJT
Received: by kanga.kvack.org (Postfix)
	id A4DD86B05B7; Sat, 14 Nov 2026 13:58:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25456B05B8; Sat, 14 Nov 2026 13:58:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93BC06B05B9; Sat, 14 Nov 2026 13:58:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB856B05B7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:58:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEE8814044F
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:58:46 +0000 (UTC)
X-FDA: 85434636252.24.E218DFF
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf22.hostedemail.com (Postfix) with ESMTP id F11AAC0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:58:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=YFljydJT;
	spf=pass (imf22.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794682725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fMcSbwNMVuFNWt2PwLWq1x2zQdIariZoeomQcnglzNI=;
	b=vCzK2h6ZxwME0lzkGc/ZgFg2yJE/c+Mh1SSvRgjuF8aEmEwSQOgzTBaBoFoywntOCvE5A8
	FQO4lk9MNdRlcY4a/ALxwJbgm1JDacBV2sfGlIx1PIv2LW9WoZrUg4oWqBV49f8fhGaUqZ
	xlm+iB5vpJx3vDU3ftVLBnzivoh98io=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=YFljydJT;
	spf=pass (imf22.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794682725;
	b=FPBcmQlHlhmlKvpRKKFdPfD9SJ1gHMzvgny+t6zjQvtySMeaug4VXyTyNe9uWamkCmUcJ0
	493IX31GXHPcWK3/F29JsVy7MRNzWyUgskX1yKgyAcLlmco1BjgJlH+j++KcEQVYWHmdrY
	hk9pFXOkUmRE0qWjIMcD+fPtjsG7ro8=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jRk1D1BM5z8Xrr9;
	Sun, 15 Nov 2026 02:58:40 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794682720;
	bh=e1/Ez/h43f4/Alk6q3O4DTkElJ6uxXkrIVkjdt3GNQA=;
	h=In-Reply-To:References:Date:From:To:Cc:Subject;
	b=YFljydJTBeiracuHceVruwh4WJ3hJmYCYp0riookSAefz2m8nIn3PV8l18y27Bqdi
	 htdgCxQO0GD0o++9o/HN/vRau7vTEQrYj2vK0kXhDShXLb7hJ1sUljAa8F2UvuXpV2
	 VqmqajpQ85MW7ONNFd2wXyo2rBHd/xktWNXJtqJG7o7H9xtCVg1ubvbSleEPDEMofo
	 S01MOaaSUybdSr19D9bsLfbb++fUfR1nzYA9Ovt74eJVFB2a4U31Fl1uxA+Z1suplZ
	 THNXRxm9Jw/htAFjHcZ70U+FSonJryZ3w/zOSPNBqgVtujwumFtUhUsjNSN9RKsXvH
	 HR9oIotVX5DXA==
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 6AEIwTPw067780;
	Sun, 15 Nov 2026 02:58:29 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 15 Nov 2026 02:58:32 +0800 (CST)
X-Zmail-TransId: 2af96af8af58f20-86e9a
X-Mailer: Zmail v1.0
Message-ID: <20261115025832904-wsPy8LPoyIcDJ6FMU1_H@zte.com.cn>
In-Reply-To: <aviVQ40at8rZEyjW@gremlin>
References: 20261115004655564ix3vefI54RZ3HhYOmxuKX@zte.com.cn,aviVQ40at8rZEyjW@gremlin
Date: Sun, 15 Nov 2026 02:58:32 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <ljs@kernel.org>
Cc: <akpm@linux-foundation.org>, <liam@infradead.org>, <linux-mm@kvack.org>,
        <vbabka@kernel.org>, <jannh@google.com>, <pfalcato@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vdm1hOiByZXN0b3JlIFZNQSBpdGVyYXRvciBvbiBmdWxsLXJhbmdlIG1lcmdlIGZhaWx1cmU=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6AEIwTPw067780
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 15 Nov 2026 02:58:40 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF8AF60.000/4jRk1D1BM5z8Xrr9
X-Stat-Signature: wyeadxydkffdk1e9czc8mq68m1tig1mi
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F11AAC0005
X-HE-Tag: 1794682723-343533
X-HE-Meta: U2FsdGVkX1//eqzrNjRDygeKpjHEynPyPIIHlXhVN0dly2tW/qVc8eofJxS4mNy7X0RQLyrPq3pxIYySodrl8jxnRlZ+e3ipYujEYDS+kUqPY76p+7u9WLfkXFOlz/feDe/TyMQzOpStxIJApvml9zmImrbA6BnXZgeI+q17HGH5d/fpLmAxymli/+CGr1AXr8ftY9oILRC7kyhIup2WnXNYEacjvD3Vzi6JJAsQoIV5eiSraVMR7CBMd4jbHvvXk5PC8gmzA13VG44fnwas8oiCQJbhdw+QqxKYgeV+5SoXIsQAVdQoxgYDuELZC2qIKGw/+k4RPgSH6AhDnfAsV3BYstuxWJ6kVkMQB5R+6HzNleruJUKiqZb1vBA16HMV/CJWJCjyiyCkeD9fB5WQmc7L9VncGipdvYjtk49Yn7MPnTsW7nWN2fgAnVbFk4oue9hsPPW5V/GSBpIu2if5HpnuhkOd91Jqx1Cv4rjtfOoEKIgJ2RhMXaywmhQ2yKx6ron2shI/wWAAax978MtDEbm6F/ZcfJRiaVX6rNjk8x+hdjW25ow7txKcf7YWhnL3wV6OoQCQpm9LaMSBfDQL+w82IfoyESS8n/iimcfbuaJO8MvzgsjBvmrOpdwt+9JYFotOAhdnnO1rY1Lqe3p+sjlme6utvHdQ4jF393Q9doUtMUfBzN5C6RjzlLv8Dw7LeL0NIiFtwqo1gD2mHH6zPj+61Etl5rDpYSzduzpYbqptdNUdoQtQXAilzyUJBi10bp0xIWiqYyi7Jt3e4Z1c/I4xqMd5vsnV0MWetkPIXMcP5rABszx8/cQXHGK2+yxiwDwJn/gir3rdtbsU9o3ehhh1qKc2XCLpTVDJB+39URFQ0Jf7CHhFFCJvxbXH8Z1E7Q4fdU54CaqYEuaVRLeg5Ru2IzfOqUklocXEBd/OLhsASfAQfj4OMpYOtTFGfBty1RMS9Vy9Zu7VZHu+YEc
 v4CGP88S
 4eLHo+z49+qpbAh5tAO/mlQbUn19+mN5eCjbFAhWrO8ykKJ597EyVjgu7X4+7D2b9jYihG8O7DJq9tIu5VfHdCiTlYKQgooVBHlRjDR6w9CLAghmV5cLhqCM3eRXydEY6PGGZDbMqCrSfBaeF9RldN5dmqjl7CKWnHOnu6Hx3YY1g326OEZJpPZnj/FHSEtW+YxbalTQgkD3jR/13yjGQsxGtJpyIpAPitl0w3zJpLP0PMDuGzexWb86cQSYd3/WHJIslsVPVqsnmyPQH1y1xpKCBxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo,

Thank you for taking the time to review these patches. I am sorry for
interrupting your work and for the unnecessary review effort caused by
the iterator report.

I checked the mprotect() caller again. You are right: when the VMA is
revisited, its flags have already been updated and mprotect_fixup()
returns without changing them again. My added assertion established an
iterator position change, not a functional failure. I have withdrawn
that patch.

Since you also raised the breadth of my submissions in the related
threads (https://lore.kernel.org/all/avibe0HG4ssUUuBX@gremlin/), I
checked my submission records to provide some per-subsystem context.
Below are selected subsystems with recorded Reviewed-by or Applied
outcomes through 14 November (UTC+8). Patches first submitted on
15 November are excluded. Each distinct patch is counted once, including
fixes and cleanups; revisions, resends, cover letters and discussion
replies are not counted again.

Subsystem                 Sent  Reviewed-by  Applied  Withdrawn
NVMe/nvmet                  19           11        7          0
UBIFS                       12            6        0          0
ATA                         18            5        7          1
GPIO                         5            3        0          1
target                       8            2        5          0
SCSI                         9            2        3          1
ublk                         5            2        0          0
PCI                          5            1        1          0
MFD                          7            1        0          0
ALSA/ASoC                    5            0        5          0
SPI                          5            0        5          0

"Reviewed-by" counts patches with that explicit review tag. "Applied"
means merged or explicitly applied by a maintainer. A patch can appear
in both columns. "Withdrawn" includes patches I withdrew after review.

For two concrete examples of accepted work:

https://git.kernel.org/linus/08a6572441a4e646c96c2b8d8ead9eea0e458332
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?id=fe5988e8708e1d42cb844bd9ac8f0a51388061fc

The first fixes zone-append sector reporting in virtio-blk's polled
completion path; the second fixes a NULL dereference in target ALUA.
These independently reviewed or accepted fixes are why I believe
AI-assisted work can make useful contributions. I remain responsible
for understanding each report and for the correctness of each patch.

I would like to learn from the technical feedback and improve the
quality of my contributions. Thank you for any further guidance you
are willing to offer, and again, sorry for the interruption.

Thanks,
Shao

