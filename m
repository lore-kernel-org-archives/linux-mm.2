Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51BA9606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EgV9Qcgl
Received: by kanga.kvack.org (Postfix)
	id 479486B05C3; Thu,  5 Nov 2026 19:43:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450496B05C4; Thu,  5 Nov 2026 19:43:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38DEF6B05C5; Thu,  5 Nov 2026 19:43:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB1786B05C3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 83DA21A0C7D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:15 +0000 (UTC)
X-FDA: 85402845150.29.FC85C86
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf31.hostedemail.com (Postfix) with ESMTP id C850220006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EgV9Qcgl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3oCLtaggKCPcclZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3oCLtaggKCPcclZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ko9lBiZy6mSuKQIVTlOLgBpFZr5J5ifQKI8Or80My08=;
	b=Xbvsu5ZN+hjhjDqK5hlyrdsIwFnpeQX2PVyARJ4fQ9+lv8BWDrifdWYDcQbpHrVBKukj8c
	euAVyFM/HFMO9vbRxxNl5xfznkcGOvspD7I+Z3JlZuL46j2Udn+ggfv5F57e7j0o0F6btq
	bdaFivdn+uwj0/SP9sDXxPyXjc0N5LU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EgV9Qcgl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3oCLtaggKCPcclZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3oCLtaggKCPcclZskZbjfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925793;
	b=3ioMYgF9j9nzvdvkXrjaEACH9sPwSPNgOvEw4D6NKyGmXOvMX4Z+o+J3PsMx3ZHx3r+S1G
	xynT9sEerYWlUwXy2xPoM2Fe535vI6NvtV601ZI8iHL/gIgCUkv0s7tyT/eut4wKdG6NpR
	RqifermkasuSyO7umH5nbFh4vS9a4gg=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4db3db8687fso127708b6e.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925793; x=1794530593; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ko9lBiZy6mSuKQIVTlOLgBpFZr5J5ifQKI8Or80My08=;
        b=EgV9Qcgl/eoU5fzHo8I4s97LsjqN3u3b+OQkqT9ai7AJX/2TNMh2B6RsQdcyQpReHd
         No7exN0cewbSFjKb9fuXKakNpOWan3uHOIUkVokRN26LzOojwHwEa087HNCfwd2tbQ/x
         s3IJlsruWpbcjkQBD3xXS5XgrxIbhlnXUJMmSAZmuzc+Hnu1QcodWkzMgds25kfOHgCD
         kSDVhvMJ9ixgsSr4EuJeSi46gVZmdnVgY8yVilCqz8AoGPEbANWtMblp6YYoiBiF3SMG
         fMwJq9z5Op3qt4IaXrpjoL+cx0OxF1LuhtURyZRhWlCmIv9FZFy3Z4utJKE32OfqjMud
         zIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925793; x=1794530593;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ko9lBiZy6mSuKQIVTlOLgBpFZr5J5ifQKI8Or80My08=;
        b=O4zH9ZZnXIB5u0JUoaTtwitiv+9xcyvz/AkMc0ysxzo/+TfLaw+tlH5ryo01AA3Alb
         uUe6hksvHXbghkEgKCpe2m9vpxAN4jELxkYBbg8h82Gu+GuGQGh+J54q9wseFLFfJ0EX
         Uq52kiiE4UUXME3BY2B0W2+HPTQxmG4cbwdXm/wX055jd7rVeIBFPWOOMOqgDpfdlDiU
         NgDEk5HCkl6UEqWsDAqHpwZPEuqfRRWqbSthdqMHdIk7yt6Bt7NWefIUGImor6nArx+u
         WavQPwn+TCcf2YKFbeYmhikCDy8MDZxw8NuAE9M5t3e/WodCXtImE5y4SuuuSFxlCAMN
         Zflg==
X-Forwarded-Encrypted: i=1; AKwUvByQC/DmDOwGS7b02FbsNRjouchKOQfGTLJaYUo4ZWxzU9bblM7ZogCZpIleB2cpPA0JD/1Q7Yfr4A==@kvack.org
X-Gm-Message-State: APuU4Z97Uum6mzNz1Ae6dXABlqeIKFBlZQ2ErdjlRcwW1QsWd9qBDGim
	hBT8edgA8TrymQzA0XDAYxOvznZavmYs9iE7IPSgDNOZ6Aw6OvX26xWWQ85VLhnwoSWQYy4PfyA
	ozrLbbIcFG8Yu7A==
