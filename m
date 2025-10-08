Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20C75CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813D88E0032; Wed,  8 Oct 2025 11:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EACF8E0002; Wed,  8 Oct 2025 11:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700928E0032; Wed,  8 Oct 2025 11:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB728E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:32:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2EF071A05A0
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:32:19 +0000 (UTC)
X-FDA: 83975338398.25.F07FEED
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf30.hostedemail.com (Postfix) with ESMTP id 02B2980013
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:32:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=IOHJbPNS;
	spf=pass (imf30.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJuHl5ANbsYhHYcQ1niKCPNcRgMvorpwYhdfPZtGtH8=;
	b=lCNW1+vnl5MDshp34DYCh9rdlvwqDntK2yLsJU6klrB8VCgCnbkEuGpOZ5qtYNmDkEaVbr
	6D5F836GH1qGSOjDe4NVBIcRIdJCaT5Wueu/oDII4Yw0nlP502InaEttJGJsfEDtHJoYDj
	pnN4hUeC56v55sQeXifBqF9E5Mam4Bk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=IOHJbPNS;
	spf=pass (imf30.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937537; a=rsa-sha256;
	cv=none;
	b=W0PGafC5gPr8bFX81DW/T3iD+AU04KRO+JCUHOK8dCVS4b9pXPwgnzF9sYsCpC9TRyK0Uu
	O8FUVC8msDty6yoIpFsE3khbvcWOW7qOQOqCJoLr4ACb86r5mAN1jYW6DnC2d4yHt++KWx
	ef1du+oWv4xVi3KhR/r0qBNK4ce+3kk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937537; x=1791473537;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wJuHl5ANbsYhHYcQ1niKCPNcRgMvorpwYhdfPZtGtH8=;
  b=IOHJbPNSNHUwrZaFUdxYF4YyIkAt85dByxGaIbDtUtD37+m/oPZr62Qf
   gRb6AK2i2abvUx4mWLIGksbZuFSnor2EtDt7xQj1EoKoFxatcW4+jfPjW
   s1eF66iwSBYjxEMXvp7rZttF9Obwy99fFW9wu1xFLqTuRfqY+YQOtONJc
   M170Vj9P3d6yhInK91Mt9NdeHrLaOVDrJayKtbAXtNHPi9UYFeeB/z7qj
   37ATTXYLXwr8TXe05BBBnSsYNCpx2CkwPNpjVuzhStxox83UmspoWv+00
   k3sw+4uhTr1SUgWnwYCQZuupNZaBIOtiQkJhh+0Kw5ko12lXrBFM92PgB
   w==;
X-CSE-ConnectionGUID: XlW0GsBMRUC+5jdP2aKEvg==
X-CSE-MsgGUID: 5y2YDcGiT525ZQEPUUeGvA==
X-IronPort-AV: E=Sophos;i="6.19,213,1754956800"; 
   d="scan'208";a="4521771"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:32:15 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:9859]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.27.3:2525] with esmtp (Farcaster)
 id 2650ce3a-12fe-4ef5-9670-f061730a3de1; Wed, 8 Oct 2025 15:32:15 +0000 (UTC)
X-Farcaster-Flow-ID: 2650ce3a-12fe-4ef5-9670-f061730a3de1
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:32:13 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:32:00 +0000
From: Eliav Farber <farbere@amazon.com>
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>,
	<rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>,
	<jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>,
	<dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
	<jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>,
	<David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH v3 08/19 5.15.y] minmax: make generic MIN() and MAX() macros available everywhere
