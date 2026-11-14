Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58FDC606A334
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RAVzUn3Y
Received: by kanga.kvack.org (Postfix)
	id 89BF26B05B5; Sat, 14 Nov 2026 08:05:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84CAD6B05B6; Sat, 14 Nov 2026 08:05:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714AF6B05B7; Sat, 14 Nov 2026 08:05:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8AA6B05B5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:05:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB4FAA71A9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:05:53 +0000 (UTC)
X-FDA: 85433746986.27.DE7F05C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 127EB18000C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:05:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RAVzUn3Y;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661552;
	b=sP5KUdktgVm6zDpAT7CWcDU+WvO905IeXVURak3r8NKeOmSvXWGUMtfPIR+/R3MoSB+9gf
	T4fxHy9ksn8pIguNvPgZ7aL2w7elIb/SOJk6psFsyL/YRLmeHoijgFYWl/eJ916PqYt0ba
	KkaB6LFMXsb3laKdCy82uNgpEwiQlNI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RAVzUn3Y;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E39AX+G/jh7TUAATD8FoQ3LTHbJD9uA3ozmx0gOpFaM=;
	b=vcZajHyc0pjrusk8D5JCfiqpwOJMehxdgbDNbXHwqT04eb/MUxQVfmS7goyQp8hwTlhgo3
	zrSzKChIvuzOJQLjas34mwfPB9LXzJVEBc/beiajVG4n8o0NflYzvPMgHNw7zrjqZL788V
	ODlaV+aWRNSHTQPO1/Q9TSIkb+aW7w4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B31E40C46;
	Sat, 14 Nov 2026 13:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C8A1F000CC;
	Sat, 14 Nov 2026 13:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661551;
	bh=E39AX+G/jh7TUAATD8FoQ3LTHbJD9uA3ozmx0gOpFaM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RAVzUn3YihPEfR8QNXiJZ4kO+0Ww2rPP5SABGZnl60hGUL2Z0RR98pxZaO/RoCDhp
	 vFYwvxbUW2TAi/HXFTMH17UIgslNBpCFe+PegPbRAYGSEPrqXonsLU/7Mi83e0RghI
	 czwaB96M9lWGq2+Bal8IV3hGZe6UTMGaixjoty54b98sTD+UZ2KloakvmTGKcP2Jtj
	 qKh6CkT3Y7cwABFcxmNSwVcEj2qVq/VdVxme/wkozCtmB2Ld1vYY0zFO17PwNCJ9q8
	 9qOOW7IJz3w0BfWgmHzKZBLNseME+eb0Q9TOZs/6zDxRI/611bKgvwwKnGnKZ+bkRy
	 yOh/Udy9zGjgQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:43 +0100
Subject: [PATCH RFC v2 02/42] nvmet: check that the file backend supports
 ->{read,write}_iter
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-2-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1291; i=brauner@kernel.org;
 h=from:subject:message-id; bh=//ir9fc9dMVqltiEAJAlWV+b7M4aWVaisbvAL6AhlSg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iMn4JfhIyMuq+MC8pis+ES5tTa9bd7/WXjzJ/vXPK
 QH3uOszOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbys5OR4c7lBycqbVyqBPoK
 F7087SO3W5fzvW6nkVvw5Mw915xkFRn+qe1OU1wTfjyRac5dfqezqXvv/Qotu/+h6FShzocNC3+
 l8QAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ga1i8ut7hdkomnczcfwx1htyao76up4x
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 127EB18000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661551-334086
X-HE-Meta: U2FsdGVkX1/4+eCLHfUx7o22FoNqfYYh7Tb1kIpo3TfCYAaPaGgvU4VgxZ/f/F1hzYQ8OY/MwqDky8Huf/d0zbjIq5N52eI+qWRh90Axq9WyjuAdSzGI6szm4BFQlCbukGmSmXPCIStsRJS1woyQeVK1Msv5jxvC8GBwKVLp070c+tLLRRPLV3nVO719k6xMnZav9GdpomMLSr5jIEq2xIS0gVkcpTEMX17KORVJcY4yHsYVmKfcjhAQ38P1O/XKcYIpJuzhhWWZ3k9MsBGGZnPNmM6r+Gsq9pnaKIzZoQSMj8iIYfz3TcAq5DSqnsWx1myFhbyXNpInuSOj8xee0kb6I6OyBsOfWbElh04pRRZ3IfCp/FxQY8UD+Ti+U7DOLiKqLWiVmOHWPej7L4yvNI+Xnq8+goRAtoVbG5ecD6JEEofemd4sZ7SpLDa2qMM07QybKrJA92YpDMTNhHoGIX/926bz6Drt/OnWkhJYhp8jkQttOInVZtieKS3fscjOGvXUPIJRtV7ERKFBbQIdJuXAlSg1PZ/Sks/ivGLg1dIld31BqyfZgIVSX7RL0/098va2X3xyDX+msYT+oN/ke6zgrQfwizB/veAHcI1mYDXzV4/vG1dj7AxCnDtrqeseokqKtC4VuSmYV65IyQ7h6ZV19ckXKwm4nBYzMD1PtjQuIdIjE/4v/DQXURU4oxkPCdILDj2lfb90AVAdqz7iitdSvdk8d36+csimi4g0GXb9rhQc5AF8m7nMq5FBtWH7omgnTYfwPOlBxK/XbfXoNH7JVShRGoSBjAH9vznwnur5rPW7Ey8wnyMb2yYiJNTRQ5Cn6d2prlGhUypRECkZQ+vosOnCQ1LxOOiXD8GfnwnMVCYDoxvFgWTnV8xLx4wsHlKe6rS2ekrO1xzb5JeWk3elp3NfFpaANkOK0D2QRsu9G9/NrjSFgOJe9P1Wn0EM6AaBc3u3rUN8pEP3bpM
 wTfixgnT
 essAmiWjK3GBDZ/PU8g/tn3+oMzPa0panyjJmCErrzPOoBpYu7sUdEM47bvm6PoORcn6TDEZijhoodS1CFI0ncAvb5GrcFySXayxv/7GBFBxn/HBtnGXMDul92aAlMlPoUflvndKHoNcXK75mVtz87hFa9sALJm1mSB4i6LZkHBK8vl4/OjOQJB0WVoYgBQsO7ckGeBEBLcCXdWQcY1OO8Q693AVBGcR0eiv5W4mG29gK3A8xhz0Sm6D7Lp5J3KecvdC/ctz4Vw9OeDtw3LgakZZHU+lB2aIbaMxjdipilv5n/wohndj6Ov9UYZR/G14kmHHBrslMFyJY+fgzelrJsr9u+U/pviaZghJJrZqxhH6DGMqVVtXeS6UKDMOFjKfeqaI8GYKO6K5rUZ9BkB7T6yqna81i4yY+6CXk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The file backend calls ->read_iter() and ->write_iter() of the backing
file directly but never checks that they exist. Everything that isn't a
block device ends up in the file backend. So a namespace pointing to a
file without them calls a NULL pointer on its first I/O. Only
buffered_io=1 gets that far as the O_DIRECT open fails for such files.

Refuse them when the namespace is enabled the same way zloop does since
commit 0c10f8a1a7ae ("zloop: check that the zone backing file support
->{read,write}_iter").

Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 695963dd932ee..dfa8aa46188c8 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -47,6 +47,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 		return ret;
 	}
 
+	if (!ns->file->f_op->read_iter || !ns->file->f_op->write_iter) {
+		ret = -EINVAL;
+		goto err;
+	}
+
 	nvmet_file_ns_revalidate(ns);
 
 	/*

-- 
2.53.0


