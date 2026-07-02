Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C26A1C43327
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2543F6B0139; Thu,  2 Jul 2026 21:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4116B0144; Thu,  2 Jul 2026 21:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB876B013F; Thu,  2 Jul 2026 21:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C11936B013B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:00:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 933AC1C6E8B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:54:45 +0000 (UTC)
X-FDA: 84944586930.12.4E3E9B2
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7459AA0007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:54:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=aKxabhML;
	spf=pass (imf15.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014883;
	b=mxsNvzkMisuSp7/6dd1Y9DSVG5uMtyz8MUdSFbHPK7HICj+GSD3ZnlyiVSWqWvmIP33yd8
	7CA+mb90GnHxzJvcWNb8pAAfH7JD+IeR/Kkjg1PE223NBEvv5QNUJL8Fblg8p9rW7FjiIR
	mLwsih1BIf2JQLKRFNALU4Gch2uQ/08=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8x4rQZI3wGrMps1gx7J+LUAbzJ5YVpPGmgWVMyrcn0=;
	b=TeNYLkm4311ku+A1HsGkQ4G4cpeNYlsp6/LoNaRBP04xGvt1MwF0oI/iVKXtDSNscLHcPx
	ebpzQdmUXXMSxfSM7OEc9mMdxE/uzvZD3qNVUXk8ElFcFdV4G0obmtBUGxQ+YDPH+qquwz
	ocvUVdXxQCO7MXEl3fwpyc3maulQhdg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=aKxabhML;
	spf=pass (imf15.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783014883; x=1814550883;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i8x4rQZI3wGrMps1gx7J+LUAbzJ5YVpPGmgWVMyrcn0=;
  b=aKxabhMLDD08J9yJ2+3GrKIRKMZeebEa1UkxmAwQS11ulZUFxkxDmgP2
   FPsrS8aAFc4ZmJKfdCMFTRcFOepXqbli9sWXSj1E4HXwXS/MK4UZX8HMF
   EjLpNLl2h0oRaPAaV/5A3lU454iVC5ILo7wtjEIHXhjOMCkBfKGa3Gtla
   2XC/zHEOvy8cTny65c3obFxxyrjh/aOjY7CrK4iWzeSf4XfY4JJnI92C9
   +Oj5kCOOlt0QklJepaBI9zclfX46PJHY2KNeQ1Bp53Uj+NpudE5D/6l3Q
   RXgapli55kVKVKXzPLq/ltxzrv3V2NWVin9ObElaJKnXxt5OhALDMLz8n
   Q==;
X-CSE-ConnectionGUID: sfChYbsLR7+K9S+0iXxigw==
X-CSE-MsgGUID: eL0Sbib7Rj2GDrU/NWV6oA==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22744903"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:54:40 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:15888]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.93:2525] with esmtp (Farcaster)
 id 1c94e942-37ba-4e7a-870c-87f2133b068d; Thu, 2 Jul 2026 17:54:39 +0000 (UTC)
X-Farcaster-Flow-ID: 1c94e942-37ba-4e7a-870c-87f2133b068d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 17:54:39 +0000
Received: from dev-dsk-sakacpav-1a-480d1124.eu-west-1.amazon.com
 (172.19.96.155) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 17:54:36 +0000
From: Pavol Sakac <sakacpav@amazon.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Tejun Heo
	<tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <driver-core@lists.linux.dev>, "David
 Woodhouse" <dwmw@amazon.co.uk>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, "David
 Matlack" <dmatlack@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Alexander Graf <graf@amazon.com>, <linux-mm@kvack.org>,
	<kexec@lists.infradead.org>, <nh-open-source@amazon.com>
Subject: [RFC PATCH 11/14] vfio: opt vfio-dev and VFIO group devices into sysfs_lazy
Date: Thu, 2 Jul 2026 19:51:11 +0200
Message-ID: <20260702175114.24659-7-sakacpav@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702175114.24659-1-sakacpav@amazon.de>
References: <20260702174033.32116-1-sakacpav@amazon.de>
 <20260702175114.24659-1-sakacpav@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [172.19.96.155]
X-ClientProxiedBy: EX19D042UWB003.ant.amazon.com (10.13.139.135) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7459AA0007
X-Rspam-User: 
X-Stat-Signature: 764j9pzgj1ks899diuw9qt34j8tir4es
X-HE-Tag: 1783014883-671720
X-HE-Meta: U2FsdGVkX1/wPhoWs/AOVLeA3gnKAVvT3SKxvBsN9etZt2KAzFXQswm0dw2zl16YnJ5fmRYtphKwkPhDmdfgEGBq+fePR09WisV0555Tjo84pI6VdW8fCKMOOaoF8y6nVTN6nqU1/y5wGo9zq0TYpNGOZR5mQf35tAdPujcd3RRxB1dqc7GCyu5WnSwE/rr9uRvF/ltpOPCp3f6rzW9t5AOHLekXAJs/5LH32dXb8wjpAaCyF3BZZcX7/nYfIEIQglEROu/aIXvxoIennCZoXDSkVZuek4KD1FGpdexhRPKrnbn6WWFMx9VXhx2F6CsZfMOajCKFUhP9uAixhQAss7aIbfMOanzs4ZAWqq/wwWcuTeOohE8FwN1ZpUELWcGirTDHoRPiMfSv/73kw1sR6LJAUXPRl6mzXefI0KH1Q4YDk+PQuf1oJH7s+XuFiTUur33pUV0Ga56+hOgMYpBP4dMWkwnZYR2TgWcUXITyh/7SoQjLaKMWKTooepHJz97g+RsIVPF/TfUrtR9jygM+evzalnzzrxpZMBX8fEZC7kWjCYfKPYdEusOel+85jcYGbgAqJ8RewLVt0cGQGtUIGTOqGmguodjYpits+vK0l8gXbqJ5vEYY/M0eTfEfm28NI1GLFLPR+KKKzwilvUC6p1hpiBRERryh9GkYy68c5iYIzRlDvpHbL2CRZ0/ayWdNaYIta2zQbGE/DNoUjIMRYwgmllunsrUt+wyoaP21UwfP+HW3W/inLY9BsrAQ4lBTLoI5tHxfAOZEUMZ96Izdt/Mz1ozOkv4rnDvcc19nu0z6Br/SKHJza6wMmEdvDoLtNyPoEroNVTgU4JvNCsLyt9+r1GPd5hbvBpll/ds3EI1Br0prIfP9a6IJlXnNjTZenjym9E881H+aVpU49Ac8HVh18gP9vrIZF3zaIqnrNJV81PZQuYgVTS3sWkxdzqu1zwAXoqr9HIIVdFmus85
 h4/8Vff+
 o71DzKKNV9DOKa/tlMzFsTjhe70M10y9c8l6xlvs6iXz0RhZPLQn8cupw3+CUrzZTi6NuSAKS9Q8md7UfUtEXJQdwSayW4lzNQ4Uvn3GIizagS/YaP99yWJaw2HFA2oQSTMqbATrUk900lZN3DmKNSH/KoDBlQ74dz3IsP90lCFnljlEUB1IO62TyS0PgKHIYOCu+4IT/0zLCffelhpabBw5qXaGUyc3dkqUVfPEsYJDaoUGrQRtOpg3SzJYsSzJpFo3QoVdixJApEC7XMPCMFN+nGq+GhNFcYDUPTBXeO0AUe/jUNc5ZwCJfFc4ln0jA7knzp6ltMcRV53mui2ByZ1ymAK2CsxxmK9RtWoX9h7PgNGH5MtYd7qLTaifsEONksuALhEz5TiRLZlbktK4k5A+z67UmGaWq4N/SKKXWZJw17lF1DU0NXV4RsQ6OJWv2fpHe8FNT3rMSVYArfFXeMBbw41F8sZS/Q61iZ5IAdlHJg67wQ5pyPxlQx4WKyIROGQZnIDfq3pwHIkOC+jQtGNEbYSHARZZGvLPTQcIztbrvdHIfFwuVIpeZBCjMAiIL1oyEEwnR2zCBfesDGN9oMRVH+SzaqgQUTmiSEmscstdZXYC1rltOZsDqnqTw0wNvo/p3PPuck8lAoC+BovcW6C6ai/d6inybUzLYNa4F2ylaadCfW2+YWrbp6/P0nFZ06G3aNHaY5YcibBJE9bZdXmpMvsgCn3GF6KnMuqOLUCGq7NHk8Osv36gjpkiuh6/WBfYGsPMIGqXwszc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Call device_set_sysfs_lazy() on vfio_device->device (vfio-dev/) and
on the VFIO group's struct device (vfio/<group>/) before device_add().
With opt-in, vfio-dev directories materialise their attribute_groups
(vfio_dev_groups + drvdata->ops->dev_groups) on first access via the
sysfs lookup path instead of eagerly at device_add(). The VFIO
group device's flat attrs follow the same deferral.

Removes the eager creation cost on platforms with thousands of VFs
assigned to VFIO containers. No userspace ABI change.

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: driver-core@lists.linux.dev
Cc: linux-api@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Pavol Sakac <sakacpav@amazon.de>
---
 drivers/vfio/group.c     | 5 +++++
 drivers/vfio/vfio_main.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index b2299e5bc6df3..aa7e0033b96e8 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -533,6 +533,11 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 	group->dev.devt = MKDEV(MAJOR(vfio.group_devt), minor);
 	group->dev.class = &vfio_class;
 	group->dev.release = vfio_group_release;
+	/* Defer per-device attrs to first kernfs access; userspace reads via ioctl. */
+	if (device_set_sysfs_lazy(&group->dev)) {
+		put_device(&group->dev);
+		return ERR_PTR(-ENOMEM);
+	}
 	cdev_init(&group->cdev, &vfio_group_fops);
 	group->cdev.owner = THIS_MODULE;
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6222376ab6ab5..ab90279c44bd0 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -306,6 +306,11 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
 			goto out_uninit;
 	}
 
+	/* Allocated before device_initialize() so out_uninit unwind frees it. */
+	ret = device_set_sysfs_lazy(&device->device);
+	if (ret)
+		goto out_uninit;
+
 	device_initialize(&device->device);
 	device->device.release = vfio_device_release;
 	device->device.class = &vfio_device_class;
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