Date: Wed, 8 Oct 2025 15:29:33 +0000
Message-ID: <20251008152946.29285-9-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWB004.ant.amazon.com (10.13.139.150) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: kduy31juih63msrkhkz4787gi4htr6rz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 02B2980013
X-HE-Tag: 1759937536-689348
X-HE-Meta: U2FsdGVkX192QFhwlT9wMRIN29Flwz92ZpdkTPfq4tVscM14KTTWwNXt2Eh26IfEVe67g2Ojh8WOg5xuk7mfTob+t27RibitZponlLstqQ9Blw4w7g2CeMM/c+0pnHZbW4QBECSo0yQzafM60uGMbvOmZS54fM9hKVKzML5NJ0MmdDWblMM5DfSbD5pyJODzvDVsPdpZjXZjL16IGBgeRBQ7zDP5mqkJtlYOjGgNgvjDfG38dUSMOr4yVtywAVh7CXgYxP3FpHltUJ0Ia797cb0xx6ij0cYsBbuKQnaIr8pZfDnbgOUmQ9+/uu39srX/XNmQOLiLhcEqg1iR6DJKKrPj8HvcX3Oy6mcss7YW0sXh3lGUfcWQV+q0v1myF1SX/B1C2CRqTsWjhyyCX1O5EMT4rxaNnTct7VCd4ZSlaZo+aA2E7Eo99MGJnunQuVHMBuJAvQ78u44zxmYuOpby2vdbzDyqz2Pk5iuT72LR/8YV/elvjQkuxAivRYORpZ36lSgDIa3N8jsTEFNukVaEIMe7CkrlauusOvxSfBuK2BrC7e5ifyc3GLLumO9kzNJ1x3rp+ZYzcjHEscqJNF2Bcdf2AWQX5Bf5HAl8bYLe7TTr61RyG4idLhumpYUY5eBPJLdAQHkm4NS6R+dn7AOK+gWqgglkxkvSJ+hEIRRuVLNzte9PGxde1qjjS0Snh42SpUdqKFzYSQRTcWIF2zutgTOjrv5EvZh1UYyEW4ZVhWPoB5UA0GgqMhNV05Y3YL8SGbAVjkp8/Ywa+PQ1Qfo7vdiT9sHHy3jTzBVC4yvI50dGaBWPbuk5V3X2/NZNAOqWzZUWtZXjAYJc1K5V1Sm93/x3+5ApcSF38+gSN6lDDtNgXgTuRp4/inbrKcWKS8dwG58HJADf+SF4AQmEQsys+6TaWb4FqVrHwYUIXFX/gd4xOcztsBy+8UHH/Ar0BwMlvp9rY26TYhYeSpGoSyQ
 IEMfweBx
 CGy7nAzVt+7IVl0vYJE+MARhe8gh/Q655QaXZTmUuIzW/b2/mziRgzZ56k9rKWkR4V+BTDHaI+AR48Ut4r0jVmv3kJZ3jyAjN3aBN9NgUMovoV0I0H2HPa5td9JJ8Dgr8QNgpsTTsx8Xj694urRHJBSTke+g0ZC677t9MiTlI5hrQDKtyFX2NN8NSG/FW6IK6KlB4Bi8W/QSUBsiCA1Jen6fPi1c63vQ0yG71l+0Qj2BCmWlp/bk8RwM8JErBhOyNAX7MRPzsW3WbBs9HF3cu+dTFKsLwAXFb93QPY1odt+h6+dT8L9rq4KiYYLKY4qIUzrFSDx/kp3GRSvuCg/T8C0ZEmYEyie98NxzcQHHkDhDn0Hm7tA2oJsBYHuHpazeQfNylkLlQ3nFm7TyOc3ZIRxOUHM1NsOs2zhxtPftK6FuhQ9ono5HiH5dbi4xE4TjBPByWPrqJzWg60y3eoKRvRUPkDXLIkZFuH4E4Ys85OGEXyY87HygkHJQB7Mu2M0mGsYzsMVhQgq56rXMRjQQBl3eU9GaCDOqk8UrxIx0oSfPwwSklFqMTyFUzY5BRLKtUTUIQKFYx/FcAJBYJ8AR3CEeDBSP0rPKaUlHJAlKbjA3g4TqxkVZuG9DG3ofNfKuoCqlWNI3/BhYTPrHnJ9nG3YCBCB4h2rbcHPZJrgJmjHUVcOtW08SoqjS0ozxets24K66MnLrGFAaNR3evtEbIi1OK7G1h4zN2PzXOzzhEPjvBQBxn7vsAOt6RO0aoz6i37+gJs0+jiaqw92HU/rorHR6PoP10Ae9fLAo2LnBmjV6cmn46dQJsDZoCSmEDZCsGDT5feEmMaBEbN70+Z8XqiFP1gFBlKWJJK50OPA4TgkP+RlB1b66VJfXZjffxq40ZVdCIoFSjiRamHzbkBlmtmxhjqSa4z8WPG3/pGKa2HfG81cBMHs/5ZINnqCQzRqFZeOT128dYDOfUb04jIEBFt3KKdMZD
 Ikdp8aIn
 Xql+SaPGRC6A4f5U8+PM5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 1a251f52cfdc417c84411a056bc142cbd77baef4 ]

