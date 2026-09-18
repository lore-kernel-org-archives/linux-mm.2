Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30BBBC982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9DA6B009F; Fri, 18 Sep 2026 16:07:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB636B00A0; Fri, 18 Sep 2026 16:07:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0296B00A2; Fri, 18 Sep 2026 16:07:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD696B009F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:07:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EAB6A1A0790
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:02 +0000 (UTC)
X-FDA: 85227966684.10.31A10A1
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf01.hostedemail.com (Postfix) with ESMTP id CB18E40005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789762020;
	b=IvlYDHB/EyTMRnLGELHZVEopAsQgsB5lpcC2jGNLJvnDbkhXRCsmJK4FEzvTvOuZ9O4H9S
	jEprD8TZnp7p5rf1hR/0KGtFW4Cd2zPEFaVMbD8DkFwMZa7DecSKvEEY/ctfiD9di5BLPd
	GVEzD8FUjtauOhBlX58LTKWLJAPumN8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDTO4eHKdMRuuk9UsFB+WlCX7AwxRYK2xSqBvBKhZIs=;
	b=kGfAGgLiWJoYmo+iw9yjlzqreg2jPMVoF+lAZYAgU7d99BU0FTYoz5snNEJprW0FAQ/AvA
	B9+RpBSbXFPVKTCNURcE8ytjWeK2Y/327WMmYYrvbL2v0xgDq7n88K+3aJSP6HAmZLRR+u
	HsGb/wfGd1yvUCQ0ZIA7FZ+0+qZiAm4=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53B54A07CE
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:00 +0000 (UTC)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 258A314078E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:00 +0000 (UTC)
X-FDA: 85227966600.13.7741236
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7994F40007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:06:58 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDTO4eHKdMRuuk9UsFB+WlCX7AwxRYK2xSqBvBKhZIs=;
	b=kuwpO0Ahe8FwgyA9SYNIQAbuBP7ElAuY8YQGm0314as2tABjGy+N/lvvkW50y3+kfvKH5N
	0UT56UyuF8vYMrrvEg9Qfayuu/I37fsA9BJQrY+jsVKllF5Xm4XUVLHEMpJAes11NsUIog
	YlbpyxgrTPlH0Vh1n7QHX0n3kWEXKvY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rOUDkP3i;
	spf=pass (imf07.hostedemail.com: domain of 34ZmtaggKCCgHQEXPEGOKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=34ZmtaggKCCgHQEXPEGOKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762018;
	b=ceOiQfk1tG4yk+im9HagUNlHaI6y0k61tTbkQM+rVsUKeG0aCx1eUvVgQA5VW/RN22tsd5
	wxS49xmFOSZzoykyok4FTqZHHNNOaB/8e1BTu3snYUnbxAUUEZ5EZGMCzpGsMx3E+kf7eb
	i6kC0Ttk2torMlAx14yYvsUhO8Fz7Vo=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2dd667770efso23589835ad.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762017; x=1790366817; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VDTO4eHKdMRuuk9UsFB+WlCX7AwxRYK2xSqBvBKhZIs=;
        b=rOUDkP3i9htKorcp7/JXRG9ybFWuqedPJ7gNjcHeGxuynrX7LDKwFTwxETIukBwaCN
         o1P09oXeeQjj4j94NiOtjECJeoG5q4GBB5iBCM05npdPc3gCTxIpat7FVzAYxDPb800T
         sfNbXpcxdbbdd4I57nqpDv8/a/sDUYhPTF5Zz3YZ6p/sH7Jagq4W8rgUzJt8q97mVE3H
         XTeiTrXsO9g2kuXdC7rFQ7966C4kGdtSgrW+bdu2vcNHF1K/UekASD4zr2iVoYse5YWf
         BLFbBM7zTfPcApsGWLsWY74FsJ9ZnRqJyvnoWLPr5MBlaov4yT2dtOClsGUCCGGsUgiY
         O3WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762017; x=1790366817;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VDTO4eHKdMRuuk9UsFB+WlCX7AwxRYK2xSqBvBKhZIs=;
        b=vBO+En8GMsK6Rm/6hpIkUq3TpCAdeerz7aw+uTQgxe9V32Z+M285+H8km2L32CLOir
         UMm/uWOV3++ouyo0lXTZy2xLcuzoFx6bLgs+dOqE7Xb1Qwqq+A0pWuQQPuLj8aflGyw8
         a3VUBs9S0Sen3KPO5XOgWO3fImWBItQOJzhTPeyYkPBj/vy5JpxWm4jAPtu6WmH92rK9
         aYA6eH/saqm8iE/TtxA6Nkcu9/VbAJzh9ohkzj097kPO3Nk68fkJe8KHd+KFM+cjkGpX
         FgbFKSfLiOAo4vsjxw6MUmxlt4FOSLthz9r6xCM/FUEKHeTMAmSBs6j7yUIyBfOLjkp0
         mDtQ==
X-Forwarded-Encrypted: i=1; AKwUvBz3MWzBPYFhEr4+eS+G1GWpON7YaBw/jOoZy3MTx5s9GCCoosuLHTJ46itqzwI0aH1DNrPyqU0pIA==@kvack.org
X-Gm-Message-State: AFuF++ncQ6OsLc0+asvv6Z3nqvk9N3bIf0sPcZhD8mibbbfmbBv6Bfo3
	XyjFaNundss68TsVBq2hdB0XABgltAFC5I75M+TL57F37QCy3oDY1LsTsRdXnYTkff134CG1FZe
	hyvugMnM8HjOFlw==
X-Received: from plmk4.prod.google.com ([2002:a17:903:1804:b0:2dd:be98:5b81])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef48:b0:2cf:7db9:e13e with SMTP id d9443c01a7336-2ddb20fe772mr43004845ad.3.1789762017240;
 Fri, 18 Sep 2026 13:06:57 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:30 +0000
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-5-dmatlack@google.com>
Subject: [PATCH v9 04/13] PCI: liveupdate: Document driver binding responsibilities
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
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
X-HE-Meta: U2FsdGVkX1/cHxGMWOn3KBLrxRIqERCkhDiwPdpfRmQongVhTi+ukhZXYzSEFt+G2LPOqF7xyEbQQmw841VMcApSsCs+p+OWsBb1+sg1bqAqjRmSMH+CoqFKOWXBOWVgvFzVbgM33G9EiTKZeVyVdhLfKysN3xB+hWR9jQvoWmeoxlXQZiTONzQcmYKN95hIv45PqkLHeh2L1nvbkBxqr9ZgiWCbPOf8v3+iiK8lGDlzZJAkIjB9uSp59iGha956s//F5ssXFsDp0X/l/QW9FpCydA8geiXzcd3DLPK3GNAn5B7UdtXLASQ1GMKSnG6Df5jWrheGhg8Uk8RTpm8Pms/yUH03HBp7CKJhJHSNV4H1DArBS8N7IEpxh+dzcfFQ581c8SHHmwwFRYp8EoLZFEDmfWU9xeqO/P8KVEVrSG87dhmKgBUCxd8uWr342n0meBwZieVEdpIOyzpbP31Qyl+MJcot14Sgksm5dRsPr/ssuKBCNOPMnjbRXtu35yuK/xdru7nw17ah0PXJVhOLETy7x21YTLQ4ur9ZVtoCGIsNg3DCSbu7AO2Ce8x7OwPmy/H6JwJCOha6VWJqjPJ3f3Q/7MYmjpn8N6rjCRU/enO9erSAOPBrPYo/9edb+DiAgtpikqMsH9pSn8eVqbIeoVJG39Q8BDJB4SPzH7NbKGTbs/a4mxqZSSyOTG1bYhGiRdJPGGKcFCQcfhPUbj2hRbnxutEHOEe8ctIkDXO789Kmx/qiY60jECSMu25mn2dw2+RkhAWdkYkXglKR/bLroHfFrEhX6peJAwlF7mnvucEk1+JS9KI8+cw+n312cZSU0whJ2c9hZOnDr3NntY+yY+9HXVU8un+LM0sAblmGGhzlIpV3HlfwIT4Wz76y5I+iKjFUUwydh/Ovf9DlXO/IdOqpgbDF2eae85YghzEOD8LXIqPehhgV+pAlJzqefFfD1KJ/fuhKL4DAF3yIUUM
 uCApg0Cl
 ZMgkh/jRjl3mgCyG2+vJuE2DJDuRfpNddVja3XpOEPYane289IAmmQ4mr+9FKRZbE7MOB12WXvS/LLwEATVSUczktXki48STewjXkTax/eHFuz8AP0x62T5eePi+ZCn/lwCJlQquzSoP+Jc8aGbl9xPSq6fxfqYXxw3RSWmThpstXG04lj0H2b6ZDPvezua7La59TAC7gT9oD4fVjrG1vBZCZq2E7hM+IMkVtWaCaUwISlgKp2UQNldyWbh+J1EVuyF0z8OMnU72pv1TtUP/L40QZKczWA5hJozN9pk0q7oVgpsD010Sifo42Q0obq2/CrLbWTYfa1CKUmZBAgdO0p/cuYNpdpUd0zfWTEgkg1TiMwoUBVD32AtAS8wrcYhod6UFRVAoJsB8cgFi4EFKbaPd0qqbykha2wmYDlw0BjDJ5clms8SSM/ZCbW4gYlRPrR6MHeBIr9D6vxX56g+9Pu8kN6fqnOFxzzCFUc260OaPu5W2wTrqNg3MU1STviP/409P99Uyd8c1PljuCTfAffNYxTYRnsnBrGojxhsFMwyNButp68TapCHQSKDEZfLcp/khIlF/NOK0ksEHXaCDXciyf7pdAW39nVqDhavmlt7aNKIrUExohFHJBUfEnANRaEcE1FjTqLjkjAcG+nPwlavJaFQzEdoYFmJC30vEvxiC2xlE=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CB18E40005
X-Rspam-User: 
X-Stat-Signature: oheqefghpfws49i44eussuz87krtzgbn
X-HE-Tag-Orig: 1789762018-97785
X-HE-Tag: 1789762020-137048
X-HE-Meta: U2FsdGVkX19vTG3j+cM6ZREKoIqhrXNWwuRsz3sfOML0giiYSYWcVcRpFjKXY9XUdI+kBGwvUZC7Ph2e1hJi0YKmACLHuvNe7+kabCoj2DbE8fJ9qcrrJMlbRR31t54pICs1F/mk5WMayzGxRlOsu9Nbqq39Eo1RMYeZdNAKspp5/KcoAYZHcUcfOA45ej8Pf2YT+z+HdD3pTkHJ+h5bYfry9OMRN9cMxdQRFYx/XhZGhOdyco9YSCrZcNV1rpmIlMtu4Zwy2X7O9Mgei7mChlmeR7XNgliTSFlCAVlsYap47fX1DXaNhrxEtl0Ut4+2BCO9pkkmgvbHQ8I9L3tBOHyhhfJQDLNpVesyy4BpUtzpc7+vFcuZygkfJYqvVhgr+8ePz/TI/Sr3fZS/AE94ughWSPZs8ZnlQuSMh/kMCXLYx0STXajN3MByh5XMKTRzQsjDqUFF4vySbbNb8h9Hzjd8TTA7BSfCjhg3W54mvlNPNUHeSAaaRFs8ewSIqHiQ11CroM2FgPJgUVjZW7R6RnuGfdXsauuCOVdk+AhHPvlhzKqwP9gCM2+xQID05e2XlNG6zo+oDu2IrXLacginNtxsECiUjIHhP3cBFjcK/9o+m9kf0f10bzo5PlfulJDJFFGYUxxvudxEmkr0TBZxntrqNqRFuRDF+T7Z29FzCWS5oOT/++iYweJCJGWauWq0pdnRvbOfFMX8nmjGOrwt6EaAlv3aBD0UW0xgUEIKw95S8OkJOclo2eJlZZ+C3a9H1G7XxfhowBxkzcj7rE0mjgrehNvgQ2jQIKCsE4JpgBU7EjZ1tDZE6Ea8AwolJRtMDHB4v0kd4Zpdn0gD+42YNJvSweycgY+OpkyrUbhtxAP15v5Hq75ST4cRC668GPenzMzemuw4syyjFBAwZE3zW9WTl2jEfGu3HRLkiWDec5F3r62ZGmIqDc/EeXlyCuYx2kooPMbC83V42b4YDGg
 AltFhp+k
 eRtREMwLa95QMLMcpK2AfhOX6qJHAzvvFQTHF0fwoSBYgO8tSLBJw48+84J9GJvM/uwzRoGk/VRJBdtmkUUmo8nYj1PRUcdtHevITtgEXO+sIwz99jfboaMgyy/WPnGqwZe6Wp9bZCHCpkNrUqHDS4EaBDjbyBjAnIEcGOYmP0cLjwigItM0mNJItjl+G8oRDHrBf6KQqgCb+MqMu1jRiLRWb9auTTlhoWsvoHIZF8UfHXEn/XooGJcZCdw3pGHHhQAHpKgdVhFolnPoUstVI8AFJB+rkpiqaoJ46HTs0M2FjknjSbjjeAkUCU9uuQs6fRotVxyRHc/myM6sbCtwf/AZQuiQrm3c0bOqyDWYyH/hT80ky6nXfPg9gerT6vkSXsihI9TNM7hQq+eQoIFlrD6pGrN9ZOO5lGrTrToVzvSralUR4XIutHzNEs9uHnMFgZrFxQGf5HofOWx+yVBk/ZjUaCSIFCANn8M+W6CKMAGq7ww+lGtApP89+ahZPcdf2CFy0pJFmD+gqZf9PW9zn83V49CumTxyNlkG7q5JXV//d8jyiWuCGcd7i26cJyrqOd8Z+8vcSjJULKgk69XQiw6mcfkaqQrjCyjOCcAeb2Y0y4cOjPJgFQdm0qa5WrlMr0OPnzW68GvGlM918YJffCacISQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document how driver binding works during a Live Update and what the PCI
core expects of drivers and users. Note that this is only a description
of the current division of responsibilities. These can change in the
future if we decide.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 00776260ad6f..ec8db86ed66d 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -123,6 +123,20 @@
  *
  *  * The device cannot be a Virtual Function (VF).
  *  * The device cannot be behind a PCI-to-PCI bridge.
+ *
+ * Driver Binding
+ * ==============
+ *
+ * In the outgoing kernel, the driver must ensure that it does not release a
+ * device between pci_liveupdate_preserve() and pci_liveupdate_unpreserve().
+ *
+ * In the incoming kernel, the driver must ensure that it does not release a
+ * preserved device between probe() and pci_liveupdate_finish().
+ *
+ * It is the user's responsibility to ensure that incoming preserved devices are
+ * bound to the correct driver. The PCI core does not protect against a device
+ * getting preserved by driver A in the outgoing kernel and then getting bound
+ * to driver B in the incoming kernel.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
-- 
2.55.0.1082.g2b9226bbc0-goog



