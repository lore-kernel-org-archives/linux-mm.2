Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC7ECD5BC9
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3435A6B0093; Thu, 21 May 2026 09:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4896B0098; Thu, 21 May 2026 09:33:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11EF46B0096; Thu, 21 May 2026 09:33:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7EF26B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:33:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFA691C0466
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:33:30 +0000 (UTC)
X-FDA: 84791518980.28.C8348F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E85F610000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:33:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gKeaVp4g;
	spf=pass (imf05.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779370409; a=rsa-sha256;
	cv=none;
	b=jL6yJoZTmdRBmQTev+2dujMyDyWpJvcUpqst9toamUOSXQUIbIYqgxL2uRjovrOd/VbFDy
	wgTAcoT540flUsxxs9uXuWSicCarY2ZPFoX2w6nx1vU3WM0IIrVA4/qyaYZKhQs9nNirL/
	SJCmSL7UcIiIg6GTuyd4vINiLHZj/jQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gKeaVp4g;
	spf=pass (imf05.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779370409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCDvxzUe4SUE/8My5CdCqwCgEMUsyBtFnEQMMX6d/s8=;
	b=FQA/2rXZButMMBVrTI8CtBHwXs1YZEIbym/i/8EcvuwYKI0CtXPIavwObTvkRU0gYqgYn2
	gE8ODmioEQU20BQBzxwF5Dc4i4J2mC+3SJ4P8zqpW2+5XxeL8mnhvrq3joLF6dI0i8X7C+
	8+zOxD9HyMMhj+EBtk77mmYppVSuJP0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8232445FC;
	Thu, 21 May 2026 13:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E471F01565;
	Thu, 21 May 2026 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779370406;
	bh=mCDvxzUe4SUE/8My5CdCqwCgEMUsyBtFnEQMMX6d/s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gKeaVp4g+fZOCB2d1zbjK4W3dvda303iCxWkDVj8H14UNIIGY3gLpzELeZZiKDuA0
	 6JIfunc/nVUvSrBIfRk900oxZ2787B+gF2h77BXqscTXGWlKDLIlSThYYzXi6Zaf6k
	 rSGRMLv44XHHzSMHgbqg/hi8HytIpEFrRSPhR2+NF71x4bQnEWRMd+fmzjPChz9SHD
	 l99zEnTWxInewz9sw/ltbjS6dRQ4fdJNXiQJ67R4+Wc+4RYmFsK3aPla3MQMOLPRtt
	 Du0AZ41GslozrTV5c51WftQYxJqxNJ5tdYXIlfTZ4AdLpFEJ8Cy0CdC8iVcMT6c/cM
	 6A9cOjvqn/5+A==
From: Kees Cook <kees@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Corey Minyard <corey@minyard.net>,
	Gabriel Somlo <somlo@cmu.edu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Baron <jbaron@akamai.com>,
	Jim Cromie <jim.cromie@gmail.com>,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	kvm@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-acpi@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	qemu-devel@nongnu.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH 02/11] panic: Replace panic_print_get() with generic helper
Date: Thu, 21 May 2026 06:33:15 -0700
Message-Id: <20260521133326.2465264-2-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260521133315.work.845-kees@kernel.org>
References: <20260521133315.work.845-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=866; i=kees@kernel.org; h=from:subject; bh=We2iaIAjr+4pDVj6nN4taHbnlsqb7PEX4Rc0M//7Kt8=; b=owGbwMvMwCVmps19z/KJym7G02pJDFn8nAumTnkv6GXi6mHz69T5F/eS51xN2sf9+OYJ/5tKM a7BKpWXOkpZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACZy9S/Db7YGn+v9lrVPV4gu m3xhJm8Bs3PHO2Ofhg7+Rze8/k6O/Mzw3yuT8f9jHfbF7g9KrUVDtZlPT9yg9mVa1fd5W55tLpg ayQcA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E85F610000B
X-Rspamd-Server: rspam03
X-Stat-Signature: s837itqwimmsjs7rajftogkwsrsk1ttn
X-HE-Tag: 1779370408-808099
X-HE-Meta: U2FsdGVkX1/96hLU4iYefuhHp64YOYPgmGyr6O+SHAVcj5NPtbdnwNkr7gR/3tvqUV311YaRWYd9GI+8BIxqrGadPXnojdZtqKFXtdxCryghtU7GTsvvKaRny9XuuOPQuYH5ezRDnShRbEE6liZDqk4hyW5kRmot/Svcl6pKCZsLGI0imENcEQyy8y8NtgJRUvrPlM8E6LM5GJ1WZn5v/+sRDlRkPm9qaSrz3InxnMCGcJrPNTnFXyncNjKKKs567Lo2BP3o/r5X88Mewz9USERIUWlSfsbBe9uv4KLzoMptUgjjBDCmntwQlOw5mm5ow9w726jc6ieTd74YzsWKD7y9FbMbndONNQuKwS3490nG982BQ7x/gEX9kkUIaEI+1o8q/90AdD43TPafxYPxZtCAbQ4Wx8SyaFj1joaFLysug9qsGA972v4gL+IfjYDUt+VRuQoang5MPFae1I4NO/YYkYPs3nnOK8DPuR1DM6lSrYSdbZH4XNeydhU5rDP7yNeQfHWQdITfFgif4Xn4ff9GYmNC1Ea54er4DbPy/RQxBGcybaPsglnYs+8D7YP+Yt5kd59j4A4TBAHDF7NmUyD78eJco26XlD2FCyT1aUyjbYE45sozfiV2tmmQrKxkbMKHKgRTrYM6tYZod6Aq+i8m2Pv7Vt9lNE1ybxl8AAQxkrADkOl0ZbubW4ey0EyLwkwwfXypBSIQ3qfsF/Ynx6ubVYTsRpAERqX4U7pQ+WmrPdOVXChhMumTBhCKfoMnjL/TLQfbhQ9Q5NE5KHh+4L3ANkO2bd0isO4MsK0TkZG8/kR8H6+JHKD53OBKSvGO4xZhYseFEXTR9y+B0xETAKt6VqOmkGSBiwZ2INXqkV9F4S+7Dl3AfM4Q3TKfjFx3A4g7TAJZVMZVPHH2LaV3sIqDqUUV5S7SOwL9z1oDIN07rUWT008Wads1N73i1RuQgCB2M3cNFQTwXth+f4Y
 UYJWIQPT
 g26cLP3lE+iDwb2ar55Z432SqjAuRy990IBouE1s/8bqFTLH6J2SRy7TnBWdpcJt/IbDvvk7zYStQmTcpiFkz7S01i84fkuniInezjSnvxyye3EuANd2nkurtqH+8cxasvlvXI1onAyedtglvgR5KRDXohMvvQ7BcGPZXvGZE9oUYr7manITRWlklOE23WIaljoqnZgeQHGSsZccF5S9ZRnzXniolK76oWZdvox2y1mGLg30suraxXb/hvOCQbS6HDTgKNN74IHFXdfBu8ss8bOqE4NeJG2DH6PeKLSvVVTnjVtMJKf3+lYDWqWjbaY0hA8fj/vPsITX5MJi84J3/gTiEswhUwVzX8TGg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since panic_print_get() just calls the ulong helper directly, there is
no need for it to exist as a wrapper.

Signed-off-by: Kees Cook <kees@kernel.org>
---
 kernel/panic.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 20feada5319d..42e5ebde4585 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -1214,14 +1214,9 @@ static int panic_print_set(const char *val, const struct kernel_param *kp)
 	return  param_set_ulong(val, kp);
 }
 
-static int panic_print_get(char *val, const struct kernel_param *kp)
-{
-	return  param_get_ulong(val, kp);
-}
-
 static const struct kernel_param_ops panic_print_ops = {
 	.set	= panic_print_set,
-	.get	= panic_print_get,
+	.get	= param_get_ulong,
 };
 __core_param_cb(panic_print, &panic_print_ops, &panic_print, 0644);
 
-- 
2.34.1