This just standardizes the use of MIN() and MAX() macros, with the very
traditional semantics.  The goal is to use these for C constant
expressions and for top-level / static initializers, and so be able to
simplify the min()/max() macros.

These macro names were used by various kernel code - they are very
traditional, after all - and all such users have been fixed up, with a
few different approaches:

 - trivial duplicated macro definitions have been removed

   Note that 'trivial' here means that it's obviously kernel code that
   already included all the major kernel headers, and thus gets the new
   generic MIN/MAX macros automatically.

 - non-trivial duplicated macro definitions are guarded with #ifndef

   This is the "yes, they define their own versions, but no, the include
   situation is not entirely obvious, and maybe they don't get the
   generic version automatically" case.

 - strange use case #1

   A couple of drivers decided that the way they want to describe their
   versioning is with

	#define MAJ 1
	#define MIN 2
	#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN)

   which adds zero value and I just did my Alexander the Great
   impersonation, and rewrote that pointless Gordian knot as

	#define DRV_VERSION "1.2"

   instead.

 - strange use case #2

   A couple of drivers thought that it's a good idea to have a random
   'MIN' or 'MAX' define for a value or index into a table, rather than
   the traditional macro that takes arguments.

   These values were re-written as C enum's instead. The new
   function-line macros only expand when followed by an open
   parenthesis, and thus don't clash with enum use.

Happily, there weren't really all that many of these cases, and a lot of
users already had the pattern of using '#ifndef' guarding (or in one
case just using '#undef MIN') before defining their own private version
that does the same thing. I left such cases alone.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 arch/um/drivers/mconsole_user.c               |  2 ++
 drivers/edac/skx_common.h                     |  1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu.h           |  2 ++
 .../drm/amd/display/modules/hdcp/hdcp_ddc.c   |  2 ++
 .../drm/amd/pm/powerplay/hwmgr/ppevvmath.h    | 14 +++++++----
 .../amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   |  2 ++
 drivers/gpu/drm/radeon/evergreen_cs.c         |  2 ++
 drivers/hwmon/adt7475.c                       | 24 +++++++++----------
 drivers/media/dvb-frontends/stv0367_priv.h    |  3 +++
 drivers/net/fjes/fjes_main.c                  |  4 +---
 drivers/nfc/pn544/i2c.c                       |  2 --
 drivers/platform/x86/sony-laptop.c            |  1 -
 drivers/scsi/isci/init.c                      |  6 +----
 .../pci/hive_isp_css_include/math_support.h   |  5 ----
 include/linux/minmax.h                        |  2 ++
 kernel/trace/preemptirq_delay_test.c          |  2 --
 lib/btree.c                                   |  1 -
 lib/decompress_unlzma.c                       |  2 ++
 lib/zstd/zstd_internal.h                      |  2 --
 mm/zsmalloc.c                                 |  1 -
 tools/testing/selftests/vm/mremap_test.c      |  2 ++
 21 files changed, 43 insertions(+), 39 deletions(-)

