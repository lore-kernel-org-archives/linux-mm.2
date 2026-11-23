Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA201606A33C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XClddXr3
Received: by kanga.kvack.org (Postfix)
	id 1F7426B05B1; Mon, 23 Nov 2026 14:01:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CF086B05B4; Mon, 23 Nov 2026 14:01:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 097A86B05D5; Mon, 23 Nov 2026 14:01:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D643A6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:01:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61272120988
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:01:03 +0000 (UTC)
X-FDA: 85467301206.12.3C2613E
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2E1821C0008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:01:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XClddXr3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3a40EawgKCPYbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3a40EawgKCPYbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795460461;
	b=lsuv/rntM5EQ4t0Y9jS5JH5cV8ZM/D/YlMM3xxyUbrlV83nbiSOO5d4u/1zRBzDa/4DAd/
	qzoo9Oxtm1rHQBio2kv7rGbJBNf9viACx/AopXCEUEqbIsP5cK1D9xL573ICodJe945Xh7
	RnzHDbwnVerfhssSDvfhSzrQhVpjWes=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qPu3il+pjsqwuiugOKKp5YPgP+PXsAspKhyyUg3SNA=;
	b=NBDOVSmJn+zhGy49r+lG0fF400gfS2q/MxuoMzmF6IYwj9CrDk9E0nM5PGChCzDMPuShyK
	Nyij76T/6qEJciT6UXzqB1seFgWmL2fb1WIZcJkMv3bh6eivqOHRMzjjGzFhWwlKPzHXOM
	VUE/t3hyg2u9wWkCkaKcHTlnvyze6fM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XClddXr3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3a40EawgKCPYbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3a40EawgKCPYbkYrjYaiemmejc.amkjglsv-kkitYai.mpe@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-57489477aabso4090460b6e.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795460460; x=1796065260; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/qPu3il+pjsqwuiugOKKp5YPgP+PXsAspKhyyUg3SNA=;
        b=XClddXr3qHc9WBkGPS7EjOO0MztkF6CxKrVZxP1ot/1jS+xtE4wcbjUeOHSU4YstXH
         m0KZUz2r3tdaXOKAliqmbcxGyeSIugkY157gKUbTN20y8HwNoPY92dKeFNbjada94x2d
         dtr8wAiyzU9dqhBhzr2VUcwMo5JWkxyUJCXFfe/qppzMxouEZiew8AH1UdwBvHaXeDul
         qpddmnYfEmWBSFSxf+8uOqdVQlZlDqBOVDjh9NHNM8wwwc/57KXOLlesFVw1UAlz+t/g
         D3t0tWpEiyrqNmtaxmoZ1vyE0dLwGp5Fx/75i5SLL+IBnCup2dnmMApsxtMn4tu9paWS
         wW0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795460460; x=1796065260;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/qPu3il+pjsqwuiugOKKp5YPgP+PXsAspKhyyUg3SNA=;
        b=rHVEWP3Qx+lcgm14STzvQwJHu474qdMTwW8E2DCsqfcdplOsoQjXuaOg9OYIHYvOHY
         LEoDWxH9HhiFlZTLGaOLkEVq8O+TWfVXbPA5TG4y6v1lu2GMIiOXTteLNto6bT4hD+rQ
         imEDNzXjfUiOioyccZPU4lii/nIgPPJ6RTm7VYUhKp6Vccv/PPatdPdVmL3AX98SXQtZ
         kCWAYADDsId0h+qTuIJndQpEQCS8PyvjQkr+Rsq2glbSl+TPbGzBAtTXxp4K6UFZdMfi
         Txa3msW3tcLrDILpPl/Yfanooqi2uNwo9It98dmiRHQkuYpwItkE/Jv6wwQkktnr4gyu
         cRbA==
X-Forwarded-Encrypted: i=1; AL+hErGvu4ITvFQKbfb4MtpnSfDDsLcFLNIH2kImk8SooYi0Qi2dslJ5veFXHCcw44s9pzhDM2k2vIPRdw==@kvack.org
X-Gm-Message-State: APuU4Z9LObx7nJM/nRxBO/UnOc7s3EAXNmL/YAIeATvEIdqSLyro8f+s
	NtjrJdAQQUjwKYBeOjHmwortmF7iChjN+QINGyzPw+ujzptKDUo95UyNbzUgPpxhrlbFSFEbqWB
	HBK9timoinb0SUg==
