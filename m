Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FA860A263F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=i1pYte31
Received: by kanga.kvack.org (Postfix)
	id A72146B00EF; Fri, 20 Nov 2026 14:11:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A23566B05B0; Fri, 20 Nov 2026 14:11:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911AF6B05B1; Fri, 20 Nov 2026 14:11:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 687C86B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:11:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C91CCC0176
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:11:09 +0000 (UTC)
X-FDA: 85456440258.27.466763A
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE59B2000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:11:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=i1pYte31;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795201868;
	b=CR66OgRZxy6i/bMkW1Uj/07ETb+crQvJGFiUagf+tZAyJbmEvkt/lCoEQ6hgDHAVEUsfFD
	S91TrUWSH+HlyikbgW4RV7bR9jHEQhY3qqh16qQqRCg9FteocOEdWgVgfIISuuBxGmZC8x
	S4D8hkbl45sctmUzI6R4BiTQ1/lBy5c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795201868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ckLOMz2fV3kY9YEywvc/HmidWwaCPHWXqmOxBtkfgk0=;
	b=J9oy+wrbi7RtujpGgiJYSqqj6xQ+hCxpR/woRAQN6iXKqEw1ehAUrFtp8SBjHVX/Nl/EpT
	uFyMBM/2fbcb7SbBvHCaLyW4ih8IWNC7E72XPs0omKM8FgutaMhBaIpt4mAkTpWAnKde33
	MqzMFFvpETRXRavn6u071mTeVRPTki0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=i1pYte31;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2f0458cc9easo8323925ad.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795201866; x=1795806666; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ckLOMz2fV3kY9YEywvc/HmidWwaCPHWXqmOxBtkfgk0=;
        b=i1pYte31UXHa0hbcT2J8EliVrmgq3xrPD/XxYeddNQJ4sX684c9Duce19k4WwLfBxr
         up5naXCGBnxSAa6wO6ZR2K6rUEc9XUNFYZ7Nik3T9R9HxC6dkHOc9SkoiNcZAFq3l7zt
         eCiWSok4h/jmjyjU+KcHC0jJYyqgnmERyD6VSaJuItyoiCNVOXi0vfil2la/9yTrcCof
         DO6P2lq+D9/HNHlyDZrSMBNY+YpAe7OGuIiAaOIAsPjHeJEUPVxUptIeu179MRTJPGYv
         GV7ianSxQbW5m6nKoKWiqWOIsCfKkrFBrLLUHbo2ZMdZE55i1Gr4SuhHo5jtDO7QHNG/
         z/MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795201866; x=1795806666;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ckLOMz2fV3kY9YEywvc/HmidWwaCPHWXqmOxBtkfgk0=;
        b=fEIrZDeCpamX75SO/qlcJMfPyc5VeAFyrEA+RPWAFuyH1kYO3oFNDqFBt/AByyYpMq
         F0Y0jhEIdtMuQTSFpY4wP1xM9fnaV5ACNsXsWyjc0GdPcwodG/NYNCPL1xYhJ8tNw2A+
         Piy4YHHHE0NvWMHLu1O6RONYm+jODrExf/P3+ygIE3R9/3BDv+4AiIsgBNjrWYHxodgE
         BJ3Z38Xb1kbJPjFiB5TPH9uDmYj6sJ0Cq00keDzdEy/j5yTNxboT2ao0sEzHsmrUBgwH
         WN0VYagtfdUPaURBiY8yMRJdfxOW3miO3XfDMQJPrN1Rno/DViC4kcbdmYh2xYjFeiU/
         6E/Q==
X-Forwarded-Encrypted: i=1; AL+hErEvY574XDLgZ+O7ZraM/yCdaZiHcGi5Ux4/WoyZqVAqOIaRPh1Ete1WGaWi+0DR0kKu1GG3uSIFQQ==@kvack.org
X-Gm-Message-State: APuU4Z+xZDlwMR4gIKLbk1pmxfPm7ZYAbVn7diDIBrVm2U0aIMcK9/ub
	iyUM6E4YGOM7up1z0EAXlSGrvpgtEzcjX3LPOG5c92RRs957i3buAXRHBlkk+qPn4A==
