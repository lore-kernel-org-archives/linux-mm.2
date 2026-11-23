Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8192C606A69E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kLhMJccR
Received: by kanga.kvack.org (Postfix)
	id 9E6506B05B0; Mon, 23 Nov 2026 14:01:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9970B6B05B1; Mon, 23 Nov 2026 14:01:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F5F6B05B4; Mon, 23 Nov 2026 14:01:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FDBD6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:01:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0CE812098C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:01:01 +0000 (UTC)
X-FDA: 85467301122.05.DECAD48
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by imf31.hostedemail.com (Postfix) with ESMTP id EBA9720011
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:00:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kLhMJccR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3ao0EawgKCPUajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3ao0EawgKCPUajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795460460;
	b=xBhFwY+wfpH41wn0d4nf9kl3T8H6J3QaRgb1byB0em8p/ODiXTSZ9G7CnaBTvSJc3+Y/tc
	QLfIExPEpiF/DQvSiSYuCngeHSlxhFS5fw4L/Ac9ZuyZUDLxxXzhv3RY2oUvH9W9HEev8a
	EwT4YJYCBk9O3bg1nTtS2BZ6ahpuu6M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4CNQ2xoCIzIiOKM0YDrq2t5ezZfH9cmVn2diC4Zwwo=;
	b=XFBG+8G0Gqf6DcjzowtPvF1CTH2iFiNrqDhhssgUChNnphwWuZlJ+0gYxRCxV7rb/AQcOV
	Pcg1qRoNDZUWg26tYuDHM4P7Yn4WVmWan/Havy0QDWPykUivW267dyVFuF2ylNNzhQybrd
	Wlxu+NLCvqFyQLbqYcLeJoBSgTOcWBs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kLhMJccR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3ao0EawgKCPUajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3ao0EawgKCPUajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-86320da67fdso3914844a34.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795460459; x=1796065259; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l4CNQ2xoCIzIiOKM0YDrq2t5ezZfH9cmVn2diC4Zwwo=;
        b=kLhMJccRUqCorqvv8wNDhlZYpl6KZSioEJ2hErnsLIcTcrUYvSINdLMYL20af7oIUU
         gUbGz6jA7TWys1wT8M2Mbdce8lITMdSx9djBNEhE2DqW2jj/Gpy1qGt7uFyeNrlkMshO
         W1BtQvumj54WBQc7kLdG/LzZDOPqlFv7fJcN2F+Xn9+F6G1didXcCINCUmNR05SiGqHD
         w1cqslJMM/yJlwcg2yApfulu73dzXHNSDLQqBEi2QnbZOl9j81pibNNCy9OgPi6C3xMi
         SyAutgfa5V8z8gtfn/c8VqcR3zG9XNpIUzvS3q5WhZI4XIlFvEkc5OsWvDb+x88A+8+S
         5WWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795460459; x=1796065259;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l4CNQ2xoCIzIiOKM0YDrq2t5ezZfH9cmVn2diC4Zwwo=;
        b=AYVvcP8daNJKiVv94UZl+AXDwV4EGTqBsSs+wtE0RpgFteOlXDX5JSdC6be55+2xu/
         a/sGIETRGJvGfpGo0dxusO5HQUQXlgg8QnT3mlg7Iya3glF9BGT7M8X0Hvo3JXl5F7yE
         GUTvubhuSgkRspYzJuf7BQ/Ny3By2cBfF7ijQzz6sOd9gGqZ1BqNIKaNdhvq+PYjxHkS
         g9ADewY8SllehkG6uLH9jYJfHJJwpm/HTdBEdlefYBCIi4mHcJ8TXROXKTG4B7HiST3h
         c7+ss/vHOiaOmJUi0LOETv1an/u+oyUmAKaPHFCV5dfIpI3cV08NWIwZRx/G8DXZZVON
         mJfg==
X-Forwarded-Encrypted: i=1; AL+hErH/LQcgeWkXjIrWSRZXb40P9Xs4L1I4KBRcl4pWpncbUbMBagWycNWD4Bhaj1AHIn7RXoiz88ZcAA==@kvack.org
X-Gm-Message-State: APuU4Z93T8K/GuBQHlvDEdBQ6pHhVyPZQ7davHav5BfQWlIrkeFkZBcu
	xg8bQyO9CEwx6zOb5Aj8x0NdyUH3o909qy96mxhFWJvz1a18N560QouoGdI6mRMAl1YGHXgwjAq
	WCmxROBb2ot9YjQ==
X-Received: from ilbcb19.prod.google.com ([2002:a05:6e02:3193:b0:54f:8d15:4dbc])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3084:b0:55c:844:98ff with SMTP id 5614622812f47-57a0a93940fmr14754171b6e.34.1795460458168;
 Mon, 23 Nov 2026 11:00:58 -0800 (PST)