X-Received: from jakj15.prod.google.com ([2002:a05:6638:148f:b0:61c:e96b:9d4d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:22a2:b0:572:d0fb:ae61 with SMTP id 5614622812f47-57a0a20e564mr12818304b6e.49.1795460459403;
 Mon, 23 Nov 2026 11:00:59 -0800 (PST)
Date: Mon, 23 Nov 2026 19:00:43 +0000
In-Reply-To: <20261118223704.3286085-10-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261118223704.3286085-10-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123190045.2166865-2-dmatlack@google.com>
Subject: [PATCH] amend! PCI: liveupdate: Adopt ACS controls in incoming
 preserved devices
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alex Williamson <alex.williamson@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 2E1821C0008
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: d73na5iiyrurxgwo63qqcq5tduimrmxz
X-HE-Tag: 1795460461-261654
X-HE-Meta: U2FsdGVkX1/XcddopEYNU29+pTqBpJqXjF0skxyDqAPKr24H1TwJeWgVF5sL6Sa9+Y5fg5hoh55bxRKje0frXXN2kNhk5nyQHk4r0/hOF2XwyjXdNaGaMhwyOFp16cipJQlgLQlXzi7FAq9e7+ONtWsPxiAHrIKidCHdYqfQAuaqcA5cKTB48+LkZWCrAPSmXNy2iQ/icRpf9HVSS84dM7oF1NXlqWvImAAT8yPfg9SUV121jI1kK2tRIk6VQSxqgW74BjwKGcgCtdG6DghHlZ15jefDdPV2L1yNMo7EMNo+POgdczOSFzYDcBYdjhMUDKJc+oUzMvUVnocAGpQDhO9eA6ZHq4gYWtcDkvknHfAnAxPV0dKwZS43TeF8sjvqc5LjWS8rdPb57KhTiNKQKL1BN9DDNyesdYDwPi0K8j4jhix3tDVpKUIHLn8jw30Ir6sik3Aoq1/E88WiGGrt4vzzVRMqj9C8RymmKETbuEfuZsH9OQvMNFr/lNnsXf1pmKQaHgYotcE+fcYdDjPxXksgQ1UTUKiPkAv4VEafHp1LXNhGgH6sdm+hVWRcbNl7k3vuszi88SgAJGyxG08UtMLNoeRXJ+aZQD0IoqFaBYs8QWobuha41ONKawS7WWx2AAGtuPo3twqz7VOY+qixYcOkM6Xvtf2/WheVv1QNtY2lFYxbEWR5MJrXYq/5NxHvz3sV75g3lKnIJA0zM92+D8gmEe/1j1nr6JOiXDbigo2k9aKr8jyOx8oAXz1fS5LZHd53QMbFnlsG5bl2YOuj/I1PLIB9x2EtdjSt9lZsXZDURXd6BkhEaaVbWKUDf2c2qn+uOEoIAPtoxrydcA6Vd8Y7nmSeIszoWcuUHexsXXVx41/Fy1M9rjEpBAAObvOX0Ym7nIszNfMnsSskCeCruksjFRSvN3wRvHk7jcc38+QW2wEIW/EijEsAN3Bbw7JdTPPOBV/1cXxz4RQ1Op7
 atzgqwCY
 Jk4Ex3FDAksBWa9POeutJszToPhqwRFlKKlh4nGs4lykvgkoNgB9Dd9yIdq127lf+5qwzbY6mWi+bgpGk17rTKS8g3zhKKt40x650Hj3tbdSV7fhbk9SuvvwxJ09Vbw40+4SZycHd/VtGuwrk0Leg1QMJHxt0tf4BQHbqUcrS+gg1Gj2A+S4quv8YKK+AgpVaVaoINRfCrfSED72f8uDzFeb+eDH6h4+JrpaTMWB0PB5L7GvEvN8vAWdSUrjbWVcPbJRELDocG6dOfwe9+FgBderMl8q6kBefLpT23H51zeX4FI+9b94tHiDrQDQTt2B44mqMjU0XKJXYV6ouzn6kiOqDuqPkIwhCEXYJeYdfHRKPKFr9WZNGm3Wezhf4CgalJFfscVQn8JBCLlXnhQNnEhvt6ZYEs8CNIU3YQZ/tXErO5rYotrLcos3IPlMhZnBYzA3YAsJMr+jRK9VBhl5dVk4kV1dI9tBrtZZVmiHDlZ6FQyVXe2Y2KFooStM3QDTOBu3uX+oYtrzRhQZ5flJbnHaqjkRxnUxgkVB6tYGElX7+1Z1KX8oU9j/YLKsUuYCc4pvQegNhrLDYs3uHR+q69ZT7nWTWrgu93VjmElLBRir8ihY/CGVUp0b1pg72r1Aa1B71GK6FNVw8r+cQ0jFCKZx8PbTocFCmKCl1bbFjSTudnSU55CTBY7eBANbXw4eFK5PhdpYzdiWYZX2bWlWXqmR4j0r4gADRbmKVsesWMluM5G1KO9MH7c3muE9rsE6JhVbJp3NAc0fSTsR+TNy1JHO6NLvx1Nd2Zi2obKi3evg50kK8hP0qfilQDek3+S/qNawNR0hxFMeUro4BpsRcZLus8KPnY249co2QCks5QLQzecFM05FoPh7b+h/Jvz1M9LdnU9eUKp2COCRmzEiQt30SrcRffXhI3SYUtG0SriAkdsao/OlwMx1POh2/HlI1CddbCRtD9vK0JCY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PCI: liveupdate: Adopt ACS controls in incoming preserved devices

Adopt Access Control Services (ACS) controls on all incoming preserved
devices (endpoints and upstream bridges) during a Live Update.

Adopting ACS controls avoids changing routing rules while memory
transactions are in flight from preserved devices. It also keeps IOMMU
groups from changing during or after Live Update.

The adopted controls are recorded by the pci_save_state() call in
pci_bus_add_device(), which runs before drivers bind, so they are
reapplied by pci_restore_state() if the device is reset. Panic if an
incoming preserved device has no ACS save buffer, since the adopted
controls would be silently lost by the first reset.

To simplify ACS adoption, reject preserving any devices that require
quirks to enable ACS as those quirks would also have to take Live Update
into account. If such a quirk matches an incoming preserved device
anyway, e.g. because it was added in the new kernel, log a warning and
adopt the device's ACS controls regardless, rather than reprogram a
device in the path of a preserved device's memory transactions. The
previous kernel did not apply such a quirk, so it programmed the
standard ACS Control register. Allocate the ACS save buffer for these
devices too, so that the adopted controls are kept across resets.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Alex Williamson <alex.williamson@nvidia.com>
Link: https://patch.msgid.link/20261118223704.3286085-10-dmatlack@google.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---

Notes:
    This amend! also replaces the commit message when squashed with
    git rebase --autosquash: it explains the ACS quirk save buffer case
    (Pranjal) and collects the Reviewed-by tags from Pranjal and Alex. The
    message already includes your Link: and Signed-off-by: trailers from
    lu-pci-preservation.

 drivers/pci/pci.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b5b578355a1b..f3d58b5e7a5d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1073,10 +1073,14 @@ static void pci_allocate_acs_save_buffer(struct pci_dev *dev)
 	/*
 	 * Devices that rely on device-specific quirks to enable an ACS
 	 * equivalent keep that configuration outside of the ACS Control
-	 * register, so they are configured from scratch on restore. The
-	 * exception is devices preserved across a Live Update, which always
-	 * adopt the ACS controls established by the previous kernel and need
-	 * the buffer to keep them across resets.
+	 * register, so they are configured from scratch on restore.
+	 *
+	 * The exception is devices preserved across a Live Update. The
+	 * previous kernel refuses to preserve devices that need such a quirk,
+	 * so a quirk can only match here if the previous kernel did not apply
+	 * it (e.g. the quirk is new in this kernel). The previous kernel then
+	 * programmed the standard ACS Control register, so save it to keep
+	 * the adopted controls across resets.
 	 */
 	if (pci_need_dev_specific_enable_acs(dev) &&
 	    !pci_liveupdate_was_incoming(dev))

base-commit: fd54e32f7903199e8acb2762dd2debfffe4501c4
prerequisite-patch-id: ac616bdf67b652da754c7b00a368613d345ae384
-- 
2.56.1.809.ga0b61035b5-goog


