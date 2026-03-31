Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F94FF60F7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2816B0095; Tue, 31 Mar 2026 05:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199CF6B0099; Tue, 31 Mar 2026 05:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6E36B009E; Tue, 31 Mar 2026 05:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EF0076B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:44:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8173E5C6B7
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:44:23 +0000 (UTC)
X-FDA: 84605872806.05.C6AEB33
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 81736180006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:44:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SjHGdz+s;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774950261; a=rsa-sha256;
	cv=none;
	b=LS2LjroSDgjIpNcZyx4GcdAe/YzqMu9dwHd0zx7nvqU4nHIppVBcVLMaW90lmeorAseupB
	bh07XnhsRbMU4Zxcnvo0aiszrH/3QAUWXWRKVSI0Hz4+lcg6IurRzBjIkOtsx9DmfGNVpH
	fvxOCn2mPKEgIN+nSe6i3yXUCgEwCjU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SjHGdz+s;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774950261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HApNsJMnQkGjRCw1G9QlTLRX0WXwGT8mBK0arH4RiRo=;
	b=aV4/mxSRnBvE/xDhPAS7cC+DMvwq+WmiYpKeVf3eLXnreB34Nrv9hOB+SCwpsfbrwnnxpC
	CLLBuYQVczhiCL7H9wxZePA79tqu80eDL9/q4mM53GnPyTgkW5yQqWqee00mm1ttEgsNpf
	ntr7kRQKjHhhcWXN7ECABdEjEDoKlYc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774950260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HApNsJMnQkGjRCw1G9QlTLRX0WXwGT8mBK0arH4RiRo=;
	b=SjHGdz+s2i0c5utmVNjcmdIm6u4cwgd+jtgsFpjHbj9JIxm9SQ9Ivq9i9jHQbi/RC1xoPC
	EIr9y+3XQcS1y9M5GXa5m5EX/ukM5GRPAg4Ph8HTjfIGrM/4Kl2d72nVkBxCJ5Hs4OYH8C
	H7WEaFnKnlo8l7iY9Hns92f7Sv6WlJg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-9FjosW1CPO2exaI7I-bw2A-1; Tue,
 31 Mar 2026 05:44:15 -0400
X-MC-Unique: 9FjosW1CPO2exaI7I-bw2A-1
X-Mimecast-MFC-AGG-ID: 9FjosW1CPO2exaI7I-bw2A_1774950253
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0CBBF195608B;
	Tue, 31 Mar 2026 09:44:13 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.121])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E08B30001A1;
	Tue, 31 Mar 2026 09:44:06 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: nathan@kernel.org,
	nsc@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
Subject: [PATCH v2 0/2] selftests/mm: clean up build output and verbosity
Date: Tue, 31 Mar 2026 17:44:00 +0800
Message-ID: <20260331094402.144131-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: MYSCorYA3NHCZMTAkGhxYcugpZ0FYlQg3J-5uKtN5FQ_1774950253
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: ur9nxsfbgnb8td7stfbk87ritkux4io1
X-Rspamd-Queue-Id: 81736180006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774950261-700471
X-HE-Meta: U2FsdGVkX18872QTTnn92roh3KJ5StQWWkwAV+xj06c5yycYUvLiX4mv0Mgx7Aw/mNPMseoynyEpuj2cuK9DkyZ2TR8N0I0Yt4Ialoraeqoes5mEkH0if+PLA83BW3Twb9jmXig+s6LjNSLPCDvQ9qbA+P5yJXKkPVODH4jBjDZ33UdvxqfiemM5w7nZeCECHFjiUU98ohVCtKfPwl79oYjKXxFbzbHoB2g35koUKo+QupHwhuYkDgdGdXq3do8IU35hWqEcyeY/KWr3hvUmHAycKCksFGir58K5mUdFV+LiLL+X3Eam3wHh85lBtx+8OvQ0xTWPMVvM+n26ccLA4Sf8a5T99JCM02UaQWd0lSftfUHmdo92OTvaGztTunzSwcdkjIj41mlQVNGRZhe+j58iWv1SADEdU76WwBaWsXFhOwgNmvn1NvaIhslgQpudnHK85b6PW1jj+KIMx2If/1iik+4PKtyE9N4Xg+BOxsWAVqPf1xoJJaXXFkdkBHzLCUIq9KUH9W2x4G4ftDZcSMOnQZ3NBP3o4KCnWzdAqoW5b5464Xzkj5u9FKOlcomz/k+73wYfvGMmOGaUxfpUCJf2owxYryAhI0Ro5T7ZMsGA3f6gyDJwWD4vE57BUk3+K9vTc/sN2alemLbJpWW8Mjwm82w8ayZfygXt7P7Bs2dg1K5AsO6p18xwuEBASMvJlyiTezy+tXMaAXXzRUAHx+ifE9EyaOw9qVcOtoqkNmjOW71bmoR4OMuYlsKMLQ8QwzmZ9gmz2kCWmeM/oAtwSHxvv4a14VLt1xmgSLJFaRoY4NMv/gWiEyqxilDTJpn3K34IwzRu/Y8fONz3ZvyXQCG8Gyth2XC/r3DhghH9ZRlDHaFEuF3TEaQj7VSX+k98LFe4fzABgYjWvopmx1ZeFRmMxSweb2fMn2eeqlY81T0VFeaLbO5OueLjttDcLIPSbQk8t/Z1wA0ZRgfWUwm
 E6aAKvBm
 Xg7yuqUVC2cfW4c14OFA/sdwAL0Y/T/C/ETTD6H8jHm5hXfLu2SHgfhcAFOU4YBgREIDhOJh0nU8ZUDE43hApjYBcxqgflCvNgD97xaAWAm2BcIwPI9OJl/7vq7uogGZlMCIF1Yq0mwdyoQfThsTVZFhGZ2gaDJ7EHlDjSkkZ7TlHd+vUIldnQ3ROBS+sf9jkK/3o2CNwcVRYQXU9THpi+zYP/aBMKhbEouM3FYHRbxm5zHkQXnDI7lInzCsXTczQKPt0eD2feIa6fal38Mc8MFS4Ftbz4gf8APBYE6WZbGPgxuQDehWLbRMHt09cbXvSTpwiFuEE6AiVaNfLmulciYgDPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the mm selftests build process can be quite noisy.

First, it leaks raw compiler errors during the liburing feature probe if
the headers are missing, which is confusing since the build system already
handles this gracefully with a clear warning.

Second, the specific 32-bit and 64-bit compilation targets ignore the
standard kbuild verbosity settings, always printing their full compiler
commands even during a default quiet build.

Notes:
  Andrew mentioned he hopes this patch merge into kbuild tree, so I resend
  to linux-kbuild@vger.kernel.org.

V2:

 - Drop 2/4, 3/4 from v1 to v2, since Andrew wasn't able to confirm the
   patch works for the rarely happening issue now, so I decided to just
   hand on the process of the parallel issue.

 - Refine the 4/4 patch only to hide compiler errors when missing liburing.

Li Wang (2):
  selftests/mm: respect build verbosity settings for 32/64-bit targets
  selftests/mm: suppress compiler error in liburing check

 tools/testing/selftests/mm/Makefile        | 9 ++++++---
 tools/testing/selftests/mm/check_config.sh | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.53.0


