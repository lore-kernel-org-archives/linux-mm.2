Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8044CD5BB7
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47BDB6B0092; Thu, 21 May 2026 09:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42BCB6B0093; Thu, 21 May 2026 09:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CCC26B0095; Thu, 21 May 2026 09:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E6F76B0092
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:33:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDCC21A0611
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:33:29 +0000 (UTC)
X-FDA: 84791518938.07.0EE2520
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2C301140010
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:33:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j4CDviTd;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779370408; a=rsa-sha256;
	cv=none;
	b=qo//l47mdPIPBUmTWrEYo/IUhwYrX61Aw4AFbTGFyIV5hfCd3Wyll4J8GCWiPBzZTcMcL9
	7x+G3m7ZTuBk3vpg5oEjOU0A4EyGY0uh16f7dTo4VGECIlGAXfezBEv1ERNZ9flfRDSryP
	KAZjzg0Vx5ihsbXF8st/RIuuCNTDRCc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j4CDviTd;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779370408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ezV5ICAM2va0jVjd8iAniGdLxBSb69xxnF1gv2JwpSY=;
	b=2nYnoDjInWV9mF3iDXb08mQd/ycMiIlEFRLaF4kAlVsgah3S6BbNBrVQo4PrpLXAtbL6pP
	bCNw+L60Gf3ldtMc/s/atyTWtvO2csMDu0m9iK+6weZLqLIFLIXhMXdUAJN/xxHcV/3c48
	ONEqSYMhnJWoWRr7H2Jz3WARhcJvfCo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A64DB445E9;
	Thu, 21 May 2026 13:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C95F1F00A3D;
	Thu, 21 May 2026 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779370406;
	bh=ezV5ICAM2va0jVjd8iAniGdLxBSb69xxnF1gv2JwpSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4CDviTd6M6LDTj5r6sQRqgJ6ESa9aWMu37zRV8mtOcXrJiE1zLL6x/OVHUw7taNB
	 jl6ETIYiu8JAkRBqc4Wuv2aB534ln8Hu69MX1fb2GFClu2Mmurr/zb532bCHmICyRT
	 bW4gGDuRH21kbO4Mt3QzAC1BgrPy+si2Rjb35ZfN4nboZAY9y9toARiousj3e/bp3M
	 OhVS9wgD8OvUpe6jIOQ+pq818okRHEEM5Lah2/H+GkNEe7+pCkBUV/HEs3jXEYS4f4
	 MtCRjjIGdmkPubfqUsmmCsve0nsahQ5jfKPmPGh0P3LHoWU280OP0E1I4NEEZgAN1h
	 MDV3MyE2qhaxQ==