X-Received: from iobgs6.prod.google.com ([2002:a05:6602:4fc6:b0:9c7:69c7:3d52])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:5087:b0:4f4:857c:98ae with SMTP id 5614622812f47-567e0faea86mr686749b6e.11.1793925792669;
 Thu, 05 Nov 2026 16:43:12 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:14 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-14-dmatlack@google.com>
Subject: [PATCH v2 13/17] PCI/VC: Split the VC Resource Control restore into a helper
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org
Cc: Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, David Matlack <dmatlack@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Lukas Wunner <lukas@wunner.de>, Mahesh J Salgaonkar <mahesh@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>, 
	"Oliver O'Halloran" <oohall@gmail.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C850220006
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: ppjsd1i81feir7645stgn3o5oycca5a7
X-HE-Tag: 1793925793-247948
X-HE-Meta: U2FsdGVkX1+CdDscFFaK2rdlSdsAEj6WHxStophUgh/kO+8svxlR00Kx0Wf5FXqR5O+T2436FVXsDHW0wzsbGsNlej9YiI9pJdUk5NHCy26azjVvxpjazyASzBiyeJjcfUx2dpGVP/svzOrfjGf5JiFbRM+AuZntnt3RglVLXQU8D7XjAX9ImepT/EYNZOdCgaBRhJS8WU+vyW7TsoMui1Rd+i3xIBkY6O4a/xWbgbKjWob2cFs+9XPvM7TpW7s78ENk+cx8hy0FALBArm3iAANpx71vUtQQu3nFVlEGI9fzsnMdzjWmTKHw/LjYgv5XjkysgT1lN6N4zd4N91kTv4zsG6aJb68CMd8rXnSYPs4RTScVhjDyzWDWV5BfCQMmTA0IsW02Z6oLjC+RyGrBRbKCSfO05J+sSAJDC+Ey5M5Ohka5c75fsYxUIZ4regQBfpKkLEP119hk1cPNmJ3C5rnfrhDG90iWaXcEp64f63iNHMAp1M/5vy5hiqNGeUxy4sXScz5sCgIMIOTgC+fvdREgsuitB+EbaAD9ozo8UtnKDGBWAkDshzeb+NQDiJveQNwY00Zl7UWIVrV1+/5tFN6nz0DWcaEtvw9BYhvjoB7zcuW6o8l6a8wcPaUJLfQEjOhkJ70YH/ikfcNz/rXhR8wrL5xrIF+wUfSVdVY+diX+5zIaRwOuipWWR0qTnhfFVDclF4HI/UKoUo6UAe557Zegh+Qs3KlTkCSHlM2jtZRPlzhmZHw9EuZPkgUYeK3Hc7m3DtNqrLwB8RT2i3YyijiIuB0PCJGmZYTXzPwDY8c83hfxsIVNVyEd0Ao1RnvqT5To8U7FiXV2oI+lLjnxZKvX2kKGCwWzR3J7467VQZdB9LEyF8v5Jl1SHe9ifvMlWMEekjtTfDLWm4OnRozHlEIvfFM3kd/oTyg+Ru2Xpo8T69GlXu7tLx5WaYGPqIPXlZ55J19DtUC5m3fVUuQ
 gV9/xL6b
 XkiNOKVblHXCx6Kz/N6lQtFkjj0rVTgQDfQdUjQ2RDa47h5bLE4A3wFH5Jxvn0HcnuJp2j1ftaLZJmi0lQPqfvnEpBx3E/05AY9CqpbcFad9yzjlus3IhBE6TMGnxRQymtLtAAmKpjPvB2YUzpF/zFVrv8Gy+uQVj3ljQrCHwrjTTMJz0nBUlgcCtHwv9w4jUN/7x+4PqV9JU+/vN9me4LiK+35acmMkAVOVwntAbg++45RSfRP8FWWzz0LIREsmasmLSwVmeJHloXjeVkNP1gz4FCGaB0kMlYCOk3T6u9TaV7TVEBc7Gp2Occrfl08NNoZEcgtobO4LCNOCr2LKEJCdNKTC04ow86jqHwWQjmfrGNxE2E1h4D8nruia2fTeLSuj+8X1LWH7jZJsiaikT4SQiubA9XkPuYxxJDQonbDk3NQenovuTdeu6g96ATe8sQOGKUTevpF2+i/SUWQTN+e8sPGNqTfFfPe4oFd4X7joITO5p5O+WMlQvZ3KPTZR+K50eIrmtT0M/x6e5YzZ7dnMdA+s57jMY8U7HXHWFrkU5Zzfq3kO9w0eQuXZW/US+IoMszMu0jbAAnaxlbEgBoYl8mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move the restore of the VC Resource Control register out of
