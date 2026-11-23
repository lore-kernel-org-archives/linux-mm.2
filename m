Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00042606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JnKN14oA
Received: by kanga.kvack.org (Postfix)
	id 26D7C6B05D5; Mon, 23 Nov 2026 14:01:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B856B05D6; Mon, 23 Nov 2026 14:01:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E396B05D7; Mon, 23 Nov 2026 14:01:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC40D6B05D5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:01:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44507C09FA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:01:05 +0000 (UTC)
X-FDA: 85467301290.18.D42F6E6
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf15.hostedemail.com (Postfix) with ESMTP id 831DDA000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:01:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JnKN14oA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3bo0EawgKCPkenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3bo0EawgKCPkenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795460463;
	b=L3EHMVmNikba4xh77HFRyXjVZoA3hq7c2oGyJGG9seFfiu7CrlpPn6M9SCqIKeCVdM2zQu
	3vVSD0jkj3jyOyzG96G2lWDKD4jeANxSsVARPwb6P1xcndaTmW28k0vAMNVDnyDmS1FOEB
	9pT9HzcjE0XiWiU3uZaNeKyIL9st4kw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BPu+oA30t3CvvayfJGBtOo4KEcsTgY7xbV9OZz0KkY=;
	b=nRQ3v9S6z6voYmZh/bY66sxko0G4WWqmAc+9LbAjZgYLrCcQqiN4Aoko/kwNhxxHDLXS+E
	CRCwJlrxbKPhC5M7dxaIuruN1tVvALzW9biSG3tUqJnPammCtMNJFt4fQGQ4ue5SsYMDGB
	8/mpj+vi2tyXEqmWyfQWX5/vj8ajw4s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JnKN14oA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3bo0EawgKCPkenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3bo0EawgKCPkenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-5384e381fbbso3291720b6e.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795460462; x=1796065262; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2BPu+oA30t3CvvayfJGBtOo4KEcsTgY7xbV9OZz0KkY=;
        b=JnKN14oAkOnX1vfPON2YiZqB2kH1CDYvKcTiYMJobKZsPiWrAdHQQlWqoxOBiMpulj
         c8VWdFwjBH71b6oGnNCLTLAjiM1F3i3rxPwh38XXDWpTiPR/ahJ7yx/jtsqRQWXWHvxg
         nUJ8ACrhzecASdMFREdbk9hXX1l7FU5VFnpiMYnkmD8BzIulXLJnN+wgeFlP9vieUGft
         r7rs7kye4hPIOZXot9TajhBRx96VWfGQYg83Cs1nR7Zunsth/I7hadt/QefBSZ6wZ5pE
         mLevRLR7W+eWTAm7b4kb48Dxy4hFvtqRqvq0bYDWK3P9VxB7Eq3npqudmEGghWUUGJBv
         +EBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795460462; x=1796065262;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2BPu+oA30t3CvvayfJGBtOo4KEcsTgY7xbV9OZz0KkY=;
        b=myDPH5LJtU8W0RFcojOosTx/CaIDL4mzege2qLEyC4DXUk4RGHpzisI4dsDNENaQ03
         8RzJM58YBSpAhh3fPwk3rh6PhKfQ4GzjRV+wFlmeoPrHckmFhpelcjk/RZAopwwuKxee
         9wBO/oF+znyUstTW3OyH5RBQsaDrL14HlzvGCVUgklHvPJsisP1+2kOOrd4cjUFX1AAB
         XnTgtRN71F/enNS+YBat93YEBS60KIAwPftqynBxL60l3IoK6fiHccs2/38FmMYGXvWA
         4sAvpJkie1pnWZwEnu/S1qmU8MKoTFJuVGDlW3qfOqWApEHCcf8bLPw5s+9VYTU//nHS
         Aing==
X-Forwarded-Encrypted: i=1; AL+hErHUVkrxjVY40I1qhGujczY9+KnKWylS6V4DOxaABx/i/ySTxZhazx2yKsFm8KGPZXYxAAkfFn4L0g==@kvack.org
X-Gm-Message-State: APuU4Z/mWXn4rY4xJf8RABSV9N/QSx+2CImvex6mKTVs0ArXROjXkCEs
	6Cr/VzZFw96GGw8pHv/rANu/zbeZAE+Phg6li76xMIH1vDa7NgpCZx7i6yRItgJS3duJTFg9ZGS
	XpEaG/s+voDcYfg==
