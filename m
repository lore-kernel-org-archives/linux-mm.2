Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7CED606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Ds41J1Y9
Received: by kanga.kvack.org (Postfix)
	id 29D576B05C5; Thu, 19 Nov 2026 00:35:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9176B05C6; Thu, 19 Nov 2026 00:35:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052DB6B05C7; Thu, 19 Nov 2026 00:35:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C21176B05C5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:35:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2050714092A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:55 +0000 (UTC)
X-FDA: 85450757070.22.F4589D1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8A3A8120003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Ds41J1Y9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795066552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zaTgPA2ioXn8bej2IOl4WB8n/Qq2lc7VcV2P19XHg1w=;
	b=OCutYYK8dfyB+Ax7aPGb6LDkoRVAsRoVR6YI7MgD9jH3OW60dXCwcO3e4nQ/iB0s2/0KRN
	nM0opmNS9chlgf+C1AO0ajmWqsekmtjZj24JVaAJKJK24lJ3ww164ghKi9f67k/Ord9xw5
	2NCoJtJu8a/AzLO9XfO/QB/ue+fnKRU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Ds41J1Y9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795066552;
	b=0VSzJNi46ZcnPioGgBdPNJotiqs/O2rBHzd+5CgDcNARgvSTMxZx5CN+TrMAWPtMm6IIHe
	2s/MoHKWyAbvuNIiVbhOMNCG5cmaQ4nEQ4+spx9ipCSRqlqt4rW0MI1f1ixpqSd1Fd72Ld
	5VbAXOwcnWU3+e29NvLZFBPl8kBxEeU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=zaTgPA2ioXn8bej2IOl4WB8n/Qq2lc7VcV2P19XHg1w=; b=Ds41J1Y94G5phu/yjrxMx4KYs0
	fd3xEflO7koDu9fjKtT0RrT6JXtuJE3ZGa/b7tv14vHbrsGtLa9cBI8rWCSO9JxiwR/EzHbJ4YyWH
	8z4Lfo2FA3XkU/tifbzr7MvY35pYR9hWGECyuQjjenBjpJMzarej8UBGlp6AB5Cl5B9wZl2ct2hlr
	yP4GZiRBHQWZ0GJWk0TzDbpYf/RtAtr+lznKLzz5QUj256D7TrUxLU7g8UYM2iIVWUk5ZdrVUV65b
	sNHHYVEKZzdr+lQMzW/6WDGqL5WcSfqNg5neQakCI513B5k5l1uBxRkTPLb31FzLHo0nl7cBnoUgi
	7Q0sWVXw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTuoJ-0000000Aufu-00YY;
	Thu, 19 Nov 2026 05:35:51 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-mm@kvack.org,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	linux-sound@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-bluetooth@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowangio@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	oe-linux-nfc@lists.linux.dev,
	Chas Williams <3chas3@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	MPT-FusionLinux.pdl@broadcom.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	linux-mtd@lists.infradead.org,
	Neill Kapron <nkapron@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	xen-devel@lists.xenproject.org,
	Hans de Goede <hansg@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Mike Marshall <hubcap@omnibond.com>,
	devel@lists.orangefs.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	intel-gfx@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	intel-xe@lists.freedesktop.org