From: Kees Cook <kees@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	stable@vger.kernel.org,
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
Subject: [PATCH 01/11] params: bound array element output to the caller's page buffer
Date: Thu, 21 May 2026 06:33:14 -0700
Message-Id: <20260521133326.2465264-1-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260521133315.work.845-kees@kernel.org>
References: <20260521133315.work.845-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2143; i=kees@kernel.org; h=from:subject; bh=3eO38ZdE0rbljlF5l/QfEOapKDQ3GxlJmKbxHXugskI=; b=owGbwMvMwCVmps19z/KJym7G02pJDFn8nAtqmS7cf3B//69jZ5rrq6va9p3fNOGM7h2Jd74Pn JTCV6u3dZSyMIhxMciKKbIE2bnHuXi8bQ93n6sIM4eVCWQIAxenAEzEYiojw//ne8uu9YZ9+sWp mJ7czDyrP2Afv+2f21+/99yL9Jp+OI2RYVNeQ9witS6BzPe55aerW/eveRmS81ixc8XMVftPpj7 OZQAA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C301140010
X-Rspamd-Server: rspam03
X-Stat-Signature: xffo6crp5shfnn8pzsow93xx9krkd14j
X-HE-Tag: 1779370408-627375
X-HE-Meta: U2FsdGVkX18l4soM5uqrgsb6YEy5UcOU+4EwQoSVftU5YDsUez9LgR5xfczPDP9rDk/cwlF6dOi3DFkv8pl/SRY7yroEMIoR4UUbaRWgShdcGKcWKeW4U9CtLi1l9f6U/07u7I8MfWAhKbX9Disfh2zRihhAOjIkPMD2Zp/+VSlZ99bXg6JSFMD8aYWFroJQeuk2DOIZ1hRuyaGaoc5aXIIlf+9AUDHExEBsm0/BPUhAs18eP/GhCVu0IAr2WezSro4aGJ8MkAkuIGczt/ttFydt/uNSWtXP01Cea5LOcW+Fl4lDQvSyurs7Nf/tx8zlV6chmAce1WKmE893qe6SEa1jqsRc5I7gqrEZWKvyM+9WckbGHikV1llOwpSWVMNt15QL1yOd3FtHrQwcsp5Ay7jdIA91yMow1pIdT28lZPlWtQ0fzxmBvNkGhLbOD9rYQDXynbAwzjtwGnoesQSHaPBt3xi91Q9rR+mjtUvckk1s6+a/5g8r058y9dS4MPykHbemy46hlykw5TvyMZm9T4WJueD2gnCYtzr915nhMb1JPHLeeyYvFoDmkioGKAulbY+8YiLt/iH5Yel+O1bRE7XFP7c5wsOrJ34PgbThAIUyPly4wHITE3SuQdA4FufPWZ+wDXRy0ArdFHOvd1/er3c+eK4Pv/qiqRiD8l0IhSKQfV4Hotl2nqDfQki8K+PZyybO6/oDFTXRDxvNfzCHRsdNuze5mMzEY3taoMvM4AQPWAckjjly8UcS9gxX6imTCUolfB8KyAqQ0wZbH3BwCrzcvQx2COpoL6UhqXubv21Pn2EyhkmAgS8nVg12jEKjt2DliwGrDjfOPqceZdMjgxTGutmq1GQM5HXQHmu4FDD57dClBdU4EcRuTZN1FjDia7LR3QhFteYePkC5bf5fPw+Bh06SvoQEO4SpWwTQ0uQwNu5LqzhOfSjrFxXcheOeq2VSrYX/h+QcN6nkJ9w
 nwSyZvGK
 lwfcMbDsryeOytaRzXnAEKyko/QQO8g/aVaEXNSTu+WnF1InkskMqZauUmqePF/IomSGMC51U4UklRK/JHdLsl/Pm6G1q4Mw42d3ZBw2IrCK6SnnLs5Q3r4YGrZkc8XJGLnRDw4gE2X/YtC0J3Bqq79ht9VK/jnlpUVG/TKTQY9Ic53e4hBXoQ0ALYIgaOaNcD4cKd7Wd+pSCKC+S0GLXsQYc2qEWsOAA1rBlyfskiledQgt33AOTJZZdczLJxfw5owX3pUV6CknXq440bgspm1rOe9Hw0Gn/30/82PvS4tWDopazuASfplf4uocYjHOQ2uTRwtQv5eRklDJ3KQiC9kuDIoIjK8PVTvw9TdDMtMTJwmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

param_array_get() appends each element's string representation into the
shared sysfs page buffer by passing buffer + off to the element getter.

That works for getters that only write a small bounded string, but
param_get_charp() and similar helpers format against PAGE_SIZE from the
pointer they receive. Once off is non-zero, an element getter can
therefore write past the end of the original sysfs page buffer.

Collect each element into a temporary PAGE_SIZE buffer first and then
copy only the remaining space into the caller's page buffer.

Cc: stable@vger.kernel.org
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 kernel/params.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 74d620bc2521..752721922a15 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -475,22 +475,36 @@ static int param_array_set(const char *val, const struct kernel_param *kp)
 static int param_array_get(char *buffer, const struct kernel_param *kp)
 {
 	int i, off, ret;
+	char *elem_buf;
 	const struct kparam_array *arr = kp->arr;
 	struct kernel_param p = *kp;
 
+	elem_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!elem_buf)
+		return -ENOMEM;
+
 	for (i = off = 0; i < (arr->num ? *arr->num : arr->max); i++) {
-		/* Replace \n with comma */
-		if (i)
-			buffer[off - 1] = ',';
 		p.arg = arr->elem + arr->elemsize * i;
 		check_kparam_locked(p.mod);
-		ret = arr->ops->get(buffer + off, &p);
+		ret = arr->ops->get(elem_buf, &p);
 		if (ret < 0)
-			return ret;
+			goto out;
+		ret = min(ret, (int)(PAGE_SIZE - 1 - off));
+		if (!ret)
+			break;
+		/* Replace the previous element's trailing newline with a comma. */
+		if (i)
+			buffer[off - 1] = ',';
+		memcpy(buffer + off, elem_buf, ret);
 		off += ret;
+		if (off == PAGE_SIZE - 1)
+			break;
 	}
 	buffer[off] = '\0';
-	return off;
+	ret = off;
+out:
+	kfree(elem_buf);
+	return ret;
 }
 
 static void param_array_free(void *arg)
-- 
2.34.1