X-Received: from iobhj14.prod.google.com ([2002:a05:6602:1d8e:b0:9c7:4d20:1320])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3514:b0:571:a186:d6b9 with SMTP id 5614622812f47-57a0a30a106mr14736384b6e.13.1795460462155;
 Mon, 23 Nov 2026 11:01:02 -0800 (PST)
Date: Mon, 23 Nov 2026 19:00:45 +0000
In-Reply-To: <20261118223704.3286085-12-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261118223704.3286085-12-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123190045.2166865-4-dmatlack@google.com>
Subject: [PATCH] amend! PCI: liveupdate: Freeze preservation status during shutdown
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
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: bifq8dpna444qjni83xcod7fqzed3e1t
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 831DDA000B
X-Rspam-User:
X-HE-Tag: 1795460463-415524
X-HE-Meta: U2FsdGVkX182VfBiET9GVpOQJdAndgfB0t+YmL8miXGr1cvgCLosf6vfNjvoW+hlvaQ+b24qoy27Hv/d8pggOzv7PqJTIW/aKe/2oyqPj5KRFIJDVID04+TkzBOY5+yEHGmav0Jyjl9IpD+jhujye1O7tgo4w4HxusEsUNr6XPVOcP/n+M6+DibrslYxc+VA+pkkgnwZdTEsRzkQnoMtM3b4O7gz0+eWeQUIZYiBhN/0vUsqGmzf7UaDsTVgIsYU433YdxDKeK6JiN99rHSpW9P8mwTFX/SG5Ett23qc9aN0dxN/JpyZWJv9zJO5ImQFbSFYkK/8RNgP2KrZr6a3qgRAx0LvwjyfhQewxlw3Kq0ZFSwnU+8mImSsMHWh/IfvYozDGoQ5cxbsoR5Ov2mV/n416cCJOJzk07m49gCp8fkMjNE2PlmVIMNRbOF6vIIdreXhbjouj1Va6A5YMTGcV7hnXGlV7QBkz0/nM9zfWYGQ8uL5j96MouboX+CBz4WQM41Ep0JCrgNKEsLkXTRpoQEOwsm5pb/dS8U2TKV3OgD7Mwdu7QNekdfu3qL6DQOn4KXUEgSWiipZJ8u9HSDZFWI6ciJUUenFWsx7fAMQOe3ywMxD11LBllYwThb4zlS89x0p7I71pR0T0JxgRyewQBuq1DW1OLIK181DK4q7oxj7dEbvsP1uNdxoPY0t/pT3yg4Uw9J7nAimQhvy/jZCjD/ePYXtso7lqg3zWrQeB+KXKjWAQgvHrY9NrrWjY92GP9Ckod8rHiiX5rXqOk8LaA+bZVjCPicrey2rwhiSZMho3ccYWhh9OEDOUivjgrV/ksWef1eSOkWBicJdUP0BdX1CB/9oHIqY8qSSJd8v+0y2gw9YRaYGoDihO+RdHS4liGjXZ3Qp09spLebKU2p+hdRIpHkNWF9Xwvqf1GWS083zn86wt4ky5S6j/X7EU2kc+2Rud/xD17rXTlC4gNt
 E+kLuIvE
 WEtm/VH/yO0ybz8rAgX3x7ygzyowJtEwAKBxo5ByXMgvOni6YGW9FE+LcCunQrnviwXMzZvYatFpS8zXZ/ZHULikaKkScOOXh48DBrD0Tr3kaDSBxTZ3UdR5zv8Lm8iT81DrTtI2NVYIhVHRrn4zVzUp1GrnQ4wqEHSeCAlZgQ95RGpwfnQNUGYxTFQI3rpoexHDufqIoxa1clevAvJ0NJlbACBEl8PNr0eTTRcer071OON0eBq+t3ZHHMdpAZqcmYr6Si1H8WGAmUHdcrrxOc8d1kaU1co03IKIlT3G653B16Pz40d6z/dKFe6z6MD7c8+3zJlFQuqea6uprUiJXyjCe6P0i1HaGAw9cqXMTJC6WAezRtKjGX7rBpFkc1wRoT4Sg70Ukejx4inAfF/4V917KYJdOHdPmVXepyPzb/3q7Gu2qgQPKldjHEv5Z2fY9cLYDA+56qfvX42G7Q4j8rNeB3HlGF0m+fp02SUHqVOcrBHUZZ4EhIzAal5iinhwBwgJ0wdYVYao0p9JC80zOU0APSW8PfkNMd7iq1cNPNxqr8u6hfcBEQ1Qa5MrQ31JLLsktYIx3TUEWo3OoOY/4yniuvZ18Y++tJ4ObcSQVSkp81ablkez7vm3uc0OsrYrM1CL0sAYCvnNibd+H3wHqut9dVz/fxMF7fOANLhBlZpqH6CizDUKqSb+yPHLe37ZV892gMYxti06cQ/Tw5b2HELUp8dQXtcM9eufa3Pa+tbYSaGCeZpNUigzr1bTqOFQ6EVlp6hTSVSlXx/xtVIw7k48jouTglIMBNzHBGEL10/ipNceX81UTSSrfVR5NXHsa9MGQM6KL71x00W8ZX5cuEWB/xkoq7WcVLGX7ZOm1JRQLwxU2rDyFxfcZz9Gc+PurmGLqkm2zksu145mPkJXmedWHHMg+00x8TR0NSgpz4Bp+efAGhx85KD45ygpGPyuoCmipUCjcb2DrEV0V7E3+/2uqkOux
 M/U6fLKY
 AoQaZCYlWeDVmlEfHQGR8dgIeMCh7x+921Cz1BOuLHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PCI: liveupdate: Freeze preservation status during shutdown