X-Gm-Gg: AZFdTZfLMTDg3LtSQ9MLECnmSvLN42Ykaty1BrN3/bqA0PZAxd5pAi10n8yeSI0Fc8w
	wDqCrgXOJWtYneYWSAP0GhigIyDj819oyu1pcOYoP81ycyd1tR3Fnn26rSLjvAf7MG8Cv92JQce
	CsERDoN49QFbqh/uS4kJBaEYhMlJgENf3nliRBbm034FPhENcPqhvAbofuhaPxNtaWcG1jLsCT2
	wFYWn5jFo9AlRbuvFBrByQcl25DmH6zhCgqWm1Jeskq341yzhyXIuZMpnx6JQqZK0yFfP3HqYbo
	Y1k4txxk6t9B3WQnXQEVEhdrqH4OVZoco5SFlxv9QSaZiwkzCwfNVq7RddXfnByDrIVM6p+dwnT
	WVPU91S55Nrn/fmiQyjeBKYHlXzkG7Oof27Qpw6dqhqMdYsjuhQeGLMtbWfNp9UcTlx5qgTWl2K
	bNFG2cC3VwiZ165VFf3eFQki2GuItahv9rjKt5+8BICBfUps1Xu6wbyu/B9uri31D82VpU/YXDI
	CsBJtWuHFyo5MIj0DbC5TPJTEiK/xZaHIudniNfkpf7BHcbQ2wD/pkW1qhhKwWOn8SgbgAOuhAl
	JMGKyD+A9+uXJ/3gpGCCEX2TiUy1OzgJ8YFIrkEVey8R/0n0OiFOcFatBtgr5uSu
X-Received: by 2002:a17:903:3b8d:b0:2e9:5714:6079 with SMTP id d9443c01a7336-2f03f1a4a0dmr40668915ad.31.1795201865671;
        Fri, 20 Nov 2026 11:11:05 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f1413f3sm17535745ad.68.2026.11.20.11.11.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 11:11:04 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 20 Nov 2026 11:11:04 -0800
Message-Id: <DN09Y7673R13.3GB4PTE9ZPXAE@google.com>
Cc: "Adithya Jayachandran" <ajayachandra@nvidia.com>, "Alexander Graf"
 <graf@amazon.com>, "Alex Williamson" <alex@shazbot.org>, "Alex Williamson"
 <alex.williamson@nvidia.com>, "Bjorn Helgaas" <bhelgaas@google.com>, "Chris
 Down" <chris@chrisdown.name>, "Chris Li" <chrisl@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Jacob Pan"
 <jacob.pan@linux.microsoft.com>, "Jason Gunthorpe" <jgg@nvidia.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Josh Hilke" <jrhilke@google.com>,
 "Leon Romanovsky" <leonro@nvidia.com>, "Lukas Wunner" <lukas@wunner.de>,
 "Mike Rapoport" <rppt@kernel.org>, "Parav Pandit" <parav@nvidia.com>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pranjal Shrivastava"
 <praan@google.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy Dunlap"
 <rdunlap@infradead.org>, "Saeed Mahameed" <saeedm@nvidia.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Vipin Sharma" <vipinsh@google.com>, "William Tu" <witu@nvidia.com>, "Yi
 Liu" <yi.l.liu@intel.com>
Subject: Re: [PATCH v11 11/13] PCI: liveupdate: Freeze preservation status
 during shutdown
From: "David Matlack" <dmatlack@google.com>
To: <sashiko-reviews@lists.linux.dev>, "David Matlack"
 <dmatlack@google.com>, <kexec@lists.infradead.org>, <linux-mm@kvack.org>,
 <linux-pci@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20261118223704.3286085-1-dmatlack@google.com>
 <20261118223704.3286085-12-dmatlack@google.com>
 <sashiko-outbox-224146@kernel.org>