Date: Mon, 23 Nov 2026 19:00:42 +0000
In-Reply-To: <20261118223704.3286085-4-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261118223704.3286085-4-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123190045.2166865-1-dmatlack@google.com>
Subject: [PATCH] fixup! PCI: liveupdate: Track incoming preserved PCI devices
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
X-Stat-Signature: trfjre9ijodh3entr5kk5tegx6txe97h
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EBA9720011
X-Rspamd-Server: rspam03
X-HE-Tag: 1795460459-891005
X-HE-Meta: U2FsdGVkX19NeIsATYyrjmzQGT8/bp7zjwq2btaUWdyIJdfEImW1fQ/74N9ZKR6fAODIy2sVQW8QaSg/Jp3ItOxJdLKVJxplAJR+tL62G3iNPNMZkIF7WxkB2t7E/T+7RCozuXNiHEZ2aALboqe/474xexpnIsoFQVZSAq4eMEIfcmpDhvLXwGKiePWWOaApHFWSysiMR+DnBF+Qo9AK0r/7ANkvNiKPeXF5ody+fpXsOvp+ZRRZiIL7GMbdXiURgP41eFCuZohYKPzR8j1SAjP+V6PF990fDxkz/FjHe2g1YxtgCJXSsbs3nJgXUQpoof8zoQSAnNQU1Bux3tZvXXUqdYh0IiDZyK2oMiFjU+2k4HI5lo3+UmhqXQ04ozWEThpfcWxvd6h1G83pBicO//DGZ+HnncEHsfRqILtjtQDFUAvEtUFk/S6x3JbPZOoohFg+UfsW49lnfx8cxaJUOt9kqBBVS0IGiYCcobXyK3k2uzlwy0sjd6w3cKUwoRaMRRnNR/OmHWcdsHk1EEy3xpuDSPnR8gI81qqeHn8R7ryj6jVOfxTkYJnOhnTyQLiar67IA0Djzzc4I9+dIsrBhJMuaWZNdNzbltGNf81sysJSmbruxRFHOZrhFeK9ShkIBhEqbhwDZE8optmgSz8oo2Pv8EGO5sUWOSGcZUrZmbsXZ20LnEIff8BUjKlZL87sF4ghSBAZZg8Yr3LlSK+wTCefThZ5vui0eRUbSZR9EOXiaYbS8A8WO8/cfBkFQU08bB01tHUhJCylL95QvrfxJqZV4xeUjT6Ecn/CHf7rQseHJVWQJtsuBs2j3HZa0Xet46aU4BXdlFOobzYv3yEIH54SbE4vdwT67zwCu2/opYODvSIKLj0ofqu0x6e3vLN3reIU+bEeVuZkxWyyFN2zHnGQYKMl7aLV660LtnsNLaaaAY9k5uXdv/yv8ROEBmexZ77mGrDcTH1lVYAC2OG
 Vct2+/FE
 E0jjNsjtIRTALQqVD1zlgvZu8Ab1/L8st9AjeBluH8MseI6Exq3hW+SfcppCDb1R//+EzGbEUaVAcM3aImcdWykDmA6hQ+Ng/5/FLCEijs7KtglcEHk8nJcA+GV7elwDqtJFJmKjweGgg2GyPNvXEhAJ81RgU7t0rLUJkbl3JHPi1GTppEGDwhNgKazUNK67MYOH6u7ae/8fJq2IMtUm4T4XoQBc7pbwcLfWUanToubSB+rnVT3F+s5ZO3T9u5RXAGAaef65VV2kJEep6KjHLRLZNV/PnO/2Piiv00Cpl5vLoGfiD1YinnVw3/0bhCNkmQRqIFwMiltj0AlBMsArNuI+5dt/sZGAUe+NjI8nDO8QGh+NsTjFe1Mi7frNOtr6DhZKxQZx8W21F+gnUWF1+OmUYZCEfHK79wexbY1+UCqQaQjm8P/Zl2R6L3Gr5D1bqSju43ql9H8FOncRu7ahTMfe2N+IRszcnygxH0XCFv4Y4NUMTm4qA2RLztxrsi80LcDhgT9CPudRtyEqVXM1BLsSL7VoSAnrB05P7l9I4/ReWCavAWTGyDKPFb8w+FbBqdQwj3jijnlvgFwsq3QCL0DlO8rAx8Fq3DmxkWlMXlgpe1WKFIoEalAEBDOsms8UTJ/6NebTCvAvh7497qWU38dmm2sWEqAk+8gHnZ+KIn4IBXlYDk/1+KDV3VMp/tIC/p30JRY+by0N/2XdcJ1bNr+/r0XkFx6FzCdVI5WkEx8A1WpRXIieUCRWOcUbVMNbbPilyDTFgux3uhBhWKK77ZlRJLjWpx9dNLVCoSpJgYJ7Akbllh/7mbT7An0oPR24up29L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

pci_flb_finish() logged args->data, but LUO does not pass args->data to
the FLB .finish() callback, so it always logged 0x0. Log the physical
address of the incoming struct pci_ser instead.

Reported by Sashiko.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 493576119a76..520c7530475c 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -409,7 +409,8 @@ static void pci_flb_finish(struct liveupdate_flb_op_args *args)
 {
 	struct pci_flb_incoming *incoming = args->obj;
 
-	pr_debug("Finished struct pci_ser (0x%llx)\n", args->data);
+	pr_debug("Finished struct pci_ser (0x%llx)\n",
+		 (u64)virt_to_phys(incoming->ser));
 	pci_check_all_devices_released(incoming->ser, &incoming->block_set);
 
 	xa_destroy(&incoming->xa);

base-commit: fd54e32f7903199e8acb2762dd2debfffe4501c4
-- 
2.56.1.809.ga0b61035b5-goog