Freeze a device's outgoing preservation status (preserved or not
preserved) during shutdown for kexec. This enables the PCI core and
drivers to safely make decisions based on the device's preservation
status during shutdown.

The PCI core freezes every device in pci_device_shutdown(), not just
preserved ones, so that no device can be preserved or unpreserved after
its shutdown starts.

Only freeze devices during kexec. Other shutdowns do not depend on the
preservation status, and they do not serialize Live Update sessions
first, so a session can still be torn down after its devices are shut
down. Refusing to unpreserve those devices would make pci_flb_unpreserve()
panic because they were never released.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20261118223704.3286085-12-dmatlack@google.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---

Notes:
    This amend! also replaces the commit message when squashed with
    git rebase --autosquash, to explain why devices are only frozen during
    kexec. The message already includes your Link: and Signed-off-by:
    trailers from lu-pci-preservation.

 drivers/pci/liveupdate.c | 2 +-
 drivers/pci/pci-driver.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 08451452fa54..76e939ea52eb 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -127,7 +127,7 @@
  *    Control Services (ACS).
  *
  * In addition, a device cannot be preserved or unpreserved once the PCI core
- * has started shutting it down (pci_device_shutdown()).
+ * has started shutting it down for kexec (pci_device_shutdown()).
  *
  * Driver Binding
  * ==============
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 08b768b9e905..2748ca22e9cf 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -560,7 +560,8 @@ static void pci_device_shutdown(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = pci_dev->driver;
 
-	pci_liveupdate_freeze(pci_dev);
+	if (kexec_in_progress)
+		pci_liveupdate_freeze(pci_dev);
 	pm_runtime_resume(dev);
 
 	if (drv && drv->shutdown)

base-commit: fd54e32f7903199e8acb2762dd2debfffe4501c4
prerequisite-patch-id: ac616bdf67b652da754c7b00a368613d345ae384
prerequisite-patch-id: 9c324eb4a47b659efcf7c0c8bb14acfcbf5d615c
prerequisite-patch-id: a1ec7135c2c0c8f90b12743df9e4620ab2ee2f2a
-- 
2.56.1.809.ga0b61035b5-goog