In-Reply-To: <sashiko-outbox-224146@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DE59B2000B
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: rzdzsm76pienuff7gby6oetgzyx1ztdn
X-HE-Tag: 1795201867-263373
X-HE-Meta: U2FsdGVkX1+CFOpK538N6555HyvjOITih1WNEJum1UAKbIec9B9KaB7xKNwXe8cK5nCjMY5nOCOPwOknnG+lQ58ebYHz5hKO1BjTvOtPS1rsWzg5Qen/4z3RNo6jIAuRAAZ3ycGw2GMBqnsa3J0cYfzu70SVD7ax9EMlZcf4tNgxtrNbN+rt4F+bCfWdhH/KI/5GYZbwTY9XWw41zvz+udLGleUaHfJuP0iQqnIqTpTlKY+Q+pJ3ijkldatrtYW3gWJ0QUcmubPkfmHlNb6NNtGZ9nW/ZonLFpsdXeACB9NtP/zAc0M5X07qBTGLHfR6t8lqwaBJWZAgFLr1Qt5oxiuOdlgtKiGpZ93q/BNRoh9/OLH3o6XD0XiQ7ggWfvei5Zll4S2D+DrNc6ZrPeWZo1a8wW32adIX51xg/rK8df/y7JPvUDKAubB4G1YOCgYKF+0M+ZlGv2/ASD26Vpnw0MB76wpih/e8rJ9GKcuGCnFXNN/XNluDOGMh1W8JDeL9qTxxpwC8LkqX4aTW/lld9gSjjYpre9a8fgQPh02Ga1KFRIwRh4gvaeCVg5TxQbmYPC3rURKYjVEo8EcpRuhs8B/SEGiYFDG2Nm5zEdmBptpT5N1p6qs218v/F9MA4Is3HouR3AtyXMIp9MBDa4FLcXCDCJPWYqyEl3Tv6iM6fXM6yt+w6YLN4qYZjS4r2VmGRJfy06gw+HRDbMJvpIrF7ihvioZaieURwY4hp4vC4zVuaoUfaXxiNqzuD0O5I6Qem384OGqoQlnzJ9Y880odg3YbsZciSVNIMNKtOwmTpbiZL0kRsff9iQJ6kiufH6Xm9e4DJjK/Gp0LQoCkX4WLAdcuA1NGoM0sYD8x46aGqUN6fe0asHFxA22I2IToZujglDHIzCTwLsf5I3EEr1ZlPiNqvkSNBeETu9Wzdkl7Rox9t4eN7iZpnfxHbZWVKGrl3rAubZKiqGuMuw8qtMH
 KW0KtyeH
 c3hI4DI/4TImUOeqFcYKqtz6x5VgmUBS5dQw0SQVjuB896RXobjPbqyl2A0DyITZz2TmKTYz5dJu6ME8215CSDJ8P/9cQ74fjAFtV8NtX6aUkBwv2IfuDEgMSgtKCriy0fDpkqcc/sMPRMNL/6qLlJ2DZm6QSp0PH0FcW6oMo25F2f2tR/dzhtC+4mczz7UrRupwD69jP8P4QJC75O3Pro/dZ8KGUJ5YLMm08AIIUlv+nA+Cw+i5m5pqdATJwjdByPGoJBCDhxNDyjgH8BiZx3qUUPk8hqgYUY4wzkUyTWSjVvT6GWjXY3AZLDPIVX5eFB3jmzUvZqxZ5Zhg5bQ6oCDOuwquNVAN8F11eJb3ku11Xg+hLmY/es5FgG07ibICWZnZhZCJPx4HTieri2PfRFDfyKu+vz/2g7uIHl+Dd7CUt7Yfx+60ptgL0qNsORwkvtbXrWjgubiUCqb54ZoP/+q712tUA0OZXx8IV+tfRoQHqUjEf1G7tt2QXQ6DeTWgA1F8o3TY0LevnikBAsj9mlTDzpyVWFtJCDdau/82Vw2VfuIhN5nAXtlLeDA3Wiu90hw/2YPc5KTAs23GfEYKdy/EA9Im5yQNZs238v4xdpdtK4qN69FbGni5ec+rdpU8BUPSGl7UmRZ6SbR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu Nov 19, 2026 at 2:38 PM PST, sashiko-bot wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] pci: liveupdate: panic on session teardown after
