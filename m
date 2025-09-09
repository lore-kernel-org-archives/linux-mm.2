Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 196F3CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552B68E001D; Tue,  9 Sep 2025 16:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF0D8E0019; Tue,  9 Sep 2025 16:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DB18E001D; Tue,  9 Sep 2025 16:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 275B98E0019
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:15:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4BD1C072B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:36 +0000 (UTC)
X-FDA: 83870817072.09.C440144
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9E682180011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=tUHIM9Il;
	spf=pass (imf06.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6j9zrtMltmIoN7tcvqfcj39ZzhThRROT8000Oa99k0=;
	b=V+b1pagH8haRd84NwEYihnASEGWqr0OhEG3p0XJtNw1AKb8ACbrTCT3LHlFqfkG4JbyuUx
	jU3c4TCJw/Ah42ipzkOPJNHHZVHvpwaDbKpE8bSrTn0DkPI+mkDLUqWYV+xZawyJx0Dtjf
	Z+mRD6TON3Ax619ourVunxM7Uiw+Ac8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448935; a=rsa-sha256;
	cv=none;
	b=TSlP5f3ifc8SovmKW4+623A8TJZD30eTYhESE6QPEQhZcmFTVjS01uEmtql2j2psSxuZ8i
	e1sJljNNBHquBExb+muFpkd34/YyyqCMpKyl/I/YU4BGOgSXkkjbKVsHsp2xJZy9c9s2P5
	kLixx4XIZk/G+G2T/IOrzfUpodZK8SY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=tUHIM9Il;
	spf=pass (imf06.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 93B5EC017C;
	Tue, 09 Sep 2025 23:15:32 +0300 (MSK)
Received: from localhost.localdomain (172.31.115.73-vpn.dhcp.yndx.net [172.31.115.73])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id IFQqlX5GteA0-lKmQ6Yfi;
	Tue, 09 Sep 2025 23:15:32 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com;
	s=default; t=1757448932;
	bh=v6j9zrtMltmIoN7tcvqfcj39ZzhThRROT8000Oa99k0=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=tUHIM9IlFhPrnvOXOM+8JQ/i0mj302skwkptt6zMP16DhVcdP4tW4deIOK4JJP3yD
	 mN3ebdg4uVK1ZkH0Io+gOBUGzVZlGDfE8Uh2rX0ZDfqoO6ePTTS6rxm/DASPVuY9h0
	 iwbPtIEVLaRWS89T8gLAY0+3oaK1BizzhT9GYSH4=
From: Andrey Ryabinin <arbn@yandex-team.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	James Gowans <jgowans@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Baoquan He <bhe@redhat.com>,
	kexec@lists.infradead.org,
	Pratyush Yadav <ptyadav@amazon.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Rientjes <rientjes@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	Ashish.Kalra@amd.com,
	William Tu <witu@nvidia.com>,
	David Matlack <dmatlack@google.com>,
	Andrey Ryabinin <arbn@yandex-team.com>
Subject: [PATCH v3 2/7] kho: move scratch memory in separate helper.
Date: Tue,  9 Sep 2025 22:14:37 +0200
Message-ID: <20250909201446.13138-3-arbn@yandex-team.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250909201446.13138-1-arbn@yandex-team.com>
References: <20250909201446.13138-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9E682180011
X-Stat-Signature: 8xnueuuprboaxpsoghicy9y635ckzzzs
X-Rspam-User: 
X-HE-Tag: 1757448934-946830
X-HE-Meta: U2FsdGVkX1/QxwmqseQS3ihwM88u5e+wR3CRuZxU2DWZITjg+TChzVVydkv7yhgpX9v5gDjpnfrfZcezv6hqsjMEm3v5VRdpWAGVUbtJFBYtZ/OZCneEfeGPBzeT7hTlcDFNHXX8TzKafNmekug8pvWQeDpJkXrsPLI58j5qr4W1e6b9YTkWVrGV2w7pQgHSAmR5JTwqHTtQh1h00NvQay3+rncbXWW7cGkGm9GsAT6x/aGcJabgGd++PU+tJSswsvtcxNeg2bMesKmYuOmIhsoPAYcF2m/cEAVBcnlFSm4YoISlF8o2ks0ZN8aeJ7pQmuYqamghhvTJiyQcSYgbLgP18hYtsIECAol9P8zFQ4JvDwviutpehpJTPaPz+bc0YhMZmRpsEntZnENeg/LeQKldJiVRUOAsA5s0EBEagiG1eTlkywx/+XtSzC2kfZGIxLa8JzHClW8+aqIITEDtLpJ5OWVYSIZqizO1f1XKLM9XAmHk3tLmKG70TrZCx1ywJiVqsor6OGAVbNBt/kJGKNjQeY4iFA/zt3dBvULJSyabOCM530CzWpMgmselyme4wEIwkMjJy1WdkkEzoOrosXTY1tEViBxYhPMQPrGGwKfoG/QGF9uf5sj7cYNVSoZSIQwR3Btrk2YEuDBeV6Vw+NbNCnIA4geRpWuEWKDouLB++noXWSNKkt9QDNrgBeV0SIALP71iJ2lgL4MdJr9hCKDXpx28wZhVDSngJg/c5iw++u1Em5tjlpB/y48SQKKo+WbSuNsDrBUCkscmLw2OnBdmxzrWJBBHnWB4Qzvl10RcFBnBvPbjPGm6i++0d6+/gHqBCzzaWIDnyEv9U+0q7mvPPvtVk8vqHjRbLxoKl7tQTZIu1J8C6nu+ixNf1u8geSUp8OSkebysZRmDbCpqKTwZ2YdBHDdKE82NEB/suYV0lsoM6RMJjlo5WR3g6qDNh3aGB7pcvPPu6YFyyEq
 mNU5YOTw
 sgHILcPrlbbKPNZ4Ao9bvPQ9/KaovwAD+MECb4hBttS8V8g2uZLNnS7vKFMByUtmTdcgjEpXm+TefZjnf9UBhg31d46RstlsAgafjYJbz6lKGyeNyGJN7Ml6hpLKjEKSi/u+9Ha62vesX4v8+V3ISSXDpSgr2WJ/S7n7p1s8lHaNYiUqDurJ1wDs+F0TEMzTT/bIfmhenr14G45dxXndWVXNgbgga/XzRTAeWm0iSuxMs7W1F+Yg/n3po1twtl+yYG/wMIP7mMbroo2pBPSuI8uuZwahDMgkpB2womVuyN7QQq7MLThLnWxADuY0Iy1EdiduVdoxw/aYrY5DPjdEK1NpuAWfmpJpwINwQT5lojNnrWB/zVJumAsOH/UoGi+AwIwQuoPrPWD/GgXHYuJFIPTTf+zva44diHMUi/jLEXkkt33s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move scratch memory initialization logic from kho_populate() into a new
helper function kho_scrath_init().

This prepares for using KSTATE in KHO instead of FDT.

Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 kernel/liveupdate/kexec_handover.c | 34 ++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index e5a436893f5b..a99425fdfce4 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1111,19 +1111,12 @@ static int __init kho_fdt_init(phys_addr_t fdt_phys, u64 fdt_len)
 	return err;
 }
 
-void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
-			 phys_addr_t scratch_phys, u64 scratch_len)
+static int __init kho_scratch_init(phys_addr_t scratch_phys, u64 scratch_len)
 {
-
-	struct kho_scratch *scratch = NULL;
 	int err = 0;
+	struct kho_scratch *scratch = NULL;
 	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 
-
-	err = kho_fdt_init(fdt_phys, fdt_len);
-	if (err)
-		goto out;
-
 	scratch = early_memremap(scratch_phys, scratch_len);
 	if (!scratch) {
 		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
@@ -1161,6 +1154,27 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	 * memory reservations from the previous kernel.
 	 */
 	memblock_set_kho_scratch_only();
+out:
+	if (scratch)
+		early_memunmap(scratch, scratch_len);
+
+	return err;
+}
+
+void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
+			 phys_addr_t scratch_phys, u64 scratch_len)
+{
+
+	int err = 0;
+	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
+
+	err = kho_fdt_init(fdt_phys, fdt_len);
+	if (err)
+		goto out;
+
+	err = kho_scratch_init(scratch_phys, scratch_len);
+	if (err)
+		goto out;
 
 	kho_in.fdt_phys = fdt_phys;
 	kho_in.scratch_phys = scratch_phys;
@@ -1168,8 +1182,6 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	pr_info("found kexec handover data. Will skip init for some devices\n");
 
 out:
-	if (scratch)
-		early_memunmap(scratch, scratch_len);
 	if (err)
 		pr_warn("disabling KHO revival: %d\n", err);
 }
-- 
2.49.1