diff --git a/arch/um/drivers/mconsole_user.c b/arch/um/drivers/mconsole_user.c
index e24298a734be..a04cd13c6315 100644
--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -71,7 +71,9 @@ static struct mconsole_command *mconsole_parse(struct mc_request *req)
 	return NULL;
 }
 
+#ifndef MIN
 #define MIN(a,b) ((a)<(b) ? (a):(b))
+#endif
 
 #define STRINGX(x) #x
 #define STRING(x) STRINGX(x)
diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index 13f761930b4f..1a78f18cf7fe 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -44,7 +44,6 @@
 #define I10NM_NUM_CHANNELS	MAX(I10NM_NUM_DDR_CHANNELS, I10NM_NUM_HBM_CHANNELS)
 #define I10NM_NUM_DIMMS		MAX(I10NM_NUM_DDR_DIMMS, I10NM_NUM_HBM_DIMMS)
 
-#define MAX(a, b)	((a) > (b) ? (a) : (b))
 #define NUM_IMC		MAX(SKX_NUM_IMC, I10NM_NUM_IMC)
 #define NUM_CHANNELS	MAX(SKX_NUM_CHANNELS, I10NM_NUM_CHANNELS)
 #define NUM_DIMMS	MAX(SKX_NUM_DIMMS, I10NM_NUM_DIMMS)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index dbef22f56482..1ee8663fd866 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1277,7 +1277,9 @@ int emu_soc_asic_init(struct amdgpu_device *adev);
 
 #define amdgpu_inc_vram_lost(adev) atomic_inc(&((adev)->vram_lost_counter));
 
+#ifndef MIN
 #define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
+#endif
 
 /* Common functions */
 bool amdgpu_device_has_job_running(struct amdgpu_device *adev);
diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
index 1b2df97226a3..40286e8dd4e1 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
@@ -25,7 +25,9 @@
 
 #include "hdcp.h"
 
+#ifndef MIN
 #define MIN(a, b) ((a) < (b) ? (a) : (b))
+#endif
 #define HDCP_I2C_ADDR 0x3a	/* 0x74 >> 1*/
 #define KSV_READ_SIZE 0xf	/* 0x6803b - 0x6802c */
 #define HDCP_MAX_AUX_TRANSACTION_SIZE 16
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
index dac29fe6cfc6..abbdb7731996 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
@@ -22,12 +22,18 @@
  */
 #include <asm/div64.h>
 
-#define SHIFT_AMOUNT 16 /* We multiply all original integers with 2^SHIFT_AMOUNT to get the fInt representation */
+enum ppevvmath_constants {
+	/* We multiply all original integers with 2^SHIFT_AMOUNT to get the fInt representation */
+	SHIFT_AMOUNT	= 16,
 
-#define PRECISION 5 /* Change this value to change the number of decimal places in the final output - 5 is a good default */
+	/* Change this value to change the number of decimal places in the final output - 5 is a good default */
+	PRECISION	=  5,
 
-#define SHIFTED_2 (2 << SHIFT_AMOUNT)
-#define MAX (1 << (SHIFT_AMOUNT - 1)) - 1 /* 32767 - Might change in the future */
+	SHIFTED_2	= (2 << SHIFT_AMOUNT),
+
+	/* 32767 - Might change in the future */
+	MAX		= (1 << (SHIFT_AMOUNT - 1)) - 1,
+};
 
 /* -------------------------------------------------------------------------------
  * NEW TYPE - fINT
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index d4fde146bd4c..95894c25881a 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -1964,7 +1964,9 @@ static void sienna_cichlid_get_override_pcie_settings(struct smu_context *smu,
 	}
 }
 
+#ifndef MAX
 #define MAX(a, b)	((a) > (b) ? (a) : (b))
+#endif
 
 static int sienna_cichlid_update_pcie_parameters(struct smu_context *smu,
 					 uint32_t pcie_gen_cap,
diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index 820c2c3641d3..1311f10fad66 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -33,8 +33,10 @@
 #include "evergreen_reg_safe.h"
 #include "cayman_reg_safe.h"
 
+#ifndef MIN
 #define MAX(a,b)                   (((a)>(b))?(a):(b))
 #define MIN(a,b)                   (((a)<(b))?(a):(b))
+#endif
 
 #define REG_SAFE_BM_SIZE ARRAY_SIZE(evergreen_reg_safe_bm)
 
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index b4c0f01f52c4..1e0678eb0077 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -23,23 +23,23 @@
 #include <linux/util_macros.h>
 
 /* Indexes for the sysfs hooks */