>   pci_liveupdate_freeze()
> --
>
> commit a3120ec70b92ea26f3e1d92d3bd0d1531b5a73b6
> Author: David Matlack <dmatlack@google.com>
>
> PCI: liveupdate: Freeze preservation status during shutdown
>
> This commit freezes a PCI device's outgoing live update preservation
> status in pci_device_shutdown() so that devices cannot be preserved or
> unpreserved once shutdown begins.
>
>> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
>> index a45ad86370d5d..e26d2f5c2338c 100644
>> --- a/drivers/pci/liveupdate.c
>> +++ b/drivers/pci/liveupdate.c
>
> [ ... ]
>
>> @@ -520,6 +523,11 @@ static int pci_liveupdate_unpreserve_device(struct =
pci_flb_outgoing *outgoing,
>>  {
>>  	struct pci_dev_ser *dev_ser =3D dev->liveupdate.outgoing;
>> =20
>> +	if (dev->liveupdate.frozen) {
>> +		pci_warn(dev, "Cannot unpreserve device after it is frozen!\n");
>> +		return -EINVAL;
>> +	}
>
> [Severity: High]
> Can rejecting pci_liveupdate_unpreserve_device() on a frozen device trigg=
er a
> panic in pci_check_all_devices_released() when a Live Update session is
> closed during a non-kexec shutdown?
>
> Unlike kernel_kexec(), which calls liveupdate_reboot() to serialize sessi=
ons
> before device_shutdown(), non-kexec shutdown paths (kernel_restart(),
> kernel_halt(), and kernel_power_off()) call device_shutdown() ->
> pci_device_shutdown() -> pci_liveupdate_freeze() without serializing Live
> Update sessions.
>
> If a task closes an open session FD with a preserved PCI device during or
> after pci_device_shutdown(), luo_file_unpreserve_files() invokes the file
> handler's .unpreserve() callback and then unconditionally drops the outgo=
ing
> FLB reference:
>
> kernel/liveupdate/luo_file.c:luo_file_unpreserve_files() {
>     ...
> 		luo_file->fh->ops->unpreserve(&args);
> 		luo_flb_file_unpreserve(luo_file->fh);
>     ...
> }
>
> Because dev->liveupdate.frozen is set, pci_liveupdate_unpreserve_device()
> returns -EINVAL without decrementing dev_ser->refcount or
> outgoing->ser->nr_devices.  When luo_flb_file_unpreserve() drops the fina=
l
> FLB reference, pci_flb_unpreserve() calls pci_check_all_devices_released(=
),
> which panics because outgoing->ser->nr_devices is still non-zero.

Yes, this can happen, although only in a narrow window.
kernel_restart(), kernel_halt(), and kernel_power_off() do not freeze
userspace or serialize Live Update sessions, so a task that still holds
a session FD when reboot(2) is called (e.g. reboot -f, which skips
killing userspace first) can close it after its devices have been
frozen. In v10 this only resulted in a warning, but the panic added to
pci_flb_unpreserve() in v11 turns it into a panic during reboot.

The freeze only matters during kexec. pci_device_shutdown() only checks
pci_liveupdate_is_outgoing() when kexec_in_progress is set, and
kernel_kexec() serializes all sessions via liveupdate_reboot() before
device_shutdown(), so nothing can be unpreserved after devices are
frozen.

I will fix this in v12 by only freezing devices during kexec, so that a
non-kexec shutdown no longer refuses to unpreserve devices:

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 08b768b9e905..2748ca22e9cf 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -560,7 +560,8 @@ static void pci_device_shutdown(struct device *dev)
 	struct pci_dev *pci_dev =3D to_pci_dev(dev);
 	struct pci_driver *drv =3D pci_dev->driver;
=20
-	pci_liveupdate_freeze(pci_dev);
+	if (kexec_in_progress)
+		pci_liveupdate_freeze(pci_dev);
 	pm_runtime_resume(dev);
=20
 	if (drv && drv->shutdown)

