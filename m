Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BEBC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858386B0096; Thu, 10 Sep 2026 03:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8086B6B009E; Thu, 10 Sep 2026 03:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7240A6B00A1; Thu, 10 Sep 2026 03:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53CE96B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:51:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94C7BC0443
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:51:00 +0000 (UTC)
X-FDA: 85197081480.09.4A727C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C2AED20003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:50:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=WC0ozvcu;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789026658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bo4Zc2Vjjp0eoQaA5SCGx0fk3myt9u8dxHPEF5jd53w=;
	b=DF/9ZBWajN91HaAgEliUxKSxXf/nxaTOctyM5kRbU10C67kGoVx+PjfrNQUgj3Q8HwHjCV
	dFkZ4P6oCDSv4zX8EiSpRENHg7g7LhlrFMYbWngltVw+Xpz/32Os32fe4D7hLgw+8fNFzQ
	zuPywxzTAV/Xe2l7+vKFhU5HBzPh09Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=WC0ozvcu;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789026658;
	b=VQ4EPQvk/RPV5ByRkSXMYY5IBHq0KXNZ71WhxpE95Xbx0cTlhE5Ovs//hIdNitdJBnimm3
	MhCYBm3VVLaNkTqlSmkVkWRcATNHg8JilneAPFmZxeQ75rCZ6J2tWHA2Nm/LjC0fOQLVxu
	4Pmu7z9jpiJgEAF+rxC1FswfSQHeCrg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 05FB7600C8;
	Thu, 10 Sep 2026 07:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDE81F000FF;
	Thu, 10 Sep 2026 07:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789026657;
	bh=bo4Zc2Vjjp0eoQaA5SCGx0fk3myt9u8dxHPEF5jd53w=;
	h=From:To:Cc:Cc:In-Reply-To:References:Subject:Date;
	b=WC0ozvcumClM2Zk72IpUYM3ax15/lEjWizeh5ueYU8QJVQpFYoF8upF8QiDNXxZdL
	 LPXTNV1dDBIvAiW5qxLP/z0ZbDj6F1hkELjHf6bMI0GSNNsCtHDvhWx2UEYv/q7wvJ
	 B5PDaMntpjp/SxArHyAM5I6sHxlk8oBKkXS7T5obb+rlZR8OM0O1uMj7pcpjWb7jrn
	 uS84sKPWB0nsiHqG7yLViksMDLestWT1IBn/Dus0NJoAsL0DwXnSaq3WeJP18N0xQa
	 pnf3wozyZeD8YJn2xXgv2ArJNSs8Y4wfmhrcHqHXfluyZxANoHfBMFDgMu6nW7jZlV
	 H7/EsrpdaXZEg==
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jeff Xu <jeffxu@google.com>, 
 =?utf-8?q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
 Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
References: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
Subject: Re: [PATCH v3 0/3] proc,security,selinux: let SELinux block
 FOLL_FORCE for /proc/self/mem
Message-Id: <20260910-wohnbau-bezwangen-wegziehen-7a32dcf237b1@brauner>
Date: Thu, 10 Sep 2026 09:48:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1738; i=brauner@kernel.org;
 h=from:subject:message-id; bh=KP/TVT990Jk6qSqTonW4zGEnqjZVXeEhG7kgWM7rpbU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQtSowq4HP7sexZeNLbJRtXzZ06ueXsvVkW0cmHdMWzH
 tk3bfg3o6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiRrsY/nDEvtj2yNPmyULZ
 HUuMevjq9vsWsBZybVM59aCX60vFVz1GhmVnVpful2MS3/Ao9j+3p+fSJUozH4nX6xUqpWtXr34
 Xww4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: n456u1mzyomkwaghfujakxt789ybcjci