Subject: [PATCH v2 12/12] docs: ioctl-number: update DRM entries
Date: Wed, 18 Nov 2026 21:35:13 -0800
Message-ID: <20261119053514.255348-13-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119053514.255348-1-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8A3A8120003
X-Stat-Signature: 9exqczcjaijiza65duahstt9juuj3zse
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795066552-395729
X-HE-Meta: U2FsdGVkX1+tSfwdQW4VM+V3lgxMOiQT21iWtf7xXGlFDMpVEGlBejf1qLAJzm+zk3Yb/aMkEdYIamnADPWmo2Xc6I9Uc5WAh7N4QS+DY2p3VsDBioI9J6vf4PpYNtqduhStqx7okUnGxxxV8aohX2/bhZciPxjWYPfzLTNgfWsdKbtPkvf0Q7A56j+BGoEzbzzcxwKSxsrlPbwv7xT6+pYD2LKN4EMZm52LXBf/5OIYBjLvPXEi+RV4LlLoQ5G8xjuP1tgmslwzEHtxMHL0s5H4CnACSCZLV75UGydKV4FRBUnrLviSmrRDL+aTEltHVt0mP20dhepIRYSZKnPGNQUryy5JXpxP5vrWM2P+cIIuvTrE9F1v64hW+EhFmLzBBHV/QiY3VvmAAOx2nV2z3z2NSw2v/aTQ1YIbc35vOowDwRKVqUU2Qf/i5/PIQlEV0i5SXjiFZYPeM9GOdXXAJ2LDSjAduhxqxPpEMgdX/Pwz5kHoaNuj2XpZKQ+JEyz2uvpbveG6eHf3UxFDDp6w6S7dABLXcW74IaHI4JQTq2VguXzspIHKPL8mL0swAaHahonbzdRd3JkRP9pPvACdQhHQsVZUHqMVALBxmmpEE38uJZ0FTfVxdc65ZMb6McoTbvhO9mRfSQFKeutSpk2UalCbgTSoM10j/TPqkcqGk1eaUnsZMr3KvC+4v+zawRiEAcJSflhxVAxz7+I+KB3tO2k1hJkC5SusJSOBchupM6Vx/mXm7W3hjWaf5WygSScRRCduYWyu7YpPr6cA9FIFYqkht687bt0iUk5LS2E0J37/UwSLt56yYAuQUYQ06BYxsul09xl5H77ixrQOSuiHC4UPhc/JZVjr4YuzLpaNljJKN5CuOEGc7rzUq1j+/3JbxpqzqEmQ3FuYvFxJz0J674x7vpOYk9dY9czzcjQvoQ5ehnZMxxP8FSHBIanSapMa0tzKRJFfKF9xdwpituQ
 sFvTmugP
 3aH2MicYCYw1m7yvM5Y5+paVyz/92WFz/uK2oQ5S7pgmiebsfwHBr5hB7xzEs7ygmn0Q51Vk8z//YrvwIRKJDNnMAmGNus6Xo6qL1HkzVIVV+D6NneeMyL20RbgrvgLbmEoQgC4MPSriWXQABwSnlU2jYvYM/ERysaI5Co2ZmtNojlwxqxFDybdkUErllk7Zgf2qKAObHzj6BF/9HVYkTUZ/szxqC0ekc7Q0QJxlDTj//oS700m9xUgeswKyEij7QNeRMR+tDx11Svyh1YHKl0+VYYyTbHfNXNvcPE7FuGmFQ5M5eOHCnc0gztOu+HYy42fb5Z4E+/39wkJs3nz2YIfGddJcyhbhr32fgq35uYnqUXENNfLTRzy8SAX7cgw34/Hj7l3Esu8t1cMAQ/yFXffOHeKAiTfvqgbu80XCloBAnSJysKhvUhs14vMJsoT5lYL6vcosXKdIJ/DDYwu8Li5VQgJsR7WivPNoqna2hTizuTk/YbJmcFci/Qj/NUhzVFG3r8qSYVtA/Nob13Bog+frPzZUzEq2LZ8zSfK7E093eM8veAIVE1X2jr/EQYwKOzy3EwZ+dbOHCeocdy2T9qXSfeTHRAA9aIj6QEvPlVDulhAusSVUtu4FH/+riF5Z60EJKalgoARcKnG9b9xpnMQVhYzFHpa9mezzYPCgej5FceJuA9jKgcmiWnf0GTIcMeb7YRo6Vlx+GFVbP7/dWaEBLC9QOTolifHF7KDpXD2w9RvzT5JbZc90EhNGbpLIwR/09kRsU7OX2ZDsTDookmDaf4NDSl1smF3R+tkK+NJioaVGBhB+Qhoy4o/AnR+rmBOiO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update the list of files where DRM ioctls are defined.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: no change

[Since having multiple maintainers trying to merge these would
cause some conflicts, it would be more manageable for Jon to
take all of these through the docs-next tree.]

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: intel-gfx@lists.freedesktop.org
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org

 Documentation/userspace-api/ioctl/ioctl-number.rst |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-next-20261116.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20261116/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -98,6 +98,7 @@ Code  Seq#    Include File
 0x1b  all                                                              InfiniBand Subsystem
                                                                        <http://infiniband.sourceforge.net/>
 0x20  all    drivers/cdrom/cm206.h
+0x20  00-01  drivers/gpu/drm/amd/amdgpu/amdgpu_umr.h
 0x22  all    scsi/sg.h
 0x3E  00-0F  linux/counter.h                                           <mailto:linux-iio@vger.kernel.org>
 '!'   00-1F  uapi/linux/seccomp.h
@@ -268,7 +269,7 @@ Code  Seq#    Include File
 'c'   08     drivers/scsi/ch.c                                         conflict!
 'c'   80-9F  arch/s390/include/asm/chsc.h                              conflict!
 'c'   A0-AF  arch/x86/include/asm/msr.h conflict!
-'d'   00-FF  linux/char/drm/drm.h                                      conflict!
+'d'   00-FF  drm/drm.h                                                 conflict!
 'd'   02-40  pcmcia/ds.h                                               conflict!
 'd'   F0-FF  linux/digi1.h
 'e'   all    linux/digi1.h                                             conflict!
@@ -292,6 +293,8 @@ Code  Seq#    Include File
                                                                        <mailto:zapman@interlan.net>
 'h'   00-1F  linux/hpet.h                                              conflict!
 'h'   80-8F  fs/hfsplus/ioctl.c
+'i'   00-02  drm/i915_drm.h
+'i'   00-04  drm/xe_drm.h
 'i'   00-3F  linux/i2o-dev.h                                           conflict!
 'i'   0B-1F  linux/ipmi.h                                              conflict!
 'i'   80-8F  linux/i8k.h

