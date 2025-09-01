Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25727CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4800F8E0025; Mon,  1 Sep 2025 05:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408558E0002; Mon,  1 Sep 2025 05:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D24B8E0025; Mon,  1 Sep 2025 05:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11A078E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:19:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B13C9BB3F5
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:35 +0000 (UTC)
X-FDA: 83840133510.23.C5E218D
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3587C0004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=c+eUN05U;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718373; a=rsa-sha256;
	cv=none;
	b=Q/aubaZEvKlCEtxkNBcGW/buSmuLEqxipo+uQfML7Qs5smb+daSgUfcTfAw+nMQODp5ACK
	yIzULxGzyhcYzy8kTc+f+p9P0OiWShpZ3lnw21iGD6QwmeHEsAh+3BpCLLwjvbFcg8uZOs
	MWXn08EV8D9G3ImxKjlduyfzit/b+z0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=c+eUN05U;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8H3eprdm8oiBq+0anIaTODIO0eIcUyIWc/5jJ7tDkes=;
	b=0JaPtF/c//aHHVmjQTAKAJ8IjODoQao/xa+ZT43cxWk1CJjIEAdxsQoHXCGTOHiIQBazFl
	/sfAbZZdDUQsah/kwbqMau/dL/9pdcMHyB9/ATabkzg7NrJbWj5YabA8Z3hl/FS36TaK6w
	xlqdVjMVjRl4cFjlnuK6ZWei3fLlVKw=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-afede1b3d05so694642266b.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718372; x=1757323172; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8H3eprdm8oiBq+0anIaTODIO0eIcUyIWc/5jJ7tDkes=;
        b=c+eUN05UTBPeoVO1fDy/JlLd2Dd/wpvoZxsBi9D4TOnwAH+WY9B/gUY0rK1zQP0qix
         97zLfyNwe2r1A/IW+/JE//ugtquaIhfk8SM5a3acpUvhslN06/7RLO4cuQwi7roQAwms
         GPuzGdUEIL5U74fzQpSGA9eM5CddT1O0Oh4gtQALBu/CCTXHLscnxDzgii2RxUHZTPGj
         uthRL5xx9fAUVT5zedy2ZrGa+QTroZFE9FT0rY9N35mXxpIPU93m0QjcnOU5V27bXFRK
         3TGOz/k1e1zNU8epY0YiWeDcW8MKg2brZDkDLmMUEcoM8mNvdb9b/ZGOUCgG7+hYxpTI
         lE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718372; x=1757323172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8H3eprdm8oiBq+0anIaTODIO0eIcUyIWc/5jJ7tDkes=;
        b=Aw53ISbbAqLKJ5ks0+U0Kvq7crhh9CdrwvrDOq2odP/6EiN7OFmmj2+FI4+/+khSsl
         TDYcH/6aaG8PieXaoxyGpFjVy518eaXo5qm3hzO9KedgXCrQr8R0uA09ILE+8HL1FuzA
         ZrRfZasVba9mEnEzBNUYFUF8fQg3MH3Ka9oNZmAGqD7eSVb0TgicyHx/iczzhPH0IZM7
         YhK+brhIjW0jBEsxirryCj21usSXQgLqPMEmL6PVAR4qZmLKfTFsMlfbv91TPizRKRPd
         VkliC4s4Pj/GQrTTk7GgQ0zgRsF25foUo9CagJZmUBblZts0+ZLidWtfO7Rc3fy8aPFu
         QqTg==
X-Forwarded-Encrypted: i=1; AJvYcCVHYTQmt47Gk079KepFsL+9CoGGtzC+VbII1/2OEdROBaSFVD2qfWMw+9hFOtxTmEMoFaGjuTurwA==@kvack.org
X-Gm-Message-State: AOJu0YzbwfnVLKl1ufnPSBK/lJx0qrOXSpC2UVQuniT+YTkydUm5kLqa
	PqrvSfpAL6EhcyKujOQB1rVg/Vy8G20pArq8o+k6BVl32NyaDI88OwnyPS2Z8SGV9+Y=
X-Gm-Gg: ASbGncv/qtJrWgAGbsGuQsaR+g2Y2qbk6PiY8k5rr1Kc3wJu4VNhukpGDcCGa8DdwCN
	hAFhfsLlbXPA50w6Z5z55XAI6yFK72LKT3UkybxvegmWetvWb5JkFYu2SGmj34aPqQ1MRfs6mye
	lLSwjz1u0aAwUAfqLgVyiw6xt+jm+0dpdwW45adgfAiIPmAmUrzCZR0j3r/G+F+xsvkhnUOuwSC
	NahNLuQ9xv3BEQtG6FJLqqYIprFwthjf5rJkLrkFR50eqC3sUor91y4KrpEM3Dm9bFsnAoc+Z57
	i+W7+IWAUbZYt3EIrSOj4yM0lErvUVHReLXFuQhXyKgI51pkDZdaSzSE49V7GZLmkhN20NsloDE
	qBhAgShexFOsVpJnDWFpMee7U388SJPc5X6sEn8g1EBhL4k3VF2RQKrDIpkRE/a/Mdy7gIwBwPf
	teNIG0nRw5dRBAi/vDdSav9pVyKwMt7vnV
X-Google-Smtp-Source: AGHT+IF3CGqBNxa77EXUE/Gi7n0PBGLpiMmjL4vqume2Hy8S1ALFuVUh9cDg4qepPIlJtHhtd6svhA==
X-Received: by 2002:a17:907:7ea7:b0:b00:5399:f5c0 with SMTP id a640c23a62f3a-b01f20bfff5mr728590366b.62.1756718371341;
        Mon, 01 Sep 2025 02:19:31 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm541005766b.12.2025.09.01.02.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 02:19:31 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 04/12] fs: add const to pointer parameters for improved const-correctness
