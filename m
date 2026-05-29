Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCCB0CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35E8A6B0095; Fri, 29 May 2026 10:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336116B0098; Fri, 29 May 2026 10:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272CA6B0099; Fri, 29 May 2026 10:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A35E6B0095
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:56:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D837C401A2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:15 +0000 (UTC)
X-FDA: 84820757910.06.B8FB3A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 010E418000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WWrEDI9P;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wq2aReJoaCIHA3G1FUxsafEMhjRdM5rz3ZQBKVlRJtM=;
	b=XKe2RThPyiUNnejC5zSJFQerSGgebx9sSfmVQ5Bhgfwj1FO2+7RRe9b+AzgbrinxhRNGI3
	6maRivTlMsilB8BIcpqBXDZL8JWrpIJvzMLXeS3pM500tSiEj0uLmsJ2kpg2aWHxT4/6y9
	LGVca0vdTWLDgEHj+NqqHZbuPdnSlx8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WWrEDI9P;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066574; a=rsa-sha256;
	cv=none;
	b=RnbD0n6S3Mu2I3fQ0n5Vafn2NilofZf+0D9zfUAhR8WXNxxhFgWcw/ewRNtXcI73bZuzIe
	J9x5fdBK4dUsPgEWO+va2WOesyV9DTQre4cGII2flPLkIZc+n9WacG/34lEEw2my3wu+VN
	3l6z4YXlWMjsUDFyeRbIV0KvrltVutw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wq2aReJoaCIHA3G1FUxsafEMhjRdM5rz3ZQBKVlRJtM=;
	b=WWrEDI9PXY5CYMutu0zBI4Tt1NpbDH/4oarv7l3D1iuWGx848Rca08zOYHIYqZb9Fg1vmw
	WDhN6XMIIen5CGQ11gebb/GNTExWbufcG27m4Arjq28xrzny5fHj1bLJUkVhmazn9pEGLQ
	ukxqAPbH73ZNc0WOqzODjxZmlnKNAyI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-lM2A8pZ4O9WzrEK2Kmw7ww-1; Fri,
 29 May 2026 10:56:11 -0400
X-MC-Unique: lM2A8pZ4O9WzrEK2Kmw7ww-1
X-Mimecast-MFC-AGG-ID: lM2A8pZ4O9WzrEK2Kmw7ww_1780066568
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D503718002C9;
	Fri, 29 May 2026 14:56:07 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 929393002D2D;
	Fri, 29 May 2026 14:56:02 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org
Subject: [PATCH v5 01/14] docs: tmpfs: remove implementation detail reference
Date: Fri, 29 May 2026 10:55:19 -0400
Message-ID: <426d01d487656dc97b6ae00717de32efb232a04d.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: OieA0pnOoF0zbRMJIyJSu85GyosoH4nVDuKWK7TTSiI_1780066568
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 010E418000E
X-Stat-Signature: ecfkmtadpud6ot5ffeo91j7mxrwg6u6f
X-HE-Tag: 1780066573-240354
X-HE-Meta: U2FsdGVkX19rV4vEjXMHwuEdx2JxO7ohI5UnwfgwumCOCJd13TZGHn+Gtp7nOAxMpikK99cfi+9A086WFBrvYvb5CzKEG3Am9LhiJQ3KfKzPwLvtzMnI/wkn3WKapQnd0CLG2OlMAlCz4K76es0BAPNyP2EWo65NUlRkZZQdWwbb7V59KuZ7GdzeBFZ22lTqMCSzzggS69KkI/NSllXjYU8gKDVbqH2zNsRhdnCRDVFj2QgUCla9pYA8NCGyL3aXZi2t8CJkQGIfW61zb2emdDFJDaOOa8oT1dsOETP8EjMvhLvD7z5fCjRPUZp8HKajxgEGyyBk+Uh7WA+Peh1HOPO5pwh/g16dyslsYhvxJMZZQMm7iVWWMlBVdvIvzbubE/ccT96D1T6LoS87OhU5NMCnZfh+n/BRAmqdt5rnjAI2TS5mqqoOIOTKLw0vH+Cqmx/PMy2clnGZ5CQeK7zQkDQFoNgg3DC68Q91sK8XdK4/oakDF299JXv8StgdzDd+yOEbJd2ajRgzCkx4MSruppB2A8ekujZHu2lsNYy1hm9Jznpy8aPxofNKXS1nIoIjwbpV+RycnTekQZN4GGySDtQCc62YhKOAZtFx59sVl3MqN4ztPkSmXova5aCUCMku4nXVsM1c5lXPA8Xr+rUFm2TOmJpG9gqJW8AiE7eesnamMl+zuRJNXxpdOjWRMt6PUak6PIItEZA2ojncW0GigfJ8nboAIXGyJtU90sMwX6DrdsbJlluTCHfNYVdBM4BgH2ptFoqSZYd/+dH5TR173uqQvyZ44ITXmSGc3SWrZeHnfBU4WBLOzzpJQsijgxAN0a5noSh9ymzI24yLDI6xnf/QdApMRfpXGQF/BRgiwkdq3apmwtFLi8PHygSvP1P+/oAaRgEzL/JP4l32+iD+mr155GlHUkTc3UYo9J0VVEHtOoGyuRkqbVc0OWKL6S61QZBV+rjkRbWUAesCKU9
 9+WIWfYI
 JyrB6OCIxiww+bWH6FIJbY/aSqeCwlokFp+HpLc8iwB7OnbsVnva6+EorRy0FqV8KHgxggALdpOSj0hTzfw0QLP3oA2F0mFLvQc9lVUGfqcZRmUigh3HX1bI2CYQnp2VBWqZyHKsxm1otqVXZfUfUMdOhwbM/TuSU5IBZ5yjVWp6i3M5FUX5qYceN3jRpRUuNGdTazprBNmD7t8Ml3YK2wDzdkdHSUnOBxg6Su7D/KzIh4AMMGvvPYogGVlTdewjDOl2CeWTDmy21DMialgN5E10XFtDD0bCeweuZyxrwlOZnJKiNoEQlz3Hmh+BApQVkA3MkdNqshIfBGn91qxIsy8wU7QAsBYa0WcqFmnVwqXV02vC6MCX/jX9D1C7uOnY/haUokmnC23VpkkFEvqbUt2RKJjUHtmA91T4y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The tmpfs.rst doc references the has_transparent_hugepage() helper, which
is an implementation detail in the kernel and not relevant for users
wishing to properly configure THP support for tmpfs. Remove it.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 Documentation/filesystems/tmpfs.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/tmpfs.rst b/Documentation/filesystems/tmpfs.rst
index d677e0428c3f..46fc986c3388 100644
--- a/Documentation/filesystems/tmpfs.rst
+++ b/Documentation/filesystems/tmpfs.rst
@@ -109,9 +109,8 @@ noswap  Disables swap. Remounts must respect the original settings.
 ======  ===========================================================
 
 tmpfs also supports Transparent Huge Pages which requires a kernel
-configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge supported for
-your system (has_transparent_hugepage(), which is architecture specific).
-The mount options for this are:
+configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge pages
+supported for your system. The mount options for this are:
 
 ================ ==============================================================
 huge=never       Do not allocate huge pages.  This is the default.
-- 
2.54.0


