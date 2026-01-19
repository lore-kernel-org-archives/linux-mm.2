Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0282CD2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53E516B0336; Mon, 19 Jan 2026 18:04:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525E06B0337; Mon, 19 Jan 2026 18:04:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381C86B0338; Mon, 19 Jan 2026 18:04:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 241F06B0336
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:04:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E2F301A02FA
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:04:30 +0000 (UTC)
X-FDA: 84350244300.12.3EB49B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5607BC000A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:04:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JddkqrE6;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k158cyD7oCbNoXtiGNFRA1wdgAAG3gz0dJWgIplLiI4=;
	b=FtAmdFyJ9tcdXV5G0J1UZtcNPRX1X55Ba0+krT0ldp0jCgj1/5tYqnxtVg3Oz05bOZyk2J
	XNiPDrQPeUV+2ekS6JfKrsikU3wCteJPKiNZHbboGgC+Vhna/04JoKG7Q2FZuqMc5+LhI5
	PfEUBKBRVS4CMV8vikyF7CprrRGvaC8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JddkqrE6;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863869; a=rsa-sha256;
	cv=none;
	b=8itfYx9upicBYDY/32FZIIDIks5uHSbGizjlOz/iyb8zQKedfrp1O7oqZcF0wL+KWQG3c3
	h9wlRmQ8RH83wmMSUEOW7WcQykgEsMyPmF12RKu+ubTK/Zs5OZANE5Z8MPl7zn3g5qgWNn
	EUb2IlYGTEG/ykGukB8M/AMRzkUOWnI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BBEF96015A;
	Mon, 19 Jan 2026 23:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A63EC116C6;
	Mon, 19 Jan 2026 23:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863868;
	bh=S1lJXi3TslhD2DUEpYR7JuVS5MOqETlTcS4z0PNouhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JddkqrE6RvS1AkcsaP0vtdPHirYtI6v+ox8YHuFnXoHZ6NJfOnr3M+yynoay6gTTs
	 2CSXcn90icHiGYaNfQcjwZ5gBkXXRJdWMqLpgNOW25skxtZ0cVYbGJUW8kM68yJjsF
	 xYxt39UFsY+/oOcthmFoy7p0q/3U5dWozuyWhB0B4IAEPbJwcOnI9Qv37JnTchNeIm
	 zer4O9EWA4zNWmtWZucviW7z2hJBTJJSFMqW2pjllnEM9ZoJQDnaoN+5yVxeyv0iPU
	 ley6W9IKnFUbeFASccnDtJvSJcW2dPCjakmFabdI4HFB4fknl1l42IDGOcMdpEVToz
	 T00lzVZ1LJSCA==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 24/24] MAINTAINERS: move memory balloon infrastructure to "MEMORY MANAGEMENT - BALLOON"
Date: Tue, 20 Jan 2026 00:01:32 +0100
Message-ID: <20260119230133.3551867-25-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: d6ab583mc3xeq7rbbn6n4r418xkpkjyx
X-Rspamd-Queue-Id: 5607BC000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1768863869-639235
X-HE-Meta: U2FsdGVkX1+oEzvaiWe5hTOLjMdqkq+fAlMOpufqAR2LTNFLlTN9JwyDil8KVrnIdQGrdKn00tPB/3FZ32LxDpCL4DDRI1reFwizIcxpoGu++xxhaoVSkPUN/kpq7+AQJxeBCJYdJdYlaeLIhGNiaq/fBtG9D7qXdlPXOzLm42gFyXDIEc+zyscqGWcfA5yBgeRz253LPIgRlRCYdE+g8VEV9z4eBacy4w8Obrjc59IQOJRdeWTOL75qzNw8lhoqUraIdcNUIrMBQLdpAjdHFDTPcnGddILruvR2G3XP29Evuy6gETJJFUFrnxA+IthdGJBuoDQqXaycIXR2Ig8QPV4IyfUMfTiUr4KSPT1z7RtxaLDGU72Co0qItoRmNLdoLVxAPgo0/8wB299GUgryRBDE7O+TrS5USNLA8UFX8kizeV+H4eE8WkOEvmyf5BYsvwy+vEEc9y9gKGHvFWR3j+aRk1AJjlesuqTy+Cr3Pzd+4o4caOFZ49CvAMwtmI96CwEXYNshRc+NxeA/S7Xnxs97MsaEbk8T9XlQ0J8aWsanhuByBTmykIflJrCbmnnWZiEYIogbT+K6Nqwn3TAVHbMp03zPgYIMigePRG0p31TOfM1rFJRPdVcFhML/xlvD2lmLJuEcWkR7u58mefSPHNaagppwXChYw1+jSoIQFJJKiQZ0jCmX52zTjA3LaSrSav4VsYJGJTCSmNQQ7O+Qbr+wKpR0mFh13fafDFc09ZUmYQoEj1bRzlNf44WeA1UDJ62QvauGOxbtnaaarKh0dd1elEglx891xD9Kbx4rwWr2++8izA8M0bq4IMS3McKS8xxYccK+/vCXhkAcL6Hfbh5s7FOZZBHbBv826Ztx+kIXJaDE3aCXQinzAVLGbbfmZo3lW83/3opBCo3BYt20KwbqRINz6tNFEFaqXJTcAMZxWmXehHrVIIhWPqW7GZiuc3m6HewR/cK1/E30hGY
 CQC4Fz32
 S5WZf2Y5scXCGhZR5V1XS/XaJc9zLd08i/evFlKmC8lOcT20+eHtEyh65VKL6KapjE5k/kj/PMr+C/L67bQ/O1V+iBbmtkoFMNW22P3hy6qVvbTEnx7cccyNGukPYZv18OvnlMOetp8x8NXeGAaBiwryj853PT/11wtU/iqyfgDs+Z1EtzhGBnLtMxzPnvfAFyOa9FzfwstT+8Q8t67jkpC7CWnIvuEH88bsToJ0HsVoo2vxRVolwpkf5jzStsSiclWQoxlLM9dDQG4XLh8W1AIRJG2Orlny2x8RIMkrEBABafd5bPovWjo7G57Mi0LQd3z+XMzbI1FJP4jffWG0Do7T0m0Z1ynvLcJi/B1LCCLR71inW9CxFajxSoocpoDSDbfJ9RHP+yFa8b86GxJukVoKV8ZTOpXPRtnqlSmfrW1fagAmpk4eS/H/RE+RJWvzybjYtdW1sCamHcD0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nowadays, there is nothing virtio-balloon specific anymore about these
files, the basic infrastructure is used by multiple memory balloon
drivers.

For now we'll route it through Andrew's tree, maybe in some future it
makes sense to route this through a separate tree.

Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 MAINTAINERS | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index de8f89ca1149f..11720728d92f2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16454,6 +16454,17 @@ T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
 F:	mm/
 F:	tools/mm/
 
+MEMORY MANAGEMENT - BALLOON
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@kernel.org>
+L:	linux-mm@kvack.org
+L:	virtualization@lists.linux.dev
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/balloon.h
+F:	mm/balloon.c
+
 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
@@ -27536,9 +27547,7 @@ M:	David Hildenbrand <david@kernel.org>
 L:	virtualization@lists.linux.dev
 S:	Maintained
 F:	drivers/virtio/virtio_balloon.c
-F:	include/linux/balloon.h
 F:	include/uapi/linux/virtio_balloon.h
-F:	mm/balloon.c
 
 VIRTIO BLOCK AND SCSI DRIVERS
 M:	"Michael S. Tsirkin" <mst@redhat.com>
-- 
2.52.0