Date: Mon,  1 Sep 2025 11:19:07 +0200
Message-ID: <20250901091916.3002082-5-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901091916.3002082-1-max.kellermann@ionos.com>
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B3587C0004
X-Stat-Signature: gmizwuufrz4eegop1a8t8uowswqx1cfn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756718373-300009
X-HE-Meta: U2FsdGVkX1/Mzb1v5RBqe19b5TcesdO7LKHZmeE4XJomqCuJKmX/xYc5fRZAlzRh853CmKq5n2bSZFXEZUauGzIgI5kJIEEPPI35xJn6naWU5JmfG0ImpCyG8S/kCHG0AS4jafR5Yf+WhshWnliKChXkpkPE28G12sWzTxuVgauurKtUr1EyZo7FgEm5wKG9eL/RtatUSGNFqK2XsbMwJce8PjbOzw4L7P8HY8FaDq1nykdQ/nZqT3lzO28D9ZyWNxhSZRxpSiqtGJhbL322SdhCeV+BOTJwX0DO/1Nlmrxc1zQdduMv6/izgQG7oCyhq3pnjuUuaFxgOBLyS4Mq3xK58lzQgLW62OT09SFCLBZfF1pcwdj7Mkf5Z61UAgHKMNvN8qC59P8lOs0n1FZ+yleeieNAigvDqr1a/7/rPxccAYSqvXbZCbt2/5p5R7YoRZX/jbdaCXYLhzDIEW3CYWQa4Oxy9H0+r+OxVOGmQBfydZIvNTP6JYynpYr+YTRcnNGwXnn3lZU/b88UgT/khaLYk1UOlZ+AVZYl+RhOg9W1UC7eJ15TvCjrlwRIyvMlIkt6vDPU7C08PxUNABIyzMPPwxqR+rZkSm0aR4sIMPZ/xk9txRwROgOmHNIqZ+8cyW3XYR/XOikfu0UYsIZAUItMgPDJUZ64aHvLSzbquE8vhol95LevjZX4Ydu7P/VLrqcZAUFUCBdzjlOQjDxmx7C3cJtWD9PRnsP9lQeCILzKtkSprV9XJfVsF3wqRaz8w8OwN0sS8Z6dT7UkGE+7hpaGme7ym6Mi/sxmo26zgHpeLpjjlwkVb/FScDQFUNEF0G1CfbhouG6MhUyR4Dv4ufTrpJP+nkuwmswyQ51BgpOuCq60O5xVdLlHnmljT+/31uJgoWWjZqw56vOImQHHX7rwaIAcLwoZm7LLXo2f5vj39aHX5GssJ09sDFr+PoYI7oQAUN20ubHLKvPE5Ow
 /0K3SAgV
 IQvJi+yI7ZIM9qkzIzfI7+YaTYKgJNsD+KX1lTFMcp12+fOuzDfYJzxcSVJ2p6MuIM6vD+FqSOE2IO17mgJZBcx4STeHDV+aZLzBoNe86za9s4SBL227oDtgTp/z3RBvZk+M2AAaFIdzzOsoG289UiEWMByrw1Mg1XXuYB6ZhB5sVyXkYQy5KVRaDK4GRG7uqK2l6VHsk5WTpfOUYQxgTQfrAe+CFqSZUbbvFfvemzdJA5rPiqpN6GHpaTV6BIzQ1VHftmkqNdvoqwoqCcZLzZHQKD7Rq4xzvT6HxOWTQNFXsQZ6eyZQl7dmSQU0rBYzplaN0yQ7nX6m9rYg5flFNoXGYitWm4q7o4mhGB8+hSZ0QtDc3vsCOkz1Aq90Rj+rpKtPZSWiegwJ1qAZBpwAGyjGFKpsqYYpUHMT8xx5eMz3dwPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory management (mm) subsystem is a fundamental low-level component
of the Linux kernel. Establishing const-correctness at this foundational
level enables higher-level subsystems, such as filesystems and drivers,
to also adopt const-correctness in their interfaces. This patch lays
the groundwork for broader const-correctness throughout the kernel
by starting with the core mm subsystem.

This patch adds const qualifiers to address_space pointer parameters
in filesystem-related functions that do not modify the referenced memory,
improving type safety and enabling compiler optimizations.

Functions improved:
- mapping_tagged()
- mapping_mapped()
- mapping_writably_mapped()

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/fs.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b9f54446db0..8dc46337467d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -537,7 +537,8 @@ struct address_space {
 /*
  * Returns true if any of the pages in the mapping are marked with the tag.
  */
-static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
+static inline bool mapping_tagged(const struct address_space *const mapping,
+				  const xa_mark_t tag)
 {
 	return xa_marked(&mapping->i_pages, tag);
 }
@@ -585,7 +586,7 @@ static inline void i_mmap_assert_write_locked(struct address_space *mapping)
 /*
  * Might pages of this file be mapped into userspace?
  */
-static inline int mapping_mapped(struct address_space *mapping)
+static inline int mapping_mapped(const struct address_space *const mapping)
 {
 	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
 }
@@ -599,7 +600,7 @@ static inline int mapping_mapped(struct address_space *mapping)
  * If i_mmap_writable is negative, no new writable mappings are allowed. You
  * can only deny writable mappings, if none exists right now.
  */
-static inline int mapping_writably_mapped(struct address_space *mapping)
+static inline int mapping_writably_mapped(const struct address_space *const mapping)
 {
 	return atomic_read(&mapping->i_mmap_writable) > 0;
 }
-- 
2.47.2