pci_vc_do_save_buffer() and into pci_vc_restore_res_ctrl().

Restoring this register is more involved than the rest of the walk: the
enable bit has to be preserved across the write, the port arbitration
table may have to be reloaded, and the VC may have to be re-enabled
afterwards. Inlined in the middle of a loop that is already sizing,
saving and restoring three kinds of register, it is hard to see where
that sequence begins and ends.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/vc.c | 51 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/vc.c b/drivers/pci/vc.c
index a4ff7f5f66dd..5b507207d56d 100644
--- a/drivers/pci/vc.c
+++ b/drivers/pci/vc.c
@@ -168,6 +168,37 @@ static void pci_vc_enable(struct pci_dev *dev, int pos, int res)
 		pci_err(link, "VC%d negotiation stuck pending\n", id);
 }
 
+/**
+ * pci_vc_restore_res_ctrl - Restore a VC Resource Control Register
+ * @dev: device
+ * @pos: starting position of VC capability (VC/VC9/MFVC)
+ * @res: VC resource number, ie. VCn (0-7)
+ * @ctrl: saved VC Resource Control Register
+ */
+static void pci_vc_restore_res_ctrl(struct pci_dev *dev, int pos, int res,
+				    u32 ctrl)
+{
+	int ctrl_pos = pos + PCI_VC_RES_CTRL + (res * PCI_CAP_VC_PER_VC_SIZEOF);
+	u32 tmp;
+
+	/*
+	 * For an FLR case, the VC config may remain.  Preserve enable bit,
+	 * restore the rest.
+	 */
+	pci_read_config_dword(dev, ctrl_pos, &tmp);
+	tmp &= PCI_VC_RES_CTRL_ENABLE;
+	tmp |= ctrl & ~PCI_VC_RES_CTRL_ENABLE;
+	pci_write_config_dword(dev, ctrl_pos, tmp);
+
+	/* Load port arbitration table if used */
+	if (ctrl & PCI_VC_RES_CTRL_ARB_SELECT)
+		pci_vc_load_port_arb_table(dev, pos, res);
+
+	/* Re-enable if needed */
+	if ((ctrl ^ tmp) & PCI_VC_RES_CTRL_ENABLE)
+		pci_vc_enable(dev, pos, res);
+}
+
 /**
  * pci_vc_do_save_buffer - Size, save, or restore VC state
  * @dev: device
@@ -311,23 +342,9 @@ static int pci_vc_do_save_buffer(struct pci_dev *dev, int pos,
 			if (save)
 				pci_read_config_dword(dev, ctrl_pos,
 						      (u32 *)buf);
-			else {
-				u32 tmp, ctrl = *(u32 *)buf;
-				/*
-				 * For an FLR case, the VC config may remain.
-				 * Preserve enable bit, restore the rest.
-				 */
-				pci_read_config_dword(dev, ctrl_pos, &tmp);
-				tmp &= PCI_VC_RES_CTRL_ENABLE;
-				tmp |= ctrl & ~PCI_VC_RES_CTRL_ENABLE;
-				pci_write_config_dword(dev, ctrl_pos, tmp);
-				/* Load port arbitration table if used */
-				if (ctrl & PCI_VC_RES_CTRL_ARB_SELECT)
-					pci_vc_load_port_arb_table(dev, pos, i);
-				/* Re-enable if needed */
-				if ((ctrl ^ tmp) & PCI_VC_RES_CTRL_ENABLE)
-					pci_vc_enable(dev, pos, i);
-			}
+			else
+				pci_vc_restore_res_ctrl(dev, pos, i,
+							*(u32 *)buf);
 			buf += 4;
 		}
 		len += 4;
-- 
2.56.0.455.g6c5a503b38-goog


