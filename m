Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA96C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E5B6B0103; Tue, 14 Jul 2026 11:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0E56B0105; Tue, 14 Jul 2026 11:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90216B0106; Tue, 14 Jul 2026 11:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99AC46B0103
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED30E1C03FD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:32 +0000 (UTC)
X-FDA: 84987731304.29.56ECFC4
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id 272FD18001F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oT4xiOY9;
	spf=pass (imf16.hostedemail.com: domain of 3kVJWagcKCOgfSZSXcRQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3kVJWagcKCOgfSZSXcRQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042131;
	b=KsKsy42v6oag7ZMl0yJxW4FkIDBq583KuemeGeBSxkjW5gDPOhHl2fbEMDYb8cHFHl8ZJo
	+s2XwlIfYvXYXOVPreW7JtDBjkpQBjUbNucjKvZTlzIDb9en4DAWfu3oIXbwD1USqpd8WK
	hYzS0WGXLXjMq1eQ+CQ8SyJv+8zt7Ek=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oT4xiOY9;
	spf=pass (imf16.hostedemail.com: domain of 3kVJWagcKCOgfSZSXcRQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3kVJWagcKCOgfSZSXcRQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tk/1w3UkNj58XSSYbOe8ncPxmDwQIUvhVdPzzBUFHPI=;
	b=p1Hco9GzttO3reKQaPKNQ488AIzIUzvZurypoUQzD/pafGDTlfaWrima6aoNdvJXfAPjp8
	gck7r0FKhvQyTws15YKuUhSCDSlf+3Yzx/H1WpjI6sIPXmmV8u2/bCdt//IMaRaWbYjQMQ
	Fdsqo7Y7FkfBurVq6rjDTO1t3v1+mKo=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8488ac68185so6844312b3a.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042130; x=1784646930; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tk/1w3UkNj58XSSYbOe8ncPxmDwQIUvhVdPzzBUFHPI=;
        b=oT4xiOY9BZrbSlIQRpFnz2o14oEVSrfa9wYV3R4GYljHI0b+DEtwk7KAltgXsfCB+X
         mr9SRm1IwuChGr1aR70NhFa3i5lDeA1Yzlvfc4Fl9Ciy+2bKGytCblJhfT0W/Xh2PoyA
         sZhhsfO6RJjZKuVlQnFLOSCv7ezY4Mmyf0aW+q5tL9CS9Db5fWDmJSsU+Xylfn2QiSgy
         WVwcogwICdr5Fvx1IP4GiG+Z4yq/3gwKhMIa9PGmQeJgo78s+n4N8TIxvd8YH2OrBSU7
         POx1RkgPBuMLvb0Ia+A4wIIVbGqF+UhPgt3ptdvk7y+pmo66R/YD8XRrFks1WO+Ji5QI
         IS7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042130; x=1784646930;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tk/1w3UkNj58XSSYbOe8ncPxmDwQIUvhVdPzzBUFHPI=;
        b=QWvaoY6D/ITyfRPB4i+aFixZ0jrhe4a6QYlVXHloJ/k1/TmWEDfSuq8EbX6HHKNV3Z
         avmXDd/o9x7R74gEEibTStISVIxaIhtPlYwyvff/iHQvpwRYS8dB0w8U7i+VSDa0WQrL
         KDIKzQdPGgDm9qLelPR/PAms4qNU9beCf5uhmh2zWYRiofQCgZxa4/JAYmcMeJdDTBlF
         kgNSdtVJiIDswdnBxNTsi+0X7BU3Wt/no+CDkNoHi+eKqeyB5wHbL/U3XdGNtCwiEJhX
         3rIvsEBPzHx7Jr4EvHwbPd3yrNGwNewRNGNvR7fGvevV8k9atrttnMq5wBOINajGUdrH
         9uTQ==
X-Forwarded-Encrypted: i=1; AHgh+RoLwO8eeHXViBPXUsQUTSt+WTP+oKQkwiyhGfvN4GxglkIp9kX/aCMpRVULJq0nlAj/ellJPRaFyg==@kvack.org
X-Gm-Message-State: AOJu0YxpsIASKw9F44VMDuQzhQQ2GMQWPIGGJz0t06hS3HbuD9y/I0b/
	BUOkbmEyRr/ckyJVCezqiM+hevvmTMURsIXNe85o22Kxjoc9E2mk6AB2IwGodA+0CycEWxDdLk0
	XEZpNW8FDYg==
X-Received: from pfet14.prod.google.com ([2002:aa7:938e:0:b0:84a:1163:2ad0])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:c88:b0:847:83bd:6676
 with SMTP id d2e1a72fcca58-8488963aa37mr12799379b3a.17.1784042129679; Tue, 14
 Jul 2026 08:15:29 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:15:04 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-20-vipinsh@google.com>
Subject: [PATCH v5 19/20] vfio: selftests: Verify that opening VFIO device
 fails during Live Update
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 272FD18001F
X-Stat-Signature: 1zkyd8kzi4o5w853t3dib6f7m6t9zw8c
X-HE-Tag: 1784042131-462151
X-HE-Meta: U2FsdGVkX1+TZHCfJ3vWno+E39nAlSPddXwloezOvG7AEum2jfXpCCS7NDACzlItet7VDo14pPagq8rnTd0Qz6RfH4t0fUWpBQ0LiwRevK2geBBYrmOjnWWR9PhTpA5lCWeMiN7FtNUqo4FK1jlJiv8mISEDWsdLx1AmfTGPMRvwFkxjHhb5fQjV5u0Amm5s8U7pLDNUYdOqBvOyIbmbKnd00yR3Jwu7d8R4r0/26Y6SFgUZNp0YN0smemHOfzFHSL3erzGPAnBPwnNWCafvA3W7p84aDmIChUCnbqppKKKftbN72KWN3YxYmHLyaMMURUzrlnBFg7TtQyot3O3xMkZgqYsL6KfLy7knU9TI35p1qlvCwAphDa2Tqi0RJ9pT4BbXaKXe+APxZH285hTS0moDzUKLKOVc/RL9ZLiBVQKC/hS8C6x+GgcRb55HnnFHbE3qBrVfZGcnBG6r81Og5qR9qxJGxn8a6BfYD/krGwDTX6eTSwsncYIEO33JHrr4sBo8XUskQjwPkmEifs0uOCygvkU/rrfyr1Un5s4Pe9cPAR+aHvrZRhelPie5UdbAxnHWfFXBXzyBiAtoCpjEGGFKgvHwBGdTk0txElzq1YySblHvNcrsNhwYCPFh+df3BKMJ3W4GMrvFG9Ph0EC9PlCqInoXAJc5TKkmLJDUQpuclh+7MMJdV1cSD3loPaes/jG3sMe3ToTBGN5sL2dt+kQx9DDsn6VTtkeVtFAv7myVtHlRP4J+4d+09tp8NAggx8pA9tqDWCJR4jueX8rO0OKsF5fXLrxh9EbMAp9wEhqjbZEONnLjiOs6HFbOw2JIHJBmscB4YqmOxWo3/LI1+Oq2t83W3nyVEBqBQcyklsx1+vpxxyQoVgMeKSgi2ZjbTxGdRQld0tFMVpbzkBkcsB4Gp7eFhYSKVb/RIFaxOybPPXD0E4NnmnTVEbqod/Bq6ulQBsrdO0A/eEwSJMM
 t5DTDkVa
 2tqRwVlqiWSinLPsy56ibrgr/9nYVcKHHLIgvIpczkLAIyJWhIGi4lSuDLNRZpmu8ufvUDCr2jbCD0lfnSCERfNQss7VICmRokbWuHYihe1TjUbeOg3L7HoXMsw+UFwcSvwXdEb8lN0rMuRSCKIVQ0Dip+zjh7ZyzL7e/6R5Zbz3hIK310dIlgyIUlHtV48/R5Wk3L03SA1J/iaz8jbmuCcGZyHZQTssOeZJobEib2e9jRmdp3CsJhbaSu/diqU35ffBb4E+qr1WxMKM0Xr9rwbSwOJ+tOAgnc7am8hXZxUADj6vIK34U4kSHxYcAg8XljcsC0i9BHA5hCGELft55lsRk4f/Ed/MYmJh5egh06WHfjDN2yKyaRlK1E0whNH2bDstJdjqpxLKic466Nol8RactkT5xepOFtHvWXo+P/x2py0u5WUW/nh675Bm46zG+VfN1qjmFb+acQy0cEbp4SWBur8ZnxJCg8gV4/KmJO024RfvQ6uXLYMfac2udgO82UdY0awJagbh56LrlxRVbOCiODI2FmN90yODJyay0ipBPTcoqnOgUQBkvRaUmbRBMkH2FpvqLh76ejyjbQ3wlMID3kaGM2tm4DAn9vCZo3fOF7/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Matlack <dmatlack@google.com>

Verify that opening a VFIO device through its cdev file and via
VFIO_GROUP_GET_DEVICE_FD both fail with -EBUSY if the device was
preserved across a Live Update. When a device file is preserved across a
Live Update, the file must be retrieved from /dev/liveupdate, not from
VFIO directly.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
index 15b3e3af91d1..ec3fe8f19502 100644
--- a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
@@ -36,6 +36,42 @@ static void before_kexec(int luo_fd)
 	daemonize_and_wait();
 }
 
+static void check_open_vfio_device_fails(void)
+{
+	const char *cdev_path = vfio_pci_get_cdev_path(device_bdf);
+	struct vfio_pci_device *device;
+	struct iommu *iommu;
+	int ret, i;
+
+	printf("Checking open(%s) fails\n", cdev_path);
+	ret = open(cdev_path, O_RDWR);
+	VFIO_ASSERT_EQ(ret, -1);
+	VFIO_ASSERT_EQ(errno, EBUSY);
+	free((void *)cdev_path);
+
+	for (i = 0; i < nr_iommu_modes; i++) {
+		if (!iommu_modes[i].container_path)
+			continue;
+
+		iommu = iommu_init(iommu_modes[i].name);
+
+		device = vfio_pci_device_alloc(device_bdf, iommu);
+		vfio_pci_group_setup(device, device_bdf);
+		vfio_container_set_iommu(device);
+
+		printf("Checking ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, \"%s\") fails (%s)\n",
+		       device_bdf, iommu_modes[i].name);
+
+		ret = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, device->bdf);
+		VFIO_ASSERT_EQ(ret, -1);
+		VFIO_ASSERT_EQ(errno, EBUSY);
+
+		close(device->group_fd);
+		free(device);
+		iommu_cleanup(iommu);
+	}
+}
+
 static void after_kexec(int luo_fd, int state_session_fd)
 {
 	struct vfio_pci_device *device;
@@ -44,6 +80,8 @@ static void after_kexec(int luo_fd, int state_session_fd)
 	int device_fd;
 	int stage;
 
+	check_open_vfio_device_fails();
+
 	restore_and_read_stage(state_session_fd, STATE_TOKEN, &stage);
 	VFIO_ASSERT_EQ(stage, 2);
 
-- 
2.55.0.795.g602f6c329a-goog