-
-#define INPUT		0
-#define MIN		1
-#define MAX		2
-#define CONTROL		3
-#define OFFSET		3
-#define AUTOMIN		4
-#define THERM		5
-#define HYSTERSIS	6
-
+enum adt_sysfs_id {
+	INPUT		= 0,
+	MIN		= 1,
+	MAX		= 2,
+	CONTROL		= 3,
+	OFFSET		= 3,	// Dup
+	AUTOMIN		= 4,
+	THERM		= 5,
+	HYSTERSIS	= 6,
 /*
  * These are unique identifiers for the sysfs functions - unlike the
  * numbers above, these are not also indexes into an array
  */
+	ALARM		= 9,
+	FAULT		= 10,
+};
 
-#define ALARM		9
-#define FAULT		10
 
 /* 7475 Common Registers */
 
diff --git a/drivers/media/dvb-frontends/stv0367_priv.h b/drivers/media/dvb-frontends/stv0367_priv.h
index 617f605947b2..7f056d1cce82 100644
--- a/drivers/media/dvb-frontends/stv0367_priv.h
+++ b/drivers/media/dvb-frontends/stv0367_priv.h
@@ -25,8 +25,11 @@
 #endif
 
 /* MACRO definitions */
+#ifndef MIN
 #define MAX(X, Y) ((X) >= (Y) ? (X) : (Y))
 #define MIN(X, Y) ((X) <= (Y) ? (X) : (Y))
+#endif
+
 #define INRANGE(X, Y, Z) \
 	((((X) <= (Y)) && ((Y) <= (Z))) || \
 	(((Z) <= (Y)) && ((Y) <= (X))) ? 1 : 0)
diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 1d1808afd529..792c22ba5b00 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -14,9 +14,7 @@
 #include "fjes.h"
 #include "fjes_trace.h"
 
-#define MAJ 1
-#define MIN 2
-#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN)
+#define DRV_VERSION "1.2"
 #define DRV_NAME	"fjes"
 char fjes_driver_name[] = DRV_NAME;
 char fjes_driver_version[] = DRV_VERSION;
diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 37d26f01986b..fd7026206f58 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -126,8 +126,6 @@ struct pn544_i2c_fw_secure_blob {
 #define PN544_FW_CMD_RESULT_COMMAND_REJECTED 0xE0
 #define PN544_FW_CMD_RESULT_CHUNK_ERROR 0xE6
 
-#define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
-
 #define PN544_FW_WRITE_BUFFER_MAX_LEN 0x9f7
 #define PN544_FW_I2C_MAX_PAYLOAD PN544_HCI_I2C_LLC_MAX_SIZE
 #define PN544_FW_I2C_WRITE_FRAME_HEADER_LEN 8
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 336dee9485d4..3c27d6b66bb4 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -757,7 +757,6 @@ static union acpi_object *__call_snc_method(acpi_handle handle, char *method,
 	return result;
 }
 
-#define MIN(a, b)	(a > b ? b : a)
 static int sony_nc_buffer_call(acpi_handle handle, char *name, u64 *value,
 		void *buffer, size_t buflen)
 {
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index bd73f6925a9d..73144b2966ba 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -65,11 +65,7 @@
 #include "task.h"
 #include "probe_roms.h"
 
-#define MAJ 1
-#define MIN 2
-#define BUILD 0
-#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN) "." \
-	__stringify(BUILD)
+#define DRV_VERSION "1.2.0"
 
 MODULE_VERSION(DRV_VERSION);
 
diff --git a/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h b/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
index a444ec14ff9d..1c17a87a8572 100644
--- a/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
+++ b/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
@@ -31,11 +31,6 @@
 /* A => B */
 #define IMPLIES(a, b)        (!(a) || (b))
 
-/* for preprocessor and array sizing use MIN and MAX
-   otherwise use min and max */
-#define MAX(a, b)            (((a) > (b)) ? (a) : (b))
-#define MIN(a, b)            (((a) < (b)) ? (a) : (b))
-
 #define ROUND_DIV(a, b)      (((b) != 0) ? ((a) + ((b) >> 1)) / (b) : 0)
 #define CEIL_DIV(a, b)       (((b) != 0) ? ((a) + (b) - 1) / (b) : 0)
 #define CEIL_MUL(a, b)       (CEIL_DIV(a, b) * (b))
diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 9c2848abc804..fc384714da45 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -277,6 +277,8 @@ static inline bool in_range32(u32 val, u32 start, u32 len)
  * Use these carefully: no type checking, and uses the arguments
  * multiple times. Use for obvious constants only.
  */
+#define MIN(a,b) __cmp(min,a,b)
+#define MAX(a,b) __cmp(max,a,b)
 #define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
 #define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
 
diff --git a/kernel/trace/preemptirq_delay_test.c b/kernel/trace/preemptirq_delay_test.c
index 8af92dbe98f0..acb0c971a408 100644
--- a/kernel/trace/preemptirq_delay_test.c
+++ b/kernel/trace/preemptirq_delay_test.c
@@ -34,8 +34,6 @@ MODULE_PARM_DESC(cpu_affinity, "Cpu num test is running on");
 
 static struct completion done;
 
-#define MIN(x, y) ((x) < (y) ? (x) : (y))
-
 static void busy_wait(ulong time)
 {
 	u64 start, end;
diff --git a/lib/btree.c b/lib/btree.c
index b4cf08a5c267..b12f99d4c45c 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -43,7 +43,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 
-#define MAX(a, b) ((a) > (b) ? (a) : (b))
 #define NODESIZE MAX(L1_CACHE_BYTES, 128)
 
 struct btree_geo {
diff --git a/lib/decompress_unlzma.c b/lib/decompress_unlzma.c
index 20a858031f12..9d34d35908da 100644
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -37,7 +37,9 @@
 
 #include <linux/decompress/mm.h>
 
+#ifndef MIN
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
+#endif
 
 static long long INIT read_int(unsigned char *ptr, int size)
 {
diff --git a/lib/zstd/zstd_internal.h b/lib/zstd/zstd_internal.h
index dac753397f86..927ed4e8c11c 100644
--- a/lib/zstd/zstd_internal.h
+++ b/lib/zstd/zstd_internal.h
@@ -36,8 +36,6 @@
 /*-*************************************
 *  shared macros
 ***************************************/
-#define MIN(a, b) ((a) < (b) ? (a) : (b))
-#define MAX(a, b) ((a) > (b) ? (a) : (b))
 #define CHECK_F(f)                       \
 	{                                \
 		size_t const errcod = f; \
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 79f389d620c9..fd01f6922874 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -126,7 +126,6 @@
 #define ISOLATED_BITS	3
 #define MAGIC_VAL_BITS	8
 
-#define MAX(a, b) ((a) >= (b) ? (a) : (b))
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
 	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
diff --git a/tools/testing/selftests/vm/mremap_test.c b/tools/testing/selftests/vm/mremap_test.c
index 58775dab3cc6..92fb74865f26 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -22,7 +22,9 @@
 #define VALIDATION_DEFAULT_THRESHOLD 4	/* 4MB */
 #define VALIDATION_NO_THRESHOLD 0	/* Verify the entire region */
 
+#ifndef MIN
 #define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
+#endif
 
 struct config {
 	unsigned long long src_alignment;
-- 
2.47.3


