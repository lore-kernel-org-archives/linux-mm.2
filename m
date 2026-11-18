Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F46360A3812
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ec9rn0Ak
Received: by kanga.kvack.org (Postfix)
	id D38686B0612; Wed, 18 Nov 2026 17:37:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1A66B0613; Wed, 18 Nov 2026 17:37:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89796B0614; Wed, 18 Nov 2026 17:37:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 771926B0612
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:37:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F108980668
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:18 +0000 (UTC)
X-FDA: 85449702156.21.65011E3
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3E0AA40009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ec9rn0Ak;
	spf=pass (imf11.hostedemail.com: domain of 3nCj-aggKCEUkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3nCj-aggKCEUkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041437;
	b=Tf6JnlKqtnc9D01icPnIhqc1QtY1HloWTRMESpG6HWp4ZeHgFC7/GHwcGAmTPIqEd9O/K6
	awOav1CNqo/v/fhhS6cPS30IPSzrDzipg1qodIGhZNKeu/so9/0m9d/7YDkt9yl04O/Pff
	exRtuW9bo1xMHHN2YrZkN/ptImKOL8s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ec9rn0Ak;
	spf=pass (imf11.hostedemail.com: domain of 3nCj-aggKCEUkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3nCj-aggKCEUkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7tUVoYWeDGeTao0p+AwzKydfdHA75iYT78ktPbXtuY=;
	b=FHWzuNEAqAjQzy0znno70/Vk54b4nuJIN7pmCIGaUlqZZ2NW3WUXpycE6Jsc/2uiLw98Oh
	D9w2bjBjIIS3DMomrpODh2NJGwprknwwwcCoBeYHrdmrPN2KQxqhyDNBzeJ2ixnw30HfF4
	dIc3Nx5Eki7Cq+4VNAwOmC6zopexSfE=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-574f8578e48so1636783b6e.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795041436; x=1795646236; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z7tUVoYWeDGeTao0p+AwzKydfdHA75iYT78ktPbXtuY=;
        b=ec9rn0Ak3JJJB3TqVfP9JSkplZaUPKgnDx9IAyTRSmYyI1DimLjFdPzdEuXLV3ZsOL
         1wRpLNe/VNL3dZT3gUtrvd+3B+PPgY+LZLS4GWAEOpTKSA54ohXEohLtYz3/wwOT9DVv
         XQrXer3YQpAD3hhjeLbpN90kGl3DrUBzw+Mf3b1uYwBqJCGI3jS5MkAkx4kR9mNCnpRc
         JCWnjsTRIPPRBw3n2n18s/ooLMKDaTBywSqyZVPDeGwu7YswQtkoL8dRDsaQZEtN6zVf
         tGCKXlpuiE0UDfkualc0NEqgglf485KDb/nbgk8Fn12xanp7+6tKKMCY0RnDII4wCJW4
         EM0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041436; x=1795646236;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z7tUVoYWeDGeTao0p+AwzKydfdHA75iYT78ktPbXtuY=;
        b=m+a/h69BGdJ8hhjBaFln2xdFsirOlYD52hui6ogjbmMs1atN/H/E/77UUdZw6Kt+9R
         JiPfXs8+FgtalwU9inXZZoFFuKoGE+VdbM1Vj3jaCS2Me9QXZbPXJWzVfiJdInxZj60X
         Ei2ywGkmn+jzM9HMWsU+M3pl82W+1m/UieGFOtC24fJejgyp15BXuW6J5OTG9tp8Bddg
         VN5lmVIgiMHihxD4cIkeFN64ry7HBHSFkmXvXOT8qSPhNGFzho2FwTfkzH2SJlHxBzQS
         m0GKzBhVLZQw/EAco7X++dbK/SSWYwe4qSbtrfJD/WR6W6VbKBKI3fPzgFkYJKDAGY/W
         j71Q==
X-Forwarded-Encrypted: i=1; AL+hErHyp9+x2Le/Mdqx/xT1F+gOAof/N7Ao4iTev+wl9xzOmTwHKx6hVUwpu7ggLPM2YQca+CHOXplcUA==@kvack.org
X-Gm-Message-State: APuU4Z/fFtsmfJYaAWJDfVWNS2pS0H3iPwJVMQmgnJeMzeU2xENL4QCY
	c2sbu+EDGR55DXtDgoDljwDZJMvap7SWAlCm6EJs1Wgi7gqQDYaPwfxohil7E1Pv0LEnTPO2FOB
	qUfIwPz/+98w4HA==
X-Received: from ilkj10.prod.google.com ([2002:a05:6e02:eea:b0:549:aa38:c185])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:221d:b0:4f9:bc36:fc5d with SMTP id 5614622812f47-5773dc44bc0mr5135544b6e.35.1795041436008;
 Wed, 18 Nov 2026 14:37:16 -0800 (PST)
Date: Wed, 18 Nov 2026 22:36:58 +0000
In-Reply-To: <20261118223704.3286085-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261118223704.3286085-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118223704.3286085-8-dmatlack@google.com>
Subject: [PATCH v11 07/13] PCI: Refactor matching logic for pci_dev_acs_ops
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>, 
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E0AA40009
X-Stat-Signature: 45agxohhewnry9a1c6gobwkd5gcrwb7u
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795041437-131438
X-HE-Meta: U2FsdGVkX19pebup/SpWv522TL7400wzA6NbEiHYKM3qWTHH7khNd5E70zymHm3aTZefMtzeAz7lGMtXGRDeovN8QR0WSeF9qtYkDorrwbNnrzbS6vO6u5XX9remFv/MD0LRM9e6i+R28JwH96LY25HITgd0CZhJdyKv30mlejFUaudUZs51APgpV6U00Ee09Y4BLcxTAHI7udWvUF/khsP5zNZoqtJvAv+P8ofIDf8DL+4h1NQ4Y4UfuSVv+7Pm1TMN86xEbTr5nt1h4VXE0lNYxeV7rQ+jkLwJp68KdqN3ID9NRih+yYsDZ74f5pMsEobT/WM6PMM6FQgKYcDbFWR3YGRnj1Bv2Cnha3Yi4lJPd2esbrgtDSPw8MMA7OSsrzBgYLrkDxhNmPi+ejzmih9nen/no+I1C98OkyAIFUZaKF4it0nlJ0bgzRBc90tXb9thp4Ct0ScdI7MEJTZQdYq1oPT0eQqxKqMCoRG7W8N0vsBBq51h8qENILJYQ7VspYmt16eeSf9iEFz0mdV9Op0Cm+920n9JfR3b3wGwRV9cXE2Hbz8bnOC8GXHINooCjz5lIll/NQtxo5uK+74KmgYO08UNwsRmQ62yM0yL/wJe1nPdOa+P9yFnhgnK1sNHW8Rac0Vy5GqppSwaJyEOA+b2ItUfMDU8Vs+ZjMsE52yNg/M03VFK+PSFpzkznYE/t03iT4r9HvGLcKHdxT+2n6zaoK+yWmu6VLGiAb2XmfceMVOwPDbXFFotioj0pmac/wwJf5ON3rHNwTjRYF7X6Di3QjA3s6xthE79mu81QQfFuRlN5Lx6URNJv5W6xuCQxqA0ADdgwzvW86aV+ZzN72tRtpmjSlKu789+YUvjq5ajspW4UGb+lGeqNLw8Co7B5aobNbrt90WEMlp0+mKPc4tJL9KvU364SqudfOO6tyKUuwcGv4ujV0GieeMtkPq9Wx6nbWGFxLOZPZOrmp6
 NUpRKPb3
 AG31oPnLOIs98qCX3l9BTavG7sYfOspez9zkPCxTdMn3AzFKBoo+QnA3aLn93rBZSJW4o9WZ4vsmeK/1gywfZLAeJFwEbIsZvq6AWE+F7YMb6WJWRSytPa74P0+6fB4xrJSfy5XDh6q5zXoIevfERfqApR+n3k0e0P2KVb5j8+PRq8ruaX1LElZYTwwI9a/OPTrbQRw5NILaHcbTCK3LCe9iFO5BHkoMmw7bFjg6AIxs5TnERtCo/ureBAo17HXI+bhSDX4GljDOeodZK5hF/s/kwR9uX693g79f/Dugtr68jN5rTvMqfFFWVaoXzxLOXxFnZkyemlF9Kmn/+PK0/hM/9HT77WSwxsOf8J4YbOWKNa/62oaShytacJ9jlZZ5hYp8Z8jWDlJfGN7OaGMXjRkez1XulTzySU6n9mAnMLG6tDLi5xFMIqAV1hxbkqPa4ZDf7/Hwz5kLijzGPPwrTVGFWwwz6fNmD2+ficPzJg8U/O6tE+l0rm3NdpA6qjRp5pUo1Js6e3Rpe/oqbexeQzB5lFPlyxZ3XK8bKmyBX2l1Tw/USnofniP8DjOcML9qPrtxWt7402/OXHgJ6vaW0c2kz7KtzNDhSsCu8wZhTFhrH8T8WZWXQPXbQjYsqzLfvGwmsSLmdrmIkoj/K6KRiiR2yKLB05xVIMC+ajadbaMMr04xKHgaIr/fYmbCY7jkj1dpr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Refactor the logic to match devices to pci_dev_acs_ops by factoring out
the device matching loop into its own routine, pci_dev_acs_ops_get().
Move the per-quirk device checks into a new .match callback so that
pci_dev_acs_ops_get() can return the single matching entry.

This eliminates duplicate code between pci_dev_specific_enable_acs() and
pci_dev_specific_disable_acs_redir(), and will also be used in a
subsequent commit to check if a device requires device-specific
enable_acs() during a Live Update.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/quirks.c | 51 ++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7f1f47ea2ee4..0978be9c17db 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5530,9 +5530,6 @@ static void pci_quirk_enable_intel_rp_mpc_acs(struct pci_dev *dev)
  */
 static int pci_quirk_enable_intel_pch_acs(struct pci_dev *dev)
 {
-	if (!pci_quirk_intel_pch_acs_match(dev))
-		return -ENOTTY;
-
 	if (pci_quirk_enable_intel_lpc_acs(dev)) {
 		pci_warn(dev, "Failed to enable Intel PCH ACS quirk\n");
 		return 0;
@@ -5552,9 +5549,6 @@ static int pci_quirk_enable_intel_spt_pch_acs(struct pci_dev *dev)
 	int pos;
 	u32 cap, ctrl;
 
-	if (!pci_quirk_intel_spt_pch_acs_match(dev))
-		return -ENOTTY;
-
 	pos = dev->acs_cap;
 	if (!pos)
 		return -ENOTTY;
@@ -5582,9 +5576,6 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
 	int pos;
 	u32 cap, ctrl;
 
-	if (!pci_quirk_intel_spt_pch_acs_match(dev))
-		return -ENOTTY;
-
 	pos = dev->acs_cap;
 	if (!pos)
 		return -ENOTTY;
@@ -5604,56 +5595,56 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
 static const struct pci_dev_acs_ops {
 	u16 vendor;
 	u16 device;
+	bool (*match)(struct pci_dev *dev);
 	int (*enable_acs)(struct pci_dev *dev);
 	int (*disable_acs_redir)(struct pci_dev *dev);
 } pci_dev_acs_ops[] = {
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
+	    .match = pci_quirk_intel_pch_acs_match,
 	    .enable_acs = pci_quirk_enable_intel_pch_acs,
 	},
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
+	    .match = pci_quirk_intel_spt_pch_acs_match,
 	    .enable_acs = pci_quirk_enable_intel_spt_pch_acs,
 	    .disable_acs_redir = pci_quirk_disable_intel_spt_pch_acs_redir,
 	},
 };
 
-int pci_dev_specific_enable_acs(struct pci_dev *dev)
+static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
 {
 	const struct pci_dev_acs_ops *p;
-	int i, ret;
+	int i;
 
 	for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
 		p = &pci_dev_acs_ops[i];
 		if ((p->vendor == dev->vendor ||
 		     p->vendor == (u16)PCI_ANY_ID) &&
 		    (p->device == dev->device ||
-		     p->device == (u16)PCI_ANY_ID) &&
-		    p->enable_acs) {
-			ret = p->enable_acs(dev);
-			if (ret >= 0)
-				return ret;
+		     p->device == (u16)PCI_ANY_ID)) {
+			if (!p->match || p->match(dev))
+				return p;
 		}
 	}
 
+	return NULL;
+}
+
+int pci_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
+
+	if (p && p->enable_acs)
+		return p->enable_acs(dev);
+
 	return -ENOTTY;
 }
 
 int pci_dev_specific_disable_acs_redir(struct pci_dev *dev)
 {
-	const struct pci_dev_acs_ops *p;
-	int i, ret;
+	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
 
-	for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
-		p = &pci_dev_acs_ops[i];
-		if ((p->vendor == dev->vendor ||
-		     p->vendor == (u16)PCI_ANY_ID) &&
-		    (p->device == dev->device ||
-		     p->device == (u16)PCI_ANY_ID) &&
-		    p->disable_acs_redir) {
-			ret = p->disable_acs_redir(dev);
-			if (ret >= 0)
-				return ret;
-		}
-	}
+	if (p && p->disable_acs_redir)
+		return p->disable_acs_redir(dev);
 
 	return -ENOTTY;
 }
-- 
2.56.1.703.gf848ed807c-goog