X-Rspamd-Queue-Id: C2AED20003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789026658-329866
X-HE-Meta: U2FsdGVkX18DI3XyKV1833gX5s2JlrwFgN5W8DSqCbhLSqQ+0q/eUqQp7tQprHURr6rGoXp5M088Nc1Y/vn/0jKxKDS0M0meCTLibYCQ7EIuYY2aKn63prUc5T0PSByFD0NL8zJh/7OKMM20pLzYT+8LyI4uKxQ8Pcu8UVhQoAqHadapeCeztRGSyMs6iGpKC06I1Ure3IX0fkvWg1bkMszu3+n5WxwBpGIm/S6BzRDk7ap7Z/iJ37OjF4MkLuP5C9nscCdBj6SesE/qT/Ts84cPmgLXuHqtWlHxz1du28MPcYW7If5qaSD7GBB2F6vdZzXtBxTsStJtXUnkxag55/BG2Yd/MIKH756VNdebNFypzY+oMrVuk30SBJsBa66i0XSL2R9e5i7B/RUtfLWsYTH+WVJQOm6h20oR0TNANxQALHQGbYtBH8hUavdmcFVafBONnPBYkabtJ76FZw/kBthJyi3lu2wT3ditsoJ8chXjkQ3PRh2fQYj25+yIN1HJKGGh2OF/lH03G7f91BNhqSXYAZgiEuyvgiwXw2aURMAmoShzGG4BVUATtMXxYTOpOrJJX1TWtIfWuTkfjyDih6uZGxyAwIjJenMNAGswuyKY9JAtFyvoLDFqwPPpFk2OGvinMe+YtjR2RlpPiZ0IaJ1m8kT9bo9Y+iralXD+IgEqugSWcegjvHWqfJMP4YeHbcUfOOOxavp84OIipzLKx26z4DXl0nLOGglYxTn04MKXZ2iUY+PkHQKJD3jdqP1WbmZkJn24F/7D6VRuE4BsJTtOCZ9eh7vd2oQSOHGMdKLkn+FzYVCs6WlsuuFFBpY5aV2Z3eOei0WoVswWH7A65rI147drFqQ/5i3i8uC0a9T0cCPznST/V1EYX3R0EAczSMII36PbvLUd73QCIOZOC8qdAe/52veelYit9gnYI/ELjw2pwiLmcmR2zMIi9Ls8HGtVdURVG1kBW2bebbb
 MwZdnh8g
 WEamqF9VP60S1S5ZzNHkuDZE0NA9QN4dJChCieuYhCFAd1R7SkaxSpyweuebJZ2jElmEO9IJre3gbdzz33yJYLX80rdm/ueH6vAgAvo3euzOsowhRqNYg47C/uZKojTcAL982Sd48SN5jTyMVt/IyyvHzqjfC0FgLEVvRq0iMuvX0CxThGRFqdcC6ZrzcTsxixeWG/o9VeSsA2DX2bi2KHiCQt1pkXl/qlyuNoTroMwSA/9UWOowZGNzmpuh0QsXe/E4Qx+0kZBWSqw8yb0Pj0ci1YKqqHG3DiziPHSbJT3Z+gX1AQnJKbSSUy9yy63AzASCXQw4+LZbUQLLRvET8oKrlwap68Za5Q+4kWstp6mx2izDLtQVcKcJVa+qV1u4+o2+TBR3Mv5tcP/BKCbdqDv/cgMtcCU6I9tEmlu6+K5N3wHBH0csO3BfuDUrBn6aNjpFzsleu4lcqQG2MJAeKqOveGQbWnAHXW6W7OOEkimdlv7Q4jLGhCwmzF0ZPO4QWX1LSPbgBDoBuQDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 07 Sep 2026 23:00:15 +0200, Jann Horn wrote:
> proc,security,selinux: let SELinux block FOLL_FORCE for /proc/self/mem
> 
> The goal of this series is to let SELinux prevent the use of FOLL_FORCE
> when a process writes into /proc/self/mem and the system is configured
> with PROC_MEM_FORCE_ALWAYS (which used to be the default behavior, and
> is still used by current Android devices).
> 
> [...]

Let's move this on a shared branch that both the vfs tree and the lsm
tree pull. That's the standard way of handling dependencies between two
subsystems that want to route code that touches both of them. Branch is
stable.

---

Applied to the vfs-7.4.shared.lsm.foll_force branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.shared.lsm.foll_force branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.shared.lsm.foll_force

[1/3] proc: refactor /proc/$pid/mem to use struct as private_data
      https://git.kernel.org/vfs/vfs/c/d5662602d178
[2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
      https://git.kernel.org/vfs/vfs/c/9f90f96af73d
[3/3] selinux: require PROCESS__PTRACE for FOLL_FORCE introspection
      https://git.kernel.org/vfs/vfs/c/5dac8c291d9b


